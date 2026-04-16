-- Metric views for domain: inventory | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_stock_position`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Core inventory position KPIs tracking stock availability, turns, and working capital efficiency across all SKUs and locations"
  source: "`manufacturing_ecm`.`inventory`.`stock_position`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant or distribution center code"
    - name: "abc_classification"
      expr: abc_classification
      comment: "ABC inventory classification (A=high value/velocity, B=medium, C=low)"
    - name: "stock_type"
      expr: stock_type
      comment: "Stock usability status (unrestricted, quality_inspection, blocked, in_transit)"
    - name: "inventory_category"
      expr: stock_category
      comment: "Ownership category (own_stock, consignment, project_stock, sales_order_stock)"
    - name: "valuation_method"
      expr: valuation_method
      comment: "Inventory costing method (standard_price, moving_average_price, FIFO, LIFO)"
    - name: "slow_moving_flag"
      expr: slow_moving_indicator
      comment: "Indicates slow-moving inventory requiring review"
    - name: "hazmat_flag"
      expr: hazardous_material_indicator
      comment: "Indicates hazardous materials requiring special handling"
  measures:
    - name: "total_on_hand_quantity"
      expr: SUM(CAST(on_hand_quantity AS DOUBLE))
      comment: "Total physical quantity on hand across all stock types"
    - name: "total_unrestricted_quantity"
      expr: SUM(CAST(unrestricted_quantity AS DOUBLE))
      comment: "Total quantity available for use without restrictions"
    - name: "total_atp_quantity"
      expr: SUM(CAST(atp_quantity AS DOUBLE))
      comment: "Total Available-to-Promise quantity for new orders"
    - name: "total_reserved_quantity"
      expr: SUM(CAST(reserved_quantity AS DOUBLE))
      comment: "Total quantity reserved for production or sales orders"
    - name: "total_blocked_quantity"
      expr: SUM(CAST(blocked_quantity AS DOUBLE))
      comment: "Total quantity blocked due to quality or administrative holds"
    - name: "total_in_transit_quantity"
      expr: SUM(CAST(in_transit_quantity AS DOUBLE))
      comment: "Total quantity in transit between locations"
    - name: "total_wip_quantity"
      expr: SUM(CAST(wip_quantity AS DOUBLE))
      comment: "Total Work-in-Progress quantity issued to production"
    - name: "total_stock_value"
      expr: SUM(CAST(total_stock_value AS DOUBLE))
      comment: "Total monetary value of inventory on hand for balance sheet reporting"
    - name: "avg_valuation_price"
      expr: AVG(CAST(valuation_price AS DOUBLE))
      comment: "Average unit valuation price across inventory positions"
    - name: "inventory_availability_rate"
      expr: ROUND(100.0 * SUM(CAST(atp_quantity AS DOUBLE)) / NULLIF(SUM(CAST(on_hand_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of on-hand inventory available to promise (ATP / On-Hand)"
    - name: "stock_reservation_rate"
      expr: ROUND(100.0 * SUM(CAST(reserved_quantity AS DOUBLE)) / NULLIF(SUM(CAST(unrestricted_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of unrestricted stock already reserved for orders"
    - name: "blocked_stock_rate"
      expr: ROUND(100.0 * SUM(CAST(blocked_quantity AS DOUBLE)) / NULLIF(SUM(CAST(on_hand_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of inventory blocked due to quality or holds"
    - name: "safety_stock_coverage_ratio"
      expr: ROUND(SUM(CAST(unrestricted_quantity AS DOUBLE)) / NULLIF(SUM(CAST(safety_stock_quantity AS DOUBLE)), 0), 2)
      comment: "Ratio of unrestricted stock to safety stock target (>1 = adequate buffer)"
    - name: "reorder_point_breach_count"
      expr: COUNT(CASE WHEN CAST(unrestricted_quantity AS DOUBLE) < CAST(reorder_point AS DOUBLE) THEN 1 END)
      comment: "Count of SKU-location positions below reorder point requiring replenishment"
    - name: "distinct_sku_count"
      expr: COUNT(DISTINCT inventory_sku_id)
      comment: "Number of distinct SKUs in inventory positions"
    - name: "distinct_location_count"
      expr: COUNT(DISTINCT storage_location_id)
      comment: "Number of distinct storage locations holding inventory"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_inventory_transaction`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Inventory movement KPIs tracking goods receipts, issues, transfers, and transaction velocity for operational efficiency and audit compliance"
  source: "`manufacturing_ecm`.`inventory`.`transaction`"
  dimensions:
    - name: "movement_category"
      expr: movement_category
      comment: "High-level movement classification (goods_receipt, goods_issue, transfer, adjustment, scrapping)"
    - name: "movement_type_code"
      expr: movement_type_code
      comment: "SAP MM movement type code (101, 201, 261, 301, 551, etc.)"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant or distribution center code"
    - name: "posting_date"
      expr: posting_date
      comment: "Accounting date of inventory transaction posting"
    - name: "posting_month"
      expr: DATE_TRUNC('MONTH', posting_date)
      comment: "Month of inventory transaction posting for trend analysis"
    - name: "stock_type"
      expr: stock_type
      comment: "Stock category (unrestricted, quality_inspection, blocked, in_transit)"
    - name: "reference_document_type"
      expr: reference_document_type
      comment: "Type of triggering document (purchase_order, production_order, sales_order, transfer_order)"
    - name: "reversal_flag"
      expr: reversal_indicator
      comment: "Indicates whether transaction is a reversal/cancellation"
    - name: "company_code"
      expr: company_code
      comment: "Legal entity company code for multi-entity reporting"
  measures:
    - name: "total_transaction_count"
      expr: COUNT(1)
      comment: "Total number of inventory movement transactions"
    - name: "total_movement_quantity"
      expr: SUM(CAST(quantity AS DOUBLE))
      comment: "Total quantity moved across all transactions (signed: positive=receipt, negative=issue)"
    - name: "total_movement_value"
      expr: SUM(CAST(valuation_amount AS DOUBLE))
      comment: "Total monetary value of inventory movements for financial impact analysis"
    - name: "avg_transaction_value"
      expr: AVG(CAST(valuation_amount AS DOUBLE))
      comment: "Average monetary value per inventory transaction"
    - name: "goods_receipt_count"
      expr: COUNT(CASE WHEN movement_category = 'goods_receipt' THEN 1 END)
      comment: "Count of inbound goods receipt transactions"
    - name: "goods_issue_count"
      expr: COUNT(CASE WHEN movement_category = 'goods_issue' THEN 1 END)
      comment: "Count of outbound goods issue transactions"
    - name: "transfer_count"
      expr: COUNT(CASE WHEN movement_category = 'transfer' THEN 1 END)
      comment: "Count of inter-location or inter-plant transfer transactions"
    - name: "adjustment_count"
      expr: COUNT(CASE WHEN movement_category = 'adjustment' THEN 1 END)
      comment: "Count of inventory adjustment transactions (cycle count, physical inventory)"
    - name: "scrapping_count"
      expr: COUNT(CASE WHEN movement_category = 'scrapping' THEN 1 END)
      comment: "Count of inventory scrapping transactions for waste tracking"
    - name: "reversal_transaction_count"
      expr: COUNT(CASE WHEN reversal_indicator = TRUE THEN 1 END)
      comment: "Count of reversed transactions indicating process errors or corrections"
    - name: "reversal_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN reversal_indicator = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of transactions reversed (quality indicator for process accuracy)"
    - name: "distinct_sku_moved"
      expr: COUNT(DISTINCT inventory_sku_id)
      comment: "Number of distinct SKUs with inventory movements"
    - name: "distinct_reference_documents"
      expr: COUNT(DISTINCT reference_document_number)
      comment: "Number of distinct source documents triggering inventory movements"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_inventory_valuation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Period-end inventory valuation KPIs for balance sheet reporting, COGS calculation, and inventory write-down analysis"
  source: "`manufacturing_ecm`.`inventory`.`inventory_valuation`"
  dimensions:
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of inventory valuation"
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period (month) within fiscal year"
    - name: "valuation_date"
      expr: date
      comment: "Business date of inventory valuation snapshot"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant or distribution center code"
    - name: "company_code"
      expr: company_code
      comment: "Legal entity company code for statutory reporting"
    - name: "valuation_method"
      expr: method
      comment: "Inventory costing method (standard_cost, moving_average_price, FIFO, LIFO)"
    - name: "price_control_indicator"
      expr: price_control_indicator
      comment: "Price control method (S=Standard Price, V=Moving Average Price)"
    - name: "inventory_category"
      expr: inventory_category
      comment: "Inventory stage (raw_material, WIP, finished_goods, MRO, semi_finished)"
    - name: "abc_classification"
      expr: abc_classification
      comment: "ABC inventory classification for value segmentation"
    - name: "valuation_class"
      expr: class
      comment: "SAP valuation class determining GL account assignment"
  measures:
    - name: "total_stock_quantity"
      expr: SUM(CAST(total_stock_quantity AS DOUBLE))
      comment: "Total valuated stock quantity on hand at period-end"
    - name: "total_stock_value_local"
      expr: SUM(CAST(total_value_local_currency AS DOUBLE))
      comment: "Total inventory value in local currency for balance sheet reporting"
    - name: "total_stock_value_group"
      expr: SUM(CAST(total_value_group_currency AS DOUBLE))
      comment: "Total inventory value in group currency for consolidated reporting"
    - name: "avg_standard_price"
      expr: AVG(CAST(standard_price AS DOUBLE))
      comment: "Average standard price per unit across valuated materials"
    - name: "avg_moving_average_price"
      expr: AVG(CAST(moving_average_price AS DOUBLE))
      comment: "Average moving average price per unit across valuated materials"
    - name: "total_net_realizable_value"
      expr: SUM(CAST(net_realizable_value AS DOUBLE))
      comment: "Total net realizable value for IFRS IAS 2 impairment assessment"
    - name: "inventory_write_down_exposure"
      expr: SUM(CASE WHEN CAST(net_realizable_value AS DOUBLE) < CAST(total_value_local_currency AS DOUBLE) THEN CAST(total_value_local_currency AS DOUBLE) - CAST(net_realizable_value AS DOUBLE) ELSE 0 END)
      comment: "Total potential inventory write-down where NRV is below cost"
    - name: "avg_devaluation_pct"
      expr: AVG(CAST(lowest_value_devaluation_pct AS DOUBLE))
      comment: "Average devaluation percentage applied for slow-moving or obsolete stock"
    - name: "distinct_sku_valuated"
      expr: COUNT(DISTINCT inventory_sku_id)
      comment: "Number of distinct SKUs included in period-end valuation"
    - name: "price_variance_exposure"
      expr: SUM(CASE WHEN CAST(standard_price AS DOUBLE) > 0 AND CAST(moving_average_price AS DOUBLE) > 0 THEN ABS(CAST(standard_price AS DOUBLE) - CAST(moving_average_price AS DOUBLE)) * CAST(total_stock_quantity AS DOUBLE) ELSE 0 END)
      comment: "Total monetary exposure from standard vs. moving average price variance"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_cycle_count`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Cycle counting program KPIs tracking inventory accuracy, count completion, and variance management for continuous physical verification"
  source: "`manufacturing_ecm`.`inventory`.`cycle_count`"
  dimensions:
    - name: "count_status"
      expr: status
      comment: "Current lifecycle status of cycle count (created, counting, recounting, completed, posted, cancelled)"
    - name: "abc_class"
      expr: abc_class
      comment: "ABC classification of materials in count scope"
    - name: "count_frequency"
      expr: count_frequency
      comment: "Scheduled count frequency (daily, weekly, monthly, quarterly, annual)"
    - name: "count_type"
      expr: count_type
      comment: "Type of count (standard, blind, recount, audit)"
    - name: "count_method"
      expr: count_method
      comment: "Physical counting method (manual, scanner, rfid, automated)"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant or distribution center code"
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period of cycle count execution"
    - name: "recount_required_flag"
      expr: recount_required
      comment: "Indicates whether recount was triggered by variance threshold breach"
    - name: "adjustment_posted_flag"
      expr: inventory_adjustment_posted
      comment: "Indicates whether inventory adjustment has been financially posted"
  measures:
    - name: "total_cycle_count_events"
      expr: COUNT(1)
      comment: "Total number of cycle count events executed"
    - name: "total_sku_in_scope"
      expr: SUM(CAST(total_sku_count AS DOUBLE))
      comment: "Total number of SKUs included in cycle count scope"
    - name: "total_sku_counted"
      expr: COUNT(1)
      comment: "Total number of SKUs physically counted"
    - name: "total_bins_counted"
      expr: SUM(CAST(total_bins_counted AS DOUBLE))
      comment: "Total number of storage bins physically counted"
    - name: "total_variance_quantity"
      expr: SUM(CAST(total_variance_qty AS DOUBLE))
      comment: "Total net quantity variance (counted minus book) across all counts"
    - name: "total_variance_value"
      expr: SUM(CAST(total_variance_value AS DOUBLE))
      comment: "Total monetary value of inventory variances identified"
    - name: "avg_variance_value_per_count"
      expr: AVG(CAST(total_variance_value AS DOUBLE))
      comment: "Average monetary variance per cycle count event"
    - name: "count_completion_rate"
      expr: COUNT(1)
      comment: "Percentage of in-scope SKUs successfully counted"
    - name: "recount_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN recount_required = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of cycle counts requiring recount due to variance threshold breach"
    - name: "adjustment_posting_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN inventory_adjustment_posted = TRUE THEN 1 END) / NULLIF(COUNT(CASE WHEN status IN ('completed', 'posted') THEN 1 END), 0), 2)
      comment: "Percentage of completed counts with adjustments financially posted"
    - name: "avg_count_duration_hours"
      expr: AVG(CAST((UNIX_TIMESTAMP(count_end_timestamp) - UNIX_TIMESTAMP(count_start_timestamp)) / 3600.0 AS DOUBLE))
      comment: "Average duration in hours from count start to count end"
    - name: "distinct_warehouses_counted"
      expr: COUNT(DISTINCT warehouse_id)
      comment: "Number of distinct warehouses with cycle count activity"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_stock_transfer`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Inter-location stock transfer KPIs tracking movement efficiency, in-transit inventory, and cross-border compliance for supply chain optimization"
  source: "`manufacturing_ecm`.`inventory`.`stock_transfer`"
  dimensions:
    - name: "transfer_type"
      expr: transfer_type
      comment: "Classification of transfer (plant_to_plant, warehouse_to_warehouse, storage_location_transfer, STO)"
    - name: "transfer_status"
      expr: status
      comment: "Current lifecycle status (created, in_transit, received, completed, cancelled)"
    - name: "source_plant_code"
      expr: source_plant_code
      comment: "Originating plant or facility code"
    - name: "destination_plant_code"
      expr: destination_plant_code
      comment: "Receiving plant or facility code"
    - name: "source_country"
      expr: source_country_code
      comment: "Country code of source location"
    - name: "destination_country"
      expr: destination_country_code
      comment: "Country code of destination location"
    - name: "cross_border_flag"
      expr: is_cross_border
      comment: "Indicates whether transfer crosses international borders"
    - name: "intercompany_flag"
      expr: is_intercompany
      comment: "Indicates whether transfer crosses legal entity boundaries"
    - name: "transfer_reason"
      expr: transfer_reason_code
      comment: "Business reason code for transfer (replenishment, production_demand, balancing, return)"
    - name: "planned_transfer_month"
      expr: DATE_TRUNC('MONTH', planned_transfer_date)
      comment: "Month of planned transfer for demand planning"
    - name: "priority"
      expr: priority
      comment: "Business priority level (critical, high, normal, low)"
  measures:
    - name: "total_transfer_count"
      expr: COUNT(1)
      comment: "Total number of stock transfer orders"
    - name: "total_transfer_quantity"
      expr: SUM(CAST(transfer_quantity AS DOUBLE))
      comment: "Total quantity planned for transfer"
    - name: "total_issued_quantity"
      expr: SUM(CAST(issued_quantity AS DOUBLE))
      comment: "Total quantity physically issued from source location"
    - name: "total_received_quantity"
      expr: SUM(CAST(received_quantity AS DOUBLE))
      comment: "Total quantity confirmed received at destination"
    - name: "total_transfer_value"
      expr: SUM(CAST(transfer_value AS DOUBLE))
      comment: "Total monetary value of stock transfers for working capital tracking"
    - name: "avg_transfer_value"
      expr: AVG(CAST(transfer_value AS DOUBLE))
      comment: "Average monetary value per transfer order"
    - name: "transfer_fulfillment_rate"
      expr: ROUND(100.0 * SUM(CAST(received_quantity AS DOUBLE)) / NULLIF(SUM(CAST(transfer_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of planned transfer quantity successfully received"
    - name: "in_transit_transfer_count"
      expr: COUNT(CASE WHEN status = 'in_transit' THEN 1 END)
      comment: "Count of transfers currently in transit between locations"
    - name: "cross_border_transfer_count"
      expr: COUNT(CASE WHEN is_cross_border = TRUE THEN 1 END)
      comment: "Count of transfers crossing international borders requiring customs"
    - name: "intercompany_transfer_count"
      expr: COUNT(CASE WHEN is_intercompany = TRUE THEN 1 END)
      comment: "Count of transfers crossing legal entity boundaries requiring intercompany billing"
    - name: "avg_transit_time_days"
      expr: AVG(CAST(DATEDIFF(actual_goods_receipt_date, actual_goods_issue_date) AS DOUBLE))
      comment: "Average number of days in transit from goods issue to goods receipt"
    - name: "on_time_receipt_count"
      expr: COUNT(CASE WHEN actual_goods_receipt_date <= planned_receipt_date THEN 1 END)
      comment: "Count of transfers received on or before planned receipt date"
    - name: "on_time_receipt_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN actual_goods_receipt_date <= planned_receipt_date THEN 1 END) / NULLIF(COUNT(CASE WHEN actual_goods_receipt_date IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of transfers received on time (SLA compliance)"
    - name: "distinct_source_plants"
      expr: COUNT(DISTINCT source_plant_code)
      comment: "Number of distinct source plants shipping inventory"
    - name: "distinct_destination_plants"
      expr: COUNT(DISTINCT destination_plant_code)
      comment: "Number of distinct destination plants receiving inventory"
    - name: "distinct_sku_transferred"
      expr: COUNT(DISTINCT inventory_sku_id)
      comment: "Number of distinct SKUs involved in stock transfers"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_wip_stock`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Work-in-Progress inventory KPIs tracking production floor inventory, WIP valuation, and manufacturing cycle efficiency"
  source: "`manufacturing_ecm`.`inventory`.`wip_stock`"
  dimensions:
    - name: "wip_status"
      expr: status
      comment: "Current WIP status (open, partially_confirmed, fully_confirmed, settled)"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant code"
    - name: "production_order_type"
      expr: production_order_type
      comment: "SAP order type (PP01 standard, PP02 repetitive, PI01 process)"
    - name: "make_to_strategy"
      expr: make_to_strategy
      comment: "Manufacturing strategy (MTO, MTS, ETO, ATO)"
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of WIP calculation"
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period (month) of WIP calculation"
    - name: "abc_classification"
      expr: abc_classification
      comment: "ABC classification of material being produced"
    - name: "operation_number"
      expr: operation_number
      comment: "Routing operation step where WIP resides"
    - name: "valuation_method"
      expr: valuation_method
      comment: "WIP valuation method (standard_cost, moving_average, actual_cost)"
  measures:
    - name: "total_wip_quantity"
      expr: SUM(CAST(wip_quantity AS DOUBLE))
      comment: "Total quantity of materials in Work-in-Progress"
    - name: "total_wip_value_local"
      expr: SUM(CAST(wip_value_local_currency AS DOUBLE))
      comment: "Total WIP value in local currency for balance sheet reporting"
    - name: "total_wip_value_group"
      expr: SUM(CAST(wip_value_group_currency AS DOUBLE))
      comment: "Total WIP value in group currency for consolidated reporting"
    - name: "avg_wip_value_per_order"
      expr: AVG(CAST(wip_value_local_currency AS DOUBLE))
      comment: "Average WIP value per production order"
    - name: "total_order_quantity"
      expr: SUM(CAST(order_quantity AS DOUBLE))
      comment: "Total planned production order quantity"
    - name: "total_confirmed_quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total quantity confirmed as completed"
    - name: "total_scrap_quantity"
      expr: SUM(CAST(scrap_quantity AS DOUBLE))
      comment: "Total quantity scrapped during production"
    - name: "production_completion_rate"
      expr: ROUND(100.0 * SUM(CAST(confirmed_quantity AS DOUBLE)) / NULLIF(SUM(CAST(order_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of planned production quantity confirmed as completed"
    - name: "scrap_rate"
      expr: ROUND(100.0 * SUM(CAST(scrap_quantity AS DOUBLE)) / NULLIF(SUM(CAST(order_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of planned production quantity scrapped (quality indicator)"
    - name: "avg_production_cycle_days"
      expr: AVG(CAST(DATEDIFF(expected_completion_date, production_start_date) AS DOUBLE))
      comment: "Average number of days from production start to expected completion"
    - name: "overdue_wip_count"
      expr: COUNT(CASE WHEN expected_completion_date < CURRENT_DATE() AND status IN ('open', 'partially_confirmed') THEN 1 END)
      comment: "Count of WIP orders past expected completion date"
    - name: "distinct_production_orders"
      expr: COUNT(DISTINCT order_id)
      comment: "Number of distinct production orders with WIP"
    - name: "distinct_sku_in_wip"
      expr: COUNT(DISTINCT inventory_sku_id)
      comment: "Number of distinct SKUs currently in Work-in-Progress"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_quarantine_hold`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Quality hold and quarantine KPIs tracking blocked inventory, hold duration, and disposition decisions for quality management and risk mitigation"
  source: "`manufacturing_ecm`.`inventory`.`quarantine_hold`"
  dimensions:
    - name: "hold_status"
      expr: status
      comment: "Current lifecycle status (active, pending_disposition, released, scrapped, returned)"
    - name: "hold_type"
      expr: hold_type
      comment: "Classification of hold (quality_inspection, customer_return, regulatory_hold, damage_hold, supplier_hold)"
    - name: "disposition_decision"
      expr: disposition_decision
      comment: "Final disposition (accept, rework, scrap, return_to_vendor, conditional_release)"
    - name: "hold_reason_code"
      expr: hold_reason_code
      comment: "Standardized reason code for root cause analysis"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant or distribution center code"
    - name: "inventory_category"
      expr: inventory_category
      comment: "Inventory stage (raw_material, WIP, finished_goods, MRO)"
    - name: "hold_start_month"
      expr: DATE_TRUNC('MONTH', hold_start_date)
      comment: "Month when hold was initiated for trend analysis"
    - name: "initiating_document_type"
      expr: initiating_document_type
      comment: "Type of document triggering hold (NCR, GRN, complaint, inspection_lot)"
  measures:
    - name: "total_hold_count"
      expr: COUNT(1)
      comment: "Total number of quarantine hold records"
    - name: "active_hold_count"
      expr: COUNT(CASE WHEN status = 'active' THEN 1 END)
      comment: "Count of currently active quarantine holds"
    - name: "total_hold_quantity"
      expr: SUM(CAST(hold_quantity AS DOUBLE))
      comment: "Total quantity of inventory under quarantine hold"
    - name: "total_hold_value"
      expr: SUM(CAST(hold_value AS DOUBLE))
      comment: "Total monetary value of quarantined inventory (financial exposure)"
    - name: "avg_hold_value"
      expr: AVG(CAST(hold_value AS DOUBLE))
      comment: "Average monetary value per quarantine hold"
    - name: "total_released_quantity"
      expr: SUM(CAST(released_quantity AS DOUBLE))
      comment: "Total quantity released back to unrestricted stock after disposition"
    - name: "total_scrapped_quantity"
      expr: SUM(CAST(scrapped_quantity AS DOUBLE))
      comment: "Total quantity scrapped following quality disposition"
    - name: "total_rework_quantity"
      expr: SUM(CAST(rework_quantity AS DOUBLE))
      comment: "Total quantity directed to rework operations"
    - name: "total_return_to_vendor_quantity"
      expr: SUM(CAST(return_to_vendor_quantity AS DOUBLE))
      comment: "Total quantity returned to supplier following quality rejection"
    - name: "release_rate"
      expr: ROUND(100.0 * SUM(CAST(released_quantity AS DOUBLE)) / NULLIF(SUM(CAST(hold_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of quarantined inventory released to unrestricted use"
    - name: "scrap_rate"
      expr: ROUND(100.0 * SUM(CAST(scrapped_quantity AS DOUBLE)) / NULLIF(SUM(CAST(hold_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of quarantined inventory scrapped (quality cost indicator)"
    - name: "avg_hold_duration_days"
      expr: AVG(CAST(DATEDIFF(COALESCE(actual_release_date, CURRENT_DATE()), hold_start_date) AS DOUBLE))
      comment: "Average number of days inventory remains under quarantine hold"
    - name: "overdue_hold_count"
      expr: COUNT(CASE WHEN expected_release_date < CURRENT_DATE() AND status = 'active' THEN 1 END)
      comment: "Count of holds past expected release date requiring escalation"
    - name: "distinct_sku_on_hold"
      expr: COUNT(DISTINCT inventory_sku_id)
      comment: "Number of distinct SKUs currently under quarantine hold"
    - name: "distinct_suppliers_affected"
      expr: COUNT(DISTINCT supplier_number)
      comment: "Number of distinct suppliers with materials on quality hold"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_replenishment_order`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Warehouse replenishment KPIs tracking min-max triggers, replenishment cycle time, and pick location availability for lean inventory management"
  source: "`manufacturing_ecm`.`inventory`.`replenishment_order`"
  dimensions:
    - name: "replenishment_status"
      expr: status
      comment: "Current lifecycle status (open, in_progress, completed, cancelled, on_hold)"
    - name: "trigger_type"
      expr: trigger_type
      comment: "Mechanism initiating replenishment (min_max, kanban, manual, demand_driven)"
    - name: "replenishment_method"
      expr: replenishment_method
      comment: "Replenishment strategy (fixed_quantity, fixed_cycle, two_bin, kanban, wave_pick)"
    - name: "priority"
      expr: priority
      comment: "Business priority level (critical, high, normal, low)"
    - name: "urgent_flag"
      expr: is_urgent
      comment: "Indicates urgent replenishment due to imminent stockout"
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant or distribution center code"
    - name: "destination_location_type"
      expr: destination_location_type
      comment: "Type of destination location (pick_face, kanban_lane, production_staging)"
    - name: "source_location_type"
      expr: source_location_type
      comment: "Type of source location (bulk_storage, reserve_storage, high_rack)"
    - name: "abc_classification"
      expr: abc_classification
      comment: "ABC classification of replenished material"
  measures:
    - name: "total_replenishment_count"
      expr: COUNT(1)
      comment: "Total number of replenishment orders"
    - name: "total_requested_quantity"
      expr: SUM(CAST(requested_quantity AS DOUBLE))
      comment: "Total quantity requested for replenishment"
    - name: "total_confirmed_quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total quantity confirmed available at source location"
    - name: "total_actual_quantity"
      expr: SUM(CAST(actual_quantity AS DOUBLE))
      comment: "Total quantity physically moved to destination location"
    - name: "replenishment_fulfillment_rate"
      expr: ROUND(100.0 * SUM(CAST(actual_quantity AS DOUBLE)) / NULLIF(SUM(CAST(requested_quantity AS DOUBLE)), 0), 2)
      comment: "Percentage of requested replenishment quantity successfully fulfilled"
    - name: "urgent_replenishment_count"
      expr: COUNT(CASE WHEN is_urgent = TRUE THEN 1 END)
      comment: "Count of urgent replenishments triggered by imminent stockout"
    - name: "urgent_replenishment_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN is_urgent = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of replenishments flagged as urgent (indicator of planning effectiveness)"
    - name: "avg_replenishment_cycle_time_hours"
      expr: AVG(CAST((UNIX_TIMESTAMP(completed_timestamp) - UNIX_TIMESTAMP(requested_timestamp)) / 3600.0 AS DOUBLE))
      comment: "Average time in hours from replenishment request to completion"
    - name: "on_time_completion_count"
      expr: COUNT(CASE WHEN completed_timestamp <= required_by_timestamp THEN 1 END)
      comment: "Count of replenishments completed on or before required-by time"
    - name: "on_time_completion_rate"
      expr: ROUND(100.0 * COUNT(CASE WHEN completed_timestamp <= required_by_timestamp THEN 1 END) / NULLIF(COUNT(CASE WHEN completed_timestamp IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of replenishments completed on time (SLA compliance)"
    - name: "cancelled_replenishment_count"
      expr: COUNT(CASE WHEN status = 'cancelled' THEN 1 END)
      comment: "Count of replenishment orders cancelled before completion"
    - name: "distinct_sku_replenished"
      expr: COUNT(DISTINCT inventory_sku_id)
      comment: "Number of distinct SKUs involved in replenishment activity"
    - name: "distinct_destination_locations"
      expr: COUNT(DISTINCT destination_location_code)
      comment: "Number of distinct pick locations receiving replenishment"
$$;