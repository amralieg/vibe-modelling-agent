-- Metric views for domain: customer | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 09:35:49

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`customer_credit_profile`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic credit risk and order-to-cash KPIs for customer credit profiles. Enables credit analysts, CFOs, and sales leadership to monitor credit exposure, utilization, overdue balances, and DSO trends across the customer portfolio. Drives credit limit decisions, collections prioritization, and risk class management."
  source: "`manufacturing_ecm`.`customer`.`credit_profile`"
  filter: status = 'ACTIVE'
  dimensions:
    - name: "credit_risk_class"
      expr: credit_risk_class
      comment: "SAP internal credit risk tier (e.g., 001=Very Low Risk through 005=Very High Risk). Primary segmentation axis for credit portfolio analysis and risk-based limit setting."
    - name: "credit_risk_class_description"
      expr: credit_risk_class_description
      comment: "Human-readable label for the credit risk class, enabling business users to interpret risk tier without code lookups."
    - name: "credit_control_area"
      expr: credit_control_area
      comment: "SAP organizational unit responsible for credit management. Allows regional or business-unit-level credit portfolio analysis."
    - name: "credit_segment"
      expr: credit_segment
      comment: "SAP credit segment grouping customers by business unit, sales org, or geography for separate credit limit management."
    - name: "credit_account_currency"
      expr: credit_account_currency
      comment: "ISO 4217 currency code for the local account currency in which credit limits and exposures are denominated."
    - name: "credit_block_status"
      expr: credit_block_status
      comment: "Boolean flag indicating whether the customer is currently on credit block. Key filter for order management and collections dashboards."
    - name: "payment_behavior_code"
      expr: payment_behavior_code
      comment: "Internal classification of historical payment behavior (e.g., prompt, slow, chronic late). Supports risk segmentation and collections strategy."
    - name: "payment_terms_code"
      expr: payment_terms_code
      comment: "SAP payment terms key (e.g., NT30, NT60) defining agreed payment conditions. Impacts DSO and credit exposure calculations."
    - name: "dunning_level"
      expr: dunning_level
      comment: "Current dunning escalation level (0–4) in SAP FI-AR. Drives collections prioritization and legal escalation decisions."
    - name: "review_frequency"
      expr: review_frequency
      comment: "Frequency of formal credit review (e.g., monthly, quarterly, annual). Supports review cadence compliance monitoring."
    - name: "last_review_date"
      expr: last_review_date
      comment: "Date of the most recent formal credit review. Used to identify overdue reviews and ensure timely reassessment."
    - name: "next_review_date"
      expr: next_review_date
      comment: "Scheduled date for the next credit review. Drives credit analyst workqueue prioritization."
    - name: "source_system"
      expr: source_system
      comment: "Originating system of record (e.g., SAP_S4HANA, SALESFORCE_CRM). Supports data lineage and multi-system reconciliation."
  measures:
    - name: "total_credit_limit_account_currency"
      expr: SUM(CAST(credit_limit_account_currency AS DOUBLE))
      comment: "Total approved credit limit across all active customer profiles in local account currency. Represents the maximum receivables exposure the organization has authorized. Executives use this to assess total credit portfolio size and headroom."
    - name: "total_credit_exposure_amount"
      expr: SUM(CAST(credit_exposure_amount AS DOUBLE))
      comment: "Total current credit exposure (open orders + deliveries + billing + AR) across all active customers in account currency. Directly compared against total credit limit to assess portfolio-level risk concentration."
    - name: "total_overdue_amount"
      expr: SUM(CAST(overdue_amount AS DOUBLE))
      comment: "Total value of overdue invoices across all active customer credit profiles. Primary trigger for collections escalation and credit block activation. A rising overdue balance signals deteriorating portfolio health."
    - name: "avg_credit_utilization_pct"
      expr: AVG(CAST(credit_utilization_pct AS DOUBLE))
      comment: "Average credit utilization percentage across active customer profiles, calculated as (exposure / credit limit) * 100. Indicates how fully customers are drawing on their approved credit. High average utilization signals elevated portfolio risk."
    - name: "avg_days_sales_outstanding"
      expr: AVG(CAST(days_sales_outstanding AS DOUBLE))
      comment: "Average DSO across active customer credit profiles. A core order-to-cash KPI measuring how quickly customers pay invoices. Rising DSO signals cash flow risk and collections inefficiency."
    - name: "count_credit_blocked_customers"
      expr: COUNT(CASE WHEN credit_block_status = TRUE THEN credit_profile_id END)
      comment: "Number of customers currently on credit block. Directly impacts order fulfillment capacity. Executives monitor this to assess revenue at risk from blocked accounts."
    - name: "count_active_credit_profiles"
      expr: COUNT(credit_profile_id)
      comment: "Total number of active customer credit profiles. Baseline denominator for credit portfolio coverage ratios and risk class distribution analysis."
    - name: "credit_block_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN credit_block_status = TRUE THEN credit_profile_id END) / NULLIF(COUNT(credit_profile_id), 0), 2)
      comment: "Percentage of active customer credit profiles currently on credit block. A rising block rate signals systemic credit risk deterioration or collections process failure requiring executive intervention."
    - name: "total_credit_insurance_limit"
      expr: SUM(CAST(credit_insurance_limit AS DOUBLE))
      comment: "Total insured credit exposure ceiling across all active customer profiles. Represents the maximum loss covered by trade credit insurance. Compared against total exposure to assess uninsured risk gap."
    - name: "avg_credit_limit_group_currency"
      expr: AVG(CAST(credit_limit_group_currency AS DOUBLE))
      comment: "Average credit limit per customer in group (corporate) currency. Enables cross-entity benchmarking of credit limit adequacy and supports consolidated credit portfolio reporting for the CFO."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`customer_account_classification`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customer account classification KPIs covering ABC segmentation, export control compliance, industry sector distribution, and classification governance. Enables sales leadership, compliance officers, and pricing teams to monitor classification coverage, export control screening status, and revenue tier distribution across the customer base."
  source: "`manufacturing_ecm`.`customer`.`account_classification`"
  filter: status = 'active'
  dimensions:
    - name: "classification_type"
      expr: classification_type
      comment: "Category of classification applied (e.g., ABC, Nielsen, ECCN, EAR99, credit risk tier). Primary segmentation axis for classification portfolio analysis."
    - name: "classification_value"
      expr: classification_value
      comment: "Specific value assigned under the classification type (e.g., A/B/C for ABC, ECCN code for export control). Enables distribution analysis within each classification type."
    - name: "abc_class"
      expr: abc_class
      comment: "ABC revenue-based segmentation tier (A=highest value, B=mid-tier, C=lower value). Core dimension for sales prioritization and resource allocation decisions."
    - name: "revenue_tier"
      expr: revenue_tier
      comment: "Revenue-based pricing and service tier (e.g., Platinum, Gold, Silver). Drives discount eligibility and dedicated account management assignment."
    - name: "industry_sector_code"
      expr: industry_sector_code
      comment: "Industry sector classification code (NAICS/SIC/NACE). Enables market segmentation and targeted sales strategy analysis."
    - name: "industry_sector_name"
      expr: industry_sector_name
      comment: "Human-readable industry sector name. Supports business reporting without requiring code lookups."
    - name: "classification_scheme"
      expr: classification_scheme
      comment: "Formal framework under which the classification is defined (e.g., SAP ABC Analysis, US EAR Export Control). Supports multi-scheme classification governance."
    - name: "country_of_application"
      expr: country_of_application
      comment: "ISO 3166-1 alpha-3 country code for which the classification applies. Enables country-specific compliance and export control analysis."
    - name: "denied_party_screen_result"
      expr: denied_party_screen_result
      comment: "Outcome of the most recent denied party screening (clear, match_found, potential_match). Critical compliance dimension for export control dashboards."
    - name: "export_license_required"
      expr: export_license_required
      comment: "Boolean flag indicating whether an export license is required for this customer. Drives export compliance workflow routing."
    - name: "ear99_flag"
      expr: ear99_flag
      comment: "Boolean flag indicating EAR99 classification (no specific export license required for most destinations). Simplifies export compliance screening for qualifying customers."
    - name: "eccn_code"
      expr: eccn_code
      comment: "Export Control Classification Number assigned to the customer. Identifies dual-use goods requiring export license screening."
    - name: "pricing_group"
      expr: pricing_group
      comment: "SAP SD pricing group code linking the customer to a specific pricing strategy and discount schedule."
    - name: "customer_account_group"
      expr: customer_account_group
      comment: "SAP customer account group (e.g., KUNA=domestic, KUNE=export, CPDL=one-time). Determines master record configuration and partner function applicability."
    - name: "assigned_date"
      expr: assigned_date
      comment: "Date the classification was formally assigned. Supports trend analysis of classification activity and audit trail reporting."
  measures:
    - name: "count_active_classifications"
      expr: COUNT(account_classification_id)
      comment: "Total number of active account classification records. Baseline measure for classification coverage and governance completeness analysis."
    - name: "count_export_license_required"
      expr: COUNT(CASE WHEN export_license_required = TRUE THEN account_classification_id END)
      comment: "Number of active customer classifications requiring an export license. Directly drives export compliance workload and revenue-at-risk assessment for restricted transactions."
    - name: "count_denied_party_screened"
      expr: COUNT(CASE WHEN denied_party_screened = TRUE THEN account_classification_id END)
      comment: "Number of customer classifications where denied party screening has been performed. Compliance officers use this to assess screening coverage and identify unscreened accounts."
    - name: "denied_party_screening_coverage_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN denied_party_screened = TRUE THEN account_classification_id END) / NULLIF(COUNT(account_classification_id), 0), 2)
      comment: "Percentage of active customer classifications with completed denied party screening. A critical compliance KPI — below-target coverage exposes the organization to export control violations and regulatory penalties."
    - name: "count_match_found_screening"
      expr: COUNT(CASE WHEN denied_party_screen_result = 'match_found' THEN account_classification_id END)
      comment: "Number of customer classifications with a confirmed denied party match. Each match triggers a compliance hold and requires immediate escalation. Executives monitor this as a zero-tolerance risk indicator."
    - name: "count_reach_rohs_compliant"
      expr: COUNT(CASE WHEN reach_rohs_compliant = TRUE THEN account_classification_id END)
      comment: "Number of customer classifications confirmed as REACH/RoHS compliant. Relevant for EU market access — non-compliant customers may be blocked from receiving regulated products."
    - name: "reach_rohs_compliance_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN reach_rohs_compliant = TRUE THEN account_classification_id END) / NULLIF(COUNT(account_classification_id), 0), 2)
      comment: "Percentage of active customer classifications confirmed as REACH/RoHS compliant. Tracks EU regulatory compliance coverage across the customer base. Below-target rates signal market access risk in the EU."
    - name: "count_primary_classifications"
      expr: COUNT(CASE WHEN is_primary = TRUE THEN account_classification_id END)
      comment: "Number of classifications flagged as primary for their type on the customer account. Ensures each customer has a governing classification for pricing and reporting. Used in data quality governance reviews."
    - name: "count_distinct_eccn_codes"
      expr: COUNT(DISTINCT eccn_code)
      comment: "Number of distinct ECCN codes present across active customer classifications. Indicates the breadth of export control complexity in the customer portfolio. Higher counts require more sophisticated compliance screening infrastructure."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`customer_sales_area_assignment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customer sales area coverage and order management KPIs. Enables sales operations, commercial excellence, and finance teams to monitor active customer-sales area relationships, block rates, rebate eligibility, and order conversion probability across the commercial portfolio. Foundational for SAP S/4HANA order-to-cash governance."
  source: "`manufacturing_ecm`.`customer`.`sales_area_assignment`"
  filter: status = 'active'
  dimensions:
    - name: "division_code"
      expr: division_code
      comment: "SAP Division code representing the product line or business segment (e.g., 01=Automation Systems, 02=Electrification, 03=Smart Infrastructure). Primary segmentation for product-line commercial analysis."
    - name: "division_name"
      expr: division_name
      comment: "Human-readable division name for reporting and analytics without requiring code lookups."
    - name: "distribution_channel_name"
      expr: distribution_channel_name
      comment: "Distribution channel description (e.g., Direct Sales, Distributor, OEM Partner). Enables channel-level commercial performance analysis."
    - name: "customer_group_code"
      expr: customer_group_code
      comment: "SAP Customer Group code (e.g., 01=OEM, 02=System Integrator, 03=Distributor). Drives pricing condition determination and customer segmentation."
    - name: "customer_group_name"
      expr: customer_group_name
      comment: "Descriptive customer group name for business reporting and segmentation analysis."
    - name: "customer_classification"
      expr: customer_classification
      comment: "SAP ABC segmentation code within the sales area (A=High Value, B=Medium, C=Low). Supports strategic account management and resource prioritization."
    - name: "incoterms_code"
      expr: incoterms_code
      comment: "Default Incoterms for the customer-sales area relationship. Governs freight cost allocation and export documentation requirements."
    - name: "payment_terms_code"
      expr: payment_terms_code
      comment: "Default SAP payment terms for the sales area (e.g., NT30, 2/10NET30). Directly impacts DSO and working capital management."
    - name: "delivery_priority"
      expr: delivery_priority
      comment: "SAP Delivery Priority code (e.g., 01=Urgent, 02=Normal, 03=Low). Impacts warehouse scheduling and customer service level differentiation."
    - name: "shipping_condition"
      expr: shipping_condition
      comment: "Default shipment mode and urgency (e.g., Standard Ground, Express Air). Used in route and shipping point determination."
    - name: "rebate_eligible_flag"
      expr: rebate_eligible_flag
      comment: "Boolean flag indicating rebate agreement eligibility. Drives rebate accrual processing and commercial incentive program management."
    - name: "order_combination_flag"
      expr: order_combination_flag
      comment: "Boolean flag indicating whether multiple orders can be combined into a single delivery. Impacts logistics cost optimization."
    - name: "sales_district_code"
      expr: sales_district_code
      comment: "SAP Sales District code for geographic territory management and regional performance reporting."
    - name: "sales_office_code"
      expr: sales_office_code
      comment: "SAP Sales Office code identifying the regional office responsible for the customer account."
    - name: "valid_from_date"
      expr: valid_from_date
      comment: "Date from which the sales area assignment is effective. Supports time-bounded relationship analysis and contract period management."
  measures:
    - name: "count_active_sales_area_assignments"
      expr: COUNT(sales_area_assignment_id)
      comment: "Total number of active customer-sales area assignments. Represents the breadth of the commercial customer portfolio across all sales areas. Baseline for coverage and block rate calculations."
    - name: "count_order_blocked_assignments"
      expr: COUNT(CASE WHEN order_block_code IS NOT NULL AND order_block_code <> '' THEN sales_area_assignment_id END)
      comment: "Number of active sales area assignments with an order block active. Directly represents revenue at risk from blocked customers. Sales operations and credit teams monitor this to prioritize unblock actions."
    - name: "count_delivery_blocked_assignments"
      expr: COUNT(CASE WHEN delivery_block_code IS NOT NULL AND delivery_block_code <> '' THEN sales_area_assignment_id END)
      comment: "Number of active sales area assignments with a delivery block active. Indicates fulfillment capacity at risk. Logistics and credit teams use this to prioritize resolution and prevent customer service failures."
    - name: "count_billing_blocked_assignments"
      expr: COUNT(CASE WHEN billing_block_code IS NOT NULL AND billing_block_code <> '' THEN sales_area_assignment_id END)
      comment: "Number of active sales area assignments with a billing block active. Directly impacts revenue recognition and cash collection. Finance and order management teams monitor this as a revenue leakage indicator."
    - name: "order_block_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN order_block_code IS NOT NULL AND order_block_code <> '' THEN sales_area_assignment_id END) / NULLIF(COUNT(sales_area_assignment_id), 0), 2)
      comment: "Percentage of active sales area assignments with an order block. A rising rate signals systemic credit, compliance, or contract issues constraining revenue generation. Executives use this as a commercial health indicator."
    - name: "count_rebate_eligible_assignments"
      expr: COUNT(CASE WHEN rebate_eligible_flag = TRUE THEN sales_area_assignment_id END)
      comment: "Number of active sales area assignments eligible for rebate agreements. Drives rebate program scope and accrual liability estimation for finance."
    - name: "avg_order_probability_pct"
      expr: AVG(CAST(order_probability_pct AS DOUBLE))
      comment: "Average quotation-to-order conversion probability across active sales area assignments. A key input to sales pipeline forecasting and revenue predictability. Declining averages signal deteriorating commercial momentum."
    - name: "count_distinct_sales_orgs"
      expr: COUNT(DISTINCT sales_org_id)
      comment: "Number of distinct sales organizations covered by active customer-sales area assignments. Indicates the geographic and organizational breadth of the active commercial portfolio."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`customer_partner_function`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "SAP SD partner function assignment KPIs for order routing, compliance, and commercial relationship governance. Enables order management, compliance, and sales operations teams to monitor partner function coverage, intercompany relationships, and assignment validity across the customer portfolio."
  source: "`manufacturing_ecm`.`customer`.`partner_function`"
  filter: status = 'active'
  dimensions:
    - name: "function_code"
      expr: function_code
      comment: "SAP SD partner function code (e.g., SP=Sold-To, SH=Ship-To, BP=Bill-To, PY=Payer, EU=End User). Primary segmentation for order routing and invoice generation analysis."
    - name: "function_description"
      expr: function_description
      comment: "Human-readable partner function role description. Enables business users to interpret function codes without SAP knowledge."
    - name: "function_category"
      expr: function_category
      comment: "Standardized business category for the partner function, independent of source system codes. Supports cross-system analytics."
    - name: "partner_type"
      expr: partner_type
      comment: "Type of business partner fulfilling the function (customer, contact, vendor, employee, org unit). Drives partner determination logic."
    - name: "assignment_level"
      expr: assignment_level
      comment: "Level at which the partner function is assigned (customer master, sales area, document header, item). Determines scope of applicability."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the partner. Used for tax determination and export control compliance analysis."
    - name: "intercompany_flag"
      expr: intercompany_flag
      comment: "Boolean flag indicating an intercompany partner relationship. Used for intercompany billing and transfer pricing process analysis."
    - name: "is_default"
      expr: is_default
      comment: "Boolean flag indicating the default partner function for the given code within the sales area. Ensures correct automatic partner proposal in new sales documents."
    - name: "is_mandatory"
      expr: is_mandatory
      comment: "Boolean flag indicating whether the partner function is mandatory for order processing. Mandatory functions must be populated before a sales document can be saved."
    - name: "document_type"
      expr: document_type
      comment: "SAP sales document type for which the partner function applies (e.g., OR=Standard Order, QT=Quotation). Null indicates all document types."
    - name: "valid_from_date"
      expr: valid_from_date
      comment: "Effective date of the partner function assignment. Supports time-bounded relationship and contract validity analysis."
    - name: "valid_to_date"
      expr: valid_to_date
      comment: "Expiry date of the partner function assignment. Drives contract expiry monitoring and partner relationship lifecycle management."
  measures:
    - name: "count_active_partner_functions"
      expr: COUNT(partner_function_id)
      comment: "Total number of active partner function assignments. Baseline measure for partner determination coverage and order routing completeness across the customer portfolio."
    - name: "count_default_partner_functions"
      expr: COUNT(CASE WHEN is_default = TRUE THEN partner_function_id END)
      comment: "Number of partner function assignments flagged as default for their function code and sales area. Ensures automatic partner proposal works correctly in new sales documents. Gaps indicate order processing risk."
    - name: "count_mandatory_partner_functions"
      expr: COUNT(CASE WHEN is_mandatory = TRUE THEN partner_function_id END)
      comment: "Number of mandatory partner function assignments. Mandatory functions must be populated before sales documents can be saved. Monitoring coverage ensures order processing is not blocked by missing mandatory partners."
    - name: "count_intercompany_partner_functions"
      expr: COUNT(CASE WHEN intercompany_flag = TRUE THEN partner_function_id END)
      comment: "Number of partner function assignments representing intercompany relationships. Drives intercompany billing volume estimation and transfer pricing process scope. Finance uses this for intercompany reconciliation planning."
    - name: "count_distinct_function_codes"
      expr: COUNT(DISTINCT function_code)
      comment: "Number of distinct partner function codes active in the portfolio. Indicates the complexity of the partner determination schema and the breadth of commercial relationship types managed."
    - name: "count_expiring_within_90_days"
      expr: COUNT(CASE WHEN valid_to_date IS NOT NULL AND valid_to_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 90) THEN partner_function_id END)
      comment: "Number of partner function assignments expiring within the next 90 days. Proactive monitoring prevents order routing failures caused by expired partner assignments. Sales ops uses this to trigger renewal workflows."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`customer_pricing_coverage_assignment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Pricing agreement coverage and approval KPIs for global account management. Enables commercial excellence, pricing, and sales leadership to monitor how broadly negotiated pricing agreements are deployed across account hierarchy nodes, track approval workflow status, and identify exclusive coverage gaps. Feeds SAP S/4HANA condition record scoping decisions."
  source: "`manufacturing_ecm`.`customer`.`pricing_coverage_assignment`"
  dimensions:
    - name: "approval_status"
      expr: approval_status
      comment: "Current approval workflow status of the pricing coverage assignment (e.g., approved, pending, rejected). Tracks whether the assignment has been authorized for the hierarchy node."
    - name: "scope_type"
      expr: scope_type
      comment: "Product scope for which the pricing agreement applies to this hierarchy node (e.g., full portfolio, specific product line). A global agreement may apply differently to parent vs. subsidiary nodes."
    - name: "is_exclusive"
      expr: is_exclusive
      comment: "Boolean flag indicating exclusive pricing rights for this hierarchy node. Prevents the same agreement terms from being assigned to competing nodes in the same region or market."
    - name: "effective_date"
      expr: effective_date
      comment: "Date from which the pricing assignment is valid for the hierarchy node. Supports staggered rollout analysis and validity period monitoring."
    - name: "expiry_date"
      expr: expiry_date
      comment: "Date on which the pricing assignment expires for the hierarchy node. Drives SAP condition record deactivation and renewal workflow triggering."
  measures:
    - name: "count_pricing_coverage_assignments"
      expr: COUNT(pricing_coverage_assignment_id)
      comment: "Total number of pricing agreement-to-hierarchy-node assignments. Represents the breadth of negotiated pricing deployment across the account portfolio. Baseline for coverage and approval rate calculations."
    - name: "count_approved_assignments"
      expr: COUNT(CASE WHEN approval_status = 'approved' THEN pricing_coverage_assignment_id END)
      comment: "Number of pricing coverage assignments with approved status. Only approved assignments are operationally active for SAP condition record scoping. Unapproved assignments represent pricing deployment gaps."
    - name: "approval_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN approval_status = 'approved' THEN pricing_coverage_assignment_id END) / NULLIF(COUNT(pricing_coverage_assignment_id), 0), 2)
      comment: "Percentage of pricing coverage assignments that have been approved. Low approval rates indicate bottlenecks in the commercial approval workflow, delaying pricing deployment to subsidiaries and risking revenue leakage."
    - name: "count_exclusive_assignments"
      expr: COUNT(CASE WHEN is_exclusive = TRUE THEN pricing_coverage_assignment_id END)
      comment: "Number of pricing coverage assignments granting exclusive pricing rights to a hierarchy node. Executives use this to assess the scope of exclusive commercial commitments and their impact on competitive flexibility."
    - name: "count_expiring_within_90_days"
      expr: COUNT(CASE WHEN expiry_date IS NOT NULL AND expiry_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, 90) THEN pricing_coverage_assignment_id END)
      comment: "Number of pricing coverage assignments expiring within the next 90 days. Proactive monitoring prevents pricing gaps caused by expired assignments. Commercial teams use this to trigger renewal negotiations before expiry."
    - name: "count_distinct_pricing_agreements"
      expr: COUNT(DISTINCT pricing_agreement_id)
      comment: "Number of distinct pricing agreements deployed across account hierarchy nodes. Indicates the breadth of the negotiated pricing portfolio. Supports commercial excellence benchmarking and agreement consolidation analysis."
    - name: "count_distinct_account_hierarchy_nodes"
      expr: COUNT(DISTINCT account_hierarchy_id)
      comment: "Number of distinct account hierarchy nodes covered by at least one pricing agreement assignment. Measures the reach of negotiated pricing across the global account structure. Gaps indicate subsidiaries or affiliates not yet covered by formal pricing agreements."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`customer_account_contact_role`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "B2B account contact relationship health and compliance KPIs. Enables sales, account management, and compliance teams to monitor contact role coverage, GDPR/CCPA consent status, relationship engagement recency, and verification completeness across complex multi-stakeholder accounts. Drives targeted communication routing and relationship governance."
  source: "`manufacturing_ecm`.`customer`.`account_contact_role`"
  filter: status = 'active'
  dimensions:
    - name: "role_type"
      expr: role_type
      comment: "Specific business function of the contact within the account (e.g., primary commercial contact, technical decision maker, accounts payable contact, executive sponsor). Primary segmentation for communication routing and stakeholder mapping."
    - name: "role_category"
      expr: role_category
      comment: "Broad functional grouping of the contact role (e.g., Commercial, Technical, Finance, Executive). Enables portfolio-level segmentation and targeted communication strategies."
    - name: "influence_level"
      expr: influence_level
      comment: "Degree of influence the contact exercises over purchasing or operational decisions (e.g., High, Medium, Low). Used in sales strategy and opportunity management."
    - name: "relationship_strength"
      expr: relationship_strength
      comment: "Qualitative assessment of the business relationship strength (e.g., Strong, Developing, Weak). Informs account management strategy and customer retention efforts."
    - name: "gdpr_consent_status"
      expr: gdpr_consent_status
      comment: "GDPR consent status for processing the contacts personal data in this role. Mandatory for EU/EEA contacts. Non-compliant contacts cannot be engaged in marketing or outbound communications."
    - name: "ccpa_opt_out"
      expr: ccpa_opt_out
      comment: "Boolean flag indicating CCPA opt-out status. Applicable to California contacts. Drives data sharing restrictions and communication compliance."
    - name: "communication_preference"
      expr: communication_preference
      comment: "Preferred communication channel for this contact role (e.g., email, phone, portal). Governs outbound communication routing for commercial and service interactions."
    - name: "sla_tier"
      expr: sla_tier
      comment: "SLA tier applicable to this contact role, governing response time commitments and escalation priorities for service interactions."
    - name: "contract_authority_level"
      expr: contract_authority_level
      comment: "Level of contractual signing authority held by this contact. Critical for order management and legal compliance workflows requiring authorized signatories."
    - name: "verified_flag"
      expr: verified_flag
      comment: "Boolean flag indicating whether the contact role assignment has been formally verified. Supports data quality governance and master data management."
    - name: "is_primary"
      expr: is_primary
      comment: "Boolean flag indicating the primary contact for the role type within the account. Ensures correct communication routing when multiple contacts hold the same role."
    - name: "last_interaction_date"
      expr: last_interaction_date
      comment: "Date of the most recent recorded business interaction with this contact. Used for relationship health monitoring and engagement analytics."
  measures:
    - name: "count_active_contact_roles"
      expr: COUNT(account_contact_role_id)
      comment: "Total number of active account-contact role associations. Baseline measure for contact coverage completeness across the B2B account portfolio."
    - name: "count_verified_contact_roles"
      expr: COUNT(CASE WHEN verified_flag = TRUE THEN account_contact_role_id END)
      comment: "Number of active contact role assignments that have been formally verified. Unverified roles represent data quality risk in communication routing and escalation processes."
    - name: "contact_verification_rate_pct"
      expr: ROUND(100.0 * COUNT(CASE WHEN verified_flag = TRUE THEN account_contact_role_id END) / NULLIF(COUNT(account_contact_role_id), 0), 2)
      comment: "Percentage of active contact role assignments that are formally verified. A key data quality KPI — low verification rates indicate stale or unconfirmed contact data that degrades communication effectiveness and escalation reliability."
    - name: "count_gdpr_consented_roles"
      expr: COUNT(CASE WHEN gdpr_consent_status = 'consented' THEN account_contact_role_id END)
      comment: "Number of active contact roles with valid GDPR consent. Determines the legally compliant pool of EU/EEA contacts available for outbound engagement. Non-consented contacts cannot be included in marketing campaigns."
    - name: "count_notification_opted_in"
      expr: COUNT(CASE WHEN notification_opt_in = TRUE THEN account_contact_role_id END)
      comment: "Number of active contact roles opted in to automated notifications (order status, shipment alerts, quality notifications). Represents the reachable audience for digital engagement programs."
    - name: "avg_purchase_order_authority_limit"
      expr: AVG(CAST(purchase_order_authority_limit AS DOUBLE))
      comment: "Average PO authority limit across active contact roles. Informs procurement workflow routing design — if average limits are low, more orders require escalation to higher-authority contacts, increasing cycle time."
    - name: "count_high_influence_contacts"
      expr: COUNT(CASE WHEN influence_level = 'High' THEN account_contact_role_id END)
      comment: "Number of active contact roles classified as high influence over purchasing or operational decisions. Sales leadership uses this to assess executive relationship coverage and identify accounts with insufficient senior-level engagement."
    - name: "count_primary_contact_roles"
      expr: COUNT(CASE WHEN is_primary = TRUE THEN account_contact_role_id END)
      comment: "Number of active contact roles designated as primary for their role type within the account. Ensures each account has a designated primary contact per function for reliable communication routing."
$$;