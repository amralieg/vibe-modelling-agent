-- Schema for Domain: masterdata | Business: Shipping_Ports | Version: v2_mvm
-- Generated on: 2026-07-13 10:24:18

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`masterdata` COMMENT 'Governs enterprise-wide reference and master data including vessel types, container types, cargo classifications, equipment codes, port codes, UN/LOCODE location references, commodity codes, currency tables, unit-of-measure standards (TEU, FEU, CBM, DWT), calendar data, RFID/EDI partner identifiers, and standardized code lists. SSOT for all shared reference data used across operational and business domains.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` (
    `vessel_master_id` BIGINT COMMENT 'Unique system identifier for the vessel master record. Primary key for the vessel master entity.',
    `flag_state_id` BIGINT COMMENT 'Foreign key linking to masterdata.flag_state. Business justification: Vessel master records reference flag state (country of vessel registration). Currently stores flag_state_code as STRING; normalizing to FK allows joining to flag_state for full regulatory compliance d',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Vessel master records reference the port of registry (home port) as a location. Currently stores port_of_registry as STRING; normalizing to FK allows joining to port_location for full location data (U',
    `shipping_line_id` BIGINT COMMENT 'Foreign key linking to masterdata.shipping_line. Business justification: Vessel master records reference the shipping line (ocean carrier) that commercially operates the vessel. Currently stores commercial_operator_code as STRING; normalizing to FK allows joining to shippi',
    `vessel_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_type. Business justification: Vessel master records reference vessel type classification (container ship, bulk carrier, etc.). Currently stores vessel_type_code as STRING; normalizing to FK allows joining to vessel_type for full t',
    `beam_meters` DECIMAL(18,2) COMMENT 'Maximum width of the vessel at its widest point. Used for berth compatibility assessment and safe navigation channel clearance calculations.',
    `builder_name` STRING COMMENT 'Name of the shipyard or shipbuilding company that constructed the vessel. Relevant for technical specifications and spare parts sourcing.',
    `call_sign` STRING COMMENT 'International radio call sign assigned to the vessel for maritime communication and identification in Vessel Traffic Service (VTS) operations.',
    `classification_society_code` STRING COMMENT 'Code identifying the classification society that certifies the vessel meets structural and mechanical standards (e.g., Lloyds Register, DNV, ABS). Impacts insurance and port acceptance.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this vessel master record was first created in the system. Supports audit trail and data lineage tracking.',
    `data_steward` STRING COMMENT 'Business unit or role responsible for maintaining the accuracy and completeness of this vessel master record. Typically Marine Operations department.',
    `engine_type` STRING COMMENT 'Type and model of the vessels main propulsion engine. Used for emissions tracking, fuel consumption estimation, and environmental compliance under MARPOL.',
    `feu_capacity` STRING COMMENT 'Maximum number of forty-foot equivalent containers the vessel can carry. Supplementary capacity metric for container vessel planning.',
    `grt` DECIMAL(18,2) COMMENT 'Total internal volume of the vessel measured in register tons (100 cubic feet). Used for regulatory compliance, port dues calculation, and statistical reporting.',
    `hull_number` STRING COMMENT 'Shipyard construction number assigned during vessel building. Used for tracking vessel lineage and construction specifications.',
    `ice_class` STRING COMMENT 'Classification indicating the vessels capability to operate in ice-covered waters. Relevant for seasonal port access and route planning in northern latitudes.',
    `imo_number` STRING COMMENT 'Unique seven-digit ship identification number assigned by the International Maritime Organization. Permanent identifier that remains unchanged through changes of name, ownership, or flag. SSOT for global vessel identity.. Valid values are `^[0-9]{7}$`',
    `is_current_record` BOOLEAN COMMENT 'Boolean flag indicating whether this is the current active version of the vessel master record. True for the latest version, False for historical versions.',
    `isps_compliant` BOOLEAN COMMENT 'Boolean flag indicating whether the vessel holds a valid International Ship Security Certificate (ISSC) and complies with ISPS Code requirements. Mandatory for port entry.',
    `issc_expiry_date` DATE COMMENT 'Expiration date of the vessels International Ship Security Certificate. Vessels with expired certificates may be denied port entry or subjected to enhanced Port State Control inspection.',
    `last_psc_inspection_date` DATE COMMENT 'Date of the most recent Port State Control inspection. Used for risk assessment and targeting of vessels for inspection under regional PSC memoranda of understanding.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this vessel master record. Used for data freshness monitoring and change data capture processing.',
    `lloyds_list_intelligence_reference` STRING COMMENT 'Unique identifier assigned by Lloyds List Intelligence maritime data service. Used for cross-referencing vessel data with external maritime intelligence feeds.',
    `loa_meters` DECIMAL(18,2) COMMENT 'Maximum length of the vessel measured from the foremost point of the bow to the aftermost point of the stern. Critical dimension for berth allocation and port infrastructure planning.',
    `marpol_compliant` BOOLEAN COMMENT 'Boolean flag indicating whether the vessel complies with MARPOL convention requirements for prevention of pollution from ships (oil, chemicals, sewage, garbage, air emissions).',
    `maximum_draft_meters` DECIMAL(18,2) COMMENT 'Maximum vertical distance between the waterline and the bottom of the hull (keel). Determines minimum water depth requirements for safe berthing and navigation.',
    `mmsi` STRING COMMENT 'Nine-digit unique identifier used in the Automatic Identification System (AIS) and Digital Selective Calling (DSC) for vessel tracking and communication.. Valid values are `^[0-9]{9}$`',
    `nrt` DECIMAL(18,2) COMMENT 'Volume of cargo-carrying spaces measured in register tons. Represents earning capacity and is used for port tariff and canal dues calculation.',
    `operational_status` STRING COMMENT 'Current operational state of the vessel. Active vessels are in service; laid-up vessels are temporarily out of service; scrapped vessels are decommissioned; under construction vessels are not yet delivered; detained vessels are held by authorities.. Valid values are `active|laid_up|scrapped|under_construction|detained`',
    `pi_club_code` STRING COMMENT 'Code identifying the Protection and Indemnity insurance club providing third-party liability coverage for the vessel. Required for port entry and cargo operations.',
    `propulsion_power_kw` DECIMAL(18,2) COMMENT 'Maximum continuous rated power output of the main propulsion engine in kilowatts. Used for environmental reporting and vessel performance assessment.',
    `psc_deficiency_count` STRING COMMENT 'Total number of deficiencies identified during the last PSC inspection. High deficiency counts indicate elevated risk and may trigger enhanced inspection or detention.',
    `registered_owner` STRING COMMENT 'Legal entity name of the registered owner as recorded in the ship registry. May differ from commercial operator. Subject to change through ownership transfers tracked via effectivity dating.',
    `solas_compliant` BOOLEAN COMMENT 'Boolean flag indicating whether the vessel meets SOLAS convention requirements for construction, equipment, and operation. Fundamental requirement for international maritime operations.',
    `summer_dwt` DECIMAL(18,2) COMMENT 'Maximum weight in metric tons that the vessel can safely carry (cargo, fuel, water, stores, crew) when loaded to the summer load line. Key metric for cargo capacity and port tariff calculation.',
    `teu_capacity` STRING COMMENT 'Maximum number of twenty-foot equivalent containers the vessel can carry. Primary capacity metric for container vessels used in terminal planning and vessel scheduling.',
    `valid_from_date` DATE COMMENT 'Effective start date for this version of the vessel master record. Supports Type 2 slowly changing dimension tracking for vessel name changes, ownership transfers, and flag changes.',
    `valid_to_date` DATE COMMENT 'Effective end date for this version of the vessel master record. Null indicates the current active record. Supports historical analysis and audit trail for vessel attribute changes.',
    `vessel_name` STRING COMMENT 'Current registered name of the vessel as recorded in the ship registry. Subject to change through vessel name amendments tracked via effectivity dating.',
    `year_built` STRING COMMENT 'Calendar year in which the vessel was constructed and delivered. Used for age-based risk assessment, insurance classification, and Port State Control (PSC) targeting.',
    CONSTRAINT pk_vessel_master PRIMARY KEY(`vessel_master_id`)
) COMMENT 'Enterprise master record for every vessel recognised by the port, capturing IMO number (unique 7-digit identifier), vessel name, call sign, MMSI, flag state (FK to country), vessel type (FK to vessel_type), LOA, beam, maximum draft, summer DWT, GRT, NRT, TEU capacity, FEU capacity, year built, classification society code, P&I club, registered owner, commercial operator (FK to shipping_line), and operational status (active, laid-up, scrapped). Includes effectivity dating (valid_from/valid_to) for vessel name changes and ownership transfers. SSOT for vessel identity referenced across vessel operations, marine services, cargo, billing, and compliance domains. Data steward: Marine Operations; updated via Lloyds List Intelligence feed and vessel pre-arrival notifications.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` (
    `vessel_type_id` BIGINT COMMENT 'Primary key for vessel_type',
    `parent_vessel_type_id` BIGINT COMMENT 'add column parent_vessel_type_id (BIGINT) with FK to masterdata.vessel_type.vessel_type_id - vessel types form a hierarchy (e.g., container vessel > feeder, mother vessel) requiring self-reference',
    `berth_compatibility_flag` BOOLEAN COMMENT 'Indicates whether this vessel type has specific berth compatibility requirements that must be validated during berth allocation.',
    `cargo_handling_method` STRING COMMENT 'Primary cargo handling method associated with this vessel type: Lift-on Lift-off (LoLo), Roll-on Roll-off (RoRo), bulk discharge, liquid pumping, or mixed methods.. Valid values are `lolo|roro|bulk|liquid|mixed|none`',
    `vessel_type_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the vessel type classification. Used as business key across operational systems.. Valid values are `^[A-Z0-9]{2,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this vessel type classification record was first created in the system.',
    `dangerous_goods_capable` BOOLEAN COMMENT 'Indicates whether vessels of this type are certified and equipped to carry dangerous goods as defined by IMDG Code.',
    `data_steward` STRING COMMENT 'Name or identifier of the business unit or individual responsible for maintaining the accuracy and currency of this vessel type classification record. Typically Marine Operations.',
    `vessel_type_description` STRING COMMENT 'Detailed textual description of the vessel type classification, including operational characteristics, typical cargo types, and special handling requirements.',
    `environmental_category` STRING COMMENT 'Environmental classification of vessel type based on typical emissions profile and environmental impact. Used for GHG reporting and environmental compliance.. Valid values are `green|standard|high_emission|specialized`',
    `imo_vessel_type_code` STRING COMMENT 'Two-digit IMO standard vessel type code as defined by the International Maritime Organization for global vessel classification.. Valid values are `^[0-9]{2}$`',
    `isps_security_level` STRING COMMENT 'Default ISPS security level applicable to vessels of this type: Level 1 (normal), Level 2 (heightened), Level 3 (exceptional), or not applicable.. Valid values are `level_1|level_2|level_3|not_applicable`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this vessel type classification record was last modified or updated.',
    `marpol_annex_reference` STRING COMMENT 'Comma-separated list of applicable MARPOL annex references for this vessel type (e.g., Annex I - Oil, Annex II - Noxious Liquid Substances).',
    `mobile_crane_compatible` BOOLEAN COMMENT 'Indicates whether vessels of this type are compatible with mobile harbour cranes (MHC) for cargo handling operations.',
    `vessel_type_name` STRING COMMENT 'Full descriptive name of the vessel type classification (e.g., Container Ship, Bulk Carrier, Tanker, RoRo, LoLo, General Cargo, Passenger/Cruise, Tug, Barge).',
    `navis_vessel_category_code` STRING COMMENT 'NAVIS N4 Terminal Operating System vessel category code used for vessel planning, berth allocation, and operational scheduling.. Valid values are `^[A-Z0-9]{1,6}$`',
    `priority_ranking` STRING COMMENT 'Numeric priority ranking for berth allocation and scheduling when multiple vessels compete for limited berth capacity. Lower numbers indicate higher priority.',
    `requires_pilotage` BOOLEAN COMMENT 'Indicates whether vessels of this type typically require marine pilotage services for port entry and berthing operations.',
    `requires_towage` BOOLEAN COMMENT 'Indicates whether vessels of this type typically require towage (tug) services for berthing and unberthing operations.',
    `solas_chapter_reference` STRING COMMENT 'Comma-separated list of applicable SOLAS chapter references for this vessel type (e.g., Chapter II-1, Chapter II-2, Chapter V).',
    `sts_crane_compatible` BOOLEAN COMMENT 'Indicates whether vessels of this type are compatible with ship-to-shore (STS) quay cranes for container handling operations.',
    `tariff_category_code` STRING COMMENT 'Tariff category code used to determine applicable port charges, wharfage, and terminal handling charges (THC) for this vessel type.. Valid values are `^[A-Z0-9]{1,6}$`',
    `typical_beam_max_m` DECIMAL(18,2) COMMENT 'Maximum typical beam (width) in meters for vessels of this type. Used for berth width compatibility assessment.',
    `typical_beam_min_m` DECIMAL(18,2) COMMENT 'Minimum typical beam (width) in meters for vessels of this type. Used for berth width compatibility assessment.',
    `typical_draft_max_m` DECIMAL(18,2) COMMENT 'Maximum typical draft (depth below waterline) in meters for vessels of this type. Critical for channel and berth depth compatibility.',
    `typical_draft_min_m` DECIMAL(18,2) COMMENT 'Minimum typical draft (depth below waterline) in meters for vessels of this type. Critical for channel and berth depth compatibility.',
    `typical_dwt_max` DECIMAL(18,2) COMMENT 'Maximum typical deadweight tonnage (DWT) in metric tons for vessels of this type. Used for berth compatibility and tariff calculation.',
    `typical_dwt_min` DECIMAL(18,2) COMMENT 'Minimum typical deadweight tonnage (DWT) in metric tons for vessels of this type. Used for berth compatibility and tariff calculation.',
    `typical_grt_max` DECIMAL(18,2) COMMENT 'Maximum typical gross registered tonnage (GRT) for vessels of this type. Used for regulatory reporting and tariff calculations.',
    `typical_grt_min` DECIMAL(18,2) COMMENT 'Minimum typical gross registered tonnage (GRT) for vessels of this type. Used for regulatory reporting and tariff calculations.',
    `typical_loa_max_m` DECIMAL(18,2) COMMENT 'Maximum typical length overall (LOA) in meters for vessels of this type. Critical for berth allocation and planning.',
    `typical_loa_min_m` DECIMAL(18,2) COMMENT 'Minimum typical length overall (LOA) in meters for vessels of this type. Critical for berth allocation and planning.',
    `typical_teu_capacity_max` STRING COMMENT 'Maximum typical container capacity in TEU for container vessel types. Null for non-container vessel types.',
    `typical_teu_capacity_min` STRING COMMENT 'Minimum typical container capacity in TEU for container vessel types. Null for non-container vessel types.',
    `valid_from_date` DATE COMMENT 'Effective start date from which this vessel type classification is valid and available for operational use. Supports temporal versioning of classification changes.',
    `valid_to_date` DATE COMMENT 'Effective end date after which this vessel type classification is no longer valid. Null indicates the classification is currently active with no planned end date.',
    `vessel_category` STRING COMMENT 'High-level categorical grouping of vessel types for operational and analytical purposes. [ENUM-REF-CANDIDATE: container|bulk|tanker|roro|lolo|general_cargo|passenger|tug|barge|specialized — 10 candidates stripped; promote to reference product]',
    `vessel_type_status` STRING COMMENT 'Current lifecycle status of the vessel type classification record. Active types are available for operational use; deprecated types are retained for historical reference only.. Valid values are `active|inactive|deprecated|pending`',
    `vts_tracking_required` BOOLEAN COMMENT 'Indicates whether vessels of this type are required to be tracked by the Vessel Traffic Service (VTS) system during port operations.',
    CONSTRAINT pk_vessel_type PRIMARY KEY(`vessel_type_id`)
) COMMENT 'Reference classification of vessel types recognised in maritime logistics — container ship, bulk carrier, tanker (crude/product/chemical), RoRo, LoLo, general cargo, passenger/cruise, tug, barge, FPSO, LNG/LPG carrier, car carrier, and livestock carrier. Captures IMO vessel type code, NAVIS vessel category code, typical DWT range, typical LOA range, beam range, applicable SOLAS chapter references, berth compatibility flags, and effectivity dates (valid_from/valid_to) for classification changes. Data steward: Marine Operations. SSOT for vessel type classification used to drive berth compatibility rules, tariff schedules, equipment assignment logic, and VTS categorisation.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` (
    `container_type_id` BIGINT COMMENT 'Primary key for container_type',
    `container_category` STRING COMMENT 'Primary functional category of the container: general-purpose (dry cargo), reefer (refrigerated), open-top, flat-rack, tank, platform, or special (non-standard). Determines handling requirements and yard allocation. [ENUM-REF-CANDIDATE: general-purpose|reefer|open-top|flat-rack|tank|platform|special — 7 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this container type master record was first created in the system. Audit trail for data lineage.',
    `data_steward` STRING COMMENT 'Business unit or role responsible for maintaining the accuracy and currency of this container type master record. Typically Terminal Operations or Master Data Management.',
    `door_configuration` STRING COMMENT 'Door access configuration: end-door (standard rear doors), side-door (side access), open-top (top loading), or no-door (platform/flat-rack). Determines loading/unloading procedures.. Valid values are `end-door|side-door|open-top|no-door`',
    `effective_from_date` DATE COMMENT 'Date from which this container type definition became effective and available for operations. Used for temporal validity and historical tracking.',
    `effective_to_date` DATE COMMENT 'Date until which this container type definition is valid. Null for currently active types. Used for phasing out obsolete container types and maintaining historical accuracy.',
    `handling_equipment_type` STRING COMMENT 'Preferred or required handling equipment for this container type (e.g., STS crane, RTG, reach stacker, mobile harbour crane). Guides terminal operations and equipment dispatch. [ENUM-REF-CANDIDATE: STS|RTG|ASC|reach-stacker|forklift|mobile-harbour-crane|spreader-standard|spreader-telescopic — promote to reference product]',
    `height_category` STRING COMMENT 'Height classification of the container: standard (8ft 6in), high-cube (9ft 6in), or super-high-cube (10ft or greater). Determines stacking and stowage constraints.. Valid values are `standard|high-cube|super-high-cube`',
    `height_mm` STRING COMMENT 'External height of the container in millimeters. Standard containers are typically 2591mm, high-cube containers are 2896mm.',
    `internal_capacity_cbm` DECIMAL(18,2) COMMENT 'Internal volume capacity of the container in cubic meters. Used for cargo volume planning and Less than Container Load (LCL) consolidation.',
    `is_collapsible` BOOLEAN COMMENT 'Boolean flag indicating whether the container can be collapsed or folded for empty repositioning to save space. Common for flat-rack collapsible types.',
    `is_hazmat_approved` BOOLEAN COMMENT 'Boolean flag indicating whether this container type is approved for carrying hazardous materials under IMDG Code. True if IMDG-certified, False otherwise.',
    `is_oog_capable` BOOLEAN COMMENT 'Boolean flag indicating whether this container type can accommodate out-of-gauge (oversized) cargo. True for open-top, flat-rack, and platform types; False for standard enclosed containers.',
    `is_reefer` BOOLEAN COMMENT 'Boolean flag indicating whether this is a refrigerated (reefer) container requiring temperature control and power supply. True for reefer types, False otherwise.',
    `iso_standard_version` STRING COMMENT 'Version or revision year of the ISO 6346 standard under which this container type is classified (e.g., ISO 6346:1995, ISO 6346:2022). Tracks standard evolution and compliance.',
    `iso_type_code` STRING COMMENT 'Four-character ISO 6346 container type code identifying the container category and characteristics (e.g., 22G1 for 20ft general purpose, 45R1 for 40ft high-cube reefer). This is the globally recognized standard identifier for container types.. Valid values are `^[A-Z0-9]{4}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this container type master record was last updated. Audit trail for change tracking and data quality monitoring.',
    `length_mm` STRING COMMENT 'External length of the container in millimeters. 20ft containers are 6058mm, 40ft containers are 12192mm, 45ft containers are 13716mm.',
    `max_gross_weight_kg` DECIMAL(18,2) COMMENT 'Maximum permissible gross weight (container + cargo) in kilograms as per ISO 6346 and SOLAS VGM requirements. Typically 30,480 kg for standard containers.',
    `max_payload_kg` DECIMAL(18,2) COMMENT 'Maximum cargo weight capacity in kilograms, calculated as max_gross_weight minus tare_weight. Used for cargo booking and load planning.',
    `container_type_name` STRING COMMENT 'Human-readable descriptive name of the container type (e.g., 20ft General Purpose, 40ft High Cube Reefer, 20ft Open Top, 40ft Flat Rack Collapsible).',
    `operational_status` STRING COMMENT 'Current operational status of this container type in the terminal system: active (in use), inactive (not currently handled), deprecated (phased out), or restricted (limited use). Controls availability in booking and yard systems.. Valid values are `active|inactive|deprecated|restricted`',
    `reefer_temp_max_celsius` DECIMAL(18,2) COMMENT 'Maximum operating temperature in Celsius for refrigerated containers. Typically ranges from +25°C to +30°C for chilled cargo. Null for non-reefer types.',
    `reefer_temp_min_celsius` DECIMAL(18,2) COMMENT 'Minimum operating temperature in Celsius for refrigerated containers. Typically ranges from -35°C to -25°C for frozen cargo. Null for non-reefer types.',
    `size_code` STRING COMMENT 'Nominal length of the container in feet. Standard values are 20, 40, and 45 feet.. Valid values are `20|40|45`',
    `special_handling_instructions` STRING COMMENT 'Free-text field capturing any special handling, stowage, or operational instructions specific to this container type (e.g., Requires twist locks, Must be stowed on deck only, Power supply mandatory).',
    `stacking_strength_tier` STRING COMMENT 'Structural stacking tier rating indicating how many containers can be safely stacked on top of this type. Typically 1-9 for standard containers, lower for specialized types. Used for yard planning and vessel stowage.',
    `swl_kg` DECIMAL(18,2) COMMENT 'Safe Working Load for lifting operations in kilograms. Maximum load that can be safely lifted by crane or handling equipment. Critical for terminal operations safety.',
    `tare_weight_kg` DECIMAL(18,2) COMMENT 'Empty weight of the container in kilograms, excluding cargo. Used for gross weight calculations and vessel stability planning.',
    `tariff_class_code` STRING COMMENT 'Tariff classification code used for billing and Terminal Handling Charge (THC) calculation. Links this container type to the ports tariff schedule for pricing.',
    `teu_equivalent` DECIMAL(18,2) COMMENT 'The TEU equivalent value for this container type. A 20ft container = 1.0 TEU, a 40ft container = 2.0 TEU, a 45ft container = 2.25 TEU. Used for capacity planning and vessel stowage calculations.',
    `ventilation_setting` STRING COMMENT 'Ventilation capability of the container: none (sealed), passive (natural vents), active (forced air), or controlled-atmosphere (CA for perishables). Relevant for reefers and ventilated containers.. Valid values are `none|passive|active|controlled-atmosphere`',
    `width_mm` STRING COMMENT 'External width of the container in millimeters. Standard ISO containers are 2438mm wide.',
    `yard_block_preference` STRING COMMENT 'Preferred yard block or zone designation for storing this container type (e.g., REEFER-01 for reefers near power outlets, HAZMAT-A for dangerous goods, GENERAL-B for standard dry containers). Guides automated yard planning.',
    CONSTRAINT pk_container_type PRIMARY KEY(`container_type_id`)
) COMMENT 'Reference master for all ISO 6346 container types handled at the terminal — 20GP, 40GP, 40HC, 45HC, 20RF, 40RF, 20OT, 40OT, 20FR, 40FR, 20TK (tank), flat rack collapsible, platform, and special-purpose units. Captures ISO type code (4-character), size code (TEU/FEU), height category (standard/high-cube/super-high-cube), tare weight, maximum gross weight, internal cubic capacity (CBM), SWL, temperature range (for reefers), ventilation settings, special handling flags (IMDG, OOG, hazardous), and effectivity dates for ISO standard revisions. Data steward: Terminal Operations. SSOT for container type classification used by NAVIS N4 TOS, cargo manifests, yard planning, and tariff domains.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` (
    `port_location_id` BIGINT COMMENT 'Unique identifier for the port location record. Primary key for the port_location entity.',
    `un_locode_id` BIGINT COMMENT 'Foreign key linking to masterdata.un_locode. Business justification: Port locations reference UN/LOCODE global location codes for international trade and EDI messaging. Currently stores un_locode as STRING; normalizing to FK allows joining to un_locode for full locatio',
    `bollard_spacing_meters` DECIMAL(18,2) COMMENT 'Distance in meters between mooring bollards along the berth or quay. Critical for vessel mooring planning and safe berthing operations. Applicable to berth and quay locations.',
    `bollard_swl_tonnes` DECIMAL(18,2) COMMENT 'Safe Working Load (SWL) of mooring bollards at this location, measured in metric tonnes. Defines the maximum safe mooring line tension. Applicable to berth and quay locations.',
    `commissioning_date` DATE COMMENT 'Date when the location was officially commissioned and became operational. Marks the start of the locations active lifecycle. Format: yyyy-MM-dd.',
    `container_yard_capacity_teu` STRING COMMENT 'Total container storage capacity of the yard location measured in Twenty-foot Equivalent Units (TEU). Applicable to Container Yard (CY) and container stacking locations.',
    `crane_type` STRING COMMENT 'Type of cargo handling crane equipment serving this location. STS = Ship-to-Shore, QC = Quay Crane, MHC = Mobile Harbour Crane, RTG = Rubber Tyred Gantry, ASC = Automated Stacking Crane. none if no crane coverage.. Valid values are `sts|qc|mhc|rtg|asc|none`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this location record was first created in the system. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX. Used for audit trail and data lineage tracking.',
    `customs_zone_code` STRING COMMENT 'Customs authority zone code applicable to this location. Defines the customs jurisdiction and regulatory requirements for cargo handling. Used for customs clearance and trade compliance.',
    `data_steward` STRING COMMENT 'Business unit or role responsible for maintaining the accuracy and completeness of this location record. Typically Infrastructure Planning, Marine Operations, or Terminal Operations department.',
    `decommissioning_date` DATE COMMENT 'Date when the location was officially decommissioned and retired from operational service. Nullable for active locations. Format: yyyy-MM-dd.',
    `effective_from_date` DATE COMMENT 'Date from which this location record is effective and valid for operational use. Supports temporal validity and historical tracking. Format: yyyy-MM-dd.',
    `effective_to_date` DATE COMMENT 'Date until which this location record is effective and valid for operational use. Nullable for currently effective records. Supports temporal validity and historical tracking. Format: yyyy-MM-dd.',
    `environmental_zone` STRING COMMENT 'Environmental monitoring zone classification for this location. Used for tracking air quality, water quality, noise levels, and emissions per Environmental Management System (EMS) requirements. Links to environmental monitoring stations.',
    `fender_energy_absorption_kj` DECIMAL(18,2) COMMENT 'Maximum energy absorption capacity of the fender system in kilojoules (kJ). Defines the berthing impact energy the fender can safely absorb. Applicable to berth and quay locations with fender systems.',
    `fender_type` STRING COMMENT 'Type of fender system installed at the berth or quay for vessel impact absorption. Applicable to berth and quay locations. none if no fender system present. [ENUM-REF-CANDIDATE: pneumatic|foam_filled|cylindrical|cone|cell|arch|none — 7 candidates stripped; promote to reference product]',
    `gate_lane_type` STRING COMMENT 'Operational direction and function of the gate lane. Defines whether the lane handles inbound traffic, outbound traffic, bidirectional flow, or inspection/customs processing. Applicable to gate lane locations.. Valid values are `inbound|outbound|bidirectional|inspection`',
    `icd_linkage_code` STRING COMMENT 'Reference code linking this port location to an associated Inland Container Depot (ICD) for intermodal container transfer. Applicable to ICD linkage point locations. Nullable for locations without ICD connectivity.',
    `isps_security_level` STRING COMMENT 'Current ISPS Code security level assigned to this location. Level 1 = normal security measures; Level 2 = heightened security measures; Level 3 = exceptional security measures. Defines access control and security protocols.. Valid values are `level_1|level_2|level_3`',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this location record was last modified in the system. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX. Used for audit trail and change tracking.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the location in decimal degrees using WGS84 datum. Positive values represent North, negative values represent South. Used for vessel navigation, pilotage planning, and GIS integration.',
    `location_area` STRING COMMENT 'Mid-level area classification within a zone (e.g., Berth Complex A, Yard Section 3, Anchorage Inner). Second level of the zone > area > point hierarchy.',
    `location_code` STRING COMMENT 'Internal alphanumeric code uniquely identifying the location within the ports operational systems. Used across Terminal Operating System (TOS), Vessel Traffic Management System (VTMS), and Port Community System (PCS) for location referencing.. Valid values are `^[A-Z0-9]{4,12}$`',
    `location_name` STRING COMMENT 'Full descriptive name of the port location (e.g., Berth 12 North, Container Yard Block A3, Anchorage Zone Outer, Pilot Boarding Ground Alpha).',
    `location_point` STRING COMMENT 'Specific point identifier within an area (e.g., Bollard 12A, Stack Row 5, Gate Lane 3). Lowest level of the zone > area > point hierarchy.',
    `location_type` STRING COMMENT 'Classification of the location type within the port infrastructure hierarchy. Defines the operational function and handling capabilities of the location. [ENUM-REF-CANDIDATE: berth|quay|anchorage|pilot_boarding_ground|container_yard|cfs_shed|gate_lane|rail_siding|bunkering_point|icd_linkage|warehouse|maintenance_area — 12 candidates stripped; promote to reference product]',
    `location_zone` STRING COMMENT 'High-level zone classification within the port (e.g., North Terminal, South Basin, Container Terminal 1). Top level of the zone > area > point hierarchy.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the location in decimal degrees using WGS84 datum. Positive values represent East, negative values represent West. Used for vessel navigation, pilotage planning, and GIS integration.',
    `maximum_vessel_beam_meters` DECIMAL(18,2) COMMENT 'Maximum permissible vessel beam (width) in meters that can be accommodated at this location. Constraint based on berth width, fender spacing, and approach channel dimensions.',
    `maximum_vessel_dwt_tonnes` DECIMAL(18,2) COMMENT 'Maximum permissible vessel Deadweight Tonnage (DWT) in metric tonnes that can be accommodated at this location. Constraint based on water depth, berth structural capacity, and mooring equipment Safe Working Load (SWL).',
    `maximum_vessel_loa_meters` DECIMAL(18,2) COMMENT 'Maximum permissible vessel Length Overall (LOA) in meters that can be accommodated at this location. Constraint based on berth length, maneuvering space, and infrastructure design.',
    `operational_status` STRING COMMENT 'Current operational status of the port location. Active = fully operational and available for use; Under Maintenance = temporarily unavailable due to maintenance or repair; Decommissioned = permanently retired from service; Planned = future location not yet commissioned; Suspended = temporarily out of service for operational reasons.. Valid values are `active|under_maintenance|decommissioned|planned|suspended`',
    `rail_siding_capacity_teu` STRING COMMENT 'Container handling capacity of the rail siding measured in Twenty-foot Equivalent Units (TEU). Defines the maximum number of containers that can be loaded/unloaded per rail operation. Applicable to rail siding locations.',
    `remarks` STRING COMMENT 'Free-text field for additional operational notes, restrictions, special handling requirements, or other relevant information about the location. Used for operational guidance and exception documentation.',
    `rfid_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether this location is equipped with Radio Frequency Identification (RFID) technology for automated container and vehicle tracking. True if RFID-enabled, False otherwise.',
    `shore_crane_coverage` BOOLEAN COMMENT 'Boolean flag indicating whether this location is covered by shore-based cargo handling cranes (Ship-to-Shore (STS), Quay Crane (QC), or Mobile Harbour Crane (MHC)). True if crane coverage exists, False otherwise.',
    `water_depth_meters` DECIMAL(18,2) COMMENT 'Water depth at the location measured in meters below Chart Datum (CD). Critical for determining vessel draft limitations and safe navigation. Applicable to berths, anchorages, and waterside locations.',
    `yard_block_bays` STRING COMMENT 'Number of container stacking bays in the yard block. Defines the longitudinal layout dimension of the container yard. Applicable to Container Yard (CY) locations.',
    `yard_block_rows` STRING COMMENT 'Number of container stacking rows in the yard block. Defines the horizontal layout dimension of the container yard. Applicable to Container Yard (CY) locations.',
    `yard_block_tiers` STRING COMMENT 'Maximum number of container stacking tiers (vertical height) in the yard block. Defines the vertical stacking capacity. Applicable to Container Yard (CY) locations.',
    CONSTRAINT pk_port_location PRIMARY KEY(`port_location_id`)
) COMMENT 'Enterprise reference for all port locations and sub-locations within the ports jurisdiction — berths (numbered), quay sections, anchorage areas (inner/outer), pilot boarding grounds, container yard blocks (CY), CFS sheds, gate lanes, rail sidings, bunkering points, and ICD linkage points. Captures UN/LOCODE (FK to un_locode), internal location code, location type hierarchy (zone > area > point), geographic coordinates (WGS84 lat/long), water depth (CD), maximum vessel LOA, maximum beam, maximum DWT, bollard spacing, shore crane coverage, fender type, and operational status (active/under-maintenance/decommissioned). Includes effectivity dates for location commissioning and decommissioning. Data steward: Infrastructure / Marine Operations. SSOT for physical location identity referenced across terminal, vessel, infrastructure, and intermodal domains.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` (
    `un_locode_id` BIGINT COMMENT 'Unique identifier for the UN/LOCODE location record. Primary key for the global location reference table.',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: UN/LOCODE location codes reference the country in which the location resides. Currently stores country_code as STRING (ISO alpha-2); normalizing to FK allows joining to country for full country data (',
    `coordinate_precision` STRING COMMENT 'Indicator of the precision level of the latitude and longitude coordinates. Exact=surveyed or GPS-verified coordinates; Approximate=estimated from regional data; Unknown=coordinates not verified.. Valid values are `exact|approximate|unknown`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this record was first created in the enterprise data lakehouse. Used for audit trail and data lineage tracking.',
    `date_added` DATE COMMENT 'Date when the location code was first added to the UN/LOCODE directory. Used for data lineage and historical tracking.',
    `date_last_modified` DATE COMMENT 'Date when the location code record was last updated in the UN/LOCODE directory. Reflects changes to location name, function codes, coordinates, or status.',
    `effective_from_date` DATE COMMENT 'Date from which this UN/LOCODE record is valid and should be used in operational systems, EDI messaging, and trade documentation. Supports temporal validity for location code changes.',
    `effective_to_date` DATE COMMENT 'Date until which this UN/LOCODE record is valid. Null indicates the record is currently active. Used for managing deprecated or superseded location codes.',
    `function_code` STRING COMMENT 'Eight-character function classifier indicating the transport modes and facilities available at the location. Position 1: Port (1=yes); Position 2: Rail terminal (2=yes); Position 3: Road terminal (3=yes); Position 4: Airport (4=yes); Position 5: Postal exchange office (5=yes); Position 6: Inland Container Depot (ICD) or Container Freight Station (CFS) (6=yes); Position 7: Fixed transport functions (7=yes); Position 8: Border crossing (B=yes). Hyphen (-) indicates function not available.. Valid values are `^[0-7B-]{8}$`',
    `iata_code` STRING COMMENT 'Three-letter IATA airport or city code if the location is an airport or has an associated IATA code. Used for air cargo routing and Air Waybill (AWB) documentation.. Valid values are `^[A-Z]{3}$`',
    `is_active` BOOLEAN COMMENT 'Boolean flag indicating whether the location code is currently active and should be used in operational systems. Inactive codes are retained for historical reference and audit purposes.',
    `is_airport` BOOLEAN COMMENT 'Boolean flag indicating whether the location functions as an airport with cargo handling facilities. Derived from function_code position 4. Used for Air Waybill (AWB) routing and multimodal logistics.',
    `is_border_crossing` BOOLEAN COMMENT 'Boolean flag indicating whether the location serves as an international border crossing point. Derived from function_code position 8. Used for customs declarations, trade compliance, and cross-border cargo tracking.',
    `is_fixed_transport_function` BOOLEAN COMMENT 'Boolean flag indicating whether the location has fixed transport infrastructure functions (e.g., pipelines, cable transport). Derived from function_code position 7.',
    `is_iaph_member` BOOLEAN COMMENT 'Boolean flag indicating whether the port is a member of the International Association of Ports and Harbors (IAPH). IAPH membership signals adherence to international port standards, best practices, and participation in global maritime policy development.',
    `is_inland_container_depot` BOOLEAN COMMENT 'Boolean flag indicating whether the location operates as an Inland Container Depot (ICD) or Container Freight Station (CFS). Derived from function_code position 6. Critical for Full Container Load (FCL) and Less than Container Load (LCL) cargo routing and customs clearance.',
    `is_port` BOOLEAN COMMENT 'Boolean flag indicating whether the location functions as a seaport or maritime terminal. Derived from function_code position 1. Used for vessel traffic management, berth allocation, and marine services routing.',
    `is_postal_exchange` BOOLEAN COMMENT 'Boolean flag indicating whether the location serves as a postal exchange office. Derived from function_code position 5.',
    `is_rail_terminal` BOOLEAN COMMENT 'Boolean flag indicating whether the location has rail freight terminal facilities. Derived from function_code position 2. Used for intermodal transport coordination and rail operations planning.',
    `is_road_terminal` BOOLEAN COMMENT 'Boolean flag indicating whether the location has road freight terminal facilities. Derived from function_code position 3. Used for truck gate operations and yard management.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this record was last modified in the enterprise data lakehouse. Used for change tracking and data quality monitoring.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate in decimal degrees (WGS84 datum). Positive values represent North, negative values represent South. Used for vessel tracking, route optimization, and geographic information systems.',
    `location_name` STRING COMMENT 'Official name of the port, inland container depot, airport, or border crossing as registered with UNECE. This is the human-readable identifier used in shipping documentation, vessel schedules, and port community systems.',
    `location_name_without_diacritics` STRING COMMENT 'ASCII-normalized version of the location name with diacritical marks removed for system compatibility and EDI messaging where special characters are not supported.',
    `locode` STRING COMMENT 'Five-character UN/LOCODE identifier consisting of two-letter ISO 3166-1 alpha-2 country code followed by three-character location code. This is the globally recognized standard identifier for ports, inland freight terminals, airports, and border crossings used in Bill of Lading (BOL), cargo manifests, customs declarations, and Electronic Data Interchange (EDI) messaging.. Valid values are `^[A-Z]{2}[A-Z0-9]{3}$`',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate in decimal degrees (WGS84 datum). Positive values represent East, negative values represent West. Used for vessel tracking, route optimization, and geographic information systems.',
    `remarks` STRING COMMENT 'Free-text field for additional notes, clarifications, or special instructions related to the location code. May include alternative names, historical context, or operational considerations.',
    `status_code` STRING COMMENT 'UN/LOCODE status indicator. AA=Approved by competent national government agency; AC=Approved by Customs Authority; AF=Approved by national facilitation body; AI=Code adopted by international organization (IATA or ECLAC); AM=Approved by the UN/LOCODE Maintenance Agency; AQ=Entry approved, functions not verified; AS=Approved by national standardization body; RL=Recognized location (not officially approved); RN=Request from credible national sources; RQ=Request under consideration; RR=Request rejected; UR=Entry included on user request; XX=Entry that will be removed in the next issue. [ENUM-REF-CANDIDATE: AA|AC|AF|AI|AM|AQ|AS|RL|RN|RQ|RR|UR|XX — 13 candidates stripped; promote to reference product]',
    `subdivision_code` STRING COMMENT 'ISO 3166-2 subdivision code identifying the state, province, or administrative region within the country. Used for regional trade statistics and domestic routing.',
    `unece_update_cycle` STRING COMMENT 'Identifier of the UNECE publication cycle in which this location code was added or last modified, formatted as YYYY-N where YYYY is the year and N is the half-year cycle (1 or 2). Used for version control and data stewardship.. Valid values are `^[0-9]{4}-[1-2]$`',
    CONSTRAINT pk_un_locode PRIMARY KEY(`un_locode_id`)
) COMMENT 'Global reference table of UN/LOCODE location codes covering ports, inland freight terminals, airports, and border crossings worldwide. Captures LOCODE (5-character), country reference (FK to country), location name, subdivision code, function codes (port, rail, road, airport, ICD), coordinates (WGS84), IAPH membership flag, and UNECE update cycle reference with effectivity dates. Data steward: Marine Operations / Trade Compliance. Used as the global location standard for BOL origin/destination, cargo routing, customs declarations, and EDI messaging across all domains.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` (
    `commodity_code_id` BIGINT COMMENT 'Unique identifier for the commodity code record. Primary key.',
    `container_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.container_type. Business justification: commodity_code.applicable_equipment_types is a STRING field that captures the standard container/equipment type for a commodity (e.g., reefer containers for temperature-sensitive goods, open-top for O',
    `imdg_class_id` BIGINT COMMENT 'Foreign key linking to masterdata.imdg_class. Business justification: Commodity codes for dangerous goods reference IMDG hazard classifications. Currently stores imdg_class_code as STRING; normalizing to FK allows joining to imdg_class for full hazard data (division, ha',
    `applicable_equipment_types` STRING COMMENT 'Comma-separated list of container or equipment type codes suitable for this commodity (e.g., 20GP, 40HC, 40RF, TANK, FLAT). References standard ISO container type codes and port-specific equipment classifications.',
    `commodity_code_status` STRING COMMENT 'Current lifecycle status of the commodity code record: ACTIVE (in use), INACTIVE (not in use), DEPRECATED (superseded by newer code), PENDING_APPROVAL (awaiting data steward approval).. Valid values are `ACTIVE|INACTIVE|DEPRECATED|PENDING_APPROVAL`',
    `commodity_description` STRING COMMENT 'Detailed textual description of the commodity or cargo type as defined by the HS code and port-specific classification.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this commodity code record was first created in the system.',
    `data_steward` STRING COMMENT 'Name or identifier of the data steward responsible for maintaining this commodity code record. Typically Trade Compliance team.',
    `ems_number` STRING COMMENT 'IMDG Emergency Schedule number providing fire-fighting and spillage procedures for dangerous goods (format: F-X,S-Y). Null if not dangerous goods.. Valid values are `^F-[A-Z],[S]-[A-Z]$`',
    `excepted_quantity` BOOLEAN COMMENT 'Indicates whether this commodity qualifies for excepted quantity exemptions under IMDG Code (True/False).',
    `export_license_required` BOOLEAN COMMENT 'Indicates whether an export license or permit is required for this commodity when leaving the port jurisdiction (True/False).',
    `flash_point_celsius` DECIMAL(18,2) COMMENT 'Flash point temperature in Celsius for flammable commodities. Null if not applicable.',
    `fumigation_required` BOOLEAN COMMENT 'Indicates whether this commodity requires fumigation treatment before or after discharge (True/False).',
    `handling_method` STRING COMMENT 'Standard handling method required for this commodity type: LOLO (Lift-on Lift-off), RORO (Roll-on Roll-off), BULK_PUMP (bulk liquid pumping), BULK_GRAB (bulk dry grab), CRANE (crane handling), FORKLIFT (forklift handling), MANUAL (manual handling), AUTOMATED (automated handling). [ENUM-REF-CANDIDATE: LOLO|RORO|BULK_PUMP|BULK_GRAB|CRANE|FORKLIFT|MANUAL|AUTOMATED — 8 candidates stripped; promote to reference product]',
    `hs_chapter` STRING COMMENT 'Two-digit chapter code representing the highest level of HS classification hierarchy (e.g., Chapter 01 = Live Animals).. Valid values are `^[0-9]{2}$`',
    `hs_code` STRING COMMENT 'International commodity classification code under the Harmonized System. 6-digit international standard, with optional 8 or 10-digit national extensions for detailed classification.. Valid values are `^[0-9]{6,10}$`',
    `hs_heading` STRING COMMENT 'Four-digit heading code representing the second level of HS classification hierarchy within a chapter.. Valid values are `^[0-9]{4}$`',
    `hs_revision_year` STRING COMMENT 'Year of the HS nomenclature revision that this code belongs to (e.g., 2017, 2022). WCO updates HS codes approximately every 5 years.',
    `hs_subheading` STRING COMMENT 'Six-digit subheading code representing the third level of HS classification hierarchy, providing detailed commodity classification.. Valid values are `^[0-9]{6}$`',
    `import_license_required` BOOLEAN COMMENT 'Indicates whether an import license or permit is required for this commodity when entering the port jurisdiction (True/False).',
    `limited_quantity` BOOLEAN COMMENT 'Indicates whether this commodity qualifies for limited quantity exemptions under IMDG Code (True/False).',
    `marine_pollutant` BOOLEAN COMMENT 'Indicates whether this commodity is classified as a marine pollutant under MARPOL and IMDG Code (True/False).',
    `marpol_category` STRING COMMENT 'MARPOL annex category applicable to this commodity if it is a pollutant or hazardous substance: ANNEX_I (oil), ANNEX_II (noxious liquid substances), ANNEX_III (harmful substances in packaged form), ANNEX_IV (sewage), ANNEX_V (garbage), ANNEX_VI (air pollution), NOT_APPLICABLE (not a MARPOL-regulated substance). [ENUM-REF-CANDIDATE: ANNEX_I|ANNEX_II|ANNEX_III|ANNEX_IV|ANNEX_V|ANNEX_VI|NOT_APPLICABLE — 7 candidates stripped; promote to reference product]',
    `notes` STRING COMMENT 'Free-text notes providing additional context, handling instructions, or special considerations for this commodity code.',
    `packing_group` STRING COMMENT 'IMDG packing group indicating degree of danger for dangerous goods: I (high danger), II (medium danger), III (low danger). Null if not dangerous goods.. Valid values are `I|II|III`',
    `prohibited_goods_flag` BOOLEAN COMMENT 'Indicates whether this commodity is prohibited from import or export through the port under current regulations (True/False).',
    `proper_shipping_name` STRING COMMENT 'Official proper shipping name for dangerous goods as defined by IMDG Code. Null if not dangerous goods.',
    `quarantine_required` BOOLEAN COMMENT 'Indicates whether this commodity requires quarantine inspection or clearance by biosecurity or agricultural authorities (True/False).',
    `segregation_group` STRING COMMENT 'IMDG segregation group code indicating stowage and segregation requirements for dangerous goods. Null if not dangerous goods.',
    `storage_area_type` STRING COMMENT 'Type of storage area required for this commodity: CY (Container Yard), CFS (Container Freight Station), OPEN_YARD (open yard), COVERED_SHED (covered shed), TANK_FARM (tank farm), REEFER_RACK (reefer rack), WAREHOUSE (warehouse), BONDED (bonded warehouse). [ENUM-REF-CANDIDATE: CY|CFS|OPEN_YARD|COVERED_SHED|TANK_FARM|REEFER_RACK|WAREHOUSE|BONDED — 8 candidates stripped; promote to reference product]',
    `tariff_rate_percent` DECIMAL(18,2) COMMENT 'Standard customs tariff rate (duty percentage) applicable to this commodity code for import into the port jurisdiction. Null if duty-free or variable.',
    `temperature_controlled` BOOLEAN COMMENT 'Indicates whether this commodity requires temperature-controlled storage or transport (reefer cargo) (True/False).',
    `temperature_range_max_celsius` DECIMAL(18,2) COMMENT 'Maximum temperature in Celsius required for temperature-controlled commodities. Null if not temperature-controlled.',
    `temperature_range_min_celsius` DECIMAL(18,2) COMMENT 'Minimum temperature in Celsius required for temperature-controlled commodities. Null if not temperature-controlled.',
    `un_number` STRING COMMENT 'Four-digit UN number identifying dangerous goods (e.g., UN1203 for gasoline). Null if not dangerous goods. Format: UN followed by 4 digits.. Valid values are `^UN[0-9]{4}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this commodity code record was last updated in the system.',
    `valid_from_date` DATE COMMENT 'Effective start date from which this commodity code is valid for use. Supports HS code revision cycles and regulatory changes.',
    `valid_to_date` DATE COMMENT 'Effective end date until which this commodity code is valid for use. Null if currently valid with no planned expiration. Supports HS code revision cycles and regulatory changes.',
    `wco_control_flag` BOOLEAN COMMENT 'Indicates whether this commodity is subject to special WCO customs controls, trade restrictions, or enhanced inspection requirements (True/False).',
    CONSTRAINT pk_commodity_code PRIMARY KEY(`commodity_code_id`)
) COMMENT 'Reference master for Harmonized System (HS) commodity codes, port-specific cargo classification codes, and cargo category hierarchy (FCL, LCL, bulk dry, bulk liquid, breakbulk, RoRo, project cargo, OOG, reefer, IMDG, empty). Captures HS code (6-digit international, 8/10-digit national extension), commodity description, chapter, heading, subheading, cargo category code, handling method, applicable equipment types, storage area type, IMDG class reference (FK to imdg_class), MARPOL category, applicable WCO controls, import/export licensing requirements, prohibited goods flag, and effectivity dates (valid_from/valid_to) for HS code revision cycles. Data steward: Trade Compliance. SSOT for cargo classification used in customs clearance, trade compliance, tariff calculation, and IMDG dangerous goods management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` (
    `country_id` BIGINT COMMENT 'Unique identifier for the country or territory record. Primary key.',
    `calling_code` STRING COMMENT 'International dialing prefix for the country (e.g., +1, +44, +86). Used for contact information validation and telecommunications routing.. Valid values are `^+[0-9]{1,4}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this country record was first created in the system. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the official currency of the country. Used for billing, tariff calculations, Currency Adjustment Factor (CAF) application, and financial reporting.. Valid values are `^[A-Z]{3}$`',
    `data_steward` STRING COMMENT 'Name of the business unit or role responsible for maintaining and validating country master data. Typically Compliance & Regulatory Affairs or Master Data Management team.',
    `effective_from_date` DATE COMMENT 'Date from which this country record is effective and valid for operational use. Supports temporal validity and historical tracking of country status changes.',
    `effective_to_date` DATE COMMENT 'Date until which this country record is effective. Null if currently active. Used for historical tracking of country status changes, mergers, or dissolutions.',
    `fatf_status` STRING COMMENT 'Status of the country with respect to Financial Action Task Force (FATF) anti-money laundering and counter-terrorism financing standards. Values: compliant (meets FATF standards), monitored (under increased monitoring), high_risk (identified as high-risk jurisdiction), not_assessed (not yet assessed). Impacts customer due diligence and financial transaction screening.. Valid values are `compliant|monitored|high_risk|not_assessed`',
    `flag_state_authority_contact` STRING COMMENT 'Primary contact information (email, phone, or address) for the flag state maritime authority. Used for regulatory inquiries, vessel certification verification, and compliance coordination.',
    `flag_state_authority_name` STRING COMMENT 'Name of the national maritime authority or flag state administration responsible for vessel registration, certification, and flag state oversight. Used for regulatory correspondence and compliance verification.',
    `flag_state_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this country is recognized as a vessel flag state. True if the country registers vessels under its flag; false otherwise. Critical for vessel registration validation and Port State Control (PSC) inspections.',
    `flag_state_performance_list` STRING COMMENT 'Classification of the flag state based on Port State Control (PSC) performance metrics. Values: white (high-performing, low deficiency rate), grey (medium-performing, moderate deficiency rate), black (low-performing, high deficiency rate). Directly impacts vessel inspection frequency and detention risk.. Valid values are `white|grey|black`',
    `imo_member_status` STRING COMMENT 'Membership status of the country in the International Maritime Organization (IMO). Values: member (full member state), associate_member (associate member), non_member (not a member). Affects applicability of IMO conventions and compliance requirements.. Valid values are `member|associate_member|non_member`',
    `indian_ocean_mou_member` BOOLEAN COMMENT 'Boolean flag indicating whether the country is a member of the Indian Ocean Memorandum of Understanding on Port State Control (Indian Ocean MOU). True if member; false otherwise. Determines PSC inspection regime applicability for vessels calling at ports in this country.',
    `iso_alpha_2_code` STRING COMMENT 'Two-letter country code as defined by ISO 3166-1 alpha-2 standard. Used in customs declarations, cargo manifests, and vessel registration documentation.. Valid values are `^[A-Z]{2}$`',
    `iso_alpha_3_code` STRING COMMENT 'Three-letter country code as defined by ISO 3166-1 alpha-3 standard. Commonly used in Bill of Lading (BOL), Electronic Data Interchange (EDI) messages, and Port Community System (PCS) integrations.. Valid values are `^[A-Z]{3}$`',
    `iso_numeric_code` STRING COMMENT 'Three-digit numeric country code as defined by ISO 3166-1 numeric standard. Used in international trade statistics and customs systems.. Valid values are `^[0-9]{3}$`',
    `isps_code_compliant` BOOLEAN COMMENT 'Boolean flag indicating whether the country has implemented the International Ship and Port Facility Security (ISPS) Code. True if compliant; false otherwise. Critical for port security assessments and vessel clearance procedures.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this country record was last modified. Used for audit trail, change tracking, and data synchronization across systems.',
    `marpol_ratified` BOOLEAN COMMENT 'Boolean flag indicating whether the country has ratified the International Convention for the Prevention of Pollution from Ships (MARPOL). True if ratified; false otherwise. Determines applicability of environmental protection and emissions standards.',
    `mlc_ratified` BOOLEAN COMMENT 'Boolean flag indicating whether the country has ratified the Maritime Labour Convention (MLC) 2006. True if ratified; false otherwise. Determines applicability of seafarer labor rights and working conditions standards.',
    `country_name` STRING COMMENT 'Common short-form name of the country or territory in English. Used for display purposes in Terminal Operating System (TOS), Vessel Traffic Management System (VTMS), and reporting interfaces.',
    `official_name` STRING COMMENT 'Full official name of the country or territory as recognized by the United Nations and International Maritime Organization (IMO). Used in formal legal documentation, customs declarations, and compliance reporting.',
    `paris_mou_member` BOOLEAN COMMENT 'Boolean flag indicating whether the country is a member of the Paris Memorandum of Understanding on Port State Control (Paris MOU). True if member; false otherwise. Determines PSC inspection regime applicability for vessels calling at ports in this country.',
    `psc_targeting_factor` DECIMAL(18,2) COMMENT 'Numeric targeting factor used by Port State Control (PSC) authorities to prioritize vessel inspections based on flag state performance. Higher values indicate higher risk and increased inspection likelihood. Range typically 0.00 to 10.00.',
    `record_status` STRING COMMENT 'Current lifecycle status of the country record. Values: active (currently in use), inactive (temporarily disabled), deprecated (no longer valid, retained for historical reference). Used to control operational visibility and data quality.. Valid values are `active|inactive|deprecated`',
    `region` STRING COMMENT 'Broad geographic region classification (e.g., Africa, Americas, Asia, Europe, Oceania) as defined by the United Nations geoscheme. Used for regional trade analysis and cargo routing strategies.',
    `region_code` BIGINT COMMENT 'add column region_code (BIGINT) with FK to masterdata.country.country_id - countries need a self-referencing parent for regional grouping used in sanctions and trade restrictions',
    `sanctions_effective_date` DATE COMMENT 'Date when current sanctions status became effective. Null if no sanctions are in place. Used for historical compliance tracking and audit trails.',
    `sanctions_expiry_date` DATE COMMENT 'Date when current sanctions are scheduled to expire or be reviewed. Null if sanctions are indefinite or no sanctions are in place. Used for forward-looking compliance planning.',
    `sanctions_list_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the country is currently subject to international trade sanctions or embargoes (e.g., United Nations, United States OFAC, European Union). True if sanctioned; false otherwise. Critical for trade compliance screening and cargo booking restrictions.',
    `solas_ratified` BOOLEAN COMMENT 'Boolean flag indicating whether the country has ratified the International Convention for the Safety of Life at Sea (SOLAS). True if ratified; false otherwise. Determines applicability of SOLAS safety requirements for vessels flagged or calling at ports in this country.',
    `sub_region` STRING COMMENT 'Sub-regional classification within the broader region (e.g., Eastern Asia, Western Europe, Southern Africa) as defined by the United Nations geoscheme. Supports granular trade flow analysis and vessel routing optimization.',
    `tokyo_mou_member` BOOLEAN COMMENT 'Boolean flag indicating whether the country is a member of the Tokyo Memorandum of Understanding on Port State Control (Tokyo MOU). True if member; false otherwise. Determines PSC inspection regime applicability for vessels calling at ports in this country.',
    `trade_agreement_codes` STRING COMMENT 'Comma-separated list of trade agreement codes applicable to this country (e.g., USMCA, EU, ASEAN, CPTPP, RCEP). Used to determine preferential tariff rates, customs duty exemptions, and Terminal Handling Charge (THC) adjustments.',
    `un_locode_prefix` STRING COMMENT 'Two-letter country prefix used in UN/LOCODE location codes. Matches ISO 3166-1 alpha-2 code. Used to construct full UN/LOCODE identifiers for ports and inland terminals within this country.. Valid values are `^[A-Z]{2}$`',
    `wco_member` BOOLEAN COMMENT 'Boolean flag indicating whether the country is a member of the World Customs Organization (WCO). True if member; false otherwise. Affects customs clearance procedures, Harmonized System (HS) Code usage, and trade facilitation standards.',
    CONSTRAINT pk_country PRIMARY KEY(`country_id`)
) COMMENT 'Global reference for all countries and territories recognised in port trade, compliance, and vessel registration operations. Captures ISO 3166-1 alpha-2 code, alpha-3 code, numeric code, country name, official name, region, sub-region, flag state indicator (boolean), IMO member status, Paris MOU/Tokyo MOU/Indian Ocean MOU membership, PSC targeting factor, grey/black/white list classification, flag state authority contact, maritime conventions ratified (SOLAS, MARPOL, MLC), WCO member flag, FATF status, sanctions list flag, and applicable trade agreement codes. Includes effectivity dating for sanctions status changes. Data steward: Compliance & Regulatory Affairs. SSOT for country identity used across customs clearance, cargo manifests, vessel registration (flag state), customer onboarding, and compliance domains.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` (
    `imdg_class_id` BIGINT COMMENT 'Unique identifier for the IMDG hazard classification record. Primary key.',
    `parent_imdg_class_id` BIGINT COMMENT 'Self-referencing FK on imdg_class (parent_imdg_class_id)',
    `class_name` STRING COMMENT 'Full descriptive name of the IMDG hazard class (e.g., Explosives, Flammable Gases, Flammable Liquids, Toxic Substances, Corrosive Substances, Radioactive Material). Human-readable label for the class.',
    `class_number` STRING COMMENT 'Primary IMDG hazard class number (1 through 9), with optional decimal subdivision (e.g., 2.1, 2.2, 2.3 for gases; 6.1, 6.2 for toxic substances). Defines the principal hazard category per IMO IMDG Code.. Valid values are `^[1-9](.[0-9])?$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this IMDG classification record was first created in the system. Used for audit trail and data lineage.',
    `data_steward` STRING COMMENT 'Name or role of the data steward responsible for maintaining and validating this IMDG classification master data. Typically the Safety & Compliance team or Dangerous Goods Compliance Officer.',
    `division` STRING COMMENT 'Subdivision or division within the IMDG class (e.g., 2.1 for flammable gases, 3 for flammable liquids, 6.1 for toxic substances). Provides finer hazard categorization within the primary class.',
    `ems_fire_code` STRING COMMENT 'EmS fire schedule code (e.g., F-A, F-B, F-C) specifying emergency response procedures for fire incidents involving this IMDG class. Referenced from the Emergency Response Procedures for Ships Carrying Dangerous Goods (EmS Guide).. Valid values are `^F-[A-Z]$`',
    `ems_spillage_code` STRING COMMENT 'EmS spillage schedule code (e.g., S-A, S-B, S-C) specifying emergency response procedures for spillage or leakage incidents involving this IMDG class. Referenced from the Emergency Response Procedures for Ships Carrying Dangerous Goods (EmS Guide).. Valid values are `^S-[A-Z]$`',
    `excepted_quantity_code` STRING COMMENT 'Excepted quantity code (E0, E1, E2, E3, E4, E5) defining the maximum quantity per inner packaging and per package for excepted quantity shipments. Excepted quantities are subject to minimal regulatory requirements.. Valid values are `E0|E1|E2|E3|E4|E5`',
    `hazard_label_type` STRING COMMENT 'Type or code of the hazard label required for containers and packages carrying goods of this IMDG class (e.g., Explosive 1.1, Flammable Gas, Toxic). Used for visual identification and compliance with labeling regulations.',
    `imdg_code_amendment_cycle` STRING COMMENT 'Amendment cycle or version of the IMDG Code under which this classification is defined (e.g., Amendment 40-20, Amendment 41-22). The IMDG Code is updated biennially; this field tracks which amendment cycle applies to this record.',
    `last_verified_date` DATE COMMENT 'Date when this IMDG classification record was last verified against the current IMO IMDG Code amendment. Used to ensure data currency and compliance with the latest regulatory requirements.',
    `limited_quantity_threshold` STRING COMMENT 'Maximum quantity per package or inner packaging that qualifies for limited quantity (LQ) exemptions under the IMDG Code. Expressed as a volume or mass (e.g., 1L, 5kg). Limited quantities are subject to reduced regulatory requirements.',
    `marine_pollutant_flag` BOOLEAN COMMENT 'Indicates whether substances in this IMDG class are classified as marine pollutants under MARPOL Annex III. True if the class typically contains marine pollutants requiring special marking and documentation.',
    `marpol_annex_reference` STRING COMMENT 'Reference to the applicable MARPOL annex for pollution prevention related to this IMDG class (e.g., Annex I - Oil, Annex II - Noxious Liquid Substances, Annex III - Harmful Substances in Packaged Form). Used for environmental compliance and spill response planning.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this IMDG classification record was last modified. Used for audit trail and change tracking.',
    `notes` STRING COMMENT 'Free-text notes or additional guidance related to this IMDG class. May include port-specific handling instructions, local regulatory variations, or clarifications for operational staff.',
    `packing_group` STRING COMMENT 'Packing group classification (I, II, or III) indicating the degree of danger: I = high danger, II = medium danger, III = low danger. Used to determine packaging specifications and handling requirements.. Valid values are `I|II|III`',
    `segregation_group_code` STRING COMMENT 'Segregation group code assigned to this IMDG class for stowage and segregation purposes (e.g., acids, alkalis, ammonium compounds). Used to determine compatibility and separation requirements in vessel stowage planning and yard block allocation.',
    `segregation_table_reference` STRING COMMENT 'Reference to the segregation table in the IMDG Code specifying separation requirements (e.g., away from, separated from, separated by a complete compartment or hold from). Defines minimum physical separation distances for safe stowage.',
    `solas_regulation_reference` STRING COMMENT 'Reference to the applicable SOLAS Chapter VII regulation governing the carriage of this dangerous goods class by sea (e.g., SOLAS Ch.VII Part A, SOLAS Ch.VII Part B). SOLAS Chapter VII addresses the carriage of dangerous goods in packaged form or in solid form in bulk.',
    `special_provisions` STRING COMMENT 'Comma-separated list of special provision codes applicable to this IMDG class (e.g., SP23, SP172, SP274). Special provisions modify or supplement the general requirements for specific substances or articles within the class.',
    `stowage_category` STRING COMMENT 'Stowage category code (A, B, C, D, or E) defining where this IMDG class may be stowed on a vessel. Category A = on deck or under deck; B = on deck or under deck with specific conditions; C = on deck only; D = on deck only with specific conditions; E = prohibited from carriage. Used in BAPLIE stowage planning.. Valid values are `A|B|C|D|E`',
    `un_number_range_end` STRING COMMENT 'Ending UN number in the range typically associated with this IMDG class. Defines the upper bound of UN numbers commonly classified under this hazard class.',
    `un_number_range_start` STRING COMMENT 'Starting UN number in the range typically associated with this IMDG class. UN numbers are four-digit identifiers assigned to hazardous substances and articles by the United Nations Committee of Experts on the Transport of Dangerous Goods.',
    `valid_from` DATE COMMENT 'Effective start date for this IMDG classification record. Used to manage amendment transitions and ensure the correct classification rules are applied based on the cargo acceptance or vessel departure date.',
    `valid_to` DATE COMMENT 'Effective end date for this IMDG classification record. Nullable for current/active classifications. Used to manage historical records when IMDG Code amendments supersede or modify classifications.',
    CONSTRAINT pk_imdg_class PRIMARY KEY(`imdg_class_id`)
) COMMENT 'Reference master for IMDG (International Maritime Dangerous Goods) hazard classifications as defined by the IMO IMDG Code. Captures IMDG class number (1–9), division (e.g., 2.1 flammable gas, 3 flammable liquid, 6.1 toxic), UN number range, hazard label type, packing group (I/II/III), segregation group code, segregation table references (away from, separated from), EmS (Emergency Schedule) fire/spillage codes, special provisions, applicable SOLAS Ch.VII regulation, and IMDG Code amendment cycle reference with effectivity dates (valid_from/valid_to) for amendment transitions. Data steward: Safety & Compliance. SSOT for dangerous goods classification used in BAPLIE stowage planning, gate-in DG acceptance checks, yard block segregation rules, and CUSCAR customs compliance.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` (
    `flag_state_id` BIGINT COMMENT 'Primary key for flag_state',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Flag states are countries that register vessels under their maritime authority. Normalizing to FK allows joining to country for full country data (ISO codes, region, sub-region, trade agreements, curr',
    `active_status` STRING COMMENT 'Current operational status of the flag state in the ports master data system. Active indicates the flag state is recognized and vessels under this flag are accepted; inactive indicates the flag state is no longer recognized; suspended indicates temporary restrictions.. Valid values are `active|inactive|suspended`',
    `authority_contact_email` STRING COMMENT 'Primary email address for contacting the flag state maritime authority for official correspondence and inquiries.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `authority_contact_phone` STRING COMMENT 'Primary telephone number for contacting the flag state maritime authority.',
    `authority_name` STRING COMMENT 'Name of the official maritime authority or administration responsible for vessel registration and flag state control in this country.',
    `authority_website_url` STRING COMMENT 'Official website URL of the flag state maritime authority for accessing regulations, forms, and public information.',
    `flag_state_code` STRING COMMENT 'Two-letter ISO 3166-1 alpha-2 country code representing the flag state under which vessels are registered. This is the primary business identifier for the flag state.. Valid values are `^[A-Z]{2}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this flag state record was first created in the system.',
    `effective_from_date` DATE COMMENT 'Date from which this flag state record is effective and valid for use in operational systems.',
    `effective_to_date` DATE COMMENT 'Date until which this flag state record is effective. Null indicates the record is currently active with no planned end date.',
    `flag_of_convenience` BOOLEAN COMMENT 'Indicates whether the flag state is commonly recognized as a flag of convenience, where vessel registration requirements are less stringent and often used for tax or regulatory advantages.',
    `imo_member_since_date` DATE COMMENT 'Date when the flag state became a member of the International Maritime Organization (IMO). Null if not a member.',
    `imo_member_status` STRING COMMENT 'Membership status of the flag state in the International Maritime Organization (IMO). Indicates whether the flag state is a full member, associate member, or non-member.. Valid values are `member|associate_member|non_member`',
    `indian_ocean_mou_member` BOOLEAN COMMENT 'Indicates whether the flag state is a member of the Indian Ocean MOU on Port State Control.',
    `isps_code_compliant` BOOLEAN COMMENT 'Indicates whether the flag state is compliant with the International Ship and Port Facility Security (ISPS) Code, which prescribes responsibilities for governments, shipping companies, and ship and port personnel to detect and deter security threats.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this flag state record was last modified or updated.',
    `marpol_ratification_date` DATE COMMENT 'Date when the flag state ratified the MARPOL Convention. Null if not ratified.',
    `marpol_ratified` BOOLEAN COMMENT 'Indicates whether the flag state has ratified the International Convention for the Prevention of Pollution from Ships (MARPOL).',
    `mlc_ratification_date` DATE COMMENT 'Date when the flag state ratified the Maritime Labour Convention. Null if not ratified.',
    `mlc_ratified` BOOLEAN COMMENT 'Indicates whether the flag state has ratified the Maritime Labour Convention (MLC) 2006, which sets out seafarers rights to decent working conditions.',
    `flag_state_name` STRING COMMENT 'Full official name of the flag state country as recognized under international maritime law.',
    `notes` STRING COMMENT 'Free-text field for capturing additional information, special considerations, or operational notes related to the flag state.',
    `paris_mou_member` BOOLEAN COMMENT 'Indicates whether the flag state is a member of the Paris MOU on Port State Control, covering European and North Atlantic regions.',
    `psc_list_classification` STRING COMMENT 'Classification of the flag state on Port State Control (PSC) performance lists. White list indicates high performance, grey list medium performance, black list poor performance, and not classified indicates no formal classification.. Valid values are `white_list|grey_list|black_list|not_classified`',
    `psc_targeting_factor` DECIMAL(18,2) COMMENT 'Numerical targeting factor used by Port State Control (PSC) authorities to determine inspection priority for vessels flying this flag. Higher values indicate higher inspection priority due to poor performance history.',
    `recognized_organization_authorized` BOOLEAN COMMENT 'Indicates whether the flag state authorizes Recognized Organizations (classification societies) to carry out statutory surveys and certification on its behalf.',
    `registry_type` STRING COMMENT 'Classification of the flag state registry. National registries require vessel ownership by nationals; open registries (flags of convenience) allow foreign ownership; international registries are hybrid models.. Valid values are `national|open|international`',
    `risk_rating` STRING COMMENT 'Internal risk assessment rating assigned to the flag state based on PSC performance, compliance history, and safety record. Used for prioritizing inspections and resource allocation.. Valid values are `low|medium|high|very_high`',
    `solas_ratification_date` DATE COMMENT 'Date when the flag state ratified the SOLAS Convention. Null if not ratified.',
    `solas_ratified` BOOLEAN COMMENT 'Indicates whether the flag state has ratified the International Convention for the Safety of Life at Sea (SOLAS).',
    `stcw_ratification_date` DATE COMMENT 'Date when the flag state ratified the STCW Convention. Null if not ratified.',
    `stcw_ratified` BOOLEAN COMMENT 'Indicates whether the flag state has ratified the International Convention on Standards of Training, Certification and Watchkeeping for Seafarers (STCW).',
    `tokyo_mou_member` BOOLEAN COMMENT 'Indicates whether the flag state is a member of the Tokyo MOU on Port State Control, covering Asia-Pacific region.',
    `total_registered_dwt` DECIMAL(18,2) COMMENT 'Total Deadweight Tonnage (DWT) of all vessels registered under this flag state. Represents the total cargo-carrying capacity of the fleet.',
    `total_registered_grt` DECIMAL(18,2) COMMENT 'Total Gross Registered Tonnage (GRT) of all vessels registered under this flag state. Used for assessing the overall size and capacity of the flag states fleet.',
    `total_registered_vessels` STRING COMMENT 'Total number of vessels currently registered under this flag state. This is a snapshot metric used for fleet size analysis and port planning.',
    CONSTRAINT pk_flag_state PRIMARY KEY(`flag_state_id`)
) COMMENT 'Reference master for all flag states (countries of vessel registration) recognised under international maritime law. Captures flag state code (ISO 3166-1 alpha-2), flag state name, IMO member status, Paris MOU/Tokyo MOU/Indian Ocean MOU membership, PSC (Port State Control) targeting factor, grey/black/white list classification, flag state authority contact, and applicable maritime conventions ratified (SOLAS, MARPOL, MLC). Used in vessel master, PSC inspection, and compliance domains.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` (
    `shipping_line_id` BIGINT COMMENT 'Primary key for shipping_line',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: shipping_line has registered_country_code (STRING) which should reference country master. Adding country_id FK normalizes the country reference and removes the denormalized code. Country table contain',
    `un_locode_id` BIGINT COMMENT 'Foreign key linking to masterdata.un_locode. Business justification: shipping_line.headquarters_city is a free-text STRING that stores the city of the carriers registered headquarters. Replacing it with a FK to un_locode.un_locode_id normalizes the headquarters locati',
    `port_community_participant_id` BIGINT COMMENT 'Unique identifier for the carrier in the ports EDI messaging system. Used for automated exchange of BAPLIE (stowage plans), COPARN (container pre-advice), IFTMIN (transport instructions), and other UN/EDIFACT messages.',
    `alliance_membership` STRING COMMENT 'Strategic alliance or consortium membership of the carrier. Major alliances include 2M (Maersk/MSC), THE Alliance (Hapag-Lloyd/ONE/Yang Ming/HMM), Ocean Alliance (CMA CGM/COSCO/OOCL/Evergreen). Independent carriers operate outside alliances. Impacts slot-sharing agreements and vessel scheduling coordination.. Valid values are `2M|THE Alliance|Ocean Alliance|Independent|Other`',
    `api_integration_enabled_flag` BOOLEAN COMMENT 'Indicates whether the carrier has active REST/SOAP API integration with the ports Terminal Operating System (TOS) for real-time data exchange beyond traditional EDI.',
    `average_teu_per_call` DECIMAL(18,2) COMMENT 'Rolling 12-month average container volume in TEU handled per vessel call for this carrier. Used for yard planning and equipment allocation.',
    `average_vessel_calls_per_month` DECIMAL(18,2) COMMENT 'Rolling 12-month average number of vessel calls made by this carrier at the port per month. Used for berth capacity planning and commercial forecasting.',
    `bic_operator_code` STRING COMMENT 'Three-letter carrier prefix followed by U (for container owner) as defined in ISO 6346. Used to identify container ownership and operator in global container tracking systems.. Valid values are `^[A-Z]{3}[U]$`',
    `carrier_name` STRING COMMENT 'Full legal registered name of the shipping line or ocean carrier as it appears on commercial contracts and vessel registration documents.',
    `carrier_short_name` STRING COMMENT 'Abbreviated or trade name of the shipping line commonly used in operational communications, vessel schedules, and port documentation.',
    `commercial_account_reference` STRING COMMENT 'Internal account identifier linking this shipping line to the commercial billing and tariff management system. Used for invoice generation, credit management, and revenue tracking.',
    `credit_rating` STRING COMMENT 'External credit rating assigned by recognized rating agencies (Moodys, S&P, Fitch) reflecting the carriers financial stability and creditworthiness. Used for credit limit determination and payment term negotiation. [ENUM-REF-CANDIDATE: AAA|AA|A|BBB|BB|B|CCC|CC|C|D|Not Rated — 11 candidates stripped; promote to reference product]',
    `customs_broker_reference` STRING COMMENT 'Identifier of the preferred customs broker or clearance agent used by the carrier for import/export documentation and customs clearance at this port.',
    `dangerous_goods_approved_flag` BOOLEAN COMMENT 'Indicates whether the carrier is approved and certified to handle IMDG (International Maritime Dangerous Goods) cargo at this port. Requires specific documentation, training, and compliance with IMDG Code.',
    `data_steward` STRING COMMENT 'Business unit responsible for maintaining and validating the accuracy of this shipping line master record. Commercial: handles tariff and contract data. Marine Operations: handles vessel scheduling and operational data. Both: shared responsibility.. Valid values are `Commercial|Marine Operations|Both`',
    `edi_enabled_flag` BOOLEAN COMMENT 'Indicates whether the carrier has active EDI integration with the port for automated message exchange. True: EDI active. False: manual/email-based communication.',
    `fleet_size_category` STRING COMMENT 'Classification of the carrier based on global fleet capacity measured in TEU. Mega Carrier: >1M TEU. Major Carrier: 500K-1M TEU. Regional Carrier: 100K-500K TEU. Niche Carrier: 10K-100K TEU. Feeder Operator: <10K TEU. Used for berth allocation priority and commercial negotiation.. Valid values are `Mega Carrier|Major Carrier|Regional Carrier|Niche Carrier|Feeder Operator`',
    `iso_certification_status` STRING COMMENT 'Highest level of ISO certification held by the carrier. ISO 9001: Quality Management. ISO 14001: Environmental Management. ISO 28000: Supply Chain Security. Multiple: holds more than one certification. Used for vendor assessment and partnership evaluation.. Valid values are `ISO 9001|ISO 14001|ISO 28000|Multiple|None`',
    `isps_compliant_flag` BOOLEAN COMMENT 'Indicates whether the carrier maintains valid ISPS certification and compliance for all vessels calling at the port. Required for international vessel operations per SOLAS Chapter XI-2.',
    `last_audit_date` DATE COMMENT 'Date when this shipping line master record was last reviewed and validated for accuracy by the data steward. Used for data quality monitoring and compliance.',
    `operational_status` STRING COMMENT 'Current operational state of the shipping line at this port. Active: currently operating vessel calls. Suspended: temporarily not calling at port. Ceased: permanently discontinued operations. Merged/Acquired: absorbed into another carrier entity.. Valid values are `Active|Suspended|Ceased|Merged|Acquired`',
    `payment_terms_days` STRING COMMENT 'Standard number of days allowed for payment of port charges and terminal handling charges (THC) after invoice date. Typical values: 0 (prepaid), 7, 14, 30, 45, 60 days.',
    `preferred_berth_window_hours` STRING COMMENT 'Preferred advance notice window in hours between ETB (Estimated Time of Berthing) and vessel arrival that the carrier requests for berth allocation planning. Used by berth planning system to optimize scheduling.',
    `primary_contact_email` STRING COMMENT 'Email address of the primary contact for operational communications, vessel scheduling, and commercial matters.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `primary_contact_name` STRING COMMENT 'Full name of the principal commercial or operations contact person at the shipping line for port coordination and service matters.',
    `primary_contact_phone` STRING COMMENT 'Direct telephone number of the primary contact including country and area codes for urgent operational coordination.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this shipping line master record was first created in the system.',
    `record_updated_by` STRING COMMENT 'User identifier or system process name that last modified this shipping line master record. Used for audit trail and data lineage.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this shipping line master record was last modified. Updated on any field change.',
    `reefer_capable_flag` BOOLEAN COMMENT 'Indicates whether the carrier operates reefer-capable vessels and handles refrigerated cargo at this port. Impacts berth allocation to reefer-equipped berths.',
    `scac_code` STRING COMMENT 'Four-letter unique identifier assigned by the National Motor Freight Traffic Association (NMFTA) to identify ocean carriers in EDI transactions and shipping documentation. Required for all US-bound cargo per CBP regulations.. Valid values are `^[A-Z]{4}$`',
    `service_commencement_date` DATE COMMENT 'Date when the shipping line first commenced vessel operations at this port facility.',
    `service_termination_date` DATE COMMENT 'Date when the shipping line ceased or suspended vessel operations at this port. Null for active carriers.',
    `service_type` STRING COMMENT 'Primary type of shipping service the carrier provides at this port. Mainline: direct long-haul international routes. Feeder: short-sea distribution services. Transshipment Hub: hub-and-spoke operations. Regional: intra-regional services. Specialized: project cargo, heavy lift, or niche services.. Valid values are `Mainline|Feeder|Transshipment Hub|Regional|Specialized`',
    `tariff_group_code` STRING COMMENT 'Internal code linking the carrier to a specific tariff schedule for port charges, THC (Terminal Handling Charges), wharfage, and other fees. Carriers in the same group receive identical pricing.',
    `total_fleet_teu_capacity` STRING COMMENT 'Total container capacity of the carriers global fleet measured in TEU. Used for commercial assessment and berth planning.',
    `vessel_count` STRING COMMENT 'Total number of vessels (owned and chartered) in the carriers operating fleet. Includes container ships, RoRo vessels, and specialized cargo vessels.',
    `vgm_compliance_method` STRING COMMENT 'Preferred method for VGM verification per SOLAS Chapter VI Regulation 2. Method 1: weighing the packed container. Method 2: weighing all contents and adding tare weight. Both: carrier accepts either method. Required for all export containers since July 2016.. Valid values are `Method 1|Method 2|Both|Not Applicable`',
    `website_url` STRING COMMENT 'Official corporate website URL of the shipping line for reference and public information access.',
    CONSTRAINT pk_shipping_line PRIMARY KEY(`shipping_line_id`)
) COMMENT 'Master record for all shipping lines (ocean carriers) operating vessel calls at the port. Captures SCAC code (Standard Carrier Alpha Code), BIC operator code (per ISO 6346), carrier name, alliance membership (2M, THE Alliance, Ocean Alliance, or independent), registered country (FK to country), principal contact, EDI partner reference (FK to edi_partner), preferred berth window, commercial account reference, fleet size indicator, and operational status (active/suspended/ceased). Data steward: Commercial / Marine Operations. Distinct from the broader port_community_participant in the customer domain — this is the operational SSOT for carrier identity used in vessel scheduling, BAPLIE stowage plans, BOL processing, tariff application, and alliance slot-sharing agreements.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ADD CONSTRAINT `fk_masterdata_vessel_master_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ADD CONSTRAINT `fk_masterdata_vessel_master_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ADD CONSTRAINT `fk_masterdata_vessel_master_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ADD CONSTRAINT `fk_masterdata_vessel_master_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ADD CONSTRAINT `fk_masterdata_vessel_type_parent_vessel_type_id` FOREIGN KEY (`parent_vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ADD CONSTRAINT `fk_masterdata_port_location_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ADD CONSTRAINT `fk_masterdata_un_locode_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ADD CONSTRAINT `fk_masterdata_commodity_code_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ADD CONSTRAINT `fk_masterdata_commodity_code_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ADD CONSTRAINT `fk_masterdata_imdg_class_parent_imdg_class_id` FOREIGN KEY (`parent_imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ADD CONSTRAINT `fk_masterdata_flag_state_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ADD CONSTRAINT `fk_masterdata_shipping_line_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ADD CONSTRAINT `fk_masterdata_shipping_line_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`masterdata` SET TAGS ('dbx_division' = 'corporate');
ALTER SCHEMA `vibe_shipping_ports_v1`.`masterdata` SET TAGS ('dbx_domain' = 'masterdata');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` SET TAGS ('dbx_subdomain' = 'maritime_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `flag_state_id` SET TAGS ('dbx_business_glossary_term' = 'Flag State Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Of Registry Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `beam_meters` SET TAGS ('dbx_business_glossary_term' = 'Beam Width in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `builder_name` SET TAGS ('dbx_business_glossary_term' = 'Shipbuilder Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `call_sign` SET TAGS ('dbx_business_glossary_term' = 'Radio Call Sign');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `classification_society_code` SET TAGS ('dbx_business_glossary_term' = 'Classification Society Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `data_steward` SET TAGS ('dbx_business_glossary_term' = 'Data Steward');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `engine_type` SET TAGS ('dbx_business_glossary_term' = 'Main Engine Type');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `feu_capacity` SET TAGS ('dbx_business_glossary_term' = 'Forty-foot Equivalent Unit (FEU) Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `grt` SET TAGS ('dbx_business_glossary_term' = 'Gross Registered Tonnage (GRT)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `hull_number` SET TAGS ('dbx_business_glossary_term' = 'Hull Number');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `ice_class` SET TAGS ('dbx_business_glossary_term' = 'Ice Class Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `imo_number` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `imo_number` SET TAGS ('dbx_value_regex' = '^[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `is_current_record` SET TAGS ('dbx_business_glossary_term' = 'Is Current Record Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `isps_compliant` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Compliant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `issc_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'International Ship Security Certificate (ISSC) Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `last_psc_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Port State Control (PSC) Inspection Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `lloyds_list_intelligence_reference` SET TAGS ('dbx_business_glossary_term' = 'Lloyds List Intelligence Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `loa_meters` SET TAGS ('dbx_business_glossary_term' = 'Length Overall (LOA) in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `marpol_compliant` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollution (MARPOL) Compliant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `maximum_draft_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Draft in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `mmsi` SET TAGS ('dbx_business_glossary_term' = 'Maritime Mobile Service Identity (MMSI)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `mmsi` SET TAGS ('dbx_value_regex' = '^[0-9]{9}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `nrt` SET TAGS ('dbx_business_glossary_term' = 'Net Registered Tonnage (NRT)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'active|laid_up|scrapped|under_construction|detained');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `pi_club_code` SET TAGS ('dbx_business_glossary_term' = 'Protection and Indemnity (P&I) Club Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `propulsion_power_kw` SET TAGS ('dbx_business_glossary_term' = 'Propulsion Power in Kilowatts (kW)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `psc_deficiency_count` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Deficiency Count');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `registered_owner` SET TAGS ('dbx_business_glossary_term' = 'Registered Owner Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `solas_compliant` SET TAGS ('dbx_business_glossary_term' = 'Safety of Life at Sea (SOLAS) Compliant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `summer_dwt` SET TAGS ('dbx_business_glossary_term' = 'Summer Deadweight Tonnage (DWT)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `teu_capacity` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `vessel_name` SET TAGS ('dbx_business_glossary_term' = 'Vessel Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_master` ALTER COLUMN `year_built` SET TAGS ('dbx_business_glossary_term' = 'Year Built');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` SET TAGS ('dbx_subdomain' = 'maritime_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `vessel_type_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `berth_compatibility_flag` SET TAGS ('dbx_business_glossary_term' = 'Berth Compatibility Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `cargo_handling_method` SET TAGS ('dbx_business_glossary_term' = 'Cargo Handling Method');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `cargo_handling_method` SET TAGS ('dbx_value_regex' = 'lolo|roro|bulk|liquid|mixed|none');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `vessel_type_code` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `vessel_type_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `dangerous_goods_capable` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Capable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `data_steward` SET TAGS ('dbx_business_glossary_term' = 'Data Steward');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `vessel_type_description` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Description');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `environmental_category` SET TAGS ('dbx_business_glossary_term' = 'Environmental Category');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `environmental_category` SET TAGS ('dbx_value_regex' = 'green|standard|high_emission|specialized');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `imo_vessel_type_code` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Vessel Type Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `imo_vessel_type_code` SET TAGS ('dbx_value_regex' = '^[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `marpol_annex_reference` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollution (MARPOL) Annex Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `mobile_crane_compatible` SET TAGS ('dbx_business_glossary_term' = 'Mobile Harbour Crane (MHC) Compatible Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `mobile_crane_compatible` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `mobile_crane_compatible` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `vessel_type_name` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `navis_vessel_category_code` SET TAGS ('dbx_business_glossary_term' = 'NAVIS Vessel Category Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `navis_vessel_category_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `priority_ranking` SET TAGS ('dbx_business_glossary_term' = 'Priority Ranking');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `requires_pilotage` SET TAGS ('dbx_business_glossary_term' = 'Requires Pilotage Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `requires_towage` SET TAGS ('dbx_business_glossary_term' = 'Requires Towage Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `solas_chapter_reference` SET TAGS ('dbx_business_glossary_term' = 'Safety of Life at Sea (SOLAS) Chapter Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `sts_crane_compatible` SET TAGS ('dbx_business_glossary_term' = 'Ship-to-Shore (STS) Crane Compatible Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `tariff_category_code` SET TAGS ('dbx_business_glossary_term' = 'Tariff Category Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `tariff_category_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `typical_beam_max_m` SET TAGS ('dbx_business_glossary_term' = 'Typical Beam Maximum in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `typical_beam_min_m` SET TAGS ('dbx_business_glossary_term' = 'Typical Beam Minimum in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `typical_draft_max_m` SET TAGS ('dbx_business_glossary_term' = 'Typical Draft Maximum in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `typical_draft_min_m` SET TAGS ('dbx_business_glossary_term' = 'Typical Draft Minimum in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `typical_dwt_max` SET TAGS ('dbx_business_glossary_term' = 'Typical Deadweight Tonnage (DWT) Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `typical_dwt_min` SET TAGS ('dbx_business_glossary_term' = 'Typical Deadweight Tonnage (DWT) Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `typical_grt_max` SET TAGS ('dbx_business_glossary_term' = 'Typical Gross Registered Tonnage (GRT) Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `typical_grt_min` SET TAGS ('dbx_business_glossary_term' = 'Typical Gross Registered Tonnage (GRT) Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `typical_loa_max_m` SET TAGS ('dbx_business_glossary_term' = 'Typical Length Overall (LOA) Maximum in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `typical_loa_min_m` SET TAGS ('dbx_business_glossary_term' = 'Typical Length Overall (LOA) Minimum in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `typical_teu_capacity_max` SET TAGS ('dbx_business_glossary_term' = 'Typical Twenty-foot Equivalent Unit (TEU) Capacity Maximum');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `typical_teu_capacity_min` SET TAGS ('dbx_business_glossary_term' = 'Typical Twenty-foot Equivalent Unit (TEU) Capacity Minimum');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `vessel_category` SET TAGS ('dbx_business_glossary_term' = 'Vessel Category');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `vessel_type_status` SET TAGS ('dbx_business_glossary_term' = 'Vessel Type Status');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `vessel_type_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated|pending');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`vessel_type` ALTER COLUMN `vts_tracking_required` SET TAGS ('dbx_business_glossary_term' = 'Vessel Traffic Service (VTS) Tracking Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` SET TAGS ('dbx_subdomain' = 'cargo_classification');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Container Type Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `container_category` SET TAGS ('dbx_business_glossary_term' = 'Container Category');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `data_steward` SET TAGS ('dbx_business_glossary_term' = 'Data Steward');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `door_configuration` SET TAGS ('dbx_business_glossary_term' = 'Door Configuration');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `door_configuration` SET TAGS ('dbx_value_regex' = 'end-door|side-door|open-top|no-door');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `handling_equipment_type` SET TAGS ('dbx_business_glossary_term' = 'Handling Equipment Type Required');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `height_category` SET TAGS ('dbx_business_glossary_term' = 'Container Height Category');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `height_category` SET TAGS ('dbx_value_regex' = 'standard|high-cube|super-high-cube');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `height_mm` SET TAGS ('dbx_business_glossary_term' = 'Container External Height in Millimeters (mm)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `internal_capacity_cbm` SET TAGS ('dbx_business_glossary_term' = 'Internal Cubic Capacity in Cubic Meters (CBM)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `is_collapsible` SET TAGS ('dbx_business_glossary_term' = 'Is Collapsible Container Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `is_hazmat_approved` SET TAGS ('dbx_business_glossary_term' = 'Is Hazardous Materials (HAZMAT) Approved Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `is_oog_capable` SET TAGS ('dbx_business_glossary_term' = 'Is Out of Gauge (OOG) Capable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `is_reefer` SET TAGS ('dbx_business_glossary_term' = 'Is Reefer Container Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `iso_standard_version` SET TAGS ('dbx_business_glossary_term' = 'International Organization for Standardization (ISO) Standard Version');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `iso_type_code` SET TAGS ('dbx_business_glossary_term' = 'International Organization for Standardization (ISO) 6346 Type Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `iso_type_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `length_mm` SET TAGS ('dbx_business_glossary_term' = 'Container External Length in Millimeters (mm)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `max_gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Gross Weight in Kilograms (kg)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `max_payload_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Payload in Kilograms (kg)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `container_type_name` SET TAGS ('dbx_business_glossary_term' = 'Container Type Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated|restricted');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `reefer_temp_max_celsius` SET TAGS ('dbx_business_glossary_term' = 'Reefer Maximum Temperature in Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `reefer_temp_min_celsius` SET TAGS ('dbx_business_glossary_term' = 'Reefer Minimum Temperature in Celsius');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `size_code` SET TAGS ('dbx_business_glossary_term' = 'Container Size Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `size_code` SET TAGS ('dbx_value_regex' = '20|40|45');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `special_handling_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Handling Instructions');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `stacking_strength_tier` SET TAGS ('dbx_business_glossary_term' = 'Stacking Strength Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `swl_kg` SET TAGS ('dbx_business_glossary_term' = 'Safe Working Load (SWL) in Kilograms (kg)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `tare_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Tare Weight in Kilograms (kg)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `tariff_class_code` SET TAGS ('dbx_business_glossary_term' = 'Tariff Class Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `teu_equivalent` SET TAGS ('dbx_business_glossary_term' = 'Twenty-foot Equivalent Unit (TEU) Equivalent');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `ventilation_setting` SET TAGS ('dbx_business_glossary_term' = 'Ventilation Setting');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `ventilation_setting` SET TAGS ('dbx_value_regex' = 'none|passive|active|controlled-atmosphere');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `width_mm` SET TAGS ('dbx_business_glossary_term' = 'Container External Width in Millimeters (mm)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`container_type` ALTER COLUMN `yard_block_preference` SET TAGS ('dbx_business_glossary_term' = 'Yard Block Preference');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` SET TAGS ('dbx_subdomain' = 'geographic_references');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Port Location Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `un_locode_id` SET TAGS ('dbx_business_glossary_term' = 'Un Locode Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `bollard_spacing_meters` SET TAGS ('dbx_business_glossary_term' = 'Bollard Spacing in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `bollard_swl_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Bollard Safe Working Load (SWL) in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `container_yard_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Container Yard Capacity in Twenty-foot Equivalent Units (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `crane_type` SET TAGS ('dbx_business_glossary_term' = 'Crane Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `crane_type` SET TAGS ('dbx_value_regex' = 'sts|qc|mhc|rtg|asc|none');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `customs_zone_code` SET TAGS ('dbx_business_glossary_term' = 'Customs Zone Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `data_steward` SET TAGS ('dbx_business_glossary_term' = 'Data Steward');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `decommissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Decommissioning Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `environmental_zone` SET TAGS ('dbx_business_glossary_term' = 'Environmental Monitoring Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `fender_energy_absorption_kj` SET TAGS ('dbx_business_glossary_term' = 'Fender Energy Absorption Capacity in Kilojoules (kJ)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `fender_type` SET TAGS ('dbx_business_glossary_term' = 'Fender Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `gate_lane_type` SET TAGS ('dbx_business_glossary_term' = 'Gate Lane Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `gate_lane_type` SET TAGS ('dbx_value_regex' = 'inbound|outbound|bidirectional|inspection');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `icd_linkage_code` SET TAGS ('dbx_business_glossary_term' = 'Inland Container Depot (ICD) Linkage Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Security Level');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `isps_security_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Geographic Latitude (WGS84)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `location_area` SET TAGS ('dbx_business_glossary_term' = 'Location Area');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `location_code` SET TAGS ('dbx_business_glossary_term' = 'Internal Location Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `location_name` SET TAGS ('dbx_business_glossary_term' = 'Location Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `location_point` SET TAGS ('dbx_business_glossary_term' = 'Location Point');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `location_type` SET TAGS ('dbx_business_glossary_term' = 'Location Type Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `location_zone` SET TAGS ('dbx_business_glossary_term' = 'Location Zone');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Geographic Longitude (WGS84)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `maximum_vessel_beam_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Vessel Beam in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `maximum_vessel_dwt_tonnes` SET TAGS ('dbx_business_glossary_term' = 'Maximum Vessel Deadweight Tonnage (DWT) in Tonnes');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `maximum_vessel_loa_meters` SET TAGS ('dbx_business_glossary_term' = 'Maximum Vessel Length Overall (LOA) in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'active|under_maintenance|decommissioned|planned|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `rail_siding_capacity_teu` SET TAGS ('dbx_business_glossary_term' = 'Rail Siding Capacity in Twenty-foot Equivalent Units (TEU)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Operational Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `rfid_enabled` SET TAGS ('dbx_business_glossary_term' = 'Radio Frequency Identification (RFID) Enabled Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `shore_crane_coverage` SET TAGS ('dbx_business_glossary_term' = 'Shore Crane Coverage Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `water_depth_meters` SET TAGS ('dbx_business_glossary_term' = 'Water Depth at Chart Datum (CD) in Meters');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `yard_block_bays` SET TAGS ('dbx_business_glossary_term' = 'Yard Block Number of Bays');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `yard_block_rows` SET TAGS ('dbx_business_glossary_term' = 'Yard Block Number of Rows');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`port_location` ALTER COLUMN `yard_block_tiers` SET TAGS ('dbx_business_glossary_term' = 'Yard Block Number of Tiers');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` SET TAGS ('dbx_subdomain' = 'geographic_references');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `un_locode_id` SET TAGS ('dbx_business_glossary_term' = 'United Nations Location Code (UN/LOCODE) Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `coordinate_precision` SET TAGS ('dbx_business_glossary_term' = 'Coordinate Precision');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `coordinate_precision` SET TAGS ('dbx_value_regex' = 'exact|approximate|unknown');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `date_added` SET TAGS ('dbx_business_glossary_term' = 'Date Added');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `date_last_modified` SET TAGS ('dbx_business_glossary_term' = 'Date Last Modified');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `function_code` SET TAGS ('dbx_business_glossary_term' = 'Function Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `function_code` SET TAGS ('dbx_value_regex' = '^[0-7B-]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `iata_code` SET TAGS ('dbx_business_glossary_term' = 'International Air Transport Association (IATA) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `iata_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `is_airport` SET TAGS ('dbx_business_glossary_term' = 'Is Airport Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `is_border_crossing` SET TAGS ('dbx_business_glossary_term' = 'Is Border Crossing Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `is_fixed_transport_function` SET TAGS ('dbx_business_glossary_term' = 'Is Fixed Transport Function Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `is_iaph_member` SET TAGS ('dbx_business_glossary_term' = 'Is International Association of Ports and Harbors (IAPH) Member Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `is_inland_container_depot` SET TAGS ('dbx_business_glossary_term' = 'Is Inland Container Depot (ICD) Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `is_port` SET TAGS ('dbx_business_glossary_term' = 'Is Port Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `is_postal_exchange` SET TAGS ('dbx_business_glossary_term' = 'Is Postal Exchange Office Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `is_rail_terminal` SET TAGS ('dbx_business_glossary_term' = 'Is Rail Terminal Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `is_road_terminal` SET TAGS ('dbx_business_glossary_term' = 'Is Road Terminal Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `location_name` SET TAGS ('dbx_business_glossary_term' = 'Location Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `location_name_without_diacritics` SET TAGS ('dbx_business_glossary_term' = 'Location Name Without Diacritics');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `locode` SET TAGS ('dbx_business_glossary_term' = 'Location Code (LOCODE)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `locode` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}[A-Z0-9]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `status_code` SET TAGS ('dbx_business_glossary_term' = 'Status Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `subdivision_code` SET TAGS ('dbx_business_glossary_term' = 'Subdivision Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `unece_update_cycle` SET TAGS ('dbx_business_glossary_term' = 'United Nations Economic Commission for Europe (UNECE) Update Cycle');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`un_locode` ALTER COLUMN `unece_update_cycle` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[1-2]$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` SET TAGS ('dbx_subdomain' = 'cargo_classification');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code ID');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `container_type_id` SET TAGS ('dbx_business_glossary_term' = 'Container Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Imdg Class Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `applicable_equipment_types` SET TAGS ('dbx_business_glossary_term' = 'Applicable Equipment Types');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `commodity_code_status` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Status');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `commodity_code_status` SET TAGS ('dbx_value_regex' = 'ACTIVE|INACTIVE|DEPRECATED|PENDING_APPROVAL');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `commodity_description` SET TAGS ('dbx_business_glossary_term' = 'Commodity Description');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `data_steward` SET TAGS ('dbx_business_glossary_term' = 'Data Steward');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `ems_number` SET TAGS ('dbx_business_glossary_term' = 'Emergency Schedule (EMS) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `ems_number` SET TAGS ('dbx_value_regex' = '^F-[A-Z],[S]-[A-Z]$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `excepted_quantity` SET TAGS ('dbx_business_glossary_term' = 'Excepted Quantity Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `export_license_required` SET TAGS ('dbx_business_glossary_term' = 'Export License Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `flash_point_celsius` SET TAGS ('dbx_business_glossary_term' = 'Flash Point (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `fumigation_required` SET TAGS ('dbx_business_glossary_term' = 'Fumigation Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `handling_method` SET TAGS ('dbx_business_glossary_term' = 'Handling Method');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `hs_chapter` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Chapter');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `hs_chapter` SET TAGS ('dbx_value_regex' = '^[0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `hs_code` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `hs_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `hs_heading` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Heading');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `hs_heading` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `hs_revision_year` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Revision Year');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `hs_subheading` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Subheading');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `hs_subheading` SET TAGS ('dbx_value_regex' = '^[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `import_license_required` SET TAGS ('dbx_business_glossary_term' = 'Import License Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `limited_quantity` SET TAGS ('dbx_business_glossary_term' = 'Limited Quantity Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `marine_pollutant` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollutant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `marpol_category` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollution (MARPOL) Category');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `packing_group` SET TAGS ('dbx_business_glossary_term' = 'Packing Group');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `packing_group` SET TAGS ('dbx_value_regex' = 'I|II|III');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `prohibited_goods_flag` SET TAGS ('dbx_business_glossary_term' = 'Prohibited Goods Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `proper_shipping_name` SET TAGS ('dbx_business_glossary_term' = 'Proper Shipping Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `quarantine_required` SET TAGS ('dbx_business_glossary_term' = 'Quarantine Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `segregation_group` SET TAGS ('dbx_business_glossary_term' = 'Segregation Group');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `storage_area_type` SET TAGS ('dbx_business_glossary_term' = 'Storage Area Type');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `tariff_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Tariff Rate Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Temperature Controlled Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `temperature_range_max_celsius` SET TAGS ('dbx_business_glossary_term' = 'Maximum Temperature Range (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `temperature_range_min_celsius` SET TAGS ('dbx_business_glossary_term' = 'Minimum Temperature Range (Celsius)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`commodity_code` ALTER COLUMN `wco_control_flag` SET TAGS ('dbx_business_glossary_term' = 'World Customs Organization (WCO) Control Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` SET TAGS ('dbx_subdomain' = 'geographic_references');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Country Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `calling_code` SET TAGS ('dbx_business_glossary_term' = 'International Calling Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `calling_code` SET TAGS ('dbx_value_regex' = '^+[0-9]{1,4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `data_steward` SET TAGS ('dbx_business_glossary_term' = 'Data Steward');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `fatf_status` SET TAGS ('dbx_business_glossary_term' = 'Financial Action Task Force (FATF) Status');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `fatf_status` SET TAGS ('dbx_value_regex' = 'compliant|monitored|high_risk|not_assessed');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `flag_state_authority_contact` SET TAGS ('dbx_business_glossary_term' = 'Flag State Authority Contact Information');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `flag_state_authority_contact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `flag_state_authority_name` SET TAGS ('dbx_business_glossary_term' = 'Flag State Authority Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `flag_state_indicator` SET TAGS ('dbx_business_glossary_term' = 'Flag State Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `flag_state_performance_list` SET TAGS ('dbx_business_glossary_term' = 'Flag State Performance List Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `flag_state_performance_list` SET TAGS ('dbx_value_regex' = 'white|grey|black');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `imo_member_status` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Member Status');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `imo_member_status` SET TAGS ('dbx_value_regex' = 'member|associate_member|non_member');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `indian_ocean_mou_member` SET TAGS ('dbx_business_glossary_term' = 'Indian Ocean Memorandum of Understanding (MOU) Member');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `iso_alpha_2_code` SET TAGS ('dbx_business_glossary_term' = 'International Organization for Standardization (ISO) 3166-1 Alpha-2 Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `iso_alpha_2_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `iso_alpha_3_code` SET TAGS ('dbx_business_glossary_term' = 'International Organization for Standardization (ISO) 3166-1 Alpha-3 Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `iso_alpha_3_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `iso_numeric_code` SET TAGS ('dbx_business_glossary_term' = 'International Organization for Standardization (ISO) 3166-1 Numeric Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `iso_numeric_code` SET TAGS ('dbx_value_regex' = '^[0-9]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `isps_code_compliant` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Code Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `marpol_ratified` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollution (MARPOL) Convention Ratified');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `mlc_ratified` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Ratified');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `country_name` SET TAGS ('dbx_business_glossary_term' = 'Country Common Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `official_name` SET TAGS ('dbx_business_glossary_term' = 'Country Official Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `paris_mou_member` SET TAGS ('dbx_business_glossary_term' = 'Paris Memorandum of Understanding (MOU) Member');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `psc_targeting_factor` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Targeting Factor');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `record_status` SET TAGS ('dbx_business_glossary_term' = 'Record Status');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `record_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `sanctions_effective_date` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Effective Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `sanctions_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `sanctions_list_flag` SET TAGS ('dbx_business_glossary_term' = 'Sanctions List Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `solas_ratified` SET TAGS ('dbx_business_glossary_term' = 'Safety of Life at Sea (SOLAS) Convention Ratified');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `sub_region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Sub-Region');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `tokyo_mou_member` SET TAGS ('dbx_business_glossary_term' = 'Tokyo Memorandum of Understanding (MOU) Member');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `trade_agreement_codes` SET TAGS ('dbx_business_glossary_term' = 'Trade Agreement Codes');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `un_locode_prefix` SET TAGS ('dbx_business_glossary_term' = 'United Nations Code for Trade and Transport Locations (UN/LOCODE) Prefix');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `un_locode_prefix` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`country` ALTER COLUMN `wco_member` SET TAGS ('dbx_business_glossary_term' = 'World Customs Organization (WCO) Member');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` SET TAGS ('dbx_subdomain' = 'cargo_classification');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `parent_imdg_class_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Imdg Class Id');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `parent_imdg_class_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `class_name` SET TAGS ('dbx_business_glossary_term' = 'IMDG Class Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `class_number` SET TAGS ('dbx_business_glossary_term' = 'IMDG Class Number');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `class_number` SET TAGS ('dbx_value_regex' = '^[1-9](.[0-9])?$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `data_steward` SET TAGS ('dbx_business_glossary_term' = 'Data Steward');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'IMDG Division Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `ems_fire_code` SET TAGS ('dbx_business_glossary_term' = 'Emergency Schedule (EmS) Fire Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `ems_fire_code` SET TAGS ('dbx_value_regex' = '^F-[A-Z]$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `ems_spillage_code` SET TAGS ('dbx_business_glossary_term' = 'Emergency Schedule (EmS) Spillage Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `ems_spillage_code` SET TAGS ('dbx_value_regex' = '^S-[A-Z]$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `excepted_quantity_code` SET TAGS ('dbx_business_glossary_term' = 'Excepted Quantity Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `excepted_quantity_code` SET TAGS ('dbx_value_regex' = 'E0|E1|E2|E3|E4|E5');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `hazard_label_type` SET TAGS ('dbx_business_glossary_term' = 'Hazard Label Type');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `imdg_code_amendment_cycle` SET TAGS ('dbx_business_glossary_term' = 'IMDG Code Amendment Cycle');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `last_verified_date` SET TAGS ('dbx_business_glossary_term' = 'Last Verified Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `limited_quantity_threshold` SET TAGS ('dbx_business_glossary_term' = 'Limited Quantity Threshold');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `marine_pollutant_flag` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollutant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `marpol_annex_reference` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollution (MARPOL) Annex Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Classification Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `packing_group` SET TAGS ('dbx_business_glossary_term' = 'Packing Group');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `packing_group` SET TAGS ('dbx_value_regex' = 'I|II|III');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `segregation_group_code` SET TAGS ('dbx_business_glossary_term' = 'Segregation Group Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `segregation_table_reference` SET TAGS ('dbx_business_glossary_term' = 'Segregation Table Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `solas_regulation_reference` SET TAGS ('dbx_business_glossary_term' = 'Safety of Life at Sea (SOLAS) Regulation Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `special_provisions` SET TAGS ('dbx_business_glossary_term' = 'Special Provisions');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `stowage_category` SET TAGS ('dbx_business_glossary_term' = 'Stowage Category');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `stowage_category` SET TAGS ('dbx_value_regex' = 'A|B|C|D|E');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `un_number_range_end` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number Range End');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `un_number_range_start` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number Range Start');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `valid_from` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`imdg_class` ALTER COLUMN `valid_to` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` SET TAGS ('dbx_subdomain' = 'maritime_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `flag_state_id` SET TAGS ('dbx_business_glossary_term' = 'Flag State Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `active_status` SET TAGS ('dbx_business_glossary_term' = 'Active Status');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `active_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `authority_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Authority Contact Email');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `authority_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `authority_contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `authority_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `authority_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Authority Contact Phone');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `authority_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `authority_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `authority_name` SET TAGS ('dbx_business_glossary_term' = 'Flag State Authority Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `authority_website_url` SET TAGS ('dbx_business_glossary_term' = 'Authority Website Uniform Resource Locator (URL)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `flag_state_code` SET TAGS ('dbx_business_glossary_term' = 'Flag State Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `flag_state_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `flag_of_convenience` SET TAGS ('dbx_business_glossary_term' = 'Flag of Convenience');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `imo_member_since_date` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Member Since Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `imo_member_status` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Member Status');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `imo_member_status` SET TAGS ('dbx_value_regex' = 'member|associate_member|non_member');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `indian_ocean_mou_member` SET TAGS ('dbx_business_glossary_term' = 'Indian Ocean Memorandum of Understanding (MOU) Member');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `isps_code_compliant` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Code Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `marpol_ratification_date` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollution (MARPOL) Ratification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `marpol_ratified` SET TAGS ('dbx_business_glossary_term' = 'Marine Pollution (MARPOL) Convention Ratified');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `mlc_ratification_date` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Ratification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `mlc_ratified` SET TAGS ('dbx_business_glossary_term' = 'Maritime Labour Convention (MLC) Ratified');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `flag_state_name` SET TAGS ('dbx_business_glossary_term' = 'Flag State Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `paris_mou_member` SET TAGS ('dbx_business_glossary_term' = 'Paris Memorandum of Understanding (MOU) Member');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `psc_list_classification` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) List Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `psc_list_classification` SET TAGS ('dbx_value_regex' = 'white_list|grey_list|black_list|not_classified');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `psc_targeting_factor` SET TAGS ('dbx_business_glossary_term' = 'Port State Control (PSC) Targeting Factor');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `recognized_organization_authorized` SET TAGS ('dbx_business_glossary_term' = 'Recognized Organization (RO) Authorized');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `registry_type` SET TAGS ('dbx_business_glossary_term' = 'Registry Type');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `registry_type` SET TAGS ('dbx_value_regex' = 'national|open|international');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Risk Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `risk_rating` SET TAGS ('dbx_value_regex' = 'low|medium|high|very_high');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `solas_ratification_date` SET TAGS ('dbx_business_glossary_term' = 'Safety of Life at Sea (SOLAS) Ratification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `solas_ratified` SET TAGS ('dbx_business_glossary_term' = 'Safety of Life at Sea (SOLAS) Convention Ratified');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `stcw_ratification_date` SET TAGS ('dbx_business_glossary_term' = 'Standards of Training, Certification and Watchkeeping (STCW) Ratification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `stcw_ratified` SET TAGS ('dbx_business_glossary_term' = 'Standards of Training, Certification and Watchkeeping (STCW) Convention Ratified');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `tokyo_mou_member` SET TAGS ('dbx_business_glossary_term' = 'Tokyo Memorandum of Understanding (MOU) Member');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `total_registered_dwt` SET TAGS ('dbx_business_glossary_term' = 'Total Registered Deadweight Tonnage (DWT)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `total_registered_grt` SET TAGS ('dbx_business_glossary_term' = 'Total Registered Gross Registered Tonnage (GRT)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`flag_state` ALTER COLUMN `total_registered_vessels` SET TAGS ('dbx_business_glossary_term' = 'Total Registered Vessels');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` SET TAGS ('dbx_subdomain' = 'maritime_assets');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `shipping_line_id` SET TAGS ('dbx_business_glossary_term' = 'Shipping Line Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `un_locode_id` SET TAGS ('dbx_business_glossary_term' = 'Headquarters Un Locode Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Partner Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `alliance_membership` SET TAGS ('dbx_business_glossary_term' = 'Alliance Membership');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `alliance_membership` SET TAGS ('dbx_value_regex' = '2M|THE Alliance|Ocean Alliance|Independent|Other');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `api_integration_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'API (Application Programming Interface) Integration Enabled Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `average_teu_per_call` SET TAGS ('dbx_business_glossary_term' = 'Average TEU (Twenty-foot Equivalent Unit) Per Call');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `average_vessel_calls_per_month` SET TAGS ('dbx_business_glossary_term' = 'Average Vessel Calls Per Month');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `bic_operator_code` SET TAGS ('dbx_business_glossary_term' = 'Bureau International des Containers (BIC) Operator Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `bic_operator_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}[U]$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Legal Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `carrier_short_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Short Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `commercial_account_reference` SET TAGS ('dbx_business_glossary_term' = 'Commercial Account Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `commercial_account_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `credit_rating` SET TAGS ('dbx_business_glossary_term' = 'Credit Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `credit_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `customs_broker_reference` SET TAGS ('dbx_business_glossary_term' = 'Customs Broker Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `dangerous_goods_approved_flag` SET TAGS ('dbx_business_glossary_term' = 'Dangerous Goods Approved Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `data_steward` SET TAGS ('dbx_business_glossary_term' = 'Data Steward');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `data_steward` SET TAGS ('dbx_value_regex' = 'Commercial|Marine Operations|Both');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `edi_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'EDI (Electronic Data Interchange) Enabled Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `fleet_size_category` SET TAGS ('dbx_business_glossary_term' = 'Fleet Size Category');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `fleet_size_category` SET TAGS ('dbx_value_regex' = 'Mega Carrier|Major Carrier|Regional Carrier|Niche Carrier|Feeder Operator');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `iso_certification_status` SET TAGS ('dbx_business_glossary_term' = 'ISO (International Organization for Standardization) Certification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `iso_certification_status` SET TAGS ('dbx_value_regex' = 'ISO 9001|ISO 14001|ISO 28000|Multiple|None');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `isps_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'ISPS (International Ship and Port Facility Security) Compliant Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Last Audit Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'Active|Suspended|Ceased|Merged|Acquired');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `payment_terms_days` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Days');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `payment_terms_days` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `preferred_berth_window_hours` SET TAGS ('dbx_business_glossary_term' = 'Preferred Berth Window Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Name');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `record_updated_by` SET TAGS ('dbx_business_glossary_term' = 'Record Updated By');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `reefer_capable_flag` SET TAGS ('dbx_business_glossary_term' = 'Reefer (Refrigerated Container) Capable Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `scac_code` SET TAGS ('dbx_business_glossary_term' = 'Standard Carrier Alpha Code (SCAC)');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `scac_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `service_commencement_date` SET TAGS ('dbx_business_glossary_term' = 'Service Commencement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `service_termination_date` SET TAGS ('dbx_business_glossary_term' = 'Service Termination Date');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'Mainline|Feeder|Transshipment Hub|Regional|Specialized');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `tariff_group_code` SET TAGS ('dbx_business_glossary_term' = 'Tariff Group Code');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `tariff_group_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `total_fleet_teu_capacity` SET TAGS ('dbx_business_glossary_term' = 'Total Fleet TEU (Twenty-foot Equivalent Unit) Capacity');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `vessel_count` SET TAGS ('dbx_business_glossary_term' = 'Vessel Count');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `vgm_compliance_method` SET TAGS ('dbx_business_glossary_term' = 'VGM (Verified Gross Mass) Compliance Method');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `vgm_compliance_method` SET TAGS ('dbx_value_regex' = 'Method 1|Method 2|Both|Not Applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'Website URL (Uniform Resource Locator)');
