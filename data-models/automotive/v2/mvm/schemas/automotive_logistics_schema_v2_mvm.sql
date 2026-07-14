-- Schema for Domain: logistics | Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-14 04:30:40

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`logistics` COMMENT 'Outbound logistics and distribution including finished vehicle transportation, vehicle storage yards, compound operations, carrier management, and delivery scheduling. Manages vehicle shipment from plant to dealer, rail/truck/vessel logistics, port processing, last-mile delivery, and CKD/SKD kit logistics. Tracks in-transit inventory, delivery lead times, transportation costs, carrier performance, and OTD metrics. Includes export/import operations for global distribution.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`shipment` (
    `shipment_id` BIGINT COMMENT 'System-generated unique identifier for each outbound vehicle shipment.',
    `carrier_id` BIGINT COMMENT 'System identifier for the carrier entity.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Required for Shipment Delivery Performance Report linking each shipment to its destination dealership; enables OTD and cost tracking per dealer.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: Inbound shipment scheduling and warehouse receiving planning require knowing which warehouse a shipment is destined for. Automotive parts distribution shipments target specific warehouses; this link e',
    `fleet_contract_id` BIGINT COMMENT 'Foreign key linking to sales.fleet_contract. Business justification: Fleet contracts specify dedicated delivery schedules and SLA terms. Linking shipment to fleet_contract enables fleet delivery performance reporting (committed vs. actual volume shipped), SLA complianc',
    `lane_id` BIGINT COMMENT 'Foreign key linking to logistics.lane. Business justification: A shipment travels on a defined logistics lane (origin-destination pair). Linking shipment to lane normalizes the origin-destination routing, enables lane-level shipment volume analysis, freight cost ',
    `parts_order_id` BIGINT COMMENT 'Foreign key linking to aftersales.aftersales_parts_order. Business justification: Parts replenishment logistics: when a dealer/service center raises an aftersales parts order, a shipment is created to fulfill it. Logistics planners and service operations teams track which shipment ',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Required for freight cost allocation per shipment in the Transportation Cost Allocation Report.',
    `production_order_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_order. Business justification: Order fulfillment shipping links each shipment to its originating production order for traceability and cost accounting.',
    `replenishment_order_id` BIGINT COMMENT 'Foreign key linking to inventory.replenishment_order. Business justification: Replenishment orders trigger inbound shipments in automotive parts supply chains. Linking shipment to replenishment_order enables replenishment fulfillment tracking, lead-time actuals vs. promised del',
    `stock_transfer_order_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_transfer_order. Business justification: Inter-plant parts transfers in automotive generate both a stock_transfer_order and a shipment to execute it. Linking shipment to stock_transfer_order enables transfer execution tracking, on-time deliv',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Required for Shipment Tracking Report to associate each shipment with the primary vehicle asset for warranty and depreciation.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Order fulfillment tracking report ties each physical shipment to its originating sales vehicle order, essential for delivery status and revenue recognition.',
    `vin_registry_id` BIGINT COMMENT 'Identifier of the truck, rail car, or vessel used for the shipment.',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Real timestamp when the shipment was received at the destination.',
    `actual_departure_timestamp` TIMESTAMP COMMENT 'Real timestamp when the shipment left the origin plant.',
    `compliance_status` STRING COMMENT 'Current compliance verification result for the shipment.. Valid values are `compliant|non_compliant|pending|exempt`',
    `container_number` STRING COMMENT 'Standard container identification number when applicable.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the shipment record was first created in the lakehouse.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for monetary amounts.. Valid values are `^[A-Z]{3}$`',
    `customs_document_number` STRING COMMENT 'Reference number for customs clearance documents.',
    `delay_reason` STRING COMMENT 'Explanation for any delay beyond the planned arrival.',
    `destination_location` STRING COMMENT 'Geographic location (city) of the destination dealer or yard.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Any discount applied to the freight cost.',
    `export_import_flag` BOOLEAN COMMENT 'Indicates whether the shipment is an export, import, or domestic movement.',
    `freight_cost` DECIMAL(18,2) COMMENT 'Gross transportation cost before discounts or adjustments.',
    `hazardous_material_flag` BOOLEAN COMMENT 'True if the shipment contains hazardous goods.',
    `incoterms_code` STRING COMMENT 'International commercial term governing responsibilities and costs.. Valid values are `EXW|FCA|CPT|CIP|DAP|DDP`',
    `load_type` STRING COMMENT 'Classification of the shipment load.. Valid values are `full|partial|hazardous|refrigerated|standard`',
    `net_cost` DECIMAL(18,2) COMMENT 'Final freight cost after discounts and adjustments.',
    `number_of_units` STRING COMMENT 'Count of individual vehicles or kits included in the shipment.',
    `origin_location` STRING COMMENT 'Geographic location (city) of the origin plant.',
    `origin_plant_code` STRING COMMENT 'Identifier of the manufacturing plant where the shipment originates.',
    `otd_flag` BOOLEAN COMMENT 'True if the shipment arrived on or before the planned arrival date.',
    `planned_arrival_date` DATE COMMENT 'Estimated date the shipment should arrive at the destination.',
    `planned_departure_date` DATE COMMENT 'Scheduled date for shipment departure from the origin plant.',
    `shipment_number` STRING COMMENT 'Business-visible shipment number assigned by SAP SD for tracking and reference.',
    `shipment_status` STRING COMMENT 'Current lifecycle status of the shipment.. Valid values are `planned|in_transit|delivered|cancelled|exception`',
    `temperature_control_flag` BOOLEAN COMMENT 'True if the shipment requires temperature‑controlled transport.',
    `tracking_url` STRING COMMENT 'Web link to real‑time shipment tracking information.',
    `transport_mode` STRING COMMENT 'Mode of transportation used for the shipment.. Valid values are `rail|truck|vessel|ckd|skd|air`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the shipment record.',
    `vin_list` STRING COMMENT 'List of VINs for all vehicles in the shipment, separated by commas.',
    `volume_cbm` DECIMAL(18,2) COMMENT 'Total cargo volume of the shipment in cubic meters.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Gross weight of the shipment in kilograms.',
    CONSTRAINT pk_shipment PRIMARY KEY(`shipment_id`)
) COMMENT 'Core master record for each outbound vehicle shipment from plant to dealer or distribution point. Captures shipment origin (plant/compound), destination (dealer/port/yard), transport mode (rail, truck, vessel, CKD/SKD), shipment status, planned and actual departure/arrival dates, OTD tracking, and associated VINs. Primary operational entity for finished vehicle logistics. Sourced from SAP SD outbound delivery and MES traceability.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` (
    `shipment_leg_id` BIGINT COMMENT 'Unique surrogate key for each shipment leg record.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: Multi‑modal shipment leg tracking requires a FK to the carrier entity for each leg.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Inbound parts logistics requires knowing the exact storage location (aisle/rack/bin) where a shipment legs cargo will be putaway. Automotive warehouse management depends on this link for dock-to-stoc',
    `goods_movement_id` BIGINT COMMENT 'Foreign key linking to inventory.goods_movement. Business justification: Enables Shipment Leg Cost Allocation: reconciles each logistics leg with the corresponding inventory goods movement for cost analysis.',
    `shipment_id` BIGINT COMMENT 'Identifier of the parent shipment (transaction header) to which this leg belongs.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Each shipment leg carries specific SKUs (parts/components). Customs declarations, hazmat compliance, and temperature control requirements are SKU-specific and must be validated at the leg level. Autom',
    `vehicle_compound_id` BIGINT COMMENT 'Foreign key linking to logistics.vehicle_compound. Business justification: A shipment leg represents a discrete movement segment that typically originates from or terminates at a vehicle compound, port, or staging area. Linking shipment_leg to vehicle_compound normalizes the',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Allows detailed Shipment Leg analysis tying each leg to the VIN master record for emissions, fuel consumption, and compliance reporting.',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Real‑time arrival date‑time recorded by carrier or IoT device.',
    `actual_departure_timestamp` TIMESTAMP COMMENT 'Real‑time departure date‑time recorded by carrier or IoT device.',
    `container_code` STRING COMMENT 'Identifier of the shipping container or trailer used for the leg.',
    `cost_amount` DECIMAL(18,2) COMMENT 'Monetary cost incurred for this leg (freight, duty, handling, etc.).',
    `cost_currency` STRING COMMENT 'Three‑letter ISO 4217 currency code for the leg cost.. Valid values are `USD|EUR|JPY|CNY|GBP`',
    `cost_type` STRING COMMENT 'Category of cost represented by cost_amount.. Valid values are `freight|duty|tax|handling`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the shipment leg record was created in the system.',
    `customs_document_number` STRING COMMENT 'Reference number of the customs clearance document for cross‑border legs.',
    `customs_status` STRING COMMENT 'Current status of customs clearance for the leg.. Valid values are `pending|cleared|rejected`',
    `delay_reason` STRING COMMENT 'Free‑text description of why a leg is delayed, if applicable.',
    `distance_km` DECIMAL(18,2) COMMENT 'Physical distance covered in this leg, measured in kilometers.',
    `emissions_kg_co2` DECIMAL(18,2) COMMENT 'Estimated carbon dioxide emissions for the leg.',
    `fuel_consumption_liters` DECIMAL(18,2) COMMENT 'Total fuel used by the vehicle during the leg.',
    `handling_instructions` STRING COMMENT 'Special handling notes for the cargo on this leg.',
    `hazardous_material_flag` BOOLEAN COMMENT 'True if the leg carries hazardous materials.',
    `hazardous_material_type` STRING COMMENT 'Classification of hazardous material (e.g., flammable, corrosive).',
    `leg_sequence` STRING COMMENT 'Ordinal position of the leg within the multi‑modal shipment.',
    `leg_status` STRING COMMENT 'Current operational status of the leg.. Valid values are `planned|in_transit|arrived|delayed|cancelled`',
    `load_type` STRING COMMENT 'Classification of cargo load for the leg.. Valid values are `full|less_than_truckload|partial`',
    `odometer_end` BIGINT COMMENT 'Vehicle odometer reading at the end of the leg (kilometers).',
    `odometer_start` BIGINT COMMENT 'Vehicle odometer reading at the start of the leg (kilometers).',
    `planned_arrival_timestamp` TIMESTAMP COMMENT 'Scheduled arrival date‑time for the leg.',
    `planned_departure_timestamp` TIMESTAMP COMMENT 'Scheduled departure date‑time for the leg.',
    `quantity` STRING COMMENT 'Number of individual vehicles or units moved in this leg.',
    `seal_number` STRING COMMENT 'Security seal identifier applied to containers or trailers.',
    `temperature_control_required` BOOLEAN COMMENT 'Indicates whether the cargo requires temperature‑controlled transport.',
    `temperature_max_c` DECIMAL(18,2) COMMENT 'Maximum temperature setting for the leg when temperature control is required.',
    `temperature_min_c` DECIMAL(18,2) COMMENT 'Minimum temperature setting for the leg when temperature control is required.',
    `tracking_number` STRING COMMENT 'Carrier‑provided tracking identifier for the leg.',
    `transport_mode` STRING COMMENT 'Mode of transport used for this leg (e.g., truck, rail, ship, air, pipeline).. Valid values are `truck|rail|ship|air|pipeline`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the shipment leg record.',
    `volume_cubic_meters` DECIMAL(18,2) COMMENT 'Total cargo volume for the leg, measured in cubic meters.',
    `weight_tons` DECIMAL(18,2) COMMENT 'Total weight of cargo transported on this leg, expressed in metric tons.',
    CONSTRAINT pk_shipment_leg PRIMARY KEY(`shipment_leg_id`)
) COMMENT 'Individual transport leg within a multi-modal shipment, representing a discrete movement segment (e.g., plant to rail yard, rail yard to port, port to dealer compound). Tracks leg sequence, transport mode, carrier assignment, origin/destination facility, planned and actual departure/arrival timestamps, distance, leg-level status, and mode-specific details (rail car number/type for rail legs, vessel name/IMO/voyage for ocean legs). After merges, this product also carries rail car assignment details and vessel voyage references for their respective transport modes. Enables end-to-end multi-modal visibility for each VIN or batch.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` (
    `vehicle_transport_order_id` BIGINT COMMENT 'Primary key for vehicle_transport_order',
    `carrier_id` BIGINT COMMENT 'Identifier of the logistics carrier responsible for the shipment.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Needed for Transport Order Execution Dashboard to associate each order with the receiving dealership; supports dealer‑level on‑time delivery metrics.',
    `lane_id` BIGINT COMMENT 'Foreign key linking to logistics.lane. Business justification: A vehicle_transport_order is issued for movement on a specific logistics lane. Linking vehicle_transport_order to lane normalizes the routing reference, enables lane-level transport order analysis, co',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant where the vehicles are shipped from.',
    `production_schedule_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_schedule. Business justification: Outbound logistics capacity planning: automotive logistics teams create vehicle transport orders directly from production schedules (S&OP process) to pre-book car carriers and rail slots. This FK enab',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: A transport order represents the execution of a shipment; linking it to the parent shipment enables traceability of cost and status.',
    `vehicle_allocation_id` BIGINT COMMENT 'Foreign key linking to dealer.vehicle_allocation. Business justification: Transport order fulfillment of dealer allocation: OEM logistics executes transport orders to fulfill specific vehicle allocations. This FK supports allocation-to-transport-order matching, delivery con',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Transport planning aligns with the specific sales vehicle order to ensure correct routing, timing, and cost allocation.',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Timestamp when the shipment was actually received at the destination.',
    `carrier_contact` STRING COMMENT 'Primary phone number for the carriers dispatch desk.',
    `compliance_regulation_code` STRING COMMENT 'Code of the regulatory requirement applicable to the shipment (e.g., IATF, EPA).',
    `confirmed_pickup_date` DATE COMMENT 'Date the carrier confirmed for vehicle pickup.',
    `container_type` STRING COMMENT 'Type of container or trailer used for the shipment (e.g., flatbed, container, roll‑on/roll‑off).',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 code of the currency used for the transport cost.. Valid values are `USD|EUR|JPY|CNY|GBP|CAD`',
    `customs_declaration_number` STRING COMMENT 'Identifier of the customs declaration for cross‑border shipments.',
    `delivery_date` DATE COMMENT 'Planned date for delivery to the destination dealer.',
    `distance_km` DECIMAL(18,2) COMMENT 'Total distance in kilometers for the shipment route.',
    `emission_co2_kg` DECIMAL(18,2) COMMENT 'Estimated CO₂ emissions for the shipment based on distance and vehicle type.',
    `estimated_arrival_timestamp` TIMESTAMP COMMENT 'System‑estimated timestamp when the shipment is expected to arrive at the destination.',
    `export_import_flag` BOOLEAN COMMENT 'Indicates whether the shipment is an export or import movement.',
    `fuel_type` STRING COMMENT 'Dominant fuel type of the vehicles being shipped.. Valid values are `diesel|gasoline|electric|hybrid`',
    `is_expedited` BOOLEAN COMMENT 'True if the shipment is marked for expedited handling.',
    `is_hazardous` BOOLEAN COMMENT 'True if the shipment contains hazardous materials requiring special compliance.',
    `notes` STRING COMMENT 'Free‑form notes entered by logistics planners.',
    `on_time_delivery_flag` BOOLEAN COMMENT 'Indicates whether the shipment was delivered within the agreed on‑time window.',
    `order_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the transport order was initially created in the system.',
    `order_number` STRING COMMENT 'External business identifier assigned to the transport order by the logistics system.',
    `order_status` STRING COMMENT 'Current lifecycle state of the transport order.. Valid values are `draft|open|confirmed|in_transit|delivered|cancelled`',
    `origin_compound` STRING COMMENT 'Name of the storage yard or compound where vehicles are staged before pickup.',
    `priority` STRING COMMENT 'Business priority assigned to the transport order.. Valid values are `low|medium|high|critical`',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when this record was first captured for audit purposes.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to this record.',
    `requested_pickup_date` DATE COMMENT 'Date the shipper requested the carrier to pick up the vehicles.',
    `shipping_instructions` STRING COMMENT 'Special handling or routing instructions for the carrier.',
    `tracking_number` STRING COMMENT 'Tracking number provided by the carrier for real‑time shipment visibility.',
    `transport_cost_gross` DECIMAL(18,2) COMMENT 'Total gross cost charged by the carrier before taxes and discounts.',
    `transport_cost_net` DECIMAL(18,2) COMMENT 'Net amount payable to the carrier after taxes and discounts.',
    `transport_cost_tax` DECIMAL(18,2) COMMENT 'Tax component of the transport cost.',
    `transport_mode` STRING COMMENT 'Mode of transportation used for the shipment.. Valid values are `truck|rail|vessel|air`',
    `vehicle_count` STRING COMMENT 'Number of vehicles included in this transport order.',
    `vin_list` STRING COMMENT 'Comma‑separated list of VINs for the vehicles being shipped.',
    `weight_tons` DECIMAL(18,2) COMMENT 'Total weight of all vehicles in the shipment.',
    CONSTRAINT pk_vehicle_transport_order PRIMARY KEY(`vehicle_transport_order_id`)
) COMMENT 'Transport order issued to a carrier for the movement of finished vehicles. Captures order number, issuing plant, carrier reference, transport mode, vehicle count, VIN list, origin compound, destination, requested pickup date, confirmed pickup date, and order status. Represents the contractual instruction to move vehicles and is the primary document linking shipments to carrier execution. Sourced from SAP TM or SAP SD.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`carrier` (
    `carrier_id` BIGINT COMMENT 'System-generated unique identifier for the carrier record.',
    `address_line1` STRING COMMENT 'First line of the carriers primary business address.',
    `address_line2` STRING COMMENT 'Second line of the carriers primary business address (optional).',
    `average_cost_per_mile` DECIMAL(18,2) COMMENT 'Average transportation cost incurred per mile for this carrier.',
    `average_on_time_delivery_pct` DECIMAL(18,2) COMMENT 'Average percentage of shipments delivered on or before the promised delivery date.',
    `carrier_status` STRING COMMENT 'Current operational status of the carrier within the logistics network.. Valid values are `active|inactive|suspended|terminated|pending`',
    `carrier_type` STRING COMMENT 'Business classification of the carrier entity.. Valid values are `carrier|logistics_provider|freight_forwarder|3pl|4pl`',
    `city` STRING COMMENT 'City of the carriers primary business address.',
    `contact_email` STRING COMMENT 'Email address for the carriers primary contact.. Valid values are `^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$`',
    `contact_name` STRING COMMENT 'Name of the primary contact person for the carrier.',
    `contact_phone` STRING COMMENT 'Telephone number for the carriers primary contact.',
    `contract_end_date` DATE COMMENT 'Expiration date of the carriers master service agreement (null if open‑ended).',
    `contract_reference` STRING COMMENT 'External reference identifier for the carriers master service agreement.',
    `contract_start_date` DATE COMMENT 'Effective start date of the carriers master service agreement.',
    `country` STRING COMMENT 'Three‑letter ISO country code of the carriers primary business address.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the carrier record was first created in the system.',
    `effective_from` DATE COMMENT 'Date from which the carrier record is considered active for reporting.',
    `effective_until` DATE COMMENT 'Date after which the carrier record is no longer active (null if indefinite).',
    `environmental_certification` STRING COMMENT 'Environmental compliance certifications held by the carrier.. Valid values are `ISO14001|EPA|CARB|None`',
    `equipment_type` STRING COMMENT 'Main type of equipment the carrier uses for shipments.. Valid values are `truck|railcar|vessel|aircraft|intermodal_container`',
    `fleet_size` STRING COMMENT 'Number of transport units (e.g., trucks, railcars) owned or operated by the carrier.',
    `iatf_compliance_status` STRING COMMENT 'Current IATF 16949 quality‑management compliance status of the carrier.. Valid values are `compliant|non_compliant|pending`',
    `insurance_policy_number` STRING COMMENT 'Policy number of the carriers liability insurance.',
    `insurance_provider` STRING COMMENT 'Name of the insurance company covering the carriers operations.',
    `last_audit_date` DATE COMMENT 'Date of the most recent compliance or safety audit performed on the carrier.',
    `carrier_name` STRING COMMENT 'Legal name of the transport carrier as registered with authorities.',
    `notes` STRING COMMENT 'Free‑form field for any supplemental information about the carrier.',
    `operating_regions` STRING COMMENT 'Geographic regions (e.g., continents, countries) where the carrier provides service.',
    `performance_rating` DECIMAL(18,2) COMMENT 'Overall performance score (0‑5) derived from on‑time delivery, safety, and cost metrics.',
    `postal_code` STRING COMMENT 'Postal/ZIP code of the carriers primary business address.',
    `safety_rating` STRING COMMENT 'Safety performance rating based on regulatory audits and incident history.. Valid values are `A|B|C|D|E|F`',
    `scac_code` STRING COMMENT 'Four‑letter code uniquely identifying the carrier in North American logistics.. Valid values are `^[A-Z]{4}$`',
    `state` STRING COMMENT 'State or province of the carriers primary business address.',
    `tax_identifier` STRING COMMENT 'Government‑issued tax identifier for the carrier.',
    `tier` STRING COMMENT 'Strategic tier assigned to the carrier based on volume, reliability, and strategic importance.. Valid values are `tier1|tier2|tier3|tier4`',
    `transport_modes` STRING COMMENT 'Transport modes the carrier is authorized to operate.. Valid values are `road|rail|vessel|air|intermodal`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the carrier record.',
    `website` STRING COMMENT 'Public website URL of the carrier.',
    CONSTRAINT pk_carrier PRIMARY KEY(`carrier_id`)
) COMMENT 'Master record for transport carriers (road haulers, rail operators, ocean shipping lines, port logistics providers) engaged for finished vehicle and CKD/SKD kit logistics. Captures carrier legal name, SCAC code, DOT number, transport modes supported, operating regions, contract reference, insurance certificate details, IATF 16949 compliance status, carrier tier classification, and performance rating. SSOT for carrier identity within the logistics domain. Referenced by transport orders, shipment legs, freight invoices, damage claims, and rate contracts.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` (
    `vehicle_compound_id` BIGINT COMMENT 'Unique identifier for the vehicle compound (yard, port, or regional staging area).',
    `plant_id` BIGINT COMMENT 'add column plant_id (BIGINT) with FK to manufacturing.plant.plant_id - vehicle compounds are typically co-located with or serve specific manufacturing plants and need this linkage for yard management',
    `address_line1` STRING COMMENT 'Primary street address of the compound.',
    `address_line2` STRING COMMENT 'Secondary address information (e.g., suite, building).',
    `capacity_units` STRING COMMENT 'Maximum number of vehicles the compound can store.',
    `city` STRING COMMENT 'City where the compound is located.',
    `compliance_certifications` STRING COMMENT 'Comma‑separated list of certifications (e.g., ISO‑9001, IATF‑16949) held by the compound.',
    `compound_code` STRING COMMENT 'Unique business code used to reference the compound in operational systems.',
    `compound_type` STRING COMMENT 'Classification of the compound (e.g., plant yard, port yard, regional distribution center, dealer preparation site).. Valid values are `plant|port|regional|dealer_prep`',
    `country_code` STRING COMMENT 'Three‑letter ISO country code where the compound resides.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the compound record was first created in the system.',
    `current_occupancy` STRING COMMENT 'Current number of vehicles stored in the compound.',
    `effective_from` DATE COMMENT 'Date when the compound became operational.',
    `effective_until` DATE COMMENT 'Date when the compound is scheduled to cease operations (null if open‑ended).',
    `is_pdi_capable` BOOLEAN COMMENT 'Indicates whether the compound can perform Pre‑Delivery Inspection (PDI) on vehicles.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent safety or compliance inspection.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude of the compound (decimal degrees).',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude of the compound (decimal degrees).',
    `manager_email` STRING COMMENT 'Contact email address for the compound operator/manager.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `manager_phone` STRING COMMENT 'Contact phone number for the compound operator/manager.. Valid values are `^[+]?d{7,15}$`',
    `vehicle_compound_name` STRING COMMENT 'Human‑readable name of the storage compound.',
    `notes` STRING COMMENT 'Free‑form notes or remarks about the compound.',
    `operator_name` STRING COMMENT 'Name of the person or organization responsible for day‑to‑day operations of the compound.',
    `otd_target_percentage` DECIMAL(18,2) COMMENT 'Target percentage for on‑time delivery performance for shipments originating from this compound.',
    `postal_code` STRING COMMENT 'Postal/ZIP code of the compound.',
    `region_code` STRING COMMENT 'Internal code representing the broader geographic region (e.g., NA, EU, APAC).',
    `security_level` STRING COMMENT 'Security classification of the compound (low, medium, high).. Valid values are `low|medium|high`',
    `state_province` STRING COMMENT 'State or province of the compound location.',
    `storage_area_sqft` DECIMAL(18,2) COMMENT 'Total floor area of the compound in square feet.',
    `temperature_controlled` BOOLEAN COMMENT 'Indicates whether the compound maintains temperature‑controlled storage.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the compound record.',
    `vehicle_compound_status` STRING COMMENT 'Current operational status of the compound.. Valid values are `active|inactive|maintenance|closed`',
    `waste_handling_capability` BOOLEAN COMMENT 'Indicates whether the compound is equipped to handle hazardous waste.',
    CONSTRAINT pk_vehicle_compound PRIMARY KEY(`vehicle_compound_id`)
) COMMENT 'Master record for vehicle storage compounds, yards, and staging areas used in the outbound logistics network (plant yards, rail yards, port compounds, regional distribution centers). Captures compound name, location, type (plant/port/regional/dealer prep), storage capacity (units), current occupancy, operator, PDI capability flag, and compound status. Enables compound capacity planning and in-transit inventory tracking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` (
    `compound_movement_id` BIGINT COMMENT 'Surrogate primary key for the compound movement record.',
    `carrier_id` BIGINT COMMENT 'Unique identifier for the carrier.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to customer.connected_vehicle. Business justification: Compound PDI operations require triggering OTA activation, telematics status checks, and connectivity readiness for connected vehicles. The plain-text vin column is a denormalization of the connecte',
    `dealership_id` BIGINT COMMENT 'Identifier of the employee who performed the movement.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: compound_movement.destination_zone is a plain-text denormalization of a storage_location. Replacing it with a proper FK enables precise intra-compound inventory positioning, supports AGV routing to sp',
    `finished_vehicle_stock_id` BIGINT COMMENT 'Foreign key linking to inventory.finished_vehicle_stock. Business justification: Compound movements physically relocate finished vehicles within or between compounds, directly changing their stock location. Linking compound_movement to finished_vehicle_stock enables real-time fini',
    `plant_id` BIGINT COMMENT 'Identifier of the employee who performed the movement.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: A compound movement (vehicle arriving at or departing from a yard/compound) is triggered by an inbound or outbound shipment. Linking compound_movement to shipment enables full traceability of which sh',
    `vehicle_compound_id` BIGINT COMMENT 'Foreign key linking to logistics.vehicle_compound. Business justification: Compound movements occur within a vehicle compound; adding vehicle_compound_id links movements to their compound.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Compound movements (PDI staging, zone transfers) are triggered by vehicle orders with committed delivery dates. Operations teams prioritize compound movements by order delivery commitments. No existin',
    `vehicle_transport_order_id` BIGINT COMMENT 'Foreign key linking to logistics.vehicle_transport_order. Business justification: compound_movement already carries transport_order_number as a STRING reference to vehicle_transport_order.order_number. Replacing this with a proper FK vehicle_transport_order_id normalizes the relati',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Recorded arrival time at the destination zone.',
    `compound_movement_status` STRING COMMENT 'Current lifecycle status of the movement.. Valid values are `pending|in_progress|completed|cancelled`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the record was first created in the system.',
    `delay_minutes` STRING COMMENT 'Minutes of delay between ETA and actual arrival.',
    `estimated_arrival_timestamp` TIMESTAMP COMMENT 'Expected arrival time at the destination zone.',
    `is_ota_capable` BOOLEAN COMMENT 'Indicates if the vehicle supports over‑the‑air updates.',
    `load_quantity` STRING COMMENT 'Number of units moved in this transaction (typically 1).',
    `movement_reference` STRING COMMENT 'External reference number used by logistics to identify the movement transaction.',
    `movement_timestamp` TIMESTAMP COMMENT 'Date and time when the movement event occurred.',
    `movement_type` STRING COMMENT 'Indicates whether the vehicle is entering, leaving, or being transferred within the compound.. Valid values are `inbound|outbound|internal_transfer`',
    `notes` STRING COMMENT 'Free‑text field for additional remarks about the movement.',
    `odometer_reading_km` STRING COMMENT 'Vehicle odometer reading at movement time.',
    `origin_zone` STRING COMMENT 'Yard or bay where the vehicle originated.',
    `priority_level` STRING COMMENT 'Priority assigned to the movement for scheduling purposes.. Valid values are `low|medium|high|critical`',
    `temperature_c` DECIMAL(18,2) COMMENT 'Temperature in the yard at the time of movement.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `vehicle_type` STRING COMMENT 'Classification of the vehicle model.. Valid values are `sedan|suv|truck|ev|hybrid`',
    `weight_kg` DECIMAL(18,2) COMMENT 'Weight of the vehicle at the time of movement.',
    CONSTRAINT pk_compound_movement PRIMARY KEY(`compound_movement_id`)
) COMMENT 'Transactional record of a vehicles physical movement into, within, or out of a compound or yard. Captures VIN, movement type (inbound/outbound/internal transfer), origin bay/zone, destination bay/zone, movement timestamp, operator ID, and associated transport order. Provides granular yard management traceability and supports compound throughput analysis.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` (
    `in_transit_inventory_id` BIGINT COMMENT 'Surrogate primary key for the in-transit inventory record.',
    `aftersales_service_appointment_id` BIGINT COMMENT 'Foreign key linking to aftersales.aftersales_service_appointment. Business justification: Parts-to-appointment scheduling: parts ordered for a specific service appointment are tracked in transit against that appointment. Service advisors use this to confirm parts availability before the cu',
    `carrier_id` BIGINT COMMENT 'FK to logistics.carrier',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to customer.connected_vehicle. Business justification: In‑transit inventory dashboard tracks connectivity; linking VIN to connected_vehicle enables real‑time OTA updates and status monitoring.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: When vehicles are shipped directly to end‑customers, tracking the recipient party is required for delivery confirmation, warranty activation, and service scheduling.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: In-transit inventory must be pre-assigned to a destination storage location for receiving and putaway planning. Automotive inbound logistics teams use this to pre-stage dock doors, allocate warehouse ',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: In‑transit inventory holding costs are allocated to a cost center for cost of goods sold calculation.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer receiving the vehicle.',
    `production_order_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_order. Business justification: In‑transit inventory reports tie each in‑transit record to its originating production order for cost allocation and visibility.',
    `shipment_id` BIGINT COMMENT 'Unique business identifier for the vehicle shipment.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: In‑Transit Inventory Visibility report needs SKU to show vehicle configuration while in transit.',
    `stock_transfer_order_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_transfer_order. Business justification: In-transit inventory executing an inter-plant stock transfer must reference the originating stock_transfer_order for inventory reconciliation. Automotive supply chain controllers use this link to conf',
    `vehicle_allocation_id` BIGINT COMMENT 'Foreign key linking to dealer.vehicle_allocation. Business justification: Allocation-to-delivery tracking process: OEMs and dealers monitor inbound allocated vehicles against specific allocation records. Linking in_transit_inventory to vehicle_allocation enables dealer port',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: In‑transit inventory status is reported per sales order to provide customers with accurate ETA and inventory visibility.',
    `vehicle_transport_order_id` BIGINT COMMENT 'Foreign key linking to logistics.vehicle_transport_order. Business justification: in_transit_inventory tracks vehicles currently moving between plant and dealer. Each in-transit vehicle is governed by a vehicle_transport_order issued to a carrier. Linking in_transit_inventory to ve',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Needed for Real‑Time In‑Transit Inventory report to associate each inventory record with the master VIN record for compliance and warranty tracking.',
    `actual_arrival_date` DATE COMMENT 'Date the vehicle actually arrived at the destination (if arrived).',
    `carrier_scac` STRING COMMENT 'Standard carrier code used for tracking and billing.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the in‑transit record was first created.',
    `current_location` STRING COMMENT 'Last known location of the vehicle while in transit.',
    `customs_document_number` STRING COMMENT 'Reference number for customs clearance documentation.',
    `customs_status` STRING COMMENT 'Current status of customs processing.. Valid values are `pending|cleared|rejected`',
    `days_in_transit` STRING COMMENT 'Number of calendar days the vehicle has been in transit.',
    `delay_reason` STRING COMMENT 'Free‑text explanation for any delay affecting the shipment.',
    `destination_facility_code` STRING COMMENT 'Code of the dealer or final destination facility.',
    `emissions_kg_co2` DECIMAL(18,2) COMMENT 'Estimated CO₂ emissions generated during transit.',
    `estimated_arrival_date` DATE COMMENT 'Planned date the vehicle is expected to arrive at the destination.',
    `fuel_consumption_liters` DECIMAL(18,2) COMMENT 'Total fuel used during the transit leg.',
    `hazardous_material_flag` BOOLEAN COMMENT 'True if the shipment contains hazardous material.',
    `hazardous_material_type` STRING COMMENT 'Classification of hazardous material, if applicable.. Valid values are `flammable|explosive|corrosive|toxic|radioactive`',
    `last_update_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `load_type` STRING COMMENT 'Classification of how the vehicle is loaded.. Valid values are `full|partial|bulk|reefer`',
    `notes` STRING COMMENT 'Optional free‑form notes related to the in‑transit record.',
    `odometer_end_km` STRING COMMENT 'Vehicle odometer reading at the end of the shipment.',
    `odometer_start_km` STRING COMMENT 'Vehicle odometer reading at the start of the shipment.',
    `origin_facility_code` STRING COMMENT 'Code of the plant or facility where the vehicle originated.',
    `seal_number` STRING COMMENT 'Security seal identifier applied to the container or trailer.',
    `shipment_leg_count` STRING COMMENT 'Count of individual transport legs in the shipment itinerary.',
    `temperature_control_flag` BOOLEAN COMMENT 'Indicates whether the shipment requires temperature control.',
    `temperature_max_c` DECIMAL(18,2) COMMENT 'Maximum temperature setting for temperature‑controlled shipments.',
    `temperature_min_c` DECIMAL(18,2) COMMENT 'Minimum temperature setting for temperature‑controlled shipments.',
    `tracking_number` STRING COMMENT 'Carrier‑provided tracking identifier for the shipment.',
    `transit_status` STRING COMMENT 'Current operational status of the shipment.. Valid values are `in_transit|delayed|arrived|cancelled|hold`',
    `transport_cost_amount` DECIMAL(18,2) COMMENT 'Monetary cost incurred for transporting the vehicle.',
    `transport_cost_currency` STRING COMMENT 'Three‑letter ISO currency code for the transport cost.',
    `transport_mode` STRING COMMENT 'Mode of transportation used for the shipment.. Valid values are `rail|truck|vessel|air|compound|intermodal`',
    `volume_cubic_meters` DECIMAL(18,2) COMMENT 'Physical volume occupied by the vehicle or load.',
    `weight_tons` DECIMAL(18,2) COMMENT 'Weight of the vehicle or load in metric tons.',
    CONSTRAINT pk_in_transit_inventory PRIMARY KEY(`in_transit_inventory_id`)
) COMMENT 'Real-time and point-in-time snapshot of finished vehicles currently in transit between plant and dealer, including vehicles on rail, truck, vessel, or staged at intermediate compounds. Captures VIN, current location (last known compound or leg), transport mode, origin, destination, estimated arrival date, days in transit, and transit status. Critical for dealer allocation visibility and OTD monitoring.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` (
    `freight_invoice_id` BIGINT COMMENT 'System-generated unique identifier for the freight invoice record.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Freight invoices are billed to the end‑customer; associating each invoice with the customer party supports financial reconciliation and compliance reporting.',
    `carrier_id` BIGINT COMMENT 'Unique identifier of the carrier that provided the transport service.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Dealer freight chargeback process: OEMs bill inbound transport costs to receiving dealerships. A direct dealership_id FK on freight_invoice enables dealer-level freight cost reporting, chargeback reco',
    `lane_id` BIGINT COMMENT 'Foreign key linking to logistics.lane. Business justification: freight_invoice carries lane_code as a STRING reference to the logistics lane. Replacing this with a proper FK lane_id normalizes the relationship to the lane master record, enabling lane-level freigh',
    `parts_order_id` BIGINT COMMENT 'Foreign key linking to aftersales.aftersales_parts_order. Business justification: Freight cost allocation for parts: AP teams match freight invoices to aftersales parts orders for cost-center allocation, parts landed-cost calculation, and dealer reimbursement. Invoice-to-PO matchin',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_purchase_order. Business justification: Freight cost allocation to specific procurement POs is required for landed cost calculation in automotive — a standard finance and procurement reporting requirement. Enables direct freight-to-PO cost ',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Freight invoicing ties each invoice to the specific shipment for cost allocation and audit.',
    `shipment_leg_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment_leg. Business justification: In multi-modal outbound logistics, freight invoices are often issued per transport leg (e.g., separate invoices for road haul vs. ocean freight). Linking freight_invoice to shipment_leg enables leg-le',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Freight invoicing is linked to the sales order for full cost‑to‑serve accounting and profitability analysis.',
    `vehicle_transport_order_id` BIGINT COMMENT 'Foreign key linking to logistics.vehicle_transport_order. Business justification: freight_invoice carries transport_order_number as a STRING reference to vehicle_transport_order.order_number. Replacing this with a proper FK vehicle_transport_order_id normalizes the relationship, en',
    `agreed_rate` DECIMAL(18,2) COMMENT 'Contracted rate per unit (e.g., per kilometer or per container) agreed with the carrier.',
    `approval_status` STRING COMMENT 'Workflow status of the invoice approval process.. Valid values are `pending|approved|rejected`',
    `approved_by` BIGINT COMMENT 'Identifier of the employee who approved the invoice.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the invoice was approved.',
    `attachment_flag` BOOLEAN COMMENT 'True if supporting documents (e.g., PDF invoice) are attached to the record.',
    `cost_center_code` STRING COMMENT 'Internal cost‑center identifier to which the freight cost is charged.',
    `cost_type` STRING COMMENT 'Classification of the cost element represented by the invoice.. Valid values are `freight|duties|taxes|handling|insurance|other`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the freight invoice record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code of the invoice amount.. Valid values are `USD|EUR|JPY|CNY|GBP|CAD`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Any discount applied to the gross invoiced amount.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Currency conversion rate applied if invoice currency differs from reporting currency.',
    `exchange_rate_date` DATE COMMENT 'Date for which the exchange rate was valid.',
    `freight_invoice_status` STRING COMMENT 'Current lifecycle state of the freight invoice.. Valid values are `draft|submitted|approved|rejected|paid|cancelled`',
    `incoterms_code` STRING COMMENT 'International commercial term governing responsibility and cost allocation. [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAT|DAP|DDP — 7 candidates stripped; promote to reference product]',
    `invoice_date` TIMESTAMP COMMENT 'Date and time when the carrier issued the freight invoice.',
    `invoice_number` STRING COMMENT 'External invoice number assigned by the carrier or logistics provider.',
    `invoiced_amount` DECIMAL(18,2) COMMENT 'Total amount billed by the carrier before discounts, taxes, or adjustments.',
    `net_amount` DECIMAL(18,2) COMMENT 'Final amount payable after discounts and taxes.',
    `number_of_units` STRING COMMENT 'Count of individual units (vehicles, kits, parts) covered by the invoice.',
    `otd_flag` BOOLEAN COMMENT 'Indicates whether the shipment met the agreed on‑time delivery commitment.',
    `payment_date` DATE COMMENT 'Date on which the invoice was actually paid.',
    `payment_due_date` DATE COMMENT 'Date by which the invoice must be paid according to contract terms.',
    `payment_status` STRING COMMENT 'Current payment processing status of the invoice.. Valid values are `pending|approved|paid|rejected|partial|overdue`',
    `remarks` STRING COMMENT 'Free‑form text for additional comments or notes about the invoice.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component included in the invoice, if applicable.',
    `transport_mode` STRING COMMENT 'Mode of transportation used for the shipment (e.g., road, rail, sea, air, intermodal).. Valid values are `road|rail|sea|air|intermodal`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the freight invoice record.',
    `variance_amount` DECIMAL(18,2) COMMENT 'Difference between the invoiced amount and the agreed rate‑based amount.',
    `volume_cbm` DECIMAL(18,2) COMMENT 'Total cubic meter volume of the shipment.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Total weight of the shipment associated with the invoice, expressed in kilograms.',
    CONSTRAINT pk_freight_invoice PRIMARY KEY(`freight_invoice_id`)
) COMMENT 'Carrier freight invoice received for transport services rendered on finished vehicle or CKD/SKD shipments. Captures invoice number, carrier, invoice date, transport order references, lane, transport mode, invoiced amount, currency, agreed rate, variance amount, approval status, and payment reference. Supports freight cost management, carrier invoice verification against contracted rates, and logistics cost accounting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`lane` (
    `lane_id` BIGINT COMMENT 'Primary key for lane',
    `carrier_id` BIGINT COMMENT 'add column carrier_id (BIGINT) with FK to logistics.carrier.carrier_id - transport lanes are serviced by specific carriers',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Lane planning process: logistics lanes define origin-to-destination transport corridors. Dealer delivery lanes require a destination dealership FK to support carrier assignment, freight rate negotiati',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: Logistics lanes in automotive parts distribution connect origin plants/compounds to destination warehouses. Lane configuration drives freight rate negotiation, carrier assignment, and transit time sta',
    `vehicle_compound_id` BIGINT COMMENT 'Foreign key linking to logistics.vehicle_compound. Business justification: A logistics lane is defined as an origin-destination pair. The origin of a lane is typically a vehicle compound, plant yard, or staging area. Linking lane to vehicle_compound for the origin node norma',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Lane cost analysis requires linking each logistics lane to a cost center for profitability tracking.',
    CONSTRAINT pk_lane PRIMARY KEY(`lane_id`)
) COMMENT 'Master record defining a logistics lane as an origin-destination pair for finished vehicle or CKD/SKD transport. Captures origin facility (plant/compound/port), destination facility (dealer/compound/port), transport mode, distance, standard transit time, lane status, and assigned primary/backup carriers. Serves as the reference for route planning, rate assignment, and OTD benchmarking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` (
    `vehicle_handover_id` BIGINT COMMENT 'System-generated unique identifier for each vehicle handover record.',
    `dealership_id` BIGINT COMMENT 'Identifier of the system user who created the handover record.',
    `delivery_appointment_id` BIGINT COMMENT 'Foreign key linking to sales.delivery_appointment. Business justification: Vehicle handover is the physical execution of a scheduled delivery appointment. Logistics and sales teams reconcile handover completion against the appointment for OTD reporting, customer satisfaction',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: Vehicle handover occurs from a specific storage location (PDI bay, delivery bay) within a compound or dealership. Linking vehicle_handover to storage_location enables finished vehicle stock location c',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Revenue from vehicle handover is recognized in the responsible profit center for margin reporting.',
    `party_id` BIGINT COMMENT 'Unique identifier of the receiving party (dealer or customer).',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Linking handover to shipment provides traceability from transport to dealer receipt.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Handover record needs SKU to capture exact vehicle configuration handed to dealer.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Vehicle Handover process requires linking handover record to the equipment asset for warranty activation and service history.',
    `trade_in_id` BIGINT COMMENT 'Foreign key linking to sales.trade_in. Business justification: At vehicle handover, the trade-in is physically collected and routed for reconditioning or auction. Linking handover to trade_in enables title transfer tracking, logistics disposition routing, and rec',
    `vehicle_compound_id` BIGINT COMMENT 'Foreign key linking to logistics.vehicle_compound. Business justification: vehicle_handover records the formal handover of a vehicle from logistics/compound to dealer or end customer. The handover typically occurs at a specific compound or staging area. Linking vehicle_hando',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Final handover of a vehicle to the dealer is tied to the sales order for warranty activation and final invoicing.',
    `vehicle_ownership_id` BIGINT COMMENT 'Foreign key linking to customer.vehicle_ownership. Business justification: Vehicle handover is the triggering event that creates or activates the vehicle_ownership record (title transfer, warranty start, odometer capture). Linking handover to ownership supports delivery clos',
    `vehicle_transport_order_id` BIGINT COMMENT 'Foreign key linking to logistics.vehicle_transport_order. Business justification: vehicle_handover is the final delivery event that closes out a vehicle_transport_order. Linking vehicle_handover to vehicle_transport_order enables end-to-end transport order lifecycle tracking (from ',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Enables Vehicle Handover audit linking handover record to VIN master for warranty start and liability tracking.',
    `acceptance_signature_status` STRING COMMENT 'Status of the acceptance signature: signed, unsigned, or pending.. Valid values are `signed|unsigned|pending`',
    `carrier_name` STRING COMMENT 'Name of the logistics carrier responsible for the transport.',
    `container_code` STRING COMMENT 'Identifier of the shipping container (if applicable) used for the vehicle.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the handover record was initially created in the system.',
    `customs_document_number` STRING COMMENT 'Reference number of the customs clearance document.',
    `delay_reason` STRING COMMENT 'Reason for any delay affecting the handover schedule.',
    `emissions_kg_co2` DECIMAL(18,2) COMMENT 'Carbon dioxide emissions generated during transport, measured in kilograms.',
    `export_import_flag` BOOLEAN COMMENT 'True if the handover involves cross‑border export or import.',
    `fuel_consumption_liters` DECIMAL(18,2) COMMENT 'Fuel consumed by the transport vehicle during the handover journey.',
    `handover_condition` STRING COMMENT 'Condition of the vehicle at handover: new, used, reconditioned, or damaged.. Valid values are `new|used|reconditioned|damaged`',
    `handover_fee_amount` DECIMAL(18,2) COMMENT 'Gross fee charged for the handover service.',
    `handover_fee_currency` STRING COMMENT 'Three‑letter ISO 4217 currency code for the handover fee.',
    `handover_fee_net_amount` DECIMAL(18,2) COMMENT 'Net amount after tax for the handover fee.',
    `handover_fee_tax_amount` DECIMAL(18,2) COMMENT 'Tax component of the handover fee.',
    `handover_location` STRING COMMENT 'Physical location (plant, compound, yard, or dealer site) where the handover took place.',
    `handover_number` STRING COMMENT 'Business-assigned handover reference number used for tracking and communication.',
    `handover_status` STRING COMMENT 'Current processing status of the handover record.. Valid values are `pending|completed|cancelled|rejected`',
    `handover_timestamp` TIMESTAMP COMMENT 'Exact date and time when the handover event occurred.',
    `handover_type` STRING COMMENT 'Classification of the handover scenario: dealer stock, retail customer, export, or import.. Valid values are `dealer_stock|retail_customer|export|import`',
    `hazardous_material_flag` BOOLEAN COMMENT 'True if the vehicle or its cargo includes hazardous materials.',
    `hazardous_material_type` STRING COMMENT 'Classification of hazardous material, if applicable.',
    `incoterms_code` STRING COMMENT 'International commercial term code governing the shipment (e.g., FOB, CIF).',
    `notes` STRING COMMENT 'Free‑form notes captured during the handover process.',
    `odometer_reading_km` DECIMAL(18,2) COMMENT 'Vehicle odometer reading at the moment of handover, expressed in kilometers.',
    `otd_flag` BOOLEAN COMMENT 'Indicates whether the handover met the agreed on‑time delivery target.',
    `pdi_reference` STRING COMMENT 'Reference identifier linking to the Pre‑Delivery Inspection record.',
    `receiving_party_type` STRING COMMENT 'Indicates whether the receiving party is a dealer or an end‑customer.. Valid values are `dealer|customer`',
    `temperature_control_flag` BOOLEAN COMMENT 'Indicates whether temperature control was required for the shipment.',
    `temperature_max_c` DECIMAL(18,2) COMMENT 'Maximum temperature maintained during transport, expressed in degrees Celsius.',
    `temperature_min_c` DECIMAL(18,2) COMMENT 'Minimum temperature maintained during transport, expressed in degrees Celsius.',
    `transport_mode` STRING COMMENT 'Mode of transport used for moving the vehicle to the handover point.. Valid values are `rail|truck|ship|air`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the handover record.',
    `warranty_end_date` DATE COMMENT 'Date when the vehicle warranty expires.',
    `warranty_start_date` DATE COMMENT 'Date when the vehicle warranty becomes effective after handover.',
    CONSTRAINT pk_vehicle_handover PRIMARY KEY(`vehicle_handover_id`)
) COMMENT 'Record of formal vehicle handover from logistics/compound to dealer or end customer. Captures VIN, handover date, handover location, receiving party (dealer/customer), handover type (dealer stock/retail customer), odometer reading at handover, handover condition, PDI reference, and acceptance signature status. Marks the transfer of custody and triggers downstream billing and warranty start events.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_lane_id` FOREIGN KEY (`lane_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`lane`(`lane_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ADD CONSTRAINT `fk_logistics_shipment_leg_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ADD CONSTRAINT `fk_logistics_shipment_leg_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ADD CONSTRAINT `fk_logistics_shipment_leg_vehicle_compound_id` FOREIGN KEY (`vehicle_compound_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`vehicle_compound`(`vehicle_compound_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ADD CONSTRAINT `fk_logistics_vehicle_transport_order_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ADD CONSTRAINT `fk_logistics_vehicle_transport_order_lane_id` FOREIGN KEY (`lane_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`lane`(`lane_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ADD CONSTRAINT `fk_logistics_vehicle_transport_order_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ADD CONSTRAINT `fk_logistics_compound_movement_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ADD CONSTRAINT `fk_logistics_compound_movement_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ADD CONSTRAINT `fk_logistics_compound_movement_vehicle_compound_id` FOREIGN KEY (`vehicle_compound_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`vehicle_compound`(`vehicle_compound_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ADD CONSTRAINT `fk_logistics_compound_movement_vehicle_transport_order_id` FOREIGN KEY (`vehicle_transport_order_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`vehicle_transport_order`(`vehicle_transport_order_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_vehicle_transport_order_id` FOREIGN KEY (`vehicle_transport_order_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`vehicle_transport_order`(`vehicle_transport_order_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_lane_id` FOREIGN KEY (`lane_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`lane`(`lane_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_shipment_leg_id` FOREIGN KEY (`shipment_leg_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment_leg`(`shipment_leg_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_vehicle_transport_order_id` FOREIGN KEY (`vehicle_transport_order_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`vehicle_transport_order`(`vehicle_transport_order_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` ADD CONSTRAINT `fk_logistics_lane_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` ADD CONSTRAINT `fk_logistics_lane_vehicle_compound_id` FOREIGN KEY (`vehicle_compound_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`vehicle_compound`(`vehicle_compound_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_vehicle_compound_id` FOREIGN KEY (`vehicle_compound_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`vehicle_compound`(`vehicle_compound_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_vehicle_transport_order_id` FOREIGN KEY (`vehicle_transport_order_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`vehicle_transport_order`(`vehicle_transport_order_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`logistics` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`logistics` SET TAGS ('dbx_domain' = 'logistics');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` SET TAGS ('dbx_subdomain' = 'transport_execution');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Identifier (CARRIER_ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `lane_id` SET TAGS ('dbx_business_glossary_term' = 'Lane Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `parts_order_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Parts Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `production_order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `replenishment_order_id` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `stock_transfer_order_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Transfer Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier (VEHICLE_ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp (ACTUAL_ARRIVAL_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `actual_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Departure Timestamp (ACTUAL_DEPARTURE_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status (COMPLIANCE_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending|exempt');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `container_number` SET TAGS ('dbx_business_glossary_term' = 'Container Number (CONTAINER_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp (CREATED_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (CURRENCY_CODE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `customs_document_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Document Number (CUSTOMS_DOCUMENT_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `delay_reason` SET TAGS ('dbx_business_glossary_term' = 'Delay Reason (DELAY_REASON)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `destination_location` SET TAGS ('dbx_business_glossary_term' = 'Destination Location (DESTINATION_LOCATION)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount (DISCOUNT_AMOUNT)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `export_import_flag` SET TAGS ('dbx_business_glossary_term' = 'Export/Import Flag (EXPORT_IMPORT_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `freight_cost` SET TAGS ('dbx_business_glossary_term' = 'Freight Cost (FREIGHT_COST)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag (HAZARDOUS_MATERIAL_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code (INCOTERMS_CODE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DDP');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `load_type` SET TAGS ('dbx_business_glossary_term' = 'Load Type (LOAD_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `load_type` SET TAGS ('dbx_value_regex' = 'full|partial|hazardous|refrigerated|standard');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `net_cost` SET TAGS ('dbx_business_glossary_term' = 'Net Cost (NET_COST)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `number_of_units` SET TAGS ('dbx_business_glossary_term' = 'Number of Units (NUMBER_OF_UNITS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `origin_location` SET TAGS ('dbx_business_glossary_term' = 'Origin Location (ORIGIN_LOCATION)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `origin_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Plant Code (ORIGIN_PLANT_CODE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `otd_flag` SET TAGS ('dbx_business_glossary_term' = 'On‑Time Delivery Flag (OTD_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `planned_arrival_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Arrival Date (PLANNED_ARRIVAL_DATE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `planned_departure_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Departure Date (PLANNED_DEPARTURE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `shipment_number` SET TAGS ('dbx_business_glossary_term' = 'Shipment Number (SHIPMENT_NUMBER)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `shipment_status` SET TAGS ('dbx_business_glossary_term' = 'Shipment Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `shipment_status` SET TAGS ('dbx_value_regex' = 'planned|in_transit|delivered|cancelled|exception');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `temperature_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Temperature Control Flag (TEMPERATURE_CONTROL_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `tracking_url` SET TAGS ('dbx_business_glossary_term' = 'Tracking URL (TRACKING_URL)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode (TRANSPORT_MODE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'rail|truck|vessel|ckd|skd|air');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp (UPDATED_TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `vin_list` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Numbers (VIN_LIST)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Volume (CUBIC METERS) (VOLUME_CBM)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight (KG) (WEIGHT_KG)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` SET TAGS ('dbx_subdomain' = 'transport_execution');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `shipment_leg_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Leg Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `goods_movement_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Movement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `vehicle_compound_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Compound Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `actual_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Departure Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `container_code` SET TAGS ('dbx_business_glossary_term' = 'Container Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Leg Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Cost Currency');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `cost_currency` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `cost_type` SET TAGS ('dbx_business_glossary_term' = 'Cost Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `cost_type` SET TAGS ('dbx_value_regex' = 'freight|duty|tax|handling');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `customs_document_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Document Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `customs_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `customs_status` SET TAGS ('dbx_value_regex' = 'pending|cleared|rejected');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `delay_reason` SET TAGS ('dbx_business_glossary_term' = 'Delay Reason');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `distance_km` SET TAGS ('dbx_business_glossary_term' = 'Leg Distance (Kilometers)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `emissions_kg_co2` SET TAGS ('dbx_business_glossary_term' = 'CO2 Emissions (kg)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `fuel_consumption_liters` SET TAGS ('dbx_business_glossary_term' = 'Fuel Consumption (Liters)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `handling_instructions` SET TAGS ('dbx_business_glossary_term' = 'Handling Instructions');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `hazardous_material_type` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `leg_sequence` SET TAGS ('dbx_business_glossary_term' = 'Leg Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `leg_status` SET TAGS ('dbx_business_glossary_term' = 'Leg Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `leg_status` SET TAGS ('dbx_value_regex' = 'planned|in_transit|arrived|delayed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `load_type` SET TAGS ('dbx_business_glossary_term' = 'Load Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `load_type` SET TAGS ('dbx_value_regex' = 'full|less_than_truckload|partial');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `odometer_end` SET TAGS ('dbx_business_glossary_term' = 'Odometer End');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `odometer_start` SET TAGS ('dbx_business_glossary_term' = 'Odometer Start');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `planned_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `planned_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Departure Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Quantity of Units');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Seal Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `temperature_control_required` SET TAGS ('dbx_business_glossary_term' = 'Temperature Control Required');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `temperature_max_c` SET TAGS ('dbx_business_glossary_term' = 'Maximum Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `temperature_min_c` SET TAGS ('dbx_business_glossary_term' = 'Minimum Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Tracking Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'truck|rail|ship|air|pipeline');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `volume_cubic_meters` SET TAGS ('dbx_business_glossary_term' = 'Leg Volume (Cubic Meters)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `weight_tons` SET TAGS ('dbx_business_glossary_term' = 'Leg Weight (Tons)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` SET TAGS ('dbx_subdomain' = 'transport_execution');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `vehicle_transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Transport Order Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `lane_id` SET TAGS ('dbx_business_glossary_term' = 'Lane Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `production_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Production Schedule Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `vehicle_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Allocation Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `carrier_contact` SET TAGS ('dbx_business_glossary_term' = 'Carrier Contact Phone');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `carrier_contact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `carrier_contact` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `compliance_regulation_code` SET TAGS ('dbx_business_glossary_term' = 'Compliance Regulation Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `confirmed_pickup_date` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Pickup Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `container_type` SET TAGS ('dbx_business_glossary_term' = 'Container Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP|CAD');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `customs_declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `distance_km` SET TAGS ('dbx_business_glossary_term' = 'Transport Distance (km)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `emission_co2_kg` SET TAGS ('dbx_business_glossary_term' = 'CO₂ Emission (kg)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `estimated_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Estimated Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `export_import_flag` SET TAGS ('dbx_business_glossary_term' = 'Export/Import Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `fuel_type` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Fuel Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `fuel_type` SET TAGS ('dbx_value_regex' = 'diesel|gasoline|electric|hybrid');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `is_expedited` SET TAGS ('dbx_business_glossary_term' = 'Expedited Shipment Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `is_hazardous` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Order Notes');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `on_time_delivery_flag` SET TAGS ('dbx_business_glossary_term' = 'On‑Time Delivery Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `order_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Order Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `order_number` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `order_status` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `order_status` SET TAGS ('dbx_value_regex' = 'draft|open|confirmed|in_transit|delivered|cancelled');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `origin_compound` SET TAGS ('dbx_business_glossary_term' = 'Origin Compound');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Transport Priority');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `requested_pickup_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Pickup Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `shipping_instructions` SET TAGS ('dbx_business_glossary_term' = 'Shipping Instructions');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Carrier Tracking Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `transport_cost_gross` SET TAGS ('dbx_business_glossary_term' = 'Transport Cost Gross');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `transport_cost_net` SET TAGS ('dbx_business_glossary_term' = 'Transport Cost Net');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `transport_cost_tax` SET TAGS ('dbx_business_glossary_term' = 'Transport Cost Tax');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'truck|rail|vessel|air');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `vehicle_count` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Count');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `vin_list` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Numbers (VINs)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `vin_list` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `vin_list` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `weight_tons` SET TAGS ('dbx_business_glossary_term' = 'Shipment Weight (tons)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` SET TAGS ('dbx_subdomain' = 'transport_execution');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `average_cost_per_mile` SET TAGS ('dbx_business_glossary_term' = 'Average Cost per Mile (USD)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `average_on_time_delivery_pct` SET TAGS ('dbx_business_glossary_term' = 'Average On‑Time Delivery Percentage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `carrier_status` SET TAGS ('dbx_business_glossary_term' = 'Carrier Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `carrier_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|terminated|pending');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `carrier_type` SET TAGS ('dbx_business_glossary_term' = 'Carrier Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `carrier_type` SET TAGS ('dbx_value_regex' = 'carrier|logistics_provider|freight_forwarder|3pl|4pl');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `contact_email` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Email (PCE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `contact_email` SET TAGS ('dbx_value_regex' = '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `contact_name` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Name (PCN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Phone (PCP)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract End Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference (CR)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Start Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `country` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `country` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `country` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `environmental_certification` SET TAGS ('dbx_business_glossary_term' = 'Environmental Certification');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `environmental_certification` SET TAGS ('dbx_value_regex' = 'ISO14001|EPA|CARB|None');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `equipment_type` SET TAGS ('dbx_business_glossary_term' = 'Primary Equipment Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `equipment_type` SET TAGS ('dbx_value_regex' = 'truck|railcar|vessel|aircraft|intermodal_container');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `fleet_size` SET TAGS ('dbx_business_glossary_term' = 'Fleet Size');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `iatf_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'IATF 16949 Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `iatf_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Policy Number (IPN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `insurance_provider` SET TAGS ('dbx_business_glossary_term' = 'Insurance Provider');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Last Audit Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Legal Name (CLN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `operating_regions` SET TAGS ('dbx_business_glossary_term' = 'Operating Regions');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Performance Rating (PR)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `safety_rating` SET TAGS ('dbx_business_glossary_term' = 'Safety Rating');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `safety_rating` SET TAGS ('dbx_value_regex' = 'A|B|C|D|E|F');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `scac_code` SET TAGS ('dbx_business_glossary_term' = 'Standard Carrier Alpha Code (SCAC)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `scac_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `state` SET TAGS ('dbx_business_glossary_term' = 'State/Province');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `state` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `state` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_business_glossary_term' = 'Tax Identification Number (TIN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `tier` SET TAGS ('dbx_business_glossary_term' = 'Carrier Tier Classification');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `tier` SET TAGS ('dbx_value_regex' = 'tier1|tier2|tier3|tier4');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `transport_modes` SET TAGS ('dbx_business_glossary_term' = 'Supported Transport Modes (STM)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `transport_modes` SET TAGS ('dbx_value_regex' = 'road|rail|vessel|air|intermodal');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ALTER COLUMN `website` SET TAGS ('dbx_business_glossary_term' = 'Website URL');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` SET TAGS ('dbx_subdomain' = 'facility_operations');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `vehicle_compound_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Compound Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `capacity_units` SET TAGS ('dbx_business_glossary_term' = 'Storage Capacity (Units)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `capacity_units` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `compliance_certifications` SET TAGS ('dbx_business_glossary_term' = 'Compliance Certifications');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `compound_code` SET TAGS ('dbx_business_glossary_term' = 'Compound Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `compound_type` SET TAGS ('dbx_business_glossary_term' = 'Compound Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `compound_type` SET TAGS ('dbx_value_regex' = 'plant|port|regional|dealer_prep');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code (ISO‑3)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `current_occupancy` SET TAGS ('dbx_business_glossary_term' = 'Current Occupancy (Units)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `is_pdi_capable` SET TAGS ('dbx_business_glossary_term' = 'Pre‑Delivery Inspection Capability Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `manager_email` SET TAGS ('dbx_business_glossary_term' = 'Operator Email Address');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `manager_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `manager_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `manager_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `manager_phone` SET TAGS ('dbx_business_glossary_term' = 'Operator Phone Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `manager_phone` SET TAGS ('dbx_value_regex' = '^[+]?d{7,15}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `manager_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `manager_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `vehicle_compound_name` SET TAGS ('dbx_business_glossary_term' = 'Compound Name');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Compound Notes');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `operator_name` SET TAGS ('dbx_business_glossary_term' = 'Operator Name');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `operator_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `operator_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `otd_target_percentage` SET TAGS ('dbx_business_glossary_term' = 'On‑Time Delivery Target (%)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `security_level` SET TAGS ('dbx_business_glossary_term' = 'Security Level');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `security_level` SET TAGS ('dbx_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State/Province');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `storage_area_sqft` SET TAGS ('dbx_business_glossary_term' = 'Storage Area (sq ft)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Temperature‑Controlled Facility Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `vehicle_compound_status` SET TAGS ('dbx_business_glossary_term' = 'Compound Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `vehicle_compound_status` SET TAGS ('dbx_value_regex' = 'active|inactive|maintenance|closed');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ALTER COLUMN `waste_handling_capability` SET TAGS ('dbx_business_glossary_term' = 'Waste Handling Capability Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` SET TAGS ('dbx_subdomain' = 'facility_operations');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `compound_movement_id` SET TAGS ('dbx_business_glossary_term' = 'Compound Movement ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Identifier (CARRIER_ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Operator ID (OPERATOR_ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `dealership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `finished_vehicle_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Finished Vehicle Stock Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Operator ID (OPERATOR_ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `vehicle_compound_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Compound Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `vehicle_transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp (ACTUAL_ARRIVAL)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `compound_movement_status` SET TAGS ('dbx_business_glossary_term' = 'Movement Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `compound_movement_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `delay_minutes` SET TAGS ('dbx_business_glossary_term' = 'Delay Duration (DELAY_MIN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `estimated_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Estimated Arrival Timestamp (ETA)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `is_ota_capable` SET TAGS ('dbx_business_glossary_term' = 'OTA Capability Flag (OTA_CAPABLE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `load_quantity` SET TAGS ('dbx_business_glossary_term' = 'Load Quantity (QUANTITY)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `movement_reference` SET TAGS ('dbx_business_glossary_term' = 'Movement Reference (MOVEMENT_REF)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `movement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Movement Timestamp (TIMESTAMP)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `movement_type` SET TAGS ('dbx_business_glossary_term' = 'Movement Type (TYPE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `movement_type` SET TAGS ('dbx_value_regex' = 'inbound|outbound|internal_transfer');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Movement Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `odometer_reading_km` SET TAGS ('dbx_business_glossary_term' = 'Odometer Reading (KM)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `origin_zone` SET TAGS ('dbx_business_glossary_term' = 'Origin Zone (ORIGIN_ZONE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level (PRIORITY)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `temperature_c` SET TAGS ('dbx_business_glossary_term' = 'Ambient Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Type (VEHICLE_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_value_regex' = 'sedan|suv|truck|ev|hybrid');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Weight (KG)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` SET TAGS ('dbx_subdomain' = 'facility_operations');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `in_transit_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'In-Transit Inventory Record ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `aftersales_service_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Service Appointment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `carrier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier (Dealer ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `production_order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Identifier (SHIP_ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `stock_transfer_order_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Transfer Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `vehicle_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Allocation Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `vehicle_transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `actual_arrival_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `carrier_scac` SET TAGS ('dbx_business_glossary_term' = 'Carrier Standard Carrier Alpha Code (SCAC)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `current_location` SET TAGS ('dbx_business_glossary_term' = 'Current Location (Facility or Compound)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `customs_document_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Document Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `customs_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `customs_status` SET TAGS ('dbx_value_regex' = 'pending|cleared|rejected');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `days_in_transit` SET TAGS ('dbx_business_glossary_term' = 'Days In Transit');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `delay_reason` SET TAGS ('dbx_business_glossary_term' = 'Delay Reason Description');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `destination_facility_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Facility Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `emissions_kg_co2` SET TAGS ('dbx_business_glossary_term' = 'CO2 Emissions (kg)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `estimated_arrival_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Arrival Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `fuel_consumption_liters` SET TAGS ('dbx_business_glossary_term' = 'Fuel Consumption (Liters)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `hazardous_material_type` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `hazardous_material_type` SET TAGS ('dbx_value_regex' = 'flammable|explosive|corrosive|toxic|radioactive');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `last_update_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `load_type` SET TAGS ('dbx_business_glossary_term' = 'Load Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `load_type` SET TAGS ('dbx_value_regex' = 'full|partial|bulk|reefer');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `odometer_end_km` SET TAGS ('dbx_business_glossary_term' = 'Odometer End Reading (km)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `odometer_start_km` SET TAGS ('dbx_business_glossary_term' = 'Odometer Start Reading (km)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `origin_facility_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Facility Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Seal Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `shipment_leg_count` SET TAGS ('dbx_business_glossary_term' = 'Number of Shipment Legs');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `temperature_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Temperature Control Required Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `temperature_max_c` SET TAGS ('dbx_business_glossary_term' = 'Maximum Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `temperature_min_c` SET TAGS ('dbx_business_glossary_term' = 'Minimum Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Tracking Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `transit_status` SET TAGS ('dbx_business_glossary_term' = 'Transit Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `transit_status` SET TAGS ('dbx_value_regex' = 'in_transit|delayed|arrived|cancelled|hold');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `transport_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Transport Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `transport_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Transport Cost Currency (ISO 4217 Code)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode (e.g., Rail, Truck, Vessel, Air, Compound, Intermodal)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'rail|truck|vessel|air|compound|intermodal');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `volume_cubic_meters` SET TAGS ('dbx_business_glossary_term' = 'Volume (cubic meters)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `weight_tons` SET TAGS ('dbx_business_glossary_term' = 'Weight (tons)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` SET TAGS ('dbx_subdomain' = 'transport_execution');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `freight_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Invoice Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `lane_id` SET TAGS ('dbx_business_glossary_term' = 'Lane Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `parts_order_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Parts Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `shipment_leg_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Leg Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `vehicle_transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `agreed_rate` SET TAGS ('dbx_business_glossary_term' = 'Agreed Freight Rate');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Approval Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approver Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Invoice Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `attachment_flag` SET TAGS ('dbx_business_glossary_term' = 'Attachment Presence Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `cost_type` SET TAGS ('dbx_business_glossary_term' = 'Cost Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `cost_type` SET TAGS ('dbx_value_regex' = 'freight|duties|taxes|handling|insurance|other');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP|CAD');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `exchange_rate_date` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `freight_invoice_status` SET TAGS ('dbx_business_glossary_term' = 'Freight Invoice Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `freight_invoice_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|approved|rejected|paid|cancelled');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Freight Invoice Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Freight Invoice Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `invoiced_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoiced Amount (USD)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `number_of_units` SET TAGS ('dbx_business_glossary_term' = 'Number of Units Shipped');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `otd_flag` SET TAGS ('dbx_business_glossary_term' = 'On‑Time Delivery Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `payment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `payment_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `payment_status` SET TAGS ('dbx_value_regex' = 'pending|approved|paid|rejected|partial|overdue');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Invoice Remarks');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|sea|air|intermodal');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `variance_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoice Variance Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Shipment Volume (cbm)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Shipment Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` SET TAGS ('dbx_subdomain' = 'transport_execution');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` ALTER COLUMN `lane_id` SET TAGS ('dbx_business_glossary_term' = 'Lane Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` ALTER COLUMN `vehicle_compound_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Vehicle Compound Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` SET TAGS ('dbx_subdomain' = 'facility_operations');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `vehicle_handover_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Handover Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `dealership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `delivery_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Appointment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Party Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `trade_in_id` SET TAGS ('dbx_business_glossary_term' = 'Trade In Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `vehicle_compound_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Compound Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `vehicle_ownership_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Ownership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `vehicle_transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `acceptance_signature_status` SET TAGS ('dbx_business_glossary_term' = 'Acceptance Signature Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `acceptance_signature_status` SET TAGS ('dbx_value_regex' = 'signed|unsigned|pending');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `acceptance_signature_status` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Name');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `container_code` SET TAGS ('dbx_business_glossary_term' = 'Container Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `customs_document_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Document Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `delay_reason` SET TAGS ('dbx_business_glossary_term' = 'Delay Reason');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `emissions_kg_co2` SET TAGS ('dbx_business_glossary_term' = 'CO₂ Emissions (kg)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `export_import_flag` SET TAGS ('dbx_business_glossary_term' = 'Export/Import Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `fuel_consumption_liters` SET TAGS ('dbx_business_glossary_term' = 'Fuel Consumption (Liters)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `handover_condition` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Handover Condition');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `handover_condition` SET TAGS ('dbx_value_regex' = 'new|used|reconditioned|damaged');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `handover_fee_amount` SET TAGS ('dbx_business_glossary_term' = 'Handover Fee Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `handover_fee_currency` SET TAGS ('dbx_business_glossary_term' = 'Handover Fee Currency');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `handover_fee_net_amount` SET TAGS ('dbx_business_glossary_term' = 'Handover Fee Net Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `handover_fee_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Handover Fee Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `handover_location` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Handover Location');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `handover_number` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Handover Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `handover_status` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Handover Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `handover_status` SET TAGS ('dbx_value_regex' = 'pending|completed|cancelled|rejected');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `handover_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Handover Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `handover_type` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Handover Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `handover_type` SET TAGS ('dbx_value_regex' = 'dealer_stock|retail_customer|export|import');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `hazardous_material_type` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Handover Notes');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `odometer_reading_km` SET TAGS ('dbx_business_glossary_term' = 'Odometer Reading (KM)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `otd_flag` SET TAGS ('dbx_business_glossary_term' = 'On‑Time Delivery Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `pdi_reference` SET TAGS ('dbx_business_glossary_term' = 'Pre‑Delivery Inspection (PDI) Reference');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `receiving_party_type` SET TAGS ('dbx_business_glossary_term' = 'Receiving Party Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `receiving_party_type` SET TAGS ('dbx_value_regex' = 'dealer|customer');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `temperature_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Temperature Control Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `temperature_max_c` SET TAGS ('dbx_business_glossary_term' = 'Maximum Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `temperature_min_c` SET TAGS ('dbx_business_glossary_term' = 'Minimum Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'rail|truck|ship|air');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `warranty_end_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty End Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Start Date');
