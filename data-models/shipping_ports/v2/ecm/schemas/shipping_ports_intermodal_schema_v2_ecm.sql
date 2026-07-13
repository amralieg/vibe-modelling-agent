-- Schema for Domain: intermodal | Business: Shipping_Ports | Version: v2_ecm
-- Generated on: 2026-07-13 08:38:28

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`intermodal` COMMENT 'Manages end-to-end intermodal transport coordination including rail operations, truck dispatch, inland container depot (ICD) linkages, truck appointment systems, AWB and IFTMIN messaging, container drayage, and last-mile delivery tracking. Supports EDI integration with inland logistics partners. SSOT for intermodal transport integration and inland logistics.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` (
    `rail_visit_id` BIGINT COMMENT 'Unique identifier for the rail train visit to the port terminal. Primary key for the rail visit record. Represents the rail equivalent of a vessel call — the unit of rail service delivery.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Rail terminal visits operate under rail operator service agreements defining track access rights, capacity allocation, and terminal handling charges. Real business process: visit authorization and bil',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Rail visit operations require employee assignment for train coordination, dispatch oversight, and operational accountability. Maritime terminals track which employee manages each rail visit for issue ',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Rail terminal operations are cost centers; rail visit costs (track usage, handling, labor) must be captured against responsible cost center for operational cost accounting, variance analysis, and term',
    `manifest_id` BIGINT COMMENT 'Foreign key linking to cargo.cargo_manifest. Business justification: Rail visits must reference the cargo manifest for customs declaration at rail-port interchange, dangerous goods compliance verification, and cargo inventory reconciliation between rail operator and te',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Rail visits utilize specific port-owned rail infrastructure assets (rail-mounted gantry cranes, track systems, loading platforms). Operations teams must track which assets serve each visit for utiliza',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Rail visits occur at specific terminal track locations. Yard planning, resource allocation, and track assignment operations require proper location reference for infrastructure management and operatio',
    `rail_operator_id` BIGINT COMMENT 'Reference to the rail carrier or operator providing the train service. Links to the port community participant master data.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Rail visits operate within dedicated rail-served terminal zones, enabling rail capacity planning, track allocation, and intermodal transfer coordination - rail operations planning process. Role-prefix',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Rail visits for contracted operators use negotiated rate cards for terminal services (loading, unloading, track usage). Essential for rail service billing and operator invoicing.',
    `intermodal_service_id` BIGINT COMMENT 'Foreign key linking to intermodal.intermodal_service. Business justification: Rail visits are instances of intermodal rail services. The service defines the scheduled route and frequency; the visit is the actual train arrival/departure. No columns removed because visit has exec',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: Capital rail infrastructure projects (track expansion, electrification, signaling) track actual rail visit volumes and revenue against WBS elements for project performance measurement, ROI calculation',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Rail operations occur in designated secure rail terminal zones requiring zone-specific access control, hazmat screening protocols, and MARSEC-level security measures - intermodal facility security pla',
    `actual_arrival_time` TIMESTAMP COMMENT 'Actual date and time when the train physically arrived at the port terminal rail facility. Recorded by terminal operations for performance measurement and billing.',
    `actual_departure_time` TIMESTAMP COMMENT 'Actual date and time when the train departed from the port terminal rail facility. Recorded for performance measurement, billing, and Service Level Agreement (SLA) compliance.',
    `appointment_reference` STRING COMMENT 'Reference to the truck appointment system booking if this rail visit is part of an integrated intermodal appointment. Links rail and truck operations.',
    `billing_status` STRING COMMENT 'Current status of billing and invoicing for this rail visit. Tracks the financial lifecycle from charge calculation through payment.. Valid values are `pending|calculated|invoiced|paid|disputed`',
    `completed_timestamp` TIMESTAMP COMMENT 'Date and time when the rail visit was marked as completed, indicating all loading/unloading operations finished and the train departed. Used for performance measurement and Service Level Agreement (SLA) compliance.',
    `container_count_discharged` STRING COMMENT 'Total number of individual containers unloaded from the train during this visit, regardless of size. Used for operational tracking and billing.',
    `container_count_loaded` STRING COMMENT 'Total number of individual containers loaded onto the train during this visit, regardless of size. Used for operational tracking and billing.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this rail visit record was first created in the Terminal Operating System (TOS). Used for audit trail and data lineage.',
    `destination_location` STRING COMMENT 'Geographic destination point or Inland Container Depot (ICD) to which the train will proceed after departing the terminal. Used for supply chain visibility and intermodal coordination.',
    `edi_message_reference` STRING COMMENT 'Reference to the EDI IFTMIN (Instruction Message for Transport) or other EDI message that initiated or updated this rail visit. Used for audit trail and system integration.',
    `empty_wagon_count` STRING COMMENT 'Number of empty wagons in the train consist. Used for capacity planning and outbound loading operations.',
    `estimated_arrival_time` TIMESTAMP COMMENT 'Current estimated arrival time based on real-time tracking and updates from the rail operator. Updated as the train progresses toward the terminal.',
    `estimated_departure_time` TIMESTAMP COMMENT 'Current estimated departure time based on operational progress and remaining work. Updated throughout the visit as operations proceed.',
    `hazmat_indicator` BOOLEAN COMMENT 'Flag indicating whether the train is carrying any hazardous materials requiring special handling per International Maritime Dangerous Goods (IMDG) Code. Triggers safety protocols and regulatory compliance procedures.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this rail visit record was last updated. Used for change tracking and data synchronization.',
    `loaded_wagon_count` STRING COMMENT 'Number of wagons carrying containers or cargo upon arrival. Used for workload estimation and equipment planning.',
    `operator_reference_number` STRING COMMENT 'Rail operators internal reference or booking number for this train visit. Used for reconciliation and communication with the rail carrier.',
    `origin_location` STRING COMMENT 'Geographic origin point or Inland Container Depot (ICD) from which the train departed. Used for supply chain visibility and intermodal coordination.',
    `priority_level` STRING COMMENT 'Operational priority assigned to the rail visit. Determines sequencing and resource allocation for loading and unloading operations.. Valid values are `standard|priority|express|emergency`',
    `reefer_container_count` STRING COMMENT 'Number of refrigerated containers on the train requiring power connection and temperature monitoring. Used for resource planning and power infrastructure allocation.',
    `remarks` STRING COMMENT 'Free-text field for operational notes, special instructions, or exceptions related to this rail visit. Used for communication between terminal staff and rail operators.',
    `scheduled_arrival_time` TIMESTAMP COMMENT 'Planned date and time when the train is scheduled to arrive at the port terminal rail facility. Used for resource planning and berth allocation.',
    `scheduled_departure_time` TIMESTAMP COMMENT 'Planned date and time when the train is scheduled to depart from the port terminal rail facility after completing loading/unloading operations.',
    `service_type` STRING COMMENT 'Type of rail service being provided. Unit train serves single customer/destination, manifest train carries mixed cargo, block train moves pre-assembled groups, local service provides switching.. Valid values are `unit_train|manifest_train|block_train|local_service`',
    `teu_capacity` STRING COMMENT 'Total container capacity of the train expressed in Twenty-foot Equivalent Units (TEU). Standard measure for rail capacity planning and performance reporting.',
    `teu_discharged` STRING COMMENT 'Actual number of TEU unloaded from the train during this visit. Used for productivity measurement and billing calculations.',
    `teu_loaded` STRING COMMENT 'Actual number of TEU loaded on the train for this visit. Used for productivity measurement and billing calculations.',
    `track_assignment` STRING COMMENT 'Identifier of the rail track or siding where the train is positioned for loading and unloading operations. Critical for yard management and equipment dispatch.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `train_identifier` STRING COMMENT 'Unique identifier assigned to the train by the rail operator. Used for tracking the physical train consist throughout its journey.. Valid values are `^[A-Z0-9-]{4,30}$`',
    `train_length_meters` DECIMAL(18,2) COMMENT 'Total physical length of the train consist in meters. Used for track capacity planning and safety compliance.',
    `train_weight_tonnes` DECIMAL(18,2) COMMENT 'Total weight of the train including wagons and cargo in metric tonnes. Used for infrastructure load management and safety compliance.',
    `visit_number` STRING COMMENT 'Business identifier for the rail visit. Externally-known unique reference number assigned by the Terminal Operating System (TOS) for tracking and communication purposes.. Valid values are `^[A-Z0-9]{6,20}$`',
    `visit_status` STRING COMMENT 'Current lifecycle status of the rail visit. Tracks the visit through scheduling, arrival, operations, and departure phases. [ENUM-REF-CANDIDATE: scheduled|confirmed|arrived|in_progress|departed|completed|cancelled — 7 candidates stripped; promote to reference product]',
    `visit_type` STRING COMMENT 'Classification of the rail visit based on operational purpose. Inbound brings containers to port, outbound removes containers, interchange involves both, shuttle provides regular scheduled service.. Valid values are `inbound|outbound|interchange|shuttle`',
    `wagon_count` STRING COMMENT 'Total number of rail wagons (railcars) in the train consist. Used for capacity planning and operational resource allocation.',
    CONSTRAINT pk_rail_visit PRIMARY KEY(`rail_visit_id`)
) COMMENT 'Master record for each rail train visit to the port terminal, capturing train identification, operator reference, scheduled and actual arrival/departure times, track assignment, wagon count, TEU capacity, and visit status. Represents the rail equivalent of a vessel call — the unit of rail service delivery. SSOT for rail call lifecycle. Sourced from TOS Rail Operations module.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` (
    `rail_wagon_id` BIGINT COMMENT 'Unique system identifier for the rail wagon record. Primary key.',
    `ghg_emission_record_id` BIGINT COMMENT 'Foreign key linking to safety.ghg_emission_record. Business justification: Port-owned or leased rail wagon emissions tracking for Scope 3 GHG reporting under GHG Protocol. Links wagon operational data (tare_weight_kg, gross_weight_limit_kg, operational_status) to emission ca',
    `inspection_id` BIGINT COMMENT 'Foreign key linking to safety.safety_inspection. Business justification: Periodic wagon safety inspections (brake systems, coupling integrity, structural condition, hazmat certification) required by rail safety regulations. Links last_inspection_date and next_inspection_du',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Rail wagons operating in port terminals are often port-owned or leased assets requiring maintenance tracking, SWL certification, inspection scheduling, and depreciation accounting. Asset management sy',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Asset tracking requires knowing physical wagon location within terminal. Critical for inventory management, dispatch planning, and wagon availability queries. Replaces denormalized current_location te',
    `acquisition_cost` DECIMAL(18,2) COMMENT 'The original purchase or acquisition cost of the rail wagon in the base currency, used for asset valuation and depreciation.',
    `axle_count` STRING COMMENT 'The number of axles on the rail wagon. Affects weight distribution, track wear, and operational restrictions.',
    `bogie_type` STRING COMMENT 'The type or model of bogie (wheel assembly) fitted to the wagon, affecting ride quality, speed capability, and maintenance requirements.',
    `brake_system` STRING COMMENT 'The type of braking system installed on the wagon, critical for train composition and safety compliance.. Valid values are `air|vacuum|hand|electronic`',
    `build_date` DATE COMMENT 'The specific date the rail wagon was completed and released from the manufacturing facility.',
    `certification_expiry_date` DATE COMMENT 'The date when the wagons operational certification expires and requires renewal.',
    `commissioning_date` DATE COMMENT 'The date the rail wagon was first placed into operational service.',
    `container_capacity_teu` DECIMAL(18,2) COMMENT 'The maximum container capacity of the wagon expressed in TEU. For example, a wagon that can carry two 20-foot containers or one 40-foot container would have a capacity of 2.0 TEU.',
    `coupling_type` STRING COMMENT 'The type of coupling mechanism used to connect the wagon to other rail vehicles, affecting interoperability with different rail systems.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this rail wagon record was first created in the system.',
    `deck_height_m` DECIMAL(18,2) COMMENT 'The height of the loading deck from rail level in meters. Critical for container loading operations and determining stacking feasibility.',
    `double_stack_capable` BOOLEAN COMMENT 'Indicates whether the wagon design allows for double-stacking of containers, typically applicable to well wagons.',
    `edi_enabled` BOOLEAN COMMENT 'Indicates whether the wagon is configured for EDI messaging integration with inland logistics partners and terminal operating systems.',
    `gps_tracking_enabled` BOOLEAN COMMENT 'Indicates whether the wagon is equipped with GPS tracking capability for real-time location monitoring.',
    `gross_weight_limit_kg` DECIMAL(18,2) COMMENT 'The maximum total weight (tare weight plus payload) in kilograms that the wagon is permitted to operate at, considering track and bridge load limits.',
    `hazmat_certified` BOOLEAN COMMENT 'Indicates whether the wagon is certified to transport hazardous materials according to IMDG Code standards.',
    `height_m` DECIMAL(18,2) COMMENT 'The height of the rail wagon in meters from rail level to the highest point, used for clearance calculations and tunnel/bridge compatibility.',
    `home_depot_location` STRING COMMENT 'The primary rail depot or yard where the wagon is based for maintenance and operational purposes.',
    `insurance_expiry_date` DATE COMMENT 'The date when the current insurance policy for the wagon expires and requires renewal.',
    `insurance_policy_number` STRING COMMENT 'The policy number of the insurance coverage for the rail wagon, used for claims and risk management.',
    `last_inspection_date` DATE COMMENT 'The date of the most recent safety or maintenance inspection performed on the wagon.',
    `last_maintenance_date` DATE COMMENT 'The date of the most recent maintenance activity performed on the wagon.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this rail wagon record was most recently modified in the system.',
    `lease_expiry_date` DATE COMMENT 'The date when the current lease agreement for the wagon expires, if applicable.',
    `lease_status` STRING COMMENT 'Indicates whether the wagon is owned outright by the operator, leased from a third party, or chartered for specific operations.. Valid values are `owned|leased|chartered`',
    `length_overall_m` DECIMAL(18,2) COMMENT 'The total length of the rail wagon in meters from end to end, used for train composition planning and yard space allocation.',
    `manufacture_year` STRING COMMENT 'The year the rail wagon was manufactured, used for age-based maintenance planning and depreciation calculations.',
    `manufacturer_name` STRING COMMENT 'The name of the company that manufactured the rail wagon.',
    `maximum_payload_kg` DECIMAL(18,2) COMMENT 'The maximum cargo weight in kilograms that the rail wagon is certified to carry safely. Critical for load planning and regulatory compliance.',
    `next_inspection_due_date` DATE COMMENT 'The scheduled date for the next mandatory inspection of the rail wagon.',
    `notes` STRING COMMENT 'Free-text field for additional operational notes, special handling instructions, or historical information about the wagon.',
    `operational_status` STRING COMMENT 'Current lifecycle status of the rail wagon indicating its availability for intermodal transport operations.. Valid values are `in_service|out_of_service|maintenance|retired|reserved|damaged`',
    `operator_name` STRING COMMENT 'The name of the rail operator or company responsible for operating and maintaining the wagon. May differ from the owner if the wagon is leased.',
    `owner_name` STRING COMMENT 'The legal name of the organization or entity that owns the rail wagon. May be a rail operator, leasing company, or port authority.',
    `refrigeration_capable` BOOLEAN COMMENT 'Indicates whether the wagon is equipped to carry refrigerated containers with power supply connections.',
    `registration_authority` STRING COMMENT 'The regulatory body or national authority that registered and certified the rail wagon for operation.',
    `registration_country_code` STRING COMMENT 'The three-letter ISO country code of the country where the wagon is registered.. Valid values are `^[A-Z]{3}$`',
    `registration_number` STRING COMMENT 'The official registration number issued by the registration authority, distinct from the wagon number and used for regulatory compliance tracking.',
    `residual_value` DECIMAL(18,2) COMMENT 'The estimated residual or salvage value of the wagon at the end of its useful life, used for depreciation calculations.',
    `rfid_tag_number` STRING COMMENT 'The unique identifier of the RFID tag attached to the wagon for automated tracking and identification in rail yards and terminals.',
    `swl_rating_kg` DECIMAL(18,2) COMMENT 'The Safe Working Load rating in kilograms, representing the maximum load the wagon can handle under normal operating conditions including dynamic forces during transport.',
    `tare_weight_kg` DECIMAL(18,2) COMMENT 'The empty weight of the rail wagon in kilograms, excluding any cargo or containers. Used for load planning and compliance with weight restrictions.',
    `wagon_number` STRING COMMENT 'The externally-known unique identification number assigned to the rail wagon by the owner or registration authority. This is the business identifier used in operational systems and documentation.',
    `wagon_type` STRING COMMENT 'Classification of the rail wagon based on its structural design and intended cargo type. Flat wagons have a flat deck, well wagons have a recessed center for double-stacking containers, spine wagons have a central spine for container placement.. Valid values are `flat|well|spine|gondola|hopper|boxcar`',
    `width_m` DECIMAL(18,2) COMMENT 'The width of the rail wagon in meters, important for clearance verification and loading gauge compliance.',
    CONSTRAINT pk_rail_wagon PRIMARY KEY(`rail_wagon_id`)
) COMMENT 'Master registry of rail wagons used in intermodal transport, including wagon number, type (flat, well, spine), tare weight, maximum payload, SWL rating, owner/operator, registration authority, and operational status. Supports container-to-wagon assignment and load planning.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` (
    `truck_appointment_id` BIGINT COMMENT 'Unique identifier for the truck appointment record. Primary key for the truck appointment entity.',
    `access_credential_id` BIGINT COMMENT 'Foreign key linking to security.access_credential. Business justification: Driver credentials must be pre-validated against truck appointments for gate access authorization, MARSEC-level clearance verification, and appointment-credential matching - core port gate security an',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Truck gate appointments validate service entitlement and pricing against terminal access agreements. Real business process: appointment authorization checks contracted service scope and applies agreed',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Vessel-side truck appointments reference specific berth for container pickup/delivery during vessel operations, enabling vessel discharge/loading coordination and berth productivity tracking - vessel ',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: Truck gate appointments for container pickup/delivery require cargo booking reference for customs clearance validation, delivery order verification, VGM compliance checking, and hazmat documentation v',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Gate operations are organized as cost centers; truck appointments consume gate resources (labor, equipment, utilities) that must be allocated to responsible cost center for activity-based costing, gat',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Truck appointment booking and confirmation requires employee accountability for customer service quality, dispute resolution, and audit trail. Gate operations track which employee processed each appoi',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Gate appointments require verified customs clearance before container release authorization. Port gate operations check declaration status to enforce regulatory compliance and prevent unauthorized car',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Appointment system checks for active holds before slot confirmation as pre-gate screening. Booking systems prevent appointment creation for held containers to avoid wasted truck trips and gate congest',
    `port_access_permit_id` BIGINT COMMENT 'Foreign key linking to customer.port_access_permit. Business justification: Truck appointments require valid port access permits for drivers entering secure ISPS-regulated port facilities. Enables permit verification at appointment booking and gate entry, critical for maritim',
    `haulier_id` BIGINT COMMENT 'Foreign key linking to intermodal.haulier. Business justification: Truck appointments are made by hauliers (road transport carriers). The haulier is the booking party. Linking allows retrieval of booking_party_name from haulier table when booking party is a haulier.',
    `inspection_id` BIGINT COMMENT 'Foreign key linking to safety.safety_inspection. Business justification: Pre-gate safety inspections verify vehicle roadworthiness, ISPS compliance, hazmat placarding before terminal entry. Standard port security protocol requires inspection record linkage to appointment f',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Appointments specify container types for gate planning, equipment compatibility checks, and handling resource allocation. Replaces denormalized container_type text field with proper master data refere',
    `participant_account_id` BIGINT COMMENT 'Identifier of the party making the appointment booking. References the shipping line, freight forwarder, or cargo owner responsible for the booking.',
    `permit_to_work_id` BIGINT COMMENT 'Foreign key linking to safety.permit_to_work. Business justification: Hot work on reefer units, confined space entry for tank container inspection, or hazmat handling during truck operations requires PTW authorization. ISPS and port safety regulations mandate permit lin',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Truck appointments depend on gate infrastructure assets (OCR systems, RFID readers, barrier gates, weighbridges). Appointment capacity planning requires knowing asset availability and operational stat',
    `call_id` BIGINT COMMENT 'Identifier of the vessel visit associated with this appointment. Links the appointment to the specific vessel call for import/export operations.',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: Truck appointments specify entry/exit gate for access control, security screening, and traffic management - core gate operations process in port terminals.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Appointments are scheduled to specific terminal locations. Gate operations, slot management, and yard routing depend on proper location reference. Replaces denormalized terminal_location_code.',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Truck appointments for contracted customers reference negotiated rate cards for gate processing and handling charges. Required for appointment-based billing and revenue allocation.',
    `sanctions_screening_id` BIGINT COMMENT 'Foreign key linking to compliance.sanctions_screening. Business justification: Pre-gate screening of haulier and cargo against sanctions lists is security protocol. Appointment systems validate screening results before slot confirmation to enforce ISPS compliance and prevent san',
    `shipping_line_id` BIGINT COMMENT 'Identifier of the shipping line or carrier responsible for the container. References the ocean carrier or vessel operator.',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: Truck appointments are made to execute transport orders. The appointment reserves a gate slot for the transport order. Linking allows retrieval of booking and BOL from transport_order.',
    `intermodal_service_id` BIGINT COMMENT 'Identifier of the rail service or train for rail-on/rail-off appointments. Links the appointment to scheduled rail operations.',
    `truck_service_id` BIGINT COMMENT 'Foreign key linking to intermodal.intermodal_service. Business justification: Truck appointments may be for specific intermodal services (e.g., rail shuttle service requiring truck gate appointment). Nullable FK (only populated when appointment is for a specific service). Allow',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Truck appointments specify terminal locations (yard_block_location, terminal_location_code) that map to security zones for MARSEC-level access control, ISPS compliance verification, and zone-specific ',
    `actual_arrival_time` TIMESTAMP COMMENT 'Actual timestamp when the vehicle arrived at the gate or facility. Captured by gate automation systems.',
    `actual_departure_time` TIMESTAMP COMMENT 'Actual timestamp when the vehicle departed from the gate or facility after completing the transaction.',
    `appointment_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the appointment record was first created in the system. Audit trail for booking lifecycle.',
    `appointment_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the appointment record was last modified. Tracks amendments and updates to the booking.',
    `appointment_reference_number` STRING COMMENT 'Externally-known unique reference number for the appointment or booking, generated by the Truck Appointment System (TAS) or intermodal booking portal. Used for customer communication and tracking.. Valid values are `^[A-Z0-9]{8,20}$`',
    `appointment_status` STRING COMMENT 'Current lifecycle status of the appointment. Tracks progression from initial request through completion or cancellation.. Valid values are `requested|confirmed|amended|cancelled|no_show|completed`',
    `appointment_type` STRING COMMENT 'Type of intermodal transaction being booked. Defines the nature of the container movement through the terminal gate or rail facility.. Valid values are `import_pickup|export_delivery|empty_return|rail_on|rail_off|transshipment`',
    `booking_channel` STRING COMMENT 'Channel through which the appointment was booked. Indicates the interface or method used to create the reservation.. Valid values are `tas_portal|edi|mobile_app|api|phone|email`',
    `cancellation_reason` STRING COMMENT 'Free-text explanation for why the appointment was cancelled. Supports operational analysis and customer service.',
    `cancellation_timestamp` TIMESTAMP COMMENT 'Timestamp when the appointment was cancelled. Null if the appointment was not cancelled.',
    `cargo_weight_kg` DECIMAL(18,2) COMMENT 'Total weight of the cargo in kilograms. Used for safety verification and equipment allocation.',
    `confirmed_slot_end_time` TIMESTAMP COMMENT 'End of the confirmed time window allocated by the terminal.',
    `confirmed_slot_start_time` TIMESTAMP COMMENT 'Start of the confirmed time window allocated by the terminal. May differ from requested time based on capacity availability.',
    `container_count` STRING COMMENT 'Number of containers included in this appointment. Typically 1 for truck appointments, may be multiple for rail or barge.',
    `container_number` STRING COMMENT 'ISO 6346 standard container identification number. Primary reference for the container being moved in this appointment.. Valid values are `^[A-Z]{4}[0-9]{7}$`',
    `container_size` STRING COMMENT 'Length of the container in feet. Standard sizes are 20-foot, 40-foot, and 45-foot containers.. Valid values are `20|40|45`',
    `delivery_order_number` STRING COMMENT 'Delivery order reference issued by the shipping line authorizing release of the container to the consignee or their agent.',
    `driver_license_number` STRING COMMENT 'Drivers license or identification number. Used for security verification and access authorization.',
    `driver_name` STRING COMMENT 'Full name of the driver operating the vehicle. Required for security and access control purposes.',
    `driver_phone_number` STRING COMMENT 'Contact phone number for the driver. Used for communication regarding appointment changes or gate issues.',
    `gate_lane_number` STRING COMMENT 'Specific gate lane assigned for the appointment. Used for traffic management and gate capacity optimization.',
    `imdg_class` STRING COMMENT 'IMDG classification code for hazardous cargo. Required when is_hazardous is true. Determines handling and storage requirements.',
    `is_hazardous` BOOLEAN COMMENT 'Flag indicating whether the cargo contains hazardous or dangerous goods requiring special handling per IMDG Code.',
    `is_oversized` BOOLEAN COMMENT 'Flag indicating whether the cargo has out-of-gauge dimensions requiring special handling or routing.',
    `is_overweight` BOOLEAN COMMENT 'Flag indicating whether the container exceeds standard weight limits, requiring special handling or permits.',
    `is_reefer` BOOLEAN COMMENT 'Flag indicating whether the container is a refrigerated (reefer) unit requiring temperature control and power connection.',
    `no_show_flag` BOOLEAN COMMENT 'Indicates whether the booking party failed to arrive for a confirmed appointment. Used for performance tracking and penalty assessment.',
    `reefer_temperature_celsius` DECIMAL(18,2) COMMENT 'Required temperature setting for refrigerated containers in degrees Celsius. Critical for cargo integrity.',
    `requested_slot_end_time` TIMESTAMP COMMENT 'End of the requested time window for the appointment. Represents the latest time within the booking window.',
    `requested_slot_start_time` TIMESTAMP COMMENT 'Start of the requested time window for the appointment. Represents the earliest time the booking party wishes to arrive.',
    `teu_quantity` DECIMAL(18,2) COMMENT 'Total TEU capacity represented by this appointment. Used for capacity planning and throughput measurement. One 40-foot container equals 2 TEU.',
    `transport_mode` STRING COMMENT 'Mode of transport for which the appointment is made. Determines the facility and handling procedures.. Valid values are `road|rail|barge`',
    `un_number` STRING COMMENT 'Four-digit UN number identifying the hazardous substance. Required for dangerous goods shipments.. Valid values are `^UN[0-9]{4}$`',
    `vehicle_registration_number` STRING COMMENT 'License plate or registration number of the truck or vehicle. Used for gate identification and access control.',
    `vehicle_type` STRING COMMENT 'Type of vehicle or conveyance used for the appointment. Determines handling requirements and gate procedures.. Valid values are `truck|trailer|chassis|rail_wagon|barge`',
    `yard_block_location` STRING COMMENT 'Yard block or stack location where the container is stored or will be placed. Guides driver to container location for pickup.',
    CONSTRAINT pk_truck_appointment PRIMARY KEY(`truck_appointment_id`)
) COMMENT 'Transactional record for all intermodal capacity slot bookings including truck gate appointments, rail service reservations, and barge slot allocations, made through the Truck Appointment System (TAS), intermodal booking portal, or carrier EDI channels. Captures appointment/booking reference, slot time window, vehicle/train/barge identification, container reference, transaction type (import pickup, export delivery, empty return, rail-on, rail-off, transshipment), booking party (shipping line, freight forwarder, cargo owner), container count, TEU quantity, requested transport date, confirmed slot, and booking status lifecycle (requested, confirmed, amended, cancelled, no-show, completed). SSOT for all intermodal capacity reservation and gate slot management across road, rail, and barge modes.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` (
    `truck_visit_id` BIGINT COMMENT 'Unique identifier for the truck gate transaction. Primary key for the truck visit record.',
    `access_event_id` BIGINT COMMENT 'Foreign key linking to security.access_event. Business justification: Each gate transaction generates access control events linking physical truck entry/exit to credential verification, biometric checks, and security screening - ISPS audit trail and access control loggi',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Actual gate transactions verify customs clearance at point of entry/exit. Gate officers validate declaration status in real-time to enforce customs authority release requirements before allowing conta',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Gate transactions verify no active holds exist before allowing container exit. Gate officers check hold status in real-time as enforcement point to prevent release of detained cargo.',
    `drayage_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.drayage_order. Business justification: Truck visits execute drayage orders. When a truck arrives at the gate, the visit is linked to the drayage order being fulfilled. Linking allows retrieval of delivery order, booking, and BOL from draya',
    `gate_transaction_id` BIGINT COMMENT 'FK to terminal.gate_transaction.gate_transaction_id — Truck lifecycle tracking from intermodal appointment through gate execution requires joining truck_visit to the terminal gate_transaction. Without this, truck turnaround time analytics are impossible.',
    `haulier_id` BIGINT COMMENT 'Reference to the drayage or trucking company operating the vehicle. Used for performance tracking and billing of terminal handling charges.',
    `inspection_id` BIGINT COMMENT 'Foreign key linking to safety.safety_inspection. Business justification: Gate transaction safety verification (container condition, seal integrity, hazmat compliance, damage inspection) generates inspection record. Required for ISPS compliance reporting and incident invest',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Truck visits require weighbridge assets for VGM compliance and overweight detection. Weighbridge calibration certificates, maintenance records, and operational status must be tracked per transaction f',
    `shipping_line_id` BIGINT COMMENT 'Reference to the ocean carrier or shipping line that owns or operates the container. Used for billing and operational coordination.',
    `truck_appointment_id` BIGINT COMMENT 'Reference to the pre-booked truck appointment that this visit is executing against. Links the actual gate transaction to the scheduled appointment slot.',
    `employee_id` BIGINT COMMENT 'Reference to the registered driver who presented credentials at the gate. Links to the driver master record for identity verification and access control.',
    `truck_employee_id` BIGINT COMMENT 'Reference to the terminal employee who processed the gate transaction. Used for operator performance tracking and audit trail.',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Gate transactions occur at specific security zones requiring zone-based access clearance, ISPS compliance checks, and MARSEC-level authorization - core port security process linking physical entry to ',
    `actual_arrival_time` TIMESTAMP COMMENT 'Timestamp when the truck physically arrived at the gate entry point, typically captured by automated gate sensors or manual gate operator entry. This is the principal business event timestamp for the transaction.',
    `container_condition` STRING COMMENT 'Status of the container at the time of gate transaction indicating whether it is loaded with cargo (full), empty, or has visible damage requiring inspection.. Valid values are `full|empty|damaged`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this truck visit record was first created in the Terminal Operating System. Used for audit trail and data lineage tracking.',
    `damage_report_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether visible damage to the container or cargo was observed and documented during the gate transaction. Triggers damage inspection workflow.',
    `driver_license_number` STRING COMMENT 'Government-issued drivers license number presented at the gate for identity verification. Captured for security and compliance purposes.. Valid values are `^[A-Z0-9]{6,20}$`',
    `driver_verification_method` STRING COMMENT 'Method used to verify the drivers identity at the gate, including biometric scan, RFID access card, manual ID document check, or facial recognition system.. Valid values are `biometric|rfid_card|manual_id_check|facial_recognition`',
    `gate_in_time` TIMESTAMP COMMENT 'Timestamp when the truck completed all gate-in processing and was authorized to enter the terminal yard. Represents the completion of inbound gate transaction.',
    `gate_lane_number` BIGINT COMMENT 'Reference to the specific physical gate lane where this truck transaction was processed. Used for gate throughput analysis and lane performance measurement.',
    `gate_out_time` TIMESTAMP COMMENT 'Timestamp when the truck completed all gate-out processing and exited the terminal. Represents the completion of outbound gate transaction.',
    `isps_compliance_check_result` STRING COMMENT 'Result of the ISPS security compliance verification performed at the gate, indicating whether the driver and vehicle met all required security protocols for port facility access.. Valid values are `passed|failed|waived|not_applicable`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this truck visit record was last updated. Used for change tracking and audit trail.',
    `license_plate_number` STRING COMMENT 'Vehicle registration plate number of the truck, typically captured via Optical Character Recognition (OCR) system at the gate. Used for vehicle identification and tracking.. Valid values are `^[A-Z0-9-]{4,15}$`',
    `ocr_confidence_score` DECIMAL(18,2) COMMENT 'Confidence percentage (0-100) of the automated OCR systems license plate read accuracy. Low scores may trigger manual verification by gate operators.',
    `rejection_reason` STRING COMMENT 'Detailed explanation of why the gate transaction was rejected, including documentation issues, security failures, equipment problems, or system errors. Populated when transaction_status is rejected.',
    `remarks` STRING COMMENT 'Additional free-text notes or comments recorded by the gate operator regarding special circumstances, exceptions, or observations during the transaction.',
    `seal_verification_status` STRING COMMENT 'Result of the container seal inspection at the gate, indicating whether the seal was intact and matched documentation (verified), was found broken, was missing, or was not applicable for this transaction type.. Valid values are `verified|broken|missing|not_applicable`',
    `transaction_status` STRING COMMENT 'Current lifecycle status of the gate transaction indicating whether the visit has been successfully completed, is still in progress at the gate, was rejected due to compliance or documentation issues, was cancelled by the driver or terminal, or is awaiting additional inspection.. Valid values are `completed|in_progress|rejected|cancelled|pending_inspection`',
    `turnaround_time_minutes` STRING COMMENT 'Total elapsed time in minutes from actual arrival at the gate to final gate-out completion. Key performance indicator (KPI) for gate efficiency and truck dwell time measurement.',
    `visit_type` STRING COMMENT 'Classification of the truck visit transaction indicating whether the truck is entering the terminal (gate-in), exiting the terminal (gate-out), or performing both operations in a single visit (dual transaction for drop-and-pick scenarios).. Valid values are `gate_in|gate_out|dual_transaction`',
    CONSTRAINT pk_truck_visit PRIMARY KEY(`truck_visit_id`)
) COMMENT 'Transactional record of each truck gate transaction at the port, capturing actual arrival time, gate-in/gate-out timestamps, lane assignment, OCR plate read, driver identity verification, ISPS compliance check result, turnaround time, and linked appointment reference. Represents the execution record against a truck appointment booking. SSOT for truck gate throughput measurement.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` (
    `drayage_order_id` BIGINT COMMENT 'Unique identifier for the drayage order record. Primary key for the drayage order entity.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Drayage services are contracted with hauliers under framework agreements specifying rates per move, service areas, and performance requirements. Real business process: order pricing lookup and haulier',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: Drayage orders execute last-mile container delivery from port to consignee. Operations require linking to cargo booking for delivery order number validation, consignee details, customs status verifica',
    `container_id` BIGINT COMMENT 'Reference to the container being moved under this drayage order. Links to the container master record.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Drayage operations are organized as cost centers; each drayage order incurs costs (fuel, labor, equipment) that must be captured against responsible cost center for drayage service line profitability ',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Drayage dispatch depends on customs clearance status for container pickup authorization. Operators verify declaration clearance before assigning trucks to avoid failed pickups and demurrage charges fr',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Drayage operations must check for active customs holds before container release. Dispatch systems query hold status to prevent unauthorized pickups and avoid penalties from moving detained cargo.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Drayage orders specify target terminal zone for container placement, enabling yard planning, slot allocation, and equipment dispatch - core terminal operations process.',
    `access_credential_id` BIGINT COMMENT 'Foreign key linking to security.access_credential. Business justification: Haulier driver credentials must be verified for container pickup/delivery authorization, background check validation, and MARSEC-level clearance - security clearance process for cargo handling authori',
    `employee_id` BIGINT COMMENT 'Reference to the specific driver assigned to this drayage movement. Links to driver master record for access control and performance tracking.',
    `haulier_id` BIGINT COMMENT 'Reference to the road haulier (trucking company) assigned to execute this drayage order. Links to the participant account master.',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Drayage orders move specific container types requiring chassis assignment, handling equipment selection, and route planning based on equipment dimensions and weight limits.',
    `ohs_incident_id` BIGINT COMMENT 'Foreign key linking to safety.ohs_incident. Business justification: Drayage incidents (loading accidents, container drops, driver injuries, hazmat spills) must link to specific order for liability determination, root cause analysis, and regulatory reporting. Mandatory',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Drayage from vessel references berth for container pickup during discharge operations, enabling vessel-to-gate coordination and berth turnaround optimization - vessel discharge process.',
    `icd_facility_id` BIGINT COMMENT 'Foreign key linking to intermodal.icd_facility. Business justification: When origin_location_type = ICD, this FK links to the specific inland container depot. Nullable FK (only populated when origin is an ICD facility). Resolves silo issue for icd_facility. origin_locat',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Drayage origin locations (container yards, berths, ICD facilities) are within designated security zones requiring zone-exit authorization, customs clearance verification, and security screening before',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Drayage from warehouse references specific warehouse for container pickup, enabling warehouse-to-gate coordination, inventory release tracking, and warehouse utilization reporting - warehousing operat',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Drayage container pickup/delivery at port terminals requires specific handling equipment (reach stackers, forklifts, empty handlers). Equipment assignment is critical for execution planning, operator ',
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: Drayage orders are issued to move containers to/from specific vessel port calls. Terminal planners, vessel operators, and billing systems require this link to coordinate landside movements with vessel',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Drayage destinations within port require proper location reference for delivery routing, proof-of-delivery validation, and distance-based pricing. Replaces denormalized destination_location_code.',
    `trade_document_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_document. Business justification: Drayage requires verification of trade documents before container movement. Dispatch systems check document completeness (delivery orders, release notes) to authorize pickup and prevent failed deliver',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: Drayage orders execute transport order instructions. The drayage_order is the operational execution record for container movement, while transport_order is the instruction (IFTMIN message). Linking al',
    `actual_delivery_timestamp` TIMESTAMP COMMENT 'Actual date and time when the container was delivered to the destination location. Captured via gate system, customer confirmation, or proof of delivery.',
    `actual_pickup_timestamp` TIMESTAMP COMMENT 'Actual date and time when the container was picked up from the origin location. Captured via gate system or manual confirmation.',
    `cancellation_reason` STRING COMMENT 'Reason for drayage order cancellation if status is CANCELLED. Used for root cause analysis and process improvement.',
    `container_condition` STRING COMMENT 'Physical condition of the container at pickup. Documented to establish liability for any damage occurring during drayage movement.. Valid values are `GOOD|DAMAGED|REQUIRES_INSPECTION`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the drayage order record was first created in the system. Audit trail for order lifecycle tracking.',
    `delivery_order_number` STRING COMMENT 'Delivery Order number authorizing the release of the container to the haulier. Required for import container pickup from the terminal.',
    `destination_address` STRING COMMENT 'Full street address of the destination location for customer premises or off-port facilities. Required for last-mile delivery coordination.',
    `destination_location_type` STRING COMMENT 'Type of destination location for container delivery. CY = Container Yard, CFS = Container Freight Station, ICD = Inland Container Depot.. Valid values are `CY|CFS|ICD|CUSTOMER_PREMISES|VESSEL|RAIL_YARD`',
    `drayage_order_number` STRING COMMENT 'Business-facing unique drayage order number issued to road hauliers for container movement instructions. Externally referenced identifier for tracking and communication.. Valid values are `^DRY-[0-9]{8,12}$`',
    `drayage_status` STRING COMMENT 'Current lifecycle status of the drayage order. Tracks progression from order creation through assignment, execution, and completion or cancellation.. Valid values are `PENDING|ASSIGNED|IN_TRANSIT|COMPLETED|CANCELLED|FAILED`',
    `drayage_type` STRING COMMENT 'Classification of the drayage movement type. IMPORT = laden container from port to customer, EXPORT = laden container from customer to port, EMPTY_RETURN = empty container return, REPOSITIONING = container relocation between port facilities.. Valid values are `IMPORT|EXPORT|EMPTY_RETURN|EMPTY_PICKUP|REPOSITIONING|CROSS_TOWN`',
    `failure_reason` STRING COMMENT 'Reason for drayage order failure if status is FAILED (e.g., container not available, access denied, address incorrect). Used for exception management.',
    `hazmat_indicator` BOOLEAN COMMENT 'Flag indicating whether the container contains hazardous materials requiring special handling and routing per IMDG Code.',
    `imdg_class` STRING COMMENT 'IMDG hazard class for dangerous goods (e.g., Class 3 - Flammable Liquids). Required for hazmat drayage movements to ensure proper routing and handling.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the drayage order record was last updated. Audit trail for tracking changes to order details or status.',
    `order_priority` STRING COMMENT 'Priority level assigned to the drayage order for dispatch sequencing and resource allocation. URGENT orders receive expedited handling.. Valid values are `URGENT|HIGH|NORMAL|LOW`',
    `origin_address` STRING COMMENT 'Full street address of the origin location for customer premises or off-port facilities. Required for last-mile delivery coordination.',
    `origin_location_code` STRING COMMENT 'Code identifying the specific origin location (yard block, CFS zone, ICD facility code, or customer site code) where the container will be picked up.',
    `origin_location_type` STRING COMMENT 'Type of origin location for container pickup. CY = Container Yard, CFS = Container Freight Station, ICD = Inland Container Depot.. Valid values are `CY|CFS|ICD|CUSTOMER_PREMISES|VESSEL|RAIL_YARD`',
    `overweight_indicator` BOOLEAN COMMENT 'Flag indicating whether the container exceeds standard weight limits and requires special routing or permits for road transport.',
    `pod_signature_name` STRING COMMENT 'Name of the person who signed for the container delivery at the destination. Captured for delivery verification and dispute resolution.',
    `proof_of_delivery_received` BOOLEAN COMMENT 'Flag indicating whether proof of delivery documentation has been received from the haulier confirming successful container delivery.',
    `proof_of_delivery_timestamp` TIMESTAMP COMMENT 'Date and time when proof of delivery was received and validated. Used for billing trigger and service level agreement measurement.',
    `reefer_indicator` BOOLEAN COMMENT 'Flag indicating whether the container is a refrigerated unit requiring temperature-controlled transport and genset-equipped truck.',
    `scheduled_delivery_date` DATE COMMENT 'Planned date for container delivery to the destination location. Used for customer appointment scheduling and receiving dock planning.',
    `scheduled_delivery_time_window_end` TIMESTAMP COMMENT 'End of the time window for container delivery. Defines the latest time the haulier may arrive for delivery without incurring penalties.',
    `scheduled_delivery_time_window_start` TIMESTAMP COMMENT 'Start of the time window for container delivery. Defines the earliest time the haulier may arrive for delivery.',
    `scheduled_pickup_date` DATE COMMENT 'Planned date for container pickup from the origin location. Used for truck appointment scheduling and yard planning.',
    `scheduled_pickup_time_window_end` TIMESTAMP COMMENT 'End of the time window for container pickup. Defines the latest time the haulier may arrive for pickup without incurring penalties.',
    `scheduled_pickup_time_window_start` TIMESTAMP COMMENT 'Start of the time window for container pickup. Defines the earliest time the haulier may arrive for pickup.',
    `seal_number` STRING COMMENT 'Security seal number affixed to the container. Verified at pickup and delivery to ensure container integrity and prevent tampering.',
    `special_handling_instructions` STRING COMMENT 'Free-text instructions for special handling requirements (e.g., fragile cargo, top-loader only, escort required). Communicated to haulier for execution.',
    `temperature_setting_celsius` DECIMAL(18,2) COMMENT 'Required temperature setting in Celsius for reefer containers. Haulier must maintain this temperature during drayage movement.',
    `truck_license_plate` STRING COMMENT 'License plate number of the truck assigned to perform the drayage movement. Used for gate access and tracking.',
    `un_number` STRING COMMENT 'Four-digit UN number identifying the hazardous substance (e.g., UN1203 for gasoline). Required for hazmat drayage compliance and emergency response.. Valid values are `^UN[0-9]{4}$`',
    `verified_gross_mass_kg` DECIMAL(18,2) COMMENT 'SOLAS-compliant verified gross mass of the packed container in kilograms. Required for export containers and used for route planning and vehicle selection.',
    CONSTRAINT pk_drayage_order PRIMARY KEY(`drayage_order_id`)
) COMMENT 'Transactional record for container drayage instructions issued to road hauliers, capturing drayage order number, container reference, origin/destination (CY, CFS, ICD, customer premises), haulier assignment, scheduled pickup and delivery windows, drayage status, and proof-of-delivery confirmation. SSOT for last-mile container drayage coordination.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` (
    `icd_facility_id` BIGINT COMMENT 'Unique system identifier for the ICD or CFS facility record. Primary key.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: ICD facilities operate under concession or service agreements defining operational scope, revenue sharing arrangements, performance obligations, and service standards. Real business process: facility ',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Each ICD facility operates as a distinct cost center; all facility operating expenses (rent, utilities, labor, maintenance) are accumulated against facility cost center for facility-level P&L analysis',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: ICD facilities require on-site manager assignment for operational oversight, vendor coordination, compliance monitoring, and escalation handling. Port networks track facility managers for accountabili',
    `facility_security_plan_id` BIGINT COMMENT 'Foreign key linking to security.facility_security_plan. Business justification: Every ICD facility interfacing with port operations requires an approved ISPS-compliant facility security plan with PFSO designation, MARSEC procedures, and security assessment - ISPS Code regulatory ',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: ICDs are physical locations within port infrastructure hierarchy. Spatial planning, distance calculations for drayage pricing, and facility master data management require proper location reference.',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: ICD facilities generate revenue from storage, handling, customs services; each facility is a profit center for segment reporting, enabling management to assess facility-level profitability, investment',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: ICD facility construction, expansion, or major refurbishment projects are tracked via WBS elements; linking facility to WBS enables capitalization of project costs to correct asset, post-commissioning',
    `active_from_date` DATE COMMENT 'Date when the facility became operational and available for container handling in the ports intermodal network. Used for historical analysis and facility lifecycle tracking.',
    `active_to_date` DATE COMMENT 'Date when the facility ceased operations or was decommissioned. Nullable for currently active facilities. Used for historical reporting and capacity planning.',
    `address_line_1` STRING COMMENT 'Primary street address line of the ICD or CFS facility, including building number and street name. Used for truck dispatch routing and delivery instructions.',
    `address_line_2` STRING COMMENT 'Secondary address line for additional location details such as suite, building, or zone information. Optional field for complex facility addresses.',
    `average_drayage_time_hours` DECIMAL(18,2) COMMENT 'Average transit time for container drayage between the port and the ICD facility, measured in hours. Used for service level agreement (SLA) definition and operational planning.',
    `billing_currency_code` STRING COMMENT 'Three-letter ISO currency code used for billing and financial transactions with the facility operator (e.g., USD, EUR, INR). Used in invoice generation and revenue accounting.. Valid values are `^[A-Z]{3}$`',
    `city` STRING COMMENT 'City or municipality where the ICD or CFS facility is located. Used for geographic routing and regional logistics planning.',
    `contract_end_date` DATE COMMENT 'Date when the current service agreement or partnership contract expires. Nullable for open-ended agreements. Used for contract renewal planning and relationship management.',
    `contract_start_date` DATE COMMENT 'Date when the service agreement or partnership contract between the port and the ICD operator became effective. Used for contract lifecycle management and billing period determination.',
    `country_code` STRING COMMENT 'Three-letter ISO country code where the ICD or CFS facility is located (e.g., USA, IND, CHN). Used for customs clearance, trade compliance, and international logistics coordination.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this facility record was first created in the master data system. Used for data lineage, audit trails, and record lifecycle tracking.',
    `customs_bonded_facility` BOOLEAN COMMENT 'Indicates whether the facility is authorized as a customs bonded warehouse, allowing storage of imported goods before duty payment. True if bonded status is active; False otherwise. Critical for trade compliance and duty deferral operations.',
    `customs_license_number` STRING COMMENT 'Official license or registration number issued by customs authorities for bonded warehouse operations. Required for facilities with customs_bonded_facility = True. Used in customs declarations and trade documentation.',
    `dangerous_goods_certified` BOOLEAN COMMENT 'Indicates whether the facility is certified to handle IMDG (International Maritime Dangerous Goods) classified cargo. True if IMDG certification is active; False otherwise. Required for hazardous material storage and handling.',
    `data_source_system` STRING COMMENT 'Name of the operational system that is the authoritative source for this facility record (e.g., NAVIS N4, Port Community System, SAP ERP). Used for data lineage and integration troubleshooting.',
    `distance_from_port_km` DECIMAL(18,2) COMMENT 'Road distance from the main port terminal to the ICD facility measured in kilometers. Used for drayage cost calculation, transit time estimation, and last-mile delivery planning.',
    `edi_connectivity_status` STRING COMMENT 'Current status of EDI integration between the ports systems and the ICD facility. CONNECTED indicates active EDI messaging (COPARN, IFTMIN, BAPLIE), NOT_CONNECTED for manual processes, PENDING for integration in progress, SUSPENDED for temporarily disabled connections.. Valid values are `CONNECTED|NOT_CONNECTED|PENDING|SUSPENDED`',
    `edi_protocol` STRING COMMENT 'Technical protocol used for EDI message exchange with the facility. EDIFACT for UN/EDIFACT standard, XML for web services, AS2 for secure file transfer, SFTP for batch file exchange, API for real-time integration.. Valid values are `EDIFACT|XML|AS2|SFTP|API`',
    `facility_code` STRING COMMENT 'Unique business identifier code assigned to the ICD or CFS facility, used in operational systems and EDI messaging (COPARN, IFTMIN). Typically alphanumeric, 4-10 characters.. Valid values are `^[A-Z0-9]{4,10}$`',
    `facility_name` STRING COMMENT 'Official registered name of the ICD or CFS facility as recognized by port authorities and logistics partners.',
    `facility_type` STRING COMMENT 'Classification of the inland facility: ICD (Inland Container Depot) for full container handling, CFS (Container Freight Station) for LCL consolidation/deconsolidation, or HYBRID for facilities offering both services.. Valid values are `ICD|CFS|HYBRID`',
    `fcl_service_available` BOOLEAN COMMENT 'Indicates whether the facility provides FCL (Full Container Load) handling services. True if the facility can receive, store, and dispatch full containers; False otherwise.',
    `imdg_license_number` STRING COMMENT 'Official license or certification number for dangerous goods handling issued by maritime safety authorities. Required when dangerous_goods_certified = True. Used in hazmat compliance reporting.',
    `isps_compliant` BOOLEAN COMMENT 'Indicates whether the facility meets ISPS Code security requirements for port facilities. True if ISPS certification is current; False otherwise. Mandatory for facilities handling international cargo.',
    `last_modified_by` STRING COMMENT 'User identifier or system account that last modified this facility record. Used for audit trails and data governance accountability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this facility record was last updated. Used for change tracking, data synchronization, and audit compliance.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the facility in decimal degrees format. Used for GPS navigation, route optimization, and geospatial analytics. Range: -90.0000000 to +90.0000000.',
    `lcl_service_available` BOOLEAN COMMENT 'Indicates whether the facility provides LCL (Less than Container Load) consolidation and deconsolidation services. True if the facility operates as a CFS for break-bulk cargo; False otherwise.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the facility in decimal degrees format. Used for GPS navigation, route optimization, and geospatial analytics. Range: -180.0000000 to +180.0000000.',
    `operating_hours` STRING COMMENT 'Standard operating hours of the facility in local time, typically formatted as day ranges and time ranges (e.g., Mon-Fri 08:00-18:00, Sat 08:00-14:00). Used for truck appointment scheduling and gate operations planning.',
    `operational_status` STRING COMMENT 'Current operational state of the facility in the ports intermodal network. ACTIVE indicates full operations, INACTIVE for temporary closure, SUSPENDED for regulatory or safety holds, UNDER_CONSTRUCTION for facilities being built, DECOMMISSIONED for permanently closed facilities.. Valid values are `ACTIVE|INACTIVE|SUSPENDED|UNDER_CONSTRUCTION|DECOMMISSIONED`',
    `operator_contact_email` STRING COMMENT 'Primary email address for operational coordination and communication with the facility operator. Used for EDI notifications, booking confirmations, and service requests.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `operator_contact_phone` STRING COMMENT 'Primary telephone number for operational coordination with the facility operator, including country code. Used for urgent operational matters and emergency contact.',
    `operator_name` STRING COMMENT 'Legal name of the company or organization operating the ICD or CFS facility. May be a third-party logistics provider, port authority subsidiary, or independent operator.',
    `postal_code` STRING COMMENT 'Postal or ZIP code for the facility address. Used for mail delivery, geographic analysis, and logistics routing optimization.',
    `rail_connectivity` BOOLEAN COMMENT 'Indicates whether the facility has direct rail access for intermodal container transfer. True if rail siding or terminal connection exists; False for truck-only facilities. Critical for rail operations planning and modal shift strategies.',
    `reefer_plug_capacity` STRING COMMENT 'Number of electrical plug-in points available for refrigerated containers (reefers) requiring temperature control. Used for cold chain logistics planning and reefer container allocation.',
    `security_level` STRING COMMENT 'Current ISPS security level of the facility. LEVEL_1 for normal operations, LEVEL_2 for heightened security risk, LEVEL_3 for imminent security threat. Determines access control and security protocols.. Valid values are `LEVEL_1|LEVEL_2|LEVEL_3`',
    `sla_turnaround_time_hours` DECIMAL(18,2) COMMENT 'Contractual maximum turnaround time for container processing at the facility, measured in hours from gate-in to gate-out. Used for SLA compliance monitoring and performance measurement.',
    `state_province` STRING COMMENT 'State, province, or administrative region where the facility is located. Used for regulatory compliance and regional operational planning.',
    `storage_capacity_teu` STRING COMMENT 'Maximum container storage capacity of the facility measured in TEU (Twenty-foot Equivalent Units). Used for capacity planning, yard management, and operational load balancing across the intermodal network.',
    `truck_parking_capacity` STRING COMMENT 'Maximum number of trucks that can be accommodated simultaneously in the facilitys parking and staging areas. Used for truck appointment system capacity planning and gate congestion management.',
    `twenty_four_seven_operations` BOOLEAN COMMENT 'Indicates whether the facility operates 24 hours a day, 7 days a week. True for round-the-clock operations; False for facilities with limited operating hours. Impacts truck appointment system configuration and service level agreements.',
    CONSTRAINT pk_icd_facility PRIMARY KEY(`icd_facility_id`)
) COMMENT 'Master record for Inland Container Depots (ICDs) and Container Freight Stations (CFS) linked to the port, capturing facility code, name, address, geographic coordinates, operator, storage capacity (TEU), available services (FCL, LCL, customs bonded), operating hours, and EDI connectivity status. SSOT for inland depot reference data.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` (
    `transport_order_id` BIGINT COMMENT 'Unique identifier for the intermodal transport order. Primary key for the transport order entity.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Intermodal transport orders execute under master service agreements with freight forwarders/BCOs defining rates, liability limits, and service standards. Real business process: order acceptance valida',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: Transport orders execute intermodal movements for containers from cargo bookings. Port operations require linking transport orders to originating cargo bookings for delivery order validation, customs ',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Transport orders carry specific commodities requiring handling rules, storage area assignment, customs classification, hazmat compliance, and tariff calculation. Replaces denormalized hs_code with pro',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Transport orders require employee ownership for customer service, issue escalation, customs coordination, and operational problem-solving. Intermodal operations track order coordinators for accountabi',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Intermodal transport orders consume resources across multiple cost centers (planning, execution, customer service); linking enables activity-based costing, service line profitability analysis, and cos',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Intermodal transport orders track customs clearance for cross-border movements. Transport planners monitor declaration status to coordinate mode transfers and ensure regulatory compliance throughout m',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Transport orders specify terminal zone for final container delivery, enabling logistics coordination, capacity planning, and zone utilization reporting - supply chain visibility requirement.',
    `import_export_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.import_export_permit. Business justification: Controlled goods transport requires permit validation before movement authorization. Transport planners verify permit validity for restricted commodities (dual-use, CITES, strategic goods) to ensure r',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Transport orders specify equipment type for intermodal compatibility, mode selection, and pricing calculation. Replaces denormalized container_type text field with proper master data reference.',
    `icd_facility_id` BIGINT COMMENT 'Foreign key linking to intermodal.icd_facility. Business justification: When origin_location is an ICD facility, this FK links to the specific depot. Nullable FK (only populated when origin is an ICD). origin_location_code remains as fallback for non-ICD origins. Resolves',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Transport orders originating from warehouse enable supply chain visibility, warehouse inventory tracking, and multimodal logistics coordination - supply chain management requirement.',
    `participant_account_id` BIGINT COMMENT 'Identifier of the party shipping the cargo. References the port community participant acting as the consignor.',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Transport orders use negotiated rate cards for contracted customers. Critical for order pricing, invoicing, and revenue recognition in intermodal transport operations.',
    `intermodal_service_id` BIGINT COMMENT 'Foreign key linking to intermodal.intermodal_service. Business justification: Transport orders are routed via specific intermodal services. The service defines the corridor and mode; the order is the instruction. No columns removed because order has execution-specific attribute',
    `tertiary_transport_carrier_participant_account_id` BIGINT COMMENT 'Identifier of the transport carrier or haulier assigned to execute this transport order. References the logistics service provider.',
    `trade_document_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_document. Business justification: Transport orders reference supporting trade documents (certificates of origin, phytosanitary certificates) for documentary compliance. Operators verify document validity before cargo acceptance to ens',
    `trade_restriction_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_restriction. Business justification: Transport planning must screen cargo against active trade restrictions for sanctions compliance. Booking systems validate commodity/party against restriction lists to prevent prohibited movements and ',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to booking.call_booking. Business justification: Transport orders coordinate intermodal movements with vessel call schedules. Operations require vessel call booking reference to synchronize container availability windows, coordinate gate-in cutoff t',
    `actual_delivery_date` TIMESTAMP COMMENT 'Actual date and time when cargo was delivered to consignee. Used for SLA compliance and proof of delivery.',
    `actual_pickup_date` TIMESTAMP COMMENT 'Actual date and time when cargo was picked up from origin. Used for performance tracking and billing.',
    `bill_of_lading_number` STRING COMMENT 'BOL number associated with this transport order. Links to the legal document of title for the cargo.. Valid values are `^[A-Z0-9]{10,20}$`',
    `booking_reference` STRING COMMENT 'Reference to the original shipping booking or reservation that triggered this transport order. Links to upstream booking system.',
    `cargo_description` STRING COMMENT 'Textual description of the cargo contents. Provides human-readable summary of goods being transported.',
    `cargo_volume_cbm` DECIMAL(18,2) COMMENT 'Total volume of the cargo in cubic meters. Used for space planning and capacity management.',
    `cargo_weight_kg` DECIMAL(18,2) COMMENT 'Total weight of the cargo in kilograms. Used for load planning and compliance with weight restrictions.',
    `carrier_name` STRING COMMENT 'Legal name of the carrier organization responsible for transport execution.',
    `consignee_name` STRING COMMENT 'Legal name of the consignee organization. Captured for documentation and delivery verification.',
    `container_reference` STRING COMMENT 'ISO 6346 container number being transported. Links the transport order to the specific container unit.. Valid values are `^[A-Z]{4}[0-9]{7}$`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this transport order record was first created in the database. Used for audit trail.',
    `delivery_order_number` STRING COMMENT 'Delivery order number authorizing release of cargo to consignee. Used for cargo handover at destination.',
    `destination_location` STRING COMMENT 'Final delivery point for the intermodal transport. May be an inland container depot, customer facility, or distribution center.',
    `estimated_delivery_date` TIMESTAMP COMMENT 'Planned date and time for cargo delivery to destination. Used for customer communication and planning.',
    `estimated_pickup_date` TIMESTAMP COMMENT 'Planned date and time for cargo pickup from origin location. Used for scheduling and coordination.',
    `iftmin_reference` STRING COMMENT 'EDI IFTMIN message reference number for this transport instruction. Links to the electronic data interchange message sent to logistics partners.. Valid values are `^IFTMIN-[A-Z0-9]{10,20}$`',
    `imdg_class` STRING COMMENT 'IMDG hazard classification for dangerous goods (e.g., 3 for flammable liquids, 8 for corrosives). Null if cargo is non-hazardous.. Valid values are `^[1-9](.[1-9])?$`',
    `is_hazardous` BOOLEAN COMMENT 'Flag indicating whether the cargo contains dangerous goods requiring special handling per IMDG code.',
    `is_refrigerated` BOOLEAN COMMENT 'Flag indicating whether the cargo requires temperature-controlled transport (reefer container).',
    `last_updated_timestamp` TIMESTAMP COMMENT 'System timestamp when this transport order record was last modified. Used for change tracking and audit.',
    `order_date` TIMESTAMP COMMENT 'Date and time when the transport order was created and issued to the carrier. Represents the business event timestamp for order initiation.',
    `order_status` STRING COMMENT 'Current lifecycle status of the transport order. Tracks progression from initial draft through to final delivery or cancellation. [ENUM-REF-CANDIDATE: draft|confirmed|dispatched|in_transit|delivered|cancelled|on_hold — 7 candidates stripped; promote to reference product]',
    `origin_location` STRING COMMENT 'Starting point for the intermodal transport journey. May be a port terminal, container yard, or inland container depot.',
    `origin_location_code` STRING COMMENT 'UN/LOCODE or facility code identifying the origin location. Standardized location identifier for EDI integration.. Valid values are `^[A-Z]{2}[A-Z0-9]{3}$`',
    `primary_transport_mode` STRING COMMENT 'Dominant mode of transport for this order. Used for high-level categorization and reporting.. Valid values are `sea|rail|road|air|barge`',
    `priority_level` STRING COMMENT 'Priority classification for this transport order. Determines scheduling precedence and resource allocation.. Valid values are `standard|high|urgent|critical`',
    `required_delivery_date` DATE COMMENT 'Target date by which the cargo must be delivered to the final destination. Used for SLA tracking and scheduling.',
    `shipper_name` STRING COMMENT 'Legal name of the shipper organization. Captured for documentation and reference purposes.',
    `special_instructions` STRING COMMENT 'Free-text field for special handling instructions, delivery notes, or operational requirements for the carrier.',
    `temperature_setpoint_celsius` DECIMAL(18,2) COMMENT 'Required temperature setting for refrigerated cargo in degrees Celsius. Null for non-refrigerated cargo.',
    `teu_count` DECIMAL(18,2) COMMENT 'TEU equivalent for this transport order. Standard measure for container capacity (20ft = 1 TEU, 40ft = 2 TEU).',
    `transport_mode_sequence` STRING COMMENT 'Ordered sequence of transport modes for this intermodal journey (e.g., sea-rail-road, sea-road, rail-road). Defines the multimodal routing plan.',
    `transport_order_number` STRING COMMENT 'Business-facing unique transport order number issued to carrier or haulier. Externally visible identifier used in communications and documentation.. Valid values are `^TO-[0-9]{8,12}$`',
    `un_number` STRING COMMENT 'Four-digit UN identification number for dangerous goods. Null if cargo is non-hazardous.. Valid values are `^UN[0-9]{4}$`',
    CONSTRAINT pk_transport_order PRIMARY KEY(`transport_order_id`)
) COMMENT 'Core transactional record representing an intermodal transport instruction (IFTMIN message) issued to a carrier or haulier, capturing transport order number, IFTMIN reference, shipper, consignee, origin, destination, mode sequence (sea-rail-road), container reference, cargo description, HS code, required delivery date, and order status. SSOT for intermodal transport instruction lifecycle.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` (
    `intermodal_rail_wagon_load_id` BIGINT COMMENT 'Unique identifier for the rail wagon load association record. Primary key for this entity.',
    `bill_of_lading_id` BIGINT COMMENT 'Foreign key linking to cargo.bill_of_lading. Business justification: Rail operators require BOL reference for customs documentation verification, cargo ownership validation, and liability determination at rail-port interchange points. Essential for cross-border rail mo',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Individual wagon loads contain specific commodities requiring segregation rules, customs declarations, handling instructions, and hazmat compliance. Critical for rail cargo manifest and regulatory rep',
    `container_id` BIGINT COMMENT 'Reference to the container or cargo unit loaded onto this wagon. Nullable for empty wagon positions or non-containerized cargo.',
    `rail_visit_id` BIGINT COMMENT 'Reference to the rail visit during which this wagon load was planned or executed. Links this load record to the specific rail service arrival at the terminal.',
    `rail_wagon_id` BIGINT COMMENT 'Reference to the specific rail wagon (railcar) that carries this container or cargo unit. Identifies the physical wagon within the rail consist.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Rail wagon loading operations require supervisor accountability for cargo securing, weight compliance, hazmat handling, and safety protocols. Terminals track which employee supervised each load operat',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: Rail wagon loads fulfill transport orders. Each container loaded onto a wagon is executing a transport order instruction. Linking allows retrieval of booking, BOL, and AWB from transport_order.',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: Rail wagon loads contain containers for specific vessel voyages. Rail operators and terminal planners need this link to coordinate rail arrival/departure timing with vessel schedules, prioritize wagon',
    `actual_load_timestamp` TIMESTAMP COMMENT 'Actual date and time when this container or cargo unit was physically loaded onto the wagon. Captured by TOS or gate systems. Used for performance measurement and billing.',
    `consignee_reference` STRING COMMENT 'Consignee-provided reference number for cargo receipt and delivery confirmation. Used for delivery coordination and proof of delivery documentation.',
    `container_iso_type_code` STRING COMMENT 'Four-character ISO 6346 type code describing the container size and type (e.g., 22G1 for 20ft general purpose, 45G1 for 40ft high cube). Critical for weight distribution and wagon compatibility validation.. Valid values are `^[A-Z0-9]{4}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this rail wagon load record was first created in the system. Used for audit trail and data lineage tracking.',
    `customs_status` STRING COMMENT 'Current customs clearance status for this load. Indicates whether cargo has been cleared for onward movement or is held pending customs inspection or documentation.. Valid values are `cleared|pending|hold|released|bonded`',
    `destination_location_code` STRING COMMENT 'Five-character UN/LOCODE identifying the final destination location for this cargo on the rail network. Used for routing, delivery planning, and customs clearance.. Valid values are `^[A-Z]{5}$`',
    `gross_weight_kg` DECIMAL(18,2) COMMENT 'Total gross weight of the loaded container or cargo unit in kilograms, including tare weight and cargo. Critical for rail wagon weight distribution compliance and safe working load (SWL) validation.',
    `imdg_class` STRING COMMENT 'IMDG hazard classification for dangerous goods (e.g., Class 3 for flammable liquids, Class 8 for corrosives). Mandatory when is_hazardous is True. Drives segregation rules and emergency response procedures.. Valid values are `^(1|2.1|2.2|2.3|3|4.1|4.2|4.3|5.1|5.2|6.1|6.2|7|8|9)$`',
    `is_hazardous` BOOLEAN COMMENT 'Boolean flag indicating whether this load contains hazardous or dangerous goods requiring special handling and segregation per IMDG Code. True if hazardous, False otherwise.',
    `is_oversized` BOOLEAN COMMENT 'Boolean flag indicating whether this load exceeds standard dimensional limits (height, width, length) for rail transport. True if oversized, False otherwise. Requires clearance validation and special routing.',
    `is_overweight` BOOLEAN COMMENT 'Boolean flag indicating whether this load exceeds standard weight limits for the wagon type or rail infrastructure. True if overweight, False otherwise. Triggers special handling and route restrictions.',
    `is_reefer` BOOLEAN COMMENT 'Boolean flag indicating whether this is a refrigerated container requiring power connection and temperature monitoring during rail transport. True if reefer, False otherwise.',
    `lashing_instructions` STRING COMMENT 'Detailed instructions for securing and lashing the container or cargo unit to the wagon. Includes twist lock positions, chain requirements, and special securing equipment needed for safe rail transport.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this rail wagon load record was last updated. Used for change tracking and data synchronization across systems.',
    `load_sequence_number` STRING COMMENT 'Order in which this container or cargo unit was loaded onto the wagon. Supports operational tracking and unloading sequence planning.',
    `load_status` STRING COMMENT 'Current lifecycle status of this wagon load. Tracks progression from planning through loading, transit, and final delivery. Used for operational visibility and exception management.. Valid values are `planned|loaded|secured|in_transit|delivered|unloaded`',
    `net_cargo_weight_kg` DECIMAL(18,2) COMMENT 'Net weight of the cargo inside the container in kilograms, calculated as gross weight minus tare weight. Used for billing, customs declarations, and cargo manifests.',
    `origin_location_code` STRING COMMENT 'Five-character UN/LOCODE identifying the origin location where this cargo was loaded onto the rail network. Used for routing and customs documentation.. Valid values are `^[A-Z]{5}$`',
    `planned_load_timestamp` TIMESTAMP COMMENT 'Scheduled date and time when this container or cargo unit is planned to be loaded onto the wagon. Used for resource planning and operational scheduling.',
    `reefer_temperature_celsius` DECIMAL(18,2) COMMENT 'Target temperature setting for refrigerated containers in degrees Celsius. Mandatory when is_reefer is True. Used for monitoring and maintaining cold chain integrity during rail transport.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, special instructions, or operational comments related to this wagon load. Used for exception handling and operational communication.',
    `seal_number` STRING COMMENT 'Unique seal number applied to the container for security and tamper-evidence. Verified at loading and unloading to ensure cargo integrity. Required for customs and security compliance.',
    `secured_timestamp` TIMESTAMP COMMENT 'Date and time when the load was confirmed as properly secured and ready for rail departure. Represents completion of lashing and safety checks.',
    `securing_equipment_type` STRING COMMENT 'Type of equipment used to secure the load to the wagon (e.g., twist locks for containers, chains for heavy cargo, straps for non-standard loads). Ensures proper securing method is applied.. Valid values are `twist_lock|chain|strap|clamp|cradle|other`',
    `shipper_reference` STRING COMMENT 'Shipper-provided reference number for this cargo shipment. Used for customer communication and shipment tracking across systems.',
    `special_handling_code` STRING COMMENT 'Code indicating special handling requirements for this load (e.g., fragile, top load only, no stacking, temperature sensitive). Drives operational procedures and equipment selection.',
    `tare_weight_kg` DECIMAL(18,2) COMMENT 'Empty weight of the container or cargo unit in kilograms, excluding cargo. Used to calculate net cargo weight and validate weight declarations.',
    `teu_count` DECIMAL(18,2) COMMENT 'TEU equivalent of the loaded container or cargo unit. Standard 20ft container = 1.0 TEU, 40ft container = 2.0 TEU. Used for capacity planning and utilization reporting.',
    `un_number` STRING COMMENT 'Four-digit United Nations number identifying the specific dangerous substance (e.g., UN1203 for gasoline). Required for hazardous cargo and used for emergency response and regulatory compliance.. Valid values are `^UN[0-9]{4}$`',
    `unload_timestamp` TIMESTAMP COMMENT 'Actual date and time when this container or cargo unit was unloaded from the wagon at the destination. Used for dwell time calculation and performance reporting.',
    `wagon_position_number` STRING COMMENT 'Sequential position number of this wagon within the rail consist or train formation. Used for load planning and operational sequencing.',
    CONSTRAINT pk_intermodal_rail_wagon_load PRIMARY KEY(`intermodal_rail_wagon_load_id`)
) COMMENT 'Association record linking containers or cargo units to specific rail wagons for a given rail visit, capturing wagon position, container ISO type, gross weight, hazardous goods flag (IMDG class), load sequence, and lashing/securing instructions. Supports rail load planning and weight distribution compliance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` (
    `edi_message_id` BIGINT COMMENT 'Unique identifier for the EDI message record. Primary key for the edi_message product.',
    `bill_of_lading_id` BIGINT COMMENT 'Foreign key linking to cargo.bill_of_lading. Business justification: EDI messages (IFTMIN, IFTMBC, COPARN, IFTSTA) frequently reference specific BOLs for cargo status updates, documentation exchange with shipping lines, and automated customs declaration submission in p',
    `drayage_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.drayage_order. Business justification: EDI messages may transmit drayage instructions or status updates. The message is the electronic transmission of the drayage order. No columns removed because message has transmission metadata not in d',
    `edi_partner_id` BIGINT COMMENT 'Identifier of the trading partner (inland logistics partner, shipping line, customs authority) with whom the EDI message was exchanged. May be GLN, SCAC, or internal partner code.',
    `edi_subscription_id` BIGINT COMMENT 'Foreign key linking to customer.edi_subscription. Business justification: EDI messages are transmitted under specific participant subscription configurations. Linking enables message routing validation, protocol/version compliance checking, endpoint verification, and subscr',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Security incidents trigger EDI notifications to shipping lines, customs authorities, and port community systems for incident reporting, regulatory notification, and supply chain security alerts - ISPS',
    `slot_booking_id` BIGINT COMMENT 'Foreign key linking to intermodal.slot_booking. Business justification: EDI messages may transmit slot booking confirmations or updates. The message is the electronic transmission of the booking. No columns removed because message has transmission metadata (acknowledgemen',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: EDI messages (IFTMIN) transmit transport order instructions. The message is the electronic transmission of the order. Linking allows retrieval of booking and BOL from transport_order.',
    `acknowledgement_status` STRING COMMENT 'Status of the EDI message acknowledgement. Accepted indicates successful processing; rejected indicates validation failure; pending indicates awaiting acknowledgement; acknowledged indicates receipt confirmation received; error indicates technical transmission failure.. Valid values are `accepted|rejected|pending|acknowledged|error`',
    `acknowledgement_timestamp` TIMESTAMP COMMENT 'Date and time when the acknowledgement (CONTRL message) was sent or received for this EDI message. Used for partner communication tracking.',
    `container_reference` STRING COMMENT 'ISO 6346 container number referenced in the EDI message, if applicable. Links the message to specific container movements or events.. Valid values are `^[A-Z]{4}[0-9]{7}$`',
    `correlation_code` STRING COMMENT 'Unique identifier linking this EDI message to the source transaction or business event that triggered it (e.g., gate transaction ID, booking reference, container movement ID). Enables traceability between EDI messages and operational records.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this EDI message record was first created in the system. Used for audit trail and data lineage.',
    `customs_reference` STRING COMMENT 'Customs declaration or clearance reference number associated with the EDI message, if applicable. Links the message to customs processing.',
    `error_code` STRING COMMENT 'Standardized error code if the EDI message processing failed. May reference UN/EDIFACT error codes or internal system error codes.',
    `error_description` STRING COMMENT 'Human-readable description of the error encountered during EDI message processing. Provides context for troubleshooting and partner communication.',
    `interchange_control_reference` STRING COMMENT 'Unique control reference for the EDI interchange envelope. Used to track the entire interchange session between sender and receiver.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this EDI message record was last updated. Used for audit trail and change tracking.',
    `message_direction` STRING COMMENT 'Direction of the EDI message flow. Inbound indicates messages received from partners; outbound indicates messages sent to partners.. Valid values are `inbound|outbound`',
    `message_function_code` STRING COMMENT 'Code indicating the function of the message. Original indicates new message; cancellation indicates cancellation of previous message; replacement indicates replacement of previous message; confirmation indicates acknowledgement; update indicates partial update.. Valid values are `original|cancellation|replacement|confirmation|update`',
    `message_payload` STRING COMMENT 'Full EDI message content in UN/EDIFACT format. Contains the complete message body including all segments and data elements. Stored for audit trail and message reconciliation purposes.',
    `message_reference_number` STRING COMMENT 'Unique reference number assigned to the EDI message by the sender. Used for message tracking and reconciliation between trading partners.',
    `message_size_bytes` STRING COMMENT 'Size of the EDI message payload in bytes. Used for transmission monitoring and capacity planning.',
    `message_standard` STRING COMMENT 'The EDI standard and version used for this message (e.g., UN/EDIFACT D.95B, UN/EDIFACT D.01B). Identifies the syntax and structure version.. Valid values are `^UN/EDIFACT.*$`',
    `message_type` STRING COMMENT 'Type of EDI message exchanged. COPARN (Container Pre-Announcement), IFTMIN (Instruction Message for Transport), IFTSTA (Transport Status), COPINO (Container Gate-In/Out Notification), BAPLIE (Bayplan/Stowage Plan reference), CODECO (Gate Activity Confirmation).. Valid values are `COPARN|IFTMIN|IFTSTA|COPINO|BAPLIE|CODECO`',
    `partner_name` STRING COMMENT 'Name of the trading partner organization involved in the EDI exchange.',
    `priority_level` STRING COMMENT 'Processing priority assigned to the EDI message. Urgent messages may require immediate attention or expedited processing.. Valid values are `normal|high|urgent`',
    `processed_timestamp` TIMESTAMP COMMENT 'Date and time when the EDI message processing was completed (successfully or with error). Used for performance monitoring and audit trail.',
    `processing_outcome` STRING COMMENT 'Detailed outcome description of the EDI message processing. Captures success confirmation, error details, or business rule validation results.',
    `processing_status` STRING COMMENT 'Current processing status of the EDI message within the internal system. Received indicates message captured; validated indicates syntax validation passed; processed indicates business logic applied successfully; failed indicates processing error; retrying indicates automatic retry in progress.. Valid values are `received|validated|processed|failed|retrying`',
    `received_timestamp` TIMESTAMP COMMENT 'Date and time when the EDI message was received and captured by the internal system. Used for audit trail and SLA monitoring.',
    `recipient_identification` STRING COMMENT 'Identification code of the message recipient as specified in the EDI interchange header. Combined with recipient_qualifier to uniquely identify the receiving party.',
    `recipient_qualifier` STRING COMMENT 'Code identifying the type of recipient identification used in the EDI interchange (e.g., GLN, DUNS, SCAC). Part of the UN/EDIFACT interchange header.',
    `retry_count` STRING COMMENT 'Number of times the system has attempted to reprocess or retransmit this EDI message after initial failure. Used for monitoring message delivery reliability.',
    `sender_identification` STRING COMMENT 'Identification code of the message sender as specified in the EDI interchange header. Combined with sender_qualifier to uniquely identify the sending party.',
    `sender_qualifier` STRING COMMENT 'Code identifying the type of sender identification used in the EDI interchange (e.g., GLN, DUNS, SCAC). Part of the UN/EDIFACT interchange header.',
    `terminal_code` STRING COMMENT 'Code identifying the port terminal or Inland Container Depot (ICD) referenced in the EDI message. May be UN/LOCODE or internal terminal identifier.',
    `test_indicator` BOOLEAN COMMENT 'Flag indicating whether this is a test message (true) or production message (false). Test messages are used for partner integration testing and should not trigger operational actions.',
    `transmission_timestamp` TIMESTAMP COMMENT 'Date and time when the EDI message was transmitted or received. Represents the actual communication event time.',
    `transport_mode` STRING COMMENT 'Mode of transport referenced in the EDI message. Identifies whether the message relates to rail, truck, barge, vessel, or air transport operations.. Valid values are `rail|truck|barge|vessel|air`',
    `vessel_imo_number` STRING COMMENT 'IMO number of the vessel referenced in the EDI message, if applicable. Links the message to specific vessel operations.. Valid values are `^IMO[0-9]{7}$`',
    `voyage_number` STRING COMMENT 'Voyage or call number referenced in the EDI message, if applicable. Links the message to specific vessel visits.',
    CONSTRAINT pk_edi_message PRIMARY KEY(`edi_message_id`)
) COMMENT 'Transactional log of EDI messages exchanged with inland logistics partners, shipping lines, and customs authorities for intermodal coordination. Covers COPARN (container pre-announcement), IFTMIN (transport instruction), IFTSTA (transport status), COPINO (container gate-in/out notification), BAPLIE references, and CODECO (gate activity confirmation). Captures message type, UN/EDIFACT standard version, direction (inbound/outbound), partner ID, transmission timestamp, acknowledgement status (accepted/rejected/pending), correlation ID linking to source transaction, processing outcome, error codes, and retry count. SSOT for intermodal EDI integration audit trail, message reconciliation, and partner communication compliance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` (
    `haulier_id` BIGINT COMMENT 'Unique identifier for the haulier record. Primary key for the intermodal transport carrier and operator registry.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Haulier master service agreements define commercial terms, service scope, insurance requirements, performance standards, and rate structures. Real business process: haulier onboarding, commercial rela',
    `contractor_safety_id` BIGINT COMMENT 'Foreign key linking to safety.contractor_safety. Business justification: Haulier safety qualification (insurance, ISPS certification, incident history, performance rating) mandatory for port access authorization. Contractor safety management system tracks qualification_sta',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Hauliers partner with designated customs brokers for clearance services. Transport operators track broker relationships to coordinate documentation and streamline customs processing for their drayage ',
    `edi_partner_id` BIGINT COMMENT 'Unique EDI partner identifier for the haulier used in electronic messaging and data exchange with port community systems, TOS, and PCS.',
    `access_credential_id` BIGINT COMMENT 'Foreign key linking to security.access_credential. Business justification: Haulier companies receive organizational credentials for fleet-wide port facility access, background check validation, and vendor security clearance - vendor security management and organizational acc',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Hauliers are registered port community participants requiring unified participant management, accreditation tracking (ISPS compliance), EDI subscriptions, and regulatory oversight. Essential for port ',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to procurement.vendor. Business justification: Hauliers provide trucking services and are vendors for procurement purposes (contracts, payments, performance evaluation). This FK enables linking haulier operational records to vendor master data for',
    `carrier_code` STRING COMMENT 'Unique business identifier code assigned to the haulier for operational reference and EDI messaging. Standard alphanumeric code used across port community systems.. Valid values are `^[A-Z0-9]{4,10}$`',
    `commercial_terms_reference` STRING COMMENT 'Reference identifier for the commercial terms, rate card, or pricing agreement governing the hauliers services with the port or terminal operator.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the haulier record was first created in the system.',
    `credit_limit` DECIMAL(18,2) COMMENT 'Maximum credit limit (in USD) extended to the haulier for services rendered before payment is required.',
    `edi_message_formats` STRING COMMENT 'Comma-separated list of EDI message formats supported by the haulier (e.g., IFTMIN, COPARN, BAPLIE) for intermodal transport coordination.',
    `emergency_contact_phone` STRING COMMENT '24/7 emergency contact phone number for urgent operational issues, incidents, or safety concerns involving the hauliers operations.',
    `fleet_size` STRING COMMENT 'Total number of vehicles, locomotives, or vessels in the hauliers operational fleet available for container transport.',
    `haulier_status` STRING COMMENT 'Current operational status of the haulier in the ports carrier registry: active (approved and operational), inactive (not currently operating), suspended (temporarily barred), pending approval (under review), or terminated (permanently removed).. Valid values are `active|inactive|suspended|pending_approval|terminated`',
    `last_service_date` DATE COMMENT 'Date of the most recent transport service or container movement performed by the haulier.',
    `licence_expiry_date` DATE COMMENT 'Expiration date of the hauliers transport operator licence. Operations must cease if licence expires without renewal.',
    `licensing_authority` STRING COMMENT 'Name of the regulatory body or government agency that issued the transport operator licence.',
    `network_access_agreement_ref` STRING COMMENT 'Reference number or identifier for the network access agreement or contract that grants the haulier operational access to port facilities, rail networks, or inland terminals.',
    `office_address_line1` STRING COMMENT 'First line of the hauliers registered office or headquarters street address.',
    `office_address_line2` STRING COMMENT 'Second line of the hauliers registered office or headquarters street address (suite, building, floor).',
    `office_city` STRING COMMENT 'City or municipality where the hauliers registered office or headquarters is located.',
    `office_country_code` STRING COMMENT 'Three-letter ISO country code for the country where the hauliers registered office or headquarters is located.. Valid values are `^[A-Z]{3}$`',
    `office_postal_code` STRING COMMENT 'Postal or ZIP code for the hauliers registered office or headquarters address.',
    `office_state_province` STRING COMMENT 'State, province, or administrative region where the hauliers registered office or headquarters is located.',
    `onboarding_date` DATE COMMENT 'Date when the haulier was first onboarded and registered in the ports intermodal carrier system.',
    `operator_type` STRING COMMENT 'Classification of the haulier operator type: road haulage company, owner-operator (independent), rail freight operator, barge service provider, or integrated logistics provider.. Valid values are `road_haulage|owner_operator|rail_freight|barge_service|integrated_logistics`',
    `payment_terms_days` STRING COMMENT 'Standard payment terms in days for invoices issued to the haulier (e.g., Net 30, Net 60).',
    `performance_tier` STRING COMMENT 'Performance tier rating assigned to the haulier based on KPIs such as on-time delivery, safety record, and service quality: platinum (top tier), gold, silver, bronze, or unrated (new/insufficient data).. Valid values are `platinum|gold|silver|bronze|unrated`',
    `regulatory_licence_number` STRING COMMENT 'Government-issued transport operator licence or permit number authorizing the haulier to conduct commercial freight operations.',
    `service_corridors` STRING COMMENT 'Geographic service corridors, routes, or regions covered by the hauliers transport network (e.g., port-to-ICD, regional shuttle, cross-border).',
    `termination_date` DATE COMMENT 'Date when the hauliers registration or service agreement was terminated, if applicable.',
    `termination_reason` STRING COMMENT 'Reason for termination of the hauliers registration or service agreement (e.g., contract expiry, performance issues, regulatory non-compliance, business closure).',
    `transport_mode` STRING COMMENT 'Primary transport mode capability of the haulier: road (truck/lorry), rail (freight train), barge (inland waterway), or multimodal (multiple modes).. Valid values are `road|rail|barge|multimodal`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the haulier record was last modified or updated.',
    `vehicle_types` STRING COMMENT 'Comma-separated list of vehicle, locomotive, or vessel types operated by the haulier (e.g., flatbed truck, chassis, container wagon, push barge).',
    CONSTRAINT pk_haulier PRIMARY KEY(`haulier_id`)
) COMMENT 'Master record for all intermodal transport carriers and operators including road haulage companies, owner-operators, rail freight operators, and barge service providers engaged in container drayage, last-mile delivery, rail shuttle services, and inland waterway transport. Captures carrier code, company name, registration number, transport mode capability (road/rail/barge/multimodal), fleet size, vehicle/locomotive types, network access agreement references, service corridors, regulatory licence number and authority, accreditation status, ISPS compliance certification, insurance coverage and expiry, performance tier rating, EDI partner ID, operational contact details, and commercial terms reference. SSOT for the unified intermodal transport partner, carrier, and operator registry — the single lookup for all carrier identity resolution within the intermodal domain.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` (
    `rail_operator_id` BIGINT COMMENT 'Unique identifier for the rail freight operator. Primary key for the rail operator master record within the intermodal domain.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Rail operator concession/service agreements define track access rights, capacity allocation, infrastructure usage charges, and performance obligations. Real business process: operator authorization, c',
    `contractor_safety_id` BIGINT COMMENT 'Foreign key linking to safety.contractor_safety. Business justification: Rail operator safety certification, incident history, and compliance status required for network access agreement and regulatory approval. Contractor safety register tracks qualification_status, trir,',
    `edi_partner_id` BIGINT COMMENT 'Unique EDI partner identifier used for electronic messaging integration with port systems, enabling automated exchange of IFTMIN (transport instruction), COPARN (container pre-announcement), and other UN/EDIFACT messages.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Rail operators are port community participants requiring accreditation, regulatory compliance (safety/environmental certifications), EDI partner registration, and unified participant registry manageme',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to procurement.vendor. Business justification: Rail operators provide rail services and are vendors for procurement purposes (service contracts, invoicing, performance management). This FK enables linking rail operator operational records to vendo',
    `container_handling_capability` STRING COMMENT 'Type of container units the operator is equipped to handle, including TEU (Twenty-foot Equivalent Unit), FEU (Forty-foot Equivalent Unit), refrigerated containers, and IMDG (International Maritime Dangerous Goods) certified cargo.. Valid values are `teu_only|feu_only|teu_feu_mixed|specialized_reefer|imdg_certified`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this rail operator record was first created in the system.',
    `credit_rating` STRING COMMENT 'Credit rating assigned by a recognized rating agency, indicating the financial stability and creditworthiness of the rail operator. [ENUM-REF-CANDIDATE: AAA|AA|A|BBB|BB|B|CCC|CC|C|D|not_rated — 11 candidates stripped; promote to reference product]',
    `edi_protocol` STRING COMMENT 'Technical protocol used for EDI message exchange with the rail operator (e.g., UN/EDIFACT, XML, REST API, AS2, SFTP).. Valid values are `edifact|xml|api_rest|as2|sftp`',
    `emergency_contact_phone` STRING COMMENT '24/7 emergency contact telephone number for urgent operational issues, incidents, or safety events.',
    `environmental_certification` STRING COMMENT 'Comma-separated list of environmental certifications held by the rail operator (e.g., ISO 14001, Green Freight certification).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this rail operator record was last updated or modified.',
    `licence_expiry_date` DATE COMMENT 'Date on which the regulatory licence expires and must be renewed for continued operations.',
    `locomotive_types` STRING COMMENT 'Comma-separated list of locomotive types operated by the carrier (e.g., diesel, electric, hybrid), indicating traction capability and environmental profile.',
    `max_gross_weight_tonnes` DECIMAL(18,2) COMMENT 'Maximum gross train weight in tonnes that the operator is authorized and equipped to haul, based on locomotive capacity and track load limits.',
    `max_train_length_m` DECIMAL(18,2) COMMENT 'Maximum train length in meters that the operator can handle, constrained by locomotive power, siding capacity, and network infrastructure.',
    `network_access_agreement_reference` STRING COMMENT 'Reference number or identifier for the network access agreement between the rail operator and the rail infrastructure manager, governing track usage rights and charges.',
    `onboarding_date` DATE COMMENT 'Date on which the rail operator was first registered and onboarded into the ports intermodal logistics network.',
    `operational_status` STRING COMMENT 'Current operational status of the rail operator within the ports intermodal network, indicating whether the operator is authorized to provide services.. Valid values are `active|suspended|inactive|pending_approval|terminated`',
    `operator_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the rail operator, used in operational systems and EDI messaging (IFTMIN, COPARN). Typically assigned by port authority or national rail registry.. Valid values are `^[A-Z0-9]{2,10}$`',
    `operator_type` STRING COMMENT 'Classification of the rail operator based on service scope and operational model.. Valid values are `freight_only|passenger_freight_mixed|private_siding|third_party_logistics`',
    `payment_terms_days` STRING COMMENT 'Standard payment terms in days for invoices issued to the rail operator for port services (e.g., 30, 60, 90 days).',
    `performance_rating` DECIMAL(18,2) COMMENT 'Composite performance rating score (0.00 to 5.00) based on KPIs such as on-time delivery, cargo handling quality, safety record, and EDI compliance.',
    `preferred_currency_code` STRING COMMENT 'Three-letter ISO currency code for the rail operators preferred invoicing and settlement currency (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `registered_address_line1` STRING COMMENT 'First line of the registered business address of the rail operator, typically street number and name.',
    `registered_address_line2` STRING COMMENT 'Second line of the registered business address, typically suite, floor, or building name.',
    `registered_city` STRING COMMENT 'City or municipality of the registered business address.',
    `registered_country_code` STRING COMMENT 'Three-letter ISO country code of the registered business address (e.g., USA, GBR, AUS).. Valid values are `^[A-Z]{3}$`',
    `registered_postal_code` STRING COMMENT 'Postal or ZIP code of the registered business address.',
    `registered_state_province` STRING COMMENT 'State, province, or region of the registered business address.',
    `regulatory_licence_number` STRING COMMENT 'Official licence or permit number issued by the national railway safety authority authorizing the operator to provide rail freight services.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, special handling instructions, or operational comments related to the rail operator.',
    `service_corridors` STRING COMMENT 'Comma-separated list of primary rail corridors or routes served by the operator (e.g., Port-City A, Port-City B-ICD C). Defines geographic service coverage.',
    `termination_date` DATE COMMENT 'Date on which the rail operators authorization to operate within the port network was terminated or suspended, if applicable.',
    `website_url` STRING COMMENT 'Official website URL of the rail operator for public information and service inquiries.. Valid values are `^https?://[a-zA-Z0-9.-]+.[a-zA-Z]{2,}.*$`',
    CONSTRAINT pk_rail_operator PRIMARY KEY(`rail_operator_id`)
) COMMENT 'Master record for rail freight operators providing intermodal rail services to and from the port, capturing operator code, company name, regulatory licence number, network access agreement reference, service corridors, locomotive types, EDI partner ID, and operational contact details. SSOT for rail carrier identity within the intermodal domain.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` (
    `slot_booking_id` BIGINT COMMENT 'Unique identifier for the intermodal slot booking record. Primary key.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Slot bookings for intermodal services reference the governing commercial agreement for rate validation and capacity entitlement verification. Real business process: booking authorization checks volume',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Slot bookings (capacity reservations) are priced using customer-specific rate cards. Critical for booking confirmation, revenue estimation, and capacity management billing in intermodal services.',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: Intermodal slot bookings (rail/truck capacity) coordinate with vessel cargo bookings for transshipment operations, intermodal transfers, and inland container movements. Required for matching container',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Slot bookings for intermodal services specify origin terminal zone for container pickup, enabling capacity reservation, zone allocation planning, and service scheduling - intermodal booking process.',
    `participant_account_id` BIGINT COMMENT 'Reference to the port community participant (shipping line, freight forwarder, or cargo owner) who made this booking. Links to customer master data.',
    `call_id` BIGINT COMMENT 'Reference to the vessel visit if this intermodal booking is for cargo arriving or departing on a specific vessel. Links to vessel operations.',
    `intermodal_service_id` BIGINT COMMENT 'Reference to the intermodal service (rail or truck route) for which this slot is booked. Links to the service schedule and capacity plan.',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: Slot bookings reserve intermodal capacity for transport orders. The booking is the capacity reservation; the transport order is the instruction. Linking allows retrieval of AWB and BOL from transport_',
    `actual_transport_date` DATE COMMENT 'Actual date when the intermodal transport service was executed. Used for on-time performance measurement and SLA compliance.',
    `booking_channel` STRING COMMENT 'Channel through which the booking was submitted. Used for channel performance analysis and digital adoption tracking.. Valid values are `web_portal|edi|email|phone|mobile_app|api`',
    `booking_date` DATE COMMENT 'Date when the slot booking was created or submitted by the customer. Used for booking lead time analysis and service level tracking.',
    `booking_reference_number` STRING COMMENT 'Externally-known unique booking reference number issued to the customer for this intermodal slot reservation. Used for customer communication and tracking.. Valid values are `^[A-Z0-9]{8,20}$`',
    `booking_status` STRING COMMENT 'Current lifecycle status of the slot booking. Tracks progression from initial request through fulfillment or cancellation.. Valid values are `pending|confirmed|cancelled|completed|no_show|waitlisted`',
    `booking_timestamp` TIMESTAMP COMMENT 'Precise date and time when the booking was created in the system. Used for audit trail and first-come-first-served slot allocation.',
    `booking_type` STRING COMMENT 'Type of intermodal transport mode for this booking. Determines handling procedures and capacity allocation rules.. Valid values are `rail|truck|barge|combined`',
    `cancellation_reason_code` STRING COMMENT 'Standardized code indicating the reason for booking cancellation. Used for root cause analysis and service improvement.. Valid values are `customer_request|no_show|capacity_unavailable|service_cancelled|weather|operational`',
    `cancellation_timestamp` TIMESTAMP COMMENT 'Date and time when the booking was cancelled. Null if booking is active. Used for cancellation analysis and capacity recovery.',
    `cargo_type` STRING COMMENT 'Classification of cargo being transported. Determines handling requirements and equipment allocation for the intermodal service.. Valid values are `fcl|lcl|breakbulk|reefer|hazmat|oversized`',
    `confirmation_timestamp` TIMESTAMP COMMENT 'Date and time when the booking status changed to confirmed. Used for service level measurement and customer notification tracking.',
    `confirmed_slot_date` DATE COMMENT 'Actual date confirmed for the intermodal transport slot. Null if booking is pending or waitlisted.',
    `confirmed_slot_time` TIMESTAMP COMMENT 'Precise date and time window confirmed for the intermodal transport departure or pickup. Used for gate appointment coordination.',
    `container_count` STRING COMMENT 'Total number of containers included in this slot booking, regardless of size. Used for slot allocation and capacity planning.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this booking record was first created in the database. Used for audit trail and data lineage.',
    `customer_reference_number` STRING COMMENT 'Customers own internal reference or purchase order number for this booking. Used for reconciliation and customer reporting.',
    `destination_location_code` STRING COMMENT 'UN/LOCODE or internal code for the destination location (Inland Container Depot, rail terminal, or customer facility).. Valid values are `^[A-Z]{5}$`',
    `edi_message_reference` STRING COMMENT 'Reference to the EDI message (IFTMIN, COPARN, or AWB) that initiated or confirmed this booking. Used for EDI reconciliation and audit.',
    `equipment_type_code` STRING COMMENT 'ISO 6346 equipment type code specifying the container or equipment type required for this booking (e.g., 22G1 for 20ft general purpose).. Valid values are `^[A-Z0-9]{4}$`',
    `hazmat_indicator` BOOLEAN COMMENT 'Flag indicating whether this booking includes hazardous materials requiring special handling and compliance documentation.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this booking record was last updated. Used for change tracking and audit trail.',
    `no_show_indicator` BOOLEAN COMMENT 'Flag indicating whether the customer failed to utilize the confirmed slot. Used for no-show penalty assessment and capacity planning.',
    `oversized_indicator` BOOLEAN COMMENT 'Flag indicating whether this booking includes oversized or out-of-gauge cargo requiring special equipment or routing.',
    `payment_terms` STRING COMMENT 'Payment terms agreed for this booking. Determines billing and collection procedures.. Valid values are `prepaid|collect|credit_account|cash_on_delivery`',
    `priority_level` STRING COMMENT 'Service priority level for this booking. Determines slot allocation preference and service level agreement targets.. Valid values are `standard|express|urgent|vip`',
    `reefer_indicator` BOOLEAN COMMENT 'Flag indicating whether this booking includes refrigerated containers requiring temperature-controlled transport.',
    `remarks` STRING COMMENT 'Additional free-text remarks or notes about this booking. Used for operational communication and exception handling.',
    `requested_transport_date` DATE COMMENT 'Date requested by the customer for the intermodal transport service. May differ from confirmed slot date based on availability.',
    `source_system_code` STRING COMMENT 'Code identifying the operational system that originated this booking record. Used for data lineage and integration troubleshooting.. Valid values are `NAVIS_N4|PCS|TAS|TOPS|MANUAL`',
    `special_handling_instructions` STRING COMMENT 'Free-text field for special handling requirements, routing instructions, or operational notes for this booking.',
    `teu_quantity` DECIMAL(18,2) COMMENT 'Total capacity of this booking expressed in TEU. Calculated from container sizes (20ft=1 TEU, 40ft=2 TEU, 45ft=2.25 TEU). Used for capacity utilization reporting.',
    `volume_cbm` DECIMAL(18,2) COMMENT 'Total volume of cargo in this booking expressed in cubic meters. Used for space utilization and capacity planning.',
    `weight_tonnes` DECIMAL(18,2) COMMENT 'Total gross weight of cargo in this booking expressed in metric tonnes. Used for load planning and compliance with weight restrictions.',
    CONSTRAINT pk_slot_booking PRIMARY KEY(`slot_booking_id`)
) COMMENT 'Transactional record for intermodal slot bookings made by shipping lines, freight forwarders, or cargo owners for rail or truck services, capturing booking reference, service ID, customer reference, container count, TEU quantity, booking date, requested transport date, confirmed slot, and booking status. Supports capacity management for intermodal services.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` (
    `last_mile_event_id` BIGINT COMMENT 'Unique identifier for the last-mile delivery tracking event. Primary key for the last_mile_event product.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Last-mile tracking at berth level enables vessel operations visibility, berth-side dwell time monitoring, and vessel loading/discharge progress tracking - vessel operations requirement.',
    `container_id` BIGINT COMMENT 'Reference to the container being tracked in this last-mile delivery event. Links to the container master data.',
    `port_location_id` BIGINT COMMENT 'Reference to the destination location for this last-mile delivery, such as customer warehouse, distribution center, or final consignee address.',
    `drayage_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.drayage_order. Business justification: Last mile events track the execution of drayage orders. Each event (pickup, in-transit, delivery) is associated with a drayage order. Linking allows retrieval of delivery_order_number from drayage_ord',
    `employee_id` BIGINT COMMENT 'Reference to the driver responsible for the last-mile delivery at the time of this event.',
    `haulier_id` BIGINT COMMENT 'Reference to the drayage or trucking company providing the last-mile delivery service. Links to the logistics service provider master data.',
    `primary_last_port_location_id` BIGINT COMMENT 'Reference to the origin location for this last-mile leg, typically an Inland Container Depot (ICD), Container Freight Station (CFS), or port terminal.',
    `shipment_id` BIGINT COMMENT 'Reference to the parent shipment or booking associated with this last-mile delivery event.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Last-mile events track container movements at zone level within terminal, enabling real-time visibility, dwell time analysis, and zone congestion monitoring - operational tracking requirement.',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: Last mile events track the progress of transport orders. Each event is part of the overall transport order execution. Linking allows retrieval of AWB and BOL from transport_order.',
    `truck_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_visit. Business justification: Last mile events may be associated with gate transactions (truck visits). When a container enters/exits the gate, a last_mile_event is created and linked to the truck_visit. Allows retrieval of vehicl',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Last-mile tracking at warehouse level enables delivery confirmation, warehouse receipt verification, and proof-of-delivery documentation - delivery confirmation requirement.',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Actual date and time when the vehicle arrived at the destination location. Populated when event_type is arrived_destination or delivered.',
    `appointment_reference` STRING COMMENT 'Reference to the truck appointment system booking for this last-mile delivery. Links to the scheduled delivery time slot.',
    `consignee_contact_person` STRING COMMENT 'Name of the individual at the consignee location who received or was contacted regarding the delivery. Used for delivery confirmation and issue resolution.',
    `consignee_name` STRING COMMENT 'Name of the consignee or receiving party for this last-mile delivery. Identifies the final recipient of the cargo.',
    `consignee_signature_captured` BOOLEAN COMMENT 'Indicates whether a consignee signature was captured as proof of delivery. True if signature was obtained, false otherwise.',
    `created_by_user` STRING COMMENT 'Username or identifier of the user or system process that created this event record. Used for audit trail and accountability.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this last-mile event record was first created in the database. Used for audit trail and data lineage tracking.',
    `delivery_photo_reference` STRING COMMENT 'Reference identifier or storage path for photographic proof of delivery, such as container placement photo or delivery location image.',
    `departure_timestamp` TIMESTAMP COMMENT 'Date and time when the vehicle departed from the origin location (depot, ICD, or CFS) for this last-mile delivery leg.',
    `distance_traveled_km` DECIMAL(18,2) COMMENT 'Total distance traveled in kilometers from origin to the current event location. Calculated from GPS tracking data or route planning system.',
    `driver_contact_number` STRING COMMENT 'Mobile phone number of the driver for real-time communication during last-mile delivery. Enables coordination and issue resolution.',
    `driver_name` STRING COMMENT 'Full name of the driver responsible for the last-mile delivery at the time of this event. Used for operational tracking and proof of delivery.',
    `edi_message_reference` STRING COMMENT 'Reference identifier for the EDI message (IFTMIN, IFTSTA, COPARN) that triggered or reported this last-mile event. Enables EDI integration traceability.',
    `estimated_arrival_timestamp` TIMESTAMP COMMENT 'Estimated date and time of arrival at the destination location, calculated based on current location, traffic conditions, and route. Updated dynamically during transit.',
    `event_notes` STRING COMMENT 'Free-text notes or comments recorded by the driver or dispatcher at the time of the event. Provides additional context for operational tracking and issue resolution.',
    `event_sequence_number` STRING COMMENT 'Sequential order number of this event within the last-mile delivery journey for the container. Enables chronological ordering and event replay.',
    `event_source_system` STRING COMMENT 'System or channel that captured and reported this last-mile event. Indicates the origin of the event data for data quality and lineage tracking.. Valid values are `mobile_app|gps_tracker|edi_message|manual_entry|tms|other`',
    `event_timestamp` TIMESTAMP COMMENT 'Date and time when the last-mile delivery event occurred in the real world. This is the business event time, distinct from system audit timestamps.',
    `event_type` STRING COMMENT 'Type of last-mile delivery event being recorded. Indicates the current status or milestone in the last-mile journey.. Valid values are `departed_depot|in_transit|arrived_destination|delivered|failed_delivery|returned_to_depot`',
    `failed_delivery_notes` STRING COMMENT 'Free-text notes providing additional details about a failed delivery attempt, including actions taken and next steps planned.',
    `failed_delivery_reason` STRING COMMENT 'Reason code for failed delivery attempts. Populated only when event_type is failed_delivery. Enables root cause analysis of delivery failures. [ENUM-REF-CANDIDATE: consignee_unavailable|access_denied|incorrect_address|cargo_refused|documentation_issue|vehicle_breakdown|other — 7 candidates stripped; promote to reference product]',
    `gps_accuracy_meters` DECIMAL(18,2) COMMENT 'Accuracy radius of the GPS coordinates in meters. Indicates the precision of the location data captured at the time of the event.',
    `gps_latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate where the last-mile event was recorded, captured from vehicle GPS or mobile device. Enables real-time location tracking and route analysis.',
    `gps_longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate where the last-mile event was recorded, captured from vehicle GPS or mobile device. Enables real-time location tracking and route analysis.',
    `humidity_percentage` DECIMAL(18,2) COMMENT 'Relative humidity percentage at the time of the event, captured from container monitoring sensors. Applicable for humidity-sensitive cargo.',
    `modified_by_user` STRING COMMENT 'Username or identifier of the user or system process that last modified this event record. Used for audit trail and accountability.',
    `modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this last-mile event record was last modified. Used for audit trail and change tracking.',
    `proof_of_delivery_reference` STRING COMMENT 'Reference number or identifier for the proof of delivery documentation, such as signed delivery receipt, electronic signature ID, or photo evidence reference.',
    `route_deviation_flag` BOOLEAN COMMENT 'Indicates whether the vehicle deviated from the planned route. True if deviation detected, false if following planned route. Used for route optimization and security monitoring.',
    `seal_number` STRING COMMENT 'Security seal number applied to the container at the time of this event. Used to verify container integrity during last-mile delivery.',
    `seal_status` STRING COMMENT 'Status of the container security seal at the time of this event. Critical for cargo security and customs compliance.. Valid values are `intact|broken|replaced|not_applicable`',
    `temperature_celsius` DECIMAL(18,2) COMMENT 'Temperature reading in Celsius at the time of the event, captured from reefer container monitoring or ambient temperature sensor. Applicable for temperature-controlled cargo.',
    `vehicle_number` BIGINT COMMENT 'Reference to the vehicle (truck, trailer, or drayage unit) performing the last-mile delivery.',
    CONSTRAINT pk_last_mile_event PRIMARY KEY(`last_mile_event_id`)
) COMMENT 'Transactional record capturing last-mile delivery tracking events for containers in transit to or from inland destinations, including event type (departed depot, in transit, delivered, failed delivery), event timestamp, GPS coordinates, driver ID, vehicle registration, and proof-of-delivery reference. Enables real-time last-mile visibility.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` (
    `haulier_icd_service_agreement_id` BIGINT COMMENT 'Unique identifier for this haulier-ICD service agreement record. Primary key.',
    `employee_id` BIGINT COMMENT 'User ID of the system user who created this service agreement record. Used for audit and accountability.',
    `haulier_id` BIGINT COMMENT 'Foreign key linking to the haulier (intermodal transport carrier) party in this service agreement.',
    `icd_facility_id` BIGINT COMMENT 'Foreign key linking to the ICD facility (Inland Container Depot) party in this service agreement.',
    `agreement_status` STRING COMMENT 'Current lifecycle status of this service agreement. DRAFT: under negotiation, ACTIVE: in force, SUSPENDED: temporarily inactive, EXPIRED: past expiry date, TERMINATED: ended before expiry.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this service agreement record was first created in the system.',
    `effective_date` DATE COMMENT 'Date when this service agreement becomes active and the negotiated terms take effect. Marks the start of the contractual relationship.',
    `expiry_date` DATE COMMENT 'Date when this service agreement expires or is scheduled for renewal. After this date, the contract terms are no longer valid unless renewed.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this service agreement record was last updated. Used for audit trail and change tracking.',
    `monthly_volume_commitment` STRING COMMENT 'Minimum monthly container volume (in TEU) that the haulier commits to transport to/from this ICD facility. Used for capacity planning and contract compliance monitoring.',
    `payment_terms_days` STRING COMMENT 'Payment terms in days specific to this service agreement (e.g., Net 30, Net 45). Overrides the hauliers default payment terms for services performed under this contract.',
    `priority_tier` STRING COMMENT 'Priority tier assigned to this haulier for service at this specific ICD facility. Determines queue priority, slot allocation, and service level. Values: PLATINUM, GOLD, SILVER, BRONZE, STANDARD.',
    `rate_per_teu` DECIMAL(18,2) COMMENT 'Negotiated transport rate per TEU (Twenty-foot Equivalent Unit) for container movement between the port and this ICD facility by this haulier. Rate is specific to this haulier-ICD combination.',
    `service_level_agreement_reference` STRING COMMENT 'Business reference number or contract identifier for the service level agreement governing this haulier-ICD relationship. Used for contract lookup and commercial reference.',
    CONSTRAINT pk_haulier_icd_service_agreement PRIMARY KEY(`haulier_icd_service_agreement_id`)
) COMMENT 'This association product represents the formal service contract between a haulier (intermodal transport carrier) and an ICD facility (Inland Container Depot). It captures negotiated commercial terms, service level commitments, pricing, and operational parameters that govern drayage and container transport services between the port and the inland depot. Each record links one haulier to one ICD facility with contract-specific attributes including rate agreements, volume commitments, priority tiers, and validity periods. This is the operational SSOT for managing and querying active and historical haulier-ICD service relationships.. Existence Justification: In maritime logistics operations, hauliers (transport carriers) establish formal service agreements with multiple ICD facilities to provide drayage services, and each ICD facility contracts with multiple hauliers to ensure transport capacity and service redundancy. These are negotiated commercial contracts with specific rates, service levels, volume commitments, and validity periods that vary by haulier-ICD combination. The port authority and intermodal operations teams actively manage these agreements as distinct business entities with their own lifecycle (negotiation, activation, renewal, termination).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` (
    `rail_icd_service_agreement_id` BIGINT COMMENT 'Unique identifier for the rail-ICD service agreement record. Primary key.',
    `icd_facility_id` BIGINT COMMENT 'Foreign key linking to the ICD or CFS facility receiving rail service under this agreement.',
    `rail_operator_id` BIGINT COMMENT 'Foreign key linking to the rail freight operator providing service under this agreement.',
    `agreement_status` STRING COMMENT 'Current lifecycle status of the service agreement. DRAFT for under negotiation, ACTIVE for in force, SUSPENDED for temporarily paused, EXPIRED for past expiry date, TERMINATED for cancelled before expiry.',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this service agreement record was first created in the system.',
    `effective_date` DATE COMMENT 'Date on which this service agreement becomes active and the negotiated terms take effect.',
    `expiry_date` DATE COMMENT 'Date on which this service agreement expires and must be renewed or renegotiated. Null indicates an evergreen agreement.',
    `last_modified_date` TIMESTAMP COMMENT 'Timestamp when this service agreement record was last updated.',
    `minimum_wagon_count` STRING COMMENT 'Minimum number of wagons (rail cars) that must be provided per service under this agreement. Defines minimum train configuration commitment.',
    `priority_level` STRING COMMENT 'Priority tier assigned to this service agreement for capacity allocation and scheduling. PREMIUM agreements receive preferential treatment during capacity constraints.',
    `rate_per_teu` DECIMAL(18,2) COMMENT 'Negotiated transportation rate per TEU (Twenty-foot Equivalent Unit) for container movement between the port and the ICD facility under this agreement. Currency determined by rail operators preferred currency.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, special terms, or operational instructions specific to this rail-ICD service agreement.',
    `service_level_agreement_reference` STRING COMMENT 'Unique reference number or contract identifier for the service level agreement governing this rail-ICD partnership. Used for contract management and dispute resolution.',
    `transit_time_hours` DECIMAL(18,2) COMMENT 'Committed transit time in hours for container movement from port to ICD facility (or reverse) under this service agreement. Used for service level monitoring.',
    `weekly_service_frequency` STRING COMMENT 'Number of scheduled rail services per week between the port and the ICD facility under this agreement. Defines minimum service commitment.',
    CONSTRAINT pk_rail_icd_service_agreement PRIMARY KEY(`rail_icd_service_agreement_id`)
) COMMENT 'This association product represents the formal service contract between a rail operator and an ICD facility for intermodal container transport. It captures negotiated service levels, pricing, frequency, and transit commitments that exist only in the context of this specific rail-ICD partnership. Each record links one rail operator to one ICD facility with contractual terms governing their operational relationship.. Existence Justification: In maritime intermodal logistics, rail operators provide service to multiple ICD facilities across their network, and each ICD facility is typically served by multiple rail operators to ensure redundancy and competitive pricing. These relationships are formalized through service agreements that specify rates, service frequency, transit commitments, and SLA terms. The port authority or terminal operator actively manages these agreements as distinct business entities with their own lifecycle, negotiation history, and performance tracking.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` (
    `driver_authorization_id` BIGINT COMMENT 'Unique identifier for the driver authorization record. Primary key for the association.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to the employee (driver) who is authorized to perform intermodal transport services for the haulier.',
    `haulier_id` BIGINT COMMENT 'Foreign key linking to the haulier company under whose authority and commercial agreement the driver is authorized to operate at port terminals.',
    `access_credential_id` BIGINT COMMENT 'add column security_access_credential_id (BIGINT) with FK to security.access_credential.access_credential_id - authorized drivers need linked access credentials for gate entry',
    `authorization_date` DATE COMMENT 'Date when the driver was first authorized to operate under this hauliers credentials at port terminals. Marks the start of the authorization relationship.',
    `authorization_expiry_date` DATE COMMENT 'Expiration date of the drivers authorization to operate for this haulier. Used for access control enforcement and compliance auditing. Must be renewed before expiry to maintain terminal access.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the driver authorization record was first created in the system.',
    `driver_authorization_status` STRING COMMENT 'Current status of the driver authorization. Active indicates valid authorization; suspended indicates temporary hold pending investigation or document renewal; expired indicates authorization_expiry_date has passed; revoked indicates permanent termination of authorization due to compliance breach or contract termination.',
    `induction_completion_date` DATE COMMENT 'Date when the driver completed the mandatory terminal safety and operational induction training specific to operating for this haulier. Required before first authorized access.',
    `isps_clearance_level` STRING COMMENT 'ISPS Code security clearance level assigned to the driver for this specific haulier relationship (e.g., Level 1 - Escorted, Level 2 - Unescorted, Level 3 - Restricted Areas). May differ from the employees base clearance depending on hauliers security tier and service scope.',
    `last_access_date` DATE COMMENT 'Date of the most recent terminal access by this driver operating under this hauliers authority. Used for activity monitoring and dormant authorization cleanup.',
    `revocation_date` DATE COMMENT 'Date when the authorization was revoked, if applicable. Nullable for active authorizations.',
    `revocation_reason` STRING COMMENT 'Reason for authorization revocation (e.g., security breach, failed drug test, haulier contract terminated, driver employment ended). Nullable for active authorizations.',
    `terminal_access_zones` STRING COMMENT 'Comma-separated list of terminal zones or restricted areas the driver is authorized to access when operating for this haulier (e.g., container yard, hazmat zone, rail interchange). Critical for ISPS Code compliance and security perimeter control.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the driver authorization record was last modified.',
    `vehicle_types_authorized` STRING COMMENT 'Comma-separated list of vehicle types the driver is authorized to operate for this haulier (e.g., rigid truck, articulated lorry, container chassis). Restricts which equipment the driver can use under this haulier relationship.',
    CONSTRAINT pk_driver_authorization PRIMARY KEY(`driver_authorization_id`)
) COMMENT 'This association product represents the security authorization and access control relationship between haulier drivers (employees of haulier companies) and the hauliers they are authorized to represent at port terminals. Each record captures the authorization credentials, access permissions, and compliance certifications required for a driver to perform container drayage and intermodal transport services on behalf of a specific haulier. This is a critical ISPS Code compliance and terminal security control point, tracking which drivers are authorized to enter restricted port zones, operate under which hauliers commercial agreement, and with what vehicle and cargo restrictions.. Existence Justification: In maritime port operations, drivers (employees) can be authorized to operate for multiple haulier companies simultaneously through subcontracting arrangements, and each haulier company employs or contracts with multiple drivers. The port terminal security and access control system must track each driver-haulier authorization relationship independently because authorization credentials, ISPS clearance levels, vehicle restrictions, and terminal access zones vary by haulier relationship. This is an operational security and compliance requirement, not an analytical correlation.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` (
    `facility_access_agreement_id` BIGINT COMMENT 'Unique system identifier for this facility access agreement record. Primary key.',
    `icd_facility_id` BIGINT COMMENT 'Foreign key linking to the ICD facility that is party to this access agreement',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to the port community participant that holds access rights under this agreement',
    `access_level` STRING COMMENT 'Current operational access privilege level granted to the participant at this facility. FULL for unrestricted access, RESTRICTED for limited services, EMERGENCY_ONLY for contingency access, SUSPENDED for temporarily revoked access.',
    `agreement_status` STRING COMMENT 'Current lifecycle status of the facility access agreement. ACTIVE for operational agreements, PENDING for signed but not yet effective, EXPIRED for past end date, TERMINATED for early cancellation, SUSPENDED for temporarily inactive.',
    `billing_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all charges under this facility access agreement (e.g., USD, EUR, INR).',
    `contract_end_date` DATE COMMENT 'Date on which the facility access agreement expires or is scheduled to terminate. Null indicates an open-ended or evergreen agreement.',
    `contract_start_date` DATE COMMENT 'Date on which the facility access agreement becomes effective and the participant gains operational access rights to the ICD facility.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this facility access agreement record was created in the port management system.',
    `edi_enabled` BOOLEAN COMMENT 'Indicates whether EDI message exchange is enabled between this participant and this facility for automated booking, gate notifications, and status updates.',
    `handling_rate_per_move` DECIMAL(18,2) COMMENT 'Negotiated handling charge per container move (lift-on/lift-off) for this participant at this facility. Rate is participant-specific and may differ from standard facility rates based on volume commitments.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this facility access agreement record was last updated, used for audit trail and data synchronization.',
    `priority_handling_flag` BOOLEAN COMMENT 'Indicates whether this participant has contracted for priority handling services at this facility, affecting queue position and turnaround time.',
    `sla_turnaround_hours` STRING COMMENT 'Service Level Agreement commitment for container turnaround time at this facility for this participant, measured in hours from gate-in to gate-out availability.',
    `storage_allocation_teu` STRING COMMENT 'Contracted storage capacity allocated to this participant at this facility, measured in TEU (Twenty-foot Equivalent Units). Used for capacity planning and enforcement of allocation limits.',
    CONSTRAINT pk_facility_access_agreement PRIMARY KEY(`facility_access_agreement_id`)
) COMMENT 'This association product represents the contractual agreement between an ICD facility and a port community participant. It captures facility-specific access rights, storage allocations, handling rates, and service level agreements. Each record links one ICD facility to one port community participant with commercial and operational terms that exist only in the context of this bilateral relationship.. Existence Justification: In maritime logistics operations, ICD facilities serve multiple port community participants (shipping lines, freight forwarders, cargo owners) simultaneously, and each participant typically contracts with multiple ICD facilities across the hinterland network for geographic coverage and capacity redundancy. The business actively manages these relationships as bilateral commercial agreements with facility-specific terms: storage allocations, handling rates, SLA commitments, and access privileges that vary by participant and facility combination.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` (
    `service_subscription_id` BIGINT COMMENT 'Unique identifier for this service subscription record. Primary key.',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to the participant account holding the subscription',
    `intermodal_service_id` BIGINT COMMENT 'Foreign key linking to the subscribed intermodal transport service',
    `actual_teu_utilized` STRING COMMENT 'Cumulative TEU volume actually utilized by this account on this service during the current contract period. Used for volume commitment tracking and reconciliation.',
    `auto_renewal_enabled` BOOLEAN COMMENT 'Indicates whether this subscription automatically renews at the end of the contract period under the same or updated terms.',
    `booking_quota_per_week` STRING COMMENT 'Maximum number of booking slots per week allocated to this account for this service under the subscription terms. Null if unlimited.',
    `contract_reference_number` STRING COMMENT 'External reference number of the master commercial contract or service agreement under which this subscription is governed.',
    `contracted_teu_volume` STRING COMMENT 'Committed annual or contract-period TEU volume that the participant account has contracted for this specific intermodal service. Used for capacity planning and volume discount eligibility. Explicitly identified in detection phase.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this service subscription record was first created in the system. Used for audit and data lineage.',
    `negotiated_rate_per_teu` DECIMAL(18,2) COMMENT 'Account-specific negotiated rate per TEU for this intermodal service, potentially different from standard tariff rates. Denominated in the participant accounts currency. Explicitly identified in detection phase.',
    `priority_level` STRING COMMENT 'Booking and allocation priority level assigned to this account for this specific service, used during capacity constraints. Values: Normal, High, Critical. Explicitly identified in detection phase.',
    `remarks` STRING COMMENT 'Additional notes, special terms, or operational instructions specific to this service subscription.',
    `service_tier` STRING COMMENT 'Contracted service tier level for this subscription, determining priority access, booking flexibility, and SLA commitments. Values: Standard, Premium, Enterprise, Custom. Explicitly identified in detection phase.',
    `subscription_end_date` DATE COMMENT 'Calendar date when this service subscription expires or is terminated. Nullable for open-ended subscriptions. Explicitly identified in detection phase.',
    `subscription_start_date` DATE COMMENT 'Calendar date when this service subscription becomes active and the participant account gains access to the intermodal service under the contracted terms. Explicitly identified in detection phase.',
    `subscription_status` STRING COMMENT 'Current lifecycle status of this service subscription. Active: subscription is operational. Suspended: temporarily inactive. Expired: contract period ended. Cancelled: terminated before expiry.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this service subscription record. Used for change tracking and synchronization.',
    `volume_commitment_pct` DECIMAL(18,2) COMMENT 'Percentage of contracted TEU volume that has been utilized to date (actual_teu_utilized / contracted_teu_volume * 100). Used for performance monitoring.',
    CONSTRAINT pk_service_subscription PRIMARY KEY(`service_subscription_id`)
) COMMENT 'This association product represents the commercial subscription contract between a participant account and an intermodal transport service. It captures the contractual terms, volume commitments, negotiated pricing, service tier entitlements, and subscription lifecycle for each account-service pairing. Each record links one participant_account to one intermodal_service with attributes that exist only in the context of this commercial relationship. Sourced from CRM contract management and intermodal booking systems.. Existence Justification: In maritime port operations, intermodal services (rail/truck corridors) operate on a subscription-based commercial model where multiple participant accounts can subscribe to the same service, and each account typically subscribes to multiple services based on their shipping corridor needs. The subscription itself is a contractual relationship with negotiated terms including volume commitments, pricing, service tiers, and priority levels that vary by account-service combination.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` (
    `transport_leg_id` BIGINT COMMENT 'Unique identifier for the intermodal transport leg within a multimodal journey. Primary key for the intermodal leg entity.',
    `bill_of_lading_id` BIGINT COMMENT 'Foreign key linking to cargo.bill_of_lading. Business justification: Each transport leg must reference the master shipping document for liability tracking, customs clearance at mode-change points, and end-to-end cargo traceability across vessel-rail-truck movements in ',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: Individual intermodal journey legs track which cargo booking they execute for end-to-end shipment visibility. Required for container tracking, milestone reporting to cargo owners, exception management',
    `container_id` BIGINT COMMENT 'Reference to the container being transported on this leg. Links the leg to the specific cargo unit.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Each leg of intermodal journey (rail, truck, vessel) is executed by specific operational cost center; linking enables leg-level cost capture for route profitability analysis, transfer pricing between ',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Individual transport legs crossing customs boundaries require declaration tracking. Border crossing operations at mode transfer points (port-to-rail, rail-to-ICD) verify customs clearance before cargo',
    `port_location_id` BIGINT COMMENT 'Reference to the ending location node for this leg (port, terminal, inland container depot, rail yard, distribution center).',
    `equipment_dispatch_id` BIGINT COMMENT 'Reference to the truck dispatch or drayage assignment for road legs. Null for non-road transport modes.',
    `haulier_id` BIGINT COMMENT 'Foreign key linking to intermodal.haulier. Business justification: When transport_mode = TRUCK, the carrier is a haulier. Nullable FK (only populated for truck legs). carrier_id is polymorphic (could be haulier, rail_operator, shipping line), so this FK is conditio',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Intermodal journeys starting at berth (vessel discharge to inland transport) enable vessel-to-hinterland connectivity tracking and multimodal transit time analysis - vessel connectivity requirement.',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Each transport leg originates from a specific security zone requiring zone-exit authorization, customs clearance, and security screening - tracks cargo movement through controlled security boundaries ',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Intermodal legs track zone-to-zone container movements for journey planning, transit time analysis, and multimodal coordination - logistics visibility requirement.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Intermodal journeys from warehouse enable warehouse-to-multimodal connectivity tracking, transit time analysis, and supply chain visibility - multimodal logistics coordination.',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Intermodal legs involving port-based container transfers (rail-to-vessel, truck-to-rail) require terminal handling equipment (gantry cranes, reach stackers, terminal tractors). Asset assignment enable',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the transport carrier or operator responsible for executing this leg (shipping line, rail operator, trucking company, barge operator).',
    `transport_order_id` BIGINT COMMENT 'Reference to the parent multimodal journey or shipment that this leg is part of. Links this leg to the overall transport chain.',
    `rail_operator_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_operator. Business justification: When transport_mode = RAIL, the carrier is a rail operator. Nullable FK (only populated for rail legs). carrier_id is polymorphic, so this FK is conditional. Removes carrier_name when carrier is rai',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: When transport_mode = RAIL, the leg is fulfilled by a specific rail visit (train arrival/departure). Nullable FK (only populated for rail legs). Allows linking leg execution to actual train visit.',
    `sanctions_screening_id` BIGINT COMMENT 'Foreign key linking to compliance.sanctions_screening. Business justification: Each transport leg involving vessel/carrier requires sanctions screening for ISPS compliance. Port security validates screening results before allowing cargo transfer between modes to enforce internat',
    `transport_port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Intermodal legs connect specific origin locations. Route planning, transit time calculation, and network optimization require proper location reference. Complements existing origin_node_id for structu',
    `intermodal_service_id` BIGINT COMMENT 'Reference to the specific rail service or train for rail legs. Null for non-rail transport modes.',
    `transport_service_id` BIGINT COMMENT 'Foreign key linking to intermodal.intermodal_service. Business justification: Each leg is an instance of a specific intermodal service (rail corridor, truck route, etc.). The service defines the route and schedule; the leg is the actual execution. No columns removed because leg',
    `truck_appointment_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_appointment. Business justification: When transport_mode = TRUCK, the leg may be linked to a truck gate appointment. Nullable FK (only populated for truck legs with appointments). Allows linking leg execution to gate slot booking.',
    `voyage_id` BIGINT COMMENT 'Reference to the specific vessel voyage for sea legs. Null for non-maritime transport modes.',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Actual date and time when the transport leg arrived at the destination node. Used for performance measurement and service level tracking.',
    `actual_cost_usd` DECIMAL(18,2) COMMENT 'Actual incurred cost for this transport leg in USD. Used for financial reporting and variance analysis.',
    `actual_departure_timestamp` TIMESTAMP COMMENT 'Actual date and time when the transport leg departed from the origin node. Used for performance tracking and delay analysis.',
    `awb_number` STRING COMMENT 'Air Waybill reference number for air transport legs. Null for non-air transport modes.',
    `carbon_emissions_kg_co2` DECIMAL(18,2) COMMENT 'Estimated carbon dioxide emissions for this transport leg measured in kilograms. Used for environmental reporting and sustainability tracking per GHG protocols.',
    `cargo_weight_kg` DECIMAL(18,2) COMMENT 'Total weight of cargo being transported on this leg measured in kilograms. Used for load planning, safety compliance, and billing.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this intermodal leg record was first created in the system. Used for audit trail and data lineage.',
    `delay_duration_minutes` STRING COMMENT 'Total delay time for this leg measured in minutes. Calculated as the difference between scheduled and actual times. Zero if no delay.',
    `delay_reason_code` STRING COMMENT 'Standardized code indicating the reason for any delay in this transport leg (e.g., weather, equipment failure, congestion). Null if no delay occurred.',
    `destination_node_name` STRING COMMENT 'Name of the ending location for this transport leg. Provides human-readable identification of the arrival point.',
    `destination_node_type` STRING COMMENT 'Classification of the destination location node. ICD = Inland Container Depot, CFS = Container Freight Station. [ENUM-REF-CANDIDATE: seaport|inland_port|rail_terminal|icd|cfs|distribution_center|warehouse — 7 candidates stripped; promote to reference product]',
    `distance_km` DECIMAL(18,2) COMMENT 'Total distance covered during this transport leg measured in kilometers. Used for cost calculation, carbon footprint analysis, and route optimization.',
    `edi_message_acknowledged_timestamp` TIMESTAMP COMMENT 'Date and time when EDI message acknowledgment was received from logistics partners. Used for integration monitoring.',
    `edi_message_sent_timestamp` TIMESTAMP COMMENT 'Date and time when EDI message (IFTMIN, COPARN) was sent to logistics partners for this leg. Used for integration tracking.',
    `estimated_cost_usd` DECIMAL(18,2) COMMENT 'Estimated or planned cost for this transport leg in USD. Used for budgeting and cost analysis.',
    `hazmat_indicator` BOOLEAN COMMENT 'Flag indicating whether this leg involves transport of dangerous goods requiring special handling per IMDG Code.',
    `imdg_class` STRING COMMENT 'IMDG classification code for dangerous goods (e.g., Class 3 - Flammable Liquids). Null if hazmat_indicator is false.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this intermodal leg record was last modified. Used for audit trail and change tracking.',
    `leg_status` STRING COMMENT 'Current operational status of this transport leg within its lifecycle. Tracks progression from planning through execution to completion.. Valid values are `planned|confirmed|in_transit|completed|delayed|cancelled`',
    `origin_node_type` STRING COMMENT 'Classification of the origin location node. ICD = Inland Container Depot, CFS = Container Freight Station. [ENUM-REF-CANDIDATE: seaport|inland_port|rail_terminal|icd|cfs|distribution_center|warehouse — 7 candidates stripped; promote to reference product]',
    `reefer_indicator` BOOLEAN COMMENT 'Flag indicating whether this leg involves a refrigerated container requiring temperature-controlled transport.',
    `scheduled_arrival_timestamp` TIMESTAMP COMMENT 'Planned date and time when the transport leg is scheduled to arrive at the destination node. Used for planning and resource allocation.',
    `scheduled_departure_timestamp` TIMESTAMP COMMENT 'Planned date and time when the transport leg is scheduled to depart from the origin node. Used for planning and coordination.',
    `sequence_number` STRING COMMENT 'Sequential order of this transport leg within the multimodal journey (e.g., 1 for first leg, 2 for second leg). Enables reconstruction of the complete journey path.',
    `temperature_setpoint_celsius` DECIMAL(18,2) COMMENT 'Target temperature setting for refrigerated containers in degrees Celsius. Null for non-reefer containers.',
    `teu_count` DECIMAL(18,2) COMMENT 'TEU equivalent for this leg (1.0 for 20ft, 2.0 for 40ft, 2.25 for 45ft). Used for capacity planning and volume reporting.',
    `transit_time_hours` DECIMAL(18,2) COMMENT 'Actual transit time for this leg from departure to arrival measured in hours. Used for performance analysis and service level tracking.',
    `transport_mode` STRING COMMENT 'Mode of transportation used for this leg of the journey. Distinguishes between maritime, rail, road, barge, air, and pipeline transport.. Valid values are `sea|rail|road|barge|air|pipeline`',
    CONSTRAINT pk_transport_leg PRIMARY KEY(`transport_leg_id`)
) COMMENT 'Transactional record representing a single transport leg within a multimodal journey, capturing leg sequence number, transport mode (sea, rail, road, barge), carrier, origin node, destination node, scheduled and actual departure/arrival, distance (km), and leg status. Enables end-to-end multimodal journey decomposition and tracking.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` (
    `intermodal_service_id` BIGINT COMMENT 'Unique identifier for the intermodal transport service. Primary key.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Scheduled intermodal services (rail/truck corridors) operate under commercial agreements defining capacity allocation, pricing structures, and service level commitments. Real business process: service',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Each intermodal service (port-to-ICD shuttle, rail corridor) is operated by designated cost center; linking enables service-level cost accumulation for pricing decisions, service rationalization analy',
    `haulier_id` BIGINT COMMENT 'Foreign key linking to intermodal.haulier. Business justification: Truck services are operated by hauliers. The operator_id field is polymorphic (could be rail_operator or haulier depending on transport_mode). When transport_mode = TRUCK, this FK links to haulier. ',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Intermodal services require employee ownership for service design, performance monitoring, SLA management, and customer relationship oversight. Port operations assign service managers to each corridor',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the transport operator or service provider responsible for executing this intermodal service.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Intermodal services operate between defined origin locations. Service planning, capacity allocation, and network design require proper location reference. Replaces denormalized origin_location text fi',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Intermodal services reference published port tariff schedules to calculate combined transport pricing. Essential for multimodal rate calculation and quote generation in port-hinterland transport opera',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Scheduled intermodal services operate through designated secure corridors and primary operational zones requiring route security planning, zone-based access control, and MARSEC-level service authoriza',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Intermodal services are organized as profit centers (rail shuttle service, drayage service line); linking enables segment P&L reporting, service portfolio profitability analysis, and strategic decisio',
    `rail_operator_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_operator. Business justification: Rail services are operated by rail operators. The operator_id field is polymorphic (could be rail_operator or haulier depending on transport_mode). When transport_mode = RAIL, this FK links to rail_',
    `booking_cutoff_hours` STRING COMMENT 'Number of hours before scheduled departure that bookings must be submitted. Used for operational planning and customer service commitments.',
    `capacity_teu` STRING COMMENT 'Maximum container capacity per service departure, measured in TEU. Critical for load planning and service utilization tracking.',
    `corridor_code` STRING COMMENT 'Standardized code representing the origin-destination corridor, typically in format XXX-YYY where XXX is origin and YYY is destination location code.. Valid values are `^[A-Z]{3}-[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this intermodal service record was first created in the system. Used for audit trail and data lineage.',
    `customs_clearance_supported` BOOLEAN COMMENT 'Indicates whether this intermodal service includes customs clearance coordination at origin or destination, critical for international cargo movements.',
    `dangerous_goods_allowed` BOOLEAN COMMENT 'Indicates whether this service is certified and equipped to handle IMDG (International Maritime Dangerous Goods) classified cargo.',
    `destination_location` STRING COMMENT 'End point of the intermodal service corridor. Typically an Inland Container Depot (ICD), rail terminal, or distribution center.',
    `edi_enabled` BOOLEAN COMMENT 'Indicates whether this service supports EDI integration for automated booking, COPARN (Container Pre-Announcement), and IFTMIN (Instruction Message for Transport) messaging with inland logistics partners.',
    `edi_message_types` STRING COMMENT 'Pipe-separated list of supported EDI message types for this service, such as COPARN, IFTMIN, IFTMBC (Booking Confirmation), IFTSTA (Status Report).',
    `effective_from_date` DATE COMMENT 'Date when this intermodal service becomes operational and available for booking. Used for service lifecycle management.',
    `effective_to_date` DATE COMMENT 'Date when this intermodal service is scheduled to end or be discontinued. Nullable for ongoing services.',
    `equipment_type_supported` STRING COMMENT 'Types of container equipment supported by this service. May include standard dry containers, reefers, open-top, flat-rack, tank containers. Pipe-separated list if multiple types.',
    `frequency` STRING COMMENT 'Frequency at which the intermodal service operates. Daily: every day. Weekly: once per week. Bi-weekly: twice per week. On-demand: as requested. Scheduled: fixed timetable.. Valid values are `daily|weekly|bi_weekly|on_demand|scheduled`',
    `gate_cutoff_hours` STRING COMMENT 'Number of hours before scheduled departure that containers must be delivered to the origin gate or Container Yard (CY). Critical for load planning.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this intermodal service record was last updated. Used for change tracking and audit purposes.',
    `oversize_cargo_allowed` BOOLEAN COMMENT 'Indicates whether this service can accommodate oversize or out-of-gauge cargo such as open-top or flat-rack containers.',
    `reefer_capable` BOOLEAN COMMENT 'Indicates whether this service can handle refrigerated containers with temperature-controlled transport throughout the corridor.',
    `remarks` STRING COMMENT 'Additional operational notes, restrictions, or special instructions related to this intermodal service. Free-text field for operational teams.',
    `route_distance_km` DECIMAL(18,2) COMMENT 'Total distance of the intermodal service route measured in kilometers, used for transit time calculation and tariff determination.',
    `service_code` STRING COMMENT 'Unique business identifier code for the intermodal service, used in operational systems and customer communications. Typically alphanumeric 6-12 characters.. Valid values are `^[A-Z0-9]{6,12}$`',
    `service_description` STRING COMMENT 'Detailed description of the intermodal service offering, including route highlights, special features, and operational characteristics. Used for marketing and customer communications.',
    `service_name` STRING COMMENT 'Human-readable name of the intermodal transport service, used for marketing and operational reference.',
    `service_status` STRING COMMENT 'Current operational status of the intermodal service. Active: currently operating. Suspended: temporarily halted. Discontinued: permanently ended. Planned: future service. Seasonal: operates during specific periods.. Valid values are `active|suspended|discontinued|planned|seasonal`',
    `service_type` STRING COMMENT 'Classification of the intermodal service offering. Rail shuttle: dedicated rail service between port and inland terminal. ICD linkage: connection to Inland Container Depot. Drayage: short-haul truck movement. Inland barge: waterway transport. Road feeder: scheduled truck service. Multimodal corridor: combination of transport modes.. Valid values are `rail_shuttle|icd_linkage|drayage|inland_barge|road_feeder|multimodal_corridor`',
    `sla_on_time_performance_target` DECIMAL(18,2) COMMENT 'Target percentage for on-time delivery performance as defined in customer Service Level Agreements. Measured as percentage of departures/arrivals within committed transit time window.',
    `transit_time_hours` DECIMAL(18,2) COMMENT 'Benchmark transit time for the service from origin to destination, measured in hours. Used for Service Level Agreement (SLA) commitments and customer expectations.',
    `transport_mode` STRING COMMENT 'Primary mode of transport for this service. Rail: railway transport. Truck: road transport. Barge: inland waterway. Multimodal: combination of modes.. Valid values are `rail|truck|barge|multimodal`',
    `weekly_departures` STRING COMMENT 'Number of scheduled departures per week for this service. Used for capacity planning and customer service commitments.',
    CONSTRAINT pk_intermodal_service PRIMARY KEY(`intermodal_service_id`)
) COMMENT 'Master catalog of intermodal transport services and corridors offered by the port, including rail shuttle services, ICD linkage routes, drayage service packages, and scheduled inland connections. Captures service code, name, transport mode, origin-destination corridor, route distance (km), transit time benchmark, frequency, capacity (TEU), active operators, tariff reference, and service status. SSOT for intermodal service offerings and corridor definitions.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_rail_operator_id` FOREIGN KEY (`rail_operator_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_operator`(`rail_operator_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_intermodal_service_id` FOREIGN KEY (`intermodal_service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service`(`intermodal_service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_intermodal_service_id` FOREIGN KEY (`intermodal_service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service`(`intermodal_service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_truck_service_id` FOREIGN KEY (`truck_service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service`(`intermodal_service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_drayage_order_id` FOREIGN KEY (`drayage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`drayage_order`(`drayage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_truck_appointment_id` FOREIGN KEY (`truck_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment`(`truck_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_intermodal_service_id` FOREIGN KEY (`intermodal_service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service`(`intermodal_service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ADD CONSTRAINT `fk_intermodal_intermodal_rail_wagon_load_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ADD CONSTRAINT `fk_intermodal_intermodal_rail_wagon_load_rail_wagon_id` FOREIGN KEY (`rail_wagon_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon`(`rail_wagon_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ADD CONSTRAINT `fk_intermodal_intermodal_rail_wagon_load_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ADD CONSTRAINT `fk_intermodal_edi_message_drayage_order_id` FOREIGN KEY (`drayage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`drayage_order`(`drayage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ADD CONSTRAINT `fk_intermodal_edi_message_slot_booking_id` FOREIGN KEY (`slot_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`slot_booking`(`slot_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ADD CONSTRAINT `fk_intermodal_edi_message_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ADD CONSTRAINT `fk_intermodal_slot_booking_intermodal_service_id` FOREIGN KEY (`intermodal_service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service`(`intermodal_service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ADD CONSTRAINT `fk_intermodal_slot_booking_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ADD CONSTRAINT `fk_intermodal_last_mile_event_drayage_order_id` FOREIGN KEY (`drayage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`drayage_order`(`drayage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ADD CONSTRAINT `fk_intermodal_last_mile_event_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ADD CONSTRAINT `fk_intermodal_last_mile_event_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ADD CONSTRAINT `fk_intermodal_last_mile_event_truck_visit_id` FOREIGN KEY (`truck_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_visit`(`truck_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ADD CONSTRAINT `fk_intermodal_haulier_icd_service_agreement_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ADD CONSTRAINT `fk_intermodal_haulier_icd_service_agreement_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ADD CONSTRAINT `fk_intermodal_rail_icd_service_agreement_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ADD CONSTRAINT `fk_intermodal_rail_icd_service_agreement_rail_operator_id` FOREIGN KEY (`rail_operator_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_operator`(`rail_operator_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ADD CONSTRAINT `fk_intermodal_driver_authorization_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ADD CONSTRAINT `fk_intermodal_facility_access_agreement_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ADD CONSTRAINT `fk_intermodal_service_subscription_intermodal_service_id` FOREIGN KEY (`intermodal_service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service`(`intermodal_service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_rail_operator_id` FOREIGN KEY (`rail_operator_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_operator`(`rail_operator_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_intermodal_service_id` FOREIGN KEY (`intermodal_service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service`(`intermodal_service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_transport_service_id` FOREIGN KEY (`transport_service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service`(`intermodal_service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_truck_appointment_id` FOREIGN KEY (`truck_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment`(`truck_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ADD CONSTRAINT `fk_intermodal_intermodal_service_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ADD CONSTRAINT `fk_intermodal_intermodal_service_rail_operator_id` FOREIGN KEY (`rail_operator_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_operator`(`rail_operator_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`intermodal` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`intermodal` SET TAGS ('dbx_domain' = 'intermodal');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` SET TAGS ('dbx_subdomain' = 'rail_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Coordinator Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `manifest_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Manifest Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Infrastructure Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Track Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `rail_operator_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Operator Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `intermodal_service_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Service Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `actual_arrival_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Time of Arrival (ATA)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `actual_departure_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Time of Departure (ATD)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `appointment_reference` SET TAGS ('dbx_business_glossary_term' = 'Appointment Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `billing_status` SET TAGS ('dbx_business_glossary_term' = 'Billing Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `billing_status` SET TAGS ('dbx_value_regex' = 'pending|calculated|invoiced|paid|disputed');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `completed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Visit Completed Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `container_count_discharged` SET TAGS ('dbx_business_glossary_term' = 'Container Count Discharged');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `container_count_loaded` SET TAGS ('dbx_business_glossary_term' = 'Container Count Loaded');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `destination_location` SET TAGS ('dbx_business_glossary_term' = 'Destination Location');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `edi_message_reference` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Message Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `empty_wagon_count` SET TAGS ('dbx_business_glossary_term' = 'Empty Wagon Count');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `estimated_arrival_time` SET TAGS ('dbx_business_glossary_term' = 'Estimated Time of Arrival (ETA)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `estimated_departure_time` SET TAGS ('dbx_business_glossary_term' = 'Estimated Time of Departure (ETD)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `hazmat_indicator` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `loaded_wagon_count` SET TAGS ('dbx_business_glossary_term' = 'Loaded Wagon Count');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `operator_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Operator Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `origin_location` SET TAGS ('dbx_business_glossary_term' = 'Origin Location');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Visit Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'standard|priority|express|emergency');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `reefer_container_count` SET TAGS ('dbx_business_glossary_term' = 'Refrigerated (Reefer) Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Operational Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `scheduled_arrival_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Arrival Time');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `scheduled_departure_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Departure Time');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Rail Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'unit_train|manifest_train|block_train|local_service');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `teu_capacity` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `teu_discharged` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Discharged');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `teu_loaded` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Loaded');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `track_assignment` SET TAGS ('dbx_business_glossary_term' = 'Rail Track Assignment');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `track_assignment` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `train_identifier` SET TAGS ('dbx_business_glossary_term' = 'Train Identification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `train_identifier` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{4,30}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `train_length_meters` SET TAGS ('dbx_business_glossary_term' = 'Train Length in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `train_weight_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Train Weight in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `visit_number` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `visit_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `visit_status` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `visit_type` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `visit_type` SET TAGS ('dbx_value_regex' = 'inbound|outbound|interchange|shuttle');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `wagon_count` SET TAGS ('dbx_business_glossary_term' = 'Wagon Count');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` SET TAGS ('dbx_subdomain' = 'rail_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `rail_wagon_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Wagon Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `ghg_emission_record_id` SET TAGS ('dbx_business_glossary_term' = 'Ghg Emission Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Inspection Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Current Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `axle_count` SET TAGS ('dbx_business_glossary_term' = 'Axle Count');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `bogie_type` SET TAGS ('dbx_business_glossary_term' = 'Bogie Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `brake_system` SET TAGS ('dbx_business_glossary_term' = 'Brake System Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `brake_system` SET TAGS ('dbx_value_regex' = 'air|vacuum|hand|electronic');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `build_date` SET TAGS ('dbx_business_glossary_term' = 'Build Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `container_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Container Capacity (Twenty-foot Equivalent Unit - TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `coupling_type` SET TAGS ('dbx_business_glossary_term' = 'Coupling Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `deck_height_m` SET TAGS ('dbx_business_glossary_term' = 'Deck Height (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `double_stack_capable` SET TAGS ('dbx_business_glossary_term' = 'Double Stack Capable');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `edi_enabled` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `gps_tracking_enabled` SET TAGS ('dbx_business_glossary_term' = 'Global Positioning System (GPS) Tracking Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `gross_weight_limit_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight Limit (Kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `hazmat_certified` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Certified');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `height_m` SET TAGS ('dbx_business_glossary_term' = 'Height (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `home_depot_location` SET TAGS ('dbx_business_glossary_term' = 'Home Depot Location');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `insurance_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Insurance Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Policy Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `lease_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Lease Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `lease_status` SET TAGS ('dbx_business_glossary_term' = 'Lease Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `lease_status` SET TAGS ('dbx_value_regex' = 'owned|leased|chartered');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `length_overall_m` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `manufacture_year` SET TAGS ('dbx_business_glossary_term' = 'Manufacture Year');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `manufacturer_name` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `maximum_payload_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Payload (Kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'in_service|out_of_service|maintenance|retired|reserved|damaged');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `operator_name` SET TAGS ('dbx_business_glossary_term' = 'Operator Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `operator_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `owner_name` SET TAGS ('dbx_business_glossary_term' = 'Owner Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `owner_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `refrigeration_capable` SET TAGS ('dbx_business_glossary_term' = 'Refrigeration Capable');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `registration_authority` SET TAGS ('dbx_business_glossary_term' = 'Registration Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `registration_country_code` SET TAGS ('dbx_business_glossary_term' = 'Registration Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `registration_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `registration_number` SET TAGS ('dbx_business_glossary_term' = 'Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `residual_value` SET TAGS ('dbx_business_glossary_term' = 'Residual Value');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `residual_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `rfid_tag_number` SET TAGS ('dbx_business_glossary_term' = 'Radio Frequency Identification (RFID) Tag Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `swl_rating_kg` SET TAGS ('dbx_business_glossary_term' = 'Safe Working Load (SWL) Rating (Kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `tare_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Tare Weight (Kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `wagon_number` SET TAGS ('dbx_business_glossary_term' = 'Wagon Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `wagon_type` SET TAGS ('dbx_business_glossary_term' = 'Wagon Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `wagon_type` SET TAGS ('dbx_value_regex' = 'flat|well|spine|gondola|hopper|boxcar');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `width_m` SET TAGS ('dbx_business_glossary_term' = 'Width (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` SET TAGS ('dbx_subdomain' = 'road_transport');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `truck_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Appointment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `access_credential_id` SET TAGS ('dbx_business_glossary_term' = 'Access Credential Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `port_access_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Driver Port Access Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Haulier Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Inspection Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Booking Party ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `permit_to_work_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `sanctions_screening_id` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Screening Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `intermodal_service_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Service ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `truck_service_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Service Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `actual_arrival_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Time');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `actual_departure_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Departure Time');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `appointment_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Appointment Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `appointment_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Appointment Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `appointment_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Appointment Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `appointment_reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `appointment_status` SET TAGS ('dbx_business_glossary_term' = 'Appointment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `appointment_status` SET TAGS ('dbx_value_regex' = 'requested|confirmed|amended|cancelled|no_show|completed');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `appointment_type` SET TAGS ('dbx_business_glossary_term' = 'Appointment Transaction Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `appointment_type` SET TAGS ('dbx_value_regex' = 'import_pickup|export_delivery|empty_return|rail_on|rail_off|transshipment');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `booking_channel` SET TAGS ('dbx_business_glossary_term' = 'Booking Channel');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `booking_channel` SET TAGS ('dbx_value_regex' = 'tas_portal|edi|mobile_app|api|phone|email');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `cancellation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `cargo_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Cargo Weight (kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `confirmed_slot_end_time` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Slot End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `confirmed_slot_start_time` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Slot Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `container_count` SET TAGS ('dbx_business_glossary_term' = 'Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `container_number` SET TAGS ('dbx_business_glossary_term' = 'Container Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `container_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `container_size` SET TAGS ('dbx_business_glossary_term' = 'Container Size (feet)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `container_size` SET TAGS ('dbx_value_regex' = '20|40|45');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order (D/O) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `driver_license_number` SET TAGS ('dbx_business_glossary_term' = 'Driver License Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `driver_license_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `driver_license_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `driver_name` SET TAGS ('dbx_business_glossary_term' = 'Driver Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `driver_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `driver_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `driver_phone_number` SET TAGS ('dbx_business_glossary_term' = 'Driver Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `driver_phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `driver_phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `gate_lane_number` SET TAGS ('dbx_business_glossary_term' = 'Gate Lane Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `is_hazardous` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Cargo Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `is_oversized` SET TAGS ('dbx_business_glossary_term' = 'Oversized Cargo Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `is_overweight` SET TAGS ('dbx_business_glossary_term' = 'Overweight Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `is_reefer` SET TAGS ('dbx_business_glossary_term' = 'Refrigerated Container Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `no_show_flag` SET TAGS ('dbx_business_glossary_term' = 'No-Show Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `reefer_temperature_celsius` SET TAGS ('dbx_business_glossary_term' = 'Reefer Temperature Setting (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `requested_slot_end_time` SET TAGS ('dbx_business_glossary_term' = 'Requested Slot End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `requested_slot_start_time` SET TAGS ('dbx_business_glossary_term' = 'Requested Slot Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `teu_quantity` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|barge');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `vehicle_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_value_regex' = 'truck|trailer|chassis|rail_wagon|barge');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `yard_block_location` SET TAGS ('dbx_business_glossary_term' = 'Yard Block Location');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` SET TAGS ('dbx_subdomain' = 'road_transport');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `truck_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `access_event_id` SET TAGS ('dbx_business_glossary_term' = 'Access Event Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `drayage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Drayage Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `gate_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Transaction Id');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Trucking Company ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Inspection Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Weighbridge Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `truck_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Appointment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Driver ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `truck_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Operator ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `truck_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `truck_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `actual_arrival_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Time');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `container_condition` SET TAGS ('dbx_business_glossary_term' = 'Container Condition');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `container_condition` SET TAGS ('dbx_value_regex' = 'full|empty|damaged');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `damage_report_indicator` SET TAGS ('dbx_business_glossary_term' = 'Damage Report Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `driver_license_number` SET TAGS ('dbx_business_glossary_term' = 'Driver License Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `driver_license_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `driver_license_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `driver_license_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `driver_verification_method` SET TAGS ('dbx_business_glossary_term' = 'Driver Verification Method');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `driver_verification_method` SET TAGS ('dbx_value_regex' = 'biometric|rfid_card|manual_id_check|facial_recognition');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `gate_in_time` SET TAGS ('dbx_business_glossary_term' = 'Gate-In Time');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `gate_lane_number` SET TAGS ('dbx_business_glossary_term' = 'Gate Lane ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `gate_out_time` SET TAGS ('dbx_business_glossary_term' = 'Gate-Out Time');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `isps_compliance_check_result` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Compliance Check Result');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `isps_compliance_check_result` SET TAGS ('dbx_value_regex' = 'passed|failed|waived|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `license_plate_number` SET TAGS ('dbx_business_glossary_term' = 'License Plate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `license_plate_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{4,15}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `license_plate_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `license_plate_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `ocr_confidence_score` SET TAGS ('dbx_business_glossary_term' = 'Optical Character Recognition (OCR) Confidence Score');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `seal_verification_status` SET TAGS ('dbx_business_glossary_term' = 'Seal Verification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `seal_verification_status` SET TAGS ('dbx_value_regex' = 'verified|broken|missing|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `transaction_status` SET TAGS ('dbx_business_glossary_term' = 'Transaction Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `transaction_status` SET TAGS ('dbx_value_regex' = 'completed|in_progress|rejected|cancelled|pending_inspection');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `turnaround_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Turnaround Time (Minutes)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `visit_type` SET TAGS ('dbx_business_glossary_term' = 'Visit Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `visit_type` SET TAGS ('dbx_value_regex' = 'gate_in|gate_out|dual_transaction');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` SET TAGS ('dbx_subdomain' = 'road_transport');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `drayage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Drayage Order Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `access_credential_id` SET TAGS ('dbx_business_glossary_term' = 'Driver Access Credential Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Driver Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Haulier Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `ohs_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Ohs Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Icd Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Handling Equipment Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `trade_document_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Document Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `actual_delivery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `actual_pickup_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Pickup Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `container_condition` SET TAGS ('dbx_business_glossary_term' = 'Container Condition');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `container_condition` SET TAGS ('dbx_value_regex' = 'GOOD|DAMAGED|REQUIRES_INSPECTION');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order (D/O) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `destination_address` SET TAGS ('dbx_business_glossary_term' = 'Destination Address');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `destination_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `destination_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `destination_location_type` SET TAGS ('dbx_business_glossary_term' = 'Destination Location Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `destination_location_type` SET TAGS ('dbx_value_regex' = 'CY|CFS|ICD|CUSTOMER_PREMISES|VESSEL|RAIL_YARD');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `drayage_order_number` SET TAGS ('dbx_business_glossary_term' = 'Drayage Order Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `drayage_order_number` SET TAGS ('dbx_value_regex' = '^DRY-[0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `drayage_status` SET TAGS ('dbx_business_glossary_term' = 'Drayage Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `drayage_status` SET TAGS ('dbx_value_regex' = 'PENDING|ASSIGNED|IN_TRANSIT|COMPLETED|CANCELLED|FAILED');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `drayage_type` SET TAGS ('dbx_business_glossary_term' = 'Drayage Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `drayage_type` SET TAGS ('dbx_value_regex' = 'IMPORT|EXPORT|EMPTY_RETURN|EMPTY_PICKUP|REPOSITIONING|CROSS_TOWN');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `failure_reason` SET TAGS ('dbx_business_glossary_term' = 'Failure Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `hazmat_indicator` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `order_priority` SET TAGS ('dbx_business_glossary_term' = 'Order Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `order_priority` SET TAGS ('dbx_value_regex' = 'URGENT|HIGH|NORMAL|LOW');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `origin_address` SET TAGS ('dbx_business_glossary_term' = 'Origin Address');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `origin_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `origin_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `origin_location_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `origin_location_type` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `origin_location_type` SET TAGS ('dbx_value_regex' = 'CY|CFS|ICD|CUSTOMER_PREMISES|VESSEL|RAIL_YARD');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `overweight_indicator` SET TAGS ('dbx_business_glossary_term' = 'Overweight Container Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `pod_signature_name` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Signature Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `pod_signature_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `pod_signature_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `proof_of_delivery_received` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Received');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `proof_of_delivery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `reefer_indicator` SET TAGS ('dbx_business_glossary_term' = 'Refrigerated (Reefer) Container Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `scheduled_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `scheduled_delivery_time_window_end` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Time Window End');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `scheduled_delivery_time_window_start` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Time Window Start');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `scheduled_pickup_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Pickup Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `scheduled_pickup_time_window_end` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Pickup Time Window End');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `scheduled_pickup_time_window_start` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Pickup Time Window Start');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Container Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `special_handling_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `temperature_setting_celsius` SET TAGS ('dbx_business_glossary_term' = 'Temperature Setting (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `truck_license_plate` SET TAGS ('dbx_business_glossary_term' = 'Truck License Plate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `verified_gross_mass_kg` SET TAGS ('dbx_business_glossary_term' = 'Verified Gross Mass (VGM) in Kilograms (kg)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` SET TAGS ('dbx_subdomain' = 'inland_logistics');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Inland Container Depot (ICD) Facility Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `facility_security_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Security Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `active_from_date` SET TAGS ('dbx_business_glossary_term' = 'Active From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `active_to_date` SET TAGS ('dbx_business_glossary_term' = 'Active To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `address_line_1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `address_line_1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `address_line_1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `address_line_2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `address_line_2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `address_line_2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `average_drayage_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Average Drayage Time in Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `billing_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `billing_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `customs_bonded_facility` SET TAGS ('dbx_business_glossary_term' = 'Customs Bonded Facility Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `customs_license_number` SET TAGS ('dbx_business_glossary_term' = 'Customs License Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `dangerous_goods_certified` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Handling Certification');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `data_source_system` SET TAGS ('dbx_business_glossary_term' = 'Data Source System');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `distance_from_port_km` SET TAGS ('dbx_business_glossary_term' = 'Distance from Port in Kilometers (KM)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `edi_connectivity_status` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Connectivity Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `edi_connectivity_status` SET TAGS ('dbx_value_regex' = 'CONNECTED|NOT_CONNECTED|PENDING|SUSPENDED');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `edi_protocol` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Protocol');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `edi_protocol` SET TAGS ('dbx_value_regex' = 'EDIFACT|XML|AS2|SFTP|API');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `facility_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `facility_name` SET TAGS ('dbx_business_glossary_term' = 'Facility Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `facility_type` SET TAGS ('dbx_business_glossary_term' = 'Facility Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `facility_type` SET TAGS ('dbx_value_regex' = 'ICD|CFS|HYBRID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `fcl_service_available` SET TAGS ('dbx_business_glossary_term' = 'Full Container Load (FCL) Service Available');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `imdg_license_number` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) License Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `isps_compliant` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Code Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Geographic Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `lcl_service_available` SET TAGS ('dbx_business_glossary_term' = 'Less than Container Load (LCL) Service Available');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Geographic Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `operating_hours` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'ACTIVE|INACTIVE|SUSPENDED|UNDER_CONSTRUCTION|DECOMMISSIONED');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `operator_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Operator Contact Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `operator_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `operator_contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `operator_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `operator_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Operator Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `operator_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `operator_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `operator_name` SET TAGS ('dbx_business_glossary_term' = 'Operator Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `operator_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `operator_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `rail_connectivity` SET TAGS ('dbx_business_glossary_term' = 'Rail Connectivity Available');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `reefer_plug_capacity` SET TAGS ('dbx_business_glossary_term' = 'Refrigerated Container (Reefer) Plug Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `security_level` SET TAGS ('dbx_business_glossary_term' = 'Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `security_level` SET TAGS ('dbx_value_regex' = 'LEVEL_1|LEVEL_2|LEVEL_3');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `sla_turnaround_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Turnaround Time in Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State or Province');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `storage_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Storage Capacity in Twenty-foot Equivalent Units (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `truck_parking_capacity` SET TAGS ('dbx_business_glossary_term' = 'Truck Parking Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `twenty_four_seven_operations` SET TAGS ('dbx_business_glossary_term' = 'Twenty-Four Seven Operations');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` SET TAGS ('dbx_subdomain' = 'inland_logistics');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Coordinator Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `import_export_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Import Export Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Icd Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Shipper ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `intermodal_service_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Service Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `tertiary_transport_carrier_participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `trade_document_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Document Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `trade_restriction_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Restriction Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `actual_pickup_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Pickup Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `booking_reference` SET TAGS ('dbx_business_glossary_term' = 'Booking Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `cargo_description` SET TAGS ('dbx_business_glossary_term' = 'Cargo Description');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `cargo_volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Cargo Volume in Cubic Meters (CBM)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `cargo_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Cargo Weight in Kilograms (KG)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `consignee_name` SET TAGS ('dbx_business_glossary_term' = 'Consignee Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `container_reference` SET TAGS ('dbx_business_glossary_term' = 'Container Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `container_reference` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order (D/O) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `destination_location` SET TAGS ('dbx_business_glossary_term' = 'Destination Location');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `estimated_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Delivery Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `estimated_pickup_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Pickup Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `iftmin_reference` SET TAGS ('dbx_business_glossary_term' = 'Instruction Message for Transport (IFTMIN) Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `iftmin_reference` SET TAGS ('dbx_value_regex' = '^IFTMIN-[A-Z0-9]{10,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `imdg_class` SET TAGS ('dbx_value_regex' = '^[1-9](.[1-9])?$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `is_hazardous` SET TAGS ('dbx_business_glossary_term' = 'Is Hazardous Cargo');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `is_refrigerated` SET TAGS ('dbx_business_glossary_term' = 'Is Refrigerated Cargo');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `order_date` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `order_status` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `origin_location` SET TAGS ('dbx_business_glossary_term' = 'Origin Location');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `origin_location_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `origin_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}[A-Z0-9]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `primary_transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Primary Transport Mode');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `primary_transport_mode` SET TAGS ('dbx_value_regex' = 'sea|rail|road|air|barge');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'standard|high|urgent|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `required_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Required Delivery Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `shipper_name` SET TAGS ('dbx_business_glossary_term' = 'Shipper Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `temperature_setpoint_celsius` SET TAGS ('dbx_business_glossary_term' = 'Temperature Setpoint in Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `teu_count` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Count');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `transport_mode_sequence` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode Sequence');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `transport_order_number` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `transport_order_number` SET TAGS ('dbx_value_regex' = '^TO-[0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` SET TAGS ('dbx_subdomain' = 'rail_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `intermodal_rail_wagon_load_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Wagon Load ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill Of Lading Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `rail_wagon_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Wagon ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Supervisor Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `actual_load_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Load Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `consignee_reference` SET TAGS ('dbx_business_glossary_term' = 'Consignee Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `container_iso_type_code` SET TAGS ('dbx_business_glossary_term' = 'Container ISO Type Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `container_iso_type_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `customs_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `customs_status` SET TAGS ('dbx_value_regex' = 'cleared|pending|hold|released|bonded');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `destination_location_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `destination_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight in Kilograms');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'IMDG (International Maritime Dangerous Goods) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `imdg_class` SET TAGS ('dbx_value_regex' = '^(1|2.1|2.2|2.3|3|4.1|4.2|4.3|5.1|5.2|6.1|6.2|7|8|9)$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `is_hazardous` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Goods Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `is_oversized` SET TAGS ('dbx_business_glossary_term' = 'Oversized Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `is_overweight` SET TAGS ('dbx_business_glossary_term' = 'Overweight Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `is_reefer` SET TAGS ('dbx_business_glossary_term' = 'Reefer Container Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `lashing_instructions` SET TAGS ('dbx_business_glossary_term' = 'Lashing and Securing Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `load_sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Load Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `load_status` SET TAGS ('dbx_business_glossary_term' = 'Load Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `load_status` SET TAGS ('dbx_value_regex' = 'planned|loaded|secured|in_transit|delivered|unloaded');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `net_cargo_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Net Cargo Weight in Kilograms');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `origin_location_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `origin_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `planned_load_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Load Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `reefer_temperature_celsius` SET TAGS ('dbx_business_glossary_term' = 'Reefer Set Temperature in Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Load Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Container Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `secured_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Secured Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `securing_equipment_type` SET TAGS ('dbx_business_glossary_term' = 'Securing Equipment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `securing_equipment_type` SET TAGS ('dbx_value_regex' = 'twist_lock|chain|strap|clamp|cradle|other');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `shipper_reference` SET TAGS ('dbx_business_glossary_term' = 'Shipper Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `special_handling_code` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `tare_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Tare Weight in Kilograms');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `teu_count` SET TAGS ('dbx_business_glossary_term' = 'TEU (Twenty-foot Equivalent Unit) Count');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'UN (United Nations) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `unload_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Unload Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ALTER COLUMN `wagon_position_number` SET TAGS ('dbx_business_glossary_term' = 'Wagon Position Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` SET TAGS ('dbx_subdomain' = 'service_capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `edi_message_id` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Message ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill Of Lading Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `drayage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Drayage Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `edi_partner_id` SET TAGS ('dbx_business_glossary_term' = 'Trading Partner ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `edi_subscription_id` SET TAGS ('dbx_business_glossary_term' = 'Edi Subscription Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `slot_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Slot Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `acknowledgement_status` SET TAGS ('dbx_business_glossary_term' = 'Acknowledgement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `acknowledgement_status` SET TAGS ('dbx_value_regex' = 'accepted|rejected|pending|acknowledged|error');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `acknowledgement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Acknowledgement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `container_reference` SET TAGS ('dbx_business_glossary_term' = 'Container Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `container_reference` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `correlation_code` SET TAGS ('dbx_business_glossary_term' = 'Correlation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `customs_reference` SET TAGS ('dbx_business_glossary_term' = 'Customs Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `error_code` SET TAGS ('dbx_business_glossary_term' = 'Error Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `error_description` SET TAGS ('dbx_business_glossary_term' = 'Error Description');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `interchange_control_reference` SET TAGS ('dbx_business_glossary_term' = 'Interchange Control Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `message_direction` SET TAGS ('dbx_business_glossary_term' = 'Message Direction');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `message_direction` SET TAGS ('dbx_value_regex' = 'inbound|outbound');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `message_function_code` SET TAGS ('dbx_business_glossary_term' = 'Message Function Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `message_function_code` SET TAGS ('dbx_value_regex' = 'original|cancellation|replacement|confirmation|update');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `message_payload` SET TAGS ('dbx_business_glossary_term' = 'Message Payload');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `message_payload` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `message_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Message Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `message_size_bytes` SET TAGS ('dbx_business_glossary_term' = 'Message Size (Bytes)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `message_standard` SET TAGS ('dbx_business_glossary_term' = 'EDI Message Standard');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `message_standard` SET TAGS ('dbx_value_regex' = '^UN/EDIFACT.*$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `message_type` SET TAGS ('dbx_business_glossary_term' = 'EDI Message Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `message_type` SET TAGS ('dbx_value_regex' = 'COPARN|IFTMIN|IFTSTA|COPINO|BAPLIE|CODECO');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `partner_name` SET TAGS ('dbx_business_glossary_term' = 'Trading Partner Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'normal|high|urgent');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `processed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Processed Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `processing_outcome` SET TAGS ('dbx_business_glossary_term' = 'Processing Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `processing_status` SET TAGS ('dbx_business_glossary_term' = 'Processing Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `processing_status` SET TAGS ('dbx_value_regex' = 'received|validated|processed|failed|retrying');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `received_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Received Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `recipient_identification` SET TAGS ('dbx_business_glossary_term' = 'Recipient Identification');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `recipient_qualifier` SET TAGS ('dbx_business_glossary_term' = 'Recipient Qualifier');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `retry_count` SET TAGS ('dbx_business_glossary_term' = 'Retry Count');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `sender_identification` SET TAGS ('dbx_business_glossary_term' = 'Sender Identification');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `sender_qualifier` SET TAGS ('dbx_business_glossary_term' = 'Sender Qualifier');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `test_indicator` SET TAGS ('dbx_business_glossary_term' = 'Test Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `transmission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Transmission Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'rail|truck|barge|vessel|air');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `vessel_imo_number` SET TAGS ('dbx_business_glossary_term' = 'Vessel International Maritime Organization (IMO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `vessel_imo_number` SET TAGS ('dbx_value_regex' = '^IMO[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ALTER COLUMN `voyage_number` SET TAGS ('dbx_business_glossary_term' = 'Voyage Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` SET TAGS ('dbx_subdomain' = 'road_transport');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Haulier Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `contractor_safety_id` SET TAGS ('dbx_business_glossary_term' = 'Contractor Safety Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `edi_partner_id` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Partner Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `access_credential_id` SET TAGS ('dbx_business_glossary_term' = 'Organizational Access Credential Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `carrier_code` SET TAGS ('dbx_business_glossary_term' = 'Carrier Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `carrier_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `commercial_terms_reference` SET TAGS ('dbx_business_glossary_term' = 'Commercial Terms Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `credit_limit` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `credit_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `edi_message_formats` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Message Formats Supported');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `fleet_size` SET TAGS ('dbx_business_glossary_term' = 'Fleet Size');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `haulier_status` SET TAGS ('dbx_business_glossary_term' = 'Haulier Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `haulier_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|pending_approval|terminated');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `last_service_date` SET TAGS ('dbx_business_glossary_term' = 'Last Service Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `licence_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Licence Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `licensing_authority` SET TAGS ('dbx_business_glossary_term' = 'Licensing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `network_access_agreement_ref` SET TAGS ('dbx_business_glossary_term' = 'Network Access Agreement Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Office Address Line 1');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_address_line2` SET TAGS ('dbx_business_glossary_term' = 'Office Address Line 2');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_city` SET TAGS ('dbx_business_glossary_term' = 'Office City');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_country_code` SET TAGS ('dbx_business_glossary_term' = 'Office Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_postal_code` SET TAGS ('dbx_business_glossary_term' = 'Office Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_state_province` SET TAGS ('dbx_business_glossary_term' = 'Office State or Province');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `office_state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `onboarding_date` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `operator_type` SET TAGS ('dbx_business_glossary_term' = 'Operator Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `operator_type` SET TAGS ('dbx_value_regex' = 'road_haulage|owner_operator|rail_freight|barge_service|integrated_logistics');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `payment_terms_days` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Days');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `performance_tier` SET TAGS ('dbx_business_glossary_term' = 'Performance Tier Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `performance_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|unrated');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `regulatory_licence_number` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Licence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `regulatory_licence_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `service_corridors` SET TAGS ('dbx_business_glossary_term' = 'Service Corridors and Routes');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Termination Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Termination Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode Capability');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'road|rail|barge|multimodal');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `vehicle_types` SET TAGS ('dbx_business_glossary_term' = 'Vehicle and Equipment Types');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` SET TAGS ('dbx_subdomain' = 'rail_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `rail_operator_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Operator Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `contractor_safety_id` SET TAGS ('dbx_business_glossary_term' = 'Contractor Safety Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `edi_partner_id` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Partner Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `container_handling_capability` SET TAGS ('dbx_business_glossary_term' = 'Container Handling Capability');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `container_handling_capability` SET TAGS ('dbx_value_regex' = 'teu_only|feu_only|teu_feu_mixed|specialized_reefer|imdg_certified');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `credit_rating` SET TAGS ('dbx_business_glossary_term' = 'Credit Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `credit_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `edi_protocol` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Protocol');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `edi_protocol` SET TAGS ('dbx_value_regex' = 'edifact|xml|api_rest|as2|sftp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `environmental_certification` SET TAGS ('dbx_business_glossary_term' = 'Environmental Certification');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `licence_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Licence Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `locomotive_types` SET TAGS ('dbx_business_glossary_term' = 'Locomotive Types');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `max_gross_weight_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Maximum Gross Weight (Tonnes)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `max_train_length_m` SET TAGS ('dbx_business_glossary_term' = 'Maximum Train Length (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `network_access_agreement_reference` SET TAGS ('dbx_business_glossary_term' = 'Network Access Agreement Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `network_access_agreement_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `onboarding_date` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'active|suspended|inactive|pending_approval|terminated');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `operator_code` SET TAGS ('dbx_business_glossary_term' = 'Rail Operator Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `operator_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `operator_type` SET TAGS ('dbx_business_glossary_term' = 'Rail Operator Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `operator_type` SET TAGS ('dbx_value_regex' = 'freight_only|passenger_freight_mixed|private_siding|third_party_logistics');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `payment_terms_days` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Performance Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `preferred_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Preferred Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `preferred_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Registered Address Line 1');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_address_line2` SET TAGS ('dbx_business_glossary_term' = 'Registered Address Line 2');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_city` SET TAGS ('dbx_business_glossary_term' = 'Registered City');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_country_code` SET TAGS ('dbx_business_glossary_term' = 'Registered Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_postal_code` SET TAGS ('dbx_business_glossary_term' = 'Registered Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_state_province` SET TAGS ('dbx_business_glossary_term' = 'Registered State or Province');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `registered_state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `regulatory_licence_number` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Licence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `regulatory_licence_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `service_corridors` SET TAGS ('dbx_business_glossary_term' = 'Service Corridors');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Termination Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'Website Uniform Resource Locator (URL)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `website_url` SET TAGS ('dbx_value_regex' = '^https?://[a-zA-Z0-9.-]+.[a-zA-Z]{2,}.*$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` SET TAGS ('dbx_subdomain' = 'service_capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `slot_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Slot Booking Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Booking Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `intermodal_service_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Service Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `actual_transport_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Transport Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `booking_channel` SET TAGS ('dbx_business_glossary_term' = 'Booking Channel');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `booking_channel` SET TAGS ('dbx_value_regex' = 'web_portal|edi|email|phone|mobile_app|api');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `booking_date` SET TAGS ('dbx_business_glossary_term' = 'Booking Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `booking_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Booking Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `booking_reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `booking_status` SET TAGS ('dbx_business_glossary_term' = 'Booking Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `booking_status` SET TAGS ('dbx_value_regex' = 'pending|confirmed|cancelled|completed|no_show|waitlisted');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `booking_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Booking Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `booking_type` SET TAGS ('dbx_business_glossary_term' = 'Booking Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `booking_type` SET TAGS ('dbx_value_regex' = 'rail|truck|barge|combined');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `cancellation_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `cancellation_reason_code` SET TAGS ('dbx_value_regex' = 'customer_request|no_show|capacity_unavailable|service_cancelled|weather|operational');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `cancellation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `cargo_type` SET TAGS ('dbx_value_regex' = 'fcl|lcl|breakbulk|reefer|hazmat|oversized');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `confirmation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Confirmation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `confirmed_slot_date` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Slot Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `confirmed_slot_time` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Slot Time');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `container_count` SET TAGS ('dbx_business_glossary_term' = 'Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `customer_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `destination_location_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `destination_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `edi_message_reference` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Message Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `equipment_type_code` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `equipment_type_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `hazmat_indicator` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `no_show_indicator` SET TAGS ('dbx_business_glossary_term' = 'No-Show Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `oversized_indicator` SET TAGS ('dbx_business_glossary_term' = 'Oversized Cargo Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = 'prepaid|collect|credit_account|cash_on_delivery');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'standard|express|urgent|vip');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `reefer_indicator` SET TAGS ('dbx_business_glossary_term' = 'Refrigerated (Reefer) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `requested_transport_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Transport Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = 'NAVIS_N4|PCS|TAS|TOPS|MANUAL');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `special_handling_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `teu_quantity` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Volume in Cubic Meters (CBM)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ALTER COLUMN `weight_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Weight in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` SET TAGS ('dbx_subdomain' = 'inland_logistics');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `last_mile_event_id` SET TAGS ('dbx_business_glossary_term' = 'Last Mile Event ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Location ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `drayage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Drayage Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Driver ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Drayage Provider ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `primary_last_port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Location ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `truck_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `appointment_reference` SET TAGS ('dbx_business_glossary_term' = 'Appointment Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `consignee_contact_person` SET TAGS ('dbx_business_glossary_term' = 'Consignee Contact Person');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `consignee_contact_person` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `consignee_contact_person` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `consignee_name` SET TAGS ('dbx_business_glossary_term' = 'Consignee Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `consignee_signature_captured` SET TAGS ('dbx_business_glossary_term' = 'Consignee Signature Captured');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `delivery_photo_reference` SET TAGS ('dbx_business_glossary_term' = 'Delivery Photo Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Departure Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `distance_traveled_km` SET TAGS ('dbx_business_glossary_term' = 'Distance Traveled in Kilometers (km)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `driver_contact_number` SET TAGS ('dbx_business_glossary_term' = 'Driver Contact Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `driver_contact_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `driver_contact_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `driver_name` SET TAGS ('dbx_business_glossary_term' = 'Driver Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `driver_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `driver_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `edi_message_reference` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Message Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `estimated_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Estimated Arrival Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `event_notes` SET TAGS ('dbx_business_glossary_term' = 'Event Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `event_sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Event Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `event_source_system` SET TAGS ('dbx_business_glossary_term' = 'Event Source System');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `event_source_system` SET TAGS ('dbx_value_regex' = 'mobile_app|gps_tracker|edi_message|manual_entry|tms|other');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Event Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Event Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `event_type` SET TAGS ('dbx_value_regex' = 'departed_depot|in_transit|arrived_destination|delivered|failed_delivery|returned_to_depot');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `failed_delivery_notes` SET TAGS ('dbx_business_glossary_term' = 'Failed Delivery Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `failed_delivery_reason` SET TAGS ('dbx_business_glossary_term' = 'Failed Delivery Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `gps_accuracy_meters` SET TAGS ('dbx_business_glossary_term' = 'GPS (Global Positioning System) Accuracy in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_business_glossary_term' = 'GPS (Global Positioning System) Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_business_glossary_term' = 'GPS (Global Positioning System) Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `humidity_percentage` SET TAGS ('dbx_business_glossary_term' = 'Humidity Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `proof_of_delivery_reference` SET TAGS ('dbx_business_glossary_term' = 'Proof of Delivery (POD) Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `route_deviation_flag` SET TAGS ('dbx_business_glossary_term' = 'Route Deviation Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `seal_status` SET TAGS ('dbx_business_glossary_term' = 'Seal Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `seal_status` SET TAGS ('dbx_value_regex' = 'intact|broken|replaced|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `temperature_celsius` SET TAGS ('dbx_business_glossary_term' = 'Temperature in Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ALTER COLUMN `vehicle_number` SET TAGS ('dbx_business_glossary_term' = 'Vehicle ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` SET TAGS ('dbx_subdomain' = 'inland_logistics');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` SET TAGS ('dbx_association_edges' = 'intermodal.haulier,intermodal.icd_facility');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `haulier_icd_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Service Agreement ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Haulier Icd Service Agreement - Haulier Id');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Haulier Icd Service Agreement - Icd Facility Id');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `agreement_status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `monthly_volume_commitment` SET TAGS ('dbx_business_glossary_term' = 'Monthly Volume Commitment (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `payment_terms_days` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `priority_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Priority Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `rate_per_teu` SET TAGS ('dbx_business_glossary_term' = 'Rate Per TEU');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ALTER COLUMN `service_level_agreement_reference` SET TAGS ('dbx_business_glossary_term' = 'SLA Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` SET TAGS ('dbx_subdomain' = 'rail_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` SET TAGS ('dbx_association_edges' = 'intermodal.rail_operator,intermodal.icd_facility');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `rail_icd_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Rail-ICD Service Agreement ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Icd Service Agreement - Icd Facility Id');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `rail_operator_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Icd Service Agreement - Rail Operator Id');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `agreement_status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Record Created Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `last_modified_date` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `minimum_wagon_count` SET TAGS ('dbx_business_glossary_term' = 'Minimum Wagon Count');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Service Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `rate_per_teu` SET TAGS ('dbx_business_glossary_term' = 'Rate Per TEU');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Agreement Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `service_level_agreement_reference` SET TAGS ('dbx_business_glossary_term' = 'SLA Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `transit_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Committed Transit Time');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_icd_service_agreement` ALTER COLUMN `weekly_service_frequency` SET TAGS ('dbx_business_glossary_term' = 'Weekly Service Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` SET TAGS ('dbx_subdomain' = 'road_transport');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` SET TAGS ('dbx_association_edges' = 'intermodal.haulier,workforce.employee');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `driver_authorization_id` SET TAGS ('dbx_business_glossary_term' = 'Driver Authorization ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Driver Authorization - Employee Id');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Driver Authorization - Haulier Id');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `authorization_date` SET TAGS ('dbx_business_glossary_term' = 'Authorization Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `authorization_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Authorization Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `driver_authorization_status` SET TAGS ('dbx_business_glossary_term' = 'Authorization Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `induction_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Induction Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `isps_clearance_level` SET TAGS ('dbx_business_glossary_term' = 'ISPS Clearance Level');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `last_access_date` SET TAGS ('dbx_business_glossary_term' = 'Last Access Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `revocation_date` SET TAGS ('dbx_business_glossary_term' = 'Revocation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `revocation_reason` SET TAGS ('dbx_business_glossary_term' = 'Revocation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `terminal_access_zones` SET TAGS ('dbx_business_glossary_term' = 'Terminal Access Zones');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ALTER COLUMN `vehicle_types_authorized` SET TAGS ('dbx_business_glossary_term' = 'Authorized Vehicle Types');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` SET TAGS ('dbx_subdomain' = 'inland_logistics');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` SET TAGS ('dbx_association_edges' = 'intermodal.icd_facility,customer.port_community_participant');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `facility_access_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Access Agreement ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Access Agreement - Icd Facility Id');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Access Agreement - Port Community Participant Id');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `access_level` SET TAGS ('dbx_business_glossary_term' = 'Access Level');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `agreement_status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `billing_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `edi_enabled` SET TAGS ('dbx_business_glossary_term' = 'EDI Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `handling_rate_per_move` SET TAGS ('dbx_business_glossary_term' = 'Handling Rate Per Move');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `priority_handling_flag` SET TAGS ('dbx_business_glossary_term' = 'Priority Handling Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `sla_turnaround_hours` SET TAGS ('dbx_business_glossary_term' = 'SLA Turnaround Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ALTER COLUMN `storage_allocation_teu` SET TAGS ('dbx_business_glossary_term' = 'Storage Allocation TEU');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` SET TAGS ('dbx_subdomain' = 'service_capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` SET TAGS ('dbx_association_edges' = 'intermodal.intermodal_service,customer.participant_account');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `service_subscription_id` SET TAGS ('dbx_business_glossary_term' = 'Service Subscription Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Service Subscription - Participant Account Id');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `intermodal_service_id` SET TAGS ('dbx_business_glossary_term' = 'Service Subscription - Intermodal Service Id');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `actual_teu_utilized` SET TAGS ('dbx_business_glossary_term' = 'Actual TEU Utilized');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `auto_renewal_enabled` SET TAGS ('dbx_business_glossary_term' = 'Auto Renewal Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `booking_quota_per_week` SET TAGS ('dbx_business_glossary_term' = 'Booking Quota Per Week');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `contract_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `contracted_teu_volume` SET TAGS ('dbx_business_glossary_term' = 'Contracted TEU Volume');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `negotiated_rate_per_teu` SET TAGS ('dbx_business_glossary_term' = 'Negotiated Rate Per TEU');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `service_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `subscription_end_date` SET TAGS ('dbx_business_glossary_term' = 'Subscription End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `subscription_start_date` SET TAGS ('dbx_business_glossary_term' = 'Subscription Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `subscription_status` SET TAGS ('dbx_business_glossary_term' = 'Subscription Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ALTER COLUMN `volume_commitment_pct` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` SET TAGS ('dbx_subdomain' = 'inland_logistics');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `transport_leg_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Leg Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill Of Lading Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Node Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `equipment_dispatch_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Dispatch Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Haulier Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Equipment Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Journey Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `rail_operator_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Operator Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `sanctions_screening_id` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Screening Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `transport_port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `intermodal_service_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Service Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `transport_service_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Service Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `truck_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Appointment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Voyage Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `actual_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Actual Cost in United States Dollars (USD)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `actual_cost_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `actual_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Departure Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `awb_number` SET TAGS ('dbx_business_glossary_term' = 'Air Waybill (AWB) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `carbon_emissions_kg_co2` SET TAGS ('dbx_business_glossary_term' = 'Carbon Emissions in Kilograms of Carbon Dioxide (kg CO2)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `cargo_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Cargo Weight in Kilograms (kg)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `delay_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Delay Duration in Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `delay_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Delay Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `destination_node_name` SET TAGS ('dbx_business_glossary_term' = 'Destination Node Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `destination_node_type` SET TAGS ('dbx_business_glossary_term' = 'Destination Node Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `distance_km` SET TAGS ('dbx_business_glossary_term' = 'Distance in Kilometers (km)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `edi_message_acknowledged_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Message Acknowledged Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `edi_message_sent_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Message Sent Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `estimated_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Estimated Cost in United States Dollars (USD)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `estimated_cost_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `hazmat_indicator` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `leg_status` SET TAGS ('dbx_business_glossary_term' = 'Leg Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `leg_status` SET TAGS ('dbx_value_regex' = 'planned|confirmed|in_transit|completed|delayed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `origin_node_type` SET TAGS ('dbx_business_glossary_term' = 'Origin Node Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `reefer_indicator` SET TAGS ('dbx_business_glossary_term' = 'Refrigerated Container (Reefer) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `scheduled_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Arrival Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `scheduled_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Departure Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Leg Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `temperature_setpoint_celsius` SET TAGS ('dbx_business_glossary_term' = 'Temperature Setpoint in Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `teu_count` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Count');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `transit_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Transit Time in Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'sea|rail|road|barge|air|pipeline');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` SET TAGS ('dbx_subdomain' = 'service_capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `intermodal_service_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Service Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Haulier Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Service Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `rail_operator_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Operator Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `booking_cutoff_hours` SET TAGS ('dbx_business_glossary_term' = 'Booking Cutoff Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Capacity in Twenty-foot Equivalent Units (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `corridor_code` SET TAGS ('dbx_business_glossary_term' = 'Corridor Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `corridor_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}-[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `customs_clearance_supported` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Supported');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `dangerous_goods_allowed` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Allowed');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `destination_location` SET TAGS ('dbx_business_glossary_term' = 'Destination Location');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `edi_enabled` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `edi_message_types` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Message Types');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `equipment_type_supported` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Supported');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `frequency` SET TAGS ('dbx_business_glossary_term' = 'Service Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|bi_weekly|on_demand|scheduled');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `gate_cutoff_hours` SET TAGS ('dbx_business_glossary_term' = 'Gate Cutoff Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `oversize_cargo_allowed` SET TAGS ('dbx_business_glossary_term' = 'Oversize Cargo Allowed');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `reefer_capable` SET TAGS ('dbx_business_glossary_term' = 'Reefer Capable');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `route_distance_km` SET TAGS ('dbx_business_glossary_term' = 'Route Distance in Kilometers (km)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `service_code` SET TAGS ('dbx_business_glossary_term' = 'Service Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `service_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `service_description` SET TAGS ('dbx_business_glossary_term' = 'Service Description');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `service_name` SET TAGS ('dbx_business_glossary_term' = 'Service Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `service_status` SET TAGS ('dbx_business_glossary_term' = 'Service Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `service_status` SET TAGS ('dbx_value_regex' = 'active|suspended|discontinued|planned|seasonal');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'rail_shuttle|icd_linkage|drayage|inland_barge|road_feeder|multimodal_corridor');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `sla_on_time_performance_target` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) On-Time Performance Target');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `transit_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Transit Time in Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'rail|truck|barge|multimodal');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ALTER COLUMN `weekly_departures` SET TAGS ('dbx_business_glossary_term' = 'Weekly Departures');
