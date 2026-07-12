-- Schema for Domain: supplychain | Business: Retail | Version: v2_mvm
-- Generated on: 2026-07-12 15:26:02

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`supplychain` COMMENT 'Manages end-to-end supply chain planning and execution from demand forecasting through distribution center operations, including facility management, warehouse workflows, inbound/outbound logistics, replenishment planning, purchase order lifecycle, cross-docking, and supply chain performance monitoring.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` (
    `replenishment_plan_id` BIGINT COMMENT 'Unique surrogate identifier for each replenishment plan record in the Silver layer lakehouse. Primary key for the replenishment_plan data product.',
    `cost_price_id` BIGINT COMMENT 'Foreign key linking to pricing.cost_price. Business justification: replenishment_plan.unit_cost is a denormalized copy of the cost_price master. Linking to cost_price enables planned_order_value accuracy using authoritative landed cost and supports retail open-to-buy',
    `demand_forecast_id` BIGINT COMMENT 'Reference to the demand forecast plan from Blue Yonder Demand Planning that drove the generation of this replenishment plan. Enables traceability from replenishment decision back to the underlying demand signal.',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.associate. Business justification: Replenishment planners own plans for planning accountability and forecast accuracy tracking. Supply chain tracks planner performance on service levels, inventory turns, and forecast bias for performan',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: item_hierarchy carries replenishment_method, safety_stock_weeks, and lead_time_days — the source parameters for replenishment planning. Linking replenishment_plan to item_hierarchy allows category man',
    `inventory_node_id` BIGINT COMMENT 'Reference to the supply chain node (store, Distribution Center (DC), or Micro-Fulfillment Center (MFC)) for which this replenishment plan is generated. Identifies the destination receiving location in the replenishment network.',
    `sku_id` BIGINT COMMENT 'Reference to the specific SKU (Stock Keeping Unit) for which this replenishment plan is generated. The SKU is the primary product-level identifier used in replenishment planning across stores, DCs, and MFCs.',
    `vendor_id` BIGINT COMMENT 'Reference to the primary supplier responsible for fulfilling this replenishment plan. Links to the supplier master for MOQ enforcement, lead time, and EDI ordering constraints.',
    `sku_price_id` BIGINT COMMENT 'Foreign key linking to pricing.sku_price. Business justification: Replenishment planning uses current retail price to compute planned_order_value and evaluate margin thresholds before releasing orders. Retail planners must reference the active sku_price to validate ',
    `vendor_item_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_item. Business justification: Replenishment planning requires vendor_item specs (unit_cost, moq, pack_size, inner_pack_quantity) to calculate planned_order_value and validate moq_compliance_flag. Supply planners expect replenishme',
    `approved_order_qty` DECIMAL(18,2) COMMENT 'The final order quantity approved by the buyer or auto-approved by the system after MOQ, order multiple, and buyer override adjustments. This is the quantity that will be transmitted to the supplier via EDI or purchase order.',
    `buyer_override_flag` BOOLEAN COMMENT 'Indicates whether a buyer has manually overridden the system-generated planned order quantity or parameters. True = buyer override applied; False = system-generated values accepted as-is. Supports audit trail for manual interventions.',
    `created_timestamp` TIMESTAMP COMMENT 'Audit timestamp recording when this replenishment plan record was first persisted in the Silver layer lakehouse. Supports data lineage and audit trail requirements.',
    `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code in which the planned order value and unit cost are expressed (e.g., USD, GBP, EUR). Required for multi-currency retail operations.. Valid values are `^[A-Z]{3}$`',
    `current_on_hand_qty` DECIMAL(18,2) COMMENT 'The quantity of the SKU physically on hand at the supply node at the time the replenishment plan was generated. Sourced from Manhattan Associates WMS or SAP S/4HANA WM. Used as the starting inventory position for plan calculations.',
    `demand_variability_factor` DECIMAL(18,2) COMMENT 'A statistical measure of demand variability (coefficient of variation or standard deviation of demand) used by the planning engine to size safety stock. Higher values indicate more volatile demand and result in larger safety stock buffers.',
    `fill_rate_target_pct` DECIMAL(18,2) COMMENT 'The target order fill rate percentage (Fill Rate) for this replenishment plan, representing the percentage of demand that should be fulfilled from available inventory. Used as a supply chain performance KPI (KPI) target for this SKU-node combination.',
    `forecasted_demand_qty` DECIMAL(18,2) COMMENT 'The total forecasted demand quantity for the SKU at the supply node over the plan horizon, as generated by Blue Yonder Demand Planning. The primary input to the planned order quantity calculation.',
    `lead_time_days` STRING COMMENT 'The number of calendar days from purchase order placement to expected receipt at the supply node, as defined in the supplier contract or purchasing info record. Used to calculate reorder points and plan order release dates.',
    `min_order_value` DECIMAL(18,2) COMMENT 'The minimum monetary value of a purchase order required by the supplier, expressed in the operating currency. Replenishment plans that do not meet the minimum order value threshold are consolidated or flagged for buyer action.',
    `moq` DECIMAL(18,2) COMMENT 'The minimum number of units that must be ordered from the supplier per purchase order line, as enforced by supplier contract terms. Replenishment plans with planned_order_qty below MOQ are rounded up or flagged for buyer review.',
    `moq_compliance_flag` BOOLEAN COMMENT 'Indicates whether the planned order quantity meets or exceeds the suppliers Minimum Order Quantity (MOQ) constraint. True = compliant; False = below MOQ threshold and requires buyer review or order consolidation before release.',
    `node_type` STRING COMMENT 'Classifies the type of supply chain node receiving the replenishment. Values: store (retail store), dc (Distribution Center), mfc (Micro-Fulfillment Center), dark_store (fulfillment-only location). Drives replenishment logic and lead time parameters.. Valid values are `store|dc|mfc|dark_store`',
    `on_order_qty` DECIMAL(18,2) COMMENT 'The quantity of the SKU already on open purchase orders or in-transit to the supply node at the time of plan generation. Included in the net inventory position calculation to avoid over-ordering.',
    `order_multiple` DECIMAL(18,2) COMMENT 'The unit increment in which the SKU must be ordered (e.g., case pack size, pallet quantity). Planned order quantities are rounded up to the nearest order multiple before purchase order generation.',
    `order_release_date` DATE COMMENT 'The date on which the replenishment plan is scheduled to be released as a purchase order to the supplier. Calculated by subtracting lead time from the planned receipt date. Drives the purchasing execution calendar.',
    `override_reason_code` STRING COMMENT 'Standardized reason code explaining why a buyer manually overrode the system-generated replenishment plan. Populated only when buyer_override_flag is True. Supports root cause analysis of planning accuracy and buyer behavior patterns.. Valid values are `promotional_uplift|supplier_constraint|excess_inventory|demand_correction|system_error|other`',
    `plan_generation_timestamp` TIMESTAMP COMMENT 'The date and time when the replenishment plan was generated by the planning engine (Blue Yonder or equivalent). Represents the principal business event timestamp for this transaction. Used for plan freshness assessment and demand signal alignment.',
    `plan_horizon_end_date` DATE COMMENT 'The end date of the planning horizon covered by this replenishment plan. Defines the end of the demand forecast window. Together with plan_horizon_start_date, bounds the coverage period for this plan.',
    `plan_horizon_start_date` DATE COMMENT 'The start date of the planning horizon covered by this replenishment plan. Defines the beginning of the demand forecast window used to generate the planned order quantity.',
    `plan_number` STRING COMMENT 'Externally-known business identifier for the replenishment plan, generated by Blue Yonder Demand Planning or SAP S/4HANA MM module. Used for cross-system traceability and supplier communication.. Valid values are `^RPL-[0-9]{10}$`',
    `plan_status` STRING COMMENT 'Current lifecycle state of the replenishment plan within the planning and execution workflow. Drives automated ordering triggers and buyer review queues. [ENUM-REF-CANDIDATE: draft|proposed|approved|released|in_progress|completed|cancelled — promote to reference product]',
    `plan_type` STRING COMMENT 'Categorizes the origin and nature of the replenishment plan. Automated plans are system-generated by Blue Yonder; manual plans are buyer-created; override plans supersede automated recommendations; emergency plans address urgent stockout risk.. Valid values are `automated|manual|override|emergency`',
    `planned_order_qty` DECIMAL(18,2) COMMENT 'The quantity of units recommended by the planning engine to be ordered for this SKU at the specified supply node. Subject to MOQ and order multiple enforcement before release to purchasing.',
    `planned_order_value` DECIMAL(18,2) COMMENT 'The total monetary value of the planned replenishment order, calculated as planned_order_qty multiplied by unit_cost. Used for Open-to-Buy (OTB) budget management and financial planning.',
    `planned_receipt_date` DATE COMMENT 'The expected date on which the replenishment order is planned to be received at the supply node, calculated as the order release date plus supplier lead time. Used for inventory projection and DC scheduling.',
    `promotion_flag` BOOLEAN COMMENT 'Indicates whether this replenishment plan was generated or adjusted to support a planned promotional event. True = promotion-driven uplift included in forecasted demand; False = baseline replenishment. Links to promotional demand lift in Blue Yonder.',
    `reorder_point` DECIMAL(18,2) COMMENT 'The inventory level (in units) at the supply node at which a replenishment order is triggered. Calculated as safety stock plus expected demand during supplier lead time. Core parameter for reorder-point-based replenishment policies.',
    `replenishment_method` STRING COMMENT 'The replenishment policy calculation method applied to generate this plan. Min/Max triggers orders when inventory falls below minimum; Reorder Point (ROP) uses statistical triggers; Days of Supply targets coverage duration; Vendor Managed Inventory (VMI) delegates to supplier; Cross-Docking bypasses storage; Direct Store Delivery (DSD) is supplier-direct. [ENUM-REF-CANDIDATE: min_max|reorder_point|days_of_supply|vendor_managed|cross_dock|dsd — promote to reference product]',
    `safety_stock_method` STRING COMMENT 'The methodology used to calculate the safety stock quantity. Fixed uses a static buffer; Statistical uses demand variability and lead time variance; Days of Supply targets a coverage duration; Service Level Based derives buffer from the target service level percentage.. Valid values are `fixed|statistical|days_of_supply|service_level_based`',
    `safety_stock_qty` DECIMAL(18,2) COMMENT 'The buffer stock quantity maintained at the supply node to protect against demand variability and supply uncertainty. Represents the minimum inventory floor below which replenishment is urgently triggered. Also referred to as buffer stock.',
    `service_level_target_pct` DECIMAL(18,2) COMMENT 'The target in-stock service level percentage used to calculate safety stock and replenishment parameters. Expressed as a percentage (e.g., 95.00 = 95%). Represents the probability of not experiencing a stockout during the replenishment lead time.',
    `source_system_code` STRING COMMENT 'Identifies the operational system of record that generated or last updated this replenishment plan. Supports data lineage and Silver layer provenance tracking. Values: blue_yonder (Blue Yonder Demand Planning), sap_s4hana (SAP S/4HANA MM), orms (the retail merchandising system Merchandising System), manual (buyer-created).. Valid values are `blue_yonder|sap_s4hana|orms|manual`',
    `updated_timestamp` TIMESTAMP COMMENT 'Audit timestamp recording when this replenishment plan record was last modified in the Silver layer lakehouse. Tracks buyer overrides, status transitions, and plan revisions.',
    `weeks_of_supply_target` DECIMAL(18,2) COMMENT 'The target number of weeks of inventory coverage (Weeks of Supply / WOS) that the replenishment plan aims to achieve at the supply node after order receipt. Used as a planning horizon parameter for days-of-supply replenishment methods.',
    CONSTRAINT pk_replenishment_plan PRIMARY KEY(`replenishment_plan_id`)
) COMMENT 'Replenishment plans for SKUs across all supply chain nodes (stores, DCs, MFCs), generated by Blue Yonder or equivalent planning engine. Captures planned order quantities, replenishment triggers, reorder points, safety stock levels and policy parameters (calculation method, service level target, demand variability factor), weeks-of-supply targets, plan status, and MOQ enforcement rules (minimum order quantity, order multiples, minimum order value). SSOT for automated replenishment decisions including buffer stock governance and supplier ordering constraints.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` (
    `demand_forecast_id` BIGINT COMMENT 'Unique surrogate identifier for each SKU-level demand forecast record generated by Blue Yonder Demand Planning. Serves as the primary key for this table.',
    `cluster_id` BIGINT COMMENT 'Foreign key linking to store.cluster. Business justification: Retail demand planning generates cluster-level baseline forecasts before disaggregating to individual store/SKU level. The Cluster-Level Demand Planning process uses store cluster segmentation (demogr',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Demand planners own forecasts for planning accountability and accuracy tracking. Supply chain tracks planner MAPE, bias, and forecast quality by planner for performance management, S&OP reviews, and p',
    `location_id` BIGINT COMMENT 'Reference to the store, distribution center (DC), or fulfillment node for which the demand forecast applies. Supports store-level and DC-level replenishment planning.',
    `sku_id` BIGINT COMMENT 'Reference to the specific Stock Keeping Unit (SKU) for which the demand forecast is generated. The SKU is the atomic unit of inventory and demand planning in retail.',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Retail demand forecasting operates at both SKU and category/hierarchy levels. Linking demand_forecast to item_hierarchy enables department- and category-level demand plans used in open-to-buy, seasona',
    `category_id` BIGINT COMMENT 'add column merchandising_category_id (BIGINT) with FK to merchandising.category.category_id - demand forecasts are generated at category level in addition to SKU level for aggregate planning',
    `promo_calendar_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_calendar. Business justification: Promotional Demand Planning: demand_forecast records generated for promotional periods (is_promotional_period=true) must reference the promo_calendar period that triggered them. Retail demand planners',
    `sku_price_id` BIGINT COMMENT 'Foreign key linking to pricing.sku_price. Business justification: Demand forecasting applies price-elasticity models that require the active retail price. forecasted_revenue on demand_forecast is computed from forecasted_units × retail_price. Retail demand planners ',
    `baseline_forecast_units` DECIMAL(18,2) COMMENT 'The pure statistical baseline demand forecast in units before any adjustments for promotions, seasonality, or manual overrides. Provides the unadjusted demand signal for comparison against the final consensus forecast.',
    `confidence_level_pct` DECIMAL(18,2) COMMENT 'The statistical confidence level (expressed as a percentage, e.g., 95.00) associated with the forecast interval. Indicates the probability that actual demand will fall within the forecast range. Used to set safety stock levels and replenishment buffers.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this demand forecast record was first written to the Silver Layer lakehouse. Supports data lineage, audit trails, and incremental load processing.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the forecasted revenue amount (e.g., USD, GBP, EUR). Supports multi-currency retail operations across international markets.. Valid values are `^[A-Z]{3}$`',
    `data_source_system` STRING COMMENT 'The operational system of record that provided the demand signal inputs used to generate this forecast (e.g., SAP_CAR for POS transaction data, the e-commerce platform_Commerce_Cloud for e-commerce demand, ORMS for inventory positions). Supports data lineage and source system auditability.',
    `demand_category` STRING COMMENT 'Classification of the SKUs demand pattern used to select the appropriate forecasting model. regular indicates stable, predictable demand; intermittent indicates sporadic demand (Croston model); lumpy indicates irregular high-volume spikes; new_item indicates insufficient history; end_of_life indicates declining/discontinuing SKU.. Valid values are `regular|intermittent|lumpy|new_item|end_of_life`',
    `forecast_bias` DECIMAL(18,2) COMMENT 'The systematic directional error in the forecast, calculated as the mean of (forecasted units minus actual units) over a rolling period. Positive values indicate over-forecasting (excess inventory risk); negative values indicate under-forecasting (stockout risk). Critical for replenishment safety stock calibration.',
    `forecast_generation_timestamp` TIMESTAMP COMMENT 'The exact date and time when this forecast record was generated by the Blue Yonder Demand Planning engine. Serves as the principal business event timestamp for the forecast lifecycle and supports version comparison across planning cycles.',
    `forecast_horizon_weeks` STRING COMMENT 'The total number of weeks into the future covered by this forecast run, measured from the forecast generation date. Determines the planning horizon for replenishment, Open-to-Buy (OTB), and supply chain optimization.',
    `forecast_lower_bound_units` DECIMAL(18,2) COMMENT 'The lower bound of the forecast confidence interval in units at the specified confidence level. Represents the low-demand scenario used for minimum order quantity (MOQ) planning and markdown risk assessment.',
    `forecast_period_end_date` DATE COMMENT 'The last calendar date of the forecast horizon period covered by this record. Together with forecast_period_start_date, defines the time bucket granularity (daily, weekly, monthly).',
    `forecast_period_start_date` DATE COMMENT 'The first calendar date of the forecast horizon period covered by this record. Defines the beginning of the time bucket (day, week, or month) for which demand is forecasted.',
    `forecast_run_number` BIGINT COMMENT 'Identifier for the specific Blue Yonder Demand Planning batch run that generated this forecast record. Enables traceability back to the originating planning cycle and supports audit of forecast lineage.',
    `forecast_status` STRING COMMENT 'Current lifecycle state of the demand forecast record. draft indicates a preliminary run; published indicates the forecast is active for replenishment; approved indicates planner sign-off; overridden indicates a manual adjustment was applied; superseded indicates a newer run has replaced this record; archived indicates the record is retained for historical analysis only.. Valid values are `draft|published|approved|overridden|superseded|archived`',
    `forecast_type` STRING COMMENT 'Classification of the demand forecast by its planning purpose. baseline is the statistical base demand without uplift; promotional incorporates promotion lift; seasonal reflects seasonal index adjustments; event_driven accounts for specific demand events; consensus is the final agreed forecast used for replenishment and Open-to-Buy (OTB) planning.. Valid values are `baseline|promotional|seasonal|event_driven|consensus`',
    `forecast_upper_bound_units` DECIMAL(18,2) COMMENT 'The upper bound of the forecast confidence interval in units at the specified confidence level. Represents the high-demand scenario used for safety stock and maximum inventory planning to prevent stockouts.',
    `forecast_version` STRING COMMENT 'An incrementing integer version number for the forecast record for a given SKU-location-period combination. Enables tracking of forecast revisions across planning cycles and supports comparison of forecast evolution over time.',
    `forecasted_revenue` DECIMAL(18,2) COMMENT 'The projected revenue in the operating currency derived from the forecasted units multiplied by the expected selling price for the forecast period. Used in financial planning, Open-to-Buy (OTB) budgeting, and Gross Margin Return on Investment (GMROI) analysis.',
    `forecasted_units` DECIMAL(18,2) COMMENT 'The statistical models predicted demand quantity in sellable units for the SKU at the specified location during the forecast period. This is the primary quantitative output of the demand planning engine and drives replenishment order quantities.',
    `is_latest_version` BOOLEAN COMMENT 'Indicates whether this forecast record is the most current version for the given SKU-location-period combination. True means this record is the active forecast used for replenishment and OTB planning; False means it has been superseded by a newer forecast run.',
    `is_new_item` BOOLEAN COMMENT 'Indicates whether the SKU is a new item with insufficient sales history for statistical forecasting. When True, the forecast relies on analogous item modeling or planner input rather than historical demand patterns. Relevant for new product launches and assortment introductions.',
    `is_override_applied` BOOLEAN COMMENT 'Indicates whether a demand planner has manually overridden the statistical forecast for this record. True means the final forecasted_units reflect a planner adjustment; False means the forecast is purely statistical. Critical for measuring forecast bias introduced by manual intervention.',
    `is_promotional_period` BOOLEAN COMMENT 'Indicates whether the forecast period overlaps with an active promotional event. When True, the promotional_lift_units field is expected to be populated and the forecast incorporates promotion-driven demand uplift.',
    `mape` DECIMAL(18,2) COMMENT 'Mean Absolute Percentage Error (MAPE) measuring the accuracy of the statistical forecast against actual sales for the equivalent prior period. Expressed as a decimal (e.g., 0.12 = 12% error). Lower values indicate higher forecast accuracy. Used as the primary KPI for demand planning performance.',
    `model_version` STRING COMMENT 'The version identifier of the statistical forecasting model used to generate this forecast record. Supports model governance, reproducibility, and performance tracking across model upgrades in Blue Yonder Demand Planning.. Valid values are `^[0-9]+.[0-9]+.[0-9]+$`',
    `otb_impact_flag` BOOLEAN COMMENT 'Indicates whether this forecast record has been incorporated into the Open-to-Buy (OTB) financial plan. When True, the forecasted revenue and units are reflected in the merchandise financial plan and buying budget for the relevant period.',
    `override_reason_code` STRING COMMENT 'A standardized code indicating the business reason for the planners manual override of the statistical forecast (e.g., new product launch, competitor action, supply constraint, market intelligence). Populated only when is_override_applied is True. [ENUM-REF-CANDIDATE: NEW_PRODUCT|COMPETITOR_ACTION|SUPPLY_CONSTRAINT|MARKET_INTEL|PROMO_CHANGE|STORE_EVENT|WEATHER — promote to reference product]',
    `override_units` DECIMAL(18,2) COMMENT 'The manually adjusted demand quantity in units entered by a demand planner to replace or supplement the statistical forecast. Populated only when is_override_applied is True. Enables analysis of planner override magnitude and its impact on forecast accuracy.',
    `planning_channel` STRING COMMENT 'The retail fulfillment channel for which this demand forecast is generated. store covers brick-and-mortar POS demand; ecommerce covers digital commerce demand from the e-commerce platform; omnichannel covers unified demand signals; dc_replenishment covers distribution center stock replenishment; bopis covers Buy Online Pick Up In Store (BOPIS) demand.. Valid values are `store|ecommerce|omnichannel|dc_replenishment|bopis`',
    `promotional_lift_units` DECIMAL(18,2) COMMENT 'The incremental demand units attributed to active promotions during the forecast period. Derived from promotion event modeling in Blue Yonder and used to isolate the promotional demand signal from baseline demand for Pricing and Promotions Management analysis.',
    `replenishment_recommendation_units` DECIMAL(18,2) COMMENT 'The system-recommended replenishment order quantity in units derived from the demand forecast, current inventory position, safety stock targets, and lead time. Feeds directly into the retail merchandising system Merchandising System (ORMS) purchase order generation and Open-to-Buy (OTB) planning.',
    `seasonality_index` DECIMAL(18,2) COMMENT 'A multiplicative seasonal index applied to the baseline forecast to account for recurring seasonal demand patterns (e.g., holiday peaks, back-to-school). A value of 1.0 indicates no seasonal adjustment; values above 1.0 indicate above-average seasonal demand.',
    `statistical_model_code` STRING COMMENT 'The identifier or code of the statistical forecasting algorithm used by Blue Yonder Demand Planning to generate this forecast (e.g., ARIMA, Holt-Winters exponential smoothing, Croston for intermittent demand, machine learning ensemble). Enables model performance benchmarking and algorithm governance. [ENUM-REF-CANDIDATE: ARIMA|HOLT_WINTERS|CROSTON|ETS|MOVING_AVG|ML_ENSEMBLE|CAUSAL — promote to reference product]',
    `time_bucket_granularity` STRING COMMENT 'The temporal granularity of the forecast period covered by this record. daily is used for short-horizon replenishment; weekly is the standard planning cadence; monthly is used for financial and Open-to-Buy (OTB) planning.. Valid values are `daily|weekly|monthly`',
    `trend_adjustment_factor` DECIMAL(18,2) COMMENT 'A multiplicative factor representing the long-term demand trend applied to the forecast. Values above 1.0 indicate upward trend; values below 1.0 indicate declining demand trend. Used to capture secular demand shifts beyond seasonal patterns.',
    `updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this demand forecast record was last modified in the Silver Layer lakehouse, including override applications, accuracy recalculations, or status changes.',
    `weeks_of_supply` DECIMAL(18,2) COMMENT 'Weeks of Supply (WOS) — the projected number of weeks the current on-hand inventory will cover demand based on the forecasted units. A key inventory health metric used in replenishment planning to identify stockout risk and excess inventory positions.',
    `wmape` DECIMAL(18,2) COMMENT 'Weighted Mean Absolute Percentage Error (WMAPE) measuring forecast accuracy weighted by sales volume, reducing the distortion caused by low-volume SKUs. Expressed as a decimal. Preferred accuracy metric for high-volume retail assortments where MAPE can be misleading.',
    CONSTRAINT pk_demand_forecast PRIMARY KEY(`demand_forecast_id`)
) COMMENT 'SKU-level demand forecast records generated by Blue Yonder Demand Planning. Captures forecasted units, revenue, forecast horizon, statistical model used, override flags, forecast accuracy (MAPE/WMAPE), and demand signals including seasonality, promotions lift, and trend adjustments. Drives replenishment and OTB planning.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` (
    `purchase_order_id` BIGINT COMMENT 'Primary key for purchase_order',
    `blanket_po_purchase_order_id` BIGINT COMMENT 'Reference to the parent blanket or framework purchase order from which this release or call-off order was created. Null for standalone standard POs. Enables tracking of spend against blanket agreement limits.',
    `buyer_id` BIGINT COMMENT 'Reference to the internal buyer or purchasing agent responsible for creating and managing this purchase order. Corresponds to SAP EKKO.EKGRP (purchasing group) owner.',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Buyers raise POs at category/hierarchy level; merchandise_category_code is a denormalized plain-text representation of item_hierarchy. Normalizing via FK enables open-to-buy tracking, category-level P',
    `lead_time_agreement_id` BIGINT COMMENT 'Foreign key linking to supplier.lead_time_agreement. Business justification: Procurement compliance auditing requires tracing each PO to its governing lead_time_agreement to verify contracted lead times are honored. Buyers and compliance teams expect POs to reference the SLA a',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.associate. Business justification: DC receiving coordinators manage PO receipts for operational ownership and accountability. Operations tracks receipt accuracy, cycle time, and discrepancy resolution by coordinator for performance man',
    `promo_calendar_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_calendar. Business justification: Promotional PO Management: buyers create purchase orders timed to promo_calendar periods to ensure promotional inventory arrives before campaign start. Retail merchandising teams track PO on-time deli',
    `dc_facility_id` BIGINT COMMENT 'Reference to the distribution center or store location designated as the delivery destination for this purchase order. Corresponds to SAP EKKO.WERKS (plant/site).',
    `vendor_id` BIGINT COMMENT 'Reference to the supplier (vendor) fulfilling this purchase order. Links to the supplier master data product managed in the customer master data system. Corresponds to SAP EKKO.LIFNR (vendor account number).',
    `actual_delivery_date` DATE COMMENT 'The date on which goods were physically received at the destination facility. Populated upon goods receipt posting in SAP (MIGO transaction). Used to calculate supplier on-time delivery performance and lead time actuals.',
    `approval_status` STRING COMMENT 'Authorization workflow status indicating whether the purchase order has been approved by the required approvers per the companys procurement authorization matrix. Distinct from po_status as it tracks the internal approval gate specifically.. Valid values are `pending|approved|rejected|escalated`',
    `approved_timestamp` TIMESTAMP COMMENT 'The timestamp when the purchase order received final authorization approval. Captures the precise moment the procurement commitment became binding. Used for approval cycle time analytics and compliance auditing.',
    `cancellation_date` DATE COMMENT 'The date by which the purchase order must be cancelled if goods have not shipped. Also known as the cancel date or cancel-by date in retail procurement. Null if the PO has not been cancelled or does not have a cancellation deadline.',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity or business unit issuing the purchase order. Used for financial reporting, P&L allocation, and intercompany reconciliation. Corresponds to SAP EKKO.BUKRS.',
    `confirmed_delivery_date` DATE COMMENT 'The delivery date confirmed by the supplier after PO acknowledgment. May differ from expected_delivery_date if the supplier cannot meet the original requested date. Used to update replenishment plans and manage weeks of supply (WOS).',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the purchase order record was first created in the source system. Audit trail field for data lineage and compliance. Corresponds to SAP EKKO.AEDAT (creation date) combined with time.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts on this purchase order (e.g., USD, EUR, GBP, CAD). Corresponds to SAP EKKO.WAERS (currency key).. Valid values are `^[A-Z]{3}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount or allowance amount applied to the purchase order by the supplier, including volume discounts, promotional allowances, and trade deals. Reduces the net payable amount. Expressed in the currency specified by currency_code.',
    `edi_transmission_status` STRING COMMENT 'Status of the EDI (Electronic Data Interchange) transmission of this purchase order to the supplier. Not Sent = EDI not applicable or not yet initiated; Pending = queued for transmission; Transmitted = EDI 850 PO sent to supplier; Acknowledged = supplier returned EDI 855 acknowledgment; Failed = transmission error; Rejected = supplier rejected the PO via EDI.. Valid values are `not_sent|pending|transmitted|acknowledged|failed|rejected`',
    `edi_transmitted_timestamp` TIMESTAMP COMMENT 'The timestamp when the purchase order was transmitted to the supplier via EDI (Electronic Data Interchange) as an EDI 850 transaction set. Null if EDI transmission has not occurred. Used for supplier communication SLA tracking.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign currency exchange rate applied to convert the purchase order amounts from the suppliers transaction currency to the companys functional currency at the time of PO creation. Corresponds to SAP EKKO.WKURS.',
    `expected_delivery_date` DATE COMMENT 'The agreed-upon date by which the supplier is expected to deliver the ordered goods to the designated distribution center or store. Used for supply chain planning, replenishment scheduling, and SLA monitoring. Corresponds to SAP EKET.EINDT (scheduled delivery date).',
    `fill_rate_pct` DECIMAL(18,2) COMMENT 'The percentage of ordered units that have been received and fulfilled by the supplier, calculated as (total_received_units / total_ordered_units) * 100. Fill Rate is a key supplier performance KPI measuring order completion. Stored as a pre-computed operational field updated upon each goods receipt.',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the responsibilities of buyer and seller for delivery, risk transfer, and cost allocation (e.g., FOB = Free On Board, DDP = Delivered Duty Paid, CIF = Cost Insurance Freight). Corresponds to SAP EKKO.INCO1. Critical for import/export compliance and logistics cost allocation. [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF — 11 candidates stripped; promote to reference product]',
    `incoterms_location` STRING COMMENT 'The named place or port associated with the Incoterms code, specifying the exact location where risk and cost transfer between buyer and seller (e.g., Port of Los Angeles for FOB). Corresponds to SAP EKKO.INCO2.',
    `is_cross_dock` BOOLEAN COMMENT 'Indicates whether this purchase order is designated for cross-docking at the distribution center, meaning goods will be transferred directly from inbound to outbound without putaway storage. Cross-docking reduces DC handling costs and accelerates store replenishment.',
    `is_drop_ship` BOOLEAN COMMENT 'Indicates whether this purchase order is a drop ship arrangement where the supplier ships goods directly to the end customer, bypassing the retailers distribution center. Drop ship POs are common in e-commerce and extended aisle assortments.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when the purchase order record was most recently modified in the source system. Used for incremental data loading, change data capture, and audit compliance.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'The minimum quantity the supplier requires for this purchase order, as defined in the supplier agreement or item master. MOQ (Minimum Order Quantity) constraints drive order sizing decisions in replenishment planning and OTB management.',
    `net_payable_amount` DECIMAL(18,2) COMMENT 'The net amount payable to the supplier after applying all discounts, allowances, and adjustments to the gross total order amount. This is the financial commitment recorded in accounts payable. Expressed in the currency specified by currency_code.',
    `notes` STRING COMMENT 'Free-text field for buyer notes, special instructions, or remarks associated with the purchase order. May include delivery instructions, quality requirements, or supplier-specific handling notes. Corresponds to SAP EKKO.IHREZ (your reference) or header text.',
    `order_date` DATE COMMENT 'The business date on which the purchase order was officially created and issued. This is the principal real-world event date for the procurement commitment. Corresponds to SAP EKKO.BEDAT (document date).',
    `payment_terms_code` STRING COMMENT 'Code representing the agreed payment terms between the retailer and supplier (e.g., NET30, NET60, 2/10NET30 for 2% discount if paid within 10 days). Corresponds to SAP EKKO.ZTERM (terms of payment key). Drives accounts payable scheduling and early payment discount capture.',
    `po_number` STRING COMMENT 'Externally-known, human-readable purchase order number assigned by the procurement system (SAP MM or the retail merchandising system). Used in EDI transmissions, supplier communications, and receiving workflows. Corresponds to SAP EKKO.EBELN field.. Valid values are `^PO-[0-9]{8,12}$`',
    `po_status` STRING COMMENT 'Current lifecycle state of the purchase order from creation through closure. Draft = created but not submitted; Pending Approval = awaiting authorization; Approved = authorized for transmission; Sent = transmitted to supplier via EDI or portal; Partially Received = some goods received; Received = all goods received; Closed = fully processed and closed; Cancelled = voided. [ENUM-REF-CANDIDATE: draft|pending_approval|approved|sent|partially_received|received|closed|cancelled — promote to reference product]',
    `po_type` STRING COMMENT 'Classification of the purchase order by procurement method. Standard = regular replenishment PO; Blanket = open-quantity framework agreement; DSD (Direct Store Delivery) = supplier delivers directly to store; Drop Ship = vendor ships direct to customer; Consignment = inventory owned by supplier until sold; RTV (Return to Vendor) = merchandise returned to supplier. [ENUM-REF-CANDIDATE: standard|blanket|direct_store_delivery|drop_ship|consignment|return_to_vendor — promote to reference product]',
    `purchasing_group_code` STRING COMMENT 'Code identifying the buyer group or commodity team responsible for this purchase order within the purchasing organization. Used for spend analytics by category and buyer performance reporting. Corresponds to SAP EKKO.EKGRP.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code representing the organizational unit responsible for procuring goods and services. Defines the legal entity and negotiation authority for the purchase order. Corresponds to SAP EKKO.EKORG.',
    `source_system_code` STRING COMMENT 'Identifies the operational system of record from which this purchase order record originated. SAP_MM = SAP S/4HANA Materials Management; ORMS = the retail merchandising system Merchandising System; MANUAL = manually entered; EDI = created via EDI inbound processing. Used for data lineage and reconciliation.. Valid values are `SAP_MM|ORMS|MANUAL|EDI`',
    `supplier_po_reference` STRING COMMENT 'The suppliers own reference number or acknowledgment number for this purchase order, returned via EDI 855 or supplier portal. Used for cross-referencing in supplier invoices, ASNs (Advance Ship Notices), and dispute resolution.',
    `total_order_amount` DECIMAL(18,2) COMMENT 'The gross total monetary value of the purchase order before any adjustments, representing the sum of all line item values. Expressed in the currency specified by currency_code. Used for open-to-buy (OTB) tracking, financial commitments, and accounts payable accruals.',
    `total_ordered_units` DECIMAL(18,2) COMMENT 'The total quantity of units ordered across all line items on this purchase order. Used for fill rate calculation, receiving reconciliation, and inventory planning. Expressed in the base unit of measure.',
    `total_received_units` DECIMAL(18,2) COMMENT 'The total quantity of units physically received and goods-receipted against this purchase order to date. Used to calculate fill rate (order completion percentage) and identify short shipments or over-deliveries.',
    CONSTRAINT pk_purchase_order PRIMARY KEY(`purchase_order_id`)
) COMMENT 'Purchase order header records representing procurement commitments to suppliers, managed in SAP MM or the retail merchandising system number, supplier reference, buyer, order and expected delivery dates, total value, currency, payment terms, incoterms, PO type (standard, blanket, DSD), approval status, and EDI transmission status. SSOT for the PO lifecycle from creation through closure.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplychain`.`po_line` (
    `po_line_id` BIGINT COMMENT 'Unique surrogate identifier for each purchase order line item in the Silver Layer lakehouse. Primary key for the po_line data product.',
    `buyer_id` BIGINT COMMENT 'Reference to the merchandise buyer or procurement officer responsible for this PO line. Supports buyer performance reporting, OTB management, and approval workflow tracking.',
    `department_id` BIGINT COMMENT 'Reference to the merchandise department or category to which this PO lines SKU belongs. Supports departmental OTB tracking, assortment planning, and financial reporting by merchandise hierarchy.',
    `gtin_registry_id` BIGINT COMMENT 'Foreign key linking to product.gtin_registry. Business justification: po_line carries a plain gtin column (denormalized). GTIN is the primary identifier used in EDI 850/855 PO transactions and ASN matching. Linking to gtin_registry normalizes barcode data, enables GS1',
    `inbound_shipment_id` BIGINT COMMENT 'Foreign key linking to supplychain.inbound_shipment. Business justification: PO lines are fulfilled by inbound shipments in retail supply chain operations. Adding inbound_shipment_id as a FK on po_line enables direct receiving reconciliation — linking what was ordered (po_line',
    `dc_facility_id` BIGINT COMMENT 'Reference to the specific destination location (DC, store, or fulfillment center) where this PO line is to be delivered. Supports multi-destination PO management and DC-to-store allocation.',
    `sku_id` BIGINT COMMENT 'Reference to the master product record for the item being ordered on this PO line. Links to the product master for full item attributes. [RESOURCE_REFERENCE — TRANSACTION_LINE canonical category]',
    `vendor_id` BIGINT COMMENT 'Reference to the supplier (vendor) fulfilling this PO line. Enables supplier performance analysis at the line level, including fill rate and lead time compliance.',
    `purchase_order_id` BIGINT COMMENT 'Reference to the parent purchase order header to which this line item belongs. Establishes the header-to-line relationship for PO lifecycle tracking. [HEADER_REFERENCE — TRANSACTION_LINE canonical category]',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: po_line carries a plain uom text column (denormalized). Ordering UOM (case, each, pallet) is critical for PO quantity validation, invoice matching, and receiving reconciliation. Linking to product.u',
    `actual_delivery_date` DATE COMMENT 'The date on which goods for this PO line were physically received at the destination. Used to calculate on-time delivery performance and actual lead time versus committed lead time.',
    `allowance_amount` DECIMAL(18,2) COMMENT 'Supplier-granted trade allowance or promotional funding amount applied to this PO line (e.g., off-invoice allowance, scan allowance). Reduces net cost and impacts COGS and GMROI calculations.',
    `cancel_date` DATE COMMENT 'The latest date by which this PO line must be received; if not received by this date, the line is automatically cancelled. Critical for seasonal and fashion merchandise to prevent late deliveries.',
    `confirmed_delivery_date` DATE COMMENT 'The delivery date confirmed by the supplier for this PO line. May differ from the requested delivery date; variance drives lead time compliance KPIs and supplier scorecards.',
    `confirmed_qty` DECIMAL(18,2) COMMENT 'Quantity confirmed by the supplier as available and committed for shipment on this PO line. May differ from ordered quantity due to supplier capacity constraints or MOQ adjustments.',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the product on this PO line was manufactured or produced. Required for customs declarations, import compliance, and consumer labeling regulations.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this PO line record was first created in the system, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Provides audit trail for PO creation and supports data lineage tracking.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the unit cost and extended cost on this PO line (e.g., USD, EUR, GBP). Required for multi-currency supplier contracts and financial consolidation.. Valid values are `^[A-Z]{3}$`',
    `destination_type` STRING COMMENT 'Type of destination for this PO line shipment. Indicates whether goods are routed to a Distribution Center (DC), direct to store (DSD), cross-docking facility, drop ship to customer, or Micro-Fulfillment Center (MFC).. Valid values are `dc|store|cross_dock|drop_ship|mfc`',
    `extended_cost` DECIMAL(18,2) COMMENT 'Total cost for this PO line calculated as ordered_qty multiplied by unit_cost. Represents the gross financial commitment for this line item before any allowances or discounts.',
    `incoterms` STRING COMMENT 'ICC Incoterms code defining the delivery terms and transfer of risk/cost responsibility between buyer and supplier for this PO line (e.g., FOB, DDP, CIF). Critical for landed cost calculation and logistics planning. [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF — 11 candidates stripped; promote to reference product]',
    `invoice_number` STRING COMMENT 'Supplier invoice number associated with this PO line for three-way match processing (PO, receipt, invoice). Links to accounts payable for payment processing and FASB ASC 606 revenue recognition compliance.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this PO line record, in ISO 8601 format (yyyy-MM-ddTHH:mm:ss.SSSXXX). Supports change data capture, audit compliance, and Silver Layer incremental processing.',
    `lead_time_days` STRING COMMENT 'Committed supplier lead time in calendar days from PO placement to expected delivery for this line item. Used for replenishment planning, OTB management, and supplier SLA compliance monitoring.',
    `line_number` STRING COMMENT 'Sequential line item number within the parent purchase order, used to uniquely identify and order line items within a PO. Corresponds to SAP MM item number (EBELP). [LINE_SEQUENCE — TRANSACTION_LINE canonical category]',
    `line_status` STRING COMMENT 'Current workflow status of this PO line item, tracking progression from open through fulfillment or cancellation. Drives replenishment alerts and supplier follow-up actions. [LIFECYCLE_STATUS — TRANSACTION_LINE canonical category]. Valid values are `open|confirmed|partially_received|fully_received|cancelled|closed`',
    `moq` DECIMAL(18,2) COMMENT 'The suppliers contractual Minimum Order Quantity (MOQ) for this SKU on this PO line. Used to validate ordered_qty compliance and negotiate order consolidation.',
    `moq_compliant` BOOLEAN COMMENT 'Indicates whether the ordered quantity on this PO line meets or exceeds the suppliers Minimum Order Quantity (MOQ) requirement. Non-compliant lines may incur supplier penalties or require buyer approval.',
    `net_cost` DECIMAL(18,2) COMMENT 'Net cost per unit after applying all supplier allowances, discounts, and deductions to the unit cost. Represents the true landed cost basis for COGS and margin calculations.',
    `order_uom_qty` DECIMAL(18,2) COMMENT 'Number of base selling units (eaches) contained within one purchase unit of measure. Enables conversion between purchase UOM and retail selling UOM for inventory and sales reporting (e.g., 12 eaches per case).',
    `ordered_qty` DECIMAL(18,2) COMMENT 'Total quantity of the SKU ordered on this PO line, expressed in the purchase unit of measure. Represents the buyers original demand signal to the supplier. [LINE_QUANTITY — TRANSACTION_LINE canonical category]',
    `otb_consumed` DECIMAL(18,2) COMMENT 'Dollar value of Open to Buy (OTB) budget consumed by this PO line at the time of order placement. Used for merchandise financial planning and budget compliance monitoring.',
    `received_qty` DECIMAL(18,2) COMMENT 'Quantity of the SKU physically received and confirmed at the distribution center or store against this PO line. Drives inventory on-hand updates and three-way match for invoice processing.',
    `rejection_reason` STRING COMMENT 'Reason code or description for any quantity rejected or returned to vendor (RTV) during receiving for this PO line (e.g., damaged goods, wrong item, quality failure). Supports chargeback processing and supplier compliance management.',
    `requested_delivery_date` DATE COMMENT 'The date by which the retailer requests delivery of this PO line at the destination (DC or store). Used for lead time compliance monitoring and replenishment planning.',
    `retail_price` DECIMAL(18,2) COMMENT 'Planned retail selling price (AUR - Average Unit Retail) for this SKU at the time of PO creation. Used for initial margin calculation and GMROI planning at the line level.',
    `ship_date` DATE COMMENT 'Date on which the supplier shipped goods for this PO line, as reported via ASN or EDI 856. Used to calculate in-transit duration and validate supplier shipping compliance.',
    `shipped_qty` DECIMAL(18,2) COMMENT 'Quantity of the SKU that the supplier has physically shipped against this PO line, as reported via ASN (Advance Shipment Notice) or EDI 856. Used to calculate in-transit inventory.',
    `sku` STRING COMMENT 'Internal retailer-assigned Stock Keeping Unit code identifying the specific product variant (size, color, style) ordered on this line. Used for inventory management and POS reconciliation.',
    `unit_cost` DECIMAL(18,2) COMMENT 'Agreed purchase cost per unit of the SKU on this PO line, in the transaction currency. Represents the negotiated supplier price and is the basis for COGS calculation and GMROI analysis. [LINE_VALUE_OR_RESULT — TRANSACTION_LINE canonical category]',
    `vendor_item_number` STRING COMMENT 'Suppliers own item number or part number for the product on this PO line. Used in EDI transactions and supplier communications to cross-reference retailer SKU with supplier catalog number.',
    CONSTRAINT pk_po_line PRIMARY KEY(`po_line_id`)
) COMMENT 'Line-item detail for each purchase order. Captures SKU/GTIN, ordered quantity, unit of measure, unit cost, extended cost, confirmed quantity, shipped quantity, received quantity, line status, MOQ compliance flag, and lead-time commitment. Enables granular PO tracking at the SKU level.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` (
    `dc_facility_id` BIGINT COMMENT 'Unique identifier for the distribution center or micro-fulfillment center facility. Primary key for the DC facility master record.',
    `location_id` BIGINT COMMENT 'add column location_id (BIGINT) with FK to store.location.location_id - DC facilities have physical addresses and should reference the location master for geographic consistency',
    `address_line_1` STRING COMMENT 'Primary street address line for the facility (street number, street name, building identifier).',
    `address_line_2` STRING COMMENT 'Secondary address line for additional location details (suite, floor, building name) if applicable.',
    `automation_level` STRING COMMENT 'Classification of the facilitys warehouse automation maturity: manual (labor-intensive), semi-automated (some mechanization), highly automated (extensive robotics and conveyors), or fully automated (lights-out operations).. Valid values are `manual|semi_automated|highly_automated|fully_automated`',
    `bonded_warehouse_flag` BOOLEAN COMMENT 'Indicates whether the facility is a customs-bonded warehouse authorized to store imported goods before duties and taxes are paid, enabling deferred duty payment and re-export options.',
    `city` STRING COMMENT 'City or municipality where the facility is located.',
    `closed_date` DATE COMMENT 'Date when the facility was permanently closed or decommissioned. Null for active facilities.',
    `country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code where the facility is located (e.g., USA, CAN, MEX).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this facility record was first created in the master data system.',
    `dock_door_count` STRING COMMENT 'Total number of loading dock doors available for inbound receiving and outbound shipping operations.',
    `facility_code` STRING COMMENT 'Business-assigned unique alphanumeric code for the facility used in operational systems, shipping documents, and cross-system integration. Typically 4-12 characters.. Valid values are `^[A-Z0-9]{4,12}$`',
    `facility_email_address` STRING COMMENT 'Primary email address for the facility used for operational communications, appointment confirmations, and document exchange.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `facility_manager_name` STRING COMMENT 'Full name of the facility manager or site director responsible for day-to-day operations and performance.',
    `facility_name` STRING COMMENT 'Official business name of the distribution center or fulfillment facility (e.g., Northeast Regional DC, Manhattan MFC-01).',
    `facility_phone_number` STRING COMMENT 'Primary contact phone number for the facility used for carrier coordination, supplier communication, and operational inquiries.',
    `facility_status` STRING COMMENT 'Current operational lifecycle status of the facility. Active facilities are fully operational; planned facilities are approved but not yet built; under construction facilities are being built; decommissioned facilities are permanently closed; temporarily closed facilities are inactive but may reopen; seasonal facilities operate only during peak periods.. Valid values are `active|planned|under_construction|decommissioned|temporarily_closed|seasonal`',
    `facility_type` STRING COMMENT 'Classification of the facility based on its primary operational purpose: regional DC (large-scale distribution), micro-fulfillment center (MFC for rapid e-commerce), dark store (fulfillment-only, no retail), cross-dock hub (transshipment), returns center (reverse logistics), or forward stocking location (FSL).. Valid values are `regional_dc|micro_fulfillment_center|dark_store|cross_dock_hub|returns_center|forward_stocking_location`',
    `gln` STRING COMMENT 'GS1-issued 13-digit Global Location Number uniquely identifying this facility in global supply chain transactions and EDI exchanges.. Valid values are `^[0-9]{13}$`',
    `hazmat_certified_flag` BOOLEAN COMMENT 'Indicates whether the facility is certified and equipped to handle, store, and ship hazardous materials in compliance with DOT and OSHA regulations.',
    `inbound_dock_door_count` STRING COMMENT 'Number of dock doors dedicated to inbound receiving operations from suppliers and carriers.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this facility record was most recently modified in the master data system.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the facility in decimal degrees for mapping, routing, and geospatial analytics.',
    `lease_expiration_date` DATE COMMENT 'Date when the current facility lease agreement expires. Null for owned facilities. Used for lease renewal planning and financial forecasting.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the facility in decimal degrees for mapping, routing, and geospatial analytics.',
    `opened_date` DATE COMMENT 'Date when the facility first became operational and began processing inventory and orders.',
    `operating_hours_weekday` STRING COMMENT 'Standard operating hours for the facility on weekdays (Monday-Friday) in format HH:MM-HH:MM (e.g., 06:00-22:00). Used for appointment scheduling and labor planning.',
    `operating_hours_weekend` STRING COMMENT 'Standard operating hours for the facility on weekends (Saturday-Sunday) in format HH:MM-HH:MM. May differ from weekday hours or indicate closed status.',
    `outbound_dock_door_count` STRING COMMENT 'Number of dock doors dedicated to outbound shipping operations to stores, customers, or other facilities.',
    `ownership_type` STRING COMMENT 'Indicates whether the facility is owned by the company, leased from a landlord, or operated by a third-party logistics provider (3PL). Impacts financial reporting and operational control.. Valid values are `owned|leased|third_party_operated`',
    `owning_region_code` STRING COMMENT 'Business region or geographic division code that owns and manages this facility (e.g., NORTHEAST, WEST, CENTRAL). Used for organizational hierarchy and P&L reporting.',
    `postal_code` STRING COMMENT 'Postal or ZIP code for the facility address used for mail delivery and geographic routing.',
    `state_province_code` STRING COMMENT 'Two-letter ISO 3166-2 subdivision code for the state, province, or region (e.g., CA for California, ON for Ontario).. Valid values are `^[A-Z]{2}$`',
    `storage_capacity_cubic_feet` DECIMAL(18,2) COMMENT 'Total volumetric storage capacity of the facility measured in cubic feet, accounting for vertical storage utilization.',
    `storage_capacity_pallet_positions` STRING COMMENT 'Maximum number of standard pallet positions available for inventory storage in racking and floor storage.',
    `temperature_zone_ambient_flag` BOOLEAN COMMENT 'Indicates whether the facility has ambient temperature storage zones (room temperature, non-climate-controlled) for general merchandise.',
    `temperature_zone_chilled_flag` BOOLEAN COMMENT 'Indicates whether the facility has refrigerated (chilled) storage zones typically maintained at 32-40°F for perishable goods like dairy and produce.',
    `temperature_zone_frozen_flag` BOOLEAN COMMENT 'Indicates whether the facility has frozen storage zones typically maintained at 0°F or below for frozen foods and ice cream.',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the facility location (e.g., America/New_York, America/Chicago) used for scheduling and timestamp normalization.',
    `total_square_footage` DECIMAL(18,2) COMMENT 'Total building square footage of the facility including warehouse space, office space, and support areas. Measured in square feet.',
    `twenty_four_seven_operation_flag` BOOLEAN COMMENT 'Indicates whether the facility operates continuously 24 hours per day, 7 days per week to support high-volume or time-sensitive fulfillment requirements.',
    `warehouse_square_footage` DECIMAL(18,2) COMMENT 'Square footage dedicated to warehouse operations including storage, picking, packing, and staging areas. Measured in square feet.',
    `wms_instance_code` STRING COMMENT 'Identifier for the Manhattan WMS instance or system deployment that manages this facilitys warehouse operations. Used for system integration and data routing.',
    CONSTRAINT pk_dc_facility PRIMARY KEY(`dc_facility_id`)
) COMMENT 'Master record for each distribution center (DC) and micro-fulfillment center (MFC) operated by Retail. Captures facility type (regional DC, MFC, dark store, cross-dock hub, returns center), physical address, square footage, storage capacity (pallet positions, cubic feet), temperature zones (ambient, chilled, frozen), dock door count, operating hours, facility status (active, planned, decommissioned), owning region, and Manhattan WMS instance assignment. SSOT for DC/MFC identity referenced by all distribution operations including zone layout, dock scheduling, carrier assignments, and performance tracking.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` (
    `warehouse_zone_id` BIGINT COMMENT 'Unique identifier for the warehouse zone. Primary key for the warehouse zone entity.',
    `dc_facility_id` BIGINT COMMENT 'Reference to the parent distribution center or micro-fulfillment center (MFC) that contains this zone.',
    `inventory_node_id` BIGINT COMMENT 'add column inventory_node_id (BIGINT) with FK to inventory.inventory_node.inventory_node_id - warehouse zones are inventory storage locations and should link to the inventory node for stock visibility',
    `aisle_range_end` STRING COMMENT 'Ending aisle identifier for the zone, defining the end of the physical aisle range contained within this zone for pick path optimization.. Valid values are `^[A-Z0-9]{1,5}$`',
    `aisle_range_start` STRING COMMENT 'Starting aisle identifier for the zone, defining the beginning of the physical aisle range contained within this zone for pick path optimization.. Valid values are `^[A-Z0-9]{1,5}$`',
    `automation_type` STRING COMMENT 'Level and type of automation deployed in the zone. ASRS = Automated Storage and Retrieval System, AMR = Autonomous Mobile Robot, AGV = Automated Guided Vehicle. [ENUM-REF-CANDIDATE: manual|conveyor|asrs|shuttle|amr|agv|robotic_pick — 7 candidates stripped; promote to reference product]',
    `barcode_scanning_required_flag` BOOLEAN COMMENT 'Indicates whether barcode scanning is mandatory for all inventory movements within the zone to ensure location accuracy and inventory integrity.',
    `cost_center_code` STRING COMMENT 'Financial cost center code for tracking labor, equipment, and operational expenses associated with the zone for profit and loss (P&L) reporting.. Valid values are `^[A-Z0-9]{4,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the zone record was first created in the warehouse management system, used for audit trail and data lineage.',
    `current_occupancy_pct` DECIMAL(18,2) COMMENT 'Current space utilization percentage of the zone, calculated as occupied capacity divided by total capacity, used for capacity management and slotting decisions.',
    `cycle_count_frequency` STRING COMMENT 'Scheduled frequency for physical inventory cycle counting within the zone, used for inventory accuracy management and shrinkage control.. Valid values are `daily|weekly|monthly|quarterly|annual|on_demand`',
    `effective_end_date` DATE COMMENT 'Date when the zone configuration was deactivated or retired from warehouse operations. Null indicates the zone is currently active.',
    `effective_start_date` DATE COMMENT 'Date when the zone configuration became active and available for warehouse operations.',
    `hazmat_certified_flag` BOOLEAN COMMENT 'Indicates whether the zone is certified and equipped for storage of hazardous materials per OSHA and DOT regulations.',
    `last_cycle_count_date` DATE COMMENT 'Date of the most recent physical inventory cycle count performed in the zone, used for audit trail and inventory accuracy monitoring.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the zone record was most recently modified, used for change tracking and audit trail purposes.',
    `location_count` STRING COMMENT 'Total number of individual storage locations (bins, slots, shelves, pallet positions) contained within this zone for granular inventory tracking.',
    `next_scheduled_cycle_count_date` DATE COMMENT 'Planned date for the next physical inventory cycle count in the zone, used for operational planning and resource scheduling.',
    `notes` STRING COMMENT 'Free-form text field for additional operational notes, special handling instructions, or configuration details relevant to the zone.',
    `pick_method` STRING COMMENT 'Primary order picking methodology used in the zone, determining workflow design and labor productivity metrics.. Valid values are `discrete|batch|zone|wave|cluster`',
    `rack_configuration_type` STRING COMMENT 'Type of racking system installed in the zone, determining storage density, accessibility, and material handling equipment requirements.. Valid values are `selective|drive_in|push_back|flow|pallet_flow|cantilever`',
    `replenishment_priority_rank` STRING COMMENT 'Priority ranking for zone replenishment tasks, with lower numbers indicating higher priority for maintaining forward pick face availability.',
    `rfid_enabled_flag` BOOLEAN COMMENT 'Indicates whether the zone is equipped with RFID infrastructure for automated inventory tracking and real-time location visibility.',
    `security_level` STRING COMMENT 'Security classification of the zone determining access control requirements, used for high-value merchandise, controlled substances, or restricted inventory.. Valid values are `standard|restricted|high_value|controlled_substance`',
    `slotting_strategy` STRING COMMENT 'Inventory slotting methodology applied to the zone for optimizing pick efficiency, labor productivity, and space utilization.. Valid values are `velocity_based|product_affinity|size_based|random|fixed`',
    `temperature_classification` STRING COMMENT 'Temperature control requirement for the zone, critical for grocery retail operations managing perishable goods and food safety compliance.. Valid values are `ambient|chilled|frozen|temperature_controlled`',
    `temperature_max_celsius` DECIMAL(18,2) COMMENT 'Maximum allowable temperature threshold for temperature-controlled zones, measured in degrees Celsius. Used for cold chain monitoring and food safety compliance.',
    `temperature_min_celsius` DECIMAL(18,2) COMMENT 'Minimum allowable temperature threshold for temperature-controlled zones, measured in degrees Celsius. Used for cold chain monitoring and food safety compliance.',
    `total_capacity_cubic_meters` DECIMAL(18,2) COMMENT 'Total volumetric storage capacity of the zone measured in cubic meters, used for space utilization analysis and capacity planning.',
    `total_capacity_pallet_positions` STRING COMMENT 'Total number of standard pallet positions available in the zone, critical for slotting optimization and inventory capacity management.',
    `weight_capacity_kg` DECIMAL(18,2) COMMENT 'Maximum weight capacity of the zone in kilograms, constrained by floor loading limits and rack weight ratings for safety compliance.',
    `zone_code` STRING COMMENT 'Business identifier code for the zone, used for operational reference and pick path planning within the warehouse management system (WMS).. Valid values are `^[A-Z0-9]{2,10}$`',
    `zone_name` STRING COMMENT 'Human-readable name of the zone describing its purpose or location within the facility (e.g., Receiving Dock A, Bulk Storage North, Forward Pick Zone 1, Packing Station B).',
    `zone_status` STRING COMMENT 'Current operational status of the zone indicating availability for warehouse operations and inventory placement.. Valid values are `active|inactive|maintenance|blocked|quarantine|seasonal`',
    `zone_type` STRING COMMENT 'Functional classification of the zone indicating its primary operational purpose within the distribution center workflow. [ENUM-REF-CANDIDATE: receiving|bulk_storage|forward_pick|reserve|packing|staging|dispatch|returns|cross_dock — 9 candidates stripped; promote to reference product]',
    CONSTRAINT pk_warehouse_zone PRIMARY KEY(`warehouse_zone_id`)
) COMMENT 'Defines the complete physical layout hierarchy within a DC or MFC, from zones (receiving, bulk storage, forward pick, packing, staging, dispatch, returns) down to individual storage locations (bin, slot, shelf, pallet position, floor stack). Zone-level attributes include zone code, type, temperature classification (ambient, chilled, frozen), aisle range, rack configuration (selective, drive-in, push-back, flow), automation type (manual, conveyor, AS/RS, shuttle, AMR), and zone capacity metrics. Location-level attributes include location code, aisle, bay, level, position, location type (bulk, pick face, reserve, floor, overflow), weight capacity, cubic capacity, RFID/barcode tag, and current occupancy status. SSOT for all physical space definitions within a facility — supports slotting optimization, pick path planning, capacity management, and location-level inventory tracking within Manhattan WMS.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` (
    `inbound_shipment_id` BIGINT COMMENT 'Primary key for inbound_shipment',
    `carrier_id` BIGINT COMMENT 'Identifier of the transportation carrier responsible for delivering this shipment. Used for carrier performance tracking and freight audit.',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.location. Business justification: Direct Store Delivery (DSD) shipments bypass the DC and arrive directly at store locations. The DSD Receiving process requires inbound_shipment to reference the destination store location for dock sch',
    `vendor_id` BIGINT COMMENT 'Identifier of the supplier or vendor originating this shipment. Links to supplier master data for performance tracking and compliance monitoring.',
    `dc_facility_id` BIGINT COMMENT 'Identifier of the originating facility for inter-facility transfers. Null for supplier-direct shipments.',
    `primary_inbound_dc_facility_id` BIGINT COMMENT 'Identifier of the distribution center or micro-fulfillment center receiving this shipment. Determines facility-specific receiving workflows and capacity planning.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Promotional Inventory Readiness Tracking: inbound shipments of promotional merchandise are tagged to promo_campaign to track on-time arrival vs. campaign start_date. Retail supply chain teams run Prom',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Inbound shipments arrive at DCs in fulfillment of purchase orders. Linking inbound_shipment to purchase_order via a purchase_order_id FK enables end-to-end PO lifecycle tracking: from order creation t',
    `actual_arrival_date` DATE COMMENT 'Actual date the shipment arrived at the distribution center. Used for on-time delivery performance measurement and carrier scorecarding.',
    `actual_arrival_timestamp` TIMESTAMP COMMENT 'Precise date and time the shipment actually arrived at the distribution center. Captured by yard management system or gate check-in.',
    `actual_carton_count` STRING COMMENT 'Total number of cartons actually received and verified during receiving operations. Compared against expected count for discrepancy resolution.',
    `actual_pallet_count` STRING COMMENT 'Total number of pallets actually received during receiving operations. Compared against expected count for variance analysis.',
    `actual_weight_kg` DECIMAL(18,2) COMMENT 'Total actual weight of the shipment in kilograms as measured during receiving. Used for freight cost verification and variance analysis.',
    `asn_number` STRING COMMENT 'Reference number from the EDI 856 Advance Ship Notice document sent by the supplier prior to shipment arrival. Critical for pre-receiving planning and dock scheduling.',
    `bill_of_lading_number` STRING COMMENT 'Legal document number issued by the carrier acknowledging receipt of cargo for shipment. Serves as contract of carriage and receipt.',
    `carrier_scac_code` STRING COMMENT 'Four-letter code uniquely identifying the transportation carrier. Standard identifier used in EDI transactions and freight documentation.. Valid values are `^[A-Z]{2,4}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this shipment record was first created in the system. Used for audit trail and data lineage tracking.',
    `cross_dock_flag` BOOLEAN COMMENT 'Indicates whether this shipment is designated for cross-docking operations, bypassing putaway and moving directly to outbound staging.',
    `dock_door_number` STRING COMMENT 'Identifier of the specific dock door assigned for receiving this shipment. Used for yard management and receiving workflow coordination.',
    `expected_arrival_date` DATE COMMENT 'Planned date the shipment is expected to arrive at the distribution center. Used for dock scheduling and labor planning.',
    `expected_arrival_timestamp` TIMESTAMP COMMENT 'Precise date and time the shipment is expected to arrive at the distribution center. Used for appointment scheduling and dock door allocation.',
    `expected_carton_count` STRING COMMENT 'Total number of cartons expected in this shipment as communicated in the ASN. Used for receiving planning and variance detection.',
    `expected_cube_m3` DECIMAL(18,2) COMMENT 'Total expected volume of the shipment in cubic meters. Used for warehouse space planning and transportation capacity optimization.',
    `expected_pallet_count` STRING COMMENT 'Total number of pallets expected in this shipment as communicated in the ASN. Used for dock space allocation and material handling equipment planning.',
    `expected_weight_kg` DECIMAL(18,2) COMMENT 'Total expected weight of the shipment in kilograms as communicated in the ASN. Used for freight audit and capacity planning.',
    `freight_cost_amount` DECIMAL(18,2) COMMENT 'Total freight transportation cost for this inbound shipment. Used for landed cost calculation and freight spend analysis.',
    `freight_currency_code` STRING COMMENT 'Three-letter ISO currency code for the freight cost amount. Enables multi-currency freight cost tracking and consolidation.. Valid values are `^[A-Z]{3}$`',
    `hazmat_flag` BOOLEAN COMMENT 'Indicates whether this shipment contains hazardous materials requiring special handling and regulatory compliance. True triggers HAZMAT receiving protocols.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this shipment record was most recently modified. Used for change tracking and data synchronization.',
    `late_arrival_reason_code` STRING COMMENT 'Standardized code explaining the reason for late arrival when on-time arrival flag is false. Used for root cause analysis and carrier accountability.',
    `notes` STRING COMMENT 'Free-text field for capturing additional information, special instructions, or exceptions related to this inbound shipment.',
    `on_time_arrival_flag` BOOLEAN COMMENT 'Indicates whether the shipment arrived within the scheduled appointment window. Used for carrier performance scorecarding and SLA compliance.',
    `pro_number` STRING COMMENT 'Carrier-assigned tracking number for the shipment. Used for freight tracking and proof of delivery.',
    `receiving_complete_timestamp` TIMESTAMP COMMENT 'Date and time when all receiving operations were completed for this shipment. Marks closure of the receiving process and inventory availability.',
    `receiving_start_timestamp` TIMESTAMP COMMENT 'Date and time when receiving operations began for this shipment. Marks the start of unloading and inspection activities.',
    `seal_number` STRING COMMENT 'Security seal number applied to the trailer or container. Verified at receiving to ensure shipment integrity and prevent tampering.',
    `shipment_number` STRING COMMENT 'Business identifier for the inbound shipment, typically referenced in communications with suppliers and carriers. May be system-generated or supplier-provided.',
    `shipment_status` STRING COMMENT 'Current lifecycle status of the inbound shipment. Tracks progression from in-transit through receiving completion or cancellation.. Valid values are `in_transit|arrived|receiving|closed|cancelled|delayed`',
    `shipment_type` STRING COMMENT 'Classification of the inbound shipment based on origin and purpose. Determines receiving workflow and handling requirements.. Valid values are `supplier_direct|inter_facility_transfer|vendor_managed_inventory|drop_ship_return|cross_dock`',
    `temperature_compliant_flag` BOOLEAN COMMENT 'Indicates whether the shipment maintained required temperature throughout transit. False triggers quality inspection and potential rejection.',
    `temperature_controlled_flag` BOOLEAN COMMENT 'Indicates whether this shipment requires temperature-controlled handling for cold chain compliance. True for refrigerated or frozen goods.',
    `temperature_max_celsius` DECIMAL(18,2) COMMENT 'Maximum acceptable temperature in Celsius for temperature-controlled shipments. Used for cold chain compliance monitoring.',
    `temperature_min_celsius` DECIMAL(18,2) COMMENT 'Minimum acceptable temperature in Celsius for temperature-controlled shipments. Used for cold chain compliance monitoring.',
    `temperature_requirement` STRING COMMENT 'Specific temperature range requirement for this shipment. Determines receiving dock assignment and storage location.. Valid values are `ambient|refrigerated|frozen|deep_frozen`',
    `trailer_number` STRING COMMENT 'Identification number of the trailer or container used to transport the shipment. Critical for yard management and dock door assignment.',
    CONSTRAINT pk_inbound_shipment PRIMARY KEY(`inbound_shipment_id`)
) COMMENT 'Tracks inbound shipments arriving at a DC or MFC from suppliers, vendors, or inter-facility transfers. Captures ASN (Advance Ship Notice) reference, carrier, trailer number, expected and actual arrival date/time, PO references, total carton and pallet counts, shipment status (in-transit, arrived, receiving, closed), and temperature compliance flag for cold chain shipments. Integrates with EDI 856 ASN feeds and Manhattan WMS receiving workflows. SSOT for all inbound freight visibility at the distribution center level.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` (
    `receiving_event_id` BIGINT COMMENT 'Unique identifier for the receiving event. Primary key for this product.',
    `buying_order_id` BIGINT COMMENT 'Foreign key linking to merchandising.buying_order. Business justification: Receiving events must validate physical receipts against original buying orders for discrepancy resolution. Warehouse operations notify buyers of shortages, overages, or quality issues by referencing ',
    `carrier_id` BIGINT COMMENT 'Reference to the carrier that delivered the inbound shipment.',
    `inbound_shipment_id` BIGINT COMMENT 'Reference to the inbound shipment being received at the dock door.',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.location. Business justification: Receiving temperature checks are logged in food_safety_log. Receiving events must reference specific temperature monitoring records for HACCP verification, regulatory audits, and product disposition d',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Receiving events are performed at the DC dock against specific purchase orders. The existing purchase_order_number STRING column is a denormalized text reference to the purchase order and should be re',
    `dc_facility_id` BIGINT COMMENT 'Reference to the distribution center where the receiving event occurred.',
    `vendor_id` BIGINT COMMENT 'Reference to the supplier who shipped the goods being received.',
    `vendor_item_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_item. Business justification: Receiving teams validate inbound goods against vendor_item specs (gtin, upc, inner_pack_quantity, unit_cost) to confirm compliance and trigger vendor scorecard updates. Receiving operations require di',
    `actual_carton_count` STRING COMMENT 'The actual number of cartons physically received and verified during the receiving event.',
    `actual_pallet_count` STRING COMMENT 'The actual number of pallets physically received and verified during the receiving event.',
    `actual_unit_quantity` STRING COMMENT 'The total number of individual units (eaches) physically received and verified during the receiving event.',
    `advance_ship_notice_number` STRING COMMENT 'The ASN number provided by the supplier, used to match expected shipment details with actual received goods.',
    `bill_of_lading_number` STRING COMMENT 'The bill of lading number associated with the inbound shipment, used for carrier reconciliation.',
    `carton_variance_count` STRING COMMENT 'The difference between expected and actual carton count (actual minus expected). Positive indicates overage, negative indicates shortage.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the receiving event record was first created in the warehouse management system.',
    `damage_flag` BOOLEAN COMMENT 'Indicates whether any damaged goods were identified during the receiving event.',
    `damaged_unit_quantity` STRING COMMENT 'The number of units identified as damaged during the receiving inspection.',
    `discrepancy_reason_code` STRING COMMENT 'Code indicating the reason for any discrepancy between expected and actual quantities (e.g., supplier short ship, damaged in transit, incorrect ASN).',
    `dock_door_number` STRING COMMENT 'The specific dock door assignment where the inbound shipment was unloaded.',
    `expected_carton_count` STRING COMMENT 'The number of cartons expected to be received based on the advance shipment notice or purchase order.',
    `expected_pallet_count` STRING COMMENT 'The number of pallets expected to be received based on the advance shipment notice or purchase order.',
    `expected_unit_quantity` STRING COMMENT 'The total number of individual units (eaches) expected to be received based on the advance shipment notice or purchase order.',
    `hazmat_flag` BOOLEAN COMMENT 'Indicates whether the received shipment contains hazardous materials requiring special handling.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when the receiving event record was last modified in the warehouse management system.',
    `overage_flag` BOOLEAN COMMENT 'Indicates whether the receiving event resulted in an overage (more units received than expected).',
    `pallet_variance_count` STRING COMMENT 'The difference between expected and actual pallet count (actual minus expected). Positive indicates overage, negative indicates shortage.',
    `putaway_task_generated_flag` BOOLEAN COMMENT 'Indicates whether putaway tasks have been automatically generated in the WMS following the receiving event.',
    `quality_inspection_required_flag` BOOLEAN COMMENT 'Indicates whether the received goods require quality inspection before being made available for putaway or sale.',
    `receiving_event_number` STRING COMMENT 'Business-readable unique identifier for the receiving event, used for tracking and reporting.',
    `receiving_notes` STRING COMMENT 'Free-text notes entered by the receiving clerk documenting any observations, issues, or special handling instructions.',
    `receiving_status` STRING COMMENT 'Current lifecycle status of the receiving event.. Valid values are `scheduled|in_progress|completed|cancelled|on_hold|exception`',
    `receiving_type` STRING COMMENT 'Type of receiving operation: blind receiving (no advance shipment notice), directed receiving (with ASN), cross-dock, return to vendor, or inter-facility transfer.. Valid values are `blind|directed|cross_dock|return|transfer`',
    `seal_intact_flag` BOOLEAN COMMENT 'Indicates whether the security seal was found intact upon arrival. False indicates potential tampering or security breach.',
    `seal_number` STRING COMMENT 'The security seal number on the trailer or container, verified during receiving to ensure shipment integrity.',
    `shortage_flag` BOOLEAN COMMENT 'Indicates whether the receiving event resulted in a shortage (fewer units received than expected).',
    `temperature_compliant_flag` BOOLEAN COMMENT 'Indicates whether temperature-controlled shipments arrived within the required temperature range.',
    `temperature_reading` DECIMAL(18,2) COMMENT 'The actual temperature reading (in Celsius) recorded upon arrival for temperature-controlled shipments.',
    `trailer_number` STRING COMMENT 'The trailer or container number of the vehicle that delivered the shipment.',
    `unit_variance_quantity` STRING COMMENT 'The difference between expected and actual unit quantity (actual minus expected). Positive indicates overage, negative indicates shortage.',
    `unload_duration_minutes` STRING COMMENT 'Total time in minutes taken to unload the shipment, calculated from start to end timestamp.',
    `unload_end_timestamp` TIMESTAMP COMMENT 'The timestamp when the unloading of the inbound shipment was completed.',
    `unload_start_timestamp` TIMESTAMP COMMENT 'The timestamp when the unloading of the inbound shipment began at the dock door.',
    CONSTRAINT pk_receiving_event PRIMARY KEY(`receiving_event_id`)
) COMMENT 'Captures the physical receiving activity at a DC dock door when inbound shipments are unloaded and verified. Records dock door assignment, unload start/end timestamps, cartons received vs. expected, discrepancy flags (overage, shortage, damage), receiver employee ID, pallet count, and blind vs. directed receiving mode. Each receiving event is tied to an inbound shipment and drives put-away task generation in Manhattan WMS.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` (
    `outbound_order_id` BIGINT COMMENT 'Unique identifier for the distribution center outbound order. Primary key for this entity. Role: TRANSACTION_HEADER.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: B2B retail operations: wholesale accounts, franchise stores, and business customers receive direct DC shipments tracked as outbound orders. Enables account-level fulfillment reporting, credit manageme',
    `carrier_id` BIGINT COMMENT 'Identifier of the transportation carrier assigned to deliver this outbound order.',
    `dc_facility_id` BIGINT COMMENT 'Identifier of the destination node (store, customer, DC, 3PL facility) receiving this shipment. Polymorphic reference interpreted based on destination_type.',
    `header_id` BIGINT COMMENT 'Foreign key linking to order.header. Business justification: DC fulfillment-to-customer-order traceability: the outbound order at the DC must reference the originating customer order header for SLA monitoring, customer service lookups, and end-to-end order trac',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.associate. Business justification: Replenishment planners create outbound store replenishment orders for planning accountability and performance tracking. Supply chain tracks planner accuracy, fill rates, and forecast vs. actual by pla',
    `primary_outbound_dc_facility_id` BIGINT COMMENT 'Identifier of the distribution center or micro-fulfillment center (MFC) fulfilling this outbound order.',
    `promo_campaign_id` BIGINT COMMENT 'Reference to the promotional event or campaign driving this outbound order, if applicable. Links fulfillment to promotional planning.',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_offer. Business justification: Promotional Inventory Positioning: outbound DC-to-store orders driven by specific promotional offers require offer-level tracking for vendor chargeback validation and promotional compliance audits. Ex',
    `purchase_order_id` BIGINT COMMENT 'Reference to the demand planning forecast or consensus demand plan that triggered this replenishment order. Links outbound execution to upstream planning.',
    `replenishment_order_id` BIGINT COMMENT 'Foreign key linking to inventory.replenishment_order. Business justification: DC fulfillment of store replenishment requires linking the outbound_order (DC execution) to the replenishment_order (store demand signal). Store replenishment fill-rate reporting, order-to-shipment cy',
    `replenishment_plan_id` BIGINT COMMENT 'Reference to the replenishment plan that generated this outbound order. Links execution to planning layer.',
    `ship_from_store_node_id` BIGINT COMMENT 'Foreign key linking to store.ship_from_store_node. Business justification: Omnichannel fulfillment operations require tracking which Ship-From-Store node fulfilled each outbound order for SFS node performance reporting, capacity utilization analysis, and carrier cost allocat',
    `actual_delivery_date` DATE COMMENT 'Date when the order was confirmed delivered to the destination. Null until delivery confirmation is received.',
    `actual_ship_date` DATE COMMENT 'Date when the order was actually shipped from the facility. Null until shipment occurs.',
    `bill_of_lading_number` STRING COMMENT 'Bill of lading number issued for this shipment. Legal document acknowledging receipt of cargo for shipment.',
    `cancellation_reason_code` STRING COMMENT 'Code indicating the reason for order cancellation: inventory unavailable, destination closed, carrier unavailable, customer request, etc. Null if order not cancelled.',
    `carrier_service_level` STRING COMMENT 'Transportation service level selected for this shipment: ground (standard), express (expedited), next-day, two-day, same-day, LTL (Less Than Truckload), or FTL (Full Truckload). [ENUM-REF-CANDIDATE: ground|express|next_day|two_day|same_day|ltl|ftl — 7 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this outbound order record was first created in the warehouse management system. Audit trail for record inception.',
    `destination_address_line1` STRING COMMENT 'Primary street address line for the shipment destination. Required for customer and store deliveries.',
    `destination_city` STRING COMMENT 'City name for the shipment destination address.',
    `destination_country_code` STRING COMMENT 'Three-letter ISO country code for the shipment destination (e.g., USA, CAN, MEX).. Valid values are `^[A-Z]{3}$`',
    `destination_postal_code` STRING COMMENT 'Postal or ZIP code for the shipment destination address.',
    `destination_state_province` STRING COMMENT 'State or province code for the shipment destination address.',
    `destination_type` STRING COMMENT 'Type of destination node receiving this outbound shipment: store (retail location), customer (direct-to-consumer), distribution center (inter-DC transfer), 3PL node (third-party logistics partner), or supplier (return to vendor).. Valid values are `store|customer|distribution_center|3pl_node|supplier`',
    `dock_door_number` STRING COMMENT 'Outbound dock door number from which this order was loaded for shipment.',
    `fill_rate_pct` DECIMAL(18,2) COMMENT 'Percentage of ordered units successfully fulfilled and shipped. Calculated as (shipped units / ordered units) * 100. Key supply chain KPI.',
    `is_cross_dock` BOOLEAN COMMENT 'Boolean flag indicating whether this order was fulfilled via cross-docking (direct transfer from inbound to outbound without storage).',
    `is_drop_ship` BOOLEAN COMMENT 'Boolean flag indicating whether this order is fulfilled via drop ship (vendor ships directly to customer, bypassing DC).',
    `is_hazmat` BOOLEAN COMMENT 'Boolean flag indicating whether this order contains hazardous materials requiring special handling and documentation.',
    `is_temperature_controlled` BOOLEAN COMMENT 'Boolean flag indicating whether this order requires temperature-controlled transportation (refrigerated or frozen goods).',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this outbound order record was last modified. Audit trail for record changes.',
    `notes` STRING COMMENT 'Free-text notes or special instructions for this outbound order. May include handling instructions, delivery requirements, or operational comments.',
    `order_date` DATE COMMENT 'Date when the outbound order was created in the warehouse management system. Business event timestamp representing order inception.',
    `order_number` STRING COMMENT 'Business-facing unique order number assigned to this outbound shipment. Used for tracking and communication with destination nodes.',
    `order_status` STRING COMMENT 'Current lifecycle status of the outbound order in the warehouse management workflow. Tracks progression from order creation through final delivery or cancellation. [ENUM-REF-CANDIDATE: draft|released|waved|picking|picked|packing|packed|shipped|in_transit|delivered|closed|cancelled — 12 candidates stripped; promote to reference product]',
    `order_type` STRING COMMENT 'Classification of the outbound order indicating the fulfillment purpose: store replenishment (push inventory to stores), e-commerce fulfillment (direct-to-customer), BOPIS (Buy Online Pick Up In Store), ROPIS (Reserve Online Pick Up In Store), inter-DC transfer (distribution center to distribution center), or DSD bypass (Direct Store Delivery bypass).. Valid values are `store_replenishment|ecommerce_fulfillment|bopis|ropis|inter_dc_transfer|dsd_bypass`',
    `priority_level` STRING COMMENT 'Priority classification for order fulfillment. Critical orders (e.g., stockout replenishment, promotional merchandise) are processed ahead of normal flow.. Valid values are `critical|high|normal|low`',
    `pro_number` STRING COMMENT 'Progressive number assigned by LTL carriers for freight tracking and billing.',
    `replenishment_reason_code` STRING COMMENT 'Code indicating the business reason for this replenishment order: stockout prevention, promotional support, seasonal refresh, new item introduction, etc.',
    `replenishment_type` STRING COMMENT 'For store replenishment orders: method used to determine replenishment quantities. Push (DC-initiated based on forecast), pull (store-requested), min-max (reorder point triggered), VMI (Vendor Managed Inventory), promotional (event-driven), seasonal (seasonal assortment), or new store (initial stock). [ENUM-REF-CANDIDATE: push|pull|min_max|vmi|promotional|seasonal|new_store — 7 candidates stripped; promote to reference product]',
    `requested_ship_date` DATE COMMENT 'Date by which the order is requested to ship from the distribution center or micro-fulfillment center. Used for planning and wave assignment.',
    `required_delivery_date` DATE COMMENT 'Date by which the order must be delivered to the destination node to meet business commitments or replenishment schedules.',
    `temperature_requirement` STRING COMMENT 'Temperature control requirement for this shipment: ambient (room temperature), refrigerated (2-8°C), frozen (below -18°C), or climate-controlled (specific range).. Valid values are `ambient|refrigerated|frozen|climate_controlled`',
    `total_cartons` STRING COMMENT 'Total number of cartons or cases packed for this outbound order.',
    `total_cube_m3` DECIMAL(18,2) COMMENT 'Total cubic volume of the outbound order in cubic meters. Used for trailer capacity planning and freight optimization.',
    `total_lines` STRING COMMENT 'Total number of distinct SKU line items included in this outbound order.',
    `total_pallets` STRING COMMENT 'Total number of pallets loaded for this outbound order.',
    `total_units` STRING COMMENT 'Total quantity of units (eaches) across all lines in this outbound order.',
    `total_weight_kg` DECIMAL(18,2) COMMENT 'Total gross weight of the outbound order in kilograms. Used for carrier selection and freight cost calculation.',
    `tracking_number` STRING COMMENT 'Carrier-provided tracking number for this shipment. Used for shipment visibility and proof of delivery.',
    `trailer_number` STRING COMMENT 'Identifier of the trailer or container loaded with this outbound order.',
    CONSTRAINT pk_outbound_order PRIMARY KEY(`outbound_order_id`)
) COMMENT 'Represents a distribution outbound order directing the DC or MFC to fulfill and ship goods to a destination (store, customer, 3PL node). Captures order type (store replenishment, e-commerce, BOPIS, DSD bypass, inter-DC transfer), destination node, requested ship date, required delivery date, priority level, total lines/units/weight/cube, wave assignment, and order status lifecycle (released, waved, picking, packed, shipped, closed). For store replenishment: captures replenishment type (push, pull, min-max, VMI), replenishment reason, demand planning source reference, and replenishment frequency. Central transactional entity for all DC outbound execution including store replenishment, e-commerce fulfillment, and inter-facility transfers.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` (
    `outbound_order_line_id` BIGINT COMMENT 'Unique identifier for each line item within an outbound distribution order. Primary key for the outbound order line entity.',
    `assortment_item_id` BIGINT COMMENT 'Foreign key linking to merchandising.assortment_item. Business justification: Outbound order lines fulfill specific assortment plan items to stores. DC operations and merchandising track which planned assortment items are being shipped to validate assortment plan execution, mon',
    `carrier_id` BIGINT COMMENT 'Transportation carrier assigned to ship this line item. Links to carrier master for service levels, rates, and performance metrics.',
    `gtin_registry_id` BIGINT COMMENT 'Foreign key linking to product.gtin_registry. Business justification: outbound_order_line carries a plain gtin column (denormalized). GTIN drives carton labeling, ASN generation, and store receiving scanning. Linking to gtin_registry normalizes this, enables packaging',
    `lot_id` BIGINT COMMENT 'Foreign key linking to inventory.lot. Business justification: FEFO (First Expired First Out) compliance in DC picking requires linking each outbound_order_line to the specific lot being shipped. Food safety traceability, recall execution (stop-ship by lot), and ',
    `order_line_id` BIGINT COMMENT 'Foreign key linking to order.order_line. Business justification: Line-level fulfillment traceability: each DC outbound order line maps to a specific customer order line, enabling line-level fill-rate reporting, short-ship exception handling, and customer order stat',
    `dc_facility_id` BIGINT COMMENT 'Distribution center fulfilling this outbound order line. Links to DC master for facility capacity, operating hours, and carrier relationships.',
    `outbound_order_id` BIGINT COMMENT 'Reference to the parent outbound distribution order header. Links this line to its containing order for fulfillment tracking and shipment consolidation.',
    `sku_id` BIGINT COMMENT 'Reference to the master product record for this line item. Links to product master data for attributes, pricing, and merchandising information.',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: outbound_order_line carries a plain unit_of_measure text column (denormalized). Outbound UOM drives pick instructions, carton build logic, and store receiving counts. Linking to product.uom normaliz',
    `location_id` BIGINT COMMENT 'Retail store or fulfillment node receiving this line item. Links to store master for address, capacity, and operational attributes.',
    `source_location_id` BIGINT COMMENT 'Warehouse storage location from which this line item was picked. Links to warehouse location master for zone, aisle, and bin tracking.',
    `stock_position_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_position. Business justification: DC allocation and picking operations require linking each outbound_order_line to the stock_position from which inventory is allocated. Available-to-promise accuracy, inventory reservation reconciliati',
    `wave_id` BIGINT COMMENT 'Warehouse wave or batch that included this line for picking. Links to wave planning for labor optimization and throughput analysis.',
    `allocated_qty` DECIMAL(18,2) COMMENT 'Quantity of units allocated from available inventory to fulfill this line. May differ from ordered quantity due to stock availability constraints.',
    `carton_number` STRING COMMENT 'Shipping carton or container identifier containing this line item. Used for package-level tracking and multi-carton shipment management.. Valid values are `^[A-Z0-9-]{6,30}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this outbound order line record was first created in the warehouse management system. Audit trail for order entry and system integration.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code for all monetary amounts on this line. Enables multi-currency operations and financial consolidation.. Valid values are `^[A-Z]{3}$`',
    `expiry_date` DATE COMMENT 'Product expiration or best-before date for perishable goods. Drives FEFO (First Expired First Out) picking logic and shelf-life management.',
    `extended_cost` DECIMAL(18,2) COMMENT 'Total cost for this line (unit cost multiplied by shipped quantity). Represents inventory value transferred from DC to destination.',
    `handling_instructions` STRING COMMENT 'Special handling requirements or notes for warehouse and carrier personnel. Includes fragile, orientation, stacking, and security instructions.',
    `is_hazmat` BOOLEAN COMMENT 'Indicates whether this line contains hazardous materials requiring special handling, labeling, and carrier certification per DOT regulations.',
    `is_temperature_controlled` BOOLEAN COMMENT 'Indicates whether this line requires refrigerated or climate-controlled transportation and storage to maintain product integrity.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to this line record. Tracks status changes, quantity adjustments, and data corrections throughout fulfillment lifecycle.',
    `line_number` STRING COMMENT 'Sequential line number within the outbound order. Establishes ordering and uniqueness of line items within a single order document.',
    `line_status` STRING COMMENT 'Current fulfillment status of this order line. Tracks progression through warehouse workflow from allocation through shipment or cancellation. [ENUM-REF-CANDIDATE: pending|allocated|picked|packed|shipped|cancelled|short_shipped|backordered — 8 candidates stripped; promote to reference product]',
    `ordered_qty` DECIMAL(18,2) COMMENT 'Quantity of units originally requested for this line item. Represents the demand signal from the destination location or customer.',
    `original_sku` STRING COMMENT 'Original SKU requested if a substitution was made. Enables demand signal accuracy and substitution pattern analysis for assortment planning.. Valid values are `^[A-Z0-9]{6,20}$`',
    `packed_qty` DECIMAL(18,2) COMMENT 'Quantity of units packed into shipping containers for this line. Confirms units staged for outbound shipment and ready for carrier pickup.',
    `picked_qty` DECIMAL(18,2) COMMENT 'Actual quantity of units physically picked from warehouse storage locations. Reflects warehouse execution accuracy and inventory availability.',
    `serial_number` STRING COMMENT 'Unique serial number for serialized items such as electronics, appliances, or high-value goods. Enables item-level tracking and warranty management.. Valid values are `^[A-Z0-9-]{6,40}$`',
    `shipped_qty` DECIMAL(18,2) COMMENT 'Final quantity of units shipped to the destination. Used for fill rate calculation, short-ship identification, and invoice reconciliation.',
    `short_ship_qty` DECIMAL(18,2) COMMENT 'Quantity variance between ordered and shipped units. Represents unfulfilled demand due to stockouts, damage, or allocation constraints.',
    `short_ship_reason_code` STRING COMMENT 'Reason code explaining why this line was short-shipped. Used for root cause analysis, supplier performance tracking, and inventory planning improvement.. Valid values are `stockout|damage|quality_hold|allocation_override|system_error|cancelled`',
    `sku` STRING COMMENT 'Internal stock keeping unit code identifying the specific product variant being shipped. Used for inventory tracking and warehouse operations.. Valid values are `^[A-Z0-9]{6,20}$`',
    `substitution_flag` BOOLEAN COMMENT 'Indicates whether a substitute product was shipped in place of the originally ordered SKU due to stockout or allocation constraints.',
    `temperature_requirement` STRING COMMENT 'Specific temperature control requirement for this line item. Drives carrier selection, routing, and cold chain compliance monitoring.. Valid values are `ambient|refrigerated|frozen|climate_controlled`',
    `unit_cost` DECIMAL(18,2) COMMENT 'Cost per unit for this line item at time of shipment. Used for inventory valuation, COGS calculation, and profitability analysis.',
    `volume_cubic_meters` DECIMAL(18,2) COMMENT 'Total cubic volume of this line item. Used for trailer utilization, storage capacity planning, and dimensional weight pricing.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Total weight of this line item in kilograms. Used for freight cost calculation, carrier capacity planning, and load optimization.',
    CONSTRAINT pk_outbound_order_line PRIMARY KEY(`outbound_order_line_id`)
) COMMENT 'Line-level detail for each SKU within an outbound distribution order. Captures SKU/UPC, ordered quantity, allocated quantity, picked quantity, packed quantity, shipped quantity, unit of measure, lot number, expiry date, storage location sourced from, and line status. Enables granular fulfillment tracking and short-ship identification at the SKU level.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplychain`.`wave` (
    `wave_id` BIGINT COMMENT 'Unique identifier for the wave batch. Primary key.',
    `carrier_id` BIGINT COMMENT 'Shipping carrier assigned to transport the outbound shipments generated from this wave.',
    `dc_facility_id` BIGINT COMMENT 'Distribution center where this wave is being executed.',
    `category_id` BIGINT COMMENT 'Primary product category for items in this wave, used for category-based wave planning and zone assignment.',
    `outbound_order_id` BIGINT COMMENT 'add column outbound_order_id (BIGINT) with FK to supplychain.outbound_order.outbound_order_id - waves group outbound orders for batch processing and this direct linkage is missing (currently only outbound_order references wave)',
    `actual_pick_end_timestamp` TIMESTAMP COMMENT 'Actual date and time when the last pick task in this wave was completed.',
    `actual_pick_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when the first pick task in this wave was started by warehouse associates.',
    `assigned_pick_zones` STRING COMMENT 'Comma-separated list of warehouse pick zone identifiers assigned to this wave for zone-based picking strategies.',
    `carrier_service_level` STRING COMMENT 'Shipping service level for this wave (e.g., ground, two-day, next-day, same-day) determining delivery speed and cost.',
    `channel` STRING COMMENT 'Destination channel for orders in this wave: store_replenishment (DC to store), ecommerce (DC to customer), BOPIS (buy online pick up in store), ship_from_store, wholesale (B2B), marketplace (third-party platform).. Valid values are `store_replenishment|ecommerce|bopis|ship_from_store|wholesale|marketplace`',
    `consolidation_location` STRING COMMENT 'Warehouse staging area or dock door where picked items from this wave are consolidated for packing and shipping.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this wave record was first created in the WMS system.',
    `equipment_type` STRING COMMENT 'Primary material handling equipment or picking technology allocated for this wave execution.. Valid values are `cart|pallet_jack|forklift|pick_to_light|voice_pick|rf_scanner`',
    `fill_rate_pct` DECIMAL(18,2) COMMENT 'Percentage of ordered units successfully picked, calculated as (picked_units / total_units) * 100, measuring wave execution effectiveness.',
    `generation_method` STRING COMMENT 'Method used to create this wave: scheduled (time-based automatic), manual (planner-initiated), demand_triggered (order volume threshold), threshold_based (inventory or capacity rule).. Valid values are `scheduled|manual|demand_triggered|threshold_based`',
    `is_hazmat` BOOLEAN COMMENT 'Indicates whether this wave contains hazardous materials requiring special handling, labeling, and compliance documentation per DOT regulations.',
    `is_promotional` BOOLEAN COMMENT 'Indicates whether this wave contains orders driven by promotional campaigns or special marketing events requiring expedited handling.',
    `is_temperature_controlled` BOOLEAN COMMENT 'Indicates whether this wave requires temperature-controlled handling and storage (refrigerated or frozen goods).',
    `labor_hours_actual` DECIMAL(18,2) COMMENT 'Actual total labor hours consumed by warehouse associates to complete this wave, measured from task start to completion.',
    `labor_hours_planned` DECIMAL(18,2) COMMENT 'Estimated total labor hours required to complete picking, packing, and staging for this wave, used for workforce scheduling.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this wave record was most recently modified, tracking status changes and execution progress.',
    `notes` STRING COMMENT 'Free-text operational notes or special instructions for warehouse associates executing this wave (e.g., gift wrap required, fragile items, rush processing).',
    `picked_units` STRING COMMENT 'Actual quantity of units successfully picked and confirmed for this wave.',
    `planned_pick_end_timestamp` TIMESTAMP COMMENT 'Scheduled date and time for picking operations to complete for this wave.',
    `planned_pick_start_timestamp` TIMESTAMP COMMENT 'Scheduled date and time for picking operations to begin for this wave.',
    `priority_rank` STRING COMMENT 'Numeric priority ranking for wave execution sequencing, with lower numbers indicating higher priority for labor allocation and equipment assignment.',
    `release_timestamp` TIMESTAMP COMMENT 'Date and time when the wave was released to the warehouse floor for picking execution.',
    `short_ship_disposition` STRING COMMENT 'Business rule applied to handle short-picked units: cancel (remove from order), backorder (fulfill later), substitute (offer alternative SKU), split_shipment (ship partial now).. Valid values are `cancel|backorder|substitute|split_shipment`',
    `short_units` STRING COMMENT 'Quantity of units that could not be picked due to inventory shortage or location discrepancies.',
    `temperature_zone` STRING COMMENT 'Required temperature control zone for this wave: ambient (room temperature), refrigerated (33-40°F), frozen (0°F or below).. Valid values are `ambient|refrigerated|frozen`',
    `template_code` BIGINT COMMENT 'Reference to the wave template configuration that defines the rules and parameters used to generate this wave.',
    `total_cartons` STRING COMMENT 'Total number of cartons or shipping containers generated from this wave for outbound shipment.',
    `total_order_lines` STRING COMMENT 'Total count of order line items included in this wave batch for picking.',
    `total_units` STRING COMMENT 'Total quantity of individual units (eaches) to be picked across all lines in this wave.',
    `units_per_hour` DECIMAL(18,2) COMMENT 'Productivity metric calculated as picked_units divided by labor_hours_actual, measuring warehouse picking efficiency.',
    `wave_number` STRING COMMENT 'Business-facing wave identifier used for operational tracking and communication across warehouse teams.',
    `wave_status` STRING COMMENT 'Current lifecycle state of the wave: planned (created but not released), released (available for picking), in-progress (actively being picked), short-closed (closed with shortages), complete (all lines picked), cancelled (wave aborted).. Valid values are `planned|released|in_progress|short_closed|complete|cancelled`',
    `wave_type` STRING COMMENT 'Classification of wave picking strategy: single-order (discrete pick per order), multi-order (batch pick across orders), cluster (cart-based multi-order), zone (pick within assigned zones), wave-less (continuous release), demand-based (dynamic priority-driven release).. Valid values are `single_order|multi_order|cluster|zone|wave_less|demand_based`',
    CONSTRAINT pk_wave PRIMARY KEY(`wave_id`)
) COMMENT 'A wave is a batch grouping of outbound order lines released together for coordinated picking within a DC. Captures wave number, wave type (single-order, multi-order, cluster, zone, demand-based), release timestamp, planned pick start/end, total lines, total units, assigned pick zones, wave status (planned, released, in-progress, short-closed, complete), fill rate, and short-ship disposition rule. Wave management is a core Manhattan WMS workflow that drives labor scheduling, equipment allocation, and pick zone sequencing for optimal DC throughput.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ADD CONSTRAINT `fk_supplychain_purchase_order_blanket_po_purchase_order_id` FOREIGN KEY (`blanket_po_purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ADD CONSTRAINT `fk_supplychain_purchase_order_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ADD CONSTRAINT `fk_supplychain_warehouse_zone_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ADD CONSTRAINT `fk_supplychain_inbound_shipment_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ADD CONSTRAINT `fk_supplychain_inbound_shipment_primary_inbound_dc_facility_id` FOREIGN KEY (`primary_inbound_dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ADD CONSTRAINT `fk_supplychain_inbound_shipment_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_primary_outbound_dc_facility_id` FOREIGN KEY (`primary_outbound_dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_wave_id` FOREIGN KEY (`wave_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`wave`(`wave_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ADD CONSTRAINT `fk_supplychain_wave_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ADD CONSTRAINT `fk_supplychain_wave_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`supplychain` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `vibe_retail_v1`.`supplychain` SET TAGS ('dbx_domain' = 'supplychain');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` SET TAGS ('dbx_subdomain' = 'demand_planning');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `cost_price_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `demand_forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Demand Plan ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Planner Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Plan Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `inventory_node_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Chain Node ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `sku_price_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `vendor_item_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Item Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `approved_order_qty` SET TAGS ('dbx_business_glossary_term' = 'Approved Order Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `current_on_hand_qty` SET TAGS ('dbx_business_glossary_term' = 'Current On-Hand Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `demand_variability_factor` SET TAGS ('dbx_business_glossary_term' = 'Demand Variability Factor (Coefficient of Variation)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `fill_rate_target_pct` SET TAGS ('dbx_business_glossary_term' = 'Fill Rate Target Percentage');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `forecasted_demand_qty` SET TAGS ('dbx_business_glossary_term' = 'Forecasted Demand Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Supplier Lead Time (Days)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `min_order_value` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Value (MOV)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `moq` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `moq_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ) Compliance Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `node_type` SET TAGS ('dbx_business_glossary_term' = 'Supply Chain Node Type');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `node_type` SET TAGS ('dbx_value_regex' = 'store|dc|mfc|dark_store');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `on_order_qty` SET TAGS ('dbx_business_glossary_term' = 'On-Order Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `order_multiple` SET TAGS ('dbx_business_glossary_term' = 'Order Multiple (Pack Size)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `override_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Buyer Override Reason Code');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `override_reason_code` SET TAGS ('dbx_value_regex' = 'promotional_uplift|supplier_constraint|excess_inventory|demand_correction|system_error|other');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `plan_generation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Plan Generation Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Plan Number');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_value_regex' = '^RPL-[0-9]{10}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Plan Status');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Plan Type');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'automated|manual|override|emergency');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `planned_order_qty` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `promotion_flag` SET TAGS ('dbx_business_glossary_term' = 'Promotion-Driven Replenishment Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `reorder_point` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point (ROP)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `safety_stock_method` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Calculation Method');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `safety_stock_method` SET TAGS ('dbx_value_regex' = 'fixed|statistical|days_of_supply|service_level_based');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `safety_stock_qty` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `service_level_target_pct` SET TAGS ('dbx_business_glossary_term' = 'Service Level Target Percentage');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = 'blue_yonder|sap_s4hana|orms|manual');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ALTER COLUMN `weeks_of_supply_target` SET TAGS ('dbx_business_glossary_term' = 'Weeks of Supply (WOS) Target');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` SET TAGS ('dbx_subdomain' = 'demand_planning');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Cluster Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Planner Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `promo_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Calendar Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `sku_price_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `confidence_level_pct` SET TAGS ('dbx_business_glossary_term' = 'Forecast Confidence Level Percentage');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `demand_category` SET TAGS ('dbx_value_regex' = 'regular|intermittent|lumpy|new_item|end_of_life');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `forecast_horizon_weeks` SET TAGS ('dbx_business_glossary_term' = 'Forecast Horizon (Weeks)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `forecast_run_number` SET TAGS ('dbx_business_glossary_term' = 'Forecast Run ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `forecast_status` SET TAGS ('dbx_value_regex' = 'draft|published|approved|overridden|superseded|archived');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `forecast_type` SET TAGS ('dbx_value_regex' = 'baseline|promotional|seasonal|event_driven|consensus');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `is_latest_version` SET TAGS ('dbx_business_glossary_term' = 'Latest Version Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `is_new_item` SET TAGS ('dbx_business_glossary_term' = 'New Item Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `is_override_applied` SET TAGS ('dbx_business_glossary_term' = 'Override Applied Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `is_promotional_period` SET TAGS ('dbx_business_glossary_term' = 'Promotional Period Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `mape` SET TAGS ('dbx_business_glossary_term' = 'Mean Absolute Percentage Error (MAPE)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `model_version` SET TAGS ('dbx_business_glossary_term' = 'Statistical Model Version');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `model_version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+.[0-9]+$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `otb_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Open-to-Buy (OTB) Impact Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `planning_channel` SET TAGS ('dbx_value_regex' = 'store|ecommerce|omnichannel|dc_replenishment|bopis');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `time_bucket_granularity` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `weeks_of_supply` SET TAGS ('dbx_business_glossary_term' = 'Weeks of Supply (WOS)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ALTER COLUMN `wmape` SET TAGS ('dbx_business_glossary_term' = 'Weighted Mean Absolute Percentage Error (WMAPE)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` SET TAGS ('dbx_subdomain' = 'warehouse_operations');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Identifier');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `blanket_po_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Blanket Purchase Order ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `lead_time_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Agreement Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Receiving Coordinator Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `promo_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Calendar Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Center (DC) ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Approval Status');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|escalated');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Approved Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `cancellation_date` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Cancellation Date');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Discount Amount');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `edi_transmission_status` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Transmission Status');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `edi_transmission_status` SET TAGS ('dbx_value_regex' = 'not_sent|pending|transmitted|acknowledged|failed|rejected');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `fill_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Fill Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Named Place or Port');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `is_cross_dock` SET TAGS ('dbx_business_glossary_term' = 'Cross-Docking Indicator');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `is_drop_ship` SET TAGS ('dbx_business_glossary_term' = 'Drop Ship Indicator');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Notes');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `order_date` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Date');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `po_number` SET TAGS ('dbx_value_regex' = '^PO-[0-9]{8,12}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `po_status` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Status');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `po_type` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Type');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = 'SAP_MM|ORMS|MANUAL|EDI');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `supplier_po_reference` SET TAGS ('dbx_business_glossary_term' = 'Supplier Purchase Order Reference Number');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ALTER COLUMN `total_order_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Purchase Order Amount');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` SET TAGS ('dbx_subdomain' = 'warehouse_operations');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Line ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `gtin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Gtin Registry Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `inbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Shipment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Destination ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Product ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Po Line Uom Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `confirmed_qty` SET TAGS ('dbx_business_glossary_term' = 'Confirmed Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `destination_type` SET TAGS ('dbx_value_regex' = 'dc|store|cross_dock|drop_ship|mfc');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'International Commercial Terms (Incoterms)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time (Days)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Line Number');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `line_status` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Line Status');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `line_status` SET TAGS ('dbx_value_regex' = 'open|confirmed|partially_received|fully_received|cancelled|closed');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `moq` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `moq_compliant` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ) Compliant Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `order_uom_qty` SET TAGS ('dbx_business_glossary_term' = 'Order Unit of Measure Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `ordered_qty` SET TAGS ('dbx_business_glossary_term' = 'Ordered Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `otb_consumed` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Consumed');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `received_qty` SET TAGS ('dbx_business_glossary_term' = 'Received Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `shipped_qty` SET TAGS ('dbx_business_glossary_term' = 'Shipped Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` SET TAGS ('dbx_subdomain' = 'warehouse_operations');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Center (DC) Facility ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `address_line_1` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `address_line_1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `address_line_2` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `address_line_2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `automation_level` SET TAGS ('dbx_value_regex' = 'manual|semi_automated|highly_automated|fully_automated');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `facility_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `facility_email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `facility_email_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `facility_email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `facility_phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `facility_phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `facility_status` SET TAGS ('dbx_value_regex' = 'active|planned|under_construction|decommissioned|temporarily_closed|seasonal');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `facility_type` SET TAGS ('dbx_value_regex' = 'regional_dc|micro_fulfillment_center|dark_store|cross_dock_hub|returns_center|forward_stocking_location');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `gln` SET TAGS ('dbx_business_glossary_term' = 'Global Location Number (GLN)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `gln` SET TAGS ('dbx_value_regex' = '^[0-9]{13}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `hazmat_certified_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Certified Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `ownership_type` SET TAGS ('dbx_value_regex' = 'owned|leased|third_party_operated');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `state_province_code` SET TAGS ('dbx_business_glossary_term' = 'State or Province Code');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `state_province_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `storage_capacity_cubic_feet` SET TAGS ('dbx_business_glossary_term' = 'Storage Capacity in Cubic Feet');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `storage_capacity_pallet_positions` SET TAGS ('dbx_business_glossary_term' = 'Storage Capacity in Pallet Positions');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `twenty_four_seven_operation_flag` SET TAGS ('dbx_business_glossary_term' = '24/7 Operation Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ALTER COLUMN `wms_instance_code` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Management System (WMS) Instance ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` SET TAGS ('dbx_subdomain' = 'warehouse_operations');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Center (DC) ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `aisle_range_end` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `aisle_range_start` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `current_occupancy_pct` SET TAGS ('dbx_business_glossary_term' = 'Current Occupancy Percentage');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `cycle_count_frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|quarterly|annual|on_demand');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `hazmat_certified_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Certified Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `pick_method` SET TAGS ('dbx_value_regex' = 'discrete|batch|zone|wave|cluster');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `rack_configuration_type` SET TAGS ('dbx_value_regex' = 'selective|drive_in|push_back|flow|pallet_flow|cantilever');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `rfid_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Radio Frequency Identification (RFID) Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `security_level` SET TAGS ('dbx_value_regex' = 'standard|restricted|high_value|controlled_substance');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `slotting_strategy` SET TAGS ('dbx_value_regex' = 'velocity_based|product_affinity|size_based|random|fixed');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `temperature_classification` SET TAGS ('dbx_value_regex' = 'ambient|chilled|frozen|temperature_controlled');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `temperature_max_celsius` SET TAGS ('dbx_business_glossary_term' = 'Maximum Temperature (Celsius)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `temperature_min_celsius` SET TAGS ('dbx_business_glossary_term' = 'Minimum Temperature (Celsius)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `total_capacity_cubic_meters` SET TAGS ('dbx_business_glossary_term' = 'Total Capacity (Cubic Meters)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `total_capacity_pallet_positions` SET TAGS ('dbx_business_glossary_term' = 'Total Capacity (Pallet Positions)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `weight_capacity_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight Capacity (Kilograms)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `zone_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ALTER COLUMN `zone_status` SET TAGS ('dbx_value_regex' = 'active|inactive|maintenance|blocked|quarantine|seasonal');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` SET TAGS ('dbx_subdomain' = 'warehouse_operations');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `inbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Shipment Identifier');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Store Location Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Origin Facility ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `primary_inbound_dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Center (DC) ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `actual_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Actual Weight (Kilograms)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `asn_number` SET TAGS ('dbx_business_glossary_term' = 'Advance Ship Notice (ASN) Number');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `carrier_scac_code` SET TAGS ('dbx_business_glossary_term' = 'Standard Carrier Alpha Code (SCAC)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `carrier_scac_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `cross_dock_flag` SET TAGS ('dbx_business_glossary_term' = 'Cross-Dock Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `expected_cube_m3` SET TAGS ('dbx_business_glossary_term' = 'Expected Cube (Cubic Meters)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `expected_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Expected Weight (Kilograms)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `freight_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `hazmat_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Shipment Notes');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `on_time_arrival_flag` SET TAGS ('dbx_business_glossary_term' = 'On-Time Arrival Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `pro_number` SET TAGS ('dbx_business_glossary_term' = 'Progressive Number (PRO)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `shipment_status` SET TAGS ('dbx_value_regex' = 'in_transit|arrived|receiving|closed|cancelled|delayed');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `shipment_type` SET TAGS ('dbx_value_regex' = 'supplier_direct|inter_facility_transfer|vendor_managed_inventory|drop_ship_return|cross_dock');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `temperature_max_celsius` SET TAGS ('dbx_business_glossary_term' = 'Maximum Temperature (Celsius)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `temperature_min_celsius` SET TAGS ('dbx_business_glossary_term' = 'Minimum Temperature (Celsius)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ALTER COLUMN `temperature_requirement` SET TAGS ('dbx_value_regex' = 'ambient|refrigerated|frozen|deep_frozen');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` SET TAGS ('dbx_subdomain' = 'warehouse_operations');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ALTER COLUMN `buying_order_id` SET TAGS ('dbx_business_glossary_term' = 'Buying Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Food Safety Log Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Center (DC) ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ALTER COLUMN `vendor_item_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Item Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ALTER COLUMN `advance_ship_notice_number` SET TAGS ('dbx_business_glossary_term' = 'Advance Ship Notice (ASN) Number');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ALTER COLUMN `hazmat_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ALTER COLUMN `receiving_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|on_hold|exception');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ALTER COLUMN `receiving_type` SET TAGS ('dbx_value_regex' = 'blind|directed|cross_dock|return|transfer');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` SET TAGS ('dbx_subdomain' = 'fulfillment_distribution');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Destination ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Header Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Planner Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `primary_outbound_dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Center (DC) ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion ID');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `replenishment_order_id` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `ship_from_store_node_id` SET TAGS ('dbx_business_glossary_term' = 'Ship From Store Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `destination_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Destination Address Line 1');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `destination_address_line1` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `destination_address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `destination_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `destination_postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `destination_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `destination_state_province` SET TAGS ('dbx_business_glossary_term' = 'Destination State or Province');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `destination_type` SET TAGS ('dbx_value_regex' = 'store|customer|distribution_center|3pl_node|supplier');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `fill_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Fill Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `is_cross_dock` SET TAGS ('dbx_business_glossary_term' = 'Is Cross-Dock Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `is_drop_ship` SET TAGS ('dbx_business_glossary_term' = 'Is Drop Ship Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `is_hazmat` SET TAGS ('dbx_business_glossary_term' = 'Is Hazardous Material (HAZMAT) Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `is_temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Is Temperature Controlled Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Order Notes');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `order_number` SET TAGS ('dbx_business_glossary_term' = 'Outbound Order Number');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `order_status` SET TAGS ('dbx_business_glossary_term' = 'Outbound Order Status');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Outbound Order Type');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'store_replenishment|ecommerce_fulfillment|bopis|ropis|inter_dc_transfer|dsd_bypass');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Order Priority Level');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'critical|high|normal|low');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `pro_number` SET TAGS ('dbx_business_glossary_term' = 'Progressive (PRO) Number');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `temperature_requirement` SET TAGS ('dbx_value_regex' = 'ambient|refrigerated|frozen|climate_controlled');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `total_cube_m3` SET TAGS ('dbx_business_glossary_term' = 'Total Cube (Cubic Meters)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `total_lines` SET TAGS ('dbx_business_glossary_term' = 'Total Order Lines');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `total_weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Total Weight (Kilograms)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Carrier Tracking Number');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` SET TAGS ('dbx_subdomain' = 'fulfillment_distribution');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `outbound_order_line_id` SET TAGS ('dbx_business_glossary_term' = 'Outbound Order Line Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `assortment_item_id` SET TAGS ('dbx_business_glossary_term' = 'Assortment Item Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `gtin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Gtin Registry Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `lot_id` SET TAGS ('dbx_business_glossary_term' = 'Lot Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `order_line_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Center Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `outbound_order_id` SET TAGS ('dbx_business_glossary_term' = 'Outbound Order Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Product Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Outbound Uom Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Store Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `source_location_id` SET TAGS ('dbx_business_glossary_term' = 'Source Location Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `stock_position_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Position Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `wave_id` SET TAGS ('dbx_business_glossary_term' = 'Wave Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `allocated_qty` SET TAGS ('dbx_business_glossary_term' = 'Allocated Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `carton_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{6,30}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `is_hazmat` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `is_temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Temperature Controlled Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `ordered_qty` SET TAGS ('dbx_business_glossary_term' = 'Ordered Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `original_sku` SET TAGS ('dbx_business_glossary_term' = 'Original Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `original_sku` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `packed_qty` SET TAGS ('dbx_business_glossary_term' = 'Packed Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `picked_qty` SET TAGS ('dbx_business_glossary_term' = 'Picked Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `serial_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{6,40}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `shipped_qty` SET TAGS ('dbx_business_glossary_term' = 'Shipped Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `short_ship_qty` SET TAGS ('dbx_business_glossary_term' = 'Short Ship Quantity');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `short_ship_reason_code` SET TAGS ('dbx_value_regex' = 'stockout|damage|quality_hold|allocation_override|system_error|cancelled');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `sku` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `temperature_requirement` SET TAGS ('dbx_value_regex' = 'ambient|refrigerated|frozen|climate_controlled');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `volume_cubic_meters` SET TAGS ('dbx_business_glossary_term' = 'Volume in Cubic Meters');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight in Kilograms (KG)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` SET TAGS ('dbx_subdomain' = 'fulfillment_distribution');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `wave_id` SET TAGS ('dbx_business_glossary_term' = 'Wave Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Carrier Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Center (DC) Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Merchandise Category Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `channel` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Channel');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `channel` SET TAGS ('dbx_value_regex' = 'store_replenishment|ecommerce|bopis|ship_from_store|wholesale|marketplace');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `equipment_type` SET TAGS ('dbx_value_regex' = 'cart|pallet_jack|forklift|pick_to_light|voice_pick|rf_scanner');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `fill_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Fill Rate Percentage (Pct)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `generation_method` SET TAGS ('dbx_business_glossary_term' = 'Wave Generation Method');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `generation_method` SET TAGS ('dbx_value_regex' = 'scheduled|manual|demand_triggered|threshold_based');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `is_hazmat` SET TAGS ('dbx_business_glossary_term' = 'Is Hazardous Materials (HAZMAT) Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `is_promotional` SET TAGS ('dbx_business_glossary_term' = 'Is Promotional Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `is_temperature_controlled` SET TAGS ('dbx_business_glossary_term' = 'Is Temperature Controlled Flag');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Wave Notes');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `release_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Wave Release Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `short_ship_disposition` SET TAGS ('dbx_value_regex' = 'cancel|backorder|substitute|split_shipment');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `temperature_zone` SET TAGS ('dbx_value_regex' = 'ambient|refrigerated|frozen');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `template_code` SET TAGS ('dbx_business_glossary_term' = 'Wave Template Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `units_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Units Per Hour (UPH)');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `wave_status` SET TAGS ('dbx_value_regex' = 'planned|released|in_progress|short_closed|complete|cancelled');
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ALTER COLUMN `wave_type` SET TAGS ('dbx_value_regex' = 'single_order|multi_order|cluster|zone|wave_less|demand_based');
