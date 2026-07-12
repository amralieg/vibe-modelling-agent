-- Schema for Domain: store | Business: Retail | Version: v2_mvm
-- Generated on: 2026-07-12 10:43:59

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`store` COMMENT 'Manages physical retail locations including hypermarkets, department stores, discount outlets, dark stores, and micro-fulfillment centers (MFC). Owns store master records, planograms (POG), gondola and endcap configurations, footfall metrics, comp sales (SSS - Same-Store Sales), visual merchandising standards, POS terminal inventory, and store-level P&L. Supports store operations and omnichannel fulfillment as ship-from-store nodes.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`location` (
    `location_id` BIGINT COMMENT 'Unique identifier for the physical retail location. Primary key for the store_location data product. This is the system-of-record identifier used across all domains (inventory, order, workforce, finance) to reference this specific store, dark store, or micro-fulfillment center (MFC).',
    `cluster_id` BIGINT COMMENT 'Foreign key linking to store.cluster. Business justification: A store location is assigned to a cluster for localized assortment, pricing, and promotional strategies — a foundational retail grouping pattern. The location table has no cluster_id today; adding thi',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.store_format. Business justification: Every store location is classified by a store format (hypermarket, discount outlet, department store, etc.). The store_location record currently denormalizes format_type as a STRING. Adding FK to stor',
    `price_zone_id` BIGINT COMMENT 'Foreign key linking to pricing.price_zone. Business justification: Stores belong to price zones for regional pricing strategies. This is a fundamental retail concept - stores in the same geographic area or market segment share pricing rules. No visible redundant colu',
    `region_id` BIGINT COMMENT 'Foreign key linking to store.region. Business justification: store.location has region_code (STRING) but no FK to store.region. Adding region_id -> store.region.region_id establishes the authoritative geographic hierarchy link between a physical store location ',
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
    `price_zone_id` BIGINT COMMENT 'Foreign key linking to pricing.price_zone. Business justification: Store format-level price zone assignment drives default pricing strategy for all stores of that format (hypermarket vs. discount outlet). Used in format-level planogram pricing, competitive positionin',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`department` (
    `department_id` BIGINT COMMENT 'Unique identifier for the store department. Primary key for the store department entity.',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Store departments map to merchandise categories (item hierarchy). Department managers are responsible for specific categories. Essential for departmental P&L reporting by category and category manager',
    `location_id` BIGINT COMMENT 'Reference to the parent store location where this department is physically located.',
    `price_list_id` BIGINT COMMENT 'Foreign key linking to pricing.price_list. Business justification: Licensed and specialty departments (pharmacy, optical, jewelry) operate under distinct price lists separate from the main store list. Department-level price list assignment drives POS price resolution',
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
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Cluster-level replenishment planning and assortment allocation require knowing which DC primarily serves a cluster. Retail planners assign clusters to DCs for distribution routing, promotional stock s',
    `parent_cluster_id` BIGINT COMMENT 'Reference to a parent cluster if this cluster is part of a hierarchical clustering structure (e.g., sub-clusters within a regional cluster). Null for top-level clusters.',
    `price_zone_id` BIGINT COMMENT 'Foreign key linking to pricing.price_zone. Business justification: Store clusters group locations by competitive/demographic profile; assigning a default price zone to a cluster operationalizes the clusters pricing_strategy attribute. Cluster-level price zone drives',
    `region_id` BIGINT COMMENT 'Foreign key linking to store.region. Business justification: Clusters are geographically scoped groupings of store locations. The cluster table carries geographic_scope (STRING) and urbanization_level (STRING) as descriptive fields, but has no FK to the authori',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`sales_territory` (
    `sales_territory_id` BIGINT COMMENT 'Primary key for sales_territory',
    `dc_facility_id` BIGINT COMMENT 'Reference to the employee who manages this sales territory. Responsible for territory performance and team oversight.',
    `parent_sales_territory_id` BIGINT COMMENT 'Self-referencing FK on sales_territory (parent_sales_territory_id)',
    `parent_territory_id` BIGINT COMMENT 'Reference to the parent sales territory in a hierarchical territory structure. Null for top-level territories.',
    `region_id` BIGINT COMMENT 'Reference to the geographic region this territory belongs to, for regional sales reporting and management.',
    `location_id` BIGINT COMMENT 'add column store_location_id (BIGINT) with FK to store.location.location_id - sales territories contain store locations and this assignment relationship is missing',
    `annual_revenue_target` DECIMAL(18,2) COMMENT 'Target annual revenue goal for this sales territory, used for performance measurement and incentive compensation.',
    `boundary_definition` STRING COMMENT 'Textual or structured definition of territory boundaries (e.g., list of counties, postal codes, geographic coordinates, or natural boundaries).',
    `competition_level` STRING COMMENT 'Assessment of competitive intensity within this sales territory: low (few competitors), moderate (balanced), high (many competitors), very_high (saturated market), monopoly (single dominant player).',
    `country_code` STRING COMMENT 'Three-letter ISO country code representing the primary country for this sales territory (e.g., USA, CAN, GBR, DEU).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this sales territory record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code for financial targets and reporting in this territory (e.g., USD, CAD, EUR, GBP).',
    `customer_count` STRING COMMENT 'Number of active customers assigned to this sales territory. Used for territory balancing and performance benchmarking.',
    `effective_end_date` DATE COMMENT 'Date when this sales territory ceases or ceased to be active. Null for open-ended territories.',
    `effective_start_date` DATE COMMENT 'Date when this sales territory becomes or became active and operational for sales assignments and reporting.',
    `household_count` BIGINT COMMENT 'Total number of households within this sales territory. Used for consumer market analysis and targeting.',
    `language_code` STRING COMMENT 'Primary language code for customer communication and marketing in this territory (e.g., en, es, fr, de).',
    `last_modified_by` STRING COMMENT 'Username or identifier of the user who last modified this sales territory record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this sales territory record was last updated or modified.',
    `market_potential_score` DECIMAL(18,2) COMMENT 'Quantitative score (0-100) representing the market opportunity and growth potential of this territory, based on demographics, competition, and economic indicators.',
    `median_household_income` DECIMAL(18,2) COMMENT 'Median annual household income within this territory, used for demographic profiling and product assortment planning.',
    `notes` STRING COMMENT 'Free-form notes and comments about this sales territory, including special instructions, historical context, or operational considerations.',
    `population_size` BIGINT COMMENT 'Total population count within the geographic boundaries of this sales territory. Used for market sizing and penetration analysis.',
    `postal_code_range_end` STRING COMMENT 'Ending postal code for territories defined by postal code ranges. Used for geographic territory assignment.',
    `postal_code_range_start` STRING COMMENT 'Starting postal code for territories defined by postal code ranges. Used for geographic territory assignment.',
    `priority_tier` STRING COMMENT 'Strategic priority classification for resource allocation and management focus. Tier 1/strategic territories receive highest investment; tier 3/maintenance receive baseline support.',
    `sales_channel` STRING COMMENT 'Primary sales channel served by this territory: retail (physical stores), wholesale (bulk/distributor), ecommerce (online), B2B (business customers), B2C (consumers), omnichannel (integrated).',
    `sales_rep_count` STRING COMMENT 'Number of sales representatives currently assigned to this territory. Used for capacity planning and workload balancing.',
    `sales_territory_status` STRING COMMENT 'Current lifecycle status of the sales territory. Active territories are operational; inactive are closed; pending are awaiting activation; suspended are temporarily halted; archived are historical; planned are future territories.',
    `state_province_code` STRING COMMENT 'State or province code for territories defined at sub-national level (e.g., CA, TX, ON, QC).',
    `store_count` STRING COMMENT 'Number of retail stores located within this sales territory. Used for territory sizing and resource allocation.',
    `territory_code` STRING COMMENT 'Unique business identifier code for the sales territory, used for external reference and reporting.',
    `territory_description` STRING COMMENT 'Detailed textual description of the sales territory, including geographic boundaries, key characteristics, strategic focus, and special considerations.',
    `territory_level` STRING COMMENT 'Numeric level in the territory hierarchy (e.g., 1=National, 2=Regional, 3=District, 4=Local). Used for rollup reporting and organizational structure.',
    `territory_name` STRING COMMENT 'Human-readable name of the sales territory (e.g., Northeast Region, California Metro, EMEA South).',
    `territory_type` STRING COMMENT 'Classification of the territory segmentation strategy: geographic (region-based), account-based (customer segments), product-based (product lines), channel-based (retail/wholesale/online), hybrid (combination), or strategic (key accounts).',
    `time_zone` STRING COMMENT 'Primary time zone for this sales territory (e.g., America/New_York, America/Los_Angeles, Europe/London). Used for scheduling and reporting.',
    `created_by` STRING COMMENT 'Username or identifier of the user who created this sales territory record.',
    CONSTRAINT pk_sales_territory PRIMARY KEY(`sales_territory_id`)
) COMMENT 'Master reference table for sales_territory. Referenced by sales_territory_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` (
    `ship_from_store_node_id` BIGINT COMMENT 'Unique identifier for the ship-from-store fulfillment node. Primary key for this entity.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier. Business justification: SFS nodes operate under carrier contracts tracked at the carrier level. carrier_account_number is a denormalized carrier reference. A direct FK to carrier enables contract management, negotiated rate ',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: SFS nodes are configured with a primary carrier service driving label generation, rate shopping, and SLA commitments. primary_carrier_code is a denormalized text reference to carrier_service. Normaliz',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Each ship-from-store node is replenished by and returns excess inventory to a designated DC. OMS and WMS systems require this link to route replenishment orders, manage returns-to-DC workflows, and re',
    `fulfillment_node_id` BIGINT COMMENT 'Foreign key linking to fulfillment.fulfillment_node. Business justification: SFS node operational governance: a ship-from-store node IS a fulfillment node operationally. Order routing, WMS integration, and SFS capacity planning all require knowing which fulfillment_node govern',
    `location_id` BIGINT COMMENT 'Reference to the physical store location that serves as this fulfillment node. Links to the store master record.',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_offer. Business justification: Omnichannel promotional offers are node-specific—BOPIS promotions, same-day delivery discounts, and curbside pickup incentives are tied to fulfillment node capabilities. E-commerce and store operation',
    `replenishment_plan_id` BIGINT COMMENT 'Foreign key linking to supplychain.replenishment_plan. Business justification: Omnichannel campaigns drive ship-from-store orders; fulfillment nodes track campaign-attributed order volume for capacity planning and marketing attribution. E-commerce operations require campaign lin',
    `activation_date` DATE COMMENT 'Date when this fulfillment node was first activated and began accepting orders for fulfillment.',
    `average_pack_time_minutes` DECIMAL(18,2) COMMENT 'Average time in minutes required to pack a standard order at this fulfillment node. Used for capacity planning and throughput estimation.',
    `average_pick_time_minutes` DECIMAL(18,2) COMMENT 'Average time in minutes required to pick a standard order at this fulfillment node. Used for capacity planning and Service Level Agreement (SLA) estimation.',
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
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Regional distribution planning assigns a primary DC to each region for inbound logistics routing, regional P&L cost allocation, and disaster-recovery rerouting. Retail supply chain directors expect re',
    `parent_region_id` BIGINT COMMENT 'Self-referencing foreign key to the parent region in the geographic hierarchy (e.g., a sub-region rolls up to a macro-region). Null for top-level regions.',
    `area_sq_km` DECIMAL(18,2) COMMENT 'Total geographic area of the region expressed in square kilometres. Used for store density analysis, market penetration calculations, and territory planning.',
    `climate_zone` STRING COMMENT 'Köppen-Geiger climate classification zone for the region. Influences seasonal merchandise planning, HVAC standards for stores, and cold-chain logistics requirements.',
    `region_code` STRING COMMENT 'Short, externally-known alphanumeric code that uniquely identifies the region across operational systems (e.g., NE, APAC-SOUTH). Used in reporting, store master data, and cross-system integration.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code for the primary country this region belongs to (e.g., GBR, USA, DEU). Used for regulatory, tax, and currency alignment.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this region record was first created in the data platform. Used for audit trail, data lineage, and SCD-2 history management. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the primary trading currency used in this region (e.g., GBP, USD, EUR). Drives pricing, P&L reporting, and financial consolidation.',
    `data_privacy_framework` STRING COMMENT 'Primary data privacy regulatory framework applicable to customer data collected in this region (e.g., GDPR for EU, CCPA for California, PDPA for Thailand). Drives consent management and data retention policies.',
    `ecommerce_enabled` BOOLEAN COMMENT 'Indicates whether the e-commerce platform is active and accepting orders for delivery or collection within this region. Drives digital marketing spend allocation and last-mile logistics planning.',
    `effective_end_date` DATE COMMENT 'Date on which this region definition ceased to be operationally effective. Null for currently active records. Supports SCD-2 history and GDPR audit requirements.',
    `effective_start_date` DATE COMMENT 'Date from which this region definition became operationally effective. Supports SCD-2 history tracking and enables point-in-time analysis of regional boundaries and assignments.',
    `external_reference_code` STRING COMMENT 'Region identifier as used in external partner systems, government statistical classifications (e.g., NUTS code in Europe, FIPS code in the USA), or third-party data providers. Enables cross-system reconciliation.',
    `franchise_model` BOOLEAN COMMENT 'Indicates whether stores in this region operate under a franchise model rather than direct corporate ownership. Affects P&L consolidation, compliance obligations, and operational reporting scope.',
    `gdp_per_capita_usd` DECIMAL(18,2) COMMENT 'Gross Domestic Product (GDP) per capita for the region expressed in USD, sourced from national statistics or IMF data. Used as a proxy for consumer purchasing power in assortment and pricing strategy.',
    `gdp_reference_year` STRING COMMENT 'The calendar year to which the GDP per capita figure refers, enabling users to assess data currency.',
    `hierarchy_level` STRING COMMENT 'Numeric depth of this region within the geographic hierarchy. Level 1 is the top (e.g., global zone), increasing integers represent finer granularity (e.g., country, macro-region, sub-region, district).',
    `hierarchy_path` STRING COMMENT 'Materialised slash-delimited path of region codes from root to this node (e.g., GLOBAL/EMEA/UK/NORTH). Enables efficient subtree queries without recursive CTEs.',
    `hq_address_line1` STRING COMMENT 'First line of the street address for the regions administrative headquarters office. Used for official correspondence, regulatory filings, and field operations coordination.',
    `hq_city` STRING COMMENT 'City in which the regions administrative headquarters is located. Used for correspondence, regulatory filings, and geographic reporting.',
    `hq_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code for the country in which the regions administrative headquarters is located. May differ from the regions operational country in cross-border management structures.',
    `hq_postal_code` STRING COMMENT 'Postal or ZIP code of the regions administrative headquarters. Used for correspondence, tax jurisdiction mapping, and logistics routing.',
    `is_current` BOOLEAN COMMENT 'SCD-2 indicator that is True for the currently active version of the region record and False for superseded historical versions. Simplifies current-state queries without date-range filtering.',
    `language_code` STRING COMMENT 'IETF BCP 47 language tag representing the primary language used in this region for store communications, signage, and customer-facing content (e.g., en-GB, fr-FR, de-DE).',
    `latitude` DECIMAL(18,2) COMMENT 'Decimal latitude of the geographic centroid of the region in WGS-84 coordinate system. Used for mapping, proximity analysis, and logistics optimisation.',
    `longitude` DECIMAL(18,2) COMMENT 'Decimal longitude of the geographic centroid of the region in WGS-84 coordinate system. Used for mapping, proximity analysis, and logistics optimisation.',
    `manager` STRING COMMENT 'Full name of the senior retail operations manager accountable for this region. Used for escalation routing, performance review, and organisational reporting. Classified confidential as it identifies an internal employee in a named role.',
    `manager_email` STRING COMMENT 'Corporate email address of the region manager. Used for automated alerts, escalation workflows, and operational communications. Classified as confidential PII.',
    `market_maturity` STRING COMMENT 'Assessment of the retail market development stage within the region. Drives investment strategy, promotional intensity, and format mix decisions (e.g., emerging markets favour discount formats).',
    `region_name` STRING COMMENT 'Full human-readable name of the region as used in business reporting and store operations (e.g., North-East, Pacific Rim). Displayed in dashboards, planograms, and territory management tools.',
    `notes` STRING COMMENT 'Free-text field for operational notes, boundary change explanations, or special instructions relevant to this region. Intended for internal use by the store operations and data governance teams.',
    `omnichannel_enabled` BOOLEAN COMMENT 'Indicates whether stores in this region are enabled for omnichannel fulfilment capabilities such as click-and-collect (BOPIS), ship-from-store (SFS), and same-day delivery. True means at least one omnichannel service is live.',
    `population` BIGINT COMMENT 'Estimated total resident population within the region boundary. Sourced from national census or third-party demographic data. Used for market sizing, store count planning, and catchment analysis.',
    `population_reference_year` STRING COMMENT 'The calendar year to which the population figure refers, enabling users to assess data currency and apply appropriate growth adjustments.',
    `region_status` STRING COMMENT 'Current lifecycle status of the region record. active means the region is in use for store assignment and reporting; inactive means it has been decommissioned; pending means it is being set up; archived means it is retained for historical reference only.',
    `region_type` STRING COMMENT 'Categorical classification of the regions primary business purpose. operational covers day-to-day store management; sales covers revenue territory; franchise covers franchisee groupings; distribution covers supply-chain zones; compliance covers regulatory jurisdictions.',
    `regulatory_zone` STRING COMMENT 'Identifier for the regulatory or compliance zone governing retail operations in this region (e.g., EU Single Market, US Federal, APAC Free Trade Zone). Determines applicable labour, food safety, and consumer protection regulations.',
    `short_name` STRING COMMENT 'Abbreviated display name for the region used in space-constrained UI elements, POS terminal screens, and printed reports (e.g., NE Region, SW).',
    `shrink_rate` DECIMAL(18,2) COMMENT 'Retail shrinkage rate for the region expressed as a percentage of net sales, encompassing theft, administrative error, and supplier fraud. Used for loss-prevention benchmarking and security resource allocation.',
    `source_system_code` STRING COMMENT 'Code identifying the upstream operational system from which this region record was sourced (e.g., the retail merchandising system, the store master data system). Used for data lineage and reconciliation.',
    `sss_index` DECIMAL(18,2) COMMENT 'Same-Store Sales (SSS) index for the region, representing the ratio of current-period comparable store sales to the prior-period baseline. A value above 1.0 indicates positive comp sales growth. Used for regional performance benchmarking.',
    `sss_reference_period` STRING COMMENT 'The fiscal period (e.g., FY2023-Q2) used as the baseline for the SSS index calculation. Ensures consistent interpretation of the SSS index across reporting cycles.',
    `store_count` STRING COMMENT 'Number of active retail locations (hypermarkets, department stores, discount outlets, dark stores, MFCs) currently assigned to this region. Maintained as a denormalised reference figure; authoritative count is derived from the store master.',
    `target_store_count` STRING COMMENT 'Planned number of stores to be operating within this region as per the current strategic expansion plan. Used for gap analysis and capital expenditure planning.',
    `tax_jurisdiction_code` STRING COMMENT 'Official tax authority jurisdiction code for the region (e.g., state FIPS code in the USA, HMRC region code in the UK). Used for tax filing, audit, and compliance reporting.',
    `tier` STRING COMMENT 'Strategic importance tier assigned to the region, used to prioritise capital investment, promotional spend, and field support resources. Tier 1 represents highest-priority markets.',
    `timezone` STRING COMMENT 'IANA timezone identifier for the regions primary operating timezone (e.g., Europe/London, America/New_York). Used for scheduling, trading-hour calculations, and timestamp normalisation.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this region record in the data platform. Used for incremental load detection, audit trail, and change data capture (CDC) processing. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `urbanisation_rate` DECIMAL(18,2) COMMENT 'Percentage of the regions population living in urban areas. Influences store format selection (hypermarket vs convenience), omnichannel investment, and last-mile delivery feasibility.',
    `vat_rate` DECIMAL(18,2) COMMENT 'Standard Value Added Tax (VAT) or equivalent sales tax rate applicable in this region, expressed as a percentage. Used for price display, financial reporting, and tax remittance calculations.',
    CONSTRAINT pk_region PRIMARY KEY(`region_id`)
) COMMENT 'Master reference table for region. Referenced by region_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`store`.`location` ADD CONSTRAINT `fk_store_location_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`location` ADD CONSTRAINT `fk_store_location_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`location` ADD CONSTRAINT `fk_store_location_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`format` ADD CONSTRAINT `fk_store_format_parent_format_id` FOREIGN KEY (`parent_format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ADD CONSTRAINT `fk_store_pos_terminal_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ADD CONSTRAINT `fk_store_pos_terminal_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`department` ADD CONSTRAINT `fk_store_department_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ADD CONSTRAINT `fk_store_cluster_parent_cluster_id` FOREIGN KEY (`parent_cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ADD CONSTRAINT `fk_store_cluster_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ADD CONSTRAINT `fk_store_sales_territory_parent_sales_territory_id` FOREIGN KEY (`parent_sales_territory_id`) REFERENCES `vibe_retail_v1`.`store`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ADD CONSTRAINT `fk_store_sales_territory_parent_territory_id` FOREIGN KEY (`parent_territory_id`) REFERENCES `vibe_retail_v1`.`store`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ADD CONSTRAINT `fk_store_sales_territory_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ADD CONSTRAINT `fk_store_sales_territory_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`region` ADD CONSTRAINT `fk_store_region_parent_region_id` FOREIGN KEY (`parent_region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`store` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_retail_v1`.`store` SET TAGS ('dbx_domain' = 'store');
ALTER TABLE `vibe_retail_v1`.`store`.`location` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`location` SET TAGS ('dbx_subdomain' = 'physical_infrastructure');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store Location ID');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Cluster Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `price_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Price Zone Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Store Address Line 1');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Store Address Line 2');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
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
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `email_address` SET TAGS ('dbx_confidential' = 'true');
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
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `phone_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Store Postal Code');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
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
ALTER TABLE `vibe_retail_v1`.`store`.`format` ALTER COLUMN `price_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Price Zone Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `barcode_scanner_type` SET TAGS ('dbx_value_regex' = 'handheld|fixed_mount|presentation|none');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `contactless_enabled` SET TAGS ('dbx_business_glossary_term' = 'Contactless (NFC) Enabled');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `customer_display_type` SET TAGS ('dbx_value_regex' = 'pole_display|integrated_screen|tablet|none');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `ebt_snap_enabled` SET TAGS ('dbx_business_glossary_term' = 'EBT/SNAP Enabled');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `hardware_serial_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{8,30}$');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `hardware_serial_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `ip_address` SET TAGS ('dbx_value_regex' = '^(?:[0-9]{1,3}.){3}[0-9]{1,3}$');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `ip_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `mac_address` SET TAGS ('dbx_value_regex' = '^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `mac_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `mobile_wallet_enabled` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `mobile_wallet_enabled` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `network_zone` SET TAGS ('dbx_value_regex' = 'cardholder_data_environment|corporate_network|guest_network|isolated');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `software_version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `terminal_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,20}$');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `terminal_status` SET TAGS ('dbx_value_regex' = 'active|offline|maintenance|decommissioned|pending_activation|suspended');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `terminal_type` SET TAGS ('dbx_value_regex' = 'staffed_checkout_lane|self_checkout_kiosk|mobile_pos|customer_service_desk|pharmacy_register|express_lane');
ALTER TABLE `vibe_retail_v1`.`store`.`department` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`department` SET TAGS ('dbx_subdomain' = 'physical_infrastructure');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Store Department ID');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `department_status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_construction|seasonal_closed|remodeling|pending_closure');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `gross_margin_target_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `labor_budget_monthly` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `license_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Department Notes');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `planogram_count` SET TAGS ('dbx_business_glossary_term' = 'Planogram (POG) Count');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `pos_terminal_count` SET TAGS ('dbx_business_glossary_term' = 'Point of Sale (POS) Terminal Count');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `sales_target_monthly` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `selling_area_sq_ft` SET TAGS ('dbx_business_glossary_term' = 'Selling Area Square Feet');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `shrinkage_rate_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `temperature_range_max_f` SET TAGS ('dbx_business_glossary_term' = 'Temperature Range Maximum Fahrenheit');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `temperature_range_min_f` SET TAGS ('dbx_business_glossary_term' = 'Temperature Range Minimum Fahrenheit');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `zone_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` SET TAGS ('dbx_subdomain' = 'geographic_organization');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `parent_cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `price_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Price Zone Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `allows_overlap` SET TAGS ('dbx_business_glossary_term' = 'Allows Store Overlap Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `assortment_depth_strategy` SET TAGS ('dbx_value_regex' = 'deep|moderate|shallow|curated');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `average_annual_sales_usd` SET TAGS ('dbx_business_glossary_term' = 'Average Annual Sales (USD)');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `average_annual_sales_usd` SET TAGS ('dbx_confidential' = 'true');
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
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` SET TAGS ('dbx_subdomain' = 'geographic_organization');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ALTER COLUMN `sales_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory Identifier');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ALTER COLUMN `parent_sales_territory_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ALTER COLUMN `postal_code_range_end` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ALTER COLUMN `postal_code_range_end` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ALTER COLUMN `postal_code_range_start` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ALTER COLUMN `postal_code_range_start` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` SET TAGS ('dbx_subdomain' = 'geographic_organization');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `ship_from_store_node_id` SET TAGS ('dbx_business_glossary_term' = 'Ship-from-Store (SFS) Fulfillment Node ID');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `replenishment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_email` SET TAGS ('dbx_business_glossary_term' = 'Contact Email Address');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Contact Phone Number');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `cost_per_order` SET TAGS ('dbx_confidential' = 'true');
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
ALTER TABLE `vibe_retail_v1`.`store`.`region` SET TAGS ('dbx_subdomain' = 'geographic_organization');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Identifier');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `hq_address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `hq_address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `hq_city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `hq_city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `hq_postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `hq_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `manager` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `manager_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `manager_email` SET TAGS ('dbx_pii_email' = 'true');
