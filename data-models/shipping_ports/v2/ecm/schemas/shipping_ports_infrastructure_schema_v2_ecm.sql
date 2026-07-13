-- Schema for Domain: infrastructure | Business: Shipping_Ports | Version: v2_ecm
-- Generated on: 2026-07-13 08:38:27

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`infrastructure` COMMENT 'Owns port physical infrastructure data including berths, quay walls, wharves, fender systems, navigational aids, dredging records, channel depth surveys, warehouses, and port layout plans. Supports AVEVA Marine Engineering integration, CAPEX infrastructure projects, capacity planning, and port expansion initiatives. SSOT for port infrastructure and fixed facilities.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` (
    `berth_id` BIGINT COMMENT 'Unique identifier for the berth. Primary key for the berth master record.',
    `marpol_record_id` BIGINT COMMENT 'Foreign key linking to compliance.marpol_record. Business justification: Berths are operational locations for waste reception, ballast water discharge, and shore power operations requiring MARPOL compliance records. Port environmental officers track Annex I-VI operations, ',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Each berth is a cost centre for operational cost allocation (utilities, maintenance, labor, equipment). Port management reports berth-level P&L for pricing decisions and performance management. Essent',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Berths are designed for specific vessel types (container, tanker, bulk, etc.). Currently berth has design_vessel_type as a string. Adding FK to masterdata.vessel_type enables proper vessel-berth compa',
    `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Berths (including superstructure, fenders, bollards, shore power) are capitalized assets requiring depreciation tracking. Financial reporting requires linking berth infrastructure records to fixed ass',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Berths are ISPS-regulated port facilities requiring mandatory security records per ISPS Code Chapter XI-2 SOLAS. Port security officers track Declaration of Security (DoS) and Port Facility Security P',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Berths are leased/assigned to terminal operators or shipping lines under concession agreements. Essential for berth allocation management, lease billing, access control, and operational planning. Role',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Berths host physical assets (fenders, bollards, shore cranes, mooring equipment) requiring asset management, maintenance scheduling, SWL certification tracking, and lifecycle management. Essential for',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Berths are physical locations within port geography. Essential for vessel routing, operational planning, spatial queries, and linking berth infrastructure to port master location data for navigation a',
    `project_id` BIGINT COMMENT 'Foreign key linking to infrastructure.infrastructure_project. Business justification: Berths are constructed or upgraded through CAPEX infrastructure projects. The existing capex_project_reference (STRING) should be replaced with FK to infrastructure_project.infrastructure_project_id. ',
    `quay_wall_id` BIGINT COMMENT 'Foreign key linking to infrastructure.quay_wall. Business justification: Berths are physically constructed on quay walls. The existing quay_wall_reference (STRING) is a business code that should be replaced with a proper FK to quay_wall.quay_wall_id. This enables joining t',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Berth operations require designated supervisor for ISPS security compliance, vessel coordination, and emergency response. Critical for accountability in 24/7 marine terminal operations and regulatory ',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Berths are located within terminal zones for operational and security management. The existing terminal_area_code (STRING) should be replaced with FK to terminal_zone.terminal_zone_id. This enables jo',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Every berth operates within a defined ISPS security zone with specific MARSEC-level access controls, patrol requirements, and screening protocols. Berth operations staff need zone classification to en',
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
    `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Quay walls are capitalized fixed assets subject to depreciation over useful life. Port asset registers must link physical quay wall records to financial asset master for depreciation calculation, NBV ',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Structural inspections require certified engineer assignment for regulatory compliance, professional liability, and asset management. Engineer competency verification is mandatory for port authority a',
    `material_master_id` BIGINT COMMENT 'Foreign key linking to procurement.material_master. Business justification: Quay walls consume specialized materials (marine-grade concrete, steel reinforcement, anti-corrosion coatings). Links wall to primary material specification for lifecycle maintenance planning, materia',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Quay walls are infrastructure at specific port locations. Required for asset management, maintenance planning, spatial analysis, and linking structural assets to port geography for regulatory reportin',
    `project_id` BIGINT COMMENT 'Foreign key linking to infrastructure.infrastructure_project. Business justification: Quay walls are major infrastructure assets built through CAPEX projects. The existing capex_project_code (STRING) should be replaced with FK to infrastructure_project.infrastructure_project_id. This e',
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
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Terminal zones (container yards, RoRo areas) are allocated to operators under concession/license agreements. Required for yard capacity allocation, throughput commitment tracking (agreement.volume_com',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Terminal zones are cost centres for yard operations, tracking equipment deployment, labor, and overhead costs. Required for terminal P&L reporting, cost allocation to customers, and operational effici',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Terminal zones are operated by specific terminal operators under concession agreements. Critical for concession management, zone operator billing, performance monitoring, and access control. Role pref',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Terminal zones are operational areas within port locations. Essential for yard planning, container tracking, customs zone mapping, and linking operational zones to master port location data for logist',
    `infrastructure_terminal_id` BIGINT COMMENT 'Reference to the parent terminal facility that contains this zone. Links zone to its owning terminal for hierarchical port layout management.',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Terminal operational zones (container yards, CFS areas) map to ISPS security zones for access control. Different operational zones may have different security classifications (restricted vs. public). ',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Each operational zone requires designated manager for customs-controlled areas, hazmat approvals, security level enforcement, and daily operational decisions. Essential for ISPS compliance and inciden',
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
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Terminal zones (container yards, hazmat areas) are ISPS-regulated restricted areas requiring security records per ISPS Code. PFSO tracks zone-specific security levels, access restrictions, and PFSP co',
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
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Warehouses (especially bonded/CFS facilities) are leased to cargo handlers or freight forwarders under service agreements. Essential for storage capacity allocation, bonded facility licensing, lease m',
    `cost_centre_id` BIGINT COMMENT 'Foreign key linking to finance.cost_centre. Business justification: Warehouses are distinct cost centres for storage operations, tracking labor, utilities, maintenance, and security costs. Essential for warehouse P&L reporting, storage rate justification, and cost rec',
    `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Warehouses are major fixed assets requiring depreciation tracking and asset valuation. Port CFOs need to link warehouse infrastructure records to asset master for financial statement preparation, insu',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Bonded warehouses and cargo storage facilities are ISPS-regulated requiring security level management, access control records, and PFSP compliance per ISPS Code. Security officers track facility-speci',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Warehouses are leased to freight forwarders, customs brokers, or cargo owners. Essential for warehouse lease management, rental billing, access control, and capacity allocation. Role prefix lessee_ ',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Bonded warehouses require designated responsible officer for customs license compliance, IMDG approvals, and inventory accountability. Regulatory requirement for customs-controlled facilities and insu',
    `material_master_id` BIGINT COMMENT 'Foreign key linking to procurement.material_master. Business justification: Warehouses stock materials for port operations. Links warehouse to primary stored material for inventory management, stock location assignment, material handling equipment compatibility verification, ',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Warehouses contain material handling equipment (forklifts, reach stackers, conveyors, HVAC, reefer units) tracked as port assets. Required for warehouse equipment inventory, maintenance planning, and ',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Warehouses exist at specific port locations. Required for cargo routing, customs clearance, logistics planning, and linking warehouse facilities to master port location data for operational and regula',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key linking to infrastructure.terminal_zone. Business justification: Warehouses are located within terminal zones. The existing port_zone_code (STRING) should be replaced with FK to terminal_zone.terminal_zone_id. This enables joining to get zone operational details (z',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Warehouses are physical facilities within security zones requiring zone-specific access credentials, patrol coverage, and CCTV monitoring per ISPS Code. Real business process: warehouse access authori',
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

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` (
    `navigational_aid_id` BIGINT COMMENT 'Unique identifier for the navigational aid. Primary key for the navigational aid master record.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Navigational aids (buoys, beacons, leading lights) mark channels and guide vessels through navigable waterways. Adding channel_id FK (nullable) enables direct linkage when a nav aid is assigned to mar',
    `compliance_audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Navigational aids require regulatory compliance audits per IALA standards and port state control. Maritime authorities conduct periodic audits of AtoN availability, light characteristics, and SOLAS co',
    `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Navigational aids (buoys, beacons, AIS stations, lights) are capitalized assets with defined useful lives. Port authorities must track these in fixed asset register for depreciation, regulatory asset ',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Critical safety equipment requires assigned qualified technician for maintenance accountability, competency verification, and emergency response. Essential for IALA compliance and port state control i',
    `material_master_id` BIGINT COMMENT 'Foreign key linking to procurement.material_master. Business justification: Navigation aids require specific replacement parts (bulbs, batteries, AIS transponders, reflectors). Links aid to primary spare part for preventive maintenance scheduling, critical spares inventory ma',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Navigational aids (buoys, beacons, lights, racons) are physical assets requiring maintenance, inspection schedules, and regulatory compliance tracking. Essential for aids-to-navigation asset register ',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Navigational aids serve specific port locations. Needed for safety management, nautical chart updates, regulatory compliance reporting, and linking navigation infrastructure to master port location da',
    `replacement_aid_navigational_aid_id` BIGINT COMMENT 'Reference to the navigational aid that replaced this aid if it was decommissioned and superseded. Null if not replaced or still active.',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Navigational aids (buoys, beacons, lights) are critical infrastructure within security zones requiring protection from tampering, sabotage, or theft per ISPS Code. Real business process: critical infr',
    `aid_code` STRING COMMENT 'Externally-known unique code or designation for the navigational aid, used in nautical charts and port documentation. Typically follows port authority or hydrographic office naming conventions.. Valid values are `^[A-Z0-9]{4,12}$`',
    `aid_name` STRING COMMENT 'Human-readable name or designation of the navigational aid (e.g., Main Channel Buoy #3, Port Entrance Leading Light, Eastern Breakwater Beacon).',
    `aid_type` STRING COMMENT 'Classification of the navigational aid by its physical form and function. Determines the aids role in the ports navigational infrastructure. [ENUM-REF-CANDIDATE: buoy|beacon|leading_light|lighthouse|channel_marker|range_light|sector_light|vts_radar|ais_aton|sound_signal|daymark — 11 candidates stripped; promote to reference product]',
    `ais_aton_type` STRING COMMENT 'Classification of AIS AtoN: real (physical aid with AIS transmitter), synthetic (virtual aid broadcast by base station), or virtual (digital-only aid). Null for non-AIS aids.. Valid values are `real|synthetic|virtual`',
    `availability_target_percent` DECIMAL(18,2) COMMENT 'Target operational availability percentage for this navigational aid (e.g., 99.8%). Based on IALA availability categories and criticality level.',
    `body_color` STRING COMMENT 'Color or color pattern of the navigational aid body/structure (e.g., red, green, red-white horizontal bands, yellow-black vertical stripes). Used for daytime visual identification.',
    `chart_reference_number` STRING COMMENT 'Reference number or identifier used on official nautical charts to denote this navigational aid. Enables cross-reference between physical aids and published charts.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this navigational aid record was first created in the system. Audit trail for data governance.',
    `criticality_level` STRING COMMENT 'Importance classification of the navigational aid based on its role in safe navigation. Critical aids require highest availability and fastest repair response times.. Valid values are `critical|high|medium|low`',
    `decommission_date` DATE COMMENT 'Date when the navigational aid was permanently decommissioned and removed from service. Null for active aids.',
    `focal_height_m` DECIMAL(18,2) COMMENT 'Height of the light focal plane above mean sea level in meters. Critical for calculating geographic range and visibility. Null for non-illuminated aids.',
    `iala_classification` STRING COMMENT 'IALA buoyage system classification indicating the aids navigational purpose and positioning convention. Critical for international maritime safety compliance. [ENUM-REF-CANDIDATE: lateral_port|lateral_starboard|cardinal_north|cardinal_south|cardinal_east|cardinal_west|isolated_danger|safe_water|special_mark|emergency_wreck|new_danger — 11 candidates stripped; promote to reference product]',
    `imo_number` STRING COMMENT 'IMO identification number for the navigational aid if registered under IMO conventions. Seven-digit unique identifier. Applicable primarily to AIS AtoN (Aids to Navigation) transmitters.. Valid values are `^[0-9]{7}$`',
    `inspection_frequency_days` STRING COMMENT 'Standard interval in days between scheduled inspections for this navigational aid. Varies based on aid type, criticality, and regulatory requirements.',
    `installation_date` DATE COMMENT 'Date when the navigational aid was first installed and commissioned for operational use.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent inspection or maintenance check performed on the navigational aid. Critical for compliance with SOLAS and IALA maintenance requirements.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this navigational aid record was last updated in the system. Audit trail for data governance.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the navigational aid in decimal degrees. Positive values indicate North, negative values indicate South. Precision to 7 decimal places provides sub-meter accuracy.',
    `light_character` STRING COMMENT 'Distinctive light pattern or characteristic displayed by the aid (e.g., Fl(2)R 10s, Iso G 4s, Q(6)+LFl 15s). Describes the rhythm, color, and period of the light signal. Null for non-illuminated aids.',
    `light_color` STRING COMMENT 'Primary color of the light emitted by the navigational aid. Null for non-illuminated aids. Color coding follows IALA conventions for lateral and cardinal marks. [ENUM-REF-CANDIDATE: red|green|white|yellow|blue|amber|orange — 7 candidates stripped; promote to reference product]',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the navigational aid in decimal degrees. Positive values indicate East, negative values indicate West. Precision to 7 decimal places provides sub-meter accuracy.',
    `manufacturer` STRING COMMENT 'Name of the manufacturer or supplier of the navigational aid equipment. Used for warranty tracking and spare parts procurement.',
    `mmsi_number` STRING COMMENT 'Nine-digit MMSI number assigned to AIS-equipped navigational aids for automatic identification and tracking. Null for non-AIS aids.. Valid values are `^[0-9]{9}$`',
    `model_number` STRING COMMENT 'Manufacturers model or product number for the navigational aid. Used for technical specifications lookup and spare parts ordering.',
    `mooring_type` STRING COMMENT 'Method by which the navigational aid is secured or anchored (e.g., sinker weight, chain mooring, pile-mounted, fixed to structure). Null or none for shore-based fixed structures.. Valid values are `sinker|chain|pile|fixed_structure|floating|none`',
    `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next mandatory inspection or maintenance activity. Used for preventive maintenance planning and regulatory compliance.',
    `nominal_range_nm` DECIMAL(18,2) COMMENT 'Nominal range of the light in nautical miles under standard atmospheric conditions (meteorological visibility of 10 nautical miles). Null for non-illuminated aids.',
    `notes` STRING COMMENT 'Free-text field for additional operational notes, special instructions, or remarks about the navigational aid (e.g., seasonal operation, temporary changes, known issues).',
    `operational_status` STRING COMMENT 'Current operational state of the navigational aid. Indicates whether the aid is functioning and available for navigation support.. Valid values are `operational|non_operational|under_maintenance|decommissioned|temporary|planned`',
    `power_source_type` STRING COMMENT 'Primary power source used to operate the navigational aid. Null for passive aids (daymarks, unlit buoys). [ENUM-REF-CANDIDATE: mains_electric|solar|battery|wind|diesel_generator|gas|hybrid|none — 8 candidates stripped; promote to reference product]',
    `racon_code` STRING COMMENT 'Single-letter Morse code identifier transmitted by the radar beacon (RACON) when interrogated by ship radar. Null for aids without RACON capability.. Valid values are `^[A-Z]$`',
    `reflective_material` BOOLEAN COMMENT 'Indicates whether the navigational aid is equipped with radar-reflective material or retroreflective tape to enhance radar and visual detection.',
    `responsible_authority` STRING COMMENT 'Name of the organization or authority responsible for the maintenance and operation of this navigational aid (e.g., port authority, coast guard, hydrographic office).',
    `serial_number` STRING COMMENT 'Unique serial number assigned by the manufacturer to this specific navigational aid unit. Used for warranty claims and asset tracking.',
    `sound_signal_character` STRING COMMENT 'Distinctive pattern or rhythm of the sound signal (e.g., 2 blasts every 30s, continuous). Null for aids without sound signals.',
    `sound_signal_type` STRING COMMENT 'Type of audible signal device installed on the navigational aid for use in reduced visibility conditions. Null or none for aids without sound signals.. Valid values are `horn|siren|bell|gong|whistle|none`',
    `structure_height_m` DECIMAL(18,2) COMMENT 'Total physical height of the navigational aid structure from base to top in meters. Used for clearance calculations and physical planning.',
    `topmark_shape` STRING COMMENT 'Shape of the topmark (daymark) mounted on top of the aid for daytime identification. Follows IALA conventions for cardinal and lateral marks. Null or none for aids without topmarks.. Valid values are `cone_up|cone_down|sphere|cylinder|x_shape|none`',
    `watch_circle_radius_m` DECIMAL(18,2) COMMENT 'Radius of the watch circle (swing radius) for floating aids, indicating the maximum distance the aid can drift from its charted position due to mooring scope and tidal/current effects. Null for fixed aids.',
    `water_depth_m` DECIMAL(18,2) COMMENT 'Depth of water at the navigational aid location measured from mean sea level to seabed in meters. Null for shore-based aids.',
    CONSTRAINT pk_navigational_aid PRIMARY KEY(`navigational_aid_id`)
) COMMENT 'Master record for all navigational aids within port jurisdiction including buoys, beacons, leading lights, lighthouses, channel markers, and VTS radar installations. Captures aid type, IALA classification, light character, nominal range, geographic coordinates (lat/lon), chart reference number, responsible authority, installation date, last inspection date, operational status, and power source type. Supports IHO and IMO compliance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` (
    `channel_id` BIGINT COMMENT 'Unique identifier for the navigable channel record. Primary key.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Navigation channels require designated authority for depth management, dredging decisions, vessel traffic coordination, and VTS monitoring. Critical for safe navigation and regulatory compliance with ',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Channels connect to and serve port locations. Essential for vessel traffic management, pilotage planning, dredging coordination, and linking navigation channels to master port location data for operat',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Navigation channels traverse security zones with varying threat levels and monitoring requirements. VTS operators coordinate with security for vessel tracking and threat response. Real business proces',
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

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` (
    `depth_survey_id` BIGINT COMMENT 'Unique identifier for the hydrographic depth survey record. Primary key for the depth survey entity.',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Depth surveys are conducted on anchorage areas to verify holding ground and water depth for anchored vessels. Adding anchorage_area_id FK (nullable) enables direct linkage when survey targets an ancho',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Depth surveys are conducted on berth pockets to verify water depth alongside berths. Adding berth_id FK (nullable) enables direct linkage when survey targets a berth. This supports berth maintenance a',
    `channel_id` BIGINT COMMENT 'Foreign key linking to infrastructure.channel. Business justification: Depth surveys are conducted on channels to verify maintained depth and identify shoaling. The existing survey_area_type and survey_area_name are generic text fields. Adding channel_id FK (nullable) en',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Surveys require qualified coordinator for data quality, regulatory submission to maritime authorities, and dredging decision support. Ensures competency verification and professional accountability fo',
    `equipment_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.equipment_type. Business justification: Depth surveys use specific survey equipment types (multibeam sonar, single beam echo sounders). Required for survey planning, equipment scheduling, contractor evaluation, and tracking survey methodolo',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Survey vessels and equipment operate within security zones requiring access authorization, escort coordination, and VTS notification. Real business process: survey vessel security clearance.',
    `approval_date` DATE COMMENT 'Date when the survey was officially approved by the port authority. Marks the effective date for declared depth updates.',
    `approval_status` STRING COMMENT 'Current approval status of the survey report. Approved surveys are used for official declared depth updates and navigation safety decisions.. Valid values are `draft|submitted|under_review|approved|rejected`',
    `approved_by` STRING COMMENT 'Name or identifier of the port authority official who approved the survey. Provides accountability for navigation safety decisions.',
    `chart_datum_reference` STRING COMMENT 'Vertical datum reference used for depth measurements (e.g., Lowest Astronomical Tide, Mean Lower Low Water, Chart Datum). Critical for standardizing depth readings across surveys.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this depth survey record was first created in the system. Used for audit trail and data lineage tracking.',
    `data_source_system` STRING COMMENT 'Name of the source system from which this survey record originated (e.g., AVEVA Marine Engineering, Hydrographic Survey System). Supports data lineage and integration troubleshooting.',
    `declared_depth_m` DECIMAL(18,2) COMMENT 'Official published depth for the surveyed area in meters, typically the minimum depth minus safety margin. Used for vessel traffic management and berth allocation.',
    `depth_variance_m` DECIMAL(18,2) COMMENT 'Difference between design depth and minimum recorded depth in meters. Positive values indicate shoaling; negative values indicate over-dredging.',
    `design_depth_m` DECIMAL(18,2) COMMENT 'Target or design depth for the surveyed area in meters as per port infrastructure specifications. Used to identify dredging requirements.',
    `dredging_priority` STRING COMMENT 'Priority classification for required dredging work based on navigation safety impact and operational criticality.. Valid values are `critical|high|medium|low|none`',
    `dredging_required_flag` BOOLEAN COMMENT 'Boolean indicator whether the survey results indicate that dredging operations are required to restore design depth. Triggers CAPEX planning workflows.',
    `horizontal_positioning_system` STRING COMMENT 'GNSS or positioning system used for horizontal positioning during the survey (e.g., DGPS, RTK GPS). Affects spatial accuracy of depth measurements.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this depth survey record was last updated. Supports change tracking and audit compliance.',
    `maximum_depth_recorded_m` DECIMAL(18,2) COMMENT 'Deepest depth measurement recorded during the survey in meters. Used for understanding channel profile and dredging effectiveness.',
    `mean_depth_m` DECIMAL(18,2) COMMENT 'Average depth across the surveyed area in meters. Provides overall depth profile understanding for capacity planning.',
    `minimum_depth_recorded_m` DECIMAL(18,2) COMMENT 'Shallowest depth measurement recorded during the survey in meters. Critical for determining safe navigation clearances and identifying shoaling hazards.',
    `remarks` STRING COMMENT 'Additional notes, observations, or comments about the survey. Captures anomalies, equipment issues, or special conditions encountered.',
    `shoaling_area_description` STRING COMMENT 'Textual description of locations and extent of shoaling areas identified during the survey. Supports dredging scope definition.',
    `shoaling_detected_flag` BOOLEAN COMMENT 'Boolean indicator whether shoaling (sediment accumulation reducing depth) was identified during the survey. Triggers dredging planning workflows.',
    `shoaling_volume_cbm` DECIMAL(18,2) COMMENT 'Estimated volume of sediment accumulation in cubic meters (CBM). Used for dredging cost estimation and contractor tendering.',
    `survey_accuracy_order` STRING COMMENT 'IHO S-44 accuracy classification of the survey (Special Order, Order 1a, Order 1b, Order 2). Determines suitability for navigation safety purposes.. Valid values are `special|order_1a|order_1b|order_2`',
    `survey_area_name` STRING COMMENT 'Name or designation of the specific area surveyed within the port (e.g., Main Channel, Berth 5 Pocket, North Anchorage).',
    `survey_area_type` STRING COMMENT 'Classification of the port area surveyed. Determines the criticality and frequency requirements for depth monitoring.. Valid values are `channel|berth_pocket|anchorage|turning_basin|approach|fairway`',
    `survey_contractor_name` STRING COMMENT 'Name of the hydrographic surveying company or contractor that performed the survey. May be internal port authority team or external specialist firm.',
    `survey_cost_amount` DECIMAL(18,2) COMMENT 'Total cost of the survey in the ports operating currency. Used for OPEX tracking and cost-per-survey benchmarking.',
    `survey_cost_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the survey cost amount.. Valid values are `^[A-Z]{3}$`',
    `survey_coverage_area_sqm` DECIMAL(18,2) COMMENT 'Total area covered by the survey in square meters. Used for survey cost validation and coverage completeness assessment.',
    `survey_data_file_location` STRING COMMENT 'File path or URI to the raw survey data files (e.g., XYZ point cloud, multibeam data). Used for detailed analysis and archival.',
    `survey_date` DATE COMMENT 'Date when the hydrographic depth survey was conducted. Critical for tracking temporal changes in channel depth and shoaling patterns.',
    `survey_end_time` TIMESTAMP COMMENT 'Timestamp when the survey operations concluded. Used for calculating survey duration and operational efficiency.',
    `survey_method` STRING COMMENT 'Technology or methodology used to conduct the depth survey. Determines accuracy, coverage density, and data quality characteristics.. Valid values are `single_beam|multi_beam|lidar|side_scan_sonar|lead_line`',
    `survey_reference_number` STRING COMMENT 'External reference number or code assigned to the survey by the surveying authority or contractor. Used for cross-referencing with survey reports and documentation.',
    `survey_report_document_reference` STRING COMMENT 'Reference number or identifier for the detailed survey report document. Links to document management system for full survey deliverables.',
    `survey_start_time` TIMESTAMP COMMENT 'Timestamp when the survey operations commenced. Used for tide correlation and survey duration tracking.',
    `survey_vessel_name` STRING COMMENT 'Name of the vessel or platform used to conduct the survey. Important for equipment calibration traceability.',
    `tide_gauge_reference` STRING COMMENT 'Identifier or name of the tide gauge station used for tidal corrections during the survey. Ensures depth measurements are reduced to chart datum.',
    `vertical_positioning_system` STRING COMMENT 'System used for vertical positioning and tidal corrections (e.g., tide gauge, RTK vertical, pressure sensor). Critical for datum reduction accuracy.',
    `weather_conditions` STRING COMMENT 'Description of weather conditions during the survey (wind, sea state, visibility). Affects survey quality and data reliability.',
    CONSTRAINT pk_depth_survey PRIMARY KEY(`depth_survey_id`)
) COMMENT 'Transactional record of hydrographic depth surveys conducted on port channels, berth pockets, and anchorage areas. Captures survey date, survey contractor, survey method (single-beam, multi-beam, LIDAR), area surveyed, minimum depth recorded, maximum depth recorded, shoaling areas identified, chart datum reference, tide gauge reference, survey report reference number, and approval status. Critical for safe navigation and dredging planning.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` (
    `dredging_campaign_id` BIGINT COMMENT 'Unique identifier for the dredging campaign. Primary key for the dredging campaign master record.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Dredging campaigns may be cost-shared or mandated by contractual depth maintenance obligations in terminal operator agreements. Necessary for cost allocation between port authority and operator, and S',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Dredging campaigns may be sponsored/funded by terminal operators or shipping lines requiring deeper drafts for larger vessels. Essential for cost allocation, beneficiary billing, and investment recove',
    `marpol_record_id` BIGINT COMMENT 'Foreign key linking to compliance.marpol_record. Business justification: Dredging campaigns generate spoil disposal requiring MARPOL Annex V compliance records. Port environmental officers track dredged material disposal locations, volumes, contamination levels, and waste ',
    `equipment_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.equipment_type. Business justification: Dredging campaigns use specific equipment types (cutter suction dredger, trailing suction hopper dredger, backhoe dredger). Essential for equipment planning, contractor evaluation, capacity analysis, ',
    `permit_id` BIGINT COMMENT 'Reference to the environmental permit authorizing the dredging campaign and spoil disposal activities. Links to infrastructure permit master data.',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Dredging campaigns are funded via internal orders in port finance systems. Operations track actual dredging costs against approved internal order budgets for cost control and variance reporting. Stand',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Links dredging campaigns to owned dredging vessels tracked as port assets (when not contracted). Required for dredging equipment utilization tracking, cost allocation, and fleet management. Removes de',
    `depth_survey_id` BIGINT COMMENT 'Reference to the bathymetric depth survey conducted before dredging operations commenced. Links to depth survey master data.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Major dredging requires designated engineer for technical oversight, environmental permit compliance, and spoil disposal monitoring. Critical for regulatory submissions and contractor coordination. Re',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Dredging campaigns can target anchorage areas to maintain water depth and remove shoaling. The existing target_channel_id and target_berth_id cover channels and berths. Adding target_anchorage_area_id',
    `berth_id` BIGINT COMMENT 'Reference to the berth pocket where dredging operations are being conducted. Links to berth master data.',
    `channel_id` BIGINT COMMENT 'Reference to the navigation channel where dredging operations are being conducted. Links to channel master data.',
    `vendor_id` BIGINT COMMENT 'Unique identifier for the dredging contractor. Links to vendor or contractor master data.',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Dredging operations occur within security zones and require zone-specific access controls for contractor vessels, equipment staging areas, and spoil disposal sites. Real business process: contractor s',
    `actual_volume_dredged_m3` DECIMAL(18,2) COMMENT 'Actual volume of material (in cubic meters) removed during the dredging campaign as measured by post-dredge surveys.',
    `approved_disposal_volume_m3` DECIMAL(18,2) COMMENT 'Maximum volume of dredged material (in cubic meters) approved for disposal at the designated site under the environmental permit.',
    `campaign_code` STRING COMMENT 'Unique alphanumeric code assigned to the dredging campaign for external reference and reporting.',
    `campaign_cost` DECIMAL(18,2) COMMENT 'Total cost of the dredging campaign including contractor fees, equipment mobilization, disposal costs, and environmental monitoring expenses. Represents Capital Expenditure (CAPEX) for capital dredging or Operational Expenditure (OPEX) for maintenance dredging.',
    `campaign_name` STRING COMMENT 'Business name or title assigned to the dredging campaign for identification and reference purposes.',
    `campaign_notes` STRING COMMENT 'Free-text notes capturing additional details, lessons learned, or special circumstances related to the dredging campaign.',
    `campaign_status` STRING COMMENT 'Current lifecycle status of the dredging campaign indicating its operational state.. Valid values are `planned|mobilizing|active|suspended|completed|cancelled`',
    `completion_date` DATE COMMENT 'Date when dredging operations were completed and the target depth was achieved.',
    `contract_reference` STRING COMMENT 'Reference number or code of the dredging contract under which the campaign is executed.',
    `contracted_volume_m3` DECIMAL(18,2) COMMENT 'Total volume of material (in cubic meters) contracted to be dredged under the campaign agreement.',
    `contractor_name` STRING COMMENT 'Name of the dredging contractor or company responsible for executing the dredging campaign.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the dredging campaign record was first created in the system.',
    `cumulative_volume_disposed_m3` DECIMAL(18,2) COMMENT 'Cumulative volume of dredged material (in cubic meters) disposed at the site during the campaign to date.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the campaign cost (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `demobilization_date` DATE COMMENT 'Date when the dredging contractor and equipment demobilized from the port site after campaign completion.',
    `design_depth_target_m` DECIMAL(18,2) COMMENT 'Target depth (in meters below Chart Datum) to be achieved by the dredging campaign. Represents the design specification for the channel or berth pocket.',
    `disposal_monitoring_requirements` STRING COMMENT 'Description of environmental monitoring requirements mandated by the disposal permit (e.g., water quality sampling frequency, sediment testing protocols, marine life surveys).',
    `disposal_permit_reference` STRING COMMENT 'Reference number or code of the specific disposal permit authorizing spoil disposal at the designated site.',
    `disposal_type` STRING COMMENT 'Method of spoil disposal: open water dumping, confined disposal facility, beneficial reuse (beach nourishment, habitat creation), or land reclamation.. Valid values are `open_water|confined|beneficial_reuse|land_reclamation`',
    `dredging_type` STRING COMMENT 'Classification of the dredging campaign: capital dredging (new depth or expansion), maintenance dredging (routine depth preservation), or emergency dredging (unplanned response to siltation or obstruction).. Valid values are `capital|maintenance|emergency`',
    `environmental_incident_count` STRING COMMENT 'Number of environmental incidents or permit violations recorded during the dredging campaign (e.g., turbidity exceedances, unauthorized disposal, marine life impacts).',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the dredging campaign record was last modified in the system.',
    `mobilization_date` DATE COMMENT 'Date when the dredging contractor and equipment mobilized to the port site to commence campaign setup.',
    `operational_downtime_days` STRING COMMENT 'Number of days dredging operations were suspended due to operational issues (equipment breakdown, vessel traffic conflicts, permit delays).',
    `safety_incident_count` STRING COMMENT 'Number of occupational health and safety incidents recorded during the dredging campaign (injuries, near-misses, equipment damage).',
    `sediment_contamination_level` STRING COMMENT 'Classification of dredged sediment contamination level based on laboratory analysis of heavy metals, hydrocarbons, and other pollutants.. Valid values are `clean|low|moderate|high`',
    `spoil_disposal_site_latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the spoil disposal site in decimal degrees.',
    `spoil_disposal_site_longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the spoil disposal site in decimal degrees.',
    `spoil_disposal_site_name` STRING COMMENT 'Name or designation of the approved site where dredged material (spoil) is disposed.',
    `start_date` DATE COMMENT 'Date when active dredging operations commenced in the target channel or berth pocket.',
    `water_quality_monitoring_results` STRING COMMENT 'Summary of water quality monitoring results during the dredging campaign, including turbidity levels, dissolved oxygen, pH, and contaminant concentrations.',
    `weather_downtime_days` STRING COMMENT 'Number of days dredging operations were suspended due to adverse weather conditions (high winds, rough seas, poor visibility).',
    CONSTRAINT pk_dredging_campaign PRIMARY KEY(`dredging_campaign_id`)
) COMMENT 'Master record for dredging campaigns covering capital dredging, maintenance dredging, and emergency dredging operations within port waters. Captures campaign name, dredging type (capital/maintenance/emergency), target channel or berth pocket reference (FK to channel or berth), contracted dredging volume (m³), actual volume dredged, design depth target (Chart Datum), pre-dredge survey reference (FK to depth_survey), post-dredge survey reference (FK to depth_survey), dredging contractor, vessel/equipment deployed, mobilization date, start date, completion date, demobilization date, environmental permit reference (FK to infrastructure_permit), spoil disposal site details (site name, coordinates, disposal type, approved volume, cumulative volume disposed, permit reference), disposal monitoring requirements, water quality monitoring results, campaign cost, and campaign status. SSOT for dredging operations lifecycle including disposal site management. Supports MARPOL, London Convention, and national environmental compliance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` (
    `port_gate_id` BIGINT COMMENT 'Unique identifier for the port gate. Primary key for the port gate master record.',
    `equipment_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.equipment_type. Business justification: Port gates use specific equipment types (RFID readers, OCR cameras, weighbridges). Essential for equipment maintenance planning, capacity analysis, technology upgrade projects, and standardizing gate ',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: ISPS-compliant gates require designated supervisor for security zone enforcement, access control, hazmat clearance, and customs coordination. Mandatory for port facility security plans and incident re',
    `isps_facility_record_id` BIGINT COMMENT 'Foreign key linking to compliance.isps_facility_record. Business justification: Port gates are ISPS security perimeter control points requiring facility security records per ISPS Code. Port Facility Security Officers (PFSO) track security level changes, access control compliance,',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Gates have physical assets (RFID readers, OCR cameras, weighbridges, barriers, access control systems) requiring asset tracking, maintenance, and replacement planning. Critical for gate operations equ',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Gates track primary users (trucking companies, freight forwarders) for dedicated lane allocation and preferential access programs. Supports gate transaction billing, access authorization, and traffic ',
    `terminal_zone_id` BIGINT COMMENT 'Reference to the terminal or port facility that this gate provides access to. Links the gate to its parent terminal infrastructure for operational hierarchy and reporting.',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Gates are primary access control points for security zones. Gate operators enforce zone-specific entry requirements (credentials, screening, escort rules) based on zone classification. Real business p',
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

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` (
    `project_id` BIGINT COMMENT 'Unique identifier for the infrastructure project. Primary key for the infrastructure project entity.',
    `facility_security_plan_id` BIGINT COMMENT 'Foreign key linking to security.facility_security_plan. Business justification: Infrastructure projects that add new facilities or modify existing ones trigger updates to the Facility Security Plan (FSP) to incorporate new security measures, access points, and zones. Real busines',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Smaller infrastructure projects and maintenance programs are funded via internal orders rather than full WBS elements. Port finance distinguishes between project-tracked (WBS) and order-tracked (IO) i',
    `employee_id` BIGINT COMMENT 'Employee identifier for the project manager, linking to HR system for contact details and organizational assignment.',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Infrastructure projects often involve major asset acquisitions (new cranes, new vessels, new handling equipment) that should be linked for capex tracking, asset commissioning, and project handover doc',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to procurement.vendor. Business justification: Infrastructure projects (berth construction, quay wall upgrades, reclamation) require primary contractor tracking for payment processing, performance evaluation, and audit compliance. Links project ca',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Major infrastructure projects often have primary beneficiary/sponsor (terminal operator, shipping line consortium) who funds or co-funds development. Essential for project sponsorship tracking, cost r',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: Multi-year infrastructure projects often operate under framework contracts or master service agreements. Links project to governing contract for rate card enforcement, scope compliance verification, a',
    `threat_assessment_id` BIGINT COMMENT 'Foreign key linking to security.threat_assessment. Business justification: Major infrastructure projects (new berths, terminal expansions, channel deepening) require security threat assessments under ISPS Code to identify vulnerabilities before commissioning. Real business p',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: Capital infrastructure projects (berth construction, terminal expansion, channel deepening) are tracked as WBS elements in port project accounting for budget control, capitalization, and financial set',
    `actual_completion_date` DATE COMMENT 'Actual date when the project achieved substantial completion and was handed over to operations. Null if project is not yet complete.',
    `actual_expenditure_to_date` DECIMAL(18,2) COMMENT 'Cumulative actual expenditure incurred on the project to date in local currency. Includes all committed and paid costs across design, procurement, construction, and project management.',
    `actual_start_date` DATE COMMENT 'Actual date when project execution phase commenced, typically the date construction or major works actually began. Null if project has not yet started.',
    `approval_date` DATE COMMENT 'Date when the project received formal approval and funding authorization from the port authority board or executive committee.',
    `approved_capex_budget` DECIMAL(18,2) COMMENT 'Total approved capital expenditure budget for the project in local currency. Represents the authorized funding envelope for all project costs including design, construction, equipment, and contingency.',
    `aveva_project_reference` STRING COMMENT 'Reference identifier linking to the AVEVA Marine Engineering system project record for design, engineering drawings, and infrastructure planning documentation.',
    `berth_length_increase_m` DECIMAL(18,2) COMMENT 'Additional berth length in meters created or made available by this project. Applicable to berth construction, expansion, or rehabilitation projects.',
    `budget_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all financial amounts in this project record (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `capacity_increase_teu` STRING COMMENT 'Projected increase in container handling capacity measured in TEU per annum resulting from this infrastructure project. Null for non-container infrastructure.',
    `project_category` STRING COMMENT 'Primary infrastructure category being developed or modified: berth, quay wall, wharf, warehouse, container yard, navigational aid, shipping channel, breakwater, terminal building, or utility infrastructure. [ENUM-REF-CANDIDATE: berth|quay_wall|wharf|warehouse|yard|navigation_aid|channel|breakwater|terminal|utility — 10 candidates stripped; promote to reference product]',
    `channel_depth_m` DECIMAL(18,2) COMMENT 'Design or target channel depth below chart datum in meters for dredging or channel deepening projects. Determines maximum vessel draft that can be accommodated.',
    `project_code` STRING COMMENT 'Externally-known unique business identifier for the infrastructure project, typically following port authority naming convention (e.g., CAP-2024-BERTH).. Valid values are `^[A-Z]{3}-[0-9]{4}-[A-Z]{2,4}$`',
    `commissioning_date` DATE COMMENT 'Date when the infrastructure was commissioned and testing/acceptance procedures commenced. Precedes actual completion and operational handover.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this project record was first created in the system, representing initial project registration or concept approval.',
    `design_ground_level_m` DECIMAL(18,2) COMMENT 'Target elevation above chart datum for reclaimed land or infrastructure platform, measured in meters. Critical for drainage, flood protection, and operational planning.',
    `design_vessel_dwt` STRING COMMENT 'Maximum vessel deadweight tonnage that the infrastructure is designed to accommodate. Key parameter for berth structural design and channel depth requirements.',
    `design_vessel_loa_m` DECIMAL(18,2) COMMENT 'Maximum vessel length overall in meters that the infrastructure is designed to accommodate. Critical design parameter for berth and channel projects.',
    `environmental_impact_assessment_required` BOOLEAN COMMENT 'Indicates whether a formal environmental impact assessment is required for this project under MARPOL, ISO 14001, or local environmental regulations.',
    `isps_security_assessment_required` BOOLEAN COMMENT 'Indicates whether an ISPS security assessment and approval is required for this infrastructure project due to impact on port facility security zones or access control.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this project record, capturing any change to status, financials, schedule, or other project attributes.',
    `project_name` STRING COMMENT 'Full descriptive name of the infrastructure project as known to stakeholders and used in official documentation.',
    `notes` STRING COMMENT 'Free-text field for additional project information, special conditions, lessons learned, or other contextual information not captured in structured fields.',
    `phase` STRING COMMENT 'Current project management phase per PMI/ISO 21500 methodology: initiation, planning, execution, monitoring and controlling, or closure.. Valid values are `initiation|planning|execution|monitoring|closure`',
    `planned_completion_date` DATE COMMENT 'Planned or baseline completion date for the project, representing the target date for substantial completion and handover to operations.',
    `planned_start_date` DATE COMMENT 'Planned or baseline start date for project execution phase, typically the date construction or major works are scheduled to commence.',
    `priority` STRING COMMENT 'Strategic priority classification assigned by port authority executive: critical (essential for operations), high (strategic importance), medium (planned enhancement), or low (opportunistic improvement).. Valid values are `critical|high|medium|low`',
    `project_status` STRING COMMENT 'Current lifecycle status of the infrastructure project: concept (initial idea), feasibility (study phase), design (engineering), approved (funding secured), tendering (contractor selection), construction (active build), commissioning (testing), completed (operational handover), suspended (temporarily halted), or cancelled (terminated). [ENUM-REF-CANDIDATE: concept|feasibility|design|approved|tendering|construction|commissioning|completed|suspended|cancelled — 10 candidates stripped; promote to reference product]',
    `project_type` STRING COMMENT 'Classification of the infrastructure project by nature of work: new construction (greenfield), rehabilitation (restoration of existing), expansion (capacity increase), upgrade (modernization), reclamation (land creation), or dredging (channel deepening).. Valid values are `new_construction|rehabilitation|expansion|upgrade|reclamation|dredging`',
    `reclamation_fill_method` STRING COMMENT 'Method used for land reclamation projects: hydraulic fill (pumped slurry), dry fill (trucked material), mixed fill (combination), or not applicable for non-reclamation projects.. Valid values are `hydraulic_fill|dry_fill|mixed_fill|not_applicable`',
    `risk_rating` STRING COMMENT 'Overall project risk assessment rating based on technical complexity, environmental factors, stakeholder impact, and delivery uncertainty.. Valid values are `very_high|high|medium|low|very_low`',
    `scope_description` STRING COMMENT 'Comprehensive description of project scope, deliverables, and technical specifications. For reclamation projects, includes fill method, design ground level, and settlement monitoring requirements.',
    `settlement_monitoring_required` BOOLEAN COMMENT 'Indicates whether ongoing geotechnical settlement monitoring is required for this project, typically true for reclamation and major foundation works.',
    `sponsoring_business_unit` STRING COMMENT 'Name of the port authority division or business unit sponsoring and funding the project (e.g., Terminal Operations, Marine Services, Commercial Development).',
    `stakeholder_consultation_required` BOOLEAN COMMENT 'Indicates whether formal stakeholder consultation process is required for this project, typically true for projects with significant community, environmental, or commercial impact.',
    `warranty_expiry_date` DATE COMMENT 'Date when the contractor defects liability period or warranty coverage expires, after which maintenance responsibility fully transfers to port operations.',
    CONSTRAINT pk_project PRIMARY KEY(`project_id`)
) COMMENT 'Master record for CAPEX infrastructure development, port expansion, and land reclamation projects. Captures project name, project type (new construction, rehabilitation, expansion, upgrade, reclamation), scope description including reclamation-specific attributes (fill method, design ground level, settlement monitoring) where applicable, sponsoring business unit, AVEVA Marine Engineering project reference, approved CAPEX budget, actual expenditure to date, project phase, start date, planned completion date, actual completion date, project manager, contractor reference, regulatory approval reference, environmental permit reference, and project status. SSOT for port infrastructure investment pipeline and expansion initiatives.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` (
    `structural_inspection_id` BIGINT COMMENT 'Unique identifier for the structural inspection record. Primary key for the structural inspection entity.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to infrastructure.berth. Business justification: Structural inspections are conducted on berths to assess fender systems, bollards, and berth structural integrity. The existing asset_type and asset_reference are generic text fields. Adding berth_id ',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: Inspection programs are funded via internal orders in port maintenance accounting. Port maintenance departments track inspection costs (contractor fees, equipment, labor) against approved internal ord',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Inspections require lead inspector FK for competency verification, certification tracking, and professional liability. Enables validation of inspector_certification against employee_certification reco',
    `navigational_aid_id` BIGINT COMMENT 'Foreign key linking to infrastructure.navigational_aid. Business justification: Structural inspections are conducted on navigational aids (buoys, beacons, lights) to assess structural condition, light functionality, and mooring integrity. Adding navigational_aid_id FK (nullable) ',
    `port_asset_id` BIGINT COMMENT 'Reference to the port infrastructure asset being inspected (quay wall, berth, fender system, warehouse, navigational aid, etc.).',
    `project_id` BIGINT COMMENT 'Foreign key linking to infrastructure.infrastructure_project. Business justification: Structural inspections during and after construction verify design compliance, material quality, and workmanship. Required for project commissioning approval, warranty activation, and handover certifi',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Inspection services are procured from specialist vendors. Links inspection to procurement order for cost allocation to assets, vendor performance tracking, budget management, and audit trail for regul',
    `quay_wall_id` BIGINT COMMENT 'Foreign key linking to infrastructure.quay_wall. Business justification: Structural inspections are conducted on quay walls to assess structural condition, corrosion, and load capacity. Adding quay_wall_id FK (nullable) enables direct linkage when inspection targets a quay',
    `security_incident_id` BIGINT COMMENT 'Foreign key linking to security.security_incident. Business justification: Security incidents (vehicle impacts, sabotage, unauthorized access) can damage infrastructure requiring inspection. Inspectors must reference the incident for insurance, liability, and forensic engine',
    `utility_network_id` BIGINT COMMENT 'Foreign key linking to infrastructure.utility_network. Business justification: Structural inspections are conducted on utility networks (electrical, water, shore power) to assess infrastructure condition, safety compliance, and capacity. Adding utility_network_id FK (nullable) e',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to infrastructure.warehouse. Business justification: Structural inspections are conducted on warehouses to assess building structure, fire suppression systems, and floor load capacity. Adding warehouse_id FK (nullable) enables direct linkage when inspec',
    `work_order_id` BIGINT COMMENT 'Reference to the maintenance work order created to address defects identified in this inspection. Links inspection findings to remediation execution.',
    `approval_date` DATE COMMENT 'Date on which the inspection report was formally approved by the port authority.',
    `approved_by` STRING COMMENT 'Name of the port authority engineer or manager who reviewed and approved the inspection report.',
    `asset_reference` STRING COMMENT 'Business identifier or name of the specific infrastructure asset being inspected (e.g., Berth 7, Quay Wall Section A, Warehouse 3).',
    `asset_type` STRING COMMENT 'Type of port infrastructure asset being inspected. Categorizes the asset for inspection methodology and defect classification purposes. [ENUM-REF-CANDIDATE: quay_wall|berth|fender_system|warehouse|navigational_aid|crane_foundation|jetty|breakwater|mooring_dolphin|channel|other — 11 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this inspection record was first created in the system.',
    `critical_defects_count` STRING COMMENT 'Number of critical severity defects identified that pose immediate safety risk or require urgent remediation.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for estimated repair cost (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `defects_identified_count` STRING COMMENT 'Total number of defects, anomalies, or areas of concern identified during the inspection.',
    `estimated_repair_cost` DECIMAL(18,2) COMMENT 'Estimated cost to remediate all defects identified in this inspection, in local currency. Used for CAPEX planning and budget forecasting.',
    `findings_summary` STRING COMMENT 'High-level summary of the inspection findings, including overall asset condition assessment and key observations.',
    `inspection_date` DATE COMMENT 'The date on which the structural inspection was conducted. Principal business event timestamp for the inspection activity.',
    `inspection_duration_hours` DECIMAL(18,2) COMMENT 'Total duration of the inspection activity in hours, from start to completion.',
    `inspection_frequency_months` STRING COMMENT 'Recommended inspection frequency in months based on asset type, condition, and regulatory requirements.',
    `inspection_method` STRING COMMENT 'Primary methodology used to conduct the structural inspection: visual (human observation), underwater ROV (Remotely Operated Vehicle), NDT ultrasonic (Non-Destructive Testing), NDT radiographic, drone survey (aerial inspection), laser scanning (3D measurement), structural load test, or other specialized techniques. [ENUM-REF-CANDIDATE: visual|underwater_rov|ndt_ultrasonic|ndt_radiographic|drone_survey|laser_scanning|structural_load_test|other — 8 candidates stripped; promote to reference product]',
    `inspection_notes` STRING COMMENT 'Additional notes, observations, or comments recorded by the inspector during the inspection that provide context or detail beyond structured fields.',
    `inspection_reference_number` STRING COMMENT 'Externally-known unique reference number assigned to this structural inspection for tracking and reporting purposes.. Valid values are `^[A-Z0-9-]{6,20}$`',
    `inspection_report_reference` STRING COMMENT 'Reference identifier or document number for the formal inspection report. May reference document management system location.',
    `inspection_status` STRING COMMENT 'Current lifecycle status of the inspection: scheduled (planned but not started), in-progress (inspection underway), completed (inspection finished, report being prepared), cancelled (inspection not performed), report-pending (awaiting final report), closed (inspection and remediation complete).. Valid values are `scheduled|in-progress|completed|cancelled|report-pending|closed`',
    `inspection_type` STRING COMMENT 'Classification of the inspection based on its purpose and trigger: routine (scheduled preventive), special (condition-based), post-incident (after damage event), regulatory (compliance-driven), pre-commissioning (before asset activation), or decommissioning (end-of-life assessment).. Valid values are `routine|special|post-incident|regulatory|pre-commissioning|decommissioning`',
    `inspector_certification` STRING COMMENT 'Professional certification or accreditation held by the inspector (e.g., Certified Welding Inspector, NDT Level II, Structural Engineer PE).',
    `inspector_company` STRING COMMENT 'Name of the company or organization that performed the inspection (internal port authority team or external contractor).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this inspection record was last updated in the system.',
    `major_defects_count` STRING COMMENT 'Number of major severity defects identified that require planned remediation within a defined timeframe.',
    `minor_defects_count` STRING COMMENT 'Number of minor severity defects identified that should be monitored or addressed during routine maintenance.',
    `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next structural inspection of this asset, based on inspection frequency requirements and current condition assessment.',
    `operational_impact` STRING COMMENT 'Assessment of the impact of identified defects on port operations: none (no impact), minor (negligible impact), moderate (some operational constraints), major (significant operational restrictions), asset closure (asset must be taken out of service).. Valid values are `none|minor|moderate|major|asset_closure`',
    `overall_condition_rating` STRING COMMENT 'Overall assessment of the asset structural condition based on inspection findings: excellent (no defects, as-new condition), good (minor wear, fully functional), fair (moderate deterioration, functional with monitoring), poor (significant deterioration, remediation required), critical (severe deterioration, immediate action required).. Valid values are `excellent|good|fair|poor|critical`',
    `photographic_evidence_reference` STRING COMMENT 'Reference identifier or file path to photographic evidence captured during the inspection (images, videos, drone footage). May reference document management system location.',
    `primary_defect_type` STRING COMMENT 'The most significant type of defect identified during the inspection: cracking (structural cracks), spalling (concrete surface deterioration), corrosion (metal degradation), settlement (foundation movement), scour (seabed erosion), impact damage (collision damage), deformation (structural distortion), erosion (material loss), joint failure (expansion joint issues), coating failure (protective coating breakdown), or none (no defects found). [ENUM-REF-CANDIDATE: cracking|spalling|corrosion|settlement|scour|impact_damage|deformation|erosion|joint_failure|coating_failure|none — 11 candidates stripped; promote to reference product]',
    `recommended_action` STRING COMMENT 'Summary of recommended remediation actions based on inspection findings, including repair scope, urgency, and methodology.',
    `regulatory_authority` STRING COMMENT 'Name of the regulatory authority or governing body requiring this inspection (e.g., Port State Control, National Maritime Safety Authority, local port authority).',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether this inspection was conducted to meet regulatory compliance requirements (True) or was voluntary/internal (False).',
    `remediation_completion_date` DATE COMMENT 'Date on which remediation work for identified defects was completed. Null if remediation is not yet complete.',
    `remediation_priority` STRING COMMENT 'Priority classification for remediation work: immediate (within 24 hours), urgent (within 1 week), high (within 1 month), medium (within 6 months), low (within 1 year), monitor only (no immediate action, continue monitoring).. Valid values are `immediate|urgent|high|medium|low|monitor_only`',
    `remediation_status` STRING COMMENT 'Current status of remediation work for identified defects: not required (no action needed), pending (awaiting approval or scheduling), planned (scheduled for execution), in progress (remediation underway), completed (remediation finished), deferred (postponed to future period).. Valid values are `not_required|pending|planned|in_progress|completed|deferred`',
    `safety_risk_level` STRING COMMENT 'Assessment of safety risk posed by identified defects: none (no safety concern), low (minimal risk), medium (moderate risk, monitoring required), high (significant risk, action needed), critical (immediate danger, asset closure required).. Valid values are `none|low|medium|high|critical`',
    `structural_integrity_assessment` STRING COMMENT 'Engineering assessment of whether the asset structural integrity is intact (fully sound), compromised (reduced capacity but stable), at risk (potential failure), or failed (structural failure occurred).. Valid values are `intact|compromised|at_risk|failed`',
    `tide_level_m` DECIMAL(18,2) COMMENT 'Tide level in meters at the time of inspection, relevant for underwater and waterline structure inspections.',
    `weather_conditions` STRING COMMENT 'Weather conditions during the inspection that may have affected inspection quality or accessibility (e.g., clear, rain, high wind, low visibility).',
    CONSTRAINT pk_structural_inspection PRIMARY KEY(`structural_inspection_id`)
) COMMENT 'Transactional record of structural inspections conducted on port infrastructure assets including quay walls, berths, fender systems, warehouses, and navigational aids. Captures inspection date, inspector name/company, inspection type (routine, special, post-incident), infrastructure asset type and reference, inspection method (visual, underwater ROV, NDT, drone survey), findings summary, defects identified with severity classification (critical, major, minor), defect type (cracking, spalling, corrosion, settlement, scour, impact damage), recommended remediation actions, remediation status tracking, photographic evidence references, next inspection due date, and inspection report reference. Supports asset condition monitoring, maintenance planning, and regulatory compliance for port infrastructure lifecycle management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` (
    `utility_network_id` BIGINT COMMENT 'Unique identifier for the utility network infrastructure asset. Primary key for the utility network entity.',
    `compliance_audit_id` BIGINT COMMENT 'Foreign key linking to compliance.audit. Business justification: Shore power and utility systems require environmental compliance audits for GHG emissions reduction verification per IMO and EU regulations. Port environmental officers conduct audits of shore power c',
    `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Utility networks (electrical distribution, water systems, shore power infrastructure) are capitalized infrastructure assets requiring depreciation. Financial accounting requires linking utility networ',
    `material_master_id` BIGINT COMMENT 'Foreign key linking to procurement.material_master. Business justification: Utility networks consume materials (cables, transformers, shore power connectors, pipes). Links network to primary material specification for maintenance planning, standardization across utility types',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Critical infrastructure (power, water, shore power) requires designated manager for emergency response, maintenance coordination, and SCADA system accountability. Essential for business continuity and',
    `port_asset_id` BIGINT COMMENT 'Foreign key linking to asset.port_asset. Business justification: Utility networks comprise physical assets (transformers, substations, pumps, shore power units, switchgear) requiring asset register tracking, maintenance scheduling, and lifecycle management. Essenti',
    `project_id` BIGINT COMMENT 'Foreign key linking to infrastructure.infrastructure_project. Business justification: Utility networks (electrical, water, shore power) are installed through CAPEX infrastructure projects. The existing capex_project_code (STRING) should be replaced with FK to infrastructure_project.inf',
    `acquisition_cost` DECIMAL(18,2) COMMENT 'Total capital cost of acquiring, constructing, and commissioning the utility network infrastructure including materials, labor, engineering, and project management.',
    `acquisition_cost_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the acquisition cost (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `annual_opex_budget` DECIMAL(18,2) COMMENT 'Annual operational expenditure budget allocated for maintenance, repairs, inspections, and operational costs of the utility network infrastructure.',
    `asset_owner` STRING COMMENT 'Legal owner of the utility network infrastructure asset. May be port authority, government entity, or private operator depending on port governance structure.',
    `capacity_unit` STRING COMMENT 'Unit of measure for the design capacity value. kVA/MVA for electrical power, cubic meters per hour or liters per minute for fluids, bar/PSI for pressure systems, Gbps/Mbps for telecommunications. [ENUM-REF-CANDIDATE: kva|mva|kw|mw|m3_per_hour|liters_per_minute|bar|psi|gbps|mbps — 10 candidates stripped; promote to reference product]',
    `condition_rating` STRING COMMENT 'Current physical condition assessment of the utility network infrastructure based on inspection findings, maintenance history, and asset health indicators.. Valid values are `excellent|good|fair|poor|critical`',
    `connection_point_count` STRING COMMENT 'Total number of connection points, outlets, or service delivery locations along the utility network (e.g., shore power connection points, fire hydrants, fuel bunkering stations, water taps).',
    `criticality_rating` STRING COMMENT 'Business criticality rating of the utility network infrastructure based on impact to port operations if the network becomes unavailable. Critical networks support essential safety or revenue-generating operations.. Valid values are `critical|high|medium|low`',
    `data_source_system` STRING COMMENT 'Name of the source system from which this utility network record originated (e.g., AVEVA Marine Engineering, Maximo Asset Management, SAP PM).',
    `design_capacity` DECIMAL(18,2) COMMENT 'Maximum design capacity of the utility network. Units vary by network type: kVA for electrical/shore power, cubic meters per hour for water/fuel, bar for compressed air, Gbps for telecommunications.',
    `environmental_compliance_flag` BOOLEAN COMMENT 'Indicates whether the utility network infrastructure meets all applicable environmental regulations and sustainability standards including IMO environmental conventions, ISO 14001 EMS requirements, and local environmental protection laws.',
    `geographic_coverage_area` STRING COMMENT 'Description of the port geographic area or terminal zones served by this utility network (e.g., Terminal 1-3, North Berth Complex, Container Yard A-D, Entire Port Facility).',
    `ghg_emissions_reduction_tonnes_co2_annual` DECIMAL(18,2) COMMENT 'Estimated annual reduction in greenhouse gas emissions measured in tonnes of CO2 equivalent attributable to this utility network. Particularly relevant for shore power networks enabling cold ironing per IMO GHG reduction strategy and MARPOL Annex VI compliance.',
    `gis_network_layer_reference` STRING COMMENT 'Reference identifier to the GIS layer or spatial dataset containing the detailed geographic mapping and routing of the utility network infrastructure. Supports AVEVA Marine Engineering integration.',
    `inspection_frequency_months` STRING COMMENT 'Required interval in months between comprehensive inspections of the utility network infrastructure as defined by maintenance standards and regulatory requirements.',
    `installation_year` STRING COMMENT 'Year the utility network infrastructure was originally installed and commissioned for operational use.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent comprehensive inspection or condition assessment of the utility network infrastructure.',
    `last_upgrade_year` STRING COMMENT 'Year of the most recent major upgrade, expansion, or modernization of the utility network infrastructure. Null if no upgrades have been performed since installation.',
    `maintenance_authority` STRING COMMENT 'Name of the organizational unit, department, or external contractor responsible for maintenance and upkeep of the utility network infrastructure.',
    `network_code` STRING COMMENT 'Business identifier code for the utility network following port infrastructure naming convention (e.g., ELEC-HV-0001, WATR-MAIN-0023). Used for external reference and asset tagging.. Valid values are `^[A-Z]{2,4}-[A-Z]{2,4}-[0-9]{4}$`',
    `network_name` STRING COMMENT 'Descriptive name of the utility network (e.g., Terminal 3 High Voltage Distribution, North Berth Water Supply Main, Shore Power Grid A).',
    `network_status` STRING COMMENT 'Current operational lifecycle status of the utility network infrastructure.. Valid values are `operational|under_maintenance|out_of_service|under_construction|decommissioned|planned`',
    `network_type` STRING COMMENT 'Classification of the utility network infrastructure. Electrical HV (High Voltage) typically >1kV, LV (Low Voltage) <1kV. Shore power enables cold ironing per IEC/ISO 80005 standards for vessel berthing emissions reduction. [ENUM-REF-CANDIDATE: electrical_hv|electrical_lv|shore_power|water_supply|fire_hydrant|fuel_bunkering|compressed_air|telecommunications|wastewater|stormwater — 10 candidates stripped; promote to reference product]',
    `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next mandatory inspection or condition assessment of the utility network infrastructure per maintenance plan.',
    `notes` STRING COMMENT 'Additional free-text notes, comments, or special considerations regarding the utility network infrastructure including operational constraints, historical context, or planned future modifications.',
    `operating_frequency_hz` DECIMAL(18,2) COMMENT 'Operating frequency in Hertz for electrical networks. Typically 50Hz or 60Hz depending on regional standards. Applicable to electrical and shore power networks. Null for non-electrical utility types.',
    `operating_pressure_bar` DECIMAL(18,2) COMMENT 'Operating pressure in bar for fluid and compressed air networks. Applicable to water supply, fire hydrant, fuel bunkering, and compressed air networks. Null for non-pressure utility types.',
    `operating_voltage_kv` DECIMAL(18,2) COMMENT 'Operating voltage in kilovolts for electrical networks. Applicable to electrical HV, electrical LV, and shore power networks. Null for non-electrical utility types.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this utility network record was first created in the system.',
    `record_updated_by` STRING COMMENT 'User identifier or system account that last modified this utility network record.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this utility network record was last modified in the system.',
    `redundancy_level` STRING COMMENT 'Level of redundancy and backup capacity built into the utility network design to ensure continuity of service during failures or maintenance. N+1 indicates one backup unit, N+2 indicates two backup units.. Valid values are `none|partial|full|n_plus_1|n_plus_2`',
    `replacement_value` DECIMAL(18,2) COMMENT 'Estimated current cost to replace the utility network infrastructure with equivalent modern capacity and functionality. Used for insurance valuation and asset management planning.',
    `safety_certification_expiry_date` DATE COMMENT 'Expiration date of current safety certifications for the utility network infrastructure. Null if certification is not required or has no expiry.',
    `safety_certification_status` STRING COMMENT 'Current status of safety certifications and compliance approvals for the utility network infrastructure per ISPS Code, SOLAS, and ISO 45001 occupational health and safety standards.. Valid values are `certified|expired|pending_renewal|not_required|non_compliant`',
    `scada_integration_flag` BOOLEAN COMMENT 'Indicates whether the utility network is integrated with SCADA systems for real-time monitoring, control, and automated management of network operations.',
    `shore_power_connector_standard` STRING COMMENT 'International standard specification for shore power connection interfaces. IEC 80005-1 for high voltage shore connection, IEC 80005-3 for low voltage. Applicable only to shore power networks.. Valid values are `iec_80005_1|iec_80005_3|iec_60309|proprietary|not_applicable`',
    `shore_power_kva_capacity` DECIMAL(18,2) COMMENT 'Total shore-to-ship power capacity in kVA for cold ironing connections per IEC/ISO 80005 standards. Enables vessels to shut down auxiliary engines while berthed, reducing GHG emissions and air pollution. Null for non-shore-power networks.',
    `smart_metering_enabled` BOOLEAN COMMENT 'Indicates whether the utility network is equipped with smart metering infrastructure for automated consumption tracking, billing, and demand management.',
    `total_network_length_m` DECIMAL(18,2) COMMENT 'Total linear length of the utility network infrastructure measured in meters, including all distribution lines, mains, and conduits.',
    CONSTRAINT pk_utility_network PRIMARY KEY(`utility_network_id`)
) COMMENT 'Master record for port utility networks and services infrastructure including electrical HV/LV networks, shore-to-ship power connection points (cold ironing per IEC/ISO 80005), water supply mains, fire hydrant networks, fuel bunkering lines, compressed air networks, and telecommunications conduits. Captures network type, total network length, design capacity, operating voltage/pressure/frequency, connection point locations and specifications (including shore power kVA capacity and connector standards), installation year, condition rating, last inspection date, GHG emissions reduction contribution tracking, and responsible maintenance authority. SSOT for all port utility infrastructure supporting IMO GHG compliance and environmental sustainability.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` (
    `anchorage_area_id` BIGINT COMMENT 'Unique identifier for the anchorage area. Primary key for the anchorage area master record.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Anchorage areas are designated zones within port locations. Required for vessel scheduling, traffic management, safety planning, and linking anchorage zones to master port location data for VTS and pi',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Anchorage areas are designated security zones with specific MARSEC-level monitoring, vessel screening, and MDA (Maritime Domain Awareness) requirements. Real business process: anchorage security monit',
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

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` (
    `closure_id` BIGINT COMMENT 'Unique identifier for the infrastructure closure record. Primary key.',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to infrastructure.anchorage_area. Business justification: Infrastructure closures can affect anchorage areas (e.g., closed for dredging, environmental incidents, or safety restrictions). The existing FKs cover berth, channel, port_gate, terminal_zone, naviga',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Closures impacting vessel operations require formal authorization by responsible officer for accountability, notification workflows, and revenue impact decisions. Replaces denormalized authorizing_off',
    `berth_id` BIGINT COMMENT 'Foreign key reference to the berth asset when infrastructure_type is berth. Nullable for other infrastructure types.',
    `channel_id` BIGINT COMMENT 'Foreign key reference to the navigation channel when infrastructure_type is channel. Nullable for other infrastructure types.',
    `dredging_campaign_id` BIGINT COMMENT 'Foreign key reference to the dredging project when closure_reason is dredging. Links channel closures to capital dredging or maintenance dredging activities.',
    `emergency_response_plan_id` BIGINT COMMENT 'Foreign key linking to safety.emergency_response_plan. Business justification: Infrastructure closures may activate emergency response plans for evacuation, containment, or mitigation. Required for emergency management coordination, stakeholder notification, and response team ac',
    `exception_id` BIGINT COMMENT 'Foreign key linking to tariff.tariff_exception. Business justification: Infrastructure closures trigger tariff waivers or adjustments as compensation for service disruptions. Commercial practice links closure events to exception records for revenue impact tracking and cus',
    `navigational_aid_id` BIGINT COMMENT 'Foreign key reference to the navigational aid asset when infrastructure_type is navigational_aid. Nullable for other infrastructure types.',
    `port_gate_id` BIGINT COMMENT 'Foreign key reference to the port gate when infrastructure_type is gate. Nullable for other infrastructure types.',
    `project_id` BIGINT COMMENT 'Foreign key linking to infrastructure.infrastructure_project. Business justification: Infrastructure closures can be caused by infrastructure projects (e.g., construction work, port expansion, land reclamation). The existing work_order_id covers maintenance work orders. Adding infrastr',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Emergency repairs or planned maintenance causing infrastructure closures are often procured urgently. Links closure to procurement order for closure cost attribution, emergency procurement justificati',
    `quay_wall_id` BIGINT COMMENT 'Foreign key linking to infrastructure.quay_wall. Business justification: Infrastructure closures can affect quay walls (e.g., closed for structural repairs, inspections, or safety incidents). Adding quay_wall_id FK (nullable) enables direct linkage when closure affects a q',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Closures may be requested by specific participants (terminal operator requests maintenance window, shipping line requests dredging). Critical for closure request tracking, impact notification, compens',
    `terminal_zone_id` BIGINT COMMENT 'Foreign key reference to the yard zone when infrastructure_type is yard_zone. Nullable for other infrastructure types.',
    `utility_network_id` BIGINT COMMENT 'Foreign key linking to infrastructure.utility_network. Business justification: Infrastructure closures can affect utility networks (e.g., power outages, water supply interruptions, shore power unavailability). Adding utility_network_id FK (nullable) enables direct linkage when c',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to booking.call_booking. Business justification: When infrastructure closes (berth maintenance, channel dredging, gate repairs), affected vessel call bookings must be identified for rescheduling or alternative berth assignment. Port operations cente',
    `warehouse_id` BIGINT COMMENT 'Foreign key reference to the warehouse facility when infrastructure_type is warehouse. Nullable for other infrastructure types.',
    `work_order_id` BIGINT COMMENT 'Foreign key reference to the maintenance or repair work order associated with the closure. Links closure event to asset management activities.',
    `actual_end_datetime` TIMESTAMP COMMENT 'Actual date and time when the infrastructure was returned to service. Nullable until closure is completed. Used for performance analysis and SLA compliance.',
    `actual_start_datetime` TIMESTAMP COMMENT 'Actual date and time when the infrastructure closure commenced. May differ from planned start due to operational conditions or emergency situations.',
    `affected_vessel_calls_count` STRING COMMENT 'Number of scheduled vessel calls impacted by the closure, requiring rescheduling, berth reallocation, or diversion to alternative facilities.',
    `alternative_infrastructure_reference` BIGINT COMMENT 'Foreign key reference to alternative infrastructure asset designated for use during the closure. Supports operational continuity and vessel rerouting decisions.',
    `capacity_reduction_percentage` DECIMAL(18,2) COMMENT 'Percentage reduction in operational capacity during partial restriction or reduced capacity closures. Used for throughput forecasting and resource planning.',
    `closure_status` STRING COMMENT 'Current lifecycle state of the closure event. Tracks progression from planning through execution to completion or cancellation.. Valid values are `planned|active|completed|cancelled|extended`',
    `created_datetime` TIMESTAMP COMMENT 'Date and time when the infrastructure closure record was first created in the system. Audit trail for record lifecycle tracking.',
    `environmental_impact_flag` BOOLEAN COMMENT 'Boolean indicator whether the closure is related to environmental protection measures, Marine Pollution Convention (MARPOL) compliance, or Environmental Management System (EMS) requirements.',
    `estimated_revenue_impact_usd` DECIMAL(18,2) COMMENT 'Projected financial impact of the closure in USD, including lost terminal handling charges, wharfage, and other port tariffs. Used for financial planning and CAPEX justification.',
    `extension_count` STRING COMMENT 'Number of times the closure period has been extended beyond the original planned end datetime. Used for performance analysis and contractor accountability.',
    `infrastructure_type` STRING COMMENT 'Category of port infrastructure affected by the closure. Determines which asset reference field is populated and operational impact scope.. Valid values are `berth|channel|gate|yard_zone|navigational_aid|warehouse`',
    `last_modified_datetime` TIMESTAMP COMMENT 'Date and time when the infrastructure closure record was last updated. Supports change tracking and audit compliance.',
    `notification_distribution_list` STRING COMMENT 'Comma-separated list of stakeholder groups or systems that received closure notifications, including shipping lines, port agents, customs, pilotage services, and Port Community System subscribers.',
    `notification_sent_datetime` TIMESTAMP COMMENT 'Date and time when the closure notification was distributed to stakeholders. Used to verify compliance with advance notice requirements and Service Level Agreements (SLA).',
    `operational_impact_description` STRING COMMENT 'Detailed narrative of the operational consequences of the closure, including affected services, alternative arrangements, and mitigation measures implemented.',
    `planned_end_datetime` TIMESTAMP COMMENT 'Scheduled date and time when the infrastructure is planned to return to service. Used for capacity planning and vessel rescheduling.',
    `planned_start_datetime` TIMESTAMP COMMENT 'Scheduled date and time when the infrastructure closure is planned to begin. Used for advance notification and vessel schedule coordination.',
    `reason` STRING COMMENT 'Primary business reason for the infrastructure closure or restriction. Drives operational response protocols and resource allocation.. Valid values are `maintenance|inspection|incident|weather|dredging|structural_failure`',
    `reason_detail` STRING COMMENT 'Extended narrative description providing specific details about the closure reason, including technical findings, incident reports, or weather conditions.',
    `reference_number` STRING COMMENT 'Externally-known business identifier for the closure event, used for communication and tracking across port operations and stakeholder notifications.. Valid values are `^CLS-[0-9]{8}$`',
    `regulatory_authority_notified` STRING COMMENT 'Name of the regulatory body or port state control authority notified of the closure, when required by International Ship and Port Facility Security (ISPS) Code or national maritime safety regulations.',
    `safety_incident_flag` BOOLEAN COMMENT 'Boolean indicator whether the closure was triggered by a safety incident or Occupational Health and Safety (OHS) concern requiring immediate action.',
    `severity_level` STRING COMMENT 'Degree of operational impact on the infrastructure asset. Full closure prevents all use; partial restriction limits specific operations; reduced capacity allows operations at lower throughput.. Valid values are `full_closure|partial_restriction|reduced_capacity`',
    CONSTRAINT pk_closure PRIMARY KEY(`closure_id`)
) COMMENT 'Transactional record of planned and unplanned closures or restrictions of port infrastructure including berth closures, channel depth restrictions, gate closures, yard zone closures, and navigational aid outages. Captures closure reference, infrastructure type and asset reference (FK to berth, channel, port_gate, or terminal_zone), closure reason (maintenance, inspection, incident, weather, dredging, structural failure), planned start datetime, planned end datetime, actual start datetime, actual end datetime, severity level (full closure, partial restriction, reduced capacity), operational impact description, estimated revenue impact, affected vessel calls count, notification distribution list, and authorizing officer. Supports port operations continuity planning and vessel schedule re-routing.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` (
    `permit_id` BIGINT COMMENT 'Unique identifier for the infrastructure permit record. Primary key for the infrastructure permit entity.',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to contract.agreement. Business justification: Environmental and regulatory permits are often conditions precedent in concession agreements; agreement effectiveness and operator compliance depend on permit validity. Required for regulatory complia',
    `facility_security_plan_id` BIGINT COMMENT 'Foreign key linking to security.facility_security_plan. Business justification: Environmental and construction permits for infrastructure work may require FSP amendments to address security implications (new access points, temporary closures, contractor access). Real business pro',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Permits require designated officer for accountability, renewal notifications, and regulatory correspondence. Replaces denormalized responsible_officer_name/email with proper FK for contact management ',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to procurement.vendor. Business justification: Environmental permits, dredging permits, construction permits often require specialist consultants for application preparation and compliance monitoring. Links permit to consultant vendor for cost tra',
    `wbs_element_id` BIGINT COMMENT 'Foreign key linking to finance.wbs_element. Business justification: Major permits (environmental, construction, dredging) incur costs that must be capitalized to specific WBS elements. Port project managers allocate permit application fees, consultant costs, and compl',
    `appeal_deadline_date` DATE COMMENT 'Final date by which an appeal or objection to permit conditions or denial can be lodged with the regulatory authority or administrative tribunal.',
    `application_date` DATE COMMENT 'Date when the permit application was formally submitted to the issuing authority. Used to track processing timelines and regulatory response times.',
    `associated_infrastructure_type` STRING COMMENT 'Type of port infrastructure asset or facility that this permit authorizes construction, modification, operation, or maintenance activities for. [ENUM-REF-CANDIDATE: berth|quay_wall|wharf|channel|dredging_area|reclamation_site|warehouse|terminal|breakwater|fender_system|navigational_aid — 11 candidates stripped; promote to reference product]',
    `audit_inspection_schedule` STRING COMMENT 'Schedule of regulatory audits, site inspections, or compliance reviews mandated by the permit. Includes frequency, scope, and advance notice requirements.',
    `compliance_monitoring_requirements` STRING COMMENT 'Description of ongoing monitoring, measurement, and reporting obligations required to demonstrate permit compliance. Includes frequency, parameters, and submission requirements.',
    `conditions_summary` STRING COMMENT 'High-level summary of the key conditions, restrictions, and obligations imposed by the permit. Provides an overview of compliance requirements without exhaustive detail.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this permit record was first created in the port management information system. Used for audit trail and data lineage tracking.',
    `document_reference` STRING COMMENT 'File path, document management system reference, or URL pointing to the official permit documentation including the approval letter, conditions schedule, and supporting materials.',
    `effective_date` DATE COMMENT 'Date from which the permit becomes legally effective and enforceable. May differ from issue date if the permit includes a delayed commencement clause.',
    `environmental_sensitivity_flag` BOOLEAN COMMENT 'Indicates whether the permitted activities are in or adjacent to environmentally sensitive areas requiring enhanced monitoring and protection measures. True if the area has special environmental significance.',
    `expiry_date` DATE COMMENT 'Date when the permit validity period ends and the authorization ceases to be enforceable. Nullable for permits with indefinite validity subject to ongoing compliance.',
    `financial_security_amount` DECIMAL(18,2) COMMENT 'Monetary value of the required financial security instrument in the port operating currency. Nullable if no financial security is required.',
    `financial_security_currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the financial security amount. Examples include USD, EUR, GBP.. Valid values are `^[A-Z]{3}$`',
    `financial_security_required_flag` BOOLEAN COMMENT 'Indicates whether the permit requires the posting of a financial bond, guarantee, or insurance policy to cover potential environmental remediation or restoration costs. True if financial security is mandated.',
    `geographic_scope` STRING COMMENT 'Description of the geographic area, zone, or specific infrastructure locations covered by this permit. May reference berth numbers, channel sections, or port facility coordinates.',
    `issue_date` DATE COMMENT 'Date when the permit was officially issued or granted by the regulatory authority. Marks the beginning of the permit validity period.',
    `issuing_authority` STRING COMMENT 'Name of the regulatory body or government agency that issued the permit. Examples include National Maritime Authority, Environmental Protection Agency, Local Planning Authority, or Port State Control Authority.',
    `issuing_authority_code` STRING COMMENT 'Standardized code or identifier for the issuing authority used for system integration and reporting purposes.',
    `key_conditions` STRING COMMENT 'Detailed listing of critical permit conditions that must be met for ongoing compliance. Includes specific technical requirements, operational constraints, monitoring obligations, and reporting deadlines.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent regulatory inspection or compliance audit conducted under this permit. Used to track inspection history and compliance trends.',
    `last_inspection_outcome` STRING COMMENT 'Result of the most recent regulatory inspection indicating compliance status. Non-compliant outcomes may trigger corrective action requirements or enforcement proceedings.. Valid values are `compliant|non_compliant|conditional_compliance|not_inspected`',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this permit record. Used for change tracking and data currency verification.',
    `next_inspection_date` DATE COMMENT 'Scheduled date for the next regulatory inspection or compliance audit. Used for operational planning and readiness preparation.',
    `non_compliance_count` STRING COMMENT 'Total number of non-compliance incidents or violations recorded against this permit since issuance. Used for risk assessment and compliance performance tracking.',
    `non_compliance_history` STRING COMMENT 'Record of past non-compliance incidents, violations, or breaches associated with this permit. Includes dates, nature of violations, and corrective actions taken.',
    `permit_number` STRING COMMENT 'Official permit number or reference code issued by the regulatory authority. This is the externally-known identifier used in all regulatory correspondence and compliance documentation.',
    `permit_status` STRING COMMENT 'Current lifecycle status of the permit indicating its validity and enforceability. Active status indicates the permit is currently valid and enforceable; expired or revoked status indicates the permit is no longer valid. [ENUM-REF-CANDIDATE: applied|under_review|granted|active|suspended|expired|revoked|withdrawn — 8 candidates stripped; promote to reference product]',
    `permit_type` STRING COMMENT 'Classification of the permit based on the nature of the infrastructure activity being authorized. Determines the regulatory framework and compliance requirements applicable to the permit. [ENUM-REF-CANDIDATE: environmental_impact_assessment|building_construction|dredging|reclamation|heritage_archaeological|marine_discharge|noise|air_emissions|waste_disposal|coastal_works — 10 candidates stripped; promote to reference product]',
    `regulatory_framework` STRING COMMENT 'Citation of the primary legislation, regulation, or international convention under which this permit was issued. Examples include MARPOL Annex, national environmental protection acts, or local planning ordinances.',
    `remarks` STRING COMMENT 'Additional notes, comments, or contextual information about the permit that does not fit into structured fields. May include historical context, special circumstances, or operational considerations.',
    `renewal_date` DATE COMMENT 'Target date for permit renewal application or renewal decision. Used for proactive compliance management and to avoid lapses in authorization.',
    `renewal_lead_time_days` STRING COMMENT 'Number of days before expiry that the renewal application must be submitted to the issuing authority. Critical for compliance planning and avoiding operational disruptions.',
    `responsible_department` STRING COMMENT 'Name of the internal port department or business unit responsible for managing compliance with this permit. Typically Infrastructure Development, Engineering, or Environmental Management.',
    `revocation_date` DATE COMMENT 'Date when the permit was permanently revoked by the issuing authority. Revocation terminates the authorization and may prevent future applications for a specified period.',
    `revocation_reason` STRING COMMENT 'Explanation of the grounds for permit revocation including the serious violations, misrepresentations, or conditions that led to permanent cancellation of the authorization.',
    `scope_description` STRING COMMENT 'Detailed description of the infrastructure activities, works, or operations covered under this permit. Includes the nature, scale, and location of authorized activities.',
    `suspension_date` DATE COMMENT 'Date when the permit was suspended by the issuing authority due to non-compliance or other regulatory concerns. Nullable if the permit has never been suspended.',
    `suspension_reason` STRING COMMENT 'Explanation of the grounds for permit suspension including the specific violations or conditions that triggered the suspension action.',
    `title` STRING COMMENT 'Official title or name of the permit as stated in the regulatory approval documentation.',
    `validity_period_months` STRING COMMENT 'Duration of the permit validity period expressed in months from the effective date. Used for planning renewal cycles and compliance calendars.',
    CONSTRAINT pk_permit PRIMARY KEY(`permit_id`)
) COMMENT 'Master record for regulatory permits, approvals, and consents required for port infrastructure construction, dredging, disposal, reclamation, and operations. Captures permit number, permit type (environmental impact assessment, building/construction, dredging, reclamation, heritage/archaeological, marine discharge, noise), issuing authority (national maritime authority, environmental protection agency, local planning authority), permit title, scope description, conditions summary, key conditions with compliance deadlines, issue date, expiry date, renewal lead time, renewal date, compliance monitoring requirements, audit/inspection schedule, non-compliance history, and permit status (applied, granted, active, suspended, expired, revoked). Supports regulatory compliance across IMO conventions, national maritime authority requirements, and environmental agency mandates. SSOT for all infrastructure-related regulatory authorizations.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` (
    `infrastructure_berth_reservation_id` BIGINT COMMENT 'Primary key for infrastructure_berth_reservation',
    `berth_id` BIGINT COMMENT 'Foreign key linking to the berth being reserved for this vessel call',
    `booking_berth_reservation_id` BIGINT COMMENT 'Unique identifier for this berth reservation record. Primary key.',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to the vessel call booking that this berth reservation serves',
    `actual_atb` TIMESTAMP COMMENT 'Actual timestamp when the vessel berthed at this specific berth. Populated after berthing operation completes.',
    `actual_atd` TIMESTAMP COMMENT 'Actual timestamp when the vessel departed from this specific berth. Populated after unberthing operation completes.',
    `assigned_berth_code` STRING COMMENT 'Code identifying the actual berth location assigned by port operations for the vessel call. [Moved from call_booking: This attribute represents the confirmed berth for a specific reservation, not a property of the booking itself. A vessel call booking may have multiple berth assignments over time (e.g., shift from one berth to another during the call).]',
    `berth_side` STRING COMMENT 'The side of the vessel that will be alongside the berth during this reservation. Critical for cargo operations planning and crane positioning.',
    `berth_utilization_hours` DECIMAL(18,2) COMMENT 'Calculated duration in hours that the berth was occupied by this vessel call, from ATB to ATD. Used for berth productivity and billing calculations.',
    `cancellation_reason` STRING COMMENT 'Explanation for why this berth reservation was cancelled (e.g., vessel schedule change, berth unavailability, operational constraints).',
    `planned_etb` TIMESTAMP COMMENT 'Planned estimated timestamp when the vessel is expected to berth at this specific berth. May differ from the booking-level ETB if berth assignment changes.',
    `planned_etd` TIMESTAMP COMMENT 'Planned estimated timestamp when the vessel is expected to depart from this specific berth. Used for berth utilization planning.',
    `priority_level` STRING COMMENT 'Priority classification for this berth reservation, used in conflict resolution and resource allocation decisions by port operations.',
    `remarks` STRING COMMENT 'Free-text field for operational notes specific to this berth reservation, such as special handling requirements or coordination details.',
    `requested_berth_code` STRING COMMENT 'Code identifying the preferred or requested berth location for the vessel call as specified by the shipping line or agent. [Moved from call_booking: This attribute represents the initial berth preference for a specific reservation attempt, not a property of the booking itself. In a multi-berth scenario, the booking may have multiple reservation attempts with different requested berths.]',
    `reservation_cancelled_timestamp` TIMESTAMP COMMENT 'Timestamp when this berth reservation was cancelled, either due to booking cancellation or berth reallocation.',
    `reservation_confirmed_timestamp` TIMESTAMP COMMENT 'Timestamp when this berth reservation was officially confirmed by port operations, locking the berth allocation.',
    `reservation_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this berth reservation record was first created by port operations or the berth allocation system.',
    `reservation_status` STRING COMMENT 'Current lifecycle status of the berth reservation. Tracks progression from initial request through confirmation, active berthing, and completion.',
    `tidal_window_required` BOOLEAN COMMENT 'Indicates whether this specific berth reservation requires tidal window coordination due to vessel draft and berth depth constraints.',
    CONSTRAINT pk_infrastructure_berth_reservation PRIMARY KEY(`infrastructure_berth_reservation_id`)
) COMMENT 'This association product represents the reservation/assignment event between a berth and a vessel call booking. It captures the operational allocation of a specific berth to a specific vessel call, including reservation priority, tidal constraints, planned and actual berthing/departure times, berth side assignment, and utilization metrics. Each record links one berth to one vessel call booking with attributes that exist only in the context of this specific berthing operation.. Existence Justification: In maritime port operations, a berth can host many vessel calls over time (sequential reservations), and a vessel call can legitimately require multiple berths during a single port visit. Multi-berth operations occur for large cruise ships, ro-ro vessels with multiple loading points, or when a vessel shifts berths mid-call due to cargo operations or berth availability. The berth reservation is a recognized operational entity that port operations teams actively manage, with its own lifecycle, priority levels, and timing attributes distinct from both the berth infrastructure and the booking request.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` (
    `infrastructure_anchorage_booking_id` BIGINT COMMENT 'Primary key for infrastructure_anchorage_booking',
    `anchorage_area_id` BIGINT COMMENT 'Foreign key linking to the anchorage area where the vessel is assigned to anchor',
    `booking_anchorage_booking_id` BIGINT COMMENT 'Unique identifier for this anchorage booking record. Primary key for the association.',
    `employee_id` BIGINT COMMENT 'Identifier of the port operations or VTS user who allocated this anchorage area to the vessel call.',
    `call_booking_id` BIGINT COMMENT 'Foreign key linking to the vessel call booking that requires anchorage',
    `vessel_id` BIGINT COMMENT 'add column vessel_id (BIGINT) with FK to vessel.vessel.vessel_id - anchorage bookings must identify which vessel is being assigned the anchorage',
    `actual_anchor_drop_time` TIMESTAMP COMMENT 'Actual timestamp when the vessel dropped anchor in this anchorage area as confirmed by VTS or AIS monitoring. Populated after the anchoring event occurs.',
    `actual_anchor_up_time` TIMESTAMP COMMENT 'Actual timestamp when the vessel weighed anchor and departed this anchorage area as confirmed by VTS or AIS monitoring. Populated after the departure event occurs.',
    `allocation_timestamp` TIMESTAMP COMMENT 'Timestamp when this anchorage area was officially allocated to the vessel call by port operations or VTS.',
    `anchorage_booking_status` STRING COMMENT 'Current lifecycle status of this anchorage booking. Tracks progression from request through allocation, occupation, and departure.',
    `anchorage_duration_hours` DECIMAL(18,2) COMMENT 'Calculated or estimated duration in hours that the vessel will occupy this anchorage area. Used for capacity planning and billing purposes.',
    `anchorage_reason_code` STRING COMMENT 'Operational reason why the vessel is assigned to this anchorage area. Determines anchorage category selection and service coordination requirements.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this anchorage booking record was first created in the system.',
    `priority_level` STRING COMMENT 'Priority level assigned to this anchorage booking. Emergency and high-priority vessels receive preferential anchorage allocation and VTS monitoring.',
    `requested_anchor_drop_time` TIMESTAMP COMMENT 'Timestamp when the vessel or agent requested to drop anchor in this anchorage area. Used for anchorage capacity planning and VTS coordination.',
    `requested_anchor_up_time` TIMESTAMP COMMENT 'Timestamp when the vessel is expected to weigh anchor and depart this anchorage area. Used for anchorage capacity planning and berth coordination.',
    `special_requirements` STRING COMMENT 'Free-text field capturing any special requirements or conditions for this anchorage booking (e.g., security escort, environmental monitoring, restricted area access).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this anchorage booking record was last modified.',
    `vts_coordination_reference` STRING COMMENT 'Reference code or identifier linking this anchorage booking to the Vessel Traffic Services coordination record. Used for VTS monitoring and communication.',
    CONSTRAINT pk_infrastructure_anchorage_booking PRIMARY KEY(`infrastructure_anchorage_booking_id`)
) COMMENT 'This association product represents the operational booking and assignment of a vessel call to a specific anchorage area within the port. It captures the anchorage-specific coordination data that exists only in the context of linking a vessel call booking to an anchorage area, including the reason for anchorage use, requested and actual anchor drop times, duration, priority level, and VTS coordination reference. Each record represents one anchorage assignment within a vessels port call lifecycle.. Existence Justification: In maritime port operations, a vessel call booking can require multiple anchorage assignments during a single port visit (e.g., quarantine anchorage upon arrival, waiting anchorage before berth availability, bunkering anchorage for refueling). Conversely, an anchorage area hosts many different vessel calls over time. The anchorage booking is an operational coordination entity actively managed by VTS and port operations, tracking reason codes, requested/actual anchor drop times, duration, priority, and VTS coordination for each vessel-anchorage assignment.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` (
    `infrastructure_berth_allocation_id` BIGINT COMMENT 'Primary key for infrastructure_berth_allocation',
    `agreement_id` BIGINT COMMENT 'Foreign key linking to the commercial agreement governing this berth allocation',
    `berth_id` BIGINT COMMENT 'Foreign key linking to the berth being allocated under this agreement',
    `terminal_berth_allocation_id` BIGINT COMMENT 'Unique identifier for this berth allocation record. Primary key.',
    `allocation_end_date` DATE COMMENT 'The date when this berth allocation expires or terminates. For time-sliced allocations, this defines the end of the allocation window. Nullable for open-ended allocations that follow agreement expiry. Explicitly identified in detection phase relationship data.',
    `allocation_start_date` DATE COMMENT 'The date when this berth allocation becomes effective under the agreement. For time-sliced allocations, this defines the start of the allocation window. Explicitly identified in detection phase relationship data.',
    `allocation_status` STRING COMMENT 'Current operational status of this berth allocation. Active: allocation is in effect; Suspended: temporarily inactive due to operational or commercial reasons; Expired: allocation period has ended; Terminated: allocation cancelled before expiry date.',
    `allocation_type` STRING COMMENT 'Classification of the allocation arrangement. Permanent: continuous allocation for agreement duration; Seasonal: recurring seasonal allocation (e.g., cruise season); Time_sliced: specific days/hours per week; On_demand: ad-hoc allocation subject to availability.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this berth allocation record was created in the system.',
    `exclusive_use_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this allocation grants exclusive use rights to the berth during the allocation period. True means no other parties can use the berth; False means shared or time-sliced use is permitted. Explicitly identified in detection phase relationship data.',
    `licensed_berths` STRING COMMENT 'For stevedoring-type agreements: comma-separated list of berth identifiers where the stevedoring company is authorized to perform cargo handling operations (e.g., B01, B02, B05). [Moved from agreement: The licensed_berths attribute in the agreement product is a comma-separated list of berth identifiers, which is a denormalized representation of the many-to-many relationship. This attribute should be removed from agreement and replaced by the properly normalized berth_allocation association, which allows each berth-agreement pairing to have its own allocation terms, dates, priority levels, and throughput commitments. The current string list cannot capture berth-specific allocation attributes.]',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this berth allocation record was last modified.',
    `priority_level` STRING COMMENT 'The priority or precedence level for this berth allocation when multiple agreements cover the same berth. Exclusive: sole use rights; Priority: first-right-of-refusal; Standard: shared access; Backup: contingency use only. Explicitly identified in detection phase relationship data.',
    `revenue_share_percentage` DECIMAL(18,2) COMMENT 'The percentage of gross revenue generated at this specific berth that is shared with the port authority under this allocation. May differ from the overall agreement revenue share if berth-specific commercial terms apply. Explicitly identified in detection phase relationship data.',
    `throughput_commitment_teu` DECIMAL(18,2) COMMENT 'The contractual minimum throughput volume (in Twenty-foot Equivalent Units) that the agreement holder commits to handle at this specific berth. Used for performance monitoring and revenue guarantee calculations. Berth-specific commitment that may differ from overall agreement throughput targets. Explicitly identified in detection phase relationship data.',
    `time_window_specification` STRING COMMENT 'For time-sliced allocations, specifies the recurring time windows when this berth is allocated to the agreement holder. Format examples: Mon-Fri 08:00-18:00, Weekends only, First week of each month. Nullable for non-time-sliced allocations.',
    CONSTRAINT pk_infrastructure_berth_allocation PRIMARY KEY(`infrastructure_berth_allocation_id`)
) COMMENT 'This association product represents the contractual allocation of berths to commercial agreement holders (shipping lines, stevedoring companies, terminal operators, concessionaires). It captures the business arrangement whereby specific berths are licensed, leased, or allocated under commercial agreements with defined time windows, priority levels, exclusivity terms, and performance commitments. Each record links one berth to one agreement with attributes that exist only in the context of this allocation relationship, enabling time-sliced berth sharing, priority-based allocation, and multi-berth concessions.. Existence Justification: In maritime port operations, berths are allocated to commercial parties (shipping lines, stevedoring companies, terminal operators) under various agreement types including concessions, stevedoring contracts, and service agreements. A single berth can be shared by multiple operators through time-sliced allocation (e.g., weekday vs weekend use), priority-based allocation (exclusive vs shared access), or seasonal allocation (cruise season vs cargo season). Conversely, a single multi-terminal concession agreement or stevedoring contract routinely covers multiple berths across different quays or terminals. The allocation itself is an actively managed business entity with specific attributes: allocation time windows, priority levels, exclusivity terms, berth-specific throughput commitments, and berth-specific revenue share percentages.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` (
    `project_permit_id` BIGINT COMMENT 'Unique identifier for this project-permit relationship record. Primary key for the association.',
    `permit_id` BIGINT COMMENT 'Foreign key linking to the regulatory permit that authorizes or governs this project',
    `project_id` BIGINT COMMENT 'Foreign key linking to the infrastructure project that requires or is covered by this permit',
    `application_date` DATE COMMENT 'Date when the permit application was submitted to the regulatory authority specifically for this infrastructure project. This is project-specific and may differ from the permits original application date if the permit covers multiple projects.',
    `approval_date` DATE COMMENT 'Date when the permit was approved or granted for this specific infrastructure project. For master permits covering multiple projects, this represents when this project was added to the permit scope.',
    `compliance_tracking_status` STRING COMMENT 'Current compliance status of the project against the conditions and requirements of this specific permit. Values: compliant (all conditions met), non_compliant (violations identified), under_review (compliance audit in progress), remediation_in_progress (corrective actions underway), not_applicable (permit not yet active or project phase not covered).',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this project-permit relationship record was created in the system.',
    `environmental_permit_reference` STRING COMMENT 'Reference number for the environmental impact assessment approval or environmental permit required for the project, ensuring compliance with MARPOL and local environmental regulations. [Moved from infrastructure_project: This attribute in infrastructure_project is a single reference to an environmental permit, but projects typically require multiple environmental permits (EIA, marine discharge, noise, etc.). This should be replaced by explicit project_permit records linking to the relevant infrastructure_permit records, where permit-specific details are tracked.]',
    `last_compliance_review_date` DATE COMMENT 'Date of the most recent compliance review or audit conducted for this project against this permits requirements. Used for tracking compliance monitoring schedules.',
    `last_updated_date` TIMESTAMP COMMENT 'Timestamp when this project-permit relationship record was last modified.',
    `next_compliance_review_date` DATE COMMENT 'Scheduled date for the next compliance review or regulatory inspection for this project under this permit. Used for proactive compliance management.',
    `permit_cost_allocation` DECIMAL(18,2) COMMENT 'Portion of permit acquisition, application, and compliance costs allocated to this infrastructure project. For permits covering multiple projects, this represents this projects share of the total permit cost. Expressed in the projects budget currency.',
    `permit_criticality_to_project` STRING COMMENT 'Assessment of how critical this permit is to the projects ability to proceed. Values: critical (project cannot start without this permit), high (major delays if not obtained), medium (impacts specific work packages), low (administrative or post-completion permit).',
    `project_permit_status` STRING COMMENT 'Current status of this permit in the context of this specific project. Values: applied (application submitted), under_review (regulatory review in progress), approved (permit granted), active (permit in force for project activities), suspended (temporarily halted), withdrawn (application withdrawn), expired (permit validity ended for this project).',
    `project_specific_conditions` STRING COMMENT 'Additional conditions, restrictions, or requirements imposed by the regulatory authority specifically for this project under this permit. Supplements the general permit conditions with project-specific obligations.',
    `regulatory_approval_reference` STRING COMMENT 'Reference number or identifier for the primary regulatory approval or development consent required for the project, issued by port state control or maritime authority. [Moved from infrastructure_project: This attribute in infrastructure_project appears to reference a primary regulatory approval, but in reality, projects have multiple permits. This generic reference should be replaced by the explicit M:N relationship to infrastructure_permit, where each project-permit relationship can track its own approval details.]',
    `responsible_project_officer` STRING COMMENT 'Name or employee identifier of the project team member responsible for managing compliance with this permit for this specific project. This is the primary point of contact for regulatory inspections and compliance reporting related to this permit-project relationship.',
    CONSTRAINT pk_project_permit PRIMARY KEY(`project_permit_id`)
) COMMENT 'This association product represents the regulatory permit application and compliance relationship between infrastructure projects and the permits required to execute them. In maritime port infrastructure development, large CAPEX projects require portfolios of permits from multiple regulatory authorities (environmental, marine, construction, safety), and conversely, master permits (e.g., port development zone permits) can authorize multiple related projects. Each record links one infrastructure project to one infrastructure permit and captures application-specific data including submission dates, approval dates, project-specific compliance status, cost allocation for permit acquisition, and the responsible project officer managing that permit relationship. This is actively managed by project compliance teams through permit registers and regulatory tracking systems.. Existence Justification: In maritime port infrastructure development, large CAPEX projects routinely require portfolios of multiple permits from different regulatory authorities (environmental impact assessments, construction permits, dredging permits, marine discharge permits, heritage approvals). Conversely, master permits such as port development zone permits or environmental framework permits can authorize multiple related infrastructure projects within their scope. Project compliance teams actively manage these relationships through permit registers, tracking application dates, approval status, compliance obligations, and cost allocation for each project-permit combination.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` (
    `project_service_cost_id` BIGINT COMMENT 'Unique identifier for this project-service cost record. Primary key.',
    `employee_id` BIGINT COMMENT 'Employee identifier for the project manager or financial controller who approved this cost. Links to HR system for audit trail and authorization verification.',
    `project_id` BIGINT COMMENT 'Foreign key linking to the infrastructure project that consumed the service',
    `service_code_id` BIGINT COMMENT 'Foreign key linking to the service code that was applied to the project',
    `actual_cost` DECIMAL(18,2) COMMENT 'Cumulative actual cost incurred for this service on this project to date. Updated as invoices are received and posted from contractors or internal service providers.',
    `approval_date` DATE COMMENT 'Date when this project-service cost was approved. Null if approval_status is PENDING or REJECTED.',
    `approval_status` STRING COMMENT 'Approval status for this project-service cost, particularly relevant for costs exceeding budgeted amounts or requiring change order approval. PENDING (awaiting review), APPROVED (authorized for payment), REJECTED (not authorized), ESCALATED (requires senior management approval).',
    `budgeted_amount` DECIMAL(18,2) COMMENT 'Planned or budgeted cost for this service within this project, established during project planning phase. Used for variance analysis against actual costs.',
    `contractor_reference` STRING COMMENT 'Reference to the contractor, vendor, or internal department that provided this service to the project. Links to vendor master or organizational unit for procurement and performance tracking.',
    `cost_center` STRING COMMENT 'SAP Controlling (CO) cost center to which this project-service cost is allocated. Enables cost tracking by organizational unit or project phase.',
    `cost_status` STRING COMMENT 'Lifecycle status of this project-service cost: PLANNED (budgeted but not committed), COMMITTED (purchase order issued), ACCRUED (service delivered, invoice pending), INVOICED (invoice received), PAID (payment processed), DISPUTED (under review), CANCELLED (no longer applicable).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this project-service cost record was first created in the system. Format: yyyy-MM-ddTHH:mm:ss.SSSZ',
    `gl_posting_date` DATE COMMENT 'Date when the cost was posted to the General Ledger in SAP FI. Used for financial period reconciliation and accrual tracking.',
    `invoice_reference` STRING COMMENT 'Reference to the invoice document in SAP FI that recorded this cost. Enables traceability from project cost to source invoice for audit and dispute resolution.',
    `last_modified_by` STRING COMMENT 'User ID or name of the person who last updated this project-service cost record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this project-service cost record was last updated. Format: yyyy-MM-ddTHH:mm:ss.SSSZ',
    `notes` STRING COMMENT 'Free-text notes documenting special circumstances, variance explanations, change order references, or other contextual information about this project-service cost.',
    `quantity` DECIMAL(18,2) COMMENT 'Quantity of the service consumed or delivered for this project, measured in the unit of measure defined in the service_code (e.g., hours for engineering services, cubic meters for dredging, days for equipment rental).',
    `service_end_date` DATE COMMENT 'Date when this service was completed or ceased for this project. Null if service is ongoing. Used for duration-based billing and project phase tracking.',
    `service_start_date` DATE COMMENT 'Date when this service began being delivered or consumed for this project. Relevant for time-based services (consulting, equipment rental) and project timeline tracking.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the quantity consumed. Typically inherited from service_code.uom_code but captured here for historical accuracy if service code UOM changes over time.',
    `variance_amount` DECIMAL(18,2) COMMENT 'Calculated variance between budgeted_amount and actual_cost (actual_cost - budgeted_amount). Positive values indicate cost overrun, negative values indicate cost savings. Used for project financial performance reporting.',
    `created_by` STRING COMMENT 'User ID or name of the person who created this project-service cost record, typically the project manager or project accountant.',
    CONSTRAINT pk_project_service_cost PRIMARY KEY(`project_service_cost_id`)
) COMMENT 'This association product represents the consumption of port services during infrastructure project execution. It captures the financial and operational tracking of each service code applied to each infrastructure project. Each record links one infrastructure_project to one service_code with budgeted amounts, actual costs, quantities consumed, and GL posting details that exist only in the context of this project-service relationship. SSOT for CAPEX project cost tracking and variance analysis.. Existence Justification: In port infrastructure CAPEX projects, each project consumes multiple service codes (engineering design, dredging, construction, equipment rental, consulting, regulatory compliance services), and each service code is applied across multiple infrastructure projects over time. Project managers actively track budgeted vs actual costs, quantities consumed, and GL postings for each project-service combination as part of project cost control and variance analysis. This is an operational business process, not an analytical correlation.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` (
    `warehouse_commodity_approval_id` BIGINT COMMENT 'Unique identifier for the warehouse commodity approval record. Primary key.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to the commodity code that is approved for storage in the warehouse',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to the warehouse facility that has been approved to handle the commodity',
    `approval_authority` STRING COMMENT 'Regulatory or operational authority that granted the approval for this warehouse-commodity combination (e.g., Customs for bonded goods, IMDG Inspector for hazardous materials)',
    `approval_certificate_number` STRING COMMENT 'Official certificate or license number issued by the approval authority for this specific warehouse-commodity approval',
    `approval_date` DATE COMMENT 'Date when the warehouse was officially approved to handle this commodity type by the relevant authority (customs, port authority, fire marshal, or IMDG inspector)',
    `approval_expiry_date` DATE COMMENT 'Date when the approval expires and requires renewal. Null for approvals with no expiration.',
    `approval_status` STRING COMMENT 'Current status of the approval: Active (in effect), Suspended (temporarily halted), Expired (past expiry date), Revoked (cancelled by authority), Pending_Renewal (renewal application submitted)',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this approval record was created in the system',
    `designated_storage_zone` STRING COMMENT 'Specific zone, bay, or area within the warehouse designated for this commodity type (e.g., Bay A1-A3, Reefer zone, Bonded section)',
    `inspection_frequency_days` STRING COMMENT 'Required inspection frequency in days for this commodity in this warehouse (e.g., 30 for monthly hazmat inspections, 90 for quarterly bonded goods audits)',
    `last_inspection_date` DATE COMMENT 'Date of the most recent compliance inspection for this warehouse-commodity combination',
    `last_updated_by` STRING COMMENT 'User ID or system identifier that last modified this approval record',
    `last_updated_date` TIMESTAMP COMMENT 'Timestamp when this approval record was last modified',
    `maximum_quantity_tonnes` DECIMAL(18,2) COMMENT 'Maximum quantity in tonnes of this commodity that can be stored in this warehouse simultaneously, as specified by the approval authority or operational safety limits',
    `next_inspection_due_date` DATE COMMENT 'Calculated date when the next compliance inspection is due based on inspection frequency',
    `segregation_requirements` STRING COMMENT 'IMDG segregation requirements for this commodity in this warehouse (e.g., Segregate from Class 1, 4, 5, Minimum 3m separation from oxidizers, Separate bay required)',
    `special_handling_instructions` STRING COMMENT 'Warehouse-specific handling instructions for this commodity (e.g., Use explosion-proof forklifts only, No smoking within 50m, Reefer plugs required)',
    `storage_conditions` STRING COMMENT 'Specific storage conditions required for this commodity in this warehouse (e.g., Temperature 2-8°C, humidity <60%, segregated from Class 3, Bonded area only, Ground floor, max stack height 3m)',
    `suspension_reason` STRING COMMENT 'Reason for suspension or revocation if approval_status is Suspended or Revoked. Null for Active approvals.',
    `created_by` STRING COMMENT 'User ID or system identifier that created this approval record',
    CONSTRAINT pk_warehouse_commodity_approval PRIMARY KEY(`warehouse_commodity_approval_id`)
) COMMENT 'This association product represents the regulatory approval and operational authorization for a warehouse to store and handle a specific commodity type. It captures approval dates, storage conditions, quantity limits, and segregation rules required for regulatory compliance (IMDG, customs, MARPOL) and operational safety. Each record links one warehouse to one commodity code with attributes that exist only in the context of this approval relationship.. Existence Justification: In maritime port operations, warehouses must obtain regulatory approvals to handle specific commodity types based on IMDG class, bonded status, temperature control requirements, and hazardous goods classifications. A single warehouse facility can be approved to handle multiple commodity types (e.g., a bonded warehouse approved for reefer cargo, general cargo, and IMDG Class 3 flammables), and each commodity type can be stored in multiple warehouses across the port (e.g., reefer commodities can be stored in multiple reefer-capable warehouses). The approval relationship itself carries critical operational and compliance data including approval dates, authority certificates, storage conditions, quantity limits, segregation rules, and inspection schedules that belong to neither the warehouse nor the commodity code alone.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` (
    `warehouse_imdg_approval_id` BIGINT COMMENT 'Unique identifier for this warehouse-IMDG class approval record. Primary key.',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to the IMDG hazard class for which this warehouse is approved',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to the warehouse facility that holds this IMDG class approval',
    `approval_authority` STRING COMMENT 'Name of the regulatory body, port authority, or certification agency that granted this approval (e.g., Port Safety Authority, Maritime Safety Administration, Fire Marshal). Required for audit trail and compliance verification.',
    `approval_date` DATE COMMENT 'Date when the warehouse facility received official approval from the port authority or regulatory body to store this specific IMDG hazard class. Used for compliance tracking and renewal scheduling.',
    `approval_expiry_date` DATE COMMENT 'Date when this approval expires and requires renewal. Null for indefinite approvals subject to periodic inspection. Used to trigger renewal workflows and prevent non-compliant storage.',
    `approval_status` STRING COMMENT 'Current lifecycle status of this approval. Active for valid approvals, Suspended for temporary holds pending corrective action, Expired for lapsed approvals, Pending_Renewal for approvals in renewal process, Revoked for permanently withdrawn approvals.',
    `certification_document_reference` STRING COMMENT 'Reference number or document management system identifier for the official approval certificate or compliance documentation. Used for audit trail and regulatory inspections.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this approval record was first created in the system. Used for audit trail and compliance reporting.',
    `emergency_contact` STRING COMMENT 'Name and contact information for the designated emergency response coordinator or safety officer responsible for incidents involving this IMDG class in this warehouse. Used for emergency response activation.',
    `fire_suppression_requirements` STRING COMMENT 'Specific fire suppression system requirements or configurations mandated for storing this IMDG class in this warehouse (e.g., foam system for Class 3 flammable liquids, CO2 for Class 4.2 spontaneously combustible, water spray for Class 8 corrosives). Must align with warehouse.fire_suppression_system_type capability.',
    `imdg_class_approvals` STRING COMMENT 'Comma-separated list of IMDG hazard classes that the warehouse is certified to store (e.g., 3,4.1,6.1,8,9). Empty if not approved for dangerous goods. Classes: 1-Explosives, 2-Gases, 3-Flammable Liquids, 4-Flammable Solids, 5-Oxidizers, 6-Toxic, 7-Radioactive, 8-Corrosives, 9-Miscellaneous. [Moved from warehouse: This comma-separated list attribute in warehouse represents a denormalized many-to-many relationship. The proper normalized model requires moving this to the association table where each approval is a separate record with its own approval_date, approval_authority, quantity limits, and compliance attributes. The warehouse table should not contain a list of IMDG classes; instead, the relationship should be queried through the warehouse_imdg_approval association.]',
    `inspection_frequency_days` STRING COMMENT 'Required frequency in days between safety inspections for this IMDG class storage in this warehouse. More hazardous classes require more frequent inspections (e.g., 30 days for Class 1, 90 days for Class 9). Used to schedule compliance audits.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent safety inspection conducted for this IMDG class storage capability in this warehouse. Used with inspection_frequency_days to determine next inspection due date.',
    `maximum_net_explosive_mass` DECIMAL(18,2) COMMENT 'Maximum net explosive mass (NEQ) in kilograms permitted for this IMDG class in this warehouse. Applies primarily to Class 1 (Explosives) and defines the upper limit for storage quantity based on warehouse construction, separation distances, and blast protection. Null for non-explosive classes.',
    `maximum_storage_quantity_tonnes` DECIMAL(18,2) COMMENT 'Maximum total quantity in tonnes of this IMDG class that may be stored in this warehouse at any time. Based on warehouse capacity, ventilation, fire suppression capability, and segregation requirements. Used for gate-in acceptance checks and yard planning.',
    `modified_by` STRING COMMENT 'User ID or name of the person who last modified this approval record. Used for change tracking and accountability.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this approval record was last modified. Used for audit trail and change tracking.',
    `next_inspection_due_date` DATE COMMENT 'Calculated or scheduled date for the next required safety inspection. Derived from last_inspection_date + inspection_frequency_days. Used for compliance monitoring and inspection scheduling.',
    `notes` STRING COMMENT 'Free-text notes for additional context, historical information, or operational guidance related to this specific warehouse-IMDG class approval. May include inspection findings, corrective actions taken, or special conditions.',
    `segregation_distance_meters` DECIMAL(18,2) COMMENT 'Minimum horizontal separation distance in meters required between this IMDG class and incompatible classes within the warehouse or from other storage areas. Based on IMDG Code segregation tables and local port regulations.',
    `special_handling_instructions` STRING COMMENT 'Free-text field capturing warehouse-specific handling procedures, restrictions, or operational notes for this IMDG class (e.g., store in north wing only, keep away from heat sources, require two-person handling, use explosion-proof equipment). Supplements standard IMDG Code requirements with local operational constraints.',
    `ventilation_requirements` STRING COMMENT 'Ventilation system requirements for this IMDG class in this warehouse (e.g., mechanical ventilation for Class 2 gases, natural ventilation acceptable for Class 9). Specifies air change rates or ventilation standards.',
    `created_by` STRING COMMENT 'User ID or name of the safety officer or compliance manager who created this approval record. Used for accountability and audit trail.',
    CONSTRAINT pk_warehouse_imdg_approval PRIMARY KEY(`warehouse_imdg_approval_id`)
) COMMENT 'This association product represents the regulatory approval and operational certification between a warehouse facility and an IMDG hazard class. It captures the specific compliance requirements, storage limitations, and safety protocols that govern the storage of each dangerous goods class in each warehouse. Each record links one warehouse to one IMDG class with attributes that exist only in the context of this approval relationship, including approval dates, quantity limits, segregation requirements, and inspection schedules mandated by IMDG Code and SOLAS regulations.. Existence Justification: In maritime port operations, warehouses must obtain specific regulatory approvals to store each IMDG hazard class, and each IMDG class can be stored in multiple approved warehouses across the port. The business actively manages these approvals as compliance entities with approval dates, expiry tracking, quantity limits, segregation distances, and inspection schedules. Safety officers and compliance managers create, update, and monitor these approval records to ensure IMDG Code and SOLAS regulatory compliance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` (
    `berth_service_contract_id` BIGINT COMMENT 'Unique identifier for this berth-vendor service contract relationship. Primary key.',
    `berth_id` BIGINT COMMENT 'Foreign key linking to the berth receiving services from the vendor',
    `agreement_id` BIGINT COMMENT 'add column contract_agreement_id (BIGINT) with FK to contract.agreement.agreement_id - berth service contracts should link to the master agreement domain for lifecycle tracking',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to the vendor providing services to the berth',
    `contract_end_date` DATE COMMENT 'The date when this service contract expires or was terminated. Null indicates an ongoing open-ended contract. Critical for tracking vendor changeovers and service continuity.',
    `contract_start_date` DATE COMMENT 'The date when this service contract between the vendor and berth becomes effective. Used for tracking contract validity and historical service provider relationships.',
    `contract_status` STRING COMMENT 'Current operational status of this berth-vendor service contract. Active contracts are in force; expired/terminated contracts provide historical record of past service providers.',
    `contract_value` DECIMAL(18,2) COMMENT 'The total monetary value of this service contract for the contract period. Used for budget tracking and vendor spend analysis by berth.',
    `primary_contact_name` STRING COMMENT 'Name of the specific vendor representative responsible for servicing this berth. May differ from the vendor master contact if the vendor assigns dedicated personnel to specific berths or terminals.',
    `primary_contact_phone` STRING COMMENT 'Direct phone number for the vendor contact responsible for this berth. Used for emergency callouts and service coordination.',
    `response_time_hours` DECIMAL(18,2) COMMENT 'The maximum number of hours within which the vendor must respond to a service request or emergency call for this berth. Response time requirements may vary by berth criticality and service type.',
    `service_level_agreement` STRING COMMENT 'The SLA tier or description defining the service quality commitments for this specific berth-vendor-service combination. May reference standard SLA codes or contain custom terms negotiated for critical berths.',
    `service_type` STRING COMMENT 'The specific type of service this vendor provides to this berth. A vendor may provide multiple service types to the same berth (requiring separate contract records), and different vendors may provide different services to the same berth.',
    CONSTRAINT pk_berth_service_contract PRIMARY KEY(`berth_service_contract_id`)
) COMMENT 'This association product represents the service contract between a berth and a vendor. It captures the specific services provided by each vendor to each berth, including maintenance of fender systems, bollard inspection, dredging, electrical services, and shore power maintenance. Each record links one berth to one vendor with service-specific terms, SLA commitments, and contract validity periods that exist only in the context of this relationship.. Existence Justification: In maritime port operations, each berth requires multiple specialized vendors for different maintenance and service functions (fender maintenance, bollard inspection, dredging, electrical, shore power). Simultaneously, each vendor typically services multiple berths across the port facility. The port authority actively manages these service contracts with berth-specific SLAs, response times, and contract terms that vary by berth criticality and service type.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` (
    `infrastructure_terminal_id` BIGINT COMMENT 'Primary key for terminal',
    `parent_terminal_id` BIGINT COMMENT 'Self-referencing FK on terminal (parent_terminal_id)',
    `port_id` BIGINT COMMENT 'Reference to the parent port facility that owns or operates this terminal.',
    `port_location_id` BIGINT COMMENT 'add column port_location_id (BIGINT) with FK to masterdata.port_location.port_location_id - terminals must reference their geographic location in the master data registry',
    `address_line1` STRING COMMENT 'Primary street address line of the terminal facility. Organizational contact data classified as confidential.',
    `address_line2` STRING COMMENT 'Secondary address line for additional location details (building, suite, zone). Organizational contact data classified as confidential.',
    `annual_throughput_capacity_teu` STRING COMMENT 'Maximum annual container handling capacity of the terminal measured in TEU. Represents the theoretical maximum throughput under optimal operating conditions. Applicable to container terminals only.',
    `city` STRING COMMENT 'City or municipality where the terminal is located.',
    `commissioning_date` DATE COMMENT 'Date when the terminal was officially commissioned and began commercial operations. Used for asset lifecycle tracking and depreciation calculations.',
    `country_code` STRING COMMENT 'Three-letter ISO country code of the terminal location (e.g., USA, CHN, SGP).',
    `crane_types` STRING COMMENT 'Comma-separated list of crane types available at the terminal (e.g., STS gantry, RTG, mobile harbor crane, bulk handling crane). Supports equipment capability assessment and vessel compatibility planning.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this terminal record was first created in the system. Used for data lineage and audit trail.',
    `customs_facility_available` BOOLEAN COMMENT 'Indicates whether the terminal has on-site customs inspection and clearance facilities. True if customs office and inspection zones exist, false otherwise.',
    `email_address` STRING COMMENT 'Primary email address for terminal operations and business inquiries. Organizational contact data classified as confidential.',
    `environmental_certification` STRING COMMENT 'Environmental management certifications held by the terminal (e.g., ISO 14001, EcoPorts, Green Marine). Comma-separated list if multiple certifications exist.',
    `free_trade_zone` BOOLEAN COMMENT 'Indicates whether the terminal operates within a designated free trade zone or foreign trade zone with special customs and tax treatment. True if FTZ status applies, false otherwise.',
    `last_expansion_date` DATE COMMENT 'Date of the most recent major capacity expansion or infrastructure upgrade project completion. Null if no expansions have occurred since commissioning.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the terminal center point in decimal degrees. Used for geospatial analysis, navigation planning, and GIS integration.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the terminal center point in decimal degrees. Used for geospatial analysis, navigation planning, and GIS integration.',
    `max_draft_m` DECIMAL(18,2) COMMENT 'Maximum vessel draft (depth below waterline) that can be safely accommodated at the terminal, measured in meters. Determined by channel depth, berth depth, and tidal variations.',
    `max_vessel_beam_m` DECIMAL(18,2) COMMENT 'Maximum beam (width) of vessel that can be accommodated at the terminal, measured in meters. Constrained by berth width and approach channel dimensions.',
    `max_vessel_length_m` DECIMAL(18,2) COMMENT 'Maximum length of vessel that can be accommodated at the terminal, measured in meters. Constrained by berth length and maneuvering basin dimensions.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this terminal record was last updated in the system. Used for data lineage and change tracking.',
    `next_maintenance_date` DATE COMMENT 'Planned date for the next major maintenance shutdown or infrastructure inspection. Used for operational planning and capacity forecasting.',
    `number_of_berths` STRING COMMENT 'Total count of vessel berths available at the terminal for simultaneous vessel operations.',
    `number_of_cranes` STRING COMMENT 'Total count of cargo handling cranes deployed at the terminal, including ship-to-shore gantry cranes, mobile harbor cranes, and rail-mounted gantry cranes.',
    `open_storage_area_sqm` DECIMAL(18,2) COMMENT 'Total uncovered outdoor storage area at the terminal measured in square meters. Used for container stacking, bulk cargo stockpiling, and vehicle parking.',
    `operational_status` STRING COMMENT 'Current operational state of the terminal in its lifecycle. Operational indicates active cargo handling, under construction indicates development phase, maintenance indicates temporary closure for repairs or upgrades, decommissioned indicates permanent closure, planned indicates future development, and suspended indicates temporary operational halt.',
    `operator_name` STRING COMMENT 'Name of the company or organization responsible for operating the terminal. May be the port authority, a private terminal operator, or a joint venture entity.',
    `operator_type` STRING COMMENT 'Classification of the terminal operating model. Port authority indicates direct government or port authority operation, private operator indicates fully privatized operation, joint venture indicates shared ownership between multiple entities, and public-private partnership indicates collaborative government-private sector arrangement.',
    `phone_number` STRING COMMENT 'Primary contact telephone number for the terminal operations center. Organizational contact data classified as confidential.',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the terminal location. Organizational contact data classified as confidential.',
    `rail_connection_available` BOOLEAN COMMENT 'Indicates whether the terminal has direct rail connectivity for intermodal cargo transfer. True if on-dock rail facilities exist, false otherwise.',
    `rail_track_length_m` DECIMAL(18,2) COMMENT 'Total length of rail tracks within the terminal facility measured in meters. Null if no rail connection exists.',
    `reefer_plug_capacity` STRING COMMENT 'Number of refrigerated container electrical connection points available at the terminal for temperature-controlled cargo. Applicable to container terminals handling perishable goods.',
    `security_certification` STRING COMMENT 'Highest level of international security certification held by the terminal. ISPS (International Ship and Port Facility Security Code) is mandatory for international ports, C-TPAT (Customs-Trade Partnership Against Terrorism) is US program, AEO (Authorized Economic Operator) is EU/international program.',
    `shore_power_available` BOOLEAN COMMENT 'Indicates whether the terminal provides shore-side electrical power (cold ironing) to berthed vessels, allowing them to shut down auxiliary engines and reduce emissions. True if shore power infrastructure exists, false otherwise.',
    `state_province` STRING COMMENT 'State, province, or administrative region where the terminal is located.',
    `storage_capacity_teu` STRING COMMENT 'Maximum container storage capacity of the terminal measured in TEU (Twenty-foot Equivalent Units). Applicable to container terminals only. Null for non-container terminals.',
    `terminal_code` STRING COMMENT 'Unique alphanumeric code assigned to the terminal for operational identification and system integration. Used in vessel manifests, cargo documentation, and port authority reporting.',
    `terminal_name` STRING COMMENT 'Official business name of the terminal facility.',
    `terminal_type` STRING COMMENT 'Classification of terminal based on primary cargo handling capability. Container terminals handle containerized cargo, bulk terminals handle dry or liquid bulk commodities, ro-ro terminals handle roll-on/roll-off vehicles and equipment, general cargo terminals handle break-bulk and non-containerized goods, cruise terminals handle passenger vessels, and multipurpose terminals support mixed operations.',
    `total_area_sqm` DECIMAL(18,2) COMMENT 'Total land area of the terminal facility measured in square meters, including berths, storage yards, warehouses, and operational zones.',
    `total_quay_length_m` DECIMAL(18,2) COMMENT 'Combined linear length of all quay walls and wharves at the terminal measured in meters. Determines the total vessel berthing capacity.',
    `truck_gate_lanes` STRING COMMENT 'Number of truck entry and exit gate lanes at the terminal for road cargo transfer. Determines truck processing capacity and gate throughput.',
    `warehouse_area_sqm` DECIMAL(18,2) COMMENT 'Total covered warehouse and storage facility area at the terminal measured in square meters. Used for cargo consolidation, temporary storage, and value-added services.',
    `website_url` STRING COMMENT 'Official website URL of the terminal for public information and service details.',
    CONSTRAINT pk_infrastructure_terminal PRIMARY KEY(`infrastructure_terminal_id`)
) COMMENT 'Master reference table for terminal. Referenced by terminal_id.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` (
    `weighing_station_id` BIGINT COMMENT 'Primary key for weighing_station',
    `berth_id` BIGINT COMMENT 'Reference to the specific berth associated with this weighing station for vessel cargo operations.',
    `parent_weighing_station_id` BIGINT COMMENT 'Self-referencing FK on weighing_station (parent_weighing_station_id)',
    `infrastructure_terminal_id` BIGINT COMMENT 'Reference to the marine terminal where this weighing station is located and operates.',
    `warehouse_id` BIGINT COMMENT 'Reference to the warehouse facility served by this weighing station for cargo storage and handling operations.',
    `accuracy_class` STRING COMMENT 'Metrological accuracy classification of the weighing station according to international standards for non-automatic weighing instruments.',
    `asset_acquisition_cost` DECIMAL(18,2) COMMENT 'Original capital expenditure (CAPEX) cost for procurement and installation of the weighing station, used for asset valuation and depreciation calculations.',
    `asset_currency_code` STRING COMMENT 'Three-letter ISO currency code for the asset acquisition cost and financial valuation.',
    `automated_data_capture_enabled` BOOLEAN COMMENT 'Indicates whether the weighing station is equipped with automated data capture capabilities for real-time weight transmission to port management systems.',
    `calibration_frequency_days` STRING COMMENT 'Required interval in days between calibration events as mandated by regulatory requirements or manufacturer specifications.',
    `certification_expiry_date` DATE COMMENT 'Date when the current certification for the weighing station expires and renewal is required.',
    `certification_number` STRING COMMENT 'Official certification or approval number issued by the national weights and measures authority authorizing the weighing station for commercial use.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this weighing station record was first created in the system.',
    `depreciation_method` STRING COMMENT 'Accounting method used to calculate depreciation of the weighing station asset over its useful life.',
    `environmental_protection_rating` STRING COMMENT 'Ingress Protection (IP) rating indicating the level of protection against dust and water ingress for outdoor marine environment operation.',
    `installation_date` DATE COMMENT 'Date when the weighing station was installed and commissioned at the port facility.',
    `integration_system_code` STRING COMMENT 'External system identifier used for integration with port operating systems, terminal operating systems (TOS), or enterprise resource planning (ERP) systems.',
    `last_calibration_date` DATE COMMENT 'Date of the most recent calibration performed on the weighing station to ensure measurement accuracy and regulatory compliance.',
    `last_maintenance_date` DATE COMMENT 'Date when the most recent preventive or corrective maintenance was performed on the weighing station.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this weighing station record was most recently modified in the system.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the weighing station location in decimal degrees format.',
    `load_cell_count` STRING COMMENT 'Number of load cells installed in the weighing station platform for weight measurement and distribution.',
    `location_zone` STRING COMMENT 'Port zone or area designation where the weighing station is physically located within the port facility.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the weighing station location in decimal degrees format.',
    `maintenance_contract_number` STRING COMMENT 'Reference number of the active maintenance service contract for the weighing station equipment.',
    `maintenance_provider_name` STRING COMMENT 'Name of the company or service provider responsible for maintenance and repair of the weighing station.',
    `manufacturer_name` STRING COMMENT 'Name of the company that manufactured the weighing station equipment.',
    `maximum_capacity_kg` DECIMAL(18,2) COMMENT 'Maximum weight capacity of the weighing station measured in kilograms, representing the upper limit for safe and accurate weighing operations.',
    `measurement_precision_kg` DECIMAL(18,2) COMMENT 'Smallest weight increment that the weighing station can accurately measure, expressed in kilograms.',
    `minimum_capacity_kg` DECIMAL(18,2) COMMENT 'Minimum weight capacity of the weighing station measured in kilograms, representing the lower threshold for accurate measurement.',
    `model_number` STRING COMMENT 'Manufacturer-assigned model number or designation for the weighing station equipment.',
    `next_calibration_due_date` DATE COMMENT 'Scheduled date for the next mandatory calibration of the weighing station to maintain accuracy certification and regulatory compliance.',
    `next_maintenance_due_date` DATE COMMENT 'Scheduled date for the next preventive maintenance service on the weighing station.',
    `notes` STRING COMMENT 'Additional free-text notes, comments, or special instructions related to the weighing station operation, maintenance, or configuration.',
    `operating_temperature_max_c` DECIMAL(18,2) COMMENT 'Maximum ambient temperature in degrees Celsius at which the weighing station can operate within specified accuracy limits.',
    `operating_temperature_min_c` DECIMAL(18,2) COMMENT 'Minimum ambient temperature in degrees Celsius at which the weighing station can operate within specified accuracy limits.',
    `operational_status` STRING COMMENT 'Current operational state of the weighing station indicating availability for weighing operations.',
    `platform_length_m` DECIMAL(18,2) COMMENT 'Length of the weighing platform measured in meters, determining the maximum vehicle or cargo size that can be accommodated.',
    `platform_width_m` DECIMAL(18,2) COMMENT 'Width of the weighing platform measured in meters, determining the lateral space available for cargo or vehicle positioning.',
    `power_supply_type` STRING COMMENT 'Type of electrical power supply used to operate the weighing station equipment and instrumentation.',
    `remote_monitoring_enabled` BOOLEAN COMMENT 'Indicates whether the weighing station supports remote monitoring and diagnostics capabilities for operational oversight.',
    `serial_number` STRING COMMENT 'Unique serial number assigned by the manufacturer to this specific weighing station unit for identification and warranty tracking.',
    `solas_vgm_compliant` BOOLEAN COMMENT 'Indicates whether the weighing station meets the accuracy and certification requirements for SOLAS VGM container weighing regulations.',
    `station_code` STRING COMMENT 'Externally-known unique alphanumeric code assigned to the weighing station for operational reference and system integration.',
    `station_name` STRING COMMENT 'Human-readable name or designation of the weighing station used for identification and reporting purposes.',
    `station_type` STRING COMMENT 'Classification of the weighing station based on its operational purpose and cargo handling capability.',
    `useful_life_years` STRING COMMENT 'Expected operational lifespan of the weighing station in years for depreciation and replacement planning purposes.',
    `weighbridge_type` STRING COMMENT 'Physical installation type of the weighbridge structure indicating mounting configuration and mobility characteristics.',
    CONSTRAINT pk_weighing_station PRIMARY KEY(`weighing_station_id`)
) COMMENT 'Master reference table for weighing_station. Referenced by weighing_station_id.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` (
    `facility_id` BIGINT COMMENT 'Primary key for facility',
    `project_id` BIGINT COMMENT 'Reference to the CAPEX project under which this facility was constructed or upgraded.',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the port authority or governing body responsible for managing this facility.',
    `facility_terminal_operator_port_community_participant_id` BIGINT COMMENT 'Reference to the terminal operator or concessionaire responsible for operating this facility.',
    `parent_facility_id` BIGINT COMMENT 'Self-referencing FK on facility (parent_facility_id)',
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

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` (
    `waste_reception_facility_id` BIGINT COMMENT 'Primary key for waste_reception_facility',
    `berth_id` BIGINT COMMENT 'Reference to the berth where this waste reception facility is located or primarily serves.',
    `parent_waste_reception_facility_id` BIGINT COMMENT 'Self-referencing FK on waste_reception_facility (parent_waste_reception_facility_id)',
    `port_community_participant_id` BIGINT COMMENT 'Reference to the organization responsible for operating and maintaining the waste reception facility.',
    `infrastructure_terminal_id` BIGINT COMMENT 'Reference to the marine terminal that operates or owns this waste reception facility.',
    `accepts_garbage` BOOLEAN COMMENT 'Indicates whether the facility can receive and process general garbage waste from vessels.',
    `accepts_hazardous_waste` BOOLEAN COMMENT 'Indicates whether the facility is licensed and equipped to handle hazardous waste materials.',
    `accepts_oily_waste` BOOLEAN COMMENT 'Indicates whether the facility can receive and process oily waste from vessels.',
    `accepts_sewage` BOOLEAN COMMENT 'Indicates whether the facility can receive and process sewage waste from vessels.',
    `address_line_1` STRING COMMENT 'Primary street address line for the waste reception facility location.',
    `address_line_2` STRING COMMENT 'Secondary address line for additional location details such as building or unit number.',
    `advance_notice_required_hours` STRING COMMENT 'Minimum number of hours advance notice required for vessels to request waste reception services.',
    `capacity_cubic_meters` DECIMAL(18,2) COMMENT 'Maximum storage capacity of the waste reception facility measured in cubic meters, representing the principal quantitative fact about this resource.',
    `certification_standard` STRING COMMENT 'Environmental management or quality certification standard that the facility complies with.',
    `city` STRING COMMENT 'City or municipality where the waste reception facility is located.',
    `commissioning_date` DATE COMMENT 'Date when the waste reception facility was officially commissioned and began operations.',
    `contact_email` STRING COMMENT 'Primary email address for booking and operational inquiries related to the waste reception facility.',
    `contact_phone` STRING COMMENT 'Primary contact phone number for the waste reception facility operations team.',
    `country_code` STRING COMMENT 'Three-letter ISO country code for the country where the facility is located.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this waste reception facility record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code for fees charged by this waste reception facility.',
    `decommissioning_date` DATE COMMENT 'Date when the waste reception facility was decommissioned and ceased operations, if applicable.',
    `disposal_method` STRING COMMENT 'Primary method used by the facility for final disposal or processing of collected waste.',
    `emergency_contact_phone` STRING COMMENT '24/7 emergency contact phone number for urgent waste reception incidents or spills.',
    `environmental_compliance_notes` STRING COMMENT 'Additional notes regarding environmental compliance, restrictions, or special handling requirements for this facility.',
    `facility_code` STRING COMMENT 'Externally-known unique business identifier for the waste reception facility, used in operational systems and regulatory reporting.',
    `facility_name` STRING COMMENT 'Official name of the waste reception facility as registered with port authority and maritime regulatory bodies.',
    `facility_type` STRING COMMENT 'Classification of the waste reception facility based on infrastructure configuration and operational model.',
    `inspection_compliance_status` STRING COMMENT 'Current compliance status based on the most recent regulatory inspection findings.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent regulatory or port authority inspection of the waste reception facility.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this waste reception facility record was last updated in the system.',
    `license_expiry_date` DATE COMMENT 'Date when the environmental license expires and requires renewal.',
    `license_issue_date` DATE COMMENT 'Date when the environmental license was issued by the regulatory authority.',
    `license_number` STRING COMMENT 'Official environmental license or permit number issued by regulatory authority authorizing waste reception operations.',
    `location_latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the waste reception facility location in decimal degrees.',
    `location_longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the waste reception facility location in decimal degrees.',
    `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next mandatory inspection of the waste reception facility.',
    `operating_hours` STRING COMMENT 'Standard operating hours for the waste reception facility, typically in format HH:MM-HH:MM or 24/7.',
    `operational_status` STRING COMMENT 'Current operational state of the waste reception facility in its lifecycle.',
    `postal_code` STRING COMMENT 'Postal or ZIP code for the waste reception facility address.',
    `service_fee_structure` STRING COMMENT 'Pricing model used for charging vessels for waste reception services.',
    `throughput_capacity_tons_per_day` DECIMAL(18,2) COMMENT 'Maximum daily processing throughput capacity of the facility measured in metric tons per day.',
    `waste_category` STRING COMMENT 'Primary category of waste handled by this facility. [ENUM-REF-CANDIDATE: oily_waste|sewage|garbage|hazardous_waste|cargo_residues|ballast_water|exhaust_gas_cleaning_residues|plastic_waste|food_waste|operational_waste|chemical_waste - promote to reference product]',
    CONSTRAINT pk_waste_reception_facility PRIMARY KEY(`waste_reception_facility_id`)
) COMMENT 'Master reference table for waste_reception_facility. Referenced by reception_facility_id.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` (
    `facility_building_id` BIGINT COMMENT 'Primary key for facility_building',
    `facility_id` BIGINT COMMENT 'add column facility_id (BIGINT) with FK to infrastructure.facility.facility_id - buildings must be linked to their parent facility for physical hierarchy',
    `parent_facility_building_id` BIGINT COMMENT 'Self-referencing FK on facility_building (parent_facility_building_id)',
    `access_control_system` STRING COMMENT 'Type of access control system deployed at the building for personnel and vehicle entry management (e.g., card reader, biometric, manned gate).',
    `acquisition_cost` DECIMAL(18,2) COMMENT 'Original acquisition or construction cost of the building in the reporting currency, used for capital asset tracking and depreciation.',
    `acquisition_date` DATE COMMENT 'Date when the building was acquired, purchased, or brought into the port authoritys asset portfolio.',
    `address_line1` STRING COMMENT 'Primary street address line of the building location within the port facility.',
    `address_line2` STRING COMMENT 'Secondary address line for additional location details (e.g., building number, zone designation).',
    `backup_power_available` BOOLEAN COMMENT 'Indicates whether the building has backup power generation capability (e.g., diesel generators, UPS systems) for critical operations continuity.',
    `building_code` STRING COMMENT 'Externally-known unique alphanumeric code assigned to the building for identification and reference in port operations, engineering drawings, and facility management systems.',
    `building_name` STRING COMMENT 'Human-readable name or designation of the building (e.g., Container Terminal Warehouse 3, Administration Building, Customs Inspection Facility).',
    `building_type` STRING COMMENT 'Classification of the building based on its primary functional purpose within the port infrastructure (e.g., warehouse, office, workshop, terminal, customs, inspection facility).',
    `cctv_coverage` BOOLEAN COMMENT 'Indicates whether the building has closed-circuit television surveillance system coverage for security monitoring.',
    `ceiling_height_m` DECIMAL(18,2) COMMENT 'Clear ceiling height measured in meters from floor to lowest structural or mechanical obstruction, important for cargo stacking and equipment clearance.',
    `city` STRING COMMENT 'City or municipality where the building is located.',
    `construction_year` STRING COMMENT 'Year when the building construction was completed and the facility became operational. Used for asset age analysis and depreciation calculations.',
    `country_code` STRING COMMENT 'Three-letter ISO country code identifying the country where the building is located.',
    `crane_capacity_tonnes` DECIMAL(18,2) COMMENT 'Maximum lifting capacity in metric tonnes of overhead cranes or gantry cranes installed within the building, if applicable.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this building record was first created in the system.',
    `current_book_value` DECIMAL(18,2) COMMENT 'Current net book value of the building asset after accumulated depreciation, used for financial reporting and asset valuation.',
    `depreciation_method` STRING COMMENT 'Accounting method used to calculate depreciation of the building asset over its useful life.',
    `electrical_capacity_kva` DECIMAL(18,2) COMMENT 'Total electrical power capacity available to the building measured in kilovolt-amperes (kVA), supporting operational equipment and systems.',
    `environmental_certification` STRING COMMENT 'Environmental or sustainability certification achieved by the building (e.g., LEED, BREEAM, Green Star), if applicable.',
    `fire_rating` STRING COMMENT 'Fire resistance classification of the building structure based on applicable fire safety standards and building codes.',
    `gross_floor_area_sqm` DECIMAL(18,2) COMMENT 'Total gross floor area of the building measured in square meters, including all floors and enclosed spaces. Critical for capacity planning and space utilization analysis.',
    `hvac_system_type` STRING COMMENT 'Type of heating, ventilation, and air conditioning system installed in the building (e.g., central, split system, natural ventilation, none).',
    `insurance_policy_number` STRING COMMENT 'Reference number of the insurance policy covering the building asset against damage, loss, or liability.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent formal structural or safety inspection conducted on the building.',
    `last_renovation_year` STRING COMMENT 'Year when the most recent major renovation, refurbishment, or structural upgrade was completed on the building.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the building location in decimal degrees, supporting GIS integration and spatial analysis.',
    `loading_dock_count` STRING COMMENT 'Number of loading docks or bays available at the building for cargo handling and material transfer operations.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the building location in decimal degrees, supporting GIS integration and spatial analysis.',
    `maintenance_schedule` STRING COMMENT 'Frequency or schedule type for planned preventive maintenance activities on the building and its systems.',
    `maximum_load_capacity_tonnes` DECIMAL(18,2) COMMENT 'Maximum structural load capacity of the building floor system measured in metric tonnes, critical for warehouse and storage facility operations.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this building record was last modified or updated in the system.',
    `next_inspection_due_date` DATE COMMENT 'Scheduled date for the next required formal inspection of the building structure and systems.',
    `number_of_floors` STRING COMMENT 'Total count of floors or levels in the building structure, including ground floor and any basement or mezzanine levels.',
    `occupancy_capacity` STRING COMMENT 'Maximum number of personnel that can safely occupy the building simultaneously based on building codes and safety regulations.',
    `operational_status` STRING COMMENT 'Current lifecycle status of the building indicating its availability and operational state within the port infrastructure.',
    `ownership_type` STRING COMMENT 'Legal ownership or tenure arrangement for the building (e.g., owned, leased, joint venture, concession, public-private partnership).',
    `parking_spaces` STRING COMMENT 'Number of vehicle parking spaces available at or adjacent to the building for staff and visitor use.',
    `postal_code` STRING COMMENT 'Postal or ZIP code for the building location.',
    `roof_type` STRING COMMENT 'Type of roof structure and design used in the building construction (e.g., flat, pitched, gable, shed, curved).',
    `security_level` STRING COMMENT 'Classification of physical security measures and access control requirements for the building based on operational sensitivity and cargo handling requirements.',
    `seismic_rating` STRING COMMENT 'Seismic design category or earthquake resistance rating of the building based on structural engineering assessments and local seismic codes.',
    `sprinkler_system_installed` BOOLEAN COMMENT 'Indicates whether an automatic fire sprinkler system is installed in the building for fire suppression.',
    `structural_material` STRING COMMENT 'Primary construction material used in the buildings structural framework (e.g., steel, concrete, reinforced concrete, masonry).',
    `usable_floor_area_sqm` DECIMAL(18,2) COMMENT 'Net usable floor area in square meters available for operational activities, excluding structural elements, mechanical rooms, and circulation spaces.',
    `useful_life_years` STRING COMMENT 'Expected useful economic life of the building in years for depreciation and asset management planning purposes.',
    CONSTRAINT pk_facility_building PRIMARY KEY(`facility_building_id`)
) COMMENT 'Master reference table for facility_building. Referenced by facility_building_id.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` (
    `port_id` BIGINT COMMENT 'Primary key for port',
    `parent_port_id` BIGINT COMMENT 'Self-referencing FK on port (parent_port_id)',
    `port_location_id` BIGINT COMMENT 'add column port_location_id (BIGINT) with FK to masterdata.port_location.port_location_id - a port entity must reference its geographic location in the master data location registry',
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
    `country_code` STRING COMMENT 'Three-letter ISO country code identifying the country where the port is located.',
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
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ADD CONSTRAINT `fk_infrastructure_quay_wall_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_infrastructure_terminal_id` FOREIGN KEY (`infrastructure_terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal`(`infrastructure_terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ADD CONSTRAINT `fk_infrastructure_navigational_aid_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ADD CONSTRAINT `fk_infrastructure_navigational_aid_replacement_aid_navigational_aid_id` FOREIGN KEY (`replacement_aid_navigational_aid_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid`(`navigational_aid_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ADD CONSTRAINT `fk_infrastructure_depth_survey_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ADD CONSTRAINT `fk_infrastructure_depth_survey_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ADD CONSTRAINT `fk_infrastructure_depth_survey_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ADD CONSTRAINT `fk_infrastructure_dredging_campaign_permit_id` FOREIGN KEY (`permit_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`permit`(`permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ADD CONSTRAINT `fk_infrastructure_dredging_campaign_depth_survey_id` FOREIGN KEY (`depth_survey_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey`(`depth_survey_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ADD CONSTRAINT `fk_infrastructure_dredging_campaign_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ADD CONSTRAINT `fk_infrastructure_dredging_campaign_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ADD CONSTRAINT `fk_infrastructure_dredging_campaign_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ADD CONSTRAINT `fk_infrastructure_structural_inspection_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ADD CONSTRAINT `fk_infrastructure_structural_inspection_navigational_aid_id` FOREIGN KEY (`navigational_aid_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid`(`navigational_aid_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ADD CONSTRAINT `fk_infrastructure_structural_inspection_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ADD CONSTRAINT `fk_infrastructure_structural_inspection_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ADD CONSTRAINT `fk_infrastructure_structural_inspection_utility_network_id` FOREIGN KEY (`utility_network_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`utility_network`(`utility_network_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ADD CONSTRAINT `fk_infrastructure_structural_inspection_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ADD CONSTRAINT `fk_infrastructure_utility_network_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_dredging_campaign_id` FOREIGN KEY (`dredging_campaign_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign`(`dredging_campaign_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_navigational_aid_id` FOREIGN KEY (`navigational_aid_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid`(`navigational_aid_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_utility_network_id` FOREIGN KEY (`utility_network_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`utility_network`(`utility_network_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ADD CONSTRAINT `fk_infrastructure_infrastructure_berth_reservation_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ADD CONSTRAINT `fk_infrastructure_infrastructure_anchorage_booking_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ADD CONSTRAINT `fk_infrastructure_infrastructure_berth_allocation_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ADD CONSTRAINT `fk_infrastructure_project_permit_permit_id` FOREIGN KEY (`permit_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`permit`(`permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ADD CONSTRAINT `fk_infrastructure_project_permit_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ADD CONSTRAINT `fk_infrastructure_project_service_cost_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ADD CONSTRAINT `fk_infrastructure_warehouse_commodity_approval_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ADD CONSTRAINT `fk_infrastructure_warehouse_imdg_approval_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ADD CONSTRAINT `fk_infrastructure_berth_service_contract_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ADD CONSTRAINT `fk_infrastructure_infrastructure_terminal_parent_terminal_id` FOREIGN KEY (`parent_terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal`(`infrastructure_terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ADD CONSTRAINT `fk_infrastructure_infrastructure_terminal_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ADD CONSTRAINT `fk_infrastructure_weighing_station_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ADD CONSTRAINT `fk_infrastructure_weighing_station_parent_weighing_station_id` FOREIGN KEY (`parent_weighing_station_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station`(`weighing_station_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ADD CONSTRAINT `fk_infrastructure_weighing_station_infrastructure_terminal_id` FOREIGN KEY (`infrastructure_terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal`(`infrastructure_terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ADD CONSTRAINT `fk_infrastructure_weighing_station_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ADD CONSTRAINT `fk_infrastructure_facility_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ADD CONSTRAINT `fk_infrastructure_facility_parent_facility_id` FOREIGN KEY (`parent_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility`(`facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ADD CONSTRAINT `fk_infrastructure_waste_reception_facility_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ADD CONSTRAINT `fk_infrastructure_waste_reception_facility_parent_waste_reception_facility_id` FOREIGN KEY (`parent_waste_reception_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility`(`waste_reception_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ADD CONSTRAINT `fk_infrastructure_waste_reception_facility_infrastructure_terminal_id` FOREIGN KEY (`infrastructure_terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal`(`infrastructure_terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ADD CONSTRAINT `fk_infrastructure_facility_building_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility`(`facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ADD CONSTRAINT `fk_infrastructure_facility_building_parent_facility_building_id` FOREIGN KEY (`parent_facility_building_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility_building`(`facility_building_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ADD CONSTRAINT `fk_infrastructure_port_parent_port_id` FOREIGN KEY (`parent_port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`infrastructure` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_shipping_ports_v1`.`infrastructure` SET TAGS ('dbx_domain' = 'infrastructure');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` SET TAGS ('dbx_subdomain' = 'berth_facilities');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `marpol_record_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Marpol Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Design Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Infrastructure Project Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `quay_wall_id` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Supervisor Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` SET TAGS ('dbx_subdomain' = 'berth_facilities');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `quay_wall_id` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Engineer Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `material_master_id` SET TAGS ('dbx_business_glossary_term' = 'Material Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Infrastructure Project Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` SET TAGS ('dbx_subdomain' = 'berth_facilities');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Operator Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `infrastructure_terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Zone Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
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
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` SET TAGS ('dbx_subdomain' = 'storage_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `cost_centre_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Centre Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Lessee Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `material_master_id` SET TAGS ('dbx_business_glossary_term' = 'Material Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Handling Equipment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` SET TAGS ('dbx_subdomain' = 'marine_waterways');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `navigational_aid_id` SET TAGS ('dbx_business_glossary_term' = 'Navigational Aid Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `compliance_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Audit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Technician Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `material_master_id` SET TAGS ('dbx_business_glossary_term' = 'Material Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `replacement_aid_navigational_aid_id` SET TAGS ('dbx_business_glossary_term' = 'Replacement Navigational Aid Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `aid_code` SET TAGS ('dbx_business_glossary_term' = 'Navigational Aid Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `aid_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `aid_name` SET TAGS ('dbx_business_glossary_term' = 'Navigational Aid Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `aid_type` SET TAGS ('dbx_business_glossary_term' = 'Navigational Aid Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `ais_aton_type` SET TAGS ('dbx_business_glossary_term' = 'Automatic Identification System (AIS) Aid to Navigation (AtoN) Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `ais_aton_type` SET TAGS ('dbx_value_regex' = 'real|synthetic|virtual');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `availability_target_percent` SET TAGS ('dbx_business_glossary_term' = 'Availability Target Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `body_color` SET TAGS ('dbx_business_glossary_term' = 'Body Color Pattern');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `chart_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Nautical Chart Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `criticality_level` SET TAGS ('dbx_business_glossary_term' = 'Criticality Level');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `criticality_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `decommission_date` SET TAGS ('dbx_business_glossary_term' = 'Decommission Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `focal_height_m` SET TAGS ('dbx_business_glossary_term' = 'Focal Height in Meters (m)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `iala_classification` SET TAGS ('dbx_business_glossary_term' = 'International Association of Lighthouse Authorities (IALA) Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `imo_number` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `imo_number` SET TAGS ('dbx_value_regex' = '^[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `inspection_frequency_days` SET TAGS ('dbx_business_glossary_term' = 'Inspection Frequency in Days');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `installation_date` SET TAGS ('dbx_business_glossary_term' = 'Installation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude Coordinate');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `light_character` SET TAGS ('dbx_business_glossary_term' = 'Light Character Pattern');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `light_color` SET TAGS ('dbx_business_glossary_term' = 'Light Color');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude Coordinate');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `manufacturer` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `mmsi_number` SET TAGS ('dbx_business_glossary_term' = 'Maritime Mobile Service Identity (MMSI) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `mmsi_number` SET TAGS ('dbx_value_regex' = '^[0-9]{9}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `model_number` SET TAGS ('dbx_business_glossary_term' = 'Model Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `mooring_type` SET TAGS ('dbx_business_glossary_term' = 'Mooring Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `mooring_type` SET TAGS ('dbx_value_regex' = 'sinker|chain|pile|fixed_structure|floating|none');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `nominal_range_nm` SET TAGS ('dbx_business_glossary_term' = 'Nominal Range in Nautical Miles (NM)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Operational Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'operational|non_operational|under_maintenance|decommissioned|temporary|planned');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `power_source_type` SET TAGS ('dbx_business_glossary_term' = 'Power Source Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `racon_code` SET TAGS ('dbx_business_glossary_term' = 'Radar Beacon (RACON) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `racon_code` SET TAGS ('dbx_value_regex' = '^[A-Z]$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `reflective_material` SET TAGS ('dbx_business_glossary_term' = 'Reflective Material Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `responsible_authority` SET TAGS ('dbx_business_glossary_term' = 'Responsible Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `sound_signal_character` SET TAGS ('dbx_business_glossary_term' = 'Sound Signal Character Pattern');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `sound_signal_type` SET TAGS ('dbx_business_glossary_term' = 'Sound Signal Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `sound_signal_type` SET TAGS ('dbx_value_regex' = 'horn|siren|bell|gong|whistle|none');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `structure_height_m` SET TAGS ('dbx_business_glossary_term' = 'Structure Height in Meters (m)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `topmark_shape` SET TAGS ('dbx_business_glossary_term' = 'Topmark Shape');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `topmark_shape` SET TAGS ('dbx_value_regex' = 'cone_up|cone_down|sphere|cylinder|x_shape|none');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `watch_circle_radius_m` SET TAGS ('dbx_business_glossary_term' = 'Watch Circle Radius in Meters (m)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ALTER COLUMN `water_depth_m` SET TAGS ('dbx_business_glossary_term' = 'Water Depth at Location in Meters (m)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` SET TAGS ('dbx_subdomain' = 'marine_waterways');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Master Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` SET TAGS ('dbx_subdomain' = 'marine_waterways');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `depth_survey_id` SET TAGS ('dbx_business_glossary_term' = 'Depth Survey ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Survey Coordinator Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Survey Equipment Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|approved|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `chart_datum_reference` SET TAGS ('dbx_business_glossary_term' = 'Chart Datum Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `data_source_system` SET TAGS ('dbx_business_glossary_term' = 'Data Source System');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `declared_depth_m` SET TAGS ('dbx_business_glossary_term' = 'Declared Depth (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `depth_variance_m` SET TAGS ('dbx_business_glossary_term' = 'Depth Variance (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `design_depth_m` SET TAGS ('dbx_business_glossary_term' = 'Design Depth (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `dredging_priority` SET TAGS ('dbx_business_glossary_term' = 'Dredging Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `dredging_priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|none');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `dredging_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Dredging Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `horizontal_positioning_system` SET TAGS ('dbx_business_glossary_term' = 'Horizontal Positioning System');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `maximum_depth_recorded_m` SET TAGS ('dbx_business_glossary_term' = 'Maximum Depth Recorded (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `mean_depth_m` SET TAGS ('dbx_business_glossary_term' = 'Mean Depth (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `minimum_depth_recorded_m` SET TAGS ('dbx_business_glossary_term' = 'Minimum Depth Recorded (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Survey Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `shoaling_area_description` SET TAGS ('dbx_business_glossary_term' = 'Shoaling Area Description');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `shoaling_detected_flag` SET TAGS ('dbx_business_glossary_term' = 'Shoaling Detected Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `shoaling_volume_cbm` SET TAGS ('dbx_business_glossary_term' = 'Shoaling Volume (Cubic Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_accuracy_order` SET TAGS ('dbx_business_glossary_term' = 'Survey Accuracy Order');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_accuracy_order` SET TAGS ('dbx_value_regex' = 'special|order_1a|order_1b|order_2');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_area_name` SET TAGS ('dbx_business_glossary_term' = 'Survey Area Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_area_type` SET TAGS ('dbx_business_glossary_term' = 'Survey Area Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_area_type` SET TAGS ('dbx_value_regex' = 'channel|berth_pocket|anchorage|turning_basin|approach|fairway');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_contractor_name` SET TAGS ('dbx_business_glossary_term' = 'Survey Contractor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_contractor_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Survey Cost Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_cost_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Survey Cost Currency');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_coverage_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Survey Coverage Area (Square Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_data_file_location` SET TAGS ('dbx_business_glossary_term' = 'Survey Data File Location');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_data_file_location` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_date` SET TAGS ('dbx_business_glossary_term' = 'Survey Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_end_time` SET TAGS ('dbx_business_glossary_term' = 'Survey End Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_method` SET TAGS ('dbx_business_glossary_term' = 'Survey Method');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_method` SET TAGS ('dbx_value_regex' = 'single_beam|multi_beam|lidar|side_scan_sonar|lead_line');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Survey Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_report_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Survey Report Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_start_time` SET TAGS ('dbx_business_glossary_term' = 'Survey Start Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `survey_vessel_name` SET TAGS ('dbx_business_glossary_term' = 'Survey Vessel Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `tide_gauge_reference` SET TAGS ('dbx_business_glossary_term' = 'Tide Gauge Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `vertical_positioning_system` SET TAGS ('dbx_business_glossary_term' = 'Vertical Positioning System');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ALTER COLUMN `weather_conditions` SET TAGS ('dbx_business_glossary_term' = 'Weather Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` SET TAGS ('dbx_subdomain' = 'marine_waterways');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `dredging_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Dredging Campaign ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Beneficiary Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `marpol_record_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Marpol Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Dredging Equipment Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `permit_id` SET TAGS ('dbx_business_glossary_term' = 'Environmental Permit ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Dredging Vessel Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `depth_survey_id` SET TAGS ('dbx_business_glossary_term' = 'Pre-Dredge Survey ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Project Engineer Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Target Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Target Berth ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Target Channel ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Contractor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `actual_volume_dredged_m3` SET TAGS ('dbx_business_glossary_term' = 'Actual Volume Dredged (Cubic Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `approved_disposal_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Approved Disposal Volume (Cubic Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `campaign_code` SET TAGS ('dbx_business_glossary_term' = 'Campaign Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `campaign_cost` SET TAGS ('dbx_business_glossary_term' = 'Campaign Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `campaign_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `campaign_name` SET TAGS ('dbx_business_glossary_term' = 'Campaign Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `campaign_notes` SET TAGS ('dbx_business_glossary_term' = 'Campaign Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `campaign_status` SET TAGS ('dbx_business_glossary_term' = 'Campaign Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `campaign_status` SET TAGS ('dbx_value_regex' = 'planned|mobilizing|active|suspended|completed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `completion_date` SET TAGS ('dbx_business_glossary_term' = 'Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `contracted_volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Contracted Volume (Cubic Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `contractor_name` SET TAGS ('dbx_business_glossary_term' = 'Contractor Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `contractor_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `contractor_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `cumulative_volume_disposed_m3` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Volume Disposed (Cubic Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `demobilization_date` SET TAGS ('dbx_business_glossary_term' = 'Demobilization Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `design_depth_target_m` SET TAGS ('dbx_business_glossary_term' = 'Design Depth Target (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `disposal_monitoring_requirements` SET TAGS ('dbx_business_glossary_term' = 'Disposal Monitoring Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `disposal_permit_reference` SET TAGS ('dbx_business_glossary_term' = 'Disposal Permit Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `disposal_type` SET TAGS ('dbx_business_glossary_term' = 'Disposal Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `disposal_type` SET TAGS ('dbx_value_regex' = 'open_water|confined|beneficial_reuse|land_reclamation');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `dredging_type` SET TAGS ('dbx_business_glossary_term' = 'Dredging Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `dredging_type` SET TAGS ('dbx_value_regex' = 'capital|maintenance|emergency');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `environmental_incident_count` SET TAGS ('dbx_business_glossary_term' = 'Environmental Incident Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `mobilization_date` SET TAGS ('dbx_business_glossary_term' = 'Mobilization Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `operational_downtime_days` SET TAGS ('dbx_business_glossary_term' = 'Operational Downtime Days');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `safety_incident_count` SET TAGS ('dbx_business_glossary_term' = 'Safety Incident Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `sediment_contamination_level` SET TAGS ('dbx_business_glossary_term' = 'Sediment Contamination Level');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `sediment_contamination_level` SET TAGS ('dbx_value_regex' = 'clean|low|moderate|high');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `spoil_disposal_site_latitude` SET TAGS ('dbx_business_glossary_term' = 'Spoil Disposal Site Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `spoil_disposal_site_latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `spoil_disposal_site_latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `spoil_disposal_site_longitude` SET TAGS ('dbx_business_glossary_term' = 'Spoil Disposal Site Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `spoil_disposal_site_longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `spoil_disposal_site_longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `spoil_disposal_site_name` SET TAGS ('dbx_business_glossary_term' = 'Spoil Disposal Site Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `water_quality_monitoring_results` SET TAGS ('dbx_business_glossary_term' = 'Water Quality Monitoring Results');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ALTER COLUMN `weather_downtime_days` SET TAGS ('dbx_business_glossary_term' = 'Weather Downtime Days');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` SET TAGS ('dbx_subdomain' = 'port_access');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Gate Supervisor Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `isps_facility_record_id` SET TAGS ('dbx_business_glossary_term' = 'Isps Facility Record Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Equipment Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Primary User Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` SET TAGS ('dbx_subdomain' = 'capital_development');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Infrastructure Project ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `facility_security_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Security Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Project Manager Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Contractor Vendor Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Sponsor Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `threat_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Threat Assessment Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `actual_expenditure_to_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Expenditure To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `actual_expenditure_to_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Project Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `approved_capex_budget` SET TAGS ('dbx_business_glossary_term' = 'Approved CAPEX (Capital Expenditure) Budget');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `approved_capex_budget` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `aveva_project_reference` SET TAGS ('dbx_business_glossary_term' = 'AVEVA (Advanced Visualization and Engineering Analysis) Project Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `berth_length_increase_m` SET TAGS ('dbx_business_glossary_term' = 'Berth Length Increase (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Budget Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `capacity_increase_teu` SET TAGS ('dbx_business_glossary_term' = 'Capacity Increase TEU (Twenty-foot Equivalent Unit)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `project_category` SET TAGS ('dbx_business_glossary_term' = 'Project Category');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `channel_depth_m` SET TAGS ('dbx_business_glossary_term' = 'Channel Depth (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `project_code` SET TAGS ('dbx_business_glossary_term' = 'Project Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `project_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}-[0-9]{4}-[A-Z]{2,4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `design_ground_level_m` SET TAGS ('dbx_business_glossary_term' = 'Design Ground Level (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `design_vessel_dwt` SET TAGS ('dbx_business_glossary_term' = 'Design Vessel DWT (Deadweight Tonnage)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `design_vessel_loa_m` SET TAGS ('dbx_business_glossary_term' = 'Design Vessel LOA (Length Overall) Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `environmental_impact_assessment_required` SET TAGS ('dbx_business_glossary_term' = 'Environmental Impact Assessment (EIA) Required');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `isps_security_assessment_required` SET TAGS ('dbx_business_glossary_term' = 'ISPS (International Ship and Port Facility Security) Security Assessment Required');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `project_name` SET TAGS ('dbx_business_glossary_term' = 'Project Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Project Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `phase` SET TAGS ('dbx_business_glossary_term' = 'Project Phase');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `phase` SET TAGS ('dbx_value_regex' = 'initiation|planning|execution|monitoring|closure');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `planned_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Project Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `project_status` SET TAGS ('dbx_business_glossary_term' = 'Project Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `project_type` SET TAGS ('dbx_business_glossary_term' = 'Project Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `project_type` SET TAGS ('dbx_value_regex' = 'new_construction|rehabilitation|expansion|upgrade|reclamation|dredging');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `reclamation_fill_method` SET TAGS ('dbx_business_glossary_term' = 'Reclamation Fill Method');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `reclamation_fill_method` SET TAGS ('dbx_value_regex' = 'hydraulic_fill|dry_fill|mixed_fill|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Risk Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `risk_rating` SET TAGS ('dbx_value_regex' = 'very_high|high|medium|low|very_low');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `scope_description` SET TAGS ('dbx_business_glossary_term' = 'Scope Description');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `settlement_monitoring_required` SET TAGS ('dbx_business_glossary_term' = 'Settlement Monitoring Required');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `sponsoring_business_unit` SET TAGS ('dbx_business_glossary_term' = 'Sponsoring Business Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `stakeholder_consultation_required` SET TAGS ('dbx_business_glossary_term' = 'Stakeholder Consultation Required');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` SET TAGS ('dbx_subdomain' = 'capital_development');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `structural_inspection_id` SET TAGS ('dbx_business_glossary_term' = 'Structural Inspection ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Inspector Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `navigational_aid_id` SET TAGS ('dbx_business_glossary_term' = 'Navigational Aid Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Port Asset ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Infrastructure Project Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `quay_wall_id` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `security_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Security Incident Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `utility_network_id` SET TAGS ('dbx_business_glossary_term' = 'Utility Network Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `approved_by` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `asset_reference` SET TAGS ('dbx_business_glossary_term' = 'Asset Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `asset_type` SET TAGS ('dbx_business_glossary_term' = 'Asset Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `critical_defects_count` SET TAGS ('dbx_business_glossary_term' = 'Critical Defects Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `defects_identified_count` SET TAGS ('dbx_business_glossary_term' = 'Defects Identified Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `estimated_repair_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Repair Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `estimated_repair_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `findings_summary` SET TAGS ('dbx_business_glossary_term' = 'Findings Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `inspection_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Inspection Duration Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `inspection_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Inspection Frequency Months');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `inspection_method` SET TAGS ('dbx_business_glossary_term' = 'Inspection Method');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `inspection_notes` SET TAGS ('dbx_business_glossary_term' = 'Inspection Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `inspection_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `inspection_reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{6,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `inspection_report_reference` SET TAGS ('dbx_business_glossary_term' = 'Inspection Report Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `inspection_status` SET TAGS ('dbx_business_glossary_term' = 'Inspection Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `inspection_status` SET TAGS ('dbx_value_regex' = 'scheduled|in-progress|completed|cancelled|report-pending|closed');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `inspection_type` SET TAGS ('dbx_business_glossary_term' = 'Inspection Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `inspection_type` SET TAGS ('dbx_value_regex' = 'routine|special|post-incident|regulatory|pre-commissioning|decommissioning');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `inspector_certification` SET TAGS ('dbx_business_glossary_term' = 'Inspector Certification');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `inspector_company` SET TAGS ('dbx_business_glossary_term' = 'Inspector Company');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `major_defects_count` SET TAGS ('dbx_business_glossary_term' = 'Major Defects Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `minor_defects_count` SET TAGS ('dbx_business_glossary_term' = 'Minor Defects Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `operational_impact` SET TAGS ('dbx_business_glossary_term' = 'Operational Impact');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `operational_impact` SET TAGS ('dbx_value_regex' = 'none|minor|moderate|major|asset_closure');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `overall_condition_rating` SET TAGS ('dbx_business_glossary_term' = 'Overall Condition Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `overall_condition_rating` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `photographic_evidence_reference` SET TAGS ('dbx_business_glossary_term' = 'Photographic Evidence Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `primary_defect_type` SET TAGS ('dbx_business_glossary_term' = 'Primary Defect Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `recommended_action` SET TAGS ('dbx_business_glossary_term' = 'Recommended Action');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `regulatory_authority` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `remediation_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Remediation Completion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `remediation_priority` SET TAGS ('dbx_business_glossary_term' = 'Remediation Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `remediation_priority` SET TAGS ('dbx_value_regex' = 'immediate|urgent|high|medium|low|monitor_only');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `remediation_status` SET TAGS ('dbx_business_glossary_term' = 'Remediation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `remediation_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|planned|in_progress|completed|deferred');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `safety_risk_level` SET TAGS ('dbx_business_glossary_term' = 'Safety Risk Level');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `safety_risk_level` SET TAGS ('dbx_value_regex' = 'none|low|medium|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `structural_integrity_assessment` SET TAGS ('dbx_business_glossary_term' = 'Structural Integrity Assessment');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `structural_integrity_assessment` SET TAGS ('dbx_value_regex' = 'intact|compromised|at_risk|failed');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `tide_level_m` SET TAGS ('dbx_business_glossary_term' = 'Tide Level Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ALTER COLUMN `weather_conditions` SET TAGS ('dbx_business_glossary_term' = 'Weather Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` SET TAGS ('dbx_subdomain' = 'port_access');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `utility_network_id` SET TAGS ('dbx_business_glossary_term' = 'Utility Network ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `compliance_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Audit Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `material_master_id` SET TAGS ('dbx_business_glossary_term' = 'Material Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Operations Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `port_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Asset Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Infrastructure Project Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `acquisition_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost Currency');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `acquisition_cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `annual_opex_budget` SET TAGS ('dbx_business_glossary_term' = 'Annual Operational Expenditure (OPEX) Budget');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `annual_opex_budget` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `asset_owner` SET TAGS ('dbx_business_glossary_term' = 'Asset Owner');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `capacity_unit` SET TAGS ('dbx_business_glossary_term' = 'Capacity Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `condition_rating` SET TAGS ('dbx_business_glossary_term' = 'Condition Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `condition_rating` SET TAGS ('dbx_value_regex' = 'excellent|good|fair|poor|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `connection_point_count` SET TAGS ('dbx_business_glossary_term' = 'Connection Point Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `criticality_rating` SET TAGS ('dbx_business_glossary_term' = 'Criticality Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `criticality_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `data_source_system` SET TAGS ('dbx_business_glossary_term' = 'Data Source System');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `design_capacity` SET TAGS ('dbx_business_glossary_term' = 'Design Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `environmental_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `geographic_coverage_area` SET TAGS ('dbx_business_glossary_term' = 'Geographic Coverage Area');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `ghg_emissions_reduction_tonnes_co2_annual` SET TAGS ('dbx_business_glossary_term' = 'Greenhouse Gas (GHG) Emissions Reduction (Tonnes CO2 Equivalent Annual)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `gis_network_layer_reference` SET TAGS ('dbx_business_glossary_term' = 'Geographic Information System (GIS) Network Layer Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `inspection_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Inspection Frequency (Months)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `installation_year` SET TAGS ('dbx_business_glossary_term' = 'Installation Year');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `last_upgrade_year` SET TAGS ('dbx_business_glossary_term' = 'Last Upgrade Year');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `maintenance_authority` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `network_code` SET TAGS ('dbx_business_glossary_term' = 'Utility Network Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `network_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}-[A-Z]{2,4}-[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `network_name` SET TAGS ('dbx_business_glossary_term' = 'Utility Network Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `network_status` SET TAGS ('dbx_business_glossary_term' = 'Utility Network Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `network_status` SET TAGS ('dbx_value_regex' = 'operational|under_maintenance|out_of_service|under_construction|decommissioned|planned');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `network_type` SET TAGS ('dbx_business_glossary_term' = 'Utility Network Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Utility Network Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `operating_frequency_hz` SET TAGS ('dbx_business_glossary_term' = 'Operating Frequency (Hertz)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `operating_pressure_bar` SET TAGS ('dbx_business_glossary_term' = 'Operating Pressure (Bar)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `operating_voltage_kv` SET TAGS ('dbx_business_glossary_term' = 'Operating Voltage (Kilovolts)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `record_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `redundancy_level` SET TAGS ('dbx_business_glossary_term' = 'Redundancy Level');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `redundancy_level` SET TAGS ('dbx_value_regex' = 'none|partial|full|n_plus_1|n_plus_2');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `replacement_value` SET TAGS ('dbx_business_glossary_term' = 'Replacement Value');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `replacement_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `safety_certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_business_glossary_term' = 'Safety Certification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `safety_certification_status` SET TAGS ('dbx_value_regex' = 'certified|expired|pending_renewal|not_required|non_compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `scada_integration_flag` SET TAGS ('dbx_business_glossary_term' = 'Supervisory Control and Data Acquisition (SCADA) Integration Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `shore_power_connector_standard` SET TAGS ('dbx_business_glossary_term' = 'Shore Power Connector Standard');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `shore_power_connector_standard` SET TAGS ('dbx_value_regex' = 'iec_80005_1|iec_80005_3|iec_60309|proprietary|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `shore_power_kva_capacity` SET TAGS ('dbx_business_glossary_term' = 'Shore Power Capacity (Kilovolt-Amperes)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `smart_metering_enabled` SET TAGS ('dbx_business_glossary_term' = 'Smart Metering Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ALTER COLUMN `total_network_length_m` SET TAGS ('dbx_business_glossary_term' = 'Total Network Length (Meters)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` SET TAGS ('dbx_subdomain' = 'marine_waterways');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Security Zone Id (Foreign Key)');
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
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` SET TAGS ('dbx_subdomain' = 'port_access');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `closure_id` SET TAGS ('dbx_business_glossary_term' = 'Infrastructure Closure Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Area Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Authorized By Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `dredging_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Dredging Project Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `emergency_response_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Emergency Response Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `exception_id` SET TAGS ('dbx_business_glossary_term' = 'Tariff Exception Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `navigational_aid_id` SET TAGS ('dbx_business_glossary_term' = 'Navigational Aid Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `port_gate_id` SET TAGS ('dbx_business_glossary_term' = 'Port Gate Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Infrastructure Project Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `quay_wall_id` SET TAGS ('dbx_business_glossary_term' = 'Quay Wall Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Requesting Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `terminal_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Zone Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `utility_network_id` SET TAGS ('dbx_business_glossary_term' = 'Utility Network Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Call Booking Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `actual_end_datetime` SET TAGS ('dbx_business_glossary_term' = 'Actual End Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `actual_start_datetime` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `affected_vessel_calls_count` SET TAGS ('dbx_business_glossary_term' = 'Affected Vessel Calls Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `alternative_infrastructure_reference` SET TAGS ('dbx_business_glossary_term' = 'Alternative Infrastructure Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `capacity_reduction_percentage` SET TAGS ('dbx_business_glossary_term' = 'Capacity Reduction Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `closure_status` SET TAGS ('dbx_business_glossary_term' = 'Closure Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `closure_status` SET TAGS ('dbx_value_regex' = 'planned|active|completed|cancelled|extended');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `created_datetime` SET TAGS ('dbx_business_glossary_term' = 'Created Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `environmental_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Impact Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `estimated_revenue_impact_usd` SET TAGS ('dbx_business_glossary_term' = 'Estimated Revenue Impact in United States Dollars (USD)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `estimated_revenue_impact_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `extension_count` SET TAGS ('dbx_business_glossary_term' = 'Closure Extension Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `infrastructure_type` SET TAGS ('dbx_business_glossary_term' = 'Infrastructure Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `infrastructure_type` SET TAGS ('dbx_value_regex' = 'berth|channel|gate|yard_zone|navigational_aid|warehouse');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `last_modified_datetime` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `notification_distribution_list` SET TAGS ('dbx_business_glossary_term' = 'Notification Distribution List');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `notification_sent_datetime` SET TAGS ('dbx_business_glossary_term' = 'Notification Sent Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `operational_impact_description` SET TAGS ('dbx_business_glossary_term' = 'Operational Impact Description');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `planned_end_datetime` SET TAGS ('dbx_business_glossary_term' = 'Planned End Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `planned_start_datetime` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Date and Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `reason` SET TAGS ('dbx_business_glossary_term' = 'Closure Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `reason` SET TAGS ('dbx_value_regex' = 'maintenance|inspection|incident|weather|dredging|structural_failure');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `reason_detail` SET TAGS ('dbx_business_glossary_term' = 'Closure Reason Detail');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `reference_number` SET TAGS ('dbx_business_glossary_term' = 'Closure Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `reference_number` SET TAGS ('dbx_value_regex' = '^CLS-[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `regulatory_authority_notified` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Authority Notified');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `safety_incident_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Incident Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `severity_level` SET TAGS ('dbx_business_glossary_term' = 'Severity Level');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ALTER COLUMN `severity_level` SET TAGS ('dbx_value_regex' = 'full_closure|partial_restriction|reduced_capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` SET TAGS ('dbx_subdomain' = 'capital_development');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `permit_id` SET TAGS ('dbx_business_glossary_term' = 'Infrastructure Permit Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Agreement Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `facility_security_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Security Plan Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Officer Employee Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `wbs_element_id` SET TAGS ('dbx_business_glossary_term' = 'Wbs Element Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `appeal_deadline_date` SET TAGS ('dbx_business_glossary_term' = 'Appeal Deadline Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `application_date` SET TAGS ('dbx_business_glossary_term' = 'Application Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `associated_infrastructure_type` SET TAGS ('dbx_business_glossary_term' = 'Associated Infrastructure Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `audit_inspection_schedule` SET TAGS ('dbx_business_glossary_term' = 'Audit and Inspection Schedule');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `compliance_monitoring_requirements` SET TAGS ('dbx_business_glossary_term' = 'Compliance Monitoring Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `conditions_summary` SET TAGS ('dbx_business_glossary_term' = 'Conditions Summary');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'Permit Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `environmental_sensitivity_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Sensitivity Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `financial_security_amount` SET TAGS ('dbx_business_glossary_term' = 'Financial Security Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `financial_security_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `financial_security_currency` SET TAGS ('dbx_business_glossary_term' = 'Financial Security Currency');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `financial_security_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `financial_security_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Financial Security Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_business_glossary_term' = 'Geographic Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `issuing_authority_code` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `key_conditions` SET TAGS ('dbx_business_glossary_term' = 'Key Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `last_inspection_outcome` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `last_inspection_outcome` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|conditional_compliance|not_inspected');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `next_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `non_compliance_count` SET TAGS ('dbx_business_glossary_term' = 'Non-Compliance Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `non_compliance_history` SET TAGS ('dbx_business_glossary_term' = 'Non-Compliance History');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `permit_number` SET TAGS ('dbx_business_glossary_term' = 'Permit Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `permit_status` SET TAGS ('dbx_business_glossary_term' = 'Permit Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `permit_type` SET TAGS ('dbx_business_glossary_term' = 'Permit Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `regulatory_framework` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Framework');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `renewal_date` SET TAGS ('dbx_business_glossary_term' = 'Renewal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `renewal_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Lead Time (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `responsible_department` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `revocation_date` SET TAGS ('dbx_business_glossary_term' = 'Revocation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `revocation_reason` SET TAGS ('dbx_business_glossary_term' = 'Revocation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `scope_description` SET TAGS ('dbx_business_glossary_term' = 'Scope Description');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `suspension_date` SET TAGS ('dbx_business_glossary_term' = 'Suspension Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `suspension_reason` SET TAGS ('dbx_business_glossary_term' = 'Suspension Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Permit Title');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ALTER COLUMN `validity_period_months` SET TAGS ('dbx_business_glossary_term' = 'Validity Period (Months)');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` SET TAGS ('dbx_subdomain' = 'berth_facilities');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` SET TAGS ('dbx_association_edges' = 'infrastructure.berth,booking.call_booking');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `infrastructure_berth_reservation_id` SET TAGS ('dbx_business_glossary_term' = 'infrastructure_berth_reservation Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Reservation - Berth Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `booking_berth_reservation_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Reservation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Reservation - Vessel Call Booking Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `actual_atb` SET TAGS ('dbx_business_glossary_term' = 'Actual Time of Berthing');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `actual_atd` SET TAGS ('dbx_business_glossary_term' = 'Actual Time of Departure');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `assigned_berth_code` SET TAGS ('dbx_business_glossary_term' = 'Assigned Berth Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `berth_side` SET TAGS ('dbx_business_glossary_term' = 'Berth Side');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `berth_utilization_hours` SET TAGS ('dbx_business_glossary_term' = 'Berth Utilization Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `planned_etb` SET TAGS ('dbx_business_glossary_term' = 'Planned Estimated Time of Berthing');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `planned_etd` SET TAGS ('dbx_business_glossary_term' = 'Planned Estimated Time of Departure');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `requested_berth_code` SET TAGS ('dbx_business_glossary_term' = 'Requested Berth Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `reservation_cancelled_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Reservation Cancelled Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `reservation_confirmed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Reservation Confirmed Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `reservation_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Reservation Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `reservation_status` SET TAGS ('dbx_business_glossary_term' = 'Reservation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ALTER COLUMN `tidal_window_required` SET TAGS ('dbx_business_glossary_term' = 'Tidal Window Required');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` SET TAGS ('dbx_subdomain' = 'marine_waterways');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` SET TAGS ('dbx_association_edges' = 'infrastructure.anchorage_area,booking.call_booking');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `infrastructure_anchorage_booking_id` SET TAGS ('dbx_business_glossary_term' = 'infrastructure_anchorage_booking Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `anchorage_area_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Booking - Anchorage Area Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `booking_anchorage_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Booking ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Allocated By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `call_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Booking - Vessel Call Booking Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `actual_anchor_drop_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Anchor Drop Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `actual_anchor_up_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Anchor Up Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `allocation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Allocation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `anchorage_booking_status` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Booking Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `anchorage_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Duration Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `anchorage_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Anchorage Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `requested_anchor_drop_time` SET TAGS ('dbx_business_glossary_term' = 'Requested Anchor Drop Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `requested_anchor_up_time` SET TAGS ('dbx_business_glossary_term' = 'Requested Anchor Up Time');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `special_requirements` SET TAGS ('dbx_business_glossary_term' = 'Special Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ALTER COLUMN `vts_coordination_reference` SET TAGS ('dbx_business_glossary_term' = 'VTS Coordination Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` SET TAGS ('dbx_subdomain' = 'berth_facilities');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` SET TAGS ('dbx_association_edges' = 'infrastructure.berth,contract.agreement');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `infrastructure_berth_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'infrastructure_berth_allocation Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Allocation - Agreement Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Allocation - Berth Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `terminal_berth_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Allocation Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `allocation_end_date` SET TAGS ('dbx_business_glossary_term' = 'Allocation End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `allocation_start_date` SET TAGS ('dbx_business_glossary_term' = 'Allocation Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_business_glossary_term' = 'Allocation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `allocation_type` SET TAGS ('dbx_business_glossary_term' = 'Allocation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `exclusive_use_flag` SET TAGS ('dbx_business_glossary_term' = 'Exclusive Use Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `licensed_berths` SET TAGS ('dbx_business_glossary_term' = 'Licensed Berths');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `revenue_share_percentage` SET TAGS ('dbx_business_glossary_term' = 'Revenue Share Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `throughput_commitment_teu` SET TAGS ('dbx_business_glossary_term' = 'Throughput Commitment TEU');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ALTER COLUMN `time_window_specification` SET TAGS ('dbx_business_glossary_term' = 'Time Window Specification');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` SET TAGS ('dbx_subdomain' = 'capital_development');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` SET TAGS ('dbx_association_edges' = 'infrastructure.infrastructure_project,infrastructure.infrastructure_permit');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `project_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Project Permit Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `permit_id` SET TAGS ('dbx_business_glossary_term' = 'Project Permit - Infrastructure Permit Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Project Permit - Infrastructure Project Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `application_date` SET TAGS ('dbx_business_glossary_term' = 'Permit Application Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Permit Approval Date for Project');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `compliance_tracking_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Tracking Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `environmental_permit_reference` SET TAGS ('dbx_business_glossary_term' = 'Environmental Permit Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `last_compliance_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Compliance Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `last_updated_date` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `next_compliance_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Compliance Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `permit_cost_allocation` SET TAGS ('dbx_business_glossary_term' = 'Permit Cost Allocation');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `permit_criticality_to_project` SET TAGS ('dbx_business_glossary_term' = 'Permit Criticality to Project');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `project_permit_status` SET TAGS ('dbx_business_glossary_term' = 'Project Permit Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `project_specific_conditions` SET TAGS ('dbx_business_glossary_term' = 'Project-Specific Permit Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `regulatory_approval_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `responsible_project_officer` SET TAGS ('dbx_business_glossary_term' = 'Responsible Project Officer');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_permit` ALTER COLUMN `responsible_project_officer` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` SET TAGS ('dbx_subdomain' = 'capital_development');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` SET TAGS ('dbx_association_edges' = 'infrastructure.infrastructure_project,masterdata.service_code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `project_service_cost_id` SET TAGS ('dbx_business_glossary_term' = 'Project Service Cost Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Project Service Cost - Infrastructure Project Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `service_code_id` SET TAGS ('dbx_business_glossary_term' = 'Project Service Cost - Service Code Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `actual_cost` SET TAGS ('dbx_business_glossary_term' = 'Actual Service Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `budgeted_amount` SET TAGS ('dbx_business_glossary_term' = 'Budgeted Service Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `contractor_reference` SET TAGS ('dbx_business_glossary_term' = 'Contractor Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `cost_status` SET TAGS ('dbx_business_glossary_term' = 'Cost Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `gl_posting_date` SET TAGS ('dbx_business_glossary_term' = 'GL Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `invoice_reference` SET TAGS ('dbx_business_glossary_term' = 'Invoice Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Cost Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Service Quantity Consumed');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `service_end_date` SET TAGS ('dbx_business_glossary_term' = 'Service End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `service_start_date` SET TAGS ('dbx_business_glossary_term' = 'Service Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `variance_amount` SET TAGS ('dbx_business_glossary_term' = 'Budget Variance Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Creator');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` SET TAGS ('dbx_subdomain' = 'storage_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` SET TAGS ('dbx_association_edges' = 'infrastructure.warehouse,masterdata.commodity_code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `warehouse_commodity_approval_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Commodity Approval ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Commodity Approval - Commodity Code Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Commodity Approval - Warehouse Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `approval_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Approval Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `approval_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Created Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `designated_storage_zone` SET TAGS ('dbx_business_glossary_term' = 'Designated Storage Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `inspection_frequency_days` SET TAGS ('dbx_business_glossary_term' = 'Inspection Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `last_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Last Updated By');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `last_updated_date` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `maximum_quantity_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Maximum Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `segregation_requirements` SET TAGS ('dbx_business_glossary_term' = 'Segregation Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `special_handling_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `storage_conditions` SET TAGS ('dbx_business_glossary_term' = 'Storage Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `suspension_reason` SET TAGS ('dbx_business_glossary_term' = 'Suspension Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` SET TAGS ('dbx_subdomain' = 'storage_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` SET TAGS ('dbx_association_edges' = 'infrastructure.warehouse,masterdata.imdg_class');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `warehouse_imdg_approval_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse IMDG Approval ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Imdg Approval - Imdg Class Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Imdg Approval - Warehouse Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `approval_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `certification_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Certification Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `emergency_contact` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `fire_suppression_requirements` SET TAGS ('dbx_business_glossary_term' = 'Fire Suppression Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `imdg_class_approvals` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class Approvals');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `inspection_frequency_days` SET TAGS ('dbx_business_glossary_term' = 'Inspection Frequency');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `maximum_net_explosive_mass` SET TAGS ('dbx_business_glossary_term' = 'Maximum Net Explosive Mass');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `maximum_storage_quantity_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Maximum Storage Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `segregation_distance_meters` SET TAGS ('dbx_business_glossary_term' = 'Segregation Distance');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `special_handling_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `ventilation_requirements` SET TAGS ('dbx_business_glossary_term' = 'Ventilation Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` SET TAGS ('dbx_subdomain' = 'berth_facilities');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` SET TAGS ('dbx_association_edges' = 'infrastructure.berth,procurement.vendor');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `berth_service_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Service Contract ID');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Service Contract - Berth Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Service Contract - Vendor Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `contract_status` SET TAGS ('dbx_business_glossary_term' = 'Contract Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `contract_value` SET TAGS ('dbx_business_glossary_term' = 'Contract Value');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Phone');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `response_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Response Time Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `service_level_agreement` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` SET TAGS ('dbx_subdomain' = 'berth_facilities');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `infrastructure_terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `parent_terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Terminal Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `parent_terminal_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line1');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line2');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `annual_throughput_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Annual Throughput Capacity Teu');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `crane_types` SET TAGS ('dbx_business_glossary_term' = 'Crane Types');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `customs_facility_available` SET TAGS ('dbx_business_glossary_term' = 'Customs Facility Available');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `email_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `environmental_certification` SET TAGS ('dbx_business_glossary_term' = 'Environmental Certification');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `free_trade_zone` SET TAGS ('dbx_business_glossary_term' = 'Free Trade Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `last_expansion_date` SET TAGS ('dbx_business_glossary_term' = 'Last Expansion Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `max_draft_m` SET TAGS ('dbx_business_glossary_term' = 'Max Draft M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `max_vessel_beam_m` SET TAGS ('dbx_business_glossary_term' = 'Max Vessel Beam M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `max_vessel_length_m` SET TAGS ('dbx_business_glossary_term' = 'Max Vessel Length M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `next_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `number_of_berths` SET TAGS ('dbx_business_glossary_term' = 'Number Of Berths');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `number_of_cranes` SET TAGS ('dbx_business_glossary_term' = 'Number Of Cranes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `open_storage_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Open Storage Area Sqm');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `operator_name` SET TAGS ('dbx_business_glossary_term' = 'Operator Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `operator_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `operator_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `operator_type` SET TAGS ('dbx_business_glossary_term' = 'Operator Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `phone_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `rail_connection_available` SET TAGS ('dbx_business_glossary_term' = 'Rail Connection Available');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `rail_track_length_m` SET TAGS ('dbx_business_glossary_term' = 'Rail Track Length M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `reefer_plug_capacity` SET TAGS ('dbx_business_glossary_term' = 'Reefer Plug Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `security_certification` SET TAGS ('dbx_business_glossary_term' = 'Security Certification');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `shore_power_available` SET TAGS ('dbx_business_glossary_term' = 'Shore Power Available');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State Province');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `storage_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Storage Capacity Teu');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `terminal_code` SET TAGS ('dbx_business_glossary_term' = 'Terminal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `terminal_name` SET TAGS ('dbx_business_glossary_term' = 'Terminal Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `terminal_type` SET TAGS ('dbx_business_glossary_term' = 'Terminal Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `total_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Total Area Sqm');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `total_quay_length_m` SET TAGS ('dbx_business_glossary_term' = 'Total Quay Length M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `truck_gate_lanes` SET TAGS ('dbx_business_glossary_term' = 'Truck Gate Lanes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `warehouse_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Area Sqm');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'Website Url');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` SET TAGS ('dbx_subdomain' = 'storage_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `weighing_station_id` SET TAGS ('dbx_business_glossary_term' = 'Weighing Station Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `parent_weighing_station_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Weighing Station Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `parent_weighing_station_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `infrastructure_terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `accuracy_class` SET TAGS ('dbx_business_glossary_term' = 'Accuracy Class');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `asset_acquisition_cost` SET TAGS ('dbx_business_glossary_term' = 'Asset Acquisition Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `asset_acquisition_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `asset_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Asset Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `automated_data_capture_enabled` SET TAGS ('dbx_business_glossary_term' = 'Automated Data Capture Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `calibration_frequency_days` SET TAGS ('dbx_business_glossary_term' = 'Calibration Frequency Days');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `certification_number` SET TAGS ('dbx_business_glossary_term' = 'Certification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `environmental_protection_rating` SET TAGS ('dbx_business_glossary_term' = 'Environmental Protection Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `installation_date` SET TAGS ('dbx_business_glossary_term' = 'Installation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `integration_system_code` SET TAGS ('dbx_business_glossary_term' = 'Integration System Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `last_calibration_date` SET TAGS ('dbx_business_glossary_term' = 'Last Calibration Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `load_cell_count` SET TAGS ('dbx_business_glossary_term' = 'Load Cell Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `location_zone` SET TAGS ('dbx_business_glossary_term' = 'Location Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `maintenance_contract_number` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Contract Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `maintenance_provider_name` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Provider Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `manufacturer_name` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `maximum_capacity_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Capacity Kg');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `measurement_precision_kg` SET TAGS ('dbx_business_glossary_term' = 'Measurement Precision Kg');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `minimum_capacity_kg` SET TAGS ('dbx_business_glossary_term' = 'Minimum Capacity Kg');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `model_number` SET TAGS ('dbx_business_glossary_term' = 'Model Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `next_calibration_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Calibration Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `next_maintenance_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Maintenance Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `operating_temperature_max_c` SET TAGS ('dbx_business_glossary_term' = 'Operating Temperature Max C');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `operating_temperature_min_c` SET TAGS ('dbx_business_glossary_term' = 'Operating Temperature Min C');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `platform_length_m` SET TAGS ('dbx_business_glossary_term' = 'Platform Length M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `platform_width_m` SET TAGS ('dbx_business_glossary_term' = 'Platform Width M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `power_supply_type` SET TAGS ('dbx_business_glossary_term' = 'Power Supply Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `remote_monitoring_enabled` SET TAGS ('dbx_business_glossary_term' = 'Remote Monitoring Enabled');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `solas_vgm_compliant` SET TAGS ('dbx_business_glossary_term' = 'Solas Vgm Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `station_code` SET TAGS ('dbx_business_glossary_term' = 'Station Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `station_name` SET TAGS ('dbx_business_glossary_term' = 'Station Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `station_type` SET TAGS ('dbx_business_glossary_term' = 'Station Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life Years');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station` ALTER COLUMN `weighbridge_type` SET TAGS ('dbx_business_glossary_term' = 'Weighbridge Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` SET TAGS ('dbx_subdomain' = 'storage_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `facility_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Capex Project Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `facility_terminal_operator_port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Operator Port Community Participant Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `parent_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Facility Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ALTER COLUMN `parent_facility_id` SET TAGS ('dbx_self_ref_fk' = 'true');
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
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` SET TAGS ('dbx_subdomain' = 'storage_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `waste_reception_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Waste Reception Facility Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `berth_id` SET TAGS ('dbx_business_glossary_term' = 'Berth Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `parent_waste_reception_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Waste Reception Facility Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `parent_waste_reception_facility_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `infrastructure_terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Terminal Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `accepts_garbage` SET TAGS ('dbx_business_glossary_term' = 'Accepts Garbage');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `accepts_hazardous_waste` SET TAGS ('dbx_business_glossary_term' = 'Accepts Hazardous Waste');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `accepts_oily_waste` SET TAGS ('dbx_business_glossary_term' = 'Accepts Oily Waste');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `accepts_sewage` SET TAGS ('dbx_business_glossary_term' = 'Accepts Sewage');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `address_line_1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `address_line_1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `address_line_1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `address_line_2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `address_line_2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `address_line_2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `advance_notice_required_hours` SET TAGS ('dbx_business_glossary_term' = 'Advance Notice Required Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `capacity_cubic_meters` SET TAGS ('dbx_business_glossary_term' = 'Capacity Cubic Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `certification_standard` SET TAGS ('dbx_business_glossary_term' = 'Certification Standard');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `contact_email` SET TAGS ('dbx_business_glossary_term' = 'Contact Email');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Contact Phone');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `decommissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Decommissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `disposal_method` SET TAGS ('dbx_business_glossary_term' = 'Disposal Method');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Phone');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `emergency_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `environmental_compliance_notes` SET TAGS ('dbx_business_glossary_term' = 'Environmental Compliance Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `facility_code` SET TAGS ('dbx_business_glossary_term' = 'Facility Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `facility_name` SET TAGS ('dbx_business_glossary_term' = 'Facility Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `facility_type` SET TAGS ('dbx_business_glossary_term' = 'Facility Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `inspection_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Inspection Compliance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `license_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'License Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `license_issue_date` SET TAGS ('dbx_business_glossary_term' = 'License Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `license_number` SET TAGS ('dbx_business_glossary_term' = 'License Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `location_latitude` SET TAGS ('dbx_business_glossary_term' = 'Location Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `location_latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `location_latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `location_longitude` SET TAGS ('dbx_business_glossary_term' = 'Location Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `location_longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `location_longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `operating_hours` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `service_fee_structure` SET TAGS ('dbx_business_glossary_term' = 'Service Fee Structure');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `throughput_capacity_tons_per_day` SET TAGS ('dbx_business_glossary_term' = 'Throughput Capacity Tons Per Day');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ALTER COLUMN `waste_category` SET TAGS ('dbx_business_glossary_term' = 'Waste Category');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` SET TAGS ('dbx_subdomain' = 'storage_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `facility_building_id` SET TAGS ('dbx_business_glossary_term' = 'Facility Building Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `parent_facility_building_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Facility Building Id');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `parent_facility_building_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `access_control_system` SET TAGS ('dbx_business_glossary_term' = 'Access Control System');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `acquisition_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `acquisition_date` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line1');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line2');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `backup_power_available` SET TAGS ('dbx_business_glossary_term' = 'Backup Power Available');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `building_code` SET TAGS ('dbx_business_glossary_term' = 'Building Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `building_name` SET TAGS ('dbx_business_glossary_term' = 'Building Name');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `building_type` SET TAGS ('dbx_business_glossary_term' = 'Building Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `cctv_coverage` SET TAGS ('dbx_business_glossary_term' = 'Cctv Coverage');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `ceiling_height_m` SET TAGS ('dbx_business_glossary_term' = 'Ceiling Height M');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `construction_year` SET TAGS ('dbx_business_glossary_term' = 'Construction Year');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `crane_capacity_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Crane Capacity Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `current_book_value` SET TAGS ('dbx_business_glossary_term' = 'Current Book Value');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `current_book_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `depreciation_method` SET TAGS ('dbx_business_glossary_term' = 'Depreciation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `electrical_capacity_kva` SET TAGS ('dbx_business_glossary_term' = 'Electrical Capacity Kva');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `environmental_certification` SET TAGS ('dbx_business_glossary_term' = 'Environmental Certification');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `fire_rating` SET TAGS ('dbx_business_glossary_term' = 'Fire Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `gross_floor_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Gross Floor Area Sqm');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `hvac_system_type` SET TAGS ('dbx_business_glossary_term' = 'Hvac System Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_business_glossary_term' = 'Insurance Policy Number');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `last_renovation_year` SET TAGS ('dbx_business_glossary_term' = 'Last Renovation Year');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `loading_dock_count` SET TAGS ('dbx_business_glossary_term' = 'Loading Dock Count');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `maintenance_schedule` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Schedule');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `maximum_load_capacity_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Maximum Load Capacity Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `next_inspection_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Inspection Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `number_of_floors` SET TAGS ('dbx_business_glossary_term' = 'Number Of Floors');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `occupancy_capacity` SET TAGS ('dbx_business_glossary_term' = 'Occupancy Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `ownership_type` SET TAGS ('dbx_business_glossary_term' = 'Ownership Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `parking_spaces` SET TAGS ('dbx_business_glossary_term' = 'Parking Spaces');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `roof_type` SET TAGS ('dbx_business_glossary_term' = 'Roof Type');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `security_level` SET TAGS ('dbx_business_glossary_term' = 'Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `seismic_rating` SET TAGS ('dbx_business_glossary_term' = 'Seismic Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `sprinkler_system_installed` SET TAGS ('dbx_business_glossary_term' = 'Sprinkler System Installed');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `structural_material` SET TAGS ('dbx_business_glossary_term' = 'Structural Material');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `usable_floor_area_sqm` SET TAGS ('dbx_business_glossary_term' = 'Usable Floor Area Sqm');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility_building` ALTER COLUMN `useful_life_years` SET TAGS ('dbx_business_glossary_term' = 'Useful Life Years');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` SET TAGS ('dbx_subdomain' = 'port_access');
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `port_id` SET TAGS ('dbx_business_glossary_term' = 'Port Identifier');
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
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
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
