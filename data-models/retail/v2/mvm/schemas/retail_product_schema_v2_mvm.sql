-- Schema for Domain: product | Business: Retail | Version: v2_mvm
-- Generated on: 2026-07-12 15:26:00

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`product` COMMENT 'Authoritative catalog of all merchandise including SKUs, UPCs, GTINs, EANs, product hierarchies (department, category, subcategory), attributes, descriptions, images, private label vs. national brands, and assortment depth and breadth classifications. Managed via PIM (Product Information Management) and MDM systems. Supports category management, new item setup, and product lifecycle from introduction to discontinuation.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`sku` (
    `sku_id` BIGINT COMMENT 'Unique identifier for the Stock Keeping Unit. Primary key for the SKU master record.',
    `brand_id` BIGINT COMMENT 'add column product_brand_id (BIGINT) with FK to product.product_brand.product_brand_id - SKUs belong to brands and this relationship is fundamental for brand-level reporting and assortment planning',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: sku has department_code, category_code, subcategory_code (all STRING) which should be normalized to a single FK to item_hierarchy. The hierarchy table is the authoritative source for merchandise taxon',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: sku.unit_of_measure (STRING) should be normalized to a proper FK to uom reference table. UOM is the authoritative master for all units of measure with conversion factors and standards compliance (GS1',
    `vendor_id` BIGINT COMMENT 'Identifier of the primary supplier or vendor who provides this SKU to the retailer. Links to the supplier master data.',
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
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: product_attribute.unit_of_measure is a STRING column storing a denormalized unit of measure reference. The uom table is the authoritative UOM master in this domain. Normalizing this to a FK attribute_',
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
    `vendor_id` BIGINT COMMENT 'Reference to the primary supplier or vendor who provides products under this brand. Links to the supplier master data for vendor negotiations, chargeback processing, and Vendor Managed Inventory (VMI) programs.',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`image` (
    `image_id` BIGINT COMMENT 'Unique identifier for the product image asset record.',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.associate. Business justification: Retail digital asset management requires tracking which associate uploaded/approved each product image for content workflow, quality control, audit trails, and accountability. Critical for e-commerce',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: product_image.sku (STRING) should be normalized to a proper FK. Images are assets associated with specific SKUs. This is a standard 1:N relationship (one SKU has many images).',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor. Business justification: Product images are often vendor-supplied assets. Retailers track image source vendor for copyright management, quality disputes, and vendor scorecard metrics on marketing asset delivery. vendor_image_',
    `approval_status` STRING COMMENT 'The current approval state of the image asset in the content workflow: draft (initial upload), pending_review (awaiting approval), approved (ready for publication), rejected (failed quality check), archived (no longer active).. Valid values are `draft|pending_review|approved|rejected|archived`',
    `approved_by` STRING COMMENT 'The username or identifier of the merchandising or marketing user who approved this image for publication.',
    `approved_timestamp` TIMESTAMP COMMENT 'The date and time when this image was approved for publication.',
    `aspect_ratio` STRING COMMENT 'The proportional relationship between width and height (e.g., 1:1, 4:3, 16:9). Used for responsive design and layout planning.',
    `background_color` STRING COMMENT 'The hexadecimal color code of the image background (e.g., #FFFFFF for white). Used for consistent product presentation and dynamic background replacement.. Valid values are `^#[0-9A-Fa-f]{6}$`',
    `caption` STRING COMMENT 'Optional marketing or descriptive caption displayed alongside the image in certain contexts (e.g., lifestyle images with usage tips).',
    `cdn_asset_reference` STRING COMMENT 'The unique identifier or key used by the Content Delivery Network to cache and serve this image asset globally.',
    `channel_applicability` STRING COMMENT 'Comma-separated list of channels where this image is approved for use (web, mobile, print, in-store, social, marketplace). Supports omnichannel merchandising.',
    `color_profile` STRING COMMENT 'The color space or profile used in the image (sRGB, Adobe RGB, ProPhoto RGB, CMYK). Critical for color accuracy across web, print, and in-store displays.. Valid values are `sRGB|Adobe_RGB|ProPhoto_RGB|CMYK`',
    `copyright_holder` STRING COMMENT 'The legal entity or individual who holds the copyright to this image asset. Critical for rights management and legal compliance.',
    `dpi` STRING COMMENT 'The resolution of the image in dots per inch. Typically 72 DPI for web and 300 DPI for print. Used to determine print quality suitability.',
    `expiration_date` DATE COMMENT 'The date when the license to use this image expires. Null for perpetual licenses. Used to manage rights and prevent unauthorized use.',
    `file_format` STRING COMMENT 'The digital file format of the image asset (JPEG, PNG, GIF, WEBP, SVG, TIFF).. Valid values are `JPEG|PNG|GIF|WEBP|SVG|TIFF`',
    `file_size_kb` DECIMAL(18,2) COMMENT 'The file size of the image asset in kilobytes. Used for performance optimization and bandwidth management.',
    `has_transparency` BOOLEAN COMMENT 'Boolean flag indicating whether the image contains transparent pixels (alpha channel). Relevant for PNG and GIF formats used in layered designs.',
    `image_type` STRING COMMENT 'Classification of the image purpose: hero (primary product shot), alternate (additional angles), swatch (color/material sample), lifestyle (in-use context), packaging (box/container), detail (close-up feature).. Valid values are `hero|alternate|swatch|lifestyle|packaging|detail`',
    `is_active` BOOLEAN COMMENT 'Boolean flag indicating whether this image is currently active and available for display. Inactive images are retained for historical reference but not shown to customers.',
    `is_primary` BOOLEAN COMMENT 'Boolean flag indicating whether this is the primary/hero image for the SKU. Only one image per SKU should be marked as primary.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this image record or the image file itself was last updated or modified.',
    `license_type` STRING COMMENT 'The licensing model under which the retailer has rights to use this image: owned (created in-house), licensed (paid third-party), royalty_free (unlimited use), creative_commons (open license), vendor_supplied (provided by supplier).. Valid values are `owned|licensed|royalty_free|creative_commons|vendor_supplied`',
    `locale` STRING COMMENT 'The language and region code (e.g., en_US, fr_FR, es_MX) indicating which market or locale this image is intended for. Supports localized product imagery.. Valid values are `^[a-z]{2}_[A-Z]{2}$`',
    `mobile_optimized` BOOLEAN COMMENT 'Boolean flag indicating whether this image has been optimized for mobile device display (compressed, resized, or formatted for mobile bandwidth and screen size).',
    `photographer_credit` STRING COMMENT 'Attribution to the photographer or content creator who produced the image. Used for rights management and licensing compliance.',
    `planogram_eligible` BOOLEAN COMMENT 'Boolean flag indicating whether this image is suitable for use in planogram design and shelf layout planning. Typically requires consistent background and perspective.',
    `print_ready` BOOLEAN COMMENT 'Boolean flag indicating whether this image meets the resolution and color profile requirements for print media (catalogs, circulars, in-store signage).',
    `quality_score` DECIMAL(18,2) COMMENT 'A computed or manually assigned quality score (0.00 to 5.00) representing the technical and aesthetic quality of the image. Used for quality control and merchandising decisions.',
    `resolution_height` STRING COMMENT 'The height of the image in pixels. Used to determine image quality and suitability for different channels (web, mobile, print).',
    `resolution_width` STRING COMMENT 'The width of the image in pixels. Used to determine image quality and suitability for different channels (web, mobile, print).',
    `seo_keywords` STRING COMMENT 'Comma-separated list of keywords associated with this image for search engine optimization and internal search relevance.',
    `sequence_number` STRING COMMENT 'The display order of this image within the products image gallery. Lower numbers appear first in the carousel or gallery view.',
    `upload_timestamp` TIMESTAMP COMMENT 'The date and time when this image was first uploaded to the digital asset management system.',
    `url` STRING COMMENT 'The full URL path to the digital image asset, typically hosted on a Content Delivery Network (CDN) or digital asset management system.. Valid values are `^https?://.*.(jpg|jpeg|png|gif|webp|svg)$`',
    `usage_rights_notes` STRING COMMENT 'Free-text field capturing any special terms, restrictions, or notes regarding the usage rights of this image (e.g., geographic restrictions, channel limitations, attribution requirements).',
    `vendor_image_code` STRING COMMENT 'The unique identifier assigned to this image by the vendor or supplier who provided it. Used for cross-reference and vendor collaboration.',
    `view_angle` STRING COMMENT 'The perspective or angle from which the product is photographed (front, back, left, right, top, bottom, angle). Helps customers understand product dimensions and features. [ENUM-REF-CANDIDATE: front|back|left|right|top|bottom|angle — 7 candidates stripped; promote to reference product]',
    `zoom_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether this image supports zoom functionality on the e-commerce platform. High-resolution images typically enable zoom for detailed product inspection.',
    CONSTRAINT pk_image PRIMARY KEY(`image_id`)
) COMMENT 'Manages digital image assets associated with each SKU including primary product images, alternate angles, lifestyle images, and swatch images. Captures image URL, image type (hero, alternate, swatch, lifestyle, packaging), resolution, file format, locale, channel applicability (web, mobile, print, in-store), CDN asset reference, and approval status. Sourced from the e-commerce platform and PIM digital asset management. Supports e-commerce product display and planogram design.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`compliance` (
    `compliance_id` BIGINT COMMENT 'Unique identifier for the product compliance record. Primary key.',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: Specific carrier service levels have distinct compliance capabilities (e.g., ground hazmat vs air hazmat, refrigerated vs ambient). Retail compliance teams pre-approve specific carrier services for re',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier. Business justification: Retail operations require matching product compliance requirements (hazmat certification, temperature control, age-restricted handling) to carrier capabilities. Hazmat-certified products can only ship',
    `sku_id` BIGINT COMMENT 'Reference to the product (SKU) that this compliance record applies to.',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor. Business justification: Regulatory traceability requires tracking which vendor supplied products for compliance records. Critical for recall management, country-of-origin verification, and audit trails. Retail compliance tea',
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
    `recall_date` DATE COMMENT 'Date when the product recall was initiated. Null if no recall has been issued.',
    `recall_reason` STRING COMMENT 'Detailed explanation of the reason for the product recall (e.g., contamination, safety hazard, labeling error). Null if no recall.',
    `recall_severity_level` STRING COMMENT 'FDA classification of recall severity: Class 1 (serious health hazard or death), Class 2 (temporary health problem), Class 3 (unlikely to cause adverse health effects). Null if no recall.. Valid values are `class_1|class_2|class_3`',
    `recall_status` STRING COMMENT 'Current recall status of the product indicating whether it is subject to a safety or quality recall.. Valid values are `no_recall|active_recall|recall_completed|recall_pending`',
    `region_code` STRING COMMENT 'Sub-national region or state code where specific compliance requirements apply (e.g., CA for California Prop 65, NY for New York regulations).',
    `responsible_party_contact` STRING COMMENT 'Contact information (phone or email) for the responsible party. Used for regulatory inquiries and recall coordination.',
    `sustainability_certification` STRING COMMENT 'Sustainability or environmental certification (e.g., Fair Trade, Rainforest Alliance, Marine Stewardship Council, Forest Stewardship Council). Null if not certified.',
    `tariff_classification_code` STRING COMMENT 'Harmonized Tariff Schedule (HTS) code used for customs classification and duty calculation for imported products.',
    `test_report_number` STRING COMMENT 'Unique identifier for the compliance test report issued by the testing laboratory. Null if no test report available.',
    `testing_laboratory` STRING COMMENT 'Name of the accredited third-party laboratory that conducted compliance testing (e.g., UL, Intertek, SGS, Bureau Veritas). Null if no third-party testing performed.',
    CONSTRAINT pk_compliance PRIMARY KEY(`compliance_id`)
) COMMENT 'Tracks regulatory and safety compliance attributes for each SKU including FDA food labeling compliance, CPSC safety certifications, FTC advertising standards, hazardous material classification, age restriction requirements, country-specific import compliance, and recall status. Captures compliance type, certifying body, certification number, effective date, expiry date, compliance status, and last audit date. Supports regulatory reporting and product recall management.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`item_bundle` (
    `item_bundle_id` BIGINT COMMENT 'Unique identifier for the item bundle configuration. Primary key.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: item_bundle.bundle_sku (STRING) should be normalized to a proper FK. The bundle itself is a SKU in the catalog. This links the bundle definition to its SKU master record. bundle_gtin can be retrieved',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: item_bundle.component_quantity (DECIMAL) represents the quantity of a component SKU within a bundle, but without a unit of measure reference this quantity is ambiguous (is it 2 each? 2 kg? 2 liters?).',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Merchandising associates create promotional bundles and multi-packs. Tracking creator enables workflow management, approval routing, performance measurement, and audit trails for promotional planning',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.store_location. Business justification: Promotional bundles are often authorized only for specific stores or store clusters (e.g., seasonal bundles in tourist locations, regional promotions). Bundle authorization by store is required for pr',
    `vendor_id` BIGINT COMMENT 'Reference to the primary vendor or supplier responsible for providing the bundle or its components. Used for vendor managed inventory and procurement.',
    `assortment_category` STRING COMMENT 'The merchandising category or department this bundle belongs to for assortment planning and category management (e.g., Grocery, Apparel, Electronics).',
    `bundle_description` STRING COMMENT 'Detailed description of the bundle contents and value proposition for merchandising and marketing purposes.',
    `bundle_name` STRING COMMENT 'The customer-facing name of the bundle (e.g., Summer BBQ Pack, Family Meal Deal, Holiday Gift Set).',
    `bundle_price_amount` DECIMAL(18,2) COMMENT 'The selling price of the bundle when pricing_method is bundle_price. Represents the total customer-facing price.',
    `bundle_status` STRING COMMENT 'Current lifecycle status of the bundle: active (available for sale), inactive (temporarily unavailable), pending (awaiting approval), discontinued (permanently removed), seasonal (available during specific periods).. Valid values are `active|inactive|pending|discontinued|seasonal`',
    `bundle_type` STRING COMMENT 'Classification of the bundle configuration: fixed_bundle (pre-defined components), mix_and_match (customer selects from options), gift_set (curated gift collection), kit (assembly required), variety_pack (multiple flavors/variants), multi_pack (quantity of same item).. Valid values are `fixed_bundle|mix_and_match|gift_set|kit|variety_pack|multi_pack`',
    `channel_availability` STRING COMMENT 'Defines which sales channels can sell this bundle: all_channels, store_only, online_only, bopis_eligible (Buy Online Pick Up In Store), ship_from_store (fulfillment from store inventory).. Valid values are `all_channels|store_only|online_only|bopis_eligible|ship_from_store`',
    `component_quantity` DECIMAL(18,2) COMMENT 'The quantity of the component SKU included in one unit of the bundle. Supports fractional quantities for weight-based items.',
    `component_sequence` STRING COMMENT 'The display order or assembly sequence of this component within the bundle. Used for kit assembly instructions and merchandising display.',
    `component_sku` STRING COMMENT 'The SKU of an individual component item included in this bundle. References the product master catalog.. Valid values are `^[A-Z0-9]{8,14}$`',
    `component_substitution_allowed` BOOLEAN COMMENT 'Indicates whether this component can be substituted with an equivalent item during fulfillment (e.g., out-of-stock scenarios, mix-and-match bundles).',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this bundle configuration record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for bundle pricing (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'The fixed dollar discount applied to the component sum when pricing_method is discount_amount.',
    `discount_percentage` DECIMAL(18,2) COMMENT 'The percentage discount applied to the component sum when pricing_method is discount_percentage (e.g., 15.00 for 15% off).',
    `effective_end_date` DATE COMMENT 'The date when this bundle configuration expires or is discontinued. Null indicates no planned end date.',
    `effective_start_date` DATE COMMENT 'The date when this bundle configuration becomes active and available for sale across all channels.',
    `inventory_deduction_method` STRING COMMENT 'Defines how inventory is tracked and decremented: component_level (deduct each component SKU), bundle_level (track bundle as single inventory unit), hybrid (track both bundle and components).. Valid values are `component_level|bundle_level|hybrid`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this bundle configuration record was last updated.',
    `loyalty_points_eligible` BOOLEAN COMMENT 'Indicates whether customers can earn loyalty program points on bundle purchases.',
    `maximum_purchase_quantity` STRING COMMENT 'The maximum number of bundle units a customer can purchase in a single transaction. Used to prevent stockouts and ensure fair distribution of limited-time offers.',
    `minimum_purchase_quantity` STRING COMMENT 'The minimum number of bundle units a customer must purchase in a single transaction. Typically 1, but may be higher for wholesale or bulk bundles.',
    `modified_by_user` STRING COMMENT 'The user ID or username of the person who last modified this bundle configuration. Used for audit trail and change management.',
    `pricing_method` STRING COMMENT 'Defines how the bundle price is calculated: bundle_price (fixed price for entire bundle), component_sum (sum of individual component prices), discount_percentage (percentage off component sum), discount_amount (fixed dollar discount off component sum).. Valid values are `bundle_price|component_sum|discount_percentage|discount_amount`',
    `promotion_eligible` BOOLEAN COMMENT 'Indicates whether this bundle can be included in additional promotional offers or discounts beyond its configured bundle pricing.',
    `return_policy_code` STRING COMMENT 'Reference code to the specific return policy applicable to this bundle (e.g., standard 30-day, final sale, exchange only).. Valid values are `^[A-Z0-9]{2,10}$`',
    `returnable` BOOLEAN COMMENT 'Indicates whether the bundle can be returned. Some bundles (e.g., opened gift sets, perishable meal kits) may not be returnable.',
    CONSTRAINT pk_item_bundle PRIMARY KEY(`item_bundle_id`)
) COMMENT 'Defines product bundle and kit configurations where multiple component SKUs are sold together as a single sellable unit. Captures bundle SKU reference (the parent sellable unit), component SKU references, component quantity, component sequence, bundle type (fixed bundle, mix-and-match, gift set, kit, variety pack, multi-pack), pricing method (bundle price, component sum, discount percentage), component substitution allowed flag, and effective dates. Supports promotional bundling, gift set creation, variety packs, multi-pack configurations, and meal deal combos across all channels. Critical for POS scanning (bundle has its own GTIN), inventory component deduction, and promotional planning.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`gtin_registry` (
    `gtin_registry_id` BIGINT COMMENT 'Unique identifier for the GTIN registry record. Primary key for the GTIN registry product.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: gtin_registry.sku_code (STRING) should be normalized to a proper FK. GTINs are registered for specific SKUs - this is the authoritative link between global trade item numbers and internal SKU master.',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: gtin_registry.net_content_unit is a STRING column storing a denormalized unit of measure for net content (e.g., oz, ml, g). The uom table contains gs1_uom_code which directly maps to GS1 standar',
    `barcode_image_url` STRING COMMENT 'URL reference to the digital barcode image asset (PNG, SVG, or EPS format). Used for printing labels, packaging artwork, and digital commerce applications. Points to asset management system or CDN location.',
    `barcode_symbology` STRING COMMENT 'The barcode encoding standard used to represent this GTIN. EAN (European Article Number bars), UPC (Universal Product Code bars), ITF-14 (Interleaved 2 of 5 for cases), GS1-128 (application identifier barcodes), QR (2D matrix code). Determines scanner compatibility.. Valid values are `EAN|UPC|ITF-14|GS1-128|QR`',
    `check_digit` STRING COMMENT 'The final digit of the GTIN calculated using GS1 check digit algorithm (modulo 10). Used to validate GTIN integrity during scanning and data entry. Automatically calculated but stored for validation purposes.. Valid values are `^[0-9]{1}$`',
    `child_gtin_quantity` STRING COMMENT 'Number of child GTINs (next lower packaging level) contained within this GTIN. For example, a case GTIN with child_gtin_quantity=24 contains 24 unit GTINs. Null for unit-level GTINs. Used to calculate inventory at different packaging levels.',
    `country_of_sale` STRING COMMENT 'ISO 3166-1 alpha-3 country code where this GTIN is authorized for sale. A single SKU may have different GTINs for different countries due to regulatory labeling requirements. For example, USA, CAN, MEX, GBR, DEU, FRA.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this GTIN registry record was first created in the system. Used for audit trail and data lineage tracking. Immutable after initial creation.',
    `discontinuation_date` DATE COMMENT 'Date when this GTIN is retired and should no longer be used in new transactions. Null for active GTINs. Used for product lifecycle management and to prevent ordering of discontinued items. Historical transactions retain the GTIN for audit purposes.',
    `effective_date` DATE COMMENT 'Date when this GTIN becomes active and can be used in transactions. For new product launches, this is the go-live date. For packaging changes, this is when the new GTIN replaces the old one. Critical for supply chain cutover planning.',
    `gdsn_last_sync_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent successful synchronization of this GTIN data to the GDSN data pool. Used to track data freshness and identify GTINs requiring re-publication after attribute changes.',
    `gdsn_publication_status` STRING COMMENT 'Status of this GTIN in the GS1 Global Data Synchronization Network. Published (live in GDSN data pool), unpublished (not yet shared), pending (awaiting data pool validation), synchronized (confirmed by trading partners), rejected (validation errors). Required for supplier collaboration and EDI.. Valid values are `published|unpublished|pending|synchronized|rejected`',
    `gross_weight_unit` STRING COMMENT 'Unit of measure for gross_weight_value. Typically g (gram), kg (kilogram), oz (ounce), or lb (pound). Must be consistent across supply chain for accurate logistics planning.. Valid values are `g|kg|oz|lb`',
    `gross_weight_value` DECIMAL(18,2) COMMENT 'Total weight of the packaged item including product and packaging materials. Used for shipping calculations, freight costing, and warehouse capacity planning. Measured in gross_weight_unit.',
    `gs1_company_prefix` STRING COMMENT 'The GS1-issued company prefix portion of the GTIN. Identifies the brand owner or manufacturer who registered this GTIN with GS1. Typically 6-12 digits depending on the company size and GS1 member organization.. Valid values are `^[0-9]{6,12}$`',
    `gtin` STRING COMMENT 'The actual GTIN barcode value. Can be 8-digit (EAN-8, UPC-E), 12-digit (UPC-A), 13-digit (EAN-13), or 14-digit (GTIN-14/ITF-14) format. This is the scannable barcode number used at POS, warehouse receiving, and throughout the supply chain.. Valid values are `^[0-9]{8}$|^[0-9]{12}$|^[0-9]{13}$|^[0-9]{14}$`',
    `gtin_type` STRING COMMENT 'The specific GTIN format type. UPC-A (12-digit North America standard), UPC-E (8-digit compressed UPC), EAN-13 (13-digit international standard), EAN-8 (8-digit short EAN), GTIN-14 (14-digit case/pallet level), ITF-14 (Interleaved 2 of 5 barcode for GTIN-14).. Valid values are `UPC-A|UPC-E|EAN-13|EAN-8|GTIN-14|ITF-14`',
    `is_base_unit` BOOLEAN COMMENT 'Indicates whether this GTIN is the base unit of measure for inventory tracking. Typically true for the smallest sellable unit (each). All other packaging levels are multiples of the base unit. Used for inventory conversion calculations.',
    `is_consumer_unit` BOOLEAN COMMENT 'Indicates whether this GTIN represents a consumer-facing unit sold at POS. True for retail each units. False for case/pallet GTINs used only in supply chain. Determines whether GTIN should appear in e-commerce catalog and POS systems.',
    `is_orderable_unit` BOOLEAN COMMENT 'Indicates whether this GTIN can be ordered directly via EDI purchase orders. True for case and pallet GTINs typically ordered from suppliers. False for unit GTINs that are only sold at retail. Controls EDI transaction validation.',
    `is_variable_measure` BOOLEAN COMMENT 'Indicates whether this GTIN represents a variable measure item (e.g., meat, produce, cheese sold by weight). True for items where price varies by weight/quantity. Affects POS scanning behavior and pricing logic.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this GTIN registry record. Updated whenever any attribute changes. Used to track data freshness and trigger downstream synchronization processes.',
    `modified_by_user` STRING COMMENT 'User ID or system account that last modified this GTIN registry record. Used for audit trail and accountability. Links to identity management system for user details.',
    `net_content_value` DECIMAL(18,2) COMMENT 'The numeric quantity of product contained in this GTIN package. For example, 500 (when unit is mL), 12 (when unit is oz), 1.5 (when unit is kg). Used with net_content_unit to describe package size. Required for GDSN synchronization.',
    `package_depth_value` DECIMAL(18,2) COMMENT 'Depth dimension of the package. Used with height and width for cubic volume calculations. Essential for warehouse bin sizing and transportation load planning. Measured in package_dimension_unit.',
    `package_dimension_unit` STRING COMMENT 'Unit of measure for package dimensions (height, width, depth). Standard units: mm (millimeter), cm (centimeter), m (meter), in (inch), ft (foot). Must be consistent for all three dimensions.. Valid values are `mm|cm|m|in|ft`',
    `package_height_value` DECIMAL(18,2) COMMENT 'Height dimension of the package. Used with package_width_value and package_depth_value to calculate cubic volume for warehouse slotting, transportation planning, and shelf space allocation. Measured in package_dimension_unit.',
    `package_width_value` DECIMAL(18,2) COMMENT 'Width dimension of the package. Critical for planogram design, shelf allocation, and transportation cube optimization. Measured in package_dimension_unit.',
    `packaging_level` STRING COMMENT 'The packaging hierarchy level this GTIN represents. Unit (each/consumer unit), inner pack (multi-pack sold as one), case (shipping carton), pallet (full pallet load), display (retail display shipper). Critical for warehouse receiving and inventory management.. Valid values are `unit|inner_pack|case|pallet|display`',
    `parent_gtin` STRING COMMENT 'Self-referencing GTIN that represents the next higher packaging level in the hierarchy. For example, a unit GTINs parent would be the case GTIN. Null for the highest packaging level (typically pallet). Enables resolution of case receipts to constituent unit GTINs.. Valid values are `^[0-9]{8}$|^[0-9]{12}$|^[0-9]{13}$|^[0-9]{14}$`',
    `registration_status` STRING COMMENT 'Current lifecycle status of this GTIN registration. Active (in use), inactive (temporarily disabled), pending (awaiting approval), suspended (compliance issue), retired (permanently discontinued). Controls whether the GTIN can be used in transactions.. Valid values are `active|inactive|pending|suspended|retired`',
    `regulatory_compliance_status` STRING COMMENT 'Indicates whether this GTIN meets all applicable regulatory requirements for its country of sale. Compliant (approved for sale), non_compliant (blocked), pending_review (under evaluation), exempt (not subject to specific regulations). Enforced by quality assurance and legal teams.. Valid values are `compliant|non_compliant|pending_review|exempt`',
    `replacement_gtin` STRING COMMENT 'The new GTIN that supersedes this one when discontinued. Used for packaging changes, reformulations, or product transitions. Enables automatic substitution in ordering systems and maintains continuity in assortment planning.. Valid values are `^[0-9]{8}$|^[0-9]{12}$|^[0-9]{13}$|^[0-9]{14}$`',
    CONSTRAINT pk_gtin_registry PRIMARY KEY(`gtin_registry_id`)
) COMMENT 'Authoritative registry of all Global Trade Item Numbers (GTINs) including UPC-A, UPC-E, EAN-13, EAN-8, and ITF-14 barcodes associated with each SKU. Captures GTIN value, GTIN type (UPC, EAN, GTIN-14), SKU reference, issuing GS1 company prefix, barcode image reference, packaging level (unit, inner pack, case, pallet), parent GTIN reference (self-referencing for packaging hierarchy — e.g., case GTIN contains N unit GTINs), child GTIN count per parent, and registration status. Models the full GS1 packaging hierarchy enabling warehouse receiving at case level to resolve to constituent unit GTINs. Aligned with GS1 global standards. Supports EDI transactions (ASN, PO, invoice), warehouse receiving, POS scanning, and GDSN data synchronization.';

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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`assortment` (
    `assortment_id` BIGINT COMMENT 'Unique identifier for this SKU-to-node assortment assignment record. Primary key.',
    `cluster_id` BIGINT COMMENT 'Foreign key linking to store.cluster. Business justification: Retail clusters group stores with similar assortment strategies (urban vs suburban, high-income vs value-oriented). Assortment plans are built at cluster level then deployed to member locations. Enabl',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.department. Business justification: Department managers plan and execute assortments within their departments for space allocation, fixture planning, and merchandising standards. Assortment at department level drives planogram creation,',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.format. Business justification: Store formats (hypermarket, supermarket, convenience, discount) have fundamentally different assortment strategies driven by space, target customer, and operating model. Assortment plans are designed ',
    `fulfillment_node_id` BIGINT COMMENT 'Foreign key linking to the fulfillment node master record. Identifies which location is authorized to stock this SKU.',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.location. Business justification: Retail assortment planning assigns specific SKUs to specific store locations based on format, demographics, and space. Assortment.assortment_sku_id defines WHAT is carried; assortment_location_id defi',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor. Business justification: Location-SKU assortment planning requires preferred vendor designation for direct-store-delivery (DSD) routing, vendor-managed inventory (VMI) programs, and multi-source replenishment decisions. Criti',
    `sku_id` BIGINT COMMENT 'Foreign key linking to the SKU master record. Identifies which product is assigned to this fulfillment node.',
    `allocation_priority` STRING COMMENT 'Priority ranking for inventory allocation when supply is constrained. Lower numbers indicate higher priority (1 = highest priority). Used by allocation engines to determine which nodes receive inventory first during shortages. Typically based on sales velocity, strategic importance, or customer service level agreements.',
    `assignment_effective_date` DATE COMMENT 'Date when this SKU was first authorized to be stocked at this node. Marks the beginning of the assortment assignment. Used for assortment history tracking and performance analysis.',
    `assignment_end_date` DATE COMMENT 'Date when this SKU was removed from the authorized assortment at this node. Null for currently active assignments. Used for assortment history and discontinued product tracking.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this assortment assignment record was created in the system.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this assortment assignment record was last updated. Tracks changes to stocking status, min/max quantities, or other assignment parameters.',
    `last_received_date` DATE COMMENT 'Date when this SKU was last received into inventory at this node. Used to identify slow-moving or stale inventory, support FIFO/FEFO rotation, and flag potential obsolescence. Updated by warehouse management system upon receipt confirmation.',
    `max_stock_quantity` STRING COMMENT 'Maximum inventory quantity that should be stocked at this node for this SKU. Prevents overstocking and ensures efficient use of storage capacity. Set based on storage constraints, demand forecasts, and inventory turn targets. Node-specific based on storage capacity and sales velocity.',
    `min_stock_quantity` STRING COMMENT 'Minimum inventory quantity that should be maintained at this node for this SKU. Triggers replenishment when on-hand inventory falls below this threshold. Set based on lead time demand, safety stock calculations, and service level targets. Node-specific based on local demand patterns.',
    `replenishment_lead_time_days` STRING COMMENT 'Number of days required to replenish this SKU at this specific node from the time a replenishment order is placed. Includes order processing, picking, packing, transit, and receiving time. Node-specific based on distance from supply source, transportation mode, and receiving capacity.',
    `stocking_status` STRING COMMENT 'Current stocking status of this SKU at this specific node. ACTIVE (currently stocked and replenished), DISCONTINUED (no longer carried at this location), SEASONAL (stocked only during specific seasons), CLEARANCE (final inventory selldown), PENDING_SETUP (authorized but not yet received), TEMPORARY_OUT (temporarily not stocked). This is node-specific and can differ from the SKUs global lifecycle_status.',
    CONSTRAINT pk_assortment PRIMARY KEY(`assortment_id`)
) COMMENT 'This association product represents the operational assignment of SKUs to fulfillment nodes in the retail network. It captures which products are authorized to be stocked at which locations, along with node-specific inventory policies, allocation rules, and stocking parameters. Each record links one SKU to one fulfillment node with attributes that govern how that SKU is managed at that specific location. This is the authoritative source for product assortment decisions and location-specific inventory control parameters.. Existence Justification: In retail omnichannel operations, a single SKU is stocked across multiple fulfillment nodes (distribution centers, stores acting as ship-from-store locations, micro-fulfillment centers, dark stores), and each node carries thousands of different SKUs. The business actively manages these SKU-to-node assignments through assortment planning processes, setting node-specific inventory policies, allocation priorities, and stocking parameters for each SKU at each location. This is a core operational relationship managed by merchandising and supply chain teams.';

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
ALTER TABLE `vibe_retail_v1`.`product`.`image` ADD CONSTRAINT `fk_product_image_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ADD CONSTRAINT `fk_product_compliance_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ADD CONSTRAINT `fk_product_item_bundle_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ADD CONSTRAINT `fk_product_item_bundle_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ADD CONSTRAINT `fk_product_gtin_registry_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ADD CONSTRAINT `fk_product_gtin_registry_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ADD CONSTRAINT `fk_product_uom_base_uom_id` FOREIGN KEY (`base_uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ADD CONSTRAINT `fk_product_assortment_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`product` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_retail_v1`.`product` SET TAGS ('dbx_domain' = 'product');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` SET TAGS ('dbx_subdomain' = 'item_identity');
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
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` SET TAGS ('dbx_subdomain' = 'item_identity');
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
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` SET TAGS ('dbx_subdomain' = 'item_identity');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `attribute_id` SET TAGS ('dbx_business_glossary_term' = 'Product Attribute Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Product Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`attribute` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Attribute Uom Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`product`.`brand` SET TAGS ('dbx_subdomain' = 'item_identity');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ALTER COLUMN `average_margin_percent` SET TAGS ('dbx_business_glossary_term' = 'Average Margin Percentage');
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
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` SET TAGS ('dbx_subdomain' = 'item_identity');
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
ALTER TABLE `vibe_retail_v1`.`product`.`image` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`image` SET TAGS ('dbx_subdomain' = 'item_identity');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `image_id` SET TAGS ('dbx_business_glossary_term' = 'Product Image ID');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Uploaded By Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Source Vendor Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Image Approval Status');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'draft|pending_review|approved|rejected|archived');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `aspect_ratio` SET TAGS ('dbx_business_glossary_term' = 'Image Aspect Ratio');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `background_color` SET TAGS ('dbx_business_glossary_term' = 'Image Background Color');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `background_color` SET TAGS ('dbx_value_regex' = '^#[0-9A-Fa-f]{6}$');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `caption` SET TAGS ('dbx_business_glossary_term' = 'Image Caption');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `cdn_asset_reference` SET TAGS ('dbx_business_glossary_term' = 'Content Delivery Network (CDN) Asset Reference');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `color_profile` SET TAGS ('dbx_value_regex' = 'sRGB|Adobe_RGB|ProPhoto_RGB|CMYK');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `dpi` SET TAGS ('dbx_business_glossary_term' = 'Dots Per Inch (DPI)');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Image License Expiration Date');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `file_format` SET TAGS ('dbx_business_glossary_term' = 'Image File Format');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `file_format` SET TAGS ('dbx_value_regex' = 'JPEG|PNG|GIF|WEBP|SVG|TIFF');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `file_size_kb` SET TAGS ('dbx_business_glossary_term' = 'Image File Size in Kilobytes (KB)');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `has_transparency` SET TAGS ('dbx_business_glossary_term' = 'Has Transparency Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `image_type` SET TAGS ('dbx_value_regex' = 'hero|alternate|swatch|lifestyle|packaging|detail');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `is_primary` SET TAGS ('dbx_business_glossary_term' = 'Is Primary Image Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `license_type` SET TAGS ('dbx_business_glossary_term' = 'Image License Type');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `license_type` SET TAGS ('dbx_value_regex' = 'owned|licensed|royalty_free|creative_commons|vendor_supplied');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `locale` SET TAGS ('dbx_business_glossary_term' = 'Locale Code');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `locale` SET TAGS ('dbx_value_regex' = '^[a-z]{2}_[A-Z]{2}$');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `mobile_optimized` SET TAGS ('dbx_business_glossary_term' = 'Mobile Optimized Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `mobile_optimized` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `mobile_optimized` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `planogram_eligible` SET TAGS ('dbx_business_glossary_term' = 'Planogram (POG) Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `print_ready` SET TAGS ('dbx_business_glossary_term' = 'Print Ready Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `quality_score` SET TAGS ('dbx_business_glossary_term' = 'Image Quality Score');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `resolution_height` SET TAGS ('dbx_business_glossary_term' = 'Image Resolution Height');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `resolution_width` SET TAGS ('dbx_business_glossary_term' = 'Image Resolution Width');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `seo_keywords` SET TAGS ('dbx_business_glossary_term' = 'Search Engine Optimization (SEO) Keywords');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Image Sequence Number');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `url` SET TAGS ('dbx_business_glossary_term' = 'Image Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `url` SET TAGS ('dbx_value_regex' = '^https?://.*.(jpg|jpeg|png|gif|webp|svg)$');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `vendor_image_code` SET TAGS ('dbx_business_glossary_term' = 'Vendor Image Identifier');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `view_angle` SET TAGS ('dbx_business_glossary_term' = 'Product View Angle');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `zoom_enabled` SET TAGS ('dbx_business_glossary_term' = 'Zoom Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` SET TAGS ('dbx_subdomain' = 'regulatory_standards');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Carrier Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Product ID');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Vendor Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending_review|expired|suspended|recalled');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `fda_food_facility_registration` SET TAGS ('dbx_business_glossary_term' = 'Food and Drug Administration (FDA) Food Facility Registration');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `hazmat_classification` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Classification');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Compliance Notes');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `prop_65_chemical_list` SET TAGS ('dbx_business_glossary_term' = 'California Proposition 65 (Prop 65) Chemical List');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `prop_65_warning_required` SET TAGS ('dbx_business_glossary_term' = 'California Proposition 65 (Prop 65) Warning Required');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `recall_severity_level` SET TAGS ('dbx_value_regex' = 'class_1|class_2|class_3');
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ALTER COLUMN `recall_status` SET TAGS ('dbx_value_regex' = 'no_recall|active_recall|recall_completed|recall_pending');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` SET TAGS ('dbx_subdomain' = 'regulatory_standards');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `item_bundle_id` SET TAGS ('dbx_business_glossary_term' = 'Item Bundle Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Bundle Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Component Uom Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `bundle_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|discontinued|seasonal');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `bundle_type` SET TAGS ('dbx_value_regex' = 'fixed_bundle|mix_and_match|gift_set|kit|variety_pack|multi_pack');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `channel_availability` SET TAGS ('dbx_value_regex' = 'all_channels|store_only|online_only|bopis_eligible|ship_from_store');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `component_sequence` SET TAGS ('dbx_business_glossary_term' = 'Component Sequence Number');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `component_sku` SET TAGS ('dbx_business_glossary_term' = 'Component Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `component_sku` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,14}$');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `component_substitution_allowed` SET TAGS ('dbx_business_glossary_term' = 'Component Substitution Allowed Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `inventory_deduction_method` SET TAGS ('dbx_value_regex' = 'component_level|bundle_level|hybrid');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `loyalty_points_eligible` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Points Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `pricing_method` SET TAGS ('dbx_value_regex' = 'bundle_price|component_sum|discount_percentage|discount_amount');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `promotion_eligible` SET TAGS ('dbx_business_glossary_term' = 'Promotion Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `return_policy_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `returnable` SET TAGS ('dbx_business_glossary_term' = 'Returnable Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` SET TAGS ('dbx_subdomain' = 'item_identity');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `gtin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Global Trade Item Number (GTIN) Registry ID');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Net Content Uom Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `barcode_symbology` SET TAGS ('dbx_value_regex' = 'EAN|UPC|ITF-14|GS1-128|QR');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `check_digit` SET TAGS ('dbx_business_glossary_term' = 'GTIN Check Digit');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `check_digit` SET TAGS ('dbx_value_regex' = '^[0-9]{1}$');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `country_of_sale` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `discontinuation_date` SET TAGS ('dbx_business_glossary_term' = 'GTIN Discontinuation Date');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'GTIN Effective Date');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `gdsn_last_sync_timestamp` SET TAGS ('dbx_business_glossary_term' = 'GDSN Last Synchronization Timestamp');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `gdsn_publication_status` SET TAGS ('dbx_business_glossary_term' = 'Global Data Synchronization Network (GDSN) Publication Status');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `gdsn_publication_status` SET TAGS ('dbx_value_regex' = 'published|unpublished|pending|synchronized|rejected');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `gross_weight_unit` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight Unit of Measure');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `gross_weight_unit` SET TAGS ('dbx_value_regex' = 'g|kg|oz|lb');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `gs1_company_prefix` SET TAGS ('dbx_value_regex' = '^[0-9]{6,12}$');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `gtin` SET TAGS ('dbx_business_glossary_term' = 'Global Trade Item Number (GTIN)');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `gtin` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$|^[0-9]{12}$|^[0-9]{13}$|^[0-9]{14}$');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `gtin_type` SET TAGS ('dbx_value_regex' = 'UPC-A|UPC-E|EAN-13|EAN-8|GTIN-14|ITF-14');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `is_variable_measure` SET TAGS ('dbx_business_glossary_term' = 'Is Variable Measure Item');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `package_dimension_unit` SET TAGS ('dbx_business_glossary_term' = 'Package Dimension Unit of Measure');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `package_dimension_unit` SET TAGS ('dbx_value_regex' = 'mm|cm|m|in|ft');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `packaging_level` SET TAGS ('dbx_value_regex' = 'unit|inner_pack|case|pallet|display');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `parent_gtin` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$|^[0-9]{12}$|^[0-9]{13}$|^[0-9]{14}$');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `registration_status` SET TAGS ('dbx_business_glossary_term' = 'GTIN Registration Status');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `registration_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|suspended|retired');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `regulatory_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending_review|exempt');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `replacement_gtin` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$|^[0-9]{12}$|^[0-9]{13}$|^[0-9]{14}$');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` SET TAGS ('dbx_subdomain' = 'regulatory_standards');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM) ID');
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
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` SET TAGS ('dbx_subdomain' = 'regulatory_standards');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `assortment_id` SET TAGS ('dbx_business_glossary_term' = 'Assortment Assignment Identifier');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Cluster Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Assortment - Fulfillment Node Id');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Assortment Location Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Vendor Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Assortment - Sku Id');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `allocation_priority` SET TAGS ('dbx_business_glossary_term' = 'Inventory Allocation Priority Rank');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `assignment_effective_date` SET TAGS ('dbx_business_glossary_term' = 'Assortment Assignment Effective Date');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `assignment_end_date` SET TAGS ('dbx_business_glossary_term' = 'Assortment Assignment End Date');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `last_received_date` SET TAGS ('dbx_business_glossary_term' = 'Last Inventory Receipt Date');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `max_stock_quantity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Stock Quantity Ceiling');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `min_stock_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Stock Quantity Threshold');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `replenishment_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Node-Specific Replenishment Lead Time');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `stocking_status` SET TAGS ('dbx_business_glossary_term' = 'Node-Specific Stocking Status');
