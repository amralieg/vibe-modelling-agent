-- Schema for Domain: mobility | Business:  | Version: v2_ecm
-- Generated on: 2026-07-13 15:03:53

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`mobility` COMMENT 'Connected vehicle services and mobility solutions including telematics, V2X (Vehicle-to-Everything Communication), OTA (Over-the-Air Update) management, fleet connectivity, and autonomous driving feature entitlements. Manages connected vehicle data streams, remote diagnostics, predictive maintenance alerts, TPMS (Tire Pressure Monitoring System) telemetry, and usage-based services. Owns connected vehicle device registry and mobility service agreements. Integrates with Geotab, Bosch IoT, and cloud-based mobility platforms.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` (
    `connected_vehicle_id` BIGINT COMMENT 'Unique surrogate key for the connected vehicle record.',
    `breakdown_case_id` BIGINT COMMENT 'FK to latest breakdown case',
    `mobility_fleet_account_id` BIGINT COMMENT 'Identifier of the fleet to which the vehicle belongs, if applicable.',
    `connected_mobility_fleet_account_id` BIGINT COMMENT 'Identifier of the fleet to which the vehicle belongs, if applicable.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Sales Attribution Report links each connected vehicle to the dealer that sold it, enabling dealer‑level warranty and service responsibility.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Fleet driver assignment report requires linking each vehicle to its current driver employee for compliance and usage tracking.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Vehicle Asset Management report requires linking each connected vehicle to its equipment registry record for warranty, maintenance, and depreciation tracking.',
    `homologation_record_id` BIGINT COMMENT 'Foreign key linking to compliance.homologation_record. Business justification: Regulatory Homologation Report requires linking each vehicle to its homologation record for market approval tracking.',
    `aftersales_nameplate_id` BIGINT COMMENT 'Foreign key linking to product.nameplate. Business justification: OTA campaign planning requires linking each connected vehicle to its product nameplate to apply correct software version and compliance reporting.',
    `ota_compliance_approval_id` BIGINT COMMENT 'Foreign key linking to compliance.ota_compliance_approval. Business justification: OTA updates must be tied to regulatory OTA compliance approval to satisfy cybersecurity and safety audit.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Needed to identify the legal owner for billing, data‑privacy compliance, and service entitlement of each connected vehicle.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Each vehicle contributes to a profit center for margin analysis; required for the Vehicle Profitability Report.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Warranty and service management need the exact SKU for each connected vehicle to determine coverage, parts, and service intervals.',
    `software_version_id` BIGINT COMMENT 'Foreign key linking to mobility.software_version. Business justification: Storing the software version as a FK enables consistent version management and eliminates duplicated version strings on the vehicle record.',
    `telematics_device_id` BIGINT COMMENT 'Unique identifier of the telematics hardware installed in the vehicle.',
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
    `model_name` STRING COMMENT 'Marketing name of the vehicle model.',
    `model_year` STRING COMMENT 'Model year of the vehicle (calendar year).',
    `ota_capability` BOOLEAN COMMENT 'Indicates whether the vehicle supports Over-The-Air updates.',
    `powertrain_type` STRING COMMENT 'Primary propulsion technology of the vehicle.. Valid values are `ev|phev|hev|ice`',
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

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` (
    `telematics_device_id` BIGINT COMMENT 'Unique surrogate key for each telematics control unit (TCU) record.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Device Installation Management process tracks which equipment asset each telematics device is mounted on for service contracts and calibration compliance.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Device installation/maintenance logs need the installer employee to support warranty validation and service cost allocation.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Supports hardware warranty and recall process linking each telematics device to its manufacturing supplier for defect tracking.',
    `battery_level_percent` DECIMAL(18,2) COMMENT 'Current battery charge level expressed as a percentage.',
    `calibration_status` BOOLEAN COMMENT 'Indicates whether the device has passed factory calibration (true) or not (false).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the telematics device record was first created in the data lake.',
    `data_plan_expiration` DATE COMMENT 'Date when the current data plan expires.',
    `data_plan_type` STRING COMMENT 'Type of cellular data plan assigned to the device.. Valid values are `payg|subscription|none`',
    `device_make` STRING COMMENT 'Name of the manufacturer that produced the telematics device.',
    `device_model` STRING COMMENT 'Model designation of the telematics device as defined by the manufacturer.',
    `device_status` STRING COMMENT 'Overall lifecycle status of the device.. Valid values are `active|inactive|faulty|retired`',
    `field_services_connected_flag` BOOLEAN COMMENT 'Whether this telematics device is connected to field services for proactive dispatch',
    `firmware_version` STRING COMMENT 'Current firmware version installed on the telematics device.',
    `gps_latitude` DOUBLE COMMENT 'Most recent latitude coordinate reported by the device.',
    `gps_longitude` DOUBLE COMMENT 'Most recent longitude coordinate reported by the device.',
    `hardware_generation` STRING COMMENT 'Generation identifier for the hardware platform of the device (e.g., Gen1, Gen2).',
    `iccid` STRING COMMENT 'Unique identifier of the SIM card embedded in the telematics device.',
    `imei` STRING COMMENT 'Globally unique identifier for the devices cellular modem.',
    `installation_date` DATE COMMENT 'Date the telematics device was installed in the vehicle.',
    `last_firmware_update` TIMESTAMP COMMENT 'When the device last received a firmware OTA update.',
    `last_heartbeat_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent health‑check ping received from the device.',
    `last_maintenance_date` DATE COMMENT 'Date of the most recent scheduled maintenance performed on the device.',
    `maintenance_cycle_months` STRING COMMENT 'Planned interval in months between routine maintenance events.',
    `odometer_km` DECIMAL(18,2) COMMENT 'Cumulative distance traveled as reported by the device, in kilometers.',
    `operational_status` STRING COMMENT 'Current operational state of the device within the fleet.. Valid values are `in_service|out_of_service|maintenance|decommissioned`',
    `ota_update_capability` BOOLEAN COMMENT 'Indicates whether the device supports over‑the‑air firmware updates.',
    `owner_type` STRING COMMENT 'Entity type that owns the device.. Valid values are `vehicle|fleet|dealer|service_center`',
    `provisioning_date` DATE COMMENT 'Date the device was provisioned and linked to the fleet management system.',
    `signal_strength_dbm` STRING COMMENT 'Cellular signal strength measured in decibel‑milliwatts.',
    `temperature_c` DOUBLE COMMENT 'Internal temperature of the telematics unit in degrees Celsius.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the telematics device record.',
    `v2x_enabled` BOOLEAN COMMENT 'Flag indicating if vehicle‑to‑everything communication is enabled on the device.',
    `vehicle_vin` STRING COMMENT 'VIN of the vehicle in which the device is installed.',
    `warranty_expiration_date` DATE COMMENT 'Date when the devices manufacturer warranty ends.',
    CONSTRAINT pk_telematics_device PRIMARY KEY(`telematics_device_id`)
) COMMENT 'Master record for each physical or embedded telematics control unit (TCU) installed in a vehicle. Tracks device make, model, firmware version, IMEI, ICCID, hardware generation, installation date, calibration status, and operational health. Sourced from Geotab and Bosch IoT device registries. Distinct from connected_vehicle which is the vehicle-level enrollment record; telematics_device is the hardware asset record.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` (
    `service_subscription_id` BIGINT COMMENT 'System-generated unique identifier for each mobility service subscription record.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Subscription Sales Attribution Report attributes each service subscription to the dealer that sold it for revenue tracking.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Financial Billing process allocates subscription fees to the specific equipment asset for cost accounting and depreciation.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Subscription fees are booked to a revenue GL account; needed for the Subscription Billing and Revenue Recognition process.',
    `party_id` BIGINT COMMENT 'Unique identifier of the customer who owns the subscription.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Sales commission reports require linking each subscription to the sales representative employee who closed the deal.',
    `service_customer_party_id` BIGINT COMMENT 'Unique identifier of the customer who owns the subscription.',
    `mobility_service_id` BIGINT COMMENT 'Reference to the specific connected mobility service offering.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Needed to tie subscription eligibility, billing and compliance directly to the vehicle master record for accurate invoicing and regulatory reporting.',
    `auto_renewal_flag` BOOLEAN COMMENT 'True if the subscription is set to renew automatically at the end of the term.',
    `billing_amount` DECIMAL(18,2) COMMENT 'Base amount charged per billing cycle before taxes, fees, or discounts.',
    `billing_cycle` STRING COMMENT 'Frequency at which the subscription is billed.. Valid values are `monthly|quarterly|yearly`',
    `cancellation_date` DATE COMMENT 'Date when the subscription was cancelled by the customer or provider.',
    `cancellation_reason` STRING COMMENT 'Reason provided for terminating the subscription.. Valid values are `customer_request|service_unavailable|non_payment|contract_end|other`',
    `compliance_gdpr_consent` BOOLEAN COMMENT 'True if the subscriber has provided consent for data processing under GDPR.',
    `contract_terms` STRING COMMENT 'Free‑text description of the contractual obligations, service level agreements, and special conditions.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the subscription record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three‑letter currency code for the billing amount.. Valid values are `^[A-Z]{3}$`',
    `data_sharing_opt_in` BOOLEAN COMMENT 'True if the subscriber agrees to share usage data with third‑party partners.',
    `end_date` DATE COMMENT 'Date when the subscription terminates or expires; null for open‑ended agreements.',
    `entitlement_tier` STRING COMMENT 'Level of service features and data allowances granted to the subscriber.. Valid values are `basic|standard|premium|enterprise`',
    `field_service_eligible_flag` BOOLEAN COMMENT 'Whether this subscription includes field service coverage',
    `last_modified_by` STRING COMMENT 'User identifier of the person who performed the most recent update.',
    `last_payment_date` DATE COMMENT 'Date when the most recent subscription payment was received.',
    `next_payment_due` DATE COMMENT 'Scheduled date for the upcoming subscription payment.',
    `notes` STRING COMMENT 'Additional free‑form comments or remarks about the subscription.',
    `overage_amount` DECIMAL(18,2) COMMENT 'Monetary charge applied for usage beyond the allocated limit.',
    `overage_fee_applied` BOOLEAN COMMENT 'True if usage exceeded the limit and an overage fee was charged.',
    `payment_method` STRING COMMENT 'Instrument used for subscription billing.. Valid values are `credit_card|debit_card|bank_transfer|paypal|apple_pay`',
    `payment_status` STRING COMMENT 'Current status of the most recent payment transaction.. Valid values are `paid|unpaid|failed|pending`',
    `privacy_policy_version` STRING COMMENT 'Version identifier of the privacy policy accepted at subscription time.',
    `promo_discount_amount` DECIMAL(18,2) COMMENT 'Monetary value of the discount granted by the promotional code.',
    `promo_end_date` DATE COMMENT 'Date when the promotional discount expires.',
    `promo_start_date` DATE COMMENT 'Date when the promotional discount becomes effective.',
    `promotional_code` STRING COMMENT 'Code applied to the subscription for a discount or special offer.',
    `renewal_date` DATE COMMENT 'Scheduled date for the next automatic renewal, if auto‑renewal is enabled.',
    `service_subscription_status` STRING COMMENT 'Current lifecycle state of the subscription.. Valid values are `active|suspended|cancelled|expired|pending`',
    `start_date` DATE COMMENT 'Date when the subscription becomes effective.',
    `subscription_number` STRING COMMENT 'External reference number assigned to the subscription agreement, used in billing and customer communications.',
    `subscription_type` STRING COMMENT 'Category of the connected mobility service (e.g., telematics, infotainment, remote diagnostics).. Valid values are `connected_mobility|infotainment|diagnostics`',
    `trial_end_date` DATE COMMENT 'Date when the trial period expires and regular billing begins.',
    `trial_flag` BOOLEAN COMMENT 'True if the subscription is currently in a free‑trial period.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the subscription record.',
    `usage_limit` DECIMAL(18,2) COMMENT 'Maximum allowed usage (e.g., data, minutes) per billing cycle.',
    `usage_unit` STRING COMMENT 'Unit of measure for usage (e.g., gigabytes, minutes).. Valid values are `GB|minutes|messages`',
    `usage_used` DECIMAL(18,2) COMMENT 'Actual usage recorded for the current billing cycle.',
    CONSTRAINT pk_service_subscription PRIMARY KEY(`service_subscription_id`)
) COMMENT 'Active and historical mobility service subscription agreements between a customer and a connected mobility service. Captures subscription start/end dates, billing cycle, entitlement tier, auto-renewal flag, cancellation reason, trial period flag, and subscription status. Links customer identity (from customer domain) to a mobility_service. This is the SSOT for mobility service entitlements and active agreements per vehicle/customer.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` (
    `telemetry_event_id` BIGINT COMMENT 'Unique surrogate key for each telemetry event record.',
    `individual_id` BIGINT COMMENT 'Unique identifier of the driver associated with the vehicle at event time.',
    `trip_id` BIGINT COMMENT 'Identifier linking the telemetry event to a specific vehicle trip or route.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Allows raw telemetry events to be associated with the official vehicle record for diagnostics, safety reporting and emissions compliance.',
    `altitude` DOUBLE COMMENT 'Elevation above sea level of the vehicle at event time, in meters.',
    `battery_soc_percent` DOUBLE COMMENT 'Current electric battery charge level for EV/HEV vehicles, expressed as a percentage.',
    `battery_voltage_volt` DOUBLE COMMENT 'Instantaneous voltage of the vehicles high‑voltage battery, expressed in volts.',
    `charging_status` BOOLEAN COMMENT 'True if the vehicle is currently connected to a charger and charging, otherwise false.',
    `connectivity_status` BOOLEAN COMMENT 'True if the telematics device had an active network connection at event time.',
    `engine_rpm` STRING COMMENT 'Engine speed measured in revolutions per minute at the time of the event.',
    `engine_temperature_c` DOUBLE COMMENT 'Measured temperature of the engine coolant at event time, in degrees Celsius.',
    `event_sequence` BIGINT COMMENT 'Monotonically increasing sequence number for events from the same vehicle, used for ordering.',
    `event_source` STRING COMMENT 'Identifier of the source system that produced the telemetry record (e.g., Geotab, Bosch).',
    `event_timestamp` TIMESTAMP COMMENT 'Date and time when the telemetry event was generated by the vehicle sensor.',
    `event_type_code` STRING COMMENT 'Code that categorizes the type of telemetry event (e.g., speed, harsh_brake, idle).',
    `field_services_breakdown_case_id` BIGINT COMMENT 'FK to field services breakdown case triggered by this telemetry event',
    `firmware_version` STRING COMMENT 'Version identifier of the telematics device firmware that generated the event.',
    `fuel_level_percent` DOUBLE COMMENT 'Remaining fuel level expressed as a percentage of tank capacity.',
    `gps_accuracy_m` DOUBLE COMMENT 'Estimated horizontal accuracy of the GPS position in meters.',
    `heading_degrees` DOUBLE COMMENT 'Compass direction the vehicle is facing at event time, expressed in degrees from true north.',
    `ignition_state` BOOLEAN COMMENT 'Indicates whether the vehicle ignition is on (true) or off (false) at the moment of the event.',
    `latitude` DOUBLE COMMENT 'Geographic latitude of the vehicle at event time, expressed in decimal degrees.',
    `latitude_accuracy` DOUBLE COMMENT 'Estimated vertical accuracy of the latitude measurement.',
    `location_city` STRING COMMENT 'City name derived from the GPS coordinates at event time.',
    `location_country` STRING COMMENT 'Three‑letter ISO country code derived from the GPS coordinates at event time.',
    `location_state` STRING COMMENT 'State or province name derived from the GPS coordinates at event time.',
    `longitude` DOUBLE COMMENT 'Geographic longitude of the vehicle at event time, expressed in decimal degrees.',
    `longitude_accuracy` DOUBLE COMMENT 'Estimated vertical accuracy of the longitude measurement.',
    `odometer_km` DOUBLE COMMENT 'Cumulative distance traveled by the vehicle, recorded in kilometers.',
    `raw_payload` STRING COMMENT 'Original JSON payload received from the telematics device before any transformation.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the telemetry record was first ingested into the silver layer.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the telemetry record in the lakehouse.',
    `signal_quality` STRING COMMENT 'Qualitative assessment of the telemetry signal (e.g., good, moderate, poor).',
    `speed_kph` DOUBLE COMMENT 'Instantaneous vehicle speed at event time, measured in kilometers per hour.',
    `tire_pressure_front_left_psi` DOUBLE COMMENT 'Air pressure of the front‑left tire measured in pounds per square inch.',
    `tire_pressure_front_right_psi` DOUBLE COMMENT 'Air pressure of the front‑right tire measured in pounds per square inch.',
    `tire_pressure_rear_left_psi` DOUBLE COMMENT 'Air pressure of the rear‑left tire measured in pounds per square inch.',
    `tire_pressure_rear_right_psi` DOUBLE COMMENT 'Air pressure of the rear‑right tire measured in pounds per square inch.',
    CONSTRAINT pk_telemetry_event PRIMARY KEY(`telemetry_event_id`)
) COMMENT 'High-frequency transactional record of raw and processed telematics events streamed from connected vehicles via Geotab or Bosch IoT. Each record captures event timestamp, VIN reference, GPS coordinates (latitude, longitude, altitude), vehicle speed, heading, ignition state, odometer reading, fuel level, battery state of charge (for EV/HEV), engine RPM, and event type code. Silver layer record represents cleansed and deduplicated stream from the bronze ingestion layer.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`trip` (
    `trip_id` BIGINT COMMENT 'Unique system-generated identifier for the trip record.',
    `connected_vehicle_id` BIGINT COMMENT 'Unique identifier of the vehicle that performed the trip.',
    `employee_id` BIGINT COMMENT 'Unique identifier of the driver associated with the trip.',
    `equipment_registry_id` BIGINT COMMENT 'Foreign key linking to asset.equipment_registry. Business justification: Asset Utilization Dashboard links trip records to equipment assets to calculate OEE and cost per vehicle.',
    `individual_id` BIGINT COMMENT 'Unique identifier of the driver associated with the trip.',
    `roadside_assistance_case_id` BIGINT COMMENT 'FK to roadside assistance case if trip was interrupted by breakdown',
    `mobility_route_id` BIGINT COMMENT 'Identifier of the predefined route, if the trip follows a known path.',
    `telematics_device_id` BIGINT COMMENT 'Unique identifier of the onboard telematics unit that reported the trip data.',
    `vin_registry_id` BIGINT COMMENT 'Unique identifier of the vehicle that performed the trip.',
    `average_speed_kph` DOUBLE COMMENT 'Mean speed of the vehicle over the trip.',
    `battery_state_of_charge_end_percent` DOUBLE COMMENT 'Battery charge level at trip end (percentage).',
    `battery_state_of_charge_start_percent` DOUBLE COMMENT 'Battery charge level at trip start (percentage).',
    `charging_event_flag` BOOLEAN COMMENT 'Indicates whether the vehicle was charged during the trip.',
    `destination_latitude` DOUBLE COMMENT 'Geographic latitude of the trip end location.',
    `destination_longitude` DOUBLE COMMENT 'Geographic longitude of the trip end location.',
    `distance_km` DOUBLE COMMENT 'Total distance covered during the trip.',
    `driver_behavior_score` DOUBLE COMMENT 'Aggregated safety score (0‑100) derived from driving events.',
    `duration_seconds` BIGINT COMMENT 'Total elapsed time from start to end of the trip.',
    `emission_co2_kg` DOUBLE COMMENT 'Estimated carbon dioxide emissions for the trip.',
    `end_odometer_km` DOUBLE COMMENT 'Vehicle odometer reading at the end of the trip.',
    `end_timestamp` TIMESTAMP COMMENT 'Date‑time when the vehicle ignition was turned off and the trip ended.',
    `energy_consumed_kwh` DOUBLE COMMENT 'Electrical energy drawn from the battery during the trip (applicable to EV/HEV).',
    `fuel_consumed_liters` DOUBLE COMMENT 'Volume of gasoline/diesel used during the trip (applicable to ICE vehicles).',
    `geo_fence_violation_count` STRING COMMENT 'Number of times the vehicle crossed a defined geofence during the trip.',
    `harsh_acceleration_count` STRING COMMENT 'Number of harsh acceleration incidents detected during the trip.',
    `harsh_braking_count` STRING COMMENT 'Number of harsh braking incidents detected during the trip.',
    `idle_time_seconds` BIGINT COMMENT 'Total time the vehicle was stationary with engine on.',
    `maintenance_alert_flag` BOOLEAN COMMENT 'True if the trip triggered a predictive‑maintenance alert.',
    `max_speed_kph` DOUBLE COMMENT 'Highest speed recorded during the trip.',
    `mileage_since_last_service_km` DOUBLE COMMENT 'Distance driven since the vehicles most recent service event.',
    `notes` STRING COMMENT 'Free‑form text notes entered by driver or operator about the trip.',
    `origin_latitude` DOUBLE COMMENT 'Geographic latitude of the trip start location.',
    `origin_longitude` DOUBLE COMMENT 'Geographic longitude of the trip start location.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the trip record was first persisted in the lakehouse.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the trip record.',
    `road_type` STRING COMMENT 'Category of road surfaces traversed.. Valid values are `highway|urban|rural|offroad`',
    `start_odometer_km` DOUBLE COMMENT 'Vehicle odometer reading at the beginning of the trip.',
    `start_timestamp` TIMESTAMP COMMENT 'Date‑time when the vehicle ignition was turned on and the trip began.',
    `toll_amount_usd` DOUBLE COMMENT 'Total toll fees incurred on the trip, expressed in US dollars.',
    `toll_currency` STRING COMMENT 'Currency of the toll amount.. Valid values are `USD|EUR|CAD|GBP|JPY|AUD`',
    `traffic_level` STRING COMMENT 'Estimated traffic congestion experienced.. Valid values are `low|moderate|high|severe`',
    `trip_date` DATE COMMENT 'Calendar date of the trip (derived from start_timestamp).',
    `trip_number` STRING COMMENT 'Human‑readable trip code used in operations and customer communications.',
    `trip_status` STRING COMMENT 'Current lifecycle state of the trip.. Valid values are `completed|in_progress|cancelled|failed`',
    `trip_type` STRING COMMENT 'Classification of the trip purpose.. Valid values are `personal|commercial|test|service`',
    `weather_condition` STRING COMMENT 'Observed weather during the trip.. Valid values are `clear|rain|snow|fog|storm`',
    CONSTRAINT pk_trip PRIMARY KEY(`trip_id`)
) COMMENT 'Aggregated trip record derived from telemetry event streams, representing a single continuous vehicle journey from ignition-on to ignition-off. Captures trip start/end timestamps, origin and destination coordinates, total distance driven, average speed, maximum speed, idle time, fuel consumed or energy consumed (kWh for EV), and driver behavior metrics (harsh braking count, harsh acceleration count, sharp cornering count, speeding duration, driver behavior score). Used for usage-based insurance (UBI), fleet safety management, driver coaching programs, and predictive maintenance triggers.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`mobility_dtc_event` (
    `mobility_dtc_event_id` BIGINT COMMENT 'Unique identifier for the mobility_dtc_event data product (auto-inserted pre-linking).',
    `breakdown_case_id` BIGINT COMMENT 'FK to breakdown case if this DTC event caused a breakdown.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Add direct link to connected_vehicle for DTC events to enable vehicle‑level diagnostics.',
    CONSTRAINT pk_mobility_dtc_event PRIMARY KEY(`mobility_dtc_event_id`)
) COMMENT 'Diagnostic Trouble Code (DTC) event record captured via OBD (On-Board Diagnostics) from connected vehicles. Each record stores the DTC code, SAE/OEM fault description, ECU source module, fault severity level, first occurrence timestamp, last occurrence timestamp, occurrence count, freeze frame data snapshot, and resolution status. Feeds remote diagnostics services and predictive maintenance alert generation. Sourced from Geotab and Bosch IoT OBD data streams.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` (
    `remote_diagnostic_session_id` BIGINT COMMENT 'System-generated unique identifier for the remote diagnostic session.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Remote diagnostic sessions are performed per vehicle; link to connected_vehicle for context.',
    `mobile_service_order_id` BIGINT COMMENT 'FK to mobile service order created from remote diagnostics',
    `individual_id` BIGINT COMMENT 'Internal identifier of the driver or vehicle owner associated with the session.',
    `remote_individual_id` BIGINT COMMENT 'Internal identifier of the driver or vehicle owner associated with the session.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Remote diagnostic audit logs must record the technician employee performing the session for quality and liability tracking.',
    `battery_state_of_charge_percent` STRING COMMENT 'Battery charge level reported by the vehicle during the session, expressed as a percentage.',
    `connectivity_status` STRING COMMENT 'Current network connectivity state of the vehicle during the session.. Valid values are `online|offline|intermittent`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the session record was first created in the lakehouse.',
    `data_volume_mb` DECIMAL(18,2) COMMENT 'Amount of telemetry and diagnostic data transferred during the session.',
    `diagnostic_scope` STRING COMMENT 'Scope of the remote diagnostic session: full vehicle scan, targeted ECU, or custom set of modules.. Valid values are `full_scan|targeted_ecu|custom`',
    `error_codes` STRING COMMENT 'Comma‑separated list of error codes returned by the vehicle during diagnostics.',
    `escalation_flag` BOOLEAN COMMENT 'Indicates whether the session was escalated to after‑sales service for further action.',
    `firmware_version` STRING COMMENT 'Version identifier of the vehicle ECU firmware queried in the session.',
    `network_type` STRING COMMENT 'Communication medium used for the remote session.. Valid values are `cellular|wifi|satellite`',
    `notes` STRING COMMENT 'Free‑form technician or system notes captured for the session.',
    `outcome` STRING COMMENT 'Result of the diagnostic session after processing.. Valid values are `success|partial_success|failure|escalated`',
    `recommended_action_codes` STRING COMMENT 'Comma‑separated list of action codes suggested by the diagnostic engine (e.g., repair steps, software patches).',
    `remote_diagnostic_session_status` STRING COMMENT 'Current processing state of the remote diagnostic session.. Valid values are `pending|in_progress|completed|failed|canceled`',
    `session_code` STRING COMMENT 'External reference code for the diagnostic session, used in service logs and customer communications.',
    `session_duration_seconds` STRING COMMENT 'Total elapsed time of the remote diagnostic session in seconds.',
    `session_timestamp` TIMESTAMP COMMENT 'Exact time the remote diagnostic session was started.',
    `signal_strength_dbm` STRING COMMENT 'Measured radio signal strength in decibel‑milliwatts at session start.',
    `triggering_event_code` STRING COMMENT 'Code of the event that initiated the session (e.g., DTC code).. Valid values are `^[PBC][0-9]{4}$`',
    `triggering_event_type` STRING COMMENT 'Origin of the session trigger – Diagnostic Trouble Code event, manual request, scheduled maintenance, or OTA update.. Valid values are `dtc|manual|scheduled|ota_update`',
    `tsb_references` STRING COMMENT 'Identifiers of TSBs surfaced during the session, if any.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the session record.',
    `vehicle_odometer_km` STRING COMMENT 'Odometer reading of the vehicle at the time of the session, in kilometers.',
    CONSTRAINT pk_remote_diagnostic_session PRIMARY KEY(`remote_diagnostic_session_id`)
) COMMENT 'Record of a remote diagnostic session initiated for a connected vehicle, either triggered automatically by a DTC event or manually by a service advisor or customer. Captures session initiation timestamp, triggering event reference, diagnostic scope (full scan vs targeted ECU), session outcome, recommended action codes, TSB (Technical Service Bulletin) references surfaced, and escalation flag to aftersales domain. Integrates with Microsoft Dynamics 365 Field Service for escalation workflows.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` (
    `predictive_maintenance_alert_id` BIGINT COMMENT 'System‑generated unique identifier for each predictive maintenance alert record.',
    `breakdown_case_id` BIGINT COMMENT 'FK to breakdown case triggered by this alert',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Link vehicle VIN to master connected_vehicle record; VIN column redundant.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Maintenance alerts trigger cost allocations to the plants cost center; required for the Predictive Maintenance Cost Forecast report.',
    `roadside_assistance_case_id` BIGINT COMMENT 'FK to roadside assistance case triggered by this alert.',
    `aftersales_repair_order_id` BIGINT COMMENT '',
    `alert_category` STRING COMMENT 'High‑level classification of the alert (e.g., engine, brake, battery, software).',
    `alert_code` STRING COMMENT 'Business identifier code assigned to the alert for tracking and reference.',
    `alert_status` STRING COMMENT 'Current lifecycle state of the alert.. Valid values are `open|acknowledged|resolved|expired`',
    `component` STRING COMMENT 'Name of the vehicle component or system predicted to fail (e.g., engine, brake, battery).',
    `confidence_percentage` DECIMAL(18,2) COMMENT 'Model confidence that the predicted failure will occur, expressed as a percentage (0‑100).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the alert record was first persisted in the lakehouse.',
    `failure_mode` STRING COMMENT 'Textual description of the failure mode the model predicts (e.g., coolant leak, battery degradation).',
    `generation_timestamp` TIMESTAMP COMMENT 'Timestamp when the predictive maintenance alert was generated by the analytics engine.',
    `mileage_at_alert` BIGINT COMMENT 'Odometer reading of the vehicle at the time the alert was generated.',
    `predicted_failure_end` TIMESTAMP COMMENT 'Latest timestamp when the predicted failure is expected to occur.',
    `predicted_failure_start` TIMESTAMP COMMENT 'Earliest timestamp when the predicted failure is expected to occur.',
    `recommended_service_action` STRING COMMENT 'Prescribed maintenance or repair action to address the predicted issue.',
    `resolution_timestamp` TIMESTAMP COMMENT 'Timestamp when the alert was marked resolved or closed.',
    `severity` STRING COMMENT 'Severity classification of the alert indicating potential impact.. Valid values are `low|medium|high|critical`',
    `temperature_celsius` DECIMAL(18,2) COMMENT 'Ambient temperature recorded by the vehicle sensor when the alert was generated.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the alert record.',
    CONSTRAINT pk_predictive_maintenance_alert PRIMARY KEY(`predictive_maintenance_alert_id`)
) COMMENT 'Operational alert record generated when telematics and DTC data patterns indicate an impending vehicle component failure or maintenance need. Captures alert generation timestamp, VIN reference, affected component or system, predicted failure window, confidence level, alert severity, recommended service action, alert status (open/acknowledged/resolved/expired), and resolution timestamp. Distinct from a DTC event (which is a raw fault code) — this is a processed, actionable maintenance recommendation.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` (
    `ota_campaign_id` BIGINT COMMENT 'System-generated unique identifier for the OTA campaign.',
    `ota_compliance_approval_id` BIGINT COMMENT 'Foreign key linking to compliance.ota_compliance_approval. Business justification: Each OTA campaign must reference its OTA compliance approval record for regulatory audit of firmware releases.',
    `software_version_id` BIGINT COMMENT 'Foreign key linking to mobility.software_version. Business justification: OTA campaign targets a specific software version; use FK to software_version for version control.',
    `approval_status` STRING COMMENT 'Current approval state of the campaign after internal review.. Valid values are `approved|rejected|pending`',
    `audit_status` STRING COMMENT 'Outcome of internal audit of the OTA campaign configuration.. Valid values are `passed|failed|pending`',
    `campaign_name` STRING COMMENT 'Human‑readable name of the OTA campaign.',
    `campaign_status` STRING COMMENT 'Operational state of the OTA campaign lifecycle.. Valid values are `draft|scheduled|in_progress|completed|failed|cancelled`',
    `campaign_type` STRING COMMENT 'Category of software being delivered (e.g., firmware, infotainment, ADAS, security patch, calibration).. Valid values are `firmware|infotainment|adas|security|calibration`',
    `checksum` STRING COMMENT 'Cryptographic hash (e.g., SHA‑256) used to verify integrity of the software package.',
    `compliance_status` STRING COMMENT 'Result of compliance checks against regulatory requirements.. Valid values are `compliant|non_compliant|pending`',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the OTA campaign record was created in the system.',
    `ota_campaign_description` STRING COMMENT 'Detailed description of the OTA campaign purpose and scope.',
    `end_date` DATE COMMENT 'Planned calendar date when the OTA rollout is expected to complete.',
    `estimated_impact_percentage` DECIMAL(18,2) COMMENT 'Projected proportion of the fleet that will successfully receive the update.',
    `firmware_size_mb` DECIMAL(18,2) COMMENT 'Size of the firmware package in megabytes.',
    `max_concurrent_devices` STRING COMMENT 'Maximum number of vehicles that may be updated simultaneously.',
    `notes` STRING COMMENT 'Free‑form field for any supplemental information or comments.',
    `regulatory_reference` STRING COMMENT 'Identifier of the regulatory or compliance document linked to the campaign.',
    `release_notes` STRING COMMENT 'Free‑form text describing changes, fixes, and new features in the update.',
    `rollback_enabled` BOOLEAN COMMENT 'Indicates whether a rollback to the previous software version is permitted.',
    `rollout_strategy` STRING COMMENT 'Planned deployment approach for the campaign.. Valid values are `phased|full|staggered`',
    `scheduled_end_timestamp` TIMESTAMP COMMENT 'Exact date‑time when the system is scheduled to finish the OTA rollout.',
    `scheduled_start_timestamp` TIMESTAMP COMMENT 'Exact date‑time when the system is scheduled to initiate the OTA rollout.',
    `start_date` DATE COMMENT 'Planned calendar date when the OTA rollout begins.',
    `target_market` STRING COMMENT 'Business market segment (e.g., US, EU, China) for the OTA campaign.',
    `target_model_years` STRING COMMENT 'Model year range (e.g., 2022‑2024) of vehicles eligible for the campaign.',
    `target_percentage` DECIMAL(18,2) COMMENT 'Portion of the eligible vehicle fleet to receive the update (0‑100%).',
    `target_region_codes` STRING COMMENT 'Comma‑separated list of ISO‑3 country codes where the campaign is applicable.',
    `target_trim_codes` STRING COMMENT 'List of vehicle trim identifiers that qualify for the update.',
    `target_vehicle_criteria` STRING COMMENT 'Logical expression or JSON defining vehicle population filters (model year, trim, region, etc.).',
    `total_target_vehicles` BIGINT COMMENT 'Count of distinct vehicles that meet the campaign criteria.',
    `updated_by` STRING COMMENT 'User identifier of the person who last updated the OTA campaign record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the OTA campaign record.',
    `created_by` STRING COMMENT 'User identifier of the person who created the OTA campaign record.',
    CONSTRAINT pk_ota_campaign PRIMARY KEY(`ota_campaign_id`)
) COMMENT 'Master record for an OTA (Over-the-Air) software or firmware update campaign targeting a population of connected vehicles. Captures campaign name, campaign type (ECU firmware, infotainment software, ADAS calibration, security patch), target vehicle population criteria (model year, trim, region), software version being deployed, rollout strategy (phased percentage, full fleet), campaign start/end dates, approval status, and regulatory compliance reference. Sourced from Geotab/Bosch IoT OTA management platform.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` (
    `mobility_ota_deployment_id` BIGINT COMMENT 'System-generated unique identifier for each OTA deployment record.',
    `connected_vehicle_id` BIGINT COMMENT 'Internal surrogate key for the vehicle entity within the data lake.',
    `ota_campaign_id` BIGINT COMMENT 'Identifier of the OTA campaign to which this deployment belongs.',
    `vin_registry_id` BIGINT COMMENT 'Internal surrogate key for the vehicle entity within the data lake.',
    `bandwidth_consumed_mb` DECIMAL(18,2) COMMENT 'Total data volume transferred during the OTA download, measured in megabytes.',
    `connection_type` STRING COMMENT 'Network technology used for the OTA download.. Valid values are `cellular|wifi|satellite`',
    `consent_given` BOOLEAN COMMENT 'Indicates whether the vehicle owner has consented to receive the OTA update.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this OTA deployment record was first created in the system.',
    `data_package_size_mb` DECIMAL(18,2) COMMENT 'Size of the OTA software package delivered to the vehicle.',
    `deployment_code` STRING COMMENT 'Business-visible code assigned to the OTA deployment, used for tracking and reporting.',
    `deployment_initiated_timestamp` TIMESTAMP COMMENT 'Timestamp when the OTA campaign was initiated for the vehicle.',
    `download_duration_seconds` STRING COMMENT 'Total time taken to download the OTA package, calculated as download_end_timestamp minus download_start_timestamp.',
    `download_end_timestamp` TIMESTAMP COMMENT 'Timestamp when the OTA package download completed.',
    `download_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the OTA package download began on the vehicle.',
    `failure_reason_code` STRING COMMENT 'Standardized code indicating why the OTA deployment failed, if applicable.',
    `install_duration_seconds` STRING COMMENT 'Total time taken to install the OTA update, calculated as install_end_timestamp minus install_start_timestamp.',
    `install_end_timestamp` TIMESTAMP COMMENT 'Timestamp when the OTA installation process completed.',
    `install_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the OTA installation process started on the vehicle.',
    `mobility_ota_deployment_status` STRING COMMENT 'Current lifecycle status of the OTA deployment.. Valid values are `pending|in_progress|success|failed|rolled_back|canceled`',
    `post_software_version` STRING COMMENT 'Software version installed on the vehicle after successful OTA update.',
    `pre_software_version` STRING COMMENT 'Software version installed on the vehicle before the OTA update.',
    `retry_count` STRING COMMENT 'Number of retry attempts made after a failed OTA deployment.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this OTA deployment record.',
    `vehicle_vin` STRING COMMENT 'Globally unique 17‑character identifier of the vehicle receiving the OTA update.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_mobility_ota_deployment PRIMARY KEY(`mobility_ota_deployment_id`)
) COMMENT 'Transactional record tracking the execution of an OTA campaign update for a specific connected vehicle. Captures deployment initiation timestamp, vehicle consent status, download start/completion timestamps, installation start/completion timestamps, pre-update software version, post-update software version, deployment outcome (success/failed/rolled-back), failure reason code, retry count, and bandwidth consumed. Provides vehicle-level OTA traceability required under UNECE WP.29 R156.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` (
    `tpms_reading_id` BIGINT COMMENT 'System‑generated unique identifier for each TPMS telemetry record.',
    `breakdown_case_id` BIGINT COMMENT 'FK to breakdown case if TPMS reading triggered roadside assistance',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: TPMS readings belong to a specific connected vehicle; VIN column redundant.',
    `alert_flag` BOOLEAN COMMENT 'Indicates whether the reading triggered a driver or service‑center alert.',
    `battery_level_percent` STRING COMMENT 'Remaining battery level of the TPMS sensor expressed as a percentage.',
    `data_quality_flag` BOOLEAN COMMENT 'Quality assessment of the TPMS reading after validation checks.',
    `firmware_version` STRING COMMENT 'Version identifier of the sensor firmware at the time of the reading.',
    `ingestion_timestamp` TIMESTAMP COMMENT 'Date‑time when the TPMS record was loaded into the lakehouse.',
    `latitude` DOUBLE COMMENT 'Geographic latitude of the vehicle when the TPMS reading was recorded.',
    `longitude` DOUBLE COMMENT 'Geographic longitude of the vehicle when the TPMS reading was recorded.',
    `odometer_km` DECIMAL(18,2) COMMENT 'Vehicle odometer reading in kilometres at the moment of the TPMS measurement.',
    `pressure_status` STRING COMMENT 'Derived status of the tire pressure based on business thresholds.. Valid values are `normal|low|critical|flat`',
    `pressure_unit` STRING COMMENT 'Unit of measure for the pressure_value (pounds per square inch or kilopascals).. Valid values are `psi|kpa`',
    `pressure_value` DECIMAL(18,2) COMMENT 'Measured tire pressure from the TPMS sensor.',
    `reading_timestamp` TIMESTAMP COMMENT 'Date‑time when the TPMS sensor measurement was captured on the vehicle.',
    `record_status` STRING COMMENT 'Processing state of the TPMS record within the data pipeline.. Valid values are `new|processed|error`',
    `sensor_serial_number` STRING COMMENT 'Manufacturer‑assigned unique identifier of the TPMS sensor device.',
    `sensor_type` STRING COMMENT 'Type of sensor that generated the event; fixed as TPMS for this product.. Valid values are `tpms`',
    `signal_strength` STRING COMMENT 'Measured RF signal strength of the TPMS sensor transmission (0‑100).',
    `speed_kph` DECIMAL(18,2) COMMENT 'Vehicle speed in kilometres per hour at the time of the TPMS reading.',
    `temperature_unit` STRING COMMENT 'Unit of measure for temperature_value (Celsius or Fahrenheit).. Valid values are `c|f`',
    `temperature_value` DECIMAL(18,2) COMMENT 'Measured temperature of the tire at the time of the pressure reading.',
    `wheel_position` STRING COMMENT 'Location of the wheel on the vehicle (Front‑Left, Front‑Right, Rear‑Left, Rear‑Right, Spare).. Valid values are `FL|FR|RL|RR|SPARE`',
    CONSTRAINT pk_tpms_reading PRIMARY KEY(`tpms_reading_id`)
) COMMENT 'Transactional record of TPMS (Tire Pressure Monitoring System) sensor telemetry readings for each wheel position on a connected vehicle. Captures reading timestamp, VIN reference, wheel position (FL/FR/RL/RR/spare), measured tire pressure (PSI/kPa), tire temperature, sensor battery level, pressure status (normal/low/critical/flat), and alert flag. Feeds predictive maintenance alerts and customer-facing TPMS monitoring service. Sourced from vehicle telematics stream.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`geofence` (
    `geofence_id` BIGINT COMMENT 'Unique system-generated identifier for the geofence.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: Geofence speed limits and restrictions depend on jurisdictional regulations; linking enables jurisdiction‑specific enforcement.',
    `mobility_fleet_account_id` BIGINT COMMENT 'Identifier of the fleet account to which the geofence belongs.',
    `activation_status` STRING COMMENT 'Current activation state of the geofence.. Valid values are `active|inactive|pending`',
    `allowed_vehicle_type` STRING COMMENT 'Vehicle categories permitted to enter the geofence.. Valid values are `car|truck|suv|ev|hybrid|bus`',
    `area_sq_meters` DECIMAL(18,2) COMMENT 'Calculated surface area of the geofence.',
    `associated_service` STRING COMMENT 'Name of the mobility service (e.g., OTA, V2X) that uses this geofence.',
    `audit_status` STRING COMMENT 'Result of the latest audit (passed, failed, or pending).. Valid values are `passed|failed|pending`',
    `center_latitude` DOUBLE COMMENT 'Latitude of the geofence centre point (used for circular geofences).',
    `center_longitude` DOUBLE COMMENT 'Longitude of the geofence centre point (used for circular geofences).',
    `city` STRING COMMENT 'City where the geofence is located.',
    `geofence_code` STRING COMMENT 'Business-visible code used to reference the geofence in external systems.',
    `compliance_status` STRING COMMENT 'Regulatory compliance state of the geofence definition.. Valid values are `compliant|non_compliant|pending`',
    `country` STRING COMMENT 'Country of the geofence location.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the geofence record was first created.',
    `data_retention_days` STRING COMMENT 'Number of days telemetry related to this geofence is retained.',
    `geofence_description` STRING COMMENT 'Detailed description of the geofence purpose and characteristics.',
    `effective_end_date` DATE COMMENT 'Date when the geofence expires or is de‑commissioned (nullable).',
    `effective_start_date` DATE COMMENT 'Date when the geofence becomes effective.',
    `external_reference_code` STRING COMMENT 'Identifier used by external systems to reference this geofence.',
    `geometry_coordinates` STRING COMMENT 'Well‑Known Text (WKT) representation of the geofence geometry.',
    `geometry_type` STRING COMMENT 'Shape type that defines the geofence geometry.. Valid values are `polygon|circle|corridor`',
    `is_default` BOOLEAN COMMENT 'Indicates whether this geofence is the default for its purpose.',
    `last_audit_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent compliance audit for the geofence.',
    `max_speed_limit_kph` DECIMAL(18,2) COMMENT 'Maximum vehicle speed allowed within the geofence.',
    `min_speed_limit_kph` DECIMAL(18,2) COMMENT 'Minimum vehicle speed required within the geofence.',
    `geofence_name` STRING COMMENT 'Human‑readable name of the geofence.',
    `notes` STRING COMMENT 'Free‑form field for any supplemental information.',
    `odometer_limit_km` DECIMAL(18,2) COMMENT 'Maximum cumulative odometer reading allowed while inside the geofence.',
    `perimeter_meters` DECIMAL(18,2) COMMENT 'Total perimeter length of the geofence boundary.',
    `purpose` STRING COMMENT 'Business purpose of the geofence, e.g., fleet zone, ODD, restricted area.. Valid values are `fleet_zone|odd|restricted_zone|dealer_territory|charging_proximity`',
    `radius_meters` DECIMAL(18,2) COMMENT 'Radius of the geofence when geometry_type is circle.',
    `region_code` STRING COMMENT 'Three‑letter ISO code representing the region of the geofence.. Valid values are `USA|CAN|MEX|GBR|DEU|JPN`',
    `state` STRING COMMENT 'State or province of the geofence location.',
    `updated_by` STRING COMMENT 'User identifier that performed the latest update.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the geofence record.',
    `version_number` STRING COMMENT 'Incremental version of the geofence definition for change tracking.',
    `created_by` STRING COMMENT 'User identifier that created the geofence record.',
    CONSTRAINT pk_geofence PRIMARY KEY(`geofence_id`)
) COMMENT 'Master record defining a geographic boundary (geofence) used in fleet management, mobility services, and autonomous driving feature activation zones. Captures geofence name, geometry type (polygon, circle, corridor), coordinate set, geofence purpose (fleet zone, ODD operational design domain for ADAS, restricted zone, dealer territory, charging station proximity), activation status, and associated service or fleet account. Used by fleet operators and autonomous feature entitlement management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` (
    `geofence_event_id` BIGINT COMMENT 'System-generated unique identifier for each geofence event record.',
    `geofence_id` BIGINT COMMENT 'Unique identifier of the defined geofence area.',
    `telematics_device_id` BIGINT COMMENT 'Identifier of the telematics hardware that reported the geofence event.',
    `battery_level_percent` STRING COMMENT 'Remaining battery charge of the vehicle (relevant for EV/HEV) at the event time.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the geofence event record was first created in the lakehouse.',
    `data_quality_flag` BOOLEAN COMMENT 'Indicates whether the event data passed validation checks (true = valid).',
    `dwell_duration_seconds` STRING COMMENT 'Length of time the vehicle remained inside the geofence before exiting; populated for exit events.',
    `event_source` STRING COMMENT 'Communication channel used to transmit the geofence event data.. Valid values are `gps|cellular|v2x`',
    `event_timestamp` TIMESTAMP COMMENT 'Date and time when the vehicle crossed the geofence boundary.',
    `event_type` STRING COMMENT 'Type of geofence interaction: entry, exit, or dwell within the boundary.. Valid values are `entry|exit|dwell`',
    `latitude` DOUBLE COMMENT 'Geographic latitude of the vehicle at the geofence crossing point.',
    `longitude` DOUBLE COMMENT 'Geographic longitude of the vehicle at the geofence crossing point.',
    `odometer_km` DECIMAL(18,2) COMMENT 'Vehicle odometer reading at the time of the event, expressed in kilometers.',
    `processing_status` STRING COMMENT 'Current processing state of the event within the data pipeline.. Valid values are `pending|processed|error`',
    `signal_strength_dbm` STRING COMMENT 'Radio signal strength of the telematics device when the event was recorded.',
    `speed_kph` DECIMAL(18,2) COMMENT 'Speed of the vehicle at the moment of crossing, measured in kilometers per hour.',
    `triggered_action` STRING COMMENT 'Business action automatically initiated by the event, such as sending an alert, activating a service, or notifying fleet management.. Valid values are `alert_sent|service_activated|fleet_notification|none`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the geofence event record.',
    `vehicle_vin` STRING COMMENT 'Globally unique identifier of the vehicle involved in the geofence event.',
    CONSTRAINT pk_geofence_event PRIMARY KEY(`geofence_event_id`)
) COMMENT 'Transactional record of a vehicle entering or exiting a defined geofence boundary. Captures event timestamp, VIN reference, geofence reference, event type (entry/exit/dwell), vehicle speed at crossing, dwell duration (for exit events), and triggered action (alert sent, service activated, fleet notification). Used for fleet compliance monitoring, ADAS ODD boundary enforcement, and usage-based service activation.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_account` (
    `mobility_fleet_account_id` BIGINT COMMENT 'Unique identifier for the mobility_fleet_account data product (auto-inserted pre-linking).',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Fleet accounting requires mapping each fleet account to a cost center for expense tracking in the Fleet Cost Allocation report.',
    `customer_fleet_account_id` BIGINT COMMENT 'SSOT reference to customer.customer_fleet_account (resolves cross-domain duplicate of fleet_account).',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Fleet Account Management links fleet accounts to the responsible dealer for financing, support, and reporting.',
    CONSTRAINT pk_mobility_fleet_account PRIMARY KEY(`mobility_fleet_account_id`)
) COMMENT 'Master record for a fleet customer account enrolled in connected mobility and fleet telematics services. Captures fleet account name, fleet type (commercial, government, rental, corporate), total enrolled vehicle count, primary contact reference, billing account reference, contracted service tier, fleet management platform preference, and account status. This is the mobility domains representation of fleet operators as a distinct customer segment — complementary to the customer domains individual customer master.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_vehicle_assignment` (
    `mobility_fleet_vehicle_assignment_id` BIGINT COMMENT 'Unique identifier for the mobility_fleet_vehicle_assignment data product (auto-inserted pre-linking).',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Vehicle assignment should reference the connected_vehicle master record.',
    `mobility_fleet_account_id` BIGINT COMMENT 'Foreign key linking to mobility.mobility_fleet_account. Business justification: Assignment records must capture which fleet account a vehicle is assigned to; the fleet account is the parent entity, so a FK from assignment to fleet account is appropriate.',
    CONSTRAINT pk_mobility_fleet_vehicle_assignment PRIMARY KEY(`mobility_fleet_vehicle_assignment_id`)
) COMMENT 'Association record linking a specific connected vehicle to a fleet account, capturing the assignment start date, assignment end date, vehicle role within the fleet (primary, backup, pool), assigned driver reference, cost center allocation, and assignment status. Manages the many-to-many lifecycle of vehicles within fleet accounts over time, supporting fleet utilization tracking and billing allocation.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` (
    `adas_feature_entitlement_id` BIGINT COMMENT 'System-generated unique identifier for the ADAS feature entitlement record.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Link vehicle VIN to master connected_vehicle record; vehicle VIN is redundant after FK.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: AD​AS feature revenue and profit are measured per profit center; needed for the ADAS Feature Profitability Dashboard.',
    `activation_timestamp` TIMESTAMP COMMENT 'Date and time when the feature became active on the vehicle.',
    `adas_feature_entitlement_status` STRING COMMENT 'Current lifecycle state of the entitlement.. Valid values are `active|inactive|suspended|pending|expired`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the entitlement record was first created.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for the entitlement price. [ENUM-REF-CANDIDATE: USD|EUR|JPY|GBP|CNY|CAD — promote to reference product]',
    `data_plan_type` STRING COMMENT 'Category of data plan associated with the entitlement.. Valid values are `basic|premium|enterprise`',
    `adas_feature_entitlement_description` STRING COMMENT 'Free‑form text describing the entitlement, conditions, or notes.',
    `entitlement_number` STRING COMMENT 'Business identifier for the entitlement, used in contracts and billing.',
    `entitlement_price` DECIMAL(18,2) COMMENT 'Monetary amount charged for the entitlement (if fee‑based).',
    `entitlement_source` STRING COMMENT 'Origin of the entitlement: factory‑installed, over‑the‑air activated, or subscription‑unlocked.. Valid values are `factory|ota|subscription`',
    `expiry_timestamp` TIMESTAMP COMMENT 'Date and time when the entitlement expires or is scheduled to deactivate.',
    `feature_code` STRING COMMENT 'Standardized code representing the ADAS feature in OEM catalogs.',
    `feature_name` STRING COMMENT 'Human‑readable name of the ADAS or autonomous driving feature (e.g., Adaptive Cruise Control).',
    `feature_version` STRING COMMENT 'Version or release identifier of the ADAS feature.',
    `geographic_restriction` STRING COMMENT 'Three‑letter ISO country or region code where the entitlement is valid (e.g., USA, CAN).',
    `is_trial` BOOLEAN COMMENT 'Indicates whether the entitlement is a trial (true) or a full entitlement (false).',
    `last_status_change_timestamp` TIMESTAMP COMMENT 'Timestamp when the status field last changed.',
    `mileage_limit` STRING COMMENT 'Maximum vehicle mileage allowed while the entitlement remains valid.',
    `odometer_at_activation` STRING COMMENT 'Vehicle odometer reading at the moment of activation.',
    `ota_update_capability` BOOLEAN COMMENT 'Indicates if the vehicle can receive OTA updates for this feature.',
    `required_firmware_version` STRING COMMENT 'Minimum vehicle firmware version required for the feature to operate.',
    `subscription_plan` STRING COMMENT 'Identifier of the subscription plan that provides the entitlement, if applicable.',
    `trial_expiry_timestamp` TIMESTAMP COMMENT 'Expiration timestamp for trial entitlements.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the entitlement record.',
    `usage_count` STRING COMMENT 'Cumulative count of feature activations or uses to date.',
    `usage_limit` STRING COMMENT 'Maximum number of times the feature can be used or activated under the entitlement.',
    `v2x_enabled` BOOLEAN COMMENT 'Flag indicating whether Vehicle‑to‑Everything communication is enabled for the feature.',
    CONSTRAINT pk_adas_feature_entitlement PRIMARY KEY(`adas_feature_entitlement_id`)
) COMMENT 'Master record defining which ADAS (Advanced Driver Assistance Systems) and autonomous driving features are entitled and activated for a specific connected vehicle. Captures feature name (e.g., adaptive cruise control, lane keep assist, automated parking, Level 2+ autonomy package), entitlement source (factory-installed, OTA-activated, subscription-unlocked), activation date, expiry date, geographic restriction (ODD boundary reference), and current activation status. Supports feature-as-a-service monetization models.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`usage_record` (
    `usage_record_id` BIGINT COMMENT 'System-generated unique identifier for the usage record.',
    `billing_period_id` BIGINT COMMENT 'Identifier of the billing period to which this usage belongs.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Usage‑based billing entries are posted to a revenue GL account; essential for the Usage Billing Ledger and compliance reporting.',
    `mobile_service_order_id` BIGINT COMMENT 'FK to mobile service order related to this usage record',
    `mobility_service_id` BIGINT COMMENT 'Identifier of the connected mobility service being consumed.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the usage record was first captured in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 code of the currency used for the rating amount.. Valid values are `USD|EUR|CAD|GBP|JPY|CHF`',
    `line_sequence` STRING COMMENT 'Sequential order of the usage line within the billing period.',
    `notes` STRING COMMENT 'Free‑form text for additional information or comments about the usage.',
    `rated_flag` BOOLEAN COMMENT 'Indicates whether the usage has been rated for billing (true) or is pending (false).',
    `rating_amount` DECIMAL(18,2) COMMENT 'Monetary amount resulting from rating the usage, in the transaction currency.',
    `unit_of_measure` STRING COMMENT 'Unit associated with the usage metric (kilometers, hours, megabytes, etc.).. Valid values are `km|hours|mb|calls|activation`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the usage record.',
    `usage_end_timestamp` TIMESTAMP COMMENT 'Timestamp marking the end of the usage interval.',
    `usage_metric_type` STRING COMMENT 'Category of usage measured (e.g., distance driven, connected hours).. Valid values are `distance|connected_hours|data_mb|api_calls|feature_activation`',
    `usage_quantity` DECIMAL(18,2) COMMENT 'Measured amount of the usage metric for the period.',
    `usage_record_status` STRING COMMENT 'Current lifecycle state of the usage record.. Valid values are `active|billed|reversed|closed`',
    `usage_start_timestamp` TIMESTAMP COMMENT 'Timestamp marking the beginning of the usage interval.',
    CONSTRAINT pk_usage_record PRIMARY KEY(`usage_record_id`)
) COMMENT 'Transactional record capturing measurable usage of a connected mobility service by a vehicle or customer within a billing period. Captures usage period start/end, service reference, usage metric type (distance driven km, connected hours, data consumed MB, API calls, feature activations), measured quantity, unit of measure, rated flag, and billing period reference. Feeds usage-based billing in the billing domain and supports usage-based insurance (UBI) programs.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`remote_command` (
    `remote_command_id` BIGINT COMMENT 'System-generated unique identifier for the remote command record.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Remote command services incur operational costs tracked against a cost center; needed for the Remote Command Cost Allocation analysis.',
    `party_id` BIGINT COMMENT 'Identifier of the customer who initiated the command (if applicable).',
    `mobility_fleet_account_id` BIGINT COMMENT 'Identifier of the fleet operator issuing the command (if applicable).',
    `remote_mobility_fleet_account_id` BIGINT COMMENT 'Identifier of the fleet operator issuing the command (if applicable).',
    `acknowledgement_timestamp` TIMESTAMP COMMENT 'Date‑time when the vehicle acknowledged receipt of the command.',
    `command_parameters` STRING COMMENT 'Serialized JSON string containing command‑specific parameters (e.g., target temperature, charge schedule details).',
    `command_reference` STRING COMMENT 'Business identifier or reference code for the remote command issued.',
    `command_source` STRING COMMENT 'Origin of the command request (customer mobile app, fleet management portal, automated rule engine, or call center).. Valid values are `customer_app|fleet_portal|automated_rule|call_center`',
    `command_type` STRING COMMENT 'Category of command sent to the vehicle (e.g., remote start, lock/unlock, climate pre‑conditioning, horn/lights, charge scheduling, speed limit set).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the remote command record was first created in the data lake.',
    `delivery_timestamp` TIMESTAMP COMMENT 'Date‑time when the command was successfully delivered to the vehicles telematics unit.',
    `execution_status` STRING COMMENT 'Result of the command execution on the vehicle.. Valid values are `success|failed|pending|rejected`',
    `expiration_timestamp` TIMESTAMP COMMENT 'Time after which the command is no longer valid if not executed.',
    `failure_reason` STRING COMMENT 'Textual description of why the command failed, if execution_status is failed.',
    `issuance_timestamp` TIMESTAMP COMMENT 'Date‑time when the remote command was created and sent to the vehicle.',
    `priority` STRING COMMENT 'Priority level assigned to the command for processing.. Valid values are `low|medium|high`',
    `scheduled_timestamp` TIMESTAMP COMMENT 'Optional future time at which the command should be executed.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the remote command record.',
    `vehicle_vin` STRING COMMENT 'Unique vehicle identifier to which the command was sent.',
    CONSTRAINT pk_remote_command PRIMARY KEY(`remote_command_id`)
) COMMENT 'Transactional record of a remote command issued to a connected vehicle by a customer, fleet operator, or automated system via the mobility platform. Captures command type (remote start, remote lock/unlock, climate pre-conditioning, horn/lights, charge scheduling for EV, speed limit set), command source (customer app, fleet portal, automated rule), issuance timestamp, delivery timestamp, vehicle acknowledgement timestamp, execution status, and failure reason if applicable.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` (
    `ev_charging_session_id` BIGINT COMMENT 'System-generated unique identifier for the EV charging session record.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Charging sessions are performed for a specific connected vehicle; linking directly to the vehicle removes the need for the redundant VIN string column.',
    `equipment_registry_id` BIGINT COMMENT 'Identifier of the physical charger unit that delivered energy.',
    `ev_charger_id` BIGINT COMMENT 'Identifier of the physical charger unit that delivered energy.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Charging revenue is posted to a specific GL account; required for the EV Charging Revenue Ledger and regulatory revenue reporting.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Owner‑level billing and usage reporting for EV charging sessions depend on associating the session with the party that owns the vehicle.',
    `charger_type` STRING COMMENT 'Technical classification of the charger used for the session.. Valid values are `level1_ac|level2_ac|dc_fast|wireless`',
    `cost_amount` DECIMAL(18,2) COMMENT 'Total monetary amount charged for the session before discounts or taxes.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the charging session record was first created in the data lake.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the monetary amounts.. Valid values are `USD|EUR|GBP|CAD|JPY|CNY`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Monetary discount applied to the session, if any.',
    `end_soc_percent` STRING COMMENT 'Battery state of charge at the end of the session.',
    `end_timestamp` TIMESTAMP COMMENT 'Timestamp when the charging session ended or was terminated.',
    `energy_delivered_kwh` DECIMAL(18,2) COMMENT 'Total electrical energy transferred to the vehicle during the session.',
    `estimated_range_added_km` STRING COMMENT 'Estimated additional driving range provided by the energy delivered, based on vehicle model.',
    `ev_charging_session_status` STRING COMMENT 'Current lifecycle status of the charging session.. Valid values are `completed|in_progress|cancelled|failed|terminated`',
    `firmware_version` STRING COMMENT 'Software version of the charger at the time of the session.',
    `is_ota_update_performed` BOOLEAN COMMENT 'Indicates whether an over‑the‑air firmware update was applied during the session.',
    `latitude` DOUBLE COMMENT 'Latitude of the charging station in decimal degrees.',
    `location_type` STRING COMMENT 'Category of the charging location where the session occurred.. Valid values are `home|public|dealer|work|other`',
    `longitude` DOUBLE COMMENT 'Longitude of the charging station in decimal degrees.',
    `net_amount` DECIMAL(18,2) COMMENT 'Final amount billed to the customer after discounts.',
    `notes` STRING COMMENT 'Optional free‑text field for additional remarks or operator comments.',
    `odometer_km_at_end` STRING COMMENT 'Vehicle odometer reading at the end of the session.',
    `odometer_km_at_start` STRING COMMENT 'Vehicle odometer reading at the start of the session.',
    `payment_method` STRING COMMENT 'Method used to settle the charging session cost.. Valid values are `credit_card|debit_card|account|prepaid|none`',
    `peak_power_kw` DECIMAL(18,2) COMMENT 'Maximum charging power achieved during the session.',
    `session_duration_seconds` BIGINT COMMENT 'Total elapsed time of the charging session.',
    `session_number` STRING COMMENT 'External business identifier assigned to the charging session, used for customer reference and invoicing.',
    `start_soc_percent` STRING COMMENT 'Battery state of charge at the beginning of the session.',
    `start_timestamp` TIMESTAMP COMMENT 'Timestamp when the charging session began.',
    `station_city` STRING COMMENT 'City where the charging station is located.',
    `station_country` STRING COMMENT 'Three‑letter ISO country code of the charging station.',
    `station_name` STRING COMMENT 'Human‑readable name of the charging station.',
    `station_state` STRING COMMENT 'State or province of the charging station location.',
    `termination_reason` STRING COMMENT 'Reason why the charging session ended.. Valid values are `user_stop|full|error|timeout|payment_failed`',
    `tpms_enabled` BOOLEAN COMMENT 'Indicates whether Tire Pressure Monitoring System data was available.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the charging session record.',
    `v2x_enabled` BOOLEAN COMMENT 'Indicates whether Vehicle‑to‑Everything communication was active.',
    CONSTRAINT pk_ev_charging_session PRIMARY KEY(`ev_charging_session_id`)
) COMMENT 'Transactional record of an EV or PHEV charging session for a connected vehicle, capturing charging session start/end timestamps, charging location (home, public EVSE, dealer), charger type (Level 1 AC, Level 2 AC, DC fast charge), energy delivered (kWh), peak charge rate (kW), state of charge at session start and end, estimated range added, charging cost, and session termination reason. Supports EV fleet management, range anxiety analytics, and charging infrastructure planning.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`service_incident` (
    `service_incident_id` BIGINT COMMENT 'Primary key for service_incident',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Service incidents are tied to a specific vehicle; link to connected_vehicle for reporting.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Incidents generate repair expenses allocated to a cost center; required for the Incident Cost Tracking and warranty reserve calculations.',
    `roadside_assistance_case_id` BIGINT COMMENT 'FK to roadside assistance case',
    CONSTRAINT pk_service_incident PRIMARY KEY(`service_incident_id`)
) COMMENT 'Transactional record of a connected mobility service incident or disruption affecting a vehicle or fleet account. Captures incident type (connectivity outage, OTA failure, remote command failure, telematics data gap, TPMS sensor fault, V2X communication failure), incident detection timestamp, affected vehicle or fleet scope, severity level, root cause category, resolution timestamp, and corrective action taken. Distinct from a DTC event (vehicle fault) — this is a service delivery incident.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`mobility_consent_record` (
    `mobility_consent_record_id` BIGINT COMMENT 'Unique identifier for the mobility_consent_record data product (auto-inserted pre-linking).',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Consent records are always associated with a specific connected vehicle; linking enables direct joins to vehicle details and eliminates duplication of vehicle identifiers.',
    `customer_consent_record_id` BIGINT COMMENT 'SSOT reference to customer.customer_consent_record (resolves cross-domain duplicate of consent_record).',
    CONSTRAINT pk_mobility_consent_record PRIMARY KEY(`mobility_consent_record_id`)
) COMMENT 'Master record capturing a vehicle owners or fleet operators data privacy and service consent decisions for connected mobility services. Captures consent type (telematics data collection, location sharing, third-party data sharing, marketing communications, OTA update authorization), consent status (granted/withdrawn/pending), consent timestamp, consent version reference, collection channel (app, dealer, web portal), and jurisdiction (GDPR, CCPA, etc.). Required for regulatory compliance with data privacy laws governing connected vehicle data.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`software_version` (
    `software_version_id` BIGINT COMMENT 'Unique surrogate key for each software version record.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: PROCUREMENT: Software licensing and regulatory reporting need the software vendor (supplier) identified for each version.',
    `checksum` STRING COMMENT 'Cryptographic hash of the software file used for integrity verification.',
    `checksum_algorithm` STRING COMMENT 'Algorithm used to generate the checksum value.. Valid values are `SHA256|MD5|SHA1`',
    `checksum_validated` BOOLEAN COMMENT 'Indicates whether the checksum has been successfully validated after upload.',
    `compatible_vehicle_models` STRING COMMENT 'Comma‑separated list of vehicle model identifiers that can receive this software version.',
    `component_name` STRING COMMENT 'Name of the software component or ECU that the version applies to (e.g., Infotainment ECU, ADAS Controller).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the software version record was first created in the data lake.',
    `software_version_description` STRING COMMENT 'Free‑text description of the software version, its purpose and key changes.',
    `download_url` STRING COMMENT 'Secure URL from which the software package can be retrieved for OTA deployment.',
    `file_format` STRING COMMENT 'Container or encoding format of the software package.. Valid values are `bin|hex|zip|tar`',
    `file_location_path` STRING COMMENT 'Internal storage path or bucket location where the software binary resides.',
    `file_size_bytes` BIGINT COMMENT 'Size of the software binary or package in bytes.',
    `hardware_dependency` STRING COMMENT 'Textual description of hardware prerequisites beyond the minimum version (e.g., specific sensor revisions).',
    `is_mandatory_update` BOOLEAN COMMENT 'True if the update must be applied to maintain compliance or safety.',
    `is_security_update` BOOLEAN COMMENT 'Indicates whether the release contains security‑related patches.',
    `minimum_hardware_version` STRING COMMENT 'Lowest hardware/ECU version required for this software to operate.',
    `regulatory_approval_date` DATE COMMENT 'Date on which regulatory approval was granted.',
    `regulatory_approval_reference` STRING COMMENT 'Reference to the regulatory approval document (e.g., UNECE WP.29 R156 SUMS).',
    `regulatory_approval_status` STRING COMMENT 'Current status of the regulatory approval for this software version.. Valid values are `approved|pending|rejected|revoked`',
    `release_cycle` STRING COMMENT 'Planned cadence for releases of this software component.. Valid values are `monthly|quarterly|annual|ad_hoc`',
    `release_date` DATE COMMENT 'Calendar date on which the software version was officially released.',
    `release_notes` STRING COMMENT 'Detailed release notes documenting bug fixes, new features, and known issues.',
    `release_type` STRING COMMENT 'Classification of the release indicating its purpose and maturity.. Valid values are `production|beta|recall_fix|security_patch|feature_update|test`',
    `release_version_code` STRING COMMENT 'Internal code used by engineering to track the release (e.g., RV20230401).',
    `software_version_status` STRING COMMENT 'Lifecycle status of the software version within the OTA ecosystem.. Valid values are `active|deprecated|retired|pending`',
    `supported_powertrain_type` STRING COMMENT 'Powertrain categories for which the software version is applicable.. Valid values are `ICE|HEV|PHEV|EV|Hybrid`',
    `target_ecu` STRING COMMENT 'Identifier of the electronic control unit (ECU) or system targeted by this software version.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the software version record.',
    `version_number` STRING COMMENT 'Human‑readable version identifier following the vendors versioning scheme (e.g., 2023.04.01).',
    CONSTRAINT pk_software_version PRIMARY KEY(`software_version_id`)
) COMMENT 'Reference master for all software and firmware versions managed within the OTA update ecosystem. Captures software component name, ECU or system target (infotainment, ADAS controller, powertrain ECU, body control module), version number, release type (production, beta, recall-fix, security patch), release date, minimum compatible hardware version, file size, checksum, and regulatory approval reference (UNECE WP.29 R156 SUMS compliance). Used by ota_campaign to define what is being deployed.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`service_tier` (
    `service_tier_id` BIGINT COMMENT 'Primary key for service_tier',
    `field_service_appointment_id` BIGINT COMMENT 'FK to field service appointment associated with this service tier',
    `pricing_plan_id` BIGINT COMMENT 'add column pricing_plan_id (BIGINT) with FK to mobility.pricing_plan.pricing_plan_id - service tiers are associated with specific pricing plans',
    `currency_code` STRING COMMENT 'ISO currency code for fee amounts',
    `service_tier_description` STRING COMMENT 'Detailed description of what the service tier includes',
    `features_included` STRING COMMENT 'Comma-separated list of features included in this tier',
    `included_features` STRING COMMENT 'Features included in this service tier.',
    `included_km` STRING COMMENT 'Number of kilometers included per month in this tier',
    `included_mileage_km` STRING COMMENT 'Kilometers included per month in this tier',
    `max_vehicles` STRING COMMENT 'Maximum number of vehicles accessible under this tier',
    `monthly_fee` DECIMAL(18,2) COMMENT 'Monthly subscription fee for the service tier.',
    `sla_response_hours` STRING COMMENT 'Guaranteed response time in hours for service requests under this tier',
    `service_tier_status` STRING COMMENT 'Current status of the service tier (active, deprecated, planned)',
    `tier_level` STRING COMMENT 'Ordinal level of the tier (1=basic, higher=premium).',
    `tier_name` STRING COMMENT 'Name of the mobility service tier.',
    `tier_status` STRING COMMENT 'Lifecycle status of the service tier.',
    `vehicle_class` STRING COMMENT 'Vehicle class available in this tier (compact, sedan, SUV, luxury)',
    CONSTRAINT pk_service_tier PRIMARY KEY(`service_tier_id`)
) COMMENT 'Reference data defining the service tier levels available for connected mobility subscriptions (e.g., Basic Connectivity, Advanced Telematics, Premium Connected, Fleet Pro). Captures tier name, tier code, included feature set, data allowance, OTA update frequency, remote diagnostics depth, V2X capability flag, ADAS feature access level, support SLA level, and pricing tier reference. Used by mobility_service and service_subscription to classify entitlement levels.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` (
    `vehicle_service_subscription_id` BIGINT COMMENT 'Primary key for the VehicleServiceSubscription association',
    `connected_vehicle_id` BIGINT COMMENT 'FK to the connected vehicle being subscribed',
    `field_service_appointment_id` BIGINT COMMENT 'FK to field service appointment under this subscription',
    `mobility_service_id` BIGINT COMMENT 'FK to the mobility service offered',
    `billing_amount` DECIMAL(18,2) COMMENT 'Amount billed for each billing cycle',
    `billing_cycle` STRING COMMENT 'Billing frequency (monthly, yearly, usage‑based)',
    `end_date` DATE COMMENT 'Date the subscription ends or is terminated',
    `start_date` DATE COMMENT 'Date the subscription became effective',
    `subscription_number` STRING COMMENT 'Business identifier for the subscription contract',
    `subscription_type` STRING COMMENT 'Type of subscription (e.g., recurring, prepaid)',
    `vehicle_service_subscription_status` STRING COMMENT 'Current lifecycle status of the subscription (active, suspended, cancelled)',
    CONSTRAINT pk_vehicle_service_subscription PRIMARY KEY(`vehicle_service_subscription_id`)
) COMMENT 'Represents the contractual subscription linking a connected vehicle to a mobility service. Each record captures the specific terms of that subscription such as dates, status, billing cycle and amount, which belong to the relationship rather than to the vehicle or service alone.. Existence Justification: A connected vehicle can be subscribed to multiple mobility services (e.g., OTA updates, V2X, remote diagnostics) and each mobility service can be provisioned for many vehicles across the fleet. The subscription itself is a managed business entity that records start/end dates, status, billing cycle and amount, and is created, updated, and terminated by operational processes.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` (
    `ev_charger_id` BIGINT COMMENT 'Primary key for ev_charger',
    `functional_location_id` BIGINT COMMENT 'Reference to the physical site or parking location where the charger is installed.',
    `parent_ev_charger_id` BIGINT COMMENT 'Self-referencing FK on ev_charger (parent_ev_charger_id)',
    `pricing_plan_id` BIGINT COMMENT 'Reference to the pricing plan governing usage fees for this charger.',
    `address_line1` STRING COMMENT 'Primary street address of the charger location.',
    `asset_tag` STRING COMMENT 'Internal asset‑tracking tag used by Automotive for inventory and maintenance.',
    `average_session_duration_minutes` DECIMAL(18,2) COMMENT 'Mean length of charging sessions in minutes.',
    `carbon_emission_reduction_kg` DECIMAL(18,2) COMMENT 'Estimated kilograms of CO₂ emissions avoided due to the charger’s operation.',
    `city` STRING COMMENT 'City where the charger is located.',
    `commissioning_date` DATE COMMENT 'Date the charger became operational and was accepted by the network.',
    `compliance_certifications` STRING COMMENT 'Comma‑separated list of safety and regulatory certifications (e.g., UL, IEC 61851).',
    `connector_type` STRING COMMENT 'Standardized connector plug type supported by the charger.',
    `country_code` STRING COMMENT 'Three‑letter ISO country code of the charger location.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the charger record was first created in the data lake.',
    `current_amperage` STRING COMMENT 'Maximum current the charger can draw, expressed in amperes.',
    `ev_charger_description` STRING COMMENT 'Free‑form description of the charger, including any special notes or installation details.',
    `firmware_version` STRING COMMENT 'Version identifier of the charger’s embedded firmware.',
    `installation_cost` DECIMAL(18,2) COMMENT 'Capital expense incurred to install the charger at its site, in USD.',
    `installation_date` DATE COMMENT 'Date the charger was physically installed at its site.',
    `is_active` BOOLEAN COMMENT 'True if the charger is currently enabled for charging sessions.',
    `is_public_access` BOOLEAN COMMENT 'True if the charger is available to the general public; false if private/enterprise only.',
    `last_maintenance_date` DATE COMMENT 'Date the charger most recently underwent scheduled maintenance.',
    `latitude` DOUBLE COMMENT 'Geographic latitude coordinate of the charger (WGS‑84).',
    `longitude` DOUBLE COMMENT 'Geographic longitude coordinate of the charger (WGS‑84).',
    `maintenance_interval_days` STRING COMMENT 'Scheduled number of days between routine maintenance activities.',
    `manufacturer` STRING COMMENT 'Company that produced the charger unit.',
    `max_session_duration_minutes` DECIMAL(18,2) COMMENT 'Longest recorded charging session duration in minutes.',
    `min_session_duration_minutes` DECIMAL(18,2) COMMENT 'Shortest recorded charging session duration in minutes.',
    `model_number` STRING COMMENT 'Manufacturer‑provided model identifier for the charger hardware.',
    `ev_charger_name` STRING COMMENT 'Human‑readable name or label assigned to the charger for display in portals and dashboards.',
    `network_provider` STRING COMMENT 'Company that operates the communication network for the charger (e.g., ChargePoint, EVgo).',
    `operational_cost` DECIMAL(18,2) COMMENT 'Recurring cost to operate and maintain the charger per month, in USD.',
    `power_rating_kw` DECIMAL(18,2) COMMENT 'Maximum power output the charger can deliver, expressed in kilowatts.',
    `region` STRING COMMENT 'State or province of the charger location.',
    `safety_rating` STRING COMMENT 'Safety classification of the charger according to industry standards.',
    `serial_number` STRING COMMENT 'Unique serial number stamped on the charger hardware.',
    `software_version` STRING COMMENT 'Version of the charger’s management software stack.',
    `ev_charger_status` STRING COMMENT 'Current lifecycle status of the charger.',
    `total_energy_delivered_kwh` DECIMAL(18,2) COMMENT 'Aggregate energy (kilowatt‑hours) dispensed by the charger across all sessions.',
    `total_sessions` BIGINT COMMENT 'Cumulative count of charging sessions recorded for the charger.',
    `ev_charger_type` STRING COMMENT 'Classification of charger as AC (Level 2) or DC (Fast) based on power delivery method.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the charger record.',
    `voltage` STRING COMMENT 'Nominal operating voltage of the charger.',
    `warranty_end_date` DATE COMMENT 'Date when the manufacturer warranty expires.',
    `warranty_start_date` DATE COMMENT 'Date when the manufacturer warranty begins.',
    `zip_code` STRING COMMENT 'Postal/ZIP code for the charger site.',
    CONSTRAINT pk_ev_charger PRIMARY KEY(`ev_charger_id`)
) COMMENT 'Master reference table for ev_charger. Referenced by charger_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` (
    `pricing_plan_id` BIGINT COMMENT 'Primary key for pricing_plan',
    `superseded_pricing_plan_id` BIGINT COMMENT 'Self-referencing FK on pricing_plan (superseded_pricing_plan_id)',
    `auto_renew` BOOLEAN COMMENT 'Indicates whether the plan automatically renews at term end.',
    `base_price` DECIMAL(18,2) COMMENT 'Standard recurring charge for the plan before any usage or overage fees.',
    `billing_cycle` STRING COMMENT 'Frequency at which the plan is billed to the customer.',
    `compliance_regulation` STRING COMMENT 'Regulatory frameworks governing the plan (e.g., GDPR, CCPA). [ENUM-REF-CANDIDATE: GDPR|CCPA|HIPAA|PCI_DSS|ISO27001|NIST|Other — promote to reference product]',
    `contract_term_months` STRING COMMENT 'Fixed length of the contract in months.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the pricing plan record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code used for all monetary amounts in the plan.',
    `data_retention_days` STRING COMMENT 'Number of days telemetry data is retained for the plan.',
    `pricing_plan_description` STRING COMMENT 'Detailed free‑text description of the plan, its purpose and target market.',
    `effective_end_date` DATE COMMENT 'Date on which the pricing plan expires; null for open‑ended plans.',
    `effective_start_date` DATE COMMENT 'Date on which the pricing plan becomes binding.',
    `eligibility_criteria` STRING COMMENT 'Business rules that determine which customers or vehicles may subscribe to the plan.',
    `external_system_code` STRING COMMENT 'Identifier of the pricing plan in an external billing or CRM system.',
    `feature_set` STRING COMMENT 'Comma‑separated list of features or services included in the plan.',
    `is_trial` BOOLEAN COMMENT 'True if the plan is a trial offering.',
    `last_modified_by` STRING COMMENT 'User identifier of the person who last updated the pricing plan record.',
    `max_devices` STRING COMMENT 'Maximum number of connected vehicle devices permitted under the plan.',
    `overage_rate` DECIMAL(18,2) COMMENT 'Charge applied per unit of usage beyond the included limit.',
    `plan_code` STRING COMMENT 'External business code used to reference the pricing plan in contracts and external systems.',
    `plan_name` STRING COMMENT 'Human‑readable name of the pricing plan.',
    `plan_type` STRING COMMENT 'Category of the plan indicating how charges are structured.',
    `price_adjustment_amount` DECIMAL(18,2) COMMENT 'Monetary amount of the manual price adjustment.',
    `price_adjustment_reason` STRING COMMENT 'Reason for any manual price adjustment applied to the plan.',
    `promotional_discount_percent` DECIMAL(18,2) COMMENT 'Percentage discount applied when promotional_flag is true.',
    `promotional_flag` BOOLEAN COMMENT 'True if the plan is currently offered as a promotion.',
    `region_code` STRING COMMENT 'Three‑letter ISO country/region code where the plan is offered.',
    `pricing_plan_status` STRING COMMENT 'Current lifecycle state of the pricing plan.',
    `support_level` STRING COMMENT 'Level of customer support included with the plan.',
    `tax_included` BOOLEAN COMMENT 'Indicates whether taxes are included in the base_price.',
    `tax_rate` DECIMAL(18,2) COMMENT 'Applicable tax rate expressed as a percentage.',
    `termination_fee` DECIMAL(18,2) COMMENT 'Fee charged to the customer if the plan is terminated early.',
    `trial_period_days` STRING COMMENT 'Number of days the trial period lasts.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the pricing plan record.',
    `usage_limit_quantity` STRING COMMENT 'Maximum amount of usage included in the plan before overage charges apply.',
    `usage_limit_unit` STRING COMMENT 'Unit of measure for the usage limit (e.g., gigabytes, kilometers).',
    `vehicle_type` STRING COMMENT 'Vehicle categories that the plan applies to.',
    `version_number` STRING COMMENT 'Incremental version number for optimistic concurrency control.',
    `created_by` STRING COMMENT 'User identifier of the person who created the pricing plan record.',
    CONSTRAINT pk_pricing_plan PRIMARY KEY(`pricing_plan_id`)
) COMMENT 'Master reference table for pricing_plan. Referenced by pricing_plan_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`mobility_route` (
    `mobility_route_id` BIGINT COMMENT 'Primary key for local mobility_route reference',
    `route_id` BIGINT COMMENT 'FK reference to SSOT logistics.route',
    CONSTRAINT pk_mobility_route PRIMARY KEY(`mobility_route_id`)
) COMMENT 'Reference to SSOT owner logistics.route. Master reference table for route. Referenced by route_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` (
    `mobility_service_id` BIGINT COMMENT 'Unique identifier for the mobility service offering.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Service management dashboards track which employee manages each mobility service for SLA compliance and accountability.',
    `aftersales_nameplate_id` BIGINT COMMENT 'Foreign key linking to product.nameplate. Business justification: Service eligibility matrix links services to specific vehicle nameplates for subscription eligibility and regulatory reporting.',
    `service_tier_id` BIGINT COMMENT 'Reference to the pricing tier applicable to the service.',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Needed for Service Supplier Management report that tracks which external supplier provides each mobility service for billing, compliance, and warranty.',
    `billing_cycle` STRING COMMENT 'Frequency of billing for the service.. Valid values are `monthly|annual|quarterly`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the service record was first created.',
    `currency` STRING COMMENT 'ISO 4217 currency code for the service price.',
    `data_privacy_level` STRING COMMENT 'Classifies the privacy level of data collected by the service.. Valid values are `public|internal|confidential|restricted`',
    `data_retention_period_days` STRING COMMENT 'Number of days the service usage data is retained.',
    `device_compatibility` STRING COMMENT 'List of compatible telematics devices or platforms (e.g., Bosch, Geotab).',
    `eligibility_rules` STRING COMMENT 'Business rules that determine which customers or vehicles may subscribe to the service.',
    `end_of_service_date` DATE COMMENT 'Date when the service is retired or no longer offered.',
    `is_premium` BOOLEAN COMMENT 'Indicates whether the service is classified as a premium offering.',
    `launch_date` DATE COMMENT 'Date when the service became available to customers.',
    `max_simultaneous_devices` STRING COMMENT 'Maximum number of vehicle devices that can be linked to a single subscription.',
    `ota_update_capability` BOOLEAN COMMENT 'Indicates whether the service includes over‑the‑air software updates.',
    `predictive_maintenance_enabled` BOOLEAN COMMENT 'Indicates whether the service provides predictive maintenance alerts.',
    `price` DECIMAL(18,2) COMMENT 'Base price of the service before taxes or discounts.',
    `provider` STRING COMMENT 'Internal business unit or external partner delivering the service.',
    `regulatory_approval_date` DATE COMMENT 'Date when regulatory approval was granted.',
    `regulatory_approval_status` STRING COMMENT 'Regulatory compliance status of the service.. Valid values are `approved|pending|rejected`',
    `remote_diagnostics_enabled` BOOLEAN COMMENT 'Indicates whether remote vehicle health diagnostics are part of the service.',
    `service_category` STRING COMMENT 'Broad classification of the service (e.g., remote diagnostics, OTA updates, V2X). [ENUM-REF-CANDIDATE: remote_diagnostics|predictive_maintenance|ota_update|tpms_monitoring|v2x|fleet_telematics|autonomous_feature_package|usage_based_insurance — promote to reference product]',
    `service_code` STRING COMMENT 'External business code used to reference the service in contracts and catalogs.',
    `service_description` STRING COMMENT 'Detailed textual description of the service offering.',
    `service_name` STRING COMMENT 'Human‑readable name of the mobility service.',
    `service_status` STRING COMMENT 'Current lifecycle state of the service offering.. Valid values are `active|inactive|retired|draft|pending`',
    `sla_description` STRING COMMENT 'Narrative description of the service level agreement terms.',
    `sla_hours` STRING COMMENT 'Target response time in hours for service‑related incidents.',
    `subscription_type` STRING COMMENT 'Billing model for the service.. Valid values are `subscription|pay_per_use|one_time|tiered`',
    `supported_vehicle_models` STRING COMMENT 'List or pattern of vehicle models (by platform or VIN prefix) that can use the service.',
    `tax_included` BOOLEAN COMMENT 'Indicates whether tax is included in the listed price.',
    `tax_rate` DECIMAL(18,2) COMMENT 'Applicable tax rate as a percentage when tax is not included.',
    `terms_url` STRING COMMENT 'Link to the legal terms and conditions governing the service.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the service record.',
    `usage_based_insurance_enabled` BOOLEAN COMMENT 'Indicates whether the service enables usage‑based insurance functionality.',
    `usage_limit` DECIMAL(18,2) COMMENT 'Maximum allowed usage quantity (e.g., miles, hours) per billing period.',
    `usage_metric` STRING COMMENT 'Metric used to measure consumption for usage‑based billing (e.g., data_volume, event_count).',
    `usage_unit` STRING COMMENT 'Unit of measure for the usage limit.. Valid values are `miles|km|hours|events`',
    `v2x_enabled` BOOLEAN COMMENT 'Indicates whether the service provides vehicle‑to‑everything communication features.',
    `version` STRING COMMENT 'Version identifier for the service definition.',
    `version_release_date` DATE COMMENT 'Date when the current service version was released.',
    CONSTRAINT pk_mobility_service PRIMARY KEY(`mobility_service_id`)
) COMMENT 'Catalog of all connected mobility service offerings available for subscription or entitlement, including remote diagnostics, predictive maintenance alerts, OTA update service, TPMS monitoring, V2X communication, fleet telematics, autonomous driving feature packages, and usage-based insurance enablement. Defines service name, category, eligibility rules, supported vehicle platforms, pricing tier reference, and service lifecycle (launch date, EOP date). This is the SSOT for mobility service definitions.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`mobility`.`mobility_route2` (
    `mobility_route2_id` BIGINT COMMENT 'Primary key for mobility_route2',
    `geofence_id` BIGINT COMMENT 'Foreign key to mobility.geofence.geofence_id',
    `route_id` BIGINT COMMENT 'FK to logistics SSOT route record for cross-domain deduplication',
    `ssot_governance_note` STRING COMMENT 'References SSOT route owned by logistics domain via FK.',
    CONSTRAINT pk_mobility_route2 PRIMARY KEY(`mobility_route2_id`)
) COMMENT '';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_mobility_fleet_account_id` FOREIGN KEY (`mobility_fleet_account_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_fleet_account`(`mobility_fleet_account_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_connected_mobility_fleet_account_id` FOREIGN KEY (`connected_mobility_fleet_account_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_fleet_account`(`mobility_fleet_account_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_software_version_id` FOREIGN KEY (`software_version_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`software_version`(`software_version_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_telematics_device_id` FOREIGN KEY (`telematics_device_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`telematics_device`(`telematics_device_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ADD CONSTRAINT `fk_mobility_service_subscription_mobility_service_id` FOREIGN KEY (`mobility_service_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_service`(`mobility_service_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ADD CONSTRAINT `fk_mobility_telemetry_event_trip_id` FOREIGN KEY (`trip_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`trip`(`trip_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ADD CONSTRAINT `fk_mobility_trip_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ADD CONSTRAINT `fk_mobility_trip_mobility_route_id` FOREIGN KEY (`mobility_route_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_route`(`mobility_route_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ADD CONSTRAINT `fk_mobility_trip_telematics_device_id` FOREIGN KEY (`telematics_device_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`telematics_device`(`telematics_device_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_dtc_event` ADD CONSTRAINT `fk_mobility_mobility_dtc_event_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ADD CONSTRAINT `fk_mobility_remote_diagnostic_session_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ADD CONSTRAINT `fk_mobility_predictive_maintenance_alert_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ADD CONSTRAINT `fk_mobility_ota_campaign_software_version_id` FOREIGN KEY (`software_version_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`software_version`(`software_version_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ADD CONSTRAINT `fk_mobility_mobility_ota_deployment_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ADD CONSTRAINT `fk_mobility_mobility_ota_deployment_ota_campaign_id` FOREIGN KEY (`ota_campaign_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`ota_campaign`(`ota_campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ADD CONSTRAINT `fk_mobility_tpms_reading_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ADD CONSTRAINT `fk_mobility_geofence_mobility_fleet_account_id` FOREIGN KEY (`mobility_fleet_account_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_fleet_account`(`mobility_fleet_account_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ADD CONSTRAINT `fk_mobility_geofence_event_geofence_id` FOREIGN KEY (`geofence_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`geofence`(`geofence_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ADD CONSTRAINT `fk_mobility_geofence_event_telematics_device_id` FOREIGN KEY (`telematics_device_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`telematics_device`(`telematics_device_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_vehicle_assignment` ADD CONSTRAINT `fk_mobility_mobility_fleet_vehicle_assignment_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_vehicle_assignment` ADD CONSTRAINT `fk_mobility_mobility_fleet_vehicle_assignment_mobility_fleet_account_id` FOREIGN KEY (`mobility_fleet_account_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_fleet_account`(`mobility_fleet_account_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ADD CONSTRAINT `fk_mobility_adas_feature_entitlement_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ADD CONSTRAINT `fk_mobility_usage_record_mobility_service_id` FOREIGN KEY (`mobility_service_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_service`(`mobility_service_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ADD CONSTRAINT `fk_mobility_remote_command_mobility_fleet_account_id` FOREIGN KEY (`mobility_fleet_account_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_fleet_account`(`mobility_fleet_account_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ADD CONSTRAINT `fk_mobility_remote_command_remote_mobility_fleet_account_id` FOREIGN KEY (`remote_mobility_fleet_account_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_fleet_account`(`mobility_fleet_account_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ADD CONSTRAINT `fk_mobility_ev_charging_session_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ADD CONSTRAINT `fk_mobility_ev_charging_session_ev_charger_id` FOREIGN KEY (`ev_charger_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`ev_charger`(`ev_charger_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_incident` ADD CONSTRAINT `fk_mobility_service_incident_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_consent_record` ADD CONSTRAINT `fk_mobility_mobility_consent_record_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_tier` ADD CONSTRAINT `fk_mobility_service_tier_pricing_plan_id` FOREIGN KEY (`pricing_plan_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`pricing_plan`(`pricing_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ADD CONSTRAINT `fk_mobility_vehicle_service_subscription_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ADD CONSTRAINT `fk_mobility_vehicle_service_subscription_mobility_service_id` FOREIGN KEY (`mobility_service_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_service`(`mobility_service_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ADD CONSTRAINT `fk_mobility_ev_charger_parent_ev_charger_id` FOREIGN KEY (`parent_ev_charger_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`ev_charger`(`ev_charger_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ADD CONSTRAINT `fk_mobility_ev_charger_pricing_plan_id` FOREIGN KEY (`pricing_plan_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`pricing_plan`(`pricing_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ADD CONSTRAINT `fk_mobility_pricing_plan_superseded_pricing_plan_id` FOREIGN KEY (`superseded_pricing_plan_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`pricing_plan`(`pricing_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ADD CONSTRAINT `fk_mobility_mobility_service_service_tier_id` FOREIGN KEY (`service_tier_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`service_tier`(`service_tier_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_route2` ADD CONSTRAINT `fk_mobility_mobility_route2_geofence_id` FOREIGN KEY (`geofence_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`geofence`(`geofence_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`mobility` SET TAGS ('dbx_pii_division' = 'business');
ALTER SCHEMA `vibe_automotive_v1`.`mobility` SET TAGS ('dbx_pii_domain' = 'mobility');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` SET TAGS ('dbx_pii_subdomain' = 'vehicle_connectivity');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` SET TAGS ('dbx_pii_scope' = 'mvm');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` SET TAGS ('dbx_pii_mvm' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` SET TAGS ('dbx_pii_mvm_scope' = 'included');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `mobility_fleet_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Fleet ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `connected_mobility_fleet_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Fleet ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Driver Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `homologation_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `ota_compliance_approval_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Ota Compliance Approval Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Owner Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `sku_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `software_version_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Version Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Device Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_pii_device' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `activation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Activation Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `activation_status` SET TAGS ('dbx_pii_value_regex' = 'inactive|active|suspended|decommissioned');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `activation_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Activation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `battery_health_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Battery Health (%)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `battery_health_percent` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `battery_health_percent` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `battery_state_of_charge_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Battery State of Charge (%)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `battery_state_of_charge_percent` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `connectivity_tier` SET TAGS ('dbx_pii_business_glossary_term' = 'Connectivity Tier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `connectivity_tier` SET TAGS ('dbx_pii_value_regex' = 'basic|standard|premium');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `data_plan` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Plan');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `data_plan` SET TAGS ('dbx_pii_value_regex' = 'none|payg|monthly|annual');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `data_usage_gb` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Usage (GB)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `data_usage_last_reset` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Usage Reset Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `deactivation_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Deactivation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `device_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Device Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `device_type` SET TAGS ('dbx_pii_value_regex' = 'Geotab_GO|Bosch_IoT|Continental|Delphi|Valeo|Denso');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `diagnostic_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Diagnostic Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `diagnostic_status` SET TAGS ('dbx_pii_value_regex' = 'ok|warning|critical');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `firmware_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Firmware Version');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `geographic_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Geographic Region');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `geographic_region` SET TAGS ('dbx_pii_value_regex' = 'USA|CAN|MEX|DEU|JPN|CHN');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `geographic_region` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `last_diagnostic_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Diagnostic Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `last_error_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Last DTC Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `last_ota_update_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last OTA Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `last_tpms_update_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last TPMS Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `last_v2x_update_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last V2X Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `manufacturer` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Manufacturer');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `mileage_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Mileage (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `mileage_last_update` SET TAGS ('dbx_pii_business_glossary_term' = 'Mileage Last Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `model_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Name');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `model_name` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `ota_capability` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Capability');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ev|phev|hev|ice');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `registration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Registration Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `registration_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Registration Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `registration_status` SET TAGS ('dbx_pii_value_regex' = 'registered|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `sim_iccid` SET TAGS ('dbx_pii_business_glossary_term' = 'SIM ICCID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `sim_iccid` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `sim_iccid` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `sim_iccid` SET TAGS ('dbx_pii_device_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `sim_imsi` SET TAGS ('dbx_pii_business_glossary_term' = 'SIM IMSI');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `sim_imsi` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `sim_imsi` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `sim_imsi` SET TAGS ('dbx_pii_device_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `software_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Software Version');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `subscription_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription End Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `subscription_plan` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Plan');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `subscription_plan` SET TAGS ('dbx_pii_value_regex' = 'basic|standard|premium|enterprise');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `subscription_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Start Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `tpms_capability` SET TAGS ('dbx_pii_business_glossary_term' = 'TPMS Capability');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `v2x_capability` SET TAGS ('dbx_pii_business_glossary_term' = 'V2X Capability');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_pii_value_regex' = 'car|truck|suv|commercial|ev|phev');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `vin` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `vin` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `vin` SET TAGS ('dbx_pii_vehicle_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `warranty_expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `warranty_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ALTER COLUMN `warranty_status` SET TAGS ('dbx_pii_value_regex' = 'in_warranty|out_of_warranty|extended');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` SET TAGS ('dbx_pii_subdomain' = 'vehicle_connectivity');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Telematics Device ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Installed By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `battery_level_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Battery Level (Percent)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `calibration_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Calibration Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `data_plan_expiration` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Plan Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `data_plan_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Plan Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `data_plan_type` SET TAGS ('dbx_pii_value_regex' = 'payg|subscription|none');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `device_make` SET TAGS ('dbx_pii_business_glossary_term' = 'Device Manufacturer (Make)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `device_model` SET TAGS ('dbx_pii_business_glossary_term' = 'Device Model');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `device_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Device Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `device_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|faulty|retired');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `firmware_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Firmware Version');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_pii_business_glossary_term' = 'GPS Latitude');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `gps_latitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_pii_business_glossary_term' = 'GPS Longitude');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `gps_longitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `hardware_generation` SET TAGS ('dbx_pii_business_glossary_term' = 'Hardware Generation');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `iccid` SET TAGS ('dbx_pii_business_glossary_term' = 'Integrated Circuit Card Identifier (ICCID)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `iccid` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `iccid` SET TAGS ('dbx_pii_pii_device' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `iccid` SET TAGS ('dbx_pii_device_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `imei` SET TAGS ('dbx_pii_business_glossary_term' = 'International Mobile Equipment Identity (IMEI)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `imei` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `imei` SET TAGS ('dbx_pii_pii_device' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `imei` SET TAGS ('dbx_pii_device_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `installation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Installation Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `last_firmware_update` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Firmware Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `last_heartbeat_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Heartbeat Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `maintenance_cycle_months` SET TAGS ('dbx_pii_business_glossary_term' = 'Maintenance Cycle (Months)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `odometer_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Odometer Reading (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `operational_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Operational Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `operational_status` SET TAGS ('dbx_pii_value_regex' = 'in_service|out_of_service|maintenance|decommissioned');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `ota_update_capability` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Update Capability');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `owner_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Owner Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `owner_type` SET TAGS ('dbx_pii_value_regex' = 'vehicle|fleet|dealer|service_center');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `provisioning_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Provisioning Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `signal_strength_dbm` SET TAGS ('dbx_pii_business_glossary_term' = 'Signal Strength (dBm)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `temperature_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Device Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `v2x_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'V2X Enabled');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_vehicle_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ALTER COLUMN `warranty_expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` SET TAGS ('dbx_pii_subdomain' = 'vehicle_connectivity');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `service_subscription_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Subscription Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Identifier (CUST_ID)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sales Rep Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `service_customer_party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Identifier (CUST_ID)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `service_customer_party_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `service_customer_party_id` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `mobility_service_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Mobility Service Identifier (SERVICE_ID)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Auto‑Renewal Indicator (AUTO_RENEW)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `billing_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Billing Amount (BILL_AMT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `billing_cycle` SET TAGS ('dbx_pii_business_glossary_term' = 'Billing Cycle (BILL_CYCLE)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `billing_cycle` SET TAGS ('dbx_pii_value_regex' = 'monthly|quarterly|yearly');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `cancellation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Cancellation Date (CANCEL_DT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Cancellation Reason (CANCEL_RSN)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_pii_value_regex' = 'customer_request|service_unavailable|non_payment|contract_end|other');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `compliance_gdpr_consent` SET TAGS ('dbx_pii_business_glossary_term' = 'GDPR Consent Indicator (GDPR_CONSENT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `compliance_gdpr_consent` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `contract_terms` SET TAGS ('dbx_pii_business_glossary_term' = 'Contract Terms (CONTRACT_TERMS)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (CURR_CD)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `data_sharing_opt_in` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Sharing Opt‑In Flag (DATA_SHARING_OPT_IN)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription End Date (END_DT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `entitlement_tier` SET TAGS ('dbx_pii_business_glossary_term' = 'Entitlement Tier (ENT_TIER)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `entitlement_tier` SET TAGS ('dbx_pii_value_regex' = 'basic|standard|premium|enterprise');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Modified By (MOD_BY)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `last_payment_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Payment Date (LAST_PAY_DT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `next_payment_due` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Payment Due Date (NEXT_PAY_DT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `overage_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Overage Amount (OVERAGE_AMT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `overage_fee_applied` SET TAGS ('dbx_pii_business_glossary_term' = 'Overage Fee Applied Indicator (OVERAGE_FLG)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `payment_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Method (PAY_METHOD)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `payment_method` SET TAGS ('dbx_pii_value_regex' = 'credit_card|debit_card|bank_transfer|paypal|apple_pay');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `payment_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Status (PAY_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `payment_status` SET TAGS ('dbx_pii_value_regex' = 'paid|unpaid|failed|pending');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `privacy_policy_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Privacy Policy Version (PRIVACY_VER)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `promo_discount_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Promotional Discount Amount (PROMO_DISC_AMT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `promo_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Promotional End Date (PROMO_END_DT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `promo_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Promotional Start Date (PROMO_START_DT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `promotional_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Promotional Code (PROMO_CD)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `renewal_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Renewal Date (RENEW_DT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `service_subscription_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Status (SUB_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `service_subscription_status` SET TAGS ('dbx_pii_value_regex' = 'active|suspended|cancelled|expired|pending');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Start Date (START_DT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `subscription_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Number (SUB_NUM)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `subscription_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Type (SUB_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `subscription_type` SET TAGS ('dbx_pii_value_regex' = 'connected_mobility|infotainment|diagnostics');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `trial_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Trial End Date (TRIAL_END_DT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `trial_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Trial Period Indicator (TRIAL_FLG)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `usage_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Limit (USAGE_LMT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `usage_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Unit (USAGE_UNIT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `usage_unit` SET TAGS ('dbx_pii_value_regex' = 'GB|minutes|messages');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ALTER COLUMN `usage_used` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Consumed (USAGE_USED)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` SET TAGS ('dbx_pii_subdomain' = 'vehicle_connectivity');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` SET TAGS ('dbx_pii_scope' = 'mvm');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` SET TAGS ('dbx_pii_mvm' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` SET TAGS ('dbx_pii_mvm_scope' = 'included');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `telemetry_event_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Telemetry Event Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `individual_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Driver Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `trip_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Trip Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `altitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Altitude (Meters)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `battery_soc_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Battery State of Charge (SOC) Percentage');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `battery_voltage_volt` SET TAGS ('dbx_pii_business_glossary_term' = 'Battery Voltage (V)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `charging_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `connectivity_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Connectivity Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `engine_rpm` SET TAGS ('dbx_pii_business_glossary_term' = 'Engine Revolutions Per Minute (RPM)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `engine_temperature_c` SET TAGS ('dbx_pii_business_glossary_term' = 'Engine Temperature (°C)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `event_sequence` SET TAGS ('dbx_pii_business_glossary_term' = 'Event Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `event_source` SET TAGS ('dbx_pii_business_glossary_term' = 'Event Source System');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `event_type_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Event Type Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `firmware_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Device Firmware Version');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `fuel_level_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Level Percentage');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `gps_accuracy_m` SET TAGS ('dbx_pii_business_glossary_term' = 'GPS Accuracy (Meters)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `gps_accuracy_m` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `heading_degrees` SET TAGS ('dbx_pii_business_glossary_term' = 'Heading (Degrees)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `ignition_state` SET TAGS ('dbx_pii_business_glossary_term' = 'Ignition State');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `ignition_state` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Latitude (Degrees)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `latitude_accuracy` SET TAGS ('dbx_pii_business_glossary_term' = 'Latitude Accuracy (Meters)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `latitude_accuracy` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `latitude_accuracy` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `location_city` SET TAGS ('dbx_pii_business_glossary_term' = 'Location City');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `location_city` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `location_country` SET TAGS ('dbx_pii_business_glossary_term' = 'Location Country (ISO 3166‑1 Alpha‑3)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `location_state` SET TAGS ('dbx_pii_business_glossary_term' = 'Location State/Province');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `location_state` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Longitude (Degrees)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `longitude_accuracy` SET TAGS ('dbx_pii_business_glossary_term' = 'Longitude Accuracy (Meters)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `longitude_accuracy` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `longitude_accuracy` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `odometer_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Odometer Reading (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `raw_payload` SET TAGS ('dbx_pii_business_glossary_term' = 'Raw Telemetry Payload');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `signal_quality` SET TAGS ('dbx_pii_business_glossary_term' = 'Signal Quality Indicator');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `speed_kph` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Speed (km/h)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `tire_pressure_front_left_psi` SET TAGS ('dbx_pii_business_glossary_term' = 'Front Left Tire Pressure (psi)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `tire_pressure_front_right_psi` SET TAGS ('dbx_pii_business_glossary_term' = 'Front Right Tire Pressure (psi)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `tire_pressure_rear_left_psi` SET TAGS ('dbx_pii_business_glossary_term' = 'Rear Left Tire Pressure (psi)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ALTER COLUMN `tire_pressure_rear_right_psi` SET TAGS ('dbx_pii_business_glossary_term' = 'Rear Right Tire Pressure (psi)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` SET TAGS ('dbx_pii_subdomain' = 'vehicle_connectivity');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `trip_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Trip Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Driver Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Equipment Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `individual_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Driver Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `mobility_route_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Route Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Telematics Device Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_pii_device' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `average_speed_kph` SET TAGS ('dbx_pii_business_glossary_term' = 'Average Speed (km/h)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `battery_state_of_charge_end_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Battery State‑of‑Charge End (%)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `battery_state_of_charge_end_percent` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `battery_state_of_charge_start_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Battery State‑of‑Charge Start (%)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `battery_state_of_charge_start_percent` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `charging_event_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Event Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `destination_latitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Destination Latitude (Degrees)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `destination_latitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `destination_latitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `destination_latitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `destination_longitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Destination Longitude (Degrees)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `destination_longitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `destination_longitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `destination_longitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `distance_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Trip Distance (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `driver_behavior_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Driver Behavior Score');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `driver_behavior_score` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `duration_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Trip Duration (seconds)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `emission_co2_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'CO2 Emissions (kg)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `end_odometer_km` SET TAGS ('dbx_pii_business_glossary_term' = 'End Odometer (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Trip End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `energy_consumed_kwh` SET TAGS ('dbx_pii_business_glossary_term' = 'Energy Consumed (kWh)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `fuel_consumed_liters` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Consumed (liters)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `geo_fence_violation_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Geofence Violation Count');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `geo_fence_violation_count` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `harsh_acceleration_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Harsh Acceleration Event Count');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `harsh_braking_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Harsh Braking Event Count');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `idle_time_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Idle Time (seconds)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `maintenance_alert_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Maintenance Alert Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `max_speed_kph` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Speed (km/h)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `mileage_since_last_service_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Mileage Since Last Service (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Trip Notes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `origin_latitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Origin Latitude (Degrees)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `origin_latitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `origin_latitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `origin_latitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `origin_longitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Origin Longitude (Degrees)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `origin_longitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `origin_longitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `origin_longitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `road_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Road Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `road_type` SET TAGS ('dbx_pii_value_regex' = 'highway|urban|rural|offroad');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `start_odometer_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Start Odometer (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Trip Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `toll_amount_usd` SET TAGS ('dbx_pii_business_glossary_term' = 'Toll Amount (USD)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `toll_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Toll Currency Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `toll_currency` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|CAD|GBP|JPY|AUD');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `traffic_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Traffic Level');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `traffic_level` SET TAGS ('dbx_pii_value_regex' = 'low|moderate|high|severe');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `trip_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Trip Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `trip_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Trip Number (Human Readable)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `trip_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Trip Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `trip_status` SET TAGS ('dbx_pii_value_regex' = 'completed|in_progress|cancelled|failed');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `trip_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Trip Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `trip_type` SET TAGS ('dbx_pii_value_regex' = 'personal|commercial|test|service');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `weather_condition` SET TAGS ('dbx_pii_business_glossary_term' = 'Weather Condition');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ALTER COLUMN `weather_condition` SET TAGS ('dbx_pii_value_regex' = 'clear|rain|snow|fog|storm');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_dtc_event` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_dtc_event` SET TAGS ('dbx_pii_subdomain' = 'vehicle_connectivity');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_dtc_event` SET TAGS ('dbx_pii_field_services_consolidation' = 'see_field_services_domain');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_dtc_event` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_dtc_event` ALTER COLUMN `mobility_dtc_event_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for mobility_dtc_event');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_dtc_event` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` SET TAGS ('dbx_pii_subdomain' = 'vehicle_connectivity');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` SET TAGS ('dbx_pii_field_services_consolidation' = 'see_field_services_domain');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `remote_diagnostic_session_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Remote Diagnostic Session ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `mobile_service_order_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `mobile_service_order_id` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `individual_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Driver Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `remote_individual_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Driver Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Technician Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `battery_state_of_charge_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Battery State of Charge (%)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `battery_state_of_charge_percent` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `connectivity_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Connectivity Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `connectivity_status` SET TAGS ('dbx_pii_value_regex' = 'online|offline|intermittent');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `data_volume_mb` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Volume (MB)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `diagnostic_scope` SET TAGS ('dbx_pii_business_glossary_term' = 'Diagnostic Scope');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `diagnostic_scope` SET TAGS ('dbx_pii_value_regex' = 'full_scan|targeted_ecu|custom');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `error_codes` SET TAGS ('dbx_pii_business_glossary_term' = 'Error Codes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `escalation_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Escalation Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `firmware_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Firmware Version');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `network_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Network Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `network_type` SET TAGS ('dbx_pii_value_regex' = 'cellular|wifi|satellite');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Session Notes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `outcome` SET TAGS ('dbx_pii_business_glossary_term' = 'Session Outcome');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `outcome` SET TAGS ('dbx_pii_value_regex' = 'success|partial_success|failure|escalated');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `recommended_action_codes` SET TAGS ('dbx_pii_business_glossary_term' = 'Recommended Action Codes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `remote_diagnostic_session_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Session Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `remote_diagnostic_session_status` SET TAGS ('dbx_pii_value_regex' = 'pending|in_progress|completed|failed|canceled');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `session_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Session Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `session_duration_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Session Duration (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `session_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Session Initiation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `signal_strength_dbm` SET TAGS ('dbx_pii_business_glossary_term' = 'Signal Strength (dBm)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `triggering_event_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Triggering Event Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `triggering_event_code` SET TAGS ('dbx_pii_value_regex' = '^[PBC][0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `triggering_event_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Triggering Event Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `triggering_event_type` SET TAGS ('dbx_pii_value_regex' = 'dtc|manual|scheduled|ota_update');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `tsb_references` SET TAGS ('dbx_pii_business_glossary_term' = 'Technical Service Bulletin References');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ALTER COLUMN `vehicle_odometer_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Odometer (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` SET TAGS ('dbx_pii_subdomain' = 'vehicle_connectivity');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` SET TAGS ('dbx_pii_scope' = 'mvm');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` SET TAGS ('dbx_pii_consolidated_into' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` SET TAGS ('dbx_pii_field_services_consolidation' = 'see_field_services_domain');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` SET TAGS ('dbx_pii_mvm' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` SET TAGS ('dbx_pii_mvm_scope' = 'included');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `predictive_maintenance_alert_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Predictive Maintenance Alert ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `alert_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Alert Category');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `alert_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Alert Code (ALERT_CODE)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `alert_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Alert Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `alert_status` SET TAGS ('dbx_pii_value_regex' = 'open|acknowledged|resolved|expired');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `component` SET TAGS ('dbx_pii_business_glossary_term' = 'Affected Component or System');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `confidence_percentage` SET TAGS ('dbx_pii_business_glossary_term' = 'Confidence Percentage (CONF_PCT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `failure_mode` SET TAGS ('dbx_pii_business_glossary_term' = 'Predicted Failure Mode Description');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `generation_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Alert Generation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `mileage_at_alert` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Mileage at Alert Generation');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `predicted_failure_end` SET TAGS ('dbx_pii_business_glossary_term' = 'Predicted Failure Window End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `predicted_failure_start` SET TAGS ('dbx_pii_business_glossary_term' = 'Predicted Failure Window Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `recommended_service_action` SET TAGS ('dbx_pii_business_glossary_term' = 'Recommended Service Action');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `resolution_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Alert Resolution Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `severity` SET TAGS ('dbx_pii_business_glossary_term' = 'Alert Severity Level');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `severity` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `temperature_celsius` SET TAGS ('dbx_pii_business_glossary_term' = 'Ambient Temperature at Alert Generation (°C)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` SET TAGS ('dbx_pii_subdomain' = 'software_management');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `ota_campaign_id` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Campaign Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `ota_compliance_approval_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Ota Compliance Approval Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `software_version_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Version Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_value_regex' = 'approved|rejected|pending');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `audit_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `audit_status` SET TAGS ('dbx_pii_value_regex' = 'passed|failed|pending');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `campaign_name` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Campaign Name');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `campaign_name` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `campaign_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Campaign Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `campaign_status` SET TAGS ('dbx_pii_value_regex' = 'draft|scheduled|in_progress|completed|failed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `campaign_type` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Campaign Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `campaign_type` SET TAGS ('dbx_pii_value_regex' = 'firmware|infotainment|adas|security|calibration');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `checksum` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Checksum');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `ota_campaign_description` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Campaign Description');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Campaign End Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `estimated_impact_percentage` SET TAGS ('dbx_pii_business_glossary_term' = 'Estimated Impact Percentage');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `firmware_size_mb` SET TAGS ('dbx_pii_business_glossary_term' = 'Firmware Size (MB)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `max_concurrent_devices` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Concurrent Devices');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Reference');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `release_notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Notes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `rollback_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Rollback Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `rollout_strategy` SET TAGS ('dbx_pii_business_glossary_term' = 'Rollout Strategy');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `rollout_strategy` SET TAGS ('dbx_pii_value_regex' = 'phased|full|staggered');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `scheduled_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Scheduled End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `scheduled_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Scheduled Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Campaign Start Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `target_market` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Market');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `target_model_years` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Model Years');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `target_percentage` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Percentage');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `target_region_codes` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Region Codes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `target_trim_codes` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Trim Codes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `target_vehicle_criteria` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Vehicle Criteria');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `total_target_vehicles` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Target Vehicles');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` SET TAGS ('dbx_pii_subdomain' = 'software_management');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `mobility_ota_deployment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Deployment Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Internal Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `ota_campaign_id` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Campaign Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Internal Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `bandwidth_consumed_mb` SET TAGS ('dbx_pii_business_glossary_term' = 'Bandwidth Consumed (Megabytes)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `connection_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Connection Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `connection_type` SET TAGS ('dbx_pii_value_regex' = 'cellular|wifi|satellite');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `consent_given` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Owner Consent Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `consent_given` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `data_package_size_mb` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Package Size (Megabytes)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `deployment_code` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Deployment Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `deployment_initiated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Deployment Initiated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `download_duration_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Download Duration (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `download_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Download End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `download_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Download Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `failure_reason_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Failure Reason Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `install_duration_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Installation Duration (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `install_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Installation End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `install_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Installation Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `mobility_ota_deployment_status` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Deployment Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `mobility_ota_deployment_status` SET TAGS ('dbx_pii_value_regex' = 'pending|in_progress|success|failed|rolled_back|canceled');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `post_software_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Post‑Update Software Version');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `pre_software_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Pre‑Update Software Version');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `retry_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Retry Count');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_pii_device' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_vehicle_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` SET TAGS ('dbx_pii_subdomain' = 'vehicle_connectivity');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `tpms_reading_id` SET TAGS ('dbx_pii_business_glossary_term' = 'TPMS Reading ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `alert_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Alert Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `battery_level_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Sensor Battery Level Percent');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `data_quality_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Quality Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `firmware_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Firmware Version');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `ingestion_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Ingestion Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `odometer_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Odometer (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `pressure_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Pressure Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `pressure_status` SET TAGS ('dbx_pii_value_regex' = 'normal|low|critical|flat');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `pressure_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Pressure Unit');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `pressure_unit` SET TAGS ('dbx_pii_value_regex' = 'psi|kpa');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `pressure_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Tire Pressure Value');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `reading_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Reading Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `record_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `record_status` SET TAGS ('dbx_pii_value_regex' = 'new|processed|error');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `sensor_serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Sensor Serial Number');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `sensor_serial_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `sensor_serial_number` SET TAGS ('dbx_pii_pii_device' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `sensor_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Sensor Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `sensor_type` SET TAGS ('dbx_pii_value_regex' = 'tpms');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `signal_strength` SET TAGS ('dbx_pii_business_glossary_term' = 'Signal Strength');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `speed_kph` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Speed (kph)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `temperature_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Temperature Unit');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `temperature_unit` SET TAGS ('dbx_pii_value_regex' = 'c|f');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `temperature_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Tire Temperature Value');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `wheel_position` SET TAGS ('dbx_pii_business_glossary_term' = 'Wheel Position');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ALTER COLUMN `wheel_position` SET TAGS ('dbx_pii_value_regex' = 'FL|FR|RL|RR|SPARE');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` SET TAGS ('dbx_pii_subdomain' = 'vehicle_connectivity');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `geofence_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Geofence ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `mobility_fleet_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Fleet Account Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `activation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Geofence Activation Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `activation_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|pending');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `allowed_vehicle_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Allowed Vehicle Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `allowed_vehicle_type` SET TAGS ('dbx_pii_value_regex' = 'car|truck|suv|ev|hybrid|bus');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `area_sq_meters` SET TAGS ('dbx_pii_business_glossary_term' = 'Geofence Area (Square Meters)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `associated_service` SET TAGS ('dbx_pii_business_glossary_term' = 'Associated Mobility Service');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `audit_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Audit Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `audit_status` SET TAGS ('dbx_pii_value_regex' = 'passed|failed|pending');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `center_latitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Center Latitude (Decimal Degrees)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `center_latitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `center_latitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `center_latitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `center_longitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Center Longitude (Decimal Degrees)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `center_longitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `center_longitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `center_longitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `city` SET TAGS ('dbx_pii_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `city` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `geofence_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Geofence Code (GFC)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `geofence_code` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `country` SET TAGS ('dbx_pii_business_glossary_term' = 'Country');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `data_retention_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Retention Period (Days)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `geofence_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Geofence Description');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `geofence_description` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `external_reference_code` SET TAGS ('dbx_pii_business_glossary_term' = 'External Reference Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `geometry_coordinates` SET TAGS ('dbx_pii_business_glossary_term' = 'Geometry Coordinates (WKT Format)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `geometry_coordinates` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `geometry_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Geometry Type (Polygon/Circle/Corridor)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `geometry_type` SET TAGS ('dbx_pii_value_regex' = 'polygon|circle|corridor');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `geometry_type` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `is_default` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Default Geofence Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `last_audit_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Audit Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `max_speed_limit_kph` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Speed Limit (km/h)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `min_speed_limit_kph` SET TAGS ('dbx_pii_business_glossary_term' = 'Minimum Speed Limit (km/h)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `geofence_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Geofence Name');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `geofence_name` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `odometer_limit_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Odometer Limit (Kilometers)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `perimeter_meters` SET TAGS ('dbx_pii_business_glossary_term' = 'Geofence Perimeter (Meters)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `purpose` SET TAGS ('dbx_pii_business_glossary_term' = 'Geofence Purpose (Operational Use Case)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `purpose` SET TAGS ('dbx_pii_value_regex' = 'fleet_zone|odd|restricted_zone|dealer_territory|charging_proximity');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `radius_meters` SET TAGS ('dbx_pii_business_glossary_term' = 'Radius (Meters) for Circular Geofence');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `region_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Region Code (ISO 3166-1 Alpha-3)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `region_code` SET TAGS ('dbx_pii_value_regex' = 'USA|CAN|MEX|GBR|DEU|JPN');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `state` SET TAGS ('dbx_pii_business_glossary_term' = 'State/Province');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `state` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` SET TAGS ('dbx_pii_subdomain' = 'vehicle_connectivity');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `geofence_event_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Geofence Event Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `geofence_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Geofence Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Telematics Device Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `battery_level_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Battery Level Percentage');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `data_quality_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Quality Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `dwell_duration_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Dwell Duration (seconds)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `event_source` SET TAGS ('dbx_pii_business_glossary_term' = 'Event Source Channel');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `event_source` SET TAGS ('dbx_pii_value_regex' = 'gps|cellular|v2x');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Event Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `event_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Geofence Event Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `event_type` SET TAGS ('dbx_pii_value_regex' = 'entry|exit|dwell');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Latitude Coordinate');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Longitude Coordinate');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `odometer_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Odometer Reading (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `processing_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Processing Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `processing_status` SET TAGS ('dbx_pii_value_regex' = 'pending|processed|error');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `signal_strength_dbm` SET TAGS ('dbx_pii_business_glossary_term' = 'Signal Strength (dBm)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `speed_kph` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Speed (km/h)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `triggered_action` SET TAGS ('dbx_pii_business_glossary_term' = 'Triggered Action');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `triggered_action` SET TAGS ('dbx_pii_value_regex' = 'alert_sent|service_activated|fleet_notification|none');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence_event` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_vehicle_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_account` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_account` SET TAGS ('dbx_pii_subdomain' = 'fleet_operations');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_account` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_account` ALTER COLUMN `mobility_fleet_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for mobility_fleet_account');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_account` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_account` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_vehicle_assignment` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_vehicle_assignment` SET TAGS ('dbx_pii_subdomain' = 'fleet_operations');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_vehicle_assignment` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_vehicle_assignment` ALTER COLUMN `mobility_fleet_vehicle_assignment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for mobility_fleet_vehicle_assignment');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_vehicle_assignment` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_vehicle_assignment` ALTER COLUMN `mobility_fleet_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Mobility Fleet Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` SET TAGS ('dbx_pii_subdomain' = 'software_management');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `adas_feature_entitlement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'ADAS Feature Entitlement ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `activation_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Activation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `adas_feature_entitlement_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Entitlement Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `adas_feature_entitlement_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|suspended|pending|expired');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `data_plan_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Plan Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `data_plan_type` SET TAGS ('dbx_pii_value_regex' = 'basic|premium|enterprise');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `adas_feature_entitlement_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Entitlement Description');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `entitlement_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Entitlement Number');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `entitlement_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Entitlement Price');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `entitlement_source` SET TAGS ('dbx_pii_business_glossary_term' = 'Entitlement Source');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `entitlement_source` SET TAGS ('dbx_pii_value_regex' = 'factory|ota|subscription');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `expiry_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiry Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `feature_code` SET TAGS ('dbx_pii_business_glossary_term' = 'ADAS Feature Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `feature_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Advanced Driver Assistance System (ADAS) Feature Name');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `feature_name` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `feature_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Feature Version');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `geographic_restriction` SET TAGS ('dbx_pii_business_glossary_term' = 'Geographic Restriction');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `geographic_restriction` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `is_trial` SET TAGS ('dbx_pii_business_glossary_term' = 'Trial Entitlement Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `last_status_change_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Status Change Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `mileage_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Mileage Limit (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `odometer_at_activation` SET TAGS ('dbx_pii_business_glossary_term' = 'Odometer at Activation (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `ota_update_capability` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Update Capability');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `required_firmware_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Required Firmware Version');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `subscription_plan` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `trial_expiry_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Trial Expiry Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `usage_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Count');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `usage_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Limit');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ALTER COLUMN `v2x_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'V2X Communication Enabled');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` SET TAGS ('dbx_pii_subdomain' = 'fleet_operations');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `usage_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Record ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `billing_period_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Billing Period ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `mobile_service_order_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `mobile_service_order_id` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `mobility_service_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Service ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|CAD|GBP|JPY|CHF');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `line_sequence` SET TAGS ('dbx_pii_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Record Notes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `rated_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Rated Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `rating_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Rating Amount');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'km|hours|mb|calls|activation');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `usage_end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `usage_metric_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Metric Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `usage_metric_type` SET TAGS ('dbx_pii_value_regex' = 'distance|connected_hours|data_mb|api_calls|feature_activation');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `usage_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Quantity');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `usage_record_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Record Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `usage_record_status` SET TAGS ('dbx_pii_value_regex' = 'active|billed|reversed|closed');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ALTER COLUMN `usage_start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` SET TAGS ('dbx_pii_subdomain' = 'fleet_operations');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `remote_command_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Remote Command ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `mobility_fleet_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Fleet Operator ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `remote_mobility_fleet_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Fleet Operator ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `acknowledgement_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Acknowledgement Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `command_parameters` SET TAGS ('dbx_pii_business_glossary_term' = 'Command Parameters JSON');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `command_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Command Reference Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `command_source` SET TAGS ('dbx_pii_business_glossary_term' = 'Remote Command Source');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `command_source` SET TAGS ('dbx_pii_value_regex' = 'customer_app|fleet_portal|automated_rule|call_center');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `command_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Remote Command Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `delivery_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Command Delivery Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `execution_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Command Execution Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `execution_status` SET TAGS ('dbx_pii_value_regex' = 'success|failed|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `expiration_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Command Expiration Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `failure_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Command Failure Reason');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `issuance_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Command Issuance Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Command Priority');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `priority` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `scheduled_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Command Scheduled Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_vehicle_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` SET TAGS ('dbx_pii_subdomain' = 'fleet_operations');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `ev_charging_session_id` SET TAGS ('dbx_pii_business_glossary_term' = 'EV Charging Session ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `equipment_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Charger Asset ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `ev_charger_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Charger Asset ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `charger_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Charger Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `charger_type` SET TAGS ('dbx_pii_value_regex' = 'level1_ac|level2_ac|dc_fast|wireless');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `cost_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Session Gross Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|GBP|CAD|JPY|CNY');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `discount_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Session Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `end_soc_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'End State of Charge (%)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `end_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Session End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `energy_delivered_kwh` SET TAGS ('dbx_pii_business_glossary_term' = 'Energy Delivered (kWh)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `estimated_range_added_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Estimated Range Added (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `ev_charging_session_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Session Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `ev_charging_session_status` SET TAGS ('dbx_pii_value_regex' = 'completed|in_progress|cancelled|failed|terminated');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `firmware_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Charger Firmware Version');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `is_ota_update_performed` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Update Performed Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Station Latitude');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `location_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Location Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `location_type` SET TAGS ('dbx_pii_value_regex' = 'home|public|dealer|work|other');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Station Longitude');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `net_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Session Net Amount');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Session Notes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `odometer_km_at_end` SET TAGS ('dbx_pii_business_glossary_term' = 'Odometer at Session End (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `odometer_km_at_start` SET TAGS ('dbx_pii_business_glossary_term' = 'Odometer at Session Start (km)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `payment_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `payment_method` SET TAGS ('dbx_pii_value_regex' = 'credit_card|debit_card|account|prepaid|none');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `peak_power_kw` SET TAGS ('dbx_pii_business_glossary_term' = 'Peak Power (kW)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `session_duration_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Session Duration (seconds)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `session_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Session Number');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `start_soc_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Start State of Charge (%)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `start_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Session Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `station_city` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Station City');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `station_city` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `station_country` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Station Country');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `station_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Station Name');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `station_name` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `station_state` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Station State/Province');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `station_state` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `termination_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Charging Session Termination Reason');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `termination_reason` SET TAGS ('dbx_pii_value_regex' = 'user_stop|full|error|timeout|payment_failed');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `tpms_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'TPMS Capability Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ALTER COLUMN `v2x_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'V2X Capability Enabled Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_incident` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_incident` SET TAGS ('dbx_pii_subdomain' = 'fleet_operations');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_incident` SET TAGS ('dbx_pii_consolidated_into' = 'field_services');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_incident` SET TAGS ('dbx_pii_field_services_consolidation' = 'see_field_services_domain');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_incident` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_incident` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_incident` ALTER COLUMN `service_incident_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Incident Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_incident` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_incident` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_consent_record` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_consent_record` SET TAGS ('dbx_pii_subdomain' = 'fleet_operations');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_consent_record` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_consent_record` ALTER COLUMN `mobility_consent_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for mobility_consent_record');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_consent_record` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` SET TAGS ('dbx_pii_subdomain' = 'software_management');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `software_version_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Version ID');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `checksum` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Checksum');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `checksum_algorithm` SET TAGS ('dbx_pii_business_glossary_term' = 'Checksum Algorithm');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `checksum_algorithm` SET TAGS ('dbx_pii_value_regex' = 'SHA256|MD5|SHA1');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `checksum_validated` SET TAGS ('dbx_pii_business_glossary_term' = 'Checksum Validation Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `compatible_vehicle_models` SET TAGS ('dbx_pii_business_glossary_term' = 'Compatible Vehicle Models');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `component_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Component Name');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `component_name` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `software_version_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Version Description');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `download_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Download URL');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `file_format` SET TAGS ('dbx_pii_business_glossary_term' = 'Software File Format');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `file_format` SET TAGS ('dbx_pii_value_regex' = 'bin|hex|zip|tar');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `file_location_path` SET TAGS ('dbx_pii_business_glossary_term' = 'File Location Path');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `file_size_bytes` SET TAGS ('dbx_pii_business_glossary_term' = 'Software File Size (Bytes)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `hardware_dependency` SET TAGS ('dbx_pii_business_glossary_term' = 'Hardware Dependency Specification');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `is_mandatory_update` SET TAGS ('dbx_pii_business_glossary_term' = 'Mandatory Update Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `is_security_update` SET TAGS ('dbx_pii_business_glossary_term' = 'Security Update Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `minimum_hardware_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Minimum Hardware Version');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `regulatory_approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `regulatory_approval_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Reference');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_value_regex' = 'approved|pending|rejected|revoked');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `release_cycle` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Cycle');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `release_cycle` SET TAGS ('dbx_pii_value_regex' = 'monthly|quarterly|annual|ad_hoc');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `release_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Release Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `release_notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Notes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `release_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Release Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `release_type` SET TAGS ('dbx_pii_value_regex' = 'production|beta|recall_fix|security_patch|feature_update|test');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `release_version_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Version Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `software_version_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Version Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `software_version_status` SET TAGS ('dbx_pii_value_regex' = 'active|deprecated|retired|pending');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `supported_powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Supported Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `supported_powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|EV|Hybrid');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `target_ecu` SET TAGS ('dbx_pii_business_glossary_term' = 'Target ECU Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Version Number');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_tier` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_tier` SET TAGS ('dbx_pii_subdomain' = 'software_management');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_tier` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_tier` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_tier` ALTER COLUMN `service_tier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Tier Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_tier` ALTER COLUMN `tier_name` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` SET TAGS ('dbx_pii_subdomain' = 'fleet_operations');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` SET TAGS ('dbx_pii_association_edges' = 'mobility.connected_vehicle,mobility.mobility_service');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `vehicle_service_subscription_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicleservicesubscription - Subscription Id');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicleservicesubscription - Connected Vehicle Id');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `mobility_service_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicleservicesubscription - Mobility Service Id');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `billing_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Billing Amount');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `billing_amount` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `billing_cycle` SET TAGS ('dbx_pii_business_glossary_term' = 'Billing Cycle');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `billing_cycle` SET TAGS ('dbx_pii_categorical' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription End Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `end_date` SET TAGS ('dbx_pii_temporal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Start Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `start_date` SET TAGS ('dbx_pii_temporal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `subscription_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Number');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `subscription_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `subscription_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `subscription_type` SET TAGS ('dbx_pii_categorical' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `vehicle_service_subscription_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ALTER COLUMN `vehicle_service_subscription_status` SET TAGS ('dbx_pii_status' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` SET TAGS ('dbx_pii_subdomain' = 'fleet_operations');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `ev_charger_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Ev Charger Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Location Id');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `parent_ev_charger_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Ev Charger Id');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `parent_ev_charger_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `pricing_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Pricing Plan Id');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line1');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_dbx_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `asset_tag` SET TAGS ('dbx_pii_business_glossary_term' = 'Asset Tag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `average_session_duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Average Session Duration Minutes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `carbon_emission_reduction_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Carbon Emission Reduction Kg');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `city` SET TAGS ('dbx_pii_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `city` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `compliance_certifications` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Certifications');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `connector_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Connector Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `current_amperage` SET TAGS ('dbx_pii_business_glossary_term' = 'Current Amperage');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `ev_charger_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `firmware_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Firmware Version');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `installation_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Installation Cost');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `installation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Installation Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `is_active` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Active');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `is_public_access` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Public Access');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Latitude');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_dbx_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_business_glossary_term' = 'Longitude');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_dbx_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_geo_location' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `maintenance_interval_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Maintenance Interval Days');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `manufacturer` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturer');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `max_session_duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Max Session Duration Minutes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `min_session_duration_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Min Session Duration Minutes');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `model_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Number');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `ev_charger_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `ev_charger_name` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `network_provider` SET TAGS ('dbx_pii_business_glossary_term' = 'Network Provider');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `operational_cost` SET TAGS ('dbx_pii_business_glossary_term' = 'Operational Cost');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `power_rating_kw` SET TAGS ('dbx_pii_business_glossary_term' = 'Power Rating Kw');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `region` SET TAGS ('dbx_pii_business_glossary_term' = 'Region');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `safety_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Rating');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `software_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Software Version');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `ev_charger_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `total_energy_delivered_kwh` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Energy Delivered Kwh');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `total_sessions` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Sessions');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `ev_charger_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `voltage` SET TAGS ('dbx_pii_business_glossary_term' = 'Voltage');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `warranty_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty End Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `zip_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Zip Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `zip_code` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `zip_code` SET TAGS ('dbx_pii_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `zip_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `zip_code` SET TAGS ('dbx_pii_dbx_classification' = 'restricted');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ALTER COLUMN `zip_code` SET TAGS ('dbx_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` SET TAGS ('dbx_pii_subdomain' = 'fleet_operations');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `pricing_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Pricing Plan Identifier');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `superseded_pricing_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Superseded Pricing Plan Id');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `superseded_pricing_plan_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `auto_renew` SET TAGS ('dbx_pii_business_glossary_term' = 'Auto Renew');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `base_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Base Price');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `billing_cycle` SET TAGS ('dbx_pii_business_glossary_term' = 'Billing Cycle');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `compliance_regulation` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Regulation');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `contract_term_months` SET TAGS ('dbx_pii_business_glossary_term' = 'Contract Term Months');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `data_retention_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Retention Days');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `pricing_plan_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `eligibility_criteria` SET TAGS ('dbx_pii_business_glossary_term' = 'Eligibility Criteria');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `external_system_code` SET TAGS ('dbx_pii_business_glossary_term' = 'External System Id');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `feature_set` SET TAGS ('dbx_pii_business_glossary_term' = 'Feature Set');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `is_trial` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Trial');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Modified By');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `max_devices` SET TAGS ('dbx_pii_business_glossary_term' = 'Max Devices');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `overage_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Overage Rate');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `plan_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Plan Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Plan Name');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Plan Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `price_adjustment_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Adjustment Amount');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `price_adjustment_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Adjustment Reason');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `promotional_discount_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Promotional Discount Percent');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `promotional_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Promotional Flag');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `region_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `pricing_plan_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `support_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Support Level');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `tax_included` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Included');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `tax_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Rate');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `termination_fee` SET TAGS ('dbx_pii_business_glossary_term' = 'Termination Fee');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `trial_period_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Trial Period Days');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `usage_limit_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Limit Quantity');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `usage_limit_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Limit Unit');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `vehicle_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Type');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`pricing_plan` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_person_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_route` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_route` SET TAGS ('dbx_pii_subdomain' = 'fleet_operations');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_route` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_route` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` SET TAGS ('dbx_pii_subdomain' = 'fleet_operations');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `mobility_service_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Mobility Service Identifier (MSID)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `service_tier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Pricing Tier Identifier (PTID)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `billing_cycle` SET TAGS ('dbx_pii_business_glossary_term' = 'Billing Cycle (BC)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `billing_cycle` SET TAGS ('dbx_pii_value_regex' = 'monthly|annual|quarterly');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (CC)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `data_privacy_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Privacy Level (DPL)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `data_privacy_level` SET TAGS ('dbx_pii_value_regex' = 'public|internal|confidential|restricted');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `data_retention_period_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Retention Period (Days) (DRPD)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `device_compatibility` SET TAGS ('dbx_pii_business_glossary_term' = 'Device Compatibility (DC)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `eligibility_rules` SET TAGS ('dbx_pii_business_glossary_term' = 'Eligibility Rules (ER)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `end_of_service_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Service End‑of‑Production Date (SEOPD)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `is_premium` SET TAGS ('dbx_pii_business_glossary_term' = 'Premium Service Flag (PSF)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `launch_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Launch Date (SLD)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `max_simultaneous_devices` SET TAGS ('dbx_pii_business_glossary_term' = 'Max Simultaneous Devices (MSD)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `max_simultaneous_devices` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `ota_update_capability` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Update Capability (OTA)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `predictive_maintenance_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Predictive Maintenance Enabled (PME)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `price` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Price (SP)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `provider` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Provider (SPRV)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `regulatory_approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Date (RAD)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Status (RAS)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_pii_value_regex' = 'approved|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `remote_diagnostics_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Remote Diagnostics Enabled (RDE)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `service_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Category (SCAT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `service_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Code (SC)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `service_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Description (SD)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `service_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Name (SN)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `service_name` SET TAGS ('dbx_pii_pii_present' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `service_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Lifecycle Status (SLS)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `service_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|retired|draft|pending');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `sla_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Service SLA Description (SSLD)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `sla_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Service SLA Response Time (Hours) (SSLA)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `subscription_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Type (ST)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `subscription_type` SET TAGS ('dbx_pii_value_regex' = 'subscription|pay_per_use|one_time|tiered');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `supported_vehicle_models` SET TAGS ('dbx_pii_business_glossary_term' = 'Supported Vehicle Models (SVM)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `tax_included` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Included Flag (TIF)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `tax_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Rate (Percentage) (TR)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `terms_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Terms URL (STU)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `usage_based_insurance_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage‑Based Insurance Enabled (UBIE)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `usage_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Limit (UL)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `usage_metric` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Metric (UM)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `usage_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Unit (UU)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `usage_unit` SET TAGS ('dbx_pii_value_regex' = 'miles|km|hours|events');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `v2x_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'V2X Communication Enabled (V2X)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `version` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Version (SV)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ALTER COLUMN `version_release_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Version Release Date (SVRD)');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_route2` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_route2` SET TAGS ('dbx_pii_subdomain' = 'fleet_operations');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_route2` SET TAGS ('dbx_pii_mvm_scope' = 'ecm_only');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_route2` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_route2` ALTER COLUMN `mobility_route2_id` SET TAGS ('dbx_pii_business_glossary_term' = 'mobility_route2 Identifier');
