-- Schema for Domain: merchandising | Business:  | Version: v2_ecm
-- Generated on: 2026-07-12 09:24:24

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`merchandising` COMMENT 'Manages strategic merchandise planning, assortment management, category management, OTB (Open to Buy) budgets, buying decisions, vendor negotiations, and seasonal planning. Tracks sell-through rates, inventory turns, and assortment performance by category, department, and store cluster. Drives assortment depth and breadth decisions and GMROI targets. Integrates with Oracle Retail Merchandising System (ORMS).';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` (
    `merch_plan_id` BIGINT COMMENT 'Unique identifier for the merchandise financial plan record. Primary key.',
    `buyer_id` BIGINT COMMENT 'Reference to the merchandise buyer responsible for executing this plan and making purchasing decisions.',
    `category_id` BIGINT COMMENT 'Reference to the product category this merchandise plan covers.',
    `cluster_id` BIGINT COMMENT 'Reference to the store cluster or group this merchandise plan applies to, enabling differentiated assortment planning by store type.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Merchandise plans allocate OTB budgets to cost centers for financial tracking, variance analysis, and budget vs actual reporting. Essential for monthly financial close and planning cost allocation.',
    `department_id` BIGINT COMMENT 'Reference to the retail department this merchandise plan covers.',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Merchandise financial plans are built at hierarchy node level (department/category/class). Critical for OTB budget management, GMROI tracking, inventory turn targets, and monthly financial planning cy',
    `price_strategy_id` BIGINT COMMENT 'Foreign key linking to pricing.price_strategy. Business justification: Merchandise plans incorporate pricing strategy assumptions for revenue and margin planning. Planned AUR, markdown budget, and margin targets depend on the pricing strategy (EDLP yields different markd',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_definition. Business justification: Merchandise plans track performance against specific KPIs (GMROI, sell-through, inventory turns). Planning systems reference KPI definitions for target setting, variance calculation, and performance d',
    `associate_id` BIGINT COMMENT 'Reference to the merchandise planner who created and maintains this financial plan.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Merchandise plans roll up to profit centers (store clusters, channels, regions) for segment P&L reporting and profitability analysis. Required for management reporting and segment performance evaluati',
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
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Assortment planning activities and associated costs (labor, systems, travel) are allocated to cost centers for expense tracking and budget management. Required for planning department cost control.',
    `department_id` BIGINT COMMENT 'Reference to the retail department responsible for this assortment plan. Used for organizational accountability and P&L (Profit and Loss) tracking.',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.store_format. Business justification: Assortment plans are format-specific; small-format stores receive different SKU mixes than hypermarkets. Real business process: merchandising teams create format-tailored assortment plans based on spa',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Assortment plans target specific merchandise hierarchy nodes for breadth/depth planning. Essential for OTB budget allocation, SKU rationalization, and assortment performance tracking against category',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Assortment plans are often coordinated with marketing campaigns (e.g., seasonal assortments aligned with seasonal campaigns). This links merchandising planning to marketing execution. No visible redun',
    `price_strategy_id` BIGINT COMMENT 'Foreign key linking to pricing.price_strategy. Business justification: Assortment plans reference pricing strategies for financial planning. Planned sales and margin calculations require pricing strategy assumptions (average markdown depth, promotional frequency). Strate',
    `associate_id` BIGINT COMMENT 'Reference to the merchandise planner responsible for financial planning, OTB (Open to Buy) management, and inventory allocation for this assortment plan.',
    `category_id` BIGINT COMMENT 'Reference to the merchandise category this assortment plan covers. Links to the product category hierarchy for strategic alignment.',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_definition. Business justification: Assortment plans measure success via KPIs (GMROI, sell-through rate, inventory turns). Planning teams configure dashboards and reports that reference these KPI definitions for consistent performance t',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Assortment plans are executed within profit center boundaries (channels, regions, store formats) for revenue attribution and channel-specific P&L reporting. Essential for channel assortment profitabil',
    `report_subscription_id` BIGINT COMMENT 'Foreign key linking to analytics.report_subscription. Business justification: Assortment planners receive automated reports (SKU performance, assortment gap analysis, compliance tracking). Planning teams configure subscriptions for regular plan reviews. Each assortment plan can',
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
    `buyer_id` BIGINT COMMENT 'Reference to the buyer responsible for procurement and vendor negotiations for this category. Typically assigned at department or category level.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Category management teams operate within cost center structures for salary, travel, and operating expense allocation. Required for category team budget management and headcount planning.',
    `parent_category_id` BIGINT COMMENT 'Reference to the parent node in the merchandise hierarchy. Null for top-level departments.',
    `associate_id` BIGINT COMMENT 'Reference to the merchandise planner responsible for assortment planning, OTB (Open to Buy) management, and inventory strategy for this category.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Product categories are subject to regulatory compliance programs (food safety for grocery, toy safety for childrens products, hazmat for chemicals, tobacco licensing). Category managers must understa',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Categories are managed at profit center level for P&L ownership and accountability. Required for category P&L reporting by channel, region, or store format.',
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
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Buyers are assigned to cost centers for salary, benefits, and operating expense allocation. Essential for buyer team budget management, headcount planning, and cost allocation.',
    `associate_id` BIGINT COMMENT 'Human resources employee identifier linking the buyer to the workforce management system. Used for payroll, performance tracking, and organizational hierarchy.',
    `semantic_layer_entity_id` BIGINT COMMENT 'Foreign key linking to analytics.semantic_layer_entity. Business justification: Buyer is a standard dimension in merchandising analytics. Performance reports, buying activity dashboards, and vendor negotiation analytics all dimension by buyer. Semantic layer defines buyer entity',
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
    `semantic_layer_entity_id` BIGINT COMMENT 'Foreign key linking to analytics.semantic_layer_entity. Business justification: Season is a fundamental time-based dimension in retail analytics. Sales planning, inventory forecasting, and assortment analysis all use season as a key dimension. Semantic layer defines season entity',
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
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: OTB budgets require a designated budget owner/planner for accountability, approval workflows, and audit trails. Retail operations track who is responsible for managing each budget allocation. Existing',
    `buyer_id` BIGINT COMMENT 'Reference to the merchandise buyer responsible for managing this OTB budget. The buyer has authority to commit purchases within the available budget balance.',
    `category_id` BIGINT COMMENT 'Reference to the merchandise category within the department for which this OTB budget applies. Categories provide finer product segmentation (e.g., Mens Shirts, Laptops, Bedding).',
    `cluster_id` BIGINT COMMENT 'Reference to the store cluster or store group for which this OTB budget is allocated. Store clusters group stores with similar assortment needs, demographics, or performance characteristics.',
    `department_id` BIGINT COMMENT 'Reference to the merchandise department for which this OTB budget is allocated. Departments represent high-level product groupings (e.g., Apparel, Electronics, Home Goods).',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: OTB budgets map to specific GL accounts (inventory, COGS) for financial posting when purchase orders are received. Required for three-way match, GL coding, and financial statement preparation.',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_definition. Business justification: OTB budget tracking measures performance against KPIs (gmroi_target, inventory_turn_target, sell_through_target_pct). Budget variance reports reference KPI definitions for standardized calculation for',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: OTB budgets are allocated to specific merchandise hierarchy nodes. Essential for buyer authority limits, budget reconciliation, receipt planning, and financial control in retail buying operations and',
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
    `buyer_id` BIGINT COMMENT 'Identifier of the merchandise buyer or purchasing agent responsible for creating and managing this buying order. Links to workforce/employee master data.',
    `category_id` BIGINT COMMENT 'Identifier of the product category within the department. Enables category-level assortment analysis and GMROI (Gross Margin Return on Investment) tracking.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Purchase orders for fixtures, supplies, or capital items are allocated to cost centers for capex vs opex classification and budget tracking. Required for non-inventory purchase cost allocation.',
    `department_id` BIGINT COMMENT 'Identifier of the merchandise department for which this buying order is placed. Used for category management and assortment planning.',
    `location_id` BIGINT COMMENT 'Identifier of the specific distribution center, store, or cross-dock facility where the merchandise will be received. Links to inventory node or store master data.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Purchase orders post to specific GL accounts (inventory, prepaid, expense) when goods are received. Essential for three-way match, accrual accounting, and financial statement accuracy.',
    `license_permit_id` BIGINT COMMENT 'Foreign key linking to compliance.license_permit. Business justification: Import buying orders for regulated categories (alcohol, tobacco, pharmaceuticals, firearms) require valid import licenses. Customs brokers verify license validity before shipment. Real business proces',
    `otb_budget_id` BIGINT COMMENT 'Identifier of the OTB (Open to Buy) budget allocation against which this buying order is committed. Used to track spending against merchandise financial plans and prevent over-buying.',
    `associate_id` BIGINT COMMENT 'Identifier of the user (merchandise manager or authorized approver) who provided final approval for the buying order. Links to workforce/employee master data.',
    `fulfillment_node_id` BIGINT COMMENT 'Foreign key linking to fulfillment.node. Business justification: Inbound purchase orders must specify receiving DC/warehouse for inventory routing and capacity planning. Retail operations require knowing which fulfillment node will process incoming vendor shipments',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Buying orders are executed within specific retail seasons for merchandise planning and OTB budget tracking. Currently has season_code (STRING) which should be normalized to season_id FK. This links bu',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Retail buying orders (merchandising procurement intent) are executed as supply chain purchase orders. Buyers track PO execution status, receipt variance, and landed cost reconciliation. This link enab',
    `vendor_id` BIGINT COMMENT 'Identifier of the supplier from whom the merchandise is being purchased. Links to the supplier master data in MDM (Master Data Management).',
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
    `buyer_id` BIGINT COMMENT 'Reference to the merchandise buyer responsible for this purchase decision. Used for accountability tracking and buyer performance analysis.',
    `category_id` BIGINT COMMENT 'Reference to the merchandise class within the department. Provides finer-grained categorization for assortment depth and breadth analysis.',
    `buying_order_id` BIGINT COMMENT 'Reference to the parent buying order header. Links this line item to the overall purchase order placed with the vendor.',
    `buying_subclass_category_id` BIGINT COMMENT 'Reference to the merchandise subclass within the class. Enables detailed category performance tracking and assortment optimization at the most granular level.',
    `department_id` BIGINT COMMENT 'Reference to the merchandise department or category to which this SKU belongs. Used for OTB (Open to Buy) budget tracking and category management reporting.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Individual PO lines may post to different GL accounts based on product type (inventory vs supplies vs capital). Required for line-level GL coding and mixed-item purchase order accounting.',
    `otb_budget_id` BIGINT COMMENT 'Reference to the OTB budget against which this line item is committed. Enables tracking of buying commitments against planned budgets by category, season, and time period.',
    `po_line_id` BIGINT COMMENT 'Foreign key linking to supplychain.po_line. Business justification: Line-level traceability from merchandising buy to supply chain PO line is essential for cost reconciliation, receipt matching, and variance analysis. Retail buyers need to track which supply chain PO',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Buying order line items are allocated to specific seasons for inventory planning and sell-through tracking. Currently has season_code (STRING) which should be normalized to season_id FK. Line-level se',
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
    `gtin` STRING COMMENT '14-digit Global Trade Item Number for international product identification. Enables cross-border supply chain visibility and EDI transactions.. Valid values are `^[0-9]{14}$`',
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
    `product_description` STRING COMMENT 'Detailed textual description of the merchandise item being ordered. Includes product name, attributes, size, color, and other distinguishing characteristics.',
    `received_quantity` DECIMAL(18,2) COMMENT 'Actual quantity received to date for this line item. Used for fill rate calculation, vendor performance tracking, and identifying short shipments or overages.',
    `retail_price` DECIMAL(18,2) COMMENT 'Planned retail selling price for this SKU at the time of order placement. Used for initial margin calculation and pricing strategy execution.',
    `sku` STRING COMMENT 'Internal stock keeping unit identifier for the merchandise item being purchased. Unique identifier used for inventory tracking and assortment management.. Valid values are `^[A-Z0-9]{8,14}$`',
    `store_cluster_code` STRING COMMENT 'Code identifying the store cluster or group for which this merchandise is allocated. Enables assortment planning by store type, geography, or performance tier.. Valid values are `^[A-Z0-9]{2,10}$`',
    `unit_cost` DECIMAL(18,2) COMMENT 'Cost per unit paid to the vendor for this SKU. Represents the negotiated wholesale price and is used for COGS (Cost of Goods Sold) calculation and margin analysis.',
    `upc` STRING COMMENT '12-digit Universal Product Code barcode identifier for the product. Used for point-of-sale scanning and supply chain tracking.. Valid values are `^[0-9]{12}$`',
    `vendor_style_number` STRING COMMENT 'Vendor-assigned style or model number for this product. Used for cross-referencing with vendor catalogs and facilitating reorder processes.',
    CONSTRAINT pk_buying_order_line PRIMARY KEY(`buying_order_line_id`)
) COMMENT 'Line-level detail of a merchandise buying order capturing individual SKU commitments including SKU/UPC, ordered quantity, unit cost, retail price, planned margin, delivery date, and allocation by store cluster. Enables SKU-level OTB tracking and receipt planning.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` (
    `merchandising_planogram_id` BIGINT COMMENT 'Unique identifier for the planogram record. Primary key.',
    `category_id` BIGINT COMMENT 'Reference to the product category that this planogram is designed for, enabling category-specific space allocation and assortment planning.',
    `cluster_id` BIGINT COMMENT 'Reference to the store cluster or format group that this planogram is designed for, enabling tailored assortments by store type, size, or demographic profile.',
    `department_id` BIGINT COMMENT 'Reference to the retail department that owns this planogram, supporting departmental merchandising strategies and accountability.',
    `associate_id` BIGINT COMMENT 'Reference to the merchandiser or category manager responsible for creating and maintaining this planogram.',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Planograms are often seasonal (seasonal_flag exists, season_name STRING exists). Currently stores season_name as string which should be normalized to season_id FK. This enables linking planogram reset',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the planogram was formally approved for deployment, marking the transition from draft to approved status.',
    `compliance_required_flag` BOOLEAN COMMENT 'Indicates whether strict compliance to this planogram is mandatory for stores, or if local merchandising teams have flexibility to adapt the layout.',
    `compliance_tolerance_pct` DECIMAL(18,2) COMMENT 'Acceptable deviation percentage from the planogram specification before a store is considered non-compliant. Used in compliance audits and store execution scoring.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the planogram record was first created in the system, supporting audit trail and lifecycle tracking.',
    `effective_end_date` DATE COMMENT 'Date when the planogram is scheduled to be retired or replaced. Nullable for open-ended planograms that remain active until explicitly superseded.',
    `effective_start_date` DATE COMMENT 'Date when the planogram becomes active and should be implemented in stores. Critical for seasonal resets and promotional planning.',
    `fixture_depth_cm` DECIMAL(18,2) COMMENT 'Depth of the fixture in centimeters, determining how far products can be placed from the front edge.',
    `fixture_height_cm` DECIMAL(18,2) COMMENT 'Total height of the fixture in centimeters, defining the vertical space available across all shelves.',
    `fixture_type` STRING COMMENT 'Type of physical merchandising fixture that this planogram is designed for, determining the layout constraints and display capabilities.. Valid values are `gondola|endcap|pegboard|shelf|cooler|freezer`',
    `fixture_width_cm` DECIMAL(18,2) COMMENT 'Total width of the fixture in centimeters, defining the horizontal space available for product placement.',
    `implementation_instructions` STRING COMMENT 'Detailed instructions for store teams on how to implement the planogram, including reset procedures, product placement guidelines, and special handling requirements.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the planogram record was last updated, supporting change tracking and version control.',
    `last_reset_date` DATE COMMENT 'Date when stores last executed a full reset to this planogram, used to track implementation currency and compliance timing.',
    `merchandising_planogram_status` STRING COMMENT 'Current lifecycle status of the planogram indicating whether it is in development, approved for deployment, actively in use in stores, or retired from use.. Valid values are `draft|approved|active|inactive|archived`',
    `next_scheduled_reset_date` DATE COMMENT 'Date when the next planogram reset or refresh is scheduled, supporting forward planning and resource allocation for store operations.',
    `planogram_code` STRING COMMENT 'Externally-known unique business identifier for the planogram, typically following a POG- prefix convention used in space planning systems and merchandising communications.. Valid values are `^POG-[A-Z0-9]{6,12}$`',
    `planogram_name` STRING COMMENT 'Human-readable descriptive name of the planogram, typically including category and fixture type for easy identification by merchandising teams.',
    `seasonal_flag` BOOLEAN COMMENT 'Indicates whether this planogram is designed for a specific season or promotional period, requiring periodic reset and rotation.',
    `shelf_count` STRING COMMENT 'Total number of shelves or levels in the fixture, determining the vertical product capacity.',
    `space_allocation_sqft` DECIMAL(18,2) COMMENT 'Total square footage of selling space allocated to this planogram, calculated from fixture dimensions and used for space productivity analysis.',
    `space_planning_system_code` STRING COMMENT 'External identifier from the space planning or planogram software system (e.g., JDA Space Planning, Apollo, Shelf Logic) used to create this planogram, enabling integration and synchronization.',
    `target_gmroi` DECIMAL(18,2) COMMENT 'Target GMROI metric for this planogram, representing the expected gross margin dollars returned for every dollar of average inventory investment. Key performance indicator for space productivity.',
    `target_sales_per_sqft` DECIMAL(18,2) COMMENT 'Target sales revenue per square foot of shelf space allocated to this planogram, used to measure space productivity and merchandising effectiveness.',
    `total_facings` STRING COMMENT 'Total number of product facings (individual product positions visible to customers) allocated across all shelves in the planogram. Key metric for assortment breadth and inventory capacity.',
    `total_sku_count` STRING COMMENT 'Total number of unique SKUs included in the planogram, representing the assortment depth for the category.',
    `version_number` STRING COMMENT 'Version identifier for the planogram, allowing tracking of revisions and updates to shelf layouts over time. Typically follows semantic versioning (e.g., 1.0, 1.1, 2.0).. Valid values are `^[0-9]{1,3}.[0-9]{1,3}$`',
    `visual_merchandising_notes` STRING COMMENT 'Additional notes on visual merchandising principles, color blocking, brand adjacencies, and aesthetic considerations for this planogram.',
    CONSTRAINT pk_merchandising_planogram PRIMARY KEY(`merchandising_planogram_id`)
) COMMENT 'Master record for planograms (POGs) defining the visual merchandising layout and shelf space allocation for a category within a store or store cluster. Captures planogram name, version, effective dates, fixture type (gondola, endcap, pegboard), number of facings, shelf dimensions, and compliance status. Integrates with space planning systems.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` (
    `planogram_position_id` BIGINT COMMENT 'Primary key for planogram_position',
    `merchandising_planogram_id` BIGINT COMMENT 'Reference to the parent planogram that contains this position. Links to the planogram master record defining the overall shelf layout.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Planogram compliance audits, space productivity analysis, and reset execution require linking shelf positions to master SKU data for dimensions, images, and inventory integration. Essential for store',
    `bay_number` STRING COMMENT 'The bay or section number within the planogram where this position is located. Defines horizontal segmentation of the fixture.',
    `capacity_units` STRING COMMENT 'The total number of product units that can be stocked at this position based on the allocated space and product dimensions. Drives replenishment planning.',
    `compliance_score` DECIMAL(18,2) COMMENT 'The compliance score (0-100%) measuring how accurately this position is executed in stores. Calculated from store audits comparing actual shelf placement to planogram specifications.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this planogram position record was first created in the system. Used for audit trail and data lineage tracking.',
    `display_orientation` STRING COMMENT 'The orientation in which the product should be displayed at this position (e.g., front-facing, side-facing, top-facing). Impacts visual merchandising and brand presentation.. Valid values are `front|side|top|angled|stacked`',
    `effective_end_date` DATE COMMENT 'The date when this planogram position is no longer active and the SKU should be removed or relocated. Nullable for open-ended positions.',
    `effective_start_date` DATE COMMENT 'The date when this planogram position becomes active and the SKU should be placed at this location. Supports seasonal resets and promotional planogram changes.',
    `facing_count` STRING COMMENT 'The number of product facings (front-facing units visible to the customer) allocated to this SKU at this position. Drives shelf capacity and visual prominence.',
    `fixture_type` STRING COMMENT 'The type of retail fixture where this position is located (gondola, endcap, peg hook, shelf, bin, cooler, freezer, display table). Defines the physical merchandising environment. [ENUM-REF-CANDIDATE: gondola|endcap|peg_hook|shelf|bin|cooler|freezer|display_table — 8 candidates stripped; promote to reference product]',
    `is_hero_position` BOOLEAN COMMENT 'Flag indicating whether this is a hero or focal position within the planogram. Hero positions receive maximum visibility and are typically assigned to top-performing or strategic SKUs.',
    `is_new_item` BOOLEAN COMMENT 'Flag indicating whether this position is designated for new product introductions. Used to highlight new SKUs and drive trial purchases.',
    `is_promotional` BOOLEAN COMMENT 'Flag indicating whether this position is designated for promotional merchandise. Promotional positions may have temporary SKU assignments and special signage.',
    `last_audit_date` DATE COMMENT 'The date when this planogram position was last audited for compliance. Used to track audit frequency and identify positions requiring re-verification.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this planogram position record was last modified. Tracks the most recent update to any attribute of this position.',
    `maximum_facings` STRING COMMENT 'The maximum number of facings allowed for this SKU at this position. Prevents over-allocation and ensures balanced assortment presentation.',
    `merchandising_zone` STRING COMMENT 'The vertical merchandising zone classification for this position (eye level, reach level, stoop level, stretch level). Eye-level positions typically drive higher sales velocity.. Valid values are `eye_level|reach_level|stoop_level|stretch_level`',
    `minimum_facings` STRING COMMENT 'The minimum number of facings required for this SKU to maintain adequate shelf presence and avoid out-of-stock appearance. Used for compliance auditing.',
    `notes` STRING COMMENT 'Free-text notes providing additional context or special instructions for this planogram position (e.g., special handling, vendor requirements, seasonal considerations).',
    `position_depth_cm` DECIMAL(18,2) COMMENT 'The depth in centimeters from the front of the shelf to the back, allocated to this position. Determines how many units can be stocked front-to-back.',
    `position_height_cm` DECIMAL(18,2) COMMENT 'The vertical height in centimeters allocated to this position. Defines the vertical space occupied by the product at this shelf location.',
    `position_sequence` STRING COMMENT 'Sequential ordering of this position within the planogram. Used to define left-to-right or top-to-bottom placement order on the shelf.',
    `position_status` STRING COMMENT 'Current lifecycle status of this planogram position. Active positions are currently in use; inactive positions are no longer merchandised; pending positions are scheduled for future activation.. Valid values are `active|inactive|pending|discontinued`',
    `position_width_cm` DECIMAL(18,2) COMMENT 'The horizontal width in centimeters allocated to this position on the shelf. Used for space productivity analysis and fixture capacity planning.',
    `priority_rank` STRING COMMENT 'The priority ranking of this position within the planogram. Higher-priority positions receive preferential placement and are critical for category performance.',
    `sales_velocity_rank` STRING COMMENT 'The sales velocity ranking of the SKU at this position relative to other positions in the same planogram. Used to optimize high-performing SKU placement.',
    `shelf_number` STRING COMMENT 'The shelf level number where this SKU is positioned. Typically numbered from bottom (1) to top, defining vertical placement within the gondola or fixture.',
    `signage_required` BOOLEAN COMMENT 'Flag indicating whether special signage (price, promotional, informational) is required at this position. Drives in-store execution and compliance auditing.',
    `space_productivity_index` DECIMAL(18,2) COMMENT 'A calculated index measuring the revenue or profit generated per unit of shelf space allocated to this position. Used to optimize space allocation and maximize category GMROI.',
    `version_number` STRING COMMENT 'The version number of the planogram to which this position belongs. Supports planogram versioning and historical analysis of assortment changes.',
    CONSTRAINT pk_planogram_position PRIMARY KEY(`planogram_position_id`)
) COMMENT 'Individual SKU position within a planogram defining shelf placement, facing count, minimum and maximum facings, shelf number, position sequence, and display orientation. Captures the authoritative shelf-level assortment for each planogram version. Enables compliance auditing and space productivity analysis.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` (
    `assortment_item_id` BIGINT COMMENT 'Unique identifier for the assortment item record. Primary key for this association between SKU, assortment plan, store cluster, and season.',
    `assortment_plan_id` BIGINT COMMENT 'Reference to the parent assortment plan that defines the strategic merchandise mix for a specific season and store cluster.',
    `cluster_id` BIGINT COMMENT 'Reference to the store cluster grouping that this assortment item applies to. Store clusters group locations by similar demographics, performance, or format.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Individual SKUs are featured in marketing campaigns as hero products, promotional items, or new arrivals. Retailers track which SKUs are featured in which campaigns for promotional planning, inventory',
    `season_id` BIGINT COMMENT 'Reference to the merchandising season (e.g., Spring 2024, Holiday 2024) for which this assortment item is planned.',
    `sku_id` BIGINT COMMENT 'Reference to the specific product SKU included in this assortment plan.',
    `vendor_id` BIGINT COMMENT 'Reference to the primary supplier providing this SKU. Critical for vendor performance tracking, negotiations, and supply chain management.',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` (
    `vendor_negotiation_id` BIGINT COMMENT 'Unique identifier for the vendor negotiation event. Primary key for this data product.',
    `associate_id` BIGINT COMMENT 'Reference to the user or manager who provided final approval for the negotiation. Links to workforce or user master data for audit trail.',
    `buyer_id` BIGINT COMMENT 'Reference to the internal buyer or merchandising manager who conducted the negotiation. Links to workforce or employee master data.',
    `category_id` BIGINT COMMENT 'Reference to the primary product category or department covered by this negotiation. Used for category management and assortment planning analysis.',
    `department_id` BIGINT COMMENT 'Reference to the merchandising department responsible for this negotiation. Supports departmental GMROI and OTB budget tracking.',
    `corrective_action_id` BIGINT COMMENT 'Foreign key linking to compliance.corrective_action. Business justification: Ethical sourcing programs conduct vendor audits (labor practices, safety, environmental). When violations are found, corrective action plans are negotiated into supply agreements with cost/term adjust',
    `vendor_contract_id` BIGINT COMMENT 'add column vendor_contract_id (BIGINT) with FK to supplier.vendor_contract.vendor_contract_id - negotiations result in contracts and need this linkage for procurement lifecycle tracking',
    `vendor_id` BIGINT COMMENT 'Reference to the supplier or vendor involved in this negotiation. Links to the supplier master data managed by the supplier domain.',
    `allowance_amount` DECIMAL(18,2) COMMENT 'Total allowance or rebate amount negotiated with the supplier, typically as a lump sum or per-unit credit. Used to calculate net cost and GMROI.',
    `allowance_type` STRING COMMENT 'Classification of the allowance indicating its purpose and accounting treatment. Supports revenue recognition and vendor compliance tracking.. Valid values are `volume_rebate|early_payment_discount|promotional_allowance|markdown_support|slotting_fee|other`',
    `approval_status` STRING COMMENT 'Approval status indicating whether the negotiated terms have been formally approved by the authorized buyer or merchandising manager. Required for execution.. Valid values are `pending|approved|rejected|conditional`',
    `approval_timestamp` TIMESTAMP COMMENT 'Timestamp when the negotiation was formally approved. Critical for audit trail and compliance reporting.',
    `contract_reference_number` STRING COMMENT 'Reference to the master contract or purchase agreement that governs this negotiation. Links to contract management system for legal terms and conditions.',
    `coop_advertising_fund` DECIMAL(18,2) COMMENT 'Cooperative advertising funds committed by the supplier to support joint marketing and promotional campaigns. Tracked separately for marketing budget allocation.',
    `cost_change_percentage` DECIMAL(18,2) COMMENT 'Percentage change from old cost to new cost, calculated as ((new_cost - old_cost) / old_cost) * 100. Positive values indicate cost increases, negative indicate decreases.',
    `cost_change_reason_code` STRING COMMENT 'Standardized reason code explaining the driver of the cost change. Critical for cost variance analysis and procurement strategy. [ENUM-REF-CANDIDATE: commodity_inflation|contract_renewal|tariff_change|volume_discount|quality_upgrade|currency_fluctuation|freight_adjustment|other — 8 candidates stripped; promote to reference product]',
    `cost_change_reason_description` STRING COMMENT 'Free-text detailed explanation of the cost change rationale provided by the buyer or supplier. Supplements the reason code with context.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this negotiation record was first created in the system. Part of standard audit trail for data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this negotiation (cost prices, allowances, co-op funds). Typically base currency of the retailer.. Valid values are `^[A-Z]{3}$`',
    `effective_date` DATE COMMENT 'Date from which the negotiated terms become binding and operational. Critical for cost change tracking and financial planning.',
    `expiration_date` DATE COMMENT 'Date when the negotiated terms expire and require renewal or renegotiation. Nullable for open-ended agreements.',
    `fill_rate_commitment_percentage` DECIMAL(18,2) COMMENT 'Suppliers committed fill rate percentage (order completion rate) as part of the service level agreement. Measured as percentage of ordered quantity delivered on time.',
    `incoterms` STRING COMMENT 'International commercial terms defining the responsibilities, costs, and risks between buyer and supplier for shipment. Standard codes such as FOB, CIF, DDP. [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF — 11 candidates stripped; promote to reference product]',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this negotiation record was last updated. Tracks the most recent change for audit and data quality purposes.',
    `lead_time_days` STRING COMMENT 'Negotiated lead time in days from purchase order placement to goods receipt at distribution center. Critical for inventory planning and weeks of supply calculations.',
    `markdown_support_amount` DECIMAL(18,2) COMMENT 'Specific amount committed by the supplier to support markdown or clearance activities. Critical for margin protection and sell-through rate optimization.',
    `moq` STRING COMMENT 'Minimum order quantity required by the supplier per purchase order. Critical constraint for OTB planning and replenishment strategy.',
    `moq_unit_of_measure` STRING COMMENT 'Unit of measure for the MOQ field (e.g., each, case, pallet). Ensures correct interpretation of MOQ constraints.. Valid values are `each|case|pallet|container|unit`',
    `negotiation_end_date` DATE COMMENT 'Date when the negotiation was concluded, either through agreement, rejection, or cancellation. Nullable for ongoing negotiations.',
    `negotiation_notes` STRING COMMENT 'Free-text notes capturing key discussion points, special conditions, or context from the negotiation. Supports knowledge transfer and future negotiations.',
    `negotiation_number` STRING COMMENT 'Business-facing unique identifier for the vendor negotiation event, typically formatted as VN-YYYYMMDD or similar pattern used in the retail merchandising system Merchandising System (ORMS).. Valid values are `^VN-[0-9]{8}$`',
    `negotiation_start_date` DATE COMMENT 'Date when the negotiation discussions formally commenced. Represents the beginning of the negotiation lifecycle.',
    `negotiation_status` STRING COMMENT 'Current lifecycle status of the negotiation event. Tracks progression from draft through approval to execution or cancellation. [ENUM-REF-CANDIDATE: draft|in_progress|pending_approval|approved|rejected|executed|cancelled — 7 candidates stripped; promote to reference product]',
    `negotiation_type` STRING COMMENT 'Classification of the negotiation event indicating the primary purpose: initial contract establishment, contract renewal, cost change request, markdown support negotiation, promotional allowance, or annual review.. Valid values are `initial_contract|contract_renewal|cost_change|markdown_support|promotional_allowance|annual_review`',
    `new_cost_price` DECIMAL(18,2) COMMENT 'Newly negotiated cost price per unit effective from the effective_date. Single source of truth for supplier commercial terms. Stored in base currency.',
    `old_cost_price` DECIMAL(18,2) COMMENT 'Previous cost price per unit before the negotiation. Used to calculate cost change impact and COGS variance. Stored in base currency.',
    `payment_terms` STRING COMMENT 'Negotiated payment terms with the supplier, typically expressed as Net 30, Net 60, 2/10 Net 30, etc. Impacts cash flow and working capital management.',
    `source_system_code` STRING COMMENT 'Unique identifier of this negotiation record in the source operational system. Enables traceability and reconciliation back to the system of record.',
    CONSTRAINT pk_vendor_negotiation PRIMARY KEY(`vendor_negotiation_id`)
) COMMENT 'Record of vendor negotiation events and resulting commercial terms including agreed cost prices, cost change records (old cost, new cost, effective date, reason code such as commodity inflation, contract renewal, or tariff change, buyer approval status), allowances, markdown support, co-op advertising funds, MOQ (Minimum Order Quantity), lead times, and fill rate commitments. Captures both negotiation-level header and SKU-level cost change lines as the single source of truth for all supplier commercial terms and cost adjustments. Distinct from the supplier master (owned by supplier domain). Sourced from ORMS cost management and vendor negotiation modules.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` (
    `markdown_event_id` BIGINT COMMENT 'Unique identifier for the markdown event record. Primary key.',
    `alert_id` BIGINT COMMENT 'Foreign key linking to analytics.analytics_alert. Business justification: Markdown performance issues trigger alerts (sell-through lift below projection, margin impact exceeds threshold). Pricing teams receive alerts for markdown strategy adjustment. Each markdown event can',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Markdown events are frequently coordinated with marketing campaigns (clearance sales, seasonal promotions, flash sales). Retail operations track which campaign drove the markdown to measure promotiona',
    `category_id` BIGINT COMMENT 'Identifier of the product category affected by this markdown event when the markdown applies to an entire category rather than individual SKUs. Supports category-level clearance and promotional strategies.',
    `cluster_id` BIGINT COMMENT 'Identifier of the store cluster or group to which this markdown applies. Enables regional or performance-based markdown strategies. Null indicates enterprise-wide markdown.',
    `audit_finding_id` BIGINT COMMENT 'Foreign key linking to compliance.audit_finding. Business justification: Markdowns triggered by compliance issues (expired food, product recalls, mislabeled goods, safety violations) reference the originating audit finding for financial reconciliation and root cause analys',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Markdowns may be allocated to cost centers for promotional expense tracking and marketing budget management. Required when markdown events are funded by specific promotional budgets or departments.',
    `department_id` BIGINT COMMENT 'Identifier of the merchandise department affected by this markdown event when the markdown applies at department level. Enables department-wide pricing strategies.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Markdowns post to specific GL accounts (markdown expense, promotional allowance, inventory write-down) for P&L impact. Required for markdown accounting, gross margin reporting, and financial statement',
    `price_zone_id` BIGINT COMMENT 'Foreign key linking to pricing.price_zone. Business justification: Markdown events execute in specific price zones for regional clearance strategies. Geographic zones have different clearance timing needs based on climate, competitive intensity, and inventory positio',
    `associate_id` BIGINT COMMENT 'Identifier of the merchandising manager, buyer, or finance approver who authorized this markdown event. Null for markdowns not requiring approval or still pending approval. Critical for audit trail and accountability.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Markdowns are tracked by profit center (store cluster, channel, region) for margin impact analysis and promotional effectiveness. Essential for channel/region markdown P&L reporting and performance ev',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Markdowns are often coordinated with promotional campaigns (clearance events, seasonal transitions). Merchandising and promotion teams collaborate on timing, depth, and marketing support. Essential fo',
    `sku_id` BIGINT COMMENT 'Identifier of the specific SKU affected by this markdown event. Links to product master data. Null when markdown applies to category or department level.',
    `tertiary_markdown_modified_by_user_associate_id` BIGINT COMMENT 'Identifier of the user who last modified this markdown event record. Used for change tracking and audit trail. Null if record has never been modified after creation.',
    `vendor_allowance_id` BIGINT COMMENT 'Identifier linking to vendor markdown support or co-op agreement where the supplier shares markdown cost burden. Null when markdown is fully retailer-funded. Critical for vendor chargeback and Return to Vendor (RTV) processing.',
    `actual_margin_impact` DECIMAL(18,2) COMMENT 'Realized gross margin dollar impact of the markdown event, calculated from actual sales and COGS data. Used for post-markdown profitability analysis and GMROI performance measurement. Null until markdown period completes.',
    `actual_revenue_impact` DECIMAL(18,2) COMMENT 'Realized total revenue impact of the markdown event, calculated from actual sales data. Used for post-markdown financial analysis and Return on Investment (ROI) measurement. Null until markdown period completes.',
    `actual_sell_through_lift_percentage` DECIMAL(18,2) COMMENT 'Realized increase in sell-through rate after the markdown was executed, expressed as a percentage. Measured post-markdown for effectiveness analysis and future markdown planning. Null until markdown period completes.',
    `actual_units_sold` STRING COMMENT 'Realized quantity of units sold during the markdown period. Captured from Point of Sale (POS) transaction data for markdown effectiveness measurement. Null until markdown period completes.',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether this markdown event requires formal approval based on markdown amount thresholds, markdown percentage limits, or organizational authorization policies. True requires approval workflow; false allows auto-execution.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the markdown event was formally approved. Null for markdowns not requiring approval or still pending. Used for approval cycle time analysis and compliance reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this markdown event record was first created in the system. Audit field for data lineage and markdown planning lead time analysis.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this markdown event (original_price, markdown_price, markdown_amount). Supports multi-currency retail operations.. Valid values are `^[A-Z]{3}$`',
    `effective_date` DATE COMMENT 'Date when the markdown pricing becomes active and applicable to transactions. Aligns with Point of Sale (POS) system pricing updates and promotional calendar.',
    `end_date` DATE COMMENT 'Date when the markdown pricing expires and reverts to standard or new pricing. Null for permanent markdowns. Critical for temporary and promotional markdown management.',
    `markdown_amount` DECIMAL(18,2) COMMENT 'The absolute dollar value reduction per unit, calculated as original_price minus markdown_price. Used for total markdown dollar impact calculation and Gross Margin Return on Investment (GMROI) analysis.',
    `markdown_number` STRING COMMENT 'Business identifier for the markdown event, typically formatted as MD-YYYYMMDD-NNNN for traceability and external reference.. Valid values are `^MD-[0-9]{8}-[0-9]{4}$`',
    `markdown_percentage` DECIMAL(18,2) COMMENT 'The percentage reduction from original price to markdown price, calculated as ((original_price - markdown_price) / original_price) * 100. Key metric for promotional intensity and margin sacrifice analysis.',
    `markdown_price` DECIMAL(18,2) COMMENT 'The new reduced retail price after the markdown is applied. Represents the new selling price point for the affected merchandise.',
    `markdown_reason` STRING COMMENT 'Business rationale for initiating the markdown event. Seasonal clearance indicates end-of-season inventory reduction; slow seller indicates poor sell-through performance; competitive response indicates market-driven pricing adjustment; end-of-life indicates product discontinuation; damaged indicates impaired merchandise; obsolete indicates outdated or superseded products.. Valid values are `seasonal_clearance|slow_seller|competitive_response|end_of_life|damaged|obsolete`',
    `markdown_status` STRING COMMENT 'Current lifecycle state of the markdown event. Draft indicates initial planning; pending approval indicates awaiting merchandising or finance authorization; approved indicates authorized but not yet effective; active indicates currently in effect; completed indicates markdown period has ended; cancelled indicates markdown was revoked before or during execution.. Valid values are `draft|pending_approval|approved|active|completed|cancelled`',
    `markdown_type` STRING COMMENT 'Classification of the markdown event indicating the nature and duration of the price reduction. Permanent markdowns are irreversible price changes; temporary markdowns are time-bound promotional reductions; clearance markdowns are end-of-season or end-of-life inventory liquidation.. Valid values are `permanent|temporary|promotional|clearance|competitive|damaged_goods`',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this markdown event record was last modified. Audit field for change tracking and data quality monitoring. Null if record has never been modified after creation.',
    `notes` STRING COMMENT 'Free-text field for additional context, business rationale, or special instructions related to the markdown event. Used for capturing merchandising strategy details, competitive intelligence, or execution guidance not captured in structured fields.',
    `original_price` DECIMAL(18,2) COMMENT 'The regular retail price before the markdown is applied. Represents the baseline Average Unit Retail (AUR) for margin impact calculation.',
    `projected_margin_impact` DECIMAL(18,2) COMMENT 'Forecasted gross margin dollar impact of the markdown event, accounting for Cost of Goods Sold (COGS) and markdown amount. Critical for Gross Margin Return on Investment (GMROI) target management and merchandising profitability planning.',
    `projected_revenue_impact` DECIMAL(18,2) COMMENT 'Forecasted total revenue impact of the markdown event, calculated as (markdown_price * projected_units_sold) minus baseline revenue. Negative values indicate revenue sacrifice; used for Profit and Loss (P&L) planning.',
    `projected_sell_through_lift_percentage` DECIMAL(18,2) COMMENT 'Forecasted increase in sell-through rate as a result of the markdown, expressed as a percentage. Used for markdown effectiveness planning and inventory turn optimization. Based on historical markdown elasticity models.',
    `projected_units_sold` STRING COMMENT 'Forecasted quantity of units expected to sell during the markdown period. Used for inventory planning and Open to Buy (OTB) budget impact assessment.',
    `vendor_contribution_amount` DECIMAL(18,2) COMMENT 'Dollar amount contributed by the vendor toward the markdown cost as per vendor support agreement. Used for vendor chargeback processing and net markdown cost calculation. Zero or null when no vendor support exists.',
    CONSTRAINT pk_markdown_event PRIMARY KEY(`markdown_event_id`)
) COMMENT 'Record of a planned or executed markdown decision capturing affected SKUs or category, store cluster scope, markdown type (permanent, temporary/POS), markdown percentage or new price point, effective and end dates, markdown reason (seasonal clearance, slow seller, competitive response, end-of-life, damaged), projected sell-through lift, actual sell-through result, and approval status. Represents the merchandising teams margin sacrifice decision distinct from pricing domain execution rules. Links to vendor markdown support agreements captured in vendor negotiations.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` (
    `private_label_program_id` BIGINT COMMENT 'Unique identifier for the private label program. Primary key.',
    `category_id` BIGINT COMMENT 'Reference to the primary merchandise category this private label program serves.',
    `cluster_id` BIGINT COMMENT 'Reference to the primary store cluster or format where this private label program is distributed (e.g., hypermarkets, discount stores, e-commerce only).',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Private label programs have dedicated cost centers for product development, quality control, packaging design, and marketing expenses. Required for private label program cost tracking and ROI analysis',
    `department_id` BIGINT COMMENT 'Reference to the merchandise department responsible for managing this private label program.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Private label launches require dedicated marketing campaigns for brand awareness and customer acquisition. Retailers track launch campaign performance to measure private label program ROI and market p',
    `price_strategy_id` BIGINT COMMENT 'Foreign key linking to pricing.price_strategy. Business justification: Private label programs have dedicated pricing strategies defining positioning vs. national brands (premium quality at mid-tier price, value tier). Strategy linkage enables consistent private label pri',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_definition. Business justification: Private label programs track specific KPIs (target_margin_premium_pct, target_gmroi, target_sell_through_rate_pct). Program performance dashboards reference KPI definitions for consistent measurement.',
    `associate_id` BIGINT COMMENT 'Reference to the merchandising manager or buyer responsible for managing this private label program.',
    `product_brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Private label programs manage specific retail brands. Links program strategy, budget, and margin targets to brand performance metrics. Critical for brand P&L reporting, margin analysis, and strategic',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Private label programs are managed at profit center level (channel, region, store format) for profitability analysis and margin contribution. Essential for private label P&L reporting by channel.',
    `certification_id` BIGINT COMMENT 'Foreign key linking to compliance.certification. Business justification: Private label programs require certifications (USDA Organic, Fair Trade, Non-GMO, GFSI food safety) to support marketing claims and regulatory compliance. Quality assurance validates certification sco',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Private label programs are often seasonal initiatives (seasonal_flag exists). Currently has season_name (STRING) which should be normalized to season_id FK. This links private label programs to the au',
    `vendor_id` BIGINT COMMENT 'Reference to the primary manufacturing supplier partner for this private label program.',
    `approval_date` DATE COMMENT 'Date when the private label program received final executive approval to proceed to launch.',
    `assortment_breadth_target` STRING COMMENT 'Target number of distinct SKUs (Stock Keeping Units) planned for this private label program across all subcategories.',
    `assortment_depth_target` STRING COMMENT 'Target number of variants (sizes, flavors, colors) within each SKU category for this private label program.',
    `competitive_positioning` STRING COMMENT 'Strategic market positioning of the private label program relative to national brand competitors.. Valid values are `premium_alternative|parity|value_alternative|discount`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this private label program record was first created in the merchandising system.',
    `discontinuation_date` DATE COMMENT 'Date when the private label program was or will be discontinued and removed from active assortment.',
    `exclusive_flag` BOOLEAN COMMENT 'Indicates whether this private label program is exclusive to this retailer (True) or shared with other retailers (False).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this private label program record was last updated in the merchandising system.',
    `launch_date` DATE COMMENT 'Planned or actual market launch date when the private label program became available to customers.',
    `lead_time_days` STRING COMMENT 'Standard supplier lead time in days from purchase order placement to delivery for this private label program.',
    `markdown_strategy` STRING COMMENT 'Pricing and markdown strategy applied to this private label program (EDLP = Everyday Low Price, Hi-Lo = High-Low promotional pricing).. Valid values are `edlp|hi_lo|seasonal_clearance|dynamic`',
    `marketing_investment_usd` DECIMAL(18,2) COMMENT 'Allocated marketing and promotional investment budget in USD for launching and supporting this private label program.',
    `minimum_order_quantity` STRING COMMENT 'MOQ (Minimum Order Quantity) required by the supplier for purchase orders under this private label program.',
    `otb_budget_amount` DECIMAL(18,2) COMMENT 'Allocated OTB (Open to Buy) budget amount in USD for purchasing inventory under this private label program for the current planning period.',
    `packaging_specification` STRING COMMENT 'Detailed packaging design specifications including materials, dimensions, labeling requirements, and branding guidelines for the private label program.',
    `program_code` STRING COMMENT 'Unique business identifier code for the private label program used across merchandising systems and supplier communications.. Valid values are `^[A-Z0-9]{6,12}$`',
    `program_description` STRING COMMENT 'Detailed business description of the private label program including strategic objectives, target customer segments, and value proposition.',
    `program_status` STRING COMMENT 'Current lifecycle status of the private label program indicating operational state and availability.. Valid values are `active|planning|pilot|discontinued|suspended|under_review`',
    `quality_control_protocol` STRING COMMENT 'Description of the quality control and inspection protocols applied to products in this private label program to ensure brand standards.',
    `quality_tier` STRING COMMENT 'Quality positioning tier of the private label program relative to national brands and competitive offerings.. Valid values are `premium|standard|value|economy`',
    `seasonal_flag` BOOLEAN COMMENT 'Indicates whether this private label program is seasonal (True) or year-round (False).',
    `sustainability_certification_type` STRING COMMENT 'Type of sustainability certification held by products in this private label program (e.g., USDA Organic, Fair Trade Certified, Rainforest Alliance).',
    `sustainability_certified_flag` BOOLEAN COMMENT 'Indicates whether products in this private label program carry sustainability certifications (e.g., organic, fair trade, carbon neutral).',
    `target_gmroi` DECIMAL(18,2) COMMENT 'Target GMROI (Gross Margin Return on Investment) goal for the private label program, measuring profitability efficiency.',
    `target_margin_premium_pct` DECIMAL(18,2) COMMENT 'Target gross margin premium percentage over comparable national brand products, representing the strategic margin advantage goal.',
    `target_price_point_usd` DECIMAL(18,2) COMMENT 'Strategic target retail price point in USD for the core SKUs in this private label program, positioned relative to national brand competitors.',
    `target_sell_through_rate_pct` DECIMAL(18,2) COMMENT 'Target sell-through rate percentage goal for inventory turnover efficiency in this private label program.',
    `vendor_managed_inventory_flag` BOOLEAN COMMENT 'Indicates whether this private label program operates under a VMI (Vendor Managed Inventory) agreement where the supplier manages replenishment.',
    CONSTRAINT pk_private_label_program PRIMARY KEY(`private_label_program_id`)
) COMMENT 'Master record for private label (store brand) programs capturing brand name, category scope, quality tier (premium, value, standard), target margin premium over national brands, supplier partnerships, packaging specifications, and launch timeline. Tracks the strategic private label portfolio managed by the merchandising team.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` (
    `category_campaign_placement_id` BIGINT COMMENT 'Unique identifier for this category-campaign placement record. Primary key.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to the marketing campaign featuring this category',
    `category_id` BIGINT COMMENT 'Foreign key linking to the merchandise category participating in this campaign',
    `actual_sales_amount` DECIMAL(18,2) COMMENT 'Actual sales revenue generated by this category during this campaign period. Used for post-campaign performance analysis and ROI calculation.',
    `actual_spend_amount` DECIMAL(18,2) COMMENT 'Actual marketing spend attributed to this category within this campaign. Used to calculate category-level campaign ROI.',
    `budget_allocation_amount` DECIMAL(18,2) COMMENT 'Portion of the total campaign budget allocated specifically to this category within this campaign. Used for planning and performance measurement.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this placement record was created in the system.',
    `effective_end_date` DATE COMMENT 'Date when this category placement ends within the campaign. May differ from overall campaign end if categories are phased out or rotated.',
    `effective_start_date` DATE COMMENT 'Date when this category placement becomes active within the campaign. May differ from overall campaign start if categories are phased in.',
    `is_featured` BOOLEAN COMMENT 'Indicates whether this category is featured or highlighted in campaign creative, signage, or digital placements. Featured categories typically receive premium positioning.',
    `placement_status` STRING COMMENT 'Current lifecycle status of this category placement within the campaign.',
    `priority_rank` STRING COMMENT 'Relative priority or ranking of this category within the campaign (1=highest priority). Used to allocate resources, creative emphasis, and merchandising support.',
    `target_sales_amount` DECIMAL(18,2) COMMENT 'Sales revenue target set for this category within this specific campaign. Used to measure campaign effectiveness at the category level.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this placement record was last modified.',
    CONSTRAINT pk_category_campaign_placement PRIMARY KEY(`category_campaign_placement_id`)
) COMMENT 'This association product represents the operational placement of merchandise categories within marketing campaigns. It captures the budget allocation, sales targets, priority ranking, and featured status for each category-campaign combination. Each record links one category to one campaign with attributes that exist only in the context of this specific promotional relationship, enabling retailers to plan, execute, and measure category-level campaign performance.. Existence Justification: In retail operations, marketing campaigns routinely feature multiple merchandise categories (e.g., a Back-to-School campaign promotes apparel, electronics, and stationery simultaneously), and each category participates in multiple campaigns throughout the year (seasonal promotions, clearance events, brand campaigns). Retailers actively manage these category-campaign placements as operational entities, setting category-specific budgets, sales targets, priority rankings, and featured status for each campaign. This is not an analytical correlation but an operational planning and execution process where marketing and merchandising teams collaborate to allocate resources and measure performance at the category-campaign intersection.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`buyer_profit_center_assignment` (
    `buyer_profit_center_assignment_id` BIGINT COMMENT 'Unique surrogate identifier for this buyer-profit center assignment record. Primary key.',
    `buyer_id` BIGINT COMMENT 'Foreign key linking to the merchandise buyer responsible for this assignment',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to the profit center for which the buyer has responsibility',
    `assigned_category_list` STRING COMMENT 'Comma-separated list of category codes for which this buyer has purchasing responsibility within this specific profit center. Categories may vary by profit center based on channel strategy and assortment localization.',
    `assignment_status` STRING COMMENT 'Current operational status of this buyer-profit center assignment. Active assignments are operational; inactive assignments are historical or terminated.',
    `effective_end_date` DATE COMMENT 'Date on which this buyer-profit center assignment ends or ended. Null for currently active assignments. Supports historical tracking of buyer responsibility changes.',
    `effective_start_date` DATE COMMENT 'Date from which this buyer-profit center assignment becomes active and the buyer assumes responsibility for the assigned categories within this profit center.',
    `otb_allocation_amount` DECIMAL(18,2) COMMENT 'Open-to-Buy budget amount allocated to this buyer for the assigned categories within this profit center for the current fiscal period. Represents the buyers spending authority for this specific profit center.',
    `primary_flag` BOOLEAN COMMENT 'Indicates whether this profit center represents the buyers primary area of responsibility. Used for workload balancing and performance evaluation prioritization.',
    CONSTRAINT pk_buyer_profit_center_assignment PRIMARY KEY(`buyer_profit_center_assignment_id`)
) COMMENT 'This association product represents the Assignment between buyer and profit_center. It captures the operational responsibility of a merchandise buyer for specific product categories within a profit center, including OTB budget allocation and time-bound accountability. Each record links one buyer to one profit_center with attributes that exist only in the context of this relationship, enabling multi-dimensional buying responsibility across channels, regions, and store formats.. Existence Justification: In retail merchandising operations, buyers are assigned responsibility for specific product categories across multiple profit centers (channels, regions, store formats), and each profit center has multiple buyers managing different category portfolios. This is an operational assignment process where the business actively manages buyer-profit center responsibilities with time-bound accountability, OTB budget allocations per assignment, and category-specific scope that varies by profit center based on assortment localization and channel strategy.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` (
    `category_accrual_rule_id` BIGINT COMMENT 'Unique identifier for this category-accrual rule assignment. Primary key.',
    `accrual_rule_id` BIGINT COMMENT 'Foreign key linking to the loyalty accrual rule being applied to this category',
    `category_id` BIGINT COMMENT 'Foreign key linking to the merchandise category to which this accrual rule applies',
    `associate_id` BIGINT COMMENT 'Identifier of the user or system that created this category-accrual rule assignment.',
    `category_accrual_rule_status` STRING COMMENT 'Current lifecycle status of this category-accrual rule assignment (active, inactive, scheduled, expired). Allows independent lifecycle management of category-rule assignments.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this category-accrual rule assignment was first created in the system.',
    `effective_end_date` DATE COMMENT 'Date when this category-specific accrual rule assignment expires. This is relationship-specific data identified in the detection phase, supporting time-bound promotional earning strategies.',
    `effective_start_date` DATE COMMENT 'Date when this category-specific accrual rule assignment becomes active. This is relationship-specific data identified in the detection phase, allowing different effective periods for different category-rule combinations.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this category-accrual rule assignment was last modified.',
    `minimum_spend_threshold` DECIMAL(18,2) COMMENT 'Minimum transaction amount within this category required for the accrual rule to apply. This is relationship-specific data identified in the detection phase, allowing category-specific thresholds that may differ from the base rule threshold.',
    `points_multiplier` DECIMAL(18,2) COMMENT 'The multiplier applied to the base earning rate for this specific category-rule combination (e.g., 2.0 for double points on beauty, 3.0 for triple points on private label apparel). This is relationship-specific data identified in the detection phase.',
    `rule_priority` STRING COMMENT 'Priority ranking for conflict resolution when multiple accrual rules apply to the same category. This is relationship-specific data identified in the detection phase, supporting complex earning rule hierarchies.',
    CONSTRAINT pk_category_accrual_rule PRIMARY KEY(`category_accrual_rule_id`)
) COMMENT 'This association product represents the assignment of loyalty point accrual rules to specific merchandise categories. It captures the category-specific earning multipliers, thresholds, and effective date ranges that govern how members earn points when purchasing from specific categories. Each record links one category to one accrual rule with attributes that exist only in the context of this category-rule combination.. Existence Justification: In retail loyalty programs, merchandise categories and accrual rules have a genuine many-to-many operational relationship. A single category (e.g., Beauty) can simultaneously participate in multiple earning rules (base earning, weekend bonus, tier-specific multiplier, seasonal promotion), and a single accrual rule (e.g., 2x points on private label) applies across multiple categories (apparel, home goods, grocery). Loyalty program managers actively create, configure, and manage these category-rule assignments as part of promotional strategy and program configuration.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ADD CONSTRAINT `fk_merchandising_category_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ADD CONSTRAINT `fk_merchandising_category_parent_category_id` FOREIGN KEY (`parent_category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_otb_budget_id` FOREIGN KEY (`otb_budget_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`otb_budget`(`otb_budget_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_buying_order_id` FOREIGN KEY (`buying_order_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order`(`buying_order_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_buying_subclass_category_id` FOREIGN KEY (`buying_subclass_category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_otb_budget_id` FOREIGN KEY (`otb_budget_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`otb_budget`(`otb_budget_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ADD CONSTRAINT `fk_merchandising_merchandising_planogram_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ADD CONSTRAINT `fk_merchandising_merchandising_planogram_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ADD CONSTRAINT `fk_merchandising_planogram_position_merchandising_planogram_id` FOREIGN KEY (`merchandising_planogram_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`merchandising_planogram`(`merchandising_planogram_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ADD CONSTRAINT `fk_merchandising_vendor_negotiation_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ADD CONSTRAINT `fk_merchandising_vendor_negotiation_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ADD CONSTRAINT `fk_merchandising_private_label_program_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ADD CONSTRAINT `fk_merchandising_private_label_program_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` ADD CONSTRAINT `fk_merchandising_category_campaign_placement_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer_profit_center_assignment` ADD CONSTRAINT `fk_merchandising_buyer_profit_center_assignment_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ADD CONSTRAINT `fk_merchandising_category_accrual_rule_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`merchandising` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_retail_v1`.`merchandising` SET TAGS ('dbx_domain' = 'merchandising');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` SET TAGS ('dbx_subdomain' = 'financial_planning');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `merch_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Merchandise Plan ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `price_strategy_id` SET TAGS ('dbx_business_glossary_term' = 'Price Strategy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Planner ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ALTER COLUMN `season_id` SET TAGS ('dbx_internal' = 'true');
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
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `price_strategy_id` SET TAGS ('dbx_business_glossary_term' = 'Price Strategy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Merchandise Planner ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `report_subscription_id` SET TAGS ('dbx_business_glossary_term' = 'Report Subscription Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ALTER COLUMN `otb_budget_amount` SET TAGS ('dbx_confidential' = 'true');
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
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Planner ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `actual_gmroi` SET TAGS ('dbx_business_glossary_term' = 'Actual Gross Margin Return on Investment (GMROI)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `actual_sell_through_rate` SET TAGS ('dbx_business_glossary_term' = 'Actual Sell-Through Rate');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `category_role` SET TAGS ('dbx_value_regex' = 'destination|routine|convenience|seasonal|occasional');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `category_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|discontinued');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `category_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `otb_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget Amount');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `otb_budget_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `otb_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Currency Code');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `otb_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `review_frequency` SET TAGS ('dbx_value_regex' = 'weekly|monthly|quarterly|semi_annual|annual');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `target_gmroi` SET TAGS ('dbx_business_glossary_term' = 'Target Gross Margin Return on Investment (GMROI)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ALTER COLUMN `target_sell_through_rate` SET TAGS ('dbx_business_glossary_term' = 'Target Sell-Through Rate');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` SET TAGS ('dbx_subdomain' = 'vendor_buying');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `semantic_layer_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Semantic Layer Entity Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `assortment_planning_system_access` SET TAGS ('dbx_business_glossary_term' = 'Assortment Planning System Access Level');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `assortment_planning_system_access` SET TAGS ('dbx_value_regex' = 'full_access|read_only|no_access');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `buyer_status` SET TAGS ('dbx_value_regex' = 'active|inactive|on_leave|terminated');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `buyer_type` SET TAGS ('dbx_value_regex' = 'merchandise_buyer|category_manager|assistant_buyer|senior_buyer|divisional_buyer');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `buying_authority_limit` SET TAGS ('dbx_confidential' = 'true');
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
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `buyer_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `buyer_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `office_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}[0-9]{3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `otb_budget_limit` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget Limit');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `otb_budget_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Buyer Phone Number');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `sell_through_rate_target` SET TAGS ('dbx_business_glossary_term' = 'Sell-Through Rate Target');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Buyer Termination Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ALTER COLUMN `vendor_negotiation_rating` SET TAGS ('dbx_value_regex' = 'excellent|good|average|needs_improvement|not_rated');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` SET TAGS ('dbx_subdomain' = 'financial_planning');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `semantic_layer_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Semantic Layer Entity Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `season_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}[0-9]{2}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Season End Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active Flag');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Season Notes');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `otb_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget Amount');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `otb_budget_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `season_status` SET TAGS ('dbx_value_regex' = 'planning|open_to_buy|in_season|post_season|closed');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `season_type` SET TAGS ('dbx_value_regex' = 'spring_summer|fall_winter|holiday|back_to_school|transitional|year_round');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Season Start Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `target_gmroi` SET TAGS ('dbx_business_glossary_term' = 'Target Gross Margin Return on Investment (GMROI)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `target_gmroi` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `target_inventory_turns` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `target_sell_through_rate` SET TAGS ('dbx_business_glossary_term' = 'Target Sell-Through Rate');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ALTER COLUMN `target_sell_through_rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` SET TAGS ('dbx_subdomain' = 'financial_planning');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `otb_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Owner Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Gmroi Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` SET TAGS ('dbx_subdomain' = 'vendor_buying');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `license_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Import License Permit Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `otb_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Open To Buy (OTB) Budget ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Fulfillment Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
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
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` SET TAGS ('dbx_subdomain' = 'vendor_buying');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Class ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `buying_subclass_category_id` SET TAGS ('dbx_business_glossary_term' = 'Subclass ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `otb_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Po Line Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `vendor_item_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Item Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `extended_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `gtin` SET TAGS ('dbx_business_glossary_term' = 'Global Trade Item Number (GTIN)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `gtin` SET TAGS ('dbx_value_regex' = '^[0-9]{14}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `line_status` SET TAGS ('dbx_value_regex' = 'open|confirmed|shipped|received|cancelled|closed');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `planned_margin_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `planned_margin_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `sku` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,14}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `store_cluster_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `unit_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `upc` SET TAGS ('dbx_business_glossary_term' = 'Universal Product Code (UPC)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ALTER COLUMN `upc` SET TAGS ('dbx_value_regex' = '^[0-9]{12}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` SET TAGS ('dbx_subdomain' = 'visual_execution');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Product Category ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Merchandiser ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `compliance_tolerance_pct` SET TAGS ('dbx_business_glossary_term' = 'Compliance Tolerance Percentage');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `fixture_depth_cm` SET TAGS ('dbx_business_glossary_term' = 'Fixture Depth (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `fixture_height_cm` SET TAGS ('dbx_business_glossary_term' = 'Fixture Height (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `fixture_type` SET TAGS ('dbx_value_regex' = 'gondola|endcap|pegboard|shelf|cooler|freezer');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `fixture_width_cm` SET TAGS ('dbx_business_glossary_term' = 'Fixture Width (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `merchandising_planogram_status` SET TAGS ('dbx_business_glossary_term' = 'Planogram Status');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `merchandising_planogram_status` SET TAGS ('dbx_value_regex' = 'draft|approved|active|inactive|archived');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `planogram_code` SET TAGS ('dbx_business_glossary_term' = 'Planogram (POG) Code');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `planogram_code` SET TAGS ('dbx_value_regex' = '^POG-[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `space_allocation_sqft` SET TAGS ('dbx_business_glossary_term' = 'Space Allocation (Square Feet)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `space_planning_system_code` SET TAGS ('dbx_business_glossary_term' = 'Space Planning System ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `target_gmroi` SET TAGS ('dbx_business_glossary_term' = 'Target Gross Margin Return on Investment (GMROI)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `target_sales_per_sqft` SET TAGS ('dbx_business_glossary_term' = 'Target Sales Per Square Foot');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `total_sku_count` SET TAGS ('dbx_business_glossary_term' = 'Total Stock Keeping Unit (SKU) Count');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Planogram Version Number');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}.[0-9]{1,3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` SET TAGS ('dbx_subdomain' = 'visual_execution');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ALTER COLUMN `planogram_position_id` SET TAGS ('dbx_business_glossary_term' = 'Planogram Position Identifier');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ALTER COLUMN `merchandising_planogram_id` SET TAGS ('dbx_business_glossary_term' = 'Planogram ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ALTER COLUMN `compliance_score` SET TAGS ('dbx_business_glossary_term' = 'Compliance Score (Percentage)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ALTER COLUMN `display_orientation` SET TAGS ('dbx_value_regex' = 'front|side|top|angled|stacked');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ALTER COLUMN `is_new_item` SET TAGS ('dbx_business_glossary_term' = 'Is New Item Position');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ALTER COLUMN `is_promotional` SET TAGS ('dbx_business_glossary_term' = 'Is Promotional Position');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ALTER COLUMN `merchandising_zone` SET TAGS ('dbx_value_regex' = 'eye_level|reach_level|stoop_level|stretch_level');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Position Notes');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ALTER COLUMN `position_depth_cm` SET TAGS ('dbx_business_glossary_term' = 'Position Depth (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ALTER COLUMN `position_height_cm` SET TAGS ('dbx_business_glossary_term' = 'Position Height (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ALTER COLUMN `position_sequence` SET TAGS ('dbx_business_glossary_term' = 'Position Sequence Number');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ALTER COLUMN `position_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|discontinued');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ALTER COLUMN `position_width_cm` SET TAGS ('dbx_business_glossary_term' = 'Position Width (Centimeters)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` SET TAGS ('dbx_subdomain' = 'assortment_strategy');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Featured Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) ID');
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
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` SET TAGS ('dbx_subdomain' = 'vendor_buying');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Product Category ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `corrective_action_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Audit Corrective Action Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `allowance_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `allowance_type` SET TAGS ('dbx_value_regex' = 'volume_rebate|early_payment_discount|promotional_allowance|markdown_support|slotting_fee|other');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Buyer Approval Status');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|conditional');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `coop_advertising_fund` SET TAGS ('dbx_business_glossary_term' = 'Co-Op (Cooperative) Advertising Fund');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `coop_advertising_fund` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `cost_change_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms (International Commercial Terms)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `markdown_support_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `moq` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `moq_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ) Unit of Measure');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `moq_unit_of_measure` SET TAGS ('dbx_value_regex' = 'each|case|pallet|container|unit');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `negotiation_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Negotiation Number');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `negotiation_number` SET TAGS ('dbx_value_regex' = '^VN-[0-9]{8}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `negotiation_type` SET TAGS ('dbx_value_regex' = 'initial_contract|contract_renewal|cost_change|markdown_support|promotional_allowance|annual_review');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `new_cost_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `old_cost_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` SET TAGS ('dbx_subdomain' = 'financial_planning');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `alert_id` SET TAGS ('dbx_business_glossary_term' = 'Analytics Alert Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `audit_finding_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Audit Finding Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `price_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Price Zone Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `tertiary_markdown_modified_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `vendor_allowance_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Support Agreement ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `actual_sell_through_lift_percentage` SET TAGS ('dbx_business_glossary_term' = 'Actual Sell-Through Lift Percentage');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Markdown Effective Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Markdown End Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `markdown_number` SET TAGS ('dbx_value_regex' = '^MD-[0-9]{8}-[0-9]{4}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `markdown_reason` SET TAGS ('dbx_value_regex' = 'seasonal_clearance|slow_seller|competitive_response|end_of_life|damaged|obsolete');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `markdown_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|active|completed|cancelled');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `markdown_type` SET TAGS ('dbx_value_regex' = 'permanent|temporary|promotional|clearance|competitive|damaged_goods');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Markdown Notes');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ALTER COLUMN `projected_sell_through_lift_percentage` SET TAGS ('dbx_business_glossary_term' = 'Projected Sell-Through Lift Percentage');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` SET TAGS ('dbx_subdomain' = 'assortment_strategy');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Store Cluster ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Launch Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `price_strategy_id` SET TAGS ('dbx_business_glossary_term' = 'Price Strategy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Merchandiser ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `product_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `certification_id` SET TAGS ('dbx_business_glossary_term' = 'Program Certification Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Supplier ID');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `competitive_positioning` SET TAGS ('dbx_value_regex' = 'premium_alternative|parity|value_alternative|discount');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `markdown_strategy` SET TAGS ('dbx_value_regex' = 'edlp|hi_lo|seasonal_clearance|dynamic');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `marketing_investment_usd` SET TAGS ('dbx_business_glossary_term' = 'Marketing Investment (USD)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `marketing_investment_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `otb_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Budget Amount');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `otb_budget_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `program_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `program_status` SET TAGS ('dbx_value_regex' = 'active|planning|pilot|discontinued|suspended|under_review');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `quality_tier` SET TAGS ('dbx_value_regex' = 'premium|standard|value|economy');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `target_gmroi` SET TAGS ('dbx_business_glossary_term' = 'Target Gross Margin Return on Investment (GMROI)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `target_margin_premium_pct` SET TAGS ('dbx_business_glossary_term' = 'Target Margin Premium Percentage');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `target_price_point_usd` SET TAGS ('dbx_business_glossary_term' = 'Target Price Point (USD)');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `target_sell_through_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Target Sell-Through Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ALTER COLUMN `vendor_managed_inventory_flag` SET TAGS ('dbx_business_glossary_term' = 'Vendor Managed Inventory (VMI) Flag');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` SET TAGS ('dbx_subdomain' = 'visual_execution');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` SET TAGS ('dbx_association_edges' = 'merchandising.category,marketing.campaign');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Category Campaign Placement - Campaign Id');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Campaign Placement - Category Id');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` ALTER COLUMN `actual_sales_amount` SET TAGS ('dbx_business_glossary_term' = 'Actual Category Sales Amount');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` ALTER COLUMN `actual_spend_amount` SET TAGS ('dbx_business_glossary_term' = 'Actual Category Spend Amount');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` ALTER COLUMN `budget_allocation_amount` SET TAGS ('dbx_business_glossary_term' = 'Category Budget Allocation Amount');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Placement Effective End Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Placement Effective Start Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` ALTER COLUMN `is_featured` SET TAGS ('dbx_business_glossary_term' = 'Category Featured Flag');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` ALTER COLUMN `priority_rank` SET TAGS ('dbx_business_glossary_term' = 'Category Priority Rank');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` ALTER COLUMN `target_sales_amount` SET TAGS ('dbx_business_glossary_term' = 'Category Target Sales Amount');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer_profit_center_assignment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer_profit_center_assignment` SET TAGS ('dbx_subdomain' = 'vendor_buying');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer_profit_center_assignment` SET TAGS ('dbx_association_edges' = 'merchandising.buyer,finance.profit_center');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer_profit_center_assignment` ALTER COLUMN `buyer_profit_center_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer Profit Center Assignment Identifier');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer_profit_center_assignment` ALTER COLUMN `buyer_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer Profit Center Assignment - Buyer Id');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer_profit_center_assignment` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer Profit Center Assignment - Profit Center Id');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer_profit_center_assignment` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Effective End Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer_profit_center_assignment` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Effective Start Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer_profit_center_assignment` ALTER COLUMN `primary_flag` SET TAGS ('dbx_business_glossary_term' = 'Primary Assignment Flag');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` SET TAGS ('dbx_subdomain' = 'assortment_strategy');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` SET TAGS ('dbx_association_edges' = 'merchandising.category,loyalty.accrual_rule');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ALTER COLUMN `category_accrual_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Category Accrual Rule Assignment Identifier');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ALTER COLUMN `accrual_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Category Accrual Rule - Accrual Rule Id');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Accrual Rule - Category Id');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Assignment Creator Associate');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ALTER COLUMN `category_accrual_rule_status` SET TAGS ('dbx_business_glossary_term' = 'Category Rule Assignment Status');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Assignment Creation Timestamp');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Category Rule Effective End Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Category Rule Effective Start Date');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Assignment Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ALTER COLUMN `minimum_spend_threshold` SET TAGS ('dbx_business_glossary_term' = 'Category-Specific Minimum Spend Threshold');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ALTER COLUMN `points_multiplier` SET TAGS ('dbx_business_glossary_term' = 'Category-Specific Points Multiplier');
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ALTER COLUMN `rule_priority` SET TAGS ('dbx_business_glossary_term' = 'Category Rule Priority Ranking');
