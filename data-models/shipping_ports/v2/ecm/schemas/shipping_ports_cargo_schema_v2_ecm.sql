-- Schema for Domain: cargo | Business: Shipping_Ports | Version: v2_ecm
-- Generated on: 2026-07-13 08:38:25

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`cargo` COMMENT 'Manages cargo handling, loading/discharge operations, stowage planning (BAPLIE), dangerous goods (IMDG), FCL/LCL management, BOL processing, and cargo documentation. Covers cargo manifests, POL/POD tracking, container pre-announcement (COPARN), delivery orders (D/O), HS Code assignment, and cargo condition monitoring. SSOT for cargo movement and handling data.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` (
    `shipment_id` BIGINT COMMENT 'Unique identifier for the cargo shipment consignment moving through the port. Primary key for the shipment entity. System-generated surrogate key used across all port systems to track this cargo movement from pre-arrival notification through final delivery or transshipment.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Shipments operate under service agreements with shipping lines or terminal operators defining rates, service levels, and terms. Essential for billing validation, rate application, and SLA tracking in ',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: Shipments execute cargo bookings - fundamental booking-to-execution traceability for operational tracking, billing reconciliation, and performance measurement. Maritime operations require linking actu',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Cargo shipments reference commodity codes for classification, tariff determination, and regulatory compliance. Currently shipment has hs_code as a string. Adding FK to masterdata.commodity_code enable',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Shipments are cleared by customs brokers. Real business process: broker assignment, declaration submission, clearance coordination. Shippers appoint brokers per shipment; port community systems track ',
    `cyber_incident_id` BIGINT COMMENT 'Foreign key linking to security.cyber_incident. Business justification: Cyber incidents affecting cargo systems (TOS, PCS, EDI) must reference impacted shipments for operational recovery, customer notification, and business continuity. Links cyber-attack to affected cargo',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Shipments are discharged at specific berths; essential for vessel operations planning, berth allocation, and cargo tracking. Port operators must know which berth each shipment was handled at for opera',
    `packaging_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.packaging_type. Business justification: Shipments declare package types for customs compliance, SOLAS VGM validation, and dangerous goods packaging verification. Linking to packaging_type master enables automated validation of IMDG packagin',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Shipments are charged according to applicable port tariff schedules. Port billing systems must link each shipment to the tariff schedule governing its charges for invoicing and revenue recognition. Es',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the party (organization or individual) receiving the cargo. The consignee to whom the goods are being shipped and who will take delivery at destination.',
    `call_id` BIGINT COMMENT 'Reference to the next vessel call for transshipment cargo. Links the shipment to the outbound vessel on which it will continue its journey. Populated only when is_transshipment is true.',
    `tertiary_shipment_port_community_participant_id` BIGINT COMMENT 'Reference to the party (organization or individual) shipping the cargo. The consignor who is sending the goods and typically appears on the Bill of Lading as the shipper.',
    `threat_assessment_id` BIGINT COMMENT 'Foreign key linking to security.threat_assessment. Business justification: High-risk shipments (origin, commodity, shipper profile) trigger threat assessments under ISPS Code. Links shipment to formal threat evaluation, enabling risk-based cargo screening, enhanced security ',
    `trade_restriction_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_restriction. Business justification: Shipments must be screened against trade restrictions (embargoes, sanctions, prohibited goods). Real regulatory requirement: export control compliance, sanctions enforcement. Booking systems verify sh',
    `bol_number` STRING COMMENT 'Bill of Lading number serving as the contract of carriage and receipt for goods. Critical document reference for cargo ownership, customs clearance, and delivery authorization. May be Master BOL or House BOL depending on shipment type.. Valid values are `^[A-Z0-9]{10,25}$`',
    `cargo_condition` STRING COMMENT 'Physical condition of the cargo as observed during handling operations. Documented for liability, insurance claims, and dispute resolution. Updated during discharge, inspection, and delivery.. Valid values are `Good|Damaged|Contaminated|Missing|Wet`',
    `cargo_type` STRING COMMENT 'Classification of cargo handling method: FCL (Full Container Load), LCL (Less than Container Load), RoRo (Roll-on Roll-off), LoLo (Lift-on Lift-off), Bulk, or Breakbulk. Determines handling equipment, storage requirements, and operational procedures.. Valid values are `FCL|LCL|RoRo|LoLo|Bulk|Breakbulk`',
    `commodity_description` STRING COMMENT 'Textual description of the cargo commodity being shipped. Provides human-readable detail about the goods for operational, customs, and commercial purposes. Complements the HS Code classification.',
    `container_count` STRING COMMENT 'Total number of physical containers (of any size) associated with this shipment. Used for gate operations, yard planning, and equipment tracking. Applicable only to containerized cargo types (FCL/LCL).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this shipment record was first created in the port system. Audit field for data lineage and record lifecycle tracking.',
    `declared_value_usd` DECIMAL(18,2) COMMENT 'Declared commercial value of the cargo in US Dollars. Used for customs valuation, insurance coverage, and liability limits. May differ from actual market value.',
    `delivery_order_issue_date` DATE COMMENT 'Date when the Delivery Order was issued by the shipping line or port authority. Marks the point when cargo becomes available for pickup by the consignee.',
    `delivery_order_number` STRING COMMENT 'Delivery Order number authorizing the release of cargo to the consignee or their agent. Required document for gate-out operations and proof of delivery authorization.. Valid values are `^[A-Z0-9]{8,20}$`',
    `discharge_date` DATE COMMENT 'Date when the cargo was physically discharged from the vessel at the berth. Key operational milestone for calculating vessel turnaround time and initiating yard operations.',
    `feu_count` DECIMAL(18,2) COMMENT 'Number of Forty-foot Equivalent Units represented by this shipment. Alternative measure for containerized cargo, particularly for larger containers. Used alongside TEU for operational reporting.',
    `final_destination_port_code` STRING COMMENT 'UN/LOCODE for the ultimate destination port if different from POD. Used for transshipment cargo where the current port is an intermediate stop.. Valid values are `^[A-Z]{5}$`',
    `freight_terms` STRING COMMENT 'Terms indicating who is responsible for freight payment: Prepaid (shipper pays), Collect (consignee pays), or Third-Party (another party pays). Affects billing and revenue allocation.. Valid values are `Prepaid|Collect|Third-Party`',
    `gate_out_date` DATE COMMENT 'Date when the cargo exited the port terminal through the gate. Marks final delivery or transfer to inland transport. Used for dwell time calculation and billing finalization.',
    `gross_weight_mt` DECIMAL(18,2) COMMENT 'Total gross weight of the shipment including packaging and container tare weight, measured in metric tons. Used for vessel stowage planning, berth load calculations, and billing.',
    `imdg_class` STRING COMMENT 'IMDG classification code for dangerous goods (e.g., Class 3 for flammable liquids, Class 8 for corrosives). Determines handling procedures, storage segregation, and emergency response protocols. Populated only when is_dangerous_goods is true.. Valid values are `^(1|2.1|2.2|2.3|3|4.1|4.2|4.3|5.1|5.2|6.1|6.2|7|8|9)$`',
    `incoterm` STRING COMMENT 'Three-letter Incoterm code defining the division of costs, risks, and responsibilities between shipper and consignee. Determines liability boundaries and insurance requirements. [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF — 11 candidates stripped; promote to reference product]',
    `insurance_policy_number` STRING COMMENT 'Reference number for the cargo insurance policy covering this shipment. Used for claims processing in case of loss, damage, or delay.. Valid values are `^[A-Z0-9]{8,25}$`',
    `is_dangerous_goods` BOOLEAN COMMENT 'Boolean flag indicating whether this shipment contains dangerous goods requiring special handling, storage, and documentation per IMDG Code. Triggers additional safety protocols and segregation requirements.',
    `is_oversized` BOOLEAN COMMENT 'Boolean flag indicating whether this shipment contains oversized cargo exceeding standard container or vessel dimensions. Requires special handling equipment, berth planning, and route clearance.',
    `is_reefer` BOOLEAN COMMENT 'Boolean flag indicating whether this shipment requires refrigeration (reefer container). Triggers temperature monitoring, power supply allocation, and specialized handling procedures.',
    `is_transshipment` BOOLEAN COMMENT 'Boolean flag indicating whether this cargo is being transshipped (transferred to another vessel) rather than being delivered locally. Affects yard allocation, customs procedures, and operational workflow.',
    `net_weight_mt` DECIMAL(18,2) COMMENT 'Net weight of the cargo excluding packaging and container tare weight, measured in metric tons. Used for customs valuation, trade statistics, and commercial invoicing.',
    `pod_port_code` STRING COMMENT 'UN/LOCODE five-character code identifying the port where the cargo will be discharged from the vessel. Determines berth allocation, discharge operations, and onward routing.. Valid values are `^[A-Z]{5}$`',
    `pol_port_code` STRING COMMENT 'UN/LOCODE five-character code identifying the port where the cargo was originally loaded onto the vessel. Critical for routing, customs, and trade statistics.. Valid values are `^[A-Z]{5}$`',
    `pre_arrival_notification_date` DATE COMMENT 'Date when the shipment was first pre-advised to the port via COPARN or other EDI message. Enables advance planning for berth allocation, yard space, and resource scheduling.',
    `shipment_status` STRING COMMENT 'Current status of the shipment in its lifecycle through the port. Tracks progression from pre-arrival notification through final delivery or transshipment. Updated by TOS and PCS systems as cargo moves through operational milestones. [ENUM-REF-CANDIDATE: Pre-Advised|In-Transit|Arrived|Discharged|Customs-Cleared|Ready-for-Delivery|Delivered|Transshipped — 8 candidates stripped; promote to reference product]',
    `special_handling_instructions` STRING COMMENT 'Free-text field capturing any special handling requirements or instructions for the cargo (e.g., fragile, keep upright, temperature-sensitive, security escort required). Communicated to operational teams.',
    `stowage_position` STRING COMMENT 'Six-digit bay-row-tier code indicating the cargos stowage location on the vessel per BAPLIE standard. Used for discharge planning, load sequencing, and operational coordination with vessel crew.. Valid values are `^[0-9]{6}$`',
    `temperature_setpoint_celsius` DECIMAL(18,2) COMMENT 'Required temperature setpoint in degrees Celsius for refrigerated cargo. Used to configure reefer container settings and monitor temperature compliance. Populated only when is_reefer is true.',
    `teu_count` DECIMAL(18,2) COMMENT 'Number of Twenty-foot Equivalent Units represented by this shipment. Standard measure for containerized cargo capacity. One 40-foot container equals 2.0 TEU. Used for port throughput statistics and capacity planning.',
    `un_number` STRING COMMENT 'Four-digit UN number identifying the specific dangerous substance (e.g., UN1203 for gasoline). Used for emergency response, handling instructions, and regulatory compliance. Populated only for dangerous goods shipments.. Valid values are `^UN[0-9]{4}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this shipment record was last modified. Audit field for change tracking and data quality monitoring.',
    `volume_cbm` DECIMAL(18,2) COMMENT 'Total volume of the shipment measured in cubic meters. Critical for yard space allocation, warehouse planning, and volumetric billing calculations.',
    `yard_location` STRING COMMENT 'Alphanumeric code identifying the specific yard block, row, and slot where the cargo is stored in the container yard or warehouse. Used for retrieval operations and inventory management.. Valid values are `^[A-Z0-9]{4,12}$`',
    CONSTRAINT pk_shipment PRIMARY KEY(`shipment_id`)
) COMMENT 'Core master entity representing a cargo consignment moving through the port, from pre-arrival notification to final delivery or transshipment. Captures shipper/consignee parties, POL/POD routing, cargo type (FCL/LCL/RoRo/LoLo/Bulk), commodity description, HS Code reference, weight (MT), volume (CBM), TEU/FEU count, booking and BOL references, vessel call linkage, IMDG classification where applicable, and cargo lifecycle status. SSOT for cargo consignment identity within the port ecosystem.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`container` (
    `container_id` BIGINT COMMENT 'Unique system identifier for the container record. Primary key for the container entity.',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: Containers are allocated to fulfill cargo bookings - essential for container inventory management, booking fulfillment tracking, and slot utilization reporting. Port operations track which containers ',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Container-vessel compatibility validation is critical for stowage planning (e.g., reefer containers require vessels with reefer plug capacity, oversized containers require specific vessel configuratio',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Cargo containers reference standardized container types. Currently container has iso_type_code and container_type as strings. Adding FK to masterdata.container_type enables standardized container clas',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Containers crossing international borders require customs declarations for clearance. Real business process: terminal gate systems verify container-level customs clearance before gate-out. Supports co',
    `access_event_id` BIGINT COMMENT 'Foreign key linking to security.access_event. Business justification: Container gate-in generates access event linking container arrival to physical gate access. Enables verification of authorized entry, driver identification, and security compliance. Supports audit tra',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to cargo.shipment. Business justification: Container is assigned to a shipment. Booking_number and bill_of_lading_number are shipment attributes that should be retrieved via FK. This links the physical container unit to the commercial shipment',
    `storage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.storage_tariff. Business justification: Container storage charges are calculated using storage tariff schedules based on container type, status, and dwell time. Terminal billing systems require this link to compute daily storage fees and ap',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Containers are stored in specific terminal yard zones; fundamental to container tracking, yard management, and retrieval operations. Current_location_code is insufficient; zone_id provides structured ',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Containers requiring special storage (LCL, bonded, hazmat, reefer) are stored in warehouses; essential for warehouse inventory management, customs compliance, and specialized cargo handling operations',
    `condition_grade` STRING COMMENT 'Physical condition grade assigned during inspection: A (excellent), B (good), C (fair - minor repairs needed), D (poor - major repairs needed), E (unserviceable). Used for maintenance planning and commercial decisions.. Valid values are `A|B|C|D|E`',
    `container_number` STRING COMMENT 'Unique container identification number in ISO 6346 format consisting of 4-letter owner code, 6-digit serial number, and 1 check digit. This is the globally recognized identifier for the physical container unit.. Valid values are `^[A-Z]{4}[0-9]{7}$`',
    `container_status` STRING COMMENT 'Current operational status of the container: full (loaded with cargo), empty (available for loading), damaged (requires inspection/repair), under_repair (in maintenance), retired (out of service), in_transit (moving between locations).. Valid values are `full|empty|damaged|under_repair|retired|in_transit`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this container record was first created in the terminal operating system. Used for audit trail and data lineage.',
    `csc_plate_expiry_date` DATE COMMENT 'Expiry date of the CSC safety approval plate. Containers must be re-certified before this date to remain in service. Critical for regulatory compliance and port acceptance.',
    `cubic_capacity_cbm` DECIMAL(18,2) COMMENT 'Internal cubic capacity of the container in cubic meters (CBM). Used for cargo stowage planning and freight calculations.',
    `current_location_code` STRING COMMENT 'Code identifying the current physical location of the container within the terminal (e.g., yard block, berth, gate, CFS). Used for real-time container tracking and retrieval.',
    `current_position_timestamp` TIMESTAMP COMMENT 'Timestamp when the container was last positioned at its current location. Used for dwell time calculation and operational tracking.',
    `delivery_order_number` STRING COMMENT 'Delivery Order number authorizing the release of the container to the consignee or their agent. Required for gate-out operations.',
    `final_destination_code` STRING COMMENT 'Five-character UN/LOCODE identifying the final inland destination for the container cargo. May differ from POD for transshipment or intermodal movements.. Valid values are `^[A-Z]{5}$`',
    `gate_in_timestamp` TIMESTAMP COMMENT 'Timestamp when the container entered the terminal through the gate. Marks the start of terminal custody and dwell time calculation.',
    `gate_out_timestamp` TIMESTAMP COMMENT 'Timestamp when the container exited the terminal through the gate. Marks the end of terminal custody and completion of dwell time.',
    `hazmat_certification_number` STRING COMMENT 'Certification or approval number for containers authorized to carry dangerous goods. Null for non-certified or non-hazmat containers. Required for IMDG compliance.',
    `height_ft` DECIMAL(18,2) COMMENT 'Physical height of the container in feet. Standard values: 8.5 ft (standard), 9.5 ft (high cube).',
    `imdg_class` STRING COMMENT 'IMDG hazard classification for dangerous goods cargo (e.g., Class 1 Explosives, Class 2 Gases, Class 3 Flammable Liquids, etc.). Null for non-hazmat containers. Determines stowage restrictions and segregation requirements.',
    `is_hazmat` BOOLEAN COMMENT 'Boolean flag indicating whether the container holds dangerous goods requiring special handling, stowage, and documentation per IMDG Code. True if hazmat cargo present, False otherwise.',
    `is_oversize` BOOLEAN COMMENT 'Boolean flag indicating whether the container carries oversize cargo extending beyond standard container dimensions (e.g., open top, flat rack with protruding cargo). Affects stowage planning and handling requirements.',
    `is_overweight` BOOLEAN COMMENT 'Boolean flag indicating whether the container exceeds standard weight limits, requiring special handling equipment or stowage restrictions. Critical for crane operations and vessel stability.',
    `is_reefer` BOOLEAN COMMENT 'Boolean flag indicating whether the container is a refrigerated (reefer) unit requiring temperature control and power supply. True for reefer containers, False for dry containers.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent physical inspection of the container for structural integrity, condition grading, and safety compliance. Used to schedule periodic inspections and maintenance.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this container record was last updated in the terminal operating system. Used for change tracking and data synchronization.',
    `length_ft` DECIMAL(18,2) COMMENT 'Physical length of the container in feet. Standard values: 20, 40, 45 feet.',
    `manufacture_date` DATE COMMENT 'Date when the container was manufactured. Used to determine container age, depreciation, and remaining service life.',
    `max_gross_weight_kg` DECIMAL(18,2) COMMENT 'Maximum allowable gross weight (container + cargo) in kilograms as per ISO standards. Typically 30,480 kg for standard containers.',
    `max_payload_kg` DECIMAL(18,2) COMMENT 'Maximum cargo weight capacity in kilograms, calculated as max gross weight minus tare weight. Represents the maximum cargo load the container can safely carry.',
    `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next mandatory container inspection. Ensures compliance with safety regulations and maintenance schedules.',
    `operator_code` STRING COMMENT 'Four-letter code identifying the shipping line or container operator (first 4 characters of container number). Represents the company operating or leasing the container.. Valid values are `^[A-Z]{4}$`',
    `owner_code` STRING COMMENT 'Four-letter code identifying the legal owner of the container. May differ from operator_code if container is leased.. Valid values are `^[A-Z]{4}$`',
    `pod_code` STRING COMMENT 'Five-character UN/LOCODE identifying the port where the container will be discharged from the vessel. Used for cargo routing and delivery planning.. Valid values are `^[A-Z]{5}$`',
    `pol_code` STRING COMMENT 'Five-character UN/LOCODE identifying the port where the container was loaded onto the vessel. Used for cargo tracking and customs documentation.. Valid values are `^[A-Z]{5}$`',
    `reefer_plug_required` BOOLEAN COMMENT 'Boolean flag indicating whether the reefer container requires electrical power connection at the terminal. True if plug-in required, False if not applicable or self-powered.',
    `reefer_set_temp_celsius` DECIMAL(18,2) COMMENT 'Target temperature setting for refrigerated containers in degrees Celsius. Null for non-reefer containers. Critical for maintaining cargo cold chain integrity.',
    `seal_number` STRING COMMENT 'Unique seal number applied to the container door to ensure cargo security and detect tampering. Critical for customs clearance and cargo integrity verification.',
    `seal_type` STRING COMMENT 'Type of security seal applied: bolt (high security bolt seal), cable (cable seal), electronic (e-seal with tracking), barrier (barrier seal). Determines security level and customs acceptance.. Valid values are `bolt|cable|electronic|barrier`',
    `size_teu` DECIMAL(18,2) COMMENT 'Container size expressed in TEU (Twenty-foot Equivalent Units). Standard values: 1.0 for 20ft, 2.0 for 40ft, 2.25 for 45ft containers. Used for capacity planning and billing calculations.',
    `swl_kg` DECIMAL(18,2) COMMENT 'Safe Working Load in kilograms - the maximum load that can be safely lifted by the containers lifting points. Critical for crane operations and cargo handling safety.',
    `tare_weight_kg` DECIMAL(18,2) COMMENT 'Empty weight of the container in kilograms. Used to calculate net cargo weight and verify VGM (Verified Gross Mass) compliance.',
    `un_number` STRING COMMENT 'Four-digit UN number identifying the specific dangerous substance (e.g., UN1203 for gasoline). Null for non-hazmat containers. Used for regulatory compliance and emergency response.. Valid values are `^UN[0-9]{4}$`',
    `width_ft` DECIMAL(18,2) COMMENT 'Physical width of the container in feet. Standard value: 8 feet.',
    CONSTRAINT pk_container PRIMARY KEY(`container_id`)
) COMMENT 'Master record for each physical container unit handled at the port. Tracks container number (ISO format), container type (20GP, 40GP, 40HC, 45HC, RF, OT, FR, TK), size (TEU/FEU), tare weight, max payload, SWL, current status (full/empty/damaged), seal number, ISO type code, operator/owner line code, last inspection date, condition grade, reefer plug requirement, and hazmat certification. SSOT for container identity and physical attributes within the terminal. Sourced from NAVIS N4 TOS.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` (
    `bill_of_lading_id` BIGINT COMMENT 'Unique identifier for the Bill of Lading record. Primary key.',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: Bills of lading are issued against cargo bookings - critical for commercial documentation traceability, customs clearance workflows, and freight billing. Maritime law requires linking transport docume',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Bill of Lading is the primary commercial document for cargo. Invoices reference B/L for freight charges, documentation fees, and B/L amendment charges. Essential for freight billing and commercial rec',
    `packaging_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.packaging_type. Business justification: BOLs must declare standardized package types for customs declarations, SOLAS VGM compliance, and cargo handling instructions. Linking to packaging_type master enables automated customs validation, dan',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Security incidents involving BOL fraud, document forgery, or suspicious cargo declarations must reference the BOL for customs investigation, law enforcement coordination, and trade compliance enforcem',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to cargo.shipment. Business justification: BOL is the transport contract document for a shipment. Bill_of_lading is the legal document; shipment is the operational cargo record. This links the document to the operational entity. Note: both hav',
    `wharfage_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.wharfage_schedule. Business justification: Wharfage charges apply to cargo covered by each B/L based on commodity type, weight, and cargo classification. Port revenue systems link B/Ls to wharfage schedules for accurate cargo dues calculation ',
    `amendment_count` STRING COMMENT 'The number of amendments or corrections that have been made to this Bill of Lading since original issuance.',
    `bol_number` STRING COMMENT 'The externally-known unique Bill of Lading number issued by the carrier or agent. This is the primary business identifier for the cargo title document.. Valid values are `^[A-Z0-9]{8,20}$`',
    `bol_status` STRING COMMENT 'Current lifecycle status of the BOL document in the cargo handling workflow.. Valid values are `draft|issued|amended|surrendered|released|cancelled`',
    `bol_type` STRING COMMENT 'Classification of the BOL document type indicating the method of release and title transfer mechanism.. Valid values are `original|seaway|express|telex_release|surrendered|electronic`',
    `cargo_description` STRING COMMENT 'Detailed textual description of the cargo being shipped, including commodity type, packaging, and any special characteristics.',
    `consignee_address` STRING COMMENT 'The full postal address of the consignee including street, city, state/province, postal code, and country.',
    `consignee_name` STRING COMMENT 'The full legal name of the consignee (receiver) to whom the cargo is being shipped. This is the party entitled to take delivery of the goods.',
    `container_count` STRING COMMENT 'The total number of shipping containers (TEU/FEU) associated with this Bill of Lading.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this Bill of Lading record was first created in the system.',
    `freight_amount` DECIMAL(18,2) COMMENT 'The total freight charge amount for transporting the cargo under this Bill of Lading.',
    `freight_currency` STRING COMMENT 'The three-letter ISO 4217 currency code in which freight charges are denominated.. Valid values are `^[A-Z]{3}$`',
    `freight_terms` STRING COMMENT 'Indicates whether freight charges are prepaid by the shipper, collect from the consignee, or billed to a third party.. Valid values are `prepaid|collect|third_party`',
    `gross_weight_kg` DECIMAL(18,2) COMMENT 'The total gross weight of the cargo including packaging, measured in kilograms.',
    `hs_code` STRING COMMENT 'The internationally standardized Harmonized System code used to classify the traded cargo for customs and tariff purposes.. Valid values are `^[0-9]{6,10}$`',
    `imdg_class` STRING COMMENT 'The IMDG classification code for dangerous goods (e.g., Class 1 - Explosives, Class 3 - Flammable Liquids), if applicable.',
    `is_dangerous_goods` BOOLEAN COMMENT 'Boolean flag indicating whether the cargo contains dangerous goods requiring special handling under IMDG Code regulations.',
    `issue_date` DATE COMMENT 'The date on which the Bill of Lading was officially issued by the carrier or authorized agent. This is the principal business event timestamp for the BOL.',
    `issuing_agent_name` STRING COMMENT 'The name of the authorized agent or freight forwarder who issued the BOL on behalf of the carrier.',
    `issuing_carrier_code` STRING COMMENT 'The Standard Carrier Alpha Code (SCAC) of the carrier that issued the Bill of Lading.. Valid values are `^[A-Z]{4}$`',
    `issuing_carrier_name` STRING COMMENT 'The full legal name of the carrier or shipping line that issued the Bill of Lading.',
    `last_amendment_date` DATE COMMENT 'The date of the most recent amendment or correction to this Bill of Lading.',
    `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this Bill of Lading record was last modified in the system.',
    `net_weight_kg` DECIMAL(18,2) COMMENT 'The net weight of the cargo excluding packaging, measured in kilograms.',
    `notify_party_address` STRING COMMENT 'The full postal address of the notify party including contact details for cargo arrival notification.',
    `notify_party_name` STRING COMMENT 'The name of the party to be notified upon arrival of the cargo at the destination port. Often the consignee or their agent.',
    `package_count` STRING COMMENT 'The total number of packages, cartons, pallets, or shipping units included in this Bill of Lading.',
    `place_of_delivery` STRING COMMENT 'The final destination location where the cargo will be delivered to the consignee, which may differ from the port of discharge in multimodal transport.',
    `place_of_receipt` STRING COMMENT 'The location where the carrier received the cargo from the shipper, which may differ from the port of loading in multimodal transport.',
    `pod_code` STRING COMMENT 'The UN/LOCODE of the port where the cargo will be discharged from the vessel.. Valid values are `^[A-Z]{5}$`',
    `pod_name` STRING COMMENT 'The full name of the port where the cargo will be discharged from the vessel.',
    `pol_code` STRING COMMENT 'The UN/LOCODE (United Nations Code for Trade and Transport Locations) of the port where the cargo was loaded onto the vessel.. Valid values are `^[A-Z]{5}$`',
    `pol_name` STRING COMMENT 'The full name of the port where the cargo was loaded onto the vessel.',
    `release_status` STRING COMMENT 'Current status of the cargo release process indicating whether the cargo is cleared for delivery to the consignee.. Valid values are `pending|approved|released|held|rejected`',
    `release_type` STRING COMMENT 'The method by which the cargo will be released to the consignee (original BOL surrender, telex release, express release, etc.).. Valid values are `original|telex|express|seaway|electronic`',
    `shipper_address` STRING COMMENT 'The full postal address of the shipper including street, city, state/province, postal code, and country.',
    `shipper_name` STRING COMMENT 'The full legal name of the shipper (consignor) who is sending the cargo. This is the party that delivers the goods to the carrier.',
    `special_instructions` STRING COMMENT 'Free-text field for any special instructions, handling requirements, or notes related to the cargo shipment.',
    `transhipment_port_1` STRING COMMENT 'The first intermediate port where cargo is transferred from one vessel to another during the voyage.',
    `transhipment_port_2` STRING COMMENT 'The second intermediate port where cargo is transferred from one vessel to another during the voyage, if applicable.',
    `un_number` STRING COMMENT 'The four-digit UN number identifying the dangerous goods substance, if applicable.. Valid values are `^UN[0-9]{4}$`',
    `vessel_imo_number` STRING COMMENT 'The unique seven-digit IMO number assigned to the vessel for identification purposes.. Valid values are `^IMO[0-9]{7}$`',
    `vessel_name` STRING COMMENT 'The name of the ocean vessel on which the cargo is being transported.',
    `volume_cbm` DECIMAL(18,2) COMMENT 'The total volume measurement of the cargo in cubic meters (CBM), used for freight calculation and stowage planning.',
    `voyage_number` STRING COMMENT 'The unique identifier for the specific voyage on which the cargo is being transported.. Valid values are `^[A-Z0-9]{3,15}$`',
    CONSTRAINT pk_bill_of_lading PRIMARY KEY(`bill_of_lading_id`)
) COMMENT 'Master record for the Bill of Lading (BOL) document — the primary cargo title and transport contract document. Captures BOL number, BOL type (original/seaway/express/telex release), issue date, issuing carrier/agent, shipper, consignee, notify party, POL, POD, transshipment ports, vessel and voyage reference, cargo description, package count, gross weight, measurement (CBM), freight terms (prepaid/collect), freight charges, special instructions, release status, and amendment history. SSOT for cargo title documentation. Sourced from Port Community System (PCS).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` (
    `manifest_id` BIGINT COMMENT 'Unique identifier for the cargo manifest record. Primary key for the cargo manifest entity.',
    `agent_appointment_id` BIGINT COMMENT 'Reference to the shipping agent, freight forwarder, or customs broker who submitted the manifest on behalf of the vessel operator.',
    `dos_record_id` BIGINT COMMENT 'Foreign key linking to security.dos_record. Business justification: Declaration of Security references cargo operations covered under ship-port interface agreement. Manifest provides detailed cargo information supporting DOS scope definition, enabling verification tha',
    `employee_id` BIGINT COMMENT 'Identifier of the user or system account that created the manifest record. Used for audit and accountability purposes.',
    `shipping_line_id` BIGINT COMMENT 'Reference to the vessel operating carrier or shipping line responsible for the cargo movement.',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to booking.call_booking. Business justification: Cargo manifests are compiled for booked vessel calls - links cargo documentation to vessel call reservations for customs pre-clearance, port planning, and regulatory compliance. Manifests must referen',
    `call_id` BIGINT COMMENT 'Reference to the vessel call for which this manifest was submitted. Links manifest to specific vessel visit.',
    `amendment_reason` STRING COMMENT 'Business justification for manifest amendment. Documents why corrections were required after initial submission.',
    `amendment_version` STRING COMMENT 'Version number tracking manifest amendments. Increments with each correction or update submitted after initial filing. Version 1 represents original submission.',
    `closure_timestamp` TIMESTAMP COMMENT 'Date and time when the manifest was finalized and closed for further amendments. Represents completion of cargo documentation for this vessel call.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the manifest record was first created in the Port Community System (PCS). Audit trail for record creation.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for declared cargo values. Standard format for international trade documentation.. Valid values are `^[A-Z]{3}$`',
    `customs_inspection_required_flag` BOOLEAN COMMENT 'Indicates whether customs authority has flagged this manifest for physical inspection. True if inspection required.',
    `customs_reference_number` STRING COMMENT 'Unique reference number assigned by customs authority upon manifest submission. Used for customs clearance tracking and compliance verification.',
    `customs_submission_status` STRING COMMENT 'Status of the manifest submission to customs authority. Tracks customs clearance workflow from initial submission through final clearance or rejection.. Valid values are `pending|submitted|processing|cleared|hold|rejected`',
    `dangerous_goods_flag` BOOLEAN COMMENT 'Indicates whether the manifest contains any dangerous goods cargo requiring special handling per International Maritime Dangerous Goods (IMDG) Code. True if dangerous goods present.',
    `document_url` STRING COMMENT 'URL or file path to the digitally stored manifest document in the document management system. Provides access to original manifest filing.',
    `empty_container_count` STRING COMMENT 'Number of empty containers listed in the manifest for repositioning or return to depot.',
    `fcl_container_count` STRING COMMENT 'Number of Full Container Load (FCL) shipments in the manifest where a single shipper uses the entire container.',
    `high_value_cargo_flag` BOOLEAN COMMENT 'Indicates whether the manifest contains high-value cargo requiring enhanced security measures and insurance coverage. True if high-value cargo present.',
    `is_active` BOOLEAN COMMENT 'Indicates whether this manifest record is currently active and valid. False if the manifest has been superseded, cancelled, or archived.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the manifest record was last updated or amended. Audit trail for tracking changes throughout manifest lifecycle.',
    `lcl_container_count` STRING COMMENT 'Number of Less than Container Load (LCL) shipments in the manifest where multiple shippers share container space through consolidation.',
    `manifest_number` STRING COMMENT 'Unique business identifier for the cargo manifest as assigned by the submitting agent or Port Community System (PCS). Used for external reference and customs tracking.',
    `manifest_status` STRING COMMENT 'Current lifecycle status of the manifest. Draft: being prepared; Submitted: sent to customs/PCS; Acknowledged: received by authority; Accepted: approved for processing; Rejected: contains errors; Amended: corrections applied; Closed: finalized and archived. [ENUM-REF-CANDIDATE: draft|submitted|acknowledged|accepted|rejected|amended|closed — 7 candidates stripped; promote to reference product]',
    `manifest_type` STRING COMMENT 'Classification of the manifest based on cargo movement direction and trade type. Import: cargo arriving at port of discharge; Export: cargo departing from port of loading; Transshipment: cargo transferred between vessels; Coastal: domestic cargo movement.. Valid values are `import|export|transshipment|coastal`',
    `oversized_cargo_flag` BOOLEAN COMMENT 'Indicates whether the manifest contains out-of-gauge (OOG) or oversized cargo exceeding standard container dimensions. True if oversized cargo present.',
    `pcs_acknowledgement_reference` STRING COMMENT 'Unique reference number issued by the Port Community System (PCS) upon successful receipt of the manifest. Used for tracking and audit purposes.',
    `pod_port_code` STRING COMMENT 'UN/LOCODE five-character code identifying the port where cargo will be discharged from the vessel. Format: 2-letter country code + 3-letter location code.. Valid values are `^[A-Z]{5}$`',
    `pol_port_code` STRING COMMENT 'UN/LOCODE five-character code identifying the port where cargo was originally loaded onto the vessel. Format: 2-letter country code + 3-letter location code.. Valid values are `^[A-Z]{5}$`',
    `quarantine_required_flag` BOOLEAN COMMENT 'Indicates whether cargo in this manifest requires quarantine inspection by biosecurity or agricultural authorities. True if quarantine required.',
    `reefer_cargo_flag` BOOLEAN COMMENT 'Indicates whether the manifest contains refrigerated (reefer) containers requiring temperature-controlled storage and monitoring. True if reefer cargo present.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, special instructions, or clarifications related to the manifest. Used for operational communication.',
    `submission_timestamp` TIMESTAMP COMMENT 'Date and time when the manifest was submitted to the Port Community System (PCS) or customs authority. Critical for compliance with advance manifest submission requirements.',
    `total_bol_count` STRING COMMENT 'Total number of Bill of Lading (BOL) entries included in this manifest. Used for manifest reconciliation and completeness verification.',
    `total_container_count` STRING COMMENT 'Total number of containers (TEU and FEU combined) listed in this manifest. Includes all container types and sizes.',
    `total_declared_value_usd` DECIMAL(18,2) COMMENT 'Total declared customs value of all cargo in the manifest, expressed in United States Dollars (USD). Used for duty calculation and insurance purposes.',
    `total_teu_count` DECIMAL(18,2) COMMENT 'Total cargo volume expressed in Twenty-foot Equivalent Units (TEU). Standard measure for container capacity where one 40-foot container equals 2 TEU.',
    `total_volume_cbm` DECIMAL(18,2) COMMENT 'Total cargo volume measured in cubic meters (CBM). Used for capacity planning and freight calculation.',
    `total_weight_mt` DECIMAL(18,2) COMMENT 'Total gross weight of all cargo listed in the manifest, measured in metric tons (MT). Includes container tare weight and cargo weight.',
    `transhipment_container_count` STRING COMMENT 'Number of containers in the manifest designated for transshipment to another vessel at this port.',
    `voyage_number` STRING COMMENT 'Voyage identifier assigned by the shipping line for this specific vessel journey. Used for cargo tracking and manifest reconciliation.',
    CONSTRAINT pk_manifest PRIMARY KEY(`manifest_id`)
) COMMENT 'Transactional record of the cargo manifest submitted per vessel call, including individual line items representing each BOL or container entry. Captures manifest number, vessel call reference, voyage number, manifest type (import/export/transshipment/coastal), submission date/time, submitting agent, total BOL count, total TEU count, total weight (MT), total CBM, customs submission status, PCS acknowledgement reference, amendment version, and manifest closure timestamp. Line-level detail includes BOL number, container number, cargo description, HS Code, package type/count, gross weight (KG), volume (CBM), shipper, consignee, POL, POD, freight terms, dangerous goods flag, IMDG class, UN number, temperature requirement, and customs declaration status. Enables granular cargo-level manifest reconciliation and customs processing. Mandatory for customs clearance and trade compliance. Sourced from Port Community System (PCS).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` (
    `manifest_line_id` BIGINT COMMENT 'Unique identifier for the manifest line item. Primary key for this entity.',
    `bill_of_lading_id` BIGINT COMMENT 'Foreign key linking to cargo.bill_of_lading. Business justification: Each manifest line represents a BOL entry in the cargo manifest. Bol_number is denormalized and should be retrieved via FK to bill_of_lading master record. This is a core relationship - manifest line ',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Manifest lines declare commodity codes (HS codes) for customs classification and duty calculation. Real regulatory requirement: WCO FAL Convention, customs tariff systems. Port community systems valid',
    `container_id` BIGINT COMMENT 'Foreign key linking to cargo.container. Business justification: Manifest line specifies container details for the cargo. Container_number is denormalized and should be retrieved via FK. This links manifest line to the physical container unit.',
    `manifest_id` BIGINT COMMENT 'Reference to the parent cargo manifest document. Links this line item to the header manifest record.',
    `packaging_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.packaging_type. Business justification: Manifest lines declare package types for line-level customs validation and tariff classification. Linking to packaging_type master enables automated HS code validation, dangerous goods packaging compl',
    `cargo_description` STRING COMMENT 'Detailed textual description of the cargo contents. Includes commodity type, packaging details, and any special characteristics.',
    `cargo_value_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the declared cargo value. Supports multi-currency cargo valuation.. Valid values are `^[A-Z]{3}$`',
    `cargo_value_usd` DECIMAL(18,2) COMMENT 'Declared commercial value of the cargo in US dollars. Used for insurance, customs valuation, and liability calculations.',
    `confirmed_timestamp` TIMESTAMP COMMENT 'Timestamp when this manifest line was confirmed and locked for vessel loading operations.',
    `consignee_address` STRING COMMENT 'Full postal address of the consignee. Delivery destination for the cargo.',
    `consignee_name` STRING COMMENT 'Legal name of the cargo consignee or receiver. Party to whom the goods are being shipped.',
    `container_size_type` STRING COMMENT 'ISO container size and type code. Indicates container dimensions and configuration (e.g., 20GP = 20-foot general purpose, 40HC = 40-foot high cube).. Valid values are `20GP|40GP|40HC|45HC|20RF|40RF`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this manifest line record was first created in the system. Audit trail for data lineage.',
    `customs_declaration_number` STRING COMMENT 'Official customs declaration reference number assigned by customs authority. Used for tracking customs processing and clearance.',
    `customs_declaration_status` STRING COMMENT 'Current status of customs clearance processing for this manifest line. Tracks progression through customs workflow.. Valid values are `pending|submitted|cleared|held|rejected`',
    `delivery_order_number` STRING COMMENT 'Delivery order reference number authorizing cargo release to consignee. Required for cargo pickup from terminal.',
    `freight_terms` STRING COMMENT 'Payment terms for freight charges. Indicates whether freight is prepaid by shipper, collect from consignee, or billed to third party.. Valid values are `prepaid|collect|third_party`',
    `gross_weight_kg` DECIMAL(18,2) COMMENT 'Total gross weight of the cargo including packaging in kilograms. Critical for vessel stability calculations and load planning.',
    `imdg_class` STRING COMMENT 'IMDG classification code for dangerous goods. Identifies the hazard class and division (e.g., 3 for flammable liquids, 8 for corrosives).. Valid values are `^[1-9](.[1-6])?$`',
    `is_dangerous_goods` BOOLEAN COMMENT 'Boolean flag indicating whether this cargo contains dangerous goods requiring special handling per IMDG Code.',
    `is_hazmat` BOOLEAN COMMENT 'Boolean flag indicating whether cargo is classified as hazardous material requiring special permits and handling.',
    `is_oversized` BOOLEAN COMMENT 'Boolean flag indicating whether cargo exceeds standard container dimensions and requires special handling equipment.',
    `is_reefer` BOOLEAN COMMENT 'Boolean flag indicating whether this is refrigerated cargo requiring temperature-controlled container.',
    `line_sequence_number` STRING COMMENT 'Sequential ordering of this line item within the parent manifest. Used for display and processing order.',
    `load_status` STRING COMMENT 'Cargo load type classification. FCL = Full Container Load, LCL = Less than Container Load, breakbulk = non-containerized, RoRo = Roll-on Roll-off.. Valid values are `fcl|lcl|breakbulk|roro`',
    `manifest_line_status` STRING COMMENT 'Current lifecycle status of this manifest line item. Tracks progression from planning through delivery.. Valid values are `draft|confirmed|loaded|discharged|delivered|cancelled`',
    `marks_and_numbers` STRING COMMENT 'Shipping marks, labels, and identification numbers on cargo packages. Used for cargo identification and handling instructions.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this manifest line record was last modified. Tracks most recent update for change management.',
    `package_count` STRING COMMENT 'Total number of packages or units within this manifest line item. Used for cargo reconciliation and tally verification.',
    `pod_code` STRING COMMENT 'UN/LOCODE five-character code identifying the port where cargo will be discharged from the vessel.. Valid values are `^[A-Z]{5}$`',
    `pol_code` STRING COMMENT 'UN/LOCODE five-character code identifying the port where cargo was loaded onto the vessel.. Valid values are `^[A-Z]{5}$`',
    `seal_number` STRING COMMENT 'Security seal number applied to the container. Used for tamper detection and cargo security verification.',
    `shipper_address` STRING COMMENT 'Full postal address of the shipper. Required for customs documentation and cargo tracing.',
    `shipper_name` STRING COMMENT 'Legal name of the cargo shipper or consignor. Party responsible for sending the goods.',
    `special_handling_instructions` STRING COMMENT 'Free-text field for special cargo handling requirements, stowage instructions, or operational notes.',
    `stowage_position` STRING COMMENT 'Bay-Row-Tier stowage location code on vessel. Seven-digit code indicating precise container position in vessel hold or on deck.. Valid values are `^[0-9]{3}[0-9]{2}[0-9]{2}$`',
    `temperature_requirement_celsius` DECIMAL(18,2) COMMENT 'Required storage temperature in degrees Celsius for refrigerated (reefer) cargo. Null for non-temperature-controlled cargo.',
    `teu_equivalent` DECIMAL(18,2) COMMENT 'TEU equivalent value for this manifest line. Standard measure for container capacity (20-foot = 1.0 TEU, 40-foot = 2.0 TEU).',
    `un_number` STRING COMMENT 'Four-digit UN identification number for dangerous goods. Standardized code used globally for hazardous material identification.. Valid values are `^UN[0-9]{4}$`',
    `volume_cbm` DECIMAL(18,2) COMMENT 'Total volume of the cargo in cubic meters. Used for space allocation and yard planning.',
    CONSTRAINT pk_manifest_line PRIMARY KEY(`manifest_line_id`)
) COMMENT 'Individual line item within a cargo manifest, representing one BOL or container entry. Captures manifest reference, line sequence number, BOL number, container number, cargo description, HS Code, package type and count, gross weight (KG), volume (CBM), shipper, consignee, POL, POD, freight terms, dangerous goods flag, IMDG class, UN number, temperature requirement (reefer), and customs declaration status. Enables granular cargo-level manifest reconciliation and customs processing.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` (
    `handling_order_id` BIGINT COMMENT 'Primary key for handling_order',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Handling orders (load/discharge operations) execute under terminal service agreements specifying productivity targets, equipment allocation, and handling rates. Critical for performance measurement, b',
    `berth_id` BIGINT COMMENT 'Reference to the berth where the handling operation will take place. Identifies the specific quay position allocated for this vessel call.',
    `violation_id` BIGINT COMMENT 'Foreign key linking to compliance.violation. Business justification: Handling operations may result in compliance violations (improper hazmat handling, MARPOL breaches, safety violations). Real business process: incident investigation, corrective action tracking, penal',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Stevedoring operations are cost center activities in port operations. Terminal operators track handling labor, equipment, and overhead costs by cost center for operational budgeting, variance analysis',
    `dos_record_id` BIGINT COMMENT 'Foreign key linking to security.dos_record. Business justification: DOS covers specific cargo operations at ship-port interface; handling orders detail those operations. Links operational execution to DOS agreement, enabling verification that security measures agreed ',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Capital projects (berth rehabilitation, crane installations) and maintenance campaigns are tracked as internal orders. Handling operations consuming project resources need direct attribution for proje',
    `permit_to_work_id` BIGINT COMMENT 'Foreign key linking to safety.permit_to_work. Business justification: Hot work on vessels during cargo operations, confined space entry for hold inspection, hazardous cargo handling, and heavy lift operations require permit-to-work authorization integrated with cargo ha',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Security incidents during cargo operations (theft during loading/discharge, unauthorized access to operational areas, sabotage) must reference the handling order for operational investigation, stevedo',
    `gang_id` BIGINT COMMENT 'Reference to the stevedore gang (labor crew) assigned to execute this handling order. Links to workforce management for labor cost allocation and productivity tracking.',
    `stowage_plan_id` BIGINT COMMENT 'Foreign key linking to cargo.cargo_stowage_plan. Business justification: Handling order executes the vessel stowage plan. Bay_plan_reference is a denormalized reference that should be replaced with FK to cargo_stowage_plan. This links operational execution to the planning ',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Load/discharge operations require documented shift supervisor for operational accountability, safety incident response, customs queries, and shift handover beyond gang-level assignment. Maritime termi',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Handling operations occur within specific terminal zones for container stacking/retrieval; required for operational planning, resource allocation, and productivity tracking. Complements berth_id which',
    `thc_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.thc_schedule. Business justification: Load/discharge operations are billed using Terminal Handling Charge schedules based on container size, type, and movement category. Stevedoring billing requires this link to apply correct THC rates to',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to booking.call_booking. Business justification: Load/discharge operations execute against booked vessel calls - operational planning requires linking handling orders to call bookings for resource allocation, berth scheduling, and service order fulf',
    `call_id` BIGINT COMMENT 'Reference to the vessel call for which this handling order is issued. Links the handling operation to a specific vessel visit.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Load/discharge operations vary significantly by vessel type (container vs bulk vs RoRo require different equipment, gang sizes, productivity targets). Linking enables automated equipment allocation ru',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: Major infrastructure projects (terminal expansion, automation initiatives) use WBS structures. Handling operations during project commissioning or pilot phases require direct cost capture to specific ',
    `actual_end_datetime` TIMESTAMP COMMENT 'Actual date and time when the handling operation completed. Captured when final container move finishes. Used for vessel turnaround KPI calculation and demurrage assessment.',
    `actual_start_datetime` TIMESTAMP COMMENT 'Actual date and time when the handling operation commenced. Captured when first container move begins. Used for performance measurement and billing.',
    `billing_status` STRING COMMENT 'Current billing status for this handling order: pending (charges not yet calculated), calculated (charges computed but not invoiced), invoiced (invoice issued), or paid (payment received).. Valid values are `pending|calculated|invoiced|paid`',
    `crane_allocation` STRING COMMENT 'Comma-separated list of crane identifiers allocated to this handling order. May include STS (Ship-to-Shore), MHC (Mobile Harbour Crane), or QC (Quay Crane) equipment codes.',
    `created_by_user` STRING COMMENT 'Username or identifier of the system user who created this handling order record. Used for audit trail and accountability.',
    `created_datetime` TIMESTAMP COMMENT 'Timestamp when this handling order record was first created in the system. Used for audit trail and operational analytics.',
    `customs_hold_flag` BOOLEAN COMMENT 'Boolean indicator whether any cargo in this handling order is subject to customs hold or inspection requirements. True if customs clearance is pending for any containers.',
    `dangerous_goods_flag` BOOLEAN COMMENT 'Boolean indicator whether this handling order includes dangerous goods cargo requiring IMDG (International Maritime Dangerous Goods) Code compliance. True if any IMDG cargo is included.',
    `equipment_delay_minutes` STRING COMMENT 'Total minutes of delay attributed to equipment breakdown or malfunction during the execution of this handling order. Used for maintenance planning and performance analysis.',
    `gross_crane_productivity_target` DECIMAL(18,2) COMMENT 'Target gross crane productivity for this handling order expressed as moves per hour. Gross productivity includes all operational time from first to last move. Used for SLA monitoring.',
    `hatch_cover_moves` STRING COMMENT 'Number of hatch cover handling operations required for this order. Hatch covers must be removed before accessing cargo holds and replaced after loading/discharge. Impacts handling time and cost.',
    `modified_by_user` STRING COMMENT 'Username or identifier of the system user who last modified this handling order record. Used for audit trail and change tracking.',
    `modified_datetime` TIMESTAMP COMMENT 'Timestamp when this handling order record was last modified. Updated whenever any attribute changes. Used for audit trail and data synchronization.',
    `operation_type` STRING COMMENT 'Type of cargo handling operation to be performed: load (loading cargo onto vessel), discharge (unloading cargo from vessel), transship (transfer between vessels), restow (repositioning cargo on same vessel), or shift (moving cargo within terminal).. Valid values are `load|discharge|transship|restow|shift`',
    `operational_notes` STRING COMMENT 'Free-text field for operational instructions, special handling requirements, safety alerts, or other contextual information relevant to the execution of this handling order.',
    `order_number` STRING COMMENT 'Business identifier for the handling order, typically a human-readable sequence number or code used in operational communications and TOS systems.',
    `order_status` STRING COMMENT 'Current lifecycle status of the handling order: planned (created but not yet released), released (authorized for execution), in_progress (actively being worked), suspended (temporarily halted), completed (all moves finished), or cancelled (order voided).. Valid values are `planned|released|in_progress|suspended|completed|cancelled`',
    `oversized_cargo_flag` BOOLEAN COMMENT 'Boolean indicator whether this handling order includes oversized or out-of-gauge cargo requiring special handling equipment or procedures. True if any oversized units are included.',
    `planned_end_datetime` TIMESTAMP COMMENT 'Scheduled date and time when the handling operation is planned to complete. Used for ETD (Estimated Time of Departure) calculation and berth planning.',
    `planned_start_datetime` TIMESTAMP COMMENT 'Scheduled date and time when the handling operation is planned to commence. Used for resource planning and vessel turnaround estimation.',
    `port_state_control_inspection_flag` BOOLEAN COMMENT 'Boolean indicator whether this handling order is subject to Port State Control inspection requirements. True if PSC inspection is scheduled or in progress.',
    `priority_sequence` STRING COMMENT 'Numeric priority ranking for this handling order relative to other orders for the same vessel call. Lower numbers indicate higher priority. Used for operational sequencing and resource allocation.',
    `reefer_cargo_flag` BOOLEAN COMMENT 'Boolean indicator whether this handling order includes refrigerated containers requiring temperature-controlled handling and monitoring. True if any reefer units are included.',
    `restow_moves` STRING COMMENT 'Number of restow operations (repositioning containers on the same vessel) included in this handling order. Restows are required to access cargo or optimize vessel stability.',
    `shift_moves` STRING COMMENT 'Number of shift operations (moving containers within the terminal yard) associated with this handling order. Shifts may be required for yard optimization or pre-positioning cargo.',
    `shift_reference` STRING COMMENT 'Identifier for the operational shift during which this handling order is scheduled or executed. Used for labor cost allocation and shift performance analysis.',
    `terminal_delay_minutes` STRING COMMENT 'Total minutes of delay attributed to terminal-side operational issues (labor shortage, yard congestion, gate delays) during the execution of this handling order. Used for internal performance analysis.',
    `thc_applicable_flag` BOOLEAN COMMENT 'Boolean indicator whether Terminal Handling Charges are applicable to this handling order. True if THC should be assessed per tariff schedule.',
    `total_moves_completed` STRING COMMENT 'Actual number of container moves completed for this handling order. Updated in real-time as operations progress. Used for progress tracking and performance measurement.',
    `total_moves_planned` STRING COMMENT 'Total number of container moves (lifts) planned for this handling order. Each TEU or FEU movement counts as one move. Used for productivity planning and resource allocation.',
    `total_teu_completed` DECIMAL(18,2) COMMENT 'Actual container volume completed for this handling order expressed in TEU. Updated as operations progress. Used for performance tracking and billing.',
    `total_teu_planned` DECIMAL(18,2) COMMENT 'Total container volume planned for this handling order expressed in TEU (Twenty-foot Equivalent Units). FEU containers count as 2 TEU. Used for capacity planning and productivity measurement.',
    `vessel_delay_minutes` STRING COMMENT 'Total minutes of delay attributed to vessel-side issues (crew availability, hatch cover problems, vessel equipment failure) during the execution of this handling order. Used for dispute resolution.',
    `weather_delay_minutes` STRING COMMENT 'Total minutes of delay attributed to adverse weather conditions during the execution of this handling order. Used for performance analysis and demurrage dispute resolution.',
    CONSTRAINT pk_handling_order PRIMARY KEY(`handling_order_id`)
) COMMENT 'Operational instruction record authorizing and directing the loading or discharge of cargo/containers for a specific vessel call. Captures order number, vessel call reference, operation type (load/discharge/transship/restow), berth assignment, planned and actual start/end datetimes, stevedore gang assignment, crane allocation (STS/MHC/QC), total moves planned vs completed, shift reference, order status (planned/in-progress/completed/cancelled), priority sequencing, and operational notes. Core transactional entity driving cargo handling execution and vessel turnaround performance. Sourced from NAVIS N4 and TOPS Expert TOS.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`move` (
    `move_id` BIGINT COMMENT 'Unique identifier for each individual cargo or container handling move transaction. Primary key for the cargo move record.',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Asset performance reporting requires linking cargo moves to specific port assets (cranes, RTGs, reach stackers) for utilization analysis, MTBF/MTTR calculation, maintenance correlation, and cost alloc',
    `violation_id` BIGINT COMMENT 'Foreign key linking to compliance.violation. Business justification: Individual cargo moves may trigger violations (dropped container causing damage, improper hazmat handling, unauthorized access). Real business process: operational incident tracking, safety audits, li',
    `container_id` BIGINT COMMENT 'Foreign key linking to cargo.container. Business justification: Each cargo move is for a specific container. Container_number is denormalized and should be retrieved via FK to container master record. This is a core operational relationship - every move must refer',
    `employee_id` BIGINT COMMENT 'Reference to the equipment operator or stevedore who executed the move. Links to workforce management for productivity tracking.',
    `equipment_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.equipment_type. Business justification: Cargo moves must validate equipment capability against cargo requirements (SWL, lift height, reefer plug availability). Linking to equipment_type master enables automated move validation, equipment pr',
    `gang_id` BIGINT COMMENT 'Reference to the stevedore gang or work crew assigned to this move. Used for gang productivity analysis and labor costing.',
    `handling_order_id` BIGINT COMMENT 'Foreign key linking to cargo.handling_order. Business justification: Individual cargo moves are executed as part of a handling order (load/discharge instruction). Handling_order is the operational work order; cargo_move is the atomic execution record. This is a clear p',
    `item_id` BIGINT COMMENT 'Foreign key linking to tariff.tariff_item. Business justification: Individual cargo moves (crane lifts, gate moves, yard shifts) generate billable charges mapped to specific tariff line items. Terminal operating systems use this link for granular activity-based billi',
    `ohs_incident_id` BIGINT COMMENT 'Foreign key linking to safety.ohs_incident. Business justification: Individual cargo moves are the atomic unit of risk exposure in terminal operations; incidents must reference the specific move for equipment operator safety records, move-type risk profiling (load/dis',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Cargo moves have origin zones (yard, CFS, gate); essential for move tracking, equipment routing, and operational analytics. Origin_location_code is unstructured; zone FK enables proper operational rep',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Cargo moves originating from warehouses (LCL destuffing, bonded release) are fundamental port operations; required for warehouse inventory reconciliation, billing, and operational tracking of CFS acti',
    `permit_to_work_id` BIGINT COMMENT 'Foreign key linking to safety.permit_to_work. Business justification: Specific high-risk moves (oversized cargo requiring road closures, heavy lifts exceeding SWL, hazmat transfers, reefer plug operations in confined spaces) require individual permit-to-work authorizati',
    `call_id` BIGINT COMMENT 'Reference to the vessel visit during which this cargo move occurred. Links move to specific vessel call.',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: Gate-in and gate-out cargo moves are fundamental port operations; required for gate transaction reconciliation, truck turnaround time analysis, and RFID/OCR system integration. Critical for landside o',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Individual cargo move security incidents (equipment tampering, unauthorized move execution, damage during handling) require direct linkage for operator accountability, equipment security review, and m',
    `shift_pattern_id` BIGINT COMMENT 'Reference to the operational shift during which the move was executed. Used for shift productivity reporting and labor allocation.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to cargo.shipment. Business justification: Cargo move is part of handling a shipment. Booking_reference and bill_of_lading_number are shipment attributes that should be retrieved via FK. This links operational moves to the commercial shipment ',
    `terminal_equipment_id` BIGINT COMMENT 'Reference to the specific equipment unit that performed the move. Links to asset register for equipment tracking and utilization.',
    `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time when the move operation was completed. Used to calculate move duration and equipment productivity.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when the move operation commenced. Captured from TOS or equipment automation system.',
    `cargo_weight_kg` DECIMAL(18,2) COMMENT 'Verified gross mass of the container and cargo in kilograms. Required under SOLAS VGM regulations for loaded containers.',
    `container_size_teu` DECIMAL(18,2) COMMENT 'Container size expressed in TEU. Standard 20ft = 1.0 TEU, 40ft = 2.0 TEU, 45ft = 2.25 TEU. Used for productivity normalization.',
    `container_type_iso` STRING COMMENT 'ISO 6346 4-character container type code indicating size and type (e.g., 22G1 for 20ft general purpose, 45R1 for 40ft high cube reefer).. Valid values are `^[A-Z0-9]{4}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this cargo move record was first created in the system. Audit trail for data lineage.',
    `customs_status` STRING COMMENT 'Current customs clearance status of the cargo. Indicates whether cargo has been released by customs authorities for movement.. Valid values are `cleared|pending|held|inspected|released|bonded`',
    `damage_reported` BOOLEAN COMMENT 'Boolean flag indicating whether container or cargo damage was reported during this move. Triggers damage assessment workflow.',
    `delivery_order_number` STRING COMMENT 'Delivery order reference number authorizing release of cargo to consignee. Required for gate-out operations.',
    `destination_location_code` STRING COMMENT 'Specific location code where the container was placed. May be berth number, yard block-bay-row-tier, gate lane, or rail track identifier.',
    `destination_location_type` STRING COMMENT 'Classification of the destination facility where the move ended. Defines the target context for the move.. Valid values are `vessel|yard|gate|rail|cfs|buffer`',
    `destination_position` STRING COMMENT 'Detailed position coordinates at destination. For vessel: bay-row-tier from BAPLIE. For yard: block-bay-row-tier. For gate: lane number.',
    `duration_minutes` DECIMAL(18,2) COMMENT 'Total elapsed time in minutes from move start to completion. Key metric for crane productivity (Moves Per Hour) and operational efficiency analysis.',
    `equipment_type` STRING COMMENT 'Type of handling equipment used to execute the move. Identifies the machinery class performing the operation. [ENUM-REF-CANDIDATE: quay_crane|rtg|reach_stacker|forklift|straddle_carrier|agv|mobile_harbour_crane|empty_handler — 8 candidates stripped; promote to reference product]',
    `exception_code` STRING COMMENT 'Code identifying any exception or deviation that occurred during the move (e.g., damage, delay, equipment failure). Null for normal moves.',
    `exception_description` STRING COMMENT 'Detailed description of any exception or issue encountered during the move execution. Free text field for operational notes.',
    `imdg_class` STRING COMMENT 'IMDG hazard classification for dangerous goods (e.g., Class 1 Explosives, Class 3 Flammable Liquids). Null for non-hazardous cargo.',
    `is_hazardous` BOOLEAN COMMENT 'Boolean flag indicating whether the cargo is classified as dangerous goods under IMDG Code. True if hazardous, false otherwise.',
    `is_oversize` BOOLEAN COMMENT 'Boolean flag indicating whether the cargo exceeds standard container dimensions (out-of-gauge). Requires special handling procedures.',
    `is_reefer` BOOLEAN COMMENT 'Boolean flag indicating whether the container is a refrigerated (reefer) unit requiring temperature control and power connection.',
    `kind` STRING COMMENT 'Classification indicating whether container is full or empty and the business purpose of the move. Distinguishes Full Container Load (FCL) from empty repositioning.. Valid values are `full|empty|tranship|restow|shifting`',
    `move_status` STRING COMMENT 'Current lifecycle status of the cargo move. Tracks progression from planning through execution to completion. [ENUM-REF-CANDIDATE: planned|dispatched|in_progress|completed|cancelled|failed|on_hold — 7 candidates stripped; promote to reference product]',
    `move_type` STRING COMMENT 'Classification of the cargo handling move operation. Defines the nature of the container movement within terminal operations. [ENUM-REF-CANDIDATE: discharge|load|shift|restow|yard_move|gate_in|gate_out|rail_in|rail_out|empty_pickup|empty_return — 11 candidates stripped; promote to reference product]',
    `origin_location_code` STRING COMMENT 'Specific location code where the container was picked up. May be berth number, yard block-bay-row-tier, gate lane, or rail track identifier.',
    `origin_location_type` STRING COMMENT 'Classification of the origin facility where the move started. Defines the source context for the move.. Valid values are `vessel|yard|gate|rail|cfs|buffer`',
    `origin_position` STRING COMMENT 'Detailed position coordinates at origin. For vessel: bay-row-tier from BAPLIE. For yard: block-bay-row-tier. For gate: lane number.',
    `planned_start_timestamp` TIMESTAMP COMMENT 'Scheduled date and time when the move was planned to begin. Used for operational planning and schedule adherence measurement.',
    `port_of_discharge` STRING COMMENT 'UN/LOCODE 5-character code for the port where the cargo is to be discharged from the vessel. Final destination port.. Valid values are `^[A-Z]{5}$`',
    `port_of_loading` STRING COMMENT 'UN/LOCODE 5-character code for the port where the cargo was originally loaded onto the vessel. Origin port in the shipping journey.. Valid values are `^[A-Z]{5}$`',
    `reefer_temperature_celsius` DECIMAL(18,2) COMMENT 'Required temperature setting in degrees Celsius for refrigerated containers. Null for non-reefer containers.',
    `seal_number` STRING COMMENT 'Security seal number affixed to the container. Used for cargo security verification and tamper detection.',
    `stage` STRING COMMENT 'Specific stage or leg of the move indicating origin and destination facility types. Defines the operational context of the move. [ENUM-REF-CANDIDATE: vessel_to_yard|yard_to_vessel|yard_to_yard|yard_to_gate|gate_to_yard|vessel_to_vessel|rail_to_yard|yard_to_rail — 8 candidates stripped; promote to reference product]',
    `transhipment_port` STRING COMMENT 'UN/LOCODE for intermediate transhipment port if cargo is being transferred between vessels. Null for direct shipments.. Valid values are `^[A-Z]{5}$`',
    `un_number` STRING COMMENT 'Four-digit UN number identifying the dangerous goods substance (e.g., UN1203 for gasoline). Required for IMDG compliance.. Valid values are `^UN[0-9]{4}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this cargo move record was last modified. Tracks data currency for operational reporting.',
    CONSTRAINT pk_move PRIMARY KEY(`move_id`)
) COMMENT 'Atomic transactional record of each individual container or cargo handling move executed at the terminal — the fundamental unit of terminal productivity measurement. Captures container/cargo reference, move type (discharge/load/shift/restow/yard-move/gate-in/gate-out), equipment used, origin and destination positions, planned vs actual timestamps, duration, operator, and exception details. Feeds crane productivity (MPH), vessel turnaround, and stevedore gang performance KPIs. Sourced from NAVIS N4 and TOPS Expert TOS.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` (
    `stowage_plan_id` BIGINT COMMENT 'Unique identifier for the cargo stowage plan record. Primary key for the vessel stowage plan associated with a specific vessel call.',
    `employee_id` BIGINT COMMENT 'Identifier of the supervisor or operations manager who approved the stowage plan. Ensures accountability in the approval workflow.',
    `primary_stowage_employee_id` BIGINT COMMENT 'Identifier of the vessel planner or stowage coordinator responsible for creating this plan. Links to workforce management system.',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Stowage plan tampering, unauthorized modifications, or cyber-attacks on planning systems are security incidents requiring investigation. Links plan integrity breaches to security response, supporting ',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to booking.call_booking. Business justification: Stowage plans are prepared for booked vessel calls - planning artifact must reference call booking for capacity validation, service requirement verification, and operational coordination between booki',
    `call_id` BIGINT COMMENT 'Reference to the vessel call for which this stowage plan is created. Links the stowage plan to a specific vessel visit.',
    `vessel_id` BIGINT COMMENT 'FK to vessel.vessel',
    `baplie_message_reference` STRING COMMENT 'Unique reference number for the BAPLIE EDI message transmitted for this stowage plan. BAPLIE is the standard EDI message format for vessel stowage plans in maritime logistics.',
    `created_datetime` TIMESTAMP COMMENT 'Date and time when this stowage plan record was first created in the system. Audit trail for record lifecycle tracking.',
    `discharge_count` STRING COMMENT 'Total number of containers to be discharged at this port according to the stowage plan. Used for berth productivity planning.',
    `empty_container_count` STRING COMMENT 'Number of empty containers included in the stowage plan. Empty containers are repositioned for operational needs and affect weight distribution.',
    `hazmat_container_count` STRING COMMENT 'Total number of containers carrying dangerous goods according to IMDG classification. Used for safety planning and regulatory compliance.',
    `hazmat_segregation_compliant_flag` BOOLEAN COMMENT 'Indicates whether the stowage plan complies with IMDG Code segregation requirements for dangerous goods. True means all hazmat containers are properly segregated according to their class.',
    `is_active` BOOLEAN COMMENT 'Indicates whether this stowage plan is the current active version for the vessel call. False for superseded or cancelled plans.',
    `laden_container_count` STRING COMMENT 'Number of loaded (full) containers in the stowage plan. Represents containers carrying cargo as opposed to empty repositioning units.',
    `last_modified_datetime` TIMESTAMP COMMENT 'Date and time when this stowage plan record was last updated. Tracks the most recent change to any field in the record.',
    `list_value_degrees` DECIMAL(18,2) COMMENT 'Lateral inclination of the vessel from vertical measured in degrees. Indicates port or starboard tilt. Must be within safe limits for vessel operations.',
    `load_count` STRING COMMENT 'Total number of containers to be loaded at this port according to the stowage plan. Used for yard and gate operations planning.',
    `next_port_of_call` STRING COMMENT 'UN/LOCODE five-character code identifying the next port in the vessels voyage after departure from the current port. Used for routing and discharge planning.. Valid values are `^[A-Z]{5}$`',
    `oog_count` STRING COMMENT 'Number of out-of-gauge containers in the stowage plan. OOG containers exceed standard dimensions and require special stowage considerations.',
    `plan_approval_datetime` TIMESTAMP COMMENT 'Date and time when the stowage plan was officially approved for execution. Marks the transition from planning to operational phase.',
    `plan_completion_datetime` TIMESTAMP COMMENT 'Date and time when the actual loading operations according to this plan were completed. Used for operational performance tracking.',
    `plan_remarks` STRING COMMENT 'Free-text field for planner notes, special instructions, or operational considerations related to this stowage plan. Captures context not represented in structured fields.',
    `plan_status` STRING COMMENT 'Current lifecycle status of the stowage plan. Tracks the plan through creation, approval, execution, and completion stages. [ENUM-REF-CANDIDATE: draft|submitted|approved|rejected|in-progress|completed|cancelled — 7 candidates stripped; promote to reference product]',
    `plan_submission_datetime` TIMESTAMP COMMENT 'Date and time when the stowage plan was submitted for approval. Tracks the planning timeline and compliance with submission deadlines.',
    `plan_type` STRING COMMENT 'Classification of the stowage plan stage. Pre-stow is the initial plan, final is the approved plan before operations, actual reflects the completed loading, and revised indicates changes after initial approval.. Valid values are `pre-stow|final|actual|revised`',
    `plan_version` STRING COMMENT 'Version number of the stowage plan. Increments with each revision to track changes and updates to the plan during the planning lifecycle.',
    `port_of_loading` STRING COMMENT 'UN/LOCODE five-character code identifying the port where containers are being loaded according to this plan. Standard international port identifier.. Valid values are `^[A-Z]{5}$`',
    `reefer_plug_capacity` STRING COMMENT 'Total number of refrigerated container electrical connection points available on the vessel. Defines the maximum number of reefer containers that can be powered simultaneously.',
    `reefer_plug_count_used` STRING COMMENT 'Number of refrigerated container electrical connection points (plugs) utilized in this stowage plan. Used to manage vessel power capacity for temperature-controlled cargo.',
    `restow_count` STRING COMMENT 'Number of containers that need to be temporarily moved (restowed) to access containers underneath. Indicates stowage plan efficiency and operational complexity.',
    `shipping_line_code` STRING COMMENT 'Standard Carrier Alpha Code (SCAC) identifying the shipping line operating the vessel. Four-character code used in EDI and documentation.. Valid values are `^[A-Z]{4}$`',
    `stability_calculation_reference` STRING COMMENT 'Reference identifier for the vessel stability calculation document or system record. Links to detailed stability analysis ensuring safe loading conditions.',
    `terminal_operator_code` STRING COMMENT 'Code identifying the terminal operator responsible for executing the stowage plan. Links to the specific terminal handling the vessel.',
    `total_feu_loaded` STRING COMMENT 'Number of forty-foot equivalent containers loaded on the vessel. Complements TEU count for detailed capacity tracking.',
    `total_teu_capacity` STRING COMMENT 'Maximum container capacity of the vessel expressed in TEU. Represents the total number of twenty-foot equivalent containers the vessel can carry.',
    `total_teu_loaded` STRING COMMENT 'Actual number of TEU loaded on the vessel according to this stowage plan. Used to calculate vessel utilization and capacity management.',
    `total_weight_mt` DECIMAL(18,2) COMMENT 'Total weight of all cargo loaded on the vessel in metric tons. Critical for vessel stability calculations and compliance with safe loading limits.',
    `transhipment_container_count` STRING COMMENT 'Number of containers being transhipped through this port (loaded from one vessel to be discharged to another). Important for port operations planning.',
    `trim_value_meters` DECIMAL(18,2) COMMENT 'Difference in draft between the forward and aft of the vessel measured in meters. Positive value indicates stern trim, negative indicates bow trim. Critical for vessel stability and navigation safety.',
    `vessel_imo_number` STRING COMMENT 'Seven-digit unique vessel identifier assigned by the International Maritime Organization. Permanent identifier that remains with the vessel throughout its lifetime.. Valid values are `^IMO[0-9]{7}$`',
    `voyage_number` STRING COMMENT 'The voyage identifier assigned by the shipping line for this vessel call. Used to track the vessels journey across multiple ports.',
    CONSTRAINT pk_stowage_plan PRIMARY KEY(`stowage_plan_id`)
) COMMENT 'Master record for the vessel stowage plan (BAPLIE) associated with a vessel call, including individual container slot assignments (bay/row/tier positions). Captures BAPLIE message reference, vessel call reference, voyage number, plan version, plan type (pre-stow/final/actual), total TEU capacity, total TEU loaded, total weight (MT), stability calculation reference, trim and list values, hazmat segregation compliance flag, reefer plug count used, OOG (out-of-gauge) count, plan submission datetime, planner ID, and approval status. Position-level detail includes container number, ISO position code (bay/row/tier), weight, height, POD, hazmat class, reefer flag, OOG dimensions, temperature/ventilation settings, and position status (planned/confirmed/actual). SSOT for vessel stowage planning data and container slot assignments. Sourced from NAVIS N4 vessel planning module.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` (
    `stowage_position_id` BIGINT COMMENT 'Unique identifier for the cargo stowage position record. Primary key for individual container slot assignments within vessel stowage plans.',
    `bill_of_lading_id` BIGINT COMMENT 'Foreign key linking to cargo.bill_of_lading. Business justification: Stowage position references the BOL for the cargo being stowed. Bol_number is denormalized and should be retrieved via FK. This links stowage planning to the cargo documentation.',
    `container_id` BIGINT COMMENT 'Foreign key linking to cargo.container. Business justification: Stowage position assigns a specific container to a vessel bay/row/tier location. Container_number is denormalized and should be retrieved via FK. This is a core stowage planning relationship.',
    `shipping_line_id` BIGINT COMMENT 'Reference to the shipping line or slot charterer operating this container slot. May differ from vessel operator in slot charter arrangements.',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the shipper (consignor) party responsible for the cargo in this container. Links to customer/participant master data.',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel on which this container is stowed. Links to vessel master data for ship identification.',
    `stowage_plan_id` BIGINT COMMENT 'Reference to the parent vessel stowage plan that contains this position assignment. Links to the overall BAPLIE (Bayplan/Stowage Plan) document.',
    `voyage_id` BIGINT COMMENT 'Reference to the specific voyage during which this stowage position is active. Links to voyage scheduling and routing information.',
    `bay_number` STRING COMMENT 'Longitudinal position identifier on the vessel from bow to stern. Two or three-digit numeric code representing the bay location in the vessels cell structure.. Valid values are `^[0-9]{2,3}$`',
    `booking_reference` STRING COMMENT 'Shipping line booking number or reservation reference associated with this container. Links stowage position to commercial booking and Bill of Lading (BOL).',
    `cargo_type` STRING COMMENT 'Classification of cargo loading: FCL (Full Container Load - single shipper), LCL (Less than Container Load - consolidated), empty (repositioning), special (project cargo, vehicles, etc.).. Valid values are `FCL|LCL|empty|special`',
    `confirmed_timestamp` TIMESTAMP COMMENT 'Date and time when this stowage position assignment was confirmed and approved by the vessel planner. Represents the confirmation event in the position lifecycle.',
    `container_height_mm` STRING COMMENT 'Physical height of the container in millimeters. Standard values include 2591mm (standard), 2896mm (high cube). Used for clearance and stacking calculations.',
    `container_size_type` STRING COMMENT 'ISO 6346 four-character code identifying container size and type. First two characters indicate length and height, last two indicate type and features (e.g., 45G1 for 40ft high cube general purpose).. Valid values are `^[0-9A-Z]{4}$`',
    `container_weight_kg` DECIMAL(18,2) COMMENT 'Verified gross mass of the container including cargo and tare weight, measured in kilograms. Critical for vessel stability calculations and SOLAS VGM compliance.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this stowage position record was first created in the system. Audit trail for data lineage and record lifecycle tracking.',
    `discharged_timestamp` TIMESTAMP COMMENT 'Date and time when the container was physically discharged from this stowage position. Null for containers still on board. Captured from terminal operating system crane operations.',
    `hs_code` STRING COMMENT 'World Customs Organization Harmonized System commodity classification code. Six to ten-digit code used for customs clearance, tariff determination, and trade statistics.. Valid values are `^[0-9]{6,10}$`',
    `imdg_class` STRING COMMENT 'IMDG Code classification for dangerous goods cargo. Values range from 1 to 9 with subdivisions (e.g., 3.1, 8.2). Null for non-hazardous cargo. Critical for segregation and safety compliance.. Valid values are `^[1-9](.[1-6])?$`',
    `iso_position_code` STRING COMMENT 'Six-digit ISO 9711 compliant position code combining bay, row, and tier numbers. Standard format for container slot identification in BAPLIE messages.. Valid values are `^[0-9]{6}$`',
    `lashing_required_flag` BOOLEAN COMMENT 'Boolean indicator whether this container requires special lashing or securing beyond standard cell guides. True for deck cargo, OOG, or heavy containers requiring additional securing.',
    `loaded_timestamp` TIMESTAMP COMMENT 'Date and time when the container was physically loaded into this stowage position on the vessel. Captured from terminal operating system crane operations.',
    `oog_flag` BOOLEAN COMMENT 'Boolean indicator whether this container carries out-of-gauge cargo exceeding standard container dimensions. True for OOG cargo requiring special handling and stowage considerations.',
    `overhang_aft_mm` STRING COMMENT 'Aft overhang dimension in millimeters for out-of-gauge cargo extending beyond the container rear. Null for standard cargo. Used for clearance and lashing calculations.',
    `overhang_fore_mm` STRING COMMENT 'Forward overhang dimension in millimeters for out-of-gauge cargo extending beyond the container front. Null for standard cargo. Used for clearance and lashing calculations.',
    `overhang_height_mm` STRING COMMENT 'Vertical overhang dimension in millimeters for out-of-gauge cargo extending above the container top. Null for standard cargo. Used for clearance and bridge height calculations.',
    `overhang_port_mm` STRING COMMENT 'Port side overhang dimension in millimeters for out-of-gauge cargo extending beyond the container left side. Null for standard cargo. Used for clearance and lashing calculations.',
    `overhang_starboard_mm` STRING COMMENT 'Starboard side overhang dimension in millimeters for out-of-gauge cargo extending beyond the container right side. Null for standard cargo. Used for clearance and lashing calculations.',
    `planned_timestamp` TIMESTAMP COMMENT 'Date and time when this stowage position was initially planned and assigned in the vessel planning system. Represents the planning event in the position lifecycle.',
    `pod_code` STRING COMMENT 'UN/LOCODE five-character code identifying the port where this container will be discharged from the vessel. Critical for discharge sequencing and yard planning.. Valid values are `^[A-Z]{5}$`',
    `pol_code` STRING COMMENT 'UN/LOCODE five-character code identifying the port where this container was loaded onto the vessel. Used for cargo tracking and manifest reconciliation.. Valid values are `^[A-Z]{5}$`',
    `position_status` STRING COMMENT 'Current lifecycle status of the stowage position assignment. Tracks progression from planning through execution: planned (initial assignment), confirmed (verified by planner), loaded (physically loaded), discharged (removed from vessel), restowed (repositioned), cancelled (assignment voided).. Valid values are `planned|confirmed|loaded|discharged|restowed|cancelled`',
    `reefer_flag` BOOLEAN COMMENT 'Boolean indicator whether this container is a refrigerated unit requiring temperature control and power connection. True for reefer containers, False for dry containers.',
    `remarks` STRING COMMENT 'Free-text field for operational notes, special instructions, or exceptions related to this stowage position. May include handling instructions, damage notes, or coordination messages.',
    `row_number` STRING COMMENT 'Transverse position identifier across the vessel from port to starboard. Two-digit numeric code with odd numbers on port side and even numbers on starboard side.. Valid values are `^[0-9]{2}$`',
    `seal_number` STRING COMMENT 'Security seal number affixed to the container door. Used for customs verification and cargo security. Multiple seals may be recorded as comma-separated values.',
    `stowage_category` STRING COMMENT 'General stowage location category on the vessel: deck (above deck), hold (cargo hold), underdeck (below deck), hatch (hatch cover area). Affects cargo protection and accessibility.. Valid values are `deck|hold|underdeck|hatch`',
    `temperature_setting_celsius` DECIMAL(18,2) COMMENT 'Target temperature setting for refrigerated containers in degrees Celsius. Null for non-reefer containers. Range typically -30°C to +30°C for perishable cargo.',
    `tier_number` STRING COMMENT 'Vertical position identifier from keel to deck. Two-digit numeric code representing the tier level in the vessels stacking structure.. Valid values are `^[0-9]{2}$`',
    `transhipment_flag` BOOLEAN COMMENT 'Boolean indicator whether this container is in transit and will be transferred to another vessel at this port. True for transhipment cargo, False for origin/destination cargo.',
    `un_number` STRING COMMENT 'Four-digit UN identification number for dangerous goods (e.g., UN1203 for gasoline). Null for non-hazardous cargo. Used for hazmat documentation and emergency response.. Valid values are `^UN[0-9]{4}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this stowage position record was last modified. Audit trail for change tracking and data quality monitoring.',
    `ventilation_setting_cbm_per_hour` DECIMAL(18,2) COMMENT 'Ventilation airflow rate for reefer containers measured in cubic meters per hour. Null for non-reefer containers. Critical for cargo requiring fresh air exchange.',
    CONSTRAINT pk_stowage_position PRIMARY KEY(`stowage_position_id`)
) COMMENT 'Individual container slot assignment within a vessel stowage plan, representing the planned or actual position of a container on the vessel. Captures stowage plan reference, container number, bay number, row number, tier number, ISO position code, weight (KG), height (MM), port of discharge, hazmat class, reefer flag, OOG dimensions (overhang fore/aft/port/starboard/height), temperature setting, ventilation setting, and position status (planned/confirmed/actual). Enables BAPLIE message generation and vessel stability calculations.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` (
    `dangerous_goods_declaration_id` BIGINT COMMENT 'Unique identifier for the dangerous goods declaration record. Primary key.',
    `bill_of_lading_id` BIGINT COMMENT 'Foreign key linking to cargo.bill_of_lading. Business justification: DGD is submitted for dangerous cargo covered by a specific BOL. Bol_number is denormalized and should be retrieved via FK. This links the hazmat declaration to the cargo title document.',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: DG declarations must reference cargo bookings for approval workflow, segregation planning, and compliance verification. Port authorities require linking hazmat declarations to booking commitments befo',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Hazmat cargo has specific HS code classifications (Chapter 28-38 chemicals, explosives, etc.). Real business need: dual-use goods screening, export controls, customs duty calculation for dangerous goo',
    `container_id` BIGINT COMMENT 'Foreign key linking to cargo.container. Business justification: DGD specifies which container holds the dangerous goods. Container_number is denormalized and should be retrieved via FK. This is critical for stowage planning and segregation compliance.',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Dangerous goods declarations must be linked to customs declarations for regulatory compliance. Real business process: customs authorities require IMDG documentation as part of clearance; port state co',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: IMDG Code requires traceable declarant identity for dangerous goods liability and emergency response. Links declarant_name/company text to participant record for compliance verification, accreditation',
    `emergency_response_plan_id` BIGINT COMMENT 'Foreign key linking to safety.emergency_response_plan. Business justification: Each DG shipment must reference applicable emergency response procedures per IMDG Code Chapter 7 requirements for spill response, fire suppression, evacuation protocols, and EMS/MFAG activation. Port ',
    `hazard_register_id` BIGINT COMMENT 'Foreign key linking to safety.hazard_register. Business justification: DG cargo creates specific IMDG-classified hazards that must be registered in the ports hazard register for regulatory compliance, emergency response planning, segregation management, and terminal ris',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: IMDG Code and port authority regulations require documented inspector identity for dangerous goods declaration verification, acceptance decisions, and safety audit trail. Port state control inspection',
    `packaging_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.packaging_type. Business justification: DG declarations must specify IMDG-compliant packaging with correct packing group for the IMDG class. Linking to packaging_type master enables automated validation of packaging group compatibility, UN ',
    `risk_assessment_id` BIGINT COMMENT 'Foreign key linking to safety.risk_assessment. Business justification: Each DG declaration requires formal risk assessment for stowage position, segregation compliance, handling procedures, and emergency response per IMDG Code and port safety management system. Risk asse',
    `shipment_id` BIGINT COMMENT 'Reference to the parent shipment containing this dangerous goods cargo.',
    `trade_restriction_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_restriction. Business justification: Dangerous goods may be subject to trade restrictions (dual-use goods, chemical weapons precursors, prohibited substances). Real regulatory requirement: export control compliance officers must screen D',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel scheduled to carry this dangerous goods cargo. Used for vessel-level IMDG compliance checks and manifest aggregation.',
    `acceptance_timestamp` TIMESTAMP COMMENT 'Date and time when the port authority officially accepted or rejected the dangerous goods declaration. Used for compliance reporting and gate release.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this dangerous goods declaration record was first created in the Port Community System. Audit trail for compliance.',
    `declarant_email` STRING COMMENT 'Email address of the declarant for official correspondence and declaration queries.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `declaration_date` DATE COMMENT 'Date when the dangerous goods declaration was signed and submitted by the declarant. Critical for compliance audit trail.',
    `declaration_place` STRING COMMENT 'City or location where the dangerous goods declaration was signed and issued.',
    `dgd_number` STRING COMMENT 'Unique externally-known dangerous goods declaration document number issued by the shipper or freight forwarder.',
    `emergency_contact_name` STRING COMMENT 'Name of the person or organization to contact in case of emergency involving this dangerous goods shipment. Required 24/7 availability.',
    `emergency_contact_phone` STRING COMMENT '24-hour emergency telephone number for technical advice on the dangerous goods. Must be monitored at all times during transport.',
    `ems_code` STRING COMMENT 'Emergency response procedures for fires (F-code) and spillage (S-code). Format: F-X,S-Y where X and Y are letters (e.g., F-E,S-D). Guides crew emergency response.. Valid values are `^F-[A-Z],[S-[A-Z]$`',
    `excepted_quantity_flag` BOOLEAN COMMENT 'Indicates whether the dangerous goods are shipped in excepted quantities per IMDG Code Chapter 3.5, allowing maximum packaging and documentation relief. True if excepted quantity, False otherwise.',
    `flash_point_celsius` DECIMAL(18,2) COMMENT 'Lowest temperature at which vapors ignite when exposed to an ignition source, measured in degrees Celsius. Critical for Class 3 flammable liquids.',
    `gross_quantity` DECIMAL(18,2) COMMENT 'Total weight or volume of the dangerous goods including packaging. Used for cargo manifests and capacity planning.',
    `imdg_class` STRING COMMENT 'IMDG hazard classification: 1=Explosives, 2=Gases, 3=Flammable liquids, 4=Flammable solids, 5=Oxidizing substances, 6=Toxic/infectious, 7=Radioactive, 8=Corrosives, 9=Miscellaneous. Includes sub-divisions (e.g., 1.1, 2.1).. Valid values are `1|1.1|1.2|1.3|1.4|1.5|1.6|2.1|2.2|2.3|3|4.1|4.2|4.3|5.1|5.2|6.1|6.2|7|8|9`',
    `imdg_subsidiary_risk` STRING COMMENT 'Secondary hazard class(es) if the substance presents additional risks beyond the primary IMDG class. Pipe-separated if multiple (e.g., 6.1|8).',
    `inspection_completed_timestamp` TIMESTAMP COMMENT 'Date and time when physical inspection of the dangerous goods container was completed by port authority or customs officials.',
    `inspection_required_flag` BOOLEAN COMMENT 'Indicates whether port authority or customs requires physical inspection of the dangerous goods container before acceptance. True if inspection required, False otherwise.',
    `limited_quantity_flag` BOOLEAN COMMENT 'Indicates whether the dangerous goods are shipped in limited quantities per IMDG Code Chapter 3.4, allowing certain packaging and labeling exemptions. True if limited quantity, False otherwise.',
    `marine_pollutant_flag` BOOLEAN COMMENT 'Indicates whether the substance is identified as a marine pollutant under MARPOL Annex III. True if marine pollutant, False otherwise.',
    `mfag_reference` STRING COMMENT 'MFAG table number providing first aid guidance for exposure to this substance. Used by ship medical officers and port emergency responders.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this dangerous goods declaration record was last updated. Tracks amendments and corrections to the declaration.',
    `net_quantity` DECIMAL(18,2) COMMENT 'Net weight or volume of the dangerous goods excluding packaging. Used for segregation and stowage calculations.',
    `number_of_packages` STRING COMMENT 'Total count of individual packages, drums, cylinders, or units containing the dangerous goods within the container or shipment.',
    `packing_group` STRING COMMENT 'Degree of danger: I=High danger, II=Medium danger, III=Low danger. Determines packaging and handling requirements.. Valid values are `I|II|III`',
    `pod_code` STRING COMMENT 'UN/LOCODE 5-character code for the port where the dangerous goods container is discharged from the vessel.. Valid values are `^[A-Z]{5}$`',
    `pol_code` STRING COMMENT 'UN/LOCODE 5-character code for the port where the dangerous goods container is loaded onto the vessel.. Valid values are `^[A-Z]{5}$`',
    `port_authority_acceptance_status` STRING COMMENT 'Current status of port authority review and acceptance of the dangerous goods declaration: pending=awaiting review, accepted=approved for handling, rejected=not compliant, conditional=accepted with restrictions, under_review=in validation process.. Valid values are `pending|accepted|rejected|conditional|under_review`',
    `proper_shipping_name` STRING COMMENT 'Official UN proper shipping name of the dangerous goods as listed in the IMDG Code Dangerous Goods List. Must be used on all transport documents.',
    `quantity_unit` STRING COMMENT 'Unit of measure for net and gross quantities: kg=kilograms, L=liters, m3=cubic meters, tonnes=metric tons.. Valid values are `kg|L|m3|tonnes`',
    `rejection_reason` STRING COMMENT 'Detailed explanation provided by port authority if the dangerous goods declaration was rejected or requires correction. Guides declarant remediation.',
    `segregation_group` STRING COMMENT 'Segregation group code(s) determining stowage separation requirements from incompatible dangerous goods (e.g., acids, alkalis, ammonium compounds). Used for BAPLIE stowage planning.',
    `special_provisions` STRING COMMENT 'Comma-separated list of IMDG special provision codes (e.g., SP23, SP274) that modify standard requirements for packing, stowage, or handling of this specific substance.',
    `stowage_category` STRING COMMENT 'IMDG stowage category defining where cargo may be stowed on vessel: A=On or under deck, B=On deck only, C=Away from living quarters, D=On deck only away from living quarters, E=On deck only in open cargo space.. Valid values are `A|B|C|D|E`',
    `stowage_position` STRING COMMENT 'Actual or planned stowage location on vessel in bay-row-tier format (e.g., 010282 = Bay 01, Row 02, Tier 82). Used in BAPLIE for segregation verification.',
    `technical_name` STRING COMMENT 'Chemical or technical name of the substance, required when the proper shipping name is a generic N.O.S. (Not Otherwise Specified) entry.',
    `un_number` STRING COMMENT 'Four-digit UN number identifying the dangerous substance or article. Format: UN followed by 4 digits (e.g., UN1203 for gasoline).. Valid values are `^UN[0-9]{4}$`',
    `voyage_number` STRING COMMENT 'Voyage or rotation number of the vessel carrying this dangerous goods shipment. Links DGD to specific vessel call.',
    CONSTRAINT pk_dangerous_goods_declaration PRIMARY KEY(`dangerous_goods_declaration_id`)
) COMMENT 'Master record for the Dangerous Goods Declaration (DGD) submitted for IMDG-classified cargo. Captures DGD number, shipment/BOL reference, container number, IMDG class (1–9), UN number, proper shipping name, packing group (I/II/III), flash point, net quantity, gross quantity, emergency contact, segregation group, special provisions, limited quantity flag, marine pollutant flag, EMS code, MFAG reference, declaration date, declarant details, and port authority acceptance status. Mandatory for IMDG compliance and ISPS security. Sourced from PCS.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` (
    `container_preadvice_id` BIGINT COMMENT 'Primary key for container_preadvice',
    `bill_of_lading_id` BIGINT COMMENT 'Foreign key linking to cargo.bill_of_lading. Business justification: COPARN pre-announces container for a specific BOL. Bol_reference is denormalized and should be retrieved via FK. This links the pre-advice message to the cargo documentation.',
    `container_id` BIGINT COMMENT 'Foreign key linking to cargo.container. Business justification: COPARN pre-announces a specific container. Temporal dependency: container may not exist when COPARN is received (pre-advice comes before container registration), so FK will be NULL initially and popul',
    `screening_record_id` BIGINT COMMENT 'Foreign key linking to security.screening_record. Business justification: Pre-advised containers are screened upon arrival against advance information (COPARN). Links pre-advice to actual screening outcome, enabling discrepancy detection, risk-based screening workflows, and',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to cargo.shipment. Business justification: COPARN is submitted for a specific shipment booking. Booking_reference is denormalized and should be retrieved via FK to shipment. This links the pre-advice message to the commercial shipment record.',
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: COPARN pre-advice messages must reference specific vessel calls for terminal planning and container matching. Terminal operators validate expected arrivals against actual vessel schedules. Removes den',
    `vessel_master_id` BIGINT COMMENT 'add column vessel_master_id (BIGINT) with FK to masterdata.vessel_master.vessel_master_id - container preadvice must identify the intended vessel for loading',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: COPARN messages enable terminals to prepare for container arrival based on expected vessel type. Linking enables automated validation of container-vessel compatibility, appropriate handling equipment ',
    `cargo_status` STRING COMMENT 'Indicates whether the container is full (laden with cargo) or empty (unladen) for this movement.. Valid values are `full|empty|laden|unladen`',
    `container_iso_type_code` STRING COMMENT 'Four-character ISO 6346 code specifying the container size and type (e.g., 22G1 for 20ft general purpose, 45G1 for 40ft high cube).. Valid values are `^[A-Z0-9]{4}$`',
    `container_size_feet` STRING COMMENT 'Length of the container in feet, typically 20, 40, or 45 feet.',
    `container_type_description` STRING COMMENT 'Human-readable description of the container type (e.g., General Purpose, High Cube, Refrigerated, Open Top, Flat Rack, Tank).',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this COPARN record was first created in the lakehouse silver layer.',
    `customs_status` STRING COMMENT 'Current customs clearance status of the container cargo.. Valid values are `cleared|pending|hold|inspection_required|released`',
    `dangerous_goods_flag` BOOLEAN COMMENT 'Indicates whether the container contains dangerous goods requiring special handling per IMDG Code.',
    `expected_arrival_datetime` TIMESTAMP COMMENT 'Expected date and time when the container will arrive at the terminal gate or berth for the announced operation.',
    `expected_arrival_window_end` TIMESTAMP COMMENT 'End of the time window during which the container is expected to arrive at the terminal.',
    `expected_arrival_window_start` TIMESTAMP COMMENT 'Start of the time window during which the container is expected to arrive at the terminal.',
    `final_destination_code` STRING COMMENT 'Five-character UN/LOCODE of the final destination for this container shipment.. Valid values are `^[A-Z]{5}$`',
    `gross_weight_kg` DECIMAL(18,2) COMMENT 'Total gross weight of the container including cargo and tare weight, measured in kilograms.',
    `imdg_class` STRING COMMENT 'IMDG classification code for dangerous goods contained in this container (e.g., Class 3 - Flammable Liquids).',
    `message_datetime` TIMESTAMP COMMENT 'Date and time when the COPARN message was created and transmitted by the sending party.',
    `message_function_code` STRING COMMENT 'Indicates the function of this COPARN message: original announcement, cancellation of previous message, replacement, addition, or deletion.. Valid values are `original|cancellation|replacement|addition|deletion`',
    `message_reference_number` STRING COMMENT 'Unique reference number assigned by the sender to identify this specific COPARN message transmission. Used for message tracking and reconciliation.',
    `message_version` STRING COMMENT 'Version of the COPARN EDI message standard used for this transmission (e.g., D95B, D01B).',
    `operation_type` STRING COMMENT 'Type of container operation being pre-announced: gate-in (truck arrival), gate-out (truck departure), vessel load, vessel discharge, transhipment, rail-in, or rail-out. [ENUM-REF-CANDIDATE: gate_in|gate_out|vessel_load|vessel_discharge|transhipment|rail_in|rail_out — 7 candidates stripped; promote to reference product]',
    `oversized_flag` BOOLEAN COMMENT 'Indicates whether the container carries oversized cargo exceeding standard container dimensions.',
    `pod_code` STRING COMMENT 'Five-character UN/LOCODE of the port where the container will be or was discharged from the vessel.. Valid values are `^[A-Z]{5}$`',
    `pol_code` STRING COMMENT 'Five-character UN/LOCODE of the port where the container was or will be loaded onto the vessel.. Valid values are `^[A-Z]{5}$`',
    `processed_timestamp` TIMESTAMP COMMENT 'Date and time when the COPARN message was successfully processed and integrated into the terminal operating system.',
    `processing_status` STRING COMMENT 'Current processing status of the COPARN message within the terminal operating system: received from EDI gateway, validated against business rules, accepted for planning, rejected due to errors, or successfully processed.. Valid values are `received|validated|accepted|rejected|processed|error`',
    `received_timestamp` TIMESTAMP COMMENT 'Date and time when the COPARN message was received by the Port Community System EDI gateway.',
    `receiving_terminal_code` STRING COMMENT 'Identifier of the port terminal receiving and processing this COPARN message.',
    `receiving_terminal_name` STRING COMMENT 'Full name of the port terminal facility receiving this container pre-announcement.',
    `reefer_flag` BOOLEAN COMMENT 'Indicates whether this is a refrigerated container requiring temperature control and power connection.',
    `sending_party_code` STRING COMMENT 'Identifier of the party sending the COPARN message, typically the shipping line, freight forwarder, or agent.',
    `sending_party_name` STRING COMMENT 'Full name of the organization or entity that sent the COPARN message.',
    `special_handling_instructions` STRING COMMENT 'Free-text field containing any special handling requirements or instructions for this container.',
    `temperature_setpoint_celsius` DECIMAL(18,2) COMMENT 'Required temperature setpoint for refrigerated containers, measured in degrees Celsius.',
    `teu_equivalent` DECIMAL(18,2) COMMENT 'TEU equivalent value of this container for capacity planning and billing purposes (e.g., 1.0 for 20ft, 2.0 for 40ft).',
    `un_number` STRING COMMENT 'Four-digit UN number identifying the dangerous goods substance (e.g., UN1203 for gasoline).. Valid values are `^UN[0-9]{4}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this COPARN record was last modified in the lakehouse silver layer.',
    `validation_error_message` STRING COMMENT 'Error message or reason code if the COPARN message was rejected or failed validation.',
    `vgm_verified_flag` BOOLEAN COMMENT 'Indicates whether the container gross weight has been verified according to SOLAS VGM requirements.',
    CONSTRAINT pk_container_preadvice PRIMARY KEY(`container_preadvice_id`)
) COMMENT 'Transactional record of COPARN (Container Pre-Announcement) EDI messages received from shipping lines or agents, notifying the terminal of containers expected for gate-in or vessel loading. Captures COPARN message ID, message reference number, sending party (shipping line/agent), receiving terminal, message datetime, vessel call reference, voyage number, container number, container type/size, operation type (in/out), expected arrival window, cargo status (full/empty), BOL reference, and processing status (received/validated/accepted/rejected). Sourced from PCS EDI gateway.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` (
    `delivery_order_id` BIGINT COMMENT 'Unique identifier for the delivery order record. Primary key for the cargo delivery order entity.',
    `access_event_id` BIGINT COMMENT 'Foreign key linking to security.access_event. Business justification: Delivery order pickup requires gate access authorization. Links cargo release to physical access control, enabling verification that authorized collector accessed terminal, supporting audit trail for ',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Delivery orders reference service agreements to validate release terms, free time entitlements, and storage conditions. Required for cargo release authorization and demurrage calculation in terminal o',
    `bill_of_lading_id` BIGINT COMMENT 'Reference to the Bill of Lading under which this cargo is shipped. Links the D/O to the master shipping document.',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: Delivery orders release cargo originally booked - links release documentation to booking for freight payment verification, demurrage calculation, and commercial terms enforcement. Delivery authorizati',
    `contact_person_id` BIGINT COMMENT 'Reference to the party authorized by the consignee to collect the cargo on their behalf. May be the consignee themselves or a nominated third party.',
    `container_id` BIGINT COMMENT 'Reference to the container for which this delivery order is issued. May be null for break-bulk or non-containerized cargo.',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Delivery orders cannot be released when customs holds are active. Real business process: terminal gate systems check hold status before authorizing cargo release; delivery order issuance is blocked un',
    `import_export_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.import_export_permit. Business justification: Delivery orders for controlled goods must reference valid import/export permits. Real business process: terminal gate release procedures require permit validation before cargo handover; gate systems v',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Delivery order issuance incurs documentation fees, D/O processing charges, and revalidation fees. Links delivery order to invoice for documentation service charges. Note: cargo_delivery_order has frei',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Delivery orders are legal cargo release documents requiring documented issuing officer for regulatory compliance, fraud prevention, dispute resolution, and audit trail. Port operations track which aut',
    `original_delivery_order_id` BIGINT COMMENT 'Self-referencing foreign key to the original delivery order if this D/O is a reissue, amendment, or replacement. Null for original D/Os.',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the shipping line agent or freight forwarder who issued the delivery order on behalf of the carrier.',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Delivery orders for contract customers reference negotiated rate cards to apply preferential pricing and SLA terms. Commercial systems require this link to enforce contracted rates and track volume co',
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: Delivery orders authorize cargo release after specific vessel discharge completion. Terminal gate operations verify cargo availability against vessel call discharge status before releasing containers.',
    `visitor_log_id` BIGINT COMMENT 'Foreign key linking to security.visitor_log. Business justification: Delivery order collection by external parties (freight forwarders, trucking companies) logged as visitor access. Links cargo release to visitor record, enabling verification of authorized collector id',
    `authorized_collector_id_number` STRING COMMENT 'The government-issued identification number of the authorized collector presented at the gate for verification. May be passport, national ID, or driver license number.',
    `authorized_collector_name` STRING COMMENT 'The full name of the individual authorized to collect the cargo on behalf of the consignee. Used for gate verification and security purposes.',
    `cancellation_datetime` TIMESTAMP COMMENT 'The date and time when the delivery order was cancelled. Null if the D/O has not been cancelled.',
    `cancellation_reason` STRING COMMENT 'Free-text explanation for why the delivery order was cancelled. Populated only when delivery_order_status is cancelled.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this delivery order record was first created in the Port Community System (PCS). Record audit field for data lineage.',
    `delivery_order_number` STRING COMMENT 'The externally-known unique delivery order number issued by the shipping line or agent authorizing cargo release. Business identifier for the D/O.. Valid values are `^[A-Z0-9]{8,20}$`',
    `delivery_order_status` STRING COMMENT 'Current lifecycle status of the delivery order. Tracks the D/O from issuance through presentation at the terminal to final cargo release or cancellation.. Valid values are `issued|presented|released|expired|cancelled|suspended`',
    `demurrage_cleared_flag` BOOLEAN COMMENT 'Boolean flag indicating whether any demurrage charges for container detention beyond free time have been paid or waived. True if cleared, false if outstanding.',
    `detention_cleared_flag` BOOLEAN COMMENT 'Boolean flag indicating whether any detention charges for container usage beyond free time outside the terminal have been paid or waived. True if cleared, false if outstanding.',
    `freight_clearance_status` STRING COMMENT 'Indicates whether all freight charges have been paid or cleared by the consignee or shipper. Cargo release is typically conditional on freight clearance.. Valid values are `cleared|pending|outstanding|waived`',
    `issue_date` DATE COMMENT 'The date on which the delivery order was issued by the shipping line or agent. Principal business event timestamp for D/O creation.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this delivery order record was last updated in the Port Community System (PCS). Record audit field for change tracking.',
    `port_dues_clearance_status` STRING COMMENT 'Indicates whether all port-related charges including Terminal Handling Charges (THC), wharfage, and Port Infrastructure Levy (PIL) have been cleared.. Valid values are `cleared|pending|outstanding|waived`',
    `port_of_discharge_code` STRING COMMENT 'The UN/LOCODE five-character code identifying the port where the cargo is being discharged and released. Typically the port operating this delivery order system.. Valid values are `^[A-Z]{5}$`',
    `presentation_datetime` TIMESTAMP COMMENT 'The date and time when the delivery order was first presented at the terminal gate or Container Freight Station (CFS) for cargo collection.',
    `release_datetime` TIMESTAMP COMMENT 'The precise date and time when the cargo was physically released to the authorized collector at the terminal gate or Container Yard (CY).',
    `release_location` STRING COMMENT 'The physical location within the port where the cargo was released. May be terminal gate, Container Yard (CY), Container Freight Station (CFS), warehouse, or berth.. Valid values are `gate|cy|cfs|warehouse|berth`',
    `release_type` STRING COMMENT 'Indicates whether the delivery order authorizes full release of all cargo under the BOL or partial release of specific containers or quantities.. Valid values are `full|partial`',
    `revalidation_count` STRING COMMENT 'The number of times this delivery order has been revalidated or extended beyond its original validity date. Tracks D/O lifecycle complexity.',
    `special_instructions` STRING COMMENT 'Free-text field for any special handling instructions, release conditions, or notes related to the delivery order. May include temperature requirements, hazmat handling, or partial release details.',
    `terminal_code` STRING COMMENT 'The code identifying the specific terminal within the port where the cargo is located and from which it will be released.. Valid values are `^[A-Z0-9]{2,6}$`',
    `validity_date` DATE COMMENT 'The expiration date until which the delivery order remains valid for cargo release. After this date, the D/O may require revalidation or reissuance.',
    `vehicle_registration_number` STRING COMMENT 'The registration plate number of the truck or vehicle used to collect the cargo from the terminal. Captured at gate-out for security and tracking.. Valid values are `^[A-Z0-9]{4,12}$`',
    CONSTRAINT pk_delivery_order PRIMARY KEY(`delivery_order_id`)
) COMMENT 'Master record for the Delivery Order (D/O) issued by the shipping line or agent authorizing release of cargo to the consignee or their nominated party. Captures D/O number, BOL reference, container number, issuing agent, issue date, validity date, consignee details, authorized collector details, release type (full/partial), freight clearance status, customs release status, port dues clearance status, demurrage/detention charges cleared flag, D/O status (issued/presented/released/expired/cancelled), and release datetime. SSOT for cargo release authorization. Sourced from PCS.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` (
    `demurrage_detention_id` BIGINT COMMENT 'Unique identifier for the demurrage and detention charge record.',
    `bill_of_lading_id` BIGINT COMMENT 'Reference to the Bill of Lading document governing this cargo shipment.',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: Demurrage/detention charges calculated against original cargo booking terms - commercial link for free-time calculation, tariff application, and billing. Charges reference booking to determine applica',
    `container_id` BIGINT COMMENT 'Reference to the container subject to demurrage or detention charges.',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Customs holds cause demurrage/detention charges. Real business process: billing systems must link holds to charge calculations for dispute resolution; shippers request waivers by proving delay was cus',
    `demurrage_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.demurrage_schedule. Business justification: Demurrage charges are calculated based on demurrage schedules (free time, daily rates). Currently demurrage_detention has tariff_id (unlinked). Adding specific FK to tariff.demurrage_schedule enables ',
    `terminal_zone_id` BIGINT COMMENT 'Reference to the container terminal where the demurrage or detention event occurred.',
    `demurrage_terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Demurrage charges are zone-specific (container stored in specific zone during free time); needed for accurate charge calculation, zone-based billing, and operational cost allocation. Terminal_id is un',
    `detention_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.detention_schedule. Business justification: Detention charges are calculated based on detention schedules (free time, daily rates). Adding FK to tariff.detention_schedule enables proper rate lookup for container detention outside port. No redun',
    `invoice_id` BIGINT COMMENT 'Reference to the invoice document that includes this demurrage or detention charge.',
    `call_id` BIGINT COMMENT 'Reference to the vessel call during which the container was discharged, triggering the free time period.',
    `port_tariff_id` BIGINT COMMENT 'Reference to the applicable tariff rate schedule used for charge calculation.',
    `shipping_line_id` BIGINT COMMENT 'Reference to the shipping line or carrier responsible for the container.',
    `bol_number` STRING COMMENT 'Unique Bill of Lading reference number issued by the carrier for this shipment.',
    `calculation_method` STRING COMMENT 'Method used to calculate charges: calendar_days (all days count), working_days (excludes weekends/holidays), tiered_rate (escalating rates over time).. Valid values are `calendar_days|working_days|tiered_rate`',
    `cargo_type` STRING COMMENT 'Classification of cargo: FCL (Full Container Load), LCL (Less than Container Load), breakbulk, or dangerous goods requiring special handling.. Valid values are `FCL|LCL|breakbulk|dangerous`',
    `charge_status` STRING COMMENT 'Current lifecycle state of the demurrage/detention charge: accruing (charges accumulating), finalized (calculation complete), disputed (under review), waived (forgiven), invoiced (billed), settled (paid), cancelled (voided). [ENUM-REF-CANDIDATE: accruing|finalized|disputed|waived|invoiced|settled|cancelled — 7 candidates stripped; promote to reference product]',
    `charge_stop_timestamp` TIMESTAMP COMMENT 'Date and time when charges cease to accrue, typically at container pickup or return.',
    `charge_type` STRING COMMENT 'Classification of the charge: demurrage (container remains at terminal beyond free time), detention (container held outside terminal beyond free time), or combined (both charges apply).. Valid values are `demurrage|detention|combined`',
    `chargeable_event_timestamp` TIMESTAMP COMMENT 'Date and time of the triggering event for charge calculation, such as container discharge for demurrage or gate-out for detention.',
    `container_size_type` STRING COMMENT 'ISO 6346 container size and type code indicating physical dimensions and equipment category (e.g., 20GP = 20-foot general purpose, 40HC = 40-foot high cube).. Valid values are `20GP|40GP|40HC|45HC|20RF|40RF`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this demurrage/detention record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this record.. Valid values are `^[A-Z]{3}$`',
    `daily_rate_amount` DECIMAL(18,2) COMMENT 'Per-day charge rate applied for demurrage or detention, expressed in the billing currency.',
    `days_exceeded` STRING COMMENT 'Number of days beyond the free time allowance for which charges are applicable.',
    `dispute_flag` BOOLEAN COMMENT 'Indicates whether the charge is currently under dispute by the shipping line or cargo owner.',
    `dispute_raised_date` DATE COMMENT 'Date when the dispute was formally lodged by the shipping line or cargo owner.',
    `dispute_reason` STRING COMMENT 'Textual explanation of the grounds for dispute, such as incorrect free time calculation, operational delays, or force majeure.',
    `dispute_resolved_date` DATE COMMENT 'Date when the dispute was resolved and final charge determination was made.',
    `free_time_days` STRING COMMENT 'Number of days allowed under the tariff or contract before demurrage or detention charges begin to accrue.',
    `free_time_end_timestamp` TIMESTAMP COMMENT 'Date and time when the free time period expires and charges begin to accrue.',
    `free_time_start_timestamp` TIMESTAMP COMMENT 'Date and time when the free time period begins, typically at container discharge or gate-out.',
    `invoice_date` DATE COMMENT 'Date when the charge was included in an invoice and billed to the shipping line.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this record was most recently modified, reflecting charge recalculations, status changes, or dispute updates.',
    `net_charge_amount` DECIMAL(18,2) COMMENT 'Final billable amount after applying waivers, calculated as total charge amount minus waiver amount.',
    `notes` STRING COMMENT 'Free-text field for additional comments, special circumstances, or operational notes related to the charge.',
    `payment_due_date` DATE COMMENT 'Date by which payment of the demurrage or detention charge is contractually due.',
    `payment_received_date` DATE COMMENT 'Date when payment for this charge was received and applied to the receivable account.',
    `pod_code` STRING COMMENT 'UN/LOCODE five-character code identifying the port where the container was discharged from the vessel.. Valid values are `^[A-Z]{5}$`',
    `pol_code` STRING COMMENT 'UN/LOCODE five-character code identifying the port where the container was loaded onto the vessel.. Valid values are `^[A-Z]{5}$`',
    `settlement_status` STRING COMMENT 'Payment status of the charge: outstanding (unpaid), partial (partially paid), settled (fully paid), overdue (past due date).. Valid values are `outstanding|partial|settled|overdue`',
    `total_charge_amount` DECIMAL(18,2) COMMENT 'Total accrued demurrage or detention charge calculated as days exceeded multiplied by daily rate.',
    `waiver_amount` DECIMAL(18,2) COMMENT 'Portion of the total charge amount that has been waived or forgiven due to dispute resolution or commercial agreement.',
    `waiver_approval_date` DATE COMMENT 'Date when the waiver was formally approved and applied to the charge.',
    `waiver_approved_by` STRING COMMENT 'Name or identifier of the port authority or commercial manager who authorized the waiver.',
    `waiver_reason` STRING COMMENT 'Business justification for granting the waiver, such as operational disruption, commercial goodwill, or contractual agreement.',
    CONSTRAINT pk_demurrage_detention PRIMARY KEY(`demurrage_detention_id`)
) COMMENT 'Transactional record tracking demurrage and detention charge accruals for containers exceeding contractual free time allowances. Captures container reference, BOL, shipping line, free time boundaries, days exceeded, applicable tariff rate, accrued amount, dispute/waiver status, and settlement state. Interfaces with tariff domain for rate lookup and billing domain for invoice generation. Critical for port revenue protection and shipping line commercial relationships.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` (
    `lcl_consolidation_id` BIGINT COMMENT 'Unique identifier for the LCL consolidation or deconsolidation job. Primary key for the LCL consolidation master record.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: LCL consolidation services operate under CFS (Container Freight Station) agreements defining stuffing/stripping rates, storage terms, and handling procedures. Required for service delivery and billing',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: LCL consolidation jobs group multiple shipments under master cargo booking - operational link for CFS planning, container stuffing/stripping scheduling, and consolidated billing. Master booking govern',
    `container_id` BIGINT COMMENT 'Foreign key linking to cargo.container. Business justification: LCL cargo is stuffed into a specific container. Container_number is denormalized and should be retrieved via FK. This links the consolidation job to the physical container unit used for stuffing.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: CFS (Container Freight Station) operations are distinct cost centers in port terminals. Consolidation/deconsolidation activities incur labor, facility, and equipment costs tracked by cost center for a',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: LCL consolidations require house BoL-level customs declarations. Real business process: CFS deconsolidation cannot proceed until all house declarations are cleared; consolidators track declaration sta',
    `employee_id` BIGINT COMMENT 'Reference to the CFS operator or workforce member responsible for executing the consolidation or deconsolidation job. Links to the employee or operator master data.',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: LCL consolidation services (CFS stuffing, stripping, cargo handling, documentation) are billable operations. Links consolidation job to invoice for CFS charges. Note: lcl_consolidation has terminal_ha',
    `bill_of_lading_id` BIGINT COMMENT 'Foreign key linking to cargo.bill_of_lading. Business justification: LCL consolidation is covered by a master BOL. Master_bol_number is denormalized and should be retrieved via FK. This links the consolidation job to the master transport document. FK column name uses ',
    `packaging_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.packaging_type. Business justification: LCL consolidation involves multiple package types requiring standardized handling. Linking to packaging_type master enables consolidation planning based on package dimensions, space optimization calcu',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the freight forwarder or Non-Vessel Operating Common Carrier (NVOCC) responsible for organizing the LCL consolidation. Links to the participant account master data.',
    `port_location_id` BIGINT COMMENT 'Reference to the Container Freight Station location where the consolidation or deconsolidation activity is performed. Links to the facility master data.',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: CFS operations are high-security areas; incidents during stuffing/stripping (theft, contamination, unauthorized access) must reference the consolidation job for investigation, CFS security review, and',
    `thc_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.thc_schedule. Business justification: LCL consolidation operations (container stuffing/stripping at CFS) incur Terminal Handling Charges per applicable schedule. CFS billing systems link consolidation jobs to THC schedules to charge for l',
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: LCL consolidation jobs at CFS facilities must coordinate stuffing/stripping schedules with specific vessel call timings for cargo readiness and berth availability. CFS operations track which vessel ca',
    `vessel_id` BIGINT COMMENT 'Reference to the vessel on which the consolidated container is scheduled to be shipped. Links to the vessel master data. Null for deconsolidation jobs or jobs not yet assigned to a vessel.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: LCL consolidation occurs at CFS warehouses; fundamental to LCL operations, warehouse capacity planning, and stuffing/stripping activity tracking. Cfs_location_id references port_location, not warehous',
    `actual_completion_timestamp` TIMESTAMP COMMENT 'Actual date and time when the consolidation or deconsolidation job was completed. Recorded when all cargo has been stuffed into or stripped from the container and the job is closed.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when the consolidation or deconsolidation job commenced at the CFS. Recorded when physical cargo handling operations begin.',
    `commodity_mix` STRING COMMENT 'Description of the types of commodities included in the consolidation. May include general cargo, textiles, electronics, machinery parts, or other goods. Used for stowage planning and compatibility assessment.',
    `consolidation_job_number` STRING COMMENT 'Business identifier for the consolidation or deconsolidation job. Externally-known reference number used in Container Freight Station (CFS) operations and documentation.. Valid values are `^[A-Z0-9]{8,20}$`',
    `container_size_type` STRING COMMENT 'ISO container size and type code for the container used in consolidation. Common values: 20GP (20-foot General Purpose), 40GP (40-foot General Purpose), 40HC (40-foot High Cube), 45HC (45-foot High Cube).. Valid values are `20GP|40GP|40HC|45HC`',
    `contains_dangerous_goods` BOOLEAN COMMENT 'Indicates whether the consolidation includes any dangerous goods requiring special handling per International Maritime Dangerous Goods (IMDG) Code. True if any house BOL contains IMDG cargo.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the LCL consolidation job record was first created in the system. Represents the initial capture of the consolidation job in the Terminal Operating System.',
    `delivery_order_issued` BOOLEAN COMMENT 'Indicates whether delivery orders have been issued for the deconsolidated cargo. True when all house BOLs have corresponding delivery orders issued for cargo release.',
    `destination_location` STRING COMMENT 'Three-letter UN/LOCODE representing the destination location or Port of Discharge (POD) for the consolidated cargo. Indicates the final destination after deconsolidation.. Valid values are `^[A-Z]{3}$`',
    `equipment_used` STRING COMMENT 'Description of material handling equipment used during the consolidation or deconsolidation operations. May include forklifts, pallet jacks, or other CFS equipment identifiers.',
    `house_bol_count` STRING COMMENT 'Total number of individual house Bills of Lading included in this consolidation job. Each house BOL represents a separate shippers cargo within the consolidated container.',
    `inspection_notes` STRING COMMENT 'Free-text field capturing observations from quality inspection. May include cargo condition notes, discrepancies, damage reports, or compliance findings.',
    `job_status` STRING COMMENT 'Current lifecycle status of the consolidation or deconsolidation job. Tracks progression from planning through completion or cancellation.. Valid values are `planned|in_progress|completed|cancelled|on_hold`',
    `job_type` STRING COMMENT 'Type of LCL job being performed. Consolidation combines multiple LCL shipments into a single container; deconsolidation unpacks a container into individual LCL shipments.. Valid values are `consolidation|deconsolidation`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the LCL consolidation job record was last updated. Tracks the most recent change to any field in the record for audit and data lineage purposes.',
    `origin_location` STRING COMMENT 'Three-letter UN/LOCODE representing the origin location or Port of Loading (POL) for the consolidated cargo. Indicates where the cargo originates before consolidation.. Valid values are `^[A-Z]{3}$`',
    `planned_stripping_date` DATE COMMENT 'Scheduled date for container stripping (unloading) during deconsolidation operations. Represents the planned date when the container will be unpacked at the CFS.',
    `planned_stuffing_date` DATE COMMENT 'Scheduled date for container stuffing (loading) during consolidation operations. Represents the planned date when LCL cargo will be loaded into the container at the CFS.',
    `quality_inspection_completed` BOOLEAN COMMENT 'Indicates whether quality inspection of the consolidation or deconsolidation job has been completed. True when cargo condition and documentation have been verified.',
    `seal_number` STRING COMMENT 'Security seal number applied to the container after consolidation stuffing is complete. Used to ensure container integrity during transport. Null for deconsolidation jobs or incomplete consolidations.. Valid values are `^[A-Z0-9]{6,20}$`',
    `special_handling_instructions` STRING COMMENT 'Free-text field capturing any special handling requirements for the consolidation job. May include temperature control, fragile cargo handling, security requirements, or other operational notes.',
    `terminal_handling_charge_applied` BOOLEAN COMMENT 'Indicates whether Terminal Handling Charges have been applied to this consolidation job. True when THC billing has been processed for the CFS operations.',
    `total_cargo_volume_cbm` DECIMAL(18,2) COMMENT 'Total volume of all cargo included in the consolidation job, measured in cubic meters. Sum of all individual shipment volumes within the job.',
    `total_cargo_weight_kg` DECIMAL(18,2) COMMENT 'Total weight of all cargo included in the consolidation job, measured in kilograms. Sum of all individual shipment weights within the job.',
    CONSTRAINT pk_lcl_consolidation PRIMARY KEY(`lcl_consolidation_id`)
) COMMENT 'Master record for LCL (Less than Container Load) consolidation and deconsolidation jobs managed at the Container Freight Station (CFS). Captures consolidation job number, CFS location reference, job type (consolidation/deconsolidation), master BOL reference, house BOL count, total cargo weight (KG), total volume (CBM), commodity mix, origin/destination, freight forwarder reference, planned stuffing/stripping date, actual completion date, container number assigned (post-consolidation), and job status. SSOT for LCL cargo grouping and CFS operations.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` (
    `cargo_document_id` BIGINT COMMENT 'Unique identifier for the cargo document record. Primary key.',
    `bill_of_lading_id` BIGINT COMMENT 'Reference to the Bill of Lading (BOL) associated with this cargo document. Nullable if document is not BOL-specific.',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Cargo documents (certificates of origin, phytosanitary certificates) reference HS codes for commodity classification. Real business process: customs brokers validate document coverage against declared',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Cargo documents (certificates of origin, insurance, phytosanitary) are issued to/held by specific participants. Essential for customs clearance workflows, compliance audits, document release authoriza',
    `packaging_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.packaging_type. Business justification: Cargo documents (packing lists, certificates of origin, phytosanitary certificates) reference package types for customs validation. Linking to packaging_type master enables automated document validati',
    `shipment_id` BIGINT COMMENT 'Reference to the parent shipment associated with this cargo document.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Customs clearance, phytosanitary certificates, and origin documents require documented verifying officer for compliance audit trail, customs disputes, and regulatory inspections. Port community system',
    `certificate_number` STRING COMMENT 'Unique certificate number assigned by the issuing authority for certificate-type documents (e.g., phytosanitary, fumigation, inspection certificates).',
    `commodity_description` STRING COMMENT 'Detailed textual description of the commodity or cargo covered by this document.',
    `country_of_issue` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code representing the country where the document was issued.. Valid values are `^[A-Z]{3}$`',
    `country_of_origin` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code representing the country where the cargo originated or was manufactured.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this cargo document record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for monetary amounts on this document (duty, tax, declared value).. Valid values are `^[A-Z]{3}$`',
    `customs_clearance_status` STRING COMMENT 'Current status of the customs clearance process for this cargo document.. Valid values are `pending|cleared|held|released|rejected`',
    `customs_entry_number` STRING COMMENT 'Unique customs entry or declaration number assigned by the customs authority. Applicable to customs entry documents.',
    `declared_value` DECIMAL(18,2) COMMENT 'Declared commercial value of the cargo covered by this document, used for customs and insurance purposes.',
    `digital_copy_reference` STRING COMMENT 'URI, file path, or document management system reference pointing to the digital copy or scanned image of the cargo document.',
    `document_number` STRING COMMENT 'The unique document number or reference code assigned by the issuing authority or system. Business identifier for the cargo document.',
    `document_status` STRING COMMENT 'Current lifecycle status of the cargo document in the trade compliance and customs clearance workflow.. Valid values are `draft|submitted|accepted|rejected|expired|cancelled`',
    `document_type` STRING COMMENT 'Classification of the cargo document type. Excludes BOL, DGD (Dangerous Goods Declaration), and VGM (Verified Gross Mass) which have dedicated products. [ENUM-REF-CANDIDATE: packing_list|certificate_of_origin|phytosanitary_certificate|fumigation_certificate|weight_certificate|customs_entry|inspection_certificate|insurance_certificate|commercial_invoice — 9 candidates stripped; promote to reference product]',
    `duty_amount` DECIMAL(18,2) COMMENT 'Total customs duty amount assessed for the cargo covered by this document. Applicable to customs entry documents.',
    `expiry_date` DATE COMMENT 'The date on which the cargo document expires and is no longer valid for trade or customs purposes. Nullable for documents without expiration.',
    `gross_weight_kg` DECIMAL(18,2) COMMENT 'Total gross weight of the cargo covered by this document, measured in kilograms. Applicable to weight certificates and packing lists.',
    `is_original` BOOLEAN COMMENT 'Boolean flag indicating whether this record represents the original document (True) or a copy (False).',
    `issue_date` DATE COMMENT 'The date on which the cargo document was officially issued by the authority. Principal business event timestamp for this document.',
    `issuing_authority` STRING COMMENT 'Name of the organization, agency, or entity that issued the cargo document (e.g., customs authority, inspection agency, chamber of commerce).',
    `issuing_authority_code` STRING COMMENT 'Standardized code or identifier for the issuing authority, if applicable.',
    `net_weight_kg` DECIMAL(18,2) COMMENT 'Net weight of the cargo (excluding packaging) covered by this document, measured in kilograms. Applicable to weight certificates and packing lists.',
    `package_count` STRING COMMENT 'Total number of packages, cartons, or units covered by this cargo document. Applicable to packing lists.',
    `rejection_reason` STRING COMMENT 'Textual explanation or code indicating the reason for rejection of the cargo document by the verifying authority. Nullable if document was not rejected.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, comments, or special instructions related to the cargo document.',
    `submission_date` DATE COMMENT 'Date on which the cargo document was submitted to the port authority, customs, or relevant regulatory body.',
    `submitted_by` STRING COMMENT 'Name or identifier of the party (shipping line, freight forwarder, customs broker) that submitted the cargo document.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount (VAT, GST, or other import taxes) assessed for the cargo covered by this document. Applicable to customs entry documents.',
    `treatment_date` DATE COMMENT 'Date on which the treatment (fumigation, inspection, etc.) was performed on the cargo.',
    `treatment_type` STRING COMMENT 'Type of treatment applied to the cargo, applicable to fumigation and phytosanitary certificates (e.g., methyl bromide fumigation, heat treatment).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this cargo document record was last modified in the system.',
    `verification_date` DATE COMMENT 'The date on which the cargo document was verified by the relevant authority.',
    `verification_status` STRING COMMENT 'Status indicating whether the cargo document has been verified by customs or port authorities for authenticity and compliance.. Valid values are `pending|verified|failed|not_required`',
    `volume_cbm` DECIMAL(18,2) COMMENT 'Total volume of the cargo covered by this document, measured in cubic meters (CBM). Applicable to packing lists and cargo manifests.',
    CONSTRAINT pk_cargo_document PRIMARY KEY(`cargo_document_id`)
) COMMENT 'Master record for supplementary cargo trade and transport documents associated with a shipment — specifically packing lists, certificates of origin, phytosanitary certificates, fumigation certificates, weight certificates, and customs entries. Captures document ID, shipment/BOL reference, document type, document number, issuing authority, issue date, expiry date, country of origin, document status (submitted/accepted/rejected/expired), digital copy reference, and verification status. Excludes BOL, DGD, and VGM which have dedicated products. Supports trade compliance and customs clearance workflows. Sourced from PCS.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` (
    `verified_gross_mass_id` BIGINT COMMENT 'Unique identifier for the VGM declaration record. Primary key for the verified gross mass entity.',
    `bill_of_lading_id` BIGINT COMMENT 'Reference to the bill of lading associated with this VGM declaration.',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: VGM submissions required for cargo bookings before vessel loading - SOLAS regulatory compliance link. Shipping lines validate VGM against booking before accepting container for loading, making booking',
    `container_id` BIGINT COMMENT 'Reference to the container for which this VGM declaration applies.',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: VGM weighing services (SOLAS requirement) incur weighbridge charges, certification fees, and VGM submission processing fees. Links VGM record to invoice for mandatory weighing service charges at conta',
    `port_asset_id` BIGINT COMMENT 'Identifier of the specific weighing equipment (weighbridge, scale) used to perform the VGM measurement. Used for calibration tracking and audit purposes.',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the shipper party responsible for providing the VGM declaration.',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: VGM weighing often occurs at gate weighbridges during truck gate-in; required for SOLAS compliance tracking, weighbridge utilization reporting, and integration with gate operating systems. Weighing_st',
    `primary_original_vgm_verified_gross_mass_id` BIGINT COMMENT 'Reference to the original VGM declaration record if this is an amended version. Null for initial submissions.',
    `employee_id` BIGINT COMMENT 'Identifier of the system user or operator who created this VGM declaration record.',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Significant VGM discrepancies or fraudulent declarations trigger security investigations for potential smuggling, misdeclaration, or safety threats. Links VGM fraud detection to formal security incide',
    `shipping_line_id` BIGINT COMMENT 'Reference to the shipping line (carrier) to whom the VGM declaration is submitted.',
    `call_id` BIGINT COMMENT 'Reference to the vessel call for which this VGM declaration is submitted. Links the VGM to the specific vessel voyage.',
    `weighing_station_id` BIGINT COMMENT 'Reference to the weighing station or facility where the VGM weighing was performed.',
    `amendment_reason` STRING COMMENT 'Explanation for why the VGM declaration was amended or resubmitted. Includes details of corrections made.',
    `amendment_version` STRING COMMENT 'Version number of the VGM declaration. Incremented each time the declaration is amended or resubmitted. Initial submission is version 1.',
    `authorized_signatory_contact` STRING COMMENT 'Contact phone number or email of the authorized signatory for verification purposes.',
    `authorized_signatory_name` STRING COMMENT 'Full name of the person authorized by the shipper to sign and submit the VGM declaration on behalf of the shipper.',
    `authorized_signatory_title` STRING COMMENT 'Job title or position of the authorized signatory within the shipper organization.',
    `bol_number` STRING COMMENT 'The bill of lading number associated with this container shipment. Denormalized for operational convenience.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this VGM declaration record was first created in the system.',
    `edi_message_reference` STRING COMMENT 'Reference number of the EDI message (e.g., VERMAS) used to transmit the VGM declaration electronically to the shipping line or terminal.',
    `gross_mass_kg` DECIMAL(18,2) COMMENT 'The verified gross mass of the packed container in kilograms, as declared by the shipper. This is the total weight including the container tare weight and all cargo contents.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this VGM declaration record was last updated or modified in the system.',
    `pcs_submission_reference` STRING COMMENT 'Reference number assigned by the Port Community System when the VGM declaration is submitted electronically through the PCS platform.',
    `pod_code` STRING COMMENT 'UN/LOCODE of the port where the container is to be discharged from the vessel.',
    `pol_code` STRING COMMENT 'UN/LOCODE of the port where the container is to be loaded onto the vessel.',
    `rejection_reason` STRING COMMENT 'Explanation provided by the shipping line or terminal operator if the VGM declaration was rejected. Includes details of discrepancies or missing information.',
    `remarks` STRING COMMENT 'Additional notes or comments related to the VGM declaration, weighing process, or special circumstances.',
    `shipper_name` STRING COMMENT 'Name of the shipper organization responsible for the VGM declaration. Denormalized for operational reporting.',
    `shipper_reference` STRING COMMENT 'Internal reference number used by the shipper to track this VGM declaration within their own systems.',
    `shipping_line_acknowledgement_reference` STRING COMMENT 'Reference number or acknowledgement code provided by the shipping line upon receipt and acceptance of the VGM declaration.',
    `submission_compliance_flag` BOOLEAN COMMENT 'Indicates whether the VGM declaration was submitted before the required deadline. True if compliant (submitted on time), False if non-compliant (late submission).',
    `submission_datetime` TIMESTAMP COMMENT 'The date and time when the VGM declaration was submitted to the shipping line or terminal operator.',
    `submission_deadline` TIMESTAMP COMMENT 'The deadline by which the VGM declaration must be submitted to the shipping line or terminal operator, as per SOLAS requirements and carrier cut-off times.',
    `terminal_code` STRING COMMENT 'Code identifying the specific terminal within the port where the VGM declaration is processed and the container is handled.',
    `verification_status` STRING COMMENT 'Current status of the VGM declaration in the verification workflow. Pending: awaiting review. Verified: accepted by shipping line. Rejected: not accepted due to errors or discrepancies. Expired: deadline passed without submission. Cancelled: declaration withdrawn.. Valid values are `pending|verified|rejected|expired|cancelled`',
    `vessel_imo_number` STRING COMMENT 'The IMO number of the vessel. Unique seven-digit identifier assigned to the vessel by the International Maritime Organization.',
    `vessel_name` STRING COMMENT 'Name of the vessel on which the container is scheduled to be loaded. Denormalized for operational reporting.',
    `vgm_reference_number` STRING COMMENT 'Unique business reference number assigned to the VGM declaration for tracking and audit purposes. Externally-known identifier used in communications with shipping lines and port authorities.',
    `voyage_number` STRING COMMENT 'The voyage number for the vessel call on which the container is to be loaded.',
    `weighing_certificate_number` STRING COMMENT 'Certificate number issued by the certified weighing facility as proof of the VGM measurement.',
    `weighing_datetime` TIMESTAMP COMMENT 'The date and time when the container was weighed to obtain the verified gross mass.',
    `weighing_facility_name` STRING COMMENT 'Name of the certified weighing facility or weighbridge where the container was weighed. Denormalized for operational reporting.',
    `weighing_method` STRING COMMENT 'The method used to determine the verified gross mass. Method 1: weighing the packed container. Method 2: weighing all packages and cargo items, including pallets, dunnage, and other packing material, and adding the tare weight of the container.. Valid values are `Method 1|Method 2`',
    CONSTRAINT pk_verified_gross_mass PRIMARY KEY(`verified_gross_mass_id`)
) COMMENT 'Transactional record of Verified Gross Mass (VGM) declarations submitted per container as mandated by SOLAS Chapter VI Regulation 2 (effective July 2016). Captures VGM reference number, container number, weighing method (Method 1: weigh packed container / Method 2: sum of contents), gross mass declared (KG), weighing station/facility, weighing datetime, authorized signatory, shipper reference, shipping line acknowledgement, submission deadline compliance flag, and verification status. Mandatory for all export containers before vessel loading. SSOT for VGM compliance data. Sourced from PCS and certified weighbridges.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` (
    `damage_claim_id` BIGINT COMMENT 'Unique identifier for the cargo damage or loss claim record. Primary key for the cargo damage claim entity.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Damage claims reference service agreements to determine liability limits, insurance requirements, and dispute resolution procedures. Critical for claims assessment and settlement in terminal liability',
    `bill_of_lading_id` BIGINT COMMENT 'Foreign key linking to cargo.bill_of_lading. Business justification: Damage claim is associated with cargo covered by a specific BOL. Bol_number is denormalized and should be retrieved via FK. This links the claim to the cargo title document and provides shipper/consig',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: Damage claims reference original cargo booking for liability determination, insurance coverage validation, and commercial terms review. Claims processing requires booking to establish contractual rela',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Claim processing requires linking claimant_name to participant account for settlement payment, credit note issuance, dispute resolution workflows, and customer service case management. Essential for b',
    `violation_id` BIGINT COMMENT 'Foreign key linking to compliance.violation. Business justification: Cargo damage may result from compliance violations (improper hazmat handling, IMDG breaches, stowage violations). Real business process: claims investigations reference violation records for liability',
    `container_id` BIGINT COMMENT 'Foreign key linking to cargo.container. Business justification: Damage claim is raised for a specific container. Container_number is denormalized and should be retrieved via FK to container master record. This provides access to container specifications, ownership',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Claim settlements post to specific GL accounts (claims expense, insurance recoverable, liability accounts). Direct link supports automated journal entry generation, audit trail from operational damage',
    `employee_id` BIGINT COMMENT 'Identifier of the system user who created the cargo damage claim record.',
    `provision_id` BIGINT COMMENT 'Foreign key linking to finance.provision. Business justification: Cargo damage claims require financial provisions under IFRS 37 / IAS 37 for probable obligations. Port operators create provisions when liability is probable and estimable. Direct link enables trackin',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Damage claim investigation requires identifying which specific asset (crane, forklift, RTG) caused the damage for root cause analysis, liability assessment, insurance claims, operator training needs, ',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Damage claims originating from security incidents (theft, sabotage, tampering) require direct linkage for liability determination, insurance processing, and investigation coordination. Distinguishes s',
    `superseded_damage_claim_id` BIGINT COMMENT 'Self-referencing FK on damage_claim (superseded_damage_claim_id)',
    `call_id` BIGINT COMMENT 'Identifier of the vessel call during which the cargo damage or loss occurred.',
    `cargo_description` STRING COMMENT 'Description of the cargo commodity that sustained damage or loss.',
    `claim_lodgement_date` DATE COMMENT 'Date when the cargo damage or loss claim was formally lodged with the port authority or terminal operator.',
    `claim_lodgement_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the cargo damage claim was received and registered in the system.',
    `claim_reference_number` STRING COMMENT 'Externally-known unique reference number assigned to the cargo damage or loss claim for tracking and communication purposes.',
    `claim_status` STRING COMMENT 'Current lifecycle status of the cargo damage claim indicating its progression through the claims management workflow.. Valid values are `lodged|under-investigation|accepted|rejected|settled|withdrawn`',
    `claimant_address` STRING COMMENT 'Full postal address of the claimant organization or individual for formal correspondence.',
    `claimant_contact_email` STRING COMMENT 'Primary email address of the claimant for claim correspondence and updates.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `claimant_contact_phone` STRING COMMENT 'Primary telephone number of the claimant for claim-related communication.',
    `claimant_type` STRING COMMENT 'Classification of the party raising the cargo damage claim, indicating their role in the supply chain.. Valid values are `shipping-line|cargo-owner|freight-forwarder|insurer|consignee|shipper`',
    `closure_date` DATE COMMENT 'Date when the cargo damage claim was formally closed and removed from active claims management.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the cargo damage claim record was first created in the database.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the estimated loss value and settlement amounts.. Valid values are `^[A-Z]{3}$`',
    `damage_description` STRING COMMENT 'Detailed narrative description of the cargo damage or loss, including observed conditions and circumstances.',
    `damage_discovery_location` STRING COMMENT 'Physical location within the port or terminal where the cargo damage or loss was first discovered.. Valid values are `vessel|yard|gate|cfs|berth|warehouse`',
    `damage_discovery_timestamp` TIMESTAMP COMMENT 'Precise date and time when the cargo damage or loss was first identified and reported.',
    `damage_type` STRING COMMENT 'Classification of the type of damage or loss sustained by the cargo, critical for liability assessment and insurance processing.. Valid values are `physical-damage|contamination|shortage|pilferage|water-damage|temperature-excursion`',
    `estimated_loss_value` DECIMAL(18,2) COMMENT 'Initial estimated monetary value of the cargo damage or loss as declared by the claimant.',
    `gross_weight_kg` DECIMAL(18,2) COMMENT 'Total gross weight in kilograms of the damaged or lost cargo.',
    `hs_code` STRING COMMENT 'Harmonized System commodity classification code for the damaged cargo, used for customs and trade documentation.',
    `inspection_record_reference` STRING COMMENT 'Reference to the formal inspection record or report conducted to assess the cargo damage.',
    `insurer_claim_reference` STRING COMMENT 'Insurance company or P&I club reference number for their parallel claim processing.',
    `insurer_name` STRING COMMENT 'Name of the insurance company or Protection and Indemnity (P&I) club involved in the claim.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when the cargo damage claim record was last updated or modified.',
    `liability_assessment` STRING COMMENT 'Determination of which party bears liability for the cargo damage or loss based on investigation findings.. Valid values are `port-liable|stevedore-liable|carrier-liable|force-majeure|under-review|no-liability`',
    `liability_assessment_date` DATE COMMENT 'Date when the liability determination was formally made and documented.',
    `liability_assessor_name` STRING COMMENT 'Name of the claims officer or assessor who conducted the liability investigation and determination.',
    `package_count` STRING COMMENT 'Number of packages or units affected by the damage or loss.',
    `photographic_evidence_url` STRING COMMENT 'Document management system URL or reference to photographic evidence of the cargo damage.',
    `pod_code` STRING COMMENT 'UN/LOCODE five-character code identifying the port where the damaged cargo was to be discharged.. Valid values are `^[A-Z]{5}$`',
    `pol_code` STRING COMMENT 'UN/LOCODE five-character code identifying the port where the damaged cargo was originally loaded.. Valid values are `^[A-Z]{5}$`',
    `rejection_reason` STRING COMMENT 'Detailed explanation for why the cargo damage claim was rejected, if applicable.',
    `remarks` STRING COMMENT 'Additional notes, comments, or special circumstances related to the cargo damage claim.',
    `settlement_amount` DECIMAL(18,2) COMMENT 'Final agreed monetary settlement amount paid to the claimant for the cargo damage or loss.',
    `settlement_date` DATE COMMENT 'Date when the claim settlement was finalized and payment was made or agreed.',
    `stevedore_company_name` STRING COMMENT 'Name of the stevedoring company responsible for cargo handling operations at the time of damage.',
    `survey_report_reference` STRING COMMENT 'Reference number or identifier of the independent cargo survey report documenting the damage or loss.',
    `terminal_operator_code` STRING COMMENT 'Code identifying the terminal operator managing the facility where the damage occurred.',
    CONSTRAINT pk_damage_claim PRIMARY KEY(`damage_claim_id`)
) COMMENT 'Transactional record of cargo damage or loss claims raised against the port, stevedore, or terminal operator. Captures claim reference number, claimant (shipping line/cargo owner/insurer), container/cargo reference, BOL reference, damage type (physical/contamination/shortage/pilferage/water damage/temperature excursion), damage discovery location (vessel/yard/gate/CFS), estimated loss value, currency, supporting evidence references (survey reports, photos, inspection records), liability assessment, claim status (lodged/under-investigation/accepted/rejected/settled), settlement amount, and closure date. Critical for port liability management and insurance reporting.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` (
    `shipment_tariff_exception_id` BIGINT COMMENT 'Primary key for the shipment_tariff_exception association',
    `employee_id` BIGINT COMMENT 'Reference to the employee who applied this exception to this shipment in the billing system. Audit trail for operational accountability.',
    `exception_id` BIGINT COMMENT 'Foreign key linking to the approved tariff exception being applied to this shipment',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to the cargo shipment to which this tariff exception is applied',
    `application_date` DATE COMMENT 'Date when this tariff exception was applied to the shipment for billing purposes. Tracks when the commercial decision was operationalized.',
    `application_justification` STRING COMMENT 'Detailed business justification for applying this specific exception to this specific shipment. Required for audit and compliance.',
    `application_status` STRING COMMENT 'Current status of this exception application: PENDING (awaiting approval), APPROVED (approved but not yet applied), APPLIED (active on shipment billing), REVOKED (cancelled), EXPIRED (validity period ended).',
    `applied_discount_percentage` DECIMAL(18,2) COMMENT 'The actual percentage discount applied to this shipment under this exception. Captured at application time for audit trail.',
    `applied_exception_rate_amount` DECIMAL(18,2) COMMENT 'The actual exceptional rate amount applied to this specific shipment under this exception. May differ from the exceptions standard rate if further negotiation occurred.',
    `applied_free_days_granted` STRING COMMENT 'The actual number of extended free days granted to this shipment under this exception. Critical for demurrage calculation.',
    `applied_waiver_amount` DECIMAL(18,2) COMMENT 'The actual monetary amount waived for this shipment under this exception. Tracks the revenue impact per shipment.',
    `approval_authority` STRING COMMENT 'Name or title of the individual or committee who approved this specific application of the exception to this shipment. Provides audit trail.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this application record.',
    `effective_date` DATE COMMENT 'Date from which this exception becomes valid for this shipment. Captured from the exception record at application time.',
    `expiry_date` DATE COMMENT 'Date on which this exception ceases to be valid for this shipment. Captured from the exception record at application time.',
    `revenue_impact_amount` DECIMAL(18,2) COMMENT 'Calculated revenue impact (loss or gain) from applying this exception to this shipment. Used for commercial analysis and reporting.',
    CONSTRAINT pk_shipment_tariff_exception PRIMARY KEY(`shipment_tariff_exception_id`)
) COMMENT 'This association product represents the application of approved tariff exceptions to specific cargo shipments moving through the port. It captures the commercial pricing deviations granted for each shipment-exception combination, including the approved rates, discounts, waivers, extended free days, validity periods, and approval authority. Each record links one shipment to one tariff exception with attributes that exist only in the context of this specific application of the exception to the shipment.. Existence Justification: In maritime port operations, a single cargo shipment can legitimately have multiple tariff exceptions applied simultaneously (e.g., a volume discount exception, a free time extension exception, and a surcharge waiver exception all applying to the same shipment). Conversely, a single approved tariff exception (such as a trade lane discount or customer loyalty waiver) is routinely applied to multiple shipments that meet the exception criteria. Port commercial teams actively manage these exception applications as distinct operational records, tracking approval, rates, validity periods, and revenue impact for each shipment-exception combination for audit, compliance, and revenue management purposes.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` (
    `cargo_rail_wagon_load_id` BIGINT COMMENT 'Primary key for cargo_rail_wagon_load',
    `employee_id` BIGINT COMMENT 'Reference to the equipment operator or crew member who performed the physical discharge operation for this container. Used for productivity tracking and quality accountability.',
    `cargo_employee_id` BIGINT COMMENT 'Reference to the equipment operator or crew member who performed the physical loading operation for this container. Used for productivity tracking and quality accountability.',
    `container_id` BIGINT COMMENT 'Foreign key linking to the specific container being loaded onto the rail visit',
    `intermodal_rail_wagon_load_id` BIGINT COMMENT 'Unique system identifier for this rail wagon load record. Primary key for the association.',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to the specific rail train visit carrying the container',
    `actual_discharge_timestamp` TIMESTAMP COMMENT 'Actual date and time when this container was physically removed from the rail wagon at destination or intermediate stop. Used for turnaround time tracking.',
    `actual_load_timestamp` TIMESTAMP COMMENT 'Actual date and time when this container was physically loaded onto the rail wagon. Used for productivity tracking and dwell time calculation.',
    `is_hazmat_load` BOOLEAN COMMENT 'Flag indicating whether this container carries dangerous goods requiring special positioning, separation, and handling during this rail movement. Derived from container hazmat status but tracked at load level for operational safety.',
    `is_overweight_load` BOOLEAN COMMENT 'Flag indicating whether this container load exceeds standard rail weight limits and requires special handling, positioning, or permits for this rail movement.',
    `lashing_equipment_used` STRING COMMENT 'Actual securing equipment applied to this container load (twist locks, chains, straps, corner castings). Used for equipment tracking and safety compliance verification.',
    `lashing_instructions` STRING COMMENT 'Specific securing and lashing instructions for this container on this wagon, including twist lock configuration, chain/strap requirements, and special securing equipment needed based on container type, weight, and cargo characteristics.',
    `load_remarks` STRING COMMENT 'Free-text operational notes about this specific container load, including special handling performed, issues encountered, damage observations, or deviations from standard procedures.',
    `load_sequence_number` STRING COMMENT 'Sequential order in which this container was loaded onto the wagon during the loading operation. Used for operational tracking and productivity measurement.',
    `load_status` STRING COMMENT 'Current operational status of this container load on the rail visit. Tracks lifecycle from planning through discharge: planned (scheduled but not yet loaded), loading (in progress), loaded (on wagon but not secured), secured (lashed and ready), in_transit (train departed), discharging (being removed), discharged (removed from wagon), cancelled (planned load cancelled).',
    `load_weight_kg` DECIMAL(18,2) COMMENT 'Verified gross weight of this container at time of loading onto the rail wagon in kilograms. Used for train weight distribution, axle load compliance, and safety verification.',
    `planned_load_timestamp` TIMESTAMP COMMENT 'Scheduled date and time when this container is planned to be loaded onto the rail wagon. Used for operational planning and resource scheduling.',
    `requires_reefer_power` BOOLEAN COMMENT 'Flag indicating whether this reefer container requires electrical power connection during this rail journey. Used for genset wagon assignment and power capacity planning.',
    `wagon_number` STRING COMMENT 'Identifier of the specific rail wagon (railcar) within the train consist where this container is positioned. Used for physical location tracking and loading plan execution.',
    `wagon_position_number` STRING COMMENT 'Sequential position number of the wagon within the train consist (1, 2, 3, etc.). Used for train composition planning and operational sequencing.',
    CONSTRAINT pk_cargo_rail_wagon_load PRIMARY KEY(`cargo_rail_wagon_load_id`)
) COMMENT 'This association product represents the operational loading event between a container and a rail visit. It captures the physical placement of a specific container onto a specific wagon within a rail train visit, including wagon position, load sequence, securing/lashing instructions, and load/discharge timestamps. Each record represents one containers journey on one rail visit, with attributes that exist only in the context of this specific loading operation.. Existence Justification: In maritime rail intermodal operations, a single rail visit (train) carries multiple containers distributed across multiple wagons, and a single container can be transported on multiple different rail visits over its lifecycle (inbound to port, outbound to inland depot, repositioning moves, transshipment). The rail_wagon_load junction is an operational business entity that rail planners and terminal operators actively manage, tracking wagon position, load sequence, securing equipment, and load/discharge timestamps for each container-on-train movement.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` (
    `container_gate_transaction_id` BIGINT COMMENT 'Unique identifier for this container gate transaction record. Primary key.',
    `container_id` BIGINT COMMENT 'Foreign key linking to the specific container being handled in this gate transaction',
    `port_gate_id` BIGINT COMMENT 'add column infrastructure_port_gate_id (BIGINT) with FK to infrastructure.port_gate.port_gate_id - container gate transactions must identify which physical gate was used',
    `truck_visit_id` BIGINT COMMENT 'Foreign key linking to the specific truck visit during which this container was handled',
    `employee_id` BIGINT COMMENT 'add column workforce_employee_id (BIGINT) with FK to workforce.employee.employee_id - gate transactions require an operator/clerk for accountability',
    `cargo_weight_kg` DECIMAL(18,2) COMMENT 'Verified gross weight of the container and cargo in kilograms, typically measured at the gate via weighbridge. Required for vessel stowage planning and compliance with SOLAS VGM (Verified Gross Mass) regulations. [Moved from truck_visit: While weight is measured at the gate, it is container-specific data. In multi-container visits, each container has its own weight. This should either be in the container product or in the association if its gate-measured weight specific to this transaction.]',
    `container_condition` STRING COMMENT 'Status of the container at the time of this gate transaction indicating whether it is full (loaded), empty (available), or damaged. Relationship-specific because condition is assessed at each gate transaction and may change between visits.',
    `container_size_type` STRING COMMENT 'Standard container size and type code indicating dimensions and special characteristics. Common values include 20GP (20-foot general purpose), 40GP (40-foot general purpose), 40HC (40-foot high cube), 45HC (45-foot high cube), 20RF (20-foot refrigerated), 40RF (40-foot refrigerated). [Moved from truck_visit: This is container master data that should be accessed via the container product FK, not duplicated in truck_visit. In multi-container scenarios, a single attribute cannot represent multiple containers.]. Valid values are `20GP|40GP|40HC|45HC|20RF|40RF`',
    `damage_description` STRING COMMENT 'Free-text description of any observed damage to the container, chassis, or cargo. Populated when damage_report_indicator is true. [Moved from truck_visit: Damage description is specific to a container-visit combination and belongs in the association. Each container may have different damage observations during different visits.]',
    `damage_report_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether visible damage to this container was observed during this specific gate transaction. Relationship-specific because damage may occur or be discovered at different points in the containers journey.',
    `gate_in_time` TIMESTAMP COMMENT 'Timestamp when this specific container completed gate-in processing during this truck visit. Relationship-specific because each container on a multi-container visit may have different processing times.',
    `gate_out_time` TIMESTAMP COMMENT 'Timestamp when this specific container completed gate-out processing during this truck visit. Relationship-specific because each container may be released at different times.',
    `hazmat_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether the container contains hazardous materials requiring special handling and compliance with IMDG (International Maritime Dangerous Goods) Code. [Moved from truck_visit: Hazmat status is container master data (is_hazmat in container product). In multi-container visits, each container has its own hazmat status accessed via FK.]',
    `imdg_class` STRING COMMENT 'IMDG hazard classification code for dangerous goods (e.g., 1.1 for explosives, 3 for flammable liquids, 8 for corrosives). Required when hazmat_indicator is true. [Moved from truck_visit: IMDG classification is container master data that should be accessed via the container product FK, not duplicated in truck_visit.]. Valid values are `^[1-9](.[1-9])?$`',
    `reefer_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether the container is a refrigerated unit requiring temperature-controlled storage and power connection at the terminal. [Moved from truck_visit: Reefer status is container master data (is_reefer in container product) that should be accessed via FK, not duplicated in truck_visit.]',
    `reefer_temperature_celsius` DECIMAL(18,2) COMMENT 'Required temperature setting in degrees Celsius for refrigerated containers. Verified at gate to ensure proper cold chain management. [Moved from truck_visit: Reefer temperature setting is container master data (reefer_set_temp_celsius in container product) that should be accessed via FK, not duplicated in truck_visit.]',
    `seal_number` STRING COMMENT 'Unique identifier of the security seal affixed to the container. Verified at gate-in and gate-out to ensure cargo integrity and detect tampering. [Moved from truck_visit: Seal number is container-specific data that should be accessed via the container product FK. In multi-container visits, each container has its own seal number.]. Valid values are `^[A-Z0-9]{6,20}$`',
    `seal_verification_status` STRING COMMENT 'Result of the container seal inspection at the gate for this specific container during this truck visit. Values: verified (seal intact and matches), broken (seal compromised), missing (no seal present), not_applicable (empty container). Relationship-specific because seal status is assessed per container per visit.',
    `transaction_sequence` BIGINT COMMENT 'Sequence number indicating the order in which this container was processed during a multi-container truck visit (1 for first container, 2 for second, etc.). Null for single-container visits.',
    `turnaround_time_minutes` DECIMAL(18,2) COMMENT 'Time in minutes from gate-in to gate-out for this specific container during this truck visit. Relationship-specific metric used for performance measurement of container handling efficiency.',
    `un_number` STRING COMMENT 'Four-digit UN identification number for hazardous substances (e.g., UN1203 for gasoline). Required for dangerous goods shipments. [Moved from truck_visit: UN number is container master data that should be accessed via the container product FK, not duplicated in truck_visit.]. Valid values are `^UN[0-9]{4}$`',
    CONSTRAINT pk_container_gate_transaction PRIMARY KEY(`container_gate_transaction_id`)
) COMMENT 'This association product represents the gate transaction event between a container and a truck visit. It captures the specific handling details, verification results, and condition assessment that occur when a particular container passes through the gate as part of a specific truck visit. Each record links one container to one truck visit with attributes that exist only in the context of this specific gate transaction.. Existence Justification: In maritime port operations, a single truck visit can handle multiple containers (e.g., a chassis carrying two 20-foot containers, or sequential gate transactions for multiple containers on one truck trip), and each container experiences multiple truck visits throughout its port dwell time (inbound delivery, repositioning moves, outbound pickup). Gate transaction data such as seal verification status, condition assessment, turnaround time, and damage reporting are specific to each container-visit combination and must be tracked per transaction.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` (
    `bol_discount_application_id` BIGINT COMMENT 'Unique identifier for this discount application record. Primary key.',
    `bill_of_lading_id` BIGINT COMMENT 'Foreign key linking to the Bill of Lading to which the discount was applied',
    `discount_scheme_id` BIGINT COMMENT 'Foreign key linking to the discount scheme that was applied',
    `application_date` DATE COMMENT 'The date on which this discount scheme was applied to the BOL, used for temporal tracking and audit trail',
    `application_status` STRING COMMENT 'Current lifecycle status of this discount application: pending (awaiting verification), approved (verified and authorized), rejected (ineligible), applied (discount posted to charges), reversed (discount removed)',
    `applied_by_user` STRING COMMENT 'Username or identifier of the commercial team member who applied this discount to the BOL',
    `approval_reference` STRING COMMENT 'Reference number or identifier for the approval of this discount application, linking to approval workflow or authority documentation',
    `discount_amount_applied` DECIMAL(18,2) COMMENT 'The actual monetary discount amount applied to this BOL under this specific discount scheme, calculated based on the scheme rules and BOL characteristics. Used for revenue reconciliation.',
    `eligibility_verified_flag` BOOLEAN COMMENT 'Indicates whether the BOLs eligibility for this discount scheme has been verified against the schemes qualifying criteria (volume thresholds, customer tier, cargo type restrictions, etc.)',
    `verification_notes` STRING COMMENT 'Free-text notes documenting the verification process, eligibility assessment, or any special circumstances related to this discount application',
    `volume_threshold_met` BOOLEAN COMMENT 'Indicates whether the volume threshold criteria specified in the discount scheme was met by this BOL or the customers cumulative volume at the time of application',
    CONSTRAINT pk_bol_discount_application PRIMARY KEY(`bol_discount_application_id`)
) COMMENT 'This association product represents the application of commercial discount schemes to specific Bills of Lading. It captures which discount schemes were applied to each BOL, the verification of eligibility criteria, the calculated discount amount, and approval details for revenue reconciliation and audit purposes. Each record links one bill_of_lading to one discount_scheme with attributes that exist only in the context of this commercial discount application.. Existence Justification: In maritime port operations, a single Bill of Lading can qualify for and receive multiple discount schemes simultaneously (e.g., a volume discount for high TEU count, a loyalty discount for the shipping lines tier status, and a promotional campaign discount). Conversely, each discount scheme is applied to many different Bills of Lading over time as various shipments meet the eligibility criteria. The commercial/tariff team actively manages these discount applications, verifying eligibility, calculating amounts, obtaining approvals, and tracking them for revenue reconciliation and audit purposes.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` (
    `container_surcharge_application_id` BIGINT COMMENT 'Unique system identifier for this surcharge application record. Primary key.',
    `billing_cycle_id` BIGINT COMMENT 'Identifier for the billing cycle or invoice batch in which this surcharge application was included. Used to group surcharge applications for invoicing.',
    `container_id` BIGINT COMMENT 'Foreign key linking to the container to which this surcharge was applied',
    `employee_id` BIGINT COMMENT 'Identifier of the system user or automated process that applied this surcharge. Used for audit trail and accountability.',
    `surcharge_rule_id` BIGINT COMMENT 'Foreign key linking to the surcharge rule that was applied to this container',
    `application_timestamp` TIMESTAMP COMMENT 'Date and time when this surcharge was applied to the container in the billing system. Used for billing cycle determination and audit purposes.',
    `approval_reference` STRING COMMENT 'Reference number or identifier for the approval or waiver authorization if the surcharge was waived or manually adjusted. Links to approval workflow or authority.',
    `calculation_basis_value` DECIMAL(18,2) COMMENT 'The base value used in the surcharge calculation (e.g., base freight amount, TEU count, weight). Provides audit trail for how surcharge_amount_applied was derived.',
    `calculation_notes` STRING COMMENT 'Free-text notes explaining special circumstances, manual adjustments, or calculation details for this surcharge application. Used for billing dispute resolution.',
    `invoice_line_reference` STRING COMMENT 'Reference to the specific invoice line item where this surcharge appears. Enables reconciliation between surcharge applications and invoices.',
    `surcharge_amount_applied` DECIMAL(18,2) COMMENT 'The calculated surcharge amount applied to this container in the billing currency. This is the result of applying the surcharge rules calculation method to this specific container.',
    `waiver_flag` BOOLEAN COMMENT 'Boolean indicator of whether this surcharge was waived or exempted for this container. True indicates the surcharge was waived (amount may be zero or reduced).',
    CONSTRAINT pk_container_surcharge_application PRIMARY KEY(`container_surcharge_application_id`)
) COMMENT 'This association product represents the application of specific surcharge rules to individual containers during terminal operations and billing cycles. It captures the operational event of applying a surcharge (BAF, CAF, hazmat, oversize, peak season, etc.) to a container, including the calculated amount, calculation basis, timestamp, and any waivers or approvals. Each record links one container to one surcharge rule with attributes that exist only in the context of this billing application.. Existence Justification: In maritime terminal operations, containers routinely incur multiple surcharges simultaneously based on their characteristics and operational context (e.g., a refrigerated oversize container during peak season may incur BAF, CAF, reefer surcharge, oversize surcharge, and peak season surcharge). Conversely, each surcharge rule (BAF, CAF, hazmat, etc.) applies to thousands of containers that meet its applicability criteria. The terminal billing system actively manages these surcharge applications as discrete billing events, tracking the calculated amount, calculation basis, application timestamp, and any waivers for accurate invoicing and dispute resolution.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ADD CONSTRAINT `fk_cargo_manifest_line_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ADD CONSTRAINT `fk_cargo_manifest_line_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ADD CONSTRAINT `fk_cargo_manifest_line_manifest_id` FOREIGN KEY (`manifest_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`manifest`(`manifest_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_stowage_plan_id` FOREIGN KEY (`stowage_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`stowage_plan`(`stowage_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_handling_order_id` FOREIGN KEY (`handling_order_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`handling_order`(`handling_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ADD CONSTRAINT `fk_cargo_stowage_position_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ADD CONSTRAINT `fk_cargo_stowage_position_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ADD CONSTRAINT `fk_cargo_stowage_position_stowage_plan_id` FOREIGN KEY (`stowage_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`stowage_plan`(`stowage_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ADD CONSTRAINT `fk_cargo_container_preadvice_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ADD CONSTRAINT `fk_cargo_container_preadvice_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ADD CONSTRAINT `fk_cargo_container_preadvice_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_original_delivery_order_id` FOREIGN KEY (`original_delivery_order_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ADD CONSTRAINT `fk_cargo_cargo_document_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ADD CONSTRAINT `fk_cargo_cargo_document_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_primary_original_vgm_verified_gross_mass_id` FOREIGN KEY (`primary_original_vgm_verified_gross_mass_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass`(`verified_gross_mass_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ADD CONSTRAINT `fk_cargo_damage_claim_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ADD CONSTRAINT `fk_cargo_damage_claim_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ADD CONSTRAINT `fk_cargo_damage_claim_superseded_damage_claim_id` FOREIGN KEY (`superseded_damage_claim_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`damage_claim`(`damage_claim_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ADD CONSTRAINT `fk_cargo_shipment_tariff_exception_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ADD CONSTRAINT `fk_cargo_cargo_rail_wagon_load_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ADD CONSTRAINT `fk_cargo_container_gate_transaction_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` ADD CONSTRAINT `fk_cargo_bol_discount_application_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ADD CONSTRAINT `fk_cargo_container_surcharge_application_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`cargo` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`cargo` SET TAGS ('dbx_domain' = 'cargo');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` SET TAGS ('dbx_subdomain' = 'shipment_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `cyber_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Cyber Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Discharge Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `packaging_type_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Consignee Party Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Onward Vessel Call Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `tertiary_shipment_port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Shipper Party Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `threat_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Threat Assessment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `trade_restriction_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Restriction Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `bol_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `bol_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10,25}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `cargo_condition` SET TAGS ('dbx_business_glossary_term' = 'Cargo Condition Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `cargo_condition` SET TAGS ('dbx_value_regex' = 'Good|Damaged|Contaminated|Missing|Wet');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `cargo_type` SET TAGS ('dbx_value_regex' = 'FCL|LCL|RoRo|LoLo|Bulk|Breakbulk');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `commodity_description` SET TAGS ('dbx_business_glossary_term' = 'Commodity Description');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `container_count` SET TAGS ('dbx_business_glossary_term' = 'Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `declared_value_usd` SET TAGS ('dbx_business_glossary_term' = 'Declared Cargo Value in United States Dollars (USD)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `declared_value_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `delivery_order_issue_date` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order (D/O) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `discharge_date` SET TAGS ('dbx_business_glossary_term' = 'Cargo Discharge Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `feu_count` SET TAGS ('dbx_business_glossary_term' = 'Forty-foot Equivalent Unit (FEU) Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `final_destination_port_code` SET TAGS ('dbx_business_glossary_term' = 'Final Destination Port Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `final_destination_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `freight_terms` SET TAGS ('dbx_business_glossary_term' = 'Freight Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `freight_terms` SET TAGS ('dbx_value_regex' = 'Prepaid|Collect|Third-Party');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `gate_out_date` SET TAGS ('dbx_business_glossary_term' = 'Gate Out Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `gross_weight_mt` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight in Metric Tons (MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `imdg_class` SET TAGS ('dbx_value_regex' = '^(1|2.1|2.2|2.3|3|4.1|4.2|4.3|5.1|5.2|6.1|6.2|7|8|9)$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `incoterm` SET TAGS ('dbx_business_glossary_term' = 'International Commercial Terms (Incoterms)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_business_glossary_term' = 'Cargo Insurance Policy Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,25}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `is_dangerous_goods` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `is_oversized` SET TAGS ('dbx_business_glossary_term' = 'Oversized Cargo Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `is_reefer` SET TAGS ('dbx_business_glossary_term' = 'Refrigerated Cargo Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `is_transshipment` SET TAGS ('dbx_business_glossary_term' = 'Transshipment Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `net_weight_mt` SET TAGS ('dbx_business_glossary_term' = 'Net Weight in Metric Tons (MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `pod_port_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `pod_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `pol_port_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `pol_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `pre_arrival_notification_date` SET TAGS ('dbx_business_glossary_term' = 'Pre-Arrival Notification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `shipment_status` SET TAGS ('dbx_business_glossary_term' = 'Shipment Lifecycle Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `special_handling_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `stowage_position` SET TAGS ('dbx_business_glossary_term' = 'Vessel Stowage Position');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `stowage_position` SET TAGS ('dbx_value_regex' = '^[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `temperature_setpoint_celsius` SET TAGS ('dbx_business_glossary_term' = 'Temperature Setpoint in Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `teu_count` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Volume in Cubic Meters (CBM)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `yard_location` SET TAGS ('dbx_business_glossary_term' = 'Yard Storage Location');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `yard_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` SET TAGS ('dbx_subdomain' = 'container_management');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Compatible Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `access_event_id` SET TAGS ('dbx_business_glossary_term' = 'Gate In Access Event Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `storage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `condition_grade` SET TAGS ('dbx_business_glossary_term' = 'Container Condition Grade');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `condition_grade` SET TAGS ('dbx_value_regex' = 'A|B|C|D|E');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `container_number` SET TAGS ('dbx_business_glossary_term' = 'Container Number (ISO Format)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `container_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `container_status` SET TAGS ('dbx_business_glossary_term' = 'Container Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `container_status` SET TAGS ('dbx_value_regex' = 'full|empty|damaged|under_repair|retired|in_transit');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `csc_plate_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'CSC (Container Safety Convention) Plate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `cubic_capacity_cbm` SET TAGS ('dbx_business_glossary_term' = 'Cubic Capacity (CBM - Cubic Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `current_location_code` SET TAGS ('dbx_business_glossary_term' = 'Current Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `current_position_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Current Position Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_business_glossary_term' = 'D/O (Delivery Order) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `final_destination_code` SET TAGS ('dbx_business_glossary_term' = 'Final Destination Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `final_destination_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `gate_in_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Gate-In Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `gate_out_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Gate-Out Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `hazmat_certification_number` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials Certification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `height_ft` SET TAGS ('dbx_business_glossary_term' = 'Container Height (Feet)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'IMDG (International Maritime Dangerous Goods) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `is_hazmat` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `is_oversize` SET TAGS ('dbx_business_glossary_term' = 'Oversize Cargo Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `is_overweight` SET TAGS ('dbx_business_glossary_term' = 'Overweight Container Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `is_reefer` SET TAGS ('dbx_business_glossary_term' = 'Reefer Container Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `length_ft` SET TAGS ('dbx_business_glossary_term' = 'Container Length (Feet)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `manufacture_date` SET TAGS ('dbx_business_glossary_term' = 'Container Manufacture Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `max_gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Gross Weight (Kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `max_payload_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Payload Capacity (Kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `operator_code` SET TAGS ('dbx_business_glossary_term' = 'Operator Line Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `operator_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `owner_code` SET TAGS ('dbx_business_glossary_term' = 'Owner Line Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `owner_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `pod_code` SET TAGS ('dbx_business_glossary_term' = 'POD (Port of Discharge) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `pod_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `pol_code` SET TAGS ('dbx_business_glossary_term' = 'POL (Port of Loading) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `pol_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `reefer_plug_required` SET TAGS ('dbx_business_glossary_term' = 'Reefer Plug Requirement Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `reefer_set_temp_celsius` SET TAGS ('dbx_business_glossary_term' = 'Reefer Set Temperature (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Container Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `seal_type` SET TAGS ('dbx_business_glossary_term' = 'Container Seal Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `seal_type` SET TAGS ('dbx_value_regex' = 'bolt|cable|electronic|barrier');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `size_teu` SET TAGS ('dbx_business_glossary_term' = 'Size in TEU (Twenty-foot Equivalent Unit)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `swl_kg` SET TAGS ('dbx_business_glossary_term' = 'SWL (Safe Working Load) in Kilograms');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `tare_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Tare Weight (Kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'UN Number (United Nations Dangerous Goods Number)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `width_ft` SET TAGS ('dbx_business_glossary_term' = 'Container Width (Feet)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` SET TAGS ('dbx_subdomain' = 'shipment_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `packaging_type_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `wharfage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Wharfage Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `amendment_count` SET TAGS ('dbx_business_glossary_term' = 'Amendment Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `bol_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `bol_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `bol_status` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `bol_status` SET TAGS ('dbx_value_regex' = 'draft|issued|amended|surrendered|released|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `bol_type` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `bol_type` SET TAGS ('dbx_value_regex' = 'original|seaway|express|telex_release|surrendered|electronic');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `cargo_description` SET TAGS ('dbx_business_glossary_term' = 'Cargo Description');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `consignee_address` SET TAGS ('dbx_business_glossary_term' = 'Consignee Address');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `consignee_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `consignee_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `consignee_name` SET TAGS ('dbx_business_glossary_term' = 'Consignee Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `consignee_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `container_count` SET TAGS ('dbx_business_glossary_term' = 'Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `freight_amount` SET TAGS ('dbx_business_glossary_term' = 'Freight Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `freight_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `freight_currency` SET TAGS ('dbx_business_glossary_term' = 'Freight Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `freight_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `freight_terms` SET TAGS ('dbx_business_glossary_term' = 'Freight Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `freight_terms` SET TAGS ('dbx_value_regex' = 'prepaid|collect|third_party');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight in Kilograms (kg)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `hs_code` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `hs_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `is_dangerous_goods` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `issuing_agent_name` SET TAGS ('dbx_business_glossary_term' = 'Issuing Agent Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `issuing_carrier_code` SET TAGS ('dbx_business_glossary_term' = 'Issuing Carrier Standard Carrier Alpha Code (SCAC)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `issuing_carrier_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `issuing_carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Issuing Carrier Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `last_amendment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Amendment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `net_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Net Weight in Kilograms (kg)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `notify_party_address` SET TAGS ('dbx_business_glossary_term' = 'Notify Party Address');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `notify_party_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `notify_party_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `notify_party_name` SET TAGS ('dbx_business_glossary_term' = 'Notify Party Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `notify_party_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `package_count` SET TAGS ('dbx_business_glossary_term' = 'Package Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `place_of_delivery` SET TAGS ('dbx_business_glossary_term' = 'Place of Delivery');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `place_of_receipt` SET TAGS ('dbx_business_glossary_term' = 'Place of Receipt');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `pod_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD) UN/LOCODE');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `pod_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `pod_name` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `pol_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL) UN/LOCODE');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `pol_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `pol_name` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL) Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `release_status` SET TAGS ('dbx_business_glossary_term' = 'Cargo Release Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `release_status` SET TAGS ('dbx_value_regex' = 'pending|approved|released|held|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `release_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Release Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `release_type` SET TAGS ('dbx_value_regex' = 'original|telex|express|seaway|electronic');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `shipper_address` SET TAGS ('dbx_business_glossary_term' = 'Shipper Address');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `shipper_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `shipper_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `shipper_name` SET TAGS ('dbx_business_glossary_term' = 'Shipper Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `shipper_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `transhipment_port_1` SET TAGS ('dbx_business_glossary_term' = 'First Transhipment Port');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `transhipment_port_2` SET TAGS ('dbx_business_glossary_term' = 'Second Transhipment Port');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `vessel_imo_number` SET TAGS ('dbx_business_glossary_term' = 'Vessel International Maritime Organization (IMO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `vessel_imo_number` SET TAGS ('dbx_value_regex' = '^IMO[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `vessel_name` SET TAGS ('dbx_business_glossary_term' = 'Vessel Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Volume in Cubic Meters (CBM)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `voyage_number` SET TAGS ('dbx_business_glossary_term' = 'Voyage Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `voyage_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,15}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` SET TAGS ('dbx_subdomain' = 'shipment_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `manifest_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Manifest ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `agent_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Submitting Agent ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `dos_record_id` SET TAGS ('dbx_business_glossary_term' = 'Dos Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `amendment_reason` SET TAGS ('dbx_business_glossary_term' = 'Amendment Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `amendment_version` SET TAGS ('dbx_business_glossary_term' = 'Amendment Version');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `closure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Manifest Closure Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `customs_inspection_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Customs Inspection Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `customs_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `customs_submission_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Submission Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `customs_submission_status` SET TAGS ('dbx_value_regex' = 'pending|submitted|processing|cleared|hold|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `dangerous_goods_flag` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `document_url` SET TAGS ('dbx_business_glossary_term' = 'Manifest Document Uniform Resource Locator (URL)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `document_url` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `empty_container_count` SET TAGS ('dbx_business_glossary_term' = 'Empty Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `fcl_container_count` SET TAGS ('dbx_business_glossary_term' = 'Full Container Load (FCL) Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `high_value_cargo_flag` SET TAGS ('dbx_business_glossary_term' = 'High Value Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `lcl_container_count` SET TAGS ('dbx_business_glossary_term' = 'Less than Container Load (LCL) Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `manifest_number` SET TAGS ('dbx_business_glossary_term' = 'Manifest Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `manifest_status` SET TAGS ('dbx_business_glossary_term' = 'Manifest Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `manifest_type` SET TAGS ('dbx_business_glossary_term' = 'Manifest Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `manifest_type` SET TAGS ('dbx_value_regex' = 'import|export|transshipment|coastal');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `oversized_cargo_flag` SET TAGS ('dbx_business_glossary_term' = 'Oversized Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `pcs_acknowledgement_reference` SET TAGS ('dbx_business_glossary_term' = 'Port Community System (PCS) Acknowledgement Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `pod_port_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `pod_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `pol_port_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `pol_port_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `quarantine_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Quarantine Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `reefer_cargo_flag` SET TAGS ('dbx_business_glossary_term' = 'Reefer Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Submission Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `total_bol_count` SET TAGS ('dbx_business_glossary_term' = 'Total Bill of Lading (BOL) Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `total_container_count` SET TAGS ('dbx_business_glossary_term' = 'Total Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `total_declared_value_usd` SET TAGS ('dbx_business_glossary_term' = 'Total Declared Value United States Dollars (USD)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `total_declared_value_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `total_teu_count` SET TAGS ('dbx_business_glossary_term' = 'Total Twenty-foot Equivalent Unit (TEU) Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `total_volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Total Volume Cubic Meters (CBM)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `total_weight_mt` SET TAGS ('dbx_business_glossary_term' = 'Total Weight Metric Tons (MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `transhipment_container_count` SET TAGS ('dbx_business_glossary_term' = 'Transshipment Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `voyage_number` SET TAGS ('dbx_business_glossary_term' = 'Voyage Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` SET TAGS ('dbx_subdomain' = 'shipment_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `manifest_line_id` SET TAGS ('dbx_business_glossary_term' = 'Manifest Line Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill Of Lading Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `manifest_id` SET TAGS ('dbx_business_glossary_term' = 'Manifest Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `packaging_type_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `cargo_description` SET TAGS ('dbx_business_glossary_term' = 'Cargo Description');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `cargo_value_currency` SET TAGS ('dbx_business_glossary_term' = 'Cargo Value Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `cargo_value_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `cargo_value_usd` SET TAGS ('dbx_business_glossary_term' = 'Cargo Value in United States Dollars (USD)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `cargo_value_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `cargo_value_usd` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `confirmed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `consignee_address` SET TAGS ('dbx_business_glossary_term' = 'Consignee Address');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `consignee_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `consignee_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `consignee_name` SET TAGS ('dbx_business_glossary_term' = 'Consignee Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `consignee_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `container_size_type` SET TAGS ('dbx_business_glossary_term' = 'Container Size and Type Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `container_size_type` SET TAGS ('dbx_value_regex' = '20GP|40GP|40HC|45HC|20RF|40RF');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `customs_declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `customs_declaration_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `customs_declaration_status` SET TAGS ('dbx_value_regex' = 'pending|submitted|cleared|held|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order (D/O) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `freight_terms` SET TAGS ('dbx_business_glossary_term' = 'Freight Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `freight_terms` SET TAGS ('dbx_value_regex' = 'prepaid|collect|third_party');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight in Kilograms (KG)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `imdg_class` SET TAGS ('dbx_value_regex' = '^[1-9](.[1-6])?$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `is_dangerous_goods` SET TAGS ('dbx_business_glossary_term' = 'Is Dangerous Goods Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `is_hazmat` SET TAGS ('dbx_business_glossary_term' = 'Is Hazardous Material (HAZMAT) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `is_oversized` SET TAGS ('dbx_business_glossary_term' = 'Is Oversized Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `is_reefer` SET TAGS ('dbx_business_glossary_term' = 'Is Reefer Container Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `line_sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `load_status` SET TAGS ('dbx_business_glossary_term' = 'Load Status Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `load_status` SET TAGS ('dbx_value_regex' = 'fcl|lcl|breakbulk|roro');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `manifest_line_status` SET TAGS ('dbx_business_glossary_term' = 'Manifest Line Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `manifest_line_status` SET TAGS ('dbx_value_regex' = 'draft|confirmed|loaded|discharged|delivered|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `marks_and_numbers` SET TAGS ('dbx_business_glossary_term' = 'Marks and Numbers');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `package_count` SET TAGS ('dbx_business_glossary_term' = 'Package Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `pod_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `pod_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `pol_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `pol_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Container Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `shipper_address` SET TAGS ('dbx_business_glossary_term' = 'Shipper Address');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `shipper_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `shipper_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `shipper_name` SET TAGS ('dbx_business_glossary_term' = 'Shipper Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `shipper_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `special_handling_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `stowage_position` SET TAGS ('dbx_business_glossary_term' = 'Stowage Position Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `stowage_position` SET TAGS ('dbx_value_regex' = '^[0-9]{3}[0-9]{2}[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `temperature_requirement_celsius` SET TAGS ('dbx_business_glossary_term' = 'Temperature Requirement in Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `teu_equivalent` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Equivalent');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Volume in Cubic Meters (CBM)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` SET TAGS ('dbx_subdomain' = 'container_management');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `handling_order_id` SET TAGS ('dbx_business_glossary_term' = 'Handling Order Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `violation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Violation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `dos_record_id` SET TAGS ('dbx_business_glossary_term' = 'Dos Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `permit_to_work_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Stevedore Gang ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `stowage_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Stowage Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Supervisor Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `thc_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Thc Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `actual_end_datetime` SET TAGS ('dbx_business_glossary_term' = 'Actual End Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `actual_start_datetime` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `billing_status` SET TAGS ('dbx_business_glossary_term' = 'Billing Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `billing_status` SET TAGS ('dbx_value_regex' = 'pending|calculated|invoiced|paid');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `crane_allocation` SET TAGS ('dbx_business_glossary_term' = 'Crane Allocation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `created_datetime` SET TAGS ('dbx_business_glossary_term' = 'Created Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `customs_hold_flag` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `dangerous_goods_flag` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Flag (IMDG)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `equipment_delay_minutes` SET TAGS ('dbx_business_glossary_term' = 'Equipment Delay Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `gross_crane_productivity_target` SET TAGS ('dbx_business_glossary_term' = 'Gross Crane Productivity Target (Moves per Hour)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `hatch_cover_moves` SET TAGS ('dbx_business_glossary_term' = 'Hatch Cover Moves');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `modified_datetime` SET TAGS ('dbx_business_glossary_term' = 'Modified Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `operation_type` SET TAGS ('dbx_business_glossary_term' = 'Operation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `operation_type` SET TAGS ('dbx_value_regex' = 'load|discharge|transship|restow|shift');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `operational_notes` SET TAGS ('dbx_business_glossary_term' = 'Operational Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `order_number` SET TAGS ('dbx_business_glossary_term' = 'Handling Order Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `order_status` SET TAGS ('dbx_business_glossary_term' = 'Handling Order Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `order_status` SET TAGS ('dbx_value_regex' = 'planned|released|in_progress|suspended|completed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `oversized_cargo_flag` SET TAGS ('dbx_business_glossary_term' = 'Oversized Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `planned_end_datetime` SET TAGS ('dbx_business_glossary_term' = 'Planned End Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `planned_start_datetime` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `port_state_control_inspection_flag` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Inspection Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `priority_sequence` SET TAGS ('dbx_business_glossary_term' = 'Priority Sequence');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `reefer_cargo_flag` SET TAGS ('dbx_business_glossary_term' = 'Reefer Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `restow_moves` SET TAGS ('dbx_business_glossary_term' = 'Restow Moves');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `shift_moves` SET TAGS ('dbx_business_glossary_term' = 'Shift Moves');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `shift_reference` SET TAGS ('dbx_business_glossary_term' = 'Shift Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `terminal_delay_minutes` SET TAGS ('dbx_business_glossary_term' = 'Terminal Delay Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `thc_applicable_flag` SET TAGS ('dbx_business_glossary_term' = 'Terminal Handling Charge (THC) Applicable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `total_moves_completed` SET TAGS ('dbx_business_glossary_term' = 'Total Moves Completed');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `total_moves_planned` SET TAGS ('dbx_business_glossary_term' = 'Total Moves Planned');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `total_teu_completed` SET TAGS ('dbx_business_glossary_term' = 'Total Twenty-foot Equivalent Unit (TEU) Completed');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `total_teu_planned` SET TAGS ('dbx_business_glossary_term' = 'Total Twenty-foot Equivalent Unit (TEU) Planned');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `vessel_delay_minutes` SET TAGS ('dbx_business_glossary_term' = 'Vessel Delay Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `weather_delay_minutes` SET TAGS ('dbx_business_glossary_term' = 'Weather Delay Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` SET TAGS ('dbx_subdomain' = 'container_management');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `move_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Move Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `violation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Violation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Gang Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `handling_order_id` SET TAGS ('dbx_business_glossary_term' = 'Handling Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Item Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `ohs_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Ohs Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `permit_to_work_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `shift_pattern_id` SET TAGS ('dbx_business_glossary_term' = 'Work Shift Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `terminal_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `cargo_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Cargo Weight in Kilograms (KG)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `container_size_teu` SET TAGS ('dbx_business_glossary_term' = 'Container Size in Twenty-foot Equivalent Units (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `container_type_iso` SET TAGS ('dbx_business_glossary_term' = 'Container Type ISO Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `container_type_iso` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `customs_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `customs_status` SET TAGS ('dbx_value_regex' = 'cleared|pending|held|inspected|released|bonded');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `damage_reported` SET TAGS ('dbx_business_glossary_term' = 'Damage Reported Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order (D/O) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `destination_location_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `destination_location_type` SET TAGS ('dbx_business_glossary_term' = 'Destination Location Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `destination_location_type` SET TAGS ('dbx_value_regex' = 'vessel|yard|gate|rail|cfs|buffer');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `destination_position` SET TAGS ('dbx_business_glossary_term' = 'Destination Position');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Move Duration in Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `equipment_type` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `exception_code` SET TAGS ('dbx_business_glossary_term' = 'Move Exception Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `exception_description` SET TAGS ('dbx_business_glossary_term' = 'Move Exception Description');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `is_hazardous` SET TAGS ('dbx_business_glossary_term' = 'Is Hazardous Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `is_oversize` SET TAGS ('dbx_business_glossary_term' = 'Is Oversize Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `is_reefer` SET TAGS ('dbx_business_glossary_term' = 'Is Refrigerated Container Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `kind` SET TAGS ('dbx_business_glossary_term' = 'Move Kind');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `kind` SET TAGS ('dbx_value_regex' = 'full|empty|tranship|restow|shifting');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `move_status` SET TAGS ('dbx_business_glossary_term' = 'Move Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `move_type` SET TAGS ('dbx_business_glossary_term' = 'Move Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `origin_location_code` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `origin_location_type` SET TAGS ('dbx_business_glossary_term' = 'Origin Location Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `origin_location_type` SET TAGS ('dbx_value_regex' = 'vessel|yard|gate|rail|cfs|buffer');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `origin_position` SET TAGS ('dbx_business_glossary_term' = 'Origin Position');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `planned_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `port_of_discharge` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `port_of_discharge` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `port_of_loading` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `port_of_loading` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `reefer_temperature_celsius` SET TAGS ('dbx_business_glossary_term' = 'Reefer Temperature in Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Container Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `stage` SET TAGS ('dbx_business_glossary_term' = 'Move Stage');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `transhipment_port` SET TAGS ('dbx_business_glossary_term' = 'Transhipment Port Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `transhipment_port` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` SET TAGS ('dbx_subdomain' = 'container_management');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `stowage_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Stowage Plan ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `primary_stowage_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Planner ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `primary_stowage_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `primary_stowage_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Id');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `vessel_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `baplie_message_reference` SET TAGS ('dbx_business_glossary_term' = 'BAPLIE (Bayplan/Stowage Plan) Message Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `created_datetime` SET TAGS ('dbx_business_glossary_term' = 'Created Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `discharge_count` SET TAGS ('dbx_business_glossary_term' = 'Discharge Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `empty_container_count` SET TAGS ('dbx_business_glossary_term' = 'Empty Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `hazmat_container_count` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `hazmat_segregation_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Segregation Compliant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `laden_container_count` SET TAGS ('dbx_business_glossary_term' = 'Laden Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `last_modified_datetime` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `list_value_degrees` SET TAGS ('dbx_business_glossary_term' = 'List Value in Degrees');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `load_count` SET TAGS ('dbx_business_glossary_term' = 'Load Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `next_port_of_call` SET TAGS ('dbx_business_glossary_term' = 'Next Port of Call');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `next_port_of_call` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `oog_count` SET TAGS ('dbx_business_glossary_term' = 'OOG (Out-of-Gauge) Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `plan_approval_datetime` SET TAGS ('dbx_business_glossary_term' = 'Plan Approval Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `plan_completion_datetime` SET TAGS ('dbx_business_glossary_term' = 'Plan Completion Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `plan_remarks` SET TAGS ('dbx_business_glossary_term' = 'Plan Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_business_glossary_term' = 'Plan Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `plan_submission_datetime` SET TAGS ('dbx_business_glossary_term' = 'Plan Submission Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Plan Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'pre-stow|final|actual|revised');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `plan_version` SET TAGS ('dbx_business_glossary_term' = 'Plan Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `port_of_loading` SET TAGS ('dbx_business_glossary_term' = 'POL (Port of Loading)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `port_of_loading` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `reefer_plug_capacity` SET TAGS ('dbx_business_glossary_term' = 'Reefer Plug Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `reefer_plug_count_used` SET TAGS ('dbx_business_glossary_term' = 'Reefer Plug Count Used');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `restow_count` SET TAGS ('dbx_business_glossary_term' = 'Restow Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `shipping_line_code` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `shipping_line_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `stability_calculation_reference` SET TAGS ('dbx_business_glossary_term' = 'Stability Calculation Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `terminal_operator_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Operator Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `total_feu_loaded` SET TAGS ('dbx_business_glossary_term' = 'Total FEU (Forty-foot Equivalent Unit) Loaded');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `total_teu_capacity` SET TAGS ('dbx_business_glossary_term' = 'Total TEU (Twenty-foot Equivalent Unit) Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `total_teu_loaded` SET TAGS ('dbx_business_glossary_term' = 'Total TEU (Twenty-foot Equivalent Unit) Loaded');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `total_weight_mt` SET TAGS ('dbx_business_glossary_term' = 'Total Weight in Metric Tons (MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `transhipment_container_count` SET TAGS ('dbx_business_glossary_term' = 'Transhipment Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `trim_value_meters` SET TAGS ('dbx_business_glossary_term' = 'Trim Value in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `vessel_imo_number` SET TAGS ('dbx_business_glossary_term' = 'IMO (International Maritime Organization) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `vessel_imo_number` SET TAGS ('dbx_value_regex' = '^IMO[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `voyage_number` SET TAGS ('dbx_business_glossary_term' = 'Voyage Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` SET TAGS ('dbx_subdomain' = 'container_management');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `stowage_position_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Stowage Position ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill Of Lading Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Slot Operator ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Shipper ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `stowage_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Stowage Plan ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `bay_number` SET TAGS ('dbx_business_glossary_term' = 'Bay Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `bay_number` SET TAGS ('dbx_value_regex' = '^[0-9]{2,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `booking_reference` SET TAGS ('dbx_business_glossary_term' = 'Booking Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `cargo_type` SET TAGS ('dbx_value_regex' = 'FCL|LCL|empty|special');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `confirmed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `container_height_mm` SET TAGS ('dbx_business_glossary_term' = 'Container Height (MM)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `container_size_type` SET TAGS ('dbx_business_glossary_term' = 'Container Size Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `container_size_type` SET TAGS ('dbx_value_regex' = '^[0-9A-Z]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `container_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Container Weight (KG)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `discharged_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Discharged Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `hs_code` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `hs_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `imdg_class` SET TAGS ('dbx_value_regex' = '^[1-9](.[1-6])?$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `iso_position_code` SET TAGS ('dbx_business_glossary_term' = 'ISO Position Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `iso_position_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `lashing_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Lashing Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `loaded_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Loaded Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `oog_flag` SET TAGS ('dbx_business_glossary_term' = 'Out of Gauge (OOG) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `overhang_aft_mm` SET TAGS ('dbx_business_glossary_term' = 'Overhang Aft (MM)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `overhang_fore_mm` SET TAGS ('dbx_business_glossary_term' = 'Overhang Fore (MM)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `overhang_height_mm` SET TAGS ('dbx_business_glossary_term' = 'Overhang Height (MM)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `overhang_port_mm` SET TAGS ('dbx_business_glossary_term' = 'Overhang Port (MM)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `overhang_starboard_mm` SET TAGS ('dbx_business_glossary_term' = 'Overhang Starboard (MM)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `planned_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `pod_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `pod_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `pol_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `pol_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `position_status` SET TAGS ('dbx_business_glossary_term' = 'Position Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `position_status` SET TAGS ('dbx_value_regex' = 'planned|confirmed|loaded|discharged|restowed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `reefer_flag` SET TAGS ('dbx_business_glossary_term' = 'Reefer Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Stowage Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `row_number` SET TAGS ('dbx_business_glossary_term' = 'Row Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `row_number` SET TAGS ('dbx_value_regex' = '^[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `stowage_category` SET TAGS ('dbx_business_glossary_term' = 'Stowage Category');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `stowage_category` SET TAGS ('dbx_value_regex' = 'deck|hold|underdeck|hatch');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `temperature_setting_celsius` SET TAGS ('dbx_business_glossary_term' = 'Temperature Setting (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `tier_number` SET TAGS ('dbx_business_glossary_term' = 'Tier Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `tier_number` SET TAGS ('dbx_value_regex' = '^[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `transhipment_flag` SET TAGS ('dbx_business_glossary_term' = 'Transhipment Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ALTER COLUMN `ventilation_setting_cbm_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Ventilation Setting (CBM per Hour)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` SET TAGS ('dbx_subdomain' = 'hazardous_cargo');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `dangerous_goods_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Declaration (DGD) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill Of Lading Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Declarant Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `emergency_response_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Emergency Response Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `hazard_register_id` SET TAGS ('dbx_business_glossary_term' = 'Hazard Register Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `packaging_type_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `risk_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `trade_restriction_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Restriction Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `acceptance_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Port Authority Acceptance Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `declarant_email` SET TAGS ('dbx_business_glossary_term' = 'Declarant Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `declarant_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `declarant_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `declarant_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `declaration_date` SET TAGS ('dbx_business_glossary_term' = 'Declaration Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `declaration_place` SET TAGS ('dbx_business_glossary_term' = 'Declaration Place');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `dgd_number` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Declaration (DGD) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `ems_code` SET TAGS ('dbx_business_glossary_term' = 'Emergency Schedule (EMS) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `ems_code` SET TAGS ('dbx_value_regex' = '^F-[A-Z],[S-[A-Z]$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `excepted_quantity_flag` SET TAGS ('dbx_business_glossary_term' = 'Excepted Quantity (EQ) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `flash_point_celsius` SET TAGS ('dbx_business_glossary_term' = 'Flash Point (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `gross_quantity` SET TAGS ('dbx_business_glossary_term' = 'Gross Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `imdg_class` SET TAGS ('dbx_value_regex' = '1|1.1|1.2|1.3|1.4|1.5|1.6|2.1|2.2|2.3|3|4.1|4.2|4.3|5.1|5.2|6.1|6.2|7|8|9');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `imdg_subsidiary_risk` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Subsidiary Risk');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `inspection_completed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Inspection Completed Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `inspection_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Physical Inspection Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `limited_quantity_flag` SET TAGS ('dbx_business_glossary_term' = 'Limited Quantity (LQ) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `marine_pollutant_flag` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollutant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `mfag_reference` SET TAGS ('dbx_business_glossary_term' = 'Medical First Aid Guide (MFAG) Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `net_quantity` SET TAGS ('dbx_business_glossary_term' = 'Net Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `number_of_packages` SET TAGS ('dbx_business_glossary_term' = 'Number of Packages');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `packing_group` SET TAGS ('dbx_business_glossary_term' = 'Packing Group (PG)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `packing_group` SET TAGS ('dbx_value_regex' = 'I|II|III');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `pod_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `pod_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `pol_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `pol_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `port_authority_acceptance_status` SET TAGS ('dbx_business_glossary_term' = 'Port Authority Acceptance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `port_authority_acceptance_status` SET TAGS ('dbx_value_regex' = 'pending|accepted|rejected|conditional|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `proper_shipping_name` SET TAGS ('dbx_business_glossary_term' = 'Proper Shipping Name (PSN)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_value_regex' = 'kg|L|m3|tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `segregation_group` SET TAGS ('dbx_business_glossary_term' = 'Segregation Group');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `special_provisions` SET TAGS ('dbx_business_glossary_term' = 'Special Provisions (SP)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `stowage_category` SET TAGS ('dbx_business_glossary_term' = 'Stowage Category');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `stowage_category` SET TAGS ('dbx_value_regex' = 'A|B|C|D|E');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `stowage_position` SET TAGS ('dbx_business_glossary_term' = 'Stowage Position');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `technical_name` SET TAGS ('dbx_business_glossary_term' = 'Technical Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `voyage_number` SET TAGS ('dbx_business_glossary_term' = 'Voyage Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` SET TAGS ('dbx_subdomain' = 'container_management');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `container_preadvice_id` SET TAGS ('dbx_business_glossary_term' = 'Container Preadvice Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill Of Lading Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `screening_record_id` SET TAGS ('dbx_business_glossary_term' = 'Screening Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `cargo_status` SET TAGS ('dbx_business_glossary_term' = 'Cargo Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `cargo_status` SET TAGS ('dbx_value_regex' = 'full|empty|laden|unladen');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `container_iso_type_code` SET TAGS ('dbx_business_glossary_term' = 'Container ISO Type Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `container_iso_type_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `container_size_feet` SET TAGS ('dbx_business_glossary_term' = 'Container Size in Feet');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `container_type_description` SET TAGS ('dbx_business_glossary_term' = 'Container Type Description');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `customs_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `customs_status` SET TAGS ('dbx_value_regex' = 'cleared|pending|hold|inspection_required|released');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `dangerous_goods_flag` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `expected_arrival_datetime` SET TAGS ('dbx_business_glossary_term' = 'Expected Arrival Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `expected_arrival_window_end` SET TAGS ('dbx_business_glossary_term' = 'Expected Arrival Window End');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `expected_arrival_window_start` SET TAGS ('dbx_business_glossary_term' = 'Expected Arrival Window Start');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `final_destination_code` SET TAGS ('dbx_business_glossary_term' = 'Final Destination Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `final_destination_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight in Kilograms');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `message_datetime` SET TAGS ('dbx_business_glossary_term' = 'Message Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `message_function_code` SET TAGS ('dbx_business_glossary_term' = 'Message Function Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `message_function_code` SET TAGS ('dbx_value_regex' = 'original|cancellation|replacement|addition|deletion');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `message_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Message Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `message_version` SET TAGS ('dbx_business_glossary_term' = 'Message Version');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `operation_type` SET TAGS ('dbx_business_glossary_term' = 'Operation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `oversized_flag` SET TAGS ('dbx_business_glossary_term' = 'Oversized Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `pod_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `pod_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `pol_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `pol_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `processed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Processed Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `processing_status` SET TAGS ('dbx_business_glossary_term' = 'Processing Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `processing_status` SET TAGS ('dbx_value_regex' = 'received|validated|accepted|rejected|processed|error');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `received_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Received Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `receiving_terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Receiving Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `receiving_terminal_name` SET TAGS ('dbx_business_glossary_term' = 'Receiving Terminal Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `reefer_flag` SET TAGS ('dbx_business_glossary_term' = 'Refrigerated Container (Reefer) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `sending_party_code` SET TAGS ('dbx_business_glossary_term' = 'Sending Party Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `sending_party_name` SET TAGS ('dbx_business_glossary_term' = 'Sending Party Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `special_handling_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `temperature_setpoint_celsius` SET TAGS ('dbx_business_glossary_term' = 'Temperature Setpoint in Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `teu_equivalent` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Equivalent');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `validation_error_message` SET TAGS ('dbx_business_glossary_term' = 'Validation Error Message');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ALTER COLUMN `vgm_verified_flag` SET TAGS ('dbx_business_glossary_term' = 'Verified Gross Mass (VGM) Verified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` SET TAGS ('dbx_subdomain' = 'shipment_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Delivery Order (D/O) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `access_event_id` SET TAGS ('dbx_business_glossary_term' = 'Access Event Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `contact_person_id` SET TAGS ('dbx_business_glossary_term' = 'Authorized Collector ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `import_export_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Import Export Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Issuing Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `original_delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Original Delivery Order (D/O) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Issuing Agent ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `visitor_log_id` SET TAGS ('dbx_business_glossary_term' = 'Visitor Log Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `authorized_collector_id_number` SET TAGS ('dbx_business_glossary_term' = 'Authorized Collector Identification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `authorized_collector_id_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `authorized_collector_id_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `authorized_collector_name` SET TAGS ('dbx_business_glossary_term' = 'Authorized Collector Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `authorized_collector_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `authorized_collector_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `cancellation_datetime` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order (D/O) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `delivery_order_status` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order (D/O) Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `delivery_order_status` SET TAGS ('dbx_value_regex' = 'issued|presented|released|expired|cancelled|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `demurrage_cleared_flag` SET TAGS ('dbx_business_glossary_term' = 'Demurrage (DMG) Cleared Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `detention_cleared_flag` SET TAGS ('dbx_business_glossary_term' = 'Detention (DET) Cleared Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `freight_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'Freight Clearance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `freight_clearance_status` SET TAGS ('dbx_value_regex' = 'cleared|pending|outstanding|waived');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `port_dues_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'Port Dues Clearance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `port_dues_clearance_status` SET TAGS ('dbx_value_regex' = 'cleared|pending|outstanding|waived');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `port_of_discharge_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `port_of_discharge_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `presentation_datetime` SET TAGS ('dbx_business_glossary_term' = 'Presentation Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `release_datetime` SET TAGS ('dbx_business_glossary_term' = 'Release Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `release_location` SET TAGS ('dbx_business_glossary_term' = 'Release Location');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `release_location` SET TAGS ('dbx_value_regex' = 'gate|cy|cfs|warehouse|berth');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `release_type` SET TAGS ('dbx_business_glossary_term' = 'Release Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `release_type` SET TAGS ('dbx_value_regex' = 'full|partial');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `revalidation_count` SET TAGS ('dbx_business_glossary_term' = 'Revalidation Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `terminal_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `validity_date` SET TAGS ('dbx_business_glossary_term' = 'Validity Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `vehicle_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `vehicle_registration_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` SET TAGS ('dbx_subdomain' = 'billing_exceptions');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `demurrage_detention_id` SET TAGS ('dbx_business_glossary_term' = 'Demurrage Detention ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `demurrage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Demurrage Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `demurrage_terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `detention_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Detention Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `bol_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `calculation_method` SET TAGS ('dbx_business_glossary_term' = 'Calculation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `calculation_method` SET TAGS ('dbx_value_regex' = 'calendar_days|working_days|tiered_rate');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `cargo_type` SET TAGS ('dbx_value_regex' = 'FCL|LCL|breakbulk|dangerous');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `charge_status` SET TAGS ('dbx_business_glossary_term' = 'Charge Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `charge_stop_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Charge Stop Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `charge_type` SET TAGS ('dbx_business_glossary_term' = 'Charge Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `charge_type` SET TAGS ('dbx_value_regex' = 'demurrage|detention|combined');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `chargeable_event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Chargeable Event Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `container_size_type` SET TAGS ('dbx_business_glossary_term' = 'Container Size Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `container_size_type` SET TAGS ('dbx_value_regex' = '20GP|40GP|40HC|45HC|20RF|40RF');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `daily_rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Daily Rate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `days_exceeded` SET TAGS ('dbx_business_glossary_term' = 'Days Exceeded');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `dispute_flag` SET TAGS ('dbx_business_glossary_term' = 'Dispute Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `dispute_raised_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Raised Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Dispute Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `dispute_resolved_date` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolved Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `free_time_days` SET TAGS ('dbx_business_glossary_term' = 'Free Time Days');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `free_time_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Free Time End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `free_time_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Free Time Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `net_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `payment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `payment_received_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Received Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `pod_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `pod_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `pol_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `pol_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `settlement_status` SET TAGS ('dbx_business_glossary_term' = 'Settlement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `settlement_status` SET TAGS ('dbx_value_regex' = 'outstanding|partial|settled|overdue');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `total_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `waiver_amount` SET TAGS ('dbx_business_glossary_term' = 'Waiver Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `waiver_approval_date` SET TAGS ('dbx_business_glossary_term' = 'Waiver Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `waiver_approved_by` SET TAGS ('dbx_business_glossary_term' = 'Waiver Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `waiver_reason` SET TAGS ('dbx_business_glossary_term' = 'Waiver Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` SET TAGS ('dbx_subdomain' = 'shipment_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `lcl_consolidation_id` SET TAGS ('dbx_business_glossary_term' = 'Less than Container Load (LCL) Consolidation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Operator ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Master Bill Of Lading Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `packaging_type_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Forwarder ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Container Freight Station (CFS) Location ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `thc_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Thc Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `actual_completion_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Completion Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `commodity_mix` SET TAGS ('dbx_business_glossary_term' = 'Commodity Mix');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `consolidation_job_number` SET TAGS ('dbx_business_glossary_term' = 'Consolidation Job Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `consolidation_job_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `container_size_type` SET TAGS ('dbx_business_glossary_term' = 'Container Size and Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `container_size_type` SET TAGS ('dbx_value_regex' = '20GP|40GP|40HC|45HC');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `contains_dangerous_goods` SET TAGS ('dbx_business_glossary_term' = 'Contains Dangerous Goods Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `delivery_order_issued` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order (D/O) Issued Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `destination_location` SET TAGS ('dbx_business_glossary_term' = 'Destination Location');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `destination_location` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `equipment_used` SET TAGS ('dbx_business_glossary_term' = 'Equipment Used');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `house_bol_count` SET TAGS ('dbx_business_glossary_term' = 'House Bill of Lading (BOL) Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `inspection_notes` SET TAGS ('dbx_business_glossary_term' = 'Inspection Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `job_status` SET TAGS ('dbx_business_glossary_term' = 'Job Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `job_status` SET TAGS ('dbx_value_regex' = 'planned|in_progress|completed|cancelled|on_hold');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `job_type` SET TAGS ('dbx_business_glossary_term' = 'Job Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `job_type` SET TAGS ('dbx_value_regex' = 'consolidation|deconsolidation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `origin_location` SET TAGS ('dbx_business_glossary_term' = 'Origin Location');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `origin_location` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `planned_stripping_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Stripping Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `planned_stuffing_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Stuffing Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `quality_inspection_completed` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Completed Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `seal_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `special_handling_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `terminal_handling_charge_applied` SET TAGS ('dbx_business_glossary_term' = 'Terminal Handling Charge (THC) Applied Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `total_cargo_volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Total Cargo Volume in Cubic Meters (CBM)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ALTER COLUMN `total_cargo_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Total Cargo Weight in Kilograms (KG)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` SET TAGS ('dbx_subdomain' = 'shipment_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `cargo_document_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Document ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Document Holder Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `packaging_type_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Verifying Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `commodity_description` SET TAGS ('dbx_business_glossary_term' = 'Commodity Description');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `country_of_issue` SET TAGS ('dbx_business_glossary_term' = 'Country of Issue');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `country_of_issue` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `customs_clearance_status` SET TAGS ('dbx_value_regex' = 'pending|cleared|held|released|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `customs_entry_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Entry Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `declared_value` SET TAGS ('dbx_business_glossary_term' = 'Declared Value');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `digital_copy_reference` SET TAGS ('dbx_business_glossary_term' = 'Digital Copy Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `document_status` SET TAGS ('dbx_business_glossary_term' = 'Document Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `document_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|accepted|rejected|expired|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Document Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `duty_amount` SET TAGS ('dbx_business_glossary_term' = 'Duty Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight (Kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `is_original` SET TAGS ('dbx_business_glossary_term' = 'Is Original Document');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `issuing_authority_code` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `net_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Net Weight (Kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `package_count` SET TAGS ('dbx_business_glossary_term' = 'Package Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Submission Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `submitted_by` SET TAGS ('dbx_business_glossary_term' = 'Submitted By');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `treatment_date` SET TAGS ('dbx_business_glossary_term' = 'Treatment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `treatment_type` SET TAGS ('dbx_business_glossary_term' = 'Treatment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Verification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `verification_status` SET TAGS ('dbx_business_glossary_term' = 'Verification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `verification_status` SET TAGS ('dbx_value_regex' = 'pending|verified|failed|not_required');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ALTER COLUMN `volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Volume (Cubic Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` SET TAGS ('dbx_subdomain' = 'hazardous_cargo');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `verified_gross_mass_id` SET TAGS ('dbx_business_glossary_term' = 'Verified Gross Mass (VGM) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Weighing Equipment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Shipper ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `primary_original_vgm_verified_gross_mass_id` SET TAGS ('dbx_business_glossary_term' = 'Original Verified Gross Mass (VGM) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `weighing_station_id` SET TAGS ('dbx_business_glossary_term' = 'Weighing Station ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `amendment_reason` SET TAGS ('dbx_business_glossary_term' = 'Amendment Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `amendment_version` SET TAGS ('dbx_business_glossary_term' = 'Amendment Version');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `authorized_signatory_contact` SET TAGS ('dbx_business_glossary_term' = 'Authorized Signatory Contact');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `authorized_signatory_contact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `authorized_signatory_contact` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `authorized_signatory_name` SET TAGS ('dbx_business_glossary_term' = 'Authorized Signatory Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `authorized_signatory_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `authorized_signatory_title` SET TAGS ('dbx_business_glossary_term' = 'Authorized Signatory Title');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `bol_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `edi_message_reference` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Message Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `gross_mass_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Mass in Kilograms (KG)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `pcs_submission_reference` SET TAGS ('dbx_business_glossary_term' = 'Port Community System (PCS) Submission Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `pod_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `pol_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `shipper_name` SET TAGS ('dbx_business_glossary_term' = 'Shipper Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `shipper_reference` SET TAGS ('dbx_business_glossary_term' = 'Shipper Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `shipping_line_acknowledgement_reference` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Acknowledgement Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `submission_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Submission Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `submission_datetime` SET TAGS ('dbx_business_glossary_term' = 'Submission Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `submission_deadline` SET TAGS ('dbx_business_glossary_term' = 'Submission Deadline');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `verification_status` SET TAGS ('dbx_business_glossary_term' = 'Verification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `verification_status` SET TAGS ('dbx_value_regex' = 'pending|verified|rejected|expired|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `vessel_imo_number` SET TAGS ('dbx_business_glossary_term' = 'Vessel International Maritime Organization (IMO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `vessel_name` SET TAGS ('dbx_business_glossary_term' = 'Vessel Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `vgm_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Verified Gross Mass (VGM) Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `voyage_number` SET TAGS ('dbx_business_glossary_term' = 'Voyage Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `weighing_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Weighing Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `weighing_datetime` SET TAGS ('dbx_business_glossary_term' = 'Weighing Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `weighing_facility_name` SET TAGS ('dbx_business_glossary_term' = 'Weighing Facility Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `weighing_method` SET TAGS ('dbx_business_glossary_term' = 'Weighing Method');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `weighing_method` SET TAGS ('dbx_value_regex' = 'Method 1|Method 2');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` SET TAGS ('dbx_subdomain' = 'billing_exceptions');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `damage_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Damage Claim ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill Of Lading Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Claimant Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `violation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Violation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `provision_id` SET TAGS ('dbx_business_glossary_term' = 'Provision Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Asset Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `superseded_damage_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded Damage Claim Id');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `superseded_damage_claim_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `cargo_description` SET TAGS ('dbx_business_glossary_term' = 'Cargo Description');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claim_lodgement_date` SET TAGS ('dbx_business_glossary_term' = 'Claim Lodgement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claim_lodgement_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Claim Lodgement Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claim_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Claim Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claim_status` SET TAGS ('dbx_business_glossary_term' = 'Claim Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claim_status` SET TAGS ('dbx_value_regex' = 'lodged|under-investigation|accepted|rejected|settled|withdrawn');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claimant_address` SET TAGS ('dbx_business_glossary_term' = 'Claimant Address');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claimant_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claimant_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claimant_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Claimant Contact Email');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claimant_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claimant_contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claimant_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claimant_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Claimant Contact Phone');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claimant_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claimant_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claimant_type` SET TAGS ('dbx_business_glossary_term' = 'Claimant Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `claimant_type` SET TAGS ('dbx_value_regex' = 'shipping-line|cargo-owner|freight-forwarder|insurer|consignee|shipper');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'Closure Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `damage_description` SET TAGS ('dbx_business_glossary_term' = 'Damage Description');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `damage_discovery_location` SET TAGS ('dbx_business_glossary_term' = 'Damage Discovery Location');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `damage_discovery_location` SET TAGS ('dbx_value_regex' = 'vessel|yard|gate|cfs|berth|warehouse');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `damage_discovery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Damage Discovery Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `damage_type` SET TAGS ('dbx_business_glossary_term' = 'Damage Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `damage_type` SET TAGS ('dbx_value_regex' = 'physical-damage|contamination|shortage|pilferage|water-damage|temperature-excursion');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `estimated_loss_value` SET TAGS ('dbx_business_glossary_term' = 'Estimated Loss Value');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `estimated_loss_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `estimated_loss_value` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight (kg)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `hs_code` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `inspection_record_reference` SET TAGS ('dbx_business_glossary_term' = 'Inspection Record Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `insurer_claim_reference` SET TAGS ('dbx_business_glossary_term' = 'Insurer Claim Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `insurer_name` SET TAGS ('dbx_business_glossary_term' = 'Insurer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `insurer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `liability_assessment` SET TAGS ('dbx_business_glossary_term' = 'Liability Assessment');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `liability_assessment` SET TAGS ('dbx_value_regex' = 'port-liable|stevedore-liable|carrier-liable|force-majeure|under-review|no-liability');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `liability_assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Liability Assessment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `liability_assessor_name` SET TAGS ('dbx_business_glossary_term' = 'Liability Assessor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `package_count` SET TAGS ('dbx_business_glossary_term' = 'Package Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `photographic_evidence_url` SET TAGS ('dbx_business_glossary_term' = 'Photographic Evidence URL');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `pod_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `pod_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `pol_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `pol_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `settlement_amount` SET TAGS ('dbx_business_glossary_term' = 'Settlement Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `settlement_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `settlement_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Settlement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `stevedore_company_name` SET TAGS ('dbx_business_glossary_term' = 'Stevedore Company Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `survey_report_reference` SET TAGS ('dbx_business_glossary_term' = 'Survey Report Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ALTER COLUMN `terminal_operator_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Operator Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` SET TAGS ('dbx_subdomain' = 'billing_exceptions');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` SET TAGS ('dbx_association_edges' = 'cargo.shipment,tariff.tariff_exception');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `shipment_tariff_exception_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Tariff Exception - Shipment Tariff Exception Id');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Applied By Employee');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `exception_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Tariff Exception - Tariff Exception Id');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Tariff Exception - Shipment Id');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `application_date` SET TAGS ('dbx_business_glossary_term' = 'Exception Application Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `application_justification` SET TAGS ('dbx_business_glossary_term' = 'Application Justification');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `application_status` SET TAGS ('dbx_business_glossary_term' = 'Application Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `applied_discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Applied Discount Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `applied_exception_rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Applied Exception Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `applied_free_days_granted` SET TAGS ('dbx_business_glossary_term' = 'Applied Free Days');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `applied_waiver_amount` SET TAGS ('dbx_business_glossary_term' = 'Applied Waiver Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approving Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Exception Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Exception Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ALTER COLUMN `revenue_impact_amount` SET TAGS ('dbx_business_glossary_term' = 'Revenue Impact');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` SET TAGS ('dbx_subdomain' = 'container_management');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` SET TAGS ('dbx_association_edges' = 'cargo.container,intermodal.rail_visit');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `cargo_rail_wagon_load_id` SET TAGS ('dbx_business_glossary_term' = 'cargo_rail_wagon_load Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Discharge Operator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `cargo_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Loading Operator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `cargo_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `cargo_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Wagon Load - Container Id');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `intermodal_rail_wagon_load_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Wagon Load ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Wagon Load - Rail Visit Id');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `actual_discharge_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Discharge Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `actual_load_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Load Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `is_hazmat_load` SET TAGS ('dbx_business_glossary_term' = 'Hazmat Load Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `is_overweight_load` SET TAGS ('dbx_business_glossary_term' = 'Overweight Load Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `lashing_equipment_used` SET TAGS ('dbx_business_glossary_term' = 'Lashing Equipment Used');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `lashing_instructions` SET TAGS ('dbx_business_glossary_term' = 'Lashing Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `load_remarks` SET TAGS ('dbx_business_glossary_term' = 'Load Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `load_sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Load Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `load_status` SET TAGS ('dbx_business_glossary_term' = 'Load Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `load_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Load Weight');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `planned_load_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Load Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `requires_reefer_power` SET TAGS ('dbx_business_glossary_term' = 'Reefer Power Required');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `wagon_number` SET TAGS ('dbx_business_glossary_term' = 'Wagon Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ALTER COLUMN `wagon_position_number` SET TAGS ('dbx_business_glossary_term' = 'Wagon Position Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` SET TAGS ('dbx_subdomain' = 'container_management');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` SET TAGS ('dbx_association_edges' = 'cargo.container,intermodal.truck_visit');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `container_gate_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Container Gate Transaction ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Gate Transaction - Container Id');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `truck_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Gate Transaction - Truck Visit Id');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `cargo_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Cargo Weight (Kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `container_condition` SET TAGS ('dbx_business_glossary_term' = 'Container Condition at Gate');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `container_size_type` SET TAGS ('dbx_business_glossary_term' = 'Container Size Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `container_size_type` SET TAGS ('dbx_value_regex' = '20GP|40GP|40HC|45HC|20RF|40RF');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `damage_description` SET TAGS ('dbx_business_glossary_term' = 'Damage Description');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `damage_report_indicator` SET TAGS ('dbx_business_glossary_term' = 'Damage Report Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `gate_in_time` SET TAGS ('dbx_business_glossary_term' = 'Gate In Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `gate_out_time` SET TAGS ('dbx_business_glossary_term' = 'Gate Out Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `hazmat_indicator` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `imdg_class` SET TAGS ('dbx_value_regex' = '^[1-9](.[1-9])?$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `reefer_indicator` SET TAGS ('dbx_business_glossary_term' = 'Refrigerated Container (Reefer) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `reefer_temperature_celsius` SET TAGS ('dbx_business_glossary_term' = 'Reefer Temperature (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `seal_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `seal_verification_status` SET TAGS ('dbx_business_glossary_term' = 'Seal Verification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `transaction_sequence` SET TAGS ('dbx_business_glossary_term' = 'Transaction Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `turnaround_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Container Turnaround Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` SET TAGS ('dbx_subdomain' = 'billing_exceptions');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` SET TAGS ('dbx_association_edges' = 'cargo.bill_of_lading,tariff.discount_scheme');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` ALTER COLUMN `bol_discount_application_id` SET TAGS ('dbx_business_glossary_term' = 'BOL Discount Application ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bol Discount Application - Bill Of Lading Id');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` ALTER COLUMN `discount_scheme_id` SET TAGS ('dbx_business_glossary_term' = 'Bol Discount Application - Discount Scheme Id');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` ALTER COLUMN `application_date` SET TAGS ('dbx_business_glossary_term' = 'Application Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` ALTER COLUMN `application_status` SET TAGS ('dbx_business_glossary_term' = 'Application Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` ALTER COLUMN `applied_by_user` SET TAGS ('dbx_business_glossary_term' = 'Applied By User');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` ALTER COLUMN `approval_reference` SET TAGS ('dbx_business_glossary_term' = 'Approval Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` ALTER COLUMN `discount_amount_applied` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount Applied');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` ALTER COLUMN `eligibility_verified_flag` SET TAGS ('dbx_business_glossary_term' = 'Eligibility Verified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` ALTER COLUMN `verification_notes` SET TAGS ('dbx_business_glossary_term' = 'Verification Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` ALTER COLUMN `volume_threshold_met` SET TAGS ('dbx_business_glossary_term' = 'Volume Threshold Met');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` SET TAGS ('dbx_subdomain' = 'billing_exceptions');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` SET TAGS ('dbx_association_edges' = 'cargo.container,tariff.surcharge_rule');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ALTER COLUMN `container_surcharge_application_id` SET TAGS ('dbx_business_glossary_term' = 'Container Surcharge Application ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ALTER COLUMN `billing_cycle_id` SET TAGS ('dbx_business_glossary_term' = 'Billing Cycle ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Surcharge Application - Container Id');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Applied By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ALTER COLUMN `surcharge_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Container Surcharge Application - Surcharge Rule Id');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ALTER COLUMN `application_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Application Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ALTER COLUMN `approval_reference` SET TAGS ('dbx_business_glossary_term' = 'Approval Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ALTER COLUMN `calculation_basis_value` SET TAGS ('dbx_business_glossary_term' = 'Calculation Basis Value');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ALTER COLUMN `calculation_notes` SET TAGS ('dbx_business_glossary_term' = 'Calculation Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ALTER COLUMN `invoice_line_reference` SET TAGS ('dbx_business_glossary_term' = 'Invoice Line Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ALTER COLUMN `surcharge_amount_applied` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Amount Applied');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ALTER COLUMN `waiver_flag` SET TAGS ('dbx_business_glossary_term' = 'Waiver Flag');
