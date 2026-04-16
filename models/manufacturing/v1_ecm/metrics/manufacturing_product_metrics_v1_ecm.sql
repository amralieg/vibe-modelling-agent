-- Metric views for domain: product | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_product_launch`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Product launch performance metrics tracking time-to-market, budget adherence, and readiness indicators for new product introductions"
  source: "`manufacturing_ecm`.`product`.`launch`"
  dimensions:
    - name: "launch_status"
      expr: status
      comment: "Current status of the product launch (e.g., Planning, In Progress, Completed, Cancelled)"
    - name: "business_unit"
      expr: business_unit
      comment: "Business unit responsible for the product launch"
    - name: "npi_phase"
      expr: npi_phase
      comment: "New Product Introduction phase (e.g., Concept, Development, Validation, Launch)"
    - name: "product_family"
      expr: product_family
      comment: "Product family grouping for the launched product"
    - name: "launch_year"
      expr: YEAR(actual_launch_date)
      comment: "Year when the product was actually launched"
    - name: "launch_quarter"
      expr: CONCAT('Q', QUARTER(actual_launch_date), '-', YEAR(actual_launch_date))
      comment: "Quarter when the product was actually launched"
    - name: "target_region"
      expr: target_regions
      comment: "Target geographic regions for the product launch"
    - name: "ce_marking_required_flag"
      expr: ce_marking_required
      comment: "Whether CE marking certification is required for this launch"
    - name: "export_control_flag"
      expr: export_control_flag
      comment: "Whether the product is subject to export control regulations"
  measures:
    - name: "total_launches"
      expr: COUNT(1)
      comment: "Total number of product launches"
    - name: "total_launch_budget"
      expr: SUM(CAST(budget_amount AS DOUBLE))
      comment: "Total budget allocated across all product launches"
    - name: "avg_launch_budget"
      expr: AVG(CAST(budget_amount AS DOUBLE))
      comment: "Average budget per product launch"
    - name: "avg_readiness_score"
      expr: AVG(CAST(readiness_score_percent AS DOUBLE))
      comment: "Average launch readiness score across all launches, indicating preparedness for market entry"
    - name: "launches_with_full_readiness"
      expr: COUNT(CASE WHEN readiness_score_percent >= 95 THEN 1 END)
      comment: "Number of launches achieving 95%+ readiness score, indicating high-quality launch execution"
    - name: "launches_with_certifications_obtained"
      expr: COUNT(CASE WHEN certifications_obtained_flag = TRUE THEN 1 END)
      comment: "Number of launches where all required certifications were obtained"
    - name: "launches_with_manufacturing_readiness"
      expr: COUNT(CASE WHEN manufacturing_readiness_flag = TRUE THEN 1 END)
      comment: "Number of launches where manufacturing readiness was achieved"
    - name: "launches_with_supply_chain_readiness"
      expr: COUNT(CASE WHEN supply_chain_readiness_flag = TRUE THEN 1 END)
      comment: "Number of launches where supply chain readiness was achieved"
    - name: "launches_with_sales_training_completed"
      expr: COUNT(CASE WHEN sales_training_completed_flag = TRUE THEN 1 END)
      comment: "Number of launches where sales training was completed"
    - name: "launches_with_pricing_loaded"
      expr: COUNT(CASE WHEN pricing_loaded_flag = TRUE THEN 1 END)
      comment: "Number of launches where pricing was loaded into systems"
    - name: "launches_with_documentation_published"
      expr: COUNT(CASE WHEN documentation_published_flag = TRUE THEN 1 END)
      comment: "Number of launches where product documentation was published"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_product_lifecycle`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Product lifecycle stage metrics tracking product maturity, end-of-life planning, and regulatory compliance status across the product portfolio"
  source: "`manufacturing_ecm`.`product`.`lifecycle`"
  dimensions:
    - name: "lifecycle_stage_code"
      expr: stage_code
      comment: "Current lifecycle stage code (e.g., Introduction, Growth, Maturity, Decline, EOL)"
    - name: "lifecycle_stage_name"
      expr: stage_name
      comment: "Descriptive name of the current lifecycle stage"
    - name: "is_current_stage_flag"
      expr: is_current_stage
      comment: "Whether this is the current active lifecycle stage for the product"
    - name: "market_region"
      expr: market_region
      comment: "Geographic market region for the product lifecycle record"
    - name: "responsible_business_unit"
      expr: responsible_business_unit
      comment: "Business unit responsible for managing the product lifecycle"
    - name: "ce_marking_status"
      expr: ce_marking_status
      comment: "CE marking compliance status (e.g., Compliant, Non-Compliant, In Progress)"
    - name: "rohs_compliance_status"
      expr: rohs_compliance_status
      comment: "RoHS (Restriction of Hazardous Substances) compliance status"
    - name: "reach_compliance_status"
      expr: reach_compliance_status
      comment: "REACH (Registration, Evaluation, Authorization of Chemicals) compliance status"
    - name: "ul_certification_status"
      expr: ul_certification_status
      comment: "UL (Underwriters Laboratories) certification status"
    - name: "regulatory_hold_flag"
      expr: regulatory_hold_flag
      comment: "Whether the product is on regulatory hold"
    - name: "inventory_wind_down_status"
      expr: inventory_wind_down_status
      comment: "Status of inventory wind-down for end-of-life products"
    - name: "customer_notification_status"
      expr: customer_notification_status
      comment: "Status of customer notifications for lifecycle changes"
  measures:
    - name: "total_lifecycle_records"
      expr: COUNT(1)
      comment: "Total number of product lifecycle records"
    - name: "products_in_current_stage"
      expr: COUNT(CASE WHEN is_current_stage = TRUE THEN 1 END)
      comment: "Number of products currently in this lifecycle stage"
    - name: "products_on_regulatory_hold"
      expr: COUNT(CASE WHEN regulatory_hold_flag = TRUE THEN 1 END)
      comment: "Number of products currently on regulatory hold, indicating compliance risk"
    - name: "products_with_ce_compliance"
      expr: COUNT(CASE WHEN ce_marking_status = 'Compliant' THEN 1 END)
      comment: "Number of products with compliant CE marking status"
    - name: "products_with_rohs_compliance"
      expr: COUNT(CASE WHEN rohs_compliance_status = 'Compliant' THEN 1 END)
      comment: "Number of products with compliant RoHS status"
    - name: "products_with_reach_compliance"
      expr: COUNT(CASE WHEN reach_compliance_status = 'Compliant' THEN 1 END)
      comment: "Number of products with compliant REACH status"
    - name: "products_with_ul_certification"
      expr: COUNT(CASE WHEN ul_certification_status = 'Certified' THEN 1 END)
      comment: "Number of products with valid UL certification"
    - name: "products_approaching_eol"
      expr: COUNT(CASE WHEN planned_eol_date IS NOT NULL AND planned_eol_date <= DATE_ADD(CURRENT_DATE(), 365) THEN 1 END)
      comment: "Number of products with planned end-of-life within the next 12 months, requiring proactive planning"
    - name: "products_with_customer_notification_pending"
      expr: COUNT(CASE WHEN customer_notification_status = 'Pending' THEN 1 END)
      comment: "Number of products with pending customer notifications for lifecycle changes"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_product_pricing`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Product pricing metrics tracking price levels, margins, discount structures, and pricing effectiveness across markets and channels"
  source: "`manufacturing_ecm`.`product`.`price_list_item`"
  dimensions:
    - name: "price_type"
      expr: price_type
      comment: "Type of price (e.g., List, Net, Transfer, Promotional)"
    - name: "currency_code"
      expr: currency_code
      comment: "Currency in which the price is denominated"
    - name: "country_code"
      expr: country_code
      comment: "Country for which the price applies"
    - name: "sales_org_code"
      expr: sales_org_code
      comment: "Sales organization code"
    - name: "distribution_channel_code"
      expr: distribution_channel_code
      comment: "Distribution channel code (e.g., Direct, Distributor, OEM)"
    - name: "customer_group_code"
      expr: customer_group_code
      comment: "Customer group or segment code"
    - name: "pricing_status"
      expr: status
      comment: "Status of the price list item (e.g., Active, Inactive, Pending)"
    - name: "cpq_eligible_flag"
      expr: cpq_eligible
      comment: "Whether the item is eligible for Configure-Price-Quote (CPQ) systems"
    - name: "rebate_eligible_flag"
      expr: rebate_eligible
      comment: "Whether the item is eligible for rebate programs"
    - name: "intercompany_flag"
      expr: intercompany_flag
      comment: "Whether this is an intercompany pricing record"
    - name: "price_includes_tax_flag"
      expr: price_includes_tax
      comment: "Whether the price includes tax"
    - name: "pricing_year"
      expr: YEAR(effective_date)
      comment: "Year when the price became effective"
  measures:
    - name: "total_price_list_items"
      expr: COUNT(1)
      comment: "Total number of price list items"
    - name: "distinct_products_priced"
      expr: COUNT(DISTINCT catalog_item_id)
      comment: "Number of distinct products with pricing defined"
    - name: "avg_unit_price"
      expr: AVG(CAST(unit_price AS DOUBLE))
      comment: "Average unit price across all price list items"
    - name: "total_rrp_value"
      expr: SUM(CAST(rrp AS DOUBLE))
      comment: "Total recommended retail price (RRP) value across all items"
    - name: "avg_rrp"
      expr: AVG(CAST(rrp AS DOUBLE))
      comment: "Average recommended retail price (RRP) per item"
    - name: "avg_floor_price"
      expr: AVG(CAST(floor_price AS DOUBLE))
      comment: "Average floor price (minimum allowable price) per item"
    - name: "total_surcharge_amount"
      expr: SUM(CAST(surcharge_amount AS DOUBLE))
      comment: "Total surcharge amounts applied across all price list items"
    - name: "avg_surcharge_percent"
      expr: AVG(CAST(surcharge_percent AS DOUBLE))
      comment: "Average surcharge percentage applied to prices"
    - name: "items_with_volume_pricing"
      expr: COUNT(CASE WHEN scale_from_quantity IS NOT NULL THEN 1 END)
      comment: "Number of items with volume-based pricing tiers defined"
    - name: "items_eligible_for_cpq"
      expr: COUNT(CASE WHEN cpq_eligible = TRUE THEN 1 END)
      comment: "Number of items eligible for Configure-Price-Quote systems"
    - name: "items_eligible_for_rebate"
      expr: COUNT(CASE WHEN rebate_eligible = TRUE THEN 1 END)
      comment: "Number of items eligible for rebate programs"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_product_compliance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Product regulatory compliance metrics tracking certification status, verification cycles, and compliance risk across the product portfolio"
  source: "`manufacturing_ecm`.`product`.`compliance`"
  dimensions:
    - name: "compliance_status"
      expr: status
      comment: "Current compliance status (e.g., Compliant, Non-Compliant, In Review, Waived)"
    - name: "responsible_party"
      expr: responsible_party
      comment: "Party responsible for ensuring compliance"
    - name: "compliance_year"
      expr: YEAR(verification_date)
      comment: "Year when compliance was last verified"
    - name: "has_waiver"
      expr: CASE WHEN waiver_expiry_date IS NOT NULL THEN 'Yes' ELSE 'No' END
      comment: "Whether a compliance waiver is in place"
    - name: "has_non_compliance_reason"
      expr: CASE WHEN non_compliance_reason IS NOT NULL THEN 'Yes' ELSE 'No' END
      comment: "Whether a non-compliance reason is documented"
  measures:
    - name: "total_compliance_records"
      expr: COUNT(1)
      comment: "Total number of product compliance records"
    - name: "distinct_products_tracked"
      expr: COUNT(DISTINCT catalog_item_id)
      comment: "Number of distinct products with compliance tracking"
    - name: "compliant_products"
      expr: COUNT(CASE WHEN status = 'Compliant' THEN 1 END)
      comment: "Number of products with compliant status"
    - name: "non_compliant_products"
      expr: COUNT(CASE WHEN status = 'Non-Compliant' THEN 1 END)
      comment: "Number of products with non-compliant status, indicating regulatory risk"
    - name: "products_with_active_waiver"
      expr: COUNT(CASE WHEN waiver_expiry_date >= CURRENT_DATE() THEN 1 END)
      comment: "Number of products with active compliance waivers"
    - name: "products_with_expired_waiver"
      expr: COUNT(CASE WHEN waiver_expiry_date < CURRENT_DATE() THEN 1 END)
      comment: "Number of products with expired compliance waivers, requiring immediate attention"
    - name: "products_with_overdue_verification"
      expr: COUNT(CASE WHEN next_verification_due_date < CURRENT_DATE() THEN 1 END)
      comment: "Number of products with overdue compliance verification, indicating process gaps"
    - name: "products_with_remediation_plan"
      expr: COUNT(CASE WHEN remediation_plan IS NOT NULL THEN 1 END)
      comment: "Number of non-compliant products with documented remediation plans"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_product_certification`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Product regulatory certification metrics tracking certification coverage, costs, renewal cycles, and market access readiness"
  source: "`manufacturing_ecm`.`product`.`product_regulatory_certification`"
  dimensions:
    - name: "certification_type"
      expr: certification_type
      comment: "Type of certification (e.g., CE, UL, FCC, ISO)"
    - name: "certification_standard"
      expr: certification_standard
      comment: "Specific standard or regulation (e.g., EN 60950, UL 508, ISO 9001)"
    - name: "certification_status"
      expr: status
      comment: "Current status of the certification (e.g., Active, Expired, In Progress, Suspended)"
    - name: "issuing_body"
      expr: issuing_body
      comment: "Organization that issued the certification"
    - name: "scope_level"
      expr: scope_level
      comment: "Scope level of the certification (e.g., Product, Product Family, Site)"
    - name: "country_of_manufacture"
      expr: country_of_manufacture
      comment: "Country where the certified product is manufactured"
    - name: "responsible_org_unit"
      expr: responsible_org_unit
      comment: "Organizational unit responsible for maintaining the certification"
    - name: "export_control_flag"
      expr: export_control_flag
      comment: "Whether the certified product is subject to export controls"
    - name: "reach_svhc_flag"
      expr: reach_svhc_flag
      comment: "Whether the product contains REACH Substances of Very High Concern"
    - name: "surveillance_audit_required_flag"
      expr: surveillance_audit_required
      comment: "Whether ongoing surveillance audits are required"
    - name: "certification_year"
      expr: YEAR(issue_date)
      comment: "Year when the certification was issued"
  measures:
    - name: "total_certifications"
      expr: COUNT(1)
      comment: "Total number of product regulatory certifications"
    - name: "distinct_products_certified"
      expr: COUNT(DISTINCT catalog_item_id)
      comment: "Number of distinct products with regulatory certifications"
    - name: "active_certifications"
      expr: COUNT(CASE WHEN status = 'Active' THEN 1 END)
      comment: "Number of active certifications"
    - name: "expired_certifications"
      expr: COUNT(CASE WHEN status = 'Expired' THEN 1 END)
      comment: "Number of expired certifications, indicating market access risk"
    - name: "certifications_in_progress"
      expr: COUNT(CASE WHEN status = 'In Progress' THEN 1 END)
      comment: "Number of certifications currently in progress"
    - name: "total_certification_cost"
      expr: SUM(CAST(certification_cost AS DOUBLE))
      comment: "Total cost of all product certifications"
    - name: "avg_certification_cost"
      expr: AVG(CAST(certification_cost AS DOUBLE))
      comment: "Average cost per certification"
    - name: "certifications_requiring_surveillance"
      expr: COUNT(CASE WHEN surveillance_audit_required = TRUE THEN 1 END)
      comment: "Number of certifications requiring ongoing surveillance audits"
    - name: "certifications_with_overdue_surveillance"
      expr: COUNT(CASE WHEN next_surveillance_date < CURRENT_DATE() AND surveillance_audit_required = TRUE THEN 1 END)
      comment: "Number of certifications with overdue surveillance audits, indicating compliance risk"
    - name: "certifications_expiring_soon"
      expr: COUNT(CASE WHEN expiry_date BETWEEN CURRENT_DATE() AND DATE_ADD(CURRENT_DATE(), 90) THEN 1 END)
      comment: "Number of certifications expiring within 90 days, requiring renewal action"
    - name: "products_with_reach_svhc"
      expr: COUNT(CASE WHEN reach_svhc_flag = TRUE THEN 1 END)
      comment: "Number of products containing REACH Substances of Very High Concern"
    - name: "products_with_export_controls"
      expr: COUNT(CASE WHEN export_control_flag = TRUE THEN 1 END)
      comment: "Number of certified products subject to export controls"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_change_notice`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Engineering change notice metrics tracking change velocity, approval cycles, cost impacts, and regulatory implications of product changes"
  source: "`manufacturing_ecm`.`product`.`change_notice`"
  dimensions:
    - name: "change_type"
      expr: change_type
      comment: "Type of change (e.g., Design, Process, Documentation, Regulatory)"
    - name: "change_category"
      expr: change_category
      comment: "Category of change (e.g., Cost Reduction, Quality Improvement, Compliance)"
    - name: "change_status"
      expr: status
      comment: "Current status of the change notice (e.g., Draft, Submitted, Approved, Implemented, Cancelled)"
    - name: "approval_status"
      expr: approval_status
      comment: "Approval status (e.g., Pending, Approved, Rejected)"
    - name: "priority"
      expr: priority
      comment: "Priority level of the change (e.g., Critical, High, Medium, Low)"
    - name: "change_reason_code"
      expr: change_reason_code
      comment: "Standardized reason code for the change"
    - name: "bom_change_flag"
      expr: bom_change_flag
      comment: "Whether the change affects the Bill of Materials"
    - name: "part_number_change_flag"
      expr: part_number_change_flag
      comment: "Whether the change involves a part number change"
    - name: "ce_marking_impact_flag"
      expr: ce_marking_impact_flag
      comment: "Whether the change impacts CE marking certification"
    - name: "rohs_impact_flag"
      expr: rohs_impact_flag
      comment: "Whether the change impacts RoHS compliance"
    - name: "reach_impact_flag"
      expr: reach_impact_flag
      comment: "Whether the change impacts REACH compliance"
    - name: "ul_certification_impact_flag"
      expr: ul_certification_impact_flag
      comment: "Whether the change impacts UL certification"
    - name: "export_control_impact_flag"
      expr: export_control_impact_flag
      comment: "Whether the change impacts export control classification"
    - name: "change_year"
      expr: YEAR(created_timestamp)
      comment: "Year when the change notice was created"
    - name: "change_quarter"
      expr: CONCAT('Q', QUARTER(created_timestamp), '-', YEAR(created_timestamp))
      comment: "Quarter when the change notice was created"
  measures:
    - name: "total_change_notices"
      expr: COUNT(1)
      comment: "Total number of engineering change notices"
    - name: "approved_change_notices"
      expr: COUNT(CASE WHEN approval_status = 'Approved' THEN 1 END)
      comment: "Number of approved change notices"
    - name: "rejected_change_notices"
      expr: COUNT(CASE WHEN approval_status = 'Rejected' THEN 1 END)
      comment: "Number of rejected change notices"
    - name: "pending_change_notices"
      expr: COUNT(CASE WHEN approval_status = 'Pending' THEN 1 END)
      comment: "Number of change notices pending approval"
    - name: "implemented_change_notices"
      expr: COUNT(CASE WHEN status = 'Implemented' THEN 1 END)
      comment: "Number of change notices that have been implemented"
    - name: "total_cost_impact"
      expr: SUM(CAST(cost_impact_amount AS DOUBLE))
      comment: "Total cost impact of all change notices (positive or negative)"
    - name: "avg_cost_impact"
      expr: AVG(CAST(cost_impact_amount AS DOUBLE))
      comment: "Average cost impact per change notice"
    - name: "changes_with_bom_impact"
      expr: COUNT(CASE WHEN bom_change_flag = TRUE THEN 1 END)
      comment: "Number of changes affecting Bill of Materials"
    - name: "changes_with_part_number_change"
      expr: COUNT(CASE WHEN part_number_change_flag = TRUE THEN 1 END)
      comment: "Number of changes involving part number changes"
    - name: "changes_with_ce_marking_impact"
      expr: COUNT(CASE WHEN ce_marking_impact_flag = TRUE THEN 1 END)
      comment: "Number of changes impacting CE marking, requiring recertification"
    - name: "changes_with_rohs_impact"
      expr: COUNT(CASE WHEN rohs_impact_flag = TRUE THEN 1 END)
      comment: "Number of changes impacting RoHS compliance"
    - name: "changes_with_reach_impact"
      expr: COUNT(CASE WHEN reach_impact_flag = TRUE THEN 1 END)
      comment: "Number of changes impacting REACH compliance"
    - name: "changes_with_ul_impact"
      expr: COUNT(CASE WHEN ul_certification_impact_flag = TRUE THEN 1 END)
      comment: "Number of changes impacting UL certification"
    - name: "changes_with_export_control_impact"
      expr: COUNT(CASE WHEN export_control_impact_flag = TRUE THEN 1 END)
      comment: "Number of changes impacting export control classification"
    - name: "critical_priority_changes"
      expr: COUNT(CASE WHEN priority = 'Critical' THEN 1 END)
      comment: "Number of critical priority change notices requiring immediate attention"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_hazardous_substance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Hazardous substance tracking metrics monitoring substance concentrations, regulatory compliance, and environmental risk across the product portfolio"
  source: "`manufacturing_ecm`.`product`.`hazardous_substance`"
  dimensions:
    - name: "substance_name"
      expr: substance_name
      comment: "Name of the hazardous substance"
    - name: "substance_category"
      expr: substance_category
      comment: "Category of the substance (e.g., Heavy Metal, Flame Retardant, Plasticizer)"
    - name: "cas_number"
      expr: cas_number
      comment: "Chemical Abstracts Service (CAS) registry number"
    - name: "compliance_status"
      expr: compliance_status
      comment: "Compliance status (e.g., Compliant, Non-Compliant, Under Review)"
    - name: "applicable_regulation"
      expr: applicable_regulation
      comment: "Applicable regulation (e.g., RoHS, REACH, Prop 65)"
    - name: "svhc_flag"
      expr: svhc_flag
      comment: "Whether the substance is a Substance of Very High Concern (SVHC)"
    - name: "rohs_restricted_flag"
      expr: rohs_restricted_flag
      comment: "Whether the substance is restricted under RoHS"
    - name: "prop65_listed_flag"
      expr: prop65_listed_flag
      comment: "Whether the substance is listed under California Proposition 65"
    - name: "exceeds_threshold_flag"
      expr: exceeds_threshold
      comment: "Whether the substance concentration exceeds regulatory thresholds"
    - name: "ghs_hazard_class"
      expr: ghs_hazard_class
      comment: "Globally Harmonized System (GHS) hazard classification"
    - name: "substance_function"
      expr: substance_function
      comment: "Function of the substance in the product (e.g., Stabilizer, Colorant, Conductor)"
    - name: "material_application"
      expr: material_application
      comment: "Material or component where the substance is used"
    - name: "country_of_applicability"
      expr: country_of_applicability
      comment: "Country or region where the regulation applies"
  measures:
    - name: "total_substance_declarations"
      expr: COUNT(1)
      comment: "Total number of hazardous substance declarations"
    - name: "distinct_substances"
      expr: COUNT(DISTINCT cas_number)
      comment: "Number of distinct hazardous substances tracked"
    - name: "substances_exceeding_threshold"
      expr: COUNT(CASE WHEN exceeds_threshold = TRUE THEN 1 END)
      comment: "Number of substance declarations exceeding regulatory thresholds, indicating compliance risk"
    - name: "svhc_substances"
      expr: COUNT(CASE WHEN svhc_flag = TRUE THEN 1 END)
      comment: "Number of Substances of Very High Concern (SVHC) present in products"
    - name: "rohs_restricted_substances"
      expr: COUNT(CASE WHEN rohs_restricted_flag = TRUE THEN 1 END)
      comment: "Number of RoHS-restricted substances present in products"
    - name: "prop65_listed_substances"
      expr: COUNT(CASE WHEN prop65_listed_flag = TRUE THEN 1 END)
      comment: "Number of California Prop 65 listed substances present in products"
    - name: "avg_concentration_ppm"
      expr: AVG(CAST(concentration_ppm AS DOUBLE))
      comment: "Average concentration of hazardous substances in parts per million"
    - name: "max_concentration_ppm"
      expr: MAX(CAST(concentration_ppm AS DOUBLE))
      comment: "Maximum concentration of hazardous substances in parts per million"
    - name: "avg_weight_fraction_percent"
      expr: AVG(CAST(weight_fraction_percent AS DOUBLE))
      comment: "Average weight fraction percentage of hazardous substances"
    - name: "substances_with_exemption"
      expr: COUNT(CASE WHEN exemption_reference IS NOT NULL THEN 1 END)
      comment: "Number of substance declarations with regulatory exemptions"
    - name: "substances_requiring_substitution"
      expr: COUNT(CASE WHEN substitution_substance_name IS NOT NULL THEN 1 END)
      comment: "Number of substances with identified substitution alternatives"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_bundle_performance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Product bundle performance metrics tracking bundle pricing, discounts, and market positioning for bundled product offerings"
  source: "`manufacturing_ecm`.`product`.`bundle`"
  dimensions:
    - name: "bundle_status"
      expr: status
      comment: "Current status of the bundle (e.g., Active, Inactive, Discontinued)"
    - name: "bundle_type"
      expr: type
      comment: "Type of bundle (e.g., Solution Bundle, Promotional Bundle, Standard Package)"
    - name: "bundle_category"
      expr: category
      comment: "Category of the bundle"
    - name: "lifecycle_stage"
      expr: lifecycle_stage
      comment: "Lifecycle stage of the bundle (e.g., Introduction, Growth, Maturity, Decline)"
    - name: "business_unit"
      expr: business_unit
      comment: "Business unit responsible for the bundle"
    - name: "target_industry"
      expr: target_industry
      comment: "Target industry for the bundle"
    - name: "distribution_channel"
      expr: distribution_channel
      comment: "Distribution channel for the bundle"
    - name: "sales_organization"
      expr: sales_organization
      comment: "Sales organization selling the bundle"
    - name: "is_configurable_flag"
      expr: is_configurable
      comment: "Whether the bundle is configurable by customers"
    - name: "is_orderable_standalone_flag"
      expr: is_orderable_standalone
      comment: "Whether the bundle can be ordered as a standalone item"
    - name: "pricing_method"
      expr: pricing_method
      comment: "Pricing method for the bundle (e.g., Fixed, Component Sum, Discounted)"
    - name: "ce_marked_flag"
      expr: ce_marked
      comment: "Whether the bundle has CE marking"
    - name: "rohs_compliant_flag"
      expr: rohs_compliant
      comment: "Whether the bundle is RoHS compliant"
    - name: "reach_compliant_flag"
      expr: reach_compliant
      comment: "Whether the bundle is REACH compliant"
  measures:
    - name: "total_bundles"
      expr: COUNT(1)
      comment: "Total number of product bundles"
    - name: "active_bundles"
      expr: COUNT(CASE WHEN status = 'Active' THEN 1 END)
      comment: "Number of active product bundles"
    - name: "configurable_bundles"
      expr: COUNT(CASE WHEN is_configurable = TRUE THEN 1 END)
      comment: "Number of configurable bundles allowing customer customization"
    - name: "avg_bundle_list_price"
      expr: AVG(CAST(list_price AS DOUBLE))
      comment: "Average list price per bundle"
    - name: "total_bundle_list_price"
      expr: SUM(CAST(list_price AS DOUBLE))
      comment: "Total list price value across all bundles"
    - name: "avg_bundle_standard_cost"
      expr: AVG(CAST(standard_cost AS DOUBLE))
      comment: "Average standard cost per bundle"
    - name: "total_bundle_standard_cost"
      expr: SUM(CAST(standard_cost AS DOUBLE))
      comment: "Total standard cost across all bundles"
    - name: "avg_bundle_discount_percent"
      expr: AVG(CAST(discount_percent AS DOUBLE))
      comment: "Average discount percentage offered on bundles"
    - name: "avg_min_order_quantity"
      expr: AVG(CAST(min_order_quantity AS DOUBLE))
      comment: "Average minimum order quantity for bundles"
    - name: "bundles_with_ce_marking"
      expr: COUNT(CASE WHEN ce_marked = TRUE THEN 1 END)
      comment: "Number of bundles with CE marking certification"
    - name: "bundles_with_rohs_compliance"
      expr: COUNT(CASE WHEN rohs_compliant = TRUE THEN 1 END)
      comment: "Number of bundles with RoHS compliance"
    - name: "bundles_with_reach_compliance"
      expr: COUNT(CASE WHEN reach_compliant = TRUE THEN 1 END)
      comment: "Number of bundles with REACH compliance"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_market_authorization`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Market authorization metrics tracking regulatory approvals, renewal cycles, and market access readiness across jurisdictions"
  source: "`manufacturing_ecm`.`product`.`market_authorization`"
  dimensions:
    - name: "authorization_status"
      expr: status
      comment: "Current status of the market authorization (e.g., Active, Expired, Pending, Suspended)"
    - name: "certification_type"
      expr: certification_type
      comment: "Type of certification or authorization required"
    - name: "regulatory_authority"
      expr: regulatory_authority
      comment: "Regulatory authority granting the authorization"
    - name: "renewal_required_flag"
      expr: renewal_required
      comment: "Whether periodic renewal is required"
    - name: "has_local_restrictions"
      expr: CASE WHEN local_restrictions IS NOT NULL THEN 'Yes' ELSE 'No' END
      comment: "Whether local restrictions apply to the authorization"
  measures:
    - name: "total_market_authorizations"
      expr: COUNT(1)
      comment: "Total number of market authorizations"
    - name: "distinct_products_authorized"
      expr: COUNT(DISTINCT product_sku_id)
      comment: "Number of distinct products with market authorizations"
    - name: "active_authorizations"
      expr: COUNT(CASE WHEN status = 'Active' THEN 1 END)
      comment: "Number of active market authorizations"
    - name: "expired_authorizations"
      expr: COUNT(CASE WHEN status = 'Expired' THEN 1 END)
      comment: "Number of expired market authorizations, indicating market access risk"
    - name: "pending_authorizations"
      expr: COUNT(CASE WHEN status = 'Pending' THEN 1 END)
      comment: "Number of pending market authorizations"
    - name: "authorizations_requiring_renewal"
      expr: COUNT(CASE WHEN renewal_required = TRUE THEN 1 END)
      comment: "Number of authorizations requiring periodic renewal"
    - name: "authorizations_with_overdue_audit"
      expr: COUNT(CASE WHEN next_audit_date < CURRENT_DATE() THEN 1 END)
      comment: "Number of authorizations with overdue audits, indicating compliance risk"
    - name: "authorizations_expiring_soon"
      expr: COUNT(CASE WHEN expiry_date BETWEEN CURRENT_DATE() AND DATE_ADD(CURRENT_DATE(), 90) THEN 1 END)
      comment: "Number of authorizations expiring within 90 days, requiring renewal action"
    - name: "authorizations_with_local_restrictions"
      expr: COUNT(CASE WHEN local_restrictions IS NOT NULL THEN 1 END)
      comment: "Number of authorizations with local market restrictions"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`product_discount_schedule`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Discount schedule metrics tracking discount programs, volume thresholds, and pricing incentive effectiveness across customer segments"
  source: "`manufacturing_ecm`.`product`.`discount_schedule`"
  dimensions:
    - name: "discount_status"
      expr: status
      comment: "Current status of the discount schedule (e.g., Active, Inactive, Expired)"
    - name: "discount_type"
      expr: discount_type
      comment: "Type of discount (e.g., Volume, Promotional, Loyalty, Early Payment)"
    - name: "discount_category"
      expr: discount_category
      comment: "Category of discount (e.g., Standard, Special, Rebate)"
    - name: "approval_status"
      expr: approval_status
      comment: "Approval status of the discount schedule"
    - name: "customer_scope_type"
      expr: customer_scope_type
      comment: "Type of customer scope (e.g., All Customers, Customer Group, Individual Customer)"
    - name: "product_scope_type"
      expr: product_scope_type
      comment: "Type of product scope (e.g., All Products, Product Category, Individual SKU)"
    - name: "distribution_channel"
      expr: distribution_channel
      comment: "Distribution channel for the discount"
    - name: "sales_organization"
      expr: sales_organization
      comment: "Sales organization offering the discount"
    - name: "region_code"
      expr: region_code
      comment: "Geographic region for the discount"
    - name: "country_code"
      expr: country_code
      comment: "Country for the discount"
    - name: "is_stackable_flag"
      expr: is_stackable
      comment: "Whether the discount can be combined with other discounts"
    - name: "requires_manual_override_flag"
      expr: requires_manual_override
      comment: "Whether the discount requires manual approval to apply"
    - name: "rebate_basis"
      expr: rebate_basis
      comment: "Basis for rebate calculation (e.g., Volume, Revenue, Margin)"
  measures:
    - name: "total_discount_schedules"
      expr: COUNT(1)
      comment: "Total number of discount schedules"
    - name: "active_discount_schedules"
      expr: COUNT(CASE WHEN status = 'Active' THEN 1 END)
      comment: "Number of active discount schedules"
    - name: "approved_discount_schedules"
      expr: COUNT(CASE WHEN approval_status = 'Approved' THEN 1 END)
      comment: "Number of approved discount schedules"
    - name: "avg_discount_rate"
      expr: AVG(CAST(discount_rate AS DOUBLE))
      comment: "Average discount rate across all schedules"
    - name: "max_discount_rate"
      expr: MAX(CAST(discount_rate AS DOUBLE))
      comment: "Maximum discount rate offered"
    - name: "avg_max_discount_ceiling"
      expr: AVG(CAST(max_discount_ceiling AS DOUBLE))
      comment: "Average maximum discount ceiling across schedules"
    - name: "avg_min_discount_floor"
      expr: AVG(CAST(min_discount_floor AS DOUBLE))
      comment: "Average minimum discount floor across schedules"
    - name: "total_volume_threshold_amount"
      expr: SUM(CAST(volume_threshold_amount AS DOUBLE))
      comment: "Total volume threshold amount across all discount schedules"
    - name: "avg_volume_threshold_amount"
      expr: AVG(CAST(volume_threshold_amount AS DOUBLE))
      comment: "Average volume threshold amount for discount eligibility"
    - name: "total_volume_threshold_qty"
      expr: SUM(CAST(volume_threshold_qty AS DOUBLE))
      comment: "Total volume threshold quantity across all discount schedules"
    - name: "avg_volume_threshold_qty"
      expr: AVG(CAST(volume_threshold_qty AS DOUBLE))
      comment: "Average volume threshold quantity for discount eligibility"
    - name: "stackable_discounts"
      expr: COUNT(CASE WHEN is_stackable = TRUE THEN 1 END)
      comment: "Number of discounts that can be stacked with other offers"
    - name: "discounts_requiring_manual_override"
      expr: COUNT(CASE WHEN requires_manual_override = TRUE THEN 1 END)
      comment: "Number of discounts requiring manual approval, indicating control points"
$$;