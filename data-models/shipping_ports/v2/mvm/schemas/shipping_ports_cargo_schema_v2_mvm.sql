-- Schema for Domain: cargo | Business: Shipping_Ports | Version: v2_mvm
-- Generated on: 2026-07-13 10:24:15

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`cargo` COMMENT 'Manages cargo handling, loading/discharge operations, stowage planning (BAPLIE), dangerous goods (IMDG), FCL/LCL management, BOL processing, and cargo documentation. Covers cargo manifests, POL/POD tracking, container pre-announcement (COPARN), delivery orders (D/O), HS Code assignment, and cargo condition monitoring. SSOT for cargo movement and handling data.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` (
    `shipment_id` BIGINT COMMENT 'Unique identifier for the cargo shipment consignment moving through the port. Primary key for the shipment entity. System-generated surrogate key used across all port systems to track this cargo movement from pre-arrival notification through final delivery or transshipment.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Cargo shipments reference commodity codes for classification, tariff determination, and regulatory compliance. Currently shipment has hs_code as a string. Adding FK to masterdata.commodity_code enable',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Shipments must be screened against trade restrictions (embargoes, sanctions, prohibited goods). Real regulatory requirement: export control compliance, sanctions enforcement. Booking systems verify sh',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Shipments are cleared by customs brokers. Real business process: broker assignment, declaration submission, clearance coordination. Shippers appoint brokers per shipment; port community systems track ',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Shipments are discharged at specific berths; essential for vessel operations planning, berth allocation, and cargo tracking. Port operators must know which berth each shipment was handled at for opera',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.packaging_type. Business justification: Shipments declare package types for customs compliance, SOLAS VGM validation, and dangerous goods packaging verification. Linking to packaging_type master enables automated validation of IMDG packagin',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: High-risk shipments (origin, commodity, shipper profile) trigger threat assessments under ISPS Code. Links shipment to formal threat evaluation, enabling risk-based cargo screening, enhanced security ',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Shipments operate under service agreements with shipping lines or terminal operators defining rates, service levels, and terms. Essential for billing validation, rate application, and SLA tracking in ',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Shipment requires structured pol_port_location_id for origin terminal operations, export documentation, customs zone determination, and loading berth assignment. Replaces denormalized pol_port_code wi',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Shipments are charged according to applicable port tariff schedules. Port billing systems must link each shipment to the tariff schedule governing its charges for invoicing and revenue recognition. Es',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the party (organization or individual) receiving the cargo. The consignee to whom the goods are being shipped and who will take delivery at destination.',
    `call_id` BIGINT COMMENT 'Reference to the next vessel call for transshipment cargo. Links the shipment to the outbound vessel on which it will continue its journey. Populated only when is_transshipment is true.',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Shipments are contracted with carriers; shipping_line_id identifies the contracted carrier for freight terms enforcement, service level tracking, schedule reliability measurement, and commercial relat',
    `tertiary_shipment_port_community_participant_id` BIGINT COMMENT 'Reference to the party (organization or individual) shipping the cargo. The consignor who is sending the goods and typically appears on the Bill of Lading as the shipper.',
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
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: Containers are allocated to fulfill cargo bookings - essential for container inventory management, booking fulfillment tracking, and slot utilization reporting. Port operations track which containers ',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Container-vessel compatibility validation is critical for stowage planning (e.g., reefer containers require vessels with reefer plug capacity, oversized containers require specific vessel configuratio',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Cargo containers reference standardized container types. Currently container has iso_type_code and container_type as strings. Adding FK to masterdata.container_type enables standardized container clas',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Container tracking requires structured current_port_location_id for real-time yard management, gate operations, equipment repositioning, and inventory control. Replaces denormalized current_location_c',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.imdg_class. Business justification: Container requires structured imdg_class_id for hazmat containers to enforce segregation rules, stowage category restrictions, and handling safety protocols. Replaces denormalized imdg_class text with',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to cargo.shipment. Business justification: Container is assigned to a shipment. Booking_number and bill_of_lading_number are shipment attributes that should be retrieved via FK. This links the physical container unit to the commercial shipment',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Containers are owned/operated by shipping lines; shipping_line_id is critical for equipment repositioning, leasing agreements, maintenance responsibility, and per diem charges. Replaces denormalized o',
    `storage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.storage_tariff. Business justification: Container storage charges are calculated using storage tariff schedules based on container type, status, and dwell time. Terminal billing systems require this link to compute daily storage fees and ap',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Containers are stored in specific terminal yard zones; fundamental to container tracking, yard management, and retrieval operations. Current_location_code is insufficient; zone_id provides structured ',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Containers requiring special storage (LCL, bonded, hazmat, reefer) are stored in warehouses; essential for warehouse inventory management, customs compliance, and specialized cargo handling operations',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: VGM (Verified Gross Mass) regulations require tracking which weighbridge equipment weighed each container. Port operations must maintain audit trail of calibrated weighing equipment used for SOLAS com',
    `condition_grade` STRING COMMENT 'Physical condition grade assigned during inspection: A (excellent), B (good), C (fair - minor repairs needed), D (poor - major repairs needed), E (unserviceable). Used for maintenance planning and commercial decisions.. Valid values are `A|B|C|D|E`',
    `container_number` STRING COMMENT 'Unique container identification number in ISO 6346 format consisting of 4-letter owner code, 6-digit serial number, and 1 check digit. This is the globally recognized identifier for the physical container unit.. Valid values are `^[A-Z]{4}[0-9]{7}$`',
    `container_status` STRING COMMENT 'Current operational status of the container: full (loaded with cargo), empty (available for loading), damaged (requires inspection/repair), under_repair (in maintenance), retired (out of service), in_transit (moving between locations).. Valid values are `full|empty|damaged|under_repair|retired|in_transit`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this container record was first created in the terminal operating system. Used for audit trail and data lineage.',
    `csc_plate_expiry_date` DATE COMMENT 'Expiry date of the CSC safety approval plate. Containers must be re-certified before this date to remain in service. Critical for regulatory compliance and port acceptance.',
    `cubic_capacity_cbm` DECIMAL(18,2) COMMENT 'Internal cubic capacity of the container in cubic meters (CBM). Used for cargo stowage planning and freight calculations.',
    `current_position_timestamp` TIMESTAMP COMMENT 'Timestamp when the container was last positioned at its current location. Used for dwell time calculation and operational tracking.',
    `delivery_order_number` STRING COMMENT 'Delivery Order number authorizing the release of the container to the consignee or their agent. Required for gate-out operations.',
    `final_destination_code` STRING COMMENT 'Five-character UN/LOCODE identifying the final inland destination for the container cargo. May differ from POD for transshipment or intermodal movements.. Valid values are `^[A-Z]{5}$`',
    `gate_in_timestamp` TIMESTAMP COMMENT 'Timestamp when the container entered the terminal through the gate. Marks the start of terminal custody and dwell time calculation.',
    `gate_out_timestamp` TIMESTAMP COMMENT 'Timestamp when the container exited the terminal through the gate. Marks the end of terminal custody and completion of dwell time.',
    `hazmat_certification_number` STRING COMMENT 'Certification or approval number for containers authorized to carry dangerous goods. Null for non-certified or non-hazmat containers. Required for IMDG compliance.',
    `height_ft` DECIMAL(18,2) COMMENT 'Physical height of the container in feet. Standard values: 8.5 ft (standard), 9.5 ft (high cube).',
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
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: Bills of lading are issued against cargo bookings - critical for commercial documentation traceability, customs clearance workflows, and freight billing. Maritime law requires linking transport docume',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: BOL requires structured commodity_code_id for tariff classification, customs duty calculation, trade compliance validation, and statistical reporting. Replaces denormalized hs_code with proper FK.',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: BOL declares commodity requiring HS code classification for tariff determination, duty calculation, and trade statistics. Port authorities and customs require HS code on BOL for regulatory compliance ',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Customs broker is appointed per BOL to prepare customs declaration, calculate duties, and manage clearance process. Broker acts as importers agent for regulatory compliance and documentation submissi',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: BOL requires structured destination_country_id for trade compliance screening, sanctions validation, export control enforcement, and customs documentation routing. POD code alone insufficient for regu',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.packaging_type. Business justification: BOLs must declare standardized package types for customs declarations, SOLAS VGM compliance, and cargo handling instructions. Linking to packaging_type master enables automated customs validation, dan',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: BOL requires structured pol_port_location_id for origin terminal operations, export customs zone routing, berth assignment, and port charge calculation. Replaces denormalized pol_code/pol_name with pr',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to cargo.shipment. Business justification: BOL is the transport contract document for a shipment. Bill_of_lading is the legal document; shipment is the operational cargo record. This links the document to the operational entity. Note: both hav',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: BOL is issued by the carrier; shipping_line_id identifies the issuing carrier for freight settlement, liability determination, cargo claims, and commercial disputes. Replaces denormalized issuing_carr',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: A Bill of Lading always references a specific voyage for freight invoicing, cargo tracing, and customs clearance. voyage_number is a denormalized plain attribute on bill_of_lading; voyage_id FK normal',
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
    `imdg_class` STRING COMMENT 'The IMDG classification code for dangerous goods (e.g., Class 1 - Explosives, Class 3 - Flammable Liquids), if applicable.',
    `is_dangerous_goods` BOOLEAN COMMENT 'Boolean flag indicating whether the cargo contains dangerous goods requiring special handling under IMDG Code regulations.',
    `issue_date` DATE COMMENT 'The date on which the Bill of Lading was officially issued by the carrier or authorized agent. This is the principal business event timestamp for the BOL.',
    `issuing_agent_name` STRING COMMENT 'The name of the authorized agent or freight forwarder who issued the BOL on behalf of the carrier.',
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
    `release_status` STRING COMMENT 'Current status of the cargo release process indicating whether the cargo is cleared for delivery to the consignee.. Valid values are `pending|approved|released|held|rejected`',
    `release_type` STRING COMMENT 'The method by which the cargo will be released to the consignee (original BOL surrender, telex release, express release, etc.).. Valid values are `original|telex|express|seaway|electronic`',
    `shipper_address` STRING COMMENT 'The full postal address of the shipper including street, city, state/province, postal code, and country.',
    `shipper_name` STRING COMMENT 'The full legal name of the shipper (consignor) who is sending the cargo. This is the party that delivers the goods to the carrier.',
    `special_instructions` STRING COMMENT 'Free-text field for any special instructions, handling requirements, or notes related to the cargo shipment.',
    `transhipment_port_1` STRING COMMENT 'The first intermediate port where cargo is transferred from one vessel to another during the voyage.',
    `transhipment_port_2` STRING COMMENT 'The second intermediate port where cargo is transferred from one vessel to another during the voyage, if applicable.',
    `un_number` STRING COMMENT 'The four-digit UN number identifying the dangerous goods substance, if applicable.. Valid values are `^UN[0-9]{4}$`',
    `volume_cbm` DECIMAL(18,2) COMMENT 'The total volume measurement of the cargo in cubic meters (CBM), used for freight calculation and stowage planning.',
    CONSTRAINT pk_bill_of_lading PRIMARY KEY(`bill_of_lading_id`)
) COMMENT 'Master record for the Bill of Lading (BOL) document — the primary cargo title and transport contract document. Captures BOL number, BOL type (original/seaway/express/telex release), issue date, issuing carrier/agent, shipper, consignee, notify party, POL, POD, transshipment ports, vessel and voyage reference, cargo description, package count, gross weight, measurement (CBM), freight terms (prepaid/collect), freight charges, special instructions, release status, and amendment history. SSOT for cargo title documentation. Sourced from Port Community System (PCS).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` (
    `manifest_id` BIGINT COMMENT 'Unique identifier for the cargo manifest record. Primary key for the cargo manifest entity.',
    `agent_appointment_id` BIGINT COMMENT 'Reference to the shipping agent, freight forwarder, or customs broker who submitted the manifest on behalf of the vessel operator.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Declaration of Security references cargo operations covered under ship-port interface agreement. Manifest provides detailed cargo information supporting DOS scope definition, enabling verification tha',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Cargo manifests are compiled for booked vessel calls - links cargo documentation to vessel call reservations for customs pre-clearance, port planning, and regulatory compliance. Manifests must referen',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Manifest is port authority regulatory document submitted per port. Manifest has berth_id and port_location_id but no direct port_id. Port-level manifest aggregation, customs clearance, and port statis',
    `port_location_id` BIGINT COMMENT 'Identifier of the user or system account that created the manifest record. Used for audit and accountability purposes.',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Vessel manifests require port tariff context for customs valuation, port dues calculation, and regulatory compliance reporting at the vessel call level. Essential for manifest-level charge aggregation',
    `shipping_line_id` BIGINT COMMENT 'Reference to the vessel operating carrier or shipping line responsible for the cargo movement.',
    `call_id` BIGINT COMMENT 'Reference to the vessel call for which this manifest was submitted. Links manifest to specific vessel visit.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Manifests require vessel_type for berth allocation planning, crane type selection, and cargo compatibility verification. Port operations teams use vessel_type to determine handling equipment and termi',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: Cargo manifests are filed per voyage for customs submission and port authority reporting. voyage_number is a denormalized voyage reference on manifest; a direct voyage_id FK normalizes this and enable',
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
    CONSTRAINT pk_manifest PRIMARY KEY(`manifest_id`)
) COMMENT 'Transactional record of the cargo manifest submitted per vessel call, including individual line items representing each BOL or container entry. Captures manifest number, vessel call reference, voyage number, manifest type (import/export/transshipment/coastal), submission date/time, submitting agent, total BOL count, total TEU count, total weight (MT), total CBM, customs submission status, PCS acknowledgement reference, amendment version, and manifest closure timestamp. Line-level detail includes BOL number, container number, cargo description, HS Code, package type/count, gross weight (KG), volume (CBM), shipper, consignee, POL, POD, freight terms, dangerous goods flag, IMDG class, UN number, temperature requirement, and customs declaration status. Enables granular cargo-level manifest reconciliation and customs processing. Mandatory for customs clearance and trade compliance. Sourced from Port Community System (PCS).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` (
    `manifest_line_id` BIGINT COMMENT 'Unique identifier for the manifest line item. Primary key for this entity.',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Manifest lines declare commodity codes (HS codes) for customs classification and duty calculation. Real regulatory requirement: WCO FAL Convention, customs tariff systems. Port community systems valid',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Manifest lines require structured link to consignee participant for customs clearance authorization, delivery order issuance, and cargo release workflows. Terminal operators and customs officers must ',
    `container_id` BIGINT COMMENT 'Foreign key linking to cargo.container. Business justification: Manifest line specifies container details for the cargo. Container_number is denormalized and should be retrieved via FK. This links manifest line to the physical container unit.',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.packaging_type. Business justification: Manifest lines declare package types for line-level customs validation and tariff classification. Linking to packaging_type master enables automated HS code validation, dangerous goods packaging compl',
    `item_id` BIGINT COMMENT 'Foreign key linking to tariff.item. Business justification: Individual manifest lines need specific tariff item linkage for per-cargo-line charge calculation including wharfage, handling, and commodity-specific fees. Critical for line-item billing accuracy and',
    `manifest_id` BIGINT COMMENT 'Reference to the parent cargo manifest document. Links this line item to the header manifest record.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Manifest_line requires structured pol_port_location_id for line-level load verification, customs declaration validation, and origin port compliance checks. Replaces denormalized pol_code with proper F',
    `cargo_description` STRING COMMENT 'Detailed textual description of the cargo contents. Includes commodity type, packaging details, and any special characteristics.',
    `cargo_value_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the declared cargo value. Supports multi-currency cargo valuation.. Valid values are `^[A-Z]{3}$`',
    `cargo_value_usd` DECIMAL(18,2) COMMENT 'Declared commercial value of the cargo in US dollars. Used for insurance, customs valuation, and liability calculations.',
    `confirmed_timestamp` TIMESTAMP COMMENT 'Timestamp when this manifest line was confirmed and locked for vessel loading operations.',
    `container_size_type` STRING COMMENT 'ISO container size and type code. Indicates container dimensions and configuration (e.g., 20GP = 20-foot general purpose, 40HC = 40-foot high cube).. Valid values are `20GP|40GP|40HC|45HC|20RF|40RF`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this manifest line record was first created in the system. Audit trail for data lineage.',
    `customs_declaration_number` STRING COMMENT 'Official customs declaration reference number assigned by customs authority. Used for tracking customs processing and clearance.',
    `customs_declaration_status` STRING COMMENT 'Current status of customs clearance processing for this manifest line. Tracks progression through customs workflow.. Valid values are `pending|submitted|cleared|held|rejected`',
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
    `berth_allocation_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal_berth_allocation. Business justification: A handling order is executed against a specific berth allocation; linking these supports berth productivity reporting, SLA turnaround time tracking, and crane allocation reconciliation. Terminal opera',
    `berth_id` BIGINT COMMENT 'Reference to the berth where the handling operation will take place. Identifies the specific quay position allocated for this vessel call.',
    `equipment_class_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_class. Business justification: Major infrastructure projects (terminal expansion, automation initiatives) use WBS structures. Handling operations during project commissioning or pilot phases require direct cost capture to specific ',
    `manifest_id` BIGINT COMMENT 'Foreign key linking to cargo.manifest. Business justification: A handling order (loading/discharge instruction) is operationally tied to the cargo manifest submitted for that vessel call. The manifest defines what cargo is to be loaded or discharged; the handling',
    `mooring_operation_id` BIGINT COMMENT 'Foreign key linking to marine.mooring_operation. Business justification: Mooring completion is mandatory prerequisite for cargo operations. Terminal operators track mooring_operation_id for safety compliance, billing reconciliation of mooring services, and precise scheduli',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Handling orders (load/discharge operations) execute under terminal service agreements specifying productivity targets, equipment allocation, and handling rates. Critical for performance measurement, b',
    `pilotage_assignment_id` BIGINT COMMENT 'Foreign key linking to marine.pilotage_assignment. Business justification: Cargo handling operations depend on vessel pilotage completion for berth positioning. Terminal operators schedule crane gangs and equipment based on pilotage ETA. Critical for operational sequencing a',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Load/discharge operations execute against booked vessel calls - operational planning requires linking handling orders to call bookings for resource allocation, berth scheduling, and service order fulf',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: Handling orders for truck gate-in/gate-out operations require gate assignment for appointment scheduling, gate productivity tracking, and customs inspection routing. Currently has berth/warehouse/term',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Stevedoring operations are cost center activities in port operations. Terminal operators track handling labor, equipment, and overhead costs by cost center for operational budgeting, variance analysis',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Handling orders are executed for specific carriers; shipping_line_id drives terminal handling charge billing, service priority allocation, SLA compliance tracking, and carrier-specific operational pro',
    `stowage_plan_id` BIGINT COMMENT 'Foreign key linking to cargo.cargo_stowage_plan. Business justification: Handling order executes the vessel stowage plan. Bay_plan_reference is a denormalized reference that should be replaced with FK to cargo_stowage_plan. This links operational execution to the planning ',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Handling operations occur within specific terminal zones for container stacking/retrieval; required for operational planning, resource allocation, and productivity tracking. Complements berth_id which',
    `thc_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.thc_schedule. Business justification: Load/discharge operations are billed using Terminal Handling Charge schedules based on container size, type, and movement category. Stevedoring billing requires this link to apply correct THC rates to',
    `towage_order_id` BIGINT COMMENT 'Foreign key linking to marine.towage_order. Business justification: Cargo handling cannot commence until vessel is towed and secured at berth. Towage completion triggers handling order activation. Essential for terminal scheduling, berth window management, and coordin',
    `call_id` BIGINT COMMENT 'Reference to the vessel call for which this handling order is issued. Links the handling operation to a specific vessel visit.',
    `vessel_id` BIGINT COMMENT 'Foreign key linking to vessel.vessel. Business justification: DOS covers specific cargo operations at ship-port interface; handling orders detail those operations. Links operational execution to DOS agreement, enabling verification that security measures agreed ',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Load/discharge operations vary significantly by vessel type (container vs bulk vs RoRo require different equipment, gang sizes, productivity targets). Linking enables automated equipment allocation ru',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Hot work on vessels during cargo operations, confined space entry for hold inspection, hazardous cargo handling, and heavy lift operations require permit-to-work authorization integrated with cargo ha',
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
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Specific high-risk moves (oversized cargo requiring road closures, heavy lifts exceeding SWL, hazmat transfers, reefer plug operations in confined spaces) require individual permit-to-work authorizati',
    `charge_event_id` BIGINT COMMENT 'Foreign key linking to billing.charge_event. Business justification: Individual moves (lift-on, lift-off, restow, shift, gate-in, gate-out) are chargeable events in terminal operations. Move is the source transaction that generates charge_event records for tariff appli',
    `container_id` BIGINT COMMENT 'Foreign key linking to cargo.container. Business justification: Each cargo move is for a specific container. Container_number is denormalized and should be retrieved via FK to container master record. This is a core operational relationship - every move must refer',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Move requires structured container_type_id for equipment allocation, handling method selection, and yard stacking rules. Replaces denormalized container_type_iso with proper FK.',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Individual cargo moves are the atomic unit of risk exposure in terminal operations; incidents must reference the specific move for equipment operator safety records, move-type risk profiling (load/dis',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to cargo.delivery_order. Business justification: A gate-out move (container release from terminal) is directly authorized by a Delivery Order. The move table currently stores delivery_order_number as a denormalized STRING, which is the natural key o',
    `equipment_id` BIGINT COMMENT 'Reference to the specific equipment unit that performed the move. Links to asset register for equipment tracking and utilization.',
    `handling_order_id` BIGINT COMMENT 'Foreign key linking to cargo.handling_order. Business justification: Individual cargo moves are executed as part of a handling order (load/discharge instruction). Handling_order is the operational work order; cargo_move is the atomic execution record. This is a clear p',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.imdg_class. Business justification: Move requires structured imdg_class_id for hazmat move planning, equipment safety requirements, and operator certification validation. Replaces denormalized imdg_class text with proper FK.',
    `item_id` BIGINT COMMENT 'Foreign key linking to tariff.tariff_item. Business justification: Individual cargo moves (crane lifts, gate moves, yard shifts) generate billable charges mapped to specific tariff line items. Terminal operating systems use this link for granular activity-based billi',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Cargo moves have origin zones (yard, CFS, gate); essential for move tracking, equipment routing, and operational analytics. Origin_location_code is unstructured; zone FK enables proper operational rep',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Cargo moves originating from warehouses (LCL destuffing, bonded release) are fundamental port operations; required for warehouse inventory reconciliation, billing, and operational tracking of CFS acti',
    `call_id` BIGINT COMMENT 'Reference to the vessel visit during which this cargo move occurred. Links move to specific vessel call.',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: Gate-in and gate-out cargo moves are fundamental port operations; required for gate transaction reconciliation, truck turnaround time analysis, and RFID/OCR system integration. Critical for landside o',
    `port_location_id` BIGINT COMMENT 'Reference to the equipment operator or stevedore who executed the move. Links to workforce management for productivity tracking.',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to cargo.shipment. Business justification: Cargo move is part of handling a shipment. Booking_reference and bill_of_lading_number are shipment attributes that should be retrieved via FK. This links operational moves to the commercial shipment ',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: When equipment fails during a cargo move, operations must link the interrupted move to the corrective work order for downtime analysis, productivity reporting, and customer claims. Critical for operat',
    `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time when the move operation was completed. Used to calculate move duration and equipment productivity.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when the move operation commenced. Captured from TOS or equipment automation system.',
    `cargo_weight_kg` DECIMAL(18,2) COMMENT 'Verified gross mass of the container and cargo in kilograms. Required under SOLAS VGM regulations for loaded containers.',
    `container_size_teu` DECIMAL(18,2) COMMENT 'Container size expressed in TEU. Standard 20ft = 1.0 TEU, 40ft = 2.0 TEU, 45ft = 2.25 TEU. Used for productivity normalization.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this cargo move record was first created in the system. Audit trail for data lineage.',
    `customs_status` STRING COMMENT 'Current customs clearance status of the cargo. Indicates whether cargo has been released by customs authorities for movement.. Valid values are `cleared|pending|held|inspected|released|bonded`',
    `damage_reported` BOOLEAN COMMENT 'Boolean flag indicating whether container or cargo damage was reported during this move. Triggers damage assessment workflow.',
    `destination_location_code` STRING COMMENT 'Specific location code where the container was placed. May be berth number, yard block-bay-row-tier, gate lane, or rail track identifier.',
    `destination_location_type` STRING COMMENT 'Classification of the destination facility where the move ended. Defines the target context for the move.. Valid values are `vessel|yard|gate|rail|cfs|buffer`',
    `destination_position` STRING COMMENT 'Detailed position coordinates at destination. For vessel: bay-row-tier from BAPLIE. For yard: block-bay-row-tier. For gate: lane number.',
    `duration_minutes` DECIMAL(18,2) COMMENT 'Total elapsed time in minutes from move start to completion. Key metric for crane productivity (Moves Per Hour) and operational efficiency analysis.',
    `equipment_type` STRING COMMENT 'Type of handling equipment used to execute the move. Identifies the machinery class performing the operation. [ENUM-REF-CANDIDATE: quay_crane|rtg|reach_stacker|forklift|straddle_carrier|agv|mobile_harbour_crane|empty_handler — 8 candidates stripped; promote to reference product]',
    `exception_code` STRING COMMENT 'Code identifying any exception or deviation that occurred during the move (e.g., damage, delay, equipment failure). Null for normal moves.',
    `exception_description` STRING COMMENT 'Detailed description of any exception or issue encountered during the move execution. Free text field for operational notes.',
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
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Stowage plan execution depends on berth assignment for crane reach, shore power availability, and berth-specific operational constraints. Plan has vessel_call_id and port_location_id but no berth_id. ',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Stowage planning must comply with facility ISPS security level for cargo access zones, dangerous goods segregation, and restricted area placement. Port facility security officer reviews stowage plans ',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Stowage plans are prepared for booked vessel calls - planning artifact must reference call booking for capacity validation, service requirement verification, and operational coordination between booki',
    `port_location_id` BIGINT COMMENT 'Identifier of the supervisor or operations manager who approved the stowage plan. Ensures accountability in the approval workflow.',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Stowage plans are carrier-specific operational documents; shipping_line_id identifies the carrier for plan approval workflow, commercial slot allocation, and carrier-specific stowage rules. Replaces d',
    `call_id` BIGINT COMMENT 'Reference to the vessel call for which this stowage plan is created. Links the stowage plan to a specific vessel visit.',
    `vessel_id` BIGINT COMMENT 'FK to vessel.vessel',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Stowage_plan requires vessel_master_id for vessel-specific stability parameters, cargo capacity limits, reefer plug capacity, and structural constraints. Replaces denormalized vessel_imo_number with p',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Stowage plans are vessel-type-specific; container ship stowage differs fundamentally from bulk carrier or RoRo. Vessel_type drives stability calculation rules, cargo placement constraints, and lashing',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: A stowage plan (BAPLIE) is inherently voyage-specific, defining container positions for a vessel voyage for stability calculations and port pre-planning. voyage_number is a denormalized plain attribut',
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
    `stability_calculation_reference` STRING COMMENT 'Reference identifier for the vessel stability calculation document or system record. Links to detailed stability analysis ensuring safe loading conditions.',
    `terminal_operator_code` STRING COMMENT 'Code identifying the terminal operator responsible for executing the stowage plan. Links to the specific terminal handling the vessel.',
    `total_feu_loaded` STRING COMMENT 'Number of forty-foot equivalent containers loaded on the vessel. Complements TEU count for detailed capacity tracking.',
    `total_teu_capacity` STRING COMMENT 'Maximum container capacity of the vessel expressed in TEU. Represents the total number of twenty-foot equivalent containers the vessel can carry.',
    `total_teu_loaded` STRING COMMENT 'Actual number of TEU loaded on the vessel according to this stowage plan. Used to calculate vessel utilization and capacity management.',
    `total_weight_mt` DECIMAL(18,2) COMMENT 'Total weight of all cargo loaded on the vessel in metric tons. Critical for vessel stability calculations and compliance with safe loading limits.',
    `transhipment_container_count` STRING COMMENT 'Number of containers being transhipped through this port (loaded from one vessel to be discharged to another). Important for port operations planning.',
    `trim_value_meters` DECIMAL(18,2) COMMENT 'Difference in draft between the forward and aft of the vessel measured in meters. Positive value indicates stern trim, negative indicates bow trim. Critical for vessel stability and navigation safety.',
    CONSTRAINT pk_stowage_plan PRIMARY KEY(`stowage_plan_id`)
) COMMENT 'Master record for the vessel stowage plan (BAPLIE) associated with a vessel call, including individual container slot assignments (bay/row/tier positions). Captures BAPLIE message reference, vessel call reference, voyage number, plan version, plan type (pre-stow/final/actual), total TEU capacity, total TEU loaded, total weight (MT), stability calculation reference, trim and list values, hazmat segregation compliance flag, reefer plug count used, OOG (out-of-gauge) count, plan submission datetime, planner ID, and approval status. Position-level detail includes container number, ISO position code (bay/row/tier), weight, height, POD, hazmat class, reefer flag, OOG dimensions, temperature/ventilation settings, and position status (planned/confirmed/actual). SSOT for vessel stowage planning data and container slot assignments. Sourced from NAVIS N4 vessel planning module.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` (
    `dangerous_goods_declaration_id` BIGINT COMMENT 'Unique identifier for the dangerous goods declaration record. Primary key.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Each DG declaration requires formal risk assessment for stowage position, segregation compliance, handling procedures, and emergency response per IMDG Code and port safety management system. Risk asse',
    `bill_of_lading_id` BIGINT COMMENT 'Foreign key linking to cargo.bill_of_lading. Business justification: DGD is submitted for dangerous cargo covered by a specific BOL. Bol_number is denormalized and should be retrieved via FK. This links the hazmat declaration to the cargo title document.',
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: DG declarations must reference cargo bookings for approval workflow, segregation planning, and compliance verification. Port authorities require linking hazmat declarations to booking commitments befo',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Dangerous goods may be subject to trade restrictions (dual-use goods, chemical weapons precursors, prohibited substances). Real regulatory requirement: export control compliance officers must screen D',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Hazmat cargo has specific HS code classifications (Chapter 28-38 chemicals, explosives, etc.). Real business need: dual-use goods screening, export controls, customs duty calculation for dangerous goo',
    `container_id` BIGINT COMMENT 'Foreign key linking to cargo.container. Business justification: DGD specifies which container holds the dangerous goods. Container_number is denormalized and should be retrieved via FK. This is critical for stowage planning and segregation compliance.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: IMDG Code requires traceable declarant identity for dangerous goods liability and emergency response. Links declarant_name/company text to participant record for compliance verification, accreditation',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: IMDG Code requires tracking specialized equipment (certified cranes, forklifts) used to handle dangerous goods. Port must document which IMDG-certified assets handled each DG declaration for safety au',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.packaging_type. Business justification: DG declarations must specify IMDG-compliant packaging with correct packing group for the IMDG class. Linking to packaging_type master enables automated validation of packaging group compatibility, UN ',
    `manifest_line_id` BIGINT COMMENT 'Foreign key linking to cargo.manifest_line. Business justification: A Dangerous Goods Declaration (DGD) is submitted for IMDG-classified cargo that appears as a specific line item in the cargo manifest. The manifest_line is the authoritative record of that cargo entry',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: IMDG Code and port authority regulations require documented inspector identity for dangerous goods declaration verification, acceptance decisions, and safety audit trail. Port state control inspection',
    `shipment_id` BIGINT COMMENT 'Reference to the parent shipment containing this dangerous goods cargo.',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: DGDs must be filed per voyage for IMDG Code compliance and port authority acceptance. voyage_number is a denormalized plain attribute; voyage_id FK normalizes it and enables voyage-level dangerous goo',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: DG cargo creates specific IMDG-classified hazards that must be registered in the ports hazard register for regulatory compliance, emergency response planning, segregation management, and terminal ris',
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
    CONSTRAINT pk_dangerous_goods_declaration PRIMARY KEY(`dangerous_goods_declaration_id`)
) COMMENT 'Master record for the Dangerous Goods Declaration (DGD) submitted for IMDG-classified cargo. Captures DGD number, shipment/BOL reference, container number, IMDG class (1–9), UN number, proper shipping name, packing group (I/II/III), flash point, net quantity, gross quantity, emergency contact, segregation group, special provisions, limited quantity flag, marine pollutant flag, EMS code, MFAG reference, declaration date, declarant details, and port authority acceptance status. Mandatory for IMDG compliance and ISPS security. Sourced from PCS.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` (
    `delivery_order_id` BIGINT COMMENT 'Unique identifier for the delivery order record. Primary key for the cargo delivery order entity.',
    `contact_person_id` BIGINT COMMENT 'Reference to the party authorized by the consignee to collect the cargo on their behalf. May be the consignee themselves or a nominated third party.',
    `container_id` BIGINT COMMENT 'Reference to the container for which this delivery order is issued. May be null for break-bulk or non-containerized cargo.',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Delivery order release requires customs broker coordination for clearance documentation, duty payment verification, and permit validation. Broker facilitates cargo release by ensuring all customs requ',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Delivery orders cannot be released when customs holds are active. Real business process: terminal gate systems check hold status before authorizing cargo release; delivery order issuance is blocked un',
    `demurrage_detention_id` BIGINT COMMENT 'Foreign key linking to cargo.demurrage_detention. Business justification: A Delivery Order authorizes cargo release and requires demurrage/detention charges to be cleared before release (evidenced by demurrage_cleared_flag and detention_cleared_flag on delivery_order). Addi',
    `import_export_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.import_export_permit. Business justification: Delivery orders for controlled goods must reference valid import/export permits. Real business process: terminal gate release procedures require permit validation before cargo handover; gate systems v',
    `original_delivery_order_id` BIGINT COMMENT 'Self-referencing foreign key to the original delivery order if this D/O is a reissue, amendment, or replacement. Null for original D/Os.',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Delivery orders reference service agreements to validate release terms, free time entitlements, and storage conditions. Required for cargo release authorization and demurrage calculation in terminal o',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Delivery orders are legal cargo release documents requiring documented issuing officer for regulatory compliance, fraud prevention, dispute resolution, and audit trail. Port operations track which aut',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the shipping line agent or freight forwarder who issued the delivery order on behalf of the carrier.',
    `rate_card_id` BIGINT COMMENT 'Foreign key linking to tariff.rate_card. Business justification: Delivery orders for contract customers reference negotiated rate cards to apply preferential pricing and SLA terms. Commercial systems require this link to enforce contracted rates and track volume co',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: Delivery order specifies cargo release location (terminal_zone_id exists) but actual gate-out occurs at specific port gate. Gate appointment systems, truck turnaround time tracking, and gate productiv',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Delivery orders are issued by shipping lines as cargo release authority; shipping_line_id identifies the issuing carrier for release authorization validation, freight payment verification, and demurra',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Delivery orders release cargo originally booked - links release documentation to booking for freight payment verification, demurrage calculation, and commercial terms enforcement. Delivery authorizati',
    `call_id` BIGINT COMMENT 'Foreign key linking to vessel.call. Business justification: Delivery orders authorize cargo release after specific vessel discharge completion. Terminal gate operations verify cargo availability against vessel call discharge status before releasing containers.',
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
    `container_id` BIGINT COMMENT 'Reference to the container subject to demurrage or detention charges.',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Demurrage charges are calculated based on demurrage schedules (free time, daily rates). Currently demurrage_detention has tariff_id (unlinked). Adding specific FK to tariff.demurrage_schedule enables ',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Customs holds cause demurrage/detention charges. Real business process: billing systems must link holds to charge calculations for dispute resolution; shippers request waivers by proving delay was cus',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Demurrage requires structured pol_port_location_id for origin port free-time calculation, port-specific tariff application, and loading port detention charges. Replaces denormalized pol_code with prop',
    `call_id` BIGINT COMMENT 'Reference to the vessel call during which the container was discharged, triggering the free time period.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Demurrage/detention charges calculated against original cargo booking terms - commercial link for free-time calculation, tariff application, and billing. Charges reference booking to determine applica',
    `port_tariff_id` BIGINT COMMENT 'Reference to the applicable tariff rate schedule used for charge calculation.',
    `terminal_zone_id` BIGINT COMMENT 'Reference to the container terminal where the demurrage or detention event occurred.',
    `shipping_line_id` BIGINT COMMENT 'Reference to the shipping line or carrier responsible for the container.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Demurrage/detention charges depend on storage location. Has two terminal_zone FKs but no warehouse_id. Warehouse-specific storage tariffs, bonded vs non-bonded status, and facility-level charge reconc',
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
    `settlement_status` STRING COMMENT 'Payment status of the charge: outstanding (unpaid), partial (partially paid), settled (fully paid), overdue (past due date).. Valid values are `outstanding|partial|settled|overdue`',
    `total_charge_amount` DECIMAL(18,2) COMMENT 'Total accrued demurrage or detention charge calculated as days exceeded multiplied by daily rate.',
    `waiver_amount` DECIMAL(18,2) COMMENT 'Portion of the total charge amount that has been waived or forgiven due to dispute resolution or commercial agreement.',
    `waiver_approval_date` DATE COMMENT 'Date when the waiver was formally approved and applied to the charge.',
    `waiver_approved_by` STRING COMMENT 'Name or identifier of the port authority or commercial manager who authorized the waiver.',
    `waiver_reason` STRING COMMENT 'Business justification for granting the waiver, such as operational disruption, commercial goodwill, or contractual agreement.',
    CONSTRAINT pk_demurrage_detention PRIMARY KEY(`demurrage_detention_id`)
) COMMENT 'Transactional record tracking demurrage and detention charge accruals for containers exceeding contractual free time allowances. Captures container reference, BOL, shipping line, free time boundaries, days exceeded, applicable tariff rate, accrued amount, dispute/waiver status, and settlement state. Interfaces with tariff domain for rate lookup and billing domain for invoice generation. Critical for port revenue protection and shipping line commercial relationships.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` (
    `verified_gross_mass_id` BIGINT COMMENT 'Unique identifier for the VGM declaration record. Primary key for the verified gross mass entity.',
    `bill_of_lading_id` BIGINT COMMENT 'Reference to the bill of lading associated with this VGM declaration.',
    `container_id` BIGINT COMMENT 'Reference to the container for which this VGM declaration applies.',
    `gate_transaction_id` BIGINT COMMENT 'Foreign key linking to terminal.gate_transaction. Business justification: VGM is captured at the terminal gate weighbridge (gate_transaction.weight_bridge_reading_kg). Linking VGM records to the gate transaction that captured the weight supports SOLAS compliance audit trail',
    `manifest_line_id` BIGINT COMMENT 'Foreign key linking to cargo.manifest_line. Business justification: A VGM declaration is submitted per container per vessel call, and the manifest_line is the corresponding cargo manifest entry for that container/BOL combination. Linking VGM to manifest_line provides ',
    `port_asset_id` BIGINT COMMENT 'Identifier of the specific weighing equipment (weighbridge, scale) used to perform the VGM measurement. Used for calibration tracking and audit purposes.',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the shipper party responsible for providing the VGM declaration.',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: VGM weighing often occurs at gate weighbridges during truck gate-in; required for SOLAS compliance tracking, weighbridge utilization reporting, and integration with gate operating systems. Weighing_st',
    `primary_original_vgm_verified_gross_mass_id` BIGINT COMMENT 'Reference to the original VGM declaration record if this is an amended version. Null for initial submissions.',
    `shipping_line_id` BIGINT COMMENT 'Reference to the shipping line (carrier) to whom the VGM declaration is submitted.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: VGM submissions required for cargo bookings before vessel loading - SOLAS regulatory compliance link. Shipping lines validate VGM against booking before accepting container for loading, making booking',
    `call_id` BIGINT COMMENT 'Reference to the vessel call for which this VGM declaration is submitted. Links the VGM to the specific vessel voyage.',
    `vessel_id` BIGINT COMMENT 'Foreign key linking to vessel.vessel. Business justification: VGM submissions identify the carrying vessel by IMO number per SOLAS VI/2 for load planning and stability compliance. vessel_imo_number and vessel_name are denormalized on verified_gross_mass; vessel_',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: VGM is submitted per voyage under SOLAS regulation VI/2 before vessel departure. voyage_number is a denormalized plain attribute on verified_gross_mass; voyage_id FK normalizes it and supports voyage-',
    `warehouse_id` BIGINT COMMENT 'Reference to the weighing station or facility where the VGM weighing was performed.',
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
    `vgm_reference_number` STRING COMMENT 'Unique business reference number assigned to the VGM declaration for tracking and audit purposes. Externally-known identifier used in communications with shipping lines and port authorities.',
    `weighing_certificate_number` STRING COMMENT 'Certificate number issued by the certified weighing facility as proof of the VGM measurement.',
    `weighing_datetime` TIMESTAMP COMMENT 'The date and time when the container was weighed to obtain the verified gross mass.',
    `weighing_facility_name` STRING COMMENT 'Name of the certified weighing facility or weighbridge where the container was weighed. Denormalized for operational reporting.',
    `weighing_method` STRING COMMENT 'The method used to determine the verified gross mass. Method 1: weighing the packed container. Method 2: weighing all packages and cargo items, including pallets, dunnage, and other packing material, and adding the tare weight of the container.. Valid values are `Method 1|Method 2`',
    CONSTRAINT pk_verified_gross_mass PRIMARY KEY(`verified_gross_mass_id`)
) COMMENT 'Transactional record of Verified Gross Mass (VGM) declarations submitted per container as mandated by SOLAS Chapter VI Regulation 2 (effective July 2016). Captures VGM reference number, container number, weighing method (Method 1: weigh packed container / Method 2: sum of contents), gross mass declared (KG), weighing station/facility, weighing datetime, authorized signatory, shipper reference, shipping line acknowledgement, submission deadline compliance flag, and verification status. Mandatory for all export containers before vessel loading. SSOT for VGM compliance data. Sourced from PCS and certified weighbridges.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ADD CONSTRAINT `fk_cargo_manifest_line_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ADD CONSTRAINT `fk_cargo_manifest_line_manifest_id` FOREIGN KEY (`manifest_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`manifest`(`manifest_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_manifest_id` FOREIGN KEY (`manifest_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`manifest`(`manifest_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_stowage_plan_id` FOREIGN KEY (`stowage_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`stowage_plan`(`stowage_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_handling_order_id` FOREIGN KEY (`handling_order_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`handling_order`(`handling_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_manifest_line_id` FOREIGN KEY (`manifest_line_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`manifest_line`(`manifest_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_demurrage_detention_id` FOREIGN KEY (`demurrage_detention_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention`(`demurrage_detention_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_original_delivery_order_id` FOREIGN KEY (`original_delivery_order_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_manifest_line_id` FOREIGN KEY (`manifest_line_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`manifest_line`(`manifest_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_primary_original_vgm_verified_gross_mass_id` FOREIGN KEY (`primary_original_vgm_verified_gross_mass_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass`(`verified_gross_mass_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`cargo` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`cargo` SET TAGS ('dbx_domain' = 'cargo');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` SET TAGS ('dbx_subdomain' = 'cargo_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Restriction Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Discharge Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Threat Assessment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Pol Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Consignee Party Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Onward Vessel Call Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ALTER COLUMN `tertiary_shipment_port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Shipper Party Identifier');
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
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` SET TAGS ('dbx_subdomain' = 'terminal_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Compatible Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Current Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Imdg Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `storage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Weighbridge Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `condition_grade` SET TAGS ('dbx_business_glossary_term' = 'Container Condition Grade');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `condition_grade` SET TAGS ('dbx_value_regex' = 'A|B|C|D|E');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `container_number` SET TAGS ('dbx_business_glossary_term' = 'Container Number (ISO Format)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `container_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `container_status` SET TAGS ('dbx_business_glossary_term' = 'Container Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `container_status` SET TAGS ('dbx_value_regex' = 'full|empty|damaged|under_repair|retired|in_transit');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `csc_plate_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'CSC (Container Safety Convention) Plate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `cubic_capacity_cbm` SET TAGS ('dbx_business_glossary_term' = 'Cubic Capacity (CBM - Cubic Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `current_position_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Current Position Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_business_glossary_term' = 'D/O (Delivery Order) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `final_destination_code` SET TAGS ('dbx_business_glossary_term' = 'Final Destination Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `final_destination_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `gate_in_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Gate-In Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `gate_out_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Gate-Out Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `hazmat_certification_number` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials Certification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ALTER COLUMN `height_ft` SET TAGS ('dbx_business_glossary_term' = 'Container Height (Feet)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` SET TAGS ('dbx_subdomain' = 'cargo_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Pol Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `is_dangerous_goods` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `issuing_agent_name` SET TAGS ('dbx_business_glossary_term' = 'Issuing Agent Name');
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
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ALTER COLUMN `volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Volume in Cubic Meters (CBM)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` SET TAGS ('dbx_subdomain' = 'cargo_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `manifest_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Manifest ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `agent_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Submitting Agent ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Dos Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` SET TAGS ('dbx_subdomain' = 'cargo_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `manifest_line_id` SET TAGS ('dbx_business_glossary_term' = 'Manifest Line Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Consignee Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Item Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `manifest_id` SET TAGS ('dbx_business_glossary_term' = 'Manifest Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Pol Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `cargo_description` SET TAGS ('dbx_business_glossary_term' = 'Cargo Description');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `cargo_value_currency` SET TAGS ('dbx_business_glossary_term' = 'Cargo Value Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `cargo_value_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `cargo_value_usd` SET TAGS ('dbx_business_glossary_term' = 'Cargo Value in United States Dollars (USD)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `cargo_value_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `cargo_value_usd` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `confirmed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `container_size_type` SET TAGS ('dbx_business_glossary_term' = 'Container Size and Type Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `container_size_type` SET TAGS ('dbx_value_regex' = '20GP|40GP|40HC|45HC|20RF|40RF');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `customs_declaration_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `customs_declaration_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ALTER COLUMN `customs_declaration_status` SET TAGS ('dbx_value_regex' = 'pending|submitted|cleared|held|rejected');
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
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` SET TAGS ('dbx_subdomain' = 'terminal_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `handling_order_id` SET TAGS ('dbx_business_glossary_term' = 'Handling Order Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `berth_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Berth Allocation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `equipment_class_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `manifest_id` SET TAGS ('dbx_business_glossary_term' = 'Manifest Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `mooring_operation_id` SET TAGS ('dbx_business_glossary_term' = 'Mooring Operation Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `pilotage_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Assignment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `stowage_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Stowage Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `thc_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Thc Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `towage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Dos Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` SET TAGS ('dbx_subdomain' = 'terminal_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `move_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Move Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `charge_event_id` SET TAGS ('dbx_business_glossary_term' = 'Charge Event Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Ohs Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `handling_order_id` SET TAGS ('dbx_business_glossary_term' = 'Handling Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Imdg Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Item Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `cargo_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Cargo Weight in Kilograms (KG)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `container_size_teu` SET TAGS ('dbx_business_glossary_term' = 'Container Size in Twenty-foot Equivalent Units (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `customs_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `customs_status` SET TAGS ('dbx_value_regex' = 'cleared|pending|held|inspected|released|bonded');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `damage_reported` SET TAGS ('dbx_business_glossary_term' = 'Damage Reported Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `destination_location_code` SET TAGS ('dbx_business_glossary_term' = 'Destination Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `destination_location_type` SET TAGS ('dbx_business_glossary_term' = 'Destination Location Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `destination_location_type` SET TAGS ('dbx_value_regex' = 'vessel|yard|gate|rail|cfs|buffer');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `destination_position` SET TAGS ('dbx_business_glossary_term' = 'Destination Position');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Move Duration in Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `equipment_type` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `exception_code` SET TAGS ('dbx_business_glossary_term' = 'Move Exception Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ALTER COLUMN `exception_description` SET TAGS ('dbx_business_glossary_term' = 'Move Exception Description');
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
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` SET TAGS ('dbx_subdomain' = 'vessel_planning');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `stowage_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Stowage Plan ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Approver ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Id');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `vessel_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `stability_calculation_reference` SET TAGS ('dbx_business_glossary_term' = 'Stability Calculation Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `terminal_operator_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Operator Code');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `total_feu_loaded` SET TAGS ('dbx_business_glossary_term' = 'Total FEU (Forty-foot Equivalent Unit) Loaded');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `total_teu_capacity` SET TAGS ('dbx_business_glossary_term' = 'Total TEU (Twenty-foot Equivalent Unit) Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `total_teu_loaded` SET TAGS ('dbx_business_glossary_term' = 'Total TEU (Twenty-foot Equivalent Unit) Loaded');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `total_weight_mt` SET TAGS ('dbx_business_glossary_term' = 'Total Weight in Metric Tons (MT)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `transhipment_container_count` SET TAGS ('dbx_business_glossary_term' = 'Transhipment Container Count');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ALTER COLUMN `trim_value_meters` SET TAGS ('dbx_business_glossary_term' = 'Trim Value in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` SET TAGS ('dbx_subdomain' = 'cargo_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `dangerous_goods_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Declaration (DGD) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill Of Lading Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Restriction Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Declarant Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Handling Equipment Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `manifest_line_id` SET TAGS ('dbx_business_glossary_term' = 'Manifest Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Inspector Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Hazard Register Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` SET TAGS ('dbx_subdomain' = 'cargo_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Delivery Order (D/O) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `contact_person_id` SET TAGS ('dbx_business_glossary_term' = 'Authorized Collector ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `demurrage_detention_id` SET TAGS ('dbx_business_glossary_term' = 'Demurrage Detention Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `import_export_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Import Export Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `original_delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Original Delivery Order (D/O) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Issuing Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Issuing Agent ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Release Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` SET TAGS ('dbx_subdomain' = 'cargo_documentation');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `demurrage_detention_id` SET TAGS ('dbx_business_glossary_term' = 'Demurrage Detention ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Demurrage Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Pol Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Warehouse Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `settlement_status` SET TAGS ('dbx_business_glossary_term' = 'Settlement Status');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `settlement_status` SET TAGS ('dbx_value_regex' = 'outstanding|partial|settled|overdue');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `total_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `waiver_amount` SET TAGS ('dbx_business_glossary_term' = 'Waiver Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `waiver_approval_date` SET TAGS ('dbx_business_glossary_term' = 'Waiver Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `waiver_approved_by` SET TAGS ('dbx_business_glossary_term' = 'Waiver Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ALTER COLUMN `waiver_reason` SET TAGS ('dbx_business_glossary_term' = 'Waiver Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` SET TAGS ('dbx_subdomain' = 'vessel_planning');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `verified_gross_mass_id` SET TAGS ('dbx_business_glossary_term' = 'Verified Gross Mass (VGM) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `bill_of_lading_id` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `gate_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Transaction Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `manifest_line_id` SET TAGS ('dbx_business_glossary_term' = 'Manifest Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Weighing Equipment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Shipper ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `primary_original_vgm_verified_gross_mass_id` SET TAGS ('dbx_business_glossary_term' = 'Original Verified Gross Mass (VGM) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call ID');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `vessel_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Weighing Station ID');
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
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `vgm_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Verified Gross Mass (VGM) Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `weighing_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Weighing Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `weighing_datetime` SET TAGS ('dbx_business_glossary_term' = 'Weighing Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `weighing_facility_name` SET TAGS ('dbx_business_glossary_term' = 'Weighing Facility Name');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `weighing_method` SET TAGS ('dbx_business_glossary_term' = 'Weighing Method');
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ALTER COLUMN `weighing_method` SET TAGS ('dbx_value_regex' = 'Method 1|Method 2');
