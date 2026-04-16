-- Schema for Domain: product | Business: Manufacturing | Version: v1_ecm
-- Generated on: 2026-04-16 07:42:35

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`product` COMMENT 'SSOT for the commercial product catalog including finished goods, automation systems, electrification solutions, smart infrastructure offerings, and aftermarket parts. Manages product classifications, SKU master data, product hierarchies, configurations, pricing structures, lifecycle stages, and regulatory certifications (CE, UL, RoHS, REACH).';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`hierarchy` (
    `hierarchy_id` BIGINT COMMENT 'Unique surrogate identifier for each node in the product hierarchy tree. Serves as the primary key for the product_hierarchy entity in the Databricks Silver Layer.',
    `classification_id` BIGINT COMMENT 'Identifier of the corresponding classification node in Siemens Teamcenter PLM. Enables cross-system alignment between the commercial product hierarchy (SAP) and the engineering product structure (PLM).',
    `approved_by` STRING COMMENT 'Name or employee identifier of the individual who approved the creation or last significant change to this hierarchy node. Supports governance, audit trail, and change management requirements.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this hierarchy node was formally approved by the designated product portfolio governance authority. Distinct from created_timestamp as approval may occur after initial creation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `business_segment` STRING COMMENT 'Name of the reportable business segment (as defined under IFRS 8 / ASC 280) to which this hierarchy node contributes. Used for segment-level P&L reporting and investor disclosures.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the primary country or market for which this hierarchy node is applicable. Supports regional product portfolio management and country-specific catalog configurations.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this product hierarchy node record was first created in the system. Used for audit trail, data lineage, and change management tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `description` STRING COMMENT 'Extended free-text description of the product hierarchy node, providing business context about the product classification, scope, and strategic positioning within the portfolio.',
    `division_code` STRING COMMENT 'Code identifying the top-level product division to which this hierarchy node belongs (e.g., AUT = Automation Systems, ELC = Electrification Solutions, SMI = Smart Infrastructure). Supports revenue reporting by division.. Valid values are `^[A-Z0-9]{1,6}$`',
    `effective_date` DATE COMMENT 'Date from which this hierarchy node becomes valid and available for product assignment and reporting. Supports time-based validity management aligned with SAP S/4HANA product hierarchy date ranges.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date after which this hierarchy node is no longer valid for new product assignments. Null indicates no planned expiry. Supports time-bounded hierarchy management and historical reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_control_flag` BOOLEAN COMMENT 'Indicates whether products in this hierarchy node are subject to export control regulations (e.g., EAR, ITAR, EU Dual-Use Regulation). Triggers export license review and trade compliance screening.. Valid values are `true|false`',
    `external_code` STRING COMMENT 'Product hierarchy code used in external-facing systems such as customer portals, distributor catalogs, or EDI transactions. May differ from the internal SAP hierarchy node code.',
    `go_to_market_channel` STRING COMMENT 'Primary sales and distribution channel strategy for products classified under this hierarchy node. Informs pricing strategy, margin targets, and channel partner management.. Valid values are `direct|distributor|oem|online|partner|mixed`',
    `gpc_code` STRING COMMENT 'GS1 Global Product Classification brick code that maps this internal hierarchy node to the globally standardized product classification schema. Enables cross-industry product data exchange and benchmarking.. Valid values are `^[0-9]{8}$`',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether products classified under this hierarchy node may contain or involve hazardous materials subject to REACH, RoHS, or OSHA regulations. Triggers additional compliance and documentation requirements.. Valid values are `true|false`',
    `is_leaf_node` BOOLEAN COMMENT 'Indicates whether this node is a terminal leaf node in the hierarchy (i.e., it has no child nodes). Leaf nodes represent the lowest level of classification (Product Line) to which SKUs are directly assigned.. Valid values are `true|false`',
    `is_revenue_reporting_node` BOOLEAN COMMENT 'Indicates whether this hierarchy node is designated as a revenue reporting aggregation point in financial and management reporting. Nodes flagged true are used in P&L roll-up and EBITDA reporting by product line.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'ISO 639-1 two-letter language code for the language in which the short_name and long_name are stored. Supports multilingual product hierarchy descriptions for global operations across multiple countries and regions.. Valid values are `^[A-Z]{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this product hierarchy node record was most recently updated. Used for incremental data loading, change detection, and audit trail maintenance in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `level` STRING COMMENT 'Numeric depth of this node within the product hierarchy tree. Level 1 = Product Division (e.g., Automation Systems), Level 2 = Product Family, Level 3 = Product Group, Level 4 = Product Line. Supports OLAP drill-down and revenue roll-up reporting.. Valid values are `^[1-9][0-9]*$`',
    `level_type` STRING COMMENT 'Business label for the hierarchy depth of this node. Defines whether the node represents a Product Division, Product Family, Product Group, or Product Line. Enables consistent labeling in reports and catalog navigation.. Valid values are `division|family|group|line`',
    `lifecycle_stage` STRING COMMENT 'Current stage of the product portfolio lifecycle for this hierarchy node, based on the standard product lifecycle model. Used in portfolio management, investment prioritization, and discontinuation planning.. Valid values are `introduction|growth|maturity|decline|end_of_life`',
    `long_name` STRING COMMENT 'Full descriptive name of the hierarchy node used in catalog navigation, customer-facing materials, and detailed reporting. Maximum 40 characters per SAP S/4HANA product hierarchy configuration.. Valid values are `.{1,40}`',
    `node_code` STRING COMMENT 'Alphanumeric code uniquely identifying this node within the product hierarchy tree. Corresponds to the SAP S/4HANA product hierarchy key (up to 18 characters). Used as the natural business key for cross-system integration.. Valid values are `^[A-Z0-9_-]{1,18}$`',
    `product_manager` STRING COMMENT 'Name or employee identifier of the product manager accountable for the product classification represented by this hierarchy node. Used for escalation, catalog governance, and stakeholder communication.',
    `region_code` STRING COMMENT 'Internal code identifying the geographic sales or operational region to which this hierarchy node is scoped (e.g., AMER, EMEA, APAC). Supports regional revenue reporting and catalog segmentation.. Valid values are `^[A-Z0-9_-]{1,10}$`',
    `regulatory_scope` STRING COMMENT 'Comma-separated list of applicable regulatory frameworks and compliance standards for products in this hierarchy node (e.g., CE, UL, RoHS, REACH, IEC 62443). Supports compliance tracking and certification management.',
    `responsible_org_unit` STRING COMMENT 'Name or code of the business unit or product management organization responsible for maintaining and governing this hierarchy node. Supports accountability and change management workflows.',
    `sap_hierarchy_path` STRING COMMENT 'Full concatenated hierarchy path string as stored in SAP S/4HANA (e.g., 00100010001). Represents the complete ancestry chain from root to this node using fixed-length segment codes. Used for SAP-native hierarchy queries and integration.',
    `short_name` STRING COMMENT 'Abbreviated display name for the hierarchy node, used in space-constrained UI elements, reports, and dashboard labels. Maximum 20 characters per SAP S/4HANA product hierarchy configuration.. Valid values are `.{1,20}`',
    `sort_order` STRING COMMENT 'Numeric sequence controlling the display order of sibling nodes within the same parent in catalog navigation, reports, and UI tree views. Lower values appear first.. Valid values are `^[0-9]+$`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this hierarchy node was sourced. Supports data lineage tracking and reconciliation between SAP S/4HANA and Siemens Teamcenter PLM.. Valid values are `SAP_S4HANA|TEAMCENTER_PLM|MANUAL|MIGRATION`',
    `source_system_key` STRING COMMENT 'Primary key or unique identifier of this hierarchy node as stored in the originating source system (e.g., SAP product hierarchy key PRODH value). Enables traceability and reconciliation back to the system of record.',
    `status` STRING COMMENT 'Current lifecycle status of the product hierarchy node. Active nodes are available for product assignment and reporting. Obsolete nodes are retained for historical data integrity. Planned nodes are approved but not yet effective.. Valid values are `active|inactive|planned|obsolete|under_review`',
    `strategic_initiative` STRING COMMENT 'Name or code of the corporate strategic initiative or growth program associated with this product hierarchy node (e.g., Digital Factory, Green Energy Transition, Smart Buildings). Supports portfolio-level strategic planning and investment tracking.',
    `technology_platform` STRING COMMENT 'Name of the underlying technology platform or architecture associated with products in this hierarchy node (e.g., TIA Portal, SIMATIC, SENTRON). Supports technology roadmap planning and R&D investment allocation.',
    `unspsc_code` STRING COMMENT 'UNSPSC code mapping this hierarchy node to the United Nations Standard Products and Services Classification. Used in procurement, sourcing (SAP Ariba), and spend analytics for category management.. Valid values are `^[0-9]{8}$`',
    CONSTRAINT pk_hierarchy PRIMARY KEY(`hierarchy_id`)
) COMMENT 'Defines the multi-level commercial product classification tree used across the enterprise — from top-level product division (e.g., Automation Systems, Electrification Solutions, Smart Infrastructure) down through product family, product group, and product line. Each node carries a hierarchy level code, parent node reference, short name, long name, and effective date range. Supports OLAP drill-down, revenue reporting by product line, and catalog navigation. Aligned with SAP S/4HANA product hierarchy configuration.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`product_configuration` (
    `product_configuration_id` BIGINT COMMENT 'Unique surrogate identifier for each product configuration record in the Silver Layer lakehouse. Serves as the primary key for the product_configuration data product.',
    `change_notice_id` BIGINT COMMENT 'Foreign key linking to product.product_change_notice. Business justification: product_configuration.change_notice_number is a STRING reference to the Engineering Change Notice that modified a configuration rule. Adding product_change_notice_id FK normalizes this relationship an',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Product configurations define customer-specific variants of base engineered components. Configure-price-quote (CPQ) systems use this link to validate feasible configurations against engineering design',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: Smart products and automation systems are tracked as configuration items in CMDB. Engineering uses this to manage product configurations that include embedded software, PLCs, and control systems requi',
    `cad_model_id` BIGINT COMMENT 'Business identifier for the variant configuration (VC) model as defined in SAP S/4HANA variant configuration or Siemens Teamcenter product configurator. Uniquely identifies the configuration model template from which this configuration is derived.. Valid values are `^[A-Z0-9_-]{3,50}$`',
    `applicable_certification` STRING COMMENT 'Pipe-separated list of regulatory certifications or standards applicable to this feature selection (e.g., CE|UL|RoHS|REACH|IECEx|ATEX). Drives compliance documentation requirements in order management and export control processes.',
    `approval_status` STRING COMMENT 'Current approval workflow status of the configuration model or change. PENDING awaits review; APPROVED is authorized for production use; REJECTED has been declined; UNDER_REVIEW is in active review; WITHDRAWN has been recalled by the submitter.. Valid values are `PENDING|APPROVED|REJECTED|UNDER_REVIEW|WITHDRAWN`',
    `approved_by` STRING COMMENT 'Name or employee identifier of the authorized person who approved this configuration model or change record. Required for quality management audit trails and regulatory compliance documentation.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this configuration model or feature record was formally approved for use. Provides a precise audit trail timestamp for quality management and regulatory compliance purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `compatible_product_families` STRING COMMENT 'Pipe-separated list of product family codes or platform identifiers with which this configuration model is compatible. Supports cross-sell, upsell, and system integration recommendations in CPQ and CRM.',
    `constraint_rule_description` STRING COMMENT 'Plain-language description of the configuration constraint rule for business users and CPQ administrators (e.g., High voltage 690V selection requires minimum IP54 enclosure protection rating for safety compliance).',
    `constraint_rule_expression` STRING COMMENT 'Formal logical expression or condition defining the configuration constraint rule (e.g., IF VOLTAGE = 690V THEN ENCLOSURE_RATING IN (IP54, IP65)). Encoded in SAP S/4HANA dependency syntax or Teamcenter configurator rule language.',
    `constraint_type` STRING COMMENT 'Type of configuration constraint rule governing the relationship between feature selections. INCOMPATIBLE prevents two features from being selected together; REQUIRES mandates a dependent selection; EXCLUDES prevents a feature when another is chosen; CONDITIONAL applies rules based on other selections.. Valid values are `INCOMPATIBLE|REQUIRES|EXCLUDES|CONDITIONAL|MANDATORY_IF|OPTIONAL`',
    `cpq_visibility_rule` STRING COMMENT 'Conditional expression determining when an option class or feature is visible to the user in the CPQ configurator interface. Controls dynamic display logic based on prior selections (e.g., show REDUNDANCY_MODULE option only when POWER_RATING >= 75KW).',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this product configuration record was first created in the source system. Used for data lineage, audit trails, and lifecycle tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `display_sequence` STRING COMMENT 'Numeric ordering sequence for presenting option classes and feature codes in CPQ configurator interfaces, sales order entry screens, and product catalogs. Lower numbers appear first in the configuration workflow.. Valid values are `^[0-9]+$`',
    `effective_from_date` DATE COMMENT 'Date from which this configuration model version, option class, or feature code becomes valid and available for use in CPQ, order entry, and manufacturing execution. Supports date-effective configuration management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_to_date` DATE COMMENT 'Date after which this configuration model version, option class, or feature code is no longer valid for new orders or configurations. Supports end-of-life management and product phase-out planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_control_classification` STRING COMMENT 'Export Control Classification Number (ECCN) or Harmonized System (HS) code applicable to this feature selection for export licensing and trade compliance purposes. Critical for dual-use technology and controlled items in international sales.',
    `feature_code` STRING COMMENT 'Selectable feature or characteristic value code within an option class (e.g., 400V, IP65, PROFINET, 75KW). Represents a specific configurable option that can be selected during CPQ or order entry. Maps to SAP S/4HANA characteristic values.. Valid values are `^[A-Z0-9_-]{2,40}$`',
    `feature_description` STRING COMMENT 'Full descriptive text for the selectable feature code, providing technical and commercial context for the option (e.g., 400V Three-Phase Input, IP65 Dust-Tight and Water-Jet Protected Enclosure, PROFINET Industrial Ethernet Interface).',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether this feature selection introduces hazardous materials subject to RoHS, REACH, or transportation hazmat regulations. Triggers additional handling, labeling, and documentation requirements in manufacturing and logistics.. Valid values are `true|false`',
    `is_default_value` BOOLEAN COMMENT 'Indicates whether this feature code is the default pre-selected value for its option class when no explicit customer selection is made. Default values streamline CPQ configuration and reduce order entry errors.. Valid values are `true|false`',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether a selection must be made for this option class before the configuration can be completed and submitted. Mandatory option classes cannot be left unselected in CPQ or order entry processes.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to this product configuration record. Supports incremental data loading in the Databricks Silver Layer and change detection for downstream consumers.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lead_time_days` STRING COMMENT 'Additional manufacturing or procurement lead time in calendar days introduced by selecting this feature code. Used in ATP (Available-to-Promise) and CTP (Capable-to-Promise) calculations during order promising.. Valid values are `^[0-9]+$`',
    `lifecycle_status` STRING COMMENT 'Current lifecycle stage of the configuration model or feature option. DRAFT indicates work-in-progress; ACTIVE is available for use in CPQ and order entry; UNDER_REVIEW is pending change approval; DEPRECATED is being phased out; OBSOLETE is no longer available; SUPERSEDED has been replaced by a newer version.. Valid values are `DRAFT|ACTIVE|UNDER_REVIEW|DEPRECATED|OBSOLETE|SUPERSEDED`',
    `model_name` STRING COMMENT 'Human-readable name of the variant configuration model, describing the configurable product family or platform (e.g., Medium Voltage Drive Series X, Smart Panel ATO Model). Used in CPQ interfaces and sales documentation.',
    `model_version` STRING COMMENT 'Version number of the configuration model, following semantic versioning conventions. Tracks revisions to the configuration model structure, option classes, and constraint rules over time.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)?$`',
    `option_class_code` STRING COMMENT 'Code identifying the option class (characteristic group) within the configuration model, such as VOLTAGE, ENCLOSURE_RATING, COMM_PROTOCOL, MOTOR_SIZE, or COOLING_TYPE. Corresponds to SAP S/4HANA characteristic classes in variant configuration.. Valid values are `^[A-Z0-9_]{2,30}$`',
    `option_class_name` STRING COMMENT 'Descriptive name of the option class, providing a human-readable label for the configurable characteristic group (e.g., Input Voltage Range, Enclosure Protection Rating, Communication Protocol Interface).',
    `pricing_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the pricing impact value (e.g., USD, EUR, GBP, CNY). Supports multi-currency pricing in global CPQ and sales order processes.. Valid values are `^[A-Z]{3}$`',
    `pricing_impact_type` STRING COMMENT 'Defines how the selection of this feature code affects the product price in CPQ pricing calculations. FIXED_ADDER adds a fixed amount; PERCENTAGE_ADDER applies a percentage uplift; MULTIPLIER scales the base price; BASE_PRICE sets the starting price; NO_IMPACT has no pricing effect.. Valid values are `FIXED_ADDER|PERCENTAGE_ADDER|MULTIPLIER|BASE_PRICE|NO_IMPACT`',
    `pricing_impact_value` DECIMAL(18,2) COMMENT 'Numeric value associated with the pricing impact type for this feature selection (e.g., fixed adder amount in base currency, percentage uplift rate, or multiplier factor). Used in CPQ price calculation engines.',
    `product_type` STRING COMMENT 'Manufacturing strategy classification for the configurable product. ETO (Engineer-to-Order) requires custom engineering; ATO (Assemble-to-Order) selects from predefined options; MTO (Make-to-Order) builds to customer specification; MTS (Make-to-Stock) is pre-built; CTO (Configure-to-Order) is a hybrid.. Valid values are `ETO|ATO|MTO|MTS|CTO`',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether selecting this feature code triggers specific regulatory compliance requirements or certifications (e.g., CE Marking, UL listing, RoHS compliance, REACH declaration). When true, compliance documentation must be verified before order fulfillment.. Valid values are `true|false`',
    `sap_vc_class_number` STRING COMMENT 'SAP S/4HANA class number for the variant configuration characteristic class associated with this option class. Provides direct linkage to the SAP VC model for order processing, BOM explosion, and routing selection.. Valid values are `^[A-Z0-9_]{3,40}$`',
    `selection_cardinality` STRING COMMENT 'Defines how many feature values can be selected within an option class. SINGLE allows exactly one selection; MULTI allows multiple simultaneous selections; EXACTLY_ONE enforces a single mandatory choice; AT_LEAST_ONE requires one or more selections.. Valid values are `SINGLE|MULTI|EXACTLY_ONE|AT_LEAST_ONE|AT_MOST_ONE`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this configuration record originated (e.g., SAP_S4HANA for variant configuration models, TEAMCENTER for PLM-driven configurations, CPQ for commercial configurator records). Supports data lineage in the lakehouse.. Valid values are `SAP_S4HANA|TEAMCENTER|OPCENTER|CPQ|SALESFORCE`',
    `teamcenter_config_object_reference` STRING COMMENT 'Reference identifier of the corresponding configuration object in Siemens Teamcenter PLM product configurator. Enables traceability between the commercial CPQ configuration model and the engineering product structure in PLM.. Valid values are `^[A-Z0-9_-]{4,60}$`',
    `weight_impact_kg` DECIMAL(18,2) COMMENT 'Incremental weight in kilograms added to the product by selecting this feature code. Used for logistics planning, shipping cost estimation, and compliance with transportation weight regulations.',
    CONSTRAINT pk_product_configuration PRIMARY KEY(`product_configuration_id`)
) COMMENT 'Defines valid configurable options and variant rules for engineer-to-order (ETO) and assemble-to-order (ATO) products. Captures configuration model ID, option classes (e.g., voltage, enclosure rating, communication protocol), selectable feature codes, constraint rules (incompatible combinations, mandatory selections), and default values. Supports CPQ (Configure-Price-Quote) processes and links to SAP S/4HANA variant configuration (VC) models and Teamcenter product configurator.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`lifecycle` (
    `lifecycle_id` BIGINT COMMENT 'Unique surrogate identifier for each product lifecycle stage record in the catalog. Serves as the primary key for the product_lifecycle data product in the Silver Layer.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: product_lifecycle primarily tracks the commercial lifecycle of catalog items. product_name and product_family are denormalized from catalog_item. Adding catalog_item_id FK enables direct parent-child ',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: product_lifecycle.sku is a STRING field referencing the SKU code. Lifecycle records track the commercial lifecycle of SKUs. Adding sku_id FK normalizes this reference and enables referential integrity',
    `actual_end_of_sale_date` DATE COMMENT 'The actual date on which the catalog item was removed from the active sales catalog and became unavailable for new orders. Used to measure accuracy of planned vs. actual end-of-sale timing.. Valid values are `^d{4}-d{2}-d{2}$`',
    `actual_eol_date` DATE COMMENT 'The actual date on which the catalog item reached End-of-Life status and all support obligations were formally concluded. Used for compliance reporting and aftermarket service closure.. Valid values are `^d{4}-d{2}-d{2}$`',
    `aftermarket_support_end_date` DATE COMMENT 'The date through which aftermarket support, spare parts, and maintenance services are committed to be available for the catalog item after End-of-Sale. Critical for customer SLA commitments and service contract management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approval_date` DATE COMMENT 'The date on which the lifecycle stage transition was formally approved by the designated authority. Provides audit trail for governance and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by` STRING COMMENT 'Name or identifier of the individual or governance body that formally approved the lifecycle stage transition. Required for audit trail and change governance compliance.',
    `ce_marking_status` STRING COMMENT 'Status of the CE Marking certification for the catalog item, indicating conformity with applicable EU health, safety, and environmental protection standards. Lifecycle stage transitions may be gated on CE Marking validity.. Valid values are `MARKED|NOT_MARKED|IN_PROGRESS|EXPIRED|NOT_APPLICABLE`',
    `customer_notification_date` DATE COMMENT 'The date on which customers were formally notified of the lifecycle stage transition (e.g., End-of-Sale or End-of-Life announcement). Required for compliance with contractual SLA obligations and customer communication governance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `customer_notification_status` STRING COMMENT 'Status of the customer notification process for the lifecycle stage transition, particularly for End-of-Sale and End-of-Life events. Tracks whether affected customers have been formally notified per contractual and regulatory obligations.. Valid values are `NOT_REQUIRED|PENDING|IN_PROGRESS|COMPLETED|ACKNOWLEDGED`',
    `erp_material_number` STRING COMMENT 'The material number assigned to the catalog item in SAP S/4HANA. Enables cross-system traceability between the product lifecycle record and procurement, production, and sales transactions in the ERP system.',
    `inventory_wind_down_status` STRING COMMENT 'Status of the inventory wind-down process for the catalog item as it approaches End-of-Sale or End-of-Life. Coordinates with Infor WMS and SAP S/4HANA MM to manage remaining stock disposition.. Valid values are `NOT_STARTED|IN_PROGRESS|COMPLETED|NOT_APPLICABLE`',
    `is_current_stage` BOOLEAN COMMENT 'Flag indicating whether this record represents the currently active lifecycle stage for the catalog item. Supports efficient querying of the current state without date-range filtering.. Valid values are `true|false`',
    `last_time_buy_date` DATE COMMENT 'The final date by which customers may place orders for the catalog item before it is permanently discontinued. Communicated to customers as part of the End-of-Sale notification process to allow final inventory stocking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `market_region` STRING COMMENT 'The geographic market region(s) to which this lifecycle stage record applies (e.g., specific country codes or regional market designations). Supports region-specific lifecycle management where a product may be in different stages across markets.',
    `planned_end_of_sale_date` DATE COMMENT 'The planned date on which the catalog item will no longer be available for new orders (End-of-Sale). Distinct from End-of-Life; aftermarket support may continue after this date. Drives inventory wind-down and last-time-buy notifications.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_eol_date` DATE COMMENT 'The planned date on which the catalog item is expected to reach End-of-Life (EOL) status, meaning no further support, spare parts, or services will be provided. Critical for customer communication, inventory wind-down, and aftermarket commitments.. Valid values are `^d{4}-d{2}-d{2}$`',
    `plm_object_reference` STRING COMMENT 'The unique identifier of the corresponding lifecycle object in Siemens Teamcenter PLM. Enables traceability and cross-system reconciliation between the Silver Layer data product and the authoritative PLM system of record.',
    `previous_stage_code` STRING COMMENT 'The lifecycle stage code that preceded the current stage for this catalog item. Enables stage transition analysis and audit trail of lifecycle progression.. Valid values are `CONCEPT|INTRODUCTION|GROWTH|MATURITY|DECLINE|END_OF_SALE|END_OF_LIFE`',
    `reach_compliance_status` STRING COMMENT 'Compliance status of the catalog item with respect to the EU REACH Regulation. Impacts lifecycle stage decisions for products containing substances of very high concern (SVHC) and drives EOL timing in regulated markets.. Valid values are `COMPLIANT|NON_COMPLIANT|EXEMPT|UNDER_REVIEW|NOT_APPLICABLE`',
    `record_created_timestamp` TIMESTAMP COMMENT 'The timestamp when this lifecycle stage record was first created in the Silver Layer data product. Supports data lineage, audit trail, and incremental processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this lifecycle stage record was last updated in the Silver Layer data product. Used for change detection, incremental loads, and audit trail maintenance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `regulatory_hold_flag` BOOLEAN COMMENT 'Indicates whether the lifecycle stage transition is on hold due to a pending regulatory review, certification requirement, or compliance obligation (e.g., CE Marking, RoHS, REACH). Prevents premature stage advancement.. Valid values are `true|false`',
    `regulatory_hold_reason` STRING COMMENT 'Description of the regulatory or compliance reason for placing the lifecycle stage transition on hold. Provides audit trail for regulatory governance and compliance reporting.',
    `responsible_business_unit` STRING COMMENT 'The organizational business unit or division accountable for the products lifecycle management (e.g., Factory Automation, Electrification Products, Smart Infrastructure). Supports portfolio governance and reporting by business unit.',
    `responsible_product_manager` STRING COMMENT 'Name or employee identifier of the product manager accountable for managing the lifecycle stage of this catalog item. Used for escalation, communication ownership, and governance accountability.',
    `rohs_compliance_status` STRING COMMENT 'Compliance status of the catalog item with respect to the EU RoHS Directive (Restriction of Hazardous Substances). Relevant for lifecycle decisions, particularly when transitioning products to End-of-Sale or End-of-Life in EU markets.. Valid values are `COMPLIANT|NON_COMPLIANT|EXEMPT|UNDER_REVIEW|NOT_APPLICABLE`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this lifecycle stage record originated (e.g., Siemens Teamcenter PLM, SAP S/4HANA). Supports data lineage and cross-system reconciliation in the Databricks Lakehouse Silver Layer.. Valid values are `TEAMCENTER_PLM|SAP_S4HANA|MANUAL|OTHER`',
    `spare_parts_availability_commitment` STRING COMMENT 'The level of spare parts availability committed to customers after the product reaches End-of-Sale. Drives aftermarket inventory planning, MRO procurement, and customer SLA management.. Valid values are `FULL|LIMITED|CRITICAL_ONLY|NONE`',
    `stage_code` STRING COMMENT 'Standardized code representing the current commercial lifecycle stage of the catalog item. Drives proactive customer communication, inventory wind-down, and aftermarket parts availability commitments. Aligned with PLM lifecycle stages in Siemens Teamcenter.. Valid values are `CONCEPT|INTRODUCTION|GROWTH|MATURITY|DECLINE|END_OF_SALE|END_OF_LIFE`',
    `stage_effective_end_date` DATE COMMENT 'The date on which the current lifecycle stage ceased to be effective, either because the product transitioned to the next stage or the record was superseded. NULL indicates the stage is currently active.. Valid values are `^d{4}-d{2}-d{2}$`',
    `stage_effective_start_date` DATE COMMENT 'The date on which the current lifecycle stage became effective for the catalog item. Used to determine how long a product has been in a given stage and to support time-based lifecycle analytics.. Valid values are `^d{4}-d{2}-d{2}$`',
    `stage_name` STRING COMMENT 'Human-readable label for the lifecycle stage corresponding to the lifecycle_stage_code. Used in customer-facing communications, dashboards, and reports.. Valid values are `Concept|Introduction|Growth|Maturity|Decline|End of Sale|End of Life`',
    `successor_sku` STRING COMMENT 'The SKU of the replacement or successor product recommended when this catalog item reaches End-of-Sale or End-of-Life. Enables automated customer migration recommendations and sales substitution logic.. Valid values are `^[A-Z0-9-]{3,50}$`',
    `transition_reason_code` STRING COMMENT 'Standardized code indicating the business reason for the lifecycle stage transition. Supports root-cause analysis of portfolio changes and regulatory reporting.. Valid values are `MARKET_DEMAND|TECHNOLOGY_OBSOLESCENCE|REGULATORY_COMPLIANCE|PORTFOLIO_RATIONALIZATION|SUCCESSOR_PRODUCT|SUPPLY_CHAIN|STRATEGIC_DECISION|CUSTOMER_REQUEST|OTHER`',
    `transition_reason_notes` STRING COMMENT 'Free-text narrative providing additional context for the lifecycle stage transition beyond the standardized reason code. Captures nuanced business justification for audit and governance purposes.',
    `ul_certification_status` STRING COMMENT 'Status of the UL (Underwriters Laboratories) product safety certification for the catalog item. Relevant for lifecycle decisions in North American markets and required for certain industrial automation and electrification products.. Valid values are `CERTIFIED|NOT_CERTIFIED|IN_PROGRESS|EXPIRED|NOT_APPLICABLE`',
    CONSTRAINT pk_lifecycle PRIMARY KEY(`lifecycle_id`)
) COMMENT 'Tracks the commercial lifecycle stage of each catalog item over time — from concept and introduction through growth, maturity, decline, end-of-sale, and end-of-life (EOL). Records the lifecycle stage code, effective start and end dates, reason for stage transition, responsible product manager, and planned EOL date. Enables proactive customer communication, inventory wind-down planning, and aftermarket parts availability commitments. Aligned with PLM lifecycle management in Siemens Teamcenter.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`product_price_list` (
    `product_price_list_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for each price list record in the commercial pricing catalog. Serves as the primary key for all downstream references.',
    `approval_status` STRING COMMENT 'Workflow approval status of the price list. Pending Approval indicates the price list is awaiting authorization; Approved means it has been authorized for use; Rejected means it was not approved; Withdrawn means it was recalled before approval.. Valid values are `pending_approval|approved|rejected|withdrawn`',
    `approved_by` STRING COMMENT 'Name or user ID of the authorized individual (e.g., Pricing Manager, VP of Sales) who approved this price list for commercial use. Supports audit trail and governance requirements.',
    `approved_date` DATE COMMENT 'The calendar date on which the price list was formally approved by the authorized approver. Used for audit trail, compliance reporting, and pricing governance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `base_price_list_code` STRING COMMENT 'Reference to the parent or base price list from which this price list is derived. Used when a price list is created as a percentage discount or markup from a standard list price, supporting tiered pricing hierarchies.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `category` STRING COMMENT 'Business category of products covered by this price list, aligned with the commercial product catalog domains: finished goods, spare parts, automation systems, electrification solutions, smart infrastructure components, services, or accessories.. Valid values are `finished_goods|spare_parts|automation_systems|electrification_solutions|smart_infrastructure|services|accessories`',
    `code` STRING COMMENT 'Business-facing alphanumeric code uniquely identifying the price list, aligned with the SAP S/4HANA SD pricing condition record key. Used in order processing, quotations, and ERP integration.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `condition_type_code` STRING COMMENT 'SAP S/4HANA SD condition type code (e.g., PR00 for base price, MWST for tax) associated with this price list. Defines the pricing element category within the SD pricing framework.. Valid values are `^[A-Z0-9]{2,10}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the primary country or market for which this price list is applicable. Supports regional pricing strategies in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this price list record was first created in the system. Provides an audit trail for pricing governance and data lineage in the lakehouse Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which all prices within this price list are denominated (e.g., USD, EUR, GBP, JPY). Supports multi-currency pricing strategies for global operations.. Valid values are `^[A-Z]{3}$`',
    `customer_group_code` STRING COMMENT 'SAP S/4HANA SD customer group code identifying the category of customers eligible for this price list (e.g., end customers, distributors, OEM partners, intercompany entities). Drives pricing condition determination.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `description` STRING COMMENT 'Extended free-text description of the price list, including its intended use, applicable customer segments, and any special conditions or notes for sales operations.',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Percentage discount applied relative to the base price list when this price list is derived from a parent list. A positive value represents a discount; a negative value represents a surcharge. Null if not applicable.. Valid values are `^-?d{1,3}.d{1,4}$`',
    `distribution_channel_code` STRING COMMENT 'SAP S/4HANA SD distribution channel code indicating the route through which products are sold under this price list (e.g., direct sales, wholesale, e-commerce, OEM, intercompany).. Valid values are `^[A-Z0-9]{2,10}$`',
    `division_code` STRING COMMENT 'SAP S/4HANA SD division code representing the product line or business unit (e.g., Automation Systems, Electrification Solutions, Smart Infrastructure) to which this price list applies.. Valid values are `^[A-Z0-9]{2,10}$`',
    `effective_date` DATE COMMENT 'The calendar date from which this price list becomes valid and applicable for pricing sales orders, quotations, and contracts. Aligns with SAP S/4HANA SD condition record validity start date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'The calendar date on which this price list ceases to be valid. After this date, the price list can no longer be applied to new sales transactions. A null value indicates an open-ended validity period.. Valid values are `^d{4}-d{2}-d{2}$`',
    `external_reference_code` STRING COMMENT 'External reference identifier for this price list as used by customers, distributors, or trading partners in their own systems. Facilitates B2B pricing alignment and EDI/API integration with partner systems.',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms) code applicable to this price list, defining the delivery obligations, risk transfer, and cost responsibilities between seller and buyer (e.g., EXW, FOB, CIF, DDP).. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `is_default` BOOLEAN COMMENT 'Indicates whether this price list is the default pricing structure applied when no other specific price list is determined for a sales transaction within the applicable sales area and customer group.. Valid values are `true|false`',
    `is_locked` BOOLEAN COMMENT 'Indicates whether the price list is locked against further modifications. A locked price list cannot be edited until explicitly unlocked by an authorized user, ensuring pricing integrity during active sales periods.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this price list record was most recently updated. Used for change tracking, incremental data loading, and audit compliance in the lakehouse Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `minimum_order_value` DECIMAL(18,2) COMMENT 'Minimum total order value (in the price list currency) required for this price list to be applicable to a sales transaction. Orders below this threshold may not qualify for the pricing terms defined in this list.. Valid values are `^d+(.d{1,4})?$`',
    `name` STRING COMMENT 'Descriptive commercial name of the price list (e.g., North America Standard List Price 2025, EMEA Distributor Price Q1 2025). Used in sales documents, customer communications, and reporting.',
    `notes` STRING COMMENT 'Free-text field for additional operational notes, special instructions, or contextual information about the price list that does not fit into structured fields. Used by pricing analysts and sales operations teams.',
    `payment_terms_code` STRING COMMENT 'SAP S/4HANA payment terms code associated with this price list, defining the standard payment conditions (e.g., net 30, 2/10 net 30) applicable to sales transactions using this pricing structure.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `pricing_procedure_code` STRING COMMENT 'SAP S/4HANA SD pricing procedure identifier that governs how condition types (discounts, surcharges, taxes, freight) are determined and calculated for sales documents using this price list.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `region_code` STRING COMMENT 'Internal regional classification code (e.g., AMER, EMEA, APAC) used to group price lists by geographic sales region for reporting and analytics purposes.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `sales_organization_code` STRING COMMENT 'SAP S/4HANA SD sales organization code to which this price list is assigned. Defines the organizational unit responsible for the sale of products and services under this pricing structure.. Valid values are `^[A-Z0-9]{2,10}$`',
    `source_system_code` STRING COMMENT 'Identifier of the operational system of record from which this price list record originates (e.g., SAP_S4HANA, SALESFORCE_CRM). Supports data lineage tracking and multi-system integration in the lakehouse.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `source_system_price_list_code` STRING COMMENT 'The native identifier of this price list record in the originating operational system (e.g., SAP S/4HANA condition record number or Salesforce price book ID). Enables traceability and reconciliation between the lakehouse and source systems.',
    `status` STRING COMMENT 'Current lifecycle status of the price list. Draft indicates the price list is being prepared; Active means it is currently in use for pricing; Inactive means it has been deactivated; Expired means the validity period has passed; Superseded means it has been replaced by a newer version; Under Review means it is pending approval.. Valid values are `draft|active|inactive|expired|superseded|under_review`',
    `tax_classification_code` STRING COMMENT 'Tax classification code associated with this price list, indicating whether prices are inclusive or exclusive of taxes (e.g., VAT, GST, sales tax). Drives tax determination in SAP S/4HANA SD sales documents.. Valid values are `^[A-Z0-9_-]{1,10}$`',
    `type` STRING COMMENT 'Classification of the price list by commercial purpose. Standard List Price is the published catalog price; Distributor Price applies to channel partners; OEM Price is for original equipment manufacturer agreements; Intercompany Transfer Price governs intra-company transactions; Promotional Price supports time-limited campaigns; Contract Price is negotiated for specific customer agreements.. Valid values are `standard_list_price|distributor_price|oem_price|intercompany_transfer_price|promotional_price|contract_price`',
    `version_number` STRING COMMENT 'Sequential version number of the price list, incremented each time the price list is revised or updated. Enables version tracking and historical comparison of pricing structures over time.. Valid values are `^[1-9][0-9]*$`',
    CONSTRAINT pk_product_price_list PRIMARY KEY(`product_price_list_id`)
) COMMENT 'Master price list entity defining the commercial pricing structure for catalog items. Captures price list name, currency, validity period (effective and expiry dates), price list type (standard list price, distributor price, OEM price, intercompany transfer price), applicable sales organization, and distribution channel. Each price list is the parent container for individual price list items. Supports multi-currency and multi-channel pricing strategies aligned with SAP S/4HANA SD pricing.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`price_list_item` (
    `price_list_item_id` BIGINT COMMENT 'Unique surrogate identifier for each individual line-level pricing record within a price list. Serves as the primary key for the price_list_item entity in the Silver Layer lakehouse.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: price_list_item can associate pricing at the catalog_item level (not just SKU level). product_name is a denormalized STRING from catalog_item. Adding catalog_item_id FK (nullable, since pricing may be',
    `hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.product_hierarchy. Business justification: price_list_item.product_hierarchy_code is a STRING reference to the product hierarchy node for hierarchy-level pricing. Adding product_hierarchy_id FK normalizes this reference and enables hierarchy-b',
    `product_price_list_id` BIGINT COMMENT 'Foreign key linking to product.price_list. Business justification: price_list_item is a line-level record within a price list. price_list_item.price_list_code is a STRING reference to the parent price_list. Adding price_list_id FK normalizes this parent-child relatio',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: price_list_item associates pricing with a specific SKU. sku_code is a STRING reference to sku.code. Adding sku_id FK normalizes this reference and enables referential integrity. sku_code is removed as',
    `tax_code_id` BIGINT COMMENT 'Foreign key linking to finance.tax_code. Business justification: Price list items require tax codes for correct sales tax calculation and compliance. Sales and finance teams use this for pricing, invoicing, and tax reporting.',
    `approved_by` STRING COMMENT 'Name or user ID of the pricing authority (e.g., pricing manager, commercial director) who approved this price list item. Supports pricing governance, delegation of authority compliance, and audit trail requirements.',
    `approved_timestamp` TIMESTAMP COMMENT 'The date and time when this price list item was formally approved by the designated pricing authority. Used for pricing governance reporting and compliance with internal delegation of authority policies.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `calculation_type` STRING COMMENT 'Defines how the price or condition value is calculated: fixed_amount (absolute monetary value), percentage (proportion of a base amount), quantity_dependent (varies by ordered quantity), formula (custom calculation rule), or free_goods (zero-price promotional item).. Valid values are `fixed_amount|percentage|quantity_dependent|formula|free_goods`',
    `condition_type_code` STRING COMMENT 'SAP SD pricing condition type code that classifies the nature of the pricing record (e.g., PR00 for base price, RA01 for discount, ZSU1 for surcharge). Governs how the price is applied during order pricing.. Valid values are `^[A-Z0-9]{2,4}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country for which this price list item is applicable. Supports country-specific pricing to reflect local market conditions, taxes, and regulatory requirements.. Valid values are `^[A-Z]{3}$`',
    `cpq_eligible` BOOLEAN COMMENT 'Indicates whether this price list item is available for use in Configure Price Quote (CPQ) processes (True) or restricted to direct order entry only (False). Controls which items appear in the CPQ pricing engine for complex product configurations.. Valid values are `true|false`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this price list item record was first created in the source system. Used for audit trail, data lineage, and pricing governance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the unit price, floor price, RRP, and surcharge amounts are expressed (e.g., USD, EUR, GBP, CNY). Supports multi-currency pricing for global operations.. Valid values are `^[A-Z]{3}$`',
    `customer_group_code` STRING COMMENT 'Code identifying the customer group or customer classification for which this price list item is applicable (e.g., key accounts, standard customers, government, OEM partners). Enables segment-specific pricing.. Valid values are `^[A-Z0-9]{1,10}$`',
    `distribution_channel_code` STRING COMMENT 'Code identifying the distribution channel for which this price applies (e.g., direct sales, distributor, OEM, e-commerce). Enables channel-specific pricing strategies within the same sales organization.. Valid values are `^[A-Z0-9]{1,4}$`',
    `effective_date` DATE COMMENT 'The date from which this price list item becomes valid and applicable for order pricing. Prices with an effective date in the future are staged but not yet active. Aligns with SAP SD condition validity start date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'The date after which this price list item is no longer valid for order pricing. Expired items are retained for historical reporting and audit purposes. Aligns with SAP SD condition validity end date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `floor_price` DECIMAL(18,2) COMMENT 'The minimum permissible selling price for the SKU below which sales representatives cannot discount. Used by Configure Price Quote (CPQ) and order management to enforce pricing guardrails and protect margin.. Valid values are `^[0-9]+(.[0-9]{1,6})?$`',
    `intercompany_flag` BOOLEAN COMMENT 'Indicates whether this price list item represents an intercompany transfer price applicable to transactions between legal entities within the same corporate group (True) or an external customer price (False). Relevant for transfer pricing compliance.. Valid values are `true|false`',
    `item_number` STRING COMMENT 'Business-facing alphanumeric identifier for the price list item as assigned in the source system (SAP SD condition record key). Used for cross-system referencing and audit traceability.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this price list item record was most recently updated in the source system. Supports change detection in ETL pipelines and pricing audit trails.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `min_order_quantity` DECIMAL(18,2) COMMENT 'The minimum quantity a customer must order to qualify for this price list item. Enforced during order entry and CPQ to ensure pricing is only applied when the minimum purchase threshold is met.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `price_includes_tax` BOOLEAN COMMENT 'Indicates whether the unit price stated in this price list item is inclusive of applicable taxes (True) or exclusive of taxes (False). Critical for markets where gross pricing is standard (e.g., VAT-inclusive pricing in EU consumer channels).. Valid values are `true|false`',
    `price_type` STRING COMMENT 'Classification of the price record indicating its commercial role: list_price (standard catalog price), floor_price (minimum allowable selling price), rrp (Recommended Retail Price), transfer_price (intercompany), contract_price (customer-specific negotiated), or promotional_price (time-limited offer).. Valid values are `list_price|floor_price|rrp|transfer_price|contract_price|promotional_price`',
    `pricing_procedure_code` STRING COMMENT 'Code identifying the SAP SD pricing procedure under which this condition record is evaluated during order pricing (e.g., RVAA01 for standard sales). Determines the sequence and calculation logic for all pricing conditions.. Valid values are `^[A-Z0-9]{1,10}$`',
    `pricing_unit_quantity` DECIMAL(18,2) COMMENT 'The quantity denominator for the unit price (e.g., price per 100 units, price per 1000 kg). Allows pricing to be expressed per batch or bulk quantity rather than per single unit. Defaults to 1 for per-unit pricing.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `pricing_uom` STRING COMMENT 'The unit of measure against which the unit price is defined (e.g., EA for each, KG for kilogram, M for meter, SET for set, PCE for piece). Determines the quantity basis for price calculation in order management.. Valid values are `^[A-Z0-9]{1,6}$`',
    `rebate_eligible` BOOLEAN COMMENT 'Indicates whether this price list item is eligible for inclusion in rebate agreement calculations (True) or excluded (False). Used by the rebate management process to determine which sales transactions qualify for retrospective rebate accruals.. Valid values are `true|false`',
    `rrp` DECIMAL(18,2) COMMENT 'The Recommended Retail Price (RRP) suggested to channel partners and distributors for resale to end customers. Used in distributor price lists and channel management to maintain market price consistency.. Valid values are `^[0-9]+(.[0-9]{1,6})?$`',
    `sales_org_code` STRING COMMENT 'Code identifying the sales organization for which this price list item is applicable. Supports multi-entity and multi-region pricing structures in global operations (e.g., different prices for EMEA vs. Americas sales organizations).. Valid values are `^[A-Z0-9]{1,10}$`',
    `scale_basis` STRING COMMENT 'The dimension on which pricing scale breaks are evaluated: quantity (number of units), value (order value in currency), weight (total weight), or volume (total volume). Determines how tier thresholds are measured for volume pricing.. Valid values are `quantity|value|weight|volume`',
    `scale_from_quantity` DECIMAL(18,2) COMMENT 'The lower bound quantity threshold for this pricing tier (e.g., 10 units). When the ordered quantity meets or exceeds this value, the corresponding tier price applies. Used to define volume-based pricing breaks.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `scale_to_quantity` DECIMAL(18,2) COMMENT 'The upper bound quantity threshold for this pricing tier (e.g., 99 units). Defines the ceiling of the quantity band for this tier. Null or 999999999 indicates the tier applies to all quantities above the from-quantity.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `scale_type` STRING COMMENT 'Defines the type of volume-based pricing scale applied to this item: graduated (tiered pricing where each tier applies to the quantity within that band), base_scale (the entire quantity is priced at the tier rate), group_scale (scale based on cumulative group quantity), or none (flat pricing with no scale).. Valid values are `graduated|base_scale|group_scale|none`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this price list item was sourced (e.g., SAP_S4HANA for SD condition records, SALESFORCE_CPQ for CPQ-originated prices). Supports data lineage and reconciliation in the lakehouse.. Valid values are `SAP_S4HANA|SALESFORCE_CPQ|MANUAL|ARIBA|LEGACY`',
    `source_system_key` STRING COMMENT 'The natural key or composite key of this price list item as it exists in the source system (e.g., SAP condition record number + condition table key). Enables traceability back to the originating system record for reconciliation and audit.',
    `status` STRING COMMENT 'Current lifecycle status of the price list item: active (in use for order pricing), inactive (disabled), pending_approval (awaiting authorization), superseded (replaced by a newer version), expired (past validity end date), or draft (under preparation).. Valid values are `active|inactive|pending_approval|superseded|expired|draft`',
    `surcharge_amount` DECIMAL(18,2) COMMENT 'Absolute monetary surcharge applied on top of the unit price for this item (e.g., hazardous material handling surcharge, small order surcharge, freight surcharge). Negative values represent absolute discounts.. Valid values are `^-?[0-9]+(.[0-9]{1,6})?$`',
    `surcharge_percent` DECIMAL(18,2) COMMENT 'Percentage-based surcharge or discount applied to the unit price for this item. Positive values indicate a surcharge; negative values indicate a discount percentage. Used when the adjustment is proportional rather than fixed.. Valid values are `^-?[0-9]{1,3}(.[0-9]{1,4})?$`',
    `tax_classification_code` STRING COMMENT 'Code indicating the tax classification applicable to this price list item (e.g., full tax, reduced tax, tax-exempt). Used in conjunction with customer tax classification to determine the applicable tax rate during order processing.. Valid values are `^[A-Z0-9]{1,4}$`',
    `unit_price` DECIMAL(18,2) COMMENT 'The base price per pricing unit of measure for the SKU as defined in this price list item. Represents the list price before any discounts or surcharges are applied. Stored with 6 decimal places to support high-precision industrial pricing.. Valid values are `^[0-9]+(.[0-9]{1,6})?$`',
    `version_number` STRING COMMENT 'Sequential version number of this price list item record, incremented each time the item is revised or superseded. Supports price history tracking, audit trails, and rollback capabilities for pricing governance.. Valid values are `^[0-9]+$`',
    CONSTRAINT pk_price_list_item PRIMARY KEY(`price_list_item_id`)
) COMMENT 'Individual line-level pricing record within a price list, associating a specific SKU or catalog item to a unit price, pricing unit of measure, minimum quantity, and scale/tiered pricing breaks. Captures list price, floor price, recommended retail price (RRP), and any surcharge or discount conditions. Supports volume-based pricing tiers (e.g., 1-9 units at $X, 10-99 units at $Y). The authoritative source for base product pricing consumed by order management and CPQ.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`discount_schedule` (
    `discount_schedule_id` BIGINT COMMENT 'Unique system-generated identifier for a discount schedule record within the product catalog pricing framework.',
    `product_price_list_id` BIGINT COMMENT 'Foreign key linking to product.price_list. Business justification: discount_schedule defines structured discount programs that operate within a pricing context. Discount schedules are applied in conjunction with price lists (e.g., a customer-specific discount schedul',
    `approval_level` STRING COMMENT 'The authorization tier required to approve this discount schedule based on the discount magnitude and business impact, per the delegation of authority matrix.. Valid values are `level_1|level_2|level_3|executive`',
    `approval_status` STRING COMMENT 'Authorization workflow status for the discount schedule: not_required (below approval threshold), pending (awaiting review), approved (authorized), rejected (denied), or escalated (referred to higher authority).. Valid values are `not_required|pending|approved|rejected|escalated`',
    `approved_by` STRING COMMENT 'Name or user ID of the pricing authority (e.g., Sales Director, Pricing Manager) who authorized this discount schedule per the delegation of authority policy.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the discount schedule was formally approved by the authorized pricing authority.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `combinability_rule` STRING COMMENT 'Defines how this discount schedule interacts with other concurrent discounts: exclusive (cannot be combined), additive (stacked with others), best_price (highest discount wins), or multiplicative (compounded).. Valid values are `exclusive|additive|best_price|multiplicative`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code specifying the geographic market to which this discount schedule applies. Supports multinational pricing governance.. Valid values are `^[A-Z]{3}$`',
    `cpq_rule_code` STRING COMMENT 'Reference identifier of the corresponding discount rule in Salesforce CPQ (Configure Price Quote) that is synchronized with this discount schedule for quote generation.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the discount schedule record was initially created in the system, used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code applicable to absolute monetary discount amounts (e.g., USD, EUR, GBP). Null for percentage-type discounts.. Valid values are `^[A-Z]{3}$`',
    `customer_scope_type` STRING COMMENT 'Defines the customer segmentation dimension to which this discount applies: customer class, customer group, sales area, distribution channel, or all customers.. Valid values are `customer_class|customer_group|sales_area|channel|all_customers`',
    `customer_scope_value` STRING COMMENT 'The specific identifier value corresponding to the customer_scope_type — e.g., the customer class code, customer group code, or channel code to which this discount applies.',
    `description` STRING COMMENT 'Detailed narrative describing the purpose, scope, and business rationale of the discount schedule, including any special terms or conditions.',
    `discount_category` STRING COMMENT 'Business category classifying the discount program: customer-class discount, volume rebate, promotional campaign, channel partner tier, trade-in allowance, contract-based, seasonal, or clearance.. Valid values are `customer_class|volume|promotional|channel_partner|trade_in|contract|seasonal|clearance`',
    `discount_rate` DECIMAL(18,2) COMMENT 'The discount rate value expressed as a percentage (e.g., 5.0000 = 5%) for percentage-type discounts, or as an absolute monetary amount for absolute-type discounts. Interpretation depends on discount_type.',
    `discount_rate_unit` STRING COMMENT 'Unit of measure for the discount rate: percentage of net price, currency amount per unit of measure, or currency amount per order. Aligns with SAP pricing condition unit.. Valid values are `percent|currency_per_unit|currency_per_order`',
    `discount_type` STRING COMMENT 'Classification of the discount mechanism: percentage-based reduction, absolute monetary deduction, volume rebate, free goods, promotional, or surcharge. Drives pricing condition calculation logic in SAP S/4HANA.. Valid values are `percentage|absolute_amount|rebate|free_goods|promotional|surcharge`',
    `distribution_channel` STRING COMMENT 'SAP S/4HANA distribution channel code (e.g., direct sales, wholesale, e-commerce, OEM) scoping the applicability of this discount schedule.. Valid values are `^[A-Z0-9]{1,2}$`',
    `effective_date` DATE COMMENT 'The calendar date from which this discount schedule becomes active and eligible for application in pricing determination. Inclusive start of the validity period.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'The calendar date on which this discount schedule expires and is no longer applicable in pricing determination. Inclusive end of the validity period.. Valid values are `^d{4}-d{2}-d{2}$`',
    `is_stackable` BOOLEAN COMMENT 'Indicates whether this discount schedule can be stacked (combined) with other active discount schedules on the same order line. True = stackable; False = exclusive.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the discount schedule record, supporting change tracking, audit compliance, and Silver layer incremental processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `max_discount_ceiling` DECIMAL(18,2) COMMENT 'The upper limit cap on the discount that can be applied under this schedule, expressed in the same unit as discount_rate. Prevents excessive discounting beyond authorized thresholds.',
    `min_discount_floor` DECIMAL(18,2) COMMENT 'The minimum discount threshold that must be met before this schedule activates, expressed in the same unit as discount_rate. Used for tiered or threshold-based discount programs.',
    `name` STRING COMMENT 'Descriptive business name of the discount schedule (e.g., Q1 2025 OEM Volume Rebate, Channel Partner Tier 2 Discount), used for display in pricing tools and reporting.',
    `pricing_condition_type` STRING COMMENT 'SAP S/4HANA pricing condition type code (e.g., K007, K020, BO01) that maps this discount schedule to the corresponding condition record in the pricing procedure.. Valid values are `^[A-Z0-9]{2,4}$`',
    `priority_rank` STRING COMMENT 'Numeric priority rank determining the order of application when multiple discount schedules are eligible for the same transaction. Lower number indicates higher priority.. Valid values are `^[1-9][0-9]*$`',
    `product_scope_type` STRING COMMENT 'Defines the level at which the discount applies within the product catalog: individual SKU (Stock Keeping Unit), product group, product hierarchy node, or all products.. Valid values are `sku|product_group|hierarchy_node|all_products`',
    `product_scope_value` STRING COMMENT 'The specific identifier value corresponding to the product_scope_type — e.g., the SKU code, product group code, or hierarchy node code to which this discount schedule applies.',
    `rebate_basis` STRING COMMENT 'The calculation basis for rebate-type discounts: net sales value, gross sales value, or quantity sold. Determines how the rebate accrual and settlement are computed in SAP S/4HANA rebate processing.. Valid values are `net_sales|gross_sales|quantity|none`',
    `rebate_settlement_frequency` STRING COMMENT 'Frequency at which rebate accruals are settled and credit memos are issued to the customer: monthly, quarterly, semi-annual, annual, or on-demand.. Valid values are `monthly|quarterly|semi_annual|annual|on_demand`',
    `region_code` STRING COMMENT 'Internal regional classification code (e.g., EMEA, APAC, AMER) further scoping the geographic applicability of the discount schedule within the multinational sales structure.',
    `requires_manual_override` BOOLEAN COMMENT 'Indicates whether application of this discount schedule requires explicit manual authorization by a sales representative or pricing manager at the time of order entry, rather than automatic determination.. Valid values are `true|false`',
    `sales_organization` STRING COMMENT 'SAP S/4HANA sales organization code to which this discount schedule is assigned, defining the legal entity and geographic scope for pricing determination.. Valid values are `^[A-Z0-9]{1,4}$`',
    `schedule_code` STRING COMMENT 'Business-facing alphanumeric code uniquely identifying the discount schedule, used in SAP S/4HANA pricing condition determination and Salesforce CPQ discount rule references.. Valid values are `^[A-Z0-9_-]{3,30}$`',
    `source_system` STRING COMMENT 'Identifies the originating operational system of record for this discount schedule record: SAP S/4HANA SD pricing conditions, Salesforce CPQ discount schedules, or manually entered.. Valid values are `SAP_S4HANA|SALESFORCE_CPQ|MANUAL`',
    `source_system_key` STRING COMMENT 'The natural key or record identifier from the originating source system (e.g., SAP condition record number KNUMH, Salesforce Discount Schedule ID) enabling traceability and reconciliation.',
    `status` STRING COMMENT 'Current lifecycle status of the discount schedule: draft (being authored), pending_approval (submitted for authorization), active (in use), suspended (temporarily halted), expired (past validity), cancelled (voided), or archived (historical record).. Valid values are `draft|pending_approval|active|suspended|expired|cancelled|archived`',
    `volume_threshold_amount` DECIMAL(18,2) COMMENT 'Minimum order or cumulative purchase value (in currency_code) required to qualify for this discount schedule. Used for value-based volume rebate programs.',
    `volume_threshold_qty` DECIMAL(18,2) COMMENT 'Minimum order or purchase quantity required to qualify for this discount schedule. Applicable for volume-based and rebate discount types. Expressed in the base unit of measure of the product.',
    CONSTRAINT pk_discount_schedule PRIMARY KEY(`discount_schedule_id`)
) COMMENT 'Defines structured discount programs applicable to catalog items or product groups — including customer-class discounts, volume rebate schedules, promotional discounts, and channel partner discount tiers. Captures discount type (percentage, absolute, rebate), applicable product scope (item, group, hierarchy node), customer segment scope, validity period, approval status, and maximum discount ceiling. Feeds into SAP S/4HANA pricing condition determination and Salesforce CPQ discount rules.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`category` (
    `category_id` BIGINT COMMENT 'Unique surrogate key identifying a product category record in the commercial product catalog taxonomy. Used as the primary key for all category-level joins and references across the Silver layer.',
    `class_id` BIGINT COMMENT 'The classification identifier from Siemens Teamcenter PLM corresponding to this product category, enabling traceability between the commercial catalog taxonomy and the engineering classification structure.',
    `warranty_policy_id` BIGINT COMMENT 'Foreign key linking to product.warranty_policy. Business justification: product_category.warranty_policy_code is a STRING reference to the default warranty policy applicable to products in this category. Adding warranty_policy_id FK normalizes this relationship and enable',
    `applicable_region` STRING COMMENT 'Pipe-separated list of ISO 3166-1 alpha-3 country codes or regional designators indicating the geographic markets where this category is commercially active and available for ordering (e.g., USA|DEU|CHN|GBR).',
    `business_division` STRING COMMENT 'The internal business division or strategic business unit responsible for the products within this category (e.g., Digital Industries, Smart Infrastructure, Mobility). Supports divisional P&L reporting and spend analytics.',
    `code` STRING COMMENT 'Unique alphanumeric business code assigned to the product category, used for catalog navigation, ERP integration, and cross-system referencing. Corresponds to the SAP MM product category key.. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this product category record was first created in the system, recorded in ISO 8601 format with timezone offset. Used for audit trail, data lineage, and change management tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `default_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code representing the default pricing currency for products in this category (e.g., USD, EUR, CNY). Used for catalog pricing display and financial reporting alignment.. Valid values are `^[A-Z]{3}$`',
    `default_uom` STRING COMMENT 'The default unit of measure for products in this category (e.g., EA for each, KG for kilogram, M for meter), aligned with SAP S/4HANA base unit of measure. Used for procurement, inventory, and order management.',
    `description` STRING COMMENT 'Detailed narrative description of the product category, including the types of products it encompasses, intended use cases, and distinguishing characteristics for catalog navigation and spend analytics.',
    `effective_date` DATE COMMENT 'The date from which this product category becomes valid and active for use in catalog navigation, ordering, and procurement. Supports time-bounded category management and scheduled activations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'The date after which this product category is no longer valid for new transactions. Used to manage category lifecycle, sunset discontinued groupings, and enforce time-bounded catalog structures.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_control_flag` BOOLEAN COMMENT 'Indicates whether products in this category are subject to export control regulations (e.g., EAR, ITAR, EU Dual-Use Regulation), requiring export licenses or restricted country screening before order fulfillment.. Valid values are `true|false`',
    `external_category_code` STRING COMMENT 'Category code used by external trading partners, distributors, or industry bodies for cross-reference and EDI/B2B integration. Enables mapping between internal taxonomy and partner-specific classification schemes.',
    `gpc_code` STRING COMMENT 'GS1 Global Product Classification (GPC) brick code assigned to this category for global trade and supply chain interoperability, enabling standardized product data exchange with trading partners and distributors.. Valid values are `^[0-9]{8}$`',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether products in this category may contain or constitute hazardous materials subject to REACH, RoHS, or OSHA regulations. Triggers additional compliance checks during procurement, manufacturing, and shipping.. Valid values are `true|false`',
    `hierarchy_level` STRING COMMENT 'Numeric depth of this category within the product classification hierarchy. Level 1 represents the top-most division (e.g., Automation Systems), with each subsequent level representing a more granular sub-classification.. Valid values are `^[1-9][0-9]*$`',
    `hierarchy_path` STRING COMMENT 'Full materialized path string representing the categorys position in the hierarchy from root to current node (e.g., Industrial Automation > Drive Technology > AC Drives), used for breadcrumb navigation and hierarchical reporting.',
    `image_url` STRING COMMENT 'URL pointing to the representative image or icon for this product category, used in digital catalog portals, e-commerce interfaces, and customer-facing product navigation.. Valid values are `^https?://.+$`',
    `industry_segment` STRING COMMENT 'The primary industry vertical or market segment this product category is applicable to, used for targeted catalog presentation, sales analytics, and go-to-market alignment (e.g., factory_automation, building_technologies, transportation).. Valid values are `factory_automation|building_technologies|transportation|energy_utilities|process_industries|discrete_manufacturing|smart_infrastructure|cross_industry`',
    `is_leaf_node` BOOLEAN COMMENT 'Indicates whether this category is a terminal (leaf) node in the hierarchy with no child categories. Leaf nodes are the lowest-level categories to which individual SKUs and catalog items are directly assigned.. Valid values are `true|false`',
    `is_orderable` BOOLEAN COMMENT 'Indicates whether products within this category are currently available for customer ordering. A value of True means the category is open for order placement; False means ordering is blocked (e.g., for internal or regulatory categories).. Valid values are `true|false`',
    `is_procurement_category` BOOLEAN COMMENT 'Indicates whether this category is used for procurement spend classification in SAP Ariba, enabling category-level spend analytics, supplier segmentation, and sourcing strategy alignment.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'ISO 639-1 language code indicating the language in which the category name and description are stored in this record (e.g., en, de, zh-CN). Supports multi-language catalog management for global operations.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this product category record was most recently updated, recorded in ISO 8601 format. Used for incremental data loading, change detection, and audit compliance in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lifecycle_stage` STRING COMMENT 'Current product lifecycle stage of the category as a whole, reflecting the commercial maturity of the product group: introduction (newly launched), growth, maturity, decline, end_of_life, or obsolete. Supports portfolio management and strategic planning.. Valid values are `introduction|growth|maturity|decline|end_of_life|obsolete`',
    `name` STRING COMMENT 'Short, human-readable name of the product category as displayed in the commercial catalog and ordering interfaces (e.g., Drive Technology, Motion Control, Power Distribution).',
    `product_line` STRING COMMENT 'The commercial product line or brand family associated with this category (e.g., SIMATIC, SINAMICS, SENTRON, SCALANCE). Used for brand-level reporting and catalog organization.',
    `regulatory_scope` STRING COMMENT 'Identifies the primary regulatory or compliance framework applicable to products in this category (e.g., ce_marking for EU market access, rohs for hazardous substance restrictions, reach for chemical registration, ul_certification for North American safety). Drives compliance reporting and certification tracking.. Valid values are `ce_marking|rohs|reach|ul_certification|iec_62443|iso_9001|none|multiple`',
    `sap_material_group` STRING COMMENT 'The SAP S/4HANA Material Group code (field MATKL) mapped to this product category, used for procurement, inventory valuation, and reporting alignment with the ERP system of record.. Valid values are `^[A-Z0-9]{1,9}$`',
    `sort_order` STRING COMMENT 'Numeric value controlling the display sequence of this category within its parent level in catalog navigation interfaces, portals, and reporting tools. Lower values appear first.. Valid values are `^[0-9]+$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this product category record originated (e.g., SAP_S4HANA for MM material group, TEAMCENTER_PLM for PLM classification). Supports data lineage and Silver layer traceability.. Valid values are `SAP_S4HANA|TEAMCENTER_PLM|SALESFORCE_CRM|SAP_ARIBA|MANUAL|OTHER`',
    `source_system_key` STRING COMMENT 'The natural or technical key of this category record in the originating source system (e.g., SAP material group code, Teamcenter classification ID). Used for reconciliation, delta processing, and audit traceability in the lakehouse.',
    `spend_category_code` STRING COMMENT 'Procurement spend category code used in SAP Ariba for supplier segmentation, sourcing strategy, and spend analytics. Maps this product category to the enterprise procurement taxonomy for category management.',
    `status` STRING COMMENT 'Current lifecycle status of the product category: active (available for ordering and catalog navigation), inactive (temporarily disabled), pending (awaiting approval), discontinued (no longer in use), draft (under creation/review).. Valid values are `active|inactive|pending|discontinued|draft`',
    `tax_classification` STRING COMMENT 'Tax classification code assigned to this product category, used to determine applicable VAT, GST, or sales tax rates during order processing and invoicing. Aligned with SAP S/4HANA tax determination logic.',
    `type` STRING COMMENT 'Classifies the category by its primary business purpose: commercial for customer-facing catalog groupings, operational for internal production/procurement use, regulatory for compliance-driven groupings, aftermarket for spare parts and service items, internal for non-saleable items.. Valid values are `commercial|operational|regulatory|aftermarket|internal`',
    `unspsc_code` STRING COMMENT 'The United Nations Standard Products and Services Code (UNSPSC) mapped to this category, enabling cross-industry spend classification, procurement benchmarking, and supplier management alignment in SAP Ariba.. Valid values are `^[0-9]{8}$`',
    CONSTRAINT pk_category PRIMARY KEY(`category_id`)
) COMMENT 'Reference classification taxonomy for grouping catalog items into commercial and operational categories — such as Drive Technology, Motion Control, Industrial Automation, Power Distribution, Building Technologies, and Aftermarket Spare Parts. Each category carries a category code, parent category (supporting multi-level hierarchy), description, applicable industry segment, and whether the category is active for ordering. Used for catalog navigation, spend analytics, and regulatory grouping.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` (
    `product_regulatory_certification_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each regulatory certification record in the product compliance catalog.',
    `application_id` BIGINT COMMENT 'Foreign key linking to technology.application. Business justification: Regulatory certifications (UL, CE, ISO) are managed in compliance management applications. Quality and regulatory affairs teams track certification documents, test results, and audit trails in special',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: regulatory_certification scope_level can be at catalog_item level (not just SKU). Adding catalog_item_id FK (nullable) enables direct referential integrity at the catalog item level. No additional col',
    `change_notice_id` BIGINT COMMENT 'Foreign key linking to product.product_change_notice. Business justification: regulatory_certification.ecn_reference is a STRING reference to the Engineering Change Notice that impacted a certification (e.g., RoHS/CE re-certification after a design change). Adding product_chang',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: regulatory_certification records product-level certifications tied to specific SKUs. sku_code and product_name are denormalized STRING references. Adding sku_id FK normalizes this relationship. sku_co',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: Regulatory certifications are often obtained during R&D phase before product launch. Compliance teams track which R&D project achieved certifications for audit trails and regulatory documentation requ',
    `regulatory_obligation_id` BIGINT COMMENT 'Foreign key linking to hse.regulatory_obligation. Business justification: Product certifications (CE, UL, ATEX) must link to specific regulatory obligations they fulfill. Quality and compliance teams use this to track certification validity against changing regulations.',
    `applicable_directives` STRING COMMENT 'Pipe-separated list of EU directives, harmonized standards, or regulatory frameworks under which the certification was granted (e.g., Low Voltage Directive 2014/35/EU|EMC Directive 2014/30/EU|IEC 61010-1). Critical for CE Marking declarations of conformity.',
    `applicable_markets` STRING COMMENT 'Pipe-separated list of ISO 3166-1 alpha-3 country codes or market identifiers for which this certification grants market access (e.g., DEU|FRA|GBR|USA|CHN). Drives export control decisions and customer compliance documentation.',
    `certificate_document_reference` STRING COMMENT 'Document management system reference or URL pointing to the scanned or digital copy of the official certificate. Enables direct retrieval of the certificate for customer compliance packages, audits, and export documentation.',
    `certificate_number` STRING COMMENT 'Official certificate number or reference code assigned by the issuing certification body (e.g., UL file number, CE declaration reference, RoHS certificate ID). Used for external verification and customer compliance documentation.',
    `certification_cost` DECIMAL(18,2) COMMENT 'Total cost incurred to obtain or renew this certification, including testing fees, certification body fees, and audit costs. Expressed in the currency specified by certification_cost_currency. Used for compliance budget tracking and OPEX reporting.',
    `certification_cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the certification cost amount (e.g., USD, EUR, GBP, CNY). Supports multi-currency financial reporting for global compliance operations.. Valid values are `^[A-Z]{3}$`',
    `certification_standard` STRING COMMENT 'Primary technical standard or norm against which the product was tested and certified (e.g., IEC 61010-1:2010, UL 508A, EN 60947-1, IEC 62443-4-2). Provides the technical basis for the certification and is referenced in test reports and declarations of conformity.',
    `certification_type` STRING COMMENT 'Classification of the regulatory certification or compliance approval. Identifies the specific scheme under which the product has been certified (e.g., CE Marking for EU market access, UL Listing for North American safety, CCC for China market, EAC for Eurasian Economic Union).. Valid values are `CE Marking|UL Listing|RoHS Compliance|REACH Declaration|CSA Certification|CCC Certification|EAC Certification|UL Recognition|FCC Authorization|ATEX Certification|IECEx Certification|KC Certification|PSE Certification|BIS Certification|INMETRO Certification|Other`',
    `country_of_manufacture` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the manufacturing site where the certified product is produced. Relevant for country-of-origin declarations, export control, and some certification schemes that require manufacturing site registration.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this certification record was first created in the data product. Supports audit trail requirements and data lineage tracking in the Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `declaration_of_conformity_reference` STRING COMMENT 'Document reference number or PLM system identifier for the manufacturers Declaration of Conformity (DoC) associated with this certification. Required for CE Marking and other self-declaration schemes under EU New Legislative Framework.',
    `expiry_date` DATE COMMENT 'The date on which the certification expires and is no longer valid for market access. Null if the certification has no defined expiry (e.g., some RoHS declarations). Used to trigger renewal workflows and prevent shipment of non-compliant products.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_control_flag` BOOLEAN COMMENT 'Indicates whether this certification has specific export control implications or restrictions (e.g., dual-use technology certifications, ITAR-controlled products). True triggers additional export compliance review before shipment to applicable markets.. Valid values are `true|false`',
    `hazardous_substance_declaration` STRING COMMENT 'Indicates the products compliance declaration status with respect to hazardous substance restrictions (RoHS, REACH, California Prop 65). Full Compliance means all restricted substances are below threshold; Exemption Applied means one or more RoHS exemptions are in use.. Valid values are `Full Compliance|Exemption Applied|Non-Applicable|Under Assessment`',
    `issue_date` DATE COMMENT 'The date on which the certification was officially issued or granted by the issuing body. Marks the start of the certificates validity period and is required for compliance documentation submitted to customers and regulators.. Valid values are `^d{4}-d{2}-d{2}$`',
    `issuing_body` STRING COMMENT 'Name of the regulatory authority, notified body, or accredited certification organization that issued the certificate (e.g., TÜV Rheinland, Bureau Veritas, Underwriters Laboratories, SGS, Intertek, DEKRA, China Quality Certification Centre).',
    `issuing_body_accreditation_number` STRING COMMENT 'Accreditation number of the notified body or certification organization as registered with the relevant national accreditation authority (e.g., NANDO notified body number for EU, ILAC member accreditation number). Enables verification of the certifiers authority.',
    `language_code` STRING COMMENT 'ISO 639-1 language code of the certificate document and associated compliance documentation (e.g., en, de, zh-CN, fr). Relevant for multi-language compliance packages required in different markets.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this certification record. Used for change detection, incremental data loading in the lakehouse pipeline, and compliance audit trails.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_surveillance_date` DATE COMMENT 'Date of the most recently completed surveillance audit or factory inspection. Used to verify compliance maintenance history and calculate the interval to the next required audit.. Valid values are `^d{4}-d{2}-d{2}$`',
    `manufacturing_site_code` STRING COMMENT 'Internal code identifying the specific manufacturing plant or facility where the certified product is produced. Some certifications (e.g., UL, CCC) are site-specific and require re-certification if production moves to a different facility.',
    `next_surveillance_date` DATE COMMENT 'Scheduled date of the next surveillance audit or periodic factory inspection required to maintain certification validity. Used for compliance calendar management and audit preparation planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reach_svhc_flag` BOOLEAN COMMENT 'Indicates whether the product contains any Substances of Very High Concern (SVHC) as defined under the EU REACH Regulation above the 0.1% w/w threshold. True triggers mandatory customer notification and supply chain communication obligations.. Valid values are `true|false`',
    `renewal_submission_date` DATE COMMENT 'The date on which the renewal application was submitted to the issuing body. Populated when status is Under Renewal. Used to track renewal progress and ensure continuity of market access.. Valid values are `^d{4}-d{2}-d{2}$`',
    `responsible_compliance_owner` STRING COMMENT 'Name or employee ID of the internal compliance engineer or regulatory affairs manager responsible for maintaining this certification, managing renewals, and responding to customer compliance inquiries.',
    `responsible_org_unit` STRING COMMENT 'Business unit, division, or department responsible for managing this certification (e.g., Global Regulatory Affairs, Product Compliance Engineering, Quality Management). Used for organizational accountability and compliance reporting.',
    `rohs_exemption_codes` STRING COMMENT 'Pipe-separated list of RoHS Annex III or Annex IV exemption codes applicable to this product (e.g., 6(a)|6(b)|7(a)). Documents the legal basis for any restricted substance usage above threshold limits. Required for RoHS compliance declarations.',
    `scope_description` STRING COMMENT 'Detailed textual description of the products, product variants, or components covered by this certification. May include model numbers, voltage ranges, power ratings, or other technical parameters that define the certification boundary.',
    `scope_level` STRING COMMENT 'Indicates whether the certification applies to a single product (SKU), a product family, a product line, a platform, or an individual component. Determines the breadth of market access coverage provided by this certificate.. Valid values are `Product|Product Family|Product Line|Platform|Component`',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this certification record was sourced (e.g., SAP S/4HANA QM module, Siemens Teamcenter PLM). Supports data lineage tracking in the Databricks Silver Layer lakehouse.. Valid values are `SAP S/4HANA|Siemens Teamcenter PLM|Manual Entry|Other`',
    `source_system_key` STRING COMMENT 'Primary key or unique identifier of this certification record in the originating source system (e.g., SAP QM certificate object number, Teamcenter PLM document ID). Enables traceability and reconciliation between the lakehouse and operational systems.',
    `standard_version` STRING COMMENT 'Version, edition, or amendment level of the certification standard applied (e.g., Ed. 3.0, Amendment 1, 2019 revision). Critical for tracking compliance against evolving standards and managing transition periods when new editions are published.',
    `status` STRING COMMENT 'Current lifecycle status of the regulatory certification. Valid indicates active market access; Expired indicates lapsed certification; Under Renewal indicates renewal in progress; Suspended indicates temporary withdrawal by the issuing body; Withdrawn indicates permanent revocation; Pending Initial indicates first-time certification in progress.. Valid values are `Valid|Expired|Under Renewal|Suspended|Withdrawn|Pending Initial|Cancelled`',
    `status_reason` STRING COMMENT 'Textual explanation for the current certification status, particularly when status is Suspended, Withdrawn, or Cancelled. Documents the root cause (e.g., product design change, non-conformance finding, voluntary withdrawal from market).',
    `surveillance_audit_required` BOOLEAN COMMENT 'Indicates whether this certification requires periodic surveillance audits or factory inspections by the issuing body to maintain validity. True triggers scheduling of surveillance visits in the compliance calendar.. Valid values are `true|false`',
    `test_report_number` STRING COMMENT 'Reference number of the test report or evaluation report issued by the testing laboratory that underpins this certification. Used to retrieve supporting technical evidence during audits, customer inquiries, or regulatory inspections.',
    `testing_laboratory` STRING COMMENT 'Name of the accredited testing laboratory that conducted the product testing and issued the test report supporting this certification (e.g., TÜV SÜD Product Service, Intertek Testing Services, SGS Laboratories). May differ from the issuing body.',
    CONSTRAINT pk_product_regulatory_certification PRIMARY KEY(`product_regulatory_certification_id`)
) COMMENT 'Records all product-level regulatory certifications and compliance approvals required for market access — including CE Marking, UL Listing, RoHS compliance, REACH substance declarations, CSA, CCC, and EAC certifications. Captures certification type, issuing body, certificate number, scope (product or product family), issue date, expiry date, applicable markets/regions, certification status (valid, expired, under renewal), and the responsible compliance owner. Critical for export control and customer compliance documentation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`hazardous_substance` (
    `hazardous_substance_id` BIGINT COMMENT 'Unique system-generated identifier for each hazardous substance record in the product compliance catalog.',
    `compliance_reach_substance_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.reach_substance_declaration. Business justification: Hazardous substances in products must be linked to formal REACH declarations. Material compliance specialists use this to ensure proper substance registration and customer communication for SVHC-conta',
    `applicable_regulation` STRING COMMENT 'Primary regulatory framework under which this substance is restricted or declarable (e.g., RoHS Directive 2011/65/EU, REACH SVHC, California Proposition 65, TSCA). Drives compliance obligations and documentation requirements.. Valid values are `RoHS|REACH_SVHC|California_Prop65|WEEE|POP|TSCA|China_RoHS|ELV|other`',
    `authorization_expiry_date` DATE COMMENT 'Expiry date of the REACH authorization granted for use of a Substance of Very High Concern (SVHC). After this date, use of the substance is prohibited unless a new authorization is obtained.. Valid values are `^d{4}-d{2}-d{2}$`',
    `authorization_number` STRING COMMENT 'Authorization number granted by the European Chemicals Agency (ECHA) under REACH Annex XIV permitting the continued use of a Substance of Very High Concern (SVHC) for a specific use case beyond the sunset date.',
    `cas_number` STRING COMMENT 'Unique numerical identifier assigned by the Chemical Abstracts Service (CAS) to uniquely identify a chemical substance. Used globally for substance identification across regulatory databases.. Valid values are `^[0-9]{2,7}-[0-9]{2}-[0-9]$`',
    `compliance_status` STRING COMMENT 'Current regulatory compliance status of the substance record for the associated catalog item. Drives product release decisions, customer material declarations, and corrective action workflows.. Valid values are `compliant|non_compliant|exempted|under_review|pending_data|not_applicable`',
    `concentration_ppm` DECIMAL(18,2) COMMENT 'Measured or declared concentration of the hazardous substance in the catalog item or homogeneous material, expressed in parts per million (PPM) by weight. Used to assess compliance against regulatory threshold limits.. Valid values are `^[0-9]+(.[0-9]+)?$`',
    `country_of_applicability` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code indicating the country or market jurisdiction where this substance regulation applies. Supports multi-jurisdictional compliance management for global product distribution.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the hazardous substance record was first created in the system. Used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `data_source_type` STRING COMMENT 'Origin of the substance concentration data: laboratory test result, supplier-provided declaration, internal engineering analysis, third-party certification, or Material Safety Data Sheet (MSDS/SDS). Indicates data reliability and traceability.. Valid values are `lab_test|supplier_declaration|internal_analysis|third_party_certification|material_safety_data_sheet|other`',
    `declaration_date` DATE COMMENT 'Date on which the substance declaration or compliance assessment was formally recorded or submitted. Used for regulatory reporting timelines and document version control.. Valid values are `^d{4}-d{2}-d{2}$`',
    `declaration_type` STRING COMMENT 'Type of compliance declaration associated with this substance record: exemption (substance use is permitted under a specific regulatory exemption), substitution (substance has been replaced), declaration of conformity (product conforms to limits), or disclosure (substance is declared for transparency).. Valid values are `exemption|substitution|declaration_of_conformity|disclosure|not_applicable`',
    `ec_number` STRING COMMENT 'European Community (EC) number assigned by the European Chemicals Agency (ECHA) to substances listed in the EINECS, ELINCS, or NLP inventories. Required for REACH compliance documentation.. Valid values are `^[0-9]{3}-[0-9]{3}-[0-9]$`',
    `exceeds_threshold` BOOLEAN COMMENT 'Indicates whether the measured substance concentration (concentration_ppm) exceeds the regulatory threshold limit (threshold_limit_ppm). True signals a potential non-compliance condition requiring corrective action or exemption documentation.. Valid values are `true|false`',
    `exemption_reference` STRING COMMENT 'Specific exemption clause or annex reference under the applicable regulation that permits the use of this substance above the threshold limit (e.g., RoHS Annex III exemption 6(c) for lead in glass of cathode ray tubes).',
    `ghs_hazard_class` STRING COMMENT 'Hazard classification of the substance under the Globally Harmonized System of Classification and Labelling of Chemicals (GHS), such as acute toxicity, carcinogenicity, reproductive toxicity, or environmental hazard. Drives SDS and labeling requirements.',
    `ipc1752_substance_class` STRING COMMENT 'Substance classification per the IPC-1752A Material Declaration Standard, indicating the level of reporting obligation (Class A through F). Used for generating standardized customer material declarations in the electronics and industrial manufacturing supply chain.. Valid values are `class_a|class_b|class_c|class_d|class_e|class_f`',
    `iupac_name` STRING COMMENT 'Systematic chemical name of the substance as defined by the International Union of Pure and Applied Chemistry (IUPAC) nomenclature standards, used for unambiguous chemical identification.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the hazardous substance record. Supports change tracking, regulatory audit trails, and data freshness monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `material_application` STRING COMMENT 'Description of the specific material, component, or homogeneous material within the catalog item where the substance is present (e.g., solder alloy, PCB substrate, cable insulation, surface coating). Required for IPC-1752A material declarations.',
    `measurement_method` STRING COMMENT 'Analytical test method used to determine the substance concentration in the material or component (e.g., X-Ray Fluorescence (XRF), ICP-OES, GC-MS). Supports traceability and audit requirements under IEC 62321.. Valid values are `XRF|ICP-OES|ICP-MS|GC-MS|HPLC|wet_chemistry|supplier_declaration|other`',
    `notes` STRING COMMENT 'Free-text field for additional compliance context, engineering notes, or regulatory clarifications related to this substance record (e.g., specific use conditions, pending regulatory decisions, or supplier qualification notes).',
    `product_category_scope` STRING COMMENT 'RoHS or REACH product category or equipment category to which this substance restriction applies (e.g., RoHS Annex I Category 1 - Large Household Appliances, Category 9 - Industrial Monitoring and Control Equipment). Determines applicability of restrictions.',
    `prop65_listed_flag` BOOLEAN COMMENT 'Indicates whether the substance is listed under California Proposition 65 (Safe Drinking Water and Toxic Enforcement Act) as known to cause cancer, birth defects, or other reproductive harm. Triggers warning label requirements for products sold in California.. Valid values are `true|false`',
    `regulation_list_version` STRING COMMENT 'Version or revision of the regulatory list or candidate list under which the substance is classified (e.g., REACH SVHC Candidate List version, RoHS Annex II amendment number). Ensures traceability to the specific regulatory update.',
    `review_due_date` DATE COMMENT 'Scheduled date by which the substance compliance record must be reviewed for accuracy and regulatory currency. Triggered by regulatory list updates, product changes, or periodic review cycles.. Valid values are `^d{4}-d{2}-d{2}$`',
    `rohs_restricted_flag` BOOLEAN COMMENT 'Indicates whether the substance is restricted under the RoHS Directive 2011/65/EU (Restriction of Hazardous Substances). Restricted substances include lead, mercury, cadmium, hexavalent chromium, PBB, PBDE, and additional substances added under RoHS 3.. Valid values are `true|false`',
    `sds_document_number` STRING COMMENT 'Reference number of the Safety Data Sheet (SDS) associated with this hazardous substance, as required under OSHA Hazard Communication Standard (HazCom) and REACH. The SDS provides detailed safety, handling, and disposal information.',
    `substance_category` STRING COMMENT 'Chemical classification category of the hazardous substance used for grouping and risk prioritization in compliance programs (e.g., heavy metal, halogen, phthalate, SVHC).. Valid values are `heavy_metal|halogen|phthalate|flame_retardant|solvent|biocide|svhc|persistent_organic_pollutant|other`',
    `substance_function` STRING COMMENT 'Technical function or role of the hazardous substance within the product or material (e.g., flame retardant, plasticizer, colorant, stabilizer). Supports substitution analysis and Design for Environment (DfE) initiatives.. Valid values are `colorant|flame_retardant|plasticizer|stabilizer|catalyst|solvent|preservative|corrosion_inhibitor|other`',
    `substance_name` STRING COMMENT 'Official chemical or common name of the hazardous substance as recognized by regulatory bodies (e.g., Lead, Cadmium, Hexavalent Chromium, Bisphenol A).',
    `substitution_cas_number` STRING COMMENT 'CAS number of the alternative substance used to replace this hazardous substance. Enables precise identification of the substitute chemical for regulatory and procurement purposes.. Valid values are `^[0-9]{2,7}-[0-9]{2}-[0-9]$`',
    `substitution_substance_name` STRING COMMENT 'Name of the alternative substance used to replace this hazardous substance when declaration_type is substitution. Supports Design for Environment (DfE) and green chemistry initiatives.',
    `supplier_declaration_reference` STRING COMMENT 'Reference number or identifier of the supplier-provided material declaration document (e.g., IPC-1752A form reference, supplier SDS document number) supporting the substance data. Used for audit traceability.',
    `svhc_flag` BOOLEAN COMMENT 'Indicates whether the substance is listed on the REACH Candidate List as a Substance of Very High Concern (SVHC). When true, triggers mandatory disclosure obligations under REACH Article 33 if concentration exceeds 0.1% w/w in articles.. Valid values are `true|false`',
    `test_report_number` STRING COMMENT 'Reference number of the laboratory test report that documents the analytical measurement of the substance concentration. Required for regulatory audit trails and customer compliance documentation.',
    `testing_laboratory` STRING COMMENT 'Name of the accredited laboratory that performed the substance concentration analysis. Supports audit traceability and verification of ISO/IEC 17025-accredited testing.',
    `threshold_limit_ppm` DECIMAL(18,2) COMMENT 'Maximum allowable concentration of the substance in a homogeneous material as defined by the applicable regulation, expressed in parts per million (PPM). Compliance is determined by comparing concentration_ppm against this limit.. Valid values are `^[0-9]+(.[0-9]+)?$`',
    `valid_from_date` DATE COMMENT 'Start date from which this substance record is considered valid and applicable to the associated catalog item or component. Supports lifecycle management of compliance records.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'Expiry date after which this substance record must be reviewed and renewed. Ensures compliance records are kept current with regulatory updates and product changes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `weight_fraction_percent` DECIMAL(18,2) COMMENT 'Concentration of the hazardous substance expressed as a percentage by weight (w/w%) of the homogeneous material or article. Used for REACH SVHC disclosure threshold assessment (0.1% w/w trigger) and IPC-1752A declarations.. Valid values are `^(100(.0+)?|[0-9]{1,2}(.[0-9]+)?)$`',
    CONSTRAINT pk_hazardous_substance PRIMARY KEY(`hazardous_substance_id`)
) COMMENT 'Tracks restricted and declarable substances present in catalog items for RoHS, REACH, and other chemical compliance programs. Captures substance name, CAS number, substance concentration (ppm), threshold limit per regulation, applicable regulation (RoHS, REACH SVHC, California Prop 65), declaration type (exemption, substitution, declaration of conformity), and the associated catalog item or component. Supports product compliance documentation and customer material declarations (e.g., IPC-1752A).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`product_document` (
    `product_document_id` BIGINT COMMENT 'Unique surrogate identifier for each product document record in the commercial and technical document library.',
    `application_id` BIGINT COMMENT 'Foreign key linking to technology.application. Business justification: Product documentation (CAD files, specs, manuals) is stored in PLM/PDM applications. Engineering and quality teams access documents through specific applications like Teamcenter, Windchill, or SharePo',
    `change_notice_id` BIGINT COMMENT 'Foreign key linking to product.product_change_notice. Business justification: product_document.ecn_reference is a STRING reference to the Engineering Change Notice that triggered a document revision. Adding product_change_notice_id FK normalizes this relationship and enables tr',
    `drawing_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_drawing. Business justification: Product documentation includes engineering drawings for installation, maintenance, and technical specifications. Customer service, field engineers, and distributors access product documents that refer',
    `product_regulatory_certification_id` BIGINT COMMENT 'Foreign key linking to product.regulatory_certification. Business justification: product_document manages certificate documents associated with regulatory certifications. certificate_number in product_document references regulatory_certification.certificate_number. Adding regulato',
    `access_level` STRING COMMENT 'Controls who is authorized to access and download this document. Public documents are available on the product portal; restricted documents require authentication and role-based authorization.. Valid values are `public|customer_only|partner_only|internal|restricted`',
    `applicable_product_range` STRING COMMENT 'Free-text or structured description of the specific product models, SKU ranges, or part number series to which this document applies. Supports multi-product document coverage without requiring individual SKU linkage.',
    `approved_by` STRING COMMENT 'Name or employee identifier of the authorized person who approved the document for release. Required for quality management system compliance and regulatory audit trails.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the document was formally approved for release by the authorized approver. Provides an immutable audit trail for quality and regulatory compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `author` STRING COMMENT 'Name or employee identifier of the person who authored or is primarily responsible for the content of this document. Used for accountability and document ownership tracking.',
    `certification_body` STRING COMMENT 'Name of the third-party certification or notified body that issued or validated the document (e.g., UL, TÜV, Bureau Veritas, SGS, Intertek). Applicable for test reports, certificates, and declarations of conformity.',
    `checksum_hash` STRING COMMENT 'SHA-256 cryptographic hash of the document file used to verify document integrity and detect unauthorized modifications. Supports regulatory audit trail requirements and tamper-evidence for compliance documents.. Valid values are `^[a-fA-F0-9]{64}$`',
    `confidential_flag` BOOLEAN COMMENT 'Indicates whether this document is classified as confidential and subject to non-disclosure restrictions. Confidential documents require NDA or contractual agreement before distribution.. Valid values are `true|false`',
    `country_of_applicability` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code(s) indicating the geographic markets for which this document is valid. GLOBAL indicates worldwide applicability. Pipe-separated for multi-country documents.. Valid values are `^[A-Z]{3}(|[A-Z]{3})*$|^GLOBAL$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the product document record was first created in the data platform. Provides audit trail for data lineage and record management.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `distribution_channel` STRING COMMENT 'Specifies the channel(s) through which this document is distributed or published. Drives automated publishing workflows and portal content management.. Valid values are `product_portal|customer_portal|partner_portal|internal_intranet|regulatory_submission|print_only|all`',
    `effective_date` DATE COMMENT 'Date from which the document version becomes the authoritative reference for product use, compliance, and manufacturing. May differ from publication date when a transition period is required.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date on which the document is scheduled to expire or be reviewed for renewal. Particularly relevant for certificates, declarations of conformity, and regulatory approvals with defined validity periods.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_controlled_flag` BOOLEAN COMMENT 'Indicates whether this document is subject to export control regulations (e.g., EAR, ITAR) and requires authorization before distribution to foreign nationals or international customers.. Valid values are `true|false`',
    `file_format` STRING COMMENT 'Electronic file format of the document (e.g., PDF, DOCX, DWG). Determines rendering capability, archival requirements, and distribution channel compatibility.. Valid values are `PDF|DOCX|XLSX|DWG|DXF|HTML|XML|ZIP|STEP|IGES|PNG|JPEG|MP4`',
    `file_size_kb` STRING COMMENT 'Size of the document file in kilobytes. Used for storage management, download time estimation, and portal performance optimization.. Valid values are `^[0-9]+$`',
    `hazardous_content_flag` BOOLEAN COMMENT 'Indicates whether this document contains or references hazardous material information (e.g., Safety Data Sheets for products containing restricted substances). Triggers mandatory handling and distribution controls.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'ISO 639-1 two-letter language code (optionally with ISO 3166-1 country subtag) indicating the language in which the document is authored (e.g., en, de, fr, zh-CN). Supports multilingual document management for global product distribution.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the product document record was most recently updated in the data platform. Used for change tracking, incremental data loads, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next mandatory review of this document to ensure continued accuracy, regulatory compliance, and alignment with current product specifications.. Valid values are `^d{4}-d{2}-d{2}$`',
    `number` STRING COMMENT 'Official document number assigned by the document management system (Siemens Teamcenter or SAP DMS) that uniquely identifies the document across all revisions and versions.. Valid values are `^[A-Z0-9-.]{3,50}$`',
    `owner_department` STRING COMMENT 'Organizational department or business unit responsible for maintaining and updating this document (e.g., Product Engineering, Regulatory Affairs, Marketing, Quality Management).',
    `publication_date` DATE COMMENT 'Date on which the document was officially published and made available for distribution to internal users, customers, or regulatory bodies.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reach_compliant` BOOLEAN COMMENT 'Indicates whether this document certifies REACH compliance for the associated product. Required for chemical substance declarations and Safety Data Sheets (SDS) under EU REACH Regulation.. Valid values are `true|false`',
    `regulatory_standard` STRING COMMENT 'The specific regulatory standard, directive, or certification framework that this document supports or demonstrates compliance with (e.g., IEC 61131, CE Marking Directive, RoHS Directive 2011/65/EU, REACH Regulation, UL 508A, ISO 9001). Critical for Declaration of Conformity and test report documents.',
    `review_cycle_months` STRING COMMENT 'Defined periodic review interval in months for this document type. Drives automated review reminders and ensures documents remain current with product changes and regulatory updates.. Valid values are `^[0-9]+$`',
    `revision_level` STRING COMMENT 'Current revision or version identifier of the document (e.g., A, B, 01, 1.0, Rev C). Tracks the document change history and ensures the correct version is referenced in production and compliance activities.. Valid values are `^[A-Z0-9.]{1,10}$`',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether this document (typically an SDS or Declaration of Conformity) certifies RoHS compliance for the associated product. Mandatory for products sold in the European Union under Directive 2011/65/EU.. Valid values are `true|false`',
    `sap_dms_document_key` STRING COMMENT 'Document key from SAP DMS (Document Management System within SAP S/4HANA) used to link the product document record back to the originating SAP document object for procurement, quality, and production cross-references.',
    `scope` STRING COMMENT 'Indicates the breadth of product applicability for this document — whether it applies to a single SKU, a product family, an entire product line, or a platform-wide standard.. Valid values are `single_product|product_family|product_line|platform|global`',
    `source_system` STRING COMMENT 'Identifies the originating operational system of record from which this document record was sourced (e.g., Siemens Teamcenter PLM, SAP DMS). Supports data lineage tracking in the Databricks Silver Layer.. Valid values are `teamcenter|sap_dms|manual|salesforce|external`',
    `status` STRING COMMENT 'Current lifecycle status of the document. Controls whether the document is available for distribution, under review, or retired from active use. Aligns with document control requirements under ISO 9001.. Valid values are `draft|in_review|approved|released|obsolete|superseded|withdrawn`',
    `storage_location_uri` STRING COMMENT 'Uniform Resource Identifier (URI) pointing to the physical storage location of the document file in the enterprise content management system, cloud storage (e.g., Azure Data Lake, S3), or Teamcenter vault. Enables direct file retrieval.. Valid values are `^(https?|s3|abfss|dbfs)://.*$`',
    `teamcenter_document_reference` STRING COMMENT 'Native document identifier from Siemens Teamcenter PLM document management module. Enables direct cross-reference and drill-through to the authoritative source system record.',
    `title` STRING COMMENT 'Full descriptive title of the document as it appears on the cover page or header, used for search, display, and catalog purposes.',
    `type` STRING COMMENT 'Classification of the document by its business purpose and content type. Drives downstream routing, access control, and regulatory compliance workflows. Includes SDS (Safety Data Sheet), DoC (Declaration of Conformity), and other standard document categories.. Valid values are `datasheet|installation_manual|user_guide|safety_data_sheet|declaration_of_conformity|test_report|marketing_collateral|quick_start_guide|service_manual|spare_parts_catalog|certificate|drawing|specification|standard_operating_procedure|application_note`',
    CONSTRAINT pk_product_document PRIMARY KEY(`product_document_id`)
) COMMENT 'Manages the library of commercial and technical documents associated with catalog items — including datasheets, installation manuals, user guides, safety data sheets (SDS), declaration of conformity (DoC), test reports, and marketing collateral. Captures document type, document number, revision level, language, file format, publication date, applicable product scope, and document status (draft, released, obsolete). Linked to Siemens Teamcenter document management and SAP DMS.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`substitution` (
    `substitution_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a product substitution or supersession relationship record in the catalog.',
    `change_notice_id` BIGINT COMMENT 'Foreign key linking to product.product_change_notice. Business justification: product_substitution.ecn_reference is a STRING reference to the Engineering Change Notice that drove the substitution/supersession. Adding product_change_notice_id FK normalizes this relationship and ',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: product_substitution.source_sku is a STRING reference to the original SKU being substituted. Adding source_sku_id FK normalizes this reference and enables referential integrity for the source side of ',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: product_substitution.source_material_number is a STRING reference to the original catalog item being substituted (at material/catalog item level). Adding source_catalog_item_id FK normalizes this refe',
    `application_scope` STRING COMMENT 'Defines the business processes in which this substitution relationship is applicable. Allows selective enablement — e.g., a substitution valid for spare parts cross-referencing in service but not for production BOM substitution.. Valid values are `all|order-management|service-spare-parts|procurement|bom-substitution|field-service`',
    `approved_by` STRING COMMENT 'Name or user ID of the authorized approver who validated and activated the substitution record. Supports audit trail and change management governance requirements.',
    `approved_timestamp` TIMESTAMP COMMENT 'The date and time when the substitution record was formally approved and authorized for use in business processes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when the substitution record was first created in the system. Used for audit trail, data lineage, and change history tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customer_notification_required` BOOLEAN COMMENT 'Indicates whether the customer must be notified before or when this substitution is applied to their order. Supports SLA compliance and customer communication workflows in Salesforce CRM Service Cloud.. Valid values are `true|false`',
    `direction` STRING COMMENT 'Indicates whether the substitution applies in one direction only (source can be replaced by target, but not vice versa) or bidirectionally (either product can substitute for the other). Critical for ATP/CTP fallback logic in order management.. Valid values are `one-way|bidirectional`',
    `effective_date` DATE COMMENT 'The date from which the substitution relationship becomes valid and can be applied in order management, procurement, and service operations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'The date after which the substitution relationship is no longer valid. Null indicates no planned expiry. Used to automatically deactivate time-limited substitutions such as emergency alternates.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_control_flag` BOOLEAN COMMENT 'Indicates whether the substitution involves products subject to export control regulations (e.g., EAR, ITAR). When true, the substitution must be reviewed by the trade compliance team before application in international orders.. Valid values are `true|false`',
    `functional_equivalence_level` STRING COMMENT 'Describes the degree to which the target product is functionally equivalent to the source product. full means complete drop-in replacement; partial means some functional differences exist; form-fit-function meets dimensional and interface requirements; dimensional-only matches physical dimensions only; performance-limited has reduced performance characteristics.. Valid values are `full|partial|form-fit-function|dimensional-only|performance-limited`',
    `hazardous_material_change_flag` BOOLEAN COMMENT 'Indicates whether the substitution involves a change in hazardous material content or classification between the source and target products. Triggers mandatory review under REACH, RoHS, and HSE compliance workflows.. Valid values are `true|false`',
    `is_auto_substitution_allowed` BOOLEAN COMMENT 'Indicates whether the system is permitted to automatically apply this substitution during order processing (ATP/CTP fallback) without manual intervention. When false, a planner or customer service representative must approve the substitution.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when the substitution record was most recently updated. Used for incremental data loading, change detection, and audit trail in the Databricks Lakehouse Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lead_time_impact_days` STRING COMMENT 'The difference in procurement or production lead time (in calendar days) between the target and source products. Positive values indicate longer lead time for the substitute; negative values indicate shorter. Used in ATP/CTP calculations.',
    `notes` STRING COMMENT 'Free-text field for additional operational notes, special handling instructions, or contextual information relevant to the substitution relationship that is not captured by structured fields.',
    `number` STRING COMMENT 'Business-facing unique identifier for the substitution relationship, used in order management, service, and procurement communications (e.g., SUB-2024-00123).. Valid values are `^SUB-[A-Z0-9]{4,20}$`',
    `plm_substitution_reference` STRING COMMENT 'The corresponding substitution or interchangeability record identifier in Siemens Teamcenter PLM, enabling cross-system traceability between the commercial product catalog and the engineering product data management system.',
    `price_impact_indicator` STRING COMMENT 'Indicates the general price impact of applying the substitution relative to the source product. Used by order management and sales to communicate cost implications to customers and for margin analysis.. Valid values are `higher|lower|neutral|variable`',
    `priority` STRING COMMENT 'Numeric priority rank when multiple substitutes exist for a single source product. Lower number indicates higher preference (1 = most preferred). Used by ATP/CTP logic to sequence fallback options during order promising.. Valid values are `^[1-9][0-9]*$`',
    `quantity_ratio` DECIMAL(18,2) COMMENT 'The quantity conversion ratio between source and target products. A value of 1.0 indicates a 1:1 substitution; a value of 2.0 means 2 units of the target are required to replace 1 unit of the source. Critical for accurate order fulfillment and BOM substitution.',
    `reason_code` STRING COMMENT 'Standardized reason code explaining why the substitution relationship was established. Supports analytics on substitution drivers and Engineering Change Notice (ECN) traceability.. Valid values are `eol-replacement|cost-reduction|performance-upgrade|supply-continuity|regulatory-compliance|design-change|supplier-change|quality-improvement|consolidation`',
    `reason_description` STRING COMMENT 'Free-text narrative providing additional context for the substitution reason beyond the standardized reason code, such as specific engineering justification or supplier change details.',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether the substitution was driven by or must satisfy regulatory compliance requirements (e.g., RoHS, REACH, CE Marking). When true, the substitution must be validated against applicable regulatory certifications before activation.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'The originating operational system of record from which this substitution record was sourced or created (e.g., SAP S/4HANA MM, Siemens Teamcenter PLM). Supports data lineage and reconciliation in the lakehouse.. Valid values are `SAP_S4HANA|TEAMCENTER_PLM|OPCENTER_MES|MANUAL|ARIBA|SALESFORCE_CRM`',
    `source_system_key` STRING COMMENT 'The primary key or unique identifier of the substitution record in the originating source system, enabling bidirectional traceability between the lakehouse silver layer and the operational system of record.',
    `status` STRING COMMENT 'Current lifecycle status of the substitution record. draft indicates under review, pending-approval awaits authorization, active is approved and in use, inactive is temporarily disabled, expired has passed its end date, superseded has been replaced by a newer substitution record.. Valid values are `draft|pending-approval|active|inactive|expired|superseded`',
    `target_material_number` STRING COMMENT 'SAP material number of the target/replacement product, enabling direct traceability to the ERP material master record for the substitute item.',
    `target_sku` STRING COMMENT 'The replacement or substitute product SKU that fulfills the role of the source product. This is the to side of the substitution relationship.',
    `type` STRING COMMENT 'Classifies the nature of the substitution relationship: superseded-by for end-of-life replacements, equivalent for functionally identical items, preferred-alternate for supply continuity alternates, cross-reference for competitor or interchangeable part mapping, emergency-alternate for unplanned supply disruption fallback.. Valid values are `superseded-by|equivalent|preferred-alternate|cross-reference|emergency-alternate`',
    `unit_of_measure` STRING COMMENT 'The unit of measure applicable to the quantity ratio (e.g., EA for each, KG for kilogram, M for meter). Ensures correct quantity conversion when applying the substitution.',
    CONSTRAINT pk_substitution PRIMARY KEY(`substitution_id`)
) COMMENT 'Defines approved product substitution and supersession relationships between catalog items — capturing when a product is replaced by a newer model, a cross-reference to a competitor equivalent, or an approved alternate SKU for supply continuity. Records substitution type (superseded-by, equivalent, preferred-alternate, cross-reference), effective date, substitution direction (one-way or bidirectional), and the reason code (EOL replacement, cost reduction, performance upgrade). Used by order management for ATP/CTP fallback and by service for spare parts cross-referencing.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`bundle` (
    `bundle_id` BIGINT COMMENT 'Unique system-generated identifier for a commercial product bundle or solution package within the industrial automation product catalog.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Product bundles are catalog items composed of multiple items. Sales and order management systems use this to identify the parent bundle item for pricing, inventory allocation, and order fulfillment of',
    `base_unit_of_measure` STRING COMMENT 'The base unit in which the bundle is sold and inventoried (e.g., EA = each, SET = set, KIT = kit). Aligns with SAP unit of measure configuration for order processing.. Valid values are `EA|SET|KIT|PCE|PAL`',
    `business_unit` STRING COMMENT 'The organizational business unit responsible for the product bundle (e.g., Factory Automation, Building Technologies, Drive Technologies, Smart Infrastructure). Used for P&L attribution and portfolio management.',
    `category` STRING COMMENT 'Business domain category of the bundle aligned to the companys product portfolio segments: automation systems, electrification solutions, smart infrastructure, drive systems, MRO kits, and aftermarket packages.. Valid values are `automation_system|electrification_solution|smart_infrastructure|drive_system|control_panel|mro_kit|aftermarket_package|starter_kit|upgrade_kit`',
    `ce_marked` BOOLEAN COMMENT 'Indicates whether the bundle as a whole carries CE marking, confirming conformity with applicable EU health, safety, and environmental protection standards required for sale in the European Economic Area.. Valid values are `true|false`',
    `code` STRING COMMENT 'Human-readable, business-assigned alphanumeric code uniquely identifying the product bundle across commercial and operational systems (e.g., SAP material number for the bundle SKU).. Valid values are `^[A-Z0-9_-]{3,30}$`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the primary country of manufacture or assembly for the bundle. Used for customs declarations, trade compliance, and country-of-origin labeling requirements.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the product bundle record was first created in the system of record. Used for audit trail, data lineage, and catalog management reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `discontinuation_date` DATE COMMENT 'Date on which the product bundle was or is planned to be discontinued from the commercial catalog. Supports end-of-life planning and customer notification processes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `discount_percent` DECIMAL(18,2) COMMENT 'Percentage discount applied to the sum of component prices when the pricing method is discounted_sum. Represents the commercial incentive for purchasing items as a bundle rather than individually.. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    `distribution_channel` STRING COMMENT 'The go-to-market channel through which the bundle is sold: direct_sales (direct to end customer), distributor, online (e-commerce), system_integrator, oem (original equipment manufacturer), or reseller.. Valid values are `direct_sales|distributor|online|system_integrator|oem|reseller`',
    `division` STRING COMMENT 'SAP sales division associated with the bundle, used for sales reporting, pricing determination, and organizational assignment within the sales and distribution structure.',
    `eccn` STRING COMMENT 'Export Control Classification Number assigned to the bundle under the US Export Administration Regulations (EAR). Determines export licensing requirements for shipments to controlled countries or end-users.. Valid values are `^[0-9][A-Z][0-9]{3}[a-z]?$|^EAR99$`',
    `export_control_flag` BOOLEAN COMMENT 'Indicates whether the bundle is subject to export control regulations (e.g., EAR, ITAR, EU Dual-Use Regulation). Bundles containing controlled technology require export licenses for certain destinations.. Valid values are `true|false`',
    `harmonized_tariff_code` STRING COMMENT 'Harmonized System (HS) tariff classification code for the bundle used in international trade documentation, customs declarations, and import/export duty determination.. Valid values are `^d{6,10}$`',
    `is_configurable` BOOLEAN COMMENT 'Indicates whether the bundle supports customer-driven configuration (variant configuration), allowing selection of optional components or specifications at order time. True for configurable bundles; False for fixed bundles.. Valid values are `true|false`',
    `is_orderable_standalone` BOOLEAN COMMENT 'Indicates whether the bundle can be ordered as a standalone item without requiring additional products or services. False for bundles that must be sold as part of a larger solution or project.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'ISO 639-1 language code for the bundles descriptive content (name, descriptions). Supports multi-language catalog management for global operations (e.g., en, de, zh-CN, fr, es).. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the product bundle record in the system of record. Supports change tracking, data freshness monitoring, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `launch_date` DATE COMMENT 'Official market launch date of the product bundle, representing when it was first made commercially available to customers. Used for product introduction tracking and go-to-market reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `lifecycle_stage` STRING COMMENT 'Product lifecycle management stage of the bundle indicating its commercial maturity: introduction, growth, maturity, decline, end_of_life, or phase_out. Used for portfolio planning and PLM governance.. Valid values are `introduction|growth|maturity|decline|end_of_life|phase_out`',
    `list_price` DECIMAL(18,2) COMMENT 'Standard published list price for the bundle as a whole, used as the baseline for commercial quotations and order processing.',
    `list_price_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the bundle list price (e.g., USD, EUR, GBP, CNY). Supports multi-currency operations across global markets.. Valid values are `^[A-Z]{3}$`',
    `long_description` STRING COMMENT 'Detailed technical and commercial description of the bundle including scope of supply, key components, and intended application (e.g., factory automation, building electrification).',
    `min_order_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity of the bundle that must be ordered in a single sales transaction. Enforced during order entry to ensure commercial viability of the bundle offering.',
    `name` STRING COMMENT 'Commercial name of the product bundle as presented in the sales catalog and customer-facing materials (e.g., Complete Drive System Bundle - 15kW).',
    `pricing_method` STRING COMMENT 'Defines how the bundle price is determined: fixed_bundle_price (single price for the entire bundle), sum_of_components (total of individual item prices), discounted_sum (sum of components minus a bundle discount), tiered_price (price varies by quantity), negotiated_price (customer-specific agreed price).. Valid values are `fixed_bundle_price|sum_of_components|discounted_sum|tiered_price|negotiated_price`',
    `reach_compliant` BOOLEAN COMMENT 'Indicates whether the bundle complies with EU REACH Regulation (EC) No 1907/2006 on Registration, Evaluation, Authorisation and Restriction of Chemicals. Required for CE-marked products sold in the European market.. Valid values are `true|false`',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether all components within the bundle comply with the EU Restriction of Hazardous Substances (RoHS) Directive 2011/65/EU, restricting use of specific hazardous materials in electrical and electronic equipment.. Valid values are `true|false`',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for selling the bundle, defining the legal entity and regional sales structure under which the bundle is marketed and sold.',
    `short_description` STRING COMMENT 'Concise marketing or operational description of the bundle suitable for order confirmations, quotations, and catalog listings.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which the bundle record originates (e.g., SAP S/4HANA SD, Siemens Teamcenter PLM, Salesforce CRM). Supports data lineage and reconciliation in the lakehouse.. Valid values are `SAP_S4HANA|TEAMCENTER_PLM|SALESFORCE_CRM|MANUAL|LEGACY`',
    `source_system_key` STRING COMMENT 'The primary key or unique identifier of the bundle record in the originating source system (e.g., SAP material number, Teamcenter item ID). Enables traceability and reconciliation between the lakehouse and operational systems.',
    `standard_cost` DECIMAL(18,2) COMMENT 'Standard cost of the bundle representing the aggregated cost of all component items plus any bundling/packaging costs. Used for cost of goods sold (COGS) calculation and margin analysis.',
    `standard_cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the bundle standard cost (e.g., USD, EUR). Supports multi-currency cost reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `status` STRING COMMENT 'Current lifecycle status of the product bundle: draft (in preparation), active (available for sale), discontinued (no longer sold), superseded (replaced by a newer bundle), blocked (temporarily unavailable), under_review (pending approval or change).. Valid values are `draft|active|discontinued|superseded|blocked|under_review`',
    `target_industry` STRING COMMENT 'Primary industry vertical for which the bundle is designed and marketed, enabling industry-specific catalog filtering, solution selling, and vertical market analytics.. Valid values are `automotive|food_beverage|pharmaceutical|oil_gas|utilities|building_automation|transportation|discrete_manufacturing|process_manufacturing|general_industry`',
    `type` STRING COMMENT 'Classification of the bundle structure: fixed_bundle (predefined set of items), configurable_bundle (customer-selectable options), promotional_kit (time-limited promotional grouping), solution_package (complete system solution), spare_parts_kit (MRO/aftermarket parts set), service_bundle (combined product and service offering).. Valid values are `fixed_bundle|configurable_bundle|promotional_kit|solution_package|spare_parts_kit|service_bundle`',
    `ul_listed` BOOLEAN COMMENT 'Indicates whether the bundle has been evaluated and listed by Underwriters Laboratories (UL) for product safety certification, required for sale in North American markets.. Valid values are `true|false`',
    `valid_from` DATE COMMENT 'Date from which the product bundle is commercially available and can be included in sales orders and quotations. Defines the start of the bundles active selling period.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to` DATE COMMENT 'Date after which the product bundle is no longer available for new sales orders. Used to manage promotional kit expiry, product phase-outs, and catalog validity windows.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_bundle PRIMARY KEY(`bundle_id`)
) COMMENT 'Defines commercial product bundles and solution packages — grouping multiple catalog items into a single orderable offering (e.g., a complete drive system bundle including VFD, motor, and HMI panel). Captures bundle name, bundle type (fixed bundle, configurable bundle, promotional kit), validity period, bundle pricing method (fixed bundle price vs. sum of components), and bundle status. Supports solution selling and system integration offerings common in industrial automation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`bundle_component` (
    `bundle_component_id` BIGINT COMMENT 'Unique surrogate identifier for each bundle component line-level association record within the product catalog. Serves as the primary key for this entity in the Databricks Silver Layer.',
    `bundle_id` BIGINT COMMENT 'Reference to the parent product bundle to which this component belongs. Links the component line to its containing bundle definition in the product catalog.',
    `change_notice_id` BIGINT COMMENT 'Foreign key linking to product.product_change_notice. Business justification: bundle_component.ecn_reference is a STRING reference to the Engineering Change Notice that triggered a bundle component change. Adding product_change_notice_id FK normalizes this relationship and enab',
    `catalog_item_id` BIGINT COMMENT 'Reference to the catalog item (finished good, automation system, electrification solution, smart infrastructure component, or aftermarket part) that constitutes this bundle component line.',
    `product_sku_id` BIGINT COMMENT 'Reference to the specific Stock Keeping Unit (SKU) variant of the catalog item assigned to this bundle component line, enabling variant-level bundle configuration.',
    `approved_by` STRING COMMENT 'Username or employee identifier of the individual who approved this bundle component association record, supporting authorization workflows and audit trail requirements for product catalog governance.',
    `approved_timestamp` TIMESTAMP COMMENT 'The date and time when this bundle component association record received formal approval, recorded in ISO 8601 format with timezone offset. Provides a complete approval audit trail for product catalog governance and regulatory compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `change_reason` STRING COMMENT 'Business justification or reason code for the most recent modification to this bundle component record, such as an Engineering Change Notice (ECN), pricing update, regulatory compliance change, or product substitution.',
    `component_type` STRING COMMENT 'Classification of the components inclusion behavior within the bundle. mandatory components are always included; optional components may be added by the customer; default_selected components are pre-selected but removable; conditional components are included only when specific configuration rules are met.. Valid values are `mandatory|optional|default_selected|conditional`',
    `configuration_group` STRING COMMENT 'Logical grouping label used to organize related optional or conditional components within a configurable bundle (e.g., Power Supply Options, Communication Modules, Safety Accessories). Supports structured presentation in CPQ and sales configurator tools.',
    `configuration_sequence` STRING COMMENT 'Display sequence number within the configuration group, controlling the order in which components are presented to sales representatives and customers during bundle configuration in CPQ or ERP sales order entry.. Valid values are `^[0-9]+$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this bundle component association record was first created in the system, recorded in ISO 8601 format with timezone offset. Used for audit trail and data lineage purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `discount_percent` DECIMAL(18,2) COMMENT 'Percentage discount applied to this components price within the bundle when pricing_method is discount_percent. Expressed as a percentage value (e.g., 15.00 for 15%).. Valid values are `^(100(.0{1,4})?|[0-9]{1,2}(.[0-9]{1,4})?)$`',
    `effective_date` DATE COMMENT 'The date from which this bundle component association becomes valid and active for sales order processing, quotation, and pricing. Supports time-phased bundle configurations and product lifecycle management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'The date after which this bundle component association is no longer valid for new sales orders or quotations. Enables time-limited bundle configurations, promotional bundles, and planned component phase-outs.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_control_flag` BOOLEAN COMMENT 'Indicates whether this bundle component is subject to export control regulations (e.g., EAR, ITAR, EU Dual-Use). When true, additional export licensing checks are required before the bundle can be sold or shipped to certain countries or end-users.. Valid values are `true|false`',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether this bundle component contains or constitutes a hazardous material requiring special handling, packaging, labeling, or shipping documentation in compliance with regulatory requirements.. Valid values are `true|false`',
    `is_separately_deliverable` BOOLEAN COMMENT 'Indicates whether this bundle component can be shipped and delivered independently from the rest of the bundle, enabling partial shipments and split delivery scenarios in logistics and order fulfillment.. Valid values are `true|false`',
    `is_separately_invoiced` BOOLEAN COMMENT 'Indicates whether this bundle component is invoiced as a separate line item on the customer invoice, as opposed to being consolidated into the bundle price. Relevant for revenue recognition and billing transparency under IFRS 15.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this bundle component association record was most recently updated, recorded in ISO 8601 format with timezone offset. Supports change tracking, delta processing in the lakehouse pipeline, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lead_time_days` STRING COMMENT 'Component-specific lead time in calendar days, representing the time required to procure or manufacture this component. May differ from the catalog items standard lead time when used in a bundle context, affecting Available to Promise (ATP) and Capable to Promise (CTP) calculations.. Valid values are `^[0-9]+$`',
    `line_number` STRING COMMENT 'Sequential line number defining the display and processing order of this component within the bundle. Used for rendering bundle configurations in sales documents, quotations, and order confirmations.. Valid values are `^[1-9][0-9]*$`',
    `maximum_quantity` DECIMAL(18,2) COMMENT 'The maximum quantity of this component that may be included when the component is selected in a configurable bundle. Enforces upper limits for optional or conditional components to prevent over-ordering.. Valid values are `^[0-9]+(.[0-9]{1,6})?$`',
    `minimum_quantity` DECIMAL(18,2) COMMENT 'The minimum quantity of this component that must be included when the component is selected in a configurable bundle. Enforces minimum order constraints for optional or conditional components.. Valid values are `^[0-9]+(.[0-9]{1,6})?$`',
    `notes` STRING COMMENT 'Free-text field for additional business notes, configuration instructions, or special handling remarks specific to this bundle component association. Used by sales, product management, and operations teams.',
    `override_price` DECIMAL(18,2) COMMENT 'Component-level price override applied when pricing_method is override_price. Supersedes the catalog list price for this component within the context of this specific bundle. Expressed in the bundles pricing currency.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `price_currency` STRING COMMENT 'ISO 4217 three-letter currency code applicable to the component override price and discount amounts within this bundle (e.g., USD, EUR, GBP, JPY, CNY).. Valid values are `^[A-Z]{3}$`',
    `pricing_method` STRING COMMENT 'Defines how this component is priced within the bundle. included means the component price is absorbed into the bundle price; component_price uses the components standalone list price; override_price applies a specific override price; discount_percent applies a percentage discount; discount_amount applies a fixed discount; free_of_charge means the component is provided at no cost.. Valid values are `included|component_price|override_price|discount_percent|discount_amount|free_of_charge`',
    `quantity` DECIMAL(18,2) COMMENT 'The quantity of this component item included in one unit of the parent bundle. Supports fractional quantities for components sold by weight, volume, or continuous measure.. Valid values are `^[0-9]+(.[0-9]{1,6})?$`',
    `reach_compliant` BOOLEAN COMMENT 'Indicates whether this bundle component complies with the EU REACH Regulation (EC) No 1907/2006 concerning the registration, evaluation, authorization, and restriction of chemical substances.. Valid values are `true|false`',
    `revenue_recognition_method` STRING COMMENT 'Specifies the revenue recognition approach for this bundle component under IFRS 15 / ASC 606. point_in_time for components delivered at a single point; over_time for components with ongoing service or subscription elements; not_applicable for components absorbed into the bundle price.. Valid values are `point_in_time|over_time|not_applicable`',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether this bundle component complies with the EU Restriction of Hazardous Substances (RoHS) Directive 2011/65/EU, restricting the use of specific hazardous materials in electrical and electronic equipment.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this bundle component record originated, supporting data lineage, reconciliation, and audit trail requirements in the Databricks Silver Layer.. Valid values are `SAP_S4HANA|TEAMCENTER_PLM|OPCENTER_MES|MANUAL|MIGRATION`',
    `source_system_key` STRING COMMENT 'The natural or surrogate key of this bundle component record in the originating source system (e.g., SAP S/4HANA condition record number, Teamcenter BOM line ID), enabling cross-system traceability and reconciliation.',
    `status` STRING COMMENT 'Current lifecycle status of this bundle component association record. active indicates the component is currently valid and in use; inactive means it has been deactivated; draft indicates it is under review; discontinued means the component has been removed from the bundle; pending_approval indicates it awaits authorization.. Valid values are `active|inactive|draft|discontinued|pending_approval`',
    `substitute_group_code` STRING COMMENT 'Code identifying the substitution group to which this component belongs. Components sharing the same substitute group code are interchangeable alternatives within the bundle configuration.. Valid values are `^[A-Z0-9_-]{1,20}$`',
    `substitution_eligible` BOOLEAN COMMENT 'Indicates whether this bundle component may be substituted with an alternative item during order fulfillment or configuration. When true, substitute components may be offered if the primary component is unavailable.. Valid values are `true|false`',
    `unit_of_measure` STRING COMMENT 'The unit of measure applicable to the component quantity within the bundle, aligned with SAP base unit of measure codes. Examples include EA (each), KG (kilogram), M (meter), KWH (kilowatt-hour).. Valid values are `EA|PC|KG|G|L|ML|M|CM|MM|M2|M3|SET|KIT|BOX|PAL|HR|MIN|KWH|MWH`',
    `warranty_months` STRING COMMENT 'Warranty period in months applicable to this specific component within the bundle. May differ from the standard product warranty when the component is sold as part of a bundle, reflecting negotiated or promotional warranty terms.. Valid values are `^[0-9]+$`',
    CONSTRAINT pk_bundle_component PRIMARY KEY(`bundle_component_id`)
) COMMENT 'Line-level association entity linking individual catalog items or SKUs to a product bundle. Captures component sequence, quantity, unit of measure, component type (mandatory, optional, default-selected), component-level pricing override, and substitution eligibility. Enables the assembly of complex solution bundles with both fixed and configurable components. The relationship between bundle and its constituent items carries its own business attributes (quantity, optionality, pricing), justifying it as a first-class entity.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`aftermarket_part` (
    `aftermarket_part_id` BIGINT COMMENT 'Unique surrogate identifier for the aftermarket part master record in the silver layer lakehouse. Serves as the primary key for all downstream joins and references.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Aftermarket parts are service/replacement versions of original engineered components. Service departments and spare parts operations require this link to ensure compatibility, interchangeability, and ',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Aftermarket parts specify which equipment catalog items theyre compatible with. Sales and service teams use this for cross-selling parts and ensuring correct part selection.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: Aftermarket parts may be developed through dedicated R&D projects for service improvements or obsolescence management. Service engineering tracks R&D origins for technical documentation and warranty a',
    `applicable_equipment_models` STRING COMMENT 'Comma-separated list or range expression of equipment model numbers for which this aftermarket part is compatible. Defines the compatibility scope used by field service engineers and customers to verify correct part selection.',
    `applicable_serial_number_range` STRING COMMENT 'Serial number range expression (e.g., SN10000-SN19999) defining the specific equipment serial numbers for which this part is compatible. Enables precise compatibility filtering when equipment models span multiple hardware revisions.',
    `base_unit_of_measure` STRING COMMENT 'The base unit in which the aftermarket part is stocked, valued, and transacted in inventory and procurement. Follows ISO unit of measure standards as implemented in SAP MM.. Valid values are `EA|KG|M|L|SET|BOX|ROLL|M2|M3`',
    `ce_marked` BOOLEAN COMMENT 'Indicates whether the aftermarket part carries the CE marking, confirming conformity with applicable EU product safety, health, and environmental protection directives. Required for sale in the European Economic Area.. Valid values are `true|false`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the aftermarket part was manufactured or substantially transformed. Required for customs declarations, import/export compliance, and trade preference programs.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the aftermarket part master record was first created in the source system or lakehouse. Used for audit trail, data lineage, and change history reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `description` STRING COMMENT 'Detailed technical and commercial description of the aftermarket part, including functional purpose, key specifications, and application context. Used in service quotes, field service documentation, and customer portals.',
    `eccn` STRING COMMENT 'US Export Administration Regulations (EAR) classification number for the aftermarket part. Determines export license requirements and restricted party screening obligations for international shipments.. Valid values are `^[0-9][A-Z][0-9]{3}[a-z]?$|^EAR99$`',
    `gross_weight_kg` DECIMAL(18,2) COMMENT 'Gross weight of the aftermarket part including packaging, in kilograms. Used for freight cost calculation, shipping documentation, and dangerous goods compliance.. Valid values are `^d{1,6}(.d{1,4})?$`',
    `harmonized_tariff_code` STRING COMMENT 'Harmonized System (HS) tariff classification code for the aftermarket part. Used for customs duty calculation, import/export declarations, and trade compliance reporting across all countries of operation.. Valid values are `^d{6,10}$`',
    `is_batch_managed` BOOLEAN COMMENT 'Indicates whether this aftermarket part is managed in inventory by production batch or lot number. Batch management enables shelf-life tracking, quality holds, and recall management at the batch level.. Valid values are `true|false`',
    `is_hazardous` BOOLEAN COMMENT 'Indicates whether the aftermarket part is classified as a hazardous material requiring special handling, storage, labeling, and shipping documentation under applicable regulations (OSHA HazCom, IATA DGR, ADR).. Valid values are `true|false`',
    `is_serialized` BOOLEAN COMMENT 'Indicates whether individual units of this aftermarket part are tracked by unique serial numbers. Serialized parts require serial number assignment at goods receipt and goods issue, enabling full traceability through the service supply chain.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the aftermarket part master record. Used for incremental data loading, change detection, and audit trail maintenance in the lakehouse silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lead_time_days` STRING COMMENT 'Standard procurement or manufacturing lead time in calendar days for the aftermarket part. Used for Available-to-Promise (ATP) calculations, service order scheduling, and safety stock determination.. Valid values are `^d{1,4}$`',
    `lifecycle_end_date` DATE COMMENT 'Date on which the aftermarket part is scheduled to be discontinued or withdrawn from the service catalog. Used for end-of-life planning, last-time-buy notifications to customers, and inventory drawdown management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `lifecycle_start_date` DATE COMMENT 'Date on which the aftermarket part became commercially available in the service catalog. Marks the beginning of the active selling period and is used for lifecycle reporting and product availability analytics.. Valid values are `^d{4}-d{2}-d{2}$`',
    `list_price` DECIMAL(18,2) COMMENT 'Standard published list price for the aftermarket part in the service and spare parts channel. This is the baseline price before any customer-specific discounts or service contract pricing is applied.. Valid values are `^d{1,14}(.d{1,4})?$`',
    `list_price_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the aftermarket part list price (e.g., USD, EUR, GBP). Supports multi-currency pricing for global aftermarket operations.. Valid values are `^[A-Z]{3}$`',
    `material_group` STRING COMMENT 'SAP material group code classifying the aftermarket part for procurement, spend analytics, and reporting purposes. Aligns with the MM module material group hierarchy.',
    `mean_time_between_replacements_hours` DECIMAL(18,2) COMMENT 'Average operating hours between required replacements for this part, derived from Mean Time Between Failures (MTBF) analysis. Used to drive preventive maintenance scheduling, spare parts demand forecasting, and service interval recommendations.. Valid values are `^d{1,7}(.d{1,2})?$`',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity of the aftermarket part that must be ordered per transaction in the service channel. Reflects packaging constraints, supplier minimums, or commercial policy for the aftermarket business.. Valid values are `^d{1,7}(.d{1,3})?$`',
    `name` STRING COMMENT 'Short commercial name or title of the aftermarket part as presented in the service catalog and customer-facing documentation.',
    `part_number` STRING COMMENT 'The unique commercial part number assigned to this aftermarket item in the service and spare parts catalog. Used for ordering, quoting, and logistics identification across the aftermarket channel.. Valid values are `^[A-Z0-9-.]{3,40}$`',
    `part_type` STRING COMMENT 'Classification of the aftermarket part by its commercial and functional role in the service channel. OEM spare parts are original manufacturer replacements; consumables are regularly depleted items; wear parts have predictable degradation cycles; repair kits bundle components for a specific repair task; exchange units are refurbished assemblies; upgrade kits extend or enhance equipment capability.. Valid values are `oem_spare|consumable|wear_part|repair_kit|exchange_unit|upgrade_kit`',
    `reach_compliant` BOOLEAN COMMENT 'Indicates whether the aftermarket part complies with EU REACH Regulation (EC) No 1907/2006 regarding chemical substance registration, evaluation, and authorization. Required for EU market access and supply chain chemical transparency.. Valid values are `true|false`',
    `replacement_interval_unit` STRING COMMENT 'Unit of measure for the mean time between replacements value. Supports multiple interval bases including operating hours, production cycles, calendar months, years, or distance (km) depending on the equipment type.. Valid values are `hours|cycles|months|years|km`',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether the aftermarket part complies with EU RoHS Directive 2011/65/EU restricting the use of hazardous substances (lead, mercury, cadmium, etc.) in electrical and electronic equipment. Required for CE marking and EU market access.. Valid values are `true|false`',
    `service_channel` STRING COMMENT 'The commercial channel through which this aftermarket part is sold and distributed. Distinguishes direct service (sold by manufacturer service team), distributor (sold through authorized service partners), ecommerce (online self-service), field service (delivered by field engineers), and depot repair (used in repair center operations).. Valid values are `direct_service|distributor|ecommerce|field_service|depot_repair`',
    `shelf_life_days` STRING COMMENT 'Maximum number of days the aftermarket part can be stored before it is no longer suitable for use. Applicable to consumables, lubricants, adhesives, and other time-sensitive materials. Drives FEFO (First Expired First Out) inventory management.. Valid values are `^d{1,5}$`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this aftermarket part master record was sourced. Supports data lineage tracking and reconciliation in the lakehouse silver layer.. Valid values are `SAP_S4HANA|TEAMCENTER|MAXIMO|SALESFORCE|MANUAL`',
    `source_system_key` STRING COMMENT 'The natural key or primary identifier of this aftermarket part record in the originating source system (e.g., SAP material number, Maximo item number). Enables traceability back to the system of record for reconciliation and audit purposes.',
    `standard_cost` DECIMAL(18,2) COMMENT 'Standard cost of the aftermarket part used for inventory valuation, cost of goods sold (COGS) calculation, and service margin analysis. Maintained in SAP CO and updated during standard cost runs.. Valid values are `^d{1,14}(.d{1,4})?$`',
    `standard_cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the standard cost value of the aftermarket part.. Valid values are `^[A-Z]{3}$`',
    `status` STRING COMMENT 'Current lifecycle status of the aftermarket part in the commercial catalog. Active parts are available for ordering; phase_out parts are being withdrawn; discontinued parts are no longer supplied; superseded parts have been replaced by a newer part number; development parts are not yet released for sale; blocked parts are temporarily unavailable.. Valid values are `active|phase_out|discontinued|superseded|development|blocked`',
    `stocking_classification` STRING COMMENT 'Inventory stocking strategy classification for the aftermarket part. Critical spares are held at all times to prevent unplanned downtime; standard parts follow normal replenishment cycles; non-stock parts are procured on demand; consignment parts are held at customer sites; slow-moving parts have low demand frequency.. Valid values are `critical_spare|standard|non_stock|consignment|slow_moving`',
    `superseded_by_date` DATE COMMENT 'The effective date on which this part was superseded by the replacement part number. Used to manage transition periods in field service, spare parts ordering, and inventory drawdown.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ul_listed` BOOLEAN COMMENT 'Indicates whether the aftermarket part has been tested and listed by Underwriters Laboratories (UL) for product safety compliance. Required for North American market access in electrical and industrial applications.. Valid values are `true|false`',
    `unspsc_code` STRING COMMENT 'Eight-digit UNSPSC code classifying the aftermarket part within the global product and services taxonomy. Used for procurement categorization, spend analysis, and cross-supplier benchmarking.. Valid values are `^d{8}$`',
    `warranty_period_months` STRING COMMENT 'Standard warranty period in months offered for this aftermarket part from the date of installation or delivery. Defines the manufacturers obligation for defect-free performance and drives warranty cost provisioning.. Valid values are `^d{1,3}$`',
    CONSTRAINT pk_aftermarket_part PRIMARY KEY(`aftermarket_part_id`)
) COMMENT 'Master record for spare parts, replacement components, and MRO items offered through the aftermarket and service channel. Captures aftermarket part number, description, part type (OEM spare, consumable, wear part, repair kit), compatibility scope (applicable equipment models and serial number ranges), supersession chain, average replacement interval (MTBF-based), and stocking classification (critical spare, standard, non-stock). Distinct from the main catalog_item as aftermarket parts follow a separate commercial and logistics channel.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`sales_org` (
    `sales_org_id` BIGINT COMMENT 'Unique surrogate identifier for the product-to-sales organization assignment record in the Silver Layer lakehouse. Serves as the primary key for this association entity.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: product_sales_org defines which catalog items are authorized for sale within specific sales organizations. material_number is a STRING reference to catalog_item.material_number. Adding catalog_item_id',
    `hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.product_hierarchy. Business justification: product_sales_org.product_hierarchy_code is a STRING reference to the product hierarchy node for sales organization assignments. Adding product_hierarchy_id FK normalizes this reference. product_hiera',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: Products sold through sales organizations must be tied to legal entities for revenue recognition, tax compliance, and financial reporting. Finance teams use this daily for consolidation and statutory ',
    `account_assignment_group` STRING COMMENT 'SAP SD account assignment group for the material, used in revenue account determination to map product revenue postings to the correct General Ledger (GL) accounts. Critical for financial reporting and revenue recognition.. Valid values are `^[A-Z0-9]{1,2}$`',
    `authorization_group` STRING COMMENT 'SAP authorization group restricting which user roles and organizational units can view or modify the sales organization data for this product. Supports role-based access control for sensitive commercial data.. Valid values are `^[A-Z0-9]{1,4}$`',
    `availability_check_rule` STRING COMMENT 'SAP SD availability check group code controlling how Available-to-Promise (ATP) and Capable-to-Promise (CTP) checks are performed for this product in the sales organization. Determines whether stock, planned orders, or production capacity are considered.. Valid values are `^[A-Z0-9]{1,2}$`',
    `cash_discount_indicator` BOOLEAN COMMENT 'Indicates whether the product is eligible for cash discount terms (e.g., early payment discounts) within this sales organization assignment. When true, cash discount conditions are applied during invoice processing.. Valid values are `true|false`',
    `code` STRING COMMENT 'SAP SD sales organization code representing the legal selling entity or regional sales unit responsible for the sale of the product. Defines the top-level commercial structure under which the product is authorized for sale.. Valid values are `^[A-Z0-9]{1,4}$`',
    `commission_group` STRING COMMENT 'SAP SD commission group code used to classify the product for sales commission calculation and incentive compensation management within the sales organization.. Valid values are `^[A-Z0-9]{1,2}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary market or geography associated with this sales organization assignment. Used for regional reporting, regulatory compliance scoping, and export control checks.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the product-sales organization assignment record was first created in the source system or data platform. Used for audit trail, data lineage, and change history reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `cross_selling_material` STRING COMMENT 'SAP material number of a complementary product recommended for cross-selling alongside this product within the sales organization. Supports guided selling and upsell/cross-sell analytics in CRM and order management.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `delivering_plant_code` STRING COMMENT 'Default manufacturing or warehouse plant assigned to fulfill orders for this product within the sales organization. Used in Available-to-Promise (ATP) checks and delivery scheduling. Can be overridden at order line level.. Valid values are `^[A-Z0-9]{1,4}$`',
    `distribution_channel_code` STRING COMMENT 'SAP SD distribution channel code indicating the route through which the product reaches the customer (e.g., direct sales, wholesale, e-commerce, dealer network). Part of the Org/DC/Div assignment key.. Valid values are `^[A-Z0-9]{1,2}$`',
    `division_code` STRING COMMENT 'SAP SD division code grouping products into business lines or product families for sales reporting and organizational assignment (e.g., automation systems, electrification, smart infrastructure). Completes the Org/DC/Div assignment key.. Valid values are `^[A-Z0-9]{1,2}$`',
    `export_control_flag` BOOLEAN COMMENT 'Indicates whether the product is subject to export control regulations (e.g., EAR, ITAR, EU Dual-Use) when sold through this sales organization. When true, additional export license checks are required before order fulfillment.. Valid values are `true|false`',
    `general_item_category_group` STRING COMMENT 'SAP SD general item category group from the material master basic data, used alongside the sales-org-specific item category group for item category determination in sales documents. Distinguishes standard goods, services, configurable products, and third-party items.. Valid values are `^[A-Z0-9]{1,4}$`',
    `item_category_group` STRING COMMENT 'SAP SD item category group assigned to the product for this sales org, controlling how the item behaves in sales order processing (e.g., standard item, configurable item, service item, third-party item). Drives item category determination in order management.. Valid values are `^[A-Z0-9]{1,4}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the product-sales organization assignment record. Used for incremental data loading, change detection, and audit compliance in the Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `loading_group` STRING COMMENT 'SAP SD loading group code classifying the product by its physical handling and loading requirements (e.g., crane required, forklift, manual). Used in shipping point and route determination for logistics planning.. Valid values are `^[A-Z0-9]{1,4}$`',
    `material_statistics_group` STRING COMMENT 'SAP SD material statistics group controlling whether sales transactions for this product are included in the Logistics Information System (LIS) and sales reporting statistics. Governs data collection for demand planning and sales analytics.. Valid values are `^[A-Z0-9]{1}$`',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity of the product that must be ordered in a single sales order line for this sales organization and distribution channel. Enforced during order entry to meet commercial or production efficiency thresholds.. Valid values are `^d+(.d{1,4})?$`',
    `minimum_order_value` DECIMAL(18,2) COMMENT 'Minimum monetary value of a sales order line for this product within the sales organization. Orders below this threshold may be rejected or subject to surcharges. Expressed in the sales organizations currency.. Valid values are `^d+(.d{1,2})?$`',
    `minimum_order_value_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the minimum order value field, reflecting the transactional currency of the sales organization (e.g., USD, EUR, GBP, CNY).. Valid values are `^[A-Z]{3}$`',
    `planned_end_of_sale_date` DATE COMMENT 'Planned date on which the product will cease to be available for new orders in this sales organization. Used for commercial lifecycle planning, customer notification, and inventory wind-down coordination.. Valid values are `^d{4}-d{2}-d{2}$`',
    `pricing_reference_material` STRING COMMENT 'SAP material number of a reference product whose pricing conditions are used as the basis for pricing this product in the sales organization. Enables pricing inheritance for product variants or successor materials.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `sales_blocking_reason` STRING COMMENT 'Reason code explaining why the product is blocked for sale in this sales organization. Populated when sales_status is blocked or restricted. Supports root cause analysis and unblocking workflows.. Valid values are `regulatory_hold|quality_hold|commercial_decision|end_of_life|supplier_issue|compliance_review|other`',
    `sales_status` STRING COMMENT 'Current commercial availability status of the product within the assigned sales organization and channel. Controls whether the product can be included in sales orders. Blocked prevents new orders; phasing_out signals end-of-sale transition; pending_activation indicates awaiting commercial launch approval.. Valid values are `active|blocked|phasing_out|discontinued|pending_activation|restricted`',
    `sales_status_effective_date` DATE COMMENT 'Date from which the current sales status is effective for this product-sales org assignment. Used to track status transitions and support time-based commercial availability reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sales_unit_of_measure` STRING COMMENT 'Unit of measure in which the product is sold within this sales organization (e.g., EA for each, PC for piece, KG for kilogram, SET for set). May differ from the base unit of measure defined in the material master.. Valid values are `^[A-Z0-9]{1,3}$`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this product-sales org assignment record originated. Supports data lineage tracking and reconciliation in the Silver Layer lakehouse.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|MIGRATION|OTHER`',
    `source_system_key` STRING COMMENT 'Natural key or composite key from the source system uniquely identifying this record (e.g., SAP composite key: MATNR+VKORG+VTWEG+SPART). Enables traceability back to the originating system record for audit and reconciliation.',
    `tax_classification_code` STRING COMMENT 'SAP SD tax classification code for the product within the sales organization, used in tax condition determination to apply the correct VAT, GST, or sales tax rates. Varies by country and product type (e.g., 0=exempt, 1=full tax, 2=reduced rate).. Valid values are `^[0-9]{1}$`',
    `transportation_group` STRING COMMENT 'SAP SD transportation group code classifying the product by its transportation requirements and constraints (e.g., hazardous goods, oversized, temperature-controlled). Used in route determination and freight cost calculation.. Valid values are `^[A-Z0-9]{1,4}$`',
    `volume_rebate_group` STRING COMMENT 'SAP SD rebate group code classifying the product for volume-based rebate agreement processing within the sales organization. Products in the same rebate group are aggregated for rebate accrual and settlement calculations.. Valid values are `^[A-Z0-9]{1,2}$`',
    `valid_from` DATE COMMENT 'Date from which the product is authorized for sale within the sales organization, distribution channel, and division. Defines the start of the commercial validity window for this assignment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to` DATE COMMENT 'Date until which the product is authorized for sale within the sales organization, distribution channel, and division. After this date, the product is no longer orderable in this commercial channel. Supports end-of-sale planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_sales_org PRIMARY KEY(`sales_org_id`)
) COMMENT 'Association entity defining which catalog items and SKUs are authorized for sale within specific sales organizations, distribution channels, and divisions — the SAP SD sales org/distribution channel/division (Org/DC/Div) assignment. Captures sales status (active, blocked, phasing-out), minimum order value, delivery plant assignment, item category group, and account assignment group. Governs which products are orderable in which commercial channels and geographies.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`product_plant` (
    `product_plant_id` BIGINT COMMENT 'Unique surrogate identifier for each product-plant combination record in the Silver Layer lakehouse. Serves as the primary key for this entity.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: product_plant defines manufacturing and storage plant-level attributes for each catalog item. material_number is a STRING reference to catalog_item.material_number. Adding catalog_item_id FK normalize',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Manufacturing plants operate as cost centers for production overhead allocation. Controllers use this to track manufacturing costs, variances, and departmental budgets in plant operations.',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: Product-plant relationships define which catalog items can be manufactured at which production plants. Master data management maintains these assignments for production planning and order allocation.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Plants are evaluated as profit centers for P&L accountability. Management accounting uses this for segment reporting, profitability analysis, and performance measurement of manufacturing locations.',
    `abc_indicator` STRING COMMENT 'ABC classification of this material at the plant based on consumption value or strategic importance. A=High value/critical, B=Medium, C=Low value. Used for inventory prioritization and cycle counting. Corresponds to the ABCIN field in SAP MM Plant Data view.. Valid values are `A|B|C`',
    `batch_management_required` BOOLEAN COMMENT 'Indicates whether batch management is activated for this material at this plant, enabling traceability of production batches for quality and regulatory compliance. Corresponds to the XCHPF field in SAP MM Plant Data view.. Valid values are `true|false`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this product-plant record was first created in the source system. Supports audit trail and data lineage requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the plant-level material valuation prices (standard price, moving average price). Supports multi-currency operations across global manufacturing plants.. Valid values are `^[A-Z]{3}$`',
    `fixed_lot_size` DECIMAL(18,2) COMMENT 'The fixed order quantity used when the lot sizing procedure is set to Fixed Lot Size (FX). MRP will always propose this quantity regardless of actual requirements. Corresponds to the BSTFE field in SAP MM MRP 1 view.. Valid values are `^d+(.d{1,3})?$`',
    `goods_receipt_processing_time_days` STRING COMMENT 'The number of working days required to inspect and process a goods receipt for this material at the plant after delivery. Added to lead time in MRP scheduling. Corresponds to the WEBAZ field in SAP MM MRP 2 view.. Valid values are `^d{1,3}$`',
    `hazardous_material_number` STRING COMMENT 'Reference number linking this material to its hazardous substance classification record at the plant. Required for materials subject to REACH, RoHS, or OSHA hazardous material regulations.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `in_house_production_time_days` STRING COMMENT 'The number of working days required to produce this material in-house at the plant. Used by MRP to calculate production order start dates. Corresponds to the DZEIT field in SAP MM MRP 2 view.. Valid values are `^d{1,4}$`',
    `issue_storage_location` STRING COMMENT 'The default storage location from which components are issued to production orders at this plant. Corresponds to the LGFSB field in SAP MM MRP 4 view.. Valid values are `^[A-Z0-9]{4}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this product-plant record was last updated in the source system. Used for incremental data loading and change detection in the lakehouse pipeline.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lot_sizing_procedure` STRING COMMENT 'Defines the lot sizing rule used by MRP to calculate order quantities for this material at the plant (e.g., EX=Exact Lot Size, FX=Fixed Lot Size, HB=Replenish to Maximum Stock Level). Corresponds to the DISLS field in SAP MM MRP 1 view.. Valid values are `EX|FX|HB|MB|PK|TB|WB|ZB|LS|SP|FP|ZL`',
    `maximum_lot_size` DECIMAL(18,2) COMMENT 'The maximum order quantity that MRP will propose for this material at the plant. Caps production or procurement orders to prevent overproduction or storage capacity breaches. Corresponds to the BSTMA field in SAP MM MRP 1 view.. Valid values are `^d+(.d{1,3})?$`',
    `minimum_lot_size` DECIMAL(18,2) COMMENT 'The minimum order quantity that MRP will propose for this material at the plant. Ensures production or procurement orders are not placed below an economically viable threshold. Corresponds to the BSTMI field in SAP MM MRP 1 view.. Valid values are `^d+(.d{1,3})?$`',
    `moving_average_price` DECIMAL(18,2) COMMENT 'The current weighted moving average cost per base unit of measure for this material at the plant, recalculated with each goods receipt when price control is set to Moving Average Price (V). Corresponds to the VERPR field in SAP MM Accounting view.. Valid values are `^d+(.d{1,4})?$`',
    `mrp_controller` STRING COMMENT 'Three-character code identifying the MRP controller (planner) responsible for planning this material at the plant. Corresponds to the DISPO field in SAP MM MRP 1 view.. Valid values are `^[A-Z0-9]{1,3}$`',
    `mrp_type` STRING COMMENT 'Defines the MRP procedure used to plan this material at the plant. Common values include PD (MRP), VB (Reorder Point), VM (Automatic Reorder Point), ND (No Planning). Corresponds to the DISMM field in SAP MM MRP 1 view.. Valid values are `PD|VB|VM|MK|MN|ND|X0|R1|S1|Z1`',
    `planned_delivery_time_days` STRING COMMENT 'The number of calendar days required to procure or externally source this material at the plant. Used by MRP to calculate order start dates for externally procured materials. Corresponds to the PLIFZ field in SAP MM MRP 2 view.. Valid values are `^d{1,4}$`',
    `price_control` STRING COMMENT 'Defines the inventory valuation method for this material at the plant. S=Standard Price (fixed standard cost), V=Moving Average Price (weighted average). Corresponds to the VPRSV field in SAP MM Accounting view.. Valid values are `S|V`',
    `price_unit` DECIMAL(18,2) COMMENT 'The quantity unit to which the standard or moving average price applies (e.g., price per 1 unit, per 100 units, per 1000 units). Corresponds to the PEINH field in SAP MM Accounting view.. Valid values are `^d+(.d{1,3})?$`',
    `procurement_type` STRING COMMENT 'Defines whether the material is produced in-house (E), externally procured (F), or both (X) at this plant. Drives MRP planning logic and sourcing decisions. Corresponds to the BESKZ field in SAP MM MRP 2 view.. Valid values are `E|F|X`',
    `production_scheduler` STRING COMMENT 'Three-character code identifying the production scheduler responsible for managing production orders for this material at the plant. Corresponds to the FEVOR field in SAP MM MRP 4 view.. Valid values are `^[A-Z0-9]{1,3}$`',
    `production_storage_location` STRING COMMENT 'The default storage location within the plant where finished goods or semi-finished materials are placed after production. Corresponds to the LGPRO field in SAP MM MRP 4 view.. Valid values are `^[A-Z0-9]{4}$`',
    `profit_center` STRING COMMENT 'The profit center assigned to this material at the plant for management accounting and profitability analysis. Drives cost allocation and financial reporting by business segment. Corresponds to the PRCTR field in SAP MM Accounting view.. Valid values are `^[A-Z0-9]{1,10}$`',
    `quality_inspection_setup` STRING COMMENT 'Two-digit code defining the quality inspection type activated for this material at the plant (e.g., goods receipt inspection, in-process inspection, final inspection). Corresponds to the QMATA field in SAP MM QM view.. Valid values are `^[0-9]{2}$`',
    `reorder_point` DECIMAL(18,2) COMMENT 'The stock level at which a replenishment order is triggered for this material at the plant when using reorder point planning (MRP type VB). Corresponds to the MINBE field in SAP MM MRP 1 view.. Valid values are `^d+(.d{1,3})?$`',
    `safety_stock` DECIMAL(18,2) COMMENT 'The minimum buffer stock quantity maintained at the plant to protect against demand variability and supply disruptions. MRP triggers replenishment when stock falls to this level. Corresponds to the EISBE field in SAP MM MRP 2 view.. Valid values are `^d+(.d{1,3})?$`',
    `serial_number_profile` STRING COMMENT 'Profile code defining when and how serial numbers are assigned to units of this material at the plant (e.g., at goods receipt, goods issue, or delivery). Supports asset traceability and after-sales service. Corresponds to the SERAIL field in SAP MM Plant Data view.. Valid values are `^[A-Z0-9]{1,4}$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this product-plant record was sourced (e.g., SAP S/4HANA MM). Supports data lineage and audit traceability in the lakehouse.. Valid values are `SAP_S4HANA|TEAMCENTER|OPCENTER|LEGACY`',
    `source_system_key` STRING COMMENT 'The natural composite key from the source system uniquely identifying this product-plant record (typically MATNR + WERKS from SAP MM). Enables reconciliation and delta processing between source and lakehouse.',
    `special_procurement_type` STRING COMMENT 'Two-digit code specifying a special procurement scenario such as consignment, subcontracting, stock transfer, or phantom assembly. Complements the standard procurement type. Corresponds to the SOBSL field in SAP MM MRP 2 view.. Valid values are `^[0-9]{2}$`',
    `specific_material_status_valid_from` DATE COMMENT 'The date from which the plant-specific material status becomes effective. Enables time-phased status transitions for production planning and procurement control. Corresponds to the MMSTD field in SAP MM Plant Data view.. Valid values are `^d{4}-d{2}-d{2}$`',
    `standard_price` DECIMAL(18,2) COMMENT 'The standard cost per base unit of measure for this material at the plant, used for inventory valuation when price control is set to Standard Price (S). Corresponds to the STPRS field in SAP MM Accounting view.. Valid values are `^d+(.d{1,4})?$`',
    `status` STRING COMMENT 'Current operational status of the material at this plant. Drives whether the material can be procured, produced, or issued at this location. Corresponds to the MMSTA (Plant-Specific Material Status) field in SAP MM.. Valid values are `active|inactive|blocked|in_review|discontinued`',
    `storage_conditions` STRING COMMENT 'Two-digit code defining the required storage conditions for this material at the plant (e.g., temperature-controlled, humidity-controlled, hazardous material storage). Corresponds to the LGBKZ field in SAP MM Plant Data/Storage view.. Valid values are `^[0-9]{2}$`',
    `temperature_conditions_indicator` STRING COMMENT 'Indicator specifying the temperature range or climate class required for storing this material at the plant. Critical for electrification components and chemical materials. Corresponds to the MHDRZ field in SAP MM Plant Data/Storage view.. Valid values are `^[A-Z0-9]{2}$`',
    `valuation_class` STRING COMMENT 'Four-digit code that determines the general ledger accounts updated when inventory movements occur for this material at the plant. Links material master to financial accounting. Corresponds to the BKLAS field in SAP MM Accounting view.. Valid values are `^[0-9]{4}$`',
    CONSTRAINT pk_product_plant PRIMARY KEY(`product_plant_id`)
) COMMENT 'Defines the manufacturing and storage plant-level attributes for each catalog item — capturing the producing plant, MRP type, MRP controller, lot sizing procedure, safety stock level, reorder point, planned delivery time, in-house production time, and storage conditions. This is the SAP MM plant-level material master view, governing how each product is planned, produced, and stored at each manufacturing facility. Essential for MRP/MRP II planning and production scheduling.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`uom` (
    `uom_id` BIGINT COMMENT 'Unique surrogate identifier for each unit of measure assignment record for a catalog item. Serves as the primary key for the product_uom entity in the Silver Layer lakehouse.',
    `change_notice_id` BIGINT COMMENT 'Foreign key linking to product.product_change_notice. Business justification: product_uom.ecn_reference is a STRING reference to the Engineering Change Notice that triggered a UoM change (e.g., packaging change). Adding product_change_notice_id FK normalizes this relationship. ',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: product_uom defines all valid units of measure for a SKU. sku_code is a STRING reference to the parent sku. Adding sku_id FK normalizes this parent-child relationship and enables referential integrity',
    `code` STRING COMMENT 'The standardized unit of measure code as defined by ISO 80000 and aligned with SAP S/4HANA internal UoM codes (e.g., EA, KG, L, M, PC, ST, PAL, CTN). Identifies the specific unit used for this UoM assignment.. Valid values are `^[A-Z0-9]{1,6}$`',
    `conversion_denominator` DECIMAL(18,2) COMMENT 'The denominator of the conversion factor from this UoM to the base UoM. Together with the numerator, defines the ratio: (numerator / denominator) units of this UoM = 1 base UoM unit. Aligned with SAP S/4HANA MARM-UMREN field.. Valid values are `^[0-9]+(.[0-9]{1,6})?$`',
    `conversion_factor` DECIMAL(18,2) COMMENT 'The pre-computed decimal conversion factor (numerator / denominator) representing how many base UoM units are equivalent to one unit of this UoM. Stored for query performance and reporting convenience. Example: 1 PAL = 48 EA → conversion_factor = 48.000000.. Valid values are `^[0-9]+(.[0-9]{1,6})?$`',
    `conversion_numerator` DECIMAL(18,2) COMMENT 'The numerator of the conversion factor from this UoM to the base UoM. Together with the denominator, defines the ratio: (numerator / denominator) units of this UoM = 1 base UoM unit. Aligned with SAP S/4HANA MARM-UMREZ field.. Valid values are `^[0-9]+(.[0-9]{1,6})?$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this UoM assignment record was first created in the source system or lakehouse. Used for audit trail, data lineage, and change history reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `description` STRING COMMENT 'Human-readable description of the unit of measure (e.g., Each, Kilogram, Liter, Pallet, Carton). Supports display in user interfaces, reports, and order documents.',
    `ean_upc_code` STRING COMMENT 'The EAN or UPC barcode associated with this UoM packaging level. Used for point-of-sale scanning, warehouse receiving, and inventory tracking. Aligned with SAP S/4HANA MARM-EAN11 and GS1 standards.. Valid values are `^[0-9]{8,14}$`',
    `effective_date` DATE COMMENT 'The date from which this UoM assignment and its conversion factors are valid and applicable for transactions. Supports time-bound UoM configurations and change management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'The date after which this UoM assignment is no longer valid for use in transactions. Supports planned UoM transitions and packaging changes without disrupting historical records.. Valid values are `^d{4}-d{2}-d{2}$`',
    `global_trade_item_number` STRING COMMENT 'The GS1-standard Global Trade Item Number (GTIN) associated with this specific UoM packaging level (e.g., GTIN-8 for inner pack, GTIN-13 for case, GTIN-14 for pallet). Enables barcode scanning, EDI transactions, and retail/logistics interoperability.. Valid values are `^[0-9]{8,14}$`',
    `gross_weight_kg` DECIMAL(18,2) COMMENT 'The gross weight of one unit in this UoM, expressed in kilograms. Used for freight calculation, shipping documentation, and hazardous material compliance. Aligned with SAP S/4HANA MARM-BRGEW.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `height_mm` DECIMAL(18,2) COMMENT 'The height dimension of one unit in this UoM, expressed in millimeters. Used for packaging design, storage slot assignment, and transportation planning.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `is_base_uom` BOOLEAN COMMENT 'Indicates whether this UoM is the base unit of measure for the catalog item. The base UoM is the reference unit to which all other UoM conversions are anchored. Only one UoM per SKU may be the base UoM.. Valid values are `true|false`',
    `is_delivery_uom` BOOLEAN COMMENT 'Indicates whether this UoM is the delivery unit of measure used in outbound deliveries and shipping documents. Supports logistics and warehouse management processes.. Valid values are `true|false`',
    `is_order_uom` BOOLEAN COMMENT 'Indicates whether this UoM is the order unit of measure used in purchase orders and procurement transactions. Corresponds to the SAP S/4HANA purchase order unit (BESTELLEINHEIT).. Valid values are `true|false`',
    `is_production_uom` BOOLEAN COMMENT 'Indicates whether this UoM is used in production orders and manufacturing execution. Supports Bill of Materials (BOM) and production planning processes in SAP PP and Siemens Opcenter MES.. Valid values are `true|false`',
    `is_sales_uom` BOOLEAN COMMENT 'Indicates whether this UoM is the sales unit of measure used in customer orders, quotations, and invoices. Corresponds to the SAP S/4HANA sales unit (VRKME).. Valid values are `true|false`',
    `is_storage_uom` BOOLEAN COMMENT 'Indicates whether this UoM is the storage unit of measure used in warehouse and inventory management. Determines how stock is tracked and managed in the warehouse management system.. Valid values are `true|false`',
    `iso_code` STRING COMMENT 'The ISO 80000-compliant international unit of measure code (e.g., KGM for kilogram, LTR for litre, MTR for metre, PCE for piece). Used for EDI, cross-system interoperability, and regulatory reporting.. Valid values are `^[A-Z0-9]{1,3}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this UoM assignment record was most recently updated in the source system or lakehouse. Supports incremental data loading, change detection, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `length_mm` DECIMAL(18,2) COMMENT 'The length dimension of one unit in this UoM, expressed in millimeters. Used for packaging design, storage slot assignment, and transportation planning.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `maximum_stack_height` STRING COMMENT 'The maximum number of units of this UoM that can be stacked on top of each other during storage or transportation. Used for warehouse slot planning and load safety compliance.. Valid values are `^[0-9]+$`',
    `min_order_quantity` DECIMAL(18,2) COMMENT 'The minimum quantity in this UoM that can be ordered in a single purchase or sales transaction. Enforced during order entry to ensure supplier and production efficiency requirements are met.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `net_weight_kg` DECIMAL(18,2) COMMENT 'The net weight of one unit in this UoM, expressed in kilograms, excluding packaging. Used for product content weight declarations, customs documentation, and regulatory compliance.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `packaging_type` STRING COMMENT 'Describes the physical packaging form associated with this UoM (e.g., each, inner pack, case, carton, pallet). Supports warehouse operations, shipping documentation, and customer order fulfillment.. Valid values are `each|inner_pack|case|carton|pallet|drum|bag|reel|tube|box|bundle|set`',
    `quantity_per_package` DECIMAL(18,2) COMMENT 'The number of base units contained within one unit of this UoM packaging level (e.g., 12 EA per case, 48 cases per pallet). Supports packaging hierarchy navigation and order quantity validation.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `rounding_value` DECIMAL(18,2) COMMENT 'The rounding quantity in this UoM to which order quantities are rounded up during Material Requirements Planning (MRP) and procurement. Ensures order quantities align with packaging multiples.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this UoM assignment record originated. Supports data lineage, reconciliation, and audit traceability in the lakehouse Silver Layer.. Valid values are `SAP_S4HANA|TEAMCENTER|OPCENTER|MANUAL|MIGRATION`',
    `source_system_key` STRING COMMENT 'The natural key or composite key from the originating source system that uniquely identifies this UoM assignment record (e.g., SAP MARM key: MATNR + MEINH). Enables reconciliation between the lakehouse and source systems.',
    `status` STRING COMMENT 'The current operational status of this UoM assignment for the catalog item. Controls whether the UoM is available for use in transactions. active = in use; inactive = temporarily disabled; obsolete = retired; pending_review = under change review.. Valid values are `active|inactive|obsolete|pending_review`',
    `type` STRING COMMENT 'Classifies the business role of this UoM assignment for the catalog item. Determines how the UoM is used across procurement, production, sales, delivery, and storage processes. Aligned with SAP S/4HANA UoM usage categories.. Valid values are `base|order|sales|delivery|storage|production|invoice|weight|volume`',
    `variable_order_unit_allowed` BOOLEAN COMMENT 'Indicates whether the order unit of measure can be changed at the time of order entry, allowing flexibility in procurement and sales transactions. Aligned with SAP S/4HANA variable order unit configuration.. Valid values are `true|false`',
    `volume_m3` DECIMAL(18,2) COMMENT 'The volume of one unit in this UoM, expressed in cubic meters. Used for warehouse space planning, container loading optimization, and freight volume calculations. Aligned with SAP S/4HANA MARM-VOLUM.. Valid values are `^[0-9]+(.[0-9]{1,6})?$`',
    `width_mm` DECIMAL(18,2) COMMENT 'The width dimension of one unit in this UoM, expressed in millimeters. Used for packaging design, storage slot assignment, and transportation planning.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    CONSTRAINT pk_uom PRIMARY KEY(`uom_id`)
) COMMENT 'Defines all valid units of measure (UoM) for a catalog item and the conversion factors between them — base unit, order unit, sales unit, delivery unit, and storage unit. Captures the UoM code (ISO 80000), conversion numerator and denominator, and whether the UoM is the base, order, or sales unit. Supports multi-UoM transactions across procurement, production, sales, and logistics. Aligned with SAP S/4HANA UoM conversion configuration.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`classification` (
    `classification_id` BIGINT COMMENT 'Unique surrogate identifier for each product classification assignment record in the Databricks Silver Layer catalog.',
    `characteristic_code` STRING COMMENT 'System-defined code for the characteristic within the classification standard (e.g., eCl@ss property IRDI 0173-1#02-AAB329#007 for Rated Voltage). Enables machine-readable attribute exchange in EDI and punchout catalog integrations.',
    `characteristic_data_type` STRING COMMENT 'Data type of the characteristic value as defined by the classification system (e.g., numeric, string, boolean, coded_value, range, date). Enables correct parsing and validation of characteristic values during EDI exchange and catalog integration.. Valid values are `numeric|string|boolean|coded_value|range|date`',
    `characteristic_name` STRING COMMENT 'Name of the technical characteristic or attribute defined by the classification system for this class (e.g., Rated Voltage, IP Protection Class, Power Rating, Rated Current). Each classification record captures one characteristic key-value pair per the classification systems feature catalog.',
    `characteristic_unit` STRING COMMENT 'Unit of measure associated with the characteristic value (e.g., V for voltage, kW for power, A for current, Hz for frequency). Follows SI units as defined by the classification standard. Null for non-numeric or coded characteristics.',
    `characteristic_value` STRING COMMENT 'The assigned value for the classification characteristic (e.g., 400V for Rated Voltage, IP65 for IP Protection Class, 11kW for Power Rating). Stored as STRING to accommodate numeric, coded, and free-text values across all classification systems.',
    `class_code` STRING COMMENT 'The specific class or commodity code assigned to the product within the classification system (e.g., eCl@ss class code 27-37-10-01 for circuit breakers, UNSPSC code 39121000 for power distribution equipment). Used for structured product search and cross-catalog comparison.',
    `class_name` STRING COMMENT 'Human-readable name or label of the assigned classification class (e.g., Circuit Breaker, Power Distribution Equipment). Supports product search, catalog display, and reporting without requiring lookup of the class code.',
    `commodity_code` STRING COMMENT 'Third-level commodity code within the classification hierarchy (e.g., UNSPSC commodity 391210 for Circuit Breakers). Provides granular product categorization for procurement sourcing, supplier management via SAP Ariba, and spend analytics.',
    `confidence_score` DECIMAL(18,2) COMMENT 'Confidence percentage (0.00–100.00) associated with the classification assignment, particularly relevant for automated or AI-assisted classifications. Enables quality filtering and prioritization of manual review for low-confidence assignments. Null for fully manual classifications.. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country for which this classification is applicable when classification_scope is country. Supports country-specific regulatory classification requirements (e.g., CE marking classification in EU countries, UL classification in USA).. Valid values are `[A-Z]{3}`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this classification record was first created in the system. Provides the foundational audit trail entry for the classification assignment lifecycle.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}`',
    `date` DATE COMMENT 'Date on which the product was assigned to this classification class and characteristics were captured. Used for audit trails, regulatory compliance reporting, and tracking classification currency against evolving standards.. Valid values are `d{4}-d{2}-d{2}`',
    `eclass_code` STRING COMMENT 'eCl@ss classification code assigned to the product in the format XX-XX-XX-XX (e.g., 27-37-10-01 for Low Voltage Circuit Breakers). eCl@ss is the primary classification standard for industrial automation, electrification, and smart infrastructure products in the manufacturing sector.. Valid values are `^[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}$`',
    `edi_catalog_code` STRING COMMENT 'Classification code formatted for use in Electronic Data Interchange (EDI) transactions and punchout catalog integrations (e.g., cXML, OCI punchout). May differ from the raw class_code due to EDI partner-specific formatting requirements. Supports SAP Ariba punchout catalog integration.',
    `effective_date` DATE COMMENT 'Date from which this classification assignment is valid and active for use in product search, EDI transactions, and punchout catalog integrations. Supports time-bounded classification management when standards are updated.. Valid values are `d{4}-d{2}-d{2}`',
    `etim_class_code` STRING COMMENT 'Electrotechnical Information Model (ETIM) class code assigned to the product (e.g., EC002714 for Circuit Breaker). ETIM is the dominant classification standard for electrotechnical and industrial automation products in European markets. Stored as a dedicated field due to its critical importance in the industrial manufacturing sector.. Valid values are `^EC[0-9]{6}$`',
    `expiry_date` DATE COMMENT 'Date on which this classification assignment expires or is superseded. Used when migrating to a new classification system version or when a product is reclassified. Null indicates the classification is currently active with no planned expiry.. Valid values are `d{4}-d{2}-d{2}`',
    `family_code` STRING COMMENT 'Second-level family code within the classification hierarchy (e.g., UNSPSC family 3912 for Power Distribution and Protection Equipment). Supports mid-level product grouping for procurement category management and spend analysis.',
    `is_primary` BOOLEAN COMMENT 'Indicates whether this classification record is the primary/preferred classification for the product within the given classification system. A product may have multiple class assignments within a system (e.g., main class and supplementary class); this flag identifies the authoritative one for search and EDI.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'IETF BCP 47 language tag for the language in which class names and characteristic names/values are expressed (e.g., en-US, de-DE, zh-CN). Supports multilingual classification for global catalog distribution and EDI partner requirements.. Valid values are `[a-z]{2}-[A-Z]{2}`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this classification record was most recently updated. Used for change detection in ETL pipelines, incremental loads to the Silver Layer, and audit trail maintenance.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}`',
    `method` STRING COMMENT 'Method by which the product was assigned to this classification. manual indicates a human classifier assigned it; automated indicates rule-based assignment; ai_assisted indicates machine learning-assisted classification; inherited indicates inherited from a parent product; imported indicates bulk-imported from an external catalog.. Valid values are `manual|automated|ai_assisted|inherited|imported`',
    `notes` STRING COMMENT 'Free-text notes or comments related to this classification assignment. Used to document classification rationale, exceptions, pending reviews, or guidance for future reclassification. Supports knowledge transfer and audit documentation.',
    `punchout_catalog_flag` BOOLEAN COMMENT 'Indicates whether this classification record is published and active in punchout catalog integrations (e.g., SAP Ariba, Coupa). When true, the classification is available for buyer-side catalog search and procurement workflows.. Valid values are `true|false`',
    `regulatory_relevance` STRING COMMENT 'Indicates whether this classification assignment has direct regulatory compliance relevance. Values include ce_marking (EU product safety), rohs (Restriction of Hazardous Substances), reach (Registration Evaluation Authorization and Restriction of Chemicals), ul (Underwriters Laboratories), multiple (more than one regulation applies), or none.. Valid values are `ce_marking|rohs|reach|ul|none|multiple`',
    `scope` STRING COMMENT 'Scope of applicability for this classification assignment. global applies across all markets; regional applies to a geographic region; country applies to a specific country market; sales_channel applies to a specific distribution channel (e.g., punchout, EDI); internal is for internal use only.. Valid values are `global|regional|country|sales_channel|internal`',
    `segment_code` STRING COMMENT 'Top-level segment code within the classification hierarchy (e.g., UNSPSC segment 39 for Electrical Systems and Lighting Equipment, eCl@ss segment 27 for Electrical Engineering). Enables high-level product portfolio analysis and spend analytics.',
    `source_system` STRING COMMENT 'Operational system of record from which this classification record originated. Primarily Siemens Teamcenter PLM (Classification module) or SAP S/4HANA MM (Material Classification). Supports data lineage tracking and conflict resolution in the Silver Layer.. Valid values are `teamcenter_plm|sap_s4hana|manual|ariba|external_feed`',
    `source_system_key` STRING COMMENT 'Native primary key or record identifier from the originating source system (e.g., Teamcenter classification object UID, SAP classification assignment internal number). Enables traceability back to the system of record for reconciliation and audit.',
    `status` STRING COMMENT 'Current lifecycle status of the classification assignment. active indicates the classification is in use; pending_review indicates it requires validation against a new standard version; superseded indicates it has been replaced by a newer classification record; draft indicates it is under preparation.. Valid values are `active|inactive|pending_review|superseded|draft`',
    `system` STRING COMMENT 'Name of the industry-standard or internal classification system used for this assignment. Supported systems include eCl@ss (electrotechnical/industrial), UNSPSC (United Nations Standard Products and Services Code), ETIM (Electrotechnical Information Model), GPC (GS1 Global Product Classification), HS (Harmonized System), NAICS, and internal/custom schemas.. Valid values are `eCl@ss|UNSPSC|ETIM|GPC|HS|NAICS|internal|custom`',
    `system_version` STRING COMMENT 'Version or release of the classification system applied (e.g., eCl@ss 12.0, UNSPSC v23.0901, ETIM 8.0). Critical for maintaining traceability as classification standards evolve and for EDI/punchout catalog compatibility.',
    `unspsc_code` STRING COMMENT 'United Nations Standard Products and Services Code (UNSPSC) 8-digit code assigned to the product. Widely used in procurement systems (SAP Ariba) for spend analytics, supplier management, and sourcing category management across global operations.. Valid values are `^[0-9]{8}$`',
    `validated_by` STRING COMMENT 'Username or employee ID of the person who validated and approved this classification assignment. Required for quality-controlled classification workflows, particularly for regulatory-relevant classifications (CE, RoHS, REACH). Supports ISO 9001 audit trail requirements.',
    `validated_timestamp` TIMESTAMP COMMENT 'Date and time when the classification assignment was validated and approved. Provides a precise audit trail for compliance reporting and classification governance.. Valid values are `d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}`',
    CONSTRAINT pk_classification PRIMARY KEY(`classification_id`)
) COMMENT 'Stores the assignment of catalog items to industry-standard classification systems and internal classification schemas — including eCl@ss, UNSPSC, ETIM (Electrotechnical Information Model), and custom internal product class codes. Captures classification system name, class code, class version, characteristic assignments (key-value pairs for technical attributes like rated voltage, IP protection class, power rating), and classification date. Enables structured product search, cross-catalog comparison, and EDI/punchout catalog integration.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`media` (
    `media_id` BIGINT COMMENT 'Unique surrogate identifier for each digital media asset record associated with a catalog item in the product media repository.',
    `change_notice_id` BIGINT COMMENT 'Foreign key linking to product.product_change_notice. Business justification: product_media.ecn_reference is a STRING reference to the Engineering Change Notice that triggered a media update. Adding product_change_notice_id FK normalizes this relationship and enables traceabili',
    `alt_text` STRING COMMENT 'Short descriptive text alternative for the media asset, used by screen readers and search engine indexing to ensure web accessibility compliance and SEO optimization for product pages.',
    `approval_status` STRING COMMENT 'Approval workflow status of the media asset, indicating whether it has been reviewed and cleared by brand, legal, or regulatory teams prior to publication.. Valid values are `pending|approved|rejected|not_required`',
    `approved_by` STRING COMMENT 'Name or user identifier of the individual who granted final approval for the media asset, providing an audit trail for brand compliance and regulatory accountability.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the media asset received final approval, recorded in ISO 8601 format with timezone offset. Used for audit trails and publication scheduling.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `code` STRING COMMENT 'Business-assigned unique alphanumeric code identifying the media asset, used for cross-system referencing and DAM integration.. Valid values are `^[A-Z0-9_-]{3,50}$`',
    `color_space` STRING COMMENT 'Color space or color profile of the media asset (e.g., sRGB for web, CMYK for print, AdobeRGB for professional photography). Critical for ensuring accurate color reproduction across print and digital channels.. Valid values are `sRGB|AdobeRGB|CMYK|Grayscale|P3`',
    `copyright_owner` STRING COMMENT 'Name of the legal entity or individual holding copyright over the media asset. Required for intellectual property management, licensing compliance, and third-party content governance.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the primary market or region for which this media asset is intended, supporting geo-targeted content delivery and regulatory compliance.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the media asset record was first created in the system, recorded in ISO 8601 format with timezone offset. Used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `dam_asset_reference` STRING COMMENT 'Native identifier of the media asset within the Digital Asset Management (DAM) system (e.g., Siemens Teamcenter Document Management), enabling traceability back to the authoritative source system.',
    `description` STRING COMMENT 'Detailed textual description of the media asset content, including subject matter, intended use context, and any relevant product or scene details.',
    `duration_seconds` DECIMAL(18,2) COMMENT 'Duration of the media asset in seconds. Applicable to video, animation, and 360-degree spin assets. Used for content planning, streaming optimization, and compliance with platform time limits.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `effective_date` DATE COMMENT 'Date from which the media asset is valid and authorized for use on product pages and marketing channels. Supports scheduled launches aligned with product release dates.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date after which the media asset is no longer authorized for use, triggering automatic archival or replacement workflows. Supports license expiry management and brand refresh cycles.. Valid values are `^d{4}-d{2}-d{2}$`',
    `file_format` STRING COMMENT 'Technical file format of the media asset (e.g., JPEG, PNG, TIFF for images; MP4, MOV for video; GLTF, GLB, STEP for 3D/CAD models; USDZ for AR assets), governing compatibility with downstream rendering and delivery systems.. Valid values are `JPEG|PNG|TIFF|SVG|MP4|MOV|WEBM|GLTF|GLB|OBJ|STEP|STL|PDF|USDZ|WEBP|GIF`',
    `file_size_bytes` BIGINT COMMENT 'Size of the media asset file in bytes, used for storage capacity planning, CDN bandwidth optimization, and delivery performance management.. Valid values are `^[0-9]+$`',
    `intended_use` STRING COMMENT 'Specifies the primary business channel or application for which the media asset is optimized — web, print, augmented reality (AR), product configurator, digital catalog, sales presentation, training, social media, or packaging.. Valid values are `web|print|ar|configurator|digital_catalog|sales_presentation|training|social_media|packaging`',
    `is_360_view` BOOLEAN COMMENT 'Flag indicating whether the media asset is a 360-degree interactive spin view of the product, enabling immersive product exploration on e-commerce and configurator platforms.. Valid values are `true|false`',
    `is_downloadable` BOOLEAN COMMENT 'Flag indicating whether the media asset (e.g., 3D CAD model, dimensional drawing, installation guide) is available for customer download from the product portal or e-commerce site.. Valid values are `true|false`',
    `is_primary` BOOLEAN COMMENT 'Flag indicating whether this media asset is the primary (hero) representation of the catalog item. Only one asset per catalog item per locale should be flagged as primary for a given media type.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'IETF BCP 47 language tag indicating the language or locale of the media asset content (e.g., en-US, de-DE, zh-CN). Supports multilingual product catalog delivery across global markets.. Valid values are `^[a-z]{2,3}(-[A-Z]{2,3})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the media asset record, recorded in ISO 8601 format with timezone offset. Supports change detection, incremental ETL processing, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `license_expiry_date` DATE COMMENT 'Date on which the usage license for the media asset expires. Applicable to third-party licensed and rights-managed assets. Triggers license renewal or asset retirement workflows.. Valid values are `^d{4}-d{2}-d{2}$`',
    `license_type` STRING COMMENT 'Type of usage license governing the media asset — proprietary (company-owned), royalty-free, rights-managed, Creative Commons, public domain, or licensed from a third party. Determines permissible usage scope and channels.. Valid values are `proprietary|royalty_free|rights_managed|creative_commons|public_domain|licensed_third_party`',
    `published_timestamp` TIMESTAMP COMMENT 'Date and time when the media asset was first made publicly available on the designated channel (e-commerce, digital catalog, configurator). Supports content freshness tracking and SLA compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `resolution_height_px` STRING COMMENT 'Vertical pixel dimension of the media asset. Used alongside width to confirm resolution adequacy for intended use channels such as print (300 DPI minimum) or web.. Valid values are `^[0-9]+$`',
    `resolution_width_px` STRING COMMENT 'Horizontal pixel dimension of the media asset. Applicable to images, videos, and rendered 3D previews. Used to validate suitability for web, print, or high-resolution display requirements.. Valid values are `^[0-9]+$`',
    `sort_order` STRING COMMENT 'Numeric sequence controlling the display order of media assets on product pages, configurators, and digital catalogs. Lower values appear first; enables merchandising teams to prioritize hero shots.. Valid values are `^[0-9]+$`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this media asset record originated (e.g., Siemens Teamcenter PLM, SAP S/4HANA, Salesforce, external creative agency upload).. Valid values are `teamcenter|sap_s4hana|salesforce|manual|external_agency|dam_system`',
    `status` STRING COMMENT 'Current publication lifecycle status of the media asset — draft (in creation), under_review (pending approval), approved (cleared for use), published (live on channels), archived (retained but not active), or retired (permanently withdrawn).. Valid values are `draft|under_review|approved|published|archived|retired`',
    `storage_url` STRING COMMENT 'Fully qualified URL pointing to the media asset in the Content Delivery Network (CDN) or Digital Asset Management (DAM) system. Used by e-commerce platforms, configurators, and digital catalogs to retrieve and render the asset.. Valid values are `^https?://[^s]+$`',
    `subtype` STRING COMMENT 'Granular classification of the media asset within its type — e.g., hero shot, exploded view, installation photo, CAD model, AR marker, tutorial video — supporting targeted retrieval for e-commerce, print, and configurator use cases.. Valid values are `hero_shot|exploded_view|installation_photo|lifestyle_photo|schematic|dimensional_drawing|cad_model|ar_marker|product_video|tutorial_video|360_spin|cutaway_view|packaging_shot`',
    `tags` STRING COMMENT 'Comma-separated keyword tags associated with the media asset for search, filtering, and taxonomy classification within the DAM system and e-commerce search engines (e.g., automation,panel,installation,24V).',
    `thumbnail_url` STRING COMMENT 'URL of the low-resolution thumbnail or preview image for the media asset, used in search results, asset management interfaces, and product listing pages for fast rendering.. Valid values are `^https?://[^s]+$`',
    `title` STRING COMMENT 'Human-readable title or name of the media asset as displayed in the digital asset management system, e-commerce portal, or product configurator.',
    `type` STRING COMMENT 'Classification of the digital media asset by its fundamental type — image, video, 3D CAD model, augmented reality (AR) asset, document, animation, or 360-degree view.. Valid values are `image|video|3d_model|ar_asset|document|animation|360_view`',
    `version_number` STRING COMMENT 'Version identifier of the media asset following semantic versioning conventions (e.g., 1.0, 2.1, 3.0.1). Tracks revisions driven by product updates, Engineering Change Notices (ECN), or brand refresh initiatives.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)?$`',
    CONSTRAINT pk_media PRIMARY KEY(`media_id`)
) COMMENT 'Manages digital media assets associated with catalog items — product images (hero shots, exploded views, installation photos), 3D CAD models for download, product videos, and augmented reality (AR) assets. Captures media type, file format, resolution, language/locale, intended use (web, print, AR, configurator), publication status, and the CDN or DAM storage URL. Supports e-commerce product pages, digital catalogs, and customer-facing configurator tools.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`attribute` (
    `attribute_id` BIGINT COMMENT 'Unique surrogate identifier for each product attribute record in the catalog. Serves as the primary key for the product_attribute entity in the Silver Layer lakehouse.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: product_attribute stores extended technical and commercial attributes for catalog items. catalog_item_code is a STRING reference to the parent catalog_item. Adding catalog_item_id FK normalizes this p',
    `change_notice_id` BIGINT COMMENT 'Foreign key linking to product.product_change_notice. Business justification: product_attribute.ecn_reference is a STRING reference to the Engineering Change Notice that triggered an attribute change. Adding product_change_notice_id FK normalizes this relationship and enables t',
    `classification_id` BIGINT COMMENT 'Foreign key linking to product.product_classification. Business justification: product_attribute stores attributes organized by classification class. attribute_class_code references product_classification.class_code. Adding product_classification_id FK normalizes this relationsh',
    `allowed_values` STRING COMMENT 'Pipe-separated list of permissible values for string-type attributes with a controlled vocabulary (e.g., IP20|IP44|IP54|IP65|IP67|IP68 for protection class). Null for free-text or numeric attributes. Used for validation in PIM, CPQ, and ERP data entry.',
    `approved_by` STRING COMMENT 'Name or user ID of the product data steward, engineer, or manager who approved this attribute value for publication. Supports data governance, audit trail, and quality management requirements under ISO 9001.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this attribute value was formally approved by the designated approver. Provides a precise audit trail for product data governance and regulatory compliance documentation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `boolean_value` BOOLEAN COMMENT 'Stores the attribute value when data_type is boolean. Examples include is_explosion_proof (true/false), has_integrated_display (true/false). Null when data_type is not boolean.. Valid values are `true|false`',
    `certification_reference` STRING COMMENT 'Specific certificate number, test report reference, or declaration of conformity document number that substantiates the attribute value for regulatory compliance purposes (e.g., CE Declaration of Conformity number, UL file number, RoHS test report ID).',
    `characteristic_code` STRING COMMENT 'SAP characteristic code (CABN) or IEC Common Data Dictionary (CDD) property identifier corresponding to this attribute. Enables cross-system traceability and standardized attribute exchange with suppliers and customers.',
    `code` STRING COMMENT 'Unique machine-readable code identifying the attribute definition (e.g., RATED_VOLTAGE, IP_PROTECTION_CLASS, OPERATING_TEMP_MIN). Used for programmatic lookup and integration with PLM and ERP classification systems.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country or market for which this attribute value applies. Supports regional product variants where specifications differ by market (e.g., voltage ratings for USA vs. EU vs. Japan).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this product attribute record was first created in the system. Used for data lineage, audit trail, and change history tracking in the Silver Layer lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `data_type` STRING COMMENT 'Logical data type of the attribute value, enabling correct parsing, validation, and rendering in downstream systems such as CPQ, ERP, and customer portals. Range type supports min/max paired values (e.g., operating temperature range).. Valid values are `string|numeric|boolean|date|range`',
    `date_value` DATE COMMENT 'Stores the attribute value when data_type is date. Examples include certification expiry date, last calibration date, or product introduction date. Null when data_type is not date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `display_sequence` STRING COMMENT 'Numeric ordering value that controls the sequence in which attributes are displayed within their attribute group on product datasheets, CPQ configurators, and customer portals. Lower values appear first.. Valid values are `^[0-9]+$`',
    `effective_date` DATE COMMENT 'Date from which this attribute value is valid and applicable to the catalog item. Supports time-variant product specifications where attribute values change over the product lifecycle (e.g., updated voltage rating after an engineering change).. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date after which this attribute value is no longer valid for the catalog item. Null indicates the attribute value has no planned expiry. Used for time-limited specifications such as certification validity periods or promotional commercial attributes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `group` STRING COMMENT 'Logical grouping category for the attribute, enabling structured navigation and filtering of product specifications. Technical covers engineering specs; commercial covers pricing/sales attributes; dimensional covers physical measurements; environmental covers operating conditions and sustainability data; regulatory covers compliance-related attributes.. Valid values are `technical|commercial|dimensional|environmental|regulatory|electrical|mechanical|thermal|chemical|performance`',
    `is_configurable_option` BOOLEAN COMMENT 'Indicates whether this attribute represents a configurable option that can be selected during product configuration in CPQ or SAP Variant Configuration (VC). True for attributes that drive product variants or pricing impacts.. Valid values are `true|false`',
    `is_customer_facing` BOOLEAN COMMENT 'Indicates whether this attribute is visible to external customers in product catalogs, datasheets, e-commerce portals, and CPQ configurators. False indicates the attribute is for internal use only (e.g., internal manufacturing specs, cost attributes).. Valid values are `true|false`',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether this attribute must be populated for the catalog item to be considered complete and publishable. Mandatory attributes are enforced during product data governance and completeness scoring.. Valid values are `true|false`',
    `is_searchable` BOOLEAN COMMENT 'Indicates whether this attribute is indexed and available as a search/filter facet in product catalogs, e-commerce platforms, and CPQ systems. Enables customers and sales teams to filter products by technical specifications.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'ISO 639-1 language code (optionally with ISO 3166-1 country subtag) for the attribute name and string value, supporting multilingual product catalogs for global markets (e.g., en, de, fr, zh-CN, ja). Enables localized product specifications for regional sales and compliance.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this product attribute record was most recently updated. Used for incremental data loading, change detection, and audit trail maintenance in the Silver Layer lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `name` STRING COMMENT 'Human-readable name of the product attribute (e.g., Rated Voltage, IP Protection Class, Minimum Operating Temperature). Displayed in product datasheets, CPQ configurators, and customer-facing portals.',
    `numeric_value` DECIMAL(18,2) COMMENT 'Stores the attribute value when data_type is numeric. Examples include rated voltage (400), rated current (16), weight (2.5), or operating temperature (-40). Null when data_type is not numeric.',
    `plm_attribute_reference` STRING COMMENT 'Unique identifier of this attribute in Siemens Teamcenter PLM. Enables direct cross-reference between the lakehouse Silver Layer and the PLM system for engineering data synchronization and change management traceability.',
    `range_max_value` DECIMAL(18,2) COMMENT 'Upper bound of the attribute value when data_type is range. Used for attributes such as operating temperature range (-40 to +85°C) or input voltage range (85 to 264 VAC). Null when data_type is not range.',
    `range_min_value` DECIMAL(18,2) COMMENT 'Lower bound of the attribute value when data_type is range. Used for attributes such as operating temperature range (-40 to +85°C) or input voltage range (85 to 264 VAC). Null when data_type is not range.',
    `regulatory_standard` STRING COMMENT 'Regulatory standard or certification body associated with this attribute (e.g., IEC 60529 for IP protection class, EN 61000 for EMC, RoHS Directive 2011/65/EU, REACH Regulation EC 1907/2006, UL 508A). Enables compliance reporting and regulatory traceability.',
    `source_system` STRING COMMENT 'Operational system of record from which this attribute was originated or last updated. Supports data lineage tracking and conflict resolution when attributes are sourced from multiple systems (e.g., SAP S/4HANA MM Classification vs. Siemens Teamcenter PLM).. Valid values are `SAP_S4HANA|TEAMCENTER_PLM|OPCENTER_MES|MINDSPHERE|MANUAL|MIGRATION`',
    `source_system_key` STRING COMMENT 'Primary key or unique identifier of this attribute record in the originating source system (e.g., SAP characteristic assignment internal ID, Teamcenter attribute object UID). Enables bidirectional traceability and reconciliation with source systems.',
    `status` STRING COMMENT 'Current lifecycle status of the product attribute record. Active attributes are published and in use; draft attributes are pending review; deprecated attributes are retained for historical reference but no longer applied to new products.. Valid values are `active|inactive|draft|deprecated|under_review`',
    `string_value` STRING COMMENT 'Stores the attribute value when data_type is string. Examples include protection class (IP65), material designation (Stainless Steel 316L), or color (RAL 7035). Null when data_type is not string.',
    `tolerance_unit` STRING COMMENT 'Specifies whether the value_tolerance is expressed as a percentage of the nominal value (percent) or as an absolute value in the attributes unit of measure (absolute). Enables correct interpretation of engineering tolerances.. Valid values are `percent|absolute`',
    `unit_of_measure` STRING COMMENT 'Physical or commercial unit associated with the attribute value (e.g., V for voltage, A for current, °C for temperature, mm for dimensions, kg for weight, W for power). Follows SI and IEC standard unit symbols. Null for non-numeric or boolean attributes.',
    `value_tolerance` DECIMAL(18,2) COMMENT 'Permissible tolerance or deviation for numeric attribute values, expressed in the same unit of measure as the attribute. Used for engineering specifications where a nominal value has an acceptable range (e.g., ±5% for voltage tolerance, ±0.1 mm for dimensional tolerance).',
    CONSTRAINT pk_attribute PRIMARY KEY(`attribute_id`)
) COMMENT 'Stores extended technical and commercial attributes for catalog items that are not part of the fixed catalog_item schema — enabling flexible, schema-less attribute extension for diverse product lines. Captures attribute name, attribute group (technical, commercial, dimensional, environmental), data type (string, numeric, boolean, date), value, unit of measure, and whether the attribute is customer-facing or internal. Supports the wide variety of technical specifications across automation, electrification, and infrastructure product lines.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`change_notice` (
    `change_notice_id` BIGINT COMMENT 'Unique surrogate key identifying each Engineering Change Notice (ECN) or Engineering Change Order (ECO) record in the commercial product catalog domain.',
    `eco_id` BIGINT COMMENT 'Foreign key linking to engineering.eco. Business justification: Product change notices communicate engineering change orders (ECOs) to commercial teams. Product management, sales, and supply chain use this to synchronize market-facing product updates with engineer',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Engineering change orders must track the responsible engineer who authored and owns the change. Engineering departments use this daily for accountability, approvals, and technical queries on product m',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: Engineering change notices often stem from R&D projects introducing improvements or new technologies. Change management teams link ECNs to originating R&D work for impact analysis and approval workflo',
    `regulatory_change_id` BIGINT COMMENT 'Foreign key linking to compliance.regulatory_change. Business justification: Product changes are often triggered by regulatory changes (new safety standards, environmental regulations). Engineering change control processes track which regulatory updates necessitate product mod',
    `affected_catalog_item_count` STRING COMMENT 'Number of distinct catalog items (finished goods, automation systems, electrification solutions, smart infrastructure components) impacted by this change notice.. Valid values are `^[0-9]+$`',
    `affected_sku_count` STRING COMMENT 'Number of distinct SKUs in the commercial product catalog that are impacted by this change notice. Provides a quick impact scope indicator for change review boards.. Valid values are `^[0-9]+$`',
    `approval_level` STRING COMMENT 'The organizational approval level required for this change notice based on its category and impact. Determines the routing of the approval workflow.. Valid values are `engineering|product_management|quality|regulatory|executive|change_control_board`',
    `approval_status` STRING COMMENT 'Current approval decision status of the change notice by the Change Control Board (CCB) or designated approvers. Distinct from workflow status — captures the decision outcome.. Valid values are `pending|approved|conditionally_approved|rejected|escalated`',
    `approved_by` STRING COMMENT 'Name or user ID of the individual or Change Control Board (CCB) member who granted final approval for the change notice.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the change notice received final approval. Used for audit trail, compliance reporting, and change velocity analytics.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `bom_change_flag` BOOLEAN COMMENT 'Indicates whether this change notice results in a modification to the Bill of Materials (BOM) for one or more affected products. Triggers BOM revision workflow in Siemens Teamcenter PLM.. Valid values are `true|false`',
    `ce_marking_impact_flag` BOOLEAN COMMENT 'Indicates whether this change notice requires re-evaluation or re-certification of CE marking for affected products sold in the European Economic Area.. Valid values are `true|false`',
    `change_category` STRING COMMENT 'Severity classification of the change indicating whether it is a major change (affects form, fit, or function), minor change (does not affect form, fit, or function), or administrative (documentation only). Drives approval workflow routing.. Valid values are `major|minor|administrative`',
    `change_reason_code` STRING COMMENT 'Standardized reason code from the PLM or ERP system that categorizes the root cause or business driver for the change (e.g., CAPA, customer complaint, design improvement, regulatory mandate).',
    `change_type` STRING COMMENT 'Classification of the engineering change by its primary driver or nature. Supports analytics on change frequency by type and impact assessment across the product catalog.. Valid values are `design_change|material_substitution|regulatory_update|cost_reduction|process_change|safety_update|customer_driven|supplier_driven|obsolescence`',
    `cost_impact_amount` DECIMAL(18,2) COMMENT 'Estimated or actual financial impact of the change on product standard cost, expressed in the designated currency. Positive values indicate cost increases; negative values indicate cost reductions.',
    `cost_impact_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the cost impact amount (e.g., USD, EUR, CNY). Supports multi-currency reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the primary country of applicability for the change, particularly relevant for country-specific regulatory changes.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the change notice record was first created in the data platform. Used for audit trail and data lineage.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `description` STRING COMMENT 'Detailed narrative describing the engineering change, its rationale, and the expected impact on the commercial product catalog.',
    `disposition_code` STRING COMMENT 'Disposition instruction for existing inventory and work-in-progress (WIP) affected by the change. Determines how existing stock is handled at the point of change effectivity.. Valid values are `use_as_is|rework|scrap|return_to_supplier|hold_for_review`',
    `ecn_number` STRING COMMENT 'Official Engineering Change Notice number as assigned in Siemens Teamcenter PLM. Serves as the primary business identifier for the change notice across engineering and commercial systems.. Valid values are `^ECN-[A-Z0-9]{4,20}$`',
    `eco_number` STRING COMMENT 'Engineering Change Order number that formally authorizes implementation of the change. An ECO is the approved execution document derived from an ECN. May be null if the ECN has not yet been converted to an ECO.. Valid values are `^ECO-[A-Z0-9]{4,20}$`',
    `effectivity_date` DATE COMMENT 'Calendar date on which the change becomes effective in production and the commercial catalog. Applicable when effectivity_type is date_based. Aligns with SAP S/4HANA material master effectivity date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effectivity_serial_number` STRING COMMENT 'The serial number at which the change becomes effective in production. Applicable when effectivity_type is serial_number_based. Used to manage configuration control for serialized products.',
    `effectivity_type` STRING COMMENT 'Defines the mechanism by which the change becomes effective — either on a specific calendar date, at a specific serial number, at a specific lot/batch number, or at a specific unit number. Critical for production planning and inventory management.. Valid values are `date_based|serial_number_based|lot_number_based|unit_number_based`',
    `export_control_impact_flag` BOOLEAN COMMENT 'Indicates whether this change notice affects the export control classification (ECCN) of affected products, requiring review under EAR or ITAR regulations.. Valid values are `true|false`',
    `implementation_date` DATE COMMENT 'Actual calendar date on which the change was implemented in production and the commercial product catalog was updated to reflect the change.. Valid values are `^d{4}-d{2}-d{2}$`',
    `language_code` STRING COMMENT 'ISO 639-1 language code for the language in which the change notice title and description are authored. Supports multi-language documentation for global operations.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the change notice record was most recently updated in the data platform. Supports incremental data processing and change data capture in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `originating_system` STRING COMMENT 'The operational system of record in which the change notice was originally created. Supports data lineage tracking and cross-system reconciliation.. Valid values are `teamcenter_plm|sap_s4hana|opcenter_mes|manual|other`',
    `part_number_change_flag` BOOLEAN COMMENT 'Indicates whether this change notice results in the creation of a new part number or material number for affected catalog items, as opposed to a revision to an existing part number.. Valid values are `true|false`',
    `planned_implementation_date` DATE COMMENT 'Target calendar date by which the change is planned to be implemented. Used for project planning and change backlog management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `priority` STRING COMMENT 'Business priority assigned to the change notice, used to sequence implementation activities and resource allocation across the engineering and commercial teams.. Valid values are `critical|high|medium|low`',
    `reach_impact_flag` BOOLEAN COMMENT 'Indicates whether this change notice affects the REACH compliance status of one or more catalog items, particularly regarding Substances of Very High Concern (SVHC).. Valid values are `true|false`',
    `regulatory_driver` STRING COMMENT 'Identifies the specific regulatory standard or compliance requirement that is driving the change, if applicable. Supports regulatory impact tracking and compliance reporting.. Valid values are `rohs|reach|ce_marking|ul_certification|iso_9001|iso_14001|iso_45001|osha|epa|iec_62443|none|other`',
    `rohs_impact_flag` BOOLEAN COMMENT 'Indicates whether this change notice affects the RoHS compliance status of one or more catalog items. Triggers mandatory compliance re-evaluation when true.. Valid values are `true|false`',
    `sap_change_number` STRING COMMENT 'Engineering Change Number (ECN) as recorded in SAP S/4HANA, used to control material master and BOM changes. Links the commercial catalog change to the ERP systems change management record.',
    `status` STRING COMMENT 'Current workflow status of the Engineering Change Notice or Engineering Change Order within the approval and implementation lifecycle.. Valid values are `draft|submitted|under_review|approved|rejected|implemented|cancelled|on_hold`',
    `submitted_by` STRING COMMENT 'Name or user ID of the engineer or product manager who originated and submitted the change notice in Siemens Teamcenter PLM.',
    `submitted_date` DATE COMMENT 'Calendar date on which the change notice was formally submitted for review and approval.. Valid values are `^d{4}-d{2}-d{2}$`',
    `teamcenter_change_object_reference` STRING COMMENT 'Native object identifier of the change notice or change order record in Siemens Teamcenter PLM. Enables direct traceability and cross-system navigation between the commercial catalog and the engineering PLM system.',
    `title` STRING COMMENT 'Short, descriptive title summarizing the nature of the engineering change, as entered in Siemens Teamcenter PLM.',
    `ul_certification_impact_flag` BOOLEAN COMMENT 'Indicates whether this change notice requires re-evaluation or re-certification of UL product safety certification for affected products sold in North American markets.. Valid values are `true|false`',
    CONSTRAINT pk_change_notice PRIMARY KEY(`change_notice_id`)
) COMMENT 'Records Engineering Change Notices (ECN) and Engineering Change Orders (ECO) that affect the commercial product catalog — capturing changes to product specifications, part numbers, configurations, or regulatory compliance status. Tracks ECN/ECO number, change type (design change, material substitution, regulatory update, cost reduction), affected catalog items, change description, effectivity date (serial number or date-based), approval status, and the originating PLM change order in Siemens Teamcenter. Bridges the engineering and commercial product domains.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`launch` (
    `launch_id` BIGINT COMMENT 'Unique surrogate identifier for each product launch record in the system. Serves as the primary key for the product_launch data product.',
    `change_notice_id` BIGINT COMMENT 'Foreign key linking to product.product_change_notice. Business justification: product_launch.ecn_reference is a STRING reference to the Engineering Change Notice associated with a new product introduction. Adding product_change_notice_id FK normalizes this relationship and enab',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Product launches require a designated manager responsible for coordinating cross-functional activities, timelines, and go-to-market execution. Product management teams track ownership for every launch',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: product_launch.sku_code is a STRING reference to the SKU being launched. Launch records track new product introduction milestones for specific SKUs. Adding sku_id FK normalizes this relationship and e',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: Product launches are the commercialization outcome of R&D projects. Marketing and operations teams reference the originating R&D project for launch planning, readiness assessment, and go-to-market str',
    `project_id` BIGINT COMMENT 'Project identifier in Siemens Teamcenter PLM corresponding to the NPI project for this product launch. Enables traceability between the commercial launch record and the engineering design project.',
    `actual_launch_date` DATE COMMENT 'Actual calendar date on which the product was commercially launched. Compared against target_launch_date to measure NPI schedule adherence and launch KPI performance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `apqp_gate_status` STRING COMMENT 'Current approval status of the most recent APQP gate review for this product launch. Indicates whether the launch has passed, conditionally passed, or failed the formal NPI gate review process.. Valid values are `not_started|in_review|approved|conditionally_approved|rejected`',
    `budget_amount` DECIMAL(18,2) COMMENT 'Total approved budget allocated for the product launch initiative, including marketing, sales enablement, tooling, and certification costs. Tracked as CAPEX/OPEX in SAP CO.',
    `budget_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the launch budget amount (e.g., USD, EUR, GBP). Supports multi-currency reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `business_unit` STRING COMMENT 'Business unit within the manufacturing organization responsible for the product launch, such as Automation Systems, Electrification Solutions, or Smart Infrastructure.',
    `cancellation_reason` STRING COMMENT 'Free-text description of the reason for cancelling the product launch, captured when status is set to cancelled. Supports post-mortem analysis and NPI process improvement.',
    `ce_marking_required` BOOLEAN COMMENT 'Indicates whether CE marking is required for the product in the target launch markets. Mandatory for products sold in the European Economic Area (EEA) under applicable EU directives.. Valid values are `true|false`',
    `certifications_obtained_flag` BOOLEAN COMMENT 'Readiness checklist indicator confirming that all required regulatory certifications (CE, UL, RoHS, REACH) have been obtained prior to commercial launch. Mandatory gate criterion for regulated markets.. Valid values are `true|false`',
    `code` STRING COMMENT 'Business-assigned alphanumeric code uniquely identifying the product launch initiative. Used for cross-system referencing and reporting across SAP, Teamcenter PLM, and Salesforce CRM.. Valid values are `^[A-Z]{2,4}-[A-Z0-9]{4,10}-[0-9]{4}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the product launch record was first created in the system, in ISO 8601 format with timezone offset. Supports audit trail and data lineage requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `delay_reason_code` STRING COMMENT 'Standardized reason code explaining why the product launch was delayed relative to the target launch date. Used for root cause analysis and NPI process improvement.. Valid values are `certification_delay|supply_chain_issue|design_change|regulatory_hold|resource_constraint|market_conditions|quality_issue|other`',
    `description` STRING COMMENT 'Detailed narrative describing the scope, objectives, and commercial intent of the product launch, including target customer segments and key differentiators.',
    `documentation_published_flag` BOOLEAN COMMENT 'Readiness checklist indicator confirming that all required product documentation (datasheets, installation manuals, safety data sheets, user guides) has been published in the product document management system prior to launch.. Valid values are `true|false`',
    `export_control_flag` BOOLEAN COMMENT 'Indicates whether the product is subject to export control regulations (e.g., EAR, ITAR) that may restrict launch in certain countries or require export licenses. Impacts target country eligibility.. Valid values are `true|false`',
    `first_customer_shipment_date` DATE COMMENT 'Date of the first customer shipment (FCS), representing the milestone when the product was physically delivered to the first paying customer. A critical NPI completion milestone tracked in SAP SD and Siemens Opcenter MES.. Valid values are `^d{4}-d{2}-d{2}$`',
    `go_to_market_strategy` STRING COMMENT 'Go-to-market channel strategy for the product launch, defining how the product will reach end customers — through direct sales, channel partners, distributors, OEM agreements, e-commerce, or a hybrid approach.. Valid values are `direct_sales|channel_partner|distributor|oem|ecommerce|hybrid`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the product launch record, in ISO 8601 format with timezone offset. Used for change tracking, audit compliance, and incremental data pipeline processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `manufacturing_readiness_flag` BOOLEAN COMMENT 'Readiness checklist indicator confirming that production lines, tooling, and manufacturing processes have been validated and are ready for volume production in Siemens Opcenter MES.. Valid values are `true|false`',
    `name` STRING COMMENT 'Official commercial name of the product launch initiative as used in go-to-market communications, NPI gate reviews, and APQP documentation.',
    `npi_phase` STRING COMMENT 'Current phase of the New Product Introduction (NPI) gate review process, aligned with APQP methodology. Tracks progression through concept, feasibility, design, prototype, validation, pilot production, and launch readiness gates.. Valid values are `concept|feasibility|design|prototype|validation|pilot_production|launch_readiness|launched`',
    `ppap_status` STRING COMMENT 'Status of the Production Part Approval Process (PPAP) submission for the launched product, confirming that the manufacturing process can consistently produce parts meeting customer requirements.. Valid values are `not_required|pending|submitted|approved|rejected|interim_approval`',
    `pricing_loaded_flag` BOOLEAN COMMENT 'Readiness checklist indicator confirming that product pricing has been loaded into SAP SD price lists and CPQ systems prior to commercial launch. Part of the NPI launch readiness gate.. Valid values are `true|false`',
    `product_family` STRING COMMENT 'Product family grouping to which the launched product belongs, aligning with the product hierarchy in Siemens Teamcenter PLM and SAP material master.',
    `readiness_score_percent` DECIMAL(18,2) COMMENT 'Overall launch readiness score expressed as a percentage (0-100), calculated from the completion status of all readiness checklist items. Used in NPI gate review dashboards and executive reporting.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `responsible_product_manager` STRING COMMENT 'Name or employee identifier of the product manager accountable for the product launch initiative, NPI gate reviews, and cross-functional readiness coordination.',
    `sales_training_completed_flag` BOOLEAN COMMENT 'Readiness checklist indicator confirming that sales force training on the new product has been completed prior to commercial launch. Tracked in Salesforce CRM and Kronos Workforce Central.. Valid values are `true|false`',
    `sap_project_reference` STRING COMMENT 'Project identifier in SAP Project System (PS) module tracking the NPI project costs, milestones, and resource allocations associated with this product launch.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this product launch record originated (e.g., SAP S/4HANA PS, Siemens Teamcenter PLM). Supports data lineage and Silver layer traceability.. Valid values are `SAP_S4HANA|TEAMCENTER_PLM|OPCENTER_MES|SALESFORCE_CRM|MANUAL`',
    `status` STRING COMMENT 'Current operational status of the product launch initiative, tracking progression from planning through execution. Drives NPI gate review workflows and executive dashboards.. Valid values are `planned|in_progress|launched|cancelled|on_hold|delayed`',
    `supply_chain_readiness_flag` BOOLEAN COMMENT 'Readiness checklist indicator confirming that the supply chain, including approved suppliers, component procurement, and inventory buffers, is ready to support product launch volumes. Tracked in SAP Ariba and SAP MM.. Valid values are `true|false`',
    `target_countries` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes where the product will be commercially launched. Used for export control screening, regulatory certification tracking, and sales territory planning.',
    `target_fcs_date` DATE COMMENT 'Planned date for achieving first customer shipment (FCS) as defined in the NPI project schedule. Used to measure schedule adherence and supply chain readiness.. Valid values are `^d{4}-d{2}-d{2}$`',
    `target_launch_date` DATE COMMENT 'Planned calendar date for the commercial product launch as defined in the NPI project plan. Used for milestone tracking, supply chain readiness, and sales force enablement scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `target_markets` STRING COMMENT 'Comma-separated list of target industry verticals or market segments for the product launch, such as factory automation, building infrastructure, transportation, or energy.',
    `target_regions` STRING COMMENT 'Comma-separated list of geographic regions targeted for the product launch (e.g., North America, Europe, Asia Pacific). Drives regional readiness checklists and regulatory certification requirements.',
    `type` STRING COMMENT 'Classification of the launch scope indicating whether the product is being released globally, in specific regions, as a limited release, as a pilot, or as a soft launch to select customers.. Valid values are `global|regional|limited_release|pilot|soft_launch`',
    `ul_certification_required` BOOLEAN COMMENT 'Indicates whether UL (Underwriters Laboratories) product safety certification is required for the product in the target launch markets, particularly for North American markets.. Valid values are `true|false`',
    CONSTRAINT pk_launch PRIMARY KEY(`launch_id`)
) COMMENT 'Manages the commercial product launch process — tracking new product introduction (NPI) milestones from market readiness through first customer shipment (FCS). Captures launch name, target launch date, actual launch date, target markets and regions, launch type (global, regional, limited release), launch status (planned, in-progress, launched, cancelled), responsible product manager, and readiness checklist completion (pricing loaded, certifications obtained, documentation published, sales training completed). Supports APQP and NPI gate review processes.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`warranty_policy` (
    `warranty_policy_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a warranty policy record in the product catalog.',
    `applicable_market_regions` STRING COMMENT 'Pipe-delimited list of ISO 3166-1 alpha-3 country codes or named regional market groupings (e.g., USA|CAN|MEX or GLOBAL) identifying the geographic markets where this warranty policy is valid and enforceable.',
    `applicable_product_scope` STRING COMMENT 'Defines the scope of catalog items to which this warranty policy applies: all products, a specific product family, product category, individual SKU, or a named product line such as automation systems or electrification solutions.. Valid values are `all_products|product_family|product_category|specific_sku|automation_systems|electrification_solutions|smart_infrastructure|aftermarket_parts`',
    `approved_by` STRING COMMENT 'Name or employee identifier of the authorized person who approved this warranty policy version for publication and use. Required for ISO 9001 documented information control.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this warranty policy version was formally approved by the authorized approver. Provides audit trail for ISO 9001 documented information control compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `claim_limit_currency` STRING COMMENT 'ISO 4217 three-letter currency code in which the max_claim_amount is denominated (e.g., USD, EUR, GBP). Supports multi-currency operations across global markets.. Valid values are `^[A-Z]{3}$`',
    `coverage_scope` STRING COMMENT 'Defines what is covered under the warranty: parts only (materials cost), parts and labor (materials plus technician time), full replacement (complete unit swap), on-site service (field technician dispatch), depot repair (return-to-depot), software only, or consumables excluded.. Valid values are `parts_only|parts_and_labor|full_replacement|on_site_service|depot_repair|software_only|consumables_excluded`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this warranty policy record was first created in the data platform. Used for audit trail, data lineage, and compliance with ISO 9001 documented information control requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `description` STRING COMMENT 'Full narrative description of the warranty policy terms, conditions, and coverage scope as communicated to customers and service teams.',
    `dispute_resolution_mechanism` STRING COMMENT 'Specifies the contractual mechanism for resolving warranty disputes between the manufacturer and customer: arbitration, mediation, litigation, expert determination, or ombudsman. Relevant for legal and compliance teams.. Valid values are `arbitration|mediation|litigation|expert_determination|ombudsman`',
    `duration_months` STRING COMMENT 'Total duration of the warranty coverage expressed in months from the warranty start date. Standard industrial automation warranties typically range from 12 to 60 months.. Valid values are `^[1-9][0-9]{0,3}$`',
    `effective_date` DATE COMMENT 'Date from which this warranty policy version becomes effective and applicable to new product sales or registrations. Used to determine which policy version applies to a given transaction date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `exclusion_conditions` STRING COMMENT 'Narrative description of conditions, events, or damage types that void or exclude warranty coverage (e.g., misuse, unauthorized modifications, improper installation, use outside rated environmental conditions, consumable wear parts, damage from external causes).',
    `expiry_date` DATE COMMENT 'Date after which this warranty policy version is no longer applicable to new sales. Policies with no expiry date remain active until explicitly superseded or retired.. Valid values are `^d{4}-d{2}-d{2}$`',
    `governing_law_country` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the jurisdiction whose laws govern the interpretation and enforcement of this warranty policy. Critical for multinational legal compliance and dispute resolution.. Valid values are `^[A-Z]{3}$`',
    `labor_coverage_months` STRING COMMENT 'Number of months during which labor costs are covered under the warranty. May differ from total duration_months when labor coverage is shorter than parts coverage (e.g., 12 months labor within a 24-month parts warranty).. Valid values are `^[0-9]{1,4}$`',
    `language_code` STRING COMMENT 'IETF BCP 47 language tag identifying the language in which this warranty policy record is authored (e.g., en, de, fr, zh-CN). Supports multi-language policy management for global markets.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this warranty policy record was most recently updated in the data platform. Supports change tracking, incremental data loads, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `max_claim_amount` DECIMAL(18,2) COMMENT 'Maximum monetary value of claims that can be processed under this warranty policy over its lifetime. Caps the manufacturers financial liability exposure per policy instance.',
    `name` STRING COMMENT 'Short descriptive name of the warranty policy (e.g., Standard 2-Year Parts and Labor, Extended 5-Year Performance Guarantee) used in customer-facing documentation and service portals.',
    `on_site_service_included` BOOLEAN COMMENT 'Indicates whether the warranty policy includes on-site field service dispatch at no additional charge to the customer. Drives field service scheduling and cost allocation in Salesforce Field Service and Maximo EAM.. Valid values are `true|false`',
    `parts_coverage_months` STRING COMMENT 'Number of months during which replacement parts are covered under the warranty. May differ from labor_coverage_months in tiered warranty structures.. Valid values are `^[0-9]{1,4}$`',
    `policy_code` STRING COMMENT 'Business-facing alphanumeric code uniquely identifying the warranty policy, used for cross-system reference in SAP SD, Salesforce Service Cloud, and customer-facing documentation.. Valid values are `^WP-[A-Z0-9]{4,20}$`',
    `preventive_maintenance_included` BOOLEAN COMMENT 'Indicates whether scheduled preventive maintenance visits are included within the warranty coverage at no additional cost. Relevant for Total Productive Maintenance (TPM) programs and Maximo EAM maintenance planning.. Valid values are `true|false`',
    `pro_rata_applicable` BOOLEAN COMMENT 'Indicates whether warranty claims are settled on a pro-rata basis (i.e., the reimbursement value decreases proportionally over the warranty period). Common in battery and consumable component warranties.. Valid values are `true|false`',
    `registration_required` BOOLEAN COMMENT 'Indicates whether the customer must register the product to activate warranty coverage. When true, warranty claims may be rejected if registration was not completed within the required registration window.. Valid values are `true|false`',
    `registration_window_days` STRING COMMENT 'Number of days from the warranty start basis event within which the customer must register the product to activate warranty coverage. Applicable only when registration_required is true.. Valid values are `^[0-9]{1,4}$`',
    `regulatory_compliance_flags` STRING COMMENT 'Pipe-delimited list of regulatory frameworks or certifications that this warranty policy is designed to satisfy (e.g., CE|RoHS|REACH|UL|ISO9001). Supports compliance reporting and customer documentation requirements.',
    `renewable` BOOLEAN COMMENT 'Indicates whether this warranty policy can be renewed or extended at the end of the coverage period, typically through a service contract or extended warranty purchase.. Valid values are `true|false`',
    `resolution_time_hours` STRING COMMENT 'Maximum number of hours within which the manufacturer commits to resolve or provide a remedy for a warranty claim. Distinct from response_time_hours which covers acknowledgment only.. Valid values are `^[0-9]{1,4}$`',
    `response_time_hours` STRING COMMENT 'Maximum number of hours within which the manufacturer commits to respond to a warranty claim or service request. Defines the Service Level Agreement (SLA) response commitment embedded in the warranty policy.. Valid values are `^[0-9]{1,4}$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this warranty policy record originates (e.g., SAP SD warranty condition, Salesforce Service Cloud warranty object, Siemens Teamcenter PLM). Supports data lineage and reconciliation.. Valid values are `SAP_SD|Salesforce_Service|Teamcenter_PLM|Manual|Legacy`',
    `source_system_key` STRING COMMENT 'Natural key or identifier of this warranty policy record in the originating source system (e.g., SAP warranty condition number, Salesforce warranty record ID). Enables cross-system traceability and reconciliation.',
    `status` STRING COMMENT 'Current lifecycle status of the warranty policy: draft (being authored), active (in use for new sales), superseded (replaced by a newer policy version), retired (no longer applicable), or under_review (pending approval for changes).. Valid values are `draft|active|superseded|retired|under_review`',
    `transferable` BOOLEAN COMMENT 'Indicates whether the warranty coverage can be transferred to a subsequent owner of the product (e.g., upon resale of industrial equipment). Relevant for asset-intensive industries where equipment changes ownership.. Valid values are `true|false`',
    `version_number` STRING COMMENT 'Version identifier of the warranty policy document following semantic versioning (e.g., 1.0, 2.1, 3.0.1). Enables tracking of policy revisions and ensures correct version is applied to warranty claims.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)?$`',
    `warranty_start_basis` STRING COMMENT 'Defines the event that triggers the start of the warranty period: ship_date (date product leaves factory), delivery_date (date received by customer), installation_date (date physically installed), commissioning_date (date system is operational), invoice_date, first_use_date, or registration_date.. Valid values are `ship_date|delivery_date|installation_date|commissioning_date|invoice_date|first_use_date|registration_date`',
    `warranty_type` STRING COMMENT 'Classification of the warranty policy type: standard (default manufacturer warranty), extended (purchased additional coverage), performance_guarantee (output/uptime commitment), limited (restricted scope), statutory (legally mandated), or supplier_passthrough (warranty passed from component supplier).. Valid values are `standard|extended|performance_guarantee|limited|statutory|supplier_passthrough`',
    CONSTRAINT pk_warranty_policy PRIMARY KEY(`warranty_policy_id`)
) COMMENT 'Defines the standard warranty terms and conditions applicable to catalog items and product families — capturing warranty type (standard, extended, performance guarantee), warranty duration (months), coverage scope (parts only, parts and labor, full replacement), exclusion conditions, warranty registration requirement flag, and applicable geographic markets. Serves as the reference policy for warranty claims processed in the service domain and for customer-facing warranty documentation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`market` (
    `market_id` BIGINT COMMENT 'Unique surrogate identifier for each product-market assignment record in the catalog. Serves as the primary key for the product_market entity in the Silver Layer lakehouse.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: product_market defines target market and regional availability assignments for catalog items. catalog_item_code is a STRING reference to the parent catalog_item. Adding catalog_item_id FK normalizes t',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: product_market assignments can also be at the SKU level (sku_code STRING field). Adding sku_id FK (nullable) normalizes this reference. sku_code is removed as it is superseded by the FK join.',
    `aftermarket_support_available` BOOLEAN COMMENT 'Indicates whether aftermarket support services (spare parts, maintenance, repair) are available for the product in the target market. Supports service and aftermarket portfolio planning and customer service commitments.. Valid values are `true|false`',
    `channel_partner_required` BOOLEAN COMMENT 'Indicates whether the product must be sold through a certified channel partner or distributor in the target market, rather than through direct sales. Supports channel strategy enforcement and partner compliance management.. Valid values are `true|false`',
    `code` STRING COMMENT 'Unique code identifying the target geographic market or regional market cluster (e.g., country code, trade bloc code) where the product is authorized for sale. Used for go-to-market planning and export compliance screening.. Valid values are `^[A-Z]{2,10}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 Alpha-3 three-letter country code representing the specific country where the product is authorized for sale or distribution. Supports export compliance and regional regulatory screening.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when the product-market assignment record was first created in the system. Used for audit trail, data lineage, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the primary transaction currency used in the target market (e.g., USD, EUR, CNY, GBP). Supports multi-currency pricing and financial reporting.. Valid values are `^[A-Z]{3}$`',
    `customs_tariff_code` STRING COMMENT 'Harmonized System (HS) or country-specific customs tariff code applicable to the product in the target market. Used for import/export duty calculation, customs declarations, and trade compliance reporting.',
    `distribution_channel_code` STRING COMMENT 'Code identifying the distribution channel through which the product reaches the target market (e.g., direct sales, distributor, OEM, e-commerce). Aligns with SAP S/4HANA SD distribution channel configuration.',
    `eccn` STRING COMMENT 'Export Control Classification Number assigned to the product for the target market, used to determine export licensing requirements under the U.S. Export Administration Regulations (EAR). Supports trade compliance and export screening.. Valid values are `^[0-9][A-Z][0-9]{3}[a-z]?$`',
    `entry_date` DATE COMMENT 'The date on which the product became or is planned to become commercially available in the target market. Used for launch planning, go-to-market scheduling, and regional availability reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `exit_date` DATE COMMENT 'The date on which the product was or is planned to be withdrawn from the target market. Supports end-of-sale planning, regional lifecycle management, and export compliance deactivation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_control_flag` BOOLEAN COMMENT 'Indicates whether the product is subject to export control regulations (e.g., EAR, ITAR, EU Dual-Use Regulation) when sold in or shipped to the target market. Supports export compliance screening and trade compliance workflows.. Valid values are `true|false`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms) code defining the delivery and risk transfer conditions applicable to the product in the target market. Governs logistics responsibilities and export compliance for cross-border transactions.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `industry_segment` STRING COMMENT 'The target vertical industry segment for which this product is positioned in the specified market (e.g., Automotive, Food and Beverage, Oil and Gas, Building Automation). Drives industry-specific go-to-market strategies and product portfolio decisions.. Valid values are `Automotive|Food and Beverage|Oil and Gas|Building Automation|Transportation|Pharmaceutical|Semiconductor|Aerospace and Defense|Energy and Utilities|Water and Wastewater|Mining|Pulp and Paper|General Manufacturing|Other`',
    `labeling_requirement` STRING COMMENT 'Description of any market-specific labeling, marking, or packaging requirement applicable to the product in the target market (e.g., CE marking, UL listing, local language labeling, country-of-origin marking). Supports regulatory compliance and export screening.',
    `language_code` STRING COMMENT 'ISO 639-1 language code representing the primary language used for product documentation, labeling, and marketing materials in the target market (e.g., de for German, fr for French, zh-CN for Simplified Chinese).. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when the product-market assignment record was most recently updated. Supports change tracking, data freshness monitoring, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `launch_type` STRING COMMENT 'Classifies the nature of the product introduction into the target market — whether it is a new product launch, an extension of an existing line, a regional variant, a relaunch, or an aftermarket part introduction.. Valid values are `new_product|product_extension|variant|relaunch|aftermarket_part`',
    `lead_time_days` STRING COMMENT 'Standard order-to-delivery lead time in calendar days for the product in the target market. Accounts for regional logistics, customs clearance, and local distribution network characteristics. Supports Available-to-Promise (ATP) and Capable-to-Promise (CTP) calculations.. Valid values are `^[0-9]+$`',
    `list_price` DECIMAL(18,2) COMMENT 'Published list price for the product in the target market, expressed in the market currency. Represents the standard commercial price before discounts or market-specific adjustments. Supports regional pricing strategy and go-to-market planning.',
    `local_product_name` STRING COMMENT 'Market-specific or localized product name used in the target market, which may differ from the global catalog name due to branding, language, or regulatory requirements. Supports localized marketing and regulatory documentation.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity of the product that must be ordered in the target market per sales transaction. Reflects market-specific commercial policies, logistics constraints, or regulatory requirements.',
    `notes` STRING COMMENT 'Free-text field for capturing additional market-specific information, exceptions, or contextual notes related to the product-market assignment that are not captured in structured fields.',
    `price_effective_date` DATE COMMENT 'Date from which the market-specific list price is valid. Supports price validity management and ensures correct pricing is applied during order processing in the target market.. Valid values are `^d{4}-d{2}-d{2}$`',
    `region_code` STRING COMMENT 'Code representing the geographic sales region or trade zone (e.g., EMEA, APAC, AMER, DACH) to which this product-market assignment belongs. Supports regional portfolio management and go-to-market planning.',
    `regulatory_approval_date` DATE COMMENT 'Date on which the required regulatory approval or certification for the product in the target market was granted. Used for compliance tracking and audit purposes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `regulatory_approval_expiry_date` DATE COMMENT 'Expiry date of the regulatory approval or certification for the product in the target market. Triggers renewal workflows and prevents sale of non-compliant products after certification lapse.. Valid values are `^d{4}-d{2}-d{2}$`',
    `regulatory_approval_status` STRING COMMENT 'Status of regulatory approval or certification required for the product to be sold in the target market (e.g., CE marking approval, UL listing, local safety certification). Critical for export compliance and market authorization.. Valid values are `approved|pending|not_required|rejected|expired|under_review`',
    `sales_organization_code` STRING COMMENT 'SAP S/4HANA sales organization code responsible for managing the product in this market. Defines the legal entity and organizational unit accountable for sales and revenue recognition in the target market.',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this product-market assignment record originated (e.g., SAP S/4HANA SD, Siemens Teamcenter PLM, Salesforce CRM). Supports data lineage tracking and Silver Layer reconciliation.. Valid values are `SAP_S4HANA|TEAMCENTER_PLM|SALESFORCE_CRM|MANUAL|OTHER`',
    `source_system_key` STRING COMMENT 'The natural or business key of the product-market record as it exists in the originating source system (e.g., SAP S/4HANA material-sales org-distribution channel key). Enables traceability and reconciliation between the lakehouse Silver Layer and operational systems.',
    `status` STRING COMMENT 'Current operational status of the product-market assignment. Indicates whether the product is actively sold, planned for launch, discontinued, or suspended in the target market.. Valid values are `active|planned|discontinued|suspended|under_review|pending_approval`',
    `strategic_priority` STRING COMMENT 'Indicates the strategic importance of the product-market combination for the business (e.g., high, medium, low, not targeted). Used for portfolio prioritization, resource allocation, and go-to-market investment decisions.. Valid values are `high|medium|low|not_targeted`',
    `tax_classification_code` STRING COMMENT 'Market-specific tax classification code applied to the product in the target market (e.g., standard VAT, reduced VAT, exempt). Used for tax determination during order processing and financial reporting.',
    `variant_code` STRING COMMENT 'Code identifying a market-specific product variant or configuration required to meet local regulatory, technical, or commercial requirements (e.g., voltage adaptation, language labeling, regional certification variant). Supports regional product differentiation.',
    `warranty_months` STRING COMMENT 'Standard warranty period in months applicable to the product in the target market. May differ from the global warranty policy due to local consumer protection laws or market-specific commercial agreements.. Valid values are `^[0-9]+$`',
    CONSTRAINT pk_market PRIMARY KEY(`market_id`)
) COMMENT 'Defines the target market and regional availability assignments for catalog items — capturing the target industry segment (e.g., Automotive, Food and Beverage, Oil and Gas, Building Automation, Transportation), geographic market (country or region), market entry date, market exit date, and any market-specific product variant or labeling requirement. Supports global product portfolio management, regional go-to-market planning, and export compliance screening.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`substance_declaration` (
    `substance_declaration_id` BIGINT COMMENT 'Unique surrogate identifier for each product-substance declaration record',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to the catalog item that contains this hazardous substance',
    `hazardous_substance_id` BIGINT COMMENT 'Foreign key linking to the hazardous substance present in this catalog item',
    `compliance_status` STRING COMMENT 'Current regulatory compliance status of this substance within this specific catalog item: compliant, non_compliant, exemption_applied, under_review, pending_test',
    `concentration_ppm` DECIMAL(18,2) COMMENT 'Measured or declared concentration of the hazardous substance in this specific catalog item, expressed in parts per million. This value is specific to the product-substance combination.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this product-substance declaration record was created',
    `data_source_type` STRING COMMENT 'Origin of the substance concentration data for this catalog item: laboratory_test, supplier_declaration, material_database, engineering_estimate',
    `declaration_date` DATE COMMENT 'Date on which this substance declaration for this catalog item was formally recorded or received from the supplier',
    `exceeds_threshold` BOOLEAN COMMENT 'Indicates whether the measured substance concentration in this catalog item exceeds the regulatory threshold limit for the applicable regulation',
    `exemption_reference` STRING COMMENT 'Specific exemption clause or annex reference under the applicable regulation that permits the use of this substance in this catalog item (e.g., RoHS Annex III exemption 7c-I)',
    `material_application` STRING COMMENT 'Description of the specific material, component, or homogeneous material within this catalog item where the substance is present (e.g., PCB solder joints, cable insulation, housing plastic)',
    `review_due_date` DATE COMMENT 'Scheduled date by which this substance compliance record for this catalog item must be reviewed for accuracy and regulatory currency',
    `substance_function` STRING COMMENT 'Technical function or role of this hazardous substance within this specific catalog item (e.g., flame retardant, solder alloy, plasticizer, pigment)',
    `supplier_declaration_reference` STRING COMMENT 'Reference number or identifier of the supplier-provided material declaration document (e.g., IPC-1752A, IMDS ID) that documents this substance in this catalog item',
    `test_report_number` STRING COMMENT 'Reference number of the laboratory test report that documents the analytical measurement of this substance in this catalog item',
    `testing_laboratory` STRING COMMENT 'Name of the accredited laboratory that performed the substance concentration analysis for this catalog item',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp when this product-substance declaration record was last updated',
    `valid_from_date` DATE COMMENT 'Start date from which this substance declaration is considered valid and applicable for this catalog item',
    `valid_to_date` DATE COMMENT 'Expiry date after which this substance declaration must be reviewed and renewed for this catalog item',
    CONSTRAINT pk_substance_declaration PRIMARY KEY(`substance_declaration_id`)
) COMMENT 'This association product represents the compliance declaration between catalog_item and hazardous_substance. It captures the presence, concentration, and regulatory compliance status of specific hazardous substances within industrial manufacturing products. Each record links one catalog item to one hazardous substance with attributes that exist only in the context of this specific product-substance combination, supporting RoHS, REACH, and other chemical compliance programs.. Existence Justification: In industrial manufacturing, chemical compliance management requires tracking which hazardous substances are present in which products at what concentrations. This is a genuine operational M:N relationship: one catalog item contains multiple hazardous substances (e.g., a circuit board contains lead in solder, brominated flame retardants in plastics, and phthalates in cables), and one hazardous substance appears in many catalog items across the portfolio. The business actively manages these declarations through supplier material declarations (IPC-1752A), laboratory testing, and compliance documentation workflows.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`partner_authorization` (
    `partner_authorization_id` BIGINT COMMENT 'Unique surrogate identifier for each partner authorization record',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to the catalog item being authorized for sale through this channel partner',
    `channel_partner_id` BIGINT COMMENT 'Foreign key linking to the channel partner receiving authorization to sell this catalog item',
    `authorization_level` STRING COMMENT 'The level of authorization granted to this partner for this specific catalog item, indicating selling privileges and support entitlements. Values: AUTHORIZED (standard selling rights), PREFERRED (enhanced support and priority), RESTRICTED (limited selling conditions), CONDITIONAL (requires approval per transaction)',
    `certification_required` BOOLEAN COMMENT 'Indicates whether product-specific technical certification is required for this channel partner to sell this catalog item. True for complex automation systems, safety equipment, and specialized electrification solutions',
    `certification_status` STRING COMMENT 'Certification status of the channel partner for this specific catalog item or product family. Some complex products (automation systems, safety equipment) require product-specific technical certification beyond general partner certification. Values: CERTIFIED (partner certified to sell and support), NOT_REQUIRED (no special certification needed), IN_PROGRESS (certification in process), EXPIRED (certification lapsed)',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this authorization record was created in the system',
    `discount_tier` STRING COMMENT 'The discount tier code applicable to this specific catalog item for this channel partner, which may differ from the partners general discount tier based on product line specialization, volume commitments, or strategic agreements',
    `effective_date` DATE COMMENT 'The date from which this channel partner is authorized to sell this catalog item. Used to manage product line expansions and new product introductions to the partner network',
    `expiration_date` DATE COMMENT 'The date on which this authorization expires and must be renewed. Used to manage product lifecycle transitions, partner performance reviews, and authorization renewals',
    `last_modified_date` TIMESTAMP COMMENT 'Timestamp when this authorization record was last modified',
    `lead_time_days` BIGINT COMMENT 'Standard lead time in days for fulfilling orders of this catalog item to this channel partner, accounting for partner location, shipping method, and product availability',
    `max_discount_pct` DECIMAL(18,2) COMMENT 'Maximum discount percentage this channel partner is authorized to offer for this specific catalog item, which may vary by product based on margin profiles and competitive positioning',
    `min_order_quantity` BIGINT COMMENT 'Minimum order quantity required for this channel partner to purchase this catalog item, which may vary by partner tier and product type',
    `rebate_eligible` BOOLEAN COMMENT 'Indicates whether sales of this catalog item to this channel partner are eligible for volume rebates or back-end incentives',
    `sales_target_amount` DECIMAL(18,2) COMMENT 'The sales target amount for this specific catalog item (or product line) assigned to this channel partner for the current period, used for performance tracking and incentive calculation',
    `sales_target_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the sales target amount',
    `status` STRING COMMENT 'Current lifecycle status of this specific authorization. Values: ACTIVE (authorization in effect), SUSPENDED (temporarily inactive due to compliance or performance issues), EXPIRED (authorization period ended), PENDING_RENEWAL (awaiting renewal approval)',
    CONSTRAINT pk_partner_authorization PRIMARY KEY(`partner_authorization_id`)
) COMMENT 'This association product represents the authorization contract between catalog_item and channel_partner. It captures the specific terms under which a channel partner is authorized to sell a particular catalog item, including discount tiers, certification requirements, sales targets, and authorization validity periods. Each record links one catalog_item to one channel_partner with relationship-specific commercial terms that exist only in the context of this authorization.. Existence Justification: In industrial manufacturing channel sales, a single catalog item (e.g., a PLC controller or motor drive) is authorized for sale through multiple channel partners across different geographies and market segments, while each channel partner is authorized to sell hundreds or thousands of catalog items from various product lines. The authorization relationship itself carries critical commercial terms including product-specific discount tiers, certification requirements, sales targets, authorization validity periods, and minimum order quantities that vary by partner-product combination.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`quality_specification` (
    `quality_specification_id` BIGINT COMMENT 'Unique surrogate identifier for each product quality specification record',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to the catalog item being specified',
    `characteristic_id` BIGINT COMMENT 'Foreign key linking to the quality characteristic being applied',
    `quality_characteristic_id` BIGINT COMMENT 'Foreign key to the quality characteristic',
    `control_method` STRING COMMENT 'The quality control method applied to this characteristic for this catalog item, indicating the approach used to ensure conformance (Statistical Process Control, acceptance sampling, 100% inspection, audit, or none)',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this product quality specification record was created',
    `effective_date` DATE COMMENT 'The date from which this product quality specification becomes active and must be applied in production and inspection',
    `engineering_change_number` STRING COMMENT 'The ECN or ECO number that authorized this product quality specification, providing traceability to engineering change management',
    `expiration_date` DATE COMMENT 'The date after which this product quality specification is no longer valid, used to manage engineering changes and specification revisions',
    `inspection_frequency` STRING COMMENT 'The required inspection frequency for this characteristic on this catalog item, indicating how often measurements must be taken during production (first piece, every piece, sample-based, skip-lot, or periodic)',
    `last_modified_by` STRING COMMENT 'User ID or name of the quality engineer who last modified this product quality specification',
    `last_modified_date` TIMESTAMP COMMENT 'Timestamp when this product quality specification record was last modified',
    `lower_tolerance` DECIMAL(18,2) COMMENT 'The product-specific negative tolerance deviation from the specification value for this catalog item, which may be tighter than the master characteristic tolerance based on product requirements',
    `measurement_method` STRING COMMENT 'The product-specific measurement method or procedure for evaluating this characteristic on this catalog item, which may differ from the master characteristic method based on product design or accessibility',
    `specification_status` STRING COMMENT 'Current lifecycle status of this product quality specification indicating whether it is actively enforced in production',
    `specification_value` DECIMAL(18,2) COMMENT 'The product-specific nominal or target value for this quality characteristic, which may differ from the master characteristic nominal value when product engineering requires tighter or different specifications',
    `upper_tolerance` DECIMAL(18,2) COMMENT 'The product-specific positive tolerance deviation from the specification value for this catalog item, which may be tighter than the master characteristic tolerance based on product requirements',
    `created_by` STRING COMMENT 'User ID or name of the quality engineer who created this product quality specification',
    CONSTRAINT pk_quality_specification PRIMARY KEY(`quality_specification_id`)
) COMMENT 'This association product represents the quality specification contract between catalog items and quality characteristics. It captures the product-specific tolerance limits, measurement methods, and inspection requirements that define how each quality characteristic is applied to each catalog item. Each record links one catalog item to one quality characteristic with specification values that exist only in the context of this product-characteristic relationship.. Existence Justification: In industrial manufacturing, catalog items (products) have multiple quality characteristics that must be inspected (dimensional tolerances, material properties, functional tests, visual standards), and each quality characteristic is reused across multiple products. Quality engineers create product-specific quality specifications that define how each characteristic applies to each product, including product-specific tolerances, measurement methods, and inspection frequencies. This is a core quality planning activity managed as inspection plans and control plans.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`product_material_info_record` (
    `product_material_info_record_id` BIGINT COMMENT 'Primary key for product_material_info_record',
    `procurement_material_info_record_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for each material info record',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier providing this SKU',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to the SKU being sourced from this supplier',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this material info record was created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 currency code for the unit_price and last_purchase_price. May differ from supplier default currency for specific SKUs.',
    `effective_date` DATE COMMENT 'Date from which the current pricing and terms in this material info record become effective. Supports time-based pricing agreements.',
    `expiration_date` DATE COMMENT 'Date on which the current pricing and terms expire, requiring renegotiation or renewal. Null if no expiration.',
    `incoterms_code` STRING COMMENT 'International Commercial Terms code specific to this SKU-supplier combination, which may differ from the suppliers default incoterms.',
    `last_modified_date` TIMESTAMP COMMENT 'Timestamp of the most recent update to this material info record.',
    `last_purchase_price` DECIMAL(18,2) COMMENT 'The actual unit price paid in the most recent purchase order for this SKU from this supplier. Used for price variance analysis and negotiation benchmarking.',
    `lead_time_days` STRING COMMENT 'Standard procurement lead time in days from purchase order placement to delivery for this SKU from this supplier. Varies by supplier based on their production capacity and logistics.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Supplier-specific minimum order quantity for this SKU. Different suppliers may impose different MOQ requirements for the same SKU.',
    `preferred_supplier_flag` BOOLEAN COMMENT 'Indicates whether this supplier is the preferred source for this SKU among multiple approved suppliers. Used in automated sourcing decisions.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for managing this specific sourcing relationship.',
    `status` STRING COMMENT 'Current status of this sourcing relationship. Controls whether this supplier-SKU combination can be used in procurement processes.',
    `unit_price` DECIMAL(18,2) COMMENT 'Negotiated unit price for this SKU from this specific supplier, in the agreed currency. This price is supplier-specific and varies by supplier for the same SKU.',
    CONSTRAINT pk_product_material_info_record PRIMARY KEY(`product_material_info_record_id`)
) COMMENT 'This association product represents the sourcing agreement between a SKU and a supplier. It captures supplier-specific procurement terms, pricing, lead times, and conditions for each SKU-supplier combination. Each record links one SKU to one supplier with attributes that exist only in the context of this sourcing relationship. Aligned with SAP MM Material Info Record (EINE/EINA).. Existence Justification: In industrial manufacturing, a single SKU can be sourced from multiple suppliers to ensure supply chain resilience, competitive pricing, and risk mitigation. Conversely, each supplier provides multiple SKUs across different product categories. The business actively manages these sourcing relationships through material info records that capture supplier-specific pricing, lead times, minimum order quantities, and preferred supplier designations for each SKU-supplier combination.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`compliance` (
    `compliance_id` BIGINT COMMENT 'Unique system-generated identifier for each product compliance record',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to the catalog item that must comply with the regulatory requirement',
    `evidence_id` BIGINT COMMENT 'Reference identifier to the compliance evidence document, test report, certification, or audit record that demonstrates compliance with this requirement. May link to document management system, quality management system, or compliance repository.',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to the regulatory requirement that applies to the catalog item',
    `audit_notes` STRING COMMENT 'Free-text notes from compliance audits, third-party assessments, or internal reviews regarding this product-requirement compliance record. Captures auditor observations, recommendations, and follow-up actions.',
    `certification_expiry_date` DATE COMMENT 'Expiration date of the certification or approval for this product-requirement combination. Used to trigger re-certification workflows and maintain continuous compliance.',
    `certification_number` STRING COMMENT 'Official certification or approval number issued by the governing body or third-party auditor confirming compliance of this catalog item with this regulatory requirement. Applicable when certification_required is true in the regulatory requirement.',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this product compliance record was first created in the system.',
    `effective_date` DATE COMMENT 'Date on which this catalog item became compliant with this regulatory requirement, or the date from which compliance is required. Used for audit trails and to track when products entered compliance.',
    `last_updated_date` TIMESTAMP COMMENT 'Timestamp when this product compliance record was last modified, reflecting the most recent status change, verification, or audit update.',
    `next_verification_due_date` DATE COMMENT 'Scheduled date for the next compliance verification or audit of this product-requirement combination, calculated based on verification_date and the compliance_frequency from the regulatory requirement record.',
    `non_compliance_reason` STRING COMMENT 'Detailed explanation of why the catalog item does not comply with this regulatory requirement, including specific gaps, deficiencies, or missing controls. Populated when compliance_status is non_compliant.',
    `remediation_plan` STRING COMMENT 'Description of the corrective action plan, remediation steps, or compliance roadmap to bring the catalog item into compliance with this requirement. Includes target completion dates and responsible parties.',
    `responsible_party` STRING COMMENT 'Name, employee ID, or role of the individual or team responsible for ensuring and maintaining compliance of this catalog item with this regulatory requirement. May reference employee master data or organizational roles.',
    `status` STRING COMMENT 'Current compliance status of the catalog item against this specific regulatory requirement. Values: compliant (verified and current), non_compliant (fails requirement), in_progress (compliance work underway), pending_verification (awaiting audit), not_applicable (requirement does not apply), waived (exception granted), expired (compliance lapsed)',
    `verification_date` DATE COMMENT 'Date on which compliance with this requirement was last verified, tested, or audited. Used to track audit currency and determine when re-verification is needed based on compliance_frequency from the regulatory requirement.',
    `waiver_approved_by` STRING COMMENT 'Name or employee ID of the authority who approved the compliance waiver or exception for this product-requirement combination.',
    `waiver_expiry_date` DATE COMMENT 'Date on which the compliance waiver expires and full compliance is required.',
    `waiver_justification` STRING COMMENT 'Business or technical justification for why this catalog item has been granted a waiver or exception from this regulatory requirement. Populated when compliance_status is waived.',
    CONSTRAINT pk_compliance PRIMARY KEY(`compliance_id`)
) COMMENT 'This association product represents the compliance relationship between catalog items and regulatory requirements in industrial manufacturing. It captures the compliance status, verification evidence, and responsible parties for each product-requirement combination. Each record links one catalog item to one regulatory requirement with attributes that track compliance verification, effective dates, audit evidence, and accountability for regulatory adherence across global jurisdictions.. Existence Justification: In industrial manufacturing, each catalog item must comply with multiple regulatory requirements (ISO standards, safety certifications, environmental regulations, export controls) across different jurisdictions and product categories. Simultaneously, each regulatory requirement applies to many catalog items across product families and business units. Compliance teams actively manage these relationships by tracking verification status, maintaining audit evidence, assigning responsible parties, and monitoring certification expiry dates for each product-requirement combination.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`product`.`market_authorization` (
    `market_authorization_id` BIGINT COMMENT 'Unique system-generated identifier for each market authorization record',
    `jurisdiction_id` BIGINT COMMENT 'Foreign key linking to the jurisdiction in which the SKU is authorized',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to the SKU that is authorized for market access',
    `authorization_date` DATE COMMENT 'Date on which the market authorization was granted by the regulatory authority',
    `authorized_by` STRING COMMENT 'Name or identifier of the compliance officer or regulatory affairs manager who processed and approved this authorization record',
    `certification_type` STRING COMMENT 'Type of certification or authorization required for this SKU in this jurisdiction (e.g., CE Marking, UL Listing, CCC, product registration)',
    `created_date` TIMESTAMP COMMENT 'System timestamp when this market authorization record was created',
    `expiry_date` DATE COMMENT 'Date on which the market authorization expires and must be renewed to continue sales',
    `last_audit_date` DATE COMMENT 'Date of the most recent compliance audit or regulatory inspection for this SKU-jurisdiction authorization',
    `last_updated_date` TIMESTAMP COMMENT 'System timestamp when this market authorization record was last modified',
    `local_restrictions` STRING COMMENT 'Jurisdiction-specific restrictions, conditions, or limitations imposed on the sale, distribution, or use of this SKU (e.g., quantity limits, customer type restrictions, usage restrictions)',
    `next_audit_date` DATE COMMENT 'Scheduled date for the next compliance audit or regulatory inspection',
    `notes` STRING COMMENT 'Free-text notes capturing additional context, special conditions, or historical information about this market authorization',
    `registration_number` STRING COMMENT 'Official registration or certification number issued by the jurisdictional regulatory authority for this SKU',
    `regulatory_authority` STRING COMMENT 'Name of the specific regulatory body or agency within the jurisdiction that issued the authorization',
    `renewal_frequency_months` STRING COMMENT 'Number of months between required renewals if renewal_required is true',
    `renewal_required` BOOLEAN COMMENT 'Indicates whether this authorization requires periodic renewal to maintain market access',
    `status` STRING COMMENT 'Current regulatory status of the market authorization indicating whether the SKU is legally permitted to be sold in the jurisdiction',
    CONSTRAINT pk_market_authorization PRIMARY KEY(`market_authorization_id`)
) COMMENT 'This association product represents the regulatory approval and authorization for a specific SKU to be sold, distributed, or operated within a specific legal jurisdiction. It captures the market authorization status, registration numbers, authorization dates, expiry dates, and jurisdiction-specific restrictions that exist only in the context of this SKU-jurisdiction relationship. Each record links one SKU to one jurisdiction with attributes that govern compliance, order fulfillment validation, and market access control.. Existence Justification: In industrial manufacturing operations, a single SKU can be authorized for sale in multiple jurisdictions (e.g., a motor variant sold in EU, US, China), and each jurisdiction has thousands of authorized SKUs. The compliance and sales teams actively manage market authorization records as operational entities, tracking authorization status, registration numbers, expiry dates, and jurisdiction-specific restrictions for each SKU-jurisdiction combination. These authorization records are created, updated, and queried as part of order fulfillment validation, regulatory compliance audits, and market access planning.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ADD CONSTRAINT `fk_product_hierarchy_classification_id` FOREIGN KEY (`classification_id`) REFERENCES `manufacturing_ecm`.`product`.`classification`(`classification_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ADD CONSTRAINT `fk_product_product_configuration_change_notice_id` FOREIGN KEY (`change_notice_id`) REFERENCES `manufacturing_ecm`.`product`.`change_notice`(`change_notice_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ADD CONSTRAINT `fk_product_price_list_item_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ADD CONSTRAINT `fk_product_price_list_item_product_price_list_id` FOREIGN KEY (`product_price_list_id`) REFERENCES `manufacturing_ecm`.`product`.`product_price_list`(`product_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ADD CONSTRAINT `fk_product_discount_schedule_product_price_list_id` FOREIGN KEY (`product_price_list_id`) REFERENCES `manufacturing_ecm`.`product`.`product_price_list`(`product_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`category` ADD CONSTRAINT `fk_product_category_warranty_policy_id` FOREIGN KEY (`warranty_policy_id`) REFERENCES `manufacturing_ecm`.`product`.`warranty_policy`(`warranty_policy_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ADD CONSTRAINT `fk_product_product_regulatory_certification_change_notice_id` FOREIGN KEY (`change_notice_id`) REFERENCES `manufacturing_ecm`.`product`.`change_notice`(`change_notice_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ADD CONSTRAINT `fk_product_product_document_change_notice_id` FOREIGN KEY (`change_notice_id`) REFERENCES `manufacturing_ecm`.`product`.`change_notice`(`change_notice_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ADD CONSTRAINT `fk_product_product_document_product_regulatory_certification_id` FOREIGN KEY (`product_regulatory_certification_id`) REFERENCES `manufacturing_ecm`.`product`.`product_regulatory_certification`(`product_regulatory_certification_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ADD CONSTRAINT `fk_product_substitution_change_notice_id` FOREIGN KEY (`change_notice_id`) REFERENCES `manufacturing_ecm`.`product`.`change_notice`(`change_notice_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ADD CONSTRAINT `fk_product_bundle_component_bundle_id` FOREIGN KEY (`bundle_id`) REFERENCES `manufacturing_ecm`.`product`.`bundle`(`bundle_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ADD CONSTRAINT `fk_product_bundle_component_change_notice_id` FOREIGN KEY (`change_notice_id`) REFERENCES `manufacturing_ecm`.`product`.`change_notice`(`change_notice_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ADD CONSTRAINT `fk_product_sales_org_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ADD CONSTRAINT `fk_product_uom_change_notice_id` FOREIGN KEY (`change_notice_id`) REFERENCES `manufacturing_ecm`.`product`.`change_notice`(`change_notice_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`media` ADD CONSTRAINT `fk_product_media_change_notice_id` FOREIGN KEY (`change_notice_id`) REFERENCES `manufacturing_ecm`.`product`.`change_notice`(`change_notice_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ADD CONSTRAINT `fk_product_attribute_change_notice_id` FOREIGN KEY (`change_notice_id`) REFERENCES `manufacturing_ecm`.`product`.`change_notice`(`change_notice_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ADD CONSTRAINT `fk_product_attribute_classification_id` FOREIGN KEY (`classification_id`) REFERENCES `manufacturing_ecm`.`product`.`classification`(`classification_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ADD CONSTRAINT `fk_product_launch_change_notice_id` FOREIGN KEY (`change_notice_id`) REFERENCES `manufacturing_ecm`.`product`.`change_notice`(`change_notice_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ADD CONSTRAINT `fk_product_substance_declaration_hazardous_substance_id` FOREIGN KEY (`hazardous_substance_id`) REFERENCES `manufacturing_ecm`.`product`.`hazardous_substance`(`hazardous_substance_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`product` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `manufacturing_ecm`.`product` SET TAGS ('dbx_domain' = 'product');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` SET TAGS ('dbx_subdomain' = 'catalog_structure');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` SET TAGS ('dbx_original_name' = 'product_hierarchy');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Product Hierarchy ID');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `classification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Lifecycle Management (PLM) Classification ID');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `business_segment` SET TAGS ('dbx_business_glossary_term' = 'Business Segment');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Node Description');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `division_code` SET TAGS ('dbx_business_glossary_term' = 'Product Division Code');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `division_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Export Control Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `external_code` SET TAGS ('dbx_business_glossary_term' = 'External Hierarchy Code');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `go_to_market_channel` SET TAGS ('dbx_business_glossary_term' = 'Go-to-Market Channel');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `go_to_market_channel` SET TAGS ('dbx_value_regex' = 'direct|distributor|oem|online|partner|mixed');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `gpc_code` SET TAGS ('dbx_business_glossary_term' = 'Global Product Classification (GPC) Code');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `gpc_code` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `is_leaf_node` SET TAGS ('dbx_business_glossary_term' = 'Is Leaf Node Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `is_leaf_node` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `is_revenue_reporting_node` SET TAGS ('dbx_business_glossary_term' = 'Is Revenue Reporting Node Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `is_revenue_reporting_node` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `level` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Level');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `level` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `level_type` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Level Type');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `level_type` SET TAGS ('dbx_value_regex' = 'division|family|group|line');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_business_glossary_term' = 'Product Lifecycle Stage');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_value_regex' = 'introduction|growth|maturity|decline|end_of_life');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `long_name` SET TAGS ('dbx_business_glossary_term' = 'Long Name');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `long_name` SET TAGS ('dbx_value_regex' = '.{1,40}');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `node_code` SET TAGS ('dbx_business_glossary_term' = 'Product Hierarchy Node Code');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `node_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,18}$');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `product_manager` SET TAGS ('dbx_business_glossary_term' = 'Product Manager');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `regulatory_scope` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Scope');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `responsible_org_unit` SET TAGS ('dbx_business_glossary_term' = 'Responsible Organizational Unit');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `sap_hierarchy_path` SET TAGS ('dbx_business_glossary_term' = 'SAP Product Hierarchy Path');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `short_name` SET TAGS ('dbx_business_glossary_term' = 'Short Name');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `short_name` SET TAGS ('dbx_value_regex' = '.{1,20}');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `sort_order` SET TAGS ('dbx_business_glossary_term' = 'Sort Order');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `sort_order` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER_PLM|MANUAL|MIGRATION');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Node Status');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|planned|obsolete|under_review');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `strategic_initiative` SET TAGS ('dbx_business_glossary_term' = 'Strategic Initiative');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `technology_platform` SET TAGS ('dbx_business_glossary_term' = 'Technology Platform');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `unspsc_code` SET TAGS ('dbx_business_glossary_term' = 'United Nations Standard Products and Services Code (UNSPSC)');
ALTER TABLE `manufacturing_ecm`.`product`.`hierarchy` ALTER COLUMN `unspsc_code` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` SET TAGS ('dbx_subdomain' = 'catalog_structure');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` SET TAGS ('dbx_original_name' = 'product_configuration');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `product_configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Product Configuration ID');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `change_notice_id` SET TAGS ('dbx_business_glossary_term' = 'Product Change Notice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `cad_model_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Model ID');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `cad_model_id` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,50}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `applicable_certification` SET TAGS ('dbx_business_glossary_term' = 'Applicable Certification');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'PENDING|APPROVED|REJECTED|UNDER_REVIEW|WITHDRAWN');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `compatible_product_families` SET TAGS ('dbx_business_glossary_term' = 'Compatible Product Families');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `constraint_rule_description` SET TAGS ('dbx_business_glossary_term' = 'Constraint Rule Description');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `constraint_rule_expression` SET TAGS ('dbx_business_glossary_term' = 'Constraint Rule Expression');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `constraint_type` SET TAGS ('dbx_business_glossary_term' = 'Constraint Type');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `constraint_type` SET TAGS ('dbx_value_regex' = 'INCOMPATIBLE|REQUIRES|EXCLUDES|CONDITIONAL|MANDATORY_IF|OPTIONAL');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `cpq_visibility_rule` SET TAGS ('dbx_business_glossary_term' = 'Configure-Price-Quote (CPQ) Visibility Rule');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `display_sequence` SET TAGS ('dbx_business_glossary_term' = 'Display Sequence');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `display_sequence` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification Number (ECCN)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `feature_code` SET TAGS ('dbx_business_glossary_term' = 'Feature Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `feature_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,40}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `feature_description` SET TAGS ('dbx_business_glossary_term' = 'Feature Description');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `is_default_value` SET TAGS ('dbx_business_glossary_term' = 'Is Default Value Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `is_default_value` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Is Mandatory Selection Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Days');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Status');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'DRAFT|ACTIVE|UNDER_REVIEW|DEPRECATED|OBSOLETE|SUPERSEDED');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `model_name` SET TAGS ('dbx_business_glossary_term' = 'Configuration Model Name');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `model_version` SET TAGS ('dbx_business_glossary_term' = 'Configuration Model Version');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `model_version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `option_class_code` SET TAGS ('dbx_business_glossary_term' = 'Option Class Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `option_class_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,30}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `option_class_name` SET TAGS ('dbx_business_glossary_term' = 'Option Class Name');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `pricing_currency` SET TAGS ('dbx_business_glossary_term' = 'Pricing Currency');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `pricing_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `pricing_impact_type` SET TAGS ('dbx_business_glossary_term' = 'Pricing Impact Type');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `pricing_impact_type` SET TAGS ('dbx_value_regex' = 'FIXED_ADDER|PERCENTAGE_ADDER|MULTIPLIER|BASE_PRICE|NO_IMPACT');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `pricing_impact_value` SET TAGS ('dbx_business_glossary_term' = 'Pricing Impact Value');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `pricing_impact_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `product_type` SET TAGS ('dbx_business_glossary_term' = 'Product Type');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `product_type` SET TAGS ('dbx_value_regex' = 'ETO|ATO|MTO|MTS|CTO');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `sap_vc_class_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Variant Configuration (VC) Class Number');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `sap_vc_class_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,40}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `selection_cardinality` SET TAGS ('dbx_business_glossary_term' = 'Selection Cardinality');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `selection_cardinality` SET TAGS ('dbx_value_regex' = 'SINGLE|MULTI|EXACTLY_ONE|AT_LEAST_ONE|AT_MOST_ONE');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER|OPCENTER|CPQ|SALESFORCE');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `teamcenter_config_object_reference` SET TAGS ('dbx_business_glossary_term' = 'Siemens Teamcenter Configuration Object ID');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `teamcenter_config_object_reference` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{4,60}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ALTER COLUMN `weight_impact_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight Impact Kilograms (kg)');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` SET TAGS ('dbx_subdomain' = 'catalog_structure');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` SET TAGS ('dbx_original_name' = 'product_lifecycle');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `lifecycle_id` SET TAGS ('dbx_business_glossary_term' = 'Product Lifecycle ID');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `actual_end_of_sale_date` SET TAGS ('dbx_business_glossary_term' = 'Actual End-of-Sale (EOS) Date');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `actual_end_of_sale_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `actual_eol_date` SET TAGS ('dbx_business_glossary_term' = 'Actual End-of-Life (EOL) Date');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `actual_eol_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `aftermarket_support_end_date` SET TAGS ('dbx_business_glossary_term' = 'Aftermarket Support End Date');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `aftermarket_support_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Stage Approval Date');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Stage Approval Authority');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `ce_marking_status` SET TAGS ('dbx_business_glossary_term' = 'CE Marking Status');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `ce_marking_status` SET TAGS ('dbx_value_regex' = 'MARKED|NOT_MARKED|IN_PROGRESS|EXPIRED|NOT_APPLICABLE');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `customer_notification_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Date');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `customer_notification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `customer_notification_status` SET TAGS ('dbx_business_glossary_term' = 'Customer End-of-Life Notification Status');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `customer_notification_status` SET TAGS ('dbx_value_regex' = 'NOT_REQUIRED|PENDING|IN_PROGRESS|COMPLETED|ACKNOWLEDGED');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `erp_material_number` SET TAGS ('dbx_business_glossary_term' = 'Enterprise Resource Planning (ERP) Material Number');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `inventory_wind_down_status` SET TAGS ('dbx_business_glossary_term' = 'Inventory Wind-Down Status');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `inventory_wind_down_status` SET TAGS ('dbx_value_regex' = 'NOT_STARTED|IN_PROGRESS|COMPLETED|NOT_APPLICABLE');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `is_current_stage` SET TAGS ('dbx_business_glossary_term' = 'Is Current Lifecycle Stage Indicator');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `is_current_stage` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `last_time_buy_date` SET TAGS ('dbx_business_glossary_term' = 'Last Time Buy (LTB) Date');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `last_time_buy_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `market_region` SET TAGS ('dbx_business_glossary_term' = 'Market Region');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `planned_end_of_sale_date` SET TAGS ('dbx_business_glossary_term' = 'Planned End-of-Sale (EOS) Date');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `planned_end_of_sale_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `planned_eol_date` SET TAGS ('dbx_business_glossary_term' = 'Planned End-of-Life (EOL) Date');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `planned_eol_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `plm_object_reference` SET TAGS ('dbx_business_glossary_term' = 'Product Lifecycle Management (PLM) Object ID');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `previous_stage_code` SET TAGS ('dbx_business_glossary_term' = 'Previous Product Lifecycle Stage Code');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `previous_stage_code` SET TAGS ('dbx_value_regex' = 'CONCEPT|INTRODUCTION|GROWTH|MATURITY|DECLINE|END_OF_SALE|END_OF_LIFE');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `reach_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Compliance Status');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `reach_compliance_status` SET TAGS ('dbx_value_regex' = 'COMPLIANT|NON_COMPLIANT|EXEMPT|UNDER_REVIEW|NOT_APPLICABLE');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `regulatory_hold_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Hold Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `regulatory_hold_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `regulatory_hold_reason` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Hold Reason');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `responsible_business_unit` SET TAGS ('dbx_business_glossary_term' = 'Responsible Business Unit');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `responsible_product_manager` SET TAGS ('dbx_business_glossary_term' = 'Responsible Product Manager');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `rohs_compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliance Status');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `rohs_compliance_status` SET TAGS ('dbx_value_regex' = 'COMPLIANT|NON_COMPLIANT|EXEMPT|UNDER_REVIEW|NOT_APPLICABLE');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'TEAMCENTER_PLM|SAP_S4HANA|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `spare_parts_availability_commitment` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Availability Commitment');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `spare_parts_availability_commitment` SET TAGS ('dbx_value_regex' = 'FULL|LIMITED|CRITICAL_ONLY|NONE');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `stage_code` SET TAGS ('dbx_business_glossary_term' = 'Product Lifecycle Management (PLM) Stage Code');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `stage_code` SET TAGS ('dbx_value_regex' = 'CONCEPT|INTRODUCTION|GROWTH|MATURITY|DECLINE|END_OF_SALE|END_OF_LIFE');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `stage_effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Stage Effective End Date');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `stage_effective_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `stage_effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Stage Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `stage_effective_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `stage_name` SET TAGS ('dbx_business_glossary_term' = 'Product Lifecycle Stage Name');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `stage_name` SET TAGS ('dbx_value_regex' = 'Concept|Introduction|Growth|Maturity|Decline|End of Sale|End of Life');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `successor_sku` SET TAGS ('dbx_business_glossary_term' = 'Successor Stock Keeping Unit (SKU)');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `successor_sku` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,50}$');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `transition_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Stage Transition Reason Code');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `transition_reason_code` SET TAGS ('dbx_value_regex' = 'MARKET_DEMAND|TECHNOLOGY_OBSOLESCENCE|REGULATORY_COMPLIANCE|PORTFOLIO_RATIONALIZATION|SUCCESSOR_PRODUCT|SUPPLY_CHAIN|STRATEGIC_DECISION|CUSTOMER_REQUEST|OTHER');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `transition_reason_notes` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Stage Transition Reason Notes');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `ul_certification_status` SET TAGS ('dbx_business_glossary_term' = 'Underwriters Laboratories (UL) Certification Status');
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ALTER COLUMN `ul_certification_status` SET TAGS ('dbx_value_regex' = 'CERTIFIED|NOT_CERTIFIED|IN_PROGRESS|EXPIRED|NOT_APPLICABLE');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` SET TAGS ('dbx_subdomain' = 'commercial_pricing');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `product_price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List ID');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Price List Approval Status');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending_approval|approved|rejected|withdrawn');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Price List Approval Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `base_price_list_code` SET TAGS ('dbx_business_glossary_term' = 'Base Price List Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `base_price_list_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Price List Category');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'finished_goods|spare_parts|automation_systems|electrification_solutions|smart_infrastructure|services|accessories');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Price List Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `condition_type_code` SET TAGS ('dbx_business_glossary_term' = 'Condition Type Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `condition_type_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `customer_group_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Group Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `customer_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Price List Description');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_value_regex' = '^-?d{1,3}.d{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `division_code` SET TAGS ('dbx_business_glossary_term' = 'Division Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `division_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Price List Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Price List Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `external_reference_code` SET TAGS ('dbx_business_glossary_term' = 'External Reference Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `is_default` SET TAGS ('dbx_business_glossary_term' = 'Is Default Price List');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `is_default` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `is_locked` SET TAGS ('dbx_business_glossary_term' = 'Is Price List Locked');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `is_locked` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `minimum_order_value` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Value');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `minimum_order_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `minimum_order_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Price List Name');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Price List Notes');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `pricing_procedure_code` SET TAGS ('dbx_business_glossary_term' = 'Pricing Procedure Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `pricing_procedure_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `source_system_price_list_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Price List ID');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Price List Status');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|inactive|expired|superseded|under_review');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `tax_classification_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Classification Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `tax_classification_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Price List Type');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'standard_list_price|distributor_price|oem_price|intercompany_transfer_price|promotional_price|contract_price');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `type` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Price List Version Number');
ALTER TABLE `manufacturing_ecm`.`product`.`product_price_list` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` SET TAGS ('dbx_subdomain' = 'commercial_pricing');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `price_list_item_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Item ID');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Product Hierarchy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `product_price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `calculation_type` SET TAGS ('dbx_business_glossary_term' = 'Calculation Type');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `calculation_type` SET TAGS ('dbx_value_regex' = 'fixed_amount|percentage|quantity_dependent|formula|free_goods');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `condition_type_code` SET TAGS ('dbx_business_glossary_term' = 'Condition Type Code');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `condition_type_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `cpq_eligible` SET TAGS ('dbx_business_glossary_term' = 'Configure Price Quote (CPQ) Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `cpq_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `customer_group_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Group Code');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `customer_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `floor_price` SET TAGS ('dbx_business_glossary_term' = 'Floor Price');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `floor_price` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `floor_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `intercompany_flag` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Pricing Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `intercompany_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `item_number` SET TAGS ('dbx_business_glossary_term' = 'Price List Item Number');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `item_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `min_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `min_order_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `price_includes_tax` SET TAGS ('dbx_business_glossary_term' = 'Price Includes Tax Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `price_includes_tax` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `price_type` SET TAGS ('dbx_business_glossary_term' = 'Price Type');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `price_type` SET TAGS ('dbx_value_regex' = 'list_price|floor_price|rrp|transfer_price|contract_price|promotional_price');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `pricing_procedure_code` SET TAGS ('dbx_business_glossary_term' = 'Pricing Procedure Code');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `pricing_procedure_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `pricing_unit_quantity` SET TAGS ('dbx_business_glossary_term' = 'Pricing Unit Quantity');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `pricing_unit_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `pricing_uom` SET TAGS ('dbx_business_glossary_term' = 'Pricing Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `pricing_uom` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `rebate_eligible` SET TAGS ('dbx_business_glossary_term' = 'Rebate Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `rebate_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `rrp` SET TAGS ('dbx_business_glossary_term' = 'Recommended Retail Price (RRP)');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `rrp` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `rrp` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `sales_org_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `sales_org_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `scale_basis` SET TAGS ('dbx_business_glossary_term' = 'Scale Basis');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `scale_basis` SET TAGS ('dbx_value_regex' = 'quantity|value|weight|volume');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `scale_from_quantity` SET TAGS ('dbx_business_glossary_term' = 'Scale From Quantity');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `scale_from_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `scale_to_quantity` SET TAGS ('dbx_business_glossary_term' = 'Scale To Quantity');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `scale_to_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `scale_type` SET TAGS ('dbx_business_glossary_term' = 'Scale Type');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `scale_type` SET TAGS ('dbx_value_regex' = 'graduated|base_scale|group_scale|none');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CPQ|MANUAL|ARIBA|LEGACY');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Price List Item Status');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_approval|superseded|expired|draft');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `surcharge_amount` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Amount');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `surcharge_amount` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `surcharge_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `surcharge_percent` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Percentage');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `surcharge_percent` SET TAGS ('dbx_value_regex' = '^-?[0-9]{1,3}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `surcharge_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `tax_classification_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Classification Code');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `tax_classification_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `unit_price` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` SET TAGS ('dbx_subdomain' = 'commercial_pricing');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `discount_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Discount Schedule ID');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `product_price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `approval_level` SET TAGS ('dbx_business_glossary_term' = 'Approval Level');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `approval_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3|executive');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|approved|rejected|escalated');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `combinability_rule` SET TAGS ('dbx_business_glossary_term' = 'Combinability Rule');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `combinability_rule` SET TAGS ('dbx_value_regex' = 'exclusive|additive|best_price|multiplicative');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `cpq_rule_code` SET TAGS ('dbx_business_glossary_term' = 'Salesforce CPQ Rule ID');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `customer_scope_type` SET TAGS ('dbx_business_glossary_term' = 'Customer Scope Type');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `customer_scope_type` SET TAGS ('dbx_value_regex' = 'customer_class|customer_group|sales_area|channel|all_customers');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `customer_scope_value` SET TAGS ('dbx_business_glossary_term' = 'Customer Scope Value');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Discount Schedule Description');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `discount_category` SET TAGS ('dbx_business_glossary_term' = 'Discount Category');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `discount_category` SET TAGS ('dbx_value_regex' = 'customer_class|volume|promotional|channel_partner|trade_in|contract|seasonal|clearance');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `discount_rate` SET TAGS ('dbx_business_glossary_term' = 'Discount Rate');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `discount_rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `discount_rate_unit` SET TAGS ('dbx_business_glossary_term' = 'Discount Rate Unit');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `discount_rate_unit` SET TAGS ('dbx_value_regex' = 'percent|currency_per_unit|currency_per_order');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `discount_type` SET TAGS ('dbx_business_glossary_term' = 'Discount Type');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `discount_type` SET TAGS ('dbx_value_regex' = 'percentage|absolute_amount|rebate|free_goods|promotional|surcharge');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `is_stackable` SET TAGS ('dbx_business_glossary_term' = 'Is Stackable Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `is_stackable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `max_discount_ceiling` SET TAGS ('dbx_business_glossary_term' = 'Maximum Discount Ceiling');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `max_discount_ceiling` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `min_discount_floor` SET TAGS ('dbx_business_glossary_term' = 'Minimum Discount Floor');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `min_discount_floor` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Discount Schedule Name');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `pricing_condition_type` SET TAGS ('dbx_business_glossary_term' = 'SAP Pricing Condition Type');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `pricing_condition_type` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `priority_rank` SET TAGS ('dbx_business_glossary_term' = 'Priority Rank');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `priority_rank` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `product_scope_type` SET TAGS ('dbx_business_glossary_term' = 'Product Scope Type');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `product_scope_type` SET TAGS ('dbx_value_regex' = 'sku|product_group|hierarchy_node|all_products');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `product_scope_value` SET TAGS ('dbx_business_glossary_term' = 'Product Scope Value');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `rebate_basis` SET TAGS ('dbx_business_glossary_term' = 'Rebate Basis');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `rebate_basis` SET TAGS ('dbx_value_regex' = 'net_sales|gross_sales|quantity|none');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `rebate_settlement_frequency` SET TAGS ('dbx_business_glossary_term' = 'Rebate Settlement Frequency');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `rebate_settlement_frequency` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annual|annual|on_demand');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `requires_manual_override` SET TAGS ('dbx_business_glossary_term' = 'Requires Manual Override Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `requires_manual_override` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `sales_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `schedule_code` SET TAGS ('dbx_business_glossary_term' = 'Discount Schedule Code');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `schedule_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CPQ|MANUAL');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Discount Schedule Status');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|active|suspended|expired|cancelled|archived');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `volume_threshold_amount` SET TAGS ('dbx_business_glossary_term' = 'Volume Threshold Amount');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `volume_threshold_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`discount_schedule` ALTER COLUMN `volume_threshold_qty` SET TAGS ('dbx_business_glossary_term' = 'Volume Threshold Quantity');
ALTER TABLE `manufacturing_ecm`.`product`.`category` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`product`.`category` SET TAGS ('dbx_subdomain' = 'catalog_structure');
ALTER TABLE `manufacturing_ecm`.`product`.`category` SET TAGS ('dbx_original_name' = 'product_category');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Product Category Identifier');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `class_id` SET TAGS ('dbx_business_glossary_term' = 'Product Lifecycle Management (PLM) Classification Identifier');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `warranty_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `applicable_region` SET TAGS ('dbx_business_glossary_term' = 'Applicable Region');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `business_division` SET TAGS ('dbx_business_glossary_term' = 'Business Division');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Category Code');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `default_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Default Currency Code');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `default_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `default_uom` SET TAGS ('dbx_business_glossary_term' = 'Default Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Category Description');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Export Control Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `external_category_code` SET TAGS ('dbx_business_glossary_term' = 'External Category Code');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `gpc_code` SET TAGS ('dbx_business_glossary_term' = 'Global Product Classification (GPC) Code');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `gpc_code` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Level');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `hierarchy_path` SET TAGS ('dbx_business_glossary_term' = 'Category Hierarchy Path');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `image_url` SET TAGS ('dbx_business_glossary_term' = 'Category Image URL');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `image_url` SET TAGS ('dbx_value_regex' = '^https?://.+$');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `industry_segment` SET TAGS ('dbx_business_glossary_term' = 'Industry Segment');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `industry_segment` SET TAGS ('dbx_value_regex' = 'factory_automation|building_technologies|transportation|energy_utilities|process_industries|discrete_manufacturing|smart_infrastructure|cross_industry');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `is_leaf_node` SET TAGS ('dbx_business_glossary_term' = 'Is Leaf Node Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `is_leaf_node` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `is_orderable` SET TAGS ('dbx_business_glossary_term' = 'Is Orderable Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `is_orderable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `is_procurement_category` SET TAGS ('dbx_business_glossary_term' = 'Is Procurement Category Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `is_procurement_category` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_business_glossary_term' = 'Category Lifecycle Stage');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_value_regex' = 'introduction|growth|maturity|decline|end_of_life|obsolete');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Category Name');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `product_line` SET TAGS ('dbx_business_glossary_term' = 'Product Line');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `regulatory_scope` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Scope');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `regulatory_scope` SET TAGS ('dbx_value_regex' = 'ce_marking|rohs|reach|ul_certification|iec_62443|iso_9001|none|multiple');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `sap_material_group` SET TAGS ('dbx_business_glossary_term' = 'SAP Material Group (MATKL)');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `sap_material_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,9}$');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `sort_order` SET TAGS ('dbx_business_glossary_term' = 'Sort Order');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `sort_order` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER_PLM|SALESFORCE_CRM|SAP_ARIBA|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `spend_category_code` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Code');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Category Status');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|discontinued|draft');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `tax_classification` SET TAGS ('dbx_business_glossary_term' = 'Tax Classification');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Category Type');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'commercial|operational|regulatory|aftermarket|internal');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `unspsc_code` SET TAGS ('dbx_business_glossary_term' = 'United Nations Standard Products and Services Code (UNSPSC)');
ALTER TABLE `manufacturing_ecm`.`product`.`category` ALTER COLUMN `unspsc_code` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` SET TAGS ('dbx_subdomain' = 'regulatory_compliance');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `product_regulatory_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Certification ID');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `application_id` SET TAGS ('dbx_business_glossary_term' = 'Application Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `change_notice_id` SET TAGS ('dbx_business_glossary_term' = 'Product Change Notice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `regulatory_obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Obligation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `applicable_directives` SET TAGS ('dbx_business_glossary_term' = 'Applicable Directives / Standards');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `applicable_markets` SET TAGS ('dbx_business_glossary_term' = 'Applicable Markets / Regions');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `certificate_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Certificate Document Reference');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Certificate Number');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `certification_cost` SET TAGS ('dbx_business_glossary_term' = 'Certification Cost');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `certification_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `certification_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Certification Cost Currency');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `certification_cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `certification_standard` SET TAGS ('dbx_business_glossary_term' = 'Certification Standard');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `certification_type` SET TAGS ('dbx_business_glossary_term' = 'Certification Type');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `certification_type` SET TAGS ('dbx_value_regex' = 'CE Marking|UL Listing|RoHS Compliance|REACH Declaration|CSA Certification|CCC Certification|EAC Certification|UL Recognition|FCC Authorization|ATEX Certification|IECEx Certification|KC Certification|PSE Certification|BIS Certification|INMETRO Cert...');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `country_of_manufacture` SET TAGS ('dbx_business_glossary_term' = 'Country of Manufacture');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `country_of_manufacture` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `declaration_of_conformity_reference` SET TAGS ('dbx_business_glossary_term' = 'Declaration of Conformity (DoC) Reference');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Export Control Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `hazardous_substance_declaration` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Substance Declaration Status');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `hazardous_substance_declaration` SET TAGS ('dbx_value_regex' = 'Full Compliance|Exemption Applied|Non-Applicable|Under Assessment');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Certificate Issue Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `issuing_body` SET TAGS ('dbx_business_glossary_term' = 'Issuing Body');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `issuing_body_accreditation_number` SET TAGS ('dbx_business_glossary_term' = 'Issuing Body Accreditation Number');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `last_surveillance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Surveillance Audit Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `last_surveillance_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `manufacturing_site_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Site Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `next_surveillance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Surveillance Audit Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `next_surveillance_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `reach_svhc_flag` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Substance of Very High Concern (SVHC) Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `reach_svhc_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `renewal_submission_date` SET TAGS ('dbx_business_glossary_term' = 'Renewal Submission Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `renewal_submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `responsible_compliance_owner` SET TAGS ('dbx_business_glossary_term' = 'Responsible Compliance Owner');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `responsible_org_unit` SET TAGS ('dbx_business_glossary_term' = 'Responsible Organizational Unit');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `rohs_exemption_codes` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Exemption Codes');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `scope_description` SET TAGS ('dbx_business_glossary_term' = 'Certification Scope Description');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `scope_level` SET TAGS ('dbx_business_glossary_term' = 'Certification Scope Level');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `scope_level` SET TAGS ('dbx_value_regex' = 'Product|Product Family|Product Line|Platform|Component');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP S/4HANA|Siemens Teamcenter PLM|Manual Entry|Other');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `standard_version` SET TAGS ('dbx_business_glossary_term' = 'Standard Version');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Certification Status');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'Valid|Expired|Under Renewal|Suspended|Withdrawn|Pending Initial|Cancelled');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `status_reason` SET TAGS ('dbx_business_glossary_term' = 'Certification Status Reason');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `surveillance_audit_required` SET TAGS ('dbx_business_glossary_term' = 'Surveillance Audit Required Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `surveillance_audit_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `test_report_number` SET TAGS ('dbx_business_glossary_term' = 'Test Report Number');
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ALTER COLUMN `testing_laboratory` SET TAGS ('dbx_business_glossary_term' = 'Testing Laboratory');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` SET TAGS ('dbx_subdomain' = 'regulatory_compliance');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `hazardous_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Substance ID');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `compliance_reach_substance_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Reach Substance Declaration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `applicable_regulation` SET TAGS ('dbx_business_glossary_term' = 'Applicable Regulation');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `applicable_regulation` SET TAGS ('dbx_value_regex' = 'RoHS|REACH_SVHC|California_Prop65|WEEE|POP|TSCA|China_RoHS|ELV|other');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `authorization_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'REACH Authorization Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `authorization_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `authorization_number` SET TAGS ('dbx_business_glossary_term' = 'REACH Authorization Number');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `cas_number` SET TAGS ('dbx_business_glossary_term' = 'Chemical Abstracts Service (CAS) Number');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `cas_number` SET TAGS ('dbx_value_regex' = '^[0-9]{2,7}-[0-9]{2}-[0-9]$');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|exempted|under_review|pending_data|not_applicable');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `concentration_ppm` SET TAGS ('dbx_business_glossary_term' = 'Substance Concentration (Parts Per Million)');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `concentration_ppm` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `country_of_applicability` SET TAGS ('dbx_business_glossary_term' = 'Country of Applicability');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `country_of_applicability` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `data_source_type` SET TAGS ('dbx_business_glossary_term' = 'Data Source Type');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `data_source_type` SET TAGS ('dbx_value_regex' = 'lab_test|supplier_declaration|internal_analysis|third_party_certification|material_safety_data_sheet|other');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `declaration_date` SET TAGS ('dbx_business_glossary_term' = 'Declaration Date');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `declaration_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `declaration_type` SET TAGS ('dbx_business_glossary_term' = 'Declaration Type');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `declaration_type` SET TAGS ('dbx_value_regex' = 'exemption|substitution|declaration_of_conformity|disclosure|not_applicable');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `ec_number` SET TAGS ('dbx_business_glossary_term' = 'European Community (EC) Number');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `ec_number` SET TAGS ('dbx_value_regex' = '^[0-9]{3}-[0-9]{3}-[0-9]$');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `exceeds_threshold` SET TAGS ('dbx_business_glossary_term' = 'Exceeds Threshold Indicator');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `exceeds_threshold` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `exemption_reference` SET TAGS ('dbx_business_glossary_term' = 'Exemption Reference');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `ghs_hazard_class` SET TAGS ('dbx_business_glossary_term' = 'Globally Harmonized System (GHS) Hazard Class');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `ipc1752_substance_class` SET TAGS ('dbx_business_glossary_term' = 'IPC-1752A Substance Class');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `ipc1752_substance_class` SET TAGS ('dbx_value_regex' = 'class_a|class_b|class_c|class_d|class_e|class_f');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `iupac_name` SET TAGS ('dbx_business_glossary_term' = 'International Union of Pure and Applied Chemistry (IUPAC) Name');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `material_application` SET TAGS ('dbx_business_glossary_term' = 'Material Application');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `measurement_method` SET TAGS ('dbx_business_glossary_term' = 'Measurement Method');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `measurement_method` SET TAGS ('dbx_value_regex' = 'XRF|ICP-OES|ICP-MS|GC-MS|HPLC|wet_chemistry|supplier_declaration|other');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Compliance Notes');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `product_category_scope` SET TAGS ('dbx_business_glossary_term' = 'Product Category Scope');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `prop65_listed_flag` SET TAGS ('dbx_business_glossary_term' = 'California Proposition 65 Listed Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `prop65_listed_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `regulation_list_version` SET TAGS ('dbx_business_glossary_term' = 'Regulation List Version');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `review_due_date` SET TAGS ('dbx_business_glossary_term' = 'Review Due Date');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `review_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `rohs_restricted_flag` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Restricted Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `rohs_restricted_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `sds_document_number` SET TAGS ('dbx_business_glossary_term' = 'Safety Data Sheet (SDS) Document Number');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `substance_category` SET TAGS ('dbx_business_glossary_term' = 'Substance Category');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `substance_category` SET TAGS ('dbx_value_regex' = 'heavy_metal|halogen|phthalate|flame_retardant|solvent|biocide|svhc|persistent_organic_pollutant|other');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `substance_function` SET TAGS ('dbx_business_glossary_term' = 'Substance Function');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `substance_function` SET TAGS ('dbx_value_regex' = 'colorant|flame_retardant|plasticizer|stabilizer|catalyst|solvent|preservative|corrosion_inhibitor|other');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `substance_name` SET TAGS ('dbx_business_glossary_term' = 'Substance Name');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `substitution_cas_number` SET TAGS ('dbx_business_glossary_term' = 'Substitution Substance CAS Number');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `substitution_cas_number` SET TAGS ('dbx_value_regex' = '^[0-9]{2,7}-[0-9]{2}-[0-9]$');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `substitution_substance_name` SET TAGS ('dbx_business_glossary_term' = 'Substitution Substance Name');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `supplier_declaration_reference` SET TAGS ('dbx_business_glossary_term' = 'Supplier Declaration Reference');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `svhc_flag` SET TAGS ('dbx_business_glossary_term' = 'Substance of Very High Concern (SVHC) Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `svhc_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `test_report_number` SET TAGS ('dbx_business_glossary_term' = 'Test Report Number');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `testing_laboratory` SET TAGS ('dbx_business_glossary_term' = 'Testing Laboratory');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `threshold_limit_ppm` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Threshold Limit (Parts Per Million)');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `threshold_limit_ppm` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `weight_fraction_percent` SET TAGS ('dbx_business_glossary_term' = 'Weight Fraction Percentage');
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ALTER COLUMN `weight_fraction_percent` SET TAGS ('dbx_value_regex' = '^(100(.0+)?|[0-9]{1,2}(.[0-9]+)?)$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` SET TAGS ('dbx_subdomain' = 'information_management');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` SET TAGS ('dbx_original_name' = 'product_document');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `product_document_id` SET TAGS ('dbx_business_glossary_term' = 'Product Document ID');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `application_id` SET TAGS ('dbx_business_glossary_term' = 'Application Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `change_notice_id` SET TAGS ('dbx_business_glossary_term' = 'Product Change Notice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `drawing_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Drawing Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `product_regulatory_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Certification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `access_level` SET TAGS ('dbx_business_glossary_term' = 'Document Access Level');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `access_level` SET TAGS ('dbx_value_regex' = 'public|customer_only|partner_only|internal|restricted');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `applicable_product_range` SET TAGS ('dbx_business_glossary_term' = 'Applicable Product Range');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `author` SET TAGS ('dbx_business_glossary_term' = 'Document Author');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `certification_body` SET TAGS ('dbx_business_glossary_term' = 'Certification Body');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `checksum_hash` SET TAGS ('dbx_business_glossary_term' = 'Document Checksum Hash (SHA-256)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `checksum_hash` SET TAGS ('dbx_value_regex' = '^[a-fA-F0-9]{64}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `confidential_flag` SET TAGS ('dbx_business_glossary_term' = 'Confidential Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `confidential_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `country_of_applicability` SET TAGS ('dbx_business_glossary_term' = 'Country of Applicability');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `country_of_applicability` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}(|[A-Z]{3})*$|^GLOBAL$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = 'product_portal|customer_portal|partner_portal|internal_intranet|regulatory_submission|print_only|all');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Document Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `export_controlled_flag` SET TAGS ('dbx_business_glossary_term' = 'Export Controlled Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `export_controlled_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `file_format` SET TAGS ('dbx_business_glossary_term' = 'File Format');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `file_format` SET TAGS ('dbx_value_regex' = 'PDF|DOCX|XLSX|DWG|DXF|HTML|XML|ZIP|STEP|IGES|PNG|JPEG|MP4');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `file_size_kb` SET TAGS ('dbx_business_glossary_term' = 'File Size (KB)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `file_size_kb` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `hazardous_content_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Content Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `hazardous_content_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Document Number');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{3,50}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `owner_department` SET TAGS ('dbx_business_glossary_term' = 'Document Owner Department');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `publication_date` SET TAGS ('dbx_business_glossary_term' = 'Publication Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `publication_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Compliant');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `regulatory_standard` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Standard');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `review_cycle_months` SET TAGS ('dbx_business_glossary_term' = 'Review Cycle (Months)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `review_cycle_months` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `revision_level` SET TAGS ('dbx_business_glossary_term' = 'Revision Level');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `revision_level` SET TAGS ('dbx_value_regex' = '^[A-Z0-9.]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliant');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `sap_dms_document_key` SET TAGS ('dbx_business_glossary_term' = 'SAP Document Management System (DMS) Document Key');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `scope` SET TAGS ('dbx_business_glossary_term' = 'Document Scope');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `scope` SET TAGS ('dbx_value_regex' = 'single_product|product_family|product_line|platform|global');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'teamcenter|sap_dms|manual|salesforce|external');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Document Status');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|in_review|approved|released|obsolete|superseded|withdrawn');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `storage_location_uri` SET TAGS ('dbx_business_glossary_term' = 'Document Storage Location URI');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `storage_location_uri` SET TAGS ('dbx_value_regex' = '^(https?|s3|abfss|dbfs)://.*$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `teamcenter_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Siemens Teamcenter Document ID');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Document Title');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Document Type');
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'datasheet|installation_manual|user_guide|safety_data_sheet|declaration_of_conformity|test_report|marketing_collateral|quick_start_guide|service_manual|spare_parts_catalog|certificate|drawing|specification|standard_operating_procedure|application_note');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` SET TAGS ('dbx_subdomain' = 'catalog_structure');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` SET TAGS ('dbx_original_name' = 'product_substitution');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `substitution_id` SET TAGS ('dbx_business_glossary_term' = 'Product Substitution ID');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `change_notice_id` SET TAGS ('dbx_business_glossary_term' = 'Product Change Notice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Source Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Source Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `application_scope` SET TAGS ('dbx_business_glossary_term' = 'Application Scope');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `application_scope` SET TAGS ('dbx_value_regex' = 'all|order-management|service-spare-parts|procurement|bom-substitution|field-service');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `customer_notification_required` SET TAGS ('dbx_business_glossary_term' = 'Customer Notification Required Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `customer_notification_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `direction` SET TAGS ('dbx_business_glossary_term' = 'Substitution Direction');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `direction` SET TAGS ('dbx_value_regex' = 'one-way|bidirectional');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Export Control Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `functional_equivalence_level` SET TAGS ('dbx_business_glossary_term' = 'Functional Equivalence Level');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `functional_equivalence_level` SET TAGS ('dbx_value_regex' = 'full|partial|form-fit-function|dimensional-only|performance-limited');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `hazardous_material_change_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Change Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `hazardous_material_change_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `is_auto_substitution_allowed` SET TAGS ('dbx_business_glossary_term' = 'Automatic Substitution Allowed Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `is_auto_substitution_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `lead_time_impact_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Impact (Days)');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Substitution Notes');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Substitution Number');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^SUB-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `plm_substitution_reference` SET TAGS ('dbx_business_glossary_term' = 'Product Lifecycle Management (PLM) Substitution ID');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `price_impact_indicator` SET TAGS ('dbx_business_glossary_term' = 'Price Impact Indicator');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `price_impact_indicator` SET TAGS ('dbx_value_regex' = 'higher|lower|neutral|variable');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Substitution Priority');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `quantity_ratio` SET TAGS ('dbx_business_glossary_term' = 'Substitution Quantity Ratio');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Substitution Reason Code');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `reason_code` SET TAGS ('dbx_value_regex' = 'eol-replacement|cost-reduction|performance-upgrade|supply-continuity|regulatory-compliance|design-change|supplier-change|quality-improvement|consolidation');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `reason_description` SET TAGS ('dbx_business_glossary_term' = 'Substitution Reason Description');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER_PLM|OPCENTER_MES|MANUAL|ARIBA|SALESFORCE_CRM');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Substitution Status');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending-approval|active|inactive|expired|superseded');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `target_material_number` SET TAGS ('dbx_business_glossary_term' = 'Target Material Number');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `target_sku` SET TAGS ('dbx_business_glossary_term' = 'Target Stock Keeping Unit (SKU)');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Substitution Type');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'superseded-by|equivalent|preferred-alternate|cross-reference|emergency-alternate');
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` SET TAGS ('dbx_subdomain' = 'commercial_pricing');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` SET TAGS ('dbx_original_name' = 'product_bundle');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `bundle_id` SET TAGS ('dbx_business_glossary_term' = 'Product Bundle ID');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `base_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Base Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `base_unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|SET|KIT|PCE|PAL');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `business_unit` SET TAGS ('dbx_business_glossary_term' = 'Business Unit');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Bundle Category');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'automation_system|electrification_solution|smart_infrastructure|drive_system|control_panel|mro_kit|aftermarket_package|starter_kit|upgrade_kit');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `ce_marked` SET TAGS ('dbx_business_glossary_term' = 'CE Marked Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `ce_marked` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Bundle Code');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Bundle Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `discontinuation_date` SET TAGS ('dbx_business_glossary_term' = 'Bundle Discontinuation Date');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `discontinuation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `discount_percent` SET TAGS ('dbx_business_glossary_term' = 'Bundle Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `discount_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `discount_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = 'direct_sales|distributor|online|system_integrator|oem|reseller');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `eccn` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification Number (ECCN)');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `eccn` SET TAGS ('dbx_value_regex' = '^[0-9][A-Z][0-9]{3}[a-z]?$|^EAR99$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Export Control Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `harmonized_tariff_code` SET TAGS ('dbx_business_glossary_term' = 'Harmonized Tariff Code (HTS Code)');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `harmonized_tariff_code` SET TAGS ('dbx_value_regex' = '^d{6,10}$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `is_configurable` SET TAGS ('dbx_business_glossary_term' = 'Is Configurable Bundle Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `is_configurable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `is_orderable_standalone` SET TAGS ('dbx_business_glossary_term' = 'Is Orderable Standalone Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `is_orderable_standalone` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Bundle Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `launch_date` SET TAGS ('dbx_business_glossary_term' = 'Bundle Launch Date');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `launch_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_business_glossary_term' = 'Bundle Lifecycle Stage');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_value_regex' = 'introduction|growth|maturity|decline|end_of_life|phase_out');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `list_price` SET TAGS ('dbx_business_glossary_term' = 'Bundle List Price');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `list_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `list_price_currency` SET TAGS ('dbx_business_glossary_term' = 'Bundle List Price Currency');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `list_price_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `long_description` SET TAGS ('dbx_business_glossary_term' = 'Bundle Long Description');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `min_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Bundle Name');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `pricing_method` SET TAGS ('dbx_business_glossary_term' = 'Bundle Pricing Method');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `pricing_method` SET TAGS ('dbx_value_regex' = 'fixed_bundle_price|sum_of_components|discounted_sum|tiered_price|negotiated_price');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'REACH Compliant Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'RoHS Compliant Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `short_description` SET TAGS ('dbx_business_glossary_term' = 'Bundle Short Description');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER_PLM|SALESFORCE_CRM|MANUAL|LEGACY');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `standard_cost` SET TAGS ('dbx_business_glossary_term' = 'Bundle Standard Cost');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `standard_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `standard_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Bundle Standard Cost Currency');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `standard_cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Bundle Status');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|discontinued|superseded|blocked|under_review');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `target_industry` SET TAGS ('dbx_business_glossary_term' = 'Target Industry');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `target_industry` SET TAGS ('dbx_value_regex' = 'automotive|food_beverage|pharmaceutical|oil_gas|utilities|building_automation|transportation|discrete_manufacturing|process_manufacturing|general_industry');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Bundle Type');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'fixed_bundle|configurable_bundle|promotional_kit|solution_package|spare_parts_kit|service_bundle');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `ul_listed` SET TAGS ('dbx_business_glossary_term' = 'UL Listed Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `ul_listed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `valid_from` SET TAGS ('dbx_business_glossary_term' = 'Bundle Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `valid_from` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `valid_to` SET TAGS ('dbx_business_glossary_term' = 'Bundle Validity End Date');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ALTER COLUMN `valid_to` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` SET TAGS ('dbx_subdomain' = 'commercial_pricing');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `bundle_component_id` SET TAGS ('dbx_business_glossary_term' = 'Bundle Component ID');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `bundle_id` SET TAGS ('dbx_business_glossary_term' = 'Bundle ID');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `change_notice_id` SET TAGS ('dbx_business_glossary_term' = 'Product Change Notice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Component Catalog Item ID');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Component Stock Keeping Unit (SKU) ID');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `change_reason` SET TAGS ('dbx_business_glossary_term' = 'Change Reason');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `component_type` SET TAGS ('dbx_business_glossary_term' = 'Bundle Component Type');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `component_type` SET TAGS ('dbx_value_regex' = 'mandatory|optional|default_selected|conditional');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `configuration_group` SET TAGS ('dbx_business_glossary_term' = 'Configuration Group');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `configuration_sequence` SET TAGS ('dbx_business_glossary_term' = 'Configuration Sequence');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `configuration_sequence` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `discount_percent` SET TAGS ('dbx_business_glossary_term' = 'Component Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `discount_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,4})?|[0-9]{1,2}(.[0-9]{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `discount_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Export Control Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `is_separately_deliverable` SET TAGS ('dbx_business_glossary_term' = 'Separately Deliverable Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `is_separately_deliverable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `is_separately_invoiced` SET TAGS ('dbx_business_glossary_term' = 'Separately Invoiced Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `is_separately_invoiced` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Component Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Component Line Number');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `line_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `maximum_quantity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Component Quantity');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `maximum_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `minimum_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Component Quantity');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `minimum_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Component Notes');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `override_price` SET TAGS ('dbx_business_glossary_term' = 'Component Override Price');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `override_price` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `override_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `price_currency` SET TAGS ('dbx_business_glossary_term' = 'Price Currency Code');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `price_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `pricing_method` SET TAGS ('dbx_business_glossary_term' = 'Component Pricing Method');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `pricing_method` SET TAGS ('dbx_value_regex' = 'included|component_price|override_price|discount_percent|discount_amount|free_of_charge');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Component Quantity');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Compliant Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `revenue_recognition_method` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Method');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `revenue_recognition_method` SET TAGS ('dbx_value_regex' = 'point_in_time|over_time|not_applicable');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliant Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER_PLM|OPCENTER_MES|MANUAL|MIGRATION');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Bundle Component Status');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|draft|discontinued|pending_approval');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `substitute_group_code` SET TAGS ('dbx_business_glossary_term' = 'Substitute Group Code');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `substitute_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `substitution_eligible` SET TAGS ('dbx_business_glossary_term' = 'Substitution Eligibility Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `substitution_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|PC|KG|G|L|ML|M|CM|MM|M2|M3|SET|KIT|BOX|PAL|HR|MIN|KWH|MWH');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `warranty_months` SET TAGS ('dbx_business_glossary_term' = 'Component Warranty Period (Months)');
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ALTER COLUMN `warranty_months` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` SET TAGS ('dbx_subdomain' = 'distribution_operations');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `aftermarket_part_id` SET TAGS ('dbx_business_glossary_term' = 'Aftermarket Part ID');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `applicable_equipment_models` SET TAGS ('dbx_business_glossary_term' = 'Applicable Equipment Models');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `applicable_serial_number_range` SET TAGS ('dbx_business_glossary_term' = 'Applicable Serial Number Range');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `base_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Base Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `base_unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|M|L|SET|BOX|ROLL|M2|M3');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `ce_marked` SET TAGS ('dbx_business_glossary_term' = 'CE Marking Status');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `ce_marked` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Aftermarket Part Description');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `eccn` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification Number (ECCN)');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `eccn` SET TAGS ('dbx_value_regex' = '^[0-9][A-Z][0-9]{3}[a-z]?$|^EAR99$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight in Kilograms');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_value_regex' = '^d{1,6}(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `harmonized_tariff_code` SET TAGS ('dbx_business_glossary_term' = 'Harmonized Tariff Code (HTS Code)');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `harmonized_tariff_code` SET TAGS ('dbx_value_regex' = '^d{6,10}$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `is_batch_managed` SET TAGS ('dbx_business_glossary_term' = 'Batch Managed Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `is_batch_managed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `is_hazardous` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `is_hazardous` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `is_serialized` SET TAGS ('dbx_business_glossary_term' = 'Serialized Part Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `is_serialized` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time in Days');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_value_regex' = '^d{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `lifecycle_end_date` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle End Date');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `lifecycle_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `lifecycle_start_date` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Start Date');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `lifecycle_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `list_price` SET TAGS ('dbx_business_glossary_term' = 'Aftermarket List Price');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `list_price` SET TAGS ('dbx_value_regex' = '^d{1,14}(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `list_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `list_price_currency` SET TAGS ('dbx_business_glossary_term' = 'List Price Currency Code');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `list_price_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `mean_time_between_replacements_hours` SET TAGS ('dbx_business_glossary_term' = 'Mean Time Between Replacements (MTBF-Based) in Hours');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `mean_time_between_replacements_hours` SET TAGS ('dbx_value_regex' = '^d{1,7}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_value_regex' = '^d{1,7}(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Aftermarket Part Name');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Aftermarket Part Number');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `part_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{3,40}$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `part_type` SET TAGS ('dbx_business_glossary_term' = 'Aftermarket Part Type');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `part_type` SET TAGS ('dbx_value_regex' = 'oem_spare|consumable|wear_part|repair_kit|exchange_unit|upgrade_kit');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Compliant');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `replacement_interval_unit` SET TAGS ('dbx_business_glossary_term' = 'Replacement Interval Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `replacement_interval_unit` SET TAGS ('dbx_value_regex' = 'hours|cycles|months|years|km');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliant');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `service_channel` SET TAGS ('dbx_business_glossary_term' = 'Service Channel');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `service_channel` SET TAGS ('dbx_value_regex' = 'direct_service|distributor|ecommerce|field_service|depot_repair');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `shelf_life_days` SET TAGS ('dbx_business_glossary_term' = 'Shelf Life in Days');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `shelf_life_days` SET TAGS ('dbx_value_regex' = '^d{1,5}$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER|MAXIMO|SALESFORCE|MANUAL');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `standard_cost` SET TAGS ('dbx_business_glossary_term' = 'Standard Cost');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `standard_cost` SET TAGS ('dbx_value_regex' = '^d{1,14}(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `standard_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `standard_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Standard Cost Currency Code');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `standard_cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Aftermarket Part Status');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|phase_out|discontinued|superseded|development|blocked');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `stocking_classification` SET TAGS ('dbx_business_glossary_term' = 'Stocking Classification');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `stocking_classification` SET TAGS ('dbx_value_regex' = 'critical_spare|standard|non_stock|consignment|slow_moving');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `superseded_by_date` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Date');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `superseded_by_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `ul_listed` SET TAGS ('dbx_business_glossary_term' = 'Underwriters Laboratories (UL) Listed');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `ul_listed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `unspsc_code` SET TAGS ('dbx_business_glossary_term' = 'United Nations Standard Products and Services Code (UNSPSC)');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `unspsc_code` SET TAGS ('dbx_value_regex' = '^d{8}$');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `warranty_period_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Period in Months');
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ALTER COLUMN `warranty_period_months` SET TAGS ('dbx_value_regex' = '^d{1,3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` SET TAGS ('dbx_subdomain' = 'distribution_operations');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` SET TAGS ('dbx_original_name' = 'product_sales_org');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `sales_org_id` SET TAGS ('dbx_business_glossary_term' = 'Product Sales Organization ID');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Product Hierarchy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `account_assignment_group` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment Group');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `account_assignment_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `authorization_group` SET TAGS ('dbx_business_glossary_term' = 'Authorization Group');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `authorization_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `availability_check_rule` SET TAGS ('dbx_business_glossary_term' = 'Availability Check Rule');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `availability_check_rule` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `cash_discount_indicator` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Eligible Indicator');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `cash_discount_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization (Sales Org) Code');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `commission_group` SET TAGS ('dbx_business_glossary_term' = 'Commission Group');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `commission_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `cross_selling_material` SET TAGS ('dbx_business_glossary_term' = 'Cross-Selling Reference Material Number');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `cross_selling_material` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `delivering_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Delivering Plant Code');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `delivering_plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `division_code` SET TAGS ('dbx_business_glossary_term' = 'Division Code');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `division_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Export Control Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `general_item_category_group` SET TAGS ('dbx_business_glossary_term' = 'General Item Category Group');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `general_item_category_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `item_category_group` SET TAGS ('dbx_business_glossary_term' = 'Item Category Group');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `item_category_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `loading_group` SET TAGS ('dbx_business_glossary_term' = 'Loading Group');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `loading_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `material_statistics_group` SET TAGS ('dbx_business_glossary_term' = 'Material Statistics Group');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `material_statistics_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `minimum_order_value` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Value (MOV)');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `minimum_order_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `minimum_order_value_currency` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Value Currency Code');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `minimum_order_value_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `planned_end_of_sale_date` SET TAGS ('dbx_business_glossary_term' = 'Planned End-of-Sale (EOS) Date');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `planned_end_of_sale_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `pricing_reference_material` SET TAGS ('dbx_business_glossary_term' = 'Pricing Reference Material Number');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `pricing_reference_material` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `sales_blocking_reason` SET TAGS ('dbx_business_glossary_term' = 'Sales Blocking Reason');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `sales_blocking_reason` SET TAGS ('dbx_value_regex' = 'regulatory_hold|quality_hold|commercial_decision|end_of_life|supplier_issue|compliance_review|other');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `sales_status` SET TAGS ('dbx_business_glossary_term' = 'Sales Status');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `sales_status` SET TAGS ('dbx_value_regex' = 'active|blocked|phasing_out|discontinued|pending_activation|restricted');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `sales_status_effective_date` SET TAGS ('dbx_business_glossary_term' = 'Sales Status Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `sales_status_effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `sales_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Sales Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `sales_unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|MIGRATION|OTHER');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `tax_classification_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Classification Code');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `tax_classification_code` SET TAGS ('dbx_value_regex' = '^[0-9]{1}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `transportation_group` SET TAGS ('dbx_business_glossary_term' = 'Transportation Group');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `transportation_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `volume_rebate_group` SET TAGS ('dbx_business_glossary_term' = 'Volume Rebate Group');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `volume_rebate_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `valid_from` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `valid_from` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `valid_to` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ALTER COLUMN `valid_to` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` SET TAGS ('dbx_subdomain' = 'distribution_operations');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` SET TAGS ('dbx_original_name' = 'product_plant');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `product_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Plant ID');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `abc_indicator` SET TAGS ('dbx_business_glossary_term' = 'ABC Indicator');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `abc_indicator` SET TAGS ('dbx_value_regex' = 'A|B|C');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `batch_management_required` SET TAGS ('dbx_business_glossary_term' = 'Batch Management Required Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `batch_management_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `fixed_lot_size` SET TAGS ('dbx_business_glossary_term' = 'Fixed Lot Size');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `fixed_lot_size` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `goods_receipt_processing_time_days` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Processing Time (Days)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `goods_receipt_processing_time_days` SET TAGS ('dbx_value_regex' = '^d{1,3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `hazardous_material_number` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Number');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `hazardous_material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `in_house_production_time_days` SET TAGS ('dbx_business_glossary_term' = 'In-House Production Time (Days)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `in_house_production_time_days` SET TAGS ('dbx_value_regex' = '^d{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `issue_storage_location` SET TAGS ('dbx_business_glossary_term' = 'Issue Storage Location');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `issue_storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `lot_sizing_procedure` SET TAGS ('dbx_business_glossary_term' = 'Lot Sizing Procedure');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `lot_sizing_procedure` SET TAGS ('dbx_value_regex' = 'EX|FX|HB|MB|PK|TB|WB|ZB|LS|SP|FP|ZL');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `maximum_lot_size` SET TAGS ('dbx_business_glossary_term' = 'Maximum Lot Size');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `maximum_lot_size` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `minimum_lot_size` SET TAGS ('dbx_business_glossary_term' = 'Minimum Lot Size');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `minimum_lot_size` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `moving_average_price` SET TAGS ('dbx_business_glossary_term' = 'Moving Average Price');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `moving_average_price` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `moving_average_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `mrp_controller` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Controller');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `mrp_controller` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `mrp_type` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Type');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `mrp_type` SET TAGS ('dbx_value_regex' = 'PD|VB|VM|MK|MN|ND|X0|R1|S1|Z1');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `planned_delivery_time_days` SET TAGS ('dbx_business_glossary_term' = 'Planned Delivery Time (Days)');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `planned_delivery_time_days` SET TAGS ('dbx_value_regex' = '^d{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `price_control` SET TAGS ('dbx_business_glossary_term' = 'Price Control');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `price_control` SET TAGS ('dbx_value_regex' = 'S|V');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `price_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Unit');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `price_unit` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'E|F|X');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `production_scheduler` SET TAGS ('dbx_business_glossary_term' = 'Production Scheduler');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `production_scheduler` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `production_storage_location` SET TAGS ('dbx_business_glossary_term' = 'Production Storage Location');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `production_storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `profit_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `quality_inspection_setup` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Setup');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `quality_inspection_setup` SET TAGS ('dbx_value_regex' = '^[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `reorder_point` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `reorder_point` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `safety_stock` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Level');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `safety_stock` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `serial_number_profile` SET TAGS ('dbx_business_glossary_term' = 'Serial Number Profile');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `serial_number_profile` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER|OPCENTER|LEGACY');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `special_procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Special Procurement Type');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `special_procurement_type` SET TAGS ('dbx_value_regex' = '^[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `specific_material_status_valid_from` SET TAGS ('dbx_business_glossary_term' = 'Plant-Specific Material Status Valid From Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `specific_material_status_valid_from` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `standard_price` SET TAGS ('dbx_business_glossary_term' = 'Standard Price');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `standard_price` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `standard_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Plant Material Status');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|in_review|discontinued');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `storage_conditions` SET TAGS ('dbx_business_glossary_term' = 'Storage Conditions');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `storage_conditions` SET TAGS ('dbx_value_regex' = '^[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `temperature_conditions_indicator` SET TAGS ('dbx_business_glossary_term' = 'Temperature Conditions Indicator');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `temperature_conditions_indicator` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `valuation_class` SET TAGS ('dbx_business_glossary_term' = 'Valuation Class');
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ALTER COLUMN `valuation_class` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` SET TAGS ('dbx_subdomain' = 'catalog_structure');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` SET TAGS ('dbx_original_name' = 'product_uom');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Product Unit of Measure (UoM) ID');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `change_notice_id` SET TAGS ('dbx_business_glossary_term' = 'Product Change Notice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM) Code');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `conversion_denominator` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM) Conversion Denominator');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `conversion_denominator` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `conversion_factor` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM) Conversion Factor');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `conversion_factor` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `conversion_numerator` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM) Conversion Numerator');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `conversion_numerator` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM) Description');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `ean_upc_code` SET TAGS ('dbx_business_glossary_term' = 'European Article Number (EAN) / Universal Product Code (UPC)');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `ean_upc_code` SET TAGS ('dbx_value_regex' = '^[0-9]{8,14}$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `global_trade_item_number` SET TAGS ('dbx_business_glossary_term' = 'Global Trade Item Number (GTIN)');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `global_trade_item_number` SET TAGS ('dbx_value_regex' = '^[0-9]{8,14}$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight per Unit of Measure (UoM) in Kilograms (kg)');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `gross_weight_kg` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `height_mm` SET TAGS ('dbx_business_glossary_term' = 'Height per Unit of Measure (UoM) in Millimeters (mm)');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `height_mm` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `is_base_uom` SET TAGS ('dbx_business_glossary_term' = 'Is Base Unit of Measure (UoM) Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `is_base_uom` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `is_delivery_uom` SET TAGS ('dbx_business_glossary_term' = 'Is Delivery Unit of Measure (UoM) Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `is_delivery_uom` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `is_order_uom` SET TAGS ('dbx_business_glossary_term' = 'Is Order Unit of Measure (UoM) Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `is_order_uom` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `is_production_uom` SET TAGS ('dbx_business_glossary_term' = 'Is Production Unit of Measure (UoM) Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `is_production_uom` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `is_sales_uom` SET TAGS ('dbx_business_glossary_term' = 'Is Sales Unit of Measure (UoM) Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `is_sales_uom` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `is_storage_uom` SET TAGS ('dbx_business_glossary_term' = 'Is Storage Unit of Measure (UoM) Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `is_storage_uom` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `iso_code` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM) ISO Code');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `iso_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `length_mm` SET TAGS ('dbx_business_glossary_term' = 'Length per Unit of Measure (UoM) in Millimeters (mm)');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `length_mm` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `maximum_stack_height` SET TAGS ('dbx_business_glossary_term' = 'Maximum Stack Height');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `maximum_stack_height` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `min_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `min_order_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `net_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Net Weight per Unit of Measure (UoM) in Kilograms (kg)');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `net_weight_kg` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `packaging_type` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `packaging_type` SET TAGS ('dbx_value_regex' = 'each|inner_pack|case|carton|pallet|drum|bag|reel|tube|box|bundle|set');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `quantity_per_package` SET TAGS ('dbx_business_glossary_term' = 'Quantity per Package');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `quantity_per_package` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `rounding_value` SET TAGS ('dbx_business_glossary_term' = 'Rounding Value');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `rounding_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER|OPCENTER|MANUAL|MIGRATION');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM) Assignment Status');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|obsolete|pending_review');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM) Type');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'base|order|sales|delivery|storage|production|invoice|weight|volume');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `variable_order_unit_allowed` SET TAGS ('dbx_business_glossary_term' = 'Variable Order Unit Allowed Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `variable_order_unit_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `volume_m3` SET TAGS ('dbx_business_glossary_term' = 'Volume per Unit of Measure (UoM) in Cubic Meters (m³)');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `volume_m3` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `width_mm` SET TAGS ('dbx_business_glossary_term' = 'Width per Unit of Measure (UoM) in Millimeters (mm)');
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ALTER COLUMN `width_mm` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` SET TAGS ('dbx_subdomain' = 'catalog_structure');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` SET TAGS ('dbx_original_name' = 'product_classification');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `classification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Classification ID');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `characteristic_code` SET TAGS ('dbx_business_glossary_term' = 'Classification Characteristic Code');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `characteristic_data_type` SET TAGS ('dbx_business_glossary_term' = 'Classification Characteristic Data Type');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `characteristic_data_type` SET TAGS ('dbx_value_regex' = 'numeric|string|boolean|coded_value|range|date');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `characteristic_name` SET TAGS ('dbx_business_glossary_term' = 'Classification Characteristic Name');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `characteristic_unit` SET TAGS ('dbx_business_glossary_term' = 'Classification Characteristic Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `characteristic_value` SET TAGS ('dbx_business_glossary_term' = 'Classification Characteristic Value');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `class_code` SET TAGS ('dbx_business_glossary_term' = 'Classification Class Code');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `class_name` SET TAGS ('dbx_business_glossary_term' = 'Classification Class Name');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `commodity_code` SET TAGS ('dbx_business_glossary_term' = 'Classification Commodity Code');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `confidence_score` SET TAGS ('dbx_business_glossary_term' = 'Classification Confidence Score');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `confidence_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '[A-Z]{3}');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `date` SET TAGS ('dbx_business_glossary_term' = 'Classification Date');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `eclass_code` SET TAGS ('dbx_business_glossary_term' = 'eCl@ss Code');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `eclass_code` SET TAGS ('dbx_value_regex' = '^[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `edi_catalog_code` SET TAGS ('dbx_business_glossary_term' = 'EDI Catalog Code');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Classification Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `etim_class_code` SET TAGS ('dbx_business_glossary_term' = 'ETIM Class Code');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `etim_class_code` SET TAGS ('dbx_value_regex' = '^EC[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Classification Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `family_code` SET TAGS ('dbx_business_glossary_term' = 'Classification Family Code');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `is_primary` SET TAGS ('dbx_business_glossary_term' = 'Is Primary Classification');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `is_primary` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '[a-z]{2}-[A-Z]{2}');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `method` SET TAGS ('dbx_business_glossary_term' = 'Classification Method');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `method` SET TAGS ('dbx_value_regex' = 'manual|automated|ai_assisted|inherited|imported');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Classification Notes');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `punchout_catalog_flag` SET TAGS ('dbx_business_glossary_term' = 'Punchout Catalog Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `punchout_catalog_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `regulatory_relevance` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Relevance');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `regulatory_relevance` SET TAGS ('dbx_value_regex' = 'ce_marking|rohs|reach|ul|none|multiple');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `scope` SET TAGS ('dbx_business_glossary_term' = 'Classification Scope');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `scope` SET TAGS ('dbx_value_regex' = 'global|regional|country|sales_channel|internal');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `segment_code` SET TAGS ('dbx_business_glossary_term' = 'Classification Segment Code');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'teamcenter_plm|sap_s4hana|manual|ariba|external_feed');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Classification Status');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_review|superseded|draft');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `system` SET TAGS ('dbx_business_glossary_term' = 'Classification System');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `system` SET TAGS ('dbx_value_regex' = 'eCl@ss|UNSPSC|ETIM|GPC|HS|NAICS|internal|custom');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `system_version` SET TAGS ('dbx_business_glossary_term' = 'Classification System Version');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `unspsc_code` SET TAGS ('dbx_business_glossary_term' = 'UNSPSC Code');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `unspsc_code` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `validated_by` SET TAGS ('dbx_business_glossary_term' = 'Validated By');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `validated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Validated Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`classification` ALTER COLUMN `validated_timestamp` SET TAGS ('dbx_value_regex' = 'd{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}');
ALTER TABLE `manufacturing_ecm`.`product`.`media` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`media` SET TAGS ('dbx_subdomain' = 'information_management');
ALTER TABLE `manufacturing_ecm`.`product`.`media` SET TAGS ('dbx_original_name' = 'product_media');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `media_id` SET TAGS ('dbx_business_glossary_term' = 'Product Media ID');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `change_notice_id` SET TAGS ('dbx_business_glossary_term' = 'Product Change Notice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `alt_text` SET TAGS ('dbx_business_glossary_term' = 'Accessibility Alternative Text');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|not_required');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Media Asset Code');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,50}$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `color_space` SET TAGS ('dbx_business_glossary_term' = 'Color Space');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `color_space` SET TAGS ('dbx_value_regex' = 'sRGB|AdobeRGB|CMYK|Grayscale|P3');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `copyright_owner` SET TAGS ('dbx_business_glossary_term' = 'Copyright Owner');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `dam_asset_reference` SET TAGS ('dbx_business_glossary_term' = 'Digital Asset Management (DAM) Asset ID');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Media Asset Description');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `duration_seconds` SET TAGS ('dbx_business_glossary_term' = 'Media Duration (Seconds)');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `duration_seconds` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `file_format` SET TAGS ('dbx_business_glossary_term' = 'File Format');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `file_format` SET TAGS ('dbx_value_regex' = 'JPEG|PNG|TIFF|SVG|MP4|MOV|WEBM|GLTF|GLB|OBJ|STEP|STL|PDF|USDZ|WEBP|GIF');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `file_size_bytes` SET TAGS ('dbx_business_glossary_term' = 'File Size (Bytes)');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `file_size_bytes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `intended_use` SET TAGS ('dbx_business_glossary_term' = 'Intended Use Channel');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `intended_use` SET TAGS ('dbx_value_regex' = 'web|print|ar|configurator|digital_catalog|sales_presentation|training|social_media|packaging');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `is_360_view` SET TAGS ('dbx_business_glossary_term' = 'Is 360-Degree View');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `is_360_view` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `is_downloadable` SET TAGS ('dbx_business_glossary_term' = 'Is Downloadable');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `is_downloadable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `is_primary` SET TAGS ('dbx_business_glossary_term' = 'Is Primary Media Asset');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `is_primary` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2,3}(-[A-Z]{2,3})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `license_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'License Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `license_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `license_type` SET TAGS ('dbx_business_glossary_term' = 'License Type');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `license_type` SET TAGS ('dbx_value_regex' = 'proprietary|royalty_free|rights_managed|creative_commons|public_domain|licensed_third_party');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `published_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Published Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `published_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `resolution_height_px` SET TAGS ('dbx_business_glossary_term' = 'Resolution Height (Pixels)');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `resolution_height_px` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `resolution_width_px` SET TAGS ('dbx_business_glossary_term' = 'Resolution Width (Pixels)');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `resolution_width_px` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `sort_order` SET TAGS ('dbx_business_glossary_term' = 'Display Sort Order');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `sort_order` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'teamcenter|sap_s4hana|salesforce|manual|external_agency|dam_system');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Media Asset Publication Status');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|under_review|approved|published|archived|retired');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `storage_url` SET TAGS ('dbx_business_glossary_term' = 'Storage URL');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `storage_url` SET TAGS ('dbx_value_regex' = '^https?://[^s]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `subtype` SET TAGS ('dbx_business_glossary_term' = 'Media Asset Subtype');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `subtype` SET TAGS ('dbx_value_regex' = 'hero_shot|exploded_view|installation_photo|lifestyle_photo|schematic|dimensional_drawing|cad_model|ar_marker|product_video|tutorial_video|360_spin|cutaway_view|packaging_shot');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `tags` SET TAGS ('dbx_business_glossary_term' = 'Media Asset Tags');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `thumbnail_url` SET TAGS ('dbx_business_glossary_term' = 'Thumbnail URL');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `thumbnail_url` SET TAGS ('dbx_value_regex' = '^https?://[^s]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Media Asset Title');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Media Type');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'image|video|3d_model|ar_asset|document|animation|360_view');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Media Asset Version Number');
ALTER TABLE `manufacturing_ecm`.`product`.`media` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` SET TAGS ('dbx_subdomain' = 'catalog_structure');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` SET TAGS ('dbx_original_name' = 'product_attribute');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `attribute_id` SET TAGS ('dbx_business_glossary_term' = 'Product Attribute ID');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `change_notice_id` SET TAGS ('dbx_business_glossary_term' = 'Product Change Notice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `classification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Classification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `allowed_values` SET TAGS ('dbx_business_glossary_term' = 'Allowed Values');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `boolean_value` SET TAGS ('dbx_business_glossary_term' = 'Boolean Attribute Value');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `boolean_value` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `certification_reference` SET TAGS ('dbx_business_glossary_term' = 'Certification Reference');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `characteristic_code` SET TAGS ('dbx_business_glossary_term' = 'Characteristic Code');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Attribute Code');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `data_type` SET TAGS ('dbx_business_glossary_term' = 'Attribute Data Type');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `data_type` SET TAGS ('dbx_value_regex' = 'string|numeric|boolean|date|range');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `date_value` SET TAGS ('dbx_business_glossary_term' = 'Date Attribute Value');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `date_value` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `display_sequence` SET TAGS ('dbx_business_glossary_term' = 'Display Sequence');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `display_sequence` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `group` SET TAGS ('dbx_business_glossary_term' = 'Attribute Group');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `group` SET TAGS ('dbx_value_regex' = 'technical|commercial|dimensional|environmental|regulatory|electrical|mechanical|thermal|chemical|performance');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `is_configurable_option` SET TAGS ('dbx_business_glossary_term' = 'Configurable Option Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `is_configurable_option` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `is_customer_facing` SET TAGS ('dbx_business_glossary_term' = 'Customer-Facing Attribute Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `is_customer_facing` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Attribute Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `is_searchable` SET TAGS ('dbx_business_glossary_term' = 'Searchable Attribute Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `is_searchable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Attribute Name');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `numeric_value` SET TAGS ('dbx_business_glossary_term' = 'Numeric Attribute Value');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `plm_attribute_reference` SET TAGS ('dbx_business_glossary_term' = 'Product Lifecycle Management (PLM) Attribute ID');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `range_max_value` SET TAGS ('dbx_business_glossary_term' = 'Range Maximum Value');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `range_min_value` SET TAGS ('dbx_business_glossary_term' = 'Range Minimum Value');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `regulatory_standard` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Standard');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER_PLM|OPCENTER_MES|MINDSPHERE|MANUAL|MIGRATION');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Attribute Status');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|draft|deprecated|under_review');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `string_value` SET TAGS ('dbx_business_glossary_term' = 'String Attribute Value');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `tolerance_unit` SET TAGS ('dbx_business_glossary_term' = 'Tolerance Unit Type');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `tolerance_unit` SET TAGS ('dbx_value_regex' = 'percent|absolute');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ALTER COLUMN `value_tolerance` SET TAGS ('dbx_business_glossary_term' = 'Value Tolerance');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` SET TAGS ('dbx_subdomain' = 'information_management');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` SET TAGS ('dbx_original_name' = 'product_change_notice');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `change_notice_id` SET TAGS ('dbx_business_glossary_term' = 'Product Change Notice Identifier');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `eco_id` SET TAGS ('dbx_business_glossary_term' = 'Eco Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Engineer Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `regulatory_change_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Change Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `affected_catalog_item_count` SET TAGS ('dbx_business_glossary_term' = 'Affected Catalog Item Count');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `affected_catalog_item_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `affected_sku_count` SET TAGS ('dbx_business_glossary_term' = 'Affected Stock Keeping Unit (SKU) Count');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `affected_sku_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `approval_level` SET TAGS ('dbx_business_glossary_term' = 'Approval Level');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `approval_level` SET TAGS ('dbx_value_regex' = 'engineering|product_management|quality|regulatory|executive|change_control_board');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|conditionally_approved|rejected|escalated');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `bom_change_flag` SET TAGS ('dbx_business_glossary_term' = 'Bill of Materials (BOM) Change Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `bom_change_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `ce_marking_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'CE Marking Impact Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `ce_marking_impact_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `change_category` SET TAGS ('dbx_business_glossary_term' = 'Change Category');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `change_category` SET TAGS ('dbx_value_regex' = 'major|minor|administrative');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `change_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Change Reason Code');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `change_type` SET TAGS ('dbx_business_glossary_term' = 'Change Type');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `change_type` SET TAGS ('dbx_value_regex' = 'design_change|material_substitution|regulatory_update|cost_reduction|process_change|safety_update|customer_driven|supplier_driven|obsolescence');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `cost_impact_amount` SET TAGS ('dbx_business_glossary_term' = 'Cost Impact Amount');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `cost_impact_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `cost_impact_currency` SET TAGS ('dbx_business_glossary_term' = 'Cost Impact Currency');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `cost_impact_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Change Notice Description');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `disposition_code` SET TAGS ('dbx_business_glossary_term' = 'Disposition Code');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `disposition_code` SET TAGS ('dbx_value_regex' = 'use_as_is|rework|scrap|return_to_supplier|hold_for_review');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `ecn_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Number');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `ecn_number` SET TAGS ('dbx_value_regex' = '^ECN-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `eco_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Order (ECO) Number');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `eco_number` SET TAGS ('dbx_value_regex' = '^ECO-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `effectivity_date` SET TAGS ('dbx_business_glossary_term' = 'Change Effectivity Date');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `effectivity_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `effectivity_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Effectivity Serial Number');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `effectivity_type` SET TAGS ('dbx_business_glossary_term' = 'Effectivity Type');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `effectivity_type` SET TAGS ('dbx_value_regex' = 'date_based|serial_number_based|lot_number_based|unit_number_based');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `export_control_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Export Control Impact Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `export_control_impact_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `implementation_date` SET TAGS ('dbx_business_glossary_term' = 'Implementation Date');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `implementation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `originating_system` SET TAGS ('dbx_business_glossary_term' = 'Originating System');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `originating_system` SET TAGS ('dbx_value_regex' = 'teamcenter_plm|sap_s4hana|opcenter_mes|manual|other');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `part_number_change_flag` SET TAGS ('dbx_business_glossary_term' = 'Part Number Change Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `part_number_change_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `planned_implementation_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Implementation Date');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `planned_implementation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Change Priority');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `reach_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Impact Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `reach_impact_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `regulatory_driver` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Driver');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `regulatory_driver` SET TAGS ('dbx_value_regex' = 'rohs|reach|ce_marking|ul_certification|iso_9001|iso_14001|iso_45001|osha|epa|iec_62443|none|other');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `rohs_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Impact Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `rohs_impact_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `sap_change_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Engineering Change Number');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Change Notice Status');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|approved|rejected|implemented|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `submitted_by` SET TAGS ('dbx_business_glossary_term' = 'Submitted By');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `submitted_date` SET TAGS ('dbx_business_glossary_term' = 'Submission Date');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `submitted_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `teamcenter_change_object_reference` SET TAGS ('dbx_business_glossary_term' = 'Siemens Teamcenter Change Object Identifier');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Change Notice Title');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `ul_certification_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Underwriters Laboratories (UL) Certification Impact Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ALTER COLUMN `ul_certification_impact_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` SET TAGS ('dbx_subdomain' = 'information_management');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` SET TAGS ('dbx_original_name' = 'product_launch');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `launch_id` SET TAGS ('dbx_business_glossary_term' = 'Product Launch ID');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `change_notice_id` SET TAGS ('dbx_business_glossary_term' = 'Product Change Notice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Launch Manager Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `project_id` SET TAGS ('dbx_business_glossary_term' = 'Siemens Teamcenter PLM Project ID');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `actual_launch_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Launch Date');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `actual_launch_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `apqp_gate_status` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Gate Status');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `apqp_gate_status` SET TAGS ('dbx_value_regex' = 'not_started|in_review|approved|conditionally_approved|rejected');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Product Launch Budget Amount');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `budget_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `budget_currency` SET TAGS ('dbx_business_glossary_term' = 'Product Launch Budget Currency');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `budget_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `business_unit` SET TAGS ('dbx_business_glossary_term' = 'Business Unit');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Launch Cancellation Reason');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `ce_marking_required` SET TAGS ('dbx_business_glossary_term' = 'CE Marking Required Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `ce_marking_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `certifications_obtained_flag` SET TAGS ('dbx_business_glossary_term' = 'Certifications Obtained Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `certifications_obtained_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Product Launch Code');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}-[A-Z0-9]{4,10}-[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `delay_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Launch Delay Reason Code');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `delay_reason_code` SET TAGS ('dbx_value_regex' = 'certification_delay|supply_chain_issue|design_change|regulatory_hold|resource_constraint|market_conditions|quality_issue|other');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Product Launch Description');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `documentation_published_flag` SET TAGS ('dbx_business_glossary_term' = 'Documentation Published Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `documentation_published_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Export Control Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `first_customer_shipment_date` SET TAGS ('dbx_business_glossary_term' = 'First Customer Shipment (FCS) Date');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `first_customer_shipment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `go_to_market_strategy` SET TAGS ('dbx_business_glossary_term' = 'Go-to-Market (GTM) Strategy');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `go_to_market_strategy` SET TAGS ('dbx_value_regex' = 'direct_sales|channel_partner|distributor|oem|ecommerce|hybrid');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `manufacturing_readiness_flag` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Readiness Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `manufacturing_readiness_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Product Launch Name');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `npi_phase` SET TAGS ('dbx_business_glossary_term' = 'New Product Introduction (NPI) Phase');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `npi_phase` SET TAGS ('dbx_value_regex' = 'concept|feasibility|design|prototype|validation|pilot_production|launch_readiness|launched');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `ppap_status` SET TAGS ('dbx_business_glossary_term' = 'Production Part Approval Process (PPAP) Status');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `ppap_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|submitted|approved|rejected|interim_approval');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `pricing_loaded_flag` SET TAGS ('dbx_business_glossary_term' = 'Pricing Loaded Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `pricing_loaded_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `product_family` SET TAGS ('dbx_business_glossary_term' = 'Product Family');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `readiness_score_percent` SET TAGS ('dbx_business_glossary_term' = 'Launch Readiness Score Percentage');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `readiness_score_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `responsible_product_manager` SET TAGS ('dbx_business_glossary_term' = 'Responsible Product Manager');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `sales_training_completed_flag` SET TAGS ('dbx_business_glossary_term' = 'Sales Training Completed Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `sales_training_completed_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `sap_project_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Project System (PS) Project ID');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER_PLM|OPCENTER_MES|SALESFORCE_CRM|MANUAL');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Product Launch Status');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'planned|in_progress|launched|cancelled|on_hold|delayed');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `supply_chain_readiness_flag` SET TAGS ('dbx_business_glossary_term' = 'Supply Chain Readiness Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `supply_chain_readiness_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `target_countries` SET TAGS ('dbx_business_glossary_term' = 'Target Countries');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `target_fcs_date` SET TAGS ('dbx_business_glossary_term' = 'Target First Customer Shipment (FCS) Date');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `target_fcs_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `target_launch_date` SET TAGS ('dbx_business_glossary_term' = 'Target Launch Date');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `target_launch_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `target_markets` SET TAGS ('dbx_business_glossary_term' = 'Target Markets');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `target_regions` SET TAGS ('dbx_business_glossary_term' = 'Target Regions');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Product Launch Type');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'global|regional|limited_release|pilot|soft_launch');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `ul_certification_required` SET TAGS ('dbx_business_glossary_term' = 'UL Certification Required Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ALTER COLUMN `ul_certification_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` SET TAGS ('dbx_subdomain' = 'commercial_pricing');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `warranty_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy ID');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `applicable_market_regions` SET TAGS ('dbx_business_glossary_term' = 'Applicable Geographic Market Regions');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `applicable_product_scope` SET TAGS ('dbx_business_glossary_term' = 'Applicable Product Scope');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `applicable_product_scope` SET TAGS ('dbx_value_regex' = 'all_products|product_family|product_category|specific_sku|automation_systems|electrification_solutions|smart_infrastructure|aftermarket_parts');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Approved By');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `claim_limit_currency` SET TAGS ('dbx_business_glossary_term' = 'Claim Limit Currency Code');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `claim_limit_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `coverage_scope` SET TAGS ('dbx_business_glossary_term' = 'Warranty Coverage Scope');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `coverage_scope` SET TAGS ('dbx_value_regex' = 'parts_only|parts_and_labor|full_replacement|on_site_service|depot_repair|software_only|consumables_excluded');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Description');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `dispute_resolution_mechanism` SET TAGS ('dbx_business_glossary_term' = 'Warranty Dispute Resolution Mechanism');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `dispute_resolution_mechanism` SET TAGS ('dbx_value_regex' = 'arbitration|mediation|litigation|expert_determination|ombudsman');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `duration_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Duration (Months)');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `duration_months` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]{0,3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `exclusion_conditions` SET TAGS ('dbx_business_glossary_term' = 'Warranty Exclusion Conditions');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `governing_law_country` SET TAGS ('dbx_business_glossary_term' = 'Governing Law Country Code');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `governing_law_country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `labor_coverage_months` SET TAGS ('dbx_business_glossary_term' = 'Labor Coverage Duration (Months)');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `labor_coverage_months` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Language Code');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `max_claim_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Warranty Claim Amount');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `max_claim_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Name');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `on_site_service_included` SET TAGS ('dbx_business_glossary_term' = 'On-Site Service Included Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `on_site_service_included` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `parts_coverage_months` SET TAGS ('dbx_business_glossary_term' = 'Parts Coverage Duration (Months)');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `parts_coverage_months` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `policy_code` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Code');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `policy_code` SET TAGS ('dbx_value_regex' = '^WP-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `preventive_maintenance_included` SET TAGS ('dbx_business_glossary_term' = 'Preventive Maintenance Included Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `preventive_maintenance_included` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `pro_rata_applicable` SET TAGS ('dbx_business_glossary_term' = 'Pro-Rata Warranty Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `pro_rata_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `registration_required` SET TAGS ('dbx_business_glossary_term' = 'Warranty Registration Required Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `registration_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `registration_window_days` SET TAGS ('dbx_business_glossary_term' = 'Warranty Registration Window (Days)');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `registration_window_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `regulatory_compliance_flags` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flags');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `renewable` SET TAGS ('dbx_business_glossary_term' = 'Warranty Renewable Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `renewable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `resolution_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Warranty Resolution Time (Hours)');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `resolution_time_hours` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `response_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Warranty Response Time (Hours)');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `response_time_hours` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_SD|Salesforce_Service|Teamcenter_PLM|Manual|Legacy');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Status');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|superseded|retired|under_review');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `transferable` SET TAGS ('dbx_business_glossary_term' = 'Warranty Transferability Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `transferable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Version Number');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `warranty_start_basis` SET TAGS ('dbx_business_glossary_term' = 'Warranty Start Basis');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `warranty_start_basis` SET TAGS ('dbx_value_regex' = 'ship_date|delivery_date|installation_date|commissioning_date|invoice_date|first_use_date|registration_date');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `warranty_type` SET TAGS ('dbx_business_glossary_term' = 'Warranty Type');
ALTER TABLE `manufacturing_ecm`.`product`.`warranty_policy` ALTER COLUMN `warranty_type` SET TAGS ('dbx_value_regex' = 'standard|extended|performance_guarantee|limited|statutory|supplier_passthrough');
ALTER TABLE `manufacturing_ecm`.`product`.`market` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`product`.`market` SET TAGS ('dbx_subdomain' = 'distribution_operations');
ALTER TABLE `manufacturing_ecm`.`product`.`market` SET TAGS ('dbx_original_name' = 'product_market');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `market_id` SET TAGS ('dbx_business_glossary_term' = 'Product Market ID');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `aftermarket_support_available` SET TAGS ('dbx_business_glossary_term' = 'Aftermarket Support Availability Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `aftermarket_support_available` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `channel_partner_required` SET TAGS ('dbx_business_glossary_term' = 'Channel Partner Required Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `channel_partner_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Market Code');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Market Currency Code');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `customs_tariff_code` SET TAGS ('dbx_business_glossary_term' = 'Customs Tariff Code (Harmonized Tariff Code)');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `eccn` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification Number (ECCN)');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `eccn` SET TAGS ('dbx_value_regex' = '^[0-9][A-Z][0-9]{3}[a-z]?$');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `entry_date` SET TAGS ('dbx_business_glossary_term' = 'Market Entry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `entry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `exit_date` SET TAGS ('dbx_business_glossary_term' = 'Market Exit Date');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `exit_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Export Control Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `industry_segment` SET TAGS ('dbx_business_glossary_term' = 'Target Industry Segment');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `industry_segment` SET TAGS ('dbx_value_regex' = 'Automotive|Food and Beverage|Oil and Gas|Building Automation|Transportation|Pharmaceutical|Semiconductor|Aerospace and Defense|Energy and Utilities|Water and Wastewater|Mining|Pulp and Paper|General Manufacturing|Other');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `labeling_requirement` SET TAGS ('dbx_business_glossary_term' = 'Market-Specific Labeling Requirement');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `launch_type` SET TAGS ('dbx_business_glossary_term' = 'Market Launch Type');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `launch_type` SET TAGS ('dbx_value_regex' = 'new_product|product_extension|variant|relaunch|aftermarket_part');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Market Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `list_price` SET TAGS ('dbx_business_glossary_term' = 'Market List Price');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `list_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `local_product_name` SET TAGS ('dbx_business_glossary_term' = 'Local Market Product Name');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Product Market Notes');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `price_effective_date` SET TAGS ('dbx_business_glossary_term' = 'Market Price Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `price_effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `regulatory_approval_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Date');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `regulatory_approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `regulatory_approval_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `regulatory_approval_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Approval Status');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `regulatory_approval_status` SET TAGS ('dbx_value_regex' = 'approved|pending|not_required|rejected|expired|under_review');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER_PLM|SALESFORCE_CRM|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Product Market Status');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|planned|discontinued|suspended|under_review|pending_approval');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `strategic_priority` SET TAGS ('dbx_business_glossary_term' = 'Market Strategic Priority');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `strategic_priority` SET TAGS ('dbx_value_regex' = 'high|medium|low|not_targeted');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `tax_classification_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Classification Code');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `variant_code` SET TAGS ('dbx_business_glossary_term' = 'Market-Specific Variant Code');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `warranty_months` SET TAGS ('dbx_business_glossary_term' = 'Market Warranty Period (Months)');
ALTER TABLE `manufacturing_ecm`.`product`.`market` ALTER COLUMN `warranty_months` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` SET TAGS ('dbx_subdomain' = 'regulatory_compliance');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` SET TAGS ('dbx_association_edges' = 'product.catalog_item,product.hazardous_substance');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` SET TAGS ('dbx_original_name' = 'product_substance_declaration');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `substance_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Product Substance Declaration ID');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Product Substance Declaration - Catalog Item Id');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `hazardous_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Product Substance Declaration - Hazardous Substance Id');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `concentration_ppm` SET TAGS ('dbx_business_glossary_term' = 'Concentration (PPM)');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `data_source_type` SET TAGS ('dbx_business_glossary_term' = 'Data Source Type');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `declaration_date` SET TAGS ('dbx_business_glossary_term' = 'Declaration Date');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `exceeds_threshold` SET TAGS ('dbx_business_glossary_term' = 'Exceeds Threshold Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `exemption_reference` SET TAGS ('dbx_business_glossary_term' = 'Exemption Reference');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `material_application` SET TAGS ('dbx_business_glossary_term' = 'Material Application');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `review_due_date` SET TAGS ('dbx_business_glossary_term' = 'Review Due Date');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `substance_function` SET TAGS ('dbx_business_glossary_term' = 'Substance Function');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `supplier_declaration_reference` SET TAGS ('dbx_business_glossary_term' = 'Supplier Declaration Reference');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `test_report_number` SET TAGS ('dbx_business_glossary_term' = 'Test Report Number');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `testing_laboratory` SET TAGS ('dbx_business_glossary_term' = 'Testing Laboratory');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` SET TAGS ('dbx_subdomain' = 'distribution_operations');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` SET TAGS ('dbx_association_edges' = 'product.catalog_item,sales.channel_partner');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `partner_authorization_id` SET TAGS ('dbx_business_glossary_term' = 'Partner Authorization Identifier');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Partner Authorization - Catalog Item Id');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `channel_partner_id` SET TAGS ('dbx_business_glossary_term' = 'Partner Authorization - Channel Partner Id');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `authorization_level` SET TAGS ('dbx_business_glossary_term' = 'Authorization Level');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `certification_required` SET TAGS ('dbx_business_glossary_term' = 'Certification Required Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `certification_status` SET TAGS ('dbx_business_glossary_term' = 'Product Certification Status');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Authorization Created Date');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `discount_tier` SET TAGS ('dbx_business_glossary_term' = 'Product-Specific Discount Tier');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Authorization Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Authorization Expiration Date');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `last_modified_date` SET TAGS ('dbx_business_glossary_term' = 'Authorization Last Modified Date');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Partner Lead Time');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `max_discount_pct` SET TAGS ('dbx_business_glossary_term' = 'Maximum Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `min_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `rebate_eligible` SET TAGS ('dbx_business_glossary_term' = 'Rebate Eligibility Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `sales_target_amount` SET TAGS ('dbx_business_glossary_term' = 'Product-Specific Sales Target');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `sales_target_currency` SET TAGS ('dbx_business_glossary_term' = 'Sales Target Currency');
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Authorization Status');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` SET TAGS ('dbx_subdomain' = 'distribution_operations');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` SET TAGS ('dbx_association_edges' = 'product.catalog_item,quality.quality_characteristic');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` SET TAGS ('dbx_original_name' = 'product_quality_specification');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `quality_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Quality Specification ID');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Product Quality Specification - Catalog Item Id');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Product Quality Specification - Quality Characteristic Id');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `quality_characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic ID');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `control_method` SET TAGS ('dbx_business_glossary_term' = 'Control Method');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Created Date');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `engineering_change_number` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Number');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `inspection_frequency` SET TAGS ('dbx_business_glossary_term' = 'Inspection Frequency');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `last_modified_date` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Date');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `lower_tolerance` SET TAGS ('dbx_business_glossary_term' = 'Lower Tolerance');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `measurement_method` SET TAGS ('dbx_business_glossary_term' = 'Measurement Method');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `specification_status` SET TAGS ('dbx_business_glossary_term' = 'Specification Status');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `specification_value` SET TAGS ('dbx_business_glossary_term' = 'Specification Value');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `upper_tolerance` SET TAGS ('dbx_business_glossary_term' = 'Upper Tolerance');
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` SET TAGS ('dbx_subdomain' = 'distribution_operations');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` SET TAGS ('dbx_association_edges' = 'product.sku,procurement.supplier');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `product_material_info_record_id` SET TAGS ('dbx_business_glossary_term' = 'product_material_info_record Identifier');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `procurement_material_info_record_id` SET TAGS ('dbx_business_glossary_term' = 'Material Info Record ID');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Material Info Record - Supplier Id');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Material Info Record - Sku Id');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Created Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `last_modified_date` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Date');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `last_purchase_price` SET TAGS ('dbx_business_glossary_term' = 'Last Purchase Price');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `last_purchase_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Days');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `preferred_supplier_flag` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier Flag');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Info Record Status');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ALTER COLUMN `unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` SET TAGS ('dbx_subdomain' = 'regulatory_compliance');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` SET TAGS ('dbx_association_edges' = 'product.catalog_item,compliance.regulatory_requirement');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` SET TAGS ('dbx_original_name' = 'product_compliance');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `compliance_id` SET TAGS ('dbx_business_glossary_term' = 'Product Compliance Identifier');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Product Compliance - Catalog Item Id');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `evidence_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Evidence Identifier');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Product Compliance - Regulatory Requirement Id');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `audit_notes` SET TAGS ('dbx_business_glossary_term' = 'Audit Notes');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `certification_number` SET TAGS ('dbx_business_glossary_term' = 'Certification Number');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Record Created Date');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Compliance Effective Date');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `last_updated_date` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Date');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `next_verification_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Verification Due Date');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `non_compliance_reason` SET TAGS ('dbx_business_glossary_term' = 'Non-Compliance Reason');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `remediation_plan` SET TAGS ('dbx_business_glossary_term' = 'Remediation Plan');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `responsible_party` SET TAGS ('dbx_business_glossary_term' = 'Compliance Responsible Party');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Compliance Verification Date');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `waiver_approved_by` SET TAGS ('dbx_business_glossary_term' = 'Waiver Approved By');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `waiver_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Waiver Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ALTER COLUMN `waiver_justification` SET TAGS ('dbx_business_glossary_term' = 'Waiver Justification');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` SET TAGS ('dbx_subdomain' = 'regulatory_compliance');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` SET TAGS ('dbx_association_edges' = 'product.sku,compliance.jurisdiction');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `market_authorization_id` SET TAGS ('dbx_business_glossary_term' = 'Market Authorization ID');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `jurisdiction_id` SET TAGS ('dbx_business_glossary_term' = 'Market Authorization - Jurisdiction Id');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Market Authorization - Sku Id');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `authorization_date` SET TAGS ('dbx_business_glossary_term' = 'Authorization Date');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `authorized_by` SET TAGS ('dbx_business_glossary_term' = 'Authorized By');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `certification_type` SET TAGS ('dbx_business_glossary_term' = 'Certification Type');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Record Created Date');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Authorization Expiry Date');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Last Audit Date');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `last_updated_date` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Date');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `local_restrictions` SET TAGS ('dbx_business_glossary_term' = 'Local Restrictions');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `next_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Next Audit Date');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Authorization Notes');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `registration_number` SET TAGS ('dbx_business_glossary_term' = 'Registration Number');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `regulatory_authority` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Authority');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `renewal_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Renewal Frequency');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `renewal_required` SET TAGS ('dbx_business_glossary_term' = 'Renewal Required');
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Authorization Status');
