-- Metric views for domain: customer | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`customer_customer_opportunity`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic sales opportunity metrics tracking pipeline value, conversion rates, and sales cycle efficiency for revenue forecasting and sales performance management"
  source: "`manufacturing_ecm`.`customer`.`customer_opportunity`"
  dimensions:
    - name: "stage"
      expr: stage
      comment: "Current sales stage of the opportunity (e.g., Qualification, Proposal, Negotiation, Closed Won/Lost)"
    - name: "forecast_category"
      expr: forecast_category
      comment: "Forecast confidence category (e.g., Pipeline, Best Case, Commit, Closed)"
    - name: "sales_region"
      expr: sales_region
      comment: "Geographic sales region responsible for the opportunity"
    - name: "sales_territory"
      expr: sales_territory
      comment: "Sales territory assignment for the opportunity"
    - name: "industry_vertical"
      expr: industry_vertical
      comment: "Target industry vertical or sector for the opportunity"
    - name: "product_line"
      expr: product_line
      comment: "Primary product line associated with the opportunity"
    - name: "deal_size_category"
      expr: deal_size_category
      comment: "Deal size classification (e.g., Small, Medium, Large, Enterprise)"
    - name: "is_strategic"
      expr: is_strategic
      comment: "Flag indicating whether this is a strategic opportunity requiring executive attention"
    - name: "fiscal_quarter"
      expr: fiscal_quarter
      comment: "Fiscal quarter for expected close date"
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year for expected close date"
    - name: "account_executive"
      expr: account_executive
      comment: "Account executive or sales representative owning the opportunity"
    - name: "lead_source"
      expr: lead_source
      comment: "Original source of the sales lead (e.g., Marketing Campaign, Referral, Direct)"
  measures:
    - name: "total_opportunity_count"
      expr: COUNT(1)
      comment: "Total number of sales opportunities in the pipeline"
    - name: "total_pipeline_value"
      expr: SUM(CAST(estimated_revenue_usd AS DOUBLE))
      comment: "Total estimated revenue value of all opportunities in USD"
    - name: "weighted_pipeline_value"
      expr: SUM(CAST(estimated_revenue_usd AS DOUBLE) * CAST(probability_percent AS DOUBLE) / 100.0)
      comment: "Probability-weighted pipeline value representing expected revenue based on win probability"
    - name: "average_deal_size"
      expr: AVG(CAST(estimated_revenue_usd AS DOUBLE))
      comment: "Average estimated revenue per opportunity in USD"
    - name: "average_win_probability"
      expr: AVG(CAST(probability_percent AS DOUBLE))
      comment: "Average win probability percentage across all opportunities"
    - name: "unique_accounts"
      expr: COUNT(DISTINCT account_id)
      comment: "Number of unique customer accounts with active opportunities"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`customer_credit_profile`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customer credit risk and financial health metrics for credit management, risk assessment, and working capital optimization"
  source: "`manufacturing_ecm`.`customer`.`credit_profile`"
  dimensions:
    - name: "credit_risk_class"
      expr: credit_risk_class
      comment: "Credit risk classification tier (e.g., Low Risk, Medium Risk, High Risk)"
    - name: "credit_segment"
      expr: credit_segment
      comment: "Credit segment grouping for portfolio management"
    - name: "credit_block_status"
      expr: credit_block_status
      comment: "Whether the customer account is currently blocked for credit reasons"
    - name: "payment_behavior_code"
      expr: payment_behavior_code
      comment: "Code representing historical payment behavior pattern"
    - name: "credit_control_area"
      expr: credit_control_area
      comment: "Credit control area responsible for managing this credit profile"
    - name: "status"
      expr: status
      comment: "Current status of the credit profile (e.g., Active, Suspended, Under Review)"
  measures:
    - name: "total_credit_profiles"
      expr: COUNT(1)
      comment: "Total number of customer credit profiles"
    - name: "total_credit_limit"
      expr: SUM(CAST(credit_limit_account_currency AS DOUBLE))
      comment: "Total credit limit extended across all customer accounts"
    - name: "total_credit_exposure"
      expr: SUM(CAST(credit_exposure_amount AS DOUBLE))
      comment: "Total current credit exposure representing outstanding receivables and open orders"
    - name: "total_overdue_amount"
      expr: SUM(CAST(overdue_amount AS DOUBLE))
      comment: "Total amount of overdue receivables across all customers"
    - name: "average_credit_utilization"
      expr: AVG(CAST(credit_utilization_pct AS DOUBLE))
      comment: "Average credit utilization percentage showing how much of available credit is being used"
    - name: "average_days_sales_outstanding"
      expr: AVG(CAST(days_sales_outstanding AS DOUBLE))
      comment: "Average days sales outstanding (DSO) indicating collection efficiency"
    - name: "total_insurance_coverage"
      expr: SUM(CAST(credit_insurance_limit AS DOUBLE))
      comment: "Total credit insurance coverage limit protecting against customer default"
    - name: "unique_blocked_accounts"
      expr: COUNT(DISTINCT CASE WHEN credit_block_status = TRUE THEN account_id END)
      comment: "Number of unique customer accounts currently blocked for credit reasons"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`customer_case`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customer service case metrics for service quality, resolution efficiency, and customer satisfaction management"
  source: "`manufacturing_ecm`.`customer`.`case`"
  dimensions:
    - name: "type"
      expr: type
      comment: "Case type classification (e.g., Technical Issue, Complaint, Request, Inquiry)"
    - name: "priority"
      expr: priority
      comment: "Case priority level (e.g., Critical, High, Medium, Low)"
    - name: "status"
      expr: status
      comment: "Current case status (e.g., Open, In Progress, Resolved, Closed)"
    - name: "origin"
      expr: origin
      comment: "Channel through which the case was created (e.g., Phone, Email, Web Portal, Field Service)"
    - name: "escalation_flag"
      expr: escalation_flag
      comment: "Whether the case has been escalated to higher support tier"
    - name: "sla_breach_flag"
      expr: sla_breach_flag
      comment: "Whether the case has breached service level agreement targets"
    - name: "root_cause_category"
      expr: root_cause_category
      comment: "Root cause category for resolved cases (e.g., Product Defect, User Error, Configuration Issue)"
    - name: "service_team"
      expr: service_team
      comment: "Service team responsible for handling the case"
    - name: "warranty_claim_flag"
      expr: warranty_claim_flag
      comment: "Whether the case involves a warranty claim"
    - name: "country_code"
      expr: country_code
      comment: "Country code where the case originated"
  measures:
    - name: "total_cases"
      expr: COUNT(1)
      comment: "Total number of customer service cases"
    - name: "average_customer_satisfaction"
      expr: AVG(CAST(customer_satisfaction_score AS DOUBLE))
      comment: "Average customer satisfaction score for resolved cases"
    - name: "average_sla_target_hours"
      expr: AVG(CAST(sla_target_resolution_hours AS DOUBLE))
      comment: "Average SLA target resolution time in hours"
    - name: "unique_affected_accounts"
      expr: COUNT(DISTINCT account_id)
      comment: "Number of unique customer accounts with open or recent cases"
    - name: "unique_affected_contacts"
      expr: COUNT(DISTINCT contact_id)
      comment: "Number of unique contacts who have opened cases"
    - name: "escalated_case_count"
      expr: COUNT(CASE WHEN escalation_flag = TRUE THEN 1 END)
      comment: "Number of cases that have been escalated"
    - name: "sla_breach_count"
      expr: COUNT(CASE WHEN sla_breach_flag = TRUE THEN 1 END)
      comment: "Number of cases that have breached SLA targets"
    - name: "warranty_claim_count"
      expr: COUNT(CASE WHEN warranty_claim_flag = TRUE THEN 1 END)
      comment: "Number of cases involving warranty claims"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`customer_nps_response`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Net Promoter Score and customer feedback metrics for customer loyalty measurement and experience improvement"
  source: "`manufacturing_ecm`.`customer`.`nps_response`"
  dimensions:
    - name: "respondent_category"
      expr: respondent_category
      comment: "NPS respondent category (Promoter: 9-10, Passive: 7-8, Detractor: 0-6)"
    - name: "sentiment_category"
      expr: sentiment_category
      comment: "Sentiment analysis category of verbatim feedback (e.g., Positive, Neutral, Negative)"
    - name: "follow_up_required"
      expr: follow_up_required
      comment: "Whether the response requires follow-up action from the service team"
    - name: "follow_up_status"
      expr: follow_up_status
      comment: "Current status of follow-up action (e.g., Pending, In Progress, Completed)"
    - name: "survey_channel"
      expr: survey_channel
      comment: "Channel through which the survey was delivered (e.g., Email, SMS, Web, In-App)"
    - name: "trigger_event_type"
      expr: trigger_event_type
      comment: "Event that triggered the NPS survey (e.g., Post-Purchase, Post-Service, Periodic)"
    - name: "product_line"
      expr: product_line
      comment: "Product line associated with the NPS response"
    - name: "region"
      expr: region
      comment: "Geographic region of the respondent"
    - name: "sales_organization"
      expr: sales_organization
      comment: "Sales organization responsible for the customer relationship"
    - name: "service_type"
      expr: service_type
      comment: "Type of service that was evaluated in the survey"
  measures:
    - name: "total_responses"
      expr: COUNT(1)
      comment: "Total number of NPS survey responses received"
    - name: "average_sentiment_score"
      expr: AVG(CAST(sentiment_score AS DOUBLE))
      comment: "Average sentiment score from natural language processing of verbatim feedback"
    - name: "unique_respondent_accounts"
      expr: COUNT(DISTINCT account_id)
      comment: "Number of unique customer accounts that provided NPS feedback"
    - name: "unique_respondent_contacts"
      expr: COUNT(DISTINCT contact_id)
      comment: "Number of unique individual contacts who responded to NPS surveys"
    - name: "follow_up_required_count"
      expr: COUNT(CASE WHEN follow_up_required = TRUE THEN 1 END)
      comment: "Number of responses requiring follow-up action due to low scores or critical feedback"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`customer_pricing_agreement`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customer pricing agreement metrics for contract compliance, discount management, and pricing strategy effectiveness"
  source: "`manufacturing_ecm`.`customer`.`pricing_agreement`"
  dimensions:
    - name: "agreement_type"
      expr: agreement_type
      comment: "Type of pricing agreement (e.g., Volume Discount, Strategic Partnership, Promotional)"
    - name: "approval_status"
      expr: approval_status
      comment: "Current approval status of the pricing agreement (e.g., Draft, Pending, Approved, Rejected)"
    - name: "status"
      expr: status
      comment: "Active status of the pricing agreement (e.g., Active, Expired, Suspended)"
    - name: "scope_type"
      expr: scope_type
      comment: "Scope of the pricing agreement (e.g., Account-Specific, Product-Specific, Global)"
    - name: "sales_organization"
      expr: sales_organization
      comment: "Sales organization that owns the pricing agreement"
    - name: "distribution_channel"
      expr: distribution_channel
      comment: "Distribution channel covered by the pricing agreement"
    - name: "is_exclusive"
      expr: is_exclusive
      comment: "Whether the pricing agreement is exclusive to the customer"
    - name: "is_retroactive"
      expr: is_retroactive
      comment: "Whether the pricing agreement applies retroactively to past orders"
    - name: "renewal_type"
      expr: renewal_type
      comment: "Renewal type for the agreement (e.g., Auto-Renew, Manual, Non-Renewable)"
  measures:
    - name: "total_agreements"
      expr: COUNT(1)
      comment: "Total number of pricing agreements"
    - name: "average_discount_percentage"
      expr: AVG(CAST(discount_percentage AS DOUBLE))
      comment: "Average discount percentage across all pricing agreements"
    - name: "average_rebate_percentage"
      expr: AVG(CAST(rebate_percentage AS DOUBLE))
      comment: "Average rebate percentage offered in pricing agreements"
    - name: "total_target_volume"
      expr: SUM(CAST(target_volume AS DOUBLE))
      comment: "Total target volume commitment across all pricing agreements"
    - name: "total_minimum_order_value"
      expr: SUM(CAST(minimum_order_value AS DOUBLE))
      comment: "Total minimum order value requirements across all agreements"
    - name: "average_price_per_quantity"
      expr: AVG(CAST(price_per_quantity AS DOUBLE))
      comment: "Average contracted price per quantity unit"
    - name: "unique_customer_accounts"
      expr: COUNT(DISTINCT account_id)
      comment: "Number of unique customer accounts with active pricing agreements"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`customer_account_contract`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customer contract value and lifecycle metrics for revenue recognition, renewal management, and contract portfolio optimization"
  source: "`manufacturing_ecm`.`customer`.`account_contract`"
  dimensions:
    - name: "renewal_status"
      expr: renewal_status
      comment: "Current renewal status of the contract (e.g., Up for Renewal, Renewed, Expired, Cancelled)"
    - name: "billing_frequency"
      expr: billing_frequency
      comment: "Billing frequency for the contract (e.g., Monthly, Quarterly, Annually)"
    - name: "service_scope"
      expr: service_scope
      comment: "Scope of services covered by the contract"
    - name: "account_manager"
      expr: account_manager
      comment: "Account manager responsible for the contract relationship"
  measures:
    - name: "total_contracts"
      expr: COUNT(1)
      comment: "Total number of customer contracts"
    - name: "total_contract_value"
      expr: SUM(CAST(contract_value AS DOUBLE))
      comment: "Total contract value representing committed revenue across all customer contracts"
    - name: "average_contract_value"
      expr: AVG(CAST(contract_value AS DOUBLE))
      comment: "Average contract value per customer agreement"
    - name: "unique_contracted_accounts"
      expr: COUNT(DISTINCT account_id)
      comment: "Number of unique customer accounts with active contracts"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`customer_interaction`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customer interaction and engagement metrics for relationship quality, touchpoint effectiveness, and customer experience optimization"
  source: "`manufacturing_ecm`.`customer`.`interaction`"
  dimensions:
    - name: "channel"
      expr: channel
      comment: "Communication channel used for the interaction (e.g., Phone, Email, In-Person, Web Chat)"
    - name: "type"
      expr: type
      comment: "Type of interaction (e.g., Sales Call, Support Request, Follow-Up, Meeting)"
    - name: "direction"
      expr: direction
      comment: "Direction of the interaction (Inbound from customer or Outbound from company)"
    - name: "outcome"
      expr: outcome
      comment: "Outcome of the interaction (e.g., Successful, No Answer, Scheduled Follow-Up)"
    - name: "sentiment"
      expr: sentiment
      comment: "Customer sentiment detected during the interaction (e.g., Positive, Neutral, Negative)"
    - name: "priority"
      expr: priority
      comment: "Priority level of the interaction (e.g., High, Medium, Low)"
    - name: "status"
      expr: status
      comment: "Current status of the interaction (e.g., Completed, Pending, Cancelled)"
    - name: "is_escalated"
      expr: is_escalated
      comment: "Whether the interaction was escalated to higher management or specialized team"
    - name: "assigned_representative_role"
      expr: assigned_representative_role
      comment: "Role of the representative handling the interaction (e.g., Sales Rep, Support Agent, Account Manager)"
  measures:
    - name: "total_interactions"
      expr: COUNT(1)
      comment: "Total number of customer interactions across all channels and types"
    - name: "unique_interacting_accounts"
      expr: COUNT(DISTINCT account_id)
      comment: "Number of unique customer accounts with recorded interactions"
    - name: "unique_interacting_contacts"
      expr: COUNT(DISTINCT contact_id)
      comment: "Number of unique individual contacts with recorded interactions"
    - name: "escalated_interaction_count"
      expr: COUNT(CASE WHEN is_escalated = TRUE THEN 1 END)
      comment: "Number of interactions that required escalation"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`customer_contact`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Customer contact engagement and data quality metrics for relationship management and marketing effectiveness"
  source: "`manufacturing_ecm`.`customer`.`contact`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current status of the contact record (e.g., Active, Inactive, Bounced, Unsubscribed)"
    - name: "role"
      expr: role
      comment: "Business role of the contact (e.g., Decision Maker, Influencer, User, Gatekeeper)"
    - name: "is_decision_maker"
      expr: is_decision_maker
      comment: "Whether the contact has decision-making authority for purchases"
    - name: "is_influencer"
      expr: is_influencer
      comment: "Whether the contact influences purchasing decisions"
    - name: "is_primary_contact"
      expr: is_primary_contact
      comment: "Whether this is the primary contact for the account"
    - name: "email_opt_in"
      expr: email_opt_in
      comment: "Whether the contact has opted in to receive email communications"
    - name: "email_opt_out"
      expr: email_opt_out
      comment: "Whether the contact has opted out of email communications"
    - name: "gdpr_consent_status"
      expr: gdpr_consent_status
      comment: "GDPR consent status for data processing (e.g., Granted, Withdrawn, Pending)"
    - name: "lead_source"
      expr: lead_source
      comment: "Original source of the contact (e.g., Trade Show, Website, Referral, Campaign)"
    - name: "department"
      expr: department
      comment: "Department or functional area of the contact"
  measures:
    - name: "total_contacts"
      expr: COUNT(1)
      comment: "Total number of customer contacts in the database"
    - name: "unique_associated_accounts"
      expr: COUNT(DISTINCT account_id)
      comment: "Number of unique customer accounts with associated contacts"
    - name: "decision_maker_count"
      expr: COUNT(CASE WHEN is_decision_maker = TRUE THEN 1 END)
      comment: "Number of contacts identified as decision makers"
    - name: "influencer_count"
      expr: COUNT(CASE WHEN is_influencer = TRUE THEN 1 END)
      comment: "Number of contacts identified as influencers in the buying process"
    - name: "email_opt_in_count"
      expr: COUNT(CASE WHEN email_opt_in = TRUE THEN 1 END)
      comment: "Number of contacts who have opted in to email marketing communications"
$$;