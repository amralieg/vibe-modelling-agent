-- Schema for Domain: promotion | Business:  | Version: v2_ecm
-- Generated on: 2026-07-12 09:24:25

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`promotion` COMMENT 'Manages promotional campaigns, deals, coupons, rebates, BOGO offers, seasonal sales events, circular ads, and digital promotions across channels. Tracks promotion effectiveness, redemption rates, incremental lift, promotional ROI, and vendor-funded promotion agreements. Distinct from pricing — promotions are time-bound, event-driven incentives. Supports omnichannel promotion execution across POS, e-commerce, and mobile apps.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` (
    `promo_campaign_id` BIGINT COMMENT 'Unique identifier for the promotional campaign. Primary key.',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Promotional campaigns are planned and executed at category level. Category managers need visibility to all campaigns targeting their categories for assortment planning, inventory positioning, and perf',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Retail promotional campaigns must comply with advertising regulations (FTC Act, state consumer protection laws, pricing disclosure requirements). Compliance program tracks regulatory framework adheren',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Campaign expenses must post to specific GL accounts for financial reporting. Every campaign has a default expense account (promotional allowances, markdown expense) required for proper accounting clas',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Campaigns target product categories/departments (e.g., Back to School - Electronics). Budget allocation, buyer approval workflows, and performance rollup all operate at hierarchy level. Enables cate',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_definition. Business justification: Campaigns are measured against specific KPIs (sales lift %, ROI, redemption rate). Campaign managers select target KPIs during planning; performance dashboards require this link to show actual vs targ',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Promotional campaigns are executed within marketing campaign umbrellas. Retailers track this for budget allocation, performance attribution, and strategic alignment. Enables marketing-to-promo ROI rep',
    `parent_promo_campaign_id` BIGINT COMMENT 'Self-referencing FK on promo_campaign (parent_promo_campaign_id)',
    `profit_center_id` BIGINT COMMENT 'Foreign key linking to finance.profit_center. Business justification: Campaigns are executed by specific profit centers (stores, channels, regions). P&L reporting requires linking campaign revenue and costs to profit centers for performance analysis and financial statem',
    `promo_calendar_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_calendar. Business justification: Campaigns are planned and executed according to promotional calendar periods. The promo_campaign has start_date and end_date that should align with promotional periods defined in promo_calendar (e.g.,',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Seasonal promotions (Back-to-School, Holiday, Spring clearance) are core retail planning. Campaigns must align with merchandising seasonal calendars for coordinated go-to-market execution. Critical fo',
    `semantic_layer_entity_id` BIGINT COMMENT 'Foreign key linking to analytics.semantic_layer_entity. Business justification: Campaigns are core analytical entities exposed in semantic layer for self-service reporting. BI teams certify campaign entity definitions (grain, attributes, business rules) for consistent analysis. T',
    `vendor_id` BIGINT COMMENT 'Identifier of the vendor providing funding or support for the campaign, if applicable.',
    `approval_status` STRING COMMENT 'Approval workflow status indicating whether the campaign has been reviewed and authorized for execution.. Valid values are `pending|approved|rejected`',
    `approved_by` STRING COMMENT 'Name or identifier of the business user who approved the campaign for execution.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the campaign was approved for execution.',
    `budget_amount` DECIMAL(18,2) COMMENT 'Total allocated budget for the promotional campaign including discounts, advertising, and operational costs.',
    `budget_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the campaign budget amount.. Valid values are `^[A-Z]{3}$`',
    `campaign_code` STRING COMMENT 'Externally-known unique business identifier for the campaign used across systems and communications.. Valid values are `^[A-Z0-9]{6,20}$`',
    `campaign_description` STRING COMMENT 'Detailed description of the campaign objectives, target audience, and promotional strategy.',
    `campaign_name` STRING COMMENT 'Human-readable name of the promotional campaign for business user identification and reporting.',
    `campaign_type` STRING COMMENT 'Classification of the promotional campaign by strategic purpose and funding model.. Valid values are `seasonal|clearance|new_product_launch|loyalty|vendor_funded|flash_sale`',
    `channel_scope` STRING COMMENT 'Distribution channels where the promotional campaign is active (omnichannel, in-store, e-commerce, mobile).. Valid values are `omnichannel|in_store_only|online_only|mobile_app_only`',
    `circular_ad_flag` BOOLEAN COMMENT 'Indicates whether the campaign is featured in printed or digital circular advertisements.',
    `cost_center_code` STRING COMMENT 'Financial cost center code to which campaign expenses are allocated for P&L reporting.. Valid values are `^[A-Z0-9]{4,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the campaign record was first created in the system.',
    `customer_segment_target` STRING COMMENT 'Target customer segment or persona for the promotional campaign (e.g., loyalty members, new customers, high-value).',
    `digital_promotion_flag` BOOLEAN COMMENT 'Indicates whether the campaign includes digital promotions delivered via e-commerce, mobile app, or email.',
    `discount_strategy` STRING COMMENT 'Primary discount mechanism used in the campaign (percentage off, fixed amount, BOGO, bundle pricing, tiered discounts, rebate).. Valid values are `percentage_off|fixed_amount_off|bogo|bundle|tiered|rebate`',
    `end_date` DATE COMMENT 'Date when the promotional campaign concludes and offers are no longer valid.',
    `event_classification` STRING COMMENT 'Specific promotional event type within the campaign (e.g., Flash Sale, Doorbuster, BOGO). [ENUM-REF-CANDIDATE: flash_sale|doorbuster|holiday_sale|weekly_circular|bogo|markdown|rebate — 7 candidates stripped; promote to reference product]',
    `geographic_scope` STRING COMMENT 'Geographic reach of the promotional campaign (national, regional, local, or specific stores).. Valid values are `national|regional|local|store_specific`',
    `loyalty_exclusive_flag` BOOLEAN COMMENT 'Indicates whether the campaign offers are exclusive to loyalty program members.',
    `modified_by` STRING COMMENT 'Name or identifier of the user who last modified the campaign record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when the campaign record was last updated.',
    `owner_email` STRING COMMENT 'Email address of the campaign owner for communication and escalation.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `owner_name` STRING COMMENT 'Name of the marketing manager or business owner responsible for the campaign execution and performance.',
    `priority_level` STRING COMMENT 'Business priority level of the campaign for resource allocation and conflict resolution.. Valid values are `critical|high|medium|low`',
    `promo_campaign_status` STRING COMMENT 'Current lifecycle status of the promotional campaign.. Valid values are `draft|scheduled|active|paused|completed|cancelled`',
    `stackable_flag` BOOLEAN COMMENT 'Indicates whether campaign offers can be combined with other promotions or coupons.',
    `start_date` DATE COMMENT 'Date when the promotional campaign becomes active and offers are available to customers.',
    `target_customer_reach` STRING COMMENT 'Number of unique customers the campaign aims to reach or engage.',
    `target_revenue` DECIMAL(18,2) COMMENT 'Expected revenue target for the promotional campaign period.',
    `target_units_sold` STRING COMMENT 'Target number of units expected to be sold during the promotional campaign.',
    `terms_and_conditions` STRING COMMENT 'Legal terms, conditions, and exclusions governing the promotional campaign offers.',
    `vendor_funded_flag` BOOLEAN COMMENT 'Indicates whether the promotional campaign is partially or fully funded by vendor cooperative marketing agreements.',
    CONSTRAINT pk_promo_campaign PRIMARY KEY(`promo_campaign_id`)
) COMMENT 'Master record for a promotional campaign representing a time-bound marketing initiative encompassing both the strategic campaign wrapper and discrete promotional sales events (Flash Sales, Doorbuster Events, Holiday Sales). Captures campaign name, type, start/end dates, event classification, budget, and performance targets.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`promo_offer` (
    `promo_offer_id` BIGINT COMMENT 'Unique identifier for the promotional offer. Primary key for this entity.',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Offers target specific categories (e.g., 20% off Apparel). Merchandising needs category-level offer visibility for pricing decisions, margin analysis, and assortment adjustments. Essential for categor',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Individual promotional offers require compliance validation against truth-in-advertising laws, consumer protection regulations, and industry-specific restrictions (alcohol, tobacco, pharmacy). Links o',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Different offer types (BOGO, percentage off, dollar off) may require different GL account treatments per accounting policy. Offer-level GL mapping enables proper expense classification for financial r',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Offers are tied to marketing campaigns for attribution and ROAS measurement. Retailers need to track which marketing campaigns drove which offers to optimize channel mix and measure campaign effective',
    `promo_campaign_id` BIGINT COMMENT 'Reference to the parent promotional campaign under which this offer is organized.',
    `promotion_stack_id` BIGINT COMMENT 'Foreign key linking to promotion.promotion_stack. Business justification: Offers can be part of promotion stacks (multiple offers that can be combined per stacking rules). The promotion_stack defines stacking rules (stack_type, stacking_rule, priority_rank), and offers need',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Seasonal offers (new season launch promotions, end-of-season clearance) require season context for merchandising coordination. Buyers need to see all offers planned for their seasons to coordinate inv',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Promotional offers target specific SKUs for discount application. Essential for offer eligibility validation, POS redemption logic, inventory planning for promoted items, and promotional ROI analysis',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor/supplier funding or co-funding this promotional offer. Null if retailer-funded.',
    `activation_trigger` STRING COMMENT 'Event or condition that activates this offer for a customer. manual = customer enters code; cart_threshold = automatically applied when cart meets criteria; login = activated upon customer login; geofence = triggered by location; time_based = activated at specific time; event_based = triggered by business event.. Valid values are `manual|cart_threshold|login|geofence|time_based|event_based`',
    `approval_status` STRING COMMENT 'Approval workflow status for this promotional offer. pending = awaiting approval; approved = authorized for execution; rejected = not approved.. Valid values are `pending|approved|rejected`',
    `approved_by` STRING COMMENT 'Name or identifier of the business user who approved this promotional offer. Null if not yet approved.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this promotional offer was approved. Null if not yet approved.',
    `channel_eligibility` STRING COMMENT 'Sales channels where this offer is valid. POS = in-store Point of Sale; ecommerce = online web storefront; mobile = mobile app; BOPIS = Buy Online Pick Up In Store; ROPIS = Reserve Online Pick Up In Store; all_channels = valid across all channels. [ENUM-REF-CANDIDATE: POS|ecommerce|mobile|BOPIS|ROPIS|call_center|kiosk — promote to reference product]. Valid values are `POS|ecommerce|mobile|BOPIS|ROPIS|all_channels`',
    `cost_share_percentage` DECIMAL(18,2) COMMENT 'Percentage of promotional discount cost borne by the vendor (0-100). Null if not applicable or fully retailer-funded.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this promotional offer record was first created in the system.',
    `customer_segment_eligibility` STRING COMMENT 'Defines which customer segments are eligible to redeem this offer. all_customers = no restrictions; loyalty_members = requires loyalty program membership; VIP = high-value customers only; new_customers = first-time buyers; targeted_segment = specific marketing segment.. Valid values are `all_customers|loyalty_members|VIP|new_customers|targeted_segment`',
    `digital_delivery_flag` BOOLEAN COMMENT 'Indicates whether this offer is delivered digitally (e.g., via email, mobile app push notification, personalized web banner). True = digital delivery; False = traditional circular/print or in-store signage only.',
    `discount_method` STRING COMMENT 'Method by which the discount is calculated and applied. Percentage = discount as a percentage of price; fixed_amount = flat dollar/currency discount; tiered = discount varies by purchase tier; quantity_based = discount based on quantity purchased.. Valid values are `percentage|fixed_amount|tiered|quantity_based`',
    `discount_value` DECIMAL(18,2) COMMENT 'Numeric value of the discount. Interpretation depends on discount_method: for percentage, this is the percentage (e.g., 15.00 for 15%); for fixed_amount, this is the currency amount (e.g., 5.00 for $5 off).',
    `display_message` STRING COMMENT 'Customer-facing promotional message displayed at Point of Sale (POS), e-commerce checkout, and mobile app. Concise marketing copy highlighting the offer value.',
    `effective_end_date` DATE COMMENT 'Date when this promotional offer expires and is no longer eligible for redemption. Null indicates an open-ended offer.',
    `effective_end_time` TIMESTAMP COMMENT 'Precise timestamp when this promotional offer expires, supporting time-of-day specific promotions. Null indicates no specific end time constraint.',
    `effective_start_date` DATE COMMENT 'Date when this promotional offer becomes active and eligible for redemption.',
    `effective_start_time` TIMESTAMP COMMENT 'Precise timestamp when this promotional offer becomes active, supporting time-of-day specific promotions (e.g., happy hour deals, flash sales).',
    `jurisdiction_restriction_flag` BOOLEAN COMMENT 'Indicates whether this offer has jurisdiction-specific restrictions (e.g., state-level promotional laws, EU consumer protection price display requirements). True = restrictions apply; False = no jurisdiction restrictions.',
    `maximum_redemption_per_customer` STRING COMMENT 'Maximum number of times a single customer can redeem this offer. Null indicates unlimited redemptions per customer.',
    `maximum_redemption_total` STRING COMMENT 'Maximum total number of redemptions allowed across all customers for this offer. Null indicates unlimited total redemptions.',
    `minimum_purchase_amount` DECIMAL(18,2) COMMENT 'Minimum purchase amount (in currency) required to qualify for this promotional offer. Null if no minimum threshold applies.',
    `minimum_purchase_quantity` STRING COMMENT 'Minimum quantity of eligible items required to qualify for this promotional offer. Null if no quantity threshold applies.',
    `modified_by` STRING COMMENT 'Name or identifier of the business user who last modified this promotional offer record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this promotional offer record was last modified.',
    `offer_code` STRING COMMENT 'Externally-known unique alphanumeric code for the promotional offer, used for redemption at Point of Sale (POS), e-commerce checkout, and mobile applications.. Valid values are `^[A-Z0-9]{6,20}$`',
    `offer_description` STRING COMMENT 'Detailed description of the promotional offer, including terms, conditions, and customer-facing messaging.',
    `offer_name` STRING COMMENT 'Human-readable name of the promotional offer for internal reference and customer-facing display.',
    `offer_priority` STRING COMMENT 'Priority ranking for offer application when multiple offers are eligible. Lower numbers indicate higher priority. Used by Point of Sale (POS) and e-commerce checkout engines to resolve offer conflicts.',
    `offer_status` STRING COMMENT 'Current lifecycle status of the promotional offer. draft = under development; scheduled = approved and awaiting activation; active = currently redeemable; paused = temporarily suspended; expired = past end date; cancelled = terminated before completion.. Valid values are `draft|scheduled|active|paused|expired|cancelled`',
    `offer_type` STRING COMMENT 'Classification of the promotional offer mechanics. BOGO = Buy One Get One; percent_off = percentage discount; dollar_off = fixed amount discount; free_gift = gift with purchase; bundle = bundled product deal; threshold_discount = discount upon reaching purchase threshold.. Valid values are `BOGO|percent_off|dollar_off|free_gift|bundle|threshold_discount`',
    `personalization_flag` BOOLEAN COMMENT 'Indicates whether this offer is personalized to individual customers based on purchase history, preferences, or predictive analytics. True = personalized; False = mass-market offer.',
    `product_eligibility_scope` STRING COMMENT 'Defines which products are eligible for this offer. all_products = applies to entire catalog; category = applies to specific product categories; SKU_list = applies to specific Stock Keeping Units (SKUs); brand = applies to specific brands; excluded_products = applies to all products except specified exclusions.. Valid values are `all_products|category|SKU_list|brand|excluded_products`',
    `restricted_jurisdictions` STRING COMMENT 'Comma-separated list of jurisdiction codes (ISO 3166-1 alpha-3 country codes or state/province codes) where this offer is restricted or prohibited due to regulatory compliance requirements. Null if no restrictions.',
    `stackable_flag` BOOLEAN COMMENT 'Indicates whether this offer can be combined (stacked) with other promotional offers in a single transaction. True = stackable; False = exclusive offer.',
    `store_eligibility_scope` STRING COMMENT 'Defines the scope of store eligibility for this offer. all_stores = valid at all retail locations; store_group = valid at a defined group of stores; individual_store = valid at specific stores only; excluded_stores = valid everywhere except specified stores.. Valid values are `all_stores|store_group|individual_store|excluded_stores`',
    `terms_and_conditions` STRING COMMENT 'Full legal terms and conditions text for this promotional offer, including disclaimers, exclusions, and fine print required for regulatory compliance.',
    `vendor_funded_flag` BOOLEAN COMMENT 'Indicates whether this promotional offer is funded (wholly or partially) by a vendor/supplier rather than the retailer. True = vendor-funded; False = retailer-funded.',
    `created_by` STRING COMMENT 'Name or identifier of the business user who created this promotional offer record.',
    CONSTRAINT pk_promo_offer PRIMARY KEY(`promo_offer_id`)
) COMMENT 'Defines a specific promotional offer within a campaign, representing the actual deal mechanics (BOGO, percent-off, dollar-off, free gift with purchase, bundle deal, threshold discount). Captures offer type, discount value, discount method (percentage vs. fixed), minimum purchase threshold, maximum redemption limit, stackability rules, offer priority, eligible SKUs/categories/product hierarchies (with inclusion/exclusion flags), channel eligibility (POS, e-commerce, mobile, BOPIS), store/store-group scope, digital delivery attributes (targeting segment, personalization, activation trigger) when applicable, effective date range, and jurisdictional compliance flags (e.g., state-level promotional restrictions, EU consumer protection price display requirements). This is the atomic unit of promotion logic executed at POS and e-commerce checkout engines. Encompasses SKU eligibility rules, channel assignments, store assignments, and digital offer mechanics as integral attributes. Supports international compliance by carrying jurisdiction-specific restriction flags that gate offer activation by market.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`coupon` (
    `coupon_id` BIGINT COMMENT 'Unique identifier for the coupon instrument. Primary key.',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Coupons are category-specific ("$5 off Grocery", "20% off Electronics"). Category managers track coupon redemption impact on sales velocity, margin, and inventory turn. Essential for category-level pr',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Coupons must comply with state-specific redemption laws, expiration disclosure requirements, and consumer protection regulations. Compliance program tracks legal framework governing coupon terms, cond',
    `tier_id` BIGINT COMMENT 'Foreign key linking to loyalty.tier. Business justification: Coupons frequently tier-gated (e.g., Platinum members: extra 20% off) - requires tier validation at redemption, supports VIP member retention strategies, and enables tier-specific promotional ROI an',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Coupons are distributed through marketing campaigns (email, social, paid media). Retailers link coupons to campaigns for redemption attribution, campaign ROI calculation, and understanding which marke',
    `promo_campaign_id` BIGINT COMMENT 'Reference to the parent promotional campaign under which this coupon was issued.',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_offer. Business justification: Coupons are instruments that implement specific promotional offers. While coupon already has promotion_campaign_id (linking to the campaign), it needs promo_offer_id to identify the exact offer the co',
    `promotion_stack_id` BIGINT COMMENT 'Foreign key linking to promotion.promotion_stack. Business justification: Coupons can be part of promotion stacks enabling multi-coupon stacking scenarios. The coupon has stackable_flag indicating it CAN stack, but doesnt indicate WHICH stack it belongs to. Adding promotio',
    `semantic_layer_entity_id` BIGINT COMMENT 'Foreign key linking to analytics.semantic_layer_entity. Business justification: Coupons are analytical entities for redemption analysis and customer segmentation. BI teams certify coupon entity definitions (grain, redemption metrics, eligibility rules) for self-service reporting.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Coupons restrict redemption to qualifying SKUs. POS systems validate coupon eligibility against product attributes (brand, category, vendor). Inventory planning uses this to forecast demand spikes. Ve',
    `vendor_id` BIGINT COMMENT 'Reference to the supplier or manufacturer funding the coupon, if applicable. Null for retailer-funded coupons.',
    `barcode` STRING COMMENT 'UPC or EAN barcode number for physical coupon scanning at POS. May be 12-digit UPC-A or 13-digit EAN format.. Valid values are `^[0-9]{12,14}$`',
    `coupon_code` STRING COMMENT 'Alphanumeric code that customers enter or scan to redeem the coupon. Unique business identifier for the coupon across all channels.. Valid values are `^[A-Z0-9]{6,20}$`',
    `coupon_status` STRING COMMENT 'Current lifecycle state of the coupon. active means available for redemption, inactive means not yet released, expired means past expiration_date, suspended means temporarily disabled, redeemed means fully used (for single-use coupons).. Valid values are `active|inactive|expired|suspended|redeemed`',
    `coupon_type` STRING COMMENT 'Classification of coupon by issuing authority and format. Manufacturer coupons are vendor-funded, store coupons are retailer-funded, digital coupons are app/email-based, paper coupons are physical print, loyalty coupons are tied to loyalty programs, vendor_funded are supplier co-op promotions.. Valid values are `manufacturer|store|digital|paper|loyalty|vendor_funded`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the coupon record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the face value (e.g., USD, CAD, EUR).. Valid values are `^[A-Z]{3}$`',
    `digital_distribution_quantity` STRING COMMENT 'Total number of digital coupon codes issued via email, app, or SMS. Null for paper-only coupons.',
    `digital_wallet_enabled_flag` BOOLEAN COMMENT 'Indicates whether this coupon can be stored in a digital wallet (mobile app, Apple Wallet, Google Pay) for redemption (True) or is paper-only (False).',
    `discount_type` STRING COMMENT 'Mechanism by which the coupon provides value. Percentage applies a percent off, fixed_amount deducts a dollar value, BOGO is buy-one-get-one, free_shipping waives delivery charges, tiered applies different discounts based on purchase thresholds.. Valid values are `percentage|fixed_amount|bogo|free_shipping|tiered`',
    `eligible_channel` STRING COMMENT 'Sales channels where the coupon can be redeemed. all_channels means omnichannel, pos is in-store only, ecommerce is online only, mobile_app is app-only, bopis is buy-online-pickup-in-store.. Valid values are `all_channels|pos|ecommerce|mobile_app|bopis`',
    `eligible_product_scope` STRING COMMENT 'Defines the breadth of products to which the coupon applies. all_products means store-wide, category restricts to a product category, brand restricts to a specific brand, sku restricts to specific SKUs, basket applies to entire cart total.. Valid values are `all_products|category|brand|sku|basket`',
    `exclusion_list` STRING COMMENT 'Comma-separated list of product SKUs, categories, or brands explicitly excluded from coupon eligibility. Null if no exclusions apply.',
    `expiration_date` DATE COMMENT 'Last date on which the coupon can be redeemed. After this date, the coupon is no longer valid.',
    `face_value` DECIMAL(18,2) COMMENT 'Nominal discount value of the coupon. For fixed_amount coupons, this is the dollar discount. For percentage coupons, this is the percentage (e.g., 15.00 for 15% off). For BOGO, may represent the value of the free item.',
    `geographic_restriction` STRING COMMENT 'Comma-separated list of geographic regions (states, provinces, countries) where the coupon is valid. Null if valid everywhere. Uses ISO 3166-1 alpha-3 country codes and ISO 3166-2 subdivision codes.',
    `issue_channel` STRING COMMENT 'Distribution channel through which the coupon was issued to customers. Circular refers to weekly print ads, mobile_app and email are digital channels, in_store_kiosk is physical print at store, website is online portal, social_media includes Facebook/Instagram ads, direct_mail is postal delivery, SMS is text message. [ENUM-REF-CANDIDATE: circular|mobile_app|email|in_store_kiosk|website|social_media|direct_mail|sms — 8 candidates stripped; promote to reference product]',
    `issue_date` DATE COMMENT 'Date on which the coupon was first made available to customers. Marks the start of the coupons validity window.',
    `issuing_authority` STRING COMMENT 'Entity responsible for funding and issuing the coupon. Retailer indicates store-funded, manufacturer indicates vendor-funded, vendor indicates supplier co-op, third_party indicates external promotion partner.. Valid values are `retailer|manufacturer|vendor|third_party`',
    `last_modified_by` STRING COMMENT 'User ID or system identifier of the person or process that last modified the coupon record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the coupon record was last updated.',
    `maximum_discount_amount` DECIMAL(18,2) COMMENT 'Cap on the total discount that can be applied by this coupon, regardless of cart value. Null if no cap applies. Relevant for percentage-based coupons.',
    `minimum_purchase_amount` DECIMAL(18,2) COMMENT 'Minimum transaction subtotal required to qualify for coupon redemption. Null if no minimum applies.',
    `print_quantity` STRING COMMENT 'Total number of physical paper coupons printed for distribution. Null for digital-only coupons.',
    `redemption_limit_per_customer` STRING COMMENT 'Maximum number of times a single customer can redeem this coupon. Null or 0 indicates unlimited redemptions per customer.',
    `single_use_flag` BOOLEAN COMMENT 'Indicates whether the coupon can only be used once (True) or multiple times (False) by the same customer, subject to redemption_limit_per_customer.',
    `stackable_flag` BOOLEAN COMMENT 'Indicates whether this coupon can be combined with other coupons or promotions in a single transaction (True) or must be used alone (False).',
    `terms_and_conditions` STRING COMMENT 'Full legal text of coupon usage terms, restrictions, and disclaimers. Required for regulatory compliance and customer transparency.',
    `total_redemption_limit` STRING COMMENT 'Maximum total number of redemptions allowed across all customers for this coupon. Null or 0 indicates unlimited total redemptions.',
    `created_by` STRING COMMENT 'User ID or system identifier of the person or process that created the coupon record.',
    CONSTRAINT pk_coupon PRIMARY KEY(`coupon_id`)
) COMMENT 'Master record for a coupon instrument issued as part of a promotional campaign. Captures coupon code, barcode/UPC, coupon type (manufacturer, store, digital, paper), face value, discount type, issue channel (circular, app, email, in-store kiosk), expiration date, single-use vs. multi-use flag, maximum redemption count, stackability with other offers, issuing authority (store vs. vendor-funded), and print/digital distribution quantity. Supports both digital wallet coupons and physical paper formats across POS and e-commerce channels. Coupon redemption events are recorded in promo_redemption (the SSOT for all redemption activity).';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`circular_ad` (
    `circular_ad_id` BIGINT COMMENT 'Unique identifier for the circular advertisement. Primary key for the circular ad entity.',
    `assortment_plan_id` BIGINT COMMENT 'Foreign key linking to merchandising.assortment_plan. Business justification: Circular ads feature products from specific assortment plans. Merchandising must coordinate featured items with inventory availability and ensure adequate stock depth for advertised items. Critical fo',
    `campaign_id` BIGINT COMMENT 'Reference to the parent promotional campaign that this circular supports. Links the circular to broader marketing initiatives and budget tracking.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Retail advertising circulars require pre-publication compliance review against FTC advertising guidelines, state deceptive practices laws, and pricing accuracy regulations. Links circular to complianc',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Circular production costs (printing, distribution) are charged to specific cost centers (marketing department, regional marketing). Required for budget tracking, variance analysis, and departmental P&',
    `creative_asset_id` BIGINT COMMENT 'Foreign key linking to marketing.creative_asset. Business justification: Circular ads contain creative assets managed in marketing asset libraries. Retailers link circular ads to constituent creative assets for asset performance tracking, reuse optimization, and ensuring b',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Circular ads feature specific hero SKUs on cover/pages. Production teams need product images, descriptions, compliance attributes. Inventory planning ensures featured items are in stock. Performance t',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Circular production and distribution costs post to specific GL accounts (advertising expense, printing expense, postage). Standard marketing accounting practice for financial statement preparation and',
    `associate_id` BIGINT COMMENT 'Reference to the user or manager who provided final approval for the circular to proceed to production.',
    `promo_budget_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_budget. Business justification: Circular ads have production costs (production_cost_amount, production_cost_currency_code) that are funded from promotional budgets. While circular_ad.promo_campaign_id links to campaign, the specific',
    `promo_calendar_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_calendar. Business justification: Circular ads are published according to promotional calendar periods. The circular_ad has effective_start_date and effective_end_date that align with promotional periods defined in promo_calendar (e.g',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Circular ads are marketing vehicles that promote specific promotional campaigns. While circular_ad already links to marketing.campaign (cross-domain for overall marketing campaign), it needs a link to',
    `report_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.report_definition. Business justification: Circular performance tracked via standard reports (reach, response rate, cost per impression). Marketing teams assign each circular to a performance report template. This link enables automated circul',
    `tertiary_circular_modified_by_user_associate_id` BIGINT COMMENT 'Reference to the user who most recently modified the circular record, supporting audit and accountability requirements.',
    `vendor_id` BIGINT COMMENT 'Reference to the external vendor or agency responsible for circular design, production, or distribution services.',
    `approval_date` DATE COMMENT 'Date when the circular content and design were officially approved for production and distribution by marketing management.',
    `circular_name` STRING COMMENT 'Marketing name or title of the circular advertisement, such as Weekly Savings, Holiday Spectacular, or Back to School Event.',
    `circular_number` STRING COMMENT 'Business identifier for the circular advertisement, typically a human-readable code or number used for reference in marketing and merchandising operations.',
    `circular_type` STRING COMMENT 'Classification of the circular advertisement based on its purpose and timing, such as weekly promotional circular, seasonal event, holiday special, clearance sale, or grand opening.. Valid values are `weekly|seasonal|holiday|event|clearance|grand_opening`',
    `compliance_review_flag` BOOLEAN COMMENT 'Indicates whether the circular has undergone legal and regulatory compliance review for advertising standards, pricing transparency, and consumer protection requirements. True if reviewed, false otherwise.',
    `cover_image_url` STRING COMMENT 'URL or file path to the cover image or hero graphic for the circular, used for digital display and thumbnail previews.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the circular record was first created in the system, used for audit trail and lifecycle tracking.',
    `digital_impressions_target` STRING COMMENT 'Target number of digital impressions or views for the circular across digital channels, used for campaign planning and performance measurement.',
    `distribution_channel` STRING COMMENT 'Primary channel through which the circular is distributed to customers, including print mail, digital web, email, mobile app, social media, or in-store display.. Valid values are `print|digital|email|mobile_app|social_media|in_store`',
    `edition_number` STRING COMMENT 'Edition or version number of the circular, used to track revisions and multiple releases within a campaign period.',
    `effective_end_date` DATE COMMENT 'Date when the promotional offers and pricing featured in the circular expire and are no longer valid for customer redemption.',
    `effective_start_date` DATE COMMENT 'Date when the promotional offers and pricing featured in the circular become valid and active for customer redemption.',
    `geographic_market` STRING COMMENT 'Geographic market or region where the circular is distributed, such as specific metro areas, states, or national coverage. Supports localized promotional strategies.',
    `is_vendor_funded` BOOLEAN COMMENT 'Indicates whether the circular includes vendor-funded promotional offers or co-op advertising agreements. True if vendor funding is involved, false otherwise.',
    `language_code` STRING COMMENT 'Two-letter ISO 639-1 language code indicating the primary language of the circular content, such as en for English or es for Spanish.. Valid values are `^[a-z]{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the circular record was most recently updated, used for audit trail and change tracking.',
    `notes` STRING COMMENT 'Free-text field for additional notes, special instructions, or context about the circular production, distribution, or performance.',
    `page_count` STRING COMMENT 'Total number of pages in the circular advertisement, used for production planning and cost management.',
    `pdf_file_url` STRING COMMENT 'URL or file path to the complete PDF version of the circular, used for digital distribution and archival purposes.',
    `print_quantity` STRING COMMENT 'Total number of physical copies printed for distribution, used for production cost tracking and circulation analysis. Null for digital-only circulars.',
    `production_cost_amount` DECIMAL(18,2) COMMENT 'Total cost to produce and distribute the circular, including design, printing, mailing, and digital distribution expenses. Used for marketing ROI analysis.',
    `production_cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the production cost amount, such as USD, CAD, or EUR.. Valid values are `^[A-Z]{3}$`',
    `production_status` STRING COMMENT 'Current lifecycle status of the circular in the production workflow, from initial draft through review, approval, production, publication, and archival.. Valid values are `draft|in_review|approved|in_production|published|archived`',
    `publication_date` DATE COMMENT 'Date when the circular advertisement is officially published or released to customers across distribution channels.',
    `target_audience` STRING COMMENT 'Primary customer segment or demographic targeted by this circular, such as families, millennials, budget shoppers, or loyalty members. Supports personalized marketing strategies.',
    `theme` STRING COMMENT 'Marketing theme or creative concept for the circular, such as Summer Savings, Holiday Gift Guide, or Spring Refresh, used for brand consistency and customer engagement.',
    `vendor_funding_amount` DECIMAL(18,2) COMMENT 'Total amount of vendor co-op funding or promotional allowances applied to this circular, used for cost allocation and vendor settlement.',
    CONSTRAINT pk_circular_ad PRIMARY KEY(`circular_ad_id`)
) COMMENT 'Master record for a printed or digital weekly/seasonal circular advertisement, including both the circular header and its featured item lines. Header captures circular name, edition number, publication date, effective date range, distribution channel (print, digital, email, app), geographic market coverage, page count, and production status. Item lines capture featured SKU, advertised price, promotional price, page number, position on page, feature type (front page, endcap feature, in-book), ad copy headline, image reference, and loss-leader flag. The circular is a key promotional vehicle in retail that drives planned traffic and is directly linked to campaign offers. Supports circular effectiveness analysis by item and planogram alignment with advertised features.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`rebate` (
    `rebate_id` BIGINT COMMENT 'Unique identifier for the rebate program. Primary key.',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Rebates are category-level incentives (appliance rebates, electronics rebates). Category managers track rebate impact on sales lift, margin erosion, and competitive positioning. Essential for category',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Rebate programs are heavily regulated with mandatory disclosure requirements, processing timeline limits, and consumer protection rules. Compliance program tracks regulatory framework (state rebate la',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Rebate liabilities and expenses post to specific GL accounts for accrual accounting. Required for accurate balance sheet (rebate liability) and P&L (rebate expense) reporting per GAAP/IFRS.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Rebates are promoted through marketing campaigns. Retailers track which campaigns drove rebate awareness and submissions to optimize marketing spend, measure campaign effectiveness, and attribute reba',
    `promo_campaign_id` BIGINT COMMENT 'Identifier of the parent promotional campaign or event to which this rebate belongs. Null if rebate is standalone.',
    `associate_id` BIGINT COMMENT 'Identifier of the manager or finance user who approved the rebate program for activation. Null if not yet approved.',
    `rebate_created_by_user_associate_id` BIGINT COMMENT 'Identifier of the system user or merchandising manager who created the rebate program record.',
    `rebate_last_modified_by_user_associate_id` BIGINT COMMENT 'Identifier of the system user who last modified the rebate program record.',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Seasonal rebates (spring lawn equipment, holiday electronics) require season alignment for merchandising planning. Buyers coordinate rebate timing with seasonal inventory builds and markdown strategie',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Rebates apply to specific qualifying products. Claim validation verifies purchased SKU matches rebate terms. Vendor chargeback reconciliation requires SKU-level tracking. Inventory planning adjusts fo',
    `vendor_id` BIGINT COMMENT 'Identifier of the supplier or vendor sponsoring or funding the rebate program. Null for retailer-funded rebates.',
    `amount` DECIMAL(18,2) COMMENT 'Fixed monetary value of the rebate in the transaction currency. Null if rebate is percentage-based.',
    `approval_status` STRING COMMENT 'Workflow approval state for the rebate program before it can be activated. Ensures financial and legal review compliance.. Valid values are `pending_approval|approved|rejected`',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the rebate program was approved. Null if not yet approved.',
    `channel_eligibility` STRING COMMENT 'Sales channels where the rebate can be redeemed: all_channels (any touchpoint), pos_only (in-store Point of Sale only), ecommerce_only (online purchases), mobile_app_only (mobile app transactions), or omnichannel (integrated cross-channel).. Valid values are `all_channels|pos_only|ecommerce_only|mobile_app_only|omnichannel`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the rebate program record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the rebate amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `customer_segment_eligibility` STRING COMMENT 'Comma-separated list of customer segment codes eligible for the rebate (e.g., loyalty_member, employee, senior, student). Null if available to all customers.',
    `rebate_description` STRING COMMENT 'Detailed internal description of the rebate program purpose, target audience, and business objectives. Used for internal planning and reporting.',
    `effective_end_date` DATE COMMENT 'Date when the rebate program expires and is no longer available for new submissions. Null for open-ended programs.',
    `effective_start_date` DATE COMMENT 'Date when the rebate program becomes active and eligible for customer redemption.',
    `exclusion_product_list` STRING COMMENT 'Comma-separated list of Stock Keeping Unit (SKU) codes or product categories explicitly excluded from the rebate program.',
    `geographic_eligibility` STRING COMMENT 'Comma-separated list of three-letter ISO country codes or region codes where the rebate is valid (e.g., USA, CAN, GBR). Null if available in all operating regions.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the rebate program record was last updated.',
    `marketing_message` STRING COMMENT 'Customer-facing promotional message displayed in circulars, digital ads, and at Point of Sale to communicate the rebate offer.',
    `maximum_rebate_amount` DECIMAL(18,2) COMMENT 'Cap on the total rebate value that can be claimed per transaction or per customer. Null if no cap applies.',
    `minimum_purchase_amount` DECIMAL(18,2) COMMENT 'Minimum transaction value required to qualify for the rebate. Null if no minimum threshold applies.',
    `minimum_purchase_quantity` STRING COMMENT 'Minimum number of qualifying units (Stock Keeping Units) that must be purchased to qualify for the rebate. Null if no quantity threshold applies.',
    `rebate_name` STRING COMMENT 'Marketing name of the rebate program displayed to customers and used in promotional materials.',
    `payment_method` STRING COMMENT 'Mechanism by which the rebate value is returned to the customer: check (mailed physical check), store_credit (loyalty account credit), digital_credit (e-wallet or app credit), prepaid_card (branded debit card), bank_transfer (direct deposit), or instant_discount (applied at Point of Sale).. Valid values are `check|store_credit|digital_credit|prepaid_card|bank_transfer|instant_discount`',
    `payment_processing_days` STRING COMMENT 'Expected number of business days from rebate approval to payment issuance. Used for customer Service Level Agreement (SLA) communication.',
    `percentage` DECIMAL(18,2) COMMENT 'Percentage discount applied as rebate (e.g., 10.00 for 10% off). Null if rebate is fixed-amount.',
    `qualifying_product_list` STRING COMMENT 'Comma-separated list of Stock Keeping Unit (SKU) codes, Universal Product Code (UPC) numbers, or product category codes that qualify for the rebate. Null if rebate applies to all products.',
    `rebate_number` STRING COMMENT 'Externally-visible unique business identifier for the rebate program, used in customer communications and vendor agreements.. Valid values are `^RBT-[A-Z0-9]{8,12}$`',
    `rebate_status` STRING COMMENT 'Current lifecycle state of the rebate program: draft (being configured), active (live and accepting submissions), paused (temporarily suspended), expired (past end date), cancelled (terminated early), or completed (ended successfully).. Valid values are `draft|active|paused|expired|cancelled|completed`',
    `rebate_type` STRING COMMENT 'Classification of the rebate mechanism: instant rebate (applied at Point of Sale), mail-in rebate (customer submits proof of purchase), vendor-funded rebate (supplier-sponsored), digital rebate (online redemption), promotional allowance (trade promotion), or volume rebate (quantity-based incentive).. Valid values are `instant_rebate|mail_in_rebate|vendor_funded_rebate|digital_rebate|promotional_allowance|volume_rebate`',
    `redemption_limit_per_customer` STRING COMMENT 'Maximum number of times a single customer can claim this rebate during the program period. Null if no limit applies.',
    `redemption_limit_per_transaction` STRING COMMENT 'Maximum number of rebate instances that can be applied in a single transaction. Null if no limit applies.',
    `requires_proof_of_purchase` BOOLEAN COMMENT 'Indicates whether customers must submit receipt or purchase documentation to claim the rebate. True for mail-in rebates, false for instant rebates applied at Point of Sale.',
    `stackable_with_other_promotions` BOOLEAN COMMENT 'Indicates whether this rebate can be combined with other promotional offers (coupons, markdowns, Buy One Get One (BOGO) deals) in the same transaction.',
    `submission_deadline_date` DATE COMMENT 'Final date by which customers must submit rebate claims for purchases made during the effective period. Typically extends beyond the effective end date for mail-in rebates.',
    `terms_and_conditions` STRING COMMENT 'Full legal text of the rebate program terms, conditions, restrictions, and disclaimers. Must comply with Federal Trade Commission (FTC) disclosure requirements.',
    `total_budget_amount` DECIMAL(18,2) COMMENT 'Total financial budget allocated for the rebate program. Used for cost control and Return on Investment (ROI) tracking. Null if budget is uncapped.',
    `vendor_funding_percentage` DECIMAL(18,2) COMMENT 'Percentage of the rebate cost funded by the vendor in co-op promotional agreements (e.g., 75.00 means vendor pays 75%, retailer pays 25%). Null for fully retailer-funded rebates.',
    CONSTRAINT pk_rebate PRIMARY KEY(`rebate_id`)
) COMMENT 'Master record for a rebate program offered to customers or funded by vendors. Captures rebate name, rebate type (instant rebate, mail-in rebate, vendor-funded rebate), rebate amount or percentage, qualifying purchase conditions, submission deadline, payment method (check, store credit, digital credit), sponsoring vendor, and rebate program status. Supports both consumer-facing rebates and vendor-funded promotional allowances.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` (
    `rebate_claim_id` BIGINT COMMENT 'Unique identifier for the rebate claim transaction. Primary key for the rebate claim entity.',
    `ap_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ap_invoice. Business justification: Approved rebate claims generate AP invoices (payable to customers) for payment processing. Links promotional claim to financial settlement document for reconciliation, audit trail, and cash management',
    `associate_id` BIGINT COMMENT 'Identifier of the employee who reviewed and processed the rebate claim. Supports audit trail and workload distribution analysis.',
    `dq_rule_id` BIGINT COMMENT 'Foreign key linking to analytics.dq_rule. Business justification: Claims data subject to quality rules (duplicate detection, amount threshold validation, documentation completeness checks). Finance systems apply specific DQ rules to each claim during processing. Fai',
    `header_id` BIGINT COMMENT 'Identifier of the qualifying purchase order that entitles the claimant to the rebate. Links to the order transaction record.',
    `location_id` BIGINT COMMENT 'Identifier of the retail store location where the qualifying purchase was made. Links to store master for location-based rebate analysis.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Rebate claims must be attributed to the marketing campaigns that drove awareness. Retailers track which campaigns generated rebate submissions to measure campaign effectiveness, calculate true campaig',
    `profile_id` BIGINT COMMENT 'Identifier of the customer who submitted the rebate claim. Links to the customer master record for claimant identity and contact information.',
    `promo_campaign_id` BIGINT COMMENT 'Identifier of the promotional campaign or rebate program under which this claim is being submitted. Links to the promotion master record.',
    `rebate_id` BIGINT COMMENT 'Foreign key linking to promotion.rebate. Business justification: Each rebate claim is submitted against a specific rebate program. The rebate_claim table currently has promo_campaign_id (linking to the campaign) but is missing the direct link to the rebate master r',
    `vendor_id` BIGINT COMMENT 'Identifier of the vendor or supplier funding the rebate program. Used for vendor-funded rebate tracking and chargeback reconciliation.',
    `approval_date` DATE COMMENT 'Date when the rebate claim was approved for payment. Triggers payment processing workflow and liability recognition.',
    `approved_amount` DECIMAL(18,2) COMMENT 'Dollar amount of rebate approved for payment after claim review and validation. May differ from claimed amount if adjustments are made.',
    `claim_number` STRING COMMENT 'Externally-visible unique business identifier for the rebate claim, used for customer and vendor communication and tracking.. Valid values are `^RBC-[0-9]{10}$`',
    `claim_status` STRING COMMENT 'Current lifecycle status of the rebate claim in the processing workflow. Tracks progression from submission through final disposition.. Valid values are `submitted|under_review|approved|rejected|paid|cancelled`',
    `claimant_email` STRING COMMENT 'Primary email address of the claimant for claim status notifications and correspondence.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `claimant_name` STRING COMMENT 'Full legal name of the individual or organization submitting the rebate claim. Used for correspondence and payment processing.',
    `claimant_phone` STRING COMMENT 'Primary contact phone number for the claimant. Used for claim verification and issue resolution.',
    `claimant_type` STRING COMMENT 'Classification of the party submitting the rebate claim. Distinguishes between customer rebates, vendor-funded rebates, and supplier chargebacks.. Valid values are `customer|vendor|supplier|partner`',
    `claimed_amount` DECIMAL(18,2) COMMENT 'Dollar amount of rebate being claimed by the claimant. Subject to validation against promotion terms and purchase amount.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this rebate claim record was first created in the system. Used for audit trail and data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this claim (purchase amount, claimed amount, approved amount).. Valid values are `^[A-Z]{3}$`',
    `days_to_approval` STRING COMMENT 'Actual number of calendar days from claim submission to approval decision. Used for SLA performance measurement and process optimization.',
    `documentation_status` STRING COMMENT 'Status of required supporting documentation (receipts, proof of purchase, UPC codes) for the rebate claim. Determines claim processing readiness.. Valid values are `complete|incomplete|pending|verified`',
    `fraud_flag` BOOLEAN COMMENT 'Indicates whether the claim has been flagged for potential fraudulent activity. Triggers enhanced review and investigation procedures.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this rebate claim record was most recently updated. Supports change tracking and audit compliance.',
    `notes` STRING COMMENT 'Free-text notes and comments added by claims processors during review. Captures special circumstances, exceptions, and processing decisions.',
    `payment_date` DATE COMMENT 'Date when the approved rebate amount was disbursed to the claimant. Marks final claim closure and liability settlement.',
    `payment_method` STRING COMMENT 'Method used to disburse the approved rebate amount to the claimant. Supports payment reconciliation and claimant preference tracking.. Valid values are `check|direct_deposit|prepaid_card|store_credit|digital_wallet`',
    `payment_reference_number` STRING COMMENT 'Unique reference number for the rebate payment transaction. Used for payment tracking, reconciliation, and claimant inquiry resolution.',
    `processing_sla_days` STRING COMMENT 'Number of business days allowed for claim processing per the rebate program terms. Used to track SLA compliance and processing efficiency.',
    `product_sku` STRING COMMENT 'Internal SKU identifier of the qualifying product. Links to product master for eligibility validation and rebate calculation.',
    `purchase_amount` DECIMAL(18,2) COMMENT 'Total purchase amount of the qualifying transaction. Used to calculate rebate entitlement and validate claim eligibility.',
    `purchase_date` DATE COMMENT 'Date of the qualifying purchase transaction that triggered rebate eligibility. Used to validate claim timing against promotion period.',
    `receipt_uploaded` BOOLEAN COMMENT 'Indicates whether the claimant has uploaded a digital copy of the purchase receipt as supporting documentation.',
    `rejection_date` DATE COMMENT 'Date when the rebate claim was rejected. Marks final disposition for ineligible or invalid claims.',
    `rejection_reason_code` STRING COMMENT 'Standardized code indicating the primary reason for claim rejection. Supports rejection pattern analysis and process improvement.. Valid values are `INELIGIBLE_PRODUCT|EXPIRED_PROMOTION|MISSING_DOCUMENTATION|DUPLICATE_CLAIM|INVALID_PURCHASE|OTHER`',
    `rejection_reason_description` STRING COMMENT 'Detailed explanation of why the rebate claim was rejected. Provided to claimant for transparency and potential resubmission guidance.',
    `review_date` DATE COMMENT 'Date when the rebate claim was reviewed by claims processing team. Marks transition from submitted to under review status.',
    `submission_channel` STRING COMMENT 'Channel or interface through which the rebate claim was submitted. Supports omnichannel claim tracking and channel effectiveness analysis.. Valid values are `web|mobile_app|email|mail|in_store|call_center`',
    `submission_date` DATE COMMENT 'Date when the rebate claim was originally submitted by the claimant. Principal business event timestamp for the claim lifecycle.',
    `submission_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the rebate claim was submitted, including time-of-day for audit and SLA tracking purposes.',
    `upc_code` STRING COMMENT '12-digit UPC barcode of the qualifying product purchased. Used to validate product eligibility for the rebate program.. Valid values are `^[0-9]{12}$`',
    `vendor_chargeback_status` STRING COMMENT 'Status of the chargeback claim submitted to the vendor for reimbursement of the rebate payment. Tracks vendor-funded rebate reconciliation.. Valid values are `pending|submitted|approved|disputed|settled`',
    CONSTRAINT pk_rebate_claim PRIMARY KEY(`rebate_claim_id`)
) COMMENT 'Transactional record for a customer or vendor rebate claim submission. Captures claim submission date, claimant identity, qualifying purchase reference, rebate amount claimed, supporting documentation status, claim processing status (submitted, under review, approved, rejected, paid), rejection reason, approval date, and payment disbursement date. Supports rebate liability tracking and vendor chargeback reconciliation.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` (
    `vendor_promo_agreement_id` BIGINT COMMENT 'Unique identifier for the vendor-funded promotional agreement record. Primary key.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Vendor funding accruals post to specific GL accounts (co-op advertising receivable, vendor allowance). Required for proper accounting of vendor-funded promotions and chargeback processing per retail a',
    `associate_id` BIGINT COMMENT 'Identifier of the internal user or manager who approved this promotional agreement.',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Vendor promotional agreements (co-op advertising, promotional allowances) fund specific promotional campaigns. The vendor_promo_agreement table currently only links to vendor but needs promo_campaign_',
    `vendor_id` BIGINT COMMENT 'Identifier of the vendor or supplier providing promotional funding for this agreement.',
    `accrual_method` STRING COMMENT 'Method used to calculate promotional funding accrual. Purchase-based: accrues on retailer purchase volume. Sales-based: accrues on consumer sales (scan data). Display-based: accrues on compliance with display requirements. Hybrid: combination of methods.. Valid values are `purchase-based|sales-based|display-based|hybrid`',
    `ad_placement_required` BOOLEAN COMMENT 'Indicates whether the retailer must feature the product in circular ads, digital promotions, or other marketing materials to qualify for co-op advertising funding.',
    `agreement_name` STRING COMMENT 'Human-readable descriptive name for the promotional agreement, typically including campaign theme or product category.',
    `agreement_number` STRING COMMENT 'Externally-known unique business identifier for the promotional agreement, used in vendor communications and settlement documents.',
    `agreement_type` STRING COMMENT 'Classification of the vendor promotional funding mechanism. Co-op advertising: shared advertising cost. Off-invoice allowance: upfront discount on purchase invoice. Bill-back: post-event reimbursement. Scan allowance: per-unit sold rebate. New item allowance: slotting fee for new SKU introduction. Volume rebate: tiered discount based on purchase volume.. Valid values are `co-op advertising|off-invoice allowance|bill-back|scan allowance|new item allowance|volume rebate`',
    `approval_date` DATE COMMENT 'Date when the promotional agreement was internally approved and authorized for execution.',
    `chargeback_eligible` BOOLEAN COMMENT 'Indicates whether the retailer can issue chargebacks to the vendor for non-compliance with agreement terms (e.g., late delivery, incorrect pricing, missing promotional materials).',
    `chargeback_penalty_amount` DECIMAL(18,2) COMMENT 'Fixed monetary penalty amount per chargeback incident for vendor non-compliance, in the agreement currency. Nullable if chargeback is not eligible or penalty is variable.',
    `contract_document_reference` STRING COMMENT 'Reference identifier or file path to the signed legal contract or agreement document stored in the document management system.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this promotional agreement record was first created in the system.',
    `display_compliance_required` BOOLEAN COMMENT 'Indicates whether the retailer must meet specific in-store display requirements (endcap placement, planogram compliance, shelf positioning) to qualify for funding.',
    `effective_end_date` DATE COMMENT 'Date when the promotional agreement expires and funding accrual ceases. Nullable for open-ended agreements.',
    `effective_start_date` DATE COMMENT 'Date when the promotional agreement becomes active and funding accrual begins.',
    `funding_amount` DECIMAL(18,2) COMMENT 'Total monetary value of vendor promotional funding committed under this agreement, in the agreement currency.',
    `funding_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the funding amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `funding_percentage` DECIMAL(18,2) COMMENT 'Percentage of qualifying costs or sales that the vendor will fund, expressed as a decimal (e.g., 15.00 for 15%). Used for co-op advertising and scan-based allowances.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this promotional agreement record was most recently updated.',
    `minimum_purchase_amount` DECIMAL(18,2) COMMENT 'Minimum monetary value of purchases required to qualify for the promotional funding, in the agreement currency. Nullable if no minimum applies.',
    `minimum_purchase_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity of product that must be purchased to qualify for the promotional funding. Nullable if no minimum applies.',
    `notes` STRING COMMENT 'Free-text field for additional comments, special conditions, or internal notes related to the promotional agreement.',
    `outstanding_balance` DECIMAL(18,2) COMMENT 'Difference between total accrued amount and total settled amount, representing funding owed by the vendor but not yet paid, in the agreement currency.',
    `performance_obligation_description` STRING COMMENT 'Detailed narrative of the retailers obligations under this agreement, including display requirements, advertising commitments, volume targets, and reporting duties.',
    `qualifying_product_scope` STRING COMMENT 'Defines which products are eligible for promotional funding under this agreement. Specific SKU: single item. Product category: all items in a category. Brand: all items of a vendor brand. Private label: retailer-branded items.. Valid values are `all products|specific SKU|product category|brand|private label`',
    `settlement_frequency` STRING COMMENT 'Frequency at which funding settlements or accruals are processed under this agreement.. Valid values are `one-time|weekly|monthly|quarterly|annually|event-based`',
    `settlement_terms` STRING COMMENT 'Defines how and when the vendor funding will be paid or credited. Upfront credit: applied at purchase. Monthly accrual: credited monthly. Quarterly settlement: paid quarterly. Post-event claim: retailer submits claim after promotion ends. Scan-based settlement: paid based on POS scan data.. Valid values are `upfront credit|monthly accrual|quarterly settlement|post-event claim|scan-based settlement`',
    `termination_date` DATE COMMENT 'Date when the agreement was terminated early, if applicable. Nullable for agreements that completed normally or are still active.',
    `termination_reason` STRING COMMENT 'Explanation for early termination of the agreement, such as vendor non-compliance, retailer strategic change, or mutual agreement. Nullable if not terminated.',
    `total_accrued_amount` DECIMAL(18,2) COMMENT 'Cumulative amount of promotional funding accrued to date under this agreement, in the agreement currency. Updated as qualifying events occur.',
    `total_settled_amount` DECIMAL(18,2) COMMENT 'Cumulative amount of promotional funding that has been paid or credited to the retailer to date, in the agreement currency.',
    `vendor_promo_agreement_status` STRING COMMENT 'Current lifecycle state of the promotional agreement. Draft: under negotiation. Pending approval: awaiting internal sign-off. Active: in effect and accruing. Suspended: temporarily paused. Completed: ended normally. Terminated: ended early. Settled: financially reconciled. [ENUM-REF-CANDIDATE: draft|pending approval|active|suspended|completed|terminated|settled — 7 candidates stripped; promote to reference product]',
    CONSTRAINT pk_vendor_promo_agreement PRIMARY KEY(`vendor_promo_agreement_id`)
) COMMENT 'Master record for a vendor-funded promotional agreement (co-op advertising, promotional allowance, scan-based trading deal). Captures vendor identifier, agreement type (co-op ad, off-invoice allowance, bill-back, scan allowance, new item allowance), agreed funding amount, funding percentage, qualifying conditions (minimum volume, display compliance, ad placement), performance obligations, agreement start/end dates, settlement terms, and agreement status. Distinct from the supplier contract in the supplier domain — this is specifically the promotional funding arrangement that drives vendor chargeback and deduction management. Supports accounts receivable accrual and vendor compliance auditing.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` (
    `vendor_promo_claim_id` BIGINT COMMENT 'Unique identifier for the vendor promotional funding claim. Primary key.',
    `ap_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ap_invoice. Business justification: Vendor promotional claims generate AP credit memos or debit memos for settlement. Links claim to financial document for vendor chargeback processing, payment reconciliation, and vendor statement match',
    `associate_id` BIGINT COMMENT 'Reference to the internal user or employee who prepared and submitted the claim.',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor or supplier against whom this promotional funding claim is made.',
    `vendor_promo_agreement_id` BIGINT COMMENT 'Reference to the vendor promotional agreement under which this claim is submitted.',
    `approved_amount` DECIMAL(18,2) COMMENT 'Monetary amount approved by the vendor for payment, which may differ from the claimed amount due to disputes or partial approvals.',
    `claim_date` DATE COMMENT 'Date on which the promotional funding claim was created or initiated by the retailer.',
    `claim_notes` STRING COMMENT 'Free-text notes or comments regarding the claim, including internal notes, vendor communications, or special circumstances.',
    `claim_number` STRING COMMENT 'Externally visible unique claim number used for tracking and communication with vendors.',
    `claim_period_end_date` DATE COMMENT 'End date of the promotional period or sales period covered by this claim.',
    `claim_period_start_date` DATE COMMENT 'Start date of the promotional period or sales period covered by this claim.',
    `claim_source_system` STRING COMMENT 'Name or identifier of the source system that originated the claim data, such as the retail merchandising system Price Management (RPM), SAP Customer Activity Repository (CAR), or manual entry.',
    `claim_status` STRING COMMENT 'Current lifecycle status of the vendor promotional claim: draft (being prepared), submitted (sent to vendor), under_review (vendor reviewing), disputed (vendor challenged), approved (vendor accepted), partially_approved (partial acceptance), rejected (vendor denied), settled (payment received), cancelled (claim withdrawn). [ENUM-REF-CANDIDATE: draft|submitted|under_review|disputed|approved|partially_approved|rejected|settled|cancelled — 9 candidates stripped; promote to reference product]',
    `claim_type` STRING COMMENT 'Type of vendor promotional funding claim: scan allowance (per-unit sold), bill-back (post-event invoice), co-op reimbursement (shared marketing cost), markdown allowance (price reduction funding), volume rebate (tier-based incentive), or slotting fee (shelf placement fee recovery).. Valid values are `scan_allowance|bill_back|co_op_reimbursement|markdown_allowance|volume_rebate|slotting_fee`',
    `claimed_amount` DECIMAL(18,2) COMMENT 'Total monetary amount claimed by the retailer from the vendor for promotional funding, in the claim currency.',
    `cost_center_code` STRING COMMENT 'Cost center or department code responsible for managing the vendor promotional agreement and claim.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the vendor promotional claim record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this claim (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `dispute_reason` STRING COMMENT 'Vendor-provided explanation or reason code for disputing all or part of the claim, such as sales data discrepancy, agreement terms interpretation, or documentation insufficiency.',
    `dispute_resolution_date` DATE COMMENT 'Date on which a disputed claim was resolved through negotiation, arbitration, or mutual agreement.',
    `disputed_amount` DECIMAL(18,2) COMMENT 'Monetary amount under dispute between the retailer and vendor, representing the difference between claimed and approved amounts.',
    `gl_account_code` STRING COMMENT 'General Ledger account code to which the vendor promotional funding receivable or settlement is posted for financial reporting.',
    `is_automated_claim` BOOLEAN COMMENT 'Boolean flag indicating whether the claim was generated automatically by the system based on Point of Sale (POS) scan data and agreement rules (True) or manually created by a user (False).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the vendor promotional claim record was last updated or modified.',
    `payment_method` STRING COMMENT 'Method by which the vendor settled the claim: check, wire transfer, Automated Clearing House (ACH), credit memo applied to future purchases, offset against accounts payable, or other method.. Valid values are `check|wire_transfer|ach|credit_memo|offset_against_payables|other`',
    `payment_reference_number` STRING COMMENT 'Vendor-provided payment reference number, check number, wire confirmation, or transaction identifier for the settlement payment.',
    `sales_revenue` DECIMAL(18,2) COMMENT 'Total gross sales revenue generated during the claim period for products covered by the vendor promotional agreement, used as supporting evidence for the claim.',
    `settled_amount` DECIMAL(18,2) COMMENT 'Actual monetary amount received from the vendor as final settlement of the claim, reflecting any adjustments or deductions.',
    `settlement_date` DATE COMMENT 'Date on which the vendor payment was received and the claim was financially settled.',
    `submission_date` DATE COMMENT 'Date on which the claim was formally submitted to the vendor for review and approval.',
    `supporting_document_reference` STRING COMMENT 'Reference identifier or URI to supporting documentation such as Point of Sale (POS) transaction reports, sales summaries, or promotional performance reports submitted with the claim.',
    `units_sold` DECIMAL(18,2) COMMENT 'Total quantity of Stock Keeping Units (SKUs) sold during the claim period that qualify for vendor promotional funding.',
    `vendor_acknowledgment_date` DATE COMMENT 'Date on which the vendor formally acknowledged receipt of the claim submission.',
    `vendor_response_date` DATE COMMENT 'Date on which the vendor provided their formal response (approval, partial approval, dispute, or rejection) to the claim.',
    CONSTRAINT pk_vendor_promo_claim PRIMARY KEY(`vendor_promo_claim_id`)
) COMMENT 'Transactional record for a vendor promotional funding claim submitted by the retailer against a vendor promo agreement. Captures claim date, agreement reference, claim type (scan allowance, bill-back, co-op reimbursement), claimed amount, supporting sales evidence, claim status (submitted, disputed, approved, settled), vendor acknowledgment date, and settlement amount. Supports accounts receivable from vendors and promotional ROI reconciliation.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` (
    `promo_redemption_id` BIGINT COMMENT 'Unique identifier for each promotional offer redemption instance. Primary key for the promo_redemption product.',
    `associate_id` BIGINT COMMENT 'Reference to the store associate or cashier who processed the transaction and applied the promotion. Populated for POS transactions. Null for e-commerce.',
    `attribution_touchpoint_id` BIGINT COMMENT 'Foreign key linking to marketing.attribution_touchpoint. Business justification: Promotional redemptions must be attributed to marketing touchpoints for multi-touch attribution modeling. Retailers need to understand which marketing channels and tactics drove promotional engagement',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Redemption analysis by category is essential for merchandising to assess promotional effectiveness, cannibalization, and incremental sales. Category managers use redemption data to adjust future assor',
    `coupon_id` BIGINT COMMENT 'Foreign key linking to promotion.coupon. Business justification: When a redemption is triggered by a coupon, promo_redemption needs a structured FK to the coupon master record. Currently has coupon_code as STRING, which should be replaced with coupon_id FK. This en',
    `fulfillment_order_id` BIGINT COMMENT 'Foreign key linking to fulfillment.fulfillment_order. Business justification: Retail operations measure promotional effectiveness by fulfillment method (BOPIS vs ship-from-store vs DC fulfillment). Links redemptions to fulfillment execution for channel-specific lift analysis, v',
    `header_id` BIGINT COMMENT 'Foreign key linking to order.order_header. Business justification: Promotion redemptions in e-commerce/omnichannel orders need order-level context for multi-line promotion analysis, customer journey tracking, and cross-channel promotional effectiveness measurement. D',
    `journal_entry_id` BIGINT COMMENT 'Foreign key linking to finance.journal_entry. Business justification: High-value or manual redemptions may require direct journal entries for accounting adjustments (e.g., promotional allowance corrections, fraud writeoffs). Links promotional activity to financial posti',
    `location_id` BIGINT COMMENT 'Reference to the physical store location where the redemption occurred. Populated for POS and BOPIS transactions. Null for pure e-commerce fulfillment.',
    `loyalty_membership_id` BIGINT COMMENT 'Foreign key linking to loyalty.membership. Business justification: Redemptions must track which loyalty member redeemed the promotion to accrue points, update tier qualification metrics, and reconcile promotional liability with loyalty liability - core operational re',
    `pos_terminal_id` BIGINT COMMENT 'Identifier of the POS terminal or register where the redemption was processed. Used for audit trail and fraud detection. Null for e-commerce transactions.',
    `pos_transaction_id` BIGINT COMMENT 'Reference to the customer transaction (POS or e-commerce order) where this promotion was applied. Links to the sales transaction header.',
    `sku_id` BIGINT COMMENT 'add column product_sku_id (BIGINT) with FK to product.sku.sku_id - redemptions occur against specific SKUs and this is essential for promotion effectiveness analysis at item level',
    `profile_id` BIGINT COMMENT 'Reference to the customer who redeemed the promotion. May be null for anonymous transactions where no customer identification was captured.',
    `promo_campaign_id` BIGINT COMMENT 'Reference to the promotional offer that was redeemed. Links to the promotion master data defining the offer terms, discount rules, and eligibility criteria.',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_offer. Business justification: Promotional redemptions capture the application of a specific promotional offer to a transaction. While promo_redemption already has promo_campaign_id, it needs promo_offer_id to identify the exact of',
    `promotion_stack_id` BIGINT COMMENT 'Identifier for the group of promotions applied together in a single transaction when promotion stacking is allowed. Multiple redemptions with the same stack_id were applied simultaneously.',
    `rebate_id` BIGINT COMMENT 'Foreign key linking to promotion.rebate. Business justification: Redemptions can be for rebate offers specifically. A customer may redeem a rebate offer at transaction time (e.g., instant rebate applied at POS), and tracking which rebate was redeemed is essential f',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor or supplier funding the promotion. Populated only when vendor_funded_flag is true. Used for chargeback processing and vendor settlement.',
    `chargeback_amount` DECIMAL(18,2) COMMENT 'The amount claimed from or paid by the vendor for this promotion redemption. May differ from discount_amount due to negotiated funding rates or caps.',
    `chargeback_status` STRING COMMENT 'Status of the vendor chargeback claim for vendor-funded promotions. Tracks the lifecycle from pending submission through payment receipt.. Valid values are `pending|submitted|approved|rejected|paid`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this redemption record was first created in the database. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the discount amount. Supports multi-currency operations across international markets.. Valid values are `^[A-Z]{3}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'The monetary value of the discount granted to the customer through this promotion redemption. Expressed in the transaction currency. Critical for promotional ROI calculation and vendor chargeback reconciliation.',
    `discount_type` STRING COMMENT 'The category of discount applied. Distinguishes between percentage-based discounts, fixed dollar amounts, buy-one-get-one offers, bundle deals, spend threshold promotions, and shipping incentives.. Valid values are `percentage_off|fixed_amount_off|bogo|bundle_discount|threshold_discount|free_shipping`',
    `final_price` DECIMAL(18,2) COMMENT 'The post-discount price after this promotion was applied. May differ from transaction final price if multiple promotions were stacked.',
    `fraud_score` DECIMAL(18,2) COMMENT 'Risk score assigned by fraud detection algorithms to assess the likelihood of fraudulent coupon use or promotion abuse. Higher scores indicate higher risk. Scale 0-100.',
    `loyalty_points_earned` STRING COMMENT 'The number of loyalty program points awarded to the customer as part of this promotion redemption. Null if the promotion does not include a points component.',
    `loyalty_points_redeemed` STRING COMMENT 'The number of loyalty program points the customer spent to activate or qualify for this promotion. Null if no points were used.',
    `modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this redemption record was last updated. Tracks changes to status, chargeback processing, or validation outcomes.',
    `original_price` DECIMAL(18,2) COMMENT 'The pre-discount price of the item or basket to which the promotion was applied. Used to calculate discount percentage and promotional lift.',
    `processing_system` STRING COMMENT 'The system or platform that processed and validated the promotion redemption. Identifies the source system for audit and reconciliation purposes.. Valid values are `pos|ecommerce_engine|oms|loyalty_platform|promotion_engine`',
    `promotion_tier` STRING COMMENT 'The tier or level of the promotion when tiered discount structures are used (e.g., spend $50 get 10% off, spend $100 get 20% off). Indicates which threshold was achieved.',
    `quantity_redeemed` STRING COMMENT 'The number of units or items to which the promotion was applied. For BOGO offers, represents the number of qualifying item sets. For single-item discounts, typically 1.',
    `redemption_channel` STRING COMMENT 'The sales channel through which the promotion was redeemed. Distinguishes between in-store POS, e-commerce platforms, mobile apps, and other customer touchpoints.. Valid values are `pos|ecommerce_web|ecommerce_mobile|call_center|kiosk|mobile_app`',
    `redemption_limit_type` STRING COMMENT 'The scope of redemption limits enforced for this promotion. Indicates whether limits apply per customer, per transaction, per day, or across the entire campaign period.. Valid values are `per_customer|per_transaction|per_day|per_campaign|unlimited`',
    `redemption_mechanism` STRING COMMENT 'Method by which the promotion was applied to the transaction. Indicates whether the discount was automatically triggered by system rules, manually entered via coupon code, applied through loyalty program, or activated through other channels. [ENUM-REF-CANDIDATE: automatic_system_triggered|coupon_code_entry|loyalty_auto_apply|cart_rule|manual_cashier_apply|mobile_app_clip|digital_wallet — 7 candidates stripped; promote to reference product]',
    `redemption_sequence_number` STRING COMMENT 'The sequential count of this redemption within the applicable limit scope. For example, if limit is per_customer, this tracks which redemption number this is for that customer (1st, 2nd, 3rd, etc.).',
    `redemption_status` STRING COMMENT 'Validation status of the promotion redemption. Indicates whether the redemption was successfully processed or rejected due to expiration, duplicate use, limit violations, or fraud detection.. Valid values are `valid|invalid|duplicate|expired|limit_exceeded|fraud_suspected`',
    `redemption_timestamp` TIMESTAMP COMMENT 'The precise date and time when the promotion was applied to the transaction. Represents the business event time of redemption, distinct from record creation time.',
    `sku` STRING COMMENT 'The specific product SKU to which the promotion was applied. Populated for item-level promotions. Null for transaction-level or basket-level promotions.',
    `source_record_reference` STRING COMMENT 'The unique identifier of this redemption record in the source operational system. Enables traceability back to the system of record.',
    `stack_sequence` STRING COMMENT 'The order in which this promotion was applied within a stacked promotion scenario. Determines calculation precedence when multiple discounts are layered.',
    `validation_error_code` STRING COMMENT 'System error code returned when a redemption attempt fails validation. Provides technical detail for troubleshooting invalid redemptions. Null for successful redemptions.',
    `validation_error_message` STRING COMMENT 'Human-readable error message explaining why a redemption was rejected. Displayed to customers or cashiers. Null for successful redemptions.',
    `vendor_funded_flag` BOOLEAN COMMENT 'Indicates whether this promotion discount is funded by a vendor/supplier through a trade promotion agreement. True when the cost is charged back to the vendor; false when retailer-funded.',
    CONSTRAINT pk_promo_redemption PRIMARY KEY(`promo_redemption_id`)
) COMMENT 'Transactional record capturing each instance of a promotional offer being applied to a customer transaction at POS or e-commerce checkout. Records offer applied, redemption mechanism (automatic system-triggered, coupon code entry, loyalty auto-apply, cart rule), coupon reference (when coupon-based), transaction reference, store or channel, customer identifier, discount amount granted, redemption timestamp, redemption status (valid, invalid, duplicate, expired), and processing system. Serves as the single source of truth for all promotion redemption activity — including coupon redemptions, automatic BOGO applications, threshold discounts, and bundle deals. Critical for promotional ROI calculation, coupon fraud prevention, vendor chargeback evidence, and real-time redemption limit enforcement.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`promo_performance` (
    `promo_performance_id` BIGINT COMMENT 'Unique identifier for the promotion performance record. Primary key for this operational performance measurement entity.',
    `assortment_plan_id` BIGINT COMMENT 'Foreign key linking to merchandising.assortment_plan. Business justification: Promotional performance directly impacts assortment decisions. Merchandising evaluates which promoted items to continue, expand, or discontinue based on promotional lift, margin impact, and sell-throu',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Performance metrics must roll up to category level for merchandising review. Category managers evaluate promotional ROI, incremental margin, and sell-through rates to inform future assortment and prom',
    `financial_period_id` BIGINT COMMENT 'add column finance_financial_period_id (BIGINT) with FK to finance.financial_period.financial_period_id - promotion performance must be measured within financial periods for P&L impact analysis',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_definition. Business justification: Performance records explicitly measure campaigns against defined KPIs. Weekly performance snapshots calculate specific KPI values (sell-through rate, promotional ROI, incremental units). Merchandising',
    `location_id` BIGINT COMMENT 'Reference to the store location where this promotion performance was measured. Supports store-level promotion analysis.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Promotional performance metrics roll up to marketing campaign level for holistic reporting. Retailers need to see how promotional tactics performed within broader marketing initiatives to measure inte',
    `promo_calendar_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_calendar. Business justification: Performance is measured over promotional periods defined in the promotional calendar. The promo_performance has performance_week_start_date and performance_week_end_date that align with promotional ca',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Promotional performance can be measured at both campaign level and offer level. While promo_performance already has promo_offer_id (offer-level measurement), adding promo_campaign_id enables direct ca',
    `promo_offer_id` BIGINT COMMENT 'Reference to the specific promotional offer or campaign being measured. Links to the promotion master definition.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Performance tracking measures promotional lift by SKU. Required for calculating incremental units, ROI, cannibalization analysis, and feeding promotional forecasts. Unlinked sku column exists but need',
    `stock_ledger_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_ledger. Business justification: Post-promotion ROI analysis requires matching promotional sales performance against actual inventory movements to calculate true incremental lift, validate COGS, identify shrinkage during events, and',
    `average_transaction_value` DECIMAL(18,2) COMMENT 'Average basket value for transactions that included this promoted item. Measures promotion impact on overall basket size.',
    `baseline_units` DECIMAL(18,2) COMMENT 'Estimated units that would have sold without the promotion, based on historical trends. Used to calculate incremental lift.',
    `cannibalization_estimate` DECIMAL(18,2) COMMENT 'Estimated units of related non-promoted products that lost sales due to this promotion. Measures negative cross-product impact.',
    `channel` STRING COMMENT 'The channel through which the promoted product was sold. Supports omnichannel promotion performance analysis.. Valid values are `in_store|ecommerce|mobile_app|bopis|ropis`',
    `cogs` DECIMAL(18,2) COMMENT 'Total cost of goods sold during the promotion period. Used to calculate gross margin and promotional ROI.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this performance record was first created in the system. Audit trail for record creation.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this record. Typically matches store local currency.. Valid values are `^[A-Z]{3}$`',
    `data_source_system` STRING COMMENT 'The operational system that generated or last updated this performance record. Used for data lineage and reconciliation.. Valid values are `sap_car|blue_yonder|oracle_rpm|manual_adjustment`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total dollar value of discounts given during the promotion period. Represents the promotional investment at retail price level.',
    `forecast_accuracy_percent` DECIMAL(18,2) COMMENT 'Accuracy of the promotional forecast compared to actual performance. Calculated as 100 minus absolute percentage error. Used to improve future forecasting.',
    `gross_margin` DECIMAL(18,2) COMMENT 'Gross profit generated during the promotion. Calculated as net_revenue minus COGS. Critical for assessing promotion profitability.',
    `gross_margin_percent` DECIMAL(18,2) COMMENT 'Gross margin as a percentage of net revenue. Expressed as a percentage value (e.g., 25.50 for 25.5%). Measures promotion profitability rate.',
    `gross_revenue` DECIMAL(18,2) COMMENT 'Total revenue generated from units sold at regular price before promotional discounts. Denominated in local store currency.',
    `incremental_units` DECIMAL(18,2) COMMENT 'Additional units sold above baseline due to the promotion. Calculated as units_sold minus baseline_units. Key measure of promotion effectiveness.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this performance record was last modified. Audit trail for record changes during adjustments or settlement.',
    `measurement_timestamp` TIMESTAMP COMMENT 'The date and time when this performance measurement was calculated and recorded. Represents the business event time for this operational record.',
    `net_revenue` DECIMAL(18,2) COMMENT 'Revenue after promotional discounts. Calculated as gross_revenue minus discount_amount. Actual revenue realized from the promotion.',
    `new_customer_count` STRING COMMENT 'Number of customers who purchased this SKU for the first time during the promotion. Measures customer acquisition effectiveness.',
    `notes` STRING COMMENT 'Free-text notes capturing exceptional circumstances, adjustments, or explanations for performance anomalies. Used for post-promotion review and vendor settlement discussions.',
    `out_of_stock_days` STRING COMMENT 'Number of days during the promotion period when the SKU was out of stock at this store. Indicates lost sales opportunity.',
    `performance_status` STRING COMMENT 'Current status of this performance record. Preliminary during promotion execution, final after close, adjusted if corrections made, settled after vendor payment.. Valid values are `preliminary|final|adjusted|settled`',
    `performance_week_end_date` DATE COMMENT 'The end date of the week for which this promotion performance is measured. Defines the weekly measurement window.',
    `performance_week_start_date` DATE COMMENT 'The start date of the week for which this promotion performance is measured. Promotion performance is captured at weekly grain for trend analysis.',
    `promotional_roi` DECIMAL(18,2) COMMENT 'Return on investment for the promotion, calculated as incremental gross margin divided by promotional investment. Expressed as ratio (e.g., 2.50 means $2.50 return per $1 invested).',
    `redemption_count` STRING COMMENT 'Number of times the promotion was redeemed (coupon scans, digital offer applications, BOGO transactions). Measures customer engagement with the offer.',
    `repeat_customer_count` STRING COMMENT 'Number of customers who had previously purchased this SKU and bought again during the promotion. Measures loyalty reinforcement.',
    `retailer_funded_amount` DECIMAL(18,2) COMMENT 'Dollar amount funded by the retailer for this promotion. Combined with vendor_funded_amount gives total promotional investment.',
    `sell_through_rate` DECIMAL(18,2) COMMENT 'Percentage of promotional inventory sold during the promotion period. Expressed as percentage (e.g., 85.50 for 85.5%). Indicates inventory velocity.',
    `sku` STRING COMMENT 'The specific product SKU included in this promotion performance measurement. Enables product-level promotion effectiveness analysis.. Valid values are `^[A-Z0-9]{8,14}$`',
    `unique_customer_count` STRING COMMENT 'Number of distinct customers who purchased the promoted item during the period. Measures promotion reach.',
    `units_per_transaction` DECIMAL(18,2) COMMENT 'Average number of units of the promoted SKU purchased per transaction. Indicates promotion-driven purchase intensity.',
    `units_sold` DECIMAL(18,2) COMMENT 'Total number of units sold during the promotion period for this SKU at this store. Core volume metric for promotion effectiveness.',
    `vendor_funded_amount` DECIMAL(18,2) COMMENT 'Dollar amount funded by the vendor/supplier as part of co-op or trade promotion agreement. Used for vendor settlement and chargeback processing.',
    CONSTRAINT pk_promo_performance PRIMARY KEY(`promo_performance_id`)
) COMMENT 'Operational record capturing the measured performance of a promotional offer or campaign at the offer-store-week grain. Stores actual units sold, revenue generated, discount dollars given, incremental units vs. baseline, redemption count, sell-through rate, promotional ROI, margin impact, and cannibalization estimate. Written by the retail analytics platform demand signal repository and Blue Yonder systems during and after promotion execution. This is an operational performance record — not an analytics aggregate — used for vendor settlement evidence, markdown planning decisions, and post-promotion review. Supports comparison against promo_forecast for forecast accuracy measurement.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`promo_budget` (
    `promo_budget_id` BIGINT COMMENT 'Unique identifier for the promotional budget record. Primary key for the promotional budget master data.',
    `associate_id` BIGINT COMMENT 'Identifier of the specific organizational unit or team responsible for this promotional budget, corresponding to the budget owner type (e.g., department code, category code, brand code, channel identifier).',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Promotional budgets are allocated by category. Category managers need visibility to total promotional investment to balance promotional spending with margin targets and competitive positioning. Essent',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Promotion budgets are allocated to finance cost centers for accounting and budget tracking. The cost_center_code column becomes redundant as it can be joined from finance.cost_center. This links promo',
    `marketing_budget_id` BIGINT COMMENT 'Foreign key linking to marketing.marketing_budget. Business justification: Promotional budgets are sub-allocations of marketing budgets. Finance and marketing teams reconcile promotional spend against marketing budget envelopes for variance reporting, budget management, and',
    `merch_plan_id` BIGINT COMMENT 'Foreign key linking to merchandising.merch_plan. Business justification: Promotional budgets are coordinated with merchandise plans. Total category investment includes both promotional spend and OTB. Buyers need integrated view of promotional and inventory investment to ma',
    `promo_calendar_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_calendar. Business justification: Promotional budgets are planned and allocated against promotional calendar periods (fiscal year, fiscal quarter, seasonal events). The promo_budget table has fiscal_year and fiscal_period as standalon',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Promotional budgets are allocated to specific promotional campaigns. The promo_budget table tracks budget_owner_type and budget_owner_id as generic strings, but needs a structured FK to promo_campaign',
    `actual_spend_amount` DECIMAL(18,2) COMMENT 'Cumulative actual spend to date against this promotional budget, including all posted promotional costs, markdowns, vendor co-op claims, and advertising expenses. Updated in real-time as promotional transactions are processed.',
    `approval_date` DATE COMMENT 'Date when this promotional budget was formally approved by authorized management. Marks the transition from pending to approved status.',
    `approval_status` STRING COMMENT 'Current approval workflow status for the promotional budget. Not submitted indicates budget has not been submitted for approval; pending review indicates awaiting management approval; approved indicates budget has been authorized; rejected indicates budget was not approved; revision required indicates budget must be modified and resubmitted.. Valid values are `not_submitted|pending_review|approved|rejected|revision_required`',
    `approved_by` STRING COMMENT 'Identifier or name of the manager or executive who approved this promotional budget. Typically a user ID or employee identifier from the HR system.',
    `budget_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the budget amount (e.g., USD, EUR, GBP, CAD). All budget amounts and spend tracking for this budget are denominated in this currency.. Valid values are `^[A-Z]{3}$`',
    `budget_name` STRING COMMENT 'Descriptive name of the promotional budget plan, typically indicating the campaign, event, or category scope (e.g., Q4 Holiday Electronics Promotion, Spring Apparel Clearance).',
    `budget_number` STRING COMMENT 'Human-readable business identifier for the promotional budget, typically following format PB-YYYYNNNN where YYYY is fiscal year and NNNN is sequence number.. Valid values are `^PB-[0-9]{8}$`',
    `budget_owner_type` STRING COMMENT 'Classification of the organizational unit responsible for managing and executing this promotional budget. Department indicates merchandising department ownership; category indicates product category team ownership; brand indicates brand management team ownership; channel indicates channel-specific ownership (e-commerce, stores); region indicates geographic region ownership; store cluster indicates store group ownership.. Valid values are `department|category|brand|channel|region|store_cluster`',
    `budget_status` STRING COMMENT 'Current lifecycle status of the promotional budget. Draft indicates initial planning stage; pending approval indicates submitted for management review; approved indicates authorized but not yet active; active indicates currently in use for promotional spend; suspended indicates temporarily paused; closed indicates completed and finalized; cancelled indicates terminated before completion. [ENUM-REF-CANDIDATE: draft|pending_approval|approved|active|suspended|closed|cancelled — 7 candidates stripped; promote to reference product]',
    `budget_type` STRING COMMENT 'Classification of the promotional budget source and purpose. Internal marketing budgets are company-funded campaigns; vendor co-op budgets are supplier-funded promotional agreements; markdown allowance budgets cover planned price reductions; clearance reserve budgets are set aside for end-of-season inventory liquidation; trade promotion budgets support B2B channel incentives; digital advertising budgets fund online and mobile promotional campaigns.. Valid values are `internal_marketing|vendor_coop|markdown_allowance|clearance_reserve|trade_promotion|digital_advertising`',
    `circular_ad_allocation` DECIMAL(18,2) COMMENT 'Portion of the total budget allocated specifically for circular advertising and weekly ad production, including print circulars, digital circulars, and featured promotional items in weekly ad campaigns.',
    `committed_amount` DECIMAL(18,2) COMMENT 'Amount committed but not yet spent, representing approved promotional activities that have been scheduled or contracted but not yet executed (e.g., scheduled markdowns, booked advertising placements, approved vendor co-op agreements).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this promotional budget record was first created in the system. Audit field for data lineage and record lifecycle tracking.',
    `ecommerce_channel_allocation` DECIMAL(18,2) COMMENT 'Portion of the total budget allocated specifically for e-commerce and digital promotional activities, including online discounts, digital coupons, email campaigns, and website promotional banners. Supports omnichannel budget planning and digital channel ROI tracking.',
    `effective_end_date` DATE COMMENT 'Date when this promotional budget expires and is no longer available for new promotional spend allocation. Any uncommitted budget remaining after this date typically rolls back to the general promotional fund or is reallocated.',
    `effective_start_date` DATE COMMENT 'Date when this promotional budget becomes active and available for promotional spend allocation. Promotional activities can begin drawing from this budget on or after this date.',
    `fiscal_period` STRING COMMENT 'Fiscal period within the fiscal year for which this budget is allocated. Format: Q1-Q4 for quarters, M01-M12 for months, H1-H2 for half-years, FY for full fiscal year. Supports period-based budget planning and performance tracking.. Valid values are `^(Q[1-4]|M(0[1-9]|1[0-2])|H[1-2]|FY)$`',
    `fiscal_year` STRING COMMENT 'Fiscal year for which this promotional budget is allocated, typically a four-digit year (e.g., 2024). Aligns with the companys financial planning and reporting calendar.',
    `gl_account_code` STRING COMMENT 'General ledger account code to which promotional spend from this budget is posted for financial reporting and P&L tracking. Links operational promotional budget management to financial accounting.. Valid values are `^[0-9]{4,10}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this promotional budget record was last updated. Audit field for change tracking and data quality monitoring.',
    `mobile_channel_allocation` DECIMAL(18,2) COMMENT 'Portion of the total budget allocated specifically for mobile app promotional activities, including app-exclusive offers, push notification campaigns, and mobile wallet coupons. Supports omnichannel budget planning and mobile channel ROI tracking.',
    `notes` STRING COMMENT 'Free-text notes and comments about the promotional budget, including planning assumptions, special conditions, vendor agreement details, or budget reallocation history. Supports collaborative budget management and audit trail documentation.',
    `otb_integration_flag` BOOLEAN COMMENT 'Boolean indicator of whether this promotional budget is integrated with the Open to Buy (OTB) merchandise planning system. When true, promotional markdowns and clearance budgets are factored into inventory purchasing decisions and margin planning.',
    `planned_spend_amount` DECIMAL(18,2) COMMENT 'Total planned or forecasted spend amount for the promotional budget based on campaign planning and historical performance. May be less than or equal to total budget amount, representing the expected utilization.',
    `pos_channel_allocation` DECIMAL(18,2) COMMENT 'Portion of the total budget allocated specifically for in-store point-of-sale promotional activities, including store markdowns, in-store coupons, and physical promotional displays. Supports omnichannel budget planning and channel-specific ROI tracking.',
    `profit_center_code` STRING COMMENT 'Profit center code associated with this promotional budget, used for segment reporting and profitability analysis. Enables tracking of promotional ROI by business unit or product line.. Valid values are `^PC-[0-9]{6}$`',
    `remaining_budget_amount` DECIMAL(18,2) COMMENT 'Available budget remaining for new promotional activities, calculated as total budget amount minus actual spend amount minus committed amount. Represents the unallocated budget available for additional promotional planning.',
    `total_budget_amount` DECIMAL(18,2) COMMENT 'Total allocated budget amount for the promotional plan in the budget currency. Represents the maximum authorized spend for this promotional budget across all channels and activities.',
    `variance_threshold_amount` DECIMAL(18,2) COMMENT 'Absolute amount threshold for budget variance alerts. When actual spend deviates from planned spend by more than this amount, automated alerts are triggered to budget owners and finance teams. Used in conjunction with or as an alternative to percentage-based thresholds.',
    `variance_threshold_percent` DECIMAL(18,2) COMMENT 'Percentage threshold for budget variance alerts. When actual spend deviates from planned spend by more than this percentage, automated alerts are triggered to budget owners and finance teams. Typical values range from 5% to 20%.',
    `vendor_funded_amount` DECIMAL(18,2) COMMENT 'Portion of the total budget that is funded by vendor co-op agreements, trade promotion allowances, or supplier marketing development funds. Represents external funding contribution to the promotional budget.',
    CONSTRAINT pk_promo_budget PRIMARY KEY(`promo_budget_id`)
) COMMENT 'Master record for the promotional budget allocated to a campaign, promotional event, or category-level promotional plan. Captures total budget amount, budget type (internal marketing, vendor co-op, markdown allowance, clearance reserve), budget owner (department, category, or brand team), planned spend by channel, actual spend to date, committed but unspent amount, remaining budget, budget approval status, fiscal period, and variance threshold for alerts. Supports OTB (Open to Buy) integration, promotional P&L management, and real-time budget consumption monitoring. Distinct from finance domain general ledger — this is the operational promotional spend plan that feeds GL accruals.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` (
    `promo_calendar_id` BIGINT COMMENT 'Unique identifier for the promotional calendar period. Primary key for the promotional calendar master record.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Promotional calendars must incorporate regulatory blackout periods (restricted promotional windows for alcohol, tobacco, regulated products) and compliance planning cycles. Links calendar to complianc',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Promotional calendar periods align with marketing campaign flights. Retailers coordinate promotional timing with marketing campaign launches for maximum impact, ensuring promotional offers are support',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Promotional calendar periods align with merchandising seasons. Planning requires synchronized timing for new season launches, mid-season promotions, and end-of-season clearance. Critical for coordinat',
    `applicable_banner_codes` STRING COMMENT 'Comma-separated list of banner codes to which this promotional period applies. Populated only when banner_applicability is banner_specific.',
    `applicable_market_codes` STRING COMMENT 'Comma-separated list of market or region codes to which this promotional period applies. Populated when market_applicability is regional or local.',
    `approval_date` DATE COMMENT 'The date when this promotional calendar period was formally approved by management. Null if still pending approval.',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether executive or senior management approval is required for promotions during this period (true) or standard approval workflows apply (false).',
    `approved_by_name` STRING COMMENT 'Name of the executive or manager who approved this promotional calendar period.',
    `banner_applicability` STRING COMMENT 'Indicates whether this promotional period applies across all retail banners (enterprise-wide) or is specific to individual banners (banner-specific). Supports multi-banner coordination.. Valid values are `enterprise_wide|banner_specific`',
    `blackout_reason` STRING COMMENT 'Business justification for why this period is designated as a promotional blackout (e.g., inventory transition, system maintenance, post-holiday recovery).',
    `budget_amount` DECIMAL(18,2) COMMENT 'Total budget allocated for this promotional period including markdown funding, advertising spend, and vendor co-op contributions.',
    `budget_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the promotional budget amount (e.g., USD, CAD, EUR).. Valid values are `^[A-Z]{3}$`',
    `channel_applicability` STRING COMMENT 'Indicates which sales channels this promotional period applies to (omnichannel, store-only, e-commerce-only, mobile-app-only).. Valid values are `omnichannel|store_only|ecommerce_only|mobile_app_only`',
    `circular_production_deadline` DATE COMMENT 'The deadline by which all promotional circular materials (print ads, digital circulars) must be finalized for production and distribution.',
    `competitive_response_flag` BOOLEAN COMMENT 'Indicates whether this promotional period was created as a competitive response to rival retailer promotions (true) or is part of the planned calendar (false).',
    `competitive_trigger_description` STRING COMMENT 'Description of the competitive market event or rival promotion that triggered this promotional period. Populated when competitive_response_flag is true.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this promotional calendar record was first created in the system.',
    `end_date` DATE COMMENT 'The date when the promotional period ends. Defines the effective end of promotional activity and pricing.',
    `expected_sales_lift_pct` DECIMAL(18,2) COMMENT 'Forecasted percentage increase in sales revenue expected during this promotional period compared to baseline or prior year.',
    `expected_traffic_lift_pct` DECIMAL(18,2) COMMENT 'Forecasted percentage increase in customer traffic (footfall and digital visits) expected during this promotional period compared to baseline.',
    `fiscal_month` STRING COMMENT 'The fiscal month (1-12) to which this promotional period belongs.',
    `fiscal_quarter` STRING COMMENT 'The fiscal quarter (1-4) to which this promotional period belongs.',
    `fiscal_week` STRING COMMENT 'The fiscal week number (1-52 or 1-53) to which this promotional period belongs, aligned with the retail 4-5-4 calendar.',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this promotional period belongs (e.g., 2024, 2025).',
    `inventory_build_start_date` DATE COMMENT 'The date when inventory positioning and build-up for this promotional period should begin to ensure adequate stock levels.',
    `is_active` BOOLEAN COMMENT 'Indicates whether this promotional calendar period is currently active and valid (true) or has been logically deleted or superseded (false).',
    `is_blackout_period` BOOLEAN COMMENT 'Flag indicating whether this period is a promotional blackout window where no new promotions should be launched (true) or a normal promotional period (false).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this promotional calendar record was last updated or modified.',
    `market_applicability` STRING COMMENT 'Geographic scope of the promotional period indicating whether it applies nationally, regionally, or to specific local markets.. Valid values are `national|regional|local`',
    `notes` STRING COMMENT 'Free-text notes and comments regarding special considerations, constraints, or coordination requirements for this promotional period.',
    `period_name` STRING COMMENT 'Business-friendly name for the promotional period (e.g., Spring Sale 2024, Black Friday Week, Back to School August).',
    `period_type` STRING COMMENT 'Classification of the promotional period indicating the nature and purpose of the promotion (weekly ad cycle, seasonal event, holiday, clearance window, competitive response, vendor-funded).. Valid values are `weekly_ad_cycle|seasonal_event|holiday|clearance_window|competitive_response|vendor_funded`',
    `planning_lock_date` DATE COMMENT 'The date by which all promotional planning for this period must be finalized and locked. After this date, changes require executive approval.',
    `planning_owner_email` STRING COMMENT 'Email address of the planning owner for coordination and communication regarding this promotional period.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `planning_owner_name` STRING COMMENT 'Name of the merchandising or marketing manager responsible for planning and executing this promotional period.',
    `planning_status` STRING COMMENT 'Current lifecycle status of the promotional calendar period (draft - under development, locked - finalized for execution, active - currently running, archived - completed and historical).. Valid values are `draft|locked|active|archived`',
    `priority_tier` STRING COMMENT 'Priority classification of the promotional period indicating strategic importance and resource allocation level (tier 1 strategic, tier 2 major, tier 3 standard, tier 4 tactical).. Valid values are `tier_1_strategic|tier_2_major|tier_3_standard|tier_4_tactical`',
    `source_system_code` STRING COMMENT 'Code identifying the source system from which this promotional calendar record originated (e.g., ORMS, RPM, internal planning tool).',
    `start_date` DATE COMMENT 'The date when the promotional period begins. Defines the effective start of promotional activity and pricing.',
    `target_customer_segment` STRING COMMENT 'Primary customer segment or demographic group targeted by this promotional period (e.g., families, millennials, loyalty members, value shoppers).',
    `theme_description` STRING COMMENT 'Marketing theme or creative concept for the promotional period (e.g., Summer Savings, Holiday Gift Guide, New Year New You).',
    `vendor_negotiation_deadline` DATE COMMENT 'The deadline by which all vendor-funded promotional agreements and co-op advertising commitments must be finalized.',
    CONSTRAINT pk_promo_calendar PRIMARY KEY(`promo_calendar_id`)
) COMMENT 'Master record for the retail promotional calendar defining planned promotional periods, key retail events, blackout dates, and competitive response windows for a fiscal year. Captures period name, period type (weekly ad cycle, seasonal event, holiday, clearance window, competitive response), start/end dates, fiscal week/month/quarter alignment, priority tier, planning lock date, planning status (draft, locked, active, archived), and banner/market applicability for multi-banner retailers. Used by merchandising, marketing, and supply chain teams to coordinate promotional activity, inventory positioning, and circular production timelines. Serves as the shared planning backbone that prevents promotional conflicts and ensures adequate lead time for vendor negotiations and inventory builds. Supports multi-banner coordination by allowing banner-specific or enterprise-wide calendar periods.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` (
    `promo_conflict_rule_id` BIGINT COMMENT 'Unique identifier for the promotion conflict rule configuration record.',
    `promo_group_id` BIGINT COMMENT 'Identifier for a group of promotions that are mutually exclusive or have defined interaction rules. Used to define which promotion pairs or sets this rule governs.',
    `associate_id` BIGINT COMMENT 'Identifier of the user or system account that created this conflict rule configuration.',
    `promo_campaign_id` BIGINT COMMENT 'Reference to the primary promotion in a conflict pair or hierarchy. Used in explicit exclusion and priority override scenarios.',
    `tertiary_promo_approved_by_user_associate_id` BIGINT COMMENT 'Identifier of the business user who approved this conflict rule for production deployment.',
    `vendor_id` BIGINT COMMENT 'Reference to the supplier or vendor when this rule is specific to vendor-funded promotion agreements.',
    `applies_to_scope` STRING COMMENT 'Granularity level at which the conflict rule operates: SKU (Stock Keeping Unit) level for individual products, category level for product groups, brand level, vendor level for supplier-funded promotions, transaction level for cart-wide rules, or customer segment for loyalty-tier specific rules.. Valid values are `sku_level|category_level|brand_level|vendor_level|transaction_level|customer_segment`',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this conflict rule was approved for production use.',
    `audit_log_required_flag` BOOLEAN COMMENT 'Indicates whether all applications and overrides of this rule must be logged for compliance and audit purposes.',
    `channel_applicability` STRING COMMENT 'Sales channels where this conflict rule is enforced: all channels (omnichannel), POS (Point of Sale) only for in-store, e-commerce only for web, mobile app only, BOPIS (Buy Online Pick Up In Store), ROPIS (Reserve Online Pick Up In Store), or call center. [ENUM-REF-CANDIDATE: all_channels|pos_only|ecommerce_only|mobile_app_only|bopis|ropis|call_center — 7 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this conflict rule record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for monetary thresholds and discount amounts in this rule.. Valid values are `^[A-Z]{3}$`',
    `customer_segment_restriction` STRING COMMENT 'Comma-separated list of customer segment codes to which this conflict rule applies. Used for loyalty-tier specific or demographic-specific conflict resolution.',
    `effective_end_date` DATE COMMENT 'Date when the conflict rule expires and is no longer enforced. Nullable for open-ended rules.',
    `effective_start_date` DATE COMMENT 'Date when the conflict rule becomes active and begins governing promotion interactions in the promotion engine.',
    `jurisdiction_code` STRING COMMENT 'ISO 3166-1 alpha-2 or alpha-3 country or region code where this rule applies, supporting jurisdiction-specific regulatory requirements such as Australian Trade Practices Act best-price requirements or EU Omnibus Directive lowest-prior-price rules.. Valid values are `^[A-Z]{2,3}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this conflict rule record was last updated.',
    `max_discount_amount` DECIMAL(18,2) COMMENT 'Maximum cumulative discount amount in local currency when multiple promotions stack, used for margin protection and fraud prevention.',
    `max_discount_percentage` DECIMAL(18,2) COMMENT 'Maximum cumulative discount percentage allowed when multiple promotions stack, used for margin protection. Expressed as a percentage (e.g., 50.00 for 50%).',
    `max_stack_count` STRING COMMENT 'Maximum number of promotions that can be combined (stacked) on a single transaction or SKU when stackability is allowed. Null if unlimited or not applicable.',
    `notes` STRING COMMENT 'Free-text field for additional business context, implementation notes, or special instructions related to this conflict rule.',
    `oms_system_flag` BOOLEAN COMMENT 'Indicates whether this rule is loaded into OMS (Order Management System) for e-commerce and omnichannel order conflict resolution.',
    `override_allowed_flag` BOOLEAN COMMENT 'Indicates whether store managers or customer service representatives are permitted to manually override this conflict rule at checkout or during order processing.',
    `override_authorization_level` STRING COMMENT 'Minimum authorization level required to override this conflict rule: none (no override allowed), cashier, supervisor, store manager, regional manager, or corporate only.. Valid values are `none|cashier|supervisor|store_manager|regional_manager|corporate_only`',
    `pos_system_flag` BOOLEAN COMMENT 'Indicates whether this rule is loaded into POS (Point of Sale) systems for in-store checkout conflict resolution.',
    `priority_rank` STRING COMMENT 'Numeric ranking used in priority-based resolution methods, where lower numbers indicate higher precedence. Used when resolution_method is priority_hierarchy.',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether this rule is mandated by regulatory requirements (true) or is a business policy decision (false). Critical for audit trails in jurisdictions with price accuracy and promotional pricing laws.',
    `resolution_method` STRING COMMENT 'Specific algorithm used to resolve conflicts when multiple promotions qualify: highest discount wins (best value for customer), first applied wins (temporal precedence), last applied wins (most recent), priority hierarchy (rank-based), explicit block (hard exclusion), customer choice (manual selection at POS), or vendor priority (supplier-funded promo takes precedence). [ENUM-REF-CANDIDATE: highest_discount_wins|first_applied_wins|last_applied_wins|priority_hierarchy|explicit_block|customer_choice|vendor_priority — 7 candidates stripped; promote to reference product]',
    `rule_code` STRING COMMENT 'Business identifier code for the conflict rule, used for reference in promotion engine configuration and operational documentation.. Valid values are `^[A-Z0-9_-]{4,20}$`',
    `rule_description` STRING COMMENT 'Detailed explanation of the conflict rule logic, business rationale, and expected behavior when multiple promotions apply.',
    `rule_name` STRING COMMENT 'Human-readable name describing the conflict rule purpose and scope.',
    `rule_status` STRING COMMENT 'Current lifecycle status of the conflict rule: active (enforced in production), inactive (not enforced), draft (under development), pending approval (awaiting business sign-off), suspended (temporarily disabled), or archived (historical record).. Valid values are `active|inactive|draft|pending_approval|suspended|archived`',
    `rule_type` STRING COMMENT 'Classification of the conflict resolution strategy: exclusivity (only one promo applies), stackability (multiple promos combine), priority override (hierarchy-based selection), best deal selection (customer receives highest discount), explicit exclusion (specific promo pairs blocked), or vendor funded override (supplier-funded promo rules).. Valid values are `exclusivity|stackability|priority_override|best_deal_selection|explicit_exclusion|vendor_funded_override`',
    `vendor_funded_flag` BOOLEAN COMMENT 'Indicates whether this rule applies to vendor-funded (supplier-funded) promotions, which may have different conflict resolution logic per vendor agreements.',
    `version_number` STRING COMMENT 'Version number of this conflict rule configuration, incremented with each modification to support change tracking and rollback capabilities.',
    CONSTRAINT pk_promo_conflict_rule PRIMARY KEY(`promo_conflict_rule_id`)
) COMMENT 'Configuration record defining rules that govern how promotional offers interact when multiple promotions apply to the same transaction or SKU. Captures rule type (exclusivity, stackability, priority override, best-deal-for-customer selection), conflicting offer pairs or groups, resolution method (highest discount wins, first applied wins, explicit exclusion), effective date range, channel applicability, and jurisdiction-specific override rules (e.g., Australian Trade Practices Act best-price requirements, EU Omnibus Directive lowest-prior-price rules). Loaded into POS and OMS promotion engines to prevent unintended discount stacking and ensure consistent promotion resolution across all checkout channels. Critical for margin protection and regulatory compliance in jurisdictions with price accuracy and promotional pricing requirements.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` (
    `promo_forecast_id` BIGINT COMMENT 'Unique identifier for the promotional forecast record. Primary key for the promo_forecast product.',
    `associate_id` BIGINT COMMENT 'Reference to the user who approved this promotional forecast for use in operational planning and replenishment decisions.',
    `assortment_plan_id` BIGINT COMMENT 'Foreign key linking to merchandising.assortment_plan. Business justification: Promotional forecasts inform assortment planning. Merchandising uses lift projections to plan inventory depth, allocate space, and adjust minimum presentation quantities. Essential for ensuring adequa',
    `demand_forecast_id` BIGINT COMMENT 'Foreign key linking to supplychain.demand_forecast. Business justification: Promotional forecasts calculate incremental lift by referencing baseline demand forecasts. Retail planners use this link to separate promotional from baseline demand for inventory planning and OTB man',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_definition. Business justification: Forecasts predict future KPI outcomes for promotional planning. Demand planners forecast specific KPIs (forecasted sales lift %, predicted redemption rate) to support budget allocation. Forecast accur',
    `location_id` BIGINT COMMENT 'Reference to the store location for which this promotional forecast applies.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Promotional forecasts must consider marketing campaign support. Demand planners need to know which marketing campaigns will amplify promotional offers to forecast incremental lift accurately and ensur',
    `merch_plan_id` BIGINT COMMENT 'Foreign key linking to merchandising.merch_plan. Business justification: Promotional forecasts feed into merchandise financial plans. Buyers adjust OTB (Open-to-Buy) based on expected promotional sales lift and margin impact. Critical for financial planning and inventory i',
    `promo_campaign_id` BIGINT COMMENT 'Reference to the promotional offer or event for which this forecast was generated.',
    `promo_calendar_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_calendar. Business justification: Forecasts are generated for specific promotional periods defined in the promotional calendar. The promo_forecast has forecast_week_start_date and forecast_week_end_date that align with promotional cal',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_offer. Business justification: Promotional forecasts are generated at the offer level (specific deal mechanics) rather than just campaign level. While promo_forecast has promo_campaign_id, adding promo_offer_id enables offer-specif',
    `sku_id` BIGINT COMMENT 'Reference to the specific SKU (Stock Keeping Unit) for which demand is forecasted during the promotion.',
    `stock_position_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_position. Business justification: Promotional demand forecasting requires real-time inventory position data (ATP, on-hand, velocity) to calculate feasible incremental lift and prevent overpromising. Forecast models must access current',
    `approved_timestamp` TIMESTAMP COMMENT 'The date and time when this promotional forecast was approved. Represents a key lifecycle event in the forecast workflow.',
    `baseline_sales_forecast_units` DECIMAL(18,2) COMMENT 'The forecasted sales units for the SKU-store-week without any promotional activity. Represents the expected demand under normal, non-promotional conditions.',
    `channel` STRING COMMENT 'The sales channel for which this promotional forecast applies. Indicates whether the forecast is for in-store, e-commerce, mobile app, or omnichannel execution.. Valid values are `store|ecommerce|mobile|omnichannel`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this promotional forecast record was first created in the system. Audit trail field for record creation.',
    `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code for all monetary amounts in this forecast record (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `forecast_adjustment_factor` DECIMAL(18,2) COMMENT 'A manual adjustment factor applied to the system-generated forecast by demand planners. A value of 1.0 indicates no adjustment; values above 1.0 indicate upward adjustment; values below 1.0 indicate downward adjustment.',
    `forecast_adjustment_reason` STRING COMMENT 'Free-text explanation for any manual adjustment applied to the system-generated forecast. Captures planner judgment and business context.',
    `forecast_confidence_level` STRING COMMENT 'The confidence level assigned to this promotional forecast by the demand planning system. Indicates the reliability of the forecast based on historical data quality, model accuracy, and market volatility.. Valid values are `high|medium|low`',
    `forecast_confidence_score` DECIMAL(18,2) COMMENT 'Numeric confidence score (0-100) representing the statistical confidence in the forecast accuracy. Higher scores indicate greater confidence.',
    `forecast_error_percentage` DECIMAL(18,2) COMMENT 'The historical forecast error percentage for similar promotions using the same forecasting model. Used to assess forecast reliability and set safety stock levels.',
    `forecast_generation_timestamp` TIMESTAMP COMMENT 'The date and time when this promotional forecast was generated by the demand planning system. Represents the principal business event timestamp for this operational planning record.',
    `forecast_model_version` STRING COMMENT 'The version identifier of the demand forecasting model used to generate this promotional forecast. Enables traceability and model performance analysis.',
    `forecast_scenario` STRING COMMENT 'The scenario name or identifier for this forecast. Enables comparison of multiple forecast scenarios (e.g., optimistic, pessimistic, baseline) for the same promotion.',
    `forecast_status` STRING COMMENT 'The current lifecycle status of the promotional forecast. Indicates whether the forecast is in draft, has been approved for use in replenishment planning, has been rejected, or has been superseded by a newer forecast.. Valid values are `draft|approved|rejected|superseded`',
    `forecast_week_end_date` DATE COMMENT 'The end date of the week for which this promotional forecast is generated.',
    `forecast_week_start_date` DATE COMMENT 'The start date of the week for which this promotional forecast is generated. Forecasts are typically generated at weekly granularity.',
    `forecasted_discount_cost_amount` DECIMAL(18,2) COMMENT 'The total forecasted cost of the promotional discount for the SKU-store-week. Represents the revenue foregone due to the promotional price reduction.',
    `forecasted_revenue_amount` DECIMAL(18,2) COMMENT 'The total forecasted revenue for the SKU-store-week during the promotion, calculated using the promotional price and total forecasted units.',
    `incremental_lift_units` DECIMAL(18,2) COMMENT 'The estimated additional sales units expected due to the promotional activity. Represents the incremental demand lift above the baseline forecast.',
    `notes` STRING COMMENT 'Free-text notes or comments about this promotional forecast. Captures additional context, assumptions, or special considerations from demand planners.',
    `open_to_buy_impact_amount` DECIMAL(18,2) COMMENT 'The impact of this promotional forecast on the Open To Buy (OTB) budget for the category. Represents the additional inventory investment required to support the forecasted promotional demand.',
    `promotion_type` STRING COMMENT 'The type of promotional offer for which this forecast was generated. Examples include Buy One Get One (BOGO), markdown, coupon, rebate, bundle, or seasonal sale.. Valid values are `BOGO|markdown|coupon|rebate|bundle|seasonal`',
    `promotional_price_amount` DECIMAL(18,2) COMMENT 'The promotional price per unit for the SKU during the forecast period. Used to calculate forecasted revenue and discount cost.',
    `regular_price_amount` DECIMAL(18,2) COMMENT 'The regular (non-promotional) price per unit for the SKU. Used to calculate the discount cost and promotional lift.',
    `replenishment_triggered_flag` BOOLEAN COMMENT 'Indicates whether this promotional forecast has triggered inventory replenishment orders. True if replenishment has been initiated, False otherwise.',
    `total_forecasted_units` DECIMAL(18,2) COMMENT 'The total forecasted sales units for the SKU-store-week including promotional lift. Calculated as baseline_sales_forecast_units plus incremental_lift_units.',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time when this promotional forecast record was last modified. Audit trail field for record updates.',
    `vendor_funded_flag` BOOLEAN COMMENT 'Indicates whether the promotional discount is funded by the vendor (supplier) rather than the retailer. True if vendor-funded, False otherwise.',
    `vendor_funding_amount` DECIMAL(18,2) COMMENT 'The total amount of promotional discount cost funded by the vendor for this SKU-store-week. Null if the promotion is not vendor-funded.',
    CONSTRAINT pk_promo_forecast PRIMARY KEY(`promo_forecast_id`)
) COMMENT 'Operational planning record capturing the pre-promotion demand forecast for a promotional offer or event at the SKU-store-week level. Stores baseline sales forecast, incremental lift estimate, total forecasted units, forecasted revenue, forecasted discount cost, and forecast confidence level. Generated by Blue Yonder Demand Planning during promotion planning and used to drive inventory replenishment and OTB decisions. This is an operational input record — not an analytics output — written during the planning cycle.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` (
    `circular_ad_category_feature_id` BIGINT COMMENT 'Unique identifier for this circular ad category feature placement. Primary key.',
    `category_id` BIGINT COMMENT 'Foreign key linking to the merchandise category being featured in this circular',
    `circular_ad_id` BIGINT COMMENT 'Foreign key linking to the circular advertisement in which this category is featured',
    `associate_id` BIGINT COMMENT 'Reference to the user or circular planner who created this category feature assignment.',
    `circular_last_modified_by_associate_id` BIGINT COMMENT 'Reference to the user who last modified this category feature record.',
    `actual_sales_amount` DECIMAL(18,2) COMMENT 'Actual sales achieved for this category during the circular effective period, attributed to this circular feature. Populated post-campaign for effectiveness analysis.',
    `allocated_space_sqin` DECIMAL(18,2) COMMENT 'Total space allocated to this category feature measured in square inches. Used for space allocation planning and cost allocation across categories.',
    `category_sales_target` DECIMAL(18,2) COMMENT 'Sales target amount for this category driven by this specific circular edition. Used to measure circular effectiveness and category-level promotional ROI.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this category feature record was created in the system during circular planning.',
    `creative_theme` STRING COMMENT 'Specific creative theme or messaging applied to this category feature within the circular (e.g., Back to School Essentials, Holiday Entertaining, Spring Refresh). May differ from the overall circular theme.',
    `feature_prominence` STRING COMMENT 'Classification of the visual prominence and placement strategy for this category feature (e.g., front_cover, center_spread, endcap_feature, in_book). Drives promotional effectiveness analysis.',
    `feature_sequence` STRING COMMENT 'Sequence or order in which this category appears within the circular layout. Supports customer journey analysis and circular flow optimization.',
    `featured_sku_count` STRING COMMENT 'Number of individual SKUs from this category featured in this circular. Supports assortment depth analysis and category representation metrics.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this category feature record.',
    `notes` STRING COMMENT 'Free-text field for additional notes about this category feature placement, such as special merchandising instructions, creative considerations, or performance observations.',
    `page_number` STRING COMMENT 'Page number(s) where this category is featured within the circular. Supports planogram alignment and feature prominence analysis.',
    `sales_lift_percent` DECIMAL(18,2) COMMENT 'Percentage lift in category sales compared to baseline (non-circular period). Calculated post-campaign to measure incremental impact of the circular feature.',
    `target_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the category sales target amount (e.g., USD, CAD, EUR).',
    `traffic_attribution_percent` DECIMAL(18,2) COMMENT 'Estimated percentage of store traffic or digital visits attributed to this category feature based on customer surveys or digital analytics. Used for traffic driver analysis.',
    `vendor_co_op_amount` DECIMAL(18,2) COMMENT 'Amount of vendor co-op funding allocated to this specific category feature within the circular. Null if vendor_co_op_flag is false.',
    `vendor_co_op_flag` BOOLEAN COMMENT 'Indicates whether this category feature includes vendor co-op funding or promotional allowances. Supports cost allocation and vendor partnership tracking.',
    CONSTRAINT pk_circular_ad_category_feature PRIMARY KEY(`circular_ad_category_feature_id`)
) COMMENT 'This association product represents the featured placement of a merchandise category within a specific circular advertisement. It captures the promotional strategy of allocating page space, prominence, and sales targets to categories within each circular. Each record links one circular_ad to one category with attributes that exist only in the context of this specific feature placement, including page location, visual prominence, space allocation, and category-specific performance targets for that circular edition.. Existence Justification: In retail circular planning, a single circular advertisement features multiple merchandise categories across different pages (e.g., Grocery on page 2, Apparel on page 5, Electronics on page 8), and each category appears in multiple circulars throughout the year (weekly, seasonal, holiday editions). Circular planning teams actively manage this many-to-many relationship by allocating page space, setting feature prominence, assigning category-specific sales targets, and tracking performance for each category within each circular edition. This is an operational business process with relationship-specific data.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`coupon_distribution` (
    `coupon_distribution_id` BIGINT COMMENT 'Unique identifier for this coupon distribution event. Primary key.',
    `audience_segment_id` BIGINT COMMENT 'Foreign key linking to the marketing audience segment receiving the coupon',
    `coupon_id` BIGINT COMMENT 'Foreign key linking to the coupon instrument being distributed',
    `actual_reach` BIGINT COMMENT 'Number of unique customers or contacts who actually received the coupon. May be less than target_reach due to delivery failures, opt-outs, or invalid contact information.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this distribution record was created in the system.',
    `distribution_channel` STRING COMMENT 'Channel through which the coupon was distributed to this segment (email, app, SMS, circular, in-store kiosk, direct mail, social media, partner site). Explicitly identified in detection reasoning as relationship data.',
    `distribution_cost` DECIMAL(18,2) COMMENT 'Total cost incurred to distribute this coupon to this segment, including channel fees, printing costs, postage, or digital delivery costs. Used for ROI analysis.',
    `distribution_date` DATE COMMENT 'Date when this coupon was distributed to this audience segment. Explicitly identified in detection reasoning as relationship data.',
    `distribution_status` STRING COMMENT 'Current status of the distribution event: scheduled (planned but not yet executed), in_progress (actively distributing), completed (distribution finished), failed (distribution encountered errors), cancelled (distribution was cancelled before completion).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this distribution record was last updated (typically when redemption counts are refreshed).',
    `quantity_distributed` BIGINT COMMENT 'Number of coupon codes or physical coupons distributed to members of this audience segment. Explicitly identified in detection reasoning as relationship data.',
    `redemption_count` BIGINT COMMENT 'Total number of redemptions of this coupon by members of this audience segment. Explicitly identified in detection reasoning as relationship data. Updated as redemptions occur.',
    `redemption_rate_percent` DECIMAL(18,2) COMMENT 'Percentage of distributed coupons that were redeemed by this segment (redemption_count / quantity_distributed * 100). Explicitly identified in detection reasoning as relationship data. Key performance metric for targeting effectiveness.',
    `target_reach` BIGINT COMMENT 'Number of unique customers or contacts in this segment targeted for this coupon distribution. May differ from quantity_distributed if some customers receive multiple copies or if distribution is limited.',
    CONSTRAINT pk_coupon_distribution PRIMARY KEY(`coupon_distribution_id`)
) COMMENT 'This association product represents the distribution event between coupon and audience_segment. It captures the operational record of which coupons were distributed to which marketing segments, when, through which channels, and the resulting redemption performance. Each record links one coupon to one audience_segment with attributes that exist only in the context of this distribution relationship.. Existence Justification: In retail operations, coupons are strategically distributed to multiple audience segments as part of targeted promotional campaigns (e.g., a 20% off coupon might be sent to loyalty members via email, lapsed customers via direct mail, and high-value prospects via app notification). Each segment receives multiple different coupons over time as part of ongoing promotional strategy. Retailers actively manage these distribution events, tracking which coupons went to which segments, through which channels, and measuring redemption performance by segment to optimize future targeting decisions.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`promo_inventory_allocation` (
    `promo_inventory_allocation_id` BIGINT COMMENT 'Unique identifier for this promotional inventory allocation record. Primary key.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to the distribution center facility receiving the promotional inventory allocation',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to the promotional campaign for which inventory is being allocated',
    `allocated_inventory_units` STRING COMMENT 'Number of inventory units allocated to this facility for this promotional campaign. Represents the facility-specific quantity planned for promotional stock distribution.',
    `allocation_percentage` DECIMAL(18,2) COMMENT 'Percentage of total promotional inventory allocated to this facility for this campaign. Enables proportional distribution planning across the DC network.',
    `allocation_status` STRING COMMENT 'Current lifecycle status of this promotional inventory allocation (planned, confirmed, in_transit, received, active, completed, cancelled). Tracks the operational state of the allocation.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this promotional inventory allocation record was created in the system.',
    `effective_end_date` DATE COMMENT 'Date when this promotional inventory allocation expires and remaining promotional stock may be redistributed or returned to standard inventory.',
    `effective_start_date` DATE COMMENT 'Date when this promotional inventory allocation becomes effective and inventory should be positioned at the facility. May differ from campaign start date to allow for lead time.',
    `facility_priority_rank` STRING COMMENT 'Priority ranking of this facility for this promotional campaign (1=highest priority). Used to sequence inventory distribution when supply is constrained or to prioritize high-performing regions.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this promotional inventory allocation record was last modified.',
    `created_by` STRING COMMENT 'User identifier or system name that created this promotional inventory allocation record.',
    CONSTRAINT pk_promo_inventory_allocation PRIMARY KEY(`promo_inventory_allocation_id`)
) COMMENT 'This association product represents the operational allocation of promotional campaign inventory across distribution center facilities. It captures the facility-specific inventory quantities, priority rankings, and timing for promotional stock distribution. Each record links one promo_campaign to one dc_facility with attributes that exist only in the context of this allocation relationship, enabling regional demand planning and promotional inventory management.. Existence Justification: In retail operations, promotional campaigns are executed across multiple distribution centers based on regional demand forecasts and store coverage areas, while each DC simultaneously supports multiple concurrent promotional campaigns. The allocation of promotional inventory to facilities is an active operational planning process managed by merchandising and supply chain teams, with facility-specific quantities, priorities, and timing that constitute relationship data.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`promo_group` (
    `promo_group_id` BIGINT COMMENT 'Primary key for promo_group',
    `conflicting_promo_group_id` BIGINT COMMENT 'Self-referencing FK on promo_group (conflicting_promo_group_id)',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether promotions assigned to this group require additional approval before activation.',
    `approval_status` STRING COMMENT 'Current approval status of the promotion group in the governance workflow.',
    `approved_by` STRING COMMENT 'Name or identifier of the person who approved this promotion group for activation.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the promotion group was approved.',
    `business_owner` STRING COMMENT 'Name or identifier of the business unit, department, or individual responsible for managing this promotion group.',
    `channel_applicability` STRING COMMENT 'Sales channels where this promotion group applies, enabling omnichannel promotion management and channel-specific conflict resolution.',
    `conflict_resolution_rule` STRING COMMENT 'Rule applied when promotions within this group conflict, determining which promotion takes precedence or how they are combined.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this promotion group record was first created in the system.',
    `customer_segment_applicability` STRING COMMENT 'Customer segments or loyalty tiers to which this promotion group applies. Null indicates applicability to all customers.',
    `effective_end_date` DATE COMMENT 'Date when this promotion group ceases to be active. Null indicates the group is open-ended with no planned expiration.',
    `effective_start_date` DATE COMMENT 'Date when this promotion group becomes active and begins governing promotion conflict resolution and eligibility.',
    `exclusion_scope` STRING COMMENT 'Defines the scope of exclusion rules: whether promotions exclude only within this group, across specific groups, or globally across all promotions.',
    `geographic_scope` STRING COMMENT 'Geographic regions, markets, or store groups where this promotion group is applicable (e.g., national, regional, specific store clusters).',
    `group_code` STRING COMMENT 'Business-assigned unique code for the promotion group used for external identification and system integration.',
    `group_description` STRING COMMENT 'Detailed description of the promotion group, including its business purpose, scope, and intended use.',
    `group_name` STRING COMMENT 'Human-readable name of the promotion group describing its purpose or theme.',
    `group_type` STRING COMMENT 'Classification of the promotion group indicating its functional purpose in promotion management (e.g., exclusion groups prevent simultaneous application, inclusion groups bundle offers, priority groups establish precedence).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this promotion group record was last updated.',
    `max_promotions_per_transaction` STRING COMMENT 'Maximum number of promotions from this group that can be applied to a single transaction. Null indicates no limit.',
    `notes` STRING COMMENT 'Free-form notes or comments about the promotion group for internal reference and documentation.',
    `priority_level` STRING COMMENT 'Numeric priority ranking used to resolve conflicts when multiple promotion groups apply to the same transaction. Lower numbers indicate higher priority.',
    `stacking_allowed_flag` BOOLEAN COMMENT 'Indicates whether promotions within this group can be stacked (applied simultaneously) with promotions from other groups.',
    `promo_group_status` STRING COMMENT 'Current lifecycle status of the promotion group indicating whether it is actively used in promotion conflict resolution and eligibility determination.',
    `vendor_funded_flag` BOOLEAN COMMENT 'Indicates whether promotions in this group are funded by vendors/suppliers as part of trade promotion agreements.',
    CONSTRAINT pk_promo_group PRIMARY KEY(`promo_group_id`)
) COMMENT 'Master reference table for promo_group. Referenced by conflicting_promo_group_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`promotion_stack` (
    `promotion_stack_id` BIGINT COMMENT 'Primary key for promotion_stack',
    `campaign_id` BIGINT COMMENT 'Reference to the parent marketing campaign under which this promotion stack is organized. Nullable for standalone promotions.',
    `parent_promotion_stack_id` BIGINT COMMENT 'Self-referencing FK on promotion_stack (parent_promotion_stack_id)',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor or supplier providing funding or support for this promotion stack. Nullable for retailer-only funded promotions.',
    `approved_by` STRING COMMENT 'Username or identifier of the business user who approved this promotion stack for activation. Nullable if not yet approved.',
    `approved_timestamp` TIMESTAMP COMMENT 'Timestamp when this promotion stack was approved for activation. Nullable if not yet approved.',
    `auto_apply` BOOLEAN COMMENT 'Indicates whether the promotion stack is automatically applied at checkout when eligibility criteria are met, or requires manual activation.',
    `budget_allocated` DECIMAL(18,2) COMMENT 'Total budget allocated for this promotion stack including all discount costs and promotional expenses.',
    `budget_currency_code` STRING COMMENT 'Three-letter ISO currency code for the budget allocated to this promotion stack.',
    `channel_applicability` STRING COMMENT 'Comma-separated list of sales channels where this promotion stack is valid (e.g., in_store, online, mobile_app, call_center).',
    `combinable_with_clearance` BOOLEAN COMMENT 'Indicates whether this promotion stack can be combined with clearance-priced items.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this promotion stack record was first created in the system.',
    `customer_segment` STRING COMMENT 'Target customer segment or segments eligible for this promotion stack (e.g., all_customers, loyalty_members, new_customers, vip_tier).',
    `effective_end_date` DATE COMMENT 'Date when the promotion stack expires and is no longer available for redemption. Nullable for open-ended promotions.',
    `effective_start_date` DATE COMMENT 'Date when the promotion stack becomes active and eligible for customer redemption.',
    `exclude_sale_items` BOOLEAN COMMENT 'Indicates whether items already on sale are excluded from this promotion stack.',
    `funding_source` STRING COMMENT 'Entity responsible for funding the promotional discount: retailer-funded, vendor-funded, co-funded partnership, or manufacturer-funded.',
    `geographic_scope` STRING COMMENT 'Geographic regions or store locations where the promotion stack is valid. May include country codes, state/province codes, or store identifiers.',
    `is_active` BOOLEAN COMMENT 'Indicates whether this promotion stack is currently active and available for redemption based on status and effective dates.',
    `last_modified_by` STRING COMMENT 'Username or identifier of the business user who last modified this promotion stack record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this promotion stack record was last updated.',
    `maximum_discount_amount` DECIMAL(18,2) COMMENT 'Maximum total discount amount that can be applied from this promotion stack in a single transaction. Nullable if no cap applies.',
    `minimum_purchase_amount` DECIMAL(18,2) COMMENT 'Minimum transaction subtotal required to qualify for the promotion stack. Nullable if no minimum applies.',
    `priority_rank` STRING COMMENT 'Numeric ranking used to determine precedence when multiple promotion stacks are eligible for the same transaction. Lower numbers indicate higher priority.',
    `promotional_message` STRING COMMENT 'Customer-facing marketing message or tagline displayed for this promotion stack across channels.',
    `redemption_limit_per_customer` STRING COMMENT 'Maximum number of times a single customer can redeem this promotion stack during its validity period. Nullable for unlimited redemptions.',
    `requires_coupon` BOOLEAN COMMENT 'Indicates whether a coupon code or digital coupon is required to activate this promotion stack.',
    `stack_code` STRING COMMENT 'Business-facing unique code for the promotion stack used in operational systems and reporting.',
    `stack_description` STRING COMMENT 'Detailed description of the promotion stack including its business objectives, target audience, and promotional strategy.',
    `stack_name` STRING COMMENT 'Human-readable name of the promotion stack describing its purpose or campaign theme.',
    `stack_status` STRING COMMENT 'Current lifecycle status of the promotion stack indicating its operational state.',
    `stack_type` STRING COMMENT 'Classification of the promotion stack structure indicating whether it contains a single offer, multiple stacked offers, tiered discounts, bundled deals, cross-category promotions, or loyalty-exclusive offers.',
    `stacking_rule` STRING COMMENT 'Rule governing how this promotion stack interacts with other promotions: exclusive (cannot combine), stackable (can combine with others), conditional (stacks under specific conditions), or best_deal (system selects best offer).',
    `terms_and_conditions` STRING COMMENT 'Legal terms, conditions, and restrictions governing the use and redemption of this promotion stack.',
    `total_redemption_limit` STRING COMMENT 'Maximum total number of redemptions allowed across all customers for this promotion stack. Nullable for unlimited redemptions.',
    `created_by` STRING COMMENT 'Username or identifier of the business user who created this promotion stack record.',
    CONSTRAINT pk_promotion_stack PRIMARY KEY(`promotion_stack_id`)
) COMMENT 'Master reference table for promotion_stack. Referenced by promotion_stack_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_parent_promo_campaign_id` FOREIGN KEY (`parent_promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_promo_calendar_id` FOREIGN KEY (`promo_calendar_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_calendar`(`promo_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_promotion_stack_id` FOREIGN KEY (`promotion_stack_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promotion_stack`(`promotion_stack_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_promotion_stack_id` FOREIGN KEY (`promotion_stack_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promotion_stack`(`promotion_stack_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_promo_budget_id` FOREIGN KEY (`promo_budget_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_budget`(`promo_budget_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_promo_calendar_id` FOREIGN KEY (`promo_calendar_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_calendar`(`promo_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ADD CONSTRAINT `fk_promotion_rebate_claim_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ADD CONSTRAINT `fk_promotion_rebate_claim_rebate_id` FOREIGN KEY (`rebate_id`) REFERENCES `vibe_retail_v1`.`promotion`.`rebate`(`rebate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ADD CONSTRAINT `fk_promotion_vendor_promo_agreement_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ADD CONSTRAINT `fk_promotion_vendor_promo_claim_vendor_promo_agreement_id` FOREIGN KEY (`vendor_promo_agreement_id`) REFERENCES `vibe_retail_v1`.`promotion`.`vendor_promo_agreement`(`vendor_promo_agreement_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_coupon_id` FOREIGN KEY (`coupon_id`) REFERENCES `vibe_retail_v1`.`promotion`.`coupon`(`coupon_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_promotion_stack_id` FOREIGN KEY (`promotion_stack_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promotion_stack`(`promotion_stack_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_rebate_id` FOREIGN KEY (`rebate_id`) REFERENCES `vibe_retail_v1`.`promotion`.`rebate`(`rebate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_promo_calendar_id` FOREIGN KEY (`promo_calendar_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_calendar`(`promo_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ADD CONSTRAINT `fk_promotion_promo_budget_promo_calendar_id` FOREIGN KEY (`promo_calendar_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_calendar`(`promo_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ADD CONSTRAINT `fk_promotion_promo_budget_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ADD CONSTRAINT `fk_promotion_promo_conflict_rule_promo_group_id` FOREIGN KEY (`promo_group_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_group`(`promo_group_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ADD CONSTRAINT `fk_promotion_promo_conflict_rule_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ADD CONSTRAINT `fk_promotion_promo_forecast_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ADD CONSTRAINT `fk_promotion_promo_forecast_promo_calendar_id` FOREIGN KEY (`promo_calendar_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_calendar`(`promo_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ADD CONSTRAINT `fk_promotion_promo_forecast_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ADD CONSTRAINT `fk_promotion_circular_ad_category_feature_circular_ad_id` FOREIGN KEY (`circular_ad_id`) REFERENCES `vibe_retail_v1`.`promotion`.`circular_ad`(`circular_ad_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon_distribution` ADD CONSTRAINT `fk_promotion_coupon_distribution_coupon_id` FOREIGN KEY (`coupon_id`) REFERENCES `vibe_retail_v1`.`promotion`.`coupon`(`coupon_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_inventory_allocation` ADD CONSTRAINT `fk_promotion_promo_inventory_allocation_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_group` ADD CONSTRAINT `fk_promotion_promo_group_conflicting_promo_group_id` FOREIGN KEY (`conflicting_promo_group_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_group`(`promo_group_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promotion_stack` ADD CONSTRAINT `fk_promotion_promotion_stack_parent_promotion_stack_id` FOREIGN KEY (`parent_promotion_stack_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promotion_stack`(`promotion_stack_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`promotion` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_retail_v1`.`promotion` SET TAGS ('dbx_domain' = 'promotion');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` SET TAGS ('dbx_subdomain' = 'campaign_management');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promotional Campaign ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Target Product Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `parent_promo_campaign_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `profit_center_id` SET TAGS ('dbx_business_glossary_term' = 'Profit Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `promo_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Calendar Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `semantic_layer_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Semantic Layer Entity Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Campaign Budget Amount');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `budget_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `campaign_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `campaign_type` SET TAGS ('dbx_value_regex' = 'seasonal|clearance|new_product_launch|loyalty|vendor_funded|flash_sale');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `channel_scope` SET TAGS ('dbx_value_regex' = 'omnichannel|in_store_only|online_only|mobile_app_only');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `discount_strategy` SET TAGS ('dbx_value_regex' = 'percentage_off|fixed_amount_off|bogo|bundle|tiered|rebate');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Campaign End Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = 'national|regional|local|store_specific');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `owner_email` SET TAGS ('dbx_business_glossary_term' = 'Campaign Owner Email');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `owner_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `owner_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `owner_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `owner_name` SET TAGS ('dbx_business_glossary_term' = 'Campaign Owner Name');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `promo_campaign_status` SET TAGS ('dbx_business_glossary_term' = 'Campaign Status');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `promo_campaign_status` SET TAGS ('dbx_value_regex' = 'draft|scheduled|active|paused|completed|cancelled');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Campaign Start Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `target_revenue` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` SET TAGS ('dbx_subdomain' = 'campaign_management');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promotional Offer ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promotional Campaign ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `promotion_stack_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion Stack Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `activation_trigger` SET TAGS ('dbx_value_regex' = 'manual|cart_threshold|login|geofence|time_based|event_based');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `channel_eligibility` SET TAGS ('dbx_value_regex' = 'POS|ecommerce|mobile|BOPIS|ROPIS|all_channels');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `cost_share_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `customer_segment_eligibility` SET TAGS ('dbx_value_regex' = 'all_customers|loyalty_members|VIP|new_customers|targeted_segment');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `discount_method` SET TAGS ('dbx_value_regex' = 'percentage|fixed_amount|tiered|quantity_based');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `effective_end_time` SET TAGS ('dbx_business_glossary_term' = 'Effective End Timestamp');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `effective_start_time` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Timestamp');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `maximum_redemption_total` SET TAGS ('dbx_business_glossary_term' = 'Maximum Total Redemptions');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `offer_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `offer_status` SET TAGS ('dbx_value_regex' = 'draft|scheduled|active|paused|expired|cancelled');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `offer_type` SET TAGS ('dbx_value_regex' = 'BOGO|percent_off|dollar_off|free_gift|bundle|threshold_discount');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `product_eligibility_scope` SET TAGS ('dbx_value_regex' = 'all_products|category|SKU_list|brand|excluded_products');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `store_eligibility_scope` SET TAGS ('dbx_value_regex' = 'all_stores|store_group|individual_store|excluded_stores');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` SET TAGS ('dbx_subdomain' = 'offer_execution');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `tier_id` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Tier Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion Campaign ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `promotion_stack_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion Stack Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `semantic_layer_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Semantic Layer Entity Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `barcode` SET TAGS ('dbx_value_regex' = '^[0-9]{12,14}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `coupon_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `coupon_status` SET TAGS ('dbx_value_regex' = 'active|inactive|expired|suspended|redeemed');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `coupon_type` SET TAGS ('dbx_value_regex' = 'manufacturer|store|digital|paper|loyalty|vendor_funded');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `discount_type` SET TAGS ('dbx_value_regex' = 'percentage|fixed_amount|bogo|free_shipping|tiered');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `eligible_channel` SET TAGS ('dbx_value_regex' = 'all_channels|pos|ecommerce|mobile_app|bopis');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `eligible_product_scope` SET TAGS ('dbx_value_regex' = 'all_products|category|brand|sku|basket');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_value_regex' = 'retailer|manufacturer|vendor|third_party');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` SET TAGS ('dbx_subdomain' = 'campaign_management');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `circular_ad_id` SET TAGS ('dbx_business_glossary_term' = 'Circular Advertisement ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `assortment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Assortment Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Review Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `creative_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Creative Asset Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Featured Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `promo_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Budget Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `promo_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Calendar Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `report_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Report Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `tertiary_circular_modified_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `circular_type` SET TAGS ('dbx_value_regex' = 'weekly|seasonal|holiday|event|clearance|grand_opening');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = 'print|digital|email|mobile_app|social_media|in_store');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `is_vendor_funded` SET TAGS ('dbx_business_glossary_term' = 'Is Vendor Funded Flag');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Circular Notes');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `production_cost_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `production_cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `production_status` SET TAGS ('dbx_value_regex' = 'draft|in_review|approved|in_production|published|archived');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `theme` SET TAGS ('dbx_business_glossary_term' = 'Circular Theme');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `vendor_funding_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` SET TAGS ('dbx_subdomain' = 'vendor_funding');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `rebate_created_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `rebate_created_by_user_associate_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `rebate_created_by_user_associate_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `rebate_last_modified_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `rebate_last_modified_by_user_associate_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `rebate_last_modified_by_user_associate_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `amount` SET TAGS ('dbx_business_glossary_term' = 'Rebate Amount');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending_approval|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `channel_eligibility` SET TAGS ('dbx_value_regex' = 'all_channels|pos_only|ecommerce_only|mobile_app_only|omnichannel');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'check|store_credit|digital_credit|prepaid_card|bank_transfer|instant_discount');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `percentage` SET TAGS ('dbx_business_glossary_term' = 'Rebate Percentage');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `rebate_number` SET TAGS ('dbx_value_regex' = '^RBT-[A-Z0-9]{8,12}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `rebate_status` SET TAGS ('dbx_value_regex' = 'draft|active|paused|expired|cancelled|completed');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `rebate_type` SET TAGS ('dbx_value_regex' = 'instant_rebate|mail_in_rebate|vendor_funded_rebate|digital_rebate|promotional_allowance|volume_rebate');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ALTER COLUMN `total_budget_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` SET TAGS ('dbx_subdomain' = 'vendor_funding');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ap Invoice Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Reviewer Employee ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `dq_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Dq Rule Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `rebate_id` SET TAGS ('dbx_business_glossary_term' = 'Rebate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Claim Approval Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `approved_amount` SET TAGS ('dbx_business_glossary_term' = 'Rebate Approved Amount');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claim_number` SET TAGS ('dbx_business_glossary_term' = 'Rebate Claim Number');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claim_number` SET TAGS ('dbx_value_regex' = '^RBC-[0-9]{10}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claim_status` SET TAGS ('dbx_business_glossary_term' = 'Rebate Claim Status');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claim_status` SET TAGS ('dbx_value_regex' = 'submitted|under_review|approved|rejected|paid|cancelled');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claimant_email` SET TAGS ('dbx_business_glossary_term' = 'Claimant Email Address');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claimant_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claimant_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claimant_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claimant_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claimant_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claimant_phone` SET TAGS ('dbx_business_glossary_term' = 'Claimant Phone Number');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claimant_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claimant_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claimant_type` SET TAGS ('dbx_value_regex' = 'customer|vendor|supplier|partner');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `claimed_amount` SET TAGS ('dbx_business_glossary_term' = 'Rebate Claimed Amount');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `documentation_status` SET TAGS ('dbx_business_glossary_term' = 'Supporting Documentation Status');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `documentation_status` SET TAGS ('dbx_value_regex' = 'complete|incomplete|pending|verified');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Claim Processing Notes');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Rebate Payment Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Rebate Payment Method');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'check|direct_deposit|prepaid_card|store_credit|digital_wallet');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `processing_sla_days` SET TAGS ('dbx_business_glossary_term' = 'Processing Service Level Agreement (SLA) Days');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `product_sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `purchase_amount` SET TAGS ('dbx_business_glossary_term' = 'Qualifying Purchase Amount');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `purchase_date` SET TAGS ('dbx_business_glossary_term' = 'Qualifying Purchase Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `receipt_uploaded` SET TAGS ('dbx_business_glossary_term' = 'Receipt Uploaded Flag');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `rejection_date` SET TAGS ('dbx_business_glossary_term' = 'Claim Rejection Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `rejection_reason_code` SET TAGS ('dbx_value_regex' = 'INELIGIBLE_PRODUCT|EXPIRED_PROMOTION|MISSING_DOCUMENTATION|DUPLICATE_CLAIM|INVALID_PURCHASE|OTHER');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `review_date` SET TAGS ('dbx_business_glossary_term' = 'Claim Review Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `submission_channel` SET TAGS ('dbx_business_glossary_term' = 'Claim Submission Channel');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `submission_channel` SET TAGS ('dbx_value_regex' = 'web|mobile_app|email|mail|in_store|call_center');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Claim Submission Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Claim Submission Timestamp');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `upc_code` SET TAGS ('dbx_business_glossary_term' = 'Universal Product Code (UPC)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `upc_code` SET TAGS ('dbx_value_regex' = '^[0-9]{12}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ALTER COLUMN `vendor_chargeback_status` SET TAGS ('dbx_value_regex' = 'pending|submitted|approved|disputed|settled');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` SET TAGS ('dbx_subdomain' = 'vendor_funding');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `vendor_promo_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Promotional Agreement ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `accrual_method` SET TAGS ('dbx_value_regex' = 'purchase-based|sales-based|display-based|hybrid');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `ad_placement_required` SET TAGS ('dbx_business_glossary_term' = 'Advertisement Placement Required Flag');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'co-op advertising|off-invoice allowance|bill-back|scan allowance|new item allowance|volume rebate');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `chargeback_eligible` SET TAGS ('dbx_business_glossary_term' = 'Chargeback Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `display_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'Display Compliance Required Flag');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `funding_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Agreement Notes');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `qualifying_product_scope` SET TAGS ('dbx_value_regex' = 'all products|specific SKU|product category|brand|private label');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `settlement_frequency` SET TAGS ('dbx_value_regex' = 'one-time|weekly|monthly|quarterly|annually|event-based');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `settlement_terms` SET TAGS ('dbx_value_regex' = 'upfront credit|monthly accrual|quarterly settlement|post-event claim|scan-based settlement');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `vendor_promo_agreement_status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Status');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` SET TAGS ('dbx_subdomain' = 'vendor_funding');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ALTER COLUMN `vendor_promo_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Promotional Claim ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ap Invoice Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Submitted By User ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ALTER COLUMN `vendor_promo_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Promotional Agreement ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ALTER COLUMN `claim_type` SET TAGS ('dbx_value_regex' = 'scan_allowance|bill_back|co_op_reimbursement|markdown_allowance|volume_rebate|slotting_fee');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ALTER COLUMN `is_automated_claim` SET TAGS ('dbx_business_glossary_term' = 'Is Automated Claim Flag');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'check|wire_transfer|ach|credit_memo|offset_against_payables|other');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` SET TAGS ('dbx_subdomain' = 'offer_execution');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `promo_redemption_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion Redemption ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Cashier ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `attribution_touchpoint_id` SET TAGS ('dbx_business_glossary_term' = 'Attribution Touchpoint Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `coupon_id` SET TAGS ('dbx_business_glossary_term' = 'Coupon Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `fulfillment_order_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order Header Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `journal_entry_id` SET TAGS ('dbx_business_glossary_term' = 'Journal Entry Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Membership Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `pos_terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Point of Sale (POS) Terminal ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `pos_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Transaction ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `rebate_id` SET TAGS ('dbx_business_glossary_term' = 'Rebate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `chargeback_status` SET TAGS ('dbx_value_regex' = 'pending|submitted|approved|rejected|paid');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `discount_type` SET TAGS ('dbx_value_regex' = 'percentage_off|fixed_amount_off|bogo|bundle_discount|threshold_discount|free_shipping');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `processing_system` SET TAGS ('dbx_value_regex' = 'pos|ecommerce_engine|oms|loyalty_platform|promotion_engine');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `redemption_channel` SET TAGS ('dbx_value_regex' = 'pos|ecommerce_web|ecommerce_mobile|call_center|kiosk|mobile_app');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `redemption_limit_type` SET TAGS ('dbx_value_regex' = 'per_customer|per_transaction|per_day|per_campaign|unlimited');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `redemption_status` SET TAGS ('dbx_value_regex' = 'valid|invalid|duplicate|expired|limit_exceeded|fraud_suspected');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `source_record_reference` SET TAGS ('dbx_business_glossary_term' = 'Source Record ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` SET TAGS ('dbx_subdomain' = 'vendor_funding');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `promo_performance_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion Performance ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `assortment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Assortment Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `promo_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Calendar Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion Offer ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `stock_ledger_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Ledger Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `average_transaction_value` SET TAGS ('dbx_business_glossary_term' = 'Average Transaction Value (ATV)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `channel` SET TAGS ('dbx_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `channel` SET TAGS ('dbx_value_regex' = 'in_store|ecommerce|mobile_app|bopis|ropis');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `cogs` SET TAGS ('dbx_business_glossary_term' = 'Cost of Goods Sold (COGS)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `cogs` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `data_source_system` SET TAGS ('dbx_value_regex' = 'sap_car|blue_yonder|oracle_rpm|manual_adjustment');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `forecast_accuracy_percent` SET TAGS ('dbx_business_glossary_term' = 'Forecast Accuracy Percentage');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `gross_margin` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `gross_margin_percent` SET TAGS ('dbx_business_glossary_term' = 'Gross Margin Percentage');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `gross_margin_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Performance Notes');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `performance_status` SET TAGS ('dbx_value_regex' = 'preliminary|final|adjusted|settled');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `promotional_roi` SET TAGS ('dbx_business_glossary_term' = 'Promotional Return on Investment (ROI)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `promotional_roi` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `retailer_funded_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `sell_through_rate` SET TAGS ('dbx_business_glossary_term' = 'Sell-Through Rate');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `sku` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,14}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `units_per_transaction` SET TAGS ('dbx_business_glossary_term' = 'Units Per Transaction (UPT)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `vendor_funded_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` SET TAGS ('dbx_subdomain' = 'campaign_management');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `promo_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Promotional Budget ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Budget Owner ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Finance Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `marketing_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Budget Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `merch_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Merch Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `promo_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Calendar Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'not_submitted|pending_review|approved|rejected|revision_required');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `budget_number` SET TAGS ('dbx_value_regex' = '^PB-[0-9]{8}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `budget_owner_type` SET TAGS ('dbx_value_regex' = 'department|category|brand|channel|region|store_cluster');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `budget_type` SET TAGS ('dbx_value_regex' = 'internal_marketing|vendor_coop|markdown_allowance|clearance_reserve|trade_promotion|digital_advertising');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `circular_ad_allocation` SET TAGS ('dbx_business_glossary_term' = 'Circular Advertisement Allocation');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `ecommerce_channel_allocation` SET TAGS ('dbx_business_glossary_term' = 'E-Commerce Channel Allocation');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(Q[1-4]|M(0[1-9]|1[0-2])|H[1-2]|FY)$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_value_regex' = '^[0-9]{4,10}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `mobile_channel_allocation` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `mobile_channel_allocation` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Budget Notes');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `otb_integration_flag` SET TAGS ('dbx_business_glossary_term' = 'Open to Buy (OTB) Integration Flag');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `pos_channel_allocation` SET TAGS ('dbx_business_glossary_term' = 'Point of Sale (POS) Channel Allocation');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ALTER COLUMN `profit_center_code` SET TAGS ('dbx_value_regex' = '^PC-[0-9]{6}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` SET TAGS ('dbx_subdomain' = 'campaign_management');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `promo_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Promotional Calendar ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `banner_applicability` SET TAGS ('dbx_business_glossary_term' = 'Banner Applicability Scope');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `banner_applicability` SET TAGS ('dbx_value_regex' = 'enterprise_wide|banner_specific');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `blackout_reason` SET TAGS ('dbx_business_glossary_term' = 'Blackout Period Reason');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Promotional Budget Amount');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `channel_applicability` SET TAGS ('dbx_business_glossary_term' = 'Channel Applicability Scope');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `channel_applicability` SET TAGS ('dbx_value_regex' = 'omnichannel|store_only|ecommerce_only|mobile_app_only');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Promotional Period End Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `expected_sales_lift_pct` SET TAGS ('dbx_business_glossary_term' = 'Expected Sales Lift Percentage');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `expected_traffic_lift_pct` SET TAGS ('dbx_business_glossary_term' = 'Expected Traffic Lift Percentage');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Active Record Indicator');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `is_blackout_period` SET TAGS ('dbx_business_glossary_term' = 'Blackout Period Indicator');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `market_applicability` SET TAGS ('dbx_business_glossary_term' = 'Market Applicability Scope');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `market_applicability` SET TAGS ('dbx_value_regex' = 'national|regional|local');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Planning Notes');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `period_name` SET TAGS ('dbx_business_glossary_term' = 'Promotional Period Name');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `period_type` SET TAGS ('dbx_business_glossary_term' = 'Promotional Period Type');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `period_type` SET TAGS ('dbx_value_regex' = 'weekly_ad_cycle|seasonal_event|holiday|clearance_window|competitive_response|vendor_funded');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `planning_owner_email` SET TAGS ('dbx_business_glossary_term' = 'Planning Owner Email Address');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `planning_owner_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `planning_owner_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `planning_status` SET TAGS ('dbx_value_regex' = 'draft|locked|active|archived');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `priority_tier` SET TAGS ('dbx_business_glossary_term' = 'Promotional Priority Tier');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `priority_tier` SET TAGS ('dbx_value_regex' = 'tier_1_strategic|tier_2_major|tier_3_standard|tier_4_tactical');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Promotional Period Start Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `theme_description` SET TAGS ('dbx_business_glossary_term' = 'Promotional Theme Description');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` SET TAGS ('dbx_subdomain' = 'campaign_management');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `promo_conflict_rule_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion Conflict Rule ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `promo_group_id` SET TAGS ('dbx_business_glossary_term' = 'Conflicting Promotion Group ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Promotion ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `tertiary_promo_approved_by_user_associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `applies_to_scope` SET TAGS ('dbx_value_regex' = 'sku_level|category_level|brand_level|vendor_level|transaction_level|customer_segment');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `jurisdiction_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `max_discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Maximum Discount Amount');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `max_discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Maximum Discount Percentage');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `max_stack_count` SET TAGS ('dbx_business_glossary_term' = 'Maximum Stack Count');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `oms_system_flag` SET TAGS ('dbx_business_glossary_term' = 'Order Management System (OMS) Flag');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `override_authorization_level` SET TAGS ('dbx_value_regex' = 'none|cashier|supervisor|store_manager|regional_manager|corporate_only');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `pos_system_flag` SET TAGS ('dbx_business_glossary_term' = 'Point of Sale (POS) System Flag');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `rule_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{4,20}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `rule_status` SET TAGS ('dbx_value_regex' = 'active|inactive|draft|pending_approval|suspended|archived');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ALTER COLUMN `rule_type` SET TAGS ('dbx_value_regex' = 'exclusivity|stackability|priority_override|best_deal_selection|explicit_exclusion|vendor_funded_override');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` SET TAGS ('dbx_subdomain' = 'offer_execution');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `promo_forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion Forecast ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `assortment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Assortment Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `demand_forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Demand Forecast Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Marketing Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `merch_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Merch Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `promo_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Calendar Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `stock_position_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Position Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `channel` SET TAGS ('dbx_value_regex' = 'store|ecommerce|mobile|omnichannel');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `forecast_confidence_level` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `forecast_status` SET TAGS ('dbx_value_regex' = 'draft|approved|rejected|superseded');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `open_to_buy_impact_amount` SET TAGS ('dbx_business_glossary_term' = 'Open To Buy (OTB) Impact Amount');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ALTER COLUMN `promotion_type` SET TAGS ('dbx_value_regex' = 'BOGO|markdown|coupon|rebate|bundle|seasonal');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` SET TAGS ('dbx_subdomain' = 'campaign_management');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` SET TAGS ('dbx_association_edges' = 'promotion.circular_ad,merchandising.category');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Circular Ad Category Feature - Category Id');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `circular_ad_id` SET TAGS ('dbx_business_glossary_term' = 'Circular Ad Category Feature - Circular Ad Id');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `actual_sales_amount` SET TAGS ('dbx_business_glossary_term' = 'Actual Category Sales Amount');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `allocated_space_sqin` SET TAGS ('dbx_business_glossary_term' = 'Allocated Space Square Inches');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `category_sales_target` SET TAGS ('dbx_business_glossary_term' = 'Category Sales Target Amount');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `creative_theme` SET TAGS ('dbx_business_glossary_term' = 'Category Feature Creative Theme');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `feature_prominence` SET TAGS ('dbx_business_glossary_term' = 'Feature Prominence Level');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `feature_sequence` SET TAGS ('dbx_business_glossary_term' = 'Feature Sequence Number');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Feature Notes');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `page_number` SET TAGS ('dbx_business_glossary_term' = 'Feature Page Number');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `sales_lift_percent` SET TAGS ('dbx_business_glossary_term' = 'Category Sales Lift Percentage');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `traffic_attribution_percent` SET TAGS ('dbx_business_glossary_term' = 'Traffic Attribution Percentage');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `vendor_co_op_amount` SET TAGS ('dbx_business_glossary_term' = 'Vendor Co-op Amount');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ALTER COLUMN `vendor_co_op_flag` SET TAGS ('dbx_business_glossary_term' = 'Vendor Co-op Funded Flag');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon_distribution` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon_distribution` SET TAGS ('dbx_subdomain' = 'offer_execution');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon_distribution` SET TAGS ('dbx_association_edges' = 'promotion.coupon,marketing.audience_segment');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon_distribution` ALTER COLUMN `coupon_distribution_id` SET TAGS ('dbx_business_glossary_term' = 'Coupon Distribution Identifier');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon_distribution` ALTER COLUMN `audience_segment_id` SET TAGS ('dbx_business_glossary_term' = 'Coupon Distribution - Audience Segment Id');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon_distribution` ALTER COLUMN `coupon_id` SET TAGS ('dbx_business_glossary_term' = 'Coupon Distribution - Coupon Id');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon_distribution` ALTER COLUMN `redemption_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Redemption Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_inventory_allocation` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_inventory_allocation` SET TAGS ('dbx_subdomain' = 'offer_execution');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_inventory_allocation` SET TAGS ('dbx_association_edges' = 'promotion.promo_campaign,supplychain.dc_facility');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_inventory_allocation` ALTER COLUMN `promo_inventory_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Promotional Inventory Allocation Identifier');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_inventory_allocation` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Inventory Allocation - Dc Facility Id');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_inventory_allocation` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Inventory Allocation - Promo Campaign Id');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_inventory_allocation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Allocation Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_inventory_allocation` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Allocation Effective End Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_inventory_allocation` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Allocation Effective Start Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_inventory_allocation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Allocation Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_inventory_allocation` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Allocation Created By');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_group` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_group` SET TAGS ('dbx_subdomain' = 'campaign_management');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_group` ALTER COLUMN `promo_group_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Group Identifier');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_group` ALTER COLUMN `conflicting_promo_group_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promotion_stack` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promotion_stack` SET TAGS ('dbx_subdomain' = 'campaign_management');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promotion_stack` ALTER COLUMN `promotion_stack_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion Stack Identifier');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promotion_stack` ALTER COLUMN `parent_promotion_stack_id` SET TAGS ('dbx_self_ref_fk' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promotion_stack` ALTER COLUMN `budget_allocated` SET TAGS ('dbx_confidential' = 'true');
