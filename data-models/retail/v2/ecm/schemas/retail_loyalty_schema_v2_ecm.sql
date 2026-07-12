-- Schema for Domain: loyalty | Business:  | Version: v2_ecm
-- Generated on: 2026-07-12 13:53:23

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`loyalty` COMMENT 'Manages customer loyalty programs, membership tiers, points accrual and redemption, rewards catalogs, personalized offers, tier qualification rules, clienteling interaction records, and engagement campaigns. Tracks program enrollment, active members, points liability, and program ROI. Integrates with customer domain for unified customer view and supports omnichannel loyalty recognition across all touchpoints.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` (
    `loyalty_program_id` BIGINT COMMENT 'Unique identifier for the loyalty program. Primary key. Inferred role: MASTER_RESOURCE (loyalty program is a managed resource/offering). This entity represents a loyalty program offering operated by the retailer.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Retail loyalty programs must comply with consumer protection laws, promotional regulations, privacy laws, and financial liability rules. Compliance programs provide governance framework, audit schedul',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Loyalty programs require designated program managers (associates) for accountability, escalations, budget ownership, and performance tracking. Replaces denormalized program_manager_name with proper FK',
    `annual_fee_amount` DECIMAL(18,2) COMMENT 'Recurring annual membership fee for subscription-based loyalty programs. Zero for free programs.',
    `banner_affiliation` STRING COMMENT 'Retail banner or brand name this loyalty program is associated with. Supports multi-banner retailers operating distinct programs for different store formats (e.g., Hypermarket Rewards, Discount Club, Premium Grocery).',
    `charitable_donation_enabled` BOOLEAN COMMENT 'Indicates whether members can donate their earned points or rewards to charitable organizations through the loyalty program.',
    `cost_center_code` STRING COMMENT 'Financial cost center code to which loyalty program expenses (rewards liability, marketing, operations) are allocated for P&L reporting.. Valid values are `^[A-Z0-9]{4,12}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this loyalty program record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this program (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `customer_service_email` STRING COMMENT 'Dedicated customer service email address for loyalty program member inquiries and support requests.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `customer_service_phone` STRING COMMENT 'Dedicated customer service phone number for loyalty program member inquiries, support, and issue resolution.',
    `ecommerce_integration_enabled` BOOLEAN COMMENT 'Indicates whether the loyalty program is integrated with the retailers e-commerce platform for online member identification, points accrual, and redemption during digital checkout.',
    `end_date` DATE COMMENT 'Date when the loyalty program is scheduled to end or was retired. Null for ongoing programs.',
    `enrollment_eligibility_rule` STRING COMMENT 'Business rule defining who can enroll in the program (e.g., age 18+, US residents only, minimum purchase requirement, invitation only). Free-text description of eligibility criteria.',
    `enrollment_fee_amount` DECIMAL(18,2) COMMENT 'One-time fee charged to enroll in the loyalty program. Zero for free programs.',
    `gamification_enabled` BOOLEAN COMMENT 'Indicates whether the loyalty program incorporates gamification elements such as challenges, badges, leaderboards, or bonus point events to drive engagement.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this loyalty program record was last updated in the system.',
    `launch_date` DATE COMMENT 'Date when the loyalty program was officially launched and made available to customers for enrollment.',
    `mobile_app_enabled` BOOLEAN COMMENT 'Indicates whether the loyalty program has a dedicated mobile application or is accessible through the retailers mobile app for member self-service, digital card, and personalized offers.',
    `omnichannel_recognition_enabled` BOOLEAN COMMENT 'Indicates whether loyalty program benefits and points accrual are recognized across all customer touchpoints (in-store POS, e-commerce, mobile app, call center). True for unified omnichannel programs.',
    `partner_coalition_enabled` BOOLEAN COMMENT 'Indicates whether this loyalty program participates in a coalition with external partners (e.g., airlines, hotels, other retailers) allowing members to earn and redeem across multiple brands.',
    `personalization_engine_enabled` BOOLEAN COMMENT 'Indicates whether the loyalty program leverages AI/ML-driven personalization to deliver individualized offers, recommendations, and communications to members based on purchase history and behavior.',
    `points_currency_name` STRING COMMENT 'Name of the points currency used in this program (e.g., Rewards Points, Stars, Miles, Cash Back Dollars). Null for non-points programs.',
    `points_earn_rate` DECIMAL(18,2) COMMENT 'Base rate at which members earn points per unit of spend (e.g., 1.0 = 1 point per dollar, 0.5 = 1 point per 2 dollars). Null for non-points programs.',
    `points_expiry_duration_months` STRING COMMENT 'Number of months until points expire, applicable when points_expiry_policy is rolling_months or activity_based. Null for non-expiring programs.',
    `points_expiry_policy` STRING COMMENT 'Policy governing when earned points expire: never (no expiration), rolling_months (expire N months after earn date), calendar_year (expire end of year), fixed_date (expire on specific date), activity_based (expire if no activity for N months).. Valid values are `never|rolling_months|calendar_year|fixed_date|activity_based`',
    `points_redemption_rate` DECIMAL(18,2) COMMENT 'Base rate at which points convert to monetary value for redemption (e.g., 0.01 = 1 point = $0.01, 100 points = $1). Null for non-points programs.',
    `pos_integration_enabled` BOOLEAN COMMENT 'Indicates whether the loyalty program is integrated with in-store POS systems for real-time member identification, points accrual, and redemption at checkout.',
    `privacy_policy_url` STRING COMMENT 'URL to the privacy policy specific to the loyalty program, detailing how member data is collected, used, and protected.. Valid values are `^https?://.*$`',
    `program_code` STRING COMMENT 'Externally-known unique business identifier for the loyalty program (e.g., REWARDS_PLUS, GOLD_CLUB). Used in operational systems, customer communications, and integrations.. Valid values are `^[A-Z0-9_-]{3,20}$`',
    `program_description` STRING COMMENT 'Detailed description of the loyalty programs value proposition, benefits, and key features. Used for internal reference and customer-facing communications.',
    `program_name` STRING COMMENT 'Human-readable marketing name of the loyalty program displayed to customers (e.g., Rewards Plus, Gold Member Club, Everyday Savings).',
    `program_status` STRING COMMENT 'Current lifecycle status of the loyalty program: active (accepting enrollments and accruals), inactive (temporarily paused), suspended (enrollment closed but existing members active), planned (designed but not launched), retired (permanently closed).. Valid values are `active|inactive|suspended|planned|retired`',
    `program_type` STRING COMMENT 'Classification of the loyalty program structure: tiered (multiple membership levels with escalating benefits), points_based (earn and redeem points), cashback (percentage rebate), coalition (multi-retailer partnership), co_branded_card (linked to credit card), subscription (paid membership with benefits).. Valid values are `tiered|points_based|cashback|coalition|co_branded_card|subscription`',
    `referral_program_enabled` BOOLEAN COMMENT 'Indicates whether the loyalty program includes a member-get-member referral component where existing members earn rewards for referring new enrollees.',
    `target_customer_segment` STRING COMMENT 'Primary customer demographic or behavioral segment this loyalty program is designed to attract and retain (e.g., high-value shoppers, frequent buyers, millennials, grocery-focused).',
    `terms_and_conditions_url` STRING COMMENT 'URL to the official terms and conditions document governing the loyalty program, including member rights, obligations, and program rules.. Valid values are `^https?://.*$`',
    `tier_evaluation_period` STRING COMMENT 'Time window over which tier qualification is evaluated: calendar_year (Jan-Dec), rolling_12_months (trailing 12 months), program_year (anniversary-based), lifetime (cumulative since enrollment). Null for non-tiered programs.. Valid values are `calendar_year|rolling_12_months|program_year|lifetime`',
    `tier_qualification_metric` STRING COMMENT 'Primary metric used to qualify members for tier advancement: annual_spend (total dollars spent), points_earned (total points accumulated), transaction_count (number of purchases), hybrid (combination of metrics). Null for non-tiered programs.. Valid values are `annual_spend|points_earned|transaction_count|hybrid`',
    `tier_structure_enabled` BOOLEAN COMMENT 'Indicates whether this loyalty program has a tiered membership structure with multiple levels (e.g., Silver, Gold, Platinum). True for tiered programs, false for flat programs.',
    CONSTRAINT pk_loyalty_program PRIMARY KEY(`loyalty_program_id`)
) COMMENT 'Master record for each customer loyalty program operated by the retailer (e.g., tiered rewards club, co-branded credit card program, coalition program). Captures program name, type, enrollment rules, points currency definition, expiry policy, program status, launch/end dates, and omnichannel recognition configuration. SSOT for loyalty program definitions referenced by all downstream entities (membership, tiers, rules, rewards, campaigns). Supports multi-program retailers operating distinct programs for different banners or customer segments.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` (
    `loyalty_membership_id` BIGINT COMMENT 'Unique identifier for the loyalty program membership. Primary key.',
    `tier_id` BIGINT COMMENT 'Foreign key linking to loyalty.tier. Business justification: Critical normalization opportunity. membership.current_tier is currently a STRING field (likely storing tier code or name). This should be normalized to a FK to tier.tier_id. The tier table is the aut',
    `loyalty_program_id` BIGINT COMMENT 'Reference to the loyalty program this membership belongs to. Supports multiple program structures.',
    `location_id` BIGINT COMMENT 'Store location where the customer enrolled, if enrollment occurred in-store. Null for digital enrollments.',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Members enroll and transact through specific digital storefronts; tracking primary storefront enables channel-specific loyalty offers, omnichannel recognition, and storefront-level member segmentation',
    `profile_id` BIGINT COMMENT 'Reference to the customer who holds this membership. Links to the customer domain for unified customer view.',
    `referred_by_member_loyalty_membership_id` BIGINT COMMENT 'Reference to the member who referred this customer to the loyalty program. Null if not a referral enrollment.',
    `anniversary_date` DATE COMMENT 'Annual anniversary date of membership enrollment. Used for anniversary campaigns and special offers.',
    `closed_date` DATE COMMENT 'Date when the membership was permanently closed or terminated. Null for active, suspended, or lapsed memberships.',
    `closed_reason` STRING COMMENT 'Reason code or description for membership closure. Examples: customer_request, fraud, terms_violation, duplicate_account, deceased.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the membership record was first created in the system. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Currency in which points value and spend amounts are tracked for this membership. Three-letter ISO 4217 currency code. [ENUM-REF-CANDIDATE: USD|EUR|GBP|CAD|AUD|JPY|CNY|INR|BRL|MXN — 10 candidates stripped; promote to reference product]',
    `current_points_balance` DECIMAL(18,2) COMMENT 'Current available points balance that can be redeemed. Calculated as lifetime earned minus lifetime redeemed minus expired points.',
    `enrollment_channel` STRING COMMENT 'Channel through which the customer enrolled in the loyalty program. Supports omnichannel enrollment tracking and channel effectiveness analysis. [ENUM-REF-CANDIDATE: in_store|online|mobile_app|call_center|referral|partner|social_media — 7 candidates stripped; promote to reference product]',
    `enrollment_date` DATE COMMENT 'Date when the customer enrolled in the loyalty program. Used for tenure analysis and anniversary campaigns.',
    `fraud_flag` BOOLEAN COMMENT 'Indicates whether the membership has been flagged for suspected fraudulent activity. Used for risk management and account review.',
    `language_preference` STRING COMMENT 'Preferred language for loyalty program communications. Three-letter ISO 639-2 language code. [ENUM-REF-CANDIDATE: ENG|SPA|FRA|GER|CHI|JPN|KOR|ARA|POR|RUS — 10 candidates stripped; promote to reference product]',
    `last_activity_date` DATE COMMENT 'Date of the most recent member activity (purchase, points redemption, offer engagement, or interaction). Used for lapse risk scoring and reactivation targeting.',
    `last_purchase_date` DATE COMMENT 'Date of the most recent purchase transaction by the member. Used for recency analysis and churn prediction.',
    `last_redemption_date` DATE COMMENT 'Date of the most recent points redemption by the member. Used for engagement analysis and redemption behavior tracking.',
    `lifetime_points_earned` DECIMAL(18,2) COMMENT 'Total points earned by the member since enrollment. Includes base points, bonus points, and promotional points. Used for tier qualification and CLTV (Customer Lifetime Value) analysis.',
    `lifetime_points_redeemed` DECIMAL(18,2) COMMENT 'Total points redeemed by the member since enrollment. Used for engagement analysis and points liability tracking.',
    `member_number` STRING COMMENT 'Externally visible unique member identifier used for program recognition across all touchpoints (POS, e-commerce, mobile app). Customer-facing identifier.',
    `membership_status` STRING COMMENT 'Current lifecycle status of the membership. Active members can earn and redeem points; suspended members are temporarily blocked; lapsed members have not engaged within retention window; closed memberships are permanently terminated.. Valid values are `active|suspended|lapsed|closed|pending`',
    `next_expiry_date` DATE COMMENT 'Date when the next batch of points will expire. Null if no points are set to expire.',
    `opt_in_direct_mail` BOOLEAN COMMENT 'Indicates whether the member has opted in to receive loyalty program communications via postal mail.',
    `opt_in_email` BOOLEAN COMMENT 'Indicates whether the member has opted in to receive loyalty program communications via email.',
    `opt_in_push` BOOLEAN COMMENT 'Indicates whether the member has opted in to receive loyalty program push notifications via mobile app.',
    `opt_in_sms` BOOLEAN COMMENT 'Indicates whether the member has opted in to receive loyalty program communications via SMS text messages.',
    `points_expiring_soon` DECIMAL(18,2) COMMENT 'Points balance that will expire within the next 90 days. Used for expiration reminder campaigns and urgency messaging.',
    `referral_code` STRING COMMENT 'Unique referral code assigned to this member for referring new customers to the loyalty program. Used in member-get-member campaigns.',
    `status_effective_date` DATE COMMENT 'Date when the current membership status became effective. Used for status duration analysis and reactivation campaigns.',
    `status_reason` STRING COMMENT 'Reason code or description for the current membership status. Examples: fraud_detected, customer_request, inactivity, terms_violation.',
    `tier_expiry_date` DATE COMMENT 'Date when the current tier status expires and re-qualification is required. Null for lifetime tiers.',
    `tier_qualification_date` DATE COMMENT 'Date when the member qualified for their current tier. Used for tier tenure tracking and re-qualification calculations.',
    `total_spend_amount` DECIMAL(18,2) COMMENT 'Total monetary value of all purchases by the member since enrollment. Used for monetary analysis, tier qualification, and CLTV (Customer Lifetime Value) calculation.',
    `total_transactions` STRING COMMENT 'Total number of purchase transactions completed by the member since enrollment. Used for frequency analysis and tier qualification.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the membership record was last modified. Used for audit trail and change tracking.',
    `vip_flag` BOOLEAN COMMENT 'Indicates whether the member is designated as a VIP for special treatment, exclusive access, and personalized service (clienteling).',
    CONSTRAINT pk_loyalty_membership PRIMARY KEY(`loyalty_membership_id`)
) COMMENT 'Represents an individual customers active enrollment in a loyalty program. Captures member number, enrollment date, enrollment channel (in-store, online, mobile, referral), current tier, tier qualification date, tier expiry date, previous tier (for downgrade tracking), membership status (active, suspended, lapsed, closed), opt-in preferences, linked customer reference, lifetime points earned, lifetime points redeemed, and tier change history summary. One customer may have memberships across multiple programs. Serves as the anchor entity for all member-level activity — points, redemptions, offers, interactions, and referrals link back here.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`tier` (
    `tier_id` BIGINT COMMENT 'Unique identifier for the loyalty program tier. Primary key.',
    `loyalty_program_id` BIGINT COMMENT 'Reference to the parent loyalty program to which this tier belongs. A loyalty program may have multiple tiers (e.g., Silver, Gold, Platinum).',
    `prior_tier_id` BIGINT COMMENT 'add column prior_tier_id (BIGINT) with FK to loyalty.tier.tier_id - tiers have a natural progression order that should be explicitly modeled for tier qualification logic',
    `badge_color` STRING COMMENT 'Hex color code or color name for the tier badge displayed in digital channels and physical membership cards (e.g., #C0C0C0 for Silver, #FFD700 for Gold, #E5E4E2 for Platinum, #B9F2FF for Diamond).',
    `badge_icon_url` STRING COMMENT 'URL to the digital asset (icon or badge image) representing this tier in mobile apps, websites, and digital communications.',
    `benefits_summary` STRING COMMENT 'Textual summary of key benefits and privileges associated with this tier (e.g., free shipping, priority customer service, exclusive access to sales, birthday rewards, concierge service). Used for customer communication and marketing.',
    `tier_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the tier within the program (e.g., SILVER, GOLD, PLAT, DIAM). Used for system integration and reporting.. Valid values are `^[A-Z0-9_]{2,20}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this tier record was first created in the system. Used for audit trail and data lineage tracking.',
    `display_order` STRING COMMENT 'Sequence number controlling the display order of tiers in customer-facing interfaces (websites, mobile apps, marketing materials). Lower numbers appear first.',
    `downgrade_rule_description` STRING COMMENT 'Textual description of the rules and conditions under which a customer is downgraded from this tier (e.g., automatic if maintenance threshold not met, grace period of 3 months, no downgrades for lifetime tiers).',
    `effective_end_date` DATE COMMENT 'Date after which this tier definition is no longer active for new qualifications. Null indicates the tier is currently active with no planned end date. Existing members may retain status beyond this date per program rules.',
    `effective_start_date` DATE COMMENT 'Date from which this tier definition becomes active and available for customer qualification. Used for managing tier launches and program changes.',
    `grace_period_months` STRING COMMENT 'Number of months a customer retains tier status after failing to meet maintenance threshold before being downgraded. Null if no grace period is offered.',
    `invitation_only_flag` BOOLEAN COMMENT 'Indicates whether this tier is available only by invitation from the company (True) or can be achieved through standard qualification rules (False). Typically used for ultra-premium or VIP tiers.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this tier record was most recently updated. Used for change tracking and audit purposes.',
    `lifetime_tier_flag` BOOLEAN COMMENT 'Indicates whether this tier, once achieved, is retained for the customers lifetime regardless of future activity (True) or is subject to periodic review and potential downgrade (False).',
    `maintenance_period_months` STRING COMMENT 'Number of months over which the maintenance threshold must be met to retain tier status (e.g., 12 for annual review). Null if no maintenance requirement.',
    `maintenance_threshold_value` DECIMAL(18,2) COMMENT 'Numeric value a customer must achieve to maintain this tier after initial qualification. Often lower than qualification threshold to encourage retention. Null if maintenance equals qualification.',
    `marketing_description` STRING COMMENT 'Extended marketing copy describing the tiers value proposition, benefits, and aspirational messaging. Used in promotional materials, program brochures, and enrollment campaigns.',
    `tier_name` STRING COMMENT 'Human-readable name of the loyalty tier displayed to customers (e.g., Silver Member, Gold Member, Platinum Elite, Diamond VIP).',
    `points_earning_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to base points earning rate for members of this tier (e.g., 1.0 for base tier, 1.5 for Gold, 2.0 for Platinum). Higher tiers earn points faster.',
    `points_redemption_discount_pct` DECIMAL(18,2) COMMENT 'Percentage discount applied to points required for redemption rewards for this tier (e.g., 0 for base tier, 10 for Gold means 10% fewer points needed, 20 for Platinum). Enhances redemption value for premium tiers.',
    `qualification_period_months` STRING COMMENT 'Number of months over which the qualification threshold must be met (e.g., 12 for annual qualification, 3 for quarterly). Null indicates lifetime qualification.',
    `qualification_threshold_type` STRING COMMENT 'The metric used to determine tier qualification: spend (total monetary spend), points (loyalty points earned), transactions (number of purchases), or hybrid (combination of multiple metrics).. Valid values are `spend|points|transactions|hybrid`',
    `qualification_threshold_value` DECIMAL(18,2) COMMENT 'Numeric value a customer must achieve to qualify for this tier (e.g., $5000 annual spend, 10000 points earned, 50 transactions). Interpretation depends on qualification_threshold_type.',
    `rank` STRING COMMENT 'Ordinal ranking of the tier within the loyalty program hierarchy. Lower numbers indicate entry-level tiers; higher numbers indicate premium tiers (e.g., 1=Silver, 2=Gold, 3=Platinum, 4=Diamond).',
    `terms_and_conditions_url` STRING COMMENT 'URL to the legal terms and conditions document governing this tiers benefits, qualification rules, and member obligations.',
    `tier_status` STRING COMMENT 'Current lifecycle status of the tier. Active tiers are available for customer enrollment and qualification; inactive tiers are no longer offered but may have legacy members; deprecated tiers are being phased out; planned tiers are under development.. Valid values are `active|inactive|deprecated|planned`',
    `upgrade_rule_description` STRING COMMENT 'Textual description of the rules and conditions under which a customer is upgraded to this tier (e.g., automatic upon reaching threshold, manual review required, invitation-only for top tier).',
    CONSTRAINT pk_tier PRIMARY KEY(`tier_id`)
) COMMENT 'Reference master defining the qualification tiers within a loyalty program (e.g., Silver, Gold, Platinum, Diamond). Captures tier name, tier rank/order, qualification threshold (spend or points), maintenance threshold, tier benefits summary, tier badge color, upgrade rules, downgrade rules, and tier validity period. Owned by the loyalty domain as the authoritative tier taxonomy.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` (
    `points_ledger_id` BIGINT COMMENT 'Unique identifier for each points ledger entry. Primary key for the immutable append-only ledger.',
    `accrual_rule_id` BIGINT COMMENT 'Foreign key linking to loyalty.accrual_rule. Business justification: Points ledger entries of type earn should reference which accrual rule generated the points. This is critical for audit trail, analytics (which rules drive the most engagement), and dispute resoluti',
    `associate_id` BIGINT COMMENT 'Reference to the employee who processed the transaction or manual adjustment. Null for automated system transactions. Used for customer service audit and clienteling attribution.',
    `campaign_id` BIGINT COMMENT 'Reference to the targeted engagement or marketing campaign that triggered this points transaction. Null for organic transactions. Enables campaign effectiveness measurement.',
    `cart_id` BIGINT COMMENT 'Foreign key linking to ecommerce.cart. Business justification: Points redemption can occur at cart level before order placement; tracking cart enables pre-order points reservation, cart abandonment recovery with points incentives, and real-time points balance upd',
    `header_id` BIGINT COMMENT 'Reference to the e-commerce or omnichannel order that generated this points transaction. Null for in-store POS transactions not linked to an order. Enables order-to-loyalty reconciliation.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Points accrual creates financial liability that must be recorded in specific GL accounts (typically deferred revenue or loyalty liability accounts). Every points transaction requires GL account mappin',
    `location_id` BIGINT COMMENT 'Reference to the physical store location where the transaction occurred. Null for online, mobile, or partner channels. Used for store-level loyalty performance reporting.',
    `loyalty_membership_id` BIGINT COMMENT 'FK to loyalty.membership.membership_id — Points ledger to membership is the core loyalty accounting join. Every points balance inquiry, tier qualification check, and loyalty statement requires this link.',
    `partner_transaction_id` BIGINT COMMENT 'Foreign key linking to loyalty.partner_transaction. Business justification: Points earned or redeemed through coalition partners should reference the partner_transaction record. Currently points_ledger has a generic partner_id field, but linking to the specific partner_transa',
    `points_loyalty_membership_id` BIGINT COMMENT 'Reference to the loyalty membership account for which this points transaction was recorded.',
    `pos_transaction_id` BIGINT COMMENT 'Foreign key linking to order.pos_transaction. Business justification: Majority of loyalty points are earned at POS; direct link enables real-time posting, receipt printing with earned points, POS-loyalty reconciliation, and audit trail for in-store transactions.',
    `promo_offer_id` BIGINT COMMENT 'Reference to the marketing promotion or campaign that triggered bonus points or special earn rate. Null for standard earn transactions. Supports promotion ROI analysis.',
    `redemption_id` BIGINT COMMENT 'Foreign key linking to loyalty.redemption. Business justification: Critical reconciliation link. When a redemption occurs, it generates a points_ledger entry (debit). The ledger should reference the redemption transaction for full traceability. Currently points_ledge',
    `redemption_rule_id` BIGINT COMMENT 'Foreign key linking to loyalty.redemption_rule. Business justification: Points ledger entries of type redeem should reference which redemption rule was applied. Parallel to accrual_rule_id, this enables audit trail for rule enforcement, compliance reporting, and analyti',
    `reversal_reference_points_ledger_id` BIGINT COMMENT 'Points ledger ID of the original transaction being reversed. Populated only for transaction_type = reversal. Creates audit trail linking correction to original entry.',
    `adjustment_reason` STRING COMMENT 'Free-text explanation for manual points adjustments. Populated only for transaction_type = adjust. Provides business context for non-standard transactions requiring audit trail.',
    `base_currency_amount` DECIMAL(18,2) COMMENT 'Monetary value in base currency (USD, EUR, etc.) that generated the points earn. Used to calculate points-per-dollar ratio and Customer Lifetime Value (CLTV). Null for non-purchase transactions.',
    `batch_number` STRING COMMENT 'Identifier for bulk processing batch if this transaction was part of a batch operation (e.g., monthly expiration run, partner file import). Null for real-time individual transactions.',
    `breakage_rate` DECIMAL(18,2) COMMENT 'Expected percentage of points that will never be redeemed (expire or go unused). Applied at transaction time for liability calculation. Expressed as decimal (e.g., 0.15 for 15% breakage).',
    `channel` STRING COMMENT 'Channel through which the points transaction was initiated: store (physical retail location), online (e-commerce website), mobile_app (branded mobile application), call_center (customer service phone interaction), partner (third-party loyalty partner), kiosk (self-service terminal).. Valid values are `store|online|mobile_app|call_center|partner|kiosk`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this ledger entry was created in the data platform. Distinct from transaction_timestamp which reflects the business event time. Used for data lineage and audit.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the base currency amount. Null if no monetary value is associated with the transaction.. Valid values are `^[A-Z]{3}$`',
    `earn_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to base earn rate for this transaction. Standard earn is 1.0, promotional or tier-based accelerators may be 2.0, 3.0, etc. Null for non-earn transactions.',
    `expiration_date` DATE COMMENT 'Date on which the points from this earn transaction will expire if not redeemed. Null for transactions that do not generate expiring points (redemptions, adjustments). Critical for points liability forecasting.',
    `is_promotional` BOOLEAN COMMENT 'Flag indicating whether this points transaction was part of a promotional or bonus program (True) or standard program rules (False). Used to segment promotional vs. organic points activity.',
    `new_tier` STRING COMMENT 'Loyalty membership tier after this transaction. Populated only for transaction_type = tier_qualify. Records the tier achieved through qualification event.',
    `notes` STRING COMMENT 'Optional free-text notes providing additional context for the transaction. Used for customer service annotations, special handling instructions, or audit clarifications.',
    `points_amount` DECIMAL(18,2) COMMENT 'Signed points value for this transaction. Positive for earn/bonus/transfer-in, negative for redeem/expire/transfer-out. Supports fractional points for partner conversions.',
    `points_liability_amount` DECIMAL(18,2) COMMENT 'Estimated monetary liability (in base currency) associated with the points in this transaction. Calculated using breakage-adjusted redemption value. Critical for ASC 606 deferred revenue accounting.',
    `previous_tier` STRING COMMENT 'Loyalty membership tier before this transaction. Populated only for transaction_type = tier_qualify. Captures tier transition history for member journey analysis.',
    `qualification_period_end` DATE COMMENT 'End date of the evaluation period used to assess tier qualification. Populated only for transaction_type = tier_qualify. Completes the qualification window definition.',
    `qualification_period_start` DATE COMMENT 'Start date of the evaluation period used to assess tier qualification. Populated only for transaction_type = tier_qualify. Defines the rolling window or calendar period for tier assessment.',
    `qualifying_points_amount` DECIMAL(18,2) COMMENT 'Total points earned that qualified the member for tier change. Populated only for transaction_type = tier_qualify. Alternative or complementary qualification metric to spend.',
    `qualifying_spend_amount` DECIMAL(18,2) COMMENT 'Total spend amount that qualified the member for tier change. Populated only for transaction_type = tier_qualify. Provides evidence for tier qualification audit.',
    `redemption_value_per_point` DECIMAL(18,2) COMMENT 'Estimated monetary value (in base currency) of one loyalty point at time of transaction. Used to calculate points liability. May vary by tier, promotion, or partner agreement.',
    `reversal_reason` STRING COMMENT 'Business reason for reversing a prior points transaction: return (product returned), cancellation (order cancelled), fraud (fraudulent activity detected), system_error (technical issue correction), customer_service (goodwill adjustment). Populated only for reversal transactions.. Valid values are `return|cancellation|fraud|system_error|customer_service`',
    `running_balance` DECIMAL(18,2) COMMENT 'Cumulative points balance for the membership after this transaction is applied. Provides snapshot of available points at this moment in time.',
    `source_reference_code` STRING COMMENT 'Identifier of the originating transaction or event in the source system. Links back to POS transaction ID, order number, promotion code, partner transaction ID, or adjustment ticket number for full audit trail.',
    `source_reference_type` STRING COMMENT 'Category of the originating business event that triggered this points transaction: pos_transaction (in-store purchase via Point of Sale), order (e-commerce or omnichannel order), promotion (marketing campaign or offer), partner (third-party loyalty partner activity), tier_evaluation (automated tier qualification assessment), manual_adjustment (customer service or program admin correction), campaign (targeted engagement initiative). [ENUM-REF-CANDIDATE: pos_transaction|order|promotion|partner|tier_evaluation|manual_adjustment|campaign — 7 candidates stripped; promote to reference product]',
    `transaction_status` STRING COMMENT 'Current status of the points transaction: posted (successfully recorded and balance updated), pending (awaiting confirmation or settlement), reversed (cancelled via reversal entry), failed (transaction rejected by system). Immutable ledger typically contains only posted entries.. Valid values are `posted|pending|reversed|failed`',
    `transaction_timestamp` TIMESTAMP COMMENT 'Exact date and time when the points transaction occurred in the source system. Business event timestamp for the points movement.',
    `transaction_type` STRING COMMENT 'Type of points movement: earn (points accrued from purchase or activity), redeem (points spent on rewards), expire (points lapsed due to inactivity or time limit), adjust (manual correction by program administrator), bonus (promotional or campaign points grant), transfer (points moved between accounts or partners), reversal (correction of a prior transaction), tier_qualify (points milestone triggering tier change). [ENUM-REF-CANDIDATE: earn|redeem|expire|adjust|bonus|transfer|reversal|tier_qualify — 8 candidates stripped; promote to reference product]',
    CONSTRAINT pk_points_ledger PRIMARY KEY(`points_ledger_id`)
) COMMENT 'Immutable append-only ledger recording every points movement for a loyalty membership, including tier-change qualification events. Each entry captures transaction type (earn, redeem, expire, adjust, bonus, transfer, reversal, tier_qualify), signed points amount, source reference (POS transaction, order, promotion, partner, tier evaluation), channel, location, timestamp, running balance, and optional tier-change metadata (previous tier, new tier, qualifying period). Serves as the financial-grade audit trail for points liability management, ASC 606 compliance evidence, tier history reporting, and CLTV calculation. No updates or deletes — corrections are posted as reversal entries. Tier qualification events include the qualifying spend/points amount and evaluation period for complete audit trail.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` (
    `accrual_rule_id` BIGINT COMMENT 'Unique identifier for the loyalty points accrual rule. Primary key.',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.store_format. Business justification: Earning rules vary by store format (hypermarkets 1x, premium formats 2x) to reflect margin structures and customer expectations. Retail loyalty programs differentiate point accrual by format for profi',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Loyalty earning rules routinely target product categories/hierarchies (e.g., 2x points on electronics, bonus points in grocery). Category-based earning is a core retail loyalty mechanic requiring',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Accrual rules define which GL accounts receive liability postings when points are earned. Different accrual rules (base earn, bonus, promotional) may post to different GL accounts for financial report',
    `loyalty_program_id` BIGINT COMMENT 'Reference to the loyalty program to which this accrual rule belongs.',
    `price_zone_id` BIGINT COMMENT 'Foreign key linking to pricing.price_zone. Business justification: Accrual rates frequently vary by price zone (e.g., 2x points in premium urban zones, 1x in discount zones). Supports zone-based earning strategies, competitive positioning in high-value markets, and z',
    `associate_id` BIGINT COMMENT 'Identifier of the user or system that created this accrual rule record.',
    `product_brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Brand-based earning rules are core loyalty strategy (e.g., 3x points on private label, double points on partner brands). Brand-level earning rules support strategic merchandising objectives requir',
    `promo_offer_id` BIGINT COMMENT 'Reference to a specific promotion campaign if this accrual rule is tied to a promotional event. Null if not promotion-specific.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: SKU-specific earning rules are common for promotions (e.g., bonus 500 points on featured item #12345, triple points on new product launch). SKU-level earning rules are real promotional mechanics r',
    `tertiary_accrual_approved_by_user_associate_id` BIGINT COMMENT 'Identifier of the user who approved this accrual rule. Null if not yet approved.',
    `accrual_rule_status` STRING COMMENT 'Current lifecycle status of the accrual rule: draft (under development), active (in use), inactive (disabled), expired (past effective period), suspended (temporarily paused).. Valid values are `draft|active|inactive|expired|suspended`',
    `applicable_channel` STRING COMMENT 'Sales channel(s) where this accrual rule applies: all channels, in-store (POS), online (e-commerce), mobile app, BOPIS (Buy Online Pick Up In Store), ROPIS (Reserve Online Pick Up In Store).. Valid values are `all|in_store|online|mobile_app|bopis|ropis`',
    `applicable_product_category` STRING COMMENT 'Product category or categories to which this accrual rule applies. Null if rule applies to all categories. Comma-separated list if multiple.',
    `applicable_sku_list` STRING COMMENT 'Specific SKUs to which this accrual rule applies. Null if rule applies broadly. Comma-separated list if multiple SKUs.',
    `approval_status` STRING COMMENT 'Approval workflow status for this accrual rule: pending (awaiting approval), approved (ready for activation), rejected (not approved).. Valid values are `pending|approved|rejected`',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this accrual rule was approved. Null if not yet approved.',
    `bonus_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to the base earning rate for bonus promotions (e.g., 2.0 for double points, 1.5 for 50% bonus). Null if not a multiplier rule.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this accrual rule record was first created in the system.',
    `day_of_week_restriction` STRING COMMENT 'Specific days of the week when this accrual rule applies (e.g., Monday,Wednesday,Friday). Null if rule applies all days.',
    `earning_basis` STRING COMMENT 'The basis on which points are earned: spend amount (dollars spent), unit quantity (items purchased), transaction count (number of transactions), or visit count (store visits).. Valid values are `spend_amount|unit_quantity|transaction_count|visit_count`',
    `effective_end_date` DATE COMMENT 'Date when this accrual rule expires and stops applying to transactions. Null for open-ended rules.',
    `effective_start_date` DATE COMMENT 'Date when this accrual rule becomes active and begins applying to qualifying transactions.',
    `excluded_product_category` STRING COMMENT 'Product categories explicitly excluded from this accrual rule (e.g., alcohol, tobacco, gift cards). Null if no exclusions. Comma-separated list if multiple.',
    `excluded_sku_list` STRING COMMENT 'Specific SKUs explicitly excluded from this accrual rule. Null if no exclusions. Comma-separated list if multiple SKUs.',
    `external_rule_code` STRING COMMENT 'Identifier of this accrual rule in the source system, used for cross-system reconciliation and integration.',
    `geographic_restriction` STRING COMMENT 'Geographic scope where this accrual rule applies (e.g., specific countries, states, regions, or store locations). Null if no geographic restriction.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this accrual rule record was last updated.',
    `maximum_points_per_transaction` STRING COMMENT 'Cap on the number of points that can be earned in a single transaction under this rule. Null if no cap.',
    `member_tier_eligibility` STRING COMMENT 'Loyalty program membership tier(s) eligible for this accrual rule. all if rule applies to all tiers, or specific tier names.. Valid values are `all|bronze|silver|gold|platinum`',
    `minimum_spend_threshold` DECIMAL(18,2) COMMENT 'Minimum transaction amount required for the accrual rule to apply. Null if no minimum threshold.',
    `notes` STRING COMMENT 'Free-text field for additional notes, comments, or special instructions related to this accrual rule.',
    `payment_method_restriction` STRING COMMENT 'Specific payment methods required for this accrual rule to apply (e.g., store_credit_card, mobile_wallet). Null if no payment method restriction.',
    `points_per_unit` DECIMAL(18,2) COMMENT 'Number of loyalty points earned per unit of the earning basis (e.g., 1 point per dollar spent, 10 points per item purchased).',
    `pricing_strategy_alignment` STRING COMMENT 'Indicates which pricing strategy this accrual rule supports: EDLP (Everyday Low Price), Hi-Lo (High-Low promotional pricing), or hybrid.. Valid values are `edlp|hi_lo|hybrid`',
    `rule_code` STRING COMMENT 'Unique business identifier code for the accrual rule, used for external reference and system integration.. Valid values are `^[A-Z0-9_]{3,20}$`',
    `rule_description` STRING COMMENT 'Detailed description of the accrual rule, including business rationale, conditions, and examples.',
    `rule_name` STRING COMMENT 'Human-readable name of the accrual rule describing its purpose (e.g., Base Earn Rate, Grocery Bonus, BOPIS Double Points).',
    `rule_priority` STRING COMMENT 'Priority ranking for conflict resolution when multiple accrual rules apply to the same transaction. Lower numbers indicate higher priority (1 = highest).',
    `rule_type` STRING COMMENT 'Classification of the accrual rule by its application logic: base earning rate, bonus multiplier, category-specific, SKU-specific, channel-specific, or tier-specific.. Valid values are `base_earn|bonus_multiplier|category_specific|sku_specific|channel_specific|tier_specific`',
    `stacking_allowed_flag` BOOLEAN COMMENT 'Indicates whether this accrual rule can be combined (stacked) with other accrual rules in the same transaction. True = stacking allowed, False = exclusive rule.',
    `time_of_day_restriction` STRING COMMENT 'Specific time windows when this accrual rule applies (e.g., 09:00-12:00, happy hour). Null if rule applies all day.',
    `version_number` STRING COMMENT 'Version number of this accrual rule, incremented with each modification to support change tracking and audit history.',
    CONSTRAINT pk_accrual_rule PRIMARY KEY(`accrual_rule_id`)
) COMMENT 'Defines the business rules governing how points are earned by members. Captures rule name, program association, earning rate (points per dollar spent, per unit purchased, per visit), applicable product categories or SKUs, applicable channels (in-store, online, BOPIS), minimum spend threshold, bonus multiplier conditions, rule effective dates, and rule priority for conflict resolution. Supports EDLP and Hi-Lo earning strategies.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` (
    `redemption_rule_id` BIGINT COMMENT 'Unique identifier for the redemption rule. Primary key.',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.store_format. Business justification: Redemption policies restrict or enhance by format (premium rewards only at flagship stores, discount outlets exclude certain types). Retail operations align redemption rules to format capabilities and',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Redemption restrictions commonly apply by category (e.g., points not valid on alcohol/tobacco, redeem only in health & beauty). Category-level redemption rules are standard retail loyalty practice',
    `associate_id` BIGINT COMMENT 'Identifier of the user or system account that created this redemption rule record.',
    `product_brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Brand restrictions on redemptions exist (e.g., points valid only on store brands, exclude premium brands from discounts). Brand-level redemption rules are real business constraints requiring this',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: SKU-level redemption restrictions exist (e.g., points not valid on clearance SKUs, exclude gift cards from point redemption). SKU-specific redemption rules are real business constraints requiring',
    `approval_workflow_code` STRING COMMENT 'Identifier of the approval workflow process to be triggered when requires_approval_flag is True. Nullable if no approval required.',
    `blackout_end_date` DATE COMMENT 'End date of blackout period during which redemptions under this rule are not allowed. Nullable if no blackout applies.',
    `blackout_start_date` DATE COMMENT 'Start date of blackout period during which redemptions under this rule are not allowed. Nullable if no blackout applies.',
    `combinable_with_promotions_flag` BOOLEAN COMMENT 'Indicates whether this redemption rule can be combined with other promotional offers (True) or must be used exclusively (False).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this redemption rule record was first created in the system.',
    `effective_end_date` DATE COMMENT 'Date when the redemption rule expires and is no longer available for member use. Nullable for open-ended rules.',
    `effective_start_date` DATE COMMENT 'Date when the redemption rule becomes active and available for member use.',
    `eligible_channels` STRING COMMENT 'Comma-separated list of channels where this redemption rule can be applied (e.g., store, online, mobile_app, call_center).',
    `eligible_reward_types` STRING COMMENT 'Comma-separated list of reward types that can be redeemed under this rule (e.g., merchandise, gift_card, discount, cashback, travel).',
    `excluded_product_categories` STRING COMMENT 'Comma-separated list of product category codes that are excluded from redemption under this rule (e.g., alcohol, tobacco, gift cards). Nullable if no exclusions.',
    `geographic_restriction` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes where this redemption rule is valid. Nullable for global applicability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this redemption rule record was last updated in the system.',
    `liability_impact_category` STRING COMMENT 'Classification of how this redemption rule impacts loyalty points liability accounting (immediate recognition, deferred, conditional on fulfillment, or no impact).. Valid values are `immediate|deferred|conditional|none`',
    `marketing_message` STRING COMMENT 'Customer-facing marketing message or promotional text to be displayed when presenting this redemption rule to members.',
    `maximum_points_threshold` DECIMAL(18,2) COMMENT 'Maximum number of loyalty points that can be redeemed in a single transaction under this rule. Nullable for unlimited redemptions.',
    `maximum_redemptions_per_day` STRING COMMENT 'Maximum number of redemption transactions allowed per member per day under this rule. Nullable for unlimited daily usage.',
    `maximum_redemptions_per_member` STRING COMMENT 'Maximum number of times a single member can use this redemption rule within the effective period. Nullable for unlimited usage.',
    `minimum_membership_tier` STRING COMMENT 'Minimum loyalty program tier required for a member to use this redemption rule (e.g., bronze, silver, gold, platinum). Nullable if no tier restriction.',
    `minimum_points_threshold` DECIMAL(18,2) COMMENT 'Minimum number of loyalty points required to initiate a redemption transaction under this rule.',
    `partial_redemption_allowed_flag` BOOLEAN COMMENT 'Indicates whether members can redeem points in amounts less than the full reward value (True) or must redeem in full increments only (False).',
    `pos_integration_required_flag` BOOLEAN COMMENT 'Indicates whether this redemption rule requires real-time integration with Point of Sale (POS) systems for in-store redemptions (True) or can be processed offline (False).',
    `priority_rank` STRING COMMENT 'Numeric ranking to determine precedence when multiple redemption rules could apply to the same transaction. Lower numbers indicate higher priority.',
    `redemption_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the monetary value associated with point redemptions.. Valid values are `^[A-Z]{3}$`',
    `redemption_rate` DECIMAL(18,2) COMMENT 'Conversion rate defining how many points equal one unit of currency or reward value (e.g., 100 points = 1 USD).',
    `redemption_rule_status` STRING COMMENT 'Current lifecycle status of the redemption rule indicating its operational state.. Valid values are `draft|active|suspended|expired|archived`',
    `requires_approval_flag` BOOLEAN COMMENT 'Indicates whether redemptions under this rule require manager or system approval before processing (True) or are auto-approved (False).',
    `rounding_rule` STRING COMMENT 'Rule for rounding points during redemption calculations when fractional points result from conversion.. Valid values are `round_up|round_down|round_nearest|no_rounding`',
    `rule_code` STRING COMMENT 'Business identifier code for the redemption rule, used for external reference and system integration.. Valid values are `^[A-Z0-9_]{4,20}$`',
    `rule_description` STRING COMMENT 'Detailed description of the redemption rule, including business purpose and usage guidelines.',
    `rule_name` STRING COMMENT 'Human-readable name of the redemption rule for display and reporting purposes.',
    `rule_type` STRING COMMENT 'Classification of the redemption rule based on its business purpose and application context.. Valid values are `standard|promotional|tier_based|seasonal|partner|event_driven`',
    `terms_and_conditions_url` STRING COMMENT 'URL link to the full legal terms and conditions document governing this redemption rule.',
    `version_number` STRING COMMENT 'Version number of this redemption rule, incremented with each modification to support change tracking and audit history.',
    CONSTRAINT pk_redemption_rule PRIMARY KEY(`redemption_rule_id`)
) COMMENT 'Defines the business rules governing how members can redeem points for rewards. Captures minimum redemption threshold, redemption rate (points to currency conversion), eligible reward types, blackout dates, channel restrictions, partial redemption flag, rounding rules, and rule effective dates. Distinct from accrual rules as redemption has its own approval workflow, liability impact, and POS integration requirements.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`reward` (
    `reward_id` BIGINT COMMENT 'Unique identifier for the reward in the loyalty program catalog. Primary key.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Reward fulfillment costs (cost_to_business field) are tracked by cost center for budgeting, variance analysis, and P&L reporting. Different reward types (merchandise, discounts, partner rewards) may b',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.store_format. Business justification: Reward eligibility restricted by format (experiential rewards only at flagship, bulk discounts only at warehouse). Retail loyalty catalogs curated per format to match inventory, service capabilities',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Rewards frequently target categories (e.g., $5 off grocery, 10% off apparel). Category-scoped rewards are a fundamental loyalty reward type requiring this link for reward catalog management and re',
    `vendor_id` BIGINT COMMENT 'External identifier for the partner vendor in the vendor management system. Null for internally-fulfilled rewards.',
    `product_brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Brand-specific rewards are common (e.g., $10 off , 20% off private label). Brand-targeted rewards support vendor partnerships and private label strategy requiring this link for brand-scoped re',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Loyalty rewards can be product-based (e.g., redeem points for this SKU). The reward.product_sku_restriction field suggests SKU-level restrictions exist. This links loyalty rewards to the product cat',
    `brand_restriction` STRING COMMENT 'Comma-separated list of brand codes this reward applies to or excludes. Null if no brand restriction. Supports brand-sponsored rewards.',
    `reward_category` STRING COMMENT 'Business classification grouping for the reward (e.g., Grocery, Apparel, Electronics, Travel, Dining, Wellness). Used for catalog navigation and reporting.',
    `category_restriction` STRING COMMENT 'Comma-separated list of product category codes this reward applies to or excludes (e.g., ELECTRONICS,APPAREL). Null if no category restriction.',
    `channel_availability` STRING COMMENT 'Channels where this reward can be redeemed: in-store (physical locations), online (e-commerce site), mobile app, call center, or all channels (omnichannel). Supports channel-specific reward strategies.. Valid values are `in_store|online|mobile_app|call_center|all_channels`',
    `reward_code` STRING COMMENT 'Externally-facing unique alphanumeric code for the reward, used in customer communications and redemption interfaces.. Valid values are `^[A-Z0-9]{6,20}$`',
    `cost_to_business` DECIMAL(18,2) COMMENT 'Internal cost to the business for fulfilling this reward (e.g., wholesale cost, partner fee). Used for program ROI analysis and points liability valuation. Business-confidential.',
    `created_by_user` STRING COMMENT 'User identifier or system account that created this reward record. Part of audit trail.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this reward record was first created in the system. Part of audit trail.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the monetary value (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `description_long` STRING COMMENT 'Detailed customer-facing description of the reward, including benefits, usage instructions, and value proposition. Used in reward detail pages.',
    `description_short` STRING COMMENT 'Brief customer-facing description of the reward (typically 1-2 sentences), used in catalog list views and mobile notifications.',
    `discount_type` STRING COMMENT 'For discount voucher rewards, specifies the discount mechanism: percentage (e.g., 20% off), fixed amount (e.g., $10 off), free shipping, buy-one-get-one (BOGO), or tiered (discount varies by spend threshold). Null for non-discount reward types.. Valid values are `percentage|fixed_amount|free_shipping|bogo|tiered`',
    `discount_value` DECIMAL(18,2) COMMENT 'Numeric value of the discount. For percentage discounts, this is the percentage (e.g., 15.00 for 15%). For fixed amount, this is the currency amount. Null for non-discount rewards.',
    `display_priority` STRING COMMENT 'Numeric priority for sorting rewards in catalog displays. Lower numbers appear first. Used for merchandising control of reward visibility.',
    `effective_end_date` DATE COMMENT 'Date when this reward is no longer available for redemption. Null for rewards with no expiration.',
    `effective_start_date` DATE COMMENT 'Date when this reward becomes available for redemption. Part of the rewards availability window.',
    `eligible_member_tiers` STRING COMMENT 'Comma-separated list of loyalty tier codes eligible to redeem this reward (e.g., SILVER,GOLD,PLATINUM). Null or ALL if available to all tiers. Enables tier-exclusive rewards.',
    `geographic_restriction` STRING COMMENT 'Comma-separated list of geographic codes (country, state, or store codes) where this reward can be redeemed. Null if no geographic restriction. Supports regional reward strategies.',
    `image_url` STRING COMMENT 'URL to the primary image asset for this reward, used in customer-facing catalog displays and mobile app.. Valid values are `^https?://.*.(jpg|jpeg|png|gif|webp)$`',
    `is_combinable` BOOLEAN COMMENT 'Boolean flag indicating whether this reward can be combined with other rewards or promotions in a single transaction. True if combinable, false if exclusive.',
    `is_featured` BOOLEAN COMMENT 'Boolean flag indicating whether this reward is featured in promotional displays and priority catalog positions. True for featured rewards, false otherwise.',
    `margin_percentage` DECIMAL(18,2) COMMENT 'Calculated margin percentage between monetary value and cost to business ((monetary_value - cost_to_business) / monetary_value * 100). Used for reward profitability analysis. Business-confidential.',
    `maximum_discount_amount` DECIMAL(18,2) COMMENT 'Cap on the discount amount for percentage-based rewards (e.g., 20% off up to $50 maximum discount). Null if no cap applies.',
    `minimum_purchase_amount` DECIMAL(18,2) COMMENT 'Minimum transaction amount required to redeem this reward. Null if no minimum applies. Used to enforce redemption rules and protect margin.',
    `monetary_value` DECIMAL(18,2) COMMENT 'Approximate monetary value of the reward in the base currency, used for points liability accounting and customer value communication.',
    `reward_name` STRING COMMENT 'Customer-facing display name of the reward (e.g., $10 Off Next Purchase, Free Coffee, Premium Gift Card).',
    `points_cost` STRING COMMENT 'Number of loyalty points required to redeem this reward. Core pricing mechanism for the loyalty program.',
    `product_sku_restriction` STRING COMMENT 'Comma-separated list of SKU codes this reward applies to or excludes. Used for product-specific rewards (e.g., free product reward for specific SKU). Null if no SKU restriction.',
    `quantity_available` STRING COMMENT 'Current inventory count of this reward available for redemption. Null for unlimited digital rewards. Decremented upon redemption.',
    `quantity_limit_per_member` STRING COMMENT 'Maximum number of times a single loyalty member can redeem this reward within the validity period. Null for no limit.',
    `redemption_validity_days` STRING COMMENT 'Number of days from redemption date that the reward voucher or certificate remains valid for use. Null for instant-use rewards.',
    `reward_status` STRING COMMENT 'Current lifecycle status of the reward in the catalog. Active: available for redemption. Inactive: temporarily unavailable. Sold out: inventory depleted. Discontinued: permanently removed. Pending approval: awaiting merchandising review.. Valid values are `active|inactive|sold_out|discontinued|pending_approval`',
    `reward_type` STRING COMMENT 'Classification of the reward by its nature: discount voucher (percentage or fixed amount off), free product (complimentary item), gift card (prepaid card), experience (event or service), charitable donation (contribution to cause), cashback (monetary return), or points multiplier (bonus points on future purchases). [ENUM-REF-CANDIDATE: discount_voucher|free_product|gift_card|experience|charitable_donation|cashback|points_multiplier — 7 candidates stripped; promote to reference product]',
    `terms_and_conditions` STRING COMMENT 'Legal terms and conditions governing the redemption and use of this reward. Includes exclusions, restrictions, and compliance disclaimers.',
    `thumbnail_url` STRING COMMENT 'URL to the thumbnail image for this reward, optimized for list views and quick loading.. Valid values are `^https?://.*.(jpg|jpeg|png|gif|webp)$`',
    `updated_by_user` STRING COMMENT 'User identifier or system account that last modified this reward record. Part of audit trail.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this reward record was last modified. Part of audit trail for change tracking.',
    CONSTRAINT pk_reward PRIMARY KEY(`reward_id`)
) COMMENT 'Master catalog of all rewards available for redemption within a loyalty program. Captures reward name, reward type (discount voucher, free product, gift card, experience, charitable donation), points cost, monetary value equivalent, reward category, availability dates, quantity limit, channel availability (in-store, online), image URL, terms and conditions, and reward status (active, sold out, discontinued). Analogous to a PIM for the rewards catalog.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`redemption` (
    `redemption_id` BIGINT COMMENT 'Unique identifier for the redemption transaction. Primary key for the redemption data product.',
    `campaign_id` BIGINT COMMENT 'Reference to the marketing campaign that drove the offer redemption, if applicable. Used for campaign performance measurement and ROI analysis.',
    `cart_id` BIGINT COMMENT 'Foreign key linking to ecommerce.cart. Business justification: Loyalty redemptions (vouchers, discounts, rewards) are applied to carts during checkout; linking enables tracking redemption application timing, cart conversion rates post-redemption, and abandoned ca',
    `header_id` BIGINT COMMENT 'Reference to the e-commerce or store order where the redemption was applied. Null if redemption has not yet been used in a transaction.',
    `location_id` BIGINT COMMENT 'Reference to the physical store location where the redemption occurred, if applicable. Null for online or call center redemptions.',
    `loyalty_membership_id` BIGINT COMMENT 'Reference to the loyalty program member who performed the redemption. Links to the loyalty member master data.',
    `member_offer_id` BIGINT COMMENT 'Reference to the personalized or promotional offer activated, if redemption type is offer-based. Null for catalog reward redemptions.',
    `partner_program_id` BIGINT COMMENT 'Reference to the third-party partner organization if the redemption was for a partner reward or occurred through a partner channel. Null for internal rewards.',
    `pos_transaction_id` BIGINT COMMENT 'Reference to the POS transaction where the redemption was applied in-store. Null for online or unused redemptions.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Redemptions may occur during promotional campaigns where both loyalty rewards and promotional discounts apply - transaction-level tracking required for margin analysis, conflict resolution, and unders',
    `redemption_rule_id` BIGINT COMMENT 'Foreign key linking to loyalty.redemption_rule. Business justification: Every redemption should reference which redemption rule allowed it (minimum points threshold, eligible channels, tier requirements, etc.). This is essential for compliance, audit, and analytics. Curre',
    `revenue_recognition_event_id` BIGINT COMMENT 'Foreign key linking to finance.revenue_recognition_event. Business justification: Redemptions trigger revenue recognition events under ASC 606. When customers redeem points for rewards, deferred revenue liability is reduced and revenue is recognized. This link is required for compl',
    `reward_id` BIGINT COMMENT 'Reference to the reward catalog item redeemed, if redemption type is catalog reward. Null for offer-based redemptions.',
    `cancellation_reason` STRING COMMENT 'Reason code explaining why the redemption was cancelled: member request, system error, fraud detection, associated order cancelled, expired before use, or duplicate transaction.. Valid values are `member_request|system_error|fraud_detection|order_cancelled|expired|duplicate`',
    `cancellation_timestamp` TIMESTAMP COMMENT 'Date and time when the redemption was cancelled by the member or system. Null if redemption was not cancelled.',
    `channel` STRING COMMENT 'The customer touchpoint or interface through which the redemption was initiated: web (e-commerce site), mobile app, physical store, call center, in-store kiosk, or partner website.. Valid values are `web|mobile_app|store|call_center|kiosk|partner_site`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this redemption record was first created in the system. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the monetary value (e.g., USD, EUR, GBP). Supports multi-currency loyalty programs.. Valid values are `^[A-Z]{3}$`',
    `expiry_date` DATE COMMENT 'Date after which the issued voucher or reward becomes invalid and cannot be used. Drives automated expiration workflows.',
    `fraud_detection_score` DECIMAL(18,2) COMMENT 'Numerical risk score (0-100) assigned by fraud detection algorithms at the time of redemption. Higher scores indicate higher fraud risk.',
    `fulfillment_method` STRING COMMENT 'Method by which the reward or voucher is delivered to the member: instant (immediate at POS), email, SMS, postal mail, in-store pickup, home delivery, or digital download. [ENUM-REF-CANDIDATE: instant|email|sms|mail|in_store_pickup|home_delivery|digital_download — 7 candidates stripped; promote to reference product]',
    `is_fraudulent` BOOLEAN COMMENT 'Boolean flag indicating whether the redemption was identified as fraudulent by fraud detection systems or manual review. True if fraudulent, False otherwise.',
    `monetary_value` DECIMAL(18,2) COMMENT 'Equivalent monetary value of the redemption in the base currency. Used for ROI analysis and financial reconciliation of loyalty program costs.',
    `notes` STRING COMMENT 'Free-text notes or comments related to the redemption transaction, typically entered by customer service representatives or system-generated for exception handling.',
    `points_redeemed` DECIMAL(18,2) COMMENT 'Number of loyalty points deducted from the members account for this redemption. Drives points liability reduction in financial reporting.',
    `redemption_number` STRING COMMENT 'Human-readable business identifier for the redemption transaction, used for customer service inquiries and operational tracking.. Valid values are `^RDM-[0-9]{10}$`',
    `redemption_status` STRING COMMENT 'Current lifecycle state of the redemption: issued (voucher/code generated), activated (member claimed), used (redeemed at point of sale or fulfillment), expired (passed validity period), cancelled (member or system cancelled), reversed (points restored due to return or error).. Valid values are `issued|activated|used|expired|cancelled|reversed`',
    `redemption_timestamp` TIMESTAMP COMMENT 'Date and time when the member initiated the redemption transaction. Represents the business event time for points liability reduction and reward issuance.',
    `redemption_type` STRING COMMENT 'Discriminator indicating the category of redemption: catalog reward (standard rewards catalog item), personalized offer (targeted member-specific offer), promotional offer (campaign-driven offer), partner reward (third-party partner reward), instant discount (point-of-sale discount), or voucher (gift certificate or coupon).. Valid values are `catalog_reward|personalized_offer|promotional_offer|partner_reward|instant_discount|voucher`',
    `reversal_reason` STRING COMMENT 'Reason code explaining why the redemption was reversed: product return, order cancellation, service failure, system error, fraud reversal, or goodwill gesture.. Valid values are `product_return|order_cancellation|service_failure|system_error|fraud_reversal|goodwill`',
    `reversal_timestamp` TIMESTAMP COMMENT 'Date and time when the redemption was reversed and points were restored to the members account. Null if redemption was not reversed.',
    `tier_at_redemption` STRING COMMENT 'The loyalty program tier level of the member at the time of redemption (e.g., Silver, Gold, Platinum). Captured for tier-based redemption analysis and benefit tracking.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this redemption record was last modified. Used for audit trail and change tracking.',
    `usage_timestamp` TIMESTAMP COMMENT 'Date and time when the voucher or reward was actually used in a transaction. Null if status is issued or activated but not yet used.',
    `voucher_code` STRING COMMENT 'Unique alphanumeric code issued to the member for redemption at point of sale or online checkout. Used to track usage and prevent fraud.. Valid values are `^[A-Z0-9]{12,16}$`',
    CONSTRAINT pk_redemption PRIMARY KEY(`redemption_id`)
) COMMENT 'Transactional record of each redemption event by a loyalty member, covering both catalog reward redemptions and personalized offer activations. Captures membership reference, item redeemed (reward or offer), redemption type discriminator, points deducted, redemption channel, timestamp, associated order or POS transaction, voucher/coupon code issued, fulfillment status (issued, used, expired, cancelled), and monetary value. Drives points liability reduction, reward fulfillment workflows, and offer performance measurement.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`member_offer` (
    `member_offer_id` BIGINT COMMENT 'Unique identifier for the member offer. Primary key.',
    `campaign_id` BIGINT COMMENT 'Identifier of the marketing campaign or engagement program that generated this offer. Null for ad-hoc or system-triggered offers.',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Personalized offers routinely target categories based on purchase history (e.g., 20% off apparel for you, bonus points on your favorite department). Category-targeted personalization is core to re',
    `loyalty_membership_id` BIGINT COMMENT 'Identifier of the loyalty member to whom this offer is assigned. Links to the member profile in the loyalty domain.',
    `member_segment_id` BIGINT COMMENT 'Identifier of the customer segment targeted by this offer, if the offer is segment-based rather than individual. Null for 1:1 personalized offers.',
    `product_brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Brand-targeted personalized offers leverage brand affinity (e.g., your favorite brand on sale, new arrivals from brands you love). Brand-level personalization is proven loyalty tactic requiring th',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_offer. Business justification: Personalized member offers often reference broader promotional offers with additional loyalty-exclusive benefits (e.g., Your exclusive: store-wide 20% off PLUS 500 bonus points) - enables coordinate',
    `reward_id` BIGINT COMMENT 'Foreign key linking to loyalty.reward. Business justification: Many member offers are tied to specific rewards from the catalog (e.g., Redeem this offer for Product X). Adding reward_id FK links offers to the reward master catalog. This is optional as not all o',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: SKU-targeted personalized offers drive replenishment (e.g., buy your favorite coffee again, reorder item #67890 at 15% off). SKU-level personalization is a proven loyalty tactic requiring this lin',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Personalized loyalty offers are presented on specific digital storefronts; tracking which storefront displayed the offer enables channel-specific offer performance measurement, storefront-level offer',
    `cluster_id` BIGINT COMMENT 'Foreign key linking to store.store_cluster. Business justification: Personalized offers target members within specific store clusters to align promotions with local assortment, pricing zones, demographic preferences. Retail loyalty engines generate cluster-specific of',
    `activation_timestamp` TIMESTAMP COMMENT 'Date and time when the member activated or accepted the offer. Null if not yet activated.',
    `bonus_points_amount` STRING COMMENT 'Fixed number of bonus points awarded upon offer redemption or qualifying action. Null if offer is not a fixed-points bonus.',
    `channel_applicability` STRING COMMENT 'Sales channel(s) where the offer can be redeemed: all (omnichannel), in_store (physical stores only), online (e-commerce website), mobile_app (mobile application), call_center (phone orders).. Valid values are `all|in_store|online|mobile_app|call_center`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this offer record was first created in the system.',
    `discount_type` STRING COMMENT 'Type of discount provided: percentage (percent off total or item) or fixed_amount (dollar/currency amount off). Null if offer is not discount-based.. Valid values are `percentage|fixed_amount`',
    `discount_value` DECIMAL(18,2) COMMENT 'Numeric value of the discount: percentage (e.g., 15.00 for 15% off) or fixed currency amount (e.g., 10.00 for $10 off). Null if offer is not discount-based.',
    `eligible_product_category` STRING COMMENT 'Product category or categories eligible for this offer (e.g., Apparel, Electronics). Null if offer applies to all products.',
    `end_date` DATE COMMENT 'Date when the offer expires and is no longer available for redemption. Null for open-ended offers.',
    `estimated_liability_amount` DECIMAL(18,2) COMMENT 'Estimated financial liability or cost to the business if this offer is fully redeemed, used for points liability and financial planning.',
    `excluded_product_category` STRING COMMENT 'Product category or categories explicitly excluded from this offer. Null if no exclusions.',
    `expiration_timestamp` TIMESTAMP COMMENT 'Date and time when the offer expired without being redeemed. Null if offer is still active or was redeemed.',
    `max_redemptions` STRING COMMENT 'Maximum number of times this offer can be redeemed by the member. Null for unlimited redemptions within validity period.',
    `minimum_quantity` STRING COMMENT 'Minimum number of items or units required to qualify for the offer. Null if no quantity requirement.',
    `minimum_spend_amount` DECIMAL(18,2) COMMENT 'Minimum purchase amount required to qualify for the offer. Null if no minimum spend requirement.',
    `modified_by` STRING COMMENT 'User ID or system identifier of the person or process that last modified this offer record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this offer record was last modified.',
    `offer_code` STRING COMMENT 'Unique alphanumeric code representing this offer, used for tracking and redemption. Externally visible identifier.. Valid values are `^[A-Z0-9]{6,20}$`',
    `offer_description` STRING COMMENT 'Detailed description of the offer terms, benefits, and conditions as communicated to the member.',
    `offer_name` STRING COMMENT 'Human-readable name of the offer as presented to the member (e.g., Birthday Bonus Points, Welcome Back Discount).',
    `offer_source` STRING COMMENT 'Origin of the offer assignment: automated (system-generated based on rules), manual (created by loyalty manager), campaign (part of marketing campaign), clienteling (personalized by store associate), tier_benefit (automatic tier-based perk).. Valid values are `automated|manual|campaign|clienteling|tier_benefit`',
    `offer_status` STRING COMMENT 'Current lifecycle status of the offer: pending (assigned but not yet presented), presented (communicated to member), activated (member accepted), redeemed (member used), expired (validity period ended), declined (member rejected), cancelled (offer withdrawn by business). [ENUM-REF-CANDIDATE: pending|presented|activated|redeemed|expired|declined|cancelled — 7 candidates stripped; promote to reference product]',
    `offer_type` STRING COMMENT 'Category of the offer benefit: bonus_points (points multiplier or fixed bonus), discount (percentage or fixed amount off), free_item (complimentary product), early_access (exclusive access to sales or products), experiential_reward (event tickets, services), tier_upgrade (accelerated tier progression).. Valid values are `bonus_points|discount|free_item|early_access|experiential_reward|tier_upgrade`',
    `personalization_score` DECIMAL(18,2) COMMENT 'Algorithmic score indicating the degree of personalization or relevance of this offer to the member, typically 0.00 to 1.00. Used for offer optimization and analytics.',
    `points_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to points accrual for qualifying purchases (e.g., 2.0 for double points, 1.5 for 50% bonus). Null if offer is not points-based.',
    `presentation_priority` STRING COMMENT 'Numeric priority for displaying this offer when multiple offers are available to the member. Lower numbers indicate higher priority.',
    `presentation_timestamp` TIMESTAMP COMMENT 'Date and time when the offer was first presented or communicated to the member. Null if not yet presented.',
    `redemption_count` STRING COMMENT 'Number of times this offer has been redeemed by the member to date.',
    `redemption_timestamp` TIMESTAMP COMMENT 'Date and time when the offer was redeemed by the member. Null if not yet redeemed.',
    `start_date` DATE COMMENT 'Date when the offer becomes active and available for redemption by the member.',
    `terms_and_conditions` STRING COMMENT 'Full legal terms and conditions governing the offer, including restrictions, exclusions, and compliance disclosures.',
    `trigger_type` STRING COMMENT 'Business event or condition that triggered the offer assignment: birthday (member birthday), anniversary (membership anniversary), win_back (lapsed customer reactivation), rfm_segment (Recency Frequency Monetary segment targeting), tier_upgrade (celebration of tier advancement), milestone (spending or visit milestone), behavioral (specific action-based), seasonal (holiday or seasonal campaign). [ENUM-REF-CANDIDATE: birthday|anniversary|win_back|rfm_segment|tier_upgrade|milestone|behavioral|seasonal — 8 candidates stripped; promote to reference product]',
    `created_by` STRING COMMENT 'User ID or system identifier of the person or process that created this offer record.',
    CONSTRAINT pk_member_offer PRIMARY KEY(`member_offer_id`)
) COMMENT 'Personalized or segment-targeted offer assigned to a loyalty member or member cohort, distinct from promotion-domain deals which are broad-market. Captures offer name, offer type (bonus points, discount, free item, early access, experiential reward), target membership or segment, offer trigger (birthday, anniversary, win-back, RFM segment, tier upgrade celebration), points multiplier or discount value, minimum spend requirement, offer start/end dates, channel applicability, presentation priority, and offer status (pending, presented, activated, redeemed, expired, declined). SSOT for member-level offer assignments — the promotion domain owns the broad promotional mechanics while this product owns the 1:1 or segment-level loyalty offer lifecycle. Redemption of offers is recorded in the redemption product with type discriminator.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` (
    `engagement_campaign_id` BIGINT COMMENT 'Unique identifier for the loyalty engagement campaign. Primary key.',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Engagement campaigns require owner associates for budget accountability, approval workflows, performance measurement, and cross-functional coordination. Replaces denormalized campaign_owner_name/email',
    `segment_id` BIGINT COMMENT 'add column customer_segment_id (BIGINT) with FK to customer.segment.segment_id - engagement campaigns target customer segments and need this cross-domain linkage beyond just member_segment',
    `finance_budget_id` BIGINT COMMENT 'Foreign key linking to finance.budget. Business justification: Campaign budgets are formal financial budgets tracked in the finance system for approval, commitment tracking, and variance reporting. The engagement_campaign.budget_amount is denormalized budget data',
    `loyalty_program_id` BIGINT COMMENT 'Reference to the loyalty program under which this campaign operates. Links campaign to program-level rules and membership base.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Loyalty engagement campaigns are often sub-campaigns within broader marketing campaigns in retail operations. Linking enables unified campaign performance reporting, consolidated budget tracking, and',
    `member_segment_id` BIGINT COMMENT 'Reference to the target member segment for this campaign. Defines the audience eligible to participate based on RFM, tier, behavior, or demographic criteria.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Loyalty engagement campaigns frequently promote specific retail promotional campaigns to members (e.g., Members: early access to Summer Sale) - strategic coordination requires linking engagement cam',
    `cluster_id` BIGINT COMMENT 'Foreign key linking to store.store_cluster. Business justification: Campaigns target member segments within specific store clusters (urban vs suburban, high-income vs value) to align offers with cluster demographics and shopping behaviors. Standard retail loyalty prac',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.store_location. Business justification: Campaigns target members by preferred/enrollment store for in-store activation events, localized offers, store-specific promotions. Retail loyalty operations execute geo-targeted campaigns tied to spe',
    `actual_enrollment_count` STRING COMMENT 'Actual number of members who enrolled or opted-in to the campaign. Updated in real-time or batch as enrollments occur.',
    `actual_incremental_spend_amount` DECIMAL(18,2) COMMENT 'Actual incremental spend generated by campaign participants, measured as the difference between campaign-period spend and baseline spend. Key ROI metric.',
    `actual_participation_count` STRING COMMENT 'Actual number of members who completed qualifying actions and actively participated in the campaign. Used to calculate participation rate.',
    `actual_participation_rate_pct` DECIMAL(18,2) COMMENT 'Actual participation rate achieved, calculated as (actual_participation_count / actual_enrollment_count) * 100. Measured against target for campaign success assessment.',
    `actual_tier_upgrade_count` STRING COMMENT 'Actual number of members who upgraded to a higher loyalty tier during or as a result of the campaign. Measured against target for tier challenge campaigns.',
    `approval_date` DATE COMMENT 'Date when the campaign was approved by the appropriate authority (e.g., marketing director, finance). Null if campaign is still in draft status.',
    `approved_by_name` STRING COMMENT 'Name of the individual who approved the campaign. Used for audit trail and governance.',
    `bonus_points_amount` STRING COMMENT 'Fixed number of bonus points awarded to members who complete campaign qualifying actions. Null if campaign does not award fixed bonus points.',
    `campaign_code` STRING COMMENT 'Unique business identifier for the campaign, used in marketing materials, tracking URLs, and operational reporting. Externally visible code.. Valid values are `^[A-Z0-9_-]{4,20}$`',
    `campaign_description` STRING COMMENT 'Detailed description of the campaign objectives, mechanics, and value proposition. Used for internal alignment and external member communication.',
    `campaign_name` STRING COMMENT 'Human-readable name of the engagement campaign, used in internal reporting and customer-facing communications.',
    `campaign_status` STRING COMMENT 'Current lifecycle status of the campaign. Draft indicates planning phase; approved indicates ready for launch; active indicates currently running; paused indicates temporarily suspended; completed indicates ended successfully; archived indicates historical record; cancelled indicates terminated before completion. [ENUM-REF-CANDIDATE: draft|approved|active|paused|completed|archived|cancelled — 7 candidates stripped; promote to reference product]',
    `campaign_type` STRING COMMENT 'Classification of the campaign by its primary objective and mechanic. Enrollment drive focuses on new member acquisition; double-points event accelerates points accrual; tier challenge incentivizes tier upgrades; birthday campaign celebrates member milestones; reactivation targets dormant members; streak bonus rewards consecutive engagement; spend milestone rewards cumulative spend thresholds; referral incentive drives member-get-member growth. [ENUM-REF-CANDIDATE: enrollment_drive|double_points_event|tier_challenge|birthday_campaign|reactivation|streak_bonus|spend_milestone|referral_incentive — 8 candidates stripped; promote to reference product]',
    `channel_app_notification_flag` BOOLEAN COMMENT 'Indicates whether in-app notifications or banners are used as a communication channel for this campaign. True if app notification is part of the channel mix.',
    `channel_direct_mail_flag` BOOLEAN COMMENT 'Indicates whether physical direct mail is used as a communication channel for this campaign. True if direct mail is part of the channel mix.',
    `channel_email_flag` BOOLEAN COMMENT 'Indicates whether email is used as a communication channel for this campaign. True if email is part of the channel mix.',
    `channel_in_store_flag` BOOLEAN COMMENT 'Indicates whether in-store signage, POS displays, or associate-driven communication are used for this campaign. True if in-store is part of the channel mix.',
    `channel_push_flag` BOOLEAN COMMENT 'Indicates whether mobile app push notifications are used as a communication channel for this campaign. True if push is part of the channel mix.',
    `channel_sms_flag` BOOLEAN COMMENT 'Indicates whether SMS is used as a communication channel for this campaign. True if SMS is part of the channel mix.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the campaign record was first created in the system. Used for audit trail and data lineage.',
    `end_date` DATE COMMENT 'The date when the campaign concludes and members can no longer participate. Nullable for evergreen campaigns with no defined end date.',
    `expected_enrollment_count` STRING COMMENT 'Projected number of members expected to enroll or opt-in to the campaign. Used for capacity planning and success measurement.',
    `expected_participation_count` STRING COMMENT 'Projected number of members expected to actively participate in the campaign by completing qualifying actions. Used for ROI forecasting.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the campaign record was last modified. Updated on any change to campaign attributes. Used for audit trail and change tracking.',
    `opt_in_required_flag` BOOLEAN COMMENT 'Indicates whether members must explicitly opt-in to participate in the campaign. True if opt-in is required; false if all eligible members are automatically enrolled.',
    `personalization_enabled_flag` BOOLEAN COMMENT 'Indicates whether campaign communications and offers are personalized based on member preferences, purchase history, or behavioral data. True if personalization is enabled.',
    `points_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to base points earning rate during the campaign. For example, 2.0 for double points, 3.0 for triple points. Null if campaign does not modify points earning.',
    `qualifying_spend_threshold` DECIMAL(18,2) COMMENT 'Minimum spend amount required for a member to qualify for campaign rewards. Null if campaign has no spend threshold requirement.',
    `qualifying_transaction_count` STRING COMMENT 'Minimum number of transactions required for a member to qualify for campaign rewards. Null if campaign has no transaction count requirement.',
    `start_date` DATE COMMENT 'The date when the campaign becomes active and members can begin participating. Campaign mechanics and offers become effective from this date.',
    `target_incremental_spend_amount` DECIMAL(18,2) COMMENT 'Target incremental spend expected to be generated by campaign participants above their baseline spend. Used to calculate campaign ROI.',
    `target_participation_rate_pct` DECIMAL(18,2) COMMENT 'Target participation rate expressed as a percentage of enrolled members. Key performance indicator for campaign effectiveness.',
    `target_tier_upgrade_count` STRING COMMENT 'Target number of members expected to upgrade to a higher loyalty tier as a result of campaign participation. Relevant for tier challenge campaigns.',
    CONSTRAINT pk_engagement_campaign PRIMARY KEY(`engagement_campaign_id`)
) COMMENT 'Master record for loyalty engagement campaigns designed to drive member activation, retention, or win-back — distinct from promotion-domain campaigns which focus on price/deal mechanics. Captures campaign name, campaign type (enrollment drive, double-points event, tier challenge, birthday campaign, reactivation, streak bonus, spend milestone), target segment reference, program association, campaign start/end dates, budget allocation, expected enrollment/participation, channel mix (email, SMS, push, in-store signage, app notification), success metrics (participation rate, incremental spend, tier upgrades), and campaign status (draft, approved, active, paused, completed, archived). SSOT for loyalty-specific campaign definitions — coordinates with member_segment for targeting and member_offer for individual offer distribution.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` (
    `clienteling_interaction_id` BIGINT COMMENT 'Unique identifier for the clienteling interaction record. Primary key.',
    `associate_id` BIGINT COMMENT 'Reference to the store associate or personal stylist who conducted the clienteling interaction.',
    `bopis_appointment_id` BIGINT COMMENT 'Foreign key linking to fulfillment.bopis_appointment. Business justification: High-touch retail clienteling frequently involves associates scheduling BOPIS appointments for VIP members during personal shopping sessions. Direct link enables attribution of appointments to cliente',
    `campaign_id` BIGINT COMMENT 'Reference to the marketing or clienteling campaign that prompted or is associated with this interaction, enabling campaign effectiveness measurement.',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.store_department. Business justification: Clienteling sessions occur in specific departments (beauty, jewelry, apparel) where associates provide personalized service. Retail operations track interaction location at department level for associ',
    `header_id` BIGINT COMMENT 'Foreign key linking to order.order_header. Business justification: Associates create orders during clienteling sessions (phone, chat, assisted in-store); linking interaction to resulting order tracks conversion rates, associate performance, and personalized service R',
    `location_id` BIGINT COMMENT 'Reference to the store location where the clienteling interaction occurred, if applicable.',
    `loyalty_membership_id` BIGINT COMMENT 'Reference to the loyalty program member who participated in this clienteling interaction.',
    `member_offer_id` BIGINT COMMENT 'Foreign key linking to loyalty.member_offer. Business justification: Clienteling interactions often discuss specific personalized offers with members. Adding offer_id FK allows tracking which offers were presented or discussed during high-touch interactions. No columns',
    `pos_transaction_id` BIGINT COMMENT 'Reference to the Point of Sale (POS) transaction or order that resulted from this clienteling interaction, if a purchase was made.',
    `profile_id` BIGINT COMMENT 'Reference to the customer profile associated with this interaction, enabling unified customer view across domains.',
    `web_session_id` BIGINT COMMENT 'Foreign key linking to ecommerce.web_session. Business justification: Clienteling associates may initiate or reference online sessions during customer interactions (e.g., assisted browsing, virtual appointments); linking enables unified customer journey tracking across',
    `appointment_scheduled_flag` BOOLEAN COMMENT 'Boolean indicator of whether a future appointment or styling session was scheduled as an outcome of this interaction.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this clienteling interaction record was first created in the system, supporting audit trail and data lineage requirements.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code representing the currency in which the interaction value amount is denominated.. Valid values are `^[A-Z]{3}$`',
    `customer_sentiment` STRING COMMENT 'Associate assessment of the customer sentiment or satisfaction level during and at the conclusion of the interaction, used for experience quality monitoring.. Valid values are `very_positive|positive|neutral|negative|very_negative`',
    `follow_up_action_required` BOOLEAN COMMENT 'Boolean indicator of whether a follow-up action or future touchpoint has been scheduled or is required as a result of this interaction.',
    `follow_up_action_type` STRING COMMENT 'Classification of the type of follow-up action scheduled or recommended as a next step in the customer relationship journey. [ENUM-REF-CANDIDATE: call_back|send_email|send_text|schedule_appointment|product_arrival_notification|event_invitation|thank_you_note|none — 8 candidates stripped; promote to reference product]',
    `follow_up_completed_flag` BOOLEAN COMMENT 'Boolean indicator of whether the scheduled follow-up action has been completed, supporting task closure and workflow management.',
    `follow_up_due_date` DATE COMMENT 'The target date by which the scheduled follow-up action should be completed, used for task management and associate performance tracking.',
    `interaction_channel` STRING COMMENT 'The communication channel or touchpoint through which the clienteling interaction was conducted, supporting omnichannel engagement analysis. [ENUM-REF-CANDIDATE: in_store|phone|email|sms|video_call|mobile_app|web_chat|social_media — 8 candidates stripped; promote to reference product]',
    `interaction_date` DATE COMMENT 'The calendar date on which the clienteling interaction occurred, used for temporal analysis and engagement frequency tracking.',
    `interaction_duration_minutes` STRING COMMENT 'The total duration of the clienteling interaction measured in minutes, used to assess engagement depth and associate time investment.',
    `interaction_initiated_by` STRING COMMENT 'Indicator of who or what initiated the clienteling interaction, distinguishing between proactive associate outreach, customer-initiated contact, and system-triggered engagements.. Valid values are `associate|customer|system_triggered|event_invitation|campaign`',
    `interaction_location_type` STRING COMMENT 'Classification of the physical or virtual location where the clienteling interaction took place, providing context for the service environment. [ENUM-REF-CANDIDATE: store_floor|private_styling_room|vip_lounge|customer_home|virtual|phone|other — 7 candidates stripped; promote to reference product]',
    `interaction_notes` STRING COMMENT 'Detailed free-text notes recorded by the associate documenting the conversation, customer feedback, special requests, and any other relevant context from the interaction.',
    `interaction_number` STRING COMMENT 'Business-facing unique identifier for the clienteling interaction, used for tracking and reference in customer service and reporting contexts.. Valid values are `^CI-[0-9]{10}$`',
    `interaction_outcome` STRING COMMENT 'The business result or action taken as a consequence of the clienteling interaction, used to measure interaction effectiveness and conversion. [ENUM-REF-CANDIDATE: purchase_made|appointment_booked|wishlist_updated|product_reserved|no_action|referral_provided|feedback_collected|complaint_resolved — 8 candidates stripped; promote to reference product]',
    `interaction_status` STRING COMMENT 'Current lifecycle status of the clienteling interaction, tracking progression from scheduling through completion or cancellation.. Valid values are `scheduled|in_progress|completed|cancelled|no_show|rescheduled`',
    `interaction_timestamp` TIMESTAMP COMMENT 'The precise date and time when the clienteling interaction began, capturing the exact moment of engagement for detailed analytics and associate performance tracking.',
    `interaction_type` STRING COMMENT 'Classification of the clienteling interaction method and purpose, indicating the nature of the personalized engagement with the loyalty member. [ENUM-REF-CANDIDATE: in_store_consultation|outbound_call|personal_styling_session|vip_event_invitation|product_launch_preview|thank_you_note|anniversary_outreach|birthday_outreach|follow_up_call|virtual_consultation|email_outreach|text_message_outreach — 12 candidates stripped; promote to reference product]',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this clienteling interaction record was most recently updated, supporting change tracking and audit compliance.',
    `member_preferences_discussed` STRING COMMENT 'Free-text notes capturing customer preferences, style interests, size information, color preferences, brand affinities, and other personalization details discussed during the interaction.',
    `next_appointment_date` DATE COMMENT 'The scheduled date for the next clienteling appointment or interaction with this customer, supporting relationship continuity and engagement planning.',
    `nps_score` STRING COMMENT 'Net Promoter Score (NPS) rating provided by the customer following the interaction, on a scale of 0-10, measuring likelihood to recommend based on the personalized service experience.',
    `products_purchased` STRING COMMENT 'Comma-separated list of Stock Keeping Unit (SKU) codes for products actually purchased as a result of this interaction, enabling recommendation-to-purchase conversion tracking.',
    `products_recommended` STRING COMMENT 'Comma-separated list of Stock Keeping Unit (SKU) codes for products recommended to the customer during the interaction, supporting product affinity and recommendation effectiveness analysis.',
    `purchase_made_flag` BOOLEAN COMMENT 'Boolean indicator of whether the clienteling interaction resulted in an immediate purchase transaction, supporting conversion rate analysis.',
    `total_interaction_value_amount` DECIMAL(18,2) COMMENT 'The total monetary value of purchases made as a direct result of this clienteling interaction, measured in the store operating currency, used to calculate clienteling Return on Investment (ROI).',
    `vip_tier_at_interaction` STRING COMMENT 'The loyalty program tier or VIP status of the member at the time of the interaction, enabling tier-specific engagement analysis and service level tracking.',
    CONSTRAINT pk_clienteling_interaction PRIMARY KEY(`clienteling_interaction_id`)
) COMMENT 'Records personalized high-touch interactions between store associates and loyalty members, primarily for top-tier and high-value customers in department store and specialty retail contexts. Captures interaction type (in-store consultation, outbound call, personal styling session, VIP event invitation, product launch preview, thank-you note, anniversary outreach), associate reference, store location, date/duration, member preferences discussed, products recommended (SKU references), follow-up actions scheduled with due dates, interaction outcome (purchase made, appointment booked, wishlist updated, no action), and sentiment/satisfaction indicator. Supports relationship-based selling strategies, drives incremental CLTV through personalized service, and provides associate performance data for workforce domain integration.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`member_segment` (
    `member_segment_id` BIGINT COMMENT 'Unique identifier for the loyalty member segment. Primary key.',
    `loyalty_program_id` BIGINT COMMENT 'Reference to the loyalty program this segment belongs to. Enables multi-program segmentation strategies.',
    `audience_segment_id` BIGINT COMMENT 'Foreign key linking to marketing.audience_segment. Business justification: Retail operations synchronize loyalty member segments with marketing audience segments for coordinated targeting across channels. Marketers need to activate loyalty segments in paid media, email, and',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Member segments require business owner associates for strategy ownership, campaign planning, and segment performance accountability. Replaces denormalized segment_owner string with proper FK for organ',
    `approved_by` STRING COMMENT 'User ID or name of the person who approved this segment for production use. Null for segments not requiring approval. Supports governance and compliance.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this segment was approved for production use. Null for segments not requiring approval. Supports governance audit trail.',
    `assignment_method` STRING COMMENT 'Method used to assign members to this segment: rule-based (deterministic business rules), ml_model (machine learning model prediction), manual (analyst-driven assignment), hybrid (combination of automated and manual).. Valid values are `rule_based|ml_model|manual|hybrid`',
    `average_annual_spend` DECIMAL(18,2) COMMENT 'Average annual spend (trailing 12 months) of members in this segment. Used for spend-based segmentation validation and campaign ROI forecasting. Currency implied by program configuration.',
    `average_ltv` DECIMAL(18,2) COMMENT 'Average Customer Lifetime Value (CLTV) of members in this segment. Calculated metric used for segment value ranking and ROI analysis. Currency implied by program configuration.',
    `average_points_balance` DECIMAL(18,2) COMMENT 'Average loyalty points balance across all members in this segment. Used for points liability forecasting and segment value analysis.',
    `business_justification` STRING COMMENT 'Business rationale and expected outcomes for creating this segment. Documents strategic intent, target KPIs, and success criteria. Supports segment portfolio governance and ROI tracking.',
    `campaign_eligibility_flag` BOOLEAN COMMENT 'Boolean flag indicating whether members in this segment are eligible for targeted marketing campaigns. False may indicate test segments or internal analytical segments not intended for outbound communication.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this segment definition was first created in the system. Supports audit trail and lifecycle tracking.',
    `definition_criteria` STRING COMMENT 'Business rules or criteria defining segment membership. May be SQL-like expression, natural language rule description, or reference to external rule engine configuration. Examples: Points earned > 5000 in last 90 days AND redemption count >= 2, RFM score R>=4 AND F>=3.',
    `effective_end_date` DATE COMMENT 'Date after which this segment definition is no longer active. Null for open-ended segments. Supports time-bound seasonal or campaign-specific segments.',
    `effective_start_date` DATE COMMENT 'Date from which this segment definition becomes active and eligible for member assignment and campaign targeting. Supports future-dated segment launches.',
    `is_exclusive` BOOLEAN COMMENT 'Boolean flag indicating whether members can belong to only this segment (true) or can be assigned to multiple segments simultaneously (false). Supports mutually exclusive vs. overlapping segmentation strategies.',
    `last_refresh_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent segment membership refresh execution. Used to monitor data freshness and SLA compliance.',
    `lifecycle_stage` STRING COMMENT 'Member lifecycle stage classification: new (recently enrolled), active (regular activity), engaged (high interaction), at-risk (declining activity), lapsed (inactive period), dormant (extended inactivity), win-back (re-engagement target), churned (permanently inactive). [ENUM-REF-CANDIDATE: new|active|engaged|at_risk|lapsed|dormant|win_back|churned — 8 candidates stripped; promote to reference product]',
    `member_count` BIGINT COMMENT 'Current count of loyalty members assigned to this segment. Updated with each segment refresh cycle. Used for campaign sizing and ROI forecasting.',
    `minimum_confidence_score` DECIMAL(18,2) COMMENT 'Minimum confidence threshold (0.0000 to 1.0000) required for ML-based segment assignment. Members with confidence scores below this threshold are not assigned to the segment. Null for rule-based segments.',
    `ml_model_reference` STRING COMMENT 'Reference identifier to the ML model used for segment assignment (e.g., model name, version, registry URI). Null for non-ML-based segments. Enables model lineage tracking and reproducibility.',
    `ml_model_version` STRING COMMENT 'Version identifier of the ML model used for segment assignment. Supports model versioning and A/B testing of segmentation strategies.',
    `modified_by` STRING COMMENT 'User ID or name of the person who last modified this segment definition. Supports audit trail and change management.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this segment definition was last modified. Supports audit trail and change tracking.',
    `next_refresh_timestamp` TIMESTAMP COMMENT 'Scheduled timestamp for the next segment membership refresh. Null for on-demand segments. Supports proactive monitoring and capacity planning.',
    `notes` STRING COMMENT 'Free-form notes and comments about this segment. Used for documenting business context, performance observations, or operational considerations.',
    `offer_eligibility_flag` BOOLEAN COMMENT 'Boolean flag indicating whether members in this segment are eligible for personalized offers and promotions. Supports offer targeting and exclusion rules.',
    `priority_rank` STRING COMMENT 'Numeric priority ranking for segment assignment when a member qualifies for multiple segments. Lower numbers indicate higher priority. Used to resolve segment overlap conflicts.',
    `refresh_frequency` STRING COMMENT 'Frequency at which segment membership is recalculated and updated: real-time (streaming), hourly, daily, weekly, monthly, quarterly, or on-demand (manual trigger). [ENUM-REF-CANDIDATE: real_time|hourly|daily|weekly|monthly|quarterly|on_demand — 7 candidates stripped; promote to reference product]',
    `segment_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the segment within the program (e.g., HIGH_VALUE_FREQ, AT_RISK_30D). Used in campaign targeting and reporting.. Valid values are `^[A-Z0-9_]{3,20}$`',
    `segment_description` STRING COMMENT 'Detailed business description of the segment purpose, target audience characteristics, and intended use cases for marketing and engagement strategies.',
    `segment_name` STRING COMMENT 'Human-readable name of the segment (e.g., High-Value Frequent Shoppers, At-Risk Members). Used in business reporting and campaign management interfaces.',
    `segment_status` STRING COMMENT 'Current operational status of the segment definition: active (in use for targeting), inactive (temporarily disabled), archived (historical reference only), draft (under development), pending approval (awaiting business sign-off).. Valid values are `active|inactive|archived|draft|pending_approval`',
    `segment_type` STRING COMMENT 'Classification of the segmentation methodology: RFM (Recency Frequency Monetary) based, spend-based, lifecycle stage (new/active/at-risk/lapsed/win-back), engagement-based, redemption behavior, or channel preference.. Valid values are `rfm_based|spend_based|lifecycle_stage|engagement_based|redemption_behavior|channel_preference`',
    `tags` STRING COMMENT 'Comma-separated list of business tags or labels for segment categorization and search (e.g., high-value, seasonal, test, omnichannel). Supports flexible segment discovery and reporting.',
    `target_member_count` BIGINT COMMENT 'Target or expected member count for this segment based on business planning. Used to monitor segment size drift and validate segmentation model performance.',
    `tier_qualification_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this segment is used for loyalty tier qualification or upgrade/downgrade decisions. True for segments that drive tier movement logic.',
    `created_by` STRING COMMENT 'User ID or name of the person who created this segment definition. Supports audit trail and accountability.',
    CONSTRAINT pk_member_segment PRIMARY KEY(`member_segment_id`)
) COMMENT 'Defines loyalty-specific behavioral segments and manages member-to-segment assignments for targeted offers, campaign eligibility, and tier management. Captures segment name, type (RFM-based, spend-based, lifecycle stage: new/active/at-risk/lapsed/win-back), definition criteria (rules or ML model reference), program association, segment size/member count, refresh frequency and last refresh timestamp, and individual member assignments with assignment method (rule-based, manual, ML-model), confidence score, effective/expiry dates, and override flag. Distinct from customer domain demographic segments — these are loyalty-program-specific behavioral cohorts derived exclusively from program activity data (points velocity, redemption patterns, engagement frequency).';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`partner_program` (
    `partner_program_id` BIGINT COMMENT 'Unique identifier for the coalition or partner loyalty arrangement. Primary key.',
    `loyalty_program_id` BIGINT COMMENT 'Reference to the parent loyalty program that this partner arrangement is associated with. Links to the core loyalty program master.',
    `third_party_assessment_id` BIGINT COMMENT 'Foreign key linking to compliance.third_party_assessment. Business justification: Partner programs sharing customer loyalty data or processing payments require third-party compliance assessments for data protection, PCI-DSS, and contractual obligations. Retail compliance teams asse',
    `api_endpoint_url` STRING COMMENT 'Base URL for the partner API endpoint used for real-time transaction posting and member validation. Confidential technical integration detail.',
    `auto_enrollment_flag` BOOLEAN COMMENT 'Indicates whether loyalty program members are automatically enrolled in this partner program or must opt-in explicitly.',
    `contract_renewal_date` DATE COMMENT 'Date when the partner program contract is scheduled for renewal or renegotiation. Used for relationship management and planning.',
    `cost_per_point_earned` DECIMAL(18,2) COMMENT 'Cost to the retailer for each loyalty point earned by members at the partner location. Used for financial liability tracking and program ROI analysis.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this partner program record was first created in the system. Used for audit trail and data lineage.',
    `data_sharing_agreement_reference` STRING COMMENT 'Reference number or identifier for the legal data sharing agreement governing member data exchange between the retailer and partner. Required for GDPR and CCPA compliance.',
    `earn_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the currency in which partner transactions are denominated for points accrual calculation.. Valid values are `^[A-Z]{3}$`',
    `earn_rate_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to base loyalty points when members make purchases at the partner. For example, 1.5 means members earn 1.5x points per dollar spent at partner locations.',
    `effective_end_date` DATE COMMENT 'Date when the partner program arrangement expires or terminates. Nullable for open-ended partnerships.',
    `effective_start_date` DATE COMMENT 'Date when the partner program arrangement becomes active and members can begin earning or redeeming points with the partner.',
    `exclusion_rules` STRING COMMENT 'Business rules defining product categories, transaction types, or conditions that are excluded from points earning or redemption at the partner (e.g., gift cards, alcohol, tobacco).',
    `geographic_scope` STRING COMMENT 'Geographic regions or countries where the partner program is available to members. Pipe-separated list of ISO 3166-1 alpha-3 country codes or region descriptors.',
    `integration_method` STRING COMMENT 'Technical integration approach used to exchange transaction and member data between the retailer and partner systems.. Valid values are `api_realtime|batch_edi|file_transfer|manual|pos_integration|web_service`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this partner program record was last updated. Used for audit trail and change tracking.',
    `last_reconciliation_date` DATE COMMENT 'Date of the most recent financial reconciliation and settlement between the retailer and partner for points earned and redeemed.',
    `maximum_earn_per_transaction` DECIMAL(18,2) COMMENT 'Cap on the number of loyalty points that can be earned in a single transaction at the partner. Nullable if no cap applies.',
    `member_communication_allowed_flag` BOOLEAN COMMENT 'Indicates whether the partner is permitted to send marketing communications directly to loyalty program members under the data sharing agreement.',
    `member_eligibility_criteria` STRING COMMENT 'Business rules or criteria defining which loyalty program members are eligible to participate in this partner program (e.g., tier requirements, geographic restrictions, age limits).',
    `minimum_transaction_amount` DECIMAL(18,2) COMMENT 'Minimum purchase amount required at the partner location for the transaction to qualify for loyalty points accrual. Nullable if no minimum applies.',
    `modified_by_user` STRING COMMENT 'Identifier of the user or system process that last modified this partner program record. Used for audit trail and accountability.',
    `partner_code` STRING COMMENT 'Externally-known unique code identifying the partner program for integration and operational reference. Used in API calls, EDI transactions, and partner communications.. Valid values are `^[A-Z0-9]{3,20}$`',
    `partner_contact_email` STRING COMMENT 'Email address of the primary business contact at the partner organization. Used for operational communications and issue resolution.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `partner_contact_name` STRING COMMENT 'Name of the primary business contact at the partner organization responsible for the loyalty program relationship.',
    `partner_contact_phone` STRING COMMENT 'Phone number of the primary business contact at the partner organization. Used for operational communications and issue resolution.',
    `partner_name` STRING COMMENT 'Legal or trading name of the coalition partner organization (e.g., airline, hotel chain, fuel retailer, financial institution).',
    `partner_status` STRING COMMENT 'Current lifecycle status of the partner program arrangement. Controls whether members can earn or redeem points with this partner.. Valid values are `active|inactive|suspended|pending_approval|terminated|pilot`',
    `partner_type` STRING COMMENT 'Classification of the partner organization by industry vertical or business category. Determines applicable earn and redemption rules. [ENUM-REF-CANDIDATE: airline|hotel|fuel_retailer|financial_institution|restaurant|entertainment|travel|ecommerce|telecom|other — 10 candidates stripped; promote to reference product]',
    `performance_sla_target` STRING COMMENT 'Service Level Agreement (SLA) performance targets for the partner integration, such as API uptime percentage, transaction processing time, or data accuracy thresholds.',
    `promotional_bonus_eligible_flag` BOOLEAN COMMENT 'Indicates whether this partner program is eligible for promotional bonus point campaigns and limited-time earn rate multipliers.',
    `redeem_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the currency in which partner redemptions are valued and settled.. Valid values are `^[A-Z]{3}$`',
    `redeem_rate_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied when members redeem loyalty points for partner rewards or services. Determines the value conversion rate from points to partner currency.',
    `revenue_per_point_redeemed` DECIMAL(18,2) COMMENT 'Revenue received by the retailer for each loyalty point redeemed by members for partner rewards. Used for financial settlement and program ROI analysis.',
    `settlement_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the currency in which financial settlements between the retailer and partner are conducted.. Valid values are `^[A-Z]{3}$`',
    `settlement_frequency` STRING COMMENT 'Frequency at which financial settlements for points earned or redeemed are reconciled and settled between the retailer and partner.. Valid values are `daily|weekly|biweekly|monthly|quarterly|on_demand`',
    `termination_notice_days` STRING COMMENT 'Number of days advance notice required by either party to terminate the partner program arrangement, as specified in the contract.',
    CONSTRAINT pk_partner_program PRIMARY KEY(`partner_program_id`)
) COMMENT 'Master record for coalition or partner loyalty arrangements where members can earn or redeem points with external partners (airlines, hotels, fuel retailers, financial partners). Captures partner name, partner type, program association, earn rate at partner, redeem rate at partner, data sharing agreement reference, integration method (API, batch EDI), partner program code, and active status. Supports omnichannel loyalty recognition beyond the retailers own touchpoints.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` (
    `partner_transaction_id` BIGINT COMMENT 'Unique identifier for the partner transaction record. Primary key.',
    `campaign_id` BIGINT COMMENT 'Reference to the marketing campaign or promotion that drove this partner transaction, if applicable.',
    `loyalty_membership_id` BIGINT COMMENT 'Reference to the loyalty program member who earned or redeemed points through this partner transaction.',
    `original_transaction_partner_transaction_id` BIGINT COMMENT 'Reference to the original partner transaction that this record reverses or adjusts.',
    `partner_program_id` BIGINT COMMENT 'Reference to the coalition partner program through which this transaction was executed.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Partner transactions require GL account mapping for settlement accounting. Partner commissions, points purchases from partners, and reconciliation entries all flow through specific GL accounts. Requir',
    `amount` DECIMAL(18,2) COMMENT 'Monetary value of the transaction at the partner location before points conversion.',
    `bonus_points` DECIMAL(18,2) COMMENT 'Additional promotional or campaign-driven bonus points awarded on top of base points for this transaction.',
    `commission_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the partner commission amount.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this partner transaction record was first created in the loyalty system.',
    `dispute_flag` BOOLEAN COMMENT 'Indicates whether this transaction is under dispute between the retailer and coalition partner.',
    `dispute_reason` STRING COMMENT 'Description of the reason for dispute if the transaction is flagged for dispute resolution.',
    `member_tier_at_transaction` STRING COMMENT 'Loyalty program tier level of the member at the time of this transaction, used for tier-based points calculation.',
    `notes` STRING COMMENT 'Free-text notes or comments related to this partner transaction for operational or audit purposes.',
    `partner_category` STRING COMMENT 'Business category or industry vertical of the coalition partner (e.g., travel, dining, fuel, entertainment).',
    `partner_commission_amount` DECIMAL(18,2) COMMENT 'Commission or interchange fee paid to or received from the coalition partner for this transaction.',
    `partner_file_batch_number` STRING COMMENT 'Identifier of the partner data file or Electronic Data Interchange (EDI) batch that contained this transaction record.',
    `partner_location_code` STRING COMMENT 'Code identifying the specific partner location or outlet where the transaction occurred.',
    `partner_merchant_code` STRING COMMENT 'Unique merchant identifier assigned by the partner organization for transaction tracking.',
    `points_awarded` DECIMAL(18,2) COMMENT 'Number of loyalty points awarded to the member for this partner transaction. Positive for earn transactions, zero for redemptions.',
    `points_expiry_date` DATE COMMENT 'Date when the points awarded in this transaction will expire if not redeemed.',
    `points_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to the base points calculation for promotional or tier-based bonus points.',
    `points_redeemed` DECIMAL(18,2) COMMENT 'Number of loyalty points deducted from the member account for this partner redemption transaction. Positive for redemptions, zero for earn transactions.',
    `reconciliation_date` DATE COMMENT 'Date when the partner transaction was successfully reconciled with partner records.',
    `reconciliation_status` STRING COMMENT 'Status of the reconciliation process between internal records and partner-provided transaction data.. Valid values are `matched|unmatched|disputed|resolved`',
    `reference` STRING COMMENT 'External transaction reference number provided by the coalition partner system for reconciliation and audit purposes.',
    `reversal_reason_code` STRING COMMENT 'Code indicating the reason for transaction reversal or cancellation, if applicable.',
    `reversal_timestamp` TIMESTAMP COMMENT 'Timestamp when the transaction was reversed or cancelled.',
    `settlement_batch_number` STRING COMMENT 'Reference to the financial settlement batch in which this partner transaction was reconciled and settled.',
    `settlement_date` DATE COMMENT 'Date when the partner transaction was financially settled between the retailer and coalition partner.',
    `transaction_channel` STRING COMMENT 'Channel through which the partner transaction was initiated by the member.. Valid values are `in_store|online|mobile_app|call_center|kiosk`',
    `transaction_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the partner transaction amount.. Valid values are `^[A-Z]{3}$`',
    `transaction_date` DATE COMMENT 'Date when the transaction occurred at the partner location or platform.',
    `transaction_status` STRING COMMENT 'Current processing status of the partner transaction in the reconciliation workflow.. Valid values are `pending|confirmed|rejected|cancelled`',
    `transaction_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the transaction was executed at the partner system, including time zone information.',
    `transaction_type` STRING COMMENT 'Type of partner transaction indicating whether points were earned, redeemed, reversed, or adjusted.. Valid values are `earn|redemption|reversal|adjustment`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this partner transaction record was last modified in the loyalty system.',
    CONSTRAINT pk_partner_transaction PRIMARY KEY(`partner_transaction_id`)
) COMMENT 'Transactional record of points earned or redeemed by a loyalty member through a coalition partner. Captures membership reference, partner program reference, transaction date, transaction amount at partner, points awarded or deducted, partner transaction reference number, processing status (pending, confirmed, rejected), and settlement batch reference. Enables reconciliation of partner-sourced points and supports coalition billing.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`referral` (
    `referral_id` BIGINT COMMENT 'Unique identifier for the referral transaction. Primary key for the referral data product.',
    `associate_id` BIGINT COMMENT 'Identifier of the store associate who facilitated the referral or enrollment. Used for associate performance tracking and commission attribution.',
    `campaign_id` BIGINT COMMENT 'Identifier of the engagement campaign associated with this referral. Links referral activity to specific marketing initiatives and promotional periods.',
    `header_id` BIGINT COMMENT 'Foreign key linking to order.order_header. Business justification: Referral programs require linking referees qualifying first order to automate reward fulfillment, validate qualification criteria, detect fraud, and measure referral campaign ROI—standard retail loya',
    `location_id` BIGINT COMMENT 'Identifier of the store location where the referral was initiated or where the referred individual enrolled. Null for digital-only referrals.',
    `originating_referral_id` BIGINT COMMENT 'Self-referencing FK on referral (originating_referral_id)',
    `loyalty_membership_id` BIGINT COMMENT 'Identifier of the loyalty program member who initiated the referral. Links to the member who is advocating for the program.',
    `profile_id` BIGINT COMMENT 'Identifier of the customer who was referred. May be null if the referred individual has not yet enrolled or been matched to a customer record.',
    `web_session_id` BIGINT COMMENT 'Foreign key linking to ecommerce.web_session. Business justification: Referral conversions often occur through web sessions (referral link clicks, enrollment flows); tracking the session enables attribution of referral-driven online enrollments and purchases, referral c',
    `channel` STRING COMMENT 'Channel through which the referral was shared by the referring member. Tracks the medium used for advocacy. [ENUM-REF-CANDIDATE: email|sms|social_media|unique_link|in_store|mobile_app|direct_mail — 7 candidates stripped; promote to reference product]',
    `referral_code` STRING COMMENT 'Unique alphanumeric code assigned to the referring member for tracking referral activity. Used by the referred individual during enrollment or first purchase.. Valid values are `^[A-Z0-9]{6,12}$`',
    `conversion_status` STRING COMMENT 'Current lifecycle status of the referral. Tracks progression from initial referral through enrollment, qualification, and reward fulfillment.. Valid values are `pending|enrolled|qualified|rewarded|expired|declined`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this referral record was first created in the system. Used for audit trail and data lineage tracking.',
    `enrollment_date` DATE COMMENT 'Date when the referred individual successfully enrolled in the loyalty program. Null if enrollment has not yet occurred.',
    `expiry_date` DATE COMMENT 'Date when the referral code or offer expires. After this date, the referral is no longer valid for qualification or reward issuance.',
    `first_purchase_amount` DECIMAL(18,2) COMMENT 'Total monetary value of the first purchase made by the referred individual. Used to evaluate referral quality and program ROI.',
    `first_purchase_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the first purchase amount. Supports multi-currency loyalty program operations.. Valid values are `^[A-Z]{3}$`',
    `first_purchase_date` DATE COMMENT 'Date when the referred individual completed their first purchase. Used to track conversion from enrollment to active customer status.',
    `fraud_detection_score` DECIMAL(18,2) COMMENT 'Numeric score from fraud detection algorithms indicating the likelihood of fraudulent referral activity. Higher scores indicate greater fraud risk.',
    `fraud_flag` BOOLEAN COMMENT 'Indicates whether this referral has been flagged for potential fraudulent activity. True if fraud is suspected, false otherwise.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this referral record was most recently updated. Tracks the latest change to any attribute for audit and reconciliation purposes.',
    `notes` STRING COMMENT 'Free-text notes capturing additional context about the referral. May include special circumstances, customer feedback, or operational observations.',
    `qualification_criteria` STRING COMMENT 'Description of the business rules that must be satisfied for the referral to qualify for rewards. Examples include first purchase threshold, enrollment completion, or minimum spend amount.',
    `qualification_date` DATE COMMENT 'Date when the referral met all qualification criteria for reward eligibility. Null if qualification has not been achieved.',
    `qualification_met_flag` BOOLEAN COMMENT 'Indicates whether the referred individual has satisfied all qualification criteria. True when qualification is complete, false otherwise.',
    `referee_reward_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for monetary rewards granted to the referred individual. Null for non-monetary rewards.. Valid values are `^[A-Z]{3}$`',
    `referee_reward_date` DATE COMMENT 'Date when the reward was granted to the referred individual. Null if the reward has not yet been issued.',
    `referee_reward_type` STRING COMMENT 'Type of reward granted to the referred individual upon enrollment or first purchase. Incentivizes new member acquisition.. Valid values are `welcome_bonus|bonus_points|discount_voucher|gift_card|free_shipping|merchandise`',
    `referee_reward_value` DECIMAL(18,2) COMMENT 'Monetary or points value of the reward granted to the referred individual. Denominated in points or currency depending on reward type.',
    `referral_date` DATE COMMENT 'Date when the referral was initiated by the referring member. Represents the business event timestamp for the referral action.',
    `referral_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the referral was created in the system. Captures the exact moment of referral initiation for audit and sequencing purposes.',
    `referrer_reward_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for monetary rewards granted to the referring member. Null for non-monetary rewards such as points or tier credits.. Valid values are `^[A-Z]{3}$`',
    `referrer_reward_date` DATE COMMENT 'Date when the reward was granted to the referring member. Null if the reward has not yet been issued.',
    `referrer_reward_type` STRING COMMENT 'Type of reward granted to the referring member upon successful referral qualification. Defines the incentive structure for advocacy.. Valid values are `bonus_points|tier_credit|gift_card|discount_voucher|cash_back|merchandise`',
    `referrer_reward_value` DECIMAL(18,2) COMMENT 'Monetary or points value of the reward granted to the referring member. Denominated in points or currency depending on reward type.',
    `source` STRING COMMENT 'Detailed source attribution for the referral. May include specific social media platform, email campaign identifier, or in-store associate identifier.',
    `viral_coefficient_contribution` DECIMAL(18,2) COMMENT 'Calculated metric representing this referrals contribution to program viral growth. Measures the multiplier effect of member advocacy on program enrollment.',
    CONSTRAINT pk_referral PRIMARY KEY(`referral_id`)
) COMMENT 'Tracks member-to-member referral activity within loyalty programs. Captures referring member, referred individual, referral channel (in-store, email, social media, unique link), referral code, referral date, conversion status (pending, enrolled, qualified, rewarded), qualification criteria (e.g., referred member must make first purchase), reward type for referrer (bonus points, tier credit, gift card), reward type for referee (welcome bonus), referral campaign association, and expiry date. Supports refer-a-friend programs, social advocacy tracking, and program growth attribution. Drives referral-sourced enrollment KPIs and program viral coefficient measurement.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`campaign_storefront_deployment` (
    `campaign_storefront_deployment_id` BIGINT COMMENT 'Unique identifier for this campaign-storefront deployment record. Primary key.',
    `engagement_campaign_id` BIGINT COMMENT 'Foreign key linking to the loyalty engagement campaign being deployed',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to the digital storefront where the campaign is deployed',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this campaign-storefront deployment record was created in the system.',
    `deployment_status` STRING COMMENT 'Current lifecycle status of this campaign deployment on this storefront. Scheduled indicates pre-launch; active indicates currently running; paused indicates temporarily suspended; completed indicates successfully concluded; cancelled indicates terminated before completion.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this deployment record was last modified, typically updated as performance metrics are refreshed.',
    `storefront_budget_allocation` DECIMAL(18,2) COMMENT 'The portion of the campaigns total budget allocated to this specific storefront, used for channel-specific promotional spend, incentives, or advertising.',
    `storefront_conversion_rate` DECIMAL(18,2) COMMENT 'The conversion rate (percentage) of enrolled members who became active participants on this specific storefront, calculated as (storefront_participation_count / storefront_enrollment_count) * 100.',
    `storefront_end_date` DATE COMMENT 'The date when this campaign concluded on this specific storefront. May differ from the campaigns global end_date to accommodate storefront-specific timing strategies.',
    `storefront_enrollment_count` STRING COMMENT 'The number of members who enrolled or opted into the campaign through this specific storefront channel.',
    `storefront_launch_date` DATE COMMENT 'The date when this campaign was launched on this specific storefront. May differ from the campaigns global start_date to accommodate storefront-specific timing strategies.',
    `storefront_participation_count` STRING COMMENT 'The number of members who actively participated in the campaign (completed qualifying actions) through this specific storefront channel.',
    CONSTRAINT pk_campaign_storefront_deployment PRIMARY KEY(`campaign_storefront_deployment_id`)
) COMMENT 'This association product represents the deployment of a loyalty engagement campaign to a specific digital storefront. It captures storefront-specific campaign configuration, launch timing, budget allocation, and performance metrics that exist only in the context of this campaign-storefront pairing. Each record links one engagement_campaign to one storefront with attributes tracking how that campaign performs on that specific channel.. Existence Justification: Loyalty engagement campaigns are deployed across multiple digital storefronts simultaneously as part of omnichannel marketing strategies, and each storefront hosts multiple campaigns concurrently. The business actively manages campaign-storefront deployments as operational entities, tracking storefront-specific launch timing, budget allocation, enrollment counts, participation metrics, and conversion rates. This is not an analytical correlation but an operational business process where campaign managers deploy campaigns TO storefronts and monitor performance BY storefront.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ADD CONSTRAINT `fk_loyalty_loyalty_membership_tier_id` FOREIGN KEY (`tier_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`tier`(`tier_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ADD CONSTRAINT `fk_loyalty_loyalty_membership_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ADD CONSTRAINT `fk_loyalty_loyalty_membership_referred_by_member_loyalty_membership_id` FOREIGN KEY (`referred_by_member_loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ADD CONSTRAINT `fk_loyalty_tier_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ADD CONSTRAINT `fk_loyalty_tier_prior_tier_id` FOREIGN KEY (`prior_tier_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`tier`(`tier_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_accrual_rule_id` FOREIGN KEY (`accrual_rule_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`accrual_rule`(`accrual_rule_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_partner_transaction_id` FOREIGN KEY (`partner_transaction_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`partner_transaction`(`partner_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_points_loyalty_membership_id` FOREIGN KEY (`points_loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_redemption_id` FOREIGN KEY (`redemption_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`redemption`(`redemption_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_redemption_rule_id` FOREIGN KEY (`redemption_rule_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`redemption_rule`(`redemption_rule_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_reversal_reference_points_ledger_id` FOREIGN KEY (`reversal_reference_points_ledger_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`points_ledger`(`points_ledger_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_member_offer_id` FOREIGN KEY (`member_offer_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`member_offer`(`member_offer_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_partner_program_id` FOREIGN KEY (`partner_program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`partner_program`(`partner_program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_redemption_rule_id` FOREIGN KEY (`redemption_rule_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`redemption_rule`(`redemption_rule_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_reward_id` FOREIGN KEY (`reward_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`reward`(`reward_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ADD CONSTRAINT `fk_loyalty_member_offer_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ADD CONSTRAINT `fk_loyalty_member_offer_member_segment_id` FOREIGN KEY (`member_segment_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`member_segment`(`member_segment_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ADD CONSTRAINT `fk_loyalty_member_offer_reward_id` FOREIGN KEY (`reward_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`reward`(`reward_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ADD CONSTRAINT `fk_loyalty_engagement_campaign_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ADD CONSTRAINT `fk_loyalty_engagement_campaign_member_segment_id` FOREIGN KEY (`member_segment_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`member_segment`(`member_segment_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ADD CONSTRAINT `fk_loyalty_clienteling_interaction_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ADD CONSTRAINT `fk_loyalty_clienteling_interaction_member_offer_id` FOREIGN KEY (`member_offer_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`member_offer`(`member_offer_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ADD CONSTRAINT `fk_loyalty_member_segment_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` ADD CONSTRAINT `fk_loyalty_partner_program_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ADD CONSTRAINT `fk_loyalty_partner_transaction_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ADD CONSTRAINT `fk_loyalty_partner_transaction_original_transaction_partner_transaction_id` FOREIGN KEY (`original_transaction_partner_transaction_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`partner_transaction`(`partner_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ADD CONSTRAINT `fk_loyalty_partner_transaction_partner_program_id` FOREIGN KEY (`partner_program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`partner_program`(`partner_program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ADD CONSTRAINT `fk_loyalty_referral_originating_referral_id` FOREIGN KEY (`originating_referral_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`referral`(`referral_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ADD CONSTRAINT `fk_loyalty_referral_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`campaign_storefront_deployment` ADD CONSTRAINT `fk_loyalty_campaign_storefront_deployment_engagement_campaign_id` FOREIGN KEY (`engagement_campaign_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`engagement_campaign`(`engagement_campaign_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`loyalty` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_retail_v1`.`loyalty` SET TAGS ('dbx_domain' = 'loyalty');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` SET TAGS ('dbx_subdomain' = 'program_management');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Program Manager Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `charitable_donation_enabled` SET TAGS ('dbx_business_glossary_term' = 'Charitable Donation Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `customer_service_email` SET TAGS ('dbx_business_glossary_term' = 'Customer Service Email Address');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `customer_service_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `customer_service_phone` SET TAGS ('dbx_business_glossary_term' = 'Customer Service Phone Number');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `ecommerce_integration_enabled` SET TAGS ('dbx_business_glossary_term' = 'E-Commerce Integration Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Program End Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `gamification_enabled` SET TAGS ('dbx_business_glossary_term' = 'Gamification Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `launch_date` SET TAGS ('dbx_business_glossary_term' = 'Program Launch Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `mobile_app_enabled` SET TAGS ('dbx_business_glossary_term' = 'Mobile App Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `omnichannel_recognition_enabled` SET TAGS ('dbx_business_glossary_term' = 'Omnichannel Recognition Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `partner_coalition_enabled` SET TAGS ('dbx_business_glossary_term' = 'Partner Coalition Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `personalization_engine_enabled` SET TAGS ('dbx_business_glossary_term' = 'Personalization Engine Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `points_expiry_duration_months` SET TAGS ('dbx_business_glossary_term' = 'Points Expiry Duration (Months)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `points_expiry_policy` SET TAGS ('dbx_value_regex' = 'never|rolling_months|calendar_year|fixed_date|activity_based');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `pos_integration_enabled` SET TAGS ('dbx_business_glossary_term' = 'Point of Sale (POS) Integration Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `privacy_policy_url` SET TAGS ('dbx_value_regex' = '^https?://.*$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `program_code` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Code');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `program_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `program_description` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Description');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `program_name` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Name');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `program_status` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Status');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `program_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|planned|retired');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `program_type` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Type');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `program_type` SET TAGS ('dbx_value_regex' = 'tiered|points_based|cashback|coalition|co_branded_card|subscription');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `referral_program_enabled` SET TAGS ('dbx_business_glossary_term' = 'Referral Program Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `terms_and_conditions_url` SET TAGS ('dbx_value_regex' = '^https?://.*$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `tier_evaluation_period` SET TAGS ('dbx_value_regex' = 'calendar_year|rolling_12_months|program_year|lifetime');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `tier_qualification_metric` SET TAGS ('dbx_value_regex' = 'annual_spend|points_earned|transaction_count|hybrid');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ALTER COLUMN `tier_structure_enabled` SET TAGS ('dbx_business_glossary_term' = 'Tier Structure Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` SET TAGS ('dbx_subdomain' = 'member_engagement');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Membership ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `tier_id` SET TAGS ('dbx_business_glossary_term' = 'Current Tier Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Enrollment Store ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `referred_by_member_loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Referred By Member ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `anniversary_date` SET TAGS ('dbx_business_glossary_term' = 'Membership Anniversary Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `closed_date` SET TAGS ('dbx_business_glossary_term' = 'Membership Closed Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `closed_reason` SET TAGS ('dbx_business_glossary_term' = 'Membership Closed Reason');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `membership_status` SET TAGS ('dbx_value_regex' = 'active|suspended|lapsed|closed|pending');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `next_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Next Points Expiry Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `opt_in_direct_mail` SET TAGS ('dbx_business_glossary_term' = 'Direct Mail Opt-In');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `opt_in_email` SET TAGS ('dbx_business_glossary_term' = 'Email Marketing Opt-In');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `opt_in_push` SET TAGS ('dbx_business_glossary_term' = 'Push Notification Opt-In');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `opt_in_sms` SET TAGS ('dbx_business_glossary_term' = 'SMS (Short Message Service) Marketing Opt-In');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `referral_code` SET TAGS ('dbx_business_glossary_term' = 'Member Referral Code');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `status_reason` SET TAGS ('dbx_business_glossary_term' = 'Membership Status Reason');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `total_transactions` SET TAGS ('dbx_business_glossary_term' = 'Total Transaction Count');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ALTER COLUMN `vip_flag` SET TAGS ('dbx_business_glossary_term' = 'VIP (Very Important Person) Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` SET TAGS ('dbx_subdomain' = 'program_management');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ALTER COLUMN `badge_color` SET TAGS ('dbx_business_glossary_term' = 'Tier Badge Color');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ALTER COLUMN `badge_icon_url` SET TAGS ('dbx_business_glossary_term' = 'Tier Badge Icon URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ALTER COLUMN `benefits_summary` SET TAGS ('dbx_business_glossary_term' = 'Tier Benefits Summary');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ALTER COLUMN `tier_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ALTER COLUMN `grace_period_months` SET TAGS ('dbx_business_glossary_term' = 'Grace Period (Months)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ALTER COLUMN `maintenance_period_months` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Period (Months)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ALTER COLUMN `points_redemption_discount_pct` SET TAGS ('dbx_business_glossary_term' = 'Points Redemption Discount Percentage');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ALTER COLUMN `qualification_period_months` SET TAGS ('dbx_business_glossary_term' = 'Qualification Period (Months)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ALTER COLUMN `qualification_threshold_type` SET TAGS ('dbx_value_regex' = 'spend|points|transactions|hybrid');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ALTER COLUMN `terms_and_conditions_url` SET TAGS ('dbx_business_glossary_term' = 'Terms and Conditions URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ALTER COLUMN `tier_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated|planned');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` SET TAGS ('dbx_subdomain' = 'points_rewards');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `accrual_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Accrual Rule Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `cart_id` SET TAGS ('dbx_business_glossary_term' = 'Cart Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Liability Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `partner_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Partner Transaction Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `pos_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Pos Transaction Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `redemption_id` SET TAGS ('dbx_business_glossary_term' = 'Redemption Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `redemption_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Redemption Rule Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `reversal_reference_points_ledger_id` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reference ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `channel` SET TAGS ('dbx_business_glossary_term' = 'Transaction Channel');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `channel` SET TAGS ('dbx_value_regex' = 'store|online|mobile_app|call_center|partner|kiosk');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Points Expiration Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Transaction Notes');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `qualification_period_end` SET TAGS ('dbx_business_glossary_term' = 'Qualification Period End Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `qualification_period_start` SET TAGS ('dbx_business_glossary_term' = 'Qualification Period Start Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_value_regex' = 'return|cancellation|fraud|system_error|customer_service');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `source_reference_code` SET TAGS ('dbx_business_glossary_term' = 'Source Reference ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `transaction_status` SET TAGS ('dbx_value_regex' = 'posted|pending|reversed|failed');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` SET TAGS ('dbx_subdomain' = 'points_rewards');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Liability Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `price_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Price Zone Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `product_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `tertiary_accrual_approved_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `accrual_rule_status` SET TAGS ('dbx_value_regex' = 'draft|active|inactive|expired|suspended');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `applicable_channel` SET TAGS ('dbx_value_regex' = 'all|in_store|online|mobile_app|bopis|ropis');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `applicable_sku_list` SET TAGS ('dbx_business_glossary_term' = 'Applicable SKU (Stock Keeping Unit) List');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `earning_basis` SET TAGS ('dbx_value_regex' = 'spend_amount|unit_quantity|transaction_count|visit_count');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `excluded_sku_list` SET TAGS ('dbx_business_glossary_term' = 'Excluded SKU (Stock Keeping Unit) List');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `external_rule_code` SET TAGS ('dbx_business_glossary_term' = 'External Rule ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `member_tier_eligibility` SET TAGS ('dbx_value_regex' = 'all|bronze|silver|gold|platinum');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `pricing_strategy_alignment` SET TAGS ('dbx_business_glossary_term' = 'Pricing Strategy Alignment (EDLP/Hi-Lo)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `pricing_strategy_alignment` SET TAGS ('dbx_value_regex' = 'edlp|hi_lo|hybrid');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `rule_code` SET TAGS ('dbx_business_glossary_term' = 'Accrual Rule Code');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `rule_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `rule_description` SET TAGS ('dbx_business_glossary_term' = 'Accrual Rule Description');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `rule_name` SET TAGS ('dbx_business_glossary_term' = 'Accrual Rule Name');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `rule_type` SET TAGS ('dbx_business_glossary_term' = 'Accrual Rule Type');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `rule_type` SET TAGS ('dbx_value_regex' = 'base_earn|bonus_multiplier|category_specific|sku_specific|channel_specific|tier_specific');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` SET TAGS ('dbx_subdomain' = 'points_rewards');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `product_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `approval_workflow_code` SET TAGS ('dbx_business_glossary_term' = 'Approval Workflow ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `blackout_end_date` SET TAGS ('dbx_business_glossary_term' = 'Blackout Period End Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `blackout_start_date` SET TAGS ('dbx_business_glossary_term' = 'Blackout Period Start Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `eligible_channels` SET TAGS ('dbx_business_glossary_term' = 'Eligible Redemption Channels');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `liability_impact_category` SET TAGS ('dbx_value_regex' = 'immediate|deferred|conditional|none');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `pos_integration_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Point of Sale (POS) Integration Required Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `priority_rank` SET TAGS ('dbx_business_glossary_term' = 'Rule Priority Rank');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `redemption_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `redemption_rule_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|archived');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `rounding_rule` SET TAGS ('dbx_business_glossary_term' = 'Points Rounding Rule');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `rounding_rule` SET TAGS ('dbx_value_regex' = 'round_up|round_down|round_nearest|no_rounding');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `rule_code` SET TAGS ('dbx_business_glossary_term' = 'Redemption Rule Code');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `rule_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{4,20}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `rule_description` SET TAGS ('dbx_business_glossary_term' = 'Redemption Rule Description');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `rule_name` SET TAGS ('dbx_business_glossary_term' = 'Redemption Rule Name');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `rule_type` SET TAGS ('dbx_business_glossary_term' = 'Redemption Rule Type');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `rule_type` SET TAGS ('dbx_value_regex' = 'standard|promotional|tier_based|seasonal|partner|event_driven');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Rule Version Number');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` SET TAGS ('dbx_subdomain' = 'points_rewards');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `reward_id` SET TAGS ('dbx_business_glossary_term' = 'Reward Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Eligible Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Partner Vendor Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `product_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Product Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `channel_availability` SET TAGS ('dbx_value_regex' = 'in_store|online|mobile_app|call_center|all_channels');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `reward_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `description_long` SET TAGS ('dbx_business_glossary_term' = 'Long Description');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `description_short` SET TAGS ('dbx_business_glossary_term' = 'Short Description');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `discount_type` SET TAGS ('dbx_value_regex' = 'percentage|fixed_amount|free_shipping|bogo|tiered');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `image_url` SET TAGS ('dbx_business_glossary_term' = 'Image Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `image_url` SET TAGS ('dbx_value_regex' = '^https?://.*.(jpg|jpeg|png|gif|webp)$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `is_combinable` SET TAGS ('dbx_business_glossary_term' = 'Is Combinable Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `is_featured` SET TAGS ('dbx_business_glossary_term' = 'Is Featured Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `monetary_value` SET TAGS ('dbx_business_glossary_term' = 'Monetary Value Equivalent');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `product_sku_restriction` SET TAGS ('dbx_business_glossary_term' = 'Product Stock Keeping Unit (SKU) Restriction');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `reward_status` SET TAGS ('dbx_value_regex' = 'active|inactive|sold_out|discontinued|pending_approval');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `thumbnail_url` SET TAGS ('dbx_business_glossary_term' = 'Thumbnail Image Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `thumbnail_url` SET TAGS ('dbx_value_regex' = '^https?://.*.(jpg|jpeg|png|gif|webp)$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` SET TAGS ('dbx_subdomain' = 'points_rewards');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Campaign ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `cart_id` SET TAGS ('dbx_business_glossary_term' = 'Cart Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Associated Order ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Member ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `member_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Offer ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `partner_program_id` SET TAGS ('dbx_business_glossary_term' = 'Partner Organization ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `pos_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Point of Sale (POS) Transaction ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `redemption_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Redemption Rule Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `revenue_recognition_event_id` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Event Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `reward_id` SET TAGS ('dbx_business_glossary_term' = 'Reward Catalog Item ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason Code');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_value_regex' = 'member_request|system_error|fraud_detection|order_cancelled|expired|duplicate');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `cancellation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Redemption Cancellation Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `channel` SET TAGS ('dbx_business_glossary_term' = 'Redemption Channel');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `channel` SET TAGS ('dbx_value_regex' = 'web|mobile_app|store|call_center|kiosk|partner_site');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Redemption Expiry Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `fraud_detection_score` SET TAGS ('dbx_business_glossary_term' = 'Fraud Detection Risk Score');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `fulfillment_method` SET TAGS ('dbx_business_glossary_term' = 'Reward Fulfillment Method');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `is_fraudulent` SET TAGS ('dbx_business_glossary_term' = 'Fraudulent Redemption Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `monetary_value` SET TAGS ('dbx_business_glossary_term' = 'Redemption Monetary Value');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Redemption Notes');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `points_redeemed` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Points Redeemed');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `redemption_number` SET TAGS ('dbx_business_glossary_term' = 'Redemption Transaction Number');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `redemption_number` SET TAGS ('dbx_value_regex' = '^RDM-[0-9]{10}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `redemption_status` SET TAGS ('dbx_business_glossary_term' = 'Redemption Fulfillment Status');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `redemption_status` SET TAGS ('dbx_value_regex' = 'issued|activated|used|expired|cancelled|reversed');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `redemption_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Redemption Transaction Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `redemption_type` SET TAGS ('dbx_value_regex' = 'catalog_reward|personalized_offer|promotional_offer|partner_reward|instant_discount|voucher');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason Code');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_value_regex' = 'product_return|order_cancellation|service_failure|system_error|fraud_reversal|goodwill');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `reversal_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Redemption Reversal Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `tier_at_redemption` SET TAGS ('dbx_business_glossary_term' = 'Member Tier at Redemption');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `usage_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Redemption Usage Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `voucher_code` SET TAGS ('dbx_business_glossary_term' = 'Voucher or Coupon Code');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `voucher_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{12,16}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` SET TAGS ('dbx_subdomain' = 'member_engagement');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Member ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `member_segment_id` SET TAGS ('dbx_business_glossary_term' = 'Segment ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `product_brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `reward_id` SET TAGS ('dbx_business_glossary_term' = 'Reward Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Target Store Cluster Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `channel_applicability` SET TAGS ('dbx_value_regex' = 'all|in_store|online|mobile_app|call_center');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `discount_type` SET TAGS ('dbx_value_regex' = 'percentage|fixed_amount');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Offer End Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `max_redemptions` SET TAGS ('dbx_business_glossary_term' = 'Maximum Redemptions');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `offer_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `offer_source` SET TAGS ('dbx_value_regex' = 'automated|manual|campaign|clienteling|tier_benefit');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `offer_type` SET TAGS ('dbx_value_regex' = 'bonus_points|discount|free_item|early_access|experiential_reward|tier_upgrade');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Offer Start Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` SET TAGS ('dbx_subdomain' = 'member_engagement');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Owner Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `finance_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Target Store Cluster Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Target Store Location Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `actual_participation_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Actual Participation Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Campaign Approval Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `campaign_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{4,20}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `channel_app_notification_flag` SET TAGS ('dbx_business_glossary_term' = 'App Notification Channel Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `channel_direct_mail_flag` SET TAGS ('dbx_business_glossary_term' = 'Direct Mail Channel Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `channel_email_flag` SET TAGS ('dbx_business_glossary_term' = 'Email Channel Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `channel_in_store_flag` SET TAGS ('dbx_business_glossary_term' = 'In-Store Channel Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `channel_push_flag` SET TAGS ('dbx_business_glossary_term' = 'Push Notification Channel Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `channel_sms_flag` SET TAGS ('dbx_business_glossary_term' = 'SMS (Short Message Service) Channel Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Campaign End Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `opt_in_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Opt-In Required Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Campaign Start Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ALTER COLUMN `target_participation_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Target Participation Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` SET TAGS ('dbx_subdomain' = 'member_engagement');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `bopis_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Bopis Appointment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Store Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order Header Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Member ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `member_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `pos_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Transaction ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `web_session_id` SET TAGS ('dbx_business_glossary_term' = 'Web Session Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `customer_sentiment` SET TAGS ('dbx_value_regex' = 'very_positive|positive|neutral|negative|very_negative');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `follow_up_action_required` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Action Required Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `follow_up_action_type` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Action Type');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `follow_up_completed_flag` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Completed Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `follow_up_due_date` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Due Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `interaction_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Interaction Duration (Minutes)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `interaction_initiated_by` SET TAGS ('dbx_value_regex' = 'associate|customer|system_triggered|event_invitation|campaign');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `interaction_number` SET TAGS ('dbx_value_regex' = '^CI-[0-9]{10}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `interaction_status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|no_show|rescheduled');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ALTER COLUMN `nps_score` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` SET TAGS ('dbx_subdomain' = 'member_engagement');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `audience_segment_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Audience Segment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Segment Owner Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `assignment_method` SET TAGS ('dbx_value_regex' = 'rule_based|ml_model|manual|hybrid');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `average_ltv` SET TAGS ('dbx_business_glossary_term' = 'Average Customer Lifetime Value (CLTV)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `is_exclusive` SET TAGS ('dbx_business_glossary_term' = 'Is Exclusive Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `ml_model_reference` SET TAGS ('dbx_business_glossary_term' = 'Machine Learning (ML) Model Reference');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `ml_model_version` SET TAGS ('dbx_business_glossary_term' = 'Machine Learning (ML) Model Version');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Segment Notes');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `segment_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `segment_status` SET TAGS ('dbx_value_regex' = 'active|inactive|archived|draft|pending_approval');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `segment_type` SET TAGS ('dbx_value_regex' = 'rfm_based|spend_based|lifecycle_stage|engagement_based|redemption_behavior|channel_preference');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `tags` SET TAGS ('dbx_business_glossary_term' = 'Segment Tags');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` SET TAGS ('dbx_subdomain' = 'program_management');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` ALTER COLUMN `third_party_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Third Party Assessment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` ALTER COLUMN `earn_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` ALTER COLUMN `integration_method` SET TAGS ('dbx_value_regex' = 'api_realtime|batch_edi|file_transfer|manual|pos_integration|web_service');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` ALTER COLUMN `partner_code` SET TAGS ('dbx_business_glossary_term' = 'Partner Program Code');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` ALTER COLUMN `partner_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` ALTER COLUMN `partner_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` ALTER COLUMN `partner_status` SET TAGS ('dbx_business_glossary_term' = 'Partner Program Status');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` ALTER COLUMN `partner_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|pending_approval|terminated|pilot');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` ALTER COLUMN `redeem_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` ALTER COLUMN `settlement_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` ALTER COLUMN `settlement_frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|biweekly|monthly|quarterly|on_demand');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` SET TAGS ('dbx_subdomain' = 'program_management');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Member ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `original_transaction_partner_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Original Transaction ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Settlement Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `amount` SET TAGS ('dbx_business_glossary_term' = 'Partner Transaction Amount');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `commission_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Transaction Notes');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `partner_file_batch_number` SET TAGS ('dbx_business_glossary_term' = 'Partner File Batch ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `partner_merchant_code` SET TAGS ('dbx_business_glossary_term' = 'Partner Merchant ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `reconciliation_status` SET TAGS ('dbx_value_regex' = 'matched|unmatched|disputed|resolved');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `reference` SET TAGS ('dbx_business_glossary_term' = 'Partner Transaction Reference Number');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `settlement_batch_number` SET TAGS ('dbx_business_glossary_term' = 'Settlement Batch ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `transaction_channel` SET TAGS ('dbx_value_regex' = 'in_store|online|mobile_app|call_center|kiosk');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `transaction_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `transaction_status` SET TAGS ('dbx_business_glossary_term' = 'Transaction Processing Status');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `transaction_status` SET TAGS ('dbx_value_regex' = 'pending|confirmed|rejected|cancelled');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_value_regex' = 'earn|redemption|reversal|adjustment');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` SET TAGS ('dbx_subdomain' = 'member_engagement');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `referral_id` SET TAGS ('dbx_business_glossary_term' = 'Referral Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Associate Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'First Purchase Order Header Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Referring Member Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Referred Customer Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `web_session_id` SET TAGS ('dbx_business_glossary_term' = 'Web Session Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `channel` SET TAGS ('dbx_business_glossary_term' = 'Referral Channel');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `referral_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `conversion_status` SET TAGS ('dbx_value_regex' = 'pending|enrolled|qualified|rewarded|expired|declined');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `first_purchase_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Referral Notes');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `referee_reward_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `referee_reward_type` SET TAGS ('dbx_value_regex' = 'welcome_bonus|bonus_points|discount_voucher|gift_card|free_shipping|merchandise');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `referrer_reward_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ALTER COLUMN `referrer_reward_type` SET TAGS ('dbx_value_regex' = 'bonus_points|tier_credit|gift_card|discount_voucher|cash_back|merchandise');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`campaign_storefront_deployment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`campaign_storefront_deployment` SET TAGS ('dbx_subdomain' = 'program_management');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`campaign_storefront_deployment` SET TAGS ('dbx_association_edges' = 'loyalty.engagement_campaign,ecommerce.storefront');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`campaign_storefront_deployment` ALTER COLUMN `engagement_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Storefront Deployment - Engagement Campaign Id');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`campaign_storefront_deployment` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Storefront Deployment - Storefront Id');
