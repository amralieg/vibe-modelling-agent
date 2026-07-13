-- Schema for Domain: field_services | Business:  | Version: v2_ecm
-- Generated on: 2026-07-13 15:03:51

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`field_services` COMMENT '';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`field_services`.`field_technician_dispatch` (
    `field_technician_dispatch_id` BIGINT COMMENT 'Primary key',
    `mobile_service_order_id` BIGINT COMMENT 'FK to mobile service order',
    `employee_id` BIGINT COMMENT 'FK to assigned technician',
    `vin_registry_id` BIGINT COMMENT 'FK to vehicle being serviced',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Actual arrival time',
    `dispatch_timestamp` TIMESTAMP COMMENT 'When the dispatch was created',
    `estimated_arrival_timestamp` TIMESTAMP COMMENT 'ETA at customer location',
    `priority` STRING COMMENT 'Priority level',
    `field_technician_dispatch_status` STRING COMMENT 'Dispatch status',
    CONSTRAINT pk_field_technician_dispatch PRIMARY KEY(`field_technician_dispatch_id`)
) COMMENT 'Dispatching of field technicians to customer locations for service, repair, or inspection tasks.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`field_services`.`mobile_service_order` (
    `mobile_service_order_id` BIGINT COMMENT 'Primary key',
    `party_id` BIGINT COMMENT 'FK to customer',
    `vin_registry_id` BIGINT COMMENT 'FK to vehicle',
    `completed_timestamp` TIMESTAMP COMMENT 'Completion timestamp',
    `created_timestamp` TIMESTAMP COMMENT 'Creation timestamp',
    `order_number` STRING COMMENT 'Order number',
    `service_type` STRING COMMENT 'Type of field service',
    `mobile_service_order_status` STRING COMMENT 'Order status',
    CONSTRAINT pk_mobile_service_order PRIMARY KEY(`mobile_service_order_id`)
) COMMENT 'Service orders for mobile/field service operations performed at customer locations rather than fixed workshops.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`field_services`.`roadside_assistance_case` (
    `roadside_assistance_case_id` BIGINT COMMENT 'Primary key',
    `vin_registry_id` BIGINT COMMENT 'FK to vehicle',
    `case_number` STRING COMMENT 'Case reference number',
    `location_latitude` DECIMAL(18,2) COMMENT 'Latitude of breakdown location',
    `location_longitude` DECIMAL(18,2) COMMENT 'Longitude of breakdown location',
    `reported_timestamp` TIMESTAMP COMMENT 'When reported',
    `resolved_timestamp` TIMESTAMP COMMENT 'When resolved',
    `roadside_assistance_case_status` STRING COMMENT 'Case status',
    CONSTRAINT pk_roadside_assistance_case PRIMARY KEY(`roadside_assistance_case_id`)
) COMMENT 'Roadside assistance cases for stranded vehicles including towing coordination and on-site repair.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`field_services`.`towing_event` (
    `towing_event_id` BIGINT COMMENT 'Primary key',
    `dealership_id` BIGINT COMMENT 'FK to destination dealer',
    `roadside_assistance_case_id` BIGINT COMMENT 'FK to roadside case',
    `delivery_timestamp` TIMESTAMP COMMENT 'Delivery time',
    `distance_km` DECIMAL(18,2) COMMENT 'Towing distance',
    `pickup_timestamp` TIMESTAMP COMMENT 'Pickup time',
    `towing_event_status` STRING COMMENT 'Towing status',
    `tow_provider_name` STRING COMMENT 'Towing provider',
    CONSTRAINT pk_towing_event PRIMARY KEY(`towing_event_id`)
) COMMENT 'Towing events for vehicles that cannot be repaired on-site and must be transported to a service facility.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`field_services`.`breakdown_case` (
    `breakdown_case_id` BIGINT COMMENT 'Primary key',
    `roadside_assistance_case_id` BIGINT COMMENT 'FK to roadside case',
    `failure_category` STRING COMMENT 'Category of breakdown',
    `resolution_description` STRING COMMENT 'Resolution applied',
    `root_cause_code` STRING COMMENT 'Root cause code',
    `breakdown_case_status` STRING COMMENT 'Case status',
    `symptom_description` STRING COMMENT 'Symptom reported',
    CONSTRAINT pk_breakdown_case PRIMARY KEY(`breakdown_case_id`)
) COMMENT 'Breakdown cases tracking vehicle failures in the field, root cause, and resolution path.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`field_services`.`field_visit` (
    `field_visit_id` BIGINT COMMENT 'Primary key',
    `dealership_id` BIGINT COMMENT 'FK to dealership visited',
    `employee_id` BIGINT COMMENT 'FK to field rep',
    `findings_summary` STRING COMMENT 'Summary of findings',
    `purpose` STRING COMMENT 'Visit purpose',
    `field_visit_status` STRING COMMENT 'Visit status',
    `visit_date` DATE COMMENT 'Date of visit',
    CONSTRAINT pk_field_visit PRIMARY KEY(`field_visit_id`)
) COMMENT 'OEM field representative visits to dealers or customer sites for quality, technical support, or audit purposes.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`field_services`.`field_activity` (
    `field_activity_id` BIGINT COMMENT 'Primary key',
    `field_visit_id` BIGINT COMMENT 'FK to field visit',
    `activity_type` STRING COMMENT 'Type of activity',
    `end_timestamp` TIMESTAMP COMMENT 'Activity end',
    `notes` STRING COMMENT 'Notes',
    `outcome` STRING COMMENT 'Activity outcome',
    `start_timestamp` TIMESTAMP COMMENT 'Activity start',
    CONSTRAINT pk_field_activity PRIMARY KEY(`field_activity_id`)
) COMMENT 'Individual activities performed during field visits or dispatches, tracking time and outcomes.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`field_services`.`field_quality_investigation` (
    `field_quality_investigation_id` BIGINT COMMENT 'Primary key',
    `defect_record_id` BIGINT COMMENT 'FK to quality defect record',
    `field_visit_id` BIGINT COMMENT 'FK to originating field visit',
    `closed_timestamp` TIMESTAMP COMMENT 'When closed',
    `investigation_number` STRING COMMENT 'Investigation reference number',
    `opened_timestamp` TIMESTAMP COMMENT 'When opened',
    `severity` STRING COMMENT 'Severity rating',
    `field_quality_investigation_status` STRING COMMENT 'Investigation status',
    CONSTRAINT pk_field_quality_investigation PRIMARY KEY(`field_quality_investigation_id`)
) COMMENT 'Quality investigations initiated from field observations, linking field findings to quality corrective actions.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`field_services`.`field_failure_analysis` (
    `field_failure_analysis_id` BIGINT COMMENT 'Primary key',
    `field_quality_investigation_id` BIGINT COMMENT 'FK to investigation',
    `part_master_id` BIGINT COMMENT 'FK to failed part',
    `analysis_date` DATE COMMENT 'Date of analysis',
    `corrective_action_recommendation` STRING COMMENT 'Recommended corrective action',
    `failure_mode` STRING COMMENT 'Failure mode identified',
    `root_cause` STRING COMMENT 'Root cause determination',
    `field_failure_analysis_status` STRING COMMENT 'Analysis status',
    CONSTRAINT pk_field_failure_analysis PRIMARY KEY(`field_failure_analysis_id`)
) COMMENT 'Detailed failure analysis of parts/components returned from the field, linking to engineering root cause.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`field_services`.`field_engineering_report` (
    `field_engineering_report_id` BIGINT COMMENT 'Primary key',
    `field_failure_analysis_id` BIGINT COMMENT 'FK to failure analysis',
    `vehicle_program_id` BIGINT COMMENT 'FK to vehicle program',
    `engineering_change_required` BOOLEAN COMMENT 'Whether an ECO/ECN is needed',
    `published_date` DATE COMMENT 'Publication date',
    `report_number` STRING COMMENT 'Report number',
    `field_engineering_report_status` STRING COMMENT 'Report status',
    `title` STRING COMMENT 'Report title',
    CONSTRAINT pk_field_engineering_report PRIMARY KEY(`field_engineering_report_id`)
) COMMENT 'Engineering reports generated from field observations, feeding back into R&D for design improvements.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`field_services`.`field_service_appointment` (
    `field_service_appointment_id` BIGINT COMMENT 'Primary key',
    `connected_vehicle_id` BIGINT COMMENT 'FK to connected vehicle for telemetry-triggered appointments',
    `party_id` BIGINT COMMENT 'FK to customer',
    `mobile_service_order_id` BIGINT COMMENT 'FK to service order',
    `location_address` STRING COMMENT 'Service location address',
    `scheduled_date` DATE COMMENT 'Scheduled date',
    `field_service_appointment_status` STRING COMMENT 'Appointment status',
    `time_slot` STRING COMMENT 'Time slot',
    CONSTRAINT pk_field_service_appointment PRIMARY KEY(`field_service_appointment_id`)
) COMMENT 'Scheduled appointments for field service visits, coordinating technician availability and customer preferences.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`field_services`.`field_parts_usage` (
    `field_parts_usage_id` BIGINT COMMENT 'Primary key',
    `mobile_service_order_id` BIGINT COMMENT 'FK to service order',
    `part_master_id` BIGINT COMMENT 'FK to part used',
    `sku_master_id` BIGINT COMMENT 'FK to inventory SKU',
    `quantity_used` STRING COMMENT 'Quantity consumed',
    `serial_number` STRING COMMENT 'Part serial number if applicable',
    `usage_timestamp` TIMESTAMP COMMENT 'When part was used',
    CONSTRAINT pk_field_parts_usage PRIMARY KEY(`field_parts_usage_id`)
) COMMENT 'Parts consumed during field service operations, tracking inventory usage outside fixed workshops.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_technician_dispatch` ADD CONSTRAINT `fk_field_services_field_technician_dispatch_mobile_service_order_id` FOREIGN KEY (`mobile_service_order_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`mobile_service_order`(`mobile_service_order_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`towing_event` ADD CONSTRAINT `fk_field_services_towing_event_roadside_assistance_case_id` FOREIGN KEY (`roadside_assistance_case_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`roadside_assistance_case`(`roadside_assistance_case_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`breakdown_case` ADD CONSTRAINT `fk_field_services_breakdown_case_roadside_assistance_case_id` FOREIGN KEY (`roadside_assistance_case_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`roadside_assistance_case`(`roadside_assistance_case_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_activity` ADD CONSTRAINT `fk_field_services_field_activity_field_visit_id` FOREIGN KEY (`field_visit_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_visit`(`field_visit_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_quality_investigation` ADD CONSTRAINT `fk_field_services_field_quality_investigation_field_visit_id` FOREIGN KEY (`field_visit_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_visit`(`field_visit_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_failure_analysis` ADD CONSTRAINT `fk_field_services_field_failure_analysis_field_quality_investigation_id` FOREIGN KEY (`field_quality_investigation_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_quality_investigation`(`field_quality_investigation_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_engineering_report` ADD CONSTRAINT `fk_field_services_field_engineering_report_field_failure_analysis_id` FOREIGN KEY (`field_failure_analysis_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_failure_analysis`(`field_failure_analysis_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_service_appointment` ADD CONSTRAINT `fk_field_services_field_service_appointment_mobile_service_order_id` FOREIGN KEY (`mobile_service_order_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`mobile_service_order`(`mobile_service_order_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_parts_usage` ADD CONSTRAINT `fk_field_services_field_parts_usage_mobile_service_order_id` FOREIGN KEY (`mobile_service_order_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`mobile_service_order`(`mobile_service_order_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`field_services` SET TAGS ('dbx_pii_division' = 'business');
ALTER SCHEMA `vibe_automotive_v1`.`field_services` SET TAGS ('dbx_pii_domain' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_technician_dispatch` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_technician_dispatch` SET TAGS ('dbx_pii_subdomain' = 'technician_dispatch');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_technician_dispatch` SET TAGS ('dbx_pii_domain' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_technician_dispatch` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_technician_dispatch` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`mobile_service_order` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`mobile_service_order` SET TAGS ('dbx_pii_subdomain' = 'technician_dispatch');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`mobile_service_order` SET TAGS ('dbx_pii_domain' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`mobile_service_order` ALTER COLUMN `mobile_service_order_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`mobile_service_order` ALTER COLUMN `mobile_service_order_id` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`roadside_assistance_case` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`roadside_assistance_case` SET TAGS ('dbx_pii_subdomain' = 'emergency_response');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`roadside_assistance_case` SET TAGS ('dbx_pii_domain' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`roadside_assistance_case` ALTER COLUMN `location_latitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`roadside_assistance_case` ALTER COLUMN `location_latitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`roadside_assistance_case` ALTER COLUMN `location_longitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`roadside_assistance_case` ALTER COLUMN `location_longitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`towing_event` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`towing_event` SET TAGS ('dbx_pii_subdomain' = 'emergency_response');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`towing_event` SET TAGS ('dbx_pii_domain' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`breakdown_case` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`breakdown_case` SET TAGS ('dbx_pii_subdomain' = 'emergency_response');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`breakdown_case` SET TAGS ('dbx_pii_domain' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_visit` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_visit` SET TAGS ('dbx_pii_subdomain' = 'quality_investigation');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_visit` SET TAGS ('dbx_pii_domain' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_visit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_visit` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_activity` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_activity` SET TAGS ('dbx_pii_subdomain' = 'quality_investigation');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_activity` SET TAGS ('dbx_pii_domain' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_quality_investigation` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_quality_investigation` SET TAGS ('dbx_pii_subdomain' = 'quality_investigation');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_quality_investigation` SET TAGS ('dbx_pii_domain' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_failure_analysis` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_failure_analysis` SET TAGS ('dbx_pii_subdomain' = 'quality_investigation');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_failure_analysis` SET TAGS ('dbx_pii_domain' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_engineering_report` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_engineering_report` SET TAGS ('dbx_pii_subdomain' = 'quality_investigation');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_engineering_report` SET TAGS ('dbx_pii_domain' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_service_appointment` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_service_appointment` SET TAGS ('dbx_pii_subdomain' = 'technician_dispatch');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_service_appointment` SET TAGS ('dbx_pii_domain' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_service_appointment` ALTER COLUMN `mobile_service_order_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_service_appointment` ALTER COLUMN `mobile_service_order_id` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_service_appointment` ALTER COLUMN `location_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_parts_usage` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_parts_usage` SET TAGS ('dbx_pii_subdomain' = 'technician_dispatch');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_parts_usage` SET TAGS ('dbx_pii_domain' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_parts_usage` ALTER COLUMN `mobile_service_order_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_parts_usage` ALTER COLUMN `mobile_service_order_id` SET TAGS ('dbx_pii_pii_phone' = 'true');
