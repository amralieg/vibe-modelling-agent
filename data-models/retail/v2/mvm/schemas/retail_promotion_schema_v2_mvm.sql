-- Schema for Domain: promotion | Business: Retail | Version: v2_mvm
-- Generated on: 2026-07-12 15:26:01

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`promotion` COMMENT 'Manages promotional campaigns, deals, coupons, rebates, BOGO offers, seasonal sales events, circular ads, and digital promotions across channels. Tracks promotion effectiveness, redemption rates, incremental lift, promotional ROI, and vendor-funded promotion agreements. Distinct from pricing — promotions are time-bound, event-driven incentives. Supports omnichannel promotion execution across POS, e-commerce, and mobile apps.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` (
    `promo_campaign_id` BIGINT COMMENT 'Unique identifier for the promotional campaign. Primary key.',
    `brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Retail campaigns frequently target specific brands (vendor-funded brand promotions, brand exclusives, seasonal brand pushes). Business tracks brand-level campaign performance and vendor funding agreem',
    `buyer_id` BIGINT COMMENT 'Foreign key linking to merchandising.buyer. Business justification: Promotional campaigns are owned and approved by the merchandising buyer responsible for the category. owner_name and owner_email on promo_campaign are denormalized buyer attributes. A proper FK enforc',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.format. Business justification: Campaigns are measured against specific KPIs (sales lift %, ROI, redemption rate). Campaign managers select target KPIs during planning; performance dashboards require this link to show actual vs targ',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Campaigns target product categories/departments (e.g., Back to School - Electronics). Budget allocation, buyer approval workflows, and performance rollup all operate at hierarchy level. Enables cate',
    `parent_promo_campaign_id` BIGINT COMMENT 'Self-referencing FK on promo_campaign (parent_promo_campaign_id)',
    `promo_calendar_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_calendar. Business justification: Campaigns are planned and executed according to promotional calendar periods. The promo_campaign has start_date and end_date that should align with promotional periods defined in promo_calendar (e.g.',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Promotional campaigns are planned and executed at category level. Category managers need visibility to all campaigns targeting their categories for assortment planning, inventory positioning, and perf',
    `vendor_id` BIGINT COMMENT 'Identifier of the vendor providing funding or support for the campaign, if applicable.',
    `region_id` BIGINT COMMENT 'Foreign key linking to store.region. Business justification: Regional campaign planning is a core retail process — regional directors approve and own campaigns scoped to their geography. promo_campaign.geographic_scope is a text field; a proper region_id FK ena',
    `return_policy_id` BIGINT COMMENT 'Foreign key linking to returns.return_policy. Business justification: Retail campaigns (Black Friday, holiday sales) routinely mandate campaign-level return policy overrides. Linking promo_campaign to return_policy enables campaign planning teams to assign and enforce s',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Seasonal promotions (Back-to-School, Holiday, Spring clearance) are core retail planning. Campaigns must align with merchandising seasonal calendars for coordinated go-to-market execution. Critical fo',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Digital campaign storefront scoping: promotional campaigns targeting specific e-commerce storefronts (app launch campaigns, site-exclusive events) need a direct storefront reference for campaign execu',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: Promotional campaigns are authorized and funded under specific vendor contracts defining co-op advertising terms, funding percentages, and promotional obligations. Retail finance teams reconcile campa',
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
    `assortment_plan_id` BIGINT COMMENT 'Foreign key linking to merchandising.assortment_plan. Business justification: Promotional offers must be validated against the active assortment plan to ensure only assorted SKUs are promoted. Buyers use this link to enforce assortment eligibility rules during offer setup and t',
    `brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Offers commonly apply to entire brand portfolios ("20% off all Brand X products"). Retailers negotiate brand-level promotional pricing with vendors. Business needs brand-offer linkage for vendor charg',
    `cluster_id` BIGINT COMMENT 'Foreign key linking to store.cluster. Business justification: Cluster-based offer targeting is standard retail practice — urban clusters receive different offers than suburban or rural clusters. promo_offer.store_eligibility_scope is a text field; a cluster_id F',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.format. Business justification: Individual offers tracked against specific KPIs (conversion rate, average basket lift, incremental margin). Offer optimization requires linking each offer to its primary performance KPI for A/B testin',
    `otb_budget_id` BIGINT COMMENT 'Foreign key linking to merchandising.otb_budget. Business justification: Promotional offers consume open-to-buy budget — retailer-funded promotional costs must be tracked and approved against the OTB budget. Buyers approve offers within OTB constraints. This link enables t',
    `promo_campaign_id` BIGINT COMMENT 'Reference to the parent promotional campaign under which this offer is organized.',
    `carrier_service_id` BIGINT COMMENT 'Foreign key linking to fulfillment.carrier_service. Business justification: Promotional free/discounted shipping offers (e.g., free 2-day delivery) are scoped to specific carrier services in retail operations. This link enables offer eligibility validation at checkout and c',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Offers target specific categories (e.g., 20% off Apparel). Merchandising needs category-level offer visibility for pricing decisions, margin analysis, and assortment adjustments. Essential for categor',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Promotional offers target specific SKUs for discount application. Essential for offer eligibility validation, POS redemption logic, inventory planning for promoted items, and promotional ROI analysis',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor/supplier funding or co-funding this promotional offer. Null if retailer-funded.',
    `return_policy_id` BIGINT COMMENT 'Foreign key linking to returns.return_policy. Business justification: Promotional offers in retail frequently carry offer-specific return policies (e.g., final sale, extended window). Linking promo_offer to return_policy enables automated return eligibility enforcement ',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Seasonal offers (new season launch promotions, end-of-season clearance) require season context for merchandising coordination. Buyers need to see all offers planned for their seasons to coordinate inv',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: Individual promo offers (BOGO, % off) are governed by vendor contract terms specifying cost-sharing and funding eligibility. Offer management and vendor settlement processes require this link to valid',
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
    `brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Manufacturer coupons are brand-specific (vendor-funded). Retailers track brand-level coupon redemption for vendor settlement and chargeback. Business process requires linking coupon to brand for vendo',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Coupons are category-specific ("$5 off Grocery", "20% off Electronics"). Category managers track coupon redemption impact on sales velocity, margin, and inventory turn. Essential for category-level pr',
    `profile_id` BIGINT COMMENT 'Foreign key linking to customer.profile. Business justification: Retail operations issue personalized coupons to specific customers for loyalty programs, birthday offers, and win-back campaigns. Tracking issued_to enables single-use enforcement, fraud detection, an',
    `promo_campaign_id` BIGINT COMMENT 'Reference to the parent promotional campaign under which this coupon was issued.',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_offer. Business justification: Coupons are instruments that implement specific promotional offers. While coupon already has promotion_campaign_id (linking to the campaign), it needs promo_offer_id to identify the exact offer the co',
    `region_id` BIGINT COMMENT 'Foreign key linking to store.region. Business justification: Coupons carry geographic restrictions for regulatory compliance (e.g., alcohol promotions restricted by jurisdiction, regional pricing laws). coupon.geographic_restriction is a denormalized text field',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Coupons restrict redemption to qualifying SKUs. POS systems validate coupon eligibility against product attributes (brand, category, vendor). Inventory planning uses this to forecast demand spikes. Ve',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Digital coupon distribution scoping: coupons issued for specific digital storefronts (app-exclusive coupons, site-specific promo codes) must reference the storefront for redemption validation and chan',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: Vendor-funded coupons are issued under specific vendor contracts. The coupon redemption settlement and chargeback process requires tracing each coupon to its governing vendor_contract to validate fund',
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
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Circular ads have production costs (production_cost_amount, production_cost_currency_code) that are funded from promotional budgets. While circular_ad.promo_campaign_id links to campaign, the specific',
    `vendor_id` BIGINT COMMENT 'Reference to the external vendor or agency responsible for circular design, production, or distribution services.',
    `cluster_id` BIGINT COMMENT 'Foreign key linking to store.cluster. Business justification: Circular ad distribution is planned by store cluster — a circular edition targets stores with similar demographics and format mix. circular_ad.geographic_market is a text field; a cluster_id FK enable',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Circular ads feature specific hero SKUs on cover/pages. Production teams need product images, descriptions, compliance attributes. Inventory planning ensures featured items are in stock. Performance t',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.location. Business justification: Circular production costs (printing, distribution) are charged to specific cost centers (marketing department, regional marketing). Required for budget tracking, variance analysis, and departmental P&',
    `markdown_id` BIGINT COMMENT 'Foreign key linking to pricing.markdown. Business justification: Circular ads frequently feature markdown and clearance items. Linking circular_ad to markdown enables tracking which markdowns were advertised in circulars, supporting markdown effectiveness analysis ',
    `promo_calendar_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_calendar. Business justification: Circular ads are published according to promotional calendar periods. The circular_ad has effective_start_date and effective_end_date that align with promotional periods defined in promo_calendar (e.g',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Circular ads are marketing vehicles that promote specific promotional campaigns. While circular_ad already links to marketing.campaign (cross-domain for overall marketing campaign), it needs a link to',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_offer. Business justification: A circular advertisement (print or digital) typically features specific promotional offers — e.g., a weekly circular page highlights a BOGO offer or a price-cut offer for a featured SKU. While circula',
    `sku_price_id` BIGINT COMMENT 'Foreign key linking to pricing.sku_price. Business justification: Circular ads contain creative assets managed in marketing asset libraries. Retailers link circular ads to constituent creative assets for asset performance tracking, reuse optimization, and ensuring b',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Digital circular distribution to storefronts: digital circular ads (online weekly flyers, digital deal pages) are published to specific storefronts. Linking circular_ad to storefront enables digital i',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: Circular ads are co-funded by vendors under specific contract terms governing placement obligations and funding amounts. The circular production billing process requires linking each circular_ad to th',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` (
    `vendor_promo_agreement_id` BIGINT COMMENT 'Unique identifier for the vendor-funded promotional agreement record. Primary key.',
    `brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Vendor promotional agreements often cover entire brand portfolios, not individual SKUs. Business tracks brand-level funding commitments, minimum purchase requirements, and performance obligations. Ess',
    `buying_order_id` BIGINT COMMENT 'Foreign key linking to merchandising.buying_order. Business justification: Vendor promotional funding agreements are contingent on buying order commitments — vendors fund promotions tied to specific purchase volumes. Settlement, chargeback processing, and accrual reconciliat',
    `cost_price_id` BIGINT COMMENT 'Foreign key linking to pricing.cost_price. Business justification: Vendor promo agreements establish the cost basis for vendor-funded promotions. Linking to cost_price enables accurate vendor chargeback calculation and deal cost reconciliation against the agreed cost',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Vendor promotional agreements (co-op advertising, promotional allowances) fund specific promotional campaigns. The vendor_promo_agreement table currently only links to vendor but needs promo_campaign_',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_offer. Business justification: A vendor-funded promotional agreement in retail is commonly tied to a specific promotional offer within the campaign (e.g., a vendor co-funds a BOGO offer or a percentage-off discount offer). While ve',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: A vendor_promo_agreement is a promotional-specific agreement subordinate to a master vendor_contract. Legal and finance teams link promo agreements to the governing master contract for compliance audi',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` (
    `promo_redemption_id` BIGINT COMMENT 'Unique identifier for each promotional offer redemption instance. Primary key for the promo_redemption product.',
    `coupon_id` BIGINT COMMENT 'Foreign key linking to promotion.coupon. Business justification: When a redemption is triggered by a coupon, promo_redemption needs a structured FK to the coupon master record. Currently has coupon_code as STRING, which should be replaced with coupon_id FK. This en',
    `fulfillment_node_id` BIGINT COMMENT 'Foreign key linking to fulfillment.fulfillment_node. Business justification: Promo performance reporting by fulfillment node (ship-from-store vs. DC) is a standard omnichannel retail KPI. Knowing which fulfillment node processed each promotional redemption enables node-level S',
    `fulfillment_order_id` BIGINT COMMENT 'Foreign key linking to fulfillment.fulfillment_order. Business justification: Retail operations measure promotional effectiveness by fulfillment method (BOPIS vs ship-from-store vs DC fulfillment). Links redemptions to fulfillment execution for channel-specific lift analysis, v',
    `header_id` BIGINT COMMENT 'Foreign key linking to order.order_header. Business justification: Promotion redemptions in e-commerce/omnichannel orders need order-level context for multi-line promotion analysis, customer journey tracking, and cross-channel promotional effectiveness measurement. D',
    `order_line_id` BIGINT COMMENT 'Foreign key linking to order.order_line. Business justification: A promotion redemption event is triggered by a specific order line (the item that qualified for the offer). Linking promo_redemption to order_line enables line-level vendor chargeback at SKU granulari',
    `pos_terminal_id` BIGINT COMMENT 'Identifier of the POS terminal or register where the redemption was processed. Used for audit trail and fraud detection. Null for e-commerce transactions.',
    `pos_transaction_id` BIGINT COMMENT 'Reference to the customer transaction (POS or e-commerce order) where this promotion was applied. Links to the sales transaction header.',
    `sku_id` BIGINT COMMENT 'add column product_sku_id (BIGINT) with FK to product.sku.sku_id - redemptions occur against specific SKUs and this is essential for promotion effectiveness analysis at item level',
    `profile_id` BIGINT COMMENT 'Reference to the customer who redeemed the promotion. May be null for anonymous transactions where no customer identification was captured.',
    `promo_campaign_id` BIGINT COMMENT 'Reference to the promotional offer that was redeemed. Links to the promotion master data defining the offer terms, discount rules, and eligibility criteria.',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Redemption analysis by category is essential for merchandising to assess promotional effectiveness, cannibalization, and incremental sales. Category managers use redemption data to adjust future assor',
    `location_id` BIGINT COMMENT 'Reference to the physical store location where the redemption occurred. Populated for POS and BOPIS transactions. Null for pure e-commerce fulfillment.',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_offer. Business justification: Promotional redemptions capture the application of a specific promotional offer to a transaction. While promo_redemption already has promo_campaign_id, it needs promo_offer_id to identify the exact of',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor or supplier funding the promotion. Populated only when vendor_funded_flag is true. Used for chargeback processing and vendor settlement.',
    `rma_id` BIGINT COMMENT 'Foreign key linking to returns.rma. Business justification: Returns of promotional purchases require tracking original promotion for accurate refund calculation, vendor chargeback allocation, and fraud detection. Critical for partial refund logic when promotio',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Redemptions can be for rebate offers specifically. A customer may redeem a rebate offer at transaction time (e.g., instant rebate applied at POS), and tracking which rebate was redeemed is essential f',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: Vendor-funded redemptions must be settled against the governing vendor_contract. The chargeback and settlement process requires tracing each vendor_funded_flag=true redemption to its specific contract',
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
    `cluster_id` BIGINT COMMENT 'Foreign key linking to store.cluster. Business justification: Cluster-level promotional performance analysis is a standard retail analytics process — merchants compare how promotions perform across urban vs. suburban vs. rural store clusters to optimize future o',
    `demand_forecast_id` BIGINT COMMENT 'Foreign key linking to supplychain.demand_forecast. Business justification: Promotional Forecast Accuracy Reporting: promo_performance actuals (units_sold, incremental_units) are compared against demand_forecast predicted promotional_lift_units and mape to measure forecast qu',
    `format_id` BIGINT COMMENT 'Foreign key linking to store.format. Business justification: Performance records explicitly measure campaigns against defined KPIs. Weekly performance snapshots calculate specific KPI values (sell-through rate, promotional ROI, incremental units). Merchandising',
    `fulfillment_node_id` BIGINT COMMENT 'Foreign key linking to fulfillment.fulfillment_node. Business justification: Omnichannel promo performance reporting requires segmenting KPIs (units sold, ROI, sell-through) by fulfillment node. Retailers track whether ship-from-store vs. DC fulfillment affects promo effective',
    `merch_plan_id` BIGINT COMMENT 'Foreign key linking to merchandising.merch_plan. Business justification: Promo performance is reconciled against the merchandise financial plan to measure actual vs. planned sales, margin, and sell-through. This is a core retail analytics process — merch_plan sets the base',
    `price_list_id` BIGINT COMMENT 'Foreign key linking to pricing.price_list. Business justification: Promo performance measurement requires knowing which price list was active during the promotion to calculate baseline vs. promotional price lift and gross margin impact. This is a standard retail prom',
    `promo_calendar_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_calendar. Business justification: Performance is measured over promotional periods defined in the promotional calendar. The promo_performance has performance_week_start_date and performance_week_end_date that align with promotional ca',
    `promo_campaign_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_campaign. Business justification: Promotional performance can be measured at both campaign level and offer level. While promo_performance already has promo_offer_id (offer-level measurement), adding promo_campaign_id enables direct ca',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Performance metrics must roll up to category level for merchandising review. Category managers evaluate promotional ROI, incremental margin, and sell-through rates to inform future assortment and prom',
    `location_id` BIGINT COMMENT 'Reference to the store location where this promotion performance was measured. Supports store-level promotion analysis.',
    `promo_offer_id` BIGINT COMMENT 'Reference to the specific promotional offer or campaign being measured. Links to the promotion master definition.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Performance tracking measures promotional lift by SKU. Required for calculating incremental units, ROI, cannibalization analysis, and feeding promotional forecasts. Unlinked sku column exists but need',
    `region_id` BIGINT COMMENT 'Foreign key linking to store.region. Business justification: Regional promotional performance reporting is a core retail management process — regional directors review campaign ROI, redemption rates, and incremental units by region. promo_performance has locati',
    `rule_id` BIGINT COMMENT 'Foreign key linking to pricing.rule. Business justification: Promo performance analysis must attribute revenue lift to the specific pricing rule applied during the promotion. This link enables rule-level effectiveness reporting and supports pricing strategy opt',
    `stock_ledger_id` BIGINT COMMENT 'Foreign key linking to inventory.stock_ledger. Business justification: Post-promotion ROI analysis requires matching promotional sales performance against actual inventory movements to calculate true incremental lift, validate COGS, identify shrinkage during events, and',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Digital channel promo performance reporting: retailers measure promotional ROI by storefront (mobile app vs. desktop site vs. marketplace storefront). This link enables storefront-level promo performa',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: Promotional performance reporting validates vendor funding claims against contracted commitments. Finance teams join promo_performance to vendor_contract to reconcile vendor_funded_amount against cont',
    `vendor_scorecard_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_scorecard. Business justification: Vendor scorecard evaluation incorporates promotional performance metrics including fill rate during promos, on-time delivery for promotional inventory, and promotional ROI. Linking promo_performance t',
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

CREATE OR REPLACE TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` (
    `promo_calendar_id` BIGINT COMMENT 'Unique identifier for the promotional calendar period. Primary key for the promotional calendar master record.',
    `region_id` BIGINT COMMENT 'Foreign key linking to store.region. Business justification: Promotional calendars are region-specific — different regions have distinct blackout periods, fiscal calendars, and promotional cadences. promo_calendar.applicable_market_codes is a denormalized text ',
    `season_id` BIGINT COMMENT 'Foreign key linking to merchandising.season. Business justification: Promotional calendar periods align with merchandising seasons. Planning requires synchronized timing for new season launches, mid-season promotions, and end-of-season clearance. Critical for coordinat',
    `storefront_id` BIGINT COMMENT 'Foreign key linking to ecommerce.storefront. Business justification: Digital promotional calendar scoping: promo calendars governing digital-only events (Cyber Monday, flash sales, app-exclusive sale windows) need storefront reference for digital planning, publication ',
    `applicable_banner_codes` STRING COMMENT 'Comma-separated list of banner codes to which this promotional period applies. Populated only when banner_applicability is banner_specific.',
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

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_parent_promo_campaign_id` FOREIGN KEY (`parent_promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_promo_calendar_id` FOREIGN KEY (`promo_calendar_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_calendar`(`promo_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_promo_calendar_id` FOREIGN KEY (`promo_calendar_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_calendar`(`promo_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ADD CONSTRAINT `fk_promotion_vendor_promo_agreement_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ADD CONSTRAINT `fk_promotion_vendor_promo_agreement_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_coupon_id` FOREIGN KEY (`coupon_id`) REFERENCES `vibe_retail_v1`.`promotion`.`coupon`(`coupon_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_promo_calendar_id` FOREIGN KEY (`promo_calendar_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_calendar`(`promo_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`promotion` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_retail_v1`.`promotion` SET TAGS ('dbx_domain' = 'promotion');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` SET TAGS ('dbx_subdomain' = 'campaign_planning');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promotional Campaign ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `buyer_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Target Product Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `promo_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Calendar Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `return_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Return Policy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Campaign Budget Amount');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `campaign_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,20}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `campaign_type` SET TAGS ('dbx_value_regex' = 'seasonal|clearance|new_product_launch|loyalty|vendor_funded|flash_sale');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `channel_scope` SET TAGS ('dbx_value_regex' = 'omnichannel|in_store_only|online_only|mobile_app_only');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `discount_strategy` SET TAGS ('dbx_value_regex' = 'percentage_off|fixed_amount_off|bogo|bundle|tiered|rebate');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Campaign End Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = 'national|regional|local|store_specific');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `promo_campaign_status` SET TAGS ('dbx_business_glossary_term' = 'Campaign Status');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `promo_campaign_status` SET TAGS ('dbx_value_regex' = 'draft|scheduled|active|paused|completed|cancelled');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Campaign Start Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` SET TAGS ('dbx_subdomain' = 'campaign_planning');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promotional Offer ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `assortment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Assortment Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Cluster Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `otb_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Otb Budget Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promotional Campaign ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `carrier_service_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Carrier Service Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `return_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Return Policy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `activation_trigger` SET TAGS ('dbx_value_regex' = 'manual|cart_threshold|login|geofence|time_based|event_based');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ALTER COLUMN `channel_eligibility` SET TAGS ('dbx_value_regex' = 'POS|ecommerce|mobile|BOPIS|ROPIS|all_channels');
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
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` SET TAGS ('dbx_subdomain' = 'campaign_planning');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Issued To Profile Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion Campaign ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` SET TAGS ('dbx_subdomain' = 'campaign_planning');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `circular_ad_id` SET TAGS ('dbx_business_glossary_term' = 'Circular Advertisement ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `assortment_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Assortment Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Budget Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Cluster Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Featured Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `markdown_id` SET TAGS ('dbx_business_glossary_term' = 'Markdown Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `promo_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Calendar Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `sku_price_id` SET TAGS ('dbx_business_glossary_term' = 'Creative Asset Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `circular_type` SET TAGS ('dbx_value_regex' = 'weekly|seasonal|holiday|event|clearance|grand_opening');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = 'print|digital|email|mobile_app|social_media|in_store');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `is_vendor_funded` SET TAGS ('dbx_business_glossary_term' = 'Is Vendor Funded Flag');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Circular Notes');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `production_cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `production_status` SET TAGS ('dbx_value_regex' = 'draft|in_review|approved|in_production|published|archived');
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ALTER COLUMN `theme` SET TAGS ('dbx_business_glossary_term' = 'Circular Theme');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` SET TAGS ('dbx_subdomain' = 'vendor_agreements');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `vendor_promo_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Promotional Agreement ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `brand_id` SET TAGS ('dbx_business_glossary_term' = 'Product Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `buying_order_id` SET TAGS ('dbx_business_glossary_term' = 'Buying Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `cost_price_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Price Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` SET TAGS ('dbx_subdomain' = 'transaction_execution');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `promo_redemption_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion Redemption ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `coupon_id` SET TAGS ('dbx_business_glossary_term' = 'Coupon Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `fulfillment_order_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order Header Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `order_line_id` SET TAGS ('dbx_business_glossary_term' = 'Order Line Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `pos_terminal_id` SET TAGS ('dbx_business_glossary_term' = 'Point of Sale (POS) Terminal ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `pos_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Transaction ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `rma_id` SET TAGS ('dbx_business_glossary_term' = 'Returns Rma Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Rebate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` SET TAGS ('dbx_subdomain' = 'transaction_execution');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `promo_performance_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion Performance ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `cluster_id` SET TAGS ('dbx_business_glossary_term' = 'Cluster Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `demand_forecast_id` SET TAGS ('dbx_business_glossary_term' = 'Demand Forecast Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `format_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `fulfillment_node_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `merch_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Merch Plan Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `promo_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Calendar Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion Offer ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `rule_id` SET TAGS ('dbx_business_glossary_term' = 'Rule Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `stock_ledger_id` SET TAGS ('dbx_business_glossary_term' = 'Stock Ledger Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `vendor_scorecard_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Scorecard Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `average_transaction_value` SET TAGS ('dbx_business_glossary_term' = 'Average Transaction Value (ATV)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `channel` SET TAGS ('dbx_business_glossary_term' = 'Sales Channel');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `channel` SET TAGS ('dbx_value_regex' = 'in_store|ecommerce|mobile_app|bopis|ropis');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `cogs` SET TAGS ('dbx_business_glossary_term' = 'Cost of Goods Sold (COGS)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `data_source_system` SET TAGS ('dbx_value_regex' = 'sap_car|blue_yonder|oracle_rpm|manual_adjustment');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `forecast_accuracy_percent` SET TAGS ('dbx_business_glossary_term' = 'Forecast Accuracy Percentage');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `gross_margin_percent` SET TAGS ('dbx_business_glossary_term' = 'Gross Margin Percentage');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Performance Notes');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `performance_status` SET TAGS ('dbx_value_regex' = 'preliminary|final|adjusted|settled');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `promotional_roi` SET TAGS ('dbx_business_glossary_term' = 'Promotional Return on Investment (ROI)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `sell_through_rate` SET TAGS ('dbx_business_glossary_term' = 'Sell-Through Rate');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `sku` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,14}$');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ALTER COLUMN `units_per_transaction` SET TAGS ('dbx_business_glossary_term' = 'Units Per Transaction (UPT)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` SET TAGS ('dbx_subdomain' = 'vendor_agreements');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `promo_calendar_id` SET TAGS ('dbx_business_glossary_term' = 'Promotional Calendar ID');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `season_id` SET TAGS ('dbx_business_glossary_term' = 'Season Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `storefront_id` SET TAGS ('dbx_business_glossary_term' = 'Storefront Id (Foreign Key)');
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
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `planning_owner_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `planning_owner_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `planning_status` SET TAGS ('dbx_value_regex' = 'draft|locked|active|archived');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `priority_tier` SET TAGS ('dbx_business_glossary_term' = 'Promotional Priority Tier');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `priority_tier` SET TAGS ('dbx_value_regex' = 'tier_1_strategic|tier_2_major|tier_3_standard|tier_4_tactical');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Promotional Period Start Date');
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ALTER COLUMN `theme_description` SET TAGS ('dbx_business_glossary_term' = 'Promotional Theme Description');
