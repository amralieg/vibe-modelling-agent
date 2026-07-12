-- Schema for Domain: merchandising | Business: Retail | Version: v2_mvm
-- Generated on: 2026-07-12 15:26:00

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`merchandising` COMMENT 'Manages strategic merchandise planning, assortment management, category management, OTB (Open to Buy) budgets, buying decisions, vendor negotiations, and seasonal planning. Tracks sell-through rates, inventory turns, and assortment performance by category, department, and store cluster. Drives assortment depth and breadth decisions and GMROI targets. Integrates with Oracle Retail Merchandising System (ORMS).';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` (
    `merch_plan_id` BIGINT COMMENT 'Unique identifier for the merchandise financial plan record. Primary key.',
    `buyer_id` BIGINT COMMENT 'Reference to the merchandise buyer responsible for executing this plan and making purchasing decisions.',
    `cluster_id` BIGINT COMMENT 'Reference to the store cluster or group this merchandise plan applies to, enabling differentiated assortment planning by store type.',
    `department_id` BIGINT COMMENT 'Reference to the retail department this merchandise plan covers.',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.format. Business justification: Merchandise plans track performance against specific KPIs (GMROI, sell-through, inventory turns). Planning systems reference KPI definitions for target setting, variance calculation, and performance d',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Merchandise financial plans are built at hierarchy node level (department/category/class). Critical for OTB budget management, GMROI tracking, inventory turn targets, and monthly financial planning cy',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.location. Business justification: Merchandise plans allocate OTB budgets to cost centers for financial tracking, variance analysis, and budget vs actual reporting. Essential for monthly financial close and planning cost allocation.',
    `category_id` BIGINT COMMENT 'Reference to the product category this merchandise plan covers.',
    `price_list_id` BIGINT COMMENT 'Foreign key linking to pricing.price_list. Business justification: Merchandise plans are built against a specific price list (planned sales at retail require a price list reference). Linking enables planned retail value calculations and price list change impact on me',
    `price_zone_id` BIGINT COMMENT 'Foreign key linking to pricing.price_strategy. Business justification: Merchandise plans incorporate pricing strategy assumptions for revenue and margin planning. Planned AUR, markdown budget, and margin targets depend on the pricing strategy (EDLP yields different markd',
    `region_id` BIGINT COMMENT 'Foreign key linking to store.region. Business justification: Regional merchandise planning is a fundamental retail process — regional sales targets, OTB allocation, and margin reporting all require merch_plan scoped to a region. merch_plan has cluster, location',
    `season_id` BIGINT COMMENT 'FK to merchandising.season',
    `approval_date` DATE COMMENT 'Date when the merchandise plan was formally approved for execution.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this merchandise plan record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this plan (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `gmroi_target` DECIMAL(18,2) COMMENT 'Target GMROI ratio representing the gross margin dollars returned for every dollar of average inventory investment.',
    `inventory_turn_target` DECIMAL(18,2) COMMENT 'Target number of times inventory is expected to turn (sell through and be replenished) during the plan period.',
    `is_active` BOOLEAN COMMENT 'Boolean flag indicating whether this merchandise plan is currently active and in use for buying decisions.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this merchandise plan record was last updated.',
    `otb_budget_amount` DECIMAL(18,2) COMMENT 'Total Open to Buy budget allocated for purchasing inventory within this plan, representing the financial commitment available for buying decisions.',
    `plan_code` STRING COMMENT 'Business identifier for the merchandise plan, used for external reference and reporting.. Valid values are `^[A-Z0-9]{6,20}$`',
    `plan_end_date` DATE COMMENT 'Effective end date of the merchandise plan period.',
    `plan_name` STRING COMMENT 'Descriptive name of the merchandise plan (e.g., Spring 2024 Apparel Plan, Holiday Electronics Plan).',
    `plan_notes` STRING COMMENT 'Free-text notes and commentary about the merchandise plan, including strategic rationale, market conditions, and special considerations.',
    `plan_start_date` DATE COMMENT 'Effective start date of the merchandise plan period.',
    `plan_status` STRING COMMENT 'Current lifecycle status of the merchandise plan indicating its approval and execution state.. Valid values are `draft|submitted|approved|active|closed|cancelled`',
    `plan_type` STRING COMMENT 'Classification of the merchandise plan by planning horizon and purpose.. Valid values are `seasonal|annual|promotional|ad_hoc`',
    `planned_beginning_inventory_amount` DECIMAL(18,2) COMMENT 'Planned retail value of inventory at the start of the plan period.',
    `planned_cost_amount` DECIMAL(18,2) COMMENT 'Total planned cost of goods to be purchased under this merchandise plan.',
    `planned_ending_inventory_amount` DECIMAL(18,2) COMMENT 'Planned retail value of inventory at the end of the plan period.',
    `planned_margin_amount` DECIMAL(18,2) COMMENT 'Expected gross margin (planned sales minus planned cost) to be achieved during the plan period.',
    `planned_margin_percent` DECIMAL(18,2) COMMENT 'Target gross margin percentage (planned margin divided by planned sales) for the merchandise plan.',
    `planned_markdown_amount` DECIMAL(18,2) COMMENT 'Anticipated markdown dollars to be taken during the plan period for price reductions and promotions.',
    `planned_markdown_percent` DECIMAL(18,2) COMMENT 'Target markdown rate as a percentage of planned sales.',
    `planned_receipt_amount` DECIMAL(18,2) COMMENT 'Total retail value of inventory receipts planned to arrive during the plan period.',
    `planned_sales_amount` DECIMAL(18,2) COMMENT 'Forecasted retail sales revenue expected to be generated during the plan period.',
    `planned_units` BIGINT COMMENT 'Total number of inventory units planned to be purchased and sold during the plan period.',
    `prior_year_margin_percent` DECIMAL(18,2) COMMENT 'Actual gross margin percentage achieved during the comparable period in the prior year.',
    `prior_year_sales_amount` DECIMAL(18,2) COMMENT 'Actual sales amount from the comparable period in the prior year, used for year-over-year comparison.',
    `prior_year_units` BIGINT COMMENT 'Actual units sold during the comparable period in the prior year.',
    `sell_through_target_percent` DECIMAL(18,2) COMMENT 'Target percentage of inventory expected to be sold during the plan period.',
    `source_system_code` STRING COMMENT 'Code identifying the operational system of record that originated this merchandise plan (e.g., ORMS, SAP_MM).. Valid values are `^[A-Z_]{2,20}$`',
    CONSTRAINT pk_merch_plan PRIMARY KEY(`merch_plan_id`)
) COMMENT 'Master merchandise financial plan capturing OTB (Open to Buy) budgets, planned sales, planned inventory, planned margin, GMROI targets, and seasonal buying commitments by department, category, and season. Seasonal commitment detail includes planned units, planned cost, planned retail value, receipt flow by month, and comparison to prior year seasonal performance — serving as the single source of truth for aggregate seasonal buying decisions before individual buying orders are raised. The authoritative financial blueprint for buying decisions, assortment investments, and seasonal commitment tracking. Integrates with the retail merchandising system Merchandising System (ORMS) merchandise planning module.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` (
    `assortment_plan_id` BIGINT COMMENT 'Unique identifier for the assortment plan. Primary key for this entity.',
    `buyer_id` BIGINT COMMENT 'Reference to the merchandise buyer responsible for developing and executing this assortment plan. Used for accountability and performance tracking.',
    `cluster_id` BIGINT COMMENT 'Reference to the store cluster definition that this assortment plan targets. Store clusters group stores with similar characteristics (sales volume, demographics, climate, format) for localized assortment strategies.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Assortment planning activities and associated costs (labor, systems, travel) are allocated to cost centers for expense tracking and budget management. Required for planning department cost control.',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.store_format. Business justification: Assortment plans are format-specific; small-format stores receive different SKU mixes than hypermarkets. Real business process: merchandising teams create format-tailored assortment plans based on spa',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Assortment plans target specific merchandise hierarchy nodes for breadth/depth planning. Essential for OTB budget allocation, SKU rationalization, and assortment performance tracking against category',
    `merch_plan_id` BIGINT COMMENT 'Foreign key linking to merchandising.merch_plan. Business justification: An assortment plan (SKU breadth/depth decisions) is governed by and subordinate to a merchandise financial plan (OTB budgets, planned sales). Adding merch_plan_id to assortment_plan establishes the pa',
    `price_list_id` BIGINT COMMENT 'Foreign key linking to pricing.price_list. Business justification: Assortment plans are built against a specific price list to calculate planned retail values and AUR targets. Linking enables planned AUR calculations and price list change impact analysis on assortmen',
    `price_zone_id` BIGINT COMMENT 'Foreign key linking to pricing.price_strategy. Business justification: Assortment plans reference pricing strategies for financial planning. Planned sales and margin calculations require pricing strategy assumptions (average markdown depth, promotional frequency). Strate',
    `category_id` BIGINT COMMENT 'Reference to the merchandise category this assortment plan covers. Links to the product category hierarchy for strategic alignment.',
    `region_id` BIGINT COMMENT 'Foreign key linking to store.region. Business justification: Regional assortment planning is standard retail practice — buyers build region-specific assortments reflecting local demographics and climate. assortment_plan has cluster and location FKs but no regio',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Assortment plans are scoped to retail planning seasons. Currently has season_code (STRING) which should be normalized to season_id FK to season.season_id. This enables proper referential integrity and',
    `location_id` BIGINT COMMENT 'add column store_location_id (BIGINT) with FK to store.location.location_id - assortment plans are deployed to specific locations beyond just clusters and formats',
    `approval_date` DATE COMMENT 'Date when the assortment plan was formally approved by management, authorizing procurement and execution activities.',
    `assortment_breadth_target` STRING COMMENT 'Target number of distinct product lines or styles to be carried, representing the width of the assortment offering across the category.',
    `assortment_depth_target` STRING COMMENT 'Target number of variants (sizes, colors, styles) within each product line to achieve desired assortment depth. Balances customer choice with inventory complexity.',
    `cluster_strategy_description` STRING COMMENT 'Detailed description of the assortment strategy tailored for the store cluster, including rationale for SKU selection, depth/breadth decisions, and localization considerations.',
    `clustering_methodology` STRING COMMENT 'Methodology used to define the store cluster for this assortment plan: sales_volume (grouped by revenue tiers), demographics (customer profile similarity), climate (weather-driven assortment needs), format (store size/type), geographic (regional proximity), or hybrid (combination of multiple factors).. Valid values are `sales_volume|demographics|climate|format|geographic|hybrid`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this assortment plan record was first created in the system, following ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Used for audit trail and data lineage.',
    `effective_end_date` DATE COMMENT 'Date when the assortment plan expires and merchandise should be phased out or transitioned to clearance. Used for markdown planning and inventory liquidation strategies.',
    `effective_start_date` DATE COMMENT 'Date when the assortment plan becomes active and merchandise should be available in stores or online channels. Critical for supply chain and inventory planning.',
    `external_plan_reference` STRING COMMENT 'External reference identifier for the assortment plan in upstream or partner systems, used for cross-system reconciliation and integration.',
    `fiscal_year` STRING COMMENT 'Fiscal year for which this assortment plan is effective, used for financial planning and budget alignment.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this assortment plan record was last updated in the system, following ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Critical for change tracking and data freshness monitoring.',
    `last_review_date` DATE COMMENT 'Date when the assortment plan was last reviewed for performance and potential adjustments. Used to track ongoing plan management and optimization cycles.',
    `national_brand_sku_count` STRING COMMENT 'Number of national brand (vendor brand) SKUs included in the assortment plan. Complements private label count to show brand mix strategy.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next formal review of the assortment plan performance and strategy adjustments.',
    `notes` STRING COMMENT 'Free-text notes and comments about the assortment plan, capturing strategic rationale, special considerations, or execution guidance for buyers and planners.',
    `otb_budget_amount` DECIMAL(18,2) COMMENT 'OTB (Open to Buy) budget allocated for purchasing inventory under this assortment plan, expressed in the companys reporting currency. Controls inventory investment and ensures financial discipline in buying decisions.',
    `otb_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the OTB (Open to Buy) budget amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `plan_code` STRING COMMENT 'Business identifier code for the assortment plan, used for external reference and reporting. Typically follows a structured format combining season, category, and year indicators.. Valid values are `^[A-Z0-9]{6,20}$`',
    `plan_name` STRING COMMENT 'Descriptive name of the assortment plan for business user identification and reporting purposes.',
    `plan_status` STRING COMMENT 'Current lifecycle status of the assortment plan: draft (under development), pending_approval (submitted for review), approved (authorized but not yet active), active (currently in execution), closed (completed and archived), or cancelled (terminated before completion).. Valid values are `draft|pending_approval|approved|active|closed|cancelled`',
    `plan_type` STRING COMMENT 'Classification of the assortment plan indicating its strategic purpose: seasonal (time-bound seasonal merchandise), core (evergreen year-round assortment), promotional (event-driven limited assortment), test (pilot/experimental assortment), clearance (end-of-life inventory reduction), or new_launch (product introduction assortment).. Valid values are `seasonal|core|promotional|test|clearance|new_launch`',
    `planned_sku_count` STRING COMMENT 'Total number of distinct SKUs (Stock Keeping Units) planned to be carried under this assortment plan. Represents assortment breadth and is a key metric for space planning and inventory investment.',
    `planogram_required_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) specifying whether a planogram (POG - shelf layout diagram) is required for this assortment plan. True indicates visual merchandising and space planning are needed.',
    `private_label_mix_percent` DECIMAL(18,2) COMMENT 'Target percentage of private label SKUs within the total assortment, expressed as a percentage (0.00 to 100.00). Key metric for margin management and brand positioning strategy.',
    `private_label_sku_count` STRING COMMENT 'Number of private label (store brand) SKUs included in the assortment plan. Used to track private label penetration strategy and margin optimization.',
    `source_system_code` STRING COMMENT 'Code identifying the source system where this assortment plan was created: ORMS (the retail merchandising system Merchandising System), SAP (SAP S/4HANA Retail), MANUAL (manually created), or LEGACY (migrated from legacy system).. Valid values are `ORMS|SAP|MANUAL|LEGACY`',
    `target_gmroi` DECIMAL(18,2) COMMENT 'Target GMROI (Gross Margin Return on Investment) for the assortment plan, measuring gross margin dollars earned for every dollar of average inventory investment. Key profitability metric for assortment performance evaluation.',
    `target_inventory_turn_rate` DECIMAL(18,2) COMMENT 'Target number of times inventory should turn (sell and replenish) during the plan period. Higher turns indicate better inventory productivity and reduced carrying costs.',
    `target_sell_through_rate_percent` DECIMAL(18,2) COMMENT 'Target sell-through rate (percentage of inventory sold within the plan period) for this assortment plan, expressed as a percentage (0.00 to 100.00). Critical KPI (Key Performance Indicator) for inventory productivity and markdown risk management.',
    `version_number` STRING COMMENT 'Version number of the assortment plan, incremented with each revision. Supports change tracking and historical analysis of plan evolution.',
    CONSTRAINT pk_assortment_plan PRIMARY KEY(`assortment_plan_id`)
) COMMENT 'Strategic assortment plan defining the breadth and depth of SKUs to be carried by category, subcategory, and season. Captures planned SKU count, assortment depth targets, private label vs. national brand mix, sell-through rate targets, and store cluster definitions (cluster ID, cluster name, clustering methodology such as sales volume, demographics, climate, or format, assigned stores, and cluster-level assortment strategy). Store clusters are owned within the assortment plan as the mechanism for localized assortment decisions. Drives buying decisions and planogram development.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`category` (
    `category_id` BIGINT COMMENT 'Unique identifier for the merchandise category. Primary key.',
    `brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Category management tracks preferred brand lists, brand-level GMROI and sell-through targets, and private label penetration goals (category has private_label_penetration_target field). Categories ofte',
    `buyer_id` BIGINT COMMENT 'Reference to the buyer responsible for procurement and vendor negotiations for this category. Typically assigned at department or category level.',
    `parent_category_id` BIGINT COMMENT 'Reference to the parent node in the merchandise hierarchy. Null for top-level departments.',
    `actual_gmroi` DECIMAL(18,2) COMMENT 'Most recent actual GMROI (Gross Margin Return on Investment) achieved by the category.',
    `actual_sell_through_rate` DECIMAL(18,2) COMMENT 'Most recent actual sell-through rate achieved by the category. Expressed as percentage (e.g., 82.30 = 82.3%).',
    `assortment_breadth_target` STRING COMMENT 'Target number of subcategories or product families within the category to achieve desired range of offerings.',
    `assortment_depth_target` STRING COMMENT 'Target number of SKUs (Stock Keeping Units) or product variants within the category to achieve desired variety within each subcategory.',
    `assortment_gap_findings` STRING COMMENT 'Documented gaps in the current assortment identified during category review (e.g., missing price points, underrepresented styles, competitor advantages).',
    `category_role` STRING COMMENT 'Strategic role of the category in the assortment (destination=traffic driver, routine=frequent purchase, convenience=fill-in, seasonal=time-bound, occasional=infrequent).. Valid values are `destination|routine|convenience|seasonal|occasional`',
    `category_status` STRING COMMENT 'Current lifecycle status of the category in the merchandise hierarchy.. Valid values are `active|inactive|pending|discontinued`',
    `category_code` STRING COMMENT 'Business identifier code for the category used across systems and reporting. Unique within hierarchy level.. Valid values are `^[A-Z0-9]{2,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this category record was first created in the system.',
    `category_description` STRING COMMENT 'Detailed description of the category scope, assortment strategy, and business purpose.',
    `division` STRING COMMENT 'Top-level business division (e.g., Hardlines, Softlines, Grocery, Electronics). Applicable to department-level nodes.',
    `effective_end_date` DATE COMMENT 'Date when this category configuration was retired or superseded. Null for currently active categories.',
    `effective_start_date` DATE COMMENT 'Date when this category configuration became active in the merchandise hierarchy.',
    `hierarchy_level` STRING COMMENT 'Numeric level in the merchandise hierarchy (1=Department, 2=Category, 3=Subcategory, 4=Segment).',
    `hierarchy_path` STRING COMMENT 'Full path from root to this node (e.g., /01/01-05/01-05-03) for efficient hierarchy traversal and reporting.',
    `is_leaf_node` BOOLEAN COMMENT 'Indicates whether this category is a leaf node (lowest level) in the hierarchy with no child categories. True for segments, false for departments and categories with children.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this category record was most recently updated.',
    `last_review_date` DATE COMMENT 'Date of the most recent category performance review and strategic assessment.',
    `merchandise_type` STRING COMMENT 'High-level merchandise classification for strategic planning and reporting. [ENUM-REF-CANDIDATE: hardlines|softlines|grocery|electronics|home|health_beauty|seasonal|services — 8 candidates stripped; promote to reference product]',
    `modified_by_user` STRING COMMENT 'User ID or name of the person who last modified this category record.',
    `category_name` STRING COMMENT 'Human-readable name of the merchandise category (e.g., Womens Apparel, Consumer Electronics, Fresh Produce).',
    `next_review_date` DATE COMMENT 'Scheduled date for the next category performance review and strategic planning session.',
    `otb_budget_amount` DECIMAL(18,2) COMMENT 'Current OTB (Open to Buy) budget allocated to the category for merchandise procurement, expressed in the reporting currency.',
    `otb_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the OTB budget amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `peak_season` STRING COMMENT 'Primary selling season for seasonal categories (e.g., Q4 Holiday, Spring, Back-to-School, Summer).',
    `performance_variance_notes` STRING COMMENT 'Narrative explanation of performance gaps between actual and target metrics, including root cause analysis and contributing factors.',
    `private_label_penetration_target` DECIMAL(18,2) COMMENT 'Target percentage of category sales from private label (store brand) products. Expressed as percentage (e.g., 25.00 = 25%).',
    `recommended_actions` STRING COMMENT 'Strategic and tactical recommendations from the most recent category review (e.g., expand assortment, rationalize SKUs, adjust pricing, increase promotions).',
    `review_frequency` STRING COMMENT 'Cadence for periodic category performance reviews and strategic adjustments.. Valid values are `weekly|monthly|quarterly|semi_annual|annual`',
    `seasonality_flag` BOOLEAN COMMENT 'Indicates whether the category exhibits significant seasonal demand patterns requiring seasonal planning and inventory strategies.',
    `strategic_objective` STRING COMMENT 'Current strategic goal for the category (e.g., market share growth, margin expansion, assortment rationalization, private label penetration).',
    `target_gmroi` DECIMAL(18,2) COMMENT 'Target GMROI (Gross Margin Return on Investment) benchmark for the category, expressed as a ratio (e.g., 2.50 means $2.50 gross margin per dollar of average inventory investment).',
    `target_inventory_turns` DECIMAL(18,2) COMMENT 'Target number of inventory turns per year for the category (COGS divided by average inventory value).',
    `target_margin_percent` DECIMAL(18,2) COMMENT 'Target gross margin percentage for the category. Expressed as percentage (e.g., 42.50 = 42.5%).',
    `target_sell_through_rate` DECIMAL(18,2) COMMENT 'Target sell-through rate (percentage of inventory sold within a period) for the category. Expressed as percentage (e.g., 85.00 = 85%).',
    CONSTRAINT pk_category PRIMARY KEY(`category_id`)
) COMMENT 'Authoritative master of the complete merchandise hierarchy from department level through category, subcategory, and segment. Each node captures its hierarchy level, parent node, code, name, and level-specific attributes: departments carry division, merchandise type (hardlines, softlines, grocery, electronics), and assigned buyer/planner; categories carry category manager ownership, category role (destination, routine, convenience, seasonal), strategic objectives, performance benchmarks, and periodic review outcomes (sell-through vs. plan, GMROI vs. target, assortment gap findings, recommended actions). The single source of truth for all merchandise classification, financial reporting hierarchies, and organizational ownership assignments.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`buyer` (
    `buyer_id` BIGINT COMMENT 'Unique identifier for the merchandise buyer or category manager. Primary key.',
    `dc_facility_id` BIGINT COMMENT 'Human resources employee identifier linking the buyer to the workforce management system. Used for payroll, performance tracking, and organizational hierarchy.',
    `assigned_category_codes` STRING COMMENT 'Comma-separated list of category codes for which this buyer has purchasing and assortment planning responsibility. Categories are sub-groupings within departments (e.g., Mens Shirts, Laptops, Bedding).',
    `assigned_department_codes` STRING COMMENT 'Comma-separated list of department codes for which this buyer has purchasing responsibility. Departments represent high-level merchandise groupings (e.g., Apparel, Electronics, Home Goods).',
    `assortment_planning_system_access` STRING COMMENT 'Level of access the buyer has to the assortment planning and space optimization systems. Full access allows creation and modification of planograms and assortment plans.. Valid values are `full_access|read_only|no_access`',
    `buyer_status` STRING COMMENT 'Current employment and operational status of the buyer. Inactive or terminated buyers cannot approve purchase orders or modify OTB budgets.. Valid values are `active|inactive|on_leave|terminated`',
    `buyer_type` STRING COMMENT 'Classification of the buyer role indicating seniority and scope of responsibility. Determines approval authority and OTB (Open to Buy) limits.. Valid values are `merchandise_buyer|category_manager|assistant_buyer|senior_buyer|divisional_buyer`',
    `buying_authority_limit` DECIMAL(18,2) COMMENT 'Maximum dollar amount the buyer can approve for a single purchase order without requiring additional management approval. Expressed in the companys reporting currency.',
    `certification_credentials` STRING COMMENT 'Comma-separated list of professional certifications held by the buyer (e.g., Certified Professional in Supply Management, Retail Management Certificate). Used for professional development tracking.',
    `buyer_code` STRING COMMENT 'Short alphanumeric code identifying the buyer in purchase orders, vendor contracts, and merchandising reports. Often used as a business key in legacy systems.. Valid values are `^[A-Z]{2,4}[0-9]{3,5}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the buyer record was first created in the system. Used for audit trail and data lineage tracking.',
    `data_source_system` STRING COMMENT 'Identifier of the source system from which the buyer record originated (e.g., ORMS for the retail merchandising system Merchandising System, Workday for HR data). Used for data lineage and reconciliation.. Valid values are `ORMS|Workday|SAP|Manual|MDM`',
    `division_code` STRING COMMENT 'Code representing the merchandising division to which the buyer belongs (e.g., Hardlines, Softlines, Grocery). Divisions are the highest level of merchandise organization.. Valid values are `^[A-Z]{2,4}$`',
    `email_address` STRING COMMENT 'Primary corporate email address for the buyer. Used for vendor communications, purchase order approvals, and system notifications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `gmroi_target` DECIMAL(18,2) COMMENT 'Target GMROI (Gross Margin Return on Investment) ratio assigned to the buyer for their assigned categories. Measures how much gross margin is generated for every dollar of inventory investment. Expressed as a ratio (e.g., 2.50 means $2.50 of gross margin per $1.00 of inventory).',
    `hire_date` DATE COMMENT 'Date the buyer was hired into the organization. Used for tenure analysis and performance benchmarking.',
    `international_sourcing_flag` BOOLEAN COMMENT 'Indicates whether the buyer is authorized to source products from international vendors and manage cross-border procurement. True if international sourcing is within scope.',
    `inventory_turn_target` DECIMAL(18,2) COMMENT 'Target inventory turnover ratio assigned to the buyer for their assigned categories. Measures how many times inventory is sold and replaced over a period (typically annually). Higher turns indicate more efficient inventory management.',
    `language_proficiency` STRING COMMENT 'Comma-separated list of languages the buyer is proficient in, relevant for international vendor negotiations and global sourcing activities.',
    `last_modified_by_user` STRING COMMENT 'User ID or system identifier of the person or process that last modified the buyer record. Used for audit trail and accountability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the buyer record was last updated. Used for change tracking and audit compliance.',
    `last_performance_review_date` DATE COMMENT 'Date of the buyers most recent formal performance review. Used to track review cycles and identify buyers due for evaluation.',
    `markdown_percentage_limit` DECIMAL(18,2) COMMENT 'Maximum allowable markdown percentage the buyer can authorize without additional approval. Expressed as a percentage of original retail price (e.g., 30.00 means up to 30% markdown is allowed).',
    `buyer_name` STRING COMMENT 'Full legal name of the merchandise buyer or category manager.',
    `office_location_code` STRING COMMENT 'Code identifying the physical office or buying center where the buyer is based. Used for travel expense allocation and regional vendor assignments.. Valid values are `^[A-Z]{3}[0-9]{3}$`',
    `otb_budget_limit` DECIMAL(18,2) COMMENT 'Total OTB (Open to Buy) budget allocated to this buyer for the current fiscal period. Represents the maximum inventory investment the buyer can commit to across all assigned categories.',
    `phone_number` STRING COMMENT 'Primary business phone number for the buyer. Used for vendor negotiations and internal escalations.',
    `preferred_vendor_count` STRING COMMENT 'Number of preferred or strategic vendors the buyer actively manages relationships with. Used to assess vendor portfolio concentration and diversification strategy.',
    `private_label_focus_flag` BOOLEAN COMMENT 'Indicates whether the buyer has primary responsibility for private label (store brand) product development and sourcing. True if the buyer manages private label assortments.',
    `sell_through_rate_target` DECIMAL(18,2) COMMENT 'Target sell-through rate percentage assigned to the buyer for their assigned categories. Represents the percentage of inventory that should be sold within a defined period (typically a season). Expressed as a percentage (e.g., 85.00 means 85% of inventory should sell through).',
    `termination_date` DATE COMMENT 'Date the buyer left the organization or was terminated. Null for active employees. Triggers reassignment of assigned categories and vendors.',
    `vendor_negotiation_rating` STRING COMMENT 'Performance rating reflecting the buyers effectiveness in negotiating favorable commercial terms with vendors. Based on achieved cost reductions, payment terms, and markdown allowances.. Valid values are `excellent|good|average|needs_improvement|not_rated`',
    `years_of_buying_experience` STRING COMMENT 'Total number of years the individual has worked in merchandise buying roles, including experience prior to joining the current organization. Used for capability assessment and succession planning.',
    CONSTRAINT pk_buyer PRIMARY KEY(`buyer_id`)
) COMMENT 'Master record for merchandise buyers and category managers responsible for vendor negotiations, OTB management, assortment decisions, and purchase order approvals within assigned departments and categories. Captures buyer name, employee ID, assigned departments and categories, buying authority limit (dollar threshold), organizational reporting hierarchy, active/inactive status, and performance history. The accountable actor for all buying decisions, vendor commercial terms, and OTB consumption within their scope.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`season` (
    `season_id` BIGINT COMMENT 'Unique identifier for the retail planning season. Primary key.',
    `assortment_breadth_target` STRING COMMENT 'The target number of distinct product categories to be carried during this season. Represents the range of categories. Drives overall merchandising strategy and store space allocation.',
    `assortment_depth_target` STRING COMMENT 'The target number of SKUs (Stock Keeping Units) within each product category for this season. Represents the variety within categories. Drives category management and buying decisions.',
    `buy_deadline_date` DATE COMMENT 'The final date by which all purchase orders for the season must be committed to vendors. Ensures timely receipt of merchandise for season launch.',
    `clearance_exit_date` DATE COMMENT 'The target date by which all seasonal merchandise should be sold through or removed from active selling floor. Marks the end of clearance activities.',
    `season_code` STRING COMMENT 'Short alphanumeric code representing the season (e.g., SS24 for Spring/Summer 2024, FW24 for Fall/Winter 2024). Used as the business identifier across merchandising systems.. Valid values are `^[A-Z]{2}[0-9]{2}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the season record was first created in the system. Audit trail for data lineage and compliance.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the OTB budget and financial planning (e.g., USD, EUR, GBP). Ensures consistent financial reporting across regions.. Valid values are `^[A-Z]{3}$`',
    `end_date` DATE COMMENT 'The date when the season officially ends. Marks the transition to post-season analysis and clearance activities.',
    `first_receipt_date` DATE COMMENT 'The target date for the first merchandise receipts to arrive at distribution centers or stores for the season. Marks the beginning of inventory flow.',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this season belongs (e.g., 2024). Aligns season planning with financial reporting periods.',
    `is_active` BOOLEAN COMMENT 'Boolean flag indicating whether the season is currently active for planning or operational use. True if the season is in planning, open-to-buy, or in-season status. False if post-season or closed.',
    `line_review_date` DATE COMMENT 'Key milestone date when the merchandising team reviews and approves the product line assortment for the season. Critical gate for buying decisions.',
    `markdown_entry_date` DATE COMMENT 'The date when initial markdown pricing strategies are activated to accelerate sell-through of seasonal merchandise. Signals transition to promotional phase.',
    `season_name` STRING COMMENT 'Full descriptive name of the season (e.g., Spring/Summer 2024, Holiday 2024, Back-to-School 2024). Human-readable label for business users.',
    `notes` STRING COMMENT 'Free-text field for capturing additional context, strategic notes, or special considerations for the season (e.g., market trends, competitive landscape, promotional themes). Used by merchandising planners.',
    `otb_budget_amount` DECIMAL(18,2) COMMENT 'The total Open to Buy budget allocated for this season in the base currency. Represents the planned purchase commitment for merchandise. Critical for financial planning and vendor negotiations.',
    `planning_start_date` DATE COMMENT 'The date when pre-season planning activities begin, including assortment planning, OTB (Open to Buy) budget allocation, and category strategy development.',
    `season_status` STRING COMMENT 'Current lifecycle status of the season. Planning: pre-season planning phase. Open-to-Buy: OTB budgets active, buying in progress. In-Season: merchandise on floor, active selling. Post-Season: season ended, analysis and clearance. Closed: season archived.. Valid values are `planning|open_to_buy|in_season|post_season|closed`',
    `season_type` STRING COMMENT 'Classification of the season by merchandising cycle (e.g., spring/summer, fall/winter, holiday, back-to-school). Drives assortment planning and buying strategies.. Valid values are `spring_summer|fall_winter|holiday|back_to_school|transitional|year_round`',
    `start_date` DATE COMMENT 'The date when the season officially begins for merchandising and planning purposes. Marks the start of in-season operations.',
    `target_gmroi` DECIMAL(18,2) COMMENT 'The target GMROI (Gross Margin Return on Investment) ratio for the season. Measures the profitability of inventory investment. Key performance metric for merchandising effectiveness.',
    `target_inventory_turns` DECIMAL(18,2) COMMENT 'The target number of times inventory should turn over during the season. Higher turns indicate more efficient inventory management. Key metric for supply chain and merchandising performance.',
    `target_sell_through_rate` DECIMAL(18,2) COMMENT 'The target percentage of seasonal inventory that should be sold at full price before markdowns begin. Expressed as a percentage (e.g., 75.00 for 75%). Drives inventory planning and markdown timing.',
    `updated_timestamp` TIMESTAMP COMMENT 'The timestamp when the season record was last modified. Audit trail for change tracking and data governance.',
    CONSTRAINT pk_season PRIMARY KEY(`season_id`)
) COMMENT 'Reference master for retail planning seasons and fiscal periods used to scope merchandise plans, OTB budgets, assortment plans, and buying commitments. Captures season code (e.g., SS24, FW24), season name, fiscal year, start and end dates, key milestone dates (line review, buy deadline, first receipt, markdown entry, clearance exit), and season status (planning, open-to-buy, in-season, post-season). Provides the temporal backbone for all merchandising planning and performance measurement.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` (
    `otb_budget_id` BIGINT COMMENT 'Unique identifier for the Open to Buy budget record. Primary key for the OTB budget entity.',
    `assortment_plan_id` BIGINT COMMENT 'Reference to the merchandise assortment plan that this OTB budget supports. Links budget allocation to the strategic assortment depth and breadth decisions.',
    `brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: OTB budgets are allocated by brand to manage national brand vs private label spend mix, enforce vendor concentration limits, and track brand-level buying authority. Retail buyers often have brand-spec',
    `buyer_id` BIGINT COMMENT 'Reference to the merchandise buyer responsible for managing this OTB budget. The buyer has authority to commit purchases within the available budget balance.',
    `cluster_id` BIGINT COMMENT 'Reference to the store cluster or store group for which this OTB budget is allocated. Store clusters group stores with similar assortment needs, demographics, or performance characteristics.',
    `department_id` BIGINT COMMENT 'Reference to the merchandise department for which this OTB budget is allocated. Departments represent high-level product groupings (e.g., Apparel, Electronics, Home Goods).',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.format. Business justification: OTB budget tracking measures performance against KPIs (gmroi_target, inventory_turn_target, sell_through_target_pct). Budget variance reports reference KPI definitions for standardized calculation for',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: OTB budgets are allocated to specific merchandise hierarchy nodes. Essential for buyer authority limits, budget reconciliation, receipt planning, and financial control in retail buying operations and',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.associate. Business justification: OTB budgets require a designated budget owner/planner for accountability, approval workflows, and audit trails. Retail operations track who is responsible for managing each budget allocation. Existing',
    `merch_plan_id` BIGINT COMMENT 'Foreign key linking to merchandising.merch_plan. Business justification: An OTB budget record is a financial control mechanism derived from and governed by the merchandise financial plan. Adding merch_plan_id to otb_budget establishes direct traceability from the OTB budge',
    `category_id` BIGINT COMMENT 'Reference to the merchandise category within the department for which this OTB budget applies. Categories provide finer product segmentation (e.g., Mens Shirts, Laptops, Bedding).',
    `price_list_id` BIGINT COMMENT 'Foreign key linking to pricing.price_list. Business justification: OTB budgets are planned using specific price lists (the price list determines the retail value of planned receipts). Linking enables accurate retail-value OTB calculations and budget reconciliation — ',
    `region_id` BIGINT COMMENT 'Foreign key linking to store.region. Business justification: Regional OTB budgeting is a named retail financial planning process — regional directors own OTB envelopes that roll up to total company. otb_budget has location, cluster, and format FKs but no region',
    `season_id` BIGINT COMMENT 'Reference to the merchandise season or planning period for which this OTB budget is allocated (e.g., Spring 2024, Holiday 2024, Back-to-School 2024).',
    `actual_receipts_at_cost` DECIMAL(18,2) COMMENT 'The total actual merchandise receipts at cost that have been received into inventory during this budget period. Updated as goods receipts are posted from purchase orders.',
    `approval_status` STRING COMMENT 'The approval status of the OTB budget. Pending = awaiting review; Approved = authorized for buyer use; Rejected = not approved and requires revision.. Valid values are `pending|approved|rejected`',
    `approved_by` STRING COMMENT 'The name or identifier of the merchandising leader or financial controller who approved this OTB budget. Used for audit trail and accountability.',
    `approved_timestamp` TIMESTAMP COMMENT 'The date and time when this OTB budget was approved. Marks the point at which the budget became active and available for buyer commitments.',
    `available_otb_balance` DECIMAL(18,2) COMMENT 'The remaining budget balance available for new purchase commitments. Calculated as: Planned Receipts + Adjustments - Actual Receipts - Committed Amount. This is the authoritative field that determines whether a buyer can place new orders.',
    `budget_adjustment_amount` DECIMAL(18,2) COMMENT 'The cumulative net adjustment to the original planned receipts budget. Includes increases, decreases, and transfers from other budgets. Positive values increase available OTB; negative values decrease it.',
    `budget_decrease_amount` DECIMAL(18,2) COMMENT 'The total amount of budget decreases applied to this OTB budget. Decreases may occur due to lower-than-expected sales, inventory overstock, or strategic reallocation to other categories.',
    `budget_end_date` DATE COMMENT 'The effective end date of the OTB budget period. After this date, the budget is typically closed and no further commitments are allowed unless extended.',
    `budget_increase_amount` DECIMAL(18,2) COMMENT 'The total amount of budget increases applied to this OTB budget. Increases are typically approved by senior merchandising leadership to support higher-than-planned demand or strategic opportunities.',
    `budget_name` STRING COMMENT 'Descriptive name for the OTB budget, typically combining department, category, season, and buyer information for easy identification.',
    `budget_number` STRING COMMENT 'Human-readable business identifier for the OTB budget record. Used for reporting, reconciliation, and cross-system reference.',
    `budget_start_date` DATE COMMENT 'The effective start date of the OTB budget period. Buyers can begin committing purchases on or after this date.',
    `budget_status` STRING COMMENT 'Current lifecycle status of the OTB budget. Draft = under planning; Active = buyers can commit purchases; Frozen = temporarily locked for review; Closed = planning period ended; Cancelled = budget withdrawn.. Valid values are `draft|active|frozen|closed|cancelled`',
    `budget_transfer_in_amount` DECIMAL(18,2) COMMENT 'The total amount of budget transferred into this OTB budget from other budgets. Transfers allow buyers to reallocate funds between categories or departments within the same season.',
    `budget_transfer_out_amount` DECIMAL(18,2) COMMENT 'The total amount of budget transferred out of this OTB budget to other budgets. Recorded as a positive value; reduces the available OTB balance of this budget.',
    `committed_amount` DECIMAL(18,2) COMMENT 'The total amount committed on open purchase orders that have not yet been received. Also known as on-order amount. Represents future obligations against the OTB budget.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this OTB budget record was first created in the system. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code in which all monetary amounts in this OTB budget are expressed (e.g., USD, EUR, GBP, CAD).. Valid values are `^[A-Z]{3}$`',
    `fiscal_period` STRING COMMENT 'The fiscal period (month or quarter) within the fiscal year for which this OTB budget is allocated. Typically 1-12 for monthly periods or 1-4 for quarterly periods.',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this OTB budget applies (e.g., 2024). Used for multi-year budget tracking and financial planning alignment.',
    `gmroi_target` DECIMAL(18,2) COMMENT 'The target GMROI ratio for this OTB budget. GMROI measures the gross margin dollars returned for every dollar invested in inventory. Used to evaluate buying efficiency and profitability.',
    `inventory_turn_target` DECIMAL(18,2) COMMENT 'The target inventory turnover rate for merchandise purchased under this OTB budget. Represents the number of times inventory is sold and replaced during the budget period.',
    `last_reconciliation_date` DATE COMMENT 'The date when this OTB budget was last reconciled with SAP S/4HANA MM purchase order and goods receipt data. Used to ensure data consistency between ORMS and ERP systems.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this OTB budget record was last modified. Updated in near-real-time as purchase orders are placed, goods are received, or budget adjustments are made.',
    `markdown_budget_pct` DECIMAL(18,2) COMMENT 'The planned markdown percentage allocated for this OTB budget. Represents the expected price reductions as a percentage of planned receipts at retail. Used for margin planning and promotional strategy.',
    `notes` STRING COMMENT 'Free-text notes or comments about this OTB budget. May include rationale for adjustments, special instructions, or strategic context for the buyer.',
    `planned_receipts_at_cost` DECIMAL(18,2) COMMENT 'The total planned merchandise receipts at cost for this budget period. Represents the initial budget allocation before any adjustments or commitments. Expressed in the budget currency.',
    `sell_through_target_pct` DECIMAL(18,2) COMMENT 'The target sell-through rate (as a percentage) for merchandise purchased under this OTB budget. Represents the percentage of inventory expected to be sold during the budget period.',
    CONSTRAINT pk_otb_budget PRIMARY KEY(`otb_budget_id`)
) COMMENT 'Open to Buy (OTB) budget record representing the financial control mechanism that governs merchandise buying spend. Tracks planned receipts at cost, actual receipts, committed orders (on-order), available OTB balance, and budget adjustments (transfers, increases, decreases) by department, category, buyer, and season. Updated in near-real-time as buying orders are placed. The authoritative record for whether a buyer has remaining budget authority to commit new purchases. Sourced from ORMS and reconciled with SAP S/4HANA MM.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`buying_order` (
    `buying_order_id` BIGINT COMMENT 'Unique identifier for the merchandise buying order record in ORMS (the retail merchandising system Merchandising System). Primary key for this entity.',
    `assortment_plan_id` BIGINT COMMENT 'Foreign key linking to merchandising.assortment_plan. Business justification: A buying order is the execution vehicle for purchasing SKUs defined in an assortment plan. Linking buying_order to assortment_plan enables direct traceability from committed purchase orders back to th',
    `buyer_id` BIGINT COMMENT 'Identifier of the merchandise buyer or purchasing agent responsible for creating and managing this buying order. Links to workforce/employee master data.',
    `category_id` BIGINT COMMENT 'Identifier of the product category within the department. Enables category-level assortment analysis and GMROI (Gross Margin Return on Investment) tracking.',
    `vendor_id` BIGINT COMMENT 'Identifier of the supplier from whom the merchandise is being purchased. Links to the supplier master data in MDM (Master Data Management).',
    `cluster_id` BIGINT COMMENT 'Foreign key linking to store.cluster. Business justification: Cluster-level buying is a named retail process where buyers place orders for store clusters. buying_order has destination_location_id for individual stores but lacks cluster_id needed for cluster-leve',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Purchase orders for fixtures, supplies, or capital items are allocated to cost centers for capex vs opex classification and budget tracking. Required for non-inventory purchase cost allocation.',
    `location_id` BIGINT COMMENT 'Identifier of the specific distribution center, store, or cross-dock facility where the merchandise will be received. Links to inventory node or store master data.',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Import buying orders for regulated categories (alcohol, tobacco, pharmaceuticals, firearms) require valid import licenses. Customs brokers verify license validity before shipment. Real business proces',
    `lead_time_agreement_id` BIGINT COMMENT 'Foreign key linking to supplier.lead_time_agreement. Business justification: Buying orders are scheduled against specific lead time agreements that govern delivery windows and SLAs. On-time delivery compliance reporting and order scheduling require linking each buying order to',
    `otb_budget_id` BIGINT COMMENT 'Identifier of the OTB (Open to Buy) budget allocation against which this buying order is committed. Used to track spending against merchandise financial plans and prevent over-buying.',
    `fulfillment_node_id` BIGINT COMMENT 'Foreign key linking to fulfillment.node. Business justification: Inbound purchase orders must specify receiving DC/warehouse for inventory routing and capacity planning. Retail operations require knowing which fulfillment node will process incoming vendor shipments',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Buying orders are executed within specific retail seasons for merchandise planning and OTB budget tracking. Currently has season_code (STRING) which should be normalized to season_id FK. This links bu',
    `vendor_address_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_address. Business justification: Landed cost calculation, incoterms application, and customs documentation require the specific vendor ship-from address on each buying order. Role prefix ship_from_ distinguishes this from destinati',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Retail buying orders (merchandising procurement intent) are executed as supply chain purchase orders. Buyers track PO execution status, receipt variance, and landed cost reconciliation. This link enab',
    `vendor_contact_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contact. Business justification: Buying order management requires tracking the specific vendor sales rep/contact responsible for the order — used for order acknowledgment, dispute resolution, and communication tracking. No existing F',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: Every buying order in retail is executed under a governing vendor contract that dictates payment terms, pricing, compliance requirements, and chargeback policies. Contract compliance audits and AP rec',
    `approval_date` DATE COMMENT 'Date when the buying order received final approval from authorized buyer or merchandise manager. Nullable for orders still in draft or pending approval status.',
    `approval_workflow_code` STRING COMMENT 'Identifier of the approval workflow instance used to authorize this buying order. Tracks multi-level approvals based on order value thresholds and buyer authority limits.',
    `cancel_date` DATE COMMENT 'Date when the buying order was cancelled. Nullable for active orders. Populated when order_status transitions to cancelled.',
    `cancellation_reason_code` STRING COMMENT 'Standardized code indicating the reason for order cancellation. Nullable for active orders. Used for supplier performance analysis and procurement process improvement.. Valid values are `buyer_request|supplier_unable|assortment_change|budget_cut|demand_shift|duplicate_order`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this buying order record was first created in ORMS. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the buying order cost and pricing (e.g., USD, EUR, GBP). Used for multi-currency procurement and financial reporting.. Valid values are `^[A-Z]{3}$`',
    `destination_type` STRING COMMENT 'Type of destination location where the merchandise will be delivered: distribution center for centralized receiving, store for direct store delivery (DSD), cross_dock for immediate transfer, or vendor_direct for drop-ship to customer.. Valid values are `distribution_center|store|cross_dock|vendor_direct`',
    `duty_cost` DECIMAL(18,2) COMMENT 'Estimated or actual customs duty and import taxes for international shipments. Used to calculate landed cost and COGS (Cost of Goods Sold).',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Exchange rate applied to convert supplier currency to base reporting currency at the time of order creation. Used for financial consolidation and P&L (Profit and Loss) reporting.',
    `fob_terms` STRING COMMENT 'Incoterms defining the point at which ownership and risk transfer from supplier to retailer. Determines freight responsibility and cost allocation. [ENUM-REF-CANDIDATE: fob_origin|fob_destination|exw|fca|cif|dap|ddp — 7 candidates stripped; promote to reference product]',
    `freight_cost` DECIMAL(18,2) COMMENT 'Estimated or actual freight and shipping cost for transporting the merchandise from supplier to destination. May be retailer-paid or supplier-paid depending on FOB terms.',
    `landed_cost` DECIMAL(18,2) COMMENT 'Total cost of merchandise including product cost, freight, duties, and other charges to deliver goods to the distribution center. Used for margin analysis and pricing decisions.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this buying order record was last updated in ORMS. Tracks the most recent change to any field in the order.',
    `notes` STRING COMMENT 'Free-text notes and special instructions for the buying order. May include packaging requirements, labeling instructions, quality specifications, or other supplier communications.',
    `order_date` DATE COMMENT 'Date when the buying order was created and committed in ORMS. Represents the business event timestamp for the buying decision.',
    `order_number` STRING COMMENT 'Externally-known business identifier for the buying order. Human-readable order number used in communications with suppliers and internal stakeholders.. Valid values are `^[A-Z0-9]{8,20}$`',
    `order_status` STRING COMMENT 'Current lifecycle status of the buying order in the procurement workflow. Tracks progression from draft through approval, submission to supplier, acknowledgment, receipt, and closure or cancellation. [ENUM-REF-CANDIDATE: draft|pending_approval|approved|submitted|acknowledged|in_transit|partially_received|received|closed|cancelled — 10 candidates stripped; promote to reference product]',
    `order_type` STRING COMMENT 'Classification of the buying order indicating the strategic purpose: initial buy for new assortment, reorder for replenishment, opportunistic for special deals, seasonal for seasonal merchandise, promotional for promotion-driven buys, or clearance for end-of-season purchases.. Valid values are `initial_buy|reorder|opportunistic|seasonal|promotional|clearance`',
    `payment_terms` STRING COMMENT 'Negotiated payment terms with the supplier (e.g., Net 30, Net 60, 2/10 Net 30). Defines the payment due date and any early payment discounts.',
    `planned_receipt_date` DATE COMMENT 'Target date by which the merchandise is expected to arrive at the distribution center or store. Used for inventory planning and assortment timing.',
    `ship_window_end_date` DATE COMMENT 'Latest date the supplier must ship the merchandise to meet planned receipt date. Defines the end of the acceptable shipping window; late shipments may incur chargebacks.',
    `ship_window_start_date` DATE COMMENT 'Earliest date the supplier is authorized to ship the merchandise. Defines the beginning of the acceptable shipping window for timely assortment flow.',
    `submission_date` DATE COMMENT 'Date when the approved buying order was transmitted to the supplier via EDI (Electronic Data Interchange) or other communication channel.',
    `total_order_cost` DECIMAL(18,2) COMMENT 'Total cost value of the buying order in the base currency, calculated as sum of (unit cost × quantity) across all line items. Represents the committed spend with the supplier, excluding freight and duties.',
    `total_order_quantity` DECIMAL(18,2) COMMENT 'Total quantity of units ordered across all SKUs (Stock Keeping Units) in this buying order. Aggregated from line-level quantities.',
    `vendor_order_number` STRING COMMENT 'Suppliers own order reference number assigned when they acknowledge the buying order. Used for order tracking and supplier communication.',
    CONSTRAINT pk_buying_order PRIMARY KEY(`buying_order_id`)
) COMMENT 'Merchandise buying order representing a committed purchase from a supplier for specific SKUs, quantities, and delivery windows. Captures order type (initial buy, reorder, opportunistic), planned receipt date, FOB terms, cost per unit, total order value, and approval status. Distinct from operational purchase orders — this is the buying decision record in ORMS.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` (
    `buying_order_line_id` BIGINT COMMENT 'Unique identifier for the buying order line item. Primary key for this entity.',
    `assortment_item_id` BIGINT COMMENT 'Foreign key linking to merchandising.assortment_item. Business justification: A buying order line represents the actual committed purchase of a specific SKU, which corresponds directly to an assortment item (the planned SKU inclusion in an assortment plan). Adding assortment_it',
    `buyer_id` BIGINT COMMENT 'Reference to the merchandise buyer responsible for this purchase decision. Used for accountability tracking and buyer performance analysis.',
    `buying_order_id` BIGINT COMMENT 'Reference to the parent buying order header. Links this line item to the overall purchase order placed with the vendor.',
    `cost_price_id` BIGINT COMMENT 'Foreign key linking to pricing.cost_price. Business justification: Each buying order line has a negotiated cost price. Linking enables cost validation at the line level, margin calculation per ordered item, and cost variance reporting against vendor contracts — a sta',
    `department_id` BIGINT COMMENT 'Reference to the merchandise department or category to which this SKU belongs. Used for OTB (Open to Buy) budget tracking and category management reporting.',
    `otb_budget_id` BIGINT COMMENT 'Reference to the OTB budget against which this line item is committed. Enables tracking of buying commitments against planned budgets by category, season, and time period.',
    `po_line_id` BIGINT COMMENT 'Foreign key linking to supplychain.po_line. Business justification: Line-level traceability from merchandising buy to supply chain PO line is essential for cost reconciliation, receipt matching, and variance analysis. Retail buyers need to track which supply chain PO',
    `category_id` BIGINT COMMENT 'Reference to the merchandise class within the department. Provides finer-grained categorization for assortment depth and breadth analysis.',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Buying order line items are allocated to specific seasons for inventory planning and sell-through tracking. Currently has season_code (STRING) which should be normalized to season_id FK. Line-level se',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Buying order lines reference specific SKUs for procurement, cost negotiation, margin planning, and receipt matching against purchase orders. The plain-text sku column denormalizes the product refere',
    `sku_price_id` BIGINT COMMENT 'Foreign key linking to pricing.sku_price. Business justification: Buying order lines reference the retail price (sku_price) to calculate planned margin at order placement. Linking enables margin calculation at order line level and price validation — a standard retai',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: Buying order lines specify unit of measure for ordered quantities. Must link to standardized UOM master for unit conversion, case pack calculations, receiving validation, and inventory reconciliation',
    `vendor_item_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_item. Business justification: Buying order lines reference vendor-specific item numbers for procurement. Receiving systems match inbound ASNs and shipments using vendor_item mappings. Purchase orders transmitted via EDI include ve',
    `allocation_quantity` DECIMAL(18,2) COMMENT 'Quantity of this SKU allocated to the specified store cluster. Supports pre-distribution planning and ensures inventory is directed to the right locations based on demand forecasts.',
    `cancel_date` DATE COMMENT 'Date after which the retailer reserves the right to cancel this line item if not received. Enforces vendor compliance with delivery commitments and protects against late shipments.',
    `cancelled_quantity` DECIMAL(18,2) COMMENT 'Quantity cancelled by either the retailer or vendor for this line item. Tracks order changes and impacts OTB budget availability and assortment plans.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this buying order line record was first created in the system. Supports audit trail and order lifecycle tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the cost and retail price amounts. Supports multi-currency procurement for international vendor sourcing.. Valid values are `^[A-Z]{3}$`',
    `delivery_date` DATE COMMENT 'Expected delivery date for this line item to the distribution center or store. Used for receipt planning, inventory replenishment scheduling, and vendor performance tracking.',
    `drop_ship_flag` BOOLEAN COMMENT 'Indicates whether this line item will be drop shipped directly from vendor to customer rather than through the retailers distribution network. Supports omnichannel fulfillment strategies.',
    `extended_cost` DECIMAL(18,2) COMMENT 'Total cost for this line item calculated as ordered quantity multiplied by unit cost. Represents the total financial commitment for this SKU on the buying order.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this buying order line record was last updated. Tracks changes to quantities, dates, costs, or status throughout the order lifecycle.',
    `lead_time_days` STRING COMMENT 'Number of days from order placement to expected delivery. Used for replenishment planning, safety stock calculations, and vendor performance measurement.',
    `line_number` STRING COMMENT 'Sequential line number within the buying order. Determines the ordering and display sequence of line items on the purchase order document.',
    `line_status` STRING COMMENT 'Current lifecycle status of this buying order line item. Tracks progression from order placement through receipt and enables exception management for delayed or cancelled items.. Valid values are `open|confirmed|shipped|received|cancelled|closed`',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity that must be ordered from the vendor for this SKU. Enforces vendor-imposed order constraints and impacts OTB planning decisions.',
    `ordered_quantity` DECIMAL(18,2) COMMENT 'Quantity of units ordered from the vendor for this SKU. Represents the commitment quantity for OTB (Open to Buy) tracking and receipt planning.',
    `pack_size` STRING COMMENT 'Number of individual units contained in a vendor pack or case. Used for calculating total units from case quantities and for warehouse receiving operations.',
    `planned_margin_amount` DECIMAL(18,2) COMMENT 'Planned gross margin amount per unit calculated as retail price minus unit cost. Represents the expected profit contribution per unit sold.',
    `planned_margin_percent` DECIMAL(18,2) COMMENT 'Planned gross margin percentage calculated as (retail price minus unit cost) divided by retail price. Key metric for category profitability and GMROI (Gross Margin Return on Investment) planning.',
    `private_label_flag` BOOLEAN COMMENT 'Indicates whether this SKU is a private label (store brand) product. Used for margin analysis, assortment strategy, and competitive positioning reporting.',
    `received_quantity` DECIMAL(18,2) COMMENT 'Actual quantity received to date for this line item. Used for fill rate calculation, vendor performance tracking, and identifying short shipments or overages.',
    `retail_price` DECIMAL(18,2) COMMENT 'Planned retail selling price for this SKU at the time of order placement. Used for initial margin calculation and pricing strategy execution.',
    `store_cluster_code` STRING COMMENT 'Code identifying the store cluster or group for which this merchandise is allocated. Enables assortment planning by store type, geography, or performance tier.. Valid values are `^[A-Z0-9]{2,10}$`',
    `unit_cost` DECIMAL(18,2) COMMENT 'Cost per unit paid to the vendor for this SKU. Represents the negotiated wholesale price and is used for COGS (Cost of Goods Sold) calculation and margin analysis.',
    `vendor_style_number` STRING COMMENT 'Vendor-assigned style or model number for this product. Used for cross-referencing with vendor catalogs and facilitating reorder processes.',
    CONSTRAINT pk_buying_order_line PRIMARY KEY(`buying_order_line_id`)
) COMMENT 'Line-level detail of a merchandise buying order capturing individual SKU commitments including SKU/UPC, ordered quantity, unit cost, retail price, planned margin, delivery date, and allocation by store cluster. Enables SKU-level OTB tracking and receipt planning.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` (
    `assortment_item_id` BIGINT COMMENT 'Unique identifier for the assortment item record. Primary key for this association between SKU, assortment plan, store cluster, and season.',
    `assortment_plan_id` BIGINT COMMENT 'Reference to the parent assortment plan that defines the strategic merchandise mix for a specific season and store cluster.',
    `sku_id` BIGINT COMMENT 'Reference to the specific product SKU included in this assortment plan.',
    `vendor_id` BIGINT COMMENT 'Reference to the primary supplier providing this SKU. Critical for vendor performance tracking, negotiations, and supply chain management.',
    `brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Assortment planning tracks brand-level performance (GMROI, sell-through, margin by brand), manages national vs private label mix targets, and enforces brand representation rules. The private_label_fla',
    `cluster_id` BIGINT COMMENT 'Reference to the store cluster grouping that this assortment item applies to. Store clusters group locations by similar demographics, performance, or format.',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.department. Business justification: Assortment items are placed within specific store departments for planogram execution and space planning. Department-level assortment reporting (SKU count per department, selling area utilization) is ',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.location. Business justification: Assortment items (especially private label, imported goods, childrens products) require product safety certifications (CPSC, FDA, CE marking). Assortment planning validates certification status befor',
    `otb_budget_id` BIGINT COMMENT 'Foreign key linking to merchandising.otb_budget. Business justification: Each assortment item (a planned SKU in an assortment plan) is financially governed by an OTB budget that controls how much can be purchased. Adding otb_budget_id to assortment_item links the individua',
    `price_list_id` BIGINT COMMENT 'Foreign key linking to pricing.price_list. Business justification: Assortment items are priced according to a specific price list (regular, promotional). Linking enables assortment-level price list assignment and supports price list change impact analysis on the asso',
    `replenishment_plan_id` BIGINT COMMENT 'Foreign key linking to supplychain.replenishment_plan. Business justification: Assortment items drive replenishment planning decisions. Buyers and planners need to link assortment selections to their corresponding replenishment plans to optimize inventory levels, monitor fill ra',
    `season_id` BIGINT COMMENT 'Reference to the merchandising season (e.g., Spring 2024, Holiday 2024) for which this assortment item is planned.',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: Assortment planning specifies minimum presentation quantities, planned units, and planogram compliance requirements; UOM is essential for space planning (shelf capacity in eaches vs cases), inventory ',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: Assortment items sourced under exclusivity or private label arrangements are governed by a specific vendor contract. Assortment compliance reviews and private label management require linking each ass',
    `vendor_item_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_item. Business justification: Each assortment item represents a SKU sourced from a specific vendor; the vendor_item record defines cost, pack size, country of origin, and DSD eligibility used in assortment cost planning and privat',
    `assortment_depth_tier` STRING COMMENT 'Classification of how many variants (sizes, colors, styles) of this item are carried within its category. Deep assortments offer extensive choice within a category, narrow assortments offer limited variety.. Valid values are `narrow|moderate|deep|very_deep`',
    `assortment_role` STRING COMMENT 'Strategic role of this item within the assortment. Core items are year-round staples, seasonal items are time-bound, trend items capture emerging demand, clearance items are being phased out, promotional items support campaigns, and test items are being evaluated.. Valid values are `core|seasonal|trend|clearance|promotional|test`',
    `attributes_checklist_complete` BOOLEAN COMMENT 'Indicates whether all required product attributes (dimensions, weight, materials, care instructions, etc.) have been captured in the Product Information Management (PIM) system for this SKU.',
    `clearance_strategy` STRING COMMENT 'Planned approach for clearing remaining inventory of discontinued items. Markdown uses progressive price reductions, liquidation sells to third parties, RTV returns unsold units to vendor, donation gives to charity, disposal destroys unsellable goods.. Valid values are `markdown|liquidation|return_to_vendor|donation|disposal`',
    `cpsc_certification_status` STRING COMMENT 'Status of CPSC safety certification for products requiring consumer safety compliance (toys, childrens products, electronics, etc.). Not required for all product categories.. Valid values are `not_required|pending|certified|failed|expired`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this assortment item record was first created in the system. Audit trail for record creation.',
    `discontinuation_reason` STRING COMMENT 'Business reason for discontinuing this SKU from the assortment. Captures strategic rationale for removal decisions to inform future assortment planning.. Valid values are `low_sell_through|supplier_exit|assortment_rationalization|dead_stock|quality_issues|regulatory_change`',
    `effective_end_date` DATE COMMENT 'Date when this assortment item record expires and the SKU should be removed from the designated store cluster. Null for ongoing assortment items without planned end date.',
    `effective_start_date` DATE COMMENT 'Date when this assortment item record becomes active and the SKU should be available in the designated store cluster. Supports time-based assortment transitions.',
    `fda_certification_status` STRING COMMENT 'Status of FDA certification for food, beverage, pharmaceutical, and cosmetic products requiring regulatory approval. Not required for non-food/drug categories.. Valid values are `not_required|pending|certified|failed|expired`',
    `final_disposition_date` DATE COMMENT 'Date when all remaining inventory of this discontinued SKU must be cleared from stores and distribution centers. Marks the end of the item lifecycle in this assortment.',
    `go_live_date` DATE COMMENT 'Planned or actual date when this SKU becomes available for sale in the designated store cluster. Critical milestone for new item launches and seasonal transitions.',
    `inclusion_status` STRING COMMENT 'Current inclusion or exclusion status of this SKU in the assortment plan. Indicates whether the item is actively carried, excluded from the plan, or pending final decision.. Valid values are `included|excluded|pending|under_review`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this assortment item record was most recently updated. Audit trail for tracking changes to assortment decisions.',
    `last_order_date` DATE COMMENT 'Final date on which purchase orders can be placed with suppliers for this SKU before discontinuation. Critical for managing inventory runout and avoiding excess stock.',
    `lifecycle_stage` STRING COMMENT 'Current stage in the item lifecycle from initial onboarding through active selling to discontinuation. Tracks the complete journey of the SKU within this assortment.. Valid values are `onboarding|active|mature|declining|discontinued`',
    `minimum_presentation_quantity` STRING COMMENT 'Minimum number of units that must be displayed on the shelf to maintain visual impact and avoid out-of-stock perception. Used for store replenishment triggers.',
    `modified_by_user` STRING COMMENT 'Username or identifier of the merchandising planner or system user who last modified this assortment item record. Supports accountability and audit requirements.',
    `onboarding_status` STRING COMMENT 'Detailed status of new item onboarding process. Tracks progress through attribute setup, compliance certification, and go-live readiness for items in onboarding lifecycle stage.. Valid values are `not_started|in_progress|attributes_complete|compliance_pending|ready_for_launch|launched`',
    `planned_aur` DECIMAL(18,2) COMMENT 'Target average selling price per unit for this SKU during the season, accounting for planned markdowns and promotions. Used for revenue forecasting and Gross Margin Return on Investment (GMROI) calculations.',
    `planned_gmroi` DECIMAL(18,2) COMMENT 'Target Gross Margin Return on Investment for this assortment item. Measures how many dollars of gross margin are returned for every dollar invested in inventory. Key profitability metric for assortment decisions.',
    `planned_sell_through_rate` DECIMAL(18,2) COMMENT 'Target percentage of inventory expected to sell during the season without markdown. Key metric for assortment performance planning and Open to Buy (OTB) budgeting. Expressed as percentage (e.g., 85.50 for 85.5%).',
    `planned_units` STRING COMMENT 'Target quantity of units to be purchased and sold for this SKU in this store cluster during the season. Foundation for Open to Buy (OTB) budget allocation.',
    `planned_weeks_of_supply` DECIMAL(18,2) COMMENT 'Target number of weeks that planned inventory should last based on forecasted demand. Critical for replenishment planning and avoiding overstock or stockouts.',
    `planogram_position_required` BOOLEAN COMMENT 'Indicates whether this SKU requires a specific shelf position defined in store planograms. True for items with strategic placement requirements (endcaps, eye-level, checkout displays).',
    `private_label_flag` BOOLEAN COMMENT 'Indicates whether this SKU is a store brand (private label) product versus a national brand. Private label items typically have higher margins and exclusive positioning.',
    `upc_registration_status` STRING COMMENT 'Status of UPC or GTIN registration with GS1 for this SKU. Required for point-of-sale scanning and supply chain tracking.. Valid values are `not_registered|pending|registered|failed`',
    CONSTRAINT pk_assortment_item PRIMARY KEY(`assortment_item_id`)
) COMMENT 'Association record linking a specific SKU to an assortment plan for a given store cluster and season, serving as the single source of truth for the complete item lifecycle from onboarding through active selling to discontinuation. Captures inclusion/exclusion status, assortment role (core, seasonal, trend, clearance), planned sell-through rate, planned weeks of supply (WOS), planned AUR (Average Unit Retail), planned units. For new item onboarding: setup status, go-live date, required attributes checklist, compliance certifications (CPSC, FDA), UPC/GTIN registration status. For discontinuation: reason (low sell-through, supplier exit, assortment rationalization, dead stock), last order date, clearance strategy, and final disposition. The authoritative record of what is carried where and its complete lifecycle state.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_merch_plan_id` FOREIGN KEY (`merch_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`merch_plan`(`merch_plan_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ADD CONSTRAINT `fk_merchandising_category_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ADD CONSTRAINT `fk_merchandising_category_parent_category_id` FOREIGN KEY (`parent_category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_merch_plan_id` FOREIGN KEY (`merch_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`merch_plan`(`merch_plan_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_otb_budget_id` FOREIGN KEY (`otb_budget_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`otb_budget`(`otb_budget_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_assortment_item_id` FOREIGN KEY (`assortment_item_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_item`(`assortment_item_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_buying_order_id` FOREIGN KEY (`buying_order_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order`(`buying_order_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_otb_budget_id` FOREIGN KEY (`otb_budget_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`otb_budget`(`otb_budget_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_otb_budget_id` FOREIGN KEY (`otb_budget_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`otb_budget`(`otb_budget_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`merchandising` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_retail_v1`.`merchandising` SET TAGS ('dbx_domain' = 'merchandising');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` SET TAGS ('dbx_subdomain' = 'financial_planning');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `merch_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Merchandise Plan ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `price_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Price Strategy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `gmroi_target` SET TAGS ('dbx_business_glossary_term' = 'Gross Margin Return on Investment (GMROI) Target');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active Flag');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `otb_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget Amount');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `plan_code` SET TAGS ('dbx_business_glossary_term' = 'Merchandise Plan Code');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `plan_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Merchandise Plan Name');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_business_glossary_term' = 'Merchandise Plan Status');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|approved|active|closed|cancelled');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Merchandise Plan Type');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'seasonal|annual|promotional|ad_hoc');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `sell_through_target_percent` SET TAGS ('dbx_business_glossary_term' = 'Sell-Through Target Percent');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = '^[A-Z_]{2,20}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` SET TAGS ('dbx_subdomain' = 'assortment_strategy');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `merch_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Merch Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `price_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Price Strategy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Assortment Plan Approval Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `cluster_strategy_description` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster Strategy Description');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `clustering_methodology` SET TAGS ('dbx_business_glossary_term' = 'Store Clustering Methodology');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `clustering_methodology` SET TAGS ('dbx_value_regex' = 'sales_volume|demographics|climate|format|geographic|hybrid');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `national_brand_sku_count` SET TAGS ('dbx_business_glossary_term' = 'National Brand Stock Keeping Unit (SKU) Count');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Review Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Assortment Plan Notes');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `otb_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget Amount');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `otb_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Currency Code');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `otb_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `plan_code` SET TAGS ('dbx_business_glossary_term' = 'Assortment Plan Code');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `plan_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Assortment Plan Name');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_business_glossary_term' = 'Assortment Plan Status');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|active|closed|cancelled');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Assortment Plan Type');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'seasonal|core|promotional|test|clearance|new_launch');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `planned_sku_count` SET TAGS ('dbx_business_glossary_term' = 'Planned Stock Keeping Unit (SKU) Count');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `planogram_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Planogram (POG) Required Flag');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `private_label_mix_percent` SET TAGS ('dbx_business_glossary_term' = 'Private Label Mix Percentage');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `private_label_sku_count` SET TAGS ('dbx_business_glossary_term' = 'Private Label Stock Keeping Unit (SKU) Count');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = 'ORMS|SAP|MANUAL|LEGACY');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `target_gmroi` SET TAGS ('dbx_business_glossary_term' = 'Target Gross Margin Return on Investment (GMROI)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `target_sell_through_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Target Sell-Through Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Assortment Plan Version Number');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` SET TAGS ('dbx_subdomain' = 'assortment_strategy');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `actual_gmroi` SET TAGS ('dbx_business_glossary_term' = 'Actual Gross Margin Return on Investment (GMROI)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `actual_sell_through_rate` SET TAGS ('dbx_business_glossary_term' = 'Actual Sell-Through Rate');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `category_role` SET TAGS ('dbx_value_regex' = 'destination|routine|convenience|seasonal|occasional');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `category_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|discontinued');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `category_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `otb_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget Amount');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `otb_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Currency Code');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `otb_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `review_frequency` SET TAGS ('dbx_value_regex' = 'weekly|monthly|quarterly|semi_annual|annual');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `target_gmroi` SET TAGS ('dbx_business_glossary_term' = 'Target Gross Margin Return on Investment (GMROI)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `target_sell_through_rate` SET TAGS ('dbx_business_glossary_term' = 'Target Sell-Through Rate');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` SET TAGS ('dbx_subdomain' = 'assortment_strategy');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `assortment_planning_system_access` SET TAGS ('dbx_business_glossary_term' = 'Assortment Planning System Access Level');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `assortment_planning_system_access` SET TAGS ('dbx_value_regex' = 'full_access|read_only|no_access');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `buyer_status` SET TAGS ('dbx_value_regex' = 'active|inactive|on_leave|terminated');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `buyer_type` SET TAGS ('dbx_value_regex' = 'merchandise_buyer|category_manager|assistant_buyer|senior_buyer|divisional_buyer');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `certification_credentials` SET TAGS ('dbx_business_glossary_term' = 'Professional Certification Credentials');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `buyer_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}[0-9]{3,5}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `data_source_system` SET TAGS ('dbx_value_regex' = 'ORMS|Workday|SAP|Manual|MDM');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `division_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Buyer Email Address');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `email_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `gmroi_target` SET TAGS ('dbx_business_glossary_term' = 'Gross Margin Return on Investment (GMROI) Target');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `hire_date` SET TAGS ('dbx_business_glossary_term' = 'Buyer Hire Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `buyer_name` SET TAGS ('dbx_business_glossary_term' = 'Buyer Full Name');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `office_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}[0-9]{3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `otb_budget_limit` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget Limit');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Buyer Phone Number');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `sell_through_rate_target` SET TAGS ('dbx_business_glossary_term' = 'Sell-Through Rate Target');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Buyer Termination Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `vendor_negotiation_rating` SET TAGS ('dbx_value_regex' = 'excellent|good|average|needs_improvement|not_rated');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` SET TAGS ('dbx_subdomain' = 'financial_planning');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `season_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}[0-9]{2}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Season End Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active Flag');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Season Notes');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `otb_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget Amount');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `season_status` SET TAGS ('dbx_value_regex' = 'planning|open_to_buy|in_season|post_season|closed');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `season_type` SET TAGS ('dbx_value_regex' = 'spring_summer|fall_winter|holiday|back_to_school|transitional|year_round');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Season Start Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `target_gmroi` SET TAGS ('dbx_business_glossary_term' = 'Target Gross Margin Return on Investment (GMROI)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `target_sell_through_rate` SET TAGS ('dbx_business_glossary_term' = 'Target Sell-Through Rate');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` SET TAGS ('dbx_subdomain' = 'financial_planning');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `otb_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Gmroi Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Owner Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `merch_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Merch Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `available_otb_balance` SET TAGS ('dbx_business_glossary_term' = 'Available Open to Buy (OTB) Balance');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `budget_name` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget Name');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `budget_number` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget Number');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `budget_status` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget Status');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `budget_status` SET TAGS ('dbx_value_regex' = 'draft|active|frozen|closed|cancelled');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `gmroi_target` SET TAGS ('dbx_business_glossary_term' = 'Gross Margin Return on Investment (GMROI) Target');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `markdown_budget_pct` SET TAGS ('dbx_business_glossary_term' = 'Markdown Budget Percentage');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Budget Notes');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `sell_through_target_pct` SET TAGS ('dbx_business_glossary_term' = 'Sell-Through Target Percentage');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `assortment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Assortment Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Cluster Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Import License Permit Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `lead_time_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Agreement Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `otb_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Open To Buy (OTB) Budget ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Fulfillment Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `vendor_address_id` SET TAGS ('dbx_business_glossary_term' = 'Ship From Vendor Address Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `vendor_address_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `vendor_address_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `vendor_contact_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contact Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Buying Order Approval Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `approval_workflow_code` SET TAGS ('dbx_business_glossary_term' = 'Approval Workflow ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `cancel_date` SET TAGS ('dbx_business_glossary_term' = 'Buying Order Cancellation Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `cancellation_reason_code` SET TAGS ('dbx_value_regex' = 'buyer_request|supplier_unable|assortment_change|budget_cut|demand_shift|duplicate_order');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `destination_type` SET TAGS ('dbx_value_regex' = 'distribution_center|store|cross_dock|vendor_direct');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `fob_terms` SET TAGS ('dbx_business_glossary_term' = 'Free On Board (FOB) Terms');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Buying Order Notes');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `order_date` SET TAGS ('dbx_business_glossary_term' = 'Buying Order Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `order_number` SET TAGS ('dbx_business_glossary_term' = 'Buying Order Number');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `order_status` SET TAGS ('dbx_business_glossary_term' = 'Buying Order Status');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Buying Order Type');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'initial_buy|reorder|opportunistic|seasonal|promotional|clearance');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Buying Order Submission Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` SET TAGS ('dbx_subdomain' = 'procurement_execution');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `assortment_item_id` SET TAGS ('dbx_business_glossary_term' = 'Assortment Item Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `cost_price_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `otb_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Po Line Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Class ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `sku_price_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `vendor_item_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Item Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `line_status` SET TAGS ('dbx_value_regex' = 'open|confirmed|shipped|received|cancelled|closed');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `store_cluster_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` SET TAGS ('dbx_subdomain' = 'assortment_strategy');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Product Safety Certification Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `otb_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Otb Budget Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `replenishment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `vendor_item_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Item Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `assortment_depth_tier` SET TAGS ('dbx_value_regex' = 'narrow|moderate|deep|very_deep');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `assortment_role` SET TAGS ('dbx_value_regex' = 'core|seasonal|trend|clearance|promotional|test');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `attributes_checklist_complete` SET TAGS ('dbx_business_glossary_term' = 'Attributes Checklist Complete Flag');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `clearance_strategy` SET TAGS ('dbx_value_regex' = 'markdown|liquidation|return_to_vendor|donation|disposal');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `cpsc_certification_status` SET TAGS ('dbx_business_glossary_term' = 'Consumer Product Safety Commission (CPSC) Certification Status');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `cpsc_certification_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|certified|failed|expired');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `discontinuation_reason` SET TAGS ('dbx_value_regex' = 'low_sell_through|supplier_exit|assortment_rationalization|dead_stock|quality_issues|regulatory_change');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `fda_certification_status` SET TAGS ('dbx_business_glossary_term' = 'Food and Drug Administration (FDA) Certification Status');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `fda_certification_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|certified|failed|expired');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `go_live_date` SET TAGS ('dbx_business_glossary_term' = 'Go-Live Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `inclusion_status` SET TAGS ('dbx_value_regex' = 'included|excluded|pending|under_review');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_value_regex' = 'onboarding|active|mature|declining|discontinued');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `onboarding_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|attributes_complete|compliance_pending|ready_for_launch|launched');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `planned_aur` SET TAGS ('dbx_business_glossary_term' = 'Planned Average Unit Retail (AUR)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `planned_gmroi` SET TAGS ('dbx_business_glossary_term' = 'Planned Gross Margin Return on Investment (GMROI)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `planned_sell_through_rate` SET TAGS ('dbx_business_glossary_term' = 'Planned Sell-Through Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `planned_weeks_of_supply` SET TAGS ('dbx_business_glossary_term' = 'Planned Weeks of Supply (WOS)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `planogram_position_required` SET TAGS ('dbx_business_glossary_term' = 'Planogram (POG) Position Required Flag');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `upc_registration_status` SET TAGS ('dbx_business_glossary_term' = 'Universal Product Code (UPC) Registration Status');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `upc_registration_status` SET TAGS ('dbx_value_regex' = 'not_registered|pending|registered|failed');
