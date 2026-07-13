-- Schema for Domain: product | Business:  | Version: v2_ecm
-- Generated on: 2026-07-13 15:03:54

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`product` COMMENT 'SSOT for the commercial vehicle product catalog and program portfolio. Owns nameplate definitions, model year program plans, option and package configurations, BOM (Bill of Materials) product structures, MSRP price books, feature-to-market availability matrices, and SKU (Stock Keeping Unit) structures. Distinct from engineering (which owns technical design data) and vehicle (which owns VIN-level production instances).';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`bom_header` (
    `bom_header_id` BIGINT COMMENT 'Unique identifier for the BOM header record. Primary key for the commercial product-level BOM structure.',
    `bom_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_bom. Business justification: Product BOM generation uses the Engineering BOM version; needed for the BOM Release Report and change control.',
    `adas_level` STRING COMMENT 'The SAE autonomy level supported by this BOM configuration. L0 = no automation; L1 = driver assistance; L2 = partial automation; L3 = conditional automation; L4 = high automation; L5 = full automation. Drives Electronic Control Unit (ECU) content and software Over-the-Air (OTA) update requirements.. Valid values are `L0|L1|L2|L3|L4|L5`',
    `alternative_bom_group` STRING COMMENT 'Grouping identifier for alternative BOM configurations that serve the same functional purpose but differ in sourcing, supplier, or regional requirements. Supports supply chain flexibility and dual-sourcing strategies.. Valid values are `^[A-Z0-9_]{1,20}$`',
    `approved_by` STRING COMMENT 'The user ID or name of the product manager, engineering lead, or quality authority who approved this BOM for production release. Supports accountability and PPAP documentation requirements.. Valid values are `^[A-Z0-9_]{3,50}$`',
    `approved_timestamp` TIMESTAMP COMMENT 'The date and time when this BOM was formally approved for production use. Milestone timestamp for traceability and regulatory compliance documentation.',
    `base_unit_of_measure` STRING COMMENT 'The unit in which the BOM header quantity is expressed. Typically EA (each) for complete vehicle assemblies or KIT for bundled option packages.. Valid values are `EA|PC|SET|KIT|ASSY`',
    `change_number` STRING COMMENT 'The most recent engineering change order identifier that modified this BOM. Links to PLM change management workflows and supports traceability for Failure Mode and Effects Analysis (FMEA) and corrective actions.. Valid values are `^ECO-[A-Z0-9]{6,15}$`',
    `configuration_profile` STRING COMMENT 'A coded representation of the option and feature set included in this BOM. Used for variant configuration in SAP SD, dealer ordering systems (DMS), and customer configurators.. Valid values are `^[A-Z0-9_]{3,30}$`',
    `connectivity_package` STRING COMMENT 'The level of connected vehicle and telematics capability included in this BOM. Basic = 4G LTE; Premium = 5G with cloud services; V2X = Vehicle-to-Everything communication for smart city integration.. Valid values are `none|basic|premium|V2X`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this BOM header record was first created in the system. Audit trail for data lineage and compliance with ISO 9001 quality management documentation requirements.',
    `effective_from_date` DATE COMMENT 'The date from which this BOM version becomes valid and applicable for production, sales configuration, and order fulfillment. Aligns with model year start or mid-year product refresh timing.',
    `effective_to_date` DATE COMMENT 'The date until which this BOM version remains valid. Nullable for open-ended BOMs. Used to manage model year transitions, End of Production (EOP), and product phase-out scenarios.',
    `emissions_standard` STRING COMMENT 'The regulatory emissions certification standard that this BOM configuration meets. Determines legal salability in jurisdictions with emissions regulations (EPA, CARB, UNECE).. Valid values are `EPA_TIER3|CARB_LEV3|EURO6|EURO7|CHINA6|BS6`',
    `engineering_release_date` DATE COMMENT 'The date on which the engineering design for this BOM was formally released from the Product Lifecycle Management (PLM) system (Teamcenter, Windchill) to manufacturing. Marks the transition from design to production readiness.',
    `eop_date` DATE COMMENT 'The planned or actual date when series production ceases for this BOM configuration. Triggers service parts planning, warranty reserve calculations, and dealer inventory clearance programs.',
    `field_service_kit_flag` BOOLEAN COMMENT 'Whether this BOM is a field service kit BOM',
    `homologation_status` STRING COMMENT 'The regulatory approval state for this BOM configuration. Certified BOMs have passed all required safety, emissions, and compliance testing (NCAP, FMVSS, WLTP). Required for legal sale and registration in target markets.. Valid values are `pending|approved|certified|rejected|expired`',
    `is_configurable` BOOLEAN COMMENT 'Indicates whether this BOM supports customer-selectable options and variant configuration. True for BOMs with option packages; False for fixed-configuration BOMs. Drives dealer ordering system behavior and customer configurator logic.',
    `lot_size_minimum` STRING COMMENT 'The minimum production batch quantity for which this BOM is economically viable. Drives production scheduling, changeover planning, and capacity utilization in Manufacturing Execution Systems (MES).',
    `market_region` STRING COMMENT 'The geographic market or regulatory region for which this BOM is configured. Drives homologation requirements (UNECE, Euro NCAP, NHTSA), emissions standards (EPA, CARB, WLTP), and localized feature content. [ENUM-REF-CANDIDATE: NAM|EUR|CHN|JPN|MEA|LATAM|APAC — 7 candidates stripped; promote to reference product]',
    `model_year` STRING COMMENT 'The model year designation for which this BOM is applicable. Critical for automotive product lifecycle management, regulatory compliance (CAFE, EPA ratings), and dealer ordering systems.',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this BOM header record was last updated. Supports change tracking, audit trails, and synchronization with PLM and ERP systems.',
    `msrp_base_amount` DECIMAL(18,2) COMMENT 'The baseline MSRP for this BOM configuration before options, packages, and destination charges. Used for dealer pricing, customer quotations, and competitive positioning. Currency is USD unless otherwise specified in market-specific price books.',
    `nameplate_code` STRING COMMENT 'The brand or model nameplate identifier (e.g., F-150, Camry, Model_S) that this BOM supports. Links to the commercial product catalog and marketing nomenclature.. Valid values are `^[A-Z0-9_]{3,20}$`',
    `notes` STRING COMMENT 'Free-text field for additional context, special instructions, or cross-references related to this BOM. May include links to Technical Service Bulletins (TSB), engineering memos, or supplier coordination notes.',
    `plant_code` STRING COMMENT 'The production plant or assembly facility where this BOM is applicable. Supports multi-plant manufacturing strategies, regional sourcing variations, and Just-in-Time (JIT) / Just-in-Sequence (JIS) supply chain execution.. Valid values are `^[A-Z0-9]{4,10}$`',
    `powertrain_type` STRING COMMENT 'The propulsion system category for this BOM. ICE = Internal Combustion Engine; HEV = Hybrid Electric Vehicle; PHEV = Plug-in Hybrid Electric Vehicle; BEV = Battery Electric Vehicle; FCEV = Fuel Cell Electric Vehicle. Drives component selection, regulatory compliance (EPA, CARB), and dealer training requirements.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `revision_level` STRING COMMENT 'Version identifier for this BOM iteration. Incremented with each engineering change order (ECO) or product configuration update. Supports traceability for Production Part Approval Process (PPAP) and Advanced Product Quality Planning (APQP).. Valid values are `^[A-Z0-9]{1,10}$`',
    `safety_certification_level` STRING COMMENT 'The crash test rating achieved by this BOM configuration from New Car Assessment Programme (NCAP) testing. Influences marketing claims, insurance premiums, and regulatory compliance in target markets.. Valid values are `5_star|4_star|3_star|not_rated|pending`',
    `sop_date` DATE COMMENT 'The planned or actual date when series production begins for this BOM configuration. Critical milestone for supply chain activation, dealer allocation planning, and launch readiness.',
    `ssot_governance_note` STRING COMMENT 'SSOT ownership governance note for this catalog/supply entity; documents domain ownership and preservation guardrails.',
    `standard_cost_amount` DECIMAL(18,2) COMMENT 'The planned manufacturing cost for this BOM at standard production volumes. Includes material, labor, and overhead. Used for margin analysis, make-vs-buy decisions, and financial planning. Currency is USD unless otherwise specified.',
    `bom_header_status` STRING COMMENT 'Current lifecycle state of the BOM header. Active BOMs are in production use; superseded BOMs have been replaced by newer revisions; obsolete BOMs are end-of-life; frozen BOMs are locked for regulatory or homologation purposes.. Valid values are `draft|active|superseded|obsolete|frozen|pending_approval`',
    `total_assembly_weight_kg` DECIMAL(18,2) COMMENT 'The cumulative weight of all components in this BOM, expressed in kilograms. Critical for vehicle curb weight calculation, Corporate Average Fuel Economy (CAFE) compliance, and freight logistics planning.',
    `total_component_count` STRING COMMENT 'The total number of distinct component line items (BOM components) included in this BOM structure. Used for complexity assessment, supply chain planning, and Material Requirements Planning (MRP).',
    `bom_header_type` STRING COMMENT 'Classification of the BOM purpose. Commercial BOMs are product-domain owned structures for SKU definition and pricing; engineering BOMs are design structures owned by engineering domain; service BOMs support after-sales parts; manufacturing BOMs are plant-specific production structures.. Valid values are `commercial|engineering|service|manufacturing|planning|sales`',
    `usage` STRING COMMENT 'The intended application context for this BOM. Production BOMs are for series manufacturing; prototype BOMs support R&D; CKD (Completely Knocked Down) and SKD (Semi Knocked Down) BOMs are for export assembly operations. [ENUM-REF-CANDIDATE: production|prototype|pre_series|pilot|service|CKD|SKD — 7 candidates stripped; promote to reference product]',
    `variant_code` STRING COMMENT 'Product variant or trim level identifier (e.g., LX, Sport, Premium, AWD). Differentiates configurations within a nameplate for option package and feature matrix management.. Valid values are `^[A-Z0-9_]{2,15}$`',
    `vin_pattern` STRING COMMENT 'The VIN prefix or pattern template associated with this BOM configuration. Positions 1-11 of the VIN encode manufacturer, plant, model, and body style. Supports VIN decoding and vehicle domain linkage.. Valid values are `^[A-HJ-NPR-Z0-9*]{17}$`',
    `warranty_program_code` STRING COMMENT 'The standard warranty coverage program applicable to this BOM configuration. Links to warranty claim processing, service bulletin distribution, and Total Cost of Ownership (TCO) calculations.. Valid values are `^[A-Z0-9_]{3,15}$`',
    CONSTRAINT pk_bom_header PRIMARY KEY(`bom_header_id`)
) COMMENT 'Product-level BOM (Bill of Materials) header record representing the commercial product structure for a given SKU or model year program. Captures BOM number, BOM type (commercial/engineering/service), effective date range, revision level, plant applicability, BOM status (active/superseded/obsolete), and total component count. This is the commercial BOM owned by the product domain — distinct from the engineering BOM managed in Teamcenter/Windchill, which is owned by the engineering domain.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`product_bom_line` (
    `product_bom_line_id` BIGINT COMMENT 'Primary key for local product_bom_line reference',
    `engineering_bom_line_id` BIGINT COMMENT 'FK reference to SSOT engineering.engineering_bom_line',
    `part_master_id` BIGINT COMMENT 'FK to engineering.part_master for BOM line part reference',
    `ssot_governance_note` STRING COMMENT '',
    CONSTRAINT pk_product_bom_line PRIMARY KEY(`product_bom_line_id`)
) COMMENT 'Reference to SSOT owner engineering.engineering_bom_line. Individual component line items within a product BOM (Bill of Materials). Captures BOM line number, part number, part description, part type (raw material/sub-assembly/purchased component/fastener), quantity per vehicle, unit of measure, effective date range, plant applicability, alternative item group, scrap factor percentage, and PPAP (Production Part Approval Process) status. Enables product cost rollup, MRP (Material Requirements Planning) explosion, and supply chain sourcing alignment.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`product_segment` (
    `product_segment_id` BIGINT COMMENT 'Primary key for local product_segment reference',
    `aftersales_nameplate_id` BIGINT COMMENT 'FK to product.aftersales_nameplate for segment-to-nameplate classification',
    `customer_segment_id` BIGINT COMMENT 'FK reference to SSOT customer.customer_segment',
    `ssot_governance_note` STRING COMMENT '',
    CONSTRAINT pk_product_segment PRIMARY KEY(`product_segment_id`)
) COMMENT 'Reference to SSOT owner customer.customer_segment. Reference classification of vehicle market segments used to position nameplates competitively (e.g., Compact Car, Midsize SUV, Full-Size Pickup, Commercial Van, Luxury Sedan, Electric Crossover). Captures segment code, segment name, segment hierarchy level, parent segment, SAE/industry classification code, competitive set definition, and applicable regulatory category. Used in market planning, competitive benchmarking, CAFE fleet averaging, and sales reporting.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`catalog_publication` (
    `catalog_publication_id` BIGINT COMMENT 'Unique identifier for the catalog publication event. Primary key.',
    `employee_id` BIGINT COMMENT 'Identifier of the user who approved the catalog for publication. Supports governance and compliance requirements for catalog release authorization.',
    `catalog_version_id` BIGINT COMMENT 'Reference to the specific catalog version being published. Links to the catalog version master.',
    `configurator_session_id` BIGINT COMMENT '',
    `aftersales_nameplate_id` BIGINT COMMENT '',
    `primary_catalog_employee_id` BIGINT COMMENT 'Identifier of the user or system account that executed the publication event. Used for audit trail and accountability.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the user or system account that executed the publication event. Used for audit trail and accountability.',
    `superseded_by_publication_catalog_publication_id` BIGINT COMMENT 'Reference to the newer publication that replaces this one, if applicable. Supports publication version chain tracking.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the catalog publication was formally approved for release. Part of the publication lifecycle audit trail.',
    `approved_by_user_name` STRING COMMENT 'Full name of the approver for human-readable audit trail.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the publication record was first created in the system. Represents the start of the publication preparation process.',
    `catalog_publication_date` TIMESTAMP COMMENT 'Date and time when the catalog was formally published and released to the target system or channel. Represents the actual distribution event timestamp.',
    `distribution_confirmation_flag` BOOLEAN COMMENT 'Indicates whether the target system has confirmed successful receipt and processing of the published catalog. True if confirmed, False if pending or failed.',
    `distribution_confirmation_timestamp` TIMESTAMP COMMENT 'Date and time when the target system confirmed successful receipt of the catalog publication. Nullable if confirmation is pending or not received.',
    `distribution_method` STRING COMMENT 'Technical method used to distribute the catalog: push (system-initiated send), pull (consumer-initiated retrieval), batch (scheduled bulk transfer), real-time (immediate synchronous), or scheduled (time-based automated).. Valid values are `push|pull|batch|real_time|scheduled`',
    `distribution_retry_count` STRING COMMENT 'Number of times the system attempted to distribute this catalog publication to the target system. Used for monitoring distribution reliability and troubleshooting failures.',
    `effective_end_date` DATE COMMENT 'Date when the published catalog expires and is no longer valid for new orders or configurations. Nullable for open-ended publications.',
    `effective_start_date` DATE COMMENT 'Date when the published catalog becomes active and valid for use in ordering, configuration, and sales processes. May differ from publication date to allow advance distribution.',
    `field_service_catalog_flag` BOOLEAN COMMENT 'Whether this catalog publication includes field service parts',
    `file_checksum` STRING COMMENT 'Cryptographic hash (e.g., MD5, SHA-256) of the published catalog file to ensure data integrity during transmission and detect corruption.',
    `file_name` STRING COMMENT 'Name of the file or data package containing the published catalog, if applicable. Used for file-based distribution tracking.',
    `file_size_bytes` BIGINT COMMENT 'Size of the published catalog file in bytes. Used for distribution monitoring and capacity planning.',
    `format` STRING COMMENT 'Technical file or data format of the published catalog: Extensible Markup Language (XML), JavaScript Object Notation (JSON), Comma-Separated Values (CSV), Portable Document Format (PDF), Excel spreadsheet, Electronic Data Interchange (EDI) X12, EDIFACT, or proprietary format. [ENUM-REF-CANDIDATE: xml|json|csv|pdf|excel|edi_x12|edifact|proprietary — 8 candidates stripped; promote to reference product]',
    `language_code` STRING COMMENT 'Two-letter ISO 639-1 language code for the catalog content (e.g., en, fr, de, es, ja). Supports multilingual catalog distribution.. Valid values are `^[a-z]{2}$`',
    `last_distribution_error` STRING COMMENT 'Error message or code from the most recent failed distribution attempt, if applicable. Supports troubleshooting and root cause analysis.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the publication record was last updated. Tracks the most recent change to publication metadata or status.',
    `model_year` STRING COMMENT 'The model year (MY) of the vehicle catalog being published, representing the production year designation for the vehicles in this catalog (e.g., 2024, 2025).',
    `nameplate_count` STRING COMMENT 'Number of distinct nameplates (vehicle model lines) included in this catalog publication. Supports publication scope tracking.',
    `notes` STRING COMMENT 'Free-text notes or comments about the publication event, including special instructions, known issues, or distribution details.',
    `number` STRING COMMENT 'Business identifier for the publication event, formatted as PUB-YYYYMMDD-XXXXXX for external reference and audit trail.. Valid values are `^PUB-[0-9]{8}-[A-Z0-9]{6}$`',
    `priority_level` STRING COMMENT 'Business priority of the publication: critical (urgent regulatory or safety update), high (important product launch), normal (routine catalog update), or low (minor correction).. Valid values are `critical|high|normal|low`',
    `published_by_user_name` STRING COMMENT 'Full name of the user who published the catalog, for human-readable audit trail and reporting.',
    `recall_reason` STRING COMMENT 'Explanation for why the catalog publication was recalled or withdrawn, if applicable. Captures business justification for publication reversal.',
    `recall_timestamp` TIMESTAMP COMMENT 'Date and time when the catalog publication was recalled or withdrawn. Part of the publication lifecycle audit trail.',
    `record_count` STRING COMMENT 'Total number of catalog records (e.g., Stock Keeping Units (SKUs), configurations, options) included in this publication. Used for validation and reconciliation.',
    `regulatory_filing_date` DATE COMMENT 'Date when the catalog was submitted to regulatory authorities, if applicable. Supports compliance audit trail.',
    `regulatory_filing_reference` STRING COMMENT 'Reference number or identifier for the associated regulatory filing submission, if applicable. Links catalog publication to compliance documentation.',
    `regulatory_filing_required_flag` BOOLEAN COMMENT 'Indicates whether this catalog publication requires submission to regulatory authorities (e.g., National Highway Traffic Safety Administration (NHTSA), Environmental Protection Agency (EPA), California Air Resources Board (CARB)). True if regulatory filing is required.',
    `ssot_governance_note` STRING COMMENT 'SSOT owner in this domain per governance; consolidated master data with cross-domain references maintained via foreign keys.',
    `catalog_publication_status` STRING COMMENT 'Current lifecycle state of the publication: draft (in preparation), approved (ready for release), published (actively distributed), recalled (withdrawn due to error), superseded (replaced by newer version), or archived (historical record).. Valid values are `draft|approved|published|recalled|superseded|archived`',
    `target_channel` STRING COMMENT 'Distribution channel or interface through which the catalog is published: Dealer Management System (DMS), web configurator, mobile application, Application Programming Interface (API), File Transfer Protocol (FTP), Electronic Data Interchange (EDI), regulatory portal, or dealer portal. [ENUM-REF-CANDIDATE: dms|web_configurator|mobile_app|api|ftp|edi|regulatory_portal|dealer_portal — 8 candidates stripped; promote to reference product]',
    `target_country_code` STRING COMMENT 'Three-letter ISO country code for the specific country market of this publication (e.g., USA, CAN, DEU, JPN). Supports country-specific catalog requirements and regulatory compliance.. Valid values are `^[A-Z]{3}$`',
    `target_region` STRING COMMENT 'Geographic region or market for which this catalog publication is intended (e.g., North America, Europe, Asia-Pacific). Supports regional catalog variations and compliance requirements.',
    `target_system` STRING COMMENT 'Name or identifier of the downstream system receiving this publication (e.g., CDK Global DMS, Salesforce Automotive Cloud, dealer portal, consumer configurator web application, NHTSA filing system).',
    `trim_count` STRING COMMENT 'Number of distinct trim levels included in this catalog publication. Supports publication scope tracking and validation.',
    `catalog_publication_type` STRING COMMENT 'Category of publication indicating the target audience: dealer ordering systems (DMS), consumer configurators, regulatory filings (NHTSA/EPA), internal sales tools, supplier portals, or fleet management systems.. Valid values are `dealer|consumer|regulatory|internal|supplier|fleet`',
    `validation_error_count` STRING COMMENT 'Number of validation errors detected during pre-publication quality checks. Zero indicates clean publication.',
    `validation_status` STRING COMMENT 'Result of pre-publication data quality validation checks: passed (all validations successful), failed (critical errors detected), warning (non-critical issues found), or not_validated (validation skipped).. Valid values are `passed|failed|warning|not_validated`',
    `validation_warning_count` STRING COMMENT 'Number of validation warnings (non-critical issues) detected during pre-publication quality checks.',
    CONSTRAINT pk_catalog_publication PRIMARY KEY(`catalog_publication_id`)
) COMMENT 'Tracks the formal publication events of the commercial product catalog to downstream consumers — dealer ordering systems (DMS), consumer configurators, sales portals, and regulatory filings. Captures publication ID, catalog version, publication type (dealer/consumer/regulatory/internal), target system/channel, publication date, effective date range, published-by user, publication status (draft/approved/published/recalled), and distribution confirmation. Provides an audit trail of when and to whom catalog versions were released.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`package_availability` (
    `package_availability_id` BIGINT COMMENT 'Primary key for the PackageAvailability association',
    `aftersales_option_package_id` BIGINT COMMENT 'Foreign key linking to the option package',
    `catalog_publication_id` BIGINT COMMENT 'Foreign key linking to product.catalog_publication. Business justification: Package availability records belong to a specific catalog publication; linking them enables traceability of which publication defines the availability status and launch date.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to the dealership',
    `field_install_available_flag` BOOLEAN COMMENT 'Whether field installation is available for this package',
    `launch_date` DATE COMMENT 'Date when the option package becomes available for sale at the dealer',
    `ssot_governance_note` STRING COMMENT 'SSOT owner in this domain per governance; consolidated master data with cross-domain references maintained via foreign keys.',
    `package_availability_status` STRING COMMENT 'Current status of the package at the dealer (e.g., Available, Discontinued, Pending)',
    CONSTRAINT pk_package_availability PRIMARY KEY(`package_availability_id`)
) COMMENT 'Associates an option package with a dealership, capturing the availability status and launch date for that package at the dealer. Each record links one option package to one dealership and stores attributes that belong only to this relationship.. Existence Justification: Dealerships actively manage which option packages they carry, setting an availability status and launch date for each package. Each option package can be offered by many dealerships, and each dealership can offer many option packages, creating a many‑to‑many relationship that carries its own attributes.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` (
    `pricing_condition_assignment_id` BIGINT COMMENT 'Primary key for the PricingConditionAssignment association',
    `billing_price_condition_id` BIGINT COMMENT 'Foreign key linking to the pricing condition',
    `catalog_version_id` BIGINT COMMENT 'Foreign key linking to product.catalog_version. Business justification: Pricing condition assignments are defined per catalog version; linking them provides versioned pricing context for each assignment.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to the vehicle SKU',
    `effective_end_date` DATE COMMENT 'Date after which the condition no longer applies to the SKU',
    `effective_start_date` DATE COMMENT 'Date from which the condition becomes applicable to the SKU',
    `field_service_condition_flag` BOOLEAN COMMENT 'Whether this pricing condition applies to field service',
    `ssot_governance_note` STRING COMMENT 'SSOT owner in this domain per governance; consolidated master data with cross-domain references maintained via foreign keys.',
    `pricing_condition_assignment_status` STRING COMMENT 'Lifecycle status of the condition assignment (e.g., active, expired)',
    `pricing_condition_assignment_type` STRING COMMENT 'Type of pricing condition (e.g., discount, tax, freight)',
    `value` DECIMAL(18,2) COMMENT 'Monetary or percentage value of the pricing condition for this SKU',
    CONSTRAINT pk_pricing_condition_assignment PRIMARY KEY(`pricing_condition_assignment_id`)
) COMMENT 'Represents the assignment of a pricing condition to a specific vehicle SKU. Each record links one SKU to one pricing condition and captures attributes that exist only in the context of this assignment, such as the condition value and its validity period.. Existence Justification: A pricing condition (e.g., discount, tax, freight) can be applied to many vehicle SKUs, and each SKU can have multiple pricing conditions such as MSRP, discounts, taxes, and fees. The pricing team actively creates, updates, and deletes these assignments, and each assignment carries attributes like value, validity dates, type, and status. This operational management makes the relationship a true many‑to‑many business entity.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`catalog_version` (
    `catalog_version_id` BIGINT COMMENT 'Primary key for catalog_version',
    `msrp_price_book_id` BIGINT COMMENT 'Identifier of the price book associated with this catalog version.',
    `previous_catalog_version_id` BIGINT COMMENT 'Self-referencing FK on catalog_version (previous_catalog_version_id)',
    `approval_status` STRING COMMENT 'Approval workflow status for the catalog version.',
    `approved_by` STRING COMMENT 'Name of the person who approved the catalog version.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when the catalog version was approved.',
    `change_summary` STRING COMMENT 'Brief summary of major changes compared to the previous catalog version.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the catalog version record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 currency code used for pricing in this catalog version.',
    `effective_end_date` DATE COMMENT 'Date when the catalog version is superseded or expires.',
    `effective_start_date` DATE COMMENT 'Date when the catalog version becomes effective for sales.',
    `field_service_content_flag` BOOLEAN COMMENT 'Whether this catalog version includes field service content',
    `is_current` BOOLEAN COMMENT 'Indicates whether this version is the currently active catalog.',
    `catalog_version_name` STRING COMMENT 'Descriptive name for the catalog version.',
    `number` STRING COMMENT 'Human‑readable version identifier (e.g., 2024Q1, v2.3).',
    `region_coverage` STRING COMMENT 'Geographic regions where this catalog version is offered.',
    `release_notes` STRING COMMENT 'Free‑form notes describing changes, new features, or fixes in this version.',
    `segment` STRING COMMENT 'Primary market segment targeted by this catalog version.',
    `sku_structure_code` BIGINT COMMENT 'Identifier of the SKU structure definition used for this catalog version.',
    `ssot_governance_note` STRING COMMENT 'SSOT owner in this domain per governance; consolidated master data with cross-domain references maintained via foreign keys.',
    `catalog_version_status` STRING COMMENT 'Current lifecycle status of the catalog version.',
    `total_models` STRING COMMENT 'Number of distinct vehicle models included in this catalog version.',
    `total_options` STRING COMMENT 'Number of option packages defined in this catalog version.',
    `catalog_version_type` STRING COMMENT 'Category of catalog version indicating its purpose.',
    `updated_by` STRING COMMENT 'User or system that performed the latest update to the catalog version record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the catalog version record.',
    `created_by` STRING COMMENT 'User or system that created the catalog version record.',
    CONSTRAINT pk_catalog_version PRIMARY KEY(`catalog_version_id`)
) COMMENT 'Master reference table for catalog_version. Referenced by catalog_version_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`sku` (
    `sku_id` BIGINT COMMENT 'Primary key for sku',
    `aftersales_trim_level_id` BIGINT COMMENT 'FK to product.trim_level',
    `aftersales_body_style_id` BIGINT COMMENT 'FK to product.body_style',
    `aftersales_color_option_id` BIGINT COMMENT 'Foreign key linking to vehicle.aftersales_color_option. Business justification: Color option is a master list; replacing the free‑form color code with a FK normalizes color data and removes the redundant exterior_color_code column.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Sales posting for each SKU uses a specific GL account; required for accurate revenue GL mapping in AR invoices.',
    `homologation_record_id` BIGINT COMMENT 'Foreign key linking to compliance.homologation_record. Business justification: REQUIRED: Recall and warranty teams need to map each SKU to its homologation approval for regulatory reporting and certification traceability.',
    `aftersales_nameplate_id` BIGINT COMMENT 'Reference to the vehicle nameplate (brand model line) that this SKU belongs to.',
    `production_bom_id` BIGINT COMMENT 'Reference to the production BOM defining the complete parts and assembly structure for manufacturing this SKU.',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Required for Production Planning & Inventory Allocation report linking each vehicle SKU to its master inventory SKU for stock tracking, WIP allocation, and regulatory compliance.',
    `adas_level` STRING COMMENT 'The SAE automation level for the ADAS features included in this SKU (none, Level 1 through Level 5).. Valid values are `none|level_1|level_2|level_3|level_4|level_5`',
    `battery_capacity_kwh` DECIMAL(18,2) COMMENT 'The total battery pack energy capacity in kilowatt-hours for electric and plug-in hybrid vehicles. Null for non-electric powertrains.',
    `cargo_volume_cu_ft` DECIMAL(18,2) COMMENT 'The cargo area volume in cubic feet behind the rear seats.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this SKU record was first created in the system.',
    `curb_weight_lbs` STRING COMMENT 'The vehicle weight in pounds without passengers or cargo, but with all fluids and standard equipment.',
    `door_count` STRING COMMENT 'The total number of doors including passenger doors and rear hatch/trunk (e.g., 2, 4, 5).',
    `drivetrain_type` STRING COMMENT 'The drivetrain configuration: FWD (Front-Wheel Drive), RWD (Rear-Wheel Drive), AWD (All-Wheel Drive), or 4WD (Four-Wheel Drive).. Valid values are `FWD|RWD|AWD|4WD`',
    `electric_range_miles` DECIMAL(18,2) COMMENT 'The EPA-certified all-electric driving range in miles for BEV and PHEV configurations. Null for non-electric powertrains.',
    `emission_standard` STRING COMMENT 'The emissions certification standard this SKU complies with (e.g., EPA Tier 3, Euro 6d, CARB LEV III).',
    `engine_displacement_liters` DECIMAL(18,2) COMMENT 'The total engine displacement volume in liters for ICE and hybrid powertrains. Null for pure electric vehicles.',
    `eop_date` DATE COMMENT 'The date when production of this SKU configuration ended or is planned to end. Null for active SKUs with no planned discontinuation.',
    `epa_city_mpg` DECIMAL(18,2) COMMENT 'The EPA-certified city fuel economy rating in miles per gallon. Null for pure electric vehicles.',
    `epa_combined_mpg` DECIMAL(18,2) COMMENT 'The EPA-certified combined fuel economy rating in miles per gallon. Null for pure electric vehicles.',
    `epa_highway_mpg` DECIMAL(18,2) COMMENT 'The EPA-certified highway fuel economy rating in miles per gallon. Null for pure electric vehicles.',
    `field_parts_usage_eligible_flag` BOOLEAN COMMENT 'Whether this SKU is eligible for field parts usage',
    `fuel_type` STRING COMMENT 'The primary fuel or energy source for the powertrain. [ENUM-REF-CANDIDATE: gasoline|diesel|e85|cng|electric|hydrogen|hybrid — 7 candidates stripped; promote to reference product]',
    `gvwr_lbs` STRING COMMENT 'The maximum allowable total weight of the vehicle including passengers, cargo, and fluids, in pounds.',
    `horsepower` STRING COMMENT 'The maximum engine or motor power output in horsepower.',
    `interior_color_code` STRING COMMENT 'The manufacturer code identifying the interior color and material combination (e.g., black leather, beige cloth).. Valid values are `^[A-Z0-9]{3,8}$`',
    `interior_material_type` STRING COMMENT 'The primary upholstery material used for seats and interior surfaces.. Valid values are `cloth|leather|synthetic_leather|alcantara|vinyl`',
    `invoice_price_amount` DECIMAL(18,2) COMMENT 'The dealer invoice price for this SKU configuration, representing the base cost to the dealer before incentives.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this SKU record was last updated.',
    `lifecycle_status` STRING COMMENT 'The current lifecycle state of this SKU: planned (future), active (available for order), orderable (accepting orders), production (being built), phasing_out (limited availability), or discontinued (no longer available).. Valid values are `planned|active|orderable|production|phasing_out|discontinued`',
    `market_destination_code` STRING COMMENT 'The ISO country or regional market code indicating the regulatory and specification destination for this SKU (e.g., USA, CAN, EUR, CHN).. Valid values are `^[A-Z]{2,3}$`',
    `model_year` STRING COMMENT 'The model year designation for this SKU configuration, representing the production year cycle.',
    `msrp_amount` DECIMAL(18,2) COMMENT 'The manufacturers suggested retail price for this SKU configuration in the base currency, excluding destination charges and options.',
    `msrp_currency_code` STRING COMMENT 'The ISO 4217 three-letter currency code for the MSRP amount (e.g., USD, CAD, EUR).. Valid values are `^[A-Z]{3}$`',
    `ncap_safety_rating` STRING COMMENT 'The overall NCAP safety rating (1-5 stars) for this vehicle configuration. Null or not_rated if not yet tested.. Valid values are `^[1-5]$|not_rated`',
    `option_package_codes` STRING COMMENT 'Comma-separated list of option package codes included in this SKU configuration (e.g., technology package, premium audio, towing package).',
    `orderable_end_date` DATE COMMENT 'The date when this SKU will no longer be available for new customer orders. Null for active SKUs with no planned end date.',
    `orderable_start_date` DATE COMMENT 'The date when this SKU became or will become available for customer orders.',
    `powertrain_code` STRING COMMENT 'The engineering code identifying the engine or electric powertrain configuration, including displacement, fuel type, and power output characteristics.. Valid values are `^[A-Z0-9]{4,12}$`',
    `powertrain_type` STRING COMMENT 'The powertrain technology category: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), or FCEV (Fuel Cell Electric Vehicle).. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `seating_capacity` STRING COMMENT 'The maximum number of passenger seats in this vehicle configuration.',
    `sop_date` DATE COMMENT 'The date when production of this SKU configuration began or is planned to begin.',
    `ssot_governance_note` STRING COMMENT 'SSOT ownership governance note for this catalog/supply entity; documents domain ownership and preservation guardrails.',
    `torque_lb_ft` STRING COMMENT 'The maximum engine or motor torque output in pound-feet.',
    `towing_capacity_lbs` STRING COMMENT 'The maximum trailer weight this vehicle configuration can tow, in pounds. Null if not rated for towing.',
    `transmission_speed_count` STRING COMMENT 'The number of forward gears in the transmission (e.g., 6, 8, 10). Null for CVT and single-speed electric drivetrains.',
    `transmission_type` STRING COMMENT 'The transmission technology: manual, automatic, CVT (Continuously Variable Transmission), DCT (Dual-Clutch Transmission), or AMT (Automated Manual Transmission).. Valid values are `manual|automatic|cvt|dct|amt`',
    `vehicle_subscription_id` BIGINT COMMENT '',
    `wheelbase_inches` DECIMAL(18,2) COMMENT 'The distance between the front and rear axle centerlines in inches.',
    CONSTRAINT pk_sku PRIMARY KEY(`sku_id`)
) COMMENT 'SSOT for the orderable SKU (Stock Keeping Unit) — the fully specified, buildable vehicle configuration combining nameplate, MY, trim level, powertrain, body style, and option packages into a unique orderable unit. Captures SKU code, SKU description, body style, drivetrain type (FWD/RWD/AWD/4WD), engine/powertrain code, transmission type, exterior color code, interior color/material code, market destination code, and SKU lifecycle status. The SKU is the atomic unit used in order management, production scheduling, and dealer inventory.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` (
    `aftersales_trim_level_id` BIGINT COMMENT 'Unique identifier for the trim level. Primary key for the trim level entity.',
    `aftersales_nameplate_id` BIGINT COMMENT 'Reference to the parent nameplate (e.g., F-150, Mustang, Explorer) under which this trim level is offered.',
    `adas_level` STRING COMMENT 'The SAE automation level of the standard ADAS features included in this trim (none, Level 1, Level 2, Level 3).. Valid values are `none|level_1|level_2|level_3`',
    `availability_regions` STRING COMMENT 'Comma-separated list of geographic regions or markets where this trim level is available for sale (e.g., USA, CAN, MEX, EUR, CHN). Detailed region-to-trim mappings maintained in separate association tables.',
    `battery_capacity_kwh` DECIMAL(18,2) COMMENT 'Total battery pack capacity in kilowatt-hours for electric and plug-in hybrid vehicles. Null for ICE-only vehicles.',
    `body_style` STRING COMMENT 'The body style configuration for this trim level (e.g., sedan, coupe, SUV, pickup). Some nameplates may offer multiple body styles across different trim levels. [ENUM-REF-CANDIDATE: sedan|coupe|hatchback|wagon|suv|crossover|pickup|van|convertible — 9 candidates stripped; promote to reference product]',
    `cargo_volume_cu_ft` DECIMAL(18,2) COMMENT 'Total cargo volume in cubic feet behind the first row of seats. For pickups, represents bed volume.',
    `aftersales_trim_level_code` STRING COMMENT 'The internal alphanumeric code uniquely identifying this trim level within the nameplate and model year. Used in manufacturing, ordering, and dealer systems.. Valid values are `^[A-Z0-9]{2,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this trim level record was first created in the system.',
    `aftersales_trim_level_description` STRING COMMENT 'Detailed description of the trim level, including key features, positioning, and target customer segment. Used for marketing materials and dealer training.',
    `drivetrain` STRING COMMENT 'The drivetrain configuration: FWD (Front-Wheel Drive), RWD (Rear-Wheel Drive), AWD (All-Wheel Drive), or 4WD (Four-Wheel Drive).. Valid values are `FWD|RWD|AWD|4WD`',
    `electric_range_miles` STRING COMMENT 'EPA-rated all-electric driving range in miles for BEV and PHEV trim levels. Null for ICE-only vehicles.',
    `engine_displacement_liters` DECIMAL(18,2) COMMENT 'The engine displacement in liters for ICE and hybrid powertrains. Null for battery electric vehicles.',
    `eop_date` DATE COMMENT 'The date when production of this trim level ended or is planned to end. Used for phase-out planning and parts support.',
    `epa_city_mpg` STRING COMMENT 'EPA-rated fuel economy for city driving in miles per gallon. For electric vehicles, this represents MPGe (miles per gallon equivalent).',
    `epa_combined_mpg` STRING COMMENT 'EPA-rated combined fuel economy in miles per gallon. For electric vehicles, this represents MPGe.',
    `epa_highway_mpg` STRING COMMENT 'EPA-rated fuel economy for highway driving in miles per gallon. For electric vehicles, this represents MPGe.',
    `field_service_coverage_level` STRING COMMENT 'Level of field service coverage included with this trim',
    `fuel_type` STRING COMMENT 'The primary fuel type for this trim level (gasoline, diesel, E85, electric, hydrogen, or hybrid).. Valid values are `gasoline|diesel|E85|electric|hydrogen|hybrid`',
    `horsepower` STRING COMMENT 'The rated horsepower output of the powertrain. For electric vehicles, represents the combined motor output.',
    `invoice_price` DECIMAL(18,2) COMMENT 'The wholesale price charged to dealers for this trim level in base configuration. Used for dealer margin calculations and incentive programs.',
    `is_fleet_eligible` BOOLEAN COMMENT 'Indicates whether this trim level is available for fleet and commercial sales programs.',
    `is_special_edition` BOOLEAN COMMENT 'Indicates whether this trim level is a limited or special edition with unique features, badging, or production volume constraints.',
    `market_segment` STRING COMMENT 'The target market segment for this trim level, indicating the positioning strategy and customer demographic focus. [ENUM-REF-CANDIDATE: entry|mid|premium|luxury|performance|commercial|fleet — 7 candidates stripped; promote to reference product]',
    `model_year` STRING COMMENT 'The model year for which this trim level is defined. Represents the commercial year designation, not the calendar year of production.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this trim level record was last modified in the system.',
    `msrp_base_price` DECIMAL(18,2) COMMENT 'The manufacturers suggested retail price for this trim level in the base configuration, excluding options, packages, destination charges, and taxes. Expressed in the home currency.',
    `msrp_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the MSRP base price (e.g., USD, EUR, CAD, GBP).. Valid values are `^[A-Z]{3}$`',
    `aftersales_trim_level_name` STRING COMMENT 'The commercial marketing name of the trim level (e.g., Base, XL, XLT, Lariat, Platinum, Limited, King Ranch, Raptor). This is the customer-facing designation.',
    `ncap_overall_rating` STRING COMMENT 'Overall safety rating from NCAP testing (1-5 stars). May vary by market (NHTSA, Euro NCAP, etc.).',
    `payload_capacity_lbs` STRING COMMENT 'Maximum payload capacity in pounds. Particularly relevant for pickup trucks and commercial vehicles.',
    `powertrain_type` STRING COMMENT 'The primary powertrain technology for this trim level: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), or FCEV (Fuel Cell Electric Vehicle).. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `production_status` STRING COMMENT 'Current production lifecycle status of this trim level: planned (not yet in production), pre_production (tooling and validation), active (in production), discontinued (no longer produced but still sold), or end_of_life (fully retired).. Valid values are `planned|pre_production|active|discontinued|end_of_life`',
    `rank` STRING COMMENT 'Ordinal ranking of this trim level within the nameplate hierarchy, where lower numbers indicate entry-level trims and higher numbers indicate premium trims. Used for sorting and comparison.',
    `seating_capacity` STRING COMMENT 'The standard number of passenger seats in this trim level configuration. May vary with optional seating packages.',
    `sop_date` DATE COMMENT 'The date when production of this trim level began or is planned to begin. Critical milestone for manufacturing and supply chain planning.',
    `ssot_governance_note` STRING COMMENT 'SSOT owner in this domain per governance; consolidated master data with cross-domain references maintained via foreign keys.',
    `standard_features_summary` STRING COMMENT 'High-level summary of the standard features included in this trim level (e.g., engine type, transmission, infotainment system, safety features). Detailed feature-to-trim mappings are maintained in separate association tables.',
    `torque_lb_ft` STRING COMMENT 'The rated torque output in pound-feet. For electric vehicles, represents the combined motor torque.',
    `towing_capacity_lbs` STRING COMMENT 'Maximum towing capacity in pounds when properly equipped. Critical specification for trucks and SUVs.',
    `transmission_type` STRING COMMENT 'The standard transmission type for this trim level (e.g., 10-speed automatic, 6-speed manual, CVT, single-speed electric).',
    `warranty_basic_miles` STRING COMMENT 'Mileage limit of the basic bumper-to-bumper warranty in miles for this trim level.',
    `warranty_basic_months` STRING COMMENT 'Duration of the basic bumper-to-bumper warranty in months for this trim level.',
    `warranty_powertrain_miles` STRING COMMENT 'Mileage limit of the powertrain warranty in miles for this trim level.',
    `warranty_powertrain_months` STRING COMMENT 'Duration of the powertrain warranty in months for this trim level.',
    CONSTRAINT pk_aftersales_trim_level PRIMARY KEY(`aftersales_trim_level_id`)
) COMMENT 'Defines the commercial trim hierarchy for a model year program (e.g., Base, XL, XLT, Lariat, Platinum, Limited). Captures trim code, trim name, trim rank/order within the nameplate hierarchy, standard feature set description, MSRP base price, market segment positioning, availability regions, and active/inactive lifecycle status. Trim levels are the primary commercial differentiation layer between the nameplate and individual option packages.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` (
    `aftersales_option_package_id` BIGINT COMMENT 'Primary key for local aftersales_option_package reference',
    `ssot_aftersales_option_package_id` BIGINT COMMENT 'FK reference to SSOT product.aftersales_option_package',
    `attachment_rate_percent` DECIMAL(18,2) COMMENT 'Historical attachment rate percentage indicating how often this option package is selected when available. Used for demand forecasting and production planning.',
    `available_markets` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes or market region codes where this option package is available for sale. Supports regional product portfolio management.',
    `available_model_years` STRING COMMENT 'Comma-separated list of model years (MY) for which this option package is available. Supports multi-year planning and phase-in/phase-out management.',
    `available_trim_levels` STRING COMMENT 'Comma-separated list of trim level codes where this option package can be ordered. Defines the commercial availability matrix by vehicle configuration.',
    `bom_reference_number` STRING COMMENT 'Reference to the engineering Bill of Materials (BOM) that defines the complete parts structure for this option package. Links commercial catalog to engineering product structure.',
    `aftersales_option_package_category` STRING COMMENT 'High-level functional category grouping for the option package used for catalog organization and customer navigation. [ENUM-REF-CANDIDATE: exterior|interior|technology|safety|performance|comfort|convenience|appearance — 8 candidates stripped; promote to reference product]',
    `aftersales_option_package_code` STRING COMMENT 'Manufacturer-assigned alphanumeric code uniquely identifying this option package in the commercial catalog (e.g., TECH01, TOW-PKG, PREM-AUD). Used in ordering systems, dealer management systems, and customer-facing configurators.. Valid values are `^[A-Z0-9]{3,10}$`',
    `content_description` STRING COMMENT 'Detailed description of all features, components, and equipment included in this option package. Used for customer communication, sales training, and regulatory disclosure.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this option package record was first created in the system.',
    `dealer_cost_amount` DECIMAL(18,2) COMMENT 'Wholesale cost to the dealer for this option package. Used for dealer margin calculations and incentive program eligibility. Business-confidential pricing data.',
    `discontinuation_date` DATE COMMENT 'Date when this option package was or will be removed from the orderable catalog. Corresponds to End of Production (EOP) or phase-out date. Null if still active.',
    `emissions_impact_grams_co2_km` DECIMAL(18,2) COMMENT 'Incremental CO2 emissions impact of this option package in grams per kilometer under WLTP test cycle. Used for CAFE and emissions compliance reporting.',
    `excludes_package_codes` STRING COMMENT 'Comma-separated list of package codes that cannot be selected if this package is chosen. Enforces mutual exclusivity constraints in the vehicle configuration logic.',
    `field_service_installable_flag` BOOLEAN COMMENT 'Whether this option package can be installed via field service',
    `fuel_economy_impact_percent` DECIMAL(18,2) COMMENT 'Percentage impact on vehicle fuel economy when this option package is installed. Positive values indicate reduced efficiency; negative values indicate improved efficiency. Used for EPA fuel economy label calculations.',
    `included_in_package_codes` STRING COMMENT 'Comma-separated list of higher-level package codes that already include this package as a component. Prevents duplicate ordering and pricing.',
    `installation_location` STRING COMMENT 'Designated location where this option package is installed: factory (during main assembly line production), port (at port facility before delivery), dealer (at dealership after delivery).. Valid values are `factory|port|dealer`',
    `introduction_date` DATE COMMENT 'Date when this option package was first made available for customer ordering. Corresponds to Start of Production (SOP) or commercial launch date.',
    `is_orderable` BOOLEAN COMMENT 'Indicates whether this option package is currently available for customer ordering. May be false due to supply constraints, regulatory holds, or lifecycle status.',
    `is_visible_to_customer` BOOLEAN COMMENT 'Indicates whether this option package should be displayed in customer-facing configurators and marketing materials. May be hidden for dealer-only or internal packages.',
    `labor_hours` DECIMAL(18,2) COMMENT 'Standard labor hours required to install this option package during vehicle assembly or at dealer/port. Used for production scheduling and capacity planning.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this option package record was last updated. Used for change tracking and data synchronization.',
    `lifecycle_status` STRING COMMENT 'Current lifecycle stage of the option package in the commercial catalog: planned (future availability), active (orderable), phasing_out (limited availability), discontinued (no longer orderable), obsolete (historical record only).. Valid values are `planned|active|phasing_out|discontinued|obsolete`',
    `marketing_description` STRING COMMENT 'Customer-facing marketing copy highlighting the benefits and value proposition of this option package. Used in brochures, websites, and configurators.',
    `msrp_amount` DECIMAL(18,2) COMMENT 'Manufacturer Suggested Retail Price uplift amount for this option package in the base currency. Represents the incremental price added to the base vehicle MSRP when this package is selected.',
    `msrp_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the MSRP amount (e.g., USD, EUR, CAD, GBP).. Valid values are `^[A-Z]{3}$`',
    `aftersales_option_package_name` STRING COMMENT 'Marketing name of the option package as presented to customers and dealers (e.g., Technology Package, Towing Package, Premium Audio System).',
    `production_feasibility_status` STRING COMMENT 'Current manufacturing feasibility status indicating whether the option package can be produced given current supply chain, capacity, and tooling constraints.. Valid values are `feasible|constrained|unavailable|pending_validation`',
    `regulatory_approval_required` BOOLEAN COMMENT 'Indicates whether this option package requires specific regulatory approval or homologation before it can be sold in certain markets (e.g., NHTSA, EPA, Euro NCAP certification).',
    `requires_package_codes` STRING COMMENT 'Comma-separated list of package codes that must be selected before this package can be ordered. Enforces prerequisite dependencies in the vehicle configuration logic.',
    `sales_rank` STRING COMMENT 'Relative sales popularity ranking of this option package compared to other packages in the same category. Used for inventory planning and marketing prioritization.',
    `sku` STRING COMMENT 'Stock Keeping Unit identifier used for inventory management, parts ordering, and dealer stock tracking. May differ from package_code in multi-channel distribution scenarios.',
    `ssot_governance_note` STRING COMMENT 'SSOT owner in this domain per governance; consolidated master data with cross-domain references maintained via foreign keys.',
    `supplier_part_number` STRING COMMENT 'Primary supplier part number for the main component or assembly of this option package. Used for procurement, supply chain traceability, and warranty tracking.',
    `aftersales_option_package_type` STRING COMMENT 'Classification of the option package: group (bundle of multiple features), standalone (single feature option), accessory (aftermarket add-on), dealer_installed (installed at dealership), port_installed (installed at port before delivery).. Valid values are `group|standalone|accessory|dealer_installed|port_installed`',
    `warranty_miles` STRING COMMENT 'Standard warranty coverage mileage limit for this option package. Used in conjunction with warranty_months for warranty claim validation.',
    `warranty_months` STRING COMMENT 'Standard warranty coverage period for this option package in months. May differ from base vehicle warranty for certain accessory or technology packages.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Total weight contribution of this option package in kilograms. Used for vehicle weight calculations, fuel economy ratings (CAFE compliance), and payload capacity determination.',
    CONSTRAINT pk_aftersales_option_package PRIMARY KEY(`aftersales_option_package_id`)
) COMMENT 'Defines commercially available option packages and standalone options that can be ordered on a vehicle (e.g., Technology Package, Tow Package, Panoramic Roof, Premium Audio). Captures package code, package name, package type (group/standalone/accessory), MSRP uplift price, content description, constraint rules (requires/excludes other packages), availability by trim level, market availability regions, and lifecycle status. Distinct from engineering feature definitions — this is the commercial catalog layer.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` (
    `aftersales_model_year_program_id` BIGINT COMMENT 'Primary key for model_year_program',
    `control_plan_id` BIGINT COMMENT 'Unique identifier for the model year program. Primary key.',
    `employee_id` BIGINT COMMENT 'Reference to the employee responsible for overall program execution, budget, and milestone delivery.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Program‑level budgeting and cost tracking rely on a dedicated cost_center for each model year program.',
    `inspection_plan_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_plan. Business justification: Inspection plans are scoped to a specific model‑year program; linking supports scheduling and compliance reporting per program.',
    `aftersales_nameplate_id` BIGINT COMMENT 'Reference to the nameplate (vehicle brand/model family) that this program is for.',
    `primary_employee_id` BIGINT COMMENT 'Reference to the employee responsible for overall program execution, budget, and milestone delivery.',
    `plant_id` BIGINT COMMENT 'Reference to the primary manufacturing plant assigned to produce vehicles for this model year program.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Program profitability (EBITDA, margin) is reported via a profit_center linked to the model_year_program.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_requirement. Business justification: REQUIRED: Program managers track which regulatory requirements apply to each vehicle program for compliance planning and budgeting.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Model Year Program Planning aligns with the engineering vehicle program for schedule, budget, and target volume decisions (Program Alignment Dashboard).',
    `actual_production_volume` STRING COMMENT 'Cumulative number of units actually produced to date for this model year program. Updated as production progresses.',
    `adas_level` STRING COMMENT 'SAE automation level for ADAS features included in this model year program. Level 0: no automation; Level 5: full automation.. Valid values are `level_0|level_1|level_2|level_3|level_4|level_5`',
    `bom_complexity_score` DECIMAL(18,2) COMMENT 'Calculated score representing the complexity of the BOM for this model year program, based on part count, variant count, and engineering change frequency.',
    `budget_amount` DECIMAL(18,2) COMMENT 'Total allocated budget for this model year program, including CapEx for tooling, engineering, validation, and launch costs. Excludes variable production costs.',
    `budget_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the program budget amount (e.g., USD, EUR, JPY).. Valid values are `^[A-Z]{3}$`',
    `cafe_target` DECIMAL(18,2) COMMENT 'Target CAFE rating (miles per gallon or equivalent) for this model year program to meet regulatory compliance in the United States.',
    `capex_amount` DECIMAL(18,2) COMMENT 'Portion of the program budget allocated to capital expenditures: tooling, equipment, facility modifications, and fixed assets required for this program.',
    `aftersales_model_year_program_code` STRING COMMENT 'Unique alphanumeric code assigned to this model year program for internal tracking and cross-system reference.. Valid values are `^[A-Z0-9]{4,12}$`',
    `connected_services_enabled` BOOLEAN COMMENT 'Indicates whether this model year program includes connected vehicle services (telematics, OTA updates, V2X communication, remote diagnostics).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this model year program record was first created in the system.',
    `aftersales_model_year_program_description` STRING COMMENT 'Detailed narrative description of the model year program, including key features, strategic objectives, target market, and differentiation from prior model years.',
    `eop_date` DATE COMMENT 'Planned or actual date when series production ends for this model year program. Triggers runout planning, parts obsolescence, and service support transition.',
    `epa_rating_target` DECIMAL(18,2) COMMENT 'Target EPA fuel economy or emissions rating for this model year program to meet U.S. environmental compliance and consumer labeling requirements.',
    `field_service_program_code` STRING COMMENT 'Field service program code for this model year',
    `fmea_completed` BOOLEAN COMMENT 'Indicates whether FMEA has been completed for this model year program as part of APQP quality planning.',
    `homologation_region` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country or region codes where this model year program is planned for regulatory homologation and sale (e.g., USA,CAN,MEX for North America).. Valid values are `^[A-Z]{3}(,[A-Z]{3})*$`',
    `launch_date` DATE COMMENT 'Date when vehicles from this program become available for customer delivery and retail sale. May differ from SOP due to inventory build and distribution lead time.',
    `msrp_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the MSRP targets (e.g., USD, EUR, JPY).. Valid values are `^[A-Z]{3}$`',
    `aftersales_model_year_program_name` STRING COMMENT 'Human-readable name of the model year program, typically combining nameplate and model year (e.g., F-150 MY2025 Program).',
    `ncap_target_rating` STRING COMMENT 'Target safety rating (1 to 5 stars) for this model year program under applicable NCAP testing (Euro NCAP, NHTSA, etc.). Influences marketing and regulatory compliance.. Valid values are `1_star|2_star|3_star|4_star|5_star`',
    `ota_capable` BOOLEAN COMMENT 'Indicates whether vehicles in this model year program support over-the-air software updates for ECU firmware, infotainment, and vehicle features.',
    `phase` STRING COMMENT 'Current lifecycle phase of the model year program. Concept: initial planning; Development: engineering and design; Validation: PPAP and testing; Launch: SOP preparation; Production: active manufacturing; Runout: approaching EOP; Discontinued: post-EOP. [ENUM-REF-CANDIDATE: concept|development|validation|launch|production|runout|discontinued — 7 candidates stripped; promote to reference product]',
    `platform_code` STRING COMMENT 'Engineering platform or architecture code that this model year program is built on. Shared platforms enable cost efficiencies and parts commonality across nameplates.. Valid values are `^[A-Z0-9]{2,10}$`',
    `powertrain_type` STRING COMMENT 'Primary powertrain technology for this model year program. ICE: Internal Combustion Engine; HEV: Hybrid Electric Vehicle; PHEV: Plug-in Hybrid Electric Vehicle; BEV: Battery Electric Vehicle; FCEV: Fuel Cell Electric Vehicle.. Valid values are `ICE|HEV|PHEV|BEV|FCEV`',
    `ppap_status` STRING COMMENT 'Current status of PPAP submissions for this model year program. PPAP approval is required before series production can begin.. Valid values are `not_started|in_progress|submitted|approved|rejected`',
    `priority` STRING COMMENT 'Strategic priority level assigned to this model year program for resource allocation, executive attention, and portfolio management.. Valid values are `critical|high|medium|low`',
    `risk_level` STRING COMMENT 'Overall risk assessment for this model year program based on technical complexity, supply chain dependencies, regulatory uncertainty, and market conditions.. Valid values are `low|medium|high|critical`',
    `sop_date` DATE COMMENT 'Planned or actual date when series production begins for this model year program. Critical milestone for supply chain, manufacturing, and dealer planning.',
    `ssot_governance_note` STRING COMMENT 'SSOT owner in this domain per governance; consolidated master data with cross-domain references maintained via foreign keys.',
    `aftersales_model_year_program_status` STRING COMMENT 'Operational status of the program. Active: proceeding as planned; On Hold: temporarily paused; Cancelled: terminated before completion; Completed: finished lifecycle.. Valid values are `active|on_hold|cancelled|completed`',
    `supplier_count` STRING COMMENT 'Number of unique suppliers engaged to provide parts and components for this model year program. Used for supply chain complexity assessment.',
    `target_msrp_max` DECIMAL(18,2) COMMENT 'Maximum MSRP target for the fully-loaded configuration of this model year program. Defines the upper bound of the pricing envelope.',
    `target_msrp_min` DECIMAL(18,2) COMMENT 'Minimum MSRP target for the base configuration of this model year program. Used for pricing strategy and competitive positioning.',
    `target_production_volume` STRING COMMENT 'Planned total number of units to be produced during the lifecycle of this model year program. Used for capacity planning, procurement, and sales forecasting.',
    `tooling_investment` DECIMAL(18,2) COMMENT 'Total investment in tooling (dies, molds, fixtures, jigs) required for this model year program. Subset of CapEx.',
    `updated_by` STRING COMMENT 'User ID or system identifier of the person or process that last modified this model year program record.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this model year program record was last modified.',
    `vehicle_segment` STRING COMMENT 'Market segment classification for this model year program. Used for competitive analysis, marketing strategy, and portfolio planning. [ENUM-REF-CANDIDATE: compact|midsize|fullsize|suv|crossover|truck|van|luxury|sports|commercial — 10 candidates stripped; promote to reference product]',
    `wltp_target` DECIMAL(18,2) COMMENT 'Target WLTP fuel consumption or CO2 emissions rating for this model year program to meet regulatory compliance in markets using WLTP standards.',
    `year` STRING COMMENT 'The model year designation for this program (e.g., 2024, 2025). Represents the marketing and regulatory year, not necessarily the calendar year of production.',
    `created_by` STRING COMMENT 'User ID or system identifier of the person or process that created this model year program record.',
    CONSTRAINT pk_aftersales_model_year_program PRIMARY KEY(`aftersales_model_year_program_id`)
) COMMENT 'Defines the annual program plan for each nameplate by MY (Model Year). Captures MY designation, program code, program phase (concept/development/launch/production/runout), SOP date, EOP date, target plant assignments, planned production volume, regulatory homologation targets (CAFE, WLTP, EPA), program budget envelope (CapEx), and program manager reference. Acts as the planning backbone linking nameplate definitions to annual production and sales programs.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` (
    `msrp_price_book_id` BIGINT COMMENT 'Unique identifier for the MSRP price book. Primary key.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Price book approvals are performed by a pricing manager employee; linking enables compliance reporting and audit of pricing decisions.',
    `superseded_by_price_book_msrp_price_book_id` BIGINT COMMENT 'Reference to the price book that replaces this one when status transitions to superseded. Nullable if not yet superseded.',
    `approved_date` DATE COMMENT 'The date on which this price book received formal approval from the designated authority.',
    `msrp_price_book_code` STRING COMMENT 'Externally-known unique business identifier for the price book, used in dealer ordering systems and OEM communications.. Valid values are `^[A-Z0-9]{6,20}$`',
    `created_by_user` STRING COMMENT 'User ID or name of the person who created this price book record.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this price book record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which all prices in this book are denominated (e.g., USD, EUR, CAD).. Valid values are `^[A-Z]{3}$`',
    `dealer_access_level` STRING COMMENT 'Access control level defining which dealer tiers or internal users can view and use this price book.. Valid values are `public|authorized_dealer|franchise_only|internal`',
    `destination_charge_included_flag` BOOLEAN COMMENT 'Indicates whether destination and delivery charges are included in the MSRP prices within this book.',
    `distribution_channel` STRING COMMENT 'SAP SD distribution channel code identifying the sales channel for which this price book applies (e.g., retail, fleet, direct).',
    `effective_end_date` DATE COMMENT 'The date on which this price book ceases to be valid. Nullable for open-ended price books.',
    `effective_start_date` DATE COMMENT 'The date from which this price book becomes valid and active for dealer ordering and MSRP publication.',
    `field_service_pricing_included_flag` BOOLEAN COMMENT 'Whether field service pricing is included in this price book',
    `last_modified_by_user` STRING COMMENT 'User ID or name of the person who last modified this price book record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this price book record was last updated or modified.',
    `list_category` STRING COMMENT 'Category of pricing entries contained in this book (e.g., base vehicle, options, packages, accessories, destination charges).. Valid values are `base|option|package|accessory|destination`',
    `market_code` STRING COMMENT 'ISO 3166-1 alpha-2 or alpha-3 country or region code identifying the geographic market for which this price book applies (e.g., USA, CAN, DEU).. Valid values are `^[A-Z]{2,3}$`',
    `model_year` STRING COMMENT 'The model year (MY) for which this price book applies, representing the production year designation for vehicles.. Valid values are `^(19|20)d{2}$`',
    `msrp_price_book_name` STRING COMMENT 'Human-readable name of the price book, typically including model year and market designation.',
    `publication_format` STRING COMMENT 'Primary format in which this price book is published and distributed to dealers and systems (e.g., PDF, XML, JSON, EDI, print).. Valid values are `pdf|xml|json|edi|print`',
    `published_date` DATE COMMENT 'The date on which this price book was officially published and made available to dealers and distribution channels.',
    `region_code` STRING COMMENT 'Internal regional grouping code for sales and distribution management, may represent sub-national regions or dealer territories.',
    `regulatory_compliance_notes` STRING COMMENT 'Free-text notes documenting compliance with pricing disclosure regulations such as NHTSA labeling requirements or EPA fuel economy disclosures.',
    `remarks` STRING COMMENT 'Additional free-text remarks or special instructions related to this price book, such as promotional conditions or market-specific notes.',
    `sales_organization` STRING COMMENT 'SAP SD sales organization code representing the legal entity or business unit responsible for this price book.',
    `ssot_governance_note` STRING COMMENT 'SSOT owner in this domain per governance; consolidated master data with cross-domain references maintained via foreign keys.',
    `msrp_price_book_status` STRING COMMENT 'Current lifecycle status of the price book governing its availability for dealer ordering and consumer communications.. Valid values are `draft|approved|published|active|superseded|archived`',
    `tax_treatment_code` STRING COMMENT 'Code indicating the tax treatment applicable to prices in this book (e.g., tax-inclusive, tax-exclusive, VAT, GST).',
    `msrp_price_book_type` STRING COMMENT 'Classification of the price book by customer segment or channel (e.g., standard retail, fleet, government, export).. Valid values are `standard|fleet|government|export|promotional`',
    `version_number` STRING COMMENT 'Semantic version number of the price book, incremented for revisions and updates (e.g., 1.0, 1.1, 2.0).. Valid values are `^d+.d+$`',
    CONSTRAINT pk_msrp_price_book PRIMARY KEY(`msrp_price_book_id`)
) COMMENT 'SSOT for MSRP (Manufacturer Suggested Retail Price) price books by model year, market, and currency. Captures price book code, effective date range, market/region code, currency code, price book status (draft/approved/published/superseded), approval authority, and publication date. The price book is the container for all MSRP pricing entries and governs which prices are active for dealer ordering and consumer-facing communications.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` (
    `msrp_price_entry_id` BIGINT COMMENT 'Unique identifier for the MSRP price entry record. Primary key for the price entry entity.',
    `aftersales_trim_level_id` BIGINT COMMENT 'Reference to the specific trim level or grade within the nameplate. Represents the feature and equipment tier (e.g., base, mid-level, premium).',
    `market_availability_id` BIGINT COMMENT 'Reference to the geographic market or sales region for which this price entry is applicable. Enables regional pricing strategies and market-specific MSRP variations.',
    `msrp_price_book_id` BIGINT COMMENT 'Reference to the parent price book that contains this price entry. Links to the price book master entity.',
    `aftersales_nameplate_id` BIGINT COMMENT 'Reference to the vehicle nameplate (model line) to which this price entry applies. Examples include specific car, truck, or SUV model lines.',
    `sku_id` BIGINT COMMENT 'Reference to the SKU or product variant being priced. May represent a base vehicle, option package, accessory, or standalone component.',
    `advertising_fee_amount` DECIMAL(18,2) COMMENT 'Mandatory regional or national advertising fee charged to the dealer and passed through to the customer. Supports cooperative advertising programs and brand marketing initiatives.',
    `approval_date` DATE COMMENT 'Date on which this price entry was formally approved by pricing management and authorized for publication. Null for draft or pending entries.',
    `approved_by` STRING COMMENT 'Name or identifier of the pricing manager or executive who approved this price entry. Supports audit trail and accountability for pricing decisions.',
    `base_msrp_amount` DECIMAL(18,2) COMMENT 'The base MSRP amount for the SKU or option before any additional charges, taxes, or adjustments. Represents the manufacturers suggested retail price in the price book currency.',
    `change_reason` STRING COMMENT 'Business reason or trigger for the price entry or price change. Supports audit trail and pricing strategy analysis. [ENUM-REF-CANDIDATE: initial_launch|model_year_change|cost_adjustment|competitive_response|incentive_program|regulatory_compliance|currency_adjustment|supply_constraint — 8 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this price entry record was first created in the data product. Supports audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code indicating the currency in which all amounts in this price entry are denominated (e.g., USD, CAD, EUR, MXN).. Valid values are `^[A-Z]{3}$`',
    `dealer_invoice_amount` DECIMAL(18,2) COMMENT 'The wholesale price charged to the dealer by the manufacturer for this SKU or option. Confidential business data used for dealer margin calculation and holdback determination. Typically lower than MSRP.',
    `destination_charge_amount` DECIMAL(18,2) COMMENT 'Mandatory freight and delivery charge from the manufacturing plant or port to the dealer. Also known as destination and delivery fee. Typically uniform within a region but may vary by vehicle size class.',
    `effective_end_date` DATE COMMENT 'The date on which this price entry expires and is no longer valid for new transactions. Nullable for open-ended pricing. Used to manage model year transitions and mid-year price changes.',
    `effective_start_date` DATE COMMENT 'The date on which this price entry becomes active and applicable for dealer invoicing and customer quotations. Represents the beginning of the price validity period.',
    `employee_pricing_amount` DECIMAL(18,2) COMMENT 'Special pricing available to manufacturer employees, retirees, and eligible family members. Confidential pricing tier typically below dealer invoice. Null if no employee program applies.',
    `field_service_surcharge_amount` DECIMAL(18,2) COMMENT 'Field service surcharge amount if applicable',
    `fleet_eligible_flag` BOOLEAN COMMENT 'Indicates whether this SKU or option is available for fleet sales programs at this price point. Fleet pricing may differ from retail MSRP. True if eligible for fleet programs, false otherwise.',
    `gas_guzzler_tax_amount` DECIMAL(18,2) COMMENT 'Federal excise tax applied to vehicles that do not meet EPA fuel economy standards. Applicable only to passenger cars (not trucks or SUVs) with combined fuel economy below the statutory threshold. Zero for compliant vehicles.',
    `government_eligible_flag` BOOLEAN COMMENT 'Indicates whether this SKU or option is available for government or municipal fleet purchases under special pricing programs. True if eligible for government sales, false otherwise.',
    `holdback_percentage` DECIMAL(18,2) COMMENT 'Percentage of MSRP or invoice that the manufacturer retains and later rebates to the dealer. Confidential dealer incentive mechanism. Typically ranges from 1% to 3% of MSRP.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this price entry record was most recently updated. Tracks the recency of pricing data and supports change detection.',
    `luxury_tax_amount` DECIMAL(18,2) COMMENT 'Additional tax or surcharge applied to high-value vehicles exceeding a statutory price threshold. Jurisdiction-specific; may be zero in regions without luxury vehicle taxation.',
    `model_year` STRING COMMENT 'The model year for which this price entry is applicable. Represents the vehicle program year, not the calendar year of sale.',
    `notes` STRING COMMENT 'Free-text field for additional pricing notes, special conditions, or explanatory comments. May include details on regional restrictions, bundle requirements, or pricing rationale.',
    `prior_msrp_amount` DECIMAL(18,2) COMMENT 'The previous total MSRP amount before the current price change. Used for price change tracking, competitive analysis, and dealer communication. Null for initial price entries.',
    `promotional_flag` BOOLEAN COMMENT 'Indicates whether this price entry is part of a limited-time promotional pricing program. True for promotional pricing, false for standard pricing.',
    `protection_flag` BOOLEAN COMMENT 'Indicates whether this price entry is covered by a price protection program that compensates dealers for inventory devaluation due to mid-year price reductions. True if protected, false otherwise.',
    `publication_date` DATE COMMENT 'Date on which this price entry was published to dealers and made available in dealer management systems and configurator tools. May differ from effective start date.',
    `source_record_reference` STRING COMMENT 'The unique identifier or key of this price entry in the source system. Enables traceability and reconciliation back to the system of record.',
    `ssot_governance_note` STRING COMMENT 'SSOT owner in this domain per governance; consolidated master data with cross-domain references maintained via foreign keys.',
    `msrp_price_entry_status` STRING COMMENT 'Current lifecycle status of the price entry. Tracks the approval and activation workflow from initial draft through active use to eventual expiration or withdrawal.. Valid values are `draft|pending_approval|active|superseded|expired|withdrawn`',
    `supplier_pricing_amount` DECIMAL(18,2) COMMENT 'Special pricing available to employees of the manufacturers supplier partners. Confidential pricing tier used as a supplier relationship benefit. Null if no supplier program applies.',
    `total_msrp_amount` DECIMAL(18,2) COMMENT 'The total MSRP including base price, destination charge, gas guzzler tax, luxury tax, and any other mandatory manufacturer charges. This is the price displayed on the Monroney window sticker.',
    `msrp_price_entry_type` STRING COMMENT 'Classification of the price entry indicating what is being priced. Distinguishes between base vehicle MSRP, individual options, bundled packages, dealer-installed accessories, mandatory destination charges, and regional pricing adjustments. [ENUM-REF-CANDIDATE: base_vehicle|option|package|accessory|destination_charge|regional_adjustment|port_installed_option — 7 candidates stripped; promote to reference product]',
    CONSTRAINT pk_msrp_price_entry PRIMARY KEY(`msrp_price_entry_id`)
) COMMENT 'Individual MSRP (Manufacturer Suggested Retail Price) pricing entries within a price book. Captures the SKU or option package being priced, base MSRP amount, destination charge, gas guzzler tax (if applicable), effective start and end dates, price type (base vehicle/option/package/accessory), and prior price for change tracking. Enables dealer invoice generation, consumer window sticker production, and competitive pricing analysis.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`market_availability` (
    `market_availability_id` BIGINT COMMENT 'Unique identifier for the market availability record. Primary key for the market availability entity.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Market availability is specific to a SKU; adding the FK eliminates the need for separate SKU code columns and enables direct joins.',
    `allocation_constraint_flag` BOOLEAN COMMENT 'Indicates whether this product configuration is subject to allocation constraints or supply limitations in the target market. True indicates constrained supply requiring allocation management.',
    `assembly_mode` STRING COMMENT 'The assembly and import mode for this product configuration. CBU (Completely Built Up) indicates fully assembled import, CKD (Completely Knocked Down) indicates full disassembly for local assembly, and SKD (Semi Knocked Down) indicates partial disassembly for local assembly. Impacts duty rates and local content requirements.. Valid values are `cbu|ckd|skd`',
    `market_availability_code` STRING COMMENT 'The geographic market or country code where this product configuration is available for sale. Uses ISO 3166-1 alpha-2 or alpha-3 country codes.. Valid values are `^[A-Z]{2,3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this market availability record was first created in the system. Used for audit trail and data lineage tracking.',
    `dealer_ordering_code` STRING COMMENT 'The code used by dealers in the Dealer Management System (DMS) to order this specific product configuration. May differ from internal SKU codes for legacy system compatibility.. Valid values are `^[A-Z0-9]{4,15}$`',
    `destination_charge_amount` DECIMAL(18,2) COMMENT 'The freight and delivery charge from the manufacturing plant or port to the dealer in the target market. Typically added to MSRP for total customer pricing.',
    `effective_date` DATE COMMENT 'The date when this market availability record became effective. Used for temporal tracking of availability changes and pricing updates.',
    `emissions_standard` STRING COMMENT 'The emissions certification standard that this product configuration meets in the target market. Examples include Euro 6, EPA Tier 3, BS6 (Bharat Stage 6), China 6, and California LEV3. Critical for regulatory compliance and market entry. [ENUM-REF-CANDIDATE: euro6|euro5|tier3|tier2|bs6|bs4|china6|china5|lev3|ulev|zlev — 11 candidates stripped; promote to reference product]',
    `ev_battery_warranty_months` STRING COMMENT 'The duration of the manufacturers battery warranty coverage for electric or hybrid vehicles in the target market, expressed in months. Null for non-electrified vehicles.',
    `expiration_date` DATE COMMENT 'The date when this market availability record expires or is superseded by a new record. Null indicates the current active record.',
    `field_service_available_flag` BOOLEAN COMMENT 'Whether field service is available in this market',
    `fuel_economy_rating` DECIMAL(18,2) COMMENT 'The official fuel economy or energy efficiency rating for this product configuration in the target market, expressed in the local standard unit (MPG, L/100km, kWh/100km). Based on standardized test procedures.',
    `fuel_economy_unit` STRING COMMENT 'The unit of measure for the fuel economy rating. MPG (miles per gallon) used in US, L/100km (liters per 100 kilometers) used in Europe and Asia, kWh/100km (kilowatt-hours per 100 kilometers) used for electric vehicles.. Valid values are `mpg|l-per-100km|kwh-per-100km|km-per-l`',
    `government_incentive_amount` DECIMAL(18,2) COMMENT 'The value of government incentives (tax credits, rebates, grants) available for this product configuration in the target market. Commonly applies to electric vehicles and fuel-efficient vehicles. Null if no government incentive available.',
    `homologation_approval_date` DATE COMMENT 'The date when regulatory type-approval was granted for this product configuration in the target market. Critical for compliance tracking and market entry timing.',
    `homologation_approval_status` STRING COMMENT 'The regulatory type-approval status for this product configuration in the target market. Approved indicates certification complete, pending indicates under review, rejected indicates failed certification, not-required indicates no certification needed, and expired indicates certification lapsed.. Valid values are `approved|pending|rejected|not-required|expired`',
    `homologation_certificate_number` STRING COMMENT 'The official type-approval or certification number issued by the regulatory authority for this product configuration in the target market. Required for legal sale in regulated markets.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `homologation_expiry_date` DATE COMMENT 'The date when the regulatory type-approval expires and must be renewed. Null indicates no expiration or perpetual approval.',
    `import_duty_classification` STRING COMMENT 'The Harmonized System (HS) tariff code or customs classification for this product configuration when imported into the target market. Used for duty calculation and customs clearance.. Valid values are `^[0-9]{4,10}$`',
    `import_duty_rate_percent` DECIMAL(18,2) COMMENT 'The applicable import duty or tariff rate as a percentage of the customs value for this product configuration in the target market. Used for landed cost calculation.',
    `incentive_eligible_flag` BOOLEAN COMMENT 'Indicates whether this product configuration is eligible for manufacturer or government incentives in the target market. True indicates eligibility for rebates, tax credits, or promotional programs.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this market availability record was last updated. Used for change tracking and data synchronization.',
    `launch_date` DATE COMMENT 'The date when this product configuration became available for order or sale in the specified market and channel. Represents the Start of Production (SOP) date for market availability.',
    `lead_time_days` STRING COMMENT 'The typical number of days from order placement to vehicle delivery for this product configuration in the target market. Used for customer expectation setting and order promising.',
    `local_content_percent` DECIMAL(18,2) COMMENT 'The percentage of the product value that is sourced or manufactured locally in the target market. Used for trade agreement compliance and preferential duty qualification.',
    `max_order_quantity` STRING COMMENT 'The maximum number of units of this product configuration that can be ordered per dealer or per order cycle in the target market. Used for allocation management and demand control. Null indicates no limit.',
    `model_year` STRING COMMENT 'The model year designation for this product availability. Represents the production year classification used for marketing and regulatory purposes.',
    `msrp_amount` DECIMAL(18,2) COMMENT 'The manufacturers suggested retail price for this product configuration in the target market, expressed in the local currency. Represents the baseline pricing before dealer adjustments, incentives, or negotiations.',
    `msrp_currency_code` STRING COMMENT 'The ISO 4217 three-letter currency code for the MSRP amount. Indicates the local currency of the target market.. Valid values are `^[A-Z]{3}$`',
    `nameplate_code` STRING COMMENT 'The vehicle nameplate or model family identifier (e.g., F-150, Camry, Model 3). Represents the brand-level product designation.. Valid values are `^[A-Z0-9_]{3,15}$`',
    `notes` STRING COMMENT 'Free-text field for additional comments, restrictions, or special instructions related to this market availability record. May include dealer ordering notes, allocation rules, or market-specific requirements.',
    `option_package_code` STRING COMMENT 'The optional equipment package identifier that can be added to the base trim configuration. May represent technology packages, appearance packages, or convenience packages.. Valid values are `^[A-Z0-9]{3,10}$`',
    `ordering_priority` STRING COMMENT 'The priority ranking for order allocation and production scheduling for this product configuration in the target market. Lower numbers indicate higher priority. Used when demand exceeds supply.',
    `powertrain_warranty_months` STRING COMMENT 'The duration of the manufacturers powertrain warranty coverage (engine, transmission, drivetrain) for this product configuration in the target market, expressed in months. Typically longer than basic warranty.',
    `pre_delivery_inspection_required_flag` BOOLEAN COMMENT 'Indicates whether a formal pre-delivery inspection is required before customer delivery for this product configuration in the target market. True indicates PDI is mandatory per OEM or regulatory requirements.',
    `record_source_system` STRING COMMENT 'The source system that created or last updated this market availability record. SAP-SD indicates SAP Sales and Distribution, PLM indicates Product Lifecycle Management system, DMS indicates Dealer Management System, pricing-engine indicates automated pricing system, manual indicates manual data entry.. Valid values are `sap-sd|plm|dms|pricing-engine|manual`',
    `safety_rating` STRING COMMENT 'The official safety rating from the target markets New Car Assessment Programme (NCAP). Expressed as star rating (e.g., 5-star, 4-star) or not-rated if not yet tested.. Valid values are `^[0-5]-star$|not-rated`',
    `sales_channel` STRING COMMENT 'The distribution channel through which this product configuration is sold. Retail represents dealer network sales, fleet represents commercial bulk sales, government represents public sector contracts, export represents international distribution, direct represents factory-to-customer, and online represents e-commerce channels.. Valid values are `retail|fleet|government|export|direct|online`',
    `ssot_governance_note` STRING COMMENT 'SSOT owner in this domain per governance; consolidated master data with cross-domain references maintained via foreign keys.',
    `market_availability_status` STRING COMMENT 'The current offering status of this product configuration in the specified market and channel. Available indicates orderable, restricted indicates conditional availability, not-offered indicates not sold in this market, discontinued indicates end of sales, pre-order indicates future availability, and limited indicates constrained supply.. Valid values are `available|restricted|not-offered|discontinued|pre-order|limited`',
    `trim_level_code` STRING COMMENT 'The trim or grade level identifier (e.g., Base, Sport, Limited, Premium). Defines the feature and equipment package tier.. Valid values are `^[A-Z0-9_]{2,10}$`',
    `warranty_mileage` STRING COMMENT 'The mileage limit of the manufacturers basic warranty coverage for this product configuration in the target market. Warranty expires at the earlier of warranty_months or warranty_mileage.',
    `warranty_months` STRING COMMENT 'The duration of the manufacturers basic warranty coverage for this product configuration in the target market, expressed in months. Represents the bumper-to-bumper or comprehensive warranty period.',
    `withdrawal_date` DATE COMMENT 'The date when this product configuration was or will be withdrawn from sale in the specified market and channel. Represents the End of Production (EOP) date for market availability. Null indicates ongoing availability.',
    CONSTRAINT pk_market_availability PRIMARY KEY(`market_availability_id`)
) COMMENT 'Defines the feature-to-market availability matrix — which SKUs, trim levels, and option packages are available in which geographic markets and sales channels. Captures market code, sales channel (retail/fleet/government/export), availability status (available/restricted/not-offered), launch date, withdrawal date, homologation approval status, import duty classification, and CKD/SKD (Completely Knocked Down / Semi Knocked Down) assembly flag. Critical for order management, dealer ordering systems, and regulatory compliance.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`order_guide` (
    `order_guide_id` BIGINT COMMENT 'Unique identifier for the dealer order guide. Primary key for the order guide entity.',
    `aftersales_nameplate_id` BIGINT COMMENT 'Reference to the vehicle nameplate (product line) that this order guide governs. Links to the nameplate master data.',
    `online_order_id` BIGINT COMMENT '',
    `employee_id` BIGINT COMMENT 'Identifier of the user who created this order guide record. Typically a product manager or sales operations analyst.',
    `order_last_modified_by_user_employee_id` BIGINT COMMENT 'Identifier of the user who last modified this order guide record. Used for accountability and audit trail purposes.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the user who approved this order guide for publication. Typically a product manager or sales director with authority to release order guides.',
    `primary_order_employee_id` BIGINT COMMENT 'Identifier of the user who approved this order guide for publication. Typically a product manager or sales director with authority to release order guides.',
    `superseded_by_order_guide_id` BIGINT COMMENT 'Reference to the order guide that supersedes this one. Used to track order guide version history and guide dealers to the current version.',
    `tertiary_order_last_modified_by_user_employee_id` BIGINT COMMENT 'Identifier of the user who last modified this order guide record. Used for accountability and audit trail purposes.',
    `allocation_method` STRING COMMENT 'The method used to allocate vehicle inventory to dealers for this order guide. Determines how production capacity is distributed across the dealer network.. Valid values are `turn_and_earn|historical_sales|market_share|equal_distribution|custom`',
    `approval_status` STRING COMMENT 'Approval workflow status indicating whether the order guide has been reviewed and approved by product management, pricing, and sales leadership.. Valid values are `not_submitted|pending_review|approved|rejected|conditional_approval`',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the order guide was approved for publication. Critical for audit trail and compliance tracking.',
    `bank_close_date` DATE COMMENT 'The date when the order bank closes and dealers can no longer submit new orders for vehicles in this order guide. Used for production planning cutoff.',
    `bank_open_date` DATE COMMENT 'The date when the order bank opens and dealers can begin submitting orders for vehicles in this order guide. May differ from effective start date.',
    `base_msrp_max` DECIMAL(18,2) COMMENT 'The maximum base MSRP across all orderable configurations in this order guide. Excludes options and packages. Used for pricing range communication.',
    `base_msrp_min` DECIMAL(18,2) COMMENT 'The minimum base MSRP across all orderable configurations in this order guide. Excludes options and packages. Used for pricing range communication.',
    `build_to_stock_flag` BOOLEAN COMMENT 'Indicates whether vehicles in this order guide are built to stock (for dealer inventory) versus build to order (for specific customer orders).',
    `cafe_compliance_flag` BOOLEAN COMMENT 'Indicates whether vehicles in this order guide contribute positively to the manufacturers CAFE compliance targets. Used for regulatory planning.',
    `order_guide_code` STRING COMMENT 'Business identifier for the order guide. Externally-known code used by dealers and sales channels to reference this specific order guide version.. Valid values are `^OG-[A-Z0-9]{6,12}$`',
    `color_option_count` STRING COMMENT 'The total number of exterior and interior color combinations available in this order guide. Used for configuration complexity tracking.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this order guide record was first created in the system. Part of the audit trail for order guide lifecycle tracking.',
    `dealer_invoice_discount_percentage` DECIMAL(18,2) COMMENT 'The standard discount percentage from MSRP to dealer invoice price for vehicles in this order guide. Confidential dealer pricing information.',
    `order_guide_description` STRING COMMENT 'Detailed description of the order guide including key features, target market, ordering instructions, and any special conditions or restrictions.',
    `effective_end_date` DATE COMMENT 'The date after which this order guide is no longer valid for new orders. Nullable for open-ended order guides. Part of the order guide validity period.',
    `effective_start_date` DATE COMMENT 'The date from which this order guide becomes active and dealers can begin placing orders using this guide. Part of the order guide validity period.',
    `emissions_standard` STRING COMMENT 'The emissions standard that vehicles in this order guide are certified to meet. Critical for regulatory compliance and market eligibility.. Valid values are `EPA_TIER3|CARB_LEV3|EURO6|EURO7|CHINA6|BS6`',
    `field_service_eligible_flag` BOOLEAN COMMENT 'Whether vehicles in this order guide are eligible for field service',
    `fleet_eligible_flag` BOOLEAN COMMENT 'Indicates whether this order guide is available for fleet sales orders. Fleet orders may have different pricing, configurations, and lead times.',
    `homologation_region` STRING COMMENT 'The regulatory homologation standard that vehicles in this order guide comply with. Determines which markets the vehicles can be sold in. [ENUM-REF-CANDIDATE: FMVSS|ECE|CMVSS|ADR|GB|INMETRO|CCC — 7 candidates stripped; promote to reference product]',
    `incentive_program_eligible_flag` BOOLEAN COMMENT 'Indicates whether vehicles ordered through this order guide are eligible for manufacturer incentive programs (rebates, financing offers, lease programs).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this order guide record was last updated. Used for change tracking and synchronization with dealer systems.',
    `lead_time_days_max` STRING COMMENT 'The maximum number of days from order placement to vehicle delivery for the slowest configuration in this order guide. Used for dealer planning.',
    `lead_time_days_min` STRING COMMENT 'The minimum number of days from order placement to vehicle delivery for the fastest configuration in this order guide. Used for dealer planning.',
    `market_region` STRING COMMENT 'The geographic market or region for which this order guide is applicable. Uses ISO 3166-1 alpha-3 country codes. Determines which dealers can order from this guide. [ENUM-REF-CANDIDATE: USA|CAN|MEX|BRA|DEU|GBR|FRA|ITA|ESP|CHN|JPN|KOR|AUS|IND|RUS|ZAF — 16 candidates stripped; promote to reference product]',
    `maximum_order_quantity` STRING COMMENT 'The maximum number of units a dealer can order per submission. Used to prevent over-ordering and ensure fair allocation across dealer network.',
    `minimum_order_quantity` STRING COMMENT 'The minimum number of units a dealer must order per submission. Used to enforce minimum order thresholds for production efficiency.',
    `model_year` STRING COMMENT 'The model year for which this order guide is published. Represents the production year designation for vehicles, not the calendar year.',
    `msrp_currency_code` STRING COMMENT 'The currency in which MSRP pricing is expressed for this order guide. Uses ISO 4217 three-letter currency codes. [ENUM-REF-CANDIDATE: USD|CAD|MXN|EUR|GBP|JPY|CNY|AUD|BRL|INR — 10 candidates stripped; promote to reference product]',
    `order_guide_name` STRING COMMENT 'Descriptive name of the order guide, typically including nameplate, model year, and market information for easy identification by dealers.',
    `option_package_count` STRING COMMENT 'The total number of option packages available in this order guide. Packages bundle multiple options together for simplified ordering.',
    `orderable_sku_count` STRING COMMENT 'The total number of unique SKUs (trim level and option combinations) that are orderable through this order guide. Used for complexity tracking.',
    `ordering_instructions_url` STRING COMMENT 'URL link to detailed ordering instructions, configuration rules, and dealer resources for this order guide. Hosted on dealer portal.. Valid values are `^https?://.*$`',
    `production_plant_code` STRING COMMENT 'The primary assembly plant code where vehicles in this order guide will be manufactured. Used for logistics and capacity planning.. Valid values are `^[A-Z0-9]{3,6}$`',
    `publication_date` DATE COMMENT 'The date when this order guide was published and made available to dealers through DMS systems and dealer portals.',
    `sales_channel` STRING COMMENT 'The sales channel for which this order guide is designed. Different channels may have different orderable configurations, pricing, and constraints.. Valid values are `retail|fleet|government|export|internal|demo`',
    `special_order_allowed_flag` BOOLEAN COMMENT 'Indicates whether dealers can place special orders for non-standard configurations not explicitly listed in the order guide. Requires additional approval.',
    `ssot_governance_note` STRING COMMENT 'SSOT owner in this domain per governance; consolidated master data with cross-domain references maintained via foreign keys.',
    `order_guide_status` STRING COMMENT 'Current lifecycle status of the order guide. Controls whether dealers can place orders and whether the guide is visible in dealer systems. [ENUM-REF-CANDIDATE: draft|pending_approval|approved|active|suspended|superseded|archived — 7 candidates stripped; promote to reference product]',
    `version_number` STRING COMMENT 'Version identifier for the order guide. Incremented when changes are made to orderable configurations, pricing, or availability. Format: major.minor (e.g., 1.0, 1.1, 2.0).. Valid values are `^[0-9]{1,3}.[0-9]{1,3}$`',
    CONSTRAINT pk_order_guide PRIMARY KEY(`order_guide_id`)
) COMMENT 'The formal dealer order guide defining which SKUs, trim levels, option packages, and colors are orderable by dealers for a given MY, market, and sales channel. Captures order guide version, effective date range, market/region, sales channel, orderable SKU list, option availability matrix, minimum/maximum order constraints, and order guide approval status. Published to dealer DMS systems and governs what dealers can order from the factory.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` (
    `aftersales_nameplate_id` BIGINT COMMENT 'Primary key for nameplate',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Cost accounting per nameplate required for budgeting and internal reporting; finance cost_center tracks expenses for each product line.',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to compliance.jurisdiction. Business justification: REQUIRED: Nameplate strategy teams record the primary jurisdiction to align emissions, safety, and tax compliance across markets.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: REQUIRED: Assign primary assembly plant for each nameplate; production planners need this for plant‑level capacity and allocation.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Product Manager role must be linked to an employee for accountability in nameplate strategy and performance dashboards.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Profitability analysis per nameplate uses finance profit_center to allocate revenue and margin; essential for product line P&L reports.',
    `adas_level` STRING COMMENT 'Highest SAE automation level supported by this nameplates ADAS features (Level 0 = no automation, Level 5 = full automation). Based on SAE J3016 standard.. Valid values are `level_0|level_1|level_2|level_3|level_4|level_5`',
    `body_style_primary` STRING COMMENT 'Primary body style configuration for this nameplate (e.g., 4-door sedan, 2-door coupe, crew cab pickup, extended wheelbase van). Multiple body styles may exist within a nameplate; this represents the flagship or most common configuration.',
    `brand_code` STRING COMMENT 'Code representing the brand or marque under which this nameplate is marketed (e.g., FORD, CHEV, TOYOTA, LEXUS).. Valid values are `^[A-Z]{2,10}$`',
    `cafe_category` STRING COMMENT 'CAFE regulatory category for fuel economy compliance: passenger car, light truck, or exempt. Used for EPA and NHTSA reporting.. Valid values are `passenger_car|light_truck|exempt`',
    `aftersales_nameplate_code` STRING COMMENT 'Unique alphanumeric code identifying the nameplate in enterprise systems (e.g., F150, CAMRY, SILVERADO). Used as the business identifier across PLM, ERP, and DMS systems.. Valid values are `^[A-Z0-9]{3,15}$`',
    `competitive_set` STRING COMMENT 'Comma-separated list of primary competitor nameplates that this nameplate is benchmarked against (e.g., Toyota Camry, Honda Accord, Nissan Altima). Used for competitive analysis and positioning.',
    `connectivity_capability` STRING COMMENT 'Level of connected vehicle capability: none (no connectivity), basic (telematics only), advanced (OTA updates, cloud services), v2x (Vehicle-to-Everything communication).. Valid values are `none|basic|advanced|v2x`',
    `created_by_user` STRING COMMENT 'User ID or name of the person who created this nameplate record. Used for audit trail and accountability.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this nameplate record was first created in the system. Used for audit trail and data lineage.',
    `design_language_theme` STRING COMMENT 'Name or description of the design language or styling theme applied to this nameplate (e.g., Kodo Soul of Motion, Sensual Purity, Bold American Truck). Used for design continuity and brand identity.',
    `emissions_standard_target` STRING COMMENT 'Target emissions compliance standard for this nameplate (e.g., EPA Tier 3, Euro 6d, China 6b, LEV III). Multiple standards may apply; this represents the most stringent.',
    `eop_quarter` STRING COMMENT 'Fiscal quarter within the EOP year when production ceased or is planned to cease (Q1, Q2, Q3, Q4). Null if eop_year is null.. Valid values are `Q1|Q2|Q3|Q4`',
    `eop_year` STRING COMMENT 'Calendar year when this nameplate ceased or is planned to cease production. Null for active nameplates with no planned discontinuation.',
    `global_availability_flag` BOOLEAN COMMENT 'Indicates whether this nameplate is available globally (true) or limited to specific regional markets (false).',
    `heritage_lineage` STRING COMMENT 'Textual description of the nameplates heritage and generational lineage (e.g., Successor to Model T, 14th generation). Used for brand storytelling and historical tracking.',
    `homologation_markets` STRING COMMENT 'Comma-separated list of regulatory markets for which this nameplate has received or is pursuing homologation approval (e.g., USA, EUR, CHN, JPN). Used for compliance tracking.',
    `lifecycle_status` STRING COMMENT 'Current lifecycle status of the nameplate: concept (pre-development), development (engineering phase), active (in production and sales), phaseout (end-of-life transition), discontinued (no longer produced).. Valid values are `concept|development|active|phaseout|discontinued`',
    `market_positioning_tier` STRING COMMENT 'Strategic market positioning tier indicating the target customer segment and price point (entry-level, mainstream, premium, luxury, performance).. Valid values are `entry|mainstream|premium|luxury|performance`',
    `marketing_tagline` STRING COMMENT 'Primary marketing tagline or slogan associated with this nameplate (e.g., Built Ford Tough, The Ultimate Driving Machine). Used for brand consistency across campaigns.',
    `modified_by_user` STRING COMMENT 'User ID or name of the person who last modified this nameplate record. Used for audit trail and accountability.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this nameplate record was last modified. Used for audit trail and change tracking.',
    `aftersales_nameplate_name` STRING COMMENT 'Commercial brand name of the vehicle nameplate as marketed to consumers (e.g., F-150, Camry, Silverado, Mustang Mach-E).',
    `ncap_rating_target` STRING COMMENT 'Target safety rating for this nameplate under applicable NCAP programs (e.g., 5-star Euro NCAP, 5-star NHTSA). Used for safety engineering and marketing.. Valid values are `3_star|4_star|5_star|not_rated`',
    `ota_update_enabled` BOOLEAN COMMENT 'Indicates whether this nameplate supports over-the-air software updates for ECU firmware, infotainment, and vehicle systems (true/false).',
    `platform_code` STRING COMMENT 'Engineering platform or architecture code on which this nameplate is built (e.g., MQB, TNGA, T1XX). Shared platforms enable economies of scale across multiple nameplates.. Valid values are `^[A-Z0-9]{2,10}$`',
    `powertrain_family` STRING COMMENT 'Primary powertrain technology family for this nameplate: ICE (Internal Combustion Engine), HEV (Hybrid Electric Vehicle), PHEV (Plug-in Hybrid Electric Vehicle), BEV (Battery Electric Vehicle), FCEV (Fuel Cell Electric Vehicle).. Valid values are `ice|hev|phev|bev|fcev`',
    `predecessor_nameplate_code` STRING COMMENT 'Nameplate code of the direct predecessor model that this nameplate replaced or evolved from. Null for entirely new nameplates with no predecessor.. Valid values are `^[A-Z0-9]{3,15}$`',
    `record_source_system` STRING COMMENT 'Name or code of the source system from which this nameplate record originated (e.g., Teamcenter PLM, SAP S/4HANA MM, Salesforce Automotive Cloud). Used for data lineage and integration tracking.',
    `regional_scope` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes or regional market codes where this nameplate is available (e.g., USA,CAN,MEX for North America; EUR for Europe). Null if global_availability_flag is true.',
    `regulatory_class` STRING COMMENT 'Regulatory classification for emissions, safety, and fuel economy standards (e.g., passenger car, light truck, medium-duty vehicle). Varies by jurisdiction (NHTSA, EPA, CARB, UNECE).',
    `seating_capacity_range` STRING COMMENT 'Range of seating capacity across all configurations of this nameplate (e.g., 5, 5-7, 2-3). Format: single number or range (min-max).. Valid values are `^d{1,2}(-d{1,2})?$`',
    `sop_quarter` STRING COMMENT 'Fiscal quarter within the SOP year when production commenced (Q1, Q2, Q3, Q4).. Valid values are `Q1|Q2|Q3|Q4`',
    `sop_year` STRING COMMENT 'Calendar year when this nameplate first entered production. Used for heritage tracking and program planning.',
    `ssot_governance_note` STRING COMMENT 'Moved from aftersales to product domain per VREQ-026; nameplate is product SSOT.',
    `target_annual_volume` STRING COMMENT 'Planned annual production volume (units) for this nameplate at steady-state production. Used for capacity planning and supply chain forecasting.',
    `target_msrp_max` DECIMAL(18,2) COMMENT 'Maximum target MSRP in USD for the highest-trim configuration of this nameplate. Used for portfolio planning and competitive positioning.',
    `target_msrp_min` DECIMAL(18,2) COMMENT 'Minimum target MSRP in USD for the base configuration of this nameplate. Used for portfolio planning and competitive positioning.',
    `vehicle_segment` STRING COMMENT 'Market segment classification of the nameplate (e.g., sedan, SUV, truck, commercial vehicle). Used for portfolio planning and market analysis. [ENUM-REF-CANDIDATE: sedan|coupe|suv|crossover|truck|van|commercial|sports|luxury — 9 candidates stripped; promote to reference product]',
    `warranty_program_code` STRING COMMENT 'Code identifying the standard warranty program applicable to this nameplate (e.g., basic warranty, powertrain warranty, EV battery warranty). Links to warranty terms and coverage details.. Valid values are `^[A-Z0-9]{3,10}$`',
    CONSTRAINT pk_aftersales_nameplate PRIMARY KEY(`aftersales_nameplate_id`)
) COMMENT 'SSOT for vehicle nameplate definitions — the commercial brand identity of a vehicle line (e.g., F-150, Silverado, Camry, Mustang). Owns nameplate code, brand affiliation, vehicle segment classification (car/truck/SUV/commercial), powertrain family (ICE/HEV/PHEV/EV), market positioning tier, global vs. regional availability flag, nameplate lifecycle status (active/discontinued), SOP (Start of Production) year, EOP (End of Production) year, and nameplate heritage lineage. This is the root anchor for all program and model year planning.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`product`.`product_segment` ADD CONSTRAINT `fk_product_product_segment_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ADD CONSTRAINT `fk_product_catalog_publication_catalog_version_id` FOREIGN KEY (`catalog_version_id`) REFERENCES `vibe_automotive_v1`.`product`.`catalog_version`(`catalog_version_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ADD CONSTRAINT `fk_product_catalog_publication_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ADD CONSTRAINT `fk_product_catalog_publication_superseded_by_publication_catalog_publication_id` FOREIGN KEY (`superseded_by_publication_catalog_publication_id`) REFERENCES `vibe_automotive_v1`.`product`.`catalog_publication`(`catalog_publication_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`package_availability` ADD CONSTRAINT `fk_product_package_availability_aftersales_option_package_id` FOREIGN KEY (`aftersales_option_package_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_option_package`(`aftersales_option_package_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`package_availability` ADD CONSTRAINT `fk_product_package_availability_catalog_publication_id` FOREIGN KEY (`catalog_publication_id`) REFERENCES `vibe_automotive_v1`.`product`.`catalog_publication`(`catalog_publication_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` ADD CONSTRAINT `fk_product_pricing_condition_assignment_catalog_version_id` FOREIGN KEY (`catalog_version_id`) REFERENCES `vibe_automotive_v1`.`product`.`catalog_version`(`catalog_version_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` ADD CONSTRAINT `fk_product_pricing_condition_assignment_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ADD CONSTRAINT `fk_product_catalog_version_msrp_price_book_id` FOREIGN KEY (`msrp_price_book_id`) REFERENCES `vibe_automotive_v1`.`product`.`msrp_price_book`(`msrp_price_book_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ADD CONSTRAINT `fk_product_catalog_version_previous_catalog_version_id` FOREIGN KEY (`previous_catalog_version_id`) REFERENCES `vibe_automotive_v1`.`product`.`catalog_version`(`catalog_version_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_aftersales_trim_level_id` FOREIGN KEY (`aftersales_trim_level_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_trim_level`(`aftersales_trim_level_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ADD CONSTRAINT `fk_product_aftersales_trim_level_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ADD CONSTRAINT `fk_product_aftersales_option_package_ssot_aftersales_option_package_id` FOREIGN KEY (`ssot_aftersales_option_package_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_option_package`(`aftersales_option_package_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ADD CONSTRAINT `fk_product_aftersales_model_year_program_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ADD CONSTRAINT `fk_product_msrp_price_book_superseded_by_price_book_msrp_price_book_id` FOREIGN KEY (`superseded_by_price_book_msrp_price_book_id`) REFERENCES `vibe_automotive_v1`.`product`.`msrp_price_book`(`msrp_price_book_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ADD CONSTRAINT `fk_product_msrp_price_entry_aftersales_trim_level_id` FOREIGN KEY (`aftersales_trim_level_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_trim_level`(`aftersales_trim_level_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ADD CONSTRAINT `fk_product_msrp_price_entry_market_availability_id` FOREIGN KEY (`market_availability_id`) REFERENCES `vibe_automotive_v1`.`product`.`market_availability`(`market_availability_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ADD CONSTRAINT `fk_product_msrp_price_entry_msrp_price_book_id` FOREIGN KEY (`msrp_price_book_id`) REFERENCES `vibe_automotive_v1`.`product`.`msrp_price_book`(`msrp_price_book_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ADD CONSTRAINT `fk_product_msrp_price_entry_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ADD CONSTRAINT `fk_product_msrp_price_entry_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ADD CONSTRAINT `fk_product_market_availability_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ADD CONSTRAINT `fk_product_order_guide_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ADD CONSTRAINT `fk_product_order_guide_superseded_by_order_guide_id` FOREIGN KEY (`superseded_by_order_guide_id`) REFERENCES `vibe_automotive_v1`.`product`.`order_guide`(`order_guide_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`product` SET TAGS ('dbx_pii_division' = 'business');
ALTER SCHEMA `vibe_automotive_v1`.`product` SET TAGS ('dbx_pii_domain' = 'product');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` SET TAGS ('dbx_pii_subdomain' = 'configuration_management');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `bom_header_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Header ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `bom_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Bom Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `adas_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Advanced Driver Assistance Systems (ADAS) Level');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `adas_level` SET TAGS ('dbx_pii_value_regex' = 'L0|L1|L2|L3|L4|L5');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `alternative_bom_group` SET TAGS ('dbx_pii_business_glossary_term' = 'Alternative BOM Group');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `alternative_bom_group` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{1,20}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{3,50}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `base_unit_of_measure` SET TAGS ('dbx_pii_business_glossary_term' = 'Base Unit of Measure');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `base_unit_of_measure` SET TAGS ('dbx_pii_value_regex' = 'EA|PC|SET|KIT|ASSY');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `change_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Change Order (ECO) Number');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `change_number` SET TAGS ('dbx_pii_value_regex' = '^ECO-[A-Z0-9]{6,15}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `configuration_profile` SET TAGS ('dbx_pii_business_glossary_term' = 'Configuration Profile');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `configuration_profile` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{3,30}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `connectivity_package` SET TAGS ('dbx_pii_business_glossary_term' = 'Connectivity Package');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `connectivity_package` SET TAGS ('dbx_pii_value_regex' = 'none|basic|premium|V2X');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Effective To Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `emissions_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Emissions Standard');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `emissions_standard` SET TAGS ('dbx_pii_value_regex' = 'EPA_TIER3|CARB_LEV3|EURO6|EURO7|CHINA6|BS6');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `engineering_release_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Engineering Release Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `eop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `homologation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `homologation_status` SET TAGS ('dbx_pii_value_regex' = 'pending|approved|certified|rejected|expired');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `is_configurable` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Configurable Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `lot_size_minimum` SET TAGS ('dbx_pii_business_glossary_term' = 'Minimum Lot Size');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `market_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Region');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `msrp_base_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Base Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `msrp_base_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `nameplate_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `nameplate_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{3,20}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Notes');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturing Plant Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `plant_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `revision_level` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Revision Level');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `revision_level` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `safety_certification_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Certification Level');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `safety_certification_level` SET TAGS ('dbx_pii_value_regex' = '5_star|4_star|3_star|not_rated|pending');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `sop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `standard_cost_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `standard_cost_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `bom_header_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `bom_header_status` SET TAGS ('dbx_pii_value_regex' = 'draft|active|superseded|obsolete|frozen|pending_approval');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `total_assembly_weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Assembly Weight (Kilograms)');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `total_component_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Component Count');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `bom_header_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `bom_header_type` SET TAGS ('dbx_pii_value_regex' = 'commercial|engineering|service|manufacturing|planning|sales');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `usage` SET TAGS ('dbx_pii_business_glossary_term' = 'BOM Usage');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `variant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Variant Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `variant_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{2,15}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `vin_pattern` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN) Pattern');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `vin_pattern` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9*]{17}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `warranty_program_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Program Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ALTER COLUMN `warranty_program_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{3,15}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`product_bom_line` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`product_bom_line` SET TAGS ('dbx_pii_subdomain' = 'configuration_management');
ALTER TABLE `vibe_automotive_v1`.`product`.`product_bom_line` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`product_bom_line` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`product_bom_line` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`product_segment` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`product_segment` SET TAGS ('dbx_pii_subdomain' = 'configuration_management');
ALTER TABLE `vibe_automotive_v1`.`product`.`product_segment` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`product_segment` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`product_segment` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` SET TAGS ('dbx_pii_subdomain' = 'catalog_publishing');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `catalog_publication_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Catalog Publication ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `catalog_version_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Catalog Version ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `primary_catalog_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Published By User ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `primary_catalog_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `primary_catalog_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Published By User ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `superseded_by_publication_catalog_publication_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Superseded By Publication ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `approved_by_user_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By User Name');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `approved_by_user_name` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `approved_by_user_name` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `catalog_publication_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Publication Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `distribution_confirmation_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Distribution Confirmation Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `distribution_confirmation_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Distribution Confirmation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `distribution_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Distribution Method');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `distribution_method` SET TAGS ('dbx_pii_value_regex' = 'push|pull|batch|real_time|scheduled');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `distribution_retry_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Distribution Retry Count');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `file_checksum` SET TAGS ('dbx_pii_business_glossary_term' = 'File Checksum');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `file_name` SET TAGS ('dbx_pii_business_glossary_term' = 'File Name');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `file_size_bytes` SET TAGS ('dbx_pii_business_glossary_term' = 'File Size Bytes');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `format` SET TAGS ('dbx_pii_business_glossary_term' = 'Publication Format');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `language_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Language Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `language_code` SET TAGS ('dbx_pii_value_regex' = '^[a-z]{2}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `last_distribution_error` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Distribution Error');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `nameplate_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Count');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Publication Notes');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Publication Number');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `number` SET TAGS ('dbx_pii_value_regex' = '^PUB-[0-9]{8}-[A-Z0-9]{6}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `priority_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Priority Level');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `priority_level` SET TAGS ('dbx_pii_value_regex' = 'critical|high|normal|low');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `published_by_user_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Published By User Name');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `published_by_user_name` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `published_by_user_name` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `recall_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Recall Reason');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `recall_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Recall Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `record_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Count');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `regulatory_filing_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Filing Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `regulatory_filing_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Filing Reference');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `regulatory_filing_required_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Filing Required Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `catalog_publication_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Publication Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `catalog_publication_status` SET TAGS ('dbx_pii_value_regex' = 'draft|approved|published|recalled|superseded|archived');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `target_channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Channel');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `target_country_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Country Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `target_country_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `target_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Region');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `target_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Target System');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `trim_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Trim Count');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `catalog_publication_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Publication Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `catalog_publication_type` SET TAGS ('dbx_pii_value_regex' = 'dealer|consumer|regulatory|internal|supplier|fleet');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `validation_error_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Validation Error Count');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `validation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Validation Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `validation_status` SET TAGS ('dbx_pii_value_regex' = 'passed|failed|warning|not_validated');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ALTER COLUMN `validation_warning_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Validation Warning Count');
ALTER TABLE `vibe_automotive_v1`.`product`.`package_availability` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`package_availability` SET TAGS ('dbx_pii_subdomain' = 'catalog_publishing');
ALTER TABLE `vibe_automotive_v1`.`product`.`package_availability` SET TAGS ('dbx_pii_association_edges' = 'product.option_package,dealer.dealership');
ALTER TABLE `vibe_automotive_v1`.`product`.`package_availability` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`package_availability` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`package_availability` ALTER COLUMN `package_availability_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Packageavailability - Package Availability Id');
ALTER TABLE `vibe_automotive_v1`.`product`.`package_availability` ALTER COLUMN `aftersales_option_package_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Packageavailability - Option Package Id');
ALTER TABLE `vibe_automotive_v1`.`product`.`package_availability` ALTER COLUMN `catalog_publication_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Catalog Publication Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`package_availability` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Packageavailability - Dealership Id');
ALTER TABLE `vibe_automotive_v1`.`product`.`package_availability` ALTER COLUMN `launch_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Package Launch Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`package_availability` ALTER COLUMN `package_availability_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Package Availability Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` SET TAGS ('dbx_pii_subdomain' = 'revenue_pricing');
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` SET TAGS ('dbx_pii_association_edges' = 'product.sku,billing.price_condition');
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` ALTER COLUMN `pricing_condition_assignment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Pricingconditionassignment - Pricing Condition Assignment Id');
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` ALTER COLUMN `billing_price_condition_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Pricingconditionassignment - Price Condition Id');
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` ALTER COLUMN `catalog_version_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Catalog Version Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` ALTER COLUMN `sku_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Pricingconditionassignment - Sku Id');
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` ALTER COLUMN `pricing_condition_assignment_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Condition Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` ALTER COLUMN `pricing_condition_assignment_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Condition Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` ALTER COLUMN `value` SET TAGS ('dbx_pii_business_glossary_term' = 'Condition Value');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` SET TAGS ('dbx_pii_subdomain' = 'catalog_publishing');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `catalog_version_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Catalog Version Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `msrp_price_book_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Book Id');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `previous_catalog_version_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Previous Catalog Version Id');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `previous_catalog_version_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `change_summary` SET TAGS ('dbx_pii_business_glossary_term' = 'Change Summary');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `is_current` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Current');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `catalog_version_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Name');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `region_coverage` SET TAGS ('dbx_pii_business_glossary_term' = 'Region Coverage');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `release_notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Release Notes');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Segment');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `sku_structure_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Structure Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `catalog_version_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `total_models` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Models');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `total_options` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Options');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `catalog_version_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Catalog Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_version` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` SET TAGS ('dbx_pii_subdomain' = 'configuration_management');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `sku_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `aftersales_trim_level_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Aftersales Trim Level Id');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `aftersales_trim_level_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `aftersales_body_style_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Body Style Id');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `aftersales_body_style_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `aftersales_color_option_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Color Option Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `homologation_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Record Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `production_bom_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Bill of Materials (BOM) Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `adas_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Advanced Driver Assistance Systems (ADAS) Level');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `adas_level` SET TAGS ('dbx_pii_value_regex' = 'none|level_1|level_2|level_3|level_4|level_5');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_pii_business_glossary_term' = 'Battery Capacity (Kilowatt-Hours)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `cargo_volume_cu_ft` SET TAGS ('dbx_pii_business_glossary_term' = 'Cargo Volume (Cubic Feet)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `curb_weight_lbs` SET TAGS ('dbx_pii_business_glossary_term' = 'Curb Weight (Pounds)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `door_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Door Count');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `drivetrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Drivetrain Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `drivetrain_type` SET TAGS ('dbx_pii_value_regex' = 'FWD|RWD|AWD|4WD');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `electric_range_miles` SET TAGS ('dbx_pii_business_glossary_term' = 'Electric Range (Miles)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `emission_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Emission Standard');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `engine_displacement_liters` SET TAGS ('dbx_pii_business_glossary_term' = 'Engine Displacement (Liters)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `eop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `epa_city_mpg` SET TAGS ('dbx_pii_business_glossary_term' = 'Environmental Protection Agency (EPA) City Miles Per Gallon (MPG)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `epa_combined_mpg` SET TAGS ('dbx_pii_business_glossary_term' = 'Environmental Protection Agency (EPA) Combined Miles Per Gallon (MPG)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `epa_highway_mpg` SET TAGS ('dbx_pii_business_glossary_term' = 'Environmental Protection Agency (EPA) Highway Miles Per Gallon (MPG)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `fuel_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `gvwr_lbs` SET TAGS ('dbx_pii_business_glossary_term' = 'Gross Vehicle Weight Rating (GVWR) Pounds');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `horsepower` SET TAGS ('dbx_pii_business_glossary_term' = 'Horsepower (HP)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `interior_color_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Interior Color Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `interior_color_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{3,8}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `interior_material_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Interior Material Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `interior_material_type` SET TAGS ('dbx_pii_value_regex' = 'cloth|leather|synthetic_leather|alcantara|vinyl');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `invoice_price_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Invoice Price Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `invoice_price_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Stock Keeping Unit (SKU) Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_value_regex' = 'planned|active|orderable|production|phasing_out|discontinued');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `market_destination_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Destination Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `market_destination_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `msrp_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `msrp_currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Currency Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `msrp_currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `ncap_safety_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'New Car Assessment Programme (NCAP) Safety Rating');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `ncap_safety_rating` SET TAGS ('dbx_pii_value_regex' = '^[1-5]$|not_rated');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `option_package_codes` SET TAGS ('dbx_pii_business_glossary_term' = 'Option Package Codes');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `orderable_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Orderable End Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `orderable_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Orderable Start Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `powertrain_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `powertrain_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `seating_capacity` SET TAGS ('dbx_pii_business_glossary_term' = 'Seating Capacity');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `seating_capacity` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `sop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `torque_lb_ft` SET TAGS ('dbx_pii_business_glossary_term' = 'Torque (Pound-Feet)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `towing_capacity_lbs` SET TAGS ('dbx_pii_business_glossary_term' = 'Towing Capacity (Pounds)');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `transmission_speed_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Transmission Speed Count');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `transmission_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `transmission_type` SET TAGS ('dbx_pii_value_regex' = 'manual|automatic|cvt|dct|amt');
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ALTER COLUMN `wheelbase_inches` SET TAGS ('dbx_pii_business_glossary_term' = 'Wheelbase (Inches)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` SET TAGS ('dbx_pii_subdomain' = 'configuration_management');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `aftersales_trim_level_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Trim Level Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Identifier (ID)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `adas_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Advanced Driver Assistance Systems (ADAS) Level');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `adas_level` SET TAGS ('dbx_pii_value_regex' = 'none|level_1|level_2|level_3');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `availability_regions` SET TAGS ('dbx_pii_business_glossary_term' = 'Availability Regions');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `battery_capacity_kwh` SET TAGS ('dbx_pii_business_glossary_term' = 'Battery Capacity (Kilowatt-Hours)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `body_style` SET TAGS ('dbx_pii_business_glossary_term' = 'Body Style');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `cargo_volume_cu_ft` SET TAGS ('dbx_pii_business_glossary_term' = 'Cargo Volume (Cubic Feet)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `aftersales_trim_level_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Trim Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `aftersales_trim_level_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `aftersales_trim_level_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Trim Description');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `drivetrain` SET TAGS ('dbx_pii_business_glossary_term' = 'Drivetrain Configuration');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `drivetrain` SET TAGS ('dbx_pii_value_regex' = 'FWD|RWD|AWD|4WD');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `electric_range_miles` SET TAGS ('dbx_pii_business_glossary_term' = 'Electric Range (Miles)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `engine_displacement_liters` SET TAGS ('dbx_pii_business_glossary_term' = 'Engine Displacement (Liters)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `eop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `epa_city_mpg` SET TAGS ('dbx_pii_business_glossary_term' = 'EPA City Miles Per Gallon (MPG)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `epa_combined_mpg` SET TAGS ('dbx_pii_business_glossary_term' = 'EPA Combined Miles Per Gallon (MPG)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `epa_highway_mpg` SET TAGS ('dbx_pii_business_glossary_term' = 'EPA Highway Miles Per Gallon (MPG)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `fuel_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `fuel_type` SET TAGS ('dbx_pii_value_regex' = 'gasoline|diesel|E85|electric|hydrogen|hybrid');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `horsepower` SET TAGS ('dbx_pii_business_glossary_term' = 'Horsepower (HP)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `invoice_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Invoice Price');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `invoice_price` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `is_fleet_eligible` SET TAGS ('dbx_pii_business_glossary_term' = 'Fleet Eligible Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `is_special_edition` SET TAGS ('dbx_pii_business_glossary_term' = 'Special Edition Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `market_segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Segment');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `msrp_base_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Base Price');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `msrp_base_price` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `msrp_currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'MSRP Currency Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `msrp_currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `aftersales_trim_level_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Trim Name');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `ncap_overall_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'New Car Assessment Programme (NCAP) Overall Rating');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `payload_capacity_lbs` SET TAGS ('dbx_pii_business_glossary_term' = 'Payload Capacity (Pounds)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `production_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `production_status` SET TAGS ('dbx_pii_value_regex' = 'planned|pre_production|active|discontinued|end_of_life');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `rank` SET TAGS ('dbx_pii_business_glossary_term' = 'Trim Rank');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `seating_capacity` SET TAGS ('dbx_pii_business_glossary_term' = 'Seating Capacity');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `seating_capacity` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `sop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `standard_features_summary` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Features Summary');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `torque_lb_ft` SET TAGS ('dbx_pii_business_glossary_term' = 'Torque (Pound-Feet)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `towing_capacity_lbs` SET TAGS ('dbx_pii_business_glossary_term' = 'Towing Capacity (Pounds)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `transmission_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Transmission Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `warranty_basic_miles` SET TAGS ('dbx_pii_business_glossary_term' = 'Basic Warranty Mileage Limit (Miles)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `warranty_basic_months` SET TAGS ('dbx_pii_business_glossary_term' = 'Basic Warranty Duration (Months)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `warranty_powertrain_miles` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Warranty Mileage Limit (Miles)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_trim_level` ALTER COLUMN `warranty_powertrain_months` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Warranty Duration (Months)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` SET TAGS ('dbx_pii_subdomain' = 'configuration_management');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `attachment_rate_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Attachment Rate (Percent)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `available_markets` SET TAGS ('dbx_pii_business_glossary_term' = 'Available Markets');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `available_model_years` SET TAGS ('dbx_pii_business_glossary_term' = 'Available Model Years');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `available_trim_levels` SET TAGS ('dbx_pii_business_glossary_term' = 'Available Trim Levels');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `bom_reference_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Reference Number');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `aftersales_option_package_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Package Category');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `aftersales_option_package_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Package Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `aftersales_option_package_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `content_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Content Description');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `dealer_cost_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `dealer_cost_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `discontinuation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Discontinuation Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `emissions_impact_grams_co2_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Emissions Impact (Grams CO2 per Kilometer)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `excludes_package_codes` SET TAGS ('dbx_pii_business_glossary_term' = 'Excludes Package Codes');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `fuel_economy_impact_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Economy Impact (Percent)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `included_in_package_codes` SET TAGS ('dbx_pii_business_glossary_term' = 'Included In Package Codes');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `installation_location` SET TAGS ('dbx_pii_business_glossary_term' = 'Installation Location');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `installation_location` SET TAGS ('dbx_pii_value_regex' = 'factory|port|dealer');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `introduction_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Introduction Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `is_orderable` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Orderable');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `is_visible_to_customer` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Visible to Customer');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `labor_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Labor Hours');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_value_regex' = 'planned|active|phasing_out|discontinued|obsolete');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `marketing_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Marketing Description');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `msrp_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `msrp_currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'MSRP Currency Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `msrp_currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `aftersales_option_package_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Package Name');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `production_feasibility_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Feasibility Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `production_feasibility_status` SET TAGS ('dbx_pii_value_regex' = 'feasible|constrained|unavailable|pending_validation');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `regulatory_approval_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Approval Required');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `requires_package_codes` SET TAGS ('dbx_pii_business_glossary_term' = 'Requires Package Codes');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `sales_rank` SET TAGS ('dbx_pii_business_glossary_term' = 'Sales Rank');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `sku` SET TAGS ('dbx_pii_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `supplier_part_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Part Number');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `aftersales_option_package_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Package Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `aftersales_option_package_type` SET TAGS ('dbx_pii_value_regex' = 'group|standalone|accessory|dealer_installed|port_installed');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `warranty_miles` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Miles');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `warranty_months` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Months');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_option_package` ALTER COLUMN `weight_kg` SET TAGS ('dbx_pii_business_glossary_term' = 'Weight (Kilograms)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` SET TAGS ('dbx_pii_subdomain' = 'configuration_management');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `aftersales_model_year_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year Program Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `control_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY) Program ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Manager ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `inspection_plan_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Manager ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Plant ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Requirement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `actual_production_volume` SET TAGS ('dbx_pii_business_glossary_term' = 'Actual Production Volume');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `adas_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Advanced Driver Assistance Systems (ADAS) Level');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `adas_level` SET TAGS ('dbx_pii_value_regex' = 'level_0|level_1|level_2|level_3|level_4|level_5');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `bom_complexity_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Bill of Materials (BOM) Complexity Score');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `budget_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `budget_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `budget_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Budget Currency');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `budget_currency` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `cafe_target` SET TAGS ('dbx_pii_business_glossary_term' = 'Corporate Average Fuel Economy (CAFE) Target');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `capex_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Capital Expenditure (CapEx) Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `capex_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `aftersales_model_year_program_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `aftersales_model_year_program_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `connected_services_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Services Enabled');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `aftersales_model_year_program_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Description');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `eop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production (EOP) Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `epa_rating_target` SET TAGS ('dbx_pii_business_glossary_term' = 'Environmental Protection Agency (EPA) Rating Target');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `fmea_completed` SET TAGS ('dbx_pii_business_glossary_term' = 'Failure Mode and Effects Analysis (FMEA) Completed');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `homologation_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Region');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `homologation_region` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}(,[A-Z]{3})*$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `launch_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Launch Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `msrp_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Currency');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `msrp_currency` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `aftersales_model_year_program_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Name');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `ncap_target_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'New Car Assessment Programme (NCAP) Target Rating');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `ncap_target_rating` SET TAGS ('dbx_pii_value_regex' = '1_star|2_star|3_star|4_star|5_star');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `ota_capable` SET TAGS ('dbx_pii_business_glossary_term' = 'Over-the-Air (OTA) Update Capable');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `phase` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Phase');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `platform_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Platform Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `platform_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_pii_value_regex' = 'ICE|HEV|PHEV|BEV|FCEV');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `ppap_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Part Approval Process (PPAP) Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `ppap_status` SET TAGS ('dbx_pii_value_regex' = 'not_started|in_progress|submitted|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Priority');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `priority` SET TAGS ('dbx_pii_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Risk Level');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `risk_level` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `sop_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `aftersales_model_year_program_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `aftersales_model_year_program_status` SET TAGS ('dbx_pii_value_regex' = 'active|on_hold|cancelled|completed');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `supplier_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Count');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `target_msrp_max` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Manufacturer Suggested Retail Price (MSRP) Maximum');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `target_msrp_max` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `target_msrp_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Manufacturer Suggested Retail Price (MSRP) Minimum');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `target_msrp_min` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `target_production_volume` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Production Volume');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `tooling_investment` SET TAGS ('dbx_pii_business_glossary_term' = 'Tooling Investment');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `tooling_investment` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `vehicle_segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Segment');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `wltp_target` SET TAGS ('dbx_pii_business_glossary_term' = 'Worldwide Harmonised Light Vehicles Test Procedure (WLTP) Target');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` SET TAGS ('dbx_pii_subdomain' = 'revenue_pricing');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `msrp_price_book_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Price Book ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `superseded_by_price_book_msrp_price_book_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Superseded By Price Book ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `approved_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `msrp_price_book_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Book Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `msrp_price_book_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `created_by_user` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `dealer_access_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Access Level');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `dealer_access_level` SET TAGS ('dbx_pii_value_regex' = 'public|authorized_dealer|franchise_only|internal');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `destination_charge_included_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Destination Charge Included Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `last_modified_by_user` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `list_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Price List Category');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `list_category` SET TAGS ('dbx_pii_value_regex' = 'base|option|package|accessory|destination');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `market_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `market_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_value_regex' = '^(19|20)d{2}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `msrp_price_book_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Book Name');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `publication_format` SET TAGS ('dbx_pii_business_glossary_term' = 'Publication Format');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `publication_format` SET TAGS ('dbx_pii_value_regex' = 'pdf|xml|json|edi|print');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `published_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Published Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `region_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Region Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `regulatory_compliance_notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Compliance Notes');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `remarks` SET TAGS ('dbx_pii_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `sales_organization` SET TAGS ('dbx_pii_business_glossary_term' = 'Sales Organization');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `msrp_price_book_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Book Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `msrp_price_book_status` SET TAGS ('dbx_pii_value_regex' = 'draft|approved|published|active|superseded|archived');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `tax_treatment_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Treatment Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `tax_treatment_code` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `tax_treatment_code` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `msrp_price_book_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Book Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `msrp_price_book_type` SET TAGS ('dbx_pii_value_regex' = 'standard|fleet|government|export|promotional');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_value_regex' = '^d+.d+$');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` SET TAGS ('dbx_pii_subdomain' = 'revenue_pricing');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `msrp_price_entry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Price Entry Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `aftersales_trim_level_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Trim Level Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `market_availability_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `msrp_price_book_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Book Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `sku_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Stock Keeping Unit (SKU) Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `advertising_fee_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Advertising Fee Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `approved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `base_msrp_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Base Manufacturer Suggested Retail Price (MSRP) Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `change_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Change Reason');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `dealer_invoice_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Invoice Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `dealer_invoice_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `destination_charge_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Destination Charge Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `employee_pricing_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Employee Pricing Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `employee_pricing_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `fleet_eligible_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Fleet Eligible Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `gas_guzzler_tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Gas Guzzler Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `government_eligible_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Government Eligible Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `holdback_percentage` SET TAGS ('dbx_pii_business_glossary_term' = 'Holdback Percentage');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `holdback_percentage` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `luxury_tax_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Luxury Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `prior_msrp_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Prior Manufacturer Suggested Retail Price (MSRP) Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `promotional_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Promotional Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `protection_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Protection Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `publication_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Publication Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `source_record_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Record Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `msrp_price_entry_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `msrp_price_entry_status` SET TAGS ('dbx_pii_value_regex' = 'draft|pending_approval|active|superseded|expired|withdrawn');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `supplier_pricing_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Supplier Pricing Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `supplier_pricing_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `total_msrp_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Manufacturer Suggested Retail Price (MSRP) Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_entry` ALTER COLUMN `msrp_price_entry_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Price Type');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` SET TAGS ('dbx_pii_subdomain' = 'catalog_publishing');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `market_availability_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Availability ID');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `sku_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `allocation_constraint_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Constraint Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `assembly_mode` SET TAGS ('dbx_pii_business_glossary_term' = 'Assembly Mode (CBU/CKD/SKD)');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `assembly_mode` SET TAGS ('dbx_pii_value_regex' = 'cbu|ckd|skd');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `market_availability_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `market_availability_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `dealer_ordering_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Ordering Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `dealer_ordering_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{4,15}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `destination_charge_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Destination Charge Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `emissions_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Emissions Standard');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `ev_battery_warranty_months` SET TAGS ('dbx_pii_business_glossary_term' = 'Electric Vehicle (EV) Battery Warranty Duration Months');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `expiration_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `fuel_economy_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Economy Rating');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `fuel_economy_unit` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Economy Unit');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `fuel_economy_unit` SET TAGS ('dbx_pii_value_regex' = 'mpg|l-per-100km|kwh-per-100km|km-per-l');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `government_incentive_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Government Incentive Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `homologation_approval_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Approval Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `homologation_approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Approval Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `homologation_approval_status` SET TAGS ('dbx_pii_value_regex' = 'approved|pending|rejected|not-required|expired');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `homologation_certificate_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Certificate Number');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `homologation_certificate_number` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `homologation_expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `import_duty_classification` SET TAGS ('dbx_pii_business_glossary_term' = 'Import Duty Classification');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `import_duty_classification` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{4,10}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `import_duty_rate_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Import Duty Rate Percent');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `incentive_eligible_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Incentive Eligible Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `launch_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Launch Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_pii_business_glossary_term' = 'Lead Time Days');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `local_content_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Local Content Percent');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `max_order_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Order Quantity');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `msrp_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Amount');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `msrp_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `msrp_currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'MSRP Currency Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `msrp_currency_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `nameplate_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `nameplate_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{3,15}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `option_package_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Option Package Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `option_package_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `ordering_priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Ordering Priority');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `powertrain_warranty_months` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Warranty Duration Months');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `pre_delivery_inspection_required_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Pre-Delivery Inspection (PDI) Required Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `record_source_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Source System');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `record_source_system` SET TAGS ('dbx_pii_value_regex' = 'sap-sd|plm|dms|pricing-engine|manual');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `safety_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Safety Rating');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `safety_rating` SET TAGS ('dbx_pii_value_regex' = '^[0-5]-star$|not-rated');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `sales_channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `sales_channel` SET TAGS ('dbx_pii_value_regex' = 'retail|fleet|government|export|direct|online');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `market_availability_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Availability Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `market_availability_status` SET TAGS ('dbx_pii_value_regex' = 'available|restricted|not-offered|discontinued|pre-order|limited');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `trim_level_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Trim Level Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `trim_level_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9_]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `warranty_mileage` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Mileage Limit');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `warranty_months` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Duration Months');
ALTER TABLE `vibe_automotive_v1`.`product`.`market_availability` ALTER COLUMN `withdrawal_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Withdrawal Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` SET TAGS ('dbx_pii_subdomain' = 'catalog_publishing');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `order_guide_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Order Guide Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `order_last_modified_by_user_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Modified By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `order_last_modified_by_user_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `order_last_modified_by_user_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `primary_order_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Approved By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `primary_order_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `primary_order_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `superseded_by_order_guide_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Superseded By Order Guide Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `tertiary_order_last_modified_by_user_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Modified By User Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `tertiary_order_last_modified_by_user_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `tertiary_order_last_modified_by_user_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `allocation_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Allocation Method');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `allocation_method` SET TAGS ('dbx_pii_value_regex' = 'turn_and_earn|historical_sales|market_share|equal_distribution|custom');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_value_regex' = 'not_submitted|pending_review|approved|rejected|conditional_approval');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `bank_close_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Order Bank Close Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `bank_open_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Order Bank Open Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `base_msrp_max` SET TAGS ('dbx_pii_business_glossary_term' = 'Base Manufacturer Suggested Retail Price (MSRP) Maximum');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `base_msrp_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Base Manufacturer Suggested Retail Price (MSRP) Minimum');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `build_to_stock_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Build To Stock Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `cafe_compliance_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Corporate Average Fuel Economy (CAFE) Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `order_guide_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Order Guide Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `order_guide_code` SET TAGS ('dbx_pii_value_regex' = '^OG-[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `color_option_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Color Option Count');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `dealer_invoice_discount_percentage` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Invoice Discount Percentage');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `dealer_invoice_discount_percentage` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `order_guide_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Order Guide Description');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `emissions_standard` SET TAGS ('dbx_pii_business_glossary_term' = 'Emissions Standard');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `emissions_standard` SET TAGS ('dbx_pii_value_regex' = 'EPA_TIER3|CARB_LEV3|EURO6|EURO7|CHINA6|BS6');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `fleet_eligible_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Fleet Eligible Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `homologation_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Region');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `incentive_program_eligible_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Incentive Program Eligible Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `lead_time_days_max` SET TAGS ('dbx_pii_business_glossary_term' = 'Lead Time Days Maximum');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `lead_time_days_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Lead Time Days Minimum');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `market_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Region');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `maximum_order_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Maximum Order Quantity');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_pii_business_glossary_term' = 'Minimum Order Quantity');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `model_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year (MY)');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `msrp_currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Manufacturer Suggested Retail Price (MSRP) Currency Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `order_guide_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Order Guide Name');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `option_package_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Option Package Count');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `orderable_sku_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Orderable Stock Keeping Unit (SKU) Count');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `ordering_instructions_url` SET TAGS ('dbx_pii_business_glossary_term' = 'Ordering Instructions Uniform Resource Locator (URL)');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `ordering_instructions_url` SET TAGS ('dbx_pii_value_regex' = '^https?://.*$');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `production_plant_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Production Plant Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `production_plant_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{3,6}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `publication_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Publication Date');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `sales_channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `sales_channel` SET TAGS ('dbx_pii_value_regex' = 'retail|fleet|government|export|internal|demo');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `special_order_allowed_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Special Order Allowed Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `order_guide_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Order Guide Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_value_regex' = '^[0-9]{1,3}.[0-9]{1,3}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` SET TAGS ('dbx_pii_subdomain' = 'configuration_management');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` SET TAGS ('dbx_pii_moved_from' = 'aftersales');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` SET TAGS ('dbx_pii_renamed_from' = 'aftersales.nameplate');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` SET TAGS ('dbx_pii_scope_integrity' = 'preserved');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` SET TAGS ('dbx_pii_ssot' = 'product');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` SET TAGS ('dbx_pii_field_services_integrated' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `aftersales_nameplate_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Identifier');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Assembly Plant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Product Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `adas_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Advanced Driver Assistance Systems (ADAS) Level');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `adas_level` SET TAGS ('dbx_pii_value_regex' = 'level_0|level_1|level_2|level_3|level_4|level_5');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `body_style_primary` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Body Style');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `brand_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Brand Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `brand_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `cafe_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Corporate Average Fuel Economy (CAFE) Category');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `cafe_category` SET TAGS ('dbx_pii_value_regex' = 'passenger_car|light_truck|exempt');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `aftersales_nameplate_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `aftersales_nameplate_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{3,15}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `competitive_set` SET TAGS ('dbx_pii_business_glossary_term' = 'Competitive Set');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `competitive_set` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `connectivity_capability` SET TAGS ('dbx_pii_business_glossary_term' = 'Connectivity Capability');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `connectivity_capability` SET TAGS ('dbx_pii_value_regex' = 'none|basic|advanced|v2x');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `created_by_user` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created By User');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `design_language_theme` SET TAGS ('dbx_pii_business_glossary_term' = 'Design Language Theme');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `emissions_standard_target` SET TAGS ('dbx_pii_business_glossary_term' = 'Emissions Standard Target');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `eop_quarter` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production (EOP) Quarter');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `eop_quarter` SET TAGS ('dbx_pii_value_regex' = 'Q1|Q2|Q3|Q4');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `eop_year` SET TAGS ('dbx_pii_business_glossary_term' = 'End of Production (EOP) Year');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `global_availability_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Global Availability Flag');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `heritage_lineage` SET TAGS ('dbx_pii_business_glossary_term' = 'Heritage Lineage');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `homologation_markets` SET TAGS ('dbx_pii_business_glossary_term' = 'Homologation Markets');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_value_regex' = 'concept|development|active|phaseout|discontinued');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `market_positioning_tier` SET TAGS ('dbx_pii_business_glossary_term' = 'Market Positioning Tier');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `market_positioning_tier` SET TAGS ('dbx_pii_value_regex' = 'entry|mainstream|premium|luxury|performance');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `marketing_tagline` SET TAGS ('dbx_pii_business_glossary_term' = 'Marketing Tagline');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Modified By User');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `aftersales_nameplate_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Nameplate Name');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `ncap_rating_target` SET TAGS ('dbx_pii_business_glossary_term' = 'New Car Assessment Programme (NCAP) Rating Target');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `ncap_rating_target` SET TAGS ('dbx_pii_value_regex' = '3_star|4_star|5_star|not_rated');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `ota_update_enabled` SET TAGS ('dbx_pii_business_glossary_term' = 'Over-the-Air (OTA) Update Enabled');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `platform_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Platform Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `platform_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `platform_code` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `powertrain_family` SET TAGS ('dbx_pii_business_glossary_term' = 'Powertrain Family');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `powertrain_family` SET TAGS ('dbx_pii_value_regex' = 'ice|hev|phev|bev|fcev');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `predecessor_nameplate_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Predecessor Nameplate Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `predecessor_nameplate_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{3,15}$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `record_source_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Source System');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `regional_scope` SET TAGS ('dbx_pii_business_glossary_term' = 'Regional Scope');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `regulatory_class` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Vehicle Class');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `seating_capacity_range` SET TAGS ('dbx_pii_business_glossary_term' = 'Seating Capacity Range');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `seating_capacity_range` SET TAGS ('dbx_pii_value_regex' = '^d{1,2}(-d{1,2})?$');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `sop_quarter` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Quarter');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `sop_quarter` SET TAGS ('dbx_pii_value_regex' = 'Q1|Q2|Q3|Q4');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `sop_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Start of Production (SOP) Year');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `target_annual_volume` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Annual Production Volume');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `target_annual_volume` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `target_msrp_max` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Manufacturer Suggested Retail Price (MSRP) Maximum');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `target_msrp_max` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `target_msrp_min` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Manufacturer Suggested Retail Price (MSRP) Minimum');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `target_msrp_min` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `vehicle_segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Segment');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `warranty_program_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Warranty Program Code');
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ALTER COLUMN `warranty_program_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{3,10}$');
