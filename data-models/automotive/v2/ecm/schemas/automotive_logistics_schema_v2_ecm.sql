-- Schema for Domain: logistics | Business:  | Version: v2_ecm
-- Generated on: 2026-07-14 02:32:22

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`logistics` COMMENT 'Outbound logistics and distribution including finished vehicle transportation, vehicle storage yards, compound operations, carrier management, and delivery scheduling. Manages vehicle shipment from plant to dealer, rail/truck/vessel logistics, port processing, last-mile delivery, and CKD/SKD kit logistics. Tracks in-transit inventory, delivery lead times, transportation costs, carrier performance, and OTD metrics. Includes export/import operations for global distribution.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`shipment` (
    `shipment_id` BIGINT COMMENT 'System-generated unique identifier for each outbound vehicle shipment.',
    `carrier_id` BIGINT COMMENT 'System identifier for the carrier entity.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Required for Shipment Compliance Documentation Report linking each shipment to its approved customs/compliance document.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Required for freight cost allocation per shipment in the Transportation Cost Allocation Report.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Required for Shipment Creation Report to record the logistics coordinator responsible for initiating each shipment.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Required for Shipment Delivery Performance Report linking each shipment to its destination dealership; enables OTD and cost tracking per dealer.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Required for Shipment Tracking Report to associate each shipment with the primary vehicle asset for warranty and depreciation.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Needed to post transportation expenses to the appropriate GL account in the General Ledger.',
    `part_master_id` BIGINT COMMENT 'Foreign key linking to engineering.part_master. Business justification: Parts Shipment Tracking requires linking each shipment to the specific part master to satisfy regulatory traceability and cost allocation reports.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: PO‑based inbound logistics tracking ties each shipment to the purchase order it fulfills, essential for supply chain KPI dashboards.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Direct supplier‑shipment link enables supplier on‑time delivery KPI and performance reporting for inbound parts.',
    `production_order_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_order. Business justification: Order fulfillment shipping links each shipment to its originating production order for traceability and cost accounting.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Order fulfillment tracking report ties each physical shipment to its originating sales vehicle order, essential for delivery status and revenue recognition.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Required for Shipment Planning Report to allocate vehicles by program; logistics teams need program context for routing and dealer allocation.',
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
    `functional_location_id` BIGINT COMMENT 'Identifier of the facility where the leg terminates.',
    `goods_movement_id` BIGINT COMMENT 'Foreign key linking to inventory.goods_movement. Business justification: Enables Shipment Leg Cost Allocation: reconciles each logistics leg with the corresponding inventory goods movement for cost analysis.',
    `shipment_functional_location_id` BIGINT COMMENT 'Identifier of the facility where the leg originates (plant, yard, port, etc.).',
    `shipment_id` BIGINT COMMENT 'Identifier of the parent shipment (transaction header) to which this leg belongs.',
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
    `finished_vehicle_stock_id` BIGINT COMMENT 'System-generated unique identifier for the transport order.',
    `carrier_id` BIGINT COMMENT 'Identifier of the logistics carrier responsible for the shipment.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Transport order costs are charged to a cost center for budgeting and variance analysis.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Needed for Transport Order Execution Dashboard to associate each order with the receiving dealership; supports dealer‑level on‑time delivery metrics.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Dispatch planning process assigns a dispatcher employee to each transport order for tracking and accountability.',
    `load_plan_id` BIGINT COMMENT 'Identifier of the load planning record associated with this transport order.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant where the vehicles are shipped from.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: A transport order represents the execution of a shipment; linking it to the parent shipment enables traceability of cost and status.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Transport planning aligns with the specific sales vehicle order to ensure correct routing, timing, and cost allocation.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Needed for Transport Order Management to group orders by vehicle program, enabling capacity planning and compliance with program launch schedules.',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` (
    `logistics_delivery_schedule_id` BIGINT COMMENT 'Unique identifier for the delivery_schedule data product (auto-inserted pre-linking).',
    `finished_vehicle_stock_id` BIGINT COMMENT 'System-generated unique identifier for the delivery schedule record.',
    `carrier_id` BIGINT COMMENT 'Identifier of the logistics carrier responsible for transportation.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Scheduled delivery cost estimates are allocated to a cost center for financial planning.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer receiving the vehicles.',
    `logistics_dealership_id` BIGINT COMMENT 'Identifier of the dealer receiving the vehicles.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant or distribution compound where the vehicles are dispatched.',
    `route_id` BIGINT COMMENT 'Identifier for the transportation route used for the delivery.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Delivery Scheduling system records which employee created/maintains each schedule for audit and performance metrics.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Delivery schedule planning references the shipment that will deliver vehicles to the dealership.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Delivery schedule generation uses sales order details to plan dealer deliveries and measure on‑time delivery performance.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Delivery Schedule Dashboard aggregates deliveries per program; linking ensures on‑time delivery metrics are tied to the correct vehicle program.',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Real timestamp when the shipment arrived at the dealer.',
    `actual_departure_timestamp` TIMESTAMP COMMENT 'Real timestamp when the shipment actually left the plant.',
    `arrival_date` DATE COMMENT 'Scheduled date for the vehicles to arrive at the dealer location.',
    `compliance_flag` BOOLEAN COMMENT 'Indicates the compliance status of the shipment with relevant regulations.',
    `cost_actual` DECIMAL(18,2) COMMENT 'Final cost incurred for the delivery after execution.',
    `cost_estimate` DECIMAL(18,2) COMMENT 'Projected cost for the scheduled delivery, before execution.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the record was first captured for audit purposes.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for cost fields.. Valid values are `USD|EUR|JPY|CNY|GBP|CAD`',
    `customs_document_required` BOOLEAN COMMENT 'True if customs paperwork is required for the shipment.',
    `delivery_window_end` TIMESTAMP COMMENT 'End of the agreed delivery time window at the dealer.',
    `delivery_window_start` TIMESTAMP COMMENT 'Start of the agreed delivery time window at the dealer.',
    `departure_date` DATE COMMENT 'Scheduled date for the vehicles to leave the plant or compound.',
    `estimated_delivery_date` DATE COMMENT 'Projected delivery date based on current schedule and carrier commitments.',
    `export_import_flag` BOOLEAN COMMENT 'Indicates whether the shipment is export, import, or domestic.',
    `freight_class` STRING COMMENT 'Classification of freight for tariff and handling purposes.',
    `incoterms` STRING COMMENT 'International commercial terms governing the delivery responsibilities.. Valid values are `EXW|FCA|CPT|CIP|DAP|DDP`',
    `is_expedited` BOOLEAN COMMENT 'Indicates whether the delivery is expedited (true) or standard (false).',
    `is_hazardous` BOOLEAN COMMENT 'True if the shipment contains hazardous materials requiring special handling.',
    `last_mile_delivery_method` STRING COMMENT 'Method used for the final leg of delivery to the dealer or customer.. Valid values are `dealer|direct|third_party|pickup|locker|drone`',
    `lead_time_days` STRING COMMENT 'Number of days between departure and arrival, calculated for performance analysis.',
    `logistics_delivery_schedule_status` STRING COMMENT 'Current lifecycle state of the delivery schedule.. Valid values are `planned|released|in_transit|delivered|cancelled|on_hold`',
    `notes` STRING COMMENT 'Free‑form field for any additional remarks.',
    `otd_actual_date` DATE COMMENT 'Actual date when the delivery was completed for OTD measurement.',
    `otd_target_date` DATE COMMENT 'Target date for achieving on‑time delivery performance.',
    `planned_quantity` BIGINT COMMENT 'Number of vehicles (or units) scheduled for delivery.',
    `priority_level` STRING COMMENT 'Business priority assigned to the delivery schedule.. Valid values are `low|medium|high|critical|urgent|standard`',
    `schedule_horizon` STRING COMMENT 'Planning horizon for the schedule (e.g., weekly, monthly).. Valid values are `weekly|monthly|quarterly|yearly|ad_hoc|custom`',
    `schedule_number` STRING COMMENT 'Business identifier assigned to the delivery schedule, used for tracking and communication with dealers and carriers.',
    `schedule_timestamp` TIMESTAMP COMMENT 'Timestamp when the delivery schedule was initially created in the system.',
    `scheduled_arrival_timestamp` TIMESTAMP COMMENT 'Planned exact timestamp for arrival, including time of day.',
    `scheduled_departure_timestamp` TIMESTAMP COMMENT 'Planned exact timestamp for departure, including time of day.',
    `special_instructions` STRING COMMENT 'Any additional handling or routing instructions for the shipment.',
    `temperature_control_required` BOOLEAN COMMENT 'True if temperature‑controlled transport is required.',
    `tracking_number` STRING COMMENT 'External tracking number provided by the carrier.',
    `transport_mode` STRING COMMENT 'Mode of transportation used for the delivery.. Valid values are `truck|rail|vessel|air|intermodal|pipeline`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the delivery schedule record.',
    `vehicle_type` STRING COMMENT 'Type of transport vehicle allocated for the shipment.. Valid values are `semi_trailer|reefer|flatbed|dry_van|tank|container`',
    `volume_cbm` DECIMAL(18,2) COMMENT 'Aggregate cargo volume in cubic meters.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Aggregate weight of the shipment in kilograms.',
    CONSTRAINT pk_logistics_delivery_schedule PRIMARY KEY(`logistics_delivery_schedule_id`)
) COMMENT 'Planned delivery schedule for finished vehicles from plant or distribution compound to dealer network. Captures scheduled delivery windows, dealer allocation, vehicle model/trim/color mix, planned quantities, transport mode, and scheduling horizon (weekly/monthly). Supports OTD planning, dealer inventory replenishment, and logistics capacity allocation. Linked to dealer orders and production scheduling.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`carrier` (
    `carrier_id` BIGINT COMMENT 'System-generated unique identifier for the carrier record.',
    `jurisdiction_id` BIGINT COMMENT 'add column jurisdiction_id (BIGINT) with FK to compliance.jurisdiction.jurisdiction_id - carriers operate under specific regulatory jurisdictions for transport licensing',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` (
    `carrier_performance_id` BIGINT COMMENT 'System‑generated unique identifier for each carrier performance scorecard row.',
    `carrier_id` BIGINT COMMENT 'Unique identifier of the logistics carrier whose performance is being measured.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Carrier performance reviews are performed by a specific employee; link enables reviewer accountability.',
    `average_transit_days` DECIMAL(18,2) COMMENT 'Mean number of calendar days shipments spent in transit for the period.',
    `carrier_performance_status` STRING COMMENT 'Indicates whether the performance record is active, inactive, or archived.. Valid values are `active|inactive|archived`',
    `claim_frequency` STRING COMMENT 'Count of loss or damage claims submitted for the carrier on this lane during the period.',
    `cost_per_shipment_usd` DECIMAL(18,2) COMMENT 'Average transportation cost incurred per shipment for the carrier on this lane.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the carrier performance row was initially loaded into the lakehouse.',
    `damage_rate_ppm` STRING COMMENT 'Number of damaged units per one million units shipped during the period.',
    `fuel_consumption_l_per_100km` DECIMAL(18,2) COMMENT 'Average liters of fuel used per 100 kilometers by the carrier on this lane.',
    `lane_code` STRING COMMENT 'Alphanumeric identifier for the transportation lane (e.g., "DET‑LAX").',
    `lane_type` STRING COMMENT 'Indicates whether the lane is domestic, export, or import.. Valid values are `domestic|export|import`',
    `notes` STRING COMMENT 'Optional textual comments regarding carrier performance, exceptions, or observations for the period.',
    `on_time_delivery_rate_pct` DECIMAL(18,2) COMMENT 'Percentage of shipments delivered within the agreed delivery window, calculated independently of OTD for cross‑validation.',
    `otd_rate_pct` DECIMAL(18,2) COMMENT 'Percentage of shipments delivered on or before the committed delivery date for the period.',
    `overall_rating` STRING COMMENT 'Composite score (1‑5) summarizing carrier performance across all metrics.',
    `performance_month` DATE COMMENT 'Calendar month (first day) representing the reporting period for the carrier performance metrics.',
    `total_claims` STRING COMMENT 'Aggregate count of all claims (damage, loss, etc.) for the period.',
    `total_damage_units` STRING COMMENT 'Sum of individual units reported as damaged during the period.',
    `total_distance_km` DECIMAL(18,2) COMMENT 'Total kilometers driven or sailed by the carrier for shipments on this lane in the period.',
    `total_shipments` STRING COMMENT 'Count of individual shipments moved by the carrier on the lane during the period.',
    `transit_time_compliance_pct` DECIMAL(18,2) COMMENT 'Percentage of shipments that met the agreed‑upon transit‑time windows.',
    `transport_mode` STRING COMMENT 'Primary mode of transportation for the lane (e.g., truck, rail, vessel, intermodal, air).. Valid values are `truck|rail|vessel|intermodal|air`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the latest modification to the carrier performance data.',
    CONSTRAINT pk_carrier_performance PRIMARY KEY(`carrier_performance_id`)
) COMMENT 'Periodic carrier performance scorecard capturing OTD rate, damage rate (PPM), transit time compliance, claim frequency, and overall carrier rating per lane and transport mode. Tracks performance against contracted SLAs, flags underperforming carriers, and supports carrier qualification reviews. Aggregated at carrier-lane-period level for logistics procurement decisions.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` (
    `vehicle_compound_id` BIGINT COMMENT 'Unique identifier for the vehicle compound (yard, port, or regional staging area).',
    `dealership_id` BIGINT COMMENT 'add column dealership_id (BIGINT) with FK to dealer.dealership.dealership_id - vehicle compounds may serve specific dealer clusters',
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
    `employee_id` BIGINT COMMENT 'Identifier of the employee who performed the movement.',
    `compound_operator_employee_id` BIGINT COMMENT 'Identifier of the employee who performed the movement.',
    `vehicle_compound_id` BIGINT COMMENT 'Foreign key linking to logistics.vehicle_compound. Business justification: Compound movements occur within a vehicle compound; adding vehicle_compound_id links movements to their compound.',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Recorded arrival time at the destination zone.',
    `compound_movement_status` STRING COMMENT 'Current lifecycle status of the movement.. Valid values are `pending|in_progress|completed|cancelled`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the record was first created in the system.',
    `delay_minutes` STRING COMMENT 'Minutes of delay between ETA and actual arrival.',
    `destination_zone` STRING COMMENT 'Yard or bay where the vehicle is moved to.',
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
    `transport_order_number` STRING COMMENT 'Reference to the transport order governing the movement.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `vehicle_type` STRING COMMENT 'Classification of the vehicle model.. Valid values are `sedan|suv|truck|ev|hybrid`',
    `vin` STRING COMMENT 'Unique identifier of the vehicle being moved.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Weight of the vehicle at the time of movement.',
    CONSTRAINT pk_compound_movement PRIMARY KEY(`compound_movement_id`)
) COMMENT 'Transactional record of a vehicles physical movement into, within, or out of a compound or yard. Captures VIN, movement type (inbound/outbound/internal transfer), origin bay/zone, destination bay/zone, movement timestamp, operator ID, and associated transport order. Provides granular yard management traceability and supports compound throughput analysis.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` (
    `in_transit_inventory_id` BIGINT COMMENT 'Surrogate primary key for the in-transit inventory record.',
    `carrier_id` BIGINT COMMENT 'FK to logistics.carrier',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: In‑transit inventory dashboard tracks connectivity; linking VIN to connected_vehicle enables real‑time OTA updates and status monitoring.',
    `container_id` BIGINT COMMENT 'Identifier of the container or trailer used for transport.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: In‑transit inventory holding costs are allocated to a cost center for cost of goods sold calculation.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: When vehicles are shipped directly to end‑customers, tracking the recipient party is required for delivery confirmation, warranty activation, and service scheduling.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer receiving the vehicle.',
    `in_dealership_id` BIGINT COMMENT 'Identifier of the dealer receiving the vehicle.',
    `production_order_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_order. Business justification: In‑transit inventory reports tie each in‑transit record to its originating production order for cost allocation and visibility.',
    `shipment_id` BIGINT COMMENT 'Unique business identifier for the vehicle shipment.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: In‑Transit Inventory Visibility report needs SKU to show vehicle configuration while in transit.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: In‑transit inventory status is reported per sales order to provide customers with accurate ETA and inventory visibility.',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`port_processing` (
    `port_processing_id` BIGINT COMMENT 'Unique system-generated identifier for each port processing record.',
    `carrier_id` BIGINT COMMENT 'FK to logistics.carrier',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Connects port processing record to the inspection compliance document required for release authorization.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Port processing report must link each processed VIN to its connected vehicle record for OTA activation and compliance tracking.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Port Processing compliance report ties each vehicle VIN to its equipment record for import/export regulatory tracking.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Port processing logs require the employee who performed the inspection for compliance and traceability.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Port processing activities are tied to a specific shipment; adding shipment_id creates the required parent‑child relationship.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Supports Port Processing Inspection report linking each processed vehicle to its VIN master record for homologation and customs verification.',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Recorded timestamp when the vessel actually arrived.',
    `actual_departure_timestamp` TIMESTAMP COMMENT 'Recorded timestamp when the vessel actually departed.',
    `arrival_date` DATE COMMENT 'Scheduled or actual date the vessel arrived at the port.',
    `carrier_scac_code` STRING COMMENT 'Standard Carrier Alpha Code identifying the carrier.',
    `compliance_regulation_code` STRING COMMENT 'Code of the specific UNECE or other regulation applicable to the shipment.',
    `compliance_status` STRING COMMENT 'Overall compliance status of the shipment with applicable regulations.. Valid values are `compliant|non_compliant|pending`',
    `container_code` STRING COMMENT 'Identifier of the shipping container if the vehicle is containerized.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the port processing record was first created in the system.',
    `customs_clearance_status` STRING COMMENT 'Current status of customs clearance for the shipment.. Valid values are `not_submitted|submitted|cleared|rejected`',
    `customs_document_number` STRING COMMENT 'Reference number of the customs filing associated with the shipment.',
    `customs_document_type` STRING COMMENT 'Type of customs document submitted for the shipment.. Valid values are `bill_of_lading|manifest|invoice|certificate`',
    `departure_date` DATE COMMENT 'Scheduled or actual date the vessel departed from the port.',
    `estimated_arrival_timestamp` TIMESTAMP COMMENT 'Planned timestamp for vessel arrival at the port.',
    `estimated_departure_timestamp` TIMESTAMP COMMENT 'Planned timestamp for vessel departure from the port.',
    `export_import_indicator` STRING COMMENT 'Specifies whether the processing event relates to an export or import shipment.. Valid values are `export|import`',
    `freight_cost_amount` DECIMAL(18,2) COMMENT 'Monetary cost of freight associated with the shipment.',
    `freight_cost_currency` STRING COMMENT 'Three‑letter ISO 4217 currency code for freight cost.',
    `homologation_inspection_status` STRING COMMENT 'Result of regulatory homologation inspection at the port.. Valid values are `not_required|pending|passed|failed`',
    `inspection_date` DATE COMMENT 'Date when the port inspection was performed.',
    `inspection_report_number` STRING COMMENT 'Identifier of the inspection report generated at the port.',
    `model_year` STRING COMMENT 'Model year of the vehicle.',
    `notes` STRING COMMENT 'Free‑form text field for additional remarks or observations.',
    `pdi_completion_status` STRING COMMENT 'Status of the pre‑delivery inspection performed at the port.. Valid values are `not_started|in_progress|completed`',
    `port_charges_amount` DECIMAL(18,2) COMMENT 'Total monetary amount of port fees and charges assessed.',
    `port_charges_currency` STRING COMMENT 'Three‑letter ISO 4217 currency code for port charges.',
    `port_facility_code` STRING COMMENT 'Standard code identifying the port facility where processing occurs.',
    `port_facility_name` STRING COMMENT 'Human‑readable name of the port facility.',
    `port_processing_status` STRING COMMENT 'Current lifecycle status of the port processing activity.. Valid values are `pending|in_progress|completed|cancelled`',
    `processing_reference` STRING COMMENT 'Business reference code assigned to the port processing event for tracking and communication.',
    `processing_timestamp` TIMESTAMP COMMENT 'Timestamp of the primary business event when the processing activity was recorded.',
    `release_authorization_flag` BOOLEAN COMMENT 'Indicates whether the vehicle has been authorized for release from the port.',
    `release_authorization_number` STRING COMMENT 'Reference number for the release authorization document.',
    `seal_number` STRING COMMENT 'Security seal number applied to the container or trailer.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the port processing record.',
    `vehicle_type` STRING COMMENT 'Category of the vehicle based on body style and powertrain. [ENUM-REF-CANDIDATE: car|truck|suv|commercial|ev|hev|phev|ice — 8 candidates stripped; promote to reference product]',
    `vessel_name` STRING COMMENT 'Name of the vessel carrying the vehicles.',
    `voyage_number` STRING COMMENT 'Identifier for the specific voyage of the vessel.',
    CONSTRAINT pk_port_processing PRIMARY KEY(`port_processing_id`)
) COMMENT 'Record of port-of-entry or port-of-exit processing activities for finished vehicles in export/import operations. Captures port facility, vessel name, voyage number, arrival/departure dates, customs clearance status, homologation inspection status, PDI completion, port charges, and release authorization. Supports global distribution and import compliance tracking per UNECE and local customs regulations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` (
    `vessel_voyage_id` BIGINT COMMENT 'System-generated unique identifier for the vessel voyage record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Voyage management tracks the captain (employee) assigned to each vessel voyage for safety and regulatory reporting.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: Vessel voyages are operated by carriers (including ocean shipping lines); adding carrier_id connects voyages to carriers.',
    `shipping_line_id` BIGINT COMMENT 'Unique identifier of the shipping line operating the vessel.',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Real‑time date and time when the vessel arrived at the destination port.',
    `actual_departure_timestamp` TIMESTAMP COMMENT 'Real‑time date and time when the vessel left the origin port.',
    `available_capacity_units` STRING COMMENT 'Remaining vehicle capacity after bookings (capacity minus booked units).',
    `booked_units` STRING COMMENT 'Number of vehicle units already booked for the voyage.',
    `cost_amount` DECIMAL(18,2) COMMENT 'Total cost incurred for the voyage (e.g., charter fee, fuel surcharge).',
    `cost_currency` STRING COMMENT 'Three‑letter ISO 4217 currency code for the cost amount.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the voyage record was first created in the system.',
    `destination_port_code` STRING COMMENT 'Three‑letter UN/LOCODE of the port where the voyage terminates.. Valid values are `^[A-Z]{3}$`',
    `imo_number` STRING COMMENT 'Seven‑digit unique identifier for the vessel as defined by IMO conventions.. Valid values are `^d{7}$`',
    `origin_port_code` STRING COMMENT 'Three‑letter UN/LOCODE of the port where the voyage originates.. Valid values are `^[A-Z]{3}$`',
    `planned_arrival_timestamp` TIMESTAMP COMMENT 'Scheduled date and time for vessel arrival at the destination port.',
    `planned_departure_timestamp` TIMESTAMP COMMENT 'Scheduled date and time for vessel departure from the origin port.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the voyage record.',
    `vessel_capacity_units` STRING COMMENT 'Maximum number of vehicles the vessel can transport on this voyage.',
    `vessel_name` STRING COMMENT 'Human‑readable name of the vessel used for the voyage.',
    `voyage_number` STRING COMMENT 'External reference number assigned to the voyage by the shipping line.',
    `voyage_status` STRING COMMENT 'Current operational status of the voyage.. Valid values are `planned|departed|arrived|cancelled|completed|on_hold`',
    `voyage_status_reason` STRING COMMENT 'Free‑text explanation for the current voyage status, e.g., weather delay, mechanical issue.',
    `voyage_type` STRING COMMENT 'Category of vessel operation, such as Roll‑On/Roll‑Off (RoRo) or container.. Valid values are `ro-ro|container|bulk|tanker`',
    CONSTRAINT pk_vessel_voyage PRIMARY KEY(`vessel_voyage_id`)
) COMMENT 'Master record for ocean vessel voyages used in finished vehicle export/import logistics. Captures vessel name, IMO number, voyage number, shipping line, origin port, destination port, planned and actual departure/arrival dates, vehicle capacity (units), booked units, and voyage status. Enables RoRo vessel capacity planning and export shipment scheduling.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` (
    `rail_car_assignment_id` BIGINT COMMENT 'Unique identifier for each rail car assignment record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Rail car assignments are executed by a specific operator employee; needed for labor tracking and incident analysis.',
    `vehicle_transport_order_id` BIGINT COMMENT 'Identifier of the parent rail transport order to which this assignment belongs.',
    `assignment_status` STRING COMMENT 'High‑level status indicating whether the rail car assignment is active, completed, or cancelled.. Valid values are `assigned|released|canceled`',
    `capacity_utilization_pct` DECIMAL(18,2) COMMENT 'Percentage of the rail cars capacity that is utilized by the current load.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the assignment record was first created in the system.',
    `critical_flag` BOOLEAN COMMENT 'True if the assignment is considered critical for meeting OTD (On‑Time Delivery) commitments.',
    `destination_yard_code` STRING COMMENT 'Standard code identifying the rail yard where unloading will occur.',
    `destination_yard_name` STRING COMMENT 'Descriptive name of the destination rail yard.',
    `load_volume_cubic_meters` DECIMAL(18,2) COMMENT 'Combined cargo volume of the loaded vehicles, measured in cubic meters.',
    `load_weight_kg` DECIMAL(18,2) COMMENT 'Aggregate weight of all vehicles loaded onto the rail car, expressed in kilograms.',
    `loading_date` DATE COMMENT 'Scheduled calendar date when the rail car is loaded with vehicles.',
    `loading_sequence` STRING COMMENT 'Ordinal position of this assignment in the loading plan.',
    `loading_status` STRING COMMENT 'Operational status of the loading process for this assignment.. Valid values are `pending|in_progress|completed|failed`',
    `notes` STRING COMMENT 'Additional comments, exceptions, or handling instructions related to the assignment.',
    `occupied_capacity_tons` DECIMAL(18,2) COMMENT 'Weight of the loaded vehicles expressed as a portion of the rail cars total capacity.',
    `origin_yard_code` STRING COMMENT 'Standard code identifying the rail yard where loading begins.',
    `origin_yard_name` STRING COMMENT 'Descriptive name of the origin rail yard.',
    `rail_car_capacity_tons` DECIMAL(18,2) COMMENT 'Design‑specified maximum payload capacity of the rail car, in metric tons.',
    `rail_car_number` STRING COMMENT 'Unique number painted on the rail car (autorack) used for this assignment.',
    `rail_car_type` STRING COMMENT 'Classification of the rail car based on its design and loading capability.. Valid values are `autorack|flatcar|boxcar|tankcar|hopper`',
    `unloading_date` DATE COMMENT 'Scheduled calendar date when the rail car is unloaded at the destination.',
    `unloading_status` STRING COMMENT 'Operational status of the unloading process for this assignment.. Valid values are `pending|in_progress|completed|failed`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the assignment record.',
    `vin_count` STRING COMMENT 'Number of vehicles (VINs) loaded onto the rail car.',
    `vin_list` STRING COMMENT 'Comma‑separated list of Vehicle Identification Numbers (VINs) assigned to this rail car.. Valid values are `^[A-HJ-NPR-Z0-9]{17}(,[A-HJ-NPR-Z0-9]{17})*$`',
    CONSTRAINT pk_rail_car_assignment PRIMARY KEY(`rail_car_assignment_id`)
) COMMENT 'Assignment record linking specific VINs to rail cars within a rail transport order. Captures rail car number, rail car type (autorack), VIN list, loading sequence, origin rail yard, destination rail yard, loading date, and unloading date. Supports rail capacity utilization tracking and VIN-level rail traceability for finished vehicle rail logistics.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` (
    `ckd_kit_shipment_id` BIGINT COMMENT 'System generated unique identifier for the CKD kit shipment record.',
    `carrier_id` BIGINT COMMENT 'Identifier of the logistics carrier handling the shipment.',
    `plant_id` BIGINT COMMENT 'FK to manufacturing.plant',
    `origin_plant_id` BIGINT COMMENT 'FK to manufacturing.plant',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: CKD/SKD kit shipments are a type of outbound shipment; linking to shipment consolidates tracking and cost reporting.',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Real‑time timestamp when the shipment arrived at the destination plant.',
    `actual_departure_timestamp` TIMESTAMP COMMENT 'Real‑time timestamp when the shipment left the origin plant.',
    `bom_reference` STRING COMMENT 'Reference to the BOM that defines the components of the kit.',
    `compliance_status` STRING COMMENT 'Regulatory compliance status of the shipment.. Valid values are `compliant|non_compliant|pending`',
    `container_number` STRING COMMENT 'Unique container identifier used for the shipment.',
    `container_type` STRING COMMENT 'Classification of the container based on its design.. Valid values are `dry|reefer|open_top|flat_rack`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the shipment record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 currency code for monetary amounts.. Valid values are `^[A-Z]{3}$`',
    `customs_invoice_currency` STRING COMMENT 'ISO 4217 currency code of the customs invoice value.. Valid values are `^[A-Z]{3}$`',
    `customs_invoice_value` DECIMAL(18,2) COMMENT 'Declared monetary value of the shipment for customs purposes.',
    `delay_reason` STRING COMMENT 'Free‑text explanation for any delay affecting the shipment.',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount applied to the freight cost.',
    `export_license_number` STRING COMMENT 'Reference number of the export license authorizing the shipment.',
    `freight_cost` DECIMAL(18,2) COMMENT 'Base freight charge for the shipment before discounts or taxes.',
    `hazardous_material_flag` BOOLEAN COMMENT 'True if the shipment contains hazardous materials.',
    `hazardous_material_type` STRING COMMENT 'Classification of hazardous material (e.g., flammable, toxic).',
    `hs_code` STRING COMMENT 'International tariff code for the kit contents.. Valid values are `^d{6,10}$`',
    `incoterms_code` STRING COMMENT 'Incoterms rule governing responsibility and cost allocation. [ENUM-REF-CANDIDATE: EXW|FCA|FOB|CFR|CIF|DAP|DDP — promote to reference product]',
    `kit_part_number` STRING COMMENT 'Part number that uniquely identifies the CKD/SKD kit configuration.',
    `kit_quantity_per_container` STRING COMMENT 'Number of kits packed in each container.',
    `net_cost` DECIMAL(18,2) COMMENT 'Net freight cost after discounts (freight_cost - discount_amount).',
    `notes` STRING COMMENT 'Free‑form field for additional remarks or special instructions.',
    `number_of_kits` STRING COMMENT 'Count of CKD/SKD kits included in the shipment.',
    `otd_flag` BOOLEAN COMMENT 'Indicates whether the shipment arrived within the agreed delivery window.',
    `packing_list_reference` STRING COMMENT 'Reference to the packing list document for the kit.',
    `planned_arrival_timestamp` TIMESTAMP COMMENT 'Scheduled date and time for shipment arrival at the destination plant.',
    `planned_departure_timestamp` TIMESTAMP COMMENT 'Scheduled date and time for shipment departure from the origin plant.',
    `seal_number` STRING COMMENT 'Security seal identifier applied to the container.',
    `shipment_status` STRING COMMENT 'Current lifecycle status of the shipment.. Valid values are `planned|in_transit|delivered|cancelled|held|customs_hold`',
    `temperature_control_required` BOOLEAN COMMENT 'Indicates whether temperature control is required for the shipment.',
    `temperature_max_c` DECIMAL(18,2) COMMENT 'Maximum temperature to be maintained inside the container.',
    `temperature_min_c` DECIMAL(18,2) COMMENT 'Minimum temperature to be maintained inside the container.',
    `tracking_number` STRING COMMENT 'External tracking identifier provided by the carrier.',
    `transport_mode` STRING COMMENT 'Mode of transportation used for the shipment.. Valid values are `sea|rail|truck|air`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the shipment record.',
    `volume_cubic_meters` DECIMAL(18,2) COMMENT 'Total cargo volume of the shipment.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Total weight of the shipment in kilograms.',
    CONSTRAINT pk_ckd_kit_shipment PRIMARY KEY(`ckd_kit_shipment_id`)
) COMMENT 'Shipment record for CKD (Completely Knocked Down) and SKD (Semi Knocked Down) kit consignments dispatched from source plants to assembly plants in global markets. Captures kit part number, BOM reference, origin plant, destination assembly plant, packing list, container numbers, customs invoice value, HS codes, export license reference, and shipment status. Supports CKD/SKD global distribution and import duty management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` (
    `transport_damage_claim_id` BIGINT COMMENT 'System generated unique identifier for each transport damage claim record.',
    `carrier_id` BIGINT COMMENT 'Unique identifier of the carrier responsible for the transport.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Damage claims are filed by the vehicle owner; linking claim to the owning party enables claim processing, financial reporting, and warranty tracking.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Damage claim processing needs the specific connected vehicle to pull diagnostic logs for root‑cause analysis.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Damage claim expenses are charged to the responsible cost center for expense tracking.',
    `employee_id` BIGINT COMMENT 'Unique identifier of the adjuster handling the claim.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Claims are posted to a specific GL account for transportation damage expense reporting.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Links damage claim to specific regulatory requirement governing liability, used in Regulatory Damage Claim Reporting.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Damage claims are filed per shipment; linking to shipment enables claim‑to‑shipment reconciliation and root‑cause analysis.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Damage claim analysis requires SKU to assess warranty and cost impact per vehicle configuration.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Damage claims are processed against the specific sales order to adjust revenue, warranty, and customer compensation.',
    `actual_repair_cost` DECIMAL(18,2) COMMENT 'Final cost incurred to repair the vehicle after claim settlement.',
    `claim_adjuster_code` BIGINT COMMENT 'Unique identifier of the adjuster handling the claim.',
    `claim_adjuster_contact` STRING COMMENT 'Phone number of the claim adjuster.',
    `claim_adjuster_name` STRING COMMENT 'Full name of the claim adjuster.',
    `claim_created_by` STRING COMMENT 'User identifier of the employee who created the claim record.',
    `claim_currency_code` STRING COMMENT 'Three‑letter ISO currency code for the claim amounts.. Valid values are `^[A-Z]{3}$`',
    `claim_document_url` STRING COMMENT 'Link to supporting documentation (photos, reports).',
    `claim_notes` STRING COMMENT 'Additional free‑form notes entered by claim handlers.',
    `claim_number` STRING COMMENT 'External business identifier assigned to the claim, used in communications with carriers and insurers.',
    `claim_policy_number` STRING COMMENT 'Policy number of the insurance covering the transport.',
    `claim_ppm_rate` DECIMAL(18,2) COMMENT 'Parts‑per‑million defect rate associated with the carrier for this claim.',
    `claim_priority` STRING COMMENT 'Priority level assigned to the claim for processing.. Valid values are `low|medium|high|critical`',
    `claim_resolution_timestamp` TIMESTAMP COMMENT 'Date‑time when the claim reached a final resolution (settled, rejected, or closed).',
    `claim_settlement_method` STRING COMMENT 'Method used to settle the claim with the carrier.. Valid values are `direct_payment|credit_note|offset`',
    `claim_settlement_reference` STRING COMMENT 'Reference number or code for the settlement transaction.',
    `claim_source` STRING COMMENT 'Origin of the claim submission.. Valid values are `dealer|plant|logistics|customer`',
    `claim_status` STRING COMMENT 'Current lifecycle status of the claim.. Valid values are `submitted|under_review|approved|rejected|settled|closed`',
    `claim_submission_timestamp` TIMESTAMP COMMENT 'Date‑time when the claim was initially filed.',
    `claim_type` STRING COMMENT 'Category of claim based on cause of damage.. Valid values are `physical_damage|water_damage|theft|other`',
    `claim_updated_by` STRING COMMENT 'User identifier of the employee who last updated the claim record.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the claim record was created.',
    `damage_category` STRING COMMENT 'Classification of damage type for reporting and analytics.. Valid values are `exterior|interior|mechanical|electrical|other`',
    `damage_description` STRING COMMENT 'Narrative description of the damage observed on the vehicle during transport.',
    `damage_location` STRING COMMENT 'Specific area of the vehicle where damage occurred (e.g., front bumper, left door).',
    `damage_severity` STRING COMMENT 'Severity rating of the damage based on repair impact.. Valid values are `minor|moderate|severe|total_loss`',
    `estimated_repair_cost` DECIMAL(18,2) COMMENT 'Initial cost estimate for repairing the reported damage.',
    `insurance_claim_number` STRING COMMENT 'Identifier assigned by the insurer for the related claim.',
    `is_fraud_flag` BOOLEAN COMMENT 'Indicates whether the claim is suspected of fraud.',
    `otd_impact_flag` BOOLEAN COMMENT 'True if the damage caused a missed on‑time delivery commitment.',
    `repair_estimate_source` STRING COMMENT 'Source of the repair cost estimate.. Valid values are `dealer|OEM|third_party`',
    `settlement_amount` DECIMAL(18,2) COMMENT 'Final amount paid to the claimant after claim approval.',
    `settlement_currency_code` STRING COMMENT 'ISO currency code for the settlement amount.. Valid values are `^[A-Z]{3}$`',
    `settlement_date` DATE COMMENT 'Date on which the settlement payment was made.',
    `transport_mode` STRING COMMENT 'Mode of transportation used for the shipment (e.g., truck, rail).. Valid values are `truck|rail|vessel|air|intermodal`',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent modification to the claim record.',
    CONSTRAINT pk_transport_damage_claim PRIMARY KEY(`transport_damage_claim_id`)
) COMMENT 'Record of vehicle damage claims raised against carriers for damage occurring during transport. Captures VIN, damage description, damage location on vehicle, estimated repair cost, carrier responsible, claim submission date, claim status, settlement amount, and resolution date. Supports carrier liability management, insurance recovery, and damage PPM tracking per carrier and transport mode.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` (
    `freight_invoice_id` BIGINT COMMENT 'System-generated unique identifier for the freight invoice record.',
    `aftersales_warranty_claim_id` BIGINT COMMENT 'Foreign key linking to aftersales.warranty_claim. Business justification: Business need: Freight invoices are associated with warranty claims for cost recovery and audit trails.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Freight invoices are billed to the end‑customer; associating each invoice with the customer party supports financial reconciliation and compliance reporting.',
    `carrier_id` BIGINT COMMENT 'Unique identifier of the carrier that provided the transport service.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Freight invoicing ties each invoice to the specific shipment for cost allocation and audit.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Freight invoicing is linked to the sales order for full cost‑to‑serve accounting and profitability analysis.',
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
    `lane_code` STRING COMMENT 'Code representing the origin‑to‑destination lane for the shipment.',
    `net_amount` DECIMAL(18,2) COMMENT 'Final amount payable after discounts and taxes.',
    `number_of_units` STRING COMMENT 'Count of individual units (vehicles, kits, parts) covered by the invoice.',
    `otd_flag` BOOLEAN COMMENT 'Indicates whether the shipment met the agreed on‑time delivery commitment.',
    `payment_date` DATE COMMENT 'Date on which the invoice was actually paid.',
    `payment_due_date` DATE COMMENT 'Date by which the invoice must be paid according to contract terms.',
    `payment_status` STRING COMMENT 'Current payment processing status of the invoice.. Valid values are `pending|approved|paid|rejected|partial|overdue`',
    `remarks` STRING COMMENT 'Free‑form text for additional comments or notes about the invoice.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax component included in the invoice, if applicable.',
    `transport_mode` STRING COMMENT 'Mode of transportation used for the shipment (e.g., road, rail, sea, air, intermodal).. Valid values are `road|rail|sea|air|intermodal`',
    `transport_order_number` STRING COMMENT 'Reference number of the transport order linked to this invoice.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the freight invoice record.',
    `variance_amount` DECIMAL(18,2) COMMENT 'Difference between the invoiced amount and the agreed rate‑based amount.',
    `volume_cbm` DECIMAL(18,2) COMMENT 'Total cubic meter volume of the shipment.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Total weight of the shipment associated with the invoice, expressed in kilograms.',
    CONSTRAINT pk_freight_invoice PRIMARY KEY(`freight_invoice_id`)
) COMMENT 'Carrier freight invoice received for transport services rendered on finished vehicle or CKD/SKD shipments. Captures invoice number, carrier, invoice date, transport order references, lane, transport mode, invoiced amount, currency, agreed rate, variance amount, approval status, and payment reference. Supports freight cost management, carrier invoice verification against contracted rates, and logistics cost accounting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` (
    `transport_rate_id` BIGINT COMMENT 'System-generated unique identifier for the transport rate record.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to logistics.carrier. Business justification: Transport rates are defined per carrier; adding carrier_id creates the necessary relationship.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Rate creation is performed by a rate analyst employee; linking supports audit of rate changes.',
    `lane_id` BIGINT COMMENT 'Foreign key linking to logistics.lane. Business justification: Rates are also specific to a logistics lane; adding logistics_lane_id links rates to lanes and resolves lanes silo.',
    `accessorial_charges` DECIMAL(18,2) COMMENT 'Additional fixed charges (e.g., lift‑gate, detention) associated with the lane.',
    `compliance_flag` BOOLEAN COMMENT 'Indicates whether the rate complies with applicable transport regulations (e.g., IATF, EPA).',
    `container_type` STRING COMMENT 'Type of container used for the shipment, if applicable.. Valid values are `standard|reefer|flatbed|open_top`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the rate record was first created.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the rate amount.. Valid values are `USD|EUR|JPY|CNY|GBP`',
    `destination_location_code` STRING COMMENT 'Code of the destination dealer or distribution center.',
    `effective_from` DATE COMMENT 'Date when the transport rate becomes valid.',
    `effective_until` DATE COMMENT 'Date when the transport rate expires (null if open‑ended).',
    `fuel_surcharge_percent` DECIMAL(18,2) COMMENT 'Percentage surcharge applied to the base rate to cover fuel price volatility.',
    `notes` STRING COMMENT 'Free‑form comments or special conditions related to the rate.',
    `origin_location_code` STRING COMMENT 'Code of the origin plant or warehouse where the shipment starts.',
    `rate_amount` DECIMAL(18,2) COMMENT 'Base monetary amount agreed for the lane before surcharges.',
    `rate_code` STRING COMMENT 'Business identifier code for the transport rate contract.',
    `rate_source_system` STRING COMMENT 'Source system where the rate originated.. Valid values are `SAP|Oracle|Custom`',
    `rate_version` STRING COMMENT 'Incremental version number for the rate record to track revisions.',
    `transport_mode` STRING COMMENT 'Mode of transportation for the lane (e.g., road, rail, sea, air).. Valid values are `road|rail|sea|air`',
    `transport_rate_status` STRING COMMENT 'Current lifecycle status of the rate contract.. Valid values are `active|inactive|pending|expired`',
    `unit_of_measure` STRING COMMENT 'Measurement unit that the rate amount applies to.. Valid values are `per_vehicle|per_container|per_ton|per_cbm`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the rate record.',
    `vehicle_type` STRING COMMENT 'Classification of vehicle type applicable to the rate.. Valid values are `sedan|suv|truck|van|e_vehicle`',
    `volume_capacity_cubic_meters` DECIMAL(18,2) COMMENT 'Maximum volume that can be transported under this rate.',
    `weight_capacity_tons` DECIMAL(18,2) COMMENT 'Maximum weight that can be transported under this rate.',
    CONSTRAINT pk_transport_rate PRIMARY KEY(`transport_rate_id`)
) COMMENT 'Contracted transport rate master for carrier lanes, defining the agreed cost per unit (vehicle or container) by origin-destination pair, transport mode, vehicle type/size class, and effective date range. Captures base rate, fuel surcharge structure, accessorial charges, currency, and rate validity period. Used for freight cost estimation, invoice verification, and logistics cost planning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`lane` (
    `lane_id` BIGINT COMMENT 'Primary key for lane',
    `carrier_id` BIGINT COMMENT 'add column carrier_id (BIGINT) with FK to logistics.carrier.carrier_id - transport lanes are serviced by specific carriers',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Lane cost analysis requires linking each logistics lane to a cost center for profitability tracking.',
    CONSTRAINT pk_lane PRIMARY KEY(`lane_id`)
) COMMENT 'Master record defining a logistics lane as an origin-destination pair for finished vehicle or CKD/SKD transport. Captures origin facility (plant/compound/port), destination facility (dealer/compound/port), transport mode, distance, standard transit time, lane status, and assigned primary/backup carriers. Serves as the reference for route planning, rate assignment, and OTD benchmarking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`logistics_pdi_inspection` (
    `logistics_pdi_inspection_id` BIGINT COMMENT 'Unique identifier for the logistics_pdi_inspection data product (auto-inserted pre-linking).',
    `logistics_delivery_schedule_id` BIGINT COMMENT 'Foreign key linking to logistics.logistics_delivery_schedule. Business justification: PDI inspections are scheduled as part of a delivery schedule; linking provides context and enables reporting on inspection outcomes per schedule.',
    `aftersales_pdi_inspection_id` BIGINT COMMENT '',
    CONSTRAINT pk_logistics_pdi_inspection PRIMARY KEY(`logistics_pdi_inspection_id`)
) COMMENT 'Pre-Delivery Inspection (PDI) record for finished vehicles conducted at compound or dealer prior to customer handover. Captures VIN, inspection date, inspection location (compound/dealer), inspector ID, checklist completion status, defects found, defect severity, rectification actions, and PDI pass/fail outcome. Ensures vehicle quality at point of delivery and supports warranty baseline establishment.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` (
    `export_declaration_id` BIGINT COMMENT 'System-generated unique identifier for the export declaration record.',
    `carrier_id` BIGINT COMMENT 'FK to logistics.carrier',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Export processing costs are charged to a cost center for compliance and cost recovery.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant exporting the goods.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Ensures each export declaration references the applicable regulatory requirement for audit and customs compliance.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Export declaration must be linked to the shipment for customs compliance tracking.',
    `clearance_status` STRING COMMENT 'Current status of customs clearance for the declaration.. Valid values are `cleared|pending|rejected`',
    `clearance_timestamp` TIMESTAMP COMMENT 'Date and time when customs cleared the export declaration.',
    `compliance_notes` STRING COMMENT 'Free‑form text for any additional regulatory or compliance remarks.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the export declaration record was first created in the system.',
    `customs_authority_reference` STRING COMMENT 'Identifier assigned by the customs authority for tracking the declaration.',
    `declaration_number` STRING COMMENT 'External reference number assigned by the exporting organization for this declaration.',
    `declared_value_amount` DECIMAL(18,2) COMMENT 'Total monetary value declared for customs purposes, before duties and taxes.',
    `declared_value_currency` STRING COMMENT 'Three‑letter ISO 4217 currency code of the declared value.. Valid values are `[A-Z]{3}`',
    `destination_country_code` STRING COMMENT 'ISO 3166‑1 alpha‑3 code of the country receiving the shipment.. Valid values are `[A-Z]{3}`',
    `duty_amount` DECIMAL(18,2) COMMENT 'Duty payable to customs based on the declared value and HS code.',
    `export_declaration_status` STRING COMMENT 'Current processing state of the export declaration.. Valid values are `draft|submitted|cleared|rejected`',
    `export_license_number` STRING COMMENT 'Reference number of the export license authorizing the shipment.',
    `export_type` STRING COMMENT 'Category of goods being exported (complete vehicle, CKD kit, SKD kit, or parts).. Valid values are `vehicle|ckd_kit|skd_kit|parts`',
    `hazardous_material_type` STRING COMMENT 'Specific classification of hazardous material, if applicable.',
    `hs_code` STRING COMMENT 'Customs tariff classification code for the exported goods.. Valid values are `[0-9]{6,10}`',
    `incoterms_code` STRING COMMENT 'International commercial term governing responsibility and cost allocation. [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAT|DAP|DDP — 7 candidates stripped; promote to reference product]',
    `is_hazardous` BOOLEAN COMMENT 'Indicates whether the shipment contains hazardous materials.',
    `net_value_amount` DECIMAL(18,2) COMMENT 'Declared value after deducting duties and any applicable taxes.',
    `otd_flag` BOOLEAN COMMENT 'Indicates whether the shipment met the promised delivery schedule.',
    `quantity` STRING COMMENT 'Total number of individual items or units exported.',
    `submission_timestamp` TIMESTAMP COMMENT 'Date and time when the export declaration was submitted to customs.',
    `temperature_control_required` BOOLEAN COMMENT 'Flag indicating whether temperature‑controlled transport is required.',
    `temperature_max_c` DECIMAL(18,2) COMMENT 'Maximum temperature in Celsius allowed for the shipment.',
    `temperature_min_c` DECIMAL(18,2) COMMENT 'Minimum temperature in Celsius required for the shipment.',
    `transport_mode` STRING COMMENT 'Primary mode of transportation used for the export shipment.. Valid values are `road|rail|sea|air`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the export declaration record.',
    `vin_list` STRING COMMENT 'Comma‑separated list of VINs included in the export shipment.',
    `volume_cbm` DECIMAL(18,2) COMMENT 'Total cargo volume in cubic meters.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Aggregate gross weight of the exported goods in kilograms.',
    CONSTRAINT pk_export_declaration PRIMARY KEY(`export_declaration_id`)
) COMMENT 'Customs export declaration record for finished vehicles and CKD/SKD kits shipped to international markets. Captures declaration number, exporting plant, destination country, HS codes, declared value, currency, export license number, customs authority reference, submission date, clearance date, and declaration status. Supports regulatory compliance with DOT, UNECE, and local customs authorities for global distribution.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` (
    `import_declaration_id` BIGINT COMMENT 'Unique surrogate key for the import declaration record.',
    `company_code_id` BIGINT COMMENT 'Identifier of the legal entity importing the goods.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Import clearance expenses are allocated to a cost center for landed cost accounting.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: Associates import declaration with the governing regulatory requirement for compliance verification.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Import declaration ties inbound shipments to customs records for regulatory reporting.',
    `arrival_timestamp` TIMESTAMP COMMENT 'Timestamp when the shipment arrived at the port of entry.',
    `carrier_name` STRING COMMENT 'Name of the logistics carrier handling the shipment.',
    `clearance_date` DATE COMMENT 'Date of customs clearance (date component).',
    `clearance_timestamp` TIMESTAMP COMMENT 'Date and time when customs clearance was granted.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the import declaration record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for monetary values.',
    `customs_authority` STRING COMMENT 'Name of the customs agency that processed the declaration.',
    `customs_document_number` STRING COMMENT 'Reference number of the supporting customs documentation.',
    `customs_value_amount` DECIMAL(18,2) COMMENT 'Declared customs value of the imported goods.',
    `declaration_number` STRING COMMENT 'Official customs declaration number assigned by the customs authority.',
    `departure_timestamp` TIMESTAMP COMMENT 'Timestamp when the shipment left the port of exit.',
    `duty_amount` DECIMAL(18,2) COMMENT 'Duty amount payable for the import declaration.',
    `duty_rate_percent` DECIMAL(18,2) COMMENT 'Applicable duty rate expressed as a percentage.',
    `exchange_rate_date` DATE COMMENT 'Date on which the exchange rate was applied.',
    `exchange_rate_to_usd` DECIMAL(18,2) COMMENT 'Currency exchange rate to US dollars used for conversion.',
    `freight_cost` DECIMAL(18,2) COMMENT 'Cost of freight transportation for the shipment.',
    `homologation_status` STRING COMMENT 'Status of vehicle homologation approval for the destination market.. Valid values are `pending|approved|rejected`',
    `hs_code` STRING COMMENT 'International tariff classification code for the goods.. Valid values are `^[0-9]{6,10}$`',
    `hs_code_description` STRING COMMENT 'Textual description of the HS tariff classification.',
    `import_cost_total` DECIMAL(18,2) COMMENT 'Sum of customs value, duty, freight, and insurance costs.',
    `import_declaration_status` STRING COMMENT 'Current lifecycle status of the import declaration.. Valid values are `pending|submitted|cleared|rejected|cancelled`',
    `import_duty_paid_flag` BOOLEAN COMMENT 'Indicates whether the customs duty has been fully paid.',
    `import_duty_payment_date` DATE COMMENT 'Date on which the customs duty was paid.',
    `import_duty_payment_method` STRING COMMENT 'Method used to settle the customs duty.. Valid values are `bank_transfer|credit_card|cash|cheque`',
    `import_license_expiry_date` DATE COMMENT 'Expiration date of the import license.',
    `import_license_issue_date` DATE COMMENT 'Date when the import license was issued.',
    `import_license_number` STRING COMMENT 'Reference number of the import license authorizing the shipment.',
    `import_license_valid` BOOLEAN COMMENT 'Indicates whether the import license is currently valid.',
    `import_type` STRING COMMENT 'Classification of the imported item (finished vehicle, CKD kit, or SKD kit).. Valid values are `finished_vehicle|ckd_kit|skd_kit`',
    `insurance_cost` DECIMAL(18,2) COMMENT 'Insurance premium paid for the shipment.',
    `model_code` STRING COMMENT 'Manufacturers model code for the imported vehicle or kit.',
    `model_year` STRING COMMENT 'Model year of the vehicle or kit being imported.',
    `origin_country_code` STRING COMMENT 'Country of origin of the imported goods.. Valid values are `^[A-Z]{3}$`',
    `port_of_entry` STRING COMMENT 'Customs port where the goods entered the destination market.',
    `port_of_exit` STRING COMMENT 'Port from which the goods departed the origin country.',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether the import complies with all applicable regulations.',
    `remarks` STRING COMMENT 'Free‑form comments or notes related to the declaration.',
    `submission_timestamp` TIMESTAMP COMMENT 'Date and time when the declaration was submitted to customs.',
    `total_landed_cost` DECIMAL(18,2) COMMENT 'Aggregate cost including customs value, duty, freight, and insurance.',
    `transport_mode` STRING COMMENT 'Primary mode of transport used for the shipment.. Valid values are `sea|air|rail|road|multimodal`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the import declaration record.',
    `vehicle_vin` STRING COMMENT 'VIN of the imported vehicle, if applicable.',
    `version` STRING COMMENT 'Version number for the declaration record to support revisions.',
    CONSTRAINT pk_import_declaration PRIMARY KEY(`import_declaration_id`)
) COMMENT 'Customs import declaration record for finished vehicles and CKD/SKD kits received at destination markets. Captures declaration number, importing entity, origin country, HS codes, customs value, duty rate, duty amount paid, import license reference, customs authority reference, submission date, clearance date, and declaration status. Supports homologation compliance and import duty cost tracking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` (
    `vehicle_handover_id` BIGINT COMMENT 'System-generated unique identifier for each vehicle handover record.',
    `aftersales_repair_order_id` BIGINT COMMENT 'Foreign key linking to aftersales.repair_order. Business justification: Process: Vehicle handover records are tied to the corresponding repair order to monitor service flow and liability.',
    `compliance_document_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_document. Business justification: Needed for Vehicle Handover Compliance Certification linking handover record to the vehicles compliance certificate.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Vehicle handover workflow associates the handed‑over VIN with the connected vehicle to trigger post‑delivery service enrollment.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Vehicle Handover process requires linking handover record to the equipment asset for warranty activation and service history.',
    `finished_vehicle_stock_id` BIGINT COMMENT 'Foreign key linking to inventory.finished_vehicle_stock. Business justification: Needed for Vehicle Handover Warranty Traceability: links handover record to inventory vehicle record for warranty and compliance tracking.',
    `production_order_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_order. Business justification: Dealer handover requires linking to the production order to support warranty registration and regulatory compliance.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Revenue from vehicle handover is recognized in the responsible profit center for margin reporting.',
    `party_id` BIGINT COMMENT 'Unique identifier of the receiving party (dealer or customer).',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Linking handover to shipment provides traceability from transport to dealer receipt.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Handover record needs SKU to capture exact vehicle configuration handed to dealer.',
    `employee_id` BIGINT COMMENT 'Identifier of the system user who created the handover record.',
    `vehicle_employee_id` BIGINT COMMENT 'Identifier of the system user who created the handover record.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Final handover of a vehicle to the dealer is tied to the sales order for warranty activation and final invoicing.',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`load_plan` (
    `load_plan_id` BIGINT COMMENT 'Unique identifier for the load_plan data product (auto-inserted pre-linking).',
    `consolidated_load_plan_id` BIGINT COMMENT 'Self-referencing FK on load_plan (consolidated_load_plan_id)',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Load planning cost estimates are budgeted against a cost center for transportation budgeting.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Load planning team assigns a planner employee to each load plan; needed for load efficiency reporting.',
    CONSTRAINT pk_load_plan PRIMARY KEY(`load_plan_id`)
) COMMENT 'Load planning record defining how finished vehicles are grouped and assigned to transport units (truck trailers, rail autoracks, RoRo vessel decks) for a given shipment or transport order. Captures load plan number, transport unit type, vehicle count, VIN assignments, weight/dimension constraints, loading sequence, special handling requirements (e.g., EV battery transport restrictions), and plan status. Supports transport utilization optimization and loading dock scheduling.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`vehicle_shipment_assignment` (
    `vehicle_shipment_assignment_id` BIGINT COMMENT 'Primary key for the vehicle_shipment_assignment association',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to the connected vehicle assigned to the shipment.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to the shipment containing the vehicle.',
    `position_in_container` STRING COMMENT 'The sequential slot or position of the vehicle within the shipment container.',
    `vehicle_shipment_status` STRING COMMENT 'Status of the vehicle within the context of this shipment.',
    CONSTRAINT pk_vehicle_shipment_assignment PRIMARY KEY(`vehicle_shipment_assignment_id`)
) COMMENT 'Represents the assignment of a connected vehicle to a specific outbound shipment. Each record captures the relationship between one shipment and one connected vehicle and includes attributes that are specific to that assignment, such as the vehicles position in the container and its status within the shipment.. Existence Justification: A shipment can contain many connected vehicles and a connected vehicle can be part of multiple shipments over its lifecycle (e.g., initial plant shipment, returns, service relocations). Logistics planners actively create and maintain records linking each vehicle to a shipment, and the link carries attributes such as the vehicles position in the container.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`route` (
    `route_id` BIGINT COMMENT 'Primary key for route',
    `carrier_id` BIGINT COMMENT 'FK to logistics.carrier',
    `return_route_id` BIGINT COMMENT 'Self-referencing FK on route (return_route_id)',
    `actual_arrival_time` TIMESTAMP COMMENT 'Real‑time arrival timestamp recorded when a shipment reaches the destination.',
    `actual_departure_time` TIMESTAMP COMMENT 'Real‑time departure timestamp recorded when a shipment leaves the origin.',
    `average_travel_time_minutes` STRING COMMENT 'Historical average travel time for the route in minutes.',
    `carrier_mode` STRING COMMENT 'Primary transportation mode used on the route.',
    `route_code` STRING COMMENT 'Standardized alphanumeric code used to reference the route in logistics systems.',
    `compliance_status` STRING COMMENT 'Current regulatory compliance state of the route.',
    `cost_usd` DECIMAL(18,2) COMMENT 'Average cost incurred to operate the route per shipment, expressed in US dollars.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the route record was first created.',
    `route_description` STRING COMMENT 'Free‑form text describing the route, its purpose, and any special handling notes.',
    `destination_location` STRING COMMENT 'Standard code of the ending location or depot for the route.',
    `distance_km` DECIMAL(18,2) COMMENT 'Typical distance covered by the route in kilometers.',
    `effective_from` DATE COMMENT 'Date when the route definition becomes active.',
    `effective_until` DATE COMMENT 'Date when the route definition is retired or superseded; null if open‑ended.',
    `emissions_kg_co2` DECIMAL(18,2) COMMENT 'Estimated carbon dioxide emissions generated per shipment on the route.',
    `fuel_consumption_l_per_100km` DECIMAL(18,2) COMMENT 'Typical fuel consumption for the route expressed in liters per 100 kilometers.',
    `is_express` BOOLEAN COMMENT 'Indicates whether the route supports express (time‑critical) shipments.',
    `last_maintenance_date` DATE COMMENT 'Date of the most recent maintenance activity affecting the route (e.g., road work, carrier audit).',
    `maintenance_interval_days` STRING COMMENT 'Standard number of days between required maintenance checks for the route.',
    `max_load_capacity_tons` DECIMAL(18,2) COMMENT 'Maximum payload the route can handle, expressed in metric tons.',
    `route_name` STRING COMMENT 'Human‑readable name of the transportation route.',
    `notes` STRING COMMENT 'Additional free‑form remarks or special instructions for the route.',
    `on_time_performance_pct` DECIMAL(18,2) COMMENT 'Percentage of shipments that arrived on or before the scheduled arrival time.',
    `origin_location` STRING COMMENT 'Standard code of the starting location or depot for the route.',
    `priority_level` STRING COMMENT 'Business priority assigned to the route for planning and allocation.',
    `regulatory_region` STRING COMMENT 'Geopolitical region governing compliance requirements for the route.',
    `route_group` STRING COMMENT 'Logical grouping identifier for related routes (e.g., region, corridor).',
    `scheduled_arrival_time` TIMESTAMP COMMENT 'Planned arrival date and time for shipments on this route.',
    `scheduled_departure_time` TIMESTAMP COMMENT 'Planned departure date and time for shipments on this route.',
    `route_status` STRING COMMENT 'Current operational status of the route.',
    `route_type` STRING COMMENT 'Category describing the geographic scope of the route.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the route record.',
    CONSTRAINT pk_route PRIMARY KEY(`route_id`)
) COMMENT 'Master reference table for route. Referenced by route_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`container` (
    `container_id` BIGINT COMMENT 'Primary key for container',
    `carrier_id` BIGINT COMMENT 'FK to logistics.carrier',
    `parent_container_id` BIGINT COMMENT 'Self-referencing FK on container (parent_container_id)',
    `actual_arrival_date` DATE COMMENT 'Date the container actually arrived at destination.',
    `condition` STRING COMMENT 'Overall physical condition of the container.',
    `container_number` STRING COMMENT 'Standard alphanumeric container identification number printed on the container exterior.',
    `container_status` STRING COMMENT 'Current operational state of the container within the logistics network.',
    `container_type` STRING COMMENT 'Category of container based on design and intended cargo (e.g., dry, refrigerated).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the container record was first created in the system.',
    `current_location` STRING COMMENT 'Identifier of the facility, yard, or terminal where the container is presently located.',
    `customs_clearance_date` DATE COMMENT 'Date when the container cleared customs.',
    `customs_status` STRING COMMENT 'Current customs processing status for the container.',
    `damage_description` STRING COMMENT 'Narrative description of any reported damage.',
    `damage_report_flag` BOOLEAN COMMENT 'True if a damage incident has been recorded for the container.',
    `departure_date` DATE COMMENT 'Date the container left the origin facility.',
    `estimated_arrival_date` DATE COMMENT 'Planned date for the containers arrival at destination.',
    `gps_latitude` DOUBLE COMMENT 'Latitude coordinate from the containers GPS device.',
    `gps_longitude` DOUBLE COMMENT 'Longitude coordinate from the containers GPS device.',
    `humidity_control` BOOLEAN COMMENT 'Indicates whether the container can regulate humidity levels.',
    `last_event_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent logistics event associated with the container.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent safety and condition inspection.',
    `lease_end_date` DATE COMMENT 'Date when the container lease or ownership period ends; null if open‑ended.',
    `lease_start_date` DATE COMMENT 'Date when the container lease or ownership period began.',
    `location_timestamp` TIMESTAMP COMMENT 'Date and time when the current location was recorded.',
    `maintenance_status` STRING COMMENT 'Current maintenance compliance of the container.',
    `max_payload_kg` DECIMAL(18,2) COMMENT 'Maximum cargo weight the container can carry, calculated as weight_capacity minus tare_weight.',
    `next_maintenance_due` DATE COMMENT 'Planned date for the next scheduled maintenance activity.',
    `owner_company` STRING COMMENT 'Legal entity that owns or leases the container.',
    `refrigerated` BOOLEAN COMMENT 'True if the container is a refrigerated (reefer) unit.',
    `seal_number` STRING COMMENT 'Unique identifier of the security seal applied to the container.',
    `size_feet` STRING COMMENT 'Standard length of the container in feet (e.g., 20, 40).',
    `tare_weight_kg` DECIMAL(18,2) COMMENT 'Weight of the empty container without any cargo.',
    `temperature_control` BOOLEAN COMMENT 'Indicates whether the container is equipped with temperature regulation.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the container record.',
    `voyage_number` STRING COMMENT 'Identifier for the specific shipment voyage the container is part of.',
    `weight_capacity_kg` DECIMAL(18,2) COMMENT 'Maximum allowable gross weight for the container, including cargo and tare weight.',
    CONSTRAINT pk_container PRIMARY KEY(`container_id`)
) COMMENT 'Master reference table for container. Referenced by container_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` (
    `shipping_line_id` BIGINT COMMENT 'Primary key for shipping_line',
    `parent_shipping_line_id` BIGINT COMMENT 'Self-referencing FK on shipping_line (parent_shipping_line_id)',
    `address_line1` STRING COMMENT 'First line of the shipping lines primary office address.',
    `address_line2` STRING COMMENT 'Second line of the shipping lines primary office address (optional).',
    `carrier_type` STRING COMMENT 'Category of transport services provided by the shipping line.',
    `city` STRING COMMENT 'City of the shipping lines primary office.',
    `compliance_status` STRING COMMENT 'Current compliance status of the shipping line with regulatory and internal standards.',
    `country` STRING COMMENT 'Three‑letter ISO 3166‑1 alpha‑3 country code of the shipping lines primary office. [ENUM-REF-CANDIDATE: USA|CAN|MEX|GBR|DEU|FRA|JPN|CHN|KOR|BRA|IND|AUS — promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the shipping line record was first created in the system.',
    `effective_from` DATE COMMENT 'Date when the shipping line became an active carrier for the enterprise.',
    `effective_until` DATE COMMENT 'Date when the shipping lines contract or relationship ends (null if open‑ended).',
    `fleet_size` STRING COMMENT 'Total number of vessels or transport units owned or operated by the carrier.',
    `hub_location` STRING COMMENT 'Main operational hub or terminal used by the carrier for consolidation.',
    `insurance_cert_number` STRING COMMENT 'Reference number of the carriers liability insurance certificate.',
    `max_container_capacity` STRING COMMENT 'Maximum number of twenty‑foot equivalent units the carrier can handle per shipment.',
    `shipping_line_name` STRING COMMENT 'Full legal name of the shipping line (carrier).',
    `notes` STRING COMMENT 'Free‑form field for any supplemental information about the shipping line.',
    `postal_code` STRING COMMENT 'Postal/ZIP code of the shipping lines primary office.',
    `preferred_currency` STRING COMMENT 'ISO 4217 currency code used for billing and settlements with the carrier.',
    `primary_contact_email` STRING COMMENT 'Email address for the primary contact.',
    `primary_contact_name` STRING COMMENT 'Name of the primary business contact for the shipping line.',
    `primary_contact_phone` STRING COMMENT 'Telephone number for the primary contact.',
    `rating_score` DECIMAL(18,2) COMMENT 'Average performance rating (0.00‑5.00) assigned by the enterprise based on service quality, timeliness, and safety.',
    `scac_code` STRING COMMENT 'Four‑character code that uniquely identifies the carrier in transportation systems.',
    `service_region` STRING COMMENT 'Geographic region(s) where the carrier provides services (e.g., North America, Europe).',
    `short_name` STRING COMMENT 'Abbreviated or commonly used short name for the shipping line.',
    `state` STRING COMMENT 'State or province of the shipping lines primary office.',
    `shipping_line_status` STRING COMMENT 'Current operational status of the shipping line within the enterprise.',
    `tax_identifier` STRING COMMENT 'Government‑issued tax identifier for the carrier entity.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the shipping line record.',
    `website_url` STRING COMMENT 'Public website URL of the shipping line.',
    CONSTRAINT pk_shipping_line PRIMARY KEY(`shipping_line_id`)
) COMMENT 'Master reference table for shipping_line. Referenced by shipping_line_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ADD CONSTRAINT `fk_logistics_shipment_leg_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ADD CONSTRAINT `fk_logistics_shipment_leg_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ADD CONSTRAINT `fk_logistics_vehicle_transport_order_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ADD CONSTRAINT `fk_logistics_vehicle_transport_order_load_plan_id` FOREIGN KEY (`load_plan_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`load_plan`(`load_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ADD CONSTRAINT `fk_logistics_vehicle_transport_order_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ADD CONSTRAINT `fk_logistics_logistics_delivery_schedule_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ADD CONSTRAINT `fk_logistics_logistics_delivery_schedule_route_id` FOREIGN KEY (`route_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`route`(`route_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ADD CONSTRAINT `fk_logistics_logistics_delivery_schedule_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ADD CONSTRAINT `fk_logistics_carrier_performance_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ADD CONSTRAINT `fk_logistics_compound_movement_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ADD CONSTRAINT `fk_logistics_compound_movement_vehicle_compound_id` FOREIGN KEY (`vehicle_compound_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`vehicle_compound`(`vehicle_compound_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`container`(`container_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ADD CONSTRAINT `fk_logistics_port_processing_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ADD CONSTRAINT `fk_logistics_port_processing_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ADD CONSTRAINT `fk_logistics_vessel_voyage_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ADD CONSTRAINT `fk_logistics_vessel_voyage_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ADD CONSTRAINT `fk_logistics_rail_car_assignment_vehicle_transport_order_id` FOREIGN KEY (`vehicle_transport_order_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`vehicle_transport_order`(`vehicle_transport_order_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ADD CONSTRAINT `fk_logistics_ckd_kit_shipment_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ADD CONSTRAINT `fk_logistics_ckd_kit_shipment_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ADD CONSTRAINT `fk_logistics_transport_damage_claim_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ADD CONSTRAINT `fk_logistics_transport_damage_claim_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ADD CONSTRAINT `fk_logistics_transport_rate_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ADD CONSTRAINT `fk_logistics_transport_rate_lane_id` FOREIGN KEY (`lane_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`lane`(`lane_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` ADD CONSTRAINT `fk_logistics_lane_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_pdi_inspection` ADD CONSTRAINT `fk_logistics_logistics_pdi_inspection_logistics_delivery_schedule_id` FOREIGN KEY (`logistics_delivery_schedule_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule`(`logistics_delivery_schedule_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ADD CONSTRAINT `fk_logistics_export_declaration_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ADD CONSTRAINT `fk_logistics_export_declaration_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ADD CONSTRAINT `fk_logistics_import_declaration_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`load_plan` ADD CONSTRAINT `fk_logistics_load_plan_consolidated_load_plan_id` FOREIGN KEY (`consolidated_load_plan_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`load_plan`(`load_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_shipment_assignment` ADD CONSTRAINT `fk_logistics_vehicle_shipment_assignment_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ADD CONSTRAINT `fk_logistics_route_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ADD CONSTRAINT `fk_logistics_route_return_route_id` FOREIGN KEY (`return_route_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`route`(`route_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ADD CONSTRAINT `fk_logistics_container_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ADD CONSTRAINT `fk_logistics_container_parent_container_id` FOREIGN KEY (`parent_container_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`container`(`container_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ADD CONSTRAINT `fk_logistics_shipping_line_parent_shipping_line_id` FOREIGN KEY (`parent_shipping_line_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipping_line`(`shipping_line_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`logistics` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`logistics` SET TAGS ('dbx_domain' = 'logistics');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` SET TAGS ('dbx_subdomain' = 'outbound_distribution');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Identifier (CARRIER_ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `part_master_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `production_order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` SET TAGS ('dbx_subdomain' = 'outbound_distribution');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `shipment_leg_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Leg Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Facility Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `goods_movement_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Movement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `shipment_functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Facility Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Identifier');
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
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` SET TAGS ('dbx_subdomain' = 'outbound_distribution');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `vehicle_transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Transport Order Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `finished_vehicle_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Transport Order ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Dispatcher Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `load_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Load Plan ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` SET TAGS ('dbx_subdomain' = 'outbound_distribution');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `logistics_delivery_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for delivery_schedule');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `finished_vehicle_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `logistics_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `route_id` SET TAGS ('dbx_business_glossary_term' = 'Route Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Scheduler Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `actual_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Departure Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `arrival_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Arrival Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `cost_actual` SET TAGS ('dbx_business_glossary_term' = 'Actual Transportation Cost');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `cost_estimate` SET TAGS ('dbx_business_glossary_term' = 'Estimated Transportation Cost');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP|CAD');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `customs_document_required` SET TAGS ('dbx_business_glossary_term' = 'Customs Documentation Required Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `delivery_window_end` SET TAGS ('dbx_business_glossary_term' = 'Delivery Window End');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `delivery_window_start` SET TAGS ('dbx_business_glossary_term' = 'Delivery Window Start');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `departure_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Departure Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `estimated_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Delivery Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `export_import_flag` SET TAGS ('dbx_business_glossary_term' = 'Export/Import Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `freight_class` SET TAGS ('dbx_business_glossary_term' = 'Freight Class');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `incoterms` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DDP');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `is_expedited` SET TAGS ('dbx_business_glossary_term' = 'Expedited Delivery Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `is_hazardous` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `last_mile_delivery_method` SET TAGS ('dbx_business_glossary_term' = 'Last‑Mile Delivery Method');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `last_mile_delivery_method` SET TAGS ('dbx_value_regex' = 'dealer|direct|third_party|pickup|locker|drone');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `logistics_delivery_schedule_status` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `logistics_delivery_schedule_status` SET TAGS ('dbx_value_regex' = 'planned|released|in_transit|delivered|cancelled|on_hold');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'General Notes');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `otd_actual_date` SET TAGS ('dbx_business_glossary_term' = 'On‑Time Delivery Actual Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `otd_target_date` SET TAGS ('dbx_business_glossary_term' = 'On‑Time Delivery Target Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `planned_quantity` SET TAGS ('dbx_business_glossary_term' = 'Planned Quantity');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Delivery Priority Level');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical|urgent|standard');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `schedule_horizon` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Horizon');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `schedule_horizon` SET TAGS ('dbx_value_regex' = 'weekly|monthly|quarterly|yearly|ad_hoc|custom');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `schedule_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule Number (DSN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `schedule_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Schedule Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `scheduled_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `scheduled_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Departure Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Delivery Instructions');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `temperature_control_required` SET TAGS ('dbx_business_glossary_term' = 'Temperature Control Requirement');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Carrier Tracking Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'truck|rail|vessel|air|intermodal|pipeline');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_value_regex' = 'semi_trailer|reefer|flatbed|dry_van|tank|container');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Total Volume (cbm)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Total Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
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
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `carrier_performance_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Performance Record Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reviewed By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `average_transit_days` SET TAGS ('dbx_business_glossary_term' = 'Average Transit Days');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `carrier_performance_status` SET TAGS ('dbx_business_glossary_term' = 'Record Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `carrier_performance_status` SET TAGS ('dbx_value_regex' = 'active|inactive|archived');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `claim_frequency` SET TAGS ('dbx_business_glossary_term' = 'Claim Frequency');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `cost_per_shipment_usd` SET TAGS ('dbx_business_glossary_term' = 'Cost per Shipment (USD)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `damage_rate_ppm` SET TAGS ('dbx_business_glossary_term' = 'Damage Rate (PPM)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `fuel_consumption_l_per_100km` SET TAGS ('dbx_business_glossary_term' = 'Fuel Consumption (L/100KM)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `lane_code` SET TAGS ('dbx_business_glossary_term' = 'Lane Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `lane_type` SET TAGS ('dbx_business_glossary_term' = 'Lane Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `lane_type` SET TAGS ('dbx_value_regex' = 'domestic|export|import');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Performance Notes');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `on_time_delivery_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'On‑Time Delivery Rate Percentage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `otd_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'On‑Time Delivery Rate (OTD) Percentage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `overall_rating` SET TAGS ('dbx_business_glossary_term' = 'Overall Carrier Rating');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `performance_month` SET TAGS ('dbx_business_glossary_term' = 'Performance Month (YYYY‑MM)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `total_claims` SET TAGS ('dbx_business_glossary_term' = 'Total Claims');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `total_damage_units` SET TAGS ('dbx_business_glossary_term' = 'Total Damaged Units');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `total_distance_km` SET TAGS ('dbx_business_glossary_term' = 'Total Distance (KM)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `total_shipments` SET TAGS ('dbx_business_glossary_term' = 'Total Shipments');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `transit_time_compliance_pct` SET TAGS ('dbx_business_glossary_term' = 'Transit‑Time Compliance Percentage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'truck|rail|vessel|intermodal|air');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` SET TAGS ('dbx_subdomain' = 'yard_operations');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` SET TAGS ('dbx_retain' = 'preserve_coverage');
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
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` SET TAGS ('dbx_subdomain' = 'yard_operations');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `compound_movement_id` SET TAGS ('dbx_business_glossary_term' = 'Compound Movement ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Identifier (CARRIER_ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operator ID (OPERATOR_ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `compound_operator_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operator ID (OPERATOR_ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `compound_operator_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `compound_operator_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `vehicle_compound_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Compound Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp (ACTUAL_ARRIVAL)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `compound_movement_status` SET TAGS ('dbx_business_glossary_term' = 'Movement Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `compound_movement_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `delay_minutes` SET TAGS ('dbx_business_glossary_term' = 'Delay Duration (DELAY_MIN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `destination_zone` SET TAGS ('dbx_business_glossary_term' = 'Destination Zone (DESTINATION_ZONE)');
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
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `transport_order_number` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Number (TRANSPORT_ORDER_NO)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Type (VEHICLE_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_value_regex' = 'sedan|suv|truck|ev|hybrid');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Weight (KG)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` SET TAGS ('dbx_subdomain' = 'outbound_distribution');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `in_transit_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'In-Transit Inventory Record ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `carrier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier (Dealer ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `in_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier (Dealer ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `production_order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Identifier (SHIP_ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` SET TAGS ('dbx_subdomain' = 'international_trade');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `port_processing_id` SET TAGS ('dbx_business_glossary_term' = 'Port Processing Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `carrier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp (AAT)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `actual_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Departure Timestamp (ADT)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `arrival_date` SET TAGS ('dbx_business_glossary_term' = 'Arrival Date (AD)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `carrier_scac_code` SET TAGS ('dbx_business_glossary_term' = 'Carrier SCAC Code (CSC)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `compliance_regulation_code` SET TAGS ('dbx_business_glossary_term' = 'Compliance Regulation Code (CRC)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status (CS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `container_code` SET TAGS ('dbx_business_glossary_term' = 'Container Identifier (CI)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Status (CCS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_value_regex' = 'not_submitted|submitted|cleared|rejected');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `customs_document_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Document Number (CDN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `customs_document_type` SET TAGS ('dbx_business_glossary_term' = 'Customs Document Type (CDT)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `customs_document_type` SET TAGS ('dbx_value_regex' = 'bill_of_lading|manifest|invoice|certificate');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `departure_date` SET TAGS ('dbx_business_glossary_term' = 'Departure Date (DD)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `estimated_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Estimated Arrival Timestamp (EAT)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `estimated_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Estimated Departure Timestamp (EDT)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `export_import_indicator` SET TAGS ('dbx_business_glossary_term' = 'Export/Import Indicator (EI)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `export_import_indicator` SET TAGS ('dbx_value_regex' = 'export|import');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `freight_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Freight Cost Amount (FCA)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `freight_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Freight Cost Currency (FCC)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `homologation_inspection_status` SET TAGS ('dbx_business_glossary_term' = 'Homologation Inspection Status (HIS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `homologation_inspection_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|passed|failed');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Inspection Date (ID)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `inspection_report_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Report Number (IRN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Processing Notes (PN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `pdi_completion_status` SET TAGS ('dbx_business_glossary_term' = 'Pre‑Delivery Inspection Completion Status (PDI‑CS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `pdi_completion_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `port_charges_amount` SET TAGS ('dbx_business_glossary_term' = 'Port Charges Amount (PCA)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `port_charges_currency` SET TAGS ('dbx_business_glossary_term' = 'Port Charges Currency (PCC)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `port_facility_code` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Code (PFC)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `port_facility_name` SET TAGS ('dbx_business_glossary_term' = 'Port Facility Name (PFN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `port_processing_status` SET TAGS ('dbx_business_glossary_term' = 'Port Processing Status (PS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `port_processing_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `processing_reference` SET TAGS ('dbx_business_glossary_term' = 'Port Processing Reference (PR)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `processing_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Processing Event Timestamp (PET)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `release_authorization_flag` SET TAGS ('dbx_business_glossary_term' = 'Release Authorization Flag (RAF)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `release_authorization_number` SET TAGS ('dbx_business_glossary_term' = 'Release Authorization Number (RAN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Seal Number (SN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Type (VT)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `vessel_name` SET TAGS ('dbx_business_glossary_term' = 'Vessel Name (VN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ALTER COLUMN `voyage_number` SET TAGS ('dbx_business_glossary_term' = 'Voyage Number (VN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` SET TAGS ('dbx_subdomain' = 'international_trade');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `vessel_voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Voyage ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Captain Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `actual_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Departure Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `available_capacity_units` SET TAGS ('dbx_business_glossary_term' = 'Available Capacity Units');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `available_capacity_units` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `booked_units` SET TAGS ('dbx_business_glossary_term' = 'Booked Units');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Voyage Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Voyage Cost Currency (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `destination_port_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Port Code (UN/LOCODE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `destination_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `imo_number` SET TAGS ('dbx_business_glossary_term' = 'IMO Number (International Maritime Organization Number)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `imo_number` SET TAGS ('dbx_value_regex' = '^d{7}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `origin_port_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Port Code (UN/LOCODE)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `origin_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `planned_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `planned_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Departure Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `vessel_capacity_units` SET TAGS ('dbx_business_glossary_term' = 'Vessel Capacity (Units)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `vessel_capacity_units` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `vessel_name` SET TAGS ('dbx_business_glossary_term' = 'Vessel Name');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `voyage_number` SET TAGS ('dbx_business_glossary_term' = 'Voyage Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `voyage_status` SET TAGS ('dbx_business_glossary_term' = 'Voyage Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `voyage_status` SET TAGS ('dbx_value_regex' = 'planned|departed|arrived|cancelled|completed|on_hold');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `voyage_status_reason` SET TAGS ('dbx_business_glossary_term' = 'Voyage Status Reason');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `voyage_type` SET TAGS ('dbx_business_glossary_term' = 'Voyage Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ALTER COLUMN `voyage_type` SET TAGS ('dbx_value_regex' = 'ro-ro|container|bulk|tanker');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` SET TAGS ('dbx_subdomain' = 'outbound_distribution');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `rail_car_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Car Assignment ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `vehicle_transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `assignment_status` SET TAGS ('dbx_business_glossary_term' = 'Assignment Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `assignment_status` SET TAGS ('dbx_value_regex' = 'assigned|released|canceled');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `capacity_utilization_pct` SET TAGS ('dbx_business_glossary_term' = 'Capacity Utilization (%)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `capacity_utilization_pct` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `critical_flag` SET TAGS ('dbx_business_glossary_term' = 'Critical Assignment Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `destination_yard_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Yard Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `destination_yard_name` SET TAGS ('dbx_business_glossary_term' = 'Destination Yard Name');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `load_volume_cubic_meters` SET TAGS ('dbx_business_glossary_term' = 'Load Volume (m³)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `load_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Load Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `loading_date` SET TAGS ('dbx_business_glossary_term' = 'Loading Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `loading_sequence` SET TAGS ('dbx_business_glossary_term' = 'Loading Sequence');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `loading_status` SET TAGS ('dbx_business_glossary_term' = 'Loading Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `loading_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|failed');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Assignment Notes');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `occupied_capacity_tons` SET TAGS ('dbx_business_glossary_term' = 'Occupied Capacity (tons)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `occupied_capacity_tons` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `origin_yard_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Yard Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `origin_yard_name` SET TAGS ('dbx_business_glossary_term' = 'Origin Yard Name');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `rail_car_capacity_tons` SET TAGS ('dbx_business_glossary_term' = 'Rail Car Capacity (tons)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `rail_car_capacity_tons` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `rail_car_number` SET TAGS ('dbx_business_glossary_term' = 'Rail Car Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `rail_car_type` SET TAGS ('dbx_business_glossary_term' = 'Rail Car Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `rail_car_type` SET TAGS ('dbx_value_regex' = 'autorack|flatcar|boxcar|tankcar|hopper');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `unloading_date` SET TAGS ('dbx_business_glossary_term' = 'Unloading Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `unloading_status` SET TAGS ('dbx_business_glossary_term' = 'Unloading Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `unloading_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|failed');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `vin_count` SET TAGS ('dbx_business_glossary_term' = 'VIN Count');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `vin_list` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number List');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ALTER COLUMN `vin_list` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}(,[A-HJ-NPR-Z0-9]{17})*$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` SET TAGS ('dbx_subdomain' = 'international_trade');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `ckd_kit_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'CKD Kit Shipment ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Plant Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `plant_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `origin_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Plant Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `origin_plant_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `actual_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Departure Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `bom_reference` SET TAGS ('dbx_business_glossary_term' = 'Bill of Materials Reference');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `container_number` SET TAGS ('dbx_business_glossary_term' = 'Container Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `container_type` SET TAGS ('dbx_business_glossary_term' = 'Container Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `container_type` SET TAGS ('dbx_value_regex' = 'dry|reefer|open_top|flat_rack');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `customs_invoice_currency` SET TAGS ('dbx_business_glossary_term' = 'Customs Invoice Currency');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `customs_invoice_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `customs_invoice_value` SET TAGS ('dbx_business_glossary_term' = 'Customs Invoice Value');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `delay_reason` SET TAGS ('dbx_business_glossary_term' = 'Delay Reason');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `export_license_number` SET TAGS ('dbx_business_glossary_term' = 'Export License Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `export_license_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `freight_cost` SET TAGS ('dbx_business_glossary_term' = 'Freight Cost');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `hazardous_material_type` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `hs_code` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `hs_code` SET TAGS ('dbx_value_regex' = '^d{6,10}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `kit_part_number` SET TAGS ('dbx_business_glossary_term' = 'Kit Part Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `kit_quantity_per_container` SET TAGS ('dbx_business_glossary_term' = 'Kits per Container');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `net_cost` SET TAGS ('dbx_business_glossary_term' = 'Net Cost');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `number_of_kits` SET TAGS ('dbx_business_glossary_term' = 'Number of Kits');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `otd_flag` SET TAGS ('dbx_business_glossary_term' = 'On‑Time Delivery Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `packing_list_reference` SET TAGS ('dbx_business_glossary_term' = 'Packing List Reference');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `planned_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `planned_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Departure Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Seal Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `shipment_status` SET TAGS ('dbx_business_glossary_term' = 'Shipment Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `shipment_status` SET TAGS ('dbx_value_regex' = 'planned|in_transit|delivered|cancelled|held|customs_hold');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `temperature_control_required` SET TAGS ('dbx_business_glossary_term' = 'Temperature Control Required');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `temperature_max_c` SET TAGS ('dbx_business_glossary_term' = 'Maximum Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `temperature_min_c` SET TAGS ('dbx_business_glossary_term' = 'Minimum Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Tracking Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'sea|rail|truck|air');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `volume_cubic_meters` SET TAGS ('dbx_business_glossary_term' = 'Volume (cubic meters)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `transport_damage_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Damage Claim Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Claim Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Claim Adjuster Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `actual_repair_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Repair Cost');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_adjuster_code` SET TAGS ('dbx_business_glossary_term' = 'Claim Adjuster Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_adjuster_contact` SET TAGS ('dbx_business_glossary_term' = 'Claim Adjuster Contact');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_adjuster_contact` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_adjuster_contact` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_adjuster_name` SET TAGS ('dbx_business_glossary_term' = 'Claim Adjuster Name');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_adjuster_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_adjuster_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_created_by` SET TAGS ('dbx_business_glossary_term' = 'Claim Created By');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Claim Currency Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_document_url` SET TAGS ('dbx_business_glossary_term' = 'Claim Document URL');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_notes` SET TAGS ('dbx_business_glossary_term' = 'Claim Notes');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_number` SET TAGS ('dbx_business_glossary_term' = 'Transport Damage Claim Number (TDCN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_policy_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Policy Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_ppm_rate` SET TAGS ('dbx_business_glossary_term' = 'Claim PPM Rate');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_priority` SET TAGS ('dbx_business_glossary_term' = 'Claim Priority');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_resolution_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Claim Resolution Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_settlement_method` SET TAGS ('dbx_business_glossary_term' = 'Claim Settlement Method');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_settlement_method` SET TAGS ('dbx_value_regex' = 'direct_payment|credit_note|offset');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_settlement_reference` SET TAGS ('dbx_business_glossary_term' = 'Claim Settlement Reference');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_source` SET TAGS ('dbx_business_glossary_term' = 'Claim Source');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_source` SET TAGS ('dbx_value_regex' = 'dealer|plant|logistics|customer');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_status` SET TAGS ('dbx_business_glossary_term' = 'Claim Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_status` SET TAGS ('dbx_value_regex' = 'submitted|under_review|approved|rejected|settled|closed');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Claim Submission Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_type` SET TAGS ('dbx_business_glossary_term' = 'Claim Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_type` SET TAGS ('dbx_value_regex' = 'physical_damage|water_damage|theft|other');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `claim_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Claim Updated By');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `damage_category` SET TAGS ('dbx_business_glossary_term' = 'Damage Category');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `damage_category` SET TAGS ('dbx_value_regex' = 'exterior|interior|mechanical|electrical|other');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `damage_description` SET TAGS ('dbx_business_glossary_term' = 'Damage Description');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `damage_location` SET TAGS ('dbx_business_glossary_term' = 'Damage Location');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `damage_severity` SET TAGS ('dbx_business_glossary_term' = 'Damage Severity');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `damage_severity` SET TAGS ('dbx_value_regex' = 'minor|moderate|severe|total_loss');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `estimated_repair_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Repair Cost');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `insurance_claim_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Claim Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `is_fraud_flag` SET TAGS ('dbx_business_glossary_term' = 'Fraud Indicator Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `otd_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'On‑Time Delivery Impact Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `repair_estimate_source` SET TAGS ('dbx_business_glossary_term' = 'Repair Estimate Source');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `repair_estimate_source` SET TAGS ('dbx_value_regex' = 'dealer|OEM|third_party');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `settlement_amount` SET TAGS ('dbx_business_glossary_term' = 'Settlement Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `settlement_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Settlement Currency Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `settlement_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Settlement Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'truck|rail|vessel|air|intermodal');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `freight_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Invoice Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `aftersales_warranty_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `lane_code` SET TAGS ('dbx_business_glossary_term' = 'Lane Code');
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
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `transport_order_number` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `variance_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoice Variance Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Shipment Volume (cbm)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Shipment Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `transport_rate_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Rate ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `lane_id` SET TAGS ('dbx_business_glossary_term' = 'Logistics Lane Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `accessorial_charges` SET TAGS ('dbx_business_glossary_term' = 'Accessorial Charges (AC)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Compliance Flag (CF)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `container_type` SET TAGS ('dbx_business_glossary_term' = 'Container Type (CT)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `container_type` SET TAGS ('dbx_value_regex' = 'standard|reefer|flatbed|open_top');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp (CT)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (CCY)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CNY|GBP');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `destination_location_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Location Code (DLC)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date (EFD)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date (EUD)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `fuel_surcharge_percent` SET TAGS ('dbx_business_glossary_term' = 'Fuel Surcharge Percent (FSP)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes (N)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `origin_location_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Code (OLC)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Base Rate Amount (BRA)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `rate_code` SET TAGS ('dbx_business_glossary_term' = 'Rate Code (RC)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `rate_source_system` SET TAGS ('dbx_business_glossary_term' = 'Rate Source System (RSS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `rate_source_system` SET TAGS ('dbx_value_regex' = 'SAP|Oracle|Custom');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `rate_version` SET TAGS ('dbx_business_glossary_term' = 'Rate Version (RV)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode (TM)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|sea|air');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `transport_rate_status` SET TAGS ('dbx_business_glossary_term' = 'Rate Status (RS)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `transport_rate_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|expired');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'per_vehicle|per_container|per_ton|per_cbm');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp (UT)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Type (VT)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_value_regex' = 'sedan|suv|truck|van|e_vehicle');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `volume_capacity_cubic_meters` SET TAGS ('dbx_business_glossary_term' = 'Volume Capacity (m³)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `volume_capacity_cubic_meters` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `weight_capacity_tons` SET TAGS ('dbx_business_glossary_term' = 'Weight Capacity (tons)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ALTER COLUMN `weight_capacity_tons` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` ALTER COLUMN `lane_id` SET TAGS ('dbx_business_glossary_term' = 'Lane Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_pdi_inspection` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_pdi_inspection` SET TAGS ('dbx_subdomain' = 'yard_operations');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_pdi_inspection` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_pdi_inspection` ALTER COLUMN `logistics_pdi_inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for logistics_pdi_inspection');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_pdi_inspection` ALTER COLUMN `logistics_delivery_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Logistics Delivery Schedule Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_pdi_inspection` ALTER COLUMN `aftersales_pdi_inspection_id` SET TAGS ('dbx_ssot_owner' = 'aftersales.aftersales_pdi_inspection');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_pdi_inspection` ALTER COLUMN `aftersales_pdi_inspection_id` SET TAGS ('dbx_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` SET TAGS ('dbx_subdomain' = 'international_trade');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `export_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Export Declaration ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `carrier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Exporter Plant ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `clearance_status` SET TAGS ('dbx_business_glossary_term' = 'Clearance Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `clearance_status` SET TAGS ('dbx_value_regex' = 'cleared|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `clearance_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Clearance Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `compliance_notes` SET TAGS ('dbx_business_glossary_term' = 'Compliance Notes');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `customs_authority_reference` SET TAGS ('dbx_business_glossary_term' = 'Customs Authority Reference');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Export Declaration Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `declared_value_amount` SET TAGS ('dbx_business_glossary_term' = 'Declared Value Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `declared_value_currency` SET TAGS ('dbx_business_glossary_term' = 'Declared Value Currency');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `declared_value_currency` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `duty_amount` SET TAGS ('dbx_business_glossary_term' = 'Customs Duty Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `export_declaration_status` SET TAGS ('dbx_business_glossary_term' = 'Export Declaration Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `export_declaration_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|cleared|rejected');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `export_license_number` SET TAGS ('dbx_business_glossary_term' = 'Export License Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `export_license_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `export_type` SET TAGS ('dbx_business_glossary_term' = 'Export Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `export_type` SET TAGS ('dbx_value_regex' = 'vehicle|ckd_kit|skd_kit|parts');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `hazardous_material_type` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `hs_code` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `hs_code` SET TAGS ('dbx_value_regex' = '[0-9]{6,10}');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `is_hazardous` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Indicator');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `net_value_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Value Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `otd_flag` SET TAGS ('dbx_business_glossary_term' = 'On‑Time Delivery Indicator');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Export Quantity');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Submission Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `temperature_control_required` SET TAGS ('dbx_business_glossary_term' = 'Temperature Control Requirement');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `temperature_max_c` SET TAGS ('dbx_business_glossary_term' = 'Maximum Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `temperature_min_c` SET TAGS ('dbx_business_glossary_term' = 'Minimum Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|sea|air');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `vin_list` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number List');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Export Volume (cbm)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Export Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` SET TAGS ('dbx_subdomain' = 'international_trade');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Import Declaration ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `company_code_id` SET TAGS ('dbx_business_glossary_term' = 'Importing Entity ID');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Name');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `clearance_date` SET TAGS ('dbx_business_glossary_term' = 'Clearance Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `clearance_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Clearance Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `customs_authority` SET TAGS ('dbx_business_glossary_term' = 'Customs Authority');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `customs_document_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Document Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `customs_value_amount` SET TAGS ('dbx_business_glossary_term' = 'Customs Value Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Number (DECL_NO)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Departure Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `duty_amount` SET TAGS ('dbx_business_glossary_term' = 'Customs Duty Amount');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `duty_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Duty Rate Percentage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `exchange_rate_date` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `exchange_rate_to_usd` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate to USD');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `freight_cost` SET TAGS ('dbx_business_glossary_term' = 'Freight Cost');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `homologation_status` SET TAGS ('dbx_business_glossary_term' = 'Homologation Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `homologation_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `hs_code` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `hs_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `hs_code_description` SET TAGS ('dbx_business_glossary_term' = 'HS Code Description');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_cost_total` SET TAGS ('dbx_business_glossary_term' = 'Total Import Cost');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_declaration_status` SET TAGS ('dbx_business_glossary_term' = 'Import Declaration Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_declaration_status` SET TAGS ('dbx_value_regex' = 'pending|submitted|cleared|rejected|cancelled');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_duty_paid_flag` SET TAGS ('dbx_business_glossary_term' = 'Import Duty Paid Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_duty_payment_date` SET TAGS ('dbx_business_glossary_term' = 'Import Duty Payment Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_duty_payment_method` SET TAGS ('dbx_business_glossary_term' = 'Import Duty Payment Method');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_duty_payment_method` SET TAGS ('dbx_value_regex' = 'bank_transfer|credit_card|cash|cheque');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_license_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Import License Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_license_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Import License Issue Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_license_number` SET TAGS ('dbx_business_glossary_term' = 'Import License Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_license_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_license_valid` SET TAGS ('dbx_business_glossary_term' = 'Import License Valid Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_type` SET TAGS ('dbx_business_glossary_term' = 'Import Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `import_type` SET TAGS ('dbx_value_regex' = 'finished_vehicle|ckd_kit|skd_kit');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `insurance_cost` SET TAGS ('dbx_business_glossary_term' = 'Insurance Cost');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `model_code` SET TAGS ('dbx_business_glossary_term' = 'Model Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Country Code (ISO 3166-1 Alpha-3)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `origin_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `port_of_entry` SET TAGS ('dbx_business_glossary_term' = 'Port of Entry');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `port_of_exit` SET TAGS ('dbx_business_glossary_term' = 'Port of Exit');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks / Comments');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Submission Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `total_landed_cost` SET TAGS ('dbx_business_glossary_term' = 'Total Landed Cost');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'sea|air|rail|road|multimodal');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Import Declaration Version');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` SET TAGS ('dbx_subdomain' = 'yard_operations');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `vehicle_handover_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Handover Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `aftersales_repair_order_id` SET TAGS ('dbx_business_glossary_term' = 'Repair Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `compliance_document_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `finished_vehicle_stock_id` SET TAGS ('dbx_business_glossary_term' = 'Finished Vehicle Stock Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `production_order_id` SET TAGS ('dbx_business_glossary_term' = 'Production Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Party Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `vehicle_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `vehicle_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `vehicle_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
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
ALTER TABLE `vibe_automotive_v1`.`logistics`.`load_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`load_plan` SET TAGS ('dbx_subdomain' = 'outbound_distribution');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`load_plan` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`load_plan` ALTER COLUMN `load_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for load_plan');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`load_plan` ALTER COLUMN `consolidated_load_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Consolidated Load Plan Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`load_plan` ALTER COLUMN `consolidated_load_plan_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`load_plan` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`load_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Planner Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`load_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`load_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_shipment_assignment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_shipment_assignment` SET TAGS ('dbx_subdomain' = 'outbound_distribution');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_shipment_assignment` SET TAGS ('dbx_association_edges' = 'logistics.shipment,mobility.connected_vehicle');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_shipment_assignment` SET TAGS ('dbx_retain' = 'preserve_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_shipment_assignment` ALTER COLUMN `vehicle_shipment_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Shipment Assignment - Vehicle Shipment Assignment Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_shipment_assignment` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Shipment Assignment - Connected Vehicle Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_shipment_assignment` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Shipment Assignment - Shipment Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_shipment_assignment` ALTER COLUMN `position_in_container` SET TAGS ('dbx_business_glossary_term' = 'Container Position');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_shipment_assignment` ALTER COLUMN `vehicle_shipment_status` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Shipment Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` SET TAGS ('dbx_subdomain' = 'carrier_management');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `route_id` SET TAGS ('dbx_business_glossary_term' = 'Route Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `carrier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `return_route_id` SET TAGS ('dbx_business_glossary_term' = 'Return Route Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `return_route_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `actual_arrival_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Time');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `actual_departure_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Departure Time');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `average_travel_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Average Travel Time Minutes');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `carrier_mode` SET TAGS ('dbx_business_glossary_term' = 'Carrier Mode');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `route_code` SET TAGS ('dbx_business_glossary_term' = 'Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Cost Usd');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `route_description` SET TAGS ('dbx_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `destination_location` SET TAGS ('dbx_business_glossary_term' = 'Destination Location');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `distance_km` SET TAGS ('dbx_business_glossary_term' = 'Distance Km');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `emissions_kg_co2` SET TAGS ('dbx_business_glossary_term' = 'Emissions Kg Co2');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `fuel_consumption_l_per_100km` SET TAGS ('dbx_business_glossary_term' = 'Fuel Consumption L Per 100km');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `is_express` SET TAGS ('dbx_business_glossary_term' = 'Is Express');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `maintenance_interval_days` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Interval Days');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `max_load_capacity_tons` SET TAGS ('dbx_business_glossary_term' = 'Max Load Capacity Tons');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `max_load_capacity_tons` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `route_name` SET TAGS ('dbx_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `on_time_performance_pct` SET TAGS ('dbx_business_glossary_term' = 'On Time Performance Pct');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `origin_location` SET TAGS ('dbx_business_glossary_term' = 'Origin Location');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `regulatory_region` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Region');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `route_group` SET TAGS ('dbx_business_glossary_term' = 'Route Group');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `scheduled_arrival_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Arrival Time');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `scheduled_departure_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Departure Time');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `route_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `route_type` SET TAGS ('dbx_business_glossary_term' = 'Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`route` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` SET TAGS ('dbx_subdomain' = 'international_trade');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `carrier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `parent_container_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Container Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `parent_container_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `actual_arrival_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `condition` SET TAGS ('dbx_business_glossary_term' = 'Container Condition');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `container_number` SET TAGS ('dbx_business_glossary_term' = 'Container Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `container_status` SET TAGS ('dbx_business_glossary_term' = 'Container Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `container_type` SET TAGS ('dbx_business_glossary_term' = 'Container Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `current_location` SET TAGS ('dbx_business_glossary_term' = 'Current Location');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `customs_clearance_date` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `customs_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `damage_description` SET TAGS ('dbx_business_glossary_term' = 'Damage Description');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `damage_report_flag` SET TAGS ('dbx_business_glossary_term' = 'Damage Report Flag');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `departure_date` SET TAGS ('dbx_business_glossary_term' = 'Departure Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `estimated_arrival_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Arrival Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_business_glossary_term' = 'Gps Latitude');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_classification' = 'confidential');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_business_glossary_term' = 'Gps Longitude');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_classification' = 'confidential');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `humidity_control` SET TAGS ('dbx_business_glossary_term' = 'Humidity Control');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `last_event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `lease_end_date` SET TAGS ('dbx_business_glossary_term' = 'Lease End Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `lease_start_date` SET TAGS ('dbx_business_glossary_term' = 'Lease Start Date');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `location_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Location Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `maintenance_status` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `max_payload_kg` SET TAGS ('dbx_business_glossary_term' = 'Max Payload Kg');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `next_maintenance_due` SET TAGS ('dbx_business_glossary_term' = 'Next Maintenance Due');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `owner_company` SET TAGS ('dbx_business_glossary_term' = 'Owner Company');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `refrigerated` SET TAGS ('dbx_business_glossary_term' = 'Refrigerated');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Seal Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `size_feet` SET TAGS ('dbx_business_glossary_term' = 'Size Feet');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `tare_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Tare Weight Kg');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `temperature_control` SET TAGS ('dbx_business_glossary_term' = 'Temperature Control');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `voyage_number` SET TAGS ('dbx_business_glossary_term' = 'Voyage Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `weight_capacity_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight Capacity Kg');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`container` ALTER COLUMN `weight_capacity_kg` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` SET TAGS ('dbx_subdomain' = 'international_trade');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `parent_shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Shipping Line Id');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `parent_shipping_line_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line1');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line2');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `carrier_type` SET TAGS ('dbx_business_glossary_term' = 'Carrier Type');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `country` SET TAGS ('dbx_business_glossary_term' = 'Country');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `country` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `country` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `fleet_size` SET TAGS ('dbx_business_glossary_term' = 'Fleet Size');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `hub_location` SET TAGS ('dbx_business_glossary_term' = 'Hub Location');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `insurance_cert_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Cert Number');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `max_container_capacity` SET TAGS ('dbx_business_glossary_term' = 'Max Container Capacity');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `max_container_capacity` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `shipping_line_name` SET TAGS ('dbx_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `preferred_currency` SET TAGS ('dbx_business_glossary_term' = 'Preferred Currency');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Email');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Name');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_true' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_classification' = 'confidential');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Phone');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `rating_score` SET TAGS ('dbx_business_glossary_term' = 'Rating Score');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `scac_code` SET TAGS ('dbx_business_glossary_term' = 'Scac Code');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `service_region` SET TAGS ('dbx_business_glossary_term' = 'Service Region');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `short_name` SET TAGS ('dbx_business_glossary_term' = 'Short Name');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `state` SET TAGS ('dbx_business_glossary_term' = 'State');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `state` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `state` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `shipping_line_status` SET TAGS ('dbx_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_business_glossary_term' = 'Tax Identifier');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipping_line` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'Website Url');
