-- Schema for Domain: store | Business:  | Version: v2_ecm
-- Generated on: 2026-07-12 09:24:26

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`store` COMMENT 'Manages physical retail locations including hypermarkets, department stores, discount outlets, dark stores, and micro-fulfillment centers (MFC). Owns store master records, planograms (POG), gondola and endcap configurations, footfall metrics, comp sales (SSS - Same-Store Sales), visual merchandising standards, POS terminal inventory, and store-level P&L. Supports store operations and omnichannel fulfillment as ship-from-store nodes.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`location` (
    `location_id` BIGINT COMMENT 'Unique identifier for the physical retail location. Primary key for the store_location data product. This is the system-of-record identifier used across all domains (inventory, order, workforce, finance) to reference this specific store, dark store, or micro-fulfillment center (MFC).',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.store_format. Business justification: Every store location is classified by a store format (hypermarket, discount outlet, department store, etc.). The store_location record currently denormalizes format_type as a STRING. Adding FK to stor',
    `legal_entity_id` BIGINT COMMENT 'add column legal_entity_id (BIGINT) with FK to finance.legal_entity.legal_entity_id - store locations operate under specific legal entities for statutory and tax reporting purposes',
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
    `primary_dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Every store has a primary DC assignment for standard replenishment routing. Fundamental retail supply chain topology required for: replenishment order routing, freight cost allocation, lead time calcu',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`store_planogram` (
    `store_planogram_id` BIGINT COMMENT 'Unique identifier for the store planogram record. Primary key.',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.store_department. Business justification: Planograms are designed for specific departments within a store (e.g., grocery planogram, apparel planogram). The store_planogram record currently denormalizes department_code as a STRING. Adding FK t',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.store_format. Business justification: Planograms are designed for specific store formats because fixture configurations, aisle layouts, and space allocations vary by format. The store_planogram record currently denormalizes store_format a',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Planograms are designed at category/subcategory level (item hierarchy nodes) for template deployment across store formats. Category space allocation planning requires linking planograms to hierarchy n',
    `product_brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Brand blocking is a common merchandising strategy where planograms specify brand placement zones. Vendor-funded brand block compliance programs require tracking which brands are assigned to which plan',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Planograms execute promotional merchandising strategies—retail operations deploy campaign-specific planogram configurations for endcap displays, seasonal sets, and promotional fixtures. Merchandising',
    `approved_by` STRING COMMENT 'Name or identifier of the merchandising manager or category manager who approved this planogram for deployment.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this planogram was approved for deployment. Part of the planogram lifecycle audit trail.',
    `compliance_required_flag` BOOLEAN COMMENT 'Indicates whether strict compliance to this planogram is mandatory (True) or if store-level adjustments are permitted (False). Used for compliance auditing and store operations guidance.',
    `compliance_tolerance_percent` DECIMAL(18,2) COMMENT 'Acceptable variance percentage from the planogram specification before a compliance violation is flagged. Typically 5-10% for facing count or placement accuracy.',
    `compliant_store_count` STRING COMMENT 'Number of stores that are currently in compliance with this planogram based on the most recent audit or compliance check.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this planogram record was first created in the system. Part of the audit trail for planogram lifecycle management.',
    `deployed_store_count` STRING COMMENT 'Number of stores where this planogram has been deployed and is currently active. Used for rollout tracking and compliance monitoring.',
    `effective_end_date` DATE COMMENT 'Date when this planogram is scheduled to be retired or replaced. Nullable for open-ended planograms.',
    `effective_start_date` DATE COMMENT 'Date when this planogram becomes active and should be implemented in applicable stores. Supports seasonal and promotional planogram changes.',
    `facing_count` STRING COMMENT 'Total number of product facings (individual product positions visible to customers) defined in this planogram. Key metric for assortment breadth and shelf capacity.',
    `fixture_count` STRING COMMENT 'Number of physical fixtures (gondolas, endcaps, bays) covered by this planogram. Used for space planning and compliance tracking.',
    `fixture_type` STRING COMMENT 'Type of physical fixture or display unit this planogram is designed for. Gondola = standard shelving unit; Endcap = end-of-aisle display; Wall Bay = wall-mounted shelving. [ENUM-REF-CANDIDATE: gondola|endcap|wall_bay|pallet_display|refrigerated_case|checkout_lane|freestanding — 7 candidates stripped; promote to reference product]',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this planogram record was last updated. Used for change tracking and version control.',
    `max_on_shelf_quantity` STRING COMMENT 'Maximum total quantity of products that can be displayed on the shelf for this planogram. Prevents overstocking and ensures visual merchandising standards.',
    `merchandising_strategy` STRING COMMENT 'Strategic approach used in this planogram layout. Category Dominance = maximize category presence; Brand Blocking = group by brand; Price Point Segmentation = organize by price tier; Cross-Merchandising = complementary products together; Impulse = high-margin impulse items.. Valid values are `category_dominance|brand_blocking|price_point_segmentation|cross_merchandising|impulse`',
    `min_on_shelf_quantity` STRING COMMENT 'Minimum total quantity of products that should be maintained on the shelf for this planogram. Used for replenishment triggers and out-of-stock prevention.',
    `notes` STRING COMMENT 'Free-text notes or comments about this planogram, including special instructions, implementation guidance, or known issues. Used by merchandising and store operations teams.',
    `planogram_code` STRING COMMENT 'Business identifier for the planogram, typically assigned by the merchandising system. Used for external reference and cross-system integration.. Valid values are `^POG-[A-Z0-9]{6,12}$`',
    `planogram_name` STRING COMMENT 'Human-readable name or title of the planogram, describing the fixture, department, or category scope (e.g., Cereal Aisle Endcap Q1 2024, Electronics Gondola Bay 3).',
    `planogram_status` STRING COMMENT 'Current lifecycle status of the planogram. Draft = under development; Approved = ready for deployment; Active = currently in use in stores; Retired = no longer in use; Suspended = temporarily inactive.. Valid values are `draft|approved|active|retired|suspended`',
    `planogram_type` STRING COMMENT 'Classification of the planogram by purpose. Standard = ongoing core assortment; Seasonal = time-bound seasonal layout; Promotional = temporary promotional display; Reset = major category reset; Test = pilot or A/B test layout.. Valid values are `standard|seasonal|promotional|reset|test`',
    `primary_sku_count` STRING COMMENT 'Number of SKUs designated as primary placements (core assortment) in this planogram, excluding promotional or secondary placements.',
    `promotional_sku_count` STRING COMMENT 'Number of SKUs designated as promotional or temporary placements in this planogram. Used for promotional execution tracking.',
    `replenishment_frequency` STRING COMMENT 'Recommended frequency for replenishing products on this planogram. Aligns with inventory management and labor scheduling.. Valid values are `daily|twice_daily|weekly|as_needed|continuous`',
    `shelf_count` STRING COMMENT 'Total number of shelves or levels across all fixtures in this planogram. Used for capacity planning and product placement calculations.',
    `sku_count` STRING COMMENT 'Total number of unique SKUs (Stock Keeping Units) included in this planogram. Measures assortment depth for the fixture or category.',
    `source_system_code` STRING COMMENT 'Unique identifier for this planogram in the source merchandising system. Used for data lineage and cross-system reconciliation.',
    `target_gmroi` DECIMAL(18,2) COMMENT 'Target GMROI (Gross Margin Return on Investment) for this planogram. Measures profitability of the shelf space allocation. Calculated as gross margin divided by average inventory investment.',
    `target_sales_per_linear_foot` DECIMAL(18,2) COMMENT 'Target sales revenue per linear foot of shelf space for this planogram. Key space productivity metric for category management and assortment optimization.',
    `total_linear_feet` DECIMAL(18,2) COMMENT 'Total linear shelf space in feet covered by this planogram. Used for space productivity analysis and category management.',
    `version` STRING COMMENT 'Version number of the planogram, incremented when layout or product placement changes are made. Supports version control and rollback.. Valid values are `^v?[0-9]+.[0-9]+(.[0-9]+)?$`',
    CONSTRAINT pk_store_planogram PRIMARY KEY(`store_planogram_id`)
) COMMENT 'Master record for store planograms (POGs) defining the approved shelf layout and product placement strategy for a given fixture, department, or store format. Captures POG ID, name, version, effective date range, format applicability, department/category scope, fixture count, facing count, POG status (draft, approved, active, retired), and source merchandising system reference. Includes granular shelf position details: fixture/shelf/facing assignments, SKU placements, position types (primary, secondary, promotional endcap), min/max on-shelf quantities, substitution SKUs, and per-position compliance flags. Planograms are the authoritative visual merchandising execution record linking store operations to category management strategy. Owned by the store domain as the execution record; strategy originates in merchandising.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`fixture` (
    `fixture_id` BIGINT COMMENT 'Unique identifier for the store fixture. Primary key.',
    `creative_asset_id` BIGINT COMMENT 'Foreign key linking to marketing.creative_asset. Business justification: In-store fixtures display marketing creative assets (signage, endcap graphics, promotional materials). Visual merchandising operations track which creative is deployed on which fixture for campaign co',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.store_department. Business justification: Fixtures are physically located within store departments. The fixture record currently denormalizes department_code as a STRING. Adding FK to store_department allows joining to get department_name, de',
    `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Store fixtures (gondolas, refrigeration units, shelving) are capitalized fixed assets requiring depreciation tracking and asset register maintenance—GAAP requirement for property, plant & equipment ac',
    `location_id` BIGINT COMMENT 'Identifier of the retail store location where this fixture is currently assigned. Links to the store master record.',
    `merchandising_planogram_id` BIGINT COMMENT 'Identifier of the current planogram (POG - shelf layout diagram) assigned to this fixture. Links to the planogram master record for product placement instructions.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Individual fixtures are assigned to promotional campaigns—retailers allocate endcaps, promotional tables, and seasonal displays to specific campaigns. Visual merchandising and store operations teams t',
    `store_planogram_id` BIGINT COMMENT 'Foreign key linking to store.store_planogram. Business justification: Physical store fixtures (gondolas, endcaps) are placed and configured according to store planograms. Adding store_planogram_id -> store.store_planogram.store_planogram_id links each fixture to the pla',
    `vendor_id` BIGINT COMMENT 'Identifier of the vendor or supplier from whom the fixture was purchased. Links to the supplier master record for procurement history and vendor performance tracking.',
    `ada_compliant_flag` BOOLEAN COMMENT 'Indicates whether the fixture meets ADA accessibility requirements for height, reach range, and clearance. True indicates compliant, false indicates non-compliant or exempted.',
    `adjustable_shelves_flag` BOOLEAN COMMENT 'Indicates whether the fixture has adjustable shelf heights. True enables flexible merchandising for varying product sizes, false indicates fixed shelf positions.',
    `aisle_number` STRING COMMENT 'Aisle identifier where the fixture is positioned within the store. Used for store navigation, planogram assignment, and customer wayfinding.',
    `bay_position` STRING COMMENT 'Specific bay or section position within the aisle (e.g., Bay 1, Bay 2). Provides granular location tracking for planogram compliance and inventory audits.',
    `fixture_category` STRING COMMENT 'Categorization of the fixture based on its intended duration and purpose. Permanent fixtures are long-term store infrastructure, seasonal fixtures support recurring seasonal merchandising, promotional fixtures are used for short-term campaigns, and temporary fixtures are ad-hoc displays.. Valid values are `permanent|seasonal|promotional|temporary`',
    `fixture_code` STRING COMMENT 'Business identifier code for the fixture, used for asset tracking and inventory management. Typically alphanumeric code assigned by merchandising or facilities team.. Valid values are `^[A-Z0-9]{8,20}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this fixture record was first created in the system. Used for data lineage and audit trail.',
    `depth_inches` DECIMAL(18,2) COMMENT 'Depth of the fixture measured in inches. Important for aisle width planning, product capacity calculation, and customer navigation.',
    `digital_display_flag` BOOLEAN COMMENT 'Indicates whether the fixture includes digital signage or electronic shelf labels (ESL) for dynamic pricing and promotions. True indicates digital capability, false indicates traditional static signage.',
    `finish_color` STRING COMMENT 'Color or finish of the fixture exterior (e.g., white, black, chrome, wood grain). Used for visual merchandising consistency and brand alignment across store fleet.',
    `fixture_status` STRING COMMENT 'Current lifecycle status of the fixture. Active indicates in-use and operational, inactive indicates temporarily not in use, maintenance indicates undergoing repair or refurbishment, retired indicates permanently removed from service, damaged indicates requiring repair, and pending installation indicates purchased but not yet deployed.. Valid values are `active|inactive|maintenance|retired|damaged|pending_installation`',
    `fixture_type` STRING COMMENT 'Classification of the fixture by its primary merchandising function. Gondola refers to standard shelving units, endcap to end-of-aisle displays, cooler/freezer to refrigerated cases, pegboard to hanging merchandise panels, display table to promotional tables, checkout lane to POS area fixtures, shelf unit to standalone shelving, and rack to hanging garment fixtures. [ENUM-REF-CANDIDATE: gondola|endcap|cooler|freezer|pegboard|display_table|checkout_lane|shelf_unit|rack — 9 candidates stripped; promote to reference product]',
    `height_inches` DECIMAL(18,2) COMMENT 'Height of the fixture measured in inches. Critical for vertical space utilization, sight line planning, and compliance with accessibility standards.',
    `installation_date` DATE COMMENT 'Date the fixture was installed in its current store location. Used for age tracking, depreciation calculation, and maintenance scheduling.',
    `last_refurbishment_date` DATE COMMENT 'Date of the most recent refurbishment, repair, or significant maintenance performed on the fixture. Null if never refurbished since installation.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this fixture record was most recently modified. Used for change tracking and data quality monitoring.',
    `lighting_integrated_flag` BOOLEAN COMMENT 'Indicates whether the fixture has built-in lighting to highlight merchandise. True indicates integrated lighting system, false indicates no built-in lighting.',
    `manufacturer_name` STRING COMMENT 'Name of the company that manufactured the fixture. Used for warranty tracking, parts sourcing, and vendor performance analysis.',
    `material_composition` STRING COMMENT 'Primary materials used in fixture construction (e.g., steel, wood, laminate, glass, acrylic). Impacts durability, maintenance requirements, and aesthetic alignment with store design.',
    `mobility_type` STRING COMMENT 'Indicates whether the fixture is permanently installed (fixed), easily movable (mobile with casters), or requires tools to relocate (semi-mobile). Impacts flexibility for store resets and seasonal merchandising changes.. Valid values are `fixed|mobile|semi_mobile`',
    `model_number` STRING COMMENT 'Manufacturers model or part number for the fixture. Critical for ordering replacement parts, warranty claims, and standardization across stores.',
    `next_maintenance_date` DATE COMMENT 'Planned date for the next preventive maintenance or inspection. Used for maintenance scheduling and compliance with safety standards.',
    `notes` STRING COMMENT 'Free-text field for additional comments, special handling instructions, maintenance history notes, or other relevant information about the fixture.',
    `power_required_flag` BOOLEAN COMMENT 'Indicates whether the fixture requires electrical power for operation (e.g., refrigeration, lighting, digital displays). True requires power connection, false indicates passive fixture.',
    `purchase_order_number` STRING COMMENT 'Purchase order number under which the fixture was procured. Used for procurement audit trail and invoice reconciliation.',
    `refrigeration_type` STRING COMMENT 'Temperature control classification for the fixture. Ambient indicates no refrigeration, chilled indicates 32-40°F range for dairy and produce, frozen indicates below 0°F for frozen foods, multi-temp indicates multiple temperature zones, and none indicates non-refrigerated fixtures.. Valid values are `ambient|chilled|frozen|multi_temp|none`',
    `rfid_enabled_flag` BOOLEAN COMMENT 'Indicates whether the fixture is equipped with RFID readers for automated inventory tracking and shrinkage prevention. True indicates RFID capability, false indicates no RFID integration.',
    `security_features` STRING COMMENT 'Description of anti-theft or security features integrated into the fixture (e.g., locking doors, security hooks, EAS tag compatibility, camera integration). Used for shrinkage prevention and loss prevention planning.',
    `serial_number` STRING COMMENT 'Manufacturer-assigned unique serial number for the individual fixture unit. Used for warranty claims, theft recovery, and precise asset tracking.',
    `shelf_count` STRING COMMENT 'Number of shelves or display levels on the fixture. Used for capacity planning and planogram assignment. Null for fixtures without shelves (e.g., pegboards, hanging racks).',
    `weight_capacity_lbs` DECIMAL(18,2) COMMENT 'Maximum weight load the fixture can safely support, measured in pounds. Critical for safety compliance and preventing structural failure when merchandising heavy products.',
    `width_inches` DECIMAL(18,2) COMMENT 'Width of the fixture measured in inches. Used for space planning, planogram design, and store layout optimization.',
    CONSTRAINT pk_fixture PRIMARY KEY(`fixture_id`)
) COMMENT 'Master record for physical store fixtures including gondolas (shelving units), endcaps (end-of-aisle displays), cooler/freezer cases, pegboard panels, display tables, and checkout lane fixtures. Captures fixture ID, fixture type, manufacturer, model number, dimensions (width, height, depth), number of shelves, adjustable shelf flag, refrigeration type (ambient, chilled, frozen), installation date, last refurbishment date, assigned store location, assigned department/zone, and current planogram assignment. Supports visual merchandising planning, maintenance scheduling, and capital asset tracking.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`traffic_count` (
    `traffic_count_id` BIGINT COMMENT 'Primary key for traffic_count',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Campaign effectiveness measured via foot traffic lift analysis. Retail analytics attribute in-store traffic increases to marketing campaigns for ROI calculation and media mix optimization. Core market',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.department. Business justification: Traffic counts are measured at store entrances AND internal zones (counting_zone_code, zone_type columns exist). When a counting zone corresponds to a store department, linking department_id -> store.',
    `kpi_value_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_value. Business justification: Footfall metrics (conversion rate, dwell time, peak occupancy) are KPIs calculated from traffic_count data for customer analytics. Store operations and marketing teams track these metrics in performan',
    `location_id` BIGINT COMMENT 'Identifier of the retail location where the traffic count was measured. Links to the store master record.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Footfall measurement during promotional periods quantifies campaign-driven traffic—retailers tag traffic counts to campaigns for incremental traffic attribution. Store operations and marketing analyti',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`comparable_sales` (
    `comparable_sales_id` BIGINT COMMENT 'Primary key for comparable_sales',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Comp sales analysis by campaign measures promotional lift and marketing ROI. Retail finance and marketing teams require campaign attribution for sales variance analysis, budget justification, and prom',
    `cluster_id` BIGINT COMMENT 'Foreign key linking to store.cluster. Business justification: Comparable store sales (SSS) analysis is a core retail KPI that is routinely performed at cluster level — comparing performance of stores within the same cluster. comparable_sales already has location',
    `financial_period_id` BIGINT COMMENT 'Foreign key linking to finance.financial_period. Business justification: Comp sales reporting requires alignment to fiscal periods for year-over-year variance analysis, investor reporting, and same-store sales metrics—standard retail financial reporting process tied to fis',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.store_format. Business justification: Comparable sales records currently denormalize store_format as a STRING. Adding FK to store_format product allows joining to get format_code, format_name, format_description, format_type, size_band_mi',
    `kpi_value_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_value. Business justification: Comp sales is a primary retail KPI; each comparable_sales record represents a kpi_value instance for comp_sales_growth_rate KPI. Direct semantic relationship for investor reporting and operational per',
    `location_id` BIGINT COMMENT 'Identifier of the retail store location for which comparable sales are being reported. Links to the store master record.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Comparable sales analysis isolates promotional campaign impact—finance and merchandising teams attribute sales lifts and traffic increases to specific campaigns. Comp sales reporting by campaign enabl',
    `region_id` BIGINT COMMENT 'Foreign key linking to store.region. Business justification: comparable_sales has reporting_region as a STRING column (denormalized). Adding region_id -> store.region.region_id provides a proper FK to the region master for geographic rollup of comp sales perfor',
    `department_id` BIGINT COMMENT 'add column store_department_id (BIGINT) with FK to store.department.department_id - comp sales are analyzed at department level in addition to store level',
    `closure_days` STRING COMMENT 'Number of days the store was closed during the reporting period. Used to adjust comp sales calculations for partial-period operations.',
    `closure_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether the store was temporarily closed for any portion of the reporting period (e.g., due to weather, emergency, renovation). Impacts comp sales qualification and interpretation.',
    `comp_sales_growth_rate` DECIMAL(18,2) COMMENT 'The year-over-year growth rate of comparable store sales expressed as a percentage. Synonymous with comp_sales_variance_percent but emphasizes growth perspective. Key performance indicator for executive reporting.',
    `comp_sales_variance_amount` DECIMAL(18,2) COMMENT 'The absolute dollar variance between current period net sales and prior period net sales. Calculated as current_period_net_sales minus prior_period_net_sales.',
    `comp_sales_variance_percent` DECIMAL(18,2) COMMENT 'The percentage variance between current period net sales and prior period net sales. Calculated as ((current_period_net_sales - prior_period_net_sales) / prior_period_net_sales) * 100. Primary metric for store performance evaluation.',
    `comp_store_qualification_status` STRING COMMENT 'Indicates whether the store qualifies for inclusion in comparable sales (SSS - Same-Store Sales) reporting for this period. Typically requires the store to have been open for a minimum qualifying period (e.g., 13+ months) and not have undergone significant remodeling or format changes.. Valid values are `qualified|not_qualified|pending_review`',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this record (e.g., USD, EUR, GBP). Ensures consistent currency interpretation for multi-currency retail operations.. Valid values are `^[A-Z]{3}$`',
    `current_period_atv` DECIMAL(18,2) COMMENT 'Average Transaction Value (ATV) for the current reporting period. Calculated as current_period_net_sales divided by current_period_transaction_count. Measures the average dollar amount spent per transaction.',
    `current_period_conversion_rate` DECIMAL(18,2) COMMENT 'Conversion Rate (CR) for the current reporting period. Calculated as (current_period_transaction_count / current_period_footfall) * 100. Measures the percentage of store visitors who complete a purchase.',
    `current_period_footfall` BIGINT COMMENT 'Total number of customer visits (store traffic count) during the current reporting period. Measured via traffic counters at store entrances. Used to calculate conversion rate.',
    `current_period_net_sales` DECIMAL(18,2) COMMENT 'Total net sales revenue for the store during the current reporting period, after returns, discounts, and allowances. Represents the actual sales performance for the period.',
    `current_period_transaction_count` BIGINT COMMENT 'Total number of completed Point of Sale (POS) transactions at the store during the current reporting period. Used to calculate Average Transaction Value (ATV).',
    `current_period_units_sold` BIGINT COMMENT 'Total number of product units (SKUs) sold at the store during the current reporting period. Used to calculate Units Per Transaction (UPT).',
    `current_period_upt` DECIMAL(18,2) COMMENT 'Units Per Transaction (UPT) for the current reporting period. Calculated as current_period_units_sold divided by current_period_transaction_count. Measures the average number of items purchased per transaction.',
    `data_source_system` STRING COMMENT 'The name of the source system from which this comparable sales record was extracted (e.g., SAP S/4HANA FI/CO, the retail merchandising system Merchandising System, SAP Customer Activity Repository). Used for data lineage and reconciliation.',
    `fiscal_period` STRING COMMENT 'The fiscal period number within the fiscal year (e.g., 1-12 for months, 1-4 for quarters) to which this comparable sales record belongs.',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this comparable sales record belongs, used for financial planning and reporting alignment.',
    `months_in_operation` STRING COMMENT 'The number of complete months the store has been in operation as of the end of the current reporting period. Used to determine comp store qualification (typically 13+ months required).',
    `prior_period_atv` DECIMAL(18,2) COMMENT 'Average Transaction Value (ATV) for the comparable prior period. Used as baseline for ATV performance comparison.',
    `prior_period_conversion_rate` DECIMAL(18,2) COMMENT 'Conversion Rate (CR) for the comparable prior period. Used as baseline for conversion rate performance comparison.',
    `prior_period_footfall` BIGINT COMMENT 'Total number of customer visits (store traffic count) during the comparable prior period. Used for year-over-year footfall comparison.',
    `prior_period_net_sales` DECIMAL(18,2) COMMENT 'Total net sales revenue for the store during the comparable prior period (same period in the previous year), after returns, discounts, and allowances. Used as the baseline for comp sales calculation.',
    `prior_period_transaction_count` BIGINT COMMENT 'Total number of completed Point of Sale (POS) transactions at the store during the comparable prior period. Used for year-over-year transaction count comparison.',
    `prior_period_units_sold` BIGINT COMMENT 'Total number of product units (SKUs) sold at the store during the comparable prior period. Used for year-over-year unit sales comparison.',
    `prior_period_upt` DECIMAL(18,2) COMMENT 'Units Per Transaction (UPT) for the comparable prior period. Used as baseline for UPT performance comparison.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this comparable sales record was first created in the system. Follows yyyy-MM-ddTHH:mm:ss.SSSXXX format. Used for audit trail and data lineage tracking.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this comparable sales record was last modified in the system. Follows yyyy-MM-ddTHH:mm:ss.SSSXXX format. Used for audit trail and change tracking.',
    `remodel_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether the store underwent significant remodeling or format change during or immediately prior to the reporting period. Stores with recent remodels may be excluded from comp sales calculations.',
    `reporting_district` STRING COMMENT 'The district or sub-region to which this store belongs within the reporting region. Used for district-level comp sales aggregation and performance management.',
    `reporting_period_end_date` DATE COMMENT 'The last day of the reporting period for which comparable sales are being measured. Follows yyyy-MM-dd format.',
    `reporting_period_start_date` DATE COMMENT 'The first day of the reporting period for which comparable sales are being measured. Follows yyyy-MM-dd format.',
    `reporting_period_type` STRING COMMENT 'The granularity of the reporting period for this comparable sales record (week, month, quarter, or year).. Valid values are `week|month|quarter|year`',
    `sales_per_sqft` DECIMAL(18,2) COMMENT 'Current period net sales divided by store size in square feet. Key productivity metric measuring revenue efficiency per unit of retail space.',
    `store_number` STRING COMMENT 'Business-facing store number or code used for operational identification and reporting. Human-readable identifier for the store.',
    `store_open_date` DATE COMMENT 'The date the store first opened for business. Used to determine eligibility for comparable sales reporting based on minimum operating period requirements.',
    `store_size_sqft` STRING COMMENT 'The total retail floor space of the store in square feet. Used for sales per square foot analysis and store productivity metrics.',
    CONSTRAINT pk_comparable_sales PRIMARY KEY(`comparable_sales_id`)
) COMMENT 'Periodic comparable store sales (SSS — Same-Store Sales) record tracking revenue performance of stores that have been open for a qualifying period (typically 13+ months). Captures store location, reporting period (week, month, quarter), total net sales, prior-period net sales, comp sales variance ($ and %), comp sales growth rate (%), transaction count, ATV (Average Transaction Value), UPT (Units Per Transaction), and comp store qualification status. This is the primary store-level financial performance signal used by finance, merchandising, and executive reporting.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`shrinkage_event` (
    `shrinkage_event_id` BIGINT COMMENT 'Unique identifier for the shrinkage event record. Primary key.',
    `adjustment_id` BIGINT COMMENT 'Identifier of the inventory adjustment transaction in the WMS or ERP system that recorded the shrinkage loss. Links to the inventory adjustment ledger.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: High-value promotional items tracked for shrinkage during campaign periods. Loss prevention analyzes shrinkage patterns by campaign to identify theft risks associated with promotional displays and hig',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.store_department. Business justification: Shrinkage events (theft, damage, spoilage) occur in specific departments within a store. The shrinkage_event record currently denormalizes department_code as a STRING. Adding FK to store_department al',
    `dq_issue_id` BIGINT COMMENT 'Foreign key linking to analytics.dq_issue. Business justification: Shrinkage data quality issues (missing events, duplicate scans, value anomalies) are tracked as dq_issue records for loss prevention data governance. AP teams investigate data integrity problems affec',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Shrinkage losses post to specific GL accounts (inventory shrink expense, theft loss) for financial statement impact and COGS accuracy—required for inventory valuation and P&L reporting.',
    `location_id` BIGINT COMMENT 'Identifier of the retail location where the shrinkage event occurred. Links to the store master record.',
    `associate_id` BIGINT COMMENT 'Identifier of the employee involved in or responsible for the shrinkage event (for internal theft or administrative error cases). Confidential and used only for internal investigations.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Promotional periods see elevated shrinkage due to high traffic, promotional displays, and temporary merchandising—loss prevention teams track shrinkage by campaign. AP and operations teams analyze cam',
    `rma_id` BIGINT COMMENT 'Foreign key linking to returns.rma. Business justification: Shrinkage events frequently originate from fraudulent returns (empty box returns, receipt fraud, wardrobing, return of stolen merchandise). LP teams link shrinkage events to specific RMAs for loss att',
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
    `associate_id` BIGINT COMMENT 'Reference to the employee assigned as the department manager responsible for operations, staffing, and performance.',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Department managers execute category-level merchandising strategies. Real business process: departments track category performance targets, space allocation, assortment compliance, and GMROI against c',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Store departments map to merchandise categories (item hierarchy). Department managers are responsible for specific categories. Essential for departmental P&L reporting by category and category manager',
    `location_id` BIGINT COMMENT 'Reference to the parent store location where this department is physically located.',
    `marketing_brand_id` BIGINT COMMENT 'Foreign key linking to marketing.marketing_brand. Business justification: Departments organized by brand (brand shops, licensed departments, brand-in-store concepts). Retail operations track brand ownership of departments for brand partnership agreements, co-op marketing, s',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`remodel` (
    `remodel_id` BIGINT COMMENT 'Unique identifier for the store remodel project record. Primary key for the store remodel entity.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Store remodels trigger grand re-opening campaigns, promotional events, and customer communication programs. Marketing operations require linking remodel projects to campaigns for budget allocation, cr',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor. Business justification: Remodel projects are executed by general contractors who are vendors. Linking the contractor vendor enables payment processing via AP, warranty claim tracking, contractor performance evaluation, and p',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Remodel project expenses charge to cost centers for capital budget tracking, variance reporting, and project accounting—standard practice for monitoring capital expenditure against approved budgets in',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.department. Business justification: Store remodels are scoped to specific departments (e.g., grocery reset, apparel department renovation). remodel currently has impacted_departments as a STRING (denormalized list). Adding department_id',
    `fixed_asset_id` BIGINT COMMENT 'Foreign key linking to finance.fixed_asset. Business justification: Capital remodels create or modify fixed assets requiring capitalization, depreciation tracking, and asset register updates—mandatory for GAAP compliance and property, plant & equipment accounting in r',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Store remodels are often launched with grand reopening promotional campaigns—retailers coordinate remodel completion with campaign timing for maximum traffic impact. Real estate and marketing teams tr',
    `location_id` BIGINT COMMENT 'Identifier of the retail location undergoing remodel. Links to the store master record.',
    `merchandising_planogram_id` BIGINT COMMENT 'Foreign key linking to merchandising.planogram. Business justification: Remodel projects specify which planograms will be deployed post-renovation. Real business process: capital project planning documents target planogram sets for new fixture layouts, enabling merchandis',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.store_format. Business justification: Store remodels may involve format changes (e.g., converting a discount outlet to a hypermarket). The store_remodel record currently denormalizes previous_format as a STRING. Adding FK to store_format',
    `actual_completion_date` DATE COMMENT 'Actual date when remodel project was completed, final inspections passed, and store reopened for business. Used for project closeout and performance measurement.',
    `actual_spend_amount` DECIMAL(18,2) COMMENT 'Cumulative actual expenditure incurred on the remodel project to date. Tracked against capital budget for variance analysis and financial reporting. Denominated in USD.',
    `actual_start_date` DATE COMMENT 'Actual date when remodel construction or renovation work commenced. Used for project performance tracking and variance analysis.',
    `approval_date` DATE COMMENT 'Date when the remodel project received formal capital budget approval and authorization to proceed. Used for financial period tracking and capital planning reporting.',
    `approved_by` STRING COMMENT 'Name or identifier of the executive or approving authority who authorized the remodel project and capital budget allocation.',
    `capital_budget_amount` DECIMAL(18,2) COMMENT 'Approved capital expenditure budget allocated for the remodel project. Includes construction, fixtures, equipment, and technology costs. Denominated in USD.',
    `closure_end_date` DATE COMMENT 'Date when the store reopens to customers after remodel completion. Null if store remains open during remodel. Used to calculate closure duration and resume comp sales tracking.',
    `closure_start_date` DATE COMMENT 'Date when the store temporarily closes to customers for remodel work. Null if store remains open during remodel. Critical for comp sales (SSS) exclusion logic.',
    `comp_sales_exclusion_flag` BOOLEAN COMMENT 'Indicates whether this store should be excluded from Same-Store Sales (SSS) or Comparable Store Sales (Comp Sales) calculations during the remodel period. True means exclude from comp sales; false means include. Stores under significant remodel are typically excluded to avoid distorting performance metrics.',
    `contractor_reference_number` STRING COMMENT 'External reference identifier or contract number assigned by the contractor for this remodel project. Used for invoice reconciliation and vendor coordination.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this remodel project record was first created in the system. Used for audit trail and data lineage tracking.',
    `format_change_flag` BOOLEAN COMMENT 'Indicates whether the remodel includes a change in store format or concept (e.g., converting from discount format to hypermarket, or introducing new department layouts). True means format conversion; false means format unchanged.',
    `inspection_completion_date` DATE COMMENT 'Date when final building inspections and occupancy certifications were completed and approved by local authorities. Required before store can reopen to customers.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this remodel project record was last updated. Used for audit trail, change tracking, and data synchronization.',
    `new_fixture_count` STRING COMMENT 'Total number of new fixtures (gondolas, endcaps, display units) installed during the remodel. Used for asset tracking and visual merchandising planning.',
    `new_format` STRING COMMENT 'Store format or concept classification after the remodel (e.g., hypermarket, discount store, department store, neighborhood market). Null if no format change occurred.',
    `notes` STRING COMMENT 'Free-text field for additional project notes, special considerations, lessons learned, or operational remarks related to the remodel execution.',
    `permit_number` STRING COMMENT 'Government-issued building permit or construction permit number required for the remodel work. Used for regulatory compliance and inspection tracking.',
    `planned_start_date` DATE COMMENT 'Scheduled date when remodel construction or renovation work is planned to begin. Used for resource planning and store operations scheduling.',
    `project_manager_name` STRING COMMENT 'Name of the internal project manager or capital projects lead responsible for overseeing the remodel execution, vendor coordination, and budget management.',
    `project_number` STRING COMMENT 'Business-facing unique identifier for the remodel project, used for tracking and reporting across finance, operations, and capital planning systems.. Valid values are `^[A-Z0-9]{8,20}$`',
    `project_status` STRING COMMENT 'Current lifecycle state of the remodel project. Planned indicates initial scoping; approved means budget allocated; in-progress indicates active construction; completed means project closed and store reopened; cancelled means project terminated; on-hold indicates temporary suspension.. Valid values are `planned|approved|in_progress|completed|cancelled|on_hold`',
    `projected_completion_date` DATE COMMENT 'Forecasted date when remodel project is expected to be completed and store reopened. Updated throughout project lifecycle based on progress.',
    `remodel_type` STRING COMMENT 'Classification of the remodel scope. Full remodel involves comprehensive store renovation; department refresh targets specific categories; fixture replacement updates gondolas, endcaps, and shelving; technology upgrade installs new POS, digital signage, or self-checkout; accessibility improvement ensures ADA compliance; format conversion changes store concept or layout.. Valid values are `full_remodel|department_refresh|fixture_replacement|technology_upgrade|accessibility_improvement|format_conversion`',
    `roi_projection_percent` DECIMAL(18,2) COMMENT 'Projected return on investment percentage for the remodel project, calculated during capital planning. Represents expected incremental sales lift or cost savings as a percentage of capital investment.',
    `square_footage_change` STRING COMMENT 'Net change in store selling square footage resulting from the remodel. Positive values indicate expansion; negative values indicate reduction. Zero indicates no size change. Measured in square feet.',
    `sustainability_features` STRING COMMENT 'Comma-separated list of sustainability or environmental improvements included in the remodel (e.g., LED lighting, energy-efficient HVAC, solar panels, water conservation fixtures, recycled materials, LEED certification).',
    `technology_upgrades` STRING COMMENT 'Comma-separated list of technology systems upgraded or installed during remodel (e.g., POS terminals, self-checkout kiosks, digital signage, RFID readers, electronic shelf labels, mobile POS).',
    `temporary_closure_flag` BOOLEAN COMMENT 'Indicates whether the store will be temporarily closed to customers during the remodel period. True means full closure; false means store remains open with partial operations.',
    CONSTRAINT pk_remodel PRIMARY KEY(`remodel_id`)
) COMMENT 'Project record tracking store remodel, renovation, and capital improvement initiatives. Captures remodel project ID, store location, remodel type (full remodel, department refresh, fixture replacement, technology upgrade, accessibility improvement), project start date, projected completion date, actual completion date, capital budget, actual spend, contractor reference, impacted departments, temporary closure flag, closure start/end dates, and remodel status (planned, in-progress, completed, cancelled). Supports capital planning, comp sales exclusion logic (stores under remodel are excluded from SSS), and store format upgrade tracking.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`cluster` (
    `cluster_id` BIGINT COMMENT 'Unique identifier for the store cluster. Primary key.',
    `loyalty_program_id` BIGINT COMMENT 'Foreign key linking to loyalty.loyalty_program. Business justification: Store clusters drive differentiated loyalty strategies (tier thresholds, reward catalogs, campaign targeting). Retail operations align loyalty program rules to cluster segmentation for localized membe',
    `parent_cluster_id` BIGINT COMMENT 'Reference to a parent cluster if this cluster is part of a hierarchical clustering structure (e.g., sub-clusters within a regional cluster). Null for top-level clusters.',
    `reporting_hierarchy_id` BIGINT COMMENT 'Foreign key linking to analytics.reporting_hierarchy. Business justification: Store clusters form reporting hierarchies (cluster → region → division) for aggregated performance reporting. Corporate reporting requires hierarchical rollup of store performance through cluster stru',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`audit` (
    `audit_id` BIGINT COMMENT 'Unique identifier for the store audit record. Primary key.',
    `associate_id` BIGINT COMMENT 'Identifier of the individual or system that conducted the audit. May be employee ID, contractor ID, inspector badge number, or system identifier.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Audit findings result in corrective action expenses (remediation, fines, training) charged to cost centers for accountability tracking and budget impact analysis—standard operational expense allocatio',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.department. Business justification: Store audits (food safety, compliance, operational) are frequently scoped to specific departments (e.g., deli, pharmacy, produce). Adding department_id -> store.department.department_id allows audit r',
    `dq_result_id` BIGINT COMMENT 'Foreign key linking to analytics.dq_result. Business justification: Store audits validate data quality (inventory accuracy, price accuracy); audit results map to dq_result records for compliance reporting. Regulatory audits and internal controls require linking audit',
    `location_id` BIGINT COMMENT 'Identifier of the retail location where the audit was conducted. Links to the store master record.',
    `merchandising_planogram_id` BIGINT COMMENT 'Foreign key linking to merchandising.planogram. Business justification: Visual merchandising audits verify planogram compliance. Real business process: field teams audit stores against specific planogram versions, scoring fixture execution, shelf positioning, and facing c',
    `previous_audit_id` BIGINT COMMENT 'Identifier of the previous audit of the same type conducted at this store, enabling trend analysis. Null for first audit.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Store audits verify promotional execution compliance—auditors inspect campaign-specific signage, pricing accuracy, display placement, and terms disclosure. Loss prevention and compliance teams scope a',
    `return_fraud_case_id` BIGINT COMMENT 'Foreign key linking to returns.return_fraud_case. Business justification: Loss prevention and asset protection audits directly generate or reference fraud cases when discovering return abuse, organized retail crime, or policy violations. Auditors document fraud case numbers',
    `rma_id` BIGINT COMMENT 'Foreign key linking to returns.rma. Business justification: Store audits (compliance, LP, operational) frequently reference specific RMAs when documenting return processing violations, refund authorization gaps, or fraud patterns discovered during audit. Audit',
    `audit_date` DATE COMMENT 'Date on which the audit was conducted at the store location.',
    `audit_number` STRING COMMENT 'Externally-known unique business identifier for the audit, formatted as AUD-YYYYMMDD-XXXXXX.. Valid values are `^AUD-[0-9]{8}-[A-Z0-9]{6}$`',
    `audit_type` STRING COMMENT 'Category of audit conducted: food safety (FDA/FSMA), loss prevention (shrinkage), planogram compliance (POG), health and safety (OSHA), accessibility (ADA), fire code, brand standards, environmental compliance, operational excellence, or regulatory inspection. [ENUM-REF-CANDIDATE: food_safety|loss_prevention|planogram_compliance|health_safety|accessibility|fire_code|brand_standards|environmental_compliance|operational_excellence|regulatory_inspection — 10 candidates stripped; promote to reference product]',
    `auditor_name` STRING COMMENT 'Full name of the auditor or system that performed the audit.',
    `auditor_type` STRING COMMENT 'Classification of the entity that performed the audit: internal LP (Loss Prevention) team, third-party auditor, regulatory inspector (FDA/OSHA/fire marshal), automated image recognition system, district manager, or corporate compliance team.. Valid values are `internal_lp_team|third_party_auditor|regulatory_inspector|automated_system|district_manager|corporate_compliance`',
    `citation_issued_flag` BOOLEAN COMMENT 'Boolean flag indicating whether a formal citation, violation notice, or warning letter was issued by a regulatory agency.',
    `closed_timestamp` TIMESTAMP COMMENT 'Timestamp when the audit and all corrective actions were verified complete and the audit was formally closed. Null if still open.',
    `corrective_action_due_date` DATE COMMENT 'Target date by which all corrective actions must be completed and verified. Null if no corrective action is required.',
    `corrective_action_required_flag` BOOLEAN COMMENT 'Boolean flag indicating whether a formal corrective action plan (CAP) is required based on audit findings.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this audit record was first created in the system.',
    `critical_findings_count` STRING COMMENT 'Number of critical findings that pose immediate risk to safety, compliance, or brand reputation and require urgent corrective action.',
    `district_manager_notified_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the district manager was formally notified of the audit results.',
    `end_time` TIMESTAMP COMMENT 'Timestamp when the audit fieldwork was completed at the store.',
    `fine_amount` DECIMAL(18,2) COMMENT 'Monetary fine or penalty amount assessed by regulatory agency in USD. Null if no fine was issued.',
    `fiscal_quarter` STRING COMMENT 'Fiscal quarter in which the audit was conducted (Q1, Q2, Q3, Q4).. Valid values are `Q1|Q2|Q3|Q4`',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the audit was conducted, enabling period-based reporting and trend analysis.',
    `follow_up_audit_date` DATE COMMENT 'Scheduled date for the follow-up audit to verify corrective actions. Null if no follow-up is required.',
    `follow_up_audit_required_flag` BOOLEAN COMMENT 'Boolean flag indicating whether a follow-up audit is required to verify corrective action completion.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this audit record was last updated in the system.',
    `major_findings_count` STRING COMMENT 'Number of major findings that represent significant non-compliance but do not pose immediate critical risk.',
    `minor_findings_count` STRING COMMENT 'Number of minor findings or observations that represent opportunities for improvement but do not constitute material non-compliance.',
    `overall_score_percent` DECIMAL(18,2) COMMENT 'Overall audit score expressed as a percentage (0.00 to 100.00), representing the stores compliance level across all audited items.',
    `pass_fail_status` STRING COMMENT 'Overall pass/fail determination for the audit based on scoring thresholds and critical findings.. Valid values are `pass|fail|conditional_pass|pending_review`',
    `photographic_evidence_count` STRING COMMENT 'Number of photographs or images captured during the audit to document findings and conditions.',
    `previous_audit_score_percent` DECIMAL(18,2) COMMENT 'Overall score from the previous audit of the same type, enabling period-over-period comparison. Null for first audit.',
    `regulatory_agency` STRING COMMENT 'Name of the regulatory agency that conducted the inspection (e.g., FDA, OSHA, Local Fire Marshal, Health Department). Null for internal audits.',
    `regulatory_case_number` STRING COMMENT 'Official case or inspection number assigned by the regulatory agency. Null for internal audits.',
    `report_url` STRING COMMENT 'URL or file path to the detailed audit report document stored in the document management system.',
    `resolution_status` STRING COMMENT 'Current status of corrective action resolution: open (not started), in progress (actions underway), pending verification (awaiting follow-up audit), closed (verified complete), or overdue (past due date).. Valid values are `open|in_progress|pending_verification|closed|overdue`',
    `scope` STRING COMMENT 'Description of the areas, departments, or processes covered by this audit (e.g., Grocery Department - Refrigeration Units, Full Store - All Departments, Pharmacy - Controlled Substances).',
    `score_variance_percent` DECIMAL(18,2) COMMENT 'Percentage point change in audit score compared to previous audit (current score minus previous score). Null for first audit.',
    `start_time` TIMESTAMP COMMENT 'Timestamp when the audit fieldwork began at the store.',
    `store_manager_notified_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the store manager was formally notified of the audit results.',
    `summary` STRING COMMENT 'Executive summary of the audit findings, key observations, and overall assessment.',
    `total_findings_count` STRING COMMENT 'Total number of findings (non-compliances, deficiencies, or observations) identified during the audit.',
    `total_items_audited` STRING COMMENT 'Total number of positions, items, or checkpoints evaluated during the audit.',
    CONSTRAINT pk_audit PRIMARY KEY(`audit_id`)
) COMMENT 'Record of operational audits and compliance checks conducted at a store location covering food safety (FDA/FSMA), loss prevention, planogram compliance, health and safety (OSHA), accessibility (ADA), fire code, brand standards, and environmental compliance. Captures audit date, store location, audit type, auditor identity (internal LP team, third-party auditor, regulatory inspector, automated image recognition system), overall audit score (%), number of findings, number of critical findings, number of positions/items audited, corrective action plan required flag, corrective action due date, resolution status, and detailed finding records. Supports OSHA, FDA food safety, FTC compliance obligations, and visual merchandising KPI tracking.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`license` (
    `license_id` BIGINT COMMENT 'Unique identifier for the store license record. Primary key. Role: MASTER_AGREEMENT.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: License fees and compliance costs charge to cost centers for expense allocation and budget tracking—standard overhead accounting for regulatory compliance expenses in retail operations.',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.department. Business justification: Licenses and permits are often department-specific within a store (e.g., pharmacy license, deli/food service permit, alcohol license for a specific department). Adding department_id -> store.departmen',
    `license_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.license_permit. Business justification: Store licenses (alcohol, pharmacy, food service) are regulatory licenses managed in compliance.license_permit master. Business need: unified license renewal tracking, regulatory filing preparation, co',
    `location_id` BIGINT COMMENT 'Reference to the store location that holds this license. Links to store_location master record.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Regulated product promotions require license verification—alcohol, tobacco, pharmacy, and lottery promotions are restricted by license type and jurisdiction. Compliance teams link licenses to campaign',
    `renewed_from_license_id` BIGINT COMMENT 'Self-referencing FK on license (renewed_from_license_id)',
    `associate_id` BIGINT COMMENT 'Reference to the store associate or manager responsible for monitoring and renewing this license. Links to workforce/employee master record.',
    `audit_trail_reference` STRING COMMENT 'Reference to audit log entries or compliance audit records associated with this license. Supports regulatory audit readiness.',
    `compliance_notes` STRING COMMENT 'Free-text notes regarding compliance requirements, special conditions, or restrictions associated with this license.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this license record was first created in the system. Audit trail for record creation.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the annual fee amount (e.g., USD, CAD, EUR).. Valid values are `^[A-Z]{3}$`',
    `effective_start_date` DATE COMMENT 'Date from which the license becomes legally binding and the store is authorized to operate under this license.',
    `inspection_frequency_months` STRING COMMENT 'Number of months between required regulatory inspections. Used to calculate next inspection due dates.',
    `inspection_required_flag` BOOLEAN COMMENT 'Indicates whether periodic regulatory inspections are required to maintain this license. True if inspections are mandatory, False otherwise.',
    `last_inspection_date` DATE COMMENT 'Date of the most recent regulatory inspection conducted for this license. Tracks compliance verification cadence.',
    `last_modified_by` STRING COMMENT 'User ID or system identifier of the person or process that last modified this record. Audit trail for accountability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this license record was most recently updated. Audit trail for record changes.',
    `last_violation_date` DATE COMMENT 'Date of the most recent violation or citation issued for this license. Used for risk assessment and compliance monitoring.',
    `next_inspection_due_date` DATE COMMENT 'Date by which the next regulatory inspection must be completed to maintain license compliance.',
    `reinstatement_conditions` STRING COMMENT 'Conditions or requirements that must be met for the license to be reinstated after suspension or revocation.',
    `reinstatement_eligible_flag` BOOLEAN COMMENT 'Indicates whether the license is eligible for reinstatement after suspension or revocation. True if reinstatement is possible, False otherwise.',
    `renewal_lead_time_days` STRING COMMENT 'Number of days before expiration that the renewal process must be initiated to ensure continuity. Supports automated renewal alerting.',
    `revocation_date` DATE COMMENT 'Date the license was permanently revoked by the regulatory authority. Populated only when license_status is revoked.',
    `revocation_reason` STRING COMMENT 'Reason provided by the regulatory authority for revoking the license. Populated only when license_status is revoked.',
    `source_system_code` STRING COMMENT 'Unique identifier for this license record in the source operational system. Enables traceability and reconciliation.',
    `supporting_document_reference` STRING COMMENT 'Reference identifier or URL to the scanned license document, certificate, or permit stored in the document management system.',
    `suspension_end_date` DATE COMMENT 'Date the license suspension is scheduled to end or was lifted. Nullable if suspension is indefinite.',
    `suspension_reason` STRING COMMENT 'Reason provided by the regulatory authority for suspending the license. Populated only when license_status is suspended.',
    `suspension_start_date` DATE COMMENT 'Date the license suspension became effective. Populated only when license_status is suspended.',
    `violation_count` STRING COMMENT 'Total number of violations or citations issued against this license since its issue date. Tracks compliance history.',
    CONSTRAINT pk_license PRIMARY KEY(`license_id`)
) COMMENT 'Master record for licenses, permits, and regulatory certifications held at each store location. Captures license ID, store location reference, license type (liquor license, pharmacy permit, tobacco license, food handling certification, business operating permit, fire occupancy permit, health department permit, controlled substance DEA registration, lottery retailer license, money services license), issuing authority, license number, issue date, expiration date, renewal lead time, renewal status (current, pending renewal, expired, suspended, revoked), annual fee, responsible associate reference, and supporting document references. Tracks multi-jurisdictional requirements (state, county, municipal) for stores operating across regulatory boundaries. Critical for compliance — operating with an expired license triggers fines, forced closure, and reputational damage. Supports automated renewal alerting and regulatory audit readiness.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`cluster_membership` (
    `cluster_membership_id` BIGINT COMMENT 'Unique identifier for this store cluster membership record. Primary key for the association.',
    `cluster_id` BIGINT COMMENT 'Foreign key linking to the store cluster. Identifies which logical cluster this membership record associates with the store location.',
    `location_id` BIGINT COMMENT 'Foreign key linking to the store location. Identifies which physical retail location is a member of the cluster.',
    `assigned_by` STRING COMMENT 'Name or identifier of the user, system, or process that created this cluster membership assignment. Used for audit trail and accountability.',
    `assignment_effective_date` DATE COMMENT 'Date when this cluster assignment becomes operationally effective for planning and execution purposes. May differ from membership_start_date to support advance planning and staged rollouts.',
    `assignment_notes` STRING COMMENT 'Free-text notes providing additional context about this cluster membership assignment. Used to document special circumstances, exceptions, or business rationale.',
    `assignment_status` STRING COMMENT 'Current lifecycle status of this cluster membership. Active = currently in operational use; Pending = scheduled for future activation; Suspended = temporarily inactive; Expired = past membership; Overridden = superseded by manual reassignment.',
    `cluster_assignment_reason` STRING COMMENT 'Business justification or methodology for assigning this store to this cluster. Examples: algorithmic segmentation based on sales patterns, manual override by merchandising team, geographic proximity, demographic alignment, performance tier classification.',
    `is_primary_cluster` BOOLEAN COMMENT 'Indicates whether this cluster is the primary cluster assignment for this store location within this cluster type. Used when a store belongs to multiple clusters of the same type and one must be designated as primary for operational purposes.',
    `last_modified_by` STRING COMMENT 'User or system identifier that last modified this cluster membership record. Used for audit trail and accountability.',
    `last_modified_date` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this cluster membership record. Used for audit trail and change tracking.',
    `membership_end_date` DATE COMMENT 'Date when this store location ceased to be a member of this cluster. Null indicates current active membership. Used for historical analysis of cluster composition changes.',
    `membership_start_date` DATE COMMENT 'Date when this store location became a member of this cluster. Supports temporal tracking of cluster membership changes over time.',
    CONSTRAINT pk_cluster_membership PRIMARY KEY(`cluster_membership_id`)
) COMMENT 'This association product represents the membership relationship between store clusters and store locations. It captures the assignment of individual stores to logical clusters used for localized assortment planning, zone pricing, promotional targeting, and operational benchmarking. Each record links one store cluster to one store location with effective dates, primary cluster designation, assignment reason, and status that exist only in the context of this relationship. Supports concurrent membership in multiple overlapping clustering schemes (assortment clusters, pricing zones, demographic clusters, performance tiers, climate zones).. Existence Justification: Store cluster membership is a genuine operational M:N relationship in retail. Retailers actively manage multiple concurrent clustering schemes (assortment clusters, pricing zones, demographic segments, performance tiers, climate zones) where a single store participates in multiple clusters simultaneously, and each cluster contains multiple stores. The relationship has its own lifecycle (effective dates), business rules (primary cluster designation), and operational significance (drives localized merchandising, pricing, and planning decisions).';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` (
    `format_offer_eligibility_id` BIGINT COMMENT 'Unique identifier for this format-offer eligibility configuration record. Primary key.',
    `associate_id` BIGINT COMMENT 'Reference to the user who created this format-offer eligibility configuration, supporting audit and accountability for promotional strategy decisions.',
    `format_id` BIGINT COMMENT 'Foreign key linking to the store format classification for which this promotional offer eligibility is configured.',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to the promotional offer being configured for format-specific eligibility and mechanics.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this format-offer eligibility configuration was created in the system.',
    `effective_end_date` DATE COMMENT 'Date when this promotional offer expires for this specific store format. May differ from the base offer effective_end_date to support format-specific promotional calendars.',
    `effective_start_date` DATE COMMENT 'Date when this promotional offer becomes active for this specific store format. May differ from the base offer effective_start_date to support phased rollouts—e.g., testing in convenience formats before expanding to hypermarkets.',
    `eligibility_flag` BOOLEAN COMMENT 'Indicates whether this promotional offer is eligible for activation in stores of this format. False indicates the offer is explicitly excluded from this format type.',
    `localized_discount_value` DECIMAL(18,2) COMMENT 'Format-specific discount value that overrides the base discount_value from promo_offer. Allows hypermarkets to offer deeper discounts than convenience stores for the same promotional campaign. Null indicates use of base offer discount_value.',
    `localized_minimum_purchase` DECIMAL(18,2) COMMENT 'Format-specific minimum purchase amount required to qualify for this offer, overriding the base minimum_purchase_amount from promo_offer. Reflects typical basket size differences across formats—convenience stores may have lower thresholds than hypermarkets. Null indicates use of base offer threshold.',
    `priority_rank` STRING COMMENT 'Priority ranking for this offer within this store format when multiple offers are eligible and stackability rules apply. Lower values indicate higher priority. May differ from the base offer_priority in promo_offer to reflect format-specific merchandising strategy.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this format-offer eligibility configuration was last modified.',
    CONSTRAINT pk_format_offer_eligibility PRIMARY KEY(`format_offer_eligibility_id`)
) COMMENT 'This association product represents the eligibility configuration between store formats and promotional offers. It captures format-specific promotional mechanics including localized discount values, purchase thresholds, priority rankings, and effective date ranges. Each record links one store format to one promo offer with attributes that define how that specific offer executes within stores of that format type. Merchandising teams use this to configure format-level promotional strategies—hypermarkets may receive deeper discounts than convenience stores for the same campaign, or different minimum purchase thresholds based on typical basket size.. Existence Justification: In retail promotional operations, a single promotional offer (e.g., 20% off electronics) is configured to apply across multiple store formats (hypermarkets, supermarkets, convenience stores) with format-specific variations in discount depth, minimum purchase thresholds, and priority rankings. Conversely, each store format participates in dozens or hundreds of promotional offers simultaneously. Merchandising teams actively manage these format-offer eligibility configurations as operational records, adjusting localized discount values and thresholds based on format-specific customer demographics, basket sizes, and competitive positioning.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`carrier_agreement` (
    `carrier_agreement_id` BIGINT COMMENT 'Unique identifier for this store-carrier service agreement record. Primary key.',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to the carrier that is party to this service agreement',
    `location_id` BIGINT COMMENT 'Foreign key linking to the store location that is party to this carrier service agreement',
    `active_status` BOOLEAN COMMENT 'Indicates whether this store-carrier agreement is currently active and available for use in carrier selection and routing logic. False indicates suspended or inactive agreement.',
    `contract_end_date` DATE COMMENT 'The date when this store-carrier service agreement expires or was terminated. Null for active ongoing agreements.',
    `contract_start_date` DATE COMMENT 'The date when this store-carrier service agreement became effective and the carrier began servicing this store location.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this store-carrier agreement record was created in the system.',
    `cutoff_time_local` STRING COMMENT 'The store-specific cutoff time in local store time zone for same-day pickup by this carrier. Format HH:MM in 24-hour notation. May differ from carriers standard cutoff due to store location or route scheduling.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this store-carrier agreement record was last modified.',
    `negotiated_rate` DECIMAL(18,2) COMMENT 'The store-specific negotiated shipping rate per unit (per pound or per shipment) that may differ from the carriers standard rate card due to volume commitments or regional agreements.',
    `pickup_frequency` STRING COMMENT 'The frequency with which this carrier picks up shipments from this store location, defining the operational cadence of the store-carrier relationship.',
    `priority_rank` STRING COMMENT 'The routing priority rank for this carrier at this store location. Lower numbers indicate higher priority in carrier selection logic during fulfillment order routing. Used when multiple carriers can fulfill the same service level.',
    `service_level_agreement` STRING COMMENT 'The contracted service level commitment for this store-carrier relationship, defining expected delivery speed and service quality standards.',
    `volume_commitment_monthly` STRING COMMENT 'The minimum number of shipments per month that this store location has committed to route through this carrier as part of the negotiated rate agreement. Null if no volume commitment exists.',
    CONSTRAINT pk_carrier_agreement PRIMARY KEY(`carrier_agreement_id`)
) COMMENT 'This association product represents the contractual service agreement between a store location and a fulfillment carrier. It captures store-specific carrier contracts, negotiated rates, service level commitments, and routing priority rules for ship-from-store and BOPIS fulfillment operations. Each record links one store location to one carrier with contract terms, service configurations, and operational parameters that exist only in the context of this specific store-carrier relationship.. Existence Justification: In retail operations, store locations contract with multiple carriers to support ship-from-store, BOPIS, and direct-to-consumer fulfillment operations. Each store may use UPS, FedEx, regional carriers, and last-mile providers depending on service level requirements, geographic coverage, and cost optimization. Conversely, each carrier serves many store locations across the retail network. The business actively manages these store-carrier relationships as service agreements with store-specific negotiated rates, priority routing rules, cutoff times, and pickup schedules.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`sales_territory` (
    `sales_territory_id` BIGINT COMMENT 'Primary key for sales_territory',
    `associate_id` BIGINT COMMENT 'Reference to the employee who manages this sales territory. Responsible for territory performance and team oversight.',
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
    `state_province_code` STRING COMMENT 'State or province code for territories defined at sub-national level (e.g., CA, TX, ON, QC).',
    `sales_territory_status` STRING COMMENT 'Current lifecycle status of the sales territory. Active territories are operational; inactive are closed; pending are awaiting activation; suspended are temporarily halted; archived are historical; planned are future territories.',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`store_profit_loss` (
    `store_profit_loss_id` BIGINT COMMENT 'Unique identifier for the store-level profit and loss record. Primary key for the store P&L data product.',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.department. Business justification: Store P&L records can be captured at department level (department-level P&L is standard in retail for gross margin management). Adding department_id -> store.department.department_id enables departmen',
    `financial_period_id` BIGINT COMMENT 'Identifier of the fiscal period (week, month, quarter, or year) to which this P&L record applies.',
    `location_id` BIGINT COMMENT 'Identifier of the retail location (hypermarket, department store, discount outlet, dark store, or micro-fulfillment center) for which this P&L record is reported.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Store P&L attributes promotional costs and revenue to campaigns—finance teams allocate promotional discounts, vendor funding, and incremental labor to specific campaigns. Store-level P&L by campaign e',
    `atv_amount` DECIMAL(18,2) COMMENT 'Average dollar value per transaction, calculated as net sales divided by transaction count. Key metric for store performance and basket analysis.',
    `cogs_amount` DECIMAL(18,2) COMMENT 'Total cost of merchandise sold at the store during the period, including product cost, inbound freight, and direct product costs. Used to calculate gross margin.',
    `comp_sales_flag` BOOLEAN COMMENT 'Indicates whether this store qualifies for comparable store sales (SSS - Same-Store Sales) analysis for the period. Typically true if the store has been open for at least 12 months.',
    `comp_sales_growth_percent` DECIMAL(18,2) COMMENT 'Year-over-year percentage change in net sales for this store during the period, used for same-store sales (SSS) performance tracking.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this store P&L record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which all monetary amounts in this P&L record are denominated.. Valid values are `^[A-Z]{3}$`',
    `depreciation_amount` DECIMAL(18,2) COMMENT 'Depreciation expense for store fixtures, equipment, POS terminals, gondolas, and other fixed assets allocated to the store for the period.',
    `discounts_amount` DECIMAL(18,2) COMMENT 'Total value of markdowns, promotional discounts, and price reductions applied to merchandise sales during the period.',
    `ebitda_amount` DECIMAL(18,2) COMMENT 'Store contribution to enterprise EBITDA, calculated as gross margin minus operating expenses (excluding depreciation). Key metric for store-level profitability and GMROI analysis.',
    `ebitda_percent` DECIMAL(18,2) COMMENT 'EBITDA as a percentage of net sales. Used for store performance benchmarking and profitability comparison across locations.',
    `finalized_timestamp` TIMESTAMP COMMENT 'Date and time when this store P&L record was marked as final and locked for audit purposes. Null if still preliminary.',
    `gross_margin_amount` DECIMAL(18,2) COMMENT 'Net sales minus COGS. Represents the profit available to cover operating expenses and contribute to EBITDA.',
    `gross_margin_percent` DECIMAL(18,2) COMMENT 'Gross margin as a percentage of net sales. Key profitability metric used for store performance benchmarking and GMROI analysis.',
    `gross_sales_amount` DECIMAL(18,2) COMMENT 'Total merchandise sales at the store before deducting returns, allowances, and discounts. Used to calculate return rates and discount penetration.',
    `labor_cost_amount` DECIMAL(18,2) COMMENT 'Total store labor expenses including wages, salaries, benefits, payroll taxes, and overtime for store associates and management during the period.',
    `marketing_expense_amount` DECIMAL(18,2) COMMENT 'Store-level marketing and advertising expenses including local promotions, signage, endcap displays, and community engagement costs for the period.',
    `net_sales_amount` DECIMAL(18,2) COMMENT 'Total revenue from merchandise sales at the store during the period, net of returns, allowances, and discounts. Represents the top line of the store P&L.',
    `notes` STRING COMMENT 'Free-text notes or comments explaining unusual variances, one-time adjustments, restatement reasons, or other contextual information for this P&L record.',
    `occupancy_cost_amount` DECIMAL(18,2) COMMENT 'Total store occupancy expenses including rent, common area maintenance (CAM) charges, property taxes, utilities, and facility maintenance costs for the period.',
    `other_operating_expense_amount` DECIMAL(18,2) COMMENT 'Miscellaneous operating expenses not classified in other categories, including bank fees, credit card processing fees, security services, and other store-level costs.',
    `period_end_date` DATE COMMENT 'The last calendar date of the fiscal period covered by this P&L record.',
    `period_start_date` DATE COMMENT 'The first calendar date of the fiscal period covered by this P&L record.',
    `pl_status` STRING COMMENT 'Current status of the P&L record indicating whether the figures are preliminary estimates, final audited values, or restated corrections.. Valid values are `preliminary|final|restated`',
    `reporting_entity` STRING COMMENT 'Legal entity or business unit responsible for this store P&L record, used for consolidated financial reporting and intercompany reconciliation.',
    `returns_amount` DECIMAL(18,2) COMMENT 'Total value of merchandise returned by customers during the period. Subtracted from gross sales to arrive at net sales.',
    `shrinkage_amount` DECIMAL(18,2) COMMENT 'Total inventory loss due to theft, damage, spoilage, or administrative errors during the period. Recorded as an operating expense.',
    `supply_expense_amount` DECIMAL(18,2) COMMENT 'Total cost of store supplies including bags, packaging materials, cleaning supplies, POS consumables, and other operational supplies consumed during the period.',
    `total_operating_expense_amount` DECIMAL(18,2) COMMENT 'Sum of all operating expenses including shrinkage, occupancy, labor, supplies, marketing, depreciation, and other operating costs for the period.',
    `transaction_count` BIGINT COMMENT 'Total number of POS transactions completed at the store during the period. Used to calculate average transaction value (ATV) and units per transaction (UPT).',
    `units_sold` BIGINT COMMENT 'Total number of merchandise units (SKUs) sold at the store during the period. Used to calculate units per transaction (UPT) and sell-through rates.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this store P&L record was last modified, including status changes or restatements.',
    `upt` DECIMAL(18,2) COMMENT 'Average number of units sold per transaction, calculated as units sold divided by transaction count. Indicates basket size and cross-selling effectiveness.',
    CONSTRAINT pk_store_profit_loss PRIMARY KEY(`store_profit_loss_id`)
) COMMENT 'Store-level Profit & Loss (P&L) record capturing periodic financial performance for each retail location. Records store location, fiscal period (week/month/quarter/year), net sales, COGS (Cost of Goods Sold), gross margin, gross margin %, shrinkage expense, occupancy cost (rent, CAM, utilities), labor cost, supply expense, total operating expense, EBITDA contribution, and P&L status (preliminary, final, restated). Owned by the store domain as the operational P&L; the finance domain owns the consolidated GL. Enables GMROI analysis and store-level profitability benchmarking.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` (
    `ship_from_store_node_id` BIGINT COMMENT 'Unique identifier for the ship-from-store fulfillment node. Primary key for this entity.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Omnichannel campaigns drive ship-from-store orders; fulfillment nodes track campaign-attributed order volume for capacity planning and marketing attribution. E-commerce operations require campaign lin',
    `inventory_node_id` BIGINT COMMENT 'Foreign key linking to inventory.inventory_node. Business justification: Ship-from-store nodes are stores functioning as fulfillment centers within the inventory network. Linking to inventory_node enables ATP queries, allocation logic, and replenishment planning to treat S',
    `location_id` BIGINT COMMENT 'Reference to the physical store location that serves as this fulfillment node. Links to the store master record.',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_offer. Business justification: Omnichannel promotional offers are node-specific—BOPIS promotions, same-day delivery discounts, and curbside pickup incentives are tied to fulfillment node capabilities. E-commerce and store operation',
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
    `primary_carrier_code` STRING COMMENT 'Code identifying the primary Third-Party Logistics (3PL) carrier or delivery service provider assigned to this fulfillment node (e.g., UPS, FEDEX, USPS, DHL).',
    `priority_rank` STRING COMMENT 'Numeric priority rank for this fulfillment node in the order routing algorithm. Lower numbers indicate higher priority. Used when multiple nodes can fulfill an order.',
    `same_day_cutoff_time` TIMESTAMP COMMENT 'Local time cutoff (HH:MM format) by which orders must be placed to qualify for same-day delivery from this node. Null if same-day delivery is not supported.',
    `secondary_carrier_code` STRING COMMENT 'Code identifying the secondary or backup carrier assigned to this fulfillment node. Used when primary carrier is unavailable or for specific delivery types.',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` (
    `direct_store_delivery_id` BIGINT COMMENT 'Unique identifier for the DSD receiving transaction. Primary key for the DSD receiving record.',
    `ap_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ap_invoice. Business justification: DSD receipts trigger AP invoice matching for three-way match (PO, receipt, invoice) and payment processing—core procure-to-pay process ensuring accurate vendor payment and accrual accounting.',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.department. Business justification: Direct Store Delivery receipts are received into specific store departments (e.g., beverages to grocery department, snacks to convenience department). Adding department_id -> store.department.departme',
    `inbound_shipment_id` BIGINT COMMENT 'Foreign key linking to supplychain.inbound_shipment. Business justification: DSD store deliveries are often part of larger multi-stop vendor shipment manifests managed by supply chain. Links store-level receipt to shipment-level tracking for freight reconciliation, multi-locat',
    `inbound_appointment_id` BIGINT COMMENT 'Foreign key linking to supplychain.inbound_appointment. Business justification: DSD receiving at stores often coordinates with DC-managed vendor delivery appointments for consolidated multi-stop deliveries. Links store receipt to supply chain appointment scheduling system for on-',
    `location_id` BIGINT COMMENT 'Identifier of the retail store location where the DSD delivery was received. Links to the store master record.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: DSD deliveries for vendor-funded promotions are tied to campaigns—beverage, snack, and bakery vendors deliver promotional inventory for specific campaign windows. Receiving and AP teams link DSD recei',
    `purchase_order_id` BIGINT COMMENT 'Reference to the purchase order that authorized this DSD delivery. May be null for scan-based trading arrangements.',
    `associate_id` BIGINT COMMENT 'Identifier of the store associate who physically received and processed the DSD delivery. Used for accountability and training purposes.',
    `inventory_node_id` BIGINT COMMENT 'Foreign key linking to inventory.inventory_node. Business justification: DSD receiving at stores must link to inventory_node for stock positioning, ATP calculation, and replenishment planning. Store location alone doesnt provide network-level inventory visibility required',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: DSD receipts record which SKUs were delivered in each direct store delivery. Essential for DSD invoice reconciliation, vendor compliance tracking, and scan-based trading settlement. Each receipt line ',
    `vendor_id` BIGINT COMMENT 'Identifier of the DSD supplier or vendor who delivered the merchandise directly to the store. Typically beverage, snack, bread, or dairy vendors.',
    `chargeback_amount` DECIMAL(18,2) COMMENT 'Total chargeback amount assessed against the supplier for compliance violations, quantity discrepancies, or quality issues. Deducted from accounts payable.',
    `chargeback_reason` STRING COMMENT 'Description of the reason for the chargeback assessment. Common reasons include short shipment, damaged goods, temperature violations, or late delivery.',
    `cost_variance` DECIMAL(18,2) COMMENT 'Difference between invoiced cost and received cost (invoiced minus received). Positive values indicate over-billing; negative values indicate pricing discrepancies.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this DSD receiving record was first created in the database. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this DSD receiving transaction.. Valid values are `^[A-Z]{3}$`',
    `delivery_manifest_number` STRING COMMENT 'Supplier-provided manifest or delivery ticket number that accompanies the DSD shipment. Used for reconciliation and chargeback processing.',
    `delivery_window_end` TIMESTAMP COMMENT 'Scheduled end time of the delivery window for this DSD shipment. Used to track on-time delivery performance and assess late delivery chargebacks.',
    `delivery_window_start` TIMESTAMP COMMENT 'Scheduled start time of the delivery window for this DSD shipment. Used to track on-time delivery performance.',
    `driver_name` STRING COMMENT 'Name of the supplier driver who delivered the DSD shipment. Used for security and accountability purposes.',
    `driver_signature_captured` BOOLEAN COMMENT 'Indicates whether the driver signature was captured electronically at the time of delivery. Required for proof of delivery documentation.',
    `invoice_match_status` STRING COMMENT 'Status indicating whether the supplier invoice matches the received quantities and costs. Critical for three-way match (PO, receipt, invoice) and accounts payable processing.. Valid values are `matched|unmatched|variance_within_tolerance|variance_exceeds_tolerance|pending_reconciliation`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this DSD receiving record was last updated. Used for audit trail and change tracking.',
    `notes` STRING COMMENT 'Free-text notes capturing additional information about the DSD receiving transaction, including special handling instructions, quality observations, or operational issues.',
    `on_time_delivery_flag` BOOLEAN COMMENT 'Indicates whether the DSD delivery arrived within the scheduled delivery window. Used for supplier performance scorecarding.',
    `putaway_completed_flag` BOOLEAN COMMENT 'Indicates whether the received DSD merchandise has been put away to its final storage or sales floor location. Used for inventory accuracy and workflow tracking.',
    `putaway_timestamp` TIMESTAMP COMMENT 'Date and time when the DSD merchandise was put away to its final location. Used to measure receiving cycle time and labor productivity.',
    `quantity_variance` DECIMAL(18,2) COMMENT 'Difference between quantity invoiced and quantity received (invoiced minus received). Positive values indicate over-billing; negative values indicate under-delivery.',
    `receipt_date` DATE COMMENT 'Calendar date when the DSD delivery was received at the store location.',
    `receipt_number` STRING COMMENT 'Store-generated receipt number assigned at the time of DSD receiving. Used for internal tracking and audit trail.',
    `receipt_status` STRING COMMENT 'Current lifecycle status of the DSD receiving transaction indicating whether the delivery was fully accepted, partially accepted, rejected, or is under review.. Valid values are `accepted|partially_accepted|rejected|pending_review|disputed`',
    `receipt_timestamp` TIMESTAMP COMMENT 'Precise date and time when the DSD receiving transaction was completed and recorded in the system. Principal business event timestamp for this transaction.',
    `receiving_location` STRING COMMENT 'Physical location within the store where the DSD delivery was received and initially staged. Used for inventory tracking and workflow optimization.. Valid values are `receiving_dock|back_room|sales_floor|cooler|freezer`',
    `reconciliation_date` DATE COMMENT 'Date when the DSD receiving transaction was fully reconciled and approved for payment. Used for accounts payable aging and cash flow management.',
    `reconciliation_status` STRING COMMENT 'Status of the financial reconciliation process between received goods, supplier invoice, and purchase order. Critical for accounts payable and vendor payment processing.. Valid values are `pending|reconciled|disputed|closed`',
    `rejection_notes` STRING COMMENT 'Free-text notes providing additional detail about the rejection or quality issue. Supports chargeback documentation and supplier dispute resolution.',
    `rejection_reason` STRING COMMENT 'Reason code indicating why the DSD delivery was rejected or partially rejected. Used for supplier performance tracking and chargeback justification. [ENUM-REF-CANDIDATE: temperature_out_of_range|damaged_product|expired_product|quantity_discrepancy|unauthorized_delivery|quality_issue|none — 7 candidates stripped; promote to reference product]',
    `scan_based_trading_flag` BOOLEAN COMMENT 'Indicates whether this DSD delivery is part of a scan-based trading arrangement where the supplier retains ownership until the product is sold at POS.',
    `temperature_check_required` BOOLEAN COMMENT 'Indicates whether temperature verification was required for this DSD delivery due to perishable goods (dairy, refrigerated, frozen items).',
    `temperature_check_result` STRING COMMENT 'Result of the temperature verification check for perishable DSD deliveries. Failed checks may trigger rejection per FDA FSMA requirements.. Valid values are `passed|failed|not_applicable|not_performed`',
    `temperature_reading` DECIMAL(18,2) COMMENT 'Actual temperature reading in Fahrenheit recorded during the DSD receiving inspection for perishable goods. Required for FDA FSMA compliance.',
    `total_cost_invoiced` DECIMAL(18,2) COMMENT 'Total cost as stated on the supplier invoice. Used for three-way match validation and variance analysis.',
    `total_cost_received` DECIMAL(18,2) COMMENT 'Total cost of goods received based on purchase order or contract pricing. Represents the expected accounts payable liability.',
    `total_quantity_invoiced` DECIMAL(18,2) COMMENT 'Total quantity of units invoiced by the supplier across all SKUs in this DSD delivery. Used for variance detection and chargeback calculation.',
    `total_quantity_received` DECIMAL(18,2) COMMENT 'Total quantity of units received across all SKUs in this DSD delivery. Aggregated from line-level detail.',
    CONSTRAINT pk_direct_store_delivery PRIMARY KEY(`direct_store_delivery_id`)
) COMMENT 'Transactional record of Direct Store Delivery (DSD) receipts where suppliers (typically beverage, snack, bread, dairy vendors) deliver merchandise directly to a store location, bypassing the distribution center network. Captures receipt date/time, store location, supplier/vendor reference, purchase order reference, delivery manifest number, SKUs received, quantities received, quantities invoiced, quantity variance, cost variance, receiving associate ID, temperature check result (for perishables per FDA FSMA requirements), rejection reason (if applicable), receipt status (accepted, partially accepted, rejected), and invoice match status. Critical for DSD vendor compliance, chargeback processing, scan-based trading (SBT) reconciliation, and store-level inventory accuracy. Typically represents 20-35% of store SKU count in grocery-anchored formats.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`store`.`region` (
    `region_id` BIGINT COMMENT 'Primary key for region',
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
    `market_maturity` STRING COMMENT 'Assessment of the retail market development stage within the region. Drives investment strategy, promotional intensity, and format mix decisions (e.g., emerging markets favour discount formats).',
    `region_name` STRING COMMENT 'Full human-readable name of the region as used in business reporting and store operations (e.g., North-East, Pacific Rim). Displayed in dashboards, planograms, and territory management tools.',
    `notes` STRING COMMENT 'Free-text field for operational notes, boundary change explanations, or special instructions relevant to this region. Intended for internal use by the store operations and data governance teams.',
    `omnichannel_enabled` BOOLEAN COMMENT 'Indicates whether stores in this region are enabled for omnichannel fulfilment capabilities such as click-and-collect (BOPIS), ship-from-store (SFS), and same-day delivery. True means at least one omnichannel service is live.',
    `population` BIGINT COMMENT 'Estimated total resident population within the region boundary. Sourced from national census or third-party demographic data. Used for market sizing, store count planning, and catchment analysis.',
    `population_reference_year` STRING COMMENT 'The calendar year to which the population figure refers, enabling users to assess data currency and apply appropriate growth adjustments.',
    `region_manager` STRING COMMENT 'Full name of the senior retail operations manager accountable for this region. Used for escalation routing, performance review, and organisational reporting. Classified confidential as it identifies an internal employee in a named role.',
    `region_manager_email` STRING COMMENT 'Corporate email address of the region manager. Used for automated alerts, escalation workflows, and operational communications. Classified as confidential PII.',
    `region_type` STRING COMMENT 'Categorical classification of the regions primary business purpose. operational covers day-to-day store management; sales covers revenue territory; franchise covers franchisee groupings; distribution covers supply-chain zones; compliance covers regulatory jurisdictions.',
    `regulatory_zone` STRING COMMENT 'Identifier for the regulatory or compliance zone governing retail operations in this region (e.g., EU Single Market, US Federal, APAC Free Trade Zone). Determines applicable labour, food safety, and consumer protection regulations.',
    `short_name` STRING COMMENT 'Abbreviated display name for the region used in space-constrained UI elements, POS terminal screens, and printed reports (e.g., NE Region, SW).',
    `shrink_rate` DECIMAL(18,2) COMMENT 'Retail shrinkage rate for the region expressed as a percentage of net sales, encompassing theft, administrative error, and supplier fraud. Used for loss-prevention benchmarking and security resource allocation.',
    `source_system_code` STRING COMMENT 'Code identifying the upstream operational system from which this region record was sourced (e.g., the retail merchandising system, the store master data system). Used for data lineage and reconciliation.',
    `sss_index` DECIMAL(18,2) COMMENT 'Same-Store Sales (SSS) index for the region, representing the ratio of current-period comparable store sales to the prior-period baseline. A value above 1.0 indicates positive comp sales growth. Used for regional performance benchmarking.',
    `sss_reference_period` STRING COMMENT 'The fiscal period (e.g., FY2023-Q2) used as the baseline for the SSS index calculation. Ensures consistent interpretation of the SSS index across reporting cycles.',
    `region_status` STRING COMMENT 'Current lifecycle status of the region record. active means the region is in use for store assignment and reporting; inactive means it has been decommissioned; pending means it is being set up; archived means it is retained for historical reference only.',
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
ALTER TABLE `vibe_retail_v1`.`store`.`location` ADD CONSTRAINT `fk_store_location_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`location` ADD CONSTRAINT `fk_store_location_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`format` ADD CONSTRAINT `fk_store_format_parent_format_id` FOREIGN KEY (`parent_format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ADD CONSTRAINT `fk_store_pos_terminal_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ADD CONSTRAINT `fk_store_pos_terminal_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ADD CONSTRAINT `fk_store_store_planogram_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ADD CONSTRAINT `fk_store_store_planogram_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ADD CONSTRAINT `fk_store_fixture_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ADD CONSTRAINT `fk_store_fixture_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ADD CONSTRAINT `fk_store_fixture_store_planogram_id` FOREIGN KEY (`store_planogram_id`) REFERENCES `vibe_retail_v1`.`store`.`store_planogram`(`store_planogram_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ADD CONSTRAINT `fk_store_traffic_count_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ADD CONSTRAINT `fk_store_traffic_count_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ADD CONSTRAINT `fk_store_comparable_sales_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ADD CONSTRAINT `fk_store_comparable_sales_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ADD CONSTRAINT `fk_store_comparable_sales_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ADD CONSTRAINT `fk_store_comparable_sales_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ADD CONSTRAINT `fk_store_comparable_sales_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`department` ADD CONSTRAINT `fk_store_department_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ADD CONSTRAINT `fk_store_remodel_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ADD CONSTRAINT `fk_store_remodel_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ADD CONSTRAINT `fk_store_remodel_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ADD CONSTRAINT `fk_store_cluster_parent_cluster_id` FOREIGN KEY (`parent_cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ADD CONSTRAINT `fk_store_audit_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ADD CONSTRAINT `fk_store_audit_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ADD CONSTRAINT `fk_store_audit_previous_audit_id` FOREIGN KEY (`previous_audit_id`) REFERENCES `vibe_retail_v1`.`store`.`audit`(`audit_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`license` ADD CONSTRAINT `fk_store_license_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`license` ADD CONSTRAINT `fk_store_license_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`license` ADD CONSTRAINT `fk_store_license_renewed_from_license_id` FOREIGN KEY (`renewed_from_license_id`) REFERENCES `vibe_retail_v1`.`store`.`license`(`license_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`cluster_membership` ADD CONSTRAINT `fk_store_cluster_membership_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`cluster_membership` ADD CONSTRAINT `fk_store_cluster_membership_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ADD CONSTRAINT `fk_store_format_offer_eligibility_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` ADD CONSTRAINT `fk_store_carrier_agreement_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ADD CONSTRAINT `fk_store_sales_territory_parent_sales_territory_id` FOREIGN KEY (`parent_sales_territory_id`) REFERENCES `vibe_retail_v1`.`store`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ADD CONSTRAINT `fk_store_sales_territory_parent_territory_id` FOREIGN KEY (`parent_territory_id`) REFERENCES `vibe_retail_v1`.`store`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ADD CONSTRAINT `fk_store_sales_territory_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ADD CONSTRAINT `fk_store_sales_territory_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ADD CONSTRAINT `fk_store_store_profit_loss_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ADD CONSTRAINT `fk_store_store_profit_loss_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ADD CONSTRAINT `fk_store_direct_store_delivery_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ADD CONSTRAINT `fk_store_direct_store_delivery_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`region` ADD CONSTRAINT `fk_store_region_parent_region_id` FOREIGN KEY (`parent_region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`store` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_retail_v1`.`store` SET TAGS ('dbx_domain' = 'store');
ALTER TABLE `vibe_retail_v1`.`store`.`location` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`location` SET TAGS ('dbx_subdomain' = 'location_management');
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store Location ID');
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
ALTER TABLE `vibe_retail_v1`.`store`.`location` ALTER COLUMN `primary_dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Dc Facility Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`store`.`format` SET TAGS ('dbx_subdomain' = 'location_management');
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
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` SET TAGS ('dbx_subdomain' = 'store_operations');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `pos_terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Point-of-Sale (POS) Terminal ID');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Store Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` SET TAGS ('dbx_subdomain' = 'store_operations');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `store_planogram_id` SET TAGS ('dbx_business_glossary_term' = 'Store Planogram (POG) ID');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Store Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `product_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `max_on_shelf_quantity` SET TAGS ('dbx_business_glossary_term' = 'Maximum On-Shelf Quantity');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `merchandising_strategy` SET TAGS ('dbx_value_regex' = 'category_dominance|brand_blocking|price_point_segmentation|cross_merchandising|impulse');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `min_on_shelf_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum On-Shelf Quantity');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `planogram_code` SET TAGS ('dbx_business_glossary_term' = 'Planogram (POG) Code');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `planogram_code` SET TAGS ('dbx_value_regex' = '^POG-[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `planogram_name` SET TAGS ('dbx_business_glossary_term' = 'Planogram (POG) Name');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `planogram_status` SET TAGS ('dbx_business_glossary_term' = 'Planogram (POG) Status');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `planogram_status` SET TAGS ('dbx_value_regex' = 'draft|approved|active|retired|suspended');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `planogram_type` SET TAGS ('dbx_business_glossary_term' = 'Planogram (POG) Type');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `planogram_type` SET TAGS ('dbx_value_regex' = 'standard|seasonal|promotional|reset|test');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `primary_sku_count` SET TAGS ('dbx_business_glossary_term' = 'Primary Stock Keeping Unit (SKU) Count');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `promotional_sku_count` SET TAGS ('dbx_business_glossary_term' = 'Promotional Stock Keeping Unit (SKU) Count');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `replenishment_frequency` SET TAGS ('dbx_value_regex' = 'daily|twice_daily|weekly|as_needed|continuous');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `sku_count` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) Count');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System ID');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `target_gmroi` SET TAGS ('dbx_business_glossary_term' = 'Target Gross Margin Return on Investment (GMROI)');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Planogram (POG) Version');
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ALTER COLUMN `version` SET TAGS ('dbx_value_regex' = '^v?[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` SET TAGS ('dbx_subdomain' = 'store_operations');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `creative_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Creative Asset Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Store Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `merchandising_planogram_id` SET TAGS ('dbx_business_glossary_term' = 'Planogram (POG) ID');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `store_planogram_id` SET TAGS ('dbx_business_glossary_term' = 'Store Planogram Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `ada_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'ADA (Americans with Disabilities Act) Compliant Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `fixture_category` SET TAGS ('dbx_value_regex' = 'permanent|seasonal|promotional|temporary');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `fixture_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `depth_inches` SET TAGS ('dbx_business_glossary_term' = 'Depth (Inches)');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `fixture_status` SET TAGS ('dbx_value_regex' = 'active|inactive|maintenance|retired|damaged|pending_installation');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `height_inches` SET TAGS ('dbx_business_glossary_term' = 'Height (Inches)');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `lighting_integrated_flag` SET TAGS ('dbx_business_glossary_term' = 'Integrated Lighting Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `mobility_type` SET TAGS ('dbx_value_regex' = 'fixed|mobile|semi_mobile');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `next_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Maintenance Date');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `refrigeration_type` SET TAGS ('dbx_value_regex' = 'ambient|chilled|frozen|multi_temp|none');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `rfid_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'RFID (Radio Frequency Identification) Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `weight_capacity_lbs` SET TAGS ('dbx_business_glossary_term' = 'Weight Capacity (Pounds)');
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ALTER COLUMN `width_inches` SET TAGS ('dbx_business_glossary_term' = 'Width (Inches)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` SET TAGS ('dbx_subdomain' = 'retail_performance');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `traffic_count_id` SET TAGS ('dbx_business_glossary_term' = 'Traffic Count Identifier');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `kpi_value_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Value Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `accuracy_confidence_percent` SET TAGS ('dbx_business_glossary_term' = 'Accuracy Confidence (Percent)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `average_dwell_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Average Dwell Time (Minutes)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `conversion_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Conversion Rate (Percent)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `counting_zone_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `measurement_interval_minutes` SET TAGS ('dbx_business_glossary_term' = 'Measurement Interval (Minutes)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `sensor_device_code` SET TAGS ('dbx_business_glossary_term' = 'Sensor Device ID');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `sensor_device_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{8,30}$');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `sensor_device_code` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `sensor_device_code` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `sensor_type` SET TAGS ('dbx_value_regex' = 'thermal|video_analytics|infrared|rfid|wifi_tracking|bluetooth_beacon');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `temperature_fahrenheit` SET TAGS ('dbx_business_glossary_term' = 'Temperature (Fahrenheit)');
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ALTER COLUMN `zone_type` SET TAGS ('dbx_value_regex' = 'entrance|department|checkout|aisle|endcap|gondola');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` SET TAGS ('dbx_subdomain' = 'retail_performance');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `comparable_sales_id` SET TAGS ('dbx_business_glossary_term' = 'Comparable Sales Identifier');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Cluster Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `financial_period_id` SET TAGS ('dbx_business_glossary_term' = 'Financial Period Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `kpi_value_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Value Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `comp_sales_growth_rate` SET TAGS ('dbx_business_glossary_term' = 'Comparable Sales (Comp Sales) Growth Rate');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `comp_sales_variance_amount` SET TAGS ('dbx_business_glossary_term' = 'Comparable Sales (Comp Sales) Variance Amount');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `comp_sales_variance_percent` SET TAGS ('dbx_business_glossary_term' = 'Comparable Sales (Comp Sales) Variance Percent');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `comp_store_qualification_status` SET TAGS ('dbx_business_glossary_term' = 'Comparable Store (Comp Store) Qualification Status');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `comp_store_qualification_status` SET TAGS ('dbx_value_regex' = 'qualified|not_qualified|pending_review');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `current_period_atv` SET TAGS ('dbx_business_glossary_term' = 'Current Period Average Transaction Value (ATV)');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `current_period_conversion_rate` SET TAGS ('dbx_business_glossary_term' = 'Current Period Conversion Rate (CR)');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `current_period_upt` SET TAGS ('dbx_business_glossary_term' = 'Current Period Units Per Transaction (UPT)');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `prior_period_atv` SET TAGS ('dbx_business_glossary_term' = 'Prior Period Average Transaction Value (ATV)');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `prior_period_conversion_rate` SET TAGS ('dbx_business_glossary_term' = 'Prior Period Conversion Rate (CR)');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `prior_period_upt` SET TAGS ('dbx_business_glossary_term' = 'Prior Period Units Per Transaction (UPT)');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `reporting_period_type` SET TAGS ('dbx_value_regex' = 'week|month|quarter|year');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `sales_per_sqft` SET TAGS ('dbx_business_glossary_term' = 'Sales Per Square Foot (sqft)');
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ALTER COLUMN `store_size_sqft` SET TAGS ('dbx_business_glossary_term' = 'Store Size Square Feet (sqft)');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` SET TAGS ('dbx_subdomain' = 'retail_performance');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Inventory Adjustment Transaction ID');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Store Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `dq_issue_id` SET TAGS ('dbx_business_glossary_term' = 'Dq Issue Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `associate_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ALTER COLUMN `rma_id` SET TAGS ('dbx_business_glossary_term' = 'Rma Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`store`.`department` SET TAGS ('dbx_subdomain' = 'location_management');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Store Department ID');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Department Manager ID');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`department` ALTER COLUMN `marketing_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Brand Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` SET TAGS ('dbx_subdomain' = 'store_operations');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `remodel_id` SET TAGS ('dbx_business_glossary_term' = 'Store Remodel ID');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Contractor Vendor Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `fixed_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Fixed Asset Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Launch Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `merchandising_planogram_id` SET TAGS ('dbx_business_glossary_term' = 'Target Planogram Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Previous Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Remodel Completion Date');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Remodel Start Date');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Project Approval Date');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `closure_end_date` SET TAGS ('dbx_business_glossary_term' = 'Temporary Closure End Date');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `closure_start_date` SET TAGS ('dbx_business_glossary_term' = 'Temporary Closure Start Date');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `comp_sales_exclusion_flag` SET TAGS ('dbx_business_glossary_term' = 'Comparable Sales (Comp Sales) Exclusion Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `format_change_flag` SET TAGS ('dbx_business_glossary_term' = 'Store Format Change Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `inspection_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Final Inspection Completion Date');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `new_format` SET TAGS ('dbx_business_glossary_term' = 'New Store Format');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Remodel Project Notes');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `permit_number` SET TAGS ('dbx_business_glossary_term' = 'Building Permit Number');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Remodel Start Date');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `project_number` SET TAGS ('dbx_business_glossary_term' = 'Remodel Project Number');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `project_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `project_status` SET TAGS ('dbx_business_glossary_term' = 'Remodel Project Status');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `project_status` SET TAGS ('dbx_value_regex' = 'planned|approved|in_progress|completed|cancelled|on_hold');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `projected_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Projected Remodel Completion Date');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `remodel_type` SET TAGS ('dbx_value_regex' = 'full_remodel|department_refresh|fixture_replacement|technology_upgrade|accessibility_improvement|format_conversion');
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ALTER COLUMN `roi_projection_percent` SET TAGS ('dbx_business_glossary_term' = 'Return on Investment (ROI) Projection Percentage');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` SET TAGS ('dbx_subdomain' = 'location_management');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `loyalty_program_id` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `parent_cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ALTER COLUMN `reporting_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Reporting Hierarchy Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`store`.`audit` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` SET TAGS ('dbx_subdomain' = 'retail_performance');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `audit_id` SET TAGS ('dbx_business_glossary_term' = 'Store Audit ID');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Auditor ID');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `associate_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `dq_result_id` SET TAGS ('dbx_business_glossary_term' = 'Dq Result Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `merchandising_planogram_id` SET TAGS ('dbx_business_glossary_term' = 'Planogram Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `return_fraud_case_id` SET TAGS ('dbx_business_glossary_term' = 'Return Fraud Case Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `rma_id` SET TAGS ('dbx_business_glossary_term' = 'Rma Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `audit_number` SET TAGS ('dbx_value_regex' = '^AUD-[0-9]{8}-[A-Z0-9]{6}$');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `auditor_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `auditor_type` SET TAGS ('dbx_value_regex' = 'internal_lp_team|third_party_auditor|regulatory_inspector|automated_system|district_manager|corporate_compliance');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `end_time` SET TAGS ('dbx_business_glossary_term' = 'Audit End Time');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `fine_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `fiscal_quarter` SET TAGS ('dbx_value_regex' = 'Q1|Q2|Q3|Q4');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `follow_up_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Audit Date');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `follow_up_audit_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Audit Required Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `overall_score_percent` SET TAGS ('dbx_business_glossary_term' = 'Overall Audit Score Percentage');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `pass_fail_status` SET TAGS ('dbx_business_glossary_term' = 'Pass/Fail Status');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `pass_fail_status` SET TAGS ('dbx_value_regex' = 'pass|fail|conditional_pass|pending_review');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `previous_audit_score_percent` SET TAGS ('dbx_business_glossary_term' = 'Previous Audit Score Percentage');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `report_url` SET TAGS ('dbx_business_glossary_term' = 'Audit Report URL');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `resolution_status` SET TAGS ('dbx_value_regex' = 'open|in_progress|pending_verification|closed|overdue');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `score_variance_percent` SET TAGS ('dbx_business_glossary_term' = 'Score Variance Percentage');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `start_time` SET TAGS ('dbx_business_glossary_term' = 'Audit Start Time');
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ALTER COLUMN `summary` SET TAGS ('dbx_business_glossary_term' = 'Audit Summary');
ALTER TABLE `vibe_retail_v1`.`store`.`license` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`license` SET TAGS ('dbx_subdomain' = 'store_operations');
ALTER TABLE `vibe_retail_v1`.`store`.`license` ALTER COLUMN `license_id` SET TAGS ('dbx_business_glossary_term' = 'Store License ID');
ALTER TABLE `vibe_retail_v1`.`store`.`license` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`license` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`license` ALTER COLUMN `license_permit_id` SET TAGS ('dbx_business_glossary_term' = 'License Permit Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`license` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`license` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`license` ALTER COLUMN `renewed_from_license_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`license` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`store`.`license` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System ID');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster_membership` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster_membership` SET TAGS ('dbx_subdomain' = 'location_management');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster_membership` SET TAGS ('dbx_association_edges' = 'store.store_cluster,store.store_location');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster_membership` ALTER COLUMN `cluster_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster Membership ID');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster_membership` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster Membership - Store Cluster Id');
ALTER TABLE `vibe_retail_v1`.`store`.`cluster_membership` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster Membership - Location Id');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` SET TAGS ('dbx_subdomain' = 'store_operations');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` SET TAGS ('dbx_association_edges' = 'store.store_format,promotion.promo_offer');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ALTER COLUMN `format_offer_eligibility_id` SET TAGS ('dbx_business_glossary_term' = 'Format Offer Eligibility Identifier');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Creator User Identifier');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ALTER COLUMN `associate_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ALTER COLUMN `associate_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Format Offer Eligibility - Store Format Id');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Format Offer Eligibility - Promo Offer Id');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Format Eligibility End Date');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Format Eligibility Start Date');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ALTER COLUMN `localized_minimum_purchase` SET TAGS ('dbx_business_glossary_term' = 'Localized Minimum Purchase Threshold');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ALTER COLUMN `priority_rank` SET TAGS ('dbx_business_glossary_term' = 'Format-Specific Priority Rank');
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` SET TAGS ('dbx_subdomain' = 'store_operations');
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` SET TAGS ('dbx_association_edges' = 'store.store_location,fulfillment.carrier');
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` ALTER COLUMN `carrier_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Store Carrier Agreement Identifier');
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Store Carrier Agreement - Fulfillment Carrier Id');
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store Carrier Agreement - Location Id');
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` ALTER COLUMN `active_status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Active Status');
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` ALTER COLUMN `cutoff_time_local` SET TAGS ('dbx_business_glossary_term' = 'Store-Specific Cutoff Time');
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` ALTER COLUMN `pickup_frequency` SET TAGS ('dbx_business_glossary_term' = 'Carrier Pickup Frequency');
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` ALTER COLUMN `priority_rank` SET TAGS ('dbx_business_glossary_term' = 'Carrier Priority Rank');
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` ALTER COLUMN `volume_commitment_monthly` SET TAGS ('dbx_business_glossary_term' = 'Monthly Volume Commitment');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` SET TAGS ('dbx_subdomain' = 'location_management');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ALTER COLUMN `sales_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory Identifier');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ALTER COLUMN `parent_sales_territory_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ALTER COLUMN `postal_code_range_end` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ALTER COLUMN `postal_code_range_end` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ALTER COLUMN `postal_code_range_start` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ALTER COLUMN `postal_code_range_start` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` SET TAGS ('dbx_subdomain' = 'retail_performance');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `store_profit_loss_id` SET TAGS ('dbx_business_glossary_term' = 'Store Profit & Loss (P&L) ID');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `atv_amount` SET TAGS ('dbx_business_glossary_term' = 'Average Transaction Value (ATV) Amount');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `cogs_amount` SET TAGS ('dbx_business_glossary_term' = 'Cost of Goods Sold (COGS) Amount');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `comp_sales_flag` SET TAGS ('dbx_business_glossary_term' = 'Comparable Store Sales (Comp Sales) Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `comp_sales_growth_percent` SET TAGS ('dbx_business_glossary_term' = 'Comparable Store Sales (Comp Sales) Growth Percent');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `ebitda_amount` SET TAGS ('dbx_business_glossary_term' = 'Earnings Before Interest, Taxes, Depreciation, and Amortization (EBITDA) Amount');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `ebitda_percent` SET TAGS ('dbx_business_glossary_term' = 'Earnings Before Interest, Taxes, Depreciation, and Amortization (EBITDA) Percent');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Profit & Loss (P&L) Notes');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `pl_status` SET TAGS ('dbx_business_glossary_term' = 'Profit & Loss (P&L) Status');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `pl_status` SET TAGS ('dbx_value_regex' = 'preliminary|final|restated');
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ALTER COLUMN `upt` SET TAGS ('dbx_business_glossary_term' = 'Units Per Transaction (UPT)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` SET TAGS ('dbx_subdomain' = 'store_operations');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `ship_from_store_node_id` SET TAGS ('dbx_business_glossary_term' = 'Ship-from-Store (SFS) Fulfillment Node ID');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `inventory_node_id` SET TAGS ('dbx_business_glossary_term' = 'Inventory Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ALTER COLUMN `carrier_account_number` SET TAGS ('dbx_confidential' = 'true');
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
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` SET TAGS ('dbx_subdomain' = 'retail_performance');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `direct_store_delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Direct Store Delivery (DSD) Receiving ID');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ap Invoice Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `inbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Inbound Shipment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `inbound_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Appointment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) ID');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `inventory_node_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Inventory Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `delivery_window_end` SET TAGS ('dbx_business_glossary_term' = 'Delivery Window End Time');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `delivery_window_start` SET TAGS ('dbx_business_glossary_term' = 'Delivery Window Start Time');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `driver_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `driver_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `driver_signature_captured` SET TAGS ('dbx_business_glossary_term' = 'Driver Signature Captured Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `invoice_match_status` SET TAGS ('dbx_value_regex' = 'matched|unmatched|variance_within_tolerance|variance_exceeds_tolerance|pending_reconciliation');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Receiving Notes');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `on_time_delivery_flag` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `receipt_status` SET TAGS ('dbx_value_regex' = 'accepted|partially_accepted|rejected|pending_review|disputed');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `receiving_location` SET TAGS ('dbx_value_regex' = 'receiving_dock|back_room|sales_floor|cooler|freezer');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_value_regex' = 'pending|reconciled|disputed|closed');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `scan_based_trading_flag` SET TAGS ('dbx_business_glossary_term' = 'Scan-Based Trading (SBT) Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `temperature_check_required` SET TAGS ('dbx_business_glossary_term' = 'Temperature Check Required Flag');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `temperature_check_result` SET TAGS ('dbx_value_regex' = 'passed|failed|not_applicable|not_performed');
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ALTER COLUMN `temperature_reading` SET TAGS ('dbx_business_glossary_term' = 'Temperature Reading (Fahrenheit)');
ALTER TABLE `vibe_retail_v1`.`store`.`region` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`store`.`region` SET TAGS ('dbx_subdomain' = 'location_management');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Identifier');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `hq_address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `hq_address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `hq_city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `hq_city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `hq_postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `hq_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `region_manager` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `region_manager_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`store`.`region` ALTER COLUMN `region_manager_email` SET TAGS ('dbx_pii_email' = 'true');
