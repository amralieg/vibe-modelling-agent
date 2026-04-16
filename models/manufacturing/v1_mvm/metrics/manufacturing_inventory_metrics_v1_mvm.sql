-- Metric views for domain: inventory | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 09:35:49

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_cycle_count_performance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Measures the operational effectiveness and financial impact of cycle counting programs across plants, zones, and ABC classes. Drives inventory accuracy governance, recount escalation tracking, and variance financial exposure reporting for warehouse and finance leadership."
  source: "`manufacturing_ecm`.`inventory`.`cycle_count`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code identifying the manufacturing facility or distribution center where the cycle count was performed. Enables multi-plant benchmarking of count accuracy and variance rates."
    - name: "count_zone"
      expr: count_zone
      comment: "Logical or physical warehouse zone designated for the cycle count. Supports zone-level accuracy analysis and workload distribution reporting."
    - name: "abc_class"
      expr: abc_class
      comment: "ABC inventory classification of materials in scope. Enables differentiated accuracy reporting by value tier — critical for ensuring A-class items receive highest counting frequency."
    - name: "count_frequency"
      expr: count_frequency
      comment: "Scheduled recurrence frequency of the cycle count (daily, weekly, monthly). Used to assess compliance with ABC-driven counting cadence requirements."
    - name: "count_method"
      expr: count_method
      comment: "Physical counting method used (manual, RF scanner, RFID, barcode). Supports accuracy-by-method analysis to drive technology investment decisions."
    - name: "count_type"
      expr: count_type
      comment: "Type of cycle count (standard, blind, recount, audit). Enables segmentation of accuracy and variance metrics by count methodology."
    - name: "inventory_category"
      expr: inventory_category
      comment: "Category of inventory being counted (Raw Material, WIP, Finished Goods, MRO). Supports category-level inventory accuracy and variance reporting."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the cycle count (planned, in-progress, completed, reconciled). Used to filter operational dashboards to active or completed counts."
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal year and period (YYYY-MM) of the cycle count. Enables period-over-period trending of inventory accuracy and variance financial impact."
    - name: "scheduled_count_date"
      expr: scheduled_count_date
      comment: "Planned date for the cycle count. Used as a time dimension for schedule adherence and compliance trending."
    - name: "actual_count_date"
      expr: actual_count_date
      comment: "Actual date the cycle count was performed. Used alongside scheduled_count_date to measure schedule adherence."
    - name: "inventory_adjustment_posted"
      expr: inventory_adjustment_posted
      comment: "Flag indicating whether the inventory adjustment has been posted in SAP MM. Used to track posting completion rate and identify open reconciliation items."
    - name: "recount_required"
      expr: recount_required
      comment: "Flag indicating whether a recount was triggered due to variance exceedance. Used to segment counts requiring escalation from those completed within tolerance."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the facility. Supports multi-country regulatory compliance and regional inventory accuracy benchmarking."
  measures:
    - name: "total_cycle_counts"
      expr: COUNT(1)
      comment: "Total number of cycle count events. Baseline volume metric used to normalize accuracy rates and assess counting program coverage across plants and periods."
    - name: "completed_cycle_counts"
      expr: COUNT(CASE WHEN status = 'completed' OR status = 'reconciled' THEN 1 END)
      comment: "Number of cycle counts that reached completed or reconciled status. Used to calculate completion rate and assess program execution discipline."
    - name: "counts_requiring_recount"
      expr: COUNT(CASE WHEN recount_required = TRUE THEN 1 END)
      comment: "Number of cycle counts that triggered a recount due to variance exceedance. High values indicate systemic accuracy issues requiring root cause investigation."
    - name: "counts_with_adjustment_posted"
      expr: COUNT(CASE WHEN inventory_adjustment_posted = TRUE THEN 1 END)
      comment: "Number of cycle counts where the inventory adjustment has been formally posted in SAP MM. Used to track financial close completeness and identify open posting backlogs."
    - name: "total_variance_value"
      expr: SUM(CAST(total_variance_value AS DOUBLE))
      comment: "Total monetary value of inventory variances identified across all cycle counts. Primary financial exposure KPI used by finance and inventory controllers to assess balance sheet risk from counting discrepancies."
    - name: "total_variance_qty"
      expr: SUM(CAST(total_variance_qty AS DOUBLE))
      comment: "Aggregate net quantity variance across all cycle counts. Positive values indicate systemic overages; negative values indicate systemic shortages. Used to identify directional inventory drift."
    - name: "avg_variance_value_per_count"
      expr: AVG(CAST(total_variance_value AS DOUBLE))
      comment: "Average monetary variance per cycle count event. Benchmarks the typical financial impact of a single count and identifies outlier events requiring investigation."
    - name: "total_skus_counted"
      expr: SUM(CAST(total_sku_count AS DOUBLE))
      comment: "Total number of SKU lines counted across all cycle count events. Measures the breadth of inventory coverage achieved by the counting program."
    - name: "total_bins_counted"
      expr: SUM(CAST(total_bins_counted AS DOUBLE))
      comment: "Total number of storage bins physically counted. Measures warehouse location coverage and supports capacity planning for counting resources."
    - name: "avg_variance_threshold_pct"
      expr: AVG(CAST(variance_threshold_pct AS DOUBLE))
      comment: "Average variance tolerance threshold configured across cycle counts. Used to assess whether tolerance policies are consistently applied and appropriately calibrated by ABC class."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_cycle_count_accuracy`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Measures inventory count accuracy at the SKU and storage location level, tracking variance rates, tolerance exceedance, recount frequency, and financial impact of discrepancies. Core KPI view for inventory accuracy governance, used by warehouse managers, inventory controllers, and finance teams."
  source: "`manufacturing_ecm`.`inventory`.`cycle_count_result`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where the cycle count result was recorded. Enables multi-plant inventory accuracy benchmarking."
    - name: "abc_classification"
      expr: abc_classification
      comment: "ABC classification of the SKU counted. Critical for segmenting accuracy performance by inventory value tier — A-class accuracy failures carry the highest financial risk."
    - name: "inventory_category"
      expr: inventory_category
      comment: "Category of inventory (raw material, WIP, finished goods, MRO). Enables category-level accuracy reporting aligned with balance sheet sub-classifications."
    - name: "count_method"
      expr: count_method
      comment: "Physical counting method used (manual, RF scanner, RFID, barcode). Supports accuracy-by-method analysis to justify technology investments."
    - name: "stock_type"
      expr: stock_type
      comment: "SAP stock category (unrestricted, quality inspection, blocked). Enables accuracy analysis by stock usability status."
    - name: "approval_status"
      expr: approval_status
      comment: "Workflow status of the count result (pending, approved, recount_required). Used to track approval pipeline and identify bottlenecks in the variance resolution process."
    - name: "count_date"
      expr: count_date
      comment: "Calendar date the physical count was performed. Primary time dimension for accuracy trending and compliance reporting."
    - name: "adjustment_posting_date"
      expr: adjustment_posting_date
      comment: "Date the inventory adjustment was posted to the GL. Used to measure turnaround time from count to financial posting."
    - name: "recount_flag"
      expr: recount_flag
      comment: "Indicates whether this result is a recount. Used to segment initial counts from recount rounds for accuracy analysis."
    - name: "exceeds_tolerance_flag"
      expr: exceeds_tolerance_flag
      comment: "Indicates whether the variance exceeded the configured tolerance threshold. Primary flag for identifying count results requiring supervisor review or recount."
    - name: "zero_count_flag"
      expr: zero_count_flag
      comment: "Indicates whether the counter confirmed a zero quantity. Used to distinguish confirmed zero-stock positions from missing count entries."
    - name: "adjustment_posted_flag"
      expr: adjustment_posted_flag
      comment: "Indicates whether the inventory adjustment has been posted to the SAP material ledger. Used to track financial close completeness."
    - name: "valuation_method"
      expr: valuation_method
      comment: "Inventory valuation method applied to the variance (standard price, MAP, FIFO). Supports financial impact analysis by costing method."
    - name: "local_currency_code"
      expr: local_currency_code
      comment: "ISO 4217 currency code for variance values. Required for multi-currency financial reporting across global plants."
  measures:
    - name: "total_count_lines"
      expr: COUNT(1)
      comment: "Total number of SKU-level count result records. Baseline volume metric for normalizing accuracy rates and measuring counting program scope."
    - name: "count_lines_exceeding_tolerance"
      expr: COUNT(CASE WHEN exceeds_tolerance_flag = TRUE THEN 1 END)
      comment: "Number of count lines where variance exceeded the configured tolerance threshold. Numerator for the tolerance exceedance rate KPI — high values signal systemic accuracy problems."
    - name: "count_lines_within_tolerance"
      expr: COUNT(CASE WHEN exceeds_tolerance_flag = FALSE THEN 1 END)
      comment: "Number of count lines where variance fell within tolerance. Numerator for the inventory accuracy rate KPI — the primary measure of counting program effectiveness."
    - name: "recount_lines"
      expr: COUNT(CASE WHEN recount_flag = TRUE THEN 1 END)
      comment: "Number of count lines that are recounts (second or subsequent count rounds). Measures the volume of rework generated by out-of-tolerance variances."
    - name: "adjustments_posted"
      expr: COUNT(CASE WHEN adjustment_posted_flag = TRUE THEN 1 END)
      comment: "Number of count lines where the inventory adjustment has been posted to the material ledger. Tracks financial close completeness for cycle count variances."
    - name: "total_variance_quantity"
      expr: SUM(CAST(variance_quantity AS DOUBLE))
      comment: "Net aggregate quantity variance across all count lines (counted minus book). Positive values indicate systemic overages; negative values indicate systemic shortages. Used to detect directional inventory drift."
    - name: "total_variance_value_local_currency"
      expr: SUM(CAST(variance_value_local_currency AS DOUBLE))
      comment: "Total monetary value of inventory variances in local currency. Primary financial exposure KPI for balance sheet risk assessment and inventory adjustment financial impact reporting."
    - name: "avg_variance_percentage"
      expr: AVG(CAST(variance_percentage AS DOUBLE))
      comment: "Average variance percentage across all count lines. Benchmarks typical relative accuracy and enables comparison against tolerance thresholds and industry benchmarks."
    - name: "total_book_quantity"
      expr: SUM(CAST(book_quantity AS DOUBLE))
      comment: "Total system book quantity across all counted SKU-location combinations. Denominator for aggregate variance rate calculations and inventory position baseline."
    - name: "total_counted_quantity"
      expr: SUM(CAST(counted_quantity AS DOUBLE))
      comment: "Total physically counted quantity across all count lines. Compared against total book quantity to assess aggregate inventory position accuracy."
    - name: "avg_valuation_price"
      expr: AVG(CAST(valuation_price AS DOUBLE))
      comment: "Average unit valuation price across counted SKUs. Used to contextualize variance financial impact and prioritize high-value accuracy investigations."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_inventory_valuation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Tracks the financial value of inventory positions by plant, category, valuation method, and fiscal period. Supports balance sheet inventory reporting, period-end closing, IFRS IAS 2 compliance, and standard cost management for finance and supply chain leadership."
  source: "`manufacturing_ecm`.`inventory`.`inventory_valuation`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code representing the manufacturing facility or distribution center. Primary organizational dimension for inventory valuation reporting."
    - name: "company_code"
      expr: company_code
      comment: "SAP company code representing the legal entity. Required for legal entity-level balance sheet reporting and intercompany reconciliation."
    - name: "inventory_category"
      expr: inventory_category
      comment: "Category of inventory (Raw Material, WIP, Finished Goods, MRO, Semi-Finished). Drives balance sheet sub-classification and COGS analysis."
    - name: "abc_classification"
      expr: abc_classification
      comment: "ABC classification of the material. Enables value-tier analysis of inventory holdings — A-class items typically represent the majority of inventory value."
    - name: "method"
      expr: method
      comment: "Inventory valuation method (Standard Cost, Moving Average Price, FIFO, LIFO). Critical for understanding how inventory value is determined and its P&L impact."
    - name: "price_control_indicator"
      expr: price_control_indicator
      comment: "SAP price control indicator (S=Standard Price, V=Moving Average Price). Determines how inventory movements are valued and variance treatment."
    - name: "class"
      expr: class
      comment: "SAP valuation class (BKLAS) determining GL account assignment. Used for financial reconciliation between MM and FI modules."
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of the valuation record. Enables year-over-year inventory value trending and annual closing analysis."
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period within the fiscal year. Enables period-end inventory closing and month-over-month valuation trending."
    - name: "snapshot_type"
      expr: snapshot_type
      comment: "Type of valuation snapshot (period-end, year-end, on-demand). Used to distinguish official financial closing snapshots from operational queries."
    - name: "currency_code"
      expr: currency_code
      comment: "ISO 4217 currency code for valuation amounts. Required for multi-currency inventory reporting across global operations."
    - name: "group_currency_code"
      expr: group_currency_code
      comment: "Corporate group reporting currency code. Enables consolidated group-level inventory value reporting."
    - name: "date"
      expr: date
      comment: "Business date of the inventory valuation snapshot. Primary time dimension for point-in-time inventory value analysis."
    - name: "special_stock_indicator"
      expr: special_stock_indicator
      comment: "SAP special stock type (consignment, project stock, sales order stock). Used to segment standard own stock from special stock categories in valuation reporting."
  measures:
    - name: "total_stock_value_local_currency"
      expr: SUM(CAST(total_value_local_currency AS DOUBLE))
      comment: "Total inventory value in local currency across all valuation records. Primary balance sheet KPI for inventory asset reporting and period-end financial closing."
    - name: "total_stock_value_group_currency"
      expr: SUM(CAST(total_value_group_currency AS DOUBLE))
      comment: "Total inventory value translated to group reporting currency. Enables consolidated group-level balance sheet inventory reporting across multinational operations."
    - name: "total_stock_quantity"
      expr: SUM(CAST(total_stock_quantity AS DOUBLE))
      comment: "Total quantity of valuated stock on hand across all materials and plants. Used to calculate average unit value and assess inventory volume trends."
    - name: "avg_moving_average_price"
      expr: AVG(CAST(moving_average_price AS DOUBLE))
      comment: "Average moving average price across materials. Tracks procurement cost trends and identifies materials with significant price drift requiring standard cost review."
    - name: "total_net_realizable_value"
      expr: SUM(CAST(net_realizable_value AS DOUBLE))
      comment: "Total net realizable value of inventory. Required under IFRS IAS 2 to assess whether inventory should be written down below cost. Critical for period-end impairment assessment."
    - name: "avg_lowest_value_devaluation_pct"
      expr: AVG(CAST(lowest_value_devaluation_pct AS DOUBLE))
      comment: "Average devaluation percentage applied under the lowest value principle. Measures the extent of inventory write-downs for slow-moving or obsolete stock across the portfolio."
    - name: "distinct_materials_valued"
      expr: COUNT(DISTINCT inventory_valuation_id)
      comment: "Number of distinct inventory valuation records. Measures the breadth of the valuation run and ensures completeness of period-end inventory coverage."
    - name: "total_stock_value_at_standard"
      expr: SUM(CAST(total_stock_value AS DOUBLE))
      comment: "Total inventory value calculated at standard or moving average price per SAP MBEW. Core balance sheet inventory figure used for statutory financial reporting and audit."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_physical_inventory`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Tracks the execution quality, financial impact, and compliance status of full physical inventory count events (wall-to-wall and partial counts). Used by inventory controllers, finance, and auditors to assess count completeness, variance exposure, and period-end closing readiness."
  source: "`manufacturing_ecm`.`inventory`.`physical_inventory`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where the physical inventory was conducted. Primary organizational dimension for multi-plant count performance benchmarking."
    - name: "company_code"
      expr: company_code
      comment: "SAP company code of the legal entity responsible for the count. Required for legal entity-level financial reporting of inventory variances."
    - name: "count_type"
      expr: count_type
      comment: "Scope of the physical inventory count (full_count, partial_count, spot_check). Enables segmentation of variance and completion metrics by count scope."
    - name: "count_method"
      expr: count_method
      comment: "Method used for the physical count (manual, scanner, RFID, automated). Supports accuracy-by-method analysis and technology investment decisions."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the physical inventory event (created, counting, recounting, completed, posted, cancelled). Used to monitor execution progress and identify stalled counts."
    - name: "approval_status"
      expr: approval_status
      comment: "Approval workflow status for variance adjustments (not_required, pending, approved, rejected). Tracks the financial authorization pipeline for inventory variance postings."
    - name: "inventory_category"
      expr: inventory_category
      comment: "Category of inventory in scope (raw materials, WIP, finished goods, MRO, all). Enables category-level variance and completion reporting."
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of the physical inventory event. Enables year-over-year comparison of count performance and variance trends."
    - name: "planned_count_date"
      expr: planned_count_date
      comment: "Scheduled date for the physical inventory count. Used as a time dimension for schedule adherence analysis."
    - name: "actual_count_date"
      expr: actual_count_date
      comment: "Actual date the count was performed. Used alongside planned_count_date to measure schedule adherence."
    - name: "adjustment_posted_flag"
      expr: adjustment_posted_flag
      comment: "Indicates whether variance adjustments have been financially posted. Used to track period-end closing completeness."
    - name: "goods_movements_blocked"
      expr: goods_movements_blocked
      comment: "Indicates whether goods movements were blocked during the count. Used to assess count integrity — unblocked counts carry higher risk of stock changes during counting."
    - name: "production_freeze_required"
      expr: production_freeze_required
      comment: "Indicates whether production was frozen during the count. Critical for full wall-to-wall counts where production activity would invalidate the count."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the facility. Supports multi-country regulatory compliance and regional reporting."
  measures:
    - name: "total_physical_inventory_events"
      expr: COUNT(1)
      comment: "Total number of physical inventory count events. Baseline volume metric for assessing counting program scope and frequency."
    - name: "completed_events"
      expr: COUNT(CASE WHEN status IN ('completed', 'posted') THEN 1 END)
      comment: "Number of physical inventory events that reached completed or posted status. Used to calculate completion rate and assess program execution discipline."
    - name: "events_with_adjustment_posted"
      expr: COUNT(CASE WHEN adjustment_posted_flag = TRUE THEN 1 END)
      comment: "Number of events where variance adjustments have been financially posted. Tracks period-end closing completeness — unposted adjustments represent open financial exposure."
    - name: "total_variance_value"
      expr: SUM(CAST(total_variance_value AS DOUBLE))
      comment: "Total financial value of inventory variances identified across all physical inventory events. Primary financial exposure KPI for balance sheet risk assessment and audit reporting."
    - name: "avg_variance_value_per_event"
      expr: AVG(CAST(total_variance_value AS DOUBLE))
      comment: "Average financial variance per physical inventory event. Benchmarks typical count quality and identifies outlier events requiring investigation."
    - name: "avg_variance_threshold_pct"
      expr: AVG(CAST(variance_threshold_pct AS DOUBLE))
      comment: "Average variance tolerance threshold configured across physical inventory events. Used to assess consistency of tolerance policy application."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_quarantine_hold`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Tracks the volume, financial exposure, aging, and disposition outcomes of inventory quarantine and quality holds. Used by quality, supply chain, and finance teams to manage blocked stock risk, supplier quality performance, and regulatory compliance."
  source: "`manufacturing_ecm`.`inventory`.`quarantine_hold`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where the quarantined inventory is located. Enables multi-plant quality hold analysis and risk concentration reporting."
    - name: "hold_type"
      expr: hold_type
      comment: "Classification of the quarantine hold (quality inspection, customer return, regulatory hold, damage hold). Drives disposition workflow and responsible team assignment."
    - name: "hold_reason_code"
      expr: hold_reason_code
      comment: "Standardized code for the hold reason. Used for root cause categorization, CAPA tracking, and trend analysis of quality hold drivers."
    - name: "disposition_decision"
      expr: disposition_decision
      comment: "Final disposition outcome (accept, rework, scrap, return to vendor). Measures the effectiveness of quality resolution and the cost of non-conformance."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the quarantine hold. Used to identify open holds, aging inventory, and resolution bottlenecks."
    - name: "inventory_category"
      expr: inventory_category
      comment: "Category of quarantined inventory (raw material, WIP, finished goods, MRO). Enables category-level quality hold analysis."
    - name: "stock_type"
      expr: stock_type
      comment: "SAP stock type of quarantined inventory (blocked, quality inspection). Determines MRP and availability check treatment of held stock."
    - name: "initiating_document_type"
      expr: initiating_document_type
      comment: "Type of document that triggered the hold (NCR, GRN, customer complaint). Identifies the business process generating the most quality holds."
    - name: "hold_start_date"
      expr: hold_start_date
      comment: "Date the quarantine hold was initiated. Primary time dimension for hold aging analysis and SLA compliance tracking."
    - name: "expected_release_date"
      expr: expected_release_date
      comment: "Planned release date for the hold. Used to assess supply chain impact and ATP availability for production planning."
    - name: "actual_release_date"
      expr: actual_release_date
      comment: "Actual date the hold was resolved. Used to calculate hold duration and measure disposition cycle time performance."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the facility. Supports multi-country regulatory compliance and regional quality hold reporting."
    - name: "company_code"
      expr: company_code
      comment: "SAP company code of the legal entity responsible for the quarantined inventory. Required for financial posting of scrap, rework costs, and vendor debit memos."
  measures:
    - name: "total_quarantine_holds"
      expr: COUNT(1)
      comment: "Total number of quarantine hold records. Baseline volume metric for quality hold program scope and trend analysis."
    - name: "open_quarantine_holds"
      expr: COUNT(CASE WHEN status NOT IN ('released', 'closed', 'scrapped', 'returned') THEN 1 END)
      comment: "Number of currently open quarantine holds. Measures the active blocked stock backlog and supply chain risk exposure at any point in time."
    - name: "total_hold_value"
      expr: SUM(CAST(hold_value AS DOUBLE))
      comment: "Total financial value of quarantined inventory. Primary financial exposure KPI for management escalation — represents capital tied up in blocked stock pending disposition."
    - name: "total_hold_quantity"
      expr: SUM(CAST(hold_quantity AS DOUBLE))
      comment: "Total quantity of inventory placed under quarantine hold. Measures the volume of blocked stock and its potential supply chain impact."
    - name: "total_scrapped_quantity"
      expr: SUM(CAST(scrapped_quantity AS DOUBLE))
      comment: "Total quantity dispositioned as scrap. Measures the volume of inventory loss from quality failures — directly impacts COGS and waste reporting."
    - name: "total_released_quantity"
      expr: SUM(CAST(released_quantity AS DOUBLE))
      comment: "Total quantity released back to unrestricted stock following inspection. Measures the recovery rate from quarantine holds."
    - name: "total_rework_quantity"
      expr: SUM(CAST(rework_quantity AS DOUBLE))
      comment: "Total quantity directed to rework operations. Measures the volume of non-conforming material requiring remediation — drives rework cost and production capacity impact."
    - name: "total_return_to_vendor_quantity"
      expr: SUM(CAST(return_to_vendor_quantity AS DOUBLE))
      comment: "Total quantity returned to suppliers. Measures supplier quality failure volume and drives supplier corrective action and scorecard updates."
    - name: "avg_hold_value_per_hold"
      expr: AVG(CAST(hold_value AS DOUBLE))
      comment: "Average financial value per quarantine hold event. Benchmarks the typical financial exposure of a quality hold and identifies high-value outliers requiring priority resolution."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_stock_adjustment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Tracks the volume, financial impact, and approval compliance of inventory stock adjustments across plants and adjustment types. Used by inventory controllers, finance, and auditors to monitor inventory write-offs, shrinkage, and the financial integrity of stock correction processes."
  source: "`manufacturing_ecm`.`inventory`.`stock_adjustment`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where the adjustment was made. Enables multi-plant benchmarking of adjustment frequency and financial impact."
    - name: "adjustment_type"
      expr: adjustment_type
      comment: "Classification of the adjustment (count variance, damage write-off, quality rejection, system correction). Drives accounting treatment and root cause analysis."
    - name: "reason_code"
      expr: reason_code
      comment: "Standardized reason code for the adjustment (CYCLE_COUNT_VAR, DAMAGE_INBOUND, QA_REJECT, SYS_ERR). Used for root cause analysis and CAPA tracking."
    - name: "inventory_category"
      expr: inventory_category
      comment: "Category of inventory adjusted (raw material, WIP, finished goods, MRO). Supports category-level adjustment analysis and COGS impact reporting."
    - name: "abc_classification"
      expr: abc_classification
      comment: "ABC classification of the adjusted SKU. Enables value-tier analysis of adjustment frequency and financial impact."
    - name: "status"
      expr: status
      comment: "Current workflow status of the adjustment (draft, pending_approval, approved, posted, reversed). Used to track the adjustment lifecycle and identify open items."
    - name: "stock_type"
      expr: stock_type
      comment: "Category of stock adjusted (unrestricted, quality inspection, blocked). Determines the inventory availability impact of the adjustment."
    - name: "company_code"
      expr: company_code
      comment: "SAP company code of the legal entity responsible for the adjustment. Required for legal entity-level financial reporting and SOX compliance."
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of the adjustment posting. Enables year-over-year trending of inventory write-offs and adjustment financial impact."
    - name: "posting_date"
      expr: posting_date
      comment: "Accounting posting date of the adjustment. Determines the fiscal period to which the financial impact is attributed."
    - name: "requires_approval"
      expr: requires_approval
      comment: "Indicates whether the adjustment required management approval. Used to assess internal controls compliance and segregation of duties."
    - name: "reversal_indicator"
      expr: reversal_indicator
      comment: "Indicates whether the adjustment has been reversed. Used to identify cancelled adjustments and calculate net financial impact."
    - name: "valuation_method"
      expr: valuation_method
      comment: "Costing method applied to value the adjustment (standard cost, MAP, FIFO). Determines how the financial impact is calculated."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the plant. Supports multi-country regulatory compliance and regional adjustment reporting."
  measures:
    - name: "total_adjustments"
      expr: COUNT(1)
      comment: "Total number of stock adjustment records. Baseline volume metric for assessing adjustment frequency and identifying plants or categories with systemic inventory accuracy issues."
    - name: "posted_adjustments"
      expr: COUNT(CASE WHEN status = 'posted' THEN 1 END)
      comment: "Number of adjustments that have been financially posted. Measures the volume of completed inventory corrections and financial close completeness."
    - name: "reversed_adjustments"
      expr: COUNT(CASE WHEN reversal_indicator = TRUE THEN 1 END)
      comment: "Number of adjustments that have been reversed. High reversal rates indicate data quality issues or process errors in the adjustment workflow."
    - name: "total_financial_impact"
      expr: SUM(CAST(financial_impact_amount AS DOUBLE))
      comment: "Total monetary value of all inventory adjustments. Primary financial KPI for inventory write-off reporting, P&L impact assessment, and SOX compliance monitoring."
    - name: "total_adjusted_quantity"
      expr: SUM(CAST(adjusted_quantity AS DOUBLE))
      comment: "Net aggregate quantity change across all adjustments. Positive values indicate net inventory increases; negative values indicate net inventory decreases (shrinkage, write-offs)."
    - name: "avg_financial_impact_per_adjustment"
      expr: AVG(CAST(financial_impact_amount AS DOUBLE))
      comment: "Average monetary impact per stock adjustment. Benchmarks the typical financial consequence of an adjustment and identifies high-value outliers requiring investigation."
    - name: "adjustments_requiring_approval"
      expr: COUNT(CASE WHEN requires_approval = TRUE THEN 1 END)
      comment: "Number of adjustments that required management approval due to financial impact thresholds. Measures the volume of high-value adjustments subject to internal controls."
    - name: "total_book_quantity_before"
      expr: SUM(CAST(book_quantity_before AS DOUBLE))
      comment: "Total book inventory quantity before adjustments were applied. Used as the baseline for calculating aggregate adjustment impact rates."
    - name: "total_book_quantity_after"
      expr: SUM(CAST(book_quantity_after AS DOUBLE))
      comment: "Total book inventory quantity after adjustments were applied. Compared against book_quantity_before to validate net adjustment impact and reconcile inventory positions."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_replenishment_performance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Measures the efficiency, fulfillment accuracy, and urgency profile of warehouse replenishment orders. Used by warehouse managers and supply chain planners to monitor replenishment cycle times, fulfillment rates, stockout risk, and the effectiveness of min/max and kanban replenishment strategies."
  source: "`manufacturing_ecm`.`inventory`.`replenishment_order`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code associated with the replenishment order. Enables multi-plant replenishment performance benchmarking."
    - name: "trigger_type"
      expr: trigger_type
      comment: "Mechanism that initiated the replenishment (min/max, kanban, manual, demand-driven). Used to assess the effectiveness of different replenishment triggering strategies."
    - name: "replenishment_method"
      expr: replenishment_method
      comment: "Replenishment strategy applied (fixed quantity, fixed cycle, two-bin, kanban, wave-pick). Enables method-level performance analysis."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the replenishment order (open, in-progress, completed, cancelled, on-hold). Used to monitor execution pipeline and identify bottlenecks."
    - name: "priority"
      expr: priority
      comment: "Business priority level of the replenishment order (critical, high, normal, low). Used to assess the urgency profile of the replenishment backlog."
    - name: "abc_classification"
      expr: abc_classification
      comment: "ABC classification of the SKU being replenished. Enables value-tier analysis of replenishment performance — A-class stockouts carry the highest business impact."
    - name: "destination_location_type"
      expr: destination_location_type
      comment: "Classification of the destination location (pick face, kanban lane, production staging). Supports analytics on replenishment demand by location type."
    - name: "source_location_type"
      expr: source_location_type
      comment: "Classification of the source location (bulk storage, reserve, external). Used for operational routing and replenishment flow pattern analysis."
    - name: "is_urgent"
      expr: is_urgent
      comment: "Flag indicating whether the replenishment was escalated as urgent. Used to measure the frequency of stockout-driven emergency replenishments."
    - name: "is_partial_allowed"
      expr: is_partial_allowed
      comment: "Indicates whether partial fulfillment is acceptable. Used to assess flexibility in replenishment fulfillment policies."
    - name: "requested_timestamp"
      expr: requested_timestamp
      comment: "Date and time the replenishment order was created. Primary time dimension for replenishment volume trending and lead time analysis."
    - name: "completed_timestamp"
      expr: completed_timestamp
      comment: "Date and time the replenishment was completed. Used alongside requested_timestamp to calculate replenishment cycle time."
  measures:
    - name: "total_replenishment_orders"
      expr: COUNT(1)
      comment: "Total number of replenishment orders. Baseline volume metric for assessing replenishment program activity and identifying demand spikes."
    - name: "completed_replenishment_orders"
      expr: COUNT(CASE WHEN status = 'completed' THEN 1 END)
      comment: "Number of replenishment orders successfully completed. Used to calculate completion rate and assess warehouse execution effectiveness."
    - name: "urgent_replenishment_orders"
      expr: COUNT(CASE WHEN is_urgent = TRUE THEN 1 END)
      comment: "Number of replenishment orders escalated as urgent. High values indicate systemic stockout risk at pick locations — a leading indicator of service level failures."
    - name: "cancelled_replenishment_orders"
      expr: COUNT(CASE WHEN status = 'cancelled' THEN 1 END)
      comment: "Number of cancelled replenishment orders. High cancellation rates indicate triggering logic issues or source location availability problems."
    - name: "total_requested_quantity"
      expr: SUM(CAST(requested_quantity AS DOUBLE))
      comment: "Total quantity requested across all replenishment orders. Measures the aggregate replenishment demand volume for capacity and resource planning."
    - name: "total_confirmed_quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total quantity confirmed as available for replenishment. Compared against requested quantity to measure source availability and fulfillment feasibility."
    - name: "total_actual_quantity"
      expr: SUM(CAST(actual_quantity AS DOUBLE))
      comment: "Total quantity actually moved and confirmed at destination. Compared against requested and confirmed quantities to measure fulfillment accuracy."
    - name: "avg_destination_on_hand_at_trigger"
      expr: AVG(CAST(destination_on_hand_quantity AS DOUBLE))
      comment: "Average on-hand quantity at the destination location when the replenishment was triggered. Low values indicate replenishment is being triggered close to or at stockout — signals need to review reorder points."
    - name: "avg_source_on_hand_at_trigger"
      expr: AVG(CAST(source_on_hand_quantity AS DOUBLE))
      comment: "Average on-hand quantity at the source location when the replenishment was triggered. Low values indicate source location availability risk and potential for replenishment failures."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_reorder_policy_health`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Assesses the configuration quality and coverage of inventory reorder policies across SKUs and plants. Used by inventory planners and supply chain managers to ensure replenishment parameters are correctly calibrated, reviewed, and aligned with demand variability and service level targets."
  source: "`manufacturing_ecm`.`inventory`.`reorder_policy`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where the reorder policy is in effect. Enables plant-level policy coverage and parameter quality analysis."
    - name: "mrp_type"
      expr: mrp_type
      comment: "Replenishment planning method (reorder point, MRP, consumption-based, Kanban, VMI). Used to assess the distribution of planning strategies across the SKU portfolio."
    - name: "abc_classification"
      expr: abc_classification
      comment: "ABC classification of the SKU. Enables differentiated policy quality analysis by value tier — A-class items require the most precise parameter calibration."
    - name: "xyz_classification"
      expr: xyz_classification
      comment: "XYZ demand variability classification (X=stable, Y=variable, Z=sporadic). Used in conjunction with ABC to assess safety stock adequacy for demand variability profiles."
    - name: "material_type"
      expr: material_type
      comment: "Material category (raw material, WIP, finished good, MRO, packaging). Enables policy analysis by material type and applicable replenishment rules."
    - name: "lot_sizing_procedure"
      expr: lot_sizing_procedure
      comment: "Lot sizing method (EOQ, fixed lot, period lot, lot-for-lot). Used to assess the distribution of lot sizing strategies and their cost optimization implications."
    - name: "policy_status"
      expr: policy_status
      comment: "Operational status of the reorder policy (active, inactive, suspended, obsolete). Used to ensure only active policies are driving replenishment decisions."
    - name: "procurement_type"
      expr: procurement_type
      comment: "Procurement strategy (external, in-house, both). Drives MRP planning logic and replenishment source determination."
    - name: "seasonal_policy_flag"
      expr: seasonal_policy_flag
      comment: "Indicates whether the policy incorporates seasonal demand adjustments. Used to identify SKUs with time-varying replenishment parameters."
    - name: "effective_date"
      expr: effective_date
      comment: "Date from which the policy is active. Used to track policy lifecycle and identify stale or expired policies."
    - name: "last_reviewed_date"
      expr: last_reviewed_date
      comment: "Date the policy was last formally reviewed. Used to identify overdue policy reviews and ensure parameters remain current."
  measures:
    - name: "total_active_policies"
      expr: COUNT(CASE WHEN policy_status = 'active' THEN 1 END)
      comment: "Number of active reorder policies. Measures the coverage of automated replenishment governance across the SKU portfolio."
    - name: "total_policies"
      expr: COUNT(1)
      comment: "Total number of reorder policy records. Baseline for calculating active policy rate and assessing overall policy portfolio size."
    - name: "avg_safety_stock_qty"
      expr: AVG(CAST(safety_stock_qty AS DOUBLE))
      comment: "Average safety stock quantity across policies. Benchmarks buffer stock levels and identifies categories where safety stock may be under- or over-provisioned."
    - name: "avg_reorder_point_qty"
      expr: AVG(CAST(reorder_point_qty AS DOUBLE))
      comment: "Average reorder point quantity across policies. Used to assess whether replenishment triggers are calibrated appropriately relative to lead times and demand."
    - name: "avg_service_level_target_pct"
      expr: AVG(CAST(service_level_target_pct AS DOUBLE))
      comment: "Average target service level across policies. Measures the aggregate service level ambition of the replenishment program and its alignment with customer commitments."
    - name: "avg_economic_order_qty"
      expr: AVG(CAST(economic_order_qty AS DOUBLE))
      comment: "Average Economic Order Quantity across policies. Used to assess the cost optimization of replenishment order sizing across the SKU portfolio."
    - name: "avg_holding_cost_rate_pct"
      expr: AVG(CAST(holding_cost_rate_pct AS DOUBLE))
      comment: "Average annual inventory holding cost rate across policies. Measures the cost of carrying inventory and informs EOQ and safety stock optimization decisions."
    - name: "total_ordering_cost"
      expr: SUM(CAST(ordering_cost_amount AS DOUBLE))
      comment: "Total ordering cost across all reorder policies. Represents the aggregate transaction cost of the replenishment program and is a key input to EOQ optimization."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_inventory_transaction`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Tracks the volume, financial value, and movement patterns of all inventory transactions (goods receipts, goods issues, transfers, scrapping, adjustments). Used by supply chain, finance, and operations teams to monitor inventory flow, COGS, and movement type distribution."
  source: "`manufacturing_ecm`.`inventory`.`transaction`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where the inventory transaction occurred. Primary organizational dimension for multi-plant inventory flow analysis."
    - name: "movement_category"
      expr: movement_category
      comment: "High-level business classification of the movement (goods_receipt, goods_issue, transfer, scrapping, adjustment). Enables simplified reporting without requiring movement type code knowledge."
    - name: "movement_type_code"
      expr: movement_type_code
      comment: "SAP MM movement type code (e.g., 101=GR against PO, 261=GI to production, 551=scrapping). Provides granular movement classification for detailed inventory flow analysis."
    - name: "stock_type"
      expr: stock_type
      comment: "Stock category at time of transaction (unrestricted, quality_inspection, blocked, in_transit). Enables analysis of inventory flow by usability status."
    - name: "company_code"
      expr: company_code
      comment: "SAP company code of the legal entity for the transaction. Required for multi-entity financial reporting and intercompany reconciliation."
    - name: "reference_document_type"
      expr: reference_document_type
      comment: "Type of business document that triggered the transaction (purchase_order, production_order, sales_order). Enables cross-domain traceability and process-level volume analysis."
    - name: "valuation_type"
      expr: valuation_type
      comment: "Inventory valuation method applied to the transaction (standard_price, moving_average_price). Determines how cost variances are handled in financial accounting."
    - name: "posting_date"
      expr: posting_date
      comment: "Accounting posting date of the transaction. Primary time dimension for period-level inventory flow and financial reporting."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the transaction location. Supports multi-country regulatory compliance and geographic inventory analytics."
    - name: "reversal_indicator"
      expr: reversal_indicator
      comment: "Indicates whether the transaction is a reversal. Used to calculate net (non-reversed) transaction volumes and values."
    - name: "special_stock_indicator"
      expr: special_stock_indicator
      comment: "SAP special stock indicator (sales order stock, consignment, project stock). Used to segment standard own stock movements from special stock transactions."
  measures:
    - name: "total_transactions"
      expr: COUNT(1)
      comment: "Total number of inventory movement transactions. Baseline volume metric for assessing inventory activity levels and identifying unusual movement spikes."
    - name: "net_transactions"
      expr: COUNT(CASE WHEN reversal_indicator = FALSE OR reversal_indicator IS NULL THEN 1 END)
      comment: "Number of non-reversed inventory transactions. Measures the volume of valid, active inventory movements excluding cancellations."
    - name: "total_valuation_amount"
      expr: SUM(CAST(valuation_amount AS DOUBLE))
      comment: "Total monetary value of all inventory movements. Measures the aggregate financial flow through inventory — a key input to COGS calculation and inventory turnover analysis."
    - name: "total_quantity_moved"
      expr: SUM(CAST(quantity AS DOUBLE))
      comment: "Net aggregate quantity moved across all transactions. Positive values indicate net stock increases; negative values indicate net stock decreases. Used for inventory flow and balance analysis."
    - name: "avg_valuation_price_per_unit"
      expr: AVG(CAST(valuation_price_per_unit AS DOUBLE))
      comment: "Average unit valuation price across all transactions. Tracks cost trends and identifies materials with significant price movements requiring standard cost review."
    - name: "reversal_transactions"
      expr: COUNT(CASE WHEN reversal_indicator = TRUE THEN 1 END)
      comment: "Number of reversal transactions. High reversal rates indicate posting errors or process issues in inventory management — a data quality and process control KPI."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_wip_stock`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Tracks Work-In-Progress inventory value, quantity, and aging at the production order and operation level. Used by manufacturing finance, production control, and supply chain teams to monitor WIP balance sheet exposure, production order completion rates, and WIP aging risk."
  source: "`manufacturing_ecm`.`inventory`.`wip_stock`"
  dimensions:
    - name: "plant_code"
      expr: plant_code
      comment: "SAP plant code where WIP stock resides. Primary organizational dimension for multi-plant WIP reporting and valuation."
    - name: "company_code"
      expr: company_code
      comment: "SAP company code of the legal entity responsible for the production order. Required for legal entity-level WIP balance sheet reporting."
    - name: "status"
      expr: status
      comment: "Current status of the WIP stock record (open, partially_confirmed, fully_confirmed). Used to segment active WIP from completed or settled orders."
    - name: "production_order_type"
      expr: production_order_type
      comment: "SAP order type (PP01 standard, PP02 repetitive, PI01 process). Drives cost collection and settlement rules for WIP valuation."
    - name: "make_to_strategy"
      expr: make_to_strategy
      comment: "Manufacturing strategy (MTO, MTS, ETO, ATO). Determines how WIP is linked to customer demand and its urgency for completion."
    - name: "abc_classification"
      expr: abc_classification
      comment: "ABC classification of the material being produced. Enables value-tier analysis of WIP holdings — A-class WIP represents the highest balance sheet exposure."
    - name: "valuation_method"
      expr: valuation_method
      comment: "Inventory valuation method applied to WIP (standard cost, moving average, actual cost). Determines how WIP is valued on the balance sheet."
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of the WIP record. Enables year-over-year WIP balance trending and annual closing analysis."
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period of the WIP record. Enables period-end WIP balance sheet posting and month-over-month WIP trending."
    - name: "production_start_date"
      expr: production_start_date
      comment: "Scheduled or actual start date of the production order. Used for WIP aging analysis — long-running orders with high WIP values represent balance sheet risk."
    - name: "expected_completion_date"
      expr: expected_completion_date
      comment: "Expected date for WIP conversion to finished goods. Used to assess delivery commitment risk and ATP calculations."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the plant. Supports multi-country WIP reporting and regulatory compliance."
    - name: "local_currency_code"
      expr: local_currency_code
      comment: "Local currency code for WIP valuation. Required for multi-currency financial reporting across global plants."
  measures:
    - name: "total_wip_value_local_currency"
      expr: SUM(CAST(wip_value_local_currency AS DOUBLE))
      comment: "Total WIP inventory value in local currency. Primary balance sheet KPI for WIP asset reporting and period-end financial closing. High values relative to finished goods output indicate production bottlenecks."
    - name: "total_wip_value_group_currency"
      expr: SUM(CAST(wip_value_group_currency AS DOUBLE))
      comment: "Total WIP value in group reporting currency. Enables consolidated group-level WIP balance sheet reporting across multinational manufacturing operations."
    - name: "total_wip_quantity"
      expr: SUM(CAST(wip_quantity AS DOUBLE))
      comment: "Total quantity of material currently in progress across all production orders and operations. Measures the volume of in-process inventory and production pipeline depth."
    - name: "total_confirmed_quantity"
      expr: SUM(CAST(confirmed_quantity AS DOUBLE))
      comment: "Total quantity confirmed as completed across production orders. Used alongside order_quantity to calculate aggregate production completion rate."
    - name: "total_order_quantity"
      expr: SUM(CAST(order_quantity AS DOUBLE))
      comment: "Total planned production order quantity. Denominator for production completion rate calculations and WIP coverage analysis."
    - name: "total_scrap_quantity"
      expr: SUM(CAST(scrap_quantity AS DOUBLE))
      comment: "Total quantity scrapped during production. Measures in-process quality losses and their impact on WIP valuation and production yield."
    - name: "avg_wip_value_per_order"
      expr: AVG(CAST(wip_value_local_currency AS DOUBLE))
      comment: "Average WIP value per production order record. Benchmarks the typical WIP exposure per order and identifies high-value outliers requiring priority completion."
    - name: "open_production_orders"
      expr: COUNT(CASE WHEN status IN ('open', 'partially_confirmed') THEN 1 END)
      comment: "Number of production orders with open or partially confirmed WIP. Measures the active production pipeline and identifies the backlog of orders requiring completion to release WIP to finished goods."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`inventory_stock_transfer`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Tracks the volume, financial value, and execution performance of inter-plant, inter-warehouse, and storage location stock transfers. Used by supply chain, logistics, and finance teams to monitor transfer cycle times, fulfillment accuracy, intercompany transfer compliance, and in-transit inventory exposure."
  source: "`manufacturing_ecm`.`inventory`.`stock_transfer`"
  dimensions:
    - name: "source_plant_code"
      expr: source_plant_code
      comment: "Originating plant code for the stock transfer. Used to identify the source of inter-plant inventory movements and assess outbound transfer volumes by plant."
    - name: "destination_plant_code"
      expr: destination_plant_code
      comment: "Receiving plant code for the stock transfer. Used to identify inbound transfer volumes and assess destination plant replenishment patterns."
    - name: "transfer_type"
      expr: transfer_type
      comment: "Classification of the transfer (plant-to-plant, warehouse-to-warehouse, storage location transfer, STO). Drives process routing and document flow analysis."
    - name: "transfer_reason_code"
      expr: transfer_reason_code
      comment: "Business reason code for the transfer. Used for demand classification, cost allocation, and understanding the drivers of inter-plant stock movements."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the transfer order (created, in-transit, received, cancelled). Used to monitor execution pipeline and identify stalled transfers."
    - name: "stock_type"
      expr: stock_type
      comment: "Stock category being transferred (unrestricted, quality inspection, blocked, in-transit). Determines inventory availability impact at source and destination."
    - name: "is_cross_border"
      expr: is_cross_border
      comment: "Indicates whether the transfer crosses international borders. Cross-border transfers require customs documentation and trade compliance — used to segment compliance-sensitive movements."
    - name: "is_intercompany"
      expr: is_intercompany
      comment: "Indicates whether the transfer crosses legal entity boundaries. Intercompany transfers require transfer pricing compliance and consolidated financial elimination entries."
    - name: "company_code"
      expr: company_code
      comment: "SAP company code of the issuing legal entity. Required for legal entity-level financial reporting and intercompany reconciliation."
    - name: "planned_transfer_date"
      expr: planned_transfer_date
      comment: "Scheduled date for the goods issue from source. Primary time dimension for transfer volume trending and schedule adherence analysis."
    - name: "actual_goods_issue_date"
      expr: actual_goods_issue_date
      comment: "Actual date goods were issued from source. Used alongside planned_transfer_date to measure transfer schedule adherence."
    - name: "actual_goods_receipt_date"
      expr: actual_goods_receipt_date
      comment: "Actual date goods were received at destination. Used to calculate actual transit time and measure delivery performance."
    - name: "priority"
      expr: priority
      comment: "Business priority of the transfer order (urgent, high, normal, low). Used to assess the urgency profile of the transfer backlog."
  measures:
    - name: "total_transfer_orders"
      expr: COUNT(1)
      comment: "Total number of stock transfer orders. Baseline volume metric for assessing inter-plant and inter-warehouse inventory movement activity."
    - name: "completed_transfer_orders"
      expr: COUNT(CASE WHEN status IN ('received', 'completed') THEN 1 END)
      comment: "Number of transfer orders successfully completed with goods receipt confirmed at destination. Used to calculate transfer completion rate."
    - name: "in_transit_transfer_orders"
      expr: COUNT(CASE WHEN status = 'in_transit' THEN 1 END)
      comment: "Number of transfer orders currently in transit. Measures the volume of in-transit inventory and associated financial exposure on the balance sheet."
    - name: "total_transfer_value"
      expr: SUM(CAST(transfer_value AS DOUBLE))
      comment: "Total monetary value of stock transfers. Measures the aggregate financial flow of inventory between locations — critical for intercompany billing, transfer pricing compliance, and in-transit inventory valuation."
    - name: "total_transfer_quantity"
      expr: SUM(CAST(transfer_quantity AS DOUBLE))
      comment: "Total planned transfer quantity across all orders. Measures the aggregate volume of inventory planned for inter-location movement."
    - name: "total_issued_quantity"
      expr: SUM(CAST(issued_quantity AS DOUBLE))
      comment: "Total quantity physically issued from source locations. Compared against transfer_quantity to measure goods issue fulfillment rate."
    - name: "total_received_quantity"
      expr: SUM(CAST(received_quantity AS DOUBLE))
      comment: "Total quantity confirmed as received at destination. Compared against issued_quantity to identify transfer losses or discrepancies in transit."
    - name: "intercompany_transfer_orders"
      expr: COUNT(CASE WHEN is_intercompany = TRUE THEN 1 END)
      comment: "Number of intercompany stock transfers. Measures the volume of cross-entity movements requiring transfer pricing compliance and consolidated financial elimination."
    - name: "cross_border_transfer_orders"
      expr: COUNT(CASE WHEN is_cross_border = TRUE THEN 1 END)
      comment: "Number of cross-border stock transfers. Measures the volume of movements requiring customs documentation and trade compliance — a regulatory risk exposure indicator."
$$;