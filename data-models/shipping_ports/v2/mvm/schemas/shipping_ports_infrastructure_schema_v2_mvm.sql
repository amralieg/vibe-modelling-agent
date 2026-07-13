-- Schema for Domain: infrastructure | Business: Shipping_Ports | Version: v2_mvm
-- Generated on: 2026-07-13 10:24:17

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`infrastructure` COMMENT 'Owns port physical infrastructure data including berths, quay walls, wharves, fender systems, navigational aids, dredging records, channel depth surveys, warehouses, and port layout plans. Supports AVEVA Marine Engineering integration, CAPEX infrastructure projects, capacity planning, and port expansion initiatives. SSOT for port infrastructure and fixed facilities.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` (
    `berth_id` BIGINT COMMENT 'Unique identifier for the berth. Primary key for the berth master record.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Berths are designated for specific commodity types (bulk grain, liquid bulk, containers). Port planners use this designation for berth allocation, IMDG compliance enforcement, and vessel acceptance de',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Berths are designed for specific vessel types (container, tanker, bulk, etc.). Currently berth has design_vessel_type as a string. Adding FK to masterdata.vessel_type enables proper vessel-berth compa',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Berths are ISPS-regulated port facilities requiring mandatory security records per ISPS Code Chapter XI-2 SOLAS. Port security officers track Declaration of Security (DoS) and Port Facility Security P',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Berths are leased/assigned to terminal operators or shipping lines under concession agreements. Essential for berth allocation management, lease billing, access control, and operational planning. Role',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: A berth is a physical docking position belonging to a specific port. berth already has port_location_id (cross-domain to masterdata) and terminal_zone_id (in-domain), but lacks a direct in-domain FK t',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Berths are physical locations within port geography. Essential for vessel routing, operational planning, spatial queries, and linking berth infrastructure to port master location data for navigation a',
    `quay_wall_id` BIGINT COMMENT 'Foreign key linking to infrastructure.quay_wall. Business justification: Berths are physically constructed on quay walls. The existing quay_wall_reference (STRING) is a business code that should be replaced with a proper FK to quay_wall.quay_wall_id. This enables joining t',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Berths are located within terminal zones for operational and security management. The existing terminal_area_code (STRING) should be replaced with FK to terminal_zone.terminal_zone_id. This enables jo',
    `annual_throughput_capacity_teu` STRING COMMENT 'The estimated annual container throughput capacity of this berth measured in TEU (Twenty-foot Equivalent Unit). Applicable only to container berths. Used for capacity planning, port expansion initiatives, and commercial planning. Null for non-container berths.',
    `aveva_reference_code` STRING COMMENT 'The unique identifier for this berth in the AVEVA Marine Engineering system. Used for integration with port design, infrastructure planning, and engineering documentation. Links berth master data to detailed engineering models and drawings.',
    `berth_number` STRING COMMENT 'The official berth number or code assigned by the port authority. This is the externally-known identifier used in vessel planning, NAVIS N4, TOPS Expert TOS, and port documentation.',
    `berth_type` STRING COMMENT 'Classification of the berth based on the primary cargo or vessel type it serves. Container berths handle containerized cargo, bulk berths handle dry or liquid bulk commodities, RoRo (Roll-on Roll-off) berths serve vehicle carriers, tanker berths handle liquid cargo vessels, and cruise berths accommodate passenger vessels.. Valid values are `container|bulk|general_cargo|roro|tanker|cruise`',
    `bollard_count` STRING COMMENT 'The total number of mooring bollards installed along this berth. Bollards are fixed posts to which vessel mooring lines are secured. The count and spacing of bollards determine the mooring capacity and configuration options.',
    `bollard_swl_tonnes` DECIMAL(18,2) COMMENT 'The Safe Working Load (SWL) rating of the mooring bollards at this berth, measured in metric tonnes. SWL represents the maximum load that can be safely applied to a bollard during normal mooring operations. All bollards at a berth typically share the same SWL rating.',
    `cfs_proximity_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this berth has direct or immediate proximity to a CFS (Container Freight Station) for LCL (Less than Container Load) cargo consolidation and deconsolidation operations.',
    `commissioning_date` DATE COMMENT 'The date when this berth was officially commissioned and became operational for vessel berthing. Used for asset lifecycle tracking, depreciation calculations, and capacity planning analysis.',
    `fender_condition` STRING COMMENT 'The current physical condition of the fender system based on the most recent inspection. Condition ratings range from excellent (new or like-new) to critical (immediate replacement required). Sourced from inspection records in Maximo Asset Management.. Valid values are `excellent|good|fair|poor|critical`',
    `fender_energy_absorption_kj` DECIMAL(18,2) COMMENT 'The total energy absorption capacity of the fender system, measured in kilojoules (kJ). This represents the maximum kinetic energy that the fender system can safely absorb during vessel berthing without damage.',
    `fender_reaction_force_kn` DECIMAL(18,2) COMMENT 'The maximum reaction force that the fender system can exert on a berthing vessel, measured in kilonewtons (kN). This is a critical safety parameter for vessel berthing operations and is used in vessel planning to ensure compatibility.',
    `fender_system_type` STRING COMMENT 'The type of fender system installed at this berth. Fenders absorb the kinetic energy of berthing vessels and protect both the vessel and the quay wall structure. Common types include pneumatic (air-filled rubber), foam-filled, buckling (energy-absorbing steel), cylindrical, cone, cell, arch, and unit fenders. [ENUM-REF-CANDIDATE: pneumatic|foam_filled|buckling|cylindrical|cone|cell|arch|unit — 8 candidates stripped; promote to reference product]',
    `isps_compliant_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this berth meets ISPS (International Ship and Port Facility Security) Code requirements. ISPS compliance is mandatory for berths handling international vessels and includes security fencing, access control, surveillance, and lighting.',
    `last_dredging_date` DATE COMMENT 'The date of the most recent dredging operation to maintain the required water depth alongside this berth. Dredging is performed periodically to remove sediment accumulation and maintain draft capacity. Sourced from dredging records.',
    `last_inspection_date` DATE COMMENT 'The date of the most recent comprehensive structural and equipment inspection of this berth. Inspections cover quay wall integrity, fender condition, mooring equipment, and safety systems. Sourced from Maximo Asset Management inspection records.',
    `latitude` DECIMAL(18,2) COMMENT 'The geographic latitude coordinate of the berth center point in decimal degrees. Used for vessel navigation, VTS (Vessel Traffic Service) integration, and GIS-based port layout planning in AVEVA Marine Engineering.',
    `length_m` DECIMAL(18,2) COMMENT 'The total usable length of the berth measured in meters along the quay wall. This is the maximum continuous length available for vessel mooring and determines the LOA (Length Overall) capacity.',
    `loa_capacity_m` DECIMAL(18,2) COMMENT 'The maximum Length Overall (LOA) of a vessel that can be safely accommodated at this berth, measured in meters. This is a critical constraint for vessel planning and berth allocation in NAVIS N4 and TOPS Expert TOS.',
    `longitude` DECIMAL(18,2) COMMENT 'The geographic longitude coordinate of the berth center point in decimal degrees. Used for vessel navigation, VTS (Vessel Traffic Service) integration, and GIS-based port layout planning in AVEVA Marine Engineering.',
    `max_draft_m` DECIMAL(18,2) COMMENT 'The maximum vessel draft (depth of the vessel below the waterline) that can be safely accommodated at this berth, measured in meters. This is constrained by the water depth alongside the berth and channel depth.',
    `max_dwt_tonnes` DECIMAL(18,2) COMMENT 'The maximum Deadweight Tonnage (DWT) of a vessel that can be accommodated at this berth, measured in metric tonnes. DWT represents the total weight a vessel can safely carry including cargo, fuel, crew, and provisions.',
    `mooring_fitting_types` STRING COMMENT 'Comma-separated list of mooring fitting types installed at this berth beyond bollards, such as hooks, rings, cleats, or quick-release hooks. Different vessel types and mooring configurations require different fitting types.',
    `berth_name` STRING COMMENT 'The common name or designation of the berth, often referencing location or purpose (e.g., Container Terminal North Berth 1, Bulk Cargo Berth A).',
    `next_maintenance_date` DATE COMMENT 'The scheduled date for the next planned preventive maintenance activity for this berth. Preventive maintenance includes fender replacement, bollard inspection, quay wall repairs, and equipment servicing. Sourced from Maximo Asset Management maintenance plans.',
    `operational_status` STRING COMMENT 'Current operational state of the berth. Operational berths are available for vessel scheduling, under_maintenance berths are temporarily unavailable, out_of_service berths are closed for extended periods, planned berths are under construction, and decommissioned berths are permanently retired.. Valid values are `operational|under_maintenance|out_of_service|planned|decommissioned`',
    `rail_connection_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this berth has direct rail connection for intermodal cargo transfer. Rail connectivity is critical for inland container depots (ICD) and bulk cargo operations.',
    `record_created_timestamp` TIMESTAMP COMMENT 'The timestamp when this berth record was first created in the system. Used for data lineage, audit trails, and record lifecycle tracking.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this berth record was last modified. Updated whenever any attribute value changes. Used for change tracking, data synchronization, and audit purposes.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, special conditions, operational constraints, or historical information about this berth that do not fit into structured fields. Used by port operations and planning teams.',
    `shore_crane_count` STRING COMMENT 'The number of shore-based cranes (STS - Ship-to-Shore cranes, QC - Quay Cranes, or MHC - Mobile Harbour Cranes) assigned to or available at this berth for cargo handling operations. Critical for container terminal berths and determines throughput capacity.',
    `shore_power_available_flag` BOOLEAN COMMENT 'Boolean flag indicating whether shore power (cold ironing) is available at this berth. Shore power allows vessels to shut down auxiliary engines while berthed, reducing emissions and noise. Increasingly required for environmental compliance.',
    `shore_power_capacity_kw` DECIMAL(18,2) COMMENT 'The total electrical power capacity available for shore power connection at this berth, measured in kilowatts (kW). Null if shore power is not available. Typical container vessel shore power requirements range from 1,000 to 10,000 kW.',
    `tidal_constraint_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this berth has operational constraints due to tidal conditions. True indicates that vessel movements (arrival, departure, or cargo operations) are restricted to specific tidal windows.',
    `tidal_range_m` DECIMAL(18,2) COMMENT 'The average tidal range (difference between high tide and low tide) at this berth location, measured in meters. Tidal constraints impact vessel scheduling, particularly for vessels with drafts close to the maximum depth.',
    `warehouse_proximity_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this berth has direct or immediate proximity to covered warehouse facilities. Important for general cargo and break-bulk operations requiring weather-protected storage.',
    `water_depth_alongside_m` DECIMAL(18,2) COMMENT 'The measured water depth alongside the berth at chart datum, measured in meters. This depth is maintained through regular dredging operations and determines the maximum draft capacity. Sourced from channel depth surveys and dredging records.',
    CONSTRAINT pk_berth PRIMARY KEY(`berth_id`)
) COMMENT 'Master record for each berth at the port, capturing physical specifications including berth number, name, location, quay wall reference, LOA capacity, maximum DWT, maximum draft, water depth alongside, berth length, berth type (container, bulk, RoRo, general cargo, tanker), operational status, fender system specifications (type, reaction force, energy absorption, condition), mooring fitting inventory (bollard count, SWL ratings, fitting types), tidal constraints, and AVEVA Marine Engineering integration reference. SSOT for berth identity, physical characteristics, and associated mooring/fendering infrastructure used by vessel planning, NAVIS N4, and TOPS Expert TOS.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` (
    `quay_wall_id` BIGINT COMMENT 'Unique identifier for the quay wall structure. Primary key for the quay wall master record.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Quay walls are structurally engineered for specific vessel types (fender energy, bollard SWL, design load). Port structural engineers use this for vessel acceptance certification and maintenance plann',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: Quay walls are leased or maintained under service agreements with port community participants. Port commercial and asset management teams require this link for contract management, maintenance respons',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Quay walls are major capital assets requiring depreciation tracking, insurance valuation, and lifecycle management in the port asset registry. Port engineers and finance teams register quay walls as f',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: A quay wall is a physical waterfront structure belonging to a specific port. While quay_wall has port_location_id pointing to masterdata.port_location, it lacks a direct in-domain FK to the port entit',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Quay walls are infrastructure at specific port locations. Required for asset management, maintenance planning, spatial analysis, and linking structural assets to port geography for regulatory reportin',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: A quay wall forms the waterfront boundary of a terminal zone. While berth already references both quay_wall and terminal_zone, the quay_wall itself lacks a direct FK to terminal_zone. Adding terminal_',
    `asset_owner` STRING COMMENT 'Classification of the legal owner of the quay wall asset: port authority, terminal operator, government, private entity, or joint venture.. Valid values are `port_authority|terminal_operator|government|private|joint_venture`',
    `bollard_spacing_m` DECIMAL(18,2) COMMENT 'Average distance in meters between mooring bollards along the quay wall, used for vessel mooring line configuration planning.',
    `bollard_swl_tonnes` DECIMAL(18,2) COMMENT 'Safe Working Load (SWL) rating of mooring bollards installed on the quay wall, expressed in tonnes, indicating the maximum safe mooring line tension.',
    `construction_material` STRING COMMENT 'Primary material used in the construction of the quay wall structure.. Valid values are `reinforced_concrete|steel|composite|masonry|timber`',
    `crane_rail_gauge_mm` STRING COMMENT 'Distance in millimeters between crane rails if present, defining the track gauge for quay crane operations.',
    `crane_rail_present` BOOLEAN COMMENT 'Indicates whether the quay wall is equipped with crane rail infrastructure for Ship-to-Shore (STS) or Mobile Harbour Crane (MHC) operations.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this quay wall record was first created in the system.',
    `current_depth_m` DECIMAL(18,2) COMMENT 'Current actual water depth alongside the quay wall measured in meters from chart datum, as determined by the most recent hydrographic survey. May differ from design depth due to sedimentation or dredging.',
    `design_depth_m` DECIMAL(18,2) COMMENT 'Design water depth alongside the quay wall measured in meters from chart datum, indicating the maximum vessel draft that can be accommodated.',
    `design_load_capacity_kn_per_m2` DECIMAL(18,2) COMMENT 'Maximum design load capacity of the quay wall surface expressed in kilonewtons per square meter (kN/m²), representing the safe working load for cargo handling operations and equipment.',
    `design_standard` STRING COMMENT 'Engineering design standard or code under which the quay wall was designed and constructed (e.g., BS 6349, PIANC guidelines, Eurocode 7).',
    `environmental_monitoring` BOOLEAN COMMENT 'Indicates whether the quay wall area is equipped with environmental monitoring systems for air quality, water quality, noise, or emissions tracking.',
    `fender_system_type` STRING COMMENT 'Type of fender system installed on the quay wall for vessel berthing protection: cylindrical, cone, cell, arch, pneumatic, foam-filled, or none if no fender system is present. [ENUM-REF-CANDIDATE: cylindrical|cone|cell|arch|pneumatic|foam_filled|none — 7 candidates stripped; promote to reference product]',
    `geographic_coordinates` STRING COMMENT 'Geographic coordinates of the quay wall centerpoint in decimal degrees format (latitude, longitude) for GIS integration and port layout planning.',
    `imdg_compliant` BOOLEAN COMMENT 'Indicates whether the quay wall infrastructure meets International Maritime Dangerous Goods (IMDG) Code requirements for handling dangerous goods cargo.',
    `insurance_policy_number` STRING COMMENT 'Reference number of the insurance policy covering the quay wall infrastructure asset.',
    `isps_compliant` BOOLEAN COMMENT 'Indicates whether the quay wall facility meets International Ship and Port Facility Security (ISPS) Code requirements for maritime security.',
    `last_dredging_date` DATE COMMENT 'Date of the most recent dredging operation performed alongside the quay wall to maintain design depth.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent comprehensive structural inspection of the quay wall by qualified marine structural engineers.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this quay wall record was most recently updated in the system.',
    `lighting_system_type` STRING COMMENT 'Type of lighting system installed along the quay wall for night operations: LED, halogen, sodium vapor, or none.. Valid values are `led|halogen|sodium_vapor|none`',
    `maintenance_responsibility` STRING COMMENT 'Entity responsible for ongoing maintenance of the quay wall structure: port authority, terminal operator, external contractor, or shared responsibility.. Valid values are `port_authority|terminal_operator|contractor|shared`',
    `max_vessel_dwt_tonnes` DECIMAL(18,2) COMMENT 'Maximum Deadweight Tonnage (DWT) in tonnes of vessels that can be safely accommodated at this quay wall.',
    `max_vessel_loa_m` DECIMAL(18,2) COMMENT 'Maximum Length Overall (LOA) in meters of vessels that can be safely accommodated at this quay wall, based on structural and operational constraints.',
    `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next mandatory structural inspection of the quay wall based on regulatory requirements and maintenance planning.',
    `operational_status` STRING COMMENT 'Current operational status of the quay wall: operational (fully available), restricted (limited use due to conditions or repairs), closed (not available for vessel operations), under maintenance (scheduled maintenance in progress), under construction (new construction or major upgrade).. Valid values are `operational|restricted|closed|under_maintenance|under_construction`',
    `permitted_cargo_types` STRING COMMENT 'Comma-separated list of cargo types permitted for handling at this quay wall (e.g., containers, bulk, breakbulk, RoRo, liquid bulk, dangerous goods). [ENUM-REF-CANDIDATE: containers|bulk_dry|bulk_liquid|breakbulk|roro|general_cargo|dangerous_goods|refrigerated — promote to reference product]',
    `remarks` STRING COMMENT 'Free-text field for additional notes, special conditions, operational restrictions, or historical information about the quay wall structure.',
    `replacement_value_usd` DECIMAL(18,2) COMMENT 'Estimated replacement value of the quay wall structure in United States Dollars (USD) for insurance and asset management purposes.',
    `seismic_design_category` STRING COMMENT 'Seismic design classification indicating the level of earthquake resistance incorporated into the quay wall structure based on regional seismic hazard assessment.. Valid values are `none|low|moderate|high|very_high`',
    `structural_condition_rating` STRING COMMENT 'Current overall structural condition assessment of the quay wall based on the most recent engineering inspection: excellent (no defects), good (minor wear), fair (moderate deterioration), poor (significant defects requiring attention), critical (unsafe, requires immediate intervention).. Valid values are `excellent|good|fair|poor|critical`',
    `tidal_range_m` DECIMAL(18,2) COMMENT 'Mean tidal range in meters at the quay wall location, representing the vertical difference between mean high water and mean low water levels.',
    `total_length_m` DECIMAL(18,2) COMMENT 'Total linear length of the quay wall structure measured in meters along the waterfront.',
    `utility_services` STRING COMMENT 'Comma-separated list of utility services available at the quay wall (e.g., electrical power, potable water, fire water, compressed air, telecommunications, sewage).',
    `wall_code` STRING COMMENT 'Externally-known unique business identifier for the quay wall structure, used in port infrastructure documentation and AVEVA Marine Engineering system integration.. Valid values are `^[A-Z0-9]{4,12}$`',
    `wall_name` STRING COMMENT 'Human-readable name or designation of the quay wall structure (e.g., North Quay Wall, Container Terminal Wharf A).',
    `wall_type` STRING COMMENT 'Classification of the quay wall based on structural construction method: gravity (mass concrete), sheet pile (interlocking steel), caisson (prefabricated box), piled (supported on piles), diaphragm (continuous reinforced concrete), or cellular (steel sheet pile cells).. Valid values are `gravity|sheet_pile|caisson|piled|diaphragm|cellular`',
    `year_built` STRING COMMENT 'Calendar year when the quay wall structure was originally constructed and commissioned.',
    CONSTRAINT pk_quay_wall PRIMARY KEY(`quay_wall_id`)
) COMMENT 'Master record for quay wall and wharf structures forming the ports waterfront infrastructure. Captures wall type (gravity, sheet pile, caisson, piled), construction material, year built, total length, design load capacity (kN/m²), current structural condition rating, last structural inspection date, design standard, tidal range exposure, and associated berth references. Supports AVEVA Marine Engineering integration and CAPEX infrastructure project planning.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` (
    `terminal_zone_id` BIGINT COMMENT 'Unique identifier for the terminal zone. Primary key for the terminal zone master record.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Terminal zones are approved for specific commodity categories (bulk, liquid, dangerous goods). Customs authorities and port operators use this for cargo segregation compliance, IMDG stowage planning, ',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: Terminal zones are designated for specific container types (reefer zones, OOG zones, hazmat zones). TOS yard planning, reefer plug allocation, and IMDG segregation compliance all depend on knowing whi',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Terminal zones (container yards, hazmat areas) are ISPS-regulated restricted areas requiring security records per ISPS Code. PFSO tracks zone-specific security levels, access restrictions, and PFSP co',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Terminal zones are operated by specific terminal operators under concession agreements. Critical for concession management, zone operator billing, performance monitoring, and access control. Role pref',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Terminal zones (container yards, RoRo areas) are allocated to operators under concession/license agreements. Required for yard capacity allocation, throughput commitment tracking (agreement.volume_com',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: Terminal zones are leased under formal service agreements (lease_status attribute confirms a governing agreement exists). Port commercial teams track which service agreement covers each zone for contr',
    `port_id` BIGINT COMMENT 'Reference to the parent terminal facility that contains this zone. Links zone to its owning terminal for hierarchical port layout management.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Terminal zones are operational areas within port locations. Essential for yard planning, container tracking, customs zone mapping, and linking operational zones to master port location data for logist',
    `sla_profile_id` BIGINT COMMENT 'Foreign key linking to customer.sla_profile. Business justification: Terminal zone throughput and operational KPIs (crane productivity, dwell time, utilisation) are tracked against SLA profiles for the operating participant. Terminal operations managers require this li',
    `access_control_system` STRING COMMENT 'Technology used to control personnel and equipment entry to the zone. RFID gate for automated vehicle identification, biometric for high-security areas, card reader for personnel access, manual for guard-controlled entry, none for unrestricted areas. Integrates with Port Access Permit system.. Valid values are `rfid_gate|biometric|card_reader|manual|none`',
    `active_flag` BOOLEAN COMMENT 'Indicates whether this zone record is currently active in the master data registry. True: active and available for operational use. False: logically deleted or archived. Used for soft-delete pattern and historical record retention without physical deletion.',
    `boundary_coordinates_wkt` STRING COMMENT 'Geographic boundary of the zone represented as Well-Known Text (WKT) POLYGON geometry. Enables GIS integration with AVEVA Marine Engineering for port layout visualization, spatial analysis, and automated equipment routing in Terminal Operating Systems.',
    `cctv_coverage_flag` BOOLEAN COMMENT 'Indicates whether the zone is monitored by CCTV surveillance system. True: full video surveillance for security and incident investigation. False: no camera coverage. Required for ISPS Level 2+ zones and cargo theft prevention.',
    `centroid_latitude` DECIMAL(18,2) COMMENT 'Latitude coordinate of the zone geometric center in decimal degrees. Used for distance calculations, equipment dispatch optimization, and integration with Vessel Traffic Management System (VTMS) for cargo location tracking.',
    `centroid_longitude` DECIMAL(18,2) COMMENT 'Longitude coordinate of the zone geometric center in decimal degrees. Used for distance calculations, equipment dispatch optimization, and integration with Vessel Traffic Management System (VTMS) for cargo location tracking.',
    `commissioning_date` DATE COMMENT 'Date when the zone was officially opened and entered operational service. Used for asset age calculations, depreciation schedules, and infrastructure lifecycle planning in SAP PM (Plant Maintenance).',
    `customs_controlled_flag` BOOLEAN COMMENT 'Indicates whether the zone is under customs authority control as a bonded area or free trade zone. True: customs-controlled area requiring special clearance procedures. False: non-bonded domestic area. Impacts cargo movement restrictions and documentation requirements in Port Community System (PCS).',
    `design_capacity_utilization_pct` DECIMAL(18,2) COMMENT 'Target operational utilization percentage for the zone as designed by port planners. Typically 70-85% to allow operational flexibility. Used as benchmark for KPI reporting and capacity expansion trigger analysis. Expressed as percentage (e.g., 75.00 for 75%).',
    `drainage_system_type` STRING COMMENT 'Stormwater management infrastructure type installed in the zone. Storm sewer for direct discharge, retention pond for controlled release, permeable pavement for infiltration, none for natural drainage. Critical for environmental compliance per MARPOL and local water quality regulations tracked in Environmental Monitoring System (EMS).. Valid values are `storm_sewer|retention_pond|permeable_pavement|none`',
    `environmental_monitoring_flag` BOOLEAN COMMENT 'Indicates whether the zone has installed environmental sensors for air quality, noise, or emissions tracking. True: active monitoring integrated with Environmental Monitoring System (EMS). False: no environmental instrumentation. Required for zones near sensitive receptors or handling bulk materials.',
    `fire_suppression_system` STRING COMMENT 'Fire protection infrastructure installed in the zone. Hydrant network for general fire response, foam system for flammable liquid storage, sprinkler for warehouse protection, none for open yard areas. Required for IMDG hazmat zones and insurance compliance.. Valid values are `hydrant_network|foam_system|sprinkler|none`',
    `ground_slot_capacity_teu` STRING COMMENT 'Number of Twenty-foot Equivalent Unit (TEU) ground slots available for container placement at single-stack height. Represents the base stacking capacity before vertical stacking. Used for yard utilization KPI calculations.',
    `handling_equipment_type` STRING COMMENT 'Primary type of cargo handling equipment deployed in this zone. RTG (Rubber Tyred Gantry) for automated container yards, ASC (Automated Stacking Crane) for rail-mounted operations, reach stacker for flexible container handling, forklift for warehouse operations, mobile crane for heavy lift, none for passive storage areas. Determines operational capacity and throughput rates.. Valid values are `rtg|asc|reach_stacker|forklift|mobile_crane|none`',
    `hazmat_approved_flag` BOOLEAN COMMENT 'Indicates whether the zone is certified and equipped for storage and handling of dangerous goods per International Maritime Dangerous Goods (IMDG) Code. True: approved for IMDG cargo with appropriate safety infrastructure. False: non-hazmat zone. Drives cargo acceptance rules in Terminal Operating System.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent formal infrastructure inspection for safety, structural integrity, and regulatory compliance. Drives preventive maintenance scheduling in Maximo Asset Management and Port State Control (PSC) readiness.',
    `last_resurfacing_date` DATE COMMENT 'Date when the zone pavement was last resurfaced or rehabilitated. Used to calculate pavement age, predict maintenance cycles, and schedule preventive maintenance in Maximo Asset Management system.',
    `lease_status` STRING COMMENT 'Commercial arrangement governing zone usage rights. Port operated: directly managed by port authority. Leased terminal operator: long-term concession to terminal operator. Leased cargo owner: dedicated to specific shipper/consignee. Subleased: operator has subleased to third party. Vacant: available for lease. Drives revenue recognition and billing in SAP FI.. Valid values are `port_operated|leased_terminal_operator|leased_cargo_owner|subleased|vacant`',
    `lighting_type` STRING COMMENT 'Type of illumination infrastructure installed in the zone for 24/7 operations. LED high mast for energy-efficient area lighting, halogen flood for legacy installations, none for daylight-only operations. Impacts operational hours, safety compliance, and energy consumption tracking in Environmental Management System (EMS).. Valid values are `led_high_mast|halogen_flood|none`',
    `maximum_stack_height` STRING COMMENT 'Maximum number of container tiers (vertical stacking levels) permitted in this zone based on pavement strength, equipment Safe Working Load (SWL), and operational safety requirements. Typically ranges from 3-6 tiers for yard operations.',
    `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next mandatory infrastructure inspection. Calculated based on regulatory requirements, pavement condition, and operational intensity. Triggers work order generation in Maximo for inspection planning.',
    `operational_status` STRING COMMENT 'Current lifecycle status of the zone. Operational: actively in use for cargo handling. Maintenance: temporarily unavailable for scheduled or emergency maintenance. Closed: administratively closed but not decommissioned. Planned: approved for construction but not yet operational. Decommissioned: permanently removed from service.. Valid values are `operational|maintenance|closed|planned|decommissioned`',
    `paved_area_sqm` DECIMAL(18,2) COMMENT 'Surface area with hard pavement (concrete or asphalt) suitable for heavy equipment operations and container stacking in square meters (m²). Critical for determining operational capacity and maintenance planning.',
    `pavement_condition_rating` STRING COMMENT 'Assessment of pavement structural integrity and surface condition. Excellent: no defects, full load capacity. Good: minor wear, full operational capacity. Fair: moderate deterioration, reduced heavy equipment operations. Poor: significant cracking/rutting, maintenance required. Critical: structural failure risk, immediate repair needed. Drives CAPEX maintenance planning.. Valid values are `excellent|good|fair|poor|critical`',
    `rail_access_flag` BOOLEAN COMMENT 'Indicates whether the zone has direct rail track access for intermodal rail operations. True: rail-connected for on-dock rail loading/unloading. False: truck-only access. Critical for intermodal logistics planning and rail operator coordination.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this terminal zone record was first created in the system. Used for data lineage, audit trail, and regulatory compliance reporting. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `record_source_system` STRING COMMENT 'Identifies the operational system of record that originated or last updated this zone record. NAVIS N4 for TOS-managed zones, AVEVA Marine for engineering-designed zones, manual entry for ad-hoc additions, GIS import for spatial data loads, legacy migration for historical data conversion. Supports data lineage and reconciliation.. Valid values are `navis_n4|aveva_marine|manual_entry|gis_import|legacy_migration`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this terminal zone record was last modified. Tracks data currency for change data capture, synchronization with operational systems (NAVIS N4, AVEVA), and audit compliance. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `reefer_plug_count` STRING COMMENT 'Number of electrical connection points (reefer plugs) available for refrigerated container (reefer) power supply. Critical for cold chain cargo capacity planning and reefer slot allocation in Terminal Operating System.',
    `remarks` STRING COMMENT 'Free-text field for additional operational notes, special handling instructions, temporary restrictions, or historical context not captured in structured fields. Used by terminal planners and operations managers for knowledge transfer.',
    `security_level` STRING COMMENT 'International Ship and Port Facility Security (ISPS) Code security level assigned to the zone. Level 1: normal operations with minimum security measures. Level 2: heightened risk requiring additional security. Level 3: imminent threat requiring maximum protective measures. Drives access control and surveillance requirements.. Valid values are `level_1|level_2|level_3`',
    `total_area_sqm` DECIMAL(18,2) COMMENT 'Total surface area of the zone in square meters (m²). Includes paved, unpaved, and built-up areas. Used for capacity planning, lease calculations, and infrastructure investment analysis.',
    `total_capacity_teu` STRING COMMENT 'Maximum theoretical container capacity in Twenty-foot Equivalent Units (TEU) when stacked to maximum allowable height. Calculated as ground_slot_capacity_teu × maximum_stack_height. Used for strategic capacity planning and terminal expansion analysis.',
    `truck_access_flag` BOOLEAN COMMENT 'Indicates whether the zone has direct road access for truck operations. True: truck-accessible for drayage and delivery operations. False: restricted access requiring internal transfer. Impacts gate operations and dwell time calculations.',
    `vessel_side_flag` BOOLEAN COMMENT 'Indicates whether the zone is located directly adjacent to berth/quay for ship-to-shore operations. True: vessel-side zone for direct discharge/loading operations. False: landside zone requiring horizontal transport. Affects Ship-to-Shore (STS) crane reach and vessel operation efficiency.',
    `weighbridge_available_flag` BOOLEAN COMMENT 'Indicates whether the zone has an integrated weighbridge (truck scale) for container/cargo weight verification. True: weighbridge installed for SOLAS VGM (Verified Gross Mass) compliance. False: no weighing capability. Mandatory for container export zones per SOLAS Amendment.',
    `zone_type` STRING COMMENT 'Classification of the zone by its primary operational function. Determines handling equipment requirements, stacking rules, and capacity calculation methods. Container Yard (CY) for TEU/FEU stacking, Container Freight Station (CFS) for LCL consolidation, RoRo for Roll-on Roll-off operations, bulk storage for dry/liquid bulk, warehouse for covered storage, gate complex for entry/exit processing, rail yard for intermodal rail transfer, intermodal transfer for truck-rail interchange, empty depot for empty container storage. [ENUM-REF-CANDIDATE: container_yard|container_freight_station|roro_ramp|roro_marshalling|bulk_storage|warehouse|gate_complex|rail_yard|intermodal_transfer|empty_depot — 10 candidates stripped; promote to reference product]',
    CONSTRAINT pk_terminal_zone PRIMARY KEY(`terminal_zone_id`)
) COMMENT 'Master record for logical and physical zones within the port terminal including container yards (CY), container freight stations (CFS), RoRo ramps and marshalling areas, bulk storage areas, warehouses, gate complexes, rail yards, intermodal transfer zones, and empty container depots. Captures zone code, zone name, zone type, parent terminal reference, total area (m²), paved area, stacking capacity (TEU ground slots and total TEU at max height), maximum stack height, reefer plug count, zone operational status, pavement condition rating, last resurfacing date, and geographic boundary coordinates (GIS polygon). SSOT for port layout, zone capacity planning, and terminal configuration management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` (
    `warehouse_id` BIGINT COMMENT 'Unique identifier for the warehouse facility. Primary key.',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Bonded warehouses and cargo storage facilities are ISPS-regulated requiring security level management, access control records, and PFSP compliance per ISPS Code. Security officers track facility-speci',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Warehouses are leased to freight forwarders, customs brokers, or cargo owners. Essential for warehouse lease management, rental billing, access control, and capacity allocation. Role prefix lessee_ ',
    `participant_account_id` BIGINT COMMENT 'Foreign key linking to customer.agreement. Business justification: Warehouses (especially bonded/CFS facilities) are leased to cargo handlers or freight forwarders under service agreements. Essential for storage capacity allocation, bonded facility licensing, lease m',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: Warehouse leases are formal service agreements (lease_expiry_date and effective_from/to_date confirm a governing agreement). Port contract managers require linking each warehouse to its service agreem',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Warehouses exist at specific port locations. Required for cargo routing, customs clearance, logistics planning, and linking warehouse facilities to master port location data for operational and regula',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Warehouses are located within terminal zones. The existing port_zone_code (STRING) should be replaced with FK to terminal_zone.terminal_zone_id. This enables joining to get zone operational details (z',
    `access_control_system` STRING COMMENT 'Type of access control system deployed for personnel and vehicle entry. Manual for guard-based control, card_reader for magnetic/proximity cards, biometric for fingerprint/facial recognition, rfid for automated vehicle gates, integrated for multi-factor systems.. Valid values are `manual|card_reader|biometric|rfid|integrated`',
    `address_line1` STRING COMMENT 'Primary street address line of the warehouse facility including building number and street name.',
    `address_line2` STRING COMMENT 'Secondary address line for additional location details such as building name, suite number, or precinct identifier.',
    `bonded_status` BOOLEAN COMMENT 'Indicates whether the warehouse is a customs-bonded facility authorized to store imported goods under customs supervision without immediate duty payment. True if bonded, false otherwise.',
    `cctv_coverage` BOOLEAN COMMENT 'Indicates whether the warehouse has comprehensive CCTV surveillance coverage for security monitoring and incident investigation. True if CCTV installed, false otherwise.',
    `city` STRING COMMENT 'City or municipality where the warehouse facility is located.',
    `warehouse_code` STRING COMMENT 'Externally-known unique alphanumeric code for the warehouse facility used in operational systems and documentation. Typically follows port naming conventions.. Valid values are `^[A-Z0-9]{4,12}$`',
    `construction_year` STRING COMMENT 'Year the warehouse facility was originally constructed. Used for asset age analysis, depreciation calculations, and maintenance planning.',
    `contact_email` STRING COMMENT 'Primary email address for warehouse operational communications and booking inquiries.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `contact_phone` STRING COMMENT 'Primary contact telephone number for warehouse operations and inquiries.',
    `country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code where the warehouse is located (e.g., USA, SGP, NLD).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this warehouse record was first created in the system. Used for audit trail and data lineage.',
    `customs_license_number` STRING COMMENT 'Official customs authority license or registration number for bonded warehouse operations. Required for customs-controlled storage facilities.',
    `effective_from_date` DATE COMMENT 'Date from which this warehouse record became active and available for operational use in the port management system.',
    `effective_to_date` DATE COMMENT 'Date until which this warehouse record is valid. Null for currently active facilities. Used for historical tracking and decommissioned assets.',
    `environmental_certification` STRING COMMENT 'Comma-separated list of environmental management certifications held by the warehouse (e.g., ISO_14001,LEED,Green_Port). Empty if no certifications.',
    `fire_suppression_system_type` STRING COMMENT 'Type of fire suppression system installed. Sprinkler for wet pipe systems, foam for flammable liquid protection, gas for clean agent systems (FM-200, CO2), deluge for high-hazard areas, dry_pipe for freezing environments, pre_action for sensitive cargo. [ENUM-REF-CANDIDATE: none|sprinkler|foam|gas|deluge|dry_pipe|pre_action — 7 candidates stripped; promote to reference product]',
    `floor_load_capacity_kn_per_sqm` DECIMAL(18,2) COMMENT 'Maximum permissible floor load capacity in kilonewtons per square meter (kN/m²). Determines safe stacking weight limits and equipment usage restrictions.',
    `geo_latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the warehouse facility in decimal degrees. Used for mapping, navigation, and spatial analytics.',
    `geo_longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the warehouse facility in decimal degrees. Used for mapping, navigation, and spatial analytics.',
    `height_clearance_m` DECIMAL(18,2) COMMENT 'Maximum internal height clearance in meters from floor to lowest overhead obstruction (beams, lighting, sprinklers). Critical for stacking height calculations and equipment compatibility.',
    `insurance_coverage_amount` DECIMAL(18,2) COMMENT 'Total insured value of the warehouse facility and maximum cargo coverage limit in the base currency. Used for risk management and financial reporting.',
    `insurance_policy_number` STRING COMMENT 'Reference number of the primary property and liability insurance policy covering the warehouse facility and stored cargo.',
    `last_major_renovation_year` STRING COMMENT 'Year of the most recent major renovation, refurbishment, or structural upgrade. Null if no major renovation has occurred since construction.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this warehouse record. Used for change tracking and synchronization.',
    `lease_expiry_date` DATE COMMENT 'Date when the current lease or concession agreement expires. Null for port-owned facilities or perpetual arrangements. Critical for contract renewal planning.',
    `loading_bay_count` STRING COMMENT 'Number of truck loading/unloading bays or dock doors available for cargo transfer operations. Impacts throughput capacity and dwell time.',
    `material_handling_equipment` STRING COMMENT 'Comma-separated list of material handling equipment types available at the warehouse (e.g., forklift,reach_stacker,pallet_jack,overhead_crane). Used for operational planning and equipment dispatch.',
    `max_forklift_capacity_tonnes` DECIMAL(18,2) COMMENT 'Maximum lifting capacity in tonnes of the largest forklift equipment available at the warehouse. Determines handling capability for heavy cargo units.',
    `warehouse_name` STRING COMMENT 'Official business name of the warehouse facility as used in contracts, signage, and operational documentation.',
    `operating_hours` STRING COMMENT 'Standard operating schedule for the warehouse. 24x7 for continuous operations, business_hours for standard weekday daytime, extended for weekday plus weekend coverage, custom for specific schedules defined separately.. Valid values are `24x7|business_hours|extended|custom`',
    `operational_status` STRING COMMENT 'Current lifecycle status of the warehouse facility indicating availability for cargo operations.. Valid values are `operational|maintenance|inactive|decommissioned|under_construction|planned`',
    `ownership_type` STRING COMMENT 'Legal ownership structure of the warehouse facility. Port_owned for direct port authority ownership, leased for long-term lease arrangements, joint_venture for shared ownership, third_party for private operator facilities, concession for build-operate-transfer arrangements.. Valid values are `port_owned|leased|joint_venture|third_party|concession`',
    `postal_code` STRING COMMENT 'Postal or ZIP code for the warehouse facility address. Format varies by country.',
    `rail_access_available` BOOLEAN COMMENT 'Indicates whether the warehouse has direct rail siding access for intermodal cargo transfer. True if rail-connected, false otherwise. Critical for inland container depot (ICD) operations.',
    `reefer_plug_count` STRING COMMENT 'Number of electrical power connection points available for refrigerated container (reefer) monitoring and power supply. Zero if not a reefer-capable facility.',
    `security_level` STRING COMMENT 'Security classification of the warehouse facility. Standard for basic access control, enhanced for CCTV and alarm systems, isps_compliant for ISPS Code certified facilities, high_value for precious cargo storage with advanced security measures.. Valid values are `standard|enhanced|isps_compliant|high_value`',
    `temperature_control_capability` STRING COMMENT 'Type of temperature control system installed. None for ambient storage, refrigerated for chilled goods (2-8°C), climate_controlled for humidity and temperature management, frozen for sub-zero storage, multi_zone for facilities with multiple temperature zones.. Valid values are `none|refrigerated|climate_controlled|frozen|multi_zone`',
    `temperature_range_max_c` DECIMAL(18,2) COMMENT 'Maximum operating temperature in Celsius that the warehouse climate control system can maintain. Applicable only for temperature-controlled facilities.',
    `temperature_range_min_c` DECIMAL(18,2) COMMENT 'Minimum operating temperature in Celsius that the warehouse climate control system can maintain. Applicable only for temperature-controlled facilities.',
    `total_floor_area_sqm` DECIMAL(18,2) COMMENT 'Total gross floor area of the warehouse facility measured in square meters, including all covered space, aisles, offices, and non-storage areas.',
    `usable_storage_area_sqm` DECIMAL(18,2) COMMENT 'Net usable storage area in square meters available for cargo placement, excluding aisles, offices, equipment rooms, and other non-storage zones. Used for capacity planning and utilization KPIs.',
    `warehouse_type` STRING COMMENT 'Classification of warehouse facility by primary function. CFS (Container Freight Station) for LCL consolidation, bonded for customs-controlled storage, hazmat for IMDG dangerous goods, reefer for temperature-controlled cargo, general for standard dry goods, open_yard for uncovered storage, transit_shed for temporary cargo staging. [ENUM-REF-CANDIDATE: CFS|bonded|hazmat|reefer|general|open_yard|transit_shed — 7 candidates stripped; promote to reference product]',
    CONSTRAINT pk_warehouse PRIMARY KEY(`warehouse_id`)
) COMMENT 'Master record for port warehouses and covered storage facilities including CFS sheds, bonded warehouses, hazardous goods stores, and reefer stations. Captures warehouse code, name, type, total floor area (m²), usable storage area, height clearance, floor load capacity (kN/m²), number of loading bays, temperature control capability, bonded status, IMDG class approvals, fire suppression system type, and operational status.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` (
    `channel_id` BIGINT COMMENT 'Unique identifier for the navigable channel record. Primary key.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Navigation channels have maximum permissible vessel type constraints (draft, beam, LOA). Port authorities use this for vessel traffic management, pre-arrival clearance decisions, and channel access co',
    `participant_service_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.participant_service_agreement. Business justification: Navigation channel dredging and maintenance is contracted to port community participants under formal service agreements. Port asset management and dredging_authority tracking require linking each cha',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: A navigable channel, fairway, or approach route is port-specific infrastructure. channel has port_location_id (cross-domain) but no in-domain FK to port. Adding port_id directly links channels to thei',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Channels connect to and serve port locations. Essential for vessel traffic management, pilotage planning, dredging coordination, and linking navigation channels to master port location data for operat',
    `bearing_degrees` DECIMAL(18,2) COMMENT 'Primary compass bearing in degrees (0-360) along which the channel is aligned, used for navigation and traffic planning.',
    `channel_type` STRING COMMENT 'Classification of the channel based on its operational purpose within the port navigation system.. Valid values are `approach|fairway|berthing_channel|turning_basin|anchorage_access|inner_harbor`',
    `chart_reference` STRING COMMENT 'Reference to the official nautical chart(s) on which this channel is depicted, including chart number and edition (e.g., AUS 123, Edition 5).',
    `channel_code` STRING COMMENT 'Unique alphanumeric code assigned to the channel for operational reference and system integration (e.g., CH-001, MAIN-APP).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this channel record was first created in the system.',
    `current_maintained_depth_cd_m` DECIMAL(18,2) COMMENT 'Current actual maintained depth of the channel measured in meters below Chart Datum (CD), reflecting the most recent survey or dredging results.',
    `design_depth_cd_m` DECIMAL(18,2) COMMENT 'Designed depth of the channel measured in meters below Chart Datum (CD), representing the minimum guaranteed depth under normal conditions.',
    `design_width_m` DECIMAL(18,2) COMMENT 'Designed navigable width of the channel measured in meters at the channel centerline, representing the safe maneuvering corridor.',
    `dredging_authority` STRING COMMENT 'Name of the organization or authority responsible for maintaining channel depth through dredging operations (e.g., Port Authority, National Maritime Agency, contracted dredging company).',
    `environmental_sensitivity_flag` BOOLEAN COMMENT 'Indicates whether the channel passes through or adjacent to environmentally sensitive areas requiring special operational or dredging considerations.',
    `last_dredging_date` DATE COMMENT 'Date when the most recent dredging operation was completed in this channel.',
    `last_survey_date` DATE COMMENT 'Date when the most recent hydrographic depth survey was conducted for this channel.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this channel record was most recently modified.',
    `max_permissible_beam_m` DECIMAL(18,2) COMMENT 'Maximum beam (width) in meters of vessels permitted to transit this channel, based on channel width and safe passing distance requirements.',
    `max_permissible_draft_m` DECIMAL(18,2) COMMENT 'Maximum vessel draft in meters permitted in this channel, calculated from current maintained depth with appropriate under-keel clearance allowances.',
    `max_permissible_dwt` DECIMAL(18,2) COMMENT 'Maximum Deadweight Tonnage (DWT) of vessels permitted to transit this channel under normal conditions, based on channel depth and width constraints.',
    `max_permissible_loa_m` DECIMAL(18,2) COMMENT 'Maximum Length Overall (LOA) in meters of vessels permitted to transit this channel, based on channel length, turning basin dimensions, and maneuvering requirements.',
    `minimum_depth_cd_m` DECIMAL(18,2) COMMENT 'Minimum recorded depth along the channel measured in meters below Chart Datum (CD), identifying the controlling depth or shoal point.',
    `channel_name` STRING COMMENT 'Official name of the navigable channel, fairway, or approach route within port waters (e.g., Main Approach Channel, Eastern Fairway).',
    `navigational_aids_description` STRING COMMENT 'Description of navigational aids marking this channel, including buoys, beacons, leading lights, range markers, and electronic navigation systems (e.g., Lighted buoys port and starboard, Leading lights at 045°).',
    `next_scheduled_survey_date` DATE COMMENT 'Planned date for the next hydrographic survey of the channel to verify maintained depth and identify sedimentation.',
    `operational_status` STRING COMMENT 'Current operational status of the channel indicating availability for vessel traffic.. Valid values are `operational|restricted|closed|under_maintenance|dredging_in_progress`',
    `pilotage_required_flag` BOOLEAN COMMENT 'Indicates whether marine pilotage is mandatory for vessels transiting this channel.',
    `remarks` STRING COMMENT 'Additional operational notes, restrictions, or special instructions relevant to this channel (e.g., seasonal restrictions, weather limitations, construction notices).',
    `sedimentation_rate_m_per_year` DECIMAL(18,2) COMMENT 'Average annual sedimentation rate in meters per year, indicating the rate at which the channel depth decreases due to sediment accumulation.',
    `survey_frequency_months` STRING COMMENT 'Standard interval in months between scheduled hydrographic surveys for this channel.',
    `tidal_window_restriction` STRING COMMENT 'Description of any tidal restrictions or windows during which vessel movements are permitted or restricted in this channel (e.g., High tide only, +/- 2 hours of high water, No restrictions).',
    `total_length_nm` DECIMAL(18,2) COMMENT 'Total navigable length of the channel measured in nautical miles from entrance to terminus.',
    `towage_required_flag` BOOLEAN COMMENT 'Indicates whether towage (tug assistance) is mandatory for certain vessel classes transiting this channel.',
    `two_way_traffic_permitted_flag` BOOLEAN COMMENT 'Indicates whether simultaneous two-way vessel traffic is permitted in this channel, or if one-way traffic restrictions apply.',
    `under_keel_clearance_m` DECIMAL(18,2) COMMENT 'Minimum required under-keel clearance in meters between vessel keel and channel bottom, applied as a safety margin when calculating maximum permissible draft.',
    `vts_monitoring_zone` STRING COMMENT 'Reference code or name of the Vessel Traffic Service (VTS) monitoring zone that covers this channel for traffic management and safety oversight.',
    CONSTRAINT pk_channel PRIMARY KEY(`channel_id`)
) COMMENT 'Master record for navigable channels, fairways, and approach routes within port waters. Captures channel name, chart reference, total length (nm), design width, design depth (Chart Datum), current maintained depth, dredging authority, last dredging date, next scheduled survey date, tidal window restrictions, maximum permissible vessel DWT, LOA limit, and VTS monitoring zone reference. SSOT for channel specifications used in vessel traffic management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` (
    `port_gate_id` BIGINT COMMENT 'Unique identifier for the port gate. Primary key for the port gate master record.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Port gates are designated for specific commodity/cargo types (hazmat gates, reefer cargo lanes, bulk cargo entry). Gate management systems use this for truck routing, customs inspection assignment, an',
    `equipment_class_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_class. Business justification: Port gates contain OCR systems, RFID readers, weighbridges, and barrier equipment that belong to equipment classes for maintenance planning, operator certification requirements, and SLA benchmarking. ',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Port gates are ISPS security perimeter control points requiring facility security records per ISPS Code. Port Facility Security Officers (PFSO) track security level changes, access control compliance,',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Gates have physical assets (RFID readers, OCR cameras, weighbridges, barriers, access control systems) requiring asset tracking, maintenance, and replacement planning. Critical for gate operations equ',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: A port gate is a physical access control point at a specific port. port_gate has port_location_id (cross-domain) and terminal_zone_id (in-domain, existing), but no direct in-domain FK to port. Adding ',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: ISPS-compliant gates require designated supervisor for security zone enforcement, access control, hazmat clearance, and customs coordination. Mandatory for port facility security plans and incident re',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Gates track primary users (trucking companies, freight forwarders) for dedicated lane allocation and preferential access programs. Supports gate transaction billing, access authorization, and traffic ',
    `terminal_zone_id` BIGINT COMMENT 'Reference to the terminal or port facility that this gate provides access to. Links the gate to its parent terminal infrastructure for operational hierarchy and reporting.',
    `access_control_system_reference` STRING COMMENT 'Reference identifier or integration code linking this gate to the port access control and security management system. Used for ISPS compliance and security zone enforcement.',
    `appointment_required_flag` BOOLEAN COMMENT 'Indicates whether advance appointment or booking is required for gate access. Supports truck appointment systems and congestion management initiatives.',
    `average_processing_time_minutes` DECIMAL(18,2) COMMENT 'Average time in minutes required to process a transaction at this gate. Used for capacity planning, queue management, and service level agreement (SLA) monitoring.',
    `cctv_coverage_flag` BOOLEAN COMMENT 'Indicates whether the gate is covered by CCTV surveillance systems for security monitoring and incident investigation. Supports ISPS security requirements.',
    `commissioning_date` DATE COMMENT 'Date when the gate was officially commissioned and put into operational service. Supports asset lifecycle tracking and infrastructure planning.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this gate record was first created in the system. Supports data lineage, audit trail, and record lifecycle tracking.',
    `customs_inspection_point_flag` BOOLEAN COMMENT 'Indicates whether this gate serves as a designated customs inspection and clearance point. Supports trade compliance and customs integration workflows.',
    `daily_throughput_capacity` STRING COMMENT 'Maximum number of transactions or vehicles that can be processed through this gate in a 24-hour period under normal operating conditions. Supports capacity planning and resource allocation.',
    `port_gate_description` STRING COMMENT 'Detailed textual description of the gate including location details, special features, operational notes, and any unique characteristics relevant to gate operations and planning.',
    `emergency_access_flag` BOOLEAN COMMENT 'Indicates whether the gate is designated for emergency vehicle access and can be opened outside normal operating hours for emergency response. Supports safety and security protocols.',
    `gate_code` STRING COMMENT 'Business identifier code for the gate used in operational systems and signage. Unique alphanumeric code assigned to each gate for reference in Terminal Operating System (TOS) and gate operations.. Valid values are `^[A-Z0-9]{2,10}$`',
    `gate_direction` STRING COMMENT 'Primary traffic flow direction supported by the gate. Determines operational procedures and transaction processing logic in TOS.. Valid values are `inbound|outbound|bidirectional`',
    `gate_name` STRING COMMENT 'Human-readable name or designation of the gate (e.g., North Truck Gate, Rail Gate 3, Crew Access Gate A). Used for operational communication and wayfinding.',
    `gate_type` STRING COMMENT 'Classification of the gate based on its primary operational purpose and the type of traffic it handles. Determines applicable operational procedures and security protocols. [ENUM-REF-CANDIDATE: truck|rail|pedestrian|crew_access|service|emergency|vip — 7 candidates stripped; promote to reference product]',
    `hazmat_clearance_required_flag` BOOLEAN COMMENT 'Indicates whether special clearance or documentation is required for vehicles carrying hazardous materials through this gate. Supports IMDG Code compliance and safety protocols.',
    `inbound_lanes` STRING COMMENT 'Number of lanes designated for inbound traffic entering the port facility. Supports directional flow management and throughput analysis.',
    `isps_security_zone` STRING COMMENT 'ISPS security zone classification for the gate indicating the level of access control and security measures required. Determines screening procedures and access authorization requirements.. Valid values are `public|port_facility|restricted|secure`',
    `last_maintenance_date` DATE COMMENT 'Date of the most recent maintenance activity performed on the gate infrastructure or systems. Supports preventive maintenance scheduling and compliance tracking.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this gate record was most recently modified. Supports change tracking, audit trail, and data quality monitoring.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the gate location in decimal degrees. Supports GIS integration, navigation systems, and spatial analysis.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the gate location in decimal degrees. Supports GIS integration, navigation systems, and spatial analysis.',
    `maximum_vehicle_height_meters` DECIMAL(18,2) COMMENT 'Maximum permissible vehicle height in meters that can pass through the gate infrastructure. Used for pre-gate clearance validation and safety compliance.',
    `maximum_vehicle_length_meters` DECIMAL(18,2) COMMENT 'Maximum permissible vehicle length in meters that can be accommodated at the gate. Used for pre-gate clearance validation and queue management.',
    `maximum_vehicle_width_meters` DECIMAL(18,2) COMMENT 'Maximum permissible vehicle width in meters that can pass through the gate infrastructure. Used for pre-gate clearance validation and safety compliance.',
    `next_scheduled_maintenance_date` DATE COMMENT 'Date when the next planned maintenance activity is scheduled for the gate. Supports proactive maintenance planning and operational continuity.',
    `number_of_lanes` STRING COMMENT 'Total count of traffic lanes at the gate for vehicle or pedestrian throughput. Used for capacity planning and queue management in gate operations.',
    `ocr_enabled_flag` BOOLEAN COMMENT 'Indicates whether the gate is equipped with OCR technology for automated license plate recognition and container number capture. Enables automated data capture and validation at gate entry/exit.',
    `operating_hours_end` STRING COMMENT 'Standard daily end time for gate operations in HH:MM format (24-hour clock). Defines the conclusion of the operational window for gate access.. Valid values are `^([01]d|2[0-3]):([0-5]d)$`',
    `operating_hours_start` STRING COMMENT 'Standard daily start time for gate operations in HH:MM format (24-hour clock). Defines the beginning of the operational window for gate access.. Valid values are `^([01]d|2[0-3]):([0-5]d)$`',
    `operational_status` STRING COMMENT 'Current operational state of the gate indicating whether it is available for use, temporarily closed, under maintenance, or permanently decommissioned. Drives gate availability in TOS and access control systems.. Valid values are `operational|closed|maintenance|suspended|decommissioned`',
    `outbound_lanes` STRING COMMENT 'Number of lanes designated for outbound traffic exiting the port facility. Supports directional flow management and throughput analysis.',
    `rfid_enabled_flag` BOOLEAN COMMENT 'Indicates whether the gate is equipped with RFID technology for automated vehicle or container identification. Supports automated gate processing and reduces manual intervention.',
    `twenty_four_hour_operation_flag` BOOLEAN COMMENT 'Indicates whether the gate operates continuously 24 hours per day, 7 days per week. Overrides standard operating hours when set to true.',
    `weighbridge_integrated_flag` BOOLEAN COMMENT 'Indicates whether the gate has an integrated weighbridge system for automated vehicle and cargo weight measurement. Supports compliance with weight regulations and cargo verification.',
    CONSTRAINT pk_port_gate PRIMARY KEY(`port_gate_id`)
) COMMENT 'Master record for port access gates including truck gates, rail gates, pedestrian gates, and vessel crew access points. Captures gate code, gate name, gate type, number of lanes, RFID/OCR capability, weighbridge integration flag, operating hours, ISPS security zone classification, access control system reference, and current operational status. Supports gate operations in NAVIS N4 and ISPS compliance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` (
    `anchorage_area_id` BIGINT COMMENT 'Unique identifier for the anchorage area. Primary key for the anchorage area master record.',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Anchorage areas are designated for specific vessel types (tanker anchorage, bulk carrier anchorage, quarantine anchorage). Port authorities use this for anchorage assignment, VTS vessel traffic manage',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Anchorage areas are designated ISPS security zones requiring Port Facility Security Plans under SOLAS Chapter XI-2. Port security officers manage ISPS security levels for anchorage areas. anchorage_ar',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: An anchorage area is a designated water area within port waters and approaches, governed by a specific port authority. anchorage_area has port_location_id (cross-domain) but no in-domain FK to port. A',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Anchorage areas are designated zones within port locations. Required for vessel scheduling, traffic management, safety planning, and linking anchorage zones to master port location data for VTS and pi',
    `ais_monitoring_required_flag` BOOLEAN COMMENT 'Indicates whether vessels anchored in this area must maintain active AIS transmission for VTS monitoring. True if AIS monitoring is mandatory, False otherwise.',
    `anchorage_category` STRING COMMENT 'Functional category of the anchorage area defining its designated use: general (standard commercial), quarantine (health inspection), explosives (dangerous cargo), STS transfer (ship-to-ship operations), waiting (pre-berth queue), emergency, or restricted (special authorization required). [ENUM-REF-CANDIDATE: general|quarantine|explosives|sts_transfer|waiting|emergency|restricted — 7 candidates stripped; promote to reference product]',
    `anchorage_code` STRING COMMENT 'Unique alphanumeric code assigned to the anchorage area for operational reference and system integration. Used by VTMS and vessel scheduling systems.. Valid values are `^[A-Z0-9]{3,10}$`',
    `anchorage_name` STRING COMMENT 'Official name of the anchorage area as designated in port operational documentation and nautical charts.',
    `area_size_square_meters` DECIMAL(18,2) COMMENT 'Total surface area of the anchorage in square meters. Used for capacity planning and utilization analysis.',
    `chart_reference` STRING COMMENT 'Reference to the official nautical chart(s) on which this anchorage area is depicted, including chart number and edition.',
    `communication_channel_vhf` STRING COMMENT 'Designated VHF radio channel for communication with vessels in this anchorage area (e.g., VHF 12, VHF 16). Used for VTS coordination and port operations.. Valid values are `^(VHFs)?[0-9]{1,2}[A-Z]?$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this anchorage area record was first created in the system.',
    `current_speed_max_knots` DECIMAL(18,2) COMMENT 'Maximum recorded or expected current speed in knots within the anchorage area. Important for anchor holding and vessel safety assessment.',
    `designated_use_restrictions` STRING COMMENT 'Text description of any specific restrictions or conditions on the use of this anchorage area (e.g., vessel type restrictions, cargo restrictions, time-of-day limitations, environmental restrictions).',
    `designation_authority` STRING COMMENT 'Name of the regulatory or port authority that officially designated this anchorage area and maintains jurisdiction over its use.',
    `designation_date` DATE COMMENT 'Date on which this anchorage area was officially designated and approved for operational use by the competent authority.',
    `distance_to_berth_nm` DECIMAL(18,2) COMMENT 'Distance in nautical miles from the anchorage area center to the nearest operational berth. Used for transit time estimation and operational planning.',
    `distance_to_pilot_boarding_nm` DECIMAL(18,2) COMMENT 'Distance in nautical miles from the anchorage area to the designated pilot boarding ground. Relevant for pilotage service coordination.',
    `dredging_maintenance_frequency` STRING COMMENT 'Scheduled frequency of dredging maintenance operations to maintain declared water depths in the anchorage area.. Valid values are `annual|biannual|quarterly|as_needed|none`',
    `emergency_anchorage_flag` BOOLEAN COMMENT 'Indicates whether this anchorage area is designated for emergency use (e.g., vessel distress, severe weather refuge). True if designated for emergency use, False for normal operations.',
    `environmental_sensitivity_flag` BOOLEAN COMMENT 'Indicates whether the anchorage area is located in or adjacent to an environmentally sensitive zone requiring special operational protocols. True if environmentally sensitive, False otherwise.',
    `geographic_boundary_polygon` STRING COMMENT 'Geographic boundary of the anchorage area defined as a polygon using coordinate pairs (latitude/longitude in decimal degrees). Format: comma-separated coordinate pairs representing the polygon vertices.',
    `holding_ground_type` STRING COMMENT 'Type of seabed material in the anchorage area that affects anchor holding capability. Critical for vessel safety and anchorage suitability assessment. [ENUM-REF-CANDIDATE: mud|sand|clay|rock|gravel|coral|mixed|unknown — 8 candidates stripped; promote to reference product]',
    `isps_security_zone` STRING COMMENT 'ISPS security zone classification for the anchorage area. Determines access control and security monitoring requirements.. Valid values are `level_1|level_2|level_3|restricted|public|none`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this anchorage area record was last updated or modified in the system.',
    `last_survey_date` DATE COMMENT 'Date of the most recent hydrographic survey conducted for this anchorage area to verify water depths and seabed conditions.',
    `latitude_center_decimal` DECIMAL(18,2) COMMENT 'Latitude coordinate of the anchorage area center point in decimal degrees (WGS84). Used for mapping, navigation, and distance calculations.',
    `lighting_aids_description` STRING COMMENT 'Description of navigational lighting aids and markers that define or support the anchorage area (e.g., buoys, beacons, range lights).',
    `longitude_center_decimal` DECIMAL(18,2) COMMENT 'Longitude coordinate of the anchorage area center point in decimal degrees (WGS84). Used for mapping, navigation, and distance calculations.',
    `maximum_vessel_beam_meters` DECIMAL(18,2) COMMENT 'Maximum permissible vessel beam (width) in meters for vessels using this anchorage area.',
    `maximum_vessel_dwt` DECIMAL(18,2) COMMENT 'Maximum permissible vessel DWT that can safely use this anchorage area. Constraint based on water depth, holding ground, and operational safety considerations.',
    `maximum_vessel_loa_meters` DECIMAL(18,2) COMMENT 'Maximum permissible vessel LOA in meters that can safely anchor in this area. Constraint based on swinging circle radius and anchorage dimensions.',
    `maximum_vessels_simultaneously` STRING COMMENT 'Maximum number of vessels that can safely occupy this anchorage area at the same time, based on area dimensions and swinging circle requirements.',
    `next_survey_due_date` DATE COMMENT 'Scheduled date for the next hydrographic survey of this anchorage area to ensure continued accuracy of depth and seabed data.',
    `operational_status` STRING COMMENT 'Current operational status of the anchorage area. Active indicates available for vessel allocation; inactive/closed indicates unavailable; suspended/maintenance indicates temporary unavailability; restricted indicates limited access.. Valid values are `active|inactive|suspended|maintenance|restricted|closed`',
    `pilotage_required_flag` BOOLEAN COMMENT 'Indicates whether marine pilotage services are mandatory for vessels entering or departing this anchorage area. True if pilotage is required, False if not required.',
    `remarks` STRING COMMENT 'Additional operational notes, special instructions, or important information regarding the use of this anchorage area not captured in other structured fields.',
    `swinging_circle_radius_meters` DECIMAL(18,2) COMMENT 'Required radius in meters for the swinging circle to accommodate vessel movement while at anchor. Calculated based on vessel LOA plus anchor chain scope.',
    `tidal_range_meters` DECIMAL(18,2) COMMENT 'Average tidal range in meters at the anchorage location. Difference between mean high water and mean low water. Critical for depth calculations and vessel safety.',
    `vts_monitoring_zone_reference` STRING COMMENT 'Reference code for the VTS monitoring zone that covers this anchorage area. Links to VTMS operational zones for traffic management.',
    `water_depth_maximum_meters` DECIMAL(18,2) COMMENT 'Maximum water depth within the anchorage area measured in meters at Chart Datum. Defines the depth range of the anchorage.',
    `water_depth_minimum_meters` DECIMAL(18,2) COMMENT 'Minimum water depth within the anchorage area measured in meters at Chart Datum. Used to determine vessel draft limitations.',
    `wind_exposure_category` STRING COMMENT 'Classification of the anchorage area based on exposure to prevailing winds and weather conditions. Affects vessel safety and anchorage suitability.. Valid values are `sheltered|moderate|exposed|highly_exposed`',
    CONSTRAINT pk_anchorage_area PRIMARY KEY(`anchorage_area_id`)
) COMMENT 'Master record for designated anchorage areas within port waters and approaches. Captures anchorage name, anchorage code, chart reference, geographic boundary (polygon coordinates), holding ground type (mud, sand, clay, rock), water depth range at Chart Datum, swinging circle radius requirements, maximum permissible vessel DWT, maximum LOA, maximum beam, maximum number of vessels simultaneously, ISPS security zone classification, VTS monitoring zone reference, anchorage category (general, quarantine, explosives, STS transfer, waiting), pilotage requirement flag, and operational status. Used by VTMS for anchorage allocation and vessel traffic management. Supports IMO anchorage designation standards.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` (
    `facility_id` BIGINT COMMENT 'Primary key for facility',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Facilities are licensed and certified for specific commodity types (liquid bulk terminals, grain silos, chemical storage). Regulatory compliance reporting, environmental permits, and cargo handling ce',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Facilities (dry docks, ship repair yards, ro-ro ramps) are designed for specific vessel types. Port commercial teams use this for facility marketing, vessel acceptance decisions, and utilization repor',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Port facilities (container terminals, repair yards, cargo handling facilities) require ISPS Port Facility Security Plans and records. berth, warehouse, and port_gate already carry this FK — facility f',
    `parent_facility_id` BIGINT COMMENT 'Self-referencing FK on facility (parent_facility_id)',
    `port_id` BIGINT COMMENT 'Foreign key linking to infrastructure.port. Business justification: A facility is a port infrastructure entity (terminal, repair facility, service facility) that belongs to a specific port. facility currently has no in-domain FK to port despite being the master refere',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the terminal operator or concessionaire responsible for operating this facility.',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: A facility (e.g., CFS shed, repair shop, service building) is physically located within a terminal zone. Adding terminal_zone_id to facility enables zone-level facility management, supports terminal z',
    `address_line1` STRING COMMENT 'Primary street address line of the facility location for operational and administrative purposes.',
    `address_line2` STRING COMMENT 'Secondary address line for additional location details such as building or suite information.',
    `annual_throughput_tonnes` DECIMAL(18,2) COMMENT 'Average annual cargo throughput handled by the facility, measured in metric tonnes. Key performance indicator for capacity planning.',
    `aveva_asset_reference` STRING COMMENT 'External identifier linking this facility to AVEVA Marine Engineering system for design and engineering integration.',
    `berth_length_m` DECIMAL(18,2) COMMENT 'Total length of the berth or quay wall measured in meters. Critical for vessel berthing planning.',
    `bollard_pull_capacity_tonnes` DECIMAL(18,2) COMMENT 'Maximum bollard pull capacity for mooring operations, measured in tonnes. Indicates the strength of mooring infrastructure.',
    `capacity_teu` DECIMAL(18,2) COMMENT 'Maximum container handling capacity of the facility measured in TEU. Applicable to container terminals and yards.',
    `city` STRING COMMENT 'City or municipality where the facility is located.',
    `facility_code` STRING COMMENT 'Externally-known unique alphanumeric code for the facility, used in operational systems and port documentation.',
    `commissioning_date` DATE COMMENT 'Date when the facility was officially commissioned and became operational.',
    `construction_cost_usd` DECIMAL(18,2) COMMENT 'Total capital cost of constructing the facility, measured in USD. Used for asset valuation and CAPEX tracking.',
    `contact_email` STRING COMMENT 'Primary email address for facility operations and administrative communication.',
    `contact_phone` STRING COMMENT 'Primary contact phone number for facility operations and coordination.',
    `country_code` STRING COMMENT 'Three-letter ISO country code indicating the country where the facility is located.',
    `crane_capacity_tonnes` DECIMAL(18,2) COMMENT 'Maximum lifting capacity of cranes installed at the facility, measured in tonnes. Applicable to container and cargo terminals.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this facility record was first created in the system.',
    `dangerous_goods_certified` BOOLEAN COMMENT 'Indicates whether the facility is certified and equipped to handle dangerous goods and hazardous materials per IMDG Code.',
    `environmental_certification` STRING COMMENT 'Environmental certifications held by the facility (e.g., ISO 14001, EcoPort, Green Marine).',
    `facility_status` STRING COMMENT 'Current lifecycle status of the facility indicating its availability and operational state.',
    `facility_type` STRING COMMENT 'Classification of the facility by its primary operational purpose within the port infrastructure.',
    `fender_system_type` STRING COMMENT 'Type of fender system installed at the berth to absorb berthing energy and protect vessels and infrastructure.',
    `isps_compliant` BOOLEAN COMMENT 'Indicates whether the facility meets ISPS Code security requirements for port facility security.',
    `last_dredging_date` DATE COMMENT 'Date of the most recent dredging operation performed to maintain water depth at the facility.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the facility in decimal degrees for geospatial mapping and navigation.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the facility in decimal degrees for geospatial mapping and navigation.',
    `max_vessel_beam_m` DECIMAL(18,2) COMMENT 'Maximum beam (width) of vessels that can be accommodated at this facility, measured in meters.',
    `max_vessel_draft_m` DECIMAL(18,2) COMMENT 'Maximum draft of vessels that can safely berth at this facility, measured in meters.',
    `max_vessel_loa_m` DECIMAL(18,2) COMMENT 'Maximum length overall of vessels that can be accommodated at this facility, measured in meters.',
    `facility_name` STRING COMMENT 'Official name of the port facility (e.g., berth name, warehouse name, terminal name).',
    `next_maintenance_date` DATE COMMENT 'Scheduled date for the next planned maintenance activity for the facility infrastructure.',
    `number_of_cranes` STRING COMMENT 'Total count of operational cranes available at the facility for cargo handling operations.',
    `operating_hours` STRING COMMENT 'Standard operating hours for the facility (e.g., 24/7, business hours, shift-based).',
    `ownership_type` STRING COMMENT 'Classification of facility ownership structure indicating whether it is publicly owned, privately operated, or under concession.',
    `postal_code` STRING COMMENT 'Postal or ZIP code for the facility address.',
    `reefer_points_count` STRING COMMENT 'Number of electrical connection points available for refrigerated containers at the facility.',
    `remarks` STRING COMMENT 'Additional notes, comments, or special instructions related to the facility operations or characteristics.',
    `state_province` STRING COMMENT 'State, province, or administrative region where the facility is located.',
    `storage_area_sqm` DECIMAL(18,2) COMMENT 'Total covered or open storage area available at the facility, measured in square meters. Applicable to warehouses and yards.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this facility record was last modified in the system.',
    `utilization_rate_pct` DECIMAL(18,2) COMMENT 'Current utilization rate of the facility expressed as a percentage of total capacity. Used for capacity planning and expansion analysis.',
    `water_depth_m` DECIMAL(18,2) COMMENT 'Maintained water depth alongside the berth or facility measured in meters below chart datum. Determines maximum vessel draft.',
    CONSTRAINT pk_facility PRIMARY KEY(`facility_id`)
) COMMENT 'Master reference table for facility. Referenced by facility_id.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` (
    `port_id` BIGINT COMMENT 'Primary key for port',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Ports operate under the jurisdiction of a specific country for port state control, customs authority, sanctions compliance, and ISPS regulatory reporting. Port has country_code as a denormalized plain',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Ports have a maximum vessel type capability (ULCC-capable, New Panamax, Handymax). Shipping lines use this for vessel routing and port selection; port authorities publish this for commercial marketing',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Each port is managed or operated by a port authority or concession holder who is a registered port community participant. Port governance reporting, regulatory submissions, and concession management r',
    `parent_port_id` BIGINT COMMENT 'Self-referencing FK on port (parent_port_id)',
    `address_line1` STRING COMMENT 'Primary street address of the port administrative office or main entrance.',
    `address_line2` STRING COMMENT 'Secondary address information such as building name, suite number, or additional location details.',
    `annual_cargo_tonnage` BIGINT COMMENT 'Total annual cargo throughput measured in metric tons, including containerized and bulk cargo.',
    `annual_throughput_teu` BIGINT COMMENT 'Annual container handling capacity or actual throughput measured in TEU (Twenty-foot Equivalent Units).',
    `bunkering_available` BOOLEAN COMMENT 'Indicates whether the port provides bunkering (fuel supply) services for vessels.',
    `channel_depth_m` DECIMAL(18,2) COMMENT 'Maintained depth of the main navigation channel providing access to the port, measured in meters.',
    `city` STRING COMMENT 'Name of the city or municipality where the port is located.',
    `port_code` STRING COMMENT 'Five-character UN/LOCODE uniquely identifying the port location for international trade and logistics. Format: 2-letter country code + 3-letter location code.',
    `contact_email` STRING COMMENT 'Primary email address for port inquiries, vessel scheduling, and operational communications.',
    `contact_phone` STRING COMMENT 'Primary contact telephone number for the port authority or operations center.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this port record was first created in the system.',
    `customs_facility` BOOLEAN COMMENT 'Indicates whether the port has on-site customs clearance facilities for import/export processing.',
    `environmental_certification` STRING COMMENT 'Type of environmental certification held by the port, such as EcoPort, Green Marine, or ISO 14001.',
    `established_date` DATE COMMENT 'Date when the port was officially established or began operations.',
    `free_trade_zone` BOOLEAN COMMENT 'Indicates whether the port operates a designated free trade zone or foreign trade zone for duty-deferred cargo.',
    `hazmat_certified` BOOLEAN COMMENT 'Indicates whether the port is certified to handle hazardous materials and dangerous goods according to IMDG Code.',
    `iso_certified` BOOLEAN COMMENT 'Indicates whether the port holds ISO certification for quality management, environmental management, or other standards.',
    `isps_compliant` BOOLEAN COMMENT 'Indicates whether the port is compliant with the ISPS Code for maritime security.',
    `last_dredging_date` DATE COMMENT 'Date of the most recent dredging operation to maintain channel and berth depths.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the port in decimal degrees, used for navigation and vessel routing.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the port in decimal degrees, used for navigation and vessel routing.',
    `max_vessel_beam_m` DECIMAL(18,2) COMMENT 'Maximum beam width of vessels that can be accommodated at the port, measured in meters.',
    `max_vessel_draft_m` DECIMAL(18,2) COMMENT 'Maximum draft depth of vessels that can safely enter and berth at the port, measured in meters below waterline.',
    `max_vessel_length_m` DECIMAL(18,2) COMMENT 'Maximum length of vessel that can be accommodated at the port, measured in meters.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this port record was last modified or updated.',
    `port_name` STRING COMMENT 'Official name of the port facility as recognized by maritime authorities and international shipping organizations.',
    `number_of_berths` STRING COMMENT 'Total count of berths available at the port for vessel mooring and cargo operations.',
    `number_of_cranes` STRING COMMENT 'Total count of cargo handling cranes including ship-to-shore (STS), gantry, and mobile cranes available at the port.',
    `operating_hours` STRING COMMENT 'Standard operating hours of the port, indicating whether it operates 24/7 or has specific operational windows.',
    `operational_status` STRING COMMENT 'Current operational state of the port facility indicating its availability for vessel operations and cargo handling.',
    `ownership_type` STRING COMMENT 'Legal ownership structure of the port facility indicating whether it is publicly owned, privately operated, or a hybrid model.',
    `pilot_required` BOOLEAN COMMENT 'Indicates whether maritime pilot services are mandatory for vessels entering or leaving the port.',
    `port_type` STRING COMMENT 'Classification of the port based on its primary operational function and geographic location.',
    `postal_code` STRING COMMENT 'Postal or ZIP code for the port location used for mail delivery and geographic identification.',
    `rail_connected` BOOLEAN COMMENT 'Indicates whether the port has direct rail connectivity for intermodal cargo transfer.',
    `reefer_connections` STRING COMMENT 'Number of electrical connection points available for refrigerated containers requiring temperature control.',
    `region` STRING COMMENT 'Geographic region or state/province within the country where the port is situated.',
    `road_connected` BOOLEAN COMMENT 'Indicates whether the port has direct road access for truck-based cargo transfer.',
    `ship_repair_facilities` BOOLEAN COMMENT 'Indicates whether the port has ship repair and maintenance facilities including dry docks or floating docks.',
    `storage_capacity_sqm` DECIMAL(18,2) COMMENT 'Total covered and open storage area available for cargo, measured in square meters.',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the port location used for scheduling vessel arrivals, departures, and operational planning.',
    `total_area_sqm` DECIMAL(18,2) COMMENT 'Total land area of the port facility measured in square meters, including terminals, warehouses, and operational zones.',
    `total_quay_length_m` DECIMAL(18,2) COMMENT 'Combined length of all quay walls and wharves measured in meters, indicating the ports vessel accommodation capacity.',
    `tug_services_available` BOOLEAN COMMENT 'Indicates whether tugboat services are available at the port for vessel maneuvering and berthing assistance.',
    `water_area_sqm` DECIMAL(18,2) COMMENT 'Total water area within port jurisdiction measured in square meters, including berths, anchorage zones, and navigational channels.',
    `website_url` STRING COMMENT 'Official website URL of the port authority providing information on services, tariffs, and operations.',
    CONSTRAINT pk_port PRIMARY KEY(`port_id`)
) COMMENT 'Master reference table for port. Referenced by port_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ADD CONSTRAINT `fk_infrastructure_quay_wall_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ADD CONSTRAINT `fk_infrastructure_quay_wall_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ADD CONSTRAINT `fk_infrastructure_channel_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ADD CONSTRAINT `fk_infrastructure_anchorage_area_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ADD CONSTRAINT `fk_infrastructure_facility_parent_facility_id` FOREIGN KEY (`parent_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility`(`facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ADD CONSTRAINT `fk_infrastructure_facility_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ADD CONSTRAINT `fk_infrastructure_facility_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ADD CONSTRAINT `fk_infrastructure_port_parent_port_id` FOREIGN KEY (`parent_port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`infrastructure` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`infrastructure` SET TAGS ('dbx_domain' = 'infrastructure');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` SET TAGS ('dbx_subdomain' = 'waterfront_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Design Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `quay_wall_id` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `annual_throughput_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Annual Throughput Capacity (TEU - Twenty-foot Equivalent Unit)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `aveva_reference_code` SET TAGS ('dbx_business_glossary_term' = 'AVEVA Marine Engineering Reference Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `berth_number` SET TAGS ('dbx_business_glossary_term' = 'Berth Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `berth_type` SET TAGS ('dbx_business_glossary_term' = 'Berth Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `berth_type` SET TAGS ('dbx_value_regex' = 'container|bulk|general_cargo|roro|tanker|cruise');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `bollard_count` SET TAGS ('dbx_business_glossary_term' = 'Bollard Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `bollard_swl_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Bollard Safe Working Load (SWL) (Tonnes)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `cfs_proximity_flag` SET TAGS ('dbx_business_glossary_term' = 'Container Freight Station (CFS) Proximity Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `fender_condition` SET TAGS ('dbx_business_glossary_term' = 'Fender Condition');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `fender_condition` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `fender_energy_absorption_kj` SET TAGS ('dbx_business_glossary_term' = 'Fender Energy Absorption (Kilojoules)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `fender_reaction_force_kn` SET TAGS ('dbx_business_glossary_term' = 'Fender Reaction Force (Kilonewtons)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `fender_system_type` SET TAGS ('dbx_business_glossary_term' = 'Fender System Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `isps_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Compliant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `last_dredging_date` SET TAGS ('dbx_business_glossary_term' = 'Last Dredging Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `length_m` SET TAGS ('dbx_business_glossary_term' = 'Berth Length (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `loa_capacity_m` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) Capacity (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `max_draft_m` SET TAGS ('dbx_business_glossary_term' = 'Maximum Draft (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `max_dwt_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Maximum Deadweight Tonnage (DWT) (Tonnes)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `mooring_fitting_types` SET TAGS ('dbx_business_glossary_term' = 'Mooring Fitting Types');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `berth_name` SET TAGS ('dbx_business_glossary_term' = 'Berth Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `next_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'operational|under_maintenance|out_of_service|planned|decommissioned');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `rail_connection_flag` SET TAGS ('dbx_business_glossary_term' = 'Rail Connection Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `shore_crane_count` SET TAGS ('dbx_business_glossary_term' = 'Shore Crane Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `shore_power_available_flag` SET TAGS ('dbx_business_glossary_term' = 'Shore Power Available Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `shore_power_capacity_kw` SET TAGS ('dbx_business_glossary_term' = 'Shore Power Capacity (Kilowatts)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `tidal_constraint_flag` SET TAGS ('dbx_business_glossary_term' = 'Tidal Constraint Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `tidal_range_m` SET TAGS ('dbx_business_glossary_term' = 'Tidal Range (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `warehouse_proximity_flag` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Proximity Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `water_depth_alongside_m` SET TAGS ('dbx_business_glossary_term' = 'Water Depth Alongside (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` SET TAGS ('dbx_subdomain' = 'waterfront_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `quay_wall_id` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Design Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `asset_owner` SET TAGS ('dbx_business_glossary_term' = 'Asset Owner Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `asset_owner` SET TAGS ('dbx_value_regex' = 'port_authority|terminal_operator|government|private|joint_venture');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `bollard_spacing_m` SET TAGS ('dbx_business_glossary_term' = 'Bollard Spacing (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `bollard_swl_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Bollard Safe Working Load (Tonnes)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `construction_material` SET TAGS ('dbx_business_glossary_term' = 'Primary Construction Material');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `construction_material` SET TAGS ('dbx_value_regex' = 'reinforced_concrete|steel|composite|masonry|timber');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `crane_rail_gauge_mm` SET TAGS ('dbx_business_glossary_term' = 'Crane Rail Gauge (Millimeters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `crane_rail_present` SET TAGS ('dbx_business_glossary_term' = 'Crane Rail Present Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `current_depth_m` SET TAGS ('dbx_business_glossary_term' = 'Current Water Depth (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `design_depth_m` SET TAGS ('dbx_business_glossary_term' = 'Design Water Depth (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `design_load_capacity_kn_per_m2` SET TAGS ('dbx_business_glossary_term' = 'Design Load Capacity (Kilonewtons per Square Meter)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `design_standard` SET TAGS ('dbx_business_glossary_term' = 'Design Standard Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `environmental_monitoring` SET TAGS ('dbx_business_glossary_term' = 'Environmental Monitoring Enabled Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `fender_system_type` SET TAGS ('dbx_business_glossary_term' = 'Fender System Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `geographic_coordinates` SET TAGS ('dbx_business_glossary_term' = 'Geographic Coordinates');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `imdg_compliant` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Compliant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Policy Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `isps_compliant` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Compliant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `last_dredging_date` SET TAGS ('dbx_business_glossary_term' = 'Last Dredging Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Structural Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `lighting_system_type` SET TAGS ('dbx_business_glossary_term' = 'Lighting System Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `lighting_system_type` SET TAGS ('dbx_value_regex' = 'led|halogen|sodium_vapor|none');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `maintenance_responsibility` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Responsibility');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `maintenance_responsibility` SET TAGS ('dbx_value_regex' = 'port_authority|terminal_operator|contractor|shared');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `max_vessel_dwt_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Maximum Vessel Deadweight Tonnage (DWT) in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `max_vessel_loa_m` SET TAGS ('dbx_business_glossary_term' = 'Maximum Vessel Length Overall (LOA) in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'operational|restricted|closed|under_maintenance|under_construction');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `permitted_cargo_types` SET TAGS ('dbx_business_glossary_term' = 'Permitted Cargo Types');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `replacement_value_usd` SET TAGS ('dbx_business_glossary_term' = 'Replacement Value (United States Dollars)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `replacement_value_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `seismic_design_category` SET TAGS ('dbx_business_glossary_term' = 'Seismic Design Category');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `seismic_design_category` SET TAGS ('dbx_value_regex' = 'none|low|moderate|high|very_high');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `structural_condition_rating` SET TAGS ('dbx_business_glossary_term' = 'Structural Condition Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `structural_condition_rating` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `tidal_range_m` SET TAGS ('dbx_business_glossary_term' = 'Tidal Range (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `total_length_m` SET TAGS ('dbx_business_glossary_term' = 'Total Length (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `utility_services` SET TAGS ('dbx_business_glossary_term' = 'Utility Services Available');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `wall_code` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `wall_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `wall_name` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `wall_type` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Construction Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `wall_type` SET TAGS ('dbx_value_regex' = 'gravity|sheet_pile|caisson|piled|diaphragm|cellular');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `year_built` SET TAGS ('dbx_business_glossary_term' = 'Year Built');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` SET TAGS ('dbx_subdomain' = 'waterfront_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `sla_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Profile Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `access_control_system` SET TAGS ('dbx_business_glossary_term' = 'Access Control System');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `access_control_system` SET TAGS ('dbx_value_regex' = 'rfid_gate|biometric|card_reader|manual|none');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `active_flag` SET TAGS ('dbx_business_glossary_term' = 'Active Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `boundary_coordinates_wkt` SET TAGS ('dbx_business_glossary_term' = 'Boundary Coordinates (Well-Known Text)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `cctv_coverage_flag` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Coverage Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `centroid_latitude` SET TAGS ('dbx_business_glossary_term' = 'Centroid Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `centroid_latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `centroid_latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `centroid_longitude` SET TAGS ('dbx_business_glossary_term' = 'Centroid Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `centroid_longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `centroid_longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `customs_controlled_flag` SET TAGS ('dbx_business_glossary_term' = 'Customs Controlled Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `design_capacity_utilization_pct` SET TAGS ('dbx_business_glossary_term' = 'Design Capacity Utilization Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `drainage_system_type` SET TAGS ('dbx_business_glossary_term' = 'Drainage System Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `drainage_system_type` SET TAGS ('dbx_value_regex' = 'storm_sewer|retention_pond|permeable_pavement|none');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `environmental_monitoring_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Monitoring Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `fire_suppression_system` SET TAGS ('dbx_business_glossary_term' = 'Fire Suppression System');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `fire_suppression_system` SET TAGS ('dbx_value_regex' = 'hydrant_network|foam_system|sprinkler|none');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `ground_slot_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Ground Slot Capacity (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `handling_equipment_type` SET TAGS ('dbx_business_glossary_term' = 'Handling Equipment Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `handling_equipment_type` SET TAGS ('dbx_value_regex' = 'rtg|asc|reach_stacker|forklift|mobile_crane|none');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `hazmat_approved_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Approved Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `last_resurfacing_date` SET TAGS ('dbx_business_glossary_term' = 'Last Resurfacing Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `lease_status` SET TAGS ('dbx_business_glossary_term' = 'Lease Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `lease_status` SET TAGS ('dbx_value_regex' = 'port_operated|leased_terminal_operator|leased_cargo_owner|subleased|vacant');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `lighting_type` SET TAGS ('dbx_business_glossary_term' = 'Lighting Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `lighting_type` SET TAGS ('dbx_value_regex' = 'led_high_mast|halogen_flood|none');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `maximum_stack_height` SET TAGS ('dbx_business_glossary_term' = 'Maximum Stack Height');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'operational|maintenance|closed|planned|decommissioned');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `paved_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Paved Area (Square Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `pavement_condition_rating` SET TAGS ('dbx_business_glossary_term' = 'Pavement Condition Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `pavement_condition_rating` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `rail_access_flag` SET TAGS ('dbx_business_glossary_term' = 'Rail Access Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `record_source_system` SET TAGS ('dbx_business_glossary_term' = 'Record Source System');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `record_source_system` SET TAGS ('dbx_value_regex' = 'navis_n4|aveva_marine|manual_entry|gis_import|legacy_migration');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `reefer_plug_count` SET TAGS ('dbx_business_glossary_term' = 'Reefer Plug Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `security_level` SET TAGS ('dbx_business_glossary_term' = 'Security Level (ISPS)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `security_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `total_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Total Area (Square Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `total_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Total Capacity (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `truck_access_flag` SET TAGS ('dbx_business_glossary_term' = 'Truck Access Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `vessel_side_flag` SET TAGS ('dbx_business_glossary_term' = 'Vessel Side Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `weighbridge_available_flag` SET TAGS ('dbx_business_glossary_term' = 'Weighbridge Available Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `zone_type` SET TAGS ('dbx_business_glossary_term' = 'Zone Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` SET TAGS ('dbx_subdomain' = 'waterfront_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Lessee Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `participant_account_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `access_control_system` SET TAGS ('dbx_business_glossary_term' = 'Access Control System');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `access_control_system` SET TAGS ('dbx_value_regex' = 'manual|card_reader|biometric|rfid|integrated');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `bonded_status` SET TAGS ('dbx_business_glossary_term' = 'Bonded Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `cctv_coverage` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Coverage');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `warehouse_code` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `warehouse_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `construction_year` SET TAGS ('dbx_business_glossary_term' = 'Construction Year');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `contact_email` SET TAGS ('dbx_business_glossary_term' = 'Contact Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `customs_license_number` SET TAGS ('dbx_business_glossary_term' = 'Customs License Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `customs_license_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `environmental_certification` SET TAGS ('dbx_business_glossary_term' = 'Environmental Certification');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `fire_suppression_system_type` SET TAGS ('dbx_business_glossary_term' = 'Fire Suppression System Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `floor_load_capacity_kn_per_sqm` SET TAGS ('dbx_business_glossary_term' = 'Floor Load Capacity (Kilonewtons per Square Meter)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `geo_latitude` SET TAGS ('dbx_business_glossary_term' = 'Geographic Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `geo_latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `geo_latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `geo_longitude` SET TAGS ('dbx_business_glossary_term' = 'Geographic Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `geo_longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `geo_longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `height_clearance_m` SET TAGS ('dbx_business_glossary_term' = 'Height Clearance (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `insurance_coverage_amount` SET TAGS ('dbx_business_glossary_term' = 'Insurance Coverage Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `insurance_coverage_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Policy Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `last_major_renovation_year` SET TAGS ('dbx_business_glossary_term' = 'Last Major Renovation Year');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `lease_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Lease Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `loading_bay_count` SET TAGS ('dbx_business_glossary_term' = 'Loading Bay Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `material_handling_equipment` SET TAGS ('dbx_business_glossary_term' = 'Material Handling Equipment');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `max_forklift_capacity_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Maximum Forklift Capacity (Tonnes)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `warehouse_name` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `operating_hours` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `operating_hours` SET TAGS ('dbx_value_regex' = '24x7|business_hours|extended|custom');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'operational|maintenance|inactive|decommissioned|under_construction|planned');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `ownership_type` SET TAGS ('dbx_business_glossary_term' = 'Ownership Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `ownership_type` SET TAGS ('dbx_value_regex' = 'port_owned|leased|joint_venture|third_party|concession');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `rail_access_available` SET TAGS ('dbx_business_glossary_term' = 'Rail Access Available');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `reefer_plug_count` SET TAGS ('dbx_business_glossary_term' = 'Reefer Plug Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `security_level` SET TAGS ('dbx_business_glossary_term' = 'Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `security_level` SET TAGS ('dbx_value_regex' = 'standard|enhanced|isps_compliant|high_value');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `temperature_control_capability` SET TAGS ('dbx_business_glossary_term' = 'Temperature Control Capability');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `temperature_control_capability` SET TAGS ('dbx_value_regex' = 'none|refrigerated|climate_controlled|frozen|multi_zone');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `temperature_range_max_c` SET TAGS ('dbx_business_glossary_term' = 'Maximum Temperature Range (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `temperature_range_min_c` SET TAGS ('dbx_business_glossary_term' = 'Minimum Temperature Range (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `total_floor_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Total Floor Area (Square Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `usable_storage_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Usable Storage Area (Square Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `warehouse_type` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` SET TAGS ('dbx_subdomain' = 'navigation_routes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Max Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `participant_service_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Participant Service Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `bearing_degrees` SET TAGS ('dbx_business_glossary_term' = 'Channel Bearing (Degrees)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `channel_type` SET TAGS ('dbx_business_glossary_term' = 'Channel Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `channel_type` SET TAGS ('dbx_value_regex' = 'approach|fairway|berthing_channel|turning_basin|anchorage_access|inner_harbor');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `chart_reference` SET TAGS ('dbx_business_glossary_term' = 'Nautical Chart Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `channel_code` SET TAGS ('dbx_business_glossary_term' = 'Channel Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `current_maintained_depth_cd_m` SET TAGS ('dbx_business_glossary_term' = 'Current Maintained Depth Chart Datum (CD) in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `design_depth_cd_m` SET TAGS ('dbx_business_glossary_term' = 'Design Depth Chart Datum (CD) in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `design_width_m` SET TAGS ('dbx_business_glossary_term' = 'Design Width (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `dredging_authority` SET TAGS ('dbx_business_glossary_term' = 'Dredging Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `environmental_sensitivity_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Sensitivity Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `last_dredging_date` SET TAGS ('dbx_business_glossary_term' = 'Last Dredging Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `last_survey_date` SET TAGS ('dbx_business_glossary_term' = 'Last Survey Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `max_permissible_beam_m` SET TAGS ('dbx_business_glossary_term' = 'Maximum Permissible Beam (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `max_permissible_draft_m` SET TAGS ('dbx_business_glossary_term' = 'Maximum Permissible Draft (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `max_permissible_dwt` SET TAGS ('dbx_business_glossary_term' = 'Maximum Permissible Deadweight Tonnage (DWT)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `max_permissible_loa_m` SET TAGS ('dbx_business_glossary_term' = 'Maximum Permissible Length Overall (LOA) in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `minimum_depth_cd_m` SET TAGS ('dbx_business_glossary_term' = 'Minimum Depth Chart Datum (CD) in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `channel_name` SET TAGS ('dbx_business_glossary_term' = 'Channel Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `navigational_aids_description` SET TAGS ('dbx_business_glossary_term' = 'Navigational Aids Description');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `next_scheduled_survey_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Survey Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'operational|restricted|closed|under_maintenance|dredging_in_progress');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `pilotage_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `sedimentation_rate_m_per_year` SET TAGS ('dbx_business_glossary_term' = 'Sedimentation Rate (Meters per Year)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `survey_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Survey Frequency (Months)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `tidal_window_restriction` SET TAGS ('dbx_business_glossary_term' = 'Tidal Window Restriction');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `total_length_nm` SET TAGS ('dbx_business_glossary_term' = 'Total Length (Nautical Miles)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `towage_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Towage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `two_way_traffic_permitted_flag` SET TAGS ('dbx_business_glossary_term' = 'Two-Way Traffic Permitted Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `under_keel_clearance_m` SET TAGS ('dbx_business_glossary_term' = 'Under-Keel Clearance (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `vts_monitoring_zone` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service (VTS) Monitoring Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` SET TAGS ('dbx_subdomain' = 'navigation_routes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `equipment_class_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Equipment Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Supervisor Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `port_location_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `port_location_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Primary User Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `access_control_system_reference` SET TAGS ('dbx_business_glossary_term' = 'Access Control System Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `appointment_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Appointment Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `average_processing_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Average Processing Time in Minutes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `cctv_coverage_flag` SET TAGS ('dbx_business_glossary_term' = 'Closed-Circuit Television (CCTV) Coverage Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `customs_inspection_point_flag` SET TAGS ('dbx_business_glossary_term' = 'Customs Inspection Point Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `daily_throughput_capacity` SET TAGS ('dbx_business_glossary_term' = 'Daily Throughput Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `port_gate_description` SET TAGS ('dbx_business_glossary_term' = 'Gate Description');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `emergency_access_flag` SET TAGS ('dbx_business_glossary_term' = 'Emergency Access Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `gate_code` SET TAGS ('dbx_business_glossary_term' = 'Gate Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `gate_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `gate_direction` SET TAGS ('dbx_business_glossary_term' = 'Gate Direction');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `gate_direction` SET TAGS ('dbx_value_regex' = 'inbound|outbound|bidirectional');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `gate_name` SET TAGS ('dbx_business_glossary_term' = 'Gate Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `gate_type` SET TAGS ('dbx_business_glossary_term' = 'Gate Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `hazmat_clearance_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Clearance Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `inbound_lanes` SET TAGS ('dbx_business_glossary_term' = 'Inbound Lanes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `isps_security_zone` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Security Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `isps_security_zone` SET TAGS ('dbx_value_regex' = 'public|port_facility|restricted|secure');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude Coordinate');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude Coordinate');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `maximum_vehicle_height_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Vehicle Height in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `maximum_vehicle_length_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Vehicle Length in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `maximum_vehicle_width_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Vehicle Width in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `next_scheduled_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `number_of_lanes` SET TAGS ('dbx_business_glossary_term' = 'Number of Lanes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `ocr_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Optical Character Recognition (OCR) Enabled Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `operating_hours_end` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `operating_hours_end` SET TAGS ('dbx_value_regex' = '^([01]d|2[0-3]):([0-5]d)$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `operating_hours_start` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `operating_hours_start` SET TAGS ('dbx_value_regex' = '^([01]d|2[0-3]):([0-5]d)$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'operational|closed|maintenance|suspended|decommissioned');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `outbound_lanes` SET TAGS ('dbx_business_glossary_term' = 'Outbound Lanes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `rfid_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Radio Frequency Identification (RFID) Enabled Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `twenty_four_hour_operation_flag` SET TAGS ('dbx_business_glossary_term' = 'Twenty-Four Hour Operation Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `weighbridge_integrated_flag` SET TAGS ('dbx_business_glossary_term' = 'Weighbridge Integrated Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` SET TAGS ('dbx_subdomain' = 'navigation_routes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Designated Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `ais_monitoring_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Automatic Identification System (AIS) Monitoring Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `anchorage_category` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Category');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `anchorage_code` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `anchorage_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `anchorage_name` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `area_size_square_meters` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Size (Square Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `chart_reference` SET TAGS ('dbx_business_glossary_term' = 'Nautical Chart Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `communication_channel_vhf` SET TAGS ('dbx_business_glossary_term' = 'Very High Frequency (VHF) Communication Channel');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `communication_channel_vhf` SET TAGS ('dbx_value_regex' = '^(VHFs)?[0-9]{1,2}[A-Z]?$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `current_speed_max_knots` SET TAGS ('dbx_business_glossary_term' = 'Maximum Current Speed (Knots)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `designated_use_restrictions` SET TAGS ('dbx_business_glossary_term' = 'Designated Use Restrictions');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `designation_authority` SET TAGS ('dbx_business_glossary_term' = 'Designation Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `designation_date` SET TAGS ('dbx_business_glossary_term' = 'Official Designation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `distance_to_berth_nm` SET TAGS ('dbx_business_glossary_term' = 'Distance to Nearest Berth (Nautical Miles)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `distance_to_pilot_boarding_nm` SET TAGS ('dbx_business_glossary_term' = 'Distance to Pilot Boarding Ground (Nautical Miles)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `dredging_maintenance_frequency` SET TAGS ('dbx_business_glossary_term' = 'Dredging Maintenance Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `dredging_maintenance_frequency` SET TAGS ('dbx_value_regex' = 'annual|biannual|quarterly|as_needed|none');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `emergency_anchorage_flag` SET TAGS ('dbx_business_glossary_term' = 'Emergency Anchorage Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `environmental_sensitivity_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Sensitivity Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `geographic_boundary_polygon` SET TAGS ('dbx_business_glossary_term' = 'Geographic Boundary Polygon Coordinates');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `holding_ground_type` SET TAGS ('dbx_business_glossary_term' = 'Holding Ground Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `isps_security_zone` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Security Zone Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `isps_security_zone` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3|restricted|public|none');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `last_survey_date` SET TAGS ('dbx_business_glossary_term' = 'Last Hydrographic Survey Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `latitude_center_decimal` SET TAGS ('dbx_business_glossary_term' = 'Center Point Latitude (Decimal Degrees)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `latitude_center_decimal` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `latitude_center_decimal` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `lighting_aids_description` SET TAGS ('dbx_business_glossary_term' = 'Navigational Lighting Aids Description');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `longitude_center_decimal` SET TAGS ('dbx_business_glossary_term' = 'Center Point Longitude (Decimal Degrees)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `longitude_center_decimal` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `longitude_center_decimal` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `maximum_vessel_beam_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Vessel Beam (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `maximum_vessel_dwt` SET TAGS ('dbx_business_glossary_term' = 'Maximum Vessel Deadweight Tonnage (DWT)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `maximum_vessel_loa_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Vessel Length Overall (LOA) in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `maximum_vessels_simultaneously` SET TAGS ('dbx_business_glossary_term' = 'Maximum Number of Vessels Simultaneously');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `next_survey_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Hydrographic Survey Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|maintenance|restricted|closed');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `pilotage_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Pilotage Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Operational Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `swinging_circle_radius_meters` SET TAGS ('dbx_business_glossary_term' = 'Swinging Circle Radius Requirement (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `tidal_range_meters` SET TAGS ('dbx_business_glossary_term' = 'Tidal Range (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `vts_monitoring_zone_reference` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service (VTS) Monitoring Zone Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `water_depth_maximum_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Water Depth at Chart Datum (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `water_depth_minimum_meters` SET TAGS ('dbx_business_glossary_term' = 'Minimum Water Depth at Chart Datum (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `wind_exposure_category` SET TAGS ('dbx_business_glossary_term' = 'Wind Exposure Category');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `wind_exposure_category` SET TAGS ('dbx_value_regex' = 'sheltered|moderate|exposed|highly_exposed');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` SET TAGS ('dbx_subdomain' = 'navigation_routes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Design Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `parent_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Facility Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `parent_facility_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Operator Port Community Participant Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line1');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line2');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `annual_throughput_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Annual Throughput Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `aveva_asset_reference` SET TAGS ('dbx_business_glossary_term' = 'Aveva Asset Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `berth_length_m` SET TAGS ('dbx_business_glossary_term' = 'Berth Length M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `bollard_pull_capacity_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Bollard Pull Capacity Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Capacity Teu');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `construction_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Construction Cost Usd');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `construction_cost_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `contact_email` SET TAGS ('dbx_business_glossary_term' = 'Contact Email');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Contact Phone');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `crane_capacity_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Crane Capacity Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `dangerous_goods_certified` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Certified');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `environmental_certification` SET TAGS ('dbx_business_glossary_term' = 'Environmental Certification');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `facility_status` SET TAGS ('dbx_business_glossary_term' = 'Facility Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `facility_type` SET TAGS ('dbx_business_glossary_term' = 'Facility Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `fender_system_type` SET TAGS ('dbx_business_glossary_term' = 'Fender System Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `isps_compliant` SET TAGS ('dbx_business_glossary_term' = 'Isps Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `last_dredging_date` SET TAGS ('dbx_business_glossary_term' = 'Last Dredging Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `max_vessel_beam_m` SET TAGS ('dbx_business_glossary_term' = 'Max Vessel Beam M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `max_vessel_draft_m` SET TAGS ('dbx_business_glossary_term' = 'Max Vessel Draft M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `max_vessel_loa_m` SET TAGS ('dbx_business_glossary_term' = 'Max Vessel Loa M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `facility_name` SET TAGS ('dbx_business_glossary_term' = 'Facility Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `next_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `number_of_cranes` SET TAGS ('dbx_business_glossary_term' = 'Number Of Cranes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `operating_hours` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `ownership_type` SET TAGS ('dbx_business_glossary_term' = 'Ownership Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `reefer_points_count` SET TAGS ('dbx_business_glossary_term' = 'Reefer Points Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State Province');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `storage_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Storage Area Sqm');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `utilization_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Utilization Rate Pct');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `water_depth_m` SET TAGS ('dbx_business_glossary_term' = 'Water Depth M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` SET TAGS ('dbx_subdomain' = 'navigation_routes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Max Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `parent_port_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Port Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `parent_port_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line1');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line2');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `annual_cargo_tonnage` SET TAGS ('dbx_business_glossary_term' = 'Annual Cargo Tonnage');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `annual_throughput_teu` SET TAGS ('dbx_business_glossary_term' = 'Annual Throughput Teu');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `bunkering_available` SET TAGS ('dbx_business_glossary_term' = 'Bunkering Available');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `channel_depth_m` SET TAGS ('dbx_business_glossary_term' = 'Channel Depth M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `port_code` SET TAGS ('dbx_business_glossary_term' = 'Port Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `contact_email` SET TAGS ('dbx_business_glossary_term' = 'Contact Email');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Contact Phone');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `customs_facility` SET TAGS ('dbx_business_glossary_term' = 'Customs Facility');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `environmental_certification` SET TAGS ('dbx_business_glossary_term' = 'Environmental Certification');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `established_date` SET TAGS ('dbx_business_glossary_term' = 'Established Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `free_trade_zone` SET TAGS ('dbx_business_glossary_term' = 'Free Trade Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `hazmat_certified` SET TAGS ('dbx_business_glossary_term' = 'Hazmat Certified');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `iso_certified` SET TAGS ('dbx_business_glossary_term' = 'Iso Certified');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `isps_compliant` SET TAGS ('dbx_business_glossary_term' = 'Isps Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `last_dredging_date` SET TAGS ('dbx_business_glossary_term' = 'Last Dredging Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `max_vessel_beam_m` SET TAGS ('dbx_business_glossary_term' = 'Max Vessel Beam M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `max_vessel_draft_m` SET TAGS ('dbx_business_glossary_term' = 'Max Vessel Draft M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `max_vessel_length_m` SET TAGS ('dbx_business_glossary_term' = 'Max Vessel Length M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `port_name` SET TAGS ('dbx_business_glossary_term' = 'Port Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `number_of_berths` SET TAGS ('dbx_business_glossary_term' = 'Number Of Berths');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `number_of_cranes` SET TAGS ('dbx_business_glossary_term' = 'Number Of Cranes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `operating_hours` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `ownership_type` SET TAGS ('dbx_business_glossary_term' = 'Ownership Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `pilot_required` SET TAGS ('dbx_business_glossary_term' = 'Pilot Required');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `port_type` SET TAGS ('dbx_business_glossary_term' = 'Port Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `rail_connected` SET TAGS ('dbx_business_glossary_term' = 'Rail Connected');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `reefer_connections` SET TAGS ('dbx_business_glossary_term' = 'Reefer Connections');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Region');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `road_connected` SET TAGS ('dbx_business_glossary_term' = 'Road Connected');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `ship_repair_facilities` SET TAGS ('dbx_business_glossary_term' = 'Ship Repair Facilities');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `storage_capacity_sqm` SET TAGS ('dbx_business_glossary_term' = 'Storage Capacity Sqm');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `time_zone` SET TAGS ('dbx_business_glossary_term' = 'Time Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `total_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Total Area Sqm');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `total_quay_length_m` SET TAGS ('dbx_business_glossary_term' = 'Total Quay Length M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `tug_services_available` SET TAGS ('dbx_business_glossary_term' = 'Tug Services Available');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `water_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Water Area Sqm');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'Website Url');
