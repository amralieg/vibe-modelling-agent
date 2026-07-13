-- Schema for Domain: terminal | Business: Shipping_Ports | Version: v2_mvm
-- Generated on: 2026-07-13 10:24:19

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`terminal` COMMENT 'Manages container terminal operations including yard management, container stacking, gate operations, equipment dispatch (RTG, STS, ASC, QC, MHC), TOS integration (NAVIS N4, TOPS Expert), CY operations, and container tracking (RFID). Covers TEU/FEU handling, LoLo/RoRo operations, CFS activities, and terminal performance KPIs. SSOT for terminal operational execution.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` (
    `yard_block_id` BIGINT COMMENT 'Unique identifier for the container yard block. Primary key. MASTER_RESOURCE role entity representing physical yard infrastructure for container stacking operations.',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: ISPS compliance requires each yard block (especially restricted/security zones) to be governed by a specific ISPS facility security record. Port security officers enforce security levels and conduct P',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Yard blocks are infrastructure assets with acquisition costs, depreciation schedules, and maintenance lifecycles. Required for capital asset register, infrastructure valuation, pavement maintenance pl',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Yard blocks function as cost centers for yard operations in terminal accounting. Costs (labor, equipment, utilities) and productivity metrics are tracked by block for operational management, budgeting',
    `storage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.storage_tariff. Business justification: Yard blocks are designated with default storage tariff structures based on block type (reefer, hazmat, general). Terminal capacity planning, block allocation rules, and automated billing systems requi',
    `terminal_id` BIGINT COMMENT 'Foreign key reference to the parent container terminal facility that owns and operates this yard block. Establishes organizational hierarchy for multi-terminal port operations.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key reference to the logical yard zone grouping that this block belongs to. Yard zones aggregate multiple blocks for operational planning, resource allocation, and performance reporting.',
    `area_square_meters` DECIMAL(18,2) COMMENT 'Total surface area of the yard block in square meters. Calculated as length_meters × width_meters. Used for density analysis, utilization reporting, and infrastructure planning.',
    `bay_count` STRING COMMENT 'Number of container bays configured in the yard block layout. Bays run parallel to the equipment travel path and define the blocks length dimension. Each bay typically accommodates one 40-foot container (FEU) or two 20-foot containers (TEU).',
    `block_code` STRING COMMENT 'Externally-known unique alphanumeric code identifying the yard block within the terminal. Used for operational communication, TOS integration, and equipment dispatch instructions.. Valid values are `^[A-Z0-9]{2,10}$`',
    `block_name` STRING COMMENT 'Human-readable descriptive name of the yard block for operational reference and reporting purposes.',
    `block_type` STRING COMMENT 'Classification of the yard block based on primary container handling purpose. Determines container allocation rules, equipment requirements, and operational workflows.. Valid values are `import|export|transshipment|reefer|dangerous_goods|empty`',
    `cctv_coverage` BOOLEAN COMMENT 'Indicates whether the yard block is covered by CCTV surveillance systems for security monitoring, incident investigation, and operational oversight per ISPS Code requirements.',
    `commissioning_date` DATE COMMENT 'Date when the yard block was officially commissioned and made available for container stacking operations. Marks the start of the blocks operational lifecycle.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this yard block master data record was first created in the system. Used for data lineage, audit trails, and record lifecycle tracking.',
    `decommissioning_date` DATE COMMENT 'Date when the yard block was permanently decommissioned and removed from active operations. Null for active blocks. Used for historical capacity analysis and infrastructure lifecycle management.',
    `drainage_system` STRING COMMENT 'Type of water drainage system installed in the yard block to manage rainwater runoff and prevent surface flooding that could disrupt operations or damage containers.. Valid values are `surface|subsurface|combined|none`',
    `environmental_monitoring` BOOLEAN COMMENT 'Indicates whether the yard block is equipped with environmental monitoring sensors for air quality, noise levels, or emissions tracking per environmental management system requirements.',
    `equipment_type` STRING COMMENT 'Primary type of container handling equipment assigned to operate in this yard block. RTG (Rubber Tyred Gantry), ASC (Automated Stacking Crane), AGV (Automated Guided Vehicle), or mobile equipment. Determines operational procedures and throughput capacity.. Valid values are `rtg|asc|reach_stacker|mobile_crane|straddle_carrier|agv`',
    `fire_suppression_system` STRING COMMENT 'Type of fire suppression system installed in the yard block for dangerous goods and reefer container fire safety. Critical for IMDG-certified blocks handling hazardous materials.. Valid values are `sprinkler|foam|dry_chemical|none`',
    `ground_slot_capacity` STRING COMMENT 'Total number of ground-level container positions (slots) available in the yard block. Represents base capacity before vertical stacking. Measured in TEU (Twenty-foot Equivalent Unit) ground slots.',
    `imdg_certified` BOOLEAN COMMENT 'Indicates whether the yard block is certified and equipped to handle dangerous goods containers per IMDG Code requirements. Includes segregation zones, safety equipment, and emergency response infrastructure.',
    `last_maintenance_date` DATE COMMENT 'Date of the most recent preventive or corrective maintenance activity performed on the yard block infrastructure (surface repair, drainage, lighting, reefer racks, etc.).',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the yard block centroid in decimal degrees. Used for GIS integration, asset tracking, and spatial analytics.',
    `length_meters` DECIMAL(18,2) COMMENT 'Physical length of the yard block measured in meters along the bay dimension. Used for spatial planning, equipment travel distance calculations, and capacity modeling.',
    `lighting_available` BOOLEAN COMMENT 'Indicates whether the yard block is equipped with operational lighting infrastructure to support 24/7 container handling operations during night shifts.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the yard block centroid in decimal degrees. Used for GIS integration, asset tracking, and spatial analytics.',
    `max_stack_height` STRING COMMENT 'Maximum number of container tiers (vertical stacking levels) permitted in this yard block. Determined by equipment capabilities (RTG, ASC safe working load), surface load-bearing capacity, and operational safety standards.',
    `next_maintenance_date` DATE COMMENT 'Scheduled date for the next planned maintenance activity on the yard block infrastructure. Used for maintenance planning and operational capacity forecasting.',
    `notes` STRING COMMENT 'Free-text field for additional operational notes, special handling instructions, temporary restrictions, or configuration details not captured in structured fields.',
    `operational_status` STRING COMMENT 'Current lifecycle state of the yard block indicating availability for container stacking operations. Active blocks accept container assignments; inactive/maintenance blocks are temporarily unavailable.. Valid values are `active|inactive|maintenance|planned|decommissioned`',
    `reefer_capable` BOOLEAN COMMENT 'Indicates whether the yard block is equipped with electrical power infrastructure (reefer racks) to support refrigerated containers requiring temperature control.',
    `reefer_plug_count` STRING COMMENT 'Number of electrical power connection points (reefer plugs) available in the yard block for refrigerated container operations. Null if reefer_capable is false.',
    `rfid_enabled` BOOLEAN COMMENT 'Indicates whether the yard block is equipped with RFID infrastructure for automated container tracking, gate automation, and real-time inventory visibility.',
    `row_count` STRING COMMENT 'Number of container rows configured in the yard block layout. Rows run perpendicular to the equipment travel path and define the blocks width dimension.',
    `security_zone` STRING COMMENT 'Security classification level of the yard block per ISPS Code requirements. Determines access control requirements, surveillance coverage, and security personnel deployment.. Valid values are `public|restricted|secure|high_security`',
    `segregation_zone` STRING COMMENT 'Designated segregation zone code for dangerous goods container stacking per IMDG Code segregation requirements. Defines compatibility groups and minimum separation distances.',
    `surface_type` STRING COMMENT 'Type of ground surface material in the yard block. Determines load-bearing capacity, drainage characteristics, equipment compatibility, and maintenance requirements.. Valid values are `asphalt|concrete|gravel|reinforced_concrete|paved`',
    `tier_count` STRING COMMENT 'Number of vertical tiers (stacking levels) configured in the yard block. Tier 1 is ground level; higher tiers represent vertical stacking positions. Must not exceed max_stack_height.',
    `updated_by` STRING COMMENT 'User identifier or system account that last modified this yard block record. Used for audit trails, accountability, and change management.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this yard block master data record was last modified. Used for change tracking, data synchronization, and audit compliance.',
    `weight_scale_available` BOOLEAN COMMENT 'Indicates whether the yard block is equipped with weighbridge or container weighing infrastructure to support SOLAS VGM (Verified Gross Mass) compliance and load planning.',
    `width_meters` DECIMAL(18,2) COMMENT 'Physical width of the yard block measured in meters along the row dimension. Used for spatial planning, equipment clearance validation, and layout optimization.',
    CONSTRAINT pk_yard_block PRIMARY KEY(`yard_block_id`)
) COMMENT 'Master data for container yard blocks within the terminal. Defines physical layout including block identifier, row/tier/bay configuration, ground slot capacity, maximum stacking height, block type (import, export, transshipment, reefer, dangerous goods, empty), surface type, and operational status. Parent entity for all yard_slot records. SSOT for yard spatial planning and container stacking configuration in NAVIS N4 and TOPS Expert TOS.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` (
    `yard_slot_id` BIGINT COMMENT 'Unique identifier for the individual ground slot within the container yard. Primary key for yard slot master data.',
    `icd_facility_id` BIGINT COMMENT 'Foreign key linking to intermodal.icd_facility. Business justification: Yard slots are pre-marshalled by destination ICD to optimize drayage routing. Linking slot to destination ICD enables yard block allocation by ICD corridor, reduces truck travel distance, and supports',
    `yard_block_id` BIGINT COMMENT 'Reference to the parent yard block containing this slot. Links slot to its physical block location within the terminal.',
    `accessibility_rating` STRING COMMENT 'Operational accessibility rating based on equipment reach, traffic flow, and physical constraints. Affects slot utilization priority.. Valid values are `high|medium|low|restricted`',
    `active_flag` BOOLEAN COMMENT 'Indicates whether the slot is currently active and available for operational use. False if decommissioned or permanently blocked.',
    `bay_number` STRING COMMENT 'Bay coordinate within the yard block. Represents the lateral position of the slot in the stacking grid.',
    `commissioning_date` DATE COMMENT 'Date when the slot was first commissioned and made available for container storage operations.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this slot record was first created in the system. Audit trail for data lineage.',
    `customs_inspection_zone` BOOLEAN COMMENT 'Indicates whether the slot is located within a designated customs inspection area. True if subject to enhanced customs controls.',
    `decommissioning_date` DATE COMMENT 'Date when the slot was decommissioned and removed from active service. Null if still active.',
    `distance_to_gate_meters` DECIMAL(18,2) COMMENT 'Distance from this slot to the nearest terminal gate in meters. Used for optimizing container placement and reducing truck turn time.',
    `distance_to_quay_meters` DECIMAL(18,2) COMMENT 'Distance from this slot to the nearest quay crane position in meters. Critical for optimizing vessel loading/discharge operations.',
    `drainage_status` STRING COMMENT 'Condition of drainage infrastructure at the slot. Critical for reefer operations and preventing water damage to cargo.. Valid values are `good|fair|poor|blocked|none`',
    `equipment_access_type` STRING COMMENT 'Type of handling equipment that can access this slot. Determines operational flexibility and throughput capability. [ENUM-REF-CANDIDATE: rtg|sts|asc|qc|mhc|reach_stacker|forklift|multi — 8 candidates stripped; promote to reference product]',
    `hazmat_approved` BOOLEAN COMMENT 'Indicates whether the slot is certified for storing hazardous materials per IMDG Code. True if approved for dangerous goods.',
    `hazmat_class_restrictions` STRING COMMENT 'Comma-separated list of IMDG hazard classes permitted in this slot. Empty if no hazmat approved. Example: 3,4.1,9.',
    `height_clearance_meters` DECIMAL(18,2) COMMENT 'Maximum vertical clearance available at this slot position. Critical for high-cube containers and OOG cargo.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent safety and structural inspection of the slot. Used for maintenance scheduling and compliance tracking.',
    `last_occupied_timestamp` TIMESTAMP COMMENT 'Date and time when a container was last placed in this slot. Used for slot utilization analytics and dwell time calculations.',
    `last_vacated_timestamp` TIMESTAMP COMMENT 'Date and time when the slot was last vacated. Used for slot turnover metrics and yard efficiency KPIs.',
    `length_meters` DECIMAL(18,2) COMMENT 'Physical length of the slot in meters. Determines the maximum container size that can be placed (e.g., 20ft, 40ft, 45ft).',
    `lighting_available` BOOLEAN COMMENT 'Indicates whether the slot has adequate lighting for 24/7 operations. True if lighting meets operational safety standards.',
    `maintenance_notes` STRING COMMENT 'Free-text field for recording maintenance history, known issues, or special handling instructions for the slot.',
    `max_weight_capacity_kg` DECIMAL(18,2) COMMENT 'Maximum gross weight the slot can safely support in kilograms. Derived from ground bearing capacity and structural limits.',
    `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next mandatory inspection of the slot. Ensures compliance with safety and operational standards.',
    `occupied_flag` BOOLEAN COMMENT 'Indicates whether the slot is currently occupied by a container. True if a container is present, false if vacant.',
    `oog_approved` BOOLEAN COMMENT 'Indicates whether the slot can accommodate out-of-gauge cargo that exceeds standard container dimensions. True if OOG capable.',
    `operational_zone` STRING COMMENT 'Logical operational zone or area code within the terminal. Used for yard segmentation and equipment dispatch optimization.. Valid values are `^[A-Z0-9]{1,10}$`',
    `reefer_plug_available` BOOLEAN COMMENT 'Indicates whether the slot is equipped with a reefer power plug for refrigerated containers. True if plug is installed and operational.',
    `reefer_plug_type` STRING COMMENT 'Type of electrical connection available for reefer containers. Specifies voltage and phase configuration of the power supply.. Valid values are `none|single_phase|three_phase|dual`',
    `reefer_voltage` STRING COMMENT 'Voltage rating of the reefer power supply at this slot in volts. Common values are 220V, 380V, or 440V.',
    `reservation_expiry_timestamp` TIMESTAMP COMMENT 'Date and time when the current slot reservation expires. After expiry, the slot becomes available for re-allocation.',
    `reservation_status` STRING COMMENT 'Indicates whether the slot has been reserved for an incoming container. Supports yard planning and berth discharge operations.. Valid values are `none|reserved|pre_allocated|confirmed`',
    `rfid_tag_code` STRING COMMENT 'Unique identifier of the RFID tag installed at this slot for automated container tracking. Null if no RFID infrastructure.. Valid values are `^[A-Z0-9]{8,24}$`',
    `row_number` STRING COMMENT 'Row coordinate within the yard block. Represents the longitudinal position of the slot in the stacking grid.',
    `slot_code` STRING COMMENT 'Unique alphanumeric code identifying the slot within the terminal. Used for operational reference and TOS integration.. Valid values are `^[A-Z0-9]{3,20}$`',
    `slot_status` STRING COMMENT 'Current operational status of the slot. Indicates whether the slot is available for container placement or restricted.. Valid values are `available|occupied|reserved|blocked|maintenance|damaged`',
    `slot_type` STRING COMMENT 'Classification of the slot based on its designated use. Determines what container types can be placed in this slot. [ENUM-REF-CANDIDATE: standard|reefer|oog|hazmat|empty|chassis|special — 7 candidates stripped; promote to reference product]',
    `surface_type` STRING COMMENT 'Type of ground surface at the slot location. Affects load-bearing capacity and equipment accessibility.. Valid values are `asphalt|concrete|gravel|paved|unpaved`',
    `swl_rating_tonnes` DECIMAL(18,2) COMMENT 'Safe Working Load rating for the slot in metric tonnes. Maximum load that can be safely handled by equipment at this position.',
    `teu_capacity` DECIMAL(18,2) COMMENT 'Container capacity of the slot expressed in TEU. Standard slots are 1.0 TEU (20ft) or 2.0 TEU (40ft).',
    `tier_number` STRING COMMENT 'Tier (height level) coordinate within the yard block. Represents the vertical stacking position, with 1 being ground level.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this slot record was last modified. Audit trail for change tracking and data quality monitoring.',
    `width_meters` DECIMAL(18,2) COMMENT 'Physical width of the slot in meters. Standard container width is 2.44m (8ft), but slots may accommodate wider OOG cargo.',
    CONSTRAINT pk_yard_slot PRIMARY KEY(`yard_slot_id`)
) COMMENT 'Master data for individual ground slots within yard blocks. Captures slot coordinates (block, row, bay, tier), slot dimensions, slot type (standard, reefer plug, OOG, hazmat), reefer plug availability, current occupancy status, and weight bearing capacity (SWL). Enables precise container positioning and slot-level yard management in the TOS.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` (
    `container_visit_id` BIGINT COMMENT 'Unique identifier for the container visit record. Primary key for tracking a containers complete terminal visit lifecycle from arrival to departure.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Customs classification, handling method determination, storage area assignment, temperature control requirements, and tariff calculation all depend on HS code reference. Essential for regulatory compl',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Terminal container visits reference standardized container types. Currently container_visit has iso_type_code as a string. Adding FK to masterdata.container_type enables standardized container classif',
    `import_export_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.import_export_permit. Business justification: Container visits for controlled goods (weapons, dual-use items, CITES species, pharmaceuticals) require a valid import/export permit. The TOS must verify permit validity and remaining authorized quant',
    `un_locode_id` BIGINT COMMENT 'Foreign key linking to masterdata.un_locode. Business justification: Port of Loading validation for customs declarations, cargo routing, and vessel stowage planning requires standardized UN/LOCODE reference. Currently stored as text code (pol_code), should reference un',
    `call_id` BIGINT COMMENT 'Reference to the vessel visit during which this container was discharged or is scheduled to be loaded. Links container to vessel operations for vessel-mode arrivals/departures.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Container visits at terminal fulfill cargo bookings. Essential for tracking which booking a container movement satisfies, reconciling booked vs actual cargo, and managing booking-to-delivery lifecycle',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: Rail-port interchange tracking: when a container is loaded onto or discharged from a rail service, the container_visit must reference the rail_visit for TOS work instruction generation, rail cutoff ma',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to cargo.shipment. Business justification: Container visit lifecycle management requires linking to the parent shipment for demurrage calculation, cargo release processing, and TOS-to-commercial reconciliation. Every TOS operator tracks which ',
    `storage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.storage_tariff. Business justification: Container visits accumulate storage charges based on dwell time. Port operations calculate storage fees by applying the applicable storage_tariff rate bands to the dwell_time_hours. Essential for bill',
    `terminal_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal. Business justification: A container visit is the core transactional record of a containers lifecycle at a specific terminal. While terminal is derivable through the chain container_visit -> yard_slot -> yard_block -> termin',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Demurrage charges apply when containers exceed free_time_days. Terminal billing systems reference the demurrage_schedule to calculate tiered daily rates based on dwell time. Critical for revenue manag',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Container handling operations (discharge, load, gate movements) are high-risk activities where incidents occur. Incident investigations must trace to the specific container visit being handled when in',
    `yard_slot_id` BIGINT COMMENT 'Foreign key linking to terminal.yard_slot. Business justification: container_visit has current_yard_location (STRING) and yard_block (STRING) which are denormalized representations of the containers current position. Should FK to yard_slot for authoritative location',
    `arrival_mode` STRING COMMENT 'Transportation mode by which the container arrived at the terminal. Determines gate processing, yard allocation, and intermodal handling requirements.. Valid values are `vessel|truck|rail|barge|internal`',
    `booking_number` STRING COMMENT 'Carrier booking reference number for the container shipment. Links container to commercial booking and shipping instructions.',
    `cargo_type` STRING COMMENT 'High-level classification of cargo carried in the container. Determines handling requirements, equipment assignment, and yard allocation strategy.. Valid values are `general|reefer|hazmat|oog|empty|special`',
    `consignee_name` STRING COMMENT 'Name of the consignee (importer) for this container shipment. Sourced from BOL or booking documentation.',
    `container_number` STRING COMMENT 'Unique container identification number following ISO 6346 standard format (4 letters + 7 digits). The globally unique identifier for the physical container unit.. Valid values are `^[A-Z]{4}[0-9]{7}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this container visit record was first created in the system. Audit field for data lineage and compliance.',
    `damage_description` STRING COMMENT 'Free-text description of container damage if damage_flag is true. Documents condition for repair estimates and liability determination.',
    `damage_flag` BOOLEAN COMMENT 'Indicates whether the container has reported damage. Triggers inspection workflow and potential repair work orders.',
    `demurrage_start_date` DATE COMMENT 'Date when demurrage charges begin to accrue for this container visit. Calculated as arrival date plus free time days.',
    `departure_mode` STRING COMMENT 'Planned or actual transportation mode for container departure from the terminal. Null until departure is scheduled or executed.. Valid values are `vessel|truck|rail|barge|internal`',
    `dwell_time_hours` DECIMAL(18,2) COMMENT 'Total time in hours that the container has remained in the terminal from arrival to current moment (or to departure if departed). Key performance indicator for terminal efficiency and customer service.',
    `final_destination_code` STRING COMMENT 'UN/LOCODE of the final destination for the container cargo. May differ from POD for transshipment or intermodal movements.. Valid values are `^[A-Z]{5}$`',
    `free_time_days` STRING COMMENT 'Number of days of free storage time allowed before demurrage or detention charges begin. Defined by tariff or commercial agreement.',
    `full_empty_indicator` STRING COMMENT 'Indicates whether the container is loaded with cargo (full) or empty. Critical for weight calculations, handling procedures, and billing.. Valid values are `full|empty`',
    `gate_in_timestamp` TIMESTAMP COMMENT 'Date and time when the container physically entered the terminal through the gate. Marks the start of terminal custody and dwell time calculation for truck/rail arrivals.',
    `gate_out_timestamp` TIMESTAMP COMMENT 'Date and time when the container physically exited the terminal through the gate. Marks the end of terminal custody and completes dwell time calculation for truck/rail departures.',
    `imdg_class` STRING COMMENT 'IMDG hazard class code if container carries dangerous goods (e.g., 3 for flammable liquids, 8 for corrosives). Determines segregation, stowage, and handling requirements per IMDG Code.',
    `oog_dimensions` STRING COMMENT 'Description of OOG measurements if oog_flag is true. Specifies overhang dimensions (front, back, left, right, top) in standard format for equipment planning.',
    `oog_flag` BOOLEAN COMMENT 'Indicates whether the container or its cargo exceeds standard ISO dimensions (out-of-gauge). Requires special handling equipment and yard allocation.',
    `pod_code` STRING COMMENT 'UN/LOCODE of the port where the container is to be discharged from the vessel. Five-character code per UN/LOCODE standard.. Valid values are `^[A-Z]{5}$`',
    `reefer_flag` BOOLEAN COMMENT 'Indicates whether the container is a refrigerated (reefer) unit requiring temperature control and power supply during terminal stay.',
    `reefer_humidity_setpoint_pct` DECIMAL(18,2) COMMENT 'Target relative humidity setting for refrigerated container as percentage. Required for certain cargo types (e.g., fresh produce) to prevent spoilage.',
    `reefer_temperature_setpoint_c` DECIMAL(18,2) COMMENT 'Target temperature setting for refrigerated container in degrees Celsius. Critical for cargo preservation; monitored continuously by terminal reefer management system.',
    `reefer_ventilation_setting` STRING COMMENT 'Ventilation configuration for reefer container (e.g., closed, 10 CBM/hr, 20 CBM/hr). Controls fresh air exchange rate for perishable cargo.',
    `rfid_tag_code` STRING COMMENT 'RFID tag identifier attached to the container for automated tracking and gate processing. Enables touchless identification at gate and yard checkpoints.',
    `seal_number_1` STRING COMMENT 'Primary security seal number affixed to the container door. Used for customs verification and cargo security tracking per ISPS Code requirements.',
    `seal_number_2` STRING COMMENT 'Secondary or customs seal number if multiple seals are applied. Common for high-security shipments or specific customs requirements.',
    `shipper_name` STRING COMMENT 'Name of the shipper (exporter) for this container shipment. Sourced from BOL or booking documentation.',
    `tare_weight_kg` DECIMAL(18,2) COMMENT 'Empty weight of the container itself in kilograms, excluding cargo. Used for VGM Method 2 calculations and payload verification.',
    `teu_factor` DECIMAL(18,2) COMMENT 'TEU conversion factor for the container. Standard values: 1.0 for 20ft containers, 2.0 for 40ft containers, 2.25 for 45ft containers. Used for capacity planning and billing calculations.',
    `tos_reference_code` STRING COMMENT 'Native identifier for this container visit in the source Terminal Operating System (NAVIS N4 or TOPS Expert). Used for system integration and audit trail.',
    `un_number` STRING COMMENT 'Four-digit UN number identifying the specific dangerous goods substance (e.g., UN1203 for gasoline). Required for hazmat containers per IMDG Code.. Valid values are `^UN[0-9]{4}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this container visit record was last modified. Audit field for change tracking and data quality monitoring.',
    `vessel_discharge_timestamp` TIMESTAMP COMMENT 'Date and time when the container was discharged from the vessel onto the terminal. Applicable for vessel arrival mode; marks start of terminal custody for vessel-delivered containers.',
    `vessel_load_timestamp` TIMESTAMP COMMENT 'Date and time when the container was loaded onto the vessel from the terminal. Applicable for vessel departure mode; marks end of terminal custody for vessel-bound containers.',
    `vgm_method` STRING COMMENT 'Method used to determine VGM: Method 1 (weighing packed container) or Method 2 (weighing contents and adding tare weight). Required for SOLAS compliance documentation.. Valid values are `method_1|method_2`',
    `vgm_weight_kg` DECIMAL(18,2) COMMENT 'Verified Gross Mass of the packed container in kilograms, as required by SOLAS regulation VI/2. Mandatory for all full export containers before vessel loading.',
    `visit_status` STRING COMMENT 'Current lifecycle status of the container visit within the terminal. Tracks progression from arrival through departure, including hold states for customs or operational reasons.. Valid values are `inbound|in_yard|outbound|departed|on_hold|customs_hold`',
    CONSTRAINT pk_container_visit PRIMARY KEY(`container_visit_id`)
) COMMENT 'Transactional record of a containers complete terminal visit lifecycle from arrival (gate-in, vessel discharge, or rail-in) to departure (gate-out, vessel load, or rail-out). Captures container number, ISO type code (per BIC/ISO 6346), size (TEU/FEU), visit status (inbound, in-yard, outbound, departed), current yard slot position, vessel visit reference, BOL reference, cargo type, VGM weight (SOLAS), seal numbers, damage flags, reefer temperature settings, IMDG class, TOS tracking identifiers, and dwell time. Core operational entity linking all terminal activities — gate transactions, equipment moves, reefer monitoring, service orders, and hazmat declarations reference this record. Aligns with DCSA Transport Event model for container tracking milestones. SSOT for real-time container position and status within NAVIS N4 and TOPS Expert.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` (
    `gate_transaction_id` BIGINT COMMENT 'Primary key for gate_transaction',
    `container_visit_id` BIGINT COMMENT 'Foreign key linking to terminal.container_visit. Business justification: Each gate transaction (gate-in or gate-out) is part of a containers terminal visit lifecycle. The gate_transaction table has container_number (STRING) but no FK to container_visit. Adding container_v',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Gate clerks verify customs broker authorization during cargo release at gate-out. The executed gate_transaction must record which licensed customs broker authorized the release for audit trail, AEO co',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Gate cannot release containers under active customs hold. Real-time hold status check at gate is critical operational control point. Prevents unauthorized release of detained cargo.',
    `import_export_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.import_export_permit. Business justification: At gate-out, terminal systems must verify a valid import/export permit exists for controlled goods (dual-use, CITES, strategic goods) before releasing the container. The gate_transaction must referenc',
    `port_community_participant_id` BIGINT COMMENT 'Identifier of the trucking or transport company responsible for the container movement.',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: Gate performance reporting, ISPS access control audits, and lane utilization analysis require knowing which physical port_gate processed each transaction. Enables per-gate throughput KPIs, OCR/ANPR sy',
    `port_location_id` BIGINT COMMENT 'Identifier of the gate clerk or operator who processed the transaction.',
    `gate_appointment_id` BIGINT COMMENT 'Foreign key linking to terminal.gate_appointment. Business justification: Gate transactions often fulfill pre-booked appointments. The gate_transaction has appointment_reference (STRING) which should be normalized to FK to gate_appointment. Business reality: a gate transact',
    `terminal_id` BIGINT COMMENT 'Identifier of the physical gate lane through which the transaction occurred.',
    `truck_appointment_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_appointment. Business justification: Gate transactions execute pre-booked truck appointments. TOS systems match arriving trucks to appointment slots for validation, lane assignment, and processing time tracking. Critical for appointment ',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Gate operations involve truck movements, container lifting, and driver interactions—common incident scenarios. Incident reports must reference the specific gate transaction during which the incident o',
    `anpr_capture_reference` STRING COMMENT 'Reference identifier to the ANPR (Automatic Number Plate Recognition) system capture of vehicle license plates for automated gate processing.',
    `booking_reference` STRING COMMENT 'Shipping line booking reference number associated with the container movement.',
    `coparn_reference` STRING COMMENT 'Reference to the COPARN EDI message (Container Pre-Announcement) sent prior to gate arrival for pre-clearance and planning.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this gate transaction record was first created in the NAVIS N4 system.',
    `damage_description` STRING COMMENT 'Free-text description of any damage observed on the container, chassis, or cargo during gate processing.',
    `damage_flag` BOOLEAN COMMENT 'Boolean indicator whether visible damage to the container or cargo was detected during gate inspection.',
    `driver_license_number` STRING COMMENT 'Government-issued driver license number used for driver identity verification at gate entry.',
    `driver_name` STRING COMMENT 'Full legal name of the driver presenting at the gate for identity verification and security compliance.',
    `driver_phone_number` STRING COMMENT 'Contact telephone number for the driver for operational communication and emergency contact purposes.',
    `gate_clerk_override_flag` BOOLEAN COMMENT 'Boolean indicator whether the gate clerk manually overrode automated gate processing rules or validations.',
    `imdg_class` STRING COMMENT 'IMDG (International Maritime Dangerous Goods) classification code if the container carries hazardous materials, per IMDG Code classification system.',
    `modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this gate transaction record was last updated or modified.',
    `ocr_capture_reference` STRING COMMENT 'Reference identifier to the OCR (Optical Character Recognition) system capture of container number, license plates, and other visual data at gate.',
    `override_reason` STRING COMMENT 'Free-text explanation provided by the gate clerk for any manual override or exception processing.',
    `processing_duration_seconds` STRING COMMENT 'Total time in seconds taken to process the gate transaction from entry to exit, used for gate performance KPI measurement.',
    `reefer_temperature_actual_c` DECIMAL(18,2) COMMENT 'Actual temperature reading in Celsius from the reefer container monitoring system at gate transaction time.',
    `reefer_temperature_setpoint_c` DECIMAL(18,2) COMMENT 'Target temperature setpoint in Celsius for refrigerated (reefer) containers requiring temperature control.',
    `rfid_tag_number` STRING COMMENT 'RFID (Radio Frequency Identification) tag number read from the container or vehicle for automated tracking and identification.',
    `rpm_scan_result` STRING COMMENT 'Result of the RPM (Radiation Portal Monitor) scan performed at gate entry for security screening and detection of radioactive materials.. Valid values are `clear|alarm|not_scanned|equipment_failure`',
    `seal_number` STRING COMMENT 'Security seal number affixed to the container door for tamper detection and cargo security verification.',
    `seal_verification_status` STRING COMMENT 'Status of the container seal verification check performed at gate, indicating seal integrity.. Valid values are `verified|broken|missing|not_checked`',
    `trailer_license_plate` STRING COMMENT 'Vehicle registration number of the trailer or chassis unit, if separate from the tractor unit.',
    `transaction_number` STRING COMMENT 'Externally-visible business identifier for the gate transaction, used for operational reference and audit trails.. Valid values are `^GTX[0-9]{10}$`',
    `transaction_status` STRING COMMENT 'Current lifecycle status of the gate transaction indicating processing state and completion.. Valid values are `pending|in_progress|completed|rejected|cancelled`',
    `transaction_timestamp` TIMESTAMP COMMENT 'Precise date and time when the container or vehicle movement through the gate occurred, representing the primary business event time.',
    `transaction_type` STRING COMMENT 'Classification of the gate movement type indicating the mode of transport and direction of movement through the terminal gate.. Valid values are `truck_in|truck_out|rail_in|rail_out|vessel_in|vessel_out`',
    `truck_license_plate` STRING COMMENT 'Vehicle registration number of the truck or tractor unit involved in the gate transaction, captured via ANPR (Automatic Number Plate Recognition) or manual entry.',
    `verified_gross_mass_kg` DECIMAL(18,2) COMMENT 'VGM (Verified Gross Mass) of the packed container as required by SOLAS regulations for vessel loading safety.',
    `weight_bridge_reading_kg` DECIMAL(18,2) COMMENT 'Gross weight of the container and vehicle measured at the terminal weight bridge in kilograms, used for safety compliance and billing verification.',
    `yard_location_assignment` STRING COMMENT 'Assigned yard location (block, row, tier) where the container will be or was stacked in the Container Yard (CY).',
    CONSTRAINT pk_gate_transaction PRIMARY KEY(`gate_transaction_id`)
) COMMENT 'Transactional record of every container or vehicle movement through the terminal gate complex. Captures gate lane, transaction type (truck-in, truck-out, rail-in, rail-out), container number (per ISO 6346), truck/vehicle registration, driver identity, appointment reference, COPARN pre-announcement reference, customs release status, radiation portal monitor (RPM) scan result, weight bridge reading, OCR/ANPR capture reference, timestamp of entry/exit, and gate clerk override flags. Supports ISPS Code gate security requirements. SSOT for gate operations in NAVIS N4.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` (
    `gate_appointment_id` BIGINT COMMENT 'Primary key for gate_appointment',
    `container_visit_id` BIGINT COMMENT 'Foreign key linking to terminal.container_visit. Business justification: Gate appointments are pre-booked for container movements (gate-in or gate-out) that are part of terminal visits. The gate_appointment table has container_number (STRING) but no FK to container_visit. ',
    `customs_broker_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_broker. Business justification: Pre-registered gate appointments reference driver/haulier access credentials for expedited processing, security validation, and MARSEC-level access control. Enables automated credential verification a',
    `call_id` BIGINT COMMENT 'Identifier linking to the vessel visit for which this container is being delivered or received, establishing the vessel-cargo relationship.',
    `port_community_participant_id` BIGINT COMMENT 'Identifier linking to the port community participant (haulier, shipping line, freight forwarder) associated with this appointment.',
    `port_gate_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port_gate. Business justification: Gate appointment scheduling assigns trucks to specific physical gates for lane capacity balancing and congestion management. Port operators need gate_appointment → port_gate to produce per-gate appoin',
    `port_location_id` BIGINT COMMENT 'Identifier of the terminal gate operator who processed the appointment transaction.',
    `terminal_id` BIGINT COMMENT 'Foreign key linking to terminal.gate_lane. Business justification: Gate appointments are scheduled for specific gate lanes. The gate_appointment table currently has gate_lane_number (STRING) but no FK relationship. Adding gate_lane_id FK enables proper referential in',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Gate appointments are scheduled for container pickup/delivery tied to specific cargo bookings. Links appointment system to cargo booking for delivery order validation and container release authorizati',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the truck arrived at the terminal gate, captured by gate operating system or RFID readers.',
    `actual_departure_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the truck departed from the terminal gate after completing the transaction.',
    `appointment_date` DATE COMMENT 'Calendar date for which the gate appointment is scheduled.',
    `appointment_number` STRING COMMENT 'Externally-known unique business identifier for the gate appointment, used for tracking and reference by hauliers and terminal operators.. Valid values are `^[A-Z0-9]{8,20}$`',
    `appointment_status` STRING COMMENT 'Current lifecycle status of the gate appointment indicating its progression through the gate transaction workflow. [ENUM-REF-CANDIDATE: pending|confirmed|arrived|in_progress|completed|cancelled|no_show — 7 candidates stripped; promote to reference product]',
    `appointment_window_end` TIMESTAMP COMMENT 'End timestamp of the scheduled appointment time slot window, defining the latest acceptable arrival time for the appointment.',
    `appointment_window_start` TIMESTAMP COMMENT 'Start timestamp of the scheduled appointment time slot window during which the truck is expected to arrive at the gate.',
    `booking_reference` STRING COMMENT 'Shipping line booking reference number associated with the container being handled in this gate transaction.',
    `cancellation_reason` STRING COMMENT 'Reason provided for cancellation of the gate appointment, applicable when appointment_status is cancelled.',
    `coparn_message_reference` STRING COMMENT 'Reference to the COPARN EDI message (EDIFACT) that pre-announced the container arrival or departure, enabling advance planning.',
    `created_by_user` STRING COMMENT 'User identifier or system account that created the gate appointment record.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the gate appointment record was first created in the system.',
    `haulier_code` STRING COMMENT 'Unique code identifying the transport operator or haulage company responsible for the container movement.. Valid values are `^[A-Z0-9]{3,10}$`',
    `haulier_name` STRING COMMENT 'Business name of the transport operator or haulage company performing the gate transaction.',
    `iftmin_message_reference` STRING COMMENT 'Reference to the IFTMIN EDI message containing transport instructions related to this gate appointment.',
    `imdg_class` STRING COMMENT 'IMDG classification code for hazardous cargo (e.g., Class 1 Explosives, Class 3 Flammable Liquids), applicable when is_hazardous_cargo is true.',
    `inspection_required` BOOLEAN COMMENT 'Flag indicating whether the container has been selected for physical inspection by customs, port state control, or security authorities.',
    `inspection_type` STRING COMMENT 'Type of inspection required for the container (customs examination, security scan, quarantine check, port state control).. Valid values are `customs|security|quarantine|psc|none`',
    `is_hazardous_cargo` BOOLEAN COMMENT 'Flag indicating whether the container contains hazardous or dangerous goods requiring special handling per IMDG Code.',
    `is_overweight` BOOLEAN COMMENT 'Flag indicating whether the container exceeds standard weight limits and requires special handling or equipment.',
    `modified_by_user` STRING COMMENT 'User identifier or system account that last modified the gate appointment record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the gate appointment record was last modified or updated.',
    `no_show_flag` BOOLEAN COMMENT 'Flag indicating whether the truck failed to arrive during the scheduled appointment window without prior cancellation.',
    `processing_duration_minutes` STRING COMMENT 'Total time in minutes taken to process the gate transaction from arrival to departure, used for KPI measurement.',
    `reefer_temperature_celsius` DECIMAL(18,2) COMMENT 'Required temperature setting in Celsius for refrigerated containers, applicable when container_size_type indicates reefer unit.',
    `remarks` STRING COMMENT 'Free-text remarks or notes recorded by gate operators regarding special circumstances, issues, or observations during the appointment.',
    `transaction_type` STRING COMMENT 'Type of gate transaction being performed, defining the nature of container movement through the terminal gate.. Valid values are `delivery|receival|empty_return|empty_pickup|export_drop|import_pickup`',
    `truck_driver_license` STRING COMMENT 'Driver license number of the truck driver, captured for security and compliance purposes.',
    `truck_driver_name` STRING COMMENT 'Full name of the truck driver presenting at the gate for the appointment.',
    `truck_registration` STRING COMMENT 'Vehicle registration plate number of the truck making the gate appointment, used for access control and tracking.. Valid values are `^[A-Z0-9]{4,15}$`',
    `un_number` STRING COMMENT 'Four-digit UN number identifying the hazardous substance being transported, required for dangerous goods declarations.. Valid values are `^UN[0-9]{4}$`',
    `verified_gross_mass_kg` DECIMAL(18,2) COMMENT 'SOLAS-compliant verified gross mass of the packed container in kilograms, mandatory for export containers.',
    `vgm_method` STRING COMMENT 'SOLAS method used to determine VGM: Method 1 (weighing packed container) or Method 2 (weighing contents and adding tare).. Valid values are `method_1|method_2`',
    CONSTRAINT pk_gate_appointment PRIMARY KEY(`gate_appointment_id`)
) COMMENT 'Master record for pre-booked truck gate appointments. Captures appointment number, appointment window (date/time slot), container number, truck registration, haulier/transport operator, transaction type (delivery, receival, empty return, empty pickup), appointment status (pending, confirmed, arrived, completed, cancelled, no-show), and COPARN/IFTMIN message reference. Enables controlled gate flow and reduces truck queuing.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` (
    `equipment_dispatch_id` BIGINT COMMENT 'Unique identifier for the equipment dispatch work instruction record. Primary key.',
    `charge_event_id` BIGINT COMMENT 'Foreign key linking to billing.charge_event. Business justification: Each productive equipment dispatch (crane lift, RTG move) generates a THC charge event. Linking equipment_dispatch → charge_event enables move-level billing reconciliation, productivity-based billing ',
    `container_visit_id` BIGINT COMMENT 'Foreign key linking to terminal.container_visit. Business justification: Equipment dispatch work instructions move containers that are part of terminal visits. The equipment_dispatch table has container_number (STRING) but no FK to container_visit. Adding container_visit_i',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: TOS work-instruction processing requires checking customs hold status before dispatching equipment to move a container. The equipment_dispatch record must reference the blocking customs_hold to enforc',
    `equipment_id` BIGINT COMMENT 'Unique identifier of the specific terminal handling equipment unit assigned to execute this dispatch instruction (e.g., RTG-0012, STS-0003, ASC-0007). Format: three-letter equipment type code followed by hyphen and four-digit unit number.',
    `call_id` BIGINT COMMENT 'Foreign key reference to the vessel visit for vessel loading/discharge operations. Null for yard-only or gate operations.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Equipment dispatches represent resource consumption that must be allocated to cost centers for activity-based costing, operational cost control, and productivity analysis. Each dispatch is costed to t',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: Terminal equipment dispatches load/discharge containers to/from rail wagons. Linking dispatch to rail visit enables rail productivity reporting (moves per hour), rail operator billing verification, an',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Equipment dispatches for vessel operations (especially quay crane moves) are performed by stevedore gangs. Tracking gang assignment enables gang productivity measurement (moves per gang hour), labor c',
    `truck_appointment_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_appointment. Business justification: Equipment-to-truck coordination: when a crane or RTG is dispatched to handle a container for a truck pickup, the dispatch must reference the truck_appointment to synchronise equipment arrival with the',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: When a crane or yard equipment dispatch results in a breakdown or damage event, the resulting work order must be traceable to the originating dispatch for crane availability KPI reporting, SLA breach ',
    `bay_position` STRING COMMENT 'Vessel bay number for container stowage position (e.g., 012, 084). Two or three-digit bay identifier. Null for non-vessel operations.. Valid values are `^[0-9]{2,3}$`',
    `bill_of_lading_number` STRING COMMENT 'BOL (Bill of Lading) number for the shipment associated with this container or cargo. Legal document of title and receipt.',
    `booking_reference` STRING COMMENT 'Shipping line booking reference number associated with this container or cargo. Used for customer billing and service tracking.',
    `cargo_reference` STRING COMMENT 'General cargo identifier for non-containerized cargo (breakbulk, RoRo units, project cargo). Used when container_number is null.',
    `completion_timestamp` TIMESTAMP COMMENT 'Date and time when the work instruction was completed by the equipment operator. Null if not yet completed.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this equipment dispatch record was first created in the TOS system. Audit trail field.',
    `customs_hold_flag` BOOLEAN COMMENT 'Indicates whether the container or cargo is under customs hold (True) and cannot be released until customs clearance is obtained, or cleared for release (False).',
    `damage_flag` BOOLEAN COMMENT 'Indicates whether the container or cargo has reported damage (True) requiring inspection or special handling, or no damage (False).',
    `destination_position` STRING COMMENT 'Target location for the container or cargo in yard slot coordinate format: block-bay-row-tier. For vessel loading, uses vessel hatch-bay-row-tier format. For gate operations, may use gate lane identifier.. Valid values are `^[A-Z0-9]{2,3}-[0-9]{2}-[0-9]{2}-[0-9]{2}$`',
    `dispatch_source` STRING COMMENT 'Origin of the dispatch instruction: TOS_auto_dispatch (system-generated by NAVIS N4 or TOPS Expert auto-dispatch algorithm), manual_planner_override (planner manual assignment), operator_request (operator-initiated), emergency_dispatch (urgent safety or operational requirement).. Valid values are `TOS_auto_dispatch|manual_planner_override|operator_request|emergency_dispatch`',
    `dispatch_status` STRING COMMENT 'Current lifecycle status of the dispatch instruction: pending (queued for assignment), assigned (allocated to equipment), in_progress (actively executing), completed (finished successfully), cancelled (voided before execution), suspended (temporarily halted).. Valid values are `pending|assigned|in_progress|completed|cancelled|suspended`',
    `dispatch_timestamp` TIMESTAMP COMMENT 'Date and time when the work instruction was dispatched to the equipment operator or automated system. Represents the principal business event time for this transaction.',
    `equipment_type` STRING COMMENT 'Classification of terminal handling equipment: RTG (Rubber Tyred Gantry), STS (Ship-to-Shore crane), QC (Quay Crane), ASC (Automated Stacking Crane), MHC (Mobile Harbour Crane), AGV (Automated Guided Vehicle), reach_stacker, forklift, empty_handler, terminal_tractor. [ENUM-REF-CANDIDATE: RTG|STS|QC|ASC|MHC|AGV|reach_stacker|forklift|empty_handler|terminal_tractor — 10 candidates stripped; promote to reference product]',
    `gross_crane_time_seconds` STRING COMMENT 'Total elapsed time in seconds from crane hook engagement to hook release, including all delays. Used for STS/QC productivity analysis. Null for non-crane operations.',
    `hatch_position` STRING COMMENT 'Vessel hatch identifier for STS/QC crane operations (e.g., H01, H12). Format: H followed by two-digit hatch number. Null for non-vessel operations.. Valid values are `^H[0-9]{2}$`',
    `hazmat_flag` BOOLEAN COMMENT 'Indicates whether the container or cargo contains hazardous materials (True) requiring IMDG Code compliance and special handling procedures, or non-hazardous (False).',
    `idle_time_seconds` STRING COMMENT 'Non-productive idle time in seconds during the dispatch operation due to delays, waiting, or interruptions. Calculated as gross_crane_time_seconds minus net_crane_time_seconds for crane operations.',
    `imdg_class` STRING COMMENT 'IMDG hazard classification for dangerous goods: 1 (explosives), 2.1 (flammable gas), 2.2 (non-flammable gas), 2.3 (toxic gas), 3 (flammable liquid), 4.1 (flammable solid), 4.2 (spontaneously combustible), 4.3 (dangerous when wet), 5.1 (oxidizer), 5.2 (organic peroxide), 6.1 (toxic), 6.2 (infectious), 7 (radioactive), 8 (corrosive), 9 (miscellaneous). Null for non-hazmat cargo.. Valid values are `1|2.1|2.2|2.3|3|4.1|4.2|4.3|5.1|5.2|6.1|6.2|7|8|9`',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this equipment dispatch record was last modified in the TOS system. Audit trail field.',
    `moves_per_hour` DECIMAL(18,2) COMMENT 'Equipment productivity metric calculated as moves completed per hour. Key performance indicator for terminal equipment efficiency. Typical ranges: STS/QC 25-35 MPH, RTG 15-20 MPH, ASC 20-25 MPH.',
    `net_crane_time_seconds` STRING COMMENT 'Productive crane time in seconds excluding idle time, delays, and interruptions. Used to calculate net crane productivity. Null for non-crane operations.',
    `origin_position` STRING COMMENT 'Starting location of the container or cargo in yard slot coordinate format: block-bay-row-tier (e.g., YA-12-05-03 for yard block YA, bay 12, row 5, tier 3). For vessel operations, uses hatch-bay-row-tier format.. Valid values are `^[A-Z0-9]{2,3}-[0-9]{2}-[0-9]{2}-[0-9]{2}$`',
    `oversized_flag` BOOLEAN COMMENT 'Indicates whether the cargo exceeds standard container dimensions (True) requiring special handling equipment or procedures, or standard size (False).',
    `priority_level` STRING COMMENT 'Dispatch priority ranking from 1 (highest) to 10 (lowest). Used by TOS auto-dispatch algorithms to sequence work instructions. Vessel operations typically receive priority 1-3, gate operations 4-6, yard housekeeping 7-10.',
    `productive_flag` BOOLEAN COMMENT 'Indicates whether this dispatch represents a productive move (True) or non-productive move (False). Productive moves directly contribute to vessel or customer operations; non-productive moves are internal yard housekeeping or rehandles.',
    `reefer_flag` BOOLEAN COMMENT 'Indicates whether the container is a refrigerated (reefer) container (True) requiring temperature-controlled storage and power connection, or non-reefer (False).',
    `reefer_temperature_celsius` DECIMAL(18,2) COMMENT 'Required temperature setpoint in degrees Celsius for refrigerated containers. Typical range: -30°C to +30°C. Null for non-reefer containers.',
    `rehandle_flag` BOOLEAN COMMENT 'Indicates whether this dispatch is a rehandle operation (True) - moving a container to access another container - or a direct move (False). Rehandles negatively impact terminal productivity metrics.',
    `rehandle_reason_code` STRING COMMENT 'Reason code for rehandle operations: access_obstruction (blocking container), weight_segregation (stacking by weight class), hazmat_compliance (IMDG segregation), reefer_relocation (reefer plug availability), vessel_premarshal (pre-stow optimization), damage_inspection (damage assessment access), customs_hold (regulatory inspection). Null for non-rehandle moves. [ENUM-REF-CANDIDATE: access_obstruction|weight_segregation|hazmat_compliance|reefer_relocation|vessel_premarshal|damage_inspection|customs_hold — 7 candidates stripped; promote to reference product]',
    `spreader_type` STRING COMMENT 'Type of crane spreader attachment used for this lift: standard_20ft (fixed 20-foot), standard_40ft (fixed 40-foot), telescopic (adjustable 20-40 foot), twin_20ft (dual 20-foot), tandem_40ft (dual 40-foot for heavy lifts), breakbulk_hook (non-container cargo). Applicable to crane operations.. Valid values are `standard_20ft|standard_40ft|telescopic|twin_20ft|tandem_40ft|breakbulk_hook`',
    `tandem_lift_flag` BOOLEAN COMMENT 'Indicates whether this operation uses tandem-lift (True) - two cranes working together on a single heavy lift - or single crane (False). Used for oversized or heavy project cargo.',
    `twin_lift_flag` BOOLEAN COMMENT 'Indicates whether this crane operation is a twin-lift (True) - lifting two 20-foot containers simultaneously - or single lift (False). Applicable only to STS/QC crane operations.',
    `work_instruction_number` STRING COMMENT 'Externally-known unique business identifier for the dispatch work instruction, formatted as WI- followed by 10 digits. Used for tracking and reference across TOS systems.. Valid values are `^WI-[0-9]{10}$`',
    `work_instruction_type` STRING COMMENT 'Type of equipment operation being dispatched: lift (vertical movement), move (horizontal transfer), load (vessel loading), discharge (vessel unloading), shift (yard repositioning), restow (vessel re-stowage), rehandle (access movement), reshuffle (yard optimization). [ENUM-REF-CANDIDATE: lift|move|load|discharge|shift|restow|rehandle|reshuffle — 8 candidates stripped; promote to reference product]',
    CONSTRAINT pk_equipment_dispatch PRIMARY KEY(`equipment_dispatch_id`)
) COMMENT 'Transactional record of individual work instructions dispatched to terminal handling equipment (RTG, STS/QC, ASC, MHC, AGV, reach stacker, forklift). Captures work instruction type (lift, move, load, discharge, shift, restow, rehandle/reshuffle), equipment unit assigned, container or cargo reference, origin and destination positions (slot coordinates), priority level, dispatch and completion timestamps, operator ID, productive/non-productive flag, rehandle reason code (access obstruction, weight segregation, hazmat compliance, reefer relocation, vessel pre-marshalling), crane-specific attributes (hatch/bay position, twin-lift/tandem-lift flag, idle time, spreader type, gross/net crane time for STS/QC operations), and moves-per-hour (MPH) productivity metric. Supports TOS auto-dispatch and manual planner override workflows. SSOT for ALL equipment movement instructions including quay crane lifts and yard rehandles in TOPS Expert and NAVIS N4.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` (
    `vessel_bay_plan_id` BIGINT COMMENT 'Unique identifier for the vessel bay plan record. Primary key for vessel stowage and operational planning.',
    `berth_allocation_id` BIGINT COMMENT 'Reference to the berth allocation record specifying where the vessel will dock.',
    `container_visit_id` BIGINT COMMENT 'Foreign key linking to terminal.container_visit. Business justification: Vessel bay plan records define the stowage position of containers that are part of terminal visits (either being loaded or discharged). The vessel_bay_plan table has container_number (STRING) but no F',
    `call_id` BIGINT COMMENT 'Reference to the specific vessel call or visit for which this bay plan applies.',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Bay plans are stowage plans created for vessel call bookings. Links planning artifact to original booking for tracking booking requirements (reefer count, hazmat, TEU) against planned stowage configur',
    `port_location_id` BIGINT COMMENT 'Reference to the terminal operations planner or vessel planner responsible for creating and maintaining this bay plan.',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: Pre-marshalling for rail departure: the vessel bay plan must reference the rail_visit to sequence containers destined for rail departure, enabling pre-marshalling planning that aligns vessel discharge',
    `stowage_plan_id` BIGINT COMMENT 'Foreign key linking to cargo.stowage_plan. Business justification: The vessel bay plan is the terminals operational execution of the stowage plan; terminal planners derive bay-level load/discharge sequences directly from the stowage plan. Linking these supports stow',
    `bay_number` STRING COMMENT 'Longitudinal position identifier on the vessel indicating the bay location for container stowage.',
    `cargo_cutoff_datetime` TIMESTAMP COMMENT 'Deadline timestamp by which all export cargo must be delivered to the terminal for loading onto this vessel call.',
    `discharge_sequence` STRING COMMENT 'Planned sequence order for discharging this container from the vessel to optimize operational efficiency.',
    `hatch_number` STRING COMMENT 'Vessel hatch identifier for grouping bays and planning hatch cover operations and crane work sequences.',
    `hatch_sequence_plan` STRING COMMENT 'Planned operational sequence for working vessel hatches to optimize crane productivity and minimize vessel turnaround time.',
    `imdg_class` STRING COMMENT 'Hazardous goods classification code per IMDG Code for dangerous cargo (e.g., Class 3 for flammable liquids). Null for non-hazardous cargo.',
    `load_sequence` STRING COMMENT 'Planned sequence order for loading this container onto the vessel to optimize operational efficiency and vessel stability.',
    `oog_flag` BOOLEAN COMMENT 'Indicates whether the container or cargo exceeds standard ISO dimensions requiring special handling and stowage considerations.',
    `oog_overhang_front_cm` DECIMAL(18,2) COMMENT 'Front overhang dimension in centimeters for out-of-gauge cargo. Null for standard containers.',
    `oog_overhang_left_cm` DECIMAL(18,2) COMMENT 'Left side overhang dimension in centimeters for out-of-gauge cargo. Null for standard containers.',
    `oog_overhang_rear_cm` DECIMAL(18,2) COMMENT 'Rear overhang dimension in centimeters for out-of-gauge cargo. Null for standard containers.',
    `oog_overhang_right_cm` DECIMAL(18,2) COMMENT 'Right side overhang dimension in centimeters for out-of-gauge cargo. Null for standard containers.',
    `oog_overheight_cm` DECIMAL(18,2) COMMENT 'Height overhang dimension in centimeters for out-of-gauge cargo. Null for standard containers.',
    `plan_approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this vessel bay plan was formally approved and released for operational execution.',
    `plan_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this vessel bay plan record was initially created in the terminal operating system.',
    `plan_status` STRING COMMENT 'Current lifecycle status of the vessel bay plan indicating planning and execution stage.. Valid values are `draft|confirmed|in_progress|completed|cancelled|revised`',
    `plan_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this vessel bay plan record was last modified or revised.',
    `plan_version` STRING COMMENT 'Version number of the bay plan to track revisions and updates to the stowage plan throughout the vessel call lifecycle.',
    `planned_crane_count` STRING COMMENT 'Number of STS (Ship-to-Shore) or QC (Quay Crane) units allocated for this vessel operation to achieve target productivity.',
    `planned_gang_count` STRING COMMENT 'Number of stevedore gangs or labor teams allocated for vessel loading and discharge operations.',
    `planned_operation_end` TIMESTAMP COMMENT 'Scheduled timestamp for completing all vessel cargo operations including final crane move and securing.',
    `planned_operation_start` TIMESTAMP COMMENT 'Scheduled timestamp for commencing vessel cargo operations including first crane move.',
    `pod_code` STRING COMMENT 'UN/LOCODE for the port where this container is scheduled to be discharged from the vessel.',
    `pol_code` STRING COMMENT 'UN/LOCODE for the port where this container was loaded onto the vessel.',
    `pre_marshalling_required` BOOLEAN COMMENT 'Indicates whether containers require pre-marshalling or repositioning in the yard prior to vessel loading to optimize load sequence.',
    `reefer_flag` BOOLEAN COMMENT 'Indicates whether the container is a refrigerated unit requiring temperature control and power connection.',
    `reefer_temperature_c` DECIMAL(18,2) COMMENT 'Required temperature setting in Celsius for refrigerated containers. Null for non-reefer units.',
    `resource_allocation_notes` STRING COMMENT 'Free-text notes documenting equipment allocation decisions, operational constraints, or special resource requirements for this vessel call.',
    `restow_flag` BOOLEAN COMMENT 'Indicates whether this container requires restowing or repositioning on the vessel to access underlying cargo or optimize stowage.',
    `row_number` STRING COMMENT 'Transverse position identifier on the vessel indicating the row location for container stowage.',
    `seal_number` STRING COMMENT 'Container seal number for security and customs verification purposes.',
    `stowage_instruction` STRING COMMENT 'Special handling or stowage instructions for the container including segregation requirements, securing notes, or operational constraints.',
    `teu_count` DECIMAL(18,2) COMMENT 'Total TEU count for this vessel call bay plan representing standardized container volume measurement.',
    `tier_number` STRING COMMENT 'Vertical position identifier on the vessel indicating the tier or stack level for container stowage.',
    `total_discharge_moves` STRING COMMENT 'Total number of container discharge moves planned for this vessel call across all bays and hatches.',
    `total_load_moves` STRING COMMENT 'Total number of container load moves planned for this vessel call across all bays and hatches.',
    `transhipment_flag` BOOLEAN COMMENT 'Indicates whether this container is transhipment cargo that will be transferred to another vessel at this port.',
    `un_number` STRING COMMENT 'United Nations number identifying hazardous substances and articles for dangerous goods. Null for non-hazardous cargo.',
    CONSTRAINT pk_vessel_bay_plan PRIMARY KEY(`vessel_bay_plan_id`)
) COMMENT 'Master record of the vessel call operational and stowage plan combining BAPLIE (UN/EDIFACT) data with resource and operation planning. Captures vessel visit reference, berth allocation reference, bay/row/tier container positions, ISO types, weights, POD/POL, hazardous goods class, reefer settings, OOG dimensions, stowage instructions, total planned discharge and load moves, planned crane and gang count, planned operation start/end time, cargo cut-off datetime, hatch sequence plan, pre-marshalling requirements, operation planner ID, and resource allocation notes. Aligns with SMDG BAPLIE 3.x standard for stowage data exchange. SSOT for vessel stowage planning, load/discharge sequencing, and vessel call operational planning in NAVIS N4.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` (
    `berth_allocation_id` BIGINT COMMENT 'Unique identifier for the berth allocation record. Primary key for the berth allocation entity.',
    `berth_id` BIGINT COMMENT 'Reference to the physical berth location allocated for this vessel call. Links to port infrastructure master data.',
    `charge_event_id` BIGINT COMMENT 'Foreign key linking to billing.charge_event. Business justification: Berth allocations directly trigger port dues, wharfage, and berth hire charge events. Linking terminal_berth_allocation → charge_event provides direct traceability from the allocation record to the sp',
    `inspection_record_id` BIGINT COMMENT 'Foreign key linking to asset.inspection_record. Business justification: Berth allocation approval requires confirming the berth structure (fenders, bollards, quay deck) passed its most recent structural inspection. Port operations and ISPS compliance require this check be',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Berth operations must comply with current facility ISPS security level. Vessel-shore interface security procedures depend on facility security status. Operational requirement for Declaration of Securi',
    `participant_account_id` BIGINT COMMENT 'Reference to the commercial agreement or contract governing the terms of this berth allocation. Links to contract domain for tariff and SLA details.',
    `pilotage_assignment_id` BIGINT COMMENT 'Foreign key linking to marine.pilotage_assignment. Business justification: Berth Planning & Marine Services Coordination: port planners must link the berth allocation to the pilotage assignment to synchronise tidal windows, arrival timing, and resource scheduling. A port ope',
    `call_id` BIGINT COMMENT 'Reference to the vessel visit for which this berth is allocated. Links to the vessel operations domain.',
    `port_dues_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.port_dues_schedule. Business justification: Port dues are vessel-level charges calculated per berth call based on GRT/LOA bands. Berth allocation triggers port dues billing by referencing the applicable schedule for the vessels characteristics',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Berth operations are cost centers in port management accounting. Each berth allocation must be costed to a specific cost center for operational budgeting, variance analysis, and berth productivity rep',
    `terminal_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal. Business justification: A berth allocation is always made at a specific terminal. While terminal_berth_allocation has berth_id (linking to terminal.terminal) and port_location_id (linking to terminal.terminal), it ',
    `towage_order_id` BIGINT COMMENT 'Foreign key linking to marine.towage_order. Business justification: Berth Arrival Towage Coordination: terminal_berth_allocation carries towage_required_flag but has no FK to the actual towage_order. Port operations require this link for billing reconciliation, SLA tr',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Berth compatibility validation, crane allocation planning, mooring gang sizing, and operational resource forecasting require vessel type specifications before vessel arrival. Critical for berth planni',
    `voyage_id` BIGINT COMMENT 'Foreign key linking to vessel.voyage. Business justification: Berth allocations are planned against voyage rotations — port planners pre-allocate berths by voyage/service weeks in advance. Direct voyage_id enables berth utilization reports by service, SLA tracki',
    `wharfage_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.wharfage_schedule. Business justification: Wharfage charges apply to cargo handled at berth. Berth allocation determines which wharfage schedule applies based on cargo type, vessel type, and berth zone. Essential for cargo-based revenue calcul',
    `allocated_crane_count` STRING COMMENT 'Number of Ship-to-Shore (STS) cranes or Quay Cranes (QC) allocated for cargo operations during this berth allocation. Impacts vessel turnaround time and terminal productivity.',
    `allocated_quay_length_m` DECIMAL(18,2) COMMENT 'Length of quay allocated for this vessel in meters. Must accommodate vessel Length Overall (LOA) plus safety margins.',
    `allocation_notes` STRING COMMENT 'Free-text notes and comments related to this berth allocation. May include operational instructions, coordination details, or special circumstances.',
    `allocation_number` STRING COMMENT 'Business identifier for the berth allocation. Format: BA-YYYYMMDD-NNNN where YYYYMMDD is allocation date and NNNN is sequence number.. Valid values are `^BA-[0-9]{8}-[0-9]{4}$`',
    `allocation_reason` STRING COMMENT 'Business reason or justification for this specific berth allocation. May include service requirements, vessel preferences, operational constraints, or commercial agreements.',
    `allocation_status` STRING COMMENT 'Current lifecycle status of the berth allocation. Planned: initial allocation created; Confirmed: vessel and berth confirmed; Active: vessel currently berthed; Completed: vessel departed; Cancelled: allocation cancelled; Suspended: temporarily on hold.. Valid values are `planned|confirmed|active|completed|cancelled|suspended`',
    `atb` TIMESTAMP COMMENT 'Actual timestamp when the vessel berthed at the allocated berth. Captured from Vessel Traffic Management System (VTMS) or Terminal Operating System (TOS).',
    `atd` TIMESTAMP COMMENT 'Actual timestamp when the vessel departed from the allocated berth. Captured from Vessel Traffic Management System (VTMS) or Terminal Operating System (TOS).',
    `berth_draft_restriction_m` DECIMAL(18,2) COMMENT 'Maximum allowable draft at the allocated berth in meters. Vessel draft must not exceed this value for safe berthing operations.',
    `berth_productivity_target_mph` DECIMAL(18,2) COMMENT 'Target container handling productivity in moves per hour for this berth allocation. Used for performance monitoring and SLA compliance.',
    `berth_window_duration_hours` DECIMAL(18,2) COMMENT 'Planned duration of the berth window in hours. Calculated from berth window start and end times. Used for berth utilization KPIs.',
    `berth_window_end` TIMESTAMP COMMENT 'End of the allocated berth window. Defines the latest time the berth is reserved for this vessel before it must be released.',
    `berth_window_start` TIMESTAMP COMMENT 'Start of the allocated berth window. Defines the earliest time the berth is reserved for this vessel.',
    `cancellation_reason` STRING COMMENT 'Reason for cancellation if allocation status is cancelled. Includes vessel no-show, schedule changes, operational constraints, or customer request.',
    `cancelled_timestamp` TIMESTAMP COMMENT 'Timestamp when this berth allocation was cancelled. Null if allocation has not been cancelled.',
    `cargo_operation_type` STRING COMMENT 'Type of cargo operations planned for this berth allocation. LoLo: Lift-on Lift-off (container); RoRo: Roll-on Roll-off (vehicles); Mixed: combination; Bulk: bulk cargo; General: general cargo.. Valid values are `LoLo|RoRo|mixed|bulk|general`',
    `confirmed_timestamp` TIMESTAMP COMMENT 'Timestamp when this berth allocation was confirmed by the berth planner and vessel operator. Represents transition from planned to confirmed status.',
    `crane_allocation_type` STRING COMMENT 'Type of cranes allocated for this berth. STS: Ship-to-Shore crane; QC: Quay Crane; MHC: Mobile Harbour Crane; Mixed: combination of crane types.. Valid values are `STS|QC|MHC|mixed`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this berth allocation record was first created in the Terminal Operating System. Used for audit trail and data lineage.',
    `etb` TIMESTAMP COMMENT 'Planned timestamp when the vessel is estimated to berth at the allocated berth. Used for berth planning and resource scheduling.',
    `etd` TIMESTAMP COMMENT 'Planned timestamp when the vessel is estimated to depart from the allocated berth. Used for berth window planning and next vessel scheduling.',
    `expected_container_moves` STRING COMMENT 'Estimated total number of container moves (load + discharge) planned for this vessel call. Used for resource planning and productivity forecasting.',
    `expected_teu_volume` STRING COMMENT 'Expected total TEU volume to be handled during this berth allocation. Includes both loading and discharge operations.',
    `imdg_cargo_flag` BOOLEAN COMMENT 'Indicates whether this berth allocation involves dangerous goods cargo requiring IMDG compliance. True if dangerous goods are present; False otherwise.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this berth allocation record was last updated. Used for change tracking and audit purposes.',
    `mooring_gang_count` STRING COMMENT 'Number of mooring gangs allocated for securing the vessel to the berth. Typically ranges from 1 to 4 depending on vessel size and weather conditions.',
    `pilotage_required_flag` BOOLEAN COMMENT 'Indicates whether marine pilotage services are required for this berth allocation. True if pilotage is mandatory; False if vessel can berth without pilot.',
    `priority_level` STRING COMMENT 'Priority level assigned to this berth allocation. Critical: emergency or VIP vessel; High: priority service; Normal: standard service; Low: flexible scheduling.. Valid values are `critical|high|normal|low`',
    `sla_turnaround_time_hours` DECIMAL(18,2) COMMENT 'Contractual Service Level Agreement turnaround time commitment for this vessel in hours. Measured from ATB to ATD.',
    `special_handling_requirements` STRING COMMENT 'Any special handling requirements for this berth allocation such as IMDG (International Maritime Dangerous Goods) cargo, refrigerated containers, oversized cargo, or security protocols.',
    `tide_window_required_flag` BOOLEAN COMMENT 'Indicates whether this berth allocation is constrained by tidal conditions. True if vessel can only berth during specific tide windows; False if tide-independent.',
    `towage_required_flag` BOOLEAN COMMENT 'Indicates whether towage (tug) services are required for this berth allocation. True if tugs are needed for berthing/unberthing; False otherwise.',
    `vessel_draft_m` DECIMAL(18,2) COMMENT 'Maximum draft of the vessel in meters. Must be validated against berth depth restrictions to ensure safe berthing.',
    `vessel_loa_m` DECIMAL(18,2) COMMENT 'Length Overall of the vessel in meters. Used to validate berth allocation suitability and quay length requirements.',
    `weather_restriction_flag` BOOLEAN COMMENT 'Indicates whether this berth allocation has weather-related restrictions (wind speed, wave height, visibility). True if weather-sensitive; False otherwise.',
    CONSTRAINT pk_berth_allocation PRIMARY KEY(`berth_allocation_id`)
) COMMENT 'Transactional record of berth assignments for vessel calls at the terminal. Captures berth identifier, vessel visit reference, planned and actual berthing time (ETB/ATB), planned and actual departure time (ETD/ATD), berth window duration, allocated quay length, draft restrictions, crane allocation count, berth planner ID, and allocation status (planned, confirmed, active, completed). SSOT for berth planning in TOPS Expert and NAVIS N4.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` (
    `reefer_monitoring_id` BIGINT COMMENT 'Primary key for reefer_monitoring',
    `charge_event_id` BIGINT COMMENT 'Foreign key linking to billing.charge_event. Business justification: Reefer monitoring records generate per-plug, per-day monitoring fee charge events before invoicing. reefer_monitoring already links to invoice but not to the upstream charge_event. This link enables t',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Cold chain compliance validation, temperature range verification against commodity specifications, and cargo-specific monitoring protocols require HS code reference. Essential for perishable cargo qua',
    `container_id` BIGINT COMMENT 'Foreign key reference to the reefer container being monitored. Links to the container master data.',
    `container_visit_id` BIGINT COMMENT 'Foreign key linking to terminal.container_visit. Business justification: Reefer monitoring events track temperature and condition of refrigerated containers during their terminal visit. The reefer_monitoring table already has container_id pointing to cargo.container (cross',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Cold-chain breaches detected during reefer monitoring trigger phytosanitary or customs holds on perishable cargo. Linking reefer_monitoring to the resulting customs_hold enables traceability between t',
    `drayage_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.drayage_order. Business justification: Cold-chain handover compliance: reefer monitoring must reference the drayage_order to trigger temperature deviation alerts before truck pickup, satisfy cold-chain regulatory requirements, and provide ',
    `import_export_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.import_export_permit. Business justification: Import/export permits for pharmaceuticals, fresh produce, and controlled perishables specify mandatory temperature ranges. Reefer monitoring compliance must be verified against permit conditions; this',
    `port_location_id` BIGINT COMMENT 'Foreign key reference to the technician who performed manual inspection or intervention on this reefer container.',
    `work_order_id` BIGINT COMMENT 'Foreign key linking to asset.work_order. Business justification: Reefer alarm events trigger corrective work orders for technician dispatch. The existing technician_inspection_reference plain-text field is a denormalization of work_order. A proper FK enables cold-c',
    `yard_slot_id` BIGINT COMMENT 'Foreign key linking to terminal.yard_slot. Business justification: reefer_monitoring has yard_slot_position (STRING) which should be normalized to FK for authoritative slot reference. Monitoring events are tied to physical locations where reefer plugs are available. ',
    `actual_temperature` DECIMAL(18,2) COMMENT 'The measured actual temperature inside the reefer container at the time of monitoring in degrees Celsius. Critical for cold chain integrity verification.',
    `alarm_flag` BOOLEAN COMMENT 'Boolean indicator whether an alarm condition was triggered during this monitoring event. True indicates an alarm was raised, False indicates normal operation.',
    `alarm_severity` STRING COMMENT 'The severity level of the alarm condition. Critical requires immediate action, high requires urgent attention, medium requires scheduled intervention, low is informational.. Valid values are `critical|high|medium|low`',
    `alarm_type` STRING COMMENT 'The category of alarm condition detected. Temperature deviation indicates actual temperature outside acceptable range, power failure indicates loss of electrical supply, door open indicates container door unsealed, humidity deviation indicates moisture level out of range, CO2 deviation indicates gas concentration issue, equipment malfunction indicates refrigeration unit failure.. Valid values are `temperature_deviation|power_failure|door_open|humidity_deviation|co2_deviation|equipment_malfunction`',
    `cargo_type` STRING COMMENT 'The classification of perishable cargo being transported in the reefer container. Examples include frozen meat, fresh produce, pharmaceuticals, dairy products, flowers.',
    `co2_level` DECIMAL(18,2) COMMENT 'The carbon dioxide concentration measured inside the reefer container in percentage. Critical for controlled atmosphere cargo such as fruits and vegetables.',
    `cold_chain_compliance_flag` BOOLEAN COMMENT 'Boolean indicator whether this monitoring event confirms cold chain integrity compliance. True indicates temperature and conditions within acceptable range, False indicates breach of cold chain requirements.',
    `compressor_runtime_hours` DECIMAL(18,2) COMMENT 'The cumulative operating hours of the refrigeration compressor since last reset. Used for maintenance scheduling and equipment lifecycle management.',
    `compressor_status` STRING COMMENT 'The operational status of the refrigeration compressor unit. Running indicates active cooling, stopped indicates unit off, standby indicates ready but not cooling, fault indicates malfunction.. Valid values are `running|stopped|standby|fault`',
    `corrective_action_description` STRING COMMENT 'Free text description of the corrective action taken or required in response to this monitoring event. Populated when intervention was necessary.',
    `corrective_action_required` BOOLEAN COMMENT 'Boolean indicator whether this monitoring event requires corrective action or intervention. True indicates follow-up action needed.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this monitoring record was first created in the system. Audit trail for data lineage.',
    `defrost_cycle_status` STRING COMMENT 'The status of the automatic defrost cycle for the refrigeration unit. Active indicates defrost in progress, inactive indicates normal cooling mode, scheduled indicates defrost pending.. Valid values are `active|inactive|scheduled`',
    `door_status` STRING COMMENT 'The physical status of the reefer container door. Closed indicates door shut but not sealed, open indicates door ajar or open, sealed indicates door closed with customs or security seal intact.. Valid values are `closed|open|sealed`',
    `humidity_reading` DECIMAL(18,2) COMMENT 'The relative humidity percentage measured inside the reefer container. Important for cargo types sensitive to moisture levels such as fresh produce.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this monitoring record was last modified in the system. Audit trail for data lineage and change tracking.',
    `monitoring_source` STRING COMMENT 'The method or system that captured this monitoring reading. Automated sensor indicates TOS integration, manual inspection indicates technician reading, remote telemetry indicates IoT device, RFID reader indicates tag-based monitoring.. Valid values are `automated_sensor|manual_inspection|remote_telemetry|rfid_reader`',
    `monitoring_status` STRING COMMENT 'The current lifecycle status of this monitoring event. Active indicates ongoing monitoring, resolved indicates issue closed, escalated indicates elevated to management, pending review indicates awaiting technician assessment.. Valid values are `active|resolved|escalated|pending_review`',
    `monitoring_timestamp` TIMESTAMP COMMENT 'The date and time when the reefer container monitoring reading was captured. Principal business event timestamp for this monitoring transaction.',
    `notification_sent_flag` BOOLEAN COMMENT 'Boolean indicator whether an alert notification was sent to stakeholders for this monitoring event. True indicates notification dispatched to customer or operations team.',
    `notification_timestamp` TIMESTAMP COMMENT 'The date and time when alert notification was sent to stakeholders regarding this monitoring event. Null if no notification was sent.',
    `o2_level` DECIMAL(18,2) COMMENT 'The oxygen concentration measured inside the reefer container in percentage. Used for controlled atmosphere monitoring to preserve perishable cargo.',
    `power_status` STRING COMMENT 'The electrical power connection status of the reefer container. Connected indicates active power supply, disconnected indicates no power, standby indicates backup power mode.. Valid values are `connected|disconnected|standby`',
    `power_supply_voltage` DECIMAL(18,2) COMMENT 'The electrical voltage being supplied to the reefer container in volts. Standard voltages are 220V, 380V, or 440V depending on terminal infrastructure.',
    `remarks` STRING COMMENT 'Free text field for additional notes, observations, or comments related to this reefer monitoring event. Used by technicians and operations staff for context.',
    `sensor_device_code` STRING COMMENT 'The unique identifier of the monitoring sensor or telemetry device that captured this reading. Used for device calibration tracking and data quality assurance.',
    `set_temperature` DECIMAL(18,2) COMMENT 'The target temperature setting configured for the reefer container in degrees Celsius. This is the temperature the refrigeration unit is programmed to maintain.',
    `sla_breach_flag` BOOLEAN COMMENT 'Boolean indicator whether this monitoring event represents a breach of customer service level agreement for reefer monitoring. True indicates SLA breach occurred.',
    `temperature_deviation` DECIMAL(18,2) COMMENT 'The calculated difference between set temperature and actual temperature in degrees. Positive values indicate warmer than set point, negative values indicate cooler than set point.',
    `temperature_unit` STRING COMMENT 'The unit of measure for temperature readings. Standard is Celsius but Fahrenheit may be used in some jurisdictions.. Valid values are `celsius|fahrenheit`',
    `ventilation_rate` DECIMAL(18,2) COMMENT 'The air exchange rate in cubic meters per hour when ventilation is active. Applicable for cargo requiring fresh air circulation.',
    `ventilation_setting` STRING COMMENT 'The ventilation mode configured for the reefer container. Closed for frozen cargo, open for fresh air exchange, controlled for modified atmosphere.. Valid values are `closed|open|controlled`',
    CONSTRAINT pk_reefer_monitoring PRIMARY KEY(`reefer_monitoring_id`)
) COMMENT 'Transactional record of reefer container temperature and condition monitoring events within the terminal yard. Captures container number, yard slot position, set temperature, actual temperature reading, humidity reading, CO2 level, ventilation setting, monitoring timestamp, alarm flag, alarm type (temperature deviation, power failure, door open), and technician inspection reference. Ensures cold chain integrity for perishable cargo.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` (
    `equipment_id` BIGINT COMMENT 'Unique identifier for the terminal handling equipment unit. Primary key for the terminal equipment master data.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: STS cranes and other quayside equipment are physically installed at specific berths. Berth crane-count validation, maintenance scheduling, and berth productivity (moves-per-hour) reporting all require',
    `maintenance_plan_id` BIGINT COMMENT 'Foreign key linking to asset.maintenance_plan. Business justification: Equipment dispatch planning requires TOS to check active maintenance windows before assigning RTGs, STS cranes, or reach stackers to work. Linking terminal_equipment directly to its maintenance_plan e',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Terminal equipment are port assets tracked in both operational (terminal_equipment) and financial (port_asset) systems. Required for depreciation reporting, capital expenditure tracking, asset valuati',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Terminal equipment assets are assigned to cost centers for depreciation allocation, maintenance cost tracking, and operational cost reporting. Each equipment unit has a home cost center for financial ',
    `terminal_id` BIGINT COMMENT 'Foreign key linking to terminal.terminal. Business justification: Terminal equipment (RTGs, STS cranes, ASCs, MHCs, reach stackers) are owned and operated by a specific terminal. The existing home_terminal STRING column is a denormalized text representation of the t',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Equipment is assigned to specific terminal zones for operational dispatch, maintenance planning, and resource allocation. The existing home_terminal text field is insufficient; equipment dispatch sy',
    `acquisition_date` DATE COMMENT 'Date on which the equipment was acquired by the port authority, either through purchase, lease commencement, or transfer. Used for asset accounting, depreciation start date, and fleet age analysis.',
    `automation_level` STRING COMMENT 'Degree of automation for equipment operation. Manual requires on-board operator, semi_automated provides operator assistance systems, fully_automated operates without human intervention (e.g., ASC, AGV), remote_controlled operated from remote control station. Critical for operational planning, safety protocols, and workforce requirements.. Valid values are `manual|semi_automated|fully_automated|remote_controlled`',
    `certification_expiry_date` DATE COMMENT 'Expiry date of the equipments current safety certification or inspection certificate. Equipment must not operate beyond this date without recertification per port safety regulations and SOLAS requirements.',
    `commissioning_date` DATE COMMENT 'Date on which the equipment was commissioned and entered active operational service at the terminal. May differ from acquisition date due to installation, testing, and certification periods.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this equipment master record was first created in the system. Used for data lineage, audit trail, and record lifecycle tracking.',
    `current_yard_zone` STRING COMMENT 'Current yard zone or operational area where the equipment is assigned or located. Used for dispatch optimization, equipment utilization tracking, and operational planning. Typically references yard block identifiers from terminal layout.',
    `depreciation_method` STRING COMMENT 'Accounting method used for calculating depreciation of the equipment asset. Used for financial reporting, tax compliance, and asset valuation per accounting standards.. Valid values are `straight_line|declining_balance|units_of_production|sum_of_years_digits`',
    `emission_standard` STRING COMMENT 'Environmental emission standard that the equipment complies with (e.g., EPA Tier 4, Euro Stage V). Used for environmental reporting, regulatory compliance, and green port initiatives. Critical for GHG emissions tracking and air quality management.',
    `equipment_number` STRING COMMENT 'Externally-known unique business identifier for the terminal handling equipment unit. Used for operational dispatch, maintenance tracking, and cross-system reference. Typically alphanumeric code assigned by terminal operations or manufacturer.. Valid values are `^[A-Z0-9]{6,20}$`',
    `fuel_power_type` STRING COMMENT 'Primary energy source or propulsion type for the equipment. Critical for environmental reporting (GHG emissions), operational cost tracking, refueling/recharging infrastructure planning, and compliance with port environmental regulations.. Valid values are `diesel|electric|hybrid_diesel_electric|LNG|battery_electric|hydrogen`',
    `gps_tracking_enabled` BOOLEAN COMMENT 'Indicates whether the equipment is equipped with active GPS tracking capability for real-time location monitoring. Used for fleet management, utilization analysis, and operational optimization.',
    `imdg_certified` BOOLEAN COMMENT 'Indicates whether the equipment is certified and equipped for handling dangerous goods containers per IMDG Code requirements. Includes specialized safety features, operator training requirements, and compliance documentation.',
    `insurance_policy_reference` STRING COMMENT 'Reference number for the insurance policy covering this equipment. Used for risk management, claims processing, and asset protection. Links to Protection and Indemnity (P&I) or equipment insurance policies.',
    `last_major_overhaul_date` DATE COMMENT 'Date of the most recent major overhaul or refurbishment of the equipment. Used for maintenance planning, remaining useful life estimation, and capital expenditure tracking.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this equipment master record was last modified. Used for data currency verification, change tracking, and audit trail maintenance.',
    `maximo_asset_reference` STRING COMMENT 'Cross-reference identifier linking this terminal equipment record to the corresponding asset record in Maximo Asset Management system. Enables integration between operational equipment master (TOS) and full asset lifecycle management (EAM) for maintenance, work orders, and asset financial tracking.',
    `maximum_lift_height_metres` DECIMAL(18,2) COMMENT 'Maximum vertical lift height of the equipment in metres. Applicable to cranes and lifting equipment, indicates the maximum container stack height or vessel reach capability. Critical for operational planning and safety.',
    `maximum_reach_metres` DECIMAL(18,2) COMMENT 'Maximum horizontal reach or span of the equipment in metres. Applicable to cranes (STS, QC, MHC, RTG, ASC) and indicates the operational envelope for cargo handling. Used for berth planning and yard layout optimization.',
    `next_scheduled_maintenance_date` DATE COMMENT 'Date of the next planned preventive maintenance activity for the equipment. Used for maintenance scheduling, resource planning, and operational availability forecasting.',
    `noise_level_db` DECIMAL(18,2) COMMENT 'Measured operational noise level of the equipment in decibels. Used for occupational health and safety compliance, environmental impact assessment, and noise pollution management per port environmental regulations.',
    `operating_hours_since_last_service` DECIMAL(18,2) COMMENT 'Operating hours accumulated since the last scheduled maintenance service. Used to trigger interval-based preventive maintenance activities.',
    `operating_hours_total` DECIMAL(18,2) COMMENT 'Cumulative total operating hours recorded for the equipment since commissioning. Used for usage-based maintenance scheduling, depreciation calculations, and equipment lifecycle analysis.',
    `operational_status` STRING COMMENT 'Current operational lifecycle state of the terminal handling equipment. Active indicates available for dispatch, under_maintenance indicates scheduled or unscheduled maintenance in progress, standby indicates operational but not currently assigned, decommissioned indicates permanently retired from service, out_of_service indicates temporarily unavailable, awaiting_repair indicates breakdown pending repair.. Valid values are `active|under_maintenance|standby|decommissioned|out_of_service|awaiting_repair`',
    `operator_certification_required` STRING COMMENT 'Type or level of operator certification required to operate this equipment. References specific training programs, licensing requirements, or competency standards per port safety regulations and Maritime Labour Convention.',
    `ownership_type` STRING COMMENT 'Legal ownership or control arrangement for the equipment. Owned indicates port authority owns the asset, leased indicates long-term lease arrangement, rented indicates short-term rental, contractor_provided indicates equipment supplied by third-party service contractor.. Valid values are `owned|leased|rented|contractor_provided`',
    `reefer_monitoring_capable` BOOLEAN COMMENT 'Indicates whether the equipment is equipped with systems to monitor refrigerated container (reefer) parameters during handling or storage. Applicable to yard equipment and critical for cold chain integrity.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, special conditions, operational constraints, or historical information about the equipment. Used for operational knowledge capture and equipment-specific context.',
    `replacement_value` DECIMAL(18,2) COMMENT 'Current estimated replacement cost for the equipment in base currency. Used for insurance valuation, capital planning, and asset management decisions. Updated periodically to reflect market conditions.',
    `rfid_tag_code` STRING COMMENT 'Unique identifier of the RFID tag attached to the equipment for automated tracking and identification within the terminal. Used for real-time location tracking, automated gate operations, and equipment utilization monitoring.',
    `serial_number` STRING COMMENT 'Manufacturer-assigned unique serial number for the equipment unit. Used for warranty claims, recall tracking, and asset provenance verification.',
    `spreader_type` STRING COMMENT 'Type of spreader attachment fitted to the equipment for container handling. Applicable to cranes and reach stackers. Fixed spreaders handle single container size, telescopic spreaders adjust between 20ft and 40ft containers, tandem spreaders handle two containers simultaneously. Critical for operational flexibility and productivity.. Valid values are `fixed_20ft|fixed_40ft|telescopic_20_40ft|tandem|auto_twist_lock|manual`',
    `swl_tonnes` DECIMAL(18,2) COMMENT 'Maximum safe working load capacity of the equipment expressed in metric tonnes. Critical safety parameter for operational dispatch and cargo handling planning. Must not be exceeded during operations per SOLAS and port safety regulations.',
    `tandem_lift_capable` BOOLEAN COMMENT 'Indicates whether the equipment is capable of lifting two Forty-foot Equivalent Unit (FEU) containers simultaneously. Applicable to high-capacity cranes and represents advanced productivity capability.',
    `telematics_system_code` STRING COMMENT 'Identifier for the telematics system or IoT device installed on the equipment for remote monitoring of performance, diagnostics, and operational parameters. Used for predictive maintenance and real-time equipment health monitoring.',
    `twin_lift_capable` BOOLEAN COMMENT 'Indicates whether the equipment is capable of lifting two Twenty-foot Equivalent Unit (TEU) containers simultaneously. Applicable to cranes and significantly impacts productivity for vessel and yard operations.',
    `year_of_manufacture` STRING COMMENT 'Calendar year in which the equipment was manufactured. Used for age-based maintenance planning, depreciation calculations, and lifecycle management decisions.',
    CONSTRAINT pk_equipment PRIMARY KEY(`equipment_id`)
) COMMENT 'Master data for all terminal handling equipment (THE) units operated within the terminal. Captures equipment number, equipment type (RTG, STS/QC, ASC, MHC, AGV, reach stacker, empty handler, forklift, terminal tractor), make, model, year of manufacture, SWL (Safe Working Load), operational status (active, under maintenance, standby, decommissioned), current yard zone assignment, fuel/power type, and Maximo asset reference. SSOT for terminal equipment identity within the terminal domain (operational profile; full asset lifecycle owned by asset domain).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` (
    `terminal_id` BIGINT COMMENT 'Primary key for terminal',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the organization entity that operates this terminal.',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: Every terminal operates within a port. Port authority reporting, port-level throughput aggregation, regulatory submissions, and port master-data governance all require the terminal → port relationship',
    `port_location_id` BIGINT COMMENT 'Reference to the parent port or seaport where this terminal is located.',
    `port_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.port_tariff. Business justification: Each terminal operates under a published master port tariff governing all charges (storage, handling, wharfage, dues). Regulatory filings, customer quotations, and billing systems require linking term',
    `address_line1` STRING COMMENT 'Primary street address line of the terminal facility.',
    `address_line2` STRING COMMENT 'Secondary address line for additional location details (building, suite, zone).',
    `annual_throughput_capacity_teu` STRING COMMENT 'Maximum annual container handling capacity measured in TEU. Represents the designed throughput volume the terminal can process per year.',
    `cfs_area_sqm` DECIMAL(18,2) COMMENT 'Total area of the Container Freight Station facility measured in square meters.',
    `cfs_facility_available` BOOLEAN COMMENT 'Indicates whether the terminal has a Container Freight Station (CFS) for Less than Container Load (LCL) cargo consolidation and deconsolidation.',
    `city` STRING COMMENT 'City where the terminal is located.',
    `contact_email` STRING COMMENT 'Primary email address for terminal operations and business communications.',
    `contact_phone` STRING COMMENT 'Primary contact phone number for terminal operations and inquiries.',
    `country_code` STRING COMMENT 'Three-letter ISO country code where the terminal is located.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this terminal record was first created in the system.',
    `customs_bonded_area` BOOLEAN COMMENT 'Indicates whether the terminal operates a customs bonded area for duty-deferred cargo storage.',
    `dangerous_goods_certified` BOOLEAN COMMENT 'Indicates whether the terminal is certified to handle dangerous goods (hazardous materials) per IMDG Code requirements.',
    `gate_lanes_inbound` STRING COMMENT 'Number of dedicated inbound gate lanes for truck entry and container delivery to the terminal.',
    `gate_lanes_outbound` STRING COMMENT 'Number of dedicated outbound gate lanes for truck exit and container pickup from the terminal.',
    `iso_28000_certified` BOOLEAN COMMENT 'Indicates whether the terminal holds ISO 28000 certification for supply chain security management.',
    `isps_compliant` BOOLEAN COMMENT 'Indicates whether the terminal is compliant with the International Ship and Port Facility Security (ISPS) Code for maritime security.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the terminal location in decimal degrees.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the terminal location in decimal degrees.',
    `max_vessel_draft_m` DECIMAL(18,2) COMMENT 'Maximum vessel draft (depth below waterline) that the terminal berths can accommodate, measured in meters. Determines the size of vessels that can safely berth.',
    `max_vessel_loa_m` DECIMAL(18,2) COMMENT 'Maximum vessel Length Overall (LOA) that the terminal can accommodate, measured in meters. Critical for determining compatible vessel classes.',
    `number_of_asc_cranes` STRING COMMENT 'Total count of Automated Stacking Cranes (ASC) deployed for automated container yard operations.',
    `number_of_berths` STRING COMMENT 'Total count of vessel berths available at the terminal for simultaneous vessel operations.',
    `number_of_mhc_units` STRING COMMENT 'Total count of Mobile Harbour Cranes (MHC) available for multipurpose cargo handling operations.',
    `number_of_reach_stackers` STRING COMMENT 'Total count of reach stacker vehicles used for container handling and stacking in the yard.',
    `number_of_rtg_cranes` STRING COMMENT 'Total count of Rubber-Tyred Gantry (RTG) cranes used for container stacking and yard operations.',
    `number_of_sts_cranes` STRING COMMENT 'Total count of Ship-to-Shore (STS) gantry cranes available for loading and unloading containers from vessels. Also known as Quay Cranes (QC).',
    `operational_start_date` DATE COMMENT 'Date when the terminal commenced commercial operations.',
    `operational_status` STRING COMMENT 'Current operational state of the terminal facility in its lifecycle.',
    `operator_name` STRING COMMENT 'Name of the company or entity operating the terminal facility.',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the terminal location.',
    `reefer_plugs_available` STRING COMMENT 'Total number of electrical connection points (plugs) available for refrigerated (reefer) containers requiring temperature control.',
    `rfid_enabled` BOOLEAN COMMENT 'Indicates whether the terminal has deployed RFID technology for automated container tracking and gate operations.',
    `state_province` STRING COMMENT 'State or province where the terminal is located.',
    `storage_capacity_teu` STRING COMMENT 'Maximum container storage capacity measured in Twenty-foot Equivalent Units (TEU). Represents the total number of standard 20-foot containers the terminal can hold.',
    `terminal_type` STRING COMMENT 'Classification of terminal based on primary cargo handling operations. Container terminals handle TEU/FEU, RoRo handles roll-on/roll-off vehicles, bulk handles commodities.',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the terminal location (e.g., America/New_York, Europe/Rotterdam).',
    `tos_system` STRING COMMENT 'Primary Terminal Operating System deployed for yard management, gate operations, and equipment dispatch. NAVIS N4 and TOPS Expert are industry-leading platforms.',
    `total_area_sqm` DECIMAL(18,2) COMMENT 'Total land area of the terminal facility measured in square meters, including container yards, warehouses, and operational zones.',
    `total_quay_length_m` DECIMAL(18,2) COMMENT 'Total length of quay wall available for vessel berthing, measured in meters.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this terminal record was last modified in the system.',
    CONSTRAINT pk_terminal PRIMARY KEY(`terminal_id`)
) COMMENT 'Master reference table for terminal. Referenced by terminal_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ADD CONSTRAINT `fk_terminal_yard_block_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ADD CONSTRAINT `fk_terminal_yard_slot_yard_block_id` FOREIGN KEY (`yard_block_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`yard_block`(`yard_block_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_yard_slot_id` FOREIGN KEY (`yard_slot_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`yard_slot`(`yard_slot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_gate_appointment_id` FOREIGN KEY (`gate_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`gate_appointment`(`gate_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`equipment`(`equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_berth_allocation_id` FOREIGN KEY (`berth_allocation_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`berth_allocation`(`berth_allocation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ADD CONSTRAINT `fk_terminal_berth_allocation_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_yard_slot_id` FOREIGN KEY (`yard_slot_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`yard_slot`(`yard_slot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ADD CONSTRAINT `fk_terminal_equipment_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`terminal` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`terminal` SET TAGS ('dbx_domain' = 'terminal');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` SET TAGS ('dbx_subdomain' = 'yard_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `yard_block_id` SET TAGS ('dbx_business_glossary_term' = 'Yard Block Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `storage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Yard Zone Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `area_square_meters` SET TAGS ('dbx_business_glossary_term' = 'Block Area in Square Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `bay_count` SET TAGS ('dbx_business_glossary_term' = 'Bay Count');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `block_code` SET TAGS ('dbx_business_glossary_term' = 'Yard Block Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `block_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `block_name` SET TAGS ('dbx_business_glossary_term' = 'Yard Block Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `block_type` SET TAGS ('dbx_business_glossary_term' = 'Yard Block Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `block_type` SET TAGS ('dbx_value_regex' = 'import|export|transshipment|reefer|dangerous_goods|empty');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `cctv_coverage` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Coverage Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `decommissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Decommissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `drainage_system` SET TAGS ('dbx_business_glossary_term' = 'Drainage System Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `drainage_system` SET TAGS ('dbx_value_regex' = 'surface|subsurface|combined|none');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `environmental_monitoring` SET TAGS ('dbx_business_glossary_term' = 'Environmental Monitoring Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `equipment_type` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `equipment_type` SET TAGS ('dbx_value_regex' = 'rtg|asc|reach_stacker|mobile_crane|straddle_carrier|agv');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `fire_suppression_system` SET TAGS ('dbx_business_glossary_term' = 'Fire Suppression System Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `fire_suppression_system` SET TAGS ('dbx_value_regex' = 'sprinkler|foam|dry_chemical|none');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `ground_slot_capacity` SET TAGS ('dbx_business_glossary_term' = 'Ground Slot Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `imdg_certified` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Certified Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude Coordinate');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `length_meters` SET TAGS ('dbx_business_glossary_term' = 'Block Length in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `lighting_available` SET TAGS ('dbx_business_glossary_term' = 'Lighting Available Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude Coordinate');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `max_stack_height` SET TAGS ('dbx_business_glossary_term' = 'Maximum Stack Height');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `next_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Operational Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'active|inactive|maintenance|planned|decommissioned');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `reefer_capable` SET TAGS ('dbx_business_glossary_term' = 'Reefer Capable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `reefer_plug_count` SET TAGS ('dbx_business_glossary_term' = 'Reefer Plug Count');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `rfid_enabled` SET TAGS ('dbx_business_glossary_term' = 'Radio Frequency Identification (RFID) Enabled Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `row_count` SET TAGS ('dbx_business_glossary_term' = 'Row Count');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `security_zone` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `security_zone` SET TAGS ('dbx_value_regex' = 'public|restricted|secure|high_security');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `segregation_zone` SET TAGS ('dbx_business_glossary_term' = 'Segregation Zone Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `surface_type` SET TAGS ('dbx_business_glossary_term' = 'Surface Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `surface_type` SET TAGS ('dbx_value_regex' = 'asphalt|concrete|gravel|reinforced_concrete|paved');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `tier_count` SET TAGS ('dbx_business_glossary_term' = 'Tier Count');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By User');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `weight_scale_available` SET TAGS ('dbx_business_glossary_term' = 'Weight Scale Available Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `width_meters` SET TAGS ('dbx_business_glossary_term' = 'Block Width in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` SET TAGS ('dbx_subdomain' = 'yard_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `yard_slot_id` SET TAGS ('dbx_business_glossary_term' = 'Yard Slot Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `icd_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Icd Facility Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `yard_block_id` SET TAGS ('dbx_business_glossary_term' = 'Yard Block Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `accessibility_rating` SET TAGS ('dbx_business_glossary_term' = 'Accessibility Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `accessibility_rating` SET TAGS ('dbx_value_regex' = 'high|medium|low|restricted');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `active_flag` SET TAGS ('dbx_business_glossary_term' = 'Active Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `bay_number` SET TAGS ('dbx_business_glossary_term' = 'Bay Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `customs_inspection_zone` SET TAGS ('dbx_business_glossary_term' = 'Customs Inspection Zone Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `decommissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Decommissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `distance_to_gate_meters` SET TAGS ('dbx_business_glossary_term' = 'Distance to Gate in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `distance_to_quay_meters` SET TAGS ('dbx_business_glossary_term' = 'Distance to Quay in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `drainage_status` SET TAGS ('dbx_business_glossary_term' = 'Drainage Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `drainage_status` SET TAGS ('dbx_value_regex' = 'good|fair|poor|blocked|none');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `equipment_access_type` SET TAGS ('dbx_business_glossary_term' = 'Equipment Access Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `hazmat_approved` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Approved Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `hazmat_class_restrictions` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Class Restrictions');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `height_clearance_meters` SET TAGS ('dbx_business_glossary_term' = 'Height Clearance in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `last_occupied_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Occupied Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `last_vacated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Vacated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `length_meters` SET TAGS ('dbx_business_glossary_term' = 'Slot Length in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `lighting_available` SET TAGS ('dbx_business_glossary_term' = 'Lighting Available Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `maintenance_notes` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `max_weight_capacity_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Weight Capacity in Kilograms (KG)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `occupied_flag` SET TAGS ('dbx_business_glossary_term' = 'Occupied Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `oog_approved` SET TAGS ('dbx_business_glossary_term' = 'Out of Gauge (OOG) Approved Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `operational_zone` SET TAGS ('dbx_business_glossary_term' = 'Operational Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `operational_zone` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `reefer_plug_available` SET TAGS ('dbx_business_glossary_term' = 'Reefer Plug Available Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `reefer_plug_type` SET TAGS ('dbx_business_glossary_term' = 'Reefer Plug Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `reefer_plug_type` SET TAGS ('dbx_value_regex' = 'none|single_phase|three_phase|dual');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `reefer_voltage` SET TAGS ('dbx_business_glossary_term' = 'Reefer Voltage');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `reservation_expiry_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Reservation Expiry Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `reservation_status` SET TAGS ('dbx_business_glossary_term' = 'Reservation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `reservation_status` SET TAGS ('dbx_value_regex' = 'none|reserved|pre_allocated|confirmed');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `rfid_tag_code` SET TAGS ('dbx_business_glossary_term' = 'Radio Frequency Identification (RFID) Tag Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `rfid_tag_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,24}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `row_number` SET TAGS ('dbx_business_glossary_term' = 'Row Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `slot_code` SET TAGS ('dbx_business_glossary_term' = 'Slot Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `slot_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `slot_status` SET TAGS ('dbx_business_glossary_term' = 'Slot Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `slot_status` SET TAGS ('dbx_value_regex' = 'available|occupied|reserved|blocked|maintenance|damaged');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `slot_type` SET TAGS ('dbx_business_glossary_term' = 'Slot Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `surface_type` SET TAGS ('dbx_business_glossary_term' = 'Surface Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `surface_type` SET TAGS ('dbx_value_regex' = 'asphalt|concrete|gravel|paved|unpaved');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `swl_rating_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Safe Working Load (SWL) Rating in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `teu_capacity` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `tier_number` SET TAGS ('dbx_business_glossary_term' = 'Tier Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `width_meters` SET TAGS ('dbx_business_glossary_term' = 'Slot Width in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` SET TAGS ('dbx_subdomain' = 'yard_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Visit Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `import_export_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Import Export Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `un_locode_id` SET TAGS ('dbx_business_glossary_term' = 'Pol Un Locode Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `storage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Demurrage Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Ohs Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `yard_slot_id` SET TAGS ('dbx_business_glossary_term' = 'Yard Slot Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `arrival_mode` SET TAGS ('dbx_business_glossary_term' = 'Arrival Mode');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `arrival_mode` SET TAGS ('dbx_value_regex' = 'vessel|truck|rail|barge|internal');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `booking_number` SET TAGS ('dbx_business_glossary_term' = 'Booking Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `cargo_type` SET TAGS ('dbx_value_regex' = 'general|reefer|hazmat|oog|empty|special');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `consignee_name` SET TAGS ('dbx_business_glossary_term' = 'Consignee Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `container_number` SET TAGS ('dbx_business_glossary_term' = 'Container Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `container_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `damage_description` SET TAGS ('dbx_business_glossary_term' = 'Damage Description');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `damage_flag` SET TAGS ('dbx_business_glossary_term' = 'Damage Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `demurrage_start_date` SET TAGS ('dbx_business_glossary_term' = 'Demurrage (DMG) Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `departure_mode` SET TAGS ('dbx_business_glossary_term' = 'Departure Mode');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `departure_mode` SET TAGS ('dbx_value_regex' = 'vessel|truck|rail|barge|internal');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `dwell_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Dwell Time in Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `final_destination_code` SET TAGS ('dbx_business_glossary_term' = 'Final Destination Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `final_destination_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `free_time_days` SET TAGS ('dbx_business_glossary_term' = 'Free Time in Days');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `full_empty_indicator` SET TAGS ('dbx_business_glossary_term' = 'Full or Empty Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `full_empty_indicator` SET TAGS ('dbx_value_regex' = 'full|empty');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `gate_in_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Gate-In Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `gate_out_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Gate-Out Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `oog_dimensions` SET TAGS ('dbx_business_glossary_term' = 'Out of Gauge (OOG) Dimensions');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `oog_flag` SET TAGS ('dbx_business_glossary_term' = 'Out of Gauge (OOG) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `pod_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `pod_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `reefer_flag` SET TAGS ('dbx_business_glossary_term' = 'Reefer Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `reefer_humidity_setpoint_pct` SET TAGS ('dbx_business_glossary_term' = 'Reefer Humidity Setpoint Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `reefer_temperature_setpoint_c` SET TAGS ('dbx_business_glossary_term' = 'Reefer Temperature Setpoint in Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `reefer_ventilation_setting` SET TAGS ('dbx_business_glossary_term' = 'Reefer Ventilation Setting');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `rfid_tag_code` SET TAGS ('dbx_business_glossary_term' = 'Radio Frequency Identification (RFID) Tag Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `seal_number_1` SET TAGS ('dbx_business_glossary_term' = 'Primary Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `seal_number_2` SET TAGS ('dbx_business_glossary_term' = 'Secondary Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `shipper_name` SET TAGS ('dbx_business_glossary_term' = 'Shipper Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `tare_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Tare Weight in Kilograms');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `teu_factor` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Factor');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `tos_reference_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Operating System (TOS) Reference Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `vessel_discharge_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Vessel Discharge Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `vessel_load_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Vessel Load Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `vgm_method` SET TAGS ('dbx_business_glossary_term' = 'Verified Gross Mass (VGM) Method');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `vgm_method` SET TAGS ('dbx_value_regex' = 'method_1|method_2');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `vgm_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Verified Gross Mass (VGM) Weight in Kilograms');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `visit_status` SET TAGS ('dbx_business_glossary_term' = 'Container Visit Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `visit_status` SET TAGS ('dbx_value_regex' = 'inbound|in_yard|outbound|departed|on_hold|customs_hold');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` SET TAGS ('dbx_subdomain' = 'gate_management');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `gate_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Transaction Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `import_export_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Import Export Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Company ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Clerk ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `gate_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Gate Appointment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Lane ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `truck_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Appointment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Ohs Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `anpr_capture_reference` SET TAGS ('dbx_business_glossary_term' = 'Automatic Number Plate Recognition (ANPR) Capture Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `booking_reference` SET TAGS ('dbx_business_glossary_term' = 'Booking Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `coparn_reference` SET TAGS ('dbx_business_glossary_term' = 'COPARN (Container Pre-Announcement) Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `damage_description` SET TAGS ('dbx_business_glossary_term' = 'Damage Description');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `damage_flag` SET TAGS ('dbx_business_glossary_term' = 'Damage Detected Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `driver_license_number` SET TAGS ('dbx_business_glossary_term' = 'Driver License Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `driver_license_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `driver_license_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `driver_name` SET TAGS ('dbx_business_glossary_term' = 'Driver Full Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `driver_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `driver_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `driver_phone_number` SET TAGS ('dbx_business_glossary_term' = 'Driver Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `driver_phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `driver_phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `gate_clerk_override_flag` SET TAGS ('dbx_business_glossary_term' = 'Gate Clerk Override Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `ocr_capture_reference` SET TAGS ('dbx_business_glossary_term' = 'Optical Character Recognition (OCR) Capture Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `override_reason` SET TAGS ('dbx_business_glossary_term' = 'Override Reason Description');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `processing_duration_seconds` SET TAGS ('dbx_business_glossary_term' = 'Gate Processing Duration (Seconds)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `reefer_temperature_actual_c` SET TAGS ('dbx_business_glossary_term' = 'Reefer Temperature Actual Reading (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `reefer_temperature_setpoint_c` SET TAGS ('dbx_business_glossary_term' = 'Reefer Temperature Setpoint (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `rfid_tag_number` SET TAGS ('dbx_business_glossary_term' = 'Radio Frequency Identification (RFID) Tag Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `rpm_scan_result` SET TAGS ('dbx_business_glossary_term' = 'Radiation Portal Monitor (RPM) Scan Result');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `rpm_scan_result` SET TAGS ('dbx_value_regex' = 'clear|alarm|not_scanned|equipment_failure');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Container Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `seal_verification_status` SET TAGS ('dbx_business_glossary_term' = 'Seal Verification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `seal_verification_status` SET TAGS ('dbx_value_regex' = 'verified|broken|missing|not_checked');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `trailer_license_plate` SET TAGS ('dbx_business_glossary_term' = 'Trailer License Plate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `trailer_license_plate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `transaction_number` SET TAGS ('dbx_business_glossary_term' = 'Gate Transaction Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `transaction_number` SET TAGS ('dbx_value_regex' = '^GTX[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `transaction_status` SET TAGS ('dbx_business_glossary_term' = 'Gate Transaction Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `transaction_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|completed|rejected|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `transaction_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Gate Transaction Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_business_glossary_term' = 'Gate Transaction Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_value_regex' = 'truck_in|truck_out|rail_in|rail_out|vessel_in|vessel_out');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `truck_license_plate` SET TAGS ('dbx_business_glossary_term' = 'Truck License Plate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `truck_license_plate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `verified_gross_mass_kg` SET TAGS ('dbx_business_glossary_term' = 'Verified Gross Mass (VGM) in Kilograms');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `weight_bridge_reading_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight Bridge Reading (Kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `yard_location_assignment` SET TAGS ('dbx_business_glossary_term' = 'Yard Location Assignment');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` SET TAGS ('dbx_subdomain' = 'gate_management');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `gate_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Appointment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `customs_broker_id` SET TAGS ('dbx_business_glossary_term' = 'Access Credential Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Operator ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Lane Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `actual_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Departure Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `appointment_date` SET TAGS ('dbx_business_glossary_term' = 'Appointment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `appointment_number` SET TAGS ('dbx_business_glossary_term' = 'Appointment Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `appointment_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `appointment_status` SET TAGS ('dbx_business_glossary_term' = 'Appointment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `appointment_window_end` SET TAGS ('dbx_business_glossary_term' = 'Appointment Window End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `appointment_window_start` SET TAGS ('dbx_business_glossary_term' = 'Appointment Window Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `booking_reference` SET TAGS ('dbx_business_glossary_term' = 'Booking Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `coparn_message_reference` SET TAGS ('dbx_business_glossary_term' = 'Container Pre-Announcement (COPARN) Message Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `haulier_code` SET TAGS ('dbx_business_glossary_term' = 'Haulier Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `haulier_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `haulier_name` SET TAGS ('dbx_business_glossary_term' = 'Haulier Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `iftmin_message_reference` SET TAGS ('dbx_business_glossary_term' = 'Instruction Message for Transport (IFTMIN) Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Inspection Required Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `inspection_type` SET TAGS ('dbx_business_glossary_term' = 'Inspection Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `inspection_type` SET TAGS ('dbx_value_regex' = 'customs|security|quarantine|psc|none');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `is_hazardous_cargo` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Cargo Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `is_overweight` SET TAGS ('dbx_business_glossary_term' = 'Overweight Container Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `no_show_flag` SET TAGS ('dbx_business_glossary_term' = 'No-Show Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `processing_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Processing Duration in Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `reefer_temperature_celsius` SET TAGS ('dbx_business_glossary_term' = 'Reefer Temperature in Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Appointment Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `transaction_type` SET TAGS ('dbx_business_glossary_term' = 'Transaction Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `transaction_type` SET TAGS ('dbx_value_regex' = 'delivery|receival|empty_return|empty_pickup|export_drop|import_pickup');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `truck_driver_license` SET TAGS ('dbx_business_glossary_term' = 'Truck Driver License Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `truck_driver_license` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `truck_driver_license` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `truck_driver_name` SET TAGS ('dbx_business_glossary_term' = 'Truck Driver Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `truck_driver_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `truck_driver_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `truck_registration` SET TAGS ('dbx_business_glossary_term' = 'Truck Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `truck_registration` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,15}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `verified_gross_mass_kg` SET TAGS ('dbx_business_glossary_term' = 'Verified Gross Mass (VGM) in Kilograms');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `vgm_method` SET TAGS ('dbx_business_glossary_term' = 'Verified Gross Mass (VGM) Method');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `vgm_method` SET TAGS ('dbx_value_regex' = 'method_1|method_2');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` SET TAGS ('dbx_subdomain' = 'equipment_dispatch');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `equipment_dispatch_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Dispatch ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `charge_event_id` SET TAGS ('dbx_business_glossary_term' = 'Charge Event Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Unit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Gang Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `truck_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Appointment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `bay_position` SET TAGS ('dbx_business_glossary_term' = 'Bay Position');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `bay_position` SET TAGS ('dbx_value_regex' = '^[0-9]{2,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `booking_reference` SET TAGS ('dbx_business_glossary_term' = 'Booking Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `cargo_reference` SET TAGS ('dbx_business_glossary_term' = 'Cargo Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `completion_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Completion Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `customs_hold_flag` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `damage_flag` SET TAGS ('dbx_business_glossary_term' = 'Damage Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `destination_position` SET TAGS ('dbx_business_glossary_term' = 'Destination Position');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `destination_position` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,3}-[0-9]{2}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `dispatch_source` SET TAGS ('dbx_business_glossary_term' = 'Dispatch Source');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `dispatch_source` SET TAGS ('dbx_value_regex' = 'TOS_auto_dispatch|manual_planner_override|operator_request|emergency_dispatch');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `dispatch_status` SET TAGS ('dbx_business_glossary_term' = 'Dispatch Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `dispatch_status` SET TAGS ('dbx_value_regex' = 'pending|assigned|in_progress|completed|cancelled|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `dispatch_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Dispatch Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `equipment_type` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `gross_crane_time_seconds` SET TAGS ('dbx_business_glossary_term' = 'Gross Crane Time (Seconds)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `hatch_position` SET TAGS ('dbx_business_glossary_term' = 'Hatch Position');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `hatch_position` SET TAGS ('dbx_value_regex' = '^H[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `hazmat_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `idle_time_seconds` SET TAGS ('dbx_business_glossary_term' = 'Idle Time (Seconds)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `imdg_class` SET TAGS ('dbx_value_regex' = '1|2.1|2.2|2.3|3|4.1|4.2|4.3|5.1|5.2|6.1|6.2|7|8|9');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `moves_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Moves Per Hour (MPH)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `net_crane_time_seconds` SET TAGS ('dbx_business_glossary_term' = 'Net Crane Time (Seconds)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `origin_position` SET TAGS ('dbx_business_glossary_term' = 'Origin Position');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `origin_position` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,3}-[0-9]{2}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `oversized_flag` SET TAGS ('dbx_business_glossary_term' = 'Oversized Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `productive_flag` SET TAGS ('dbx_business_glossary_term' = 'Productive Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `reefer_flag` SET TAGS ('dbx_business_glossary_term' = 'Reefer Container Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `reefer_temperature_celsius` SET TAGS ('dbx_business_glossary_term' = 'Reefer Temperature (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `rehandle_flag` SET TAGS ('dbx_business_glossary_term' = 'Rehandle Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `rehandle_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Rehandle Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `spreader_type` SET TAGS ('dbx_business_glossary_term' = 'Spreader Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `spreader_type` SET TAGS ('dbx_value_regex' = 'standard_20ft|standard_40ft|telescopic|twin_20ft|tandem_40ft|breakbulk_hook');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `tandem_lift_flag` SET TAGS ('dbx_business_glossary_term' = 'Tandem Lift Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `twin_lift_flag` SET TAGS ('dbx_business_glossary_term' = 'Twin Lift Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `work_instruction_number` SET TAGS ('dbx_business_glossary_term' = 'Work Instruction Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `work_instruction_number` SET TAGS ('dbx_value_regex' = '^WI-[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `work_instruction_type` SET TAGS ('dbx_business_glossary_term' = 'Work Instruction Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` SET TAGS ('dbx_subdomain' = 'vessel_services');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `vessel_bay_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Bay Plan ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `berth_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Allocation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Operation Planner ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `stowage_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Stowage Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `bay_number` SET TAGS ('dbx_business_glossary_term' = 'Bay Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `cargo_cutoff_datetime` SET TAGS ('dbx_business_glossary_term' = 'Cargo Cut-off Date Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `discharge_sequence` SET TAGS ('dbx_business_glossary_term' = 'Discharge Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `hatch_number` SET TAGS ('dbx_business_glossary_term' = 'Hatch Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `hatch_sequence_plan` SET TAGS ('dbx_business_glossary_term' = 'Hatch Sequence Plan');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'IMDG (International Maritime Dangerous Goods) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `load_sequence` SET TAGS ('dbx_business_glossary_term' = 'Load Sequence Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `oog_flag` SET TAGS ('dbx_business_glossary_term' = 'OOG (Out of Gauge) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `oog_overhang_front_cm` SET TAGS ('dbx_business_glossary_term' = 'OOG (Out of Gauge) Overhang Front (Centimeters)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `oog_overhang_left_cm` SET TAGS ('dbx_business_glossary_term' = 'OOG (Out of Gauge) Overhang Left (Centimeters)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `oog_overhang_rear_cm` SET TAGS ('dbx_business_glossary_term' = 'OOG (Out of Gauge) Overhang Rear (Centimeters)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `oog_overhang_right_cm` SET TAGS ('dbx_business_glossary_term' = 'OOG (Out of Gauge) Overhang Right (Centimeters)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `oog_overheight_cm` SET TAGS ('dbx_business_glossary_term' = 'OOG (Out of Gauge) Overheight (Centimeters)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `plan_approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Plan Approved Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `plan_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Plan Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_business_glossary_term' = 'Plan Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_value_regex' = 'draft|confirmed|in_progress|completed|cancelled|revised');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `plan_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Plan Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `plan_version` SET TAGS ('dbx_business_glossary_term' = 'Plan Version Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `planned_crane_count` SET TAGS ('dbx_business_glossary_term' = 'Planned Crane Count');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `planned_gang_count` SET TAGS ('dbx_business_glossary_term' = 'Planned Gang Count');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `planned_operation_end` SET TAGS ('dbx_business_glossary_term' = 'Planned Operation End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `planned_operation_start` SET TAGS ('dbx_business_glossary_term' = 'Planned Operation Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `pod_code` SET TAGS ('dbx_business_glossary_term' = 'POD (Port of Discharge) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `pol_code` SET TAGS ('dbx_business_glossary_term' = 'POL (Port of Loading) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `pre_marshalling_required` SET TAGS ('dbx_business_glossary_term' = 'Pre-marshalling Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `reefer_flag` SET TAGS ('dbx_business_glossary_term' = 'Reefer Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `reefer_temperature_c` SET TAGS ('dbx_business_glossary_term' = 'Reefer Temperature (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `resource_allocation_notes` SET TAGS ('dbx_business_glossary_term' = 'Resource Allocation Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `restow_flag` SET TAGS ('dbx_business_glossary_term' = 'Restow Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `row_number` SET TAGS ('dbx_business_glossary_term' = 'Row Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `stowage_instruction` SET TAGS ('dbx_business_glossary_term' = 'Stowage Instruction');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `teu_count` SET TAGS ('dbx_business_glossary_term' = 'TEU (Twenty-foot Equivalent Unit) Count');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `tier_number` SET TAGS ('dbx_business_glossary_term' = 'Tier Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `total_discharge_moves` SET TAGS ('dbx_business_glossary_term' = 'Total Discharge Moves');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `total_load_moves` SET TAGS ('dbx_business_glossary_term' = 'Total Load Moves');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `transhipment_flag` SET TAGS ('dbx_business_glossary_term' = 'Transhipment Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'UN Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` SET TAGS ('dbx_subdomain' = 'vessel_services');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `berth_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Berth Allocation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `charge_event_id` SET TAGS ('dbx_business_glossary_term' = 'Charge Event Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `inspection_record_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Commercial Agreement ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `pilotage_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Assignment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `port_dues_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Port Dues Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `towage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Towage Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `voyage_id` SET TAGS ('dbx_business_glossary_term' = 'Voyage Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `wharfage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Wharfage Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `allocated_crane_count` SET TAGS ('dbx_business_glossary_term' = 'Allocated Crane Count');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `allocated_quay_length_m` SET TAGS ('dbx_business_glossary_term' = 'Allocated Quay Length (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `allocation_notes` SET TAGS ('dbx_business_glossary_term' = 'Allocation Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `allocation_number` SET TAGS ('dbx_business_glossary_term' = 'Berth Allocation Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `allocation_number` SET TAGS ('dbx_value_regex' = '^BA-[0-9]{8}-[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `allocation_reason` SET TAGS ('dbx_business_glossary_term' = 'Allocation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_business_glossary_term' = 'Allocation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_value_regex' = 'planned|confirmed|active|completed|cancelled|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `atb` SET TAGS ('dbx_business_glossary_term' = 'Actual Time of Berthing (ATB)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `atd` SET TAGS ('dbx_business_glossary_term' = 'Actual Time of Departure (ATD)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `berth_draft_restriction_m` SET TAGS ('dbx_business_glossary_term' = 'Berth Draft Restriction (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `berth_productivity_target_mph` SET TAGS ('dbx_business_glossary_term' = 'Berth Productivity Target (Moves Per Hour)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `berth_window_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Berth Window Duration (Hours)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `berth_window_end` SET TAGS ('dbx_business_glossary_term' = 'Berth Window End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `berth_window_start` SET TAGS ('dbx_business_glossary_term' = 'Berth Window Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `cancelled_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `cargo_operation_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Operation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `cargo_operation_type` SET TAGS ('dbx_value_regex' = 'LoLo|RoRo|mixed|bulk|general');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `confirmed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Confirmation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `crane_allocation_type` SET TAGS ('dbx_business_glossary_term' = 'Crane Allocation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `crane_allocation_type` SET TAGS ('dbx_value_regex' = 'STS|QC|MHC|mixed');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `etb` SET TAGS ('dbx_business_glossary_term' = 'Estimated Time of Berthing (ETB)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `etd` SET TAGS ('dbx_business_glossary_term' = 'Estimated Time of Departure (ETD)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `expected_container_moves` SET TAGS ('dbx_business_glossary_term' = 'Expected Container Moves');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `expected_teu_volume` SET TAGS ('dbx_business_glossary_term' = 'Expected Twenty-foot Equivalent Unit (TEU) Volume');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `imdg_cargo_flag` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `mooring_gang_count` SET TAGS ('dbx_business_glossary_term' = 'Mooring Gang Count');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `pilotage_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Allocation Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'critical|high|normal|low');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `sla_turnaround_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Turnaround Time (Hours)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `special_handling_requirements` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `tide_window_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Tide Window Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `towage_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Towage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `vessel_draft_m` SET TAGS ('dbx_business_glossary_term' = 'Vessel Draft (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `vessel_loa_m` SET TAGS ('dbx_business_glossary_term' = 'Vessel Length Overall (LOA) in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ALTER COLUMN `weather_restriction_flag` SET TAGS ('dbx_business_glossary_term' = 'Weather Restriction Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` SET TAGS ('dbx_subdomain' = 'yard_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `reefer_monitoring_id` SET TAGS ('dbx_business_glossary_term' = 'Reefer Monitoring Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `charge_event_id` SET TAGS ('dbx_business_glossary_term' = 'Charge Event Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `drayage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Drayage Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `import_export_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Import Export Permit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Technician ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `yard_slot_id` SET TAGS ('dbx_business_glossary_term' = 'Yard Slot Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `actual_temperature` SET TAGS ('dbx_business_glossary_term' = 'Actual Temperature');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `alarm_flag` SET TAGS ('dbx_business_glossary_term' = 'Alarm Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `alarm_severity` SET TAGS ('dbx_business_glossary_term' = 'Alarm Severity');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `alarm_severity` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `alarm_type` SET TAGS ('dbx_business_glossary_term' = 'Alarm Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `alarm_type` SET TAGS ('dbx_value_regex' = 'temperature_deviation|power_failure|door_open|humidity_deviation|co2_deviation|equipment_malfunction');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `co2_level` SET TAGS ('dbx_business_glossary_term' = 'Carbon Dioxide (CO2) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `cold_chain_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Cold Chain Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `compressor_runtime_hours` SET TAGS ('dbx_business_glossary_term' = 'Compressor Runtime Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `compressor_status` SET TAGS ('dbx_business_glossary_term' = 'Compressor Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `compressor_status` SET TAGS ('dbx_value_regex' = 'running|stopped|standby|fault');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `corrective_action_description` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Description');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `defrost_cycle_status` SET TAGS ('dbx_business_glossary_term' = 'Defrost Cycle Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `defrost_cycle_status` SET TAGS ('dbx_value_regex' = 'active|inactive|scheduled');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `door_status` SET TAGS ('dbx_business_glossary_term' = 'Door Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `door_status` SET TAGS ('dbx_value_regex' = 'closed|open|sealed');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `humidity_reading` SET TAGS ('dbx_business_glossary_term' = 'Humidity Reading');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `monitoring_source` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Source');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `monitoring_source` SET TAGS ('dbx_value_regex' = 'automated_sensor|manual_inspection|remote_telemetry|rfid_reader');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `monitoring_status` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `monitoring_status` SET TAGS ('dbx_value_regex' = 'active|resolved|escalated|pending_review');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `monitoring_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Monitoring Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `notification_sent_flag` SET TAGS ('dbx_business_glossary_term' = 'Notification Sent Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `notification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Notification Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `o2_level` SET TAGS ('dbx_business_glossary_term' = 'Oxygen (O2) Level');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `power_status` SET TAGS ('dbx_business_glossary_term' = 'Power Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `power_status` SET TAGS ('dbx_value_regex' = 'connected|disconnected|standby');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `power_supply_voltage` SET TAGS ('dbx_business_glossary_term' = 'Power Supply Voltage');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `sensor_device_code` SET TAGS ('dbx_business_glossary_term' = 'Sensor Device ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `sensor_device_code` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `sensor_device_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `set_temperature` SET TAGS ('dbx_business_glossary_term' = 'Set Temperature');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `temperature_deviation` SET TAGS ('dbx_business_glossary_term' = 'Temperature Deviation');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `temperature_unit` SET TAGS ('dbx_business_glossary_term' = 'Temperature Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `temperature_unit` SET TAGS ('dbx_value_regex' = 'celsius|fahrenheit');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `ventilation_rate` SET TAGS ('dbx_business_glossary_term' = 'Ventilation Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `ventilation_setting` SET TAGS ('dbx_business_glossary_term' = 'Ventilation Setting');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `ventilation_setting` SET TAGS ('dbx_value_regex' = 'closed|open|controlled');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` SET TAGS ('dbx_subdomain' = 'equipment_dispatch');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Equipment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `maintenance_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `acquisition_date` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `automation_level` SET TAGS ('dbx_business_glossary_term' = 'Automation Level');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `automation_level` SET TAGS ('dbx_value_regex' = 'manual|semi_automated|fully_automated|remote_controlled');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `current_yard_zone` SET TAGS ('dbx_business_glossary_term' = 'Current Yard Zone Assignment');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|declining_balance|units_of_production|sum_of_years_digits');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `emission_standard` SET TAGS ('dbx_business_glossary_term' = 'Emission Standard Compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `equipment_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `equipment_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `fuel_power_type` SET TAGS ('dbx_business_glossary_term' = 'Fuel or Power Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `fuel_power_type` SET TAGS ('dbx_value_regex' = 'diesel|electric|hybrid_diesel_electric|LNG|battery_electric|hydrogen');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `gps_tracking_enabled` SET TAGS ('dbx_business_glossary_term' = 'Global Positioning System (GPS) Tracking Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `imdg_certified` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Code Certified');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `insurance_policy_reference` SET TAGS ('dbx_business_glossary_term' = 'Insurance Policy Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `insurance_policy_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `last_major_overhaul_date` SET TAGS ('dbx_business_glossary_term' = 'Last Major Overhaul Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `maximo_asset_reference` SET TAGS ('dbx_business_glossary_term' = 'Maximo Asset Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `maximum_lift_height_metres` SET TAGS ('dbx_business_glossary_term' = 'Maximum Lift Height in Metres');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `maximum_reach_metres` SET TAGS ('dbx_business_glossary_term' = 'Maximum Reach in Metres');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `next_scheduled_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `noise_level_db` SET TAGS ('dbx_business_glossary_term' = 'Noise Level in Decibels (dB)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `operating_hours_since_last_service` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours Since Last Service');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `operating_hours_total` SET TAGS ('dbx_business_glossary_term' = 'Total Operating Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'active|under_maintenance|standby|decommissioned|out_of_service|awaiting_repair');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `operator_certification_required` SET TAGS ('dbx_business_glossary_term' = 'Operator Certification Required');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `ownership_type` SET TAGS ('dbx_business_glossary_term' = 'Ownership Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `ownership_type` SET TAGS ('dbx_value_regex' = 'owned|leased|rented|contractor_provided');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `reefer_monitoring_capable` SET TAGS ('dbx_business_glossary_term' = 'Reefer Monitoring Capable');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `replacement_value` SET TAGS ('dbx_business_glossary_term' = 'Replacement Value');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `replacement_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `rfid_tag_code` SET TAGS ('dbx_business_glossary_term' = 'Radio Frequency Identification (RFID) Tag Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Serial Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `spreader_type` SET TAGS ('dbx_business_glossary_term' = 'Spreader Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `spreader_type` SET TAGS ('dbx_value_regex' = 'fixed_20ft|fixed_40ft|telescopic_20_40ft|tandem|auto_twist_lock|manual');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `swl_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Safe Working Load (SWL) in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `tandem_lift_capable` SET TAGS ('dbx_business_glossary_term' = 'Tandem Lift Capable');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `telematics_system_code` SET TAGS ('dbx_business_glossary_term' = 'Telematics System Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `twin_lift_capable` SET TAGS ('dbx_business_glossary_term' = 'Twin Lift Capable');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ALTER COLUMN `year_of_manufacture` SET TAGS ('dbx_business_glossary_term' = 'Year of Manufacture');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` SET TAGS ('dbx_subdomain' = 'vessel_services');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Id');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `port_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Port Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line1');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line2');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `annual_throughput_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Annual Throughput Capacity Teu');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `cfs_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Cfs Area Sqm');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `cfs_facility_available` SET TAGS ('dbx_business_glossary_term' = 'Cfs Facility Available');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `contact_email` SET TAGS ('dbx_business_glossary_term' = 'Contact Email');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Contact Phone');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `customs_bonded_area` SET TAGS ('dbx_business_glossary_term' = 'Customs Bonded Area');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `dangerous_goods_certified` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Certified');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `gate_lanes_inbound` SET TAGS ('dbx_business_glossary_term' = 'Gate Lanes Inbound');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `gate_lanes_outbound` SET TAGS ('dbx_business_glossary_term' = 'Gate Lanes Outbound');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `iso_28000_certified` SET TAGS ('dbx_business_glossary_term' = 'Iso 28000 Certified');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `isps_compliant` SET TAGS ('dbx_business_glossary_term' = 'Isps Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `max_vessel_draft_m` SET TAGS ('dbx_business_glossary_term' = 'Max Vessel Draft M');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `max_vessel_loa_m` SET TAGS ('dbx_business_glossary_term' = 'Max Vessel Loa M');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `number_of_asc_cranes` SET TAGS ('dbx_business_glossary_term' = 'Number Of Asc Cranes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `number_of_berths` SET TAGS ('dbx_business_glossary_term' = 'Number Of Berths');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `number_of_mhc_units` SET TAGS ('dbx_business_glossary_term' = 'Number Of Mhc Units');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `number_of_reach_stackers` SET TAGS ('dbx_business_glossary_term' = 'Number Of Reach Stackers');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `number_of_rtg_cranes` SET TAGS ('dbx_business_glossary_term' = 'Number Of Rtg Cranes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `number_of_sts_cranes` SET TAGS ('dbx_business_glossary_term' = 'Number Of Sts Cranes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `operational_start_date` SET TAGS ('dbx_business_glossary_term' = 'Operational Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `operator_name` SET TAGS ('dbx_business_glossary_term' = 'Operator Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `operator_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `operator_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `reefer_plugs_available` SET TAGS ('dbx_business_glossary_term' = 'Reefer Plugs Available');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `rfid_enabled` SET TAGS ('dbx_business_glossary_term' = 'Rfid Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State Province');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `storage_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Storage Capacity Teu');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `terminal_type` SET TAGS ('dbx_business_glossary_term' = 'Terminal Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `time_zone` SET TAGS ('dbx_business_glossary_term' = 'Time Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `tos_system` SET TAGS ('dbx_business_glossary_term' = 'Tos System');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `total_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Total Area Sqm');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `total_quay_length_m` SET TAGS ('dbx_business_glossary_term' = 'Total Quay Length M');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
