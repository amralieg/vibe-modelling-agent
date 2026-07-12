-- Schema for Domain: fulfillment | Business:  | Version: v2_ecm
-- Generated on: 2026-07-12 13:53:22

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`fulfillment` COMMENT 'Manages order picking, packing, ship-from-store, BOPIS/ROPIS processing, dark store fulfillment, last-mile delivery execution, carrier selection, route optimization, and fulfillment KPI tracking. Owns the operational execution layer between order capture and customer delivery, including transportation planning and last-mile logistics.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` (
    `fulfillment_order_id` BIGINT COMMENT 'Unique identifier for the fulfillment order. Primary key for this entity.',
    `carrier_id` BIGINT COMMENT 'Reference to the third-party logistics provider or carrier assigned to deliver this fulfillment order.',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: fulfillment_order has carrier_id FK and denormalized carrier_service_level column, but no FK to carrier_service. Business reality: a fulfillment order is assigned a specific carrier service for shipme',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Fulfillment orders for regulated products (food, pharma, hazmat) must comply with specific programs (HACCP, FDA, DOT). Enables compliance tracking per order and supports audit trails for regulatory in',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Fulfillment operations incur labor, packaging, and shipping costs that must be allocated to cost centers for operational expense tracking, budget variance analysis, and P&L reporting by fulfillment ch',
    `fulfillment_node_id` BIGINT COMMENT 'Identifier of the inventory node (store, dark store, distribution center, or warehouse) assigned to fulfill this order.',
    `header_id` BIGINT COMMENT 'Reference to the originating customer order that spawned this fulfillment work order. Links back to the order domain.',
    `location_id` BIGINT COMMENT 'Reference to the retail store location when fulfillment method is ship-from-store, BOPIS, or ROPIS.',
    `outbound_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.outbound_order. Business justification: Store replenishment orders fulfilled from DC create both outbound_order (DC perspective) and fulfillment_order (execution). Links DC dispatch to fulfillment execution for ship-to-store scenarios, enab',
    `price_zone_id` BIGINT COMMENT 'Foreign key linking to pricing.price_zone. Business justification: Fulfillment orders execute in specific price zones for zone-based pricing, shipping cost allocation, and regional pricing compliance. Retail operations track which price zone applies to each fulfillme',
    `associate_id` BIGINT COMMENT 'Reference to the warehouse or store employee assigned to pick items for this fulfillment order. Used for productivity tracking.',
    `profile_id` BIGINT COMMENT 'Reference to the customer who placed the originating order. Required for customer communication and service.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Orders generate revenue attributed to specific profit centers (store, online channel, region) for segment reporting, profitability analysis, and management reporting required for retail financial stat',
    `address_id` BIGINT COMMENT 'Reference to the customer address where this fulfillment order will be delivered. Not applicable for BOPIS/ROPIS orders.',
    `sku_price_id` BIGINT COMMENT 'Foreign key linking to pricing.sku_price. Business justification: Fulfillment orders require actual selling price for shipment value declaration, insurance coverage calculation, customs documentation, and financial reconciliation. Links fulfillment execution to the',
    `actual_fulfillment_hours` DECIMAL(18,2) COMMENT 'The actual elapsed time in hours from fulfillment order creation to completion. Used for performance measurement against SLA.',
    `cancellation_reason` STRING COMMENT 'Free-text explanation of why this fulfillment order was cancelled, if applicable. Used for root cause analysis.',
    `completed_timestamp` TIMESTAMP COMMENT 'Timestamp when the fulfillment order reached final completion state (delivered or picked up by customer).',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this fulfillment order.. Valid values are `^[A-Z]{3}$`',
    `fulfillment_assigned_timestamp` TIMESTAMP COMMENT 'Timestamp when the fulfillment order was assigned to a specific fulfillment node and became actionable.',
    `fulfillment_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this fulfillment order record was created in the system. Marks the start of fulfillment processing.',
    `fulfillment_method` STRING COMMENT 'The operational fulfillment strategy used to complete this order. BOPIS = Buy Online Pick Up In Store, ROPIS = Reserve Online Pick Up In Store.. Valid values are `ship_from_store|dark_store|distribution_center|bopis|ropis|drop_ship`',
    `fulfillment_order_number` STRING COMMENT 'Human-readable business identifier for the fulfillment order, used for tracking and communication across systems and with partners.. Valid values are `^FO[0-9]{10}$`',
    `fulfillment_status` STRING COMMENT 'Current lifecycle state of the fulfillment order in the pick-pack-ship workflow. [ENUM-REF-CANDIDATE: created|assigned|picking|picked|packing|packed|shipped|ready_for_pickup|completed|cancelled — 10 candidates stripped; promote to reference product]',
    `gift_message` STRING COMMENT 'Customer-provided gift message to be included with the shipment, if this is a gift order.',
    `is_gift` BOOLEAN COMMENT 'Indicates whether this fulfillment order is a gift, requiring special packaging and excluding pricing information from packing slip.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this fulfillment order record. Used for change tracking and audit trails.',
    `order_date` TIMESTAMP COMMENT 'Timestamp when the customer placed the originating order. Used for SLA calculation and aging analysis.',
    `package_count` STRING COMMENT 'Number of physical packages or parcels created for this fulfillment order. Orders may be split across multiple packages.',
    `packing_completed_timestamp` TIMESTAMP COMMENT 'Timestamp when the fulfillment order was packed and ready for shipment or pickup.',
    `packing_slip_url` STRING COMMENT 'URL to the packing slip document that accompanies the shipment, listing order contents.',
    `picking_completed_timestamp` TIMESTAMP COMMENT 'Timestamp when all items in the fulfillment order were successfully picked from inventory.',
    `picking_started_timestamp` TIMESTAMP COMMENT 'Timestamp when the picking process began for this fulfillment order.',
    `pickup_location_code` STRING COMMENT 'Designated area or counter code within the store where BOPIS/ROPIS orders are staged for customer pickup.. Valid values are `^[A-Z0-9]{3,10}$`',
    `priority_level` STRING COMMENT 'Processing priority assigned to this fulfillment order based on customer tier, service level, or business rules.. Valid values are `standard|expedited|rush|vip`',
    `promised_delivery_date` DATE COMMENT 'The date communicated to the customer as the expected delivery or pickup availability date. Used for SLA tracking.',
    `shipped_timestamp` TIMESTAMP COMMENT 'Timestamp when the fulfillment order was handed off to the carrier for delivery.',
    `shipping_cost_amount` DECIMAL(18,2) COMMENT 'Actual cost incurred for carrier services to ship this fulfillment order. Used for profitability analysis and cost allocation.',
    `shipping_label_url` STRING COMMENT 'URL to the generated shipping label document for this fulfillment order, used by warehouse staff for package labeling.',
    `sla_target_hours` STRING COMMENT 'The number of hours from order creation to promised delivery, representing the committed service level for this fulfillment method.',
    `special_handling_instructions` STRING COMMENT 'Additional instructions for fulfillment staff regarding fragile items, gift wrapping, temperature control, or other special requirements.',
    `total_item_quantity` STRING COMMENT 'Total number of individual units across all line items in this fulfillment order. Used for capacity planning and picker productivity.',
    `total_line_count` STRING COMMENT 'Number of distinct SKU line items in this fulfillment order. Impacts picking complexity and time.',
    `total_volume_cubic_meters` DECIMAL(18,2) COMMENT 'Total volumetric size of the fulfillment order in cubic meters, used for transportation planning and dimensional weight pricing.',
    `total_weight_kg` DECIMAL(18,2) COMMENT 'Total weight of the fulfillment order in kilograms, used for carrier selection, shipping cost calculation, and capacity planning.',
    `tracking_number` STRING COMMENT 'The carrier-provided tracking identifier used by customers and operations to monitor shipment progress.. Valid values are `^[A-Z0-9]{10,40}$`',
    CONSTRAINT pk_fulfillment_order PRIMARY KEY(`fulfillment_order_id`)
) COMMENT 'Core operational record representing a fulfillment work order created from a customer order. Tracks the end-to-end execution of picking, packing, and shipping activities for a single order or order subset. Captures fulfillment method (ship-from-store, dark store, DC, BOPIS, ROPIS, drop-ship), assigned fulfillment node, SLA commitment, promised delivery date, current fulfillment status, and carrier assignment. This is the primary entity in the fulfillment domain and the operational counterpart to the order domains order record.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` (
    `fulfillment_line_id` BIGINT COMMENT 'Unique identifier for the fulfillment line item. Primary key for this entity.',
    `fulfillment_node_id` BIGINT COMMENT 'Identifier of the specific fulfillment location (DC number, store number, vendor ID, etc.). Links to the physical location that executed fulfillment.',
    `fulfillment_order_id` BIGINT COMMENT 'Reference to the parent fulfillment order header. Links this line to the overall fulfillment order.',
    `haccp_control_point_id` BIGINT COMMENT 'Foreign key linking to compliance.haccp_control_point. Business justification: Perishable/food SKUs must reference HACCP critical control points for temperature monitoring, lot traceability, and recall management. Required for FDA compliance and food safety audits in grocery ful',
    `handling_unit_id` BIGINT COMMENT 'Identifier of the shipping carton or container into which this line was packed. Links line items to physical shipment packages.',
    `order_line_id` BIGINT COMMENT 'Reference to the original sales order line that this fulfillment line is satisfying. Links fulfillment execution back to customer order.',
    `outbound_order_line_id` BIGINT COMMENT 'Foreign key linking to supplychain.outbound_order_line. Business justification: Line-level linkage for DC-to-store replenishment. Each fulfillment_line executing store replenishment corresponds to outbound_order_line in DC system. Critical for SKU-level reconciliation and invento',
    `associate_id` BIGINT COMMENT 'Identifier of the warehouse associate who picked this line. Used for productivity tracking and quality accountability.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Fulfillment lines must reference the product SKU being fulfilled. The product_name column becomes redundant as it can be joined from product.sku. This links fulfillment execution to the product catalo',
    `vendor_item_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_item. Business justification: Fulfillment costing and allocation decisions require vendor item master data for cost, pack configuration, and vendor-specific attributes. Real-world WMS systems query vendor_item during order fulfill',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this fulfillment line record was first created in the system. Audit trail for record creation.',
    `exception_code` STRING COMMENT 'Code identifying any exception or issue encountered during fulfillment of this line (stockout, damage, mispick, etc.). Null if no exception occurred.',
    `exception_description` STRING COMMENT 'Detailed description of the fulfillment exception or issue. Provides context for exception resolution and process improvement.',
    `expiry_date` DATE COMMENT 'Expiration date of the picked inventory. Critical for perishable goods, food safety, and FEFO (First Expired First Out) fulfillment strategies.',
    `extended_cost` DECIMAL(18,2) COMMENT 'Total cost for this line (unit cost × quantity shipped). Represents total COGS for the fulfilled quantity.',
    `fulfillment_source_type` STRING COMMENT 'Type of fulfillment location from which this line was fulfilled (distribution center, store, dark store, vendor direct, third-party logistics). Enables omnichannel fulfillment analysis.. Valid values are `dc|store|dark_store|vendor|3pl`',
    `gtin` STRING COMMENT 'Global Trade Item Number for the product. International standard product identifier used across supply chain and fulfillment systems.. Valid values are `^[0-9]{14}$`',
    `line_number` STRING COMMENT 'Sequential line number within the fulfillment order. Used for ordering and referencing specific line items.',
    `line_status` STRING COMMENT 'Current fulfillment status of this line item. Tracks progression through the fulfillment workflow from allocation to shipment. [ENUM-REF-CANDIDATE: pending|allocated|picked|packed|shipped|cancelled|exception — 7 candidates stripped; promote to reference product]',
    `lot_number` STRING COMMENT 'Manufacturing lot or batch number of the picked inventory. Critical for traceability, recalls, and expiry management.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this fulfillment line record was last updated. Audit trail for record changes.',
    `original_sku` STRING COMMENT 'The originally ordered SKU if this line is a substitution. Null if no substitution occurred. Enables tracking of substitution patterns and customer acceptance.',
    `pack_timestamp` TIMESTAMP COMMENT 'Date and time when this line was packed into a shipping container. Used for throughput analysis and bottleneck identification.',
    `pick_location` STRING COMMENT 'The warehouse location (aisle, bin, shelf) from which this item was picked. Used for inventory tracking and pick path optimization.',
    `pick_timestamp` TIMESTAMP COMMENT 'Date and time when this line was physically picked from inventory. Critical for cycle time analysis and SLA tracking.',
    `quantity_allocated` DECIMAL(18,2) COMMENT 'The quantity of inventory allocated or reserved for this fulfillment line. Represents inventory commitment before physical picking.',
    `quantity_cancelled` DECIMAL(18,2) COMMENT 'The quantity cancelled and not fulfilled for this line. Represents unfulfilled demand due to stockouts, customer cancellation, or other exceptions.',
    `quantity_ordered` DECIMAL(18,2) COMMENT 'The quantity of this item originally requested in the order. Represents the customer demand that fulfillment is attempting to satisfy.',
    `quantity_packed` DECIMAL(18,2) COMMENT 'The quantity successfully packed into shipping containers for this line. Represents items ready for shipment.',
    `quantity_picked` DECIMAL(18,2) COMMENT 'The actual quantity physically picked from inventory for this line. May differ from ordered quantity due to stockouts or picking errors.',
    `quantity_shipped` DECIMAL(18,2) COMMENT 'The quantity actually shipped to the customer for this line. Final fulfilled quantity that left the facility.',
    `serial_number` STRING COMMENT 'Unique serial number of the individual item picked, if serialized inventory. Enables item-level tracking for high-value or regulated products.',
    `ship_timestamp` TIMESTAMP COMMENT 'Date and time when this line was shipped from the facility. Marks completion of fulfillment execution and start of delivery.',
    `sku` STRING COMMENT 'Stock Keeping Unit identifier for the product being fulfilled. The internal product identifier used for inventory tracking and fulfillment operations.. Valid values are `^[A-Z0-9]{6,20}$`',
    `substitution_flag` BOOLEAN COMMENT 'Indicates whether this line represents a product substitution (true) or the originally ordered item (false). Used to track when alternative products are fulfilled.',
    `substitution_reason_code` STRING COMMENT 'Reason code explaining why a substitution was made. Used for root cause analysis and inventory planning.. Valid values are `out_of_stock|discontinued|damaged|customer_request|upgrade|downgrade`',
    `unit_cost` DECIMAL(18,2) COMMENT 'Cost of Goods Sold (COGS) per unit for this item. Used for inventory valuation and profitability analysis.',
    `unit_of_measure` STRING COMMENT 'The unit of measure for all quantities on this line (each, case, pallet, etc.). Defines how quantities are counted and tracked.. Valid values are `each|case|pallet|box|pack|unit`',
    `upc` STRING COMMENT 'Universal Product Code barcode identifier. Standard 12-digit product identifier used for scanning and product identification.. Valid values are `^[0-9]{12}$`',
    `weight` DECIMAL(18,2) COMMENT 'Total weight of the picked quantity for this line. Used for shipping cost calculation and carrier selection.',
    `weight_unit` STRING COMMENT 'Unit of measure for the weight field (pounds, kilograms, etc.). Standardizes weight reporting across fulfillment operations.. Valid values are `lb|kg|oz|g`',
    CONSTRAINT pk_fulfillment_line PRIMARY KEY(`fulfillment_line_id`)
) COMMENT 'Line-level detail of a fulfillment order, representing each SKU/UPC being fulfilled. Captures quantity requested, quantity picked, quantity packed, quantity shipped, unit of measure, pick location, substitution flag, and line-level fulfillment status. Enables granular tracking of partial fulfillments, substitutions, and out-of-stock exceptions at the item level.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`shipment` (
    `shipment_id` BIGINT COMMENT 'Primary key for shipment',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier. Business justification: shipment has denormalized carrier_code and carrier_name columns but no FK to carrier master. Adding carrier_id FK allows joining to carrier for full carrier details (contact info, capabilities, contra',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: shipment has denormalized service_level column but no FK to carrier_service (in addition to the carrier_id FK proposed above). Business reality: a shipment is dispatched using a specific carrier servi',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Shipping costs (carrier charges, packaging materials, labor) are operational expenses allocated to cost centers for budget tracking, variance analysis, and fulfillment cost-per-order KPI reporting use',
    `environmental_event_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_event. Business justification: Hazmat shipments involved in spills, leaks, or disposal incidents must link to environmental event records for EPA/DOT reporting, manifest tracking, and remediation documentation. Regulatory requireme',
    `fulfillment_node_id` BIGINT COMMENT 'Reference to the fulfillment node (distribution center, store, dark store, or micro-fulfillment center) from which the shipment originated.',
    `fulfillment_order_id` BIGINT COMMENT 'Foreign key linking to fulfillment.fulfillment_order. Business justification: shipment is the physical dispatch output of a fulfillment_order (the operational work order). Currently shipment only links to order_header, missing the operational lineage. Adding fulfillment_order_i',
    `header_id` BIGINT COMMENT 'Reference to the parent order that this shipment fulfills. Links shipment to the originating customer order.',
    `outbound_shipment_id` BIGINT COMMENT 'Foreign key linking to supplychain.outbound_shipment. Business justification: Same physical shipment tracked in both domains. Fulfillment.shipment is customer-facing view; outbound_shipment is DC logistics view. Essential for unified shipment visibility, freight reconciliation',
    `profile_id` BIGINT COMMENT 'Reference to the customer receiving the shipment. Primary party reference for the transaction.',
    `actual_delivery_date` DATE COMMENT 'Actual date when the shipment was successfully delivered to the recipient. Used for on-time delivery performance measurement.',
    `carrier_charge_amount` DECIMAL(18,2) COMMENT 'Actual cost charged by the carrier for transporting this shipment. Used for freight cost accounting and margin analysis.',
    `carrier_charge_currency_code` STRING COMMENT 'Three-letter ISO currency code for the carrier charge amount (e.g., USD, CAD, EUR).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the shipment record was first created in the system. Audit field for record lifecycle tracking.',
    `declared_value_amount` DECIMAL(18,2) COMMENT 'Declared monetary value of the shipment contents for insurance and customs purposes. Used to determine carrier liability limits.',
    `declared_value_currency_code` STRING COMMENT 'Three-letter ISO currency code for the declared value amount (e.g., USD, CAD, EUR).. Valid values are `^[A-Z]{3}$`',
    `delivery_instructions` STRING COMMENT 'Special instructions provided by the customer for delivery handling (e.g., leave at door, ring bell, gate code). Passed to carrier for execution.',
    `delivery_signature_required_flag` BOOLEAN COMMENT 'Indicates whether a recipient signature is required upon delivery for proof of receipt. True if signature required, false otherwise.',
    `estimated_delivery_date` DATE COMMENT 'Carrier-provided or system-calculated expected delivery date communicated to the customer. Used for Service Level Agreement (SLA) tracking.',
    `fulfillment_type` STRING COMMENT 'Classification of the fulfillment method used for this shipment. Distinguishes between standard shipping, Buy Online Pick Up In Store (BOPIS), Reserve Online Pick Up In Store (ROPIS), ship-from-store, drop-ship, and curbside pickup.. Valid values are `standard|bopis|ropis|ship_from_store|drop_ship|curbside`',
    `hazmat_flag` BOOLEAN COMMENT 'Indicates whether the shipment contains hazardous materials requiring special handling and documentation. True if hazmat, false otherwise.',
    `height_cm` DECIMAL(18,2) COMMENT 'Shortest dimension of the shipment in centimeters. Used for carrier rating and dimensional weight calculations.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the shipment record was most recently modified. Audit field for change tracking and data freshness monitoring.',
    `length_cm` DECIMAL(18,2) COMMENT 'Longest dimension of the shipment in centimeters. Used for carrier rating and dimensional weight calculations.',
    `package_count` STRING COMMENT 'Total number of physical packages or parcels included in this shipment. Supports multi-package shipment tracking.',
    `ship_date` DATE COMMENT 'Date when the shipment was physically dispatched from the fulfillment node. Key business event timestamp for fulfillment cycle time measurement.',
    `ship_from_location_type` STRING COMMENT 'Classification of the originating fulfillment location type. Supports omnichannel fulfillment analytics including ship-from-store (SFS) and dark store operations.. Valid values are `distribution_center|store|dark_store|micro_fulfillment_center|vendor`',
    `ship_to_address_line1` STRING COMMENT 'Primary street address line for the shipment destination. First line of the delivery address.',
    `ship_to_address_line2` STRING COMMENT 'Secondary address line for apartment, suite, unit, or building information at the delivery destination.',
    `ship_to_city` STRING COMMENT 'City or municipality name for the shipment delivery destination.',
    `ship_to_contact_name` STRING COMMENT 'Name of the recipient or contact person at the delivery destination. Used for delivery confirmation and communication.',
    `ship_to_country_code` STRING COMMENT 'Three-letter ISO country code for the shipment delivery destination (e.g., USA, CAN, MEX).. Valid values are `^[A-Z]{3}$`',
    `ship_to_email_address` STRING COMMENT 'Email address for shipment tracking notifications and delivery updates sent to the recipient.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `ship_to_phone_number` STRING COMMENT 'Contact phone number for the shipment recipient. Used by carriers for delivery coordination and customer notifications.',
    `ship_to_postal_code` STRING COMMENT 'Postal or ZIP code for the shipment delivery destination. Used for carrier routing and delivery zone determination.',
    `ship_to_state_province` STRING COMMENT 'State, province, or region code for the shipment delivery destination.',
    `shipment_number` STRING COMMENT 'Externally visible unique shipment identifier used for customer tracking and carrier communication. Business identifier for the shipment.. Valid values are `^SHP[0-9]{10}$`',
    `shipment_status` STRING COMMENT 'Current lifecycle status of the shipment in the fulfillment workflow. Tracks progression from creation through final delivery or return. [ENUM-REF-CANDIDATE: created|picked|packed|manifested|in_transit|out_for_delivery|delivered|failed_delivery|returned|cancelled — 10 candidates stripped; promote to reference product]',
    `shipping_cost_amount` DECIMAL(18,2) COMMENT 'Total cost charged to the customer for shipping this shipment. Includes base shipping rate and any surcharges.',
    `shipping_cost_currency_code` STRING COMMENT 'Three-letter ISO currency code for the shipping cost amount (e.g., USD, CAD, EUR).. Valid values are `^[A-Z]{3}$`',
    `signature_name` STRING COMMENT 'Name of the person who signed for the shipment upon delivery. Captured for proof of delivery and dispute resolution.',
    `total_volume_cubic_meters` DECIMAL(18,2) COMMENT 'Total volumetric measurement of the shipment in cubic meters. Used for dimensional weight pricing and transportation planning.',
    `total_weight_kg` DECIMAL(18,2) COMMENT 'Total weight of the shipment in kilograms, including all packages and packaging materials. Used for carrier billing and capacity planning.',
    `tracking_number` STRING COMMENT 'Carrier-assigned unique tracking identifier used for shipment visibility and proof of delivery. Enables customer and internal tracking through carrier systems.',
    `width_cm` DECIMAL(18,2) COMMENT 'Middle dimension of the shipment in centimeters. Used for carrier rating and dimensional weight calculations.',
    CONSTRAINT pk_shipment PRIMARY KEY(`shipment_id`)
) COMMENT 'Master record for a physical shipment dispatched to a customer or transfer destination. Captures carrier, tracking number, ship date, estimated delivery date, actual delivery date, shipment weight, dimensions, number of packages, ship-from node, ship-to address, service level (ground, 2-day, overnight), and shipment status. Serves as the SSOT for all outbound shipment tracking across channels including e-commerce, BOPIS, and store-to-door.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` (
    `shipment_package_id` BIGINT COMMENT 'Unique identifier for the shipment package. Primary key.',
    `carrier_id` BIGINT COMMENT 'Reference to the carrier (third-party logistics provider) responsible for transporting this package.',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: shipment_package has carrier_id FK and denormalized carrier_service_level column, but no FK to carrier_service. Business reality: each package is shipped using a specific carrier service offering. Add',
    `fulfillment_node_id` BIGINT COMMENT 'Reference to the fulfillment location (distribution center, store, dark store, or micro-fulfillment center) where this package was prepared.',
    `header_id` BIGINT COMMENT 'Reference to the customer order being fulfilled by this package.',
    `outbound_shipment_id` BIGINT COMMENT 'Foreign key linking to supplychain.outbound_shipment. Business justification: Packages in customer shipments may originate from DC outbound operations (cross-dock, ship-from-store with DC consolidation). Links package-level fulfillment tracking to upstream DC dispatch for multi',
    `shipment_id` BIGINT COMMENT 'Reference to the parent shipment that contains this package. A single shipment may contain multiple packages.',
    `actual_delivery_timestamp` TIMESTAMP COMMENT 'Date and time when the package was actually delivered to the customer, confirming successful fulfillment.',
    `billable_weight_kg` DECIMAL(18,2) COMMENT 'The greater of actual weight or dimensional weight, used as the basis for carrier shipping charges.',
    `contents_summary` STRING COMMENT 'High-level description of package contents, often used for customs declarations or customer communication (e.g., Apparel and Electronics).',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this package record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this record.. Valid values are `^[A-Z]{3}$`',
    `delivery_confirmation_method` STRING COMMENT 'Method used to confirm successful delivery of the package (e.g., signature, photo proof, GPS coordinates, contactless delivery). [ENUM-REF-CANDIDATE: signature|photo|gps|contactless|left_at_door|handed_to_resident|locker — 7 candidates stripped; promote to reference product]',
    `delivery_notes` STRING COMMENT 'Free-text notes from the carrier or driver regarding delivery (e.g., Left at front door, Delivered to neighbor).',
    `dimensional_weight_kg` DECIMAL(18,2) COMMENT 'Calculated dimensional weight based on package volume, used by carriers for rating when dimensional weight exceeds actual weight.',
    `estimated_delivery_date` DATE COMMENT 'Carrier-provided estimated date when the package will be delivered to the customer.',
    `height_cm` DECIMAL(18,2) COMMENT 'Height dimension of the package in centimeters, used for carrier rating and capacity planning.',
    `insurance_value_amount` DECIMAL(18,2) COMMENT 'Declared value of the package contents for insurance purposes.',
    `is_hazmat` BOOLEAN COMMENT 'Indicates whether the package contains hazardous materials requiring special handling and labeling per regulatory requirements.',
    `is_insured` BOOLEAN COMMENT 'Indicates whether the package has been insured for loss or damage during transit.',
    `is_label_printed` BOOLEAN COMMENT 'Indicates whether the shipping label has been printed for this package.',
    `is_manifested` BOOLEAN COMMENT 'Indicates whether the package has been included in a carrier manifest and is ready for pickup.',
    `is_sealed` BOOLEAN COMMENT 'Indicates whether the package has been sealed and is ready for shipment.',
    `is_signature_required` BOOLEAN COMMENT 'Indicates whether a signature is required upon delivery for this package.',
    `item_count` STRING COMMENT 'Total number of individual items (SKUs) contained in this package.',
    `labeled_timestamp` TIMESTAMP COMMENT 'Date and time when the shipping label was printed and affixed to the package.',
    `length_cm` DECIMAL(18,2) COMMENT 'Length dimension of the package in centimeters, used for carrier rating and capacity planning.',
    `manifested_timestamp` TIMESTAMP COMMENT 'Date and time when the package was included in the carrier manifest, indicating readiness for carrier pickup.',
    `package_number` STRING COMMENT 'Human-readable business identifier for the package, often printed on the label. May follow internal numbering conventions.',
    `package_sequence` STRING COMMENT 'Sequential position of this package within the parent shipment (e.g., package 1 of 3).',
    `package_status` STRING COMMENT 'Current lifecycle status of the package in the fulfillment and delivery process. [ENUM-REF-CANDIDATE: created|packed|sealed|labeled|manifested|picked_up|in_transit|out_for_delivery|delivered|exception|returned — 11 candidates stripped; promote to reference product]',
    `package_type` STRING COMMENT 'Type of packaging container used for this package.. Valid values are `box|poly_bag|envelope|pallet|crate|tube`',
    `packed_timestamp` TIMESTAMP COMMENT 'Date and time when the package was packed and sealed, marking readiness for shipment.',
    `picked_up_timestamp` TIMESTAMP COMMENT 'Date and time when the carrier physically picked up the package from the fulfillment location.',
    `shipping_cost_amount` DECIMAL(18,2) COMMENT 'Actual shipping cost charged by the carrier for this package.',
    `shipping_method` STRING COMMENT 'Fulfillment method used for this package (e.g., Ship-from-Store (SFS), Distribution Center (DC) fulfillment, Buy Online Pick Up In Store (BOPIS), Reserve Online Pick Up In Store (ROPIS), drop ship). [ENUM-REF-CANDIDATE: ship_from_store|dc_fulfillment|drop_ship|bopis|ropis|curbside|locker — 7 candidates stripped; promote to reference product]',
    `total_packages_in_shipment` STRING COMMENT 'Total number of packages in the parent shipment, providing context for the package sequence.',
    `tracking_number` STRING COMMENT 'Carrier-assigned tracking barcode or number used for end-to-end package visibility and customer tracking.',
    `unit_count` STRING COMMENT 'Total quantity of units across all items in the package (sum of quantities for all SKUs).',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this package record was last modified.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Actual weight of the package in kilograms, including contents and packaging materials. Used for carrier rating and shipping cost calculation.',
    `width_cm` DECIMAL(18,2) COMMENT 'Width dimension of the package in centimeters, used for carrier rating and capacity planning.',
    CONSTRAINT pk_shipment_package PRIMARY KEY(`shipment_package_id`)
) COMMENT 'Represents an individual physical package or carton within a shipment. Tracks package dimensions, weight, package type (box, poly bag, envelope), seal status, label printed flag, tracking barcode, contents summary, and package-level delivery confirmation. A single shipment may contain multiple packages, each with its own tracking and delivery status.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` (
    `pick_task_id` BIGINT COMMENT 'Primary key for pick_task',
    `associate_id` BIGINT COMMENT 'Reference to the warehouse associate assigned to execute this task. Used for productivity tracking and workload balancing.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier. Business justification: pick_task has denormalized carrier_code and service_level columns but no FKs to carrier or carrier_service. Business reality: pick tasks are prioritized and routed based on carrier and service level (',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: Following from pick_task carrier_id FK above, pick_task also needs carrier_service_id FK to normalize service_level. Business reality: pick task prioritization and routing depend on service level (ove',
    `fulfillment_node_id` BIGINT COMMENT 'Reference to the fulfillment center, store, or dark store where the task is executed. Supports omnichannel fulfillment including ship-from-store and BOPIS.',
    `header_id` BIGINT COMMENT 'Reference to the parent order that generated this pick task. Links the task to the customer order being fulfilled.',
    `outbound_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.outbound_order. Business justification: DC pick tasks fulfill outbound orders (store replenishment). Direct link enables task-to-order traceability for DC operations, supports labor planning tied to outbound order volume, and facilitates pi',
    `wave_id` BIGINT COMMENT 'Reference to the wave batch that this task belongs to. Wave-based picking groups tasks for efficient fulfillment execution.',
    `aisle` STRING COMMENT 'Aisle location within the warehouse where the item is stored. Part of the physical location hierarchy for item retrieval.. Valid values are `^[A-Z0-9]{1,10}$`',
    `assigned_timestamp` TIMESTAMP COMMENT 'Date and time when the task was assigned to the warehouse associate. Marks the start of the task lifecycle.',
    `bay` STRING COMMENT 'Bay location within the aisle where the item is stored. Provides granular location detail for picking accuracy.. Valid values are `^[A-Z0-9]{1,10}$`',
    `completion_timestamp` TIMESTAMP COMMENT 'Date and time when the task was completed by the associate. Used for throughput analysis and SLA tracking.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the pick task record was created in the system. Audit field for data lineage and task generation tracking.',
    `customer_approval_status` STRING COMMENT 'Customer approval status for the substitution. Tracks whether customer accepted the replacement item for BOPIS and delivery orders.. Valid values are `approved|rejected|pending|not_required`',
    `exception_code` STRING COMMENT 'Code identifying the type of exception encountered during task execution. Used for root cause analysis and process improvement.. Valid values are `^[A-Z0-9]{2,10}$`',
    `exception_reason` STRING COMMENT 'Detailed description of the exception or issue encountered during task execution. Provides context for exception resolution.',
    `fulfillment_channel` STRING COMMENT 'Channel through which the order is being fulfilled. Supports omnichannel fulfillment strategy including store-based and centralized fulfillment.. Valid values are `ship_from_store|dark_store|distribution_center|bopis|ropis|curbside`',
    `label_applied` BOOLEAN COMMENT 'Indicates whether the shipping label was successfully applied to the package. Critical checkpoint for shipment readiness.',
    `original_sku` STRING COMMENT 'Original SKU requested before substitution. Captured when substitution_occurred is true for order accuracy tracking.. Valid values are `^[A-Z0-9-]{6,20}$`',
    `package_type` STRING COMMENT 'Type of packaging used for the shipment. Determines shipping method, carrier selection, and dimensional weight calculation.. Valid values are `box|envelope|poly_bag|tube|pallet|tote`',
    `packing_slip_printed` BOOLEAN COMMENT 'Indicates whether the packing slip was printed and included in the package. Required for customer order verification.',
    `packing_station_code` STRING COMMENT 'Identifier for the packing station where the item is packed. Used for pack tasks and station utilization tracking.. Valid values are `^[A-Z0-9]{1,15}$`',
    `pick_task_status` STRING COMMENT 'Current lifecycle state of the pick task. Tracks progression from assignment through completion or exception handling. [ENUM-REF-CANDIDATE: pending|assigned|in_progress|completed|exception|cancelled|on_hold — 7 candidates stripped; promote to reference product]',
    `priority_level` STRING COMMENT 'Numeric priority ranking for task execution sequence. Lower numbers indicate higher priority. Used for queue management and SLA adherence.',
    `quality_check_outcome` STRING COMMENT 'Result of the quality check performed on the picked items. Ensures accuracy and condition standards before shipment.. Valid values are `passed|failed|not_required|pending`',
    `quantity_picked` DECIMAL(18,2) COMMENT 'Actual quantity of the item picked by the associate. May differ from requested quantity due to inventory discrepancies or short picks.',
    `quantity_requested` DECIMAL(18,2) COMMENT 'Original quantity of the item requested for picking. Represents the target quantity from the order or wave plan.',
    `shelf` STRING COMMENT 'Shelf level within the bay where the item is stored. Completes the physical location coordinates for item retrieval.. Valid values are `^[A-Z0-9]{1,10}$`',
    `sku` STRING COMMENT 'Stock Keeping Unit identifier for the product being picked. Unique identifier for inventory tracking and product identification.. Valid values are `^[A-Z0-9-]{6,20}$`',
    `start_timestamp` TIMESTAMP COMMENT 'Date and time when the associate began executing the task. Used to calculate task duration and associate productivity.',
    `substituted_sku` STRING COMMENT 'Replacement SKU provided when original item was unavailable. Used for substitution analysis and customer communication.. Valid values are `^[A-Z0-9-]{6,20}$`',
    `substitution_occurred` BOOLEAN COMMENT 'Indicates whether a product substitution was made during picking. Common in grocery and BOPIS fulfillment when original item is unavailable.',
    `task_duration_seconds` STRING COMMENT 'Total time in seconds from task start to completion. Used for associate productivity analysis and labor standards calibration.',
    `task_method` STRING COMMENT 'Picking methodology used for task execution. Defines how items are grouped and picked for optimal efficiency.. Valid values are `single_order|batch|zone|wave|cluster`',
    `task_number` STRING COMMENT 'Human-readable business identifier for the pick task. Used by warehouse associates to reference and track tasks.. Valid values are `^[A-Z0-9]{8,20}$`',
    `task_type` STRING COMMENT 'Classification of the fulfillment task activity. Determines the workflow and execution requirements for the task.. Valid values are `pick|pack|quality_check|value_added_service|replenishment|cycle_count`',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the quantity being picked. Defines whether picking is by individual units, cases, or other packaging levels.. Valid values are `each|case|pallet|box|pack`',
    `upc` STRING COMMENT 'Universal Product Code barcode for the item. Used for scanning and verification during pick execution.. Valid values are `^[0-9]{12}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when the pick task record was last modified. Audit field for change tracking and data quality monitoring.',
    `void_fill_used` BOOLEAN COMMENT 'Indicates whether void fill material was used in the package. Tracks packaging material usage for cost and sustainability reporting.',
    `work_zone` STRING COMMENT 'Designated zone within the fulfillment location where the task is performed. Used for zone-based picking and associate assignment.. Valid values are `^[A-Z0-9]{1,10}$`',
    CONSTRAINT pk_pick_task PRIMARY KEY(`pick_task_id`)
) COMMENT 'Unified operational task record for all fulfillment execution activities including picking, packing, quality checks, and value-added services. Captures task type (pick, pack, QC, VAS), assigned associate, work zone, location (aisle, bay, shelf, packing station), SKU/items, quantity requested vs actual, task method (single, batch, zone, wave), priority, status (assigned, in-progress, completed, exception), start time, completion time, quality check outcome, packing details (station ID, package type, void fill, label applied, packing slip printed), and substitution outcome (original SKU, substituted SKU, customer approval status). Supports wave-based task generation from WMS systems including Manhattan Associates and Blue Yonder. Enables associate productivity tracking, task queue management, and fulfillment throughput analytics across the entire pick-pack-QC workflow.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` (
    `pack_task_id` BIGINT COMMENT 'Unique identifier for the packing task record. Primary key for the pack task entity.',
    `associate_id` BIGINT COMMENT 'Identifier of the warehouse associate assigned to perform the packing operation. Used for productivity tracking and quality accountability.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier. Business justification: pack_task has denormalized carrier_code and service_level columns but no FKs to carrier or carrier_service. Business reality: a pack task prepares a package for a specific carrier. Adding carrier_id F',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: Following from pack_task carrier_id FK above, pack_task also needs carrier_service_id FK to normalize service_level. Business reality: packing requirements vary by service level (overnight requires sp',
    `fulfillment_node_id` BIGINT COMMENT 'Reference to the fulfillment location (distribution center, dark store, or ship-from-store location) where packing occurred.',
    `header_id` BIGINT COMMENT 'Reference to the customer order being fulfilled by this pack task. Enables traceability from packing back to the original order.',
    `outbound_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.outbound_order. Business justification: DC pack tasks package outbound orders for store replenishment. Links packing execution to supply chain order, supports packing productivity analysis by order type, and enables outbound order status up',
    `pick_task_id` BIGINT COMMENT 'Reference to the upstream pick task that provided the items for this packing operation. Links the packing workflow to the picking workflow.',
    `shipment_id` BIGINT COMMENT 'Reference to the shipment record that this packed package will be included in for carrier handoff and delivery.',
    `assigned_timestamp` TIMESTAMP COMMENT 'Timestamp when the pack task was assigned to the packer. Used to measure queue time and task aging.',
    `completed_timestamp` TIMESTAMP COMMENT 'Timestamp when the pack task reached completed status and the package was ready for carrier handoff. Used for SLA tracking and throughput measurement.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the pack task record was first created in the system. Used for audit trail and data lineage.',
    `exception_code` STRING COMMENT 'Code identifying the type of exception encountered during packing. Used for root cause analysis and process improvement. [ENUM-REF-CANDIDATE: short_pick|damaged_item|wrong_item|missing_label|scale_mismatch|oversized|none — 7 candidates stripped; promote to reference product]',
    `exception_notes` STRING COMMENT 'Free-text notes describing the exception or special handling required. Provides context for exception resolution and audit trail.',
    `fulfillment_type` STRING COMMENT 'Type of fulfillment method for this pack task. Determines packing requirements, labeling, and handoff process. BOPIS (Buy Online Pick Up In Store), ROPIS (Reserve Online Pick Up In Store), SFS (Ship From Store).. Valid values are `standard_ship|bopis|ropis|sfs|dark_store|same_day`',
    `gift_message_included_flag` BOOLEAN COMMENT 'Indicates whether a personalized gift message was printed and included in the package per customer request.',
    `gift_wrap_flag` BOOLEAN COMMENT 'Indicates whether gift wrapping service was requested and applied to this package. Impacts packing time and material cost.',
    `hazmat_flag` BOOLEAN COMMENT 'Indicates whether the package contains hazardous materials requiring special handling, labeling, and carrier compliance documentation.',
    `insurance_value_amount` DECIMAL(18,2) COMMENT 'Declared value of the package contents for insurance purposes. Used to determine insurance premium and claim limits.',
    `items_packed_count` STRING COMMENT 'Total number of individual items (SKUs) packed into the package for this task. Used for productivity measurement and quality verification.',
    `pack_duration_seconds` STRING COMMENT 'Total time in seconds spent on the packing operation from start to completion. Key metric for labor standards and productivity analysis.',
    `pack_end_timestamp` TIMESTAMP COMMENT 'Timestamp when the packing operation was completed and the package was sealed. Used to calculate pack cycle time and throughput.',
    `pack_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the packer began the packing operation. Used to calculate pack cycle time and labor productivity.',
    `package_height_cm` DECIMAL(18,2) COMMENT 'Height dimension of the package in centimeters. Used for dimensional weight calculation and carrier compliance.',
    `package_length_cm` DECIMAL(18,2) COMMENT 'Length dimension of the package in centimeters. Used for dimensional weight calculation and carrier compliance.',
    `package_size` STRING COMMENT 'Standardized size designation of the package selected. Used for dimensional weight calculation and carrier rate determination. [ENUM-REF-CANDIDATE: XS|S|M|L|XL|XXL|custom — 7 candidates stripped; promote to reference product]',
    `package_type` STRING COMMENT 'Type of packaging material selected by the packer for this task. Influences shipping cost, protection level, and carrier handling.. Valid values are `box|poly_mailer|padded_envelope|tube|pallet|tote`',
    `package_weight_kg` DECIMAL(18,2) COMMENT 'Actual weight of the sealed package in kilograms, measured at the packing station. Used for carrier rate calculation and compliance verification.',
    `package_width_cm` DECIMAL(18,2) COMMENT 'Width dimension of the package in centimeters. Used for dimensional weight calculation and carrier compliance.',
    `packing_slip_printed_flag` BOOLEAN COMMENT 'Indicates whether the packing slip document was successfully printed and included in the package. Required for customer order verification.',
    `packing_station_code` STRING COMMENT 'Identifier of the physical packing station where the task was performed. Used for workload balancing and station performance analysis.. Valid values are `^PS-[A-Z0-9]{3,10}$`',
    `quality_check_performed_by` BIGINT COMMENT 'Identifier of the associate who performed the quality inspection. Used for accountability and training needs identification.',
    `quality_check_status` STRING COMMENT 'Result of the quality inspection performed on the packed package. Failed status triggers rework or escalation.. Valid values are `passed|failed|pending|not_required|exception`',
    `shipping_label_applied_flag` BOOLEAN COMMENT 'Indicates whether the carrier shipping label was successfully printed and affixed to the package. Required for carrier acceptance.',
    `signature_required_flag` BOOLEAN COMMENT 'Indicates whether the shipment requires recipient signature upon delivery. Impacts carrier service selection and cost.',
    `task_number` STRING COMMENT 'Human-readable business identifier for the pack task. Used for operational tracking, troubleshooting, and communication between warehouse staff.. Valid values are `^PKT-[0-9]{8,12}$`',
    `task_priority` STRING COMMENT 'Priority level assigned to the pack task based on order SLA, shipping cutoff time, or customer tier. Determines task sequencing at the packing station.. Valid values are `urgent|high|normal|low`',
    `task_status` STRING COMMENT 'Current lifecycle state of the packing task. Tracks progression from assignment through completion or exception handling.. Valid values are `assigned|in_progress|completed|quality_hold|exception|cancelled`',
    `tracking_number` STRING COMMENT 'Unique tracking identifier assigned by the carrier for shipment visibility. Provided to customer for delivery status monitoring.. Valid values are `^[A-Z0-9]{10,35}$`',
    `units_packed_count` STRING COMMENT 'Total quantity of units packed across all items. Differs from items_packed_count when multiple units of the same SKU are included.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the pack task record was last modified. Used for audit trail and change tracking.',
    `void_fill_type` STRING COMMENT 'Type of void fill material used to protect items and prevent shifting during transit. Impacts packaging cost and sustainability metrics.. Valid values are `air_pillows|bubble_wrap|paper|foam_peanuts|none`',
    CONSTRAINT pk_pack_task PRIMARY KEY(`pack_task_id`)
) COMMENT 'Operational task record for the packing station workflow. Captures packer assignment, packing station ID, items packed, package type selected, void fill used, packing slip printed flag, label applied flag, pack start time, pack end time, and quality check status. Tracks the transition from picked items to sealed, labeled packages ready for carrier handoff.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` (
    `delivery_route_id` BIGINT COMMENT 'Unique identifier for the delivery route. Primary key.',
    `carrier_id` BIGINT COMMENT 'Identifier of the carrier or Third-Party Logistics (3PL) partner responsible for executing this route, if outsourced.',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: delivery_route has carrier_id FK and denormalized service_level column, but no FK to carrier_service. Business reality: a delivery route is planned for a specific service level (same-day, next-day, et',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Last-mile delivery routes incur driver labor, vehicle fuel, and maintenance costs that must be allocated to cost centers for operational budgeting, route profitability analysis, and last-mile delivery',
    `fulfillment_node_id` BIGINT COMMENT 'Identifier of the Distribution Center (DC), dark store, or Micro-Fulfillment Center (MFC) from which this route originates.',
    `outbound_shipment_id` BIGINT COMMENT 'Foreign key linking to supplychain.outbound_shipment. Business justification: Last-mile delivery routes consolidate shipments, some originating from DC outbound operations (store replenishment deliveries). Enables route optimization with DC shipment data and supports consolidat',
    `associate_id` BIGINT COMMENT 'Identifier of the driver or delivery associate assigned to execute this route.',
    `safety_inspection_id` BIGINT COMMENT 'Foreign key linking to compliance.safety_inspection. Business justification: Delivery routes and vehicles undergo DOT safety inspections (brake checks, load securement, driver hours). Links routes to inspection records for compliance tracking and fleet safety management in las',
    `actual_departure_time` TIMESTAMP COMMENT 'Actual timestamp when the driver departed from the fulfillment center or dark store to begin the route.',
    `actual_distance_km` DECIMAL(18,2) COMMENT 'Actual distance traveled on the route in kilometers, captured from vehicle telematics or GPS tracking.',
    `actual_duration_minutes` STRING COMMENT 'Actual total duration of the route in minutes, from departure to return.',
    `actual_return_time` TIMESTAMP COMMENT 'Actual timestamp when the driver returned to the fulfillment center after completing the route.',
    `cancellation_reason` STRING COMMENT 'Reason code or description explaining why this route was cancelled (e.g., weather, vehicle breakdown, driver unavailability).',
    `cancellation_timestamp` TIMESTAMP COMMENT 'Timestamp when this route was cancelled, if applicable.',
    `completed_stops` STRING COMMENT 'Number of delivery stops successfully completed on this route.',
    `completion_timestamp` TIMESTAMP COMMENT 'Timestamp when this route was marked as completed in the system.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this delivery route record was first created in the system.',
    `dispatch_timestamp` TIMESTAMP COMMENT 'Timestamp when this route was dispatched and assigned to the driver.',
    `estimated_duration_minutes` STRING COMMENT 'Estimated total duration of the route in minutes, including drive time and stop time, calculated by the route optimization algorithm.',
    `failed_stops` STRING COMMENT 'Number of delivery stops that failed or could not be completed on this route.',
    `hazmat_flag` BOOLEAN COMMENT 'Indicates whether this route includes hazardous materials requiring special handling and compliance with Department of Transportation (DOT) regulations.',
    `optimization_algorithm` STRING COMMENT 'Name or identifier of the route optimization algorithm or system used to plan this route (e.g., Blue Yonder, internal heuristic, third-party optimizer).',
    `optimization_version` STRING COMMENT 'Version or configuration identifier of the optimization algorithm used, for audit and performance tracking.',
    `planned_departure_time` TIMESTAMP COMMENT 'Scheduled timestamp when the driver is expected to depart from the fulfillment center or dark store to begin the route.',
    `planned_return_time` TIMESTAMP COMMENT 'Scheduled timestamp when the driver is expected to return to the fulfillment center after completing all deliveries.',
    `route_date` DATE COMMENT 'The scheduled date for this delivery route execution.',
    `route_name` STRING COMMENT 'Human-readable name or label for the route, often including geographic area or zone identifier.',
    `route_notes` STRING COMMENT 'Free-text notes or special instructions for the driver or dispatcher regarding this route (e.g., traffic alerts, access restrictions, customer preferences).',
    `route_number` STRING COMMENT 'Business identifier for the delivery route, externally visible to drivers and operations teams.. Valid values are `^[A-Z0-9]{6,20}$`',
    `route_priority` STRING COMMENT 'Priority level assigned to this route for resource allocation and dispatch sequencing.. Valid values are `high|medium|low`',
    `route_status` STRING COMMENT 'Current lifecycle status of the delivery route in the fulfillment workflow.. Valid values are `planned|assigned|in_progress|completed|partial|cancelled`',
    `route_type` STRING COMMENT 'Classification of the route based on fulfillment model: last-mile delivery, Ship-from-Store (SFS), Buy Online Pick Up In Store (BOPIS), Reserve Online Pick Up In Store (ROPIS), or dark store fulfillment.. Valid values are `last_mile|ship_from_store|bopis|ropis|dark_store`',
    `route_zone` STRING COMMENT 'Geographic zone or delivery area code covered by this route, used for territory management and planning.',
    `temperature_controlled_flag` BOOLEAN COMMENT 'Indicates whether this route requires temperature-controlled transport for perishable or temperature-sensitive goods.',
    `total_distance_km` DECIMAL(18,2) COMMENT 'Total planned distance of the route in kilometers, calculated by the route optimization algorithm.',
    `total_packages` STRING COMMENT 'Total number of packages or parcels loaded on this route for delivery.',
    `total_stops` STRING COMMENT 'Total number of delivery stop addresses planned on this route.',
    `total_volume_m3` DECIMAL(18,2) COMMENT 'Total volume of all packages on this route in cubic meters, used for vehicle capacity planning.',
    `total_weight_kg` DECIMAL(18,2) COMMENT 'Total weight of all packages on this route in kilograms, used for vehicle capacity planning.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this delivery route record was last modified.',
    `vehicle_code` BIGINT COMMENT 'Identifier of the delivery vehicle assigned to this route.',
    `vehicle_type` STRING COMMENT 'Type or class of vehicle used for this delivery route, impacting capacity and route planning.. Valid values are `van|truck|bike|scooter|car|cargo_bike`',
    CONSTRAINT pk_delivery_route PRIMARY KEY(`delivery_route_id`)
) COMMENT 'Planned last-mile delivery route for a driver or delivery vehicle covering multiple stop addresses. Captures route date, assigned driver, vehicle type, carrier or 3PL partner, planned stop sequence, total stops, total distance (miles/km), estimated route duration, route optimization algorithm used, route status (planned, in-progress, completed, partial), and departure/return times. Supports last-mile delivery execution and route optimization analytics.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` (
    `delivery_stop_id` BIGINT COMMENT 'Unique identifier for the delivery stop. Primary key for this entity.',
    `associate_id` BIGINT COMMENT 'Reference to the driver who executed the delivery at this stop.',
    `carrier_id` BIGINT COMMENT 'Reference to the carrier or third-party logistics provider responsible for this delivery stop.',
    `delivery_route_id` BIGINT COMMENT 'Reference to the parent delivery route that contains this stop.',
    `header_id` BIGINT COMMENT 'Reference to the customer order associated with this delivery stop.',
    `outbound_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.outbound_order. Business justification: Store delivery stops fulfill DC outbound orders (store replenishment). Links last-mile delivery execution to upstream supply chain order, enabling store receipt confirmation and DC-to-store delivery p',
    `profile_id` BIGINT COMMENT 'Reference to the customer receiving the delivery at this stop.',
    `shipment_id` BIGINT COMMENT 'Reference to the shipment being delivered at this stop.',
    `access_instructions` STRING COMMENT 'Special instructions for accessing the delivery location, such as gate codes, building entry procedures, or parking information.',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Actual date and time when the driver arrived at the delivery stop location.',
    `actual_departure_timestamp` TIMESTAMP COMMENT 'Actual date and time when the driver departed from the delivery stop location after completing the delivery attempt.',
    `actual_service_time_minutes` STRING COMMENT 'Actual duration in minutes spent at the delivery stop from arrival to departure.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this delivery stop record was first created in the system.',
    `delivery_address_line1` STRING COMMENT 'Primary street address line for the delivery location.',
    `delivery_address_line2` STRING COMMENT 'Secondary address line for apartment, suite, or unit number at the delivery location.',
    `delivery_city` STRING COMMENT 'City name for the delivery address.',
    `delivery_completion_timestamp` TIMESTAMP COMMENT 'Date and time when the delivery was successfully completed and proof of delivery was captured.',
    `delivery_country_code` STRING COMMENT 'Three-letter ISO country code for the delivery address.. Valid values are `^[A-Z]{3}$`',
    `delivery_latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the delivery address, used for route optimization and GPS navigation.',
    `delivery_location_type` STRING COMMENT 'Specific location at the delivery address where the package was left or handed off. [ENUM-REF-CANDIDATE: front_door|back_door|side_door|mailbox|parcel_locker|reception_desk|neighbor|garage|porch — 9 candidates stripped; promote to reference product]',
    `delivery_longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the delivery address, used for route optimization and GPS navigation.',
    `delivery_outcome` STRING COMMENT 'Final result of the delivery attempt at this stop, indicating whether the delivery was successful or the reason for failure. [ENUM-REF-CANDIDATE: delivered|attempted_no_answer|attempted_access_issue|refused|damaged|address_not_found|returned_to_sender — 7 candidates stripped; promote to reference product]',
    `delivery_postal_code` STRING COMMENT 'Postal or ZIP code for the delivery address, used for route optimization and zone assignment.',
    `delivery_state_province` STRING COMMENT 'State or province code for the delivery address.',
    `driver_notes` STRING COMMENT 'Free-text notes entered by the driver regarding the delivery attempt, including any issues encountered or special circumstances.',
    `estimated_service_time_minutes` STRING COMMENT 'Planned duration in minutes for completing the delivery at this stop, used for route planning and optimization.',
    `planned_arrival_window_end` TIMESTAMP COMMENT 'End of the scheduled time window when the driver is expected to arrive at this stop.',
    `planned_arrival_window_start` TIMESTAMP COMMENT 'Beginning of the scheduled time window when the driver is expected to arrive at this stop.',
    `pod_capture_method` STRING COMMENT 'Technology or device used to capture the proof of delivery evidence.. Valid values are `mobile_app|handheld_scanner|kiosk|web_portal|automated_system`',
    `pod_capture_timestamp` TIMESTAMP COMMENT 'Date and time when the proof of delivery evidence was captured by the driver or system.',
    `pod_gps_latitude` DECIMAL(18,2) COMMENT 'GPS latitude coordinate captured at the moment of delivery completion, used for delivery location verification.',
    `pod_gps_longitude` DECIMAL(18,2) COMMENT 'GPS longitude coordinate captured at the moment of delivery completion, used for delivery location verification.',
    `pod_photo_image_url` STRING COMMENT 'URL reference to the stored photograph of the delivered package at the delivery location.',
    `pod_pin_code` STRING COMMENT 'Personal identification number provided by the recipient to confirm delivery, used for contactless delivery verification.',
    `pod_signature_image_url` STRING COMMENT 'URL reference to the stored digital signature image captured as proof of delivery.',
    `pod_verification_status` STRING COMMENT 'Status indicating whether the proof of delivery evidence has been verified and accepted for compliance and dispute resolution purposes.. Valid values are `verified|pending_verification|verification_failed|disputed|not_required`',
    `recipient_name` STRING COMMENT 'Full name of the person receiving the delivery, may differ from the ordering customer.',
    `recipient_phone` STRING COMMENT 'Contact phone number for the recipient at the delivery location, used for delivery notifications and coordination.',
    `stop_sequence_number` STRING COMMENT 'Sequential position of this stop within the delivery route, used for route optimization and driver navigation.',
    `stop_status` STRING COMMENT 'Current lifecycle status of the delivery stop indicating progress through the last-mile delivery workflow. [ENUM-REF-CANDIDATE: scheduled|in_transit|arrived|delivered|attempted|failed|cancelled|returned_to_sender — 8 candidates stripped; promote to reference product]',
    `stop_type` STRING COMMENT 'Classification of the delivery stop type indicating the nature of the fulfillment activity.. Valid values are `customer_delivery|bopis_pickup|ropis_pickup|return_pickup|dark_store_transfer`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this delivery stop record was last modified in the system.',
    `vehicle_code` BIGINT COMMENT 'Reference to the delivery vehicle used for this stop.',
    CONSTRAINT pk_delivery_stop PRIMARY KEY(`delivery_stop_id`)
) COMMENT 'Individual stop on a delivery route representing a single customer delivery address, including integrated proof-of-delivery (POD) capture. Captures stop sequence number, customer address, shipment reference, planned arrival window, actual arrival time, delivery outcome (delivered, attempted, failed, returned-to-sender), recipient name, delivery location type (front door, mailbox, neighbor, locker), and driver notes. POD evidence includes signature image URL, delivery photo URL, PIN confirmation code, GPS coordinates at delivery, POD capture timestamp, POD capture method (mobile app, handheld scanner, kiosk), and POD verification status. Enables granular last-mile delivery tracking, customer notification triggers, dispute resolution through integrated POD evidence, and carrier compliance verification.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`carrier` (
    `carrier_id` BIGINT COMMENT 'Primary key for carrier',
    `certification_id` BIGINT COMMENT 'Foreign key linking to compliance.certification. Business justification: Carriers must maintain certifications (DOT authority, hazmat endorsement, food transport certification, C-TPAT) to be eligible for retail shipping contracts. Links carriers to certification records fo',
    `vendor_id` BIGINT COMMENT 'add column vendor_id (BIGINT) with FK to supplier.vendor.vendor_id - carriers are vendors with contracts and should link to the vendor master for unified supplier management',
    `api_integration_flag` BOOLEAN COMMENT 'Indicates whether the carrier provides API integration capabilities for real-time rate shopping, booking, and tracking.',
    `base_rate_per_lb` DECIMAL(18,2) COMMENT 'Negotiated base shipping rate per pound for standard service level, before surcharges and adjustments.',
    `bopis_ready_flag` BOOLEAN COMMENT 'Indicates whether the carrier supports BOPIS fulfillment logistics including store-to-customer handoff coordination.',
    `carrier_status` STRING COMMENT 'Current operational status of the carrier relationship indicating whether the carrier is available for shipment assignment.. Valid values are `active|inactive|suspended|pending_approval`',
    `carrier_type` STRING COMMENT 'Classification of the carrier based on service model: parcel (small package), LTL (Less Than Truckload), FTL (Full Truckload), last-mile delivery, same-day delivery, or third-party logistics (3PL) provider.. Valid values are `parcel|ltl|ftl|last_mile|same_day|3pl`',
    `carrier_code` STRING COMMENT 'Internal short code or abbreviation used to identify the carrier in operational systems.. Valid values are `^[A-Z0-9]{2,10}$`',
    `contact_email` STRING COMMENT 'Email address of the primary carrier contact for operational communication and escalations.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `contact_name` STRING COMMENT 'Name of the primary account representative or contact person at the carrier for operational coordination and issue resolution.',
    `contact_phone` STRING COMMENT 'Phone number of the primary carrier contact for urgent operational issues and coordination.',
    `contract_end_date` DATE COMMENT 'Date when the carrier service contract expires or is scheduled for renewal.',
    `contract_start_date` DATE COMMENT 'Date when the carrier service contract or agreement became effective.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the carrier master record was first created in the system.',
    `cutoff_time_local` STRING COMMENT 'Daily cutoff time in local warehouse time zone (HH:MM format) by which shipments must be tendered to the carrier to qualify for same-day pickup and service level commitment.. Valid values are `^([01]?[0-9]|2[0-3]):[0-5][0-9]$`',
    `dimensional_weight_factor` DECIMAL(18,2) COMMENT 'Divisor used to calculate dimensional weight from package dimensions (length x width x height / factor). Common values are 139 for domestic and 166 for international.',
    `edi_capable_flag` BOOLEAN COMMENT 'Indicates whether the carrier supports Electronic Data Interchange (EDI) for automated shipment booking, tracking, and invoicing.',
    `extended_area_surcharge` DECIMAL(18,2) COMMENT 'Additional fee charged for deliveries to remote or extended service areas beyond standard coverage zones.',
    `fuel_surcharge_percentage` DECIMAL(18,2) COMMENT 'Current fuel surcharge percentage applied to base shipping rates, typically adjusted monthly based on fuel price indices.',
    `geographic_coverage` STRING COMMENT 'Description of the geographic regions and countries where the carrier provides service coverage. May include restrictions or limitations.',
    `hazmat_certified_flag` BOOLEAN COMMENT 'Indicates whether the carrier is certified and authorized to transport hazardous materials under Department of Transportation (DOT) regulations.',
    `insurance_coverage_flag` BOOLEAN COMMENT 'Indicates whether the carrier offers shipment insurance or declared value coverage for high-value packages.',
    `max_height_inches` DECIMAL(18,2) COMMENT 'Maximum package height dimension in inches that the carrier will accept for shipment.',
    `max_length_inches` DECIMAL(18,2) COMMENT 'Maximum package length dimension in inches that the carrier will accept for shipment.',
    `max_weight_lbs` DECIMAL(18,2) COMMENT 'Maximum package weight in pounds that the carrier will accept for shipment under standard service terms.',
    `max_width_inches` DECIMAL(18,2) COMMENT 'Maximum package width dimension in inches that the carrier will accept for shipment.',
    `carrier_name` STRING COMMENT 'The legal business name of the carrier or third-party logistics (3PL) provider.',
    `negotiated_discount_percentage` DECIMAL(18,2) COMMENT 'Volume-based discount percentage negotiated off published carrier rates based on annual shipping commitment.',
    `rate_effective_date` DATE COMMENT 'Date when the current rate card and pricing terms became effective.',
    `rate_expiry_date` DATE COMMENT 'Date when the current rate card expires and requires renegotiation or renewal.',
    `residential_delivery_surcharge` DECIMAL(18,2) COMMENT 'Additional flat fee charged for deliveries to residential addresses versus commercial addresses.',
    `scac_code` STRING COMMENT 'Standard Carrier Alpha Code assigned by the National Motor Freight Traffic Association for freight carriers in North America.. Valid values are `^[A-Z]{2,4}$`',
    `service_level_ground` BOOLEAN COMMENT 'Indicates whether the carrier offers standard ground shipping service.',
    `service_level_overnight` BOOLEAN COMMENT 'Indicates whether the carrier offers overnight express shipping service.',
    `service_level_same_day` BOOLEAN COMMENT 'Indicates whether the carrier offers same-day delivery service for local or regional shipments.',
    `service_level_two_day` BOOLEAN COMMENT 'Indicates whether the carrier offers two-day expedited shipping service.',
    `signature_required_flag` BOOLEAN COMMENT 'Indicates whether the carrier requires recipient signature upon delivery as a standard service feature.',
    `tracking_capability_flag` BOOLEAN COMMENT 'Indicates whether the carrier provides real-time shipment tracking and visibility capabilities.',
    `transit_days_zone_1` STRING COMMENT 'Standard number of business days for ground shipment delivery to Zone 1 (typically local or adjacent regions).',
    `transit_days_zone_2` STRING COMMENT 'Standard number of business days for ground shipment delivery to Zone 2 (typically regional).',
    `transit_days_zone_3` STRING COMMENT 'Standard number of business days for ground shipment delivery to Zone 3 (typically extended regional).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the carrier master record was last modified or updated.',
    CONSTRAINT pk_carrier PRIMARY KEY(`carrier_id`)
) COMMENT 'Master record for carrier and 3PL partners used for outbound shipment execution, encompassing carrier identity, service catalog, and contracted rate cards. Captures carrier name, carrier code, carrier type (parcel, LTL, FTL, last-mile, same-day), SCAC code, EDI/API integration capabilities. Service catalog includes service levels (ground, 2-day, overnight, same-day, BOPIS-ready), transit days by zone, cutoff times, max weight/dimensions, surcharge types, tracking capability, signature required flag, and geographic restrictions. Rate card includes base rates by zone/weight/service, dimensional weight factor, fuel surcharges, residential delivery surcharges, extended area surcharges, negotiated discount percentages, rate effective and expiry dates, and weight breaks. Serves as the single source of truth for all carrier master data, service definitions, and freight cost references within the fulfillment domain. Used in carrier selection logic during fulfillment order routing and freight cost estimation.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` (
    `carrier_service_id` BIGINT COMMENT 'Unique identifier for the carrier service offering. Primary key.',
    `carrier_id` BIGINT COMMENT 'Reference to the carrier (logistics provider) offering this service. Links to the carrier master entity.',
    `base_rate` DECIMAL(18,2) COMMENT 'Base shipping rate for this carrier service in the default currency. Used as starting point for total shipping cost calculation before surcharges and discounts.',
    `bopis_eligible_flag` BOOLEAN COMMENT 'Indicates whether this carrier service is eligible for BOPIS (Buy Online Pick Up In Store) fulfillment scenarios. Used in omnichannel order routing.',
    `carbon_neutral_flag` BOOLEAN COMMENT 'Indicates whether this carrier service is certified as carbon-neutral or participates in carbon offset programs. Used in sustainability reporting and eco-conscious customer service selection.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this carrier service record was first created in the system. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the base rate (e.g., USD, EUR, GBP). Used in multi-currency pricing and cost normalization.. Valid values are `^[A-Z]{3}$`',
    `cutoff_time` TIMESTAMP COMMENT 'Daily cutoff time (HH:MM format, 24-hour) by which orders must be placed to qualify for same-day shipment with this service. Critical for order routing and fulfillment scheduling.',
    `cutoff_timezone` STRING COMMENT 'Timezone identifier for the cutoff time (e.g., EST, PST, CST, UTC). Ensures accurate cutoff enforcement across distributed fulfillment centers.. Valid values are `^[A-Z]{3,5}$`',
    `effective_end_date` DATE COMMENT 'Date after which this carrier service configuration is no longer active. Null indicates indefinite availability. Used in temporal service availability logic.',
    `effective_start_date` DATE COMMENT 'Date from which this carrier service configuration becomes active and available for order routing. Used in temporal service availability logic.',
    `geographic_restriction_type` STRING COMMENT 'Type of geographic restriction applied to this carrier service (e.g., domestic only, specific regions, postal code whitelist/blacklist). Used in carrier eligibility filtering.. Valid values are `none|domestic_only|regional|postal_code_list|country_list`',
    `hazmat_eligible_flag` BOOLEAN COMMENT 'Indicates whether this carrier service is certified to transport hazardous materials. Used in carrier selection for restricted product categories.',
    `holiday_delivery_flag` BOOLEAN COMMENT 'Indicates whether this carrier service supports delivery on recognized holidays. Used in delivery date estimation and peak season planning.',
    `insurance_included_flag` BOOLEAN COMMENT 'Indicates whether shipment insurance is automatically included with this carrier service. Affects cost calculations and risk management decisions.',
    `insurance_max_value` DECIMAL(18,2) COMMENT 'Maximum insured value (in base currency) covered by this carrier service. Orders exceeding this value may require additional insurance or alternative services.',
    `international_eligible_flag` BOOLEAN COMMENT 'Indicates whether this carrier service supports international cross-border shipments. Used in carrier selection for international orders.',
    `max_girth_cm` DECIMAL(18,2) COMMENT 'Maximum package girth (length + 2×width + 2×height) in centimeters. Some carriers enforce combined dimensional limits beyond individual dimension constraints.',
    `max_height_cm` DECIMAL(18,2) COMMENT 'Maximum package height dimension in centimeters accepted by this carrier service. Used in dimensional eligibility checks during carrier selection.',
    `max_length_cm` DECIMAL(18,2) COMMENT 'Maximum package length dimension in centimeters accepted by this carrier service. Used in dimensional eligibility checks during carrier selection.',
    `max_weight_kg` DECIMAL(18,2) COMMENT 'Maximum shipment weight in kilograms that this carrier service can handle. Used in carrier selection logic to filter eligible services based on order weight.',
    `max_width_cm` DECIMAL(18,2) COMMENT 'Maximum package width dimension in centimeters accepted by this carrier service. Used in dimensional eligibility checks during carrier selection.',
    `perishable_eligible_flag` BOOLEAN COMMENT 'Indicates whether this carrier service supports temperature-controlled or time-sensitive perishable goods (e.g., groceries, fresh food). Used in carrier selection for perishable SKUs.',
    `restricted_countries` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes where this carrier service is NOT available. Used in international order routing and carrier selection.',
    `restricted_postal_codes` STRING COMMENT 'Comma-separated list of postal codes or postal code prefixes where this carrier service is NOT available. Used in carrier eligibility filtering during order routing.',
    `saturday_delivery_flag` BOOLEAN COMMENT 'Indicates whether this carrier service supports Saturday delivery. Used in delivery date estimation and customer service selection.',
    `service_code` STRING COMMENT 'Unique alphanumeric code identifying the carrier service offering (e.g., GROUND, 2DAY, OVERNIGHT, SAMEDAY). Used in carrier selection logic and order routing.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `service_name` STRING COMMENT 'Human-readable name of the carrier service offering (e.g., Ground Shipping, Two-Day Express, Overnight Priority, Same-Day Delivery).',
    `service_status` STRING COMMENT 'Current operational status of the carrier service. Determines availability for order routing and fulfillment selection.. Valid values are `active|inactive|suspended|seasonal|deprecated`',
    `service_type` STRING COMMENT 'Classification of the carrier service by delivery speed and priority level. Used for service tier segmentation and customer selection.. Valid values are `ground|express|overnight|same_day|next_day|standard`',
    `ship_from_store_eligible_flag` BOOLEAN COMMENT 'Indicates whether this carrier service is eligible for SFS (Ship From Store) fulfillment scenarios. Used in omnichannel order routing and inventory optimization.',
    `signature_required_flag` BOOLEAN COMMENT 'Indicates whether this carrier service mandates recipient signature upon delivery. Impacts service selection for high-value or restricted items.',
    `sla_delivery_guarantee_flag` BOOLEAN COMMENT 'Indicates whether this carrier service includes a contractual SLA (Service Level Agreement) delivery guarantee with refund or credit for late deliveries. Used in service selection and customer promise management.',
    `sunday_delivery_flag` BOOLEAN COMMENT 'Indicates whether this carrier service supports Sunday delivery. Used in delivery date estimation and customer service selection.',
    `surcharge_types` STRING COMMENT 'Comma-separated list of surcharge types applicable to this carrier service (e.g., fuel_surcharge, residential_delivery, remote_area, oversized, peak_season). Used in total shipping cost calculation.',
    `tracking_capability_flag` BOOLEAN COMMENT 'Indicates whether this carrier service provides real-time shipment tracking capability. Used to determine customer visibility options and service selection.',
    `transit_days_max` STRING COMMENT 'Maximum number of business days required for delivery from shipment date. Used in delivery date estimation and SLA (Service Level Agreement) calculations.',
    `transit_days_min` STRING COMMENT 'Minimum number of business days required for delivery from shipment date. Used in delivery date estimation and SLA (Service Level Agreement) calculations.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this carrier service record was last modified. Used for audit trail, change tracking, and data synchronization.',
    CONSTRAINT pk_carrier_service PRIMARY KEY(`carrier_service_id`)
) COMMENT 'Defines specific service offerings provided by a carrier, such as ground, 2-day, overnight, same-day, or BOPIS-ready services. Captures service code, service name, transit days, cutoff time, max weight, max dimensions, surcharge types, tracking capability, signature required flag, and geographic restrictions. Used in carrier selection logic during fulfillment order routing.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` (
    `fulfillment_node_id` BIGINT COMMENT 'Unique identifier for the node data product.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Each fulfillment node (DC, store fulfillment center, dark store) operates as a cost center for expense allocation, budget management, headcount planning, and operational cost reporting required for re',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Fulfillment nodes include DCs. When node is a DC, linking to dc_facility provides full facility details (dock doors, capacity, WMS, zones). Essential for DC-based fulfillment operations, capacity plan',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Fulfillment nodes operating as ship-from-store or BOPIS locations generate attributed revenue and operate as profit centers for segment reporting, channel profitability analysis, and omnichannel finan',
    `activation_date` DATE COMMENT 'Date when the fulfillment node became operational and available for order fulfillment.',
    `address_line_1` STRING COMMENT 'Primary street address of the fulfillment node (street number, street name). Organizational contact data classified as confidential per business policy.',
    `address_line_2` STRING COMMENT 'Secondary address information (suite, building, floor). Organizational contact data classified as confidential per business policy.',
    `automation_level` STRING COMMENT 'Degree of automation in fulfillment operations: manual (human-only picking/packing), semi_automated (conveyor systems, pick-to-light), fully_automated (robotic picking, automated storage and retrieval systems).. Valid values are `manual|semi_automated|fully_automated`',
    `bopis_enabled` BOOLEAN COMMENT 'Indicates whether this node supports Buy Online Pick Up In Store (BOPIS) fulfillment capability. True if customers can place online orders for in-store pickup at this location.',
    `city` STRING COMMENT 'City where the fulfillment node is located. Organizational contact data classified as confidential per business policy.',
    `country_code` STRING COMMENT 'Three-letter ISO country code where the fulfillment node is located (e.g., USA, CAN, MEX).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this fulfillment node record was first created in the system.',
    `curbside_pickup_enabled` BOOLEAN COMMENT 'Indicates whether this node supports curbside pickup fulfillment. True if customers can pick up orders without entering the building.',
    `deactivation_date` DATE COMMENT 'Date when the fulfillment node was decommissioned or permanently closed. Null for active nodes.',
    `delivery_zone_coverage_radius_miles` DECIMAL(18,2) COMMENT 'Maximum delivery radius in miles from this fulfillment node for last-mile delivery services. Used for order routing and delivery zone assignment.',
    `dock_door_count` STRING COMMENT 'Number of loading dock doors available at this fulfillment node for inbound receiving and outbound shipping. Key constraint for DC and cross-dock operations.',
    `email_address` STRING COMMENT 'Primary email contact for the fulfillment node operations team. Organizational contact data classified as confidential per business policy.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `hazmat_certified` BOOLEAN COMMENT 'Indicates whether this node is certified to handle and store hazardous materials per OSHA and DOT regulations. True if hazmat fulfillment is permitted.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this fulfillment node record was last updated in the system.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the fulfillment node, used for distance calculations, delivery zone mapping, and route optimization.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the fulfillment node, used for distance calculations, delivery zone mapping, and route optimization.',
    `manager_name` STRING COMMENT 'Name of the fulfillment operations manager responsible for this node. Business reference, not direct PII.',
    `next_day_delivery_enabled` BOOLEAN COMMENT 'Indicates whether this node supports next-day delivery fulfillment. True if orders can be delivered to customers on the day following order placement.',
    `node_code` STRING COMMENT 'Business identifier code for the fulfillment node, used across operational systems for node identification and routing logic. Typically alphanumeric, uppercase.. Valid values are `^[A-Z0-9]{4,12}$`',
    `node_name` STRING COMMENT 'Human-readable name of the fulfillment node (e.g., Downtown Distribution Center, Store #1234 - Main Street, MFC Phoenix West).',
    `node_status` STRING COMMENT 'Current operational lifecycle status of the fulfillment node. Active nodes are available for order routing; inactive/temporarily_closed nodes are excluded from fulfillment logic.. Valid values are `active|inactive|planned|under_construction|temporarily_closed|decommissioned`',
    `node_type` STRING COMMENT 'Classification of the fulfillment node by its primary operational purpose: distribution_center (DC - regional warehouse), store (retail location with fulfillment capability), dark_store (fulfillment-only location, no customer traffic), micro_fulfillment_center (MFC - automated urban fulfillment hub), cross_dock (direct transfer facility), returns_center (reverse logistics hub).. Valid values are `distribution_center|store|dark_store|micro_fulfillment_center|cross_dock|returns_center`',
    `operating_hours_weekday` STRING COMMENT 'Standard operating hours for weekdays (Monday-Friday) in format HH:MM-HH:MM (e.g., 08:00-20:00). Used for order cutoff time calculations and fulfillment scheduling.',
    `operating_hours_weekend` STRING COMMENT 'Standard operating hours for weekends (Saturday-Sunday) in format HH:MM-HH:MM (e.g., 09:00-18:00). Used for order cutoff time calculations and fulfillment scheduling.',
    `pack_station_count` STRING COMMENT 'Number of packing stations available at this fulfillment node. Determines packing throughput capacity for ship-from-store and DC operations.',
    `phone_number` STRING COMMENT 'Primary contact phone number for the fulfillment node. Organizational contact data classified as confidential per business policy.',
    `pick_capacity_orders_per_hour` STRING COMMENT 'Maximum number of orders that can be picked per hour at this fulfillment node under normal operating conditions. Used for capacity planning and order routing decisions.',
    `postal_code` STRING COMMENT 'Postal or ZIP code for the fulfillment node address. Organizational contact data classified as confidential per business policy.',
    `primary_carrier_code` STRING COMMENT 'Code identifying the primary shipping carrier assigned to this fulfillment node (e.g., UPS, FedEx, USPS, regional 3PL). Used for default carrier selection in order routing.',
    `refrigerated_storage_enabled` BOOLEAN COMMENT 'Indicates whether this node has refrigerated storage capability for perishable goods (dairy, produce, frozen foods). True if cold chain fulfillment is supported.',
    `ropis_enabled` BOOLEAN COMMENT 'Indicates whether this node supports Reserve Online Pick Up In Store (ROPIS) fulfillment capability. True if customers can reserve items online for later in-store pickup and payment.',
    `same_day_delivery_enabled` BOOLEAN COMMENT 'Indicates whether this node supports same-day delivery fulfillment. True if orders can be delivered to customers on the same day they are placed.',
    `ship_from_store_enabled` BOOLEAN COMMENT 'Indicates whether this node supports Ship From Store (SFS) fulfillment capability. True if this location can pick, pack, and ship online orders directly to customers.',
    `state_province` STRING COMMENT 'Two-letter state or province code (e.g., CA, TX, ON). Organizational contact data classified as confidential per business policy.. Valid values are `^[A-Z]{2}$`',
    `storage_capacity_square_feet` STRING COMMENT 'Total storage capacity of the fulfillment node measured in square feet. Used for inventory capacity planning and space utilization analysis.',
    `storage_zone_count` STRING COMMENT 'Number of distinct storage zones within the fulfillment node (e.g., ambient, refrigerated, frozen, hazmat). Used for inventory placement and pick path optimization.',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the fulfillment node (e.g., America/New_York, America/Los_Angeles), used for scheduling and cutoff time calculations.',
    `wms_system_code` STRING COMMENT 'Identifier of the WMS system instance managing this fulfillment node. Links to the operational WMS platform (e.g., Manhattan Associates instance ID).',
    CONSTRAINT pk_fulfillment_node PRIMARY KEY(`fulfillment_node_id`)
) COMMENT 'Master record for all physical locations capable of fulfilling customer orders, including stores acting as ship-from-store nodes, dark stores, micro-fulfillment centers (MFCs), and distribution centers (DCs). Captures node type, address, fulfillment capabilities (BOPIS, ROPIS, SFS, dark store, MFC), active carrier assignments, operating hours, pick capacity (orders/hour), pack station count, dock door count, storage zones, node activation status, and geographic delivery zone coverage. Distinct from the store domains store master — this entity focuses exclusively on fulfillment operational capabilities and capacity constraints. Note: PK naming (fulfillment_fulfillment_node_id) contains a double-prefix defect that should be corrected to fulfillment_node_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` (
    `bopis_appointment_id` BIGINT COMMENT 'Unique identifier for the BOPIS or ROPIS pickup appointment record.',
    `fulfillment_order_id` BIGINT COMMENT 'Foreign key linking to fulfillment.fulfillment_order. Business justification: bopis_appointment tracks BOPIS/ROPIS customer pickup appointments. It links to order_header but not to the operational fulfillment_order that picks and stages the items. Adding fulfillment_order_id FK',
    `header_id` BIGINT COMMENT 'Reference to the e-commerce or omnichannel order associated with this pickup appointment.',
    `location_id` BIGINT COMMENT 'Reference to the store or fulfillment node where the customer will pick up the order.',
    `associate_id` BIGINT COMMENT 'Reference to the store associate who handed off the order to the customer at pickup.',
    `profile_id` BIGINT COMMENT 'Reference to the customer who placed the order and scheduled the pickup appointment.',
    `actual_pickup_timestamp` TIMESTAMP COMMENT 'Timestamp when the customer physically received and collected the order from the store.',
    `actual_ready_minutes` STRING COMMENT 'Actual elapsed time in minutes from order placement to ready-for-pickup status, used for SLA performance tracking.',
    `alternate_pickup_person_name` STRING COMMENT 'Name of an alternate person authorized to pick up the order on behalf of the customer.',
    `appointment_number` STRING COMMENT 'Human-readable unique appointment confirmation number provided to the customer for reference at pickup.. Valid values are `^[A-Z0-9]{8,20}$`',
    `appointment_status` STRING COMMENT 'Current lifecycle status of the BOPIS appointment: scheduled (appointment created), ready (order ready for pickup), picked_up (customer collected order), expired (pickup window passed), cancelled (customer or system cancelled), no_show (customer did not arrive).. Valid values are `scheduled|ready|picked_up|expired|cancelled|no_show`',
    `appointment_type` STRING COMMENT 'Type of pickup appointment: BOPIS (Buy Online Pick Up In Store - order already paid) or ROPIS (Reserve Online Pick Up In Store - payment at pickup).. Valid values are `BOPIS|ROPIS`',
    `cancellation_reason` STRING COMMENT 'Reason code for appointment cancellation: customer_request, out_of_stock (item unavailable), store_closure, system_error, fraud (suspected fraudulent order), other.. Valid values are `customer_request|out_of_stock|store_closure|system_error|fraud|other`',
    `cancellation_timestamp` TIMESTAMP COMMENT 'Timestamp when the appointment was cancelled by customer or system.',
    `check_in_method` STRING COMMENT 'Method used by the customer to check in for pickup: mobile_app (customer used retailer app), kiosk (in-store self-service kiosk), associate (checked in with store associate), phone (called store), walk_in (arrived without prior check-in).. Valid values are `mobile_app|kiosk|associate|phone|walk_in`',
    `check_in_timestamp` TIMESTAMP COMMENT 'Timestamp when the customer checked in to notify the store of their arrival for pickup.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the BOPIS appointment record was first created in the system.',
    `customer_email` STRING COMMENT 'Email address for sending pickup ready notifications and appointment confirmations.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `customer_name` STRING COMMENT 'Full name of the customer who will pick up the order, used for identity verification at the pickup counter.',
    `customer_phone` STRING COMMENT 'Contact phone number for the customer, used for pickup notifications and communication.',
    `expiration_timestamp` TIMESTAMP COMMENT 'Timestamp when the appointment expired due to customer not picking up within the allowed window.',
    `id_verification_method` STRING COMMENT 'Method used to verify customer identity at pickup: drivers_license, passport, order_confirmation (email/SMS), photo_id, none (no verification required).. Valid values are `drivers_license|passport|order_confirmation|photo_id|none`',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the BOPIS appointment record was last modified.',
    `parking_spot_number` STRING COMMENT 'Designated parking spot number for curbside pickup where the customer is waiting.. Valid values are `^[A-Z0-9]{1,10}$`',
    `pickup_instructions` STRING COMMENT 'Special instructions provided by the customer for pickup (e.g., curbside delivery, vehicle description, accessibility needs).',
    `pickup_location_code` STRING COMMENT 'Code identifying the specific pickup area within the store (e.g., customer service desk, dedicated BOPIS counter, curbside zone).. Valid values are `^[A-Z0-9]{2,10}$`',
    `ready_for_pickup_timestamp` TIMESTAMP COMMENT 'Timestamp when the order was marked as ready for customer pickup by store associates or fulfillment system.',
    `ready_notification_sent_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the ready-for-pickup notification (email/SMS) was successfully sent to the customer.',
    `ready_notification_sent_timestamp` TIMESTAMP COMMENT 'Timestamp when the ready-for-pickup notification was sent to the customer.',
    `scheduled_date` DATE COMMENT 'The date on which the customer scheduled to pick up the order.',
    `scheduled_time_slot_end` TIMESTAMP COMMENT 'End timestamp of the customer-selected pickup time window.',
    `scheduled_time_slot_start` TIMESTAMP COMMENT 'Start timestamp of the customer-selected pickup time window.',
    `sla_met_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the BOPIS readiness SLA commitment was met (true) or missed (false).',
    `sla_target_ready_minutes` STRING COMMENT 'Target time in minutes from order placement to ready-for-pickup status, as committed in the BOPIS service level agreement.',
    `vehicle_description` STRING COMMENT 'Description of the customers vehicle for curbside pickup identification (make, model, color, license plate).',
    `wait_time_minutes` STRING COMMENT 'Time in minutes the customer waited from check-in to actual pickup, used for customer experience KPI tracking.',
    CONSTRAINT pk_bopis_appointment PRIMARY KEY(`bopis_appointment_id`)
) COMMENT 'Tracks BOPIS (Buy Online Pick Up In Store) and ROPIS (Reserve Online Pick Up In Store) customer pickup appointments. Captures order reference, customer name, pickup store/node, appointment window (date and time slot), check-in method (app, kiosk, associate), check-in timestamp, ready-for-pickup notification sent flag, actual pickup timestamp, and appointment status (scheduled, ready, picked-up, expired, cancelled). Enables SLA tracking for BOPIS readiness commitments.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`exception` (
    `exception_id` BIGINT COMMENT 'Primary key for exception',
    `associate_id` BIGINT COMMENT 'Reference to the specific employee, system, or carrier entity responsible for or assigned to resolve the exception.',
    `carrier_id` BIGINT COMMENT 'Reference to the carrier involved in the exception. Relevant for carrier pickup missed or delivery attempt failure exceptions.',
    `corrective_action_id` BIGINT COMMENT 'Foreign key linking to compliance.corrective_action. Business justification: Fulfillment exceptions (temperature excursions, damaged goods, contamination) trigger corrective actions tracked in compliance system. Supports CAPA processes, quality management, and audit evidence f',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Fulfillment exceptions (damaged goods, mis-picks, customer returns, carrier claims) create operational costs and shrink that must be allocated to cost centers for variance tracking, exception cost ana',
    `fulfillment_line_id` BIGINT COMMENT 'Reference to the specific fulfillment order line item affected by this exception. Nullable if exception applies to entire order.',
    `fulfillment_node_id` BIGINT COMMENT 'Reference to the fulfillment location (distribution center, store, dark store, micro-fulfillment center) where the exception occurred.',
    `fulfillment_order_id` BIGINT COMMENT 'Reference to the fulfillment order in which this exception occurred.',
    `loyalty_membership_id` BIGINT COMMENT 'Foreign key linking to loyalty.membership. Business justification: Fulfillment exception resolution in retail is prioritized by loyalty tier - VIP members receive immediate escalation, expedited replacement, and premium communication. Real-time exception routing syst',
    `service_case_id` BIGINT COMMENT 'Foreign key linking to service.service_case. Business justification: Fulfillment exceptions (damaged goods, delivery failures, inventory shortages) often trigger customer service cases. Linking exception to service_case enables tracking which exceptions resulted in cus',
    `exception_code` STRING COMMENT 'System-specific code representing the detailed exception reason. Maps to internal exception taxonomy and resolution workflows.',
    `corrective_action_plan` STRING COMMENT 'Description of preventive measures or process changes implemented to avoid recurrence of similar exceptions.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this exception record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for financial impact amount.. Valid values are `^[A-Z]{3}$`',
    `customer_notification_timestamp` TIMESTAMP COMMENT 'Date and time when customer notification was sent regarding the exception.',
    `customer_notified_flag` BOOLEAN COMMENT 'Indicates whether the customer was notified about the exception and its impact on their order.',
    `exception_description` STRING COMMENT 'Detailed narrative description of the exception circumstances, root cause, and impact. Captured by fulfillment associate or system.',
    `detected_at_stage` STRING COMMENT 'Fulfillment process stage where the exception was identified. [ENUM-REF-CANDIDATE: picking|packing|quality_check|staging|loading|carrier_handoff|in_transit|delivery — 8 candidates stripped; promote to reference product]',
    `escalation_level` STRING COMMENT 'Number indicating how many times the exception has been escalated through management hierarchy. Zero indicates no escalation.',
    `exception_number` STRING COMMENT 'Human-readable business identifier for the exception, used for tracking and communication across fulfillment teams.',
    `exception_status` STRING COMMENT 'Current lifecycle state of the exception in the resolution workflow.. Valid values are `open|in_progress|resolved|escalated|cancelled`',
    `exception_timestamp` TIMESTAMP COMMENT 'Date and time when the exception was first detected or logged in the fulfillment system.',
    `exception_type` STRING COMMENT 'Category of fulfillment exception encountered. Classifies the nature of the operational disruption. [ENUM-REF-CANDIDATE: out_of_stock_at_pick|damaged_item|mispick|carrier_pickup_missed|address_validation_failure|delivery_attempt_failure|item_not_found|quantity_shortage|quality_issue|packaging_failure|label_printing_error|system_error — 12 candidates stripped; promote to reference product]',
    `financial_impact_amount` DECIMAL(18,2) COMMENT 'Estimated or actual financial cost of the exception in local currency, including refunds, credits, expedited shipping, or inventory write-offs.',
    `notes` STRING COMMENT 'Additional free-form notes or comments from fulfillment associates, supervisors, or customer service regarding the exception handling.',
    `owner_type` STRING COMMENT 'Role or system component responsible for the exception occurrence or resolution. [ENUM-REF-CANDIDATE: picker|packer|quality_inspector|carrier|system|supervisor|customer_service — 7 candidates stripped; promote to reference product]',
    `priority` STRING COMMENT 'Business priority assigned to the exception resolution based on customer impact, order value, and SLA criticality.. Valid values are `critical|high|medium|low`',
    `quantity_affected` DECIMAL(18,2) COMMENT 'Number of units impacted by the exception. Relevant for quantity shortages, damaged items, or mispicks.',
    `resolution_action` STRING COMMENT 'Corrective action taken or planned to resolve the exception. [ENUM-REF-CANDIDATE: substitute_item|cancel_line|reroute_order|reschedule_delivery|issue_refund|contact_customer|escalate_to_supervisor|reprocess — 8 candidates stripped; promote to reference product]',
    `resolution_duration_minutes` STRING COMMENT 'Time elapsed in minutes from exception detection to resolution. Used for SLA tracking and performance analysis.',
    `resolution_timestamp` TIMESTAMP COMMENT 'Date and time when the exception was resolved or closed. Nullable if exception is still open.',
    `root_cause_category` STRING COMMENT 'High-level classification of the underlying cause of the exception. Used for trend analysis and process improvement. [ENUM-REF-CANDIDATE: inventory_accuracy|process_error|system_failure|carrier_issue|product_quality|human_error|external_factor — 7 candidates stripped; promote to reference product]',
    `sku` STRING COMMENT 'Product SKU affected by the exception. Nullable if exception is not item-specific.',
    `sla_breach_flag` BOOLEAN COMMENT 'Indicates whether this exception caused a breach of fulfillment service level agreement commitments.',
    `sla_target_resolution_minutes` STRING COMMENT 'Target time in minutes within which this exception type should be resolved per SLA policy.',
    `tracking_number` STRING COMMENT 'Shipment tracking number associated with the exception. Applicable for in-transit or delivery exceptions.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this exception record was last modified.',
    CONSTRAINT pk_exception PRIMARY KEY(`exception_id`)
) COMMENT 'Records operational exceptions encountered during the fulfillment lifecycle, including out-of-stock at pick, damaged item, mispick, carrier pickup missed, address validation failure, and delivery attempt failure. Captures exception type, exception code, affected fulfillment order and line, exception timestamp, resolution action taken, resolution timestamp, and exception owner (picker, packer, carrier, system). Drives exception management workflows and SLA breach tracking.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` (
    `shipment_tracking_event_id` BIGINT COMMENT 'Unique identifier for the shipment tracking event record. Primary key.',
    `carrier_id` BIGINT COMMENT 'Reference to the carrier entity that reported this tracking event (e.g., FedEx, UPS, USPS, regional 3PL).',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: shipment_tracking_event has carrier_id FK and denormalized carrier_service_level column, but no FK to carrier_service. Business reality: tracking events are reported by the carrier for a specific serv',
    `shipment_id` BIGINT COMMENT 'Reference to the parent shipment for which this tracking event was recorded. Links to the shipment entity.',
    `shipment_package_id` BIGINT COMMENT 'Reference to the specific package within the shipment if tracking is at package level. Nullable for shipment-level events.',
    `carrier_event_code` STRING COMMENT 'The raw event code provided by the carrier in their native format. Preserved for audit and troubleshooting purposes.',
    `carrier_event_description` STRING COMMENT 'The human-readable event description provided by the carrier. May contain carrier-specific terminology and details.',
    `carrier_facility_code` STRING COMMENT 'The carriers internal facility or hub code where the event was recorded. Used for detailed logistics analysis.',
    `data_source_system` STRING COMMENT 'The specific system or API endpoint that provided this tracking event (e.g., FedEx Track API v1, UPS Quantum View, EDI 214 from XYZ 3PL).',
    `data_source_type` STRING COMMENT 'The integration method or channel through which this tracking event was received. Enables data quality and latency analysis by source.. Valid values are `carrier_api|edi_214|webhook|manual_entry|scrape`',
    `delivery_signature_name` STRING COMMENT 'Name of the person who signed for the delivery, if applicable. Captured only for delivered events with signature.',
    `delivery_signature_required_flag` BOOLEAN COMMENT 'Indicates whether a signature was required for delivery. True if signature required, False otherwise.',
    `estimated_delivery_date` DATE COMMENT 'The carriers current estimated delivery date for the shipment. May be updated with each tracking event as conditions change.',
    `event_location_city` STRING COMMENT 'The city where the tracking event occurred, as reported by the carrier. May be null for certain event types.',
    `event_location_country_code` STRING COMMENT 'Three-letter ISO country code where the tracking event occurred (e.g., USA, CAN, MEX).. Valid values are `^[A-Z]{3}$`',
    `event_location_postal_code` STRING COMMENT 'The postal code or ZIP code where the tracking event occurred, as reported by the carrier.',
    `event_location_state` STRING COMMENT 'The state or province code where the tracking event occurred. Uses standard postal abbreviations (e.g., CA, TX, ON).',
    `event_sequence_number` STRING COMMENT 'Sequential ordering of events within a shipment lifecycle. Enables chronological sorting and gap detection in event streams.',
    `event_timestamp` TIMESTAMP COMMENT 'The date and time when the tracking event occurred in the carriers system, reported in ISO 8601 format with timezone. This is the business event time, not the data ingestion time.',
    `event_type` STRING COMMENT 'Standardized classification of the tracking event milestone. Normalized from carrier-specific event codes to enable cross-carrier analytics. [ENUM-REF-CANDIDATE: label_created|picked_up|in_transit|out_for_delivery|delivered|delivery_attempted|exception|returned_to_sender|cancelled — 9 candidates stripped; promote to reference product]',
    `exception_code` STRING COMMENT 'Standardized code indicating the type of delivery exception if event_type is exception. Examples: weather_delay, address_issue, recipient_unavailable, damaged_package.',
    `exception_description` STRING COMMENT 'Detailed description of the exception or issue that occurred, if applicable. Null for non-exception events.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate where the tracking event occurred, if available from carrier GPS data. Enables geospatial analytics.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate where the tracking event occurred, if available from carrier GPS data. Enables geospatial analytics.',
    `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether a customer notification (email, SMS, push) was triggered by this tracking event. True if notification sent, False otherwise.',
    `notification_sent_timestamp` TIMESTAMP COMMENT 'The timestamp when the customer notification was sent, if applicable. Null if no notification was sent.',
    `received_timestamp` TIMESTAMP COMMENT 'The timestamp when this tracking event record was received and ingested into the data platform. Used for data latency monitoring and audit purposes.',
    `scan_type` STRING COMMENT 'The method used to capture this tracking event. Indicates whether the scan was automated (conveyor), manual (handheld), mobile (driver app), or RFID-based.. Valid values are `automated|manual|mobile|rfid`',
    `source_record_reference` STRING COMMENT 'The unique identifier of this event in the source carrier system or EDI transaction. Enables traceability and deduplication.',
    `tracking_number` STRING COMMENT 'The carrier-assigned tracking number for the shipment or package. Used for customer-facing tracking queries.',
    `weight_actual_kg` DECIMAL(18,2) COMMENT 'The actual weight of the package as measured by the carrier, in kilograms. May differ from the declared weight and can trigger billing adjustments.',
    CONSTRAINT pk_shipment_tracking_event PRIMARY KEY(`shipment_tracking_event_id`)
) COMMENT 'Immutable event log of carrier-reported tracking milestones for a shipment or package. Captures event type (label created, picked up, in-transit, out-for-delivery, delivered, exception, returned), event timestamp, event location (city, state, facility), carrier event code, carrier event description, and data source (carrier API, EDI 214, webhook). Enables real-time shipment visibility and customer notification triggers. Sourced from carrier EDI/API integrations.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`sla` (
    `sla_id` BIGINT COMMENT 'Primary key for sla',
    `carrier_id` BIGINT COMMENT 'Identifier of the shipping carrier this SLA applies to (e.g., FedEx, UPS, USPS, regional courier). Null if SLA is carrier-agnostic.',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: sla defines SLA rules for specific carrier services (e.g., FedEx 2-Day must deliver within 48 hours). Currently has carrier_id FK and denormalized carrier_service_level column, but no FK to carrier_',
    `fulfillment_node_id` BIGINT COMMENT 'Identifier of the specific fulfillment node (store, DC, dark store, MFC) this SLA rule applies to. Null if SLA applies globally across all nodes of the specified node_type.',
    `category_id` BIGINT COMMENT 'Identifier of the product category this SLA applies to (e.g., perishables may have stricter SLAs). Null if SLA applies to all product categories.',
    `applies_to_holidays` BOOLEAN COMMENT 'Indicates whether this SLA rule applies to orders placed on recognized holidays. If false, holiday orders may follow different SLA rules.',
    `applies_to_weekdays` BOOLEAN COMMENT 'Indicates whether this SLA rule applies to orders placed on weekdays (Monday-Friday).',
    `applies_to_weekends` BOOLEAN COMMENT 'Indicates whether this SLA rule applies to orders placed on weekends (Saturday-Sunday).',
    `breach_threshold_hours` DECIMAL(18,2) COMMENT 'Number of hours before the SLA deadline at which an alert or escalation should be triggered if the order is not yet fulfilled. Used for proactive SLA risk management.',
    `breach_threshold_percentage` DECIMAL(18,2) COMMENT 'Percentage of the total SLA time window at which an alert should be triggered (e.g., 80% means alert when 80% of allowed time has elapsed). Alternative to breach_threshold_hours.',
    `carrier_cutoff_time` TIMESTAMP COMMENT 'Daily cutoff time (HH:MM in 24-hour format, local node time) by which orders must be ready for carrier pickup to meet the SLA. Null if not applicable.',
    `sla_code` STRING COMMENT 'Business-readable unique code identifying this SLA rule (e.g., BOPIS_2HR, SAMEDAY_SHIP, NEXTDAY_DEL).. Valid values are `^[A-Z0-9_-]{3,20}$`',
    `compliance_notes` STRING COMMENT 'Free-text notes documenting any regulatory, contractual, or business policy requirements that govern this SLA rule (e.g., Required by premium membership terms, State law mandates 24-hour BOPIS readiness).',
    `country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code this SLA applies to (e.g., USA, CAN, MEX). Null if SLA is not country-specific.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this SLA rule record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for order value thresholds (e.g., USD, CAD, EUR). Null if order value thresholds are not defined.. Valid values are `^[A-Z]{3}$`',
    `effective_end_date` DATE COMMENT 'Date after which this SLA rule is no longer effective. Null indicates the rule is open-ended and remains active until explicitly deactivated.',
    `effective_start_date` DATE COMMENT 'Date from which this SLA rule becomes effective and should be applied to orders.',
    `escalation_rule` STRING COMMENT 'Business rule or workflow identifier defining what actions to take when SLA breach risk is detected (e.g., NOTIFY_STORE_MANAGER, REROUTE_TO_ALTERNATE_NODE, UPGRADE_CARRIER_SERVICE).',
    `excluded_dates` STRING COMMENT 'Comma-separated list of specific dates (YYYY-MM-DD format) on which this SLA rule does not apply (e.g., peak season blackout dates, facility closures).',
    `fulfillment_method` STRING COMMENT 'The fulfillment execution method this SLA applies to: BOPIS (Buy Online Pick Up In Store), ROPIS (Reserve Online Pick Up In Store), ship-to-home, ship-from-store, dark store fulfillment, curbside pickup, locker pickup, or direct ship. [ENUM-REF-CANDIDATE: BOPIS|ROPIS|SHIP_TO_HOME|SHIP_FROM_STORE|DARK_STORE|CURBSIDE_PICKUP|LOCKER_PICKUP|DIRECT_SHIP — 8 candidates stripped; promote to reference product]',
    `geographic_scope` STRING COMMENT 'Geographic applicability of this SLA rule: GLOBAL (all locations), NATIONAL (country-wide), REGIONAL (multi-state/province), LOCAL (specific metro area or node).. Valid values are `GLOBAL|NATIONAL|REGIONAL|LOCAL`',
    `is_active` BOOLEAN COMMENT 'Indicates whether this SLA rule is currently active and should be applied to new orders. False means the rule is disabled or deprecated.',
    `loyalty_tier` STRING COMMENT 'Customer loyalty program tier this SLA applies to (e.g., PLATINUM, GOLD, SILVER). Null if SLA is not loyalty-tier-specific. Premium tiers may receive enhanced SLA commitments.',
    `sla_name` STRING COMMENT 'Human-readable descriptive name of the SLA rule (e.g., Buy Online Pick Up In Store - 2 Hour Ready, Same-Day Shipping Cutoff).',
    `node_type` STRING COMMENT 'Type of fulfillment node this SLA applies to: store, distribution center (DC), dark store (fulfillment-only location), micro-fulfillment center (MFC), vendor, or third-party logistics (3PL).. Valid values are `STORE|DC|DARK_STORE|MFC|VENDOR|3PL`',
    `order_channel` STRING COMMENT 'The sales channel through which the order was placed: web, mobile app, in-store, call center, marketplace, or social commerce.. Valid values are `WEB|MOBILE_APP|IN_STORE|CALL_CENTER|MARKETPLACE|SOCIAL_COMMERCE`',
    `order_cutoff_time` TIMESTAMP COMMENT 'Daily cutoff time (HH:MM in 24-hour format, local node time) by which orders must be placed to qualify for this SLA (e.g., same-day delivery cutoff at 14:00). Null if no order cutoff applies.',
    `order_value_max` DECIMAL(18,2) COMMENT 'Maximum order total amount (in currency_code) for which this SLA applies. Null if no maximum order value threshold exists.',
    `order_value_min` DECIMAL(18,2) COMMENT 'Minimum order total amount (in currency_code) required for this SLA to apply. Null if no minimum order value threshold exists.',
    `postal_code_pattern` STRING COMMENT 'Regex pattern or prefix defining the postal/ZIP codes this SLA applies to (e.g., ^90[0-9]{3}$ for Los Angeles area). Null if SLA is not postal-code-specific.',
    `priority_level` STRING COMMENT 'Business priority assigned to this SLA rule: CRITICAL (premium/express), HIGH (next-day), MEDIUM (standard), LOW (economy). Used for resource allocation and conflict resolution.. Valid values are `CRITICAL|HIGH|MEDIUM|LOW`',
    `promised_hours_to_deliver` DECIMAL(18,2) COMMENT 'Total number of hours from order placement to final delivery to the customer. Used for end-to-end delivery SLAs (same-day, next-day, standard ground).',
    `promised_hours_to_ready` DECIMAL(18,2) COMMENT 'Number of hours from order placement to when the order must be ready for customer pickup (for BOPIS/ROPIS) or ready for carrier pickup (for ship-from-store). Null if not applicable to this SLA type.',
    `promised_hours_to_ship` DECIMAL(18,2) COMMENT 'Number of hours from order placement to when the shipment must be handed off to the carrier. Applies to ship-to-home and ship-from-store fulfillment methods.',
    `region_code` STRING COMMENT 'Internal region or state/province code this SLA applies to (e.g., US-CA, US-TX, NORTHEAST). Null if SLA is not region-specific.',
    `sla_type` STRING COMMENT 'Category of SLA commitment: BOPIS readiness, ROPIS readiness, same-day ship cutoff, next-day delivery, standard ground, express delivery, or ship-from-store. [ENUM-REF-CANDIDATE: BOPIS_READINESS|ROPIS_READINESS|SAME_DAY_SHIP|NEXT_DAY_DELIVERY|STANDARD_GROUND|EXPRESS_DELIVERY|SHIP_FROM_STORE — 7 candidates stripped; promote to reference product]',
    `updated_by` STRING COMMENT 'User ID or system identifier of the person or process that last updated this SLA rule record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this SLA rule record was last modified.',
    CONSTRAINT pk_sla PRIMARY KEY(`sla_id`)
) COMMENT 'Defines SLA (Service Level Agreement) rules and thresholds governing fulfillment performance commitments. Captures SLA type (BOPIS readiness, same-day ship cutoff, next-day delivery, standard ground), fulfillment method, order channel, node type, promised hours-to-ready, promised hours-to-ship, carrier cutoff time, breach threshold, and escalation rules. Used to evaluate fulfillment order compliance and trigger alerts when SLA risk is detected.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` (
    `carrier_rate_id` BIGINT COMMENT 'Unique identifier for the carrier rate record. Primary key.',
    `carrier_id` BIGINT COMMENT 'Reference to the carrier (shipping company) offering this rate. Links to the carrier master entity.',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: carrier_rate has carrier_id FK and denormalized service_level/service_code columns, but no FK to carrier_service. Business reality: a rate is pricing for a specific carrier_service offering. Adding ca',
    `base_rate_amount` DECIMAL(18,2) COMMENT 'Base shipping rate amount before surcharges and discounts. This is the starting point for freight cost calculation.',
    `contract_number` STRING COMMENT 'Reference number of the carrier contract or agreement under which this rate is offered. Business-confidential identifier.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this carrier rate record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this rate record (e.g., USD, CAD, EUR).. Valid values are `^[A-Z]{3}$`',
    `destination_country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code for the shipment destination (e.g., USA, CAN, MEX).. Valid values are `^[A-Z]{3}$`',
    `destination_postal_code` STRING COMMENT 'Postal code of the shipment destination (customer delivery address).',
    `dimensional_weight_factor` DECIMAL(18,2) COMMENT 'Divisor used to calculate dimensional weight from package dimensions (length × width × height ÷ factor). Common values are 5000 (cm³/kg) or 139 (in³/lb).',
    `effective_date` DATE COMMENT 'Date when this carrier rate becomes active and can be used for freight cost estimation and carrier selection.',
    `expiry_date` DATE COMMENT 'Date when this carrier rate expires and is no longer valid. Null indicates an open-ended rate with no expiration.',
    `extended_area_surcharge` DECIMAL(18,2) COMMENT 'Additional fee for delivery to remote or extended service areas beyond standard carrier coverage zones.',
    `fuel_surcharge_rate` DECIMAL(18,2) COMMENT 'Fuel surcharge rate expressed as a decimal percentage (e.g., 0.1250 for 12.50%). Applied to base rate to account for fuel cost fluctuations.',
    `is_hazmat_eligible` BOOLEAN COMMENT 'Flag indicating whether this carrier service level can handle hazardous materials shipments under applicable regulations.',
    `is_international` BOOLEAN COMMENT 'Flag indicating whether this rate applies to international shipments (cross-border) or domestic shipments within a single country.',
    `minimum_charge_amount` DECIMAL(18,2) COMMENT 'Minimum shipping charge that will be applied regardless of calculated rate. Ensures carrier covers base handling costs.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this carrier rate record was last modified or updated.',
    `negotiated_discount_percentage` DECIMAL(18,2) COMMENT 'Discount percentage off published rates negotiated with the carrier, expressed as a decimal (e.g., 0.1500 for 15% discount). Business-confidential contract term.',
    `notes` STRING COMMENT 'Free-text notes or comments about this carrier rate, including special terms, restrictions, or usage guidance.',
    `origin_country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code for the shipment origin (e.g., USA, CAN, MEX).. Valid values are `^[A-Z]{3}$`',
    `origin_postal_code` STRING COMMENT 'Postal code of the shipment origin location (fulfillment center, store, or warehouse).',
    `oversized_package_surcharge` DECIMAL(18,2) COMMENT 'Additional fee for packages exceeding standard size limits (length + girth thresholds vary by carrier).',
    `rate_per_kg` DECIMAL(18,2) COMMENT 'Incremental rate charged per kilogram above the weight break minimum. Used for weight-based pricing calculations.',
    `rate_source` STRING COMMENT 'Source system or method by which this rate was obtained: carrier API (real-time), manual entry, contract upload, rate shopping engine, or third-party logistics provider.. Valid values are `carrier_api|manual_entry|contract_upload|rate_shop|third_party`',
    `rate_status` STRING COMMENT 'Current lifecycle status of the carrier rate: active (in use), inactive (not in use), pending (awaiting activation), expired (past expiry date), suspended (temporarily disabled).. Valid values are `active|inactive|pending|expired|suspended`',
    `rate_type` STRING COMMENT 'Classification of the rate: base (standard published rate), negotiated (custom contract rate), published (carrier list price), spot (one-time rate), or contract (long-term agreement rate).. Valid values are `base|negotiated|published|spot|contract`',
    `rate_version` STRING COMMENT 'Version number of this rate record. Incremented when rate terms are updated, enabling rate history tracking and audit trails.',
    `rate_zone` STRING COMMENT 'Geographic zone or region for which this rate applies. Carriers use zone-based pricing to calculate shipping costs based on origin and destination distance.',
    `residential_delivery_surcharge` DECIMAL(18,2) COMMENT 'Additional flat fee charged for delivery to residential addresses (as opposed to commercial addresses).',
    `saturday_delivery_surcharge` DECIMAL(18,2) COMMENT 'Additional fee for Saturday delivery service, which is outside standard weekday delivery schedules.',
    `service_level` STRING COMMENT 'Type of shipping service offered by the carrier (e.g., ground, express, overnight, two-day, economy, priority, standard). [ENUM-REF-CANDIDATE: ground|express|overnight|two_day|economy|priority|standard — 7 candidates stripped; promote to reference product]',
    `signature_required_surcharge` DECIMAL(18,2) COMMENT 'Additional fee charged when signature confirmation is required upon delivery.',
    `transit_days` STRING COMMENT 'Expected number of business days for shipment transit from origin to destination using this service level.',
    `weight_break_max_kg` DECIMAL(18,2) COMMENT 'Maximum weight in kilograms for this rate tier. Null indicates no upper limit for the highest tier.',
    `weight_break_min_kg` DECIMAL(18,2) COMMENT 'Minimum weight in kilograms for this rate tier. Carriers use weight breaks to define tiered pricing (e.g., 0-5kg, 5-10kg, 10-20kg).',
    CONSTRAINT pk_carrier_rate PRIMARY KEY(`carrier_rate_id`)
) COMMENT 'Contracted and published rate records for carrier services, capturing base rate, dimensional weight factor, fuel surcharge rate, residential delivery surcharge, extended area surcharge, rate effective date, rate expiry date, rate zone, weight break, and negotiated discount percentage. Used in carrier selection and freight cost estimation during fulfillment order routing. Distinct from pricing domain — this is carrier freight cost, not retail product pricing.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` (
    `drop_ship_order_id` BIGINT COMMENT 'Primary key for drop_ship_order',
    `buyer_id` BIGINT COMMENT 'Foreign key linking to merchandising.buyer. Business justification: Buyers negotiate drop-ship agreements with vendors, approve drop-ship SKUs, and own vendor performance. Retail operations track which buyer authorized each drop-ship arrangement for vendor management',
    `carrier_id` BIGINT COMMENT 'Reference to the shipping carrier used by the vendor for drop ship delivery.',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: drop_ship_order has carrier_id FK and denormalized carrier_service_level column, but no FK to carrier_service. Business reality: a drop-ship order is fulfilled by the vendor using a specific carrier s',
    `cost_price_id` BIGINT COMMENT 'Foreign key linking to pricing.cost_price. Business justification: Drop ship orders track vendor cost for margin analysis, profitability reporting, and vendor performance evaluation. Currently has denormalized unit_cost/extended_cost; linking to cost_price provides f',
    `header_id` BIGINT COMMENT 'Reference to the parent customer order that this drop ship fulfillment is executing against.',
    `order_line_id` BIGINT COMMENT 'Reference to the specific order line item being fulfilled via drop ship.',
    `profile_id` BIGINT COMMENT 'Reference to the customer who will receive the drop ship delivery.',
    `vendor_contact_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contact. Business justification: Drop ship operations require designated vendor contact for order transmission, shipment coordination, exception resolution, and SLA escalation. Retail drop ship systems maintain contact assignments pe',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: Drop ship orders execute under specific vendor contracts defining pricing, terms, SLAs, and chargeback provisions. Contract reference required for compliance verification, SLA monitoring, dispute reso',
    `vendor_id` BIGINT COMMENT 'Reference to the supplier or vendor who will ship directly to the customer on behalf of the retailer.',
    `vendor_item_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_item. Business justification: Drop ship PO generation requires vendor item number, pack configuration, and vendor-specific cost from vendor item master. Critical for accurate vendor order transmission, invoice reconciliation, and',
    `actual_delivery_date` DATE COMMENT 'Date the customer actually received the drop ship delivery. Confirmed via carrier proof of delivery.',
    `actual_ship_date` DATE COMMENT 'Date the vendor actually shipped the order to the customer. Used for SLA compliance measurement.',
    `cancellation_reason` STRING COMMENT 'Reason the drop ship order was cancelled, either by the customer, retailer, or vendor.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time this drop ship order record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code for all monetary amounts in this drop ship order.. Valid values are `^[A-Z]{3}$`',
    `drop_ship_order_number` STRING COMMENT 'Unique business identifier for the drop ship order, used for external communication and tracking.',
    `drop_ship_status` STRING COMMENT 'Current lifecycle status of the drop ship order. Tracks progression from vendor notification through final delivery. [ENUM-REF-CANDIDATE: sent_to_vendor|acknowledged|in_progress|shipped|delivered|cancelled|exception|returned — 8 candidates stripped; promote to reference product]',
    `estimated_delivery_date` DATE COMMENT 'Expected date the customer will receive the drop ship delivery.',
    `exception_code` STRING COMMENT 'Standardized code identifying the type of exception or issue encountered during drop ship fulfillment (e.g., out of stock, address invalid, delivery failed).',
    `exception_description` STRING COMMENT 'Detailed explanation of the exception or issue that occurred during drop ship processing or delivery.',
    `gtin` STRING COMMENT 'Global standard identifier for the trade item being drop shipped.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time this drop ship order record was last updated.',
    `product_name` STRING COMMENT 'Human-readable name or description of the product being drop shipped.',
    `promised_ship_date` DATE COMMENT 'Date the vendor committed to ship the order to the customer. Used for SLA tracking and customer expectation management.',
    `quantity_ordered` STRING COMMENT 'Number of units requested from the vendor for drop ship fulfillment.',
    `quantity_shipped` STRING COMMENT 'Actual number of units shipped by the vendor to the customer.',
    `sent_to_vendor_timestamp` TIMESTAMP COMMENT 'Date and time the drop ship request was transmitted to the vendor via EDI, API, or portal.',
    `ship_to_address_line1` STRING COMMENT 'Primary street address line for the customer delivery location.',
    `ship_to_address_line2` STRING COMMENT 'Secondary address line (apartment, suite, building) for the customer delivery location.',
    `ship_to_city` STRING COMMENT 'City name for the customer delivery location.',
    `ship_to_country_code` STRING COMMENT 'Three-letter ISO country code for the customer delivery location.. Valid values are `^[A-Z]{3}$`',
    `ship_to_email` STRING COMMENT 'Email address for delivery notifications and tracking updates.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `ship_to_name` STRING COMMENT 'Name of the recipient for the drop ship delivery.',
    `ship_to_phone` STRING COMMENT 'Contact phone number for delivery coordination and customer communication.',
    `ship_to_postal_code` STRING COMMENT 'Postal or ZIP code for the customer delivery location.',
    `ship_to_state_province` STRING COMMENT 'State or province code for the customer delivery location.',
    `sku` STRING COMMENT 'Retailers internal product identifier for the item being drop shipped.',
    `unit_of_measure` STRING COMMENT 'Standard unit used to quantify the product (e.g., each, case, box).. Valid values are `each|case|pallet|box|pair|set`',
    `upc` STRING COMMENT 'Standard barcode identifier for the product being drop shipped.',
    `vendor_acknowledged_timestamp` TIMESTAMP COMMENT 'Date and time the vendor confirmed receipt and acceptance of the drop ship order.',
    `vendor_order_reference` STRING COMMENT 'Vendors internal order reference or confirmation number for this drop ship request.',
    `vendor_po_number` STRING COMMENT 'Purchase order number sent to the vendor to authorize the drop ship fulfillment. Used for vendor reconciliation and invoice matching.',
    `vendor_sla_compliance_flag` BOOLEAN COMMENT 'Indicates whether the vendor met the promised ship date commitment. True if shipped on or before promised date, false otherwise.',
    `vendor_tracking_number` STRING COMMENT 'Carrier tracking number provided by the vendor for shipment visibility and customer self-service tracking.',
    CONSTRAINT pk_drop_ship_order PRIMARY KEY(`drop_ship_order_id`)
) COMMENT 'Tracks vendor drop-ship fulfillment orders where the supplier ships directly to the customer on behalf of the retailer. Captures vendor reference, PO number sent to vendor, customer ship-to address, promised ship date, actual ship date, vendor tracking number, drop-ship status (sent-to-vendor, acknowledged, shipped, delivered, exception), and vendor SLA compliance flag. Distinct from standard fulfillment orders — drop-ship bypasses the retailers physical fulfillment nodes entirely.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` (
    `proof_of_delivery_id` BIGINT COMMENT 'Unique identifier for the proof of delivery record. Primary key.',
    `associate_id` BIGINT COMMENT 'Reference to the driver or delivery associate who completed the delivery. Used for driver performance tracking and accountability.',
    `carrier_id` BIGINT COMMENT 'Reference to the carrier or logistics provider who executed the delivery. Used for carrier performance tracking and compliance.',
    `header_id` BIGINT COMMENT 'Reference to the customer order associated with this delivery. Enables tracing POD back to the original order.',
    `outbound_shipment_id` BIGINT COMMENT 'Foreign key linking to supplychain.outbound_shipment. Business justification: POD for DC-to-store shipments. When DC ships to store, proof_of_delivery captures store receipt signature/timestamp, linking to outbound_shipment. Critical for store replenishment confirmation, DC-to-',
    `shipment_id` BIGINT COMMENT 'Reference to the shipment that was delivered. Links to the shipment record for which proof of delivery was captured.',
    `age_verification_completed_flag` BOOLEAN COMMENT 'Indicates whether age verification was successfully completed. True if verification passed, False otherwise.',
    `age_verification_required_flag` BOOLEAN COMMENT 'Indicates whether age verification was required for this delivery (e.g., alcohol, tobacco). True if verification was required, False otherwise.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this proof of delivery record was first created in the system. Used for audit trail and data lineage.',
    `customer_notified_flag` BOOLEAN COMMENT 'Indicates whether the customer was notified of the delivery completion. True if notification was sent, False otherwise.',
    `delivery_date` DATE COMMENT 'The calendar date of delivery. Used for daily delivery reporting and performance analytics.',
    `delivery_exception_code` STRING COMMENT 'The code representing any exception or issue encountered during delivery (e.g., customer not home, address incorrect, access denied). Used for root cause analysis.',
    `delivery_instructions_followed_flag` BOOLEAN COMMENT 'Indicates whether the driver followed the customer-provided delivery instructions. True if instructions were followed, False otherwise.',
    `delivery_latitude` DECIMAL(18,2) COMMENT 'The GPS latitude coordinate where the delivery was completed. Used for route optimization and delivery location verification.',
    `delivery_location_type` STRING COMMENT 'The specific location where the package was left at the delivery address. Critical for customer satisfaction and package security. [ENUM-REF-CANDIDATE: front_door|back_door|side_door|garage|porch|mailbox|parcel_locker|reception|neighbor|building_office|other — 11 candidates stripped; promote to reference product]',
    `delivery_longitude` DECIMAL(18,2) COMMENT 'The GPS longitude coordinate where the delivery was completed. Used for route optimization and delivery location verification.',
    `delivery_notes` STRING COMMENT 'Free-text notes entered by the driver about the delivery. Captures additional context not covered by structured fields.',
    `delivery_photo_url` STRING COMMENT 'The URL or storage path to the photo taken at the delivery location. Provides visual proof of package placement and condition.',
    `delivery_status` STRING COMMENT 'The final status of the delivery attempt. Indicates whether the delivery was successful or encountered issues.. Valid values are `delivered|partial_delivery|refused|undeliverable|returned|damaged`',
    `delivery_stop_reference` STRING COMMENT 'The unique reference number for the delivery stop on the carrier route. Used for route optimization and last-mile logistics tracking.',
    `delivery_timestamp` TIMESTAMP COMMENT 'The exact date and time when the delivery was completed and POD was captured. Critical for SLA compliance and dispute resolution.',
    `dispute_filed_flag` BOOLEAN COMMENT 'Indicates whether the customer filed a dispute regarding this delivery (e.g., not received, damaged, incorrect). True if dispute exists, False otherwise.',
    `dispute_resolution_status` STRING COMMENT 'The current status of any delivery dispute. Used for dispute management and resolution tracking.. Valid values are `open|under_review|resolved_customer_favor|resolved_carrier_favor|closed`',
    `gps_accuracy_meters` DECIMAL(18,2) COMMENT 'The accuracy radius of the GPS coordinates in meters. Indicates the precision of the location capture.',
    `id_verification_method` STRING COMMENT 'The method used to verify the recipients identity or age. Used for compliance with age-restricted product delivery regulations.. Valid values are `drivers_license|passport|government_id|digital_id|none`',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this proof of delivery record was last modified. Used for audit trail and change tracking.',
    `notification_channel` STRING COMMENT 'The communication channel used to notify the customer of delivery completion. Used for channel effectiveness analysis.. Valid values are `sms|email|push_notification|in_app|voice_call`',
    `notification_timestamp` TIMESTAMP COMMENT 'The date and time when the delivery completion notification was sent to the customer.',
    `package_condition` STRING COMMENT 'The physical condition of the package as observed and recorded at the time of delivery. Critical for damage claims and carrier accountability.. Valid values are `intact|damaged|opened|wet|crushed|other`',
    `pin_confirmation_code` STRING COMMENT 'The personal identification number (PIN) or confirmation code provided by the recipient to authorize delivery. Used for high-value or secure deliveries.',
    `pod_capture_method` STRING COMMENT 'The technology or device used to capture the proof of delivery. Used for process improvement and technology adoption tracking.. Valid values are `mobile_app|handheld_scanner|tablet|kiosk|web_portal|manual_entry`',
    `recipient_name` STRING COMMENT 'The name of the person who received the delivery. May differ from the original customer if delivery was accepted by an alternate recipient.',
    `recipient_relationship` STRING COMMENT 'The relationship of the recipient to the original customer. Used to validate authorized delivery acceptance. [ENUM-REF-CANDIDATE: customer|household_member|neighbor|building_staff|reception|security|other — 7 candidates stripped; promote to reference product]',
    `signature_captured_flag` BOOLEAN COMMENT 'Indicates whether a physical or electronic signature was captured at delivery. True if signature was obtained, False otherwise.',
    `signature_image_url` STRING COMMENT 'The URL or storage path to the digital signature image file. Used for dispute resolution and carrier compliance verification.',
    `sla_met_flag` BOOLEAN COMMENT 'Indicates whether the delivery met the promised service level agreement (delivery time commitment). True if SLA was met, False if breached.',
    `temperature_at_delivery_celsius` DECIMAL(18,2) COMMENT 'The recorded temperature of the package or delivery environment at the time of delivery, measured in Celsius. Used for cold chain compliance.',
    `temperature_compliant_flag` BOOLEAN COMMENT 'Indicates whether temperature-sensitive shipments remained within required temperature range during delivery. True if compliant, False if breach occurred. Applicable to grocery and pharmaceutical deliveries.',
    `tracking_number` STRING COMMENT 'The carrier-assigned tracking number for the shipment. Used for carrier reconciliation and customer inquiry resolution.',
    CONSTRAINT pk_proof_of_delivery PRIMARY KEY(`proof_of_delivery_id`)
) COMMENT 'Records proof-of-delivery (POD) evidence captured at the point of customer delivery. Captures delivery stop reference, delivery timestamp, recipient name, signature image URL, delivery photo URL, PIN confirmation code, GPS coordinates at delivery, delivery location type (front door, mailbox, neighbor, locker), and POD capture method (mobile app, handheld scanner, kiosk). Critical for dispute resolution, carrier compliance, and customer delivery confirmation.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` (
    `carrier_facility_contract_id` BIGINT COMMENT 'Unique identifier for this carrier-facility service contract record. Primary key.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to the distribution center facility receiving carrier service',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to the carrier master record providing service to this facility',
    `assigned_dock_doors` STRING COMMENT 'Comma-separated list of dock door numbers or identifiers assigned to this carrier at this facility for loading operations.',
    `contract_number` STRING COMMENT 'Business-assigned contract or agreement number for this carrier-facility relationship, used for legal and procurement reference.',
    `contract_status` STRING COMMENT 'Current lifecycle status of this carrier-facility contract indicating whether it is operationally active.',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this carrier-facility contract record was created in the system.',
    `daily_pickup_schedule` STRING COMMENT 'Scheduled pickup times for this carrier at this facility, typically in format HH:MM or multiple times (e.g., 10:00,14:00,18:00), defining when the carrier collects outbound shipments.',
    `effective_date` DATE COMMENT 'Date when this carrier-facility service agreement became active and rates/terms took effect.',
    `expiry_date` DATE COMMENT 'Date when this carrier-facility service agreement expires and requires renewal or renegotiation.',
    `facility_discount_percentage` DECIMAL(18,2) COMMENT 'Additional volume-based discount percentage negotiated specifically for this facility based on shipment volume commitments.',
    `facility_specific_base_rate` DECIMAL(18,2) COMMENT 'Negotiated base shipping rate per pound for this specific carrier-facility combination, potentially different from the carriers standard base rate due to facility volume or regional pricing.',
    `max_daily_volume_packages` STRING COMMENT 'Maximum number of packages this carrier commits to pick up daily from this facility under the service agreement.',
    `priority_rank` STRING COMMENT 'Priority ranking for this carrier at this facility used in carrier selection logic (1=highest priority), allowing facilities to prefer certain carriers based on performance or cost.',
    `rate_tier` STRING COMMENT 'Negotiated rate tier or pricing level for this specific facility, which may differ from the carriers standard rates based on facility volume commitments.',
    `service_levels_enabled` STRING COMMENT 'Comma-separated list or JSON array of service levels enabled for this carrier-facility combination (e.g., ground, two_day, overnight), as not all carrier services may be available at all facilities.',
    `sla_on_time_percentage` DECIMAL(18,2) COMMENT 'Service level agreement percentage for on-time delivery performance that this carrier commits to for shipments originating from this facility.',
    `updated_date` TIMESTAMP COMMENT 'Timestamp when this carrier-facility contract record was last modified.',
    CONSTRAINT pk_carrier_facility_contract PRIMARY KEY(`carrier_facility_contract_id`)
) COMMENT 'This association product represents the contractual service agreement between a carrier and a distribution center facility. It captures facility-specific carrier terms including negotiated rates, service level commitments, pickup schedules, and dock door assignments. Each record links one carrier to one DC facility with attributes that exist only in the context of this specific carrier-facility relationship, enabling multi-carrier operations at each DC and multi-facility service coverage by each carrier.. Existence Justification: In retail distribution operations, carriers provide service to multiple DC facilities across the network, and each DC facility contracts with multiple carriers to ensure service redundancy, cost optimization, and capacity flexibility. The carrier-facility relationship is contractual and operational, with facility-specific negotiated rates, pickup schedules, dock door assignments, service level agreements, and volume commitments that vary by facility based on regional pricing, facility volume, and operational constraints.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ADD CONSTRAINT `fk_fulfillment_shipment_package_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ADD CONSTRAINT `fk_fulfillment_shipment_package_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ADD CONSTRAINT `fk_fulfillment_shipment_package_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ADD CONSTRAINT `fk_fulfillment_shipment_package_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ADD CONSTRAINT `fk_fulfillment_pack_task_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ADD CONSTRAINT `fk_fulfillment_pack_task_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ADD CONSTRAINT `fk_fulfillment_pack_task_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ADD CONSTRAINT `fk_fulfillment_pack_task_pick_task_id` FOREIGN KEY (`pick_task_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`pick_task`(`pick_task_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ADD CONSTRAINT `fk_fulfillment_pack_task_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ADD CONSTRAINT `fk_fulfillment_delivery_route_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ADD CONSTRAINT `fk_fulfillment_delivery_route_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ADD CONSTRAINT `fk_fulfillment_delivery_route_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ADD CONSTRAINT `fk_fulfillment_delivery_stop_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ADD CONSTRAINT `fk_fulfillment_delivery_stop_delivery_route_id` FOREIGN KEY (`delivery_route_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`delivery_route`(`delivery_route_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ADD CONSTRAINT `fk_fulfillment_delivery_stop_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ADD CONSTRAINT `fk_fulfillment_carrier_service_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ADD CONSTRAINT `fk_fulfillment_exception_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ADD CONSTRAINT `fk_fulfillment_exception_fulfillment_line_id` FOREIGN KEY (`fulfillment_line_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_line`(`fulfillment_line_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ADD CONSTRAINT `fk_fulfillment_exception_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ADD CONSTRAINT `fk_fulfillment_exception_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ADD CONSTRAINT `fk_fulfillment_shipment_tracking_event_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ADD CONSTRAINT `fk_fulfillment_shipment_tracking_event_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ADD CONSTRAINT `fk_fulfillment_shipment_tracking_event_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ADD CONSTRAINT `fk_fulfillment_shipment_tracking_event_shipment_package_id` FOREIGN KEY (`shipment_package_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment_package`(`shipment_package_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ADD CONSTRAINT `fk_fulfillment_sla_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ADD CONSTRAINT `fk_fulfillment_sla_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ADD CONSTRAINT `fk_fulfillment_sla_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` ADD CONSTRAINT `fk_fulfillment_carrier_rate_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` ADD CONSTRAINT `fk_fulfillment_carrier_rate_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ADD CONSTRAINT `fk_fulfillment_drop_ship_order_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ADD CONSTRAINT `fk_fulfillment_drop_ship_order_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ADD CONSTRAINT `fk_fulfillment_proof_of_delivery_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ADD CONSTRAINT `fk_fulfillment_proof_of_delivery_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ADD CONSTRAINT `fk_fulfillment_carrier_facility_contract_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`fulfillment` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_retail_v1`.`fulfillment` SET TAGS ('dbx_domain' = 'fulfillment');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `outbound_order_id` SET TAGS ('dbx_business_glossary_term' = 'Outbound Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `price_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Price Zone Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Picker Employee ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `sku_price_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `fulfillment_method` SET TAGS ('dbx_value_regex' = 'ship_from_store|dark_store|distribution_center|bopis|ropis|drop_ship');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `fulfillment_order_number` SET TAGS ('dbx_value_regex' = '^FO[0-9]{10}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `is_gift` SET TAGS ('dbx_business_glossary_term' = 'Is Gift Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `pickup_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'standard|expedited|rush|vip');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `sla_target_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Target Hours');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `total_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Total Weight Kilograms (KG)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ALTER COLUMN `tracking_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10,40}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Source ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `haccp_control_point_id` SET TAGS ('dbx_business_glossary_term' = 'Haccp Control Point Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `handling_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Carton ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `outbound_order_line_id` SET TAGS ('dbx_business_glossary_term' = 'Outbound Order Line Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Picker ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `vendor_item_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Item Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `fulfillment_source_type` SET TAGS ('dbx_value_regex' = 'dc|store|dark_store|vendor|3pl');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `gtin` SET TAGS ('dbx_business_glossary_term' = 'Global Trade Item Number (GTIN)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `gtin` SET TAGS ('dbx_value_regex' = '^[0-9]{14}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `original_sku` SET TAGS ('dbx_business_glossary_term' = 'Original Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `sku` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `substitution_reason_code` SET TAGS ('dbx_value_regex' = 'out_of_stock|discontinued|damaged|customer_request|upgrade|downgrade');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'each|case|pallet|box|pack|unit');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `upc` SET TAGS ('dbx_business_glossary_term' = 'Universal Product Code (UPC)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `upc` SET TAGS ('dbx_value_regex' = '^[0-9]{12}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ALTER COLUMN `weight_unit` SET TAGS ('dbx_value_regex' = 'lb|kg|oz|g');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` SET TAGS ('dbx_subdomain' = 'shipping_delivery');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Identifier');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `environmental_event_id` SET TAGS ('dbx_business_glossary_term' = 'Environmental Event Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Ship-From Node ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `fulfillment_order_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `outbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Shipment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Ship-To Customer ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `carrier_charge_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `declared_value_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `fulfillment_type` SET TAGS ('dbx_value_regex' = 'standard|bopis|ropis|ship_from_store|drop_ship|curbside');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `hazmat_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `height_cm` SET TAGS ('dbx_business_glossary_term' = 'Height in Centimeters (CM)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `length_cm` SET TAGS ('dbx_business_glossary_term' = 'Length in Centimeters (CM)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `ship_from_location_type` SET TAGS ('dbx_business_glossary_term' = 'Ship-From Location Type');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `ship_from_location_type` SET TAGS ('dbx_value_regex' = 'distribution_center|store|dark_store|micro_fulfillment_center|vendor');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `ship_to_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Ship-To Address Line 1');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `ship_to_address_line2` SET TAGS ('dbx_business_glossary_term' = 'Ship-To Address Line 2');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `ship_to_city` SET TAGS ('dbx_business_glossary_term' = 'Ship-To City');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `ship_to_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Ship-To Contact Name');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `ship_to_country_code` SET TAGS ('dbx_business_glossary_term' = 'Ship-To Country Code');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `ship_to_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `ship_to_email_address` SET TAGS ('dbx_business_glossary_term' = 'Ship-To Email Address');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `ship_to_email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `ship_to_phone_number` SET TAGS ('dbx_business_glossary_term' = 'Ship-To Phone Number');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `ship_to_postal_code` SET TAGS ('dbx_business_glossary_term' = 'Ship-To Postal Code');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `ship_to_state_province` SET TAGS ('dbx_business_glossary_term' = 'Ship-To State or Province');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `shipment_number` SET TAGS ('dbx_value_regex' = '^SHP[0-9]{10}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `shipping_cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `total_volume_cubic_meters` SET TAGS ('dbx_business_glossary_term' = 'Total Volume in Cubic Meters');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `total_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Total Weight in Kilograms (KG)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ALTER COLUMN `width_cm` SET TAGS ('dbx_business_glossary_term' = 'Width in Centimeters (CM)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` SET TAGS ('dbx_subdomain' = 'shipping_delivery');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `outbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Shipment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `billable_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Billable Weight (Kilograms)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `contents_summary` SET TAGS ('dbx_business_glossary_term' = 'Package Contents Summary');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `dimensional_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Dimensional Weight (Kilograms)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `height_cm` SET TAGS ('dbx_business_glossary_term' = 'Package Height (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `is_hazmat` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `is_insured` SET TAGS ('dbx_business_glossary_term' = 'Insured Package Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `is_label_printed` SET TAGS ('dbx_business_glossary_term' = 'Label Printed Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `is_manifested` SET TAGS ('dbx_business_glossary_term' = 'Manifested Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `is_sealed` SET TAGS ('dbx_business_glossary_term' = 'Package Sealed Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `is_signature_required` SET TAGS ('dbx_business_glossary_term' = 'Signature Required Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `length_cm` SET TAGS ('dbx_business_glossary_term' = 'Package Length (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `package_sequence` SET TAGS ('dbx_business_glossary_term' = 'Package Sequence Number');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `package_type` SET TAGS ('dbx_value_regex' = 'box|poly_bag|envelope|pallet|crate|tube');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Package Weight (Kilograms)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ALTER COLUMN `width_cm` SET TAGS ('dbx_business_glossary_term' = 'Package Width (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `pick_task_id` SET TAGS ('dbx_business_glossary_term' = 'Pick Task Identifier');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Location ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `outbound_order_id` SET TAGS ('dbx_business_glossary_term' = 'Outbound Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `aisle` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `bay` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `customer_approval_status` SET TAGS ('dbx_value_regex' = 'approved|rejected|pending|not_required');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `exception_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `fulfillment_channel` SET TAGS ('dbx_value_regex' = 'ship_from_store|dark_store|distribution_center|bopis|ropis|curbside');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `original_sku` SET TAGS ('dbx_business_glossary_term' = 'Original Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `original_sku` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `package_type` SET TAGS ('dbx_value_regex' = 'box|envelope|poly_bag|tube|pallet|tote');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `packing_station_code` SET TAGS ('dbx_business_glossary_term' = 'Packing Station ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `packing_station_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,15}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `pick_task_status` SET TAGS ('dbx_business_glossary_term' = 'Task Status');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `quality_check_outcome` SET TAGS ('dbx_business_glossary_term' = 'Quality Check (QC) Outcome');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `quality_check_outcome` SET TAGS ('dbx_value_regex' = 'passed|failed|not_required|pending');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `shelf` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `sku` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `substituted_sku` SET TAGS ('dbx_business_glossary_term' = 'Substituted Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `substituted_sku` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `task_method` SET TAGS ('dbx_value_regex' = 'single_order|batch|zone|wave|cluster');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `task_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `task_type` SET TAGS ('dbx_value_regex' = 'pick|pack|quality_check|value_added_service|replenishment|cycle_count');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'each|case|pallet|box|pack');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `upc` SET TAGS ('dbx_business_glossary_term' = 'Universal Product Code (UPC)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `upc` SET TAGS ('dbx_value_regex' = '^[0-9]{12}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ALTER COLUMN `work_zone` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Packer ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `outbound_order_id` SET TAGS ('dbx_business_glossary_term' = 'Outbound Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `assigned_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Task Assigned Timestamp');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `completed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Task Completed Timestamp');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `exception_code` SET TAGS ('dbx_business_glossary_term' = 'Pack Exception Code');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `exception_notes` SET TAGS ('dbx_business_glossary_term' = 'Pack Exception Notes');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `fulfillment_type` SET TAGS ('dbx_value_regex' = 'standard_ship|bopis|ropis|sfs|dark_store|same_day');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `hazmat_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `pack_duration_seconds` SET TAGS ('dbx_business_glossary_term' = 'Pack Duration (Seconds)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `package_height_cm` SET TAGS ('dbx_business_glossary_term' = 'Package Height (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `package_length_cm` SET TAGS ('dbx_business_glossary_term' = 'Package Length (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `package_type` SET TAGS ('dbx_value_regex' = 'box|poly_mailer|padded_envelope|tube|pallet|tote');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `package_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Package Weight (Kilograms)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `package_width_cm` SET TAGS ('dbx_business_glossary_term' = 'Package Width (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `packing_station_code` SET TAGS ('dbx_business_glossary_term' = 'Packing Station ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `packing_station_code` SET TAGS ('dbx_value_regex' = '^PS-[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `quality_check_status` SET TAGS ('dbx_value_regex' = 'passed|failed|pending|not_required|exception');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `task_number` SET TAGS ('dbx_business_glossary_term' = 'Pack Task Number');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `task_number` SET TAGS ('dbx_value_regex' = '^PKT-[0-9]{8,12}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `task_priority` SET TAGS ('dbx_business_glossary_term' = 'Pack Task Priority');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `task_priority` SET TAGS ('dbx_value_regex' = 'urgent|high|normal|low');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `task_status` SET TAGS ('dbx_business_glossary_term' = 'Pack Task Status');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `task_status` SET TAGS ('dbx_value_regex' = 'assigned|in_progress|completed|quality_hold|exception|cancelled');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Carrier Tracking Number');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `tracking_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10,35}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ALTER COLUMN `void_fill_type` SET TAGS ('dbx_value_regex' = 'air_pillows|bubble_wrap|paper|foam_peanuts|none');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` SET TAGS ('dbx_subdomain' = 'shipping_delivery');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Center ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `outbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Outbound Shipment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Driver ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `safety_inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Inspection Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `actual_distance_km` SET TAGS ('dbx_business_glossary_term' = 'Actual Distance (Kilometers)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `actual_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Actual Duration (Minutes)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `estimated_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Estimated Duration (Minutes)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `hazmat_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `route_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `route_priority` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `route_status` SET TAGS ('dbx_value_regex' = 'planned|assigned|in_progress|completed|partial|cancelled');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `route_type` SET TAGS ('dbx_value_regex' = 'last_mile|ship_from_store|bopis|ropis|dark_store');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `total_distance_km` SET TAGS ('dbx_business_glossary_term' = 'Total Distance (Kilometers)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `total_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Total Volume (Cubic Meters)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `total_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Total Weight (Kilograms)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `vehicle_code` SET TAGS ('dbx_business_glossary_term' = 'Vehicle ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_value_regex' = 'van|truck|bike|scooter|car|cargo_bike');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` SET TAGS ('dbx_subdomain' = 'shipping_delivery');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Driver ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `outbound_order_id` SET TAGS ('dbx_business_glossary_term' = 'Outbound Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `actual_service_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Actual Service Time in Minutes');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `delivery_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address Line 1');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `delivery_address_line2` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address Line 2');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `delivery_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `delivery_state_province` SET TAGS ('dbx_business_glossary_term' = 'Delivery State or Province');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `estimated_service_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Estimated Service Time in Minutes');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `pod_capture_method` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Capture Method');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `pod_capture_method` SET TAGS ('dbx_value_regex' = 'mobile_app|handheld_scanner|kiosk|web_portal|automated_system');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `pod_capture_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Capture Timestamp');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `pod_gps_latitude` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) GPS Latitude');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `pod_gps_longitude` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) GPS Longitude');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `pod_photo_image_url` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Photo Image URL');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `pod_pin_code` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) PIN Code');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `pod_signature_image_url` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Signature Image URL');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `pod_verification_status` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Verification Status');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `pod_verification_status` SET TAGS ('dbx_value_regex' = 'verified|pending_verification|verification_failed|disputed|not_required');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `recipient_phone` SET TAGS ('dbx_business_glossary_term' = 'Recipient Phone Number');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `stop_type` SET TAGS ('dbx_value_regex' = 'customer_delivery|bopis_pickup|ropis_pickup|return_pickup|dark_store_transfer');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ALTER COLUMN `vehicle_code` SET TAGS ('dbx_business_glossary_term' = 'Vehicle ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Identifier');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `certification_id` SET TAGS ('dbx_business_glossary_term' = 'Certification Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `api_integration_flag` SET TAGS ('dbx_business_glossary_term' = 'Application Programming Interface (API) Integration Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `base_rate_per_lb` SET TAGS ('dbx_business_glossary_term' = 'Base Rate Per Pound');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `bopis_ready_flag` SET TAGS ('dbx_business_glossary_term' = 'Buy Online Pick Up In Store (BOPIS) Ready Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `carrier_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|pending_approval');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `carrier_type` SET TAGS ('dbx_value_regex' = 'parcel|ltl|ftl|last_mile|same_day|3pl');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `carrier_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `contact_email` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Email Address');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `contact_name` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Name');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Phone Number');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `cutoff_time_local` SET TAGS ('dbx_value_regex' = '^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `edi_capable_flag` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Capable Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `hazmat_certified_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Certified Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `insurance_coverage_flag` SET TAGS ('dbx_business_glossary_term' = 'Insurance Coverage Available Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `max_height_inches` SET TAGS ('dbx_business_glossary_term' = 'Maximum Height in Inches');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `max_length_inches` SET TAGS ('dbx_business_glossary_term' = 'Maximum Length in Inches');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `max_weight_lbs` SET TAGS ('dbx_business_glossary_term' = 'Maximum Weight in Pounds (lbs)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `max_width_inches` SET TAGS ('dbx_business_glossary_term' = 'Maximum Width in Inches');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Legal Name');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `scac_code` SET TAGS ('dbx_business_glossary_term' = 'Standard Carrier Alpha Code (SCAC)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `scac_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `service_level_ground` SET TAGS ('dbx_business_glossary_term' = 'Ground Service Level Available');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `service_level_overnight` SET TAGS ('dbx_business_glossary_term' = 'Overnight Service Level Available');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `service_level_same_day` SET TAGS ('dbx_business_glossary_term' = 'Same-Day Service Level Available');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `service_level_two_day` SET TAGS ('dbx_business_glossary_term' = 'Two-Day Service Level Available');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `transit_days_zone_1` SET TAGS ('dbx_business_glossary_term' = 'Transit Days for Zone 1');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `transit_days_zone_2` SET TAGS ('dbx_business_glossary_term' = 'Transit Days for Zone 2');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `transit_days_zone_3` SET TAGS ('dbx_business_glossary_term' = 'Transit Days for Zone 3');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `bopis_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Buy Online Pick Up In Store (BOPIS) Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `cutoff_timezone` SET TAGS ('dbx_value_regex' = '^[A-Z]{3,5}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `geographic_restriction_type` SET TAGS ('dbx_value_regex' = 'none|domestic_only|regional|postal_code_list|country_list');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `hazmat_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `insurance_max_value` SET TAGS ('dbx_business_glossary_term' = 'Insurance Maximum Value');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `international_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'International Shipping Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `max_girth_cm` SET TAGS ('dbx_business_glossary_term' = 'Maximum Girth (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `max_height_cm` SET TAGS ('dbx_business_glossary_term' = 'Maximum Height (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `max_length_cm` SET TAGS ('dbx_business_glossary_term' = 'Maximum Length (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `max_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Weight (Kilograms)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `max_width_cm` SET TAGS ('dbx_business_glossary_term' = 'Maximum Width (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `perishable_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Perishable Goods Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `service_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `service_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|seasonal|deprecated');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'ground|express|overnight|same_day|next_day|standard');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `ship_from_store_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Ship From Store (SFS) Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `sla_delivery_guarantee_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Delivery Guarantee Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `transit_days_max` SET TAGS ('dbx_business_glossary_term' = 'Maximum Transit Days');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_service` ALTER COLUMN `transit_days_min` SET TAGS ('dbx_business_glossary_term' = 'Minimum Transit Days');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` SET TAGS ('dbx_subdomain' = 'network_configuration');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for node');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `automation_level` SET TAGS ('dbx_value_regex' = 'manual|semi_automated|fully_automated');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `bopis_enabled` SET TAGS ('dbx_business_glossary_term' = 'Buy Online Pick Up In Store (BOPIS) Enabled');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `hazmat_certified` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Certified');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `node_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `node_status` SET TAGS ('dbx_value_regex' = 'active|inactive|planned|under_construction|temporarily_closed|decommissioned');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `node_type` SET TAGS ('dbx_value_regex' = 'distribution_center|store|dark_store|micro_fulfillment_center|cross_dock|returns_center');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `ropis_enabled` SET TAGS ('dbx_business_glossary_term' = 'Reserve Online Pick Up In Store (ROPIS) Enabled');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `ship_from_store_enabled` SET TAGS ('dbx_business_glossary_term' = 'Ship From Store (SFS) Enabled');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State or Province');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `state_province` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ALTER COLUMN `wms_system_code` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Management System (WMS) System ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `bopis_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'BOPIS (Buy Online Pick Up In Store) Appointment ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `fulfillment_order_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `appointment_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `appointment_status` SET TAGS ('dbx_value_regex' = 'scheduled|ready|picked_up|expired|cancelled|no_show');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `appointment_type` SET TAGS ('dbx_value_regex' = 'BOPIS|ROPIS');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_value_regex' = 'customer_request|out_of_stock|store_closure|system_error|fraud|other');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `check_in_method` SET TAGS ('dbx_business_glossary_term' = 'Check-In Method');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `check_in_method` SET TAGS ('dbx_value_regex' = 'mobile_app|kiosk|associate|phone|walk_in');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `check_in_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Check-In Timestamp');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `customer_email` SET TAGS ('dbx_business_glossary_term' = 'Customer Email Address');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `customer_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `customer_phone` SET TAGS ('dbx_business_glossary_term' = 'Customer Phone Number');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `id_verification_method` SET TAGS ('dbx_value_regex' = 'drivers_license|passport|order_confirmation|photo_id|none');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `parking_spot_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `pickup_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `scheduled_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Pickup Date');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `sla_met_flag` SET TAGS ('dbx_business_glossary_term' = 'SLA (Service Level Agreement) Met Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ALTER COLUMN `sla_target_ready_minutes` SET TAGS ('dbx_business_glossary_term' = 'SLA (Service Level Agreement) Target Ready Minutes');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ALTER COLUMN `exception_id` SET TAGS ('dbx_business_glossary_term' = 'Exception Identifier');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Exception Owner ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ALTER COLUMN `corrective_action_id` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ALTER COLUMN `fulfillment_line_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Order Line ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Membership Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ALTER COLUMN `service_case_id` SET TAGS ('dbx_business_glossary_term' = 'Service Case Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ALTER COLUMN `exception_status` SET TAGS ('dbx_value_regex' = 'open|in_progress|resolved|escalated|cancelled');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ALTER COLUMN `owner_type` SET TAGS ('dbx_business_glossary_term' = 'Exception Owner Type');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ALTER COLUMN `sla_target_resolution_minutes` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Target Resolution Minutes');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` SET TAGS ('dbx_subdomain' = 'shipping_delivery');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ALTER COLUMN `shipment_package_id` SET TAGS ('dbx_business_glossary_term' = 'Package ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ALTER COLUMN `data_source_type` SET TAGS ('dbx_value_regex' = 'carrier_api|edi_214|webhook|manual_entry|scrape');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ALTER COLUMN `event_location_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ALTER COLUMN `event_location_state` SET TAGS ('dbx_business_glossary_term' = 'Event Location State or Province');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Tracking Event Type');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Event Location Latitude');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Event Location Longitude');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ALTER COLUMN `notification_sent_flag` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Sent Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ALTER COLUMN `received_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Data Received Timestamp');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ALTER COLUMN `scan_type` SET TAGS ('dbx_value_regex' = 'automated|manual|mobile|rfid');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ALTER COLUMN `source_record_reference` SET TAGS ('dbx_business_glossary_term' = 'Source System Record ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Carrier Tracking Number');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_tracking_event` ALTER COLUMN `weight_actual_kg` SET TAGS ('dbx_business_glossary_term' = 'Actual Weight in Kilograms');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` SET TAGS ('dbx_subdomain' = 'network_configuration');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `sla_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Identifier');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `applies_to_holidays` SET TAGS ('dbx_business_glossary_term' = 'Applies to Holidays Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `applies_to_weekdays` SET TAGS ('dbx_business_glossary_term' = 'Applies to Weekdays Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `applies_to_weekends` SET TAGS ('dbx_business_glossary_term' = 'Applies to Weekends Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `sla_code` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Code');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `sla_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = 'GLOBAL|NATIONAL|REGIONAL|LOCAL');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `sla_name` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Name');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `node_type` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Node Type');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `node_type` SET TAGS ('dbx_value_regex' = 'STORE|DC|DARK_STORE|MFC|VENDOR|3PL');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `order_channel` SET TAGS ('dbx_value_regex' = 'WEB|MOBILE_APP|IN_STORE|CALL_CENTER|MARKETPLACE|SOCIAL_COMMERCE');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `order_value_max` SET TAGS ('dbx_business_glossary_term' = 'Maximum Order Value');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `order_value_min` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Value');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'CRITICAL|HIGH|MEDIUM|LOW');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `sla_type` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Type');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` ALTER COLUMN `is_hazmat_eligible` SET TAGS ('dbx_business_glossary_term' = 'Is Hazardous Materials (HAZMAT) Eligible');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` ALTER COLUMN `rate_per_kg` SET TAGS ('dbx_business_glossary_term' = 'Rate Per Kilogram');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` ALTER COLUMN `rate_source` SET TAGS ('dbx_value_regex' = 'carrier_api|manual_entry|contract_upload|rate_shop|third_party');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` ALTER COLUMN `rate_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|expired|suspended');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` ALTER COLUMN `rate_type` SET TAGS ('dbx_value_regex' = 'base|negotiated|published|spot|contract');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` ALTER COLUMN `weight_break_max_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight Break Maximum (kg)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_rate` ALTER COLUMN `weight_break_min_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight Break Minimum (kg)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` SET TAGS ('dbx_subdomain' = 'order_execution');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `drop_ship_order_id` SET TAGS ('dbx_business_glossary_term' = 'Drop Ship Order Identifier');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `buyer_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `cost_price_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `vendor_contact_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contact Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `vendor_item_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Item Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `gtin` SET TAGS ('dbx_business_glossary_term' = 'Global Trade Item Number (GTIN)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `ship_to_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Ship To Address Line 1');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `ship_to_address_line2` SET TAGS ('dbx_business_glossary_term' = 'Ship To Address Line 2');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `ship_to_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `ship_to_email` SET TAGS ('dbx_business_glossary_term' = 'Ship To Email Address');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `ship_to_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `ship_to_phone` SET TAGS ('dbx_business_glossary_term' = 'Ship To Phone Number');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `ship_to_state_province` SET TAGS ('dbx_business_glossary_term' = 'Ship To State or Province');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'each|case|pallet|box|pair|set');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `upc` SET TAGS ('dbx_business_glossary_term' = 'Universal Product Code (UPC)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `vendor_po_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Purchase Order (PO) Number');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ALTER COLUMN `vendor_sla_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Vendor Service Level Agreement (SLA) Compliance Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` SET TAGS ('dbx_subdomain' = 'shipping_delivery');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `proof_of_delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Driver ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `outbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Shipment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `delivery_latitude` SET TAGS ('dbx_business_glossary_term' = 'Delivery Location Latitude');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `delivery_longitude` SET TAGS ('dbx_business_glossary_term' = 'Delivery Location Longitude');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `delivery_status` SET TAGS ('dbx_value_regex' = 'delivered|partial_delivery|refused|undeliverable|returned|damaged');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `delivery_stop_reference` SET TAGS ('dbx_business_glossary_term' = 'Delivery Stop Reference Number');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `delivery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Timestamp');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `dispute_filed_flag` SET TAGS ('dbx_business_glossary_term' = 'Delivery Dispute Filed Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `dispute_resolution_status` SET TAGS ('dbx_value_regex' = 'open|under_review|resolved_customer_favor|resolved_carrier_favor|closed');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `gps_accuracy_meters` SET TAGS ('dbx_business_glossary_term' = 'GPS Accuracy in Meters');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `id_verification_method` SET TAGS ('dbx_business_glossary_term' = 'Identification Verification Method');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `id_verification_method` SET TAGS ('dbx_value_regex' = 'drivers_license|passport|government_id|digital_id|none');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `notification_channel` SET TAGS ('dbx_value_regex' = 'sms|email|push_notification|in_app|voice_call');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Timestamp');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `package_condition` SET TAGS ('dbx_business_glossary_term' = 'Package Condition at Delivery');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `package_condition` SET TAGS ('dbx_value_regex' = 'intact|damaged|opened|wet|crushed|other');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `pod_capture_method` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Capture Method');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `pod_capture_method` SET TAGS ('dbx_value_regex' = 'mobile_app|handheld_scanner|tablet|kiosk|web_portal|manual_entry');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `recipient_name` SET TAGS ('dbx_business_glossary_term' = 'Recipient Full Name');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `recipient_relationship` SET TAGS ('dbx_business_glossary_term' = 'Recipient Relationship to Customer');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `sla_met_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Met Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `temperature_at_delivery_celsius` SET TAGS ('dbx_business_glossary_term' = 'Temperature at Delivery in Celsius');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `temperature_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'Temperature Compliance Flag');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Carrier Tracking Number');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` SET TAGS ('dbx_association_edges' = 'fulfillment.carrier,supplychain.dc_facility');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Facility Contract - Dc Facility Id');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Facility Contract - Fulfillment Carrier Id');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Record Created Date');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Effective Date');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Expiry Date');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ALTER COLUMN `facility_discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Facility Volume Discount');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ALTER COLUMN `facility_specific_base_rate` SET TAGS ('dbx_business_glossary_term' = 'Facility-Specific Base Rate');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ALTER COLUMN `max_daily_volume_packages` SET TAGS ('dbx_business_glossary_term' = 'Maximum Daily Package Volume');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ALTER COLUMN `priority_rank` SET TAGS ('dbx_business_glossary_term' = 'Carrier Priority Rank');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ALTER COLUMN `rate_tier` SET TAGS ('dbx_business_glossary_term' = 'Facility Rate Tier');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ALTER COLUMN `service_levels_enabled` SET TAGS ('dbx_business_glossary_term' = 'Enabled Service Levels');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ALTER COLUMN `sla_on_time_percentage` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery SLA');
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ALTER COLUMN `updated_date` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Date');
