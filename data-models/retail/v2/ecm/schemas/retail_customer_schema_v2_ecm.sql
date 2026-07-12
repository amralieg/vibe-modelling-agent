-- Schema for Domain: customer | Business:  | Version: v2_ecm
-- Generated on: 2026-07-12 13:53:21

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`customer` COMMENT 'Single source of truth for all customer identity, profiles, households, segments (B2C and B2B), contact information, preferences, and RFM (Recency Frequency Monetary) analytics. Manages customer lifecycle, NPS scores, CLTV (Customer Lifetime Value), CAC (Customer Acquisition Cost), consent/privacy preferences, and omnichannel interaction history. Supports personalized clienteling and customer recognition across POS, e-commerce, and mobile.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`profile` (
    `profile_id` BIGINT COMMENT 'Unique identifier for the customer profile. Primary key for the golden customer record in the customer master data system.',
    `household_id` BIGINT COMMENT 'Identifier linking this customer to a household group for family-level analytics and shared loyalty benefits.',
    `location_id` BIGINT COMMENT 'Identifier of the customers preferred or most frequently visited store location, used for localized assortment and clienteling.',
    `acquisition_channel` STRING COMMENT 'The channel through which the customer was originally acquired, used for CAC (Customer Acquisition Cost) analysis and channel effectiveness measurement.. Valid values are `store|ecommerce|mobile_app|social_media|referral|partner`',
    `acquisition_date` DATE COMMENT 'Date when the customer first engaged with the business, marking the start of the customer lifecycle.',
    `ccpa_opt_out_date` TIMESTAMP COMMENT 'Timestamp when CCPA opt-out request was processed, required for compliance audit trails.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the customer profile record was first created in the master data management system.',
    `customer_type` STRING COMMENT 'Legal entity type: individual or organization (not role/classification). Valid values are `individual|corporate|employee|vip|wholesale`',
    `date_of_birth` DATE COMMENT 'Date of birth of the customer, used for age verification, lifecycle marketing, and personalized birthday promotions.',
    `effective_from` TIMESTAMP COMMENT 'SCD2 row effective start date',
    `effective_to` TIMESTAMP COMMENT 'SCD2 row effective end date',
    `email_address` STRING COMMENT 'Primary email address for customer communication across all channels including e-commerce, loyalty programs, and promotional campaigns.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `first_name` STRING COMMENT 'Legal first name or given name of the customer as recorded in the master data management system.',
    `full_name` STRING COMMENT 'Complete legal name of the customer, typically concatenated from first, middle, and last name components.',
    `gdpr_consent_date` TIMESTAMP COMMENT 'Timestamp when GDPR consent was granted by the customer, required for compliance audit trails.',
    `gender` STRING COMMENT 'Self-identified gender of the customer, used for personalized merchandising and assortment planning.. Valid values are `male|female|non_binary|prefer_not_to_say|other|unknown`',
    `is_current` BOOLEAN COMMENT 'SCD2 flag indicating current active record',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to any attribute in the customer profile record.',
    `last_name` STRING COMMENT 'Legal last name or family name of the customer as recorded in the master data management system.',
    `lifecycle_stage` STRING COMMENT 'Current stage in the customer lifecycle journey, used for targeted marketing campaigns and retention strategies. [ENUM-REF-CANDIDATE: prospect|new|active|at_risk|dormant|churned|reactivated — 7 candidates stripped; promote to reference product]',
    `loyalty_tier` STRING COMMENT 'Current tier level in the loyalty program, determining benefits, discounts, and personalized services.. Valid values are `bronze|silver|gold|platinum|diamond`',
    `mdm_confidence_score` DECIMAL(18,2) COMMENT 'Confidence score (0-100) from the customer master data system indicating the quality and reliability of the golden record match and data completeness.',
    `mdm_last_match_date` TIMESTAMP COMMENT 'Timestamp of the last MDM matching and survivorship process execution that updated this golden record.',
    `mdm_source_system` STRING COMMENT 'Name of the primary source system that contributed the authoritative data for this golden record (e.g., the retail analytics platform, the e-commerce platform, POS).',
    `middle_name` STRING COMMENT 'Middle name or initial of the customer. Nullable field for customers without a middle name.',
    `mobile_number` STRING COMMENT 'Mobile phone number used for SMS notifications, mobile app authentication, and last-mile delivery coordination.',
    `nationality` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the customers nationality or citizenship.. Valid values are `^[A-Z]{3}$`',
    `phone_number` STRING COMMENT 'Primary contact phone number for customer service, order notifications, and BOPIS (Buy Online Pick Up In Store) communications.',
    `preferred_contact_method` STRING COMMENT 'Customers preferred method for receiving communications and notifications from the business.. Valid values are `email|phone|sms|mail|none`',
    `preferred_language` STRING COMMENT 'ISO 639-2 three-letter language code representing the customers preferred language for communication and marketing materials.. Valid values are `^[A-Z]{3}$`',
    `profile_status` STRING COMMENT 'Current operational status of the customer profile, controlling access to services and transactions across all channels.. Valid values are `active|inactive|suspended|blocked|closed`',
    `row_hash` STRING COMMENT 'Hash of tracked columns for change detection',
    `effective_start_date` TIMESTAMP COMMENT '',
    `effective_end_date` TIMESTAMP COMMENT '',
    CONSTRAINT pk_profile PRIMARY KEY(`profile_id`)
) COMMENT 'Golden record for every customer (B2C and B2B) served by Retail. Stores core identity attributes sourced from the customer master data system including full legal name, date of birth, gender, preferred language, nationality, customer type (individual/corporate), acquisition channel, CAC, CLTV score, NPS score, lifecycle stage, privacy consent flags (GDPR/CCPA), and golden-record confidence score. This is the single authoritative master entity for all customer identity data across POS, e-commerce, and mobile channels.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`account` (
    `account_id` BIGINT COMMENT 'Unique identifier for the account. Primary key.',
    `associate_id` BIGINT COMMENT 'Reference to the employee assigned as the dedicated account manager for this account (typically for high-value B2B or VIP accounts). Null for standard consumer accounts without dedicated management.',
    `address_id` BIGINT COMMENT 'Reference to the default billing address for this account. Used for invoicing, credit checks, and payment processing. Null if no billing address on file.',
    `location_id` BIGINT COMMENT 'Reference to the customers preferred or home store location for in-store pickup, returns, and personalized store-based services. Null if no preference set.',
    `price_list_id` BIGINT COMMENT 'Foreign key linking to pricing.price_list. Business justification: B2B and corporate accounts require contract-specific pricing (volume discounts, negotiated rates, special terms). Account managers assign custom price lists during contract setup. Essential for wholes',
    `profile_id` BIGINT COMMENT 'Reference to the customer profile who owns this account. One customer may have multiple accounts (e.g., personal and business).',
    `shipping_address_id` BIGINT COMMENT 'Reference to the default shipping address for this account. Used for order fulfillment and delivery. Null if no default shipping address set.',
    `payment_method_id` BIGINT COMMENT 'Reference to the customers default payment method for this account (e.g., credit card on file, bank account). Null if no default set. Used for one-click checkout and recurring billing.',
    `account_number` STRING COMMENT 'Externally-visible unique account number used for customer communication, statements, and customer service lookup. Distinct from internal account_id.. Valid values are `^[A-Z0-9]{8,20}$`',
    `account_status` STRING COMMENT 'Current lifecycle state of the account. Active accounts can transact; suspended accounts are temporarily blocked; closed accounts are permanently terminated; pending_activation awaits customer verification; frozen accounts are under investigation; dormant accounts have no recent activity.. Valid values are `active|suspended|closed|pending_activation|frozen|dormant`',
    `account_type` STRING COMMENT 'Classification of the account indicating the nature of the commercial relationship: personal (B2C consumer), business (B2B corporate), employee (staff discount account), or wholesale (bulk buyer).. Valid values are `personal|business|employee|wholesale`',
    `b2b_pricing_flag` BOOLEAN COMMENT 'Indicates whether this account receives B2B contract pricing instead of standard retail pricing. True for wholesale and corporate accounts; false for consumer accounts.',
    `close_date` DATE COMMENT 'Date when the account was permanently closed. Null for active accounts. Used for churn analysis and account lifecycle reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this account record was first created in the system. Used for audit trail and data lineage tracking.',
    `credit_limit` DECIMAL(18,2) COMMENT 'Maximum credit amount (in base currency) extended to this account for deferred payment or credit purchases. Null for cash-only accounts. Used for credit management and risk assessment.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the accounts base currency (e.g., USD, EUR, GBP). All monetary transactions and balances for this account are denominated in this currency.. Valid values are `^[A-Z]{3}$`',
    `effective_from` TIMESTAMP COMMENT 'SCD2 row effective start date',
    `effective_to` TIMESTAMP COMMENT 'SCD2 row effective end date',
    `employee_discount_eligible` BOOLEAN COMMENT 'Indicates whether this account is eligible for employee discount pricing. True for employee accounts and authorized family members; false otherwise.',
    `is_current` BOOLEAN COMMENT 'SCD2 flag indicating current active record',
    `loyalty_program_enrolled` BOOLEAN COMMENT 'Indicates whether this account is enrolled in the retailers loyalty or rewards program. True if enrolled; false otherwise. Used for loyalty analytics and targeted promotions.',
    `notes` STRING COMMENT 'Free-text field for internal notes about the account (e.g., special handling instructions, VIP preferences, service history, escalation notes). Used by customer service and account management teams.',
    `open_date` DATE COMMENT 'Date when the account was first opened and activated. Used for account age calculations, tenure-based benefits, and lifecycle analytics.',
    `preferred_channel` STRING COMMENT 'Customers preferred interaction channel for shopping and service. Used for omnichannel routing, personalized marketing, and channel-specific offers.. Valid values are `in_store|online|mobile_app|call_center`',
    `row_hash` STRING COMMENT 'Hash of tracked columns for change detection',
    `suspension_date` DATE COMMENT 'Date when the account was most recently suspended. Null if never suspended or currently active. Used for compliance and risk management reporting.',
    `suspension_reason` STRING COMMENT 'Free-text explanation of why the account was suspended (e.g., payment default, fraud investigation, customer request, policy violation). Null if never suspended.',
    `tax_exempt_certificate_number` STRING COMMENT 'Government-issued tax exemption certificate number for tax-exempt accounts. Null for non-exempt accounts. Required for audit and compliance verification.',
    `tax_exempt_expiry_date` DATE COMMENT 'Expiration date of the tax exemption certificate. Null for non-exempt accounts or perpetual exemptions. Used for compliance monitoring and renewal reminders.',
    `tax_exempt_flag` BOOLEAN COMMENT 'Indicates whether this account is exempt from sales tax (e.g., non-profit organizations, government entities, resellers with valid tax exemption certificates). True if exempt; false otherwise.',
    `tier` STRING COMMENT 'Service tier or membership level of the account, determining benefits, discounts, and service priority. Standard is base tier; premium, VIP, and platinum offer escalating benefits.. Valid values are `standard|premium|vip|platinum`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this account record was last modified. Used for audit trail, change tracking, and data synchronization.',
    `effective_start_date` TIMESTAMP COMMENT '',
    `effective_end_date` TIMESTAMP COMMENT '',
    CONSTRAINT pk_account PRIMARY KEY(`account_id`)
) COMMENT 'Commercial relationship record between a customer and Retail, distinct from profile (identity). Tracks account number, status (active/suspended/closed), open date, tier (standard/premium/VIP), credit limit, preferred store, preferred channel (in-store/online/mobile), default payment method reference, and account-level flags (employee discount eligibility, tax-exempt status, B2B pricing flag). One profile may have multiple accounts (e.g., personal + business). Supports account-level reporting, credit management, and omnichannel preference routing.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`household` (
    `household_id` BIGINT COMMENT 'Unique identifier for the household unit. Primary key for the household entity.',
    `location_id` BIGINT COMMENT 'Reference to the store location most frequently visited by household members. Used for localized promotions and inventory planning.',
    `profile_id` BIGINT COMMENT 'Reference to the primary customer profile within the household. This member typically represents the household in loyalty programs and receives primary communications.',
    `address_line_1` STRING COMMENT 'Primary street address of the household. Used for delivery, geo-targeting, and household matching.',
    `address_line_2` STRING COMMENT 'Secondary address information (apartment, suite, unit number). Optional field for household address.',
    `average_basket_value` DECIMAL(18,2) COMMENT 'Average transaction value (ATV) across all household purchases. Used for household-level pricing and promotion strategies.',
    `city` STRING COMMENT 'City or municipality of the household address. Used for regional marketing and store assignment.',
    `combined_cltv` DECIMAL(18,2) COMMENT 'Aggregated Customer Lifetime Value across all household members. Represents the total predicted revenue from the household over its lifetime. Used for household-level loyalty tier assignment and VIP treatment.',
    `communication_preference` STRING COMMENT 'Preferred method for household-level marketing communications. Honors consent and privacy preferences.. Valid values are `email|sms|mail|phone|none`',
    `country_code` STRING COMMENT 'Three-letter ISO country code of the household address (e.g., USA, CAN, MEX). Used for international operations and compliance.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the household record was first created in the system. Used for audit and data lineage.',
    `data_sharing_consent` BOOLEAN COMMENT 'Indicates whether the household has consented to sharing data with third-party partners. True if consented, False otherwise.',
    `estimated_income_band` STRING COMMENT 'Estimated annual household income range. Derived from third-party data enrichment or modeled from purchase behavior. Used for targeted marketing and assortment planning.. Valid values are `under_25k|25k_50k|50k_75k|75k_100k|100k_150k|over_150k`',
    `external_household_code` STRING COMMENT 'Household identifier from the source system or external partner. Used for cross-system reconciliation and data integration.',
    `household_status` STRING COMMENT 'Current lifecycle status of the household record. Active households are eligible for household-level promotions and loyalty benefits.. Valid values are `active|inactive|merged|split|pending`',
    `household_type` STRING COMMENT 'Classification of the household structure. Used for targeted marketing and assortment planning.. Valid values are `single_person|nuclear_family|extended_family|multi_generational|shared_residence|other`',
    `last_purchase_date` DATE COMMENT 'Date of the most recent purchase made by any household member. Used for recency analysis in RFM (Recency Frequency Monetary) segmentation.',
    `loyalty_tier` STRING COMMENT 'Household-level loyalty program tier based on combined spending and engagement. Determines household-level benefits and promotions.. Valid values are `bronze|silver|gold|platinum|vip`',
    `marketing_opt_in` BOOLEAN COMMENT 'Indicates whether the household has consented to receive marketing communications. True if opted in, False otherwise.',
    `household_name` STRING COMMENT 'Human-readable name or label for the household (e.g., Smith Family, Johnson Household). Used for clienteling and personalized marketing.',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the household address. Critical for delivery routing, geo-analytics, and demographic segmentation.',
    `preferred_channel` STRING COMMENT 'Primary shopping channel used by the household. Supports omnichannel personalization and channel-specific promotions.. Valid values are `in_store|online|mobile_app|call_center`',
    `primary_language` STRING COMMENT 'Two-letter ISO language code representing the households preferred language for communications (e.g., en, es, fr). Used for localized marketing and customer service.. Valid values are `^[a-z]{2}$`',
    `segment` STRING COMMENT 'Marketing or behavioral segment assigned to the household based on RFM (Recency Frequency Monetary) analysis, purchase patterns, and demographics. Used for targeted campaigns.',
    `size` STRING COMMENT 'Number of individual members in the household. Used for basket size prediction and household-level promotions.',
    `state_province` STRING COMMENT 'State, province, or region of the household address. Used for tax calculation and regional compliance.',
    `total_loyalty_points` STRING COMMENT 'Aggregated loyalty points balance across all household members. Used for household-level redemption and rewards.',
    `total_purchase_count` STRING COMMENT 'Total number of transactions made by all household members. Used for frequency analysis in RFM (Recency Frequency Monetary) segmentation.',
    `total_spend_amount` DECIMAL(18,2) COMMENT 'Cumulative monetary value of all purchases made by household members. Used for monetary analysis in RFM (Recency Frequency Monetary) segmentation.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the household record was last modified. Used for audit and change tracking.',
    CONSTRAINT pk_household PRIMARY KEY(`household_id`)
) COMMENT 'Groups individual customer profiles into a household unit for B2C clienteling, basket analysis, and loyalty aggregation. Stores household identifier, household name, primary member profile reference, household address, estimated household income band, household size, and combined CLTV. Enables Retail to recognize family purchasing patterns, apply household-level promotions, and support omnichannel personalization across all household members.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`corporate_account` (
    `corporate_account_id` BIGINT COMMENT 'Unique identifier for the B2B corporate customer account. Primary key for the corporate account entity.',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: B2B corporate accounts require dedicated account managers (sales reps or account executives) who handle contract negotiations, pricing agreements, credit terms, and ongoing relationship management. Es',
    `address_id` BIGINT COMMENT 'FK to customer.address',
    `account_id` BIGINT COMMENT 'Reference to the parent corporate account if this account is part of a multi-location or subsidiary hierarchy. Null for standalone accounts or top-level parent accounts. Enables consolidated billing and enterprise-wide reporting.',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: Corporate accounts have a designated primary contact person. Currently, corporate_account stores primary_contact_name, primary_contact_email, primary_contact_phone as denormalized columns. Adding prim',
    `shipping_address_id` BIGINT COMMENT 'FK to customer.address',
    `account_established_date` DATE COMMENT 'Date when the corporate account was first created in the system. Used to calculate customer tenure and lifetime value metrics.',
    `annual_spend_tier` STRING COMMENT 'Classification of the corporate account based on annual purchase volume. Used to determine discount levels, service priority, and account management resources. Tier_1 = highest spend (>$1M), Tier_5 = lowest spend (<$10K). Tiers recalculated annually.. Valid values are `tier_1|tier_2|tier_3|tier_4|tier_5`',
    `business_entity_type` STRING COMMENT 'Legal structure of the corporate entity. Values: sole_proprietorship, partnership, llc (Limited Liability Company), corporation (C-Corp), s_corp (S-Corporation), non_profit (501c3 or similar), government (public sector entity). [ENUM-REF-CANDIDATE: sole_proprietorship|partnership|llc|corporation|s_corp|non_profit|government — 7 candidates stripped; promote to reference product]',
    `contract_pricing_flag` BOOLEAN COMMENT 'Indicates whether the corporate account has negotiated contract pricing that overrides standard catalog prices. True = custom pricing agreement in place; False = standard pricing applies.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this corporate account record was first created in the database. Used for audit trail and data lineage tracking.',
    `credit_limit` DECIMAL(18,2) COMMENT 'Maximum outstanding balance allowed for the corporate account before requiring payment or credit hold. Expressed in USD. Null if account is cash-only.',
    `credit_status` STRING COMMENT 'Current credit approval status for the corporate account. Determines whether the customer can purchase on credit terms. Values: approved (credit line active), pending (application submitted), declined (credit denied), under_review (periodic credit review in progress), suspended (credit privileges temporarily revoked).. Valid values are `approved|pending|declined|under_review|suspended`',
    `dba_name` STRING COMMENT 'Trade name or fictitious business name under which the corporate customer operates, if different from legal name. Used for marketing and customer-facing communications.',
    `duns_number` STRING COMMENT 'Nine-digit unique identifier assigned by Dun & Bradstreet to establish business credit profile and track commercial credit history. Used for supplier onboarding and credit evaluation.. Valid values are `^[0-9]{9}$`',
    `industry_classification_naics` STRING COMMENT 'Six-digit code classifying the corporate customers primary industry using the NAICS standard. Provides more granular industry segmentation than SIC for modern business categories.. Valid values are `^[0-9]{6}$`',
    `industry_classification_sic` STRING COMMENT 'Four-digit code classifying the corporate customers primary industry sector using the U.S. Standard Industrial Classification system. Used for market segmentation and industry analysis.. Valid values are `^[0-9]{4}$`',
    `last_order_date` DATE COMMENT 'Date of the most recent purchase order placed by this corporate account. Used for recency analysis and dormant account identification.',
    `legal_business_name` STRING COMMENT 'The official registered legal name of the corporate entity as it appears on government filings and tax documents. Used for contracts, invoicing, and legal compliance.',
    `payment_terms` STRING COMMENT 'Standard payment terms negotiated with the corporate customer. Values: net_30 (payment due 30 days after invoice), net_45, net_60, net_90, due_on_receipt (immediate payment), prepay (payment before shipment), custom (non-standard terms documented separately). [ENUM-REF-CANDIDATE: net_30|net_45|net_60|net_90|due_on_receipt|prepay|custom — 7 candidates stripped; promote to reference product]',
    `preferred_delivery_method` STRING COMMENT 'Default shipping method preference for corporate orders. Values: standard_ground, expedited, next_day, freight (for large/bulk orders), customer_pickup (will-call).. Valid values are `standard_ground|expedited|next_day|freight|customer_pickup`',
    `tax_exempt_certificate_number` STRING COMMENT 'Government-issued tax exemption certificate number. Required for tax-exempt accounts to validate exemption status during order processing and audits.',
    `tax_exempt_flag` BOOLEAN COMMENT 'Indicates whether the corporate account is exempt from sales tax (e.g., government entities, non-profits with valid exemption certificates). True = tax exempt; False = taxable.',
    `tax_identifier` STRING COMMENT 'Federal tax identification number (EIN) assigned by the IRS for business tax reporting and compliance. Format: XX-XXXXXXX.. Valid values are `^[0-9]{2}-[0-9]{7}$`',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp when this corporate account record was last modified. Used for change tracking and data synchronization across systems.',
    CONSTRAINT pk_corporate_account PRIMARY KEY(`corporate_account_id`)
) COMMENT 'B2B corporate customer entity representing business clients such as small businesses, restaurants, and institutional buyers purchasing from Retail. Stores legal business name, tax ID / EIN, DUNS number, industry classification (SIC/NAICS), credit terms, assigned account manager, annual spend tier, contract pricing flag, and parent-subsidiary hierarchy reference. Supports B2B procurement workflows distinct from B2C consumer accounts.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`contact` (
    `contact_id` BIGINT COMMENT 'Unique identifier for the contact method record. Primary key.',
    `profile_id` BIGINT COMMENT 'Reference to the customer profile or corporate account that owns this contact method. Links to the customer master record in the customer master data system.',
    `bounce_count` STRING COMMENT 'The cumulative number of times communication attempts via this contact method have bounced or failed. Used to trigger contact validation workflows and suppress invalid addresses.',
    `consent_source` STRING COMMENT 'The channel or touchpoint where the customer provided consent for this contact method (e.g., web registration, mobile app, POS, call center, in-store signup). Supports consent audit trails. [ENUM-REF-CANDIDATE: web|mobile_app|pos|call_center|email|in_store|third_party — 7 candidates stripped; promote to reference product]',
    `contact_status` STRING COMMENT 'Current lifecycle status of the contact method. Active indicates usable for communication; bounced/invalid indicates delivery failure; suppressed indicates customer request or compliance block; pending_verification indicates awaiting confirmation.. Valid values are `active|inactive|bounced|invalid|suppressed|pending_verification`',
    `contact_type` STRING COMMENT 'The type or category of contact method (e.g., primary email, mobile phone, work phone, WhatsApp, SMS, fax). Determines the channel and priority for omnichannel outreach. [ENUM-REF-CANDIDATE: primary_email|secondary_email|mobile|home_phone|work_phone|whatsapp|sms|fax — 8 candidates stripped; promote to reference product]',
    `country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code indicating the country associated with this contact method (e.g., USA, GBR, CAN). Used for regional compliance and localization of communications.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this contact method record was first created in the system. Supports audit trails and data lineage.',
    `effective_end_date` DATE COMMENT 'The date when this contact method ceased to be active or valid. Nullable for currently active contact methods. Supports temporal tracking and historical analysis.',
    `effective_start_date` DATE COMMENT 'The date from which this contact method became active and valid for customer communication. Supports temporal tracking and historical analysis.',
    `is_primary` BOOLEAN COMMENT 'Boolean flag indicating whether this is the primary contact method for the customer. Used to prioritize communication channels in omnichannel campaigns and clienteling.',
    `is_verified` BOOLEAN COMMENT 'Boolean flag indicating whether the contact method has been verified (e.g., email verification link clicked, phone number confirmed via OTP). Ensures data quality for marketing and transactional communications.',
    `language_preference` STRING COMMENT 'Two-letter ISO 639-1 language code indicating the customers preferred language for communications via this contact method (e.g., en, es, fr). Supports personalized omnichannel outreach.. Valid values are `^[a-z]{2}$`',
    `last_bounce_date` DATE COMMENT 'The date of the most recent bounce or delivery failure for this contact method. Nullable if no bounces have occurred.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this contact method record was last updated. Supports change tracking and audit trails.',
    `last_used_date` DATE COMMENT 'The date when this contact method was last successfully used for customer communication (email sent, SMS delivered, call completed). Helps identify stale or inactive contact points.',
    `priority_rank` STRING COMMENT 'Numeric ranking indicating the priority order of this contact method relative to other contact methods for the same customer. Lower numbers indicate higher priority. Used for fallback logic in omnichannel campaigns.',
    `source_system_code` STRING COMMENT 'The unique identifier for this contact method in the source system. Enables traceability and cross-system reconciliation.',
    `value` DECIMAL(18,2) COMMENT 'The actual contact point value: email address, phone number, or social media handle. This is the primary data element used for customer communication and CRM campaigns via the case management system. Classified as restricted PII as it may contain email, phone, or other personal identifiers.',
    `verification_date` DATE COMMENT 'The date when the contact method was last verified by the customer. Used to track data freshness and trigger re-verification workflows.',
    CONSTRAINT pk_contact PRIMARY KEY(`contact_id`)
) COMMENT 'Stores all contact points for a customer profile or corporate account including email addresses, phone numbers, and social handles. Each row represents a single contact method with type (primary email, mobile, work phone, WhatsApp), verification status, opt-in/opt-out flags per channel, verification date, and source system. Supports omnichannel outreach, CRM campaigns via the case management system, and GDPR/CCPA consent enforcement at the contact-method level.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`address` (
    `address_id` BIGINT COMMENT 'Unique identifier for the address record. Primary key.',
    `profile_id` BIGINT COMMENT 'Reference to the customer or corporate account associated with this address.',
    `address_status` STRING COMMENT 'Current lifecycle status of the address record. Active addresses are available for use in orders and shipments.. Valid values are `active|inactive|archived|pending_verification`',
    `address_type` STRING COMMENT 'Classification of the address purpose: billing, shipping, store pickup (BOPIS/ROPIS), home, work, or mailing.. Valid values are `billing|shipping|home|work|store_pickup|mailing`',
    `city` STRING COMMENT 'City or municipality name for the address.',
    `country_code` STRING COMMENT 'Three-letter ISO country code (e.g., USA, CAN, GBR) identifying the country of the address.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the address record was first created in the system.',
    `delivery_instructions` STRING COMMENT 'Special delivery instructions provided by the customer (e.g., gate code, leave at door, ring bell).',
    `delivery_point_barcode` STRING COMMENT 'USPS Delivery Point Barcode (DPBC) or equivalent postal barcode for automated mail sorting and delivery.',
    `effective_from_date` DATE COMMENT 'Date from which this address becomes active and valid for use in transactions.',
    `effective_to_date` DATE COMMENT 'Date until which this address remains active. Null indicates the address is currently active with no end date.',
    `is_default_billing` BOOLEAN COMMENT 'Flag indicating whether this address is the default billing address for the customer.',
    `is_default_shipping` BOOLEAN COMMENT 'Flag indicating whether this address is the default shipping destination for the customer.',
    `last_used_date` DATE COMMENT 'Date when this address was last used in a transaction (order, shipment, or billing event).',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate in decimal degrees for geolocation and last-mile delivery optimization.',
    `line_1` STRING COMMENT 'Primary street address line including street number, street name, and unit/apartment number.',
    `line_2` STRING COMMENT 'Secondary address line for additional location details such as building name, floor, suite, or department.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate in decimal degrees for geolocation and last-mile delivery optimization.',
    `military_address_flag` BOOLEAN COMMENT 'Indicates whether the address is a military address (APO/FPO/DPO). Requires special handling for international military mail.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the address record was last modified or updated.',
    `nickname` STRING COMMENT 'Customer-provided friendly name for the address (e.g., Home, Office, Moms House) for easy identification.',
    `po_box_flag` BOOLEAN COMMENT 'Indicates whether the address is a PO Box. Some carriers and products cannot deliver to PO Boxes.',
    `postal_code` STRING COMMENT 'Postal code, ZIP code, or postcode for the address. Used for delivery routing and tax jurisdiction determination.',
    `residential_flag` BOOLEAN COMMENT 'Indicates whether the address is a residential location (true) or commercial/business location (false). Impacts shipping rates and delivery windows.',
    `standardization_flag` BOOLEAN COMMENT 'Indicates whether the address has been standardized to postal service formatting rules (USPS Publication 28, etc.).',
    `state_province` STRING COMMENT 'State, province, or region code or name. For US addresses, use two-letter state abbreviation (e.g., CA, NY).',
    `tax_jurisdiction_code` STRING COMMENT 'Tax jurisdiction identifier derived from the address, used to determine applicable sales tax rates and rules.',
    `validation_status` STRING COMMENT 'Status of address validation against postal service standards (USPS, Canada Post, etc.). Validated addresses reduce delivery failures.. Valid values are `validated|unvalidated|invalid|pending`',
    `verification_timestamp` TIMESTAMP COMMENT 'Timestamp when the address was last verified against postal service databases or address validation services.',
    CONSTRAINT pk_address PRIMARY KEY(`address_id`)
) COMMENT 'Physical and mailing addresses associated with a customer profile or corporate account. Stores address type (billing, shipping, store pickup, home, work), full address lines, city, state/province, postal code, country, geocoordinates (lat/lng), address validation status, USPS/postal standardization flag, and default shipping flag. Critical for last-mile delivery, BOPIS/ROPIS fulfillment, and tax jurisdiction determination.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`preference` (
    `preference_id` BIGINT COMMENT 'Unique identifier for the customer preference record. Primary key.',
    `effective_from` TIMESTAMP COMMENT 'SCD2 row effective start date',
    `effective_to` TIMESTAMP COMMENT 'SCD2 row effective end date',
    `is_current` BOOLEAN COMMENT 'SCD2 flag indicating current active record',
    `row_hash` STRING COMMENT 'Hash of tracked columns for change detection',
    CONSTRAINT pk_preference PRIMARY KEY(`preference_id`)
) COMMENT 'Captures customer-declared and inferred preferences for personalization across all Retail channels. Stores preference category (communication channel, product category affinity, dietary restriction, brand preference, store preference, language, notification frequency), preference value, preference source (self-declared/behavioral/inferred), confidence level, and last updated timestamp. Feeds the e-commerce platform personalization engine and in-store clienteling tools.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`identity_link` (
    `identity_link_id` BIGINT COMMENT 'Unique identifier for the identity link record. Primary key for the identity resolution table.',
    `profile_id` BIGINT COMMENT 'Reference to the golden customer record (master profile) in the Customer domain that this identifier is linked to. This is the single source of truth customer identity.',
    `channel` STRING COMMENT 'The customer interaction channel where this identifier is primarily used. Supports omnichannel customer recognition and journey analytics.. Valid values are `in_store|online|mobile|call_center|social_media`',
    `consent_status` STRING COMMENT 'The customer consent status for using this identifier for marketing, personalization, or cross-channel tracking. Critical for GDPR and CCPA compliance.. Valid values are `granted|denied|pending|withdrawn|expired`',
    `consent_timestamp` TIMESTAMP COMMENT 'The date and time when the customer provided or updated their consent for this identifier. Required for regulatory audit trails. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `data_quality_score` DECIMAL(18,2) COMMENT 'Numeric score (0.0000 to 1.0000) representing the overall quality and reliability of this identifier based on completeness, accuracy, consistency, and timeliness dimensions.',
    `identifier_first_seen_date` DATE COMMENT 'The date when this specific identifier value was first observed in any source system. Used for recency analysis in RFM (Recency Frequency Monetary) segmentation. Format: yyyy-MM-dd.',
    `identifier_last_seen_date` DATE COMMENT 'The date when this identifier was most recently used in a transaction or interaction. Critical for identifying dormant identifiers. Format: yyyy-MM-dd.',
    `identifier_type` STRING COMMENT 'The category or type of identifier being linked. Examples include loyalty card number, email hash, device ID, cookie ID, POS customer ID, the e-commerce platform, SAP customer number. [ENUM-REF-CANDIDATE: loyalty_card|email_hash|device_id|cookie_id|pos_customer_id|salesforce_contact_id|sap_customer_number|mobile_app_id|web_account_id|third_party_id — promote to reference product]',
    `identifier_usage_count` STRING COMMENT 'The total number of times this identifier has been used across all channels and transactions. Helps assess identifier reliability and customer engagement.',
    `identifier_value` DECIMAL(18,2) COMMENT 'The actual identifier value (e.g., loyalty card number 123456789, email hash abc123def, device UUID). This is the raw identifier string from the source system.',
    `is_primary_identifier` BOOLEAN COMMENT 'Boolean flag indicating whether this is the primary or preferred identifier for this customer. True if this is the main identifier used for customer recognition, False otherwise.',
    `link_confidence_score` DECIMAL(18,2) COMMENT 'Numeric confidence score (0.0000 to 1.0000) indicating the certainty of the identity link. Deterministic matches typically score 1.0000, while probabilistic matches score lower based on matching algorithm confidence.',
    `link_created_timestamp` TIMESTAMP COMMENT 'The date and time when this identity link was first established in the MDM system. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `link_effective_from_date` DATE COMMENT 'The date from which this identity link is considered valid and active for customer recognition across channels. Format: yyyy-MM-dd.',
    `link_effective_to_date` DATE COMMENT 'The date until which this identity link remains valid. Null indicates an open-ended link. Format: yyyy-MM-dd.',
    `link_method` STRING COMMENT 'The methodology used to establish the identity link. Deterministic uses exact matching rules (e.g., same email), probabilistic uses statistical algorithms, manual indicates human review, third-party indicates external data provider.. Valid values are `deterministic|probabilistic|manual|third_party`',
    `link_notes` STRING COMMENT 'Free-text notes or comments about this identity link, typically used for manual review cases or to document special circumstances in the linking decision.',
    `link_status` STRING COMMENT 'Current lifecycle status of the identity link. Active links are used for customer recognition, inactive links are deprecated, pending_review requires manual validation, rejected links failed validation, superseded links have been replaced by newer links.. Valid values are `active|inactive|pending_review|rejected|superseded`',
    `link_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this identity link was last modified or re-validated. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `linked_by_user` STRING COMMENT 'The username or system identifier of the user or process that created this identity link. Used for audit and accountability purposes.',
    `match_attributes` STRING COMMENT 'Comma-separated list of attributes that were used in the matching process (e.g., email, phone, postal_code). Provides transparency into the matching logic.',
    `merge_history_reference` STRING COMMENT 'Reference identifier to the merge/split history log if this link was affected by customer profile merges or splits. Supports audit trail and rollback scenarios.',
    `validation_status` STRING COMMENT 'Indicates whether this identifier has been validated through external verification (e.g., email verification, phone verification). Validated identifiers have higher trust scores.. Valid values are `validated|unvalidated|failed|pending`',
    `validation_timestamp` TIMESTAMP COMMENT 'The date and time when this identifier was last validated. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    CONSTRAINT pk_identity_link PRIMARY KEY(`identity_link_id`)
) COMMENT 'Cross-channel identity resolution table managed by the customer master data system that links a single customer golden record (profile) to all their known identifiers across systems. Stores identifier type (loyalty card number, email hash, device ID, cookie ID, POS customer ID, the e-commerce platform, SAP customer number), identifier value, source system, link confidence score, link method (deterministic/probabilistic), and link creation timestamp. Enables omnichannel recognition across POS, e-commerce, and mobile.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`interaction` (
    `interaction_id` BIGINT COMMENT 'Unique identifier for the customer interaction event. Primary key.',
    `campaign_id` BIGINT COMMENT 'Identifier of the marketing campaign or promotion associated with this interaction, if applicable. Null for non-campaign interactions.',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Customer interactions (browsing, inquiries, service cases) often category-specific. Enables category engagement analytics, service case routing to category-expert associates, and category-level custom',
    `email_send_id` BIGINT COMMENT 'Foreign key linking to marketing.email_send. Business justification: Customer interactions (email opens, clicks, unsubscribes) must link to specific email sends for campaign performance measurement, deliverability analysis, and customer engagement scoring. New FK requi',
    `header_id` BIGINT COMMENT 'Identifier of the order associated with this interaction, if applicable. Links to the order record. Null for non-order-related interactions.',
    `location_id` BIGINT COMMENT 'Identifier of the physical store location where the interaction occurred. Applicable for in-store interactions (POS visit, clienteling visit, in-store event). Null for digital interactions.',
    `pos_transaction_id` BIGINT COMMENT 'Identifier of the POS transaction associated with this interaction, if applicable. Links to the POS transaction record. Null for non-transaction interactions.',
    `associate_id` BIGINT COMMENT 'Identifier of the call center or customer service agent who handled this interaction. Applicable for call center contacts, live chat, and service cases. Null for non-agent-assisted interactions.',
    `profile_id` BIGINT COMMENT 'Identifier of the customer who participated in this interaction. Links to the customer master record.',
    `promo_offer_id` BIGINT COMMENT 'Identifier of the specific promotion or offer presented or redeemed during this interaction, if applicable. Null if no promotion was involved.',
    `rma_id` BIGINT COMMENT 'Foreign key linking to returns.rma. Business justification: Customer service interactions frequently reference specific RMAs for context, case resolution tracking, and audit trail. Service agents need to view return authorization details during calls, chats, a',
    `service_case_id` BIGINT COMMENT 'Identifier of the customer service case or ticket associated with this interaction, if applicable. Links to the service case record. Null for non-case interactions.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Customer interactions (product inquiries, reviews, complaints, browsing) reference specific SKUs. Service case resolution, product feedback analysis, and engagement tracking require linking interactio',
    `web_session_id` BIGINT COMMENT 'Unique identifier for the digital session (web or mobile app) during which this interaction occurred. Applicable for website sessions and mobile app sessions. Null for non-session-based interactions.',
    `browser` STRING COMMENT 'The web browser used by the customer during this interaction (e.g., Chrome, Safari, Firefox, Edge). Applicable for web-based interactions. Null for non-web interactions.',
    `channel` STRING COMMENT 'The channel or medium through which the interaction occurred (e.g., store, web, mobile app, call center, email, SMS, push notification, social media, kiosk). [ENUM-REF-CANDIDATE: store|web|mobile_app|call_center|email|sms|push|social_media|kiosk|chat|video — promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this interaction record was first created in the data platform. Audit field for data lineage and compliance.',
    `delivery_status` STRING COMMENT 'The delivery and engagement status for outbound communication interactions (email, SMS, push notification). Indicates whether the message was delivered, opened, clicked, bounced, or failed. Null for inbound or non-message interactions.. Valid values are `delivered|opened|clicked|bounced|failed|pending`',
    `device_type` STRING COMMENT 'The type of device used by the customer during this interaction (e.g., desktop, mobile, tablet, kiosk, POS terminal). Applicable for digital and in-store interactions. Null if device type is unknown.. Valid values are `desktop|mobile|tablet|kiosk|pos_terminal|other`',
    `digital_property` STRING COMMENT 'The specific digital asset or platform where the interaction occurred (e.g., main website, mobile app, partner site, social media platform name). Applicable for digital interactions. Null for in-store interactions.',
    `direction` STRING COMMENT 'Indicates whether the interaction was initiated by the customer (inbound) or by Retail (outbound).. Valid values are `inbound|outbound`',
    `duration_seconds` STRING COMMENT 'The length of the interaction in seconds. Applicable for sessions, calls, chats, and visits. Null for instantaneous events (e.g., email send, SMS send).',
    `email_clicked_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the customer clicked a link within an outbound email. Applicable only for email interactions. Null for non-email interactions.',
    `email_opened_flag` BOOLEAN COMMENT 'Boolean flag indicating whether an outbound email was opened by the customer. Applicable only for email interactions. Null for non-email interactions.',
    `geolocation_latitude` DECIMAL(18,2) COMMENT 'The latitude coordinate of the customer location at the time of this interaction, if available. Applicable for mobile app interactions with location services enabled. Null if location data is unavailable.',
    `geolocation_longitude` DECIMAL(18,2) COMMENT 'The longitude coordinate of the customer location at the time of this interaction, if available. Applicable for mobile app interactions with location services enabled. Null if location data is unavailable.',
    `interaction_timestamp` TIMESTAMP COMMENT 'The date and time when the interaction event occurred. This is the business event timestamp (when the customer engaged), distinct from record audit timestamps.',
    `interaction_type` STRING COMMENT 'The category of customer touchpoint or engagement event. Defines the nature of the interaction (e.g., POS visit, website session, app open, call center contact, email send, SMS send, push notification, chat, clienteling visit, NPS survey response). [ENUM-REF-CANDIDATE: pos_visit|website_session|mobile_app_open|call_center_contact|email_campaign|sms_campaign|push_notification|live_chat|clienteling_visit|nps_survey|social_media_engagement|kiosk_interaction|video_call|in_store_event — promote to reference product]',
    `ip_address` STRING COMMENT 'The IP address of the customer device during this interaction. Applicable for digital interactions. Null for in-store interactions. May be considered PII in some jurisdictions.',
    `landing_page_url` STRING COMMENT 'The URL of the first page visited by the customer during this interaction session. Applicable for web-based interactions. Null for non-web interactions.',
    `notes` STRING COMMENT 'Free-text notes or comments recorded by the associate or agent during or after the interaction. Captures additional context, customer requests, or follow-up actions. Null if no notes were recorded.',
    `nps_score` STRING COMMENT 'The Net Promoter Score (NPS) provided by the customer during or after this interaction, if applicable. Scale 0-10. Null if no NPS was collected.',
    `operating_system` STRING COMMENT 'The operating system of the device used during this interaction (e.g., Windows, macOS, iOS, Android). Applicable for digital interactions. Null for non-digital interactions.',
    `outcome` STRING COMMENT 'The result or resolution status of the interaction (e.g., completed, abandoned, escalated, resolved, converted, bounced, unsubscribed). [ENUM-REF-CANDIDATE: completed|abandoned|escalated|resolved|converted|bounced|unsubscribed|pending|transferred|no_response — promote to reference product]',
    `referrer_url` STRING COMMENT 'The URL of the page or source that referred the customer to this interaction (e.g., search engine, social media, email link). Applicable for web-based interactions. Null for non-web interactions.',
    `sentiment_score` DECIMAL(18,2) COMMENT 'A numeric score representing the sentiment or emotional tone of the interaction, derived from text analytics or voice analytics. Scale typically -1.0 (negative) to +1.0 (positive). Null if sentiment analysis was not performed.',
    `sms_delivered_flag` BOOLEAN COMMENT 'Boolean flag indicating whether an outbound SMS message was successfully delivered to the customer. Applicable only for SMS interactions. Null for non-SMS interactions.',
    `subject` STRING COMMENT 'A brief subject or title describing the purpose or topic of the interaction (e.g., product inquiry, order status check, complaint, feedback). Applicable for call center contacts, service cases, and clienteling visits. Null for automated or non-subject-based interactions.',
    `unsubscribed_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the customer unsubscribed from communications as a result of this interaction. Applicable for outbound communication interactions.',
    `updated_timestamp` TIMESTAMP COMMENT 'The date and time when this interaction record was last updated in the data platform. Audit field for data lineage and compliance.',
    CONSTRAINT pk_interaction PRIMARY KEY(`interaction_id`)
) COMMENT 'Records every customer touchpoint, engagement event, and outbound communication across all Retail channels sourced from SAP Customer Activity Repository (CAR) and the case management system. Stores interaction type (POS visit, website session, app open, call center contact, email send/open/click, SMS send/delivery, push notification, chat, clienteling visit, NPS survey response), direction (inbound/outbound), channel, store or digital property, timestamp, duration, outcome, NPS score (when applicable), associated campaign or promotion ID, delivery status and engagement metrics for outbound messages (delivered/opened/clicked/bounced/unsubscribed), and agent/associate ID. This is the single consolidated product for all customer communication and engagement history — foundation for omnichannel interaction timeline, communication audit trail, campaign response tracking, and CLTV modeling.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`wishlist` (
    `wishlist_id` BIGINT COMMENT 'Primary key for wishlist',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Wishlists often organized by category ("Wedding Registry - Home Goods", "Holiday - Toys") for customer convenience and retailer assortment gap analysis. Enables category-level demand forecasting from',
    `location_id` BIGINT COMMENT 'Identifier of the physical store location associated with this wishlist (e.g., for BOPIS preferences, in-store registry creation, or store-specific wishlists). Nullable for online-only wishlists.',
    `profile_id` BIGINT COMMENT 'Identifier of the customer who owns this wishlist. Links to the customer master record.',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Wedding and baby registry wishlists are managed by dedicated in-store registry consultants who assist customers with product selection, registry setup, gift tracking, and completion discounts. Support',
    `address_id` BIGINT COMMENT 'Identifier of the preferred shipping address for gift registry items. Links to customer address records. Nullable for non-registry wishlists.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Wishlists contain specific SKUs customers intend to purchase. Core e-commerce and registry functionality requires linking wishlist items to product catalog. Drives conversion tracking, inventory plann',
    `archived_timestamp` TIMESTAMP COMMENT 'Date and time when the wishlist was archived by the customer or system. Nullable if never archived. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `channel` STRING COMMENT 'Digital channel through which the wishlist was created: web (desktop browser), mobile_app (iOS/Android app), mobile_web (mobile browser), in_store_kiosk, or call_center (assisted creation).. Valid values are `web|mobile_app|mobile_web|in_store_kiosk|call_center`',
    `co_registrant_first_name` STRING COMMENT 'First name of the secondary registrant for gift registries (e.g., groom, co-host). Nullable for single-registrant or non-registry wishlists.',
    `co_registrant_last_name` STRING COMMENT 'Last name of the secondary registrant for gift registries. Nullable for single-registrant or non-registry wishlists.',
    `conversion_rate_percentage` DECIMAL(18,2) COMMENT 'Percentage of wishlist items that have been purchased (converted to orders). Calculated as (purchased items / total items) × 100. Key metric for wishlist effectiveness.',
    `conversion_status` STRING COMMENT 'Indicates whether items from this wishlist have been purchased: unconverted (no items purchased), partially_converted (some items purchased), fully_converted (all items purchased).. Valid values are `unconverted|partially_converted|fully_converted`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the wishlist was first created by the customer. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the wishlist value amount (e.g., USD, EUR, GBP, CAD).. Valid values are `^[A-Z]{3}$`',
    `data_retention_expiry_date` DATE COMMENT 'Date when this wishlist record is eligible for permanent deletion per data retention policies. Calculated based on last activity date and regulatory requirements. Format: yyyy-MM-dd.',
    `deleted_timestamp` TIMESTAMP COMMENT 'Date and time when the wishlist was soft-deleted. Nullable if not deleted. Supports data retention and recovery policies. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `wishlist_description` STRING COMMENT 'Optional customer-provided description or notes about the wishlist purpose, preferences, or special instructions (e.g., Items for new apartment, Prefer blue colors).',
    `device_type` STRING COMMENT 'Type of device used to create the wishlist: desktop, tablet, smartphone, kiosk, or unknown if not captured.. Valid values are `desktop|tablet|smartphone|kiosk|unknown`',
    `event_date` DATE COMMENT 'Target date for the event associated with this wishlist (e.g., wedding date, birthday, holiday). Applicable primarily to gift registries. Nullable for non-event wishlists. Format: yyyy-MM-dd.',
    `external_wishlist_code` STRING COMMENT 'Original wishlist identifier from the source system (e.g., the e-commerce platform wishlist GUID). Used for cross-system reconciliation and data lineage.',
    `first_conversion_timestamp` TIMESTAMP COMMENT 'Date and time when the first item from this wishlist was purchased. Nullable if no conversions have occurred. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `is_default_flag` BOOLEAN COMMENT 'Indicates whether this is the customers default wishlist. True if default (items added without specifying a list go here), False otherwise. Each customer should have only one default wishlist.',
    `last_conversion_timestamp` TIMESTAMP COMMENT 'Date and time when the most recent item from this wishlist was purchased. Nullable if no conversions have occurred. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the wishlist was last updated (items added/removed, name changed, settings modified). Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `last_viewed_timestamp` TIMESTAMP COMMENT 'Date and time when the wishlist was last viewed by any user (owner or gift-giver). Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `wishlist_name` STRING COMMENT 'Customer-provided name for the wishlist (e.g., Birthday Gifts, Holiday Shopping, Wedding Registry).',
    `notification_enabled_flag` BOOLEAN COMMENT 'Indicates whether the customer has enabled notifications for this wishlist (e.g., back-in-stock alerts, price drop alerts, event reminders). True if enabled, False if disabled.',
    `notification_frequency` STRING COMMENT 'Frequency at which the customer wants to receive wishlist notifications: immediate (real-time alerts), daily digest, weekly digest, event_based (only for specific triggers), or disabled.. Valid values are `immediate|daily|weekly|event_based|disabled`',
    `privacy_consent_flag` BOOLEAN COMMENT 'Indicates whether the customer has consented to use wishlist data for personalized recommendations and marketing. True if consent given, False otherwise. Required for GDPR and CCPA compliance.',
    `registrant_first_name` STRING COMMENT 'First name of the primary registrant for gift registries (e.g., bride, birthday person). Used for registry search and display. Nullable for non-registry wishlists.',
    `registrant_last_name` STRING COMMENT 'Last name of the primary registrant for gift registries. Used for registry search and display. Nullable for non-registry wishlists.',
    `registry_number` STRING COMMENT 'Unique public-facing registry number for gift registries, used by gift-givers to search and locate the registry. Nullable for non-registry wishlists.',
    `share_count` STRING COMMENT 'Number of times the wishlist has been shared via email, social media, or direct link. Tracks viral/social engagement.',
    `share_url` STRING COMMENT 'Unique shareable URL for this wishlist. Generated for shared and public wishlists to enable gift-givers to view and purchase items. Nullable for private wishlists.',
    `total_item_count` STRING COMMENT 'Total number of distinct product SKUs currently in the wishlist. Calculated from wishlist item detail records.',
    `total_quantity` STRING COMMENT 'Sum of desired quantities across all items in the wishlist. Accounts for items where customer wants multiple units.',
    `total_value_amount` DECIMAL(18,2) COMMENT 'Total monetary value of all items in the wishlist at current prices. Sum of (item price × desired quantity) for all items. Used for demand forecasting and promotional targeting.',
    `view_count` STRING COMMENT 'Total number of times the wishlist has been viewed by the owner or others (for shared/public wishlists). Engagement metric.',
    `visibility` STRING COMMENT 'Privacy setting for the wishlist: private (only owner can view), shared (accessible via link), public (searchable by others), or registry (publicly searchable gift registry).. Valid values are `private|shared|public|registry`',
    `wishlist_status` STRING COMMENT 'Current lifecycle status of the wishlist: active (in use), archived (saved but inactive), deleted (soft-deleted), or expired (past event date for registries).. Valid values are `active|archived|deleted|expired`',
    `wishlist_type` STRING COMMENT 'Classification of the wishlist purpose: standard personal wishlist, gift registry for events, save-for-later cart items, favorites collection, private collection, or shared list.. Valid values are `standard|gift_registry|save_for_later|favorites|private_collection|shared_list`',
    CONSTRAINT pk_wishlist PRIMARY KEY(`wishlist_id`)
) COMMENT 'Customer-created product wishlists, saved-for-later collections, and gift registries across Retail e-commerce and mobile platforms (the e-commerce platform). Stores wishlist name, creation date, visibility (private/shared/registry), last modified date, total item count, item-level details (product SKU reference, desired quantity, priority, added date, price-at-add, availability status), associated channel, and conversion status (unconverted/partially-converted/fully-converted). Supports personalized recommendations, targeted promotions, back-in-stock notifications, gift registry workflows, and demand signal generation for merchandising.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`privacy_request` (
    `privacy_request_id` BIGINT COMMENT 'Unique identifier for the privacy request. Primary key.',
    `associate_id` BIGINT COMMENT 'Identifier of the employee or system user assigned to process this privacy request.',
    `loyalty_membership_id` BIGINT COMMENT 'Foreign key linking to loyalty.membership. Business justification: GDPR/CCPA data subject requests require purging or exporting loyalty data (points history, redemptions, tier status). Privacy teams need direct link to membership record to fulfill right-to-erasure, r',
    `profile_id` BIGINT COMMENT 'Identifier of the customer who submitted the privacy request.',
    `appeal_outcome` STRING COMMENT 'Outcome of the customer appeal: upheld (original decision maintained), overturned (request re-processed), pending (under review), withdrawn (customer cancelled appeal).. Valid values are `upheld|overturned|pending|withdrawn`',
    `appeal_submitted_flag` BOOLEAN COMMENT 'Indicates whether the customer submitted an appeal or complaint regarding the handling of this privacy request.',
    `appeal_timestamp` TIMESTAMP COMMENT 'Date and time when the customer submitted an appeal or complaint.',
    `assignment_timestamp` TIMESTAMP COMMENT 'Date and time when the privacy request was assigned to a processor.',
    `audit_log_reference` STRING COMMENT 'Reference identifier to the detailed audit log entries tracking all system actions taken to fulfill this privacy request.',
    `completion_timestamp` TIMESTAMP COMMENT 'Date and time when the privacy request was completed and the customer was notified.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this privacy request record was first created in the system.',
    `customer_notification_sent_flag` BOOLEAN COMMENT 'Indicates whether the customer was notified of the request outcome via email or other channel.',
    `customer_notification_timestamp` TIMESTAMP COMMENT 'Date and time when the customer was notified of the request outcome.',
    `data_categories_affected` STRING COMMENT 'Comma-separated list of data categories affected by this request (e.g., profile, transaction_history, loyalty, marketing_preferences, location_data).',
    `data_export_expiry_timestamp` TIMESTAMP COMMENT 'Date and time when the data export download link expires for security purposes.',
    `data_export_format` STRING COMMENT 'File format used for data portability requests: JSON, CSV, PDF, XML. Applicable only for access and portability request types.. Valid values are `JSON|CSV|PDF|XML`',
    `data_export_url` STRING COMMENT 'Secure download URL for the exported customer data package. Time-limited and encrypted. Applicable for access and portability requests.',
    `denial_reason` STRING COMMENT 'Legal or business justification for denying the privacy request (e.g., legal obligation to retain data, manifestly unfounded request, excessive requests).',
    `extension_granted_flag` BOOLEAN COMMENT 'Indicates whether a deadline extension was granted for this request due to complexity or volume.',
    `extension_reason` STRING COMMENT 'Business justification for granting a deadline extension (e.g., complex request, high volume, technical difficulties).',
    `outcome` STRING COMMENT 'Final outcome of the privacy request: fulfilled (completed as requested), partially_fulfilled (some data unavailable), denied (rejected with justification), withdrawn (cancelled by customer).. Valid values are `fulfilled|partially_fulfilled|denied|withdrawn`',
    `processing_deadline` DATE COMMENT 'Regulatory deadline by which the privacy request must be completed. GDPR: 30 days (extendable to 90), CCPA: 45 days (extendable to 90).',
    `processing_notes` STRING COMMENT 'Internal notes and comments from the assigned processor documenting actions taken, challenges encountered, and decisions made during request processing.',
    `records_anonymized_count` STRING COMMENT 'Number of database records anonymized (PII removed but record retained for analytics) to fulfill an erasure request.',
    `records_deleted_count` STRING COMMENT 'Number of database records deleted across all systems to fulfill an erasure request.',
    `regulatory_framework` STRING COMMENT 'Primary data protection regulation governing this request: GDPR (EU General Data Protection Regulation), CCPA (California Consumer Privacy Act), LGPD (Brazil), PIPEDA (Canada), APPI (Japan), POPIA (South Africa).. Valid values are `GDPR|CCPA|LGPD|PIPEDA|APPI|POPIA`',
    `request_number` STRING COMMENT 'Externally-visible unique business identifier for the privacy request, used for customer communication and tracking.. Valid values are `^PR-[0-9]{10}$`',
    `request_status` STRING COMMENT 'Current lifecycle status of the privacy request: submitted (initial receipt), pending_verification (identity check in progress), verified (identity confirmed), in_progress (being processed), completed (fulfilled), rejected (denied), cancelled (withdrawn by customer). [ENUM-REF-CANDIDATE: submitted|pending_verification|verified|in_progress|completed|rejected|cancelled — 7 candidates stripped; promote to reference product]',
    `request_type` STRING COMMENT 'Type of privacy request: access (right to know), erasure (right to delete), portability (data export), rectification (correction), opt_out_sale (CCPA opt-out), restriction (processing limitation).. Valid values are `access|erasure|portability|rectification|opt_out_sale|restriction`',
    `submission_channel` STRING COMMENT 'Channel through which the privacy request was submitted: web_portal, mobile_app, email, phone, in_store, postal_mail.. Valid values are `web_portal|mobile_app|email|phone|in_store|postal_mail`',
    `submission_timestamp` TIMESTAMP COMMENT 'Date and time when the privacy request was submitted by the customer. Principal business event timestamp.',
    `systems_affected` STRING COMMENT 'Comma-separated list of operational systems where data was accessed, modified, or deleted to fulfill this request (e.g., CRM, ERP, WMS, E-commerce).',
    `updated_timestamp` TIMESTAMP COMMENT 'Date and time when this privacy request record was last modified.',
    `verification_method` STRING COMMENT 'Method used to verify the customers identity: email_token, sms_code, account_login, document_upload, phone_callback, in_person.. Valid values are `email_token|sms_code|account_login|document_upload|phone_callback|in_person`',
    `verification_status` STRING COMMENT 'Status of customer identity verification: not_started, pending (verification in progress), verified (identity confirmed), failed (verification unsuccessful), exempted (verification not required).. Valid values are `not_started|pending|verified|failed|exempted`',
    `verification_timestamp` TIMESTAMP COMMENT 'Date and time when customer identity verification was completed.',
    CONSTRAINT pk_privacy_request PRIMARY KEY(`privacy_request_id`)
) COMMENT 'Formal customer privacy rights requests submitted under GDPR (right to access, right to erasure, right to portability, right to rectification) and CCPA (right to know, right to delete, right to opt-out of sale). Stores request type, submission channel, submission timestamp, verification status, assigned processor, processing deadline (regulatory SLA), completion timestamp, outcome, and data categories affected. Managed in compliance with GDPR and CCPA as enforced by applicable regulatory bodies.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`issuance` (
    `issuance_id` BIGINT COMMENT 'Unique identifier for this coupon issuance record. Primary key.',
    `coupon_id` BIGINT COMMENT 'Foreign key linking to the coupon instrument that was issued',
    `profile_id` BIGINT COMMENT 'Foreign key linking to the customer profile who received this coupon issuance',
    `location_id` BIGINT COMMENT 'Store or channel location where this customer redeemed this coupon. Null if not yet redeemed. Foreign key to location/store master.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this issuance record was created in the system.',
    `expiration_date` DATE COMMENT 'Expiration date for this specific issuance. May differ from the coupon master expiration_date if personalized or extended for this customer.',
    `issue_channel` STRING COMMENT 'Distribution channel through which this coupon was issued to this customer. Tracks the specific touchpoint used for this issuance event.',
    `issue_date` DATE COMMENT 'Date when this specific coupon was issued to this specific customer. Tracks the per-customer issuance event, distinct from the coupons general availability date.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this issuance record was last updated.',
    `personalization_discount_override` DECIMAL(18,2) COMMENT 'Customer-specific discount value that overrides the coupons standard face_value. Used for personalized promotional offers based on customer segment, loyalty tier, or campaign targeting.',
    `redemption_date` DATE COMMENT 'Date when this customer redeemed this coupon. Null if not yet redeemed. Tracks the per-customer redemption event.',
    `redemption_status` STRING COMMENT 'Current lifecycle status of this coupon issuance. Tracks whether the customer has redeemed, let expire, or still has the coupon available.',
    CONSTRAINT pk_issuance PRIMARY KEY(`issuance_id`)
) COMMENT 'This association product represents the issuance event between a customer profile and a coupon. It captures the operational lifecycle of a coupon from the moment it is issued to a specific customer through redemption or expiration. Each record links one customer to one coupon with attributes that track when and how the coupon was issued, personalization overrides, redemption status, and channel-specific metadata. This is distinct from promo_redemption which tracks transaction-level usage; issuance tracks the coupon lifecycle per customer.. Existence Justification: In retail operations, coupon issuance is a managed many-to-many relationship where customers receive multiple coupons from different campaigns and channels, and each coupon is issued to multiple customers. The business actively tracks the lifecycle of each customer-coupon pairing including when issued, through what channel, personalization overrides, redemption status, and redemption details. This is distinct from transaction-level redemption tracking (handled by promo_redemption) and represents the operational management of coupon distribution and lifecycle per customer.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`targeting` (
    `targeting_id` BIGINT COMMENT 'Unique identifier for this segment-campaign targeting record. Primary key.',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to the marketing campaign that is targeting this segment',
    `segment_id` BIGINT COMMENT 'Foreign key linking to the customer segment being targeted in this campaign',
    `activation_timestamp` TIMESTAMP COMMENT 'Date and time when this segment was activated for targeting within the campaign. May differ from campaign start date if segments are activated in waves.',
    `actual_reached_count` BIGINT COMMENT 'Actual number of customers from this segment who were successfully reached by campaign communications (emails delivered, ads served, SMS sent, etc.).',
    `budget_allocation_amount` DECIMAL(18,2) COMMENT 'Portion of the campaign budget allocated specifically to reaching this customer segment. Sum of all segment allocations should equal or be less than total campaign budget.',
    `conversion_rate_percent` DECIMAL(18,2) COMMENT 'Percentage of reached customers from this segment who completed the desired campaign conversion action (purchase, sign-up, etc.). Calculated as (converters / actual_reached_count) * 100.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this targeting record was created in the system. Audit field.',
    `deactivation_timestamp` TIMESTAMP COMMENT 'Date and time when this segment targeting was deactivated or completed. Null for currently active targeting.',
    `estimated_reach` BIGINT COMMENT 'Estimated number of customers from this segment expected to be reached by the campaign based on segment membership count and channel penetration rates.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this targeting record was last updated. Audit field.',
    `priority` STRING COMMENT 'Priority level assigned to this segment within the campaigns targeting strategy. Primary: main target audience; Secondary: secondary audience for expansion; Tertiary: opportunistic reach; Excluded: explicitly excluded from campaign.',
    `response_rate_percent` DECIMAL(18,2) COMMENT 'Percentage of reached customers from this segment who responded to the campaign (clicked, opened, visited store, etc.). Calculated as (responders / actual_reached_count) * 100.',
    `targeting_status` STRING COMMENT 'Current operational status of this segment targeting within the campaign. Planned: scheduled but not yet active; Active: currently being executed; Paused: temporarily suspended; Completed: execution finished; Cancelled: targeting cancelled before completion.',
    CONSTRAINT pk_targeting PRIMARY KEY(`targeting_id`)
) COMMENT 'This association product represents the targeting relationship between customer segments and marketing campaigns. It captures the operational activation of specific customer segments within campaign execution, tracking targeting priority, budget allocation, reach metrics, and performance outcomes for each segment-campaign combination. Each record links one customer segment to one marketing campaign with attributes that exist only in the context of this targeted activation.. Existence Justification: In retail marketing operations, campaigns routinely target multiple customer segments simultaneously (e.g., a seasonal promotion targeting VIP Gold, Geographic Region A, and High-Value Lapsed segments), and customer segments participate in multiple concurrent campaigns (e.g., VIP Gold segment is targeted by loyalty rewards campaign, seasonal sale, and category-specific promotion). The business actively manages segment targeting as an operational entity, allocating budget per segment, setting targeting priorities, and measuring segment-specific performance metrics (response rates, conversion rates, reach) for campaign optimization and ROI analysis.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`segment_banner_targeting` (
    `segment_banner_targeting_id` BIGINT COMMENT 'Unique identifier for this segment-banner targeting relationship. Primary key.',
    `segment_id` BIGINT COMMENT 'Foreign key linking to the customer segment being targeted by this banner placement',
    `promotion_banner_id` BIGINT COMMENT 'Foreign key linking to the promotional banner being displayed to this segment',
    `attributed_revenue` DECIMAL(18,2) COMMENT 'Total revenue generated by customers in this segment attributed to this banner through click-through and conversion tracking. Enables segment-level ROI analysis.',
    `click_count` BIGINT COMMENT 'Total number of times customers in this segment have clicked on this banner. Used to calculate segment-specific CTR and engagement.',
    `conversion_count` BIGINT COMMENT 'Total number of conversions (orders placed) by customers in this segment attributed to this banner through click-through tracking.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this segment targeting relationship was first configured in the campaign management system.',
    `end_date` DATE COMMENT 'Date when this banner stopped being targeted to this specific segment. May differ from the banners overall end_date if segment targeting is phased or A/B tested.',
    `impression_count` BIGINT COMMENT 'Total number of times this banner has been displayed to customers in this segment. Used to calculate segment-specific reach and CTR.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this segment targeting configuration was last updated (status change, date adjustment, etc.).',
    `start_date` DATE COMMENT 'Date when this banner began being targeted to this specific segment. May differ from the banners overall start_date if segment targeting is phased.',
    `targeting_status` STRING COMMENT 'Current status of this segment targeting configuration. Active: currently displaying to segment; Paused: temporarily disabled; Completed: ended normally; Cancelled: ended early.',
    CONSTRAINT pk_segment_banner_targeting PRIMARY KEY(`segment_banner_targeting_id`)
) COMMENT 'This association product represents the targeting relationship between customer segments and promotional banners in digital marketing campaigns. It captures campaign performance metrics specific to each segment-banner combination, enabling marketing attribution analysis, segment ROI measurement, and campaign optimization. Each record links one customer segment to one promotional banner with performance metrics and display scheduling that exist only in the context of this targeted marketing relationship.. Existence Justification: In retail digital marketing operations, promotional banners are actively targeted to multiple customer segments simultaneously through campaign management systems (e.g., VIP Gold sees Banner A, Lapsed Customers see Banner B, but both segments may also see Banner C in different placements or time windows). Each segment-banner combination generates its own performance metrics (impressions, clicks, conversions, attributed revenue) that marketing teams use for attribution analysis, segment ROI measurement, and campaign optimization. This is an operational marketing execution relationship that humans actively configure, monitor, and optimize.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`client_relationship` (
    `client_relationship_id` BIGINT COMMENT 'Unique identifier for this client-associate relationship assignment. Primary key.',
    `associate_id` BIGINT COMMENT 'Foreign key linking to the associate providing personalized service',
    `profile_id` BIGINT COMMENT 'Foreign key linking to the customer profile receiving personalized service',
    `assignment_status` STRING COMMENT 'Current operational status of this relationship assignment. ACTIVE indicates ongoing service relationship, INACTIVE indicates ended relationship, SUSPENDED indicates temporary pause (e.g., associate leave), TRANSFERRED indicates customer reassigned to different associate.',
    `communication_preference` STRING COMMENT 'Preferred communication channel for this specific associate-customer relationship. May differ from customers general communication preference based on relationship type (e.g., stylist prefers in-person consultations, business rep prefers email).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this relationship assignment record was created in the system.',
    `end_date` DATE COMMENT 'Date when this associate-customer relationship ended. Null for active relationships. Used for turnover analysis and reassignment tracking.',
    `primary_contact_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this associate is the primary/lead contact for this customer when multiple associates serve the same customer across departments. True indicates primary relationship manager, false indicates supporting specialist.',
    `relationship_type` STRING COMMENT 'Classification of the service relationship type defining the nature of personalized service provided. Examples: PERSONAL_SHOPPER for general shopping assistance, STYLIST for fashion/wardrobe consulting, REGISTRY_CONSULTANT for wedding/baby registry management, BUSINESS_ACCOUNT_REP for B2B corporate buyers, VIP_CONCIERGE for high-CLTV customers, DEPARTMENT_SPECIALIST for category-specific expertise.',
    `start_date` DATE COMMENT 'Date when this associate was assigned to this customer for personalized service. Used for relationship tenure tracking and service continuity metrics.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this relationship assignment record.',
    CONSTRAINT pk_client_relationship PRIMARY KEY(`client_relationship_id`)
) COMMENT 'This association product represents the assignment relationship between high-value customers and dedicated retail associates (personal shoppers, stylists, relationship managers). It captures the formal assignment of associates to VIP/corporate clients for personalized service delivery. Each record links one customer profile to one associate with relationship metadata including type, dates, primary contact designation, and communication preferences that exist only in the context of this service relationship.. Existence Justification: In retail operations, high-value customers (VIP, corporate executives) are assigned multiple specialized associates simultaneously - a customer may work with a personal stylist, a registry consultant, and a business account representative across different departments. Conversely, each associate (stylist, relationship manager) manages a portfolio of multiple VIP clients. The business actively manages these assignments with specific relationship types, dates, primary contact designations, and communication preferences.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`b2b_contract` (
    `b2b_contract_id` BIGINT COMMENT 'Primary key for b2b_contract',
    `associate_id` BIGINT COMMENT 'Reference to the employee who provided final approval for this contract.',
    `b2b_associate_id` BIGINT COMMENT 'Reference to the employee responsible for managing this B2B customer relationship and contract.',
    `contract_template_id` BIGINT COMMENT 'Reference to the standard contract template used as the basis for this agreement.',
    `corporate_account_id` BIGINT COMMENT 'Reference to the B2B customer organization that is party to this contract.',
    `master_b2b_contract_id` BIGINT COMMENT 'Self-referencing FK on b2b_contract (master_b2b_contract_id)',
    `price_list_id` BIGINT COMMENT 'add column pricing_price_list_id (BIGINT) with FK to pricing.price_list.price_list_id - B2B contracts specify negotiated price lists for corporate customers',
    `sales_territory_id` BIGINT COMMENT 'Reference to the geographic or organizational sales territory to which this contract is assigned.',
    `approved_date` DATE COMMENT 'Date when the contract received final internal approval.',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the contract is configured to automatically renew upon expiration.',
    `billing_frequency` STRING COMMENT 'Frequency at which invoices are generated and payments are due under this contract.',
    `contract_document_url` STRING COMMENT 'Reference link or storage location for the signed contract document.',
    `contract_number` STRING COMMENT 'Externally-known unique business identifier for the contract, used in communications and documentation.',
    `contract_status` STRING COMMENT 'Current lifecycle state of the contract indicating its operational validity and enforceability.',
    `contract_type` STRING COMMENT 'Classification of the contract based on its business purpose and legal structure.',
    `contract_value` DECIMAL(18,2) COMMENT 'Total monetary value of the contract over its full term, representing the expected revenue or commitment amount.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this contract record was first created in the system.',
    `credit_limit` DECIMAL(18,2) COMMENT 'Maximum outstanding credit amount allowed for the customer under this contract.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary values in this contract.',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Standard discount rate applied to list prices for this B2B customer under the contract terms.',
    `effective_end_date` DATE COMMENT 'Date when the contract terms expire or are scheduled to terminate. Nullable for open-ended contracts.',
    `effective_start_date` DATE COMMENT 'Date when the contract terms become legally binding and operational.',
    `exclusive_agreement_flag` BOOLEAN COMMENT 'Indicates whether this is an exclusive supply or distribution agreement preventing the customer from engaging competitors.',
    `governing_law` STRING COMMENT 'Legal jurisdiction and governing law under which the contract is interpreted and enforced.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this contract record was last updated in the system.',
    `minimum_order_value` DECIMAL(18,2) COMMENT 'Minimum purchase amount required per order or billing period as stipulated in the contract.',
    `notes` STRING COMMENT 'Additional free-text notes or comments about the contract for internal reference.',
    `payment_terms` STRING COMMENT 'Description of payment conditions including timing, method, and any special arrangements (e.g., Net 30, Net 60, advance payment).',
    `penalty_terms` STRING COMMENT 'Description of financial penalties or remedies for breach of contract terms or service level failures.',
    `pricing_tier` STRING COMMENT 'Pricing level or tier assigned to this contract, determining applicable rates and discounts.',
    `renewal_notice_days` STRING COMMENT 'Number of days prior to expiration that renewal notice must be provided, as specified in contract terms.',
    `renewal_type` STRING COMMENT 'Indicates whether the contract automatically renews, requires manual renewal, or is non-renewable.',
    `service_level_agreement` STRING COMMENT 'Description of service level commitments including delivery times, quality standards, and performance metrics.',
    `signed_date` DATE COMMENT 'Date when the contract was executed and signed by all parties.',
    `termination_date` DATE COMMENT 'Actual date when the contract was terminated, if applicable. Null for active contracts.',
    `termination_notice_days` STRING COMMENT 'Number of days advance notice required for contract termination by either party.',
    `termination_reason` STRING COMMENT 'Explanation or business reason for contract termination, if terminated.',
    `volume_commitment` DECIMAL(18,2) COMMENT 'Total volume or quantity the customer commits to purchase over the contract term.',
    CONSTRAINT pk_b2b_contract PRIMARY KEY(`b2b_contract_id`)
) COMMENT 'Master reference table for b2b_contract. Referenced by b2b_contract_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`contract_template` (
    `contract_template_id` BIGINT COMMENT 'Primary key for contract_template',
    `parent_contract_template_id` BIGINT COMMENT 'Self-referencing FK on contract_template (parent_contract_template_id)',
    `approval_level` STRING COMMENT 'Organizational level or role required to approve contracts generated from this template.',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether contracts generated from this template require formal approval before execution.',
    `approved_by` STRING COMMENT 'Identifier or name of the user or authority who approved this template for active use.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this contract template was formally approved for use.',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether contracts generated from this template include automatic renewal provisions by default.',
    `compliance_tags` STRING COMMENT 'Comma-separated list of regulatory or compliance frameworks this template adheres to, such as GDPR, CCPA, SOX, or industry-specific regulations.',
    `confidentiality_clause_included` BOOLEAN COMMENT 'Indicates whether the template includes confidentiality and non-disclosure provisions.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this contract template record was first created in the system.',
    `default_term_length_days` STRING COMMENT 'Standard duration in days for contracts generated from this template, representing the default commitment period.',
    `contract_template_description` STRING COMMENT 'Detailed business description of the contract template purpose, scope, and intended use cases.',
    `dispute_resolution_method` STRING COMMENT 'Primary mechanism specified in the template for resolving disputes between contracting parties.',
    `effective_end_date` DATE COMMENT 'Date after which this contract template version is no longer valid for generating new contracts. Nullable for templates with indefinite validity.',
    `effective_start_date` DATE COMMENT 'Date from which this contract template version becomes valid and available for use in generating new contracts.',
    `governing_law` STRING COMMENT 'Specific legal framework, statute, or body of law that governs contracts created from this template.',
    `language_code` STRING COMMENT 'Two-letter ISO language code indicating the primary language in which the contract template is written.',
    `last_used_date` DATE COMMENT 'Most recent date on which this template was used to generate a contract.',
    `legal_jurisdiction` STRING COMMENT 'Three-letter ISO country code indicating the primary legal jurisdiction under which contracts generated from this template are governed.',
    `liability_cap_amount` DECIMAL(18,2) COMMENT 'Maximum liability amount specified in the template, representing the upper limit of financial exposure.',
    `liability_cap_currency` STRING COMMENT 'Three-letter ISO currency code for the liability cap amount.',
    `modified_by` STRING COMMENT 'Identifier or name of the user or system that most recently modified this contract template.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this contract template record was last modified.',
    `notes` STRING COMMENT 'Additional free-form notes, comments, or instructions related to the use or maintenance of this contract template.',
    `renewal_notice_days` STRING COMMENT 'Number of days advance notice required before contract renewal or termination, as specified in the template.',
    `review_due_date` DATE COMMENT 'Scheduled date for the next periodic review of this contract template to ensure continued legal and business relevance.',
    `contract_template_status` STRING COMMENT 'Current lifecycle status of the contract template indicating its availability for use in contract generation.',
    `template_category` STRING COMMENT 'High-level category indicating the primary counterparty type this template is designed for.',
    `template_code` STRING COMMENT 'Externally-known unique business identifier code for the contract template, used for reference across systems and documentation.',
    `template_content` STRING COMMENT 'Full text content of the contract template including placeholders, clauses, terms, and conditions. May contain markup or template syntax.',
    `template_format` STRING COMMENT 'Technical format or markup language used to structure the template content.',
    `template_name` STRING COMMENT 'Human-readable name of the contract template that clearly identifies its purpose and use case.',
    `template_type` STRING COMMENT 'Classification of the contract template by its primary business purpose and legal structure.',
    `termination_clause_included` BOOLEAN COMMENT 'Indicates whether the template includes standard termination provisions and exit clauses.',
    `usage_count` STRING COMMENT 'Total number of contracts that have been generated using this template, tracking template adoption and popularity.',
    `version_number` STRING COMMENT 'Semantic version number of the contract template following major.minor.patch convention to track template evolution.',
    `created_by` STRING COMMENT 'Identifier or name of the user or system that originally created this contract template.',
    CONSTRAINT pk_contract_template PRIMARY KEY(`contract_template_id`)
) COMMENT 'Master reference table for contract_template. Referenced by contract_template_id.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`communication_preference` (
    `communication_preference_id` BIGINT COMMENT 'Unique identifier for the customer preference record. Primary key.',
    `preference_id` BIGINT COMMENT 'Identifier of the preference record that supersedes or replaces this preference. Nullable if this is the current active preference. Supports preference lineage and history tracking.',
    `channel_captured` STRING COMMENT 'The channel or touchpoint through which the preference was originally captured (e.g., web, mobile app, POS (Point of Sale), call center, in-store kiosk, email, survey, third-party). Supports omnichannel attribution and data quality assessment. [ENUM-REF-CANDIDATE: web|mobile_app|pos|call_center|in_store_kiosk|email|survey|third_party — 8 candidates stripped; promote to reference product]',
    `consent_given` BOOLEAN COMMENT 'Boolean flag indicating whether the customer has provided explicit consent for this preference to be used for personalization, marketing, or data processing. True indicates consent granted; False indicates consent not granted or withdrawn.',
    `consent_timestamp` TIMESTAMP COMMENT 'The timestamp when the customer provided or withdrew consent for this preference. Required for GDPR and CCPA compliance audit trails. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `language` STRING COMMENT 'Three-letter ISO 639-2 language code indicating the language in which the preference was captured or should be displayed (e.g., ENG for English, SPA for Spanish, FRA for French). Supports multilingual customer experience and localization.. Valid values are `^[A-Z]{3}$`',
    `opt_out_flag` BOOLEAN COMMENT 'Boolean flag indicating whether the customer has opted out of having this preference used for personalization or marketing. True indicates customer has opted out; False indicates customer has not opted out. Supports GDPR right to object and CCPA opt-out requirements.',
    `opt_out_timestamp` TIMESTAMP COMMENT 'The timestamp when the customer opted out of this preference. Required for compliance audit trails. Nullable if customer has not opted out. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `preference_category` STRING COMMENT 'The category or type of preference being captured (e.g., communication channel, product category affinity, dietary restriction, brand preference, store preference, language, notification frequency, privacy consent, marketing opt-in, delivery preference, payment method preference, shopping time preference). Supports segmentation and personalization across all Retail channels. [ENUM-REF-CANDIDATE: communication_channel|product_category_affinity|dietary_restriction|brand_preference|store_preference|language|notification_frequency|privacy_consent|marketing_opt_in|delivery_preference|payment_method_preference|shopping_time_preference — 12 candidates stripped; promote to reference product]',
    `preference_description` STRING COMMENT 'Free-text description or additional context about the preference, especially useful for complex or custom preferences that require explanation. Supports customer service and clienteling use cases.',
    `preference_source` STRING COMMENT 'The origin of the preference data. Self-declared indicates customer explicitly provided the preference; behavioral indicates derived from purchase or browsing history; inferred indicates algorithmic prediction; third-party indicates sourced from external data provider; imported indicates migrated from legacy system.. Valid values are `self_declared|behavioral|inferred|third_party|imported`',
    `preference_status` STRING COMMENT 'Current lifecycle status of the preference. Active indicates currently in use; inactive indicates temporarily disabled; expired indicates no longer valid due to time constraints; superseded indicates replaced by a newer preference.. Valid values are `active|inactive|expired|superseded`',
    `preference_value` DECIMAL(18,2) COMMENT 'The specific value or selection for the preference category (e.g., email, organic produce, , Store #1234, Spanish, weekly). Free-text or structured value depending on category.',
    CONSTRAINT pk_communication_preference PRIMARY KEY(`communication_preference_id`)
) COMMENT 'Stores customer communication preferences including channel preferences, frequency settings, and opt-in/opt-out status for various communication types.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`customer_attribute` (
    `customer_attribute_id` BIGINT COMMENT 'Unique identifier for the customer preference record. Primary key.',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Customers express merchandise category preferences ("interested in electronics", "loves organic food") for personalized marketing, homepage customization, and category affinity scoring. Retail standar',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Category and department preferences enable targeted marketing campaigns and personalized navigation. Retail marketing segments customers by preferred categories (e.g., Beauty shoppers, Electronics',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Customer product preferences at SKU level (favorite items, repeat purchases) drive personalization engines, targeted promotions, and replenishment recommendations. Retail personalization requires link',
    `profile_id` BIGINT COMMENT 'Identifier of the customer who holds this preference. Links to the customer master record.',
    `application_count` STRING COMMENT 'The cumulative number of times this preference has been applied or used in customer interactions, recommendations, or personalization events. Supports preference effectiveness measurement and RFM (Recency Frequency Monetary) analytics.',
    `confidence_level` DECIMAL(18,2) COMMENT 'Numeric confidence score (0.00 to 100.00) indicating the reliability or certainty of the preference, especially for inferred or behavioral preferences. Higher values indicate stronger confidence. Self-declared preferences typically have 100.00 confidence.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this preference record was first created in the system. Supports audit trail and lifecycle analysis. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `data_source_system` STRING COMMENT 'The name or identifier of the source system or application that originally captured or provided this preference data (e.g., the e-commerce platform, the retail analytics platform, the customer master data system, Mobile App v2.3). Supports data lineage and troubleshooting.',
    `effective_end_date` DATE COMMENT 'The date on which this preference expires or is no longer valid. Nullable for open-ended preferences. Format: yyyy-MM-dd.',
    `effective_start_date` DATE COMMENT 'The date from which this preference becomes active and should be applied in personalization and customer interactions. Format: yyyy-MM-dd.',
    `geographic_scope` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code indicating the geographic region or country to which this preference applies (e.g., USA, CAN, MEX, GBR). Supports region-specific personalization and compliance with local regulations.. Valid values are `^[A-Z]{3}$`',
    `last_applied_timestamp` TIMESTAMP COMMENT 'The timestamp when this preference was last actively used or applied in a customer interaction, personalization event, or recommendation. Supports preference relevance scoring and decay analysis. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this preference record was last modified or refreshed. Used for data freshness tracking and synchronization with downstream systems. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `notes` STRING COMMENT 'Free-text field for additional notes, comments, or context about the preference. Used by customer service representatives for clienteling and personalized service. May contain customer service agent observations or customer-provided explanations.',
    `priority_rank` STRING COMMENT 'Numeric ranking indicating the relative priority or importance of this preference when multiple preferences exist for the same customer and category. Lower numbers indicate higher priority (e.g., 1 is highest priority).',
    `subcategory` STRING COMMENT 'Optional granular subcategory within the preference category for more detailed segmentation (e.g., within product_category_affinity, subcategory could be organic_produce, gluten_free_bakery, athletic_footwear). Supports fine-grained personalization.',
    `verification_status` STRING COMMENT 'Indicates whether the preference has been verified or validated through customer confirmation, behavioral validation, or data quality checks. Verified indicates confirmed accuracy; unverified indicates not yet validated; pending_verification indicates in validation process; verification_failed indicates validation attempt unsuccessful.. Valid values are `verified|unverified|pending_verification|verification_failed`',
    `verification_timestamp` TIMESTAMP COMMENT 'The timestamp when the preference verification status was last updated or when verification was completed. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `version` STRING COMMENT 'Version number of this preference record, incremented each time the preference is updated. Supports preference history tracking and change management. Initial version is 1.',
    `weight` DECIMAL(18,2) COMMENT 'Numeric weight (0.00 to 100.00) assigned to this preference for use in recommendation algorithms and personalization scoring. Higher weights indicate stronger influence on recommendations. Used by AI/ML models for CLTV (Customer Lifetime Value) and next-best-action predictions.',
    CONSTRAINT pk_customer_attribute PRIMARY KEY(`customer_attribute_id`)
) COMMENT 'Stores custom attributes and metadata for customer profiles';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ADD CONSTRAINT `fk_customer_profile_household_id` FOREIGN KEY (`household_id`) REFERENCES `vibe_retail_v1`.`customer`.`household`(`household_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_shipping_address_id` FOREIGN KEY (`shipping_address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ADD CONSTRAINT `fk_customer_household_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ADD CONSTRAINT `fk_customer_corporate_account_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ADD CONSTRAINT `fk_customer_corporate_account_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ADD CONSTRAINT `fk_customer_corporate_account_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `vibe_retail_v1`.`customer`.`contact`(`contact_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ADD CONSTRAINT `fk_customer_corporate_account_shipping_address_id` FOREIGN KEY (`shipping_address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ADD CONSTRAINT `fk_customer_contact_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ADD CONSTRAINT `fk_customer_address_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`identity_link` ADD CONSTRAINT `fk_customer_identity_link_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ADD CONSTRAINT `fk_customer_wishlist_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ADD CONSTRAINT `fk_customer_wishlist_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ADD CONSTRAINT `fk_customer_privacy_request_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`issuance` ADD CONSTRAINT `fk_customer_issuance_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`client_relationship` ADD CONSTRAINT `fk_customer_client_relationship_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`b2b_contract` ADD CONSTRAINT `fk_customer_b2b_contract_contract_template_id` FOREIGN KEY (`contract_template_id`) REFERENCES `vibe_retail_v1`.`customer`.`contract_template`(`contract_template_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`b2b_contract` ADD CONSTRAINT `fk_customer_b2b_contract_corporate_account_id` FOREIGN KEY (`corporate_account_id`) REFERENCES `vibe_retail_v1`.`customer`.`corporate_account`(`corporate_account_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`b2b_contract` ADD CONSTRAINT `fk_customer_b2b_contract_master_b2b_contract_id` FOREIGN KEY (`master_b2b_contract_id`) REFERENCES `vibe_retail_v1`.`customer`.`b2b_contract`(`b2b_contract_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`contract_template` ADD CONSTRAINT `fk_customer_contract_template_parent_contract_template_id` FOREIGN KEY (`parent_contract_template_id`) REFERENCES `vibe_retail_v1`.`customer`.`contract_template`(`contract_template_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`communication_preference` ADD CONSTRAINT `fk_customer_communication_preference_preference_id` FOREIGN KEY (`preference_id`) REFERENCES `vibe_retail_v1`.`customer`.`preference`(`preference_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` ADD CONSTRAINT `fk_customer_customer_attribute_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`customer` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_retail_v1`.`customer` SET TAGS ('dbx_domain' = 'customer');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` SET TAGS ('dbx_subdomain' = 'identity_master');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Profile ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Store ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `acquisition_channel` SET TAGS ('dbx_business_glossary_term' = 'Customer Acquisition Channel');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `acquisition_channel` SET TAGS ('dbx_value_regex' = 'store|ecommerce|mobile_app|social_media|referral|partner');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `acquisition_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Acquisition Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `ccpa_opt_out_date` SET TAGS ('dbx_business_glossary_term' = 'California Consumer Privacy Act (CCPA) Opt-Out Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Profile Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `customer_type` SET TAGS ('dbx_business_glossary_term' = 'Customer Type Classification');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `customer_type` SET TAGS ('dbx_value_regex' = 'individual|corporate|employee|vip|wholesale');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `customer_type` SET TAGS ('dbx_legal_entity_type_only' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_business_glossary_term' = 'Customer Date of Birth');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Customer Email Address');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `first_name` SET TAGS ('dbx_business_glossary_term' = 'Customer First Name');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `full_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Full Legal Name');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `gdpr_consent_date` SET TAGS ('dbx_business_glossary_term' = 'General Data Protection Regulation (GDPR) Consent Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `gender` SET TAGS ('dbx_business_glossary_term' = 'Customer Gender');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `gender` SET TAGS ('dbx_value_regex' = 'male|female|non_binary|prefer_not_to_say|other|unknown');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Profile Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `last_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Last Name');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_business_glossary_term' = 'Customer Lifecycle Stage');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `loyalty_tier` SET TAGS ('dbx_business_glossary_term' = 'Customer Loyalty Tier');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `loyalty_tier` SET TAGS ('dbx_value_regex' = 'bronze|silver|gold|platinum|diamond');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `mdm_confidence_score` SET TAGS ('dbx_business_glossary_term' = 'Master Data Management (MDM) Golden Record Confidence Score');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `mdm_last_match_date` SET TAGS ('dbx_business_glossary_term' = 'Master Data Management (MDM) Last Match Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `mdm_source_system` SET TAGS ('dbx_business_glossary_term' = 'Master Data Management (MDM) Source System');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `middle_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Middle Name');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `mobile_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Mobile Phone Number');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `nationality` SET TAGS ('dbx_business_glossary_term' = 'Customer Nationality');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `nationality` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Phone Number');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `preferred_contact_method` SET TAGS ('dbx_value_regex' = 'email|phone|sms|mail|none');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `preferred_language` SET TAGS ('dbx_business_glossary_term' = 'Customer Preferred Language');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `preferred_language` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `profile_status` SET TAGS ('dbx_business_glossary_term' = 'Customer Profile Status');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `profile_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|blocked|closed');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_scd2' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_scd2' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` SET TAGS ('dbx_subdomain' = 'identity_master');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Account Manager ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Store ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `account_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `account_status` SET TAGS ('dbx_value_regex' = 'active|suspended|closed|pending_activation|frozen|dormant');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `account_type` SET TAGS ('dbx_value_regex' = 'personal|business|employee|wholesale');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `b2b_pricing_flag` SET TAGS ('dbx_business_glossary_term' = 'Business-to-Business (B2B) Pricing Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `close_date` SET TAGS ('dbx_business_glossary_term' = 'Account Close Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `credit_limit` SET TAGS ('dbx_business_glossary_term' = 'Account Credit Limit');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `employee_discount_eligible` SET TAGS ('dbx_business_glossary_term' = 'Employee Discount Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `loyalty_program_enrolled` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Program Enrolled Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Account Notes');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `open_date` SET TAGS ('dbx_business_glossary_term' = 'Account Open Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `preferred_channel` SET TAGS ('dbx_value_regex' = 'in_store|online|mobile_app|call_center');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `suspension_date` SET TAGS ('dbx_business_glossary_term' = 'Account Suspension Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `suspension_reason` SET TAGS ('dbx_business_glossary_term' = 'Account Suspension Reason');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `tax_exempt_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Tax Exempt Certificate Expiry Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `tier` SET TAGS ('dbx_value_regex' = 'standard|premium|vip|platinum');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_scd2' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_scd2' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` SET TAGS ('dbx_subdomain' = 'identity_master');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `household_id` SET TAGS ('dbx_business_glossary_term' = 'Household Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Store Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Member Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `combined_cltv` SET TAGS ('dbx_business_glossary_term' = 'Combined Customer Lifetime Value (CLTV)');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `communication_preference` SET TAGS ('dbx_value_regex' = 'email|sms|mail|phone|none');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `data_sharing_consent` SET TAGS ('dbx_business_glossary_term' = 'Data Sharing Consent Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `estimated_income_band` SET TAGS ('dbx_value_regex' = 'under_25k|25k_50k|50k_75k|75k_100k|100k_150k|over_150k');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `external_household_code` SET TAGS ('dbx_business_glossary_term' = 'External Household Identifier (ID)');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `household_status` SET TAGS ('dbx_value_regex' = 'active|inactive|merged|split|pending');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `household_type` SET TAGS ('dbx_value_regex' = 'single_person|nuclear_family|extended_family|multi_generational|shared_residence|other');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `loyalty_tier` SET TAGS ('dbx_value_regex' = 'bronze|silver|gold|platinum|vip');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `marketing_opt_in` SET TAGS ('dbx_business_glossary_term' = 'Marketing Opt-In Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `preferred_channel` SET TAGS ('dbx_value_regex' = 'in_store|online|mobile_app|call_center');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `primary_language` SET TAGS ('dbx_value_regex' = '^[a-z]{2}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `segment` SET TAGS ('dbx_business_glossary_term' = 'Household Segment');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `size` SET TAGS ('dbx_business_glossary_term' = 'Household Size');
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State or Province');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` SET TAGS ('dbx_subdomain' = 'identity_master');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Account Manager Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Corporate Account ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `annual_spend_tier` SET TAGS ('dbx_value_regex' = 'tier_1|tier_2|tier_3|tier_4|tier_5');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `credit_limit` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit Amount');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `credit_status` SET TAGS ('dbx_value_regex' = 'approved|pending|declined|under_review|suspended');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `dba_name` SET TAGS ('dbx_business_glossary_term' = 'Doing Business As (DBA) Name');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `duns_number` SET TAGS ('dbx_business_glossary_term' = 'Data Universal Numbering System (DUNS) Number');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `duns_number` SET TAGS ('dbx_value_regex' = '^[0-9]{9}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `industry_classification_naics` SET TAGS ('dbx_business_glossary_term' = 'North American Industry Classification System (NAICS) Code');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `industry_classification_naics` SET TAGS ('dbx_value_regex' = '^[0-9]{6}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `industry_classification_sic` SET TAGS ('dbx_business_glossary_term' = 'Standard Industrial Classification (SIC) Code');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `industry_classification_sic` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `preferred_delivery_method` SET TAGS ('dbx_value_regex' = 'standard_ground|expedited|next_day|freight|customer_pickup');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_business_glossary_term' = 'Tax Identification Number (TIN) / Employer Identification Number (EIN)');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_value_regex' = '^[0-9]{2}-[0-9]{7}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` SET TAGS ('dbx_subdomain' = 'identity_master');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ALTER COLUMN `contact_status` SET TAGS ('dbx_value_regex' = 'active|inactive|bounced|invalid|suppressed|pending_verification');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ALTER COLUMN `is_primary` SET TAGS ('dbx_business_glossary_term' = 'Is Primary Contact');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ALTER COLUMN `language_preference` SET TAGS ('dbx_value_regex' = '^[a-z]{2}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` SET TAGS ('dbx_subdomain' = 'identity_master');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `address_status` SET TAGS ('dbx_value_regex' = 'active|inactive|archived|pending_verification');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `address_type` SET TAGS ('dbx_value_regex' = 'billing|shipping|home|work|store_pickup|mailing');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `is_default_billing` SET TAGS ('dbx_business_glossary_term' = 'Is Default Billing Address');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `is_default_shipping` SET TAGS ('dbx_business_glossary_term' = 'Is Default Shipping Address');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `line_1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `line_2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `nickname` SET TAGS ('dbx_business_glossary_term' = 'Address Nickname');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `po_box_flag` SET TAGS ('dbx_business_glossary_term' = 'Post Office (PO) Box Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `residential_flag` SET TAGS ('dbx_business_glossary_term' = 'Residential Address Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `standardization_flag` SET TAGS ('dbx_business_glossary_term' = 'Postal Standardization Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State or Province');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `validation_status` SET TAGS ('dbx_business_glossary_term' = 'Address Validation Status');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `validation_status` SET TAGS ('dbx_value_regex' = 'validated|unvalidated|invalid|pending');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `verification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Address Verification Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`preference` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`preference` SET TAGS ('dbx_subdomain' = 'engagement_preferences');
ALTER TABLE `vibe_retail_v1`.`customer`.`identity_link` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`identity_link` SET TAGS ('dbx_subdomain' = 'identity_master');
ALTER TABLE `vibe_retail_v1`.`customer`.`identity_link` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`identity_link` ALTER COLUMN `channel` SET TAGS ('dbx_value_regex' = 'in_store|online|mobile|call_center|social_media');
ALTER TABLE `vibe_retail_v1`.`customer`.`identity_link` ALTER COLUMN `consent_status` SET TAGS ('dbx_value_regex' = 'granted|denied|pending|withdrawn|expired');
ALTER TABLE `vibe_retail_v1`.`customer`.`identity_link` ALTER COLUMN `is_primary_identifier` SET TAGS ('dbx_business_glossary_term' = 'Is Primary Identifier Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`identity_link` ALTER COLUMN `link_method` SET TAGS ('dbx_value_regex' = 'deterministic|probabilistic|manual|third_party');
ALTER TABLE `vibe_retail_v1`.`customer`.`identity_link` ALTER COLUMN `link_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_review|rejected|superseded');
ALTER TABLE `vibe_retail_v1`.`customer`.`identity_link` ALTER COLUMN `validation_status` SET TAGS ('dbx_value_regex' = 'validated|unvalidated|failed|pending');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` SET TAGS ('dbx_subdomain' = 'engagement_preferences');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `email_send_id` SET TAGS ('dbx_business_glossary_term' = 'Email Send Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `pos_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Transaction ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Agent ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `rma_id` SET TAGS ('dbx_business_glossary_term' = 'Returns Rma Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `service_case_id` SET TAGS ('dbx_business_glossary_term' = 'Case ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `web_session_id` SET TAGS ('dbx_business_glossary_term' = 'Session ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `channel` SET TAGS ('dbx_business_glossary_term' = 'Interaction Channel');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `delivery_status` SET TAGS ('dbx_business_glossary_term' = 'Message Delivery Status');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `delivery_status` SET TAGS ('dbx_value_regex' = 'delivered|opened|clicked|bounced|failed|pending');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `device_type` SET TAGS ('dbx_value_regex' = 'desktop|mobile|tablet|kiosk|pos_terminal|other');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `direction` SET TAGS ('dbx_business_glossary_term' = 'Interaction Direction');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `direction` SET TAGS ('dbx_value_regex' = 'inbound|outbound');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `duration_seconds` SET TAGS ('dbx_business_glossary_term' = 'Interaction Duration (Seconds)');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `ip_address` SET TAGS ('dbx_business_glossary_term' = 'IP (Internet Protocol) Address');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `landing_page_url` SET TAGS ('dbx_business_glossary_term' = 'Landing Page URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Interaction Notes');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `nps_score` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS)');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `outcome` SET TAGS ('dbx_business_glossary_term' = 'Interaction Outcome');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `referrer_url` SET TAGS ('dbx_business_glossary_term' = 'Referrer URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `sms_delivered_flag` SET TAGS ('dbx_business_glossary_term' = 'SMS (Short Message Service) Delivered Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `subject` SET TAGS ('dbx_business_glossary_term' = 'Interaction Subject');
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` SET TAGS ('dbx_subdomain' = 'engagement_preferences');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `wishlist_id` SET TAGS ('dbx_business_glossary_term' = 'Wishlist Identifier');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Registry Consultant Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `channel` SET TAGS ('dbx_business_glossary_term' = 'Wishlist Creation Channel');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `channel` SET TAGS ('dbx_value_regex' = 'web|mobile_app|mobile_web|in_store_kiosk|call_center');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `co_registrant_first_name` SET TAGS ('dbx_business_glossary_term' = 'Co-Registrant First Name');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `co_registrant_last_name` SET TAGS ('dbx_business_glossary_term' = 'Co-Registrant Last Name');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `conversion_rate_percentage` SET TAGS ('dbx_business_glossary_term' = 'Wishlist Conversion Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `conversion_status` SET TAGS ('dbx_business_glossary_term' = 'Wishlist Conversion Status');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `conversion_status` SET TAGS ('dbx_value_regex' = 'unconverted|partially_converted|fully_converted');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Wishlist Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `device_type` SET TAGS ('dbx_value_regex' = 'desktop|tablet|smartphone|kiosk|unknown');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `event_date` SET TAGS ('dbx_business_glossary_term' = 'Wishlist Event Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `external_wishlist_code` SET TAGS ('dbx_business_glossary_term' = 'External Wishlist ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `is_default_flag` SET TAGS ('dbx_business_glossary_term' = 'Is Default Wishlist Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Wishlist Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `notification_frequency` SET TAGS ('dbx_value_regex' = 'immediate|daily|weekly|event_based|disabled');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `registry_number` SET TAGS ('dbx_business_glossary_term' = 'Gift Registry Number');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `share_count` SET TAGS ('dbx_business_glossary_term' = 'Wishlist Share Count');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `share_url` SET TAGS ('dbx_business_glossary_term' = 'Wishlist Share URL (Uniform Resource Locator)');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `total_value_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Wishlist Value Amount');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `view_count` SET TAGS ('dbx_business_glossary_term' = 'Wishlist View Count');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `visibility` SET TAGS ('dbx_business_glossary_term' = 'Wishlist Visibility');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `visibility` SET TAGS ('dbx_value_regex' = 'private|shared|public|registry');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `wishlist_status` SET TAGS ('dbx_value_regex' = 'active|archived|deleted|expired');
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ALTER COLUMN `wishlist_type` SET TAGS ('dbx_value_regex' = 'standard|gift_registry|save_for_later|favorites|private_collection|shared_list');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` SET TAGS ('dbx_subdomain' = 'privacy_compliance');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Processor ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Membership Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `appeal_outcome` SET TAGS ('dbx_value_regex' = 'upheld|overturned|pending|withdrawn');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `data_export_format` SET TAGS ('dbx_value_regex' = 'JSON|CSV|PDF|XML');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `outcome` SET TAGS ('dbx_business_glossary_term' = 'Request Outcome');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `outcome` SET TAGS ('dbx_value_regex' = 'fulfilled|partially_fulfilled|denied|withdrawn');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `regulatory_framework` SET TAGS ('dbx_value_regex' = 'GDPR|CCPA|LGPD|PIPEDA|APPI|POPIA');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `request_number` SET TAGS ('dbx_business_glossary_term' = 'Privacy Request Number');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `request_number` SET TAGS ('dbx_value_regex' = '^PR-[0-9]{10}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `request_status` SET TAGS ('dbx_business_glossary_term' = 'Privacy Request Status');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `request_type` SET TAGS ('dbx_business_glossary_term' = 'Privacy Request Type');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `request_type` SET TAGS ('dbx_value_regex' = 'access|erasure|portability|rectification|opt_out_sale|restriction');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `submission_channel` SET TAGS ('dbx_value_regex' = 'web_portal|mobile_app|email|phone|in_store|postal_mail');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `verification_method` SET TAGS ('dbx_value_regex' = 'email_token|sms_code|account_login|document_upload|phone_callback|in_person');
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ALTER COLUMN `verification_status` SET TAGS ('dbx_value_regex' = 'not_started|pending|verified|failed|exempted');
ALTER TABLE `vibe_retail_v1`.`customer`.`issuance` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`issuance` SET TAGS ('dbx_subdomain' = 'privacy_compliance');
ALTER TABLE `vibe_retail_v1`.`customer`.`issuance` SET TAGS ('dbx_association_edges' = 'customer.profile,promotion.coupon');
ALTER TABLE `vibe_retail_v1`.`customer`.`issuance` ALTER COLUMN `issuance_id` SET TAGS ('dbx_business_glossary_term' = 'Issuance Identifier');
ALTER TABLE `vibe_retail_v1`.`customer`.`issuance` ALTER COLUMN `coupon_id` SET TAGS ('dbx_business_glossary_term' = 'Issuance - Coupon Id');
ALTER TABLE `vibe_retail_v1`.`customer`.`issuance` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Issuance - Profile Id');
ALTER TABLE `vibe_retail_v1`.`customer`.`issuance` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Redemption Location');
ALTER TABLE `vibe_retail_v1`.`customer`.`issuance` ALTER COLUMN `personalization_discount_override` SET TAGS ('dbx_business_glossary_term' = 'Personalized Discount Override');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` SET TAGS ('dbx_subdomain' = 'commercial_relationships');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` SET TAGS ('dbx_association_edges' = 'customer.segment,marketing.campaign');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ALTER COLUMN `targeting_id` SET TAGS ('dbx_business_glossary_term' = 'Targeting Record Identifier');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Targeting - Campaign Id');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ALTER COLUMN `segment_id` SET TAGS ('dbx_business_glossary_term' = 'Targeting - Customer Segment Id');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ALTER COLUMN `activation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Segment Activation Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ALTER COLUMN `actual_reached_count` SET TAGS ('dbx_business_glossary_term' = 'Actual Segment Reach');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ALTER COLUMN `budget_allocation_amount` SET TAGS ('dbx_business_glossary_term' = 'Segment Budget Allocation');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ALTER COLUMN `conversion_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Segment Conversion Rate');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ALTER COLUMN `deactivation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Segment Deactivation Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ALTER COLUMN `estimated_reach` SET TAGS ('dbx_business_glossary_term' = 'Estimated Segment Reach');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Targeting Priority Level');
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ALTER COLUMN `response_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Segment Response Rate');
ALTER TABLE `vibe_retail_v1`.`customer`.`segment_banner_targeting` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`segment_banner_targeting` SET TAGS ('dbx_subdomain' = 'commercial_relationships');
ALTER TABLE `vibe_retail_v1`.`customer`.`segment_banner_targeting` SET TAGS ('dbx_association_edges' = 'customer.segment,ecommerce.promotion_banner');
ALTER TABLE `vibe_retail_v1`.`customer`.`segment_banner_targeting` ALTER COLUMN `segment_id` SET TAGS ('dbx_business_glossary_term' = 'Segment Banner Targeting - Customer Segment Id');
ALTER TABLE `vibe_retail_v1`.`customer`.`segment_banner_targeting` ALTER COLUMN `promotion_banner_id` SET TAGS ('dbx_business_glossary_term' = 'Segment Banner Targeting - Promotion Banner Id');
ALTER TABLE `vibe_retail_v1`.`customer`.`client_relationship` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`client_relationship` SET TAGS ('dbx_subdomain' = 'commercial_relationships');
ALTER TABLE `vibe_retail_v1`.`customer`.`client_relationship` SET TAGS ('dbx_association_edges' = 'customer.profile,workforce.associate');
ALTER TABLE `vibe_retail_v1`.`customer`.`client_relationship` ALTER COLUMN `client_relationship_id` SET TAGS ('dbx_business_glossary_term' = 'Client Relationship Identifier');
ALTER TABLE `vibe_retail_v1`.`customer`.`client_relationship` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Client Relationship - Associate Id');
ALTER TABLE `vibe_retail_v1`.`customer`.`client_relationship` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Client Relationship - Profile Id');
ALTER TABLE `vibe_retail_v1`.`customer`.`client_relationship` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`client_relationship` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Relationship End Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`client_relationship` ALTER COLUMN `primary_contact_flag` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Indicator');
ALTER TABLE `vibe_retail_v1`.`customer`.`client_relationship` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Relationship Start Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`client_relationship` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`b2b_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`b2b_contract` SET TAGS ('dbx_subdomain' = 'commercial_relationships');
ALTER TABLE `vibe_retail_v1`.`customer`.`b2b_contract` ALTER COLUMN `b2b_contract_id` SET TAGS ('dbx_business_glossary_term' = 'B2B Contract Identifier');
ALTER TABLE `vibe_retail_v1`.`customer`.`contract_template` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`contract_template` SET TAGS ('dbx_subdomain' = 'commercial_relationships');
ALTER TABLE `vibe_retail_v1`.`customer`.`contract_template` ALTER COLUMN `contract_template_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Template Identifier');
ALTER TABLE `vibe_retail_v1`.`customer`.`communication_preference` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`communication_preference` SET TAGS ('dbx_subdomain' = 'engagement_preferences');
ALTER TABLE `vibe_retail_v1`.`customer`.`communication_preference` ALTER COLUMN `language` SET TAGS ('dbx_business_glossary_term' = 'Preference Language');
ALTER TABLE `vibe_retail_v1`.`customer`.`communication_preference` ALTER COLUMN `language` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`communication_preference` ALTER COLUMN `opt_out_flag` SET TAGS ('dbx_business_glossary_term' = 'Opt-Out Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`communication_preference` ALTER COLUMN `opt_out_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Opt-Out Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`communication_preference` ALTER COLUMN `preference_source` SET TAGS ('dbx_value_regex' = 'self_declared|behavioral|inferred|third_party|imported');
ALTER TABLE `vibe_retail_v1`.`customer`.`communication_preference` ALTER COLUMN `preference_status` SET TAGS ('dbx_value_regex' = 'active|inactive|expired|superseded');
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` SET TAGS ('dbx_subdomain' = 'engagement_preferences');
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` ALTER COLUMN `subcategory` SET TAGS ('dbx_business_glossary_term' = 'Preference Subcategory');
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` ALTER COLUMN `verification_status` SET TAGS ('dbx_value_regex' = 'verified|unverified|pending_verification|verification_failed');
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Preference Version');
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` ALTER COLUMN `weight` SET TAGS ('dbx_business_glossary_term' = 'Preference Weight');
