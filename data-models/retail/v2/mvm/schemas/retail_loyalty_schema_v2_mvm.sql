-- Schema for Domain: loyalty | Business: Retail | Version: v2_mvm
-- Generated on: 2026-07-12 10:43:57

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`loyalty` COMMENT 'Manages customer loyalty programs, membership tiers, points accrual and redemption, rewards catalogs, personalized offers, tier qualification rules, clienteling interaction records, and engagement campaigns. Tracks program enrollment, active members, points liability, and program ROI. Integrates with customer domain for unified customer view and supports omnichannel loyalty recognition across all touchpoints.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`program` (
    `program_id` BIGINT COMMENT 'Unique identifier for the loyalty program. Primary key. Inferred role: MASTER_RESOURCE (loyalty program is a managed resource/offering). This entity represents a loyalty program offering operated by the retailer.',
    `region_id` BIGINT COMMENT 'Foreign key linking to store.region. Business justification: Loyalty programs are scoped to geographic regions for regulatory compliance (GDPR by region, tax treatment of points by jurisdiction) and regional market strategy. A program operating in EU vs. US req',
    `annual_fee_amount` DECIMAL(18,2) COMMENT 'Recurring annual membership fee for subscription-based loyalty programs. Zero for free programs.',
    `banner_affiliation` STRING COMMENT 'Retail banner or brand name this loyalty program is associated with. Supports multi-banner retailers operating distinct programs for different store formats (e.g., Hypermarket Rewards, Discount Club, Premium Grocery).',
    `charitable_donation_enabled` BOOLEAN COMMENT 'Indicates whether members can donate their earned points or rewards to charitable organizations through the loyalty program.',
    `program_code` STRING COMMENT 'Externally-known unique business identifier for the loyalty program (e.g., REWARDS_PLUS, GOLD_CLUB). Used in operational systems, customer communications, and integrations.. Valid values are `^[A-Z0-9_-]{3,20}$`',
    `cost_center_code` STRING COMMENT 'Financial cost center code to which loyalty program expenses (rewards liability, marketing, operations) are allocated for P&L reporting.. Valid values are `^[A-Z0-9]{4,12}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this loyalty program record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this program (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `customer_service_email` STRING COMMENT 'Dedicated customer service email address for loyalty program member inquiries and support requests.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `customer_service_phone` STRING COMMENT 'Dedicated customer service phone number for loyalty program member inquiries, support, and issue resolution.',
    `program_description` STRING COMMENT 'Detailed description of the loyalty programs value proposition, benefits, and key features. Used for internal reference and customer-facing communications.',
    `ecommerce_integration_enabled` BOOLEAN COMMENT 'Indicates whether the loyalty program is integrated with the retailers e-commerce platform for online member identification, points accrual, and redemption during digital checkout.',
    `end_date` DATE COMMENT 'Date when the loyalty program is scheduled to end or was retired. Null for ongoing programs.',
    `enrollment_eligibility_rule` STRING COMMENT 'Business rule defining who can enroll in the program (e.g., age 18+, US residents only, minimum purchase requirement, invitation only). Free-text description of eligibility criteria.',
    `enrollment_fee_amount` DECIMAL(18,2) COMMENT 'One-time fee charged to enroll in the loyalty program. Zero for free programs.',
    `gamification_enabled` BOOLEAN COMMENT 'Indicates whether the loyalty program incorporates gamification elements such as challenges, badges, leaderboards, or bonus point events to drive engagement.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this loyalty program record was last updated in the system.',
    `launch_date` DATE COMMENT 'Date when the loyalty program was officially launched and made available to customers for enrollment.',
    `mobile_app_enabled` BOOLEAN COMMENT 'Indicates whether the loyalty program has a dedicated mobile application or is accessible through the retailers mobile app for member self-service, digital card, and personalized offers.',
    `program_name` STRING COMMENT 'Human-readable marketing name of the loyalty program displayed to customers (e.g., Rewards Plus, Gold Member Club, Everyday Savings).',
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
    `program_status` STRING COMMENT 'Current lifecycle status of the loyalty program: active (accepting enrollments and accruals), inactive (temporarily paused), suspended (enrollment closed but existing members active), planned (designed but not launched), retired (permanently closed).. Valid values are `active|inactive|suspended|planned|retired`',
    `program_type` STRING COMMENT 'Classification of the loyalty program structure: tiered (multiple membership levels with escalating benefits), points_based (earn and redeem points), cashback (percentage rebate), coalition (multi-retailer partnership), co_branded_card (linked to credit card), subscription (paid membership with benefits).. Valid values are `tiered|points_based|cashback|coalition|co_branded_card|subscription`',
    `referral_program_enabled` BOOLEAN COMMENT 'Indicates whether the loyalty program includes a member-get-member referral component where existing members earn rewards for referring new enrollees.',
    `target_customer_segment` STRING COMMENT 'Primary customer demographic or behavioral segment this loyalty program is designed to attract and retain (e.g., high-value shoppers, frequent buyers, millennials, grocery-focused).',
    `terms_and_conditions_url` STRING COMMENT 'URL to the official terms and conditions document governing the loyalty program, including member rights, obligations, and program rules.. Valid values are `^https?://.*$`',
    `tier_evaluation_period` STRING COMMENT 'Time window over which tier qualification is evaluated: calendar_year (Jan-Dec), rolling_12_months (trailing 12 months), program_year (anniversary-based), lifetime (cumulative since enrollment). Null for non-tiered programs.. Valid values are `calendar_year|rolling_12_months|program_year|lifetime`',
    `tier_qualification_metric` STRING COMMENT 'Primary metric used to qualify members for tier advancement: annual_spend (total dollars spent), points_earned (total points accumulated), transaction_count (number of purchases), hybrid (combination of metrics). Null for non-tiered programs.. Valid values are `annual_spend|points_earned|transaction_count|hybrid`',
    `tier_structure_enabled` BOOLEAN COMMENT 'Indicates whether this loyalty program has a tiered membership structure with multiple levels (e.g., Silver, Gold, Platinum). True for tiered programs, false for flat programs.',
    CONSTRAINT pk_program PRIMARY KEY(`program_id`)
) COMMENT 'Master record for each customer loyalty program operated by the retailer (e.g., tiered rewards club, co-branded credit card program, coalition program). Captures program name, type, enrollment rules, points currency definition, expiry policy, program status, launch/end dates, and omnichannel recognition configuration. SSOT for loyalty program definitions referenced by all downstream entities (membership, tiers, rules, rewards, campaigns). Supports multi-program retailers operating distinct programs for different banners or customer segments.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`membership` (
    `membership_id` BIGINT COMMENT 'Unique identifier for the loyalty program membership. Primary key.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Retail loyalty memberships must link to customer accounts for B2B pricing eligibility, credit limit enforcement, tax exemption application, and account-level benefit tracking. Essential for omnichanne',
    `tier_id` BIGINT COMMENT 'Foreign key linking to loyalty.tier. Business justification: Critical normalization opportunity. membership.current_tier is currently a STRING field (likely storing tier code or name). This should be normalized to a FK to tier.tier_id. The tier table is the aut',
    `location_id` BIGINT COMMENT 'Store location where the customer enrolled, if enrollment occurred in-store. Null for digital enrollments.',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Members enroll and transact through specific digital storefronts; tracking primary storefront enables channel-specific loyalty offers, omnichannel recognition, and storefront-level member segmentation',
    `profile_id` BIGINT COMMENT 'Reference to the customer who holds this membership. Links to the customer domain for unified customer view.',
    `program_id` BIGINT COMMENT 'Reference to the loyalty program this membership belongs to. Supports multiple program structures.',
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
    CONSTRAINT pk_membership PRIMARY KEY(`membership_id`)
) COMMENT 'Represents an individual customers active enrollment in a loyalty program. Captures member number, enrollment date, enrollment channel (in-store, online, mobile, referral), current tier, tier qualification date, tier expiry date, previous tier (for downgrade tracking), membership status (active, suspended, lapsed, closed), opt-in preferences, linked customer reference, lifetime points earned, lifetime points redeemed, and tier change history summary. One customer may have memberships across multiple programs. Serves as the anchor entity for all member-level activity — points, redemptions, offers, interactions, and referrals link back here.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`loyalty`.`tier` (
    `tier_id` BIGINT COMMENT 'Unique identifier for the loyalty program tier. Primary key.',
    `prior_tier_id` BIGINT COMMENT 'add column prior_tier_id (BIGINT) with FK to loyalty.tier.tier_id - tiers have a natural progression order that should be explicitly modeled for tier qualification logic',
    `program_id` BIGINT COMMENT 'Reference to the parent loyalty program to which this tier belongs. A loyalty program may have multiple tiers (e.g., Silver, Gold, Platinum).',
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
    `cart_id` BIGINT COMMENT 'Foreign key linking to ecommerce.cart. Business justification: Points redemption can occur at cart level before order placement; tracking cart enables pre-order points reservation, cart abandonment recovery with points incentives, and real-time points balance upd',
    `checkout_id` BIGINT COMMENT 'Foreign key linking to ecommerce.checkout. Business justification: Points are earned and redeemed at checkout completion. Linking points_ledger to checkout enables checkout-level loyalty reconciliation, supports loyalty liability reporting per checkout event, and all',
    `header_id` BIGINT COMMENT 'Reference to the e-commerce or omnichannel order that generated this points transaction. Null for in-store POS transactions not linked to an order. Enables order-to-loyalty reconciliation.',
    `location_id` BIGINT COMMENT 'Reference to the physical store location where the transaction occurred. Null for online, mobile, or partner channels. Used for store-level loyalty performance reporting.',
    `membership_id` BIGINT COMMENT 'FK to loyalty.membership.membership_id — Points ledger to membership is the core loyalty accounting join. Every points balance inquiry, tier qualification check, and loyalty statement requires this link.',
    `pos_transaction_id` BIGINT COMMENT 'Foreign key linking to order.pos_transaction. Business justification: Majority of loyalty points are earned at POS; direct link enables real-time posting, receipt printing with earned points, POS-loyalty reconciliation, and audit trail for in-store transactions.',
    `primary_points_loyalty_membership_id` BIGINT COMMENT 'Reference to the loyalty membership account for which this points transaction was recorded.',
    `profile_id` BIGINT COMMENT 'Foreign key linking to customer.profile. Business justification: Points ledger transactions require direct profile linkage for customer service dispute resolution, GDPR/CCPA data subject access requests, and customer-centric transaction history reporting. Eliminate',
    `promo_offer_id` BIGINT COMMENT 'Reference to the marketing promotion or campaign that triggered bonus points or special earn rate. Null for standard earn transactions. Supports promotion ROI analysis.',
    `redemption_id` BIGINT COMMENT 'Foreign key linking to loyalty.redemption. Business justification: Critical reconciliation link. When a redemption occurs, it generates a points_ledger entry (debit). The ledger should reference the redemption transaction for full traceability. Currently points_ledge',
    `redemption_rule_id` BIGINT COMMENT 'Foreign key linking to loyalty.redemption_rule. Business justification: Points ledger entries of type redeem should reference which redemption rule was applied. Parallel to accrual_rule_id, this enables audit trail for rule enforcement, compliance reporting, and analyti',
    `reversal_reference_points_ledger_id` BIGINT COMMENT 'Points ledger ID of the original transaction being reversed. Populated only for transaction_type = reversal. Creates audit trail linking correction to original entry.',
    `rma_id` BIGINT COMMENT 'Foreign key linking to returns.rma. Business justification: Points reversal entries in the ledger (transaction_type = REVERSAL/ADJUSTMENT) must reference the RMA that triggered the reversal for audit compliance and customer dispute resolution. points_ledger ha',
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
    `brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Brand-based earning rules are core loyalty strategy (e.g., 3x points on private label, double points on partner brands). Brand-level earning rules support strategic merchandising objectives requir',
    `cluster_id` BIGINT COMMENT 'Foreign key linking to store.cluster. Business justification: Store clusters drive differentiated loyalty accrual strategies — urban high-income clusters receive elevated earn rates to drive basket size. Cluster-level accrual rules are a core retail loyalty pers',
    `demand_forecast_id` BIGINT COMMENT 'Foreign key linking to supplychain.demand_forecast. Business justification: Loyalty bonus point promotions on specific SKUs drive measurable demand lift. Retail supply chain teams use loyalty-driven promotional demand forecasting — accrual rules are inputs to demand_forecas',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.department. Business justification: Retailers configure department-level bonus point accrual (e.g., 3x points in pharmacy, 2x in electronics). Accrual rules scoped to store departments drive targeted loyalty promotions and category-leve',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Loyalty earning rules routinely target product categories/hierarchies (e.g., 2x points on electronics, bonus points in grocery). Category-based earning is a core retail loyalty mechanic requiring',
    `price_zone_id` BIGINT COMMENT 'Foreign key linking to pricing.price_zone. Business justification: Accrual rates frequently vary by price zone (e.g., 2x points in premium urban zones, 1x in discount zones). Supports zone-based earning strategies, competitive positioning in high-value markets, and z',
    `program_id` BIGINT COMMENT 'Reference to the loyalty program to which this accrual rule belongs.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Campaign-scoped bonus points accrual rules (e.g., triple points during a holiday campaign) are a standard retail loyalty mechanic. accrual_rule already links to promo_offer for offer-level rules; a ca',
    `promo_offer_id` BIGINT COMMENT 'Reference to a specific promotion campaign if this accrual rule is tied to a promotional event. Null if not promotion-specific.',
    `rule_id` BIGINT COMMENT 'Foreign key linking to pricing.rule. Business justification: Retail loyalty accrual rules are triggered by or aligned with pricing rules — bonus points activate when a promotional pricing rule fires. This pricing-triggered points accrual process is a named reta',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: SKU-specific earning rules are common for promotions (e.g., bonus 500 points on featured item #12345, triple points on new product launch). SKU-level earning rules are real promotional mechanics r',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Loyalty operations teams configure storefront-specific accrual rules (e.g., double points on a specific e-commerce site). Linking accrual_rule to storefront enables filtering and applying the correct ',
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
    `rule_description` STRING COMMENT 'Detailed description of the accrual rule, including business rationale, conditions, and examples.',
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
    `brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Brand restrictions on redemptions exist (e.g., points valid only on store brands, exclude premium brands from discounts). Brand-level redemption rules are real business constraints requiring this',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.department. Business justification: Redemption rules are restricted by department for compliance and margin protection (e.g., points cannot be redeemed in licensed tobacco/alcohol departments). Regulatory and operational reporting on de',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Redemption restrictions commonly apply by category (e.g., points not valid on alcohol/tobacco, redeem only in health & beauty). Category-level redemption rules are standard retail loyalty practice',
    `location_id` BIGINT COMMENT 'Identifier of the user or system account that created this redemption rule record.',
    `price_list_id` BIGINT COMMENT 'Foreign key linking to pricing.price_list. Business justification: Redemption rules in retail are scoped to specific price lists — e.g., points redemption valid only against full-price list, not clearance. Loyalty operations and promotional planning teams configure t',
    `program_id` BIGINT COMMENT 'Foreign key linking to loyalty.loyalty_program. Business justification: Redemption rules govern how members redeem points within a specific loyalty program — rules are program-scoped business policies. Currently redemption_rule has no FK to loyalty_program, meaning rules ',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Campaign-gated redemption rules (points redeemable only during a specific promotional campaign window) are a real retail loyalty operations pattern. redemption_rule has no current link to the promotio',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: SKU-level redemption restrictions exist (e.g., points not valid on clearance SKUs, exclude gift cards from point redemption). SKU-specific redemption rules are real business constraints requiring',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Redemption rules are configured per storefront in omnichannel retail (e.g., online-only redemption windows, storefront-specific minimum thresholds). This FK enables the checkout engine to query applic',
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
    `brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Brand-specific rewards are common (e.g., $10 off , 20% off private label). Brand-targeted rewards support vendor partnerships and private label strategy requiring this link for brand-scoped re',
    `demand_forecast_id` BIGINT COMMENT 'Foreign key linking to supplychain.demand_forecast. Business justification: Physical product rewards create incremental SKU demand that must be incorporated into demand forecasts. Retail supply chain planners run reward redemption demand forecasting to size DC inventory for',
    `digital_catalog_id` BIGINT COMMENT 'Foreign key linking to ecommerce.digital_catalog. Business justification: A reward may be a specific product listed in the digital catalog (free product reward, discounted item). Linking reward to digital_catalog enables the PDP to display redeem points for this item and ',
    `department_id` BIGINT COMMENT 'Foreign key linking to store.department. Business justification: Rewards are scoped to specific store departments (e.g., a free product reward valid only in the bakery or electronics department). Department-level reward eligibility drives targeted member engagement',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.store_format. Business justification: Reward eligibility restricted by format (experiential rewards only at flagship, bulk discounts only at warehouse). Retail loyalty catalogs curated per format to match inventory, service capabilities,',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Rewards frequently target categories (e.g., $5 off grocery, 10% off apparel). Category-scoped rewards are a fundamental loyalty reward type requiring this link for reward catalog management and re',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Loyalty rewards can be product-based (e.g., redeem points for this SKU). The reward.product_sku_restriction field suggests SKU-level restrictions exist. This links loyalty rewards to the product cat',
    `program_id` BIGINT COMMENT 'Foreign key linking to loyalty.loyalty_program. Business justification: A reward in the catalog belongs to a specific loyalty program — members of that program can redeem points for rewards defined within it. Currently the reward table has no FK to loyalty_program, creati',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_offer. Business justification: Loyalty rewards are frequently fulfilled via promotional offers (e.g., a free-product reward IS a promo_offer). Linking reward to promo_offer enables the POS and e-commerce checkout to apply the corre',
    `sku_price_id` BIGINT COMMENT 'Foreign key linking to pricing.sku_price. Business justification: Loyalty reward valuation and margin/liability accounting requires knowing the exact SKU price record against which a reward discount applies. Retail loyalty operations teams use this link to calculate',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Online-exclusive rewards (e.g., free shipping vouchers, digital gift cards) are scoped to specific storefronts. Retail loyalty teams manage storefront-specific reward catalogs; this FK enables the sto',
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
    `cart_id` BIGINT COMMENT 'Foreign key linking to ecommerce.cart. Business justification: Loyalty redemptions (vouchers, discounts, rewards) are applied to carts during checkout; linking enables tracking redemption application timing, cart conversion rates post-redemption, and abandoned ca',
    `checkout_id` BIGINT COMMENT 'Foreign key linking to ecommerce.checkout. Business justification: Redemptions are executed at checkout. A direct checkout_id FK on redemption enables checkout-level redemption auditing, supports reversal workflows when checkout is abandoned post-redemption, and is r',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to supplychain.dc_facility. Business justification: Physical reward redemptions are fulfilled from a specific DC. Retail operations track reward fulfillment DC attribution for cost allocation, DC capacity planning, and SLA reporting. Role-prefix ful',
    `fulfillment_node_id` BIGINT COMMENT 'Foreign key linking to fulfillment.fulfillment_node. Business justification: Reward pickup node assignment: BOPIS loyalty redemptions (points redeemed for in-store pickup rewards) must be assigned to a specific fulfillment node. The node processes the reward pickup; loyalty op',
    `header_id` BIGINT COMMENT 'Reference to the e-commerce or store order where the redemption was applied. Null if redemption has not yet been used in a transaction.',
    `location_id` BIGINT COMMENT 'Reference to the physical store location where the redemption occurred, if applicable. Null for online or call center redemptions.',
    `membership_id` BIGINT COMMENT 'Reference to the loyalty program member who performed the redemption. Links to the loyalty member master data.',
    `outbound_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.outbound_order. Business justification: When a member redeems points for a physical reward, the DC generates an outbound order to fulfill it. Linking redemption to outbound_order enables end-to-end loyalty reward fulfillment tracking — a na',
    `pos_transaction_id` BIGINT COMMENT 'Reference to the POS transaction where the redemption was applied in-store. Null for online or unused redemptions.',
    `profile_id` BIGINT COMMENT 'Foreign key linking to customer.profile. Business justification: Redemptions trigger revenue recognition events under ASC 606. When customers redeem points for rewards, deferred revenue liability is reduced and revenue is recognized. This link is required for compl',
    `program_id` BIGINT COMMENT 'Reference to the third-party partner organization if the redemption was for a partner reward or occurred through a partner channel. Null for internal rewards.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Redemptions may occur during promotional campaigns where both loyalty rewards and promotional discounts apply - transaction-level tracking required for margin analysis, conflict resolution, and unders',
    `promo_offer_id` BIGINT COMMENT 'Reference to the personalized or promotional offer activated, if redemption type is offer-based. Null for catalog reward redemptions.',
    `redemption_rule_id` BIGINT COMMENT 'Foreign key linking to loyalty.redemption_rule. Business justification: Every redemption should reference which redemption rule allowed it (minimum points threshold, eligible channels, tier requirements, etc.). This is essential for compliance, audit, and analytics. Curre',
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

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ADD CONSTRAINT `fk_loyalty_membership_tier_id` FOREIGN KEY (`tier_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`tier`(`tier_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ADD CONSTRAINT `fk_loyalty_membership_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ADD CONSTRAINT `fk_loyalty_membership_referred_by_member_loyalty_membership_id` FOREIGN KEY (`referred_by_member_loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ADD CONSTRAINT `fk_loyalty_tier_prior_tier_id` FOREIGN KEY (`prior_tier_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`tier`(`tier_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` ADD CONSTRAINT `fk_loyalty_tier_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_accrual_rule_id` FOREIGN KEY (`accrual_rule_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`accrual_rule`(`accrual_rule_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_primary_points_loyalty_membership_id` FOREIGN KEY (`primary_points_loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_redemption_id` FOREIGN KEY (`redemption_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`redemption`(`redemption_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_redemption_rule_id` FOREIGN KEY (`redemption_rule_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`redemption_rule`(`redemption_rule_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_reversal_reference_points_ledger_id` FOREIGN KEY (`reversal_reference_points_ledger_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`points_ledger`(`points_ledger_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_redemption_rule_id` FOREIGN KEY (`redemption_rule_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`redemption_rule`(`redemption_rule_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_reward_id` FOREIGN KEY (`reward_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`reward`(`reward_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`loyalty` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_retail_v1`.`loyalty` SET TAGS ('dbx_domain' = 'loyalty');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` SET TAGS ('dbx_subdomain' = 'program_administration');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `charitable_donation_enabled` SET TAGS ('dbx_business_glossary_term' = 'Charitable Donation Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `program_code` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Code');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `program_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,20}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,12}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `customer_service_email` SET TAGS ('dbx_business_glossary_term' = 'Customer Service Email Address');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `customer_service_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `customer_service_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `customer_service_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `customer_service_phone` SET TAGS ('dbx_business_glossary_term' = 'Customer Service Phone Number');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `customer_service_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `customer_service_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `program_description` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Description');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `ecommerce_integration_enabled` SET TAGS ('dbx_business_glossary_term' = 'E-Commerce Integration Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Program End Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `gamification_enabled` SET TAGS ('dbx_business_glossary_term' = 'Gamification Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `launch_date` SET TAGS ('dbx_business_glossary_term' = 'Program Launch Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `mobile_app_enabled` SET TAGS ('dbx_business_glossary_term' = 'Mobile App Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `mobile_app_enabled` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `mobile_app_enabled` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `program_name` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Name');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `omnichannel_recognition_enabled` SET TAGS ('dbx_business_glossary_term' = 'Omnichannel Recognition Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `partner_coalition_enabled` SET TAGS ('dbx_business_glossary_term' = 'Partner Coalition Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `personalization_engine_enabled` SET TAGS ('dbx_business_glossary_term' = 'Personalization Engine Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `points_expiry_duration_months` SET TAGS ('dbx_business_glossary_term' = 'Points Expiry Duration (Months)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `points_expiry_policy` SET TAGS ('dbx_value_regex' = 'never|rolling_months|calendar_year|fixed_date|activity_based');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `pos_integration_enabled` SET TAGS ('dbx_business_glossary_term' = 'Point of Sale (POS) Integration Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `privacy_policy_url` SET TAGS ('dbx_value_regex' = '^https?://.*$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `program_status` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Status');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `program_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|planned|retired');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `program_type` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Type');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `program_type` SET TAGS ('dbx_value_regex' = 'tiered|points_based|cashback|coalition|co_branded_card|subscription');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `referral_program_enabled` SET TAGS ('dbx_business_glossary_term' = 'Referral Program Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `terms_and_conditions_url` SET TAGS ('dbx_value_regex' = '^https?://.*$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `tier_evaluation_period` SET TAGS ('dbx_value_regex' = 'calendar_year|rolling_12_months|program_year|lifetime');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `tier_qualification_metric` SET TAGS ('dbx_value_regex' = 'annual_spend|points_earned|transaction_count|hybrid');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ALTER COLUMN `tier_structure_enabled` SET TAGS ('dbx_business_glossary_term' = 'Tier Structure Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` SET TAGS ('dbx_subdomain' = 'program_administration');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `membership_id` SET TAGS ('dbx_business_glossary_term' = 'Membership ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `tier_id` SET TAGS ('dbx_business_glossary_term' = 'Current Tier Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Enrollment Store ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `referred_by_member_loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Referred By Member ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `referred_by_member_loyalty_membership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `referred_by_member_loyalty_membership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `anniversary_date` SET TAGS ('dbx_business_glossary_term' = 'Membership Anniversary Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `closed_date` SET TAGS ('dbx_business_glossary_term' = 'Membership Closed Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `closed_reason` SET TAGS ('dbx_business_glossary_term' = 'Membership Closed Reason');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `member_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `member_number` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `membership_status` SET TAGS ('dbx_value_regex' = 'active|suspended|lapsed|closed|pending');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `next_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Next Points Expiry Date');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `opt_in_direct_mail` SET TAGS ('dbx_business_glossary_term' = 'Direct Mail Opt-In');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `opt_in_email` SET TAGS ('dbx_business_glossary_term' = 'Email Marketing Opt-In');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `opt_in_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `opt_in_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `opt_in_push` SET TAGS ('dbx_business_glossary_term' = 'Push Notification Opt-In');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `opt_in_sms` SET TAGS ('dbx_business_glossary_term' = 'SMS (Short Message Service) Marketing Opt-In');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `referral_code` SET TAGS ('dbx_business_glossary_term' = 'Member Referral Code');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `status_reason` SET TAGS ('dbx_business_glossary_term' = 'Membership Status Reason');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `total_transactions` SET TAGS ('dbx_business_glossary_term' = 'Total Transaction Count');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ALTER COLUMN `vip_flag` SET TAGS ('dbx_business_glossary_term' = 'VIP (Very Important Person) Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`tier` SET TAGS ('dbx_subdomain' = 'program_administration');
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
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` SET TAGS ('dbx_subdomain' = 'points_management');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `accrual_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Accrual Rule Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `cart_id` SET TAGS ('dbx_business_glossary_term' = 'Cart Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `checkout_id` SET TAGS ('dbx_business_glossary_term' = 'Checkout Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `pos_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Pos Transaction Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `redemption_id` SET TAGS ('dbx_business_glossary_term' = 'Redemption Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `redemption_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Redemption Rule Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `reversal_reference_points_ledger_id` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reference ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ALTER COLUMN `rma_id` SET TAGS ('dbx_business_glossary_term' = 'Rma Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` SET TAGS ('dbx_subdomain' = 'points_management');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Cluster Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `demand_forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Demand Forecast Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `price_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Price Zone Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `rule_id` SET TAGS ('dbx_business_glossary_term' = 'Rule Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `accrual_rule_status` SET TAGS ('dbx_value_regex' = 'draft|active|inactive|expired|suspended');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `applicable_channel` SET TAGS ('dbx_value_regex' = 'all|in_store|online|mobile_app|bopis|ropis');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `applicable_sku_list` SET TAGS ('dbx_business_glossary_term' = 'Applicable SKU (Stock Keeping Unit) List');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `earning_basis` SET TAGS ('dbx_value_regex' = 'spend_amount|unit_quantity|transaction_count|visit_count');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `excluded_sku_list` SET TAGS ('dbx_business_glossary_term' = 'Excluded SKU (Stock Keeping Unit) List');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `external_rule_code` SET TAGS ('dbx_business_glossary_term' = 'External Rule ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `member_tier_eligibility` SET TAGS ('dbx_value_regex' = 'all|bronze|silver|gold|platinum');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `rule_description` SET TAGS ('dbx_business_glossary_term' = 'Accrual Rule Description');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `rule_type` SET TAGS ('dbx_business_glossary_term' = 'Accrual Rule Type');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ALTER COLUMN `rule_type` SET TAGS ('dbx_value_regex' = 'base_earn|bonus_multiplier|category_specific|sku_specific|channel_specific|tier_specific');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` SET TAGS ('dbx_subdomain' = 'reward_redemption');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Applicable Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `program_id` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` SET TAGS ('dbx_subdomain' = 'reward_redemption');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `reward_id` SET TAGS ('dbx_business_glossary_term' = 'Reward Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `demand_forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Demand Forecast Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `digital_catalog_id` SET TAGS ('dbx_business_glossary_term' = 'Digital Catalog Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `department_id` SET TAGS ('dbx_business_glossary_term' = 'Eligible Department Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Eligible Store Format Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Product Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `program_id` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `sku_price_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `channel_availability` SET TAGS ('dbx_value_regex' = 'in_store|online|mobile_app|call_center|all_channels');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `reward_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `cost_to_business` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `description_long` SET TAGS ('dbx_business_glossary_term' = 'Long Description');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `description_short` SET TAGS ('dbx_business_glossary_term' = 'Short Description');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `discount_type` SET TAGS ('dbx_value_regex' = 'percentage|fixed_amount|free_shipping|bogo|tiered');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `image_url` SET TAGS ('dbx_business_glossary_term' = 'Image Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `image_url` SET TAGS ('dbx_value_regex' = '^https?://.*.(jpg|jpeg|png|gif|webp)$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `is_combinable` SET TAGS ('dbx_business_glossary_term' = 'Is Combinable Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `is_featured` SET TAGS ('dbx_business_glossary_term' = 'Is Featured Flag');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `margin_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `monetary_value` SET TAGS ('dbx_business_glossary_term' = 'Monetary Value Equivalent');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `product_sku_restriction` SET TAGS ('dbx_business_glossary_term' = 'Product Stock Keeping Unit (SKU) Restriction');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `reward_status` SET TAGS ('dbx_value_regex' = 'active|inactive|sold_out|discontinued|pending_approval');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `thumbnail_url` SET TAGS ('dbx_business_glossary_term' = 'Thumbnail Image Uniform Resource Locator (URL)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ALTER COLUMN `thumbnail_url` SET TAGS ('dbx_value_regex' = '^https?://.*.(jpg|jpeg|png|gif|webp)$');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` SET TAGS ('dbx_subdomain' = 'reward_redemption');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `cart_id` SET TAGS ('dbx_business_glossary_term' = 'Cart Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `checkout_id` SET TAGS ('dbx_business_glossary_term' = 'Checkout Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Dc Facility Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Associated Order ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `membership_id` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Member ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `outbound_order_id` SET TAGS ('dbx_business_glossary_term' = 'Outbound Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `pos_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Point of Sale (POS) Transaction ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Revenue Recognition Event Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `program_id` SET TAGS ('dbx_business_glossary_term' = 'Partner Organization ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Offer ID');
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `redemption_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Redemption Rule Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ALTER COLUMN `voucher_code` SET TAGS ('dbx_confidential' = 'true');
