-- Metric views for domain: sales | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 09:35:49

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_account_plan`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic account planning KPIs for industrial B2B accounts. Tracks revenue targets, whitespace opportunity, budget allocation, and customer satisfaction across the account plan portfolio. Used by Sales Directors and Key Account Managers to prioritise accounts, allocate pre-sales resources, and steer annual planning cycles."
  source: "`manufacturing_ecm`.`sales`.`account_plan`"
  filter: status = 'active'
  dimensions:
    - name: "region"
      expr: region
      comment: "Internal sales region (e.g., North America, EMEA, APAC) for geographic performance segmentation."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the account, enabling country-level planning analysis."
    - name: "industry_vertical"
      expr: industry_vertical
      comment: "Industry sector of the account (e.g., automotive, oil and gas) for vertical-specific planning insights."
    - name: "plan_year"
      expr: CAST(plan_year AS STRING)
      comment: "Fiscal or calendar year of the account plan for year-over-year comparison."
    - name: "plan_type"
      expr: plan_type
      comment: "Planning horizon classification: annual, multi-year, quarterly, or campaign."
    - name: "sales_motion"
      expr: sales_motion
      comment: "Go-to-market approach: direct, channel, or hybrid."
    - name: "competitive_position"
      expr: competitive_position
      comment: "Competitive standing within the account: incumbent, challenger, new entrant, preferred vendor, sole source, or at risk."
    - name: "key_solution_focus"
      expr: key_solution_focus
      comment: "Primary solution category targeted for growth (automation, electrification, smart infrastructure)."
    - name: "relationship_strength"
      expr: relationship_strength
      comment: "Qualitative depth of the business relationship with the account."
    - name: "is_global_account"
      expr: is_global_account
      comment: "Flag indicating whether the account is managed as a global strategic account."
    - name: "plan_start_date"
      expr: plan_start_date
      comment: "Start date of the account plan period for time-series analysis."
    - name: "approved_date"
      expr: approved_date
      comment: "Date the account plan was formally approved, used for planning cycle tracking."
  measures:
    - name: "total_revenue_target"
      expr: SUM(CAST(revenue_target_amount AS DOUBLE))
      comment: "Total committed revenue target across all active account plans. Core top-line planning KPI used in QBRs and annual sales planning to assess aggregate ambition vs. prior year baseline."
    - name: "total_whitespace_opportunity"
      expr: SUM(CAST(whitespace_opportunity_amount AS DOUBLE))
      comment: "Total estimated addressable revenue from untapped product lines across accounts. Drives expansion strategy and resource allocation decisions for new footprint growth."
    - name: "total_budget_allocated"
      expr: SUM(CAST(budget_allocated_amount AS DOUBLE))
      comment: "Total internal sales budget allocated across account plans (travel, MDF, pre-sales engineering). Used by Sales Ops to govern spend efficiency and ROI on account investment."
    - name: "avg_revenue_target_per_plan"
      expr: AVG(CAST(revenue_target_amount AS DOUBLE))
      comment: "Average revenue target per account plan. Benchmarks ambition level per account and identifies outliers requiring management attention."
    - name: "avg_customer_satisfaction_score"
      expr: AVG(CAST(customer_satisfaction_score AS DOUBLE))
      comment: "Average NPS/CSAT score across active account plans. Leading indicator of retention risk and renewal probability; triggers executive intervention when below threshold."
    - name: "total_prior_year_revenue"
      expr: SUM(CAST(prior_year_revenue_amount AS DOUBLE))
      comment: "Total actual revenue from prior fiscal year across accounts. Baseline for year-over-year growth target-setting and portfolio performance benchmarking."
    - name: "active_account_plan_count"
      expr: COUNT(1)
      comment: "Number of active strategic account plans. Indicates breadth of managed account coverage and sales capacity utilisation."
    - name: "global_account_plan_count"
      expr: COUNT(CASE WHEN is_global_account = TRUE THEN 1 END)
      comment: "Number of active plans for globally managed strategic accounts. Used to track executive-level account coverage and cross-regional coordination requirements."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_activity`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Sales engagement activity KPIs tracking field visit cadence, technical support demand, key account coverage, and activity outcomes. Used by Sales Managers and Revenue Operations to assess pipeline progression, rep productivity, and engagement quality across territories and product families."
  source: "`manufacturing_ecm`.`sales`.`activity`"
  filter: status IN ('completed', 'planned')
  dimensions:
    - name: "activity_date"
      expr: date
      comment: "Calendar date of the sales activity for time-series engagement cadence analysis."
    - name: "activity_type"
      expr: type
      comment: "Classification of the activity: field visit, technical demo, RFQ response, etc."
    - name: "outcome"
      expr: outcome
      comment: "Result of the activity: advanced, neutral, or negative signal."
    - name: "opportunity_stage"
      expr: opportunity_stage
      comment: "Pipeline stage of the associated opportunity at the time of the activity."
    - name: "channel"
      expr: channel
      comment: "Sales channel through which the activity was conducted: direct or channel/partner."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code where the activity took place."
    - name: "industry_segment"
      expr: industry_segment
      comment: "Industry vertical of the customer account targeted in the activity."
    - name: "product_family"
      expr: product_family
      comment: "Product family featured in the activity (e.g., PLC systems, drives, switchgear)."
    - name: "solution_type"
      expr: solution_type
      comment: "Industrial solution category discussed: automation, electrification, smart infrastructure."
    - name: "is_key_account"
      expr: is_key_account
      comment: "Flag indicating whether the activity is associated with a strategically designated key account."
    - name: "location_type"
      expr: location_type
      comment: "Venue type: on-site visit, virtual meeting, factory tour, trade show."
    - name: "priority"
      expr: priority
      comment: "Business priority level assigned to the activity."
    - name: "owner_name"
      expr: owner_name
      comment: "Sales representative or account manager who owns the activity."
  measures:
    - name: "total_activities"
      expr: COUNT(1)
      comment: "Total number of sales engagement activities. Core volume KPI for sales cadence management and rep productivity benchmarking."
    - name: "key_account_activities"
      expr: COUNT(CASE WHEN is_key_account = TRUE THEN 1 END)
      comment: "Number of activities on strategically designated key accounts. Ensures elevated engagement standards are being met for highest-value accounts."
    - name: "technical_support_activities"
      expr: COUNT(CASE WHEN requires_technical_support = TRUE THEN 1 END)
      comment: "Number of activities requiring pre-sales engineering or technical consultant involvement. Drives resource planning for technical sales support capacity."
    - name: "positive_outcome_activities"
      expr: COUNT(CASE WHEN outcome = 'advanced' THEN 1 END)
      comment: "Number of activities that advanced the associated opportunity. Leading indicator of pipeline progression velocity and engagement effectiveness."
    - name: "unique_accounts_engaged"
      expr: COUNT(DISTINCT contact_id)
      comment: "Number of distinct customer contacts engaged through sales activities. Measures breadth of customer relationship coverage across the portfolio."
    - name: "unique_campaigns_activated"
      expr: COUNT(DISTINCT campaign_id)
      comment: "Number of distinct campaigns driving field sales activity. Measures campaign-to-field activation effectiveness for marketing ROI analysis."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_campaign`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Sales campaign performance KPIs covering budget deployment, revenue targets, pipeline generation goals, and lead targets. Used by Marketing and Sales leadership to evaluate campaign ROI, prioritise investment across product families and regions, and steer go-to-market execution."
  source: "`manufacturing_ecm`.`sales`.`campaign`"
  filter: status IN ('active', 'completed')
  dimensions:
    - name: "campaign_type"
      expr: type
      comment: "Commercial purpose: product launch, end-of-life promotion, vertical market initiative."
    - name: "region"
      expr: region
      comment: "Geographic region of campaign execution for regional revenue attribution."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of primary campaign execution country."
    - name: "industry_vertical"
      expr: industry_vertical
      comment: "Target industry vertical for the campaign."
    - name: "product_family"
      expr: product_family
      comment: "Primary product family associated with the campaign."
    - name: "solution_type"
      expr: solution_type
      comment: "Industrial solution category being promoted: automation, electrification, smart infrastructure."
    - name: "sales_motion"
      expr: sales_motion
      comment: "Go-to-market model: direct, channel, distributor, OEM, hybrid."
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of campaign execution for annual budget and performance alignment."
    - name: "fiscal_quarter"
      expr: fiscal_quarter
      comment: "Fiscal quarter of primary campaign activity for quarterly planning alignment."
    - name: "priority"
      expr: priority
      comment: "Business priority level of the campaign for resource allocation decisions."
    - name: "is_global"
      expr: is_global
      comment: "Flag indicating whether the campaign is executed globally or regionally."
    - name: "theme"
      expr: theme
      comment: "Strategic messaging pillar: Digital Transformation, Sustainable Manufacturing, Industry 4.0."
    - name: "start_date"
      expr: start_date
      comment: "Campaign start date for scheduling and duration analysis."
  measures:
    - name: "total_budget_usd"
      expr: SUM(CAST(budget_amount_usd AS DOUBLE))
      comment: "Total approved campaign budget in USD across all active/completed campaigns. Primary investment KPI for marketing spend governance and ROI measurement."
    - name: "total_revenue_target_usd"
      expr: SUM(CAST(revenue_target_usd AS DOUBLE))
      comment: "Total expected revenue from campaigns in USD. Used to assess aggregate commercial ambition and pipeline coverage from campaign-driven demand generation."
    - name: "total_pipeline_target"
      expr: SUM(CAST(pipeline_target_amount AS DOUBLE))
      comment: "Total target pipeline value expected to be generated by campaigns. Supports pipeline coverage ratio analysis and S&OP demand planning."
    - name: "avg_budget_per_campaign_usd"
      expr: AVG(CAST(budget_amount_usd AS DOUBLE))
      comment: "Average budget per campaign in USD. Benchmarks investment intensity and identifies over- or under-funded campaigns relative to revenue targets."
    - name: "avg_revenue_target_per_campaign_usd"
      expr: AVG(CAST(revenue_target_usd AS DOUBLE))
      comment: "Average revenue target per campaign in USD. Used to assess expected return per campaign investment and compare campaign efficiency across regions and product families."
    - name: "active_campaign_count"
      expr: COUNT(1)
      comment: "Number of active or completed campaigns. Measures go-to-market execution breadth and campaign portfolio size."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_forecast`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Sales forecast accuracy and pipeline KPIs for S&OP and financial planning. Tracks forecasted revenue, margin, units, quota coverage, and forecast-to-quota variance across product families, territories, and fiscal periods. Used by Sales Directors, Finance Controllers, and S&OP teams to manage revenue risk and production planning."
  source: "`manufacturing_ecm`.`sales`.`forecast`"
  filter: status IN ('approved', 'submitted')
  dimensions:
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period (Q1–Q4 or P01–P12) to which the forecast applies."
    - name: "product_family"
      expr: product_family
      comment: "High-level product family grouping: Industrial Automation, Electrification Solutions, Smart Infrastructure, Motion Control."
    - name: "region_code"
      expr: region_code
      comment: "Geographic region code (AMER, EMEA, APAC) for regional S&OP aggregation."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code for country-level revenue recognition forecasting."
    - name: "industry_vertical"
      expr: industry_vertical
      comment: "End-customer industry vertical for vertical-specific pipeline analysis."
    - name: "distribution_channel"
      expr: distribution_channel
      comment: "Sales channel through which forecasted revenue is expected: direct, channel partner, distributor, OEM, EPC."
    - name: "sales_motion"
      expr: sales_motion
      comment: "Go-to-market motion: direct, channel, hybrid, OEM, EPC, service."
    - name: "cycle_type"
      expr: cycle_type
      comment: "Forecast cadence: monthly, quarterly, annual, or rolling 12-month."
    - name: "confidence_level"
      expr: confidence_level
      comment: "Qualitative reliability rating: high, medium, low."
    - name: "category"
      expr: category
      comment: "CRM forecast category: commit (high confidence) or pipeline (early-stage)."
    - name: "forecast_type"
      expr: type
      comment: "Forecast dimension: revenue, units, margin, bookings, or pipeline."
    - name: "period_start_date"
      expr: period_start_date
      comment: "Start date of the forecast period for time-series alignment."
    - name: "product_line_code"
      expr: product_line_code
      comment: "Specific product line code within the product family for granular attainment tracking."
  measures:
    - name: "total_forecasted_revenue_usd"
      expr: SUM(CAST(forecasted_revenue_usd AS DOUBLE))
      comment: "Total forecasted gross revenue in USD across all approved/submitted forecasts. Primary top-line planning KPI for board reporting and financial consolidation."
    - name: "total_forecasted_margin"
      expr: SUM(CAST(forecasted_margin_amount AS DOUBLE))
      comment: "Total projected gross margin across forecasts. Core profitability planning KPI used in S&OP reviews and EBITDA forecasting."
    - name: "total_forecasted_units"
      expr: SUM(CAST(forecasted_units AS DOUBLE))
      comment: "Total projected unit volume across forecasts. Drives production planning (MRP) and capacity scheduling in manufacturing S&OP."
    - name: "total_quota_amount"
      expr: SUM(CAST(quota_amount AS DOUBLE))
      comment: "Total quota target against which forecasts are measured. Enables aggregate quota coverage analysis and identifies under-forecasted territories."
    - name: "total_variance_to_quota"
      expr: SUM(CAST(variance_to_quota_amount AS DOUBLE))
      comment: "Net forecast-to-quota variance (positive = over-forecast, negative = under-forecast). Critical risk indicator for revenue attainment; triggers management intervention when significantly negative."
    - name: "avg_forecasted_margin_pct"
      expr: AVG(CAST(forecasted_margin_pct AS DOUBLE))
      comment: "Average projected gross margin percentage across forecasts. Key profitability KPI for S&OP and financial planning; flags margin erosion trends requiring pricing or cost action."
    - name: "avg_forecast_probability"
      expr: AVG(CAST(probability_pct AS DOUBLE))
      comment: "Average probability of forecast realisation across the portfolio. Used for risk-adjusted revenue forecasting and weighted pipeline calculations."
    - name: "forecast_record_count"
      expr: COUNT(1)
      comment: "Number of approved/submitted forecast records. Measures forecast submission completeness and S&OP process compliance."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_lead`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Lead pipeline quality and conversion KPIs for industrial automation and electrification sales. Tracks lead volume, conversion rates, estimated deal value, and funnel health by source, segment, and territory. Used by Marketing, Inside Sales, and Revenue Operations to optimise demand generation ROI and pipeline entry quality."
  source: "`manufacturing_ecm`.`sales`.`lead`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the lead: new, working, qualified, converted, disqualified."
    - name: "qualification_status"
      expr: qualification_status
      comment: "BANT qualification assessment: qualified, unqualified, in progress."
    - name: "source"
      expr: source
      comment: "Lead generation channel: trade show, web, referral, campaign, partner, etc."
    - name: "industry_segment"
      expr: industry_segment
      comment: "Industry vertical of the prospect for segment-specific funnel analysis."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the prospect for geographic pipeline analysis."
    - name: "product_interest"
      expr: product_interest
      comment: "Primary product or solution category the lead expressed interest in."
    - name: "project_type"
      expr: project_type
      comment: "Greenfield (new build) or brownfield (retrofit/upgrade) project classification."
    - name: "rating"
      expr: rating
      comment: "Sales team urgency assessment: hot, warm, cold."
    - name: "sales_channel"
      expr: sales_channel
      comment: "Direct or indirect (partner/distributor/OEM) pursuit channel."
    - name: "purchase_timeframe"
      expr: purchase_timeframe
      comment: "Prospect's indicated purchase decision timeframe for pipeline forecasting."
    - name: "assigned_owner"
      expr: assigned_owner
      comment: "Sales representative responsible for working the lead."
    - name: "created_date"
      expr: CAST(created_timestamp AS DATE)
      comment: "Date the lead was created, used for funnel entry time-series analysis."
    - name: "converted_date"
      expr: converted_date
      comment: "Date the lead was converted to an opportunity, used for conversion cycle time analysis."
  measures:
    - name: "total_leads"
      expr: COUNT(1)
      comment: "Total number of leads in the pipeline. Core funnel volume KPI for demand generation capacity planning and marketing investment decisions."
    - name: "converted_leads"
      expr: COUNT(CASE WHEN is_converted = TRUE THEN 1 END)
      comment: "Number of leads successfully converted to qualified opportunities. Numerator for lead conversion rate; directly measures demand generation effectiveness."
    - name: "qualified_leads"
      expr: COUNT(CASE WHEN qualification_status = 'qualified' THEN 1 END)
      comment: "Number of leads that have passed BANT qualification criteria. Measures pipeline entry quality and sales readiness of the lead pool."
    - name: "total_estimated_deal_value"
      expr: SUM(CAST(estimated_deal_value AS DOUBLE))
      comment: "Total estimated contract value across all leads. Provides early-stage pipeline value signal for territory planning and capacity forecasting."
    - name: "avg_estimated_deal_value"
      expr: AVG(CAST(estimated_deal_value AS DOUBLE))
      comment: "Average estimated deal value per lead. Benchmarks deal size expectations and identifies high-value lead segments requiring prioritised pursuit."
    - name: "unique_campaigns_generating_leads"
      expr: COUNT(DISTINCT campaign_id)
      comment: "Number of distinct campaigns that generated at least one lead. Measures campaign activation breadth and identifies which campaigns are driving pipeline entry."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_opportunity_competitor`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Competitive win/loss intelligence KPIs for industrial automation and electrification opportunities. Tracks competitive engagement outcomes, incumbent displacement rates, price differential patterns, and win/loss review compliance. Used by Sales Directors, Product Management, and Competitive Intelligence teams to steer competitive strategy and prioritise battlecard investment."
  source: "`manufacturing_ecm`.`sales`.`opportunity_competitor`"
  filter: status IN ('won', 'lost', 'no_decision')
  dimensions:
    - name: "outcome"
      expr: outcome
      comment: "Win/loss outcome relative to this competitor: won, lost, or no decision."
    - name: "region"
      expr: region
      comment: "Sales region where the competitive engagement occurred."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the competitive engagement market."
    - name: "industry_segment"
      expr: industry_segment
      comment: "Industry vertical of the customer account for segment-level competitive analysis."
    - name: "solution_type"
      expr: solution_type
      comment: "Type of solution proposed by the competitor: product sale, turnkey project, service contract."
    - name: "loss_reason"
      expr: loss_reason
      comment: "Primary reason for losing to this competitor, used for corrective action planning."
    - name: "displacement_strategy"
      expr: displacement_strategy
      comment: "Strategy used to displace or counter the competitor in the opportunity."
    - name: "competitive_strength"
      expr: competitive_strength
      comment: "Sales rep's assessment of the competitor's relative strength in this opportunity."
    - name: "win_theme_used"
      expr: win_theme_used
      comment: "Primary win theme used to differentiate against the competitor."
    - name: "incumbent_flag"
      expr: incumbent_flag
      comment: "Flag indicating whether the competitor is the incumbent supplier at the account."
    - name: "identified_date"
      expr: identified_date
      comment: "Date the competitor was first identified in the opportunity for competitive timeline analysis."
  measures:
    - name: "total_competitive_engagements"
      expr: COUNT(1)
      comment: "Total number of competitive opportunity engagements. Measures the volume of deals where competitive intelligence is required and battlecard deployment is tracked."
    - name: "won_engagements"
      expr: COUNT(CASE WHEN outcome = 'won' THEN 1 END)
      comment: "Number of opportunities won against competitors. Numerator for win rate calculation; directly measures competitive effectiveness."
    - name: "lost_engagements"
      expr: COUNT(CASE WHEN outcome = 'lost' THEN 1 END)
      comment: "Number of opportunities lost to competitors. Drives corrective action in product, pricing, and sales strategy."
    - name: "incumbent_displacement_attempts"
      expr: COUNT(CASE WHEN incumbent_flag = TRUE THEN 1 END)
      comment: "Number of competitive engagements where the competitor is the incumbent supplier. Measures the scale of displacement challenge in the pipeline."
    - name: "incumbent_displacement_wins"
      expr: COUNT(CASE WHEN incumbent_flag = TRUE AND outcome = 'won' THEN 1 END)
      comment: "Number of successful incumbent displacements. Strategic KPI for measuring competitive market share capture from entrenched competitors."
    - name: "win_loss_reviews_completed"
      expr: COUNT(CASE WHEN win_loss_review_completed = TRUE THEN 1 END)
      comment: "Number of competitive engagements with a completed win/loss review debrief. Measures sales process compliance and quality of competitive intelligence capture."
    - name: "avg_price_differential_pct"
      expr: AVG(CAST(price_differential_pct AS DOUBLE))
      comment: "Average percentage price differential between our price and the competitor's estimated price. Positive = we are priced higher; negative = we are priced lower. Informs pricing strategy and discount authority decisions."
    - name: "unique_competitors_tracked"
      expr: COUNT(DISTINCT competitor_id)
      comment: "Number of distinct competitors actively tracked across the opportunity pipeline. Measures competitive intelligence coverage breadth."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_quota`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Sales quota planning and attainment baseline KPIs for industrial product lines and territories. Tracks quota target deployment, unit targets, margin targets, and quota portfolio composition by region, product family, and sales motion. Used by Sales Management and Finance to govern quota setting, monitor attainment risk, and align incentive compensation."
  source: "`manufacturing_ecm`.`sales`.`quota`"
  filter: status IN ('active', 'approved')
  dimensions:
    - name: "fiscal_year"
      expr: CAST(fiscal_year AS STRING)
      comment: "Fiscal year of the quota for annual planning and year-over-year comparison."
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Specific fiscal period (Q1–Q4, M01–M12) for period-level attainment tracking."
    - name: "region_code"
      expr: region_code
      comment: "Geographic region code (AMER, EMEA, APAC) for regional quota aggregation."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code for country-level quota analysis."
    - name: "product_family"
      expr: product_family
      comment: "Industrial product family in scope for the quota: Automation Systems, Electrification Solutions, Smart Infrastructure."
    - name: "quota_type"
      expr: type
      comment: "Quota measurement basis: revenue, units, margin, activity, or pipeline."
    - name: "category"
      expr: category
      comment: "Quota assignment category: individual rep, team, territory, channel partner, or overlay specialist."
    - name: "sales_motion"
      expr: sales_motion
      comment: "Direct, channel, or hybrid sales motion for the quota."
    - name: "distribution_channel"
      expr: distribution_channel
      comment: "Distribution channel through which quota attainment is measured."
    - name: "industry_vertical"
      expr: industry_vertical
      comment: "Target industry vertical for vertical-specific quota performance analysis."
    - name: "period_type"
      expr: period_type
      comment: "Time granularity of the quota cycle: monthly, quarterly, semi-annual, or annual."
    - name: "attainment_basis"
      expr: attainment_basis
      comment: "Measurement basis for attainment: booked_revenue, invoiced_revenue, shipped_units, gross_margin."
    - name: "start_date"
      expr: start_date
      comment: "Start date of the quota period for active window determination."
  measures:
    - name: "total_quota_target_usd"
      expr: SUM(CAST(target_amount_usd AS DOUBLE))
      comment: "Total quota target in USD across all active/approved quotas. Primary revenue commitment KPI for board reporting and financial planning consolidation."
    - name: "total_quota_target_local"
      expr: SUM(CAST(target_amount AS DOUBLE))
      comment: "Total quota target in local transaction currency. Used for territory-level attainment tracking and local commission calculation."
    - name: "total_unit_quota_target"
      expr: SUM(CAST(target_units AS DOUBLE))
      comment: "Total unit quota target across all active quotas. Drives production planning and capacity scheduling in manufacturing S&OP."
    - name: "avg_target_margin_pct"
      expr: AVG(CAST(target_margin_pct AS DOUBLE))
      comment: "Average target gross margin percentage across margin-based quotas. Measures the profitability ambition embedded in the incentive compensation structure."
    - name: "avg_accelerator_threshold_pct"
      expr: AVG(CAST(accelerator_threshold_pct AS DOUBLE))
      comment: "Average quota attainment percentage at which accelerated commission rates are triggered. Benchmarks incentive plan aggressiveness and overperformance incentive design."
    - name: "active_quota_count"
      expr: COUNT(1)
      comment: "Number of active or approved quota records. Measures quota deployment completeness and identifies territories or reps without active quotas."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`sales_territory_assignment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Territory coverage and quota allocation KPIs for industrial sales force management. Tracks territory quota deployment, commission split structures, overlay coverage, and split-territory complexity. Used by Sales Operations and HR Compensation teams to govern territory design, ensure full coverage, and manage incentive plan integrity."
  source: "`manufacturing_ecm`.`sales`.`territory_assignment`"
  filter: status = 'active'
  dimensions:
    - name: "geographic_region"
      expr: geographic_region
      comment: "Named geographic region covered by the territory assignment (e.g., Northeast US, DACH, Southeast Asia)."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of the territory assignment."
    - name: "assignment_type"
      expr: assignment_type
      comment: "Role classification: primary, secondary, overlay, backup, channel, or split."
    - name: "sales_motion"
      expr: sales_motion
      comment: "Direct, indirect/channel, or hybrid sales motion for the territory."
    - name: "industry_vertical"
      expr: industry_vertical
      comment: "Target industry vertical covered by the territory assignment."
    - name: "sales_role"
      expr: sales_role
      comment: "Functional sales role of the assigned representative for commission plan mapping."
    - name: "is_overlay"
      expr: is_overlay
      comment: "Flag indicating whether this is an overlay specialist role vs. a direct territory owner."
    - name: "is_split_territory"
      expr: is_split_territory
      comment: "Flag indicating whether the territory is shared among multiple reps requiring quota splits."
    - name: "quota_fiscal_year"
      expr: CAST(quota_fiscal_year AS STRING)
      comment: "Fiscal year to which the territory quota applies."
    - name: "quota_period_type"
      expr: quota_period_type
      comment: "Time granularity of the quota cycle: annual, semi-annual, quarterly, or monthly."
    - name: "sales_organization_code"
      expr: sales_organization_code
      comment: "SAP S/4HANA sales organization code for ERP-aligned revenue reporting."
    - name: "effective_date"
      expr: effective_date
      comment: "Date the territory assignment became active."
  measures:
    - name: "total_territory_quota"
      expr: SUM(CAST(quota_amount AS DOUBLE))
      comment: "Total revenue quota deployed across all active territory assignments. Measures aggregate sales force quota coverage and identifies uncovered territories."
    - name: "avg_commission_split_pct"
      expr: AVG(CAST(commission_split_percent AS DOUBLE))
      comment: "Average commission split percentage across territory assignments. Benchmarks incentive plan design and identifies anomalous split structures requiring governance review."
    - name: "avg_quota_split_pct"
      expr: AVG(CAST(quota_split_percent AS DOUBLE))
      comment: "Average quota split percentage across territory assignments. Used to validate that quota splits sum correctly across shared territories and detect governance gaps."
    - name: "active_assignment_count"
      expr: COUNT(1)
      comment: "Total number of active territory assignments. Measures sales force coverage breadth and identifies capacity gaps in territory management."
    - name: "overlay_assignment_count"
      expr: COUNT(CASE WHEN is_overlay = TRUE THEN 1 END)
      comment: "Number of active overlay specialist assignments. Measures specialist resource deployment and technical sales support coverage across the territory portfolio."
    - name: "split_territory_assignment_count"
      expr: COUNT(CASE WHEN is_split_territory = TRUE THEN 1 END)
      comment: "Number of active assignments in split-territory scenarios. Measures complexity of territory management and commission governance burden for Sales Operations."
    - name: "unique_territories_covered"
      expr: COUNT(DISTINCT sales_territory_id)
      comment: "Number of distinct territories with at least one active assignment. Measures geographic coverage completeness and identifies uncovered territories."
$$;