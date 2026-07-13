-- Schema for Domain: customer | Business:  | Version: v2_ecm
-- Generated on: 2026-07-13 15:03:49

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`customer` COMMENT 'SSOT for all customer identities including retail buyers, fleet operators, corporate accounts, and government entities. Manages customer profiles, contact information, preferences, vehicle ownership history, loyalty program membership, household linkages, and customer segmentation. Tracks NPS (Net Promoter Score), CLTV (Customer Lifetime Value), and customer journey touchpoints. Supports both B2C and B2B customer types with unified identity management. Integrates with Salesforce Automotive Cloud.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`party` (
    `party_id` BIGINT COMMENT 'Unique system-generated identifier for the party record.',
    `loyalty_program_id` BIGINT COMMENT 'Identifier of the loyalty program the party is enrolled in.',
    `address_line1` STRING COMMENT 'First line of the partys primary mailing address.',
    `address_line2` STRING COMMENT 'Second line of the partys primary mailing address (optional).',
    `address_type` STRING COMMENT 'Classification of the primary address (e.g., billing, shipping).. Valid values are `billing|shipping|mailing|primary`',
    `city` STRING COMMENT 'City component of the primary mailing address.',
    `communication_preference` STRING COMMENT 'Preferred channel for outbound communications.. Valid values are `email|sms|phone|mail`',
    `country_code` STRING COMMENT 'Three‑letter ISO country code for the primary mailing address.. Valid values are `^[A-Z]{3}$`',
    `credit_rating` STRING COMMENT 'External credit rating assigned to the party for risk assessment.. Valid values are `AAA|AA|A|BBB|BB|B`',
    `customer_lifetime_value` DECIMAL(18,2) COMMENT 'Estimated total net revenue expected from the party over the relationship.',
    `customer_segment` STRING COMMENT 'Business segment classification for analytics and targeting.. Valid values are `mass_market|premium|fleet|government|enterprise`',
    `data_residency_region` STRING COMMENT 'Geographic region where the partys personal data is stored to satisfy data‑sovereignty requirements.',
    `date_of_birth` DATE COMMENT 'Birth date of an individual party, used for age verification and KYC.',
    `email_address` STRING COMMENT 'Primary email address for electronic communication.. Valid values are `^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$`',
    `external_reference_code` STRING COMMENT 'Additional external reference used for cross‑system reconciliation.',
    `gdpr_consent_email` BOOLEAN COMMENT 'Indicates whether the party has consented to receive email communications under GDPR.',
    `gdpr_consent_sms` BOOLEAN COMMENT 'Indicates whether the party has consented to receive SMS communications under GDPR.',
    `incorporation_date` DATE COMMENT 'Date the organization was legally formed.',
    `industry_classification` STRING COMMENT 'Standard industry code (NAICS or SIC) describing the partys primary business.',
    `is_tax_exempt` BOOLEAN COMMENT 'Indicates whether the party is exempt from sales tax.',
    `kyc_status` STRING COMMENT 'Current status of KYC verification for the party.. Valid values are `pending|verified|rejected`',
    `last_verified_date` DATE COMMENT 'Date when the partys information was last validated against source data.',
    `legal_name` STRING COMMENT 'Full legal name of the individual or organization as recorded for contracts and compliance.',
    `lifecycle_status` STRING COMMENT 'Current lifecycle stage of the party within the business relationship.. Valid values are `prospect|active|inactive|churned|suspended`',
    `loyalty_tier` STRING COMMENT 'Current tier level within the loyalty program.. Valid values are `bronze|silver|gold|platinum`',
    `marketing_opt_in` BOOLEAN COMMENT 'Indicates whether the party has consented to receive marketing communications.',
    `net_promoter_score` STRING COMMENT 'Latest NPS rating captured for the party.',
    `notes` STRING COMMENT 'Free‑form notes entered by business users about the party.',
    `onboarding_channel` STRING COMMENT 'Channel through which the party was onboarded.. Valid values are `online|branch|dealer|partner`',
    `onboarding_date` DATE COMMENT 'Date the party was first created in the system.',
    `party_type` STRING COMMENT 'Indicates whether the party is an individual customer or an organization (e.g., fleet operator, dealer).. Valid values are `individual|organization`',
    `phone_number` STRING COMMENT 'Primary telephone number for voice or SMS contact.',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the primary mailing address.',
    `preferred_currency` STRING COMMENT 'ISO 4217 currency code the party prefers for billing and pricing.',
    `preferred_language` STRING COMMENT 'ISO 639‑1 language code for the partys preferred communication language.',
    `primary_contact_method` STRING COMMENT 'Method most frequently used to reach the party.. Valid values are `email|phone|mail`',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the party record was first created in the lakehouse.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the party record.',
    `registration_number` STRING COMMENT 'Official registration number for an organization (e.g., corporate registration, dealer license).',
    `source_system_code` STRING COMMENT 'Unique identifier of the party in the source system.',
    `state_province` STRING COMMENT 'State or province component of the primary mailing address.',
    `tax_exempt_reason` STRING COMMENT 'Reason or code for tax exemption, if applicable.',
    `tax_identification_number` STRING COMMENT 'Government‑issued tax identifier (e.g., EIN, VAT) for the party.',
    `trade_name` STRING COMMENT 'Doing‑business‑as name or brand name used by the organization.',
    CONSTRAINT pk_party PRIMARY KEY(`party_id`)
) COMMENT 'SSOT master entity for all customer identities served by Automotive — retail buyers (B2C), fleet operators, corporate accounts, government entities, and dealer principals. Stores the unified identity record including party type (individual/organization), legal name, tax identification, registration number, preferred language, preferred currency, date of birth (for individuals), incorporation date (for organizations), industry classification (NAICS/SIC), credit rating, KYC status, GDPR consent flags, data residency region, source system (Salesforce Automotive Cloud party ID), onboarding channel, onboarding date, lifecycle status (prospect/active/inactive/churned), and last verified date. This is the anchor entity for all customer-domain relationships.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`individual` (
    `individual_id` BIGINT COMMENT 'Unique system-generated identifier for the individual.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer the individual prefers for service or purchase.',
    `party_id` BIGINT COMMENT 'add column party_id (BIGINT) with FK to customer.party.party_id - individual is a subtype of party and must reference the parent party record',
    `primary_dealership_id` BIGINT COMMENT 'Identifier of the dealer the individual prefers for service or purchase.',
    `dealer_contact_id` BIGINT COMMENT 'Unique identifier of the individual in Salesforce Automotive Cloud.',
    `address_line1` STRING COMMENT 'First line of the individuals street address.',
    `address_line2` STRING COMMENT 'Second line of the street address (apartment, suite, etc.).',
    `annual_income_band` STRING COMMENT 'Income range band used for segmentation and marketing.. Valid values are `0-25k|25k-50k|50k-75k|75k-100k|100k-150k|150k+`',
    `city` STRING COMMENT 'City component of the individuals mailing address.',
    `cltv_estimate` DECIMAL(18,2) COMMENT 'Estimated total future revenue attributable to the individual.',
    `consent_timestamp` TIMESTAMP COMMENT 'Timestamp when the individual gave marketing consent.',
    `country_code` STRING COMMENT 'Three‑letter country code of the mailing address.',
    `country_of_residence` STRING COMMENT 'Country where the individual currently resides.',
    `customer_type` STRING COMMENT 'Classification of the individual as B2C, B2B, government, or fleet.. Valid values are `b2c|b2b|government|fleet`',
    `date_of_birth` DATE COMMENT 'Birth date of the individual, used for age‑based analytics and compliance.',
    `driver_license_expiry` DATE COMMENT 'Expiration date of the driver license.',
    `driver_license_number` STRING COMMENT 'Government‑issued driver license identifier.',
    `driver_license_state` STRING COMMENT 'State or province that issued the driver license.',
    `education_level` STRING COMMENT 'Highest completed education level of the individual.. Valid values are `high_school|associate|bachelor|master|doctorate|other`',
    `email_address` STRING COMMENT 'Primary email address for electronic communications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `employment_status` STRING COMMENT 'Current employment situation of the individual.. Valid values are `employed|unemployed|student|retired|self_employed|other`',
    `first_name` STRING COMMENT 'Given name of the individual.',
    `gender` STRING COMMENT 'Self‑identified gender of the individual.. Valid values are `male|female|other|prefer_not_to_say`',
    `household_id` BIGINT COMMENT 'Identifier linking individuals belonging to the same household.',
    `individual_status` STRING COMMENT 'Current lifecycle status of the individual record.. Valid values are `active|inactive|suspended|prospect|deceased`',
    `last_name` STRING COMMENT 'Family name or surname of the individual.',
    `last_purchase_date` DATE COMMENT 'Date of the most recent vehicle or service purchase.',
    `loyalty_tier` STRING COMMENT 'Current loyalty program tier of the individual.. Valid values are `bronze|silver|gold|platinum|elite`',
    `marital_status` STRING COMMENT 'Current marital status of the individual.. Valid values are `single|married|divorced|widowed|partnered|prefer_not_to_say`',
    `marketing_opt_in_email` BOOLEAN COMMENT 'True if the individual has consented to receive marketing emails.',
    `marketing_opt_in_phone` BOOLEAN COMMENT 'True if the individual has consented to receive marketing phone calls.',
    `marketing_opt_in_sms` BOOLEAN COMMENT 'True if the individual has consented to receive marketing SMS messages.',
    `middle_name` STRING COMMENT 'Middle name or initial of the individual, if any.',
    `nationality` STRING COMMENT 'Country of citizenship of the individual.',
    `nps_score` STRING COMMENT 'Latest NPS rating provided by the individual (‑100 to 100).',
    `occupation` STRING COMMENT 'Primary occupation or job title of the individual.',
    `phone_number` STRING COMMENT 'Primary telephone number for voice contact.',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the mailing address.',
    `preferred_contact_method` STRING COMMENT 'Individuals preferred channel for communications.. Valid values are `email|phone|sms|mail|app_notification`',
    `primary_spoken_language` STRING COMMENT 'ISO 639‑1 code of the individuals primary language.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the individual record was first created.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the individual record.',
    `segment` STRING COMMENT 'Business segment used for marketing and analytics (e.g., luxury, economy).',
    `state_province` STRING COMMENT 'State or province component of the mailing address.',
    `suffix` STRING COMMENT 'Suffix such as Jr., Sr., III, if applicable.',
    `vehicle_ownership_count` STRING COMMENT 'Number of vehicles currently owned by the individual.',
    CONSTRAINT pk_individual PRIMARY KEY(`individual_id`)
) COMMENT 'B2C retail customer profile extending the party master for natural persons. Captures personal identity attributes: first name, middle name, last name, suffix, gender, marital status, employment status, occupation, annual income band, education level, driver license number, driver license state/country, driver license expiry, primary spoken language, nationality, country of residence, household_id (FK to household), loyalty tier, NPS score (latest), CLTV estimate, preferred contact method, marketing opt-in flags, and Salesforce Contact ID. Supports personalized marketing, loyalty management, and customer journey analytics for retail vehicle buyers.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`organization_account` (
    `organization_account_id` BIGINT COMMENT 'Unique surrogate key for the organization account record.',
    `parent_organization_account_id` BIGINT COMMENT 'Identifier of the parent organization in corporate hierarchy, if applicable.',
    `account_tier` STRING COMMENT 'Tier classification of the account based on strategic importance.. Valid values are `strategic|key|standard`',
    `accounts_payable_contact_email` STRING COMMENT 'Email address of the accounts payable contact.',
    `accounts_payable_contact_name` STRING COMMENT 'Name of the accounts payable contact.',
    `accounts_payable_contact_phone` STRING COMMENT 'Phone number of the accounts payable contact.',
    `address_line1` STRING COMMENT 'First line of the organizations primary address.',
    `address_line2` STRING COMMENT 'Second line of the organizations primary address.',
    `annual_revenue` DECIMAL(18,2) COMMENT 'Annual revenue of the organization in US dollars.',
    `city` STRING COMMENT 'City of the organizations primary address.',
    `classification` STRING COMMENT 'Broad classification of the organization account.. Valid values are `corporate|fleet|government|leasing`',
    `contract_vehicle_type` STRING COMMENT 'Contract vehicle type used for government procurement.. Valid values are `GSA|state|none`',
    `country` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the organizations primary address.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the organization account record was created.',
    `credit_limit` DECIMAL(18,2) COMMENT 'Maximum credit amount extended to the organization.',
    `dba_name` STRING COMMENT 'Trade name under which the organization operates.',
    `duns_number` STRING COMMENT 'Unique DUNS identifier for the organization.',
    `effective_from` DATE COMMENT 'Date when the account became effective.',
    `effective_until` DATE COMMENT 'Date when the account expires or is terminated, if applicable.',
    `fleet_size` STRING COMMENT 'Number of vehicles owned or managed by the organization.',
    `government_entity_type` STRING COMMENT 'Type of government entity, if applicable.. Valid values are `federal|state|municipal|private`',
    `industry_codes` STRING COMMENT 'Additional industry-specific codes (e.g., CAGE, NCAGE).',
    `legal_entity_name` STRING COMMENT 'Full legal name of the organization.',
    `naics_code` STRING COMMENT 'North American Industry Classification System code for the organization.',
    `number_of_employees` STRING COMMENT 'Total number of employees in the organization.',
    `organization_account_status` STRING COMMENT 'Current lifecycle status of the organization account.. Valid values are `active|inactive|suspended|pending|closed`',
    `payment_terms` STRING COMMENT 'Standard payment terms agreed with the organization.. Valid values are `net_30|net_45|net_60|due_on_receipt|custom`',
    `postal_code` STRING COMMENT 'Postal code of the organizations primary address.',
    `preferred_oem_programs` STRING COMMENT 'Comma-separated list of preferred OEM programs for the organization.',
    `primary_contact_email` STRING COMMENT 'Primary email address for general communications with the organization.',
    `primary_contact_phone` STRING COMMENT 'Primary phone number for the organization.',
    `procurement_contact_email` STRING COMMENT 'Email address of the procurement contact.',
    `procurement_contact_name` STRING COMMENT 'Name of the primary procurement contact for the organization.',
    `procurement_contact_phone` STRING COMMENT 'Phone number of the procurement contact.',
    `sap_customer_number` STRING COMMENT 'Customer number in SAP S/4HANA Finance module.',
    `sic_code` STRING COMMENT 'Standard Industrial Classification code for the organization.',
    `state` STRING COMMENT 'State or province of the organizations primary address.',
    `tax_identifier` STRING COMMENT 'Tax identification number for the organization.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the organization account record.',
    CONSTRAINT pk_organization_account PRIMARY KEY(`organization_account_id`)
) COMMENT 'B2B customer profile for corporate accounts, fleet operators, government entities, and leasing companies. Extends the party master with organization-specific attributes: legal entity name, DBA name, parent company party_id (for corporate hierarchy), DUNS number, SIC/NAICS code, annual revenue, number of employees, fleet size, procurement contact name, accounts payable contact, credit limit, payment terms, preferred OEM programs, government entity type (federal/state/municipal), contract vehicle type (GSA/state contract), Salesforce Account ID, SAP customer number, and account tier (strategic/key/standard). Enables B2B fleet sales, government procurement, and corporate account management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`household` (
    `household_id` BIGINT COMMENT 'Unique system-generated identifier for the household.',
    `individual_id` BIGINT COMMENT 'Identifier of the party designated as primary decision maker for household purchases.',
    `loyalty_program_id` BIGINT COMMENT 'Identifier of the loyalty program the household is enrolled in.',
    `party_id` BIGINT COMMENT 'Identifier of the party designated as primary decision maker for household purchases.',
    `address_line2` STRING COMMENT 'Secondary address line (e.g., apartment, suite).',
    `census_block` STRING COMMENT 'Census block identifier for geographic segmentation.',
    `city` STRING COMMENT 'City of the household residence.',
    `cltv` DECIMAL(18,2) COMMENT 'Projected total net revenue from the household over its relationship lifespan.',
    `country_code` STRING COMMENT 'Three‑letter ISO country code of the household.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the household record was first created.',
    `estimated_income_band` STRING COMMENT 'Income band estimate used for marketing segmentation.. Valid values are `low|mid|high|very_high`',
    `formation_date` DATE COMMENT 'Date the household entity was first created in the system.',
    `household_status` STRING COMMENT 'Current lifecycle status of the household record.. Valid values are `active|inactive|closed|pending`',
    `household_type` STRING COMMENT 'Classification of household composition.. Valid values are `single|family|multi-generational|other`',
    `last_contact_date` DATE COMMENT 'Date of the most recent interaction with the household.',
    `marketing_opt_in` BOOLEAN COMMENT 'Indicates whether the household has opted in to marketing communications.',
    `member_count` STRING COMMENT 'Total count of individual members in the household.',
    `household_name` STRING COMMENT 'Legal or commonly used name of the household (e.g., Smith Family).',
    `notes` STRING COMMENT 'Free‑form text for any supplemental information about the household.',
    `nps_score` STRING COMMENT 'Latest NPS rating associated with the household.',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the household.',
    `primary_email` STRING COMMENT 'Primary email address for household communications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `primary_phone` STRING COMMENT 'Primary telephone number for household contact.. Valid values are `^+?[0-9]{7,15}$`',
    `source_system_code` STRING COMMENT 'Unique identifier of the household record in the source system.',
    `state_province` STRING COMMENT 'State or province of the household residence.',
    `street_address` STRING COMMENT 'Primary street address line of the household.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the household record.',
    `vehicle_count` STRING COMMENT 'Count of vehicles registered to members of the household.',
    CONSTRAINT pk_household PRIMARY KEY(`household_id`)
) COMMENT 'Groups individual customers into household units for B2C relationship management, multi-vehicle ownership tracking, and household-level marketing. Stores household name, primary address, estimated household income band, number of members, number of vehicles owned, primary decision maker party_id, household formation date, household type (single/family/multi-generational), geographic census block, and Salesforce Household ID. Enables household-level CLTV calculation, conquest and retention campaigns, and multi-vehicle loyalty program management.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`contact_point` (
    `contact_point_id` BIGINT COMMENT 'System-generated unique identifier for each contact point record.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Contact points belong to a party (customer or organization). Adding contact_point.party_id creates the required inbound link and eliminates isolation.',
    `address_line1` STRING COMMENT 'First line of the mailing address.',
    `address_line2` STRING COMMENT 'Second line of the mailing address (optional).',
    `channel` STRING COMMENT 'Preferred channel associated with the contact point for outbound messaging.. Valid values are `voice|sms|email|mail|push|social`',
    `city` STRING COMMENT 'City component of the mailing address.',
    `classification` STRING COMMENT 'Business classification indicating the nature of the party owning the contact point.. Valid values are `personal|business|dealer|fleet|government`',
    `communication_preference` STRING COMMENT 'Type of communications the party consents to receive via this contact point.. Valid values are `marketing|transactional|service|none`',
    `contact_point_status` STRING COMMENT 'Current lifecycle status of the contact point.. Valid values are `active|inactive|pending|suspended|deleted`',
    `contact_point_type` STRING COMMENT 'Category of the contact point indicating the medium (e.g., email, phone, mailing address, social media handle).. Valid values are `email|phone|address|social|other`',
    `country_code` STRING COMMENT 'Three‑letter ISO country code for the mailing address.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the contact point record was first created in the lakehouse.',
    `effective_date` DATE COMMENT 'Date from which the contact point becomes valid for use.',
    `email_address` STRING COMMENT 'Email address used for electronic communication.. Valid values are `^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$`',
    `expiry_date` DATE COMMENT 'Date after which the contact point is no longer valid.',
    `is_primary` BOOLEAN COMMENT 'Indicates whether this contact point is the primary method for reaching the party.',
    `is_verified` BOOLEAN COMMENT 'True when the contact point has been successfully verified.',
    `language_preference` STRING COMMENT 'Preferred language for communications sent to this contact point.',
    `last_used_timestamp` TIMESTAMP COMMENT 'Most recent timestamp when this contact point was used for communication.',
    `opt_in_status` BOOLEAN COMMENT 'True when the party has consented to receive communications via this contact point.',
    `opt_out_date` TIMESTAMP COMMENT 'Date and time when the party withdrew consent for this contact point.',
    `phone_number` STRING COMMENT 'Telephone number including country code, used for voice or SMS contact.. Valid values are `^+?[0-9]{7,15}$`',
    `postal_code` STRING COMMENT 'Postal or ZIP code of the mailing address.',
    `preferred_contact_hours` STRING COMMENT 'Typical daily time window (e.g., 09:00-17:00) when the party prefers to be contacted.',
    `preferred_time_zone` STRING COMMENT 'IANA time‑zone identifier representing the partys preferred time zone for contact.',
    `social_handle` STRING COMMENT 'Identifier for the party on a social media platform (e.g., @user).',
    `social_platform` STRING COMMENT 'Social media platform associated with the social handle.. Valid values are `twitter|linkedin|facebook|instagram|other`',
    `state_province` STRING COMMENT 'State or province component of the mailing address.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the contact point record.',
    `value` DECIMAL(18,2) COMMENT 'The raw value of the contact point (e.g., email address, phone number, full mailing address, social handle).',
    `verification_date` TIMESTAMP COMMENT 'Date and time when the contact point was verified.',
    `verification_method` STRING COMMENT 'Method used to verify the contact point (e.g., email link, SMS code).. Valid values are `email|sms|call|postal|in_person|other`',
    CONSTRAINT pk_contact_point PRIMARY KEY(`contact_point_id`)
) COMMENT 'Stores all contact information for a party (individual or organization) including email addresses, phone numbers, mailing addresses, and social media handles. Each record captures: contact point type (email/phone/address/social), contact point value, is_primary flag, is_verified flag, verification date, verification method, opt-in status, opt-out date, channel (voice/SMS/email/mail/push), preferred time zone, preferred contact hours, source system, and effective/expiry dates. Supports omnichannel communication, regulatory compliance (TCPA, CAN-SPAM, GDPR), and Salesforce Automotive Cloud contact synchronization.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` (
    `vehicle_ownership_id` BIGINT COMMENT 'Surrogate primary key uniquely identifying each vehicle ownership record.',
    `connected_vehicle_id` BIGINT COMMENT 'Foreign key linking to mobility.connected_vehicle. Business justification: Required for OTA campaign and warranty management linking each ownership record to its connected vehicle entity.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Required for warranty/service eligibility reports linking each ownership record to the dealer that sold the vehicle; dealer_code is denormalized and replaced.',
    `party_id` BIGINT COMMENT 'Unique identifier of the customer (party) that owns or leases the vehicle.',
    `telematics_device_id` BIGINT COMMENT 'Foreign key linking to mobility.telematics_device. Business justification: Service and OTA update processes need to know which telematics device is installed on each owned vehicle.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Links ownership record to the original sales order, enabling warranty, service, and revenue attribution reports.',
    `vehicle_program_id` BIGINT COMMENT 'Foreign key linking to engineering.vehicle_program. Business justification: Required for warranty, recall and production tracking reports that map each owned vehicle to its engineering program.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Required for ownership verification and warranty claim processing; links each ownership record to the VIN registry entry to retrieve vehicle specs.',
    `acquisition_channel` STRING COMMENT 'Source through which the vehicle was obtained.. Valid values are `dealer|direct|auction|fleet`',
    `acquisition_date` DATE COMMENT 'Date the customer acquired the vehicle (purchase, lease start, etc.).',
    `acquisition_dealer_code` STRING COMMENT 'Identifier of the dealer that facilitated the acquisition.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the ownership record was first created.',
    `current_odometer` BIGINT COMMENT 'Most recent mileage reported for the vehicle.',
    `disposition_date` DATE COMMENT 'Date the vehicle was disposed of (sold, traded, etc.).',
    `disposition_odometer` BIGINT COMMENT 'Mileage recorded at the time of disposition.',
    `disposition_type` STRING COMMENT 'How the ownership relationship ended.. Valid values are `sold|traded|totaled|repossessed|retired`',
    `insurance_carrier` STRING COMMENT 'Company providing the vehicles insurance coverage.',
    `insurance_expiry` DATE COMMENT 'Date the insurance coverage ends.',
    `insurance_policy_number` STRING COMMENT 'Identifier of the insurance policy covering the vehicle.',
    `is_primary_vehicle` BOOLEAN COMMENT 'True if this vehicle is the primary vehicle for the customer household.',
    `lien_holder_name` STRING COMMENT 'Name of the financial institution or entity holding a lien on the vehicle.',
    `odometer_at_acquisition` BIGINT COMMENT 'Vehicle mileage recorded at the time of acquisition.',
    `ownership_number` STRING COMMENT 'Business identifier for the ownership agreement between the customer and the manufacturer/dealer.',
    `ownership_type` STRING COMMENT 'Classification of how the vehicle is held by the customer.. Valid values are `retail|lease|fleet|government`',
    `purchase_price` DECIMAL(18,2) COMMENT 'Amount paid by the customer for the vehicle at acquisition.',
    `registration_country` STRING COMMENT 'Three‑letter country code of the registration jurisdiction.',
    `registration_expiry` DATE COMMENT 'Date the vehicle registration expires.',
    `registration_number` STRING COMMENT 'Official license plate number assigned to the vehicle.',
    `registration_state` STRING COMMENT 'State or province where the vehicle is registered.',
    `title_number` STRING COMMENT 'Legal document number proving ownership.',
    `title_state` STRING COMMENT 'State that issued the title.',
    `trade_in_vin` STRING COMMENT 'VIN of a vehicle traded in as part of the acquisition, if applicable.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the ownership record.',
    `vehicle_ownership_status` STRING COMMENT 'Current lifecycle state of the ownership record.. Valid values are `active|inactive|closed|pending`',
    CONSTRAINT pk_vehicle_ownership PRIMARY KEY(`vehicle_ownership_id`)
) COMMENT 'Tracks the ownership history of vehicles by customers — the authoritative record linking a customer (party) to a VIN. Captures: VIN, party_id (owner), ownership type (retail purchase/lease/fleet/government), acquisition date, acquisition channel (dealer/direct/auction/fleet), acquisition dealer code, purchase price, trade-in VIN, registration state/country, registration number, registration expiry, title number, title state, lien holder name, insurance carrier, insurance policy number, insurance expiry, odometer at acquisition, current odometer (last reported), is_primary_vehicle flag, disposition type (sold/traded/totaled/repossessed), disposition date, and disposition odometer. SSOT for customer-vehicle relationship; cross-references vehicle domain VIN master.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` (
    `loyalty_membership_id` BIGINT COMMENT 'System-generated unique identifier for the loyalty membership record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Loyalty Membership Enrollment Tracking records the employee who enrolled the party into the loyalty program.',
    `household_id` BIGINT COMMENT 'Identifier linking members belonging to the same household.',
    `loyalty_program_id` BIGINT COMMENT 'Identifier of the loyalty program to which the member is enrolled.',
    `party_id` BIGINT COMMENT 'Unique identifier of the customer (party) that holds the membership.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the loyalty membership record was first created.',
    `current_tier` STRING COMMENT 'Current loyalty tier of the member based on points qualification.. Valid values are `bronze|silver|gold|platinum`',
    `enrollment_channel` STRING COMMENT 'Channel through which the customer enrolled (e.g., online, in‑store).. Valid values are `online|in_store|dealer|call_center|mobile_app`',
    `enrollment_date` DATE COMMENT 'Date the customer enrolled in the loyalty program.',
    `is_primary_member` BOOLEAN COMMENT 'Indicates if this member is the primary account holder in a household linkage.',
    `last_activity_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent activity (e.g., point accrual, redemption) by the member.',
    `last_redemption_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent points redemption.',
    `lifetime_points_earned` DECIMAL(18,2) COMMENT 'Total points the member has earned over the lifetime of the membership.',
    `membership_expiry_date` DATE COMMENT 'Date when the membership itself expires if not renewed.',
    `membership_number` STRING COMMENT 'Business identifier assigned to the member within the loyalty program.',
    `notes` STRING COMMENT 'Free‑form comments or notes about the membership.',
    `points_balance` DECIMAL(18,2) COMMENT 'Current balance of loyalty points available for redemption.',
    `points_balance_last_year` DECIMAL(18,2) COMMENT 'Points balance at the end of the previous fiscal year.',
    `points_earned_this_year` DECIMAL(18,2) COMMENT 'Points accrued by the member during the current calendar year.',
    `points_expiry_date` DATE COMMENT 'Date on which the current points balance will expire if not used.',
    `points_redeemed_this_year` DECIMAL(18,2) COMMENT 'Points redeemed by the member during the current calendar year.',
    `preferred_redemption_category` STRING COMMENT 'Members preferred category for redeeming points.. Valid values are `service|accessories|cash|gift_card|charity`',
    `program_status` STRING COMMENT 'Current status of the membership within the loyalty program.. Valid values are `active|suspended|expired|cancelled`',
    `record_status` STRING COMMENT 'Lifecycle status of the record for data‑governance purposes.. Valid values are `active|inactive|deleted`',
    `redemption_eligibility_flag` BOOLEAN COMMENT 'Indicates whether the member is currently eligible to redeem points.',
    `referral_code` STRING COMMENT 'Alphanumeric code used by the member to refer new customers.',
    `salesforce_loyalty_member_reference` STRING COMMENT 'Identifier of the member record in Salesforce Automotive Cloud Loyalty Management.',
    `tier_benefits_description` STRING COMMENT 'Textual description of benefits associated with the current tier.',
    `tier_expiry_date` DATE COMMENT 'Date the current tier expires if not renewed.',
    `tier_points_required` DECIMAL(18,2) COMMENT 'Number of points required to reach the next tier level.',
    `tier_qualification_date` DATE COMMENT 'Date the member qualified for the current tier.',
    `total_points_redeemed` DECIMAL(18,2) COMMENT 'Aggregate number of points the member has redeemed.',
    `total_redemptions` STRING COMMENT 'Cumulative count of redemption transactions performed by the member.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the loyalty membership record.',
    CONSTRAINT pk_loyalty_membership PRIMARY KEY(`loyalty_membership_id`)
) COMMENT 'Manages customer enrollment and status in Automotive loyalty programs (e.g., owner rewards, EV early adopter program, fleet loyalty). Captures: program_id, party_id, membership number, enrollment date, enrollment channel, current tier (bronze/silver/gold/platinum), tier qualification date, tier expiry date, points balance, lifetime points earned, points expiry date, redemption eligibility flag, referral code, referred_by party_id, preferred redemption category, program status (active/suspended/expired/cancelled), and Salesforce Loyalty Management program member ID. Enables tier-based benefits, points accrual/redemption, and retention marketing.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` (
    `loyalty_transaction_id` BIGINT COMMENT 'System-generated unique identifier for the loyalty transaction record.',
    `loyalty_membership_id` BIGINT COMMENT 'Identifier of the loyalty program membership to which this transaction belongs.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Loyalty Points Accrual Audit tracks which employee processed each loyalty transaction at point‑of‑sale.',
    `promotion_id` BIGINT COMMENT 'Identifier of the promotion or campaign that generated the points, if applicable.',
    `approval_status` STRING COMMENT 'Administrative approval state of the transaction for fraud control and audit.. Valid values are `approved|pending|rejected`',
    `channel` STRING COMMENT 'Channel through which the transaction was recorded (dealer, online portal, mobile app, or call center).. Valid values are `dealer|online|app|call_center`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the transaction record was first created in the system.',
    `dealer_code` STRING COMMENT 'Code of the dealer or service location associated with the transaction.',
    `notes` STRING COMMENT 'Free‑text field for additional comments or remarks about the transaction.',
    `points_amount` STRING COMMENT 'Number of loyalty points affected by the transaction (positive for earn, negative for redeem/expire).',
    `points_balance_after` STRING COMMENT 'Running total of loyalty points for the membership after this transaction is applied.',
    `points_expiry_date` DATE COMMENT 'Date on which earned points are scheduled to expire, if applicable.',
    `reference_document_number` STRING COMMENT 'External document identifier linked to the transaction (e.g., invoice number, repair order number, VIN).',
    `transaction_number` STRING COMMENT 'External business identifier assigned to the transaction (e.g., transaction code used in reporting).',
    `transaction_status` STRING COMMENT 'Current lifecycle status of the transaction.. Valid values are `pending|posted|cancelled|reversed|approved`',
    `transaction_timestamp` TIMESTAMP COMMENT 'Date and time when the loyalty event actually occurred.',
    `transaction_type` STRING COMMENT 'Category of the transaction indicating points earned, redeemed, adjusted, expired, or transferred.. Valid values are `earn|redeem|adjust|expire|transfer`',
    `triggering_event_type` STRING COMMENT 'Business event that caused the points transaction (e.g., vehicle purchase, service visit, referral, promotion, OTA enrollment, EV charge).. Valid values are `vehicle_purchase|service_visit|referral|promotion|ota_enrollment|ev_charge`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the transaction record.',
    CONSTRAINT pk_loyalty_transaction PRIMARY KEY(`loyalty_transaction_id`)
) COMMENT 'Records every points accrual and redemption event within a loyalty program membership. Captures: membership_id, transaction type (earn/redeem/adjust/expire/transfer), transaction date, points amount (positive for earn, negative for redeem/expire), triggering event type (vehicle purchase/service visit/referral/promotion/OTA enrollment/EV charge), reference document number (e.g., RO number, invoice number, VIN), dealer code, channel (dealer/online/app/call center), promotion_id, expiry date of earned points, running points balance after transaction, and approval status. Supports loyalty program P&L, fraud detection, and member engagement analytics.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`customer_segment` (
    `customer_segment_id` BIGINT COMMENT 'Unique surrogate key for each customer segment record.',
    `product_segment_id` BIGINT COMMENT 'SSOT reference to product.product_segment (resolves cross-domain duplicate of segment).',
    `confidence_score` DECIMAL(18,2) COMMENT 'Statistical confidence (0‑100) that the segment definition accurately captures the target customers.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the segment record was first created in the system.',
    `customer_segment_description` STRING COMMENT 'Detailed narrative describing the purpose and characteristics of the segment.',
    `effective_date` DATE COMMENT 'Date when the segment becomes effective for use.',
    `estimated_segment_size` BIGINT COMMENT 'Projected number of customers that belong to this segment.',
    `expiry_date` DATE COMMENT 'Date when the segment is retired or no longer valid.',
    `geographic_scope` STRING COMMENT 'Geographic extent of the segments relevance.. Valid values are `global|regional|national|local`',
    `is_active` BOOLEAN COMMENT 'Indicates whether the segment is currently active for assignment.',
    `last_review_date` DATE COMMENT 'Date when the segment was last reviewed for relevance and accuracy.',
    `model_year_end` STRING COMMENT 'Last model year included in the segments relevance window.',
    `model_year_start` STRING COMMENT 'First model year included in the segments relevance window.',
    `owner` STRING COMMENT 'Internal team or business unit responsible for maintaining the segment.',
    `primary_vehicle_interest` STRING COMMENT 'Dominant vehicle powertrain or body style interest for customers in this segment (e.g., ICE, HEV, PHEV, EV, truck, SUV, commercial). [ENUM-REF-CANDIDATE: ICE|HEV|PHEV|EV|truck|SUV|commercial — promote to reference product]',
    `priority` STRING COMMENT 'Numeric priority used to order segments when multiple apply to a customer.',
    `qualifying_criteria_summary` STRING COMMENT 'Brief summary of the rules or metrics used to assign customers to this segment.',
    `revenue_potential_band` STRING COMMENT 'Estimated revenue range the segment is expected to generate.. Valid values are `low|mid|high|very_high`',
    `segment_category` STRING COMMENT 'Taxonomy category that defines the basis of the segmentation.. Valid values are `demographic|behavioral|psychographic|firmographic|lifecycle|vehicle_type`',
    `segment_code` STRING COMMENT 'Short alphanumeric code used to reference the segment in reporting and downstream systems.',
    `segment_name` STRING COMMENT 'Human‑readable name of the customer segment.',
    `segment_status` STRING COMMENT 'Current lifecycle status of the segment.. Valid values are `active|inactive|deprecated|pending`',
    `tags` STRING COMMENT 'Free‑form tags or keywords associated with the segment for ad‑hoc filtering.',
    `target_customer_type` STRING COMMENT 'Indicates whether the segment applies to retail consumers, business accounts, or both.. Valid values are `B2C|B2B|both`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the segment record.',
    `version` STRING COMMENT 'Version number of the segment definition, incremented on each change.',
    CONSTRAINT pk_customer_segment PRIMARY KEY(`customer_segment_id`)
) COMMENT 'Defines the segmentation taxonomy used to classify customers for marketing, sales, and product planning. Each segment record captures: segment code, segment name, segment category (demographic/behavioral/psychographic/firmographic/lifecycle/vehicle-type), description, target customer type (B2C/B2B/both), qualifying criteria summary, estimated segment size, revenue potential band, primary vehicle interest (ICE/HEV/PHEV/EV/truck/SUV/commercial), geographic scope, model year relevance, is_active flag, effective date, and expiry date. Reference data consumed by individual and organization_account entities for segmentation assignment.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`segment_membership` (
    `segment_membership_id` BIGINT COMMENT 'System-generated unique identifier for each segment membership record.',
    `customer_segment_id` BIGINT COMMENT 'Unique identifier of the customer segment to which the party is assigned.',
    `party_id` BIGINT COMMENT 'Unique identifier of the customer (party) assigned to a segment.',
    `assigned_by` STRING COMMENT 'Identifier of the user or system that performed the segment assignment.',
    `assignment_date` DATE COMMENT 'Date on which the customer was assigned to the segment.',
    `assignment_method` STRING COMMENT 'Method used to assign the customer to the segment: rule‑based, manual, or machine‑learning model.. Valid values are `rule_based|manual|ml_model`',
    `confidence_score` DECIMAL(18,2) COMMENT 'Confidence level (0‑1) indicating the certainty of the segment assignment.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the segment membership record was first created in the system.',
    `expiry_date` DATE COMMENT 'Date when the segment membership becomes inactive or is scheduled to expire.',
    `is_primary_segment` BOOLEAN COMMENT 'True if this segment is the primary segment for the customer; otherwise false.',
    `model_version` STRING COMMENT 'Version identifier of the ML model that performed the assignment, if assignment_method is ml_model.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the segment membership record.',
    CONSTRAINT pk_segment_membership PRIMARY KEY(`segment_membership_id`)
) COMMENT 'Association entity recording which customers belong to which segments at any point in time. Captures: party_id, customer_segment_id, assignment date, assignment method (rule-based/manual/ML-model), model version (if ML-assigned), confidence score (0-1), is_primary_segment flag, expiry date, and assigned_by user. Supports dynamic segmentation, A/B testing cohort assignment, and historical segment membership tracking for campaign attribution and regulatory audit.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`preference` (
    `preference_id` BIGINT COMMENT 'Unique system-generated identifier for each preference entry.',
    `party_id` BIGINT COMMENT 'Identifier of the customer (person or organization) to whom the preference applies.',
    `preference_category` STRING COMMENT 'High‑level grouping of the preference (e.g., communication, vehicle feature, service scheduling, digital experience, privacy).. Valid values are `communication|vehicle|service|digital|privacy`',
    `channel` STRING COMMENT 'Preferred channel for delivering communications when the preference_category is communication.. Valid values are `email|sms|push|mail|phone`',
    `confidence_score` DECIMAL(18,2) COMMENT 'Confidence level (0.0000‑1.0000) that the stored preference accurately reflects the customers intent.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the preference record was first created in the system.',
    `data_origin_system` STRING COMMENT 'Identifies the source system that supplied the preference record.. Valid values are `salesforce|cdk|custom|other`',
    `effective_date` DATE COMMENT 'Date on which the preference becomes active.',
    `expiry_date` DATE COMMENT 'Date after which the preference is no longer valid; null if indefinite.',
    `is_opt_out` BOOLEAN COMMENT 'True if the customer has explicitly opted out of the indicated preference; otherwise false.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the preference record.',
    `notes` STRING COMMENT 'Optional free‑form comments or remarks about the preference.',
    `preference_status` STRING COMMENT 'Current lifecycle state of the preference (e.g., active, inactive, expired, pending review).. Valid values are `active|inactive|expired|pending`',
    `source` STRING COMMENT 'Origin of the preference record: self‑declared by the customer, inferred by analytics, or imported from an external system.. Valid values are `self_declared|inferred|imported`',
    `value` DECIMAL(18,2) COMMENT 'The value assigned to the preference key; stored as text and interpreted according to value_data_type.',
    `value_data_type` STRING COMMENT 'Indicates the native data type of preference_value (e.g., string, boolean, integer, list).. Valid values are `string|boolean|integer|list`',
    CONSTRAINT pk_preference PRIMARY KEY(`preference_id`)
) COMMENT 'Stores customer-declared and inferred preferences for communications, vehicle features, service scheduling, and digital experiences. Each record captures: party_id, preference category (communication/vehicle/service/digital/privacy), preference key (e.g., preferred_fuel_type, preferred_body_style, preferred_service_day, email_frequency), preference value, value data type (string/boolean/integer/list), source (self-declared/inferred/imported), confidence score, effective date, expiry date, and last updated timestamp. Supports personalized marketing, product recommendation engines, and connected vehicle feature configuration.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`customer_consent_record` (
    `customer_consent_record_id` BIGINT COMMENT 'Unique identifier for the customer_consent_record data product (auto-inserted pre-linking).',
    `party_id` BIGINT COMMENT 'add column party_id (BIGINT) with FK to customer.party.party_id - consent records must be linked to the customer who gave consent',
    `channel` STRING COMMENT 'Channel through which consent was collected (web, app, in-store, phone)',
    `consent_channel` STRING COMMENT 'Channel through which consent was captured.',
    `consent_date` DATE COMMENT 'Date consent was given',
    `consent_status` STRING COMMENT 'Current consent status (granted, withdrawn, expired).',
    `consent_timestamp` TIMESTAMP COMMENT 'Timestamp when the consent decision was recorded.',
    `consent_type` STRING COMMENT 'Type of consent (marketing, data processing, telemetry, etc.).',
    `consent_version` STRING COMMENT 'Version of the consent policy/terms accepted by the customer',
    `data_categories` STRING COMMENT 'Categories of personal data covered by this consent record',
    `expiry_date` DATE COMMENT 'Date the consent expires if not renewed.',
    `granted_date` DATE COMMENT 'Date when consent was originally granted by the customer',
    `legal_basis` STRING COMMENT 'Legal basis for processing under GDPR (consent, legitimate interest, contract)',
    `purpose` STRING COMMENT 'Specific purpose for which consent was granted per GDPR Art.6',
    `revocation_timestamp` TIMESTAMP COMMENT 'Timestamp when consent was revoked, if applicable',
    `customer_consent_record_status` STRING COMMENT 'Consent status',
    `withdrawal_date` DATE COMMENT 'Date when the customer withdrew consent, if applicable',
    CONSTRAINT pk_customer_consent_record PRIMARY KEY(`customer_consent_record_id`)
) COMMENT 'SSOT for all customer consent and privacy preference records required under GDPR, CCPA, TCPA, and CAN-SPAM regulations. Captures: party_id, consent type (marketing_email/marketing_sms/telematics_data/data_sharing/profiling/cookies), consent status (granted/withdrawn/pending), consent version (policy version at time of consent), consent date, withdrawal date, consent channel (web/app/dealer/call_center/paper), IP address at consent, geolocation at consent, consent text snapshot, legal basis (consent/legitimate_interest/contract/legal_obligation), data processing purpose, third_party_sharing_flag, retention period (days), and regulatory jurisdiction (GDPR/CCPA/PIPEDA/LGPD). Critical for regulatory compliance and privacy-by-design.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`nps_response` (
    `nps_response_id` BIGINT COMMENT 'System-generated unique identifier for each NPS survey response record.',
    `case_id` BIGINT COMMENT 'Identifier of the service case created if the response was escalated.',
    `party_id` BIGINT COMMENT 'Unique identifier of the customer (person or organization) who provided the NPS response.',
    `survey_id` BIGINT COMMENT 'Identifier of the NPS survey definition that was administered.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the NPS response record was first inserted into the data lake.',
    `dealer_code` STRING COMMENT 'Code of the dealer or service location linked to the survey touchpoint.',
    `follow_up_required_flag` BOOLEAN COMMENT 'Indicates whether the response requires follow‑up action (true) or not (false).',
    `follow_up_status` STRING COMMENT 'Current status of any follow‑up activity triggered by the response.. Valid values are `required|in_progress|completed|none`',
    `nps_response_status` STRING COMMENT 'Current processing state of the NPS response record.. Valid values are `pending|completed|escalated|closed`',
    `nps_score` STRING COMMENT 'Numeric rating provided by the respondent on a 0‑10 scale.',
    `promoter_category` STRING COMMENT 'Categorization of the NPS score: promoter (9‑10), passive (7‑8), or detractor (0‑6).. Valid values are `promoter|passive|detractor`',
    `response_date` DATE COMMENT 'Date on which the respondent submitted the completed survey.',
    `salesforce_survey_response_reference` STRING COMMENT 'Unique identifier of the response record in Salesforce Survey system.',
    `survey_channel` STRING COMMENT 'Medium through which the survey was delivered to the respondent.. Valid values are `email|sms|app|ivr`',
    `survey_date` DATE COMMENT 'Date on which the survey was presented to the respondent.',
    `survey_type` STRING COMMENT 'Indicates whether the NPS survey is transactional (post‑purchase) or relational (brand experience).. Valid values are `transactional|relational`',
    `touchpoint` STRING COMMENT 'Business interaction point at which the NPS survey was triggered.. Valid values are `vehicle_purchase|service_visit|delivery|recall|roadside|connected_app`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the NPS response record.',
    `verbatim_comment` STRING COMMENT 'Free‑text comment supplied by the respondent providing qualitative feedback.',
    `vin` STRING COMMENT 'Unique 17‑character identifier of the vehicle associated with the response, if applicable.',
    CONSTRAINT pk_nps_response PRIMARY KEY(`nps_response_id`)
) COMMENT 'Captures Net Promoter Score survey responses from customers across all touchpoints in the automotive ownership journey. Records: party_id, VIN (if vehicle-specific), survey_id, survey type (transactional/relational), touchpoint (vehicle_purchase/service_visit/delivery/recall/roadside/connected_app), dealer code, nps_score (0-10), promoter category (promoter/passive/detractor), verbatim comment, survey channel (email/SMS/app/IVR), survey date, response date, follow-up required flag, follow-up status, case_id (if escalated), and Salesforce Survey Response ID. Feeds NPS KPI reporting and closed-loop customer recovery workflows.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`cltv_record` (
    `cltv_record_id` BIGINT COMMENT 'Unique identifier for each CLTV record snapshot.',
    `party_id` BIGINT COMMENT 'Identifier of the customer (party) to which this CLTV estimate belongs.',
    `calculation_date` DATE COMMENT 'The calendar date on which the CLTV estimate was generated.',
    `calculation_status` STRING COMMENT 'Current processing state of the CLTV record.. Valid values are `pending|completed|failed`',
    `churn_probability` DECIMAL(18,2) COMMENT 'Likelihood (0‑1) that the customer will stop doing business within the horizon.',
    `cltv_amount` DECIMAL(18,2) COMMENT 'Present value of the total expected net revenue from the customer over the forecast horizon.',
    `cltv_horizon_months` STRING COMMENT 'Number of months over which the CLTV is projected.',
    `data_completeness_score` DECIMAL(18,2) COMMENT 'Percentage (0‑100) reflecting how complete the underlying data was for this CLTV estimate.',
    `discount_rate` DECIMAL(18,2) COMMENT 'Annual discount rate (as a decimal) applied to future cash flows to compute present value.',
    `model_version` STRING COMMENT 'Version identifier of the predictive model used for the CLTV calculation.',
    `projected_accessories_revenue` DECIMAL(18,2) COMMENT 'Estimated revenue from future accessories and add‑on sales.',
    `projected_connected_services_revenue` DECIMAL(18,2) COMMENT 'Estimated revenue from OTA updates, telematics subscriptions, and other connected mobility services.',
    `projected_finance_revenue` DECIMAL(18,2) COMMENT 'Estimated revenue from financing, leasing, and related financial products.',
    `projected_parts_revenue` DECIMAL(18,2) COMMENT 'Estimated revenue from future parts sales to the customer.',
    `projected_service_revenue` DECIMAL(18,2) COMMENT 'Estimated revenue from future service and maintenance activities.',
    `projected_vehicle_purchases` STRING COMMENT 'Estimated count of future vehicle purchases by the customer within the horizon.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Date‑time when this CLTV snapshot was inserted into the Silver layer.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the latest modification to this CLTV record.',
    `retention_probability` DECIMAL(18,2) COMMENT 'Likelihood (0‑1) that the customer will remain active throughout the horizon.',
    `revenue_to_date` DECIMAL(18,2) COMMENT 'Cumulative revenue earned from the customer up to the calculation date.',
    `segment_at_calculation` STRING COMMENT 'Business segment classification of the customer when the CLTV was calculated.. Valid values are `high|medium|low|new|churn_risk`',
    CONSTRAINT pk_cltv_record PRIMARY KEY(`cltv_record_id`)
) COMMENT 'Stores calculated Customer Lifetime Value (CLTV) estimates and their historical snapshots for each customer party. Captures: party_id, calculation date, calculation model version, cltv_amount (present value), cltv_horizon_months, revenue_to_date, projected_vehicle_purchases, projected_service_revenue, projected_parts_revenue, projected_accessories_revenue, projected_finance_revenue, projected_connected_services_revenue, discount_rate, churn_probability, retention_probability, segment_at_calculation, and data_completeness_score. Supports strategic customer investment decisions, retention program targeting, and dealer incentive allocation. NOT an analytics aggregate — this is the operational CLTV record used in CRM workflows.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` (
    `journey_touchpoint_id` BIGINT COMMENT 'System-generated unique identifier for each touchpoint event.',
    `campaign_id` BIGINT COMMENT 'Identifier of the marketing campaign linked to the touchpoint.',
    `employee_id` BIGINT COMMENT 'Identifier of the sales or service agent handling the touchpoint.',
    `loyalty_program_id` BIGINT COMMENT 'Identifier of the loyalty program associated with the touchpoint, when applicable.',
    `party_id` BIGINT COMMENT 'Identifier of the customer (person or organization) associated with the touchpoint.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the sales or service agent handling the touchpoint.',
    `activity_id` BIGINT COMMENT 'Identifier of the corresponding activity record in Salesforce Automotive Cloud.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Customer journey analytics associate each touchpoint with a specific vehicle; linking to VIN registry provides model and feature context.',
    `channel` STRING COMMENT 'Medium through which the touchpoint was delivered.. Valid values are `dealer|online|app|call_center|event|social`',
    `connected_app_code` STRING COMMENT 'Identifier of the connected mobile or in‑vehicle application activated.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the touchpoint record was first created in the lakehouse.',
    `dealer_code` STRING COMMENT 'Code identifying the dealer involved in the touchpoint, if applicable.',
    `device_type` STRING COMMENT 'Type of device used by the customer for digital interactions.. Valid values are `smartphone|tablet|desktop|in_vehicle|other`',
    `duration_seconds` STRING COMMENT 'Length of the interaction in seconds for digital or call channels.',
    `event_source` STRING COMMENT 'System of record that generated the touchpoint event (e.g., Salesforce, DMS, IoT platform).',
    `feedback_comments` STRING COMMENT 'Free‑form textual feedback supplied by the customer.',
    `feedback_score` STRING COMMENT 'Numeric rating provided by the customer for the interaction (1‑5).',
    `interaction_outcome` STRING COMMENT 'Result of the interaction from the customers perspective.. Valid values are `success|failure|pending|cancelled|no_show`',
    `ip_address` STRING COMMENT 'IP address of the client device for online interactions.. Valid values are `^((25[0-5]|2[0-4]d|[01]?dd?).){3}(25[0-5]|2[0-4]d|[01]?dd?)$`',
    `is_assisted` BOOLEAN COMMENT 'Indicates whether the touchpoint involved human assistance (true) or was fully automated (false).',
    `location_city` STRING COMMENT 'City where the touchpoint took place, if location is applicable.',
    `location_country` STRING COMMENT 'Three‑letter ISO country code where the touchpoint occurred.. Valid values are `^[A-Z]{3}$`',
    `location_state` STRING COMMENT 'State or province code for the touchpoint location.',
    `loyalty_points_redeemed` STRING COMMENT 'Number of loyalty points used during the interaction.',
    `marketing_attribution` STRING COMMENT 'Attribution source for the touchpoint (e.g., email, paid search, referral).',
    `notes` STRING COMMENT 'Additional free‑form comments or observations captured for the touchpoint.',
    `ota_update_version` STRING COMMENT 'Software version applied during an Over‑The‑Air update touchpoint.',
    `repurchase_flag` BOOLEAN COMMENT 'True if the touchpoint represents a repeat purchase by the customer.',
    `session_reference` STRING COMMENT 'Unique identifier for the digital session associated with the touchpoint.',
    `touchpoint_timestamp` TIMESTAMP COMMENT 'Exact date and time when the touchpoint occurred.',
    `touchpoint_type` STRING COMMENT 'Category of the interaction event in the customer journey.. Valid values are `lead_inquiry|test_drive|quote_request|vehicle_purchase|delivery|service_visit`',
    `trade_in_vehicle_vin` STRING COMMENT 'VIN of the vehicle offered as a trade‑in during the touchpoint.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the touchpoint record.',
    `user_agent` STRING COMMENT 'Browser or application user‑agent string for the digital session.',
    CONSTRAINT pk_journey_touchpoint PRIMARY KEY(`journey_touchpoint_id`)
) COMMENT 'Records every significant interaction event in a customers lifecycle journey with Automotive — from initial lead through ownership and repurchase. Captures: party_id, VIN (if applicable), touchpoint type (lead_inquiry/test_drive/quote_request/vehicle_purchase/delivery/service_visit/recall_notification/loyalty_redemption/connected_app_activation/OTA_update/trade_in/repurchase), touchpoint date, channel (dealer/online/app/call_center/event/social), dealer code, campaign_id, interaction outcome, duration_seconds (for digital/call interactions), agent_id (for assisted channels), device_type (for digital), session_id (for digital), and Salesforce Activity ID. Enables customer journey mapping, attribution modeling, and next-best-action recommendations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_account` (
    `customer_fleet_account_id` BIGINT COMMENT 'Unique identifier for the customer_fleet_account data product (auto-inserted pre-linking).',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Fleet Account Management requires linking each fleet account to the fleet manager employee responsible.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Customer fleet accounts represent fleet customers; linking to the master party provides identity context and connects the product to the graph.',
    CONSTRAINT pk_customer_fleet_account PRIMARY KEY(`customer_fleet_account_id`)
) COMMENT 'Specialized master entity for fleet customer accounts — commercial, government, and rental fleet operators — extending organization_account with fleet-specific attributes. Captures: organization_account_id, fleet type (commercial/government/rental/utility/emergency), fleet size (total vehicles), active_fleet_size, annual_replacement_volume, preferred_vehicle_segments (sedan/SUV/truck/van/EV/commercial), preferred_powertrain (ICE/HEV/PHEV/EV), fleet management system name, telematics provider, upfitter name, dedicated fleet sales rep, fleet pricing tier, volume discount percentage, fleet program code, government contract number, GSA schedule number, state contract number, annual spend, and fleet account status. Supports fleet sales operations, volume pricing, and government procurement compliance.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_vehicle_assignment` (
    `customer_fleet_vehicle_assignment_id` BIGINT COMMENT 'Unique identifier for the customer_fleet_vehicle_assignment data product (auto-inserted pre-linking).',
    `customer_fleet_account_id` BIGINT COMMENT 'add column customer_fleet_account_id (BIGINT) with FK to customer.customer_fleet_account.customer_fleet_account_id - fleet vehicle assignments belong to fleet accounts',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Fleet Vehicle Assignment Log tracks which fleet manager assigned a vehicle to a fleet account.',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Each fleet vehicle assignment is performed by a driver (party). Adding party_id links the assignment to the driver entity and removes isolation.',
    `vin_registry_id` BIGINT COMMENT 'add column vin_registry_id (BIGINT) with FK to vehicle.vin_registry.vin_registry_id - fleet vehicle assignments must reference specific VINs',
    CONSTRAINT pk_customer_fleet_vehicle_assignment PRIMARY KEY(`customer_fleet_vehicle_assignment_id`)
) COMMENT 'Tracks the assignment of specific VINs to fleet accounts and their designated operators/drivers within a fleet. Captures: fleet_account_id, VIN, assigned_driver_party_id, assignment start date, assignment end date, assignment type (permanent/pool/temporary), cost center, department, usage purpose (sales/service/executive/delivery/government), mileage allowance per period, mileage period type (monthly/annual), telematics device ID, fuel card number, and assignment status (active/returned/transferred/disposed). Enables fleet utilization tracking, driver accountability, and fleet billing reconciliation.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` (
    `identity_resolution_id` BIGINT COMMENT 'System‑generated unique identifier for each identity resolution event.',
    `party_id` BIGINT COMMENT 'Identifier of the surviving (golden) party record after resolution.',
    `match_confidence_score` DECIMAL(18,2) COMMENT 'Confidence level (0‑1) indicating how certain the match is, as calculated by the MDM engine.',
    `match_method` STRING COMMENT 'Technique used to determine the match: deterministic, probabilistic, or manual review.. Valid values are `deterministic|probabilistic|manual`',
    `match_rule_set_version` STRING COMMENT 'Version identifier of the matching rule set used for this resolution.',
    `matched_attributes` STRING COMMENT 'JSON‑encoded list of attribute names that were used to compute the match (e.g., ["email","phone","address"]).',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when this identity resolution record was first created in the data lake.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to this identity resolution record.',
    `rejection_reason` STRING COMMENT 'Free‑text explanation why a resolution was rejected, if applicable.',
    `resolution_action` STRING COMMENT 'Action taken after the match: merge (combine records), link (associate), suppress (deactivate duplicate), or review (manual investigation required).. Valid values are `merge|link|suppress|review`',
    `resolution_date` TIMESTAMP COMMENT 'Timestamp when the identity resolution decision was recorded.',
    `resolved_by` STRING COMMENT 'User name or system identifier that performed the resolution.',
    `review_status` STRING COMMENT 'Current review state of the resolution: automatically approved, pending manual review, or rejected.. Valid values are `auto-approved|pending_review|rejected`',
    `source_system_a` STRING COMMENT 'Name or code of the first source system contributing the party record (e.g., Salesforce, SAP, CDK).',
    `source_system_b` STRING COMMENT 'Name or code of the second source system contributing the party record.',
    CONSTRAINT pk_identity_resolution PRIMARY KEY(`identity_resolution_id`)
) COMMENT 'Records the results of identity resolution and deduplication processes that match, merge, and link customer party records across source systems (Salesforce, SAP, CDK DMS, dealer systems). Captures: golden_party_id (surviving record), duplicate_party_id (merged/suppressed record), source_system_a, source_system_b, match_rule_set_version, match_confidence_score (0-1), match_method (deterministic/probabilistic/manual), matched_attributes (JSON list of attributes used), resolution_action (merge/link/suppress/review), resolution_date, resolved_by (user or system), review_status (auto-approved/pending_review/rejected), and rejection_reason. Supports MDM governance, SSOT maintenance, and regulatory right-to-erasure compliance.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` (
    `communication_subscription_id` BIGINT COMMENT 'System-generated unique identifier for the communication subscription record.',
    `customer_consent_record_id` BIGINT COMMENT 'Reference to the consent record that captures the legal basis for this subscription.',
    `party_id` BIGINT COMMENT 'Identifier of the party (customer) who holds the subscription.',
    `preference_id` BIGINT COMMENT 'Reference to the preference record that defines channel preferences for the party.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Subscription Management Oversight tracks which employee manages a customers communication subscription.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the subscription record was first created.',
    `dealer_code` STRING COMMENT 'Code of the dealer associated with a dealer‑specific subscription.',
    `delivery_channel` STRING COMMENT 'Preferred channel for delivering the communication.. Valid values are `email|sms|push|mail`',
    `external_subscription_code` STRING COMMENT 'External identifier used by third‑party systems to reference this subscription.',
    `frequency` STRING COMMENT 'How often the communication is sent to the party.. Valid values are `daily|weekly|monthly|event_triggered`',
    `is_test` BOOLEAN COMMENT 'Indicates whether the subscription is for testing purposes only.',
    `language` STRING COMMENT 'ISO 639-1 language code indicating the language of the communication.',
    `last_sent_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent communication sent under this subscription.',
    `marketing_cloud_key` STRING COMMENT 'Unique key used by Salesforce Marketing Cloud to identify the subscription.',
    `next_scheduled_send` TIMESTAMP COMMENT 'Planned timestamp for the next communication to be sent.',
    `subscription_date` DATE COMMENT 'Date when the subscription became effective.',
    `subscription_status` STRING COMMENT 'Current lifecycle status of the subscription.. Valid values are `active|paused|unsubscribed`',
    `subscription_type` STRING COMMENT 'Category of communication subscription (e.g., service_reminder, recall_alert, loyalty_newsletter, ev_charging_tips, ota_update_notification, promotional_offers, dealer_newsletter, safety_bulletin). [ENUM-REF-CANDIDATE: service_reminder|recall_alert|loyalty_newsletter|ev_charging_tips|ota_update_notification|promotional_offers|dealer_newsletter|safety_bulletin — promote to reference product]',
    `unsubscribe_date` DATE COMMENT 'Date when the subscription was terminated by the party.',
    `unsubscribe_reason` STRING COMMENT 'Reason provided by the party for unsubscribing, if any.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the subscription record.',
    CONSTRAINT pk_communication_subscription PRIMARY KEY(`communication_subscription_id`)
) COMMENT 'Manages customer subscriptions to specific communication programs, newsletters, and notification channels — distinct from consent_record (which captures legal basis) and preference (which captures channel preferences). Captures: party_id, subscription type (service_reminder/recall_alert/loyalty_newsletter/ev_charging_tips/ota_update_notification/promotional_offers/dealer_newsletter/safety_bulletin), subscription status (active/paused/unsubscribed), subscription date, unsubscribe date, unsubscribe reason, delivery channel (email/SMS/push/mail), frequency (daily/weekly/monthly/event-triggered), language, dealer code (for dealer-specific subscriptions), and Salesforce Marketing Cloud subscription key. Enables targeted communication management and CAN-SPAM/GDPR unsubscribe compliance.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`party_relationship` (
    `party_relationship_id` BIGINT COMMENT 'Surrogate primary key for the party relationship record.',
    `party_id` BIGINT COMMENT 'Identifier of the source party in the relationship (e.g., parent company, household head, driver).',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Customer Relationship Owner tracking records the employee overseeing a specific party‑to‑party relationship.',
    `to_party_id` BIGINT COMMENT 'Identifier of the target party in the relationship (e.g., subsidiary, household member, authorized driver).',
    `authorization_level` STRING COMMENT 'Level of authorization granted to the target party for actions on behalf of the source party.. Valid values are `read|write|admin|none`',
    `compliance_status` STRING COMMENT 'Compliance verification status of the relationship with respect to regulatory requirements.. Valid values are `compliant|non_compliant|under_review`',
    `contract_reference` STRING COMMENT 'External contract or agreement identifier that governs the relationship, if applicable.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the relationship record was first created in the lakehouse.',
    `party_relationship_description` STRING COMMENT 'Free-text notes or comments describing the nature of the relationship.',
    `effective_date` DATE COMMENT 'Date when the relationship becomes effective.',
    `expiry_date` DATE COMMENT 'Date when the relationship ends or is scheduled to terminate.',
    `inverse_role` STRING COMMENT 'Corresponding role of the target party from its perspective.',
    `is_legal_entity` BOOLEAN COMMENT 'Flag indicating whether the relationship is recognized as a legal entity relationship (e.g., corporate ownership) rather than informal.',
    `is_primary` BOOLEAN COMMENT 'Indicates if this relationship is the primary link among multiple relationships of the same type for the source party.',
    `jurisdiction` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the legal jurisdiction of the relationship.. Valid values are `^[A-Z]{3}$`',
    `last_review_date` DATE COMMENT 'Date when the relationship details were last reviewed for accuracy or compliance.',
    `party_relationship_status` STRING COMMENT 'Current lifecycle status of the relationship.. Valid values are `active|inactive|pending|terminated`',
    `relationship_role` STRING COMMENT 'Role of the source party within this relationship (e.g., owner, contact, driver, guarantor).',
    `relationship_strength` STRING COMMENT 'Numeric rating (1-5) indicating the assessed strength or importance of the relationship.',
    `relationship_type` STRING COMMENT 'Categorizes the nature of the link (e.g., parent_company, subsidiary, household_member, authorized_driver, fleet_contact, dealer_contact, co_owner, guarantor, beneficiary, partner, vendor, customer, employee). [ENUM-REF-CANDIDATE: parent_company|subsidiary|household_member|authorized_driver|fleet_contact|dealer_contact|co_owner|guarantor|beneficiary|partner|vendor|customer|employee — promote to reference product]',
    `updated_by` STRING COMMENT 'User or process identifier that performed the latest update.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the relationship record.',
    `created_by` STRING COMMENT 'User or process identifier that initially created the relationship record.',
    CONSTRAINT pk_party_relationship PRIMARY KEY(`party_relationship_id`)
) COMMENT 'Models relationships between party entities — corporate hierarchies (parent/subsidiary), household member relationships, authorized drivers, fleet account contacts, and dealer-customer relationships. Captures: from_party_id, to_party_id, relationship type (parent_company/subsidiary/household_member/authorized_driver/fleet_contact/dealer_contact/co_owner/guarantor/beneficiary), relationship role (from_party perspective), inverse_role (to_party perspective), effective date, expiry date, is_primary flag, authorization level, and source system. Enables corporate account hierarchy navigation, household relationship mapping, and authorized user management for connected vehicle services.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`pdi_record` (
    `pdi_record_id` BIGINT COMMENT 'Unique system-generated identifier for the PDI record.',
    `party_id` BIGINT COMMENT 'Identifier of the customer receiving the vehicle.',
    `technician_id` BIGINT COMMENT 'Identifier of the technician who performed the inspection.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Pre‑delivery inspection must validate vehicle configuration against the VIN registry to ensure correct build and compliance.',
    `connected_services_activated` BOOLEAN COMMENT 'True if connected vehicle services (e.g., telematics) were activated at delivery.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the PDI record was first created in the system.',
    `customer_signature_date` DATE COMMENT 'Date on which the customer signed the PDI acceptance form.',
    `customer_walkthrough_completed` BOOLEAN COMMENT 'True if the dealer completed the customer walkthrough of vehicle features.',
    `dealer_code` STRING COMMENT 'Code identifying the dealer that performed the PDI.. Valid values are `^[A-Z0-9]{3,6}$`',
    `delivery_date` DATE COMMENT 'Official date the vehicle was handed over to the customer.',
    `floor_mat_count` STRING COMMENT 'Count of floor mats provided with the vehicle.',
    `fuel_level_percent` DECIMAL(18,2) COMMENT 'Fuel level recorded at delivery expressed as a percentage of tank capacity.',
    `inspection_checklist_version` STRING COMMENT 'Version of the PDI checklist used during the inspection.. Valid values are `^vd+.d+$`',
    `inspection_items_json` STRING COMMENT 'JSON string capturing individual checklist item results and comments.',
    `key_count` STRING COMMENT 'Count of vehicle keys handed over to the customer.',
    `notes` STRING COMMENT 'Free‑form field for any additional observations or comments from the technician.',
    `odometer_km` BIGINT COMMENT 'Vehicle odometer reading at the time of delivery, in kilometers.',
    `ota_baseline_version` STRING COMMENT 'Baseline over‑the‑air software version installed on the vehicle at delivery.. Valid values are `^vd+.d+$`',
    `overall_pass` BOOLEAN COMMENT 'Flag indicating whether the vehicle passed the overall PDI (true) or failed (false).',
    `owner_manual_provided` BOOLEAN COMMENT 'Indicates whether the owner’s manual was supplied to the customer.',
    `pdi_date` DATE COMMENT 'Calendar date on which the PDI was conducted.',
    `pdi_number` STRING COMMENT 'Business identifier assigned to the PDI event, used for tracking and reference.. Valid values are `^[A-Z0-9]{8,12}$`',
    `pdi_record_status` STRING COMMENT 'Current lifecycle status of the PDI record.. Valid values are `pending|in_progress|completed|failed|rework|cancelled`',
    `pdi_timestamp` TIMESTAMP COMMENT 'Exact timestamp when the PDI inspection was performed.',
    `tpms_calibrated` BOOLEAN COMMENT 'Indicates whether the Tire Pressure Monitoring System was calibrated.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the PDI record.',
    CONSTRAINT pk_pdi_record PRIMARY KEY(`pdi_record_id`)
) COMMENT 'Pre-Delivery Inspection (PDI) record capturing the formal inspection and handover checklist completed by the dealer before vehicle delivery to the customer. Captures: VIN, party_id (receiving customer), dealer code, PDI date, PDI technician ID, inspection checklist version, overall PDI pass/fail status, individual inspection item results (JSON), fuel level at delivery, odometer at delivery, key count, floor mat count, owner manual provided flag, connected services activation status, OTA baseline software version, TPMS calibration status, customer walkthrough completed flag, customer signature date, and delivery date. Links vehicle domain (VIN) and dealer domain (dealer code) to customer delivery event.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`customer_test_drive` (
    `customer_test_drive_id` BIGINT COMMENT 'Primary key for local customer_test_drive reference',
    `sales_test_drive_id` BIGINT COMMENT 'FK reference to SSOT sales.sales_test_drive',
    CONSTRAINT pk_customer_test_drive PRIMARY KEY(`customer_test_drive_id`)
) COMMENT 'Reference to SSOT owner sales.sales_test_drive. Records customer test drive events at dealerships or OEM-hosted drive events. Captures: party_id, VIN (demo vehicle), dealer code, event type (dealer_showroom/OEM_drive_event/home_delivery_test/virtual), test drive date, scheduled start time, actual start time, actual end time, duration_minutes, sales consultant ID, vehicle model, trim level, powertrain type (ICE/HEV/PHEV/EV), customer feedback score (1-5), interest level (hot/warm/cold), follow-up action (quote_requested/brochure_sent/no_action), campaign_id (if event-driven), driver license verified flag, insurance verified flag, and Salesforce Activity ID. Feeds sales pipeline and product interest analytics.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`case` (
    `case_id` BIGINT COMMENT 'Unique system-generated identifier for the customer service case.',
    `employee_id` BIGINT COMMENT 'Identifier of the service agent currently assigned to the case.',
    `party_id` BIGINT COMMENT 'Identifier of the customer (individual, fleet, corporate) who raised the case.',
    `primary_employee_id` BIGINT COMMENT 'Identifier of the service agent currently assigned to the case.',
    `roadside_assistance_case_id` BIGINT COMMENT 'FK to roadside assistance case',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Needed for service case management to pull vehicle specifications, warranty status, and recall info from VIN registry.',
    `case_number` STRING COMMENT 'Business-visible case number assigned at creation.',
    `case_status` STRING COMMENT 'Current lifecycle state of the case.. Valid values are `new|in_progress|pending_customer|resolved|closed|escalated`',
    `case_type` STRING COMMENT 'High-level classification of the case purpose.. Valid values are `complaint|inquiry|warranty_claim|recall|roadside|goodwill`',
    `case_category` STRING COMMENT 'Primary business category for the case (e.g., Service, Sales, Technical).',
    `closed_timestamp` TIMESTAMP COMMENT 'Date and time when the case was finally closed.',
    `customer_satisfaction_score` STRING COMMENT 'Post‑resolution satisfaction rating provided by the customer (e.g., 1‑10).',
    `dealer_code` STRING COMMENT 'Identifier of the dealer handling the case.',
    `case_description` STRING COMMENT 'Full free‑text description of the issue, request or complaint.',
    `dynamics_case_reference` STRING COMMENT 'Native Microsoft Dynamics 365 identifier for the case.',
    `escalation_level` STRING COMMENT 'Level of escalation applied to the case, if any.. Valid values are `level1|level2|level3`',
    `escalation_reason` STRING COMMENT 'Reason why the case was escalated.',
    `opened_timestamp` TIMESTAMP COMMENT 'Date and time when the case was initially created.',
    `priority` STRING COMMENT 'Business priority level indicating urgency (P1 highest).. Valid values are `P1|P2|P3|P4`',
    `record_audit_created` TIMESTAMP COMMENT 'System timestamp when the case record was first persisted.',
    `record_audit_updated` TIMESTAMP COMMENT 'System timestamp of the most recent update to the case record.',
    `resolution_code` STRING COMMENT 'Standard code representing how the case was resolved.',
    `resolution_description` STRING COMMENT 'Free‑text description of the resolution actions taken.',
    `resolved_timestamp` TIMESTAMP COMMENT 'Date and time when the case was marked as resolved.',
    `salesforce_case_reference` STRING COMMENT 'Native Salesforce identifier for the case record.',
    `sla_due_timestamp` TIMESTAMP COMMENT 'Target date/time by which the case should be resolved per Service Level Agreement.',
    `source_channel` STRING COMMENT 'Channel through which the case was originally submitted.. Valid values are `phone|email|web|in_person|mobile_app`',
    `sub_category` STRING COMMENT 'More detailed sub‑category within the main category.',
    `subject` STRING COMMENT 'Brief title or subject line summarising the case.',
    `total_handle_time_minutes` STRING COMMENT 'Cumulative time spent handling the case, measured in minutes.',
    CONSTRAINT pk_case PRIMARY KEY(`case_id`)
) COMMENT 'Customer service case record tracking complaints, inquiries, warranty claims, recall notifications, and roadside assistance requests raised by customers through any channel. Captures: party_id, VIN (if vehicle-related), case number, case type (complaint/inquiry/warranty_claim/recall/roadside/goodwill/lemon_law/regulatory), case category, case sub-category, subject, description, priority (P1-P4), status (new/in_progress/pending_customer/resolved/closed/escalated), opened date, SLA due date, resolved date, closed date, resolution code, resolution description, dealer code (if dealer-handled), assigned agent ID, escalation level, escalation reason, total handle time (minutes), customer satisfaction score (post-resolution), Salesforce Case ID, and Microsoft Dynamics 365 Case ID. SSOT for customer service operations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` (
    `connected_service_enrollment_id` BIGINT COMMENT 'System‑generated unique identifier for each connected service enrollment record.',
    `account_id` BIGINT COMMENT 'Identifier of the billing account to which fees for this enrollment are charged.',
    `party_id` BIGINT COMMENT 'Unique identifier of the customer (person or organization) that owns the enrollment.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Connected Services Activation Log records the service advisor who enrolls a customer in a connected service.',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Connected service enrollment requires confirming vehicle eligibility and retrieving OTA capabilities from the VIN registry.',
    `activation_date` DATE COMMENT 'Date the service became active after any trial or provisioning period.',
    `auto_renew` BOOLEAN COMMENT 'Indicates whether the subscription automatically renews at the end of the term.',
    `billing_cycle` STRING COMMENT 'Frequency of recurring billing for the subscription.. Valid values are `monthly|annual`',
    `connected_app_user_reference` STRING COMMENT 'Identifier of the user account within the mobile or web app that accesses the service.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the enrollment record was first created in the system.',
    `data_plan_gb` DECIMAL(18,2) COMMENT 'Allocated data volume per billing cycle for data‑enabled services.',
    `data_usage_gb` DECIMAL(18,2) COMMENT 'Total data consumed by the service during the current billing cycle.',
    `device_imei` STRING COMMENT 'International Mobile Equipment Identity of the telematics device installed in the vehicle.',
    `enrollment_channel` STRING COMMENT 'Origin of the enrollment request (e.g., online portal, dealer, mobile app).. Valid values are `online|dealer|mobile_app|call_center|partner`',
    `enrollment_date` DATE COMMENT 'Date the customer initially signed up for the service (trial or paid).',
    `enrollment_reference_code` STRING COMMENT 'External reference number used in partner systems or printed on invoices.',
    `enrollment_status` STRING COMMENT 'Current lifecycle state of the enrollment.. Valid values are `trial|active|suspended|cancelled|expired`',
    `last_ota_update_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent over‑the‑air software update applied to the vehicle.',
    `monthly_fee` DECIMAL(18,2) COMMENT 'Recurring monthly charge for the selected service plan.',
    `price_currency` STRING COMMENT 'Three‑letter ISO currency code for monetary amounts (e.g., USD, EUR).',
    `service_plan_code` STRING COMMENT 'Code that uniquely identifies the subscription plan for the service type.',
    `service_type` STRING COMMENT 'Category of the connected service the customer is enrolled in.. Valid values are `telematics|remote_access|ev_charging|ota_updates|wifi_hotspot|v2x`',
    `sim_iccid` STRING COMMENT 'Integrated Circuit Card Identifier of the SIM used for cellular connectivity.',
    `status_reason` STRING COMMENT 'Free‑text explanation for the current status (e.g., payment failure, user request).',
    `subscription_end_date` DATE COMMENT 'Date the paid subscription period ends or is scheduled to terminate.',
    `subscription_start_date` DATE COMMENT 'Date the paid subscription period begins.',
    `telematics_provider` STRING COMMENT 'Company that supplies the telematics connectivity service.. Valid values are `Geotab|Bosch_IoT|Other`',
    `trial_end_date` DATE COMMENT 'Date the free trial period expires, if applicable.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the enrollment record.',
    CONSTRAINT pk_connected_service_enrollment PRIMARY KEY(`connected_service_enrollment_id`)
) COMMENT 'Tracks customer enrollment in connected vehicle and mobility services — telematics subscriptions, remote access apps, OTA update programs, EV charging network memberships, and V2X services. Captures: party_id, VIN, service_type (telematics/remote_access/ev_charging/ota_updates/wifi_hotspot/autonomous_feature/roadside_connect/v2x), service plan code, enrollment date, activation date, trial_end_date, subscription_start_date, subscription_end_date, auto_renew flag, billing_account_id (FK to billing domain), monthly_fee, data_plan_gb, connected_app_user_id, device_IMEI, SIM_ICCID, telematics_provider (Geotab/Bosch_IoT), enrollment channel, and enrollment status (trial/active/suspended/cancelled/expired). Bridges customer domain with mobility and billing domains.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` (
    `loyalty_program_id` BIGINT COMMENT 'System-generated unique identifier for the loyalty program.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the program record was first created in the system.',
    `loyalty_program_description` STRING COMMENT 'Detailed description of the program purpose, benefits and target audience.',
    `earn_rate_points_per_dollar` DECIMAL(18,2) COMMENT 'Number of loyalty points earned for each US dollar spent.',
    `eligibility_criteria` STRING COMMENT 'Business rules that determine which customers may join the program.',
    `end_date` DATE COMMENT 'Date when the loyalty program is terminated or superseded.',
    `enrollment_end_date` DATE COMMENT 'Date after which new enrollments are no longer accepted.',
    `enrollment_start_date` DATE COMMENT 'Date when new members may begin enrolling in the program.',
    `is_partner_program` BOOLEAN COMMENT 'Indicates whether the program is co‑branded with an external partner.',
    `last_review_date` DATE COMMENT 'Date when the program definition was last reviewed for relevance or compliance.',
    `loyalty_program_status` STRING COMMENT 'Current lifecycle state of the loyalty program.. Valid values are `active|inactive|suspended|pending|retired`',
    `loyalty_program_type` STRING COMMENT 'Classification of the program based on reward mechanism.. Valid values are `points|tier|cashback|hybrid`',
    `min_redemption_points` DECIMAL(18,2) COMMENT 'Minimum number of points a member must have before a redemption can be processed.',
    `loyalty_program_name` STRING COMMENT 'Human‑readable name of the loyalty program.',
    `notes` STRING COMMENT 'Free‑form field for additional remarks or operational comments.',
    `partner_redemption_options` STRING COMMENT 'Description of third‑party partners where points can be redeemed.',
    `points_earn_rate_currency` STRING COMMENT 'Currency in which the earn rate is expressed.. Valid values are `USD|EUR|GBP|CAD|JPY|AUD`',
    `points_expiry_months` STRING COMMENT 'Number of months after which earned points expire if not redeemed.',
    `points_redemption_currency` STRING COMMENT 'Currency in which the redemption rate is expressed.. Valid values are `USD|EUR|GBP|CAD|JPY|AUD`',
    `program_category` STRING COMMENT 'High‑level classification such as owner rewards, EV loyalty, fleet loyalty, or partner co‑branded.',
    `program_code` STRING COMMENT 'External business code used to reference the program in contracts and marketing materials.',
    `program_owner` STRING COMMENT 'Internal team or business unit responsible for the program.',
    `redemption_rate_points_per_dollar` DECIMAL(18,2) COMMENT 'Number of points required to redeem one US dollar of reward.',
    `salesforce_loyalty_program_reference` STRING COMMENT 'Identifier of the program in Salesforce Automotive Cloud.',
    `sponsoring_brand` STRING COMMENT 'Brand or sub‑brand that sponsors the loyalty program.',
    `start_date` DATE COMMENT 'Date when the loyalty program becomes effective for members.',
    `target_customer_type` STRING COMMENT 'Customer segment the program is designed for.. Valid values are `B2C|B2B|fleet`',
    `tier_structure` STRING COMMENT 'JSON string describing tier names, thresholds and associated benefits.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the program record.',
    `version_number` STRING COMMENT 'Incremental version identifier for change management.',
    CONSTRAINT pk_loyalty_program PRIMARY KEY(`loyalty_program_id`)
) COMMENT 'Reference master for all loyalty program definitions offered by Automotive — owner rewards, EV loyalty, fleet loyalty, and partner co-branded programs. Captures: program code, program name, program type (points/tier/cashback/hybrid), target customer type (B2C/B2B/fleet), sponsoring brand, program description, enrollment eligibility criteria, tier structure (JSON: tier names, thresholds, benefits), points earn rate (per dollar spent), points redemption rate (points per dollar), minimum redemption threshold, points expiry policy (months), partner redemption options, program start date, program end date, is_active flag, and Salesforce Loyalty Program ID. Reference data consumed by loyalty_membership.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`privacy_request` (
    `privacy_request_id` BIGINT COMMENT 'Unique system-generated identifier for the privacy request record.',
    `case_id` BIGINT COMMENT 'Link to the related service case or ticket in the case management system.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: GDPR Request Handling requires linking each privacy request to the employee responsible for processing it.',
    `party_id` BIGINT COMMENT 'Identifier of the customer (individual, fleet, corporate, or government) who submitted the privacy request.',
    `completion_date` DATE COMMENT 'Date the request was fully processed and closed.',
    `data_domains_affected` STRING COMMENT 'JSON‑encoded list of business data domains (e.g., vehicle, sales, after‑sales) impacted by the request.',
    `due_date` DATE COMMENT 'Regulatory deadline by which the request must be fulfilled.',
    `fulfillment_notes` STRING COMMENT 'Free‑form notes describing actions taken to satisfy the request.',
    `is_high_risk` BOOLEAN COMMENT 'Indicates whether the request involves high‑risk data (e.g., biometric, financial).',
    `priority` STRING COMMENT 'Business priority assigned to the request for handling urgency.. Valid values are `low|medium|high|critical`',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the privacy request record was first created in the lakehouse.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the privacy request record.',
    `regulatory_basis` STRING COMMENT 'Legal framework governing the request, such as GDPR, CCPA, PIPEDA, or LGPD.. Valid values are `GDPR|CCPA|PIPEDA|LGPD`',
    `rejection_reason` STRING COMMENT 'Explanation why a request was rejected or partially fulfilled.',
    `request_number` STRING COMMENT 'Business identifier assigned to the request for tracking and reference.',
    `request_status` STRING COMMENT 'Current processing status of the request.. Valid values are `received|in_progress|completed|rejected|partially_fulfilled`',
    `request_type` STRING COMMENT 'Type of privacy right exercised by the subject (e.g., erasure, access, portability, rectification, restriction, opt‑out).. Valid values are `erasure|access|portability|rectification|restriction|opt_out`',
    `submission_channel` STRING COMMENT 'Channel through which the privacy request was received.. Valid values are `web_portal|email|call_center|mail`',
    `submission_date` DATE COMMENT 'Date the privacy request was submitted by the subject.',
    `systems_notified` STRING COMMENT 'JSON‑encoded list of source systems (e.g., SAP S/4HANA, Salesforce) that were informed of the request.',
    `verification_method` STRING COMMENT 'Method used to verify the identity of the requestor before processing.. Valid values are `identity_document|knowledge_based|email_link|sms_code`',
    `verified_by` STRING COMMENT 'Identifier of the employee or system that performed the identity verification.',
    CONSTRAINT pk_privacy_request PRIMARY KEY(`privacy_request_id`)
) COMMENT 'Tracks formal customer privacy rights requests submitted under GDPR (right to erasure, right of access, right to portability, right to rectification), CCPA (right to delete, right to know, right to opt-out), and other applicable privacy regulations. Captures: party_id, request type (erasure/access/portability/rectification/restriction/opt_out), regulatory_basis (GDPR/CCPA/PIPEDA/LGPD), submission date, submission channel (web_portal/email/call_center/mail), request status (received/in_progress/completed/rejected/partially_fulfilled), due_date (regulatory deadline), completion_date, fulfillment_notes, rejection_reason, data_domains_affected (JSON list), systems_notified (JSON list), verification_method (identity verified before processing), verified_by, and case_id (linked service case). Mandatory for privacy compliance operations.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` (
    `dealer_customer_link_id` BIGINT COMMENT 'System-generated unique identifier for each dealer-customer relationship record.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Dealer‑Customer Relationship Management assigns a dealer account manager employee to each customer link.',
    `dealership_id` BIGINT COMMENT 'add column dealership_id (BIGINT) with FK to dealer.dealership.dealership_id - dealer-customer links must reference the specific dealership',
    `party_id` BIGINT COMMENT 'Unique identifier of the customer (person or organization) linked to the dealer.',
    `assignment_method` STRING COMMENT 'How the dealer was assigned to the customer: chosen by the customer, automatically by the system, or claimed by the dealer.. Valid values are `customer_selected|system_assigned|dealer_claimed`',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the dealer‑customer link record was first created in the lakehouse.',
    `dealer_code` STRING COMMENT 'Alphanumeric code that uniquely identifies the dealership within the CDK Global DMS.',
    `dealer_customer_link_status` STRING COMMENT 'Current lifecycle state of the relationship (active, inactive, terminated, pending).. Valid values are `active|inactive|terminated|pending`',
    `is_primary` BOOLEAN COMMENT 'Indicates whether this dealer is the primary dealer for the customer (true) or a secondary/auxiliary dealer (false).',
    `last_service_date` DATE COMMENT 'Most recent date on which the customer received service at this dealer.',
    `notes` STRING COMMENT 'Optional free‑text field for comments, special conditions, or business remarks about the relationship.',
    `relationship_end_date` DATE COMMENT 'Date when the dealer-customer relationship was terminated or is scheduled to end (nullable for active relationships).',
    `relationship_number` STRING COMMENT 'Human‑readable business identifier for the dealer‑customer agreement, used in contracts and reporting.',
    `relationship_start_date` DATE COMMENT 'Date when the dealer-customer relationship became effective.',
    `relationship_type` STRING COMMENT 'Classification of the dealer-customer link (e.g., primary selling dealer, service dealer, preferred dealer, conquest dealer).. Valid values are `selling_dealer|service_dealer|preferred_dealer|conquest_dealer`',
    `salesforce_account_dealer_reference` STRING COMMENT 'Identifier linking this record to the corresponding account‑dealer relationship in Salesforce Automotive Cloud.',
    `total_service_visits` STRING COMMENT 'Cumulative count of service appointments the customer has completed at this dealer.',
    `total_spend_at_dealer` DECIMAL(18,2) COMMENT 'Aggregate monetary amount (USD) the customer has spent on sales, service, parts, and accessories at this dealer.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent modification to the dealer‑customer link record.',
    `vin` STRING COMMENT '17‑character vehicle identifier when the relationship is specific to a particular vehicle.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    CONSTRAINT pk_dealer_customer_link PRIMARY KEY(`dealer_customer_link_id`)
) COMMENT 'Association entity recording the relationship between a customer party and a specific dealership — capturing primary dealer assignment, service dealer preference, selling dealer history, and conquest/retention dealer transitions. Captures: party_id, dealer_code, relationship type (selling_dealer/service_dealer/preferred_dealer/conquest_dealer), VIN (if vehicle-specific relationship), relationship start date, relationship end date, is_primary flag, assignment method (customer_selected/system_assigned/dealer_claimed), last_service_date, total_service_visits, total_spend_at_dealer, and Salesforce Account-Dealer relationship ID. Enables dealer performance attribution, customer retention by dealer, and dealer network territory analysis.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`promotion` (
    `promotion_id` BIGINT COMMENT 'Primary key for promotion',
    `campaign_id` BIGINT COMMENT 'Identifier of the broader marketing campaign that owns this promotion.',
    `predecessor_promotion_id` BIGINT COMMENT 'Self-referencing FK on promotion (predecessor_promotion_id)',
    `employee_id` BIGINT COMMENT 'User identifier of the person who created the promotion record.',
    `promotion_updated_by_user_employee_id` BIGINT COMMENT 'User identifier of the person who last modified the promotion record.',
    `applicable_geographies` STRING COMMENT 'Geographic regions (country codes) where the promotion is valid.',
    `applicable_vehicle_models` STRING COMMENT 'Comma‑separated list of vehicle models eligible for the promotion.',
    `budget_amount` DECIMAL(18,2) COMMENT 'Total monetary budget allocated for the promotion.',
    `channel` STRING COMMENT 'Primary distribution channel through which the promotion is offered.',
    `cltv_impact_estimate` DECIMAL(18,2) COMMENT 'Estimated change in Customer Lifetime Value attributable to the promotion.',
    `promotion_code` STRING COMMENT 'Unique alphanumeric code assigned to the promotion for tracking and lookup.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the promotion record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for monetary values associated with the promotion.',
    `customer_segment` STRING COMMENT 'Business segment classification for the promotions target customers.',
    `discount_type` STRING COMMENT 'Indicates whether the discount_value is a percentage of the transaction amount or a fixed monetary amount.',
    `discount_value` DECIMAL(18,2) COMMENT 'Numeric value of the discount offered; interpretation depends on discount_type (percentage or fixed amount).',
    `eligibility_criteria` STRING COMMENT 'Business rules that define which transactions or customers qualify for the promotion.',
    `end_date` DATE COMMENT 'Date after which the promotion is no longer valid.',
    `is_exclusive` BOOLEAN COMMENT 'True if the promotion cannot be combined with other promotions.',
    `loyalty_program_flag` BOOLEAN COMMENT 'Indicates whether the promotion is part of a loyalty program.',
    `max_discount_amount` DECIMAL(18,2) COMMENT 'Upper limit on the discount value that can be applied per transaction.',
    `min_purchase_amount` DECIMAL(18,2) COMMENT 'Minimum transaction amount required for the promotion to be applicable.',
    `promotion_name` STRING COMMENT 'Human‑readable name of the promotion as used in marketing materials.',
    `nps_impact_estimate` DECIMAL(18,2) COMMENT 'Estimated effect of the promotion on Net Promoter Score (percentage points).',
    `priority` STRING COMMENT 'Numeric priority used to rank promotions when multiple are applicable.',
    `promotion_type` STRING COMMENT 'Category of the promotion indicating the mechanism used to provide value to the customer.',
    `promotional_message` STRING COMMENT 'Marketing copy displayed to customers describing the promotion.',
    `redemption_count` STRING COMMENT 'Running total of how many times the promotion has been redeemed.',
    `required_product_category` STRING COMMENT 'Product category that must be purchased for the promotion to apply.',
    `start_date` DATE COMMENT 'Date on which the promotion becomes effective and can be redeemed.',
    `promotion_status` STRING COMMENT 'Current lifecycle state of the promotion.',
    `target_audience` STRING COMMENT 'Segment of customers for whom the promotion is intended.',
    `terms_and_conditions` STRING COMMENT 'Legal and operational rules governing the promotion.',
    `total_redemption_limit` STRING COMMENT 'Maximum total number of redemptions allowed across all customers.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the promotion record.',
    `usage_limit_per_customer` STRING COMMENT 'Maximum number of times a single customer may redeem the promotion.',
    CONSTRAINT pk_promotion PRIMARY KEY(`promotion_id`)
) COMMENT 'Master reference table for promotion. Referenced by promotion_id.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`customer`.`survey` (
    `survey_id` BIGINT COMMENT 'Primary key for survey',
    `follow_up_survey_id` BIGINT COMMENT 'Self-referencing FK on survey (follow_up_survey_id)',
    `survey_category` STRING COMMENT 'Broad analytical grouping used for reporting and segmentation.',
    `channel` STRING COMMENT 'Mechanism used to present the survey to respondents.',
    `confidentiality_level` STRING COMMENT 'Data classification governing who may view survey content and responses.',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the survey definition was initially entered into the system.',
    `survey_description` STRING COMMENT 'Narrative explaining the objectives, scope, and content of the survey.',
    `effective_from` DATE COMMENT 'Calendar date on which the survey may start being offered to respondents.',
    `effective_until` DATE COMMENT 'Calendar date after which the survey is no longer available (nullable for open‑ended surveys).',
    `incentive_type` STRING COMMENT 'Type of reward provided for completing the survey.',
    `incentive_value` DECIMAL(18,2) COMMENT 'Financial amount associated with the incentive; null when non‑monetary.',
    `is_anonymous` BOOLEAN COMMENT 'True when responses are recorded without linking to respondent identities.',
    `is_mandatory` BOOLEAN COMMENT 'True when respondents are required to complete the survey as part of a process.',
    `language` STRING COMMENT 'ISO language code indicating the language in which the survey is delivered.',
    `max_responses_allowed` STRING COMMENT 'Cap on total responses that can be accepted; null means unlimited.',
    `survey_name` STRING COMMENT 'Human‑readable title of the survey.',
    `owner_contact_email` STRING COMMENT 'Email address of the primary owner or coordinator for the survey.',
    `owner_contact_phone` STRING COMMENT 'Phone number of the primary owner or coordinator for the survey.',
    `owner_department` STRING COMMENT 'Business unit that created and maintains the survey.',
    `response_deadline` DATE COMMENT 'Final date by which responses must be received for the survey period.',
    `survey_status` STRING COMMENT 'Indicates whether the survey is being designed, is live, or has been retired.',
    `survey_type` STRING COMMENT 'Category that defines the primary intent of the survey.',
    `target_audience` STRING COMMENT 'Segment of customers or stakeholders the survey is designed for.',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the latest modification to any survey attribute.',
    `version_number` STRING COMMENT 'Sequential integer indicating the revision of the survey definition.',
    CONSTRAINT pk_survey PRIMARY KEY(`survey_id`)
) COMMENT 'Master reference table for survey. Referenced by survey_id.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ADD CONSTRAINT `fk_customer_party_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_automotive_v1`.`customer`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ADD CONSTRAINT `fk_customer_individual_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ADD CONSTRAINT `fk_customer_organization_account_parent_organization_account_id` FOREIGN KEY (`parent_organization_account_id`) REFERENCES `vibe_automotive_v1`.`customer`.`organization_account`(`organization_account_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ADD CONSTRAINT `fk_customer_household_individual_id` FOREIGN KEY (`individual_id`) REFERENCES `vibe_automotive_v1`.`customer`.`individual`(`individual_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ADD CONSTRAINT `fk_customer_household_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_automotive_v1`.`customer`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ADD CONSTRAINT `fk_customer_household_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ADD CONSTRAINT `fk_customer_contact_point_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ADD CONSTRAINT `fk_customer_vehicle_ownership_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ADD CONSTRAINT `fk_customer_loyalty_membership_household_id` FOREIGN KEY (`household_id`) REFERENCES `vibe_automotive_v1`.`customer`.`household`(`household_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ADD CONSTRAINT `fk_customer_loyalty_membership_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_automotive_v1`.`customer`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ADD CONSTRAINT `fk_customer_loyalty_membership_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ADD CONSTRAINT `fk_customer_loyalty_transaction_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_automotive_v1`.`customer`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ADD CONSTRAINT `fk_customer_loyalty_transaction_promotion_id` FOREIGN KEY (`promotion_id`) REFERENCES `vibe_automotive_v1`.`customer`.`promotion`(`promotion_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ADD CONSTRAINT `fk_customer_segment_membership_customer_segment_id` FOREIGN KEY (`customer_segment_id`) REFERENCES `vibe_automotive_v1`.`customer`.`customer_segment`(`customer_segment_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ADD CONSTRAINT `fk_customer_segment_membership_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ADD CONSTRAINT `fk_customer_preference_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_consent_record` ADD CONSTRAINT `fk_customer_customer_consent_record_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ADD CONSTRAINT `fk_customer_nps_response_case_id` FOREIGN KEY (`case_id`) REFERENCES `vibe_automotive_v1`.`customer`.`case`(`case_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ADD CONSTRAINT `fk_customer_nps_response_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ADD CONSTRAINT `fk_customer_nps_response_survey_id` FOREIGN KEY (`survey_id`) REFERENCES `vibe_automotive_v1`.`customer`.`survey`(`survey_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ADD CONSTRAINT `fk_customer_cltv_record_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ADD CONSTRAINT `fk_customer_journey_touchpoint_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_automotive_v1`.`customer`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ADD CONSTRAINT `fk_customer_journey_touchpoint_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_account` ADD CONSTRAINT `fk_customer_customer_fleet_account_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_vehicle_assignment` ADD CONSTRAINT `fk_customer_customer_fleet_vehicle_assignment_customer_fleet_account_id` FOREIGN KEY (`customer_fleet_account_id`) REFERENCES `vibe_automotive_v1`.`customer`.`customer_fleet_account`(`customer_fleet_account_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_vehicle_assignment` ADD CONSTRAINT `fk_customer_customer_fleet_vehicle_assignment_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ADD CONSTRAINT `fk_customer_identity_resolution_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ADD CONSTRAINT `fk_customer_communication_subscription_customer_consent_record_id` FOREIGN KEY (`customer_consent_record_id`) REFERENCES `vibe_automotive_v1`.`customer`.`customer_consent_record`(`customer_consent_record_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ADD CONSTRAINT `fk_customer_communication_subscription_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ADD CONSTRAINT `fk_customer_communication_subscription_preference_id` FOREIGN KEY (`preference_id`) REFERENCES `vibe_automotive_v1`.`customer`.`preference`(`preference_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ADD CONSTRAINT `fk_customer_party_relationship_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ADD CONSTRAINT `fk_customer_party_relationship_to_party_id` FOREIGN KEY (`to_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ADD CONSTRAINT `fk_customer_pdi_record_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ADD CONSTRAINT `fk_customer_connected_service_enrollment_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ADD CONSTRAINT `fk_customer_privacy_request_case_id` FOREIGN KEY (`case_id`) REFERENCES `vibe_automotive_v1`.`customer`.`case`(`case_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ADD CONSTRAINT `fk_customer_privacy_request_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ADD CONSTRAINT `fk_customer_dealer_customer_link_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ADD CONSTRAINT `fk_customer_promotion_predecessor_promotion_id` FOREIGN KEY (`predecessor_promotion_id`) REFERENCES `vibe_automotive_v1`.`customer`.`promotion`(`promotion_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ADD CONSTRAINT `fk_customer_survey_follow_up_survey_id` FOREIGN KEY (`follow_up_survey_id`) REFERENCES `vibe_automotive_v1`.`customer`.`survey`(`survey_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`customer` SET TAGS ('dbx_pii_division' = 'business');
ALTER SCHEMA `vibe_automotive_v1`.`customer` SET TAGS ('dbx_pii_domain' = 'customer');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` SET TAGS ('dbx_pii_subdomain' = 'identity_management');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Party Identifier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `loyalty_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Program Identifier (LOYALTY_ID)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line 1 (ADDR_LINE1)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line 2 (ADDR_LINE2)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `address_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Type (ADDR_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `address_type` SET TAGS ('dbx_pii_value_regex' = 'billing|shipping|mailing|primary');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `city` SET TAGS ('dbx_pii_business_glossary_term' = 'City (CITY)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `city` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `city` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `communication_preference` SET TAGS ('dbx_pii_business_glossary_term' = 'Communication Preference (COMM_PREF)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `communication_preference` SET TAGS ('dbx_pii_value_regex' = 'email|sms|phone|mail');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Country Code (ISO 3166‑1 Alpha‑3)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `credit_rating` SET TAGS ('dbx_pii_business_glossary_term' = 'Credit Rating (CR)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `credit_rating` SET TAGS ('dbx_pii_value_regex' = 'AAA|AA|A|BBB|BB|B');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `credit_rating` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `credit_rating` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `customer_lifetime_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Lifetime Value (CLTV)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `customer_lifetime_value` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `customer_lifetime_value` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `customer_segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Segment (SEGMENT)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `customer_segment` SET TAGS ('dbx_pii_value_regex' = 'mass_market|premium|fleet|government|enterprise');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `data_residency_region` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Residency Region (DATA_RES_REGION)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_pii_business_glossary_term' = 'Date of Birth (DOB)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_pii_pii_dob' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_business_glossary_term' = 'Email Address (EMAIL)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_value_regex' = '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `external_reference_code` SET TAGS ('dbx_pii_business_glossary_term' = 'External Reference Code (EXT_REF_CODE)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `gdpr_consent_email` SET TAGS ('dbx_pii_business_glossary_term' = 'GDPR Email Consent (GDPR_EMAIL)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `gdpr_consent_email` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `gdpr_consent_email` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `gdpr_consent_sms` SET TAGS ('dbx_pii_business_glossary_term' = 'GDPR SMS Consent (GDPR_SMS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `incorporation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Incorporation Date (INCORP_DATE)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `industry_classification` SET TAGS ('dbx_pii_business_glossary_term' = 'Industry Classification (NAICS/SIC)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `is_tax_exempt` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Exempt Flag (TAX_EXEMPT)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `kyc_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Know‑Your‑Customer Status (KYC_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `kyc_status` SET TAGS ('dbx_pii_value_regex' = 'pending|verified|rejected');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `last_verified_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Verified Date (LAST_VERIFIED)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `legal_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Legal Name (FULL)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `legal_name` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `legal_name` SET TAGS ('dbx_pii_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Lifecycle Status (LIFECYCLE_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_pii_value_regex' = 'prospect|active|inactive|churned|suspended');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `loyalty_tier` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Tier (LOYALTY_TIER)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `loyalty_tier` SET TAGS ('dbx_pii_value_regex' = 'bronze|silver|gold|platinum');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `marketing_opt_in` SET TAGS ('dbx_pii_business_glossary_term' = 'Marketing Opt‑In Flag (MKT_OPT_IN)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `net_promoter_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Promoter Score (NPS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes (FREE_TEXT)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `onboarding_channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Onboarding Channel (ONB_CHANNEL)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `onboarding_channel` SET TAGS ('dbx_pii_value_regex' = 'online|branch|dealer|partner');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `onboarding_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Onboarding Date (ONB_DATE)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `party_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Party Type (INDIVIDUAL|ORGANIZATION)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `party_type` SET TAGS ('dbx_pii_value_regex' = 'individual|organization');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Phone Number (PHONE)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Postal Code (POSTAL_CODE)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `preferred_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Preferred Currency (CURR_PREF)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `preferred_language` SET TAGS ('dbx_pii_business_glossary_term' = 'Preferred Language (LANG_PREF)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `primary_contact_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Contact Method (PRIMARY_CONTACT)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `primary_contact_method` SET TAGS ('dbx_pii_value_regex' = 'email|phone|mail');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `primary_contact_method` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `registration_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Registration Number (REG_NO)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `registration_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `registration_number` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `source_system_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Source System Identifier (SRC_SYS_ID)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_business_glossary_term' = 'State or Province (STATE_PROV)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `tax_exempt_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Exempt Reason (TAX_EXEMPT_REASON)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Identification Number (TIN)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party` ALTER COLUMN `trade_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Trade Name (DBA)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` SET TAGS ('dbx_pii_subdomain' = 'identity_management');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `individual_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Individual ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Preferred Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `primary_dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Preferred Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `dealer_contact_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Salesforce Contact ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `annual_income_band` SET TAGS ('dbx_pii_business_glossary_term' = 'Annual Income Band');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `annual_income_band` SET TAGS ('dbx_pii_value_regex' = '0-25k|25k-50k|50k-75k|75k-100k|100k-150k|150k+');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `city` SET TAGS ('dbx_pii_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `city` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `cltv_estimate` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Lifetime Value Estimate (CLTV)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `cltv_estimate` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `cltv_estimate` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `consent_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Marketing Consent Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Country Code (ISO 3166‑1 Alpha‑3)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `country_of_residence` SET TAGS ('dbx_pii_business_glossary_term' = 'Country of Residence (ISO 3166‑1 Alpha‑3)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `customer_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `customer_type` SET TAGS ('dbx_pii_value_regex' = 'b2c|b2b|government|fleet');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_pii_business_glossary_term' = 'Date of Birth (DOB)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `date_of_birth` SET TAGS ('dbx_pii_pii_dob' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `driver_license_expiry` SET TAGS ('dbx_pii_business_glossary_term' = 'Driver License Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `driver_license_expiry` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `driver_license_expiry` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `driver_license_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Driver License Number');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `driver_license_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `driver_license_number` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `driver_license_state` SET TAGS ('dbx_pii_business_glossary_term' = 'Driver License State/Province');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `driver_license_state` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `driver_license_state` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `education_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Education Level');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `education_level` SET TAGS ('dbx_pii_value_regex' = 'high_school|associate|bachelor|master|doctorate|other');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_business_glossary_term' = 'Email Address');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `employment_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Employment Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `employment_status` SET TAGS ('dbx_pii_value_regex' = 'employed|unemployed|student|retired|self_employed|other');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `first_name` SET TAGS ('dbx_pii_business_glossary_term' = 'First Name (FN)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `first_name` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `first_name` SET TAGS ('dbx_pii_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `gender` SET TAGS ('dbx_pii_business_glossary_term' = 'Gender');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `gender` SET TAGS ('dbx_pii_value_regex' = 'male|female|other|prefer_not_to_say');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `gender` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `gender` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `gender` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `household_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Household ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `individual_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Individual Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `individual_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|suspended|prospect|deceased');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `last_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Name (LN)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `last_name` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `last_name` SET TAGS ('dbx_pii_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `last_purchase_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Purchase Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `loyalty_tier` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Tier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `loyalty_tier` SET TAGS ('dbx_pii_value_regex' = 'bronze|silver|gold|platinum|elite');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `marital_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Marital Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `marital_status` SET TAGS ('dbx_pii_value_regex' = 'single|married|divorced|widowed|partnered|prefer_not_to_say');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `marital_status` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `marital_status` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `marketing_opt_in_email` SET TAGS ('dbx_pii_business_glossary_term' = 'Marketing Opt‑In Email');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `marketing_opt_in_email` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `marketing_opt_in_email` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `marketing_opt_in_phone` SET TAGS ('dbx_pii_business_glossary_term' = 'Marketing Opt‑In Phone');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `marketing_opt_in_phone` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `marketing_opt_in_phone` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `marketing_opt_in_sms` SET TAGS ('dbx_pii_business_glossary_term' = 'Marketing Opt‑In SMS');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `middle_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Middle Name (MN)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `middle_name` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `middle_name` SET TAGS ('dbx_pii_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `nationality` SET TAGS ('dbx_pii_business_glossary_term' = 'Nationality (ISO 3166‑1 Alpha‑3)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `nationality` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `nationality` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `nps_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Promoter Score (NPS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `occupation` SET TAGS ('dbx_pii_business_glossary_term' = 'Occupation');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Phone Number');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `preferred_contact_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Preferred Contact Method');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `preferred_contact_method` SET TAGS ('dbx_pii_value_regex' = 'email|phone|sms|mail|app_notification');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `primary_spoken_language` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Spoken Language');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Segment');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_business_glossary_term' = 'State/Province');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `suffix` SET TAGS ('dbx_pii_business_glossary_term' = 'Name Suffix');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `suffix` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `suffix` SET TAGS ('dbx_pii_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ALTER COLUMN `vehicle_ownership_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Ownership Count');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` SET TAGS ('dbx_pii_subdomain' = 'identity_management');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `organization_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Organization Account ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `parent_organization_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Parent Organization Account ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `account_tier` SET TAGS ('dbx_pii_business_glossary_term' = 'Account Tier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `account_tier` SET TAGS ('dbx_pii_value_regex' = 'strategic|key|standard');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `accounts_payable_contact_email` SET TAGS ('dbx_pii_business_glossary_term' = 'Accounts Payable Contact Email');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `accounts_payable_contact_email` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `accounts_payable_contact_email` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `accounts_payable_contact_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Accounts Payable Contact Name');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `accounts_payable_contact_name` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `accounts_payable_contact_name` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `accounts_payable_contact_phone` SET TAGS ('dbx_pii_business_glossary_term' = 'Accounts Payable Contact Phone');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `accounts_payable_contact_phone` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `accounts_payable_contact_phone` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `annual_revenue` SET TAGS ('dbx_pii_business_glossary_term' = 'Annual Revenue (USD)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `annual_revenue` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `annual_revenue` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `city` SET TAGS ('dbx_pii_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `city` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `city` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `classification` SET TAGS ('dbx_pii_business_glossary_term' = 'Organization Classification');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `classification` SET TAGS ('dbx_pii_value_regex' = 'corporate|fleet|government|leasing');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `contract_vehicle_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Contract Vehicle Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `contract_vehicle_type` SET TAGS ('dbx_pii_value_regex' = 'GSA|state|none');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `country` SET TAGS ('dbx_pii_business_glossary_term' = 'Country Code (ISO 3166-1 Alpha-3)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `country` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `country` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `credit_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Credit Limit (USD)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `credit_limit` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `credit_limit` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `dba_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Doing Business As (DBA) Name');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `duns_number` SET TAGS ('dbx_pii_business_glossary_term' = 'DUNS Number (Data Universal Numbering System)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `duns_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `duns_number` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `fleet_size` SET TAGS ('dbx_pii_business_glossary_term' = 'Fleet Size');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `government_entity_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Government Entity Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `government_entity_type` SET TAGS ('dbx_pii_value_regex' = 'federal|state|municipal|private');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `industry_codes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Industry Codes');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `legal_entity_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Legal Entity Name');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `naics_code` SET TAGS ('dbx_pii_business_glossary_term' = 'North American Industry Classification System (NAICS) Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `number_of_employees` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Employees');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `number_of_employees` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `organization_account_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Account Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `organization_account_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|suspended|pending|closed');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `payment_terms` SET TAGS ('dbx_pii_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `payment_terms` SET TAGS ('dbx_pii_value_regex' = 'net_30|net_45|net_60|due_on_receipt|custom');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `preferred_oem_programs` SET TAGS ('dbx_pii_business_glossary_term' = 'Preferred OEM Programs');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Contact Email');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Contact Phone');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `procurement_contact_email` SET TAGS ('dbx_pii_business_glossary_term' = 'Procurement Contact Email');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `procurement_contact_email` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `procurement_contact_email` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `procurement_contact_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Procurement Contact Name');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `procurement_contact_name` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `procurement_contact_name` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `procurement_contact_phone` SET TAGS ('dbx_pii_business_glossary_term' = 'Procurement Contact Phone');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `procurement_contact_phone` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `procurement_contact_phone` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `sap_customer_number` SET TAGS ('dbx_pii_business_glossary_term' = 'SAP Customer Number');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `sic_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Standard Industrial Classification (SIC) Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `state` SET TAGS ('dbx_pii_business_glossary_term' = 'State/Province');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `state` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `state` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_pii_business_glossary_term' = 'Tax Identification Number (EIN)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` SET TAGS ('dbx_pii_subdomain' = 'identity_management');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `household_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Household Identifier (HH_ID)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `individual_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Decision Maker Party ID (DM_ID)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `loyalty_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Program Identifier (LP_ID)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Decision Maker Party ID (DM_ID)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line 2 (AL2)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `census_block` SET TAGS ('dbx_pii_business_glossary_term' = 'Census Block Code (CBC)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `city` SET TAGS ('dbx_pii_business_glossary_term' = 'City (CTY)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `city` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `city` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `cltv` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Lifetime Value (CLTV)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `cltv` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `cltv` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Country Code (ISO 3166-1 Alpha-3) (CC)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (CRT_TS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `estimated_income_band` SET TAGS ('dbx_pii_business_glossary_term' = 'Estimated Household Income Band (INC_BAND)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `estimated_income_band` SET TAGS ('dbx_pii_value_regex' = 'low|mid|high|very_high');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `formation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Household Formation Date (HFD)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `household_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Household Status (HS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `household_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|closed|pending');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `household_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Household Type (HT)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `household_type` SET TAGS ('dbx_pii_value_regex' = 'single|family|multi-generational|other');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `last_contact_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Contact Date (LCT_DATE)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `marketing_opt_in` SET TAGS ('dbx_pii_business_glossary_term' = 'Marketing Opt-In Flag (MKT_OPT_IN)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `member_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Household Members (MEM_COUNT)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `household_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Household Name (HHN)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `household_name` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `household_name` SET TAGS ('dbx_pii_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `nps_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Promoter Score (NPS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Postal Code (PC)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `primary_email` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Email Address (PEA)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `primary_email` SET TAGS ('dbx_pii_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `primary_email` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `primary_email` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `primary_phone` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Phone Number (PPN)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `primary_phone` SET TAGS ('dbx_pii_value_regex' = '^+?[0-9]{7,15}$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `primary_phone` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `primary_phone` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `source_system_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Source System Record Identifier (SRC_ID)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_business_glossary_term' = 'State or Province (ST)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `street_address` SET TAGS ('dbx_pii_business_glossary_term' = 'Street Address (SA)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `street_address` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `street_address` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp (UPD_TS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`household` ALTER COLUMN `vehicle_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Vehicles Owned by Household (VEH_COUNT)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` SET TAGS ('dbx_pii_subdomain' = 'identity_management');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `contact_point_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Contact Point ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Communication Channel');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `channel` SET TAGS ('dbx_pii_value_regex' = 'voice|sms|email|mail|push|social');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `city` SET TAGS ('dbx_pii_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `city` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `city` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `classification` SET TAGS ('dbx_pii_business_glossary_term' = 'Contact Point Classification');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `classification` SET TAGS ('dbx_pii_value_regex' = 'personal|business|dealer|fleet|government');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `communication_preference` SET TAGS ('dbx_pii_business_glossary_term' = 'Communication Preference');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `communication_preference` SET TAGS ('dbx_pii_value_regex' = 'marketing|transactional|service|none');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `contact_point_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Contact Point Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `contact_point_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|pending|suspended|deleted');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `contact_point_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Contact Point Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `contact_point_type` SET TAGS ('dbx_pii_value_regex' = 'email|phone|address|social|other');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Country Code (ISO 3166‑1 Alpha‑3)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `country_code` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_business_glossary_term' = 'Email Address');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_value_regex' = '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `is_primary` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Contact Flag');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `is_verified` SET TAGS ('dbx_pii_business_glossary_term' = 'Verification Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `language_preference` SET TAGS ('dbx_pii_business_glossary_term' = 'Language Preference');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `last_used_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Used Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `opt_in_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Opt‑In Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `opt_out_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Opt‑Out Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Phone Number');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_value_regex' = '^+?[0-9]{7,15}$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `preferred_contact_hours` SET TAGS ('dbx_pii_business_glossary_term' = 'Preferred Contact Hours');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `preferred_time_zone` SET TAGS ('dbx_pii_business_glossary_term' = 'Preferred Time Zone');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `social_handle` SET TAGS ('dbx_pii_business_glossary_term' = 'Social Media Handle');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `social_handle` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `social_handle` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `social_platform` SET TAGS ('dbx_pii_business_glossary_term' = 'Social Media Platform');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `social_platform` SET TAGS ('dbx_pii_value_regex' = 'twitter|linkedin|facebook|instagram|other');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_business_glossary_term' = 'State/Province');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `value` SET TAGS ('dbx_pii_business_glossary_term' = 'Contact Point Value');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `verification_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Verification Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `verification_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Verification Method');
ALTER TABLE `vibe_automotive_v1`.`customer`.`contact_point` ALTER COLUMN `verification_method` SET TAGS ('dbx_pii_value_regex' = 'email|sms|call|postal|in_person|other');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` SET TAGS ('dbx_pii_subdomain' = 'ownership_tracking');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `vehicle_ownership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Ownership Record ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `connected_vehicle_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Vehicle Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Telematics Device Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `telematics_device_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `vehicle_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Program Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `acquisition_channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Acquisition Channel');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `acquisition_channel` SET TAGS ('dbx_pii_value_regex' = 'dealer|direct|auction|fleet');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `acquisition_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Acquisition Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `acquisition_dealer_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Acquisition Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `current_odometer` SET TAGS ('dbx_pii_business_glossary_term' = 'Current Odometer Reading');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `disposition_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Disposition Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `disposition_odometer` SET TAGS ('dbx_pii_business_glossary_term' = 'Disposition Odometer Reading');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `disposition_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Disposition Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `disposition_type` SET TAGS ('dbx_pii_value_regex' = 'sold|traded|totaled|repossessed|retired');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `insurance_carrier` SET TAGS ('dbx_pii_business_glossary_term' = 'Insurance Carrier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `insurance_expiry` SET TAGS ('dbx_pii_business_glossary_term' = 'Insurance Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Insurance Policy Number');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `insurance_policy_number` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `is_primary_vehicle` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Vehicle Indicator');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `lien_holder_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Lien Holder Name');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `lien_holder_name` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `odometer_at_acquisition` SET TAGS ('dbx_pii_business_glossary_term' = 'Acquisition Odometer Reading');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `ownership_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Ownership Contract Number');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `ownership_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Ownership Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `ownership_type` SET TAGS ('dbx_pii_value_regex' = 'retail|lease|fleet|government');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `purchase_price` SET TAGS ('dbx_pii_business_glossary_term' = 'Purchase Price');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `purchase_price` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `purchase_price` SET TAGS ('dbx_pii_pii_financial' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `registration_country` SET TAGS ('dbx_pii_business_glossary_term' = 'Registration Country');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `registration_expiry` SET TAGS ('dbx_pii_business_glossary_term' = 'Registration Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `registration_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Registration Number');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `registration_state` SET TAGS ('dbx_pii_business_glossary_term' = 'Registration State');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `title_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Title Number');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `title_state` SET TAGS ('dbx_pii_business_glossary_term' = 'Title State');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `trade_in_vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Trade‑In Vehicle VIN');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `vehicle_ownership_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Ownership Record Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ALTER COLUMN `vehicle_ownership_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|closed|pending');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` SET TAGS ('dbx_pii_subdomain' = 'engagement_programs');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Membership ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Enrollment Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `household_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Household ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `loyalty_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Program ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `current_tier` SET TAGS ('dbx_pii_business_glossary_term' = 'Current Tier (BRONZE/SILVER/GOLD/PLATINUM)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `current_tier` SET TAGS ('dbx_pii_value_regex' = 'bronze|silver|gold|platinum');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `enrollment_channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Enrollment Channel');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `enrollment_channel` SET TAGS ('dbx_pii_value_regex' = 'online|in_store|dealer|call_center|mobile_app');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `enrollment_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Enrollment Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `is_primary_member` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Primary Member Flag');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `last_activity_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Activity Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `last_redemption_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Redemption Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `lifetime_points_earned` SET TAGS ('dbx_pii_business_glossary_term' = 'Lifetime Points Earned');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `membership_expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Membership Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `membership_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Membership Number (MEMBER_NO)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `membership_number` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `membership_number` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `points_balance` SET TAGS ('dbx_pii_business_glossary_term' = 'Points Balance');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `points_balance_last_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Points Balance Last Year');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `points_earned_this_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Points Earned This Year');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `points_expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Points Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `points_redeemed_this_year` SET TAGS ('dbx_pii_business_glossary_term' = 'Points Redeemed This Year');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `preferred_redemption_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Preferred Redemption Category');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `preferred_redemption_category` SET TAGS ('dbx_pii_value_regex' = 'service|accessories|cash|gift_card|charity');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `program_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `program_status` SET TAGS ('dbx_pii_value_regex' = 'active|suspended|expired|cancelled');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `record_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `record_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|deleted');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `redemption_eligibility_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Redemption Eligibility Flag');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `referral_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Referral Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `salesforce_loyalty_member_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Salesforce Loyalty Member ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `salesforce_loyalty_member_reference` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `salesforce_loyalty_member_reference` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `tier_benefits_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Tier Benefits Description');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `tier_expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Tier Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `tier_points_required` SET TAGS ('dbx_pii_business_glossary_term' = 'Tier Points Required');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `tier_qualification_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Tier Qualification Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `total_points_redeemed` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Points Redeemed');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `total_redemptions` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Redemptions');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` SET TAGS ('dbx_pii_subdomain' = 'engagement_programs');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `loyalty_transaction_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Transaction ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Membership ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Processed By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `promotion_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Promotion ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `approval_status` SET TAGS ('dbx_pii_value_regex' = 'approved|pending|rejected');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Transaction Channel');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `channel` SET TAGS ('dbx_pii_value_regex' = 'dealer|online|app|call_center');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `dealer_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Transaction Notes');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `points_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Points Amount');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `points_balance_after` SET TAGS ('dbx_pii_business_glossary_term' = 'Points Balance After Transaction');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `points_expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Points Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `transaction_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Transaction Number');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `transaction_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Transaction Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `transaction_status` SET TAGS ('dbx_pii_value_regex' = 'pending|posted|cancelled|reversed|approved');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `transaction_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Transaction Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Transaction Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `transaction_type` SET TAGS ('dbx_pii_value_regex' = 'earn|redeem|adjust|expire|transfer');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `triggering_event_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Triggering Event Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `triggering_event_type` SET TAGS ('dbx_pii_value_regex' = 'vehicle_purchase|service_visit|referral|promotion|ota_enrollment|ev_charge');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` SET TAGS ('dbx_pii_subdomain' = 'engagement_programs');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `customer_segment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Segment Identifier (CSID)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `confidence_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment Confidence Score (SCS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (RCT)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `customer_segment_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment Description (SD)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date (ED)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `estimated_segment_size` SET TAGS ('dbx_pii_business_glossary_term' = 'Estimated Segment Size (ESS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiry Date (EXD)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_pii_business_glossary_term' = 'Geographic Scope (GS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_pii_value_regex' = 'global|regional|national|local');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `is_active` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Active Flag (IAF)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date (LRD)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `model_year_end` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year End (MYE)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `model_year_start` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Year Start (MYS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `owner` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment Owner (SO)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `primary_vehicle_interest` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Vehicle Interest (PVI)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment Priority (SP)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `qualifying_criteria_summary` SET TAGS ('dbx_pii_business_glossary_term' = 'Qualifying Criteria Summary (QCS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `revenue_potential_band` SET TAGS ('dbx_pii_business_glossary_term' = 'Revenue Potential Band (RPB)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `revenue_potential_band` SET TAGS ('dbx_pii_value_regex' = 'low|mid|high|very_high');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `segment_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment Category (SCAT)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `segment_category` SET TAGS ('dbx_pii_value_regex' = 'demographic|behavioral|psychographic|firmographic|lifecycle|vehicle_type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `segment_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment Code (SC)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `segment_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment Name (SN)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `segment_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment Status (SS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `segment_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|deprecated|pending');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `tags` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment Tags (ST)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `target_customer_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Customer Type (TCT)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `target_customer_type` SET TAGS ('dbx_pii_value_regex' = 'B2C|B2B|both');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp (RUT)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ALTER COLUMN `version` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment Version (SV)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` SET TAGS ('dbx_pii_subdomain' = 'engagement_programs');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ALTER COLUMN `segment_membership_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment Membership ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ALTER COLUMN `customer_segment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Segment ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ALTER COLUMN `assigned_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Assigned By User');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ALTER COLUMN `assignment_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment Assignment Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ALTER COLUMN `assignment_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment Assignment Method');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ALTER COLUMN `assignment_method` SET TAGS ('dbx_pii_value_regex' = 'rule_based|manual|ml_model');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ALTER COLUMN `confidence_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Assignment Confidence Score');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Segment Membership Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ALTER COLUMN `is_primary_segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Segment Indicator');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ALTER COLUMN `model_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Model Version');
ALTER TABLE `vibe_automotive_v1`.`customer`.`segment_membership` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` SET TAGS ('dbx_pii_subdomain' = 'engagement_programs');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `preference_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `preference_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Category');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `preference_category` SET TAGS ('dbx_pii_value_regex' = 'communication|vehicle|service|digital|privacy');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Communication Channel');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `channel` SET TAGS ('dbx_pii_value_regex' = 'email|sms|push|mail|phone');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `confidence_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Confidence Score');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `data_origin_system` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Data Origin System');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `data_origin_system` SET TAGS ('dbx_pii_value_regex' = 'salesforce|cdk|custom|other');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Effective Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `is_opt_out` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Opt‑Out Indicator');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Notes');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `preference_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `preference_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|expired|pending');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `source` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Source');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `source` SET TAGS ('dbx_pii_value_regex' = 'self_declared|inferred|imported');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `value` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Value');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `value_data_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Value Data Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`preference` ALTER COLUMN `value_data_type` SET TAGS ('dbx_pii_value_regex' = 'string|boolean|integer|list');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_consent_record` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_consent_record` SET TAGS ('dbx_pii_subdomain' = 'privacy_compliance');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_consent_record` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_consent_record` ALTER COLUMN `customer_consent_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for customer_consent_record');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` SET TAGS ('dbx_pii_subdomain' = 'experience_analytics');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `nps_response_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Promoter Score Response ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `case_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Case ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Party ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `survey_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Survey ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `dealer_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `follow_up_required_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Follow‑Up Required Flag');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `follow_up_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Follow‑Up Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `follow_up_status` SET TAGS ('dbx_pii_value_regex' = 'required|in_progress|completed|none');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `nps_response_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Response Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `nps_response_status` SET TAGS ('dbx_pii_value_regex' = 'pending|completed|escalated|closed');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `nps_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Net Promoter Score (NPS) Rating');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `promoter_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Promoter Category');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `promoter_category` SET TAGS ('dbx_pii_value_regex' = 'promoter|passive|detractor');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `response_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Response Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `salesforce_survey_response_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Salesforce Survey Response ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `survey_channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Survey Delivery Channel');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `survey_channel` SET TAGS ('dbx_pii_value_regex' = 'email|sms|app|ivr');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `survey_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Survey Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `survey_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Survey Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `survey_type` SET TAGS ('dbx_pii_value_regex' = 'transactional|relational');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `touchpoint` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Touchpoint');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `touchpoint` SET TAGS ('dbx_pii_value_regex' = 'vehicle_purchase|service_visit|delivery|recall|roadside|connected_app');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `verbatim_comment` SET TAGS ('dbx_pii_business_glossary_term' = 'Verbatim Comment');
ALTER TABLE `vibe_automotive_v1`.`customer`.`nps_response` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` SET TAGS ('dbx_pii_subdomain' = 'experience_analytics');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `cltv_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Lifetime Value Record ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Party ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `calculation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'CLTV Calculation Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `calculation_status` SET TAGS ('dbx_pii_business_glossary_term' = 'CLTV Calculation Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `calculation_status` SET TAGS ('dbx_pii_value_regex' = 'pending|completed|failed');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `churn_probability` SET TAGS ('dbx_pii_business_glossary_term' = 'Churn Probability');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `cltv_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Lifetime Value Amount');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `cltv_horizon_months` SET TAGS ('dbx_pii_business_glossary_term' = 'CLTV Horizon (Months)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `data_completeness_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Completeness Score');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `discount_rate` SET TAGS ('dbx_pii_business_glossary_term' = 'Discount Rate');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `model_version` SET TAGS ('dbx_pii_business_glossary_term' = 'CLTV Model Version');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `projected_accessories_revenue` SET TAGS ('dbx_pii_business_glossary_term' = 'Projected Accessories Revenue');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `projected_connected_services_revenue` SET TAGS ('dbx_pii_business_glossary_term' = 'Projected Connected Services Revenue');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `projected_finance_revenue` SET TAGS ('dbx_pii_business_glossary_term' = 'Projected Finance Revenue');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `projected_parts_revenue` SET TAGS ('dbx_pii_business_glossary_term' = 'Projected Parts Revenue');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `projected_service_revenue` SET TAGS ('dbx_pii_business_glossary_term' = 'Projected Service Revenue');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `projected_vehicle_purchases` SET TAGS ('dbx_pii_business_glossary_term' = 'Projected Vehicle Purchases');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `retention_probability` SET TAGS ('dbx_pii_business_glossary_term' = 'Retention Probability');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `revenue_to_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Revenue To Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `segment_at_calculation` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Segment (At Calculation)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`cltv_record` ALTER COLUMN `segment_at_calculation` SET TAGS ('dbx_pii_value_regex' = 'high|medium|low|new|churn_risk');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` SET TAGS ('dbx_pii_subdomain' = 'experience_analytics');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `journey_touchpoint_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Journey Touchpoint ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `campaign_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Campaign ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Agent ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `loyalty_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Program ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Party ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Agent ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `activity_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Salesforce Activity ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Interaction Channel');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `channel` SET TAGS ('dbx_pii_value_regex' = 'dealer|online|app|call_center|event|social');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `connected_app_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected App ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `dealer_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `device_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Device Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `device_type` SET TAGS ('dbx_pii_value_regex' = 'smartphone|tablet|desktop|in_vehicle|other');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `duration_seconds` SET TAGS ('dbx_pii_business_glossary_term' = 'Interaction Duration (Seconds)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `event_source` SET TAGS ('dbx_pii_business_glossary_term' = 'Event Source System');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `feedback_comments` SET TAGS ('dbx_pii_business_glossary_term' = 'Feedback Comments');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `feedback_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Feedback Score');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `interaction_outcome` SET TAGS ('dbx_pii_business_glossary_term' = 'Interaction Outcome');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `interaction_outcome` SET TAGS ('dbx_pii_value_regex' = 'success|failure|pending|cancelled|no_show');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `ip_address` SET TAGS ('dbx_pii_business_glossary_term' = 'IP Address');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `ip_address` SET TAGS ('dbx_pii_value_regex' = '^((25[0-5]|2[0-4]d|[01]?dd?).){3}(25[0-5]|2[0-4]d|[01]?dd?)$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `ip_address` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `ip_address` SET TAGS ('dbx_pii_pii_ip' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `is_assisted` SET TAGS ('dbx_pii_business_glossary_term' = 'Assisted Interaction Flag');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `location_city` SET TAGS ('dbx_pii_business_glossary_term' = 'Touchpoint City');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `location_city` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `location_country` SET TAGS ('dbx_pii_business_glossary_term' = 'Touchpoint Country Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `location_country` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `location_state` SET TAGS ('dbx_pii_business_glossary_term' = 'Touchpoint State/Province');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `loyalty_points_redeemed` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Points Redeemed');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `marketing_attribution` SET TAGS ('dbx_pii_business_glossary_term' = 'Marketing Attribution');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Touchpoint Notes');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `ota_update_version` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Update Version');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `repurchase_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Repurchase Flag');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `session_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Session ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `touchpoint_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Touchpoint Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `touchpoint_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Touchpoint Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `touchpoint_type` SET TAGS ('dbx_pii_value_regex' = 'lead_inquiry|test_drive|quote_request|vehicle_purchase|delivery|service_visit');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `trade_in_vehicle_vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Trade‑In Vehicle VIN');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `user_agent` SET TAGS ('dbx_pii_business_glossary_term' = 'User Agent String');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `user_agent` SET TAGS ('dbx_pii_internal' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ALTER COLUMN `user_agent` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_account` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_account` SET TAGS ('dbx_pii_subdomain' = 'ownership_tracking');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_account` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_account` ALTER COLUMN `customer_fleet_account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for customer_fleet_account');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_account` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Fleet Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_account` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_account` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_account` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_vehicle_assignment` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_vehicle_assignment` SET TAGS ('dbx_pii_subdomain' = 'ownership_tracking');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_vehicle_assignment` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_vehicle_assignment` ALTER COLUMN `customer_fleet_vehicle_assignment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Key for customer_fleet_vehicle_assignment');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_vehicle_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Fleet Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_vehicle_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_vehicle_assignment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_vehicle_assignment` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` SET TAGS ('dbx_pii_subdomain' = 'identity_management');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `identity_resolution_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Identity Resolution Record ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Golden Party Identifier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `match_confidence_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Match Confidence Score');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `match_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Match Method');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `match_method` SET TAGS ('dbx_pii_value_regex' = 'deterministic|probabilistic|manual');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `match_rule_set_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Match Rule Set Version');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `matched_attributes` SET TAGS ('dbx_pii_business_glossary_term' = 'Matched Attributes');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Created');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Updated');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `resolution_action` SET TAGS ('dbx_pii_business_glossary_term' = 'Resolution Action');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `resolution_action` SET TAGS ('dbx_pii_value_regex' = 'merge|link|suppress|review');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `resolution_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Resolution Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `resolved_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Resolved By');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `review_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Review Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `review_status` SET TAGS ('dbx_pii_value_regex' = 'auto-approved|pending_review|rejected');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `source_system_a` SET TAGS ('dbx_pii_business_glossary_term' = 'Source System A');
ALTER TABLE `vibe_automotive_v1`.`customer`.`identity_resolution` ALTER COLUMN `source_system_b` SET TAGS ('dbx_pii_business_glossary_term' = 'Source System B');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` SET TAGS ('dbx_pii_subdomain' = 'engagement_programs');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `communication_subscription_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Communication Subscription ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `customer_consent_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Consent Record Identifier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Party Identifier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `preference_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Preference Record Identifier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `dealer_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `delivery_channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Delivery Channel');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `delivery_channel` SET TAGS ('dbx_pii_value_regex' = 'email|sms|push|mail');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `external_subscription_code` SET TAGS ('dbx_pii_business_glossary_term' = 'External Subscription Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `frequency` SET TAGS ('dbx_pii_business_glossary_term' = 'Communication Frequency');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `frequency` SET TAGS ('dbx_pii_value_regex' = 'daily|weekly|monthly|event_triggered');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `is_test` SET TAGS ('dbx_pii_business_glossary_term' = 'Test Subscription Flag');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `language` SET TAGS ('dbx_pii_business_glossary_term' = 'Language Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `last_sent_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Sent Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `marketing_cloud_key` SET TAGS ('dbx_pii_business_glossary_term' = 'Marketing Cloud Subscription Key');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `next_scheduled_send` SET TAGS ('dbx_pii_business_glossary_term' = 'Next Scheduled Send Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `subscription_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Start Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `subscription_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `subscription_status` SET TAGS ('dbx_pii_value_regex' = 'active|paused|unsubscribed');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `subscription_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `unsubscribe_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Unsubscribe Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `unsubscribe_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Unsubscribe Reason');
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` SET TAGS ('dbx_pii_subdomain' = 'identity_management');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `party_relationship_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Party Relationship ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Source Party ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Relationship Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `to_party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Party ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `authorization_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Authorization Level');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `authorization_level` SET TAGS ('dbx_pii_value_regex' = 'read|write|admin|none');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `compliance_status` SET TAGS ('dbx_pii_value_regex' = 'compliant|non_compliant|under_review');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `contract_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Contract Reference');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `party_relationship_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Relationship Description');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `effective_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `expiry_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `inverse_role` SET TAGS ('dbx_pii_business_glossary_term' = 'Inverse Role (Target Perspective)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `is_legal_entity` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Legal Entity Relationship');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `is_primary` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Primary Relationship');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_pii_business_glossary_term' = 'Jurisdiction (ISO 3166-1 Alpha-3)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_pii_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `party_relationship_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Relationship Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `party_relationship_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|pending|terminated');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `relationship_role` SET TAGS ('dbx_pii_business_glossary_term' = 'Relationship Role (Source Perspective)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `relationship_strength` SET TAGS ('dbx_pii_business_glossary_term' = 'Relationship Strength Rating');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `relationship_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Relationship Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `updated_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ALTER COLUMN `created_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` SET TAGS ('dbx_pii_subdomain' = 'ownership_tracking');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `pdi_record_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Pre-Delivery Inspection Record ID (PDI_ID)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Party Identifier (CUSTOMER_ID)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `technician_id` SET TAGS ('dbx_pii_business_glossary_term' = 'PDI Technician Identifier (TECH_ID)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `connected_services_activated` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Services Activation Flag (CONNECTED_SERVICES_ACTIVATED)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `customer_signature_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Signature Date (SIGNATURE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `customer_signature_date` SET TAGS ('dbx_pii_pii_person_data' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `customer_walkthrough_completed` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Walkthrough Completion Flag (WALKTHROUGH_COMPLETED)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `dealer_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Code (DEALER_CD)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `dealer_code` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{3,6}$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `delivery_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Delivery Date (DELIVERY_DATE)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `floor_mat_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Floor Mats Delivered (FLOOR_MAT_COUNT)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `fuel_level_percent` SET TAGS ('dbx_pii_business_glossary_term' = 'Fuel Level at Delivery Percentage (FUEL_LVL_PCT)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `inspection_checklist_version` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Checklist Version (CHECKLIST_VER)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `inspection_checklist_version` SET TAGS ('dbx_pii_value_regex' = '^vd+.d+$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `inspection_items_json` SET TAGS ('dbx_pii_business_glossary_term' = 'Inspection Item Results JSON (INSPECTION_ITEMS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `key_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Number of Keys Delivered (KEY_COUNT)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Additional Notes or Comments (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `odometer_km` SET TAGS ('dbx_pii_business_glossary_term' = 'Odometer Reading at Delivery Kilometers (ODOMETER_KM)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `ota_baseline_version` SET TAGS ('dbx_pii_business_glossary_term' = 'OTA Baseline Software Version (OTA_BASE_VER)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `ota_baseline_version` SET TAGS ('dbx_pii_value_regex' = '^vd+.d+$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `overall_pass` SET TAGS ('dbx_pii_business_glossary_term' = 'Overall PDI Pass Indicator (PDI_PASS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `owner_manual_provided` SET TAGS ('dbx_pii_business_glossary_term' = 'Owner Manual Provided Flag (MANUAL_PROVIDED)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `pdi_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Pre-Delivery Inspection Date (PDI_DATE)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `pdi_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Pre-Delivery Inspection Number (PDI_NO)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `pdi_number` SET TAGS ('dbx_pii_value_regex' = '^[A-Z0-9]{8,12}$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `pdi_record_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Pre-Delivery Inspection Status (PDI_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `pdi_record_status` SET TAGS ('dbx_pii_value_regex' = 'pending|in_progress|completed|failed|rework|cancelled');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `pdi_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Pre-Delivery Inspection Event Timestamp (PDI_EVENT_TS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `tpms_calibrated` SET TAGS ('dbx_pii_business_glossary_term' = 'TPMS Calibration Status (TPMS_CALIBRATED)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Last Updated Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_test_drive` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_test_drive` SET TAGS ('dbx_pii_subdomain' = 'ownership_tracking');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_test_drive` SET TAGS ('dbx_pii_ssot_reference' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_test_drive` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` SET TAGS ('dbx_pii_subdomain' = 'experience_analytics');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `case_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Case ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Assigned Agent ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Party ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Assigned Agent ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `primary_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `case_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Case Number');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `case_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Case Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `case_status` SET TAGS ('dbx_pii_value_regex' = 'new|in_progress|pending_customer|resolved|closed|escalated');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `case_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Case Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `case_type` SET TAGS ('dbx_pii_value_regex' = 'complaint|inquiry|warranty_claim|recall|roadside|goodwill');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `case_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Case Category');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Case Closed Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `customer_satisfaction_score` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Satisfaction Score');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `dealer_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `case_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Case Description');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `dynamics_case_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Dynamics 365 Case ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `escalation_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Escalation Level');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `escalation_level` SET TAGS ('dbx_pii_value_regex' = 'level1|level2|level3');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `escalation_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Escalation Reason');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `opened_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Case Opened Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Case Priority');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `priority` SET TAGS ('dbx_pii_value_regex' = 'P1|P2|P3|P4');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Created');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Audit Updated');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `resolution_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Resolution Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `resolution_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Resolution Description');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `resolved_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Case Resolved Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `salesforce_case_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Salesforce Case ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `sla_due_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'SLA Due Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `source_channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Case Source Channel');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `source_channel` SET TAGS ('dbx_pii_value_regex' = 'phone|email|web|in_person|mobile_app');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `sub_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Case Sub-Category');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `subject` SET TAGS ('dbx_pii_business_glossary_term' = 'Case Subject');
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ALTER COLUMN `total_handle_time_minutes` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Handle Time (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` SET TAGS ('dbx_pii_subdomain' = 'experience_analytics');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `connected_service_enrollment_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Service Enrollment ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `account_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Billing Account ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Party ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Advisor Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `activation_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Activation Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `auto_renew` SET TAGS ('dbx_pii_business_glossary_term' = 'Auto‑Renew Flag');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `billing_cycle` SET TAGS ('dbx_pii_business_glossary_term' = 'Billing Cycle');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `billing_cycle` SET TAGS ('dbx_pii_value_regex' = 'monthly|annual');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `connected_app_user_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected App User ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `connected_app_user_reference` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `connected_app_user_reference` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `data_plan_gb` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Plan Size (GB)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `data_usage_gb` SET TAGS ('dbx_pii_business_glossary_term' = 'Cumulative Data Usage (GB)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `device_imei` SET TAGS ('dbx_pii_business_glossary_term' = 'Device IMEI');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `device_imei` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `device_imei` SET TAGS ('dbx_pii_pii_device' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `enrollment_channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Enrollment Channel');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `enrollment_channel` SET TAGS ('dbx_pii_value_regex' = 'online|dealer|mobile_app|call_center|partner');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `enrollment_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Enrollment Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `enrollment_reference_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Enrollment Reference Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `enrollment_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Enrollment Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `enrollment_status` SET TAGS ('dbx_pii_value_regex' = 'trial|active|suspended|cancelled|expired');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `last_ota_update_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Last OTA Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `monthly_fee` SET TAGS ('dbx_pii_business_glossary_term' = 'Monthly Subscription Fee');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `price_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `service_plan_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Plan Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `service_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Connected Service Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `service_type` SET TAGS ('dbx_pii_value_regex' = 'telematics|remote_access|ev_charging|ota_updates|wifi_hotspot|v2x');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `sim_iccid` SET TAGS ('dbx_pii_business_glossary_term' = 'SIM ICCID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `sim_iccid` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `sim_iccid` SET TAGS ('dbx_pii_pii_device' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `status_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Enrollment Status Reason');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `subscription_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription End Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `subscription_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Subscription Start Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `telematics_provider` SET TAGS ('dbx_pii_business_glossary_term' = 'Telematics Provider');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `telematics_provider` SET TAGS ('dbx_pii_value_regex' = 'Geotab|Bosch_IoT|Other');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `trial_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Trial End Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` SET TAGS ('dbx_pii_data_type' = 'reference_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` SET TAGS ('dbx_pii_subdomain' = 'engagement_programs');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `loyalty_program_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Program Identifier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `loyalty_program_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Program Description');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `earn_rate_points_per_dollar` SET TAGS ('dbx_pii_business_glossary_term' = 'Points Earn Rate');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `eligibility_criteria` SET TAGS ('dbx_pii_business_glossary_term' = 'Enrollment Eligibility Criteria');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Program End Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `enrollment_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Enrollment End Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `enrollment_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Enrollment Start Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `is_partner_program` SET TAGS ('dbx_pii_business_glossary_term' = 'Partner Program Flag');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `last_review_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `loyalty_program_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Lifecycle Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `loyalty_program_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|suspended|pending|retired');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `loyalty_program_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Program Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `loyalty_program_type` SET TAGS ('dbx_pii_value_regex' = 'points|tier|cashback|hybrid');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `min_redemption_points` SET TAGS ('dbx_pii_business_glossary_term' = 'Minimum Redemption Threshold');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `loyalty_program_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Program Name');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Notes');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `partner_redemption_options` SET TAGS ('dbx_pii_business_glossary_term' = 'Partner Redemption Options');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `points_earn_rate_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Earn Rate Currency');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `points_earn_rate_currency` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|GBP|CAD|JPY|AUD');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `points_expiry_months` SET TAGS ('dbx_pii_business_glossary_term' = 'Points Expiry Period (Months)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `points_redemption_currency` SET TAGS ('dbx_pii_business_glossary_term' = 'Redemption Currency');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `points_redemption_currency` SET TAGS ('dbx_pii_value_regex' = 'USD|EUR|GBP|CAD|JPY|AUD');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `program_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Category');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `program_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Program Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `program_owner` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Owner');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `redemption_rate_points_per_dollar` SET TAGS ('dbx_pii_business_glossary_term' = 'Points Redemption Rate');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `salesforce_loyalty_program_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Salesforce Loyalty Program ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `sponsoring_brand` SET TAGS ('dbx_pii_business_glossary_term' = 'Sponsoring Brand');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Start Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `target_customer_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Customer Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `target_customer_type` SET TAGS ('dbx_pii_value_regex' = 'B2C|B2B|fleet');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `tier_structure` SET TAGS ('dbx_pii_business_glossary_term' = 'Tier Structure Definition');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_program` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Program Version Number');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` SET TAGS ('dbx_pii_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` SET TAGS ('dbx_pii_subdomain' = 'privacy_compliance');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `privacy_request_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Privacy Request Identifier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `case_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Service Case Identifier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Handling Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Identifier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `completion_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Completion Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `data_domains_affected` SET TAGS ('dbx_pii_business_glossary_term' = 'Data Domains Affected');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `due_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Due Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `fulfillment_notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Fulfillment Notes');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `is_high_risk` SET TAGS ('dbx_pii_business_glossary_term' = 'High‑Risk Flag');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Request Priority');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `priority` SET TAGS ('dbx_pii_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `regulatory_basis` SET TAGS ('dbx_pii_business_glossary_term' = 'Regulatory Basis');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `regulatory_basis` SET TAGS ('dbx_pii_value_regex' = 'GDPR|CCPA|PIPEDA|LGPD');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_pii_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `request_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Privacy Request Number');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `request_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Privacy Request Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `request_status` SET TAGS ('dbx_pii_value_regex' = 'received|in_progress|completed|rejected|partially_fulfilled');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `request_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Privacy Request Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `request_type` SET TAGS ('dbx_pii_value_regex' = 'erasure|access|portability|rectification|restriction|opt_out');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `submission_channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Channel');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `submission_channel` SET TAGS ('dbx_pii_value_regex' = 'web_portal|email|call_center|mail');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `submission_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Submission Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `systems_notified` SET TAGS ('dbx_pii_business_glossary_term' = 'Systems Notified');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `verification_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Verification Method');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `verification_method` SET TAGS ('dbx_pii_value_regex' = 'identity_document|knowledge_based|email_link|sms_code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ALTER COLUMN `verified_by` SET TAGS ('dbx_pii_business_glossary_term' = 'Verified By');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` SET TAGS ('dbx_pii_data_type' = 'association_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` SET TAGS ('dbx_pii_subdomain' = 'identity_management');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `dealer_customer_link_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Customer Link Identifier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Account Manager Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `party_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Party ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `assignment_method` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Assignment Method');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `assignment_method` SET TAGS ('dbx_pii_value_regex' = 'customer_selected|system_assigned|dealer_claimed');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `dealer_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `dealer_customer_link_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer‑Customer Link Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `dealer_customer_link_status` SET TAGS ('dbx_pii_value_regex' = 'active|inactive|terminated|pending');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `is_primary` SET TAGS ('dbx_pii_business_glossary_term' = 'Primary Dealer Flag');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `last_service_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Last Service Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `notes` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer‑Customer Link Notes');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `relationship_end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Relationship End Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `relationship_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer‑Customer Relationship Number');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `relationship_start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Relationship Start Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `relationship_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Dealer Relationship Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `relationship_type` SET TAGS ('dbx_pii_value_regex' = 'selling_dealer|service_dealer|preferred_dealer|conquest_dealer');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `salesforce_account_dealer_reference` SET TAGS ('dbx_pii_business_glossary_term' = 'Salesforce Account‑Dealer Relationship ID');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `total_service_visits` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Service Visits');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `total_spend_at_dealer` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Spend at Dealer (USD)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `vin` SET TAGS ('dbx_pii_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `vin` SET TAGS ('dbx_pii_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `vin` SET TAGS ('dbx_pii_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ALTER COLUMN `vin` SET TAGS ('dbx_pii_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` SET TAGS ('dbx_pii_subdomain' = 'engagement_programs');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `promotion_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Promotion Identifier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `campaign_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Marketing Campaign Id');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `predecessor_promotion_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Predecessor Promotion Id');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `predecessor_promotion_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Employee Id');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `promotion_updated_by_user_employee_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated By User Employee Id');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `promotion_updated_by_user_employee_id` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `promotion_updated_by_user_employee_id` SET TAGS ('dbx_pii_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `applicable_geographies` SET TAGS ('dbx_pii_business_glossary_term' = 'Applicable Geographies');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `applicable_vehicle_models` SET TAGS ('dbx_pii_business_glossary_term' = 'Applicable Vehicle Models');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `budget_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Budget Amount');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `budget_amount` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Channel');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `cltv_impact_estimate` SET TAGS ('dbx_pii_business_glossary_term' = 'Cltv Impact Estimate');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `promotion_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `currency_code` SET TAGS ('dbx_pii_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `customer_segment` SET TAGS ('dbx_pii_business_glossary_term' = 'Customer Segment');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `discount_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Discount Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `discount_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Discount Value');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `discount_value` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `eligibility_criteria` SET TAGS ('dbx_pii_business_glossary_term' = 'Eligibility Criteria');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `end_date` SET TAGS ('dbx_pii_business_glossary_term' = 'End Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `is_exclusive` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Exclusive');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `loyalty_program_flag` SET TAGS ('dbx_pii_business_glossary_term' = 'Loyalty Program Flag');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `max_discount_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Max Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `min_purchase_amount` SET TAGS ('dbx_pii_business_glossary_term' = 'Min Purchase Amount');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `promotion_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `nps_impact_estimate` SET TAGS ('dbx_pii_business_glossary_term' = 'Nps Impact Estimate');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `priority` SET TAGS ('dbx_pii_business_glossary_term' = 'Priority');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `promotion_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Promotion Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `promotional_message` SET TAGS ('dbx_pii_business_glossary_term' = 'Promotional Message');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `redemption_count` SET TAGS ('dbx_pii_business_glossary_term' = 'Redemption Count');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `required_product_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Required Product Category');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `start_date` SET TAGS ('dbx_pii_business_glossary_term' = 'Start Date');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `promotion_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `target_audience` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Audience');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `terms_and_conditions` SET TAGS ('dbx_pii_business_glossary_term' = 'Terms And Conditions');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `total_redemption_limit` SET TAGS ('dbx_pii_business_glossary_term' = 'Total Redemption Limit');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ALTER COLUMN `usage_limit_per_customer` SET TAGS ('dbx_pii_business_glossary_term' = 'Usage Limit Per Customer');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` SET TAGS ('dbx_pii_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` SET TAGS ('dbx_pii_subdomain' = 'experience_analytics');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` SET TAGS ('dbx_pii_ecm_scope' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `survey_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Survey Identifier');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `follow_up_survey_id` SET TAGS ('dbx_pii_business_glossary_term' = 'Follow Up Survey Id');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `follow_up_survey_id` SET TAGS ('dbx_pii_self_ref_fk' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `survey_category` SET TAGS ('dbx_pii_business_glossary_term' = 'Survey Category');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `channel` SET TAGS ('dbx_pii_business_glossary_term' = 'Channel');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_pii_business_glossary_term' = 'Confidentiality Level');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `survey_description` SET TAGS ('dbx_pii_business_glossary_term' = 'Description');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `effective_from` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective From');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `effective_until` SET TAGS ('dbx_pii_business_glossary_term' = 'Effective Until');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `incentive_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Incentive Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `incentive_value` SET TAGS ('dbx_pii_business_glossary_term' = 'Incentive Value');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `is_anonymous` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Anonymous');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_pii_business_glossary_term' = 'Is Mandatory');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `language` SET TAGS ('dbx_pii_business_glossary_term' = 'Language');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `max_responses_allowed` SET TAGS ('dbx_pii_business_glossary_term' = 'Max Responses Allowed');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `survey_name` SET TAGS ('dbx_pii_business_glossary_term' = 'Name');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `owner_contact_email` SET TAGS ('dbx_pii_business_glossary_term' = 'Owner Contact Email');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `owner_contact_email` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `owner_contact_email` SET TAGS ('dbx_pii_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `owner_contact_phone` SET TAGS ('dbx_pii_business_glossary_term' = 'Owner Contact Phone');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `owner_contact_phone` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `owner_contact_phone` SET TAGS ('dbx_pii_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `owner_department` SET TAGS ('dbx_pii_business_glossary_term' = 'Owner Department');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `response_deadline` SET TAGS ('dbx_pii_business_glossary_term' = 'Response Deadline');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `survey_status` SET TAGS ('dbx_pii_business_glossary_term' = 'Status');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `survey_type` SET TAGS ('dbx_pii_business_glossary_term' = 'Survey Type');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `target_audience` SET TAGS ('dbx_pii_business_glossary_term' = 'Target Audience');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_pii_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`customer`.`survey` ALTER COLUMN `version_number` SET TAGS ('dbx_pii_business_glossary_term' = 'Version Number');
