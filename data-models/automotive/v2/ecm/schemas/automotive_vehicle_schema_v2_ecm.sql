-- Schema for Domain: vehicle | Business:  | Version: v2_ecm
-- Generated on: 2026-07-14 02:32:24

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`vehicle` COMMENT 'SSOT for all vehicle master data across the enterprise. Owns VIN-level vehicle identity, model configurations, trim levels, MY (Model Year) lifecycle from SOP (Start of Production) to EOP (End of Production), powertrain variants (ICE, HEV, PHEV, EV), platform architectures, and ADAS feature sets. Serves as the authoritative reference for every downstream domain that needs to identify or describe a vehicle instance.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` (
    `vin_registry_id` BIGINT COMMENT 'Unique identifier for the VIN registry record. Primary key for the VIN registry data product.',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_configuration. Business justification: Each VIN corresponds to a single vehicle configuration; linking VIN to its configuration eliminates duplicated spec columns.',
    `product_nameplate_id` BIGINT COMMENT 'Foreign key linking to product.nameplate. Business justification: VIN decoding determines nameplate for warranty, recall and regulatory reporting; linking enables automated recall notices per nameplate.',
    `telematics_device_id` BIGINT COMMENT 'The unique identifier of the embedded telematics control unit (TCU) or connectivity module installed in this vehicle. Used for V2X communication and OTA updates.',
    `battery_capacity_kwh` DECIMAL(18,2) COMMENT 'The total energy storage capacity of the high-voltage traction battery in kilowatt-hours. Applicable to HEV, PHEV, BEV, and FCEV vehicles. Null for pure ICE vehicles.',
    `build_date` DATE COMMENT 'The calendar date when the vehicle completed final assembly and rolled off the production line. Captured from Manufacturing Execution System (MES).',
    `check_digit` STRING COMMENT 'The 9th character of the VIN used to validate VIN authenticity through a mathematical algorithm. Required in North American markets. Value is 0-9 or X (representing 10).. Valid values are `^[0-9X]$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this VIN registry record was first created in the enterprise data system. Audit trail for data lineage.',
    `curb_weight_kg` DECIMAL(18,2) COMMENT 'The weight of the vehicle with standard equipment, full fluids, and a full tank of fuel, but without passengers or cargo. Measured in kilograms.',
    `destination_market` STRING COMMENT 'The intended sales and distribution market for this vehicle unit. May differ from homologation market for export vehicles. Three-letter ISO 3166-1 alpha-3 country code.. Valid values are `^[A-Z]{3}$`',
    `emission_standard` STRING COMMENT 'The regulatory emissions certification standard this vehicle complies with (e.g., EPA Tier 3, Euro 6d, China 6, BS VI). Defines allowable pollutant limits.',
    `eop_date` DATE COMMENT 'The planned or actual date when series production ceased for this vehicles model and platform configuration. Null if still in production.',
    `epa_combined_mpg` DECIMAL(18,2) COMMENT 'The EPA-certified combined city/highway fuel economy rating in miles per gallon. Applicable to ICE, HEV, and PHEV vehicles sold in the United States.',
    `fuel_tank_capacity_liters` DECIMAL(18,2) COMMENT 'The total volume capacity of the primary fuel tank in liters. For electric vehicles, this represents the battery capacity equivalent or is null.',
    `gvwr_kg` DECIMAL(18,2) COMMENT 'The maximum allowable total weight of the vehicle including chassis, body, engine, fluids, passengers, and cargo, as certified by the manufacturer. Measured in kilograms.',
    `homologation_market` STRING COMMENT 'The primary regulatory market for which this vehicle was homologated and certified (e.g., USA, DEU, CHN, JPN). Three-letter ISO 3166-1 alpha-3 country code.. Valid values are `^[A-Z]{3}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this VIN registry record was most recently updated. Audit trail for data lineage and change tracking.',
    `line_off_timestamp` TIMESTAMP COMMENT 'The precise date and time when the vehicle exited the final assembly line and passed end-of-line quality inspection. Captured from MES.',
    `model_year_decoded` STRING COMMENT 'The decoded four-digit calendar year representing the model year (e.g., 2023, 2024). Derived from the 10th VIN character.',
    `msrp_currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for the MSRP amount (e.g., USD, EUR, CNY, JPY).. Valid values are `^[A-Z]{3}$`',
    `obd_protocol` STRING COMMENT 'The diagnostic communication protocol standard implemented in this vehicles Electronic Control Units (ECUs) for emissions and diagnostics monitoring.. Valid values are `obd_i|obd_ii|eobd|jobd|can|uds`',
    `plant_code` STRING COMMENT 'The 11th character of the VIN identifying the specific assembly plant where the vehicle was manufactured. Manufacturer-specific encoding.. Valid values are `^[A-HJ-NPR-Z0-9]{1}$`',
    `production_sequence_number` STRING COMMENT 'Characters 12-17 of the VIN representing the sequential production number assigned to this vehicle unit at the assembly plant. Resets annually per plant.. Valid values are `^[0-9]{6}$`',
    `recall_flag` BOOLEAN COMMENT 'Indicates whether this vehicle unit is currently subject to one or more open safety or compliance recalls issued by the manufacturer or regulatory authority.',
    `safety_rating` STRING COMMENT 'The overall safety assessment rating from regulatory crash testing programs (e.g., NHTSA 5-star, Euro NCAP 5-star). Reflects occupant protection performance.',
    `sop_date` DATE COMMENT 'The date when series production began for this vehicles model and platform configuration. Indicates transition from pre-production to volume manufacturing.',
    `telematics_enabled_flag` BOOLEAN COMMENT 'Indicates whether this vehicle is equipped with connected vehicle telematics hardware and has an active data subscription for remote diagnostics, OTA updates, and mobility services.',
    `vds` STRING COMMENT 'Characters 4-9 of the VIN that describe vehicle attributes such as model, body style, engine type, and restraint system. Manufacturer-specific encoding.. Valid values are `^[A-HJ-NPR-Z0-9]{6}$`',
    `vehicle_lifecycle_status` STRING COMMENT 'Current lifecycle stage of this vehicle unit from manufacturing through end-of-life. Tracks the vehicles journey from plant to customer to disposal. [ENUM-REF-CANDIDATE: pre_production|in_production|quality_hold|in_transit|dealer_inventory|retail_sold|in_service|recalled|scrapped|exported|end_of_life — 11 candidates stripped; promote to reference product]',
    `vin` STRING COMMENT 'The 17-character alphanumeric Vehicle Identification Number that uniquely identifies this physical vehicle unit worldwide. Excludes letters I, O, Q to avoid confusion with numbers.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `vis` STRING COMMENT 'Characters 10-17 of the VIN that include model year, plant code, and production sequence number. Uniquely identifies this specific vehicle unit.. Valid values are `^[A-HJ-NPR-Z0-9]{8}$`',
    `warranty_end_date` DATE COMMENT 'The date when the manufacturers base warranty coverage expires for this vehicle unit. Calculated from warranty start date plus warranty duration.',
    `warranty_start_date` DATE COMMENT 'The date when the manufacturers warranty coverage begins for this vehicle unit. Typically the retail delivery date or first registration date.',
    `wltp_combined_consumption` DECIMAL(18,2) COMMENT 'The WLTP-certified combined fuel consumption in liters per 100 kilometers. Applicable to vehicles sold in markets requiring WLTP certification (EU, UK, etc.).',
    `wmi` STRING COMMENT 'The first three characters of the VIN that identify the manufacturer and country of origin. Assigned by SAE International.. Valid values are `^[A-HJ-NPR-Z0-9]{3}$`',
    CONSTRAINT pk_vin_registry PRIMARY KEY(`vin_registry_id`)
) COMMENT 'SSOT for every physical vehicle instance identified by its 17-character VIN per ISO 3779. Captures decoded VIN structure (WMI, VDS, VIS), manufacturing plant code, production sequence number, build date, model year (MY), line-off timestamp, homologation market, and current lifecycle status (pre-production, in-production, in-transit, in-service, end-of-life). This is the enterprise anchor record — the single identity key — that every downstream domain (sales, aftersales, logistics, mobility, finance) references to identify a specific vehicle unit.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`model` (
    `model_id` BIGINT COMMENT 'Unique surrogate key for the vehicle model record.',
    `product_nameplate_id` BIGINT COMMENT 'Foreign key linking to product.nameplate. Business justification: Model-to-nameplate mapping is required for global product catalog, pricing strategy and sales reporting across regions.',
    `platform_id` BIGINT COMMENT 'FK to vehicle.platform',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Required for Program Management report linking each vehicle model to its engineering program for budgeting, target metrics, and compliance.',
    `adas_features` STRING COMMENT 'Comma‑separated list of Advanced Driver Assistance Systems features.',
    `battery_capacity_kwh` DECIMAL(18,2) COMMENT 'Usable energy storage capacity of the battery pack.',
    `body_style` STRING COMMENT 'Physical body configuration of the model. [ENUM-REF-CANDIDATE: sedan|hatchback|crossover|pickup|coupe|convertible|wagon|suv|van|truck — 10 candidates stripped; promote to reference product]',
    `brand_manager_email` STRING COMMENT 'Email address of the brand manager responsible for this model.',
    `brand_name` STRING COMMENT 'Manufacturer brand or marque associated with the model (e.g., Chevrolet, Toyota).',
    `cargo_capacity_liters` DECIMAL(18,2) COMMENT 'Maximum cargo volume.',
    `co2_emissions_g_per_km` DECIMAL(18,2) COMMENT 'Regulated CO₂ emissions per kilometer.',
    `connectivity_features` STRING COMMENT 'Comma‑separated list of telematics and OTA capabilities.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the model record was first created.',
    `curb_weight_kg` DECIMAL(18,2) COMMENT 'Weight of the vehicle with standard equipment, no passengers or cargo.',
    `model_description` STRING COMMENT 'Narrative description of the models positioning and key attributes.',
    `drive_configuration` STRING COMMENT 'Primary drivetrain layout of the model.. Valid values are `fwd|rwd|awd|4wd`',
    `electric_range_miles` DECIMAL(18,2) COMMENT 'EPA‑rated electric driving range.',
    `emissions_standard` STRING COMMENT 'Regulatory emissions standard applicable to the model.. Valid values are `epa|euro6|caeb|none`',
    `end_of_production_model_year` STRING COMMENT 'Model year in which production of the model ends.',
    `engine_code` STRING COMMENT 'Factory‑assigned engine identifier for ICE/HEV models.',
    `eop_date` DATE COMMENT 'Date when production of the model ceased.',
    `fuel_economy_city_mpg` DECIMAL(18,2) COMMENT 'EPA city fuel consumption rating.',
    `fuel_economy_hwy_mpg` DECIMAL(18,2) COMMENT 'EPA highway fuel consumption rating.',
    `fuel_type` STRING COMMENT 'Primary fuel used by the model.. Valid values are `gasoline|diesel|electric|hybrid|plug_in_hybrid`',
    `height_mm` DECIMAL(18,2) COMMENT 'Overall vehicle height.',
    `homologation_status` STRING COMMENT 'Current status of regulatory homologation.. Valid values are `pending|approved|rejected`',
    `launch_model_year` STRING COMMENT 'Model year in which the model entered production (Start of Production).',
    `length_mm` DECIMAL(18,2) COMMENT 'Overall vehicle length.',
    `market_regions` STRING COMMENT 'Comma‑separated list of ISO‑3 country codes where the model is sold.',
    `msrp_usd` DECIMAL(18,2) COMMENT 'Base MSRP in US dollars.',
    `model_name` STRING COMMENT 'Human‑readable name of the vehicle model (e.g., Model 3, F‑150).',
    `ncap_safety_rating` STRING COMMENT 'Euro NCAP safety rating.. Valid values are `5_star|4_star|3_star|2_star|1_star|not_rated`',
    `powertrain_type` STRING COMMENT 'Powertrain architecture category.. Valid values are `ice|hev|phev|ev`',
    `primary_market` STRING COMMENT 'Geographic market where the model is primarily sold. [ENUM-REF-CANDIDATE: north_america|europe|asia|latin_america|middle_east|africa|australia — 7 candidates stripped; promote to reference product]',
    `program_code` STRING COMMENT 'Internal program identifier linking the model to development projects.',
    `safety_standard` STRING COMMENT 'Safety regulatory framework governing the model.. Valid values are `nhtsa|euro_ncap|none`',
    `seating_capacity` STRING COMMENT 'Maximum number of occupants.',
    `segment` STRING COMMENT 'Market segment classification of the model.. Valid values are `sedan|suv|pickup|van|coupe|convertible`',
    `sop_date` DATE COMMENT 'Date when production of the model commenced.',
    `model_status` STRING COMMENT 'Current lifecycle status of the model.. Valid values are `active|inactive|discontinued`',
    `transmission_gears` STRING COMMENT 'Count of forward gears in the transmission.',
    `transmission_type` STRING COMMENT 'Type of drivetrain transmission.. Valid values are `automatic|manual|cvT|dual_clutch`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the model record.',
    `variant_count` STRING COMMENT 'Number of distinct trim/option configurations derived from this model.',
    `vehicle_class` STRING COMMENT 'High‑level classification of the vehicle purpose.. Valid values are `passenger|commercial|luxury|performance|off_road`',
    `wheelbase_mm` DECIMAL(18,2) COMMENT 'Distance between front and rear axles.',
    `width_mm` DECIMAL(18,2) COMMENT 'Overall vehicle width.',
    CONSTRAINT pk_model PRIMARY KEY(`model_id`)
) COMMENT 'Defines the commercial vehicle model (nameplate) as a business entity — e.g., F-150, Camry, Model 3. Captures model name, brand/marque, vehicle segment (sedan, SUV, pickup, commercial), body style, drive configuration (FWD, RWD, AWD, 4WD), primary market, launch MY, EOP MY, and program code. Serves as the top-level classification anchor for all vehicle configurations and trim hierarchies.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_model_year_program` (
    `vehicle_model_year_program_id` BIGINT COMMENT 'Unique identifier for the vehicle_model_year_program data product (auto-inserted pre-linking).',
    `aftersales_model_year_program_id` BIGINT COMMENT 'SSOT reference to product.aftersales_model_year_program (cross-domain duplicate reconciliation; product designated SSOT owner for model_year_program).',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Each model year program belongs to a specific vehicle model; adding model_id FK enables proper hierarchy and eliminates the siloed vehicle_model_year_program table.',
    CONSTRAINT pk_vehicle_model_year_program PRIMARY KEY(`vehicle_model_year_program_id`)
) COMMENT 'Governs the MY (Model Year) lifecycle for each model, from SOP (Start of Production) through EOP (End of Production). Tracks planned SOP date, actual SOP date, planned EOP date, actual EOP date, regulatory MY designation, CAFE compliance year, homologation status per market, and program phase (concept, development, launch, production, wind-down). Links model to its annual production program and drives downstream planning in manufacturing and supply chain.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` (
    `vehicle_trim_level_id` BIGINT COMMENT 'Unique identifier for the vehicle_trim_level data product (auto-inserted pre-linking).',
    `aftersales_trim_level_id` BIGINT COMMENT 'Foreign key linking to product.trim_level. Business justification: Trim level definitions in vehicle data must map to product trim records for pricing, options and market availability.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Trim levels are defined per model; adding model_id FK removes duplicated model attributes and ties trim to its parent model.',
    CONSTRAINT pk_vehicle_trim_level PRIMARY KEY(`vehicle_trim_level_id`)
) COMMENT 'Defines the ordered hierarchy of trim grades within a model-MY combination (e.g., Base, XL, XLT, Lariat, Platinum, Limited). Captures trim code, trim name, market positioning tier, MSRP base price, standard feature set description, target market region, and active/inactive status. Trim levels are the primary commercial differentiation unit used in sales, dealer ordering, and MSRP pricing.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` (
    `powertrain_variant_id` BIGINT COMMENT 'Unique surrogate key for each powertrain variant record.',
    `powertrain_config_id` BIGINT COMMENT 'Foreign key linking to vehicle.powertrain_config. Business justification: Engineering change management aligns each powertrain variant with its detailed powertrain configuration for compliance and cost tracking.',
    `powertrain_spec_id` BIGINT COMMENT 'Foreign key linking to engineering.powertrain_spec. Business justification: Needed for Powertrain Engineering Spec compliance tracking; each variant must reference the spec defining performance, emissions, and dimensions.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: WARRANTY & REGULATORY: Powertrain variant must be linked to its engine/motor supplier for warranty and emissions compliance.',
    `battery_capacity_kwh` DECIMAL(18,2) COMMENT 'Usable energy storage capacity of the battery pack.',
    `charging_standard` STRING COMMENT 'Supported fast‑charging protocol.. Valid values are `CCS|CHAdeMO|NACS`',
    `co2_emissions_g_per_km` STRING COMMENT 'Tailpipe carbon dioxide emissions per kilometer.',
    `combined_system_power_kw` DECIMAL(18,2) COMMENT 'Total system power (engine + motor) delivered to the drivetrain.',
    `cylinder_count` STRING COMMENT 'Number of cylinders in the internal combustion engine.',
    `powertrain_variant_description` STRING COMMENT 'Free‑form description of the variant, including marketing notes.',
    `drive_type` STRING COMMENT 'Configuration of power delivery to wheels.. Valid values are `FWD|RWD|AWD|4WD`',
    `electric_motor_power_kw` DECIMAL(18,2) COMMENT 'Maximum electric motor output in kilowatts.',
    `end_of_production_date` DATE COMMENT 'Date when the variant ceased production (null if still in production).',
    `engine_displacement_cc` STRING COMMENT 'Engine cylinder volume in cubic centimeters for internal combustion engines.',
    `epa_fuel_economy_combined_mpg` DECIMAL(18,2) COMMENT 'EPA combined fuel economy for regulatory reporting.',
    `epa_range_miles` STRING COMMENT 'EPA certified electric range in miles.',
    `fuel_economy_city_mpg` DECIMAL(18,2) COMMENT 'EPA city fuel economy in miles per gallon.',
    `fuel_economy_combined_mpg` DECIMAL(18,2) COMMENT 'EPA combined city/highway fuel economy in miles per gallon.',
    `fuel_economy_highway_mpg` DECIMAL(18,2) COMMENT 'EPA highway fuel economy in miles per gallon.',
    `fuel_type` STRING COMMENT 'Primary fuel used by the powertrain.. Valid values are `gasoline|diesel|electric|hydrogen|hybrid`',
    `model_year` STRING COMMENT 'Model year associated with the variant.',
    `powertrain_type` STRING COMMENT 'Classification of the powertrain technology.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `powertrain_variant_status` STRING COMMENT 'Current lifecycle status of the variant.. Valid values are `active|inactive|retired|planned`',
    `range_km` STRING COMMENT 'Estimated driving range on a full charge for electric variants.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the record was first created in the system.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the record.',
    `start_of_production_date` DATE COMMENT 'Date when the variant entered series production.',
    `transmission_type` STRING COMMENT 'Type of transmission used with the powertrain.. Valid values are `automatic|manual|CVT|dual_clutch`',
    `variant_code` STRING COMMENT 'Business identifier code used by engineering and manufacturing to reference the variant.',
    `variant_name` STRING COMMENT 'Human‑readable name of the powertrain variant.',
    `vehicle_platform` STRING COMMENT 'Underlying vehicle architecture/platform shared across models.',
    `wltp_fuel_economy_combined_mpg` DECIMAL(18,2) COMMENT 'Combined fuel economy measured under WLTP test cycle.',
    `wltp_range_km` STRING COMMENT 'Estimated driving range under WLTP testing.',
    CONSTRAINT pk_powertrain_variant PRIMARY KEY(`powertrain_variant_id`)
) COMMENT 'Authoritative catalog of all powertrain configurations available across the vehicle lineup. Captures powertrain type (ICE, HEV, PHEV, BEV, FCEV), engine displacement, cylinder count, fuel type, electric motor peak power (kW), combined system power, transmission type, drive type, EPA/WLTP fuel economy or range rating, CO2 emissions (g/km), battery capacity (kWh for EV/PHEV), and charging standard (CCS, CHAdeMO, NACS). Used for homologation, CAFE compliance, and consumer-facing specifications.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`platform` (
    `platform_id` BIGINT COMMENT 'Unique surrogate key for the vehicle platform record.',
    `vehicle_program_id` BIGINT COMMENT 'add column vehicle_program_id (BIGINT) with FK to engineering.vehicle_program.vehicle_program_id - platforms are developed under specific vehicle programs',
    `adaptive_cruise_control` BOOLEAN COMMENT 'True if the platform supports adaptive cruise control as a standard feature.',
    `adas_features` STRING COMMENT 'Pipe‑separated list of Advanced Driver Assistance System features available on the platform. [ENUM-REF-CANDIDATE: lane_keep|blind_spot|auto_brake|traffic_sign_recognition|parking_assist|night_vision|driver_monitor|highway_assist|traffic_jam_assist|remote_parking|collision_warning|pedestrian_detection — promote to reference product]',
    `architecture` STRING COMMENT 'Technical architecture family (e.g., front‑engine, rear‑engine, modular).',
    `platform_code` STRING COMMENT 'External, human‑readable code that uniquely identifies the platform across the enterprise.',
    `compatible_powertrain_families` STRING COMMENT 'Pipe‑separated list of powertrain families that can be mounted on the platform.. Valid values are `ICE|HEV|PHEV|EV|FCEV|Hybrid`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the platform record was first created in the system.',
    `platform_description` STRING COMMENT 'Free‑form textual description of the platforms purpose and key characteristics.',
    `development_cost_usd` DECIMAL(18,2) COMMENT 'Total engineering and tooling cost incurred to develop the platform, expressed in US dollars.',
    `emissions_class` STRING COMMENT 'Regulatory emissions classification applicable to the platform.. Valid values are `Euro6|Euro5|EPA_Tier2|EPA_Tier3|EPA_Tier4`',
    `end_of_production_date` DATE COMMENT 'Date when the platform ceased series production; null if still active.',
    `family` STRING COMMENT 'Family grouping used internally to cluster related platforms.',
    `generation` STRING COMMENT 'Generation identifier indicating the evolutionary version of the platform (e.g., Gen1, Gen2).',
    `height_max_mm` STRING COMMENT 'Longest overall height (mm) that the platform can accommodate.',
    `height_min_mm` STRING COMMENT 'Shortest overall height (mm) that the platform can accommodate.',
    `length_max_mm` STRING COMMENT 'Longest overall length (mm) that the platform can accommodate.',
    `length_min_mm` STRING COMMENT 'Shortest overall length (mm) that the platform can accommodate.',
    `material_strategy` STRING COMMENT 'Primary structural material approach used for the platform.. Valid values are `steel|aluminum|mixed|composite`',
    `max_gvw_kg` STRING COMMENT 'Maximum allowable gross vehicle weight for vehicles built on this platform, expressed in kilograms.',
    `modular_score` STRING COMMENT 'Numeric rating (1‑10) indicating the degree of modularity and parts commonality.',
    `platform_name` STRING COMMENT 'Descriptive name of the platform used in engineering and marketing materials.',
    `ota_capability` BOOLEAN COMMENT 'Indicates whether vehicles on this platform support OTA software updates.',
    `owner_business_unit` STRING COMMENT 'Organizational unit responsible for the platforms development and lifecycle management.',
    `platform_status` STRING COMMENT 'Current lifecycle status of the platform.. Valid values are `active|inactive|planned|retired`',
    `platform_type` STRING COMMENT 'High‑level classification such as unibody or body‑on‑frame.',
    `regulatory_compliance` STRING COMMENT 'Textual statement summarizing compliance with NHTSA, EPA, IATF 16949, and other applicable standards.',
    `release_year` STRING COMMENT 'Calendar year when the platform was first released for production.',
    `start_of_production_date` DATE COMMENT 'Date when the platform entered series production.',
    `track_width_max_mm` STRING COMMENT 'Longest track width (in millimetres) accommodated by the platform.',
    `track_width_min_mm` STRING COMMENT 'Shortest track width (in millimetres) accommodated by the platform.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the platform record.',
    `version` STRING COMMENT 'Version identifier for engineering revisions of the platform.',
    `weight_kg` STRING COMMENT 'Typical curb weight of the platform without powertrain or body equipment, in kilograms.',
    `wheelbase_max_mm` STRING COMMENT 'Longest wheelbase dimension (in millimetres) supported by the platform.',
    `wheelbase_min_mm` STRING COMMENT 'Shortest wheelbase dimension (in millimetres) that a model can be built on this platform.',
    `width_max_mm` STRING COMMENT 'Longest overall width (mm) that the platform can accommodate.',
    `width_min_mm` STRING COMMENT 'Shortest overall width (mm) that the platform can accommodate.',
    CONSTRAINT pk_platform PRIMARY KEY(`platform_id`)
) COMMENT 'Defines the vehicle platform (architecture) that underpins one or more models. Captures platform code, platform name, architecture generation, wheelbase range, track width range, structural material strategy (steel, aluminum, mixed), compatible powertrain families, maximum GVW rating, and platform owner business unit. Platforms are shared across multiple nameplates and model years, making this a critical cross-model reference for engineering, manufacturing, and supply chain.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_adas_feature` (
    `vehicle_adas_feature_id` BIGINT COMMENT 'Unique identifier for the vehicle_adas_feature data product (auto-inserted pre-linking).',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_configuration. Business justification: An ADAS feature is part of a specific vehicle configuration; FK provides context and removes duplicated configuration fields.',
    `engineering_adas_feature_id` BIGINT COMMENT 'add column engineering_adas_feature_id (BIGINT) with FK to engineering.engineering_adas_feature.engineering_adas_feature_id - vehicle ADAS features must reference the engineering feature definition',
    CONSTRAINT pk_vehicle_adas_feature PRIMARY KEY(`vehicle_adas_feature_id`)
) COMMENT 'Catalog of all ADAS (Advanced Driver Assistance Systems) and autonomous driving features offered across the vehicle lineup. Captures feature code, feature name, SAE automation level (L0–L5), sensor dependencies (camera, radar, lidar, ultrasonic), regulatory approval status per market, OTA-updatable flag, ECU host system, software version baseline, and availability by trim/market. Supports homologation, NCAP scoring, and connected mobility feature management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`configuration` (
    `configuration_id` BIGINT COMMENT 'Unique surrogate key for each vehicle configuration record.',
    `aftersales_trim_level_id` BIGINT COMMENT 'FK to product.trim_level',
    `vehicle_body_style_id` BIGINT COMMENT 'FK to product.body_style',
    `change_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_change. Business justification: Configuration traceability to the engineering change that introduced it is required for change impact analysis and audit.',
    `control_plan_id` BIGINT COMMENT 'Foreign key linking to quality.control_plan. Business justification: Each vehicle configuration follows a control plan that defines inspection and test requirements; FK links configuration to its quality control plan.',
    `design_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.design_specification. Business justification: Each vehicle configuration must reference the design specification governing component requirements for compliance and validation.',
    `ecu_catalog_id` BIGINT COMMENT 'Foreign key linking to vehicle.ecu_catalog. Business justification: Vehicle configuration includes a set of ECUs; adding ECU catalog FK provides direct reference.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Configuration approval process mandates an engineer sign‑off; linking to employee enables approval workflow and regulatory audit of engineering responsibility.',
    `model_id` BIGINT COMMENT 'FK to vehicle.model',
    `product_nameplate_id` BIGINT COMMENT 'Foreign key linking to product.nameplate. Business justification: Configuration records are grouped under a nameplate to support global pricing, compliance and reporting across plants.',
    `platform_id` BIGINT COMMENT 'FK to vehicle.platform',
    `powertrain_variant_id` BIGINT COMMENT 'Foreign key linking to vehicle.powertrain_variant. Business justification: Vehicle configuration selects a powertrain variant; FK to powertrain_variant eliminates duplicated variant attributes.',
    `plant_id` BIGINT COMMENT 'Identifier of the manufacturing plant assigned to build the configuration.',
    `adas_features` STRING COMMENT 'Comma-separated list of ADAS features included.. Valid values are `lane_keep|adaptive_cruise|blind_spot|auto_brake|parking_assist|traffic_sign_recognition`',
    `body_style` STRING COMMENT 'Physical body style of the vehicle. [ENUM-REF-CANDIDATE: sedan|hatchback|SUV|truck|coupe|convertible|wagon — 7 candidates stripped; promote to reference product]',
    `build_feasibility_status` STRING COMMENT 'Indicates whether the configuration can be built at the plant.. Valid values are `feasible|non-feasible|pending`',
    `co2_emissions_g_per_km` STRING COMMENT 'Tailpipe CO2 emissions per kilometer.',
    `configuration_code` STRING COMMENT 'Alphanumeric code uniquely identifying the vehicle configuration within the enterprise.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the configuration record was created.',
    `destination_charge` DECIMAL(18,2) COMMENT 'Standard charge for delivery to dealer.',
    `drivetrain` STRING COMMENT 'Drive configuration.. Valid values are `FWD|RWD|AWD|4WD`',
    `emissions_cert_status` STRING COMMENT 'Regulatory emissions certification status.. Valid values are `certified|pending|exempt`',
    `end_of_production_date` DATE COMMENT 'Date when production of this configuration ends.',
    `ev_range_miles` STRING COMMENT 'Estimated electric driving range in miles.',
    `exterior_color` STRING COMMENT 'Standard exterior paint color code.',
    `fuel_economy_city_mpg` DECIMAL(18,2) COMMENT 'City fuel economy in miles per gallon.',
    `fuel_economy_hwy_mpg` DECIMAL(18,2) COMMENT 'Highway fuel economy in miles per gallon.',
    `fuel_type` STRING COMMENT 'Primary fuel used by the powertrain.. Valid values are `gasoline|diesel|electric|hydrogen|hybrid`',
    `interior_material` STRING COMMENT 'Material used for interior trim (e.g., leather, fabric).',
    `market_country_code` STRING COMMENT 'Three-letter ISO country code of the target market.. Valid values are `[A-Z]{3}`',
    `market_region` STRING COMMENT 'Geographic market region for which the configuration is built.. Valid values are `NA|EU|APAC|LATAM|MEA`',
    `model_year` STRING COMMENT 'Calendar year in which the model is marketed.',
    `msrp_amount` DECIMAL(18,2) COMMENT 'Base MSRP before options and destination charges.',
    `optional_package_codes` STRING COMMENT 'Pipe-separated list of optional package identifiers.',
    `record_status` STRING COMMENT 'Current lifecycle status of the configuration record.. Valid values are `active|inactive|archived`',
    `start_of_production_date` DATE COMMENT 'Date when production of this configuration begins.',
    `total_price` DECIMAL(18,2) COMMENT 'Combined MSRP and destination charge.',
    `transmission_type` STRING COMMENT 'Transmission technology.. Valid values are `automatic|manual|CVT|dual-clutch`',
    `trim_level` STRING COMMENT 'Specific trim level designation (e.g., Sport, Luxury).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the configuration record.',
    `vehicle_platform` STRING COMMENT 'Underlying platform architecture shared across models.',
    `warranty_miles` STRING COMMENT 'Maximum mileage covered under the basic warranty.',
    `warranty_years` STRING COMMENT 'Number of years covered under the basic warranty.',
    `wheel_size_inch` STRING COMMENT 'Diameter of wheels in inches.',
    CONSTRAINT pk_configuration PRIMARY KEY(`configuration_id`)
) COMMENT 'The fully specified, buildable vehicle configuration combining model, MY, trim, powertrain, and market. Each record represents a unique orderable specification (analogous to a manufacturing SKU or dealer order code). Captures configuration code, market region, build feasibility status, MSRP, destination charge, fuel economy label values, emissions certification status, and production plant assignment. This is the master configuration record that bridges product planning to manufacturing BOM explosion and dealer order management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` (
    `vehicle_option_package_id` BIGINT COMMENT 'Unique identifier for the vehicle_option_package data product (auto-inserted pre-linking).',
    `aftersales_option_package_id` BIGINT COMMENT 'SSOT reference to product.aftersales_option_package (cross-domain duplicate reconciliation; product designated SSOT owner for option_package).',
    `bom_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_bom. Business justification: Option package definition relies on an engineering BOM that lists parts and quantities; linking enables traceability from package to BOM.',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_configuration. Business justification: Option packages are assigned to specific vehicle configurations; FK creates the relationship.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: INVENTORY & COSTING: Option packages are sourced from specific suppliers; linking supports inventory allocation and cost analysis.',
    CONSTRAINT pk_vehicle_option_package PRIMARY KEY(`vehicle_option_package_id`)
) COMMENT 'Defines factory-installed option packages, standalone options, exterior colors, and interior trim selections available for vehicle configurations. Captures option code, option name, option type (package, standalone, accessory, exterior color, interior trim), MSRP uplift, content description, availability constraints (trim/market/powertrain restrictions), mutually exclusive options, and required prerequisite options. Drives dealer order configuration, window sticker (Monroney label) generation, and BOM explosion in manufacturing.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` (
    `build_spec_id` BIGINT COMMENT 'System-generated unique identifier for the as-built vehicle specification record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Build spec approval is signed off by a designated employee; linking provides audit trail for quality control and change‑management reports.',
    `bom_header_id` BIGINT COMMENT 'Foreign key linking to product.bom_header. Business justification: Production planning uses the build spec to reference the exact BOM header that defines component list and costs.',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_configuration. Business justification: Build spec records represent the as‑built configuration; linking to vehicle_configuration removes duplicated spec attributes.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Required for Build Traceability Report linking each built vehicle to the primary assembly equipment for warranty and quality investigations.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: PRODUCTION SCHEDULING: Build spec ties to the PO that supplies parts, enabling financial reconciliation and line‑balancing.',
    `build_date` DATE COMMENT 'Calendar date the vehicle left the production line.',
    `build_spec_status` STRING COMMENT 'Current operational status of the build specification record.. Valid values are `active|inactive|decommissioned`',
    `co2_emissions_g_per_km` STRING COMMENT 'Measured carbon dioxide emissions per kilometer.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the build specification record was created in the data lake.',
    `diagnostic_trouble_code_initial` STRING COMMENT 'First DTC recorded at the end of production, if any.',
    `emissions_rating` STRING COMMENT 'Regulatory emissions classification applicable to the vehicle.. Valid values are `EPA Tier 1|EPA Tier 2|EPA Tier 3|Euro 6|Euro 7`',
    `fleet_spec_flag` BOOLEAN COMMENT 'True if the vehicle was built to a fleet or corporate specification.',
    `fuel_efficiency_mpg` DECIMAL(18,2) COMMENT 'Manufacturer‑reported fuel economy in miles per gallon (city/highway combined).',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the build specification record.',
    `ncap_rating` STRING COMMENT 'New Car Assessment Programme safety rating.. Valid values are `1-star|2-star|3-star|4-star|5-star`',
    `ota_updatable_flag` BOOLEAN COMMENT 'Indicates whether the vehicle supports over‑the‑air updates.',
    `plant_code` STRING COMMENT 'Identifier of the manufacturing plant where the vehicle was assembled.',
    `production_line` STRING COMMENT 'Specific assembly line or bay within the plant.',
    `regulatory_approval_status` STRING COMMENT 'Current status of regulatory approvals for the vehicle configuration.. Valid values are `approved|pending|rejected`',
    `safety_feature_codes` STRING COMMENT 'Comma‑separated list of safety system identifiers (e.g., ADAS, ESC).',
    `sequence_number` STRING COMMENT 'Sequential number assigned to the vehicle on the production day.',
    `software_version` STRING COMMENT 'Baseline software version loaded on vehicle ECUs at build.',
    `special_order_flag` BOOLEAN COMMENT 'Indicates whether the vehicle was built to a special customer order.',
    `v2x_enabled_flag` BOOLEAN COMMENT 'True if vehicle‑to‑everything communication hardware is installed.',
    `vehicle_weight_kg` DECIMAL(18,2) COMMENT 'Curb weight of the vehicle as built, in kilograms.',
    `vin` STRING COMMENT 'Globally unique 17‑character identifier assigned to each vehicle at manufacture.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `warranty_end_date` DATE COMMENT 'Date when the vehicle warranty period expires.',
    `warranty_mileage_limit` STRING COMMENT 'Maximum mileage covered under the warranty.',
    `warranty_start_date` DATE COMMENT 'Date when the vehicle warranty period begins.',
    CONSTRAINT pk_build_spec PRIMARY KEY(`build_spec_id`)
) COMMENT 'The as-built specification record for a specific VIN, capturing the exact combination of configuration, options, colors, powertrain, and features installed on that vehicle unit as it rolled off the production line. Captures VIN reference, configuration code, exterior color, interior trim selection, all installed option codes, actual build date, plant code, production sequence number, and any deviation from standard specification (e.g., special order, fleet spec, running change). This is the definitive as-built record used by aftersales, warranty, recall population identification, and residual value analytics.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`homologation` (
    `homologation_id` BIGINT COMMENT 'Unique system-generated identifier for each homologation record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Homologation certifications require a compliance officer; FK records the responsible employee for regulatory reporting and traceability.',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_configuration. Business justification: Homologation is tied to a specific vehicle configuration; FK eliminates duplicated regulatory fields.',
    `homologation_requirement_id` BIGINT COMMENT 'Foreign key linking to engineering.homologation_requirement. Business justification: Regulatory compliance audit requires each homologation record to reference the specific requirement it satisfies.',
    `homologation_variant_id` BIGINT COMMENT 'Foreign key linking to compliance.homologation_variant. Business justification: Regulatory filing links each vehicle homologation record to the specific product homologation variant for audit trails.',
    `approval_date` DATE COMMENT 'Date on which the homologation was officially granted.',
    `approval_type` STRING COMMENT 'Indicates whether the approval applies to the entire vehicle or a specific component.. Valid values are `whole_vehicle|component`',
    `authority_name` STRING COMMENT 'Name of the government or standards authority that issued the approval.',
    `homologation_category` STRING COMMENT 'Primary focus of the approval: safety, emissions, or both.. Valid values are `safety|emissions|both`',
    `certificate_number` STRING COMMENT 'Official certificate or approval number assigned by the authority.',
    `certification_status_date` DATE COMMENT 'Date when the compliance status was last updated.',
    `compliance_document_url` STRING COMMENT 'Link to the digital copy of the approval certificate or related documentation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the homologation record was first created in the system.',
    `effective_from` DATE COMMENT 'Date when the homologation becomes effective for production.',
    `effective_until` DATE COMMENT 'Date when the homologation ceases to be effective (if different from expiry).',
    `expiry_date` DATE COMMENT 'Date on which the homologation expires and must be renewed or re‑validated.',
    `is_active` BOOLEAN COMMENT 'True if the homologation is currently active and usable.',
    `is_ota_updatable` BOOLEAN COMMENT 'Indicates whether the approved component can receive Over‑The‑Air updates.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent compliance inspection associated with this homologation.',
    `lifecycle_status` STRING COMMENT 'Overall lifecycle state of the homologation record.. Valid values are `active|inactive|expired|suspended`',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the homologation record.',
    `next_renewal_date` DATE COMMENT 'Planned date for the next renewal or re‑certification of the homologation.',
    `notes` STRING COMMENT 'Additional comments or observations related to the homologation.',
    `record_audit_created` TIMESTAMP COMMENT 'Audit timestamp for when the record was initially loaded.',
    `record_audit_updated` TIMESTAMP COMMENT 'Audit timestamp for the latest modification of the record.',
    `regulatory_framework` STRING COMMENT 'Regulatory regime under which the homologation was granted (e.g., FMVSS, ECE, NCAP, CARB, EPA).. Valid values are `FMVSS|ECE|NCAP|CARB|EPA`',
    `regulatory_version` STRING COMMENT 'Specific version or amendment of the regulatory framework applied (e.g., FMVSS 123‑2022).',
    `scope` STRING COMMENT 'Specifies whether the record represents a whole‑vehicle type approval or a component‑level approval.. Valid values are `type_approval|component_approval`',
    `vehicle_identification_number` STRING COMMENT '17‑character VIN of the vehicle instance covered by the homologation.. Valid values are `[A-HJ-NPR-Z0-9]{17}`',
    CONSTRAINT pk_homologation PRIMARY KEY(`homologation_id`)
) COMMENT 'Tracks the regulatory type-approval and homologation status of vehicle configurations for each target market. Captures homologation type (whole vehicle type approval, component approval), regulatory framework (FMVSS, ECE, NCAP, CARB, EPA), approval authority, certificate number, approval date, expiry date, applicable model/MY/market, emissions standard tier (e.g., EPA Tier 3, Euro 6d), and compliance status. Critical for market launch readiness and regulatory reporting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` (
    `ecu_catalog_id` BIGINT COMMENT 'Unique surrogate key for each ECU catalog entry.',
    `ecu_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.ecu_specification. Business justification: ECU catalog entries must link to their technical specification for validation, OTA updates, and safety certification.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: QUALITY & COMPLIANCE: ECU entries must reference their supplier for traceability, safety certification, and PPAP tracking.',
    `applicable_trim_levels` STRING COMMENT 'Comma‑separated list of trim level identifiers where the ECU is available.',
    `applicable_vehicle_models` STRING COMMENT 'Comma‑separated list of vehicle model codes that can be equipped with this ECU.',
    `communication_protocol` STRING COMMENT 'Primary in‑vehicle communication protocol used by the ECU.. Valid values are `CAN|LIN|Ethernet|AUTOSAR`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the ECU catalog record was first created.',
    `cybersecurity_certification` STRING COMMENT 'Certification identifier (e.g., SAE J3061) confirming the ECU meets cybersecurity requirements.',
    `ecu_catalog_description` STRING COMMENT 'Free‑form description of the ECU, including key capabilities and notes.',
    `ecu_code` STRING COMMENT 'Unique OEM‑assigned code that identifies the ECU across the enterprise.',
    `ecu_function` STRING COMMENT 'Primary functional domain of the ECU (e.g., engine control, transmission control, ADAS, body control, infotainment, OBD gateway).',
    `ecu_name` STRING COMMENT 'Human‑readable name of the electronic control unit.',
    `end_of_life_date` DATE COMMENT 'Planned date after which the ECU will no longer be produced or supported.',
    `functional_safety_asil` STRING COMMENT 'Automotive Safety Integrity Level assigned to the ECU (A‑D).. Valid values are `A|B|C|D`',
    `hardware_part_number` STRING COMMENT 'Manufacturer part number for the ECU hardware module.',
    `is_deprecated` BOOLEAN COMMENT 'Indicates whether the ECU entry is deprecated and should not be used for new vehicle builds.',
    `lifecycle_status` STRING COMMENT 'Current lifecycle state of the ECU within the product portfolio.. Valid values are `active|inactive|retired|pending`',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the ECU catalog record.',
    `ota_updatable_flag` BOOLEAN COMMENT 'Indicates whether the ECU firmware can be updated over‑the‑air.',
    `power_consumption_watts` DECIMAL(18,2) COMMENT 'Typical steady‑state power draw of the ECU in watts.',
    `regulatory_approval_date` DATE COMMENT 'Date on which the ECU received regulatory approval.',
    `regulatory_approval_status` STRING COMMENT 'Current status of regulatory approval for the ECU.. Valid values are `approved|pending|rejected`',
    `software_baseline_version` STRING COMMENT 'Baseline software version shipped with the ECU at start of production.',
    `supplier_name` STRING COMMENT 'Name of the external supplier that provides the ECU hardware.',
    `supplier_part_number` STRING COMMENT 'Supplier‑assigned part number for the ECU hardware.',
    `v2x_communication_enabled` BOOLEAN COMMENT 'True if the ECU supports vehicle‑to‑everything communication.',
    `voltage_volts` DECIMAL(18,2) COMMENT 'Nominal operating voltage supplied to the ECU.',
    `warranty_period_months` STRING COMMENT 'Standard warranty duration provided for the ECU.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Physical weight of the ECU unit.',
    CONSTRAINT pk_ecu_catalog PRIMARY KEY(`ecu_catalog_id`)
) COMMENT 'Catalog of all ECU (Electronic Control Unit) and embedded software modules installed across vehicle configurations. Captures ECU code, ECU name, ECU function (engine control, transmission control, ADAS domain controller, body control, infotainment, OBD gateway), supplier, hardware part number, software baseline version, OTA-updatable flag, communication protocol (CAN, LIN, Ethernet, AUTOSAR), and applicable vehicle configurations. Supports OTA update management, cybersecurity compliance, and aftersales diagnostics.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` (
    `msrp_pricing_id` BIGINT COMMENT 'System-generated unique identifier for each MSRP pricing record.',
    `aftersales_option_package_id` BIGINT COMMENT 'FK to product.option_package',
    `configuration_id` BIGINT COMMENT 'Reference to the vehicle configuration that this MSRP applies to.',
    `model_id` BIGINT COMMENT 'FK to vehicle.model',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the price amount.. Valid values are `[A-Z]{3}`',
    `destination_charge_amount` DECIMAL(18,2) COMMENT 'Standard charge for vehicle delivery to the dealer.',
    `destination_charge_flag` BOOLEAN COMMENT 'Indicates whether a destination charge is included.',
    `effective_end_date` DATE COMMENT 'Date when the MSRP expires or is superseded.',
    `effective_start_date` DATE COMMENT 'Date when the MSRP becomes effective.',
    `ev_tax_credit_amount` DECIMAL(18,2) COMMENT 'Monetary value of the eligible EV tax credit.',
    `ev_tax_credit_eligibility_flag` BOOLEAN COMMENT 'True if the vehicle qualifies for the federal EV tax credit.',
    `gas_guzzler_tax_amount` DECIMAL(18,2) COMMENT 'Additional tax amount for low‑efficiency vehicles, if applicable.',
    `gas_guzzler_tax_flag` BOOLEAN COMMENT 'Indicates whether the gas guzzler tax applies to this configuration.',
    `market_country_code` STRING COMMENT 'Three‑letter ISO country code of the market.. Valid values are `[A-Z]{3}`',
    `market_region` STRING COMMENT 'Geographic sales region for which the MSRP applies.. Valid values are `NA|EU|APAC|LATAM|MEA`',
    `model_year` STRING COMMENT 'Model year for which the MSRP is defined.',
    `msrp_pricing_status` STRING COMMENT 'Current lifecycle status of the MSRP record.. Valid values are `active|inactive|retired|pending`',
    `option_package_code` STRING COMMENT 'Code of the option package associated with the MSRP.',
    `powertrain_type` STRING COMMENT 'Powertrain technology of the vehicle (e.g., ICE, HEV, PHEV, EV).. Valid values are `ICE|HEV|PHEV|EV`',
    `price_amount` DECIMAL(18,2) COMMENT 'Monetary amount for the price component, expressed in the specified currency.',
    `price_key` STRING COMMENT 'Business identifier code for the MSRP entry, unique within market and model.',
    `price_label` STRING COMMENT 'Human‑readable label describing the MSRP entry (e.g., "2024 Model X Base").',
    `price_notes` STRING COMMENT 'Additional remarks or special conditions for the MSRP entry.',
    `price_source_system` STRING COMMENT 'Originating system that supplied the MSRP data.. Valid values are `SAP|PLM|CRM`',
    `price_type` STRING COMMENT 'Classification of the price component (base MSRP, destination charge, tax, total).. Valid values are `base|destination|tax|total`',
    `price_uplift_amount` DECIMAL(18,2) COMMENT 'Monetary increase applied due to selected option packages or market adjustments.',
    `price_uplift_reason` STRING COMMENT 'Explanation for the price uplift (e.g., "Premium Paint", "Advanced Safety Package").',
    `price_version` STRING COMMENT 'Version number of the MSRP record for change tracking.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the MSRP record was first created in the lakehouse.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the MSRP record.',
    `trim_level` STRING COMMENT 'Trim level designation for the vehicle configuration.',
    CONSTRAINT pk_msrp_pricing PRIMARY KEY(`msrp_pricing_id`)
) COMMENT 'Manages the MSRP (Manufacturer Suggested Retail Price) schedule for vehicle configurations, trim levels, and option packages by market and MY. Captures base MSRP, destination and delivery charge, gas guzzler tax (if applicable), federal EV tax credit eligibility, effective date, expiry date, currency, and market region. Provides the authoritative pricing reference for dealer ordering, window sticker generation, and sales analytics. Distinct from dealer invoice pricing (owned by billing domain).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` (
    `lifecycle_event_id` BIGINT COMMENT 'System-generated unique identifier for each vehicle lifecycle event record.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Vehicle lifecycle events occurring at a dealership need a dealership_id FK to attribute service, warranty, and recall actions to the correct dealer.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Required for compliance reports: each lifecycle event must record the employee who logged/handled it, ensuring traceability and auditability.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Vehicle lifecycle events reference a VIN; linking to vin_registry provides a stable surrogate and removes the raw VIN column.',
    `event_category` STRING COMMENT 'High‑level grouping of the event (e.g., production, logistics, sales, post‑sale, disposal). [ENUM-REF-CANDIDATE: production|logistics|sales|post_sale|disposal — promote to reference product]',
    `event_description` STRING COMMENT 'Free‑text narrative describing the event details and context.',
    `event_location_city` STRING COMMENT 'City name where the event was recorded.',
    `event_location_country` STRING COMMENT 'Three‑letter ISO country code where the event took place.. Valid values are `^[A-Z]{3}$`',
    `event_location_latitude` DOUBLE COMMENT 'Geographic latitude of the event location in decimal degrees.',
    `event_location_longitude` DOUBLE COMMENT 'Geographic longitude of the event location in decimal degrees.',
    `event_location_state` STRING COMMENT 'State or province abbreviation for the event location, if applicable.',
    `event_notes` STRING COMMENT 'Additional remarks or internal notes attached to the event.',
    `event_sequence_number` STRING COMMENT 'Sequential order of events for the same VIN, starting at 1.',
    `event_source_module` STRING COMMENT 'Specific module or component within the source system that emitted the event.',
    `event_source_reference` STRING COMMENT 'Unique identifier of the source system instance that emitted the event (e.g., message ID, log ID).',
    `event_source_system` STRING COMMENT 'Higher‑level system or application that originated the event record.',
    `event_status` STRING COMMENT 'Processing status of the event record within the data pipeline.. Valid values are `active|completed|failed`',
    `event_subtype` STRING COMMENT 'More granular classification within the event category.',
    `event_timestamp` TIMESTAMP COMMENT 'Date‑time when the lifecycle event actually occurred.',
    `event_type` STRING COMMENT 'Category of lifecycle transition (e.g., manufactured, pdi_completed, shipped_to_dealer, sold_retail, sold_fleet, exported, titled, re_acquired, scrapped, stolen, total_loss). [ENUM-REF-CANDIDATE: manufactured|pdi_completed|shipped_to_dealer|sold_retail|sold_fleet|exported|titled|re_acquired|scrapped|stolen|total_loss — promote to reference product]',
    `is_critical` BOOLEAN COMMENT 'Indicates whether the event is considered critical for compliance or safety reporting.',
    `odometer_reading_km` BIGINT COMMENT 'Vehicle mileage at the time of the event, expressed in kilometers.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the event record was first inserted into the lakehouse.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the event record.',
    `triggering_system` STRING COMMENT 'Name of the IT/OT system that generated the event (e.g., MES, DMS, Telematics Platform).',
    CONSTRAINT pk_lifecycle_event PRIMARY KEY(`lifecycle_event_id`)
) COMMENT 'Transactional log of significant lifecycle state transitions for a specific VIN throughout its life. Captures event type (manufactured, PDI-completed, shipped-to-dealer, sold-retail, sold-fleet, exported, titled, re-acquired, scrapped, stolen, total-loss), event timestamp, event location, responsible party, odometer reading at event, and triggering system. Provides the complete lifecycle audit trail for a vehicle unit from production to end-of-life, supporting title history, recall tracking, and residual value analytics.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_emissions_certification` (
    `vehicle_emissions_certification_id` BIGINT COMMENT 'Unique identifier for the vehicle_emissions_certification data product (auto-inserted pre-linking).',
    `compliance_emissions_certification_id` BIGINT COMMENT 'add column compliance_emissions_certification_id (BIGINT) with FK to compliance.compliance_emissions_certification.compliance_emissions_certification_id - vehicle emissions certifications must link to the compliance certification record',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.configuration. Business justification: Vehicle emissions certification pertains to a specific vehicle configuration; linking to configuration enables traceability and eliminates redundancy.',
    CONSTRAINT pk_vehicle_emissions_certification PRIMARY KEY(`vehicle_emissions_certification_id`)
) COMMENT 'Stores the official emissions test results and certification records for vehicle configurations submitted to regulatory bodies (EPA, CARB, Euro 6, WLTP). Captures test cycle type (FTP-75, HWFET, WLTP, RDE), CO2 g/km, NOx mg/km, PM mg/km, fuel economy (MPG/L/100km), electric range (km for EV/PHEV), combined CAFE contribution value, certification authority, certificate number, test date, and certification status. Directly supports CAFE compliance reporting and homologation.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` (
    `vehicle_ota_deployment_id` BIGINT COMMENT 'Primary key for the ota_deployment association',
    `mobility_ota_deployment_id` BIGINT COMMENT 'SSOT reference to mobility.mobility_ota_deployment (cross-domain duplicate reconciliation; mobility designated SSOT owner for ota_deployment).',
    `ota_campaign_id` BIGINT COMMENT 'Foreign key linking to the OTA campaign',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to the vehicle VIN registry',
    `consent_given` BOOLEAN COMMENT 'Indicates whether the vehicle owner consented to the OTA update',
    `deployment_initiated_timestamp` TIMESTAMP COMMENT 'Timestamp when the deployment was initiated for this vehicle',
    `download_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the vehicle started downloading the OTA package',
    `install_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the vehicle began installing the OTA package',
    `post_software_version` STRING COMMENT 'Software version after successful OTA update',
    `pre_software_version` STRING COMMENT 'Software version installed on the vehicle before the OTA update',
    `vehicle_ota_deployment_status` STRING COMMENT 'Current deployment status (e.g., pending, in_progress, completed, failed)',
    CONSTRAINT pk_vehicle_ota_deployment PRIMARY KEY(`vehicle_ota_deployment_id`)
) COMMENT 'Association product representing the deployment of an OTA campaign to a specific vehicle. Each record captures the operational details of that deployment, linking one vin_registry record to one ota_campaign record.. Existence Justification: Each OTA campaign can be applied to many individual vehicles, and a single vehicle can receive multiple OTA campaigns over its lifecycle. The deployment of a campaign to a vehicle is recorded as a distinct operational event with its own status, timestamps, and version information, which is actively created and managed by the OTA management team.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`ownership` (
    `ownership_id` BIGINT COMMENT 'Primary key for the vehicle_ownership association',
    `party_id` BIGINT COMMENT 'Foreign key linking to party',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vin_registry',
    `acquisition_date` DATE COMMENT 'Date the party acquired the vehicle',
    `disposition_date` DATE COMMENT 'Date the party disposed of the vehicle',
    `ownership_number` STRING COMMENT 'Identifier for the ownership contract or agreement',
    `ownership_type` STRING COMMENT 'Type of ownership (e.g., lease, purchase, fleet)',
    CONSTRAINT pk_ownership PRIMARY KEY(`ownership_id`)
) COMMENT 'This association product represents the ownership relationship between a vehicle (vin_registry) and a party (customer). It captures acquisition and disposition dates, ownership type, and ownership number, tracking the history of which parties own which vehicles.. Existence Justification: A vehicle can be owned by multiple parties over its lifecycle (e.g., resale), and a party can own multiple vehicles simultaneously. The business actively records each ownership event with dates, type, and ownership number, and users query ownership history for warranty, service, recall, and resale analytics.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` (
    `campaign_enrollment_id` BIGINT COMMENT 'Primary key for the vehicle_campaign_enrollment association',
    `service_campaign_id` BIGINT COMMENT 'Foreign key linking to service_campaign',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vin_registry',
    `labor_time_hours` DECIMAL(18,2) COMMENT 'Labor hours spent on the campaign for the vehicle',
    `notification_date` DATE COMMENT 'Date the vehicle owner was notified about the campaign',
    `notification_status` STRING COMMENT 'Current status of the notification for the vehicle regarding the campaign (e.g., pending, sent, acknowledged)',
    `parts_consumed` BIGINT COMMENT 'Number of parts used to fulfill the campaign for the vehicle',
    `remedy_completion_date` DATE COMMENT 'Date the remedial action was completed for the vehicle',
    `scheduled_service_date` DATE COMMENT 'Date the service for the campaign is scheduled for the vehicle',
    `total_labor_cost_usd` DECIMAL(18,2) COMMENT 'Total labor cost for the vehicle in the campaign',
    `total_parts_cost_usd` DECIMAL(18,2) COMMENT 'Total cost of parts used for the vehicle in the campaign',
    `total_remedy_cost_usd` DECIMAL(18,2) COMMENT 'Aggregate cost (parts + labor) for the vehicles remedy',
    `warranty_covered` BOOLEAN COMMENT 'Indicates if the remedy is covered under warranty for the vehicle',
    CONSTRAINT pk_campaign_enrollment PRIMARY KEY(`campaign_enrollment_id`)
) COMMENT 'Association representing the enrollment of a vehicle (identified by VIN) into a service campaign. Captures enrollment status, dates, remedy completion, parts and labor costs, and warranty coverage for each vehicle‑campaign pair.. Existence Justification: Vehicles are enrolled in service campaigns; each campaign can affect many vehicles and a single vehicle can participate in multiple campaigns over its lifecycle. The enrollment is actively managed by aftersales operations and carries its own data such as notification dates, status, remedy completion, parts and labor costs, and warranty coverage.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` (
    `regulatory_compliance_assignment_id` BIGINT COMMENT 'Primary key for the RegulatoryComplianceAssignment association',
    `model_id` BIGINT COMMENT 'Foreign key linking to the vehicle model',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to the regulatory requirement',
    `compliance_status` STRING COMMENT 'Current compliance state of the model for this requirement',
    `effective_date` DATE COMMENT 'Date the regulatory requirement became effective for the model',
    `notes` STRING COMMENT 'Free‑form comments about the compliance relationship',
    CONSTRAINT pk_regulatory_compliance_assignment PRIMARY KEY(`regulatory_compliance_assignment_id`)
) COMMENT 'This association captures the compliance relationship between a vehicle model and a regulatory requirement. It records the compliance status, the date the requirement became effective for the model, and any notes specific to that pairing.. Existence Justification: Each vehicle model must satisfy multiple regulatory requirements, and each regulatory requirement applies to many vehicle models. The compliance team actively maintains a matrix that records the compliance status, effective dates, and notes for every model‑requirement pair.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` (
    `powertrain_config_id` BIGINT COMMENT 'Unique identifier for the powertrain configuration. Primary key for this product.',
    `product_nameplate_id` BIGINT COMMENT 'Reference to the vehicle nameplate (model line) for which this powertrain configuration is available.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: REQUIRED: Powertrain configurations are produced at designated plants; supply‑chain and capacity forecasts rely on this mapping.',
    `powertrain_spec_id` BIGINT COMMENT 'Foreign key linking to engineering.powertrain_spec. Business justification: Powertrain configuration must reference detailed engineering powertrain specifications for emissions, WLTP, and cost validation (Powertrain Spec Validation Report).',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Needed for Powertrain Supplier Performance Dashboard, linking each powertrain configuration to its component supplier for quality, cost, and regulatory compliance tracking.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: REQUIRED: Emissions certification links each powertrain configuration to the specific regulatory requirement it must meet.',
    `aspiration_type` STRING COMMENT 'Method of air induction for the internal combustion engine. Null for pure electric and fuel cell powertrains.. Valid values are `naturally_aspirated|turbocharged|supercharged|twin_turbo`',
    `battery_capacity_kwh` DECIMAL(18,2) COMMENT 'Total usable battery capacity in kilowatt-hours for electric and plug-in hybrid powertrains. Null for pure ICE vehicles.',
    `battery_chemistry` STRING COMMENT 'Chemical composition of the battery pack for electric and hybrid powertrains. none for pure ICE vehicles.. Valid values are `none|lithium_ion|nickel_metal_hydride|solid_state|lithium_iron_phosphate`',
    `cafe_credit_value` DECIMAL(18,2) COMMENT 'CAFE credit multiplier or value assigned to this powertrain configuration for fleet average fuel economy compliance calculations. Higher for electric and alternative fuel vehicles.',
    `charging_capability` STRING COMMENT 'Maximum charging capability supported by the powertrain for electric and plug-in hybrid vehicles. none for pure ICE and non-plug-in hybrids.. Valid values are `none|level_1|level_2|dc_fast_charge|ultra_fast_charge`',
    `co2_emissions_g_km` STRING COMMENT 'Certified carbon dioxide emissions in grams per kilometer under WLTP or NEDC test cycle. Zero for pure electric vehicles. Used for regulatory compliance and CAFE calculations.',
    `combined_horsepower` STRING COMMENT 'Total system horsepower combining ICE and electric motor output at peak performance. For hybrids, represents maximum combined output, not sum of individual components.',
    `combined_torque_nm` STRING COMMENT 'Total system torque in Newton-meters combining ICE and electric motor output. For hybrids, represents maximum combined torque available to the drivetrain.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this powertrain configuration record was first created in the system.',
    `cylinder_count` STRING COMMENT 'Number of cylinders in the internal combustion engine. Null for pure electric (BEV) and fuel cell (FCEV) powertrains.',
    `dealer_invoice_cost_usd` DECIMAL(18,2) COMMENT 'Dealer invoice cost for this powertrain configuration in US dollars. Used for dealer margin calculations and incentive programs.',
    `drivetrain_layout` STRING COMMENT 'Drive wheel configuration. FWD=Front-Wheel Drive, RWD=Rear-Wheel Drive, AWD=All-Wheel Drive (full-time or automatic), 4WD=Four-Wheel Drive (part-time, driver-selectable).. Valid values are `fwd|rwd|awd|4wd`',
    `electric_motor_position` STRING COMMENT 'Physical location of electric motor(s) in the vehicle architecture. integrated indicates motor integrated with transmission. none for pure ICE.. Valid values are `none|front|rear|front_rear|integrated`',
    `electric_motor_type` STRING COMMENT 'Configuration of electric motors in the powertrain. Applicable to HEV, PHEV, BEV, and MHEV. none for pure ICE powertrains.. Valid values are `none|single_motor|dual_motor|tri_motor|quad_motor`',
    `emissions_standard` STRING COMMENT 'Regulatory emissions standard to which this powertrain is certified. ZLEV=Zero Emission Vehicle, SULEV=Super Ultra Low Emission Vehicle, ULEV=Ultra Low Emission Vehicle, LEV III=Low Emission Vehicle III (California), Tier 3=EPA Tier 3, Euro 6=European Standard.. Valid values are `euro_6|tier_3|lev_iii|ulev|sulev|zlev`',
    `end_of_production_date` DATE COMMENT 'Date when this powertrain configuration was discontinued from production. Null for currently active configurations.',
    `engine_configuration` STRING COMMENT 'Physical arrangement of engine cylinders (inline, V-type, flat/boxer, rotary, W-type). Null for pure electric and fuel cell powertrains.. Valid values are `inline|v_type|flat|rotary|w_type`',
    `engine_displacement_liters` DECIMAL(18,2) COMMENT 'Total swept volume of all engine cylinders in liters. Null for pure BEV and FCEV powertrains without an ICE component.',
    `epa_city_mpg` STRING COMMENT 'EPA-certified city fuel economy rating in miles per gallon. For electric vehicles, this represents MPGe (miles per gallon equivalent). Null if EPA rating not applicable.',
    `epa_combined_mpg` STRING COMMENT 'EPA-certified combined (55% city, 45% highway) fuel economy rating in miles per gallon. For electric vehicles, this represents MPGe. Null if EPA rating not applicable.',
    `epa_electric_range_miles` STRING COMMENT 'EPA-certified all-electric driving range in miles for BEV and PHEV powertrains before ICE engagement or recharge required. Null for pure ICE and HEV.',
    `epa_highway_mpg` STRING COMMENT 'EPA-certified highway fuel economy rating in miles per gallon. For electric vehicles, this represents MPGe. Null if EPA rating not applicable.',
    `fuel_type` STRING COMMENT 'Primary fuel type consumed by the powertrain. For hybrids, this represents the ICE fuel; electric component is captured separately.. Valid values are `gasoline|diesel|electric|hydrogen|flex_fuel|cng`',
    `homologation_status` STRING COMMENT 'Current regulatory homologation and type-approval status for this powertrain configuration. Required for legal sale in regulated markets.. Valid values are `certified|pending|not_required|expired`',
    `manufacturing_cost_usd` DECIMAL(18,2) COMMENT 'Standard manufacturing cost for this powertrain configuration in US dollars. Used for margin analysis and profitability reporting.',
    `market_availability` STRING COMMENT 'Geographic market regions where this powertrain configuration is available for sale. [ENUM-REF-CANDIDATE: global|north_america|europe|asia_pacific|china|japan|middle_east|latin_america|africa — promote to reference product]. Valid values are `global|north_america|europe|asia_pacific|china|japan`',
    `max_charging_power_kw` STRING COMMENT 'Maximum DC fast charging power acceptance rate in kilowatts for electric and plug-in hybrid vehicles. Null for pure ICE and non-plug-in hybrids.',
    `model_year` STRING COMMENT 'The model year for which this powertrain configuration is offered. Represents the marketing year, not the calendar year of production.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this powertrain configuration record was last updated in the system.',
    `msrp_base_usd` DECIMAL(18,2) COMMENT 'Base MSRP premium or cost associated with selecting this powertrain configuration, in US dollars. May be zero for base powertrain or represent upgrade cost.',
    `payload_capacity_lbs` STRING COMMENT 'Maximum cargo and passenger weight capacity in pounds for this powertrain configuration. Critical for commercial and truck applications.',
    `powertrain_code` STRING COMMENT 'Manufacturer-assigned alphanumeric code uniquely identifying this powertrain configuration across all nameplates and model years. Used in ordering systems, BOMs, and production planning.. Valid values are `^[A-Z0-9]{6,12}$`',
    `powertrain_config_status` STRING COMMENT 'Current lifecycle status of this powertrain configuration in the product catalog. Active=currently orderable, Discontinued=no longer available, Planned=future introduction, Phase-out=being discontinued.. Valid values are `active|discontinued|planned|phase_out`',
    `powertrain_name` STRING COMMENT 'Customer-facing marketing name for the powertrain configuration (e.g., EcoBoost 2.0L Turbo, PowerMax V8, e-Drive Electric).',
    `powertrain_type` STRING COMMENT 'High-level classification of the powertrain architecture. ICE=Internal Combustion Engine, HEV=Hybrid Electric Vehicle, PHEV=Plug-in Hybrid Electric Vehicle, BEV=Battery Electric Vehicle, FCEV=Fuel Cell Electric Vehicle, MHEV=Mild Hybrid Electric Vehicle.. Valid values are `ICE|HEV|PHEV|BEV|FCEV|MHEV`',
    `start_of_production_date` DATE COMMENT 'Date when this powertrain configuration entered production and became available for vehicle assembly. Used for program planning and phase-in/phase-out management.',
    `towing_capacity_lbs` STRING COMMENT 'Maximum trailer weight rating in pounds that can be safely towed with this powertrain configuration when properly equipped.',
    `transmission_speeds` STRING COMMENT 'Number of forward gear ratios in the transmission. Null for CVT and single-speed transmissions.',
    `transmission_type` STRING COMMENT 'Type of transmission paired with this powertrain. CVT=Continuously Variable Transmission, DCT=Dual Clutch Transmission, AMT=Automated Manual Transmission. Single-speed common for BEVs.. Valid values are `manual|automatic|cvt|dct|amt|single_speed`',
    `warranty_battery_miles` STRING COMMENT 'Battery pack warranty coverage mileage limit for electric and plug-in hybrid powertrains. Null for pure ICE vehicles.',
    `warranty_battery_months` STRING COMMENT 'Battery pack warranty coverage period in months for electric and plug-in hybrid powertrains. Null for pure ICE vehicles.',
    `warranty_powertrain_miles` STRING COMMENT 'Standard powertrain warranty coverage mileage limit offered with this configuration. Warranty expires at earlier of months or miles.',
    `warranty_powertrain_months` STRING COMMENT 'Standard powertrain warranty coverage period in months offered with this configuration.',
    `wltp_city_range_km` STRING COMMENT 'WLTP-certified city driving range in kilometers for electric vehicles. Null if WLTP not applicable.',
    `wltp_combined_range_km` STRING COMMENT 'WLTP-certified combined driving range in kilometers for electric vehicles (BEV, PHEV electric-only mode). Used for European and international markets. Null if WLTP not applicable.',
    `zero_to_sixty_seconds` DECIMAL(18,2) COMMENT 'Manufacturer-tested acceleration time from 0 to 60 mph in seconds. Key performance metric for marketing and competitive positioning.',
    CONSTRAINT pk_powertrain_config PRIMARY KEY(`powertrain_config_id`)
) COMMENT 'Commercial powertrain configuration catalog defining the orderable powertrain combinations available for each nameplate and MY. Captures powertrain code, engine displacement, cylinder count, fuel type (gasoline/diesel/hybrid/PHEV/BEV/FCEV), electric motor configuration (for EV/HEV/PHEV), combined horsepower, combined torque, transmission type, EPA fuel economy rating (city/highway/combined), WLTP range (for EVs), battery capacity (kWh for EVs), and emissions classification. Distinct from engineering powertrain design data — this is the commercial specification layer.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_body_style` (
    `vehicle_body_style_id` BIGINT COMMENT 'Primary key for body style.',
    `body_style_code` STRING COMMENT 'Body style code.',
    `body_style_name` STRING COMMENT 'Body style name.',
    `created_timestamp` TIMESTAMP COMMENT 'Creation timestamp.',
    `door_count` STRING COMMENT 'Number of doors.',
    CONSTRAINT pk_vehicle_body_style PRIMARY KEY(`vehicle_body_style_id`)
) COMMENT 'Body style master data (SSOT in vehicle domain, moved from aftersales).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_color_option` (
    `vehicle_color_option_id` BIGINT COMMENT 'Primary key for color option.',
    `color_code` STRING COMMENT 'Color code.',
    `color_name` STRING COMMENT 'Color name.',
    `color_type` STRING COMMENT 'Exterior/interior indicator.',
    `created_timestamp` TIMESTAMP COMMENT 'Creation timestamp.',
    CONSTRAINT pk_vehicle_color_option PRIMARY KEY(`vehicle_color_option_id`)
) COMMENT 'Color option master data (SSOT in vehicle domain, moved from aftersales).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` (
    `aftersales_color_option_id` BIGINT COMMENT 'Unique identifier for the color option. Primary key for the color option catalog.',
    `vehicle_color_option_id` BIGINT COMMENT '',
    `color_availability_status` STRING COMMENT 'Current lifecycle status of the color option. Controls visibility in configurators, order acceptance, and production scheduling. Phase-out colors may have restricted order windows.. Valid values are `active|discontinued|limited_availability|pre_launch|phase_out`',
    `color_code` STRING COMMENT 'Manufacturer-assigned alphanumeric code uniquely identifying the color option. Used in Bill of Materials (BOM), production scheduling, and order management systems. Examples: WP9, B3Q, NH731P.. Valid values are `^[A-Z0-9]{3,10}$`',
    `color_description` STRING COMMENT 'Detailed marketing description of the color option including visual characteristics, finish effects, and brand positioning. Used in sales literature, website content, and dealer training materials.',
    `color_durability_rating` STRING COMMENT 'Qualitative assessment of color fade resistance and durability based on accelerated weathering tests. Influences warranty terms and customer expectations for long-term appearance retention.. Valid values are `standard|enhanced|premium`',
    `color_family` STRING COMMENT 'Broad color category grouping for reporting, inventory management, and market analysis. Enables aggregation of similar colors across model years and nameplates. [ENUM-REF-CANDIDATE: white|black|gray|silver|red|blue|green|brown|beige|yellow|orange|other — 12 candidates stripped; promote to reference product]',
    `color_image_url` STRING COMMENT 'Uniform Resource Locator (URL) to the digital asset management system hosting the color swatch or vehicle image in this color. Used in online configurators, mobile apps, and dealer portals.. Valid values are `^https?://.*.(jpg|jpeg|png|webp)$`',
    `color_match_tolerance` STRING COMMENT 'Acceptable color variation tolerance expressed in Delta E (ΔE) units or manufacturer-specific scale. Used in quality control, paint booth calibration, and supplier acceptance criteria.',
    `color_name` STRING COMMENT 'Marketing name of the color option as presented to customers and dealers. Examples: Arctic White, Midnight Black, Crimson Red, Graphite Metallic.',
    `color_type` STRING COMMENT 'Classification indicating whether the color option applies to exterior paint, interior trim/upholstery, or both. Determines applicability in vehicle configuration.. Valid values are `exterior|interior|both`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this color option record was first created in the system. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the MSRP uplift amount. Supports multi-currency pricing across global markets.. Valid values are `^[A-Z]{3}$`',
    `end_of_production_date` DATE COMMENT 'Date when this color option is discontinued from production. Nullable for ongoing colors. Used to manage phase-out inventory and dealer order cutoff dates.',
    `environmental_compliance_flag` BOOLEAN COMMENT 'Indicates whether this color option meets all applicable environmental regulations including Volatile Organic Compound (VOC) limits, REACH, and RoHS directives. Required for regulatory reporting and market certification.',
    `historical_sales_volume` STRING COMMENT 'Cumulative number of vehicles sold with this color option across all model years and nameplates. Used for demand forecasting, inventory planning, and portfolio optimization. Confidential business metric.',
    `interior_material_type` STRING COMMENT 'Material composition for interior color options. Applicable only when color_type is interior or both. Drives Bill of Materials (BOM) component selection and supplier sourcing. [ENUM-REF-CANDIDATE: cloth|leather|synthetic_leather|premium_leather|alcantara|vinyl|suede|not_applicable — 8 candidates stripped; promote to reference product]',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this color option record was last updated. Supports change tracking, data quality monitoring, and synchronization with downstream systems.',
    `lead_time_days` STRING COMMENT 'Additional production lead time in days required for this color option beyond standard build cycle. Used in order promising and delivery date calculation.',
    `marketing_priority_rank` STRING COMMENT 'Relative priority ranking for marketing and promotional activities. Lower numbers indicate higher priority. Used to determine featured colors in advertising, configurator defaults, and showroom displays.',
    `model_year` STRING COMMENT 'Model year for which this color option is available. Enables year-over-year color portfolio management and historical analysis. Format: YYYY.',
    `msrp_uplift_amount` DECIMAL(18,2) COMMENT 'Additional charge in base currency for selecting this color option above the standard color. Zero for no-charge colors. Used in pricing configuration and dealer quotation systems.',
    `package_compatibility` STRING COMMENT 'Comma-separated list of option package codes that are compatible or required with this color option. Supports complex configuration dependencies and upsell strategies.',
    `paint_code_supplier` STRING COMMENT 'Supplier-specific paint code or formula reference used in procurement and quality control. Links to supplier master data and Production Part Approval Process (PPAP) documentation.',
    `paint_technology` STRING COMMENT 'Paint finish technology and application method. Impacts manufacturing process complexity, cost, and visual appearance. Tri-coat and multi-stage finishes require additional production steps.. Valid values are `solid|metallic|pearl|matte|tri-coat|multi-stage`',
    `production_cost_delta` DECIMAL(18,2) COMMENT 'Incremental manufacturing cost for this color option compared to base color. Used in margin analysis, Total Cost of Ownership (TCO) calculations, and profitability reporting. Confidential business data.',
    `regional_availability` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes or region codes where this color option is offered. Supports market-specific color strategies and regulatory compliance. Example: USA,CAN,MEX or EMEA.',
    `special_order_flag` BOOLEAN COMMENT 'Indicates whether this color option requires special order processing with extended lead times. True for low-volume or custom colors not stocked in standard production flow.',
    `start_of_production_date` DATE COMMENT 'Date when this color option becomes available for production scheduling and vehicle assembly. Aligns with manufacturing readiness and supplier qualification milestones.',
    `touch_up_paint_available_flag` BOOLEAN COMMENT 'Indicates whether touch-up paint kits are available through after-sales parts channels for this color option. Supports service operations and customer self-repair.',
    `trim_level_compatibility` STRING COMMENT 'Comma-separated list of trim level codes or names for which this color option is available. Enforces configuration rules in order management and prevents invalid SKU (Stock Keeping Unit) combinations.',
    `voc_content_grams_per_liter` DECIMAL(18,2) COMMENT 'Volatile Organic Compound content measured in grams per liter for paint formulation. Required for Environmental Protection Agency (EPA) and California Air Resources Board (CARB) compliance reporting.',
    CONSTRAINT pk_aftersales_color_option PRIMARY KEY(`aftersales_color_option_id`)
) COMMENT 'Commercial color catalog defining all available exterior paint colors and interior color/material combinations offered across model year programs. Captures color code, color name, color type (exterior/interior), color family, paint technology (solid/metallic/pearl/matte), interior material type (cloth/leather/synthetic/premium), availability by trim level, MSRP uplift (for premium colors), regional availability, and active/discontinued status. Used in SKU configuration, order management, and production scheduling.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ADD CONSTRAINT `fk_vehicle_vin_registry_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ADD CONSTRAINT `fk_vehicle_model_platform_id` FOREIGN KEY (`platform_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`platform`(`platform_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_model_year_program` ADD CONSTRAINT `fk_vehicle_vehicle_model_year_program_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` ADD CONSTRAINT `fk_vehicle_vehicle_trim_level_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ADD CONSTRAINT `fk_vehicle_powertrain_variant_powertrain_config_id` FOREIGN KEY (`powertrain_config_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`powertrain_config`(`powertrain_config_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_adas_feature` ADD CONSTRAINT `fk_vehicle_vehicle_adas_feature_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_vehicle_body_style_id` FOREIGN KEY (`vehicle_body_style_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vehicle_body_style`(`vehicle_body_style_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_ecu_catalog_id` FOREIGN KEY (`ecu_catalog_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`ecu_catalog`(`ecu_catalog_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_platform_id` FOREIGN KEY (`platform_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`platform`(`platform_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_powertrain_variant_id` FOREIGN KEY (`powertrain_variant_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`powertrain_variant`(`powertrain_variant_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` ADD CONSTRAINT `fk_vehicle_vehicle_option_package_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ADD CONSTRAINT `fk_vehicle_build_spec_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ADD CONSTRAINT `fk_vehicle_homologation_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ADD CONSTRAINT `fk_vehicle_msrp_pricing_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ADD CONSTRAINT `fk_vehicle_msrp_pricing_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ADD CONSTRAINT `fk_vehicle_lifecycle_event_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_emissions_certification` ADD CONSTRAINT `fk_vehicle_vehicle_emissions_certification_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` ADD CONSTRAINT `fk_vehicle_vehicle_ota_deployment_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` ADD CONSTRAINT `fk_vehicle_ownership_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ADD CONSTRAINT `fk_vehicle_campaign_enrollment_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` ADD CONSTRAINT `fk_vehicle_regulatory_compliance_assignment_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ADD CONSTRAINT `fk_vehicle_aftersales_color_option_vehicle_color_option_id` FOREIGN KEY (`vehicle_color_option_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vehicle_color_option`(`vehicle_color_option_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`vehicle` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`vehicle` SET TAGS ('dbx_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` SET TAGS ('dbx_subdomain' = 'physical_instances');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN) Registry ID');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `product_nameplate_id` SET TAGS ('dbx_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_business_glossary_term' = 'Telematics Device ID');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_device' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_business_glossary_term' = 'Battery Capacity in Kilowatt-Hours (kWh)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `build_date` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Build Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `check_digit` SET TAGS ('dbx_business_glossary_term' = 'VIN Check Digit');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `check_digit` SET TAGS ('dbx_value_regex' = '^[0-9X]$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `curb_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Curb Weight in Kilograms');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `destination_market` SET TAGS ('dbx_business_glossary_term' = 'Destination Market');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `destination_market` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `emission_standard` SET TAGS ('dbx_business_glossary_term' = 'Emission Standard');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `eop_date` SET TAGS ('dbx_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `epa_combined_mpg` SET TAGS ('dbx_business_glossary_term' = 'Environmental Protection Agency (EPA) Combined Miles Per Gallon (MPG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `fuel_tank_capacity_liters` SET TAGS ('dbx_business_glossary_term' = 'Fuel Tank Capacity in Liters');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `fuel_tank_capacity_liters` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `gvwr_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Vehicle Weight Rating (GVWR) in Kilograms');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `homologation_market` SET TAGS ('dbx_business_glossary_term' = 'Homologation Market');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `homologation_market` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `line_off_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Line-Off Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `model_year_decoded` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY) Decoded');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `msrp_currency_code` SET TAGS ('dbx_business_glossary_term' = 'MSRP Currency Code');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `msrp_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `obd_protocol` SET TAGS ('dbx_business_glossary_term' = 'On-Board Diagnostics (OBD) Protocol');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `obd_protocol` SET TAGS ('dbx_value_regex' = 'obd_i|obd_ii|eobd|jobd|can|uds');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{1}$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `production_sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Production Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `production_sequence_number` SET TAGS ('dbx_value_regex' = '^[0-9]{6}$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `recall_flag` SET TAGS ('dbx_business_glossary_term' = 'Recall Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `safety_rating` SET TAGS ('dbx_business_glossary_term' = 'Safety Rating');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `sop_date` SET TAGS ('dbx_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `telematics_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Telematics Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `vds` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Descriptor Section (VDS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `vds` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{6}$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `vehicle_lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `vis` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identifier Section (VIS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `vis` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{8}$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `warranty_end_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty End Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `wltp_combined_consumption` SET TAGS ('dbx_business_glossary_term' = 'Worldwide Harmonised Light Vehicles Test Procedure (WLTP) Combined Consumption');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `wmi` SET TAGS ('dbx_business_glossary_term' = 'World Manufacturer Identifier (WMI)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `wmi` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{3}$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` SET TAGS ('dbx_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Identifier');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `product_nameplate_id` SET TAGS ('dbx_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `platform_id` SET TAGS ('dbx_business_glossary_term' = 'Platform Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `platform_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `adas_features` SET TAGS ('dbx_business_glossary_term' = 'ADAS Feature Set (ADAS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_business_glossary_term' = 'Battery Capacity (kWh)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `body_style` SET TAGS ('dbx_business_glossary_term' = 'Body Style (BODY)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `brand_manager_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `brand_manager_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `brand_name` SET TAGS ('dbx_business_glossary_term' = 'Brand Name (BRAND)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `cargo_capacity_liters` SET TAGS ('dbx_business_glossary_term' = 'Cargo Capacity (Liters)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `cargo_capacity_liters` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `co2_emissions_g_per_km` SET TAGS ('dbx_business_glossary_term' = 'CO₂ Emissions (g/km)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `connectivity_features` SET TAGS ('dbx_business_glossary_term' = 'Connectivity Feature Set (CONNECT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `curb_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Curb Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `model_description` SET TAGS ('dbx_business_glossary_term' = 'Model Description (DESC)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `drive_configuration` SET TAGS ('dbx_business_glossary_term' = 'Drive Configuration (DRIVE)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `drive_configuration` SET TAGS ('dbx_value_regex' = 'fwd|rwd|awd|4wd');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `electric_range_miles` SET TAGS ('dbx_business_glossary_term' = 'Electric Range (Miles)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `emissions_standard` SET TAGS ('dbx_business_glossary_term' = 'Emissions Standard (EMISS_STD)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `emissions_standard` SET TAGS ('dbx_value_regex' = 'epa|euro6|caeb|none');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `end_of_production_model_year` SET TAGS ('dbx_business_glossary_term' = 'End‑of‑Production Model Year (EOP MY)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `engine_code` SET TAGS ('dbx_business_glossary_term' = 'Engine Code (ENG_CD)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `eop_date` SET TAGS ('dbx_business_glossary_term' = 'End of Production Date (EOP)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `fuel_economy_city_mpg` SET TAGS ('dbx_business_glossary_term' = 'City Fuel Economy (MPG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `fuel_economy_city_mpg` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `fuel_economy_hwy_mpg` SET TAGS ('dbx_business_glossary_term' = 'Highway Fuel Economy (MPG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `fuel_type` SET TAGS ('dbx_business_glossary_term' = 'Fuel Type (FUEL)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `fuel_type` SET TAGS ('dbx_value_regex' = 'gasoline|diesel|electric|hybrid|plug_in_hybrid');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `height_mm` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Height (mm)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `homologation_status` SET TAGS ('dbx_business_glossary_term' = 'Homologation Status (HOMO_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `homologation_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `launch_model_year` SET TAGS ('dbx_business_glossary_term' = 'Launch Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `length_mm` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Length (mm)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `market_regions` SET TAGS ('dbx_business_glossary_term' = 'Market Regions (REGIONS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `msrp_usd` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `model_name` SET TAGS ('dbx_business_glossary_term' = 'Model Name (NAME)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `ncap_safety_rating` SET TAGS ('dbx_business_glossary_term' = 'NCAP Safety Rating (NCAP)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `ncap_safety_rating` SET TAGS ('dbx_value_regex' = '5_star|4_star|3_star|2_star|1_star|not_rated');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type (PT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ice|hev|phev|ev');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `primary_market` SET TAGS ('dbx_business_glossary_term' = 'Primary Market (MARKET)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `program_code` SET TAGS ('dbx_business_glossary_term' = 'Program Code (PROG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `safety_standard` SET TAGS ('dbx_business_glossary_term' = 'Safety Standard (SAFE_STD)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `safety_standard` SET TAGS ('dbx_value_regex' = 'nhtsa|euro_ncap|none');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `seating_capacity` SET TAGS ('dbx_business_glossary_term' = 'Seating Capacity (SEATS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `seating_capacity` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `segment` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Segment (SEG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `segment` SET TAGS ('dbx_value_regex' = 'sedan|suv|pickup|van|coupe|convertible');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `sop_date` SET TAGS ('dbx_business_glossary_term' = 'Start of Production Date (SOP)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `model_status` SET TAGS ('dbx_business_glossary_term' = 'Model Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `model_status` SET TAGS ('dbx_value_regex' = 'active|inactive|discontinued');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `transmission_gears` SET TAGS ('dbx_business_glossary_term' = 'Number of Gears (GEARS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `transmission_type` SET TAGS ('dbx_business_glossary_term' = 'Transmission Type (TRANS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `transmission_type` SET TAGS ('dbx_value_regex' = 'automatic|manual|cvT|dual_clutch');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `variant_count` SET TAGS ('dbx_business_glossary_term' = 'Variant Count (VAR_COUNT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `vehicle_class` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Class (CLASS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `vehicle_class` SET TAGS ('dbx_value_regex' = 'passenger|commercial|luxury|performance|off_road');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `wheelbase_mm` SET TAGS ('dbx_business_glossary_term' = 'Wheelbase (mm)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ALTER COLUMN `width_mm` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Width (mm)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_model_year_program` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_model_year_program` SET TAGS ('dbx_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_model_year_program` ALTER COLUMN `vehicle_model_year_program_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for vehicle_model_year_program');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_model_year_program` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` SET TAGS ('dbx_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` ALTER COLUMN `vehicle_trim_level_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for vehicle_trim_level');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` ALTER COLUMN `aftersales_trim_level_id` SET TAGS ('dbx_business_glossary_term' = 'Trim Level Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` SET TAGS ('dbx_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `powertrain_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Variant Identifier');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `powertrain_config_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Config Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `powertrain_spec_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Spec Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_business_glossary_term' = 'Battery Capacity (kWh)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `charging_standard` SET TAGS ('dbx_business_glossary_term' = 'Charging Standard');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `charging_standard` SET TAGS ('dbx_value_regex' = 'CCS|CHAdeMO|NACS');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `co2_emissions_g_per_km` SET TAGS ('dbx_business_glossary_term' = 'CO₂ Emissions (g/km)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `combined_system_power_kw` SET TAGS ('dbx_business_glossary_term' = 'Combined System Power (kW)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `cylinder_count` SET TAGS ('dbx_business_glossary_term' = 'Cylinder Count');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `powertrain_variant_description` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Variant Description');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `drive_type` SET TAGS ('dbx_business_glossary_term' = 'Drive Type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `drive_type` SET TAGS ('dbx_value_regex' = 'FWD|RWD|AWD|4WD');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `electric_motor_power_kw` SET TAGS ('dbx_business_glossary_term' = 'Electric Motor Peak Power (kW)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `end_of_production_date` SET TAGS ('dbx_business_glossary_term' = 'End of Production Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `engine_displacement_cc` SET TAGS ('dbx_business_glossary_term' = 'Engine Displacement (cc)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `epa_fuel_economy_combined_mpg` SET TAGS ('dbx_business_glossary_term' = 'EPA Combined Fuel Economy (MPG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `epa_range_miles` SET TAGS ('dbx_business_glossary_term' = 'EPA Rated Range (miles)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `fuel_economy_city_mpg` SET TAGS ('dbx_business_glossary_term' = 'City Fuel Economy (MPG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `fuel_economy_city_mpg` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `fuel_economy_combined_mpg` SET TAGS ('dbx_business_glossary_term' = 'Combined Fuel Economy (MPG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `fuel_economy_highway_mpg` SET TAGS ('dbx_business_glossary_term' = 'Highway Fuel Economy (MPG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `fuel_type` SET TAGS ('dbx_business_glossary_term' = 'Fuel Type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `fuel_type` SET TAGS ('dbx_value_regex' = 'gasoline|diesel|electric|hydrogen|hybrid');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type (ICE|HEV|PHEV|BEV|FCEV)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `powertrain_variant_status` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Variant Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `powertrain_variant_status` SET TAGS ('dbx_value_regex' = 'active|inactive|retired|planned');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `range_km` SET TAGS ('dbx_business_glossary_term' = 'Electric Range (km)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `start_of_production_date` SET TAGS ('dbx_business_glossary_term' = 'Start of Production Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `transmission_type` SET TAGS ('dbx_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `transmission_type` SET TAGS ('dbx_value_regex' = 'automatic|manual|CVT|dual_clutch');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `variant_code` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Variant Code');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `variant_name` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Variant Name');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `vehicle_platform` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Platform');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `wltp_fuel_economy_combined_mpg` SET TAGS ('dbx_business_glossary_term' = 'WLTP Combined Fuel Economy (MPG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ALTER COLUMN `wltp_range_km` SET TAGS ('dbx_business_glossary_term' = 'WLTP Range (km)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` SET TAGS ('dbx_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `platform_id` SET TAGS ('dbx_business_glossary_term' = 'Platform ID');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `adaptive_cruise_control` SET TAGS ('dbx_business_glossary_term' = 'Adaptive Cruise Control Availability (ACC)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `adas_features` SET TAGS ('dbx_business_glossary_term' = 'ADAS Feature Set (ADAS_FEAT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `architecture` SET TAGS ('dbx_business_glossary_term' = 'Platform Architecture (ARCH)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `platform_code` SET TAGS ('dbx_business_glossary_term' = 'Platform Code (PLT_CODE)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `compatible_powertrain_families` SET TAGS ('dbx_business_glossary_term' = 'Compatible Powertrain Families (PT_FAM)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `compatible_powertrain_families` SET TAGS ('dbx_value_regex' = 'ICE|HEV|PHEV|EV|FCEV|Hybrid');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `platform_description` SET TAGS ('dbx_business_glossary_term' = 'Platform Description (DESC)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `development_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Platform Development Cost (USD)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `development_cost_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `emissions_class` SET TAGS ('dbx_business_glossary_term' = 'Emissions Class (EMISS_CLASS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `emissions_class` SET TAGS ('dbx_value_regex' = 'Euro6|Euro5|EPA_Tier2|EPA_Tier3|EPA_Tier4');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `end_of_production_date` SET TAGS ('dbx_business_glossary_term' = 'End of Production Date (EOP_DATE)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `family` SET TAGS ('dbx_business_glossary_term' = 'Platform Family (FAMILY)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `generation` SET TAGS ('dbx_business_glossary_term' = 'Platform Generation (GEN)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `height_max_mm` SET TAGS ('dbx_business_glossary_term' = 'Maximum Platform Height (HT_MAX_MM)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `height_min_mm` SET TAGS ('dbx_business_glossary_term' = 'Minimum Platform Height (HT_MIN_MM)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `length_max_mm` SET TAGS ('dbx_business_glossary_term' = 'Maximum Platform Length (LEN_MAX_MM)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `length_min_mm` SET TAGS ('dbx_business_glossary_term' = 'Minimum Platform Length (LEN_MIN_MM)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `material_strategy` SET TAGS ('dbx_business_glossary_term' = 'Material Strategy (MAT_STRAT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `material_strategy` SET TAGS ('dbx_value_regex' = 'steel|aluminum|mixed|composite');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `max_gvw_kg` SET TAGS ('dbx_business_glossary_term' = 'Maximum Gross Vehicle Weight (MAX_GVW_KG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `modular_score` SET TAGS ('dbx_business_glossary_term' = 'Platform Modularity Score (MOD_SCORE)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `platform_name` SET TAGS ('dbx_business_glossary_term' = 'Platform Name (PLT_NAME)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `ota_capability` SET TAGS ('dbx_business_glossary_term' = 'Over‑The‑Air Capability (OTA)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `owner_business_unit` SET TAGS ('dbx_business_glossary_term' = 'Platform Owner Business Unit (OWNER_BU)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `platform_status` SET TAGS ('dbx_business_glossary_term' = 'Platform Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `platform_status` SET TAGS ('dbx_value_regex' = 'active|inactive|planned|retired');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `platform_type` SET TAGS ('dbx_business_glossary_term' = 'Platform Type (TYPE)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `regulatory_compliance` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Statement (REG_COMP)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `release_year` SET TAGS ('dbx_business_glossary_term' = 'Platform Release Year (REL_YEAR)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `start_of_production_date` SET TAGS ('dbx_business_glossary_term' = 'Start of Production Date (SOP_DATE)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `track_width_max_mm` SET TAGS ('dbx_business_glossary_term' = 'Maximum Track Width (TW_MAX_MM)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `track_width_min_mm` SET TAGS ('dbx_business_glossary_term' = 'Minimum Track Width (TW_MIN_MM)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Platform Version (VERSION)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Platform Curb Weight (WEIGHT_KG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `wheelbase_max_mm` SET TAGS ('dbx_business_glossary_term' = 'Maximum Wheelbase (WB_MAX_MM)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `wheelbase_min_mm` SET TAGS ('dbx_business_glossary_term' = 'Minimum Wheelbase (WB_MIN_MM)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `width_max_mm` SET TAGS ('dbx_business_glossary_term' = 'Maximum Platform Width (WID_MAX_MM)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ALTER COLUMN `width_min_mm` SET TAGS ('dbx_business_glossary_term' = 'Minimum Platform Width (WID_MIN_MM)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_adas_feature` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_adas_feature` SET TAGS ('dbx_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_adas_feature` ALTER COLUMN `vehicle_adas_feature_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for vehicle_adas_feature');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_adas_feature` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` SET TAGS ('dbx_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration ID');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `aftersales_trim_level_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Trim Level Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `aftersales_trim_level_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `vehicle_body_style_id` SET TAGS ('dbx_business_glossary_term' = 'Body Style Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `vehicle_body_style_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `change_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Control Plan Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `design_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Design Specification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `ecu_catalog_id` SET TAGS ('dbx_business_glossary_term' = 'Ecu Catalog Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Engineer Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `model_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `product_nameplate_id` SET TAGS ('dbx_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `platform_id` SET TAGS ('dbx_business_glossary_term' = 'Platform Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `platform_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `powertrain_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Variant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant ID');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `adas_features` SET TAGS ('dbx_business_glossary_term' = 'ADAS Feature Set (ADAS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `adas_features` SET TAGS ('dbx_value_regex' = 'lane_keep|adaptive_cruise|blind_spot|auto_brake|parking_assist|traffic_sign_recognition');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `body_style` SET TAGS ('dbx_business_glossary_term' = 'Body Style (BODY)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `build_feasibility_status` SET TAGS ('dbx_business_glossary_term' = 'Build Feasibility Status (BUILD_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `build_feasibility_status` SET TAGS ('dbx_value_regex' = 'feasible|non-feasible|pending');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `co2_emissions_g_per_km` SET TAGS ('dbx_business_glossary_term' = 'CO2 Emissions (g/km)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `configuration_code` SET TAGS ('dbx_business_glossary_term' = 'Configuration Code (CFG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `destination_charge` SET TAGS ('dbx_business_glossary_term' = 'Destination Charge (DEST)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `drivetrain` SET TAGS ('dbx_business_glossary_term' = 'Drivetrain (DRIVE)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `drivetrain` SET TAGS ('dbx_value_regex' = 'FWD|RWD|AWD|4WD');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `emissions_cert_status` SET TAGS ('dbx_business_glossary_term' = 'Emissions Certification Status (EMISS_CERT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `emissions_cert_status` SET TAGS ('dbx_value_regex' = 'certified|pending|exempt');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `end_of_production_date` SET TAGS ('dbx_business_glossary_term' = 'End of Production Date (EOP)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `ev_range_miles` SET TAGS ('dbx_business_glossary_term' = 'Electric Vehicle Range (EV_RANGE)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `exterior_color` SET TAGS ('dbx_business_glossary_term' = 'Exterior Color (COLOR_EXT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `fuel_economy_city_mpg` SET TAGS ('dbx_business_glossary_term' = 'City Fuel Economy (MPG_CITY)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `fuel_economy_city_mpg` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `fuel_economy_hwy_mpg` SET TAGS ('dbx_business_glossary_term' = 'Highway Fuel Economy (MPG_HWY)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `fuel_type` SET TAGS ('dbx_business_glossary_term' = 'Fuel Type (FUEL)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `fuel_type` SET TAGS ('dbx_value_regex' = 'gasoline|diesel|electric|hydrogen|hybrid');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `interior_material` SET TAGS ('dbx_business_glossary_term' = 'Interior Material (INT_MAT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `market_country_code` SET TAGS ('dbx_business_glossary_term' = 'Market Country Code (ISO3)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `market_country_code` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `market_region` SET TAGS ('dbx_business_glossary_term' = 'Market Region (REG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `market_region` SET TAGS ('dbx_value_regex' = 'NA|EU|APAC|LATAM|MEA');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `msrp_amount` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `optional_package_codes` SET TAGS ('dbx_business_glossary_term' = 'Optional Package Codes (PKG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `record_status` SET TAGS ('dbx_business_glossary_term' = 'Record Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `record_status` SET TAGS ('dbx_value_regex' = 'active|inactive|archived');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `start_of_production_date` SET TAGS ('dbx_business_glossary_term' = 'Start of Production Date (SOP)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `total_price` SET TAGS ('dbx_business_glossary_term' = 'Total Vehicle Price (TOTAL_PRICE)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `transmission_type` SET TAGS ('dbx_business_glossary_term' = 'Transmission Type (TRANS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `transmission_type` SET TAGS ('dbx_value_regex' = 'automatic|manual|CVT|dual-clutch');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `trim_level` SET TAGS ('dbx_business_glossary_term' = 'Trim Level (TRIM)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `vehicle_platform` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Platform (PLATFORM)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `warranty_miles` SET TAGS ('dbx_business_glossary_term' = 'Warranty Mileage (MILES)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `warranty_years` SET TAGS ('dbx_business_glossary_term' = 'Warranty Period (YEARS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `wheel_size_inch` SET TAGS ('dbx_business_glossary_term' = 'Wheel Size (INCH)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` SET TAGS ('dbx_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` ALTER COLUMN `vehicle_option_package_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for vehicle_option_package');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` ALTER COLUMN `bom_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Bom Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` SET TAGS ('dbx_subdomain' = 'physical_instances');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `build_spec_id` SET TAGS ('dbx_business_glossary_term' = 'Build Specification ID');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `bom_header_id` SET TAGS ('dbx_business_glossary_term' = 'Bom Header Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `build_date` SET TAGS ('dbx_business_glossary_term' = 'Build Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `build_spec_status` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `build_spec_status` SET TAGS ('dbx_value_regex' = 'active|inactive|decommissioned');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `co2_emissions_g_per_km` SET TAGS ('dbx_business_glossary_term' = 'CO2 Emissions (g/km)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `diagnostic_trouble_code_initial` SET TAGS ('dbx_business_glossary_term' = 'Initial Diagnostic Trouble Code (DTC)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `emissions_rating` SET TAGS ('dbx_business_glossary_term' = 'Emissions Rating');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `emissions_rating` SET TAGS ('dbx_value_regex' = 'EPA Tier 1|EPA Tier 2|EPA Tier 3|Euro 6|Euro 7');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `fleet_spec_flag` SET TAGS ('dbx_business_glossary_term' = 'Fleet Specification Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `fuel_efficiency_mpg` SET TAGS ('dbx_business_glossary_term' = 'Fuel Efficiency (MPG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `ncap_rating` SET TAGS ('dbx_business_glossary_term' = 'NCAP Rating');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `ncap_rating` SET TAGS ('dbx_value_regex' = '1-star|2-star|3-star|4-star|5-star');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `ota_updatable_flag` SET TAGS ('dbx_business_glossary_term' = 'OTA Updatable Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `production_line` SET TAGS ('dbx_business_glossary_term' = 'Production Line');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_value_regex' = 'approved|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `safety_feature_codes` SET TAGS ('dbx_business_glossary_term' = 'Safety Feature Codes');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Production Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `software_version` SET TAGS ('dbx_business_glossary_term' = 'Software Version');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `special_order_flag` SET TAGS ('dbx_business_glossary_term' = 'Special Order Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `v2x_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'V2X Communication Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `vehicle_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `warranty_end_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty End Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `warranty_mileage_limit` SET TAGS ('dbx_business_glossary_term' = 'Warranty Mileage Limit');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` SET TAGS ('dbx_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `homologation_id` SET TAGS ('dbx_business_glossary_term' = 'Homologation Identifier');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Officer Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `homologation_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Homologation Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `homologation_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Homologation Variant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `approval_type` SET TAGS ('dbx_business_glossary_term' = 'Approval Type (WHOLE_VEHICLE|COMPONENT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `approval_type` SET TAGS ('dbx_value_regex' = 'whole_vehicle|component');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `authority_name` SET TAGS ('dbx_business_glossary_term' = 'Authority Name');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `homologation_category` SET TAGS ('dbx_business_glossary_term' = 'Homologation Category');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `homologation_category` SET TAGS ('dbx_value_regex' = 'safety|emissions|both');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Certificate Number');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `certification_status_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Status Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `compliance_document_url` SET TAGS ('dbx_business_glossary_term' = 'Compliance Document URL');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `effective_from` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `effective_until` SET TAGS ('dbx_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Active Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `is_ota_updatable` SET TAGS ('dbx_business_glossary_term' = 'OTA Updatable Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `last_inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inspection Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'active|inactive|expired|suspended');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modification Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `next_renewal_date` SET TAGS ('dbx_business_glossary_term' = 'Next Renewal Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `regulatory_framework` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Framework');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `regulatory_framework` SET TAGS ('dbx_value_regex' = 'FMVSS|ECE|NCAP|CARB|EPA');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `regulatory_version` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Version');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `scope` SET TAGS ('dbx_business_glossary_term' = 'Homologation Scope');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `scope` SET TAGS ('dbx_value_regex' = 'type_approval|component_approval');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `vehicle_identification_number` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ALTER COLUMN `vehicle_identification_number` SET TAGS ('dbx_value_regex' = '[A-HJ-NPR-Z0-9]{17}');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` SET TAGS ('dbx_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `ecu_catalog_id` SET TAGS ('dbx_business_glossary_term' = 'ECU Catalog Identifier');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `ecu_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Ecu Specification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `applicable_trim_levels` SET TAGS ('dbx_business_glossary_term' = 'Applicable Trim Levels');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `applicable_vehicle_models` SET TAGS ('dbx_business_glossary_term' = 'Applicable Vehicle Models');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `communication_protocol` SET TAGS ('dbx_business_glossary_term' = 'Communication Protocol');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `communication_protocol` SET TAGS ('dbx_value_regex' = 'CAN|LIN|Ethernet|AUTOSAR');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `cybersecurity_certification` SET TAGS ('dbx_business_glossary_term' = 'Cybersecurity Certification');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `ecu_catalog_description` SET TAGS ('dbx_business_glossary_term' = 'ECU Description');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `ecu_code` SET TAGS ('dbx_business_glossary_term' = 'ECU Code');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `ecu_function` SET TAGS ('dbx_business_glossary_term' = 'ECU Function');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `ecu_name` SET TAGS ('dbx_business_glossary_term' = 'ECU Name');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `end_of_life_date` SET TAGS ('dbx_business_glossary_term' = 'End‑of‑Life Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `functional_safety_asil` SET TAGS ('dbx_business_glossary_term' = 'Functional Safety ASIL');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `functional_safety_asil` SET TAGS ('dbx_value_regex' = 'A|B|C|D');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `hardware_part_number` SET TAGS ('dbx_business_glossary_term' = 'Hardware Part Number');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `is_deprecated` SET TAGS ('dbx_business_glossary_term' = 'Is Deprecated Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'ECU Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'active|inactive|retired|pending');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `ota_updatable_flag` SET TAGS ('dbx_business_glossary_term' = 'OTA Updatable Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `power_consumption_watts` SET TAGS ('dbx_business_glossary_term' = 'Power Consumption (Watts)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `regulatory_approval_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_value_regex' = 'approved|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `software_baseline_version` SET TAGS ('dbx_business_glossary_term' = 'Software Baseline Version');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `supplier_name` SET TAGS ('dbx_business_glossary_term' = 'Supplier Name');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `supplier_part_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Part Number');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `v2x_communication_enabled` SET TAGS ('dbx_business_glossary_term' = 'V2X Communication Enabled');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `voltage_volts` SET TAGS ('dbx_business_glossary_term' = 'Operating Voltage (Volts)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `warranty_period_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Period (Months)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'ECU Weight (kg)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` SET TAGS ('dbx_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `msrp_pricing_id` SET TAGS ('dbx_business_glossary_term' = 'MSRP Pricing Identifier');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `aftersales_option_package_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Option Package Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `aftersales_option_package_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Configuration Identifier (VC_ID)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `model_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO‑4217)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `destination_charge_amount` SET TAGS ('dbx_business_glossary_term' = 'Destination Charge Amount (DEST_AMT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `destination_charge_flag` SET TAGS ('dbx_business_glossary_term' = 'Destination Charge Flag (DEST_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date (END_DATE)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date (START_DATE)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `ev_tax_credit_amount` SET TAGS ('dbx_business_glossary_term' = 'EV Tax Credit Amount (EV_CREDIT_AMT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `ev_tax_credit_eligibility_flag` SET TAGS ('dbx_business_glossary_term' = 'EV Tax Credit Eligibility Flag (EV_CREDIT_ELIG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `gas_guzzler_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Gas Guzzler Tax Amount (GGT_AMT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `gas_guzzler_tax_flag` SET TAGS ('dbx_business_glossary_term' = 'Gas Guzzler Tax Flag (GGT_FLAG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `market_country_code` SET TAGS ('dbx_business_glossary_term' = 'Market Country Code (ISO‑3)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `market_country_code` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `market_region` SET TAGS ('dbx_business_glossary_term' = 'Market Region (REGION)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `market_region` SET TAGS ('dbx_value_regex' = 'NA|EU|APAC|LATAM|MEA');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `msrp_pricing_status` SET TAGS ('dbx_business_glossary_term' = 'Pricing Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `msrp_pricing_status` SET TAGS ('dbx_value_regex' = 'active|inactive|retired|pending');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `option_package_code` SET TAGS ('dbx_business_glossary_term' = 'Option Package Code (PKG)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type (PT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ICE|HEV|PHEV|EV');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `price_amount` SET TAGS ('dbx_business_glossary_term' = 'Price Amount (AMT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `price_key` SET TAGS ('dbx_business_glossary_term' = 'MSRP Pricing Key (CODE)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `price_label` SET TAGS ('dbx_business_glossary_term' = 'MSRP Pricing Label');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `price_notes` SET TAGS ('dbx_business_glossary_term' = 'Price Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `price_source_system` SET TAGS ('dbx_business_glossary_term' = 'Price Source System (SRC_SYS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `price_source_system` SET TAGS ('dbx_value_regex' = 'SAP|PLM|CRM');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `price_type` SET TAGS ('dbx_business_glossary_term' = 'Price Type (TYPE)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `price_type` SET TAGS ('dbx_value_regex' = 'base|destination|tax|total');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `price_uplift_amount` SET TAGS ('dbx_business_glossary_term' = 'Price Uplift Amount (UPLIFT_AMT)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `price_uplift_reason` SET TAGS ('dbx_business_glossary_term' = 'Price Uplift Reason (UPLIFT_REASON)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `price_version` SET TAGS ('dbx_business_glossary_term' = 'Price Version (VER)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ALTER COLUMN `trim_level` SET TAGS ('dbx_business_glossary_term' = 'Trim Level (TRIM)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` SET TAGS ('dbx_subdomain' = 'physical_instances');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `lifecycle_event_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Lifecycle Event ID');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_category` SET TAGS ('dbx_business_glossary_term' = 'Event Category');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_description` SET TAGS ('dbx_business_glossary_term' = 'Event Description');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_location_city` SET TAGS ('dbx_business_glossary_term' = 'Event Location City');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_location_city` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_location_country` SET TAGS ('dbx_business_glossary_term' = 'Event Location Country Code');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_location_country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_location_latitude` SET TAGS ('dbx_business_glossary_term' = 'Event Latitude (degrees)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_location_latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_location_latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_location_longitude` SET TAGS ('dbx_business_glossary_term' = 'Event Longitude (degrees)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_location_longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_location_longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_location_state` SET TAGS ('dbx_business_glossary_term' = 'Event Location State/Province');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_notes` SET TAGS ('dbx_business_glossary_term' = 'Event Notes');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Event Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_source_module` SET TAGS ('dbx_business_glossary_term' = 'Event Source Module');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_source_reference` SET TAGS ('dbx_business_glossary_term' = 'Event Source Reference');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_source_system` SET TAGS ('dbx_business_glossary_term' = 'Event Source System');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_status` SET TAGS ('dbx_business_glossary_term' = 'Event Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_status` SET TAGS ('dbx_value_regex' = 'active|completed|failed');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_subtype` SET TAGS ('dbx_business_glossary_term' = 'Event Subtype');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Event Type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `is_critical` SET TAGS ('dbx_business_glossary_term' = 'Critical Event Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `odometer_reading_km` SET TAGS ('dbx_business_glossary_term' = 'Odometer Reading (km)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `triggering_system` SET TAGS ('dbx_business_glossary_term' = 'Triggering System');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_emissions_certification` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_emissions_certification` SET TAGS ('dbx_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_emissions_certification` ALTER COLUMN `vehicle_emissions_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for vehicle_emissions_certification');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_emissions_certification` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` SET TAGS ('dbx_subdomain' = 'physical_instances');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` SET TAGS ('dbx_association_edges' = 'vehicle.vin_registry,mobility.ota_campaign');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` ALTER COLUMN `vehicle_ota_deployment_id` SET TAGS ('dbx_business_glossary_term' = 'Ota Deployment - Ota Deployment Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` ALTER COLUMN `ota_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Ota Deployment - Ota Campaign Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Ota Deployment - Vin Registry Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` ALTER COLUMN `consent_given` SET TAGS ('dbx_business_glossary_term' = 'Consent Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` ALTER COLUMN `deployment_initiated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Deployment Initiated Time');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` ALTER COLUMN `download_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Download Start Time');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` ALTER COLUMN `install_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Install Start Time');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` ALTER COLUMN `post_software_version` SET TAGS ('dbx_business_glossary_term' = 'Post‑Update Software Version');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` ALTER COLUMN `pre_software_version` SET TAGS ('dbx_business_glossary_term' = 'Pre‑Update Software Version');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` ALTER COLUMN `vehicle_ota_deployment_status` SET TAGS ('dbx_business_glossary_term' = 'Deployment Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` SET TAGS ('dbx_subdomain' = 'physical_instances');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` SET TAGS ('dbx_association_edges' = 'vehicle.vin_registry,customer.party');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` ALTER COLUMN `ownership_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Ownership - Vehicle Ownership Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Ownership - Party Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Ownership - Vin Registry Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` ALTER COLUMN `acquisition_date` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` ALTER COLUMN `disposition_date` SET TAGS ('dbx_business_glossary_term' = 'Disposition Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` ALTER COLUMN `ownership_number` SET TAGS ('dbx_business_glossary_term' = 'Ownership Number');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` ALTER COLUMN `ownership_type` SET TAGS ('dbx_business_glossary_term' = 'Ownership Type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` SET TAGS ('dbx_subdomain' = 'physical_instances');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` SET TAGS ('dbx_association_edges' = 'vehicle.vin_registry,aftersales.service_campaign');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ALTER COLUMN `campaign_enrollment_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Campaign Enrollment - Vehicle Campaign Enrollment Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ALTER COLUMN `service_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Campaign Enrollment - Service Campaign Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Campaign Enrollment - Vin Registry Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ALTER COLUMN `labor_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Campaign Enrollment - Labor Time Hours');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ALTER COLUMN `notification_date` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Campaign Enrollment - Notification Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ALTER COLUMN `notification_status` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Campaign Enrollment - Notification Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ALTER COLUMN `parts_consumed` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Campaign Enrollment - Parts Consumed');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ALTER COLUMN `remedy_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Campaign Enrollment - Remedy Completion Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ALTER COLUMN `scheduled_service_date` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Campaign Enrollment - Scheduled Service Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ALTER COLUMN `total_labor_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Campaign Enrollment - Total Labor Cost Usd');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ALTER COLUMN `total_parts_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Campaign Enrollment - Total Parts Cost Usd');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ALTER COLUMN `total_remedy_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Campaign Enrollment - Total Remedy Cost Usd');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ALTER COLUMN `warranty_covered` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Campaign Enrollment - Warranty Covered');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` SET TAGS ('dbx_subdomain' = 'regulatory_certification');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` SET TAGS ('dbx_association_edges' = 'vehicle.model,compliance.regulatory_requirement');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` ALTER COLUMN `regulatory_compliance_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatorycomplianceassignment - Model Regulation Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatorycomplianceassignment - Model Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatorycomplianceassignment - Regulatory Requirement Id');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Compliance Notes');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` SET TAGS ('dbx_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `powertrain_config_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Configuration ID');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `product_nameplate_id` SET TAGS ('dbx_business_glossary_term' = 'Nameplate ID');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Plant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `powertrain_spec_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Spec Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `aspiration_type` SET TAGS ('dbx_business_glossary_term' = 'Aspiration Type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `aspiration_type` SET TAGS ('dbx_value_regex' = 'naturally_aspirated|turbocharged|supercharged|twin_turbo');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_business_glossary_term' = 'Battery Capacity (Kilowatt-Hours)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `battery_chemistry` SET TAGS ('dbx_business_glossary_term' = 'Battery Chemistry Type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `battery_chemistry` SET TAGS ('dbx_value_regex' = 'none|lithium_ion|nickel_metal_hydride|solid_state|lithium_iron_phosphate');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `cafe_credit_value` SET TAGS ('dbx_business_glossary_term' = 'Corporate Average Fuel Economy (CAFE) Credit Value');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `charging_capability` SET TAGS ('dbx_business_glossary_term' = 'Charging Capability Level');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `charging_capability` SET TAGS ('dbx_value_regex' = 'none|level_1|level_2|dc_fast_charge|ultra_fast_charge');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `co2_emissions_g_km` SET TAGS ('dbx_business_glossary_term' = 'Carbon Dioxide (CO2) Emissions (Grams per Kilometer)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `combined_horsepower` SET TAGS ('dbx_business_glossary_term' = 'Combined Horsepower (HP)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `combined_torque_nm` SET TAGS ('dbx_business_glossary_term' = 'Combined Torque (Newton-Meters)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `cylinder_count` SET TAGS ('dbx_business_glossary_term' = 'Cylinder Count');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `dealer_invoice_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Dealer Invoice Cost (US Dollars)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `dealer_invoice_cost_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `drivetrain_layout` SET TAGS ('dbx_business_glossary_term' = 'Drivetrain Layout');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `drivetrain_layout` SET TAGS ('dbx_value_regex' = 'fwd|rwd|awd|4wd');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `electric_motor_position` SET TAGS ('dbx_business_glossary_term' = 'Electric Motor Position');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `electric_motor_position` SET TAGS ('dbx_value_regex' = 'none|front|rear|front_rear|integrated');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `electric_motor_type` SET TAGS ('dbx_business_glossary_term' = 'Electric Motor Configuration');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `electric_motor_type` SET TAGS ('dbx_value_regex' = 'none|single_motor|dual_motor|tri_motor|quad_motor');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `emissions_standard` SET TAGS ('dbx_business_glossary_term' = 'Emissions Standard Certification');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `emissions_standard` SET TAGS ('dbx_value_regex' = 'euro_6|tier_3|lev_iii|ulev|sulev|zlev');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `end_of_production_date` SET TAGS ('dbx_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `engine_configuration` SET TAGS ('dbx_business_glossary_term' = 'Engine Configuration');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `engine_configuration` SET TAGS ('dbx_value_regex' = 'inline|v_type|flat|rotary|w_type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `engine_displacement_liters` SET TAGS ('dbx_business_glossary_term' = 'Engine Displacement (Liters)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `epa_city_mpg` SET TAGS ('dbx_business_glossary_term' = 'Environmental Protection Agency (EPA) City Fuel Economy (Miles Per Gallon)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `epa_city_mpg` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `epa_combined_mpg` SET TAGS ('dbx_business_glossary_term' = 'Environmental Protection Agency (EPA) Combined Fuel Economy (Miles Per Gallon)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `epa_electric_range_miles` SET TAGS ('dbx_business_glossary_term' = 'Environmental Protection Agency (EPA) All-Electric Range (Miles)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `epa_highway_mpg` SET TAGS ('dbx_business_glossary_term' = 'Environmental Protection Agency (EPA) Highway Fuel Economy (Miles Per Gallon)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `fuel_type` SET TAGS ('dbx_business_glossary_term' = 'Fuel Type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `fuel_type` SET TAGS ('dbx_value_regex' = 'gasoline|diesel|electric|hydrogen|flex_fuel|cng');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `homologation_status` SET TAGS ('dbx_business_glossary_term' = 'Homologation Certification Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `homologation_status` SET TAGS ('dbx_value_regex' = 'certified|pending|not_required|expired');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `manufacturing_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Cost (US Dollars)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `manufacturing_cost_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `market_availability` SET TAGS ('dbx_business_glossary_term' = 'Market Availability Region');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `market_availability` SET TAGS ('dbx_value_regex' = 'global|north_america|europe|asia_pacific|china|japan');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `max_charging_power_kw` SET TAGS ('dbx_business_glossary_term' = 'Maximum Charging Power (Kilowatts)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `msrp_base_usd` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Base Amount (US Dollars)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `msrp_base_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `payload_capacity_lbs` SET TAGS ('dbx_business_glossary_term' = 'Maximum Payload Capacity (Pounds)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `payload_capacity_lbs` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `powertrain_code` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Code');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `powertrain_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `powertrain_config_status` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Configuration Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `powertrain_config_status` SET TAGS ('dbx_value_regex' = 'active|discontinued|planned|phase_out');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `powertrain_name` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Marketing Name');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV|MHEV');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `start_of_production_date` SET TAGS ('dbx_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `towing_capacity_lbs` SET TAGS ('dbx_business_glossary_term' = 'Maximum Towing Capacity (Pounds)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `towing_capacity_lbs` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `transmission_speeds` SET TAGS ('dbx_business_glossary_term' = 'Transmission Speed Count');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `transmission_type` SET TAGS ('dbx_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `transmission_type` SET TAGS ('dbx_value_regex' = 'manual|automatic|cvt|dct|amt|single_speed');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `warranty_battery_miles` SET TAGS ('dbx_business_glossary_term' = 'Battery Warranty Mileage Limit (Miles)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `warranty_battery_months` SET TAGS ('dbx_business_glossary_term' = 'Battery Warranty Duration (Months)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `warranty_powertrain_miles` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Warranty Mileage Limit (Miles)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `warranty_powertrain_months` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Warranty Duration (Months)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `wltp_city_range_km` SET TAGS ('dbx_business_glossary_term' = 'Worldwide Harmonised Light Vehicles Test Procedure (WLTP) City Range (Kilometers)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `wltp_city_range_km` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `wltp_combined_range_km` SET TAGS ('dbx_business_glossary_term' = 'Worldwide Harmonised Light Vehicles Test Procedure (WLTP) Combined Range (Kilometers)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ALTER COLUMN `zero_to_sixty_seconds` SET TAGS ('dbx_business_glossary_term' = 'Zero to Sixty Miles Per Hour Acceleration Time (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_body_style` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_body_style` SET TAGS ('dbx_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_color_option` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_color_option` SET TAGS ('dbx_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` SET TAGS ('dbx_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` SET TAGS ('dbx_retention' = 'preserve_core_coverage');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `aftersales_color_option_id` SET TAGS ('dbx_business_glossary_term' = 'Color Option ID');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `color_availability_status` SET TAGS ('dbx_business_glossary_term' = 'Color Availability Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `color_availability_status` SET TAGS ('dbx_value_regex' = 'active|discontinued|limited_availability|pre_launch|phase_out');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `color_code` SET TAGS ('dbx_business_glossary_term' = 'Color Code');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `color_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `color_description` SET TAGS ('dbx_business_glossary_term' = 'Color Description');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `color_durability_rating` SET TAGS ('dbx_business_glossary_term' = 'Color Durability Rating');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `color_durability_rating` SET TAGS ('dbx_value_regex' = 'standard|enhanced|premium');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `color_family` SET TAGS ('dbx_business_glossary_term' = 'Color Family');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `color_image_url` SET TAGS ('dbx_business_glossary_term' = 'Color Image Uniform Resource Locator (URL)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `color_image_url` SET TAGS ('dbx_value_regex' = '^https?://.*.(jpg|jpeg|png|webp)$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `color_match_tolerance` SET TAGS ('dbx_business_glossary_term' = 'Color Match Tolerance');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `color_name` SET TAGS ('dbx_business_glossary_term' = 'Color Name');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `color_type` SET TAGS ('dbx_business_glossary_term' = 'Color Type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `color_type` SET TAGS ('dbx_value_regex' = 'exterior|interior|both');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `end_of_production_date` SET TAGS ('dbx_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `environmental_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Environmental Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `historical_sales_volume` SET TAGS ('dbx_business_glossary_term' = 'Historical Sales Volume');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `historical_sales_volume` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `interior_material_type` SET TAGS ('dbx_business_glossary_term' = 'Interior Material Type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Days');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `marketing_priority_rank` SET TAGS ('dbx_business_glossary_term' = 'Marketing Priority Rank');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `msrp_uplift_amount` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Uplift Amount');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `package_compatibility` SET TAGS ('dbx_business_glossary_term' = 'Package Compatibility');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `paint_code_supplier` SET TAGS ('dbx_business_glossary_term' = 'Paint Code Supplier Reference');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `paint_technology` SET TAGS ('dbx_business_glossary_term' = 'Paint Technology');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `paint_technology` SET TAGS ('dbx_value_regex' = 'solid|metallic|pearl|matte|tri-coat|multi-stage');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `production_cost_delta` SET TAGS ('dbx_business_glossary_term' = 'Production Cost Delta');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `production_cost_delta` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `regional_availability` SET TAGS ('dbx_business_glossary_term' = 'Regional Availability');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `special_order_flag` SET TAGS ('dbx_business_glossary_term' = 'Special Order Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `start_of_production_date` SET TAGS ('dbx_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `touch_up_paint_available_flag` SET TAGS ('dbx_business_glossary_term' = 'Touch-Up Paint Available Flag');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `trim_level_compatibility` SET TAGS ('dbx_business_glossary_term' = 'Trim Level Compatibility');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` ALTER COLUMN `voc_content_grams_per_liter` SET TAGS ('dbx_business_glossary_term' = 'Volatile Organic Compound (VOC) Content Grams Per Liter');
