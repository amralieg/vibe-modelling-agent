-- Schema for Domain: vehicle | Business:  | Version: v2_ecm
-- Generated on: 2026-07-13 15:03:55

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`vehicle` COMMENT 'SSOT for all vehicle master data across the enterprise. Owns VIN-level vehicle identity, model configurations, trim levels, MY (Model Year) lifecycle from SOP (Start of Production) to EOP (End of Production), powertrain variants (ICE, HEV, PHEV, EV), platform architectures, and ADAS feature sets. Serves as the authoritative reference for every downstream domain that needs to identify or describe a vehicle instance.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` (
    `vin_registry_id` BIGINT COMMENT '',
    `aftersales_body_style_id` BIGINT COMMENT '',
    `aftersales_color_option_id` BIGINT COMMENT '',
    `configuration_id` BIGINT COMMENT '',
    `aftersales_nameplate_id` BIGINT COMMENT '',
    `telematics_device_id` BIGINT COMMENT '',
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
    `plant_code` STRING COMMENT '',
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
    `aftersales_nameplate_id` BIGINT COMMENT '',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_model_year_program` (
    `vehicle_model_year_program_id` BIGINT COMMENT '',
    `aftersales_model_year_program_id` BIGINT COMMENT '',
    `model_id` BIGINT COMMENT '',
    CONSTRAINT pk_vehicle_model_year_program PRIMARY KEY(`vehicle_model_year_program_id`)
) COMMENT 'Vehicle model year program linkage.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` (
    `vehicle_trim_level_id` BIGINT COMMENT '',
    `aftersales_trim_level_id` BIGINT COMMENT '',
    `aftersales_body_style_id` BIGINT COMMENT '',
    `aftersales_color_option_id` BIGINT COMMENT '',
    `model_id` BIGINT COMMENT '',
    CONSTRAINT pk_vehicle_trim_level PRIMARY KEY(`vehicle_trim_level_id`)
) COMMENT 'Vehicle trim level linkage.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` (
    `powertrain_variant_id` BIGINT COMMENT '',
    `powertrain_config_id` BIGINT COMMENT '',
    `powertrain_type` STRING COMMENT '',
    `variant_code` STRING COMMENT '',
    `variant_name` STRING COMMENT '',
    CONSTRAINT pk_powertrain_variant PRIMARY KEY(`powertrain_variant_id`)
) COMMENT 'Powertrain variant details.';

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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_adas_feature` (
    `vehicle_adas_feature_id` BIGINT COMMENT '',
    `engineering_adas_feature_id` BIGINT COMMENT '',
    CONSTRAINT pk_vehicle_adas_feature PRIMARY KEY(`vehicle_adas_feature_id`)
) COMMENT 'Reference to SSOT owner engineering.engineering_adas_feature. Vehicle ADAS feature assignments.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`configuration` (
    `configuration_id` BIGINT COMMENT '',
    `aftersales_body_style_id` BIGINT COMMENT '',
    `model_id` BIGINT COMMENT '',
    `aftersales_nameplate_id` BIGINT COMMENT '',
    `platform_id` BIGINT COMMENT '',
    `configuration_code` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `model_year` STRING COMMENT '',
    CONSTRAINT pk_configuration PRIMARY KEY(`configuration_id`)
) COMMENT 'Vehicle configuration combining trim, options, powertrain.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` (
    `vehicle_option_package_id` BIGINT COMMENT '',
    `aftersales_option_package_id` BIGINT COMMENT '',
    `configuration_id` BIGINT COMMENT '',
    CONSTRAINT pk_vehicle_option_package PRIMARY KEY(`vehicle_option_package_id`)
) COMMENT 'Vehicle option package assignments.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` (
    `build_spec_id` BIGINT COMMENT '',
    `configuration_id` BIGINT COMMENT '',
    `build_date` DATE COMMENT '',
    `vin` STRING COMMENT '',
    CONSTRAINT pk_build_spec PRIMARY KEY(`build_spec_id`)
) COMMENT 'Vehicle build specification.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`homologation` (
    `homologation_id` BIGINT COMMENT '',
    `configuration_id` BIGINT COMMENT '',
    `homologation_variant_id` BIGINT COMMENT '',
    `certificate_number` STRING COMMENT '',
    CONSTRAINT pk_homologation PRIMARY KEY(`homologation_id`)
) COMMENT 'Vehicle homologation records.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` (
    `ecu_catalog_id` BIGINT COMMENT '',
    `ecu_specification_id` BIGINT COMMENT '',
    `ecu_code` STRING COMMENT '',
    `ecu_name` STRING COMMENT '',
    CONSTRAINT pk_ecu_catalog PRIMARY KEY(`ecu_catalog_id`)
) COMMENT 'ECU catalog for vehicle electronic control units.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` (
    `msrp_pricing_id` BIGINT COMMENT '',
    `configuration_id` BIGINT COMMENT '',
    `model_id` BIGINT COMMENT '',
    `price_amount` DECIMAL(18,2) COMMENT '',
    CONSTRAINT pk_msrp_pricing PRIMARY KEY(`msrp_pricing_id`)
) COMMENT 'MSRP pricing for vehicle configurations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` (
    `lifecycle_event_id` BIGINT COMMENT '',
    `vin_registry_id` BIGINT COMMENT '',
    `event_timestamp` TIMESTAMP COMMENT '',
    `event_type` STRING COMMENT '',
    CONSTRAINT pk_lifecycle_event PRIMARY KEY(`lifecycle_event_id`)
) COMMENT 'Vehicle lifecycle events.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_emissions_certification` (
    `vehicle_emissions_certification_id` BIGINT COMMENT '',
    `compliance_emissions_certification_id` BIGINT COMMENT '',
    CONSTRAINT pk_vehicle_emissions_certification PRIMARY KEY(`vehicle_emissions_certification_id`)
) COMMENT 'Reference to SSOT owner compliance.compliance_emissions_certification. Vehicle emissions certification linkage.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` (
    `vehicle_ota_deployment_id` BIGINT COMMENT '',
    `vin_registry_id` BIGINT COMMENT '',
    `vehicle_ota_deployment_status` STRING COMMENT '',
    CONSTRAINT pk_vehicle_ota_deployment PRIMARY KEY(`vehicle_ota_deployment_id`)
) COMMENT 'Vehicle OTA deployment tracking.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`ownership` (
    `ownership_id` BIGINT COMMENT '',
    `party_id` BIGINT COMMENT '',
    `vin_registry_id` BIGINT COMMENT '',
    `ownership_type` STRING COMMENT '',
    CONSTRAINT pk_ownership PRIMARY KEY(`ownership_id`)
) COMMENT 'Vehicle ownership records.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` (
    `campaign_enrollment_id` BIGINT COMMENT '',
    `service_campaign_id` BIGINT COMMENT '',
    `vin_registry_id` BIGINT COMMENT '',
    CONSTRAINT pk_campaign_enrollment PRIMARY KEY(`campaign_enrollment_id`)
) COMMENT 'Vehicle campaign enrollment.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` (
    `regulatory_compliance_assignment_id` BIGINT COMMENT '',
    `model_id` BIGINT COMMENT '',
    `regulatory_requirement_id` BIGINT COMMENT '',
    CONSTRAINT pk_regulatory_compliance_assignment PRIMARY KEY(`regulatory_compliance_assignment_id`)
) COMMENT 'Vehicle regulatory compliance assignments.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` (
    `powertrain_config_id` BIGINT COMMENT '',
    `aftersales_nameplate_id` BIGINT COMMENT '',
    `powertrain_spec_id` BIGINT COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `powertrain_code` STRING COMMENT '',
    `powertrain_type` STRING COMMENT '',
    CONSTRAINT pk_powertrain_config PRIMARY KEY(`powertrain_config_id`)
) COMMENT 'Powertrain configuration definitions.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_body_style` (
    `aftersales_body_style_id` BIGINT COMMENT '',
    `body_style_code` STRING COMMENT '',
    `body_style_name` STRING COMMENT '',
    `body_style_status` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `door_count` STRING COMMENT '',
    `seating_capacity` STRING COMMENT '',
    `ssot_governance_note` STRING COMMENT '',
    CONSTRAINT pk_aftersales_body_style PRIMARY KEY(`aftersales_body_style_id`)
) COMMENT 'Body style definitions (moved from aftersales).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` (
    `aftersales_color_option_id` BIGINT COMMENT '',
    `color_code` STRING COMMENT '',
    `color_name` STRING COMMENT '',
    `color_type` STRING COMMENT '',
    `created_timestamp` TIMESTAMP COMMENT '',
    `ssot_governance_note` STRING COMMENT '',
    CONSTRAINT pk_aftersales_color_option PRIMARY KEY(`aftersales_color_option_id`)
) COMMENT 'Color option definitions (moved from aftersales).';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ADD CONSTRAINT `fk_vehicle_vin_registry_aftersales_body_style_id` FOREIGN KEY (`aftersales_body_style_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`aftersales_body_style`(`aftersales_body_style_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ADD CONSTRAINT `fk_vehicle_vin_registry_aftersales_color_option_id` FOREIGN KEY (`aftersales_color_option_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`aftersales_color_option`(`aftersales_color_option_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ADD CONSTRAINT `fk_vehicle_vin_registry_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ADD CONSTRAINT `fk_vehicle_model_platform_id` FOREIGN KEY (`platform_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`platform`(`platform_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_model_year_program` ADD CONSTRAINT `fk_vehicle_vehicle_model_year_program_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` ADD CONSTRAINT `fk_vehicle_vehicle_trim_level_aftersales_body_style_id` FOREIGN KEY (`aftersales_body_style_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`aftersales_body_style`(`aftersales_body_style_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` ADD CONSTRAINT `fk_vehicle_vehicle_trim_level_aftersales_color_option_id` FOREIGN KEY (`aftersales_color_option_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`aftersales_color_option`(`aftersales_color_option_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` ADD CONSTRAINT `fk_vehicle_vehicle_trim_level_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` ADD CONSTRAINT `fk_vehicle_powertrain_variant_powertrain_config_id` FOREIGN KEY (`powertrain_config_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`powertrain_config`(`powertrain_config_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_aftersales_body_style_id` FOREIGN KEY (`aftersales_body_style_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`aftersales_body_style`(`aftersales_body_style_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_platform_id` FOREIGN KEY (`platform_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`platform`(`platform_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` ADD CONSTRAINT `fk_vehicle_vehicle_option_package_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ADD CONSTRAINT `fk_vehicle_build_spec_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ADD CONSTRAINT `fk_vehicle_homologation_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ADD CONSTRAINT `fk_vehicle_msrp_pricing_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` ADD CONSTRAINT `fk_vehicle_msrp_pricing_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ADD CONSTRAINT `fk_vehicle_lifecycle_event_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` ADD CONSTRAINT `fk_vehicle_vehicle_ota_deployment_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` ADD CONSTRAINT `fk_vehicle_ownership_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ADD CONSTRAINT `fk_vehicle_campaign_enrollment_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` ADD CONSTRAINT `fk_vehicle_regulatory_compliance_assignment_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`vehicle` SET TAGS ('dbx_pii_division' = 'operations');
ALTER SCHEMA `vibe_automotive_v1`.`vehicle` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` SET TAGS ('dbx_pii_pii_scan_reviewed' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_model_year_program` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_model_year_program` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_model_year_program` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_model_year_program` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_variant` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_adas_feature` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_adas_feature` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_adas_feature` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_adas_feature` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_adas_feature` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` SET TAGS ('dbx_pii_subdomain' = 'regulatory_compliance');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`msrp_pricing` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` SET TAGS ('dbx_pii_subdomain' = 'ownership_tracking');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_emissions_certification` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_emissions_certification` SET TAGS ('dbx_pii_subdomain' = 'regulatory_compliance');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_emissions_certification` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_emissions_certification` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_emissions_certification` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` SET TAGS ('dbx_pii_subdomain' = 'ownership_tracking');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` SET TAGS ('dbx_pii_association_edges' = 'vehicle.vin_registry,mobility.ota_campaign');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_ota_deployment` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` SET TAGS ('dbx_pii_subdomain' = 'ownership_tracking');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` SET TAGS ('dbx_pii_association_edges' = 'vehicle.vin_registry,customer.party');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` SET TAGS ('dbx_pii_subdomain' = 'ownership_tracking');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` SET TAGS ('dbx_pii_association_edges' = 'vehicle.vin_registry,aftersales.service_campaign');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` SET TAGS ('dbx_pii_subdomain' = 'regulatory_compliance');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` SET TAGS ('dbx_pii_association_edges' = 'vehicle.model,compliance.regulatory_requirement');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_body_style` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_body_style` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_body_style` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_body_style` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` SET TAGS ('dbx_pii_subdomain' = 'product_catalog');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` SET TAGS ('dbx_pii_domain' = 'vehicle');
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`aftersales_color_option` SET TAGS ('dbx_pii_ecm_scope' = 'true');
