-- Schema for Domain: marketing | Business:  | Version: v2_ecm
-- Generated on: 2026-07-12 13:53:23

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`marketing` COMMENT 'Manages marketing campaigns, audience targeting, media spend, attribution analytics, email/SMS marketing automation, social media engagement, and brand management across all retail channels. Distinct from promotion (which owns deal mechanics and redemption) — marketing owns the upstream campaign strategy, channel execution, and ROI measurement.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`campaign` (
    `campaign_id` BIGINT COMMENT 'Unique identifier for the marketing campaign. Primary key.',
    `associate_id` BIGINT COMMENT 'Identifier of the employee who approved the campaign for execution.',
    `campaign_associate_id` BIGINT COMMENT 'Identifier of the employee who created the campaign record.',
    `campaign_modified_by_associate_id` BIGINT COMMENT 'Identifier of the employee who last modified the campaign record.',
    `channel_id` BIGINT COMMENT 'add column channel_id (BIGINT) with FK to marketing.channel.channel_id - campaigns execute through primary channels and need this linkage for channel attribution',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Campaigns must comply with regulatory frameworks (GDPR consent, CAN-SPAM, TCPA, FTC advertising standards). Retail marketing requires compliance verification before launch and audit trail for regulato',
    `marketing_brand_id` BIGINT COMMENT 'Identifier of the retail brand or banner that owns or sponsors this campaign.',
    `parent_campaign_id` BIGINT COMMENT 'Reference to the parent campaign if this campaign is part of a hierarchical campaign structure (e.g., a sub-campaign or wave within a master campaign).',
    `price_strategy_id` BIGINT COMMENT 'Foreign key linking to pricing.price_strategy. Business justification: Retail campaigns execute specific pricing strategies (EDLP, Hi-Lo, promotional). Campaign planning requires knowing which price strategy governs promoted SKUs. Real business process: campaign brief cr',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_definition. Business justification: Campaigns are measured against specific KPIs (ROAS, conversion rate, CTR) defined in analytics. Marketing teams set primary success metrics at campaign launch; this link enables performance tracking',
    `replenishment_plan_id` BIGINT COMMENT 'Foreign key linking to supplychain.replenishment_plan. Business justification: Promotional campaigns drive dedicated replenishment plans for campaign-specific inventory. Retail buyers create replenishment plans tied to Black Friday, back-to-school campaigns. Essential for promot',
    `training_program_id` BIGINT COMMENT 'Foreign key linking to compliance.training_program. Business justification: Marketing associates require mandatory compliance training (data privacy, advertising standards, FTC disclosure rules) before executing campaigns. Real business need: ensuring campaign creators are ce',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Large promotional campaigns trigger dedicated purchase orders for promotional merchandise (e.g., Super Bowl campaign inventory, holiday gift sets). Buyers create POs specifically tagged to campaigns f',
    `actual_end_date` DATE COMMENT 'Actual date when the campaign execution concluded, may differ from planned end date.',
    `actual_spend_amount` DECIMAL(18,2) COMMENT 'Total actual expenditure incurred for the campaign across all channels and activities.',
    `actual_start_date` DATE COMMENT 'Actual date when the campaign execution began, may differ from planned start date due to operational adjustments.',
    `approval_status` STRING COMMENT 'Status of campaign approval workflow indicating whether the campaign has been approved for execution.. Valid values are `pending|approved|rejected`',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the campaign was approved for execution.',
    `budget_amount` DECIMAL(18,2) COMMENT 'Total allocated budget for the campaign across all channels and activities.',
    `budget_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the campaign budget (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `campaign_status` STRING COMMENT 'Current lifecycle status of the campaign indicating its operational state.. Valid values are `draft|scheduled|active|paused|completed|cancelled`',
    `campaign_type` STRING COMMENT 'Classification of the campaign based on its strategic purpose (e.g., brand awareness, customer acquisition, retention, win-back, seasonal promotion, product launch).. Valid values are `brand_awareness|acquisition|retention|win_back|seasonal|product_launch`',
    `channel_mix` STRING COMMENT 'Comma-separated list or description of marketing channels used in this campaign (e.g., email, SMS, social media, paid search, display, in-store, direct mail).',
    `campaign_code` STRING COMMENT 'Unique business identifier or code for the campaign, often used in external systems and tracking URLs.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the campaign record was first created in the system.',
    `creative_theme` STRING COMMENT 'The overarching creative theme, messaging concept, or visual identity used in campaign assets.',
    `campaign_description` STRING COMMENT 'Detailed description of the campaign including its purpose, key messages, and tactical approach.',
    `geographic_scope` STRING COMMENT 'Geographic reach of the campaign indicating whether it is national, regional, local, or international.. Valid values are `national|regional|local|international`',
    `is_omnichannel` BOOLEAN COMMENT 'Flag indicating whether the campaign is executed across multiple channels in an integrated omnichannel approach.',
    `is_personalized` BOOLEAN COMMENT 'Flag indicating whether the campaign uses personalized messaging or offers tailored to individual customers.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when the campaign record was last modified.',
    `campaign_name` STRING COMMENT 'Human-readable name of the marketing campaign used for identification and reporting.',
    `objective` STRING COMMENT 'Primary business objective or goal of the campaign (e.g., increase store traffic, drive online sales, build brand awareness, grow loyalty membership).',
    `planned_end_date` DATE COMMENT 'Scheduled date when the campaign is planned to conclude.',
    `planned_start_date` DATE COMMENT 'Scheduled date when the campaign is planned to begin execution.',
    `primary_channel` STRING COMMENT 'The primary or lead marketing channel for this campaign. [ENUM-REF-CANDIDATE: email|sms|social_media|paid_search|display|in_store|direct_mail|out_of_home — 8 candidates stripped; promote to reference product]',
    `target_audience_definition` STRING COMMENT 'Description of the target audience segment for this campaign, including demographic, behavioral, and geographic criteria.',
    `target_audience_size` BIGINT COMMENT 'Estimated or actual number of customers or prospects targeted by this campaign.',
    `target_conversion_goal` BIGINT COMMENT 'Target number of conversions (e.g., purchases, sign-ups, store visits) expected from this campaign.',
    `target_country_codes` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes where the campaign is executed (e.g., USA, CAN, GBR).',
    `target_revenue_goal` DECIMAL(18,2) COMMENT 'Revenue target or goal set for this campaign, used to measure campaign success.',
    `utm_campaign` STRING COMMENT 'UTM campaign parameter used for digital campaign tracking, typically matches the campaign code or name.',
    `utm_medium` STRING COMMENT 'UTM medium parameter used for digital campaign tracking to identify the marketing medium (e.g., email, cpc, social, display).',
    `utm_source` STRING COMMENT 'UTM source parameter used for digital campaign tracking to identify the traffic source (e.g., google, facebook, newsletter).',
    CONSTRAINT pk_campaign PRIMARY KEY(`campaign_id`)
) COMMENT 'Master record for every marketing campaign executed across all retail channels (digital, in-store, email, SMS, social, paid media, OOH). Captures campaign name, type (brand awareness, acquisition, retention, win-back, seasonal), objective, status (draft, active, paused, completed), planned and actual start/end dates, target audience definition, owning brand or banner, campaign owner, budget allocation, channel mix, creative theme, UTM parameters, and campaign hierarchy (parent/child). Distinct from promotion.campaign which owns deal mechanics and redemption — this entity owns upstream campaign strategy and channel execution.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` (
    `campaign_brief_id` BIGINT COMMENT 'Unique identifier for the campaign brief. Primary key.',
    `campaign_id` BIGINT COMMENT 'Reference to the parent marketing campaign that this brief governs.',
    `segment_id` BIGINT COMMENT 'Reference to the primary customer segment being targeted by this campaign.',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Campaign briefs in retail specify target product categories/hierarchies for category-specific marketing strategies, assortment planning, and merchandising alignment. Category managers and marketing te',
    `marketing_brand_id` BIGINT COMMENT 'Foreign key linking to marketing.marketing_brand. Business justification: Campaign briefs are brand-specific strategic documents. While campaign_brief links to campaign, and campaign links to marketing_brand, the brief itself should have a direct FK to marketing_brand becau',
    `privacy_assessment_id` BIGINT COMMENT 'Foreign key linking to compliance.privacy_assessment. Business justification: Campaign briefs triggering new data collection/processing require Data Protection Impact Assessment under GDPR Article 35 and CCPA. Real business need: privacy-by-design workflow, regulatory mandate.',
    `revised_from_campaign_brief_id` BIGINT COMMENT 'Self-referencing FK on campaign_brief (revised_from_campaign_brief_id)',
    `approver_name` STRING COMMENT 'Name of the executive or stakeholder who provided final approval sign-off on the brief.',
    `approver_title` STRING COMMENT 'Job title or role of the approver who signed off on the campaign brief.',
    `assigned_agency_name` STRING COMMENT 'Name of the external creative or media agency assigned to execute this campaign brief.',
    `brief_approved_date` DATE COMMENT 'Date when the campaign brief received final approval and sign-off.',
    `brief_name` STRING COMMENT 'Descriptive name of the campaign brief for easy identification and reference.',
    `brief_number` STRING COMMENT 'Human-readable business identifier for the campaign brief, used for external reference and tracking.',
    `brief_status` STRING COMMENT 'Current lifecycle status of the campaign brief in the approval workflow.. Valid values are `draft|submitted|under_review|approved|rejected|revision_requested`',
    `brief_submitted_date` DATE COMMENT 'Date when the campaign brief was formally submitted for review and approval.',
    `brief_type` STRING COMMENT 'Classification of the brief by campaign execution scope and channel mix. [ENUM-REF-CANDIDATE: integrated|digital_only|print_only|social_media|email|in_store|omnichannel — 7 candidates stripped; promote to reference product]',
    `budget_allocated_amount` DECIMAL(18,2) COMMENT 'Total budget amount allocated for executing this campaign brief across all channels and activities.',
    `budget_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the budget allocated amount.. Valid values are `^[A-Z]{3}$`',
    `call_to_action` STRING COMMENT 'Primary call-to-action that the campaign should drive (e.g., Shop Now, Sign Up, Learn More, Visit Store).',
    `campaign_end_date` DATE COMMENT 'Planned end date for campaign execution as specified in the brief.',
    `campaign_start_date` DATE COMMENT 'Planned start date for campaign execution as specified in the brief.',
    `channel_mix_strategy` STRING COMMENT 'Strategic allocation and prioritization of marketing channels (email, social, paid search, display, in-store, etc.) for campaign execution.',
    `competitive_context` STRING COMMENT 'Analysis of competitive landscape, competitor campaigns, and market positioning considerations relevant to this brief.',
    `created_by_user` STRING COMMENT 'Username or identifier of the user who created the campaign brief.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the campaign brief record was first created in the system.',
    `creative_assets_required` STRING COMMENT 'List of creative deliverables required (e.g., video, display ads, email templates, social posts, in-store signage).',
    `creative_lead_name` STRING COMMENT 'Name of the creative lead or art director responsible for creative development.',
    `geographic_scope` STRING COMMENT 'Geographic markets, regions, or store locations targeted by this campaign brief.',
    `internal_team_assignment` STRING COMMENT 'Internal marketing team or department responsible for managing and executing this brief.',
    `key_message` STRING COMMENT 'Core message or value proposition that must be communicated across all campaign creative and channels.',
    `landing_page_url` STRING COMMENT 'URL of the campaign landing page or destination where customers will be directed.',
    `legal_compliance_notes` STRING COMMENT 'Legal and regulatory compliance considerations, disclaimers, and requirements that must be adhered to in campaign execution.',
    `mandatory_brand_elements` STRING COMMENT 'List of required brand assets, logos, taglines, legal disclaimers, and visual elements that must appear in all campaign materials.',
    `product_category_focus` STRING COMMENT 'Primary product categories or merchandise assortments featured in the campaign.',
    `revision_notes` STRING COMMENT 'Notes documenting changes, feedback, and revisions made to the brief during the review process.',
    `revision_number` STRING COMMENT 'Version number tracking the number of revisions made to the campaign brief.',
    `success_kpi_definition` STRING COMMENT 'Definition of key performance indicators and success metrics that will be used to measure campaign effectiveness.',
    `target_audience_description` STRING COMMENT 'Detailed description of the target audience personas, demographics, psychographics, and behavioral characteristics.',
    `target_conversion_rate_pct` DECIMAL(18,2) COMMENT 'Target conversion rate percentage that the campaign aims to achieve.',
    `target_reach` BIGINT COMMENT 'Target number of unique customers or impressions the campaign aims to achieve.',
    `target_roi_pct` DECIMAL(18,2) COMMENT 'Target return on investment percentage expected from the campaign spend.',
    `tone_of_voice` STRING COMMENT 'Prescribed tone and style for campaign communications (e.g., friendly, authoritative, playful, urgent).',
    `updated_by_user` STRING COMMENT 'Username or identifier of the user who last updated the campaign brief.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the campaign brief record was last modified.',
    CONSTRAINT pk_campaign_brief PRIMARY KEY(`campaign_brief_id`)
) COMMENT 'Creative and strategic brief document associated with a marketing campaign. Captures campaign objectives, target audience personas, key messages, tone of voice, mandatory brand elements, competitive context, success KPIs, agency or internal team assignments, brief approval status, revision history, and sign-off dates. Serves as the authoritative upstream strategy document that governs all downstream creative and channel execution for the campaign.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`audience_segment` (
    `audience_segment_id` BIGINT COMMENT 'Unique identifier for the marketing audience segment. Primary key.',
    `parent_audience_segment_id` BIGINT COMMENT 'Self-referencing FK on audience_segment (parent_audience_segment_id)',
    `privacy_assessment_id` BIGINT COMMENT 'Foreign key linking to compliance.privacy_assessment. Business justification: Audience segmentation using personal data requires privacy impact assessment under GDPR Article 35. Real business need: data subject rights protection, legal basis validation. Retail segmentation (beh',
    `activation_channels` STRING COMMENT 'Comma-separated list of marketing channels where this segment is activated (e.g., email, SMS, social media, display advertising, search, in-store personalization).',
    `activation_status` STRING COMMENT 'Indicates whether the segment has been activated for use in live marketing campaigns and media buying platforms.. Valid values are `activated|not_activated|pending_activation|deactivated`',
    `actual_reach` BIGINT COMMENT 'Actual count of unique customers or contacts currently assigned to this segment after the last refresh execution.',
    `approved_by` STRING COMMENT 'User ID or name of the marketing manager or compliance officer who approved this segment for activation.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this segment was approved for use in marketing campaigns.',
    `average_aov` DECIMAL(18,2) COMMENT 'Average Order Value for customers in this segment, calculated from historical transaction data.',
    `average_cltv` DECIMAL(18,2) COMMENT 'Average Customer Lifetime Value across all members of this segment, used for ROI forecasting and media spend allocation decisions.',
    `average_purchase_frequency` DECIMAL(18,2) COMMENT 'Average number of purchases per customer per year within this segment, used for campaign frequency planning.',
    `business_objective` STRING COMMENT 'Strategic marketing objective or campaign goal this segment supports (e.g., customer acquisition, retention, cross-sell, win-back, loyalty tier upgrade).',
    `confidence_score` DECIMAL(18,2) COMMENT 'Statistical confidence or quality score for modeled segments, representing the predicted accuracy of segment membership (0.0000 to 1.0000). Null for non-modeled segments.',
    `consent_required_flag` BOOLEAN COMMENT 'Indicates whether explicit customer consent is required before activating this segment for marketing communications, per privacy regulations.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this segment record was first created in the system.',
    `creation_method` STRING COMMENT 'Method used to create the segment: manual selection, rule-based logic, machine learning model, lookalike modeling, imported from external system, or cloned from existing segment.. Valid values are `manual|rule_based|ml_model|lookalike_model|imported|cloned`',
    `data_retention_days` STRING COMMENT 'Number of days segment membership data is retained before automatic purge, aligned with data privacy and retention policies.',
    `data_sources` STRING COMMENT 'Comma-separated list or description of source systems and data domains used to build this segment (e.g., CRM, loyalty program, web analytics, POS transaction data, email engagement).',
    `definition_logic` STRING COMMENT 'SQL predicate, rule set, or business logic defining the segment membership criteria. May reference customer attributes, transaction history, loyalty tier, web behavior, or other data sources.',
    `effective_end_date` DATE COMMENT 'Date when this segment definition expires or is scheduled for deactivation. Null for open-ended segments.',
    `effective_start_date` DATE COMMENT 'Date when this segment definition became active and available for campaign targeting.',
    `estimated_reach` BIGINT COMMENT 'Estimated number of customers or contacts that qualify for this segment based on the most recent evaluation of the definition logic.',
    `exclusion_flag` BOOLEAN COMMENT 'Indicates whether this is a suppression segment used to exclude customers from campaigns (e.g., unsubscribed, opted-out, recent purchasers to avoid over-messaging).',
    `last_refresh_timestamp` TIMESTAMP COMMENT 'Date and time when the segment membership was last recalculated and updated.',
    `model_code` STRING COMMENT 'Identifier of the machine learning or lookalike model used to generate this segment, if applicable. Null for non-modeled segments.',
    `model_version` STRING COMMENT 'Version number or timestamp of the ML model used to generate this segment, enabling model lineage tracking and reproducibility.',
    `modified_by` STRING COMMENT 'User ID or name of the person who last modified this segment definition or configuration.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this segment record was last updated.',
    `next_refresh_timestamp` TIMESTAMP COMMENT 'Scheduled date and time for the next segment membership refresh based on the defined refresh frequency.',
    `notes` STRING COMMENT 'Free-text field for additional context, campaign history, performance observations, or special handling instructions related to this segment.',
    `owning_team` STRING COMMENT 'Name or identifier of the marketing team, business unit, or campaign manager responsible for this segment.',
    `priority_level` STRING COMMENT 'Business priority assigned to this segment for resource allocation, campaign sequencing, and media spend decisions.. Valid values are `critical|high|medium|low`',
    `refresh_frequency` STRING COMMENT 'Cadence at which the segment membership is recalculated and updated to reflect current customer behavior and attributes. [ENUM-REF-CANDIDATE: real_time|hourly|daily|weekly|monthly|on_demand|static — 7 candidates stripped; promote to reference product]',
    `segment_code` STRING COMMENT 'Short alphanumeric code or abbreviation for the segment, used in campaign tagging and reporting systems.',
    `segment_description` STRING COMMENT 'Detailed narrative description of the segment purpose, target audience characteristics, and intended use cases for marketing activation.',
    `segment_name` STRING COMMENT 'Human-readable name of the audience segment used for campaign targeting and identification by marketing teams.',
    `segment_status` STRING COMMENT 'Current lifecycle status of the audience segment indicating whether it is available for campaign activation.. Valid values are `active|inactive|draft|archived|suspended|testing`',
    `segment_type` STRING COMMENT 'Classification of the segment methodology: behavioral (purchase patterns, browsing), demographic (age, income, location), psychographic (lifestyle, values), RFM-based (Recency Frequency Monetary analysis), lookalike (modeled similarity to high-value customers), or suppression (exclusion list).. Valid values are `behavioral|demographic|psychographic|rfm_based|lookalike|suppression`',
    `tags` STRING COMMENT 'Comma-separated list of user-defined tags or labels for segment categorization, search, and filtering (e.g., seasonal, promotional, loyalty, acquisition).',
    `target_persona` STRING COMMENT 'Marketing persona or customer archetype this segment represents (e.g., high-value shoppers, bargain hunters, omnichannel enthusiasts, lapsed customers).',
    `created_by` STRING COMMENT 'User ID or name of the marketing analyst or system that created this segment definition.',
    CONSTRAINT pk_audience_segment PRIMARY KEY(`audience_segment_id`)
) COMMENT 'Marketing-owned audience segment definitions used for campaign targeting, media buying, and personalization. Captures segment name, segment type (behavioral, demographic, psychographic, RFM-based, lookalike, suppression), definition logic (SQL predicate or rule set), estimated reach, data sources used (CRM, loyalty, web analytics), refresh frequency, activation status, and owning marketing team. Distinct from customer.segment which is the customer-domain SSOT for customer classification — this entity represents marketing-specific targeting constructs built on top of customer segments for campaign activation.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` (
    `campaign_audience_id` BIGINT COMMENT 'Unique identifier for the campaign audience association record.',
    `audience_segment_id` BIGINT COMMENT 'Reference to the audience segment being targeted by this campaign.',
    `campaign_id` BIGINT COMMENT 'Reference to the marketing campaign that is targeting this audience segment.',
    `split_from_campaign_audience_id` BIGINT COMMENT 'Self-referencing FK on campaign_audience (split_from_campaign_audience_id)',
    `activation_end_date` DATE COMMENT 'The date when this audience segment targeting ends or expires within the campaign. Used for time-bound targeting windows or campaign flight schedules.',
    `activation_start_date` DATE COMMENT 'The date when this audience segment targeting becomes active within the campaign. Used for scheduled or phased campaign rollouts.',
    `activation_timestamp` TIMESTAMP COMMENT 'The date and time when this audience segment was activated for the campaign and messages were sent or ads were served.',
    `actual_reached_count` BIGINT COMMENT 'The actual number of customers or contacts successfully reached after campaign execution. Populated post-execution for performance measurement.',
    `budget_allocation_amount` DECIMAL(18,2) COMMENT 'The portion of the campaign budget allocated specifically to this audience segment for media spend, creative production, or channel costs.',
    `budget_allocation_currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for the budget allocation amount.. Valid values are `^[A-Z]{3}$`',
    `campaign_audience_status` STRING COMMENT 'The current lifecycle status of this campaign-audience association. Tracks whether the targeting configuration is in planning, execution, or post-campaign state.. Valid values are `draft|scheduled|active|paused|completed|cancelled`',
    `channel_applicability` STRING COMMENT 'The marketing channel(s) for which this audience segment is applicable within the campaign. Determines where this segment will be activated. [ENUM-REF-CANDIDATE: email|sms|push|display|social|search|direct_mail|in_store|all_channels — 9 candidates stripped; promote to reference product]',
    `consent_verification_date` DATE COMMENT 'The date when opt-in consent was last verified for this audience segment. Used for regulatory compliance and audit trails.',
    `conversion_count` BIGINT COMMENT 'The number of customers in this audience segment who completed the campaign conversion goal (purchase, sign-up, store visit, etc.). Populated post-execution for ROI measurement.',
    `conversion_rate_percent` DECIMAL(18,2) COMMENT 'The percentage of reached customers who converted (conversion_count / actual_reached_count * 100). Primary metric for campaign return on investment.',
    `cost_per_acquisition` DECIMAL(18,2) COMMENT 'The average cost to acquire one conversion from this audience segment (budget_allocation_amount / conversion_count). Key efficiency metric for campaign optimization.',
    `created_by_user` STRING COMMENT 'The username or identifier of the marketing user who created this campaign-audience association.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this campaign-audience association record was first created in the system.',
    `delivery_rate_percent` DECIMAL(18,2) COMMENT 'The percentage of the estimated reach that was successfully delivered (actual_reached_count / estimated_reach * 100). Calculated post-execution to measure targeting accuracy and deliverability.',
    `estimated_reach` BIGINT COMMENT 'The estimated number of customers or contacts in this audience segment at the time of campaign planning and activation setup.',
    `frequency_cap` STRING COMMENT 'The maximum number of times a customer in this audience segment should be contacted or exposed to campaign messages within the campaign period. Used to prevent over-messaging.',
    `frequency_cap_period_days` STRING COMMENT 'The time period in days over which the frequency cap is enforced. For example, a frequency cap of 3 over 7 days means no more than 3 messages in any 7-day window.',
    `lookalike_model_code` STRING COMMENT 'Reference to the lookalike modeling algorithm or configuration used when this audience segment serves as a seed for lookalike expansion. Only populated when targeting_role is lookalike_seed.',
    `lookalike_similarity_threshold` DECIMAL(18,2) COMMENT 'The minimum similarity score (0.0000 to 1.0000) required for a customer to be included in the lookalike expansion audience. Higher thresholds produce smaller, more similar audiences.',
    `notes` STRING COMMENT 'Free-text notes or comments about this campaign-audience association, including targeting rationale, special instructions, or post-campaign observations.',
    `opt_in_consent_verified` BOOLEAN COMMENT 'Flag indicating whether opt-in consent has been verified for all customers in this audience segment for the specified channel. Required for GDPR, CCPA, and CAN-SPAM compliance.',
    `personalization_strategy` STRING COMMENT 'The personalization or dynamic content strategy applied to this audience segment within the campaign (e.g., product recommendations, location-based offers, behavioral triggers, demographic customization).',
    `priority_rank` STRING COMMENT 'The priority ranking of this audience segment within the campaign when multiple segments are targeted. Lower numbers indicate higher priority for message delivery or budget allocation.',
    `response_count` BIGINT COMMENT 'The number of customers in this audience segment who responded to the campaign (clicked, opened, converted, or took the desired action). Populated post-execution for performance measurement.',
    `response_rate_percent` DECIMAL(18,2) COMMENT 'The percentage of reached customers who responded to the campaign (response_count / actual_reached_count * 100). Key performance indicator for campaign effectiveness.',
    `return_on_ad_spend` DECIMAL(18,2) COMMENT 'The ratio of attributed revenue to budget allocation for this audience segment (revenue_attributed_amount / budget_allocation_amount). Measures campaign profitability per segment.',
    `revenue_attributed_amount` DECIMAL(18,2) COMMENT 'The total revenue attributed to this audience segment from the campaign based on the attribution model. Used for ROI calculation and segment performance comparison.',
    `revenue_attributed_currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for the attributed revenue amount.. Valid values are `^[A-Z]{3}$`',
    `segment_refresh_date` DATE COMMENT 'The date when the audience segment membership was last refreshed or recalculated prior to campaign activation. Important for understanding data recency.',
    `suppression_reason` STRING COMMENT 'The business reason why this audience segment is being excluded or suppressed from the campaign (e.g., recent purchasers, unsubscribed, high-value customers to protect, regulatory exclusion). Only populated when targeting_role is exclude or suppress.',
    `targeting_role` STRING COMMENT 'The role this audience segment plays in the campaign targeting strategy (include for primary targeting, exclude/suppress for opt-outs or suppression lists, lookalike_seed for expansion modeling, control_group for A/B testing, holdout for measurement).. Valid values are `include|exclude|suppress|lookalike_seed|control_group|holdout`',
    `test_group_indicator` BOOLEAN COMMENT 'Flag indicating whether this audience segment is part of an A/B test or experimental group within the campaign. True if this is a test variant, false if control or standard execution.',
    `test_variant_name` STRING COMMENT 'The name or identifier of the test variant applied to this audience segment (e.g., Variant A, Creative B, Offer 20% Off). Only populated when test_group_indicator is true.',
    `updated_by_user` STRING COMMENT 'The username or identifier of the marketing user who last modified this campaign-audience association.',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time when this campaign-audience association record was last modified.',
    CONSTRAINT pk_campaign_audience PRIMARY KEY(`campaign_audience_id`)
) COMMENT 'Association record linking a marketing campaign to one or more audience segments, defining the targeting configuration for each campaign execution. Captures campaign reference, audience segment reference, targeting role (include, exclude/suppress, lookalike seed), estimated reach at time of activation, actual reached count post-execution, channel applicability, and activation timestamp. Enables multi-segment targeting strategies and suppression list management per campaign.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`media_plan` (
    `media_plan_id` BIGINT COMMENT 'Unique identifier for the media plan. Primary key.',
    `campaign_id` BIGINT COMMENT 'Reference to the parent marketing campaign this media plan supports.',
    `marketing_budget_id` BIGINT COMMENT 'Foreign key linking to marketing.marketing_budget. Business justification: Media plans are funded by marketing budgets and represent the allocation of budget to media channels. The media_plan should link to marketing_budget to track which budget allocation is funding the pla',
    `associate_id` BIGINT COMMENT 'Identifier of the user who created this media plan record.',
    `media_modified_by_associate_id` BIGINT COMMENT 'Identifier of the user who last modified this media plan record.',
    `owner_associate_id` BIGINT COMMENT 'Identifier of the marketing manager or media planner responsible for this media plan.',
    `primary_media_associate_id` BIGINT COMMENT 'Identifier of the user or manager who approved this media plan.',
    `revised_from_media_plan_id` BIGINT COMMENT 'Self-referencing FK on media_plan (revised_from_media_plan_id)',
    `agency_name` STRING COMMENT 'Name of the advertising agency or media buying agency responsible for executing this media plan.',
    `approval_status` STRING COMMENT 'Approval status of the media plan by marketing leadership or finance.. Valid values are `pending|approved|rejected`',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the media plan was approved.',
    `audience_segment_ids` STRING COMMENT 'Comma-separated list of audience segment identifiers targeted by this media plan.',
    `budget_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the planned budget amount.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the media plan record was first created in the system.',
    `display_budget_amount` DECIMAL(18,2) COMMENT 'Budget allocated to display advertising (banner ads, programmatic display, retargeting).',
    `dsp_platform_name` STRING COMMENT 'Name of the demand-side platform used for programmatic media buying (e.g., Google DV360, The Trade Desk, Amazon DSP).',
    `email_budget_amount` DECIMAL(18,2) COMMENT 'Budget allocated to email marketing campaigns and automation.',
    `flight_end_date` DATE COMMENT 'End date for the media flight or campaign execution period.',
    `flight_start_date` DATE COMMENT 'Start date for the media flight or campaign execution period.',
    `geographic_targeting` STRING COMMENT 'Geographic scope for media placement, including countries, regions, DMAs, or postal codes targeted.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when the media plan record was last modified.',
    `ooh_budget_amount` DECIMAL(18,2) COMMENT 'Budget allocated to out-of-home advertising (billboards, transit ads, digital signage).',
    `paid_search_budget_amount` DECIMAL(18,2) COMMENT 'Budget allocated to paid search advertising channels (Google Ads, Bing Ads, etc.).',
    `paid_social_budget_amount` DECIMAL(18,2) COMMENT 'Budget allocated to paid social media advertising channels (Facebook, Instagram, LinkedIn, TikTok, etc.).',
    `plan_code` STRING COMMENT 'Unique alphanumeric code for the media plan, used for external reference and integration with media buying platforms.',
    `plan_description` STRING COMMENT 'Detailed description of the media plan strategy, objectives, and tactical approach.',
    `plan_name` STRING COMMENT 'Business-friendly name for the media plan, used for identification and reporting.',
    `plan_status` STRING COMMENT 'Current lifecycle status of the media plan indicating its approval and execution state.. Valid values are `draft|pending_approval|approved|in_flight|completed|cancelled`',
    `planned_frequency` DECIMAL(18,2) COMMENT 'Average number of times each individual in the target audience is expected to be exposed to the campaign.',
    `planned_reach` BIGINT COMMENT 'Estimated number of unique individuals or households expected to be exposed to the campaign at least once.',
    `planned_total_impressions` BIGINT COMMENT 'Total number of ad impressions planned across all channels for this media plan.',
    `planning_period_end_date` DATE COMMENT 'End date of the planning period for which this media plan is designed.',
    `planning_period_start_date` DATE COMMENT 'Start date of the planning period for which this media plan is designed.',
    `print_budget_amount` DECIMAL(18,2) COMMENT 'Budget allocated to print advertising (newspapers, magazines, circulars).',
    `radio_budget_amount` DECIMAL(18,2) COMMENT 'Budget allocated to radio advertising (terrestrial and streaming radio).',
    `sms_budget_amount` DECIMAL(18,2) COMMENT 'Budget allocated to SMS marketing campaigns and automation.',
    `target_cpa` DECIMAL(18,2) COMMENT 'Target cost per customer acquisition or conversion for performance marketing channels.',
    `target_cpc` DECIMAL(18,2) COMMENT 'Target cost per click for paid search and paid social channels.',
    `target_cpm` DECIMAL(18,2) COMMENT 'Target cost per thousand impressions for media buying efficiency.',
    `target_roas` DECIMAL(18,2) COMMENT 'Target return on ad spend ratio, expressed as revenue generated per dollar spent on advertising.',
    `total_planned_budget_amount` DECIMAL(18,2) COMMENT 'Total budget allocated for this media plan across all channels and placements.',
    `tv_budget_amount` DECIMAL(18,2) COMMENT 'Budget allocated to television advertising (broadcast, cable, connected TV).',
    `video_budget_amount` DECIMAL(18,2) COMMENT 'Budget allocated to video advertising channels (YouTube, OTT, streaming platforms).',
    CONSTRAINT pk_media_plan PRIMARY KEY(`media_plan_id`)
) COMMENT 'Master record for a media plan defining the planned allocation of marketing spend across channels, placements, and time periods for a campaign. Captures media plan name, campaign reference, planning period, total planned budget, channel breakdown (paid search, paid social, display, video, OOH, print, radio, TV, email, SMS), agency or DSP used, flight dates per channel, planned impressions, planned reach and frequency targets, and approval status. Serves as the financial and tactical blueprint for media buying execution.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`media_buy` (
    `media_buy_id` BIGINT COMMENT 'Unique identifier for the media buy transaction. Primary key for the media buy record.',
    `sku_price_id` BIGINT COMMENT 'Foreign key linking to pricing.sku_price. Business justification: Media buys feature specific products at specific advertised prices ("$9.99 sale" in display ads). Creative approval and legal compliance require verifying advertised prices match current authorized re',
    `campaign_id` BIGINT COMMENT 'Reference to the marketing campaign this media buy supports. Enables campaign-level performance rollup and attribution.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to marketing.marketing_channel. Business justification: Media buys are executed via specific marketing channels and should reference the authoritative marketing_channel master. Currently, media_buy has a denormalized channel_type STRING attribute. Adding m',
    `creative_asset_id` BIGINT COMMENT 'Reference to the creative asset (ad copy, banner, video) assigned to this media buy. Links buy to creative execution for performance analysis.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Retail media buys (circulars, digital ads, TV spots, display) frequently feature specific hero SKUs or promotional items. Essential for tracking promotional effectiveness, ad-to-sale attribution, and',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Media buys require GL account assignment for proper expense classification (advertising expense accounts) and financial reporting. Accounting teams need this for month-end close, accruals, and varianc',
    `make_good_for_media_buy_id` BIGINT COMMENT 'Self-referencing FK on media_buy (make_good_for_media_buy_id)',
    `marketing_brand_id` BIGINT COMMENT 'Reference to the retail brand or product line this media buy promotes. Enables brand-level spend and performance analysis.',
    `associate_id` BIGINT COMMENT 'Reference to the user or manager who approved this media buy. Used for governance and audit trail.',
    `media_created_by_associate_id` BIGINT COMMENT 'Reference to the user who created this media buy record. Audit trail for data governance.',
    `media_modified_by_associate_id` BIGINT COMMENT 'Reference to the user who last modified this media buy record. Audit trail for change management.',
    `media_plan_id` BIGINT COMMENT 'Reference to the parent media plan under which this buy was executed. Links the buy to strategic planning and budget allocation.',
    `publisher_id` BIGINT COMMENT 'Reference to the supplier or vendor master record for the publisher. Links to vendor management and payment systems.',
    `actual_spend_amount` DECIMAL(18,2) COMMENT 'Total actual spend incurred for this media buy based on delivered impressions, clicks, or contracted terms. Updated as invoices are received and reconciled.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the media buy was approved. Audit trail for governance and compliance.',
    `booking_date` DATE COMMENT 'The date when the media buy was officially booked or reserved with the publisher. Key milestone in the buy lifecycle.',
    `buy_reference_number` STRING COMMENT 'External business identifier for the media buy, used in vendor communications, invoices, and reporting. Human-readable unique code.. Valid values are `^[A-Z0-9-]{6,20}$`',
    `buy_status` STRING COMMENT 'Current lifecycle status of the media buy. Tracks progression from planning through execution to completion or cancellation. [ENUM-REF-CANDIDATE: draft|pending_approval|approved|booked|in_flight|completed|cancelled|paused — 8 candidates stripped; promote to reference product]',
    `buy_type` STRING COMMENT 'Pricing model for the media buy. CPM (Cost Per Mille/Thousand Impressions), CPC (Cost Per Click), CPV (Cost Per View), CPA (Cost Per Acquisition), CPL (Cost Per Lead), flat fee, or sponsorship. [ENUM-REF-CANDIDATE: cpm|cpc|cpv|cpa|cpl|flat_fee|sponsorship|programmatic_rtb — 8 candidates stripped; promote to reference product]',
    `click_count` BIGINT COMMENT 'Total number of clicks recorded for this media buy. Key engagement metric for digital placements.',
    `contracted_rate` DECIMAL(18,2) COMMENT 'The negotiated unit rate for the buy based on the buy type (e.g., rate per thousand impressions for CPM, rate per click for CPC). Basis for cost calculation.',
    `conversion_count` BIGINT COMMENT 'Number of conversions (purchases, sign-ups, leads) attributed to this media buy based on attribution model. Used for ROI calculation.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this media buy record was first created in the system. Audit trail for data lineage.',
    `daypart_targeting` STRING COMMENT 'Time-of-day or day-of-week targeting applied to the buy (e.g., weekday mornings, prime time). Used for scheduling optimization.',
    `delivered_impressions` BIGINT COMMENT 'Actual number of ad impressions served by the publisher for this buy. Used for delivery reconciliation and performance analysis.',
    `device_targeting` STRING COMMENT 'Device types targeted for this buy (desktop, mobile, tablet, connected TV). Applicable to digital placements.. Valid values are `desktop|mobile|tablet|ctv|all`',
    `dsp_platform_name` STRING COMMENT 'Name of the demand-side platform used for programmatic buys (e.g., Google DV360, The Trade Desk, Amazon DSP). Null for direct buys.',
    `flight_end_date` DATE COMMENT 'The date when the media buy placement stops running. Defines the end of the active delivery window.',
    `flight_start_date` DATE COMMENT 'The date when the media buy placement begins running. Defines the start of the active delivery window.',
    `geographic_targeting` STRING COMMENT 'Geographic scope for ad delivery (countries, regions, DMAs, postal codes). Defines where the ad will be shown.',
    `insertion_order_number` STRING COMMENT 'The insertion order or contract number issued to the publisher for this buy. Legal and financial reference for the placement.',
    `is_programmatic` BOOLEAN COMMENT 'Indicates whether this buy was executed through programmatic advertising platforms (DSP, ad exchange) versus direct publisher negotiation.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this media buy record was last updated. Audit trail for change tracking.',
    `notes` STRING COMMENT 'Free-text notes or comments about the media buy, including special terms, delivery issues, or optimization actions taken.',
    `placement_type` STRING COMMENT 'Specific type of media placement within the channel (e.g., search keyword, display banner, video pre-roll, sponsored post, billboard, TV spot). Describes the ad format and positioning.',
    `planned_impressions` BIGINT COMMENT 'Target number of ad impressions contracted or forecasted for this buy. Used for reach and frequency planning.',
    `planned_spend_amount` DECIMAL(18,2) COMMENT 'Budgeted or forecasted spend for this media buy at the time of booking. Used for budget tracking and variance analysis.',
    `rate_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the contracted rate and spend amounts (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `target_audience_definition` STRING COMMENT 'Description of the audience targeting criteria applied to this buy (demographics, interests, behaviors, geographic, contextual). Defines who will see the ad.',
    `view_count` BIGINT COMMENT 'Total number of video views or viewable impressions recorded for this media buy. Applicable to video and rich media placements.',
    `viewability_rate` DECIMAL(18,2) COMMENT 'Percentage of impressions that met viewability standards (MRC: 50% of pixels in view for 1+ seconds for display, 2+ seconds for video). Quality metric.',
    CONSTRAINT pk_media_buy PRIMARY KEY(`media_buy_id`)
) COMMENT 'Transactional record of an individual media placement purchase or booking executed against a media plan. Captures media buy reference, media plan reference, channel type, publisher or platform (Google Ads, Meta, TikTok, programmatic DSP, TV network, OOH vendor), placement type (search keyword, display banner, video pre-roll, sponsored post, billboard), buy type (CPM, CPC, CPV, CPA, flat fee), contracted rate, planned spend, actual spend, impression delivery, click-through count, flight start/end dates, creative asset assigned, and buy status.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`creative_asset` (
    `creative_asset_id` BIGINT COMMENT 'Unique identifier for the creative asset record. Primary key.',
    `campaign_id` BIGINT COMMENT 'Identifier of the marketing campaign this creative asset is associated with or was produced for.',
    `associate_id` BIGINT COMMENT 'Identifier of the user who created the creative asset record in the system.',
    `creative_modified_by_associate_id` BIGINT COMMENT 'Identifier of the user who last modified the creative asset record.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Creative assets (product images, videos, copy) are produced for specific SKUs in retail marketing. Critical for digital asset management, content attribution, and ensuring correct product representati',
    `sku_price_id` BIGINT COMMENT 'Foreign key linking to pricing.sku_price. Business justification: Retail creative assets (circulars, display ads, social posts) display product prices. Legal compliance and brand standards require price accuracy validation. Real business process: creative asset appr',
    `marketing_brand_id` BIGINT COMMENT 'Identifier of the retail brand or banner associated with this creative asset (e.g., store brand, private label, or corporate brand).',
    `org_unit_id` BIGINT COMMENT 'Identifier of the internal marketing or creative team responsible for producing or managing the creative asset.',
    `parent_asset_creative_asset_id` BIGINT COMMENT 'Identifier of the parent or master creative asset from which this asset was derived or adapted. Null if this is an original asset.',
    `primary_creative_owner_associate_id` BIGINT COMMENT 'Identifier of the individual user who owns or is accountable for the creative asset within the organization.',
    `primary_derived_from_creative_asset_id` BIGINT COMMENT 'Self-referencing FK on creative_asset (derived_from_creative_asset_id)',
    `alt_text` STRING COMMENT 'Alternative text description for accessibility compliance, used by screen readers and when the asset cannot be displayed.',
    `approval_status` STRING COMMENT 'Current approval workflow status indicating which review gates the creative asset has passed (legal, brand, compliance).. Valid values are `not_submitted|pending_legal|pending_brand|pending_compliance|approved|rejected`',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the creative asset received final approval and became available for campaign use.',
    `asset_code` STRING COMMENT 'Unique business identifier or SKU-like code assigned to the creative asset for cataloging and reference across marketing systems.',
    `asset_name` STRING COMMENT 'Human-readable name or title of the creative asset, used for identification and search within the Digital Asset Management (DAM) system.',
    `asset_status` STRING COMMENT 'Current lifecycle status of the creative asset indicating its approval state and availability for use in campaigns.. Valid values are `draft|pending_review|approved|active|expired|archived`',
    `asset_type` STRING COMMENT 'Classification of the creative asset by its primary format and intended use case. [ENUM-REF-CANDIDATE: digital_banner|email_template|sms_copy|social_media_post|video_ad|print_artwork|in_store_signage|landing_page|display_ad|native_ad|audio_ad|podcast_ad|influencer_content|gif_animation|interactive_content — promote to reference product]',
    `call_to_action` STRING COMMENT 'Primary call-to-action message or button text embedded in the creative asset (e.g., Shop Now, Learn More, Sign Up).',
    `channel_suitability` STRING COMMENT 'Comma-separated list of marketing channels for which this creative asset is suitable or optimized (e.g., email, social, display, in-store, mobile).',
    `compliance_notes` STRING COMMENT 'Free-text notes documenting compliance review findings, legal disclaimers required, or regulatory considerations for the creative asset.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the creative asset record was first created in the DAM system.',
    `creative_agency_name` STRING COMMENT 'Name of the external creative agency or vendor that produced the creative asset.',
    `creative_asset_description` STRING COMMENT 'Detailed textual description of the creative asset content, purpose, and intended use case.',
    `dimensions` STRING COMMENT 'Physical or pixel dimensions of the creative asset (e.g., 1920x1080 for video, 8.5x11 inches for print, 300x250 pixels for banner).',
    `effective_end_date` DATE COMMENT 'Date after which the creative asset expires and should no longer be used in campaigns, often due to promotional expiry or seasonal relevance.',
    `effective_start_date` DATE COMMENT 'Date from which the creative asset is valid and authorized for use in marketing campaigns.',
    `file_reference_url` STRING COMMENT 'Uniform Resource Locator (URL) or Digital Asset Management (DAM) system path pointing to the stored creative asset file.',
    `file_size_kb` DECIMAL(18,2) COMMENT 'Size of the creative asset file in kilobytes, used for storage management and delivery optimization.',
    `format` STRING COMMENT 'Technical file format or MIME type of the creative asset (e.g., JPG, PNG, MP4, HTML, PDF).',
    `is_compliant` BOOLEAN COMMENT 'Boolean flag indicating whether the creative asset has passed all regulatory and brand compliance checks (True) or has outstanding compliance issues (False).',
    `is_master_version` BOOLEAN COMMENT 'Boolean flag indicating whether this is the master or canonical version of the creative asset (True) or a derivative/variant (False).',
    `keywords` STRING COMMENT 'Comma-separated list of keywords or tags for search and discovery of the creative asset within the DAM system.',
    `language_code` STRING COMMENT 'Two-letter ISO 639-1 language code indicating the primary language of the creative asset content.. Valid values are `^[a-z]{2}$`',
    `license_expiry_date` DATE COMMENT 'Date when the usage license for the creative asset expires, after which continued use may require renewal or renegotiation.',
    `licensing_terms` STRING COMMENT 'Detailed text description of licensing terms, restrictions, and usage conditions for the creative asset, including geographic and temporal constraints.',
    `locale_code` STRING COMMENT 'Locale identifier combining language and country/region (e.g., en_US, fr_CA) for localized creative variants.. Valid values are `^[a-z]{2}_[A-Z]{2}$`',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when the creative asset record was last modified or updated.',
    `target_url` STRING COMMENT 'Destination URL that users are directed to when they interact with the creative asset (click-through link).',
    `thumbnail_url` STRING COMMENT 'URL to a preview thumbnail image of the creative asset for quick visual identification in the DAM catalog.',
    `usage_count` STRING COMMENT 'Number of times the creative asset has been deployed or used in marketing campaigns, tracked for ROI and asset performance analysis.',
    `usage_rights` STRING COMMENT 'Type of intellectual property rights governing the use of the creative asset (owned, licensed, royalty-free, rights-managed, creative commons).. Valid values are `owned|licensed|royalty_free|rights_managed|creative_commons`',
    `utm_parameters` STRING COMMENT 'Urchin Tracking Module (UTM) parameters appended to the target URL for campaign tracking and attribution (utm_source, utm_medium, utm_campaign, utm_content, utm_term).',
    `version_number` STRING COMMENT 'Sequential version number of the creative asset, incremented with each revision or update.',
    CONSTRAINT pk_creative_asset PRIMARY KEY(`creative_asset_id`)
) COMMENT 'Master record for all marketing creative assets including digital banners, email templates, SMS copy, social media posts, video ads, print artwork, and in-store signage. Captures asset name, asset type, format/dimensions, file reference (DAM URL), brand/banner, campaign association, channel suitability, language/locale, version number, approval status, expiry date, usage rights and licensing terms, and the creative team or agency that produced it. Serves as the marketing DAM (Digital Asset Management) catalog within the data platform.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`email_send` (
    `email_send_id` BIGINT COMMENT 'Unique identifier for the email send event. Primary key for the email send transaction.',
    `audience_segment_id` BIGINT COMMENT 'Reference to the customer segment targeted by this email send. Links to the audience definition and segmentation criteria.',
    `campaign_id` BIGINT COMMENT 'Reference to the parent marketing campaign that this email send is part of. Links the email execution to the broader campaign strategy.',
    `email_template_id` BIGINT COMMENT 'Identifier for the email creative template or asset used in this send. Links to the design and content structure in the marketing automation platform.',
    `resend_of_email_send_id` BIGINT COMMENT 'Self-referencing FK on email_send (resend_of_email_send_id)',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Email campaigns target specific storefronts/brands in multi-brand retail. Essential for brand-specific email performance tracking, ensuring brand-appropriate messaging, and measuring channel-specific',
    `ab_test_variant` STRING COMMENT 'The test variant identifier if this send is part of an A/B or multivariate test. Used to compare performance across test cells.',
    `actual_send_timestamp` TIMESTAMP COMMENT 'The actual date and time when the email send job was executed by the Email Service Provider (ESP). Represents the real-world business event time for send execution.',
    `bounce_count` STRING COMMENT 'The total number of emails that bounced (failed delivery). Sum of hard bounces and soft bounces.',
    `click_count` STRING COMMENT 'The total number of times links in the email were clicked by recipients. Includes multiple clicks by the same recipient.',
    `completed_timestamp` TIMESTAMP COMMENT 'The date and time when the email send job finished processing all recipients. Used to calculate send duration and throughput metrics.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this email send record was first created in the system. Used for audit trail and data lineage.',
    `delivered_count` STRING COMMENT 'The number of emails successfully delivered to recipient inboxes without bouncing. Key metric for deliverability performance.',
    `esp_job_code` STRING COMMENT 'The unique job or batch identifier assigned by the Email Service Provider (e.g., the e-commerce platform, Braze, Klaviyo). Used for reconciliation and troubleshooting.',
    `esp_platform_name` STRING COMMENT 'The name of the Email Service Provider platform used to execute this send (e.g., the e-commerce platform, Braze, Klaviyo, Mailchimp). Enables multi-platform send analysis.',
    `from_email_address` STRING COMMENT 'The sender email address used for this send. Must be authenticated and verified with the ESP for deliverability.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `from_name` STRING COMMENT 'The sender name displayed in the recipient inbox. Represents the brand or person sending the email.',
    `hard_bounce_count` STRING COMMENT 'The number of emails that permanently failed delivery due to invalid or non-existent email addresses. Indicates data quality issues.',
    `is_test_send` BOOLEAN COMMENT 'Boolean flag indicating whether this send was a test or quality assurance execution rather than a production send to customers.',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this email send record was last updated. Tracks changes to send status and performance metrics.',
    `open_count` STRING COMMENT 'The total number of times emails from this send were opened by recipients. Includes multiple opens by the same recipient.',
    `preheader_text` STRING COMMENT 'The preview text displayed after the subject line in most email clients. Used to provide additional context and improve open rates.',
    `reply_to_email_address` STRING COMMENT 'The email address where recipient replies will be directed. May differ from the from_email_address for operational routing.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `scheduled_send_timestamp` TIMESTAMP COMMENT 'The planned date and time when the email send was scheduled to execute. Used for campaign timing analysis and scheduling optimization.',
    `send_name` STRING COMMENT 'Business-friendly name assigned to this email send event for identification and reporting purposes.',
    `send_priority` STRING COMMENT 'The priority level assigned to this email send for queue processing and resource allocation. High priority sends are processed first.. Valid values are `high|normal|low`',
    `send_status` STRING COMMENT 'Current lifecycle status of the email send job. Tracks the execution state from scheduling through completion or failure.. Valid values are `scheduled|processing|completed|failed|cancelled|paused`',
    `send_type` STRING COMMENT 'Classification of the email send execution method. Batch sends are scheduled bulk sends, triggered sends are event-driven, transactional sends are operational confirmations, automated sends are part of nurture flows, and test sends are quality assurance executions.. Valid values are `batch|triggered|transactional|automated|test`',
    `sent_count` STRING COMMENT 'The total number of email messages successfully handed off to the Email Service Provider for delivery. Represents the actual send volume.',
    `soft_bounce_count` STRING COMMENT 'The number of emails that temporarily failed delivery due to issues like full mailboxes or server problems. May succeed on retry.',
    `spam_complaint_count` STRING COMMENT 'The number of recipients who marked the email as spam or junk. High complaint rates damage sender reputation and deliverability.',
    `subject_line` STRING COMMENT 'The subject line text displayed in the recipient inbox. Critical for open rate optimization and A/B testing analysis.',
    `suppression_list_applied` BOOLEAN COMMENT 'Boolean flag indicating whether suppression lists (unsubscribed, bounced, or blocked addresses) were applied to filter the target audience before sending.',
    `target_recipient_count` STRING COMMENT 'The total number of recipients in the target audience segment at the time of send scheduling. Represents the intended send volume.',
    `unique_click_count` STRING COMMENT 'The number of unique recipients who clicked at least one link in the email. Used to calculate click-through rate (CTR).',
    `unique_open_count` STRING COMMENT 'The number of unique recipients who opened the email at least once. Used to calculate open rate.',
    `unsubscribe_count` STRING COMMENT 'The number of recipients who opted out of future email communications via the unsubscribe link. Critical for list health and compliance.',
    `utm_campaign` STRING COMMENT 'The UTM campaign tracking parameter embedded in email links. Used to identify the specific campaign or promotion in web analytics.',
    `utm_medium` STRING COMMENT 'The UTM medium tracking parameter embedded in email links. Typically set to email for email marketing sends.',
    `utm_source` STRING COMMENT 'The UTM source tracking parameter embedded in email links for campaign attribution. Typically set to the email platform or channel name.',
    CONSTRAINT pk_email_send PRIMARY KEY(`email_send_id`)
) COMMENT 'Transactional record of a bulk or triggered email send event executed through the marketing automation platform (e.g., the e-commerce platform, Braze, Klaviyo). Captures send name, campaign reference, audience segment, email template/creative asset, send timestamp, total recipients, delivered count, bounce count (hard/soft), open count, click count, unsubscribe count, spam complaint count, send type (batch, triggered, transactional), subject line, from name/address, and ESP job ID. Represents the execution event for email channel marketing.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`sms_send` (
    `sms_send_id` BIGINT COMMENT 'Unique identifier for the SMS/MMS send event. Primary key for the sms_send product.',
    `audience_segment_id` BIGINT COMMENT 'Reference to the customer segment or audience list targeted by this SMS send. Defines the recipient population based on segmentation rules, RFM analysis, or manual list upload.',
    `campaign_id` BIGINT COMMENT 'Reference to the parent marketing campaign that this SMS send is part of. Links this SMS execution to the broader campaign strategy and budget.',
    `associate_id` BIGINT COMMENT 'Reference to the user or system account that created this SMS send record. Used for audit trails and accountability in campaign execution.',
    `profile_id` BIGINT COMMENT 'Foreign key linking to customer.profile. Business justification: SMS campaigns target individual customer profiles for delivery confirmation, opt-out management, and TCPA compliance tracking. New FK required as no existing profile_id column exists. Critical for mob',
    `resend_of_sms_send_id` BIGINT COMMENT 'Self-referencing FK on sms_send (resend_of_sms_send_id)',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: SMS campaigns are storefront-specific for channel-appropriate messaging and compliance. Enables storefront-level SMS performance tracking, opt-in management per brand, and ensures regulatory complianc',
    `ab_test_variant` STRING COMMENT 'The variant identifier if this SMS send is part of an A/B or multivariate test. Examples include control, variant_a, variant_b. Used to compare message content, timing, or audience performance.',
    `actual_send_timestamp` TIMESTAMP COMMENT 'The actual date and time when the SMS send job was initiated and messages began transmitting to the carrier gateway. This is the principal business event timestamp for this transaction.',
    `approved_timestamp` TIMESTAMP COMMENT 'The date and time when this SMS send was approved for execution. Null if no approval workflow is required or if send is still pending approval.',
    `bounced_count` STRING COMMENT 'The number of messages that bounced due to permanent delivery failures such as disconnected numbers or invalid phone numbers. Subset of failed_count requiring list cleanup.',
    `carrier_routing` STRING COMMENT 'The mobile carrier network or SMS gateway provider used to route and deliver this SMS send. Examples include Twilio, Vonage, or direct carrier integrations. Impacts delivery rates and cost.',
    `click_count` STRING COMMENT 'The number of unique clicks on tracked URLs included in the SMS message. Measures recipient engagement and campaign effectiveness. Tracked via URL shortening and redirect services.',
    `completed_timestamp` TIMESTAMP COMMENT 'The date and time when the SMS send job finished processing all messages and received final delivery reports from the carrier. Null if send is still in progress or failed.',
    `compliance_consent_verified` BOOLEAN COMMENT 'Boolean flag indicating whether all recipients in this send have verified opt-in consent on file, as required by TCPA and CTIA guidelines. Critical for regulatory compliance and audit trails.',
    `conversion_count` STRING COMMENT 'The number of recipients who completed a desired action (purchase, registration, appointment booking) attributed to this SMS send via campaign tracking codes. Key ROI metric.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this SMS send record was first created in the marketing automation system. Represents the initial setup or draft creation event.',
    `delivered_count` STRING COMMENT 'The number of SMS messages successfully delivered to recipient mobile devices as confirmed by carrier delivery receipts. Key metric for send effectiveness and billing reconciliation.',
    `failed_count` STRING COMMENT 'The number of SMS messages that failed to deliver due to invalid numbers, carrier blocks, network errors, or recipient device issues. Used for list hygiene and troubleshooting.',
    `geographic_scope` STRING COMMENT 'The geographic targeting scope for this SMS send, such as national, regional, or specific metro areas. Used for localized campaigns and compliance with regional SMS regulations.',
    `is_mms` BOOLEAN COMMENT 'Boolean flag indicating whether this send included multimedia content (images, video, audio) making it an MMS rather than plain text SMS. MMS has different pricing and delivery characteristics.',
    `media_url` STRING COMMENT 'The URL of the multimedia asset (image, video, audio file) included in an MMS message. Null for standard SMS. Used for content tracking and compliance archiving.',
    `message_content` STRING COMMENT 'The actual text content of the SMS/MMS message sent to recipients. May include personalization tokens that were dynamically replaced per recipient. For MMS, this is the text portion; media URLs are tracked separately.',
    `message_length` STRING COMMENT 'The character count of the SMS message content. Standard SMS is 160 characters; longer messages are segmented. Used for billing and compliance tracking.',
    `message_segment_count` STRING COMMENT 'The number of SMS segments required to transmit the message. Messages over 160 characters are split into multiple segments, each billed separately. Critical for cost calculation.',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this SMS send record was last modified or updated. Tracks changes to send configuration, status updates, or metric refreshes.',
    `opt_out_count` STRING COMMENT 'The number of recipients who replied with STOP or unsubscribe keywords in response to this SMS send, triggering automatic removal from future sends. Critical for TCPA compliance and list management.',
    `platform_job_code` STRING COMMENT 'The unique job or batch identifier assigned by the SMS marketing automation platform (e.g., the e-commerce platform, Braze, Iterable) for this send execution. Used for platform-specific troubleshooting and reconciliation.',
    `scheduled_send_timestamp` TIMESTAMP COMMENT 'The planned date and time when the SMS send job was scheduled to execute. For immediate sends, this matches actual_send_timestamp. For scheduled sends, this represents the intended send time.',
    `send_cost_amount` DECIMAL(18,2) COMMENT 'The total cost incurred for this SMS send, calculated based on message segment count, recipient count, and carrier pricing. Used for campaign ROI analysis and budget tracking.',
    `send_cost_currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for the send cost amount. Typically USD for US operations, but may vary for international sends.. Valid values are `^[A-Z]{3}$`',
    `send_name` STRING COMMENT 'Human-readable name or label assigned to this SMS send event for identification and reporting purposes within the marketing automation platform.',
    `send_priority` STRING COMMENT 'The priority level assigned to this SMS send for queue processing. High priority sends are processed first, used for time-sensitive alerts or transactional messages. Normal and low priority for bulk promotional sends.. Valid values are `high|normal|low`',
    `send_status` STRING COMMENT 'Current lifecycle status of the SMS send job. Draft indicates preparation; scheduled indicates queued for future send; sending indicates in-progress; completed indicates all messages processed; failed indicates system error; cancelled indicates user-aborted.. Valid values are `draft|scheduled|sending|completed|failed|cancelled`',
    `send_type` STRING COMMENT 'Classification of the SMS send purpose. Promotional sends are marketing offers; transactional sends are order/account updates; alerts are time-sensitive notifications; reminders are appointment/event notifications; service messages are operational communications.. Valid values are `promotional|transactional|alert|reminder|notification|service`',
    `sender_code` STRING COMMENT 'The alphanumeric sender ID or long code phone number displayed to recipients as the message sender. Alternative to short codes, used for lower-volume or international sends.',
    `short_code` STRING COMMENT 'The 5-6 digit short code number used as the sender ID for this SMS send. Short codes are leased from carriers and used for high-volume marketing sends. Provides brand recognition and opt-out handling.',
    `target_country_codes` STRING COMMENT 'Comma-separated list of three-letter ISO 3166-1 alpha-3 country codes representing the countries targeted by this SMS send. Used for international campaign tracking and carrier routing.',
    `total_recipients` STRING COMMENT 'The total number of unique mobile phone numbers targeted by this SMS send. Represents the audience size before any delivery filtering or failures.',
    `tracked_url` STRING COMMENT 'The shortened, trackable URL included in the SMS message that redirects to the campaign landing page. Enables click tracking and attribution. Typically uses bit.ly or custom domain shortener.',
    `utm_campaign` STRING COMMENT 'The UTM campaign parameter embedded in tracked URLs to identify the specific campaign or promotion. Enables granular campaign performance tracking in web analytics.',
    `utm_medium` STRING COMMENT 'The UTM medium parameter embedded in tracked URLs to classify the marketing medium. Typically text-message or sms for SMS sends.',
    `utm_source` STRING COMMENT 'The UTM source parameter embedded in tracked URLs to identify the traffic source as SMS in web analytics. Standard value is sms for SMS channel attribution.',
    CONSTRAINT pk_sms_send PRIMARY KEY(`sms_send_id`)
) COMMENT 'Transactional record of a bulk or triggered SMS/MMS send event executed through the marketing automation platform. Captures send name, campaign reference, audience segment, message content, send timestamp, total recipients, delivered count, failed delivery count, opt-out count, click count (for tracked links), send type (promotional, transactional, alert), short code or sender ID, carrier routing, and SMS platform job ID. Represents the execution event for SMS/MMS channel marketing.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` (
    `push_notification_send_id` BIGINT COMMENT 'Unique identifier for the push notification send event. Primary key for this transactional record.',
    `audience_segment_id` BIGINT COMMENT 'Reference to the customer segment that was targeted for this push notification send. Defines the recipient population based on behavioral, demographic, or transactional criteria.',
    `campaign_id` BIGINT COMMENT 'Reference to the parent marketing campaign that this push notification send is part of. Links this send event to the broader campaign strategy and budget.',
    `associate_id` BIGINT COMMENT 'Reference to the user or system account that created this push notification send record. Supports audit trail and accountability.',
    `profile_id` BIGINT COMMENT 'Foreign key linking to customer.profile. Business justification: Push notifications target individual customer profiles for device-specific delivery, engagement tracking, and app-based customer journey orchestration. New FK required. Essential for mobile app market',
    `resend_of_push_notification_send_id` BIGINT COMMENT 'Self-referencing FK on push_notification_send (resend_of_push_notification_send_id)',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Push notifications target specific mobile apps/storefronts. Required for app-specific push performance measurement, ensures notifications route to correct app instance, and enables storefront-level mo',
    `ab_test_variant` STRING COMMENT 'The variant identifier if this push notification send is part of an A/B test or multivariate experiment. Used to compare performance across different message versions.',
    `action_button_1_label` STRING COMMENT 'The text label for the first action button displayed in the push notification. Enables direct customer actions such as Shop Now or View Details.',
    `action_button_1_url` STRING COMMENT 'The deep link URL associated with the first action button. Directs the customer to a specific app screen when the button is tapped.',
    `action_button_2_label` STRING COMMENT 'The text label for the second action button displayed in the push notification. Provides an alternative customer action option.',
    `action_button_2_url` STRING COMMENT 'The deep link URL associated with the second action button. Directs the customer to an alternative app screen when the button is tapped.',
    `actual_send_timestamp` TIMESTAMP COMMENT 'The actual date and time when the push notification send was executed by the marketing automation platform. Primary business event timestamp for this transaction.',
    `badge_count` STRING COMMENT 'The number displayed on the app icon badge after this notification is delivered. Used to indicate unread notifications or pending actions.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this push notification send record was first created in the marketing automation system. Audit trail for record creation.',
    `deep_link_url` STRING COMMENT 'The URL that directs the customer to a specific screen or content within the retailers mobile app when the notification is tapped. Enables direct navigation to relevant product, category, or promotional content.',
    `delivered_count` BIGINT COMMENT 'The number of push notifications that were successfully delivered to customer devices. Indicates successful transmission to the mobile operating system.',
    `dismissed_count` BIGINT COMMENT 'The number of customers who dismissed or swiped away the push notification without opening it. Indicates lack of engagement or relevance.',
    `failed_count` BIGINT COMMENT 'The number of push notifications that failed to deliver due to technical errors, invalid device tokens, or platform issues.',
    `image_url` STRING COMMENT 'The URL of the image asset displayed within the push notification. Rich media notifications can include product images, promotional banners, or brand visuals.',
    `is_silent_notification` BOOLEAN COMMENT 'Indicates whether this push notification was sent as a silent background notification without alerting the user. Used for data synchronization or app state updates.',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this push notification send record was last modified. Tracks the most recent update to the record.',
    `notification_body` STRING COMMENT 'The main message content or body text of the push notification. Provides detailed information or call-to-action to the customer.',
    `notification_title` STRING COMMENT 'The headline or title text displayed in the push notification on the customers mobile device. Primary attention-grabbing message component.',
    `opened_count` BIGINT COMMENT 'The number of customers who tapped or opened the push notification. Key engagement metric for measuring notification effectiveness.',
    `personalization_applied` BOOLEAN COMMENT 'Indicates whether dynamic personalization was applied to the notification content based on customer data. Personalized notifications may include customer name, product recommendations, or behavioral triggers.',
    `platform` STRING COMMENT 'The mobile operating system platform targeted by this push notification send. Determines the push notification service used (APNS for iOS, FCM for Android).. Valid values are `iOS|Android|both`',
    `priority` STRING COMMENT 'The delivery priority level assigned to this push notification send. High priority notifications are delivered immediately, while lower priority may be batched or delayed.. Valid values are `high|normal|low`',
    `push_platform_job_code` STRING COMMENT 'The unique job or batch identifier assigned by the push notification platform (e.g., Firebase Cloud Messaging, Apple Push Notification Service) for this send execution. Used for technical troubleshooting and reconciliation.',
    `scheduled_send_timestamp` TIMESTAMP COMMENT 'The planned date and time when the push notification send was scheduled to execute. Used for campaign planning and timing optimization.',
    `send_code` STRING COMMENT 'Unique business identifier or code for this push notification send, used for external reference and cross-system tracking.',
    `send_cost_amount` DECIMAL(18,2) COMMENT 'The total cost incurred for executing this push notification send, typically charged by the push notification platform provider on a per-message or per-recipient basis.',
    `send_cost_currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for the send cost amount. Enables multi-currency cost tracking for global marketing operations.. Valid values are `^[A-Z]{3}$`',
    `send_name` STRING COMMENT 'Human-readable name or title assigned to this specific push notification send for internal tracking and reporting purposes.',
    `send_status` STRING COMMENT 'Current lifecycle status of the push notification send event. Tracks the execution state from planning through completion.. Valid values are `draft|scheduled|in_progress|completed|failed|cancelled`',
    `send_type` STRING COMMENT 'Classification of the push notification send based on its business purpose and trigger mechanism. Determines the messaging strategy and expected customer response. [ENUM-REF-CANDIDATE: promotional|behavioral_trigger|cart_abandonment|price_drop_alert|order_update|loyalty_reward|back_in_stock — 7 candidates stripped; promote to reference product]',
    `sound_file_name` STRING COMMENT 'The name of the audio file played when the push notification is received. Enables custom notification sounds for different message types.',
    `target_recipient_count` BIGINT COMMENT 'The total number of customers or mobile devices that were targeted to receive this push notification send. Represents the intended audience size.',
    `time_to_live_seconds` STRING COMMENT 'The duration in seconds that the push notification platform will attempt to deliver the notification if the device is offline. After this period, the notification expires.',
    `utm_campaign` STRING COMMENT 'The UTM campaign parameter embedded in the deep link URL for campaign attribution tracking. Identifies the specific campaign or promotion.',
    `utm_medium` STRING COMMENT 'The UTM medium parameter embedded in the deep link URL for campaign attribution tracking. Typically set to push or mobile_push.',
    `utm_source` STRING COMMENT 'The UTM source parameter embedded in the deep link URL for campaign attribution tracking. Identifies the traffic source as push notification.',
    CONSTRAINT pk_push_notification_send PRIMARY KEY(`push_notification_send_id`)
) COMMENT 'Transactional record of a mobile push notification send event executed through the marketing automation platform for the retailers mobile app. Captures send name, campaign reference, audience segment, notification title and body, deep link URL, send timestamp, total recipients, delivered count, open count, dismissed count, send type (promotional, behavioral trigger, cart abandonment, price drop alert), platform (iOS, Android), and push platform job ID.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`social_post` (
    `social_post_id` BIGINT COMMENT 'Unique identifier for the social media post record. Primary key.',
    `account_id` BIGINT COMMENT 'The platform-specific unique identifier for the social media account (e.g., Facebook Page ID, Instagram Business Account ID). Used for API integration and cross-platform tracking.',
    `policy_id` BIGINT COMMENT 'Foreign key linking to compliance.policy. Business justification: Boosted social posts must comply with FTC disclosure policies and platform advertising policies. Real business need: approval workflow before paid promotion, regulatory compliance verification. Retail',
    `campaign_id` BIGINT COMMENT 'Reference to the marketing campaign this post is associated with, if applicable. Links post to upstream campaign strategy and budget allocation.',
    `creative_asset_id` BIGINT COMMENT 'Foreign key linking to marketing.creative_asset. Business justification: Social posts often use creative assets from the marketing asset library (images, videos, graphics). The social_post table has media_asset_url (STRING) which stores a URL, but if the asset is managed i',
    `marketing_brand_id` BIGINT COMMENT 'Reference to the retail brand or banner this post represents (e.g., main retail brand, private label brand, regional banner). Used for multi-brand portfolio management and brand performance analysis.',
    `associate_id` BIGINT COMMENT 'Reference to the internal user or marketing team member who created the post record. Used for content authorship tracking and workflow accountability.',
    `reply_to_social_post_id` BIGINT COMMENT 'Self-referencing FK on social_post (reply_to_social_post_id)',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Social posts promote specific storefronts/brands. Multi-brand retailers need storefront-level social performance tracking, brand-appropriate content governance, and channel-specific engagement metrics',
    `tertiary_social_modified_by_associate_id` BIGINT COMMENT 'Reference to the internal user who last modified the post record. Used for audit trail and accountability tracking.',
    `account_handle` STRING COMMENT 'The username or handle of the brand or banner account that published the post (e.g., @RetailBrandUSA). Identifies which corporate social account owns the post.',
    `actual_publish_timestamp` TIMESTAMP COMMENT 'The actual date and time when the post went live on the platform. May differ from scheduled time due to manual overrides, platform delays, or approval workflows.',
    `approved_timestamp` TIMESTAMP COMMENT 'The date and time when the post was approved for publication. Null if no approval workflow is required or if post is still in draft. Used for compliance and governance tracking.',
    `boost_budget_amount` DECIMAL(18,2) COMMENT 'The total budget allocated for boosting or promoting this post, in the currency specified by boost_budget_currency_code. Null for organic posts.',
    `boost_budget_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the boost budget (e.g., USD, EUR, GBP). Null for organic posts.. Valid values are `^[A-Z]{3}$`',
    `call_to_action` STRING COMMENT 'The primary call-to-action button or directive included in the post, particularly for boosted or paid posts. None indicates no explicit CTA. Used for conversion optimization and campaign effectiveness analysis. [ENUM-REF-CANDIDATE: shop_now|learn_more|sign_up|download|book_now|contact_us|apply_now|watch_more|none — 9 candidates stripped; promote to reference product]',
    `comments` BIGINT COMMENT 'The total number of comments the post received. Platform-reported metric; updated periodically via API sync.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this social post record was first created in the system. Used for audit trail and data lineage tracking.',
    `engagement_rate` DECIMAL(18,2) COMMENT 'The calculated engagement rate for the post, typically (likes + comments + shares) / reach. Expressed as a decimal (e.g., 0.0523 for 5.23%). May be calculated internally or sourced from platform analytics.',
    `hashtags` STRING COMMENT 'Comma-separated list of hashtags included in the post (e.g., #RetailDeals, #SummerSale, #BOPIS). Used for content categorization and trend analysis.',
    `impressions` BIGINT COMMENT 'The total number of times the post was displayed, including multiple views by the same user. Platform-reported metric; updated periodically via API sync.',
    `is_boosted` BOOLEAN COMMENT 'Indicates whether the post has paid media spend behind it (boosted or promoted). True means paid amplification is active; false means organic reach only.',
    `likes` BIGINT COMMENT 'The total number of likes or reactions the post received. Platform-reported metric; updated periodically via API sync.',
    `link_clicks` BIGINT COMMENT 'The total number of clicks on any links embedded in the post (e.g., product links, landing page URLs). Platform-reported metric; updated periodically via API sync.',
    `mentions` STRING COMMENT 'Comma-separated list of user handles or brand accounts mentioned in the post (e.g., @InfluencerName, @PartnerBrand). Used for influencer tracking and partnership attribution.',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this social post record was last modified in the system. Used for audit trail and data lineage tracking.',
    `platform` STRING COMMENT 'The social media platform where the post was published. X refers to the platform formerly known as Twitter. [ENUM-REF-CANDIDATE: Facebook|Instagram|TikTok|Pinterest|X|YouTube|LinkedIn — 7 candidates stripped; promote to reference product]',
    `platform_post_code` STRING COMMENT 'The unique identifier assigned by the social media platform to this post (e.g., Facebook Post ID, Instagram Media ID). Used for API integration and cross-system reconciliation.',
    `post_content` STRING COMMENT 'The full text content of the social media post, including captions, hashtags, and copy. May be null for image-only or video-only posts without text.',
    `post_status` STRING COMMENT 'Current lifecycle status of the post. Draft indicates content is being prepared; scheduled indicates approved and queued; published indicates live; failed indicates publication error; deleted indicates removed by user; archived indicates past content retained for compliance.. Valid values are `draft|scheduled|published|failed|deleted|archived`',
    `post_type` STRING COMMENT 'The format or media type of the social post. Carousel refers to multi-image swipeable posts; story refers to ephemeral 24-hour content; reel refers to short-form vertical video. [ENUM-REF-CANDIDATE: image|video|carousel|story|reel|live|link|text — 8 candidates stripped; promote to reference product]',
    `post_url` STRING COMMENT 'The direct URL link to the published post on the social media platform. Used for auditing, reporting, and customer service reference.',
    `reach` BIGINT COMMENT 'The total number of unique users who saw the post at least once. Platform-reported metric; updated periodically via API sync.',
    `saves` BIGINT COMMENT 'The total number of times users saved or bookmarked the post for later viewing. Applicable to platforms like Instagram and Pinterest. Platform-reported metric; updated periodically via API sync.',
    `scheduled_publish_timestamp` TIMESTAMP COMMENT 'The date and time when the post was scheduled to be published. Used for content calendar planning and automated publishing workflows.',
    `sentiment_score` DECIMAL(18,2) COMMENT 'Calculated sentiment score for the post based on comment analysis and engagement patterns, ranging from -1.00 (very negative) to +1.00 (very positive). May be derived from AI/ML sentiment analysis tools or third-party social listening platforms.',
    `shares` BIGINT COMMENT 'The total number of times the post was shared or reposted by users. Platform-reported metric; updated periodically via API sync.',
    `target_age_range` STRING COMMENT 'The age range targeted for boosted posts (e.g., 18-24, 25-34, 35-44). Null for organic posts or when age targeting is not applied.',
    `target_audience_definition` STRING COMMENT 'Textual description or JSON representation of the audience targeting parameters applied to boosted posts (e.g., age range, gender, interests, geographic regions). Null for organic posts.',
    `target_country_codes` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes representing the geographic targeting for boosted posts (e.g., USA,CAN,MEX). Null for organic posts or global targeting.',
    `target_gender` STRING COMMENT 'The gender demographic targeted for boosted posts. All indicates no gender filtering. Null for organic posts.. Valid values are `all|male|female|non-binary`',
    `video_views` BIGINT COMMENT 'The total number of video views for video or reel posts. Definition of a view varies by platform (e.g., 3 seconds on Facebook, 1 second on TikTok). Null for non-video posts. Platform-reported metric; updated periodically via API sync.',
    CONSTRAINT pk_social_post PRIMARY KEY(`social_post_id`)
) COMMENT 'Master record for organic and paid social media posts published across all social platforms (Facebook, Instagram, TikTok, Pinterest, X/Twitter, YouTube, LinkedIn) on behalf of the retailers brands and banners. Captures post content, platform, account/page, post type (image, video, carousel, story, reel, live), campaign association, scheduled and published timestamps, boosted/paid flag, targeting parameters if boosted, reach, impressions, engagements (likes, comments, shares, saves), link clicks, and post status.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`influencer` (
    `influencer_id` BIGINT COMMENT 'Unique identifier for the influencer or content creator partner. Primary key for the influencer master record.',
    `associate_id` BIGINT COMMENT 'The unique identifier of the user or system that created the influencer record.',
    `referred_by_influencer_id` BIGINT COMMENT 'Self-referencing FK on influencer (referred_by_influencer_id)',
    `agency_contact_email` STRING COMMENT 'The email address of the primary contact person at the talent agency.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `agency_contact_name` STRING COMMENT 'The name of the primary contact person at the talent agency representing the influencer.',
    `agency_name` STRING COMMENT 'The name of the talent agency or management company representing the influencer, if applicable.',
    `audience_age_range` STRING COMMENT 'The predominant age range of the influencers audience based on platform demographics.. Valid values are `13-17|18-24|25-34|35-44|45-54|55+`',
    `audience_gender_split` STRING COMMENT 'The gender distribution of the influencers audience, typically expressed as percentages (e.g., 60% Female, 40% Male).',
    `audience_geography` STRING COMMENT 'The primary geographic regions or countries where the influencers audience is located, expressed as comma-separated ISO 3-letter country codes or region names.',
    `content_niche` STRING COMMENT 'The primary content category or niche that the influencer specializes in. [ENUM-REF-CANDIDATE: Fashion|Beauty|Lifestyle|Fitness|Food|Travel|Tech|Gaming|Home|Parenting|Finance|Education — promote to reference product]',
    `contract_end_date` DATE COMMENT 'The date when the influencer contract or partnership agreement expires or is scheduled to terminate.',
    `contract_start_date` DATE COMMENT 'The date when the influencer contract or partnership agreement became effective.',
    `contract_status` STRING COMMENT 'The current status of the contractual relationship between the influencer and the retail organization.. Valid values are `Active|Pending|Expired|Terminated|Inactive`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the influencer record was first created in the system.',
    `email_address` STRING COMMENT 'The primary email address for contacting the influencer for business inquiries and campaign coordination.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `engagement_rate_percent` DECIMAL(18,2) COMMENT 'The average engagement rate (likes, comments, shares divided by followers) across the influencers primary platform, expressed as a percentage.',
    `exclusivity_terms` STRING COMMENT 'Description of any exclusivity clauses in the influencer contract, such as category exclusivity, competitor restrictions, or time-based exclusivity periods.',
    `facebook_follower_count` BIGINT COMMENT 'The total number of followers or page likes the influencer has on Facebook as of the last update.',
    `facebook_handle` STRING COMMENT 'The influencers username or page name on Facebook.',
    `ftc_disclosure_compliant` BOOLEAN COMMENT 'Indicates whether the influencer consistently follows FTC disclosure requirements for sponsored content and paid partnerships.',
    `full_name` STRING COMMENT 'The full legal or professional name of the influencer or content creator.',
    `instagram_follower_count` BIGINT COMMENT 'The total number of followers the influencer has on Instagram as of the last update.',
    `instagram_handle` STRING COMMENT 'The influencers username or handle on Instagram.. Valid values are `^@?[A-Za-z0-9._]{1,30}$`',
    `last_campaign_date` DATE COMMENT 'The date of the most recent campaign the influencer participated in for the retail organization.',
    `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when the influencer record was last modified or updated.',
    `notes` STRING COMMENT 'Free-text notes or comments about the influencer, including special requirements, preferences, past performance observations, or relationship management details.',
    `performance_rating` DECIMAL(18,2) COMMENT 'An internal performance rating for the influencer based on past campaign results, engagement quality, and professionalism, typically on a scale of 1.00 to 5.00.',
    `phone_number` STRING COMMENT 'The primary phone number for contacting the influencer.',
    `preferred_content_format` STRING COMMENT 'The primary content format the influencer specializes in or prefers to create for sponsored campaigns.. Valid values are `Photo|Video|Story|Reel|Live|Blog`',
    `primary_platform` STRING COMMENT 'The primary social media platform where the influencer has the largest following or engagement. [ENUM-REF-CANDIDATE: Instagram|TikTok|YouTube|Facebook|Twitter|LinkedIn|Pinterest|Snapchat|Twitch|Reddit — promote to reference product]',
    `rate_currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for the influencers rate (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `rate_per_post_amount` DECIMAL(18,2) COMMENT 'The standard fee or rate charged by the influencer for a single sponsored post or content piece.',
    `stage_name` STRING COMMENT 'The public-facing stage name, alias, or brand name used by the influencer across platforms.',
    `tier_classification` STRING COMMENT 'The tier classification of the influencer based on follower count: Nano (1K-10K), Micro (10K-100K), Macro (100K-1M), Mega (1M+), Celebrity (established public figure).. Valid values are `Nano|Micro|Macro|Mega|Celebrity`',
    `tiktok_follower_count` BIGINT COMMENT 'The total number of followers the influencer has on TikTok as of the last update.',
    `tiktok_handle` STRING COMMENT 'The influencers username or handle on TikTok.. Valid values are `^@?[A-Za-z0-9._]{1,24}$`',
    `total_campaigns_completed` STRING COMMENT 'The total number of marketing campaigns the influencer has completed with the retail organization to date.',
    `twitter_follower_count` BIGINT COMMENT 'The total number of followers the influencer has on Twitter (X) as of the last update.',
    `twitter_handle` STRING COMMENT 'The influencers username or handle on Twitter (X).. Valid values are `^@?[A-Za-z0-9_]{1,15}$`',
    `youtube_channel_name` STRING COMMENT 'The influencers YouTube channel name or handle.',
    `youtube_subscriber_count` BIGINT COMMENT 'The total number of subscribers the influencer has on YouTube as of the last update.',
    CONSTRAINT pk_influencer PRIMARY KEY(`influencer_id`)
) COMMENT 'Master record for influencer and content creator partners engaged for marketing campaigns. Captures influencer name, handle/username per platform, platform(s), follower count per platform, engagement rate, content niche/category, audience demographics, tier classification (nano, micro, macro, mega), contact information, agency representation, contract status, exclusivity terms, past campaign history, and compliance/FTC disclosure status. Enables influencer relationship management and campaign assignment.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` (
    `influencer_engagement_id` BIGINT COMMENT 'Unique identifier for the influencer engagement record. Primary key.',
    `campaign_id` BIGINT COMMENT 'Reference to the marketing campaign this influencer engagement is part of.',
    `policy_id` BIGINT COMMENT 'Foreign key linking to compliance.policy. Business justification: Influencer content requires FTC disclosure compliance (16 CFR Part 255 - Endorsement Guides). Real business need: ftc_disclosure_compliant_flag validation, legal review workflow. Retail influencer mar',
    `follow_up_influencer_engagement_id` BIGINT COMMENT 'Self-referencing FK on influencer_engagement (follow_up_influencer_engagement_id)',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Influencer payments must be classified to specific GL accounts (marketing expense, talent fees) for financial reporting and tax compliance including 1099 reporting. Finance requires this for proper ex',
    `associate_id` BIGINT COMMENT 'Reference to the employee or user who approved the influencer content.',
    `influencer_created_by_associate_id` BIGINT COMMENT 'Reference to the user or employee who created this influencer engagement record.',
    `influencer_id` BIGINT COMMENT 'Reference to the influencer or content creator participating in this engagement.',
    `influencer_modified_by_associate_id` BIGINT COMMENT 'Reference to the user or employee who last modified this influencer engagement record.',
    `actual_clicks_count` BIGINT COMMENT 'Number of clicks on links or call-to-action elements within the influencers content.',
    `actual_comments_count` BIGINT COMMENT 'Number of comments received on the published content.',
    `actual_engagement_count` BIGINT COMMENT 'Total number of user interactions with the content (likes, comments, shares, saves, clicks).',
    `actual_impressions_count` BIGINT COMMENT 'Total number of times the influencers content was displayed, including multiple views by the same user.',
    `actual_likes_count` BIGINT COMMENT 'Number of likes or reactions received on the published content.',
    `actual_reach_count` BIGINT COMMENT 'Actual number of unique users who saw the influencers content, as reported by the platform analytics.',
    `actual_shares_count` BIGINT COMMENT 'Number of times the content was shared or reposted by users.',
    `actual_video_views_count` BIGINT COMMENT 'Number of video views if the content is video format, as reported by the platform.',
    `approval_status` STRING COMMENT 'Status of content approval workflow (pending, approved, rejected, revision requested).. Valid values are `pending|approved|rejected|revision_requested`',
    `commission_rate_percent` DECIMAL(18,2) COMMENT 'Commission percentage rate applied to sales generated through this influencer engagement, if applicable.',
    `compensation_type` STRING COMMENT 'Type of compensation structure for this engagement (flat fee, commission-based, product gifting, or hybrid model).. Valid values are `flat_fee|commission|gifting|hybrid`',
    `content_approval_date` DATE COMMENT 'Date when the submitted content was approved by the brand or marketing team.',
    `content_publish_date` DATE COMMENT 'Date when the approved content was published or went live on the influencers platform.',
    `content_submission_date` DATE COMMENT 'Date when the influencer submitted content for review and approval.',
    `contract_end_date` DATE COMMENT 'Date when the influencer engagement contract expires or is completed.',
    `contract_start_date` DATE COMMENT 'Date when the influencer engagement contract becomes effective.',
    `contracted_deliverables` STRING COMMENT 'Description of the deliverables agreed upon in the influencer contract (e.g., number of posts, stories, videos, event attendance).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this influencer engagement record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this engagement.. Valid values are `^[A-Z]{3}$`',
    `disclosure_text` STRING COMMENT 'The actual disclosure text or hashtag used by the influencer to indicate sponsored content (e.g., #ad, #sponsored, #partner).',
    `engagement_code` STRING COMMENT 'Business identifier or reference code for this influencer engagement, used for tracking and reporting purposes.',
    `engagement_notes` STRING COMMENT 'Additional notes, comments, or special instructions related to this influencer engagement.',
    `engagement_status` STRING COMMENT 'Current lifecycle status of the influencer engagement (draft, contracted, content submitted, approved, published, completed, cancelled). [ENUM-REF-CANDIDATE: draft|contracted|content_submitted|approved|published|completed|cancelled — 7 candidates stripped; promote to reference product]',
    `engagement_type` STRING COMMENT 'Type of influencer engagement or activation (e.g., sponsored post, product seeding, affiliate partnership, brand ambassador program, event appearance, unboxing video, product review). [ENUM-REF-CANDIDATE: sponsored_post|product_seeding|affiliate|brand_ambassador|event_appearance|unboxing_video|product_review — 7 candidates stripped; promote to reference product]',
    `flat_fee_amount` DECIMAL(18,2) COMMENT 'Fixed monetary compensation amount agreed for this engagement, if applicable.',
    `ftc_disclosure_compliant_flag` BOOLEAN COMMENT 'Indicates whether the influencer content includes proper FTC-required disclosure of the sponsored relationship (true/false).',
    `gifting_value_amount` DECIMAL(18,2) COMMENT 'Monetary value of products or services gifted to the influencer as part of this engagement.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this influencer engagement record was last modified or updated.',
    `payment_date` DATE COMMENT 'Date when payment was issued to the influencer for this engagement.',
    `payment_reference_number` STRING COMMENT 'Reference number or transaction ID for the payment made to the influencer.',
    `payment_status` STRING COMMENT 'Current status of payment to the influencer (pending, scheduled, paid, cancelled).. Valid values are `pending|scheduled|paid|cancelled`',
    `platform_name` STRING COMMENT 'Social media or content platform where the influencer published the content (Instagram, TikTok, YouTube, Facebook, Twitter, Pinterest, blog). [ENUM-REF-CANDIDATE: instagram|tiktok|youtube|facebook|twitter|pinterest|blog — 7 candidates stripped; promote to reference product]',
    `published_content_url` STRING COMMENT 'URL or link to the published content on the influencers platform (social media post, blog, video).',
    `rejection_reason` STRING COMMENT 'Explanation or reason provided if the influencer content was rejected or revision was requested.',
    CONSTRAINT pk_influencer_engagement PRIMARY KEY(`influencer_engagement_id`)
) COMMENT 'Transactional record of a specific influencer engagement or activation within a marketing campaign. Captures influencer reference, campaign reference, engagement type (sponsored post, product seeding, affiliate, brand ambassador, event appearance), contracted deliverables, agreed compensation (flat fee, commission rate, gifting value), content submission dates, approval status, published content URLs, actual reach and engagement metrics delivered, payment status, and FTC disclosure compliance flag.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` (
    `attribution_touchpoint_id` BIGINT COMMENT 'Unique identifier for the attribution touchpoint event. Primary key for the immutable event record capturing each marketing interaction on the customer journey to conversion.',
    `attribution_model_id` BIGINT COMMENT 'Foreign key linking to marketing.attribution_model. Business justification: Attribution touchpoints are evaluated using attribution models. The attribution_touchpoint table has attribution_model_weight (DECIMAL) which implies a model was applied, but theres no FK to the attr',
    `audience_segment_id` BIGINT COMMENT 'Reference to the customer segment or audience list targeted by this touchpoint. Links to segmentation master data for segment-level attribution and targeting effectiveness.',
    `campaign_id` BIGINT COMMENT 'Reference to the marketing campaign that generated this touchpoint. Links to campaign master data for budget allocation, creative strategy, and campaign-level ROI measurement.',
    `creative_asset_id` BIGINT COMMENT 'Identifier of the specific creative asset (ad copy, image, video, email template) shown at this touchpoint. Enables creative-level performance analysis and A/B test attribution.',
    `sku_price_id` BIGINT COMMENT 'Foreign key linking to pricing.sku_price. Business justification: Attribution analysis needs to know which price point the customer saw at each touchpoint to understand price sensitivity and conversion drivers. Real business process: price elasticity modeling uses t',
    `header_id` BIGINT COMMENT 'Reference to the order or transaction that resulted from this customer journey. Populated only when conversion_event_flag is true. Links touchpoint to revenue for ROI calculation.',
    `marketing_brand_id` BIGINT COMMENT 'Reference to the retail brand promoted in this touchpoint. Used for brand-level attribution and multi-brand portfolio analysis in retail conglomerates.',
    `media_buy_id` BIGINT COMMENT 'Reference to the media buy or insertion order that funded this touchpoint. Links to media spend data for cost-per-touchpoint and ROAS (Return on Ad Spend) calculation.',
    `prior_attribution_touchpoint_id` BIGINT COMMENT 'Self-referencing FK on attribution_touchpoint (prior_attribution_touchpoint_id)',
    `category_id` BIGINT COMMENT 'Reference to the product category featured in this touchpoint creative. Used for category-level attribution and merchandising campaign effectiveness analysis.',
    `profile_id` BIGINT COMMENT 'Identifier of the known customer who encountered this touchpoint. Null for anonymous visitors prior to identification. Links to customer master data for attribution analysis by customer segment.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Attribution analysis in retail requires linking marketing touchpoints to specific SKUs purchased to measure product-level marketing effectiveness, calculate product-specific ROAS, and optimize media s',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Touchpoints occur on specific storefronts. Required for channel-specific attribution modeling, enables storefront-level marketing effectiveness measurement, and supports multi-channel attribution repo',
    `privacy_assessment_id` BIGINT COMMENT 'Foreign key linking to compliance.privacy_assessment. Business justification: Cross-device tracking and behavioral attribution require privacy assessment under GDPR Article 35 and CCPA. Real business need: legal basis validation for tracking technologies, data subject rights. R',
    `web_session_id` BIGINT COMMENT 'Identifier of the web or app session during which this touchpoint occurred. Groups touchpoints within a single browsing session for session-level attribution and path analysis.',
    `ad_network` STRING COMMENT 'The advertising network or platform that served this touchpoint (e.g., Google Ads, Facebook Ads, Criteo). Used for network-level attribution and vendor performance comparison.',
    `ad_placement` STRING COMMENT 'The specific placement or position where the ad was shown (e.g., search_top, sidebar, feed, pre_roll). Used for placement-level attribution and media optimization.',
    `anonymous_visitor_code` STRING COMMENT 'Pseudonymous identifier for unidentified visitors (cookie ID, device fingerprint, or session token). Used to track pre-conversion touchpoints before customer identification. May be stitched to customer_id post-conversion.',
    `channel_type` STRING COMMENT 'The marketing channel through which the touchpoint was delivered. Used for channel-level attribution and cross-channel ROI analysis. Aligns with GS1 digital marketing standards. [ENUM-REF-CANDIDATE: paid_search|organic_search|display|social_paid|social_organic|email|sms|push_notification|affiliate|direct|referral|video|native|audio|out_of_home — 15 candidates stripped; promote to reference product]',
    `conversion_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the conversion revenue amount. Required for multi-currency attribution reporting and global campaign analysis.. Valid values are `^[A-Z]{3}$`',
    `conversion_event_flag` BOOLEAN COMMENT 'Indicates whether this touchpoint directly resulted in a conversion event (purchase, signup, lead submission). True for the final converting touchpoint; false for assisting touchpoints.',
    `conversion_revenue_amount` DECIMAL(18,2) COMMENT 'The total revenue amount (in base currency) attributed to the conversion event linked to this touchpoint. Used for revenue-weighted attribution models and ROAS calculation.',
    `cost_per_touchpoint` DECIMAL(18,2) COMMENT 'The allocated media cost for this individual touchpoint (CPC for clicks, CPM-derived for impressions). Used for touchpoint-level ROI and efficiency analysis.',
    `device_type` STRING COMMENT 'The device category on which the touchpoint was delivered. Used for device-level attribution and omnichannel journey analysis. [ENUM-REF-CANDIDATE: desktop|mobile|tablet|smart_tv|wearable|voice_assistant|kiosk|unknown — 8 candidates stripped; promote to reference product]',
    `event_source_system` STRING COMMENT 'The source system or platform that captured this touchpoint event (e.g., Google Analytics, Adobe Analytics, the e-commerce platform). Used for data lineage and multi-source attribution reconciliation.',
    `geographic_city` STRING COMMENT 'The city derived from IP geolocation. Used for hyper-local attribution and store-level marketing campaign analysis in omnichannel retail.',
    `geographic_country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code derived from IP geolocation or device settings. Used for geographic attribution and regional campaign performance analysis.. Valid values are `^[A-Z]{3}$`',
    `geographic_region` STRING COMMENT 'The state, province, or region derived from IP geolocation. Used for sub-national geographic attribution and local market campaign analysis.',
    `ingestion_timestamp` TIMESTAMP COMMENT 'The timestamp when this touchpoint event was ingested into the lakehouse. Used for data freshness monitoring and late-arriving event handling in attribution pipelines.',
    `ip_address` STRING COMMENT 'The IP address of the device from which the touchpoint originated. Used for geographic attribution, fraud detection, and bot filtering. May be considered PII under GDPR.',
    `is_view_through` BOOLEAN COMMENT 'Indicates whether this touchpoint was a view-through (impression-only, no click) that contributed to conversion. True for display impressions that influenced purchase without direct click.',
    `landing_page_url` STRING COMMENT 'The destination URL where the customer landed after this touchpoint interaction. Used for landing page performance analysis and conversion funnel optimization.',
    `referrer_url` STRING COMMENT 'The full URL of the referring page that led to this touchpoint. Used for referral source analysis and organic traffic attribution when UTM parameters are absent.',
    `time_to_conversion_hours` DECIMAL(18,2) COMMENT 'The number of hours between this touchpoint and the eventual conversion event. Used for time-decay attribution models and customer journey velocity analysis.',
    `touchpoint_sequence_number` STRING COMMENT 'The ordinal position of this touchpoint in the customer journey (1 for first touch, incrementing for each subsequent touchpoint). Used for position-based attribution models.',
    `touchpoint_timestamp` TIMESTAMP COMMENT 'Precise date and time when the marketing touchpoint occurred (impression served, email opened, ad clicked, SMS delivered). Critical for time-decay attribution models and customer journey sequencing.',
    `touchpoint_type` STRING COMMENT 'The specific type of interaction or exposure at this touchpoint. Distinguishes passive impressions from active engagements for weighted attribution models. [ENUM-REF-CANDIDATE: impression|click|email_open|email_click|sms_click|push_open|push_click|video_view|video_complete|social_engagement|landing_page_view|form_submit — 12 candidates stripped; promote to reference product]',
    `user_agent` STRING COMMENT 'The browser and operating system user agent string captured at the touchpoint. Used for device and browser attribution analysis and technical compatibility tracking.',
    `utm_campaign` STRING COMMENT 'The UTM campaign parameter from the touchpoint URL, identifying the specific campaign name or code. Links web traffic to campaign master data for attribution analysis.',
    `utm_content` STRING COMMENT 'The UTM content parameter from the touchpoint URL, identifying the specific ad or link variant (e.g., banner_a, text_link). Used for creative-level A/B test attribution.',
    `utm_medium` STRING COMMENT 'The UTM medium parameter from the touchpoint URL, identifying the marketing medium (e.g., cpc, email, social). Used for channel classification and cross-channel attribution.',
    `utm_source` STRING COMMENT 'The UTM source parameter from the touchpoint URL, identifying the traffic source (e.g., google, facebook, newsletter). Standard parameter for digital marketing attribution and campaign tracking.',
    `utm_term` STRING COMMENT 'The UTM term parameter from the touchpoint URL, identifying the paid search keyword that triggered the ad. Used for keyword-level attribution and SEM (Search Engine Marketing) optimization.',
    CONSTRAINT pk_attribution_touchpoint PRIMARY KEY(`attribution_touchpoint_id`)
) COMMENT 'Immutable event record capturing each marketing touchpoint a customer encounters on their path to conversion. Captures customer or anonymous visitor identifier, touchpoint timestamp, channel type, campaign reference, creative asset reference, media buy reference, touchpoint type (impression, click, email open, SMS click, push open, social engagement), device type, session reference, and conversion event flag. Feeds multi-touch attribution models to measure channel contribution to sales and ROI.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`attribution_model` (
    `attribution_model_id` BIGINT COMMENT 'Unique identifier for the attribution model configuration. Primary key.',
    `associate_id` BIGINT COMMENT 'Identifier of the user who approved this attribution model configuration for production use. Part of the governance and audit trail.',
    `attribution_baseline_model_id` BIGINT COMMENT 'Reference to another attribution model used as the baseline for comparison and incrementality analysis. Enables A/B testing of attribution methodologies and measurement of model impact on ROI reporting.',
    `attribution_created_by_associate_id` BIGINT COMMENT 'Identifier of the user who created this attribution model configuration. Part of standard audit trail.',
    `attribution_modified_by_associate_id` BIGINT COMMENT 'Identifier of the user who last modified this attribution model configuration. Part of standard audit trail.',
    `org_unit_id` BIGINT COMMENT 'Identifier of the analytics or marketing team responsible for maintaining and governing this attribution model configuration.',
    `primary_superseded_attribution_model_id` BIGINT COMMENT 'Self-referencing FK on attribution_model (superseded_attribution_model_id)',
    `algorithmic_model_code` STRING COMMENT 'Reference identifier to the machine learning or data-driven model used for algorithmic attribution. Applicable only when model_type is algorithmic or data_driven. Links to the ML model registry or experiment tracking system.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this attribution model configuration was approved for production use. Part of the governance and audit trail.',
    `channel_weighting_rules` STRING COMMENT 'JSON or structured text defining the credit allocation rules per marketing channel. For position-based models, specifies percentage weights (e.g., first:40%, last:40%, middle:20%). For time-decay, defines the decay function parameters. For algorithmic models, references the ML model version.',
    `conversion_event_types` STRING COMMENT 'Comma-separated list of conversion event types in scope for this attribution model (e.g., purchase, add_to_cart, lead_submission, store_visit). Defines which customer actions are treated as conversions for credit assignment.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this attribution model record was first created in the system. Part of standard audit trail.',
    `cross_channel_enabled` BOOLEAN COMMENT 'Flag indicating whether this attribution model spans multiple marketing channels (omnichannel attribution). When true, touchpoints from online and offline channels are unified in the attribution path.',
    `cross_device_enabled` BOOLEAN COMMENT 'Flag indicating whether this attribution model includes cross-device tracking and attribution. When true, touchpoints across multiple devices (mobile, desktop, tablet) for the same user are unified in the attribution path.',
    `data_source_systems` STRING COMMENT 'Comma-separated list of source systems providing touchpoint and conversion data for this attribution model (e.g., Google Analytics, Adobe Analytics, the e-commerce platform, the retail analytics platform). Documents data lineage and integration points.',
    `deduplication_window_hours` STRING COMMENT 'Time window in hours used to deduplicate repeated touchpoints from the same channel. Multiple interactions within this window are collapsed into a single touchpoint to avoid over-crediting repetitive exposures.',
    `effective_end_date` DATE COMMENT 'Date on which this attribution model configuration ceases to be active. Null for currently active models. Used for historical model retirement and version transitions.',
    `effective_start_date` DATE COMMENT 'Date from which this attribution model configuration becomes active and is applied to campaign ROI (Return on Investment) reporting and analytics. Supports temporal model versioning.',
    `excluded_channels` STRING COMMENT 'Comma-separated list of marketing channels explicitly excluded from this attribution model (e.g., internal_traffic, test_campaigns). Used to filter out non-customer touchpoints or internal activity.',
    `included_channels` STRING COMMENT 'Comma-separated list of marketing channels included in this attribution model (e.g., paid_search, organic_search, email, social_media, display, affiliate, direct). Channels not listed are excluded from attribution credit.',
    `is_default_model` BOOLEAN COMMENT 'Flag indicating whether this is the default attribution model used for standard campaign ROI reporting when no specific model is requested. Only one model should be marked as default at any given time.',
    `lookback_window_days` STRING COMMENT 'Number of days prior to conversion during which touchpoints are considered for attribution credit. Common values are 7, 14, 30, 60, or 90 days. Defines the temporal scope of the customer journey included in attribution analysis.',
    `max_touchpoints_considered` STRING COMMENT 'Maximum number of touchpoints in a customer journey that will be included in attribution analysis. Touchpoints beyond this limit are truncated. Used to manage computational complexity and focus on most relevant interactions.',
    `min_touchpoints_required` STRING COMMENT 'Minimum number of marketing touchpoints required in a customer journey for attribution credit to be assigned. Journeys with fewer touchpoints may be excluded or handled differently. Common values are 1 (all journeys) or 2 (multi-touch only).',
    `model_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the model for system integration and reporting (e.g., LC_2024Q4, MTL_STD).. Valid values are `^[A-Z0-9_]{3,20}$`',
    `model_description` STRING COMMENT 'Detailed business description of the attribution models purpose, methodology, use cases, and any special considerations. Provides context for analysts and stakeholders on when and how to apply this model.',
    `model_name` STRING COMMENT 'Business-friendly name of the attribution model (e.g., Q4 2024 Last-Click Model, Multi-Touch Linear Attribution).',
    `model_status` STRING COMMENT 'Current lifecycle status of the attribution model. Active models are in production use; inactive models are paused; draft models are under development; archived models are retained for historical reference; deprecated models are superseded by newer versions.. Valid values are `active|inactive|draft|archived|deprecated`',
    `model_type` STRING COMMENT 'The methodology used to assign conversion credit across touchpoints. Last-click assigns 100% credit to the final touchpoint; first-click to the initial touchpoint; linear distributes credit equally; time-decay gives more weight to recent interactions; position-based (U-shaped) emphasizes first and last; algorithmic/data-driven uses machine learning to determine credit distribution. [ENUM-REF-CANDIDATE: last_click|first_click|linear|time_decay|position_based|algorithmic|data_driven — 7 candidates stripped; promote to reference product]',
    `model_version` STRING COMMENT 'Semantic version number of the attribution model configuration (e.g., v1.0, v2.1.3). Incremented when model parameters, weighting rules, or conversion definitions are updated. Enables historical comparison and audit trail.. Valid values are `^v[0-9]+.[0-9]+(.[0-9]+)?$`',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this attribution model record was last modified. Updated whenever any configuration parameter changes. Part of standard audit trail.',
    `reporting_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code used for all revenue and ROI calculations in this attribution model (e.g., USD, EUR, GBP). Ensures consistent financial reporting across campaigns.. Valid values are `^[A-Z]{3}$`',
    CONSTRAINT pk_attribution_model PRIMARY KEY(`attribution_model_id`)
) COMMENT 'Reference master defining the attribution model configurations used to assign conversion credit across marketing touchpoints. Captures model name, model type (last-click, first-click, linear, time-decay, position-based, data-driven/algorithmic), lookback window (days), conversion event types in scope, channel weighting rules, model version, active status, and owning analytics team. Enables consistent and auditable attribution methodology across all campaign ROI reporting.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`conversion_event` (
    `conversion_event_id` BIGINT COMMENT 'Unique identifier for the conversion event record. Primary key.',
    `assisted_by_conversion_event_id` BIGINT COMMENT 'Self-referencing FK on conversion_event (assisted_by_conversion_event_id)',
    `attribution_model_id` BIGINT COMMENT 'Foreign key linking to marketing.attribution_model. Business justification: Conversion events are attributed using attribution models. The conversion_event table has attribution_model (STRING) which stores the model name, but this should be normalized to a FK to attribution_m',
    `campaign_id` BIGINT COMMENT 'Identifier of the marketing campaign attributed to this conversion event. Links to the campaign that drove the conversion.',
    `associate_id` BIGINT COMMENT 'Identifier of the user or system process that created this conversion event record. Audit trail for record origin.',
    `conversion_modified_by_associate_id` BIGINT COMMENT 'Identifier of the user or system process that last modified this conversion event record. Audit trail for record changes.',
    `header_id` BIGINT COMMENT 'Identifier of the order or transaction associated with this conversion event, if applicable. Null for non-purchase conversions.',
    `location_id` BIGINT COMMENT 'Identifier of the physical store associated with this conversion event, if applicable. Relevant for BOPIS (Buy Online Pick Up In Store) and in-store conversions.',
    `profile_id` BIGINT COMMENT 'Identifier of the customer who completed the conversion event. Links to the customer who performed the action.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Conversion events must track which specific SKUs were purchased to attribute revenue to marketing activities at product level. Essential for product-level marketing attribution, calculating SKU-specif',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Conversions happen on specific storefronts. Essential for multi-channel conversion tracking, storefront-level marketing ROI calculation, and channel performance comparison—core requirement for retaile',
    `web_session_id` BIGINT COMMENT 'Identifier of the web or app session during which the conversion occurred. Links conversion to broader session analytics.',
    `attributed_channel` STRING COMMENT 'Marketing channel attributed to driving this conversion event based on the attribution model applied. [ENUM-REF-CANDIDATE: email|social_media|paid_search|organic_search|display|affiliate|direct — 7 candidates stripped; promote to reference product]',
    `attributed_revenue_amount` DECIMAL(18,2) COMMENT 'Revenue value attributed to this conversion event in the base currency. Represents the monetary value generated by the conversion.',
    `attributed_touchpoint` STRING COMMENT 'Specific marketing touchpoint or interaction attributed to driving this conversion. May include campaign creative, ad placement, or email message identifier.',
    `browser` STRING COMMENT 'Web browser used by the customer at the time of conversion. Captured for technical and user experience analysis.',
    `conversion_event_code` STRING COMMENT 'Business-readable unique code identifying this conversion event for reporting and tracking purposes.. Valid values are `^[A-Z0-9_]{3,20}$`',
    `conversion_notes` STRING COMMENT 'Free-text notes or comments about this conversion event. Captures additional context or special circumstances.',
    `conversion_page_url` STRING COMMENT 'URL of the page where the conversion event was completed. Identifies the exact location of the conversion action.',
    `conversion_path_length` STRING COMMENT 'Number of marketing touchpoints the customer interacted with before completing this conversion event. Measures the complexity of the customer journey.',
    `conversion_status` STRING COMMENT 'Current lifecycle status of the conversion event. Tracks whether the conversion was successfully completed or encountered issues.. Valid values are `completed|pending|cancelled|reversed|failed`',
    `conversion_timestamp` TIMESTAMP COMMENT 'Exact date and time when the conversion event occurred. Represents the moment the customer completed the conversion action.',
    `conversion_type` STRING COMMENT 'Type of conversion event that occurred. Categorizes the nature of the customer action that constitutes a conversion.. Valid values are `purchase|sign_up|loyalty_enrollment|app_install|bopis_order|email_subscription`',
    `conversion_value` DECIMAL(18,2) COMMENT 'Business value assigned to this conversion event, which may differ from revenue for non-purchase conversions. Used for ROI and campaign effectiveness measurement.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this conversion event record was first created in the system. Audit trail for record creation.',
    `device_type` STRING COMMENT 'Type of device used by the customer when the conversion event occurred. Enables device-based conversion analysis.. Valid values are `desktop|mobile|tablet|smart_tv|wearable|other`',
    `geographic_city` STRING COMMENT 'City where the customer was located at the time of conversion. Supports city-level conversion tracking.',
    `geographic_country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code representing the geographic location of the customer at the time of conversion.. Valid values are `^[A-Z]{3}$`',
    `geographic_region` STRING COMMENT 'State, province, or region where the customer was located at the time of conversion. Enables regional conversion analysis.',
    `is_new_customer` BOOLEAN COMMENT 'Boolean flag indicating whether this conversion represents a new customer acquisition. True if this is the customers first conversion event.',
    `is_omnichannel` BOOLEAN COMMENT 'Boolean flag indicating whether this conversion involved multiple channels in the customer journey. True if the conversion path crossed online and offline touchpoints.',
    `landing_page_url` STRING COMMENT 'URL of the page where the customer first landed in the session that led to conversion. Entry point for the conversion journey.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this conversion event record was last modified. Audit trail for record updates.',
    `operating_system` STRING COMMENT 'Operating system of the device used at the time of conversion. Supports platform-specific conversion analysis.',
    `referrer_url` STRING COMMENT 'URL of the page that referred the customer to the conversion page. Captures the immediate source of traffic.',
    `revenue_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the attributed revenue amount.. Valid values are `^[A-Z]{3}$`',
    `time_to_conversion_hours` DECIMAL(18,2) COMMENT 'Number of hours elapsed from the first attributed touchpoint to the conversion event. Measures the length of the conversion cycle.',
    `utm_campaign` STRING COMMENT 'UTM campaign parameter captured at the time of conversion. Identifies the specific campaign that drove the conversion.',
    `utm_content` STRING COMMENT 'UTM content parameter captured at the time of conversion. Differentiates similar content or links within the same campaign.',
    `utm_medium` STRING COMMENT 'UTM medium parameter captured at the time of conversion. Identifies the marketing medium used.',
    `utm_source` STRING COMMENT 'UTM source parameter captured at the time of conversion. Identifies the traffic source that referred the customer.',
    `utm_term` STRING COMMENT 'UTM term parameter captured at the time of conversion. Identifies paid search keywords.',
    CONSTRAINT pk_conversion_event PRIMARY KEY(`conversion_event_id`)
) COMMENT 'Transactional record of a customer conversion event attributed to a marketing campaign or touchpoint. Captures conversion event type (purchase, sign-up, loyalty enrollment, app install, BOPIS order, email subscription, account creation), customer identifier, order or transaction reference, conversion timestamp, attributed campaign, attributed channel, attribution model applied, attributed revenue value, and conversion path length (number of touchpoints). Serves as the authoritative record linking marketing activity to business outcomes.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` (
    `marketing_budget_id` BIGINT COMMENT 'Unique identifier for the marketing budget record. Primary key.',
    `campaign_id` BIGINT COMMENT 'Reference to the parent marketing campaign if this budget is allocated at the campaign level. Null for channel-level or master budgets.',
    `cost_center_id` BIGINT COMMENT 'Reference to the finance cost center responsible for this marketing budget allocation. Links to finance.cost_center for GL reconciliation.',
    `associate_id` BIGINT COMMENT 'Reference to the user who created this budget record.',
    `marketing_brand_id` BIGINT COMMENT 'Reference to the retail brand or banner for which this budget is allocated (e.g., store brand, private label, or retail banner).',
    `marketing_modified_by_associate_id` BIGINT COMMENT 'Reference to the user who last modified this budget record.',
    `primary_marketing_associate_id` BIGINT COMMENT 'Reference to the employee or user who owns and is accountable for this budget allocation and its performance.',
    `revised_from_marketing_budget_id` BIGINT COMMENT 'Self-referencing FK on marketing_budget (revised_from_marketing_budget_id)',
    `actual_spend_to_date` DECIMAL(18,2) COMMENT 'Total actual expenditure against this budget as of the current date, including all invoiced and paid amounts.',
    `agency_fees_budget` DECIMAL(18,2) COMMENT 'Budget allocation for external agency retainers, project fees, and consulting services.',
    `approval_status` STRING COMMENT 'Current approval workflow status for this budget allocation. Tracks progression through the approval chain.. Valid values are `not_submitted|pending|approved|rejected|revision_requested`',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this budget allocation was officially approved and became active.',
    `budget_code` STRING COMMENT 'Unique business identifier or code for the budget allocation, used for cross-system reference and reporting.',
    `budget_name` STRING COMMENT 'Descriptive name of the marketing budget allocation (e.g., Q1 2024 Digital Campaign Budget, Holiday Season Omnichannel Budget).',
    `budget_status` STRING COMMENT 'Current lifecycle status of the budget allocation. Tracks progression from draft through approval to active execution and closure.. Valid values are `draft|pending_approval|approved|active|closed|cancelled`',
    `committed_spend` DECIMAL(18,2) COMMENT 'Total amount of budget committed through media buys, agency contracts, and vendor bookings but not yet invoiced or paid.',
    `content_production_budget` DECIMAL(18,2) COMMENT 'Budget allocation for creative content production including photography, videography, copywriting, and design services.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this budget record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the budget amounts (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `digital_channel_budget` DECIMAL(18,2) COMMENT 'Budget allocation specifically for digital marketing channels including e-commerce, social media, search, display, and email.',
    `display_advertising_budget` DECIMAL(18,2) COMMENT 'Budget allocation for display advertising including banner ads, video ads, and programmatic advertising.',
    `email_marketing_budget` DECIMAL(18,2) COMMENT 'Budget allocation for email marketing campaigns, automation platforms, and SMS marketing activities.',
    `end_date` DATE COMMENT 'Effective end date for this budget allocation period. Spending against this budget must occur before this date.',
    `events_sponsorship_budget` DECIMAL(18,2) COMMENT 'Budget allocation for event marketing, trade shows, sponsorships, and experiential marketing activities.',
    `fiscal_period` STRING COMMENT 'The fiscal period within the year (quarterly, half-yearly, or annual) for which this budget is allocated. [ENUM-REF-CANDIDATE: Q1|Q2|Q3|Q4|H1|H2|Annual — 7 candidates stripped; promote to reference product]',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this budget allocation applies (e.g., 2024).',
    `geographic_scope` STRING COMMENT 'Geographic scope of the marketing budget allocation indicating whether it covers national, regional, local, or international markets.. Valid values are `national|regional|local|international|global`',
    `influencer_marketing_budget` DECIMAL(18,2) COMMENT 'Budget allocation for influencer partnerships, sponsored content, and brand ambassador programs.',
    `last_revision_date` DATE COMMENT 'Date when this budget allocation was last revised or amended. Tracks budget reforecasting and reallocation activities.',
    `market_research_budget` DECIMAL(18,2) COMMENT 'Budget allocation for market research, consumer insights, competitive analysis, and brand tracking studies.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this budget record was last modified or updated.',
    `notes` STRING COMMENT 'Free-form notes and comments about this budget allocation including strategic context, constraints, or special instructions.',
    `remaining_budget` DECIMAL(18,2) COMMENT 'Remaining unallocated budget calculated as total approved budget minus committed spend and actual spend to date.',
    `revision_reason` STRING COMMENT 'Business justification or reason for the most recent budget revision (e.g., Increased holiday season demand, Campaign performance reallocation).',
    `search_engine_marketing_budget` DECIMAL(18,2) COMMENT 'Budget allocation for paid search advertising including Google Ads, Bing Ads, and other search engine marketing platforms.',
    `social_media_budget` DECIMAL(18,2) COMMENT 'Budget allocation specifically for social media marketing activities across platforms (Facebook, Instagram, Twitter, LinkedIn, TikTok).',
    `start_date` DATE COMMENT 'Effective start date for this budget allocation period. Spending against this budget is valid from this date forward.',
    `target_country_codes` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes where this budget will be deployed (e.g., USA,CAN,MEX).',
    `target_revenue_goal` DECIMAL(18,2) COMMENT 'Target revenue goal that this marketing budget is expected to generate or influence through campaign activities.',
    `target_roi_percentage` DECIMAL(18,2) COMMENT 'Target return on investment percentage expected from this marketing budget allocation. Used for performance measurement and attribution analysis.',
    `total_approved_budget` DECIMAL(18,2) COMMENT 'Total approved budget amount for this allocation across all channels and campaigns. Represents the authorized spending limit.',
    `traditional_channel_budget` DECIMAL(18,2) COMMENT 'Budget allocation for traditional marketing channels including TV, radio, print, outdoor, and direct mail.',
    `utilization_percentage` DECIMAL(18,2) COMMENT 'Percentage of total approved budget that has been spent or committed, calculated as (actual_spend_to_date + committed_spend) / total_approved_budget * 100.',
    CONSTRAINT pk_marketing_budget PRIMARY KEY(`marketing_budget_id`)
) COMMENT 'Master record for marketing budget allocations by campaign, channel, brand/banner, fiscal period, and cost center. Captures budget name, fiscal year and period, total approved budget, channel-level budget breakdown, campaign-level allocation, committed spend (media buys and agency fees booked), actual spend to date, remaining budget, budget owner, approval status, and last revision date. Distinct from finance.budget which is the GL-level financial SSOT — this entity is the marketing-owned operational spend plan used for campaign planning and pacing.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` (
    `marketing_brand_id` BIGINT COMMENT 'Unique identifier for the marketing brand record. Primary key.',
    `associate_id` BIGINT COMMENT 'Employee identifier of the user who created this brand record.',
    `marketing_modified_by_associate_id` BIGINT COMMENT 'Employee identifier of the user who last modified this brand record.',
    `parent_marketing_brand_id` BIGINT COMMENT 'Self-referencing FK on marketing_brand (parent_marketing_brand_id)',
    `primary_marketing_associate_id` BIGINT COMMENT 'Employee identifier of the brand manager or marketing lead responsible for this brand.',
    `accent_color_hex` STRING COMMENT 'Hexadecimal color code for the brands accent color used for highlights and call-to-action elements.. Valid values are `^#[0-9A-Fa-f]{6}$`',
    `annual_marketing_budget_amount` DECIMAL(18,2) COMMENT 'Total annual marketing budget allocated to this brand for campaigns, media, and promotional activities.',
    `approval_status` STRING COMMENT 'Current approval workflow status for this brand record, particularly relevant for new brand launches or brand guideline updates.. Valid values are `draft|pending_approval|approved|rejected`',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this brand record or brand guidelines were officially approved.',
    `brand_category` STRING COMMENT 'Primary product category or merchandise division this brand operates within (e.g., apparel, electronics, grocery, home goods).',
    `brand_code` STRING COMMENT 'Internal alphanumeric code used to uniquely identify the brand in marketing systems and campaigns.. Valid values are `^[A-Z0-9]{3,10}$`',
    `brand_name` STRING COMMENT 'The official marketing name of the brand as presented to consumers across all channels.',
    `brand_status` STRING COMMENT 'Current lifecycle status of the brand in the marketing portfolio.. Valid values are `active|inactive|pending_launch|discontinued|under_review|sunset`',
    `brand_tier` STRING COMMENT 'Price and quality positioning tier of the brand within the retail portfolio.. Valid values are `premium|mid_tier|value|economy`',
    `brand_type` STRING COMMENT 'Classification of the brand ownership and positioning model: national banner (third-party national brand), private label (store-owned brand), sub-brand (variant of parent brand), co-brand (partnership brand), licensed brand (licensed IP), or exclusive brand (retailer-exclusive third-party).. Valid values are `national_banner|private_label|sub_brand|co_brand|licensed_brand|exclusive_brand`',
    `budget_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the annual marketing budget amount.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this brand record was first created in the marketing system.',
    `discontinuation_date` DATE COMMENT 'Date when the brand was discontinued or sunset from the active portfolio. Null for active brands.',
    `equity_score` DECIMAL(18,2) COMMENT 'Quantitative brand equity index score derived from brand health tracking studies, measuring overall brand strength, awareness, and consumer perception. Scale and methodology defined by marketing analytics team.',
    `geographic_scope` STRING COMMENT 'Geographic reach and distribution scope of the brand: global (worldwide), regional (multi-country region), national (single country), or local (specific markets or stores).. Valid values are `global|regional|national|local`',
    `guidelines_document_reference` STRING COMMENT 'URI or document management system reference to the official brand guidelines document containing usage rules, visual standards, and messaging frameworks.',
    `health_tracking_status` STRING COMMENT 'Indicates whether this brand is actively monitored through brand health tracking studies measuring awareness, consideration, preference, and loyalty metrics.. Valid values are `tracked|not_tracked|paused`',
    `is_omnichannel` BOOLEAN COMMENT 'Boolean flag indicating whether this brand is marketed and sold across multiple channels (stores, e-commerce, mobile, marketplaces) with unified brand experience.',
    `is_sustainable_brand` BOOLEAN COMMENT 'Boolean flag indicating whether this brand is positioned and marketed with a sustainability or environmental responsibility focus.',
    `launch_date` DATE COMMENT 'Date when the brand was officially launched or introduced to the market.',
    `logo_asset_reference` STRING COMMENT 'Digital asset management system reference or URI pointing to the primary brand logo file in approved formats.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this brand record was last modified or updated.',
    `net_promoter_score` DECIMAL(18,2) COMMENT 'Most recent Net Promoter Score for this brand, measuring customer loyalty and likelihood to recommend. Score ranges from -100 to +100.',
    `owning_marketing_team` STRING COMMENT 'Name or identifier of the marketing team or business unit responsible for managing this brands strategy, campaigns, and performance.',
    `positioning_statement` STRING COMMENT 'Strategic statement defining the brands unique value proposition, target audience, and competitive differentiation in the market.',
    `primary_color_hex` STRING COMMENT 'Hexadecimal color code for the brands primary color used in visual identity and marketing materials.. Valid values are `^#[0-9A-Fa-f]{6}$`',
    `secondary_color_hex` STRING COMMENT 'Hexadecimal color code for the brands secondary color used in visual identity and marketing materials.. Valid values are `^#[0-9A-Fa-f]{6}$`',
    `social_media_handles` STRING COMMENT 'JSON or comma-separated list of official social media account handles for this brand across platforms (e.g., @brandname on Twitter, Facebook, Instagram).',
    `tagline` STRING COMMENT 'Official tagline or slogan associated with the brand used in advertising and marketing communications.',
    `target_country_codes` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes where this brand is marketed and sold.',
    `target_demographic` STRING COMMENT 'Primary demographic profile of the intended consumer audience for this brand, including age range, income level, lifestyle attributes, and psychographic characteristics.',
    `tone_of_voice` STRING COMMENT 'Descriptive characterization of the brands communication style and personality used in messaging, content, and customer interactions (e.g., friendly and approachable, professional and authoritative, playful and energetic).',
    `website_url` STRING COMMENT 'Primary website URL or landing page dedicated to this brand for consumer engagement and information.',
    CONSTRAINT pk_marketing_brand PRIMARY KEY(`marketing_brand_id`)
) COMMENT 'Master record for retail brand and banner identities managed by the marketing organization. Captures brand name, brand type (national banner, private label, sub-brand, co-brand), brand positioning statement, target demographic, brand guidelines document reference, logo asset reference, color palette, tone of voice, brand health tracking status, launch date, and owning marketing team. Distinct from product.brand which is the merchandise catalog brand SSOT — this entity represents the marketing-managed brand identity and strategy layer.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`channel` (
    `channel_id` BIGINT COMMENT 'Unique identifier for the marketing channel. Primary key.',
    `associate_id` BIGINT COMMENT 'User identifier of the person who created this channel record, for audit trail purposes.',
    `channel_modified_by_user_associate_id` BIGINT COMMENT 'User identifier of the person who last modified this channel record, for audit trail purposes.',
    `parent_channel_id` BIGINT COMMENT 'Self-referencing FK on channel (parent_channel_id)',
    `api_authentication_method` STRING COMMENT 'Authentication method required for API integration: OAuth, API key, basic authentication, SAML (Security Assertion Markup Language), or none.. Valid values are `oauth|api_key|basic_auth|saml|none`',
    `api_endpoint_url` STRING COMMENT 'API endpoint URL for programmatic integration with the channel platform, used by marketing automation systems.',
    `attribution_window_days` STRING COMMENT 'Number of days after interaction during which conversions are attributed to this channel for attribution analytics.',
    `average_cpa_amount` DECIMAL(18,2) COMMENT 'Average cost per acquisition or conversion for this channel, key metric for ROI (Return on Investment) measurement.',
    `average_cpc_amount` DECIMAL(18,2) COMMENT 'Average cost per click for this channel, used for performance benchmarking and budget allocation.',
    `average_cpm_amount` DECIMAL(18,2) COMMENT 'Average cost per thousand impressions for this channel, used for budget planning and ROI (Return on Investment) analysis.',
    `channel_category` STRING COMMENT 'High-level classification of the channel: owned (company-controlled properties), earned (organic reach), or paid (purchased media).. Valid values are `owned|earned|paid`',
    `channel_type` STRING COMMENT 'Specific type of marketing channel. Examples: email, SMS (Short Message Service), push notification, paid search, paid social, display advertising, video, OOH (Out-of-Home), print, radio, TV (Television), in-store, affiliate. [ENUM-REF-CANDIDATE: email|sms|push|paid_search|paid_social|display|video|ooh|print|radio|tv|in_store|affiliate — promote to reference product]',
    `channel_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the channel for reporting and integration purposes.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `compliance_notes` STRING COMMENT 'Notes on regulatory compliance requirements specific to this channel (e.g., CAN-SPAM for email, TCPA for SMS, GDPR for digital advertising in EU).',
    `contract_end_date` DATE COMMENT 'End date or renewal date of the vendor contract for this channel. Null if contract is evergreen or month-to-month.',
    `contract_start_date` DATE COMMENT 'Start date of the vendor contract or service agreement for this channel.',
    `cost_model` STRING COMMENT 'Pricing model for the channel: CPM (Cost Per Mille/Thousand Impressions), CPC (Cost Per Click), CPA (Cost Per Acquisition), flat (fixed fee), hybrid (combination), performance (outcome-based).. Valid values are `cpm|cpc|cpa|flat|hybrid|performance`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this channel record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all cost metrics associated with this channel (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `data_refresh_frequency` STRING COMMENT 'Frequency at which performance data from this channel is refreshed in the marketing analytics platform: real-time, hourly, daily, weekly, or manual.. Valid values are `real_time|hourly|daily|weekly|manual`',
    `channel_description` STRING COMMENT 'Detailed description of the channel, including its purpose, audience reach, and typical use cases within the marketing strategy.',
    `geographic_coverage` STRING COMMENT 'Geographic regions or markets where this channel is available and effective (e.g., USA, CAN, GBR, global).',
    `integration_status` STRING COMMENT 'Current integration status with the marketing automation platform: integrated (fully connected), pending (in progress), not_integrated (manual or offline), deprecated (legacy, no longer used).. Valid values are `integrated|pending|not_integrated|deprecated`',
    `is_active` BOOLEAN COMMENT 'Indicates whether the channel is currently active and available for campaign execution. True if active, False if inactive or retired.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this channel record was last modified or updated.',
    `channel_name` STRING COMMENT 'The business name of the marketing channel (e.g., Google Ads, Facebook, Email Newsletter, In-Store Display).',
    `owner_email` STRING COMMENT 'Email address of the channel owner for operational communication and escalation.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `owner_name` STRING COMMENT 'Name of the individual or team responsible for managing and optimizing this channel.',
    `platform_vendor_name` STRING COMMENT 'Name of the platform or vendor providing the channel service (e.g., Google, Meta, the e-commerce platform, Mailchimp, Adobe Campaign).',
    `primary_kpi` STRING COMMENT 'The primary key performance indicator used to measure success for this channel (e.g., CTR (Click-Through Rate), conversion rate, ROAS (Return on Ad Spend), engagement rate).',
    `supports_ab_testing` BOOLEAN COMMENT 'Indicates whether the channel supports A/B testing or multivariate testing for campaign optimization. True if supported, False otherwise.',
    `supports_automation` BOOLEAN COMMENT 'Indicates whether the channel supports marketing automation workflows (e.g., triggered campaigns, drip sequences). True if supported, False otherwise.',
    `supports_personalization` BOOLEAN COMMENT 'Indicates whether the channel supports personalized content delivery based on customer data and segmentation. True if supported, False otherwise.',
    `target_audience_profile` STRING COMMENT 'Description of the typical audience demographics and psychographics that this channel reaches most effectively.',
    `vendor_contract_number` STRING COMMENT 'Contract or agreement number with the channel vendor or platform provider, used for procurement and compliance tracking.',
    CONSTRAINT pk_channel PRIMARY KEY(`channel_id`)
) COMMENT 'Reference master defining all marketing channels used for campaign execution and media planning. Captures channel name, channel category (owned, earned, paid), channel type (email, SMS, push, paid search, paid social, display, video, OOH, print, radio, TV, in-store, affiliate), platform or vendor name, integration status with marketing automation platform, cost model (CPM, CPC, CPA, flat), and active status. Provides standardized channel taxonomy for consistent reporting and budget allocation across all campaigns.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` (
    `utm_parameter_id` BIGINT COMMENT 'Unique identifier for the UTM parameter configuration record.',
    `campaign_id` BIGINT COMMENT 'Reference to the parent marketing campaign that this UTM parameter configuration supports.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to marketing.marketing_channel. Business justification: UTM parameters are used to tag URLs for channel tracking and should reference the authoritative marketing_channel master. Currently, utm_parameter has a denormalized channel_type STRING attribute. Add',
    `derived_from_utm_parameter_id` BIGINT COMMENT 'Self-referencing FK on utm_parameter (derived_from_utm_parameter_id)',
    `associate_id` BIGINT COMMENT 'User identifier of the person who created this UTM parameter configuration record.',
    `tertiary_utm_approved_by_user_associate_id` BIGINT COMMENT 'User identifier of the person who approved this UTM parameter configuration for campaign use.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this UTM parameter configuration was approved for use in marketing campaigns.',
    `base_url` STRING COMMENT 'The destination URL before UTM parameters are appended (e.g., https://www.retailer.com/products/shoes). Used as the foundation for tagged URL construction.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this UTM parameter configuration record was first created in the system.',
    `creative_asset_reference` STRING COMMENT 'Reference identifier to the creative asset (banner, video, email template) associated with this UTM configuration. Links to Digital Asset Management (DAM) system.',
    `effective_end_date` DATE COMMENT 'Date after which this UTM parameter configuration is no longer valid for use. Null indicates no expiration.',
    `effective_start_date` DATE COMMENT 'Date from which this UTM parameter configuration is valid and approved for use in marketing campaigns.',
    `full_tagged_url` STRING COMMENT 'Complete URL with all UTM parameters appended as query string. This is the final URL used in marketing materials and campaigns.',
    `geographic_target` STRING COMMENT 'Geographic scope for this UTM configuration (e.g., USA, CAN, GBR, global). Uses ISO 3166-1 alpha-3 country codes or global for worldwide campaigns.',
    `is_active` BOOLEAN COMMENT 'Boolean flag indicating whether this UTM parameter configuration is currently active and approved for use in marketing campaigns.',
    `last_used_date` DATE COMMENT 'Date when this UTM parameter configuration was most recently used in a campaign or marketing material.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this UTM parameter configuration record was most recently modified.',
    `notes` STRING COMMENT 'Free-text notes providing additional context, usage instructions, or special considerations for this UTM parameter configuration.',
    `owning_team` STRING COMMENT 'Name of the marketing team or business unit responsible for managing and maintaining this UTM parameter configuration.',
    `parameter_code` STRING COMMENT 'Unique business code for this UTM parameter configuration, used for system integration and lookup.. Valid values are `^[A-Z0-9_]{3,20}$`',
    `parameter_name` STRING COMMENT 'Human-readable name for this UTM parameter configuration, used for internal reference and governance.',
    `parameter_status` STRING COMMENT 'Current lifecycle status of this UTM parameter configuration. Active configurations are approved for use in campaigns.. Valid values are `active|inactive|draft|archived|deprecated`',
    `platform_integration` STRING COMMENT 'Name of the marketing platform or tool where this UTM configuration is deployed (e.g., Google Ads, Facebook Ads Manager, the e-commerce platform, Mailchimp).',
    `short_url` STRING COMMENT 'Shortened version of the full tagged URL, used in space-constrained marketing materials such as SMS, social media posts, or print ads.',
    `target_audience_segment` STRING COMMENT 'Description of the audience segment this UTM configuration is intended to reach (e.g., high_value_customers, new_prospects, cart_abandoners).',
    `taxonomy_version` STRING COMMENT 'Version identifier of the UTM taxonomy standard applied to this configuration. Ensures consistency across campaigns and prevents taxonomy drift.',
    `tracking_domain` STRING COMMENT 'Domain used for URL shortening or click tracking (e.g., bit.ly, custom branded domain). Used when the full tagged URL is shortened for display purposes.',
    `usage_count` STRING COMMENT 'Number of times this UTM parameter configuration has been deployed in marketing campaigns or materials. Used for governance and reuse tracking.',
    `utm_campaign` STRING COMMENT 'Identifies the specific campaign name (e.g., spring_sale_2024, black_friday, back_to_school). Used to group related marketing efforts.',
    `utm_content` STRING COMMENT 'Identifies the specific content or creative variant within a campaign (e.g., banner_ad_1, text_link, hero_image). Used for A/B testing and creative performance analysis.',
    `utm_medium` STRING COMMENT 'Identifies the marketing medium (e.g., cpc, email, social, display, affiliate). Represents the channel type.',
    `utm_source` STRING COMMENT 'Identifies the source of traffic (e.g., google, facebook, newsletter, affiliate_partner). Represents the referrer or origin platform.',
    `utm_term` STRING COMMENT 'Identifies the paid search keyword or term that triggered the ad (e.g., running_shoes, discount_electronics). Primarily used for paid search campaigns.',
    `validation_errors` STRING COMMENT 'Description of any validation errors or warnings identified during automated quality checks. Used for governance and correction workflows.',
    `validation_status` STRING COMMENT 'Status of automated validation checks for this UTM parameter configuration. Ensures compliance with naming conventions and taxonomy rules.. Valid values are `valid|invalid|pending_review|requires_correction`',
    CONSTRAINT pk_utm_parameter PRIMARY KEY(`utm_parameter_id`)
) COMMENT 'Master record for standardized UTM parameter configurations used to tag marketing URLs for campaign tracking across digital channels. Captures UTM source, UTM medium, UTM campaign, UTM content, UTM term, full tagged URL, campaign reference, channel reference, creative asset reference, creation date, created by, and active status. Ensures consistent UTM taxonomy governance to prevent fragmented or inconsistent tagging that would corrupt attribution and web analytics data.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` (
    `ab_test_campaign_id` BIGINT COMMENT 'Unique identifier for the A/B test campaign record. Primary key.',
    `associate_id` BIGINT COMMENT 'Reference to the employee or user who created this A/B test campaign record.',
    `ab_modified_by_associate_id` BIGINT COMMENT 'Reference to the employee or user who last modified this A/B test campaign record.',
    `audience_segment_id` BIGINT COMMENT 'Reference to the audience segment used for this A/B test, defining the target population.',
    `baseline_ab_test_campaign_id` BIGINT COMMENT 'Self-referencing FK on ab_test_campaign (baseline_ab_test_campaign_id)',
    `campaign_id` BIGINT COMMENT 'Reference to the parent marketing campaign under which this A/B test is conducted.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to marketing.marketing_channel. Business justification: A/B test campaigns are conducted within specific marketing channels and should reference the authoritative marketing_channel master. Currently, ab_test_campaign has a denormalized channel_tested STRIN',
    `creative_asset_id` BIGINT COMMENT 'Foreign key linking to marketing.creative_asset. Business justification: A/B tests often test different creative variants. The ab_test_campaign should link to the creative_asset being tested. The control_variant_definition and test_variant_definition are STRING description',
    `primary_ab_associate_id` BIGINT COMMENT 'Reference to the employee or user responsible for designing, executing, and analyzing this A/B test.',
    `sku_price_id` BIGINT COMMENT 'Foreign key linking to pricing.sku_price. Business justification: A/B tests in retail frequently test different price points or promotional depths. Test variant definitions require linking to the specific prices being tested. Real business process: promotional optim',
    `actual_end_timestamp` TIMESTAMP COMMENT 'The precise timestamp when the A/B test campaign execution ended.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'The precise timestamp when the A/B test campaign execution began.',
    `approval_status` STRING COMMENT 'Indicates whether the A/B test design and execution plan has been approved by the appropriate stakeholders.. Valid values are `pending|approved|rejected`',
    `approved_timestamp` TIMESTAMP COMMENT 'The timestamp when the A/B test campaign was approved for execution.',
    `confidence_level_pct` DECIMAL(18,2) COMMENT 'The actual confidence level achieved in the test results, indicating the statistical reliability of the outcome.',
    `control_audience_size` BIGINT COMMENT 'Number of individuals or contacts assigned to the control variant.',
    `control_audience_split_pct` DECIMAL(18,2) COMMENT 'Percentage of the total audience allocated to the control variant (e.g., 50.00 for a 50/50 split).',
    `control_metric_value` DECIMAL(18,2) COMMENT 'The measured value of the primary success metric for the control variant (e.g., 25.50 for 25.5% open rate).',
    `control_variant_definition` STRING COMMENT 'Detailed description of the control (baseline) variant used in the test, including creative elements, messaging, and configuration.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this A/B test campaign record was first created in the system.',
    `hypothesis` STRING COMMENT 'The hypothesis statement describing the expected outcome or behavior change being tested (e.g., Changing subject line to include urgency will increase open rate by 10%).',
    `lift_pct` DECIMAL(18,2) COMMENT 'The percentage improvement (or decline) of the test variant over the control variant for the primary success metric.',
    `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this A/B test campaign record was last modified or updated.',
    `primary_success_metric` STRING COMMENT 'The key performance indicator (KPI) used to determine the winning variant (e.g., open rate, click-through rate, conversion rate, revenue, engagement rate).. Valid values are `open_rate|click_through_rate|conversion_rate|revenue|engagement_rate|unsubscribe_rate`',
    `statistical_significance_threshold_pct` DECIMAL(18,2) COMMENT 'The confidence level threshold (e.g., 95.00) required to declare a variant as statistically significant winner.',
    `test_audience_size` BIGINT COMMENT 'Number of individuals or contacts assigned to the test variant(s).',
    `test_audience_split_pct` DECIMAL(18,2) COMMENT 'Percentage of the total audience allocated to the test variant(s) (e.g., 50.00 for a 50/50 split).',
    `test_code` STRING COMMENT 'Unique business identifier or code assigned to the test for tracking and reference across systems.',
    `test_description` STRING COMMENT 'Detailed narrative description of the A/B test objectives, methodology, and expected business impact.',
    `test_end_date` DATE COMMENT 'The date when the A/B test campaign concluded or is scheduled to conclude.',
    `test_metric_value` DECIMAL(18,2) COMMENT 'The measured value of the primary success metric for the test variant (e.g., 28.75 for 28.75% open rate).',
    `test_name` STRING COMMENT 'Human-readable name of the A/B or multivariate test for identification and reporting purposes.',
    `test_notes` STRING COMMENT 'Additional notes, observations, or learnings captured during or after the test execution.',
    `test_start_date` DATE COMMENT 'The date when the A/B test campaign was launched and began collecting data.',
    `test_status` STRING COMMENT 'Current lifecycle status of the A/B test campaign (draft, scheduled, running, completed, cancelled, paused).. Valid values are `draft|scheduled|running|completed|cancelled|paused`',
    `test_type` STRING COMMENT 'Category of the test indicating what element is being tested (e.g., subject line, creative variant, send time, audience split, channel mix, landing page).. Valid values are `subject_line|creative_variant|send_time|audience_split|channel_mix|landing_page`',
    `test_variant_definition` STRING COMMENT 'Detailed description of the test (challenger) variant(s) used in the experiment, including creative elements, messaging, and configuration.',
    `total_audience_size` BIGINT COMMENT 'Total number of individuals or contacts included in the A/B test across all variants.',
    `winning_variant` STRING COMMENT 'Indicates which variant won the test based on the primary success metric (control, test, or inconclusive if no clear winner).. Valid values are `control|test|inconclusive`',
    CONSTRAINT pk_ab_test_campaign PRIMARY KEY(`ab_test_campaign_id`)
) COMMENT 'Master record for A/B and multivariate tests conducted within marketing campaigns to optimize creative, messaging, audience targeting, and channel strategy. Captures test name, campaign reference, test type (subject line, creative variant, send time, audience split, channel mix), hypothesis, control and variant definitions, audience split percentages, test start/end dates, primary success metric, statistical significance threshold, winning variant, and test status. Distinct from ecommerce.ab_test which governs on-site UX experiments — this entity governs marketing message and channel experiments.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`automation_flow` (
    `automation_flow_id` BIGINT COMMENT 'Unique identifier for the marketing automation flow or journey program. Primary key.',
    `associate_id` BIGINT COMMENT 'Reference to the marketing team member or user responsible for managing and optimizing this automation flow.',
    `automation_created_by_associate_id` BIGINT COMMENT 'Reference to the user who originally created this automation flow configuration. Supports accountability and audit requirements.',
    `automation_modified_by_associate_id` BIGINT COMMENT 'Reference to the user who last modified this automation flow configuration. Tracks change ownership for governance.',
    `campaign_id` BIGINT COMMENT 'Reference to the parent marketing campaign that this automation flow supports. Links the flow to broader campaign strategy and budget.',
    `cloned_from_automation_flow_id` BIGINT COMMENT 'Self-referencing FK on automation_flow (cloned_from_automation_flow_id)',
    `audience_segment_id` BIGINT COMMENT 'Reference to the customer segment that is eligible for this automation flow. Defines the population scope for enrollment.',
    `activation_date` DATE COMMENT 'Date when the automation flow was first activated and began enrolling customers. Marks the start of the flows operational lifecycle.',
    `active_enrolled_count` BIGINT COMMENT 'Current number of customers actively progressing through the flow (not yet completed or exited). Indicates in-flight journey volume.',
    `branching_logic_description` STRING COMMENT 'Description of conditional branching and decision points within the flow (e.g., If email opened, send offer; if not opened after 24h, send reminder). Captures personalization and dynamic path logic.',
    `business_unit` STRING COMMENT 'The business unit, brand, or division that owns this automation flow (e.g., Grocery, Apparel, Electronics). Used for organizational segmentation and reporting.',
    `channel_sequence` STRING COMMENT 'Ordered list of marketing channels used in this flow (e.g., email → SMS → push notification, email → email → SMS). Describes the multi-touch communication strategy.',
    `completed_count` BIGINT COMMENT 'Total number of customers who have completed all steps in the automation flow. Measures journey completion rate.',
    `consent_required_flag` BOOLEAN COMMENT 'Indicates whether explicit customer consent is required before enrollment in this flow. Critical for General Data Protection Regulation (GDPR) and California Consumer Privacy Act (CCPA) compliance.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this automation flow record was first created in the system. Audit trail for data lineage and governance.',
    `deactivation_date` DATE COMMENT 'Date when the automation flow was deactivated or paused, stopping new customer enrollments. Null if the flow is still active.',
    `entry_criteria` STRING COMMENT 'Detailed business rules and conditions that a customer must meet to enter this automation flow. May include segment membership, purchase history, engagement thresholds, or attribute filters.',
    `exit_criteria` STRING COMMENT 'Conditions under which a customer is removed from the automation flow before completion (e.g., purchase made, unsubscribed, goal achieved, maximum time elapsed).',
    `flow_code` STRING COMMENT 'Unique business identifier or code for the automation flow, used for external reference and integration with marketing automation platforms.',
    `flow_description` STRING COMMENT 'Detailed narrative description of the automation flows purpose, strategy, and expected customer experience. Provides context for stakeholders and future reference.',
    `flow_name` STRING COMMENT 'Human-readable name of the marketing automation flow or journey (e.g., Cart Abandonment Recovery, Loyalty Welcome Series, Post-Purchase Thank You).',
    `flow_status` STRING COMMENT 'Current lifecycle status of the automation flow: draft (being configured), active (running and enrolling customers), paused (temporarily stopped), completed (finished execution), or archived (historical record).. Valid values are `draft|active|paused|completed|archived`',
    `flow_type` STRING COMMENT 'Classification of the automation flow based on execution pattern: triggered by customer action, scheduled at specific times, recurring on a cadence, one-time campaign, event-based, or behavioral targeting.. Valid values are `triggered|scheduled|recurring|one_time|event_based|behavioral`',
    `goal_achieved_count` BIGINT COMMENT 'Number of customers who achieved the defined goal while enrolled in this flow. Primary success metric for conversion attribution.',
    `goal_definition` STRING COMMENT 'The primary business objective or conversion goal for this automation flow (e.g., Complete purchase, Activate loyalty account, Re-engage dormant customer, Increase Average Order Value (AOV)).',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this automation flow record was last modified. Tracks configuration changes and updates over time.',
    `planned_end_date` DATE COMMENT 'Scheduled date for the automation flow to conclude or be archived. Used for time-bound campaigns or seasonal flows.',
    `platform_flow_code` STRING COMMENT 'External identifier for this flow in the source marketing automation platform. Used for integration and reconciliation with platform reporting.',
    `platform_name` STRING COMMENT 'Name of the marketing automation platform where this flow is configured (e.g., the e-commerce platform, Braze, Klaviyo, Adobe Campaign, HubSpot).',
    `primary_channel` STRING COMMENT 'The main marketing channel used for this automation flow. Determines platform integration and message delivery infrastructure.. Valid values are `email|sms|push|in_app|direct_mail|webhook`',
    `priority_level` STRING COMMENT 'Business priority assigned to this automation flow, indicating its strategic importance and resource allocation precedence.. Valid values are `critical|high|medium|low`',
    `step_count` STRING COMMENT 'Total number of steps or touchpoints configured in this automation flow. Indicates complexity and length of the customer journey.',
    `suppression_list_applied_flag` BOOLEAN COMMENT 'Indicates whether suppression lists (unsubscribed, opted-out, or blocked customers) are enforced for this flow to ensure compliance with communication preferences.',
    `tags` STRING COMMENT 'Comma-separated list of tags or labels applied to this flow for categorization, search, and reporting (e.g., retention, seasonal, high-value, mobile-first).',
    `test_mode_flag` BOOLEAN COMMENT 'Indicates whether this flow is running in test or preview mode (not sending to real customers). Used during configuration and quality assurance.',
    `total_enrolled_count` BIGINT COMMENT 'Cumulative number of customers who have entered this automation flow since activation. Key metric for reach and scale assessment.',
    `trigger_event` STRING COMMENT 'The specific customer behavior or system event that initiates entry into this automation flow (e.g., cart_abandonment, loyalty_enrollment, birthday, win_back, post_purchase, browse_abandonment, product_back_in_stock).',
    `wait_period_description` STRING COMMENT 'Human-readable description of wait times and delays between steps in the flow (e.g., Wait 2 hours, then wait 1 day, then wait 3 days). Defines the timing cadence of the journey.',
    CONSTRAINT pk_automation_flow PRIMARY KEY(`automation_flow_id`)
) COMMENT 'Master record for marketing automation journeys and triggered workflow programs configured in the marketing automation platform (e.g., the e-commerce platform Builder, Braze Canvas, Klaviyo Flow). Captures flow name, trigger event (cart abandonment, loyalty enrollment, birthday, win-back, post-purchase, browse abandonment), channel sequence (email → SMS → push), entry criteria, exit criteria, wait periods, branching logic description, campaign association, active status, and total enrolled count.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` (
    `automation_enrollment_id` BIGINT COMMENT 'Unique identifier for the automation enrollment record. Primary key.',
    `audience_segment_id` BIGINT COMMENT 'Identifier of the audience segment that the customer belonged to at the time of enrollment. Used for targeting analysis and segment performance measurement.',
    `automation_flow_id` BIGINT COMMENT 'Identifier of the marketing automation flow that the customer was enrolled into. References the specific automation campaign or journey definition.',
    `automation_step_id` BIGINT COMMENT 'Identifier of the current step or stage in the automation flow where the customer is positioned. Null if the customer has exited the flow.',
    `campaign_id` BIGINT COMMENT 'Identifier of the parent marketing campaign that this automation enrollment is associated with. Links the automation flow to broader campaign strategy and budget.',
    `associate_id` BIGINT COMMENT 'Identifier of the user or system process that created this enrollment record. Used for audit trail and accountability.',
    `profile_id` BIGINT COMMENT 'Identifier of the customer enrolled in the automation flow. Links to the customer who entered the marketing automation journey.',
    `re_enrolled_from_automation_enrollment_id` BIGINT COMMENT 'Self-referencing FK on automation_enrollment (re_enrolled_from_automation_enrollment_id)',
    `consent_status` STRING COMMENT 'The current consent status of the customer for receiving marketing communications in this automation flow. Ensures compliance with data privacy regulations.. Valid values are `granted|withdrawn|pending|expired`',
    `conversion_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the conversion value amount.. Valid values are `^[A-Z]{3}$`',
    `conversion_flag` BOOLEAN COMMENT 'Indicates whether the customer achieved the target conversion goal of the automation flow. True if the customer completed the desired action (purchase, sign-up, engagement), false otherwise.',
    `conversion_timestamp` TIMESTAMP COMMENT 'The date and time when the customer achieved the conversion goal. Null if no conversion occurred.',
    `conversion_value_amount` DECIMAL(18,2) COMMENT 'The monetary value attributed to the conversion event. Represents revenue, order value, or estimated customer lifetime value (CLTV) impact from the automation-driven conversion.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this enrollment record was first created in the system. Used for audit trail and data lineage.',
    `current_step_entry_timestamp` TIMESTAMP COMMENT 'The date and time when the customer entered the current step of the automation flow. Used to calculate time-in-step and identify stalled journeys.',
    `enrollment_channel` STRING COMMENT 'The primary marketing channel through which the automation flow communicates with the customer. Indicates the delivery mechanism for automation messages.. Valid values are `email|sms|push|in_app|web|multi_channel`',
    `enrollment_code` STRING COMMENT 'Business-readable unique code for this enrollment instance. Used for operational tracking and customer service reference.',
    `enrollment_notes` STRING COMMENT 'Free-text notes or comments about this enrollment. Used for operational context, troubleshooting, or manual intervention documentation.',
    `enrollment_source` STRING COMMENT 'The system or method that initiated the enrollment. Indicates whether the enrollment was triggered automatically by an event, manually by a user, or via batch processing.. Valid values are `api|web_form|manual|batch_import|event_trigger|segment_refresh`',
    `enrollment_status` STRING COMMENT 'Current lifecycle status of the customer within the automation flow. Indicates whether the customer is actively progressing, has completed, or has exited the flow.. Valid values are `active|paused|completed|exited|suppressed|failed`',
    `enrollment_timestamp` TIMESTAMP COMMENT 'The date and time when the customer was enrolled into the automation flow. Represents the start of the customers journey through the automation.',
    `enrollment_trigger_event` STRING COMMENT 'The business event or action that triggered the customers enrollment into the automation flow. Examples include cart abandonment, product purchase, account creation, loyalty tier change, or manual enrollment.',
    `exit_reason` STRING COMMENT 'The reason the customer exited the automation flow. Examples include completed (finished all steps), unsubscribed (opted out), suppressed (consent withdrawn), manually_removed (admin action), goal_achieved (converted), or error (technical failure). Null if still active.',
    `exit_timestamp` TIMESTAMP COMMENT 'The date and time when the customer exited the automation flow. Null if the customer is still actively enrolled.',
    `last_interaction_timestamp` TIMESTAMP COMMENT 'The date and time of the customers most recent interaction with any message in this automation flow. Includes opens, clicks, or other engagement actions.',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this enrollment record was last modified. Used for audit trail and change tracking.',
    `next_scheduled_action_timestamp` TIMESTAMP COMMENT 'The date and time when the next automation action (message send, step transition, or evaluation) is scheduled for this enrollment. Used for operational monitoring and queue management.',
    `priority_level` STRING COMMENT 'The business priority assigned to this enrollment. High-priority enrollments may receive expedited processing or preferential treatment in message queues.. Valid values are `high|medium|low|urgent`',
    `step_sequence_number` STRING COMMENT 'The ordinal position of the current step within the automation flow. Indicates progression depth through the journey.',
    `suppression_flag` BOOLEAN COMMENT 'Indicates whether the customer is currently suppressed from receiving further messages in this automation flow due to consent withdrawal, unsubscribe, or compliance requirements.',
    `suppression_timestamp` TIMESTAMP COMMENT 'The date and time when the customer was suppressed from the automation flow. Null if not suppressed.',
    `total_messages_clicked` STRING COMMENT 'Count of marketing messages where the customer clicked a link or call-to-action during this automation enrollment. Indicates deeper engagement and intent.',
    `total_messages_opened` STRING COMMENT 'Count of marketing messages that the customer opened during this automation enrollment. Used to measure engagement and message effectiveness.',
    `total_messages_sent` STRING COMMENT 'Count of marketing messages (emails, SMS, push notifications) sent to the customer as part of this automation enrollment. Used to measure communication volume and frequency.',
    `total_steps_completed` STRING COMMENT 'Count of automation flow steps that the customer has successfully completed since enrollment. Used to measure journey progression and engagement.',
    CONSTRAINT pk_automation_enrollment PRIMARY KEY(`automation_enrollment_id`)
) COMMENT 'Transactional record capturing each customers entry into and progression through a marketing automation flow. Captures customer identifier, automation flow reference, enrollment trigger event, enrollment timestamp, current step in the flow, step history, exit reason (completed, unsubscribed, suppressed, manually removed), exit timestamp, and conversion flag. Enables operational monitoring of automation flow health and customer journey progression.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` (
    `opt_in_record_id` BIGINT COMMENT 'Unique identifier for the marketing communication opt-in record. Primary key for the opt-in record entity.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to marketing.marketing_channel. Business justification: Opt-in records are channel-specific (email opt-in, SMS opt-in, push opt-in) and should reference the authoritative marketing_channel master. Currently, opt_in_record has a denormalized channel_type ST',
    `associate_id` BIGINT COMMENT 'Identifier of the user or system process that created this opt-in record. Used for audit trail and accountability.',
    `opt_modified_by_user_associate_id` BIGINT COMMENT 'Identifier of the user or system process that last modified this opt-in record. Used for audit trail and accountability.',
    `profile_id` BIGINT COMMENT 'Reference to the customer who owns this opt-in preference. Links to the customer master record.',
    `superseded_opt_in_record_id` BIGINT COMMENT 'Self-referencing FK on opt_in_record (superseded_opt_in_record_id)',
    `can_spam_compliant_flag` BOOLEAN COMMENT 'Indicates whether this opt-in record meets CAN-SPAM Act requirements for email marketing. True if compliant, false otherwise.',
    `ccpa_compliant_flag` BOOLEAN COMMENT 'Indicates whether this opt-in record meets CCPA requirements for California residents. True if compliant, false otherwise.',
    `consent_expiry_date` DATE COMMENT 'The date when this opt-in consent expires and must be re-confirmed. Null if consent does not expire. Required in some jurisdictions (e.g., GDPR recommends periodic re-consent).',
    `consent_text_version` STRING COMMENT 'Version identifier of the consent language presented to the customer at the time of opt-in. Required for GDPR compliance to prove informed consent.',
    `contact_count` STRING COMMENT 'The total number of marketing communications sent to this customer via this channel since opt-in. Used for frequency capping and customer experience management.',
    `contact_value` DECIMAL(18,2) COMMENT 'The actual contact point value for this channel (email address for email channel, phone number for SMS/phone channels, device token for push, mailing address for direct mail). Stored for audit and verification purposes.',
    `contact_verification_timestamp` TIMESTAMP COMMENT 'The date and time when the contact value was last verified. Null if never verified.',
    `contact_verified_flag` BOOLEAN COMMENT 'Indicates whether the contact value has been verified as valid and deliverable. True if verified, false otherwise.',
    `content_preference` STRING COMMENT 'Free-text or coded description of the types of content the customer wants to receive (e.g., promotions, new arrivals, loyalty rewards). Used for personalized targeting.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this opt-in record was first created in the system. Used for audit trail and data lineage.',
    `double_opt_in_confirmation_timestamp` TIMESTAMP COMMENT 'The date and time when the customer confirmed their opt-in via double opt-in process. Null if double opt-in was not used or not yet confirmed.',
    `double_opt_in_flag` BOOLEAN COMMENT 'Indicates whether the customer confirmed their opt-in via a double opt-in process (e.g., email confirmation link). True if double opt-in confirmed, false if single opt-in.',
    `effective_end_date` DATE COMMENT 'The date when this opt-in record ceases to be effective. Null if currently effective. Set when customer opts out or consent expires.',
    `effective_start_date` DATE COMMENT 'The date from which this opt-in record becomes effective and the customer can be contacted. May differ from opt_in_timestamp if there is a processing delay.',
    `frequency_preference` STRING COMMENT 'The customers preferred frequency for receiving marketing communications on this channel. Used to honor customer preferences and reduce unsubscribes.. Valid values are `daily|weekly|biweekly|monthly|quarterly|as_needed`',
    `gdpr_compliant_flag` BOOLEAN COMMENT 'Indicates whether this opt-in record meets GDPR consent requirements for customers in EU jurisdictions. True if compliant, false otherwise.',
    `geographic_scope` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code indicating the geographic jurisdiction under which this opt-in was collected. Used for compliance with jurisdiction-specific regulations.. Valid values are `^[A-Z]{3}$`',
    `ip_address` STRING COMMENT 'The IP address from which the opt-in or opt-out action was performed. Stored for fraud detection and consent audit trail.',
    `language_preference` STRING COMMENT 'Two-letter ISO 639-1 language code indicating the customers preferred language for marketing communications on this channel.. Valid values are `^[a-z]{2}$`',
    `last_contact_date` DATE COMMENT 'The date when the customer was last contacted via this channel. Used to enforce frequency preferences and avoid over-communication.',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this opt-in record was last modified. Used for audit trail and change tracking.',
    `notes` STRING COMMENT 'Free-text notes or comments about this opt-in record. Used for documenting special circumstances, customer service interactions, or compliance exceptions.',
    `opt_in_source` STRING COMMENT 'The touchpoint or system where the customer provided their opt-in consent. Critical for audit trail and consent provenance. [ENUM-REF-CANDIDATE: checkout|loyalty_enrollment|website_preference_center|in_store|mobile_app|customer_service|third_party — 7 candidates stripped; promote to reference product]',
    `opt_in_status` STRING COMMENT 'Current opt-in status for this customer and channel combination. Governs whether the customer can be contacted via this channel.. Valid values are `opted_in|opted_out|pending|expired|suppressed`',
    `opt_in_timestamp` TIMESTAMP COMMENT 'The date and time when the customer opted in to receive marketing communications for this channel. Required for CAN-SPAM and GDPR consent audit trails.',
    `opt_out_method` STRING COMMENT 'The mechanism or channel through which the customer opted out. Required for compliance reporting and process improvement. [ENUM-REF-CANDIDATE: unsubscribe_link|preference_center|customer_service|email_reply|sms_stop|in_store|automated — 7 candidates stripped; promote to reference product]',
    `opt_out_reason` STRING COMMENT 'Free-text or coded reason provided by the customer for opting out. Used for customer experience analysis and retention strategies.',
    `opt_out_timestamp` TIMESTAMP COMMENT 'The date and time when the customer opted out of receiving marketing communications for this channel. Null if customer has not opted out.',
    `suppression_list_flag` BOOLEAN COMMENT 'Indicates whether this customer-channel combination is on a suppression list and must not be contacted. True if suppressed, false otherwise.',
    `suppression_reason` STRING COMMENT 'The reason why this customer-channel combination is suppressed from marketing communications. Null if not suppressed. [ENUM-REF-CANDIDATE: hard_bounce|spam_complaint|legal_request|fraud|deceased|duplicate|invalid_contact — 7 candidates stripped; promote to reference product]',
    `tcpa_compliant_flag` BOOLEAN COMMENT 'Indicates whether this opt-in record meets TCPA requirements for SMS and phone marketing. True if compliant, false otherwise. Applies to SMS and phone channels only.',
    `third_party_consent_date` DATE COMMENT 'The date when consent was originally obtained by the third-party source. Null if not applicable. Required for GDPR Article 14 transparency.',
    `third_party_source_name` STRING COMMENT 'Name of the third-party vendor or partner who provided this opt-in record, if applicable. Null if opt-in was collected directly. Required for compliance and data lineage.',
    `user_agent` STRING COMMENT 'The browser or application user agent string captured at the time of opt-in or opt-out. Used for audit trail and fraud detection.',
    CONSTRAINT pk_opt_in_record PRIMARY KEY(`opt_in_record_id`)
) COMMENT 'Authoritative record of customer marketing communication opt-in and opt-out preferences by channel, distinct from customer.consent which covers broader GDPR/CCPA privacy consent. Captures customer identifier, channel type (email, SMS, push, direct mail, phone), opt-in status, opt-in source (checkout, loyalty enrollment, website preference center, in-store), opt-in timestamp, opt-out timestamp, opt-out reason, suppression list membership, and CAN-SPAM/TCPA compliance flags. Governs which customers can be contacted via each marketing channel.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` (
    `campaign_performance_id` BIGINT COMMENT 'Unique identifier for the campaign performance record. Primary key for this operational performance snapshot.',
    `attribution_model_id` BIGINT COMMENT 'Foreign key linking to marketing.attribution_model. Business justification: Campaign performance metrics are calculated using attribution models. The campaign_performance table has attribution_model (STRING) which stores the model name/code, but this should be normalized to a',
    `campaign_id` BIGINT COMMENT 'Reference to the marketing campaign being measured. Links this performance record to the parent campaign entity.',
    `channel_id` BIGINT COMMENT 'Foreign key linking to marketing.marketing_channel. Business justification: Campaign performance is measured by marketing channel and should reference the authoritative marketing_channel master. Currently, campaign_performance has a denormalized channel_type STRING attribute.',
    `financial_period_id` BIGINT COMMENT 'Foreign key linking to finance.financial_period. Business justification: Campaign performance metrics must align with financial reporting periods for ROI analysis, budget variance reporting, and board-level marketing effectiveness reviews. CFO and CMO jointly review market',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Campaign performance reporting in retail aggregates by product category/hierarchy for category managers and merchandising teams. Essential for measuring campaign effectiveness by department/class/subc',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_definition. Business justification: Performance records measure specific KPIs defined in analytics (impressions, conversions, ROAS). Each performance row tracks one or more standardized metrics; this link enables consistent metric defin',
    `price_strategy_id` BIGINT COMMENT 'Foreign key linking to pricing.price_strategy. Business justification: Campaign performance reporting segments results by pricing strategy (promotional vs everyday pricing campaigns). Real business process: marketing mix modeling compares ROAS across different price stra',
    `prior_period_campaign_performance_id` BIGINT COMMENT 'Self-referencing FK on campaign_performance (prior_period_campaign_performance_id)',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Campaign performance is measured per storefront in multi-channel retail. Enables storefront-level campaign ROI reporting, supports budget allocation decisions by channel, and tracks brand-specific cam',
    `attributed_revenue_amount` DECIMAL(18,2) COMMENT 'Total revenue attributed to this campaign and channel during the reporting period, based on the attribution model in use.',
    `click_count` BIGINT COMMENT 'Total number of clicks recorded during the reporting period for this campaign and channel.',
    `conversion_count` BIGINT COMMENT 'Total number of conversions (completed desired actions such as purchases, sign-ups, downloads) attributed to this campaign and channel during the reporting period.',
    `conversion_rate_percent` DECIMAL(18,2) COMMENT 'Conversion rate expressed as a percentage, calculated as (conversions / clicks) * 100 for the reporting period.',
    `cpa_amount` DECIMAL(18,2) COMMENT 'Cost per acquisition or conversion (CPA) for this campaign and channel during the reporting period, in the spend currency.',
    `cpc_amount` DECIMAL(18,2) COMMENT 'Cost per click (CPC) for this campaign and channel during the reporting period, in the spend currency.',
    `cpm_amount` DECIMAL(18,2) COMMENT 'Cost per thousand impressions (CPM) for this campaign and channel during the reporting period, in the spend currency.',
    `ctr_percent` DECIMAL(18,2) COMMENT 'Click-through rate expressed as a percentage, calculated as (clicks / impressions) * 100 for the reporting period.',
    `data_source_system` STRING COMMENT 'The name of the source system or platform from which this performance data was extracted (e.g., Google Ads, Facebook Ads Manager, the e-commerce platform, Adobe Analytics).',
    `email_delivered_count` BIGINT COMMENT 'Total number of emails successfully delivered (not bounced) for this campaign during the reporting period. Applicable only when channel_type is email.',
    `email_open_count` BIGINT COMMENT 'Total number of email opens recorded for this campaign during the reporting period. Applicable only when channel_type is email.',
    `email_open_rate_percent` DECIMAL(18,2) COMMENT 'Email open rate expressed as a percentage, calculated as (opens / delivered) * 100 for the reporting period. Applicable only when channel_type is email.',
    `email_send_count` BIGINT COMMENT 'Total number of emails sent for this campaign during the reporting period. Applicable only when channel_type is email.',
    `email_unsubscribe_count` BIGINT COMMENT 'Total number of unsubscribes triggered by this campaign during the reporting period. Applicable only when channel_type is email.',
    `email_unsubscribe_rate_percent` DECIMAL(18,2) COMMENT 'Email unsubscribe rate expressed as a percentage, calculated as (unsubscribes / delivered) * 100 for the reporting period. Applicable only when channel_type is email.',
    `engagement_count` BIGINT COMMENT 'Total number of engagements (likes, shares, comments, reactions) recorded for this campaign and channel during the reporting period. Primarily applicable to social media channels.',
    `engagement_rate_percent` DECIMAL(18,2) COMMENT 'Engagement rate expressed as a percentage, calculated as (engagements / impressions) * 100 for the reporting period. Primarily applicable to social media channels.',
    `impressions_delivered` BIGINT COMMENT 'Total number of impressions delivered during the reporting period for this campaign and channel combination.',
    `measurement_timestamp` TIMESTAMP COMMENT 'The timestamp when this performance data was measured and recorded. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `notes` STRING COMMENT 'Free-text notes or comments about this performance record, including anomalies, data quality issues, or contextual information.',
    `performance_status` STRING COMMENT 'Current operational status of the campaign performance tracking for this channel and period (active, paused, completed, cancelled).. Valid values are `active|paused|completed|cancelled`',
    `reach_count` BIGINT COMMENT 'Total unique individuals or accounts reached during the reporting period for this campaign and channel.',
    `reporting_period_end_date` DATE COMMENT 'The end date of the reporting period for which this performance data was captured. Format: yyyy-MM-dd.',
    `reporting_period_start_date` DATE COMMENT 'The start date of the reporting period for which this performance data was captured. Format: yyyy-MM-dd.',
    `reporting_period_type` STRING COMMENT 'The granularity of the reporting period for this performance snapshot (daily, weekly, monthly, quarterly).. Valid values are `daily|weekly|monthly|quarterly`',
    `revenue_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the attributed revenue amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `roas_ratio` DECIMAL(18,2) COMMENT 'Return on Ad Spend ratio, calculated as attributed revenue divided by spend for this campaign and channel during the reporting period. A value of 3.50 means $3.50 revenue per $1.00 spent.',
    `spend_amount` DECIMAL(18,2) COMMENT 'Total media spend or campaign cost for this campaign and channel during the reporting period.',
    `spend_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the spend amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `video_completion_rate_percent` DECIMAL(18,2) COMMENT 'Percentage of video views that were completed (watched to the end) during the reporting period. Applicable only when channel_type is video.',
    `video_view_count` BIGINT COMMENT 'Total number of video views recorded for this campaign during the reporting period. Applicable only when channel_type is video.',
    CONSTRAINT pk_campaign_performance PRIMARY KEY(`campaign_performance_id`)
) COMMENT 'Operational performance snapshot record capturing measured results for a campaign at a given reporting period and channel level. Captures campaign reference, channel reference, reporting period (day, week, month), impressions delivered, reach, clicks, CTR, conversions, conversion rate, attributed revenue, ROAS (Return on Ad Spend), CPM, CPC, CPA, email open rate, unsubscribe rate, and spend to date. This is an operational Silver Layer record aggregated at the campaign-channel-period grain for campaign management — NOT a Gold Layer analytics product.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`agency_brief` (
    `agency_brief_id` BIGINT COMMENT 'Unique identifier for the agency brief record. Primary key.',
    `associate_id` BIGINT COMMENT 'Identifier of the user who created the agency brief record.',
    `campaign_id` BIGINT COMMENT 'Reference to the marketing campaign this brief supports. Links the brief to the broader campaign strategy and execution.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Agency work is budgeted and tracked at cost center level for expense control and chargeback to business units. Finance requires cost center assignment for agency spend allocation, budget tracking, and',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Agency briefs specify target product categories/hierarchies for creative development and media planning. Essential for aligning agency deliverables with merchandising strategy, ensuring category-appro',
    `marketing_brand_id` BIGINT COMMENT 'Identifier of the retail brand or private label that this brief supports.',
    `primary_agency_associate_id` BIGINT COMMENT 'Identifier of the internal user who approved the agency deliverables.',
    `revised_from_agency_brief_id` BIGINT COMMENT 'Self-referencing FK on agency_brief (revised_from_agency_brief_id)',
    `agency_contact_email` STRING COMMENT 'Email address of the primary agency contact for communication regarding this brief.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `agency_contact_name` STRING COMMENT 'Primary contact person at the agency responsible for this brief.',
    `agency_contact_phone` STRING COMMENT 'Phone number of the primary agency contact for urgent communications.',
    `agency_name` STRING COMMENT 'Name of the external agency (creative, media, digital, PR, or influencer) to which this brief is issued.',
    `agency_type` STRING COMMENT 'Classification of the agency based on their specialization and service offering.. Valid values are `creative|media|digital|pr|influencer|social_media`',
    `approval_date` DATE COMMENT 'Date when the deliverables were officially approved by the marketing team.',
    `brief_issued_date` DATE COMMENT 'Date when the brief was officially issued to the agency, marking the start of the agency engagement.',
    `brief_name` STRING COMMENT 'Descriptive name of the agency brief that summarizes the project or initiative.',
    `brief_number` STRING COMMENT 'Human-readable unique reference number for the agency brief, used for tracking and communication with agencies.',
    `brief_status` STRING COMMENT 'Current lifecycle status of the agency brief indicating its progress through the workflow. [ENUM-REF-CANDIDATE: draft|issued|in_progress|delivered|approved|rejected|cancelled — 7 candidates stripped; promote to reference product]',
    `budget_allocated_amount` DECIMAL(18,2) COMMENT 'Total budget amount allocated to the agency for this brief, covering all deliverables and services.',
    `budget_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the budget allocated amount.. Valid values are `^[A-Z]{3}$`',
    `channel_focus` STRING COMMENT 'Primary marketing channels or media types that this brief targets (e.g., social media, TV, print, digital display).',
    `compliance_requirements` STRING COMMENT 'Legal, regulatory, and industry compliance requirements that the agency must adhere to (e.g., FTC disclosure, GDPR, advertising standards).',
    `contract_reference_number` STRING COMMENT 'Reference number of the master service agreement or contract under which this brief is executed.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the agency brief record was first created in the system.',
    `creative_guidelines` STRING COMMENT 'Brand guidelines, tone of voice, visual standards, and creative constraints that the agency must follow.',
    `deliverable_status` STRING COMMENT 'Current status of the deliverables from the agency, tracking progress toward completion. [ENUM-REF-CANDIDATE: not_started|in_progress|submitted|under_review|approved|rejected|revision_required — 7 candidates stripped; promote to reference product]',
    `deliverables_list` STRING COMMENT 'Comma-separated or structured list of specific deliverables expected from the agency (e.g., creative concepts, media plans, content pieces, reports).',
    `feedback_notes` STRING COMMENT 'Internal feedback and comments provided to the agency regarding their submissions and deliverables.',
    `key_message` STRING COMMENT 'Primary message or value proposition that the agency should communicate through their deliverables.',
    `milestone_dates` STRING COMMENT 'Key milestone dates and checkpoints throughout the project timeline, formatted as structured text or JSON.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the agency brief record was last modified or updated.',
    `notes` STRING COMMENT 'Additional notes, context, or special instructions related to the agency brief.',
    `priority_level` STRING COMMENT 'Business priority level assigned to this brief, indicating urgency and resource allocation.. Valid values are `low|medium|high|urgent`',
    `project_end_date` DATE COMMENT 'Planned or actual end date by which all deliverables should be completed and delivered.',
    `project_start_date` DATE COMMENT 'Planned or actual start date for the agency to begin work on the brief deliverables.',
    `response_due_date` DATE COMMENT 'Date by which the agency is expected to submit their initial response or proposal to the brief.',
    `revision_count` STRING COMMENT 'Number of revision rounds requested for the deliverables, tracking iteration cycles.',
    `scope_of_work` STRING COMMENT 'Detailed description of the work to be performed by the agency, including objectives, requirements, and boundaries.',
    `submission_date` DATE COMMENT 'Date when the agency submitted their deliverables for review.',
    `success_criteria` STRING COMMENT 'Measurable criteria and KPIs (Key Performance Indicators) that define success for this agency engagement.',
    `target_audience_description` STRING COMMENT 'Detailed description of the target audience for the campaign, including demographics, psychographics, and behavioral characteristics.',
    CONSTRAINT pk_agency_brief PRIMARY KEY(`agency_brief_id`)
) COMMENT 'Master record for briefs issued to external marketing agencies, media agencies, creative agencies, and PR firms. Captures brief name, agency name, agency type (creative, media, digital, PR, influencer), scope of work, deliverables list, campaign reference, budget allocated to agency, timeline and milestone dates, brief status (draft, issued, in-progress, delivered, approved), contact persons, and contractual reference. Enables marketing operations teams to track agency workload and deliverable status across all active campaigns.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`campaign_deployment` (
    `campaign_deployment_id` BIGINT COMMENT 'Unique identifier for this campaign deployment record. Primary key.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to the marketing campaign being deployed',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to the digital storefront where the campaign is deployed',
    `activation_end_date` DATE COMMENT 'The date when this campaign was deactivated or concluded on this specific storefront. May differ from campaign-level end date due to performance-based early termination or extension.',
    `activation_start_date` DATE COMMENT 'The date when this campaign was activated on this specific storefront. May differ from the campaign-level planned start date due to phased rollouts or storefront-specific timing.',
    `actual_reach_count` BIGINT COMMENT 'The actual number of unique customers or visitors who were exposed to this campaign on this storefront during the activation period. Measured via impressions, page views, or email opens.',
    `attributed_revenue_amount` DECIMAL(18,2) COMMENT 'The total revenue attributed to this campaign on this storefront, calculated using attribution models (first-touch, last-touch, or multi-touch). Used to measure campaign ROI at the storefront level.',
    `budget_allocation_amount` DECIMAL(18,2) COMMENT 'The portion of the total campaign budget allocated specifically to this storefront deployment. Allows tracking spend distribution across storefronts.',
    `budget_allocation_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the budget allocation amount (e.g., USD, EUR, GBP). May differ from campaign-level currency for multi-currency deployments.',
    `conversion_count` BIGINT COMMENT 'The number of conversions (purchases, sign-ups, add-to-cart actions, or other goal completions) attributed to this campaign on this storefront during the activation period.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this campaign deployment record was created in the system.',
    `deployment_status` STRING COMMENT 'Current operational status of this campaign deployment on this storefront. Values: scheduled (planned but not yet active), active (currently running), paused (temporarily suspended), completed (ended as planned), cancelled (terminated early).',
    `performance_metrics` STRING COMMENT 'JSON or delimited string containing additional performance metrics specific to this campaign-storefront deployment, such as click-through rate, conversion rate, cost per acquisition, return on ad spend, or engagement scores.',
    `target_audience_size` BIGINT COMMENT 'The estimated or actual number of customers or prospects targeted by this campaign on this specific storefront. Subset of the campaign-level target audience, segmented by storefront locale, customer base, or channel.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this campaign deployment record was last updated.',
    CONSTRAINT pk_campaign_deployment PRIMARY KEY(`campaign_deployment_id`)
) COMMENT 'This association product represents the deployment of a marketing campaign to a specific digital storefront. It captures the operational execution of campaign strategy at the storefront level, including budget allocation, activation timing, and performance metrics specific to each campaign-storefront combination. Each record links one campaign to one storefront with attributes that exist only in the context of this deployment relationship.. Existence Justification: In retail operations, marketing campaigns are routinely deployed across multiple digital storefronts simultaneously (e.g., a national holiday campaign runs on the main e-commerce site, mobile app, and marketplace storefronts), and each storefront hosts multiple campaigns concurrently (seasonal promotions, category-specific campaigns, brand campaigns). Marketing teams actively manage these deployments as distinct operational entities, allocating budgets, setting activation windows, and tracking performance metrics at the campaign-storefront level.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` (
    `campaign_fulfillment_id` BIGINT COMMENT 'Unique identifier for this campaign-to-DC fulfillment assignment record. Primary key.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to the marketing campaign being fulfilled through this DC assignment',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to the distribution center facility assigned to fulfill this campaign',
    `allocated_inventory_units` BIGINT COMMENT 'Number of inventory units (SKUs, cases, or pallets) allocated to this DC for fulfilling demand generated by this campaign. Represents pre-positioned or reserved inventory.',
    `assignment_status` STRING COMMENT 'Current operational status of this campaign-DC fulfillment assignment. Tracks lifecycle from planning through completion.',
    `campaign_end_date` DATE COMMENT 'Date when this DC stops fulfilling orders for this campaign. May differ from the campaigns overall end date due to inventory depletion or regional timing.',
    `campaign_start_date` DATE COMMENT 'Date when this DC begins fulfilling orders for this campaign. May differ from the campaigns overall start date due to phased rollouts or regional timing.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this campaign-DC fulfillment assignment was created in the system.',
    `fulfillment_sla_hours` STRING COMMENT 'Target number of hours from order placement to shipment for campaign orders fulfilled by this DC. Campaign-specific SLA may be tighter than standard DC SLA for high-priority campaigns.',
    `geographic_coverage_codes` STRING COMMENT 'Comma-separated list of postal codes, regions, or zones that this DC is responsible for fulfilling within the context of this campaign. Defines the geographic split when multiple DCs support one campaign.',
    `priority_rank` STRING COMMENT 'Priority ranking of this DC for fulfilling this campaign (1 = highest priority). Used for order routing logic when multiple DCs support the same campaign and geographic area.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this campaign-DC fulfillment assignment was last modified.',
    CONSTRAINT pk_campaign_fulfillment PRIMARY KEY(`campaign_fulfillment_id`)
) COMMENT 'This association product represents the operational assignment between marketing campaigns and distribution center facilities that fulfill campaign-driven demand. It captures the multi-facility fulfillment strategy for national and regional campaigns, where each DC is allocated specific inventory quantities, assigned priority rankings, and bound by campaign-specific SLAs. Each record links one campaign to one DC facility with attributes that exist only in the context of this fulfillment relationship.. Existence Justification: In retail operations, national and regional marketing campaigns are routinely fulfilled from multiple distribution centers based on geographic coverage, inventory positioning, and capacity. Each campaign-to-DC assignment is an operational decision with specific allocated inventory quantities, priority rankings for order routing, and campaign-specific fulfillment SLAs. Conversely, each DC simultaneously supports multiple active campaigns with different inventory allocations and priorities. This is an actively managed operational relationship, not a derived analytical correlation.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` (
    `campaign_policy_compliance_id` BIGINT COMMENT 'Unique identifier for this campaign-policy compliance record. Primary key.',
    `campaign_id` BIGINT COMMENT 'Foreign key to marketing.campaign. Identifies which campaign this compliance record applies to.',
    `policy_id` BIGINT COMMENT 'Foreign key to compliance.policy. Identifies which policy this compliance record verifies.',
    `associate_id` BIGINT COMMENT 'Identifier of the compliance team member who reviewed and verified this campaign against this policy. Explicitly identified in detection phase.',
    `acknowledgment_date` DATE COMMENT 'Date when the campaign owner or compliance team acknowledged that this policy applies to this campaign. Explicitly identified in detection phase.',
    `compliance_verification_status` STRING COMMENT 'Current status of compliance verification for this campaign-policy pair. Values: pending, verified, non_compliant, exception_granted, under_review. Explicitly identified in detection phase.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this compliance record was created in the system.',
    `exception_expiration_date` DATE COMMENT 'Date when the granted policy exception expires and the campaign must come into full compliance. Nullable if no exception granted. Explicitly identified in detection phase.',
    `exception_granted_flag` BOOLEAN COMMENT 'Indicates whether an exception to this policy was granted for this campaign. Explicitly identified in detection phase.',
    `exception_justification` STRING COMMENT 'Business justification for why a policy exception was granted for this campaign-policy pair.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this compliance record was last modified.',
    `non_compliance_notes` STRING COMMENT 'Detailed notes describing any non-compliance issues identified during verification, including remediation steps required.',
    `verification_date` DATE COMMENT 'Date when the compliance reviewer completed verification of this campaign against this policy.',
    CONSTRAINT pk_campaign_policy_compliance PRIMARY KEY(`campaign_policy_compliance_id`)
) COMMENT 'This association product represents the compliance verification relationship between marketing campaigns and internal compliance policies. It captures the acknowledgment, verification, and exception management for each campaign-policy pairing. Each record links one campaign to one policy with attributes that track when compliance was verified, by whom, and whether any exceptions were granted.. Existence Justification: In retail operations, marketing campaigns must comply with multiple internal policies (data privacy, advertising standards, promotional terms, sweepstakes regulations, PCI security for payment promotions). Each policy applies to many campaigns across different brands, channels, and time periods. The compliance team actively manages campaign-policy compliance records as operational entities, tracking acknowledgment dates, verification status, reviewer assignments, and exception approvals for audit and regulatory reporting purposes.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`automation_step` (
    `automation_step_id` BIGINT COMMENT 'Primary key for automation_step',
    `email_template_id` BIGINT COMMENT 'Reference to the message template used by this automation step for content rendering.',
    `next_automation_step_id` BIGINT COMMENT 'Self-referencing FK on automation_step (next_automation_step_id)',
    `ab_test_split_percentage` DECIMAL(18,2) COMMENT 'Percentage of audience allocated to this A/B test variant (0.00 to 100.00).',
    `ab_test_variant` STRING COMMENT 'Variant identifier for A/B test steps indicating which version of content is used (control, variant A, variant B, variant C).',
    `activated_timestamp` TIMESTAMP COMMENT 'Date and time when this automation step was activated and made live for execution.',
    `channel` STRING COMMENT 'Primary marketing channel through which this automation step is executed (email, SMS, push, in-app, web, social).',
    `condition_logic` STRING COMMENT 'Business rule or conditional expression evaluated for conditional split or branching steps (e.g., cart_value > 100, customer_segment = VIP).',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this automation step record was first created in the system.',
    `deactivated_timestamp` TIMESTAMP COMMENT 'Date and time when this automation step was deactivated and stopped from executing.',
    `effective_end_date` DATE COMMENT 'Date after which this automation step is no longer effective and will not execute (nullable for open-ended steps).',
    `effective_start_date` DATE COMMENT 'Date from which this automation step becomes effective and eligible for execution.',
    `execution_count` BIGINT COMMENT 'Total number of times this automation step has been executed since activation.',
    `goal_metric` STRING COMMENT 'Primary success metric or key performance indicator (KPI) this automation step is designed to optimize (e.g., open_rate, click_through_rate, conversion_rate).',
    `is_deleted` BOOLEAN COMMENT 'Soft delete indicator showing whether this automation step has been logically deleted (True/False).',
    `last_execution_timestamp` TIMESTAMP COMMENT 'Date and time when this automation step was last executed.',
    `modified_by` STRING COMMENT 'Username or identifier of the marketing user who last modified this automation step.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this automation step record was last modified.',
    `notes` STRING COMMENT 'Free-form internal notes or comments about this automation step for marketing team reference.',
    `personalization_enabled` BOOLEAN COMMENT 'Indicates whether dynamic personalization is enabled for this automation step (True/False).',
    `priority_level` STRING COMMENT 'Execution priority level of this automation step relative to other steps (low, medium, high, critical).',
    `retry_count` STRING COMMENT 'Number of retry attempts allowed if the automation step execution fails.',
    `retry_interval_minutes` STRING COMMENT 'Time interval in minutes between retry attempts for failed automation step executions.',
    `send_time_optimization` BOOLEAN COMMENT 'Indicates whether send time optimization (STO) is enabled to deliver messages at the optimal time for each recipient (True/False).',
    `sender_email` STRING COMMENT 'Email address from which email-type automation steps are sent.',
    `sender_name` STRING COMMENT 'Display name of the sender for email or SMS automation steps.',
    `step_code` STRING COMMENT 'Unique business identifier code for the automation step, used for external references and integrations.',
    `step_description` STRING COMMENT 'Detailed business description of the automation steps purpose, behavior, and intended outcome.',
    `step_name` STRING COMMENT 'Human-readable name of the automation step (e.g., Welcome Email, Abandoned Cart Reminder, Post-Purchase Survey).',
    `step_sequence` STRING COMMENT 'Ordinal position of this step within its parent automation workflow, determining execution order.',
    `step_status` STRING COMMENT 'Current lifecycle status of the automation step indicating whether it is active, inactive, draft, archived, deprecated, or in testing.',
    `step_type` STRING COMMENT 'Classification of the automation step by its execution type (email, SMS, push notification, webhook, wait, conditional split, A/B test).',
    `subject_line` STRING COMMENT 'Subject line text for email-type automation steps, may include personalization tokens.',
    `target_audience_segment` STRING COMMENT 'Customer segment or audience group targeted by this automation step (e.g., new_customers, lapsed_buyers, high_value).',
    `throttle_limit_per_hour` STRING COMMENT 'Maximum number of messages this automation step can send per hour to prevent system overload or deliverability issues.',
    `wait_duration_minutes` STRING COMMENT 'Duration in minutes for wait-type automation steps before proceeding to the next step.',
    `webhook_method` STRING COMMENT 'HTTP method used for webhook-type automation steps (GET, POST, PUT, PATCH, DELETE).',
    `webhook_url` STRING COMMENT 'Target URL endpoint for webhook-type automation steps to send event data to external systems.',
    `created_by` STRING COMMENT 'Username or identifier of the marketing user who created this automation step.',
    CONSTRAINT pk_automation_step PRIMARY KEY(`automation_step_id`)
) COMMENT 'Master reference table for automation_step. Referenced by current_step_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`email_template` (
    `email_template_id` BIGINT COMMENT 'Primary key for email_template',
    `associate_id` BIGINT COMMENT 'Reference to the user who approved this template for production use.',
    `email_associate_id` BIGINT COMMENT 'Reference to the marketing user or administrator who originally created this template.',
    `email_last_modified_by_user_associate_id` BIGINT COMMENT 'Reference to the user who most recently modified this template.',
    `marketing_brand_id` BIGINT COMMENT 'Reference to the retail brand or sub-brand this template is associated with for brand consistency.',
    `parent_email_template_id` BIGINT COMMENT 'Self-referencing FK on email_template (parent_email_template_id)',
    `ab_test_enabled_flag` BOOLEAN COMMENT 'Indicates whether this template is configured to support A/B testing variations for optimization.',
    `accessibility_compliant_flag` BOOLEAN COMMENT 'Indicates whether the template meets accessibility standards for users with disabilities.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the template was approved for use in live campaigns.',
    `audience_segment` STRING COMMENT 'Description of the intended audience segment or persona this template is optimized for.',
    `campaign_category` STRING COMMENT 'High-level marketing campaign category this template is designed to support.',
    `compliance_reviewed_flag` BOOLEAN COMMENT 'Indicates whether the template has been reviewed for regulatory compliance including CAN-SPAM, GDPR, and CASL requirements.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the email template record was first created in the system.',
    `design_framework` STRING COMMENT 'The design system or framework used to build the email template structure.',
    `dynamic_content_flag` BOOLEAN COMMENT 'Indicates whether the template includes dynamic content blocks that change based on recipient attributes or behavior.',
    `effective_end_date` DATE COMMENT 'Date after which this template is no longer available for use. Null indicates no expiration.',
    `effective_start_date` DATE COMMENT 'Date from which this template becomes available for use in marketing campaigns.',
    `from_email` STRING COMMENT 'Email address shown as the sender of the email. Must be a verified domain address.',
    `from_name` STRING COMMENT 'Display name shown as the sender of the email in the recipients inbox.',
    `html_body` STRING COMMENT 'The HTML-formatted content of the email template including markup, styling, and personalization tokens.',
    `language_code` STRING COMMENT 'ISO 639-1 language code (with optional ISO 3166-1 country code) indicating the language of the template content.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the email template was last updated or modified.',
    `last_used_timestamp` TIMESTAMP COMMENT 'Date and time when this template was most recently used in an email campaign send.',
    `mobile_optimized_flag` BOOLEAN COMMENT 'Indicates whether the template has been designed and tested for optimal rendering on mobile devices.',
    `notes` STRING COMMENT 'Internal notes or comments about the template for marketing team reference and documentation.',
    `personalization_level` STRING COMMENT 'Degree of dynamic personalization and customization capability built into the template.',
    `preheader_text` STRING COMMENT 'Preview text that appears after the subject line in email clients, providing additional context to encourage opens.',
    `reply_to_email` STRING COMMENT 'Email address where recipient replies will be directed. May differ from the from_email address.',
    `spam_score` DECIMAL(18,2) COMMENT 'Calculated spam likelihood score for the template content, used to optimize deliverability. Lower scores indicate better deliverability.',
    `email_template_status` STRING COMMENT 'Current lifecycle status of the email template indicating its availability for use in campaigns.',
    `subject_line` STRING COMMENT 'The subject line text that appears in the recipients inbox. May contain personalization tokens.',
    `tags` STRING COMMENT 'Comma-separated list of tags or keywords for organizing and searching templates within the marketing platform.',
    `template_code` STRING COMMENT 'Unique business identifier code for the email template used for external reference and system integration.',
    `template_name` STRING COMMENT 'Human-readable name of the email template for identification and selection purposes.',
    `template_type` STRING COMMENT 'Classification of the email template based on its marketing purpose and use case.',
    `text_body` STRING COMMENT 'Plain text version of the email content for email clients that do not support HTML rendering.',
    `thumbnail_url` STRING COMMENT 'URL to a preview thumbnail image of the email template for quick visual identification in the marketing platform.',
    `usage_count` STRING COMMENT 'Total number of times this template has been used in email campaigns since creation.',
    `version_number` STRING COMMENT 'Version identifier for tracking template iterations and changes over time.',
    CONSTRAINT pk_email_template PRIMARY KEY(`email_template_id`)
) COMMENT 'Master reference table for email_template. Referenced by email_template_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`publisher` (
    `publisher_id` BIGINT COMMENT 'Primary key for publisher',
    `parent_publisher_id` BIGINT COMMENT 'Self-referencing FK on publisher (parent_publisher_id)',
    `ad_format_supported` STRING COMMENT 'The types of advertising formats supported by the publisher (e.g., banner, video, native, sponsored content, email).',
    `attribution_window_days` STRING COMMENT 'The number of days after a user interaction during which conversions are attributed to this publisher for campaign performance measurement.',
    `audience_reach_estimate` BIGINT COMMENT 'The estimated total audience reach or user base size of the publisher platform.',
    `brand_safety_certified` BOOLEAN COMMENT 'Indicates whether the publisher has been certified for brand safety standards and content suitability.',
    `publisher_code` STRING COMMENT 'The externally-known unique code or identifier for the publisher used in campaign tracking and attribution systems.',
    `commission_rate_percent` DECIMAL(18,2) COMMENT 'The commission or revenue share percentage paid to the publisher for performance-based campaigns.',
    `content_category` STRING COMMENT 'The primary content category or vertical focus of the publisher (e.g., news, entertainment, lifestyle, technology, sports).',
    `contract_end_date` DATE COMMENT 'The date when the publisher contract or partnership agreement expires or terminates. Nullable for open-ended agreements.',
    `contract_start_date` DATE COMMENT 'The date when the publisher contract or partnership agreement becomes effective.',
    `cost_per_click_usd` DECIMAL(18,2) COMMENT 'The negotiated cost per click rate in USD for click-based advertising campaigns with this publisher.',
    `cost_per_impression_usd` DECIMAL(18,2) COMMENT 'The negotiated cost per thousand impressions (CPM) rate in USD for impression-based advertising campaigns with this publisher.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this publisher record was first created in the system.',
    `fraud_risk_level` STRING COMMENT 'The assessed fraud risk level for traffic and conversions from this publisher (low, medium, high, verified).',
    `geographic_coverage` STRING COMMENT 'The primary geographic markets or regions where the publisher has significant audience presence (e.g., USA, CAN, GBR, global).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this publisher record was last updated or modified.',
    `publisher_name` STRING COMMENT 'The official business name of the publisher or media platform.',
    `notes` STRING COMMENT 'Free-form notes or comments about the publisher relationship, performance observations, or special considerations.',
    `payment_terms` STRING COMMENT 'The agreed payment terms for publisher invoices (e.g., net 30, net 60, net 90, prepaid, postpaid).',
    `preferred_vendor` BOOLEAN COMMENT 'Indicates whether this publisher is designated as a preferred or strategic vendor for marketing campaigns.',
    `primary_contact_email` STRING COMMENT 'The email address of the primary business contact at the publisher organization.',
    `primary_contact_name` STRING COMMENT 'The name of the primary business contact or account manager at the publisher organization.',
    `primary_contact_phone` STRING COMMENT 'The phone number of the primary business contact at the publisher organization.',
    `publisher_type` STRING COMMENT 'The category or type of publisher platform (e.g., search engine, social media, display network, affiliate, email service, video platform).',
    `quality_score` DECIMAL(18,2) COMMENT 'An internal quality score or rating (0.00 to 5.00) assigned to the publisher based on traffic quality, conversion performance, and brand safety.',
    `publisher_status` STRING COMMENT 'Current lifecycle status of the publisher relationship (active, inactive, suspended, pending approval, archived).',
    `target_demographics` STRING COMMENT 'The primary demographic segments or audience profiles that the publisher reaches (e.g., millennials, parents, tech enthusiasts).',
    `tier` STRING COMMENT 'The tier or classification level of the publisher based on reach, performance, or strategic importance (premium, standard, emerging, test).',
    `tracking_pixel_enabled` BOOLEAN COMMENT 'Indicates whether tracking pixel integration is enabled for attribution and conversion tracking with this publisher.',
    `website_url` STRING COMMENT 'The primary website URL or domain of the publisher platform.',
    CONSTRAINT pk_publisher PRIMARY KEY(`publisher_id`)
) COMMENT 'Master reference table for publisher. Referenced by publisher_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`segment` (
    `segment_id` BIGINT COMMENT 'Primary key for segment',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Customer segments are owned by marketing analysts, merchandising managers, or CRM specialists who define qualification criteria, monitor segment performance, design targeted campaigns, and refresh mem',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Customer segments defined by category affinity ("Premium Electronics Buyers", "Organic Enthusiasts") for category-targeted campaigns and segment-aware assortment planning. Replaces denormalized prefer',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Customer segments are often defined by product category affinity. Existing preferred_product_category text field should be proper FK to item_hierarchy for segment-based assortment planning, targeted',
    `price_list_id` BIGINT COMMENT 'Foreign key linking to pricing.price_list. Business justification: Customer segments drive targeted pricing strategies (loyalty tier pricing, VIP exclusive pricing, student/senior discounts). Merchandising teams create segment-specific price lists to optimize convers',
    `price_strategy_id` BIGINT COMMENT 'Foreign key linking to pricing.price_strategy. Business justification: Price strategies are designed for specific customer segments (high-value customers get EDLP, price-sensitive get Hi-Lo promotional). Category managers define strategy-segment mappings during annual pl',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Customer segments are explicitly targeted by promotional campaigns (promo_campaign.customer_segment_target exists as text field). Creating FK enables direct segment-to-campaign assignment for targeted',
    `auto_refresh_flag` BOOLEAN COMMENT 'Indicates whether customer membership in this segment is automatically recalculated on a scheduled basis (True) or manually managed (False). True for dynamic segments (e.g., RFM tiers recalculated nightly); False for static segments (e.g., one-time campaign lists).',
    `average_aov` DECIMAL(18,2) COMMENT 'Mean Average Order Value for customers in this segment over the measurement period. Key metric for pricing strategy, promotion design, and basket optimization. Expressed in base currency (USD).',
    `average_cltv` DECIMAL(18,2) COMMENT 'Mean Customer Lifetime Value across all customers currently assigned to this segment. Used for segment valuation, investment prioritization, and ROI forecasting. Expressed in base currency (USD).',
    `average_purchase_frequency` DECIMAL(18,2) COMMENT 'Mean number of transactions per customer in this segment over the measurement period (typically 12 months). Used for replenishment forecasting, loyalty program design, and churn prediction.',
    `b2b_b2c_indicator` STRING COMMENT 'Indicates whether this segment applies to B2B customers (business accounts, wholesale, corporate), B2C customers (individual consumers), or both. Drives differentiated engagement strategies, pricing models, and service levels.. Valid values are `b2b|b2c|both`',
    `ccpa_opt_out_honored_flag` BOOLEAN COMMENT 'Indicates whether this segment respects CCPA Do Not Sell My Personal Information opt-out requests (True) or is exempt (False, e.g., service-related communications). Ensures compliance for California residents.',
    `churn_risk_score` DECIMAL(18,2) COMMENT 'Aggregate churn risk score for this segment, ranging from 0.00 (no risk) to 100.00 (high risk). Calculated from recency, frequency, and engagement metrics. Drives retention campaign prioritization and at-risk customer interventions.',
    `segment_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the segment for operational use (e.g., VIP_GOLD, LAPSED_90D, HIGH_VALUE_B2B). Used in marketing campaigns, pricing rules, and POS systems.. Valid values are `^[A-Z0-9_]{3,20}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this segment definition was first created in the system. Audit trail for segment lifecycle tracking and governance.',
    `segment_description` STRING COMMENT 'Detailed narrative describing the segments defining characteristics, business rationale, and strategic purpose. Includes target customer profile, expected behaviors, and recommended engagement strategies.',
    `discount_sensitivity` STRING COMMENT 'Behavioral classification of segments responsiveness to promotional pricing. High: primarily purchases on promotion (Hi-Lo shoppers). Medium: balanced full-price and promotional purchases. Low: primarily full-price purchases (EDLP preference or premium segment).. Valid values are `high|medium|low`',
    `effective_end_date` DATE COMMENT 'Date when this segment definition was retired or superseded. Null for currently active segments. Enables segment lifecycle management and historical reporting.',
    `effective_start_date` DATE COMMENT 'Date when this segment definition became active and available for customer assignment. Supports temporal segmentation strategies and historical analysis.',
    `gdpr_consent_required_flag` BOOLEAN COMMENT 'Indicates whether explicit customer consent is required under GDPR for marketing communications to this segment (True) or whether legitimate interest or other legal basis applies (False). Ensures regulatory compliance for EU customers.',
    `geographic_scope` STRING COMMENT 'Geographic boundary or region to which this segment applies (e.g., USA, Northeast Region, Urban Markets, Global). Supports localized segmentation strategies and regional campaign targeting. Use ISO 3166-1 alpha-3 country codes where applicable.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this segment definition was last updated (criteria, name, status, or any other attribute). Supports change tracking and audit compliance.',
    `last_refresh_timestamp` TIMESTAMP COMMENT 'Date and time when segment membership was last recalculated and customer assignments were updated. Critical for data freshness validation and SLA monitoring.',
    `max_rfm_score` STRING COMMENT 'Maximum RFM composite score for customer assignment to this segment (if segment_type is rfm_tier). Defines the upper bound of the RFM tier. Null for non-RFM segments.',
    `membership_count` BIGINT COMMENT 'Current count of customers assigned to this segment. Updated periodically based on auto-refresh schedule. Used for segment sizing, campaign planning, and capacity forecasting.',
    `min_rfm_score` STRING COMMENT 'Minimum RFM composite score required for customer assignment to this segment (if segment_type is rfm_tier). RFM scores typically range from 3 (lowest: 1-1-1) to 15 (highest: 5-5-5). Null for non-RFM segments.',
    `segment_name` STRING COMMENT 'Human-readable name of the segment (e.g., VIP Gold Tier, Lapsed Customers - 90 Days, High-Value B2B Accounts). Used in reporting, dashboards, and customer-facing communications.',
    `nps_score` DECIMAL(18,2) COMMENT 'Average Net Promoter Score for customers in this segment, ranging from -100.00 (all detractors) to +100.00 (all promoters). Measures customer satisfaction, loyalty, and likelihood to recommend. Used for segment health monitoring and experience improvement prioritization.',
    `owning_business_unit` STRING COMMENT 'Name of the business unit or department responsible for defining, maintaining, and governing this segment (e.g., Marketing Analytics, Customer Insights, Loyalty Program Management). Establishes accountability for segment quality and usage.',
    `priority_tier` STRING COMMENT 'Service and engagement priority level assigned to this segment. Platinum: highest CLTV, white-glove service. Gold: high-value, priority support. Silver: mid-value, standard service. Bronze: emerging value. Standard: baseline service. Drives clienteling strategies and resource allocation.. Valid values are `platinum|gold|silver|bronze|standard`',
    `qualification_criteria` STRING COMMENT 'Summary of the business rules and thresholds used to assign customers to this segment (e.g., Purchased in last 30 days AND total spend > $5000 in last 12 months, RFM Score >= 9, Age 25-34 AND lives in urban area). Human-readable representation of the segmentation logic.',
    `refresh_frequency` STRING COMMENT 'Cadence at which segment membership is recalculated for auto-refresh segments. Daily: high-velocity behavioral segments. Weekly: standard RFM tiers. Monthly: demographic or lifecycle segments. Quarterly: strategic value tiers. On-Demand: manual trigger only.. Valid values are `daily|weekly|monthly|quarterly|on_demand`',
    `segment_status` STRING COMMENT 'Current lifecycle status of the segment definition. Active: in production use for customer assignment and campaigns. Inactive: temporarily suspended, no new assignments. Archived: retired, historical reference only. Draft: under development, not yet released.. Valid values are `active|inactive|archived|draft`',
    `segment_type` STRING COMMENT 'Classification of the segmentation methodology applied. RFM Tier: Recency, Frequency, Monetary analysis. Demographic: age, gender, income. Behavioral: purchase patterns, product affinity. Psychographic: lifestyle, values. Lifecycle Stage: new, active, at-risk, lapsed. Geographic: region, climate zone. Channel Preference: omnichannel, e-commerce-only, store-only. Value Tier: CLTV-based stratification. [ENUM-REF-CANDIDATE: rfm_tier|demographic|behavioral|psychographic|lifecycle_stage|geographic|channel_preference|value_tier — 8 candidates stripped; promote to reference product]',
    `target_marketing_channel` STRING COMMENT 'Primary communication channel recommended for engaging customers in this segment. Aligns segment strategy with channel preference and regulatory consent. All Channels: omnichannel engagement strategy. [ENUM-REF-CANDIDATE: email|sms|push_notification|direct_mail|in_store|call_center|social_media|all_channels — 8 candidates stripped; promote to reference product]',
    CONSTRAINT pk_segment PRIMARY KEY(`segment_id`)
) COMMENT 'Defines market segmentation classifications applied to customer profiles for targeted marketing, personalized pricing, and assortment decisions. Stores segment code, segment name, segment type (RFM tier, demographic, behavioral, psychographic, lifecycle stage, geographic, channel preference, value tier), segment description, qualification criteria summary, membership count, effective date range, auto-refresh flag, owning business unit, and profile-to-segment assignments with effective dates and expiry dates. Enables Retail to execute clienteling strategies, personalized promotions, and differentiated service levels across POS and e-commerce channels.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`marketing`.`customer_membership` (
    `customer_membership_id` BIGINT COMMENT 'Primary key for customer_membership',
    `segment_id` BIGINT COMMENT 'Foreign key linking to the segment definition to which this profile is assigned',
    `loyalty_membership_id` BIGINT COMMENT 'Unique identifier for this segment membership record. Primary key.',
    `profile_id` BIGINT COMMENT 'Foreign key linking to the customer profile participating in this segment membership',
    `assignment_confidence_score` DECIMAL(18,2) COMMENT 'Confidence score (0.00-100.00) indicating the strength of this customers qualification for this segment. For rule-based assignments, reflects how strongly the customer meets qualification criteria. For ML-based assignments, reflects model prediction confidence. Used for prioritizing marketing outreach and identifying borderline members.',
    `assignment_method` STRING COMMENT 'Mechanism by which this customer was assigned to this segment. AutoRefresh: automatically assigned via scheduled segment refresh process. ManualOverride: manually assigned by business user overriding qualification rules. RuleEngine: assigned via real-time rule evaluation. MLModel: assigned via predictive model scoring. BulkImport: assigned via batch data load.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this membership record was first created in the system. Audit field for data lineage and troubleshooting.',
    `customer_membership_status` STRING COMMENT 'Current operational status of this segment membership. Active: customer currently qualifies and membership is in effect. Expired: membership ended due to disqualification or time-based expiry. Suspended: temporarily inactive due to business rules. PendingQualification: awaiting next refresh cycle to confirm eligibility.',
    `end_date` DATE COMMENT 'Date when this customer profile exited this segment or the membership was terminated. Null for currently active memberships. Used for churn analysis and segment tenure calculations.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this membership record was last updated (status change, confidence score update, override modification). Audit field for change tracking.',
    `last_qualification_check_date` TIMESTAMP COMMENT 'Timestamp of the most recent evaluation of this customers eligibility for this segment. Updated during auto-refresh cycles or manual re-qualification checks. Used for audit trails and determining when next qualification check is due.',
    `manual_override_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this membership was manually assigned by a business user, overriding automated qualification rules. True: manual override in effect, customer may not meet standard qualification criteria. False: standard rule-based or automated assignment. Used for governance and audit purposes.',
    `override_reason` STRING COMMENT 'Free-text explanation provided by business user when manual_override_flag is true. Documents business justification for overriding automated qualification rules (e.g., VIP customer per executive request, Strategic account exception, Retention offer). Null when no override is in effect.',
    `start_date` DATE COMMENT 'Date when this customer profile was assigned to this segment and the membership became active. Used for lifecycle tracking and historical analysis of segment transitions.',
    CONSTRAINT pk_customer_membership PRIMARY KEY(`customer_membership_id`)
) COMMENT 'This association product represents the assignment of customer profiles to market segments for targeted marketing, personalized pricing, and differentiated service delivery. It captures the operational reality that customers can simultaneously belong to multiple segments (e.g., VIP Gold + High CLTV + Geographic Northeast) and that segments contain many customers. Each record links one profile to one segment with lifecycle attributes (start/end dates, status), assignment metadata (method, confidence, override flags), and qualification tracking that exist only in the context of this membership relationship.. Existence Justification: Customer segmentation in retail operates as a true many-to-many relationship where individual customer profiles are simultaneously assigned to multiple segments (e.g., a customer can be both VIP Gold Tier and High CLTV and Northeast Geographic at the same time), and each segment definition contains thousands of customer profiles. Marketing teams actively manage these memberships as operational business entities, tracking when customers enter/exit segments, how they were assigned (auto-refresh vs. manual override), and qualification confidence scores. The segment table currently has no FK relationships to profile—it is a definition table that requires an association product to operationalize the membership relationship.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ADD CONSTRAINT `fk_marketing_campaign_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_retail_v1`.`marketing`.`channel`(`channel_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ADD CONSTRAINT `fk_marketing_campaign_marketing_brand_id` FOREIGN KEY (`marketing_brand_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_brand`(`marketing_brand_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ADD CONSTRAINT `fk_marketing_campaign_parent_campaign_id` FOREIGN KEY (`parent_campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ADD CONSTRAINT `fk_marketing_campaign_brief_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ADD CONSTRAINT `fk_marketing_campaign_brief_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`segment`(`segment_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ADD CONSTRAINT `fk_marketing_campaign_brief_marketing_brand_id` FOREIGN KEY (`marketing_brand_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_brand`(`marketing_brand_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ADD CONSTRAINT `fk_marketing_campaign_brief_revised_from_campaign_brief_id` FOREIGN KEY (`revised_from_campaign_brief_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign_brief`(`campaign_brief_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`audience_segment` ADD CONSTRAINT `fk_marketing_audience_segment_parent_audience_segment_id` FOREIGN KEY (`parent_audience_segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`audience_segment`(`audience_segment_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` ADD CONSTRAINT `fk_marketing_campaign_audience_audience_segment_id` FOREIGN KEY (`audience_segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`audience_segment`(`audience_segment_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` ADD CONSTRAINT `fk_marketing_campaign_audience_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` ADD CONSTRAINT `fk_marketing_campaign_audience_split_from_campaign_audience_id` FOREIGN KEY (`split_from_campaign_audience_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign_audience`(`campaign_audience_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ADD CONSTRAINT `fk_marketing_media_plan_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ADD CONSTRAINT `fk_marketing_media_plan_marketing_budget_id` FOREIGN KEY (`marketing_budget_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_budget`(`marketing_budget_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ADD CONSTRAINT `fk_marketing_media_plan_revised_from_media_plan_id` FOREIGN KEY (`revised_from_media_plan_id`) REFERENCES `vibe_retail_v1`.`marketing`.`media_plan`(`media_plan_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ADD CONSTRAINT `fk_marketing_media_buy_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ADD CONSTRAINT `fk_marketing_media_buy_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_retail_v1`.`marketing`.`channel`(`channel_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ADD CONSTRAINT `fk_marketing_media_buy_creative_asset_id` FOREIGN KEY (`creative_asset_id`) REFERENCES `vibe_retail_v1`.`marketing`.`creative_asset`(`creative_asset_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ADD CONSTRAINT `fk_marketing_media_buy_make_good_for_media_buy_id` FOREIGN KEY (`make_good_for_media_buy_id`) REFERENCES `vibe_retail_v1`.`marketing`.`media_buy`(`media_buy_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ADD CONSTRAINT `fk_marketing_media_buy_marketing_brand_id` FOREIGN KEY (`marketing_brand_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_brand`(`marketing_brand_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ADD CONSTRAINT `fk_marketing_media_buy_media_plan_id` FOREIGN KEY (`media_plan_id`) REFERENCES `vibe_retail_v1`.`marketing`.`media_plan`(`media_plan_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ADD CONSTRAINT `fk_marketing_media_buy_publisher_id` FOREIGN KEY (`publisher_id`) REFERENCES `vibe_retail_v1`.`marketing`.`publisher`(`publisher_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ADD CONSTRAINT `fk_marketing_creative_asset_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ADD CONSTRAINT `fk_marketing_creative_asset_marketing_brand_id` FOREIGN KEY (`marketing_brand_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_brand`(`marketing_brand_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ADD CONSTRAINT `fk_marketing_creative_asset_parent_asset_creative_asset_id` FOREIGN KEY (`parent_asset_creative_asset_id`) REFERENCES `vibe_retail_v1`.`marketing`.`creative_asset`(`creative_asset_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ADD CONSTRAINT `fk_marketing_creative_asset_primary_derived_from_creative_asset_id` FOREIGN KEY (`primary_derived_from_creative_asset_id`) REFERENCES `vibe_retail_v1`.`marketing`.`creative_asset`(`creative_asset_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ADD CONSTRAINT `fk_marketing_email_send_audience_segment_id` FOREIGN KEY (`audience_segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`audience_segment`(`audience_segment_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ADD CONSTRAINT `fk_marketing_email_send_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ADD CONSTRAINT `fk_marketing_email_send_email_template_id` FOREIGN KEY (`email_template_id`) REFERENCES `vibe_retail_v1`.`marketing`.`email_template`(`email_template_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ADD CONSTRAINT `fk_marketing_email_send_resend_of_email_send_id` FOREIGN KEY (`resend_of_email_send_id`) REFERENCES `vibe_retail_v1`.`marketing`.`email_send`(`email_send_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ADD CONSTRAINT `fk_marketing_sms_send_audience_segment_id` FOREIGN KEY (`audience_segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`audience_segment`(`audience_segment_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ADD CONSTRAINT `fk_marketing_sms_send_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ADD CONSTRAINT `fk_marketing_sms_send_resend_of_sms_send_id` FOREIGN KEY (`resend_of_sms_send_id`) REFERENCES `vibe_retail_v1`.`marketing`.`sms_send`(`sms_send_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ADD CONSTRAINT `fk_marketing_push_notification_send_audience_segment_id` FOREIGN KEY (`audience_segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`audience_segment`(`audience_segment_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ADD CONSTRAINT `fk_marketing_push_notification_send_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ADD CONSTRAINT `fk_marketing_push_notification_send_resend_of_push_notification_send_id` FOREIGN KEY (`resend_of_push_notification_send_id`) REFERENCES `vibe_retail_v1`.`marketing`.`push_notification_send`(`push_notification_send_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ADD CONSTRAINT `fk_marketing_social_post_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ADD CONSTRAINT `fk_marketing_social_post_creative_asset_id` FOREIGN KEY (`creative_asset_id`) REFERENCES `vibe_retail_v1`.`marketing`.`creative_asset`(`creative_asset_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ADD CONSTRAINT `fk_marketing_social_post_marketing_brand_id` FOREIGN KEY (`marketing_brand_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_brand`(`marketing_brand_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ADD CONSTRAINT `fk_marketing_social_post_reply_to_social_post_id` FOREIGN KEY (`reply_to_social_post_id`) REFERENCES `vibe_retail_v1`.`marketing`.`social_post`(`social_post_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ADD CONSTRAINT `fk_marketing_influencer_referred_by_influencer_id` FOREIGN KEY (`referred_by_influencer_id`) REFERENCES `vibe_retail_v1`.`marketing`.`influencer`(`influencer_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ADD CONSTRAINT `fk_marketing_influencer_engagement_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ADD CONSTRAINT `fk_marketing_influencer_engagement_follow_up_influencer_engagement_id` FOREIGN KEY (`follow_up_influencer_engagement_id`) REFERENCES `vibe_retail_v1`.`marketing`.`influencer_engagement`(`influencer_engagement_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ADD CONSTRAINT `fk_marketing_influencer_engagement_influencer_id` FOREIGN KEY (`influencer_id`) REFERENCES `vibe_retail_v1`.`marketing`.`influencer`(`influencer_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_attribution_model_id` FOREIGN KEY (`attribution_model_id`) REFERENCES `vibe_retail_v1`.`marketing`.`attribution_model`(`attribution_model_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_audience_segment_id` FOREIGN KEY (`audience_segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`audience_segment`(`audience_segment_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_creative_asset_id` FOREIGN KEY (`creative_asset_id`) REFERENCES `vibe_retail_v1`.`marketing`.`creative_asset`(`creative_asset_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_marketing_brand_id` FOREIGN KEY (`marketing_brand_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_brand`(`marketing_brand_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_media_buy_id` FOREIGN KEY (`media_buy_id`) REFERENCES `vibe_retail_v1`.`marketing`.`media_buy`(`media_buy_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_prior_attribution_touchpoint_id` FOREIGN KEY (`prior_attribution_touchpoint_id`) REFERENCES `vibe_retail_v1`.`marketing`.`attribution_touchpoint`(`attribution_touchpoint_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ADD CONSTRAINT `fk_marketing_attribution_model_attribution_baseline_model_id` FOREIGN KEY (`attribution_baseline_model_id`) REFERENCES `vibe_retail_v1`.`marketing`.`attribution_model`(`attribution_model_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ADD CONSTRAINT `fk_marketing_attribution_model_primary_superseded_attribution_model_id` FOREIGN KEY (`primary_superseded_attribution_model_id`) REFERENCES `vibe_retail_v1`.`marketing`.`attribution_model`(`attribution_model_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ADD CONSTRAINT `fk_marketing_conversion_event_assisted_by_conversion_event_id` FOREIGN KEY (`assisted_by_conversion_event_id`) REFERENCES `vibe_retail_v1`.`marketing`.`conversion_event`(`conversion_event_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ADD CONSTRAINT `fk_marketing_conversion_event_attribution_model_id` FOREIGN KEY (`attribution_model_id`) REFERENCES `vibe_retail_v1`.`marketing`.`attribution_model`(`attribution_model_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ADD CONSTRAINT `fk_marketing_conversion_event_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ADD CONSTRAINT `fk_marketing_marketing_budget_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ADD CONSTRAINT `fk_marketing_marketing_budget_marketing_brand_id` FOREIGN KEY (`marketing_brand_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_brand`(`marketing_brand_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ADD CONSTRAINT `fk_marketing_marketing_budget_revised_from_marketing_budget_id` FOREIGN KEY (`revised_from_marketing_budget_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_budget`(`marketing_budget_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ADD CONSTRAINT `fk_marketing_marketing_brand_parent_marketing_brand_id` FOREIGN KEY (`parent_marketing_brand_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_brand`(`marketing_brand_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ADD CONSTRAINT `fk_marketing_channel_parent_channel_id` FOREIGN KEY (`parent_channel_id`) REFERENCES `vibe_retail_v1`.`marketing`.`channel`(`channel_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ADD CONSTRAINT `fk_marketing_utm_parameter_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ADD CONSTRAINT `fk_marketing_utm_parameter_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_retail_v1`.`marketing`.`channel`(`channel_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ADD CONSTRAINT `fk_marketing_utm_parameter_derived_from_utm_parameter_id` FOREIGN KEY (`derived_from_utm_parameter_id`) REFERENCES `vibe_retail_v1`.`marketing`.`utm_parameter`(`utm_parameter_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ADD CONSTRAINT `fk_marketing_ab_test_campaign_audience_segment_id` FOREIGN KEY (`audience_segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`audience_segment`(`audience_segment_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ADD CONSTRAINT `fk_marketing_ab_test_campaign_baseline_ab_test_campaign_id` FOREIGN KEY (`baseline_ab_test_campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`ab_test_campaign`(`ab_test_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ADD CONSTRAINT `fk_marketing_ab_test_campaign_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ADD CONSTRAINT `fk_marketing_ab_test_campaign_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_retail_v1`.`marketing`.`channel`(`channel_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ADD CONSTRAINT `fk_marketing_ab_test_campaign_creative_asset_id` FOREIGN KEY (`creative_asset_id`) REFERENCES `vibe_retail_v1`.`marketing`.`creative_asset`(`creative_asset_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ADD CONSTRAINT `fk_marketing_automation_flow_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ADD CONSTRAINT `fk_marketing_automation_flow_cloned_from_automation_flow_id` FOREIGN KEY (`cloned_from_automation_flow_id`) REFERENCES `vibe_retail_v1`.`marketing`.`automation_flow`(`automation_flow_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ADD CONSTRAINT `fk_marketing_automation_flow_audience_segment_id` FOREIGN KEY (`audience_segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`audience_segment`(`audience_segment_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ADD CONSTRAINT `fk_marketing_automation_enrollment_audience_segment_id` FOREIGN KEY (`audience_segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`audience_segment`(`audience_segment_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ADD CONSTRAINT `fk_marketing_automation_enrollment_automation_flow_id` FOREIGN KEY (`automation_flow_id`) REFERENCES `vibe_retail_v1`.`marketing`.`automation_flow`(`automation_flow_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ADD CONSTRAINT `fk_marketing_automation_enrollment_automation_step_id` FOREIGN KEY (`automation_step_id`) REFERENCES `vibe_retail_v1`.`marketing`.`automation_step`(`automation_step_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ADD CONSTRAINT `fk_marketing_automation_enrollment_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ADD CONSTRAINT `fk_marketing_automation_enrollment_re_enrolled_from_automation_enrollment_id` FOREIGN KEY (`re_enrolled_from_automation_enrollment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`automation_enrollment`(`automation_enrollment_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ADD CONSTRAINT `fk_marketing_opt_in_record_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_retail_v1`.`marketing`.`channel`(`channel_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ADD CONSTRAINT `fk_marketing_opt_in_record_superseded_opt_in_record_id` FOREIGN KEY (`superseded_opt_in_record_id`) REFERENCES `vibe_retail_v1`.`marketing`.`opt_in_record`(`opt_in_record_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ADD CONSTRAINT `fk_marketing_campaign_performance_attribution_model_id` FOREIGN KEY (`attribution_model_id`) REFERENCES `vibe_retail_v1`.`marketing`.`attribution_model`(`attribution_model_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ADD CONSTRAINT `fk_marketing_campaign_performance_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ADD CONSTRAINT `fk_marketing_campaign_performance_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_retail_v1`.`marketing`.`channel`(`channel_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ADD CONSTRAINT `fk_marketing_campaign_performance_prior_period_campaign_performance_id` FOREIGN KEY (`prior_period_campaign_performance_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign_performance`(`campaign_performance_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ADD CONSTRAINT `fk_marketing_agency_brief_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ADD CONSTRAINT `fk_marketing_agency_brief_marketing_brand_id` FOREIGN KEY (`marketing_brand_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_brand`(`marketing_brand_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ADD CONSTRAINT `fk_marketing_agency_brief_revised_from_agency_brief_id` FOREIGN KEY (`revised_from_agency_brief_id`) REFERENCES `vibe_retail_v1`.`marketing`.`agency_brief`(`agency_brief_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_deployment` ADD CONSTRAINT `fk_marketing_campaign_deployment_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` ADD CONSTRAINT `fk_marketing_campaign_fulfillment_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ADD CONSTRAINT `fk_marketing_campaign_policy_compliance_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_step` ADD CONSTRAINT `fk_marketing_automation_step_email_template_id` FOREIGN KEY (`email_template_id`) REFERENCES `vibe_retail_v1`.`marketing`.`email_template`(`email_template_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_step` ADD CONSTRAINT `fk_marketing_automation_step_next_automation_step_id` FOREIGN KEY (`next_automation_step_id`) REFERENCES `vibe_retail_v1`.`marketing`.`automation_step`(`automation_step_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_template` ADD CONSTRAINT `fk_marketing_email_template_marketing_brand_id` FOREIGN KEY (`marketing_brand_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_brand`(`marketing_brand_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_template` ADD CONSTRAINT `fk_marketing_email_template_parent_email_template_id` FOREIGN KEY (`parent_email_template_id`) REFERENCES `vibe_retail_v1`.`marketing`.`email_template`(`email_template_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`publisher` ADD CONSTRAINT `fk_marketing_publisher_parent_publisher_id` FOREIGN KEY (`parent_publisher_id`) REFERENCES `vibe_retail_v1`.`marketing`.`publisher`(`publisher_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` ADD CONSTRAINT `fk_marketing_customer_membership_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`segment`(`segment_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`marketing` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_retail_v1`.`marketing` SET TAGS ('dbx_domain' = 'marketing');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` SET TAGS ('dbx_subdomain' = 'campaign_planning');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `campaign_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `campaign_modified_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `marketing_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Brand ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `price_strategy_id` SET TAGS ('dbx_business_glossary_term' = 'Price Strategy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `replenishment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Replenishment Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `training_program_id` SET TAGS ('dbx_business_glossary_term' = 'Required Training Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `campaign_status` SET TAGS ('dbx_value_regex' = 'draft|scheduled|active|paused|completed|cancelled');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `campaign_type` SET TAGS ('dbx_value_regex' = 'brand_awareness|acquisition|retention|win_back|seasonal|product_launch');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = 'national|regional|local|international');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `objective` SET TAGS ('dbx_business_glossary_term' = 'Campaign Objective');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `utm_campaign` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Campaign');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `utm_medium` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Medium');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ALTER COLUMN `utm_source` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Source');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` SET TAGS ('dbx_subdomain' = 'campaign_planning');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ALTER COLUMN `marketing_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ALTER COLUMN `privacy_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Privacy Assessment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ALTER COLUMN `brief_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|approved|rejected|revision_requested');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ALTER COLUMN `call_to_action` SET TAGS ('dbx_business_glossary_term' = 'Call to Action (CTA)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ALTER COLUMN `landing_page_url` SET TAGS ('dbx_business_glossary_term' = 'Landing Page URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ALTER COLUMN `success_kpi_definition` SET TAGS ('dbx_business_glossary_term' = 'Success KPI (Key Performance Indicator) Definition');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ALTER COLUMN `target_conversion_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Target Conversion Rate (CR) Percentage');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ALTER COLUMN `target_roi_pct` SET TAGS ('dbx_business_glossary_term' = 'Target ROI (Return on Investment) Percentage');
ALTER TABLE `vibe_retail_v1`.`marketing`.`audience_segment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`audience_segment` SET TAGS ('dbx_subdomain' = 'audience_intelligence');
ALTER TABLE `vibe_retail_v1`.`marketing`.`audience_segment` ALTER COLUMN `privacy_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Privacy Assessment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`audience_segment` ALTER COLUMN `activation_status` SET TAGS ('dbx_value_regex' = 'activated|not_activated|pending_activation|deactivated');
ALTER TABLE `vibe_retail_v1`.`marketing`.`audience_segment` ALTER COLUMN `average_aov` SET TAGS ('dbx_business_glossary_term' = 'Average Order Value (AOV)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`audience_segment` ALTER COLUMN `average_cltv` SET TAGS ('dbx_business_glossary_term' = 'Average Customer Lifetime Value (CLTV)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`audience_segment` ALTER COLUMN `creation_method` SET TAGS ('dbx_value_regex' = 'manual|rule_based|ml_model|lookalike_model|imported|cloned');
ALTER TABLE `vibe_retail_v1`.`marketing`.`audience_segment` ALTER COLUMN `model_code` SET TAGS ('dbx_business_glossary_term' = 'Model ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`audience_segment` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`marketing`.`audience_segment` ALTER COLUMN `segment_status` SET TAGS ('dbx_value_regex' = 'active|inactive|draft|archived|suspended|testing');
ALTER TABLE `vibe_retail_v1`.`marketing`.`audience_segment` ALTER COLUMN `segment_type` SET TAGS ('dbx_value_regex' = 'behavioral|demographic|psychographic|rfm_based|lookalike|suppression');
ALTER TABLE `vibe_retail_v1`.`marketing`.`audience_segment` ALTER COLUMN `tags` SET TAGS ('dbx_business_glossary_term' = 'Segment Tags');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` SET TAGS ('dbx_subdomain' = 'campaign_planning');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` ALTER COLUMN `budget_allocation_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` ALTER COLUMN `campaign_audience_status` SET TAGS ('dbx_value_regex' = 'draft|scheduled|active|paused|completed|cancelled');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` ALTER COLUMN `conversion_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Conversion Rate Percent (CR)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` ALTER COLUMN `cost_per_acquisition` SET TAGS ('dbx_business_glossary_term' = 'Cost Per Acquisition (CPA)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` ALTER COLUMN `lookalike_model_code` SET TAGS ('dbx_business_glossary_term' = 'Lookalike Model ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Campaign Audience Notes');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` ALTER COLUMN `opt_in_consent_verified` SET TAGS ('dbx_business_glossary_term' = 'Opt-In Consent Verified');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` ALTER COLUMN `return_on_ad_spend` SET TAGS ('dbx_business_glossary_term' = 'Return On Ad Spend (ROAS)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` ALTER COLUMN `revenue_attributed_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_audience` ALTER COLUMN `targeting_role` SET TAGS ('dbx_value_regex' = 'include|exclude|suppress|lookalike_seed|control_group|holdout');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` SET TAGS ('dbx_subdomain' = 'media_execution');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `marketing_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Budget Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `media_modified_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `owner_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Plan Owner ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `primary_media_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `dsp_platform_name` SET TAGS ('dbx_business_glossary_term' = 'Demand-Side Platform (DSP) Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `ooh_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Out-of-Home (OOH) Budget Amount');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `plan_code` SET TAGS ('dbx_business_glossary_term' = 'Media Plan Code');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Media Plan Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_business_glossary_term' = 'Media Plan Status');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|in_flight|completed|cancelled');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `sms_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Short Message Service (SMS) Budget Amount');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `target_cpa` SET TAGS ('dbx_business_glossary_term' = 'Target Cost Per Acquisition (CPA)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `target_cpc` SET TAGS ('dbx_business_glossary_term' = 'Target Cost Per Click (CPC)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `target_cpm` SET TAGS ('dbx_business_glossary_term' = 'Target Cost Per Mille (CPM)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `target_roas` SET TAGS ('dbx_business_glossary_term' = 'Target Return on Ad Spend (ROAS)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ALTER COLUMN `tv_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Television (TV) Budget Amount');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` SET TAGS ('dbx_subdomain' = 'media_execution');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `sku_price_id` SET TAGS ('dbx_business_glossary_term' = 'Advertised Sku Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Channel Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Featured Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `marketing_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Brand ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `media_created_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `media_modified_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `publisher_id` SET TAGS ('dbx_business_glossary_term' = 'Publisher or Vendor ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `buy_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Media Buy Reference Number');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `buy_reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `buy_status` SET TAGS ('dbx_business_glossary_term' = 'Media Buy Status');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `buy_type` SET TAGS ('dbx_business_glossary_term' = 'Media Buy Type');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `device_targeting` SET TAGS ('dbx_value_regex' = 'desktop|mobile|tablet|ctv|all');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `dsp_platform_name` SET TAGS ('dbx_business_glossary_term' = 'Demand-Side Platform (DSP) Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `insertion_order_number` SET TAGS ('dbx_business_glossary_term' = 'Insertion Order (IO) Number');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `is_programmatic` SET TAGS ('dbx_business_glossary_term' = 'Is Programmatic Buy Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Media Buy Notes');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `rate_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ALTER COLUMN `viewability_rate` SET TAGS ('dbx_business_glossary_term' = 'Viewability Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` SET TAGS ('dbx_subdomain' = 'content_delivery');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `creative_modified_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Featured Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `sku_price_id` SET TAGS ('dbx_business_glossary_term' = 'Featured Sku Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `marketing_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Brand ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Creative Team ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `parent_asset_creative_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Asset ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `primary_creative_owner_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Creative Owner User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `alt_text` SET TAGS ('dbx_business_glossary_term' = 'Alternative Text');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'not_submitted|pending_legal|pending_brand|pending_compliance|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `asset_status` SET TAGS ('dbx_value_regex' = 'draft|pending_review|approved|active|expired|archived');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `call_to_action` SET TAGS ('dbx_business_glossary_term' = 'Call to Action (CTA)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `creative_asset_description` SET TAGS ('dbx_business_glossary_term' = 'Asset Description');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `dimensions` SET TAGS ('dbx_business_glossary_term' = 'Asset Dimensions');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `file_size_kb` SET TAGS ('dbx_business_glossary_term' = 'File Size (KB)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `format` SET TAGS ('dbx_business_glossary_term' = 'Asset Format');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `is_compliant` SET TAGS ('dbx_business_glossary_term' = 'Is Compliant Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `is_master_version` SET TAGS ('dbx_business_glossary_term' = 'Is Master Version Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `keywords` SET TAGS ('dbx_business_glossary_term' = 'Asset Keywords');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `locale_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}_[A-Z]{2}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ALTER COLUMN `usage_rights` SET TAGS ('dbx_value_regex' = 'owned|licensed|royalty_free|rights_managed|creative_commons');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` SET TAGS ('dbx_subdomain' = 'content_delivery');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `ab_test_variant` SET TAGS ('dbx_business_glossary_term' = 'A/B Test Variant');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `bounce_count` SET TAGS ('dbx_business_glossary_term' = 'Total Bounce Count');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `click_count` SET TAGS ('dbx_business_glossary_term' = 'Total Click Count');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `completed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Send Completion Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `esp_job_code` SET TAGS ('dbx_business_glossary_term' = 'Email Service Provider (ESP) Job ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `esp_platform_name` SET TAGS ('dbx_business_glossary_term' = 'Email Service Provider (ESP) Platform Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `from_email_address` SET TAGS ('dbx_business_glossary_term' = 'Email From Address');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `from_email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `from_name` SET TAGS ('dbx_business_glossary_term' = 'Email From Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `is_test_send` SET TAGS ('dbx_business_glossary_term' = 'Is Test Send Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `open_count` SET TAGS ('dbx_business_glossary_term' = 'Total Open Count');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `preheader_text` SET TAGS ('dbx_business_glossary_term' = 'Email Preheader Text');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `reply_to_email_address` SET TAGS ('dbx_business_glossary_term' = 'Email Reply-To Address');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `reply_to_email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `send_name` SET TAGS ('dbx_business_glossary_term' = 'Email Send Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `send_priority` SET TAGS ('dbx_business_glossary_term' = 'Send Priority Level');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `send_priority` SET TAGS ('dbx_value_regex' = 'high|normal|low');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `send_status` SET TAGS ('dbx_business_glossary_term' = 'Email Send Status');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `send_status` SET TAGS ('dbx_value_regex' = 'scheduled|processing|completed|failed|cancelled|paused');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `send_type` SET TAGS ('dbx_business_glossary_term' = 'Email Send Type');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `send_type` SET TAGS ('dbx_value_regex' = 'batch|triggered|transactional|automated|test');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `subject_line` SET TAGS ('dbx_business_glossary_term' = 'Email Subject Line');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `suppression_list_applied` SET TAGS ('dbx_business_glossary_term' = 'Suppression List Applied Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `utm_campaign` SET TAGS ('dbx_business_glossary_term' = 'UTM Campaign Parameter');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `utm_medium` SET TAGS ('dbx_business_glossary_term' = 'UTM Medium Parameter');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ALTER COLUMN `utm_source` SET TAGS ('dbx_business_glossary_term' = 'UTM Source Parameter');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` SET TAGS ('dbx_subdomain' = 'content_delivery');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `sms_send_id` SET TAGS ('dbx_business_glossary_term' = 'SMS (Short Message Service) Send ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `ab_test_variant` SET TAGS ('dbx_business_glossary_term' = 'A/B Test Variant');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `failed_count` SET TAGS ('dbx_business_glossary_term' = 'Failed Delivery Count');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `is_mms` SET TAGS ('dbx_business_glossary_term' = 'Is MMS (Multimedia Messaging Service)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `media_url` SET TAGS ('dbx_business_glossary_term' = 'Media URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `message_content` SET TAGS ('dbx_business_glossary_term' = 'SMS Message Content');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `opt_out_count` SET TAGS ('dbx_business_glossary_term' = 'Opt-Out Count');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `platform_job_code` SET TAGS ('dbx_business_glossary_term' = 'Platform Job ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `send_cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `send_name` SET TAGS ('dbx_business_glossary_term' = 'SMS Send Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `send_priority` SET TAGS ('dbx_value_regex' = 'high|normal|low');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `send_status` SET TAGS ('dbx_business_glossary_term' = 'SMS Send Status');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `send_status` SET TAGS ('dbx_value_regex' = 'draft|scheduled|sending|completed|failed|cancelled');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `send_type` SET TAGS ('dbx_business_glossary_term' = 'SMS Send Type');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `send_type` SET TAGS ('dbx_value_regex' = 'promotional|transactional|alert|reminder|notification|service');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `sender_code` SET TAGS ('dbx_business_glossary_term' = 'Sender ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `short_code` SET TAGS ('dbx_business_glossary_term' = 'SMS Short Code');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `tracked_url` SET TAGS ('dbx_business_glossary_term' = 'Tracked URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `utm_campaign` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Campaign');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `utm_medium` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Medium');
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ALTER COLUMN `utm_source` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Source');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` SET TAGS ('dbx_subdomain' = 'content_delivery');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `ab_test_variant` SET TAGS ('dbx_business_glossary_term' = 'A/B Test Variant');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `action_button_1_url` SET TAGS ('dbx_business_glossary_term' = 'Action Button 1 URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `action_button_2_url` SET TAGS ('dbx_business_glossary_term' = 'Action Button 2 URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `deep_link_url` SET TAGS ('dbx_business_glossary_term' = 'Deep Link URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `image_url` SET TAGS ('dbx_business_glossary_term' = 'Image URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `platform` SET TAGS ('dbx_business_glossary_term' = 'Mobile Platform');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `platform` SET TAGS ('dbx_value_regex' = 'iOS|Android|both');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Send Priority');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'high|normal|low');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `push_platform_job_code` SET TAGS ('dbx_business_glossary_term' = 'Push Platform Job ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `send_cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `send_status` SET TAGS ('dbx_value_regex' = 'draft|scheduled|in_progress|completed|failed|cancelled');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `time_to_live_seconds` SET TAGS ('dbx_business_glossary_term' = 'Time To Live (TTL) Seconds');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `utm_campaign` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Campaign');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `utm_medium` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Medium');
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ALTER COLUMN `utm_source` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Source');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` SET TAGS ('dbx_subdomain' = 'content_delivery');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Platform Account ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `policy_id` SET TAGS ('dbx_business_glossary_term' = 'Advertising Policy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `creative_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Creative Asset Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `marketing_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Brand ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `tertiary_social_modified_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `account_handle` SET TAGS ('dbx_business_glossary_term' = 'Social Media Account Handle');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `boost_budget_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `call_to_action` SET TAGS ('dbx_business_glossary_term' = 'Call To Action (CTA) Type');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Post Comments Count');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `engagement_rate` SET TAGS ('dbx_business_glossary_term' = 'Engagement Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `hashtags` SET TAGS ('dbx_business_glossary_term' = 'Post Hashtags');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `impressions` SET TAGS ('dbx_business_glossary_term' = 'Post Impressions');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `is_boosted` SET TAGS ('dbx_business_glossary_term' = 'Boosted Post Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `likes` SET TAGS ('dbx_business_glossary_term' = 'Post Likes Count');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `link_clicks` SET TAGS ('dbx_business_glossary_term' = 'Post Link Clicks Count');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `mentions` SET TAGS ('dbx_business_glossary_term' = 'Post Mentions');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `platform` SET TAGS ('dbx_business_glossary_term' = 'Social Media Platform');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `platform_post_code` SET TAGS ('dbx_business_glossary_term' = 'Platform Post ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `post_content` SET TAGS ('dbx_business_glossary_term' = 'Post Content Text');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `post_status` SET TAGS ('dbx_business_glossary_term' = 'Post Publication Status');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `post_status` SET TAGS ('dbx_value_regex' = 'draft|scheduled|published|failed|deleted|archived');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `post_type` SET TAGS ('dbx_business_glossary_term' = 'Post Content Type');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `reach` SET TAGS ('dbx_business_glossary_term' = 'Post Reach');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `saves` SET TAGS ('dbx_business_glossary_term' = 'Post Saves Count');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `shares` SET TAGS ('dbx_business_glossary_term' = 'Post Shares Count');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `target_gender` SET TAGS ('dbx_value_regex' = 'all|male|female|non-binary');
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ALTER COLUMN `video_views` SET TAGS ('dbx_business_glossary_term' = 'Video Views Count');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` SET TAGS ('dbx_subdomain' = 'brand_partnerships');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `agency_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Agency Contact Email Address');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `agency_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `agency_name` SET TAGS ('dbx_business_glossary_term' = 'Talent Agency Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `audience_age_range` SET TAGS ('dbx_value_regex' = '13-17|18-24|25-34|35-44|45-54|55+');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `audience_geography` SET TAGS ('dbx_business_glossary_term' = 'Audience Geographic Distribution');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `content_niche` SET TAGS ('dbx_business_glossary_term' = 'Content Niche Category');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `contract_status` SET TAGS ('dbx_value_regex' = 'Active|Pending|Expired|Terminated|Inactive');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Influencer Email Address');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `engagement_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Engagement Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `ftc_disclosure_compliant` SET TAGS ('dbx_business_glossary_term' = 'Federal Trade Commission (FTC) Disclosure Compliant');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `full_name` SET TAGS ('dbx_business_glossary_term' = 'Influencer Full Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `instagram_handle` SET TAGS ('dbx_value_regex' = '^@?[A-Za-z0-9._]{1,30}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Influencer Notes');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Influencer Phone Number');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `preferred_content_format` SET TAGS ('dbx_value_regex' = 'Photo|Video|Story|Reel|Live|Blog');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `primary_platform` SET TAGS ('dbx_business_glossary_term' = 'Primary Social Media Platform');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `rate_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `stage_name` SET TAGS ('dbx_business_glossary_term' = 'Influencer Stage Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `tier_classification` SET TAGS ('dbx_business_glossary_term' = 'Influencer Tier Classification');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `tier_classification` SET TAGS ('dbx_value_regex' = 'Nano|Micro|Macro|Mega|Celebrity');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `tiktok_handle` SET TAGS ('dbx_value_regex' = '^@?[A-Za-z0-9._]{1,24}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ALTER COLUMN `twitter_handle` SET TAGS ('dbx_value_regex' = '^@?[A-Za-z0-9_]{1,15}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` SET TAGS ('dbx_subdomain' = 'brand_partnerships');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ALTER COLUMN `policy_id` SET TAGS ('dbx_business_glossary_term' = 'Disclosure Policy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ALTER COLUMN `influencer_created_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ALTER COLUMN `influencer_modified_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|revision_requested');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ALTER COLUMN `compensation_type` SET TAGS ('dbx_value_regex' = 'flat_fee|commission|gifting|hybrid');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ALTER COLUMN `ftc_disclosure_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'Federal Trade Commission (FTC) Disclosure Compliant Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ALTER COLUMN `payment_status` SET TAGS ('dbx_value_regex' = 'pending|scheduled|paid|cancelled');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` SET TAGS ('dbx_subdomain' = 'audience_intelligence');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `attribution_model_id` SET TAGS ('dbx_business_glossary_term' = 'Attribution Model Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `sku_price_id` SET TAGS ('dbx_business_glossary_term' = 'Exposed Sku Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Conversion Order ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `marketing_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Brand ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `privacy_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Tracking Privacy Assessment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `ad_network` SET TAGS ('dbx_business_glossary_term' = 'Advertising Network');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `anonymous_visitor_code` SET TAGS ('dbx_business_glossary_term' = 'Anonymous Visitor ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `channel_type` SET TAGS ('dbx_business_glossary_term' = 'Marketing Channel Type');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `conversion_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `geographic_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `ip_address` SET TAGS ('dbx_business_glossary_term' = 'IP (Internet Protocol) Address');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `is_view_through` SET TAGS ('dbx_business_glossary_term' = 'Is View-Through Conversion');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `landing_page_url` SET TAGS ('dbx_business_glossary_term' = 'Landing Page URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `referrer_url` SET TAGS ('dbx_business_glossary_term' = 'Referrer URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `time_to_conversion_hours` SET TAGS ('dbx_business_glossary_term' = 'Time to Conversion (Hours)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `touchpoint_type` SET TAGS ('dbx_business_glossary_term' = 'Touchpoint Interaction Type');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `user_agent` SET TAGS ('dbx_business_glossary_term' = 'User Agent String');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `utm_campaign` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Campaign');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `utm_content` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Content');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `utm_medium` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Medium');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `utm_source` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Source');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ALTER COLUMN `utm_term` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Term');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` SET TAGS ('dbx_subdomain' = 'audience_intelligence');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `attribution_baseline_model_id` SET TAGS ('dbx_business_glossary_term' = 'Baseline Attribution Model ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `attribution_created_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `attribution_modified_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Owning Team ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `algorithmic_model_code` SET TAGS ('dbx_business_glossary_term' = 'Algorithmic Model ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `cross_channel_enabled` SET TAGS ('dbx_business_glossary_term' = 'Cross-Channel Attribution Enabled');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `cross_device_enabled` SET TAGS ('dbx_business_glossary_term' = 'Cross-Device Attribution Enabled');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `excluded_channels` SET TAGS ('dbx_business_glossary_term' = 'Excluded Marketing Channels');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `included_channels` SET TAGS ('dbx_business_glossary_term' = 'Included Marketing Channels');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `is_default_model` SET TAGS ('dbx_business_glossary_term' = 'Is Default Attribution Model');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `max_touchpoints_considered` SET TAGS ('dbx_business_glossary_term' = 'Maximum Touchpoints Considered');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `min_touchpoints_required` SET TAGS ('dbx_business_glossary_term' = 'Minimum Touchpoints Required');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `model_code` SET TAGS ('dbx_business_glossary_term' = 'Attribution Model Code');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `model_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `model_description` SET TAGS ('dbx_business_glossary_term' = 'Attribution Model Description');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `model_name` SET TAGS ('dbx_business_glossary_term' = 'Attribution Model Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `model_status` SET TAGS ('dbx_business_glossary_term' = 'Attribution Model Status');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `model_status` SET TAGS ('dbx_value_regex' = 'active|inactive|draft|archived|deprecated');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `model_type` SET TAGS ('dbx_business_glossary_term' = 'Attribution Model Type');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `model_version` SET TAGS ('dbx_business_glossary_term' = 'Attribution Model Version');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `model_version` SET TAGS ('dbx_value_regex' = '^v[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ALTER COLUMN `reporting_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` SET TAGS ('dbx_subdomain' = 'audience_intelligence');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `attribution_model_id` SET TAGS ('dbx_business_glossary_term' = 'Attribution Model Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `conversion_modified_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `web_session_id` SET TAGS ('dbx_business_glossary_term' = 'Session ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `conversion_event_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `conversion_page_url` SET TAGS ('dbx_business_glossary_term' = 'Conversion Page URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `conversion_status` SET TAGS ('dbx_value_regex' = 'completed|pending|cancelled|reversed|failed');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `conversion_type` SET TAGS ('dbx_value_regex' = 'purchase|sign_up|loyalty_enrollment|app_install|bopis_order|email_subscription');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `device_type` SET TAGS ('dbx_value_regex' = 'desktop|mobile|tablet|smart_tv|wearable|other');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `geographic_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `is_new_customer` SET TAGS ('dbx_business_glossary_term' = 'Is New Customer Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `is_omnichannel` SET TAGS ('dbx_business_glossary_term' = 'Is Omnichannel Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `landing_page_url` SET TAGS ('dbx_business_glossary_term' = 'Landing Page URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `referrer_url` SET TAGS ('dbx_business_glossary_term' = 'Referrer URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `revenue_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `utm_campaign` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Campaign');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `utm_content` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Content');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `utm_medium` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Medium');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `utm_source` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Source');
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ALTER COLUMN `utm_term` SET TAGS ('dbx_business_glossary_term' = 'UTM (Urchin Tracking Module) Term');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` SET TAGS ('dbx_subdomain' = 'brand_partnerships');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `marketing_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Brand ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `marketing_modified_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `primary_marketing_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Owner ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'not_submitted|pending|approved|rejected|revision_requested');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `budget_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|active|closed|cancelled');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Budget Currency Code');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Budget End Date');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `events_sponsorship_budget` SET TAGS ('dbx_business_glossary_term' = 'Events and Sponsorship Budget');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = 'national|regional|local|international|global');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Budget Notes');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `search_engine_marketing_budget` SET TAGS ('dbx_business_glossary_term' = 'Search Engine Marketing (SEM) Budget');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Budget Start Date');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `target_roi_percentage` SET TAGS ('dbx_business_glossary_term' = 'Target Return on Investment (ROI) Percentage');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ALTER COLUMN `utilization_percentage` SET TAGS ('dbx_business_glossary_term' = 'Budget Utilization Percentage');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` SET TAGS ('dbx_subdomain' = 'brand_partnerships');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Employee ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `marketing_modified_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By Employee ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `primary_marketing_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Brand Manager ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `accent_color_hex` SET TAGS ('dbx_business_glossary_term' = 'Accent Color Hex Code');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `accent_color_hex` SET TAGS ('dbx_value_regex' = '^#[0-9A-Fa-f]{6}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `brand_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `brand_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_launch|discontinued|under_review|sunset');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `brand_tier` SET TAGS ('dbx_value_regex' = 'premium|mid_tier|value|economy');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `brand_type` SET TAGS ('dbx_value_regex' = 'national_banner|private_label|sub_brand|co_brand|licensed_brand|exclusive_brand');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `discontinuation_date` SET TAGS ('dbx_business_glossary_term' = 'Brand Discontinuation Date');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `equity_score` SET TAGS ('dbx_business_glossary_term' = 'Brand Equity Score');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = 'global|regional|national|local');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `guidelines_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Brand Guidelines Document Reference');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `health_tracking_status` SET TAGS ('dbx_business_glossary_term' = 'Brand Health Tracking Status');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `health_tracking_status` SET TAGS ('dbx_value_regex' = 'tracked|not_tracked|paused');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `is_omnichannel` SET TAGS ('dbx_business_glossary_term' = 'Is Omnichannel Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `is_sustainable_brand` SET TAGS ('dbx_business_glossary_term' = 'Is Sustainable Brand Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `launch_date` SET TAGS ('dbx_business_glossary_term' = 'Brand Launch Date');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `net_promoter_score` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `positioning_statement` SET TAGS ('dbx_business_glossary_term' = 'Brand Positioning Statement');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `primary_color_hex` SET TAGS ('dbx_business_glossary_term' = 'Primary Color Hex Code');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `primary_color_hex` SET TAGS ('dbx_value_regex' = '^#[0-9A-Fa-f]{6}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `secondary_color_hex` SET TAGS ('dbx_business_glossary_term' = 'Secondary Color Hex Code');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `secondary_color_hex` SET TAGS ('dbx_value_regex' = '^#[0-9A-Fa-f]{6}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `tagline` SET TAGS ('dbx_business_glossary_term' = 'Brand Tagline');
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'Brand Website URL');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` SET TAGS ('dbx_subdomain' = 'brand_partnerships');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Channel ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `channel_modified_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `api_authentication_method` SET TAGS ('dbx_business_glossary_term' = 'API (Application Programming Interface) Authentication Method');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `api_authentication_method` SET TAGS ('dbx_value_regex' = 'oauth|api_key|basic_auth|saml|none');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `api_endpoint_url` SET TAGS ('dbx_business_glossary_term' = 'API (Application Programming Interface) Endpoint URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `average_cpa_amount` SET TAGS ('dbx_business_glossary_term' = 'Average Cost Per Acquisition (CPA) Amount');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `average_cpc_amount` SET TAGS ('dbx_business_glossary_term' = 'Average Cost Per Click (CPC) Amount');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `average_cpm_amount` SET TAGS ('dbx_business_glossary_term' = 'Average Cost Per Mille (CPM) Amount');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `channel_category` SET TAGS ('dbx_value_regex' = 'owned|earned|paid');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `channel_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `cost_model` SET TAGS ('dbx_value_regex' = 'cpm|cpc|cpa|flat|hybrid|performance');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `data_refresh_frequency` SET TAGS ('dbx_value_regex' = 'real_time|hourly|daily|weekly|manual');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `integration_status` SET TAGS ('dbx_value_regex' = 'integrated|pending|not_integrated|deprecated');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Active Status Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `owner_email` SET TAGS ('dbx_business_glossary_term' = 'Channel Owner Email Address');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `owner_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `owner_name` SET TAGS ('dbx_business_glossary_term' = 'Channel Owner Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `platform_vendor_name` SET TAGS ('dbx_business_glossary_term' = 'Platform or Vendor Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `primary_kpi` SET TAGS ('dbx_business_glossary_term' = 'Primary KPI (Key Performance Indicator)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `supports_ab_testing` SET TAGS ('dbx_business_glossary_term' = 'Supports A/B Testing Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `supports_automation` SET TAGS ('dbx_business_glossary_term' = 'Supports Automation Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ALTER COLUMN `supports_personalization` SET TAGS ('dbx_business_glossary_term' = 'Supports Personalization Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` SET TAGS ('dbx_subdomain' = 'media_execution');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `utm_parameter_id` SET TAGS ('dbx_business_glossary_term' = 'Urchin Tracking Module (UTM) Parameter ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Channel Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `tertiary_utm_approved_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `base_url` SET TAGS ('dbx_business_glossary_term' = 'Base Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `full_tagged_url` SET TAGS ('dbx_business_glossary_term' = 'Full Tagged Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Active Status Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modification Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Configuration Notes');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `parameter_code` SET TAGS ('dbx_business_glossary_term' = 'UTM Parameter Configuration Code');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `parameter_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `parameter_name` SET TAGS ('dbx_business_glossary_term' = 'UTM Parameter Configuration Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `parameter_status` SET TAGS ('dbx_business_glossary_term' = 'UTM Parameter Configuration Status');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `parameter_status` SET TAGS ('dbx_value_regex' = 'active|inactive|draft|archived|deprecated');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `short_url` SET TAGS ('dbx_business_glossary_term' = 'Short Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `taxonomy_version` SET TAGS ('dbx_business_glossary_term' = 'UTM Taxonomy Version');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `usage_count` SET TAGS ('dbx_business_glossary_term' = 'UTM Parameter Usage Count');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `utm_campaign` SET TAGS ('dbx_business_glossary_term' = 'Urchin Tracking Module (UTM) Campaign');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `utm_content` SET TAGS ('dbx_business_glossary_term' = 'Urchin Tracking Module (UTM) Content');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `utm_medium` SET TAGS ('dbx_business_glossary_term' = 'Urchin Tracking Module (UTM) Medium');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `utm_source` SET TAGS ('dbx_business_glossary_term' = 'Urchin Tracking Module (UTM) Source');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `utm_term` SET TAGS ('dbx_business_glossary_term' = 'Urchin Tracking Module (UTM) Term');
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ALTER COLUMN `validation_status` SET TAGS ('dbx_value_regex' = 'valid|invalid|pending_review|requires_correction');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` SET TAGS ('dbx_subdomain' = 'campaign_planning');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `ab_test_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'A/B Test Campaign ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `ab_modified_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Channel Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `creative_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Creative Asset Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `primary_ab_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Test Owner ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `sku_price_id` SET TAGS ('dbx_business_glossary_term' = 'Test Sku Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `confidence_level_pct` SET TAGS ('dbx_business_glossary_term' = 'Confidence Level Percentage');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `control_audience_split_pct` SET TAGS ('dbx_business_glossary_term' = 'Control Audience Split Percentage');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `hypothesis` SET TAGS ('dbx_business_glossary_term' = 'Test Hypothesis');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `lift_pct` SET TAGS ('dbx_business_glossary_term' = 'Lift Percentage');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `primary_success_metric` SET TAGS ('dbx_value_regex' = 'open_rate|click_through_rate|conversion_rate|revenue|engagement_rate|unsubscribe_rate');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `statistical_significance_threshold_pct` SET TAGS ('dbx_business_glossary_term' = 'Statistical Significance Threshold Percentage');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `test_audience_split_pct` SET TAGS ('dbx_business_glossary_term' = 'Test Audience Split Percentage');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `test_status` SET TAGS ('dbx_value_regex' = 'draft|scheduled|running|completed|cancelled|paused');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `test_type` SET TAGS ('dbx_value_regex' = 'subject_line|creative_variant|send_time|audience_split|channel_mix|landing_page');
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ALTER COLUMN `winning_variant` SET TAGS ('dbx_value_regex' = 'control|test|inconclusive');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` SET TAGS ('dbx_subdomain' = 'content_delivery');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ALTER COLUMN `automation_flow_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Automation Flow ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Owner ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ALTER COLUMN `automation_created_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ALTER COLUMN `automation_modified_by_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ALTER COLUMN `flow_status` SET TAGS ('dbx_value_regex' = 'draft|active|paused|completed|archived');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ALTER COLUMN `flow_type` SET TAGS ('dbx_value_regex' = 'triggered|scheduled|recurring|one_time|event_based|behavioral');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ALTER COLUMN `platform_flow_code` SET TAGS ('dbx_business_glossary_term' = 'Platform Flow ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ALTER COLUMN `primary_channel` SET TAGS ('dbx_value_regex' = 'email|sms|push|in_app|direct_mail|webhook');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` SET TAGS ('dbx_subdomain' = 'content_delivery');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ALTER COLUMN `audience_segment_id` SET TAGS ('dbx_business_glossary_term' = 'Segment ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ALTER COLUMN `consent_status` SET TAGS ('dbx_value_regex' = 'granted|withdrawn|pending|expired');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ALTER COLUMN `conversion_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ALTER COLUMN `enrollment_channel` SET TAGS ('dbx_value_regex' = 'email|sms|push|in_app|web|multi_channel');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ALTER COLUMN `enrollment_source` SET TAGS ('dbx_value_regex' = 'api|web_form|manual|batch_import|event_trigger|segment_refresh');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ALTER COLUMN `enrollment_status` SET TAGS ('dbx_value_regex' = 'active|paused|completed|exited|suppressed|failed');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'high|medium|low|urgent');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` SET TAGS ('dbx_subdomain' = 'brand_partnerships');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `opt_in_record_id` SET TAGS ('dbx_business_glossary_term' = 'Opt-In Record Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Channel Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `opt_modified_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `can_spam_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'CAN-SPAM Compliant Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `ccpa_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'California Consumer Privacy Act (CCPA) Compliant Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `double_opt_in_confirmation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Double Opt-In Confirmation Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `double_opt_in_flag` SET TAGS ('dbx_business_glossary_term' = 'Double Opt-In Confirmation Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `frequency_preference` SET TAGS ('dbx_business_glossary_term' = 'Communication Frequency Preference');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `frequency_preference` SET TAGS ('dbx_value_regex' = 'daily|weekly|biweekly|monthly|quarterly|as_needed');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `gdpr_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'General Data Protection Regulation (GDPR) Compliant Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `ip_address` SET TAGS ('dbx_business_glossary_term' = 'Internet Protocol (IP) Address');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `language_preference` SET TAGS ('dbx_value_regex' = '^[a-z]{2}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `opt_in_source` SET TAGS ('dbx_business_glossary_term' = 'Opt-In Source');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `opt_in_status` SET TAGS ('dbx_business_glossary_term' = 'Opt-In Status');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `opt_in_status` SET TAGS ('dbx_value_regex' = 'opted_in|opted_out|pending|expired|suppressed');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `opt_in_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Opt-In Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `opt_out_method` SET TAGS ('dbx_business_glossary_term' = 'Opt-Out Method');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `opt_out_reason` SET TAGS ('dbx_business_glossary_term' = 'Opt-Out Reason');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `opt_out_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Opt-Out Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `suppression_list_flag` SET TAGS ('dbx_business_glossary_term' = 'Suppression List Membership Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `tcpa_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'Telephone Consumer Protection Act (TCPA) Compliant Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `third_party_consent_date` SET TAGS ('dbx_business_glossary_term' = 'Third-Party Consent Date');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `third_party_source_name` SET TAGS ('dbx_business_glossary_term' = 'Third-Party Source Name');
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ALTER COLUMN `user_agent` SET TAGS ('dbx_business_glossary_term' = 'User Agent String');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` SET TAGS ('dbx_subdomain' = 'campaign_planning');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `attribution_model_id` SET TAGS ('dbx_business_glossary_term' = 'Attribution Model Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `channel_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Channel Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `financial_period_id` SET TAGS ('dbx_business_glossary_term' = 'Financial Period Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `price_strategy_id` SET TAGS ('dbx_business_glossary_term' = 'Price Strategy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `conversion_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Conversion Rate (CR) Percent');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `cpa_amount` SET TAGS ('dbx_business_glossary_term' = 'Cost Per Acquisition (CPA) Amount');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `cpc_amount` SET TAGS ('dbx_business_glossary_term' = 'Cost Per Click (CPC) Amount');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `cpm_amount` SET TAGS ('dbx_business_glossary_term' = 'Cost Per Mille (CPM) Amount');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `ctr_percent` SET TAGS ('dbx_business_glossary_term' = 'Click-Through Rate (CTR) Percent');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Performance Notes');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `performance_status` SET TAGS ('dbx_value_regex' = 'active|paused|completed|cancelled');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `reporting_period_type` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|quarterly');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `revenue_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `roas_ratio` SET TAGS ('dbx_business_glossary_term' = 'Return on Ad Spend (ROAS) Ratio');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ALTER COLUMN `spend_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` SET TAGS ('dbx_subdomain' = 'media_execution');
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ALTER COLUMN `marketing_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Brand ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ALTER COLUMN `primary_agency_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ALTER COLUMN `agency_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Agency Contact Email Address');
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ALTER COLUMN `agency_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ALTER COLUMN `agency_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Agency Contact Phone Number');
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ALTER COLUMN `agency_type` SET TAGS ('dbx_value_regex' = 'creative|media|digital|pr|influencer|social_media');
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ALTER COLUMN `brief_number` SET TAGS ('dbx_business_glossary_term' = 'Brief Reference Number');
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|urgent');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_deployment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_deployment` SET TAGS ('dbx_subdomain' = 'campaign_planning');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_deployment` SET TAGS ('dbx_association_edges' = 'marketing.campaign,ecommerce.storefront');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_deployment` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Deployment - Campaign Id');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_deployment` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Deployment - Storefront Id');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` SET TAGS ('dbx_subdomain' = 'campaign_planning');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` SET TAGS ('dbx_association_edges' = 'marketing.campaign,supplychain.dc_facility');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` ALTER COLUMN `campaign_fulfillment_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Fulfillment Assignment Identifier');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Fulfillment - Campaign Id');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Fulfillment - Dc Facility Id');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` ALTER COLUMN `campaign_end_date` SET TAGS ('dbx_business_glossary_term' = 'Campaign End Date at Facility');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` ALTER COLUMN `campaign_start_date` SET TAGS ('dbx_business_glossary_term' = 'Campaign Start Date at Facility');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Assignment Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` ALTER COLUMN `fulfillment_sla_hours` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Service Level Agreement Hours');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` ALTER COLUMN `priority_rank` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Priority Rank');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Assignment Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` SET TAGS ('dbx_subdomain' = 'campaign_planning');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` SET TAGS ('dbx_association_edges' = 'marketing.campaign,compliance.policy');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ALTER COLUMN `campaign_policy_compliance_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Policy Compliance Identifier');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Identifier');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ALTER COLUMN `policy_id` SET TAGS ('dbx_business_glossary_term' = 'Policy Identifier');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Reviewer Associate Identifier');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ALTER COLUMN `acknowledgment_date` SET TAGS ('dbx_business_glossary_term' = 'Policy Acknowledgment Date');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ALTER COLUMN `exception_expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Policy Exception Expiration Date');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ALTER COLUMN `exception_granted_flag` SET TAGS ('dbx_business_glossary_term' = 'Policy Exception Granted Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ALTER COLUMN `exception_justification` SET TAGS ('dbx_business_glossary_term' = 'Policy Exception Justification');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ALTER COLUMN `non_compliance_notes` SET TAGS ('dbx_business_glossary_term' = 'Non-Compliance Notes');
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Compliance Verification Date');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_step` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_step` SET TAGS ('dbx_subdomain' = 'content_delivery');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_step` ALTER COLUMN `automation_step_id` SET TAGS ('dbx_business_glossary_term' = 'Automation Step Identifier');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_step` ALTER COLUMN `email_template_id` SET TAGS ('dbx_classification' = 'restricted');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_step` ALTER COLUMN `email_template_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_step` ALTER COLUMN `sender_email` SET TAGS ('dbx_classification' = 'restricted');
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_step` ALTER COLUMN `sender_email` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_template` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_template` SET TAGS ('dbx_subdomain' = 'content_delivery');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_template` ALTER COLUMN `email_template_id` SET TAGS ('dbx_business_glossary_term' = 'Email Template Identifier');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_template` ALTER COLUMN `associate_id` SET TAGS ('dbx_classification' = 'restricted');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_template` ALTER COLUMN `associate_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_template` ALTER COLUMN `email_associate_id` SET TAGS ('dbx_classification' = 'confidential');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_template` ALTER COLUMN `email_associate_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_template` ALTER COLUMN `email_last_modified_by_user_associate_id` SET TAGS ('dbx_classification' = 'restricted');
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_template` ALTER COLUMN `email_last_modified_by_user_associate_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`marketing`.`publisher` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`publisher` SET TAGS ('dbx_subdomain' = 'media_execution');
ALTER TABLE `vibe_retail_v1`.`marketing`.`publisher` ALTER COLUMN `publisher_id` SET TAGS ('dbx_business_glossary_term' = 'Publisher Identifier');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` SET TAGS ('dbx_subdomain' = 'audience_intelligence');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `segment_id` SET TAGS ('dbx_business_glossary_term' = 'Segment Identifier');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Owner Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `price_strategy_id` SET TAGS ('dbx_business_glossary_term' = 'Price Strategy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `auto_refresh_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto-Refresh Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `average_aov` SET TAGS ('dbx_business_glossary_term' = 'Average Order Value (AOV)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `average_cltv` SET TAGS ('dbx_business_glossary_term' = 'Average Customer Lifetime Value (CLTV)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `b2b_b2c_indicator` SET TAGS ('dbx_business_glossary_term' = 'Business-to-Business (B2B) / Business-to-Consumer (B2C) Indicator');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `b2b_b2c_indicator` SET TAGS ('dbx_value_regex' = 'b2b|b2c|both');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `ccpa_opt_out_honored_flag` SET TAGS ('dbx_business_glossary_term' = 'California Consumer Privacy Act (CCPA) Opt-Out Honored Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `churn_risk_score` SET TAGS ('dbx_business_glossary_term' = 'Segment Churn Risk Score');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `segment_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Segment Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `discount_sensitivity` SET TAGS ('dbx_business_glossary_term' = 'Discount Sensitivity Level');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `discount_sensitivity` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Segment Effective End Date');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Segment Effective Start Date');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `gdpr_consent_required_flag` SET TAGS ('dbx_business_glossary_term' = 'General Data Protection Regulation (GDPR) Consent Required Flag');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Segment Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `last_refresh_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Segment Last Refresh Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `max_rfm_score` SET TAGS ('dbx_business_glossary_term' = 'Maximum Recency Frequency Monetary (RFM) Score');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `membership_count` SET TAGS ('dbx_business_glossary_term' = 'Segment Membership Count');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `min_rfm_score` SET TAGS ('dbx_business_glossary_term' = 'Minimum Recency Frequency Monetary (RFM) Score');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `nps_score` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS)');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `priority_tier` SET TAGS ('dbx_business_glossary_term' = 'Segment Priority Tier');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `priority_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `qualification_criteria` SET TAGS ('dbx_business_glossary_term' = 'Qualification Criteria Summary');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `refresh_frequency` SET TAGS ('dbx_business_glossary_term' = 'Segment Refresh Frequency');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `refresh_frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|quarterly|on_demand');
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ALTER COLUMN `segment_status` SET TAGS ('dbx_value_regex' = 'active|inactive|archived|draft');
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` SET TAGS ('dbx_subdomain' = 'audience_intelligence');
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` SET TAGS ('dbx_association_edges' = 'customer.profile,customer.segment');
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` ALTER COLUMN `customer_membership_id` SET TAGS ('dbx_business_glossary_term' = 'customer_membership Identifier');
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` ALTER COLUMN `segment_id` SET TAGS ('dbx_business_glossary_term' = 'Membership - Customer Segment Id');
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Membership Identifier');
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Membership - Profile Id');
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` ALTER COLUMN `customer_membership_status` SET TAGS ('dbx_business_glossary_term' = 'Membership Status');
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Membership End Date');
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` ALTER COLUMN `last_qualification_check_date` SET TAGS ('dbx_business_glossary_term' = 'Last Qualification Check Timestamp');
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` ALTER COLUMN `manual_override_flag` SET TAGS ('dbx_business_glossary_term' = 'Manual Override Indicator');
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Membership Start Date');
