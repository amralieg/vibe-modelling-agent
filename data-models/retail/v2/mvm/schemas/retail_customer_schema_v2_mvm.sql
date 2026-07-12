-- Schema for Domain: customer | Business: Retail | Version: v2_mvm
-- Generated on: 2026-07-12 15:25:59

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`customer` COMMENT 'Single source of truth for all customer identity, profiles, households, segments (B2C and B2B), contact information, preferences, and RFM (Recency Frequency Monetary) analytics. Manages customer lifecycle, NPS scores, CLTV (Customer Lifetime Value), CAC (Customer Acquisition Cost), consent/privacy preferences, and omnichannel interaction history. Supports personalized clienteling and customer recognition across POS, e-commerce, and mobile.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`profile` (
    `profile_id` BIGINT COMMENT 'Unique identifier for the customer profile. Primary key for the golden customer record in the customer master data system.',
    `location_id` BIGINT COMMENT 'Identifier of the customers preferred or most frequently visited store location, used for localized assortment and clienteling.',
    `brand_id` BIGINT COMMENT 'Foreign key linking to product.product_brand. Business justification: Retail CRM brand affinity profiling: links a customers preferred brand to their profile for personalization engines, loyalty targeting, and marketing segmentation. A domain expert in retail CRM would',
    `item_hierarchy_id` BIGINT COMMENT 'Foreign key linking to product.item_hierarchy. Business justification: Retail customer category affinity: links a customer profile to their preferred product category node for CRM segmentation, targeted email campaigns, and recommendation engine personalization. Retail m',
    `region_id` BIGINT COMMENT 'Foreign key linking to store.region. Business justification: Regional marketing campaigns, loyalty program segmentation, and data privacy compliance (GDPR/CCPA) require assigning customer profiles to a geographic region. store.region carries data_privacy_framew',
    `acquisition_channel` STRING COMMENT 'The channel through which the customer was originally acquired, used for CAC (Customer Acquisition Cost) analysis and channel effectiveness measurement.. Valid values are `store|ecommerce|mobile_app|social_media|referral|partner`',
    `acquisition_date` DATE COMMENT 'Date when the customer first engaged with the business, marking the start of the customer lifecycle.',
    `ccpa_opt_out_date` TIMESTAMP COMMENT 'Timestamp when CCPA opt-out request was processed, required for compliance audit trails.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the customer profile record was first created in the master data management system.',
    `customer_type` STRING COMMENT 'Legal entity type: individual or organization (not role/classification). Valid values are `individual|corporate|employee|vip|wholesale`',
    `date_of_birth` DATE COMMENT 'Date of birth of the customer, used for age verification, lifecycle marketing, and personalized birthday promotions.',
    `effective_end_date` TIMESTAMP COMMENT '',
    `effective_from` TIMESTAMP COMMENT 'SCD2 row effective start date',
    `effective_start_date` TIMESTAMP COMMENT '',
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
    CONSTRAINT pk_profile PRIMARY KEY(`profile_id`)
) COMMENT 'Golden record for every customer (B2C and B2B) served by Retail. Stores core identity attributes sourced from the customer master data system including full legal name, date of birth, gender, preferred language, nationality, customer type (individual/corporate), acquisition channel, CAC, CLTV score, NPS score, lifecycle stage, privacy consent flags (GDPR/CCPA), and golden-record confidence score. This is the single authoritative master entity for all customer identity data across POS, e-commerce, and mobile channels.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`account` (
    `account_id` BIGINT COMMENT 'Unique identifier for the account. Primary key.',
    `address_id` BIGINT COMMENT 'Reference to the default billing address for this account. Used for invoicing, credit checks, and payment processing. Null if no billing address on file.',
    `location_id` BIGINT COMMENT 'Reference to the customers preferred or home store location for in-store pickup, returns, and personalized store-based services. Null if no preference set.',
    `price_list_id` BIGINT COMMENT 'Foreign key linking to pricing.price_list. Business justification: B2B and corporate accounts require contract-specific pricing (volume discounts, negotiated rates, special terms). Account managers assign custom price lists during contract setup. Essential for wholes',
    `price_zone_id` BIGINT COMMENT 'Foreign key linking to pricing.price_zone. Business justification: B2B account management requires explicit price zone assignment for corporate/wholesale accounts (b2b_pricing_flag=true) where negotiated pricing overrides location-derived zones. The accounts by pric',
    `profile_id` BIGINT COMMENT 'Reference to the customer profile who owns this account. One customer may have multiple accounts (e.g., personal and business).',
    `shipping_address_id` BIGINT COMMENT 'Reference to the default shipping address for this account. Used for order fulfillment and delivery. Null if no default shipping address set.',
    `account_number` STRING COMMENT 'Externally-visible unique account number used for customer communication, statements, and customer service lookup. Distinct from internal account_id.. Valid values are `^[A-Z0-9]{8,20}$`',
    `account_status` STRING COMMENT 'Current lifecycle state of the account. Active accounts can transact; suspended accounts are temporarily blocked; closed accounts are permanently terminated; pending_activation awaits customer verification; frozen accounts are under investigation; dormant accounts have no recent activity.. Valid values are `active|suspended|closed|pending_activation|frozen|dormant`',
    `account_type` STRING COMMENT 'Classification of the account indicating the nature of the commercial relationship: personal (B2C consumer), business (B2B corporate), employee (staff discount account), or wholesale (bulk buyer).. Valid values are `personal|business|employee|wholesale`',
    `b2b_pricing_flag` BOOLEAN COMMENT 'Indicates whether this account receives B2B contract pricing instead of standard retail pricing. True for wholesale and corporate accounts; false for consumer accounts.',
    `close_date` DATE COMMENT 'Date when the account was permanently closed. Null for active accounts. Used for churn analysis and account lifecycle reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this account record was first created in the system. Used for audit trail and data lineage tracking.',
    `credit_limit` DECIMAL(18,2) COMMENT 'Maximum credit amount (in base currency) extended to this account for deferred payment or credit purchases. Null for cash-only accounts. Used for credit management and risk assessment.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the accounts base currency (e.g., USD, EUR, GBP). All monetary transactions and balances for this account are denominated in this currency.. Valid values are `^[A-Z]{3}$`',
    `effective_end_date` TIMESTAMP COMMENT '',
    `effective_from` TIMESTAMP COMMENT 'SCD2 row effective start date',
    `effective_start_date` TIMESTAMP COMMENT '',
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
    CONSTRAINT pk_account PRIMARY KEY(`account_id`)
) COMMENT 'Commercial relationship record between a customer and Retail, distinct from profile (identity). Tracks account number, status (active/suspended/closed), open date, tier (standard/premium/VIP), credit limit, preferred store, preferred channel (in-store/online/mobile), default payment method reference, and account-level flags (employee discount eligibility, tax-exempt status, B2B pricing flag). One profile may have multiple accounts (e.g., personal + business). Supports account-level reporting, credit management, and omnichannel preference routing.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`customer`.`contact` (
    `contact_id` BIGINT COMMENT 'Unique identifier for the contact method record. Primary key.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: In B2B retail scenarios, contact persons (buyers, procurement managers, store managers) are associated with corporate accounts. A contact belongs to one account while an account can have many contacts',
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

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_shipping_address_id` FOREIGN KEY (`shipping_address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ADD CONSTRAINT `fk_customer_contact_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ADD CONSTRAINT `fk_customer_contact_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ADD CONSTRAINT `fk_customer_address_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`customer` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_retail_v1`.`customer` SET TAGS ('dbx_domain' = 'customer');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` SET TAGS ('dbx_subdomain' = 'identity_management');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Profile ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Store ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `brand_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Brand Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `item_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Category Item Hierarchy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `region_id` SET TAGS ('dbx_business_glossary_term' = 'Region Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `acquisition_channel` SET TAGS ('dbx_business_glossary_term' = 'Customer Acquisition Channel');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `acquisition_channel` SET TAGS ('dbx_value_regex' = 'store|ecommerce|mobile_app|social_media|referral|partner');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `acquisition_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Acquisition Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `ccpa_opt_out_date` SET TAGS ('dbx_business_glossary_term' = 'California Consumer Privacy Act (CCPA) Opt-Out Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Profile Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `customer_type` SET TAGS ('dbx_business_glossary_term' = 'Customer Type Classification');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `customer_type` SET TAGS ('dbx_value_regex' = 'individual|corporate|employee|vip|wholesale');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `customer_type` SET TAGS ('dbx_legal_entity_type_only' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_business_glossary_term' = 'Customer Date of Birth');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_scd2' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_scd2' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Customer Email Address');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `email_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `first_name` SET TAGS ('dbx_business_glossary_term' = 'Customer First Name');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `first_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `first_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `full_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Full Legal Name');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `full_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `full_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `gdpr_consent_date` SET TAGS ('dbx_business_glossary_term' = 'General Data Protection Regulation (GDPR) Consent Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `gender` SET TAGS ('dbx_business_glossary_term' = 'Customer Gender');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `gender` SET TAGS ('dbx_value_regex' = 'male|female|non_binary|prefer_not_to_say|other|unknown');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `gender` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `gender` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Profile Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `last_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Last Name');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `last_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `last_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `lifecycle_stage` SET TAGS ('dbx_business_glossary_term' = 'Customer Lifecycle Stage');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `loyalty_tier` SET TAGS ('dbx_business_glossary_term' = 'Customer Loyalty Tier');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `loyalty_tier` SET TAGS ('dbx_value_regex' = 'bronze|silver|gold|platinum|diamond');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `mdm_confidence_score` SET TAGS ('dbx_business_glossary_term' = 'Master Data Management (MDM) Golden Record Confidence Score');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `mdm_last_match_date` SET TAGS ('dbx_business_glossary_term' = 'Master Data Management (MDM) Last Match Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `mdm_source_system` SET TAGS ('dbx_business_glossary_term' = 'Master Data Management (MDM) Source System');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `middle_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Middle Name');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `middle_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `middle_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `mobile_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Mobile Phone Number');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `mobile_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `mobile_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `nationality` SET TAGS ('dbx_business_glossary_term' = 'Customer Nationality');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `nationality` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `nationality` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `nationality` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Phone Number');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `preferred_contact_method` SET TAGS ('dbx_value_regex' = 'email|phone|sms|mail|none');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `preferred_language` SET TAGS ('dbx_business_glossary_term' = 'Customer Preferred Language');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `preferred_language` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `profile_status` SET TAGS ('dbx_business_glossary_term' = 'Customer Profile Status');
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ALTER COLUMN `profile_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|blocked|closed');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` SET TAGS ('dbx_subdomain' = 'identity_management');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `address_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `address_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Store ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `price_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Price Zone Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `shipping_address_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `shipping_address_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `account_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `account_status` SET TAGS ('dbx_value_regex' = 'active|suspended|closed|pending_activation|frozen|dormant');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `account_type` SET TAGS ('dbx_value_regex' = 'personal|business|employee|wholesale');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `b2b_pricing_flag` SET TAGS ('dbx_business_glossary_term' = 'Business-to-Business (B2B) Pricing Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `close_date` SET TAGS ('dbx_business_glossary_term' = 'Account Close Date');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `credit_limit` SET TAGS ('dbx_business_glossary_term' = 'Account Credit Limit');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_scd2' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_scd2' = 'true');
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
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` SET TAGS ('dbx_subdomain' = 'communication_channels');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ALTER COLUMN `contact_status` SET TAGS ('dbx_value_regex' = 'active|inactive|bounced|invalid|suppressed|pending_verification');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ALTER COLUMN `is_primary` SET TAGS ('dbx_business_glossary_term' = 'Is Primary Contact');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ALTER COLUMN `language_preference` SET TAGS ('dbx_value_regex' = '^[a-z]{2}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`contact` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` SET TAGS ('dbx_subdomain' = 'communication_channels');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `address_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `address_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `address_status` SET TAGS ('dbx_value_regex' = 'active|inactive|archived|pending_verification');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `address_status` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `address_status` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `address_type` SET TAGS ('dbx_value_regex' = 'billing|shipping|home|work|store_pickup|mailing');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `is_default_billing` SET TAGS ('dbx_business_glossary_term' = 'Is Default Billing Address');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `is_default_shipping` SET TAGS ('dbx_business_glossary_term' = 'Is Default Shipping Address');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `line_1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `line_2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `military_address_flag` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `military_address_flag` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `nickname` SET TAGS ('dbx_business_glossary_term' = 'Address Nickname');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `po_box_flag` SET TAGS ('dbx_business_glossary_term' = 'Post Office (PO) Box Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `po_box_flag` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `po_box_flag` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `residential_flag` SET TAGS ('dbx_business_glossary_term' = 'Residential Address Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `standardization_flag` SET TAGS ('dbx_business_glossary_term' = 'Postal Standardization Flag');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State or Province');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `validation_status` SET TAGS ('dbx_business_glossary_term' = 'Address Validation Status');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `validation_status` SET TAGS ('dbx_value_regex' = 'validated|unvalidated|invalid|pending');
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ALTER COLUMN `verification_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Address Verification Timestamp');
