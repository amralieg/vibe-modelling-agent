-- Metric views for domain: product | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 09:35:49

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_aftermarket_part`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic KPIs for the aftermarket spare parts catalog — covering catalog health, pricing economics, compliance posture, and service reliability. Used by aftermarket business leaders, service operations, and compliance teams to steer parts portfolio decisions."
  source: "`manufacturing_ecm`.`product`.`aftermarket_part`"
  dimensions:
    - name: "part_type"
      expr: part_type
      comment: "Commercial and functional role of the part (OEM spare, consumable, wear part, repair kit, exchange unit, upgrade kit). Primary segmentation axis for aftermarket portfolio analysis."
    - name: "status"
      expr: status
      comment: "Lifecycle status of the part (active, phase_out, discontinued, superseded, development, blocked). Drives catalog hygiene and end-of-life planning."
    - name: "stocking_classification"
      expr: stocking_classification
      comment: "Inventory stocking strategy (critical spare, standard, non-stock, consignment, slow-moving). Key dimension for service availability and working capital analysis."
    - name: "service_channel"
      expr: service_channel
      comment: "Commercial distribution channel (direct service, distributor, ecommerce, field service, depot repair). Enables channel-level margin and availability analysis."
    - name: "country_of_origin"
      expr: country_of_origin
      comment: "ISO 3166-1 alpha-3 country of manufacture. Used for trade compliance, tariff analysis, and supply chain risk segmentation."
    - name: "material_group"
      expr: material_group
      comment: "SAP material group code. Supports procurement spend analytics and category management for aftermarket parts."
    - name: "is_hazardous"
      expr: is_hazardous
      comment: "Flags parts classified as hazardous materials. Used to segment compliance obligations and logistics cost exposure."
    - name: "rohs_compliant"
      expr: rohs_compliant
      comment: "RoHS compliance flag. Critical for EU market access eligibility analysis across the aftermarket catalog."
    - name: "ce_marked"
      expr: ce_marked
      comment: "CE marking status. Required for sale in the European Economic Area; used to assess EU market readiness of the parts portfolio."
    - name: "lifecycle_start_date"
      expr: DATE_TRUNC('MONTH', lifecycle_start_date)
      comment: "Month of commercial availability start. Enables cohort analysis of parts introduced over time."
    - name: "lifecycle_end_date"
      expr: DATE_TRUNC('MONTH', lifecycle_end_date)
      comment: "Month of planned discontinuation. Used for end-of-life pipeline planning and last-time-buy scheduling."
  measures:
    - name: "active_parts_count"
      expr: COUNT(CASE WHEN status = 'active' THEN aftermarket_part_id END)
      comment: "Number of commercially active aftermarket parts available for ordering. Core catalog health KPI — a declining count signals portfolio contraction or lifecycle management issues."
    - name: "avg_list_price"
      expr: AVG(CAST(list_price AS DOUBLE))
      comment: "Average list price across aftermarket parts in scope. Tracks pricing level trends and supports channel pricing strategy reviews."
    - name: "avg_standard_cost"
      expr: AVG(CAST(standard_cost AS DOUBLE))
      comment: "Average standard cost across aftermarket parts. Used alongside avg_list_price to monitor gross margin positioning at the portfolio level."
    - name: "avg_gross_margin_pct_numerator"
      expr: SUM(CAST(list_price AS DOUBLE) - CAST(standard_cost AS DOUBLE))
      comment: "Sum of (list_price minus standard_cost) across parts — numerator for gross margin percentage calculation. Combine with sum_list_price in BI to derive portfolio gross margin %."
    - name: "sum_list_price"
      expr: SUM(CAST(list_price AS DOUBLE))
      comment: "Total list price value of the parts catalog in scope. Denominator for gross margin % and a proxy for catalog revenue potential."
    - name: "avg_lead_time_days"
      expr: AVG(CAST(lead_time_days AS DOUBLE))
      comment: "Average procurement/manufacturing lead time in days. A rising average signals supply chain risk and impacts service order scheduling and ATP commitments."
    - name: "avg_mtbr_hours"
      expr: AVG(CAST(mean_time_between_replacements_hours AS DOUBLE))
      comment: "Average Mean Time Between Replacements in operating hours. Drives preventive maintenance scheduling and spare parts demand forecasting accuracy."
    - name: "hazardous_parts_count"
      expr: COUNT(CASE WHEN is_hazardous = TRUE THEN aftermarket_part_id END)
      comment: "Number of hazardous material parts in the catalog. Quantifies compliance and logistics cost exposure from dangerous goods handling requirements."
    - name: "non_rohs_compliant_parts_count"
      expr: COUNT(CASE WHEN rohs_compliant = FALSE THEN aftermarket_part_id END)
      comment: "Number of parts not RoHS compliant. Directly measures EU market access risk — any non-zero value in active parts requires immediate compliance remediation."
    - name: "critical_spare_parts_count"
      expr: COUNT(CASE WHEN stocking_classification = 'critical_spare' THEN aftermarket_part_id END)
      comment: "Number of parts classified as critical spares. Executives use this to assess unplanned downtime risk exposure and validate safety stock investment levels."
    - name: "phase_out_parts_count"
      expr: COUNT(CASE WHEN status = 'phase_out' THEN aftermarket_part_id END)
      comment: "Number of parts currently in phase-out status. Signals the volume of end-of-life transitions requiring customer notification and inventory drawdown management."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_regulatory_certification`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Compliance portfolio KPIs tracking the health, coverage, cost, and renewal pipeline of product regulatory certifications (CE, UL, RoHS, REACH, CCC, EAC). Used by Regulatory Affairs, Product Compliance, and executive leadership to manage market access risk and compliance investment."
  source: "`manufacturing_ecm`.`product`.`regulatory_certification`"
  dimensions:
    - name: "certification_type"
      expr: certification_type
      comment: "Type of regulatory certification (CE Marking, UL Listing, CCC, EAC, RoHS, REACH). Primary segmentation for compliance portfolio analysis."
    - name: "status"
      expr: status
      comment: "Lifecycle status of the certification (Valid, Expired, Under Renewal, Suspended, Withdrawn, Pending Initial). Core dimension for market access risk assessment."
    - name: "issuing_body"
      expr: issuing_body
      comment: "Certification body that issued the certificate (TÜV, UL, Bureau Veritas, SGS, etc.). Used to analyze certification body concentration and audit workload."
    - name: "scope_level"
      expr: scope_level
      comment: "Breadth of certification coverage (SKU, product family, product line, platform, component). Determines how many products are protected by each certificate."
    - name: "certification_cost_currency"
      expr: certification_cost_currency
      comment: "Currency of certification cost. Required for multi-currency compliance budget reporting."
    - name: "country_of_manufacture"
      expr: country_of_manufacture
      comment: "Manufacturing country of the certified product. Some certifications are site-specific; this dimension supports site-level compliance tracking."
    - name: "responsible_org_unit"
      expr: responsible_org_unit
      comment: "Business unit responsible for the certification. Enables accountability reporting and compliance workload distribution analysis."
    - name: "surveillance_audit_required"
      expr: surveillance_audit_required
      comment: "Whether periodic surveillance audits are required. Segments certifications by ongoing maintenance burden."
    - name: "issue_date_month"
      expr: DATE_TRUNC('MONTH', issue_date)
      comment: "Month of certificate issuance. Enables trend analysis of new certifications obtained over time."
    - name: "expiry_date_month"
      expr: DATE_TRUNC('MONTH', expiry_date)
      comment: "Month of certificate expiry. Used to build the renewal pipeline calendar and prevent market access lapses."
  measures:
    - name: "valid_certifications_count"
      expr: COUNT(CASE WHEN status = 'Valid' THEN regulatory_certification_id END)
      comment: "Number of currently valid regulatory certifications. The primary market access health KPI — a decline signals growing compliance gaps that block product shipments."
    - name: "expired_certifications_count"
      expr: COUNT(CASE WHEN status = 'Expired' THEN regulatory_certification_id END)
      comment: "Number of expired certifications. Each expired certificate represents a potential market access blockage and regulatory non-compliance risk."
    - name: "expiring_within_90_days_count"
      expr: COUNT(CASE WHEN expiry_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 90) THEN regulatory_certification_id END)
      comment: "Certifications expiring within the next 90 days. Critical leading indicator for renewal pipeline management — prevents unplanned market access lapses."
    - name: "under_renewal_count"
      expr: COUNT(CASE WHEN status = 'Under Renewal' THEN regulatory_certification_id END)
      comment: "Number of certifications currently in the renewal process. Tracks renewal pipeline volume and workload for the Regulatory Affairs team."
    - name: "total_certification_cost"
      expr: SUM(CAST(certification_cost AS DOUBLE))
      comment: "Total spend on regulatory certifications in scope. Core compliance OPEX KPI used in budget planning and cost-per-market-access analysis."
    - name: "avg_certification_cost"
      expr: AVG(CAST(certification_cost AS DOUBLE))
      comment: "Average cost per regulatory certification. Benchmarks certification efficiency and supports make-vs-buy decisions for compliance testing."
    - name: "reach_svhc_products_count"
      expr: COUNT(CASE WHEN reach_svhc_flag = TRUE THEN regulatory_certification_id END)
      comment: "Number of certified products containing REACH SVHCs above 0.1% w/w threshold. Quantifies mandatory customer notification obligations under REACH Article 33."
    - name: "suspended_or_withdrawn_count"
      expr: COUNT(CASE WHEN status IN ('Suspended', 'Withdrawn') THEN regulatory_certification_id END)
      comment: "Number of certifications suspended or withdrawn by the issuing body. Represents active market access blockages requiring immediate executive escalation."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_hazardous_substance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Chemical compliance KPIs tracking hazardous substance concentrations, threshold exceedances, SVHC exposure, and regulatory declaration status across the product catalog. Used by Product Compliance, Regulatory Affairs, and Supply Chain to manage RoHS, REACH, and Prop 65 obligations."
  source: "`manufacturing_ecm`.`product`.`hazardous_substance`"
  dimensions:
    - name: "applicable_regulation"
      expr: applicable_regulation
      comment: "Regulatory framework governing the substance (RoHS, REACH SVHC, California Prop 65, TSCA). Primary segmentation for compliance program analysis."
    - name: "compliance_status"
      expr: compliance_status
      comment: "Current compliance status of the substance record. Drives product release decisions and corrective action prioritization."
    - name: "substance_category"
      expr: substance_category
      comment: "Chemical category (heavy metal, halogen, phthalate, SVHC). Supports risk prioritization and substitution program management."
    - name: "declaration_type"
      expr: declaration_type
      comment: "Type of compliance declaration (exemption, substitution, declaration of conformity, disclosure). Tracks the compliance resolution approach across the portfolio."
    - name: "data_source_type"
      expr: data_source_type
      comment: "Origin of substance data (lab test, supplier declaration, internal analysis). Indicates data reliability and audit readiness."
    - name: "ghs_hazard_class"
      expr: ghs_hazard_class
      comment: "GHS hazard classification of the substance. Used to assess safety risk profile and SDS/labeling obligations."
    - name: "country_of_applicability"
      expr: country_of_applicability
      comment: "Country jurisdiction for the substance regulation. Supports multi-jurisdictional compliance management."
    - name: "declaration_date_month"
      expr: DATE_TRUNC('MONTH', declaration_date)
      comment: "Month of compliance declaration. Enables trend analysis of declaration activity and regulatory submission timelines."
    - name: "review_due_date_month"
      expr: DATE_TRUNC('MONTH', review_due_date)
      comment: "Month when substance records are due for review. Used to build the compliance review calendar and prevent stale declarations."
  measures:
    - name: "threshold_exceedance_count"
      expr: COUNT(CASE WHEN exceeds_threshold = TRUE THEN hazardous_substance_id END)
      comment: "Number of substance records where measured concentration exceeds the regulatory threshold. Each exceedance is a potential non-compliance event requiring corrective action or exemption documentation."
    - name: "svhc_substance_count"
      expr: COUNT(CASE WHEN svhc_flag = TRUE THEN hazardous_substance_id END)
      comment: "Number of REACH SVHC substance records. Quantifies mandatory disclosure obligations under REACH Article 33 — a key metric for supply chain transparency and customer communication."
    - name: "avg_concentration_ppm"
      expr: AVG(CAST(concentration_ppm AS DOUBLE))
      comment: "Average measured substance concentration in PPM across records in scope. Tracks overall chemical risk level and monitors trends against regulatory thresholds."
    - name: "max_concentration_ppm"
      expr: MAX(CAST(concentration_ppm AS DOUBLE))
      comment: "Maximum substance concentration in PPM observed in scope. Identifies worst-case compliance exposure and prioritizes remediation focus."
    - name: "avg_threshold_limit_ppm"
      expr: AVG(CAST(threshold_limit_ppm AS DOUBLE))
      comment: "Average regulatory threshold limit in PPM across substance records. Provides context for interpreting concentration levels relative to regulatory limits."
    - name: "prop65_listed_count"
      expr: COUNT(CASE WHEN prop65_listed_flag = TRUE THEN hazardous_substance_id END)
      comment: "Number of California Prop 65 listed substance records. Quantifies warning label obligations for products sold in California — a direct market access and litigation risk indicator."
    - name: "rohs_restricted_substance_count"
      expr: COUNT(CASE WHEN rohs_restricted_flag = TRUE THEN hazardous_substance_id END)
      comment: "Number of RoHS-restricted substance records across the product catalog. Measures the breadth of RoHS compliance obligations and remediation workload."
    - name: "overdue_review_count"
      expr: COUNT(CASE WHEN review_due_date < CURRENT_DATE THEN hazardous_substance_id END)
      comment: "Number of substance records past their scheduled review date. Stale compliance records create regulatory audit risk — this KPI drives compliance calendar management."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_price_list_item`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Pricing portfolio KPIs covering price level, floor price discipline, margin guardrails, volume pricing structure, and pricing governance. Used by Pricing Management, Commercial Finance, and Sales Operations to steer pricing strategy and protect margin."
  source: "`manufacturing_ecm`.`product`.`price_list_item`"
  dimensions:
    - name: "price_type"
      expr: price_type
      comment: "Commercial role of the price record (list_price, floor_price, rrp, transfer_price, contract_price, promotional_price). Primary segmentation for pricing portfolio analysis."
    - name: "status"
      expr: status
      comment: "Lifecycle status of the price list item (active, inactive, pending_approval, superseded, expired, draft). Used to assess pricing catalog health and governance compliance."
    - name: "currency_code"
      expr: currency_code
      comment: "ISO 4217 currency code. Enables multi-currency pricing analysis across global sales organizations."
    - name: "sales_org_code"
      expr: sales_org_code
      comment: "Sales organization code. Supports regional pricing strategy comparison and multi-entity pricing governance."
    - name: "distribution_channel_code"
      expr: distribution_channel_code
      comment: "Distribution channel (direct, distributor, OEM, e-commerce). Enables channel-specific pricing strategy analysis."
    - name: "country_code"
      expr: country_code
      comment: "Country for which the price applies. Supports country-level pricing competitiveness and compliance analysis."
    - name: "calculation_type"
      expr: calculation_type
      comment: "Price calculation method (fixed_amount, percentage, quantity_dependent, formula, free_goods). Tracks pricing complexity and CPQ configuration requirements."
    - name: "scale_type"
      expr: scale_type
      comment: "Volume pricing scale type (graduated, base_scale, group_scale, none). Used to analyze the prevalence and structure of volume discount programs."
    - name: "cpq_eligible"
      expr: cpq_eligible
      comment: "Whether the item is available in CPQ. Measures CPQ catalog coverage — low coverage limits configure-price-quote automation."
    - name: "effective_date_month"
      expr: DATE_TRUNC('MONTH', effective_date)
      comment: "Month the price became effective. Enables trend analysis of pricing changes and price increase cadence."
    - name: "expiry_date_month"
      expr: DATE_TRUNC('MONTH', expiry_date)
      comment: "Month the price expires. Used to manage pricing renewal pipeline and prevent order pricing failures."
  measures:
    - name: "avg_unit_price"
      expr: AVG(CAST(unit_price AS DOUBLE))
      comment: "Average list unit price across price list items in scope. Tracks overall price level trends and supports pricing strategy reviews."
    - name: "avg_floor_price"
      expr: AVG(CAST(floor_price AS DOUBLE))
      comment: "Average floor price (minimum permissible selling price) across items. Used to assess the margin guardrail level and discount headroom available to sales."
    - name: "avg_rrp"
      expr: AVG(CAST(rrp AS DOUBLE))
      comment: "Average Recommended Retail Price across items. Benchmarks channel resale pricing and supports distributor margin analysis."
    - name: "avg_price_to_floor_spread"
      expr: AVG(CAST(unit_price AS DOUBLE) - CAST(floor_price AS DOUBLE))
      comment: "Average spread between list price and floor price. Measures the discount headroom available to sales — a narrowing spread signals margin compression risk."
    - name: "sum_surcharge_amount"
      expr: SUM(CAST(surcharge_amount AS DOUBLE))
      comment: "Total absolute surcharge value across price list items. Quantifies surcharge revenue contribution (e.g., hazmat handling, small order fees) to the pricing portfolio."
    - name: "avg_surcharge_percent"
      expr: AVG(CAST(surcharge_percent AS DOUBLE))
      comment: "Average percentage surcharge/discount across items. Tracks the overall pricing adjustment level and monitors for excessive discounting patterns."
    - name: "active_price_items_count"
      expr: COUNT(CASE WHEN status = 'active' THEN price_list_item_id END)
      comment: "Number of active price list items. Measures the breadth of the active pricing catalog — gaps indicate products without valid pricing that cannot be ordered."
    - name: "expiring_prices_within_30_days_count"
      expr: COUNT(CASE WHEN expiry_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 30) THEN price_list_item_id END)
      comment: "Number of price list items expiring within 30 days. Leading indicator for pricing renewal urgency — expired prices cause order entry failures and revenue leakage."
    - name: "volume_priced_items_count"
      expr: COUNT(CASE WHEN scale_type != 'none' AND scale_type IS NOT NULL THEN price_list_item_id END)
      comment: "Number of items with volume-based pricing scales. Measures the breadth of volume discount programs — used to assess pricing complexity and CPQ configuration requirements."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_hierarchy`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Product portfolio structure KPIs tracking the health, coverage, and governance of the commercial product hierarchy. Used by Product Management, Portfolio Strategy, and Finance to assess catalog completeness, lifecycle stage distribution, and revenue reporting node coverage."
  source: "`manufacturing_ecm`.`product`.`hierarchy`"
  dimensions:
    - name: "level_type"
      expr: level_type
      comment: "Hierarchy depth label (Product Division, Product Family, Product Group, Product Line). Primary segmentation for portfolio structure analysis."
    - name: "status"
      expr: status
      comment: "Lifecycle status of the hierarchy node (active, obsolete, planned). Used to assess catalog health and identify stale or planned nodes."
    - name: "lifecycle_stage"
      expr: lifecycle_stage
      comment: "Portfolio lifecycle stage of the hierarchy node. Used in investment prioritization and discontinuation planning."
    - name: "division_code"
      expr: division_code
      comment: "Top-level product division code (AUT, ELC, SMI). Enables division-level portfolio analysis and revenue reporting."
    - name: "business_segment"
      expr: business_segment
      comment: "IFRS 8 / ASC 280 reportable business segment. Used for segment-level P&L and investor disclosure reporting."
    - name: "region_code"
      expr: region_code
      comment: "Geographic sales region (AMER, EMEA, APAC). Supports regional portfolio management and catalog segmentation."
    - name: "go_to_market_channel"
      expr: go_to_market_channel
      comment: "Primary GTM channel strategy for the hierarchy node. Informs channel pricing and partner management decisions."
    - name: "technology_platform"
      expr: technology_platform
      comment: "Underlying technology platform (TIA Portal, SIMATIC, SENTRON). Supports technology roadmap planning and R&D investment allocation."
    - name: "strategic_initiative"
      expr: strategic_initiative
      comment: "Corporate strategic initiative associated with the node (Digital Factory, Green Energy Transition, Smart Buildings). Enables portfolio-level strategic investment tracking."
    - name: "effective_date_year"
      expr: DATE_TRUNC('YEAR', effective_date)
      comment: "Year the hierarchy node became effective. Enables cohort analysis of portfolio expansion over time."
  measures:
    - name: "active_hierarchy_nodes_count"
      expr: COUNT(CASE WHEN status = 'active' THEN hierarchy_id END)
      comment: "Number of active product hierarchy nodes. Measures the breadth of the active commercial product portfolio — a key catalog health indicator for portfolio governance."
    - name: "leaf_nodes_count"
      expr: COUNT(CASE WHEN is_leaf_node = TRUE THEN hierarchy_id END)
      comment: "Number of leaf nodes (lowest-level product lines to which SKUs are assigned). Represents the actual product line count — the actionable portfolio depth."
    - name: "revenue_reporting_nodes_count"
      expr: COUNT(CASE WHEN is_revenue_reporting_node = TRUE THEN hierarchy_id END)
      comment: "Number of nodes designated as revenue reporting aggregation points. Measures P&L reporting coverage — gaps indicate product lines not captured in financial reporting."
    - name: "export_controlled_nodes_count"
      expr: COUNT(CASE WHEN export_control_flag = TRUE THEN hierarchy_id END)
      comment: "Number of hierarchy nodes subject to export control regulations. Quantifies the portfolio's export compliance exposure and trade screening workload."
    - name: "hazardous_material_nodes_count"
      expr: COUNT(CASE WHEN hazardous_material_flag = TRUE THEN hierarchy_id END)
      comment: "Number of hierarchy nodes involving hazardous materials. Measures the scope of REACH/RoHS compliance obligations across the product portfolio."
    - name: "obsolete_nodes_count"
      expr: COUNT(CASE WHEN status = 'obsolete' THEN hierarchy_id END)
      comment: "Number of obsolete hierarchy nodes retained for historical integrity. A growing count signals the need for catalog rationalization and governance cleanup."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_substitution`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Product substitution and supersession KPIs tracking the health, automation readiness, compliance risk, and lead time impact of the substitution catalog. Used by Supply Chain, Order Management, and Product Management to manage ATP/CTP fallback quality and EOL transition risk."
  source: "`manufacturing_ecm`.`product`.`substitution`"
  dimensions:
    - name: "type"
      expr: type
      comment: "Nature of the substitution relationship (superseded-by, equivalent, preferred-alternate, cross-reference, emergency-alternate). Primary segmentation for substitution portfolio analysis."
    - name: "status"
      expr: status
      comment: "Lifecycle status of the substitution record (draft, pending-approval, active, inactive, expired, superseded). Used to assess substitution catalog health and governance compliance."
    - name: "functional_equivalence_level"
      expr: functional_equivalence_level
      comment: "Degree of functional equivalence (full, partial, form-fit-function, dimensional-only, performance-limited). Critical for assessing substitution quality and customer impact risk."
    - name: "reason_code"
      expr: reason_code
      comment: "Standardized reason for the substitution (EOL replacement, cost reduction, performance upgrade, etc.). Enables analysis of substitution drivers and ECN traceability."
    - name: "direction"
      expr: direction
      comment: "Substitution directionality (one-way or bidirectional). Impacts ATP/CTP fallback logic and order management automation."
    - name: "application_scope"
      expr: application_scope
      comment: "Business processes where the substitution is applicable (order management, service, procurement, BOM). Enables process-specific substitution coverage analysis."
    - name: "is_auto_substitution_allowed"
      expr: is_auto_substitution_allowed
      comment: "Whether automatic substitution is permitted without manual approval. Measures the degree of order management automation enabled by the substitution catalog."
    - name: "regulatory_compliance_flag"
      expr: regulatory_compliance_flag
      comment: "Whether the substitution was driven by regulatory compliance requirements. Segments compliance-driven substitutions for RoHS/REACH validation tracking."
    - name: "effective_date_month"
      expr: DATE_TRUNC('MONTH', effective_date)
      comment: "Month the substitution became effective. Enables trend analysis of substitution activation cadence and EOL transition velocity."
  measures:
    - name: "active_substitutions_count"
      expr: COUNT(CASE WHEN status = 'active' THEN substitution_id END)
      comment: "Number of active approved substitution relationships. Measures the breadth of the ATP/CTP fallback catalog — insufficient coverage creates order fulfillment risk during supply disruptions."
    - name: "auto_substitution_eligible_count"
      expr: COUNT(CASE WHEN is_auto_substitution_allowed = TRUE AND status = 'active' THEN substitution_id END)
      comment: "Number of active substitutions eligible for automatic application. Measures order management automation potential — higher counts reduce manual intervention in supply disruption scenarios."
    - name: "full_equivalence_substitutions_count"
      expr: COUNT(CASE WHEN functional_equivalence_level = 'full' AND status = 'active' THEN substitution_id END)
      comment: "Number of active substitutions with full functional equivalence (drop-in replacements). Highest-quality substitutions that can be applied without customer impact — a key service continuity KPI."
    - name: "regulatory_driven_substitutions_count"
      expr: COUNT(CASE WHEN regulatory_compliance_flag = TRUE THEN substitution_id END)
      comment: "Number of substitutions driven by regulatory compliance requirements. Quantifies the compliance-driven product change workload and tracks RoHS/REACH remediation progress."
    - name: "customer_notification_required_count"
      expr: COUNT(CASE WHEN customer_notification_required = TRUE AND status = 'active' THEN substitution_id END)
      comment: "Number of active substitutions requiring customer notification before application. Measures customer communication workload and SLA compliance obligations in order management."
    - name: "hazmat_change_substitutions_count"
      expr: COUNT(CASE WHEN hazardous_material_change_flag = TRUE THEN substitution_id END)
      comment: "Number of substitutions involving a change in hazardous material content. Each represents a mandatory REACH/RoHS compliance review — a direct regulatory risk exposure metric."
    - name: "avg_quantity_ratio"
      expr: AVG(CAST(quantity_ratio AS DOUBLE))
      comment: "Average quantity conversion ratio between source and substitute products. Ratios significantly above 1.0 indicate substitutions that increase material consumption and cost — important for BOM and procurement planning."
    - name: "expired_substitutions_count"
      expr: COUNT(CASE WHEN status = 'expired' THEN substitution_id END)
      comment: "Number of expired substitution records. A growing count signals catalog hygiene issues — expired substitutions that are still needed must be renewed to maintain ATP/CTP fallback coverage."
$$;