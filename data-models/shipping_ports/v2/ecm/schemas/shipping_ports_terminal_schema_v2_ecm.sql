-- Schema for Domain: terminal | Business: Shipping_Ports | Version: v2_ecm
-- Generated on: 2026-07-13 08:38:32

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`terminal` COMMENT 'Manages container terminal operations including yard management, container stacking, gate operations, equipment dispatch (RTG, STS, ASC, QC, MHC), TOS integration (NAVIS N4, TOPS Expert), CY operations, and container tracking (RFID). Covers TEU/FEU handling, LoLo/RoRo operations, CFS activities, and terminal performance KPIs. SSOT for terminal operational execution.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` (
    `yard_block_id` BIGINT COMMENT 'Unique identifier for the container yard block. Primary key. MASTER_RESOURCE role entity representing physical yard infrastructure for container stacking operations.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Yard blocks function as cost centers for yard operations in terminal accounting. Costs (labor, equipment, utilities) and productivity metrics are tracked by block for operational management, budgeting',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Yard blocks are infrastructure assets with acquisition costs, depreciation schedules, and maintenance lifecycles. Required for capital asset register, infrastructure valuation, pavement maintenance pl',
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
    `container_id` BIGINT COMMENT 'Reference to the container currently occupying this slot. Null if slot is vacant. Enables real-time container location tracking.',
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
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: Container visits at terminal fulfill cargo bookings. Essential for tracking which booking a container movement satisfies, reconciling booked vs actual cargo, and managing booking-to-delivery lifecycle',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Customs classification, handling method determination, storage area assignment, temperature control requirements, and tariff calculation all depend on HS code reference. Essential for regulatory compl',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Terminal container visits reference standardized container types. Currently container_visit has iso_type_code as a string. Adding FK to masterdata.container_type enables standardized container classif',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Every container import/export requires customs clearance declaration. Container_visit tracks physical movement; customs_declaration tracks regulatory clearance. Core port clearance process linking ope',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Customs authorities place holds on specific container visits for examination or documentation issues. Terminal operations must track which containers are detained. Operational requirement for yard pla',
    `demurrage_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.demurrage_schedule. Business justification: Demurrage charges apply when containers exceed free_time_days. Terminal billing systems reference the demurrage_schedule to calculate tiered daily rates based on dwell time. Critical for revenue manag',
    `drayage_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.drayage_order. Business justification: Container visits are fulfilled by drayage movements. Linking visit to drayage order enables intermodal billing reconciliation, haulier performance tracking, and proof-of-delivery validation. Essential',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Container visits generate billable events (storage, handling, reefer monitoring, demurrage). Direct link enables charge validation, dispute resolution, and dwell time billing reconciliation - core por',
    `ohs_incident_id` BIGINT COMMENT 'Foreign key linking to safety.ohs_incident. Business justification: Container handling operations (discharge, load, gate movements) are high-risk activities where incidents occur. Incident investigations must trace to the specific container visit being handled when in',
    `call_id` BIGINT COMMENT 'Reference to the vessel visit during which this container was discharged or is scheduled to be loaded. Links container to vessel operations for vessel-mode arrivals/departures.',
    `sanctions_screening_id` BIGINT COMMENT 'Foreign key linking to compliance.sanctions_screening. Business justification: Every container visit must be screened against sanctions lists (cargo, shipper, consignee, vessel). Mandatory compliance process for port security and trade compliance. Links operational visit to regu',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Container visits may trigger security incidents (contraband detection, seal tampering, unauthorized access) requiring direct linkage for investigation tracking, compliance reporting, and corrective ac',
    `storage_tariff_id` BIGINT COMMENT 'Foreign key linking to tariff.storage_tariff. Business justification: Container visits accumulate storage charges based on dwell time. Port operations calculate storage fees by applying the applicable storage_tariff rate bands to the dwell_time_hours. Essential for bill',
    `transport_order_id` BIGINT COMMENT 'Foreign key linking to intermodal.transport_order. Business justification: Container visits execute transport orders in multimodal supply chains. Linking enables end-to-end shipment visibility, transport order status updates, and exception management when containers miss sch',
    `yard_slot_id` BIGINT COMMENT 'Foreign key linking to terminal.yard_slot. Business justification: container_visit has current_yard_location (STRING) and yard_block (STRING) which are denormalized representations of the containers current position. Should FK to yard_slot for authoritative location',
    `arrival_mode` STRING COMMENT 'Transportation mode by which the container arrived at the terminal. Determines gate processing, yard allocation, and intermodal handling requirements.. Valid values are `vessel|truck|rail|barge|internal`',
    `bol_number` STRING COMMENT 'Bill of Lading number associated with this container visit. Legal document issued by carrier to shipper acknowledging receipt of cargo and contract of carriage.',
    `booking_number` STRING COMMENT 'Carrier booking reference number for the container shipment. Links container to commercial booking and shipping instructions.',
    `cargo_type` STRING COMMENT 'High-level classification of cargo carried in the container. Determines handling requirements, equipment assignment, and yard allocation strategy.. Valid values are `general|reefer|hazmat|oog|empty|special`',
    `consignee_name` STRING COMMENT 'Name of the consignee (importer) for this container shipment. Sourced from BOL or booking documentation.',
    `container_number` STRING COMMENT 'Unique container identification number following ISO 6346 standard format (4 letters + 7 digits). The globally unique identifier for the physical container unit.. Valid values are `^[A-Z]{4}[0-9]{7}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this container visit record was first created in the system. Audit field for data lineage and compliance.',
    `damage_description` STRING COMMENT 'Free-text description of container damage if damage_flag is true. Documents condition for repair estimates and liability determination.',
    `damage_flag` BOOLEAN COMMENT 'Indicates whether the container has reported damage. Triggers inspection workflow and potential repair work orders.',
    `delivery_order_number` STRING COMMENT 'Delivery order number authorizing release of the container to the consignee or their agent. Required document for import container gate-out.',
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
    `pol_code` STRING COMMENT 'UN/LOCODE of the port where the container was loaded onto the vessel. Five-character code per UN/LOCODE standard.. Valid values are `^[A-Z]{5}$`',
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
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Gate release authorization depends on customs clearance status. Gate operators verify customs declaration clearance before allowing container exit. Operational control point for import/export complian',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Gate cannot release containers under active customs hold. Real-time hold status check at gate is critical operational control point. Prevents unauthorized release of detained cargo.',
    `employee_id` BIGINT COMMENT 'Identifier of the gate clerk or operator who processed the transaction.',
    `gate_lane_id` BIGINT COMMENT 'Identifier of the physical gate lane through which the transaction occurred.',
    `ohs_incident_id` BIGINT COMMENT 'Foreign key linking to safety.ohs_incident. Business justification: Gate operations involve truck movements, container lifting, and driver interactions—common incident scenarios. Incident reports must reference the specific gate transaction during which the incident o',
    `port_community_participant_id` BIGINT COMMENT 'Identifier of the trucking or transport company responsible for the container movement.',
    `screening_record_id` BIGINT COMMENT 'Foreign key linking to security.screening_record. Business justification: Every gate transaction requires security screening (document verification, watchlist check, prohibited item detection) per ISPS Code. Links transaction to screening outcome for audit trail, compliance',
    `shift_pattern_id` BIGINT COMMENT 'Foreign key linking to workforce.shift_pattern. Business justification: Gate transactions occur within specific shift windows. Shift context is critical for labor cost allocation to transactions, shift productivity analysis (transactions per shift), and MLC rest-hour comp',
    `gate_appointment_id` BIGINT COMMENT 'Foreign key linking to terminal.gate_appointment. Business justification: Gate transactions often fulfill pre-booked appointments. The gate_transaction has appointment_reference (STRING) which should be normalized to FK to gate_appointment. Business reality: a gate transact',
    `truck_appointment_id` BIGINT COMMENT 'Foreign key linking to intermodal.truck_appointment. Business justification: Gate transactions execute pre-booked truck appointments. TOS systems match arriving trucks to appointment slots for validation, lane assignment, and processing time tracking. Critical for appointment ',
    `anpr_capture_reference` STRING COMMENT 'Reference identifier to the ANPR (Automatic Number Plate Recognition) system capture of vehicle license plates for automated gate processing.',
    `bill_of_lading_number` STRING COMMENT 'BOL (Bill of Lading) number representing the contract of carriage and receipt of goods for the container.',
    `booking_reference` STRING COMMENT 'Shipping line booking reference number associated with the container movement.',
    `coparn_reference` STRING COMMENT 'Reference to the COPARN EDI message (Container Pre-Announcement) sent prior to gate arrival for pre-clearance and planning.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this gate transaction record was first created in the NAVIS N4 system.',
    `damage_description` STRING COMMENT 'Free-text description of any damage observed on the container, chassis, or cargo during gate processing.',
    `damage_flag` BOOLEAN COMMENT 'Boolean indicator whether visible damage to the container or cargo was detected during gate inspection.',
    `delivery_order_number` STRING COMMENT 'D/O (Delivery Order) number authorizing the release of the container from the terminal to the consignee or their agent.',
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
    `access_credential_id` BIGINT COMMENT 'Foreign key linking to security.access_credential. Business justification: Pre-registered gate appointments reference driver/haulier access credentials for expedited processing, security validation, and MARSEC-level access control. Enables automated credential verification a',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: Gate appointments are scheduled for container pickup/delivery tied to specific cargo bookings. Links appointment system to cargo booking for delivery order validation and container release authorizati',
    `container_visit_id` BIGINT COMMENT 'Foreign key linking to terminal.container_visit. Business justification: Gate appointments are pre-booked for container movements (gate-in or gate-out) that are part of terminal visits. The gate_appointment table has container_number (STRING) but no FK to container_visit. ',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Pre-arrival gate appointments reference expected customs clearance status for planning. Truck appointment systems verify customs release before scheduling. Operational planning dependency on regulator',
    `employee_id` BIGINT COMMENT 'Identifier of the terminal gate operator who processed the appointment transaction.',
    `gate_lane_id` BIGINT COMMENT 'Foreign key linking to terminal.gate_lane. Business justification: Gate appointments are scheduled for specific gate lanes. The gate_appointment table currently has gate_lane_number (STRING) but no FK relationship. Adding gate_lane_id FK enables proper referential in',
    `call_id` BIGINT COMMENT 'Identifier linking to the vessel visit for which this container is being delivered or received, establishing the vessel-cargo relationship.',
    `port_community_participant_id` BIGINT COMMENT 'Identifier linking to the port community participant (haulier, shipping line, freight forwarder) associated with this appointment.',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the truck arrived at the terminal gate, captured by gate operating system or RFID readers.',
    `actual_departure_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the truck departed from the terminal gate after completing the transaction.',
    `appointment_date` DATE COMMENT 'Calendar date for which the gate appointment is scheduled.',
    `appointment_number` STRING COMMENT 'Externally-known unique business identifier for the gate appointment, used for tracking and reference by hauliers and terminal operators.. Valid values are `^[A-Z0-9]{8,20}$`',
    `appointment_status` STRING COMMENT 'Current lifecycle status of the gate appointment indicating its progression through the gate transaction workflow. [ENUM-REF-CANDIDATE: pending|confirmed|arrived|in_progress|completed|cancelled|no_show — 7 candidates stripped; promote to reference product]',
    `appointment_window_end` TIMESTAMP COMMENT 'End timestamp of the scheduled appointment time slot window, defining the latest acceptable arrival time for the appointment.',
    `appointment_window_start` TIMESTAMP COMMENT 'Start timestamp of the scheduled appointment time slot window during which the truck is expected to arrive at the gate.',
    `bill_of_lading_number` STRING COMMENT 'Bill of Lading number associated with the cargo being moved through the gate, linking to cargo manifest documentation.',
    `booking_reference` STRING COMMENT 'Shipping line booking reference number associated with the container being handled in this gate transaction.',
    `cancellation_reason` STRING COMMENT 'Reason provided for cancellation of the gate appointment, applicable when appointment_status is cancelled.',
    `coparn_message_reference` STRING COMMENT 'Reference to the COPARN EDI message (EDIFACT) that pre-announced the container arrival or departure, enabling advance planning.',
    `created_by_user` STRING COMMENT 'User identifier or system account that created the gate appointment record.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the gate appointment record was first created in the system.',
    `delivery_order_number` STRING COMMENT 'Delivery order number authorizing the release of the container from the terminal to the haulier.',
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
    `access_credential_id` BIGINT COMMENT 'Foreign key linking to security.access_credential. Business justification: Equipment operators require valid security credentials to access restricted zones (waterside, customs, hazmat areas) per MARSEC protocols. Tracks operator clearance for dispatch authorization, zone ac',
    `container_visit_id` BIGINT COMMENT 'Foreign key linking to terminal.container_visit. Business justification: Equipment dispatch work instructions move containers that are part of terminal visits. The equipment_dispatch table has container_number (STRING) but no FK to container_visit. Adding container_visit_i',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Equipment dispatches represent resource consumption that must be allocated to cost centers for activity-based costing, operational cost control, and productivity analysis. Each dispatch is costed to t',
    `gang_id` BIGINT COMMENT 'Foreign key linking to workforce.gang. Business justification: Equipment dispatches for vessel operations (especially quay crane moves) are performed by stevedore gangs. Tracking gang assignment enables gang productivity measurement (moves per gang hour), labor c',
    `call_id` BIGINT COMMENT 'Foreign key reference to the vessel visit for vessel loading/discharge operations. Null for yard-only or gate operations.',
    `employee_id` BIGINT COMMENT 'Unique identifier of the equipment operator assigned to execute this work instruction. Format: OP followed by six digits. Null for automated equipment (AGV, ASC).',
    `rail_visit_id` BIGINT COMMENT 'Foreign key linking to intermodal.rail_visit. Business justification: Terminal equipment dispatches load/discharge containers to/from rail wagons. Linking dispatch to rail visit enables rail productivity reporting (moves per hour), rail operator billing verification, an',
    `terminal_equipment_id` BIGINT COMMENT 'Unique identifier of the specific terminal handling equipment unit assigned to execute this dispatch instruction (e.g., RTG-0012, STS-0003, ASC-0007). Format: three-letter equipment type code followed by hyphen and four-digit unit number.',
    `thc_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.thc_schedule. Business justification: Terminal handling charges (THC) are applied per container move (load/discharge/shift). Equipment dispatch records the productive move; linking to thc_schedule enables accurate per-move billing based o',
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
    `container_visit_id` BIGINT COMMENT 'Foreign key linking to terminal.container_visit. Business justification: Vessel bay plan records define the stowage position of containers that are part of terminal visits (either being loaded or discharged). The vessel_bay_plan table has container_number (STRING) but no F',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Bay plans contain cargo manifest data that feeds customs declarations for vessel cargo. Regulatory data flow from stowage plan to customs clearance. Required for FAL Form 2 and customs manifest submis',
    `edi_message_id` BIGINT COMMENT 'Unique identifier for the UN/EDIFACT BAPLIE message received from the vessel or shipping line containing stowage plan data.',
    `employee_id` BIGINT COMMENT 'Reference to the terminal operations planner or vessel planner responsible for creating and maintaining this bay plan.',
    `pilotage_assignment_id` BIGINT COMMENT 'Foreign key linking to marine.pilotage_assignment. Business justification: Vessel bay plans are created in coordination with specific pilotage assignments to ensure accurate vessel positioning for cargo operations. Links stowage planning with actual vessel berthing execution',
    `call_id` BIGINT COMMENT 'Reference to the specific vessel call or visit for which this bay plan applies.',
    `personnel_id` BIGINT COMMENT 'Foreign key linking to security.security_personnel. Business justification: Bay plans containing hazmat/restricted cargo require security officer review and clearance per ISPS Code. Tracks which security-cleared personnel approved stowage plans for audit trail, liability dete',
    `terminal_berth_allocation_id` BIGINT COMMENT 'Reference to the berth allocation record specifying where the vessel will dock.',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to booking.call_booking. Business justification: Bay plans are stowage plans created for vessel call bookings. Links planning artifact to original booking for tracking booking requirements (reefer count, hazmat, TEU) against planned stowage configur',
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

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` (
    `terminal_berth_allocation_id` BIGINT COMMENT 'Unique identifier for the berth allocation record. Primary key for the berth allocation entity.',
    `berth_id` BIGINT COMMENT 'Reference to the physical berth location allocated for this vessel call. Links to port infrastructure master data.',
    `agreement_id` BIGINT COMMENT 'Reference to the commercial agreement or contract governing the terms of this berth allocation. Links to contract domain for tariff and SLA details.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Berth operations are cost centers in port management accounting. Each berth allocation must be costed to a specific cost center for operational budgeting, variance analysis, and berth productivity rep',
    `dos_record_id` BIGINT COMMENT 'Foreign key linking to security.dos_record. Business justification: SOLAS/ISPS mandate Declaration of Security for ship-port interface. Each berth allocation for international vessels requires DOS completion before operations commence. Links allocation to security agr',
    `inspection_id` BIGINT COMMENT 'Foreign key linking to safety.safety_inspection. Business justification: Berth operations require pre-arrival safety inspections per ISPS, port state control, and terminal safety protocols. Documented inspections tied to specific berth allocations are mandatory before vess',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Berth allocation is primary revenue source (berth hire charges based on LOA, duration, GRT). Link enables berth occupancy charge validation, SLA-based billing, and berth productivity reconciliation - ',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Berth operations must comply with current facility ISPS security level. Vessel-shore interface security procedures depend on facility security status. Operational requirement for Declaration of Securi',
    `call_id` BIGINT COMMENT 'Reference to the vessel visit for which this berth is allocated. Links to the vessel operations domain.',
    `port_dues_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.port_dues_schedule. Business justification: Port dues are vessel-level charges calculated per berth call based on GRT/LOA bands. Berth allocation triggers port dues billing by referencing the applicable schedule for the vessels characteristics',
    `profit_centre_id` BIGINT COMMENT 'Foreign key linking to finance.profit_centre. Business justification: Berths are profit centers in port P&L reporting. Each berth allocation generates revenue and costs tracked to profit centers for segment reporting, performance management, and strategic berth utilizat',
    `employee_id` BIGINT COMMENT 'Reference to the system user who created this berth allocation record. Links to workforce domain for audit trail.',
    `terminal_employee_id` BIGINT COMMENT 'Reference to the terminal operations staff member responsible for creating and managing this berth allocation. Links to workforce domain.',
    `terminal_last_modified_by_user_employee_id` BIGINT COMMENT 'Reference to the system user who last modified this berth allocation record. Links to workforce domain for audit trail.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Berth compatibility validation, crane allocation planning, mooring gang sizing, and operational resource forecasting require vessel type specifications before vessel arrival. Critical for berth planni',
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
    CONSTRAINT pk_terminal_berth_allocation PRIMARY KEY(`terminal_berth_allocation_id`)
) COMMENT 'Transactional record of berth assignments for vessel calls at the terminal. Captures berth identifier, vessel visit reference, planned and actual berthing time (ETB/ATB), planned and actual departure time (ETD/ATD), berth window duration, allocated quay length, draft restrictions, crane allocation count, berth planner ID, and allocation status (planned, confirmed, active, completed). SSOT for berth planning in TOPS Expert and NAVIS N4.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` (
    `reefer_monitoring_id` BIGINT COMMENT 'Primary key for reefer_monitoring',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Cold chain compliance validation, temperature range verification against commodity specifications, and cargo-specific monitoring protocols require HS code reference. Essential for perishable cargo qua',
    `container_id` BIGINT COMMENT 'Foreign key reference to the reefer container being monitored. Links to the container master data.',
    `container_visit_id` BIGINT COMMENT 'Foreign key linking to terminal.container_visit. Business justification: Reefer monitoring events track temperature and condition of refrigerated containers during their terminal visit. The reefer_monitoring table already has container_id pointing to cargo.container (cross',
    `employee_id` BIGINT COMMENT 'Foreign key reference to the technician who performed manual inspection or intervention on this reefer container.',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Reefer monitoring is separately billable service (power supply, temperature monitoring, alarm response). Link enables per-container reefer charge validation, power consumption billing - specialized co',
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
    `technician_inspection_reference` STRING COMMENT 'Reference number or identifier linking this monitoring event to a technician inspection work order or maintenance record. Populated when manual intervention occurred.',
    `temperature_deviation` DECIMAL(18,2) COMMENT 'The calculated difference between set temperature and actual temperature in degrees. Positive values indicate warmer than set point, negative values indicate cooler than set point.',
    `temperature_unit` STRING COMMENT 'The unit of measure for temperature readings. Standard is Celsius but Fahrenheit may be used in some jurisdictions.. Valid values are `celsius|fahrenheit`',
    `ventilation_rate` DECIMAL(18,2) COMMENT 'The air exchange rate in cubic meters per hour when ventilation is active. Applicable for cargo requiring fresh air circulation.',
    `ventilation_setting` STRING COMMENT 'The ventilation mode configured for the reefer container. Closed for frozen cargo, open for fresh air exchange, controlled for modified atmosphere.. Valid values are `closed|open|controlled`',
    CONSTRAINT pk_reefer_monitoring PRIMARY KEY(`reefer_monitoring_id`)
) COMMENT 'Transactional record of reefer container temperature and condition monitoring events within the terminal yard. Captures container number, yard slot position, set temperature, actual temperature reading, humidity reading, CO2 level, ventilation setting, monitoring timestamp, alarm flag, alarm type (temperature deviation, power failure, door open), and technician inspection reference. Ensures cold chain integrity for perishable cargo.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` (
    `container_damage_id` BIGINT COMMENT 'Unique identifier for the container damage record. Primary key for the container damage assessment entity.',
    `container_id` BIGINT COMMENT 'Reference to the container that sustained damage. Links to the container master record for full container details including container number, size, type, and ownership.',
    `container_visit_id` BIGINT COMMENT 'Reference to the specific container visit or handling event during which the damage was discovered. Links to the container movement or visit record in the Terminal Operating System (TOS).',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Container damage repairs generate invoices or credit adjustments. Link supports damage claim billing, repair cost recovery, liability party invoicing - standard terminal damage handling process.',
    `ohs_incident_id` BIGINT COMMENT 'Foreign key linking to safety.ohs_incident. Business justification: Container damage discovery often coincides with or causes safety incidents (falling cargo, structural failure, hazmat exposure). Incident investigations must cross-reference damage reports to determin',
    `employee_id` BIGINT COMMENT 'Reference to the system user who created the initial damage record. Supports audit trail and accountability for data quality.',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the legal owner of the container (may be shipping line, leasing company, or container pool). Critical for determining who must be notified and who will receive repair payment.',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to procurement.vendor. Business justification: Container repairs are outsourced to specialized repair vendors. Damage reports must track which vendor performed repairs for cost recovery, quality assessment, vendor performance evaluation, and liabi',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Container damage may indicate security breach (tampering, theft, sabotage). Links damage report to security incident for investigation coordination, root cause analysis, and determination whether dama',
    `shipping_line_id` BIGINT COMMENT 'Reference to the shipping line or carrier responsible for the container at the time of damage discovery. Used for notification, claims, and liability coordination.',
    `surveyor_id` BIGINT COMMENT 'Reference to the surveyor or inspector who conducted the damage assessment. May be internal terminal staff or external independent surveyor depending on damage severity and liability context.',
    `trade_document_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_document. Business justification: Damage reports may require amendments to trade documents (survey certificates, condition reports). Documentary evidence chain for cargo claims and insurance. Links operational damage record to regulat',
    `actual_repair_cost` DECIMAL(18,2) COMMENT 'Final invoiced cost of repairs completed. Used for variance analysis against estimate, billing to liable party, and financial reporting. Amount in terminal base currency.',
    `cargo_damage_indicator` BOOLEAN COMMENT 'Flag indicating whether the container damage also resulted in damage to the cargo inside. Triggers separate cargo damage assessment and claims processes.',
    `cargo_status_at_discovery` STRING COMMENT 'Whether the container was empty or laden (loaded with cargo) when the damage was discovered. Impacts liability assessment and urgency of repair or cargo transfer.. Valid values are `empty|laden|unknown`',
    `claim_reference_number` STRING COMMENT 'External claim reference number assigned by the P&I club, insurance company, or shipping line for tracking the damage claim. Used for reconciliation and correspondence.',
    `container_size_type` STRING COMMENT 'ISO 6346 container size and type code. Denormalized from container master for reporting and analysis. Format: 2-digit size code + 2-letter type code (e.g., 22G1 for 20ft general purpose).. Valid values are `^[0-9]{2}[A-Z]{2}$`',
    `corrective_action_taken` STRING COMMENT 'Description of corrective actions implemented to prevent recurrence of similar damage incidents. May include training, equipment maintenance, process changes, or safety improvements.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the damage record was first created in the Terminal Operating System. Part of audit trail for record lifecycle tracking.',
    `damage_description` STRING COMMENT 'Detailed narrative description of the damage observed, including dimensions, extent, and any contributing factors. Provides context for surveyors, repairers, and claims adjusters.',
    `damage_location_code` STRING COMMENT 'Standardized code identifying the specific location on the container where damage occurred. Uses IICL location coding system for precise damage mapping and repair specification.. Valid values are `^[A-Z]{2}[0-9]{2}$`',
    `damage_report_number` STRING COMMENT 'Unique business identifier for the damage report used for external communication with shipping lines, P&I clubs, and surveyors. Format: DMG-YYYYMMDD sequence.. Valid values are `^DMG-[0-9]{8}$`',
    `damage_report_status` STRING COMMENT 'Current lifecycle status of the damage report. Tracks progression from initial discovery through survey, liability determination, claims processing, and final resolution. [ENUM-REF-CANDIDATE: draft|submitted|under_review|approved|disputed|closed|cancelled — 7 candidates stripped; promote to reference product]',
    `damage_severity` STRING COMMENT 'Assessment of the severity level of the damage based on repair cost, structural integrity impact, and container serviceability. Used for prioritization and liability determination.. Valid values are `minor|moderate|major|total_loss`',
    `damage_type` STRING COMMENT 'Classification of the type of damage sustained by the container. Categorizes damage by the structural component or system affected to support repair estimation and liability assessment. [ENUM-REF-CANDIDATE: structural|door|floor|roof|side_panel|corner_post|front_wall|refrigeration_unit|twist_lock|seal — 10 candidates stripped; promote to reference product]',
    `discovery_location` STRING COMMENT 'The specific physical location within the terminal where the damage was discovered, such as gate lane number, yard block and row, or berth position. Supports incident investigation and operational analysis.',
    `discovery_point` STRING COMMENT 'The operational checkpoint or activity during which the damage was first discovered. Critical for establishing liability and determining whether damage occurred on-terminal or pre-existing. [ENUM-REF-CANDIDATE: gate_in|gate_out|discharge|loading|yard_inspection|vessel_inspection|delivery|receiving — 8 candidates stripped; promote to reference product]',
    `discovery_timestamp` TIMESTAMP COMMENT 'The date and time when the container damage was first identified and recorded. Used for liability determination and claims processing timelines.',
    `edi_message_reference` STRING COMMENT 'Reference to the EDI message (such as CODECO Container Damage Report) sent to notify external parties of the damage. Supports audit trail and message reconciliation.',
    `environmental_incident_flag` BOOLEAN COMMENT 'Flag indicating whether the container damage resulted in an environmental incident such as spill, leak, or release of hazardous materials. Triggers regulatory reporting and remediation protocols.',
    `equipment_involved` STRING COMMENT 'Identification of terminal equipment involved in causing or discovering the damage, such as RTG (Rubber Tyred Gantry), STS (Ship-to-Shore crane), reach stacker, or gate inspection equipment. Supports root cause analysis.',
    `estimated_repair_cost` DECIMAL(18,2) COMMENT 'Surveyor estimate of the cost to repair the damage to IICL standards. Used for liability assessment, claims processing, and repair authorization thresholds. Amount in terminal base currency.',
    `imdg_class` STRING COMMENT 'IMDG classification of dangerous goods if the damaged container held hazardous cargo. Critical for safety assessment and environmental incident reporting. Empty if container held general cargo.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to the damage record. Tracks record currency and supports change detection for downstream systems.',
    `liability_party` STRING COMMENT 'Determination of which party is responsible for the damage based on discovery point, handling records, and investigation findings. Critical for claims processing and cost recovery.. Valid values are `terminal|shipping_line|stevedore|trucker|unknown|under_investigation`',
    `notification_sent_timestamp` TIMESTAMP COMMENT 'Date and time when damage notification was sent to the shipping line, container owner, or other relevant parties. Critical for compliance with contractual notification requirements and claims timelines.',
    `photographic_evidence_reference` STRING COMMENT 'Reference identifier or file path to digital photographs documenting the damage. Critical evidence for P&I claims, disputes, and repair verification. May reference document management system or cloud storage location.',
    `remarks` STRING COMMENT 'Additional free-text comments, notes, or observations related to the damage incident, survey, or claims process. Provides context not captured in structured fields.',
    `repair_authorization_number` STRING COMMENT 'Authorization number provided by the container owner or shipping line approving repair work. Required before terminal or depot can proceed with repairs and invoice for costs.',
    `repair_completion_date` DATE COMMENT 'Date on which container repairs were completed and container returned to serviceable condition. Used for tracking repair turnaround time and container availability.',
    `repair_cost_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the estimated repair cost. Supports multi-currency operations and financial reporting.. Valid values are `^[A-Z]{3}$`',
    `repair_recommendation` STRING COMMENT 'Surveyor recommendation on the appropriate action to take regarding the damaged container. Guides operational decisions on container disposition and repair authorization.. Valid values are `repair|scrap|monitor|no_action_required`',
    `root_cause_analysis` STRING COMMENT 'Documented findings from investigation into the root cause of the damage. May include operator error, equipment malfunction, pre-existing condition, or external factors. Supports continuous improvement.',
    `safety_incident_flag` BOOLEAN COMMENT 'Flag indicating whether the container damage was associated with a safety incident involving personnel injury or equipment damage. Triggers OHS reporting and investigation.',
    `survey_date` DATE COMMENT 'The date on which the formal damage survey was conducted. May differ from discovery date if initial discovery was by gate clerk and formal survey conducted later by qualified surveyor.',
    CONSTRAINT pk_container_damage PRIMARY KEY(`container_damage_id`)
) COMMENT 'Transactional record of container damage assessments and surveys conducted at the terminal. Captures container number, container visit reference, damage type (structural, door, floor, roof, side panel), damage severity (minor, moderate, major), damage location code, discovery point (gate-in, discharge, yard inspection), surveyor ID, photographic evidence reference, repair recommendation, liability party, and damage report status. Supports P&I claims and cargo liability management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` (
    `cfs_activity_id` BIGINT COMMENT 'Unique identifier for the CFS activity record. Primary key for the CFS activity transaction.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: CFS stuffing/stripping services are governed by specific consolidation service agreements defining handling rates, liability terms, storage periods, and operational procedures. Billing systems must va',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: CFS stuffing/stripping activities fulfill cargo bookings for LCL shipments. Links consolidation/deconsolidation operations to original booking for billing reconciliation and cargo tracking in less-tha',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: CFS stuffing/stripping operations require HS code for customs documentation generation, handling method selection, storage area assignment, and billing tariff classification. Essential for LCL cargo p',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: CFS cargo consolidation requires HS code classification for customs declaration and duty calculation. Operational data capture for LCL shipments. Links warehouse activity to tariff classification for ',
    `container_visit_id` BIGINT COMMENT 'Foreign key linking to terminal.container_visit. Business justification: CFS (Container Freight Station) activities such as stuffing and stripping are performed on containers during their terminal visit. The cfs_activity table has container_number (STRING) but no FK to con',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: CFS stuffing/stripping activities generate LCL cargo requiring customs clearance. Operational-to-regulatory data flow for consolidated shipments. Links warehouse activity to customs declaration for im',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: CFS operations (container stuffing/stripping, LCL handling) are billable services. Link enables CFS charge reconciliation, handling fee validation, per-package billing - core CFS revenue process.',
    `item_id` BIGINT COMMENT 'Foreign key linking to tariff.tariff_item. Business justification: CFS stuffing/stripping activities are billable services with specific tariff rates per package, weight, or volume. Linking to tariff_item enables accurate service charge calculation and supports the e',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: CFS stuffing/stripping operations require tracking which employee performed the work for productivity measurement (packages per hour), quality accountability (damage claims), and labor billing to cust',
    `packaging_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.packaging_type. Business justification: CFS operations must verify UN packaging compliance, select appropriate handling equipment, determine stacking limits, and validate IMDG/SOLAS requirements based on package type specifications. Removes',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the workforce member or team responsible for performing the CFS activity. Used for productivity tracking and accountability.',
    `shift_pattern_id` BIGINT COMMENT 'Foreign key linking to workforce.shift_pattern. Business justification: CFS activities are shift-based operations. Shift tracking enables labor cost allocation to CFS jobs, shift productivity benchmarking (CBM handled per shift), and compliance with labor agreements defin',
    `shipment_id` BIGINT COMMENT 'Reference to the parent shipment record for this CFS activity. Links the CFS operation to the broader cargo movement.',
    `tertiary_cfs_consignee_port_community_participant_id` BIGINT COMMENT 'Reference to the consignee party receiving the cargo. Links to the customer or participant account.',
    `activity_status` STRING COMMENT 'Current lifecycle status of the CFS activity. Tracks the operational state from scheduling through completion.. Valid values are `scheduled|in_progress|completed|suspended|cancelled`',
    `activity_type` STRING COMMENT 'Type of CFS operation performed. Stuffing refers to loading cargo into a container; stripping refers to unloading cargo from a container; consolidation combines multiple LCL shipments; deconsolidation separates consolidated cargo.. Valid values are `stuffing|stripping|consolidation|deconsolidation|inspection|repacking`',
    `actual_start_time` TIMESTAMP COMMENT 'Actual date and time when the CFS activity commenced. Used for performance measurement and billing accuracy.',
    `bill_of_lading_number` STRING COMMENT 'Bill of Lading reference number for the cargo being handled. Legal document serving as receipt and contract of carriage.. Valid values are `^[A-Z0-9]{10,20}$`',
    `cargo_description` STRING COMMENT 'Detailed description of the cargo being handled in the CFS operation. Includes commodity type, packaging, and general characteristics.',
    `cargo_volume_cbm` DECIMAL(18,2) COMMENT 'Total volume of cargo measured in cubic meters. Critical for space planning and freight calculation for LCL shipments.',
    `cargo_weight_kg` DECIMAL(18,2) COMMENT 'Total weight of cargo in kilograms. Used for load planning, billing, and compliance with container weight limits per SOLAS VGM requirements.',
    `cfs_job_number` STRING COMMENT 'Business identifier for the CFS job. Externally-known reference number used for tracking and billing purposes.. Valid values are `^CFS[0-9]{8,12}$`',
    `cfs_location_code` STRING COMMENT 'Code identifying the specific CFS facility or zone where the activity is performed. Used for operational planning and resource allocation.. Valid values are `^CFS[A-Z0-9]{2,6}$`',
    `completion_timestamp` TIMESTAMP COMMENT 'Date and time when the CFS activity was completed. Marks the end of the operational lifecycle for this transaction.',
    `consignee_reference` STRING COMMENT 'Consignee-provided reference number for cargo identification and delivery coordination. Used for matching cargo to receiver records.',
    `created_by_user` STRING COMMENT 'Username or identifier of the system user who created this CFS activity record. Audit trail for data governance and accountability.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this CFS activity record was first created in the system. Audit trail for data lineage and compliance.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this transaction. Ensures consistent financial reporting.. Valid values are `^[A-Z]{3}$`',
    `damage_description` STRING COMMENT 'Detailed description of any damage observed during the CFS activity. Used for claims processing and liability determination.',
    `damage_reported_flag` BOOLEAN COMMENT 'Indicates whether cargo or container damage was reported during the CFS activity. True if damage was observed and documented.',
    `dangerous_goods_flag` BOOLEAN COMMENT 'Indicates whether the cargo contains dangerous goods requiring special handling per IMDG Code. True if hazardous materials are present.',
    `duration_minutes` STRING COMMENT 'Total time in minutes taken to complete the CFS activity. Calculated from actual start to completion for productivity analysis and billing.',
    `handling_charge_amount` DECIMAL(18,2) COMMENT 'Base charge amount for the CFS handling service. Excludes taxes and additional fees. Used for billing and revenue recognition.',
    `imdg_class` STRING COMMENT 'IMDG classification for dangerous goods if applicable. Classes range from 1 (explosives) to 9 (miscellaneous dangerous substances). [ENUM-REF-CANDIDATE: 1|2|3|4|5|6|7|8|9 — 9 candidates stripped; promote to reference product]',
    `last_modified_by_user` STRING COMMENT 'Username or identifier of the system user who last modified this CFS activity record. Audit trail for change tracking and compliance.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this CFS activity record was last updated. Tracks data currency and change history for audit purposes.',
    `number_of_packages` STRING COMMENT 'Total count of individual packages, cartons, pallets, or units being handled in this CFS activity. Used for inventory control and customs declaration.',
    `remarks` STRING COMMENT 'Free-text field for operational notes, special instructions, or exceptions related to the CFS activity. Captures information not covered by structured fields.',
    `scheduled_start_time` TIMESTAMP COMMENT 'Planned date and time when the CFS activity is scheduled to begin. Used for resource planning and operational coordination.',
    `seal_intact_flag` BOOLEAN COMMENT 'Indicates whether the container seal was found intact upon arrival at CFS. True if seal was unbroken, false if tampered or missing.',
    `seal_number` STRING COMMENT 'Security seal number applied to the container after stuffing or removed before stripping. Critical for cargo security and customs compliance per ISPS Code.. Valid values are `^[A-Z0-9]{6,20}$`',
    `shipper_reference` STRING COMMENT 'Shipper-provided reference number or identifier for tracking and correspondence. May include purchase order numbers or internal shipper codes.',
    `target_temperature_celsius` DECIMAL(18,2) COMMENT 'Required temperature setting in degrees Celsius for temperature-controlled cargo. Used for reefer container configuration and monitoring.',
    `temperature_controlled_flag` BOOLEAN COMMENT 'Indicates whether the cargo requires temperature-controlled handling. True for refrigerated or temperature-sensitive cargo.',
    `un_number` STRING COMMENT 'Four-digit UN identification number for dangerous goods. Standardized code for hazardous material classification and emergency response.. Valid values are `^UN[0-9]{4}$`',
    CONSTRAINT pk_cfs_activity PRIMARY KEY(`cfs_activity_id`)
) COMMENT 'Transactional record of Container Freight Station (CFS) activities for LCL (Less than Container Load) cargo consolidation and deconsolidation. Captures CFS job number, activity type (stuffing, stripping, consolidation, deconsolidation), container number, cargo description, CBM, weight, number of packages, shipper/consignee reference, customs examination flag, examination result, CFS operator ID, and completion timestamp.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` (
    `terminal_service_order_id` BIGINT COMMENT 'Unique identifier for the terminal service order. Primary key for this entity.',
    `access_credential_id` BIGINT COMMENT 'Foreign key linking to security.access_credential. Business justification: Service providers (repair technicians, inspectors, cleaners) require valid security credentials to access terminal areas per ISPS Code. Links service order to provider credential for access authorizat',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Terminal service orders (container repairs, inspections, special handling, cleaning) are governed by service agreements defining rates, terms, and SLAs. Billing validation requires linking service cha',
    `booking_service_order_id` BIGINT COMMENT 'Foreign key linking to booking.booking_service_order. Business justification: Terminal service orders execute booking service orders (pilotage, towage, mooring). Links operational execution to booking request for SLA tracking, billing reconciliation, and service delivery confir',
    `container_id` BIGINT COMMENT 'Reference to the container for which the terminal service is being performed.',
    `container_visit_id` BIGINT COMMENT 'Foreign key linking to terminal.container_visit. Business justification: Terminal service orders (repairs, inspections, cleaning, etc.) are performed on containers during their terminal visit. The terminal_service_order table has container_id pointing to cargo.container (c',
    `customs_hold_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_hold. Business justification: Services on containers under customs hold (repairs, inspections, surveys) require customs authorization. Operational control for service execution and billing. Prevents unauthorized access to detained',
    `employee_id` BIGINT COMMENT 'Reference to the terminal operator or technician assigned to perform the service.',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Non-standard terminal services (container repairs, special handling, extended storage, equipment rentals) are tracked as internal orders for cost collection and settlement to customers or cost centers',
    `invoice_id` BIGINT COMMENT 'Reference to the invoice where this service charge was billed to the customer.',
    `item_id` BIGINT COMMENT 'Foreign key linking to tariff.tariff_item. Business justification: Service orders (repairs, inspections, special handling) are priced per tariff_item rates. Linking provides rate provenance for the charge_amount field and enables tariff compliance audits. Essential f',
    `material_master_id` BIGINT COMMENT 'Foreign key linking to procurement.material_master. Business justification: Terminal service orders consume materials (spare parts, consumables, lashing equipment). Material consumption tracking for cost allocation, inventory management, and service costing requires linking s',
    `permit_to_work_id` BIGINT COMMENT 'Foreign key linking to safety.permit_to_work. Business justification: Service orders for hot work, confined space entry, or equipment maintenance require permits to work per safety regulations. Terminal operations cannot authorize high-risk service work without valid PT',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the customer (shipping line, freight forwarder, or cargo owner) who requested the terminal service.',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Outsourced terminal services (container repairs, reefer maintenance, cleaning, lashing) are procured via purchase orders. Financial reconciliation, three-way matching (service entry vs PO vs invoice),',
    `service_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.service_code. Business justification: Billing classification, GL account mapping, tariff rate lookup, SLA definition, and revenue recognition all require service code master data reference. Critical for terminal billing operations and fin',
    `shift_pattern_id` BIGINT COMMENT 'Foreign key linking to workforce.shift_pattern. Business justification: Service orders (container repairs, PTI, cleaning, reefer services) are scheduled and executed within shift windows. Shift tracking is essential for labor cost allocation, shift productivity reporting ',
    `terminal_equipment_id` BIGINT COMMENT 'Reference to the terminal equipment (RTG, MHC, forklift, etc.) assigned to perform the service, if applicable.',
    `yard_slot_id` BIGINT COMMENT 'Foreign key linking to terminal.yard_slot. Business justification: terminal_service_order has yard_location (STRING) which should be normalized to FK when the service is performed at a yard slot. Services like repairs, inspections, or reefer maintenance are performed',
    `actual_completion_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the service was completed, used for SLA compliance measurement and billing finalization.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Actual timestamp when the service execution began, captured for performance tracking and billing verification.',
    `approval_required` BOOLEAN COMMENT 'Indicates whether the service order requires management or customer approval before execution, typically for high-value or non-standard services.',
    `approval_status` STRING COMMENT 'Current approval status of the service order in the authorization workflow.. Valid values are `pending|approved|rejected|not_required`',
    `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when the service order was approved, used for workflow tracking and SLA calculation.',
    `approved_by` STRING COMMENT 'Identifier of the user who approved the service order, for audit trail and accountability purposes.',
    `cancellation_reason` STRING COMMENT 'Reason provided for service order cancellation, used for operational analysis and customer service improvement.',
    `cancellation_timestamp` TIMESTAMP COMMENT 'Timestamp when the service order was cancelled, used for operational reporting and billing adjustments.',
    `cancelled_by` STRING COMMENT 'Identifier of the user or system that cancelled the service order, for audit trail purposes.',
    `charge_amount` DECIMAL(18,2) COMMENT 'Monetary amount charged for the terminal service, used for revenue recognition and customer billing.',
    `charge_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the service charge amount.. Valid values are `^[A-Z]{3}$`',
    `charge_reference` STRING COMMENT 'Reference to the billing charge or tariff code associated with this service for revenue tracking and invoicing.',
    `completion_date` DATE COMMENT 'Date when the terminal service was completed, used for daily operational reporting and revenue recognition.',
    `completion_remarks` STRING COMMENT 'Final remarks or comments recorded upon service completion, including any deviations from standard procedure or follow-up actions required.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the service order record was first created in the system, used for audit trail and data lineage.',
    `customer_reference_number` STRING COMMENT 'External reference number provided by the customer for their internal tracking and reconciliation purposes.',
    `estimated_duration_minutes` STRING COMMENT 'Estimated duration for the service execution in minutes, used for scheduling and resource planning.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the service order record was last modified, used for change tracking and data synchronization.',
    `priority_level` STRING COMMENT 'Priority classification for service execution scheduling, with urgent services requiring immediate attention.. Valid values are `urgent|high|normal|low`',
    `quality_check_performed` BOOLEAN COMMENT 'Indicates whether a quality inspection or verification was performed after service completion to ensure standards were met.',
    `quality_check_result` STRING COMMENT 'Result of the quality inspection performed after service completion, indicating whether the service met required standards.. Valid values are `passed|failed|conditional|not_applicable`',
    `requested_date` DATE COMMENT 'Date when the customer initially requested the terminal service, used for SLA tracking and service demand analysis.',
    `requested_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the service order was submitted by the customer or created in the system.',
    `scheduled_date` DATE COMMENT 'Date when the terminal service is planned to be performed, used for resource allocation and customer communication.',
    `scheduled_end_time` TIMESTAMP COMMENT 'Planned timestamp for when the service execution should be completed, used for capacity planning and SLA management.',
    `scheduled_start_time` TIMESTAMP COMMENT 'Planned timestamp for when the service execution should begin, used for precise equipment and operator scheduling.',
    `service_duration_minutes` STRING COMMENT 'Actual duration of the service execution in minutes, calculated from start to completion timestamps for productivity analysis.',
    `service_location_type` STRING COMMENT 'Type of terminal location where the service is performed, such as container yard, gate, berth, container freight station (CFS), workshop, or inspection area.. Valid values are `yard|gate|berth|cfs|workshop|inspection_area`',
    `service_notes` STRING COMMENT 'Operational notes recorded by the assigned operator during or after service execution, documenting observations or issues encountered.',
    `service_order_number` STRING COMMENT 'Externally-known business identifier for the terminal service order, typically formatted as TSO- followed by numeric sequence. Used for customer communication and billing reference.. Valid values are `^TSO-[0-9]{8,12}$`',
    `service_status` STRING COMMENT 'Current lifecycle status of the terminal service order in the workflow from request through completion or cancellation. [ENUM-REF-CANDIDATE: requested|scheduled|in_progress|completed|cancelled|on_hold|failed — 7 candidates stripped; promote to reference product]',
    `sla_compliance_flag` BOOLEAN COMMENT 'Indicates whether the service was completed within the agreed SLA timeframe, used for performance monitoring and customer satisfaction tracking.',
    `sla_target_hours` DECIMAL(18,2) COMMENT 'Target turnaround time in hours as defined in the customer service level agreement for this type of service.',
    `special_instructions` STRING COMMENT 'Specific instructions or requirements provided by the customer for service execution, such as handling precautions or timing constraints.',
    `work_order_reference` STRING COMMENT 'Reference to the maintenance or operational work order associated with this service, if applicable.',
    CONSTRAINT pk_terminal_service_order PRIMARY KEY(`terminal_service_order_id`)
) COMMENT 'Transactional record of value-added terminal service requests and orders raised by shipping lines, freight forwarders, or cargo owners. Captures service order number, customer reference, service type (reefer monitoring, container washing, fumigation, weighing, lashing/unlashing, OOG handling, customs examination facilitation), container number, requested date, scheduled date, completion date, assigned operator, service status, and charge reference. Supports terminal ancillary revenue and service delivery tracking.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` (
    `terminal_equipment_id` BIGINT COMMENT 'Unique identifier for the terminal handling equipment unit. Primary key for the terminal equipment master data.',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Terminal equipment assets are assigned to cost centers for depreciation allocation, maintenance cost tracking, and operational cost reporting. Each equipment unit has a home cost center for financial ',
    `equipment_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.equipment_type. Business justification: Equipment maintenance standards, certification requirements, operational specifications, and resource planning all require master equipment type reference. Removes denormalized equipment_type, manufac',
    `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Terminal equipment (cranes, RTGs, reach stackers, forklifts) are capitalized fixed assets requiring integration between operational equipment master and financial asset register for depreciation, net ',
    `material_master_id` BIGINT COMMENT 'Foreign key linking to procurement.material_master. Business justification: Critical spare parts inventory planning for terminal equipment requires linking equipment types to their primary spare parts in material master. Enables predictive maintenance, inventory optimization,',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Ports track which operator is currently assigned to each equipment unit (RTG, reach stacker, forklift) for operational dispatch, accountability, maintenance handover, and incident investigation. Essen',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Terminal equipment are port assets tracked in both operational (terminal_equipment) and financial (port_asset) systems. Required for depreciation reporting, capital expenditure tracking, asset valuati',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: Major terminal equipment (cranes, RTGs) typically has long-term maintenance contracts with OEMs or specialized service providers. Linking equipment to contracts enables contract utilization tracking, ',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Equipment is assigned to specific terminal zones for operational dispatch, maintenance planning, and resource allocation. The existing home_terminal text field is insufficient; equipment dispatch sy',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to procurement.vendor. Business justification: Terminal equipment (cranes, RTGs, reach stackers) procurement and warranty tracking requires vendor linkage. Equipment maintenance, spare parts ordering, and warranty claims depend on knowing the orig',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Equipment home location and current zone assignment required for security patrol verification, zone access control, and asset tracking. Enables security personnel to verify equipment authorization in ',
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
    `home_terminal` STRING COMMENT 'Primary terminal or facility where the equipment is permanently assigned. Used for multi-terminal port operations to track equipment allocation and inter-terminal transfers.',
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
    CONSTRAINT pk_terminal_equipment PRIMARY KEY(`terminal_equipment_id`)
) COMMENT 'Master data for all terminal handling equipment (THE) units operated within the terminal. Captures equipment number, equipment type (RTG, STS/QC, ASC, MHC, AGV, reach stacker, empty handler, forklift, terminal tractor), make, model, year of manufacture, SWL (Safe Working Load), operational status (active, under maintenance, standby, decommissioned), current yard zone assignment, fuel/power type, and Maximo asset reference. SSOT for terminal equipment identity within the terminal domain (operational profile; full asset lifecycle owned by asset domain).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` (
    `roro_activity_id` BIGINT COMMENT 'Unique identifier for the RoRo activity record. Primary key for the RoRo activity transaction.',
    `employee_id` BIGINT COMMENT 'Identifier of the driver or tug operator who performed the roll-on or roll-off operation. Links to workforce management for accountability and performance tracking.',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: RoRo handling is billable per vehicle unit (loading/discharge, lashing, deck positioning). Link supports per-unit vehicle handling charge validation, RoRo terminal revenue reconciliation - specialized',
    `ohs_incident_id` BIGINT COMMENT 'Foreign key linking to safety.ohs_incident. Business justification: RoRo operations (vehicle driving on/off vessel) have unique incident risks (vehicle accidents, ramp failures, lashing injuries). Incident investigations for RoRo operations must link to the specific a',
    `call_id` BIGINT COMMENT 'Reference to the vessel visit during which this RoRo activity occurred. Links the activity to the specific vessel call.',
    `port_community_participant_id` BIGINT COMMENT 'Identifier of the customer (shipping line, freight forwarder, or cargo owner) responsible for the cargo. Links to customer master data for billing and service level tracking.',
    `screening_record_id` BIGINT COMMENT 'Foreign key linking to security.screening_record. Business justification: RoRo cargo (vehicles) requires security screening for contraband, stowaways, and prohibited items per ISPS Code. Links activity to screening outcome for compliance verification, stowaway detection aud',
    `shift_pattern_id` BIGINT COMMENT 'Identifier of the operational shift during which the activity occurred. Used for workforce planning and productivity analysis.',
    `wharfage_schedule_id` BIGINT COMMENT 'Foreign key linking to tariff.wharfage_schedule. Business justification: RoRo cargo (vehicles, rolling stock) is charged wharfage per unit or tonnage. RoRo activity records the handling event; linking to wharfage_schedule enables per-unit billing based on vehicle type, wei',
    `yard_slot_id` BIGINT COMMENT 'Foreign key linking to terminal.yard_slot. Business justification: roro_activity has yard_position (STRING) which should be normalized to FK to yard_slot. RoRo vehicles are stored in yard slots when not on vessel. FK allows JOIN to get slot coordinates, accessibility',
    `activity_end_timestamp` TIMESTAMP COMMENT 'Date and time when the RoRo activity was completed. Used for duration calculation and productivity analysis.',
    `activity_number` STRING COMMENT 'Business identifier for the RoRo activity. Externally-known reference number used in operational communications and documentation.. Valid values are `^RORO-[A-Z0-9]{8,12}$`',
    `activity_start_timestamp` TIMESTAMP COMMENT 'Date and time when the RoRo activity commenced. Used for operational performance measurement and billing.',
    `activity_status` STRING COMMENT 'Current lifecycle status of the RoRo activity. Tracks the operational state from planning through completion.. Valid values are `planned|in-progress|completed|cancelled|suspended`',
    `activity_type` STRING COMMENT 'Type of RoRo handling activity performed. Distinguishes between loading (roll-on), discharge (roll-off), securing (lashing), releasing (unlashing), inspection, and repositioning operations.. Valid values are `roll-on|roll-off|lashing|unlashing|inspection|repositioning`',
    `bill_of_lading_number` STRING COMMENT 'Reference to the Bill of Lading document covering this cargo unit. Links the activity to shipping documentation and customs clearance.',
    `booking_reference` STRING COMMENT 'Customer booking reference number for the RoRo cargo. Links the activity to commercial agreements and billing.',
    `cargo_condition` STRING COMMENT 'Overall condition assessment of the vehicle or cargo unit at the time of handling. Used for quality control and customer service.. Valid values are `excellent|good|fair|poor|damaged`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this RoRo activity record was first created in the system. Used for audit trail and data lineage.',
    `customs_status` STRING COMMENT 'Customs clearance status of the cargo unit. Determines whether the cargo can be released from the terminal.. Valid values are `cleared|pending|held|bonded|in-transit`',
    `damage_description` STRING COMMENT 'Detailed description of any damage detected during inspection. Used for claims processing and liability determination.',
    `damage_detected_flag` BOOLEAN COMMENT 'Indicates whether damage was detected during inspection. True if damage found, false if no damage or no inspection performed.',
    `damage_inspection_flag` BOOLEAN COMMENT 'Indicates whether a damage inspection was performed during or after the activity. True if inspection occurred, false otherwise.',
    `dangerous_goods_flag` BOOLEAN COMMENT 'Indicates whether the vehicle or cargo unit contains or is classified as dangerous goods. True if IMDG-classified cargo, false otherwise.',
    `deck_position` STRING COMMENT 'Stowage position on the vessel deck where the vehicle is located or will be placed. Follows vessel stowage plan notation.',
    `duration_minutes` STRING COMMENT 'Total duration of the RoRo activity in minutes. Calculated from start and end timestamps for performance KPI tracking.',
    `equipment_used` STRING COMMENT 'Identifier of the terminal equipment (tug, tractor, forklift) used to perform the RoRo activity. Links to asset management for utilization tracking.',
    `final_destination` STRING COMMENT 'Ultimate destination of the cargo unit beyond the port of discharge. Used for intermodal coordination and delivery planning.',
    `handling_instruction` STRING COMMENT 'Special handling instructions or requirements for the cargo unit. May include stowage preferences, security requirements, or operational constraints.',
    `height_meters` DECIMAL(18,2) COMMENT 'Height of the vehicle or cargo unit in meters. Critical for deck clearance and stowage planning.',
    `imdg_class` STRING COMMENT 'IMDG classification code if the cargo is dangerous goods. Determines handling, stowage, and safety requirements.',
    `lashing_equipment_type` STRING COMMENT 'Type of lashing equipment used to secure the cargo. Determines securing method and safety compliance.. Valid values are `chain|webbing|wire-rope|turnbuckle|twist-lock|combination`',
    `lashing_point_count` STRING COMMENT 'Number of lashing points used to secure the vehicle or cargo unit. Ensures compliance with cargo securing requirements.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this RoRo activity record was last modified. Used for audit trail and change tracking.',
    `length_meters` DECIMAL(18,2) COMMENT 'Length of the vehicle or cargo unit in meters. Used for stowage planning and space allocation.',
    `port_of_discharge` STRING COMMENT 'UN/LOCODE of the port where the cargo is to be discharged from the vessel. Five-character code following UN/LOCODE standard.. Valid values are `^[A-Z]{5}$`',
    `port_of_loading` STRING COMMENT 'UN/LOCODE of the port where the cargo was originally loaded onto the vessel. Five-character code following UN/LOCODE standard.. Valid values are `^[A-Z]{5}$`',
    `ramp_identifier` STRING COMMENT 'Identifier of the RoRo ramp used for the activity. Links the operation to specific terminal infrastructure.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, observations, or operational comments related to the RoRo activity.',
    `un_number` STRING COMMENT 'UN number for dangerous goods identification. Four-digit code assigned by the United Nations Committee of Experts on the Transport of Dangerous Goods.. Valid values are `^UN[0-9]{4}$`',
    `vehicle_make` STRING COMMENT 'Manufacturer or brand of the vehicle being handled. Used for inventory tracking and customer reporting.',
    `vehicle_model` STRING COMMENT 'Model designation of the vehicle being handled. Provides detailed identification for tracking and documentation.',
    `vehicle_type` STRING COMMENT 'Classification of the vehicle or cargo unit being handled. Determines handling requirements, stowage planning, and safety protocols. [ENUM-REF-CANDIDATE: car|truck|trailer|bus|heavy-machinery|project-cargo|agricultural-equipment|construction-equipment — 8 candidates stripped; promote to reference product]',
    `vehicle_unit_identifier` STRING COMMENT 'Unique identifier for the vehicle or cargo unit being handled. May be VIN (Vehicle Identification Number), chassis number, or equipment identifier depending on cargo type.',
    `weight_tonnes` DECIMAL(18,2) COMMENT 'Actual or declared weight of the vehicle or cargo unit in metric tonnes. Critical for vessel stability calculations and safe working load compliance.',
    `width_meters` DECIMAL(18,2) COMMENT 'Width of the vehicle or cargo unit in meters. Used for stowage planning and clearance verification.',
    CONSTRAINT pk_roro_activity PRIMARY KEY(`roro_activity_id`)
) COMMENT 'Transactional record of Roll-on Roll-off (RoRo) cargo handling activities at the terminal. Captures activity type (roll-on, roll-off, lashing, unlashing), vehicle/cargo unit identifier, vehicle type (car, truck, trailer, heavy machinery, project cargo), vessel visit reference, ramp used, deck position, weight, dimensions, lashing point count, driver or tug operator ID, activity timestamp, and damage inspection flag. Supports RoRo terminal operations distinct from LoLo container handling.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` (
    `hazmat_declaration_id` BIGINT COMMENT 'Unique identifier for the hazardous material declaration record. Primary key for the hazmat_declaration product.',
    `cargo_booking_id` BIGINT COMMENT 'Foreign key linking to booking.cargo_booking. Business justification: Hazmat declarations are submitted as part of cargo booking process for dangerous goods. Links regulatory compliance documentation to booking for pre-arrival approval and terminal acceptance decision-m',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: IMDG Code requires a competent person to certify dangerous goods declarations. Tracking the certifying employee is mandatory for regulatory compliance, audit trails, and competency verification (emplo',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Customs clearance, tariff classification, import/export license verification, and WCO control flag checks for dangerous goods require HS code reference. Dangerous goods must satisfy both IMDG and cust',
    `hs_code_id` BIGINT COMMENT 'Foreign key linking to compliance.hs_code. Business justification: Hazmat declarations must include correct HS classification for customs duty calculation and trade restriction screening. Regulatory requirement linking dangerous goods classification to tariff classif',
    `container_id` BIGINT COMMENT 'Foreign key reference to the container entity. Links this hazmat declaration to the specific container carrying dangerous goods.',
    `container_visit_id` BIGINT COMMENT 'Foreign key linking to terminal.container_visit. Business justification: hazmat_declaration has container_visit_reference (STRING) which should be normalized to FK. A hazmat declaration is specific to a containers visit to the terminal (not just the container itself, as t',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Dangerous goods declarations must be submitted to customs as part of import/export clearance. IMDG compliance requires customs notification. Regulatory requirement linking hazmat safety and customs cl',
    `hazard_register_id` BIGINT COMMENT 'Foreign key linking to safety.hazard_register. Business justification: IMDG cargo declarations must map to terminal hazard register entries for segregation planning, emergency response preparedness, and regulatory compliance. Terminal safety management requires linking d',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.imdg_class. Business justification: Segregation table lookup, stowage category determination, EMS code retrieval, and SOLAS/MARPOL compliance verification require full IMDG class master data beyond the class number field. Critical for d',
    `invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: Hazmat handling incurs surcharges (IMDG handling, segregation, inspection, documentation). Link enables hazmat fee validation, dangerous goods surcharge reconciliation - regulatory compliance revenue.',
    `surcharge_rule_id` BIGINT COMMENT 'Foreign key linking to tariff.surcharge_rule. Business justification: Hazardous cargo incurs IMDG surcharges defined in surcharge_rule schedules. Terminal operations apply these surcharges at acceptance/handling. Link enables automated surcharge calculation based on IMD',
    `threat_assessment_id` BIGINT COMMENT 'Foreign key linking to security.threat_assessment. Business justification: Hazmat acceptance decisions reference current threat assessment (terrorism, sabotage risk) per ISPS security protocols. Links declaration to threat level for risk-based acceptance decisions, enhanced ',
    `trade_restriction_id` BIGINT COMMENT 'Foreign key linking to compliance.trade_restriction. Business justification: Hazmat shipments may be subject to trade restrictions (dual-use chemicals, precursors, sanctioned materials). Compliance screening requirement to verify dangerous goods against export control and sanc',
    `yard_slot_id` BIGINT COMMENT 'Foreign key linking to terminal.yard_slot. Business justification: hazmat_declaration has yard_slot_position (STRING) which should be normalized to FK. Hazmat containers must be stored in IMDG-certified slots with proper segregation. FK allows validation of hazmat_ap',
    `acceptance_decision_by` STRING COMMENT 'The name or user ID of the terminal hazmat officer or supervisor who made the acceptance decision. Used for audit trail and accountability.',
    `acceptance_decision_timestamp` TIMESTAMP COMMENT 'The date and time when the terminal made the acceptance decision (accepted, rejected, or conditional). Null if status is still pending.',
    `bol_number` STRING COMMENT 'The Bill of Lading number associated with the dangerous goods shipment. Links the hazmat declaration to the cargo manifest and commercial documentation.',
    `competent_authority_approval_reference` STRING COMMENT 'The approval reference number issued by the competent authority for dangerous goods requiring special authorization (e.g., Class 1 explosives, Class 7 radioactive materials). Null if no approval required.',
    `competent_authority_notification_reference` STRING COMMENT 'The reference number of the notification sent to the competent authority (port state control, customs, or environmental agency) for high-risk dangerous goods. Required for certain IMDG classes per local regulations.',
    `consignee_name` STRING COMMENT 'The legal name of the consignee (receiver) of the dangerous goods. Must match the Bill of Lading (BOL) consignee.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this hazmat declaration record was first created in the system. Used for audit trail and data lineage.',
    `dgd_document_reference` STRING COMMENT 'The unique reference number of the Dangerous Goods Declaration document submitted by the shipper. Links to the electronic or paper DGD in the Port Community System (PCS).',
    `dgd_submission_timestamp` TIMESTAMP COMMENT 'The date and time when the Dangerous Goods Declaration was submitted to the terminal via EDI, PCS, or manual upload. Used for compliance verification and SLA tracking.',
    `emergency_contact_name` STRING COMMENT 'The name of the person or organization to contact in case of a hazmat emergency. Required for 24/7 emergency response coordination.',
    `emergency_contact_phone` STRING COMMENT 'The 24-hour emergency contact phone number for hazmat incidents. Must be operational at all times during container stay at terminal.',
    `ems_number` STRING COMMENT 'The IMDG Code Emergency Schedule number (e.g., F-A, S-B) providing fire-fighting and spillage response procedures. Used by terminal emergency response teams.. Valid values are `^F-[A-Z]$|^S-[A-Z]$`',
    `excepted_quantity_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the dangerous goods are shipped in excepted quantities per IMDG Code Chapter 3.5. Excepted quantities have minimal regulatory requirements.',
    `flashpoint_celsius` DECIMAL(18,2) COMMENT 'The flashpoint temperature in degrees Celsius for flammable liquids (IMDG Class 3). Critical for fire risk assessment and segregation planning. Null for non-flammable goods.',
    `gross_weight_kg` DECIMAL(18,2) COMMENT 'The total gross weight of the container including dangerous goods and packaging, measured in kilograms. Used for equipment dispatch and Safe Working Load (SWL) compliance.',
    `imdg_class` STRING COMMENT 'The IMDG Code classification of the dangerous goods (Classes 1-9 with subdivisions). Determines segregation requirements, stowage restrictions, and emergency response procedures. Class 1: Explosives; Class 2: Gases; Class 3: Flammable liquids; Class 4: Flammable solids; Class 5: Oxidizing substances; Class 6: Toxic substances; Class 7: Radioactive material; Class 8: Corrosives; Class 9: Miscellaneous dangerous goods.. Valid values are `1|1.1|1.2|1.3|1.4|1.5|1.6|2.1|2.2|2.3|3|4.1|4.2|4.3|5.1|5.2|6.1|6.2|7|8|9`',
    `inspection_completed_timestamp` TIMESTAMP COMMENT 'The date and time when the physical hazmat inspection was completed. Null if no inspection required or not yet completed.',
    `inspection_required_flag` BOOLEAN COMMENT 'Boolean flag indicating whether a physical inspection of the container and documentation is required by the terminal hazmat officer before acceptance. True for high-risk classes or first-time shippers.',
    `inspector_name` STRING COMMENT 'The name or user ID of the terminal hazmat inspector who conducted the physical inspection. Null if no inspection performed.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this hazmat declaration record was last modified. Used for audit trail and change tracking.',
    `limited_quantity_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the dangerous goods are shipped in limited quantities per IMDG Code Chapter 3.4. Limited quantities have relaxed packaging and labeling requirements.',
    `marine_pollutant_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the dangerous goods are classified as a marine pollutant under MARPOL Annex III. True if marine pollutant marking is required.',
    `mfag_table_number` STRING COMMENT 'The IMDG Code Medical First Aid Guide table number providing first aid instructions for exposure to the dangerous goods. Used by terminal medical and safety personnel.',
    `net_quantity` DECIMAL(18,2) COMMENT 'The net quantity of dangerous goods in the container, excluding packaging. Used for segregation distance calculations and emergency response planning.',
    `net_quantity_unit` STRING COMMENT 'The unit of measure for the net quantity: kilograms (kg), liters (L), or cubic meters (m3). Must align with IMDG Code reporting requirements.. Valid values are `kg|L|m3`',
    `packing_group` STRING COMMENT 'The IMDG packing group indicating the degree of danger: I (high danger), II (medium danger), III (low danger). Determines packaging specifications and handling requirements.. Valid values are `I|II|III`',
    `placarding_required_flag` BOOLEAN COMMENT 'Boolean flag indicating whether IMDG placards and labels must be affixed to the container. True for most dangerous goods; false for limited/excepted quantities.',
    `proper_shipping_name` STRING COMMENT 'The official IMDG Code proper shipping name for the dangerous goods. Must match the UN number and IMDG class. Used on all shipping documents and placards.',
    `rejection_reason` STRING COMMENT 'Free-text explanation of why the hazmat declaration was rejected. May include incomplete documentation, non-compliance with IMDG Code, or terminal capacity constraints. Null if not rejected.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, observations, or special instructions related to the hazmat declaration. May include inspector comments, operational notes, or customer requests.',
    `segregation_distance_meters` DECIMAL(18,2) COMMENT 'The minimum required horizontal separation distance in meters from incompatible dangerous goods, calculated per IMDG Code Chapter 7.2. Enforced by the TOS yard planning module.',
    `segregation_group` STRING COMMENT 'The IMDG Code segregation group code used to determine minimum separation distances from incompatible dangerous goods in the yard. Derived from IMDG Chapter 7.2 segregation tables.',
    `shipper_name` STRING COMMENT 'The legal name of the shipper (consignor) responsible for the dangerous goods declaration. Must match the Bill of Lading (BOL) shipper.',
    `special_stowage_instructions` STRING COMMENT 'Free-text field capturing any special stowage, handling, or segregation instructions from the shipper or competent authority. May include ventilation requirements, temperature controls, or away-from restrictions.',
    `terminal_acceptance_status` STRING COMMENT 'The current status of the hazmat declaration in the terminal acceptance workflow. Pending: under review; Accepted: approved for handling; Rejected: not accepted; Conditional: accepted with restrictions; Withdrawn: declaration cancelled by shipper.. Valid values are `pending|accepted|rejected|conditional|withdrawn`',
    `un_number` STRING COMMENT 'The four-digit UN identification number assigned to the dangerous substance or article (e.g., UN1203 for gasoline). Used globally to identify hazardous materials in transport.. Valid values are `^UN[0-9]{4}$`',
    `vessel_name` STRING COMMENT 'The name of the vessel carrying or scheduled to carry the container with dangerous goods. Used for vessel stowage planning and BAPLIE message generation.',
    `voyage_number` STRING COMMENT 'The voyage number of the vessel call associated with this hazmat container. Links the declaration to the specific vessel visit for stowage coordination.',
    CONSTRAINT pk_hazmat_declaration PRIMARY KEY(`hazmat_declaration_id`)
) COMMENT 'Transactional record of dangerous goods (IMDG Code) declarations for hazardous containers handled at the terminal. Captures container number, container visit reference, IMDG class (1-9), UN number, proper shipping name, packing group (I/II/III), flashpoint, emergency contact, segregation requirements (per IMDG Chapter 7.2), special stowage instructions, terminal acceptance status, competent authority notification reference, and Dangerous Goods Declaration (DGD) document reference. Ensures IMDG Code compliance for hazardous cargo handling, yard segregation distance enforcement, and emergency response planning.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` (
    `container_tariff_exception_application_id` BIGINT COMMENT 'Unique identifier for this specific application of a tariff exception to a container visit. Primary key.',
    `container_visit_id` BIGINT COMMENT 'Foreign key linking to the specific container visit to which this tariff exception was applied during billing.',
    `employee_id` BIGINT COMMENT 'Reference to the user who applied this tariff exception to this container visit in the billing system. Supports accountability and audit requirements.',
    `exception_id` BIGINT COMMENT 'Foreign key linking to the approved tariff exception that was applied to this container visit.',
    `invoice_id` BIGINT COMMENT 'Reference to the invoice in which this exception application was billed. Null if not yet invoiced. Links exception application to financial settlement.',
    `application_notes` STRING COMMENT 'Free-text notes documenting any special circumstances, manual adjustments, or business context relevant to this specific application of the exception to this container visit.',
    `application_status` STRING COMMENT 'Current status of this exception application: APPLIED (active), REVERSED (cancelled), DISPUTED (under review), CONFIRMED (finalized in invoice). Tracks lifecycle of the application.',
    `application_timestamp` TIMESTAMP COMMENT 'System timestamp when this tariff exception was applied to this container visit in the billing system. Provides audit trail for when the exception was operationally activated.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this exception application record.',
    `discount_percentage` DECIMAL(18,2) COMMENT 'The actual percentage discount applied to this container visit under this exception. Captured at application time to preserve historical accuracy even if the exception terms change.',
    `effective_date` DATE COMMENT 'The date from which this tariff exception became applicable to this container visit. Typically aligned with container arrival or gate-in date, but may differ based on exception terms.',
    `exception_rate_amount` DECIMAL(18,2) COMMENT 'The actual exceptional rate amount applied to this specific container visit under this exception, in the specified currency. May differ from the exceptions standard rate if further adjustments were made.',
    `expiry_date` DATE COMMENT 'The date on which this tariff exception ceases to apply to this container visit. Used to calculate the period during which exceptional rates are valid for billing.',
    `free_days_granted` STRING COMMENT 'The number of free days granted to this specific container visit under this exception before storage or demurrage charges apply. Captured at application time.',
    `revenue_impact_amount` DECIMAL(18,2) COMMENT 'Calculated financial impact of applying this exception to this container visit, expressed as the difference between standard tariff and exception rate. Negative values indicate revenue reduction.',
    `waiver_amount` DECIMAL(18,2) COMMENT 'The absolute monetary amount waived for this specific container visit under this exception, in the specified currency. Recorded at application time for audit trail.',
    CONSTRAINT pk_container_tariff_exception_application PRIMARY KEY(`container_tariff_exception_application_id`)
) COMMENT 'This association product represents the application of approved tariff exceptions to specific container visits during terminal operations. It captures the operational linkage between negotiated rate concessions and actual container movements, recording which exceptions were applied, the effective rates charged, and the financial impact. Each record links one container visit to one tariff exception with attributes that exist only in the context of this billing application.. Existence Justification: In maritime terminal operations, a single container visit can have multiple tariff exceptions applied simultaneously (e.g., a volume discount exception plus a free-day extension exception for the same container), and a single tariff exception (such as a customer-level rate agreement) applies to multiple container visits over time. The business actively manages these applications as operational billing events, tracking which exceptions were applied to which containers, the effective rates charged, and the revenue impact for each application.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` (
    `berth_discount_application_id` BIGINT COMMENT 'Unique identifier for this discount application record. Primary key.',
    `employee_id` BIGINT COMMENT 'Reference to the employee who created this discount application record',
    `discount_scheme_id` BIGINT COMMENT 'Foreign key linking to the discount scheme being applied',
    `terminal_berth_allocation_id` BIGINT COMMENT 'Foreign key linking to the berth allocation record to which the discount is applied',
    `application_reason` STRING COMMENT 'Business justification for applying this discount to this berth allocation (e.g., Customer met quarterly TEU threshold, Promotional campaign for new service, Off-peak berthing incentive)',
    `application_status` STRING COMMENT 'Lifecycle status of this discount application: pending (awaiting approval), approved (authorized but not yet applied), applied (discount reflected in billing), rejected (not authorized), expired (no longer valid)',
    `applied_discount_value` DECIMAL(18,2) COMMENT 'The actual discount value applied to this specific berth allocation. May differ from the schemes base discount_value due to pro-rating, caps, or threshold calculations specific to this allocation.',
    `approval_authority_name` STRING COMMENT 'Name or role of the person who approved this specific discount application (may differ from the schemes general approval authority for case-by-case approvals)',
    `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when this specific discount application was approved',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this discount application record was created',
    `discount_amount_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the applied discount amount',
    `effective_from_timestamp` TIMESTAMP COMMENT 'Timestamp from which this discount application becomes effective for this berth allocation. Typically aligned with berth_window_start or ATB.',
    `effective_to_timestamp` TIMESTAMP COMMENT 'Timestamp until which this discount application remains effective for this berth allocation. Typically aligned with berth_window_end or ATD.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this discount application record was last modified',
    `threshold_met_flag` BOOLEAN COMMENT 'Indicates whether the qualifying threshold defined in the discount scheme was met at the time of this application',
    `volume_commitment_teu` STRING COMMENT 'TEU volume commitment associated with this discount application, if the discount is contingent on volume thresholds',
    CONSTRAINT pk_berth_discount_application PRIMARY KEY(`berth_discount_application_id`)
) COMMENT 'This association product represents the application of commercial discount schemes to specific berth allocations. It captures which discount schemes were applied to which berth allocations, the effective discount value realized, and the business justification for the discount application. Each record links one berth allocation to one discount scheme with attributes that exist only in the context of this specific discount application.. Existence Justification: In maritime port operations, a single berth allocation can qualify for multiple concurrent discount schemes (e.g., a high-volume customer receives both a loyalty discount and an off-peak berthing discount on the same vessel call). Conversely, a single discount scheme (e.g., Q1 2024 Container Volume Incentive) applies to many berth allocations across multiple customers and vessel calls. The commercial team actively manages which discounts apply to which allocations, tracks approval workflows, and records the effective discount amounts for billing reconciliation.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` (
    `gate_lane_id` BIGINT COMMENT 'Primary key for gate_lane',
    `paired_gate_lane_id` BIGINT COMMENT 'Self-referencing FK on gate_lane (paired_gate_lane_id)',
    `port_gate_id` BIGINT COMMENT 'Reference to the parent gate complex or gate facility that this lane belongs to.',
    `terminal_id` BIGINT COMMENT 'Reference to the terminal where this gate lane is located.',
    `appointment_required` BOOLEAN COMMENT 'Indicates whether vehicles must have a pre-scheduled appointment to use this lane.',
    `automation_level` STRING COMMENT 'Degree of automation implemented in the gate lane for processing and verification activities.',
    `average_processing_time_seconds` STRING COMMENT 'Average time in seconds required to process a single vehicle transaction through this lane.',
    `booth_number` STRING COMMENT 'Identifier for the gate booth or control station associated with this lane, if applicable.',
    `cargo_type_restriction` STRING COMMENT 'Specifies any restrictions on the type of cargo that can be processed through this lane.',
    `commissioning_date` DATE COMMENT 'Date when the gate lane was first commissioned and put into service.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this gate lane record was first created in the system.',
    `customs_clearance_enabled` BOOLEAN COMMENT 'Indicates whether customs clearance activities can be performed at this lane.',
    `effective_from_date` DATE COMMENT 'Date when this gate lane configuration became or will become active and operational.',
    `effective_to_date` DATE COMMENT 'Date when this gate lane configuration will cease to be active, null if currently active with no planned end date.',
    `geo_coordinates_latitude` DECIMAL(18,2) COMMENT 'Latitude coordinate of the gate lane location in decimal degrees format.',
    `geo_coordinates_longitude` DECIMAL(18,2) COMMENT 'Longitude coordinate of the gate lane location in decimal degrees format.',
    `inspection_lane` BOOLEAN COMMENT 'Indicates whether this lane is designated for detailed physical inspection of containers and cargo.',
    `lane_length_meters` DECIMAL(18,2) COMMENT 'Physical length of the gate lane measured in meters, from entry point to exit point.',
    `lane_name` STRING COMMENT 'Descriptive name or label for the gate lane to aid in identification and wayfinding.',
    `lane_number` STRING COMMENT 'Business identifier for the gate lane, typically displayed on signage and used in operational communications (e.g., A1, B3, TRUCK-05).',
    `lane_type` STRING COMMENT 'Classification of the gate lane based on its operational purpose and traffic flow direction.',
    `lane_width_meters` DECIMAL(18,2) COMMENT 'Physical width of the gate lane measured in meters, determining the size of vehicles that can be accommodated.',
    `last_maintenance_date` DATE COMMENT 'Date when the most recent maintenance or inspection was performed on the lane equipment and infrastructure.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this gate lane record was most recently modified in the system.',
    `maximum_vehicle_height_meters` DECIMAL(18,2) COMMENT 'Maximum permitted height for vehicles using this lane, typically constrained by overhead structures or equipment.',
    `next_scheduled_maintenance_date` DATE COMMENT 'Date when the next planned maintenance or inspection is scheduled for the lane.',
    `ocr_enabled` BOOLEAN COMMENT 'Indicates whether the lane is equipped with OCR cameras for automated license plate and container number recognition.',
    `operating_hours_end` STRING COMMENT 'Daily end time for lane operations in HH:MM format (24-hour clock).',
    `operating_hours_start` STRING COMMENT 'Daily start time for lane operations in HH:MM format (24-hour clock).',
    `operational_status` STRING COMMENT 'Current operational state of the gate lane indicating availability for processing traffic.',
    `priority_lane` BOOLEAN COMMENT 'Indicates whether this lane is designated for priority or expedited processing of pre-approved or trusted carrier vehicles.',
    `processing_capacity_per_hour` STRING COMMENT 'Designed throughput capacity of the lane measured in number of vehicle transactions that can be processed per hour under normal operating conditions.',
    `radiation_scanner_equipped` BOOLEAN COMMENT 'Indicates whether the lane has radiation detection equipment for security screening of containers.',
    `remarks` STRING COMMENT 'Additional notes, comments, or special instructions related to the gate lane configuration or operations.',
    `rfid_enabled` BOOLEAN COMMENT 'Indicates whether the lane is equipped with RFID readers for automated container and vehicle identification.',
    `security_level` STRING COMMENT 'Classification of the security screening intensity applied at this lane.',
    `tos_integration_enabled` BOOLEAN COMMENT 'Indicates whether the lane is integrated with the terminal operating system for real-time transaction processing and data exchange.',
    `traffic_direction` STRING COMMENT 'Indicates the permitted direction of vehicle traffic flow through the lane.',
    `twenty_four_hour_operation` BOOLEAN COMMENT 'Indicates whether the lane operates continuously on a 24/7 basis.',
    `vehicle_category` STRING COMMENT 'Type of vehicles permitted to use this gate lane based on cargo status or vehicle configuration.',
    `weighbridge_equipped` BOOLEAN COMMENT 'Indicates whether the lane has an integrated weighbridge for vehicle and cargo weight verification.',
    `xray_scanner_equipped` BOOLEAN COMMENT 'Indicates whether the lane has X-ray scanning equipment for non-intrusive cargo inspection.',
    CONSTRAINT pk_gate_lane PRIMARY KEY(`gate_lane_id`)
) COMMENT 'Master reference table for gate_lane. Referenced by gate_lane_id.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` (
    `terminal_id` BIGINT COMMENT 'Primary key for terminal',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the organization entity that operates this terminal.',
    `port_location_id` BIGINT COMMENT 'Reference to the parent port or seaport where this terminal is located.',
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
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_yard_slot_id` FOREIGN KEY (`yard_slot_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`yard_slot`(`yard_slot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_gate_lane_id` FOREIGN KEY (`gate_lane_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`gate_lane`(`gate_lane_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_gate_appointment_id` FOREIGN KEY (`gate_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`gate_appointment`(`gate_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_gate_lane_id` FOREIGN KEY (`gate_lane_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`gate_lane`(`gate_lane_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_terminal_equipment_id` FOREIGN KEY (`terminal_equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment`(`terminal_equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_terminal_berth_allocation_id` FOREIGN KEY (`terminal_berth_allocation_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation`(`terminal_berth_allocation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_yard_slot_id` FOREIGN KEY (`yard_slot_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`yard_slot`(`yard_slot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ADD CONSTRAINT `fk_terminal_container_damage_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ADD CONSTRAINT `fk_terminal_cfs_activity_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_terminal_equipment_id` FOREIGN KEY (`terminal_equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment`(`terminal_equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_yard_slot_id` FOREIGN KEY (`yard_slot_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`yard_slot`(`yard_slot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ADD CONSTRAINT `fk_terminal_roro_activity_yard_slot_id` FOREIGN KEY (`yard_slot_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`yard_slot`(`yard_slot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ADD CONSTRAINT `fk_terminal_hazmat_declaration_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ADD CONSTRAINT `fk_terminal_hazmat_declaration_yard_slot_id` FOREIGN KEY (`yard_slot_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`yard_slot`(`yard_slot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ADD CONSTRAINT `fk_terminal_container_tariff_exception_application_container_visit_id` FOREIGN KEY (`container_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`container_visit`(`container_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ADD CONSTRAINT `fk_terminal_berth_discount_application_terminal_berth_allocation_id` FOREIGN KEY (`terminal_berth_allocation_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation`(`terminal_berth_allocation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ADD CONSTRAINT `fk_terminal_gate_lane_paired_gate_lane_id` FOREIGN KEY (`paired_gate_lane_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`gate_lane`(`gate_lane_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ADD CONSTRAINT `fk_terminal_gate_lane_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`terminal` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`terminal` SET TAGS ('dbx_domain' = 'terminal');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` SET TAGS ('dbx_subdomain' = 'yard_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `yard_block_id` SET TAGS ('dbx_business_glossary_term' = 'Yard Block Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Current Container Identifier (ID)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `demurrage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Demurrage Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `drayage_order_id` SET TAGS ('dbx_business_glossary_term' = 'Drayage Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `ohs_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Ohs Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `sanctions_screening_id` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Screening Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `storage_tariff_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Tariff Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `transport_order_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `yard_slot_id` SET TAGS ('dbx_business_glossary_term' = 'Yard Slot Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `arrival_mode` SET TAGS ('dbx_business_glossary_term' = 'Arrival Mode');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `arrival_mode` SET TAGS ('dbx_value_regex' = 'vessel|truck|rail|barge|internal');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `bol_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `booking_number` SET TAGS ('dbx_business_glossary_term' = 'Booking Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `cargo_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `cargo_type` SET TAGS ('dbx_value_regex' = 'general|reefer|hazmat|oog|empty|special');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `consignee_name` SET TAGS ('dbx_business_glossary_term' = 'Consignee Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `container_number` SET TAGS ('dbx_business_glossary_term' = 'Container Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `container_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `damage_description` SET TAGS ('dbx_business_glossary_term' = 'Damage Description');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `damage_flag` SET TAGS ('dbx_business_glossary_term' = 'Damage Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order (D/O) Number');
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
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `pol_code` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ALTER COLUMN `pol_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
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
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Clerk ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `gate_lane_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Lane ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `ohs_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Ohs Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Transport Company ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `screening_record_id` SET TAGS ('dbx_business_glossary_term' = 'Security Screening Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `shift_pattern_id` SET TAGS ('dbx_business_glossary_term' = 'Shift Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `gate_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Gate Appointment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `truck_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Truck Appointment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `anpr_capture_reference` SET TAGS ('dbx_business_glossary_term' = 'Automatic Number Plate Recognition (ANPR) Capture Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `booking_reference` SET TAGS ('dbx_business_glossary_term' = 'Booking Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `coparn_reference` SET TAGS ('dbx_business_glossary_term' = 'COPARN (Container Pre-Announcement) Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `damage_description` SET TAGS ('dbx_business_glossary_term' = 'Damage Description');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `damage_flag` SET TAGS ('dbx_business_glossary_term' = 'Damage Detected Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order (D/O) Number');
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
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `access_credential_id` SET TAGS ('dbx_business_glossary_term' = 'Access Credential Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Operator ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `gate_lane_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Lane Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `actual_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `actual_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Departure Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `appointment_date` SET TAGS ('dbx_business_glossary_term' = 'Appointment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `appointment_number` SET TAGS ('dbx_business_glossary_term' = 'Appointment Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `appointment_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `appointment_status` SET TAGS ('dbx_business_glossary_term' = 'Appointment Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `appointment_window_end` SET TAGS ('dbx_business_glossary_term' = 'Appointment Window End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `appointment_window_start` SET TAGS ('dbx_business_glossary_term' = 'Appointment Window Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `booking_reference` SET TAGS ('dbx_business_glossary_term' = 'Booking Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `coparn_message_reference` SET TAGS ('dbx_business_glossary_term' = 'Container Pre-Announcement (COPARN) Message Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ALTER COLUMN `delivery_order_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Order (D/O) Number');
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
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` SET TAGS ('dbx_subdomain' = 'equipment_handling');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `equipment_dispatch_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Dispatch ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `access_credential_id` SET TAGS ('dbx_business_glossary_term' = 'Security Clearance Credential Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `gang_id` SET TAGS ('dbx_business_glossary_term' = 'Gang Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operator ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `rail_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Rail Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `terminal_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Unit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ALTER COLUMN `thc_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Thc Schedule Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` SET TAGS ('dbx_subdomain' = 'vessel_berth');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `vessel_bay_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Bay Plan ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `edi_message_id` SET TAGS ('dbx_business_glossary_term' = 'BAPLIE (Bayplan/Stowage Plan) Message ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operation Planner ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `pilotage_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Assignment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `personnel_id` SET TAGS ('dbx_business_glossary_term' = 'Security Clearance Officer Security Personnel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `terminal_berth_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Allocation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` SET TAGS ('dbx_subdomain' = 'vessel_berth');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `terminal_berth_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Berth Allocation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Commercial Agreement ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `dos_record_id` SET TAGS ('dbx_business_glossary_term' = 'Dos Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Inspection Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `port_dues_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Port Dues Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `profit_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `terminal_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Planner ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `terminal_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `terminal_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `terminal_last_modified_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `terminal_last_modified_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `terminal_last_modified_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `wharfage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Wharfage Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `allocated_crane_count` SET TAGS ('dbx_business_glossary_term' = 'Allocated Crane Count');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `allocated_quay_length_m` SET TAGS ('dbx_business_glossary_term' = 'Allocated Quay Length (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `allocation_notes` SET TAGS ('dbx_business_glossary_term' = 'Allocation Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `allocation_number` SET TAGS ('dbx_business_glossary_term' = 'Berth Allocation Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `allocation_number` SET TAGS ('dbx_value_regex' = '^BA-[0-9]{8}-[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `allocation_reason` SET TAGS ('dbx_business_glossary_term' = 'Allocation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_business_glossary_term' = 'Allocation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_value_regex' = 'planned|confirmed|active|completed|cancelled|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `atb` SET TAGS ('dbx_business_glossary_term' = 'Actual Time of Berthing (ATB)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `atd` SET TAGS ('dbx_business_glossary_term' = 'Actual Time of Departure (ATD)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `berth_draft_restriction_m` SET TAGS ('dbx_business_glossary_term' = 'Berth Draft Restriction (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `berth_productivity_target_mph` SET TAGS ('dbx_business_glossary_term' = 'Berth Productivity Target (Moves Per Hour)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `berth_window_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Berth Window Duration (Hours)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `berth_window_end` SET TAGS ('dbx_business_glossary_term' = 'Berth Window End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `berth_window_start` SET TAGS ('dbx_business_glossary_term' = 'Berth Window Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `cancelled_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `cargo_operation_type` SET TAGS ('dbx_business_glossary_term' = 'Cargo Operation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `cargo_operation_type` SET TAGS ('dbx_value_regex' = 'LoLo|RoRo|mixed|bulk|general');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `confirmed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Confirmation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `crane_allocation_type` SET TAGS ('dbx_business_glossary_term' = 'Crane Allocation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `crane_allocation_type` SET TAGS ('dbx_value_regex' = 'STS|QC|MHC|mixed');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `etb` SET TAGS ('dbx_business_glossary_term' = 'Estimated Time of Berthing (ETB)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `etd` SET TAGS ('dbx_business_glossary_term' = 'Estimated Time of Departure (ETD)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `expected_container_moves` SET TAGS ('dbx_business_glossary_term' = 'Expected Container Moves');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `expected_teu_volume` SET TAGS ('dbx_business_glossary_term' = 'Expected Twenty-foot Equivalent Unit (TEU) Volume');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `imdg_cargo_flag` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Cargo Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `mooring_gang_count` SET TAGS ('dbx_business_glossary_term' = 'Mooring Gang Count');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `pilotage_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Allocation Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'critical|high|normal|low');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `sla_turnaround_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Turnaround Time (Hours)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `special_handling_requirements` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `tide_window_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Tide Window Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `towage_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Towage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `vessel_draft_m` SET TAGS ('dbx_business_glossary_term' = 'Vessel Draft (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `vessel_loa_m` SET TAGS ('dbx_business_glossary_term' = 'Vessel Length Overall (LOA) in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ALTER COLUMN `weather_restriction_flag` SET TAGS ('dbx_business_glossary_term' = 'Weather Restriction Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` SET TAGS ('dbx_subdomain' = 'yard_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `reefer_monitoring_id` SET TAGS ('dbx_business_glossary_term' = 'Reefer Monitoring Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Technician ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `technician_inspection_reference` SET TAGS ('dbx_business_glossary_term' = 'Technician Inspection Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `temperature_deviation` SET TAGS ('dbx_business_glossary_term' = 'Temperature Deviation');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `temperature_unit` SET TAGS ('dbx_business_glossary_term' = 'Temperature Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `temperature_unit` SET TAGS ('dbx_value_regex' = 'celsius|fahrenheit');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `ventilation_rate` SET TAGS ('dbx_business_glossary_term' = 'Ventilation Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `ventilation_setting` SET TAGS ('dbx_business_glossary_term' = 'Ventilation Setting');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ALTER COLUMN `ventilation_setting` SET TAGS ('dbx_value_regex' = 'closed|open|controlled');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` SET TAGS ('dbx_subdomain' = 'yard_operations');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `container_damage_id` SET TAGS ('dbx_business_glossary_term' = 'Container Damage ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `ohs_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Ohs Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Container Owner ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Repair Vendor Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `surveyor_id` SET TAGS ('dbx_business_glossary_term' = 'Surveyor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `trade_document_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Document Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `actual_repair_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Repair Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `actual_repair_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `cargo_damage_indicator` SET TAGS ('dbx_business_glossary_term' = 'Cargo Damage Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `cargo_status_at_discovery` SET TAGS ('dbx_business_glossary_term' = 'Cargo Status at Discovery');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `cargo_status_at_discovery` SET TAGS ('dbx_value_regex' = 'empty|laden|unknown');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `claim_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Claim Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `container_size_type` SET TAGS ('dbx_business_glossary_term' = 'Container Size Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `container_size_type` SET TAGS ('dbx_value_regex' = '^[0-9]{2}[A-Z]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `corrective_action_taken` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Taken');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `damage_description` SET TAGS ('dbx_business_glossary_term' = 'Damage Description');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `damage_location_code` SET TAGS ('dbx_business_glossary_term' = 'Damage Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `damage_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `damage_report_number` SET TAGS ('dbx_business_glossary_term' = 'Damage Report Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `damage_report_number` SET TAGS ('dbx_value_regex' = '^DMG-[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `damage_report_status` SET TAGS ('dbx_business_glossary_term' = 'Damage Report Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `damage_severity` SET TAGS ('dbx_business_glossary_term' = 'Damage Severity');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `damage_severity` SET TAGS ('dbx_value_regex' = 'minor|moderate|major|total_loss');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `damage_type` SET TAGS ('dbx_business_glossary_term' = 'Damage Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `discovery_location` SET TAGS ('dbx_business_glossary_term' = 'Discovery Location');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `discovery_point` SET TAGS ('dbx_business_glossary_term' = 'Discovery Point');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `discovery_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Discovery Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `edi_message_reference` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Message Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `environmental_incident_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Incident Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `equipment_involved` SET TAGS ('dbx_business_glossary_term' = 'Equipment Involved');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `estimated_repair_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Repair Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `estimated_repair_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `liability_party` SET TAGS ('dbx_business_glossary_term' = 'Liability Party');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `liability_party` SET TAGS ('dbx_value_regex' = 'terminal|shipping_line|stevedore|trucker|unknown|under_investigation');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `notification_sent_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Notification Sent Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `photographic_evidence_reference` SET TAGS ('dbx_business_glossary_term' = 'Photographic Evidence Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `repair_authorization_number` SET TAGS ('dbx_business_glossary_term' = 'Repair Authorization Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `repair_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Repair Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `repair_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Repair Cost Currency');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `repair_cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `repair_recommendation` SET TAGS ('dbx_business_glossary_term' = 'Repair Recommendation');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `repair_recommendation` SET TAGS ('dbx_value_regex' = 'repair|scrap|monitor|no_action_required');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `root_cause_analysis` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Analysis');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `safety_incident_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Incident Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ALTER COLUMN `survey_date` SET TAGS ('dbx_business_glossary_term' = 'Survey Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` SET TAGS ('dbx_subdomain' = 'commercial_services');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `cfs_activity_id` SET TAGS ('dbx_business_glossary_term' = 'Container Freight Station (CFS) Activity ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Item Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `packaging_type_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Container Freight Station (CFS) Operator ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `shift_pattern_id` SET TAGS ('dbx_business_glossary_term' = 'Shift Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `tertiary_cfs_consignee_port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Consignee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `activity_status` SET TAGS ('dbx_business_glossary_term' = 'CFS Activity Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `activity_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|suspended|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `activity_type` SET TAGS ('dbx_business_glossary_term' = 'CFS Activity Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `activity_type` SET TAGS ('dbx_value_regex' = 'stuffing|stripping|consolidation|deconsolidation|inspection|repacking');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `actual_start_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `cargo_description` SET TAGS ('dbx_business_glossary_term' = 'Cargo Description');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `cargo_volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Cargo Volume in Cubic Meters (CBM)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `cargo_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Cargo Weight in Kilograms (KG)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `cfs_job_number` SET TAGS ('dbx_business_glossary_term' = 'Container Freight Station (CFS) Job Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `cfs_job_number` SET TAGS ('dbx_value_regex' = '^CFS[0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `cfs_location_code` SET TAGS ('dbx_business_glossary_term' = 'Container Freight Station (CFS) Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `cfs_location_code` SET TAGS ('dbx_value_regex' = '^CFS[A-Z0-9]{2,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `completion_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Completion Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `consignee_reference` SET TAGS ('dbx_business_glossary_term' = 'Consignee Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `damage_description` SET TAGS ('dbx_business_glossary_term' = 'Damage Description');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `damage_reported_flag` SET TAGS ('dbx_business_glossary_term' = 'Damage Reported Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `dangerous_goods_flag` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Duration in Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `handling_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Handling Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `last_modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `number_of_packages` SET TAGS ('dbx_business_glossary_term' = 'Number of Packages');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `scheduled_start_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `seal_intact_flag` SET TAGS ('dbx_business_glossary_term' = 'Seal Intact Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `seal_number` SET TAGS ('dbx_business_glossary_term' = 'Container Seal Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `seal_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `shipper_reference` SET TAGS ('dbx_business_glossary_term' = 'Shipper Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `target_temperature_celsius` SET TAGS ('dbx_business_glossary_term' = 'Target Temperature in Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `temperature_controlled_flag` SET TAGS ('dbx_business_glossary_term' = 'Temperature Controlled Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` SET TAGS ('dbx_subdomain' = 'commercial_services');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `terminal_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Service Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `access_credential_id` SET TAGS ('dbx_business_glossary_term' = 'Service Provider Credential Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `booking_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Booking Service Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `customs_hold_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Hold Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Operator ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `item_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Item Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `material_master_id` SET TAGS ('dbx_business_glossary_term' = 'Material Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `permit_to_work_id` SET TAGS ('dbx_business_glossary_term' = 'Permit To Work Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `service_code_id` SET TAGS ('dbx_business_glossary_term' = 'Service Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `shift_pattern_id` SET TAGS ('dbx_business_glossary_term' = 'Shift Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `terminal_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Equipment ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `yard_slot_id` SET TAGS ('dbx_business_glossary_term' = 'Yard Slot Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `actual_completion_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Completion Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `approval_required` SET TAGS ('dbx_business_glossary_term' = 'Approval Required');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|not_required');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `cancellation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `cancelled_by` SET TAGS ('dbx_business_glossary_term' = 'Cancelled By');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Charge Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `charge_currency` SET TAGS ('dbx_business_glossary_term' = 'Charge Currency');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `charge_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `charge_reference` SET TAGS ('dbx_business_glossary_term' = 'Charge Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `completion_date` SET TAGS ('dbx_business_glossary_term' = 'Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `completion_remarks` SET TAGS ('dbx_business_glossary_term' = 'Completion Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `customer_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `estimated_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Estimated Duration Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'urgent|high|normal|low');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `quality_check_performed` SET TAGS ('dbx_business_glossary_term' = 'Quality Check Performed');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `quality_check_result` SET TAGS ('dbx_business_glossary_term' = 'Quality Check Result');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `quality_check_result` SET TAGS ('dbx_value_regex' = 'passed|failed|conditional|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `requested_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `requested_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Requested Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `scheduled_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `scheduled_end_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `scheduled_start_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `service_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Service Duration Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `service_location_type` SET TAGS ('dbx_business_glossary_term' = 'Service Location Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `service_location_type` SET TAGS ('dbx_value_regex' = 'yard|gate|berth|cfs|workshop|inspection_area');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `service_notes` SET TAGS ('dbx_business_glossary_term' = 'Service Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `service_order_number` SET TAGS ('dbx_business_glossary_term' = 'Service Order Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `service_order_number` SET TAGS ('dbx_value_regex' = '^TSO-[0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `service_status` SET TAGS ('dbx_business_glossary_term' = 'Service Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `sla_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `sla_target_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Target Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ALTER COLUMN `work_order_reference` SET TAGS ('dbx_business_glossary_term' = 'Work Order Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` SET TAGS ('dbx_subdomain' = 'equipment_handling');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `terminal_equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Equipment Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `material_master_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Spare Part Material Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Contract Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `acquisition_date` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `automation_level` SET TAGS ('dbx_business_glossary_term' = 'Automation Level');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `automation_level` SET TAGS ('dbx_value_regex' = 'manual|semi_automated|fully_automated|remote_controlled');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `current_yard_zone` SET TAGS ('dbx_business_glossary_term' = 'Current Yard Zone Assignment');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_value_regex' = 'straight_line|declining_balance|units_of_production|sum_of_years_digits');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `emission_standard` SET TAGS ('dbx_business_glossary_term' = 'Emission Standard Compliance');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `equipment_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `equipment_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `fuel_power_type` SET TAGS ('dbx_business_glossary_term' = 'Fuel or Power Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `fuel_power_type` SET TAGS ('dbx_value_regex' = 'diesel|electric|hybrid_diesel_electric|LNG|battery_electric|hydrogen');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `gps_tracking_enabled` SET TAGS ('dbx_business_glossary_term' = 'Global Positioning System (GPS) Tracking Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `home_terminal` SET TAGS ('dbx_business_glossary_term' = 'Home Terminal');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `imdg_certified` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Code Certified');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `insurance_policy_reference` SET TAGS ('dbx_business_glossary_term' = 'Insurance Policy Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `insurance_policy_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `last_major_overhaul_date` SET TAGS ('dbx_business_glossary_term' = 'Last Major Overhaul Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `maximo_asset_reference` SET TAGS ('dbx_business_glossary_term' = 'Maximo Asset Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `maximum_lift_height_metres` SET TAGS ('dbx_business_glossary_term' = 'Maximum Lift Height in Metres');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `maximum_reach_metres` SET TAGS ('dbx_business_glossary_term' = 'Maximum Reach in Metres');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `next_scheduled_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `noise_level_db` SET TAGS ('dbx_business_glossary_term' = 'Noise Level in Decibels (dB)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `operating_hours_since_last_service` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours Since Last Service');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `operating_hours_total` SET TAGS ('dbx_business_glossary_term' = 'Total Operating Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'active|under_maintenance|standby|decommissioned|out_of_service|awaiting_repair');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `operator_certification_required` SET TAGS ('dbx_business_glossary_term' = 'Operator Certification Required');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `ownership_type` SET TAGS ('dbx_business_glossary_term' = 'Ownership Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `ownership_type` SET TAGS ('dbx_value_regex' = 'owned|leased|rented|contractor_provided');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `reefer_monitoring_capable` SET TAGS ('dbx_business_glossary_term' = 'Reefer Monitoring Capable');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `replacement_value` SET TAGS ('dbx_business_glossary_term' = 'Replacement Value');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `replacement_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `rfid_tag_code` SET TAGS ('dbx_business_glossary_term' = 'Radio Frequency Identification (RFID) Tag Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Serial Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `spreader_type` SET TAGS ('dbx_business_glossary_term' = 'Spreader Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `spreader_type` SET TAGS ('dbx_value_regex' = 'fixed_20ft|fixed_40ft|telescopic_20_40ft|tandem|auto_twist_lock|manual');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `swl_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Safe Working Load (SWL) in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `tandem_lift_capable` SET TAGS ('dbx_business_glossary_term' = 'Tandem Lift Capable');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `telematics_system_code` SET TAGS ('dbx_business_glossary_term' = 'Telematics System Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `twin_lift_capable` SET TAGS ('dbx_business_glossary_term' = 'Twin Lift Capable');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ALTER COLUMN `year_of_manufacture` SET TAGS ('dbx_business_glossary_term' = 'Year of Manufacture');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` SET TAGS ('dbx_subdomain' = 'equipment_handling');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `roro_activity_id` SET TAGS ('dbx_business_glossary_term' = 'Roll-on Roll-off (RoRo) Activity ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Driver or Operator ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `ohs_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Ohs Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `call_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Visit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `screening_record_id` SET TAGS ('dbx_business_glossary_term' = 'Security Screening Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `shift_pattern_id` SET TAGS ('dbx_business_glossary_term' = 'Shift ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `wharfage_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Wharfage Schedule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `yard_slot_id` SET TAGS ('dbx_business_glossary_term' = 'Yard Slot Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `activity_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Activity End Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `activity_number` SET TAGS ('dbx_business_glossary_term' = 'RoRo Activity Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `activity_number` SET TAGS ('dbx_value_regex' = '^RORO-[A-Z0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `activity_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Activity Start Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `activity_status` SET TAGS ('dbx_business_glossary_term' = 'Activity Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `activity_status` SET TAGS ('dbx_value_regex' = 'planned|in-progress|completed|cancelled|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `activity_type` SET TAGS ('dbx_business_glossary_term' = 'RoRo Activity Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `activity_type` SET TAGS ('dbx_value_regex' = 'roll-on|roll-off|lashing|unlashing|inspection|repositioning');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `booking_reference` SET TAGS ('dbx_business_glossary_term' = 'Booking Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `cargo_condition` SET TAGS ('dbx_business_glossary_term' = 'Cargo Condition');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `cargo_condition` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor|damaged');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `customs_status` SET TAGS ('dbx_business_glossary_term' = 'Customs Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `customs_status` SET TAGS ('dbx_value_regex' = 'cleared|pending|held|bonded|in-transit');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `damage_description` SET TAGS ('dbx_business_glossary_term' = 'Damage Description');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `damage_detected_flag` SET TAGS ('dbx_business_glossary_term' = 'Damage Detected Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `damage_inspection_flag` SET TAGS ('dbx_business_glossary_term' = 'Damage Inspection Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `dangerous_goods_flag` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `deck_position` SET TAGS ('dbx_business_glossary_term' = 'Deck Position');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Duration in Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `equipment_used` SET TAGS ('dbx_business_glossary_term' = 'Equipment Used');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `final_destination` SET TAGS ('dbx_business_glossary_term' = 'Final Destination');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `handling_instruction` SET TAGS ('dbx_business_glossary_term' = 'Handling Instruction');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `height_meters` SET TAGS ('dbx_business_glossary_term' = 'Height in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `lashing_equipment_type` SET TAGS ('dbx_business_glossary_term' = 'Lashing Equipment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `lashing_equipment_type` SET TAGS ('dbx_value_regex' = 'chain|webbing|wire-rope|turnbuckle|twist-lock|combination');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `lashing_point_count` SET TAGS ('dbx_business_glossary_term' = 'Lashing Point Count');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `length_meters` SET TAGS ('dbx_business_glossary_term' = 'Length in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `port_of_discharge` SET TAGS ('dbx_business_glossary_term' = 'Port of Discharge (POD)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `port_of_discharge` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `port_of_loading` SET TAGS ('dbx_business_glossary_term' = 'Port of Loading (POL)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `port_of_loading` SET TAGS ('dbx_value_regex' = '^[A-Z]{5}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `ramp_identifier` SET TAGS ('dbx_business_glossary_term' = 'Ramp Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `vehicle_make` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Make');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `vehicle_model` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `vehicle_unit_identifier` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Unit Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `weight_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Weight in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ALTER COLUMN `width_meters` SET TAGS ('dbx_business_glossary_term' = 'Width in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` SET TAGS ('dbx_subdomain' = 'commercial_services');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `hazmat_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Declaration ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `cargo_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Certifying Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `hs_code_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hs Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `container_id` SET TAGS ('dbx_business_glossary_term' = 'Container ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Visit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `hazard_register_id` SET TAGS ('dbx_business_glossary_term' = 'Hazard Register Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Imdg Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `surcharge_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Rule Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `threat_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Threat Assessment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `trade_restriction_id` SET TAGS ('dbx_business_glossary_term' = 'Trade Restriction Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `yard_slot_id` SET TAGS ('dbx_business_glossary_term' = 'Yard Slot Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `acceptance_decision_by` SET TAGS ('dbx_business_glossary_term' = 'Acceptance Decision By');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `acceptance_decision_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Acceptance Decision Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `bol_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `competent_authority_approval_reference` SET TAGS ('dbx_business_glossary_term' = 'Competent Authority Approval Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `competent_authority_notification_reference` SET TAGS ('dbx_business_glossary_term' = 'Competent Authority Notification Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `consignee_name` SET TAGS ('dbx_business_glossary_term' = 'Consignee Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `dgd_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Declaration (DGD) Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `dgd_submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Declaration (DGD) Submission Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `emergency_contact_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `ems_number` SET TAGS ('dbx_business_glossary_term' = 'Emergency Schedule (EMS) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `ems_number` SET TAGS ('dbx_value_regex' = '^F-[A-Z]$|^S-[A-Z]$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `excepted_quantity_flag` SET TAGS ('dbx_business_glossary_term' = 'Excepted Quantity (EQ) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `flashpoint_celsius` SET TAGS ('dbx_business_glossary_term' = 'Flashpoint (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight (Kilograms)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `imdg_class` SET TAGS ('dbx_value_regex' = '1|1.1|1.2|1.3|1.4|1.5|1.6|2.1|2.2|2.3|3|4.1|4.2|4.3|5.1|5.2|6.1|6.2|7|8|9');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `inspection_completed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Inspection Completed Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `inspection_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Inspection Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `inspector_name` SET TAGS ('dbx_business_glossary_term' = 'Inspector Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `limited_quantity_flag` SET TAGS ('dbx_business_glossary_term' = 'Limited Quantity (LQ) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `marine_pollutant_flag` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollutant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `mfag_table_number` SET TAGS ('dbx_business_glossary_term' = 'Medical First Aid Guide (MFAG) Table Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `net_quantity` SET TAGS ('dbx_business_glossary_term' = 'Net Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `net_quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Net Quantity Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `net_quantity_unit` SET TAGS ('dbx_value_regex' = 'kg|L|m3');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `packing_group` SET TAGS ('dbx_business_glossary_term' = 'Packing Group (PG)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `packing_group` SET TAGS ('dbx_value_regex' = 'I|II|III');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `placarding_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Placarding Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `proper_shipping_name` SET TAGS ('dbx_business_glossary_term' = 'Proper Shipping Name (PSN)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `segregation_distance_meters` SET TAGS ('dbx_business_glossary_term' = 'Segregation Distance (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `segregation_group` SET TAGS ('dbx_business_glossary_term' = 'Segregation Group');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `shipper_name` SET TAGS ('dbx_business_glossary_term' = 'Shipper Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `special_stowage_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Stowage Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `terminal_acceptance_status` SET TAGS ('dbx_business_glossary_term' = 'Terminal Acceptance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `terminal_acceptance_status` SET TAGS ('dbx_value_regex' = 'pending|accepted|rejected|conditional|withdrawn');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `vessel_name` SET TAGS ('dbx_business_glossary_term' = 'Vessel Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ALTER COLUMN `voyage_number` SET TAGS ('dbx_business_glossary_term' = 'Voyage Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` SET TAGS ('dbx_subdomain' = 'commercial_services');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` SET TAGS ('dbx_association_edges' = 'terminal.container_visit,tariff.tariff_exception');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `container_tariff_exception_application_id` SET TAGS ('dbx_business_glossary_term' = 'Container Tariff Exception Application ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `container_visit_id` SET TAGS ('dbx_business_glossary_term' = 'Container Tariff Exception Application - Container Visit Id');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Applied By User');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `exception_id` SET TAGS ('dbx_business_glossary_term' = 'Container Tariff Exception Application - Tariff Exception Id');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `application_notes` SET TAGS ('dbx_business_glossary_term' = 'Exception Application Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `application_status` SET TAGS ('dbx_business_glossary_term' = 'Exception Application Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `application_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Exception Application Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Applied Discount Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Exception Application Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `exception_rate_amount` SET TAGS ('dbx_business_glossary_term' = 'Applied Exception Rate Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Exception Application Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `free_days_granted` SET TAGS ('dbx_business_glossary_term' = 'Free Days Granted');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `revenue_impact_amount` SET TAGS ('dbx_business_glossary_term' = 'Revenue Impact Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ALTER COLUMN `waiver_amount` SET TAGS ('dbx_business_glossary_term' = 'Applied Waiver Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` SET TAGS ('dbx_subdomain' = 'commercial_services');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` SET TAGS ('dbx_association_edges' = 'terminal.berth_allocation,tariff.discount_scheme');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `berth_discount_application_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Discount Application ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `discount_scheme_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Discount Application - Discount Scheme Id');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `terminal_berth_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Discount Application - Terminal Berth Allocation Id');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `application_reason` SET TAGS ('dbx_business_glossary_term' = 'Application Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `application_status` SET TAGS ('dbx_business_glossary_term' = 'Application Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `applied_discount_value` SET TAGS ('dbx_business_glossary_term' = 'Applied Discount Value');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `approval_authority_name` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `discount_amount_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `effective_from_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Effective From Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `effective_to_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Effective To Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `threshold_met_flag` SET TAGS ('dbx_business_glossary_term' = 'Threshold Met Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ALTER COLUMN `volume_commitment_teu` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment TEU');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` SET TAGS ('dbx_subdomain' = 'gate_management');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `gate_lane_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Lane Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `paired_gate_lane_id` SET TAGS ('dbx_business_glossary_term' = 'Paired Gate Lane Id');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `paired_gate_lane_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Id');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Id');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `appointment_required` SET TAGS ('dbx_business_glossary_term' = 'Appointment Required');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `automation_level` SET TAGS ('dbx_business_glossary_term' = 'Automation Level');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `average_processing_time_seconds` SET TAGS ('dbx_business_glossary_term' = 'Average Processing Time Seconds');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `booth_number` SET TAGS ('dbx_business_glossary_term' = 'Booth Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `cargo_type_restriction` SET TAGS ('dbx_business_glossary_term' = 'Cargo Type Restriction');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `customs_clearance_enabled` SET TAGS ('dbx_business_glossary_term' = 'Customs Clearance Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `geo_coordinates_latitude` SET TAGS ('dbx_business_glossary_term' = 'Geo Coordinates Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `geo_coordinates_latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `geo_coordinates_latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `geo_coordinates_longitude` SET TAGS ('dbx_business_glossary_term' = 'Geo Coordinates Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `geo_coordinates_longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `geo_coordinates_longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `inspection_lane` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lane');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `lane_length_meters` SET TAGS ('dbx_business_glossary_term' = 'Lane Length Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `lane_name` SET TAGS ('dbx_business_glossary_term' = 'Lane Name');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `lane_number` SET TAGS ('dbx_business_glossary_term' = 'Lane Number');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `lane_type` SET TAGS ('dbx_business_glossary_term' = 'Lane Type');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `lane_width_meters` SET TAGS ('dbx_business_glossary_term' = 'Lane Width Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `maximum_vehicle_height_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Vehicle Height Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `next_scheduled_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `ocr_enabled` SET TAGS ('dbx_business_glossary_term' = 'Ocr Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `operating_hours_end` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours End');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `operating_hours_start` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours Start');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `priority_lane` SET TAGS ('dbx_business_glossary_term' = 'Priority Lane');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `processing_capacity_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Processing Capacity Per Hour');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `radiation_scanner_equipped` SET TAGS ('dbx_business_glossary_term' = 'Radiation Scanner Equipped');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `rfid_enabled` SET TAGS ('dbx_business_glossary_term' = 'Rfid Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `security_level` SET TAGS ('dbx_business_glossary_term' = 'Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `tos_integration_enabled` SET TAGS ('dbx_business_glossary_term' = 'Tos Integration Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `traffic_direction` SET TAGS ('dbx_business_glossary_term' = 'Traffic Direction');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `twenty_four_hour_operation` SET TAGS ('dbx_business_glossary_term' = 'Twenty Four Hour Operation');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `vehicle_category` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Category');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `weighbridge_equipped` SET TAGS ('dbx_business_glossary_term' = 'Weighbridge Equipped');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ALTER COLUMN `xray_scanner_equipped` SET TAGS ('dbx_business_glossary_term' = 'Xray Scanner Equipped');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` SET TAGS ('dbx_subdomain' = 'commercial_services');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Id');
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id');
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
