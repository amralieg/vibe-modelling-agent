-- Schema for Domain: intermodal | Business: Shipping_Ports | Version: v2_mvm
-- Generated on: 2026-07-13 10:24:17

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`intermodal` COMMENT 'Manages end-to-end intermodal transport coordination including rail operations, truck dispatch, inland container depot (ICD) linkages, truck appointment systems, AWB and IFTMIN messaging, container drayage, and last-mile delivery tracking. Supports EDI integration with inland logistics partners. SSOT for intermodal transport integration and inland logistics.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` (
    `rail_visit_id` BIGINT COMMENT 'Unique identifier for the rail train visit to the port terminal. Primary key for the rail visit record. Represents the rail equivalent of a vessel call — the unit of rail service delivery.',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: A rail visit can be placed on customs hold, blocking train departure or cargo discharge. Terminal planners and customs officers need this direct link to manage hold status, prevent unauthorized moveme',
    `icd_facility_id` BIGINT COMMENT 'Foreign key linking to intermodal.icd_facility. Business justification: A rail visit originates from or terminates at an ICD facility. The rail_visit table has origin_location and destination_location as free-text STRINGs. Adding origin_icd_facility_id as a FK to icd_faci',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Rail terminal visits operate under rail operator service agreements defining track access rights, capacity allocation, and terminal handling charges. Real business process: visit authorization and bil',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: Rail visits are executed under a specific commercial service agreement governing billing rates, volume commitments, and operational terms. Invoice reconciliation and contract compliance reporting requ',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Rail visits utilize specific port-owned rail infrastructure assets (rail-mounted gantry cranes, track systems, loading platforms). Operations teams must track which assets serve each visit for utiliza',
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: A vessel call (with confirmed berth, ATA, ATB, cargo ops timestamps) directly drives rail_visit scheduling for container handoff. Rail coordinators need the call record to confirm cargo availability a',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: Rail trains enter/exit the port through designated rail gates. Gate-level throughput reporting, ISPS access control, and OCR reconciliation for rail visits require knowing which port gate was used. A ',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Port-level rail traffic volume reporting, port authority billing, and capacity planning require knowing which port each rail visit belongs to. A port operations expert would expect rail_visit to be di',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Rail visits occur at specific terminal track locations. Yard planning, resource allocation, and track assignment operations require proper location reference for infrastructure management and operatio',
    `rail_operator_id` BIGINT COMMENT 'Reference to the rail carrier or operator providing the train service. Links to the port community participant master data.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Rail visits operate within dedicated rail-served terminal zones, enabling rail capacity planning, track allocation, and intermodal transfer coordination - rail operations planning process. Role-prefix',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Rail visits for contracted operators use negotiated rate cards for terminal services (loading, unloading, track usage). Essential for rail service billing and operator invoicing.',
    `service_id` BIGINT COMMENT 'Foreign key linking to intermodal.intermodal_service. Business justification: Rail visits are instances of intermodal rail services. The service defines the scheduled route and frequency; the visit is the actual train arrival/departure. No columns removed because visit has exec',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.sla_profile. Business justification: Rail visit on-time performance and turnaround time are measured against contracted SLA targets. Port operators run SLA compliance reports per rail operator per visit. Direct link enables automated SLA',
    `terminal_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal. Business justification: Terminal-level rail throughput reporting: a rail_visit occurs at a specific terminal; terminal_id is required for terminal capacity management, rail berth/track scheduling, and regulatory reporting of',
    `thc_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.thc_schedule. Business justification: Rail visits generate THC billing events for each container discharged/loaded. The thc_schedule governs the applicable handling charge rate by container type and movement. Port billing teams require th',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: Rail operators plan container availability windows against specific vessel voyages. The voyage record carries cargo manifest status, TEU counts, and ETA/ETB — all required by rail planners to schedule',
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
    `icd_facility_id` BIGINT COMMENT 'Foreign key linking to intermodal.icd_facility. Business justification: A rail wagon has a home depot — the ICD or inland facility where it is based when not in service. The rail_wagon table currently stores home_depot_location as a free-text STRING. Replacing this with a',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Rail wagons operating in port terminals are often port-owned or leased assets requiring maintenance tracking, SWL certification, inspection scheduling, and depreciation accounting. Asset management sy',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Asset tracking requires knowing physical wagon location within terminal. Critical for inventory management, dispatch planning, and wagon availability queries. Replaces denormalized current_location te',
    `rail_operator_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_operator. Business justification: A rail wagon is owned or operated by a rail operator. The rail_wagon table currently stores operator_name as a free-text STRING, which is a denormalized reference to the rail_operator master record. A',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Rail wagon registration jurisdiction determines regulatory compliance, inspection authority, and cross-border operating rights. Port authorities and customs require verified country-of-registration fo',
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
    `owner_name` STRING COMMENT 'The legal name of the organization or entity that owns the rail wagon. May be a rail operator, leasing company, or port authority.',
    `refrigeration_capable` BOOLEAN COMMENT 'Indicates whether the wagon is equipped to carry refrigerated containers with power supply connections.',
    `registration_authority` STRING COMMENT 'The regulatory body or national authority that registered and certified the rail wagon for operation.',
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
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Vessel-side truck appointments reference specific berth for container pickup/delivery during vessel operations, enabling vessel discharge/loading coordination and berth productivity tracking - vessel ',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Appointment system checks for active holds before slot confirmation as pre-gate screening. Booking systems prevent appointment creation for held containers to avoid wasted truck trips and gate congest',
    `port_access_permit_id` BIGINT COMMENT 'Foreign key linking to customer.port_access_permit. Business justification: Truck appointments require valid port access permits for drivers entering secure ISPS-regulated port facilities. Enables permit verification at appointment booking and gate entry, critical for maritim',
    `haulier_id` BIGINT COMMENT 'Foreign key linking to intermodal.haulier. Business justification: Truck appointments are made by hauliers (road transport carriers). The haulier is the booking party. Linking allows retrieval of booking_party_name from haulier table when booking party is a haulier.',
    `icd_facility_id` BIGINT COMMENT 'Foreign key linking to intermodal.icd_facility. Business justification: A truck appointment for container pickup or delivery at an ICD facility must reference the specific ICD. This FK enables the truck appointment system to coordinate with ICD operational schedules, capa',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.imdg_class. Business justification: Hazmat truck appointments require validated IMDG class at booking time for gate access control, lane routing, and port authority hazmat notification. The plain imdg_class string on truck_appointment m',
    `import_export_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.import_export_permit. Business justification: Truck appointments for controlled goods (dual-use, CITES, quota-restricted) require import/export permit validation before slot confirmation. Port community systems enforce permit checks at appointmen',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Appointments specify container types for gate planning, equipment compatibility checks, and handling resource allocation. Replaces denormalized container_type text field with proper master data refere',
    `participant_account_id` BIGINT COMMENT 'Identifier of the party making the appointment booking. References the shipping line, freight forwarder, or cargo owner responsible for the booking.',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: Truck appointments are billed under a hauliers service agreement with the port. Rate application, volume discount calculation, and invoice generation require linking each appointment to the governing',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Truck appointments depend on gate infrastructure assets (OCR systems, RFID readers, barrier gates, weighbridges). Appointment capacity planning requires knowing asset availability and operational stat',
    `call_id` BIGINT COMMENT 'Identifier of the vessel visit associated with this appointment. Links the appointment to the specific vessel call for import/export operations.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Driver credentials must be pre-validated against truck appointments for gate access authorization, MARSEC-level clearance verification, and appointment-credential matching - core port gate security an',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: Truck appointments specify entry/exit gate for access control, security screening, and traffic management - core gate operations process in port terminals.',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Port-level truck appointment volume reporting, port authority billing, and gate capacity planning require knowing which port each appointment belongs to. truck_appointment has port_location_id (master',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Appointments are scheduled to specific terminal locations. Gate operations, slot management, and yard routing depend on proper location reference. Replaces denormalized terminal_location_code.',
    `service_id` BIGINT COMMENT 'Identifier of the rail service or train for rail-on/rail-off appointments. Links the appointment to scheduled rail operations.',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: A truck appointment for intermodal rail-truck interchange must reference the specific rail visit it is coordinating with. This is essential for rail-truck transfer scheduling at the terminal — the tru',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Truck appointments for contracted customers reference negotiated rate cards for gate processing and handling charges. Required for appointment-based billing and revenue allocation.',
    `shipping_line_id` BIGINT COMMENT 'Identifier of the shipping line or carrier responsible for the container. References the ocean carrier or vessel operator.',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Truck gate appointments validate service entitlement and pricing against terminal access agreements. Real business process: appointment authorization checks contracted service scope and applies agreed',
    `terminal_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal. Business justification: Terminal gate capacity management: truck appointments are made for a specific terminal; terminal_id is needed for gate lane capacity planning, terminal-level appointment slot allocation, and SLA repor',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Truck gate appointments for container pickup/delivery require cargo booking reference for customs clearance validation, delivery order verification, VGM compliance checking, and hazmat documentation v',
    `thc_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.thc_schedule. Business justification: Truck appointments for container import/export trigger THC charges per container movement. The thc_schedule determines the applicable handling rate by container type, size, and movement direction. Por',
    `trade_document_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_document. Business justification: Trade document verification is required before confirming truck appointment slots for regulated cargo (phytosanitary, dangerous goods certificates). Appointment booking systems must validate document ',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: Truck appointments are made to execute transport orders. The appointment reserves a gate slot for the transport order. Linking allows retrieval of booking and BOL from transport_order.',
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
    `driver_license_number` STRING COMMENT 'Drivers license or identification number. Used for security verification and access authorization.',
    `driver_name` STRING COMMENT 'Full name of the driver operating the vehicle. Required for security and access control purposes.',
    `driver_phone_number` STRING COMMENT 'Contact phone number for the driver. Used for communication regarding appointment changes or gate issues.',
    `gate_lane_number` STRING COMMENT 'Specific gate lane assigned for the appointment. Used for traffic management and gate capacity optimization.',
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
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Gate transactions verify no active holds exist before allowing container exit. Gate officers check hold status in real-time as enforcement point to prevent release of detained cargo.',
    `drayage_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.drayage_order. Business justification: Truck visits execute drayage orders. When a truck arrives at the gate, the visit is linked to the drayage order being fulfilled. Linking allows retrieval of delivery order, booking, and BOL from draya',
    `gate_transaction_id` BIGINT COMMENT 'FK to terminal.gate_transaction.gate_transaction_id — Truck lifecycle tracking from intermodal appointment through gate execution requires joining truck_visit to the terminal gate_transaction. Without this, truck turnaround time analytics are impossible.',
    `haulier_id` BIGINT COMMENT 'Reference to the drayage or trucking company operating the vehicle. Used for performance tracking and billing of terminal handling charges.',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.participant_account. Business justification: Actual gate events (truck visits) are billed directly to the hauliers participant account. Invoices are raised against actual visits, not just appointments. Direct link enables accounts receivable pr',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Truck visits require weighbridge assets for VGM compliance and overweight detection. Weighbridge calibration certificates, maintenance records, and operational status must be tracked per transaction f',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: Truck visits pass through a specific port gate. Gate-level throughput KPIs, OCR reconciliation, ISPS compliance audits, and gate performance reporting all require the actual visit to reference the phy',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Port-level truck traffic reporting, port authority billing, and operational dashboards require knowing which port each truck visit occurred at. truck_visit has port_location_id (masterdata) but no dir',
    `port_location_id` BIGINT COMMENT 'Reference to the registered driver who presented credentials at the gate. Links to the driver master record for identity verification and access control.',
    `shipping_line_id` BIGINT COMMENT 'Reference to the ocean carrier or shipping line that owns or operates the container. Used for billing and operational coordination.',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.sla_profile. Business justification: Gate-to-gate turnaround time is a key SLA metric tracked per haulier. Ports report SLA compliance on actual truck visits against contracted turnaround targets. Direct link enables automated SLA breach',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Truck visits are physically executed within a specific terminal zone. ISPS zone compliance tracking, yard management, and zone-level throughput reporting require the actual visit record to capture whi',
    `truck_appointment_id` BIGINT COMMENT 'Reference to the pre-booked truck appointment that this visit is executing against. Links the actual gate transaction to the scheduled appointment slot.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Gate transaction safety verification (container condition, seal integrity, hazmat compliance, damage inspection) generates inspection record. Required for ISPS compliance reporting and incident invest',
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
    `container_id` BIGINT COMMENT 'Reference to the container being moved under this drayage order. Links to the container master record.',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Haulier driver credentials must be verified for container pickup/delivery authorization, background check validation, and MARSEC-level clearance - security clearance process for cargo handling authori',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Drayage operations must check for active customs holds before container release. Dispatch systems query hold status to prevent unauthorized pickups and avoid penalties from moving detained cargo.',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to cargo.delivery_order. Business justification: Drayage orders are created to execute port delivery orders. TMS systems link drayage jobs to DOs for container release authorization, demurrage liability tracking, and billing reconciliation. Port com',
    `terminal_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal. Business justification: Drayage routing and terminal pre-notification: the destination terminal is a primary routing field for drayage orders; terminal_id enables terminal pre-arrival notification, gate pre-clearance, and te',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Drayage orders specify target terminal zone for container placement, enabling yard planning, slot allocation, and equipment dispatch - core terminal operations process.',
    `haulier_id` BIGINT COMMENT 'Reference to the road haulier (trucking company) assigned to execute this drayage order. Links to the participant account master.',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.imdg_class. Business justification: Hazmat drayage orders require validated IMDG classification for route planning, driver ADR/hazmat certification matching, and emergency response documentation. Normalizing the plain imdg_class string ',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Drayage orders move specific container types requiring chassis assignment, handling equipment selection, and route planning based on equipment dimensions and weight limits.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Drayage from vessel references berth for container pickup during discharge operations, enabling vessel-to-gate coordination and berth turnaround optimization - vessel discharge process.',
    `icd_facility_id` BIGINT COMMENT 'Foreign key linking to intermodal.icd_facility. Business justification: When origin_location_type = ICD, this FK links to the specific inland container depot. Nullable FK (only populated when origin is an ICD facility). Resolves silo issue for icd_facility. origin_locat',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Drayage from warehouse references specific warehouse for container pickup, enabling warehouse-to-gate coordination, inventory release tracking, and warehouse utilization reporting - warehousing operat',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Drayage services are contracted with hauliers under framework agreements specifying rates per move, service areas, and performance requirements. Real business process: order pricing lookup and haulier',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: Drayage orders are executed under a hauliers service agreement governing rates, delivery terms, and liability. Billing reconciliation and contract compliance audits require linking each drayage order',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Drayage container pickup/delivery at port terminals requires specific handling equipment (reach stackers, forklifts, empty handlers). Equipment assignment is critical for execution planning, operator ',
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: Drayage orders are issued to move containers to/from specific vessel port calls. Terminal planners, vessel operators, and billing systems require this link to coordinate landside movements with vessel',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Drayage orders execute last-mile container delivery from port to consignee. Operations require linking to cargo booking for delivery order number validation, consignee details, customs status verifica',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: Drayage orders specify which gate the truck should use for cargo pickup/delivery. Gate assignment is part of drayage planning, ISPS compliance, and gate capacity management. A port logistics expert wo',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Drayage orders are executed at a specific port. Port-level drayage volume reporting, port authority oversight, and haulier performance management by port all require this link. drayage_order has port_',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Drayage destinations within port require proper location reference for delivery routing, proof-of-delivery validation, and distance-based pricing. Replaces denormalized destination_location_code.',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Drayage orders are commercial instructions for container transport priced under negotiated rate cards. Port billing and logistics teams require the applicable rate card on each drayage order to calcul',
    `service_id` BIGINT COMMENT 'Foreign key linking to intermodal.intermodal_service. Business justification: A drayage order is executed under a specific intermodal service corridor. The intermodal_service master defines the route, SLA, and operational parameters for the drayage. Linking drayage_order to int',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to cargo.shipment. Business justification: Drayage orders move containers belonging to specific shipments. Operators need shipment-level cargo details (commodity, IMDG class, consignee) for route planning, customs pre-clearance, and special ha',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Drayage orders execute container movements on behalf of a specific shipping line. Container release authorization, drayage billing, and port community reporting are all performed per shipping line. A ',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.sla_profile. Business justification: Drayage delivery time windows and on-time performance are governed by SLA commitments. Ports and logistics operators track drayage SLA compliance for penalty/incentive calculations. Direct link enable',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: Drayage orders execute transport order instructions. The drayage_order is the operational execution record for container movement, while transport_order is the instruction (IFTMIN message). Linking al',
    `actual_delivery_timestamp` TIMESTAMP COMMENT 'Actual date and time when the container was delivered to the destination location. Captured via gate system, customer confirmation, or proof of delivery.',
    `actual_pickup_timestamp` TIMESTAMP COMMENT 'Actual date and time when the container was picked up from the origin location. Captured via gate system or manual confirmation.',
    `cancellation_reason` STRING COMMENT 'Reason for drayage order cancellation if status is CANCELLED. Used for root cause analysis and process improvement.',
    `container_condition` STRING COMMENT 'Physical condition of the container at pickup. Documented to establish liability for any damage occurring during drayage movement.. Valid values are `GOOD|DAMAGED|REQUIRES_INSPECTION`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the drayage order record was first created in the system. Audit trail for order lifecycle tracking.',
    `destination_address` STRING COMMENT 'Full street address of the destination location for customer premises or off-port facilities. Required for last-mile delivery coordination.',
    `destination_location_type` STRING COMMENT 'Type of destination location for container delivery. CY = Container Yard, CFS = Container Freight Station, ICD = Inland Container Depot.. Valid values are `CY|CFS|ICD|CUSTOMER_PREMISES|VESSEL|RAIL_YARD`',
    `drayage_order_number` STRING COMMENT 'Business-facing unique drayage order number issued to road hauliers for container movement instructions. Externally referenced identifier for tracking and communication.. Valid values are `^DRY-[0-9]{8,12}$`',
    `drayage_status` STRING COMMENT 'Current lifecycle status of the drayage order. Tracks progression from order creation through assignment, execution, and completion or cancellation.. Valid values are `PENDING|ASSIGNED|IN_TRANSIT|COMPLETED|CANCELLED|FAILED`',
    `drayage_type` STRING COMMENT 'Classification of the drayage movement type. IMPORT = laden container from port to customer, EXPORT = laden container from customer to port, EMPTY_RETURN = empty container return, REPOSITIONING = container relocation between port facilities.. Valid values are `IMPORT|EXPORT|EMPTY_RETURN|EMPTY_PICKUP|REPOSITIONING|CROSS_TOWN`',
    `failure_reason` STRING COMMENT 'Reason for drayage order failure if status is FAILED (e.g., container not available, access denied, address incorrect). Used for exception management.',
    `hazmat_indicator` BOOLEAN COMMENT 'Flag indicating whether the container contains hazardous materials requiring special handling and routing per IMDG Code.',
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
    `contact_person_id` BIGINT COMMENT 'Foreign key linking to customer.contact_person. Business justification: ICD facilities have a designated operational contact person registered in the port community system. The operator_contact_email and operator_contact_phone are denormalized from contact_person. Direct ',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: ICD facilities are registered under national customs and trade authorities. Country determines customs bonded status eligibility, bilateral trade agreement applicability, and sanctions screening requi',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: ICD facilities operate under concession or service agreements defining operational scope, revenue sharing arrangements, performance obligations, and service standards. Real business process: facility ',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: ICD facilities operate under a formal service agreement with the port authority governing access rights, billing terms, and operational conditions. Contract management and billing reconciliation requi',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: ICD facilities are operated by registered port community participants (freight stations, inland container depots). Regulatory reporting, ISPS compliance, and community participant management require l',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: ICD facilities serve specific seaports — distance_from_port_km confirms this conceptual link. Port authorities maintain a registry of ICDs serving their port for capacity planning, trade facilitation ',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: ICDs are physical locations within port infrastructure hierarchy. Spatial planning, distance calculations for drayage pricing, and facility master data management require proper location reference.',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.sla_profile. Business justification: ICD facilities operate under SLA agreements with the port covering turnaround times, connectivity performance, and service availability. The sla_turnaround_time_hours plain attribute is a denormalizat',
    `un_locode_id` BIGINT COMMENT 'Foreign key linking to masterdata.un_locode. Business justification: ICDs are formally registered UN/LOCODE locations (un_locode.is_inland_container_depot=true). Bill of lading origin/destination codes, customs declarations, and EDI messages reference ICD locations by ',
    `active_from_date` DATE COMMENT 'Date when the facility became operational and available for container handling in the ports intermodal network. Used for historical analysis and facility lifecycle tracking.',
    `active_to_date` DATE COMMENT 'Date when the facility ceased operations or was decommissioned. Nullable for currently active facilities. Used for historical reporting and capacity planning.',
    `address_line_1` STRING COMMENT 'Primary street address line of the ICD or CFS facility, including building number and street name. Used for truck dispatch routing and delivery instructions.',
    `address_line_2` STRING COMMENT 'Secondary address line for additional location details such as suite, building, or zone information. Optional field for complex facility addresses.',
    `average_drayage_time_hours` DECIMAL(18,2) COMMENT 'Average transit time for container drayage between the port and the ICD facility, measured in hours. Used for service level agreement (SLA) definition and operational planning.',
    `billing_currency_code` STRING COMMENT 'Three-letter ISO currency code used for billing and financial transactions with the facility operator (e.g., USD, EUR, INR). Used in invoice generation and revenue accounting.. Valid values are `^[A-Z]{3}$`',
    `city` STRING COMMENT 'City or municipality where the ICD or CFS facility is located. Used for geographic routing and regional logistics planning.',
    `contract_end_date` DATE COMMENT 'Date when the current service agreement or partnership contract expires. Nullable for open-ended agreements. Used for contract renewal planning and relationship management.',
    `contract_start_date` DATE COMMENT 'Date when the service agreement or partnership contract between the port and the ICD operator became effective. Used for contract lifecycle management and billing period determination.',
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
    `postal_code` STRING COMMENT 'Postal or ZIP code for the facility address. Used for mail delivery, geographic analysis, and logistics routing optimization.',
    `rail_connectivity` BOOLEAN COMMENT 'Indicates whether the facility has direct rail access for intermodal container transfer. True if rail siding or terminal connection exists; False for truck-only facilities. Critical for rail operations planning and modal shift strategies.',
    `reefer_plug_capacity` STRING COMMENT 'Number of electrical plug-in points available for refrigerated containers (reefers) requiring temperature control. Used for cold chain logistics planning and reefer container allocation.',
    `security_level` STRING COMMENT 'Current ISPS security level of the facility. LEVEL_1 for normal operations, LEVEL_2 for heightened security risk, LEVEL_3 for imminent security threat. Determines access control and security protocols.. Valid values are `LEVEL_1|LEVEL_2|LEVEL_3`',
    `state_province` STRING COMMENT 'State, province, or administrative region where the facility is located. Used for regulatory compliance and regional operational planning.',
    `storage_capacity_teu` STRING COMMENT 'Maximum container storage capacity of the facility measured in TEU (Twenty-foot Equivalent Units). Used for capacity planning, yard management, and operational load balancing across the intermodal network.',
    `truck_parking_capacity` STRING COMMENT 'Maximum number of trucks that can be accommodated simultaneously in the facilitys parking and staging areas. Used for truck appointment system capacity planning and gate congestion management.',
    `twenty_four_seven_operations` BOOLEAN COMMENT 'Indicates whether the facility operates 24 hours a day, 7 days a week. True for round-the-clock operations; False for facilities with limited operating hours. Impacts truck appointment system configuration and service level agreements.',
    CONSTRAINT pk_icd_facility PRIMARY KEY(`icd_facility_id`)
) COMMENT 'Master record for Inland Container Depots (ICDs) and Container Freight Stations (CFS) linked to the port, capturing facility code, name, address, geographic coordinates, operator, storage capacity (TEU), available services (FCL, LCL, customs bonded), operating hours, and EDI connectivity status. SSOT for inland depot reference data.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` (
    `transport_order_id` BIGINT COMMENT 'Unique identifier for the intermodal transport order. Primary key for the transport order entity.',
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: Transport orders execute intermodal movements for containers from cargo bookings. Port operations require linking transport orders to originating cargo bookings for delivery order validation, customs ',
    `call_schedule_id` BIGINT COMMENT 'Foreign key linking to vessel.call_schedule. Business justification: Transport orders are created against published vessel call schedules before actual call confirmation. Linking transport_order to call_schedule enables pre-booking of inland transport capacity aligned ',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Transport orders carry specific commodities requiring handling rules, storage area assignment, customs classification, hazmat compliance, and tariff calculation. Replaces denormalized hs_code with pro',
    `contact_person_id` BIGINT COMMENT 'Foreign key linking to customer.contact_person. Business justification: Transport orders have a designated contact person (shipper or consignee representative) for delivery coordination and documentation. The consignee_name and shipper_name are denormalized from contact_p',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Transport orders for cargo under customs hold must be suspended until hold release. Transport planners need this direct link to prevent dispatching held cargo, track hold-related delays, and calculate',
    `terminal_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal. Business justification: Transport order routing to terminal: the destination terminal is a core field for transport order execution; terminal_id enables terminal pre-arrival planning, berth coordination, and terminal-level t',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Transport orders specify terminal zone for final container delivery, enabling logistics coordination, capacity planning, and zone utilization reporting - supply chain visibility requirement.',
    `haulier_id` BIGINT COMMENT 'Foreign key linking to intermodal.haulier. Business justification: A transport order (IFTMIN message) is executed by a specific haulier/carrier. The transport_order table currently stores carrier_name as a free-text STRING, which is a denormalized reference to the ha',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.imdg_class. Business justification: Transport orders for hazardous cargo require validated IMDG classification for stowage planning, route restrictions, driver certification verification, and regulatory reporting to port authorities. No',
    `import_export_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.import_export_permit. Business justification: Controlled goods transport requires permit validation before movement authorization. Transport planners verify permit validity for restricted commodities (dual-use, CITES, strategic goods) to ensure r',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Transport orders specify equipment type for intermodal compatibility, mode selection, and pricing calculation. Replaces denormalized container_type text field with proper master data reference.',
    `icd_facility_id` BIGINT COMMENT 'Foreign key linking to intermodal.icd_facility. Business justification: When origin_location is an ICD facility, this FK links to the specific depot. Nullable FK (only populated when origin is an ICD). origin_location_code remains as fallback for non-ICD origins. Resolves',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Transport orders originating from warehouse enable supply chain visibility, warehouse inventory tracking, and multimodal logistics coordination - supply chain management requirement.',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: Transport orders are executed under a specific service agreement governing rates, transit time commitments, and liability terms. Invoice generation and contract compliance reporting require linking ea',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Transport orders coordinate intermodal movements with vessel call schedules. Operations require vessel call booking reference to synchronize container availability windows, coordinate gate-in cutoff t',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Transport orders are executed at a specific port. Port-level trade volume reporting, port authority billing, customs reporting, and port performance dashboards all require knowing which port a transpo',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Transport orders require employee ownership for customer service, issue escalation, customs coordination, and operational problem-solving. Intermodal operations track order coordinators for accountabi',
    `participant_account_id` BIGINT COMMENT 'Identifier of the party shipping the cargo. References the port community participant acting as the consignor.',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: A transport order for rail-based intermodal movement must reference the specific rail visit that fulfills it. This FK enables direct traceability from a transport instruction (IFTMIN) to the actual tr',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Transport orders use negotiated rate cards for contracted customers. Critical for order pricing, invoicing, and revenue recognition in intermodal transport operations.',
    `service_id` BIGINT COMMENT 'Foreign key linking to intermodal.intermodal_service. Business justification: Transport orders are routed via specific intermodal services. The service defines the corridor and mode; the order is the instruction. No columns removed because order has execution-specific attribute',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to cargo.shipment. Business justification: Transport orders move containers from port to inland destinations as part of specific maritime shipments. TMS systems track which ocean shipment each land leg serves for end-to-end visibility, cargo i',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Intermodal transport orders execute under master service agreements with freight forwarders/BCOs defining rates, liability limits, and service standards. Real business process: order acceptance valida',
    `tertiary_transport_carrier_participant_account_id` BIGINT COMMENT 'Identifier of the transport carrier or haulier assigned to execute this transport order. References the logistics service provider.',
    `trade_document_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_document. Business justification: Transport orders reference supporting trade documents (certificates of origin, phytosanitary certificates) for documentary compliance. Operators verify document validity before cargo acceptance to ens',
    `actual_delivery_date` TIMESTAMP COMMENT 'Actual date and time when cargo was delivered to consignee. Used for SLA compliance and proof of delivery.',
    `actual_pickup_date` TIMESTAMP COMMENT 'Actual date and time when cargo was picked up from origin. Used for performance tracking and billing.',
    `booking_reference` STRING COMMENT 'Reference to the original shipping booking or reservation that triggered this transport order. Links to upstream booking system.',
    `cargo_description` STRING COMMENT 'Textual description of the cargo contents. Provides human-readable summary of goods being transported.',
    `cargo_volume_cbm` DECIMAL(18,2) COMMENT 'Total volume of the cargo in cubic meters. Used for space planning and capacity management.',
    `cargo_weight_kg` DECIMAL(18,2) COMMENT 'Total weight of the cargo in kilograms. Used for load planning and compliance with weight restrictions.',
    `container_reference` STRING COMMENT 'ISO 6346 container number being transported. Links the transport order to the specific container unit.. Valid values are `^[A-Z]{4}[0-9]{7}$`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this transport order record was first created in the database. Used for audit trail.',
    `delivery_order_number` STRING COMMENT 'Delivery order number authorizing release of cargo to consignee. Used for cargo handover at destination.',
    `destination_location` STRING COMMENT 'Final delivery point for the intermodal transport. May be an inland container depot, customer facility, or distribution center.',
    `estimated_delivery_date` TIMESTAMP COMMENT 'Planned date and time for cargo delivery to destination. Used for customer communication and planning.',
    `estimated_pickup_date` TIMESTAMP COMMENT 'Planned date and time for cargo pickup from origin location. Used for scheduling and coordination.',
    `iftmin_reference` STRING COMMENT 'EDI IFTMIN message reference number for this transport instruction. Links to the electronic data interchange message sent to logistics partners.. Valid values are `^IFTMIN-[A-Z0-9]{10,20}$`',
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
    `special_instructions` STRING COMMENT 'Free-text field for special handling instructions, delivery notes, or operational requirements for the carrier.',
    `temperature_setpoint_celsius` DECIMAL(18,2) COMMENT 'Required temperature setting for refrigerated cargo in degrees Celsius. Null for non-refrigerated cargo.',
    `teu_count` DECIMAL(18,2) COMMENT 'TEU equivalent for this transport order. Standard measure for container capacity (20ft = 1 TEU, 40ft = 2 TEU).',
    `transport_mode_sequence` STRING COMMENT 'Ordered sequence of transport modes for this intermodal journey (e.g., sea-rail-road, sea-road, rail-road). Defines the multimodal routing plan.',
    `transport_order_number` STRING COMMENT 'Business-facing unique transport order number issued to carrier or haulier. Externally visible identifier used in communications and documentation.. Valid values are `^TO-[0-9]{8,12}$`',
    `un_number` STRING COMMENT 'Four-digit UN identification number for dangerous goods. Null if cargo is non-hazardous.. Valid values are `^UN[0-9]{4}$`',
    CONSTRAINT pk_transport_order PRIMARY KEY(`transport_order_id`)
) COMMENT 'Core transactional record representing an intermodal transport instruction (IFTMIN message) issued to a carrier or haulier, capturing transport order number, IFTMIN reference, shipper, consignee, origin, destination, mode sequence (sea-rail-road), container reference, cargo description, HS code, required delivery date, and order status. SSOT for intermodal transport instruction lifecycle.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` (
    `haulier_id` BIGINT COMMENT 'Unique identifier for the haulier record. Primary key for the intermodal transport carrier and operator registry.',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Hauliers provide trucking services and are vendors for procurement purposes (contracts, payments, performance evaluation). This FK enables linking haulier operational records to vendor master data for',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Haulier master service agreements define commercial terms, service scope, insurance requirements, performance standards, and rate structures. Real business process: haulier onboarding, commercial rela',
    `pilot_id` BIGINT COMMENT 'Foreign key linking to marine.pilot. Business justification: Haulier safety qualification (insurance, ISPS certification, incident history, performance rating) mandatory for port access authorization. Contractor safety management system tracks qualification_sta',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Hauliers are registered port community participants requiring unified participant management, accreditation tracking (ISPS compliance), EDI subscriptions, and regulatory oversight. Essential for port ',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Hauliers are licensed and operate at specific ports — port authority network access agreements, ISPS vetting, and port-level haulier performance reporting are port-specific. A port operations expert w',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.sla_profile. Business justification: Hauliers operate under SLA profiles governing on-time delivery, turnaround time, and service quality metrics. The performance_tier plain attribute is a denormalization of SLA tier. Direct link enables',
    `carrier_code` STRING COMMENT 'Unique business identifier code assigned to the haulier for operational reference and EDI messaging. Standard alphanumeric code used across port community systems.. Valid values are `^[A-Z0-9]{4,10}$`',
    `commercial_terms_reference` STRING COMMENT 'Reference identifier for the commercial terms, rate card, or pricing agreement governing the hauliers services with the port or terminal operator.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the haulier record was first created in the system.',
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
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Rail operators provide rail services and are vendors for procurement purposes (service contracts, invoicing, performance management). This FK enables linking rail operator operational records to vendo',
    `credit_assessment_id` BIGINT COMMENT 'Foreign key linking to customer.credit_assessment. Business justification: Rail operators are subject to credit assessments for billing on account and financial risk management. The credit_rating plain attribute is a denormalization of the credit assessment outcome. Direct l',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Rail operator concession/service agreements define track access rights, capacity allocation, infrastructure usage charges, and performance obligations. Real business process: operator authorization, c',
    `pilot_id` BIGINT COMMENT 'Foreign key linking to marine.pilot. Business justification: Rail operator safety certification, incident history, and compliance status required for network access agreement and regulatory approval. Contractor safety register tracks qualification_status, trir,',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Rail operators are port community participants requiring accreditation, regulatory compliance (safety/environmental certifications), EDI partner registration, and unified participant registry manageme',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Rail operators hold network access agreements with specific ports. Port authority licensing, rail capacity planning, and port-level rail operator performance reporting all require knowing which port a',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.sla_profile. Business justification: Rail operators are governed by SLA profiles covering on-time performance, train length compliance, and service reliability. The performance_rating plain attribute is a denormalization of SLA metrics. ',
    `container_handling_capability` STRING COMMENT 'Type of container units the operator is equipped to handle, including TEU (Twenty-foot Equivalent Unit), FEU (Forty-foot Equivalent Unit), refrigerated containers, and IMDG (International Maritime Dangerous Goods) certified cargo.. Valid values are `teu_only|feu_only|teu_feu_mixed|specialized_reefer|imdg_certified`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this rail operator record was first created in the system.',
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

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` (
    `service_id` BIGINT COMMENT 'Unique identifier for the intermodal transport service. Primary key.',
    `haulier_id` BIGINT COMMENT 'Foreign key linking to intermodal.haulier. Business justification: Truck services are operated by hauliers. The operator_id field is polymorphic (could be rail_operator or haulier depending on transport_mode). When transport_mode = TRUCK, this FK links to haulier. ',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Scheduled intermodal services (rail/truck corridors) operate under commercial agreements defining capacity allocation, pricing structures, and service level commitments. Real business process: service',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the transport operator or service provider responsible for executing this intermodal service.',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Intermodal services originate from or terminate at a specific port. Port-level service catalog management, tariff application, and port authority reporting require a direct FK to infrastructure.port. ',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Intermodal services operate between defined origin locations. Service planning, capacity allocation, and network design require proper location reference. Replaces denormalized origin_location text fi',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Intermodal services reference published port tariff schedules to calculate combined transport pricing. Essential for multimodal rate calculation and quote generation in port-hinterland transport opera',
    `rail_operator_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_operator. Business justification: Rail services are operated by rail operators. The operator_id field is polymorphic (could be rail_operator or haulier depending on transport_mode). When transport_mode = RAIL, this FK links to rail_',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.sla_profile. Business justification: Intermodal services are defined with specific SLA commitments for on-time performance and transit times. The sla_on_time_performance_target plain attribute is a denormalization of the SLA profile targ',
    `terminal_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal. Business justification: Service-terminal capacity allocation: intermodal services (rail/truck corridors) operate from specific terminals; terminal_id is required for terminal capacity allocation to services, service scheduli',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Intermodal services are assigned to a specific terminal zone (e.g., a dedicated rail terminal zone or truck staging zone). This supports resource planning, gate scheduling, and zone-level capacity man',
    `booking_cutoff_hours` STRING COMMENT 'Number of hours before scheduled departure that bookings must be submitted. Used for operational planning and customer service commitments.',
    `capacity_teu` STRING COMMENT 'Maximum container capacity per service departure, measured in TEU. Critical for load planning and service utilization tracking.',
    `service_code` STRING COMMENT 'Unique business identifier code for the intermodal service, used in operational systems and customer communications. Typically alphanumeric 6-12 characters.. Valid values are `^[A-Z0-9]{6,12}$`',
    `corridor_code` STRING COMMENT 'Standardized code representing the origin-destination corridor, typically in format XXX-YYY where XXX is origin and YYY is destination location code.. Valid values are `^[A-Z]{3}-[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this intermodal service record was first created in the system. Used for audit trail and data lineage.',
    `customs_clearance_supported` BOOLEAN COMMENT 'Indicates whether this intermodal service includes customs clearance coordination at origin or destination, critical for international cargo movements.',
    `dangerous_goods_allowed` BOOLEAN COMMENT 'Indicates whether this service is certified and equipped to handle IMDG (International Maritime Dangerous Goods) classified cargo.',
    `service_description` STRING COMMENT 'Detailed description of the intermodal service offering, including route highlights, special features, and operational characteristics. Used for marketing and customer communications.',
    `destination_location` STRING COMMENT 'End point of the intermodal service corridor. Typically an Inland Container Depot (ICD), rail terminal, or distribution center.',
    `edi_enabled` BOOLEAN COMMENT 'Indicates whether this service supports EDI integration for automated booking, COPARN (Container Pre-Announcement), and IFTMIN (Instruction Message for Transport) messaging with inland logistics partners.',
    `edi_message_types` STRING COMMENT 'Pipe-separated list of supported EDI message types for this service, such as COPARN, IFTMIN, IFTMBC (Booking Confirmation), IFTSTA (Status Report).',
    `effective_from_date` DATE COMMENT 'Date when this intermodal service becomes operational and available for booking. Used for service lifecycle management.',
    `effective_to_date` DATE COMMENT 'Date when this intermodal service is scheduled to end or be discontinued. Nullable for ongoing services.',
    `equipment_type_supported` STRING COMMENT 'Types of container equipment supported by this service. May include standard dry containers, reefers, open-top, flat-rack, tank containers. Pipe-separated list if multiple types.',
    `frequency` STRING COMMENT 'Frequency at which the intermodal service operates. Daily: every day. Weekly: once per week. Bi-weekly: twice per week. On-demand: as requested. Scheduled: fixed timetable.. Valid values are `daily|weekly|bi_weekly|on_demand|scheduled`',
    `gate_cutoff_hours` STRING COMMENT 'Number of hours before scheduled departure that containers must be delivered to the origin gate or Container Yard (CY). Critical for load planning.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this intermodal service record was last updated. Used for change tracking and audit purposes.',
    `service_name` STRING COMMENT 'Human-readable name of the intermodal transport service, used for marketing and operational reference.',
    `oversize_cargo_allowed` BOOLEAN COMMENT 'Indicates whether this service can accommodate oversize or out-of-gauge cargo such as open-top or flat-rack containers.',
    `reefer_capable` BOOLEAN COMMENT 'Indicates whether this service can handle refrigerated containers with temperature-controlled transport throughout the corridor.',
    `remarks` STRING COMMENT 'Additional operational notes, restrictions, or special instructions related to this intermodal service. Free-text field for operational teams.',
    `route_distance_km` DECIMAL(18,2) COMMENT 'Total distance of the intermodal service route measured in kilometers, used for transit time calculation and tariff determination.',
    `service_status` STRING COMMENT 'Current operational status of the intermodal service. Active: currently operating. Suspended: temporarily halted. Discontinued: permanently ended. Planned: future service. Seasonal: operates during specific periods.. Valid values are `active|suspended|discontinued|planned|seasonal`',
    `service_type` STRING COMMENT 'Classification of the intermodal service offering. Rail shuttle: dedicated rail service between port and inland terminal. ICD linkage: connection to Inland Container Depot. Drayage: short-haul truck movement. Inland barge: waterway transport. Road feeder: scheduled truck service. Multimodal corridor: combination of transport modes.. Valid values are `rail_shuttle|icd_linkage|drayage|inland_barge|road_feeder|multimodal_corridor`',
    `transit_time_hours` DECIMAL(18,2) COMMENT 'Benchmark transit time for the service from origin to destination, measured in hours. Used for Service Level Agreement (SLA) commitments and customer expectations.',
    `transport_mode` STRING COMMENT 'Primary mode of transport for this service. Rail: railway transport. Truck: road transport. Barge: inland waterway. Multimodal: combination of modes.. Valid values are `rail|truck|barge|multimodal`',
    `weekly_departures` STRING COMMENT 'Number of scheduled departures per week for this service. Used for capacity planning and customer service commitments.',
    CONSTRAINT pk_service PRIMARY KEY(`service_id`)
) COMMENT 'Master catalog of intermodal transport services and corridors offered by the port, including rail shuttle services, ICD linkage routes, drayage service packages, and scheduled inland connections. Captures service code, name, transport mode, origin-destination corridor, route distance (km), transit time benchmark, frequency, capacity (TEU), active operators, tariff reference, and service status. SSOT for intermodal service offerings and corridor definitions.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` (
    `wagon_consist_id` BIGINT COMMENT 'Unique system identifier for this wagon-to-visit assignment record. Primary key.',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to the rail visit record. Identifies which specific train visit this wagon assignment belongs to.',
    `rail_wagon_id` BIGINT COMMENT 'Foreign key linking to the rail wagon master record. Identifies which specific wagon is part of this train consist.',
    `arrival_load_status` STRING COMMENT 'The load status of the wagon when the train arrived at the terminal. Distinguishes inbound vs outbound cargo handling.',
    `assigned_timestamp` TIMESTAMP COMMENT 'The date and time when this wagon was assigned to this train visit in the Terminal Operating System.',
    `consist_status` STRING COMMENT 'The operational status of this wagon assignment within the train visit lifecycle. Tracks progression from planning through completion.',
    `container_count_on_wagon` STRING COMMENT 'The number of containers loaded on this specific wagon during this specific visit. Varies by visit based on cargo type and stacking configuration.',
    `departure_load_status` STRING COMMENT 'The load status of the wagon when the train departed from the terminal. Tracks whether the wagon was loaded, unloaded, or remained unchanged.',
    `discharge_sequence` STRING COMMENT 'The planned or actual sequence in which this wagon will be/was unloaded during this visit. May differ from wagon_position_on_train based on operational priorities.',
    `hazmat_on_wagon` BOOLEAN COMMENT 'Flag indicating whether this wagon is carrying hazardous materials during this visit. Affects positioning in consist and handling procedures.',
    `load_status_at_visit` STRING COMMENT 'The load status of this specific wagon at the time of this visit. A wagon may arrive loaded and depart empty, or vice versa. This is visit-specific, not a wagon attribute.',
    `notes` STRING COMMENT 'Free-text operational notes specific to this wagon on this visit (e.g., damage observed, special handling instructions, delays).',
    `reefer_power_required` BOOLEAN COMMENT 'Indicates whether this wagon requires reefer power connection during this visit (for refrigerated containers). Affects terminal resource allocation.',
    `seal_number` STRING COMMENT 'The customs or security seal number applied to this wagon for this visit, if applicable. Used for cargo security and customs verification.',
    `teu_on_wagon` DECIMAL(18,2) COMMENT 'The total TEU (Twenty-foot Equivalent Units) loaded on this wagon for this visit. Used for capacity utilization reporting and billing.',
    `unassigned_timestamp` TIMESTAMP COMMENT 'The date and time when this wagon was removed from this train visit (if applicable). Used for consist changes and operational adjustments.',
    `wagon_position_on_train` STRING COMMENT 'The sequential position of this wagon in the train consist (1 = first wagon, 2 = second, etc.). Critical for operational planning, discharge sequencing, and safety (weight distribution, hazmat separation).',
    CONSTRAINT pk_wagon_consist PRIMARY KEY(`wagon_consist_id`)
) COMMENT 'This association product represents the operational assignment of a rail wagon to a specific train visit. It captures the train consist (the list of wagons forming a specific train) — a well-recognized business concept in rail freight operations. Each record links one rail wagon to one rail visit with attributes that exist only in the context of this specific visit assignment, including wagon position, load status, container count, and discharge sequencing.. Existence Justification: In rail freight operations, the train consist (the list of wagons forming a specific train) is a fundamental operational concept. A rail wagon participates in many train visits over its lifecycle, and each train visit consists of many wagons. Port terminals actively manage wagon manifests per visit, tracking position, load status, container count, seal numbers, and discharge sequencing for each wagon-visit combination. This is not an analytical correlation but an operational business process.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_rail_operator_id` FOREIGN KEY (`rail_operator_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_operator`(`rail_operator_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_service_id` FOREIGN KEY (`service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`service`(`service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ADD CONSTRAINT `fk_intermodal_rail_wagon_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ADD CONSTRAINT `fk_intermodal_rail_wagon_rail_operator_id` FOREIGN KEY (`rail_operator_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_operator`(`rail_operator_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_service_id` FOREIGN KEY (`service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`service`(`service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_drayage_order_id` FOREIGN KEY (`drayage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`drayage_order`(`drayage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_truck_appointment_id` FOREIGN KEY (`truck_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment`(`truck_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_service_id` FOREIGN KEY (`service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`service`(`service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_service_id` FOREIGN KEY (`service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`service`(`service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ADD CONSTRAINT `fk_intermodal_service_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ADD CONSTRAINT `fk_intermodal_service_rail_operator_id` FOREIGN KEY (`rail_operator_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_operator`(`rail_operator_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ADD CONSTRAINT `fk_intermodal_wagon_consist_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ADD CONSTRAINT `fk_intermodal_wagon_consist_rail_wagon_id` FOREIGN KEY (`rail_wagon_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon`(`rail_wagon_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`intermodal` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`intermodal` SET TAGS ('dbx_domain' = 'intermodal');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` SET TAGS ('dbx_subdomain' = 'rail_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Icd Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Infrastructure Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Track Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `rail_operator_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Operator Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `service_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Service Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Profile Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `thc_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Thc Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Home Depot Icd Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Current Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `rail_operator_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Operator Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Registration Country Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `owner_name` SET TAGS ('dbx_business_glossary_term' = 'Owner Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `owner_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `refrigeration_capable` SET TAGS ('dbx_business_glossary_term' = 'Refrigeration Capable');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ALTER COLUMN `registration_authority` SET TAGS ('dbx_business_glossary_term' = 'Registration Authority');
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
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `port_access_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Driver Port Access Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Haulier Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Icd Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Imdg Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `import_export_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Import Export Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Booking Party ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Access Credential Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `service_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Service ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `thc_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Thc Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `trade_document_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Document Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `drayage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Drayage Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `gate_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Transaction Id');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Trucking Company ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Weighbridge Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Driver ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Profile Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `truck_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Appointment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Inspection Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Driver Access Credential Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Terminal Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Haulier Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Imdg Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Icd Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Handling Equipment Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Port Call Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `service_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Service Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Profile Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `actual_delivery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `actual_pickup_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Pickup Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `container_condition` SET TAGS ('dbx_business_glossary_term' = 'Container Condition');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `container_condition` SET TAGS ('dbx_value_regex' = 'GOOD|DAMAGED|REQUIRES_INSPECTION');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
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
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` SET TAGS ('dbx_subdomain' = 'service_management');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Inland Container Depot (ICD) Facility Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `contact_person_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Person Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Profile Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `un_locode_id` SET TAGS ('dbx_business_glossary_term' = 'Un Locode Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `rail_connectivity` SET TAGS ('dbx_business_glossary_term' = 'Rail Connectivity Available');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `reefer_plug_capacity` SET TAGS ('dbx_business_glossary_term' = 'Refrigerated Container (Reefer) Plug Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `security_level` SET TAGS ('dbx_business_glossary_term' = 'Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `security_level` SET TAGS ('dbx_value_regex' = 'LEVEL_1|LEVEL_2|LEVEL_3');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State or Province');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `storage_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Storage Capacity in Twenty-foot Equivalent Units (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `truck_parking_capacity` SET TAGS ('dbx_business_glossary_term' = 'Truck Parking Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ALTER COLUMN `twenty_four_seven_operations` SET TAGS ('dbx_business_glossary_term' = 'Twenty-Four Seven Operations');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` SET TAGS ('dbx_subdomain' = 'service_management');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `call_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Call Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `contact_person_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Person Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Terminal Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Haulier Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Imdg Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `import_export_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Import Export Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Masterdata Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Icd Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Coordinator Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Shipper ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `service_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Service Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `tertiary_transport_carrier_participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier ID');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `trade_document_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Document Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `actual_pickup_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Pickup Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `booking_reference` SET TAGS ('dbx_business_glossary_term' = 'Booking Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `cargo_description` SET TAGS ('dbx_business_glossary_term' = 'Cargo Description');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `cargo_volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Cargo Volume in Cubic Meters (CBM)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `cargo_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Cargo Weight in Kilograms (KG)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `container_reference` SET TAGS ('dbx_business_glossary_term' = 'Container Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `container_reference` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order (D/O) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `destination_location` SET TAGS ('dbx_business_glossary_term' = 'Destination Location');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `estimated_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Delivery Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `estimated_pickup_date` SET TAGS ('dbx_business_glossary_term' = 'Estimated Pickup Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `iftmin_reference` SET TAGS ('dbx_business_glossary_term' = 'Instruction Message for Transport (IFTMIN) Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `iftmin_reference` SET TAGS ('dbx_value_regex' = '^IFTMIN-[A-Z0-9]{10,20}$');
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
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `temperature_setpoint_celsius` SET TAGS ('dbx_business_glossary_term' = 'Temperature Setpoint in Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `teu_count` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Count');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `transport_mode_sequence` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode Sequence');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `transport_order_number` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `transport_order_number` SET TAGS ('dbx_value_regex' = '^TO-[0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` SET TAGS ('dbx_subdomain' = 'road_transport');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Haulier Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Contractor Safety Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Profile Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `carrier_code` SET TAGS ('dbx_business_glossary_term' = 'Carrier Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `carrier_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `commercial_terms_reference` SET TAGS ('dbx_business_glossary_term' = 'Commercial Terms Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
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
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `credit_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Assessment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `pilot_id` SET TAGS ('dbx_business_glossary_term' = 'Contractor Safety Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Profile Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `container_handling_capability` SET TAGS ('dbx_business_glossary_term' = 'Container Handling Capability');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `container_handling_capability` SET TAGS ('dbx_value_regex' = 'teu_only|feu_only|teu_feu_mixed|specialized_reefer|imdg_certified');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
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
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` SET TAGS ('dbx_subdomain' = 'service_management');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `service_id` SET TAGS ('dbx_business_glossary_term' = 'Intermodal Service Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `haulier_id` SET TAGS ('dbx_business_glossary_term' = 'Haulier Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `rail_operator_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Operator Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Profile Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `booking_cutoff_hours` SET TAGS ('dbx_business_glossary_term' = 'Booking Cutoff Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Capacity in Twenty-foot Equivalent Units (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `service_code` SET TAGS ('dbx_business_glossary_term' = 'Service Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `service_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `corridor_code` SET TAGS ('dbx_business_glossary_term' = 'Corridor Code');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `corridor_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}-[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `customs_clearance_supported` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Supported');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `dangerous_goods_allowed` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Allowed');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `service_description` SET TAGS ('dbx_business_glossary_term' = 'Service Description');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `destination_location` SET TAGS ('dbx_business_glossary_term' = 'Destination Location');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `edi_enabled` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `edi_message_types` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Message Types');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `equipment_type_supported` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Supported');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `frequency` SET TAGS ('dbx_business_glossary_term' = 'Service Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|bi_weekly|on_demand|scheduled');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `gate_cutoff_hours` SET TAGS ('dbx_business_glossary_term' = 'Gate Cutoff Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `service_name` SET TAGS ('dbx_business_glossary_term' = 'Service Name');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `oversize_cargo_allowed` SET TAGS ('dbx_business_glossary_term' = 'Oversize Cargo Allowed');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `reefer_capable` SET TAGS ('dbx_business_glossary_term' = 'Reefer Capable');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `route_distance_km` SET TAGS ('dbx_business_glossary_term' = 'Route Distance in Kilometers (km)');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `service_status` SET TAGS ('dbx_business_glossary_term' = 'Service Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `service_status` SET TAGS ('dbx_value_regex' = 'active|suspended|discontinued|planned|seasonal');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'rail_shuttle|icd_linkage|drayage|inland_barge|road_feeder|multimodal_corridor');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `transit_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Transit Time in Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'rail|truck|barge|multimodal');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ALTER COLUMN `weekly_departures` SET TAGS ('dbx_business_glossary_term' = 'Weekly Departures');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` SET TAGS ('dbx_subdomain' = 'rail_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` SET TAGS ('dbx_association_edges' = 'intermodal.rail_wagon,intermodal.rail_visit');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `wagon_consist_id` SET TAGS ('dbx_business_glossary_term' = 'Wagon Consist Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Wagon Consist - Rail Visit Id');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `rail_wagon_id` SET TAGS ('dbx_business_glossary_term' = 'Wagon Consist - Rail Wagon Id');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `arrival_load_status` SET TAGS ('dbx_business_glossary_term' = 'Arrival Load Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `assigned_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Assignment Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `consist_status` SET TAGS ('dbx_business_glossary_term' = 'Consist Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `container_count_on_wagon` SET TAGS ('dbx_business_glossary_term' = 'Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `departure_load_status` SET TAGS ('dbx_business_glossary_term' = 'Departure Load Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `discharge_sequence` SET TAGS ('dbx_business_glossary_term' = 'Discharge Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `hazmat_on_wagon` SET TAGS ('dbx_business_glossary_term' = 'Hazmat Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `load_status_at_visit` SET TAGS ('dbx_business_glossary_term' = 'Wagon Load Status');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Operational Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `reefer_power_required` SET TAGS ('dbx_business_glossary_term' = 'Reefer Power Requirement');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `seal_number` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `teu_on_wagon` SET TAGS ('dbx_business_glossary_term' = 'TEU Count on Wagon');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `unassigned_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Unassignment Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`wagon_consist` ALTER COLUMN `wagon_position_on_train` SET TAGS ('dbx_business_glossary_term' = 'Wagon Position Number');
