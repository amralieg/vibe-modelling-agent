-- Schema for Domain: store | Business: Retail | Version: v2_mvm
-- Generated on: 2026-07-12 15:26:01

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`store` COMMENT 'Manages physical retail locations including hypermarkets, department stores, discount outlets, dark stores, and micro-fulfillment centers (MFC). Owns store master records, planograms (POG), gondola and endcap configurations, footfall metrics, comp sales (SSS - Same-Store Sales), visual merchandising standards, POS terminal inventory, and store-level P&L. Supports store operations and omnichannel fulfillment as ship-from-store nodes.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`location` (
    `location_id` BIGINT COMMENT 'Unique identifier for the physical retail location. Primary key for the store_location data product. This is the system-of-record identifier used across all domains (inventory, order, workforce, finance) to reference this specific store, dark store, or micro-fulfillment center (MFC).',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.store_format. Business justification: Every store location is classified by a store format (hypermarket, discount outlet, department store, etc.). The store_location record currently denormalizes format_type as a STRING. Adding FK to stor',
    `price_zone_id` BIGINT COMMENT 'Foreign key linking to pricing.price_zone. Business justification: Stores belong to price zones for regional pricing strategies. This is a fundamental retail concept - stores in the same geographic area or market segment share pricing rules. No visible redundant colu',
    `accessibility_certified` BOOLEAN COMMENT 'Indicates whether the store location is certified as fully accessible for customers with disabilities, meeting ADA (Americans with Disabilities Act) or equivalent local accessibility standards. True = certified accessible; False = not certified or non-compliant.',
    `address_line1` STRING COMMENT 'Primary street address line for the store location (street number and name). Used for customer navigation, delivery routing, and regulatory filings. Organizational contact data classified as confidential.',
    `address_line2` STRING COMMENT 'Secondary address line for the store location (suite, unit, building). Null if not applicable. Organizational contact data classified as confidential.',
    `assortment_breadth_norm` STRING COMMENT 'Standard assortment breadth (range of categories) for this store format. Narrow = limited category count (convenience); Moderate = balanced category mix; Broad = wide category range; Very Broad = full-line assortment (hypermarket). Used for merchandising strategy.. Valid values are `narrow|moderate|broad|very_broad`',
    `assortment_depth_norm` STRING COMMENT 'Standard assortment depth (variety within a category) for this store format. Shallow = limited SKU count per category; Moderate = balanced SKU selection; Deep = extensive SKU variety; Very Deep = maximum SKU variety. Used for category management and space planning.. Valid values are `shallow|moderate|deep|very_deep`',
    `banner_brand` STRING COMMENT 'The retail banner or brand under which this location operates (e.g., Retail Hypermarket, Retail Discount, Retail Express). Used for brand segmentation, assortment planning, and marketing strategy.',
    `bopis_capable` BOOLEAN COMMENT 'Indicates whether this store location supports BOPIS (Buy Online Pick Up In Store) fulfillment. True = BOPIS enabled with dedicated pickup area; False = BOPIS not available. Used for omnichannel order routing and customer service.',
    `city` STRING COMMENT 'City or municipality where the store location is situated. Used for geographic segmentation, market analysis, and regulatory compliance.',
    `climate_zone` STRING COMMENT 'Climate zone classification for the store location. Used for seasonal assortment planning, HVAC energy management, and merchandise mix optimization (e.g., winter apparel depth in continental zones).. Valid values are `tropical|subtropical|temperate|continental|polar`',
    `closure_date` DATE COMMENT 'The date this store location permanently ceased operations. Null for active stores. Used for historical analysis, lease termination tracking, and asset disposition planning.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code where the store location is situated (e.g., USA, CAN, MEX). Used for regulatory compliance, currency determination, and international reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this store location record was first created in the system. Used for data lineage, audit trails, and record lifecycle tracking.',
    `district_code` STRING COMMENT 'Code identifying the retail district or region to which this store location belongs. Used for hierarchical reporting, district manager accountability, and regional performance analysis.',
    `dsd_receiving` BOOLEAN COMMENT 'Indicates whether this store location accepts Direct Store Delivery (DSD) from vendors, bypassing the distribution center (DC). True = DSD receiving enabled; False = all inventory flows through DC. Common for beverages, snacks, and bread.',
    `email_address` STRING COMMENT 'Primary email address for the store location. Used for operational communications, customer service escalations, and vendor coordination. Organizational contact data classified as confidential.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `format_size_band` STRING COMMENT 'Size classification band for the store format, used for assortment planning and operational benchmarking. Small = <20K sq ft; Medium = 20K-50K sq ft; Large = 50K-100K sq ft; Extra Large = >100K sq ft. Bands are format-specific.. Valid values are `small|medium|large|extra_large`',
    `last_remodel_date` DATE COMMENT 'The date of the most recent major remodel or renovation of this store location. Used for capital expenditure tracking, store refresh planning, and performance analysis post-remodel.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the store location in decimal degrees. Used for geospatial analysis, delivery routing, trade area mapping, and proximity-based customer targeting.',
    `lifecycle_status` STRING COMMENT 'Current operational status of the store location in its lifecycle. Planned = approved but not yet built; Under Construction = site work in progress; Open = actively trading; Temporarily Closed = closed for short-term reasons (weather, emergency); Permanently Closed = ceased operations; Remodeling = closed for renovation.. Valid values are `planned|under_construction|open|temporarily_closed|permanently_closed|remodeling`',
    `locale` STRING COMMENT 'Locale identifier for the store location in format language_COUNTRY (e.g., en_US, es_MX, fr_CA). Used for localized pricing, signage, customer communications, and regulatory compliance.. Valid values are `^[a-z]{2}_[A-Z]{2}$`',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the store location in decimal degrees. Used for geospatial analysis, delivery routing, trade area mapping, and proximity-based customer targeting.',
    `manager_name` STRING COMMENT 'Full name of the current store manager responsible for this location. Used for operational accountability, escalation routing, and organizational reporting. Business reference, not direct PII.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this store location record was last modified. Used for data lineage, change tracking, and audit trails. Updated on every record change.',
    `number_of_floors` STRING COMMENT 'Total number of customer-accessible floors in the store location. Used for store layout planning, accessibility compliance, and customer flow analysis.',
    `opening_date` DATE COMMENT 'The date this store location first opened for business. Used for comp sales (SSS - Same-Store Sales) calculations, anniversary planning, and store maturity analysis. Null for planned stores not yet opened.',
    `operating_hours` STRING COMMENT 'Standard operating hours for the store location, typically in format Mon-Fri 8:00-22:00, Sat-Sun 9:00-21:00. Used for workforce scheduling, customer communications, and omnichannel order fulfillment time windows.',
    `parking_capacity` STRING COMMENT 'Total number of customer parking spaces available at the store location. Used for site selection, customer convenience analysis, and BOPIS/ROPIS pickup planning. Null for urban locations without dedicated parking.',
    `phone_number` STRING COMMENT 'Primary contact phone number for the store location. Used for customer inquiries, BOPIS/ROPIS coordination, and operational communications. Organizational contact data classified as confidential.',
    `postal_code` STRING COMMENT 'Postal code or ZIP code for the store location. Used for delivery routing, trade area analysis, and demographic segmentation. Organizational contact data classified as confidential.',
    `region_code` STRING COMMENT 'Code identifying the retail region to which this store location belongs. Used for hierarchical reporting, regional strategy, and executive-level performance analysis.',
    `ropis_capable` BOOLEAN COMMENT 'Indicates whether this store location supports ROPIS (Reserve Online Pick Up In Store) fulfillment, where customers reserve items online and complete purchase in-store. True = ROPIS enabled; False = ROPIS not available.',
    `selling_square_footage` DECIMAL(18,2) COMMENT 'Square footage of customer-accessible selling floor space, excluding back-of-house, storage, and office areas. Used for sales per square foot calculations, planogram (POG) planning, and merchandising density analysis.',
    `sfs_capable` BOOLEAN COMMENT 'Indicates whether this store location is enabled as a Ship-from-Store (SFS) fulfillment node, capable of picking, packing, and shipping e-commerce orders directly from store inventory. True = SFS enabled; False = SFS not available.',
    `staffing_model_type` STRING COMMENT 'The staffing model classification for this store format. Full Service = high staff-to-customer ratio with clienteling; Limited Service = moderate staffing; Self Service = minimal staff, customer self-checkout; Automated = dark store or MFC with no customer-facing staff.. Valid values are `full_service|limited_service|self_service|automated`',
    `state_province` STRING COMMENT 'State or province code (2-letter ISO or postal abbreviation) where the store location is situated. Used for tax jurisdiction determination, regulatory compliance, and regional reporting.. Valid values are `^[A-Z]{2}$`',
    `store_name` STRING COMMENT 'The trading name or display name of the store location as it appears to customers (e.g., Retail Superstore Downtown, Retail Express Market Hill). Used for customer communications, receipts, and marketing materials.',
    `store_number` STRING COMMENT 'Externally-known business identifier for the store location. This is the human-readable store number used in operational communications, signage, and customer-facing materials. Unique within the retail banner/brand.. Valid values are `^[A-Z0-9]{4,12}$`',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the store location (e.g., America/New_York, America/Chicago). Used for POS transaction timestamping, workforce scheduling, and omnichannel order fulfillment coordination.. Valid values are `^[A-Z]{3,5}$`',
    `total_square_footage` DECIMAL(18,2) COMMENT 'Total building square footage of the store location, including selling floor, back-of-house, storage, and office space. Used for productivity metrics (sales per square foot), lease accounting, and facility management.',
    CONSTRAINT pk_location PRIMARY KEY(`location_id`)
) COMMENT 'Master record for every physical retail location operated by the business, including hypermarkets, department stores, discount outlets, dark stores, and micro-fulfillment centers (MFCs). Captures store number, banner/brand, format type (hypermarket, department, discount, dark store, MFC), format size band, assortment depth/breadth norms, staffing model type, fulfillment capability flags (BOPIS-capable, ROPIS-capable, SFS-capable, DSD-receiving), trading name, legal entity, opening date, closure date, remodel history, square footage (total and selling), number of floors, parking capacity, operating hours, time zone, locale, climate zone, accessibility certifications, and store lifecycle status. This is the SSOT for all store identity, classification, and format configuration data consumed by inventory, order, workforce, and finance domains.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`format` (
    `format_id` BIGINT COMMENT 'Unique identifier for the store format. Primary key.',
    `parent_format_id` BIGINT COMMENT 'add column parent_format_id (BIGINT) with FK to store.format.format_id - store formats may have hierarchical relationships (e.g., hypermarket subtypes) needed for rollup reporting',
    `assortment_breadth_level` STRING COMMENT 'Typical range of product categories carried by this format. Narrow = few categories (e.g., convenience); broad = many categories (e.g., hypermarket).. Valid values are `narrow|moderate|broad|very_broad`',
    `assortment_depth_level` STRING COMMENT 'Typical variety within each product category for this format. Shallow = limited SKU (Stock Keeping Unit) variety per category; deep = extensive SKU variety per category.. Valid values are `shallow|moderate|deep|very_deep`',
    `bopis_capable_flag` BOOLEAN COMMENT 'Indicates whether stores of this format are capable of supporting BOPIS (Buy Online Pick Up In Store) fulfillment. True if BOPIS is supported; false otherwise.',
    `clienteling_service_flag` BOOLEAN COMMENT 'Indicates whether stores of this format offer clienteling (personalized in-store service) to customers. True if clienteling is offered; false otherwise.',
    `format_code` STRING COMMENT 'Short alphanumeric code representing the store format (e.g., HM for hypermarket, SS for superstore, DS for discount store, CONV for convenience, DARK for dark store, MFC for micro-fulfillment center).. Valid values are `^[A-Z0-9]{2,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this store format record was first created in the system.',
    `format_description` STRING COMMENT 'Detailed description of the store format including its purpose, target customer segment, and operational characteristics.',
    `dsd_receiving_flag` BOOLEAN COMMENT 'Indicates whether stores of this format receive DSD (Direct Store Delivery) shipments directly from vendors, bypassing the DC (Distribution Center). True if DSD receiving is supported; false otherwise.',
    `effective_end_date` DATE COMMENT 'Date when this store format definition was retired or deprecated. Null for currently active formats.',
    `effective_start_date` DATE COMMENT 'Date when this store format definition became effective and available for use in store planning and operations.',
    `endcap_count_typical` STRING COMMENT 'Typical number of endcaps (end-of-aisle displays) available for promotional merchandising in stores of this format.',
    `format_status` STRING COMMENT 'Current lifecycle status of the store format. Active formats are in use across the banner portfolio; deprecated formats are being phased out; pilot formats are under testing.. Valid values are `active|inactive|deprecated|pilot`',
    `format_type` STRING COMMENT 'High-level classification of the format: physical_retail (customer-facing), fulfillment_only (dark store, MFC), or hybrid (ship-from-store capable retail location).. Valid values are `physical_retail|fulfillment_only|hybrid`',
    `gondola_configuration_type` STRING COMMENT 'Typical gondola (shelving unit) configuration used in stores of this format. Defines the standard shelving layout and fixture type.. Valid values are `standard|high_density|low_profile|modular|custom`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this store format record was last updated in the system.',
    `loyalty_program_participation_flag` BOOLEAN COMMENT 'Indicates whether stores of this format participate in the enterprise loyalty program. True if loyalty program is active; false otherwise.',
    `format_name` STRING COMMENT 'Full descriptive name of the store format (e.g., Hypermarket, Superstore, Department Store, Discount Outlet, Convenience Store, Dark Store, Micro-Fulfillment Center, Ship-from-Store Node).',
    `operating_hours_type` STRING COMMENT 'Typical operating hours pattern for stores of this format. 24_7 = open 24 hours; extended = long hours (e.g., 6am-midnight); standard = typical retail hours; limited = short hours; variable = hours vary by location.. Valid values are `24_7|extended|standard|limited|variable`',
    `parking_capacity_typical` STRING COMMENT 'Typical number of parking spaces available at stores of this format. Null for formats without customer parking (e.g., dark stores, MFCs).',
    `planogram_template_code` STRING COMMENT 'Code identifying the standard planogram (POG - Shelf Layout Diagram) template used for visual merchandising in stores of this format. Links to master planogram library.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `pos_terminal_count_max` STRING COMMENT 'Maximum number of POS (Point of Sale) terminals typically deployed in stores of this format. Defines the upper bound of checkout capacity.',
    `pos_terminal_count_min` STRING COMMENT 'Minimum number of POS (Point of Sale) terminals typically deployed in stores of this format. Defines the lower bound of checkout capacity.',
    `pricing_strategy_type` STRING COMMENT 'Typical pricing strategy employed by stores of this format. EDLP (Everyday Low Price) = consistent low prices; Hi-Lo (High-Low Pricing Strategy) = regular prices with frequent promotions; premium = higher prices with quality focus; discount = below-market pricing; dynamic = algorithmic pricing.. Valid values are `edlp|hi_lo|premium|discount|dynamic`',
    `rfid_enabled_flag` BOOLEAN COMMENT 'Indicates whether stores of this format use RFID (Radio Frequency Identification) technology for inventory tracking and shrinkage prevention. True if RFID is deployed; false otherwise.',
    `ropis_capable_flag` BOOLEAN COMMENT 'Indicates whether stores of this format are capable of supporting ROPIS (Reserve Online Pick Up In Store) fulfillment. True if ROPIS is supported; false otherwise.',
    `sfs_capable_flag` BOOLEAN COMMENT 'Indicates whether stores of this format are capable of serving as SFS (Ship-from-Store) fulfillment nodes for e-commerce orders. True if SFS is supported; false otherwise.',
    `size_band_max_sqft` DECIMAL(18,2) COMMENT 'Maximum store size in square feet for this format. Defines the upper bound of the typical size range.',
    `size_band_min_sqft` DECIMAL(18,2) COMMENT 'Minimum store size in square feet for this format. Defines the lower bound of the typical size range.',
    `staffing_model_type` STRING COMMENT 'Typical staffing and service model for this format. Full service = high staff-to-customer ratio with personalized assistance; self-service = minimal staff, customer-driven; automated = robotic/automated fulfillment.. Valid values are `full_service|limited_service|self_service|automated|hybrid`',
    `target_demographic` STRING COMMENT 'Primary customer demographic segment targeted by this store format (e.g., value-conscious families, urban professionals, convenience shoppers, bulk buyers).',
    `typical_sku_count_max` STRING COMMENT 'Maximum number of SKUs (Stock Keeping Units) typically carried by stores of this format. Defines the upper bound of product assortment size.',
    `typical_sku_count_min` STRING COMMENT 'Minimum number of SKUs (Stock Keeping Units) typically carried by stores of this format. Defines the lower bound of product assortment size.',
    `wms_integration_required_flag` BOOLEAN COMMENT 'Indicates whether stores of this format require integration with WMS (Warehouse Management System) for inventory management. True for fulfillment-heavy formats (dark stores, MFCs, SFS nodes); false for traditional retail-only formats.',
    CONSTRAINT pk_format PRIMARY KEY(`format_id`)
) COMMENT 'Reference classification of retail store formats used across the banner portfolio. Defines format codes and descriptions (hypermarket, superstore, department store, discount outlet, convenience, dark store, MFC, ship-from-store node), typical size bands (sq ft ranges), assortment depth/breadth norms, staffing model type, and fulfillment capability flags (BOPIS-capable, ROPIS-capable, SFS-capable, DSD-receiving). Used to drive operational standards, planogram templates, and omnichannel routing rules.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`pos_terminal` (
    `pos_terminal_id` BIGINT COMMENT 'Unique identifier for the POS terminal. Primary key. Inferred role: MASTER_RESOURCE.',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.store_department. Business justification: POS terminals are assigned to specific departments within a store (e.g., electronics department checkout, grocery department checkout). The pos_terminal record currently denormalizes department_code a',
    `location_id` BIGINT COMMENT 'Foreign key reference to the store location where this POS terminal is deployed.',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor. Business justification: POS terminals are capital equipment procured from hardware vendors. Tracking the vendor supports warranty claims, maintenance contract management, service call routing, and replacement parts procureme',
    `barcode_scanner_type` STRING COMMENT 'Type of barcode scanner peripheral attached to the POS terminal. Determines scanning workflow and throughput capabilities.. Valid values are `handheld|fixed_mount|presentation|none`',
    `cash_drawer_enabled` BOOLEAN COMMENT 'Indicates whether the terminal is connected to a cash drawer for handling cash transactions. False for self-checkout kiosks and mobile POS devices that do not accept cash.',
    `contactless_enabled` BOOLEAN COMMENT 'Indicates whether the terminal supports Near Field Communication (NFC) contactless payments (tap-to-pay, mobile wallets like Apple Pay, Google Pay).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this POS terminal record was first created in the master data system. Used for audit trail and data lineage tracking.',
    `customer_display_type` STRING COMMENT 'Type of customer-facing display device attached to the terminal. Shows transaction details, pricing, and promotional messages to the customer during checkout.. Valid values are `pole_display|integrated_screen|tablet|none`',
    `ebt_snap_enabled` BOOLEAN COMMENT 'Indicates whether the terminal is certified to accept Electronic Benefits Transfer (EBT) and Supplemental Nutrition Assistance Program (SNAP) payments. Required for grocery retailers serving SNAP recipients.',
    `emv_chip_enabled` BOOLEAN COMMENT 'Indicates whether the terminal supports EMV chip card transactions (contact chip reading). Required for PCI DSS compliance and fraud reduction.',
    `encryption_enabled` BOOLEAN COMMENT 'Indicates whether the terminal encrypts payment card data at the point of interaction (P2PE - Point-to-Point Encryption). Required for PCI DSS compliance and fraud prevention.',
    `hardware_model` STRING COMMENT 'Manufacturer model number or identifier for the POS terminal hardware (e.g., NCR RealPOS 82XRT, Toshiba TCx Sky, Zebra TC52). Critical for maintenance planning and compatibility management.',
    `hardware_serial_number` STRING COMMENT 'Manufacturer-assigned unique serial number for the physical POS terminal device. Used for warranty tracking, asset management, and theft prevention.. Valid values are `^[A-Z0-9-]{8,30}$`',
    `installation_date` DATE COMMENT 'Date when the POS terminal was first installed and commissioned at the store location. Used for asset lifecycle tracking and depreciation calculations.',
    `ip_address` STRING COMMENT 'Internet Protocol (IP) address assigned to the POS terminal on the store network. Used for network troubleshooting, security monitoring, and remote management.. Valid values are `^(?:[0-9]{1,3}.){3}[0-9]{1,3}$`',
    `lane_number` STRING COMMENT 'Physical lane or checkout position number within the store layout. Used for customer wayfinding and operational reporting. Null for mobile POS devices.',
    `last_maintenance_date` DATE COMMENT 'Date of the most recent preventive maintenance or repair service performed on the terminal. Used for maintenance schedule compliance tracking.',
    `last_transaction_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent transaction processed by this terminal. Used for terminal utilization analysis and anomaly detection (e.g., identifying inactive terminals).',
    `mac_address` STRING COMMENT 'Media Access Control (MAC) address of the POS terminal network interface. Unique hardware identifier used for network access control and device authentication.. Valid values are `^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$`',
    `mobile_wallet_enabled` BOOLEAN COMMENT 'Indicates whether the terminal supports mobile wallet payment methods (Apple Pay, Google Pay, Samsung Pay, etc.). Typically requires NFC hardware.',
    `network_zone` STRING COMMENT 'Network security zone or segment where the POS terminal is deployed. Cardholder Data Environment (CDE) terminals are subject to stricter PCI DSS controls.. Valid values are `cardholder_data_environment|corporate_network|guest_network|isolated`',
    `next_scheduled_maintenance_date` DATE COMMENT 'Date when the next preventive maintenance service is scheduled for the terminal. Used for proactive maintenance planning and resource allocation.',
    `operating_system` STRING COMMENT 'Operating system running on the POS terminal (e.g., Windows 10 IoT, Android 11, Linux Ubuntu 20.04). Impacts security posture and application compatibility.',
    `payment_processor` STRING COMMENT 'Name of the payment processing service or gateway integrated with this terminal (e.g., First Data, Worldpay, Square). Determines payment acceptance capabilities and settlement routing.',
    `pci_dss_certification_date` DATE COMMENT 'Date when the terminal last passed Payment Card Industry Data Security Standard (PCI DSS) compliance certification. Must be renewed annually to maintain payment acceptance capabilities.',
    `pci_dss_certification_expiry_date` DATE COMMENT 'Date when the current PCI DSS certification expires. Terminals must be recertified before this date to continue processing payment card transactions.',
    `pin_debit_enabled` BOOLEAN COMMENT 'Indicates whether the terminal supports PIN-based debit card transactions. Requires secure PIN pad hardware.',
    `qr_code_payment_enabled` BOOLEAN COMMENT 'Indicates whether the terminal supports QR code-based payment methods (e.g., Alipay, WeChat Pay, retailer-specific QR payment apps).',
    `receipt_printer_model` STRING COMMENT 'Model identifier for the receipt printer peripheral attached to the POS terminal. Used for consumables ordering and maintenance scheduling.',
    `remote_management_enabled` BOOLEAN COMMENT 'Indicates whether the terminal can be remotely monitored, configured, and updated from a central management system. Enables efficient fleet management and rapid issue resolution.',
    `scale_integrated` BOOLEAN COMMENT 'Indicates whether the terminal has an integrated scale for weighing produce, bulk items, or other variable-weight merchandise. Common in grocery checkout lanes.',
    `signature_capture_enabled` BOOLEAN COMMENT 'Indicates whether the terminal supports electronic signature capture for credit card transactions and delivery confirmations.',
    `software_version` STRING COMMENT 'Version number of the POS application software currently installed on the terminal. Critical for security patch management and feature compatibility.. Valid values are `^[0-9]+.[0-9]+.[0-9]+(.[0-9]+)?$`',
    `terminal_name` STRING COMMENT 'Human-readable name or label for the POS terminal, often indicating its location or purpose within the store (e.g., Lane 5, Customer Service Desk, Pharmacy Register).',
    `terminal_number` STRING COMMENT 'Business identifier for the POS terminal, typically displayed on the terminal and used in operational communications. Unique within a store location.. Valid values are `^[A-Z0-9]{4,20}$`',
    `terminal_status` STRING COMMENT 'Current operational status of the POS terminal. Determines whether the terminal is available for transaction processing. Active terminals are in production use; offline terminals are temporarily unavailable; maintenance terminals are undergoing service; decommissioned terminals are permanently retired.. Valid values are `active|offline|maintenance|decommissioned|pending_activation|suspended`',
    `terminal_type` STRING COMMENT 'Classification of the POS terminal based on its operational function and staffing model. Determines transaction workflows and customer interaction patterns.. Valid values are `staffed_checkout_lane|self_checkout_kiosk|mobile_pos|customer_service_desk|pharmacy_register|express_lane`',
    `tokenization_enabled` BOOLEAN COMMENT 'Indicates whether the terminal supports payment tokenization, replacing sensitive card data with non-sensitive tokens for storage and transmission. Reduces PCI DSS scope.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this POS terminal record was last modified in the master data system. Used for change tracking and data synchronization.',
    CONSTRAINT pk_pos_terminal PRIMARY KEY(`pos_terminal_id`)
) COMMENT 'Master record for every Point-of-Sale (POS) terminal deployed within a store location. Captures terminal ID, lane number, terminal type (staffed checkout lane, self-checkout kiosk, mobile POS, customer service desk, pharmacy register), hardware model, software version, payment acceptance capabilities (EMV chip, NFC/contactless, PIN debit, EBT/SNAP, mobile wallet), peripheral devices (scanner, scale, receipt printer), installation date, last maintenance date, next scheduled maintenance, terminal status (active, offline, maintenance, decommissioned), PCI DSS compliance certification date, and assigned department or zone within the store. Critical for POS transaction reconciliation, shrinkage investigation, lane productivity analysis, and omnichannel payment compliance.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`traffic_count` (
    `traffic_count_id` BIGINT COMMENT 'Primary key for traffic_count',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.department. Business justification: Traffic count sensors are deployed at store entrances AND internal department zones (counting_zone_code, counting_zone_name, zone_type columns exist on traffic_count). When a traffic count record repr',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Footfall measurement during promotional periods quantifies campaign-driven traffic—retailers tag traffic counts to campaigns for incremental traffic attribution. Store operations and marketing analyti',
    `location_id` BIGINT COMMENT 'Identifier of the retail location where the traffic count was measured. Links to the store master record.',
    `accuracy_confidence_percent` DECIMAL(18,2) COMMENT 'Estimated accuracy confidence level of the measurement as a percentage (e.g., 95.5 indicates 95.5% confidence). Provided by advanced sensor systems with built-in quality scoring.',
    `average_dwell_time_minutes` DECIMAL(18,2) COMMENT 'Average time in minutes that customers spent in the counting zone during the measurement interval. Calculated from inbound/outbound timing data. Indicates customer engagement and shopping behavior.',
    `calibration_date` DATE COMMENT 'Date when the sensor device was last calibrated or validated for accuracy. Sensors require periodic calibration to maintain measurement precision; this attribute supports data quality auditing.',
    `conversion_rate_percent` DECIMAL(18,2) COMMENT 'Percentage of footfall that resulted in a transaction during the measurement interval. Calculated by dividing POS transaction count by inbound count. Key KPI for store performance and merchandising effectiveness.',
    `counting_zone_code` STRING COMMENT 'Code identifying the specific zone or area within the store where traffic was measured (e.g., MAIN_ENTRANCE, DEPT_ELECTRONICS, CHECKOUT_AREA, ENDCAP_A1). Enables zone-level footfall analysis.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `counting_zone_name` STRING COMMENT 'Human-readable name of the counting zone (e.g., Main Entrance, Electronics Department, Checkout Area 1). Provides business-friendly identification of the measurement location.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this traffic count record was first created in the data platform. Used for data lineage and audit trail purposes.',
    `data_quality_flag` BOOLEAN COMMENT 'Indicator of the reliability and completeness of the traffic count measurement. Used to filter or adjust analytics based on data quality issues.',
    `data_source_system` STRING COMMENT 'Name of the source system or vendor platform that provided the traffic count data (e.g., RetailNext, ShopperTrak, Axis Camera Analytics). Used for data lineage and vendor performance tracking.',
    `day_of_week` STRING COMMENT 'Day of the week when the measurement was taken. Footfall patterns vary significantly by day of week; this attribute supports day-of-week trend analysis and staffing optimization. [ENUM-REF-CANDIDATE: monday|tuesday|wednesday|thursday|friday|saturday|sunday — 7 candidates stripped; promote to reference product]',
    `hour_of_day` STRING COMMENT 'Hour of the day (0-23) when the measurement was taken. Enables intraday footfall pattern analysis and peak-hour identification for workforce scheduling.',
    `inbound_count` STRING COMMENT 'Number of customers or individuals entering the counting zone during the measurement interval. Core footfall metric for traffic volume analysis.',
    `is_holiday` BOOLEAN COMMENT 'Flag indicating whether the measurement occurred on a recognized retail holiday or peak shopping day (e.g., Black Friday, Cyber Monday, Christmas Eve). Holidays significantly impact footfall patterns.',
    `is_promotional_event` BOOLEAN COMMENT 'Flag indicating whether a store-level promotional event or special sale was active during the measurement period. Used to isolate promotional lift in footfall analysis.',
    `is_store_open` BOOLEAN COMMENT 'Flag indicating whether the store was open for business during the measurement interval. Distinguishes operational footfall from after-hours activity (e.g., restocking, maintenance).',
    `measurement_interval_minutes` STRING COMMENT 'Duration of the measurement interval in minutes (e.g., 15, 60, 1440 for daily). Defines the time window over which traffic counts were aggregated.',
    `measurement_timestamp` TIMESTAMP COMMENT 'The precise date and time when the traffic count measurement was captured by the sensor system. Represents the business event time of the footfall observation.',
    `net_occupancy_estimate` STRING COMMENT 'Estimated number of customers present in the zone at the end of the measurement interval, calculated as cumulative inbound minus outbound. Used for real-time capacity management and safety compliance.',
    `notes` STRING COMMENT 'Free-text field for operational notes or anomalies related to the measurement (e.g., sensor malfunction, store event, construction activity). Provides context for data quality issues or unusual patterns.',
    `outbound_count` STRING COMMENT 'Number of customers or individuals exiting the counting zone during the measurement interval. Used to calculate net occupancy and dwell time.',
    `peak_occupancy` STRING COMMENT 'Maximum number of customers simultaneously present in the zone during the measurement interval. Used for capacity planning, safety compliance, and staffing optimization.',
    `sensor_device_code` STRING COMMENT 'Unique identifier of the people-counting sensor or camera system that captured the measurement. Used for device performance tracking and data quality auditing.. Valid values are `^[A-Z0-9-]{8,30}$`',
    `sensor_type` STRING COMMENT 'Technology type of the counting sensor (e.g., thermal imaging, video analytics with AI, infrared beam, RFID, WiFi tracking, Bluetooth beacon). Impacts measurement accuracy and privacy considerations.. Valid values are `thermal|video_analytics|infrared|rfid|wifi_tracking|bluetooth_beacon`',
    `temperature_fahrenheit` DECIMAL(18,2) COMMENT 'Outdoor temperature in degrees Fahrenheit at the time of measurement. Used for weather-adjusted footfall modeling and seasonal trend analysis.',
    `transaction_count` STRING COMMENT 'Number of POS transactions completed during the measurement interval in the counting zone. Used to calculate conversion rate and sales per visitor metrics.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this traffic count record was last modified in the data platform. Supports change tracking and data quality auditing.',
    `weather_condition_code` STRING COMMENT 'Weather condition at the time of measurement. Footfall is highly correlated with weather; this attribute enables weather-adjusted traffic forecasting and comp sales analysis. [ENUM-REF-CANDIDATE: clear|rain|snow|fog|storm|extreme_heat|extreme_cold — 7 candidates stripped; promote to reference product]',
    `zone_type` STRING COMMENT 'Classification of the counting zone by functional area type. Used to segment footfall analysis by store area category.. Valid values are `entrance|department|checkout|aisle|endcap|gondola`',
    CONSTRAINT pk_traffic_count PRIMARY KEY(`traffic_count_id`)
) COMMENT 'Time-series record of customer traffic counts (footfall) measured at store entrances and internal zones, captured by people-counting sensors or RFID/camera systems. Records store location, counting zone (main entrance, department zone, checkout area), measurement interval (15-min, hourly, daily), inbound count, outbound count, net occupancy estimate, sensor device ID, data quality flag, and weather condition code at time of measurement. Footfall is a primary store operations KPI used for staffing optimization, conversion rate analysis, and trade area benchmarking.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`shrinkage_event` (
    `shrinkage_event_id` BIGINT COMMENT 'Unique identifier for the shrinkage event record. Primary key.',
    `adjustment_id` BIGINT COMMENT 'Identifier of the inventory adjustment transaction in the WMS or ERP system that recorded the shrinkage loss. Links to the inventory adjustment ledger.',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.store_department. Business justification: Shrinkage events (theft, damage, spoilage) occur in specific departments within a store. The shrinkage_event record currently denormalizes department_code as a STRING. Adding FK to store_department al',
    `inbound_shipment_id` BIGINT COMMENT 'Foreign key linking to supplychain.inbound_shipment. Business justification: Loss prevention investigations require tracing shrinkage events back to the originating inbound shipment to identify vendor fraud, transit damage, or receiving discrepancies. The Shrinkage Root Cause ',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Promotional periods see elevated shrinkage due to high traffic, promotional displays, and temporary merchandising—loss prevention teams track shrinkage by campaign. AP and operations teams analyze cam',
    `replenishment_plan_id` BIGINT COMMENT 'Foreign key linking to supplychain.replenishment_plan. Business justification: High-value promotional items tracked for shrinkage during campaign periods. Loss prevention analyzes shrinkage patterns by campaign to identify theft risks associated with promotional displays and hig',
    `rma_id` BIGINT COMMENT 'Foreign key linking to returns.rma. Business justification: Shrinkage events frequently originate from fraudulent returns (empty box returns, receipt fraud, wardrobing, return of stolen merchandise). LP teams link shrinkage events to specific RMAs for loss att',
    `location_id` BIGINT COMMENT 'Identifier of the retail location where the shrinkage event occurred. Links to the store master record.',
    `vendor_id` BIGINT COMMENT 'Identifier of the vendor or supplier involved in the shrinkage event (for vendor fraud or DSD - Direct Store Delivery discrepancies).',
    `case_reference_number` STRING COMMENT 'Reference number for the associated Loss Prevention investigation case, if one was opened. May link to external case management systems.',
    `cost_value_lost` DECIMAL(18,2) COMMENT 'The total cost value (COGS - Cost of Goods Sold) of inventory lost in this shrinkage event. Used for financial accounting and inventory valuation adjustments.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this shrinkage event record was first created in the system. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this record (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `detection_method` STRING COMMENT 'The method or process by which the shrinkage event was identified: POS (Point of Sale) exception report, cycle count, physical inventory, RFID (Radio Frequency Identification) scan, LP (Loss Prevention) investigation, or vendor audit.. Valid values are `pos_exception|cycle_count|physical_inventory|rfid_scan|lp_investigation|vendor_audit`',
    `event_date` DATE COMMENT 'The date on which the shrinkage event was identified or occurred. Format: yyyy-MM-dd.',
    `event_number` STRING COMMENT 'Business-facing unique reference number for the shrinkage event, used for tracking and case management (e.g., SHR-0000012345).. Valid values are `^SHR-[0-9]{10}$`',
    `event_timestamp` TIMESTAMP COMMENT 'Precise date and time when the shrinkage event was detected or recorded. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `fiscal_period` STRING COMMENT 'The fiscal period (quarter or month) in which the shrinkage event occurred, used for financial reporting and P&L impact analysis (e.g., 2024-Q2 or 2024-06).. Valid values are `^[0-9]{4}-Q[1-4]$|^[0-9]{4}-[0-9]{2}$`',
    `incident_report_filed` BOOLEAN COMMENT 'Indicates whether a formal incident report was filed with Loss Prevention or law enforcement for this shrinkage event.',
    `inventory_adjustment_posted` BOOLEAN COMMENT 'Indicates whether the inventory adjustment for this shrinkage event has been posted to the inventory ledger and financial systems (WMS - Warehouse Management System and ERP).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this shrinkage event record was last updated. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `notes` STRING COMMENT 'Free-text notes providing additional context, investigation findings, or details about the shrinkage event. May include Loss Prevention officer observations or follow-up actions.',
    `police_report_number` STRING COMMENT 'Law enforcement report number if the shrinkage event involved external theft and was reported to police.',
    `product_description` STRING COMMENT 'Human-readable description of the product(s) involved in the shrinkage event.',
    `quantity_lost` DECIMAL(18,2) COMMENT 'The quantity of units lost in the shrinkage event. May include fractional units for weight-based or bulk items.',
    `recovery_amount` DECIMAL(18,2) COMMENT 'The monetary value recovered from the shrinkage event through restitution, insurance claims, vendor credits, or merchandise recovery. Null or zero if no recovery occurred.',
    `recovery_method` STRING COMMENT 'The method by which value was recovered: merchandise physically recovered, restitution from perpetrator, insurance claim payout, vendor credit (RTV - Return to Vendor), chargeback to vendor, or none.. Valid values are `merchandise_recovered|restitution|insurance_claim|vendor_credit|chargeback|none`',
    `resolution_date` DATE COMMENT 'The date on which the shrinkage event case was resolved or closed. Null if still open or under investigation.',
    `resolution_status` STRING COMMENT 'Current status of the shrinkage event case: open (newly identified), under investigation, resolved (cause identified and addressed), closed unresolved, or recovered (merchandise or value recovered).. Valid values are `open|under_investigation|resolved|closed_unresolved|recovered`',
    `responsible_party_type` STRING COMMENT 'Classification of the party responsible for the shrinkage: external (customer/shoplifter), employee (internal theft), vendor (fraud/error), unknown, or not applicable (e.g., damage, administrative error).. Valid values are `external|employee|vendor|unknown|not_applicable`',
    `shrinkage_type` STRING COMMENT 'Classification of the root cause of the shrinkage event: external theft (shoplifting), internal theft (employee), administrative error (paperwork/system), vendor fraud, damage (spoilage/breakage), or unknown.. Valid values are `external_theft|internal_theft|administrative_error|vendor_fraud|damage|unknown`',
    `sku` STRING COMMENT 'The Stock Keeping Unit identifier of the primary product involved in the shrinkage event. For multi-SKU events, this represents the primary or highest-value item.. Valid values are `^[A-Z0-9]{6,20}$`',
    `total_retail_value_lost` DECIMAL(18,2) COMMENT 'The total estimated retail value of inventory lost in this shrinkage event (quantity_lost × unit_retail_value). Directly impacts store P&L (Profit and Loss).',
    `unit_of_measure` STRING COMMENT 'The unit of measure for the quantity lost (e.g., each, case, pound, kilogram, liter, gallon).. Valid values are `each|case|pound|kilogram|liter|gallon`',
    `unit_retail_value` DECIMAL(18,2) COMMENT 'The retail price per unit of the product at the time of the shrinkage event. Used to calculate total estimated loss.',
    `upc` STRING COMMENT 'The 12-digit Universal Product Code (UPC) barcode of the product involved in the shrinkage event.. Valid values are `^[0-9]{12}$`',
    `zone_location` STRING COMMENT 'Specific zone, aisle, or area within the store where the shrinkage event was detected (e.g., Aisle 12, Backroom, Checkout Lane 5).',
    CONSTRAINT pk_shrinkage_event PRIMARY KEY(`shrinkage_event_id`)
) COMMENT 'Operational record of an identified inventory shrinkage event at a store location. Captures event date, store location, department/zone, shrinkage type (shoplifting/external theft, internal theft, administrative error, vendor fraud, damage), SKU(s) involved, quantity lost, estimated retail value lost, detection method (POS exception, cycle count, RFID, LP investigation), case reference number, resolution status, and recovery amount. Shrinkage is a critical retail KPI directly impacting store P&L and inventory accuracy. Supports LP (Loss Prevention) operations and CPSC/FTC compliance reporting.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`department` (
    `department_id` BIGINT COMMENT 'Unique identifier for the store department. Primary key for the store department entity.',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Department managers execute category-level merchandising strategies. Real business process: departments track category performance targets, space allocation, assortment compliance, and GMROI against c',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Store departments map to merchandise categories (item hierarchy). Department managers are responsible for specific categories. Essential for departmental P&L reporting by category and category manager',
    `location_id` BIGINT COMMENT 'Reference to the parent store location where this department is physically located.',
    `price_zone_id` BIGINT COMMENT 'Foreign key linking to pricing.price_zone. Business justification: Departments (e.g., pharmacy, electronics, grocery) can operate in differentiated price zones within the same store. Department-level price zone assignment drives pricing rule application, markdown eli',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor. Business justification: Retail departments (bakery, deli, produce, electronics) have designated primary vendors for DSD receiving, planogram compliance, and category management. Department-level vendor assignment drives repl',
    `return_policy_id` BIGINT COMMENT 'Foreign key linking to returns.return_policy. Business justification: Retail departments enforce department-specific return policies (electronics: 15-day window; apparel: 30-day). Department managers and POS systems reference the departments return policy to validate r',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the department record was first created in the system. Used for audit trail and data lineage.',
    `department_status` STRING COMMENT 'Current operational status of the department. Active departments are open for business; inactive departments are closed or not yet operational.. Valid values are `active|inactive|under_construction|seasonal_closed|remodeling|pending_closure`',
    `department_type` STRING COMMENT 'Classification of the department by merchandise category. Determines merchandising strategy, planogram standards, and operational procedures. [ENUM-REF-CANDIDATE: grocery|apparel|electronics|household|pharmacy|bakery|deli|produce|frozen|health_beauty|seasonal|home_garden|automotive|sporting_goods|toys|jewelry|furniture — 17 candidates stripped; promote to reference product]',
    `effective_end_date` DATE COMMENT 'Date when the department ceased operations or when the current configuration ended. Null for currently active departments.',
    `effective_start_date` DATE COMMENT 'Date when the department became operational or when the current configuration became effective. Used for historical tracking and comp sales analysis.',
    `endcap_count` STRING COMMENT 'Number of endcap display positions (end-of-aisle promotional displays) available in the department. Prime real estate for high-margin or promotional items.',
    `fixture_count` STRING COMMENT 'Total number of fixtures (gondolas, endcaps, shelving units, display cases) assigned to the department. Used for planogram capacity planning.',
    `floor_number` STRING COMMENT 'Floor level where the department is located within the store. Ground floor is typically 1, basement levels may be 0 or negative.',
    `gondola_count` STRING COMMENT 'Number of gondola shelving units (freestanding double-sided shelving) in the department. Key metric for planogram assignment and merchandising capacity.',
    `gross_margin_target_percent` DECIMAL(18,2) COMMENT 'Target gross margin percentage for the department. Used to measure profitability and pricing effectiveness.',
    `labor_budget_monthly` DECIMAL(18,2) COMMENT 'Monthly labor budget allocation for the department in local currency. Used for workforce scheduling and labor-to-sales ratio management.',
    `last_modified_by` STRING COMMENT 'User ID or system identifier of the person or process that last modified the department record. Used for audit trail and accountability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the department record was last updated. Used for audit trail and change tracking.',
    `license_expiry_date` DATE COMMENT 'Expiration date of the regulatory license or permit for licensed departments. Null for non-licensed departments.',
    `license_number` STRING COMMENT 'Regulatory license or permit number for licensed departments (e.g., pharmacy license, alcohol retail license). Null for non-licensed departments.',
    `licensed_department_flag` BOOLEAN COMMENT 'Indicates whether the department requires special licensing or regulatory compliance (e.g., pharmacy, alcohol, tobacco, firearms). True if licensing is required.',
    `notes` STRING COMMENT 'Free-form text field for additional notes, comments, or special instructions related to the department. Used for operational context and exception handling.',
    `omnichannel_fulfillment_enabled_flag` BOOLEAN COMMENT 'Indicates whether the department supports omnichannel fulfillment operations (BOPIS, ROPIS, ship-from-store). True if omnichannel fulfillment is enabled.',
    `planogram_count` STRING COMMENT 'Number of active planograms (shelf layout diagrams) assigned to the department. Each planogram defines product placement and facings for a fixture or section.',
    `pos_terminal_count` STRING COMMENT 'Number of POS terminals or checkout lanes assigned to or located within the department. Relevant for departments with dedicated checkout (e.g., pharmacy, jewelry).',
    `sales_target_monthly` DECIMAL(18,2) COMMENT 'Monthly sales target or quota for the department in local currency. Used for performance management and comp sales (SSS) analysis.',
    `selling_area_sq_ft` DECIMAL(18,2) COMMENT 'Total selling floor space allocated to the department measured in square feet. Used to calculate sales per square foot and space productivity metrics.',
    `shrinkage_rate_percent` DECIMAL(18,2) COMMENT 'Historical shrinkage rate (inventory loss due to theft, damage, spoilage) for the department expressed as a percentage of sales. Used for loss prevention planning.',
    `temperature_controlled_flag` BOOLEAN COMMENT 'Indicates whether the department requires temperature-controlled environment (e.g., frozen, refrigerated, deli, bakery). True if climate control is required.',
    `temperature_range_max_f` DECIMAL(18,2) COMMENT 'Maximum temperature threshold in Fahrenheit for temperature-controlled departments. Null for non-temperature-controlled departments.',
    `temperature_range_min_f` DECIMAL(18,2) COMMENT 'Minimum temperature threshold in Fahrenheit for temperature-controlled departments. Null for non-temperature-controlled departments.',
    `visual_merchandising_standard` STRING COMMENT 'Code or reference to the visual merchandising standard or guideline applied to the department. Defines display aesthetics, signage, and presentation rules.',
    `zone_code` STRING COMMENT 'Alphanumeric code identifying the physical zone or area within the store floor plan. Used for wayfinding, inventory location, and planogram assignment.. Valid values are `^[A-Z0-9]{1,5}$`',
    CONSTRAINT pk_department PRIMARY KEY(`department_id`)
) COMMENT 'Master record for departments or selling zones within a store location — the primary sub-location operational unit in retail. Captures department ID, department name, department code, parent store location, floor number, zone coordinates, department type (grocery, apparel, electronics, household, pharmacy, bakery, deli, produce, frozen, health & beauty, seasonal, etc.), selling area (sq ft), number of fixtures, department manager assignment reference, labor budget allocation, and active status. Departments are the fundamental unit for planogram assignment, inventory allocation, staffing schedules, shrinkage attribution, and P&L sub-reporting within a store. Most operational KPIs (sales per sq ft, shrink rate, labor-to-sales ratio) are measured at department level.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`cluster` (
    `cluster_id` BIGINT COMMENT 'Unique identifier for the store cluster. Primary key.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Supply chain network planning assigns each store cluster to a primary DC for replenishment routing. The DC-to-Cluster Service Area Assignment drives replenishment frequency, transportation lane config',
    `parent_cluster_id` BIGINT COMMENT 'Reference to a parent cluster if this cluster is part of a hierarchical clustering structure (e.g., sub-clusters within a regional cluster). Null for top-level clusters.',
    `price_zone_id` BIGINT COMMENT 'Foreign key linking to pricing.price_zone. Business justification: Retail clusters are assigned to price zones to enforce consistent pricing strategy across member stores. Cluster-level price zone assignment drives promotional planning, competitive response configura',
    `allows_overlap` BOOLEAN COMMENT 'Indicates whether a store can belong to multiple clusters of this type simultaneously. True for concurrent clustering schemes (e.g., a store can be in both an assortment cluster and a pricing zone cluster); false for mutually exclusive schemes.',
    `assortment_depth_strategy` STRING COMMENT 'Planned depth of product assortment for this cluster. Deep assortment offers extensive variety within categories; moderate offers balanced selection; shallow offers limited SKU count; curated offers highly selective premium assortment. Drives OTB planning and space allocation.. Valid values are `deep|moderate|shallow|curated`',
    `average_annual_sales_usd` DECIMAL(18,2) COMMENT 'Average annual sales volume in USD for stores in this cluster. Used for performance tier clustering and benchmarking. Business-confidential financial metric.',
    `average_store_size_sqft` DECIMAL(18,2) COMMENT 'Average selling floor area in square feet of stores in this cluster. Used for format-based clustering and space productivity benchmarking.',
    `climate_zone` STRING COMMENT 'Predominant climate classification for stores in this cluster. Used for climate-based clustering to drive seasonal assortment and inventory planning (e.g., winter apparel depth, cooling appliances).. Valid values are `tropical|arid|temperate|continental|polar`',
    `cluster_status` STRING COMMENT 'Current lifecycle status of the cluster. Active clusters are in operational use; inactive clusters are temporarily disabled; pending clusters are awaiting approval; archived clusters are historical; under_review clusters are being evaluated for changes.. Valid values are `active|inactive|pending|archived|under_review`',
    `cluster_type` STRING COMMENT 'Classification of the clustering scheme. Assortment clusters drive localized product mix; pricing zone clusters enable zone-based pricing strategies; demographic clusters group by customer profile; performance tier clusters segment by sales volume or profitability; climate clusters address seasonal/weather-driven needs; geographic clusters group by region; format clusters group by store format (hypermarket, discount, dark store); omnichannel clusters optimize fulfillment network. [ENUM-REF-CANDIDATE: assortment|pricing_zone|demographic|performance_tier|climate|geographic|format|omnichannel — 8 candidates stripped; promote to reference product]',
    `clustering_criteria` STRING COMMENT 'Business rules or data attributes used to assign stores to this cluster (e.g., sales volume > $10M, urban location, customer income > $75K, climate zone = temperate). Supports transparency and auditability of cluster logic.',
    `clustering_methodology` STRING COMMENT 'Method used to define the cluster. Algorithmic indicates data-driven segmentation (e.g., k-means, hierarchical clustering); manual indicates business-defined groupings; hybrid combines both; machine_learning indicates advanced ML models; rule_based indicates business rules engine.. Valid values are `algorithmic|manual|hybrid|machine_learning|rule_based`',
    `cluster_code` STRING COMMENT 'Business-friendly alphanumeric code for the store cluster, used in reporting and operational systems. Typically follows a pattern like REGION-TYPE-SEQ (e.g., NE-ASSORT-01, SW-PRICE-03).. Valid values are `^[A-Z0-9]{3,12}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this cluster record was first created in the system. Supports audit trail and data lineage.',
    `cluster_description` STRING COMMENT 'Detailed business description of the cluster purpose, characteristics, and intended use. Explains the rationale for grouping these stores together.',
    `effective_end_date` DATE COMMENT 'Date when this cluster definition ceases to be effective. Null indicates the cluster is currently active with no planned end date.',
    `effective_start_date` DATE COMMENT 'Date when this cluster definition becomes effective for operational use. Supports temporal validity and historical analysis of cluster changes.',
    `external_cluster_code` STRING COMMENT 'Cluster identifier from the source system of record. Used for cross-system reconciliation and data lineage tracking.',
    `geographic_scope` STRING COMMENT 'Geographic coverage of the cluster. National clusters span the entire country; regional clusters cover multi-state regions; state clusters are state-specific; metro clusters cover metropolitan areas; local clusters are city or neighborhood-level.. Valid values are `national|regional|state|metro|local`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this cluster record was last updated. Supports change tracking and audit trail.',
    `last_review_date` DATE COMMENT 'Date when this cluster definition was last reviewed and validated by the cluster owner. Used to track cluster maintenance and ensure clustering logic remains current.',
    `cluster_level` STRING COMMENT 'Depth level in the cluster hierarchy. Level 1 is top-level (e.g., national or regional); higher numbers indicate more granular sub-clusters. Supports hierarchical rollup and drill-down analysis.',
    `member_store_count` STRING COMMENT 'Total number of store locations currently assigned to this cluster. Updated as stores join or leave the cluster.',
    `cluster_name` STRING COMMENT 'Human-readable name of the store cluster, used for display and business communication (e.g., Northeast Urban High-Income, Southwest Discount Tier 1).',
    `next_review_date` DATE COMMENT 'Scheduled date for the next cluster review. Ensures periodic validation of cluster definitions and membership. Typically quarterly or semi-annually.',
    `owner_name` STRING COMMENT 'Name of the individual or role responsible for this cluster definition (e.g., Regional Merchandising Manager, Pricing Director).',
    `owner_team` STRING COMMENT 'Business function responsible for defining and maintaining this cluster. Merchandising owns assortment clusters; pricing owns pricing zone clusters; operations owns performance tier clusters; supply chain owns fulfillment clusters; marketing owns demographic clusters; analytics owns data-driven experimental clusters.. Valid values are `merchandising|pricing|operations|supply_chain|marketing|analytics`',
    `pricing_strategy` STRING COMMENT 'Pricing approach for this cluster. EDLP (Everyday Low Price) maintains consistent low prices; hi-lo uses frequent promotions; premium targets high-margin customers; competitive matches market prices; value emphasizes affordability. Drives zone pricing rules.. Valid values are `EDLP|hi_lo|premium|competitive|value`',
    `primary_business_purpose` STRING COMMENT 'Primary operational use case for this cluster (e.g., localized assortment planning, zone pricing strategy, promotional targeting, operational benchmarking, fulfillment network optimization).',
    `promotional_intensity` STRING COMMENT 'Frequency and depth of promotional activity targeted at this cluster. High intensity clusters receive frequent deep discounts; low intensity clusters have minimal promotions; none indicates EDLP strategy with no promotions.. Valid values are `high|medium|low|none`',
    `replenishment_frequency` STRING COMMENT 'Standard inventory replenishment cadence for stores in this cluster. Drives supply chain planning and DC allocation. High-volume urban stores typically receive daily replenishment; lower-volume rural stores may be weekly or bi-weekly.. Valid values are `daily|twice_weekly|weekly|bi_weekly|monthly`',
    `store_format_mix` STRING COMMENT 'Comma-separated list of store formats included in this cluster (e.g., hypermarket, discount, dark_store, MFC). Used for format-based clustering and omnichannel fulfillment optimization.',
    `supports_omnichannel` BOOLEAN COMMENT 'Indicates whether stores in this cluster are enabled for omnichannel fulfillment capabilities (BOPIS, ROPIS, ship-from-store, curbside pickup). True if cluster is designed for omnichannel operations.',
    `target_customer_segment` STRING COMMENT 'Primary customer demographic or psychographic segment this cluster is designed to serve (e.g., high-income urban professionals, budget-conscious families, college students). Used for demographic-based clustering.',
    `urbanization_level` STRING COMMENT 'Population density classification for stores in this cluster. Urban stores serve high-density city centers; suburban stores serve residential areas; rural stores serve low-density regions; exurban stores serve outer suburban fringe areas.. Valid values are `urban|suburban|rural|exurban`',
    CONSTRAINT pk_cluster PRIMARY KEY(`cluster_id`)
) COMMENT 'Master record defining store clusters — logical groupings of store locations used for localized assortment planning, zone pricing, promotional targeting, and operational benchmarking. Captures cluster ID, name, type (assortment, pricing zone, demographic, performance tier, climate), clustering methodology (algorithmic, manual override, hybrid), effective date range, member store count, and cluster owner (merchandising, pricing, or operations team). Also owns store-to-cluster membership associations including effective dates and override reasons, supporting many-to-many store-cluster relationships across concurrent clustering schemes.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` (
    `ship_from_store_node_id` BIGINT COMMENT 'Unique identifier for the ship-from-store fulfillment node. Primary key for this entity.',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: SFS nodes must reference their configured carrier service to enforce same-day/next-day cutoff times and SLA commitments. Carrier service determines eligible delivery windows and surcharge rules. Retai',
    `fulfillment_node_id` BIGINT COMMENT 'Foreign key linking to fulfillment.fulfillment_node. Business justification: SFS order routing and capacity management require linking each ship-from-store node to its corresponding fulfillment_node. This enables WMS integration, pick/pack capacity checks, and SLA target assig',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier. Business justification: SFS nodes have a primary carrier for label generation, rate negotiation, and carrier performance reporting. primary_carrier_code is a denormalized carrier reference; replacing it with a proper FK to f',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_offer. Business justification: Omnichannel promotional offers are node-specific—BOPIS promotions, same-day delivery discounts, and curbside pickup incentives are tied to fulfillment node capabilities. E-commerce and store operation',
    `inventory_node_id` BIGINT COMMENT 'Foreign key linking to inventory.inventory_node. Business justification: Ship-from-store nodes are stores functioning as fulfillment centers within the inventory network. Linking to inventory_node enables ATP queries, allocation logic, and replenishment planning to treat S',
    `location_id` BIGINT COMMENT 'Reference to the physical store location that serves as this fulfillment node. Links to the store master record.',
    `activation_date` DATE COMMENT 'Date when this fulfillment node was first activated and began accepting orders for fulfillment.',
    `average_pack_time_minutes` DECIMAL(18,2) COMMENT 'Average time in minutes required to pack a standard order at this fulfillment node. Used for capacity planning and throughput estimation.',
    `average_pick_time_minutes` DECIMAL(18,2) COMMENT 'Average time in minutes required to pick a standard order at this fulfillment node. Used for capacity planning and Service Level Agreement (SLA) estimation.',
    `carrier_account_number` STRING COMMENT 'Account number or identifier used for billing and tracking with the primary carrier. Business-confidential information used for shipment processing.',
    `contact_email` STRING COMMENT 'Email address of the primary operational contact for this fulfillment node. Organizational contact data classified as confidential.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `contact_name` STRING COMMENT 'Name of the primary operational contact or fulfillment manager for this node. Business-confidential organizational contact information.',
    `contact_phone` STRING COMMENT 'Phone number of the primary operational contact for this fulfillment node. Organizational contact data classified as confidential.',
    `cost_per_order` DECIMAL(18,2) COMMENT 'Average operational cost in local currency to fulfill one order from this node, including labor, packaging, and overhead. Used for profitability analysis and routing optimization.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this fulfillment node record was first created in the system. Audit trail for data lineage and compliance.',
    `daily_capacity_orders` STRING COMMENT 'Maximum number of orders this fulfillment node can process per day, based on staffing, space, and operational constraints. Used by OMS for capacity-based order routing.',
    `daily_capacity_units` STRING COMMENT 'Maximum number of individual units (SKUs) this fulfillment node can pick, pack, and ship per day. Complements order capacity for more granular planning.',
    `deactivation_date` DATE COMMENT 'Date when this fulfillment node was deactivated or decommissioned. Null for currently active nodes.',
    `inventory_sync_frequency_minutes` STRING COMMENT 'Frequency in minutes at which inventory positions at this fulfillment node are synchronized with the central inventory system. Lower values enable more accurate real-time inventory visibility.',
    `next_day_cutoff_time` TIMESTAMP COMMENT 'Local time cutoff (HH:MM format) by which orders must be placed to qualify for next-day delivery from this node. Null if next-day delivery is not supported.',
    `node_code` STRING COMMENT 'Externally-known unique business identifier for this fulfillment node, used in Order Management System (OMS) and Warehouse Management System (WMS) integrations.. Valid values are `^[A-Z0-9]{6,12}$`',
    `node_name` STRING COMMENT 'Human-readable name of the fulfillment node, typically matching the store name or including a fulfillment designation (e.g., Downtown Store - SFS Node).',
    `node_type` STRING COMMENT 'Classification of the fulfillment node: ship_from_store (SFS - regular store with fulfillment capability), dark_store (fulfillment-only location closed to customers), micro_fulfillment_center (MFC - automated compact fulfillment facility), or hybrid (combination model).. Valid values are `ship_from_store|dark_store|micro_fulfillment_center|hybrid`',
    `notes` STRING COMMENT 'Free-text field for operational notes, special instructions, or configuration details specific to this fulfillment node. Used for documentation and knowledge transfer.',
    `oms_integration_enabled` BOOLEAN COMMENT 'Indicates whether this fulfillment node is integrated with the Order Management System (OMS) for automated order routing and status updates. True if OMS integration is active; false otherwise.',
    `operating_hours` STRING COMMENT 'Standard operating hours for fulfillment operations at this node, typically in format Mon-Fri: 08:00-20:00, Sat-Sun: 09:00-18:00. Used for capacity planning and order routing.',
    `operational_status` STRING COMMENT 'Current operational state of the fulfillment node. Active nodes accept orders; inactive nodes are temporarily offline; suspended nodes are under review; testing nodes are in pilot phase; decommissioned nodes are permanently closed.. Valid values are `active|inactive|suspended|testing|decommissioned`',
    `picking_zone_count` STRING COMMENT 'Number of active picking zones configured within this fulfillment node. Zones organize inventory by category or location to optimize picking efficiency.',
    `picking_zone_identifiers` STRING COMMENT 'Comma-separated list of picking zone codes or identifiers active in this fulfillment node (e.g., ZONE-A,ZONE-B,ZONE-C). Used for WMS integration and picker assignment.',
    `priority_rank` STRING COMMENT 'Numeric priority rank for this fulfillment node in the order routing algorithm. Lower numbers indicate higher priority. Used when multiple nodes can fulfill an order.',
    `same_day_cutoff_time` TIMESTAMP COMMENT 'Local time cutoff (HH:MM format) by which orders must be placed to qualify for same-day delivery from this node. Null if same-day delivery is not supported.',
    `service_postal_codes` STRING COMMENT 'Comma-separated list of postal codes or postal code prefixes this fulfillment node serves. Used for zone-based order routing when radius-based routing is insufficient.',
    `service_radius_km` DECIMAL(18,2) COMMENT 'Geographic service radius in kilometers from this fulfillment node. Orders within this radius are eligible for fulfillment from this node. Used by OMS for proximity-based routing.',
    `supports_bopis` BOOLEAN COMMENT 'Indicates whether this fulfillment node supports Buy Online Pick Up In Store (BOPIS) service. True if BOPIS is available; false otherwise.',
    `supports_curbside_pickup` BOOLEAN COMMENT 'Indicates whether this fulfillment node offers curbside pickup service where customers can collect orders without entering the store. True if curbside pickup is available; false otherwise.',
    `supports_next_day_delivery` BOOLEAN COMMENT 'Indicates whether this fulfillment node offers next-day delivery service. True if next-day delivery is available; false otherwise.',
    `supports_same_day_delivery` BOOLEAN COMMENT 'Indicates whether this fulfillment node offers same-day delivery service. True if same-day delivery is available; false otherwise.',
    `timezone` STRING COMMENT 'IANA timezone identifier for this fulfillment node (e.g., America/New_York, Europe/London). Used to interpret cutoff times and operating hours in local time.',
    `updated_by` STRING COMMENT 'User identifier or system account that last modified this fulfillment node record. Audit trail for accountability and compliance.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this fulfillment node record was last modified. Audit trail for change tracking and data governance.',
    `wms_integration_enabled` BOOLEAN COMMENT 'Indicates whether this fulfillment node is integrated with the Warehouse Management System (WMS) for automated pick/pack/ship workflows. True if WMS integration is active; false if manual processes are used.',
    CONSTRAINT pk_ship_from_store_node PRIMARY KEY(`ship_from_store_node_id`)
) COMMENT 'Master record designating a store location as a Ship-from-Store (SFS), dark store, or MFC fulfillment node within the omnichannel network. Captures node ID, store location reference, node type, daily fulfillment capacity (orders/day), active picking zones within the store, assigned carrier accounts, same-day/next-day cutoff times, geographic service radius, supported delivery SLAs, and node activation status. This is the SSOT for store-as-fulfillment-node configuration consumed by OMS and fulfillment domains. The fulfillment domain owns execution (pick/pack/ship); this product owns the node capability and capacity definition.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`region` (
    `region_id` BIGINT COMMENT 'Primary key for region',
    `dc_facility_id` BIGINT COMMENT 'Identifier of the Vice President of Operations (VP Ops) to whom the Regional Director reports. Used for escalation hierarchies and organizational reporting.',
    `location_id` BIGINT COMMENT 'Identifier of the employee designated as the Regional Director (RD) responsible for overall store performance, P&L accountability, and operational standards within this region.',
    `parent_region_id` BIGINT COMMENT 'Self-referencing identifier pointing to the parent region in the geographic hierarchy (e.g., a sub-region rolls up to a macro-region or division). Null for top-level regions.',
    `price_zone_id` BIGINT COMMENT 'Foreign key linking to pricing.price_zone. Business justification: Regions are geographic pricing territories; assigning a default price zone to a region enables regional pricing directors to manage zone boundaries, competitive pricing responses, and regional P&L rep',
    `climate_zone` STRING COMMENT 'Köppen-Geiger climate classification zone for the region. Used to drive seasonal merchandise planning, HVAC cost modelling, and category assortment decisions (e.g., winter apparel depth in continental zones).',
    `region_code` STRING COMMENT 'Short alphanumeric business code uniquely identifying the region, used in reporting, store master records, and cross-system integration (e.g., NE, SW, EMEA-NORTH).',
    `comp_sales_base_year` STRING COMMENT 'The fiscal year used as the baseline for same-store sales (SSS) comparisons in this region. Ensures consistent year-over-year comp sales reporting across the regional portfolio.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code for the primary country in which this region operates (e.g., USA, GBR, DEU). Used for regulatory jurisdiction mapping and cross-border reporting.',
    `country_subdivision_code` STRING COMMENT 'ISO 3166-2 code for the principal state, province, or administrative subdivision covered by this region (e.g., US-CA, GB-ENG, DE-BY). Supports tax jurisdiction and compliance reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this region record was first created in the system, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Supports audit trails and data lineage.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the primary trading currency used in this region (e.g., USD, EUR, GBP). Drives financial consolidation and same-store sales (SSS) reporting.',
    `data_privacy_framework` STRING COMMENT 'Primary data privacy regulatory framework applicable to customer data collected in this region. Drives consent management, data retention policies, and subject access request (SAR) workflows for stores in this region.',
    `effective_end_date` DATE COMMENT 'Date on which this region record ceased to be operationally effective. Null for currently active regions. Supports SCD-2 history and GDPR audit trails.',
    `effective_start_date` DATE COMMENT 'Date from which this region record became operationally effective. Used for SCD-2 history tracking and to determine which stores were assigned to this region at any point in time.',
    `external_region_code` STRING COMMENT 'Region identifier as used in external or upstream systems (e.g., ERP, retail analytics platform, franchise management system). Enables cross-system reconciliation without exposing internal surrogate keys.',
    `fiscal_calendar_code` STRING COMMENT 'Code identifying the fiscal calendar applied to this region for financial period alignment (e.g., 4-5-4, 4-4-5, Gregorian). Critical for P&L consolidation and comp sales (SSS) period matching across regions with different fiscal structures.',
    `food_safety_authority` STRING COMMENT 'Name or code of the primary food safety regulatory authority governing grocery and perishable operations in this region (e.g., FDA, EFSA, FSA-UK). Drives compliance inspection scheduling and recall notification routing.',
    `geographic_area_km2` DECIMAL(18,2) COMMENT 'Total geographic area covered by the region in square kilometres. Used for store density analysis, logistics planning, and market penetration assessments.',
    `hierarchy_level` STRING COMMENT 'Numeric depth of this region within the geographic hierarchy. Level 1 represents the top-most tier (e.g., global division); higher numbers represent finer granularity (e.g., district, zone). Used for rollup reporting and org chart rendering.',
    `hierarchy_path` STRING COMMENT 'Materialized path string representing the full ancestry of the region from root to current node (e.g., /GLOBAL/AMERICAS/NORTH-AMERICA/NORTHEAST). Enables efficient subtree queries without recursive joins.',
    `labor_law_jurisdiction` STRING COMMENT 'Identifies the labor law jurisdiction governing employment practices for store associates in this region (e.g., US-Federal, EU-Directive, UK-Employment-Rights-Act). Used by workforce management and payroll systems.',
    `locale_code` STRING COMMENT 'IETF BCP 47 locale code representing the primary language and regional formatting conventions for this region (e.g., en_US, fr_FR, de_DE). Drives localization of store communications, receipts, and digital content.',
    `market_maturity` STRING COMMENT 'Classification of the regions retail market development stage. Emerging markets have low store penetration and high growth potential; developing markets are growing; mature markets have stable penetration; saturated markets have limited new-store opportunity. Drives capital allocation and expansion strategy.',
    `region_name` STRING COMMENT 'Full descriptive name of the region as used in business reporting and store operations (e.g., Northeast, Pacific Northwest, Central Europe).',
    `notes` STRING COMMENT 'Free-text field for operational notes, special instructions, or contextual information about the region that does not fit structured attributes (e.g., merger history, boundary change rationale, temporary operational constraints).',
    `population_estimate` BIGINT COMMENT 'Estimated total population residing within the region boundary, sourced from the most recent census or demographic data provider. Used for market sizing, store count planning, and catchment analysis.',
    `population_estimate_year` STRING COMMENT 'Calendar year to which the population estimate applies, enabling staleness assessment and refresh scheduling.',
    `region_status` STRING COMMENT 'Current lifecycle status of the region record. Active regions are in use for store assignment and reporting. Inactive regions are no longer operational. Pending regions are being set up. Archived regions are retained for historical reference only.',
    `region_type` STRING COMMENT 'Functional classification of the region indicating its primary business purpose. Operational regions group stores for management; sales regions support territory planning; franchise regions define franchisee boundaries; distribution regions align with supply chain nodes; compliance regions reflect regulatory jurisdictions; marketing regions support campaign targeting.',
    `regional_director_email` STRING COMMENT 'Business email address of the Regional Director (RD) for escalation routing, store communications, and operational alerts.',
    `regional_director_name` STRING COMMENT 'Full name of the Regional Director (RD) accountable for this region. Stored as a denormalized display field for operational dashboards and store communications.',
    `sales_channel_scope` STRING COMMENT 'Indicates the sales channel coverage applicable to this region. Omnichannel regions support both physical stores and digital fulfilment; brick-and-mortar regions cover physical stores only; ecommerce regions are digital-only; hybrid regions have partial digital integration.',
    `source_system_code` STRING COMMENT 'Code identifying the upstream operational system of record from which this region record originates (e.g., STORE_MASTER, HR_SYSTEM, ERP). Supports data lineage and master data management (MDM) reconciliation.',
    `store_count` STRING COMMENT 'Number of active retail locations currently assigned to this region. Maintained as a denormalized operational counter for quick regional capacity reporting; authoritative count is derived from the store master.',
    `store_format_scope` STRING COMMENT 'Comma-separated list of store formats present in this region (e.g., hypermarket, department_store, discount_outlet, dark_store, micro_fulfillment_center). Drives format-specific operational standards and planogram (POG) assignments. [ENUM-REF-CANDIDATE: hypermarket|department_store|discount_outlet|dark_store|micro_fulfillment_center|convenience — promote to reference product]',
    `tax_jurisdiction_code` STRING COMMENT 'Primary tax jurisdiction code for the region, used to determine applicable sales tax, VAT, or GST rates for store-level transactions. Maps to the tax engines jurisdiction table.',
    `timezone` STRING COMMENT 'IANA timezone identifier for the primary timezone of the region (e.g., America/New_York, Europe/Berlin). Used to normalize store operating hours, footfall timestamps, and POS transaction times.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this region record, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Used for change detection and incremental data pipeline processing.',
    `vat_applicable_flag` BOOLEAN COMMENT 'Indicates whether Value Added Tax (VAT) applies to retail transactions in this region. True for VAT-registered jurisdictions; False for sales-tax or tax-exempt jurisdictions. Drives POS tax calculation logic.',
    CONSTRAINT pk_region PRIMARY KEY(`region_id`)
) COMMENT 'Master reference table for region. Referenced by region_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`assignment` (
    `assignment_id` BIGINT COMMENT 'Unique identifier for this store-cluster assignment record. Primary key.',
    `cluster_id` BIGINT COMMENT 'Foreign key linking to the cluster to which the store location is assigned',
    `location_id` BIGINT COMMENT 'Foreign key linking to the store location being assigned to a cluster',
    `assigned_by` STRING COMMENT 'Name or identifier of the user or system process that created this assignment. Used for accountability and audit trail.',
    `assignment_date` DATE COMMENT 'Date when this store-cluster assignment was created in the system. Distinct from effective_start_date, which is when the assignment becomes operationally active. Used for audit and change tracking.',
    `assignment_status` STRING COMMENT 'Current lifecycle status of this assignment. Active = currently in effect; Pending = scheduled for future activation; Expired = past effective_end_date; Overridden = superseded by a newer assignment.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this assignment record was first created in the system. Used for data lineage and audit.',
    `effective_end_date` DATE COMMENT 'Date when this store-cluster assignment ceases to be effective. Null indicates the assignment is currently active. Supports historical tracking of cluster membership changes.',
    `effective_start_date` DATE COMMENT 'Date when this store-cluster assignment becomes effective for operational use. Supports historical tracking of cluster membership changes over time, critical for SSS comparisons and assortment localization audits.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this assignment record was last updated. Used for change tracking and data lineage.',
    `override_reason` STRING COMMENT 'Business justification for manual override of algorithmic cluster assignment. Populated when clustering_methodology is manual override or hybrid. Examples: competitive pressure, local market dynamics, new store ramp-up period.',
    `primary_cluster_flag` BOOLEAN COMMENT 'Indicates whether this cluster is the primary cluster for this store location within its cluster type. Used when a store belongs to multiple clusters of the same type and one must be designated as primary for reporting or operational precedence.',
    CONSTRAINT pk_assignment PRIMARY KEY(`assignment_id`)
) COMMENT 'This association product represents the Assignment between location and cluster. It captures the operational assignment of store locations to logical clusters for localized assortment planning, zone pricing, promotional targeting, and operational benchmarking. Each record links one location to one cluster with attributes that exist only in the context of this relationship, including assignment dates, primary cluster designation, and override reasons. Supports concurrent membership across multiple clustering schemes (assortment, pricing zone, demographic, performance tier, climate) as explicitly designed by the business via the allows_overlap flag.. Existence Justification: In retail operations, store locations are routinely assigned to multiple cluster types simultaneously for different operational purposes (geographic cluster, format cluster, volume-tier cluster, climate cluster, pricing zone). The cluster product explicitly includes allows_overlap: BOOLEAN as direct schema evidence that the business designed clusters to support overlapping membership. Each assignment carries temporal attributes (effective dates), designation attributes (primary_cluster_flag), and audit attributes (assignment_date, override_reason) that belong to the relationship itself, not to either location or cluster.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`store`.`location` ADD CONSTRAINT `fk_store_location_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`format` ADD CONSTRAINT `fk_store_format_parent_format_id` FOREIGN KEY (`parent_format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ADD CONSTRAINT `fk_store_pos_terminal_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ADD CONSTRAINT `fk_store_pos_terminal_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ADD CONSTRAINT `fk_store_traffic_count_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ADD CONSTRAINT `fk_store_traffic_count_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`department` ADD CONSTRAINT `fk_store_department_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ADD CONSTRAINT `fk_store_cluster_parent_cluster_id` FOREIGN KEY (`parent_cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`region` ADD CONSTRAINT `fk_store_region_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`region` ADD CONSTRAINT `fk_store_region_parent_region_id` FOREIGN KEY (`parent_region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` ADD CONSTRAINT `fk_store_assignment_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` ADD CONSTRAINT `fk_store_assignment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`store` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_retail_v1`.`store` SET TAGS ('dbx_domain' = 'store');
ALTER TABLE `vibe_retail_v1`.`store`.`location` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`location` SET TAGS ('dbx_subdomain' = 'physical_infrastructure');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store Location ID');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `price_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Price Zone Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Store Address Line 1');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `address_line1` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Store Address Line 2');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `address_line2` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `assortment_breadth_norm` SET TAGS ('dbx_value_regex' = 'narrow|moderate|broad|very_broad');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `assortment_depth_norm` SET TAGS ('dbx_value_regex' = 'shallow|moderate|deep|very_deep');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `banner_brand` SET TAGS ('dbx_business_glossary_term' = 'Retail Banner Brand');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `bopis_capable` SET TAGS ('dbx_business_glossary_term' = 'Buy Online Pick Up In Store (BOPIS) Capable');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'Store City');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `climate_zone` SET TAGS ('dbx_value_regex' = 'tropical|subtropical|temperate|continental|polar');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `closure_date` SET TAGS ('dbx_business_glossary_term' = 'Store Closure Date');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Store Country Code');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `district_code` SET TAGS ('dbx_business_glossary_term' = 'Retail District Code');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `dsd_receiving` SET TAGS ('dbx_business_glossary_term' = 'Direct Store Delivery (DSD) Receiving');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Store Email Address');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `email_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `format_size_band` SET TAGS ('dbx_business_glossary_term' = 'Store Format Size Band');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `format_size_band` SET TAGS ('dbx_value_regex' = 'small|medium|large|extra_large');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Store Latitude');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Store Lifecycle Status');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'planned|under_construction|open|temporarily_closed|permanently_closed|remodeling');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `locale` SET TAGS ('dbx_business_glossary_term' = 'Store Locale');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `locale` SET TAGS ('dbx_value_regex' = '^[a-z]{2}_[A-Z]{2}$');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Store Longitude');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `manager_name` SET TAGS ('dbx_business_glossary_term' = 'Store Manager Name');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `opening_date` SET TAGS ('dbx_business_glossary_term' = 'Store Opening Date');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `operating_hours` SET TAGS ('dbx_business_glossary_term' = 'Store Operating Hours');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Store Phone Number');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Store Postal Code');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Retail Region Code');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `ropis_capable` SET TAGS ('dbx_business_glossary_term' = 'Reserve Online Pick Up In Store (ROPIS) Capable');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `sfs_capable` SET TAGS ('dbx_business_glossary_term' = 'Ship From Store (SFS) Capable');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `staffing_model_type` SET TAGS ('dbx_value_regex' = 'full_service|limited_service|self_service|automated');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'Store State or Province');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `state_province` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `store_name` SET TAGS ('dbx_business_glossary_term' = 'Store Trading Name');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `store_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `time_zone` SET TAGS ('dbx_business_glossary_term' = 'Store Time Zone');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `time_zone` SET TAGS ('dbx_value_regex' = '^[A-Z]{3,5}$');
ALTER TABLE `vibe_retail_v1`.`store`.`format` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`store`.`format` SET TAGS ('dbx_subdomain' = 'physical_infrastructure');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Store Format ID');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `assortment_breadth_level` SET TAGS ('dbx_value_regex' = 'narrow|moderate|broad|very_broad');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `assortment_depth_level` SET TAGS ('dbx_value_regex' = 'shallow|moderate|deep|very_deep');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `bopis_capable_flag` SET TAGS ('dbx_business_glossary_term' = 'BOPIS (Buy Online Pick Up In Store) Capable Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `clienteling_service_flag` SET TAGS ('dbx_business_glossary_term' = 'Clienteling (Personalized In-Store Service) Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `format_code` SET TAGS ('dbx_business_glossary_term' = 'Store Format Code');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `format_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `format_description` SET TAGS ('dbx_business_glossary_term' = 'Store Format Description');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `dsd_receiving_flag` SET TAGS ('dbx_business_glossary_term' = 'DSD (Direct Store Delivery) Receiving Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `endcap_count_typical` SET TAGS ('dbx_business_glossary_term' = 'Endcap (End-of-Aisle Display) Count Typical');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `format_status` SET TAGS ('dbx_business_glossary_term' = 'Store Format Status');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `format_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated|pilot');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `format_type` SET TAGS ('dbx_business_glossary_term' = 'Store Format Type');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `format_type` SET TAGS ('dbx_value_regex' = 'physical_retail|fulfillment_only|hybrid');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `gondola_configuration_type` SET TAGS ('dbx_business_glossary_term' = 'Gondola (Shelving Unit) Configuration Type');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `gondola_configuration_type` SET TAGS ('dbx_value_regex' = 'standard|high_density|low_profile|modular|custom');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `format_name` SET TAGS ('dbx_business_glossary_term' = 'Store Format Name');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `operating_hours_type` SET TAGS ('dbx_value_regex' = '24_7|extended|standard|limited|variable');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `planogram_template_code` SET TAGS ('dbx_business_glossary_term' = 'Planogram (POG) Template Code');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `planogram_template_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `pos_terminal_count_max` SET TAGS ('dbx_business_glossary_term' = 'POS (Point of Sale) Terminal Count Maximum');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `pos_terminal_count_min` SET TAGS ('dbx_business_glossary_term' = 'POS (Point of Sale) Terminal Count Minimum');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `pricing_strategy_type` SET TAGS ('dbx_value_regex' = 'edlp|hi_lo|premium|discount|dynamic');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `rfid_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'RFID (Radio Frequency Identification) Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `ropis_capable_flag` SET TAGS ('dbx_business_glossary_term' = 'ROPIS (Reserve Online Pick Up In Store) Capable Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `sfs_capable_flag` SET TAGS ('dbx_business_glossary_term' = 'SFS (Ship-from-Store) Capable Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `size_band_max_sqft` SET TAGS ('dbx_business_glossary_term' = 'Size Band Maximum Square Feet');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `size_band_min_sqft` SET TAGS ('dbx_business_glossary_term' = 'Size Band Minimum Square Feet');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `staffing_model_type` SET TAGS ('dbx_value_regex' = 'full_service|limited_service|self_service|automated|hybrid');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `typical_sku_count_max` SET TAGS ('dbx_business_glossary_term' = 'Typical SKU (Stock Keeping Unit) Count Maximum');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `typical_sku_count_min` SET TAGS ('dbx_business_glossary_term' = 'Typical SKU (Stock Keeping Unit) Count Minimum');
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `wms_integration_required_flag` SET TAGS ('dbx_business_glossary_term' = 'WMS (Warehouse Management System) Integration Required Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` SET TAGS ('dbx_subdomain' = 'physical_infrastructure');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `pos_terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Point-of-Sale (POS) Terminal ID');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Store Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `barcode_scanner_type` SET TAGS ('dbx_value_regex' = 'handheld|fixed_mount|presentation|none');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `contactless_enabled` SET TAGS ('dbx_business_glossary_term' = 'Contactless (NFC) Enabled');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `customer_display_type` SET TAGS ('dbx_value_regex' = 'pole_display|integrated_screen|tablet|none');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `ebt_snap_enabled` SET TAGS ('dbx_business_glossary_term' = 'EBT/SNAP Enabled');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `hardware_serial_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{8,30}$');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `ip_address` SET TAGS ('dbx_value_regex' = '^(?:[0-9]{1,3}.){3}[0-9]{1,3}$');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `ip_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `ip_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `mac_address` SET TAGS ('dbx_value_regex' = '^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `mac_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `mac_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `mobile_wallet_enabled` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `mobile_wallet_enabled` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `network_zone` SET TAGS ('dbx_value_regex' = 'cardholder_data_environment|corporate_network|guest_network|isolated');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `software_version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `terminal_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,20}$');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `terminal_status` SET TAGS ('dbx_value_regex' = 'active|offline|maintenance|decommissioned|pending_activation|suspended');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `terminal_type` SET TAGS ('dbx_value_regex' = 'staffed_checkout_lane|self_checkout_kiosk|mobile_pos|customer_service_desk|pharmacy_register|express_lane');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` SET TAGS ('dbx_subdomain' = 'operational_metrics');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `traffic_count_id` SET TAGS ('dbx_business_glossary_term' = 'Traffic Count Identifier');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `accuracy_confidence_percent` SET TAGS ('dbx_business_glossary_term' = 'Accuracy Confidence (Percent)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `average_dwell_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Average Dwell Time (Minutes)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `conversion_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Conversion Rate (Percent)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `counting_zone_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `measurement_interval_minutes` SET TAGS ('dbx_business_glossary_term' = 'Measurement Interval (Minutes)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `sensor_device_code` SET TAGS ('dbx_business_glossary_term' = 'Sensor Device ID');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `sensor_device_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{8,30}$');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `sensor_type` SET TAGS ('dbx_value_regex' = 'thermal|video_analytics|infrared|rfid|wifi_tracking|bluetooth_beacon');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `temperature_fahrenheit` SET TAGS ('dbx_business_glossary_term' = 'Temperature (Fahrenheit)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `zone_type` SET TAGS ('dbx_value_regex' = 'entrance|department|checkout|aisle|endcap|gondola');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` SET TAGS ('dbx_subdomain' = 'operational_metrics');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Inventory Adjustment Transaction ID');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Store Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `inbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Shipment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `replenishment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `rma_id` SET TAGS ('dbx_business_glossary_term' = 'Rma Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `case_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Loss Prevention (LP) Case Reference Number');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `detection_method` SET TAGS ('dbx_value_regex' = 'pos_exception|cycle_count|physical_inventory|rfid_scan|lp_investigation|vendor_audit');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `event_date` SET TAGS ('dbx_business_glossary_term' = 'Shrinkage Event Date');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `event_number` SET TAGS ('dbx_business_glossary_term' = 'Shrinkage Event Number');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `event_number` SET TAGS ('dbx_value_regex' = '^SHR-[0-9]{10}$');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `event_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Shrinkage Event Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-Q[1-4]$|^[0-9]{4}-[0-9]{2}$');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `incident_report_filed` SET TAGS ('dbx_business_glossary_term' = 'Incident Report Filed Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `inventory_adjustment_posted` SET TAGS ('dbx_business_glossary_term' = 'Inventory Adjustment Posted Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Shrinkage Event Notes');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `recovery_method` SET TAGS ('dbx_value_regex' = 'merchandise_recovered|restitution|insurance_claim|vendor_credit|chargeback|none');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `resolution_status` SET TAGS ('dbx_value_regex' = 'open|under_investigation|resolved|closed_unresolved|recovered');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `responsible_party_type` SET TAGS ('dbx_value_regex' = 'external|employee|vendor|unknown|not_applicable');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `shrinkage_type` SET TAGS ('dbx_value_regex' = 'external_theft|internal_theft|administrative_error|vendor_fraud|damage|unknown');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `sku` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'each|case|pound|kilogram|liter|gallon');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `upc` SET TAGS ('dbx_business_glossary_term' = 'Universal Product Code (UPC)');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `upc` SET TAGS ('dbx_value_regex' = '^[0-9]{12}$');
ALTER TABLE `vibe_retail_v1`.`store`.`department` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`department` SET TAGS ('dbx_subdomain' = 'physical_infrastructure');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Store Department ID');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `price_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Price Zone Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Vendor Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `return_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Return Policy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `department_status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_construction|seasonal_closed|remodeling|pending_closure');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Department Notes');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `planogram_count` SET TAGS ('dbx_business_glossary_term' = 'Planogram (POG) Count');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `pos_terminal_count` SET TAGS ('dbx_business_glossary_term' = 'Point of Sale (POS) Terminal Count');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `selling_area_sq_ft` SET TAGS ('dbx_business_glossary_term' = 'Selling Area Square Feet');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `temperature_range_max_f` SET TAGS ('dbx_business_glossary_term' = 'Temperature Range Maximum Fahrenheit');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `temperature_range_min_f` SET TAGS ('dbx_business_glossary_term' = 'Temperature Range Minimum Fahrenheit');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `zone_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` SET TAGS ('dbx_subdomain' = 'physical_infrastructure');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `parent_cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `price_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Price Zone Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `allows_overlap` SET TAGS ('dbx_business_glossary_term' = 'Allows Store Overlap Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `assortment_depth_strategy` SET TAGS ('dbx_value_regex' = 'deep|moderate|shallow|curated');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `average_annual_sales_usd` SET TAGS ('dbx_business_glossary_term' = 'Average Annual Sales (USD)');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `average_store_size_sqft` SET TAGS ('dbx_business_glossary_term' = 'Average Store Size (Square Feet)');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `climate_zone` SET TAGS ('dbx_value_regex' = 'tropical|arid|temperate|continental|polar');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `cluster_status` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster Status');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `cluster_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|archived|under_review');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `cluster_type` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster Type');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `clustering_methodology` SET TAGS ('dbx_value_regex' = 'algorithmic|manual|hybrid|machine_learning|rule_based');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `cluster_code` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster Code');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `cluster_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,12}$');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `cluster_description` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster Description');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Cluster Effective End Date');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Cluster Effective Start Date');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `external_cluster_code` SET TAGS ('dbx_business_glossary_term' = 'External Cluster ID');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = 'national|regional|state|metro|local');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `cluster_level` SET TAGS ('dbx_business_glossary_term' = 'Cluster Hierarchy Level');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `cluster_name` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster Name');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `owner_name` SET TAGS ('dbx_business_glossary_term' = 'Cluster Owner Name');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `owner_team` SET TAGS ('dbx_business_glossary_term' = 'Cluster Owner Team');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `owner_team` SET TAGS ('dbx_value_regex' = 'merchandising|pricing|operations|supply_chain|marketing|analytics');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `pricing_strategy` SET TAGS ('dbx_value_regex' = 'EDLP|hi_lo|premium|competitive|value');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `promotional_intensity` SET TAGS ('dbx_value_regex' = 'high|medium|low|none');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `replenishment_frequency` SET TAGS ('dbx_value_regex' = 'daily|twice_weekly|weekly|bi_weekly|monthly');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `supports_omnichannel` SET TAGS ('dbx_business_glossary_term' = 'Supports Omnichannel Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `urbanization_level` SET TAGS ('dbx_value_regex' = 'urban|suburban|rural|exurban');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` SET TAGS ('dbx_subdomain' = 'operational_metrics');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `ship_from_store_node_id` SET TAGS ('dbx_business_glossary_term' = 'Ship-from-Store (SFS) Fulfillment Node ID');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Carrier Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `inventory_node_id` SET TAGS ('dbx_business_glossary_term' = 'Inventory Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `carrier_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `carrier_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_email` SET TAGS ('dbx_business_glossary_term' = 'Contact Email Address');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Contact Phone Number');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `inventory_sync_frequency_minutes` SET TAGS ('dbx_business_glossary_term' = 'Inventory Synchronization Frequency Minutes');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `next_day_cutoff_time` SET TAGS ('dbx_business_glossary_term' = 'Next-Day Delivery Cutoff Time');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `node_code` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Node Code');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `node_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `node_name` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Node Name');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `node_type` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Node Type');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `node_type` SET TAGS ('dbx_value_regex' = 'ship_from_store|dark_store|micro_fulfillment_center|hybrid');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Operational Notes');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `oms_integration_enabled` SET TAGS ('dbx_business_glossary_term' = 'Order Management System (OMS) Integration Enabled');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|testing|decommissioned');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `same_day_cutoff_time` SET TAGS ('dbx_business_glossary_term' = 'Same-Day Delivery Cutoff Time');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `service_radius_km` SET TAGS ('dbx_business_glossary_term' = 'Service Radius Kilometers');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `supports_bopis` SET TAGS ('dbx_business_glossary_term' = 'Supports Buy Online Pick Up In Store (BOPIS)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `supports_next_day_delivery` SET TAGS ('dbx_business_glossary_term' = 'Supports Next-Day Delivery');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `supports_same_day_delivery` SET TAGS ('dbx_business_glossary_term' = 'Supports Same-Day Delivery');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `updated_by` SET TAGS ('dbx_business_glossary_term' = 'Updated By User');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `wms_integration_enabled` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Management System (WMS) Integration Enabled');
ALTER TABLE `vibe_retail_v1`.`store`.`region` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`region` SET TAGS ('dbx_subdomain' = 'physical_infrastructure');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Identifier');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `price_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Price Zone Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `regional_director_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `regional_director_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` SET TAGS ('dbx_subdomain' = 'physical_infrastructure');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` SET TAGS ('dbx_association_edges' = 'store.location,store.cluster');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` ALTER COLUMN `assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster Assignment Identifier');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Assignment - Cluster Id');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Assignment - Location Id');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` ALTER COLUMN `assigned_by` SET TAGS ('dbx_business_glossary_term' = 'Assignment Creator');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` ALTER COLUMN `assignment_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Creation Date');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` ALTER COLUMN `assignment_status` SET TAGS ('dbx_business_glossary_term' = 'Assignment Status');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Effective End Date');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Effective Start Date');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` ALTER COLUMN `override_reason` SET TAGS ('dbx_business_glossary_term' = 'Manual Override Reason');
ALTER TABLE `vibe_retail_v1`.`store`.`assignment` ALTER COLUMN `primary_cluster_flag` SET TAGS ('dbx_business_glossary_term' = 'Primary Cluster Indicator');
