-- Schema for Domain: procurement | Business:  | Version: v1_mvm
-- Generated on: 2026-04-16 09:51:31

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`procurement` COMMENT 'Governs end-to-end procurement and supply chain planning including supplier master data, MRP/MRP II planning, demand forecasting, strategic sourcing, purchase requisitions, PO lifecycle, GRN processing, supplier performance tracking, vendor qualification, spend analytics, category management, and procurement compliance for direct and indirect materials';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`mrp_run` (
    `mrp_run_id` BIGINT COMMENT 'Unique system-generated identifier for each MRP or MRP II planning run execution record in the Silver Layer lakehouse.',
    `engineering_bom_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_bom. Business justification: Each MRP run is executed against a specific BOM revision. Traceability to the exact BOM used is required for audit, re-planning after ECNs, and reconciling planned vs. actual material requirements in ',
    `physical_inventory_id` BIGINT COMMENT 'Foreign key linking to inventory.physical_inventory. Business justification: MRP runs use confirmed physical inventory counts as the authoritative stock baseline. Linking mrp_run to physical_inventory ensures MRP calculations are grounded in verified stock data, not just syste',
    `segment_id` BIGINT COMMENT 'Foreign key linking to customer.segment. Business justification: MRP runs in industrial manufacturing are scoped by customer segment to prioritize material requirements for strategic segments (e.g., high-volume automotive). Planners execute segment-specific MRP run',
    `bom_explosion_level` STRING COMMENT 'Maximum number of BOM levels exploded during the MRP run. Indicates the depth of the product structure traversed to derive dependent requirements for sub-assemblies and raw materials.. Valid values are `^[0-9]+$`',
    `capacity_check_performed` BOOLEAN COMMENT 'Indicates whether a capacity requirements planning (CRP) check was executed as part of this MRP II run to validate work center availability against planned production orders.. Valid values are `true|false`',
    `capacity_overload_count` STRING COMMENT 'Number of work centers identified as overloaded (capacity demand exceeds available capacity) during the MRP II capacity check. Requires production scheduling intervention.. Valid values are `^[0-9]+$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant location where the MRP run was executed. Supports multi-country reporting and regional supply planning analytics.. Valid values are `^[A-Z]{3}$`',
    `coverage_shortfall_count` STRING COMMENT 'Number of materials with identified supply shortfalls (demand exceeds available supply within the planning horizon) after the MRP run. Critical KPI for supply risk management.. Valid values are `^[0-9]+$`',
    `exception_cancel_count` STRING COMMENT 'Count of MRP exception messages recommending cancellation of existing planned receipts (purchase orders or production orders) due to excess supply or demand cancellation.. Valid values are `^[0-9]+$`',
    `exception_messages_total` STRING COMMENT 'Total count of MRP exception messages generated during the run across all materials. Exception messages flag planning anomalies requiring MRP controller review and action.. Valid values are `^[0-9]+$`',
    `exception_new_requirement_count` STRING COMMENT 'Count of MRP exception messages indicating new demand requirements that have been identified and for which new planned orders or purchase requisitions have been created.. Valid values are `^[0-9]+$`',
    `exception_reschedule_in_count` STRING COMMENT 'Count of MRP exception messages recommending that existing receipts (purchase orders, production orders) be rescheduled to an earlier date to cover demand shortfalls.. Valid values are `^[0-9]+$`',
    `exception_reschedule_out_count` STRING COMMENT 'Count of MRP exception messages recommending that existing receipts be rescheduled to a later date due to excess supply or demand postponement.. Valid values are `^[0-9]+$`',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year in which the MRP run was executed. Enables period-over-period comparison of planning run outputs and exception trends.. Valid values are `^(0[1-9]|1[0-2])$`',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the MRP planning run was executed. Used for financial period alignment in procurement spend analytics and supply planning reporting.. Valid values are `^[0-9]{4}$`',
    `horizon_end_date` DATE COMMENT 'The end date of the planning horizon window for this MRP run. Marks the latest date for which planned orders and procurement proposals are generated.. Valid values are `^d{4}-d{2}-d{2}$`',
    `horizon_start_date` DATE COMMENT 'The start date of the planning horizon window for this MRP run. Marks the earliest date for which planned orders and procurement proposals are generated.. Valid values are `^d{4}-d{2}-d{2}$`',
    `initiated_by` STRING COMMENT 'SAP user ID or system job name that triggered the MRP planning run. Distinguishes between manually initiated runs by MRP controllers and automated scheduled batch jobs.',
    `material_range_from` STRING COMMENT 'Starting material number of the material range included in the MRP run when run_scope is material_range. Enables targeted replanning of specific material groups.',
    `material_range_to` STRING COMMENT 'Ending material number of the material range included in the MRP run when run_scope is material_range. Defines the upper boundary of the material selection.',
    `mrp_area` STRING COMMENT 'SAP MRP area within the plant that scopes the planning run. An MRP area can represent a storage location, subcontractor, or the entire plant, enabling granular supply planning.',
    `mrp_controller_group` STRING COMMENT 'SAP MRP controller group code responsible for reviewing and acting on the exception messages and planned orders generated by this MRP run.',
    `planned_orders_created` STRING COMMENT 'Number of new planned production orders generated by the MRP run. Planned orders represent internal manufacturing proposals that MRP controllers review and convert to production orders.. Valid values are `^[0-9]+$`',
    `planning_date` DATE COMMENT 'The business date used as the reference point for the MRP planning run. All requirements, receipts, and planned orders are evaluated relative to this date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planning_horizon_days` STRING COMMENT 'Number of calendar days forward from the planning date that the MRP run covers. Defines the time fence within which planned orders and procurement proposals are generated.. Valid values are `^[0-9]+$`',
    `planning_mode` STRING COMMENT 'Indicates the planning methodology applied during the run: standard MRP (Material Requirements Planning), MRP II (Manufacturing Resource Planning including capacity), consumption-based, reorder point, or forecast-based planning.. Valid values are `mrp|mrp_ii|consumption_based|reorder_point|forecast_based`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility for which the MRP run was executed. Aligns with the organizational unit in SAP S/4HANA.. Valid values are `^[A-Z0-9]{4}$`',
    `purchase_requisitions_created` STRING COMMENT 'Number of purchase requisitions automatically generated by the MRP run for externally procured materials. PRs are subsequently converted to purchase orders by the procurement team.. Valid values are `^[0-9]+$`',
    `run_duration_seconds` STRING COMMENT 'Total elapsed time in seconds for the MRP planning run to complete. Used to monitor system performance, identify degradation trends, and plan batch scheduling windows.. Valid values are `^[0-9]+$`',
    `run_end_timestamp` TIMESTAMP COMMENT 'Date and time when the MRP planning run completed in SAP S/4HANA. Combined with run_start_timestamp to calculate run duration for performance benchmarking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `run_number` STRING COMMENT 'Business-facing alphanumeric identifier for the MRP planning run, used for cross-referencing in SAP S/4HANA PP/MM and audit trail documentation.. Valid values are `^MRP-[0-9]{4}-[0-9]{6}$`',
    `run_scope` STRING COMMENT 'Defines the breadth of materials included in the MRP run: a single material, a defined material range, all materials in the MRP area, or the entire plant.. Valid values are `single_material|material_range|all_materials|mrp_area|plant_wide`',
    `run_start_timestamp` TIMESTAMP COMMENT 'Date and time when the MRP planning run was initiated in SAP S/4HANA. Used for performance monitoring, audit trail, and scheduling conflict detection.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `run_trigger_type` STRING COMMENT 'Indicates how the MRP run was initiated: manually by an MRP controller, via a scheduled batch job, triggered by a business event (e.g., large sales order), or via API integration.. Valid values are `manual|scheduled_batch|event_driven|api_triggered`',
    `run_type` STRING COMMENT 'Classification of the MRP planning run scope: regenerative replans all materials, net_change replans only materials with changes since last run, net_change_planning_horizon limits net change to the planning horizon window.. Valid values are `regenerative|net_change|net_change_planning_horizon`',
    `schedule_lines_created` STRING COMMENT 'Number of delivery schedule lines generated by the MRP run for scheduling agreement-based procurement. Represents firm or forecast delivery commitments to suppliers.. Valid values are `^[0-9]+$`',
    `scheduling_type` STRING COMMENT 'Defines the scheduling logic applied during the MRP run: basic date calculation, lead time scheduling using routing data, or capacity planning with work center load leveling.. Valid values are `basic_dates|lead_time_scheduling|capacity_planning`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which the MRP run data was extracted. Supports data lineage tracking in the Databricks Silver Layer lakehouse.. Valid values are `SAP_S4HANA|SAP_ECC|OPCENTER|OTHER`',
    `source_system_run_reference` STRING COMMENT 'The native identifier of the MRP run in the source operational system (e.g., SAP S/4HANA internal run key). Enables traceability and reconciliation between the lakehouse and the system of record.',
    `status` STRING COMMENT 'Current execution status of the MRP planning run. Supports MRP controller workflow management and exception handling processes.. Valid values are `initiated|in_progress|completed|completed_with_exceptions|failed|cancelled`',
    `total_materials_planned` STRING COMMENT 'Count of distinct material numbers processed during the MRP run. Used to assess run scope, compare against prior runs, and validate completeness of planning coverage.. Valid values are `^[0-9]+$`',
    CONSTRAINT pk_mrp_run PRIMARY KEY(`mrp_run_id`)
) COMMENT 'Records each MRP (Material Requirements Planning) or MRP II planning run executed in SAP PP/MM. Captures planning scope (plant, MRP area, material range), run type (regenerative, net change, net change in planning horizon), run timestamp, planning horizon, and exception message counts. Provides audit trail for supply planning decisions and supports MRP controller review workflows.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` (
    `mrp_planned_order_id` BIGINT COMMENT 'Unique surrogate identifier for each MRP/MRP II planned order record in the lakehouse silver layer. Serves as the primary key for this entity.',
    `engineering_bom_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_bom. Business justification: MRP explosion runs against the engineering BOM to generate planned orders. Each planned order must trace back to the BOM revision used during the MRP run — critical for change management when an ECN u',
    `forecast_id` BIGINT COMMENT 'Foreign key linking to sales.sales_forecast. Business justification: MRP systems convert sales forecasts into planned production orders. Manufacturing planners trace planned orders back to originating sales forecasts to validate material requirements against actual cus',
    `hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.hierarchy. Business justification: MRP planned orders are generated against specific product hierarchy nodes in industrial manufacturing. Planners run MRP at hierarchy level to aggregate demand across product families — used daily in p',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.line_item. Business justification: MRP planned orders are generated against specific sales order line items in make-to-order environments. Production planners link planned orders to demand lines to ensure customer-specific production s',
    `mrp_run_id` BIGINT COMMENT 'Foreign key linking to procurement.mrp_run. Business justification: MRP planned orders are generated by specific MRP/MRP II planning runs. This is a fundamental parent-child relationship in the MRP data model. mrp_run_date is retained as a date field (not a business k',
    `product_cost_estimate_id` BIGINT COMMENT 'Foreign key linking to finance.product_cost_estimate. Business justification: MRP planned orders reference product cost estimates to value planned procurement quantities at standard cost. Finance uses this to calculate planned purchase price variances and inventory valuation.',
    `product_variant_id` BIGINT COMMENT 'Foreign key linking to engineering.product_variant. Business justification: MRP planned orders are variant-specific because different product variants have different BOMs and component requirements. This link enables procurement to trace planned orders back to the variant con',
    `source_list_id` BIGINT COMMENT 'Foreign key linking to procurement.source_list. Business justification: MRP uses the source list to determine which supplier or contract to assign to a planned order. Planners rely on this link to ensure planned orders are automatically routed to the correct approved supp',
    `stock_position_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_position. Business justification: MRP planned orders are generated based on current stock positions versus demand. The planned order must reference the stock position it is intended to replenish, enabling planners to validate coverage',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: MRP planned orders must reference the products unit of measure to correctly calculate order quantities. Procurement planners rely on consistent UOM alignment between product master and planned orders',
    `bom_explosion_indicator` BOOLEAN COMMENT 'Indicates whether the MRP run performed a BOM explosion for this planned order to generate dependent requirements for lower-level components. True for production orders; typically false for externally procured materials.. Valid values are `true|false`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity or subsidiary for which this planned order is generated. Supports multi-company-code MRP planning in a multinational enterprise context and financial reporting alignment.. Valid values are `^[A-Z0-9]{1,10}$`',
    `conversion_timestamp` TIMESTAMP COMMENT 'The date and time at which the planned order was converted to a purchase requisition or production order. Supports lead time analysis and MRP controller performance tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `converted_document_number` STRING COMMENT 'The purchase requisition number or production order number to which this planned order was converted upon firming and release. Populated after conversion; null for unconverted planned orders. Enables traceability from planned to actual procurement.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or facility for which this planned order was generated. Supports regional compliance, cross-border procurement regulations, and multinational reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time at which the planned order record was created in the source system (SAP S/4HANA) by the MRP run. Used for audit trail, data lineage, and MRP run frequency analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the planned order value (e.g., USD, EUR, GBP). Supports multi-currency procurement planning and spend analytics in a multinational manufacturing environment.. Valid values are `^[A-Z]{3}$`',
    `demand_source_type` STRING COMMENT 'The type of demand element that triggered the generation of this planned order by MRP (e.g., sales order, planned independent requirement/forecast, safety stock replenishment, dependent demand from BOM explosion, manual reservation, project requirement, service order).. Valid values are `sales_order|forecast|safety_stock|dependent_demand|manual_reservation|project|service_order`',
    `exception_message_code` STRING COMMENT 'SAP MRP exception message code indicating an action required by the MRP controller (e.g., reschedule in, reschedule out, cancel, bring forward, push back). Exception messages highlight planning deviations requiring manual intervention.. Valid values are `^[0-9]{1,5}$`',
    `exception_message_text` STRING COMMENT 'Descriptive text of the MRP exception message associated with this planned order, providing the MRP controller with actionable guidance on the planning deviation (e.g., Reschedule order to earlier date, Order quantity exceeds maximum lot size).',
    `goods_receipt_processing_days` STRING COMMENT 'The number of workdays required for goods receipt inspection and posting after physical delivery, as maintained in the SAP material master. Included in MRP lead time calculation to determine the planned start date.. Valid values are `^[0-9]{1,3}$`',
    `is_firmed` BOOLEAN COMMENT 'Boolean flag indicating whether the planned order has been firmed (fixed) by the MRP controller to prevent automatic rescheduling or deletion by subsequent MRP runs. Firmed orders are protected from MRP changes.. Valid values are `true|false`',
    `lot_size_key` STRING COMMENT 'The lot-sizing procedure applied by MRP to calculate the planned order quantity (e.g., EX=exact lot size, FX=fixed lot size, MB=monthly lot size, HB=replenish to maximum stock level). Determines how demand is aggregated into order quantities.. Valid values are `^[A-Z0-9]{1,4}$`',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time at which the planned order record was last updated in the source system, capturing manual changes by MRP controllers or automatic updates from subsequent MRP runs.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `mrp_area` STRING COMMENT 'MRP area within the plant for which the planned order was generated. Enables sub-plant level planning segmentation such as storage locations or subcontractor areas in SAP S/4HANA.. Valid values are `^[A-Z0-9]{1,10}$`',
    `mrp_controller_code` STRING COMMENT 'Code identifying the MRP controller (planner) responsible for reviewing, firming, and converting this planned order. Corresponds to the MRP controller field in the SAP material master MRP 1 view.. Valid values are `^[A-Z0-9]{1,10}$`',
    `mrp_run_date` DATE COMMENT 'The date on which the MRP/MRP II planning run was executed that generated or last updated this planned order. Used for audit, traceability, and identifying stale planned orders.. Valid values are `^d{4}-d{2}-d{2}$`',
    `mrp_type` STRING COMMENT 'The MRP procedure used to plan this material (e.g., MRP, MPS, consumption-based planning, reorder point planning). Corresponds to the MRP type field in the SAP material master MRP 1 view.. Valid values are `^[A-Z0-9]{1,4}$`',
    `opening_date` DATE COMMENT 'The date on which the planned order should be released or converted to an actionable order (purchase requisition or production order), calculated by subtracting the float before production from the planned start date in SAP MRP.. Valid values are `^d{4}-d{2}-d{2}$`',
    `order_type` STRING COMMENT 'Classification of the planned order indicating the intended conversion target: purchase requisition (external procurement), production order (in-house manufacturing), transfer order (stock transfer), subcontracting, or consignment. Drives MRP controller firming decisions.. Valid values are `purchase_requisition|production_order|transfer_order|subcontracting|consignment`',
    `planned_delivery_days` STRING COMMENT 'The planned delivery time in calendar days for external procurement of this material, as maintained in the SAP material master or purchasing info record. Used by MRP to calculate planned start date from requirements date.. Valid values are `^[0-9]{1,5}$`',
    `planned_finish_date` DATE COMMENT 'The date by which the planned order must be completed (goods receipt or production completion) to satisfy the dependent or independent demand requirement. Derived from MRP scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_order_number` STRING COMMENT 'Business-facing alphanumeric identifier for the planned order as assigned by the MRP/MRP II run in SAP S/4HANA (MD04/MD06). Used by MRP controllers to reference, review, and firm planned orders.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `planned_order_value` DECIMAL(18,2) COMMENT 'Estimated monetary value of the planned order calculated as planned quantity multiplied by the standard or moving average price of the material. Used for spend analytics, budget planning, and procurement commitment reporting.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `planned_quantity` DECIMAL(18,2) COMMENT 'The quantity of material to be procured or produced as determined by the MRP/MRP II run, expressed in the base unit of measure. Reflects lot-sizing rules, safety stock, and demand requirements.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `planned_start_date` DATE COMMENT 'The date on which procurement or production activities for this planned order are scheduled to begin, as calculated by the MRP/MRP II backward scheduling logic. Used for capacity and supplier lead time planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `procurement_type` STRING COMMENT 'Indicates whether the material is procured externally (E), produced in-house (F), or both (X), as defined in the SAP material master MRP 2 view. Determines the planned order conversion path.. Valid values are `external|in_house|both|subcontracting`',
    `purchasing_group_code` STRING COMMENT 'SAP purchasing group (buyer group) responsible for the procurement activity associated with this planned order. Used for workload distribution and spend analytics by buyer.. Valid values are `^[A-Z0-9]{1,10}$`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization responsible for converting this planned order into a purchase requisition or purchase order. Relevant for externally procured planned orders.. Valid values are `^[A-Z0-9]{1,10}$`',
    `requirements_date` DATE COMMENT 'The date on which the material is required to be available in stock to fulfill the demand element (sales order, production order, forecast, safety stock). Drives MRP scheduling backward to determine planned start date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `safety_stock_quantity` DECIMAL(18,2) COMMENT 'The minimum stock level maintained as a buffer against demand variability and supply uncertainty, as defined in the SAP material master MRP 2 view. Influences MRP net requirements calculation and planned order quantities.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `source_plant_code` STRING COMMENT 'For stock transfer planned orders, the supplying plant from which the material will be transferred. Relevant for multi-plant and cross-company-code MRP scenarios in multinational manufacturing environments.. Valid values are `^[A-Z0-9]{1,10}$`',
    `special_procurement_key` STRING COMMENT 'SAP special procurement type key indicating non-standard procurement scenarios such as subcontracting, consignment, stock transfer from another plant, or phantom assembly. Influences planned order type and conversion behavior.. Valid values are `^[A-Z0-9]{1,4}$`',
    `status` STRING COMMENT 'Current lifecycle status of the planned order. Created indicates a system-generated order awaiting review; Firmed indicates the MRP controller has locked the order to prevent MRP rescheduling; Converted indicates the order has been converted to a purchase requisition or production order; Cancelled indicates the order is no longer required; Exception indicates an MRP exception message is pending resolution.. Valid values are `created|firmed|converted|cancelled|exception`',
    `storage_location_code` STRING COMMENT 'The storage location within the plant where the planned goods receipt will be posted upon conversion and execution of the planned order. Supports warehouse and inventory management integration.. Valid values are `^[A-Z0-9]{1,10}$`',
    CONSTRAINT pk_mrp_planned_order PRIMARY KEY(`mrp_planned_order_id`)
) COMMENT 'Planned orders generated by MRP/MRP II runs representing future procurement or production requirements. Captures material, plant, planned quantity, planned start date, planned finish date, order type (purchase requisition, production order, transfer order), and firming status. Supports MRP controller review, firming decisions, and conversion to purchase requisitions or production orders.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` (
    `demand_forecast_id` BIGINT COMMENT 'Unique surrogate identifier for each demand forecast record in the silver layer lakehouse. Serves as the primary key for all downstream joins and lineage tracking.',
    `account_hierarchy_id` BIGINT COMMENT 'Foreign key linking to customer.account_hierarchy. Business justification: Demand forecasts are often aggregated and disaggregated along customer account hierarchies (e.g., global OEM vs. regional subsidiary). Procurement uses account hierarchy to roll up or drill down forec',
    `blanket_order_id` BIGINT COMMENT 'Foreign key linking to order.blanket_order. Business justification: Demand forecasts are based on blanket orders (framework agreements) with committed volumes. Supply planning uses this to align procurement with contracted customer demand over planning horizons.',
    `fiscal_period_id` BIGINT COMMENT 'Foreign key linking to finance.fiscal_period. Business justification: Demand forecasts are bucketed by fiscal period to align procurement planning with financial budgeting cycles. Finance uses period-aligned forecasts to project cash outflows and purchase commitments.',
    `forecast_id` BIGINT COMMENT 'Foreign key linking to sales.sales_forecast. Business justification: Manufacturing procurement uses sales forecasts to drive MRP demand planning and material requirements. Production planning teams reference sales projections daily to determine raw material purchasing ',
    `hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.hierarchy. Business justification: Demand forecasts in manufacturing are structured against product hierarchy levels (product family, category, SKU). Demand planners aggregate and disaggregate forecasts through the hierarchy — a core d',
    `product_variant_id` BIGINT COMMENT 'Foreign key linking to engineering.product_variant. Business justification: Demand forecasts are generated at the product variant level to drive variant-specific material requirements. Procurement planners reference product variants daily when building forecasts that feed MRP',
    `segment_id` BIGINT COMMENT 'Foreign key linking to customer.segment. Business justification: Demand forecasts in industrial manufacturing are driven by customer segment demand signals (e.g., automotive vs. energy). Procurement planners segment forecasts by customer category to align material ',
    `spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.spend_category. Business justification: Demand forecasts are organized by product/spend category to drive category-level supply planning and MRP inputs. The existing product_category_code (STRING) is a denormalized code; adding spend_catego',
    `stock_position_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_position. Business justification: Demand forecasts are created at the material/stock position level to project future inventory needs. Procurement planners reference current stock positions when building forecasts to calculate net pro',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: Demand forecasts must be expressed in the products defined unit of measure to ensure MRP calculations and procurement quantities are consistent. UOM is a mandatory reference on every forecast record.',
    `abc_classification` STRING COMMENT 'ABC inventory classification of the forecasted material based on consumption value: A (high value/high attention), B (medium), C (low value/low attention). Drives differentiated forecasting and safety stock policies.. Valid values are `A|B|C`',
    `approved_by` STRING COMMENT 'Name or user ID of the demand planner or S&OP manager who approved and locked the consensus forecast for MRP consumption. Supports audit trail and accountability in the S&OP governance process.',
    `approved_date` DATE COMMENT 'Date on which the forecast was formally approved and locked for MRP input. Used for S&OP cycle governance, audit compliance, and measuring planning cycle time.. Valid values are `^d{4}-d{2}-d{2}$`',
    `consensus_adjustment_quantity` DECIMAL(18,2) COMMENT 'Manual quantity adjustment applied to the statistical baseline during the S&OP consensus process. Positive values indicate upward revision; negative values indicate downward revision. Captures commercial intelligence not reflected in historical data.. Valid values are `^-?[0-9]+(.[0-9]{1,4})?$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the plant or demand origin location. Supports regional demand aggregation, cross-border supply planning, and regulatory compliance reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the demand forecast record was first created in the source system or ingested into the lakehouse silver layer. Supports data lineage, audit trail, and SCD (Slowly Changing Dimension) processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for any monetary values associated with the forecast (e.g., forecasted spend, standard cost valuation). Supports multi-currency reporting in global operations.. Valid values are `^[A-Z]{3}$`',
    `demand_category` STRING COMMENT 'Classification of the demand type: independent (end-customer driven), dependent (derived from parent BOM), spare parts (aftermarket service), promotional (campaign-driven), new product introduction, or phase-out. Drives appropriate forecasting methodology selection.. Valid values are `independent|dependent|spare_parts|service|promotional|new_product|phase_out`',
    `forecast_algorithm` STRING COMMENT 'Statistical or algorithmic method used to generate the baseline forecast. Supports model governance, accuracy benchmarking, and algorithm selection optimization within the S&OP process.. Valid values are `exponential_smoothing|moving_average|holt_winters|arima|causal|machine_learning|manual`',
    `forecast_bias` DECIMAL(18,2) COMMENT 'Systematic directional error in the forecast, calculated as the average of (forecast minus actual) over the evaluation period. Positive bias indicates consistent over-forecasting; negative bias indicates under-forecasting. Used to detect and correct systemic forecast errors.. Valid values are `^-?[0-9]+(.[0-9]{1,4})?$`',
    `forecast_end_date` DATE COMMENT 'End date of the forecast time bucket. Together with forecast_start_date, defines the discrete planning period for which the forecasted quantity applies.. Valid values are `^d{4}-d{2}-d{2}$`',
    `forecast_number` STRING COMMENT 'Business-facing alphanumeric identifier for the forecast record, used in S&OP meetings, planning reports, and cross-functional communications. Typically sourced from SAP MRP or APO planning run identifiers.. Valid values are `^FC-[0-9]{4}-[0-9]{6}$`',
    `forecast_period_type` STRING COMMENT 'Granularity of the forecast time bucket: weekly (for near-term operational planning), monthly (for mid-term S&OP), or quarterly (for strategic capacity planning and supplier reservation).. Valid values are `weekly|monthly|quarterly`',
    `forecast_start_date` DATE COMMENT 'Start date of the forecast time bucket (week, month, or quarter). Combined with forecast_end_date, defines the planning horizon window for this forecast record.. Valid values are `^d{4}-d{2}-d{2}$`',
    `forecasted_quantity` DECIMAL(18,2) COMMENT 'Final consensus demand quantity for the forecast period after all adjustments. This is the primary demand signal consumed by MRP planning runs to generate planned orders and purchase requisitions.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `forecasted_spend_amount` DECIMAL(18,2) COMMENT 'Estimated procurement spend for the forecasted quantity, calculated using the standard or moving average price. Used for budget planning, spend analytics, and supplier capacity reservation negotiations.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `is_mrp_relevant` BOOLEAN COMMENT 'Indicates whether this forecast record is active and eligible to be consumed as a demand signal in the next MRP planning run. False records are excluded from MRP net requirements calculation.. Valid values are `true|false`',
    `is_supplier_shared` BOOLEAN COMMENT 'Indicates whether this forecast has been shared with the supplier for capacity reservation purposes. Supports collaborative planning (CPFR) and supplier capacity commitment tracking.. Valid values are `true|false`',
    `lot_size_procedure` STRING COMMENT 'SAP lot-sizing procedure used when converting forecast demand into planned orders or purchase requisitions: exact (lot-for-lot), fixed quantity, economic order quantity (EOQ), period-based, or min/max. Affects procurement cost and inventory levels.. Valid values are `exact|fixed|economic_order_quantity|period|minimum_maximum`',
    `mape` DECIMAL(18,2) COMMENT 'Mean Absolute Percentage Error measuring forecast accuracy as a percentage deviation between forecasted and actual demand over the trailing evaluation period. Lower values indicate higher forecast accuracy. Key KPI for S&OP performance management.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the demand forecast record, whether from a consensus adjustment, status change, or MRP parameter update. Enables incremental data processing and change detection in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `mrp_area` STRING COMMENT 'SAP MRP area within the plant that further segments planning for sub-plant locations such as storage locations or subcontractor areas. Enables granular supply planning below plant level.',
    `mrp_type` STRING COMMENT 'SAP MRP type assigned to the material, determining the planning logic applied: standard MRP (deterministic), consumption-based, reorder point, forecast-based, or manual. Directly impacts how the forecast drives procurement signals.. Valid values are `MRP|consumption_based|reorder_point|forecast_based|manual`',
    `planning_horizon_months` STRING COMMENT 'Number of months into the future this forecast record covers, measured from the forecast creation date. Determines how far out the demand signal extends for supplier capacity reservation and long-lead procurement.. Valid values are `^[0-9]+$`',
    `plant_code` STRING COMMENT 'SAP plant code representing the manufacturing or distribution facility for which the demand forecast is generated. Drives MRP planning at the plant level.. Valid values are `^[A-Z0-9]{4}$`',
    `procurement_type` STRING COMMENT 'SAP MRP procurement type indicator specifying how the material is sourced: externally purchased, produced in-house, subcontracted, on consignment, or via stock transfer order. Determines which planning elements MRP generates.. Valid values are `external|in_house|subcontracting|consignment|stock_transfer`',
    `product_category_code` STRING COMMENT 'Procurement category or commodity code classifying the forecasted material (e.g., raw materials, electronic components, MRO). Enables category-level demand aggregation for strategic sourcing and spend analytics.',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization responsible for procuring the forecasted material. Links demand signals to sourcing and supplier capacity reservation activities.',
    `reorder_point` DECIMAL(18,2) COMMENT 'Inventory level at which a replenishment order should be triggered, calculated from the forecast demand rate and supplier lead time. Directly fed into SAP MRP reorder point planning.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `safety_stock_quantity` DECIMAL(18,2) COMMENT 'Recommended safety stock level derived from this forecast, accounting for demand variability and supply lead time uncertainty. Used to set reorder points and buffer stock targets in SAP MRP.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `sop_cycle` STRING COMMENT 'The S&OP planning cycle (YYYY-MM) in which this forecast was generated or last reviewed. Links the forecast to the specific monthly S&OP process iteration for governance and audit purposes.. Valid values are `^[0-9]{4}-(0[1-9]|1[0-2])$`',
    `source_system` STRING COMMENT 'Operational system of record from which this forecast record originated (e.g., SAP S/4HANA PP-MRP, SAP APO, manual Excel upload). Supports data lineage tracking and reconciliation in the lakehouse silver layer.. Valid values are `SAP_S4HANA|SAP_APO|EXCEL|MANUAL|EXTERNAL`',
    `statistical_forecast_quantity` DECIMAL(18,2) COMMENT 'System-generated statistical forecast quantity produced by the forecasting algorithm (e.g., exponential smoothing, moving average) before any manual consensus adjustments. Serves as the baseline for S&OP review.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `status` STRING COMMENT 'Current lifecycle status of the demand forecast record. Locked forecasts are consumed by MRP planning runs. Superseded records are replaced by newer versions.. Valid values are `draft|in_review|approved|locked|superseded|cancelled`',
    `supplier_lead_time_days` STRING COMMENT 'Planned replenishment lead time in calendar days from purchase order placement to goods receipt, as used in MRP net requirements calculation. Drives the timing of procurement signals relative to the forecast period.. Valid values are `^[0-9]+$`',
    `version_number` STRING COMMENT 'Sequential version number of the forecast for a given material, plant, and period combination. Enables tracking of forecast revisions across S&OP cycles and consensus planning rounds.. Valid values are `^[0-9]+$`',
    `version_type` STRING COMMENT 'Classifies the nature of the forecast version: baseline (initial statistical run), statistical (algorithm-generated), consensus (cross-functional agreed), final (locked for MRP input), adjusted (manually overridden), or simulation (what-if scenario).. Valid values are `baseline|statistical|consensus|final|adjusted|simulation`',
    `xyz_classification` STRING COMMENT 'XYZ demand variability classification: X (stable/predictable demand), Y (variable demand), Z (irregular/sporadic demand). Combined with ABC classification to determine optimal forecasting strategy and safety stock levels.. Valid values are `X|Y|Z`',
    CONSTRAINT pk_demand_forecast PRIMARY KEY(`demand_forecast_id`)
) COMMENT 'Forward-looking demand signals used to drive supply planning and MRP inputs. Captures forecast version, material, plant, forecast period (weekly/monthly), forecasted quantity, statistical forecast baseline, consensus forecast adjustments, and forecast accuracy metrics (MAPE, bias). Supports S&OP (Sales and Operations Planning), safety stock optimization, and supplier capacity reservation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` (
    `supply_agreement_id` BIGINT COMMENT 'Unique system-generated identifier for the supply agreement record in the procurement data platform. Serves as the primary key for all downstream joins and references.',
    `profitability_segment_id` BIGINT COMMENT 'Foreign key linking to finance.profitability_segment. Business justification: Supply agreements for direct materials are linked to profitability segments so procurement costs can be traced to product lines or customer segments in margin analysis reporting.',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Every supply agreement and blanket purchase agreement is negotiated with a specific supplier. The current supplier_code (STRING) is a denormalized reference to the supplier master. Adding supplier_id ',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: Supply agreements define contracted quantities and pricing in a specific unit of measure. Procurement contracts teams reference the product UOM to ensure agreement terms are legally and operationally ',
    `agreement_number` STRING COMMENT 'Business-facing document number assigned to the supply agreement, corresponding to the SAP MM Outline Agreement document number (e.g., scheduling agreement or contract number). Used for cross-system reference and supplier communication.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `agreement_type` STRING COMMENT 'Classification of the supply agreement by its commercial and operational structure. Scheduling agreements govern delivery schedules; blanket orders allow multiple releases up to a committed value; framework contracts define terms for future individual orders; master supply agreements set overarching terms across multiple categories.. Valid values are `scheduling_agreement|blanket_order|framework_contract|master_supply_agreement|call_off_contract`',
    `approval_status` STRING COMMENT 'Current status of the internal approval workflow for this supply agreement. Tracks progression through the procurement authorization hierarchy before the agreement becomes active and releases are permitted.. Valid values are `not_submitted|pending|approved|rejected|revision_required`',
    `approved_by` STRING COMMENT 'Name or user ID of the procurement authority who granted final approval for this supply agreement. Required for audit trail and segregation of duties compliance.',
    `approved_date` DATE COMMENT 'Date on which the supply agreement received final internal approval and was authorized for release. Used for procurement cycle time analysis and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ariba_contract_reference` STRING COMMENT 'Unique contract identifier assigned by SAP Ariba Contract Management for this supply agreement. Enables cross-system reconciliation between the Ariba contract repository and SAP MM Outline Agreement.. Valid values are `^[A-Z0-9-]{3,50}$`',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether this supply agreement automatically renews upon expiry unless formally terminated by either party within the notice period. Drives contract lifecycle management alerts and renewal workflows.. Valid values are `true|false`',
    `category_code` STRING COMMENT 'Procurement commodity or spend category code (e.g., UNSPSC or internal taxonomy) classifying the goods or services covered by this supply agreement. Enables spend analytics, category management, and strategic sourcing alignment.. Valid values are `^[A-Z0-9-.]{2,20}$`',
    `country_of_supply` STRING COMMENT 'ISO 3166-1 alpha-3 country code identifying the primary country from which goods or services are supplied under this agreement. Used for supply chain risk assessment, import/export compliance, and REACH/RoHS regulatory tracking.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the supply agreement record was first created in the procurement system. Used for data lineage, audit trail, and SLA compliance tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which all monetary values within this supply agreement are denominated (e.g., USD, EUR, GBP). Supports multi-currency procurement operations across global manufacturing sites.. Valid values are `^[A-Z]{3}$`',
    `effective_end_date` DATE COMMENT 'Date on which the supply agreement expires and no further releases are permitted without renewal. Corresponds to the validity end date in SAP MM Outline Agreement. Used for contract renewal alerts and compliance monitoring.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_start_date` DATE COMMENT 'Date from which the supply agreement becomes legally effective and purchase order releases are permitted. Corresponds to the validity start date in SAP MM Outline Agreement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the delivery obligations, risk transfer point, and cost responsibilities between buyer and supplier under this supply agreement.. Valid values are `^(EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF)$`',
    `incoterms_location` STRING COMMENT 'Named place or port associated with the Incoterms code, specifying the exact location where risk and cost transfer between supplier and buyer (e.g., Port of Hamburg for FOB, Buyer Warehouse, Detroit for DDP).',
    `minimum_call_off_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity that must be ordered per release or call-off against this supply agreement, as contractually agreed with the supplier. Violations may trigger penalty clauses or supplier non-compliance flags.. Valid values are `^d+(.d{1,3})?$`',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the supply agreement record. Used for change detection, data synchronization, and audit trail maintenance in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `payment_terms_code` STRING COMMENT 'SAP payment terms key defining the payment conditions negotiated under this supply agreement (e.g., net 30, 2/10 net 30, immediate payment). Drives accounts payable processing and cash flow planning.. Valid values are `^[A-Z0-9]{2,10}$`',
    `penalty_clause_description` STRING COMMENT 'Textual description of the penalty terms applicable under this supply agreement, including trigger conditions, penalty calculation method, and maximum liability caps. Populated when penalty_clause_flag is true.',
    `penalty_clause_flag` BOOLEAN COMMENT 'Indicates whether this supply agreement contains contractual penalty clauses for supplier non-performance, late delivery, quality failures, or minimum volume shortfalls. When true, penalty terms are documented in the agreement.. Valid values are `true|false`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility that is the primary recipient of goods or services under this supply agreement. Relevant for scheduling agreements tied to specific production sites.. Valid values are `^[A-Z0-9]{2,10}$`',
    `pricing_condition_type` STRING COMMENT 'Type of pricing mechanism agreed with the supplier. Fixed price locks unit cost for the agreement duration; tiered volume pricing adjusts price based on quantity thresholds; index-linked pricing ties price to a commodity index; cost-plus adds a margin to supplier cost.. Valid values are `fixed_price|tiered_volume|index_linked|cost_plus|time_and_material|frame_rate`',
    `procurement_type` STRING COMMENT 'Classification of the procurement scope as direct materials (used in production), indirect materials (operational supplies), MRO (Maintenance Repair and Operations), services, or capital expenditure. Drives accounting treatment, approval workflows, and spend reporting.. Valid values are `direct|indirect|mro|services|capital`',
    `purchasing_group_code` STRING COMMENT 'SAP purchasing group code identifying the buyer or buyer team responsible for day-to-day management of this supply agreement, including release creation and supplier communication.. Valid values are `^[A-Z0-9]{2,10}$`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for negotiating and managing this supply agreement. Determines the organizational unit with procurement authority and defines the scope of the agreement within the enterprise hierarchy.. Valid values are `^[A-Z0-9]{2,10}$`',
    `released_quantity` DECIMAL(18,2) COMMENT 'Cumulative quantity of goods or services released against this supply agreement through purchase order releases or delivery schedule lines. Used to track agreement consumption against committed volume.. Valid values are `^d+(.d{1,3})?$`',
    `released_value` DECIMAL(18,2) COMMENT 'Cumulative monetary value of all purchase order releases issued against this supply agreement to date. Compared against total_committed_value to monitor agreement utilization and remaining open commitment.. Valid values are `^d+(.d{1,2})?$`',
    `renewal_notice_days` STRING COMMENT 'Number of calendar days prior to agreement expiry by which either party must provide written notice of intent not to renew. Used to trigger contract renewal review workflows and supplier negotiation planning.. Valid values are `^d{1,4}$`',
    `sap_outline_agreement_number` STRING COMMENT 'SAP MM document number for the Outline Agreement (scheduling agreement or contract) created via transaction ME31L or ME31K. Primary cross-reference key for integration with SAP S/4HANA procurement and finance modules.. Valid values are `^[0-9]{10}$`',
    `sourcing_event_reference` STRING COMMENT 'Reference number of the SAP Ariba sourcing event (RFQ/RFP/auction) that resulted in the award of this supply agreement. Provides traceability from competitive sourcing to contracted agreement for audit and compliance purposes.. Valid values are `^[A-Z0-9-]{3,30}$`',
    `status` STRING COMMENT 'Current lifecycle status of the supply agreement. Drives procurement workflow, release authorization, and reporting. Active agreements permit purchase order releases; suspended agreements are temporarily blocked; terminated agreements are closed before natural expiry.. Valid values are `draft|pending_approval|active|suspended|expired|terminated|closed`',
    `termination_date` DATE COMMENT 'Actual date on which the supply agreement was terminated prior to its natural expiry, if applicable. Populated only for agreements with status terminated. Used for supplier relationship analysis and spend impact assessment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `termination_reason` STRING COMMENT 'Reason code for early termination of the supply agreement. Supports supplier performance analysis, sourcing strategy reviews, and risk management reporting.. Valid values are `supplier_default|mutual_agreement|strategic_sourcing_change|regulatory_non_compliance|financial_insolvency|force_majeure|other`',
    `title` STRING COMMENT 'Short descriptive title of the supply agreement used for identification in procurement systems, dashboards, and supplier communications. Typically includes supplier name, commodity category, and agreement year.',
    `total_committed_quantity` DECIMAL(18,2) COMMENT 'Total volume of goods or services committed under this supply agreement over its validity period, expressed in the agreement unit of measure. Applicable primarily to scheduling agreements and volume-based contracts.. Valid values are `^d+(.d{1,3})?$`',
    `total_committed_value` DECIMAL(18,2) COMMENT 'Total monetary value committed under this supply agreement over its validity period, as negotiated with the supplier. For blanket orders, this is the maximum release value. For scheduling agreements, this is the total planned spend. Used for spend commitment reporting and budget planning.. Valid values are `^d+(.d{1,2})?$`',
    `unit_price` DECIMAL(18,2) COMMENT 'Negotiated unit price for the primary material or service covered by this supply agreement, expressed in the agreement currency. For tiered or index-linked agreements, this represents the base or reference price.. Valid values are `^d+(.d{1,4})?$`',
    CONSTRAINT pk_supply_agreement PRIMARY KEY(`supply_agreement_id`)
) COMMENT 'Long-term supply agreements and blanket purchase agreements negotiated with strategic suppliers. Captures agreement type (scheduling agreement, blanket order, framework contract), validity period, total committed volume, pricing conditions, release schedule, minimum call-off quantities, and penalty clauses. Aligned with SAP MM Outline Agreement (ME31L/ME31K). Distinct from individual POs which are releases against agreements.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` (
    `delivery_schedule_id` BIGINT COMMENT 'Unique system-generated identifier for each delivery schedule line released against a supply agreement or blanket Purchase Order (PO). Serves as the primary key for the delivery_schedule data product.',
    `address_id` BIGINT COMMENT 'Foreign key linking to customer.address. Business justification: In drop-ship or direct-to-customer delivery models common in industrial manufacturing, supplier delivery schedules reference the customers ship-to address directly. Eliminates address duplication and',
    `schedule_line_id` BIGINT COMMENT 'Foreign key linking to order.schedule_line. Business justification: Supplier delivery schedules in procurement are directly aligned to customer-facing schedule lines in sales orders. Supply chain coordinators map inbound delivery dates to outbound schedule commitments',
    `sla_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.sla_agreement. Business justification: Supplier delivery schedules in industrial manufacturing are structured around customer SLA commitments. Logistics and procurement teams use the SLA agreement to set inbound delivery windows that guara',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Delivery schedule lines are fulfilled by a specific supplier. The current supplier_code (STRING) is a denormalized reference. Adding supplier_id as a FK to the supplier master normalizes the supplier ',
    `supply_agreement_id` BIGINT COMMENT 'Foreign key linking to procurement.supply_agreement. Business justification: Delivery schedules are released against supply agreements (scheduling agreements in SAP). This is a fundamental parent-child relationship in the scheduling agreement lifecycle. agreement_number is ret',
    `actual_delivery_date` DATE COMMENT 'Calendar date on which the supplier actually delivered the material and the Goods Receipt Note (GRN) was posted. Compared against scheduled_delivery_date to calculate on-time delivery performance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `agreement_number` STRING COMMENT 'Reference number of the parent supply agreement or blanket Purchase Order (PO) against which this delivery schedule line is released. Links the schedule to its governing contractual instrument.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `confirmed_quantity` DECIMAL(18,2) COMMENT 'Quantity confirmed by the supplier as committed for delivery on the scheduled date. May differ from scheduled quantity due to supplier capacity constraints or partial confirmations.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the delivery schedule line was first created in the source system, recorded in ISO 8601 format with timezone offset. Supports audit trail and data lineage requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `cumulative_delivered_quantity` DECIMAL(18,2) COMMENT 'Running cumulative total of all quantities actually received against this scheduling agreement line from the start of the agreement period. Enables cumulative quantity reconciliation and supplier delivery performance analysis.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `cumulative_scheduled_quantity` DECIMAL(18,2) COMMENT 'Running cumulative total of all scheduled quantities from the beginning of the scheduling agreement period to the current schedule line. Used in automotive and lean manufacturing for cumulative quantity reconciliation with suppliers.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the unit price and schedule value (e.g., USD, EUR, GBP, JPY). Supports multi-currency procurement operations across global manufacturing sites.. Valid values are `^[A-Z]{3}$`',
    `days_early_late` STRING COMMENT 'Number of calendar days the actual delivery was early (negative value) or late (positive value) relative to the scheduled delivery date. Key metric for supplier delivery performance scorecards.. Valid values are `^-?[0-9]{1,4}$`',
    `delivered_quantity` DECIMAL(18,2) COMMENT 'Quantity actually received and posted via Goods Receipt Note (GRN) processing against this schedule line. Used to calculate delivery completeness and schedule adherence.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `delivery_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code of the delivery destination, supporting multinational logistics, customs compliance, and cross-border trade documentation.. Valid values are `^[A-Z]{3}$`',
    `delivery_note_number` STRING COMMENT 'Supplier-provided delivery note or packing slip number accompanying the physical shipment. Used for three-way matching (PO, GRN, invoice) and discrepancy resolution.. Valid values are `^[A-Z0-9-]{1,35}$`',
    `grn_number` STRING COMMENT 'Reference number of the Goods Receipt Note (GRN) document posted in SAP S/4HANA upon physical receipt of the delivery. Links the schedule line to the inventory posting and financial accrual.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms 2020) code defining the transfer of risk, cost responsibility, and delivery obligations between buyer and supplier for this schedule line.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `is_on_time` BOOLEAN COMMENT 'Boolean flag indicating whether the actual delivery date fell within the scheduled delivery window (true) or was late/early (false). Populated upon GRN posting and used for supplier on-time delivery (OTD) performance KPI reporting.. Valid values are `true|false`',
    `jit_delivery_window_end` TIMESTAMP COMMENT 'Latest acceptable timestamp for supplier delivery under JIT (Just-In-Time) replenishment rules. Deliveries after this timestamp are considered late and trigger schedule adherence exceptions.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `jit_delivery_window_start` TIMESTAMP COMMENT 'Earliest acceptable timestamp for supplier delivery under JIT (Just-In-Time) replenishment rules. Deliveries before this timestamp are considered early and may be rejected or incur storage costs.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `kanban_signal_number` STRING COMMENT 'Unique identifier of the Kanban replenishment signal that triggered this delivery schedule line. Applicable for Kanban-managed materials where pull signals drive supplier delivery requests.. Valid values are `^[A-Z0-9-]{1,30}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the delivery schedule line in the source system. Used for incremental data loading, change detection, and audit trail maintenance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `line_number` STRING COMMENT 'Sequential line item number within the delivery schedule document, distinguishing individual delivery date/quantity combinations within the same schedule release.. Valid values are `^[0-9]{1,5}$`',
    `material_description` STRING COMMENT 'Short description of the material or component to be delivered, providing human-readable context for the material number in reports and supplier communications.',
    `material_number` STRING COMMENT 'SAP material number or internal part number identifying the specific raw material, component, or indirect material to be delivered. Used for MRP (Material Requirements Planning) reconciliation and inventory management.. Valid values are `^[A-Z0-9-.]{1,40}$`',
    `mrp_element_type` STRING COMMENT 'Type of MRP (Material Requirements Planning) planning element that generated or is associated with this delivery schedule line, indicating whether it originated from a planned order, purchase requisition, or scheduling agreement release.. Valid values are `planned_order|purchase_requisition|scheduling_agreement|purchase_order|stock_transfer`',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing facility or distribution center that is the destination for the scheduled delivery. Drives MRP planning and inventory posting.. Valid values are `^[A-Z0-9]{4}$`',
    `purchasing_group_code` STRING COMMENT 'SAP purchasing group (buyer group) code identifying the individual buyer or team responsible for managing this delivery schedule and supplier relationship.. Valid values are `^[A-Z0-9]{3}$`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code responsible for managing the supply agreement and releasing delivery schedules. Represents the organizational unit with procurement authority.. Valid values are `^[A-Z0-9]{4}$`',
    `release_type` STRING COMMENT 'Indicates whether this schedule line is a forecast release (planning horizon, non-binding), a JIT (Just-In-Time) release (firm, short-term), an immediate release, or a manually created release.. Valid values are `forecast|jit|immediate|manual`',
    `sap_scheduling_agreement_number` STRING COMMENT 'SAP S/4HANA internal 10-digit document number for the scheduling agreement (Outline Agreement) from which this delivery schedule line was released. Enables direct traceability to the source system record.. Valid values are `^[0-9]{10}$`',
    `schedule_adherence_status` STRING COMMENT 'Categorical assessment of supplier delivery adherence for this schedule line: on_time (within window), early (before JIT window start), late (after scheduled date), partial (quantity shortfall), missed (no delivery), or pending (not yet due).. Valid values are `on_time|early|late|partial|missed|pending`',
    `schedule_number` STRING COMMENT 'Business-facing alphanumeric identifier for the delivery schedule document, used for cross-system reference and supplier communication. Corresponds to the scheduling agreement release number in SAP S/4HANA MM.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `schedule_type` STRING COMMENT 'Classification of the delivery schedule indicating the replenishment strategy: JIT (Just-In-Time) for time-critical lean deliveries, forecast for planning horizon releases, firm for committed quantities, or Kanban for pull-based replenishment signals.. Valid values are `jit|forecast|firm|kanban|blanket_release|spot`',
    `scheduled_delivery_date` DATE COMMENT 'Planned calendar date on which the supplier is required to deliver the material to the specified plant or delivery location. Core field for JIT delivery window management and supplier on-time delivery (OTD) performance tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `scheduled_delivery_time` STRING COMMENT 'Specific time of day (HH:MM, 24-hour format) within the scheduled delivery date by which the supplier must deliver, supporting JIT (Just-In-Time) delivery window precision and dock scheduling.. Valid values are `^([01]d|2[0-3]):[0-5]d$`',
    `scheduled_quantity` DECIMAL(18,2) COMMENT 'Quantity of material scheduled for delivery on the specified date, expressed in the base unit of measure. Drives MRP (Material Requirements Planning) supply coverage calculations and Kanban replenishment signal sizing.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `sku_code` STRING COMMENT 'Stock Keeping Unit (SKU) code used for warehouse and inventory tracking of the scheduled material, aligning with Infor WMS inventory records.. Valid values are `^[A-Z0-9-.]{1,50}$`',
    `status` STRING COMMENT 'Current lifecycle status of the delivery schedule line, tracking progression from initial release through supplier confirmation, shipment, receipt, and closure. Supports schedule adherence monitoring and exception management.. Valid values are `draft|released|confirmed|in_transit|partially_delivered|delivered|cancelled|overdue|closed`',
    `storage_location_code` STRING COMMENT 'SAP storage location within the receiving plant where the delivered material will be physically stored upon Goods Receipt Note (GRN) processing.. Valid values are `^[A-Z0-9]{4}$`',
    `tolerance_over_percent` DECIMAL(18,2) COMMENT 'Maximum percentage by which the supplier may over-deliver against the scheduled quantity without triggering a rejection or return. Defined in the supply agreement and enforced during GRN processing.. Valid values are `^[0-9]{1,3}(.[0-9]{1,2})?$`',
    `tolerance_under_percent` DECIMAL(18,2) COMMENT 'Maximum percentage by which the supplier may under-deliver against the scheduled quantity and still have the delivery accepted as complete. Defined in the supply agreement.. Valid values are `^[0-9]{1,3}(.[0-9]{1,2})?$`',
    `unit_of_measure` STRING COMMENT 'Base unit of measure for the scheduled, confirmed, and delivered quantities (e.g., EA for each, KG for kilogram, M for meter, L for liter, PC for piece). Aligns with SAP material master UoM configuration.. Valid values are `^[A-Z]{2,5}$`',
    `unit_price` DECIMAL(18,2) COMMENT 'Agreed price per unit of measure for the material as specified in the supply agreement or blanket PO. Used for financial accruals, goods receipt valuation, and spend analytics.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    CONSTRAINT pk_delivery_schedule PRIMARY KEY(`delivery_schedule_id`)
) COMMENT 'Scheduled delivery lines released against a supply agreement or blanket PO specifying exact delivery dates, quantities, and delivery locations. Captures JIT (Just-In-Time) delivery windows, Kanban replenishment signals, cumulative quantities, and schedule adherence tracking. Supports lean manufacturing replenishment and supplier delivery performance monitoring.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`source_list` (
    `source_list_id` BIGINT COMMENT 'Unique surrogate identifier for each source list record in the Databricks Silver Layer. Serves as the primary key for the source_list data product.',
    `approved_manufacturer_id` BIGINT COMMENT 'Foreign key linking to engineering.approved_manufacturer. Business justification: The procurement source list (which suppliers can supply a given part) must be constrained to engineerings AML. Only AML-approved manufacturers may appear on the source list — this link enforces that ',
    `plant_id` BIGINT COMMENT 'Foreign key linking to product.product_plant. Business justification: Source lists in manufacturing are maintained at the product-plant level to define valid supply sources per plant. MRP uses source lists to automatically assign planned orders to approved suppliers for',
    `quota_arrangement_id` BIGINT COMMENT 'Foreign key linking to procurement.quota_arrangement. Business justification: Source list entries can reference quota arrangements that define the volume split across multiple approved suppliers. The table has quota_arrangement_number. Adding quota_arrangement_id FK formalizes ',
    `supply_agreement_id` BIGINT COMMENT 'Foreign key linking to procurement.supply_agreement. Business justification: Source list entries can reference supply agreements as the approved source of supply for a material. The table has outline_agreement_number. Adding supply_agreement_id FK formalizes this relationship ',
    `agreement_type` STRING COMMENT 'Type of supply agreement referenced by this source list entry. Scheduling agreement = delivery schedule-based; Contract = quantity/value contract; Blanket PO = open purchase order; None = spot/info record-based sourcing.. Valid values are `scheduling_agreement|contract|blanket_po|none`',
    `approved_by` STRING COMMENT 'Name or user ID of the procurement professional or category manager who approved this source list entry. Supports audit trail and procurement governance requirements.',
    `country_of_origin` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code indicating the country where the material is manufactured or sourced from. Used for trade compliance, import/export controls, REACH/RoHS compliance, and supply chain risk assessment.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this source list record was first created in the source system (SAP MM). Used for audit trail, data lineage, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the pricing currency agreed with this supplier for this material. Used for multi-currency procurement and spend analytics in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `info_record_number` STRING COMMENT 'Reference to the SAP purchasing info record that holds the negotiated price and conditions for this material-supplier-plant combination. Used when no outline agreement exists.',
    `is_blocked` BOOLEAN COMMENT 'Indicates whether this source of supply is explicitly blocked from being used for procurement. A blocked source cannot be selected for purchase requisitions or purchase orders, even if within the validity period.. Valid values are `true|false`',
    `is_fixed_source` BOOLEAN COMMENT 'Indicates whether this supplier is designated as the fixed (mandatory) source of supply for the material-plant combination. When true, MRP will exclusively generate purchase requisitions for this supplier, overriding other approved sources.. Valid values are `true|false`',
    `is_mrp_source_list_required` BOOLEAN COMMENT 'Indicates whether the source list is mandatory for MRP to generate purchase requisitions for this material-plant combination. When true, MRP will only create purchase requisitions for sources listed in the source list.. Valid values are `true|false`',
    `is_preferred_source` BOOLEAN COMMENT 'Indicates whether this supplier is the preferred (but not mandatory) source of supply. When multiple approved sources exist, the preferred source is prioritized during manual and automatic sourcing decisions.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this source list record in the source system. Supports change tracking, data freshness monitoring, and incremental data loading in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_reviewed_date` DATE COMMENT 'Date when this source list entry was last reviewed and validated by the procurement or category management team. Supports supplier qualification governance and periodic source list maintenance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `material_description` STRING COMMENT 'Short descriptive text for the material as maintained in the material master. Provides human-readable context for the source list entry without requiring a join to the material master.',
    `material_group` STRING COMMENT 'SAP material group (commodity category) classifying the material for spend analytics, category management, and sourcing strategy alignment. Used in procurement reporting and supplier segmentation.',
    `maximum_order_quantity` DECIMAL(18,2) COMMENT 'Maximum quantity that can be ordered from this supplier in a single purchase order. Used to enforce supply capacity constraints and split large requirements across multiple sources.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity that must be ordered from this supplier in a single purchase order. MRP considers this constraint when generating purchase requisitions for this source.',
    `mrp_relevance_indicator` STRING COMMENT 'Controls how MRP uses this source list entry when generating purchase requisitions. 0 = Not relevant for MRP (manual sourcing only); 1 = MRP can generate purchase requisitions for this source; 2 = Source is blocked for MRP (MRP must not use this source). Directly maps to SAP EORD-MODUS field.. Valid values are `0|1|2`',
    `notes` STRING COMMENT 'Free-text field for additional context, sourcing rationale, exceptions, or special instructions related to this source list entry. Used by procurement teams to document sourcing decisions.',
    `number` STRING COMMENT 'Business-facing identifier for the source list entry as assigned in SAP MM (EORD table key). Used for cross-referencing with procurement documents and MRP outputs.',
    `order_unit` STRING COMMENT 'Unit of measure in which the material is ordered from this supplier (e.g., EA, KG, M, L, PC). May differ from the materials base unit of measure and is specific to this supplier relationship.',
    `outline_agreement_item` STRING COMMENT 'Line item number within the referenced outline agreement (scheduling agreement or contract) that corresponds to this source list entry. Required when the agreement covers multiple materials.',
    `outline_agreement_number` STRING COMMENT 'Reference to the SAP scheduling agreement or contract (outline agreement) that governs the supply relationship for this source list entry. Links the source list to a binding supply agreement.',
    `plant_of_supply` STRING COMMENT 'For internal/inter-plant supply types, identifies the supplying plant (internal manufacturing or distribution center) that will fulfill the demand. Applicable when supply_type is internal_plant or stock_transfer.',
    `procurement_type` STRING COMMENT 'Classifies whether the material is procured as direct material (used in production, part of BOM) or indirect material (MRO, services, overhead). Drives different procurement workflows and spend analytics.. Valid values are `direct|indirect`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization responsible for negotiating and managing the supply agreement with the supplier for this material-plant combination.',
    `quota_arrangement_number` STRING COMMENT 'Reference to the SAP quota arrangement that governs the percentage split of procurement volume across multiple approved sources for this material-plant combination. Enables multi-source supply strategies.',
    `quota_percentage` DECIMAL(18,2) COMMENT 'Percentage of total procurement volume for this material-plant combination allocated to this supplier source. Used in multi-source supply strategies to distribute demand across approved suppliers.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this source list record was ingested into the Databricks Silver Layer. Supports data lineage and multi-system reconciliation in the lakehouse architecture.. Valid values are `SAP_S4HANA|SAP_ECC|ARIBA|MANUAL`',
    `special_procurement_type` STRING COMMENT 'SAP special procurement type code indicating non-standard procurement scenarios such as subcontracting (supplier processes company-owned components), consignment (supplier-owned stock), third-party (direct shipment to customer), or pipeline (continuous supply).. Valid values are `standard|subcontracting|consignment|third_party|pipeline`',
    `standard_lead_time_days` STRING COMMENT 'Standard procurement lead time in calendar days from purchase order placement to goods receipt for this material-supplier-plant combination. Used by MRP for scheduling and delivery date calculation.. Valid values are `^[0-9]+$`',
    `status` STRING COMMENT 'Current operational status of the source list entry. Indicates whether the source is currently active and usable for procurement, expired due to validity period lapse, blocked, or pending approval.. Valid values are `active|inactive|expired|blocked|pending_approval`',
    `sub_range` STRING COMMENT 'Supplier sub-range code identifying a specific product line, manufacturing site, or division within the suppliers organization that is the approved source. Relevant for large suppliers with multiple production facilities.',
    `supply_type` STRING COMMENT 'Categorizes the type of supply relationship for this source list entry. External supplier = standard third-party procurement; Internal plant = inter-plant stock transfer; Subcontracting = supplier processes company-owned materials; Consignment = supplier-owned stock at company premises; Stock transfer = intra-company movement.. Valid values are `external_supplier|internal_plant|subcontracting|consignment|stock_transfer`',
    `usage` STRING COMMENT 'Defines whether the source list is mandatory (procurement must use only listed sources) or optional (source list is advisory). Controlled at the material master level but captured here for analytical context.. Valid values are `mandatory|optional`',
    `valid_from_date` DATE COMMENT 'Start date of the validity period during which this source of supply is approved and active. MRP will only consider this source for automatic purchase requisition generation within the validity window.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'End date of the validity period for this source of supply. After this date, the source is no longer considered by MRP for automatic purchase requisition generation.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_source_list PRIMARY KEY(`source_list_id`)
) COMMENT 'Defines the approved and preferred sources of supply for each material at each plant. Captures valid supplier sources, supply agreement references, fixed/preferred source indicators, MRP relevance flags, and validity periods. Controls which suppliers MRP can automatically generate purchase requisitions for. Aligned with SAP MM Source List (ME01/EORD).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` (
    `quota_arrangement_id` BIGINT COMMENT 'Unique surrogate identifier for the quota arrangement record in the Databricks Silver Layer. Serves as the primary key for this entity.',
    `plant_id` BIGINT COMMENT 'Foreign key linking to product.product_plant. Business justification: Quota arrangements split procurement volume across suppliers at the product-plant level. Procurement planners configure quotas per plant to manage multi-source supply strategies — a standard SAP MM op',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Quota arrangements define the split of procurement volume across multiple approved suppliers for a given material. Each quota arrangement line references a specific supplier. The current supplier_code',
    `supply_agreement_id` BIGINT COMMENT 'Foreign key linking to procurement.supply_agreement. Business justification: Quota arrangements can reference supply agreements (outline agreements) that govern the sourcing split. The table has outline_agreement_number. Adding supply_agreement_id FK formalizes this relationsh',
    `allocated_quantity` DECIMAL(18,2) COMMENT 'Cumulative quantity already allocated to this supplier under the quota arrangement (EQUK-ZUGMG). Used by MRP to determine which supplier should receive the next procurement order based on quota ratios.',
    `approval_date` DATE COMMENT 'Date on which the quota arrangement was formally approved by the authorized procurement authority. Required for compliance with procurement governance policies.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by` STRING COMMENT 'Name or user ID of the procurement manager or category manager who approved the quota arrangement. Supports audit trail and procurement governance requirements.',
    `arrangement_number` STRING COMMENT 'Business key identifying the quota arrangement in the source system (SAP MM EQUK table key). Used for cross-system traceability and reconciliation.. Valid values are `^[A-Z0-9]{1,10}$`',
    `category_code` STRING COMMENT 'Procurement category or material group code classifying the material under the quota arrangement (e.g., raw materials, MRO, packaging). Supports spend analytics and category management.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country from which the supplier sources or manufactures the material. Relevant for trade compliance, REACH/RoHS, and supply chain risk management.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the quota arrangement record was originally created in the source system. Used for audit trail, data lineage, and change history tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code applicable to pricing and value fields within this quota arrangement. Supports multi-currency procurement in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `info_record_number` STRING COMMENT 'Reference to the SAP purchasing info record (EINE/EINA) that defines the price and conditions for this supplier-material combination. Links quota to negotiated pricing.. Valid values are `^[0-9]{10}$`',
    `is_blocked` BOOLEAN COMMENT 'Indicates whether this quota line is blocked from being used in automatic source determination. A blocked line is excluded from MRP source selection without being deleted.. Valid values are `true|false`',
    `is_fixed_source` BOOLEAN COMMENT 'Indicates whether this quota line is designated as a fixed source of supply, bypassing quota ratio calculations and always directing procurement to this supplier. Supports sole-source or preferred-supplier strategies.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the quota arrangement record in the source system. Supports incremental data loading, change detection, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_reset_date` DATE COMMENT 'Date on which the quota base quantity and allocated quantity counters were last reset. Quota resets are performed periodically to rebalance supplier allocations and reflect updated volume agreements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `line_number` STRING COMMENT 'Sequential line number within the quota arrangement identifying each suppliers quota item (EQUK-ZEILE). Multiple lines exist per arrangement, one per approved supplier.. Valid values are `^[0-9]{1,5}$`',
    `material_description` STRING COMMENT 'Short descriptive text for the material subject to the quota arrangement, supporting readability in reports and analytics without requiring a join to the material master.',
    `maximum_lot_size` DECIMAL(18,2) COMMENT 'Maximum order quantity that can be placed with this supplier in a single procurement order under the quota arrangement. Supports capacity and risk management.',
    `minimum_lot_size` DECIMAL(18,2) COMMENT 'Minimum order quantity that must be placed with this supplier under the quota arrangement. Prevents splitting orders below economically viable quantities.',
    `notes` STRING COMMENT 'Free-text field for capturing business rationale, strategic sourcing decisions, risk diversification justifications, or other contextual information related to the quota arrangement.',
    `outline_agreement_line` STRING COMMENT 'Line item number within the outline agreement referenced by this quota arrangement line. Required when the agreement contains multiple material lines.',
    `outline_agreement_number` STRING COMMENT 'Reference to the SAP scheduling agreement or contract (EKKO) associated with this quota line. Enables procurement to be executed against pre-negotiated framework agreements.. Valid values are `^[0-9]{10}$`',
    `priority` STRING COMMENT 'Numeric priority rank assigned to this quota line relative to other suppliers for the same material and plant. Lower values indicate higher priority for source selection when quota ratios are equal.. Valid values are `^[1-9][0-9]?$`',
    `procurement_type` STRING COMMENT 'Indicates the procurement method for this quota line — external procurement from a supplier, subcontracting, consignment, or internal stock transfer. Drives MRP planning logic.. Valid values are `external|subcontracting|consignment|stock_transfer`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization responsible for negotiating and managing the quota arrangement. Determines the procurement authority and supplier contracts applicable.. Valid values are `^[A-Z0-9]{1,4}$`',
    `quota_base_quantity` DECIMAL(18,2) COMMENT 'Base quantity used as the starting point for quota usage calculation (EQUK-QUOGR). Resets periodically and is used in conjunction with allocated quantity to determine the next source of supply.',
    `quota_percentage` DECIMAL(18,2) COMMENT 'Percentage of total procurement volume allocated to this supplier for the material and plant. All active quota lines for a material/plant must sum to 100%. Core field for multi-source supply strategy.. Valid values are `^(100(.00?)?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `quota_usage_count` STRING COMMENT 'Number of times this quota line has been selected during automatic source determination (EQUK-QUNUM). Used alongside allocated quantity to track supplier selection frequency.',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this quota arrangement record was extracted. Supports data lineage and reconciliation in the Databricks Silver Layer.. Valid values are `SAP_S4HANA|SAP_ECC|MANUAL`',
    `source_type` STRING COMMENT 'Type of procurement source assigned to this quota line. Indicates whether the quota directs procurement to a vendor directly, a contract, or a scheduling agreement.. Valid values are `vendor|outline_agreement|scheduling_agreement`',
    `special_procurement_key` STRING COMMENT 'SAP special procurement key (EQUK-SOBSL) that refines the procurement type, e.g., subcontracting (30), consignment (10), or stock transfer from another plant. Used in MRP source determination.. Valid values are `^[A-Z0-9]{1,2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the quota arrangement line. Drives whether the line is considered during MRP/MRP II source determination and purchase order creation.. Valid values are `active|inactive|expired|suspended|pending_approval`',
    `supplying_plant_code` STRING COMMENT 'For stock transfer quota lines, identifies the SAP plant that supplies the material. Applicable when procurement type is internal stock transfer between plants.. Valid values are `^[A-Z0-9]{1,4}$`',
    `unit_of_measure` STRING COMMENT 'Unit of measure for quota base quantity and allocated quantity (e.g., EA, KG, PC, M). Aligns with the material master base unit of measure.. Valid values are `^[A-Z]{2,3}$`',
    `valid_from_date` DATE COMMENT 'Date from which the quota arrangement line becomes effective and eligible for automatic source determination during MRP runs and purchase order creation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'Date on which the quota arrangement line expires and is no longer used for source determination. Supports contract and supplier agreement lifecycle management.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_quota_arrangement PRIMARY KEY(`quota_arrangement_id`)
) COMMENT 'Defines the split of procurement volume across multiple approved suppliers for a given material and plant. Captures quota percentages per supplier, quota base quantity, cumulative allocated quantities, and validity period. Supports multi-source supply strategies, risk diversification, and competitive supplier management. Aligned with SAP MM Quota Arrangement (MEQ1/EQUK).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` (
    `purchase_requisition_id` BIGINT COMMENT 'Primary key for purchase_requisition',
    `cost_allocation_id` BIGINT COMMENT 'Foreign key linking to finance.cost_allocation. Business justification: Purchase requisitions carry account assignment (cost center, WBS, internal order) that routes spend to the correct cost object. Budget availability check runs against this allocation at requisition cr',
    `engineering_bom_id` BIGINT COMMENT 'Foreign key linking to engineering.engineering_bom. Business justification: MRP and manual requisitions are triggered directly from the engineering BOM. Procurement planners reference the BOM daily to validate part numbers, quantities, and revision levels before converting re',
    `line_item_id` BIGINT COMMENT 'Foreign key linking to order.line_item. Business justification: Sales order line items trigger purchase requisitions in make-to-order manufacturing. Procurement planners trace every PR back to the originating order line to fulfill customer demand — used daily in d',
    `plant_id` BIGINT COMMENT 'Foreign key linking to product.product_plant. Business justification: Purchase requisitions are raised for a specific product at a specific plant. The product-plant record holds MRP parameters, procurement type, and storage data that determine how the requisition is pro',
    `product_specification_id` BIGINT COMMENT 'Foreign key linking to engineering.product_specification. Business justification: Procurement requisitions for custom or engineered components must reference the product specification to ensure suppliers receive correct technical requirements. Used by buyers when issuing RFQs and a',
    `reorder_policy_id` BIGINT COMMENT 'Foreign key linking to inventory.reorder_policy. Business justification: Purchase requisitions generated automatically by inventory reorder policies must reference the triggering policy. Procurement planners use this to validate that the requisition parameters (quantity, t',
    `spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.spend_category. Business justification: purchase_requisition should be categorized by spend_category for approval routing and spend analytics. Adding spend_category_id FK enables category-based requisition management.',
    CONSTRAINT pk_purchase_requisition PRIMARY KEY(`purchase_requisition_id`)
) COMMENT 'Internal procurement request generated by production planning (MRP), maintenance (MRO), or business units requesting materials, components, or services. Captures requestor, cost center, material/service description, required quantity, required delivery date, preferred supplier, and approval workflow status. Sourced from SAP S/4HANA MM module (ME51N).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` (
    `supplier_invoice_id` BIGINT COMMENT 'Primary key for supplier_invoice',
    `ap_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ap_invoice. Business justification: Supplier invoices received in procurement are posted as AP invoices in finance. AP team matches supplier invoices to AP records daily for payment processing and liability recognition.',
    `currency_exchange_rate_id` BIGINT COMMENT 'Foreign key linking to finance.currency_exchange_rate. Business justification: Supplier invoices in foreign currencies require an exchange rate to convert to company code currency for GL posting. Exchange rate differences between PO and invoice create price variance postings.',
    `goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.goods_receipt. Business justification: 3-way matching requires linking the supplier invoice to the goods receipt that confirmed physical delivery. AP teams use this to verify invoiced quantities match received quantities before releasing p',
    `journal_entry_id` BIGINT COMMENT 'Foreign key linking to finance.journal_entry. Business justification: Supplier invoice verification posts a journal entry (GR-IR debit / AP credit). Finance requires this link to reconcile invoice postings and support period-end AP subledger balancing.',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Supplier invoices are matched against purchase orders in the standard 3-way match process (PO-GRN-Invoice) used in SAP MM/FI. The purchase_order_id FK enables invoice verification, over/under-delivery',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Supplier invoices are submitted by a specific supplier for goods or services delivered. Without supplier_id, supplier_invoice is completely siloed. Adding supplier_id as a FK to the supplier master is',
    `uom_id` BIGINT COMMENT 'Foreign key linking to product.uom. Business justification: Supplier invoices must reference the same UOM as the PO and goods receipt for three-way matching. Accounts payable teams validate UOM consistency across PO, GR, and invoice to approve payment — a dail',
    CONSTRAINT pk_supplier_invoice PRIMARY KEY(`supplier_invoice_id`)
) COMMENT 'Supplier-submitted invoice for goods or services delivered against a PO. Captures invoice number, invoice date, invoiced amount, tax amount, currency, payment due date, three-way match status (PO-GRN-Invoice), discrepancy flags, and payment block reasons. Processed via SAP S/4HANA MM Invoice Verification (MIRO) and linked to accounts payable in Finance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`spend_category` (
    `spend_category_id` BIGINT COMMENT 'Primary key for spend_category',
    `category_id` BIGINT COMMENT 'Foreign key linking to product.category. Business justification: Procurement spend categories map directly to product categories to enable spend analytics and category management. Category managers use this link to analyze supplier spend by product category and set',
    `chart_of_accounts_id` BIGINT COMMENT 'Foreign key linking to finance.chart_of_accounts. Business justification: Spend categories map to GL accounts in the chart of accounts to ensure procurement spend is posted to the correct expense or asset account. Used in automatic account determination during invoice posti',
    CONSTRAINT pk_spend_category PRIMARY KEY(`spend_category_id`)
) COMMENT 'Hierarchical classification taxonomy for all procurement spend categories including direct materials (raw materials, components, subassemblies), indirect materials (MRO, facilities), and services (contract manufacturing, logistics). Captures category code, category level, parent category, commodity code (UNSPSC), responsible category manager, and strategic sourcing strategy. Supports category management and spend analytics.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` (
    `preferred_supplier_list_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each preferred supplier list entry in the Databricks Silver Layer.',
    `category_id` BIGINT COMMENT 'Foreign key linking to product.category. Business justification: Preferred supplier lists are organized by product category — procurement teams maintain approved suppliers per category to enforce sourcing compliance. Category managers review and update preferred su',
    `contract_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_contract. Business justification: Preferred supplier list entries reference the procurement contract that governs the preferred supplier relationship. The table has contract_reference. Adding procurement_contract_id FK formalizes this',
    `spend_category_id` BIGINT COMMENT 'Foreign key linking to procurement.spend_category. Business justification: Preferred supplier list entries are organized by spend category. The table stores category_code and category_name. Adding spend_category_id FK normalizes this relationship; category_name is redundant ',
    `supplier_id` BIGINT COMMENT 'FK to procurement.supplier',
    `supplier_qualification_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier_qualification. Business justification: PSL designation should reference the formal qualification record. The qualification_status and qualification_expiry_date in PSL are redundant with the authoritative data in procurement_supplier_qualif',
    `approval_status` STRING COMMENT 'Workflow approval status of this PSL entry, tracking whether the preferred designation has been reviewed and authorized by the appropriate procurement authority.. Valid values are `pending|approved|rejected|withdrawn`',
    `approved_by` STRING COMMENT 'Name or employee ID of the procurement authority (e.g., Category Manager, CPO) who approved this preferred supplier designation.',
    `approved_date` DATE COMMENT 'Date on which the preferred supplier designation was formally approved by the authorized procurement stakeholder.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ariba_psl_reference` STRING COMMENT 'External identifier from SAP Ariba Supplier Management module corresponding to this preferred supplier list entry, enabling cross-system traceability.',
    `category_code` STRING COMMENT 'Procurement spend category code (aligned to UNSPSC or internal taxonomy) defining the scope of goods or services for which the supplier is preferred.',
    `category_manager_name` STRING COMMENT 'Name of the category manager responsible for managing the supplier relationship and preferred status within this spend category.',
    `conflict_minerals_compliant` BOOLEAN COMMENT 'Indicates whether the supplier has provided conflict minerals compliance documentation (3TG: tin, tantalum, tungsten, gold) per Dodd-Frank Section 1502 requirements.. Valid values are `true|false`',
    `contract_reference` STRING COMMENT 'Reference to the supply agreement, outline agreement, or blanket purchase order number in SAP S/4HANA or SAP Ariba that underpins this preferred supplier designation.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country scope of this preferred supplier designation. Null indicates multi-country or global applicability.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp recording when this preferred supplier list entry was first created in the system, supporting audit trail and data lineage requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `designation_reason` STRING COMMENT 'Business rationale documenting why this supplier was designated at the specified preference tier, including strategic alignment, competitive sourcing outcome, or qualification result.',
    `is_diversity_supplier` BOOLEAN COMMENT 'Flag indicating whether this supplier qualifies as a diversity supplier (e.g., minority-owned, women-owned, veteran-owned), supporting supplier diversity program compliance and reporting.. Valid values are `true|false`',
    `is_single_source` BOOLEAN COMMENT 'Flag indicating that this supplier is the sole approved source for the designated category and plant, requiring documented single-source justification per procurement policy.. Valid values are `true|false`',
    `is_strategic_supplier` BOOLEAN COMMENT 'Flag indicating whether this supplier is classified as a strategic partner, warranting executive-level relationship management, joint development programs, and enhanced collaboration.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this preferred supplier list entry, used for change tracking, incremental data loads, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the periodic review of this preferred supplier designation to assess continued alignment with procurement strategy, supplier performance, and qualification status.. Valid values are `^d{4}-d{2}-d{2}$`',
    `notes` STRING COMMENT 'Free-text field for additional context, conditions, or exceptions associated with this preferred supplier designation, such as volume thresholds, geographic restrictions, or transition plans.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or distribution facility for which this supplier preference applies. Null indicates enterprise-wide applicability.',
    `preference_tier` STRING COMMENT 'Procurement policy designation indicating the level of preference for this supplier within the category. Preferred directs buyers to use this supplier first; Approved allows use without restriction; Conditional requires additional justification; Restricted limits use to specific circumstances.. Valid values are `preferred|approved|conditional|restricted`',
    `priority_rank` STRING COMMENT 'Numeric rank indicating the order of preference among multiple approved suppliers within the same category and plant scope. Rank 1 indicates the highest-priority preferred supplier.. Valid values are `^[1-9][0-9]*$`',
    `procurement_type` STRING COMMENT 'Classification of the procurement spend type: direct materials (production-related), indirect materials, services, capital expenditure (CAPEX), or maintenance, repair, and operations (MRO).. Valid values are `direct|indirect|services|capex|mro`',
    `psl_number` STRING COMMENT 'Business-facing alphanumeric identifier for the preferred supplier list entry, used in procurement communications and audit trails.. Valid values are `^PSL-[0-9]{4}-[0-9]{6}$`',
    `purchasing_org_code` STRING COMMENT 'SAP purchasing organization code representing the procurement entity responsible for managing this supplier preference, enabling multi-org governance.',
    `reach_compliant` BOOLEAN COMMENT 'Indicates whether the supplier has confirmed compliance with EU REACH Regulation for the designated category, required for chemical and material procurement.. Valid values are `true|false`',
    `region_code` STRING COMMENT 'Geographic region code (e.g., EMEA, APAC, AMER) for which this supplier preference is valid, supporting multinational procurement governance.',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether the supplier has confirmed compliance with EU RoHS Directive for the designated category, required for electronics and electrical equipment procurement.. Valid values are `true|false`',
    `single_source_justification` STRING COMMENT 'Documented business justification for sole-source designation, required when is_single_source is true. Captures technical, commercial, or regulatory reasons for limiting to one supplier.',
    `sourcing_event_reference` STRING COMMENT 'Reference to the SAP Ariba sourcing event (RFQ/RFP) that resulted in this supplier being designated as preferred, providing traceability to the competitive sourcing process.',
    `sourcing_strategy` STRING COMMENT 'Procurement sourcing strategy alignment for this supplier-category combination, indicating whether the supplier is a sole source, one of multiple approved sources, or part of a strategic partnership.. Valid values are `single_source|dual_source|multi_source|preferred_with_backup|strategic_partnership`',
    `spend_allocation_percent` DECIMAL(18,2) COMMENT 'Target percentage of category spend to be directed to this supplier as part of a multi-source or quota-based sourcing strategy. Supports spend distribution governance.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `status` STRING COMMENT 'Current lifecycle status of the preferred supplier list entry, controlling whether buyers may use this supplier for the designated category.. Valid values are `active|inactive|under_review|suspended|expired`',
    `supplier_code` STRING COMMENT 'Unique vendor identifier from the supplier master, referencing the approved supplier in SAP S/4HANA or SAP Ariba.',
    `valid_from_date` DATE COMMENT 'Start date from which this preferred supplier designation is effective and buyers may direct spend to this supplier for the designated category.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'Expiry date after which this preferred supplier designation is no longer valid and must be renewed or replaced through the qualification and sourcing process.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_preferred_supplier_list PRIMARY KEY(`preferred_supplier_list_id`)
) COMMENT 'Maintains the approved and preferred supplier registry per spend category, plant, and region. Captures supplier preference tier (preferred, approved, conditional, restricted), valid period, category scope, sourcing strategy alignment, and the business rationale for preference designation. Enforces procurement policy by directing buyers to qualified, strategically aligned suppliers.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` (
    `preferred_supplier_id` BIGINT COMMENT 'Primary key for the preferred_supplier association',
    `sla_agreement_id` BIGINT COMMENT 'Foreign key linking to customer.sla_agreement. Business justification: Supplier performance KPIs in industrial manufacturing are benchmarked against customer SLA commitments. Procurement quality teams measure on-time delivery and defect rates relative to the SLA obligati',
    `spend_category_id` BIGINT COMMENT 'Foreign key linking to the spend category for which the supplier is preferred',
    `supplier_id` BIGINT COMMENT 'Foreign key linking to the approved supplier master record',
    `is_strategic_supplier` BOOLEAN COMMENT 'Indicates whether this supplier is designated as a strategic supplier for this specific spend category. A supplier may be strategic in one category but not another, so this flag belongs to the relationship.',
    `preference_tier` STRING COMMENT 'The tier ranking of this supplier within the spend category on the Preferred Supplier List (e.g., Tier 1 = primary preferred, Tier 2 = secondary). Belongs to the relationship, not to the supplier or category alone.',
    `priority_rank` BIGINT COMMENT 'Numeric ordering of preferred suppliers within a spend category (e.g., 1 = first choice, 2 = second choice). Used when multiple Tier 1 suppliers exist to determine sourcing sequence.',
    `spend_allocation_percent` DECIMAL(18,2) COMMENT 'The target percentage of category spend directed to this supplier as part of the sourcing strategy. This value is specific to the supplier-category combination and cannot reside on either master record.',
    `valid_from_date` DATE COMMENT 'The date from which this suppliers preferred status for the spend category is effective. Part of the PSL validity window governing the sourcing preference.',
    `valid_to_date` DATE COMMENT 'The date on which this suppliers preferred status for the spend category expires. Enables time-bounded PSL governance and renewal workflows.',
    CONSTRAINT pk_preferred_supplier PRIMARY KEY(`preferred_supplier_id`)
) COMMENT 'This association product represents the Contract/Approval between a supplier and a spend category within the Preferred Supplier List (PSL) governance process. It captures which suppliers are approved and preferred for each spend category, along with the tier ranking, spend allocation percentage, validity period, and strategic designation. Each record links one supplier to one spend category and carries attributes that exist only in the context of this sourcing preference relationship — they cannot reside on the supplier or spend_category master records alone.. Existence Justification: In industrial manufacturing procurement, a supplier is approved and preferred for multiple spend categories (e.g., a fastener supplier may be preferred for both raw materials and MRO), and each spend category has multiple approved/preferred suppliers with different tiers, allocation percentages, and validity periods. The Preferred Supplier List (PSL) is a formally governed business concept in strategic sourcing — procurement teams actively create, review, and expire PSL entries as part of category management. This is not an analytical correlation; it is an operational record that procurement managers maintain in systems like SAP Ariba.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_mrp_run_id` FOREIGN KEY (`mrp_run_id`) REFERENCES `manufacturing_ecm`.`procurement`.`mrp_run`(`mrp_run_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_source_list_id` FOREIGN KEY (`source_list_id`) REFERENCES `manufacturing_ecm`.`procurement`.`source_list`(`source_list_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_spend_category_id` FOREIGN KEY (`spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`spend_category`(`spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ADD CONSTRAINT `fk_procurement_delivery_schedule_supply_agreement_id` FOREIGN KEY (`supply_agreement_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supply_agreement`(`supply_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ADD CONSTRAINT `fk_procurement_source_list_quota_arrangement_id` FOREIGN KEY (`quota_arrangement_id`) REFERENCES `manufacturing_ecm`.`procurement`.`quota_arrangement`(`quota_arrangement_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ADD CONSTRAINT `fk_procurement_source_list_supply_agreement_id` FOREIGN KEY (`supply_agreement_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supply_agreement`(`supply_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ADD CONSTRAINT `fk_procurement_quota_arrangement_supply_agreement_id` FOREIGN KEY (`supply_agreement_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supply_agreement`(`supply_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_spend_category_id` FOREIGN KEY (`spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`spend_category`(`spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ADD CONSTRAINT `fk_procurement_preferred_supplier_list_spend_category_id` FOREIGN KEY (`spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`spend_category`(`spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` ADD CONSTRAINT `fk_procurement_preferred_supplier_spend_category_id` FOREIGN KEY (`spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`spend_category`(`spend_category_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`procurement` SET TAGS ('dbx_division' = 'corporate');
ALTER SCHEMA `manufacturing_ecm`.`procurement` SET TAGS ('dbx_domain' = 'procurement');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` SET TAGS ('dbx_subdomain' = 'supply_planning');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `mrp_run_id` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Run ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `engineering_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Bom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `physical_inventory_id` SET TAGS ('dbx_business_glossary_term' = 'Physical Inventory Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `segment_id` SET TAGS ('dbx_business_glossary_term' = 'Segment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `bom_explosion_level` SET TAGS ('dbx_business_glossary_term' = 'Bill of Materials (BOM) Explosion Level');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `bom_explosion_level` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `capacity_check_performed` SET TAGS ('dbx_business_glossary_term' = 'Capacity Check Performed');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `capacity_check_performed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `capacity_overload_count` SET TAGS ('dbx_business_glossary_term' = 'Capacity Overload Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `capacity_overload_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `coverage_shortfall_count` SET TAGS ('dbx_business_glossary_term' = 'Coverage Shortfall Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `coverage_shortfall_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_cancel_count` SET TAGS ('dbx_business_glossary_term' = 'Exception: Cancel Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_cancel_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_messages_total` SET TAGS ('dbx_business_glossary_term' = 'Total Exception Messages');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_messages_total` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_new_requirement_count` SET TAGS ('dbx_business_glossary_term' = 'Exception: New Requirement Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_new_requirement_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_reschedule_in_count` SET TAGS ('dbx_business_glossary_term' = 'Exception: Reschedule In Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_reschedule_in_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_reschedule_out_count` SET TAGS ('dbx_business_glossary_term' = 'Exception: Reschedule Out Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `exception_reschedule_out_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(0[1-9]|1[0-2])$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `horizon_end_date` SET TAGS ('dbx_business_glossary_term' = 'Planning Horizon End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `horizon_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `horizon_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planning Horizon Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `horizon_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `initiated_by` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Initiated By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `material_range_from` SET TAGS ('dbx_business_glossary_term' = 'Material Range From');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `material_range_to` SET TAGS ('dbx_business_glossary_term' = 'Material Range To');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `mrp_area` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Area');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `mrp_controller_group` SET TAGS ('dbx_business_glossary_term' = 'MRP Controller Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planned_orders_created` SET TAGS ('dbx_business_glossary_term' = 'Planned Orders Created');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planned_orders_created` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planning_date` SET TAGS ('dbx_business_glossary_term' = 'MRP Planning Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planning_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planning_horizon_days` SET TAGS ('dbx_business_glossary_term' = 'Planning Horizon (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planning_horizon_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planning_mode` SET TAGS ('dbx_business_glossary_term' = 'Planning Mode');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `planning_mode` SET TAGS ('dbx_value_regex' = 'mrp|mrp_ii|consumption_based|reorder_point|forecast_based');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `purchase_requisitions_created` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisitions (PR) Created');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `purchase_requisitions_created` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_duration_seconds` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Duration (Seconds)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_duration_seconds` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'MRP Run End Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_end_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_number` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_number` SET TAGS ('dbx_value_regex' = '^MRP-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_scope` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Scope');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_scope` SET TAGS ('dbx_value_regex' = 'single_material|material_range|all_materials|mrp_area|plant_wide');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_trigger_type` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Trigger Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_trigger_type` SET TAGS ('dbx_value_regex' = 'manual|scheduled_batch|event_driven|api_triggered');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_type` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `run_type` SET TAGS ('dbx_value_regex' = 'regenerative|net_change|net_change_planning_horizon');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `schedule_lines_created` SET TAGS ('dbx_business_glossary_term' = 'Schedule Lines Created');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `schedule_lines_created` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `scheduling_type` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `scheduling_type` SET TAGS ('dbx_value_regex' = 'basic_dates|lead_time_scheduling|capacity_planning');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ECC|OPCENTER|OTHER');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `source_system_run_reference` SET TAGS ('dbx_business_glossary_term' = 'Source System MRP Run ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'MRP Run Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'initiated|in_progress|completed|completed_with_exceptions|failed|cancelled');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `total_materials_planned` SET TAGS ('dbx_business_glossary_term' = 'Total Materials Planned');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ALTER COLUMN `total_materials_planned` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` SET TAGS ('dbx_subdomain' = 'supply_planning');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_planned_order_id` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Planned Order ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `engineering_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Bom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Forecast Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_run_id` SET TAGS ('dbx_business_glossary_term' = 'Mrp Run Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `product_cost_estimate_id` SET TAGS ('dbx_business_glossary_term' = 'Product Cost Estimate Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `product_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Variant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `source_list_id` SET TAGS ('dbx_business_glossary_term' = 'Source List Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `stock_position_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Position Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `bom_explosion_indicator` SET TAGS ('dbx_business_glossary_term' = 'Bill of Materials (BOM) Explosion Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `bom_explosion_indicator` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `conversion_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Conversion Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `conversion_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `converted_document_number` SET TAGS ('dbx_business_glossary_term' = 'Converted Document Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `converted_document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `demand_source_type` SET TAGS ('dbx_business_glossary_term' = 'Demand Source Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `demand_source_type` SET TAGS ('dbx_value_regex' = 'sales_order|forecast|safety_stock|dependent_demand|manual_reservation|project|service_order');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `exception_message_code` SET TAGS ('dbx_business_glossary_term' = 'MRP Exception Message Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `exception_message_code` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `exception_message_text` SET TAGS ('dbx_business_glossary_term' = 'MRP Exception Message Text');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `goods_receipt_processing_days` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Processing Days');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `goods_receipt_processing_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `is_firmed` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Firmed Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `is_firmed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `lot_size_key` SET TAGS ('dbx_business_glossary_term' = 'Lot Size Key');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `lot_size_key` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_area` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Area');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_controller_code` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Controller Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_controller_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_run_date` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Run Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_run_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_type` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `mrp_type` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `opening_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Opening Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `opening_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'purchase_requisition|production_order|transfer_order|subcontracting|consignment');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_delivery_days` SET TAGS ('dbx_business_glossary_term' = 'Planned Delivery Days');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_delivery_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_finish_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Finish Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_finish_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_order_number` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_order_value` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_order_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_order_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_quantity` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'external|in_house|both|subcontracting');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `requirements_date` SET TAGS ('dbx_business_glossary_term' = 'Requirements Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `requirements_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `source_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Source Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `source_plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `special_procurement_key` SET TAGS ('dbx_business_glossary_term' = 'Special Procurement Key');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `special_procurement_key` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Planned Order Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'created|firmed|converted|cancelled|exception');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` SET TAGS ('dbx_subdomain' = 'supply_planning');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `demand_forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Demand Forecast ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `account_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Account Hierarchy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `blanket_order_id` SET TAGS ('dbx_business_glossary_term' = 'Blanket Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `fiscal_period_id` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Forecast Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `product_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Variant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `segment_id` SET TAGS ('dbx_business_glossary_term' = 'Segment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `stock_position_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Position Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `abc_classification` SET TAGS ('dbx_business_glossary_term' = 'ABC Classification');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `abc_classification` SET TAGS ('dbx_value_regex' = 'A|B|C');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Forecast Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Forecast Approval Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `consensus_adjustment_quantity` SET TAGS ('dbx_business_glossary_term' = 'Consensus Forecast Adjustment Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `consensus_adjustment_quantity` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `demand_category` SET TAGS ('dbx_business_glossary_term' = 'Demand Category');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `demand_category` SET TAGS ('dbx_value_regex' = 'independent|dependent|spare_parts|service|promotional|new_product|phase_out');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_algorithm` SET TAGS ('dbx_business_glossary_term' = 'Forecast Algorithm');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_algorithm` SET TAGS ('dbx_value_regex' = 'exponential_smoothing|moving_average|holt_winters|arima|causal|machine_learning|manual');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_bias` SET TAGS ('dbx_business_glossary_term' = 'Forecast Bias');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_bias` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_end_date` SET TAGS ('dbx_business_glossary_term' = 'Forecast Period End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_number` SET TAGS ('dbx_business_glossary_term' = 'Forecast Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_number` SET TAGS ('dbx_value_regex' = '^FC-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_period_type` SET TAGS ('dbx_business_glossary_term' = 'Forecast Period Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_period_type` SET TAGS ('dbx_value_regex' = 'weekly|monthly|quarterly');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_start_date` SET TAGS ('dbx_business_glossary_term' = 'Forecast Period Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecast_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecasted_quantity` SET TAGS ('dbx_business_glossary_term' = 'Forecasted Demand Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecasted_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecasted_spend_amount` SET TAGS ('dbx_business_glossary_term' = 'Forecasted Procurement Spend Amount');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecasted_spend_amount` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `forecasted_spend_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `is_mrp_relevant` SET TAGS ('dbx_business_glossary_term' = 'MRP Relevance Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `is_mrp_relevant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `is_supplier_shared` SET TAGS ('dbx_business_glossary_term' = 'Supplier Shared Forecast Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `is_supplier_shared` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `lot_size_procedure` SET TAGS ('dbx_business_glossary_term' = 'Lot Size Procedure');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `lot_size_procedure` SET TAGS ('dbx_value_regex' = 'exact|fixed|economic_order_quantity|period|minimum_maximum');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `mape` SET TAGS ('dbx_business_glossary_term' = 'Mean Absolute Percentage Error (MAPE)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `mape` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `mrp_area` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Area');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `mrp_type` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `mrp_type` SET TAGS ('dbx_value_regex' = 'MRP|consumption_based|reorder_point|forecast_based|manual');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `planning_horizon_months` SET TAGS ('dbx_business_glossary_term' = 'Planning Horizon (Months)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `planning_horizon_months` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'external|in_house|subcontracting|consignment|stock_transfer');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `product_category_code` SET TAGS ('dbx_business_glossary_term' = 'Product Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `reorder_point` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `reorder_point` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `safety_stock_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `sop_cycle` SET TAGS ('dbx_business_glossary_term' = 'Sales and Operations Planning (S&OP) Cycle');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `sop_cycle` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-(0[1-9]|1[0-2])$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_APO|EXCEL|MANUAL|EXTERNAL');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `statistical_forecast_quantity` SET TAGS ('dbx_business_glossary_term' = 'Statistical Forecast Baseline Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `statistical_forecast_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Forecast Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|in_review|approved|locked|superseded|cancelled');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `supplier_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Supplier Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `supplier_lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Forecast Version Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `version_type` SET TAGS ('dbx_business_glossary_term' = 'Forecast Version Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `version_type` SET TAGS ('dbx_value_regex' = 'baseline|statistical|consensus|final|adjusted|simulation');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `xyz_classification` SET TAGS ('dbx_business_glossary_term' = 'XYZ Classification');
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ALTER COLUMN `xyz_classification` SET TAGS ('dbx_value_regex' = 'X|Y|Z');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` SET TAGS ('dbx_original_name' = 'procurement_supply_agreement');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `supply_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `profitability_segment_id` SET TAGS ('dbx_business_glossary_term' = 'Profitability Segment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'scheduling_agreement|blanket_order|framework_contract|master_supply_agreement|call_off_contract');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Approval Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'not_submitted|pending|approved|rejected|revision_required');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Approval Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `ariba_contract_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Contract ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `ariba_contract_reference` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,50}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto-Renewal Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `category_code` SET TAGS ('dbx_business_glossary_term' = 'Commodity Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `category_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `country_of_supply` SET TAGS ('dbx_business_glossary_term' = 'Country of Supply');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `country_of_supply` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Agreement Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Effective End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = '^(EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Location');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `minimum_call_off_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Call-Off Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `minimum_call_off_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `penalty_clause_description` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `penalty_clause_description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `penalty_clause_flag` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `penalty_clause_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `pricing_condition_type` SET TAGS ('dbx_business_glossary_term' = 'Pricing Condition Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `pricing_condition_type` SET TAGS ('dbx_value_regex' = 'fixed_price|tiered_volume|index_linked|cost_plus|time_and_material|frame_rate');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `pricing_condition_type` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'direct|indirect|mro|services|capital');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization (PO) Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `released_quantity` SET TAGS ('dbx_business_glossary_term' = 'Released Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `released_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `released_value` SET TAGS ('dbx_business_glossary_term' = 'Released Agreement Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `released_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `released_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notice Period (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_value_regex' = '^d{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `sap_outline_agreement_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Outline Agreement Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `sap_outline_agreement_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `sourcing_event_reference` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Reference Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `sourcing_event_reference` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|active|suspended|expired|terminated|closed');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Termination Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `termination_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Agreement Termination Reason');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `termination_reason` SET TAGS ('dbx_value_regex' = 'supplier_default|mutual_agreement|strategic_sourcing_change|regulatory_non_compliance|financial_insolvency|force_majeure|other');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Title');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `title` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `total_committed_quantity` SET TAGS ('dbx_business_glossary_term' = 'Total Committed Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `total_committed_quantity` SET TAGS ('dbx_value_regex' = '^d+(.d{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `total_committed_value` SET TAGS ('dbx_business_glossary_term' = 'Total Committed Agreement Value');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `total_committed_value` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `total_committed_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Agreed Unit Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `unit_price` SET TAGS ('dbx_value_regex' = '^d+(.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ALTER COLUMN `unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` SET TAGS ('dbx_subdomain' = 'supply_planning');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivery_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `address_id` SET TAGS ('dbx_business_glossary_term' = 'Address Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `address_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `address_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `schedule_line_id` SET TAGS ('dbx_business_glossary_term' = 'Schedule Line Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `sla_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `supply_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement / Blanket Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `agreement_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_business_glossary_term' = 'Supplier Confirmed Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `confirmed_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `cumulative_delivered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Delivered Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `cumulative_delivered_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `cumulative_scheduled_quantity` SET TAGS ('dbx_business_glossary_term' = 'Cumulative Scheduled Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `cumulative_scheduled_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `days_early_late` SET TAGS ('dbx_business_glossary_term' = 'Days Early or Late');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `days_early_late` SET TAGS ('dbx_value_regex' = '^-?[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivered Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivered_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivery_country_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivery_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivery_note_number` SET TAGS ('dbx_business_glossary_term' = 'Supplier Delivery Note Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `delivery_note_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,35}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `grn_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Note (GRN) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `grn_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `is_on_time` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `is_on_time` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `jit_delivery_window_end` SET TAGS ('dbx_business_glossary_term' = 'Just-In-Time (JIT) Delivery Window End');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `jit_delivery_window_end` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `jit_delivery_window_start` SET TAGS ('dbx_business_glossary_term' = 'Just-In-Time (JIT) Delivery Window Start');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `jit_delivery_window_start` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `kanban_signal_number` SET TAGS ('dbx_business_glossary_term' = 'Kanban Signal Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `kanban_signal_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Schedule Line Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `line_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `mrp_element_type` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Element Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `mrp_element_type` SET TAGS ('dbx_value_regex' = 'planned_order|purchase_requisition|scheduling_agreement|purchase_order|stock_transfer');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `purchasing_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `release_type` SET TAGS ('dbx_business_glossary_term' = 'Schedule Release Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `release_type` SET TAGS ('dbx_value_regex' = 'forecast|jit|immediate|manual');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `sap_scheduling_agreement_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Scheduling Agreement Document ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `sap_scheduling_agreement_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `schedule_adherence_status` SET TAGS ('dbx_business_glossary_term' = 'Schedule Adherence Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `schedule_adherence_status` SET TAGS ('dbx_value_regex' = 'on_time|early|late|partial|missed|pending');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `schedule_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `schedule_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `schedule_type` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `schedule_type` SET TAGS ('dbx_value_regex' = 'jit|forecast|firm|kanban|blanket_release|spot');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `scheduled_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `scheduled_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `scheduled_delivery_time` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Time (HH:MM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `scheduled_delivery_time` SET TAGS ('dbx_value_regex' = '^([01]d|2[0-3]):[0-5]d$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `scheduled_quantity` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Delivery Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `scheduled_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `sku_code` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `sku_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{1,50}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Delivery Schedule Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|released|confirmed|in_transit|partially_delivered|delivered|cancelled|overdue|closed');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `storage_location_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `tolerance_over_percent` SET TAGS ('dbx_business_glossary_term' = 'Over-Delivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `tolerance_over_percent` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `tolerance_under_percent` SET TAGS ('dbx_business_glossary_term' = 'Under-Delivery Tolerance Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `tolerance_under_percent` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `unit_price` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ALTER COLUMN `unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `source_list_id` SET TAGS ('dbx_business_glossary_term' = 'Source List ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `approved_manufacturer_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Manufacturer Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `quota_arrangement_id` SET TAGS ('dbx_business_glossary_term' = 'Quota Arrangement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `supply_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'scheduling_agreement|contract|blanket_po|none');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `info_record_number` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Info Record Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_blocked` SET TAGS ('dbx_business_glossary_term' = 'Source Blocked Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_blocked` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_fixed_source` SET TAGS ('dbx_business_glossary_term' = 'Fixed Source Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_fixed_source` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_mrp_source_list_required` SET TAGS ('dbx_business_glossary_term' = 'MRP Source List Required Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_mrp_source_list_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_preferred_source` SET TAGS ('dbx_business_glossary_term' = 'Preferred Source Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `is_preferred_source` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_business_glossary_term' = 'Last Reviewed Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `maximum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Order Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `mrp_relevance_indicator` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Relevance Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `mrp_relevance_indicator` SET TAGS ('dbx_value_regex' = '0|1|2');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Source List Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Source List Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `order_unit` SET TAGS ('dbx_business_glossary_term' = 'Order Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `outline_agreement_item` SET TAGS ('dbx_business_glossary_term' = 'Outline Agreement Item Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `outline_agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Outline Agreement Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `plant_of_supply` SET TAGS ('dbx_business_glossary_term' = 'Plant of Supply');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'direct|indirect');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization (PO) Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `quota_arrangement_number` SET TAGS ('dbx_business_glossary_term' = 'Quota Arrangement Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `quota_percentage` SET TAGS ('dbx_business_glossary_term' = 'Quota Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `quota_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ECC|ARIBA|MANUAL');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `special_procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Special Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `special_procurement_type` SET TAGS ('dbx_value_regex' = 'standard|subcontracting|consignment|third_party|pipeline');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `standard_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Standard Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `standard_lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Source List Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|expired|blocked|pending_approval');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `sub_range` SET TAGS ('dbx_business_glossary_term' = 'Supplier Sub-Range');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `supply_type` SET TAGS ('dbx_business_glossary_term' = 'Supply Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `supply_type` SET TAGS ('dbx_value_regex' = 'external_supplier|internal_plant|subcontracting|consignment|stock_transfer');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `usage` SET TAGS ('dbx_business_glossary_term' = 'Source List Usage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `usage` SET TAGS ('dbx_value_regex' = 'mandatory|optional');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Source List Valid From Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Source List Valid To Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `quota_arrangement_id` SET TAGS ('dbx_business_glossary_term' = 'Quota Arrangement ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `supply_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `allocated_quantity` SET TAGS ('dbx_business_glossary_term' = 'Allocated Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `arrangement_number` SET TAGS ('dbx_business_glossary_term' = 'Quota Arrangement Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `arrangement_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `category_code` SET TAGS ('dbx_business_glossary_term' = 'Material Group / Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `category_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `info_record_number` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Info Record Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `info_record_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `is_blocked` SET TAGS ('dbx_business_glossary_term' = 'Blocked Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `is_blocked` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `is_fixed_source` SET TAGS ('dbx_business_glossary_term' = 'Fixed Source Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `is_fixed_source` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `last_reset_date` SET TAGS ('dbx_business_glossary_term' = 'Last Quota Reset Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `last_reset_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Quota Arrangement Line Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `line_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `maximum_lot_size` SET TAGS ('dbx_business_glossary_term' = 'Maximum Lot Size');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `minimum_lot_size` SET TAGS ('dbx_business_glossary_term' = 'Minimum Lot Size');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Quota Arrangement Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `outline_agreement_line` SET TAGS ('dbx_business_glossary_term' = 'Outline Agreement Line Item');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `outline_agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Outline Agreement Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `outline_agreement_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Quota Priority');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]?$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'external|subcontracting|consignment|stock_transfer');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization (PO) Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `quota_base_quantity` SET TAGS ('dbx_business_glossary_term' = 'Quota Base Quantity');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `quota_percentage` SET TAGS ('dbx_business_glossary_term' = 'Quota Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `quota_percentage` SET TAGS ('dbx_value_regex' = '^(100(.00?)?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `quota_usage_count` SET TAGS ('dbx_business_glossary_term' = 'Quota Usage Count');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ECC|MANUAL');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `source_type` SET TAGS ('dbx_business_glossary_term' = 'Source Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `source_type` SET TAGS ('dbx_value_regex' = 'vendor|outline_agreement|scheduling_agreement');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `special_procurement_key` SET TAGS ('dbx_business_glossary_term' = 'Special Procurement Key');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `special_procurement_key` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Quota Arrangement Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|expired|suspended|pending_approval');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `supplying_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Supplying Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `supplying_plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Validity End Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` SET TAGS ('dbx_subdomain' = 'purchase_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'purchase_requisition Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ALTER COLUMN `cost_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Allocation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ALTER COLUMN `engineering_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Engineering Bom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ALTER COLUMN `line_item_id` SET TAGS ('dbx_business_glossary_term' = 'Line Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ALTER COLUMN `product_specification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Specification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ALTER COLUMN `reorder_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Reorder Policy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ALTER COLUMN `spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` SET TAGS ('dbx_subdomain' = 'purchase_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'supplier_invoice Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ap Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ALTER COLUMN `currency_exchange_rate_id` SET TAGS ('dbx_business_glossary_term' = 'Currency Exchange Rate Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ALTER COLUMN `goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ALTER COLUMN `uom_id` SET TAGS ('dbx_business_glossary_term' = 'Uom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_category` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_category` SET TAGS ('dbx_subdomain' = 'purchase_execution');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_category` ALTER COLUMN `spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'spend_category Identifier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_category` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_category` ALTER COLUMN `chart_of_accounts_id` SET TAGS ('dbx_business_glossary_term' = 'Chart Of Accounts Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `preferred_supplier_list_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier List (PSL) ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `supplier_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `supplier_qualification_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Qualification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|withdrawn');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `ariba_psl_reference` SET TAGS ('dbx_business_glossary_term' = 'SAP Ariba Preferred Supplier List (PSL) ID');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `category_code` SET TAGS ('dbx_business_glossary_term' = 'Spend Category Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `category_manager_name` SET TAGS ('dbx_business_glossary_term' = 'Category Manager Name');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `conflict_minerals_compliant` SET TAGS ('dbx_business_glossary_term' = 'Conflict Minerals Compliant');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `conflict_minerals_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `designation_reason` SET TAGS ('dbx_business_glossary_term' = 'Preference Designation Reason');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `is_diversity_supplier` SET TAGS ('dbx_business_glossary_term' = 'Diversity Supplier Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `is_diversity_supplier` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `is_single_source` SET TAGS ('dbx_business_glossary_term' = 'Single Source Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `is_single_source` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `is_strategic_supplier` SET TAGS ('dbx_business_glossary_term' = 'Strategic Supplier Indicator');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `is_strategic_supplier` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `preference_tier` SET TAGS ('dbx_business_glossary_term' = 'Supplier Preference Tier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `preference_tier` SET TAGS ('dbx_value_regex' = 'preferred|approved|conditional|restricted');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `priority_rank` SET TAGS ('dbx_business_glossary_term' = 'Supplier Priority Rank');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `priority_rank` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'direct|indirect|services|capex|mro');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `psl_number` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier List (PSL) Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `psl_number` SET TAGS ('dbx_value_regex' = '^PSL-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `purchasing_org_code` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization (Purchasing Org) Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Compliant');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliant');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `single_source_justification` SET TAGS ('dbx_business_glossary_term' = 'Single Source Justification');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `sourcing_event_reference` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Event Reference Number');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Strategy');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_value_regex' = 'single_source|dual_source|multi_source|preferred_with_backup|strategic_partnership');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `spend_allocation_percent` SET TAGS ('dbx_business_glossary_term' = 'Spend Allocation Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `spend_allocation_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'PSL Entry Status');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_review|suspended|expired');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `supplier_code` SET TAGS ('dbx_business_glossary_term' = 'Supplier Code');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` SET TAGS ('dbx_association_edges' = 'procurement.supplier,procurement.spend_category');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` ALTER COLUMN `preferred_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier - Preferred Supplier Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` ALTER COLUMN `sla_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Agreement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` ALTER COLUMN `spend_category_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier - Spend Category Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier - Supplier Id');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` ALTER COLUMN `is_strategic_supplier` SET TAGS ('dbx_business_glossary_term' = 'Strategic Supplier Flag');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` ALTER COLUMN `preference_tier` SET TAGS ('dbx_business_glossary_term' = 'Supplier Preference Tier');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` ALTER COLUMN `priority_rank` SET TAGS ('dbx_business_glossary_term' = 'Supplier Priority Rank');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` ALTER COLUMN `spend_allocation_percent` SET TAGS ('dbx_business_glossary_term' = 'Spend Allocation Percentage');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'PSL Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'PSL Validity End Date');
