-- Metric views for domain: sales | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_account_plan`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Account Plan business metrics"
  source: "`manufacturing_ecm`.`sales`.`account_plan`"
  dimensions:
    - name: "Approved Date"
      expr: approved_date
    - name: "Competitive Position"
      expr: competitive_position
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Crm Record Code"
      expr: crm_record_code
    - name: "Engagement Plan Summary"
      expr: engagement_plan_summary
    - name: "Erp Customer Number"
      expr: erp_customer_number
    - name: "Framework Agreement Ref"
      expr: framework_agreement_ref
    - name: "Industry Vertical"
      expr: industry_vertical
    - name: "Is Global Account"
      expr: is_global_account
    - name: "Key Solution Focus"
      expr: key_solution_focus
    - name: "Last Reviewed Date"
      expr: last_reviewed_date
    - name: "Modified Timestamp"
      expr: modified_timestamp
    - name: "Plan End Date"
      expr: plan_end_date
    - name: "Plan Name"
      expr: plan_name
    - name: "Plan Start Date"
      expr: plan_start_date
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Account Plan"
      expr: COUNT(DISTINCT account_plan_id)
    - name: "Total Budget Allocated Amount"
      expr: SUM(budget_allocated_amount)
    - name: "Average Budget Allocated Amount"
      expr: AVG(budget_allocated_amount)
    - name: "Total Customer Satisfaction Score"
      expr: SUM(customer_satisfaction_score)
    - name: "Average Customer Satisfaction Score"
      expr: AVG(customer_satisfaction_score)
    - name: "Total Prior Year Revenue Amount"
      expr: SUM(prior_year_revenue_amount)
    - name: "Average Prior Year Revenue Amount"
      expr: AVG(prior_year_revenue_amount)
    - name: "Total Revenue Target Amount"
      expr: SUM(revenue_target_amount)
    - name: "Average Revenue Target Amount"
      expr: AVG(revenue_target_amount)
    - name: "Total Whitespace Opportunity Amount"
      expr: SUM(whitespace_opportunity_amount)
    - name: "Average Whitespace Opportunity Amount"
      expr: AVG(whitespace_opportunity_amount)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_activity`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Activity business metrics"
  source: "`manufacturing_ecm`.`sales`.`activity`"
  dimensions:
    - name: "Attendee Count"
      expr: attendee_count
    - name: "Channel"
      expr: channel
    - name: "Competitor Mentioned"
      expr: competitor_mentioned
    - name: "Contact Title"
      expr: contact_title
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Crm Activity Code"
      expr: crm_activity_code
    - name: "Date"
      expr: date
    - name: "Duration Minutes"
      expr: duration_minutes
    - name: "End Timestamp"
      expr: end_timestamp
    - name: "Industry Segment"
      expr: industry_segment
    - name: "Internal Attendees"
      expr: internal_attendees
    - name: "Is Key Account"
      expr: is_key_account
    - name: "Language Code"
      expr: language_code
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Location Address"
      expr: location_address
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Activity"
      expr: COUNT(DISTINCT activity_id)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_campaign`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Campaign business metrics"
  source: "`manufacturing_ecm`.`sales`.`campaign`"
  dimensions:
    - name: "Approved By"
      expr: approved_by
    - name: "Approved Date"
      expr: approved_date
    - name: "Code"
      expr: code
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Crm Campaign Code"
      expr: crm_campaign_code
    - name: "Currency Code"
      expr: currency_code
    - name: "Description"
      expr: description
    - name: "End Date"
      expr: end_date
    - name: "Fiscal Quarter"
      expr: fiscal_quarter
    - name: "Fiscal Year"
      expr: fiscal_year
    - name: "Industry Vertical"
      expr: industry_vertical
    - name: "Is Global"
      expr: is_global
    - name: "Language Code"
      expr: language_code
    - name: "Lead Target Count"
      expr: lead_target_count
    - name: "Modified Timestamp"
      expr: modified_timestamp
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Campaign"
      expr: COUNT(DISTINCT campaign_id)
    - name: "Total Budget Amount"
      expr: SUM(budget_amount)
    - name: "Average Budget Amount"
      expr: AVG(budget_amount)
    - name: "Total Budget Amount Usd"
      expr: SUM(budget_amount_usd)
    - name: "Average Budget Amount Usd"
      expr: AVG(budget_amount_usd)
    - name: "Total Pipeline Target Amount"
      expr: SUM(pipeline_target_amount)
    - name: "Average Pipeline Target Amount"
      expr: AVG(pipeline_target_amount)
    - name: "Total Revenue Target Amount"
      expr: SUM(revenue_target_amount)
    - name: "Average Revenue Target Amount"
      expr: AVG(revenue_target_amount)
    - name: "Total Revenue Target Usd"
      expr: SUM(revenue_target_usd)
    - name: "Average Revenue Target Usd"
      expr: AVG(revenue_target_usd)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_channel_partner_program`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Channel Partner Program business metrics"
  source: "`manufacturing_ecm`.`sales`.`channel_partner_program`"
  dimensions:
    - name: "Business Plan Required"
      expr: business_plan_required
    - name: "Certification Level Required"
      expr: certification_level_required
    - name: "Co Marketing Fund Basis"
      expr: co_marketing_fund_basis
    - name: "Co Sell Eligible"
      expr: co_sell_eligible
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      expr: currency_code
    - name: "Dedicated Account Manager"
      expr: dedicated_account_manager
    - name: "Description"
      expr: description
    - name: "Effective Date"
      expr: effective_date
    - name: "Enrollment Deadline"
      expr: enrollment_deadline
    - name: "Expiry Date"
      expr: expiry_date
    - name: "Governing Law Country Code"
      expr: governing_law_country_code
    - name: "Lead Sharing Eligible"
      expr: lead_sharing_eligible
    - name: "Max Enrolled Partners"
      expr: max_enrolled_partners
    - name: "Modified Timestamp"
      expr: modified_timestamp
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Channel Partner Program"
      expr: COUNT(DISTINCT channel_partner_program_id)
    - name: "Total Annual Revenue Threshold Max"
      expr: SUM(annual_revenue_threshold_max)
    - name: "Average Annual Revenue Threshold Max"
      expr: AVG(annual_revenue_threshold_max)
    - name: "Total Annual Revenue Threshold Min"
      expr: SUM(annual_revenue_threshold_min)
    - name: "Average Annual Revenue Threshold Min"
      expr: AVG(annual_revenue_threshold_min)
    - name: "Total Base Discount Pct"
      expr: SUM(base_discount_pct)
    - name: "Average Base Discount Pct"
      expr: AVG(base_discount_pct)
    - name: "Total Co Marketing Fund Amount"
      expr: SUM(co_marketing_fund_amount)
    - name: "Average Co Marketing Fund Amount"
      expr: AVG(co_marketing_fund_amount)
    - name: "Total Co Marketing Fund Pct"
      expr: SUM(co_marketing_fund_pct)
    - name: "Average Co Marketing Fund Pct"
      expr: AVG(co_marketing_fund_pct)
    - name: "Total Deal Registration Discount Pct"
      expr: SUM(deal_registration_discount_pct)
    - name: "Average Deal Registration Discount Pct"
      expr: AVG(deal_registration_discount_pct)
    - name: "Total Rebate Pct"
      expr: SUM(rebate_pct)
    - name: "Average Rebate Pct"
      expr: AVG(rebate_pct)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_commission_plan`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Commission Plan business metrics"
  source: "`manufacturing_ecm`.`sales`.`commission_plan`"
  dimensions:
    - name: "Approval Status"
      expr: approval_status
    - name: "Approved By"
      expr: approved_by
    - name: "Approved Date"
      expr: approved_date
    - name: "Clawback Period Days"
      expr: clawback_period_days
    - name: "Clawback Trigger"
      expr: clawback_trigger
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      expr: currency_code
    - name: "Description"
      expr: description
    - name: "Draw Type"
      expr: draw_type
    - name: "Effective End Date"
      expr: effective_end_date
    - name: "Effective Start Date"
      expr: effective_start_date
    - name: "Eligible Order Type"
      expr: eligible_order_type
    - name: "Fiscal Year"
      expr: fiscal_year
    - name: "Max Split Parties"
      expr: max_split_parties
    - name: "Modified Timestamp"
      expr: modified_timestamp
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Commission Plan"
      expr: COUNT(DISTINCT commission_plan_id)
    - name: "Total Accelerator Rate"
      expr: SUM(accelerator_rate)
    - name: "Average Accelerator Rate"
      expr: AVG(accelerator_rate)
    - name: "Total Accelerator Threshold Pct"
      expr: SUM(accelerator_threshold_pct)
    - name: "Average Accelerator Threshold Pct"
      expr: AVG(accelerator_threshold_pct)
    - name: "Total Base Commission Rate"
      expr: SUM(base_commission_rate)
    - name: "Average Base Commission Rate"
      expr: AVG(base_commission_rate)
    - name: "Total Cap Amount"
      expr: SUM(cap_amount)
    - name: "Average Cap Amount"
      expr: AVG(cap_amount)
    - name: "Total Draw Amount"
      expr: SUM(draw_amount)
    - name: "Average Draw Amount"
      expr: AVG(draw_amount)
    - name: "Total Minimum Deal Size"
      expr: SUM(minimum_deal_size)
    - name: "Average Minimum Deal Size"
      expr: AVG(minimum_deal_size)
    - name: "Total Product Line Multiplier"
      expr: SUM(product_line_multiplier)
    - name: "Average Product Line Multiplier"
      expr: AVG(product_line_multiplier)
    - name: "Total Quota Attainment Threshold Pct"
      expr: SUM(quota_attainment_threshold_pct)
    - name: "Average Quota Attainment Threshold Pct"
      expr: AVG(quota_attainment_threshold_pct)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_commission_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Commission Record business metrics"
  source: "`manufacturing_ecm`.`sales`.`commission_record`"
  dimensions:
    - name: "Adjustment Reason"
      expr: adjustment_reason
    - name: "Approval Date"
      expr: approval_date
    - name: "Approved By"
      expr: approved_by
    - name: "Booking Date"
      expr: booking_date
    - name: "Calculation Date"
      expr: calculation_date
    - name: "Clawback Reason"
      expr: clawback_reason
    - name: "Country Code"
      expr: country_code
    - name: "Currency Code"
      expr: currency_code
    - name: "Dispute Flag"
      expr: dispute_flag
    - name: "Dispute Reason"
      expr: dispute_reason
    - name: "Dispute Resolution Date"
      expr: dispute_resolution_date
    - name: "Fiscal Quarter"
      expr: fiscal_quarter
    - name: "Fiscal Year"
      expr: fiscal_year
    - name: "Notes"
      expr: notes
    - name: "Payee Name"
      expr: payee_name
    - name: "Payee Type"
      expr: payee_type
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Commission Record"
      expr: COUNT(DISTINCT commission_record_id)
    - name: "Total Adjustment Amount"
      expr: SUM(adjustment_amount)
    - name: "Average Adjustment Amount"
      expr: AVG(adjustment_amount)
    - name: "Total Clawback Amount"
      expr: SUM(clawback_amount)
    - name: "Average Clawback Amount"
      expr: AVG(clawback_amount)
    - name: "Total Commission Rate"
      expr: SUM(commission_rate)
    - name: "Average Commission Rate"
      expr: AVG(commission_rate)
    - name: "Total Earned Amount"
      expr: SUM(earned_amount)
    - name: "Average Earned Amount"
      expr: AVG(earned_amount)
    - name: "Total Net Payable Amount"
      expr: SUM(net_payable_amount)
    - name: "Average Net Payable Amount"
      expr: AVG(net_payable_amount)
    - name: "Total Revenue Amount"
      expr: SUM(revenue_amount)
    - name: "Average Revenue Amount"
      expr: AVG(revenue_amount)
    - name: "Total Split Percentage"
      expr: SUM(split_percentage)
    - name: "Average Split Percentage"
      expr: AVG(split_percentage)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_competitor`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Competitor business metrics"
  source: "`manufacturing_ecm`.`sales`.`competitor`"
  dimensions:
    - name: "Battlecard Url"
      expr: battlecard_url
    - name: "Certifications"
      expr: certifications
    - name: "Competitive Threat Level"
      expr: competitive_threat_level
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Crm Competitor Code"
      expr: crm_competitor_code
    - name: "Employee Count Range"
      expr: employee_count_range
    - name: "Geographic Presence"
      expr: geographic_presence
    - name: "Go To Market Model"
      expr: go_to_market_model
    - name: "Headquarters City"
      expr: headquarters_city
    - name: "Headquarters Country Code"
      expr: headquarters_country_code
    - name: "Industry Segment"
      expr: industry_segment
    - name: "Intelligence As Of Date"
      expr: intelligence_as_of_date
    - name: "Intelligence Source"
      expr: intelligence_source
    - name: "Known Strengths"
      expr: known_strengths
    - name: "Known Weaknesses"
      expr: known_weaknesses
    - name: "Market Segments Served"
      expr: market_segments_served
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Competitor"
      expr: COUNT(DISTINCT competitor_id)
    - name: "Total Estimated Annual Revenue Usd"
      expr: SUM(estimated_annual_revenue_usd)
    - name: "Average Estimated Annual Revenue Usd"
      expr: AVG(estimated_annual_revenue_usd)
    - name: "Total Estimated Market Share Pct"
      expr: SUM(estimated_market_share_pct)
    - name: "Average Estimated Market Share Pct"
      expr: AVG(estimated_market_share_pct)
    - name: "Total Loss Rate Against Pct"
      expr: SUM(loss_rate_against_pct)
    - name: "Average Loss Rate Against Pct"
      expr: AVG(loss_rate_against_pct)
    - name: "Total Win Rate Against Pct"
      expr: SUM(win_rate_against_pct)
    - name: "Average Win Rate Against Pct"
      expr: AVG(win_rate_against_pct)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_deal_registration`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Deal Registration business metrics"
  source: "`manufacturing_ecm`.`sales`.`deal_registration`"
  dimensions:
    - name: "Approval Date"
      expr: approval_date
    - name: "Approver Name"
      expr: approver_name
    - name: "Competing Registration Count"
      expr: competing_registration_count
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Crm Registration Code"
      expr: crm_registration_code
    - name: "Currency Code"
      expr: currency_code
    - name: "End Customer Country Code"
      expr: end_customer_country_code
    - name: "End Customer Name"
      expr: end_customer_name
    - name: "Expected Close Date"
      expr: expected_close_date
    - name: "Expiry Date"
      expr: expiry_date
    - name: "Has Competing Registration"
      expr: has_competing_registration
    - name: "Industry Segment"
      expr: industry_segment
    - name: "Last Renewal Date"
      expr: last_renewal_date
    - name: "Linked Opportunity Number"
      expr: linked_opportunity_number
    - name: "Modified Timestamp"
      expr: modified_timestamp
    - name: "Partner Country Code"
      expr: partner_country_code
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Deal Registration"
      expr: COUNT(DISTINCT deal_registration_id)
    - name: "Total Discount Pct"
      expr: SUM(discount_pct)
    - name: "Average Discount Pct"
      expr: AVG(discount_pct)
    - name: "Total Exchange Rate"
      expr: SUM(exchange_rate)
    - name: "Average Exchange Rate"
      expr: AVG(exchange_rate)
    - name: "Total Registered Value"
      expr: SUM(registered_value)
    - name: "Average Registered Value"
      expr: AVG(registered_value)
    - name: "Total Registered Value Usd"
      expr: SUM(registered_value_usd)
    - name: "Average Registered Value Usd"
      expr: AVG(registered_value_usd)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_discount_structure`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Discount Structure business metrics"
  source: "`manufacturing_ecm`.`sales`.`discount_structure`"
  dimensions:
    - name: "Approval Authority Level"
      expr: approval_authority_level
    - name: "Approval Date"
      expr: approval_date
    - name: "Approved By"
      expr: approved_by
    - name: "Code"
      expr: code
    - name: "Condition Type"
      expr: condition_type
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Crm Price Rule Code"
      expr: crm_price_rule_code
    - name: "Currency Code"
      expr: currency_code
    - name: "Customer Segment"
      expr: customer_segment
    - name: "Description"
      expr: description
    - name: "Discount Basis"
      expr: discount_basis
    - name: "Discount Type"
      expr: discount_type
    - name: "Distribution Channel Code"
      expr: distribution_channel_code
    - name: "Exclusion Group"
      expr: exclusion_group
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Discount Structure"
      expr: COUNT(DISTINCT discount_structure_id)
    - name: "Total Fixed Discount Amount"
      expr: SUM(fixed_discount_amount)
    - name: "Average Fixed Discount Amount"
      expr: AVG(fixed_discount_amount)
    - name: "Total Max Discount Pct"
      expr: SUM(max_discount_pct)
    - name: "Average Max Discount Pct"
      expr: AVG(max_discount_pct)
    - name: "Total Min Discount Pct"
      expr: SUM(min_discount_pct)
    - name: "Average Min Discount Pct"
      expr: AVG(min_discount_pct)
    - name: "Total Min Order Quantity"
      expr: SUM(min_order_quantity)
    - name: "Average Min Order Quantity"
      expr: AVG(min_order_quantity)
    - name: "Total Min Order Value"
      expr: SUM(min_order_value)
    - name: "Average Min Order Value"
      expr: AVG(min_order_value)
    - name: "Total Standard Discount Pct"
      expr: SUM(standard_discount_pct)
    - name: "Average Standard Discount Pct"
      expr: AVG(standard_discount_pct)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_forecast`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Forecast business metrics"
  source: "`manufacturing_ecm`.`sales`.`forecast`"
  dimensions:
    - name: "Approved Date"
      expr: approved_date
    - name: "Category"
      expr: category
    - name: "Confidence Level"
      expr: confidence_level
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Crm Forecast Code"
      expr: crm_forecast_code
    - name: "Currency Code"
      expr: currency_code
    - name: "Cycle Type"
      expr: cycle_type
    - name: "Distribution Channel"
      expr: distribution_channel
    - name: "Fiscal Period"
      expr: fiscal_period
    - name: "Industry Vertical"
      expr: industry_vertical
    - name: "Modified Timestamp"
      expr: modified_timestamp
    - name: "Name"
      expr: name
    - name: "Notes"
      expr: notes
    - name: "Number"
      expr: number
    - name: "Period End Date"
      expr: period_end_date
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Forecast"
      expr: COUNT(DISTINCT forecast_id)
    - name: "Total Exchange Rate"
      expr: SUM(exchange_rate)
    - name: "Average Exchange Rate"
      expr: AVG(exchange_rate)
    - name: "Total Forecasted Margin Amount"
      expr: SUM(forecasted_margin_amount)
    - name: "Average Forecasted Margin Amount"
      expr: AVG(forecasted_margin_amount)
    - name: "Total Forecasted Margin Pct"
      expr: SUM(forecasted_margin_pct)
    - name: "Average Forecasted Margin Pct"
      expr: AVG(forecasted_margin_pct)
    - name: "Total Forecasted Revenue Amount"
      expr: SUM(forecasted_revenue_amount)
    - name: "Average Forecasted Revenue Amount"
      expr: AVG(forecasted_revenue_amount)
    - name: "Total Forecasted Revenue Usd"
      expr: SUM(forecasted_revenue_usd)
    - name: "Average Forecasted Revenue Usd"
      expr: AVG(forecasted_revenue_usd)
    - name: "Total Forecasted Units"
      expr: SUM(forecasted_units)
    - name: "Average Forecasted Units"
      expr: AVG(forecasted_units)
    - name: "Total Probability Pct"
      expr: SUM(probability_pct)
    - name: "Average Probability Pct"
      expr: AVG(probability_pct)
    - name: "Total Quota Amount"
      expr: SUM(quota_amount)
    - name: "Average Quota Amount"
      expr: AVG(quota_amount)
    - name: "Total Variance To Quota Amount"
      expr: SUM(variance_to_quota_amount)
    - name: "Average Variance To Quota Amount"
      expr: AVG(variance_to_quota_amount)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_lead`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Lead business metrics"
  source: "`manufacturing_ecm`.`sales`.`lead`"
  dimensions:
    - name: "Assigned Owner"
      expr: assigned_owner
    - name: "City"
      expr: city
    - name: "Consent Obtained"
      expr: consent_obtained
    - name: "Converted Date"
      expr: converted_date
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Crm Lead Code"
      expr: crm_lead_code
    - name: "Currency Code"
      expr: currency_code
    - name: "Description"
      expr: description
    - name: "Disqualification Reason"
      expr: disqualification_reason
    - name: "Do Not Contact"
      expr: do_not_contact
    - name: "Email"
      expr: email
    - name: "Employee Count"
      expr: employee_count
    - name: "First Name"
      expr: first_name
    - name: "Industry Segment"
      expr: industry_segment
    - name: "Is Converted"
      expr: is_converted
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Lead"
      expr: COUNT(DISTINCT lead_id)
    - name: "Total Annual Revenue"
      expr: SUM(annual_revenue)
    - name: "Average Annual Revenue"
      expr: AVG(annual_revenue)
    - name: "Total Estimated Deal Value"
      expr: SUM(estimated_deal_value)
    - name: "Average Estimated Deal Value"
      expr: AVG(estimated_deal_value)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_opportunity_competitor`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Opportunity Competitor business metrics"
  source: "`manufacturing_ecm`.`sales`.`opportunity_competitor`"
  dimensions:
    - name: "Battlecard Version"
      expr: battlecard_version
    - name: "Competitive Strength"
      expr: competitive_strength
    - name: "Competitor Code"
      expr: competitor_code
    - name: "Competitor Price Currency"
      expr: competitor_price_currency
    - name: "Competitor Product Category"
      expr: competitor_product_category
    - name: "Competitor Product Name"
      expr: competitor_product_name
    - name: "Competitor Relationship Strength"
      expr: competitor_relationship_strength
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Displacement Strategy"
      expr: displacement_strategy
    - name: "Displacement Strategy Detail"
      expr: displacement_strategy_detail
    - name: "Identified Date"
      expr: identified_date
    - name: "Incumbent Flag"
      expr: incumbent_flag
    - name: "Industry Segment"
      expr: industry_segment
    - name: "Intelligence Confidence"
      expr: intelligence_confidence
    - name: "Intelligence Source"
      expr: intelligence_source
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Opportunity Competitor"
      expr: COUNT(DISTINCT opportunity_competitor_id)
    - name: "Total Competitor Price Estimate"
      expr: SUM(competitor_price_estimate)
    - name: "Average Competitor Price Estimate"
      expr: AVG(competitor_price_estimate)
    - name: "Total Price Differential Pct"
      expr: SUM(price_differential_pct)
    - name: "Average Price Differential Pct"
      expr: AVG(price_differential_pct)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_opportunity_line`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Opportunity Line business metrics"
  source: "`manufacturing_ecm`.`sales`.`opportunity_line`"
  dimensions:
    - name: "Configuration Details"
      expr: configuration_details
    - name: "Created Date"
      expr: created_date
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Line Status"
      expr: line_status
    - name: "Requested Delivery Date"
      expr: requested_delivery_date
    - name: "Created Date Month"
      expr: DATE_TRUNC('MONTH', created_date)
    - name: "Last Modified Timestamp Month"
      expr: DATE_TRUNC('MONTH', last_modified_timestamp)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Opportunity Line"
      expr: COUNT(DISTINCT opportunity_line_id)
    - name: "Total Cost Estimate"
      expr: SUM(cost_estimate)
    - name: "Average Cost Estimate"
      expr: AVG(cost_estimate)
    - name: "Total Discount Percent"
      expr: SUM(discount_percent)
    - name: "Average Discount Percent"
      expr: AVG(discount_percent)
    - name: "Total Line Number"
      expr: SUM(line_number)
    - name: "Average Line Number"
      expr: AVG(line_number)
    - name: "Total Line Total"
      expr: SUM(line_total)
    - name: "Average Line Total"
      expr: AVG(line_total)
    - name: "Total Margin Amount"
      expr: SUM(margin_amount)
    - name: "Average Margin Amount"
      expr: AVG(margin_amount)
    - name: "Total Quantity"
      expr: SUM(quantity)
    - name: "Average Quantity"
      expr: AVG(quantity)
    - name: "Total Unit Price"
      expr: SUM(unit_price)
    - name: "Average Unit Price"
      expr: AVG(unit_price)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_opportunity_stage_history`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Opportunity Stage History business metrics"
  source: "`manufacturing_ecm`.`sales`.`opportunity_stage_history`"
  dimensions:
    - name: "Approval Required"
      expr: approval_required
    - name: "Approval Timestamp"
      expr: approval_timestamp
    - name: "Approved By"
      expr: approved_by
    - name: "Changed By Name"
      expr: changed_by_name
    - name: "Changed By Role"
      expr: changed_by_role
    - name: "Competitor Name"
      expr: competitor_name
    - name: "Country Code"
      expr: country_code
    - name: "Currency Code"
      expr: currency_code
    - name: "Duration Days"
      expr: duration_days
    - name: "Forecast Category"
      expr: forecast_category
    - name: "From Stage"
      expr: from_stage
    - name: "Industry Segment"
      expr: industry_segment
    - name: "Is Current Stage"
      expr: is_current_stage
    - name: "Is Regression"
      expr: is_regression
    - name: "Next Step"
      expr: next_step
    - name: "Record Created Timestamp"
      expr: record_created_timestamp
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Opportunity Stage History"
      expr: COUNT(DISTINCT opportunity_stage_history_id)
    - name: "Total Probability Pct"
      expr: SUM(probability_pct)
    - name: "Average Probability Pct"
      expr: AVG(probability_pct)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_opportunity_supplier_sourcing`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Opportunity Supplier Sourcing business metrics"
  source: "`manufacturing_ecm`.`sales`.`opportunity_supplier_sourcing`"
  dimensions:
    - name: "Component Type"
      expr: component_type
    - name: "Created Date"
      expr: created_date
    - name: "Criticality Level"
      expr: criticality_level
    - name: "Is Preferred Supplier"
      expr: is_preferred_supplier
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Notes"
      expr: notes
    - name: "Quote Received Date"
      expr: quote_received_date
    - name: "Quote Reference Number"
      expr: quote_reference_number
    - name: "Quote Valid Until Date"
      expr: quote_valid_until_date
    - name: "Sourcing Status"
      expr: sourcing_status
    - name: "Created Date Month"
      expr: DATE_TRUNC('MONTH', created_date)
    - name: "Last Modified Timestamp Month"
      expr: DATE_TRUNC('MONTH', last_modified_timestamp)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Opportunity Supplier Sourcing"
      expr: COUNT(DISTINCT opportunity_supplier_sourcing_id)
    - name: "Total Estimated Cost"
      expr: SUM(estimated_cost)
    - name: "Average Estimated Cost"
      expr: AVG(estimated_cost)
    - name: "Total Lead Time Days"
      expr: SUM(lead_time_days)
    - name: "Average Lead Time Days"
      expr: AVG(lead_time_days)
    - name: "Total Quantity Required"
      expr: SUM(quantity_required)
    - name: "Average Quantity Required"
      expr: AVG(quantity_required)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_partner_certification`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Partner Certification business metrics"
  source: "`manufacturing_ecm`.`sales`.`partner_certification`"
  dimensions:
    - name: "Certification Body"
      expr: certification_body
    - name: "Certification Date"
      expr: certification_date
    - name: "Certification Expiry Date"
      expr: certification_expiry_date
    - name: "Certification Level"
      expr: certification_level
    - name: "Expiry Date"
      expr: expiry_date
    - name: "Last Audit Date"
      expr: last_audit_date
    - name: "Next Renewal Date"
      expr: next_renewal_date
    - name: "Specialization Tier"
      expr: specialization_tier
    - name: "Status"
      expr: status
    - name: "Certification Date Month"
      expr: DATE_TRUNC('MONTH', certification_date)
    - name: "Certification Expiry Date Month"
      expr: DATE_TRUNC('MONTH', certification_expiry_date)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Partner Certification"
      expr: COUNT(DISTINCT partner_certification_id)
    - name: "Total Certified Engineers Count"
      expr: SUM(certified_engineers_count)
    - name: "Average Certified Engineers Count"
      expr: AVG(certified_engineers_count)
    - name: "Total Training Hours Completed"
      expr: SUM(training_hours_completed)
    - name: "Average Training Hours Completed"
      expr: AVG(training_hours_completed)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_partner_rd_collaboration`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Partner Rd Collaboration business metrics"
  source: "`manufacturing_ecm`.`sales`.`partner_rd_collaboration`"
  dimensions:
    - name: "Co Development Agreement Date"
      expr: co_development_agreement_date
    - name: "Collaboration Role"
      expr: collaboration_role
    - name: "Collaboration Status"
      expr: collaboration_status
    - name: "Created Date"
      expr: created_date
    - name: "End Date"
      expr: end_date
    - name: "Ip Sharing Terms"
      expr: ip_sharing_terms
    - name: "Market Feedback Provided"
      expr: market_feedback_provided
    - name: "Modified Date"
      expr: modified_date
    - name: "Nda Reference"
      expr: nda_reference
    - name: "Start Date"
      expr: start_date
    - name: "Technical Contribution"
      expr: technical_contribution
    - name: "Co Development Agreement Date Month"
      expr: DATE_TRUNC('MONTH', co_development_agreement_date)
    - name: "Created Date Month"
      expr: DATE_TRUNC('MONTH', created_date)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Partner Rd Collaboration"
      expr: COUNT(DISTINCT partner_rd_collaboration_id)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_partner_supplier_relationship`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Partner Supplier Relationship business metrics"
  source: "`manufacturing_ecm`.`sales`.`partner_supplier_relationship`"
  dimensions:
    - name: "Conflict Of Interest Flag"
      expr: conflict_of_interest_flag
    - name: "Contract End Date"
      expr: contract_end_date
    - name: "Contract Start Date"
      expr: contract_start_date
    - name: "Created Date"
      expr: created_date
    - name: "Last Modified Date"
      expr: last_modified_date
    - name: "Partnership Type"
      expr: partnership_type
    - name: "Product Categories"
      expr: product_categories
    - name: "Relationship Status"
      expr: relationship_status
    - name: "Territory"
      expr: territory
    - name: "Contract End Date Month"
      expr: DATE_TRUNC('MONTH', contract_end_date)
    - name: "Contract Start Date Month"
      expr: DATE_TRUNC('MONTH', contract_start_date)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Partner Supplier Relationship"
      expr: COUNT(DISTINCT partner_supplier_relationship_id)
    - name: "Total Revenue Share Percentage"
      expr: SUM(revenue_share_percentage)
    - name: "Average Revenue Share Percentage"
      expr: AVG(revenue_share_percentage)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_partner_territory_authorization`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Partner Territory Authorization business metrics"
  source: "`manufacturing_ecm`.`sales`.`partner_territory_authorization`"
  dimensions:
    - name: "Authorized Service Types"
      expr: authorized_service_types
    - name: "Certification Level"
      expr: certification_level
    - name: "Coverage Days"
      expr: coverage_days
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Effective Date"
      expr: effective_date
    - name: "Expiration Date"
      expr: expiration_date
    - name: "Is 24x7 Available"
      expr: is_24x7_available
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Max Concurrent Orders"
      expr: max_concurrent_orders
    - name: "Service Capability Tier"
      expr: service_capability_tier
    - name: "Status"
      expr: status
    - name: "Territory Priority"
      expr: territory_priority
    - name: "Created Timestamp Month"
      expr: DATE_TRUNC('MONTH', created_timestamp)
    - name: "Effective Date Month"
      expr: DATE_TRUNC('MONTH', effective_date)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Partner Territory Authorization"
      expr: COUNT(DISTINCT partner_territory_authorization_id)
    - name: "Total Response Time Commitment Hours"
      expr: SUM(response_time_commitment_hours)
    - name: "Average Response Time Commitment Hours"
      expr: AVG(response_time_commitment_hours)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_quota`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Quota business metrics"
  source: "`manufacturing_ecm`.`sales`.`quota`"
  dimensions:
    - name: "Approved By"
      expr: approved_by
    - name: "Approved Timestamp"
      expr: approved_timestamp
    - name: "Attainment Basis"
      expr: attainment_basis
    - name: "Category"
      expr: category
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      expr: currency_code
    - name: "Distribution Channel"
      expr: distribution_channel
    - name: "End Date"
      expr: end_date
    - name: "Fiscal Period"
      expr: fiscal_period
    - name: "Fiscal Year"
      expr: fiscal_year
    - name: "Industry Vertical"
      expr: industry_vertical
    - name: "Modified Timestamp"
      expr: modified_timestamp
    - name: "Name"
      expr: name
    - name: "Notes"
      expr: notes
    - name: "Number"
      expr: number
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Quota"
      expr: COUNT(DISTINCT quota_id)
    - name: "Total Accelerator Threshold Pct"
      expr: SUM(accelerator_threshold_pct)
    - name: "Average Accelerator Threshold Pct"
      expr: AVG(accelerator_threshold_pct)
    - name: "Total Exchange Rate"
      expr: SUM(exchange_rate)
    - name: "Average Exchange Rate"
      expr: AVG(exchange_rate)
    - name: "Total Floor Threshold Pct"
      expr: SUM(floor_threshold_pct)
    - name: "Average Floor Threshold Pct"
      expr: AVG(floor_threshold_pct)
    - name: "Total Target Amount"
      expr: SUM(target_amount)
    - name: "Average Target Amount"
      expr: AVG(target_amount)
    - name: "Total Target Amount Usd"
      expr: SUM(target_amount_usd)
    - name: "Average Target Amount Usd"
      expr: AVG(target_amount_usd)
    - name: "Total Target Margin Pct"
      expr: SUM(target_margin_pct)
    - name: "Average Target Margin Pct"
      expr: AVG(target_margin_pct)
    - name: "Total Target Units"
      expr: SUM(target_units)
    - name: "Average Target Units"
      expr: AVG(target_units)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_rebate_accrual`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Rebate Accrual business metrics"
  source: "`manufacturing_ecm`.`sales`.`rebate_accrual`"
  dimensions:
    - name: "Accrual Date"
      expr: accrual_date
    - name: "Accrual Number"
      expr: accrual_number
    - name: "Accrual Period End Date"
      expr: accrual_period_end_date
    - name: "Accrual Period Start Date"
      expr: accrual_period_start_date
    - name: "Accrual Type"
      expr: accrual_type
    - name: "Cost Center Code"
      expr: cost_center_code
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Credit Memo Number"
      expr: credit_memo_number
    - name: "Currency Code"
      expr: currency_code
    - name: "Customer Name"
      expr: customer_name
    - name: "Customer Number"
      expr: customer_number
    - name: "Distribution Channel Code"
      expr: distribution_channel_code
    - name: "Fiscal Period"
      expr: fiscal_period
    - name: "Fiscal Year"
      expr: fiscal_year
    - name: "Gl Account Code"
      expr: gl_account_code
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Rebate Accrual"
      expr: COUNT(DISTINCT rebate_accrual_id)
    - name: "Total Accrued Amount"
      expr: SUM(accrued_amount)
    - name: "Average Accrued Amount"
      expr: AVG(accrued_amount)
    - name: "Total Accrued Amount Usd"
      expr: SUM(accrued_amount_usd)
    - name: "Average Accrued Amount Usd"
      expr: AVG(accrued_amount_usd)
    - name: "Total Exchange Rate"
      expr: SUM(exchange_rate)
    - name: "Average Exchange Rate"
      expr: AVG(exchange_rate)
    - name: "Total Outstanding Accrual Amount"
      expr: SUM(outstanding_accrual_amount)
    - name: "Average Outstanding Accrual Amount"
      expr: AVG(outstanding_accrual_amount)
    - name: "Total Qualifying Revenue Amount"
      expr: SUM(qualifying_revenue_amount)
    - name: "Average Qualifying Revenue Amount"
      expr: AVG(qualifying_revenue_amount)
    - name: "Total Rebate Rate Pct"
      expr: SUM(rebate_rate_pct)
    - name: "Average Rebate Rate Pct"
      expr: AVG(rebate_rate_pct)
    - name: "Total Settled Amount"
      expr: SUM(settled_amount)
    - name: "Average Settled Amount"
      expr: AVG(settled_amount)
    - name: "Total Tier Threshold Amount"
      expr: SUM(tier_threshold_amount)
    - name: "Average Tier Threshold Amount"
      expr: AVG(tier_threshold_amount)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_rebate_agreement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Rebate Agreement business metrics"
  source: "`manufacturing_ecm`.`sales`.`rebate_agreement`"
  dimensions:
    - name: "Accrual Method"
      expr: accrual_method
    - name: "Agreement Number"
      expr: agreement_number
    - name: "Approval Status"
      expr: approval_status
    - name: "Approved By"
      expr: approved_by
    - name: "Approved Timestamp"
      expr: approved_timestamp
    - name: "Calculation Basis"
      expr: calculation_basis
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Crm Agreement Code"
      expr: crm_agreement_code
    - name: "Currency Code"
      expr: currency_code
    - name: "Distribution Channel"
      expr: distribution_channel
    - name: "Erp Condition Number"
      expr: erp_condition_number
    - name: "Fiscal Year"
      expr: fiscal_year
    - name: "Is Combinable"
      expr: is_combinable
    - name: "Is Retroactive"
      expr: is_retroactive
    - name: "Modified Timestamp"
      expr: modified_timestamp
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Rebate Agreement"
      expr: COUNT(DISTINCT rebate_agreement_id)
    - name: "Total Accrual Rate Pct"
      expr: SUM(accrual_rate_pct)
    - name: "Average Accrual Rate Pct"
      expr: AVG(accrual_rate_pct)
    - name: "Total Base Rebate Rate Pct"
      expr: SUM(base_rebate_rate_pct)
    - name: "Average Base Rebate Rate Pct"
      expr: AVG(base_rebate_rate_pct)
    - name: "Total Max Rebate Amount"
      expr: SUM(max_rebate_amount)
    - name: "Average Max Rebate Amount"
      expr: AVG(max_rebate_amount)
    - name: "Total Max Rebate Rate Pct"
      expr: SUM(max_rebate_rate_pct)
    - name: "Average Max Rebate Rate Pct"
      expr: AVG(max_rebate_rate_pct)
    - name: "Total Min Threshold Amount"
      expr: SUM(min_threshold_amount)
    - name: "Average Min Threshold Amount"
      expr: AVG(min_threshold_amount)
    - name: "Total Prior Year Baseline Amount"
      expr: SUM(prior_year_baseline_amount)
    - name: "Average Prior Year Baseline Amount"
      expr: AVG(prior_year_baseline_amount)
    - name: "Total Target Threshold Amount"
      expr: SUM(target_threshold_amount)
    - name: "Average Target Threshold Amount"
      expr: AVG(target_threshold_amount)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_sales_price_list`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Sales Price List business metrics"
  source: "`manufacturing_ecm`.`sales`.`sales_price_list`"
  dimensions:
    - name: "Approved By"
      expr: approved_by
    - name: "Approved Date"
      expr: approved_date
    - name: "Base Price Type"
      expr: base_price_type
    - name: "Code"
      expr: code
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      expr: currency_code
    - name: "Customer Classification"
      expr: customer_classification
    - name: "Description"
      expr: description
    - name: "Distribution Channel"
      expr: distribution_channel
    - name: "Division"
      expr: division
    - name: "Incoterms"
      expr: incoterms
    - name: "Is Default"
      expr: is_default
    - name: "Is Net Price"
      expr: is_net_price
    - name: "Language Code"
      expr: language_code
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Sales Price List"
      expr: COUNT(DISTINCT sales_price_list_id)
    - name: "Total Max Discount Percent"
      expr: SUM(max_discount_percent)
    - name: "Average Max Discount Percent"
      expr: AVG(max_discount_percent)
    - name: "Total Min Order Value"
      expr: SUM(min_order_value)
    - name: "Average Min Order Value"
      expr: AVG(min_order_value)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_sales_territory`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Sales Territory business metrics"
  source: "`manufacturing_ecm`.`sales`.`sales_territory`"
  dimensions:
    - name: "Account Count Target"
      expr: account_count_target
    - name: "Code"
      expr: code
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Crm Territory Code"
      expr: crm_territory_code
    - name: "Currency Code"
      expr: currency_code
    - name: "Description"
      expr: description
    - name: "Effective End Date"
      expr: effective_end_date
    - name: "Effective Start Date"
      expr: effective_start_date
    - name: "Hierarchy Level"
      expr: hierarchy_level
    - name: "Industry Vertical"
      expr: industry_vertical
    - name: "Is Overlay"
      expr: is_overlay
    - name: "Is Strategic"
      expr: is_strategic
    - name: "Language Code"
      expr: language_code
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Model Name"
      expr: model_name
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Sales Territory"
      expr: COUNT(DISTINCT sales_territory_id)
    - name: "Total Annual Revenue Quota"
      expr: SUM(annual_revenue_quota)
    - name: "Average Annual Revenue Quota"
      expr: AVG(annual_revenue_quota)
    - name: "Total Pipeline Target"
      expr: SUM(pipeline_target)
    - name: "Average Pipeline Target"
      expr: AVG(pipeline_target)
    - name: "Total Quota Attainment Target Pct"
      expr: SUM(quota_attainment_target_pct)
    - name: "Average Quota Attainment Target Pct"
      expr: AVG(quota_attainment_target_pct)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_service_inclusion`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Service Inclusion business metrics"
  source: "`manufacturing_ecm`.`sales`.`service_inclusion`"
  dimensions:
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Last Modified Timestamp"
      expr: last_modified_timestamp
    - name: "Quantity"
      expr: quantity
    - name: "Renewal Terms"
      expr: renewal_terms
    - name: "Service Level"
      expr: service_level
    - name: "Start Date"
      expr: start_date
    - name: "Status"
      expr: status
    - name: "Created Timestamp Month"
      expr: DATE_TRUNC('MONTH', created_timestamp)
    - name: "Last Modified Timestamp Month"
      expr: DATE_TRUNC('MONTH', last_modified_timestamp)
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Service Inclusion"
      expr: COUNT(DISTINCT service_inclusion_id)
    - name: "Total Annual Contract Value"
      expr: SUM(annual_contract_value)
    - name: "Average Annual Contract Value"
      expr: AVG(annual_contract_value)
    - name: "Total Discount Pct"
      expr: SUM(discount_pct)
    - name: "Average Discount Pct"
      expr: AVG(discount_pct)
    - name: "Total Service Term Years"
      expr: SUM(service_term_years)
    - name: "Average Service Term Years"
      expr: AVG(service_term_years)
    - name: "Total Unit Price"
      expr: SUM(unit_price)
    - name: "Average Unit Price"
      expr: AVG(unit_price)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_special_pricing_request`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Special Pricing Request business metrics"
  source: "`manufacturing_ecm`.`sales`.`special_pricing_request`"
  dimensions:
    - name: "Approval Level"
      expr: approval_level
    - name: "Approved Timestamp"
      expr: approved_timestamp
    - name: "Approver Comments"
      expr: approver_comments
    - name: "Approver Decision"
      expr: approver_decision
    - name: "Approver Name"
      expr: approver_name
    - name: "Competitive Context"
      expr: competitive_context
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Crm Spr Code"
      expr: crm_spr_code
    - name: "Currency Code"
      expr: currency_code
    - name: "Erp Condition Record Number"
      expr: erp_condition_record_number
    - name: "Erp Customer Number"
      expr: erp_customer_number
    - name: "Industry Segment"
      expr: industry_segment
    - name: "Is Strategic Deal"
      expr: is_strategic_deal
    - name: "Justification"
      expr: justification
    - name: "Material Number"
      expr: material_number
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Special Pricing Request"
      expr: COUNT(DISTINCT special_pricing_request_id)
    - name: "Total Approved Discount Pct"
      expr: SUM(approved_discount_pct)
    - name: "Average Approved Discount Pct"
      expr: AVG(approved_discount_pct)
    - name: "Total Approved Price Amount"
      expr: SUM(approved_price_amount)
    - name: "Average Approved Price Amount"
      expr: AVG(approved_price_amount)
    - name: "Total Competitor Price Amount"
      expr: SUM(competitor_price_amount)
    - name: "Average Competitor Price Amount"
      expr: AVG(competitor_price_amount)
    - name: "Total Deal Amount Usd"
      expr: SUM(deal_amount_usd)
    - name: "Average Deal Amount Usd"
      expr: AVG(deal_amount_usd)
    - name: "Total Estimated Margin Pct"
      expr: SUM(estimated_margin_pct)
    - name: "Average Estimated Margin Pct"
      expr: AVG(estimated_margin_pct)
    - name: "Total Floor Price Amount"
      expr: SUM(floor_price_amount)
    - name: "Average Floor Price Amount"
      expr: AVG(floor_price_amount)
    - name: "Total List Price Amount"
      expr: SUM(list_price_amount)
    - name: "Average List Price Amount"
      expr: AVG(list_price_amount)
    - name: "Total Requested Discount Pct"
      expr: SUM(requested_discount_pct)
    - name: "Average Requested Discount Pct"
      expr: AVG(requested_discount_pct)
    - name: "Total Requested Price Amount"
      expr: SUM(requested_price_amount)
    - name: "Average Requested Price Amount"
      expr: AVG(requested_price_amount)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_team`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Team business metrics"
  source: "`manufacturing_ecm`.`sales`.`team`"
  dimensions:
    - name: "Account Name"
      expr: account_name
    - name: "Code"
      expr: code
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Crm Team Code"
      expr: crm_team_code
    - name: "Currency Code"
      expr: currency_code
    - name: "Effective End Date"
      expr: effective_end_date
    - name: "Effective Start Date"
      expr: effective_start_date
    - name: "Fiscal Year"
      expr: fiscal_year
    - name: "Industry Vertical"
      expr: industry_vertical
    - name: "Is Lead Team"
      expr: is_lead_team
    - name: "Member Count"
      expr: member_count
    - name: "Modified Timestamp"
      expr: modified_timestamp
    - name: "Name"
      expr: name
    - name: "Notes"
      expr: notes
    - name: "Region"
      expr: region
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Team"
      expr: COUNT(DISTINCT team_id)
    - name: "Total Opportunity Amount"
      expr: SUM(opportunity_amount)
    - name: "Average Opportunity Amount"
      expr: AVG(opportunity_amount)
    - name: "Total Opportunity Amount Usd"
      expr: SUM(opportunity_amount_usd)
    - name: "Average Opportunity Amount Usd"
      expr: AVG(opportunity_amount_usd)
    - name: "Total Total Commission Split Pct"
      expr: SUM(total_commission_split_pct)
    - name: "Average Total Commission Split Pct"
      expr: AVG(total_commission_split_pct)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_territory_assignment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Territory Assignment business metrics"
  source: "`manufacturing_ecm`.`sales`.`territory_assignment`"
  dimensions:
    - name: "Approval Date"
      expr: approval_date
    - name: "Approved By"
      expr: approved_by
    - name: "Assignment Number"
      expr: assignment_number
    - name: "Assignment Reason"
      expr: assignment_reason
    - name: "Assignment Type"
      expr: assignment_type
    - name: "Country Code"
      expr: country_code
    - name: "Effective Date"
      expr: effective_date
    - name: "Expiry Date"
      expr: expiry_date
    - name: "Geographic Region"
      expr: geographic_region
    - name: "Industry Vertical"
      expr: industry_vertical
    - name: "Is Overlay"
      expr: is_overlay
    - name: "Is Split Territory"
      expr: is_split_territory
    - name: "Notes"
      expr: notes
    - name: "Product Line Scope"
      expr: product_line_scope
    - name: "Quota Currency"
      expr: quota_currency
    - name: "Quota Fiscal Year"
      expr: quota_fiscal_year
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Territory Assignment"
      expr: COUNT(DISTINCT territory_assignment_id)
    - name: "Total Commission Split Percent"
      expr: SUM(commission_split_percent)
    - name: "Average Commission Split Percent"
      expr: AVG(commission_split_percent)
    - name: "Total Quota Amount"
      expr: SUM(quota_amount)
    - name: "Average Quota Amount"
      expr: AVG(quota_amount)
    - name: "Total Quota Split Percent"
      expr: SUM(quota_split_percent)
    - name: "Average Quota Split Percent"
      expr: AVG(quota_split_percent)
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_win_loss_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Win Loss Record business metrics"
  source: "`manufacturing_ecm`.`sales`.`win_loss_record`"
  dimensions:
    - name: "Action Items"
      expr: action_items
    - name: "Close Date"
      expr: close_date
    - name: "Competitor Displaced"
      expr: competitor_displaced
    - name: "Country Code"
      expr: country_code
    - name: "Created Timestamp"
      expr: created_timestamp
    - name: "Currency Code"
      expr: currency_code
    - name: "Customer Interview Conducted"
      expr: customer_interview_conducted
    - name: "Decision Criteria"
      expr: decision_criteria
    - name: "Fiscal Quarter"
      expr: fiscal_quarter
    - name: "Fiscal Year"
      expr: fiscal_year
    - name: "Industry Segment"
      expr: industry_segment
    - name: "Lessons Learned"
      expr: lessons_learned
    - name: "Modified Timestamp"
      expr: modified_timestamp
    - name: "Outcome"
      expr: outcome
    - name: "Price Competitiveness Rating"
      expr: price_competitiveness_rating
    - name: "Primary Reason"
      expr: primary_reason
  measures:
    - name: "Row Count"
      expr: COUNT(1)
    - name: "Distinct Win Loss Record"
      expr: COUNT(DISTINCT win_loss_record_id)
    - name: "Total Deal Amount"
      expr: SUM(deal_amount)
    - name: "Average Deal Amount"
      expr: AVG(deal_amount)
    - name: "Total Deal Amount Usd"
      expr: SUM(deal_amount_usd)
    - name: "Average Deal Amount Usd"
      expr: AVG(deal_amount_usd)
$$;