-- Schema for Domain: product | Business:  | Version: v2_ecm
-- Generated on: 2026-07-12 09:24:25

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`product` COMMENT 'Authoritative catalog of all merchandise including SKUs, UPCs, GTINs, EANs, product hierarchies (department, category, subcategory), attributes, descriptions, images, private label vs. national brands, and assortment depth and breadth classifications. Managed via PIM (Product Information Management) and MDM systems. Supports category management, new item setup, and product lifecycle from introduction to discontinuation.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`sku` (
    `sku_id` BIGINT COMMENT 'Unique identifier for the Stock Keeping Unit. Primary key for the SKU master record.',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: sku has department_code, category_code, subcategory_code (all STRING) which should be normalized to a single FK to item_hierarchy. The hierarchy table is the authoritative source for merchandise taxon',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.store_location. Business justification: Store-level assortment planning and authorization. Retail assortment systems maintain store-SKU authorization matrices determining which items each store is authorized to carry. Critical for planogram',
    `marketing_brand_id` BIGINT COMMENT 'Foreign key linking to marketing.marketing_brand. Business justification: Retail marketing operations require linking SKUs to marketing brand entities for campaign planning, brand performance analysis, and marketing attribution reporting. Distinct from product_brand (supply',
    `product_brand_id` BIGINT COMMENT 'add column product_brand_id (BIGINT) with FK to product.product_brand.product_brand_id - SKUs belong to brands and this relationship is fundamental for brand-level reporting and assortment planning',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: sku.unit_of_measure (STRING) should be normalized to a proper FK to uom reference table. UOM is the authoritative master for all units of measure with conversion factors and standards compliance (GS1,',
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
    `cost_center_id` BIGINT COMMENT 'FK to finance.cost_center',
    `gl_account_id` BIGINT COMMENT 'FK to finance.gl_account',
    `parent_hierarchy_node_item_hierarchy_id` BIGINT COMMENT 'Foreign key reference to the parent node in the hierarchy tree. Self-referencing relationship enabling tree traversal and roll-up aggregations. Null for top-level division nodes.',
    `profit_center_id` BIGINT COMMENT 'FK to finance.profit_center',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`product_attribute` (
    `product_attribute_id` BIGINT COMMENT 'Unique identifier for the product attribute record. Primary key for the product_attribute entity.',
    `sku_id` BIGINT COMMENT 'Foreign key reference to the parent product (SKU) to which this attribute belongs. Links to the product master catalog.',
    `approved_by` STRING COMMENT 'The username or identifier of the person who approved this product attribute value for publication. Supports accountability and audit trails in PIM workflows.',
    `approved_timestamp` TIMESTAMP COMMENT 'The date and time when this product attribute value was approved for publication or use in operational systems. Supports PIM workflow and governance processes.',
    `attribute_group` STRING COMMENT 'Logical grouping or category of the attribute (e.g., physical, technical, descriptive, nutritional, environmental, regulatory, marketing, quality, packaging, pricing). Enables faceted search and attribute organization in PIM systems. [ENUM-REF-CANDIDATE: physical|technical|descriptive|nutritional|environmental|regulatory|marketing|quality|packaging|pricing — 10 candidates stripped; promote to reference product]',
    `attribute_name` STRING COMMENT 'The name or label of the product attribute (e.g., color, size, fabric, flavor, wattage, nutritional_info). Represents the semantic key in the entity-attribute-value (EAV) pattern.',
    `attribute_status` STRING COMMENT 'Current lifecycle status of this attribute record (e.g., active, inactive, pending_approval, deprecated, archived). Supports attribute governance and PIM workflow management.. Valid values are `active|inactive|pending_approval|deprecated|archived`',
    `attribute_value` DECIMAL(18,2) COMMENT 'The actual value of the product attribute (e.g., Red, Large, 100% Cotton, Vanilla, 60W, 15g protein per serving). Stores the descriptive, technical, or measurement data for the attribute.',
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
    `notes` STRING COMMENT 'Free-text field for additional notes, comments, or context about this product attribute. Used for internal documentation, special handling instructions, or data steward annotations.',
    `regulatory_reference` STRING COMMENT 'Citation or reference to the specific regulation, statute, or standard that mandates this attribute (e.g., FDA 21 CFR 101.9, CPSC 16 CFR 1500, FTC 16 CFR Part 255). Applicable when is_regulatory_required is True.',
    `source_system_code` STRING COMMENT 'The unique identifier or key for this attribute record in the source system. Enables traceability and cross-system reconciliation.',
    `unit_of_measure` STRING COMMENT 'The unit of measure for numeric or measurement attributes (e.g., kg, lb, cm, inch, ml, oz, watt, volt, calorie). Supports multi-UOM transaction processing across procurement, inventory, and POS.',
    `validation_rule` STRING COMMENT 'Business rule or regex pattern used to validate the attribute value (e.g., must be positive integer, must match color palette, must be ISO 8601 date). Enforces data quality at attribute capture time.',
    CONSTRAINT pk_product_attribute PRIMARY KEY(`product_attribute_id`)
) COMMENT 'Stores extended descriptive, technical, and measurement attributes for each SKU beyond core identity fields using a flexible entity-attribute-value (EAV) pattern. Captures attribute name, attribute value, attribute group (e.g., fabric, color, size, flavor, nutritional supplement, technical spec, UOM conversion, environmental certification, data quality score), data type, unit of measure, conversion factor, validation rule, source system, and locale/language for multilingual and multi-market support. Enables faceted search on e-commerce platforms, product comparison, PIM-driven enrichment, multi-UOM transaction support across procurement/inventory/POS, data completeness scoring for GS1 GDSN readiness, and regulatory attribute capture. Sourced from the customer master data system PIM module and the e-commerce platform product catalog. Aligned with GS1 GDSN attribute standards for trade item data synchronization.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`product_brand` (
    `product_brand_id` BIGINT COMMENT 'Unique identifier for the product brand record. Primary key.',
    `item_hierarchy_id` BIGINT COMMENT 'add column item_hierarchy_id (BIGINT) with FK to product.item_hierarchy.item_hierarchy_id - brands operate within product hierarchy categories for category management',
    `vendor_id` BIGINT COMMENT 'Reference to the primary supplier or vendor who provides products under this brand. Links to the supplier master data for vendor negotiations, chargeback processing, and Vendor Managed Inventory (VMI) programs.',
    `average_margin_percent` DECIMAL(18,2) COMMENT 'Average gross margin percentage achieved across all SKUs (Stock Keeping Units) under this brand. Calculated as (Average Unit Retail - Cost of Goods Sold) / Average Unit Retail * 100. Critical for brand profitability analysis and private label vs. national brand comparison.',
    `brand_code` STRING COMMENT 'Unique alphanumeric code assigned to the brand for internal identification and system integration. Used in merchandising, procurement, and reporting systems.. Valid values are `^[A-Z0-9]{3,20}$`',
    `brand_description` STRING COMMENT 'Detailed narrative describing the brand positioning, value proposition, target customer segment, and key differentiators. Used for internal merchandising guidance and external marketing content.',
    `brand_name` STRING COMMENT 'Official registered name of the brand as it appears on product packaging and marketing materials. Consumer-facing brand identifier.',
    `brand_status` STRING COMMENT 'Current lifecycle status of the brand in the retail assortment. Active brands are available for new item setup and replenishment; inactive brands are temporarily suspended; discontinued brands are permanently removed; pending approval brands are under review for introduction.. Valid values are `active|inactive|discontinued|pending_approval`',
    `brand_tier` STRING COMMENT 'Market positioning tier indicating price point and quality perception. Premium brands command higher margins and target affluent consumers; value and economy brands focus on price-sensitive segments. Drives assortment strategy and shelf placement.. Valid values are `premium|standard|value|economy`',
    `brand_type` STRING COMMENT 'Classification of brand ownership and distribution model. National brands are manufacturer-owned and widely distributed; private label are retailer-owned store brands; exclusive brands are sold only through specific retail partnerships; licensed brands use third-party intellectual property.. Valid values are `national|private_label|exclusive|licensed`',
    `country_of_origin_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the primary country where products under this brand are manufactured or sourced. Required for customs compliance and consumer transparency.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this brand record was first created in the Master Data Management (MDM) system. Used for data lineage tracking and audit trail compliance.',
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
    `owner_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the country where the brand owner is headquartered. Used for country-of-origin reporting and supplier diversity analytics.. Valid values are `^[A-Z]{3}$`',
    `owner_name` STRING COMMENT 'Legal name of the company or entity that owns the intellectual property rights to the brand. May be the retailer (for private label) or a manufacturer/supplier (for national brands).',
    `portfolio_group` STRING COMMENT 'Higher-level grouping of related brands under a common portfolio or brand family. Enables portfolio-level margin analysis, vendor negotiations, and strategic assortment planning across brand families.',
    `quality_rating` DECIMAL(18,2) COMMENT 'Internal quality assessment score for the brand based on product defect rates, customer returns, and quality audits. Scale of 0.00 to 5.00. Used for vendor scorecard evaluation and assortment quality management.',
    `return_rate_percent` DECIMAL(18,2) COMMENT 'Percentage of units sold under this brand that are returned by customers. Calculated as (units returned / units sold) * 100. High return rates may indicate quality issues or misaligned customer expectations.',
    `sustainability_certification` STRING COMMENT 'Environmental or social responsibility certifications held by the brand (e.g., Fair Trade, Organic, B Corp, Carbon Neutral). Supports ESG reporting and consumer filtering on e-commerce platforms for sustainable products.',
    `target_customer_segment` STRING COMMENT 'Primary demographic or psychographic customer segment that this brand is designed to appeal to (e.g., millennials, families, health-conscious, budget shoppers). Supports personalized marketing and assortment localization.',
    `website_url` STRING COMMENT 'Official website URL for the brand, providing additional product information, brand story, and consumer engagement content. Used for e-commerce product page enrichment and customer education.',
    CONSTRAINT pk_product_brand PRIMARY KEY(`product_brand_id`)
) COMMENT 'Master record for all brands carried in the retail assortment, covering national brands, private label (store brand), exclusive, and licensed products. Captures brand name, brand owner, brand type (national, private label, exclusive, licensed), brand tier (premium, value, standard), country of origin, brand logo asset reference, brand status, launch date, and brand portfolio grouping. Supports private label vs. national brand assortment strategy, vendor brand negotiations, brand-level margin analysis, and consumer-facing brand filtering on e-commerce platforms.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`item_variant` (
    `item_variant_id` BIGINT COMMENT 'Unique identifier for the item variant relationship record. Primary key.',
    `associate_id` BIGINT COMMENT 'Identifier of the user or system account that approved this variant or substitution relationship for use. Used for accountability and compliance in merchandising and product data governance.',
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
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: product_image.sku (STRING) should be normalized to a proper FK. Images are assets associated with specific SKUs. This is a standard 1:N relationship (one SKU has many images).',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Retail digital asset management requires tracking which associate uploaded/approved each product image for content workflow, quality control, audit trails, and accountability. Critical for e-commerce',
    `alt_text` STRING COMMENT 'Descriptive text for the image used for accessibility (screen readers) and SEO. Describes the image content for visually impaired users.',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` (
    `item_lifecycle_event_id` BIGINT COMMENT 'Unique identifier for each item lifecycle event record. Primary key for the item lifecycle event log.',
    `associate_id` BIGINT COMMENT 'The system user identifier of the person who approved or rejected this lifecycle event. Null if approval is not required or still pending.',
    `buyer_id` BIGINT COMMENT 'The identifier of the merchandise buyer responsible for this SKU during the lifecycle event. Used for accountability and category management tracking.',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.store_location. Business justification: New item launches and discontinuations are phased by store or store cluster. Lifecycle events track which stores receive new items in each wave. Essential for launch wave planning and discontinuation',
    `primary_item_associate_id` BIGINT COMMENT 'The system user identifier of the person or automated process that initiated this lifecycle event. Used for accountability and audit purposes.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: item_lifecycle_event.sku (STRING) should be normalized to a proper FK. Lifecycle events track state changes for specific SKUs. The department/category/subcategory codes are redundant - they can be ret',
    `vendor_id` BIGINT COMMENT 'The unique identifier of the supplier or vendor associated with this SKU at the time of the lifecycle event. Relevant for new item introductions, vendor changes, and discontinuations.',
    `actual_launch_date` DATE COMMENT 'The actual date when the SKU became active and available for sale. Used to measure performance against target launch date and track new item setup SLA compliance.',
    `approval_status` STRING COMMENT 'The approval state of this lifecycle event. Tracks whether the event required approval and if it was granted, rejected, or automatically approved per business rules.. Valid values are `pending|approved|rejected|auto_approved|not_required`',
    `approval_timestamp` TIMESTAMP COMMENT 'The date and time when the lifecycle event was approved or rejected. Null if approval is not required or still pending.',
    `compliance_reference_number` STRING COMMENT 'External reference number for regulatory compliance documentation (e.g., FDA submission number, CPSC recall number). Supports audit trails for regulatory compliance.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this lifecycle event record was first created in the data lakehouse. Audit field for data lineage and troubleshooting.',
    `discontinuation_date` DATE COMMENT 'The date when the SKU was or will be discontinued and removed from active assortment. Applicable to discontinuation and end-of-life events.',
    `effective_date` DATE COMMENT 'The date from which the new lifecycle status becomes effective. May differ from event timestamp for planned future transitions.',
    `event_timestamp` TIMESTAMP COMMENT 'The date and time when the lifecycle event occurred in the source system. Represents the real-world business event time, distinct from audit timestamps.',
    `event_type` STRING COMMENT 'The type of lifecycle state change event. Categorizes the nature of the transition (e.g., new item introduction, range extension, reformulation, repackaging, seasonal activation/deactivation, markdown initiation, clearance transition, discontinuation). [ENUM-REF-CANDIDATE: new_item_introduction|range_extension|reformulation|repackaging|seasonal_activation|seasonal_deactivation|markdown_initiation|clearance_transition|discontinuation|product_recall|vendor_change|assortment_exit — promote to reference product]',
    `is_private_label` BOOLEAN COMMENT 'Indicates whether the SKU is a private label (store brand) product. Used to track private label development milestones and lifecycle management separately from national brands.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this lifecycle event record was last updated in the data lakehouse. Audit field for tracking data changes and lineage.',
    `new_status` STRING COMMENT 'The lifecycle status of the SKU after this event was applied. Represents the current state following the transition. [ENUM-REF-CANDIDATE: draft|pending_approval|active|seasonal_inactive|markdown|clearance|discontinued — 7 candidates stripped; promote to reference product]',
    `prior_status` STRING COMMENT 'The lifecycle status of the SKU immediately before this event occurred. Enables tracking of state transitions and audit trails. [ENUM-REF-CANDIDATE: draft|pending_approval|active|seasonal_inactive|markdown|clearance|discontinued — 7 candidates stripped; promote to reference product]',
    `reason_code` STRING COMMENT 'A standardized code indicating the business reason for the lifecycle event (e.g., seasonal refresh, vendor discontinuation, poor sales performance, regulatory compliance, quality issue, competitive response).',
    `reason_description` STRING COMMENT 'Free-text description providing additional context and details about why this lifecycle event was triggered. Complements the reason code with specific business justification.',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether this lifecycle event was triggered by or requires regulatory compliance action (e.g., Food and Drug Administration (FDA) labeling change, Consumer Product Safety Commission (CPSC) recall, safety standard update).',
    `requestor_name` STRING COMMENT 'The name of the person or team who originally requested this lifecycle event. Used for new item setup workflow tracking and accountability.',
    `source_system_event_code` STRING COMMENT 'The unique identifier of this lifecycle event in the source operational system. Used for traceability and reconciliation with upstream systems.',
    `supporting_notes` STRING COMMENT 'Additional free-text notes and comments providing context, instructions, or documentation for this lifecycle event. Used for knowledge transfer and audit trail completeness.',
    `target_launch_date` DATE COMMENT 'The planned date for the SKU to become active and available for sale. Applicable primarily to new item introduction and seasonal activation events. Used for new item setup Service Level Agreement (SLA) tracking.',
    `workflow_stage` STRING COMMENT 'The current stage in the new item setup or lifecycle change workflow. Tracks progression through the approval chain from initial submission to final approval or rejection.. Valid values are `vendor_submission|buyer_review|data_entry|approval_pending|approved|rejected`',
    CONSTRAINT pk_item_lifecycle_event PRIMARY KEY(`item_lifecycle_event_id`)
) COMMENT 'Transactional log of significant lifecycle state changes for each SKU from initial vendor submission through end-of-life. Captures new item introduction (setup workflow with requestor, vendor, buyer assignment, data steward, target launch date, approval chain), range extension, reformulation, repackaging, seasonal activation/deactivation, markdown initiation, clearance transition, and discontinuation. Stores event type, event date, triggered-by user, approval status, prior status, new status, reason code, and supporting notes. Supports product lifecycle management, new item setup SLA tracking, private label development milestones, and audit trails for regulatory compliance (FDA, CPSC). Sourced from the retail merchandising system Merchandising System.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`product_compliance` (
    `product_compliance_id` BIGINT COMMENT 'Unique identifier for the product compliance record. Primary key.',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: Specific carrier service levels have distinct compliance capabilities (e.g., ground hazmat vs air hazmat, refrigerated vs ambient). Retail compliance teams pre-approve specific carrier services for re',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier. Business justification: Retail operations require matching product compliance requirements (hazmat certification, temperature control, age-restricted handling) to carrier capabilities. Hazmat-certified products can only ship',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Regulatory compliance management requires designated compliance officers (associates) responsible for maintaining certifications, audit records, and regulatory submissions. Essential for FDA, CPSC, an',
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
    CONSTRAINT pk_product_compliance PRIMARY KEY(`product_compliance_id`)
) COMMENT 'Tracks regulatory and safety compliance attributes for each SKU including FDA food labeling compliance, CPSC safety certifications, FTC advertising standards, hazardous material classification, age restriction requirements, country-specific import compliance, and recall status. Captures compliance type, certifying body, certification number, effective date, expiry date, compliance status, and last audit date. Supports regulatory reporting and product recall management.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`recall` (
    `recall_id` BIGINT COMMENT 'Unique identifier for the product recall event. Primary key for the product recall record.',
    `compliance_program_id` BIGINT COMMENT 'add column compliance_program_id (BIGINT) with FK to compliance.compliance_program.compliance_program_id - product recalls are governed by compliance programs (FDA, CPSC) and need this regulatory linkage',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Product recall management requires designated recall coordinators to manage regulatory notifications, customer communications, and recovery operations. Critical for FDA/CPSC compliance and liability m',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Product recalls incur significant costs (recovery, disposal, refunds, legal) that must be tracked against specific cost centers for budget management, variance analysis, and financial reporting. Retai',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Recall expenses must be posted to specific GL accounts (product liability reserves, disposal costs, customer refunds) for GAAP-compliant financial statements and accurate P&L reporting. Required for a',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.store_location. Business justification: Product recalls must identify which stores received affected lots for customer notification, product removal from shelves, and recovery tracking. Recall execution systems require store-level tracking',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: product_recall.sku (STRING) should be normalized to a proper FK. Recalls are initiated for specific SKUs. The upc and gtin columns are redundant - they can be retrieved via sku → gtin_registry join.',
    `vendor_id` BIGINT COMMENT 'Unique identifier for the supplier or vendor who manufactured or provided the recalled product. Used for vendor accountability and chargeback processing.',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`item_bundle` (
    `item_bundle_id` BIGINT COMMENT 'Unique identifier for the item bundle configuration. Primary key.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: item_bundle.bundle_sku (STRING) should be normalized to a proper FK. The bundle itself is a SKU in the catalog. This links the bundle definition to its SKU master record. bundle_gtin can be retrieved',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Merchandising associates create promotional bundles and multi-packs. Tracking creator enables workflow management, approval routing, performance measurement, and audit trails for promotional planning',
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
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: GTIN registry maintenance requires data stewards to ensure GS1 compliance, barcode accuracy, and GDSN synchronization. Essential for master data governance, supply chain integration, and point-of-sale',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: gtin_registry.sku_code (STRING) should be normalized to a proper FK. GTINs are registered for specific SKUs - this is the authoritative link between global trade item numbers and internal SKU master.',
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
    `net_content_unit` STRING COMMENT 'The unit of measure for net_content_value. Standard units: g (gram), kg (kilogram), mg (milligram), oz (ounce), lb (pound), mL (milliliter), L (liter), gal (gallon), qt (quart), pt (pint), ea (each), ct (count). Must align with regulatory labeling requirements. [ENUM-REF-CANDIDATE: g|kg|mg|oz|lb|mL|L|gal|qt|pt|ea|ct — 12 candidates stripped; promote to reference product]',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`item_nutritional` (
    `item_nutritional_id` BIGINT COMMENT 'Unique identifier for the nutritional information record. Primary key for the item nutritional data product.',
    `sku_id` BIGINT COMMENT 'Foreign key reference to the SKU product. Links nutritional information to the specific product item.',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Nutritional labeling requires validation by qualified associates (dietitians, compliance specialists) for FDA compliance, allergen accuracy, and regulatory audit trails. Critical for food safety, liab',
    `added_sugars_g` DECIMAL(18,2) COMMENT 'Added sugar content per serving measured in grams. Required under updated FDA nutrition facts label rules.',
    `allergen_declaration` STRING COMMENT 'Declaration of major food allergens present in the product. Must identify milk, eggs, fish, crustacean shellfish, tree nuts, peanuts, wheat, and soybeans per FALCPA requirements.',
    `calcium_mg` DECIMAL(18,2) COMMENT 'Calcium content per serving measured in milligrams. Required under updated FDA nutrition facts label.',
    `calories_from_fat` STRING COMMENT 'Number of calories derived from fat per serving. Optional field under updated FDA labeling rules.',
    `calories_per_serving` STRING COMMENT 'Total caloric content per serving, measured in kilocalories (kcal). Required on FDA nutrition facts label.',
    `cholesterol_mg` DECIMAL(18,2) COMMENT 'Cholesterol content per serving measured in milligrams. Required FDA nutrition facts component.',
    `contains_eggs` BOOLEAN COMMENT 'Boolean flag indicating whether the product contains eggs or egg-derived ingredients. Supports allergen filtering and dietary restriction compliance.',
    `contains_fish` BOOLEAN COMMENT 'Boolean flag indicating whether the product contains fish or fish-derived ingredients. Supports allergen filtering and dietary restriction compliance.',
    `contains_milk` BOOLEAN COMMENT 'Boolean flag indicating whether the product contains milk or milk-derived ingredients. Supports allergen filtering and dietary restriction compliance.',
    `contains_peanuts` BOOLEAN COMMENT 'Boolean flag indicating whether the product contains peanuts or peanut-derived ingredients. Supports allergen filtering and dietary restriction compliance.',
    `contains_shellfish` BOOLEAN COMMENT 'Boolean flag indicating whether the product contains crustacean shellfish or shellfish-derived ingredients. Supports allergen filtering and dietary restriction compliance.',
    `contains_soybeans` BOOLEAN COMMENT 'Boolean flag indicating whether the product contains soybeans or soy-derived ingredients. Supports allergen filtering and dietary restriction compliance.',
    `contains_tree_nuts` BOOLEAN COMMENT 'Boolean flag indicating whether the product contains tree nuts or tree nut-derived ingredients. Supports allergen filtering and dietary restriction compliance.',
    `contains_wheat` BOOLEAN COMMENT 'Boolean flag indicating whether the product contains wheat or wheat-derived ingredients. Supports allergen filtering and dietary restriction compliance.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this nutritional information record was first created in the system. Supports audit trail and data lineage tracking.',
    `dietary_fiber_g` DECIMAL(18,2) COMMENT 'Dietary fiber content per serving measured in grams. Required FDA nutrition facts component.',
    `ingredient_statement` STRING COMMENT 'Complete list of ingredients in descending order of predominance by weight as required by FDA labeling regulations. Includes sub-ingredients for compound ingredients.',
    `iron_mg` DECIMAL(18,2) COMMENT 'Iron content per serving measured in milligrams. Required under updated FDA nutrition facts label.',
    `is_gluten_free` BOOLEAN COMMENT 'Boolean flag indicating whether the product meets FDA gluten-free labeling standards (less than 20 ppm gluten). Supports dietary restriction filtering.',
    `is_halal_certified` BOOLEAN COMMENT 'Boolean flag indicating whether the product is certified halal by a recognized halal certification body. Supports dietary and religious preference filtering.',
    `is_kosher_certified` BOOLEAN COMMENT 'Boolean flag indicating whether the product is certified kosher by a recognized kosher certification agency. Supports dietary and religious preference filtering.',
    `is_non_gmo_verified` BOOLEAN COMMENT 'Boolean flag indicating whether the product is verified as non-GMO by the Non-GMO Project or equivalent verification program. Supports dietary preference filtering.',
    `is_organic_certified` BOOLEAN COMMENT 'Boolean flag indicating whether the product is certified organic by USDA or equivalent certifying body. Supports organic product filtering and merchandising.',
    `is_vegan` BOOLEAN COMMENT 'Boolean flag indicating whether the product contains no animal-derived ingredients or by-products. Supports dietary preference filtering.',
    `is_vegetarian` BOOLEAN COMMENT 'Boolean flag indicating whether the product contains no meat, poultry, or fish ingredients. May contain dairy or eggs. Supports dietary preference filtering.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this nutritional information record was last updated. Supports audit trail and change tracking.',
    `modified_by_user` STRING COMMENT 'User ID or system identifier of the person or process that last modified this nutritional information record. Supports audit trail and accountability.',
    `monounsaturated_fat_g` DECIMAL(18,2) COMMENT 'Monounsaturated fat content per serving measured in grams. Optional voluntary declaration.',
    `nutritional_data_effective_date` DATE COMMENT 'Date when this nutritional information became effective for the product. Supports version control and regulatory compliance tracking.',
    `nutritional_data_expiration_date` DATE COMMENT 'Date when this nutritional information expires or is superseded by updated data. Null if currently active. Supports version control and compliance tracking.',
    `nutritional_data_source` STRING COMMENT 'Source of the nutritional information (laboratory analysis, USDA database, supplier-provided, calculated from ingredients, third-party database). Supports data quality and compliance auditing.. Valid values are `laboratory_analysis|usda_database|supplier_provided|calculated|third_party_database`',
    `organic_certification_body` STRING COMMENT 'Name of the organization that certified the product as organic (e.g., USDA, CCOF, Oregon Tilth). Null if product is not organic certified.',
    `polyunsaturated_fat_g` DECIMAL(18,2) COMMENT 'Polyunsaturated fat content per serving measured in grams. Optional voluntary declaration.',
    `potassium_mg` DECIMAL(18,2) COMMENT 'Potassium content per serving measured in milligrams. Required under updated FDA nutrition facts label.',
    `protein_g` DECIMAL(18,2) COMMENT 'Protein content per serving measured in grams. Required FDA nutrition facts component.',
    `saturated_fat_g` DECIMAL(18,2) COMMENT 'Saturated fat content per serving measured in grams. Required FDA nutrition facts component.',
    `serving_size_unit` STRING COMMENT 'Unit of measure for the serving size (grams, milliliters, ounces, cups, pieces, etc.). [ENUM-REF-CANDIDATE: g|mg|kg|ml|l|oz|fl oz|cup|tbsp|tsp|piece|slice|container — 13 candidates stripped; promote to reference product]',
    `serving_size_value` DECIMAL(18,2) COMMENT 'Numeric value representing the standard serving size for this product as defined by FDA regulations.',
    `servings_per_container` DECIMAL(18,2) COMMENT 'Number of servings contained in the package. May be approximate for variable-weight items.',
    `sodium_mg` DECIMAL(18,2) COMMENT 'Sodium content per serving measured in milligrams. Required FDA nutrition facts component.',
    `total_carbohydrate_g` DECIMAL(18,2) COMMENT 'Total carbohydrate content per serving measured in grams. Includes dietary fiber, sugars, and other carbohydrates.',
    `total_fat_g` DECIMAL(18,2) COMMENT 'Total fat content per serving measured in grams. Includes saturated, trans, monounsaturated, and polyunsaturated fats.',
    `total_sugars_g` DECIMAL(18,2) COMMENT 'Total sugar content per serving measured in grams. Includes naturally occurring and added sugars.',
    `trans_fat_g` DECIMAL(18,2) COMMENT 'Trans fat content per serving measured in grams. Must be declared per FDA regulations.',
    `vitamin_d_mcg` DECIMAL(18,2) COMMENT 'Vitamin D content per serving measured in micrograms. Required under updated FDA nutrition facts label.',
    CONSTRAINT pk_item_nutritional PRIMARY KEY(`item_nutritional_id`)
) COMMENT 'Stores FDA-mandated nutritional facts and ingredient information for food and beverage SKUs. Captures serving size, servings per container, calories, total fat, saturated fat, trans fat, cholesterol, sodium, total carbohydrates, dietary fiber, total sugars, added sugars, protein, vitamins and minerals, ingredient list, allergen declarations, and organic/non-GMO certifications. Supports FDA food labeling compliance, e-commerce product display, and dietary filtering.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`item_cross_reference` (
    `item_cross_reference_id` BIGINT COMMENT 'Unique identifier for the item cross reference record. Primary key.',
    `associate_id` BIGINT COMMENT 'The user ID or name of the person who validated this cross reference mapping. Provides accountability for data quality assurance.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: item_cross_reference.internal_sku (STRING) should be normalized to a proper FK. This table maps external system identifiers to internal SKUs - the internal_sku is the core link to the authoritative SK',
    `superseded_by_reference_item_cross_reference_id` BIGINT COMMENT 'The item_cross_reference_id of the newer mapping that replaces this one when status is superseded. Creates a chain of reference history for audit and troubleshooting.',
    `vendor_id` BIGINT COMMENT 'Identifier of the trading partner (supplier, vendor, distributor, marketplace) associated with this cross reference. Used for EDI transactions and supplier collaboration.',
    `conversion_factor` DECIMAL(18,2) COMMENT 'Numeric conversion factor used when the external system uses different units of measure than the internal system. For example, if internal system tracks in eaches but external system tracks in cases, this would be the case pack quantity.',
    `created_by_user` STRING COMMENT 'The user ID or name of the person or system process that created this cross reference record. Provides accountability and audit trail.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this cross reference record was first created in the system. Used for audit trail and data lineage tracking.',
    `cross_reference_status` STRING COMMENT 'Current lifecycle status of the cross reference mapping. Active indicates the mapping is currently in use, inactive means it is no longer valid, pending indicates awaiting approval, deprecated means phasing out, and superseded means replaced by a newer mapping.. Valid values are `ACTIVE|INACTIVE|PENDING|DEPRECATED|SUPERSEDED`',
    `cross_reference_type` STRING COMMENT 'Classification of the cross reference relationship. Indicates the nature of the external identifier such as supplier part number, legacy item number from a retired system, marketplace ASIN for Amazon or other platforms, vendor-specific SKU, distributor code, or manufacturer code.. Valid values are `SUPPLIER_PART_NUMBER|LEGACY_ITEM_NUMBER|MARKETPLACE_ASIN|VENDOR_SKU|DISTRIBUTOR_CODE|MANUFACTURER_CODE`',
    `effective_end_date` DATE COMMENT 'The date after which this cross reference mapping is no longer valid. Null indicates an open-ended mapping that remains active until explicitly terminated.',
    `effective_start_date` DATE COMMENT 'The date from which this cross reference mapping becomes valid and should be used for system integration and EDI transactions.',
    `external_item_description` STRING COMMENT 'The item description as it appears in the external system. Useful for reconciliation and troubleshooting when descriptions differ across systems.',
    `external_item_number` STRING COMMENT 'The item identifier used by the external system. This could be a supplier part number, legacy item code, marketplace ASIN, or system-specific SKU.',
    `external_system_instance` STRING COMMENT 'Specific instance or environment of the external system when multiple instances exist (e.g., SAP Production, SAP QA, ORMS US, ORMS EU). Helps disambiguate cross references when the same system is deployed in multiple regions or environments.',
    `external_system_name` STRING COMMENT 'Name of the external or legacy system that uses the external item identifier. Examples include SAP, the retail merchandising system Merchandising System (ORMS), Manhattan WMS, supplier EDI systems, e-commerce platforms, or legacy systems. [ENUM-REF-CANDIDATE: SAP|ORMS|WMS|EDI|E-COMMERCE|POS|SUPPLIER|MARKETPLACE|LEGACY|OTHER — 10 candidates stripped; promote to reference product]',
    `external_unit_of_measure` STRING COMMENT 'The unit of measure used by the external system for this item (e.g., EACH, CASE, PALLET, KG, LB). Used in conjunction with conversion factor for accurate quantity translation.',
    `internal_unit_of_measure` STRING COMMENT 'The unit of measure used internally by the retailer for this item. Provides context for the conversion factor calculation.',
    `is_primary_reference` BOOLEAN COMMENT 'Indicates whether this is the primary or preferred cross reference for the given external system. True means this is the authoritative mapping when multiple mappings exist for the same system.',
    `last_modified_by_user` STRING COMMENT 'The user ID or name of the person or system process that most recently modified this cross reference record. Provides accountability for changes.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this cross reference record was most recently updated. Used for change tracking and audit purposes.',
    `last_used_date` DATE COMMENT 'The most recent date this cross reference was used in a transaction or system integration. Helps identify obsolete mappings that can be archived.',
    `mapping_confidence_score` DECIMAL(18,2) COMMENT 'A score from 0 to 100 indicating the confidence level in the accuracy of this cross reference mapping. Higher scores indicate greater certainty. Used for automated mappings that may require validation.',
    `mapping_source` STRING COMMENT 'Indicates how this cross reference mapping was created. Values include manual entry, EDI transaction, API integration, file import, system migration, supplier catalog load, or MDM system synchronization. [ENUM-REF-CANDIDATE: MANUAL|EDI|API|FILE_IMPORT|SYSTEM_MIGRATION|SUPPLIER_CATALOG|MDM — 7 candidates stripped; promote to reference product]',
    `notes` STRING COMMENT 'Free-text notes providing additional context about this cross reference mapping. May include special handling instructions, known issues, or historical context.',
    `trading_partner_name` STRING COMMENT 'Name of the trading partner organization associated with this cross reference. Provides human-readable context for the trading partner.',
    `upc_ean_gtin` STRING COMMENT 'The standard barcode identifier (UPC, EAN, or GTIN) associated with this cross reference. Used for point-of-sale scanning and global product identification.',
    `usage_count` BIGINT COMMENT 'The total number of times this cross reference has been used in transactions or system integrations. Indicates the importance and activity level of the mapping.',
    `validation_date` DATE COMMENT 'The date when this cross reference mapping was last validated for accuracy. Used to track data quality assurance activities.',
    `validation_status` STRING COMMENT 'Indicates whether this cross reference mapping has been validated for accuracy. Validated means confirmed correct, unvalidated means not yet checked, failed means validation found errors, pending review means awaiting manual verification.. Valid values are `VALIDATED|UNVALIDATED|FAILED|PENDING_REVIEW`',
    CONSTRAINT pk_item_cross_reference PRIMARY KEY(`item_cross_reference_id`)
) COMMENT 'Maps internal SKU identifiers to external and legacy system identifiers across trading partners and operational systems. Captures internal SKU reference, external system name (SAP, ORMS, WMS, supplier EDI, e-commerce platform), external item number, cross-reference type (supplier part number, legacy item number, marketplace ASIN, retailer-specific UPC), and effective dates. Supports system integration, EDI transactions, and multi-system reconciliation.';

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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`category_campaign_plan` (
    `category_campaign_plan_id` BIGINT COMMENT 'Unique identifier for this category-campaign plan record. Primary key.',
    `associate_id` BIGINT COMMENT 'Identifier of the employee (typically category manager or marketing director) who approved this category inclusion and budget allocation.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to the marketing campaign that includes this category in its execution plan.',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to the merchandise hierarchy node (category, subcategory, or department) included in this campaign plan.',
    `actual_revenue_amount` DECIMAL(18,2) COMMENT 'Actual revenue generated by this category during the campaign period. Used to calculate campaign effectiveness and ROI.',
    `actual_spend_amount` DECIMAL(18,2) COMMENT 'Actual expenditure incurred for this category within this campaign. Populated during and after campaign execution for ROI analysis.',
    `actual_units_sold` BIGINT COMMENT 'Actual number of units sold for this category during the campaign period. Compared against target_units_goal for performance measurement.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this category-campaign plan was approved for execution.',
    `budget_allocated_amount` DECIMAL(18,2) COMMENT 'Portion of the total campaign budget allocated specifically to this category. Used to track spending and ROI at the category level within the campaign.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this category-campaign plan record was first created in the system.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this category-campaign plan record.',
    `media_weight_percent` DECIMAL(18,2) COMMENT 'Percentage of campaign media impressions, creative assets, or channel mix allocated to featuring this category. Indicates relative prominence in campaign messaging.',
    `performance_priority_rank` STRING COMMENT 'Relative priority ranking of this category within the campaign (1 = highest priority). Used to guide resource allocation and performance monitoring focus.',
    `plan_status` STRING COMMENT 'Lifecycle status of this category-campaign plan. Tracks approval workflow and execution state.',
    `promotional_depth_percent` DECIMAL(18,2) COMMENT 'Average discount percentage or promotional intensity planned for this category within this campaign. Expressed as percentage off regular price.',
    `target_revenue_goal` DECIMAL(18,2) COMMENT 'Revenue target set for this specific category within this campaign. Aggregates up to the campaign-level revenue goal.',
    `target_units_goal` BIGINT COMMENT 'Target number of units (SKUs) expected to sell for this category during the campaign period. Used for inventory planning and performance measurement.',
    CONSTRAINT pk_category_campaign_plan PRIMARY KEY(`category_campaign_plan_id`)
) COMMENT 'This association product represents the tactical marketing plan linking specific merchandise categories to marketing campaigns. It captures budget allocation, revenue targets, promotional depth, and media investment for each category-campaign pairing. Each record represents a deliberate business decision to include a specific category in a campaign with its own performance goals and resource allocation. Managed by category managers and campaign managers collaboratively during campaign planning cycles.. Existence Justification: In retail operations, marketing campaigns routinely target multiple merchandise categories simultaneously (e.g., back-to-school campaigns include apparel, electronics, and school supplies), and individual categories participate in multiple concurrent campaigns (seasonal promotions, brand campaigns, clearance events). The business actively manages category-campaign plans as operational entities with specific budget allocations, revenue targets, promotional depths, and media weights for each category-campaign pairing. These plans are created during campaign planning cycles, approved by category and marketing managers, and tracked for performance measurement.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`assortment` (
    `assortment_id` BIGINT COMMENT 'Unique identifier for this SKU-to-node assortment assignment record. Primary key.',
    `fulfillment_node_id` BIGINT COMMENT 'Foreign key linking to the fulfillment node master record. Identifies which location is authorized to stock this SKU.',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`product`.`category_kpi_target` (
    `category_kpi_target_id` BIGINT COMMENT 'Unique identifier for this category-KPI target configuration record. Primary key.',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to the merchandise category or hierarchy node for which this KPI target is configured',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to the KPI definition being tracked for this category',
    `alert_threshold` DECIMAL(18,2) COMMENT 'The threshold value at which alerts should be triggered for this category-KPI combination. When actual performance crosses this threshold, notifications are sent to responsible_role. Example: Alert when shrink exceeds 2.5% for Electronics.',
    `configuration_notes` STRING COMMENT 'Free-text notes explaining the rationale for this specific target configuration, special business context, or seasonal adjustments. Example: Holiday season target increased by 15% based on 3-year average lift.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this category-KPI target configuration was first created in the system. Supports audit trail and governance.',
    `effective_end_date` DATE COMMENT 'Date when this category-KPI target configuration expires or is replaced. Null for currently active configurations. Supports temporal tracking of performance targets.',
    `effective_start_date` DATE COMMENT 'Date when this category-KPI target configuration becomes active. Supports historical tracking of target changes over time (e.g., Q1 targets vs Q4 holiday targets).',
    `is_active` BOOLEAN COMMENT 'Boolean flag indicating whether this category-KPI configuration is currently active and in use for performance reporting. Inactive configurations are retained for historical analysis.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this configuration was last updated. Supports change tracking and audit requirements.',
    `measurement_frequency` STRING COMMENT 'How often this KPI is calculated and reported for this specific category. May differ from the enterprise-level reporting_frequency in kpi_definition based on category volatility and business needs. High-velocity categories may require daily tracking while stable categories use weekly.',
    `responsible_role` STRING COMMENT 'The business role or job function responsible for monitoring and acting on this KPI for this category. Examples: Category Manager, Merchandise Planner, Store Operations Director. May differ from the category_manager_name or planner_name in item_hierarchy as KPI ownership can be specialized.',
    `target_value` DECIMAL(18,2) COMMENT 'The specific target value for this KPI at this category level. Overrides the enterprise-level target_threshold_value from kpi_definition for this specific category. Example: Electronics department may have a 35% gross margin target while Grocery has 22%.',
    CONSTRAINT pk_category_kpi_target PRIMARY KEY(`category_kpi_target_id`)
) COMMENT 'This association product represents the performance measurement configuration between item_hierarchy categories and kpi_definition metrics. It captures category-specific KPI targets, thresholds, measurement frequencies, and ownership assignments that exist only in the context of a specific category-KPI pairing. Each record links one merchandise category to one KPI definition with the specific performance targets and alert rules configured for that category.. Existence Justification: In retail performance management, merchandise categories track multiple KPIs (sales, margin, inventory turns, shrink, comp store sales, etc.) and each KPI is measured across multiple categories with category-specific targets and thresholds. Category managers actively configure and manage these category-KPI pairings with specific target values, alert thresholds, measurement frequencies, and role assignments that vary by category characteristics (velocity, margin profile, seasonality). This is an operational configuration that the business actively maintains, not an analytical correlation.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_product_brand_id` FOREIGN KEY (`product_brand_id`) REFERENCES `vibe_retail_v1`.`product`.`product_brand`(`product_brand_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ADD CONSTRAINT `fk_product_item_hierarchy_parent_hierarchy_node_item_hierarchy_id` FOREIGN KEY (`parent_hierarchy_node_item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ADD CONSTRAINT `fk_product_product_attribute_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ADD CONSTRAINT `fk_product_product_brand_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ADD CONSTRAINT `fk_product_item_variant_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ADD CONSTRAINT `fk_product_item_variant_target_item_sku_id` FOREIGN KEY (`target_item_sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`image` ADD CONSTRAINT `fk_product_image_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ADD CONSTRAINT `fk_product_item_lifecycle_event_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ADD CONSTRAINT `fk_product_product_compliance_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ADD CONSTRAINT `fk_product_recall_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ADD CONSTRAINT `fk_product_item_bundle_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ADD CONSTRAINT `fk_product_gtin_registry_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ADD CONSTRAINT `fk_product_item_nutritional_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ADD CONSTRAINT `fk_product_item_cross_reference_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ADD CONSTRAINT `fk_product_item_cross_reference_superseded_by_reference_item_cross_reference_id` FOREIGN KEY (`superseded_by_reference_item_cross_reference_id`) REFERENCES `vibe_retail_v1`.`product`.`item_cross_reference`(`item_cross_reference_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`uom` ADD CONSTRAINT `fk_product_uom_base_uom_id` FOREIGN KEY (`base_uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`category_campaign_plan` ADD CONSTRAINT `fk_product_category_campaign_plan_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ADD CONSTRAINT `fk_product_assortment_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` ADD CONSTRAINT `fk_product_category_kpi_target_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`product` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_retail_v1`.`product` SET TAGS ('dbx_domain' = 'product');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` SET TAGS ('dbx_subdomain' = 'item_master');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) ID');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ALTER COLUMN `marketing_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Brand Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` SET TAGS ('dbx_subdomain' = 'item_master');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `parent_hierarchy_node_item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Hierarchy Node ID');
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_internal' = 'true');
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
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` SET TAGS ('dbx_subdomain' = 'item_master');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `product_attribute_id` SET TAGS ('dbx_business_glossary_term' = 'Product Attribute Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Product Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `attribute_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_approval|deprecated|archived');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `conversion_factor` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM) Conversion Factor');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `data_type` SET TAGS ('dbx_value_regex' = 'string|numeric|boolean|date|timestamp|decimal');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `display_order` SET TAGS ('dbx_business_glossary_term' = 'Display Order Sequence');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `is_certified` SET TAGS ('dbx_business_glossary_term' = 'Is Certified Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `is_comparable` SET TAGS ('dbx_business_glossary_term' = 'Is Comparable Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `is_regulatory_required` SET TAGS ('dbx_business_glossary_term' = 'Is Regulatory Required Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `is_required` SET TAGS ('dbx_business_glossary_term' = 'Is Required Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `is_searchable` SET TAGS ('dbx_business_glossary_term' = 'Is Searchable Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `locale` SET TAGS ('dbx_business_glossary_term' = 'Locale Code');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `locale` SET TAGS ('dbx_value_regex' = '^[a-z]{2}_[A-Z]{2}$');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Attribute Notes');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_retail_v1`.`product`.`product_attribute` ALTER COLUMN `validation_rule` SET TAGS ('dbx_business_glossary_term' = 'Attribute Validation Rule');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` SET TAGS ('dbx_subdomain' = 'item_master');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `product_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `average_margin_percent` SET TAGS ('dbx_business_glossary_term' = 'Average Margin Percentage');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `average_margin_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `brand_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `brand_status` SET TAGS ('dbx_value_regex' = 'active|inactive|discontinued|pending_approval');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `brand_tier` SET TAGS ('dbx_value_regex' = 'premium|standard|value|economy');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `brand_type` SET TAGS ('dbx_value_regex' = 'national|private_label|exclusive|licensed');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `country_of_origin_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `discontinuation_date` SET TAGS ('dbx_business_glossary_term' = 'Brand Discontinuation Date');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `is_exclusive` SET TAGS ('dbx_business_glossary_term' = 'Is Exclusive Brand Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `is_licensed` SET TAGS ('dbx_business_glossary_term' = 'Is Licensed Brand Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `is_private_label` SET TAGS ('dbx_business_glossary_term' = 'Is Private Label Brand Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `launch_date` SET TAGS ('dbx_business_glossary_term' = 'Brand Launch Date');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time in Days');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `logo_asset_url` SET TAGS ('dbx_business_glossary_term' = 'Brand Logo Asset Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `owner_country_code` SET TAGS ('dbx_business_glossary_term' = 'Brand Owner Country Code');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `owner_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `owner_name` SET TAGS ('dbx_business_glossary_term' = 'Brand Owner Name');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `portfolio_group` SET TAGS ('dbx_business_glossary_term' = 'Brand Portfolio Group');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `quality_rating` SET TAGS ('dbx_business_glossary_term' = 'Brand Quality Rating');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `return_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Return Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'Brand Website Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` SET TAGS ('dbx_subdomain' = 'item_master');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `item_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Item Variant Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User Identifier (ID)');
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
ALTER TABLE `vibe_retail_v1`.`product`.`image` SET TAGS ('dbx_subdomain' = 'content_assets');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `image_id` SET TAGS ('dbx_business_glossary_term' = 'Product Image ID');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Uploaded By Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`image` ALTER COLUMN `alt_text` SET TAGS ('dbx_business_glossary_term' = 'Alternative Text (Alt Text)');
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
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` SET TAGS ('dbx_subdomain' = 'compliance_safety');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approver User ID');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `associate_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `buyer_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `primary_item_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Triggered By User ID');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `primary_item_associate_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|auto_approved|not_required');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `event_type` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Event Type');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `new_status` SET TAGS ('dbx_business_glossary_term' = 'New Lifecycle Status');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `prior_status` SET TAGS ('dbx_business_glossary_term' = 'Prior Lifecycle Status');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `reason_code` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Event Reason Code');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `reason_description` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Event Reason Description');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `requestor_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `source_system_event_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Event ID');
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ALTER COLUMN `workflow_stage` SET TAGS ('dbx_value_regex' = 'vendor_submission|buyer_review|data_entry|approval_pending|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` SET TAGS ('dbx_subdomain' = 'compliance_safety');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Carrier Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Officer Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Product ID');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending_review|expired|suspended|recalled');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `fda_food_facility_registration` SET TAGS ('dbx_business_glossary_term' = 'Food and Drug Administration (FDA) Food Facility Registration');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `hazmat_classification` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Classification');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Compliance Notes');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `prop_65_chemical_list` SET TAGS ('dbx_business_glossary_term' = 'California Proposition 65 (Prop 65) Chemical List');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `prop_65_warning_required` SET TAGS ('dbx_business_glossary_term' = 'California Proposition 65 (Prop 65) Warning Required');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `recall_severity_level` SET TAGS ('dbx_value_regex' = 'class_1|class_2|class_3');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `recall_status` SET TAGS ('dbx_value_regex' = 'no_recall|active_recall|recall_completed|recall_pending');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `responsible_party_contact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ALTER COLUMN `responsible_party_contact` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` SET TAGS ('dbx_subdomain' = 'compliance_safety');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `recall_id` SET TAGS ('dbx_business_glossary_term' = 'Product Recall ID');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Recall Coordinator Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
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
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` SET TAGS ('dbx_subdomain' = 'item_master');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `item_bundle_id` SET TAGS ('dbx_business_glossary_term' = 'Item Bundle Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Bundle Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Associate Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` SET TAGS ('dbx_subdomain' = 'item_master');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `gtin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Global Trade Item Number (GTIN) Registry ID');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Data Steward Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `net_content_unit` SET TAGS ('dbx_business_glossary_term' = 'Net Content Unit of Measure');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `package_dimension_unit` SET TAGS ('dbx_business_glossary_term' = 'Package Dimension Unit of Measure');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `package_dimension_unit` SET TAGS ('dbx_value_regex' = 'mm|cm|m|in|ft');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `packaging_level` SET TAGS ('dbx_value_regex' = 'unit|inner_pack|case|pallet|display');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `parent_gtin` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$|^[0-9]{12}$|^[0-9]{13}$|^[0-9]{14}$');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `registration_status` SET TAGS ('dbx_business_glossary_term' = 'GTIN Registration Status');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `registration_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|suspended|retired');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `regulatory_compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending_review|exempt');
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ALTER COLUMN `replacement_gtin` SET TAGS ('dbx_value_regex' = '^[0-9]{8}$|^[0-9]{12}$|^[0-9]{13}$|^[0-9]{14}$');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` SET TAGS ('dbx_subdomain' = 'content_assets');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) ID');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Validated By Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `added_sugars_g` SET TAGS ('dbx_business_glossary_term' = 'Added Sugars (Grams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `calcium_mg` SET TAGS ('dbx_business_glossary_term' = 'Calcium (Milligrams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `cholesterol_mg` SET TAGS ('dbx_business_glossary_term' = 'Cholesterol (Milligrams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `contains_eggs` SET TAGS ('dbx_business_glossary_term' = 'Contains Eggs Allergen');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `contains_fish` SET TAGS ('dbx_business_glossary_term' = 'Contains Fish Allergen');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `contains_milk` SET TAGS ('dbx_business_glossary_term' = 'Contains Milk Allergen');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `contains_peanuts` SET TAGS ('dbx_business_glossary_term' = 'Contains Peanuts Allergen');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `contains_shellfish` SET TAGS ('dbx_business_glossary_term' = 'Contains Shellfish Allergen');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `contains_soybeans` SET TAGS ('dbx_business_glossary_term' = 'Contains Soybeans Allergen');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `contains_tree_nuts` SET TAGS ('dbx_business_glossary_term' = 'Contains Tree Nuts Allergen');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `contains_wheat` SET TAGS ('dbx_business_glossary_term' = 'Contains Wheat Allergen');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `dietary_fiber_g` SET TAGS ('dbx_business_glossary_term' = 'Dietary Fiber (Grams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `iron_mg` SET TAGS ('dbx_business_glossary_term' = 'Iron (Milligrams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `is_gluten_free` SET TAGS ('dbx_business_glossary_term' = 'Gluten-Free Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `is_halal_certified` SET TAGS ('dbx_business_glossary_term' = 'Halal Certification Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `is_kosher_certified` SET TAGS ('dbx_business_glossary_term' = 'Kosher Certification Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `is_non_gmo_verified` SET TAGS ('dbx_business_glossary_term' = 'Non-GMO (Genetically Modified Organism) Verification Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `is_organic_certified` SET TAGS ('dbx_business_glossary_term' = 'Organic Certification Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `is_vegan` SET TAGS ('dbx_business_glossary_term' = 'Vegan Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `is_vegetarian` SET TAGS ('dbx_business_glossary_term' = 'Vegetarian Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `monounsaturated_fat_g` SET TAGS ('dbx_business_glossary_term' = 'Monounsaturated Fat (Grams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `nutritional_data_source` SET TAGS ('dbx_value_regex' = 'laboratory_analysis|usda_database|supplier_provided|calculated|third_party_database');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `polyunsaturated_fat_g` SET TAGS ('dbx_business_glossary_term' = 'Polyunsaturated Fat (Grams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `potassium_mg` SET TAGS ('dbx_business_glossary_term' = 'Potassium (Milligrams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `protein_g` SET TAGS ('dbx_business_glossary_term' = 'Protein (Grams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `saturated_fat_g` SET TAGS ('dbx_business_glossary_term' = 'Saturated Fat (Grams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `serving_size_unit` SET TAGS ('dbx_business_glossary_term' = 'Serving Size Unit of Measure');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `sodium_mg` SET TAGS ('dbx_business_glossary_term' = 'Sodium (Milligrams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `total_carbohydrate_g` SET TAGS ('dbx_business_glossary_term' = 'Total Carbohydrate (Grams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `total_fat_g` SET TAGS ('dbx_business_glossary_term' = 'Total Fat (Grams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `total_sugars_g` SET TAGS ('dbx_business_glossary_term' = 'Total Sugars (Grams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `trans_fat_g` SET TAGS ('dbx_business_glossary_term' = 'Trans Fat (Grams)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ALTER COLUMN `vitamin_d_mcg` SET TAGS ('dbx_business_glossary_term' = 'Vitamin D (Micrograms)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` SET TAGS ('dbx_subdomain' = 'item_master');
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Validated By User');
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ALTER COLUMN `superseded_by_reference_item_cross_reference_id` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Reference ID');
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Trading Partner ID');
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ALTER COLUMN `conversion_factor` SET TAGS ('dbx_business_glossary_term' = 'Unit Conversion Factor');
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ALTER COLUMN `cross_reference_status` SET TAGS ('dbx_value_regex' = 'ACTIVE|INACTIVE|PENDING|DEPRECATED|SUPERSEDED');
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ALTER COLUMN `cross_reference_type` SET TAGS ('dbx_value_regex' = 'SUPPLIER_PART_NUMBER|LEGACY_ITEM_NUMBER|MARKETPLACE_ASIN|VENDOR_SKU|DISTRIBUTOR_CODE|MANUFACTURER_CODE');
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ALTER COLUMN `is_primary_reference` SET TAGS ('dbx_business_glossary_term' = 'Is Primary Reference Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Cross Reference Notes');
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ALTER COLUMN `upc_ean_gtin` SET TAGS ('dbx_business_glossary_term' = 'Universal Product Code (UPC) / European Article Number (EAN) / Global Trade Item Number (GTIN)');
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ALTER COLUMN `validation_status` SET TAGS ('dbx_value_regex' = 'VALIDATED|UNVALIDATED|FAILED|PENDING_REVIEW');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`product`.`uom` SET TAGS ('dbx_subdomain' = 'item_master');
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
ALTER TABLE `vibe_retail_v1`.`product`.`category_campaign_plan` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`product`.`category_campaign_plan` SET TAGS ('dbx_subdomain' = 'category_planning');
ALTER TABLE `vibe_retail_v1`.`product`.`category_campaign_plan` SET TAGS ('dbx_association_edges' = 'product.item_hierarchy,marketing.campaign');
ALTER TABLE `vibe_retail_v1`.`product`.`category_campaign_plan` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Category Campaign Plan - Campaign Id');
ALTER TABLE `vibe_retail_v1`.`product`.`category_campaign_plan` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Category Campaign Plan - Item Hierarchy Id');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` SET TAGS ('dbx_subdomain' = 'category_planning');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` SET TAGS ('dbx_association_edges' = 'product.sku,fulfillment.node');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `assortment_id` SET TAGS ('dbx_business_glossary_term' = 'Assortment Assignment Identifier');
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Assortment - Fulfillment Node Id');
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
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` SET TAGS ('dbx_subdomain' = 'category_planning');
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` SET TAGS ('dbx_association_edges' = 'product.item_hierarchy,analytics.kpi_definition');
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` ALTER COLUMN `category_kpi_target_id` SET TAGS ('dbx_business_glossary_term' = 'Category KPI Target Identifier');
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Category Kpi Target - Item Hierarchy Id');
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Category Kpi Target - Kpi Definition Id');
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` ALTER COLUMN `alert_threshold` SET TAGS ('dbx_business_glossary_term' = 'Alert Threshold Value');
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Configuration Effective End Date');
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Configuration Effective Start Date');
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Active Configuration Flag');
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` ALTER COLUMN `measurement_frequency` SET TAGS ('dbx_business_glossary_term' = 'Category Measurement Frequency');
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` ALTER COLUMN `responsible_role` SET TAGS ('dbx_business_glossary_term' = 'Responsible Business Role');
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` ALTER COLUMN `target_value` SET TAGS ('dbx_business_glossary_term' = 'Category-Specific Target Value');
