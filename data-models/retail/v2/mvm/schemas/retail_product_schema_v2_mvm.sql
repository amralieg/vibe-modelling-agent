-- Schema for Domain: product | Business: Retail | Version: v2_mvm
-- Generated on: 2026-07-12 10:43:58

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`product` COMMENT 'Authoritative catalog of all merchandise including SKUs, UPCs, GTINs, EANs, product hierarchies (department, category, subcategory), attributes, descriptions, images, private label vs. national brands, and assortment depth and breadth classifications. Managed via PIM (Product Information Management) and MDM systems. Supports category management, new item setup, and product lifecycle from introduction to discontinuation.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`sku` (
    `sku_id` BIGINT COMMENT 'Unique identifier for the Stock Keeping Unit. Primary key for the SKU master record.',
    `brand_id` BIGINT COMMENT 'add column product_brand_id (BIGINT) with FK to product.product_brand.product_brand_id - SKUs belong to brands and this relationship is fundamental for brand-level reporting and assortment planning',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: sku has department_code, category_code, subcategory_code (all STRING) which should be normalized to a single FK to item_hierarchy. The hierarchy table is the authoritative source for merchandise taxon',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: sku.unit_of_measure (STRING) should be normalized to a proper FK to uom reference table. UOM is the authoritative master for all units of measure with conversion factors and standards compliance (GS1,',
    `age_restriction_flag` BOOLEAN COMMENT 'Indicates whether this SKU has age restrictions for purchase (e.g., alcohol, tobacco, mature-rated products). True if age-restricted, False if not.',
    `country_of_origin` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code indicating where the product was manufactured or produced. Required for customs and regulatory compliance.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this SKU record was first created in the master data system. Follows format yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `cube` DECIMAL(18,2) COMMENT 'Cubic volume of the SKU package calculated as length × width × height. Used for warehouse space planning and transportation optimization. Measured in cubic feet or cubic meters.',
    `sku_description` STRING COMMENT 'Detailed textual description of the SKU including key product attributes, features, and specifications. Used for product information management and customer-facing displays.',
    `dimension_unit_of_measure` STRING COMMENT 'Unit of measure for length, width, and height fields. IN (Inch), CM (Centimeter), FT (Foot), M (Meter).. Valid values are `IN|CM|FT|M`',
    `discontinuation_date` DATE COMMENT 'Date when this SKU will be or was discontinued and removed from the active assortment. Null if the SKU is not planned for discontinuation. Follows format yyyy-MM-dd.',
    `ean` STRING COMMENT '13-digit European Article Number used for product identification globally. International barcode standard.. Valid values are `^[0-9]{13}$`',
    `effective_date` DATE COMMENT 'Date when this SKU becomes active and available for sale. Used for new product launches and seasonal assortment planning. Follows format yyyy-MM-dd.',
    `gross_weight` DECIMAL(18,2) COMMENT 'Total weight of the SKU including packaging, measured in the unit specified by weight_unit_of_measure. Used for shipping and logistics calculations.',
    `gtin` STRING COMMENT 'Global Trade Item Number that uniquely identifies trade items worldwide. Can be 8, 12, 13, or 14 digits. Umbrella term encompassing UPC, EAN, and other GS1 identifiers.. Valid values are `^[0-9]{8}$|^[0-9]{12}$|^[0-9]{13}$|^[0-9]{14}$`',
    `hazmat_flag` BOOLEAN COMMENT 'Indicates whether this SKU is classified as hazardous material requiring special handling, storage, and transportation procedures. True if hazmat, False if not.',
    `height` DECIMAL(18,2) COMMENT 'Height dimension of the SKU package, measured in the unit specified by dimension_unit_of_measure. Used for space planning and logistics.',
    `hi` STRING COMMENT 'Number of layers (tiers) that can be stacked on a pallet. Part of the Ti-Hi pallet configuration used in warehouse and distribution center operations.',
    `image_url` STRING COMMENT 'URL or file path to the primary product image. Used for e-commerce, mobile apps, and digital signage.',
    `internal_item_number` STRING COMMENT 'Retailer-specific internal product identifier used in legacy systems and internal operations. May differ from external GTIN/UPC.',
    `length` DECIMAL(18,2) COMMENT 'Length dimension of the SKU package, measured in the unit specified by dimension_unit_of_measure. Used for space planning and logistics.',
    `lifecycle_status` STRING COMMENT 'Current lifecycle status of the SKU in the product assortment. ACTIVE (currently sold), DISCONTINUED (no longer ordered), SEASONAL (sold during specific periods), CLEARANCE (being phased out), PENDING_SETUP (not yet available for sale), INACTIVE (temporarily unavailable).. Valid values are `ACTIVE|DISCONTINUED|SEASONAL|CLEARANCE|PENDING_SETUP|INACTIVE`',
    `minimum_age_requirement` STRING COMMENT 'Minimum age in years required to purchase this SKU. Null if no age restriction applies. Typically 18 or 21 for restricted products.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this SKU record was last modified in the master data system. Follows format yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `net_weight` DECIMAL(18,2) COMMENT 'Weight of the product contents excluding packaging, measured in the unit specified by weight_unit_of_measure. Used for regulatory compliance and consumer information.',
    `pack_size` STRING COMMENT 'Number of consumer units contained in a single sellable pack. For example, a 6-pack of soda has pack_size = 6.',
    `private_label_flag` BOOLEAN COMMENT 'Indicates whether this SKU is a private label (store brand) product or a national brand. True for private label, False for national brand.',
    `shelf_life_days` STRING COMMENT 'Number of days the product remains sellable and safe for consumption from the date of manufacture or receipt. Critical for perishable goods and inventory rotation.',
    `short_description` STRING COMMENT 'Abbreviated product description for use in constrained display contexts such as receipts, labels, and mobile interfaces. Typically 40-60 characters.',
    `stackable_flag` BOOLEAN COMMENT 'Indicates whether this SKU can be safely stacked during storage and transportation. True if stackable, False if not.',
    `temperature_requirement` STRING COMMENT 'Storage and transportation temperature requirement for the SKU. AMBIENT (room temperature), REFRIGERATED (32-40°F), FROZEN (below 0°F), CONTROLLED (specific temperature range).. Valid values are `AMBIENT|REFRIGERATED|FROZEN|CONTROLLED`',
    `ti` STRING COMMENT 'Number of units per layer on a pallet. Part of the Ti-Hi pallet configuration used in warehouse and distribution center operations.',
    `upc` STRING COMMENT '12-digit Universal Product Code used for point-of-sale scanning in North America. Standard barcode identifier for retail products.. Valid values are `^[0-9]{12}$`',
    `vendor_item_number` STRING COMMENT 'The suppliers own product identifier for this SKU. Used for purchase orders and vendor communication.',
    `volume` DECIMAL(18,2) COMMENT 'Volume or capacity of the product, measured in the unit specified by volume_unit_of_measure. Relevant for liquid and bulk products.',
    `volume_unit_of_measure` STRING COMMENT 'Unit of measure for volume field. GAL (Gallon), LTR (Liter), ML (Milliliter), OZ (Fluid Ounce), QT (Quart).. Valid values are `GAL|LTR|ML|OZ|QT`',
    `weight_unit_of_measure` STRING COMMENT 'Unit of measure for gross_weight and net_weight fields. LB (Pound), KG (Kilogram), OZ (Ounce), G (Gram).. Valid values are `LB|KG|OZ|G`',
    `width` DECIMAL(18,2) COMMENT 'Width dimension of the SKU package, measured in the unit specified by dimension_unit_of_measure. Used for space planning and logistics.',
    CONSTRAINT pk_sku PRIMARY KEY(`sku_id`)
) COMMENT 'Authoritative master record for every Stock Keeping Unit (SKU) in the retail assortment. This is the SSOT for all SKU-level product identity and physical characteristics across the enterprise. Captures the unique sellable unit identity including UPC, EAN, GTIN, internal item number, SKU description, brand reference, unit of measure, pack size, weight, dimensions (gross/net weight, length, width, height, volume, cube), ti-hi pallet configuration, temperature requirement, stackability, country of origin, hazmat flag, age-restriction flag, shelf life, product lifecycle status (active, discontinued, seasonal, clearance, pending setup), and creation/modification timestamps. Aligned with GS1 GDSN Trade Item standard. Sourced from the customer master data system and the retail merchandising system Merchandising System (ORMS). Central hub entity — all other product domain entities reference this record.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`item_hierarchy` (
    `item_hierarchy_id` BIGINT COMMENT 'Unique identifier for the item hierarchy node. Primary key for the item hierarchy entity. This is the system-generated surrogate key for each node in the merchandise hierarchy tree.',
    `parent_hierarchy_node_item_hierarchy_id` BIGINT COMMENT 'Foreign key reference to the parent node in the hierarchy tree. Self-referencing relationship enabling tree traversal and roll-up aggregations. Null for top-level division nodes.',
    `allows_direct_sku_assignment` BOOLEAN COMMENT 'Boolean flag indicating whether SKUs can be directly assigned to this hierarchy node. Typically True for leaf nodes (subcategory, segment, class) and False for parent nodes (division, department, category). Controls data quality and hierarchy integrity in PIM (Product Information Management) systems.',
    `assortment_breadth_target` STRING COMMENT 'Target number of distinct subcategories or product families within this category. Assortment breadth measures the range of categories offered. Used in category management and OTB (Open to Buy) planning.',
    `assortment_depth_target` STRING COMMENT 'Target number of distinct SKUs (Stock Keeping Units) within a subcategory or product family. Assortment depth measures the variety within a category. Deeper assortments offer more choice but increase inventory complexity and carrying costs.',
    `category_manager_name` STRING COMMENT 'Name of the category manager responsible for strategic category management, assortment optimization, and category P&L performance. Category managers define assortment breadth and depth targets and drive GMROI (Gross Margin Return on Investment).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this hierarchy node record was first created in the system. Supports audit trail, data lineage, and master data governance. Automatically populated by the customer master data system (Master Data Management) or source system.',
    `data_quality_score` DECIMAL(18,2) COMMENT 'Automated data quality score (0-100) calculated by the customer master data system based on completeness, accuracy, consistency, and timeliness rules. Scores below threshold trigger data stewardship workflows. Supports master data governance and continuous improvement.',
    `effective_end_date` DATE COMMENT 'Date when this hierarchy node is retired or deprecated. Null for currently active nodes. Supports historical reporting and category lifecycle management. Enables analysis of discontinued categories and assortment changes over time.',
    `effective_start_date` DATE COMMENT 'Date when this hierarchy node becomes active and available for use in assortment planning, purchase orders, and reporting. Supports time-variant hierarchy structures and seasonal category introductions.',
    `external_reference_code` STRING COMMENT 'External identifier from source system or third-party data provider. Used for cross-system reconciliation, EDI (Electronic Data Interchange) integration, and external reporting. Examples: GS1 category codes, NRF ARTS hierarchy IDs, supplier category codes.',
    `hierarchy_description` STRING COMMENT 'Detailed description of the hierarchy node purpose, scope, and business rules. Includes category definition, inclusion/exclusion criteria, and merchandising guidelines. Used for training, onboarding, and cross-functional alignment.',
    `hierarchy_level` STRING COMMENT 'The level of this node within the merchandise hierarchy tree. Defines the depth and classification granularity. Division is the highest level, followed by department, category, subcategory, segment, and class as the most granular.. Valid values are `division|department|category|subcategory|segment|class`',
    `hierarchy_node_code` STRING COMMENT 'Business identifier code for the hierarchy node. This is the externally-known unique code used in the retail merchandising system Merchandising System (ORMS) and SAP S/4HANA MM module for category management and reporting. Examples: DEPT01, CAT-ELEC, SUBCAT-TV.. Valid values are `^[A-Z0-9]{2,20}$`',
    `hierarchy_node_name` STRING COMMENT 'Human-readable name of the hierarchy node. Examples: Electronics, Home Appliances, Televisions, 4K Smart TVs. Used in reporting, planograms, and category management dashboards.',
    `hierarchy_path` STRING COMMENT 'Full path from root to current node using node codes separated by forward slashes. Example: DIVISION01/DEPT05/CAT-ELEC/SUBCAT-TV. Enables efficient hierarchy queries and reporting roll-ups without recursive joins.',
    `hierarchy_type` STRING COMMENT 'Classification of the hierarchy purpose. Operational hierarchies support daily store operations and planograms. Strategic hierarchies support category management and assortment planning. Financial hierarchies align with P&L reporting. Planning hierarchies support OTB (Open to Buy) and MRP (Material Requirements Planning).. Valid values are `operational|strategic|financial|planning|reporting`',
    `is_leaf_node` BOOLEAN COMMENT 'Boolean flag indicating whether this node is a leaf node (has no children) in the hierarchy tree. Leaf nodes are the most granular classification level and are directly associated with SKUs. True for leaf nodes, False for parent nodes.',
    `last_modified_by` STRING COMMENT 'User ID or system account that last modified this hierarchy node record. Supports audit trail, accountability, and master data governance. Captured from the customer master data system workflow or source system authentication.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this hierarchy node record was last updated. Supports change tracking, audit trail, and incremental data pipeline processing. Updated automatically on every modification in the customer master data system or source system.',
    `lead_time_days` STRING COMMENT 'Average supplier delivery lead time in days for this category. Used in demand planning, safety stock calculations, and OTB (Open to Buy) planning. Managed in Blue Yonder Demand Planning and the retail merchandising system Merchandising System (ORMS).',
    `lifecycle_status` STRING COMMENT 'Current lifecycle state of the hierarchy node. Active nodes are in use for assortment planning and reporting. Inactive nodes are temporarily disabled. Pending nodes are awaiting approval. Deprecated nodes are being phased out. Archived nodes are retained for historical reporting only.. Valid values are `active|inactive|pending|deprecated|archived`',
    `markdown_cadence` STRING COMMENT 'Frequency and timing of planned price markdowns for this category. Weekly and biweekly cadences support fast fashion and perishables. Monthly cadences support durable goods. Seasonal cadences align with end-of-season clearance. Event-driven markdowns respond to competitive pressure or excess inventory. Managed in the retail merchandising system Price Management (RPM).. Valid values are `weekly|biweekly|monthly|seasonal|event_driven|none`',
    `minimum_order_quantity` STRING COMMENT 'Minimum order quantity required by suppliers for this category. Impacts purchase order planning, inventory carrying costs, and cash flow management. Negotiated by buyers and enforced in procurement systems.',
    `omnichannel_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether this category is available across all channels (stores, e-commerce, mobile app, BOPIS, ship-from-store). True for omnichannel categories, False for channel-specific categories. Supports unified commerce strategy and cross-channel inventory visibility.',
    `planner_name` STRING COMMENT 'Name of the merchandise planner responsible for demand forecasting, inventory planning, and replenishment for this category. Planners use Blue Yonder Demand Planning to optimize inventory levels and minimize stockouts and overstock.',
    `pricing_strategy` STRING COMMENT 'Pricing strategy classification for this category. EDLP (Everyday Low Price) maintains consistent low prices. Hi-Lo (High-Low Pricing Strategy) uses frequent promotions and markdowns. Premium targets higher-margin positioning. Competitive matches market pricing. Value emphasizes affordability. Managed in the retail merchandising system Price Management (RPM).. Valid values are `edlp|hi_lo|premium|competitive|value`',
    `private_label_penetration_target_percent` DECIMAL(18,2) COMMENT 'Target percentage of category sales from private label (store brand) products. Private label products typically offer higher margins than national brands. Used in assortment planning and supplier negotiations to optimize category profitability.',
    `replenishment_method` STRING COMMENT 'Inventory replenishment method for this category. Auto uses system-driven replenishment based on demand forecasting. Manual requires planner intervention. Vendor Managed Inventory (VMI) delegates replenishment to suppliers. Cross-docking transfers inventory directly from receiving to shipping. Drop ship sends directly from vendor to customer.. Valid values are `auto|manual|vendor_managed|cross_dock|drop_ship`',
    `safety_stock_weeks` DECIMAL(18,2) COMMENT 'Target safety stock level expressed in weeks of supply (WOS). Buffer inventory to protect against demand variability and supply chain disruptions. Calculated based on service level targets and lead time variability in Blue Yonder Demand Planning.',
    `seasonality_indicator` STRING COMMENT 'Seasonal demand pattern classification for this category. Non-seasonal categories have consistent year-round demand. Seasonal categories have predictable demand peaks tied to calendar periods. Used in demand forecasting, markdown planning, and inventory optimization. [ENUM-REF-CANDIDATE: non_seasonal|spring|summer|fall|winter|holiday|back_to_school — 7 candidates stripped; promote to reference product]',
    `sort_order` STRING COMMENT 'Numeric sequence for ordering sibling nodes within the same parent. Used for consistent presentation in reports, planograms, and digital storefronts. Lower numbers appear first.',
    `strategic_classification` STRING COMMENT 'Strategic role of the category in the overall merchandising strategy. Destination categories drive store traffic and differentiation. Routine categories are frequently purchased staples. Convenience categories are impulse or fill-in purchases. Seasonal categories have time-bound demand. Private label vs. national brand classification supports margin optimization.. Valid values are `destination|routine|convenience|seasonal|private_label|national_brand`',
    `target_gross_margin_percent` DECIMAL(18,2) COMMENT 'Target gross margin percentage for this category, expressed as a percentage of net sales. Used in pricing strategy, markdown planning, and category performance evaluation. Supports GMROI (Gross Margin Return on Investment) optimization.',
    CONSTRAINT pk_item_hierarchy PRIMARY KEY(`item_hierarchy_id`)
) COMMENT 'Defines the full merchandise hierarchy and category taxonomy used to organize SKUs into departments, categories, subcategories, and segments for both operational and strategic purposes. This is the SSOT for all product classification and category management taxonomy. Captures hierarchy node identity, node code, node name, level (department, category, subcategory, segment), parent node reference (self-referencing for tree traversal), hierarchy path, hierarchy type (operational, strategic/category management), buyer assignment, planner assignment, strategic classification (destination, routine, convenience, seasonal), assortment breadth/depth targets, category manager, and effective dates. Supports category management, assortment planning, planogram design, financial reporting roll-ups, and NRF ARTS merchandise hierarchy alignment. Managed in the retail merchandising system Merchandising System (ORMS) and SAP S/4HANA MM module.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`attribute` (
    `attribute_id` BIGINT COMMENT 'Unique identifier for the product attribute record. Primary key for the product_attribute entity.',
    `sku_id` BIGINT COMMENT 'Foreign key reference to the parent product (SKU) to which this attribute belongs. Links to the product master catalog.',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: product_attribute stores a free-text unit_of_measure STRING column for the attribute_value (e.g., kg, cm, oz). The uom table is the authoritative UOM master in this domain. Normalizing this to a',
    `approved_by` STRING COMMENT 'The username or identifier of the person who approved this product attribute value for publication. Supports accountability and audit trails in PIM workflows.',
    `approved_timestamp` TIMESTAMP COMMENT 'The date and time when this product attribute value was approved for publication or use in operational systems. Supports PIM workflow and governance processes.',
    `attribute_group` STRING COMMENT 'Logical grouping or category of the attribute (e.g., physical, technical, descriptive, nutritional, environmental, regulatory, marketing, quality, packaging, pricing). Enables faceted search and attribute organization in PIM systems. [ENUM-REF-CANDIDATE: physical|technical|descriptive|nutritional|environmental|regulatory|marketing|quality|packaging|pricing — 10 candidates stripped; promote to reference product]',
    `attribute_status` STRING COMMENT 'Current lifecycle status of this attribute record (e.g., active, inactive, pending_approval, deprecated, archived). Supports attribute governance and PIM workflow management.. Valid values are `active|inactive|pending_approval|deprecated|archived`',
    `certification_body` STRING COMMENT 'The name of the organization or authority that certified this attribute value (e.g., USDA Organic, Energy Star, Fair Trade, UL Listed). Applicable when is_certified is True.',
    `certification_date` DATE COMMENT 'The date on which this attribute value was certified. Applicable when is_certified is True. Supports audit trails and compliance reporting.',
    `conversion_factor` DECIMAL(18,2) COMMENT 'Numeric conversion factor to translate this attributes unit of measure to a base or standard unit (e.g., 1 lb = 0.453592 kg). Enables cross-UOM calculations and reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this product attribute record was first created in the system. Supports audit trails and data lineage tracking.',
    `data_quality_score` DECIMAL(18,2) COMMENT 'Numeric score (0-100) representing the completeness and accuracy of this attribute value. Used for GS1 GDSN readiness assessment and PIM data quality dashboards.',
    `data_type` STRING COMMENT 'The data type of the attribute value (e.g., string, numeric, boolean, date, timestamp, decimal). Used for validation and type-safe processing in downstream systems.. Valid values are `string|numeric|boolean|date|timestamp|decimal`',
    `display_order` STRING COMMENT 'Numeric sequence controlling the display order of attributes on product detail pages, labels, and reports. Lower numbers appear first.',
    `effective_end_date` DATE COMMENT 'The date until which this attribute value is effective. Null indicates the attribute is currently active. Supports historical attribute tracking and product lifecycle management.',
    `effective_start_date` DATE COMMENT 'The date from which this attribute value is effective and should be used in product displays, transactions, and reporting. Supports time-variant attribute management.',
    `is_certified` BOOLEAN COMMENT 'Boolean flag indicating whether this attribute value has been certified or verified by an authoritative source (e.g., environmental certification, organic certification, safety compliance). True if certified, False otherwise.',
    `is_comparable` BOOLEAN COMMENT 'Boolean flag indicating whether this attribute should be displayed in product comparison views (True) or not (False). Supports side-by-side product comparison features in e-commerce.',
    `is_regulatory_required` BOOLEAN COMMENT 'Boolean flag indicating whether this attribute is required by regulatory or legal mandate (e.g., FDA nutritional labeling, CPSC safety warnings, FTC advertising disclosures). True if mandated, False otherwise.',
    `is_required` BOOLEAN COMMENT 'Boolean flag indicating whether this attribute is mandatory for the product (True) or optional (False). Used for data completeness scoring and GS1 GDSN readiness checks.',
    `is_searchable` BOOLEAN COMMENT 'Boolean flag indicating whether this attribute should be indexed for faceted search on e-commerce platforms (True) or not (False). Drives search and filter capabilities in digital commerce.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this product attribute record was last modified. Supports change tracking and data quality monitoring.',
    `locale` STRING COMMENT 'The locale or language-region code for this attribute value (e.g., en_US, es_MX, fr_CA). Supports multilingual and multi-market product catalogs for global retail operations.. Valid values are `^[a-z]{2}_[A-Z]{2}$`',
    `attribute_name` STRING COMMENT 'The name or label of the product attribute (e.g., color, size, fabric, flavor, wattage, nutritional_info). Represents the semantic key in the entity-attribute-value (EAV) pattern.',
    `notes` STRING COMMENT 'Free-text field for additional notes, comments, or context about this product attribute. Used for internal documentation, special handling instructions, or data steward annotations.',
    `regulatory_reference` STRING COMMENT 'Citation or reference to the specific regulation, statute, or standard that mandates this attribute (e.g., FDA 21 CFR 101.9, CPSC 16 CFR 1500, FTC 16 CFR Part 255). Applicable when is_regulatory_required is True.',
    `source_system_code` STRING COMMENT 'The unique identifier or key for this attribute record in the source system. Enables traceability and cross-system reconciliation.',
    `validation_rule` STRING COMMENT 'Business rule or regex pattern used to validate the attribute value (e.g., must be positive integer, must match color palette, must be ISO 8601 date). Enforces data quality at attribute capture time.',
    `value` DECIMAL(18,2) COMMENT 'The actual value of the product attribute (e.g., Red, Large, 100% Cotton, Vanilla, 60W, 15g protein per serving). Stores the descriptive, technical, or measurement data for the attribute.',
    CONSTRAINT pk_attribute PRIMARY KEY(`attribute_id`)
) COMMENT 'Stores extended descriptive, technical, and measurement attributes for each SKU beyond core identity fields using a flexible entity-attribute-value (EAV) pattern. Captures attribute name, attribute value, attribute group (e.g., fabric, color, size, flavor, nutritional supplement, technical spec, UOM conversion, environmental certification, data quality score), data type, unit of measure, conversion factor, validation rule, source system, and locale/language for multilingual and multi-market support. Enables faceted search on e-commerce platforms, product comparison, PIM-driven enrichment, multi-UOM transaction support across procurement/inventory/POS, data completeness scoring for GS1 GDSN readiness, and regulatory attribute capture. Sourced from the customer master data system PIM module and the e-commerce platform product catalog. Aligned with GS1 GDSN attribute standards for trade item data synchronization.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`brand` (
    `brand_id` BIGINT COMMENT 'Unique identifier for the product brand record. Primary key.',
    `item_hierarchy_id` BIGINT COMMENT 'add column item_hierarchy_id (BIGINT) with FK to product.item_hierarchy.item_hierarchy_id - brands operate within product hierarchy categories for category management',
    `average_margin_percent` DECIMAL(18,2) COMMENT 'Average gross margin percentage achieved across all SKUs (Stock Keeping Units) under this brand. Calculated as (Average Unit Retail - Cost of Goods Sold) / Average Unit Retail * 100. Critical for brand profitability analysis and private label vs. national brand comparison.',
    `brand_status` STRING COMMENT 'Current lifecycle status of the brand in the retail assortment. Active brands are available for new item setup and replenishment; inactive brands are temporarily suspended; discontinued brands are permanently removed; pending approval brands are under review for introduction.. Valid values are `active|inactive|discontinued|pending_approval`',
    `brand_type` STRING COMMENT 'Classification of brand ownership and distribution model. National brands are manufacturer-owned and widely distributed; private label are retailer-owned store brands; exclusive brands are sold only through specific retail partnerships; licensed brands use third-party intellectual property.. Valid values are `national|private_label|exclusive|licensed`',
    `brand_code` STRING COMMENT 'Unique alphanumeric code assigned to the brand for internal identification and system integration. Used in merchandising, procurement, and reporting systems.. Valid values are `^[A-Z0-9]{3,20}$`',
    `country_of_origin_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the primary country where products under this brand are manufactured or sourced. Required for customs compliance and consumer transparency.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this brand record was first created in the Master Data Management (MDM) system. Used for data lineage tracking and audit trail compliance.',
    `brand_description` STRING COMMENT 'Detailed narrative describing the brand positioning, value proposition, target customer segment, and key differentiators. Used for internal merchandising guidance and external marketing content.',
    `discontinuation_date` DATE COMMENT 'Date when the brand was permanently removed from the retail assortment. Null for active brands. Used for historical analysis and Return to Vendor (RTV) processing.',
    `is_exclusive` BOOLEAN COMMENT 'Boolean flag indicating whether this brand is sold exclusively through this retailer or a limited retail partnership. True for exclusive brands, false for widely distributed brands. Supports competitive differentiation strategy.',
    `is_licensed` BOOLEAN COMMENT 'Boolean flag indicating whether this brand operates under a licensing agreement using third-party intellectual property (e.g., character brands, celebrity brands, sports team brands). True for licensed brands, false otherwise. Impacts royalty payments and contract management.',
    `is_private_label` BOOLEAN COMMENT 'Boolean flag indicating whether this brand is a retailer-owned private label (store brand) product. True for private label brands, false for national or licensed brands. Critical for margin analysis and private label penetration reporting.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this brand record was most recently updated in the Master Data Management (MDM) system. Used for change tracking and data synchronization across systems.',
    `launch_date` DATE COMMENT 'Date when the brand was first introduced into the retail assortment. Used for new brand performance tracking, vendor scorecard evaluation, and assortment lifecycle analytics.',
    `lead_time_days` STRING COMMENT 'Average number of days from purchase order placement to product delivery at the Distribution Center (DC) for this brand. Used for demand planning, safety stock calculation, and Weeks of Supply (WOS) analysis.',
    `license_expiration_date` DATE COMMENT 'Date when the licensing agreement for this brand expires. Null for non-licensed brands. Used for contract renewal planning and inventory liquidation strategy for expiring licenses.',
    `logo_asset_url` STRING COMMENT 'Reference URL or path to the digital brand logo asset stored in the Product Information Management (PIM) or Digital Asset Management (DAM) system. Used for e-commerce product pages, marketing materials, and mobile app display.',
    `minimum_order_quantity` STRING COMMENT 'Minimum order quantity required by the supplier for purchase orders of products under this brand. Used for Open to Buy (OTB) planning and inventory replenishment optimization.',
    `modified_by_user` STRING COMMENT 'User identifier or name of the person who last modified this brand record. Used for audit trail and data governance accountability.',
    `brand_name` STRING COMMENT 'Official registered name of the brand as it appears on product packaging and marketing materials. Consumer-facing brand identifier.',
    `owner_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the country where the brand owner is headquartered. Used for country-of-origin reporting and supplier diversity analytics.. Valid values are `^[A-Z]{3}$`',
    `owner_name` STRING COMMENT 'Legal name of the company or entity that owns the intellectual property rights to the brand. May be the retailer (for private label) or a manufacturer/supplier (for national brands).',
    `portfolio_group` STRING COMMENT 'Higher-level grouping of related brands under a common portfolio or brand family. Enables portfolio-level margin analysis, vendor negotiations, and strategic assortment planning across brand families.',
    `quality_rating` DECIMAL(18,2) COMMENT 'Internal quality assessment score for the brand based on product defect rates, customer returns, and quality audits. Scale of 0.00 to 5.00. Used for vendor scorecard evaluation and assortment quality management.',
    `return_rate_percent` DECIMAL(18,2) COMMENT 'Percentage of units sold under this brand that are returned by customers. Calculated as (units returned / units sold) * 100. High return rates may indicate quality issues or misaligned customer expectations.',
    `sustainability_certification` STRING COMMENT 'Environmental or social responsibility certifications held by the brand (e.g., Fair Trade, Organic, B Corp, Carbon Neutral). Supports ESG reporting and consumer filtering on e-commerce platforms for sustainable products.',
    `target_customer_segment` STRING COMMENT 'Primary demographic or psychographic customer segment that this brand is designed to appeal to (e.g., millennials, families, health-conscious, budget shoppers). Supports personalized marketing and assortment localization.',
    `tier` STRING COMMENT 'Market positioning tier indicating price point and quality perception. Premium brands command higher margins and target affluent consumers; value and economy brands focus on price-sensitive segments. Drives assortment strategy and shelf placement.. Valid values are `premium|standard|value|economy`',
    `website_url` STRING COMMENT 'Official website URL for the brand, providing additional product information, brand story, and consumer engagement content. Used for e-commerce product page enrichment and customer education.',
    CONSTRAINT pk_brand PRIMARY KEY(`brand_id`)
) COMMENT 'Master record for all brands carried in the retail assortment, covering national brands, private label (store brand), exclusive, and licensed products. Captures brand name, brand owner, brand type (national, private label, exclusive, licensed), brand tier (premium, value, standard), country of origin, brand logo asset reference, brand status, launch date, and brand portfolio grouping. Supports private label vs. national brand assortment strategy, vendor brand negotiations, brand-level margin analysis, and consumer-facing brand filtering on e-commerce platforms.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`item_variant` (
    `item_variant_id` BIGINT COMMENT 'Unique identifier for the item variant relationship record. Primary key.',
    `sku_id` BIGINT COMMENT 'Reference to the parent or source SKU in the variant or substitution relationship. For variant relationships, this is the parent style or base item. For substitution relationships, this is the original SKU being substituted.',
    `target_item_sku_id` BIGINT COMMENT 'Reference to the child or target SKU in the variant or substitution relationship. For variant relationships, this is the child SKU (specific size, color, flavor). For substitution relationships, this is the replacement SKU.',
    `approval_timestamp` TIMESTAMP COMMENT 'The date and time when this variant or substitution relationship was approved for activation. Used to track the approval workflow and ensure proper governance of product relationships.',
    `auto_substitute_flag` BOOLEAN COMMENT 'Indicates whether this substitution can be applied automatically by fulfillment systems without manual intervention. True enables automatic substitution during picking when the source item is out of stock. False requires manual approval or customer consent.',
    `channel_applicability` STRING COMMENT 'Sales and fulfillment channels where this variant or substitution relationship is valid. All indicates the relationship applies across all channels. Specific values restrict the relationship to designated channels. Critical for omnichannel fulfillment and BOPIS (Buy Online Pick Up In Store) and ROPIS (Reserve Online Pick Up In Store) scenarios. [ENUM-REF-CANDIDATE: all|in_store|online|bopis|ropis|mobile_app|call_center — 7 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this variant relationship record was first created in the system. Used for audit trails and data lineage tracking.',
    `customer_consent_required_flag` BOOLEAN COMMENT 'Indicates whether explicit customer consent is required before applying this substitution. True means the customer must approve the substitution (e.g., for price upgrades or significant product differences). False means the substitution can be applied automatically (e.g., for equivalent items). Applicable primarily for substitution relationships.',
    `display_sequence` STRING COMMENT 'Numeric order for displaying variants in e-commerce product pages, mobile apps, and digital catalogs. Lower numbers appear first. Used to control the presentation order of size-color grids and variant selectors.',
    `effective_end_date` DATE COMMENT 'The date when this variant or substitution relationship expires and is no longer valid. Null indicates an open-ended relationship. Used to manage product lifecycle transitions and discontinuations.',
    `effective_start_date` DATE COMMENT 'The date when this variant or substitution relationship becomes active and can be used by merchandising, e-commerce, and fulfillment systems. Supports time-bound relationships for seasonal assortments or promotional periods.',
    `inventory_interchangeable_flag` BOOLEAN COMMENT 'Indicates whether the source and target items can be treated as interchangeable for inventory allocation and fulfillment purposes. True means inventory of either item can fulfill demand for the other. False means they must be tracked separately. Relevant for substitution relationships.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this variant relationship record was most recently updated. Used for change tracking and data synchronization across systems.',
    `notes` STRING COMMENT 'Free-text field for additional context, business rules, or special handling instructions related to this variant or substitution relationship. Used by merchandising and fulfillment teams for operational guidance.',
    `price_differential_amount` DECIMAL(18,2) COMMENT 'The price difference between the source and target items. Positive values indicate the target is more expensive (upgrade). Negative values indicate the target is less expensive (downgrade). Zero or null indicates equivalent pricing. Used for substitution cost impact analysis.',
    `relationship_status` STRING COMMENT 'Current lifecycle status of the variant or substitution relationship. Active means the relationship is in use. Inactive means temporarily disabled. Pending means awaiting approval or activation. Discontinued means permanently retired.. Valid values are `active|inactive|pending|discontinued`',
    `relationship_type` STRING COMMENT 'Type of relationship between source and target items. Variant indicates parent-child SKU relationship (e.g., style to size-color). Substitution indicates approved replacement for out-of-stock scenarios. Cross-sell and upsell support merchandising. Bundle and accessory support product associations.. Valid values are `variant|substitution|cross_sell|upsell|bundle|accessory`',
    `source_system_code` STRING COMMENT 'Identifier of the operational system that created or manages this variant relationship record. Examples: PIM for Product Information Management, MDM for Master Data Management, OMS for Order Management System. Used for data lineage and troubleshooting.',
    `substitution_priority_rank` STRING COMMENT 'Numeric rank indicating the priority order for substitution when multiple substitutes are available. Lower numbers indicate higher priority. Used by fulfillment systems to select the best substitute when the source item is out of stock.',
    `substitution_type` STRING COMMENT 'Classification of the substitution relationship. Equivalent indicates same quality and price point. Upgrade indicates higher quality or price. Downgrade indicates lower quality or price. Alternative indicates different but acceptable replacement. Applicable only when relationship_type is substitution.. Valid values are `equivalent|upgrade|downgrade|alternative`',
    `variant_dimension_type` STRING COMMENT 'The dimension along which the variant differs from the parent item. Applicable only when relationship_type is variant. Examples: size for apparel, flavor for beverages, scent for personal care, pack configuration for multi-packs. [ENUM-REF-CANDIDATE: size|color|flavor|scent|pack_configuration|material|style|fit|length|width — 10 candidates stripped; promote to reference product]',
    `variant_dimension_value` DECIMAL(18,2) COMMENT 'The specific value of the variant dimension for the target item. Examples: Small, Medium, Large for size; Red, Blue, Green for color; Vanilla, Chocolate for flavor; 6-pack, 12-pack for pack configuration.',
    `variant_ean` STRING COMMENT 'The 13-digit EAN barcode assigned to the target variant item. Used internationally for product identification and scanning. Common in European and global retail operations.. Valid values are `^[0-9]{13}$`',
    `variant_group_code` STRING COMMENT 'A code that groups related variants together under a common parent style or product family. Used to aggregate sales, inventory, and performance metrics across all variants of a base item. Supports category management and assortment planning.',
    `variant_gtin` STRING COMMENT 'The Global Trade Item Number assigned to the target variant item. GTIN is the umbrella term for UPC, EAN, and other GS1 product identifiers. Used for global supply chain and EDI transactions.. Valid values are `^[0-9]{8,14}$`',
    `variant_upc` STRING COMMENT 'The 12-digit UPC barcode assigned to the target variant item. Used for point-of-sale scanning and inventory tracking. Each variant SKU typically has its own unique UPC.. Valid values are `^[0-9]{12}$`',
    CONSTRAINT pk_item_variant PRIMARY KEY(`item_variant_id`)
) COMMENT 'Captures all SKU-to-SKU relationships including variant relationships (parent style/base item to child SKUs across size, color, flavor, scent, pack configuration) and approved substitution relationships (equivalent, upgrade, downgrade, cross-sell for fulfillment and out-of-stock scenarios). This is the SSOT for all inter-SKU relationships within the product domain. Stores source SKU reference, target SKU reference, relationship type (variant, substitution), dimension type (size, color, flavor, etc.), dimension value, substitution priority rank, channel applicability (in-store, online, BOPIS), customer consent required flag, variant-level UPC, and effective dates. Critical for apparel size-color grids, grocery flavor/size variants, omnichannel fulfillment substitution, BOPIS/ROPIS picking, and reducing lost sales from stockouts. Enables parent-child item navigation in PIM and e-commerce.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`compliance` (
    `compliance_id` BIGINT COMMENT 'Unique identifier for the product compliance record. Primary key.',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: Specific carrier service levels have distinct compliance capabilities (e.g., ground hazmat vs air hazmat, refrigerated vs ambient). Retail compliance teams pre-approve specific carrier services for re',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier. Business justification: Retail operations require matching product compliance requirements (hazmat certification, temperature control, age-restricted handling) to carrier capabilities. Hazmat-certified products can only ship',
    `recall_id` BIGINT COMMENT 'Foreign key linking to product.recall. Business justification: product_compliance contains four denormalized recall-specific columns: recall_date, recall_reason, recall_severity_level, and recall_status. These fields duplicate data that belongs in the authoritati',
    `sku_id` BIGINT COMMENT 'Reference to the product (SKU) that this compliance record applies to.',
    `age_restriction_required` BOOLEAN COMMENT 'Indicates whether the product requires age verification at point of sale due to regulatory restrictions (e.g., alcohol, tobacco, certain chemicals).',
    `allergen_declaration_compliant` BOOLEAN COMMENT 'Indicates whether the product labeling complies with allergen disclosure requirements (e.g., contains milk, eggs, peanuts, tree nuts, fish, shellfish, soy, wheat).',
    `certification_number` STRING COMMENT 'Unique certification or approval number issued by the certifying body for this compliance record.',
    `certifying_body` STRING COMMENT 'Name of the regulatory authority or third-party organization that issued the compliance certification (e.g., FDA, CPSC, UL, NSF, USDA).',
    `compliance_status` STRING COMMENT 'Current compliance status of the product for this regulatory requirement.. Valid values are `compliant|non_compliant|pending_review|expired|suspended|recalled`',
    `compliance_type` STRING COMMENT 'Category of regulatory compliance requirement (e.g., food safety, product safety, hazardous material classification, age restriction, import/export, labeling, environmental). [ENUM-REF-CANDIDATE: food_safety|product_safety|hazmat|age_restriction|import_export|labeling|environmental — 7 candidates stripped; promote to reference product]',
    `country_code` STRING COMMENT 'Three-letter ISO country code indicating the jurisdiction or market where this compliance requirement applies (e.g., USA, CAN, GBR, DEU).. Valid values are `^[A-Z]{3}$`',
    `country_of_origin_compliant` BOOLEAN COMMENT 'Indicates whether the product labeling meets country-of-origin marking requirements for customs and consumer disclosure.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the compliance record was first created in the system.',
    `effective_date` DATE COMMENT 'Date when the compliance certification becomes effective and the product is authorized for sale or distribution.',
    `expiry_date` DATE COMMENT 'Date when the compliance certification expires and requires renewal or re-certification. Null if certification does not expire.',
    `fda_food_facility_registration` STRING COMMENT 'FDA registration number for the manufacturing facility where food products are produced. Required for food safety compliance. Null for non-food items.',
    `hazmat_classification` STRING COMMENT 'Classification code for hazardous materials according to transportation and storage regulations (e.g., UN number, DOT hazard class). Null if product is not hazardous.',
    `import_license_number` STRING COMMENT 'Government-issued import license or permit number required for cross-border trade of regulated products. Null if not applicable.',
    `last_audit_date` DATE COMMENT 'Date of the most recent compliance audit or inspection conducted by the certifying body or internal quality assurance team.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the compliance record was last updated or modified.',
    `minimum_age_years` STRING COMMENT 'Minimum age in years required to purchase this product. Null if no age restriction applies.',
    `modified_by_user` STRING COMMENT 'Username or identifier of the user who last modified the compliance record. Used for audit trail and accountability.',
    `next_audit_date` DATE COMMENT 'Scheduled date for the next compliance audit or inspection. Used for proactive compliance management.',
    `notes` STRING COMMENT 'Free-text field for additional compliance information, special handling instructions, or notes from compliance audits.',
    `nutrition_labeling_compliant` BOOLEAN COMMENT 'Indicates whether the product meets FDA nutrition labeling requirements (Nutrition Facts panel). Applicable to food and beverage products.',
    `organic_certification` STRING COMMENT 'Organic certification number or designation (e.g., USDA Organic, EU Organic). Null if product is not certified organic.',
    `prop_65_chemical_list` STRING COMMENT 'Comma-separated list of Prop 65 chemicals present in the product that trigger warning requirements. Null if no Prop 65 warning required.',
    `prop_65_warning_required` BOOLEAN COMMENT 'Indicates whether the product requires a California Prop 65 warning label due to presence of chemicals known to cause cancer, birth defects, or reproductive harm.',
    `region_code` STRING COMMENT 'Sub-national region or state code where specific compliance requirements apply (e.g., CA for California Prop 65, NY for New York regulations).',
    `responsible_party_contact` STRING COMMENT 'Contact information (phone or email) for the responsible party. Used for regulatory inquiries and recall coordination.',
    `sustainability_certification` STRING COMMENT 'Sustainability or environmental certification (e.g., Fair Trade, Rainforest Alliance, Marine Stewardship Council, Forest Stewardship Council). Null if not certified.',
    `tariff_classification_code` STRING COMMENT 'Harmonized Tariff Schedule (HTS) code used for customs classification and duty calculation for imported products.',
    `test_report_number` STRING COMMENT 'Unique identifier for the compliance test report issued by the testing laboratory. Null if no test report available.',
    `testing_laboratory` STRING COMMENT 'Name of the accredited third-party laboratory that conducted compliance testing (e.g., UL, Intertek, SGS, Bureau Veritas). Null if no third-party testing performed.',
    CONSTRAINT pk_compliance PRIMARY KEY(`compliance_id`)
) COMMENT 'Tracks regulatory and safety compliance attributes for each SKU including FDA food labeling compliance, CPSC safety certifications, FTC advertising standards, hazardous material classification, age restriction requirements, country-specific import compliance, and recall status. Captures compliance type, certifying body, certification number, effective date, expiry date, compliance status, and last audit date. Supports regulatory reporting and product recall management.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`recall` (
    `recall_id` BIGINT COMMENT 'Unique identifier for the product recall event. Primary key for the product recall record.',
    `brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: recall has a manufacturer_name STRING column but no structured reference to the product_brand master. In retail, recalls are frequently brand-scoped (e.g., all units of a private label brand, or a nat',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Product recall management requires designated recall coordinators to manage regulatory notifications, customer communications, and recovery operations. Critical for FDA/CPSC compliance and liability m',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Product recalls frequently target entire categories or subcategories (e.g., all romaine lettuce, all toys from specific supplier). Recall management requires hierarchy-level scope definition for affec',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.store_location. Business justification: Product recalls must identify which stores received affected lots for customer notification, product removal from shelves, and recovery tracking. Recall execution systems require store-level tracking',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: product_recall.sku (STRING) should be normalized to a proper FK. Recalls are initiated for specific SKUs. The upc and gtin columns are redundant - they can be retrieved via sku → gtin_registry join.',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: recall tracks three unit-count fields: units_affected (BIGINT), units_in_customer_hands (BIGINT), and units_recovered (BIGINT). Without a UOM reference, these counts are ambiguous — are they individua',
    `affected_date_range_end` DATE COMMENT 'End date of the production or distribution period for affected products. Used to identify inventory within the recall scope.',
    `affected_date_range_start` DATE COMMENT 'Start date of the production or distribution period for affected products. Used to identify inventory within the recall scope.',
    `affected_lot_numbers` STRING COMMENT 'Comma-separated list of production lot numbers or batch codes affected by the recall. Used to identify specific inventory units.',
    `chargeback_amount` DECIMAL(18,2) COMMENT 'Total chargeback amount assessed to the supplier or vendor for recall-related costs, including recovery, disposal, and customer remedies.',
    `class` STRING COMMENT 'FDA recall classification indicating severity: Class I (serious health hazard or death), Class II (temporary health problem), Class III (unlikely to cause adverse health reaction).. Valid values are `class_i|class_ii|class_iii`',
    `completion_date` DATE COMMENT 'Date when the recall was officially closed or completed, indicating all recovery and remediation actions have been finalized.',
    `coordinator_email` STRING COMMENT 'Email address of the recall coordinator for internal and external communication regarding the recall event.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `coordinator_phone` STRING COMMENT 'Phone number of the recall coordinator for urgent communication and escalation regarding the recall event.. Valid values are `^+?[0-9]{10,15}$`',
    `corrective_action_plan` STRING COMMENT 'Description of corrective actions implemented to prevent recurrence of the issue, including process changes, supplier audits, or quality control enhancements.',
    `country_of_origin_code` STRING COMMENT 'Three-letter ISO country code indicating where the recalled product was manufactured or produced.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the product recall record was first created in the system. Used for audit trail and data lineage tracking.',
    `customer_notification_method` STRING COMMENT 'Comma-separated list of methods used to notify customers of the recall: email, direct mail, phone, in-store signage, website, social media, press release.',
    `estimated_financial_impact_amount` DECIMAL(18,2) COMMENT 'Estimated total financial impact of the recall in USD, including product costs, logistics, customer remedies, and regulatory penalties.',
    `hazard_description` STRING COMMENT 'Description of the specific hazard or risk posed by the recalled product to consumers, including potential injuries or health impacts.',
    `initiation_date` DATE COMMENT 'Date when the recall was officially initiated and communicated to internal teams and external stakeholders.',
    `is_private_label` BOOLEAN COMMENT 'Boolean flag indicating whether the recalled product is a private label (store brand) product. True if private label, False if national brand.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the product recall record was last updated or modified. Used for audit trail and change tracking.',
    `manufacturer_name` STRING COMMENT 'Name of the manufacturer or producer of the recalled product. May differ from the supplier if using third-party manufacturing.',
    `modified_by_user` STRING COMMENT 'Username or employee identifier of the user who last modified the product recall record. Used for audit trail and accountability.',
    `press_release_url` STRING COMMENT 'URL link to the official press release or public announcement document for the recall event, hosted on company or regulatory body website.. Valid values are `^https?://.*$`',
    `public_announcement_date` DATE COMMENT 'Date when the recall was publicly announced through press releases, website postings, or regulatory body publications.',
    `reason` STRING COMMENT 'Detailed description of the reason for the recall, including safety hazard, contamination, labeling error, or quality defect.',
    `recall_status` STRING COMMENT 'Current status of the recall event: open (initiated), in-progress (recovery underway), closed (completed), or terminated (discontinued).. Valid values are `open|in_progress|closed|terminated`',
    `recall_type` STRING COMMENT 'Classification of the recall action: mandatory (regulatory-mandated), voluntary (company-initiated), or market withdrawal (removal without regulatory involvement).. Valid values are `mandatory|voluntary|market_withdrawal`',
    `recovery_rate_percent` DECIMAL(18,2) COMMENT 'Percentage of affected units successfully recovered, calculated as (units_recovered / units_affected) * 100. Key performance indicator for recall effectiveness.',
    `reference_number` STRING COMMENT 'External recall reference number assigned by regulatory body or internal quality team. Used for tracking and reporting to CPSC, FDA, or other governing bodies.. Valid values are `^[A-Z0-9]{8,20}$`',
    `regulatory_body` STRING COMMENT 'Governing body that mandated or was notified of the recall: CPSC (Consumer Product Safety Commission), FDA (Food and Drug Administration), FTC (Federal Trade Commission), internal (company-initiated), or other.. Valid values are `cpsc|fda|ftc|internal|other`',
    `regulatory_case_number` STRING COMMENT 'Case or docket number assigned by the regulatory body (CPSC, FDA) for tracking and official correspondence related to the recall.. Valid values are `^[A-Z0-9-]{8,30}$`',
    `regulatory_notification_date` DATE COMMENT 'Date when the regulatory body (CPSC, FDA, etc.) was officially notified of the recall event. Required for compliance reporting.',
    `remedy_type` STRING COMMENT 'Type of remedy offered to customers for the recalled product: refund (money back), replacement (new product), repair (fix defect), or disposal (safe destruction).. Valid values are `refund|replacement|repair|disposal`',
    `root_cause_analysis` STRING COMMENT 'Summary of the root cause analysis findings identifying the underlying cause of the product defect or safety issue that triggered the recall.',
    `scope` STRING COMMENT 'Geographic scope of the recall: national (all locations), regional (specific regions or states), or store-specific (individual store locations).. Valid values are `national|regional|store_specific`',
    `units_affected` BIGINT COMMENT 'Total number of product units subject to the recall across all channels (stores, distribution centers, customer hands).',
    `units_in_customer_hands` BIGINT COMMENT 'Estimated number of recalled units that were sold to customers and remain outstanding (not yet returned or recovered).',
    `units_recovered` BIGINT COMMENT 'Number of recalled product units successfully recovered from stores, distribution centers, and customers through return or disposal.',
    CONSTRAINT pk_recall PRIMARY KEY(`recall_id`)
) COMMENT 'Operational record of product safety recalls and withdrawal events initiated by CPSC, FDA, or internal quality teams. Captures recall reference number, SKU reference, recall type (mandatory, voluntary, market withdrawal), recall reason, affected lot numbers, affected date range, recall scope (national, regional, store-specific), recall status (open, in-progress, closed), units affected, units recovered, and regulatory body notification date. Supports compliance reporting and reverse logistics coordination.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`uom` (
    `uom_id` BIGINT COMMENT 'Unique identifier for the unit of measure. Primary key for the UOM reference master.',
    `base_uom_id` BIGINT COMMENT 'Self-referencing FK on uom (base_uom_id)',
    `class` STRING COMMENT 'Classification of the unit of measure by measurement type: weight (mass), volume (capacity), count (discrete units), length (distance), area (surface), or time (duration).. Valid values are `weight|volume|count|length|area|time`',
    `uom_code` STRING COMMENT 'Short alphanumeric code representing the unit of measure (e.g., EA for each, CS for case, LB for pound, KG for kilogram). Used as the business identifier across ordering, inventory, pricing, and distribution systems.. Valid values are `^[A-Z0-9]{2,10}$`',
    `conversion_factor` DECIMAL(18,2) COMMENT 'Numeric multiplier to convert this unit of measure to the base unit. For example, if 1 case = 12 each, the conversion factor is 12. A value of 1 indicates this is the base unit.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this unit of measure record was first created in the master data system. Part of audit trail for data governance and compliance.',
    `data_quality_score` DECIMAL(18,2) COMMENT 'Numeric score (0-100) representing the completeness, accuracy, and consistency of this unit of measure record based on Master Data Management (MDM) data quality rules and validation checks.',
    `uom_description` STRING COMMENT 'Detailed description of the unit of measure, including usage context and business rules for application across retail operations.',
    `effective_end_date` DATE COMMENT 'Date after which this unit of measure is no longer valid for new transactions. Null indicates no planned end date. Part of temporal validity tracking.',
    `effective_start_date` DATE COMMENT 'Date from which this unit of measure becomes valid and available for use across retail systems. Part of temporal validity tracking.',
    `gs1_uom_code` STRING COMMENT 'Standardized GS1 unit of measure code used for Electronic Data Interchange (EDI) and global supply chain interoperability. Maps internal UOM codes to GS1 standards.',
    `inverse_conversion_factor` DECIMAL(18,2) COMMENT 'Reciprocal of the conversion factor, used for reverse conversions from base unit to this unit. Calculated as 1 divided by conversion_factor.',
    `is_base_unit` BOOLEAN COMMENT 'Boolean flag indicating whether this is the base unit of measure in its class (True) or a derived/alternate unit (False). Base units have a conversion factor of 1.',
    `is_consumer_unit` BOOLEAN COMMENT 'Boolean flag indicating whether this unit of measure represents a consumer-facing selling unit (True for each, single item, False for case, pallet, or bulk units).',
    `is_fractional_allowed` BOOLEAN COMMENT 'Boolean flag indicating whether fractional quantities are permitted for this unit of measure (True for weight/volume units like pounds or liters, False for discrete count units like cases or pallets).',
    `is_inventory_tracked` BOOLEAN COMMENT 'Boolean flag indicating whether inventory quantities are tracked and managed in this unit of measure (True if used in Warehouse Management System (WMS) and inventory systems, False if conversion-only).',
    `is_orderable` BOOLEAN COMMENT 'Boolean flag indicating whether this unit of measure can be used for purchase order creation and supplier ordering (True if valid for procurement, False if display-only or internal-use).',
    `is_variable_measure` BOOLEAN COMMENT 'Boolean flag indicating whether this unit of measure is used for variable-weight or variable-measure items (True for items sold by weight or volume with varying quantities, False for fixed-count items).',
    `iso_uom_code` STRING COMMENT 'International Organization for Standardization (ISO) unit code per ISO 80000 and ISO 31 standards, ensuring global consistency in measurement representation.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this unit of measure record was most recently updated. Part of audit trail for data governance and change tracking.',
    `lifecycle_status` STRING COMMENT 'Current lifecycle status of the unit of measure: active (in use), inactive (not currently used but retained for historical data), deprecated (being phased out), or pending (awaiting approval for use).. Valid values are `active|inactive|deprecated|pending`',
    `modified_by_user` STRING COMMENT 'User ID or name of the data steward or system user who last modified this unit of measure record. Part of audit trail for accountability and data governance.',
    `uom_name` STRING COMMENT 'Full descriptive name of the unit of measure (e.g., Each, Case, Pound, Kilogram, Liter, Ounce, Pallet).',
    `precision_decimal_places` STRING COMMENT 'Number of decimal places to which quantities in this unit of measure should be rounded for display and calculation purposes (e.g., 0 for whole units like cases, 2 for currency-like precision, 3 for weight measurements).',
    `sort_order` STRING COMMENT 'Numeric value controlling the display sequence of units of measure in user interfaces and reports. Lower values appear first.',
    `superseded_by_uom_code` STRING COMMENT 'Code of the replacement unit of measure that supersedes this one when deprecated. Used to maintain continuity during UOM transitions and system migrations.',
    `symbol` STRING COMMENT 'Standard abbreviated symbol for the unit of measure (e.g., kg for kilogram, lb for pound, L for liter, oz for ounce). Used in labels, reports, and user interfaces.',
    `unece_code` STRING COMMENT 'United Nations Economic Commission for Europe (UN/ECE) Recommendation 20 unit code, widely used in international trade and customs documentation.',
    `uom_type` STRING COMMENT 'Functional type indicating the primary business context where this UOM is used: base (fundamental unit), alternate (conversion unit), display (customer-facing), ordering (procurement), inventory (stock tracking), pricing (selling unit), or shipping (logistics). [ENUM-REF-CANDIDATE: base|alternate|display|ordering|inventory|pricing|shipping — 7 candidates stripped; promote to reference product]',
    `usage_context` STRING COMMENT 'Textual description of the business contexts and operational scenarios where this unit of measure is typically applied (e.g., used for bulk ordering of dry goods, used for pricing fresh produce, used for shipping pallet quantities).',
    CONSTRAINT pk_uom PRIMARY KEY(`uom_id`)
) COMMENT 'Unit of measure reference master defining all valid units (each, case, pallet, pound, kilogram, liter, ounce) and conversion factors used across ordering, inventory, pricing, and distribution. Captures UOM code, description, UOM class (weight, volume, count, length), base UOM conversion factor, and GS1 standard mapping.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ADD CONSTRAINT `fk_product_item_hierarchy_parent_hierarchy_node_item_hierarchy_id` FOREIGN KEY (`parent_hierarchy_node_item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ADD CONSTRAINT `fk_product_attribute_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ADD CONSTRAINT `fk_product_attribute_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ADD CONSTRAINT `fk_product_brand_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ADD CONSTRAINT `fk_product_item_variant_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ADD CONSTRAINT `fk_product_item_variant_target_item_sku_id` FOREIGN KEY (`target_item_sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ADD CONSTRAINT `fk_product_compliance_recall_id` FOREIGN KEY (`recall_id`) REFERENCES `vibe_retail_v1`.`product`.`recall`(`recall_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ADD CONSTRAINT `fk_product_compliance_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ADD CONSTRAINT `fk_product_recall_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ADD CONSTRAINT `fk_product_recall_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ADD CONSTRAINT `fk_product_recall_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ADD CONSTRAINT `fk_product_recall_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ADD CONSTRAINT `fk_product_uom_base_uom_id` FOREIGN KEY (`base_uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`product` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_retail_v1`.`product` SET TAGS ('dbx_domain' = 'product');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` SET TAGS ('dbx_subdomain' = 'catalog_management');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) ID');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `sku_description` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) Description');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `dimension_unit_of_measure` SET TAGS ('dbx_value_regex' = 'IN|CM|FT|M');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `ean` SET TAGS ('dbx_business_glossary_term' = 'European Article Number (EAN)');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `ean` SET TAGS ('dbx_value_regex' = '^[0-9]{13}$');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `gtin` SET TAGS ('dbx_business_glossary_term' = 'Global Trade Item Number (GTIN)');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `gtin` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$|^[0-9]{12}$|^[0-9]{13}$|^[0-9]{14}$');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `hazmat_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `hi` SET TAGS ('dbx_business_glossary_term' = 'Hi (High)');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'ACTIVE|DISCONTINUED|SEASONAL|CLEARANCE|PENDING_SETUP|INACTIVE');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `temperature_requirement` SET TAGS ('dbx_value_regex' = 'AMBIENT|REFRIGERATED|FROZEN|CONTROLLED');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `ti` SET TAGS ('dbx_business_glossary_term' = 'Ti (Tier)');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `upc` SET TAGS ('dbx_business_glossary_term' = 'Universal Product Code (UPC)');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `upc` SET TAGS ('dbx_value_regex' = '^[0-9]{12}$');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `volume_unit_of_measure` SET TAGS ('dbx_value_regex' = 'GAL|LTR|ML|OZ|QT');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `weight_unit_of_measure` SET TAGS ('dbx_value_regex' = 'LB|KG|OZ|G');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` SET TAGS ('dbx_subdomain' = 'catalog_management');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `parent_hierarchy_node_item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Hierarchy Node ID');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `allows_direct_sku_assignment` SET TAGS ('dbx_business_glossary_term' = 'Allows Direct SKU (Stock Keeping Unit) Assignment Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `external_reference_code` SET TAGS ('dbx_business_glossary_term' = 'External Reference ID');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_value_regex' = 'division|department|category|subcategory|segment|class');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `hierarchy_node_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,20}$');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `hierarchy_type` SET TAGS ('dbx_value_regex' = 'operational|strategic|financial|planning|reporting');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `is_leaf_node` SET TAGS ('dbx_business_glossary_term' = 'Is Leaf Node Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|deprecated|archived');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `markdown_cadence` SET TAGS ('dbx_value_regex' = 'weekly|biweekly|monthly|seasonal|event_driven|none');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `omnichannel_enabled` SET TAGS ('dbx_business_glossary_term' = 'Omnichannel Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `pricing_strategy` SET TAGS ('dbx_value_regex' = 'edlp|hi_lo|premium|competitive|value');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `replenishment_method` SET TAGS ('dbx_value_regex' = 'auto|manual|vendor_managed|cross_dock|drop_ship');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `strategic_classification` SET TAGS ('dbx_value_regex' = 'destination|routine|convenience|seasonal|private_label|national_brand');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` SET TAGS ('dbx_subdomain' = 'catalog_management');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `attribute_id` SET TAGS ('dbx_business_glossary_term' = 'Product Attribute Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Product Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `attribute_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_approval|deprecated|archived');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `conversion_factor` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM) Conversion Factor');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `data_type` SET TAGS ('dbx_value_regex' = 'string|numeric|boolean|date|timestamp|decimal');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `display_order` SET TAGS ('dbx_business_glossary_term' = 'Display Order Sequence');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `is_certified` SET TAGS ('dbx_business_glossary_term' = 'Is Certified Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `is_comparable` SET TAGS ('dbx_business_glossary_term' = 'Is Comparable Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `is_regulatory_required` SET TAGS ('dbx_business_glossary_term' = 'Is Regulatory Required Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `is_required` SET TAGS ('dbx_business_glossary_term' = 'Is Required Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `is_searchable` SET TAGS ('dbx_business_glossary_term' = 'Is Searchable Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `locale` SET TAGS ('dbx_business_glossary_term' = 'Locale Code');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `locale` SET TAGS ('dbx_value_regex' = '^[a-z]{2}_[A-Z]{2}$');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Attribute Notes');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `validation_rule` SET TAGS ('dbx_business_glossary_term' = 'Attribute Validation Rule');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` SET TAGS ('dbx_subdomain' = 'catalog_management');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `average_margin_percent` SET TAGS ('dbx_business_glossary_term' = 'Average Margin Percentage');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `average_margin_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `brand_status` SET TAGS ('dbx_value_regex' = 'active|inactive|discontinued|pending_approval');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `brand_type` SET TAGS ('dbx_value_regex' = 'national|private_label|exclusive|licensed');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `brand_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `country_of_origin_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `discontinuation_date` SET TAGS ('dbx_business_glossary_term' = 'Brand Discontinuation Date');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `is_exclusive` SET TAGS ('dbx_business_glossary_term' = 'Is Exclusive Brand Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `is_licensed` SET TAGS ('dbx_business_glossary_term' = 'Is Licensed Brand Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `is_private_label` SET TAGS ('dbx_business_glossary_term' = 'Is Private Label Brand Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `launch_date` SET TAGS ('dbx_business_glossary_term' = 'Brand Launch Date');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time in Days');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `logo_asset_url` SET TAGS ('dbx_business_glossary_term' = 'Brand Logo Asset Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `owner_country_code` SET TAGS ('dbx_business_glossary_term' = 'Brand Owner Country Code');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `owner_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `owner_name` SET TAGS ('dbx_business_glossary_term' = 'Brand Owner Name');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `portfolio_group` SET TAGS ('dbx_business_glossary_term' = 'Brand Portfolio Group');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `quality_rating` SET TAGS ('dbx_business_glossary_term' = 'Brand Quality Rating');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `return_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Return Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `tier` SET TAGS ('dbx_value_regex' = 'premium|standard|value|economy');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'Brand Website Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` SET TAGS ('dbx_subdomain' = 'catalog_management');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `item_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Item Variant Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Source Item Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `target_item_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Target Item Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Relationship Notes');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `relationship_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|discontinued');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `relationship_type` SET TAGS ('dbx_value_regex' = 'variant|substitution|cross_sell|upsell|bundle|accessory');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `substitution_type` SET TAGS ('dbx_value_regex' = 'equivalent|upgrade|downgrade|alternative');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `variant_ean` SET TAGS ('dbx_business_glossary_term' = 'Variant European Article Number (EAN)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `variant_ean` SET TAGS ('dbx_value_regex' = '^[0-9]{13}$');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `variant_gtin` SET TAGS ('dbx_business_glossary_term' = 'Variant Global Trade Item Number (GTIN)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `variant_gtin` SET TAGS ('dbx_value_regex' = '^[0-9]{8,14}$');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `variant_upc` SET TAGS ('dbx_business_glossary_term' = 'Variant Universal Product Code (UPC)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `variant_upc` SET TAGS ('dbx_value_regex' = '^[0-9]{12}$');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` SET TAGS ('dbx_subdomain' = 'regulatory_safety');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Carrier Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `recall_id` SET TAGS ('dbx_business_glossary_term' = 'Recall Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Product ID');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending_review|expired|suspended|recalled');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `fda_food_facility_registration` SET TAGS ('dbx_business_glossary_term' = 'Food and Drug Administration (FDA) Food Facility Registration');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `hazmat_classification` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Classification');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Compliance Notes');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `prop_65_chemical_list` SET TAGS ('dbx_business_glossary_term' = 'California Proposition 65 (Prop 65) Chemical List');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `prop_65_warning_required` SET TAGS ('dbx_business_glossary_term' = 'California Proposition 65 (Prop 65) Warning Required');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `responsible_party_contact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `responsible_party_contact` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` SET TAGS ('dbx_subdomain' = 'regulatory_safety');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `recall_id` SET TAGS ('dbx_business_glossary_term' = 'Product Recall ID');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Recall Coordinator Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `chargeback_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `class` SET TAGS ('dbx_value_regex' = 'class_i|class_ii|class_iii');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `completion_date` SET TAGS ('dbx_business_glossary_term' = 'Recall Completion Date');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `coordinator_email` SET TAGS ('dbx_business_glossary_term' = 'Recall Coordinator Email');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `coordinator_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `coordinator_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `coordinator_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `coordinator_phone` SET TAGS ('dbx_business_glossary_term' = 'Recall Coordinator Phone');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `coordinator_phone` SET TAGS ('dbx_value_regex' = '^+?[0-9]{10,15}$');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `coordinator_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `coordinator_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `country_of_origin_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `estimated_financial_impact_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `initiation_date` SET TAGS ('dbx_business_glossary_term' = 'Recall Initiation Date');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `press_release_url` SET TAGS ('dbx_value_regex' = '^https?://.*$');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `reason` SET TAGS ('dbx_business_glossary_term' = 'Recall Reason');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `recall_status` SET TAGS ('dbx_value_regex' = 'open|in_progress|closed|terminated');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `recall_type` SET TAGS ('dbx_value_regex' = 'mandatory|voluntary|market_withdrawal');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `reference_number` SET TAGS ('dbx_business_glossary_term' = 'Recall Reference Number');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_value_regex' = 'cpsc|fda|ftc|internal|other');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `regulatory_case_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{8,30}$');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `remedy_type` SET TAGS ('dbx_value_regex' = 'refund|replacement|repair|disposal');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `scope` SET TAGS ('dbx_value_regex' = 'national|regional|store_specific');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` SET TAGS ('dbx_subdomain' = 'catalog_management');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM) ID');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `base_uom_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `class` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM) Class');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `class` SET TAGS ('dbx_value_regex' = 'weight|volume|count|length|area|time');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `uom_code` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM) Code');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `uom_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `uom_description` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM) Description');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `gs1_uom_code` SET TAGS ('dbx_business_glossary_term' = 'GS1 Unit of Measure (UOM) Code');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `is_base_unit` SET TAGS ('dbx_business_glossary_term' = 'Is Base Unit Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `is_consumer_unit` SET TAGS ('dbx_business_glossary_term' = 'Is Consumer Unit Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `is_fractional_allowed` SET TAGS ('dbx_business_glossary_term' = 'Is Fractional Quantity Allowed Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `is_inventory_tracked` SET TAGS ('dbx_business_glossary_term' = 'Is Inventory Tracked Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `is_orderable` SET TAGS ('dbx_business_glossary_term' = 'Is Orderable Unit Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `is_variable_measure` SET TAGS ('dbx_business_glossary_term' = 'Is Variable Measure Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `iso_uom_code` SET TAGS ('dbx_business_glossary_term' = 'ISO Unit of Measure (UOM) Code');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated|pending');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `uom_name` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM) Name');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `superseded_by_uom_code` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Unit of Measure (UOM) Code');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `symbol` SET TAGS ('dbx_business_glossary_term' = 'Unit Symbol');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `unece_code` SET TAGS ('dbx_business_glossary_term' = 'UN/ECE Recommendation 20 Code');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `uom_type` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM) Type');
