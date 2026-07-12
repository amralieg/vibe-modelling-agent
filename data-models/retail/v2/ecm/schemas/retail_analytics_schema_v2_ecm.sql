-- Schema for Domain: analytics | Business:  | Version: v2_ecm
-- Generated on: 2026-07-12 13:53:21

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`analytics` COMMENT 'Manages enterprise reporting definitions, KPI master data, dashboard configurations, data quality rules, and business intelligence metadata. Owns the semantic layer that translates raw data products into business-consumable metrics and dimensions for retail decision-making.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` (
    `kpi_definition_id` BIGINT COMMENT 'Unique identifier for the KPI definition record. Primary key.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Many KPIs are defined to measure compliance program effectiveness (OSHA recordable rate, food safety violation rate, training completion percentage). Link enables compliance reporting architecture and',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.store_department. Business justification: Department-level KPIs (department margin, shrinkage by department, sales per labor hour) are defined for merchandising analytics. Category managers track performance by department across store fleet.',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.store_format. Business justification: Format-level KPIs (typical sales per sqft by format, labor efficiency by format) are defined for format benchmarking and strategic planning. Retail planning teams compare hypermarket vs discount forma',
    `member_segment_id` BIGINT COMMENT 'Foreign key linking to loyalty.member_segment. Business justification: Segment-specific KPIs (segment growth rate, segment profitability, segment churn, segment LTV) are defined per member segment for targeted measurement. Retailers track KPI definitions scoped to high-v',
    `parent_kpi_definition_id` BIGINT COMMENT 'Self-referencing FK on kpi_definition (parent_kpi_definition_id)',
    `aggregation_method` STRING COMMENT 'The method used to aggregate the KPI across dimensions (e.g., sum for total sales, average for average transaction value, count for transaction count, ratio for calculated metrics like sell-through rate). [ENUM-REF-CANDIDATE: sum|average|count|min|max|median|weighted_average|ratio — 8 candidates stripped; promote to reference product]',
    `approval_date` DATE COMMENT 'Date when the KPI definition was formally approved by the data governance council or business steward. Null if not yet approved.',
    `approval_status` STRING COMMENT 'Current approval status of the KPI definition in the governance workflow: draft (under development), pending_review (awaiting steward approval), approved (active and published), deprecated (scheduled for retirement), or retired (no longer in use).. Valid values are `draft|pending_review|approved|deprecated|retired`',
    `benchmark_source` STRING COMMENT 'The source of the benchmark value (e.g., NRF Industry Report 2023, Gartner Retail Analytics, internal historical average). Provides traceability and credibility for the benchmark.',
    `benchmark_value` DECIMAL(18,2) COMMENT 'Industry benchmark or competitive reference value for this KPI, used for external performance comparison. May be sourced from NRF, industry reports, or competitive intelligence. Null if no benchmark is available.',
    `bi_tool_integration` STRING COMMENT 'List of BI tools and platforms where this KPI is published and consumed (e.g., Tableau, Power BI, Looker, SAP Analytics Cloud). Comma-separated list.',
    `calculation_formula` STRING COMMENT 'Mathematical formula or business logic description defining how the KPI is calculated. May be expressed as a formula (e.g., (Net Sales - COGS) / Average Inventory) or as a narrative description of the calculation steps.',
    `change_log` STRING COMMENT 'Summary of changes made in this version of the KPI definition. Documents what was modified, why, and by whom. Supports audit trail and impact analysis.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this KPI definition record was first created in the system. Supports audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code (e.g., USD, EUR, GBP) applicable when unit_of_measure is currency. Null for non-monetary KPIs.. Valid values are `^[A-Z]{3}$`',
    `dashboard_usage_count` STRING COMMENT 'The number of enterprise dashboards and reports that currently consume this KPI. Used to assess the criticality and impact of changes to the KPI definition.',
    `data_lineage_description` STRING COMMENT 'High-level description of the data lineage for this KPI: which source systems, data products, and transformation steps contribute to the calculation. Supports impact analysis and troubleshooting.',
    `data_quality_rule` STRING COMMENT 'Business rules or validation logic that must be applied to ensure the accuracy and reliability of this KPI (e.g., exclude returns older than 90 days, filter out test transactions, require non-null store_id).',
    `data_source_domain` STRING COMMENT 'The primary data domain(s) from which this KPI sources its input data (e.g., Customer, Product, Inventory, Order, Store, Supply Chain, Pricing, Promotion, Finance). May reference multiple domains separated by commas.',
    `data_type` STRING COMMENT 'The data type of the KPI value: decimal (for precise numeric values), integer (for counts), percentage (for ratios expressed as percentages), or boolean (for yes/no metrics).. Valid values are `decimal|integer|percentage|boolean`',
    `effective_end_date` DATE COMMENT 'Date until which this KPI definition is effective. Null for currently active definitions. Used to manage KPI definition versioning and retirement.',
    `effective_start_date` DATE COMMENT 'Date from which this KPI definition is effective and should be used for reporting. Supports versioning and historical tracking of KPI definition changes.',
    `is_lagging_indicator` BOOLEAN COMMENT 'True if this KPI is a lagging indicator (measures past performance, e.g., sales revenue, profit margin). False if it is a leading indicator (predicts future performance, e.g., foot traffic, cart abandonment rate).',
    `is_leading_indicator` BOOLEAN COMMENT 'True if this KPI is a leading indicator (predicts future performance, e.g., promotional engagement, inventory availability). False if it is a lagging indicator (measures past results).',
    `is_published_externally` BOOLEAN COMMENT 'True if this KPI is published in external reports (e.g., investor relations, annual reports, regulatory filings). False if it is for internal use only. Affects data quality and audit requirements.',
    `kpi_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the KPI across the enterprise (e.g., COMP_SALES, GMROI, INV_TURN). Used as a stable technical identifier in BI tools and dashboards.. Valid values are `^[A-Z0-9_]{3,20}$`',
    `kpi_description` STRING COMMENT 'Detailed business description of what the KPI measures, its purpose, and how it supports retail decision-making. Includes context on when and why the metric is used.',
    `kpi_name` STRING COMMENT 'Human-readable business name of the KPI (e.g., Comparable Store Sales, Gross Margin Return on Investment, Inventory Turnover Rate). This is the display name used in reports and dashboards.',
    `last_modified_by` STRING COMMENT 'Username or identifier of the person who last modified this KPI definition. Supports accountability and audit trail.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this KPI definition record was last updated. Supports change tracking and audit trail.',
    `maximum_acceptable_value` DECIMAL(18,2) COMMENT 'The maximum acceptable value above which the KPI performance may indicate an anomaly or issue (e.g., excessive shrinkage, abnormal returns). Null if no maximum threshold is defined.',
    `minimum_acceptable_value` DECIMAL(18,2) COMMENT 'The minimum acceptable value below which the KPI performance is considered unsatisfactory. Used for alerting and exception reporting. Null if no minimum threshold is defined.',
    `owning_business_function` STRING COMMENT 'The primary business function or department responsible for this KPI: merchandising, store operations, supply chain, finance, marketing, e-commerce, human resources, customer service, pricing, or inventory management. [ENUM-REF-CANDIDATE: merchandising|store_operations|supply_chain|finance|marketing|ecommerce|human_resources|customer_service|pricing|inventory — 10 candidates stripped; promote to reference product]',
    `precision_scale` STRING COMMENT 'Numeric precision and scale specification for decimal KPIs (e.g., 18,2 for currency, 5,4 for ratios). Defines the total number of digits and decimal places expected.',
    `regulatory_requirement` STRING COMMENT 'Reference to any regulatory or compliance requirement that mandates the tracking and reporting of this KPI (e.g., SOX financial controls, GDPR data subject rights metrics, FTC advertising compliance). Null if not regulatory-driven.',
    `reporting_frequency` STRING COMMENT 'How often the KPI is calculated and reported: real-time (streaming), hourly, daily, weekly, monthly, quarterly, annually, or on-demand (ad-hoc). [ENUM-REF-CANDIDATE: real-time|hourly|daily|weekly|monthly|quarterly|annually|on-demand — 8 candidates stripped; promote to reference product]',
    `steward_email` STRING COMMENT 'Email address of the business data steward responsible for this KPI. Used for inquiries, clarifications, and change requests.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `steward_name` STRING COMMENT 'Name of the business data steward responsible for the definition, accuracy, and governance of this KPI. This is the business owner, not a technical contact.',
    `target_threshold_value` DECIMAL(18,2) COMMENT 'The target or goal value for this KPI that the business aims to achieve. Used for performance tracking and variance analysis. Null if no target is defined.',
    `time_grain` STRING COMMENT 'The finest level of time granularity at which this KPI is calculated: transaction-level, hourly, daily, weekly, monthly, quarterly, or annually. [ENUM-REF-CANDIDATE: transaction|hour|day|week|month|quarter|year — 7 candidates stripped; promote to reference product]',
    `trend_direction` STRING COMMENT 'Indicates the desired direction of KPI movement: higher_is_better (e.g., sales, margin), lower_is_better (e.g., shrinkage, cost), target_is_optimal (e.g., inventory weeks of supply), or neutral (directional preference depends on context).. Valid values are `higher_is_better|lower_is_better|target_is_optimal|neutral`',
    `unit_of_measure` STRING COMMENT 'The unit in which the KPI value is expressed: currency (USD, EUR), percentage, count (number of items), ratio (dimensionless), days, units, hours, or rate. [ENUM-REF-CANDIDATE: currency|percentage|count|ratio|days|units|hours|rate — 8 candidates stripped; promote to reference product]',
    `version_number` STRING COMMENT 'Semantic version number of the KPI definition (e.g., 1.0, 2.1). Incremented when the calculation logic, thresholds, or other material aspects of the KPI change.. Valid values are `^[0-9]+.[0-9]+$`',
    CONSTRAINT pk_kpi_definition PRIMARY KEY(`kpi_definition_id`)
) COMMENT 'Master catalog of all enterprise KPI definitions used across retail reporting and decision-making. Captures KPI name, business description, calculation formula or logic description, unit of measure (currency, percentage, count, ratio), reporting frequency, owning business function (merchandising, store ops, supply chain, finance, marketing), data source domain, target threshold, and benchmark values. Serves as the semantic layer anchor for all metric consumption by BI tools and dashboards.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`kpi_value` (
    `kpi_value_id` BIGINT COMMENT 'Unique identifier for the KPI value record. Primary key for the kpi_value product.',
    `adjustment_id` BIGINT COMMENT 'Foreign key linking to inventory.adjustment. Business justification: Shrinkage and adjustment KPIs (shrink rate, adjustment cost, LP case closure rate) require direct adjustment linkage for loss prevention reporting, compliance audits, and executive shrinkage reviews.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: KPI measurements often track campaign-level performance (campaign ROAS, campaign conversion rate). Retail analytics teams measure campaign effectiveness; this link enables campaign performance analysi',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Retail KPIs track compliance metrics (food safety scores, OSHA incident rates, audit pass rates). Business filters KPI dashboards and reports by compliance program for regulatory reporting and operati',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Store/department-level KPI tracking requires cost center attribution for P&L analysis, operational scorecards, and manager accountability reporting. Essential dimension for retail operational analytic',
    `cycle_count_id` BIGINT COMMENT 'Foreign key linking to inventory.cycle_count. Business justification: Inventory accuracy KPIs (count variance %, recount rate, accuracy by zone) directly measure cycle count performance. Operations dashboards track these metrics to manage labor efficiency and inventory',
    `demand_forecast_id` BIGINT COMMENT 'Foreign key linking to supplychain.demand_forecast. Business justification: Forecast accuracy KPIs (MAPE, WMAPE, bias) measured against specific forecast runs. Core supply chain planning metric for demand planning effectiveness and inventory optimization decisions.',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.store_department. Business justification: Department performance (actual margin, actual shrinkage, actual sales) is measured and reported for merchandising decisions. Operational analytics require linking measurements to specific departments',
    `disposition_id` BIGINT COMMENT 'Foreign key linking to returns.disposition. Business justification: Disposition recovery rates, restock rates, liquidation performance, and RTV success rates are key supply chain KPIs tracked for reverse logistics optimization and inventory management decisions.',
    `engagement_campaign_id` BIGINT COMMENT 'Foreign key linking to loyalty.engagement_campaign. Business justification: Campaign performance KPIs (participation rate, incremental spend, ROI, tier upgrade count) are measured per engagement campaign. kpi_value with business_entity_type=engagement_campaign requires FK f',
    `fulfillment_node_id` BIGINT COMMENT 'Foreign key linking to fulfillment.node. Business justification: Node-level KPIs (throughput, capacity utilization, labor productivity, cost per unit, on-time ship rate) are core to DC and store operations management. Essential for facility performance scorecards',
    `fulfillment_order_id` BIGINT COMMENT 'Foreign key linking to fulfillment.fulfillment_order. Business justification: Retail KPIs measure fulfillment-specific metrics (pick accuracy, pack time, SLA compliance, cost per order) at the fulfillment order level. Essential for operational performance dashboards, DC scoreca',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Financial KPIs (revenue per sq ft, COGS %, gross margin) require GL account linkage for reconciliation to general ledger, audit trail, and financial statement mapping.',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Category and department-level KPIs (category sales, department margin, subcategory comp) drive merchandising strategy and buyer performance evaluation. Retail planning and reporting operate on hierarc',
    `kpi_definition_id` BIGINT COMMENT 'Reference to the KPI definition master record that defines the metric, calculation logic, and business rules for this KPI value.',
    `liquidation_batch_id` BIGINT COMMENT 'Foreign key linking to returns.liquidation_batch. Business justification: Liquidation recovery rates, batch performance, and net recovery amounts are tracked as KPIs for reverse logistics optimization, vendor negotiations, and financial reporting on inventory write-offs.',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.store_location. Business justification: Actual store performance measurements (comp sales, traffic conversion, labor productivity) are captured with location_id as business_entity_id. Core operational reporting requirement for retail store',
    `loyalty_membership_id` BIGINT COMMENT 'Foreign key linking to loyalty.membership. Business justification: Member-level KPIs (lifetime value, engagement score, retention rate, points velocity) are core retail loyalty metrics. kpi_value.business_entity_type=membership pattern requires FK to membership for',
    `markdown_id` BIGINT COMMENT 'Foreign key linking to pricing.markdown. Business justification: Markdown effectiveness KPIs (sell-through rate, markdown ROI, clearance velocity) directly measure individual markdown events. Enables clearance optimization reporting with drill-through to markdown d',
    `member_segment_id` BIGINT COMMENT 'Foreign key linking to loyalty.member_segment. Business justification: Segment performance measurement via KPI values where business_entity_type=member_segment. Retailers measure segment health, engagement, and profitability metrics for personalization strategy and res',
    `price_change_id` BIGINT COMMENT 'Foreign key linking to pricing.price_change. Business justification: Price change velocity KPIs (approval cycle time, change frequency, competitive response time) track individual price change events. Enables pricing agility dashboards. Real business process: pricing o',
    `prior_period_kpi_value_id` BIGINT COMMENT 'Self-referencing FK on kpi_value (prior_period_kpi_value_id)',
    `profile_id` BIGINT COMMENT 'Foreign key linking to customer.profile. Business justification: Retail KPI dashboards measure customer-level metrics (CLTV, NPS, purchase frequency, churn risk). Customer performance tracking is core to retail CRM and loyalty management. Natural business link for',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Profit center performance measurement is core to retail segment reporting, divisional scorecards, and executive dashboards. Enables channel/region/banner-level KPI analysis for strategic decision-maki',
    `replenishment_plan_id` BIGINT COMMENT 'Foreign key linking to supplychain.replenishment_plan. Business justification: Measures replenishment plan effectiveness KPIs (service level achievement, inventory turns, weeks of supply) for inventory health monitoring and planner performance evaluation. Standard retail plannin',
    `reporting_hierarchy_id` BIGINT COMMENT 'Foreign key linking to analytics.reporting_hierarchy. Business justification: KPI values are often aggregated along reporting hierarchies (organizational, merchandise, geographic). This FK links the value to the specific hierarchy node it represents, enabling roll-up aggregatio',
    `retail_calendar_id` BIGINT COMMENT 'Foreign key linking to analytics.retail_calendar. Business justification: KPI values are measured for specific dates in the retail calendar. This FK links the value to the authoritative retail calendar date (typically the measurement_period_start_date), enabling consistent',
    `return_request_id` BIGINT COMMENT 'Foreign key linking to returns.return_request. Business justification: Return request metrics (approval rate, SLA compliance, request-to-RMA conversion, denial rate) are core retail KPIs tracked for customer service performance management and process optimization.',
    `rma_id` BIGINT COMMENT 'Foreign key linking to returns.rma. Business justification: Returns KPIs (return rate, refund velocity, fraud rate, customer satisfaction) are measured per RMA and tracked in kpi_value for operational dashboards and executive reporting. Real-world retail opera',
    `semantic_layer_entity_id` BIGINT COMMENT 'The unique identifier of the specific business entity instance (e.g., store ID, category ID, region ID) that this KPI value is associated with.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: SKU-level KPIs (sales velocity, inventory turns, margin, out-of-stock rate) are fundamental retail performance metrics. Every merchandising dashboard and buyer scorecard requires SKU-level measurement',
    `sku_price_id` BIGINT COMMENT 'Foreign key linking to pricing.sku_price. Business justification: Pricing performance KPIs (price index, competitive gap %, price elasticity response) measure specific SKU price records. Enables pricing dashboard drill-through from KPI to underlying price detail. Re',
    `stock_ledger_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_ledger. Business justification: Transaction-level KPIs (movement velocity, adjustment frequency, COGS accuracy) measure ledger activity. Audit trails and variance analysis reports require direct ledger linkage for regulatory complia',
    `stock_position_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_position. Business justification: Inventory health KPIs (turnover rate, days on hand, shrinkage %) require direct linkage to stock positions for calculation and drill-through in executive dashboards. Retail operations track position-l',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Retail tracks PO-level KPIs (on-time delivery %, cost variance, fill rate) for vendor scorecards and procurement performance dashboards. Essential for supplier relationship management and procurement',
    `actual_value` DECIMAL(18,2) COMMENT 'The actual computed or ingested value of the KPI for the specified business entity and time period. This is the primary measurement result.',
    `alert_severity` STRING COMMENT 'The severity level of the alert if one was triggered: info (informational), warning (attention needed), critical (immediate action required), or none.. Valid values are `info|warning|critical|none`',
    `alert_triggered_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) showing whether this KPI value triggered a performance alert or threshold breach requiring management attention.',
    `approval_status` STRING COMMENT 'The approval workflow status for this KPI value, particularly relevant for manually-entered or adjusted metrics requiring management sign-off.. Valid values are `draft|pending_review|approved|rejected`',
    `approved_by` STRING COMMENT 'The user ID or name of the person who approved this KPI value, if approval was required. Null for auto-computed metrics.',
    `approved_timestamp` TIMESTAMP COMMENT 'The timestamp when this KPI value was approved, if approval was required. Null for auto-computed metrics.',
    `business_entity_type` STRING COMMENT 'The type of business entity this KPI value is measured against (e.g., store, category, channel, region, supplier, product, customer segment). [ENUM-REF-CANDIDATE: store|category|channel|region|supplier|product|customer_segment — 7 candidates stripped; promote to reference product]',
    `calculation_method` STRING COMMENT 'The method by which this KPI value was derived: computed from raw data, ingested from external system, manually entered, or aggregated from lower-level metrics.. Valid values are `computed|ingested|manual|aggregated`',
    `calculation_timestamp` TIMESTAMP COMMENT 'The timestamp when this KPI value was computed or ingested into the analytics platform.',
    `confidence_interval_lower` DECIMAL(18,2) COMMENT 'The lower bound of the statistical confidence interval for this KPI value, used in forecasting and predictive analytics scenarios.',
    `confidence_interval_upper` DECIMAL(18,2) COMMENT 'The upper bound of the statistical confidence interval for this KPI value, used in forecasting and predictive analytics scenarios.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this KPI value record was first created in the analytics platform.',
    `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for monetary KPI values (e.g., USD, EUR, GBP). Null for non-monetary metrics.. Valid values are `^[A-Z]{3}$`',
    `data_freshness_timestamp` TIMESTAMP COMMENT 'The timestamp indicating when the source data used to calculate this KPI value was last refreshed or updated. Critical for understanding data latency.',
    `data_quality_score` DECIMAL(18,2) COMMENT 'A numerical score (0-100) representing the quality and reliability of this KPI value based on completeness, accuracy, and timeliness of source data.',
    `data_source` STRING COMMENT 'The originating system or data source from which this KPI value was calculated or ingested (e.g., the retail analytics platform, the retail merchandising system, Blue Yonder, manual entry).',
    `forecast_model_version` STRING COMMENT 'The version identifier of the forecasting model or algorithm used to generate this KPI value, if it is a forecast. Null for actual values.',
    `is_active` BOOLEAN COMMENT 'Boolean indicator (True/False) showing whether this KPI value record is currently active and should be used in reporting and analytics. False indicates deprecated or superseded values.',
    `is_forecast` BOOLEAN COMMENT 'Boolean indicator (True/False) showing whether this KPI value represents a forecasted/projected value rather than an actual historical measurement.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this KPI value record was last modified or refreshed.',
    `measurement_period_end_date` DATE COMMENT 'The end date of the time period for which this KPI value was calculated or measured.',
    `measurement_period_start_date` DATE COMMENT 'The start date of the time period for which this KPI value was calculated or measured.',
    `notes` STRING COMMENT 'Free-text field for additional context, explanations, or annotations about this KPI value (e.g., data quality issues, business events affecting the metric).',
    `performance_status` STRING COMMENT 'A categorical assessment of performance relative to target: exceeds target (green), meets target (yellow), below target (amber), critical (red), or not applicable.. Valid values are `exceeds_target|meets_target|below_target|critical|not_applicable`',
    `period_type` STRING COMMENT 'The granularity or type of the measurement period (e.g., daily, weekly, monthly, quarterly, yearly, custom).. Valid values are `daily|weekly|monthly|quarterly|yearly|custom`',
    `prior_period_value` DECIMAL(18,2) COMMENT 'The KPI value from the comparable prior period (e.g., same period last year, previous month) used for trend analysis and year-over-year comparisons.',
    `prior_period_variance_amount` DECIMAL(18,2) COMMENT 'The absolute difference between the actual value and the prior period value (actual_value - prior_period_value). Used for trend analysis.',
    `prior_period_variance_percentage` DECIMAL(18,2) COMMENT 'The percentage change from the prior period value, calculated as ((actual_value - prior_period_value) / prior_period_value) * 100. Enables period-over-period growth analysis.',
    `sample_size` BIGINT COMMENT 'The number of data points or transactions used to calculate this KPI value. Relevant for statistically-derived metrics to assess reliability.',
    `target_value` DECIMAL(18,2) COMMENT 'The planned or target value for this KPI against which actual performance is measured. Used for variance analysis and performance tracking.',
    `trend_direction` STRING COMMENT 'The directional trend of this KPI over recent periods: improving, stable, declining, volatile, or insufficient data for trend analysis.. Valid values are `improving|stable|declining|volatile|insufficient_data`',
    `unit_of_measure` STRING COMMENT 'The unit in which the KPI value is expressed (e.g., USD, units, percentage, days, ratio). Critical for proper interpretation and display of the metric.',
    `variance_amount` DECIMAL(18,2) COMMENT 'The absolute difference between the actual value and the target value (actual_value - target_value). Positive values indicate performance above target.',
    `variance_percentage` DECIMAL(18,2) COMMENT 'The percentage difference between actual and target values, calculated as ((actual_value - target_value) / target_value) * 100. Enables normalized performance comparison.',
    CONSTRAINT pk_kpi_value PRIMARY KEY(`kpi_value_id`)
) COMMENT 'Transactional record capturing the computed or ingested value of a KPI for a specific business entity (store, category, channel, region) and time period. Stores the actual value, target value, prior period value, variance, variance percentage, and data freshness timestamp. Enables trend analysis, target tracking, and performance alerting across all retail KPIs including comp sales, gross margin, inventory turns, and NPS.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`report_definition` (
    `report_definition_id` BIGINT COMMENT 'Unique identifier for the report definition. Primary key for the report registry.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Compliance reports (audit summaries, training rosters, incident logs, regulatory filings) are standard retail requirements. Link enables report catalog governance, regulatory traceability, and automat',
    `parent_report_definition_id` BIGINT COMMENT 'Self-referencing FK on report_definition (parent_report_definition_id)',
    `semantic_layer_entity_id` BIGINT COMMENT 'Foreign key linking to analytics.semantic_layer_entity. Business justification: Reports consume semantic layer entities as their primary data sources. The report_definition has source_data_products: STRING (comma-separated list), but a structured FK to the primary semantic entity',
    `semantic_metric_id` BIGINT COMMENT 'Foreign key linking to analytics.semantic_metric. Business justification: Reports can be built around specific semantic metrics (e.g., a Monthly Revenue Report centered on the Revenue semantic metric). This FK captures the primary metric focus of the report, enabling metr',
    `access_control_group` STRING COMMENT 'Name of the Active Directory group, LDAP group, or IAM role that grants access to this report. Used for automated access provisioning and audit.',
    `approval_date` DATE COMMENT 'Date when the report definition was approved for production use. Nullable for reports not requiring approval or still pending.',
    `approval_status` STRING COMMENT 'Current approval status for reports requiring governance review before publication. Pending reports await approval, approved reports are cleared for production, rejected reports require rework.. Valid values are `pending|approved|rejected`',
    `approved_by` STRING COMMENT 'Username or email of the governance approver who authorized the report for production use. Nullable for reports not requiring approval.',
    `average_execution_time_seconds` DECIMAL(18,2) COMMENT 'Average time in seconds required to generate or refresh the report. Used for performance monitoring and capacity planning.',
    `certification_date` DATE COMMENT 'Date when the report received its certification from the BI governance team. Nullable for non-certified reports.',
    `contains_financial_data` BOOLEAN COMMENT 'Flag indicating whether the report includes financial data subject to SOX, FASB, or other financial reporting standards. Triggers additional audit and retention requirements.',
    `contains_pii` BOOLEAN COMMENT 'Flag indicating whether the report includes personally identifiable information subject to GDPR, CCPA, or other privacy regulations. Triggers additional access controls and audit logging.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the report definition record was first created in the analytics catalog. Audit field for record lifecycle tracking.',
    `data_domains_consumed` STRING COMMENT 'Comma-separated list of data domains that this report consumes data from. Examples: Customer, Order, Product or Inventory, Supply Chain, Store. Enables impact analysis and data lineage tracking.',
    `data_retention_days` STRING COMMENT 'Number of days that historical report snapshots or output files are retained before archival or deletion. Driven by regulatory requirements and storage policies.',
    `delivery_format` STRING COMMENT 'Primary format or platform through which the report is delivered to consumers. Indicates the technical rendering mechanism (PDF, Excel) or BI platform (Tableau, Power BI, Databricks). [ENUM-REF-CANDIDATE: pdf|excel|tableau|powerbi|databricks_notebook|looker|qlik|csv|json|api — 10 candidates stripped; promote to reference product]',
    `deprecation_date` DATE COMMENT 'Date when the report was marked as deprecated and scheduled for retirement. Nullable for active reports. Used to communicate sunset timelines to consumers.',
    `dimension_count` STRING COMMENT 'Number of distinct dimensions or attributes available for slicing and filtering in the report. Indicates the analytical flexibility of the report.',
    `documentation_url` STRING COMMENT 'URL to the detailed report documentation, including metric definitions, data sources, calculation logic, and usage guidelines. Typically points to Confluence, SharePoint, or internal wiki.',
    `governance_classification` STRING COMMENT 'Data classification level of the report content, determining access controls and distribution restrictions. Public reports can be shared externally, internal reports are for employees only, confidential reports contain sensitive business data, restricted reports contain PII/PHI/PCI data.. Valid values are `public|internal|confidential|restricted`',
    `is_certified` BOOLEAN COMMENT 'Flag indicating whether the report has been certified by the BI governance team as meeting quality, accuracy, and documentation standards. Certified reports are promoted in the catalog.',
    `kpi_count` STRING COMMENT 'Number of distinct KPIs or metrics included in the report. Provides a measure of report complexity and scope.',
    `last_modified_by` STRING COMMENT 'Username or email of the person who last modified the report definition. Used for audit trail and change accountability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the report definition record was last updated. Audit field for change tracking and version control.',
    `owning_team` STRING COMMENT 'Name of the business or analytics team responsible for the report definition, maintenance, and quality. Examples: Merchandising Analytics, Finance Reporting, Executive Insights.',
    `publication_date` DATE COMMENT 'Date when the report was first published to production and made available to consumers. Marks the start of the reports operational lifecycle.',
    `refresh_cadence` STRING COMMENT 'Frequency at which the report data is refreshed or regenerated. Defines the data freshness SLA for report consumers. [ENUM-REF-CANDIDATE: real_time|hourly|daily|weekly|monthly|quarterly|annually|on_demand — 8 candidates stripped; promote to reference product]',
    `regulatory_scope` STRING COMMENT 'Comma-separated list of regulatory frameworks or compliance requirements that this report supports. Examples: SOX, GDPR, PCI-DSS, FDA, FTC. Empty if the report has no regulatory purpose.',
    `report_category` STRING COMMENT 'Business domain or functional area that the report primarily serves. Aligns with the enterprise data domain taxonomy to enable domain-based report discovery and governance. [ENUM-REF-CANDIDATE: sales|inventory|finance|customer|supply_chain|workforce|merchandising|ecommerce|store_operations|pricing|promotion|other — 12 candidates stripped; promote to reference product]',
    `report_code` STRING COMMENT 'Unique business identifier for the report, used for external references and API calls. Typically follows a naming convention like RPT_SALES_DAILY or EXEC_DASHBOARD_01.. Valid values are `^[A-Z0-9_]{3,20}$`',
    `report_description` STRING COMMENT 'Detailed business description of the report purpose, key metrics included, intended audience, and business questions it answers. Provides context for report consumers and governance teams.',
    `report_name` STRING COMMENT 'Human-readable name of the report as displayed in the analytics catalog and BI tools. Example: Daily Sales Performance Dashboard or Monthly Inventory Turnover Report.',
    `report_owner_email` STRING COMMENT 'Primary contact email address for the report owner or steward. Used for governance inquiries, change requests, and issue escalation.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `report_status` STRING COMMENT 'Current lifecycle status of the report definition. Draft reports are under development, active reports are in production use, deprecated reports are scheduled for retirement, retired reports are no longer available, suspended reports are temporarily disabled.. Valid values are `draft|active|deprecated|retired|suspended`',
    `report_type` STRING COMMENT 'Classification of the report by its primary business purpose. Operational reports support daily operations, financial reports support accounting and P&L analysis, executive reports provide strategic insights, regulatory reports meet compliance requirements, analytical reports support deep-dive analysis, and adhoc reports are one-time or exploratory.. Valid values are `operational|financial|executive|regulatory|analytical|adhoc`',
    `report_url` STRING COMMENT 'Direct URL or deep link to access the report in the BI platform or analytics portal. Enables one-click navigation from the report catalog.',
    `retirement_date` DATE COMMENT 'Date when the report was retired and removed from production. Nullable for active and deprecated reports. Marks the end of the reports operational lifecycle.',
    `source_data_products` STRING COMMENT 'Comma-separated list of upstream data product names that feed this report. Enables detailed lineage tracking and change impact analysis at the product level.',
    `tags` STRING COMMENT 'Comma-separated list of user-defined tags or labels for report categorization and discovery. Examples: sales, weekly, executive, store-level. Supports flexible taxonomy beyond formal categories.',
    `target_audience` STRING COMMENT 'Description of the intended consumer audience for the report. Examples: Store Managers, Executive Leadership, Finance Controllers, Merchandising Planners. Helps with report discovery and access provisioning.',
    `version_number` STRING COMMENT 'Semantic version number of the report definition following major.minor.patch convention. Incremented when report logic, metrics, or structure changes.. Valid values are `^[0-9]+.[0-9]+.[0-9]+$`',
    CONSTRAINT pk_report_definition PRIMARY KEY(`report_definition_id`)
) COMMENT 'Master record for every enterprise report registered in the analytics catalog. Captures report name, business description, owning team, report type (operational, financial, executive, regulatory), delivery format (PDF, Excel, Tableau, Power BI, Databricks notebook), refresh cadence, data domains consumed, and governance classification. Acts as the authoritative registry of all sanctioned reports across the retail enterprise.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` (
    `dashboard_config_id` BIGINT COMMENT 'Unique identifier for the dashboard configuration record. Primary key for the dashboard_config product.',
    `access_policy_id` BIGINT COMMENT 'Foreign key linking to analytics.analytics_access_policy. Business justification: Dashboards are subject to access policies that determine who can view them. This FK links the dashboard to the governing access policy, enabling enforcement of dashboard-level security and ensuring da',
    `cloned_from_dashboard_config_id` BIGINT COMMENT 'Self-referencing FK on dashboard_config (cloned_from_dashboard_config_id)',
    `access_tier` STRING COMMENT 'Data classification level governing who can access this dashboard: public (all employees), internal (department-level), restricted (role-based), confidential (executive-only).. Valid values are `public|internal|restricted|confidential`',
    `bi_platform` STRING COMMENT 'The BI platform or tool on which this dashboard is deployed (e.g., Tableau, Power BI, Databricks SQL, Looker). [ENUM-REF-CANDIDATE: tableau|power_bi|databricks_sql|looker|qlik|microstrategy|sap_analytics_cloud|oracle_analytics — 8 candidates stripped; promote to reference product]',
    `certification_date` DATE COMMENT 'Date on which the dashboard was last certified by the BI governance team. Certifications typically expire after a defined period (e.g., 12 months).',
    `certification_status` STRING COMMENT 'Indicates whether the dashboard has been reviewed and certified by the BI governance team for data accuracy, compliance, and best practices: certified, pending_certification, not_certified.. Valid values are `certified|pending_certification|not_certified`',
    `compliance_tags` STRING COMMENT 'Comma-separated list of regulatory or compliance frameworks this dashboard supports (e.g., SOX, GDPR, PCI_DSS, ASC_606). Used for audit trail and regulatory reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this dashboard configuration record was first created in the system. Supports audit trail and lifecycle tracking.',
    `dashboard_code` STRING COMMENT 'Unique business identifier code for the dashboard used in BI platform URLs and API references (e.g., STORE_PERF_001, INV_HEALTH_002).. Valid values are `^[A-Z0-9_]{3,20}$`',
    `dashboard_description` STRING COMMENT 'Detailed business description of the dashboard purpose, key metrics displayed, intended use cases, and decision-making support provided.',
    `dashboard_name` STRING COMMENT 'Human-readable name of the business intelligence dashboard (e.g., Store Performance Scorecard, Inventory Health Monitor, Sales Executive Summary).',
    `dashboard_owner_email` STRING COMMENT 'Email address of the dashboard owner for governance inquiries, access requests, and issue escalation.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `dashboard_owner_name` STRING COMMENT 'Full name of the business owner or product manager responsible for the dashboard content, accuracy, and governance.',
    `dashboard_type` STRING COMMENT 'Classification of the dashboard by its primary business purpose: operational (real-time monitoring), strategic (long-term planning), analytical (deep-dive analysis), tactical (short-term actions), executive (C-suite summary), or compliance (regulatory reporting).. Valid values are `operational|strategic|analytical|tactical|executive|compliance`',
    `data_source_references` STRING COMMENT 'Comma-separated or JSON list of underlying data products, tables, or views that feed this dashboard (e.g., sales_transaction, inventory_snapshot, store_master). Enables data lineage tracking.',
    `effective_end_date` DATE COMMENT 'Date on which this dashboard configuration is deactivated or superseded by a new version. Null for currently active dashboards.',
    `effective_start_date` DATE COMMENT 'Date from which this dashboard configuration becomes active and accessible to users. Supports phased rollouts and scheduled launches.',
    `embedded_kpi_references` STRING COMMENT 'Comma-separated or JSON list of KPI identifiers that are visualized on this dashboard (e.g., comp_sales, gmroi, fill_rate, shrinkage_rate). Links to the KPI master data product.',
    `export_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether users are permitted to export data from this dashboard to external formats (Excel, PDF, CSV). May be restricted for confidential dashboards.',
    `filter_defaults` STRING COMMENT 'JSON or key-value structure defining default filter values applied when the dashboard loads (e.g., date range: last 30 days, region: all, store format: hypermarket).',
    `is_active` BOOLEAN COMMENT 'Boolean flag indicating whether this dashboard configuration is currently active and accessible to users. Inactive dashboards are hidden from user catalogs.',
    `last_accessed_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent user access to this dashboard. Used to identify stale or unused dashboards for archival.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this dashboard configuration record. Tracks configuration change history.',
    `layout_configuration` STRING COMMENT 'JSON or XML structure defining the dashboard layout, including widget placement, grid dimensions, responsive breakpoints, and visual hierarchy. Stored as serialized configuration metadata.',
    `mobile_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether this dashboard is optimized for and accessible on mobile devices (smartphones, tablets).',
    `owning_business_unit` STRING COMMENT 'The primary business unit or department that owns and governs this dashboard (e.g., merchandising, store_operations, supply_chain, finance, ecommerce). [ENUM-REF-CANDIDATE: merchandising|store_operations|supply_chain|finance|ecommerce|marketing|human_resources|loss_prevention|customer_service|real_estate — 10 candidates stripped; promote to reference product]',
    `publication_status` STRING COMMENT 'Current lifecycle state of the dashboard: draft (under development), in_review (pending approval), published (live and accessible), archived (historical reference), deprecated (no longer maintained).. Valid values are `draft|in_review|published|archived|deprecated`',
    `published_timestamp` TIMESTAMP COMMENT 'Timestamp when this dashboard was last published and made available to end users. Distinct from creation or modification timestamps.',
    `refresh_schedule` STRING COMMENT 'Frequency at which the underlying data for this dashboard is refreshed: real_time (streaming), hourly, daily, weekly, monthly, or on_demand (manual trigger).. Valid values are `real_time|hourly|daily|weekly|monthly|on_demand`',
    `refresh_time` TIMESTAMP COMMENT 'Scheduled time of day (HH:MM format, 24-hour clock) when the dashboard data refresh job executes. Applicable for daily, weekly, or monthly refresh schedules.',
    `subscription_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether users can subscribe to scheduled email or notification delivery of this dashboard.',
    `tags` STRING COMMENT 'Comma-separated list of business tags or keywords for dashboard discovery and categorization (e.g., sales, inventory, store_performance, executive, real_time).',
    `target_persona` STRING COMMENT 'Primary user role or persona for whom this dashboard is designed (e.g., Store Manager, Category Buyer, DC Supervisor, CFO, Merchandising Planner, Demand Planner, Loss Prevention Analyst).',
    `technical_contact_email` STRING COMMENT 'Email address of the technical contact for dashboard support, bug reports, and technical inquiries.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `technical_contact_name` STRING COMMENT 'Full name of the technical developer or BI engineer responsible for dashboard maintenance, troubleshooting, and enhancements.',
    `thumbnail_url` STRING COMMENT 'URL to a preview image or screenshot of the dashboard used in catalog listings, search results, and governance portals.',
    `url` STRING COMMENT 'Direct web link to access the dashboard in the BI platform. Enables single-click navigation from metadata catalogs and governance tools.',
    `usage_count` BIGINT COMMENT 'Cumulative number of times this dashboard has been accessed or viewed by users. Used for adoption tracking and ROI analysis.',
    `version_number` STRING COMMENT 'Semantic version number of the dashboard configuration (e.g., 1.0.0, 2.3.1). Incremented with each published change to track dashboard evolution.. Valid values are `^[0-9]+.[0-9]+.[0-9]+$`',
    CONSTRAINT pk_dashboard_config PRIMARY KEY(`dashboard_config_id`)
) COMMENT 'Master configuration record for each business intelligence dashboard deployed across retail operations. Captures dashboard name, owning business unit, target persona (store manager, buyer, DC supervisor, CFO), BI platform (Tableau, Power BI, Databricks SQL), layout configuration, embedded KPI references, filter defaults, refresh schedule, access tier, and publication status. Governs the semantic layer presentation of retail metrics to business consumers.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` (
    `dashboard_widget_id` BIGINT COMMENT 'Unique identifier for the dashboard widget. Primary key.',
    `audit_event_id` BIGINT COMMENT 'Foreign key linking to compliance.audit_event. Business justification: Retail operations dashboards display recent audit results as widgets (store health scores, recent findings, compliance status). Direct link supports real-time compliance visibility for store managers',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Dashboard widgets display campaign-specific metrics (campaign spend vs. budget, campaign conversion funnel). Retail marketing dashboards show campaign performance; this link enables campaign-scoped wi',
    `associate_id` BIGINT COMMENT 'Identifier of the user who owns and is responsible for maintaining this widget.',
    `dashboard_config_id` BIGINT COMMENT 'Identifier of the parent dashboard that contains this widget.',
    `dashboard_created_by_user_associate_id` BIGINT COMMENT 'Identifier of the user who created this widget.',
    `dashboard_modified_by_user_associate_id` BIGINT COMMENT 'Identifier of the user who last modified this widget.',
    `dq_rule_id` BIGINT COMMENT 'Identifier of the data quality rule applied to validate the data displayed in this widget. Null if no specific rule is enforced.',
    `kpi_definition_id` BIGINT COMMENT 'Identifier of the KPI definition that this widget visualizes. Null if widget displays a custom report rather than a predefined KPI.',
    `parent_dashboard_widget_id` BIGINT COMMENT 'Self-referencing FK on dashboard_widget (parent_dashboard_widget_id)',
    `report_definition_id` BIGINT COMMENT 'Identifier of the report definition that this widget renders. Null if widget displays a KPI rather than a custom report.',
    `semantic_layer_entity_id` BIGINT COMMENT 'Foreign key linking to analytics.semantic_layer_entity. Business justification: Dashboard widgets can query semantic layer entities directly for data-driven visualizations (e.g., a table widget showing all customers from the Customer semantic entity). This FK enables widgets to b',
    `business_domain` STRING COMMENT 'Business domain or functional area that this widget supports (e.g., Sales, Inventory, Finance, Customer, Supply Chain).',
    `conditional_formatting_rules` STRING COMMENT 'JSON or structured text defining conditional formatting rules (color coding, icons, thresholds) applied to widget data based on business logic.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this widget record was first created in the system.',
    `dashboard_widget_status` STRING COMMENT 'Current lifecycle status of the widget: active (published and visible), inactive (hidden), draft (under development), archived (retained for history), or deprecated (scheduled for removal).. Valid values are `active|inactive|draft|archived|deprecated`',
    `data_query_reference` STRING COMMENT 'Reference to the underlying data query or dataset identifier (SQL view name, data product name, or query ID) that feeds this widget.',
    `dashboard_widget_description` STRING COMMENT 'Detailed business description of the widget purpose, data displayed, and intended use cases.',
    `display_order` STRING COMMENT 'Sequence number controlling the rendering order of widgets within the dashboard, used for layering and tab order.',
    `drill_through_enabled` BOOLEAN COMMENT 'Indicates whether drill-through navigation to detailed reports or dashboards is enabled for this widget.',
    `drill_through_target` STRING COMMENT 'Reference to the target dashboard, report, or URL that users navigate to when drilling through from this widget. Null if drill-through is disabled.',
    `effective_end_date` DATE COMMENT 'Date when this widget configuration expires and is no longer visible to users. Null indicates no expiration.',
    `effective_start_date` DATE COMMENT 'Date when this widget configuration becomes effective and visible to users.',
    `export_enabled` BOOLEAN COMMENT 'Indicates whether users can export widget data to external formats (CSV, Excel, PDF).',
    `export_formats` STRING COMMENT 'Comma-separated list of allowed export formats (CSV, XLSX, PDF, PNG) for this widget. Null if export is disabled.',
    `filter_configuration` STRING COMMENT 'JSON or structured text defining the filter configuration (filter fields, default values, filter type) for this widget. Null if filtering is disabled.',
    `filter_enabled` BOOLEAN COMMENT 'Indicates whether interactive filtering is enabled for this widget, allowing users to apply filters to the displayed data.',
    `height` STRING COMMENT 'Height of the widget in grid units or pixels, defining its vertical span on the dashboard canvas.',
    `last_refresh_timestamp` TIMESTAMP COMMENT 'Timestamp when the widget data was last refreshed from the underlying data source.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this widget record was last modified.',
    `position_x` STRING COMMENT 'Horizontal position coordinate (in grid units or pixels) of the widget within the dashboard layout.',
    `position_y` STRING COMMENT 'Vertical position coordinate (in grid units or pixels) of the widget within the dashboard layout.',
    `refresh_behavior` STRING COMMENT 'Defines when the widget data is refreshed: manual (user-triggered), auto (periodic), on_load (dashboard open), or scheduled (specific times).. Valid values are `manual|auto|on_load|scheduled`',
    `refresh_interval_seconds` STRING COMMENT 'Automatic refresh interval in seconds. Null indicates manual refresh only.',
    `tags` STRING COMMENT 'Comma-separated list of business tags or keywords for categorization, search, and discovery of widgets (e.g., sales, inventory, KPI, executive).',
    `tooltip_text` STRING COMMENT 'Help text or tooltip displayed to users when hovering over the widget, providing context or usage guidance.',
    `usage_count` BIGINT COMMENT 'Cumulative count of how many times this widget has been viewed or interacted with by users, supporting usage analytics and widget optimization.',
    `version_number` STRING COMMENT 'Version number of the widget configuration, incremented with each modification to support change tracking and rollback.',
    `visibility_scope` STRING COMMENT 'Defines who can view this widget: public (all users), private (owner only), role_based (specific roles), or user_specific (specific users).. Valid values are `public|private|role_based|user_specific`',
    `visualization_type` STRING COMMENT 'Specific visualization rendering type (bar chart, line chart, pie chart, heatmap, etc.) used to display data. [ENUM-REF-CANDIDATE: bar|line|pie|donut|scatter|heatmap|treemap|waterfall|funnel|area|combo|bullet|grid|pivot — 14 candidates stripped; promote to reference product]',
    `widget_name` STRING COMMENT 'Business-friendly name of the widget displayed to end users.',
    `widget_title` STRING COMMENT 'Display title shown in the widget header on the dashboard canvas.',
    `widget_type` STRING COMMENT 'Functional type of the widget component (chart, table, scorecard, map, sparkline, gauge).. Valid values are `chart|table|scorecard|map|sparkline|gauge`',
    `width` STRING COMMENT 'Width of the widget in grid units or pixels, defining its horizontal span on the dashboard canvas.',
    CONSTRAINT pk_dashboard_widget PRIMARY KEY(`dashboard_widget_id`)
) COMMENT 'Individual visual component (chart, table, scorecard, map, sparkline) configured within a dashboard. Captures widget name, widget type, associated KPI or report definition, visualization type, position coordinates within the dashboard layout, data query reference, conditional formatting rules, drill-through targets, and refresh behavior. Enables fine-grained governance of dashboard composition and supports impact analysis when upstream data products change.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` (
    `metric_dimension_id` BIGINT COMMENT 'Unique identifier for the metric dimension master record. Primary key for the dimensional modeling backbone used in OLAP cube design and BI semantic layer configuration.',
    `parent_metric_dimension_id` BIGINT COMMENT 'Self-referencing FK on metric_dimension (parent_metric_dimension_id)',
    `primary_replacement_metric_dimension_id` BIGINT COMMENT 'Reference to the metric_dimension_id of the dimension that replaces this deprecated dimension. Null if no replacement exists. Supports migration planning and backward compatibility mapping.',
    `associated_domain` STRING COMMENT 'The primary data domain to which this dimension belongs, such as Customer, Product, Inventory, Order, Store, Supply Chain, Pricing, Promotion, or Finance. Aligns the dimension with enterprise data governance and domain ownership structures.',
    `business_owner` STRING COMMENT 'Name or identifier of the business unit, role, or individual responsible for the business definition, quality, and governance of this dimension. Typically a domain data steward or business subject matter expert.',
    `business_rules` STRING COMMENT 'Documentation of business rules, constraints, and logic applied to this dimension. Examples include how dimension members are classified, how hierarchies are constructed, or how slowly changing dimension logic is applied.',
    `cardinality_estimate` BIGINT COMMENT 'Estimated number of distinct members or rows in this dimension. Used for query optimization, index design, and OLAP cube sizing. For example, Store dimension might have 5000 members, while Time dimension at day grain might have 3650 members for 10 years.',
    `compliance_tags` STRING COMMENT 'Comma-separated list of regulatory compliance frameworks or requirements applicable to this dimension. Examples include GDPR, CCPA, PCI DSS, SOX, HIPAA. Used for compliance reporting and audit trail documentation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this dimension master record was first created in the semantic layer metadata repository. Supports audit trail and data lineage tracking.',
    `data_quality_rules` STRING COMMENT 'Specification of data quality rules and validation checks applied to this dimension. Includes completeness checks, uniqueness constraints, referential integrity rules, and acceptable value ranges.',
    `default_aggregation` STRING COMMENT 'The default aggregation method to apply when this dimension is used in calculations or rolled up in hierarchies. Typically none for true dimensions, but may specify aggregation for degenerate dimensions or dimension attributes used in calculations. [ENUM-REF-CANDIDATE: sum|average|count|min|max|distinct_count|none — 7 candidates stripped; promote to reference product]',
    `default_sort_order` STRING COMMENT 'Numeric value indicating the default display order of this dimension in BI tools, dashboards, and reports. Lower values appear first. Used to standardize dimension presentation across the enterprise semantic layer.',
    `deprecated_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this dimension has been deprecated and is scheduled for retirement. Deprecated dimensions should not be used in new reports or dashboards but are retained for backward compatibility.',
    `deprecation_date` DATE COMMENT 'The date on which this dimension was marked as deprecated. Null if the dimension is not deprecated. Used for planning migration and retirement activities.',
    `dimension_code` STRING COMMENT 'Short alphanumeric code or abbreviation for the dimension, used as a technical identifier in BI tools and semantic layer configurations. Typically uppercase and concise for system integration.',
    `dimension_description` STRING COMMENT 'Comprehensive business description of the dimension, its purpose, and how it should be used in analytics and reporting. Provides context for business users and data analysts consuming the semantic layer.',
    `dimension_name` STRING COMMENT 'The business name of the dimension used to slice and filter KPIs and metrics in the retail semantic layer. Examples include Store, Channel, Category, Brand, Region, Time Period, Customer Segment.',
    `dimension_type` STRING COMMENT 'Classification of the dimension based on dimensional modeling patterns. Conformed dimensions are shared across multiple fact tables; degenerate dimensions are stored in the fact table; role-playing dimensions serve multiple contexts; junk dimensions combine low-cardinality flags; slowly changing dimensions track historical changes; outrigger dimensions are secondary dimensions referenced by a primary dimension.. Valid values are `conformed|degenerate|role_playing|junk|slowly_changing|outrigger`',
    `display_format` STRING COMMENT 'Specification of how dimension members should be formatted for display in BI tools and reports. Examples include date formats, number formats, or custom display templates for composite keys.',
    `drill_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether drill-down and drill-up operations are enabled for this dimension in OLAP cubes and BI tools. Requires hierarchy_levels to be defined.',
    `effective_end_date` DATE COMMENT 'The date on which this dimension definition ceased to be effective. Null if the dimension is currently active. Used for historical tracking and version management of dimension metadata.',
    `effective_start_date` DATE COMMENT 'The date from which this dimension definition became effective and available for use in the semantic layer. Supports temporal validity and version control of dimension metadata.',
    `filter_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether this dimension is available for use as a filter in BI tools and dashboards. Some dimensions may be display-only and not suitable for filtering due to cardinality or performance considerations.',
    `grain_description` STRING COMMENT 'Detailed description of the level of detail or granularity represented by this dimension. Defines what one row in the dimension table represents, such as individual store location, daily time period, or product SKU level.',
    `hierarchy_levels` STRING COMMENT 'Comma-separated list of hierarchical levels within the dimension, ordered from most granular to most aggregated. For example, Store dimension might have: Store > District > Region > Division. Time dimension might have: Day > Week > Month > Quarter > Year. Supports drill-down and roll-up analytics.',
    `is_active` BOOLEAN COMMENT 'Boolean flag indicating whether this dimension is currently active and available for use in BI tools, semantic layers, and OLAP cubes. Inactive dimensions are retained for historical reference but not exposed to end users.',
    `is_conformed` BOOLEAN COMMENT 'Boolean flag indicating whether this dimension is a conformed dimension shared across multiple fact tables and business processes. Conformed dimensions enable consistent cross-process reporting and are a cornerstone of enterprise data warehouse design.',
    `is_slowly_changing` BOOLEAN COMMENT 'Boolean flag indicating whether this dimension tracks historical changes over time using Slowly Changing Dimension (SCD) techniques. True if the dimension maintains history of attribute changes; false if only current state is maintained.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this dimension master record was last updated. Tracks the most recent change to dimension metadata, supporting change management and audit requirements.',
    `notes` STRING COMMENT 'Free-form text field for additional notes, comments, or documentation about this dimension. Used for capturing implementation details, known issues, or special handling instructions.',
    `refresh_frequency` STRING COMMENT 'The frequency at which this dimension is refreshed from source systems. Determines data latency and impacts BI tool cache strategies and OLAP cube processing schedules.. Valid values are `real_time|hourly|daily|weekly|monthly|on_demand`',
    `scd_type` STRING COMMENT 'Classification of the SCD technique applied to this dimension. Type 0: retain original; Type 1: overwrite; Type 2: add new row with versioning; Type 3: add new column; Type 4: separate history table; Type 6: hybrid (1+2+3). Not applicable if is_slowly_changing is false. [ENUM-REF-CANDIDATE: type_0|type_1|type_2|type_3|type_4|type_6|not_applicable — 7 candidates stripped; promote to reference product]',
    `security_classification` STRING COMMENT 'Data classification level for this dimension, determining access controls and data handling requirements. Public: no restrictions; Internal: company employees only; Confidential: sensitive business data; Restricted: highly sensitive data requiring special authorization.. Valid values are `public|internal|confidential|restricted`',
    `technical_owner` STRING COMMENT 'Name or identifier of the technical team, role, or individual responsible for the implementation, maintenance, and technical quality of this dimension in the semantic layer and BI platforms.',
    `usage_count` BIGINT COMMENT 'Number of fact tables, KPIs, metrics, dashboards, or reports that reference this dimension. High usage count indicates a critical conformed dimension; low usage may indicate a candidate for deprecation or consolidation.',
    `version_number` STRING COMMENT 'Version number of this dimension definition. Incremented when significant changes are made to dimension structure, hierarchy, or business rules. Supports change management and impact analysis.',
    CONSTRAINT pk_metric_dimension PRIMARY KEY(`metric_dimension_id`)
) COMMENT 'Master record defining the business dimensions used to slice and filter KPIs and metrics in the retail semantic layer. Captures dimension name (store, channel, category, brand, region, time period, customer segment), dimension type (conformed, degenerate, role-playing), grain description, associated domain, hierarchy levels, and default sort order. Serves as the dimensional modeling backbone for OLAP cube design and BI tool semantic layer configuration.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`dq_rule` (
    `dq_rule_id` BIGINT COMMENT 'Unique identifier for the data quality rule. Primary key for the DQ rule registry.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Data quality rules enforce compliance data integrity (required fields for OSHA logs, food safety temperature ranges, training completion validation). Link enables compliance-driven DQ governance and r',
    `parent_dq_rule_id` BIGINT COMMENT 'Self-referencing FK on dq_rule (parent_dq_rule_id)',
    `semantic_layer_entity_id` BIGINT COMMENT 'Foreign key linking to analytics.semantic_layer_entity. Business justification: DQ rules can target semantic layer entities in addition to raw data products. The dq_rule has target_domain, target_product, target_attribute for raw products, but semantic layer entities are also dat',
    `approved_by` STRING COMMENT 'User ID of the data steward or governance authority who approved this rule for production use. Required for critical and major severity rules.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this rule was formally approved for enforcement. Null for draft or unapproved rules.',
    `blocking_flag` BOOLEAN COMMENT 'Indicates whether violations of this rule should halt downstream pipeline execution. True for critical data integrity rules; false for monitoring-only rules.',
    `business_justification` STRING COMMENT 'Explanation of the business need or regulatory requirement driving this rule. Links rule to business outcomes, compliance mandates, or risk mitigation.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this rule record was first created in the registry. Immutable audit field.',
    `documentation_url` STRING COMMENT 'Link to detailed documentation, runbook, or knowledge base article explaining this rule, its business context, and remediation procedures.',
    `effective_from_date` DATE COMMENT 'Date when this rule version became active and began enforcement. Used for temporal rule versioning and audit trail.',
    `effective_to_date` DATE COMMENT 'Date when this rule version was superseded or retired. Null for currently active rules. Supports rule history and compliance audits.',
    `execution_frequency` STRING COMMENT 'Cadence at which this rule is evaluated. Real-time rules run on every record insert/update; batch rules run on scheduled intervals.. Valid values are `real_time|hourly|daily|weekly|monthly|on_demand`',
    `execution_layer` STRING COMMENT 'Lakehouse medallion layer where this rule is enforced. Bronze for ingestion validation, Silver for transformation quality, Gold for consumption readiness.. Valid values are `bronze|silver|gold`',
    `last_execution_timestamp` TIMESTAMP COMMENT 'Date and time when this rule was most recently evaluated. Used to monitor rule execution health and detect stale rules.',
    `last_violation_count` BIGINT COMMENT 'Number of records that failed this rule during the most recent execution. Used for trend analysis and alerting.',
    `modified_by` STRING COMMENT 'User ID or service account that last updated this rule definition. Used for change tracking and accountability.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to this rule record. Updated on every change for audit trail.',
    `notification_enabled` BOOLEAN COMMENT 'Flag indicating whether automated alerts should be sent when this rule is violated. True enables email/Slack/PagerDuty notifications.',
    `notification_recipients` STRING COMMENT 'Comma-separated list of email addresses, Slack channels, or distribution lists to notify when this rule is violated. Used by alerting engine.',
    `quarantine_enabled` BOOLEAN COMMENT 'Flag indicating whether records violating this rule should be moved to a quarantine table for manual review. True enables automatic quarantine workflow.',
    `regulatory_reference` STRING COMMENT 'Citation of applicable regulation, standard, or policy requiring this rule (e.g., GDPR Article 5, SOX Section 404, PCI DSS 3.2). Null if rule is business-driven only.',
    `remediation_action` STRING COMMENT 'Prescribed corrective action or workflow to be triggered when this rule is violated. May reference automated fix procedures or manual investigation steps.',
    `remediation_owner` STRING COMMENT 'Business role, team, or individual responsible for investigating and resolving violations of this rule. Used for incident routing and accountability.',
    `rule_code` STRING COMMENT 'Unique business identifier or mnemonic code for the rule. Used for cross-system reference and automation.',
    `rule_description` STRING COMMENT 'Detailed business explanation of what the rule validates, why it matters, and what constitutes a violation. Used for documentation and training.',
    `rule_logic` STRING COMMENT 'SQL expression, Python function, or declarative logic defining the rule condition. Returns true for valid records, false for violations.',
    `rule_name` STRING COMMENT 'Human-readable name of the data quality rule. Used for identification and reporting purposes.',
    `rule_priority` STRING COMMENT 'Execution order priority when multiple rules apply to the same target. Lower numbers execute first. Used to sequence dependent validations.',
    `rule_status` STRING COMMENT 'Current lifecycle status of the rule. Active rules are enforced in production; inactive/deprecated rules are retained for audit history.. Valid values are `active|inactive|draft|deprecated|suspended`',
    `rule_tags` STRING COMMENT 'Comma-separated list of metadata tags for rule categorization and filtering (e.g., PII, financial, regulatory, master_data). Used for rule discovery and reporting.',
    `rule_type` STRING COMMENT 'Category of data quality dimension this rule enforces: completeness (null checks), uniqueness (duplicate detection), validity (format/range checks), consistency (cross-field logic), timeliness (freshness checks), or referential integrity (FK validation).. Valid values are `completeness|uniqueness|validity|consistency|timeliness|referential_integrity`',
    `rule_version` STRING COMMENT 'Semantic version identifier for this rule definition (e.g., 1.0.0, 2.1.3). Incremented when rule logic, thresholds, or scope change.',
    `severity_level` STRING COMMENT 'Business impact classification of rule violations. Critical violations block downstream processing; warnings are logged but do not halt pipelines.. Valid values are `critical|major|minor|warning`',
    `target_attribute` STRING COMMENT 'The specific column or attribute within the target product that this rule validates. Null if rule applies to entire product or multiple attributes.',
    `target_domain` STRING COMMENT 'The business domain (e.g., Customer, Product, Order, Inventory) to which this rule applies. Aligns with enterprise data domain taxonomy.',
    `target_product` STRING COMMENT 'The specific data product or table within the target domain that this rule validates. Fully qualified name in domain.product format.',
    `threshold_operator` STRING COMMENT 'Comparison operator applied to threshold_value. Defines whether the measured metric must be above, below, or equal to the threshold.. Valid values are `less_than|less_than_or_equal|greater_than|greater_than_or_equal|equal|not_equal`',
    `threshold_unit` STRING COMMENT 'Unit of measure for threshold_value. Percentage for error rates, count for absolute violations, ratio for proportional checks.. Valid values are `percentage|count|ratio`',
    `threshold_value` DECIMAL(18,2) COMMENT 'Numeric threshold for rule pass/fail determination. Interpretation depends on threshold_operator (e.g., error rate must be less than 0.05).',
    `created_by` STRING COMMENT 'User ID or service account that originally defined this rule. Used for accountability and change tracking.',
    CONSTRAINT pk_dq_rule PRIMARY KEY(`dq_rule_id`)
) COMMENT 'Master record for data quality rules governing the analytics domain and cross-domain data products. Captures rule name, rule type (completeness, uniqueness, validity, consistency, timeliness, referential integrity), target domain and product, SQL or expression-based rule logic, severity level (critical, major, minor), expected threshold, remediation owner, and rule status. Serves as the authoritative registry of all DQ controls enforced in the Databricks Silver Layer.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`dq_result` (
    `dq_result_id` BIGINT COMMENT 'Unique identifier for the data quality rule execution result record.',
    `audit_event_id` BIGINT COMMENT 'Foreign key linking to compliance.audit_event. Business justification: Audit data quality is validated before regulatory submission (OSHA 300 logs, food safety records). Link tracks DQ validation results tied to specific audit cycles for regulatory compliance assurance.',
    `dq_rule_id` BIGINT COMMENT 'Identifier of the data quality rule that was executed. References the rule definition in the DQ rule catalog.',
    `financial_period_id` BIGINT COMMENT 'Foreign key linking to finance.financial_period. Business justification: Data quality checks on financial data are executed per fiscal period for close process validation, SOX compliance, and audit readiness. Period context essential for issue tracking.',
    `fulfillment_order_id` BIGINT COMMENT 'Foreign key linking to fulfillment.fulfillment_order. Business justification: Data quality checks on fulfillment order data (missing tracking numbers, invalid statuses, orphaned records, SLA calculation accuracy) ensure operational data integrity. Essential for data governance',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to fulfillment.shipment. Business justification: Shipment data quality validation (tracking number format, carrier code validity, address completeness, weight/dimension accuracy) ensures reliable logistics operations. Critical for carrier integratio',
    `inbound_shipment_id` BIGINT COMMENT 'Foreign key linking to supplychain.inbound_shipment. Business justification: Validates ASN and receiving data quality (quantity accuracy, timestamp completeness). Essential for warehouse operations data integrity and supplier compliance monitoring.',
    `previous_dq_result_id` BIGINT COMMENT 'Self-referencing FK on dq_result (previous_dq_result_id)',
    `retail_calendar_id` BIGINT COMMENT 'Foreign key linking to analytics.retail_calendar. Business justification: DQ results are executed on specific dates in the retail calendar. This FK links the result to the authoritative retail calendar date (typically the execution_timestamp date), enabling fiscal period an',
    `stock_position_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_position. Business justification: Data quality rules validate stock positions (negative inventory, ATP calculation errors, stale timestamps). DQ dashboards require direct position linkage for remediation workflows and data steward inv',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Tracks data quality validation results for PO data (completeness, accuracy of costs, dates). Required for procurement data governance and financial reconciliation processes.',
    `semantic_layer_entity_id` BIGINT COMMENT 'Foreign key linking to analytics.semantic_layer_entity. Business justification: DQ results can be for semantic layer entities, consistent with dq_rule → semantic_layer_entity. When a DQ rule targets a semantic entity, the execution result should reference that entity. This FK ena',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Quality results track which SKUs failed validation (missing dimensions, incomplete nutritional data, expired compliance certs). Stewards need SKU-level failure tracking for remediation. Data quality s',
    `batch_code` STRING COMMENT 'Identifier for the batch or job that executed this rule. Used to group multiple rule executions that ran together as part of a scheduled DQ assessment.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this DQ result record was first created in the lakehouse. Used for audit trail and data lineage tracking.',
    `data_snapshot_timestamp` TIMESTAMP COMMENT 'Timestamp of the data snapshot that was evaluated. May differ from execution_timestamp if the rule evaluates historical or point-in-time data.',
    `data_trust_score` DECIMAL(18,2) COMMENT 'Calculated trust score for the target data product based on this rule execution result, ranging from 0.00 (no trust) to 100.00 (full trust). Aggregated across multiple rules to produce product-level trust metrics.',
    `execution_duration_seconds` DECIMAL(18,2) COMMENT 'Time taken to execute the data quality rule against the target data product, measured in seconds. Used for performance monitoring and optimization.',
    `execution_error_message` STRING COMMENT 'Technical error message if the rule execution failed or encountered issues. Null if execution completed successfully.',
    `execution_status` STRING COMMENT 'Technical execution status of the rule run: completed (rule executed successfully), failed (execution error), timeout (exceeded time limit), cancelled (manually stopped).. Valid values are `completed|failed|timeout|cancelled`',
    `execution_timestamp` TIMESTAMP COMMENT 'Date and time when the data quality rule was executed against the target data product. Represents the business event time of the quality check.',
    `failure_rate_percent` DECIMAL(18,2) COMMENT 'Percentage of records that failed the quality check, calculated as (records_failed_count / records_evaluated_count) * 100. Used for trend analysis and SLA monitoring.',
    `failure_reason` STRING COMMENT 'Detailed explanation of why records failed the quality check (e.g., Email format invalid, Value exceeds maximum threshold, Required field is null).',
    `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether an alert notification was sent to data stewards or stakeholders for this quality check result. True if notification sent, False otherwise.',
    `pass_fail_status` STRING COMMENT 'Overall outcome of the rule execution: pass (within acceptable threshold), fail (exceeds threshold), warning (approaching threshold), error (execution failure).. Valid values are `pass|fail|warning|error`',
    `previous_failure_rate_percent` DECIMAL(18,2) COMMENT 'Failure rate from the previous execution of this rule against the same target product. Used for trend analysis and detecting quality degradation.',
    `records_evaluated_count` BIGINT COMMENT 'Total number of records in the target data product that were evaluated by this rule execution.',
    `records_failed_count` BIGINT COMMENT 'Number of records that failed the data quality rule criteria and did not meet the expected quality threshold.',
    `records_passed_count` BIGINT COMMENT 'Number of records that passed the data quality rule criteria.',
    `remediation_action` STRING COMMENT 'Action taken in response to the quality check result: none (no action required), alert_sent (notification to data steward), ticket_created (incident logged), auto_corrected (automated fix applied), quarantined (records isolated), rejected (records blocked from downstream).. Valid values are `none|alert_sent|ticket_created|auto_corrected|quarantined|rejected`',
    `remediation_owner` STRING COMMENT 'Name or identifier of the data steward, team, or system responsible for addressing the quality issues identified by this rule execution.',
    `rule_name` STRING COMMENT 'Human-readable name of the data quality rule that was executed (e.g., Customer Email Format Validation, Order Amount Range Check).',
    `rule_type` STRING COMMENT 'Category of data quality dimension being evaluated: completeness (null checks), accuracy (value correctness), consistency (cross-field logic), validity (format/range), uniqueness (duplicate detection), timeliness (freshness checks).. Valid values are `completeness|accuracy|consistency|validity|uniqueness|timeliness`',
    `sample_failed_keys` STRING COMMENT 'Comma-separated list of primary key values for a sample of records that failed the quality check. Used for root cause analysis and remediation. Limited to first 100 keys.',
    `schedule_type` STRING COMMENT 'How this rule execution was initiated: scheduled (regular cadence), on_demand (manual trigger), event_triggered (data arrival event), continuous (real-time monitoring).. Valid values are `scheduled|on_demand|event_triggered|continuous`',
    `severity_level` STRING COMMENT 'Business impact severity of quality failures detected by this rule: critical (blocks downstream processing), high (impacts key metrics), medium (degrades analytics), low (informational).. Valid values are `critical|high|medium|low`',
    `sla_compliance_flag` BOOLEAN COMMENT 'Indicates whether the data quality result meets the defined SLA threshold for this rule and target product. True if within SLA, False if SLA violated.',
    `target_attribute` STRING COMMENT 'The specific column/attribute within the target product that was evaluated. Null if the rule evaluates the entire record or multiple attributes.',
    `target_domain` STRING COMMENT 'The business domain of the data product being evaluated (e.g., customer, product, order, inventory). Aligns with enterprise data domain taxonomy.',
    `target_product` STRING COMMENT 'The specific data product (table/entity) that was evaluated by the DQ rule (e.g., customer.profile, order.header, inventory.stock_level).',
    `threshold_value` DECIMAL(18,2) COMMENT 'The acceptable failure rate threshold defined for this rule (e.g., 5.00 means up to 5% failure is acceptable). Used to determine pass/fail status.',
    `trend_direction` STRING COMMENT 'Trend of data quality compared to previous execution: improving (failure rate decreased), stable (no significant change), degrading (failure rate increased), new (first execution).. Valid values are `improving|stable|degrading|new`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this DQ result record was last modified. Used for audit trail and change tracking.',
    CONSTRAINT pk_dq_result PRIMARY KEY(`dq_result_id`)
) COMMENT 'Transactional record capturing the outcome of a data quality rule execution against a target data product. Stores rule execution timestamp, target domain, target product, records evaluated count, records failed count, failure rate, pass/fail status, sample failed record keys, and remediation action taken. Enables DQ trend monitoring, SLA compliance tracking, and data trust scoring across the retail lakehouse.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`dq_issue` (
    `dq_issue_id` BIGINT COMMENT 'Unique identifier for the data quality issue record. Primary key for tracking individual DQ incidents from detection through resolution.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Data quality issues often affect specific SKUs (incorrect weight causing shipping errors, missing allergen data blocking e-commerce). Issue tracking requires SKU identification for remediation workflo',
    `dq_result_id` BIGINT COMMENT 'Foreign key linking to analytics.dq_result. Business justification: A DQ issue is typically detected FROM a specific DQ result execution. This FK links the issue to the result that identified it, enabling traceability from issue back to the rule execution that detecte',
    `dq_rule_id` BIGINT COMMENT 'Identifier of the automated data quality rule that detected this issue, null if detected through manual methods. Links to rule metadata for traceability.',
    `inbound_shipment_id` BIGINT COMMENT 'Foreign key linking to supplychain.inbound_shipment. Business justification: Manages receiving discrepancy issues (quantity variances, damaged goods) through resolution workflow. Core to warehouse quality management and supplier chargeback processes.',
    `parent_dq_issue_id` BIGINT COMMENT 'Self-referencing FK on dq_issue (related_dq_issue_id)',
    `profile_id` BIGINT COMMENT 'Foreign key linking to customer.profile. Business justification: Data quality issues in customer master data (duplicate profiles, invalid contact info, address standardization failures) are tracked with reference to affected customer for remediation. Master data ma',
    `replenishment_order_id` BIGINT COMMENT 'Foreign key linking to inventory.replenishment_order. Business justification: Data quality issues in replenishment (MOQ violations, lead time anomalies, duplicate orders) require order-level tracking for supplier performance management and procurement process improvement.',
    `return_fraud_case_id` BIGINT COMMENT 'Foreign key linking to returns.return_fraud_case. Business justification: Fraud cases often surface data quality issues (duplicate profiles, address mismatches, inconsistent purchase history) that trigger DQ investigations. Real-world fraud teams escalate data anomalies to',
    `stock_position_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_position. Business justification: DQ issues flagging specific inventory positions (ATP errors, valuation anomalies, dead stock) require direct position reference for data steward remediation workflows and root cause analysis.',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Tracks and manages data quality issues in procurement data (missing costs, invalid dates) with remediation workflow. Required for procurement data stewardship and audit compliance.',
    `affected_attribute` STRING COMMENT 'The specific column or attribute within the data product that exhibits the quality issue, null if issue affects entire product.',
    `affected_record_count` BIGINT COMMENT 'Number of data records impacted by this quality issue, providing quantitative measure of issue scope and remediation effort.',
    `assigned_timestamp` TIMESTAMP COMMENT 'Date and time when the issue was assigned to a remediation owner, used for response time SLA measurement.',
    `assigned_to` STRING COMMENT 'User ID or team name responsible for investigating and remediating this data quality issue, enabling workload tracking and escalation.',
    `business_impact` STRING COMMENT 'Narrative assessment of business consequences including affected processes, downstream systems, reporting accuracy, compliance risk, and operational disruption.',
    `closed_by` STRING COMMENT 'User ID of the person who verified resolution and closed the issue, typically a data steward or quality manager.',
    `closed_timestamp` TIMESTAMP COMMENT 'Date and time when the issue was formally closed after verification and stakeholder approval, marking end of issue lifecycle.',
    `compliance_framework` STRING COMMENT 'Specific regulatory framework or standard affected by this issue (e.g., GDPR, CCPA, PCI DSS, FDA 21 CFR Part 11, SOX), null if no compliance impact.',
    `compliance_impact_flag` BOOLEAN COMMENT 'Boolean indicator whether this data quality issue affects regulatory reporting or compliance obligations (FTC, FDA, PCI DSS, GDPR, CCPA), requiring escalation and audit trail.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this DQ issue record was first created in the system, supporting audit trail and issue aging analysis.',
    `data_lineage_path` STRING COMMENT 'Comma-separated list of systems and transformations the data passed through from source to the point where the issue was detected, enabling impact analysis.',
    `data_product` STRING COMMENT 'The specific data product or table where the quality issue was detected, enabling precise impact assessment and remediation targeting.',
    `dq_issue_description` STRING COMMENT 'Detailed narrative description of the data quality issue including symptoms observed, data elements affected, and business context.',
    `detected_by` STRING COMMENT 'User ID or system name that detected the issue, supporting accountability and detection pattern analysis.',
    `detected_timestamp` TIMESTAMP COMMENT 'Date and time when the data quality issue was first detected by automated monitoring or manual review. Critical for SLA tracking.',
    `detection_method` STRING COMMENT 'How the issue was discovered: automated_rule (DQ rule engine), manual_review (data steward inspection), user_report (business user complaint), reconciliation (cross-system comparison), audit (compliance review), monitoring_alert (observability platform).. Valid values are `automated_rule|manual_review|user_report|reconciliation|audit|monitoring_alert`',
    `domain` STRING COMMENT 'The business data domain where the quality issue was identified, aligning with enterprise data domain taxonomy. [ENUM-REF-CANDIDATE: customer|product|inventory|order|store|supply_chain|pricing|promotion|workforce|supplier|finance|loyalty|ecommerce|distribution|merchandising|analytics — 16 candidates stripped; promote to reference product]',
    `dq_issue_status` STRING COMMENT 'Current lifecycle status of the data quality issue: open (newly detected), in_progress (under investigation or remediation), resolved (fix implemented), closed (verified and closed), accepted (acknowledged as acceptable risk), rejected (false positive).. Valid values are `open|in_progress|resolved|closed|accepted|rejected`',
    `issue_number` STRING COMMENT 'Human-readable business identifier for the data quality issue, typically formatted as DQ-NNNNNN for external reference and communication.. Valid values are `^DQ-[0-9]{6,10}$`',
    `issue_type` STRING COMMENT 'Classification of the data quality issue according to standard DQ dimensions: completeness (missing values), accuracy (incorrect values), consistency (contradictory values), validity (format violations), timeliness (stale data), uniqueness (duplicates).. Valid values are `completeness|accuracy|consistency|validity|timeliness|uniqueness`',
    `prevention_action` STRING COMMENT 'Description of preventive measures implemented to avoid recurrence including process changes, rule enhancements, training, or system improvements.',
    `priority` STRING COMMENT 'Remediation priority level determining resolution urgency: P1 (immediate), P2 (urgent), P3 (normal), P4 (low). Combines severity and business criticality.. Valid values are `p1|p2|p3|p4`',
    `recurrence_flag` BOOLEAN COMMENT 'Boolean indicator whether this issue is a recurrence of a previously resolved issue, triggering deeper root cause analysis and process improvement.',
    `remediation_cost_estimate` DECIMAL(18,2) COMMENT 'Estimated cost in USD to remediate this issue including labor, system changes, and data correction effort, supporting prioritization and resource planning.',
    `resolution_description` STRING COMMENT 'Detailed explanation of the remediation actions taken including data corrections, process changes, rule updates, and preventive measures implemented.',
    `resolved_by` STRING COMMENT 'User ID of the person who completed the remediation and marked the issue as resolved, supporting accountability and performance tracking.',
    `resolved_timestamp` TIMESTAMP COMMENT 'Date and time when the issue was marked as resolved after remediation actions were completed and verified.',
    `root_cause_category` STRING COMMENT 'High-level classification of the underlying cause: source_system (upstream system issue), etl_process (transformation logic error), data_entry (manual input error), business_rule (validation rule gap), integration (interface issue), migration (data conversion problem), manual_override (unauthorized change), unknown (under investigation). [ENUM-REF-CANDIDATE: source_system|etl_process|data_entry|business_rule|integration|migration|manual_override|unknown — 8 candidates stripped; promote to reference product]',
    `root_cause_description` STRING COMMENT 'Detailed explanation of the identified root cause including technical details, system components involved, and causal chain analysis.',
    `severity` STRING COMMENT 'Business impact severity classification: critical (blocks operations or regulatory reporting), high (significant business impact), medium (moderate impact), low (minimal impact).. Valid values are `critical|high|medium|low`',
    `sla_due_timestamp` TIMESTAMP COMMENT 'Target date and time by which the issue must be resolved based on priority and severity SLA commitments. Null if no SLA applies.',
    `title` STRING COMMENT 'Brief descriptive title summarizing the data quality issue for quick identification and reporting dashboards.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this DQ issue record was last modified, tracking issue progression and activity recency.',
    `verification_notes` STRING COMMENT 'Notes documenting the verification process including tests performed, data samples reviewed, and stakeholder sign-off confirming issue resolution.',
    CONSTRAINT pk_dq_issue PRIMARY KEY(`dq_issue_id`)
) COMMENT 'Operational record tracking an identified data quality issue requiring investigation or remediation. Captures issue description, affected domain and product, root cause classification, business impact assessment, assigned remediation owner, priority level, issue status (open, in-progress, resolved, accepted), resolution notes, and SLA due date. Provides the operational workflow for managing data quality incidents from detection through closure.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` (
    `semantic_layer_entity_id` BIGINT COMMENT 'Unique identifier for the semantic layer entity record. Primary key.',
    `loyalty_program_id` BIGINT COMMENT 'Foreign key linking to loyalty.loyalty_program. Business justification: Semantic entities for loyalty reporting (member_summary, points_activity, tier_movement) are scoped to specific loyalty programs in multi-program retailers. Semantic layer needs program context for co',
    `parent_semantic_layer_entity_id` BIGINT COMMENT 'Self-referencing FK on semantic_layer_entity (parent_semantic_layer_entity_id)',
    `primary_replacement_semantic_layer_entity_id` BIGINT COMMENT 'Foreign key reference to the semantic layer entity that replaces this deprecated entity. Null for active entities or deprecated entities without a direct replacement.',
    `approval_required_flag` BOOLEAN COMMENT 'Boolean flag indicating whether access to this semantic entity requires explicit approval from a data steward or domain owner. True for sensitive or restricted entities.',
    `business_definition` STRING COMMENT 'Comprehensive business definition of what this semantic entity represents, written in business language. Explains the business meaning, usage context, and interpretation guidelines for business users consuming this entity in reports and dashboards.',
    `calculation_logic` STRING COMMENT 'Detailed description or pseudocode of the calculation logic used to derive this semantic entity, if applicable. For metrics and derived entities, documents the formula, aggregation method, filters, and business rules applied.',
    `certified_status` STRING COMMENT 'Certification status indicating the trustworthiness and approval level of this semantic entity. Certified = production-approved for enterprise reporting; Provisional = available but not yet fully validated; Deprecated = scheduled for retirement; Draft = under development.. Valid values are `certified|provisional|deprecated|draft`',
    `consumption_tier` STRING COMMENT 'Access tier defining who can consume this semantic entity. Self-service = available to all business users; Governed = requires approval or training; Restricted = limited to specific roles or compliance-cleared users.. Valid values are `self_service|governed|restricted`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this semantic entity record was first created in the metadata repository. Part of standard audit trail.',
    `data_quality_score` DECIMAL(18,2) COMMENT 'Composite data quality score for this semantic entity, expressed as a percentage (0.00 to 100.00). Aggregates completeness, accuracy, consistency, and timeliness metrics from underlying data quality rules.',
    `data_steward_email` STRING COMMENT 'Email address of the data steward for this semantic entity. Used for escalations, clarifications, and governance communications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `data_steward_name` STRING COMMENT 'Full name of the data steward responsible for the quality, definition, and governance of this semantic layer entity. Primary contact for business questions and data quality issues.',
    `deprecation_reason` STRING COMMENT 'Explanation of why this semantic entity was deprecated, if applicable. Includes migration guidance and references to replacement entities. Null for active entities.',
    `documentation_url` STRING COMMENT 'URL link to detailed documentation for this semantic entity, including usage examples, business context, calculation details, and FAQs. Typically points to Confluence, SharePoint, or internal wiki.',
    `domain` STRING COMMENT 'Business domain that owns and governs this semantic layer entity (e.g., Customer, Product, Inventory, Order, Store, Finance, Loyalty). Aligns with enterprise data domain taxonomy.',
    `effective_end_date` DATE COMMENT 'Date on which this semantic entity definition was deprecated or replaced. Null for currently active entities. Used to manage entity lifecycle and prevent usage of outdated definitions.',
    `effective_start_date` DATE COMMENT 'Date from which this semantic entity definition became active and available for consumption. Supports temporal validity and historical analysis of semantic layer changes.',
    `entity_label` STRING COMMENT 'Business-friendly display label for the semantic layer entity, used in reports and dashboards. Human-readable name that business users will recognize (e.g., Customer 360 View, Store Performance Metrics, Inventory Health).',
    `entity_name` STRING COMMENT 'Technical name of the semantic layer entity as defined in the BI tool or semantic layer platform (e.g., LookML model name, dbt semantic model name, Unity Catalog metric name). Must be unique within the semantic layer namespace.',
    `entity_type` STRING COMMENT 'Classification of the semantic layer entity type. Dimension = descriptive attribute for slicing/dicing; Measure = quantitative metric; Metric = calculated KPI; Fact = transactional event; Aggregate = pre-aggregated summary; Derived = computed from other entities.. Valid values are `dimension|measure|metric|fact|aggregate|derived`',
    `grain_definition` STRING COMMENT 'Textual description of the grain (level of detail) of this semantic entity. Defines what one row represents (e.g., One row per customer, One row per store per day, One row per SKU per transaction). Critical for correct join and aggregation logic.',
    `is_active` BOOLEAN COMMENT 'Boolean flag indicating whether this semantic entity is currently active and available for use. False indicates the entity has been soft-deleted or deactivated but retained for historical reference.',
    `is_financial_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this semantic entity contains financial data subject to SOX, FASB, or other financial reporting standards. True if entity includes revenue, cost, profit, or other P&L components.',
    `is_pii_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this semantic entity contains or exposes PII data. True if any underlying attributes include customer names, emails, phone numbers, addresses, or other personal identifiers. Used for access control and compliance reporting.',
    `last_modified_by` STRING COMMENT 'Username or email of the person who last modified this semantic entity definition. Used for change tracking and accountability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this semantic entity record. Part of standard audit trail for change tracking.',
    `last_refresh_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent data refresh for the underlying table that feeds this semantic entity. Used to communicate data freshness to end users.',
    `platform_object_code` STRING COMMENT 'Native identifier or URI of this entity within the semantic layer platform (e.g., Looker explore ID, dbt model unique_id, Unity Catalog full path). Used for deep linking and platform-specific integrations.',
    `platform_type` STRING COMMENT 'The BI or semantic layer platform where this entity is defined and exposed (e.g., Looker LookML, dbt Semantic Layer, Databricks Unity Catalog, Tableau Data Model). [ENUM-REF-CANDIDATE: looker|dbt|tableau|power_bi|databricks_unity_catalog|thoughtspot|other — 7 candidates stripped; promote to reference product]',
    `refresh_frequency` STRING COMMENT 'Frequency at which the underlying data for this semantic entity is refreshed. Indicates data freshness and latency expectations for business users.. Valid values are `real_time|hourly|daily|weekly|monthly|on_demand`',
    `related_kpi_definitions` STRING COMMENT 'Comma-separated list of KPI definition IDs or names that reference or depend on this semantic entity. Establishes lineage between semantic entities and enterprise KPIs.',
    `sample_query` STRING COMMENT 'Example SQL or platform-specific query demonstrating how to use this semantic entity. Helps business users understand proper usage patterns and join logic.',
    `tags` STRING COMMENT 'Comma-separated list of business tags or labels applied to this semantic entity for categorization, search, and discovery (e.g., revenue, customer_360, regulatory, executive_dashboard).',
    `underlying_table_reference` STRING COMMENT 'Fully qualified name of the underlying physical table or view in the lakehouse that this semantic entity is built upon (e.g., silver.customer.profile, gold.sales.daily_aggregates). References the source data product in the Silver or Gold layer.',
    `unique_user_count_last_30_days` STRING COMMENT 'Number of distinct users who accessed this semantic entity in the last 30 days. Measures adoption breadth across the organization.',
    `usage_count_last_30_days` STRING COMMENT 'Number of times this semantic entity was queried or used in reports/dashboards in the last 30 days. Indicates popularity and business value of the entity.',
    `version` STRING COMMENT 'Version identifier for this semantic entity definition. Incremented when calculation logic, grain, or structure changes. Supports change tracking and backward compatibility.',
    `created_by` STRING COMMENT 'Username or email of the person who created this semantic entity definition. Used for accountability and contact tracing.',
    CONSTRAINT pk_semantic_layer_entity PRIMARY KEY(`semantic_layer_entity_id`)
) COMMENT 'Master record defining a logical business entity exposed through the retail semantic layer (e.g., Looker LookML model, dbt semantic model, Databricks Unity Catalog metric). Captures entity name, business-friendly label, underlying physical table reference, domain ownership, grain definition, certified status, steward contact, and consumption tier (self-service, governed, restricted). Bridges raw Silver Layer data products to business-consumable analytics objects.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` (
    `semantic_metric_id` BIGINT COMMENT 'Unique identifier for the semantic metric definition within the retail semantic layer.',
    `derived_from_semantic_metric_id` BIGINT COMMENT 'Self-referencing FK on semantic_metric (derived_from_semantic_metric_id)',
    `financial_period_id` BIGINT COMMENT 'Foreign key linking to finance.financial_period. Business justification: Metric definitions often specify fiscal period grain for time-series analysis, YoY comparisons, and period-to-date calculations. Standardizes temporal semantics across reporting.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Financial metrics must map to GL accounts for audit trail, reconciliation to source systems, and financial statement lineage. Enables metric to ledger traceability required by SOX controls.',
    `kpi_definition_id` BIGINT COMMENT 'Reference to the parent KPI definition that this semantic metric supports or measures.',
    `price_strategy_id` BIGINT COMMENT 'Foreign key linking to pricing.price_strategy. Business justification: Pricing strategy effectiveness metrics (EDLP vs Hi-Lo performance, strategy ROI, competitive index achievement) must reference the strategy being measured. Enables strategy performance reporting. Real',
    `aggregation_method` STRING COMMENT 'The default time-series aggregation behavior for the metric when rolled up across time periods (e.g., sum for revenue, average for margin percent, last_value for inventory balance). [ENUM-REF-CANDIDATE: sum|average|count|min|max|median|last_value|first_value|distinct_count — 9 candidates stripped; promote to reference product]',
    `alert_threshold_lower` DECIMAL(18,2) COMMENT 'Lower boundary value that triggers an automated alert or exception notification when the metric falls below this threshold, indicating potential business issue or opportunity.',
    `alert_threshold_upper` DECIMAL(18,2) COMMENT 'Upper boundary value that triggers an automated alert or exception notification when the metric exceeds this threshold, indicating potential business issue or opportunity.',
    `base_measure` STRING COMMENT 'The foundational data element or fact table measure that serves as the primary input to the metric calculation (e.g., sales_amount, inventory_units, transaction_count).',
    `benchmark_available_flag` BOOLEAN COMMENT 'Indicates whether external industry benchmark data is available for this metric to enable competitive performance comparison (True) or not (False).',
    `benchmark_source` STRING COMMENT 'Name of the external data provider or industry association that publishes benchmark values for this metric (e.g., NRF, Nielsen, Gartner). Null if no benchmark available.',
    `business_definition` STRING COMMENT 'Plain-language business definition of what the metric measures, its purpose, and how it should be interpreted by business users.',
    `business_owner` STRING COMMENT 'Name or identifier of the business function leader or department responsible for defining the business logic and interpretation of this metric (e.g., VP Merchandising, Director Finance).',
    `calculation_expression` STRING COMMENT 'The technical calculation logic expressed in SQL, dbt metric syntax, or semantic layer DSL that defines how the metric is computed from base measures.',
    `calculation_layer` STRING COMMENT 'The lakehouse medallion layer at which this metric is calculated: bronze (raw), silver (cleansed), gold (aggregated), semantic (business logic applied).. Valid values are `bronze|silver|gold|semantic`',
    `certification_status` STRING COMMENT 'Governance status indicating whether the metric definition has been reviewed and approved for enterprise use: draft (in development), under_review (pending approval), certified (production-ready), deprecated (no longer recommended).. Valid values are `draft|under_review|certified|deprecated`',
    `certified_by` STRING COMMENT 'Name or identifier of the data steward, business owner, or governance committee member who certified this metric definition for production use.',
    `certified_timestamp` TIMESTAMP COMMENT 'Date and time when the metric definition was officially certified and approved for enterprise reporting and analytics.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this semantic metric definition record was first created in the metadata repository.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for monetary metrics (e.g., USD, EUR, GBP). Null for non-monetary metrics.. Valid values are `^[A-Z]{3}$`',
    `dashboard_count` STRING COMMENT 'Number of active BI dashboards and reports that currently consume this metric, used to assess impact of definition changes.',
    `data_quality_rule` STRING COMMENT 'Description of data quality checks and validation rules applied to the metric calculation to ensure accuracy and reliability (e.g., null checks, range validation, reconciliation to source).',
    `data_source_table` STRING COMMENT 'The primary fact table or data product in the lakehouse silver layer from which the base measure is sourced (e.g., sales_transaction, inventory_snapshot, order_line).',
    `decimal_precision` STRING COMMENT 'Number of decimal places to display for the metric value in reports and dashboards (e.g., 2 for currency, 1 for percentages, 0 for counts).',
    `dimension_list` STRING COMMENT 'Comma-separated list of dimension attributes by which this metric can be sliced and analyzed (e.g., store, product_category, customer_segment, channel).',
    `documentation_url` STRING COMMENT 'Web link to detailed documentation, business glossary entry, or wiki page that provides extended definition, calculation examples, and usage guidance for this metric.',
    `effective_end_date` DATE COMMENT 'The date after which this version of the metric definition is no longer valid and has been superseded by a newer version. Null for the current active version.',
    `effective_start_date` DATE COMMENT 'The date from which this version of the metric definition is valid and should be used for calculations and reporting.',
    `filter_expression` STRING COMMENT 'SQL WHERE clause or semantic layer filter logic that defines the scope of data included in the metric calculation (e.g., exclude returns, include only completed transactions).',
    `is_active` BOOLEAN COMMENT 'Indicates whether this metric definition is currently active and available for use in reports and dashboards (True) or has been deactivated/archived (False).',
    `last_refresh_timestamp` TIMESTAMP COMMENT 'Date and time when the metric calculation was last executed and the semantic layer metadata was updated, used to assess data freshness.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this semantic metric definition record was most recently modified, including changes to calculation logic, filters, or metadata.',
    `metric_code` STRING COMMENT 'Short alphanumeric code or abbreviation used to reference the metric in technical systems and data models (e.g., GM_PCT, STR, GMROI, ATV).',
    `metric_name` STRING COMMENT 'The canonical business name of the metric as it appears in BI tools and reports (e.g., Gross Margin Percent, Sell-Through Rate, GMROI, Average Transaction Value).',
    `metric_type` STRING COMMENT 'Classification of the metric calculation pattern: simple (direct measure), ratio (numerator/denominator), derived (formula from multiple measures), cumulative (running total), compound (nested calculations).. Valid values are `simple|ratio|derived|cumulative|compound`',
    `refresh_frequency` STRING COMMENT 'How often the metric calculation is refreshed and updated in the semantic layer and downstream BI tools (e.g., real_time for POS metrics, daily for inventory, monthly for financial close).. Valid values are `real_time|hourly|daily|weekly|monthly`',
    `tags` STRING COMMENT 'Comma-separated list of searchable keywords and category labels used to organize and discover metrics in the BI catalog (e.g., financial, operational, customer, inventory, sales).',
    `technical_owner` STRING COMMENT 'Name or identifier of the data engineer, analytics engineer, or BI developer responsible for implementing and maintaining the metric calculation logic.',
    `time_grain` STRING COMMENT 'The default or minimum time granularity at which this metric is calculated and reported (e.g., daily sales, weekly inventory turns, monthly comp sales).. Valid values are `daily|weekly|monthly|quarterly|yearly`',
    `trend_direction_indicator` STRING COMMENT 'Defines the desired direction of metric movement for positive business performance: higher_is_better (e.g., sales, margin), lower_is_better (e.g., shrinkage, cost), target_is_optimal (e.g., inventory weeks of supply).. Valid values are `higher_is_better|lower_is_better|target_is_optimal`',
    `unit_of_measure` STRING COMMENT 'The unit in which the metric value is expressed (e.g., USD, percent, units, days, ratio, index) to ensure correct interpretation and display formatting.',
    `usage_frequency` STRING COMMENT 'Classification of how often this metric is consumed in reports and dashboards: high (daily/weekly executive dashboards), medium (monthly business reviews), low (ad-hoc analysis only).. Valid values are `high|medium|low`',
    `version_number` STRING COMMENT 'Semantic version identifier for the metric definition (e.g., 1.0.0, 2.1.3) to track changes in calculation logic, filters, or business rules over time.',
    CONSTRAINT pk_semantic_metric PRIMARY KEY(`semantic_metric_id`)
) COMMENT 'Master record for a certified business metric defined within the retail semantic layer. Captures metric name, business definition, calculation expression (SQL or dbt metric syntax), base measure, filters applied, time aggregation behavior (sum, average, last value), associated dimensions, owning KPI definition, certification status, and version history. Provides the single authoritative definition of each retail metric (e.g., Gross Margin %, Sell-Through Rate, GMROI, Basket Size) consumed by BI tools.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`report_subscription` (
    `report_subscription_id` BIGINT COMMENT 'Unique identifier for the report subscription record. Primary key.',
    `access_policy_id` BIGINT COMMENT 'Foreign key linking to analytics.analytics_access_policy. Business justification: Report subscriptions are subject to access policies that determine who can subscribe to specific reports. This FK links the subscription to the governing access policy, enabling enforcement of subscri',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Users subscribe to campaign-specific performance reports (daily campaign dashboards, weekly performance summaries). Retail marketing teams need automated campaign reporting; this link enables campaign',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Compliance stakeholders subscribe to recurring compliance reports (monthly audit summaries, quarterly training completion, annual regulatory filings). Link enables compliance-specific distribution lis',
    `dashboard_config_id` BIGINT COMMENT 'Foreign key linking to analytics.dashboard_config. Business justification: Users can subscribe to dashboard refreshes in addition to report deliveries. This enables dashboard-based subscriptions where users receive updated dashboard snapshots on a schedule. The FK is optiona',
    `demand_forecast_id` BIGINT COMMENT 'Foreign key linking to supplychain.demand_forecast. Business justification: Distributes forecast reports to planning teams on scheduled basis. Essential for S&OP processes, forecast review meetings, and collaborative planning with merchandising.',
    `financial_period_id` BIGINT COMMENT 'Foreign key linking to finance.financial_period. Business justification: Scheduled financial reports are delivered per fiscal period (monthly close packs, quarterly board decks). Subscription triggers align to period close dates for timely stakeholder distribution.',
    `inventory_node_id` BIGINT COMMENT 'Foreign key linking to inventory.inventory_node. Business justification: Scheduled inventory reports (daily stock status, weekly replenishment summary, cycle count results) are scoped to specific nodes. Report distribution and filtering require node context for operational',
    `org_unit_id` BIGINT COMMENT 'Reference to the team or group that subscribed to this report or dashboard. Nullable if subscription is individual.',
    `associate_id` BIGINT COMMENT 'Reference to the individual user who subscribed to this report or dashboard.',
    `profile_id` BIGINT COMMENT 'Foreign key linking to customer.profile. Business justification: B2B customers and corporate account holders subscribe to custom reports (spend analysis, order history, compliance reports). Retail B2B self-service portals deliver scheduled reports to customer conta',
    `report_definition_id` BIGINT COMMENT 'Reference to the report or dashboard definition that is being subscribed to.',
    `superseded_report_subscription_id` BIGINT COMMENT 'Self-referencing FK on report_subscription (superseded_report_subscription_id)',
    `tertiary_report_last_modified_by_user_associate_id` BIGINT COMMENT 'Reference to the user who most recently modified this subscription record.',
    `attachment_filename_pattern` STRING COMMENT 'Template or pattern for naming the report file attachment, supporting dynamic variables like date, report name, and subscriber name.',
    `cancellation_reason` STRING COMMENT 'User-provided or system-generated reason for why the subscription was cancelled, used for analytics and improvement.',
    `cancellation_timestamp` TIMESTAMP COMMENT 'Timestamp when the subscription was cancelled by the user or system.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this subscription record was first created in the system.',
    `data_refresh_required_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the underlying data should be refreshed before each delivery or if cached data is acceptable.',
    `delivery_channel` STRING COMMENT 'The channel through which the report or dashboard will be delivered to the subscriber.. Valid values are `email|slack|teams|in_app|sftp|webhook`',
    `delivery_count` STRING COMMENT 'Total number of times the report or dashboard has been successfully delivered to the subscriber since subscription creation.',
    `delivery_email_address` STRING COMMENT 'Email address to which the report will be delivered if delivery channel is email. May differ from subscriber user email.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `delivery_message_body` STRING COMMENT 'Body text or description included in the delivery message to provide context or instructions to the subscriber.',
    `delivery_message_subject` STRING COMMENT 'Subject line or title for the delivery message when the report is sent via email or messaging channel.',
    `delivery_schedule_expression` STRING COMMENT 'Cron expression or named cadence value defining when the report should be delivered (e.g., 0 8 * * MON for weekly Monday 8am, or daily, weekly, monthly).',
    `delivery_schedule_type` STRING COMMENT 'Type of scheduling mechanism used for report delivery: cron expression, named cadence, on-demand, or event-triggered.. Valid values are `cron|named_cadence|on_demand|event_triggered`',
    `delivery_timezone` STRING COMMENT 'Timezone in which the delivery schedule should be interpreted (e.g., America/New_York, UTC). IANA timezone identifier.',
    `failed_delivery_count` STRING COMMENT 'Total number of failed delivery attempts for this subscription due to errors or unavailability.',
    `filter_parameters_json` STRING COMMENT 'JSON-encoded string containing the filter parameters applied to the report or dashboard for this subscription (e.g., store region, date range, product category).',
    `include_empty_results_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the report should be delivered even when the result set is empty or contains no data.',
    `is_shared_subscription` BOOLEAN COMMENT 'Boolean flag indicating whether this subscription is shared with multiple users or teams versus being a personal subscription.',
    `last_delivery_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent successful delivery of the report or dashboard to the subscriber.',
    `last_failure_reason` STRING COMMENT 'Description or error message from the most recent failed delivery attempt, used for troubleshooting and support.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this subscription record was most recently updated or modified.',
    `max_delivery_attempts` STRING COMMENT 'Maximum number of retry attempts allowed for failed deliveries before the subscription is automatically paused or cancelled.',
    `next_scheduled_delivery_timestamp` TIMESTAMP COMMENT 'Timestamp when the next report delivery is scheduled to occur based on the delivery schedule.',
    `notes` STRING COMMENT 'Free-form text field for additional notes, comments, or context about this subscription provided by the user or administrator.',
    `notification_on_failure_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the subscriber should be notified when a delivery attempt fails.',
    `output_format` STRING COMMENT 'File format in which the report or dashboard will be rendered and delivered to the subscriber.. Valid values are `pdf|excel|csv|html|powerpoint|json`',
    `priority_level` STRING COMMENT 'Priority level assigned to this subscription for delivery queue management and resource allocation.. Valid values are `low|normal|high|urgent`',
    `subscription_end_date` DATE COMMENT 'Date when the subscription expires and report deliveries should cease. Nullable for open-ended subscriptions.',
    `subscription_name` STRING COMMENT 'User-defined name or label for this subscription to help identify it among multiple subscriptions.',
    `subscription_start_date` DATE COMMENT 'Date when the subscription becomes active and report deliveries should begin.',
    `subscription_status` STRING COMMENT 'Current lifecycle status of the subscription indicating whether it is actively delivering reports or has been paused, cancelled, or expired.. Valid values are `active|paused|cancelled|expired|pending`',
    CONSTRAINT pk_report_subscription PRIMARY KEY(`report_subscription_id`)
) COMMENT 'Transactional record capturing a business users or teams subscription to a scheduled report or dashboard. Stores subscriber identity reference, report or dashboard reference, delivery channel (email, Slack, Teams, in-app), delivery schedule (cron expression or named cadence), output format, filter parameters applied, subscription status, and last delivery timestamp. Enables governed self-service report distribution across retail business units.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`access_policy` (
    `access_policy_id` BIGINT COMMENT 'Unique identifier for the analytics access policy record. Primary key.',
    `associate_id` BIGINT COMMENT 'Individual user identifier for user-specific policy assignments. Used for exceptions and personalized access grants.',
    `parent_access_policy_id` BIGINT COMMENT 'Self-referencing FK on access_policy (parent_access_policy_id)',
    `access_level` STRING COMMENT 'Permission level granted by this policy: view (read-only), export (download capability), edit (modify), admin (full control), or deny (explicit block).. Valid values are `view|export|edit|admin|deny`',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether this policy requires explicit approval workflow before activation. True for high-risk or sensitive data access policies.',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when this policy was approved. Part of the governance audit trail.',
    `approved_by` STRING COMMENT 'User identifier of the data steward or governance officer who approved this policy. Required for audit trail and compliance reporting.',
    `assigned_group` STRING COMMENT 'User group identifier to which this policy is assigned. Enables group-based access management for analytics assets.',
    `assigned_role` STRING COMMENT 'Role identifier to which this policy is assigned. Supports role-based access control (RBAC) for analytics consumption.',
    `business_justification` STRING COMMENT 'Business rationale for granting or restricting access. Documents the business case, regulatory requirement, or operational need driving this policy.',
    `compliance_framework` STRING COMMENT 'Regulatory or compliance framework this policy supports (e.g., GDPR, CCPA, SOX, PCI-DSS, HIPAA). Enables compliance reporting and audit readiness.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this policy record was first created in the system. Supports audit trail and policy lifecycle tracking.',
    `data_classification_constraint` STRING COMMENT 'Data classification level constraint enforced by this policy. Restricts access based on data sensitivity: restricted (PII/PHI/PCI), confidential (business-sensitive), internal (employee-only), public (unrestricted).. Valid values are `restricted|confidential|internal|public`',
    `department_scope_restriction` STRING COMMENT 'Comma-separated list of department codes to which this policy restricts data visibility. Enables departmental data segmentation (e.g., merchandising, finance, supply chain).',
    `effective_end_date` DATE COMMENT 'Date when this access policy expires and is no longer enforced. Null indicates indefinite policy duration.',
    `effective_start_date` DATE COMMENT 'Date when this access policy becomes active and enforceable. Supports time-bound access grants for temporary projects or seasonal roles.',
    `enforcement_mode` STRING COMMENT 'Policy enforcement behavior: enforce (block unauthorized access), audit (log violations but allow access), warn (notify user but allow access). Supports phased rollout and testing.. Valid values are `enforce|audit|warn`',
    `filter_expression` STRING COMMENT 'SQL WHERE clause or filter predicate applied for row-level security. Dynamically filters data based on user context, role, or attribute values.',
    `is_active` BOOLEAN COMMENT 'Indicates whether this policy is currently active and being enforced. False indicates the policy is disabled or archived.',
    `last_access_review_date` DATE COMMENT 'Date when this policy was last reviewed for continued appropriateness and accuracy. Supports periodic access recertification processes.',
    `last_modified_by` STRING COMMENT 'User identifier of the person who last modified this policy record. Tracks accountability for policy changes.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this policy record was last updated. Supports change tracking and audit compliance.',
    `masking_rule` STRING COMMENT 'Data masking technique applied for column-level security: none (no masking), full_mask (complete obfuscation), partial_mask (show last 4 digits), hash (one-way hash), tokenize (reversible token), redact (replace with placeholder), null (return null). [ENUM-REF-CANDIDATE: none|full_mask|partial_mask|hash|tokenize|redact|null — 7 candidates stripped; promote to reference product]',
    `next_review_due_date` DATE COMMENT 'Scheduled date for the next mandatory policy review. Ensures policies remain current and aligned with business needs and regulatory requirements.',
    `policy_code` STRING COMMENT 'Unique business identifier code for the access policy, used for system integration and reference.. Valid values are `^[A-Z0-9_-]{3,20}$`',
    `policy_description` STRING COMMENT 'Detailed business justification and purpose of this access policy. Explains why the policy exists and what business need it serves.',
    `policy_name` STRING COMMENT 'Human-readable name of the access policy for identification and management purposes.',
    `policy_status` STRING COMMENT 'Current lifecycle state of the access policy: draft (under review), active (enforced), suspended (temporarily disabled), expired (past end date), revoked (permanently cancelled).. Valid values are `draft|active|suspended|expired|revoked`',
    `policy_type` STRING COMMENT 'Classification of the access control mechanism: row-level (filters rows), column-level (masks columns), object-level (entire object access), attribute-level (specific field access), cell-level (individual cell masking), or dynamic (context-based).. Valid values are `row_level|column_level|object_level|attribute_level|cell_level|dynamic`',
    `priority_rank` STRING COMMENT 'Numeric priority for policy evaluation when multiple policies apply to the same user and object. Lower numbers indicate higher priority. Used for conflict resolution.',
    `region_scope_restriction` STRING COMMENT 'Comma-separated list of region codes or geographic identifiers to which this policy restricts data visibility. Supports regional business unit data isolation.',
    `risk_level` STRING COMMENT 'Risk classification of the data or analytics asset governed by this policy. Drives approval workflows and monitoring intensity.. Valid values are `low|medium|high|critical`',
    `store_scope_restriction` STRING COMMENT 'Comma-separated list of store identifiers or store codes to which this policy restricts data visibility. Enables store-level data segmentation for regional managers and store operations.',
    `target_object_name` STRING COMMENT 'Fully qualified name or identifier of the specific analytics object (dashboard, report, metric, data product) governed by this policy.',
    `target_object_type` STRING COMMENT 'Type of analytics object this policy governs: dashboard, report, semantic metric, data product, dataset, view, or table. [ENUM-REF-CANDIDATE: dashboard|report|semantic_metric|data_product|dataset|view|table — 7 candidates stripped; promote to reference product]',
    `target_schema_name` STRING COMMENT 'Database schema or catalog namespace where the target object resides, supporting multi-tenant and domain-segregated analytics environments.',
    `created_by` STRING COMMENT 'User identifier of the person who created this policy record. Part of the audit trail for governance and compliance.',
    CONSTRAINT pk_access_policy PRIMARY KEY(`access_policy_id`)
) COMMENT 'Master record defining row-level, column-level, and object-level access policies governing who can consume which analytics products, dashboards, and semantic layer entities. Captures policy name, target object type (dashboard, report, semantic metric, data product), access level (view, export, edit), assigned role or group, data classification constraint, store/region scope restriction, and effective date range. Enforces data governance and privacy controls on analytics consumption.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` (
    `retail_calendar_id` BIGINT COMMENT 'Unique identifier for each calendar date record in the retail fiscal calendar. Primary key for the retail calendar dimension.',
    `financial_period_id` BIGINT COMMENT 'add column financial_period_id (BIGINT) with FK to finance.financial_period.financial_period_id - retail calendar weeks/periods must map to financial periods (4-5-4 calendar alignment) for financial reporting',
    `prior_year_retail_calendar_id` BIGINT COMMENT 'Self-referencing FK on retail_calendar (prior_year_retail_calendar_id)',
    `calendar_date` DATE COMMENT 'The Gregorian calendar date represented by this record. Serves as the natural business key for date-based joins and filtering.',
    `calendar_day_of_month` STRING COMMENT 'The day of the month in the Gregorian calendar (1-31). Used for day-of-month pattern analysis and billing cycle alignment.',
    `calendar_day_of_year` STRING COMMENT 'The day number within the Gregorian calendar year (1-365 or 1-366). Supports calendar year-to-date calculations.',
    `calendar_month` STRING COMMENT 'The Gregorian calendar month number (1-12). Enables calendar-month aggregations and seasonality analysis.',
    `calendar_quarter` STRING COMMENT 'The Gregorian calendar quarter (1-4). Supports calendar-based quarterly analysis and external benchmarking.',
    `calendar_year` STRING COMMENT 'The Gregorian calendar year (YYYY). Used for calendar-year reporting and external regulatory filings.',
    `comparable_date_prior_year` DATE COMMENT 'The corresponding date in the prior fiscal year for year-over-year comparable sales (comp sales) analysis. Accounts for fiscal calendar shifts.',
    `comparable_week_prior_year` STRING COMMENT 'The fiscal week number in the prior year that corresponds to this date for week-over-week year-over-year analysis.',
    `day_abbreviation` STRING COMMENT 'The three-letter abbreviation for the day of the week. Used for compact display in dashboards and reports. [ENUM-REF-CANDIDATE: Mon|Tue|Wed|Thu|Fri|Sat|Sun — 7 candidates stripped; promote to reference product]',
    `day_name` STRING COMMENT 'The full name of the day of the week. Provides human-readable day identification for reporting and visualization. [ENUM-REF-CANDIDATE: Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday — 7 candidates stripped; promote to reference product]',
    `fiscal_day_of_period` STRING COMMENT 'The day number within the current fiscal period. Supports daily sales tracking and period-to-date performance analysis.',
    `fiscal_day_of_week` STRING COMMENT 'The day number within the fiscal week (1-7). Used for day-of-week sales pattern analysis and staffing optimization.',
    `fiscal_day_of_year` STRING COMMENT 'The day number within the fiscal year (1-364 or 1-371). Enables year-to-date calculations and trend analysis.',
    `fiscal_period` STRING COMMENT 'The fiscal period (month) number within the fiscal year (1-12). Aligns with monthly financial close and reporting cycles.',
    `fiscal_period_end_date` DATE COMMENT 'The end date of the fiscal period (month) to which this date belongs. Supports monthly close processes and period-end reporting.',
    `fiscal_period_start_date` DATE COMMENT 'The start date of the fiscal period (month) to which this date belongs. Enables period boundary identification and period-to-date calculations.',
    `fiscal_quarter` STRING COMMENT 'The fiscal quarter number within the fiscal year (1-4). Used for quarterly financial reporting and planning cycles.',
    `fiscal_week` STRING COMMENT 'The fiscal week number within the fiscal year (1-52 or 1-53). Follows the retail 4-5-4 or 4-4-5 week structure for consistent period comparisons.',
    `fiscal_week_end_date` DATE COMMENT 'The end date of the fiscal week to which this date belongs. Supports weekly reporting cycles and week-end inventory snapshots.',
    `fiscal_week_of_period` STRING COMMENT 'The week number within the current fiscal period (1-4 or 1-5). Enables week-level analysis within monthly periods following 4-5-4 structure.',
    `fiscal_week_start_date` DATE COMMENT 'The start date of the fiscal week to which this date belongs. Enables week boundary identification and week-to-date calculations.',
    `fiscal_year` STRING COMMENT 'The retail fiscal year to which this date belongs. Fiscal year may differ from calendar year based on company fiscal calendar definition.',
    `fiscal_year_end_date` DATE COMMENT 'The end date of the fiscal year to which this date belongs. Supports fiscal year-end reporting and planning cycles.',
    `fiscal_year_start_date` DATE COMMENT 'The start date of the fiscal year to which this date belongs. Enables fiscal year boundary identification and year-to-date calculations.',
    `holiday_name` STRING COMMENT 'The name of the holiday if the date is a recognized retail holiday. Null for non-holiday dates. Enables holiday-specific performance tracking.',
    `is_53_week_year` BOOLEAN COMMENT 'Boolean flag indicating whether the fiscal year contains 53 weeks instead of the standard 52. Occurs approximately every 5-6 years in 4-5-4 calendars.',
    `is_back_to_school_period` BOOLEAN COMMENT 'Boolean flag indicating whether the date falls within the back-to-school shopping period. Drives seasonal merchandising and promotional planning.',
    `is_black_friday_week` BOOLEAN COMMENT 'Boolean flag indicating whether the date falls within the Black Friday promotional week. Critical for peak season planning and analysis.',
    `is_current_date` BOOLEAN COMMENT 'Boolean flag indicating whether this record represents todays date. Updated daily to support current-date filtering in reports.',
    `is_cyber_monday_week` BOOLEAN COMMENT 'Boolean flag indicating whether the date falls within the Cyber Monday promotional week. Supports digital commerce peak event analysis.',
    `is_holiday` BOOLEAN COMMENT 'Boolean flag indicating whether the date is a recognized retail holiday. Supports holiday sales analysis and staffing planning.',
    `is_holiday_shopping_period` BOOLEAN COMMENT 'Boolean flag indicating whether the date falls within the November-December holiday shopping season. Critical for peak season resource planning.',
    `is_leap_year` BOOLEAN COMMENT 'Boolean flag indicating whether the calendar year is a leap year (366 days). Used for year-over-year normalization in analytics.',
    `is_weekday` BOOLEAN COMMENT 'Boolean flag indicating whether the date falls on a weekday (Monday through Friday). Used for weekday traffic and sales pattern analysis.',
    `is_weekend` BOOLEAN COMMENT 'Boolean flag indicating whether the date falls on a weekend (Saturday or Sunday). Used for weekend vs weekday sales analysis.',
    `iso_week` STRING COMMENT 'The ISO 8601 week number (1-53). Provides standardized week numbering for international reporting and cross-industry comparisons.',
    `iso_year` STRING COMMENT 'The ISO 8601 week-numbering year. May differ from Gregorian year for dates in the first or last week of the year.',
    `month_abbreviation` STRING COMMENT 'The three-letter abbreviation for the calendar month. Used for compact display in dashboards and reports. [ENUM-REF-CANDIDATE: Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec — promote to reference product]',
    `month_name` STRING COMMENT 'The full name of the calendar month. Provides human-readable month identification for reporting. [ENUM-REF-CANDIDATE: January|February|March|April|May|June|July|August|September|October|November|December — promote to reference product]',
    `season` STRING COMMENT 'The retail merchandising season designation (Spring/Summer, Fall/Winter). Drives seasonal assortment planning and promotional strategies.. Valid values are `Spring|Summer|Fall|Winter`',
    CONSTRAINT pk_retail_calendar PRIMARY KEY(`retail_calendar_id`)
) COMMENT 'Authoritative retail fiscal calendar master defining the 4-5-4 or 4-4-5 fiscal week structure used across all retail planning, reporting, and analytics. Captures fiscal year, fiscal quarter, fiscal period, fiscal week number, ISO week number, Gregorian date range, season designation (Spring/Summer, Fall/Winter), key retail event flags (Black Friday week, Back-to-School, Holiday), and comparable period mapping. Serves as the conformed time dimension for all retail analytics and reporting.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`reporting_hierarchy` (
    `reporting_hierarchy_id` BIGINT COMMENT 'Unique identifier for the reporting hierarchy node. Primary key for the reporting hierarchy master record.',
    `parent_reporting_hierarchy_id` BIGINT COMMENT 'Self-referencing FK on reporting_hierarchy (parent_reporting_hierarchy_id)',
    `attributes_json` STRING COMMENT 'JSON-formatted string containing hierarchy-type-specific attributes that do not warrant dedicated columns. For example, geographic hierarchies may include latitude/longitude; merchandise hierarchies may include buyer name; organizational hierarchies may include square footage. Provides extensibility without schema changes.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this hierarchy node record was first created in the system. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for financial metrics reported at this hierarchy node. Used for multi-currency reporting and consolidation (e.g., USD for US stores, CAD for Canadian stores, EUR for European operations).. Valid values are `^[A-Z]{3}$`',
    `data_source` STRING COMMENT 'Source system or data feed that provided this hierarchy node record (e.g., the customer master data system, SAP S/4HANA FI/CO, the retail merchandising system Merchandising System). Used for data lineage and reconciliation.',
    `effective_end_date` DATE COMMENT 'Date when this hierarchy node becomes inactive. Null for currently active nodes. Supports historical reporting and enables point-in-time hierarchy reconstruction for trend analysis and comp sales calculations.',
    `effective_start_date` DATE COMMENT 'Date when this hierarchy node becomes active and valid for reporting. Supports time-variant hierarchy structures (e.g., store reorganizations, category restructuring). Used for as-of-date reporting and historical trend analysis.',
    `external_system_code` STRING COMMENT 'Identifier for this hierarchy node in the source operational system (e.g., SAP S/4HANA cost center, the retail merchandising system location code, MDM golden record ID). Used for data lineage and reconciliation.',
    `external_system_name` STRING COMMENT 'Name of the source operational system that owns this hierarchy node (e.g., SAP S/4HANA, the retail merchandising system Merchandising System, the customer master data system). Used for data lineage and troubleshooting.',
    `hierarchy_name` STRING COMMENT 'Business name of the reporting hierarchy structure (e.g., Store Geographic Hierarchy, Merchandise Category Hierarchy, Channel Hierarchy).',
    `hierarchy_type` STRING COMMENT 'Classification of the hierarchy structure. Organizational hierarchies represent corporate structure (banner/division/region/district/store). Geographic hierarchies represent location rollups (country/state/city/postal). Merchandise hierarchies represent product categorization (department/category/subcategory/class). Channel hierarchies represent sales channel groupings (omnichannel/online/store/mobile). Financial hierarchies represent cost center and profit center rollups. Customer segment hierarchies represent customer classification structures.. Valid values are `organizational|geographic|merchandise|channel|financial|customer_segment`',
    `is_active` BOOLEAN COMMENT 'Indicates whether this hierarchy node is currently active and available for use in reporting and analytics. True for active nodes, False for inactive/historical nodes. Used for filtering current vs historical hierarchies.',
    `last_updated_by` STRING COMMENT 'User ID or system identifier that last modified this hierarchy node record. Used for audit trail and change tracking.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this hierarchy node record was last modified. Used for audit trail, change data capture, and incremental processing.',
    `leaf_node_flag` BOOLEAN COMMENT 'Indicates whether this node is a leaf (terminal) node with no children. True for leaf nodes (e.g., individual stores, SKUs), False for parent/aggregate nodes. Used to control drill-down behavior in dashboards.',
    `level_name` STRING COMMENT 'Business name for this hierarchy level (e.g., Banner, Region, District, Store for organizational hierarchy; Department, Category, Subcategory, Class for merchandise hierarchy). Provides semantic meaning to level_number.',
    `level_number` STRING COMMENT 'Numeric position of this node within the hierarchy depth. Root level is 1, immediate children are 2, etc. Used for level-based aggregation and drill-down control in BI tools.',
    `node_description` STRING COMMENT 'Detailed description of the hierarchy node, including scope, coverage, and business purpose. Provides context for reporting users.',
    `node_identifier` STRING COMMENT 'Business identifier for this specific node within the hierarchy. May be a store number, department code, region code, or other business key depending on hierarchy type. Used for drill-down and roll-up navigation in OLAP reporting.',
    `node_name` STRING COMMENT 'Human-readable display name for this hierarchy node (e.g., Northeast Region, Electronics Department, Store #1234, E-Commerce Channel).',
    `node_owner` STRING COMMENT 'Business owner or responsible party for this hierarchy node (e.g., Regional VP, Category Manager, Channel Director). Used for governance and accountability in KPI reporting.',
    `node_path` STRING COMMENT 'Full hierarchical path from root to this node, typically delimited (e.g., /Banner/Region/District/Store or Department>Category>Subcategory). Enables fast ancestor and descendant queries without recursive joins.',
    `node_status` STRING COMMENT 'Current lifecycle status of the hierarchy node. Active nodes are used in current reporting. Inactive nodes are historical. Pending nodes are scheduled for future activation. Deprecated nodes are being phased out. Merged nodes have been consolidated into another node.. Valid values are `active|inactive|pending|deprecated|merged`',
    `parent_node_identifier` STRING COMMENT 'Business identifier of the parent node in the hierarchy. Null for root nodes. Enables recursive roll-up aggregation of KPIs and metrics from child to parent levels.',
    `reporting_calendar_type` STRING COMMENT 'Calendar convention used for period-based reporting at this hierarchy node. Gregorian for standard calendar. Retail 4-5-4 and 4-4-5 for NRF retail calendar. Fiscal for custom fiscal periods. Enables consistent period comparisons and comp sales calculations.. Valid values are `gregorian|retail_454|retail_445|fiscal`',
    `rollup_method` STRING COMMENT 'Default aggregation method for rolling up metrics from child nodes to this parent node. Sum for additive metrics (sales, units). Average for rates and percentages. Weighted_average for metrics requiring weighting (average selling price). None for non-aggregatable dimensions. [ENUM-REF-CANDIDATE: sum|average|weighted_average|min|max|count|none — 7 candidates stripped; promote to reference product]',
    `root_node_flag` BOOLEAN COMMENT 'Indicates whether this node is the root (top-level) node of the hierarchy. True for root nodes (e.g., Total Company, All Products), False for all other nodes.',
    `sort_order` STRING COMMENT 'Numeric value controlling the display sequence of sibling nodes at the same hierarchy level. Lower values appear first. Used to control presentation order in reports and dashboards.',
    `time_zone` STRING COMMENT 'IANA time zone identifier for this hierarchy node (e.g., America/New_York, America/Los_Angeles). Used for time-based reporting and comp sales calculations across geographic regions.',
    `version_number` STRING COMMENT 'Version number for this hierarchy node record. Incremented with each modification. Supports optimistic locking and change history tracking for hierarchy restructuring events.',
    `created_by` STRING COMMENT 'User ID or system identifier that created this hierarchy node record. Used for audit trail and data governance.',
    CONSTRAINT pk_reporting_hierarchy PRIMARY KEY(`reporting_hierarchy_id`)
) COMMENT 'Master record defining organizational and merchandise reporting hierarchies used to roll up KPIs and metrics across the retail enterprise. Captures hierarchy name, hierarchy type (organizational, geographic, merchandise, channel), node identifier, node name, parent node reference, level number, level name, and effective date range. Supports drill-down and roll-up navigation in dashboards and OLAP reporting for dimensions such as store region/district/store, department/category/subcategory, and banner/channel.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` (
    `analytics_kpi_target_id` BIGINT COMMENT 'Unique identifier for the KPI target record. Primary key for the kpi_target product.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Compliance programs have target KPIs (zero critical findings, 100% training completion, <2% food safety violations). Link enables target-setting by program and performance tracking against regulatory',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Store/department targets are set at cost center level for operational accountability, manager goal-setting, and performance management. Standard retail practice for decentralized target allocation.',
    `demand_forecast_id` BIGINT COMMENT 'Foreign key linking to supplychain.demand_forecast. Business justification: Establishes forecast accuracy targets by SKU/location/time period for planning team performance goals. Standard practice in retail demand planning and S&OP processes.',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.store_department. Business justification: Department managers receive targets for sales, margin, shrinkage by department. Retail operations management requires department-level goal setting for accountability and performance tracking across s',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.store_format. Business justification: Corporate sets differentiated targets by format (hypermarket target margin 28% vs discount format 18%) for strategic planning. Format-level goal setting is standard retail strategy execution practice.',
    `fulfillment_node_id` BIGINT COMMENT 'Foreign key linking to fulfillment.node. Business justification: Performance targets set at node level (orders per hour, SLA percentage, cost per order, pick accuracy) drive operational planning and performance management. Essential for budget planning, incentive p',
    `plan_id` BIGINT COMMENT 'Reference to the specific incentive or compensation plan associated with this target. Null if target is not incentive-eligible.',
    `inventory_node_id` BIGINT COMMENT 'Foreign key linking to inventory.inventory_node. Business justification: Inventory KPI targets (turnover rate, fill rate, DOS) are set at node level (DC, store, region). Performance tracking and incentive compensation require node-level target linkage.',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Annual targets set at category/department level (category sales plan, department margin target, subcategory unit goal). Retail planning and buyer incentive plans operate on hierarchy. Financial planni',
    `kpi_definition_id` BIGINT COMMENT 'Reference to the KPI definition master record that specifies the metric being targeted (e.g., comp sales, shrinkage rate, NPS score, GMROI).',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.store_location. Business justification: Store managers receive monthly/quarterly targets for sales, margin, shrinkage by location. Standard retail performance management process requires linking targets to specific stores for goal tracking',
    `margin_target_id` BIGINT COMMENT 'Foreign key linking to pricing.margin_target. Business justification: KPI targets for margin metrics must reference operational margin targets set by merchandising/pricing teams. Ensures performance management alignment between analytics layer and operational planning.',
    `associate_id` BIGINT COMMENT 'Identifier of the user or manager who approved the target. Establishes accountability for target authorization.',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Segment-level targets require profit center attribution for divisional performance management, strategic planning, and executive compensation metrics. Enables banner/channel/region target tracking.',
    `reporting_hierarchy_id` BIGINT COMMENT 'Foreign key linking to analytics.reporting_hierarchy. Business justification: KPI targets are often set at specific nodes in reporting hierarchies (e.g., regional targets, category targets). This FK links the target to the specific hierarchy node it applies to, enabling hierarc',
    `retail_calendar_id` BIGINT COMMENT 'Foreign key linking to analytics.retail_calendar. Business justification: KPI targets are set for specific fiscal periods defined in the retail calendar. This FK links the target to the authoritative retail calendar date (typically the period_start_date), enabling consisten',
    `revised_analytics_kpi_target_id` BIGINT COMMENT 'Self-referencing FK on analytics_kpi_target (revised_analytics_kpi_target_id)',
    `semantic_layer_entity_id` BIGINT COMMENT 'Identifier of the specific business entity (store number, category code, region code, channel identifier) to which this target applies. Polymorphic reference based on business_entity_type.',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Sets performance targets at PO level for vendor scorecards (e.g., 95% on-time delivery target for specific PO). Used in supplier performance management and contract compliance tracking.',
    `financial_period_id` BIGINT COMMENT 'Foreign key linking to finance.financial_period. Business justification: Annual/quarterly targets must align to fiscal calendar for budget vs actual reporting, performance reviews, and incentive compensation calculations. Distinct from measurement period; targets are set p',
    `target_owner_user_associate_id` BIGINT COMMENT 'Identifier of the individual or role accountable for achieving the target. Typically a store manager, category manager, regional director, or channel leader.',
    `tertiary_analytics_last_updated_by_user_associate_id` BIGINT COMMENT 'Identifier of the user who most recently modified the target record. Supports accountability and audit trail.',
    `approval_status` STRING COMMENT 'Current approval state of the target within the governance workflow. Ensures targets are formally reviewed and authorized before becoming active.. Valid values are `draft|pending_approval|approved|rejected|revised`',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the target was formally approved. Provides audit trail for governance compliance.',
    `business_entity_type` STRING COMMENT 'Type of business entity for which the target is set. Determines the scope and granularity of performance measurement.. Valid values are `store|category|region|channel|department|supplier`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the target record was first created in the system. Provides audit trail for record lifecycle.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for monetary targets (e.g., USD, EUR, GBP). Null for non-monetary KPIs.. Valid values are `^[A-Z]{3}$`',
    `data_source` STRING COMMENT 'System or process that originated or last updated the target record (e.g., SAP BPC, Blue Yonder Demand Planning, Manual Entry, Excel Upload). Supports data lineage and troubleshooting.',
    `effective_end_date` DATE COMMENT 'Date until which this target version remains effective. Null for currently active targets. Supports temporal validity and target change management.',
    `effective_start_date` DATE COMMENT 'Date from which this target version becomes effective. Supports temporal validity and target change management.',
    `fiscal_period` STRING COMMENT 'Fiscal period within the year (e.g., Q1, Q2, Q3, Q4, M01, M02, W01, FY) for which the target is defined. Supports quarterly, monthly, weekly, and annual target setting.',
    `fiscal_year` STRING COMMENT 'Fiscal year for which the target is set, following the organizations fiscal calendar (e.g., 2024, 2025).',
    `floor_threshold_value` DECIMAL(18,2) COMMENT 'Minimum acceptable performance level below which corrective action or escalation is required. Represents the lower bound of acceptable performance.',
    `incentive_eligible_flag` BOOLEAN COMMENT 'Indicates whether achievement of this target is tied to compensation, bonuses, or other incentive programs. True if target performance impacts financial rewards.',
    `is_active` BOOLEAN COMMENT 'Indicates whether this target is currently active and in use for performance measurement. False for superseded, cancelled, or historical targets.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when the target record was most recently modified. Provides audit trail for record changes.',
    `notes` STRING COMMENT 'Free-text field for additional context, assumptions, constraints, or commentary related to the target. Supports collaborative planning and knowledge capture.',
    `period_end_date` DATE COMMENT 'End date of the performance measurement period for this target. Defines the conclusion of the evaluation window.',
    `period_start_date` DATE COMMENT 'Start date of the performance measurement period for this target. Defines the beginning of the evaluation window.',
    `revision_reason` STRING COMMENT 'Explanation for why the target was revised after initial approval (e.g., market conditions changed, strategic pivot, acquisition impact). Provides context for mid-period adjustments.',
    `stretch_target_value` DECIMAL(18,2) COMMENT 'Aspirational or stretch goal value that exceeds the baseline target. Used to incentivize exceptional performance and drive continuous improvement.',
    `target_basis` STRING COMMENT 'Descriptive explanation of the rationale, assumptions, or data sources used to derive the target value. Provides transparency and auditability for target-setting decisions.',
    `target_owner_role` STRING COMMENT 'Organizational role or job title of the target owner (e.g., Store Manager, Category Manager, Regional VP, E-Commerce Director). Provides context for accountability assignment.',
    `target_setting_method` STRING COMMENT 'Methodology used to establish the target value. Top-down: cascaded from corporate goals; Bottom-up: aggregated from operational plans; Algorithmic: calculated by forecasting models; Historical: based on prior period performance; Benchmark: derived from industry or peer comparisons.. Valid values are `top_down|bottom_up|algorithmic|historical|benchmark`',
    `target_value` DECIMAL(18,2) COMMENT 'Planned or expected value for the KPI during the specified period. Represents the baseline performance goal that the business entity is expected to achieve.',
    `target_version` STRING COMMENT 'Version number of the target record. Increments when targets are revised or reforecasted during the performance period. Supports target change history and audit.',
    `unit_of_measure` STRING COMMENT 'Unit in which the target value is expressed (e.g., USD, percent, units, score, days, ratio). Ensures consistent interpretation of target metrics.',
    `variance_alert_threshold_percent` DECIMAL(18,2) COMMENT 'Percentage deviation from target that triggers an alert or notification (e.g., 10.00 means alert if actual is 10% or more below target). Enables proactive performance management.',
    CONSTRAINT pk_analytics_kpi_target PRIMARY KEY(`analytics_kpi_target_id`)
) COMMENT 'Master record defining planned KPI targets for a specific business entity (store, category, region, channel) and time period. Captures KPI definition reference, target entity type and identifier, fiscal period, target value, stretch target value, floor threshold, target setting method (top-down, bottom-up, algorithmic), approval status, and target owner. Enables variance-to-target reporting and performance management across all retail KPIs including sales, margin, shrink, and NPS.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`alert` (
    `alert_id` BIGINT COMMENT 'Unique identifier for the analytics alert record. Primary key.',
    `access_policy_id` BIGINT COMMENT 'Foreign key linking to analytics.analytics_access_policy. Business justification: Analytics alerts may be subject to access policies that determine who can view, acknowledge, or resolve them. This FK links the alert to the governing access policy, enabling enforcement of row-level',
    `adjustment_id` BIGINT COMMENT 'Foreign key linking to inventory.adjustment. Business justification: Shrinkage alerts flag high-value adjustments (>$500, unauthorized adjustments, pattern anomalies). Loss prevention requires direct adjustment linkage for case management and investigation workflows.',
    `audit_finding_id` BIGINT COMMENT 'Foreign key linking to compliance.audit_finding. Business justification: Critical audit findings trigger operational alerts (critical food safety violation, immediate corrective action required). Link enables automated escalation workflows and real-time compliance issue ma',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Alerts trigger on campaign performance thresholds (underperforming ROAS, overspend, low conversion). Retail marketing operations require real-time alerts for campaign issues; this link enables proacti',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Operational alerts (shrink, labor variance, expense overruns) are triggered at cost center level for immediate manager notification and corrective action. Standard retail exception management.',
    `cycle_count_id` BIGINT COMMENT 'Foreign key linking to inventory.cycle_count. Business justification: Variance alerts trigger when cycle counts exceed thresholds (>5% variance, high-value discrepancies). Operations teams investigate specific count events; alert systems require direct count linkage for',
    `demand_forecast_id` BIGINT COMMENT 'Foreign key linking to supplychain.demand_forecast. Business justification: Alerts planners when forecast variance exceeds thresholds, enabling exception-based planning. Essential for demand sensing and rapid response to demand shifts in retail.',
    `dq_result_id` BIGINT COMMENT 'Foreign key linking to analytics.dq_result. Business justification: Analytics alerts can be triggered by data quality rule violations. This FK links the alert to the specific DQ result execution that triggered it, enabling root cause analysis and linking alert resolut',
    `escalated_from_alert_id` BIGINT COMMENT 'Self-referencing FK on alert (escalated_from_alert_id)',
    `financial_period_id` BIGINT COMMENT 'Foreign key linking to finance.financial_period. Business justification: Alerts on financial KPIs must reference the fiscal period for context (e.g., Q3 margin below threshold). Essential for period-specific exception reporting and close process monitoring.',
    `fulfillment_node_id` BIGINT COMMENT 'Foreign key linking to fulfillment.node. Business justification: Node-level alerts (capacity threshold breaches, equipment downtime, staffing shortages, inventory discrepancies) trigger operational responses. Critical for facility management, resource allocation, a',
    `fulfillment_order_id` BIGINT COMMENT 'Foreign key linking to fulfillment.fulfillment_order. Business justification: Alerts trigger on fulfillment order exceptions (SLA breaches, stuck orders, allocation failures, cancellation spikes). Core to real-time operational monitoring, exception management workflows, and pro',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to fulfillment.shipment. Business justification: Shipment-level alerts (carrier delays, tracking gaps, delivery failures, damaged packages) are fundamental to logistics monitoring. Enables carrier performance tracking, customer proactive notificatio',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Category-level alerts (department sales miss, subcategory margin below plan) trigger merchandising review. Aggregate performance monitoring at hierarchy nodes. Standard retail exception-based manageme',
    `kpi_definition_id` BIGINT COMMENT 'Reference to the KPI definition that triggered this alert. Links to the master KPI catalog.',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.store_location. Business justification: Store performance alerts (shrinkage spike, conversion drop, sales miss) trigger notifications to store/district managers. Operational exception management requires linking alerts to specific store loc',
    `loyalty_membership_id` BIGINT COMMENT 'Foreign key linking to loyalty.membership. Business justification: Member-level alerts (fraud detection, unusual redemption patterns, tier qualification anomalies, points expiry warnings) trigger on specific memberships. Alerts require FK to membership for investigat',
    `margin_target_id` BIGINT COMMENT 'Foreign key linking to pricing.margin_target. Business justification: Margin breach alerts reference specific margin targets being violated (department, category, or buyer-level targets). Enables margin protection workflows with direct link to target definition. Real bu',
    `markdown_id` BIGINT COMMENT 'Foreign key linking to pricing.markdown. Business justification: Markdown alerts (slow sell-through, excess inventory at clearance, markdown budget overrun) trigger on specific markdown events. Enables clearance intervention workflows. Real business process: automa',
    `osha_incident_id` BIGINT COMMENT 'Foreign key linking to compliance.osha_incident. Business justification: Serious safety incidents trigger immediate alerts to leadership and safety teams (recordable injuries, fatalities). Link supports real-time incident response, regulatory notification workflows, and sa',
    `associate_id` BIGINT COMMENT 'Identifier of the user or team member assigned to investigate and resolve the alert. Null if unassigned.',
    `profile_id` BIGINT COMMENT 'Foreign key linking to customer.profile. Business justification: Customer-level alerts for high-value churn risk, VIP service issues, fraud detection, and loyalty tier changes are core to retail CRM operations. Real-time customer monitoring drives retention and los',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Executive alerts on segment performance (channel underperformance, regional margin issues) require profit center context for strategic response and resource reallocation decisions.',
    `replenishment_plan_id` BIGINT COMMENT 'Foreign key linking to supplychain.replenishment_plan. Business justification: Alerts for stockout risk, excess inventory, or service level breaches on specific replenishment plans. Core inventory health monitoring for retail operations and DC management.',
    `reporting_hierarchy_id` BIGINT COMMENT 'Foreign key linking to analytics.reporting_hierarchy. Business justification: Analytics alerts may be scoped to specific nodes in reporting hierarchies (e.g., alerts for a specific region or category). This FK links the alert to the hierarchy node it applies to, enabling hierar',
    `retail_calendar_id` BIGINT COMMENT 'Foreign key linking to analytics.retail_calendar. Business justification: Analytics alerts are triggered for specific dates in the retail calendar. This FK links the alert to the authoritative retail calendar date (typically the triggered_timestamp date), enabling fiscal pe',
    `semantic_layer_entity_id` BIGINT COMMENT 'Identifier of the specific business entity instance affected by the alert (e.g., store number, SKU, customer ID). Polymorphic reference based on business_entity_type.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Alerts fire on SKU-level threshold breaches (inventory below safety stock, margin erosion, velocity drop, out-of-stock). Buyers and planners need SKU identification for action. Real-time operational m',
    `sku_price_id` BIGINT COMMENT 'Foreign key linking to pricing.sku_price. Business justification: Price alerts (MAP violations, competitive gap thresholds, margin floor breaches) trigger on specific SKU price records. Enables automated pricing compliance monitoring with direct link to violating pr',
    `stock_position_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_position. Business justification: Inventory alerts (out-of-stock, overstock, dead stock, negative ATP) trigger on specific positions. Store managers and planners require direct drill-through to position details for immediate action.',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Triggers alerts for PO exceptions (late delivery, cost overruns, quantity variances) to procurement teams. Critical for proactive supply chain risk management and vendor issue resolution.',
    `acknowledged_timestamp` TIMESTAMP COMMENT 'Date and time when the alert was acknowledged by a user. Null if not yet acknowledged.',
    `actual_value` DECIMAL(18,2) COMMENT 'The actual measured value of the KPI at the time the alert was triggered.',
    `alert_status` STRING COMMENT 'Current lifecycle status of the alert: new when first triggered, acknowledged when reviewed, investigating during analysis, resolved when addressed, dismissed if false positive, escalated if requiring higher attention.. Valid values are `new|acknowledged|investigating|resolved|dismissed|escalated`',
    `alert_type` STRING COMMENT 'Classification of the alert trigger mechanism: threshold breach when a KPI crosses a defined limit, anomaly detection for statistical outliers, trend deviation for directional changes, forecast variance for prediction misses, data quality issues, or target misses.. Valid values are `threshold_breach|anomaly_detection|trend_deviation|forecast_variance|data_quality_issue|target_miss`',
    `business_entity_type` STRING COMMENT 'Type of business entity affected by this alert (e.g., store, product, customer segment, supplier, category, region, sales channel). [ENUM-REF-CANDIDATE: store|product|customer|supplier|category|region|channel|campaign|employee|distribution_center — 10 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this alert record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for monetary KPIs (e.g., USD, EUR, GBP). Null for non-monetary metrics.. Valid values are `^[A-Z]{3}$`',
    `data_source` STRING COMMENT 'Source system or data product that provided the KPI measurement triggering this alert (e.g., the retail analytics platform, the retail merchandising system, Blue Yonder).',
    `escalation_level` STRING COMMENT 'Number of times the alert has been escalated to higher management levels. Zero for no escalation, increments with each escalation.',
    `false_positive_flag` BOOLEAN COMMENT 'Indicates whether the alert was determined to be a false positive after investigation. True if false alarm, False if legitimate alert.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this alert record was last modified, tracking status changes, acknowledgments, and resolution updates.',
    `measurement_period_end_date` DATE COMMENT 'End date of the measurement period for which the KPI was calculated and the alert triggered.',
    `measurement_period_start_date` DATE COMMENT 'Start date of the measurement period for which the KPI was calculated and the alert triggered.',
    `alert_name` STRING COMMENT 'Business-friendly name of the alert for identification and reporting purposes.',
    `notification_channel` STRING COMMENT 'Primary communication channel used to deliver the alert notification (email, SMS, push notification, Slack, Microsoft Teams, dashboard, webhook). [ENUM-REF-CANDIDATE: email|sms|push|slack|teams|dashboard|webhook — 7 candidates stripped; promote to reference product]',
    `notification_sent_flag` BOOLEAN COMMENT 'Indicates whether notification was successfully sent to recipients. True if sent, False if pending or failed.',
    `period_type` STRING COMMENT 'Type of time period for the measurement: daily, weekly, monthly, quarterly, yearly, rolling window, or custom date range. [ENUM-REF-CANDIDATE: daily|weekly|monthly|quarterly|yearly|rolling|custom — 7 candidates stripped; promote to reference product]',
    `priority_score` STRING COMMENT 'Calculated priority score (0-100) combining severity, business impact, and urgency to support alert queue management and triage.',
    `recipient_list` STRING COMMENT 'Comma-separated list of notification recipients (email addresses, user IDs, or distribution group names) who received or should receive this alert.',
    `related_alert_count` STRING COMMENT 'Number of related or correlated alerts triggered in the same time window for the same or related business entities, supporting root cause analysis.',
    `resolution_duration_minutes` STRING COMMENT 'Time elapsed in minutes from alert trigger to resolution, used for Service Level Agreement (SLA) tracking and performance analysis.',
    `resolution_notes` STRING COMMENT 'Free-text notes documenting the investigation findings, root cause analysis, and actions taken to resolve the alert.',
    `resolution_timestamp` TIMESTAMP COMMENT 'Date and time when the alert was marked as resolved. Null if still open or investigating.',
    `rule_version` STRING COMMENT 'Version identifier of the alert rule configuration that was active when this alert triggered, supporting rule change tracking and audit.',
    `severity_level` STRING COMMENT 'Business impact severity of the alert: critical requires immediate action, high needs urgent attention, medium for monitoring, low for awareness, informational for FYI.. Valid values are `critical|high|medium|low|informational`',
    `suppression_flag` BOOLEAN COMMENT 'Indicates whether this alert was suppressed from notification due to alert fatigue rules, maintenance windows, or duplicate detection. True if suppressed, False if active.',
    `suppression_reason` STRING COMMENT 'Explanation of why the alert was suppressed (e.g., maintenance window, duplicate within 1 hour, recipient opt-out). Null if not suppressed.',
    `threshold_value` DECIMAL(18,2) COMMENT 'The threshold or boundary value that was breached to trigger the alert. Null for non-threshold alert types.',
    `trigger_condition` STRING COMMENT 'Detailed description of the condition that triggered the alert, including the rule logic and comparison operators used.',
    `triggered_timestamp` TIMESTAMP COMMENT 'Date and time when the alert condition was detected and the alert was triggered.',
    `unit_of_measure` STRING COMMENT 'The unit of measurement for the KPI value (e.g., USD, units, percentage, days, count).',
    `variance_amount` DECIMAL(18,2) COMMENT 'Absolute difference between actual value and threshold value, calculated as actual minus threshold.',
    `variance_percentage` DECIMAL(18,2) COMMENT 'Percentage variance between actual and threshold, calculated as (actual - threshold) / threshold * 100.',
    CONSTRAINT pk_alert PRIMARY KEY(`alert_id`)
) COMMENT 'Operational record capturing a triggered analytics alert when a KPI value breaches a configured threshold or anomaly is detected. Stores alert name, associated KPI definition, triggering condition (threshold breach, anomaly, trend deviation), actual value at trigger, threshold value, severity level (critical, warning, informational), affected business entity, notification recipients, acknowledgment status, and resolution notes. Supports proactive retail performance management.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`self_service_query` (
    `self_service_query_id` BIGINT COMMENT 'Unique identifier for the self-service query execution record.',
    `access_policy_id` BIGINT COMMENT 'Foreign key linking to analytics.access_policy. Business justification: Self-service queries are governed by access policies that determine which data the user can query (row-level security, column masking, etc.). The query has access_granted_by_policy: STRING (policy nam',
    `associate_id` BIGINT COMMENT 'Identifier of the business user who executed the query.',
    `dashboard_config_id` BIGINT COMMENT 'Foreign key linking to analytics.dashboard_config. Business justification: Self-service queries can be executed from dashboard contexts (e.g., drill-through from a dashboard widget). This FK links the query to the dashboard it was executed from, enabling understanding of das',
    `forked_from_self_service_query_id` BIGINT COMMENT 'Self-referencing FK on self_service_query (forked_from_self_service_query_id)',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_definition. Business justification: Self-service queries can retrieve or analyze specific KPIs. This FK links the query to the KPI definition being analyzed, enabling KPI usage tracking, understanding which KPIs drive ad-hoc analysis, a',
    `loyalty_membership_id` BIGINT COMMENT 'Foreign key linking to loyalty.membership. Business justification: Business users query member-specific data (transaction history, points balance, offer eligibility, tier status) for customer service and clienteling. Query log tracks which membership was analyzed for',
    `report_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.report_definition. Business justification: Self-service queries can be based on or derived from report definitions (e.g., user modifies a standard report). This FK links the query to the report template it was derived from, enabling understand',
    `semantic_layer_entity_id` BIGINT COMMENT 'Foreign key linking to analytics.semantic_layer_entity. Business justification: Self-service queries execute against semantic layer entities. This FK links the query to the entity being queried, enabling usage tracking, performance analysis, and understanding which semantic entit',
    `semantic_metric_id` BIGINT COMMENT 'Foreign key linking to analytics.semantic_metric. Business justification: Self-service queries can retrieve specific semantic metrics. This FK links the query to the metric being retrieved, enabling metric usage tracking, performance analysis, and understanding which certif',
    `web_session_id` BIGINT COMMENT 'The user session identifier associated with the query execution, used to group queries within a single user session.',
    `workspace_id` BIGINT COMMENT 'The workspace or project identifier where the query was executed, used for organizational segmentation.',
    `access_granted_by_policy` STRING COMMENT 'The data access policy or permission rule that granted the user access to execute this query.',
    `aggregation_functions` STRING COMMENT 'The aggregation functions used in the query (e.g., SUM, AVG, COUNT, MAX, MIN), captured for complexity analysis.',
    `bi_tool` STRING COMMENT 'The BI or analytics tool used to execute the query (e.g., Tableau, Power BI, Databricks SQL, Looker). [ENUM-REF-CANDIDATE: tableau|power_bi|databricks_sql|looker|qlik|thoughtspot|other — 7 candidates stripped; promote to reference product]',
    `cache_hit` BOOLEAN COMMENT 'Flag indicating whether the query results were served from cache rather than re-executed.',
    `compute_cost_usd` DECIMAL(18,2) COMMENT 'The estimated compute cost in USD for executing the query, used for cost attribution and chargeback.',
    `contains_pii` BOOLEAN COMMENT 'Flag indicating whether the query accessed data containing PII.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this query execution record was created in the system.',
    `data_classification` STRING COMMENT 'The highest data classification level of the objects accessed by the query (restricted, confidential, internal, public).. Valid values are `restricted|confidential|internal|public`',
    `data_scanned_bytes` BIGINT COMMENT 'The total volume of data scanned during query execution, measured in bytes.',
    `error_message` STRING COMMENT 'The error message or exception details if the query failed or encountered issues during execution.',
    `execution_timestamp` TIMESTAMP COMMENT 'The date and time when the query was executed by the user.',
    `export_format` STRING COMMENT 'The file format used if the query results were exported: CSV, Excel, PDF, JSON, Parquet, or none if not exported.. Valid values are `csv|excel|pdf|json|parquet|none`',
    `filter_criteria` STRING COMMENT 'The filter or WHERE clause criteria applied by the user in the query, captured for usage pattern analysis.',
    `join_count` STRING COMMENT 'The number of table joins performed in the query, used to assess query complexity.',
    `query_complexity_score` DECIMAL(18,2) COMMENT 'A calculated score representing the complexity of the query based on joins, aggregations, subqueries, and data volume.',
    `query_duration_seconds` DECIMAL(18,2) COMMENT 'The total execution time of the query in seconds, from submission to completion.',
    `query_name` STRING COMMENT 'User-assigned name or title for the query, used for identification and reuse.',
    `query_optimization_applied` BOOLEAN COMMENT 'Flag indicating whether automatic query optimization or rewrite was applied by the query engine.',
    `query_purpose` STRING COMMENT 'The business purpose or use case for the query: ad-hoc analysis, reporting, dashboard refresh, data exploration, model training, or data quality check.. Valid values are `ad_hoc_analysis|reporting|dashboard_refresh|data_exploration|model_training|data_quality_check`',
    `query_status` STRING COMMENT 'The execution status of the query: success, failed, timeout, cancelled by user, or partial results.. Valid values are `success|failed|timeout|cancelled|partial`',
    `query_text` STRING COMMENT 'The full SQL or semantic query definition executed by the user. May be SQL, natural language, or semantic layer query syntax.',
    `query_type` STRING COMMENT 'The type or format of the query executed: SQL, semantic layer query, natural language, visual query builder, or saved query reference.. Valid values are `sql|semantic|natural_language|visual_builder|saved_query`',
    `result_set_size_mb` DECIMAL(18,2) COMMENT 'The size of the query result set in megabytes, used for performance and storage analysis.',
    `rows_returned` BIGINT COMMENT 'The number of rows returned by the query execution.',
    `saved_query_flag` BOOLEAN COMMENT 'Flag indicating whether the user saved this query for future reuse.',
    `shared_flag` BOOLEAN COMMENT 'Flag indicating whether the query or its results were shared with other users.',
    `target_data_product` STRING COMMENT 'The specific data product or table accessed by the query within the target domain.',
    `target_domain` STRING COMMENT 'The business domain or data domain accessed by the query (e.g., Customer, Product, Inventory, Order, Finance).',
    `user_department` STRING COMMENT 'The department or business unit of the user who executed the query, used for usage segmentation and cost allocation.',
    `user_role` STRING COMMENT 'The role or job function of the user who executed the query (e.g., analyst, manager, data scientist, executive).',
    CONSTRAINT pk_self_service_query PRIMARY KEY(`self_service_query_id`)
) COMMENT 'Transactional record capturing ad-hoc self-service queries executed by business users against the retail semantic layer or data catalog. Stores user reference, query text or semantic query definition, target domain and product, execution timestamp, query duration, rows returned, BI tool used (Tableau, Power BI, Databricks SQL, Looker), query status, and data classification of accessed objects. Enables analytics usage governance, cost attribution, and popular query identification.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`glossary_term` (
    `glossary_term_id` BIGINT COMMENT 'Unique identifier for the business glossary term record. Primary key.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Operational terms reference cost center structure (e.g., Store Labor = cost centers 1000-1999). Supports business user understanding of organizational dimensions in reports.',
    `dashboard_config_id` BIGINT COMMENT 'Foreign key linking to analytics.dashboard_config. Business justification: Glossary terms may reference dashboards where they are used. This FK links the term to the dashboard, enabling business users to understand which dashboards use specific terminology, and enabling dash',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Business glossary entries reference specific SKUs as examples (e.g., term private label links to example SKU, hazmat item shows real instance). Documentation and training practice for data literac',
    `financial_period_id` BIGINT COMMENT 'Foreign key linking to finance.financial_period. Business justification: Temporal business terms reference fiscal calendar (e.g., Comparable Period = prior year same period). Standardizes time-based terminology across retail analytics and reporting.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Business terms for financial metrics reference specific GL accounts (e.g., Net Sales = accounts 4000-4999). Enables business-to-technical mapping for self-service analytics and data literacy.',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_definition. Business justification: Formalizes the relationship between glossary terms and KPI definitions. Currently glossary_term has associated_kpi_code (string) which is a soft reference. Replacing this with a proper FK to kpi_defin',
    `metric_dimension_id` BIGINT COMMENT 'Foreign key linking to analytics.metric_dimension. Business justification: Glossary terms may define or describe metric dimensions. This FK links the term to the dimension, enabling business users to understand the business meaning of dimensions used to slice and filter KPIs',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.obligation. Business justification: Compliance terms reference specific regulatory obligations (definitions cite CFR sections, OSHA standards, FDA requirements). Link provides regulatory traceability for business glossary and ensures co',
    `parent_glossary_term_id` BIGINT COMMENT 'Self-referencing FK on glossary_term (parent_glossary_term_id)',
    `report_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.report_definition. Business justification: Glossary terms may reference reports where they are used. This FK links the term to the report, enabling business users to understand which reports use specific terminology, and enabling report docume',
    `semantic_layer_entity_id` BIGINT COMMENT 'Foreign key linking to analytics.semantic_layer_entity. Business justification: Glossary terms may reference semantic layer entities they define or describe. This FK links the term to the entity, enabling business users to navigate from terminology definitions to the actual seman',
    `semantic_metric_id` BIGINT COMMENT 'Foreign key linking to analytics.semantic_metric. Business justification: Glossary terms may reference semantic metrics they define or describe. This FK links the term to the metric, enabling business users to navigate from terminology definitions to the actual certified me',
    `approval_date` DATE COMMENT 'Date when the glossary term was officially approved by the governance body.',
    `approval_status` STRING COMMENT 'Current approval and publication status of the glossary term in the governance workflow. Indicates readiness for enterprise-wide use.. Valid values are `draft|pending_review|approved|published|deprecated|retired`',
    `approved_by` STRING COMMENT 'Name or identifier of the individual or governance body that approved this glossary term for publication.',
    `associated_report_names` STRING COMMENT 'Comma-separated list of report names or dashboard titles where this term is prominently used. Helps users understand term application.',
    `business_definition` STRING COMMENT 'Comprehensive business definition of the term explaining its meaning, usage context, and business significance in retail operations.',
    `business_owner_email` STRING COMMENT 'Email address of the business owner responsible for this glossary term.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `business_owner_name` STRING COMMENT 'Name of the business owner or subject matter expert who has authority over the business meaning and usage of this term.',
    `calculation_formula` STRING COMMENT 'Mathematical or logical formula used to calculate or derive this term if it represents a metric or KPI. Example: GMROI = Gross Margin / Average Inventory Cost.',
    `change_log` STRING COMMENT 'Summary of changes made in this version of the glossary term. Documents evolution of the term definition over time.',
    `contains_financial_data` BOOLEAN COMMENT 'Boolean flag indicating whether this term represents financial data subject to accounting standards or financial reporting requirements.',
    `contains_pii` BOOLEAN COMMENT 'Boolean flag indicating whether this term represents or includes personally identifiable information subject to privacy regulations.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this glossary term record was first created in the system.',
    `criticality_level` STRING COMMENT 'Business criticality rating indicating the importance of this term to enterprise decision-making and regulatory compliance.. Valid values are `critical|high|medium|low`',
    `data_classification` STRING COMMENT 'Security classification level for data represented by this term. Indicates sensitivity and access control requirements.. Valid values are `restricted|confidential|internal|public`',
    `data_steward_email` STRING COMMENT 'Email address of the data steward responsible for this glossary term.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `data_steward_name` STRING COMMENT 'Name of the individual or role responsible for stewarding this glossary term, ensuring accuracy, consistency, and governance compliance.',
    `data_type` STRING COMMENT 'Expected data type for this term when represented in data products or analytics. Helps ensure consistent implementation across systems. [ENUM-REF-CANDIDATE: string|numeric|decimal|integer|date|timestamp|boolean — 7 candidates stripped; promote to reference product]',
    `effective_end_date` DATE COMMENT 'Date when this glossary term definition is no longer active. Null indicates the term is currently active.',
    `effective_start_date` DATE COMMENT 'Date from which this glossary term definition becomes active and should be used across the enterprise.',
    `is_active` BOOLEAN COMMENT 'Boolean flag indicating whether this glossary term is currently active and available for use. False indicates the term is deprecated or retired.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this glossary term record was last updated or modified.',
    `notes` STRING COMMENT 'Additional notes, clarifications, or context about the glossary term that do not fit in other structured fields.',
    `owning_domain` STRING COMMENT 'The primary data domain responsible for defining and maintaining this glossary term. Aligns with enterprise data domain taxonomy. [ENUM-REF-CANDIDATE: customer|product|inventory|order|store|supply_chain|pricing|promotion|workforce|supplier|finance|loyalty|ecommerce|distribution|merchandising|analytics — 16 candidates stripped; promote to reference product]',
    `regulatory_reference` STRING COMMENT 'Citation of regulatory standards, compliance frameworks, or industry guidelines that govern the definition or usage of this term. Example: GDPR Article 4, FASB ASC 606, PCI DSS.',
    `related_terms` STRING COMMENT 'Comma-separated list of related glossary term codes or names that have semantic relationships with this term. Helps users discover connected concepts.',
    `synonyms` STRING COMMENT 'Comma-separated list of alternative terms, aliases, or synonyms used across the organization that refer to the same concept. Example: Item, Product, Article for SKU.',
    `tags` STRING COMMENT 'Comma-separated list of user-defined tags or labels for categorization, search, and discovery. Example: retail, sales, inventory, compliance.',
    `technical_definition` STRING COMMENT 'Technical or data-centric definition describing how the term is calculated, derived, or represented in data systems.',
    `term_abbreviation` STRING COMMENT 'Standard abbreviation or acronym for the term. Example: SKU, SSS, GMROI, BOPIS, EDLP.',
    `term_category` STRING COMMENT 'Classification of the glossary term type. Indicates whether the term represents master data, transactional data, a metric, dimension, KPI, business rule, process, or system concept. [ENUM-REF-CANDIDATE: master_data|transactional_data|reference_data|metric|dimension|kpi|business_rule|process|system — 9 candidates stripped; promote to reference product]',
    `term_code` STRING COMMENT 'Short, unique alphanumeric code for the glossary term used for system references and lookups. Example: SKU_DEF, COMP_SALES, GMROI.. Valid values are `^[A-Z0-9_]{3,20}$`',
    `term_name` STRING COMMENT 'The official business term or phrase as used across the enterprise. Example: Stock Keeping Unit, Comparable Store Sales, Gross Margin Return on Investment.',
    `unit_of_measure` STRING COMMENT 'Standard unit of measure for this term if it represents a quantitative metric. Example: USD, Percent, Units, Days, Weeks.',
    `usage_example` STRING COMMENT 'Concrete example demonstrating how the term is used in business context, reports, or analytics. Provides clarity for end users.',
    `usage_frequency` STRING COMMENT 'Indicator of how frequently this term is used across reports, dashboards, and analytics products. Helps prioritize governance efforts.. Valid values are `high|medium|low`',
    `valid_values` STRING COMMENT 'Comma-separated list or description of valid values, ranges, or constraints for this term. Example: Active, Inactive, Suspended for Status terms.',
    `version_number` STRING COMMENT 'Version identifier for this glossary term definition. Incremented when the definition is updated. Example: 1.0, 2.1.. Valid values are `^[0-9]+.[0-9]+$`',
    CONSTRAINT pk_glossary_term PRIMARY KEY(`glossary_term_id`)
) COMMENT 'Master record for the enterprise business glossary defining standardized retail terminology used across analytics, reporting, and data products. Captures term name, business definition, synonyms, related terms, owning domain, data steward, usage examples, associated KPI or semantic metric references, approval status, and effective date. Ensures consistent interpretation of retail business concepts (e.g., Net Sales vs Gross Sales, Comp Store vs Non-Comp, Shrink vs Waste) across all analytics consumers.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` (
    `kpi_dimensionality_id` BIGINT COMMENT 'Unique identifier for this KPI-dimension configuration record. Primary key.',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to the KPI definition being configured for dimensional analysis',
    `metric_dimension_id` BIGINT COMMENT 'Foreign key linking to the metric dimension available for slicing this KPI',
    `aggregation_level` STRING COMMENT 'The aggregation method to apply when this KPI is sliced by this dimension (e.g., sum for additive metrics, average for ratios, none for pre-aggregated). Identified in detection phase relationship data.',
    `configuration_notes` STRING COMMENT 'Free-text notes explaining why this dimension is configured for this KPI, any special handling, or business context.',
    `configured_by` STRING COMMENT 'Name or identifier of the BI team member or data steward who configured this KPI-dimension pairing.',
    `default_filter_value` DECIMAL(18,2) COMMENT 'Optional default filter value to apply for this dimension when this KPI is first loaded (e.g., current_year for time dimension, flagship_stores for store dimension). Identified in detection phase relationship data.',
    `dimension_value_filter` STRING COMMENT 'Optional filter expression limiting which dimension members are valid for this KPI (e.g., only active stores, only product categories with inventory). Identified in detection phase relationship data.',
    `dimensionality` STRING COMMENT 'The business dimensions by which this KPI can be sliced and analyzed (e.g., Store, Product Category, Time Period, Customer Segment, Channel). Comma-separated list of applicable dimensions. [Moved from kpi_definition: The dimensionality attribute in kpi_definition is a text description of which dimensions apply to the KPI. This should be replaced by the explicit M:N relationship captured in kpi_dimensionality, where each valid dimension is a separate record with its own configuration.]',
    `display_format` STRING COMMENT 'Optional display format override for this dimension when used with this specific KPI (e.g., abbreviated store names for space-constrained dashboards). Identified in detection phase relationship data.',
    `drill_enabled` BOOLEAN COMMENT 'Boolean flag indicating whether drill-down operations are enabled for this KPI along this dimension hierarchy. Identified in detection phase relationship data.',
    `effective_end_date` DATE COMMENT 'The date on which this KPI-dimension configuration ceased to be effective. Null if currently active.',
    `effective_start_date` DATE COMMENT 'The date from which this KPI-dimension configuration became effective and available for use.',
    `is_active` BOOLEAN COMMENT 'Boolean flag indicating whether this KPI-dimension configuration is currently active and available in BI tools.',
    `is_required_dimension` BOOLEAN COMMENT 'Boolean flag indicating whether this dimension MUST be included when querying this KPI (e.g., time period is required for all temporal KPIs).',
    `sort_order` STRING COMMENT 'The display order of this dimension when presenting this KPI in BI tools and dashboards. Lower numbers appear first. Identified in detection phase relationship data.',
    CONSTRAINT pk_kpi_dimensionality PRIMARY KEY(`kpi_dimensionality_id`)
) COMMENT 'This association product represents the configuration relationship between KPI definitions and the metric dimensions by which they can be sliced and analyzed. It captures the explicit business rules governing which dimensions are available for each KPI, how they aggregate, and their display behavior in BI tools. Each record links one KPI definition to one metric dimension with configuration attributes that exist only in the context of this specific KPI-dimension pairing.. Existence Justification: In retail analytics operations, BI teams actively configure which dimensions are available for each KPI, how they aggregate, their display order, and drill-down behavior. This is not a derived analytical correlation but an explicit configuration that semantic layer architects manage as part of OLAP cube design and BI tool setup. The business recognizes this as KPI dimensionality configuration - a managed artifact that determines how business users can slice and filter metrics.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`report_composition` (
    `report_composition_id` BIGINT COMMENT 'Unique identifier for this report-KPI composition record. Primary key.',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to the KPI definition that is included in this report composition',
    `report_definition_id` BIGINT COMMENT 'Foreign key linking to the report definition that contains this KPI',
    `added_date` DATE COMMENT 'Date when this KPI was added to this report definition. Used for tracking report evolution and composition history.',
    `composition_status` STRING COMMENT 'Current status of this KPI within this report: active (currently displayed), deprecated (scheduled for removal), testing (under evaluation). Supports report composition lifecycle management.',
    `conditional_formatting_rules` STRING COMMENT 'JSON or structured string defining the conditional formatting logic for this KPI in this report (e.g., color coding rules, threshold-based highlighting). Allows report-specific visual treatment of the same KPI.',
    `configured_by` STRING COMMENT 'Username or email of the BI analyst or report owner who configured this KPI for inclusion in this report. Used for governance and change tracking.',
    `display_order` STRING COMMENT 'The sequential position in which this KPI appears within the report layout. Used by BI tools to render KPIs in the intended business sequence.',
    `drill_down_enabled` BOOLEAN COMMENT 'Flag indicating whether drill-down functionality is enabled for this KPI in this report context. The same KPI may allow drill-down in some reports but not others based on audience and use case.',
    `filter_defaults` STRING COMMENT 'JSON or structured string defining the default filter values applied to this KPI when the report is opened (e.g., {"region": "Northeast", "time_period": "last_30_days"}). Enables report-specific pre-filtering of KPI data.',
    `is_primary_metric` BOOLEAN COMMENT 'Flag indicating whether this KPI is designated as a primary or headline metric for this report. Primary metrics may receive special visual treatment or positioning.',
    `removed_date` DATE COMMENT 'Date when this KPI was removed from this report definition. Nullable for active KPIs. Enables historical tracking of report composition changes.',
    `section_name` STRING COMMENT 'The named section or tab within the report where this KPI is displayed (e.g., "Executive Summary", "Store Performance", "Financial Metrics"). Used to organize KPIs into logical groupings within multi-section reports.',
    `target_threshold_override` DECIMAL(18,2) COMMENT 'Report-specific override of the KPIs default target threshold value. Allows different reports to apply different performance targets for the same KPI based on audience or business context. Nullable if using the KPIs default target.',
    `visualization_type` STRING COMMENT 'The chart or visualization format used to display this KPI in this specific report context (e.g., table, line_chart, bar_chart, gauge, scorecard). The same KPI may be visualized differently across different reports.',
    CONSTRAINT pk_report_composition PRIMARY KEY(`report_composition_id`)
) COMMENT 'This association product represents the configuration relationship between KPI definitions and report definitions in the retail analytics catalog. It captures how KPIs are composed into reports with report-specific presentation rules, display ordering, visualization preferences, and threshold overrides. Each record links one KPI definition to one report definition with attributes that control how that specific KPI appears and behaves within that specific report context.. Existence Justification: In retail analytics operations, BI teams actively manage the composition of reports by selecting which KPIs to include, configuring how each KPI is visualized, setting display order, and defining report-specific presentation rules. A single KPI (e.g., Comparable Store Sales) appears in multiple reports (Executive Dashboard, Store Operations Report, Regional Performance Report) with different visualizations, thresholds, and filters. Conversely, each report contains multiple KPIs arranged in a specific sequence with report-specific configuration. This is an operational configuration activity managed through BI catalog tools, not an analytical correlation.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`metric_entity_dependency` (
    `metric_entity_dependency_id` BIGINT COMMENT 'Unique identifier for this metric-entity dependency record. Primary key.',
    `semantic_layer_entity_id` BIGINT COMMENT 'Foreign key linking to the semantic layer entity that this metric depends on for calculation',
    `semantic_metric_id` BIGINT COMMENT 'Foreign key linking to the semantic metric that consumes this entity in its calculation',
    `aggregation_role` STRING COMMENT 'The role this entity plays in the metric calculation: BASE_MEASURE (provides the fact to aggregate), DIMENSION (provides grouping/slicing attributes), FILTER (used only for filtering), GROUPING (defines the grain of aggregation).',
    `calculation_order` STRING COMMENT 'Numeric sequence indicating the order in which this entity is joined or processed in the metric calculation. Lower numbers are processed first. Used for complex multi-step metric calculations.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this metric-entity dependency was first defined in the semantic layer platform. Tracks when the relationship was established.',
    `dependency_type` STRING COMMENT 'Classification of the dependency relationship: DIRECT (entity is explicitly referenced in metric definition), INDIRECT (entity is required through transitive dependency), DERIVED (entity is computed from other entities for this metric).',
    `entity_alias` STRING COMMENT 'The alias or reference name used for this entity within the metric calculation expression. Used when the same entity is referenced multiple times with different join paths or filters.',
    `filter_expression` STRING COMMENT 'SQL WHERE clause or semantic layer filter logic applied specifically to this entity when used in this metric calculation. Defines the subset of entity data included in the metric.',
    `is_required_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this entity dependency is mandatory for the metric calculation. True = metric cannot be calculated without this entity; False = entity is optional or conditional.',
    `join_condition` STRING COMMENT 'SQL join condition or semantic layer join expression that defines how this entity is joined to other entities in the metric calculation. Captures the ON clause logic.',
    `join_type` STRING COMMENT 'SQL join type used to connect this entity to the metric calculation (INNER, LEFT, RIGHT, FULL, CROSS). Defines how the entity participates in the metric query generation.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this dependency configuration (join logic, filter, role). Used for change tracking and impact analysis.',
    `modified_by` STRING COMMENT 'Identifier of the analytics engineer or data steward who last modified this dependency configuration. Used for governance and accountability.',
    CONSTRAINT pk_metric_entity_dependency PRIMARY KEY(`metric_entity_dependency_id`)
) COMMENT 'This association product represents the metadata lineage relationship between semantic metrics and the semantic layer entities they depend on for calculation. It captures the technical join configuration, filter logic, and aggregation behavior required to compute each metric from its constituent entities. Each record links one semantic metric to one semantic layer entity with attributes that define how the entity participates in the metric calculation within the BI semantic layer platform.. Existence Justification: In retail semantic layer platforms (Looker, dbt Semantic Layer, Databricks Unity Catalog), metrics explicitly depend on multiple entities for calculation (e.g., a Gross Margin % metric requires sales_fact, product_dim, and cost_dim entities), and entities are reused across many metrics. The business actively manages these dependencies as metadata configurations that drive BI query generation, defining join paths, filter logic, and aggregation roles for each metric-entity pair.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` (
    `sla_kpi_measurement_id` BIGINT COMMENT 'Unique surrogate identifier for this SLA-KPI measurement binding record. Primary key.',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to the enterprise KPI definition used to measure this SLA',
    `sla_definition_id` BIGINT COMMENT 'Foreign key linking to the supply chain SLA being measured',
    `alert_threshold_value` DECIMAL(18,2) COMMENT 'An early-warning threshold value that triggers alerts before the breach threshold is reached. Allows proactive intervention when KPI performance is trending toward SLA breach.',
    `breach_penalty_rate` DECIMAL(18,2) COMMENT 'The penalty rate applied when this specific KPI breaches the threshold for this specific SLA. Expressed as a percentage or per-unit rate depending on the SLAs penalty structure type. Allows different KPIs measuring the same SLA to have different penalty consequences.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this measurement binding was created in the SLA management system.',
    `effective_end_date` DATE COMMENT 'The date on which this KPI-SLA measurement binding ceases to be active. Nullable for ongoing measurements. Supports historical tracking of which KPIs were used to measure which SLAs at different points in time.',
    `effective_start_date` DATE COMMENT 'The date on which this KPI-SLA measurement binding becomes active. Allows the measurement framework to evolve over time as KPIs are added or removed from SLA scorecards.',
    `is_primary_kpi` BOOLEAN COMMENT 'Indicates whether this KPI is the primary/lead metric for this SLA (true) or a supporting/secondary metric (false). Used to distinguish the main performance indicator from supplementary metrics.',
    `last_modified_by` STRING COMMENT 'User ID or email of the user who last modified this measurement binding configuration.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent modification to this measurement binding.',
    `measurement_frequency` STRING COMMENT 'How often this specific KPI is calculated and evaluated against this specific SLA. May differ from the KPIs default reporting frequency or the SLAs default measurement frequency when this combination requires special handling.',
    `measurement_status` STRING COMMENT 'Current operational status of this KPI-SLA measurement binding. Active means currently in use; Suspended means temporarily disabled; Under Review means being evaluated for changes; Deprecated means no longer used but retained for historical reference.',
    `measurement_weight` DECIMAL(18,2) COMMENT 'The relative weight or importance of this KPI in the overall SLA performance scorecard, expressed as a decimal (e.g., 0.30 for 30%). Used when multiple KPIs contribute to a composite SLA score.',
    `measurement_window_days` STRING COMMENT 'Rolling number of days over which this KPI is aggregated when evaluating this SLA. May differ from the SLAs default measurement window when this specific KPI requires different temporal aggregation.',
    `threshold_value` DECIMAL(18,2) COMMENT 'The target threshold value for this KPI when measuring this specific SLA. This is the SLA-KPI-specific threshold that may differ from the KPIs enterprise-wide target_threshold_value or the SLAs generic target_threshold_value, allowing customization per measurement context.',
    `created_by` STRING COMMENT 'User ID or email of the supply chain analyst or SLA manager who created this KPI-SLA measurement binding.',
    CONSTRAINT pk_sla_kpi_measurement PRIMARY KEY(`sla_kpi_measurement_id`)
) COMMENT 'This association product represents the measurement contract between supply chain SLA definitions and enterprise KPI definitions. It captures the specific measurement parameters, thresholds, and penalty structures that apply when a particular KPI is used to evaluate a particular SLA. Each record links one SLA definition to one KPI definition with measurement-specific attributes that exist only in the context of this monitoring relationship.. Existence Justification: In retail supply chain operations, a single SLA (e.g., Supplier Fill Rate SLA) is measured by multiple KPIs (fill rate percentage, order completeness count, line item accuracy), and each enterprise KPI (e.g., On-Time Delivery %) is used to measure multiple SLAs across different suppliers, product categories, and distribution centers. The business actively manages SLA performance scorecards where each KPI-SLA pairing has its own measurement frequency, threshold, penalty rate, and effective dates.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`analytics`.`workspace` (
    `workspace_id` BIGINT COMMENT 'Primary key for workspace',
    `access_policy_id` BIGINT COMMENT 'Foreign key linking to analytics.access_policy. Business justification: Workspaces require access control to govern who can access workspace resources. This FK links workspace to its governing access_policy, consistent with the pattern where dashboard_config and report_su',
    `account_id` BIGINT COMMENT 'Identifier of the billing account responsible for workspace-related charges.',
    `org_unit_id` BIGINT COMMENT 'Identifier of the business unit to which this workspace is assigned.',
    `department_id` BIGINT COMMENT 'Identifier of the department that owns and manages this workspace.',
    `parent_workspace_id` BIGINT COMMENT 'Self-referencing FK on workspace (parent_workspace_id)',
    `access_level` STRING COMMENT 'Security classification level that determines who can access this workspace.',
    `activation_date` DATE COMMENT 'Date when the workspace was activated and made available for use.',
    `archive_after_days` STRING COMMENT 'Number of days of inactivity after which workspace content is automatically archived.',
    `archived_date` DATE COMMENT 'Date when the workspace was archived and moved to inactive status.',
    `asset_count` STRING COMMENT 'Total number of data assets, reports, dashboards, or other objects contained within this workspace.',
    `auto_archive_enabled` BOOLEAN COMMENT 'Indicates whether automatic archiving of inactive workspace content is enabled.',
    `workspace_code` STRING COMMENT 'Unique business identifier code for the workspace, used for external references and integrations.',
    `compliance_framework` STRING COMMENT 'Regulatory or compliance framework that governs this workspace, such as GDPR, CCPA, SOX, or HIPAA. [ENUM-REF-CANDIDATE: GDPR|CCPA|SOX|HIPAA|PCI-DSS|ISO-27001|NIST — promote to reference product]',
    `cost_center_code` STRING COMMENT 'Financial cost center code to which workspace expenses are allocated.',
    `created_by_user_code` BIGINT COMMENT 'Identifier of the user who created this workspace.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the workspace was initially created in the system.',
    `data_residency_country` STRING COMMENT 'Three-letter country code indicating where workspace data must be stored for compliance purposes.',
    `workspace_description` STRING COMMENT 'Detailed description of the workspace purpose, scope, and intended use cases.',
    `environment_type` STRING COMMENT 'Classification of the workspace based on its intended environment usage.',
    `expiration_date` DATE COMMENT 'Date when the workspace is scheduled to expire or be decommissioned.',
    `is_active` BOOLEAN COMMENT 'Indicates whether the workspace is currently active and available for use.',
    `is_default` BOOLEAN COMMENT 'Indicates whether this workspace is the default workspace for new users or specific user groups.',
    `is_template` BOOLEAN COMMENT 'Indicates whether this workspace serves as a template for creating new workspaces.',
    `last_accessed_timestamp` TIMESTAMP COMMENT 'Timestamp when the workspace was last accessed by any user.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the workspace configuration or content was last modified.',
    `max_member_limit` STRING COMMENT 'Maximum number of users allowed to be members of this workspace.',
    `member_count` STRING COMMENT 'Total number of users who have access to this workspace.',
    `modified_by_user_code` BIGINT COMMENT 'Identifier of the user who last modified this workspace configuration.',
    `workspace_name` STRING COMMENT 'Human-readable name of the workspace used for identification and display purposes.',
    `notes` STRING COMMENT 'Free-form text field for additional notes, comments, or special instructions related to the workspace.',
    `owner_user_code` BIGINT COMMENT 'Identifier of the user who owns and is responsible for this workspace.',
    `priority_level` STRING COMMENT 'Business priority level assigned to this workspace for resource allocation and support purposes.',
    `region_code` STRING COMMENT 'Three-letter code representing the geographic region where this workspace data is stored.',
    `retention_policy_days` STRING COMMENT 'Number of days that data within this workspace must be retained before it can be purged.',
    `storage_quota_gb` DECIMAL(18,2) COMMENT 'Maximum storage capacity allocated to this workspace measured in gigabytes.',
    `storage_used_gb` DECIMAL(18,2) COMMENT 'Current amount of storage consumed by this workspace measured in gigabytes.',
    `tags` STRING COMMENT 'Comma-separated list of tags or labels applied to this workspace for categorization and search purposes.',
    `template_source_code` BIGINT COMMENT 'Identifier of the template workspace from which this workspace was created, if applicable.',
    `visibility_scope` STRING COMMENT 'Defines the organizational scope within which this workspace is visible and discoverable.',
    `workspace_status` STRING COMMENT 'Current lifecycle status of the workspace indicating its operational state.',
    `workspace_type` STRING COMMENT 'Classification of the workspace based on its scope and intended use within the organization.',
    CONSTRAINT pk_workspace PRIMARY KEY(`workspace_id`)
) COMMENT 'Master reference table for workspace. Referenced by workspace_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ADD CONSTRAINT `fk_analytics_kpi_definition_parent_kpi_definition_id` FOREIGN KEY (`parent_kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_prior_period_kpi_value_id` FOREIGN KEY (`prior_period_kpi_value_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_value`(`kpi_value_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_reporting_hierarchy_id` FOREIGN KEY (`reporting_hierarchy_id`) REFERENCES `vibe_retail_v1`.`analytics`.`reporting_hierarchy`(`reporting_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_retail_calendar_id` FOREIGN KEY (`retail_calendar_id`) REFERENCES `vibe_retail_v1`.`analytics`.`retail_calendar`(`retail_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_semantic_layer_entity_id` FOREIGN KEY (`semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ADD CONSTRAINT `fk_analytics_report_definition_parent_report_definition_id` FOREIGN KEY (`parent_report_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`report_definition`(`report_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ADD CONSTRAINT `fk_analytics_report_definition_semantic_layer_entity_id` FOREIGN KEY (`semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ADD CONSTRAINT `fk_analytics_report_definition_semantic_metric_id` FOREIGN KEY (`semantic_metric_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_metric`(`semantic_metric_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ADD CONSTRAINT `fk_analytics_dashboard_config_access_policy_id` FOREIGN KEY (`access_policy_id`) REFERENCES `vibe_retail_v1`.`analytics`.`access_policy`(`access_policy_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ADD CONSTRAINT `fk_analytics_dashboard_config_cloned_from_dashboard_config_id` FOREIGN KEY (`cloned_from_dashboard_config_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dashboard_config`(`dashboard_config_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ADD CONSTRAINT `fk_analytics_dashboard_widget_dashboard_config_id` FOREIGN KEY (`dashboard_config_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dashboard_config`(`dashboard_config_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ADD CONSTRAINT `fk_analytics_dashboard_widget_dq_rule_id` FOREIGN KEY (`dq_rule_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dq_rule`(`dq_rule_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ADD CONSTRAINT `fk_analytics_dashboard_widget_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ADD CONSTRAINT `fk_analytics_dashboard_widget_parent_dashboard_widget_id` FOREIGN KEY (`parent_dashboard_widget_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dashboard_widget`(`dashboard_widget_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ADD CONSTRAINT `fk_analytics_dashboard_widget_report_definition_id` FOREIGN KEY (`report_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`report_definition`(`report_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ADD CONSTRAINT `fk_analytics_dashboard_widget_semantic_layer_entity_id` FOREIGN KEY (`semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` ADD CONSTRAINT `fk_analytics_metric_dimension_parent_metric_dimension_id` FOREIGN KEY (`parent_metric_dimension_id`) REFERENCES `vibe_retail_v1`.`analytics`.`metric_dimension`(`metric_dimension_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` ADD CONSTRAINT `fk_analytics_metric_dimension_primary_replacement_metric_dimension_id` FOREIGN KEY (`primary_replacement_metric_dimension_id`) REFERENCES `vibe_retail_v1`.`analytics`.`metric_dimension`(`metric_dimension_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` ADD CONSTRAINT `fk_analytics_dq_rule_parent_dq_rule_id` FOREIGN KEY (`parent_dq_rule_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dq_rule`(`dq_rule_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` ADD CONSTRAINT `fk_analytics_dq_rule_semantic_layer_entity_id` FOREIGN KEY (`semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ADD CONSTRAINT `fk_analytics_dq_result_dq_rule_id` FOREIGN KEY (`dq_rule_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dq_rule`(`dq_rule_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ADD CONSTRAINT `fk_analytics_dq_result_previous_dq_result_id` FOREIGN KEY (`previous_dq_result_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dq_result`(`dq_result_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ADD CONSTRAINT `fk_analytics_dq_result_retail_calendar_id` FOREIGN KEY (`retail_calendar_id`) REFERENCES `vibe_retail_v1`.`analytics`.`retail_calendar`(`retail_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ADD CONSTRAINT `fk_analytics_dq_result_semantic_layer_entity_id` FOREIGN KEY (`semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ADD CONSTRAINT `fk_analytics_dq_issue_dq_result_id` FOREIGN KEY (`dq_result_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dq_result`(`dq_result_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ADD CONSTRAINT `fk_analytics_dq_issue_dq_rule_id` FOREIGN KEY (`dq_rule_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dq_rule`(`dq_rule_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ADD CONSTRAINT `fk_analytics_dq_issue_parent_dq_issue_id` FOREIGN KEY (`parent_dq_issue_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dq_issue`(`dq_issue_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ADD CONSTRAINT `fk_analytics_semantic_layer_entity_parent_semantic_layer_entity_id` FOREIGN KEY (`parent_semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ADD CONSTRAINT `fk_analytics_semantic_layer_entity_primary_replacement_semantic_layer_entity_id` FOREIGN KEY (`primary_replacement_semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ADD CONSTRAINT `fk_analytics_semantic_metric_derived_from_semantic_metric_id` FOREIGN KEY (`derived_from_semantic_metric_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_metric`(`semantic_metric_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ADD CONSTRAINT `fk_analytics_semantic_metric_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ADD CONSTRAINT `fk_analytics_report_subscription_access_policy_id` FOREIGN KEY (`access_policy_id`) REFERENCES `vibe_retail_v1`.`analytics`.`access_policy`(`access_policy_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ADD CONSTRAINT `fk_analytics_report_subscription_dashboard_config_id` FOREIGN KEY (`dashboard_config_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dashboard_config`(`dashboard_config_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ADD CONSTRAINT `fk_analytics_report_subscription_report_definition_id` FOREIGN KEY (`report_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`report_definition`(`report_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ADD CONSTRAINT `fk_analytics_report_subscription_superseded_report_subscription_id` FOREIGN KEY (`superseded_report_subscription_id`) REFERENCES `vibe_retail_v1`.`analytics`.`report_subscription`(`report_subscription_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`access_policy` ADD CONSTRAINT `fk_analytics_access_policy_parent_access_policy_id` FOREIGN KEY (`parent_access_policy_id`) REFERENCES `vibe_retail_v1`.`analytics`.`access_policy`(`access_policy_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ADD CONSTRAINT `fk_analytics_retail_calendar_prior_year_retail_calendar_id` FOREIGN KEY (`prior_year_retail_calendar_id`) REFERENCES `vibe_retail_v1`.`analytics`.`retail_calendar`(`retail_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`reporting_hierarchy` ADD CONSTRAINT `fk_analytics_reporting_hierarchy_parent_reporting_hierarchy_id` FOREIGN KEY (`parent_reporting_hierarchy_id`) REFERENCES `vibe_retail_v1`.`analytics`.`reporting_hierarchy`(`reporting_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_reporting_hierarchy_id` FOREIGN KEY (`reporting_hierarchy_id`) REFERENCES `vibe_retail_v1`.`analytics`.`reporting_hierarchy`(`reporting_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_retail_calendar_id` FOREIGN KEY (`retail_calendar_id`) REFERENCES `vibe_retail_v1`.`analytics`.`retail_calendar`(`retail_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_revised_analytics_kpi_target_id` FOREIGN KEY (`revised_analytics_kpi_target_id`) REFERENCES `vibe_retail_v1`.`analytics`.`analytics_kpi_target`(`analytics_kpi_target_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_semantic_layer_entity_id` FOREIGN KEY (`semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_access_policy_id` FOREIGN KEY (`access_policy_id`) REFERENCES `vibe_retail_v1`.`analytics`.`access_policy`(`access_policy_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_dq_result_id` FOREIGN KEY (`dq_result_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dq_result`(`dq_result_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_escalated_from_alert_id` FOREIGN KEY (`escalated_from_alert_id`) REFERENCES `vibe_retail_v1`.`analytics`.`alert`(`alert_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_reporting_hierarchy_id` FOREIGN KEY (`reporting_hierarchy_id`) REFERENCES `vibe_retail_v1`.`analytics`.`reporting_hierarchy`(`reporting_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_retail_calendar_id` FOREIGN KEY (`retail_calendar_id`) REFERENCES `vibe_retail_v1`.`analytics`.`retail_calendar`(`retail_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_semantic_layer_entity_id` FOREIGN KEY (`semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ADD CONSTRAINT `fk_analytics_self_service_query_access_policy_id` FOREIGN KEY (`access_policy_id`) REFERENCES `vibe_retail_v1`.`analytics`.`access_policy`(`access_policy_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ADD CONSTRAINT `fk_analytics_self_service_query_dashboard_config_id` FOREIGN KEY (`dashboard_config_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dashboard_config`(`dashboard_config_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ADD CONSTRAINT `fk_analytics_self_service_query_forked_from_self_service_query_id` FOREIGN KEY (`forked_from_self_service_query_id`) REFERENCES `vibe_retail_v1`.`analytics`.`self_service_query`(`self_service_query_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ADD CONSTRAINT `fk_analytics_self_service_query_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ADD CONSTRAINT `fk_analytics_self_service_query_report_definition_id` FOREIGN KEY (`report_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`report_definition`(`report_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ADD CONSTRAINT `fk_analytics_self_service_query_semantic_layer_entity_id` FOREIGN KEY (`semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ADD CONSTRAINT `fk_analytics_self_service_query_semantic_metric_id` FOREIGN KEY (`semantic_metric_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_metric`(`semantic_metric_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ADD CONSTRAINT `fk_analytics_self_service_query_workspace_id` FOREIGN KEY (`workspace_id`) REFERENCES `vibe_retail_v1`.`analytics`.`workspace`(`workspace_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ADD CONSTRAINT `fk_analytics_glossary_term_dashboard_config_id` FOREIGN KEY (`dashboard_config_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dashboard_config`(`dashboard_config_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ADD CONSTRAINT `fk_analytics_glossary_term_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ADD CONSTRAINT `fk_analytics_glossary_term_metric_dimension_id` FOREIGN KEY (`metric_dimension_id`) REFERENCES `vibe_retail_v1`.`analytics`.`metric_dimension`(`metric_dimension_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ADD CONSTRAINT `fk_analytics_glossary_term_parent_glossary_term_id` FOREIGN KEY (`parent_glossary_term_id`) REFERENCES `vibe_retail_v1`.`analytics`.`glossary_term`(`glossary_term_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ADD CONSTRAINT `fk_analytics_glossary_term_report_definition_id` FOREIGN KEY (`report_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`report_definition`(`report_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ADD CONSTRAINT `fk_analytics_glossary_term_semantic_layer_entity_id` FOREIGN KEY (`semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ADD CONSTRAINT `fk_analytics_glossary_term_semantic_metric_id` FOREIGN KEY (`semantic_metric_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_metric`(`semantic_metric_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` ADD CONSTRAINT `fk_analytics_kpi_dimensionality_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` ADD CONSTRAINT `fk_analytics_kpi_dimensionality_metric_dimension_id` FOREIGN KEY (`metric_dimension_id`) REFERENCES `vibe_retail_v1`.`analytics`.`metric_dimension`(`metric_dimension_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_composition` ADD CONSTRAINT `fk_analytics_report_composition_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_composition` ADD CONSTRAINT `fk_analytics_report_composition_report_definition_id` FOREIGN KEY (`report_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`report_definition`(`report_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_entity_dependency` ADD CONSTRAINT `fk_analytics_metric_entity_dependency_semantic_layer_entity_id` FOREIGN KEY (`semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_entity_dependency` ADD CONSTRAINT `fk_analytics_metric_entity_dependency_semantic_metric_id` FOREIGN KEY (`semantic_metric_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_metric`(`semantic_metric_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ADD CONSTRAINT `fk_analytics_sla_kpi_measurement_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`workspace` ADD CONSTRAINT `fk_analytics_workspace_access_policy_id` FOREIGN KEY (`access_policy_id`) REFERENCES `vibe_retail_v1`.`analytics`.`access_policy`(`access_policy_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`workspace` ADD CONSTRAINT `fk_analytics_workspace_parent_workspace_id` FOREIGN KEY (`parent_workspace_id`) REFERENCES `vibe_retail_v1`.`analytics`.`workspace`(`workspace_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`analytics` SET TAGS ('dbx_division' = 'corporate');
ALTER SCHEMA `vibe_retail_v1`.`analytics` SET TAGS ('dbx_domain' = 'analytics');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` SET TAGS ('dbx_subdomain' = 'performance_measurement');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) Definition ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Store Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `member_segment_id` SET TAGS ('dbx_business_glossary_term' = 'Member Segment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'draft|pending_review|approved|deprecated|retired');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `bi_tool_integration` SET TAGS ('dbx_business_glossary_term' = 'Business Intelligence (BI) Tool Integration');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `data_type` SET TAGS ('dbx_value_regex' = 'decimal|integer|percentage|boolean');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `kpi_code` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) Code');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `kpi_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `kpi_description` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) Description');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `kpi_name` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) Name');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `precision_scale` SET TAGS ('dbx_business_glossary_term' = 'Precision and Scale');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `steward_email` SET TAGS ('dbx_business_glossary_term' = 'Data Steward Email Address');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `steward_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `steward_name` SET TAGS ('dbx_business_glossary_term' = 'Data Steward Name');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `trend_direction` SET TAGS ('dbx_value_regex' = 'higher_is_better|lower_is_better|target_is_optimal|neutral');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` SET TAGS ('dbx_subdomain' = 'performance_measurement');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `kpi_value_id` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) Value ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `cycle_count_id` SET TAGS ('dbx_business_glossary_term' = 'Cycle Count Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `demand_forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Demand Forecast Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Store Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `disposition_id` SET TAGS ('dbx_business_glossary_term' = 'Disposition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `engagement_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Engagement Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Fulfillment Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `fulfillment_order_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) Definition ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `liquidation_batch_id` SET TAGS ('dbx_business_glossary_term' = 'Liquidation Batch Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Membership Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `markdown_id` SET TAGS ('dbx_business_glossary_term' = 'Markdown Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `member_segment_id` SET TAGS ('dbx_business_glossary_term' = 'Member Segment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `price_change_id` SET TAGS ('dbx_business_glossary_term' = 'Price Change Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `replenishment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `reporting_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Reporting Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `retail_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Retail Calendar Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `return_request_id` SET TAGS ('dbx_business_glossary_term' = 'Return Request Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `rma_id` SET TAGS ('dbx_business_glossary_term' = 'Returns Rma Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `sku_price_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `stock_ledger_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Ledger Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `stock_position_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Position Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `alert_severity` SET TAGS ('dbx_value_regex' = 'info|warning|critical|none');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'draft|pending_review|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `calculation_method` SET TAGS ('dbx_value_regex' = 'computed|ingested|manual|aggregated');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `confidence_interval_lower` SET TAGS ('dbx_business_glossary_term' = 'Confidence Interval Lower Bound');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `confidence_interval_upper` SET TAGS ('dbx_business_glossary_term' = 'Confidence Interval Upper Bound');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `is_forecast` SET TAGS ('dbx_business_glossary_term' = 'Is Forecast Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `performance_status` SET TAGS ('dbx_value_regex' = 'exceeds_target|meets_target|below_target|critical|not_applicable');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `period_type` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|quarterly|yearly|custom');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `trend_direction` SET TAGS ('dbx_value_regex' = 'improving|stable|declining|volatile|insufficient_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` SET TAGS ('dbx_subdomain' = 'reporting_governance');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `semantic_layer_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Semantic Layer Entity Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `semantic_metric_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Semantic Metric Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `average_execution_time_seconds` SET TAGS ('dbx_business_glossary_term' = 'Average Execution Time (Seconds)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `contains_pii` SET TAGS ('dbx_business_glossary_term' = 'Contains Personally Identifiable Information (PII)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `documentation_url` SET TAGS ('dbx_business_glossary_term' = 'Documentation Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `governance_classification` SET TAGS ('dbx_value_regex' = 'public|internal|confidential|restricted');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `kpi_count` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) Count');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `report_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `report_owner_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `report_status` SET TAGS ('dbx_value_regex' = 'draft|active|deprecated|retired|suspended');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `report_type` SET TAGS ('dbx_value_regex' = 'operational|financial|executive|regulatory|analytical|adhoc');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `report_url` SET TAGS ('dbx_business_glossary_term' = 'Report Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `tags` SET TAGS ('dbx_business_glossary_term' = 'Report Tags');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+.[0-9]+$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` SET TAGS ('dbx_subdomain' = 'reporting_governance');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `dashboard_config_id` SET TAGS ('dbx_business_glossary_term' = 'Dashboard Configuration ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `access_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Analytics Access Policy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `access_tier` SET TAGS ('dbx_value_regex' = 'public|internal|restricted|confidential');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `bi_platform` SET TAGS ('dbx_business_glossary_term' = 'Business Intelligence (BI) Platform');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `certification_status` SET TAGS ('dbx_value_regex' = 'certified|pending_certification|not_certified');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `dashboard_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `dashboard_owner_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `dashboard_type` SET TAGS ('dbx_value_regex' = 'operational|strategic|analytical|tactical|executive|compliance');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `embedded_kpi_references` SET TAGS ('dbx_business_glossary_term' = 'Embedded Key Performance Indicator (KPI) References');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `export_enabled` SET TAGS ('dbx_business_glossary_term' = 'Export Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `mobile_enabled` SET TAGS ('dbx_business_glossary_term' = 'Mobile Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `publication_status` SET TAGS ('dbx_value_regex' = 'draft|in_review|published|archived|deprecated');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `refresh_schedule` SET TAGS ('dbx_value_regex' = 'real_time|hourly|daily|weekly|monthly|on_demand');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `subscription_enabled` SET TAGS ('dbx_business_glossary_term' = 'Subscription Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `tags` SET TAGS ('dbx_business_glossary_term' = 'Dashboard Tags');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `technical_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `thumbnail_url` SET TAGS ('dbx_business_glossary_term' = 'Thumbnail Image Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `url` SET TAGS ('dbx_business_glossary_term' = 'Dashboard Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_config` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+.[0-9]+$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` SET TAGS ('dbx_subdomain' = 'reporting_governance');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `audit_event_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Event Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Owner User ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `dashboard_config_id` SET TAGS ('dbx_business_glossary_term' = 'Dashboard ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `dashboard_created_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `dashboard_modified_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `dq_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Data Quality Rule ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `semantic_layer_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Semantic Layer Entity Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `dashboard_widget_status` SET TAGS ('dbx_business_glossary_term' = 'Widget Status');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `dashboard_widget_status` SET TAGS ('dbx_value_regex' = 'active|inactive|draft|archived|deprecated');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `dashboard_widget_description` SET TAGS ('dbx_business_glossary_term' = 'Widget Description');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `drill_through_enabled` SET TAGS ('dbx_business_glossary_term' = 'Drill-Through Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `drill_through_target` SET TAGS ('dbx_business_glossary_term' = 'Drill-Through Target');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `export_enabled` SET TAGS ('dbx_business_glossary_term' = 'Export Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `filter_enabled` SET TAGS ('dbx_business_glossary_term' = 'Filter Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `height` SET TAGS ('dbx_business_glossary_term' = 'Widget Height');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `position_x` SET TAGS ('dbx_business_glossary_term' = 'Position X Coordinate');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `position_y` SET TAGS ('dbx_business_glossary_term' = 'Position Y Coordinate');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `refresh_behavior` SET TAGS ('dbx_value_regex' = 'manual|auto|on_load|scheduled');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `tags` SET TAGS ('dbx_business_glossary_term' = 'Widget Tags');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `visibility_scope` SET TAGS ('dbx_value_regex' = 'public|private|role_based|user_specific');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `widget_type` SET TAGS ('dbx_value_regex' = 'chart|table|scorecard|map|sparkline|gauge');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ALTER COLUMN `width` SET TAGS ('dbx_business_glossary_term' = 'Widget Width');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` SET TAGS ('dbx_subdomain' = 'semantic_catalog');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` ALTER COLUMN `metric_dimension_id` SET TAGS ('dbx_business_glossary_term' = 'Metric Dimension Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` ALTER COLUMN `primary_replacement_metric_dimension_id` SET TAGS ('dbx_business_glossary_term' = 'Replacement Dimension Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` ALTER COLUMN `default_aggregation` SET TAGS ('dbx_business_glossary_term' = 'Default Aggregation Method');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` ALTER COLUMN `dimension_type` SET TAGS ('dbx_value_regex' = 'conformed|degenerate|role_playing|junk|slowly_changing|outrigger');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` ALTER COLUMN `drill_enabled` SET TAGS ('dbx_business_glossary_term' = 'Drill Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` ALTER COLUMN `filter_enabled` SET TAGS ('dbx_business_glossary_term' = 'Filter Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` ALTER COLUMN `is_conformed` SET TAGS ('dbx_business_glossary_term' = 'Is Conformed Dimension Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` ALTER COLUMN `is_slowly_changing` SET TAGS ('dbx_business_glossary_term' = 'Is Slowly Changing Dimension (SCD) Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` ALTER COLUMN `refresh_frequency` SET TAGS ('dbx_value_regex' = 'real_time|hourly|daily|weekly|monthly|on_demand');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` ALTER COLUMN `scd_type` SET TAGS ('dbx_business_glossary_term' = 'Slowly Changing Dimension (SCD) Type');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_dimension` ALTER COLUMN `security_classification` SET TAGS ('dbx_value_regex' = 'public|internal|confidential|restricted');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` SET TAGS ('dbx_subdomain' = 'quality_control');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` ALTER COLUMN `dq_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Data Quality (DQ) Rule ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` ALTER COLUMN `semantic_layer_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Target Semantic Layer Entity Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` ALTER COLUMN `execution_frequency` SET TAGS ('dbx_value_regex' = 'real_time|hourly|daily|weekly|monthly|on_demand');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` ALTER COLUMN `execution_layer` SET TAGS ('dbx_value_regex' = 'bronze|silver|gold');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` ALTER COLUMN `rule_status` SET TAGS ('dbx_value_regex' = 'active|inactive|draft|deprecated|suspended');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` ALTER COLUMN `rule_type` SET TAGS ('dbx_value_regex' = 'completeness|uniqueness|validity|consistency|timeliness|referential_integrity');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` ALTER COLUMN `severity_level` SET TAGS ('dbx_value_regex' = 'critical|major|minor|warning');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` ALTER COLUMN `threshold_operator` SET TAGS ('dbx_value_regex' = 'less_than|less_than_or_equal|greater_than|greater_than_or_equal|equal|not_equal');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` ALTER COLUMN `threshold_unit` SET TAGS ('dbx_value_regex' = 'percentage|count|ratio');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` SET TAGS ('dbx_subdomain' = 'quality_control');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `dq_result_id` SET TAGS ('dbx_business_glossary_term' = 'Data Quality (DQ) Result ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `audit_event_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Event Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `dq_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Data Quality (DQ) Rule ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `financial_period_id` SET TAGS ('dbx_business_glossary_term' = 'Financial Period Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `fulfillment_order_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Shipment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `inbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Shipment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `retail_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Retail Calendar Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `stock_position_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Position Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `semantic_layer_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Target Semantic Layer Entity Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Target Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `batch_code` SET TAGS ('dbx_business_glossary_term' = 'Data Quality (DQ) Batch ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `execution_duration_seconds` SET TAGS ('dbx_business_glossary_term' = 'Execution Duration in Seconds');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `execution_status` SET TAGS ('dbx_value_regex' = 'completed|failed|timeout|cancelled');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `execution_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Rule Execution Timestamp');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `failure_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Failure Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `pass_fail_status` SET TAGS ('dbx_business_glossary_term' = 'Pass/Fail Status');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `pass_fail_status` SET TAGS ('dbx_value_regex' = 'pass|fail|warning|error');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `previous_failure_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Previous Failure Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `remediation_action` SET TAGS ('dbx_business_glossary_term' = 'Remediation Action Taken');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `remediation_action` SET TAGS ('dbx_value_regex' = 'none|alert_sent|ticket_created|auto_corrected|quarantined|rejected');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `rule_name` SET TAGS ('dbx_business_glossary_term' = 'Data Quality (DQ) Rule Name');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `rule_type` SET TAGS ('dbx_business_glossary_term' = 'Data Quality (DQ) Rule Type');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `rule_type` SET TAGS ('dbx_value_regex' = 'completeness|accuracy|consistency|validity|uniqueness|timeliness');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `sample_failed_keys` SET TAGS ('dbx_business_glossary_term' = 'Sample Failed Record Keys');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `schedule_type` SET TAGS ('dbx_value_regex' = 'scheduled|on_demand|event_triggered|continuous');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `severity_level` SET TAGS ('dbx_business_glossary_term' = 'Data Quality (DQ) Severity Level');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `severity_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `sla_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Compliance Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `target_domain` SET TAGS ('dbx_business_glossary_term' = 'Target Data Domain');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `target_product` SET TAGS ('dbx_business_glossary_term' = 'Target Data Product');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `threshold_value` SET TAGS ('dbx_business_glossary_term' = 'Quality Threshold Value');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `trend_direction` SET TAGS ('dbx_business_glossary_term' = 'Quality Trend Direction');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `trend_direction` SET TAGS ('dbx_value_regex' = 'improving|stable|degrading|new');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` SET TAGS ('dbx_subdomain' = 'quality_control');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `dq_issue_id` SET TAGS ('dbx_business_glossary_term' = 'Data Quality (DQ) Issue ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Affected Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `dq_result_id` SET TAGS ('dbx_business_glossary_term' = 'Dq Result Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `dq_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Detection Rule ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `inbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Shipment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `replenishment_order_id` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `return_fraud_case_id` SET TAGS ('dbx_business_glossary_term' = 'Return Fraud Case Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `stock_position_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Position Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `affected_attribute` SET TAGS ('dbx_business_glossary_term' = 'Affected Attribute Name');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `assigned_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Assignment Timestamp');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `assigned_to` SET TAGS ('dbx_business_glossary_term' = 'Assigned To User');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `business_impact` SET TAGS ('dbx_business_glossary_term' = 'Business Impact Assessment');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `closed_by` SET TAGS ('dbx_business_glossary_term' = 'Closed By User');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Closure Timestamp');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `data_product` SET TAGS ('dbx_business_glossary_term' = 'Data Product Name');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `dq_issue_description` SET TAGS ('dbx_business_glossary_term' = 'Issue Description');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `detected_by` SET TAGS ('dbx_business_glossary_term' = 'Detected By User');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `detected_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Detection Timestamp');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `detection_method` SET TAGS ('dbx_value_regex' = 'automated_rule|manual_review|user_report|reconciliation|audit|monitoring_alert');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `domain` SET TAGS ('dbx_business_glossary_term' = 'Data Domain');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `dq_issue_status` SET TAGS ('dbx_business_glossary_term' = 'Issue Status');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `dq_issue_status` SET TAGS ('dbx_value_regex' = 'open|in_progress|resolved|closed|accepted|rejected');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `issue_number` SET TAGS ('dbx_business_glossary_term' = 'Data Quality (DQ) Issue Number');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `issue_number` SET TAGS ('dbx_value_regex' = '^DQ-[0-9]{6,10}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `issue_type` SET TAGS ('dbx_business_glossary_term' = 'Data Quality (DQ) Issue Type');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `issue_type` SET TAGS ('dbx_value_regex' = 'completeness|accuracy|consistency|validity|timeliness|uniqueness');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `prevention_action` SET TAGS ('dbx_business_glossary_term' = 'Prevention Action Plan');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Remediation Priority');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'p1|p2|p3|p4');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `remediation_cost_estimate` SET TAGS ('dbx_business_glossary_term' = 'Remediation Cost Estimate (USD)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `resolved_by` SET TAGS ('dbx_business_glossary_term' = 'Resolved By User');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `resolved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Resolution Timestamp');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `severity` SET TAGS ('dbx_business_glossary_term' = 'Issue Severity Level');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `severity` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `sla_due_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Due Timestamp');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Issue Title');
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` SET TAGS ('dbx_subdomain' = 'semantic_catalog');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `loyalty_program_id` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `primary_replacement_semantic_layer_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Replacement Entity ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `certified_status` SET TAGS ('dbx_business_glossary_term' = 'Certification Status');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `certified_status` SET TAGS ('dbx_value_regex' = 'certified|provisional|deprecated|draft');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `consumption_tier` SET TAGS ('dbx_value_regex' = 'self_service|governed|restricted');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `data_steward_email` SET TAGS ('dbx_business_glossary_term' = 'Data Steward Email Address');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `data_steward_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `documentation_url` SET TAGS ('dbx_business_glossary_term' = 'Documentation URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `domain` SET TAGS ('dbx_business_glossary_term' = 'Business Domain');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `entity_label` SET TAGS ('dbx_business_glossary_term' = 'Entity Business Label');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `entity_type` SET TAGS ('dbx_value_regex' = 'dimension|measure|metric|fact|aggregate|derived');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `is_financial_flag` SET TAGS ('dbx_business_glossary_term' = 'Contains Financial Data Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `is_pii_flag` SET TAGS ('dbx_business_glossary_term' = 'Contains PII (Personally Identifiable Information) Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `platform_object_code` SET TAGS ('dbx_business_glossary_term' = 'Platform Object Identifier');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `platform_type` SET TAGS ('dbx_business_glossary_term' = 'Semantic Layer Platform Type');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `refresh_frequency` SET TAGS ('dbx_value_regex' = 'real_time|hourly|daily|weekly|monthly|on_demand');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `related_kpi_definitions` SET TAGS ('dbx_business_glossary_term' = 'Related KPI (Key Performance Indicator) Definitions');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `tags` SET TAGS ('dbx_business_glossary_term' = 'Entity Tags');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `underlying_table_reference` SET TAGS ('dbx_business_glossary_term' = 'Underlying Physical Table Reference');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Entity Version');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` SET TAGS ('dbx_subdomain' = 'semantic_catalog');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `financial_period_id` SET TAGS ('dbx_business_glossary_term' = 'Financial Period Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) Definition ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `price_strategy_id` SET TAGS ('dbx_business_glossary_term' = 'Price Strategy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `calculation_layer` SET TAGS ('dbx_value_regex' = 'bronze|silver|gold|semantic');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `certification_status` SET TAGS ('dbx_value_regex' = 'draft|under_review|certified|deprecated');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `documentation_url` SET TAGS ('dbx_business_glossary_term' = 'Documentation Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `metric_type` SET TAGS ('dbx_value_regex' = 'simple|ratio|derived|cumulative|compound');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `refresh_frequency` SET TAGS ('dbx_value_regex' = 'real_time|hourly|daily|weekly|monthly');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `time_grain` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|quarterly|yearly');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `trend_direction_indicator` SET TAGS ('dbx_value_regex' = 'higher_is_better|lower_is_better|target_is_optimal');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ALTER COLUMN `usage_frequency` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` SET TAGS ('dbx_subdomain' = 'reporting_governance');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `access_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Analytics Access Policy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `dashboard_config_id` SET TAGS ('dbx_business_glossary_term' = 'Dashboard Config Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `demand_forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Demand Forecast Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `financial_period_id` SET TAGS ('dbx_business_glossary_term' = 'Financial Period Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `inventory_node_id` SET TAGS ('dbx_business_glossary_term' = 'Inventory Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Subscriber Team ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Subscriber User ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `tertiary_report_last_modified_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `delivery_channel` SET TAGS ('dbx_value_regex' = 'email|slack|teams|in_app|sftp|webhook');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `delivery_email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `delivery_schedule_type` SET TAGS ('dbx_value_regex' = 'cron|named_cadence|on_demand|event_triggered');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `max_delivery_attempts` SET TAGS ('dbx_business_glossary_term' = 'Maximum Delivery Attempts');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `output_format` SET TAGS ('dbx_value_regex' = 'pdf|excel|csv|html|powerpoint|json');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'low|normal|high|urgent');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ALTER COLUMN `subscription_status` SET TAGS ('dbx_value_regex' = 'active|paused|cancelled|expired|pending');
ALTER TABLE `vibe_retail_v1`.`analytics`.`access_policy` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`access_policy` SET TAGS ('dbx_subdomain' = 'quality_control');
ALTER TABLE `vibe_retail_v1`.`analytics`.`access_policy` ALTER COLUMN `access_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Analytics Access Policy ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`access_policy` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned User ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`access_policy` ALTER COLUMN `access_level` SET TAGS ('dbx_value_regex' = 'view|export|edit|admin|deny');
ALTER TABLE `vibe_retail_v1`.`analytics`.`access_policy` ALTER COLUMN `data_classification_constraint` SET TAGS ('dbx_value_regex' = 'restricted|confidential|internal|public');
ALTER TABLE `vibe_retail_v1`.`analytics`.`access_policy` ALTER COLUMN `enforcement_mode` SET TAGS ('dbx_value_regex' = 'enforce|audit|warn');
ALTER TABLE `vibe_retail_v1`.`analytics`.`access_policy` ALTER COLUMN `policy_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`access_policy` ALTER COLUMN `policy_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|revoked');
ALTER TABLE `vibe_retail_v1`.`analytics`.`access_policy` ALTER COLUMN `policy_type` SET TAGS ('dbx_value_regex' = 'row_level|column_level|object_level|attribute_level|cell_level|dynamic');
ALTER TABLE `vibe_retail_v1`.`analytics`.`access_policy` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` SET TAGS ('dbx_subdomain' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ALTER COLUMN `is_53_week_year` SET TAGS ('dbx_business_glossary_term' = 'Is 53-Week Year Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ALTER COLUMN `is_back_to_school_period` SET TAGS ('dbx_business_glossary_term' = 'Is Back-to-School Period Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ALTER COLUMN `is_black_friday_week` SET TAGS ('dbx_business_glossary_term' = 'Is Black Friday Week Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ALTER COLUMN `is_current_date` SET TAGS ('dbx_business_glossary_term' = 'Is Current Date Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ALTER COLUMN `is_cyber_monday_week` SET TAGS ('dbx_business_glossary_term' = 'Is Cyber Monday Week Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ALTER COLUMN `is_holiday` SET TAGS ('dbx_business_glossary_term' = 'Is Holiday Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ALTER COLUMN `is_holiday_shopping_period` SET TAGS ('dbx_business_glossary_term' = 'Is Holiday Shopping Period Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ALTER COLUMN `is_leap_year` SET TAGS ('dbx_business_glossary_term' = 'Is Leap Year Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ALTER COLUMN `is_weekday` SET TAGS ('dbx_business_glossary_term' = 'Is Weekday Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ALTER COLUMN `is_weekend` SET TAGS ('dbx_business_glossary_term' = 'Is Weekend Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ALTER COLUMN `iso_week` SET TAGS ('dbx_business_glossary_term' = 'ISO Week Number');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ALTER COLUMN `season` SET TAGS ('dbx_business_glossary_term' = 'Retail Season');
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ALTER COLUMN `season` SET TAGS ('dbx_value_regex' = 'Spring|Summer|Fall|Winter');
ALTER TABLE `vibe_retail_v1`.`analytics`.`reporting_hierarchy` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`reporting_hierarchy` SET TAGS ('dbx_subdomain' = 'semantic_catalog');
ALTER TABLE `vibe_retail_v1`.`analytics`.`reporting_hierarchy` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`reporting_hierarchy` ALTER COLUMN `external_system_code` SET TAGS ('dbx_business_glossary_term' = 'External System ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`reporting_hierarchy` ALTER COLUMN `hierarchy_type` SET TAGS ('dbx_value_regex' = 'organizational|geographic|merchandise|channel|financial|customer_segment');
ALTER TABLE `vibe_retail_v1`.`analytics`.`reporting_hierarchy` ALTER COLUMN `node_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|deprecated|merged');
ALTER TABLE `vibe_retail_v1`.`analytics`.`reporting_hierarchy` ALTER COLUMN `reporting_calendar_type` SET TAGS ('dbx_value_regex' = 'gregorian|retail_454|retail_445|fiscal');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` SET TAGS ('dbx_subdomain' = 'performance_measurement');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `analytics_kpi_target_id` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) Target ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `demand_forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Demand Forecast Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Store Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Fulfillment Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `inventory_node_id` SET TAGS ('dbx_business_glossary_term' = 'Inventory Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) Definition ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `margin_target_id` SET TAGS ('dbx_business_glossary_term' = 'Margin Target Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `reporting_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Reporting Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `retail_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Retail Calendar Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `semantic_layer_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Business Entity Identifier');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `financial_period_id` SET TAGS ('dbx_business_glossary_term' = 'Target Financial Period Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `target_owner_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Target Owner User ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `tertiary_analytics_last_updated_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Last Updated By User ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Target Approval Status');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|rejected|revised');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Target Approval Timestamp');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `business_entity_type` SET TAGS ('dbx_value_regex' = 'store|category|region|channel|department|supplier');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Target Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `data_source` SET TAGS ('dbx_business_glossary_term' = 'Target Data Source');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Target Effective End Date');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Target Effective Start Date');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Active Target Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Target Record Last Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Target Notes');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Target Period End Date');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Target Period Start Date');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `revision_reason` SET TAGS ('dbx_business_glossary_term' = 'Target Revision Reason');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `target_setting_method` SET TAGS ('dbx_value_regex' = 'top_down|bottom_up|algorithmic|historical|benchmark');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `target_version` SET TAGS ('dbx_business_glossary_term' = 'Target Version Number');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ALTER COLUMN `variance_alert_threshold_percent` SET TAGS ('dbx_business_glossary_term' = 'Variance Alert Threshold Percentage');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` SET TAGS ('dbx_subdomain' = 'performance_measurement');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `alert_id` SET TAGS ('dbx_business_glossary_term' = 'Analytics Alert ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `access_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Analytics Access Policy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `audit_finding_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Finding Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `cycle_count_id` SET TAGS ('dbx_business_glossary_term' = 'Cycle Count Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `demand_forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Demand Forecast Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `dq_result_id` SET TAGS ('dbx_business_glossary_term' = 'Dq Result Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `financial_period_id` SET TAGS ('dbx_business_glossary_term' = 'Financial Period Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Fulfillment Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `fulfillment_order_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Shipment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) Definition ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Location Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Membership Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `margin_target_id` SET TAGS ('dbx_business_glossary_term' = 'Margin Target Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `markdown_id` SET TAGS ('dbx_business_glossary_term' = 'Markdown Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `osha_incident_id` SET TAGS ('dbx_business_glossary_term' = 'Osha Incident Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned To User ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `replenishment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `reporting_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Reporting Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `retail_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Retail Calendar Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `sku_price_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `stock_position_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Position Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `alert_status` SET TAGS ('dbx_value_regex' = 'new|acknowledged|investigating|resolved|dismissed|escalated');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `alert_type` SET TAGS ('dbx_value_regex' = 'threshold_breach|anomaly_detection|trend_deviation|forecast_variance|data_quality_issue|target_miss');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `rule_version` SET TAGS ('dbx_business_glossary_term' = 'Alert Rule Version');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `severity_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|informational');
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` SET TAGS ('dbx_subdomain' = 'reporting_governance');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `self_service_query_id` SET TAGS ('dbx_business_glossary_term' = 'Self-Service Query ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `access_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Access Policy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'User ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `dashboard_config_id` SET TAGS ('dbx_business_glossary_term' = 'Dashboard Config Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Membership Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `report_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Report Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `semantic_layer_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Semantic Layer Entity Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `semantic_metric_id` SET TAGS ('dbx_business_glossary_term' = 'Semantic Metric Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `bi_tool` SET TAGS ('dbx_business_glossary_term' = 'Business Intelligence (BI) Tool');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `compute_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Compute Cost (USD)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `contains_pii` SET TAGS ('dbx_business_glossary_term' = 'Contains Personally Identifiable Information (PII)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `data_classification` SET TAGS ('dbx_value_regex' = 'restricted|confidential|internal|public');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `data_scanned_bytes` SET TAGS ('dbx_business_glossary_term' = 'Data Scanned (Bytes)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `export_format` SET TAGS ('dbx_value_regex' = 'csv|excel|pdf|json|parquet|none');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `query_duration_seconds` SET TAGS ('dbx_business_glossary_term' = 'Query Duration (Seconds)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `query_purpose` SET TAGS ('dbx_value_regex' = 'ad_hoc_analysis|reporting|dashboard_refresh|data_exploration|model_training|data_quality_check');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `query_status` SET TAGS ('dbx_value_regex' = 'success|failed|timeout|cancelled|partial');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `query_type` SET TAGS ('dbx_value_regex' = 'sql|semantic|natural_language|visual_builder|saved_query');
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ALTER COLUMN `result_set_size_mb` SET TAGS ('dbx_business_glossary_term' = 'Result Set Size (MB)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` SET TAGS ('dbx_subdomain' = 'semantic_catalog');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `glossary_term_id` SET TAGS ('dbx_business_glossary_term' = 'Glossary Term Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `dashboard_config_id` SET TAGS ('dbx_business_glossary_term' = 'Dashboard Config Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Example Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `financial_period_id` SET TAGS ('dbx_business_glossary_term' = 'Financial Period Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `metric_dimension_id` SET TAGS ('dbx_business_glossary_term' = 'Metric Dimension Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Obligation Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `report_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Report Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `semantic_layer_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Semantic Layer Entity Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `semantic_metric_id` SET TAGS ('dbx_business_glossary_term' = 'Semantic Metric Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'draft|pending_review|approved|published|deprecated|retired');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `business_owner_email` SET TAGS ('dbx_business_glossary_term' = 'Business Owner Email Address');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `business_owner_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `contains_financial_data` SET TAGS ('dbx_business_glossary_term' = 'Contains Financial Data Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `contains_pii` SET TAGS ('dbx_business_glossary_term' = 'Contains Personally Identifiable Information (PII) Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `criticality_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `data_classification` SET TAGS ('dbx_value_regex' = 'restricted|confidential|internal|public');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `data_steward_email` SET TAGS ('dbx_business_glossary_term' = 'Data Steward Email Address');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `data_steward_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `term_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `usage_frequency` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` SET TAGS ('dbx_subdomain' = 'performance_measurement');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` SET TAGS ('dbx_association_edges' = 'analytics.kpi_definition,analytics.metric_dimension');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` ALTER COLUMN `kpi_dimensionality_id` SET TAGS ('dbx_business_glossary_term' = 'KPI Dimensionality Configuration ID');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Dimensionality - Kpi Definition Id');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` ALTER COLUMN `metric_dimension_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Dimensionality - Metric Dimension Id');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` ALTER COLUMN `configured_by` SET TAGS ('dbx_business_glossary_term' = 'Configuration Owner');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` ALTER COLUMN `display_format` SET TAGS ('dbx_business_glossary_term' = 'Display Format Override');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` ALTER COLUMN `drill_enabled` SET TAGS ('dbx_business_glossary_term' = 'Drill-Down Enabled');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Configuration Effective End Date');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Configuration Effective Start Date');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Active Configuration Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` ALTER COLUMN `is_required_dimension` SET TAGS ('dbx_business_glossary_term' = 'Required Dimension Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_dimensionality` ALTER COLUMN `sort_order` SET TAGS ('dbx_business_glossary_term' = 'Dimension Sort Order');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_composition` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_composition` SET TAGS ('dbx_subdomain' = 'reporting_governance');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_composition` SET TAGS ('dbx_association_edges' = 'analytics.kpi_definition,analytics.report_definition');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_composition` ALTER COLUMN `report_composition_id` SET TAGS ('dbx_business_glossary_term' = 'Report Composition Identifier');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_composition` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Report Composition - Kpi Definition Id');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_composition` ALTER COLUMN `report_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Report Composition - Report Definition Id');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_composition` ALTER COLUMN `added_date` SET TAGS ('dbx_business_glossary_term' = 'KPI Added Date');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_composition` ALTER COLUMN `is_primary_metric` SET TAGS ('dbx_business_glossary_term' = 'Primary Metric Flag');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_composition` ALTER COLUMN `removed_date` SET TAGS ('dbx_business_glossary_term' = 'KPI Removed Date');
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_composition` ALTER COLUMN `section_name` SET TAGS ('dbx_business_glossary_term' = 'Report Section Name');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_entity_dependency` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_entity_dependency` SET TAGS ('dbx_subdomain' = 'semantic_catalog');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_entity_dependency` SET TAGS ('dbx_association_edges' = 'analytics.semantic_layer_entity,analytics.semantic_metric');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_entity_dependency` ALTER COLUMN `metric_entity_dependency_id` SET TAGS ('dbx_business_glossary_term' = 'Metric Entity Dependency Identifier');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_entity_dependency` ALTER COLUMN `semantic_layer_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Metric Entity Dependency - Semantic Layer Entity Id');
ALTER TABLE `vibe_retail_v1`.`analytics`.`metric_entity_dependency` ALTER COLUMN `semantic_metric_id` SET TAGS ('dbx_business_glossary_term' = 'Metric Entity Dependency - Semantic Metric Id');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` SET TAGS ('dbx_subdomain' = 'performance_measurement');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` SET TAGS ('dbx_association_edges' = 'analytics.kpi_definition,supplychain.sla_definition');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ALTER COLUMN `sla_kpi_measurement_id` SET TAGS ('dbx_business_glossary_term' = 'SLA KPI Measurement Identifier');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Kpi Measurement - Kpi Definition Id');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ALTER COLUMN `sla_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Kpi Measurement - Supply Chain Sla Id');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ALTER COLUMN `alert_threshold_value` SET TAGS ('dbx_business_glossary_term' = 'Alert Threshold');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Creation Timestamp');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Measurement Effective End Date');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Measurement Effective Start Date');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ALTER COLUMN `is_primary_kpi` SET TAGS ('dbx_business_glossary_term' = 'Primary KPI Indicator');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ALTER COLUMN `measurement_weight` SET TAGS ('dbx_business_glossary_term' = 'KPI Weight in SLA Scorecard');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ALTER COLUMN `measurement_window_days` SET TAGS ('dbx_business_glossary_term' = 'Measurement Window');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ALTER COLUMN `threshold_value` SET TAGS ('dbx_business_glossary_term' = 'SLA-Specific KPI Threshold');
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_retail_v1`.`analytics`.`workspace` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`workspace` SET TAGS ('dbx_subdomain' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`analytics`.`workspace` ALTER COLUMN `workspace_id` SET TAGS ('dbx_business_glossary_term' = 'Workspace Identifier');
ALTER TABLE `vibe_retail_v1`.`analytics`.`workspace` ALTER COLUMN `access_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Access Policy Id (Foreign Key)');
