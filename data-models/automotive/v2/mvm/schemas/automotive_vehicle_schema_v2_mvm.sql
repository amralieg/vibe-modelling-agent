-- Schema for Domain: vehicle | Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-13 17:05:59

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`vehicle` COMMENT 'SSOT for all vehicle master data across the enterprise. Owns VIN-level vehicle identity, model configurations, trim levels, MY (Model Year) lifecycle from SOP (Start of Production) to EOP (End of Production), powertrain variants (ICE, HEV, PHEV, EV), platform architectures, and ADAS feature sets. Serves as the authoritative reference for every downstream domain that needs to identify or describe a vehicle instance.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` (
    `vin_registry_id` BIGINT COMMENT '',
    `bom_id` BIGINT COMMENT 'Foreign key linking to engineering.bom. Business justification: Vehicle build traceability: each VIN is manufactured to a specific BOM revision. Warranty claims, recall scoping, and field quality investigations require knowing which exact BOM was used to build a g',
    `configuration_id` BIGINT COMMENT '',
    `ecu_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.ecu_specification. Business justification: Build-time ECU traceability: each VIN has a specific ECU spec installed at the plant. Recall management, OTA eligibility determination, and diagnostic trouble code support require knowing which ecu_sp',
    `plant_id` BIGINT COMMENT '',
    `powertrain_spec_id` BIGINT COMMENT 'Foreign key linking to engineering.powertrain_spec. Business justification: Emissions compliance and warranty management require knowing which powertrain_spec was installed in each VIN. Regulatory reporting (EPA, WLTP) and field quality investigations depend on this build-tim',
    `battery_capacity_kwh` DECIMAL(18,2) COMMENT '',
    `build_date` DATE COMMENT '',
    `check_digit` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `curb_weight_kg` DECIMAL(18,2) COMMENT '',
    `destination_market` STRING COMMENT '',
    `emission_standard` STRING COMMENT '',
    `eop_date` DATE COMMENT '',
    `epa_combined_mpg` DECIMAL(18,2) COMMENT '',
    `fuel_tank_capacity_liters` DECIMAL(18,2) COMMENT '',
    `gvwr_kg` DECIMAL(18,2) COMMENT '',
    `homologation_market` STRING COMMENT '',
    `last_modified_timestamp` TIMESTAMP COMMENT '',
    `line_off_timestamp` TIMESTAMP COMMENT '',
    `model_year_decoded` STRING COMMENT '',
    `msrp_currency_code` STRING COMMENT '',
    `obd_protocol` STRING COMMENT '',
    `production_sequence_number` STRING COMMENT '',
    `recall_flag` BOOLEAN COMMENT '',
    `safety_rating` STRING COMMENT '',
    `sop_date` DATE COMMENT '',
    `telematics_enabled_flag` BOOLEAN COMMENT '',
    `vds` STRING COMMENT '',
    `vehicle_lifecycle_status` STRING COMMENT '',
    `vin` STRING COMMENT '',
    `vis` STRING COMMENT '',
    `warranty_end_date` DATE COMMENT '',
    `warranty_start_date` DATE COMMENT '',
    `wltp_combined_consumption` DECIMAL(18,2) COMMENT '',
    `wmi` STRING COMMENT '',
    CONSTRAINT pk_vin_registry PRIMARY KEY(`vin_registry_id`)
) COMMENT 'Vehicle Identification Number registry tracking every produced vehicle.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`model` (
    `model_id` BIGINT COMMENT '',
    `plant_id` BIGINT COMMENT '',
    `platform_id` BIGINT COMMENT '',
    `vehicle_program_id` BIGINT COMMENT '',
    `body_style` STRING COMMENT '',
    `brand_name` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `model_description` STRING COMMENT '',
    `eop_date` DATE COMMENT '',
    `fuel_type` STRING COMMENT '',
    `launch_model_year` STRING COMMENT '',
    `model_status` STRING COMMENT '',
    `model_name` STRING COMMENT '',
    `powertrain_type` STRING COMMENT '',
    `segment` STRING COMMENT '',
    `sop_date` DATE COMMENT '',
    `ssot_governance_note` STRING COMMENT '',
    `updated_timestamp` TIMESTAMP COMMENT '',
    CONSTRAINT pk_model PRIMARY KEY(`model_id`)
) COMMENT 'Vehicle model definitions.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`platform` (
    `platform_id` BIGINT COMMENT '',
    `vehicle_program_id` BIGINT COMMENT '',
    `architecture` STRING COMMENT '',
    `platform_code` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `platform_name` STRING COMMENT '',
    `platform_status` STRING COMMENT '',
    CONSTRAINT pk_platform PRIMARY KEY(`platform_id`)
) COMMENT 'Vehicle platform definitions.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`configuration` (
    `configuration_id` BIGINT COMMENT '',
    `bom_id` BIGINT COMMENT 'Foreign key linking to engineering.bom. Business justification: Configuration-to-BOM mapping is a core automotive PDM process: each vehicle configuration (model year + trim + plant) is governed by a specific BOM. Production planning, change management impact analy',
    `model_id` BIGINT COMMENT '',
    `configuration_trim_level_model_id` BIGINT COMMENT 'Foreign key linking to vehicle.vehicle_trim_level. Business justification: A vehicle configuration is defined as the combination of trim level, options, and powertrain. vehicle_trim_level is the authoritative trim-level entity in this domain, and configuration should carry a',
    `plant_id` BIGINT COMMENT '',
    `platform_id` BIGINT COMMENT '',
    `powertrain_spec_id` BIGINT COMMENT 'Foreign key linking to engineering.powertrain_spec. Business justification: Each vehicle configuration specifies a powertrain variant. Homologation approval, order management, and MSRP pricing depend on knowing which powertrain_spec applies to a given configuration. This is a',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Option packages (sunroof, technology, towing packages) are procured and stocked as SKUs. Linking vehicle_option_package to sku_master enables parts ordering, aftersales parts lookup for installed opti',
    `configuration_code` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `model_year` STRING COMMENT '',
    `price_amount` DECIMAL(18,2) COMMENT '',
    CONSTRAINT pk_configuration PRIMARY KEY(`configuration_id`)
) COMMENT 'Vehicle configuration combining trim, options, powertrain.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` (
    `build_spec_id` BIGINT COMMENT '',
    `bom_id` BIGINT COMMENT 'Foreign key linking to engineering.bom. Business justification: Build_spec captures the actual BOM revision used at build time for a specific VIN, which may differ from the configurations nominal BOM due to mid-year engineering change orders. Manufacturing audit ',
    `change_id` BIGINT COMMENT 'Foreign key linking to engineering.change. Business justification: Engineering change orders (ECOs) trigger build spec updates. Linking build_spec to the triggering engineering change supports ECO impact traceability, production audit trails, and change effectivity v',
    `configuration_id` BIGINT COMMENT '',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Build-to-order traceability: automotive OEMs link each build spec to the originating sales order for production scheduling and order fulfillment tracking. A domain expert expects build_spec to referen',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: build_spec contains a raw `vin` STRING column that is a denormalized copy of the VIN. vin_registry is the enterprise SSOT for all VIN-level vehicle identity. Adding a FK build_spec.vin_registry_id → v',
    `build_date` DATE COMMENT '',
    CONSTRAINT pk_build_spec PRIMARY KEY(`build_spec_id`)
) COMMENT 'Vehicle build specification.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` (
    `lifecycle_event_id` BIGINT COMMENT '',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Key lifecycle events — PDI completion, retail delivery, recall service completion — occur at specific dealerships. Linking lifecycle_event to dealership enables dealer-level lifecycle audit reporting,',
    `vin_registry_id` BIGINT COMMENT '',
    `event_timestamp` TIMESTAMP COMMENT '',
    `event_type` STRING COMMENT '',
    CONSTRAINT pk_lifecycle_event PRIMARY KEY(`lifecycle_event_id`)
) COMMENT 'Vehicle lifecycle events.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`ownership` (
    `ownership_id` BIGINT COMMENT '',
    `party_id` BIGINT COMMENT '',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Ownership provenance tracking: automotive title and registration workflows require linking each ownership record to the originating sales transaction. Supports ownership history audits, warranty regis',
    `vin_registry_id` BIGINT COMMENT '',
    `ownership_type` STRING COMMENT '',
    CONSTRAINT pk_ownership PRIMARY KEY(`ownership_id`)
) COMMENT 'Vehicle ownership records.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` (
    `connected_vehicle_id` BIGINT COMMENT 'Unique surrogate key for the connected vehicle record.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Sales Attribution Report links each connected vehicle to the dealer that sold it, enabling dealer‑level warranty and service responsibility.',
    `ecu_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.ecu_specification. Business justification: Connected vehicle operations require knowing which ECU spec governs OTA update eligibility, diagnostic trouble code support, and software lifecycle management. This link enables OTA campaign targeting',
    `fleet_contract_id` BIGINT COMMENT 'Foreign key linking to sales.fleet_contract. Business justification: Fleet telematics contract governance: connected vehicles deployed in fleet accounts operate under fleet contracts that define SLA levels, connectivity tiers, and billing terms. Direct FK enables conne',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Regulatory Homologation Report requires linking each vehicle to its homologation record for market approval tracking.',
    `organization_account_id` BIGINT COMMENT 'Identifier of the fleet to which the vehicle belongs, if applicable.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Needed to identify the legal owner for billing, data‑privacy compliance, and service entitlement of each connected vehicle.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Fleet driver assignment report requires linking each vehicle to its current driver employee for compliance and usage tracking.',
    `powertrain_spec_id` BIGINT COMMENT 'Foreign key linking to engineering.powertrain_spec. Business justification: Connected vehicle service campaigns and OTA updates are powertrain-specific. Linking to powertrain_spec replaces the denormalized powertrain_type plain attribute and enables powertrain-targeted remote',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Warranty and service management need the exact SKU for each connected vehicle to determine coverage, parts, and service intervals.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Required for warranty, recall and OTA management linking each connected vehicle to the official VIN registry record.',
    `activation_status` STRING COMMENT 'Current lifecycle state of the device activation.. Valid values are `inactive|active|suspended|decommissioned`',
    `activation_timestamp` TIMESTAMP COMMENT 'Date and time when the device was first activated.',
    `battery_health_percent` DECIMAL(18,2) COMMENT 'Estimated health of the battery relative to its original capacity.',
    `battery_state_of_charge_percent` DECIMAL(18,2) COMMENT 'Current state of charge of the vehicles battery expressed as a percentage.',
    `connectivity_tier` STRING COMMENT 'Service tier defining data allowance and priority for the vehicle.. Valid values are `basic|standard|premium`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the connected vehicle record was first created in the lakehouse.',
    `data_plan` STRING COMMENT 'Subscription plan governing cellular data usage.. Valid values are `none|payg|monthly|annual`',
    `data_usage_gb` DECIMAL(18,2) COMMENT 'Cumulative cellular data consumed by the vehicle in the current billing cycle.',
    `data_usage_last_reset` DATE COMMENT 'Date when the data usage counter was last reset.',
    `deactivation_timestamp` TIMESTAMP COMMENT 'Date and time when the device was deactivated or retired.',
    `device_type` STRING COMMENT 'Model or family of the connected telematics device.. Valid values are `Geotab_GO|Bosch_IoT|Continental|Delphi|Valeo|Denso`',
    `diagnostic_status` STRING COMMENT 'Overall health status derived from the latest diagnostic data.. Valid values are `ok|warning|critical`',
    `firmware_version` STRING COMMENT 'Current firmware version installed on the telematics device.',
    `geographic_region` STRING COMMENT 'Three‑letter ISO country code representing the primary market of the vehicle.. Valid values are `USA|CAN|MEX|DEU|JPN|CHN`',
    `last_diagnostic_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent vehicle diagnostic event.',
    `last_error_code` STRING COMMENT 'Most recent Diagnostic Trouble Code reported by the vehicle.',
    `last_ota_update_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent Over‑The‑Air software update.',
    `last_tpms_update_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent TPMS firmware or configuration update.',
    `last_v2x_update_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent V2X software update.',
    `manufacturer` STRING COMMENT 'Original Equipment Manufacturer of the vehicle.',
    `mileage_km` DECIMAL(18,2) COMMENT 'Total distance traveled by the vehicle, reported in kilometers.',
    `mileage_last_update` TIMESTAMP COMMENT 'Timestamp of the most recent mileage reading.',
    `model_year` STRING COMMENT 'Model year of the vehicle (calendar year).',
    `ota_capability` BOOLEAN COMMENT 'Indicates whether the vehicle supports Over-The-Air updates.',
    `registration_date` DATE COMMENT 'Date the vehicle was enrolled in the connected mobility program.',
    `registration_status` STRING COMMENT 'Current status of the vehicles connectivity service registration.. Valid values are `registered|pending|rejected`',
    `sim_iccid` STRING COMMENT 'Integrated Circuit Card Identifier of the SIM/eSIM used for connectivity.',
    `sim_imsi` STRING COMMENT 'International Mobile Subscriber Identity associated with the SIM.',
    `software_version` STRING COMMENT 'Version of the vehicles on‑board software platform.',
    `subscription_end_date` DATE COMMENT 'Date when the current subscription plan expires (null if open‑ended).',
    `subscription_plan` STRING COMMENT 'Service plan governing feature entitlements for the connected vehicle.. Valid values are `basic|standard|premium|enterprise`',
    `subscription_start_date` DATE COMMENT 'Date when the current subscription plan became effective.',
    `tpms_capability` BOOLEAN COMMENT 'Indicates whether the vehicle is equipped with Tire Pressure Monitoring System telemetry.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the connected vehicle record.',
    `v2x_capability` BOOLEAN COMMENT 'Indicates whether the vehicle can communicate Vehicle‑to‑Everything.',
    `vehicle_type` STRING COMMENT 'Broad category of the vehicle.. Valid values are `car|truck|suv|commercial|ev|phev`',
    `vin` STRING COMMENT 'Globally unique identifier assigned to each vehicle by the manufacturer.',
    `warranty_expiration_date` DATE COMMENT 'Date when the vehicles warranty coverage ends.',
    `warranty_status` STRING COMMENT 'Current warranty coverage status of the vehicle.. Valid values are `in_warranty|out_of_warranty|extended`',
    CONSTRAINT pk_connected_vehicle PRIMARY KEY(`connected_vehicle_id`)
) COMMENT 'Master registry of all connected vehicles enrolled in mobility and telematics services. Owns the connected device identity per VIN, connectivity hardware profile (Geotab/Bosch IoT device), SIM/eSIM identifiers, connectivity tier, activation status, OTA capability flags, V2X capability flags, and TPMS sensor registration. This is the SSOT for connected vehicle device identity within the mobility domain, distinct from the vehicle master in the vehicle domain which owns VIN-level manufacturing identity. Links to telematics_device for hardware asset details.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ADD CONSTRAINT `fk_vehicle_vin_registry_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ADD CONSTRAINT `fk_vehicle_model_platform_id` FOREIGN KEY (`platform_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`platform`(`platform_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_configuration_trim_level_model_id` FOREIGN KEY (`configuration_trim_level_model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_platform_id` FOREIGN KEY (`platform_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`platform`(`platform_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ADD CONSTRAINT `fk_vehicle_build_spec_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ADD CONSTRAINT `fk_vehicle_build_spec_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ADD CONSTRAINT `fk_vehicle_lifecycle_event_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` ADD CONSTRAINT `fk_vehicle_ownership_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ADD CONSTRAINT `fk_vehicle_connected_vehicle_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ADD CONSTRAINT `fk_vehicle_connected_vehicle_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`vehicle` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`vehicle` SET TAGS ('dbx_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` SET TAGS ('dbx_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `bom_id` SET TAGS ('dbx_business_glossary_term' = 'Bom Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `ecu_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Ecu Specification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `powertrain_spec_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Spec Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` SET TAGS ('dbx_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` SET TAGS ('dbx_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` SET TAGS ('dbx_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `bom_id` SET TAGS ('dbx_business_glossary_term' = 'Bom Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `configuration_trim_level_model_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Trim Level Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `powertrain_spec_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Spec Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` SET TAGS ('dbx_subdomain' = 'product_definition');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `bom_id` SET TAGS ('dbx_business_glossary_term' = 'Bom Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `change_id` SET TAGS ('dbx_business_glossary_term' = 'Change Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` SET TAGS ('dbx_subdomain' = 'ownership_tracking');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` SET TAGS ('dbx_subdomain' = 'ownership_tracking');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` SET TAGS ('dbx_subdomain' = 'ownership_tracking');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_business_glossary_term' = 'Connected Vehicle ID');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `ecu_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Ecu Specification Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `organization_account_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet ID');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Owner Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Driver Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `powertrain_spec_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Spec Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `activation_status` SET TAGS ('dbx_business_glossary_term' = 'Activation Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `activation_status` SET TAGS ('dbx_value_regex' = 'inactive|active|suspended|decommissioned');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `activation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Activation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `battery_health_percent` SET TAGS ('dbx_business_glossary_term' = 'Battery Health (%)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `battery_health_percent` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `battery_health_percent` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `battery_state_of_charge_percent` SET TAGS ('dbx_business_glossary_term' = 'Battery State of Charge (%)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `battery_state_of_charge_percent` SET TAGS ('dbx_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `connectivity_tier` SET TAGS ('dbx_business_glossary_term' = 'Connectivity Tier');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `connectivity_tier` SET TAGS ('dbx_value_regex' = 'basic|standard|premium');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `data_plan` SET TAGS ('dbx_business_glossary_term' = 'Data Plan');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `data_plan` SET TAGS ('dbx_value_regex' = 'none|payg|monthly|annual');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `data_usage_gb` SET TAGS ('dbx_business_glossary_term' = 'Data Usage (GB)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `data_usage_last_reset` SET TAGS ('dbx_business_glossary_term' = 'Data Usage Reset Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `deactivation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Deactivation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `device_type` SET TAGS ('dbx_business_glossary_term' = 'Device Type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `device_type` SET TAGS ('dbx_value_regex' = 'Geotab_GO|Bosch_IoT|Continental|Delphi|Valeo|Denso');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `diagnostic_status` SET TAGS ('dbx_business_glossary_term' = 'Diagnostic Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `diagnostic_status` SET TAGS ('dbx_value_regex' = 'ok|warning|critical');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `firmware_version` SET TAGS ('dbx_business_glossary_term' = 'Firmware Version');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `geographic_region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `geographic_region` SET TAGS ('dbx_value_regex' = 'USA|CAN|MEX|DEU|JPN|CHN');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `geographic_region` SET TAGS ('dbx_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `last_diagnostic_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Diagnostic Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `last_error_code` SET TAGS ('dbx_business_glossary_term' = 'Last DTC Code');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `last_ota_update_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last OTA Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `last_tpms_update_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last TPMS Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `last_v2x_update_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last V2X Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `manufacturer` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Manufacturer');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `mileage_km` SET TAGS ('dbx_business_glossary_term' = 'Mileage (km)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `mileage_last_update` SET TAGS ('dbx_business_glossary_term' = 'Mileage Last Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `ota_capability` SET TAGS ('dbx_business_glossary_term' = 'OTA Capability');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `registration_date` SET TAGS ('dbx_business_glossary_term' = 'Registration Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `registration_status` SET TAGS ('dbx_business_glossary_term' = 'Registration Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `registration_status` SET TAGS ('dbx_value_regex' = 'registered|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `sim_iccid` SET TAGS ('dbx_business_glossary_term' = 'SIM ICCID');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `sim_iccid` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `sim_iccid` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `sim_iccid` SET TAGS ('dbx_pii_device_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `sim_imsi` SET TAGS ('dbx_business_glossary_term' = 'SIM IMSI');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `sim_imsi` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `sim_imsi` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `sim_imsi` SET TAGS ('dbx_pii_device_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `software_version` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Software Version');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `subscription_end_date` SET TAGS ('dbx_business_glossary_term' = 'Subscription End Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `subscription_plan` SET TAGS ('dbx_business_glossary_term' = 'Subscription Plan');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `subscription_plan` SET TAGS ('dbx_value_regex' = 'basic|standard|premium|enterprise');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `subscription_start_date` SET TAGS ('dbx_business_glossary_term' = 'Subscription Start Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `tpms_capability` SET TAGS ('dbx_business_glossary_term' = 'TPMS Capability');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `v2x_capability` SET TAGS ('dbx_business_glossary_term' = 'V2X Capability');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Type');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_value_regex' = 'car|truck|suv|commercial|ev|phev');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `vin` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `vin` SET TAGS ('dbx_pii_vehicle_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `warranty_expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `warranty_status` SET TAGS ('dbx_business_glossary_term' = 'Warranty Status');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ALTER COLUMN `warranty_status` SET TAGS ('dbx_value_regex' = 'in_warranty|out_of_warranty|extended');
