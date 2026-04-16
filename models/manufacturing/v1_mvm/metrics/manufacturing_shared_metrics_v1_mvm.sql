-- Metric views for domain: shared | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 09:35:49

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`shared_ar_invoice`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Accounts Receivable invoice performance metrics tracking revenue recognition, outstanding balances, dispute exposure, and collection efficiency across billing dimensions."
  source: "`manufacturing_ecm`.`shared`.`ar_invoice`"
  dimensions:
    - name: "invoice_type"
      expr: invoice_type
      comment: "Type of AR invoice (standard, credit memo, debit memo) for segmenting revenue and collection analysis."
    - name: "invoice_status"
      expr: status
      comment: "Current lifecycle status of the invoice (open, cleared, disputed, cancelled) for aging and collection tracking."
    - name: "company_code"
      expr: company_code
      comment: "Legal entity company code for cross-entity financial reporting and consolidation."
    - name: "sales_organization"
      expr: sales_organization
      comment: "Sales organization responsible for the invoice, enabling revenue attribution by sales unit."
    - name: "country_code"
      expr: country_code
      comment: "Country of the invoice for geographic revenue and tax analysis."
    - name: "currency_code"
      expr: currency_code
      comment: "Transaction currency of the invoice for multi-currency financial reporting."
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of the invoice for annual financial performance tracking."
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period of the invoice for monthly/quarterly financial close analysis."
    - name: "invoice_date"
      expr: invoice_date
      comment: "Date the invoice was issued, used for time-series revenue trend analysis."
    - name: "due_date"
      expr: due_date
      comment: "Payment due date for aging bucket analysis and DSO calculation."
    - name: "revenue_recognition_status"
      expr: revenue_recognition_status
      comment: "Revenue recognition status (recognized, deferred, pending) for compliance and financial reporting."
    - name: "payment_terms_code"
      expr: payment_terms_code
      comment: "Payment terms code to analyze collection performance by terms bucket."
    - name: "profit_center"
      expr: profit_center
      comment: "Profit center for P&L attribution and segment profitability analysis."
    - name: "dispute_indicator"
      expr: dispute_indicator
      comment: "Flag indicating whether the invoice is under dispute, used to quantify disputed revenue exposure."
    - name: "clearing_status"
      expr: clearing_status
      comment: "Clearing status of the invoice to distinguish paid vs. outstanding receivables."
  measures:
    - name: "total_invoiced_gross_amount"
      expr: SUM(CAST(gross_amount AS DOUBLE))
      comment: "Total gross invoiced amount across all AR invoices. Core revenue volume KPI used in financial close and executive revenue reporting."
    - name: "total_invoiced_net_amount"
      expr: SUM(CAST(net_amount AS DOUBLE))
      comment: "Total net invoiced amount after discounts. Represents actual recognized revenue base for margin and profitability analysis."
    - name: "total_open_receivables"
      expr: SUM(CAST(open_amount AS DOUBLE))
      comment: "Total outstanding open receivables balance. Critical liquidity and cash flow KPI monitored by CFO and treasury."
    - name: "total_discount_amount"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total discount granted on invoices. Tracks pricing discipline and discount leakage impacting net revenue."
    - name: "total_tax_amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount billed on AR invoices. Required for tax compliance reporting and VAT reconciliation."
    - name: "invoice_count"
      expr: COUNT(1)
      comment: "Total number of AR invoices issued. Volume baseline for billing throughput and operational capacity analysis."
    - name: "disputed_invoice_count"
      expr: COUNT(CASE WHEN dispute_indicator = TRUE THEN 1 END)
      comment: "Number of invoices currently under dispute. Tracks dispute exposure and customer satisfaction risk."
    - name: "disputed_open_amount"
      expr: SUM(CASE WHEN dispute_indicator = TRUE THEN CAST(open_amount AS DOUBLE) ELSE 0 END)
      comment: "Total open receivables amount tied to disputed invoices. Quantifies financial risk from unresolved disputes."
    - name: "avg_invoice_net_amount"
      expr: AVG(CAST(net_amount AS DOUBLE))
      comment: "Average net invoice value. Tracks deal size trends and revenue concentration risk over time."
    - name: "dispute_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN dispute_indicator = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of invoices under dispute. Key quality and customer satisfaction KPI; high rates signal billing or delivery issues."
    - name: "open_receivables_ratio_pct"
      expr: ROUND(100.0 * SUM(CAST(open_amount AS DOUBLE)) / NULLIF(SUM(CAST(gross_amount AS DOUBLE)), 0), 2)
      comment: "Ratio of open receivables to total gross invoiced amount. Measures collection effectiveness and cash conversion efficiency."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`shared_ap_invoice`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Accounts Payable invoice metrics tracking payables liability, payment efficiency, discount capture, and three-way match compliance across procurement and finance dimensions."
  source: "`manufacturing_ecm`.`shared`.`ap_invoice`"
  dimensions:
    - name: "invoice_type"
      expr: invoice_type
      comment: "Type of AP invoice (standard, credit, debit) for payables categorization and reporting."
    - name: "invoice_status"
      expr: invoice_status
      comment: "Current status of the AP invoice (open, paid, blocked, cancelled) for payables aging and liability tracking."
    - name: "company_code"
      expr: company_code
      comment: "Legal entity company code for cross-entity payables consolidation and reporting."
    - name: "vendor_account_number"
      expr: vendor_account_number
      comment: "Vendor identifier for supplier-level payables analysis and spend concentration."
    - name: "purchasing_org"
      expr: purchasing_org
      comment: "Purchasing organization responsible for the invoice for procurement performance attribution."
    - name: "payment_method"
      expr: payment_method
      comment: "Payment method used (wire, check, ACH) for cash management and payment efficiency analysis."
    - name: "payment_terms_code"
      expr: payment_terms_code
      comment: "Payment terms code to analyze early payment discount capture and DPO performance."
    - name: "three_way_match_status"
      expr: three_way_match_status
      comment: "Three-way match status (matched, unmatched, exception) for procurement compliance and audit risk."
    - name: "capex_opex_indicator"
      expr: capex_opex_indicator
      comment: "Indicator distinguishing capital expenditure from operating expenditure for budget classification."
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of the AP invoice for annual spend and liability reporting."
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period for monthly accrual and payables close analysis."
    - name: "cost_center"
      expr: cost_center
      comment: "Cost center for departmental spend allocation and budget variance analysis."
    - name: "profit_center"
      expr: profit_center
      comment: "Profit center for P&L cost attribution and segment cost analysis."
    - name: "payment_block_indicator"
      expr: payment_block_indicator
      comment: "Payment block reason code to identify invoices held from payment and associated liability risk."
    - name: "invoice_date"
      expr: invoice_date
      comment: "Invoice date for time-series spend trend and accrual analysis."
  measures:
    - name: "total_gross_payables"
      expr: SUM(CAST(gross_amount AS DOUBLE))
      comment: "Total gross AP invoice amount representing total payables liability. Core spend and cash outflow KPI for CFO and procurement leadership."
    - name: "total_net_payables"
      expr: SUM(CAST(net_amount AS DOUBLE))
      comment: "Total net AP invoice amount after discounts. Represents actual cash obligation for treasury and working capital management."
    - name: "total_tax_amount"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount on AP invoices for VAT reclaim and tax compliance reporting."
    - name: "total_discount_captured"
      expr: SUM(CAST(discount_amount AS DOUBLE))
      comment: "Total early payment discounts captured. Measures procurement's ability to optimize cash and capture supplier discounts."
    - name: "total_withholding_tax"
      expr: SUM(CAST(withholding_tax_amount AS DOUBLE))
      comment: "Total withholding tax on AP invoices for statutory tax compliance and reporting."
    - name: "invoice_count"
      expr: COUNT(1)
      comment: "Total number of AP invoices processed. Baseline for AP throughput, automation rate, and processing efficiency benchmarking."
    - name: "unmatched_invoice_count"
      expr: COUNT(CASE WHEN three_way_match_status != 'MATCHED' THEN 1 END)
      comment: "Number of invoices failing three-way match. Tracks procurement compliance risk and potential fraud exposure."
    - name: "blocked_invoice_count"
      expr: COUNT(CASE WHEN payment_block_indicator IS NOT NULL AND payment_block_indicator != '' THEN 1 END)
      comment: "Number of invoices blocked from payment. Indicates process exceptions requiring resolution to avoid supplier relationship risk."
    - name: "three_way_match_failure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN three_way_match_status != 'MATCHED' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of AP invoices failing three-way match. Critical procurement compliance KPI; high rates indicate receiving or PO discrepancies."
    - name: "avg_invoice_gross_amount"
      expr: AVG(CAST(gross_amount AS DOUBLE))
      comment: "Average gross AP invoice value. Tracks supplier invoice size trends and spend concentration for strategic sourcing decisions."
    - name: "company_currency_spend"
      expr: SUM(CAST(amount_in_company_currency AS DOUBLE))
      comment: "Total AP spend in company reporting currency. Enables consistent cross-currency spend analysis for consolidated financial reporting."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`shared_production_order_cost`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Production order cost performance metrics tracking actual vs. planned manufacturing costs, variance analysis, scrap and rework costs, and WIP valuation across plants and products."
  source: "`manufacturing_ecm`.`shared`.`production_order_cost`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant code for plant-level cost performance benchmarking and capacity investment decisions."
    - name: "material_number"
      expr: material_number
      comment: "Material/product number for product-level cost analysis and standard cost variance tracking."
    - name: "order_type"
      expr: order_type
      comment: "Production order type (standard, rework, repair) for cost categorization and efficiency analysis."
    - name: "order_status"
      expr: order_status
      comment: "Current status of the production order (released, completed, settled) for WIP and cost settlement tracking."
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year for annual manufacturing cost trend and budget variance reporting."
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period for monthly manufacturing cost close and variance analysis."
    - name: "company_code"
      expr: company_code
      comment: "Legal entity for cross-entity manufacturing cost consolidation."
    - name: "variance_category"
      expr: variance_category
      comment: "Category of cost variance (price, quantity, efficiency) for root cause analysis and corrective action."
    - name: "settlement_status"
      expr: settlement_status
      comment: "Settlement status of the production order for period-end cost accounting completeness."
    - name: "costing_variant"
      expr: costing_variant
      comment: "Costing variant used for the production order to distinguish standard vs. actual costing approaches."
    - name: "order_start_date"
      expr: order_start_date
      comment: "Production order start date for lead time and throughput time analysis."
    - name: "order_finish_date"
      expr: order_finish_date
      comment: "Production order finish date for on-time completion and cycle time analysis."
  measures:
    - name: "total_actual_cost"
      expr: SUM(CAST(actual_total_cost AS DOUBLE))
      comment: "Total actual manufacturing cost across all production orders. Primary cost of goods manufactured KPI for gross margin and profitability analysis."
    - name: "total_planned_cost"
      expr: SUM(CAST(planned_cost_amount AS DOUBLE))
      comment: "Total planned/standard manufacturing cost. Baseline for cost variance analysis and budget adherence tracking."
    - name: "total_cost_variance"
      expr: SUM(CAST(variance_amount AS DOUBLE))
      comment: "Total manufacturing cost variance (actual minus planned). Key operational efficiency KPI; large variances trigger management investigation."
    - name: "total_actual_material_cost"
      expr: SUM(CAST(actual_material_cost AS DOUBLE))
      comment: "Total actual material cost consumed in production. Tracks raw material efficiency and procurement cost impact on COGS."
    - name: "total_actual_labor_cost"
      expr: SUM(CAST(actual_labor_cost AS DOUBLE))
      comment: "Total actual labor cost in production. Tracks workforce efficiency and labor cost as a component of manufacturing cost."
    - name: "total_actual_machine_cost"
      expr: SUM(CAST(actual_machine_cost AS DOUBLE))
      comment: "Total actual machine/equipment cost in production. Tracks asset utilization efficiency and depreciation impact on COGS."
    - name: "total_actual_overhead_cost"
      expr: SUM(CAST(actual_overhead_cost AS DOUBLE))
      comment: "Total actual overhead cost absorbed in production. Monitors overhead absorption rate and fixed cost coverage."
    - name: "total_scrap_cost"
      expr: SUM(CAST(scrap_cost AS DOUBLE))
      comment: "Total scrap cost incurred in production. Direct quality KPI; high scrap costs indicate process or material quality issues requiring intervention."
    - name: "total_rework_cost"
      expr: SUM(CAST(rework_cost AS DOUBLE))
      comment: "Total rework cost incurred in production. Tracks quality failure cost and process capability; drives lean manufacturing improvement initiatives."
    - name: "total_wip_value"
      expr: SUM(CAST(wip_value AS DOUBLE))
      comment: "Total work-in-progress inventory value. Critical balance sheet and working capital KPI for financial close and inventory management."
    - name: "production_order_count"
      expr: COUNT(1)
      comment: "Total number of production orders. Volume baseline for manufacturing throughput and capacity utilization analysis."
    - name: "total_confirmed_quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total quantity confirmed/produced across production orders. Measures manufacturing output volume for capacity and throughput analysis."
    - name: "avg_cost_per_unit"
      expr: ROUND(SUM(CAST(actual_total_cost AS DOUBLE)) / NULLIF(SUM(CAST(confirmed_quantity AS DOUBLE)), 0), 4)
      comment: "Average actual manufacturing cost per unit produced. Key unit economics KPI for pricing, margin, and make-vs-buy decisions."
    - name: "cost_variance_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(variance_amount AS DOUBLE)) / NULLIF(SUM(CAST(planned_cost_amount AS DOUBLE)), 0), 2)
      comment: "Manufacturing cost variance as a percentage of planned cost. Measures production cost discipline; persistent negative variance signals systemic inefficiency."
    - name: "scrap_cost_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(scrap_cost AS DOUBLE)) / NULLIF(SUM(CAST(actual_total_cost AS DOUBLE)), 0), 2)
      comment: "Scrap cost as a percentage of total actual manufacturing cost. Quality efficiency KPI used in lean manufacturing and Six Sigma programs."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`shared_stock_position`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Inventory stock position metrics tracking on-hand availability, stock value, safety stock coverage, slow-moving inventory, and ATP quantity across plants and storage locations."
  source: "`manufacturing_ecm`.`shared`.`stock_position`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing or distribution plant code for plant-level inventory performance and replenishment decisions."
    - name: "stock_type"
      expr: stock_type
      comment: "Type of stock (unrestricted, quality inspection, blocked, consignment) for inventory availability analysis."
    - name: "stock_category"
      expr: stock_category
      comment: "Stock category for inventory classification and reporting (raw material, WIP, finished goods)."
    - name: "abc_classification"
      expr: abc_classification
      comment: "ABC inventory classification (A=high value, B=medium, C=low) for prioritized inventory management."
    - name: "mrp_type"
      expr: mrp_type
      comment: "MRP planning type for inventory replenishment strategy analysis and planning effectiveness."
    - name: "valuation_method"
      expr: valuation_method
      comment: "Inventory valuation method (FIFO, LIFO, moving average) for financial reporting consistency."
    - name: "valuation_currency"
      expr: valuation_currency
      comment: "Currency used for inventory valuation for multi-currency balance sheet reporting."
    - name: "country_of_origin"
      expr: country_of_origin
      comment: "Country of origin for trade compliance, tariff analysis, and supply chain risk assessment."
    - name: "slow_moving_indicator"
      expr: slow_moving_indicator
      comment: "Flag indicating slow-moving inventory items requiring markdown, disposal, or demand generation action."
    - name: "hazardous_material_indicator"
      expr: hazardous_material_indicator
      comment: "Flag for hazardous material stock requiring special handling and regulatory compliance tracking."
    - name: "position_snapshot_date"
      expr: DATE(position_snapshot_timestamp)
      comment: "Date of the inventory snapshot for time-series stock level trend analysis."
    - name: "last_movement_date"
      expr: last_movement_date
      comment: "Date of last stock movement for inventory aging and slow-moving stock identification."
  measures:
    - name: "total_on_hand_quantity"
      expr: SUM(CAST(on_hand_quantity AS DOUBLE))
      comment: "Total on-hand inventory quantity across all stock positions. Primary inventory availability KPI for supply chain and operations leadership."
    - name: "total_unrestricted_quantity"
      expr: SUM(CAST(unrestricted_quantity AS DOUBLE))
      comment: "Total unrestricted (available for use/sale) inventory quantity. Measures immediately available supply for order fulfillment and production planning."
    - name: "total_stock_value"
      expr: SUM(CAST(total_stock_value AS DOUBLE))
      comment: "Total inventory value at current valuation price. Critical balance sheet KPI for working capital management and financial reporting."
    - name: "total_atp_quantity"
      expr: SUM(CAST(atp_quantity AS DOUBLE))
      comment: "Total Available-to-Promise quantity. Drives customer order confirmation and delivery date commitment accuracy."
    - name: "total_blocked_quantity"
      expr: SUM(CAST(blocked_quantity AS DOUBLE))
      comment: "Total blocked inventory quantity. Tracks quality holds and process exceptions that reduce available supply."
    - name: "total_quality_inspection_quantity"
      expr: SUM(CAST(quality_inspection_quantity AS DOUBLE))
      comment: "Total quantity under quality inspection. Measures quality hold backlog impacting supply availability and customer service levels."
    - name: "total_in_transit_quantity"
      expr: SUM(CAST(in_transit_quantity AS DOUBLE))
      comment: "Total quantity in transit between locations. Tracks supply pipeline for accurate inventory availability and replenishment planning."
    - name: "total_reserved_quantity"
      expr: SUM(CAST(reserved_quantity AS DOUBLE))
      comment: "Total quantity reserved for confirmed orders or production. Measures committed supply and net available inventory."
    - name: "total_wip_quantity"
      expr: SUM(CAST(wip_quantity AS DOUBLE))
      comment: "Total work-in-progress quantity. Tracks manufacturing pipeline and WIP inventory levels for production flow analysis."
    - name: "avg_valuation_price"
      expr: AVG(CAST(valuation_price AS DOUBLE))
      comment: "Average inventory valuation price per stock position. Tracks unit cost trends for inventory revaluation and margin impact analysis."
    - name: "stock_position_count"
      expr: COUNT(1)
      comment: "Total number of distinct stock positions. Baseline for inventory complexity and storage location utilization analysis."
    - name: "slow_moving_stock_value"
      expr: SUM(CASE WHEN slow_moving_indicator = TRUE THEN CAST(total_stock_value AS DOUBLE) ELSE 0 END)
      comment: "Total value of slow-moving inventory. Quantifies working capital tied up in non-moving stock; drives markdown and disposal decisions."
    - name: "slow_moving_stock_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN slow_moving_indicator = TRUE THEN CAST(total_stock_value AS DOUBLE) ELSE 0 END) / NULLIF(SUM(CAST(total_stock_value AS DOUBLE)), 0), 2)
      comment: "Percentage of total inventory value classified as slow-moving. Key inventory health KPI; high percentage signals excess inventory and working capital inefficiency."
    - name: "safety_stock_coverage_ratio"
      expr: ROUND(SUM(CAST(unrestricted_quantity AS DOUBLE)) / NULLIF(SUM(CAST(safety_stock_quantity AS DOUBLE)), 0), 2)
      comment: "Ratio of unrestricted on-hand quantity to safety stock level. Measures supply buffer adequacy; ratio below 1.0 signals stockout risk requiring immediate replenishment action."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`shared_failure_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Equipment and asset failure metrics tracking downtime impact, repair costs, failure frequency, safety incidents, and OEE loss across plants and asset categories."
  source: "`manufacturing_ecm`.`shared`.`failure_record`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Plant where the failure occurred for plant-level reliability and maintenance performance benchmarking."
    - name: "failure_class"
      expr: failure_class
      comment: "Classification of the failure type for root cause analysis and preventive maintenance prioritization."
    - name: "failure_mode"
      expr: failure_mode
      comment: "Specific failure mode for FMEA-driven reliability improvement and design change decisions."
    - name: "severity_level"
      expr: severity_level
      comment: "Severity level of the failure (critical, major, minor) for risk prioritization and maintenance resource allocation."
    - name: "maintenance_type"
      expr: maintenance_type
      comment: "Type of maintenance triggered (corrective, preventive, predictive) for maintenance strategy effectiveness analysis."
    - name: "oee_loss_category"
      expr: oee_loss_category
      comment: "OEE loss category (availability, performance, quality) for Overall Equipment Effectiveness improvement targeting."
    - name: "failure_status"
      expr: failure_status
      comment: "Current status of the failure record (open, in-progress, closed) for backlog and resolution tracking."
    - name: "safety_incident_flag"
      expr: safety_incident_flag
      comment: "Flag indicating whether the failure resulted in a safety incident for EHS compliance and risk reporting."
    - name: "environmental_incident_flag"
      expr: environmental_incident_flag
      comment: "Flag indicating environmental incident associated with the failure for regulatory compliance tracking."
    - name: "recurrence_flag"
      expr: recurrence_flag
      comment: "Flag indicating whether this is a recurring failure for chronic problem identification and CAPA prioritization."
    - name: "capa_required_flag"
      expr: capa_required_flag
      comment: "Flag indicating whether a Corrective and Preventive Action is required for quality system compliance."
    - name: "failure_start_date"
      expr: DATE(failure_start_timestamp)
      comment: "Date the failure started for time-series reliability trend analysis and MTBF calculation."
    - name: "repair_type"
      expr: repair_type
      comment: "Type of repair performed (in-house, outsourced, warranty) for repair cost and strategy analysis."
  measures:
    - name: "total_failure_count"
      expr: COUNT(1)
      comment: "Total number of failure records. Primary reliability KPI baseline for MTBF calculation and maintenance program effectiveness."
    - name: "total_downtime_minutes"
      expr: SUM(CAST(downtime_duration_minutes AS DOUBLE))
      comment: "Total equipment downtime in minutes. Core OEE availability loss KPI; directly impacts production throughput and revenue."
    - name: "total_actual_repair_cost"
      expr: SUM(CAST(actual_repair_cost AS DOUBLE))
      comment: "Total actual repair cost across all failures. Key maintenance cost KPI for budget management and make-vs-buy repair decisions."
    - name: "total_estimated_repair_cost"
      expr: SUM(CAST(estimated_repair_cost AS DOUBLE))
      comment: "Total estimated repair cost for open failures. Forward-looking maintenance liability for budget forecasting and resource planning."
    - name: "total_affected_production_quantity"
      expr: SUM(CAST(affected_production_quantity AS DOUBLE))
      comment: "Total production quantity affected by failures. Quantifies the direct production output loss from equipment failures."
    - name: "safety_incident_count"
      expr: COUNT(CASE WHEN safety_incident_flag = TRUE THEN 1 END)
      comment: "Number of failures resulting in safety incidents. Critical EHS KPI; any non-zero value triggers executive safety review and regulatory reporting."
    - name: "recurring_failure_count"
      expr: COUNT(CASE WHEN recurrence_flag = TRUE THEN 1 END)
      comment: "Number of recurring failures. Identifies chronic equipment problems requiring root cause elimination and capital investment decisions."
    - name: "avg_downtime_per_failure_minutes"
      expr: AVG(CAST(downtime_duration_minutes AS DOUBLE))
      comment: "Average downtime duration per failure event. Measures maintenance response and repair efficiency; high averages indicate resource or parts availability issues."
    - name: "avg_repair_cost"
      expr: AVG(CAST(actual_repair_cost AS DOUBLE))
      comment: "Average actual repair cost per failure. Tracks repair cost trends for maintenance budget planning and outsourcing decisions."
    - name: "safety_incident_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN safety_incident_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of failures resulting in safety incidents. EHS performance KPI reported to board and regulatory bodies; drives safety investment prioritization."
    - name: "recurring_failure_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN recurrence_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of failures that are recurring. Measures maintenance program effectiveness; high rates indicate inadequate root cause resolution."
    - name: "capa_required_count"
      expr: COUNT(CASE WHEN capa_required_flag = TRUE THEN 1 END)
      comment: "Number of failures requiring CAPA. Tracks quality system compliance workload and open corrective action backlog."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`shared_product_cost_estimate`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Product standard cost estimate metrics tracking cost structure by component (material, labor, machine, overhead), cost accuracy, and cost trends across products, plants, and fiscal periods."
  source: "`manufacturing_ecm`.`shared`.`product_cost_estimate`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Manufacturing plant for plant-level standard cost comparison and transfer pricing analysis."
    - name: "product_category"
      expr: product_category
      comment: "Product category for category-level cost structure analysis and portfolio margin management."
    - name: "costing_type"
      expr: costing_type
      comment: "Type of cost estimate (standard, modified standard, current) for cost version comparison."
    - name: "costing_status"
      expr: costing_status
      comment: "Status of the cost estimate (released, marked, saved) for cost release governance tracking."
    - name: "make_buy_indicator"
      expr: make_buy_indicator
      comment: "Make vs. buy indicator for sourcing strategy cost comparison and outsourcing decisions."
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of the cost estimate for annual standard cost setting and year-over-year cost trend analysis."
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period for periodic cost review and revaluation analysis."
    - name: "company_code"
      expr: company_code
      comment: "Legal entity for cross-entity cost comparison and intercompany transfer pricing."
    - name: "costing_variant"
      expr: costing_variant
      comment: "Costing variant for distinguishing different cost scenarios (standard, simulation, actual)."
    - name: "error_indicator"
      expr: error_indicator
      comment: "Flag indicating cost estimate errors for data quality monitoring and costing run governance."
    - name: "costing_date"
      expr: costing_date
      comment: "Date the cost estimate was calculated for cost validity and release date tracking."
  measures:
    - name: "total_standard_cost"
      expr: SUM(CAST(total_standard_cost AS DOUBLE))
      comment: "Total standard cost across all product cost estimates. Foundation for COGS budgeting, transfer pricing, and inventory valuation."
    - name: "total_material_cost"
      expr: SUM(CAST(material_cost AS DOUBLE))
      comment: "Total material cost component of standard cost. Tracks raw material cost impact on product cost structure and procurement savings."
    - name: "total_labor_cost"
      expr: SUM(CAST(labor_cost AS DOUBLE))
      comment: "Total labor cost component of standard cost. Measures workforce cost contribution to product cost for make-vs-buy and automation ROI analysis."
    - name: "total_machine_cost"
      expr: SUM(CAST(machine_cost AS DOUBLE))
      comment: "Total machine/equipment cost component of standard cost. Tracks capital asset cost absorption and equipment investment justification."
    - name: "total_overhead_cost"
      expr: SUM(CAST(overhead_cost AS DOUBLE))
      comment: "Total overhead cost component of standard cost. Monitors overhead absorption and fixed cost allocation efficiency."
    - name: "total_subcontracting_cost"
      expr: SUM(CAST(subcontracting_cost AS DOUBLE))
      comment: "Total subcontracting cost component. Tracks outsourced manufacturing cost for make-vs-buy and supplier cost management decisions."
    - name: "avg_standard_cost_per_estimate"
      expr: AVG(CAST(total_standard_cost AS DOUBLE))
      comment: "Average standard cost per product cost estimate. Tracks unit cost trends for pricing strategy and margin management."
    - name: "material_cost_share_pct"
      expr: ROUND(100.0 * SUM(CAST(material_cost AS DOUBLE)) / NULLIF(SUM(CAST(total_standard_cost AS DOUBLE)), 0), 2)
      comment: "Material cost as a percentage of total standard cost. Measures material intensity of the product portfolio; high share indicates procurement leverage opportunity."
    - name: "labor_cost_share_pct"
      expr: ROUND(100.0 * SUM(CAST(labor_cost AS DOUBLE)) / NULLIF(SUM(CAST(total_standard_cost AS DOUBLE)), 0), 2)
      comment: "Labor cost as a percentage of total standard cost. Measures labor intensity for automation investment prioritization and workforce planning."
    - name: "error_estimate_count"
      expr: COUNT(CASE WHEN error_indicator = TRUE THEN 1 END)
      comment: "Number of cost estimates with errors. Data quality KPI for costing run governance; errors must be resolved before standard cost release."
    - name: "cost_estimate_count"
      expr: COUNT(1)
      comment: "Total number of product cost estimates. Baseline for costing run completeness and product portfolio cost coverage."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`shared_returns_order`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customer returns metrics tracking return volumes, return value, warranty claim rates, return reasons, and restocking costs to manage reverse logistics and product quality performance."
  source: "`manufacturing_ecm`.`shared`.`returns_order`"
  dimensions:
    - name: "return_reason_code"
      expr: return_reason_code
      comment: "Reason code for the return (defective, wrong item, customer change) for root cause analysis and quality improvement."
    - name: "return_reason_description"
      expr: return_reason_description
      comment: "Descriptive reason for the return for detailed analysis and customer feedback categorization."
    - name: "return_plant_code"
      expr: return_plant_code
      comment: "Plant receiving the return for reverse logistics capacity and disposition planning."
    - name: "disposition_code"
      expr: disposition_code
      comment: "Disposition decision for returned goods (restock, scrap, repair, return to supplier) for reverse logistics cost analysis."
    - name: "warranty_claim_flag"
      expr: warranty_claim_flag
      comment: "Flag indicating whether the return is a warranty claim for warranty liability and product quality tracking."
    - name: "status"
      expr: status
      comment: "Current status of the return order for backlog and resolution tracking."
    - name: "sales_organization"
      expr: sales_organization
      comment: "Sales organization associated with the original sale for return rate analysis by sales channel."
    - name: "currency_code"
      expr: currency_code
      comment: "Transaction currency for multi-currency return value reporting."
    - name: "material_condition_code"
      expr: material_condition_code
      comment: "Condition of returned material (new, used, damaged) for disposition and refurbishment planning."
    - name: "order_date"
      expr: order_date
      comment: "Date the return order was created for time-series return trend analysis."
    - name: "inspection_required_flag"
      expr: inspection_required_flag
      comment: "Flag indicating whether returned goods require quality inspection for resource planning."
    - name: "credit_memo_request_flag"
      expr: credit_memo_request_flag
      comment: "Flag indicating a credit memo is requested for financial liability and AR impact tracking."
  measures:
    - name: "total_return_count"
      expr: COUNT(1)
      comment: "Total number of return orders. Primary reverse logistics volume KPI for customer satisfaction and product quality monitoring."
    - name: "total_return_quantity"
      expr: SUM(CAST(return_quantity AS DOUBLE))
      comment: "Total quantity of goods returned. Measures return volume impact on inventory and production planning."
    - name: "total_net_return_value"
      expr: SUM(CAST(net_return_value AS DOUBLE))
      comment: "Total net value of returned goods. Quantifies revenue reversal and financial impact of returns on net revenue."
    - name: "total_restocking_fee"
      expr: SUM(CAST(restocking_fee AS DOUBLE))
      comment: "Total restocking fees collected on returns. Measures cost recovery from return processing and reverse logistics."
    - name: "total_tax_on_returns"
      expr: SUM(CAST(tax_amount AS DOUBLE))
      comment: "Total tax amount on return orders for tax reclaim and compliance reporting."
    - name: "warranty_claim_count"
      expr: COUNT(CASE WHEN warranty_claim_flag = TRUE THEN 1 END)
      comment: "Number of returns classified as warranty claims. Tracks warranty liability exposure and product reliability performance."
    - name: "warranty_claim_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN warranty_claim_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of returns that are warranty claims. Key product quality and reliability KPI; high rates trigger engineering and supplier quality reviews."
    - name: "avg_return_value"
      expr: AVG(CAST(net_return_value AS DOUBLE))
      comment: "Average net value per return order. Tracks return severity and financial impact per incident for prioritization."
    - name: "credit_memo_request_count"
      expr: COUNT(CASE WHEN credit_memo_request_flag = TRUE THEN 1 END)
      comment: "Number of returns requiring credit memo issuance. Tracks AR credit exposure and financial adjustment workload."
    - name: "inspection_required_count"
      expr: COUNT(CASE WHEN inspection_required_flag = TRUE THEN 1 END)
      comment: "Number of returns requiring quality inspection. Measures quality inspection backlog from returns for resource planning."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`shared_work_order_operation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Work order operation metrics tracking labor efficiency, cost performance, schedule adherence, and safety compliance across maintenance and production operations."
  source: "`manufacturing_ecm`.`shared`.`work_order_operation`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "Plant where the work order operation is executed for plant-level maintenance and production efficiency benchmarking."
    - name: "operation_type"
      expr: operation_type
      comment: "Type of operation (maintenance, production, inspection) for operational performance segmentation."
    - name: "activity_type"
      expr: activity_type
      comment: "Activity type for cost element assignment and labor category analysis."
    - name: "craft_type"
      expr: craft_type
      comment: "Craft or trade type of the technician for workforce skill utilization and capacity planning."
    - name: "work_center_code"
      expr: work_center_code
      comment: "Work center where the operation is performed for capacity utilization and bottleneck analysis."
    - name: "status"
      expr: status
      comment: "Current status of the work order operation (planned, in-progress, completed) for backlog and completion tracking."
    - name: "is_safety_critical"
      expr: is_safety_critical
      comment: "Flag indicating safety-critical operations requiring permit-to-work and enhanced oversight."
    - name: "is_milestone"
      expr: is_milestone
      comment: "Flag indicating milestone operations for project schedule adherence tracking."
    - name: "permit_to_work_required"
      expr: permit_to_work_required
      comment: "Flag indicating permit-to-work requirement for safety compliance monitoring."
    - name: "cost_currency"
      expr: cost_currency
      comment: "Currency of operation cost for multi-currency maintenance cost reporting."
    - name: "scheduled_start_date"
      expr: DATE(scheduled_start_timestamp)
      comment: "Scheduled start date for schedule adherence and planning accuracy analysis."
    - name: "actual_start_date"
      expr: DATE(actual_start_timestamp)
      comment: "Actual start date for schedule variance and delay analysis."
  measures:
    - name: "total_actual_labor_hours"
      expr: SUM(CAST(actual_labor_hours AS DOUBLE))
      comment: "Total actual labor hours consumed across work order operations. Core workforce utilization KPI for capacity planning and labor cost management."
    - name: "total_estimated_labor_hours"
      expr: SUM(CAST(estimated_labor_hours AS DOUBLE))
      comment: "Total estimated labor hours for planned work. Baseline for labor planning accuracy and resource allocation."
    - name: "total_actual_duration_hours"
      expr: SUM(CAST(actual_duration_hours AS DOUBLE))
      comment: "Total actual duration of work order operations. Measures total elapsed time for throughput and scheduling efficiency analysis."
    - name: "total_estimated_duration_hours"
      expr: SUM(CAST(estimated_duration_hours AS DOUBLE))
      comment: "Total estimated duration for planned operations. Baseline for schedule adherence and planning accuracy measurement."
    - name: "total_estimated_cost"
      expr: SUM(CAST(estimated_cost AS DOUBLE))
      comment: "Total estimated cost of work order operations. Forward-looking maintenance and production cost for budget management."
    - name: "total_remaining_labor_hours"
      expr: SUM(CAST(remaining_labor_hours AS DOUBLE))
      comment: "Total remaining labor hours on open operations. Measures outstanding work backlog for resource planning and completion forecasting."
    - name: "operation_count"
      expr: COUNT(1)
      comment: "Total number of work order operations. Volume baseline for operational throughput and work management system utilization."
    - name: "safety_critical_operation_count"
      expr: COUNT(CASE WHEN is_safety_critical = TRUE THEN 1 END)
      comment: "Number of safety-critical operations. Tracks high-risk work volume requiring enhanced oversight and permit-to-work compliance."
    - name: "labor_efficiency_ratio"
      expr: ROUND(SUM(CAST(estimated_labor_hours AS DOUBLE)) / NULLIF(SUM(CAST(actual_labor_hours AS DOUBLE)), 0), 3)
      comment: "Ratio of estimated to actual labor hours. Measures workforce efficiency; ratio below 1.0 indicates over-run requiring investigation and corrective action."
    - name: "avg_actual_duration_hours"
      expr: AVG(CAST(actual_duration_hours AS DOUBLE))
      comment: "Average actual duration per work order operation. Tracks operation cycle time for scheduling optimization and capacity planning."
    - name: "schedule_overrun_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN actual_duration_hours > estimated_duration_hours THEN 1 END) / NULLIF(COUNT(CASE WHEN estimated_duration_hours IS NOT NULL AND actual_duration_hours IS NOT NULL THEN 1 END), 0), 2)
      comment: "Percentage of operations that exceeded estimated duration. Measures planning accuracy and execution discipline; high rates indicate systemic scheduling or resource issues."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`shared_cost_allocation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Cost allocation metrics tracking allocated amounts by cost center, allocation method, and fiscal period to support management accounting, profitability analysis, and overhead absorption monitoring."
  source: "`manufacturing_ecm`.`shared`.`cost_allocation`"
  dimensions:
    - name: "allocation_type"
      expr: allocation_type
      comment: "Type of cost allocation (assessment, distribution, settlement) for management accounting transparency."
    - name: "allocation_method"
      expr: allocation_method
      comment: "Method used for cost allocation (percentage, quantity-based, activity-based) for allocation fairness and accuracy analysis."
    - name: "company_code"
      expr: company_code
      comment: "Legal entity for cross-entity cost allocation consolidation and intercompany analysis."
    - name: "receiver_cost_center"
      expr: receiver_cost_center
      comment: "Cost center receiving the allocated costs for departmental cost accountability and budget variance analysis."
    - name: "sender_cost_element"
      expr: sender_cost_element
      comment: "Cost element of the sending cost center for cost origin traceability and overhead pool analysis."
    - name: "functional_area"
      expr: functional_area
      comment: "Functional area (manufacturing, sales, R&D) for functional cost reporting and P&L segmentation."
    - name: "capex_opex_indicator"
      expr: capex_opex_indicator
      comment: "Capital vs. operating expenditure indicator for budget classification and financial reporting."
    - name: "plan_actual_indicator"
      expr: plan_actual_indicator
      comment: "Indicator distinguishing planned from actual allocations for budget vs. actual variance analysis."
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year for annual cost allocation trend and budget adherence reporting."
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period for monthly cost allocation close and accrual analysis."
    - name: "reversal_flag"
      expr: reversal_flag
      comment: "Flag indicating reversed allocation entries for net allocation accuracy and audit trail."
    - name: "allocation_date"
      expr: allocation_date
      comment: "Date of the cost allocation posting for time-series cost flow analysis."
  measures:
    - name: "total_allocated_amount"
      expr: SUM(CAST(allocated_amount AS DOUBLE))
      comment: "Total cost allocated in transaction currency. Primary management accounting KPI for overhead absorption and cost center accountability."
    - name: "total_allocated_company_currency"
      expr: SUM(CAST(allocated_amount_company_currency AS DOUBLE))
      comment: "Total allocated cost in company reporting currency. Enables consistent cross-currency cost consolidation for financial reporting."
    - name: "total_allocated_controlling_currency"
      expr: SUM(CAST(allocated_amount_controlling_currency AS DOUBLE))
      comment: "Total allocated cost in controlling area currency. Used for management reporting and profitability analysis in the controlling currency."
    - name: "allocation_count"
      expr: COUNT(1)
      comment: "Total number of cost allocation postings. Baseline for allocation cycle completeness and period-end close monitoring."
    - name: "reversal_count"
      expr: COUNT(CASE WHEN reversal_flag = TRUE THEN 1 END)
      comment: "Number of reversed allocation entries. Tracks allocation correction volume; high reversal rates indicate process quality issues."
    - name: "avg_allocation_amount"
      expr: AVG(CAST(allocated_amount AS DOUBLE))
      comment: "Average cost allocation amount per posting. Tracks allocation granularity and identifies unusually large or small allocations for review."
    - name: "reversal_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN reversal_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of cost allocations that were reversed. Measures allocation process quality; high rates indicate data entry errors or incorrect allocation rules."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`shared_installed_base`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Installed base asset metrics tracking fleet size, operational status, warranty coverage, service overdue assets, and upgrade eligibility to support aftermarket revenue and service planning."
  source: "`manufacturing_ecm`.`shared`.`installed_base`"
  dimensions:
    - name: "operational_status"
      expr: operational_status
      comment: "Operational status of the installed asset (active, inactive, decommissioned) for fleet availability and service planning."
    - name: "product_category"
      expr: product_category
      comment: "Product category of the installed asset for portfolio-level service revenue and aftermarket analysis."
    - name: "warranty_type"
      expr: warranty_type
      comment: "Type of warranty coverage (standard, extended, none) for warranty liability and service contract upsell analysis."
    - name: "connectivity_status"
      expr: connectivity_status
      comment: "IoT/IIoT connectivity status of the asset for digital service enablement and remote monitoring coverage."
    - name: "service_territory"
      expr: service_territory
      comment: "Service territory for field service resource planning and territory-level service performance."
    - name: "upgrade_eligibility_flag"
      expr: upgrade_eligibility_flag
      comment: "Flag indicating whether the asset is eligible for upgrade for aftermarket revenue opportunity identification."
    - name: "status"
      expr: status
      comment: "Record status of the installed base entry for data quality and active fleet management."
    - name: "installation_date"
      expr: installation_date
      comment: "Date the asset was installed for fleet age analysis and end-of-life planning."
    - name: "warranty_start_date"
      expr: warranty_start_date
      comment: "Warranty start date for warranty coverage period tracking and expiry management."
    - name: "end_of_support_date"
      expr: end_of_support_date
      comment: "End of support date for proactive customer notification and service contract renewal campaigns."
  measures:
    - name: "total_installed_base_count"
      expr: COUNT(1)
      comment: "Total number of installed base assets. Primary fleet size KPI for aftermarket revenue potential, service capacity planning, and market penetration analysis."
    - name: "active_asset_count"
      expr: COUNT(CASE WHEN operational_status = 'ACTIVE' THEN 1 END)
      comment: "Number of actively operational installed assets. Measures productive fleet size for service revenue forecasting and utilization analysis."
    - name: "upgrade_eligible_count"
      expr: COUNT(CASE WHEN upgrade_eligibility_flag = TRUE THEN 1 END)
      comment: "Number of assets eligible for upgrade. Quantifies aftermarket upgrade revenue opportunity for sales and product management."
    - name: "connected_asset_count"
      expr: COUNT(CASE WHEN connectivity_status = 'CONNECTED' THEN 1 END)
      comment: "Number of IoT-connected installed assets. Measures digital service enablement coverage and remote monitoring penetration."
    - name: "connectivity_penetration_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN connectivity_status = 'CONNECTED' THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of installed base that is IoT-connected. Strategic KPI for digital transformation progress and predictive maintenance enablement."
    - name: "upgrade_eligible_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN upgrade_eligibility_flag = TRUE THEN 1 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of installed base eligible for upgrade. Measures aftermarket revenue opportunity size relative to total fleet."
    - name: "overdue_service_count"
      expr: COUNT(CASE WHEN next_planned_service_date < CURRENT_DATE() AND operational_status = 'ACTIVE' THEN 1 END)
      comment: "Number of active assets with overdue planned service. Critical field service KPI; overdue assets risk SLA breach, warranty void, and customer satisfaction impact."
    - name: "distinct_product_categories"
      expr: COUNT(DISTINCT product_category)
      comment: "Number of distinct product categories in the installed base. Measures portfolio breadth for service capability and spare parts planning."
$$;