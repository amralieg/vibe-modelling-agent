-- Schema for Domain: customer | Business: Manufacturing | Version: v1_ecm
-- Generated on: 2026-04-16 07:42:33

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`customer` COMMENT 'Single source of truth for all customer identities, accounts, contacts, and segmentation across B2B industrial buyers, OEM partners, system integrators, distributors, and end-users. Manages customer hierarchies, credit profiles, corporate accounts, contract associations, and SLA agreements across CRM and ERP systems.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`contact` (
    `contact_id` BIGINT COMMENT 'Unique surrogate identifier for each individual contact record in the silver layer, serving as the primary key for the contact data product.',
    `account_id` BIGINT COMMENT 'FK to customer.account',
    `ccpa_opt_out` BOOLEAN COMMENT 'Indicates whether the contact has exercised their CCPA right to opt out of the sale or sharing of their personal information. Applicable to contacts who are California residents.. Valid values are `true|false`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the country where the contact is primarily located or operates. Used for regional segmentation, compliance jurisdiction determination, and territory assignment.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the contact record was first created in the source system (Salesforce CRM). Used for data lineage, audit trails, and measuring time-to-contact from lead acquisition.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `crm_contact_code` STRING COMMENT 'Native record identifier from Salesforce CRM (Contact object ID, e.g., 003XXXXXXXXXXXXXXX), used for cross-system traceability and lineage back to the source system of record.',
    `data_subject_request_status` STRING COMMENT 'Tracks the status of any active data subject rights request (access, deletion, portability, rectification) submitted by this contact under GDPR or CCPA. Supports privacy compliance workflows.. Valid values are `none|access_requested|deletion_requested|portability_requested|rectification_requested|completed`',
    `department` STRING COMMENT 'Organizational department or functional unit the contact belongs to within their company (e.g., Engineering, Procurement, Operations, Finance, Quality). Supports targeted communication and account mapping.',
    `email` STRING COMMENT 'Primary business email address of the contact, used for commercial communications, order notifications, service updates, and marketing campaigns. Sourced from Salesforce CRM Contact object.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `email_opt_in` BOOLEAN COMMENT 'Indicates whether the contact has opted in to receive marketing and commercial email communications. Must be true before any marketing emails are sent. Supports GDPR and CCPA compliance.. Valid values are `true|false`',
    `email_opt_out` BOOLEAN COMMENT 'Indicates whether the contact has explicitly opted out of all marketing email communications. When true, the contact must be excluded from all commercial email campaigns regardless of opt-in status.. Valid values are `true|false`',
    `first_name` STRING COMMENT 'Given name of the individual contact as recorded in Salesforce CRM. Used for personalized communication and salutation in customer-facing correspondence.',
    `gdpr_consent_date` DATE COMMENT 'Date on which the contact granted or last updated their GDPR consent. Required for audit and compliance purposes to demonstrate lawful basis for data processing under GDPR.. Valid values are `^d{4}-d{2}-d{2}$`',
    `gdpr_consent_status` STRING COMMENT 'Current GDPR consent status for processing this contacts personal data. Tracks whether consent has been granted, withdrawn, is pending collection, or is not applicable (e.g., for contacts outside GDPR jurisdiction).. Valid values are `granted|withdrawn|pending|not_applicable`',
    `is_decision_maker` BOOLEAN COMMENT 'Indicates whether this contact holds decision-making authority for purchasing, contracting, or technical approvals within their organization. Critical for sales qualification and opportunity management in B2B industrial sales cycles.. Valid values are `true|false`',
    `is_influencer` BOOLEAN COMMENT 'Indicates whether this contact is identified as a key influencer in the purchasing or technical evaluation process, even if they do not hold final decision-making authority. Supports multi-stakeholder account management strategies.. Valid values are `true|false`',
    `is_primary_contact` BOOLEAN COMMENT 'Indicates whether this contact is designated as the primary point of contact for the associated customer account. Only one contact per account should be flagged as primary for a given role.. Valid values are `true|false`',
    `job_title` STRING COMMENT 'Official job title or position of the contact within their organization (e.g., Plant Manager, Procurement Manager, Engineering Lead, VP of Operations). Used for segmentation, routing, and persona-based engagement.',
    `last_activity_date` DATE COMMENT 'Date of the most recent logged activity (call, email, meeting, task) associated with this contact in Salesforce CRM. Used to measure contact engagement recency and identify dormant contacts for re-engagement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_contacted_date` DATE COMMENT 'Date on which a sales or service representative last made direct contact with this individual (distinct from last_activity_date which includes all logged activities). Supports contact cadence management and SLA tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the contact record in the source system (Salesforce CRM). Used for change data capture (CDC), incremental data loads, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_name` STRING COMMENT 'Family name or surname of the individual contact. Combined with first_name to form the full display name for reporting, CRM, and correspondence.',
    `lead_source` STRING COMMENT 'Channel or origin through which this contact was first acquired or entered the CRM system. Used for marketing attribution, pipeline analysis, and ROI measurement of demand generation activities.. Valid values are `web|trade_show|referral|cold_outreach|partner|inbound_call|marketing_campaign|existing_customer|other`',
    `linkedin_profile_url` STRING COMMENT 'URL of the contacts LinkedIn professional profile. Used by sales and account management teams for social selling, relationship intelligence, and contact verification in B2B industrial markets.. Valid values are `^https://(www.)?linkedin.com/in/[a-zA-Z0-9-_%]+/?$`',
    `mailing_city` STRING COMMENT 'City component of the contacts mailing address. Used for geographic segmentation, territory management, and physical correspondence.',
    `mailing_state_province` STRING COMMENT 'State or province component of the contacts mailing address. Supports regional compliance (e.g., CCPA for California residents), territory assignment, and geographic reporting.',
    `mobile_phone` STRING COMMENT 'Mobile or cell phone number for the contact, used for urgent communications, field service coordination, and SMS notifications. Distinct from the primary office phone.. Valid values are `^+?[0-9s-().]{7,20}$`',
    `nps_score` STRING COMMENT 'Most recent Net Promoter Score (NPS) survey response from this contact, on a scale of 0-10. Used to measure individual contact loyalty and satisfaction, and to identify promoters, passives, and detractors within key accounts.. Valid values are `^([0-9]|10)$`',
    `phone` STRING COMMENT 'Primary business phone number for the contact, typically a direct office line or switchboard extension. Used for sales outreach, service escalations, and account management.. Valid values are `^+?[0-9s-().]{7,20}$`',
    `phone_opt_out` BOOLEAN COMMENT 'Indicates whether the contact has opted out of phone-based outreach including sales calls and telemarketing. Supports compliance with do-not-call regulations and GDPR consent requirements.. Valid values are `true|false`',
    `preferred_language` STRING COMMENT 'ISO 639-1 language code (optionally with ISO 3166-1 country subtag) representing the contacts preferred language for communications, documentation, and support (e.g., en-US, de-DE, fr-FR, zh-CN).. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `record_effective_date` DATE COMMENT 'Date from which the current version of the contact record is considered valid in the silver layer. Supports slowly changing dimension (SCD) type 2 history tracking and point-in-time reporting for analytics and compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `reports_to_name` STRING COMMENT 'Full name of the contacts direct manager or superior within the customer organization. Used to understand organizational hierarchy and identify escalation paths within the account.',
    `role` STRING COMMENT 'Business role classification of the contact within the customer engagement model. Identifies whether the contact is a technical evaluator, commercial decision-maker, executive sponsor, or operational user. Drives sales strategy and communication routing.. Valid values are `technical|commercial|executive|operational|financial|quality|logistics|other`',
    `salutation` STRING COMMENT 'Formal honorific or title prefix used when addressing the contact in written or verbal communication (e.g., Mr., Dr., Eng.). Supports professional etiquette in B2B industrial contexts.. Valid values are `Mr.|Ms.|Mrs.|Dr.|Prof.|Eng.`',
    `sap_business_partner_number` STRING COMMENT 'SAP S/4HANA Business Partner identifier corresponding to this contact, enabling cross-system linkage between Salesforce CRM contact records and SAP ERP business partner master data for order management and billing.',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this contact record was originally sourced or created. Supports data lineage, master data management, and deduplication workflows.. Valid values are `salesforce_crm|sap_s4hana|manual_entry|data_import|web_form|other`',
    `status` STRING COMMENT 'Current lifecycle status of the contact record. Indicates whether the contact is actively engaged, inactive, flagged as do-not-contact, or has been merged into another record.. Valid values are `active|inactive|do_not_contact|deceased|merged`',
    CONSTRAINT pk_contact PRIMARY KEY(`contact_id`)
) COMMENT 'Individual person records associated with customer accounts, including procurement managers, engineering leads, plant managers, and executive sponsors at B2B industrial buyer organizations. Captures full name, job title, department, phone, email, preferred language, LinkedIn profile, contact role (technical, commercial, executive), opt-in/opt-out flags, and GDPR/CCPA consent status. Sourced from Salesforce CRM Contact object.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` (
    `account_hierarchy_id` BIGINT COMMENT 'Unique surrogate identifier for each parent-child account hierarchy relationship record in the Databricks Silver Layer. Serves as the primary key for the account_hierarchy data product.',
    `account_id` BIGINT COMMENT 'FK to customer.account',
    `parent_account_id` BIGINT COMMENT 'FK to customer.account',
    `root_account_id` BIGINT COMMENT 'FK to customer.account',
    `account_group_code` STRING COMMENT 'SAP S/4HANA account group classification code assigned to the child account within this hierarchy, controlling field selection, number ranges, and partner functions. Examples include KUNA (one-time customer), DEBI (domestic customer), EXPO (export customer).',
    `approval_date` DATE COMMENT 'Date on which this hierarchy relationship was formally approved by the designated authority. Used for audit trail, compliance reporting, and governance of corporate account structure changes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by` STRING COMMENT 'Name or employee identifier of the business authority (e.g., Global Account Director, Credit Manager) who approved the establishment or modification of this hierarchy relationship. Supports governance, audit trail, and segregation of duties requirements.',
    `child_account_code` STRING COMMENT 'Business identifier of the child (subordinate) account in the hierarchy relationship, sourced from SAP S/4HANA or Salesforce CRM. Represents the subsidiary, division, affiliate, or regional entity reporting up to the parent.',
    `consolidated_credit_limit` DECIMAL(18,2) COMMENT 'Maximum credit exposure amount approved for the child account within the context of this hierarchy relationship, expressed in the credit_limit_currency. Used for consolidated credit exposure tracking across subsidiaries and global account credit risk management in SAP S/4HANA FI Credit Management.',
    `consolidation_method` STRING COMMENT 'Accounting method applied to consolidate the child accounts financials into the parents financial statements. Determined by ownership percentage and control assessment per IFRS 10 and GAAP ASC 810. Drives credit exposure aggregation and financial reporting roll-up logic.. Valid values are `full_consolidation|proportional_consolidation|equity_method|cost_method|not_consolidated`',
    `contract_reference` STRING COMMENT 'Reference number of the master contract or framework agreement governing the commercial relationship between the parent and child accounts within this hierarchy. Links to the contract management system for terms, pricing, and SLA enforcement.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the child accounts primary registered country. Used for geographic roll-up reporting, regional credit exposure analysis, regulatory compliance (GDPR, CCPA), and multi-country account management.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this account hierarchy relationship record was first created in the Databricks Silver Layer. Used for data lineage, audit trail, and incremental processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_limit_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the consolidated credit limit assigned to this hierarchy node. Supports multi-currency credit exposure management across global enterprise accounts.. Valid values are `^[A-Z]{3}$`',
    `customer_classification` STRING COMMENT 'Business classification of the child account within the customer portfolio, reflecting its strategic importance and commercial relationship type. Drives account management priority, SLA tier assignment, and pricing strategy in Salesforce CRM and SAP S/4HANA SD.. Valid values are `strategic|key_account|standard|distributor|oem_partner|system_integrator|end_user|prospect`',
    `effective_date` DATE COMMENT 'The date from which this parent-child hierarchy relationship is valid and active. Used for time-based hierarchy queries, historical roll-up reporting, and compliance with IFRS/GAAP consolidation period requirements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'The date on which this parent-child hierarchy relationship ceases to be valid, typically due to corporate restructuring, divestiture, merger, or acquisition. A null value indicates the relationship is currently active with no planned end date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `global_account_manager` STRING COMMENT 'Name or employee identifier of the global account manager responsible for managing the parent-level account relationship. Used for accountability tracking, escalation routing, and global account management reporting in Salesforce CRM.',
    `hierarchy_code` STRING COMMENT 'Business-assigned alphanumeric code uniquely identifying this hierarchy relationship, used for cross-system referencing in SAP S/4HANA SD and Salesforce CRM account hierarchy structures.. Valid values are `^[A-Z0-9_-]{3,30}$`',
    `hierarchy_depth` STRING COMMENT 'Total number of levels in the hierarchy tree rooted at the ultimate parent account. Indicates the structural complexity of the corporate group. Distinct from hierarchy_level which represents the position of the child; this represents the full tree depth.. Valid values are `^[1-9][0-9]*$`',
    `hierarchy_level` STRING COMMENT 'Numeric depth level of the child account within the corporate hierarchy tree, where level 1 represents the ultimate parent (global headquarters). Used for roll-up reporting, credit exposure aggregation, and global account management analytics.. Valid values are `^[1-9][0-9]*$`',
    `hierarchy_path` STRING COMMENT 'Delimited string representing the full ancestry path from the root (ultimate parent) to the current child account, e.g., ROOT_CODE/REGION_CODE/COUNTRY_CODE/CHILD_CODE. Enables efficient tree traversal and ancestor lookups in analytics and reporting.',
    `hierarchy_type` STRING COMMENT 'Classifies the purpose or dimension of the hierarchy relationship. Corporate reflects legal ownership structure; sales reflects sales territory or account management grouping; credit reflects credit consolidation grouping; reporting reflects management reporting roll-up; legal reflects legal entity structure; operational reflects operational management grouping.. Valid values are `corporate|sales|credit|reporting|legal|operational`',
    `industry_sector_code` STRING COMMENT 'Industry classification code assigned to the child account, aligned with NAICS or SIC standards. Used for market segmentation, industry-specific SLA assignment, and analytics across B2B industrial buyers, OEM partners, system integrators, and distributors.',
    `is_direct_relationship` BOOLEAN COMMENT 'Indicates whether the parent-child relationship in this record is a direct (immediate) relationship (true) or an indirect/derived relationship representing a non-adjacent ancestor-descendant link in the hierarchy (false). Enables distinction between direct and transitive hierarchy edges for graph traversal and reporting.. Valid values are `true|false`',
    `is_primary_hierarchy` BOOLEAN COMMENT 'Indicates whether this hierarchy relationship is the primary (authoritative) hierarchy for the child account when multiple hierarchy types exist (e.g., corporate vs. sales vs. credit). Ensures unambiguous roll-up path selection for consolidated reporting.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this account hierarchy relationship record in the Databricks Silver Layer. Used for change tracking, incremental data processing, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `notes` STRING COMMENT 'Free-text field for capturing additional context, business rationale, or special instructions related to this hierarchy relationship. May include details about corporate restructuring events, exceptions to standard hierarchy rules, or account management notes.',
    `ownership_percentage` DECIMAL(18,2) COMMENT 'Percentage of ownership or equity stake held by the parent account in the child account entity. Critical for IFRS 10/GAAP ASC 810 consolidation determination (>50% typically triggers full consolidation), credit exposure weighting, and financial risk assessment.. Valid values are `^(100(.00?)?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `parent_account_code` STRING COMMENT 'Business identifier of the parent account in the hierarchy relationship, sourced from SAP S/4HANA customer master (SD) or Salesforce CRM. Represents the superior entity (e.g., global headquarters, holding company) in the corporate structure.',
    `region_code` STRING COMMENT 'Internal regional classification code (e.g., EMEA, APAC, AMER, LATAM) assigned to the child account for geographic segmentation, regional reporting, and global account management analytics.',
    `relationship_type` STRING COMMENT 'Classifies the nature of the corporate relationship between the parent and child accounts. Drives legal, financial, and credit consolidation rules. Examples include subsidiary (majority-owned), division (internal business unit), affiliate (minority-owned), joint venture, branch, or distributor.. Valid values are `subsidiary|division|affiliate|joint_venture|branch|holding|franchise|distributor|oem_partner|system_integrator`',
    `restructuring_reason` STRING COMMENT 'Reason code explaining why this hierarchy relationship was created, modified, or terminated. Captures corporate events such as mergers, acquisitions, divestitures, spin-offs, or internal reorganizations. Critical for audit trail and financial consolidation history.. Valid values are `merger|acquisition|divestiture|spin_off|reorganization|joint_venture_formation|dissolution|other`',
    `root_account_code` STRING COMMENT 'Business identifier of the ultimate parent account at the top of the corporate hierarchy (level 1). Used for consolidated credit exposure tracking, global account management, and enterprise-wide roll-up reporting across all subsidiaries and affiliates.',
    `sales_organization_code` STRING COMMENT 'SAP S/4HANA sales organization code under which this hierarchy relationship is defined and managed. Determines the sales area context for the hierarchy, enabling region-specific account management and revenue roll-up.',
    `sla_tier` STRING COMMENT 'Service Level Agreement tier assigned to the child account within this hierarchy, determining response times, support priority, and service entitlements. Inherited from or overridden at the hierarchy level for consolidated account management.. Valid values are `platinum|gold|silver|bronze|standard`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this hierarchy relationship record was sourced. Supports data lineage tracking, reconciliation, and master data management governance across SAP S/4HANA SD and Salesforce CRM.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|OTHER`',
    `source_system_record_code` STRING COMMENT 'Native record identifier of this hierarchy relationship in the originating source system (e.g., SAP S/4HANA account hierarchy node ID or Salesforce CRM account relationship ID). Enables traceability and reconciliation between the Silver Layer and operational systems.',
    `status` STRING COMMENT 'Current operational status of the parent-child hierarchy relationship. Active indicates the relationship is currently valid; inactive indicates it has been superseded or deactivated; pending indicates awaiting approval; terminated indicates formally ended; under_review indicates a corporate restructuring review is in progress.. Valid values are `active|inactive|pending|terminated|under_review`',
    CONSTRAINT pk_account_hierarchy PRIMARY KEY(`account_hierarchy_id`)
) COMMENT 'Defines parent-child corporate hierarchy relationships between customer accounts, enabling roll-up reporting across subsidiaries, regional entities, and global enterprise accounts. Captures parent account, child account, hierarchy level, relationship type (subsidiary, division, affiliate, joint venture), effective date, and hierarchy depth. Critical for global account management and consolidated credit exposure tracking.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`address` (
    `address_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each address record in the customer address repository.',
    `access_restriction` STRING COMMENT 'Indicates any access restrictions applicable to this address for deliveries or service visits. Common in industrial manufacturing environments where plant sites require security clearance, scheduled appointments, or certified personnel.. Valid values are `none|security_clearance_required|appointment_required|restricted_hours|hazmat_certified_only|other`',
    `attention_line` STRING COMMENT 'Attention or care-of line specifying the department, role, or individual to whom correspondence or shipments should be directed at this address (e.g., Attn: Procurement Department, c/o Plant Manager).',
    `city` STRING COMMENT 'Name of the city, municipality, or locality where the address is located. Used for logistics routing, tax jurisdiction determination, and regional reporting.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code identifying the country of the address (e.g., USA, DEU, CHN, GBR). Supports multinational customer operations across all geographies.. Valid values are `^[A-Z]{3}$`',
    `county_district` STRING COMMENT 'County, district, or sub-regional administrative division of the address. Used for local tax jurisdiction determination and regulatory compliance reporting in jurisdictions where county-level data is required.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the address record was first created in the system. Used for audit trail, data lineage, and compliance reporting.',
    `customs_region_code` STRING COMMENT 'Customs or trade region code associated with the address, used for export/import compliance, customs duty calculation, and trade zone classification (e.g., free trade zone, bonded warehouse zone).',
    `data_quality_score` DECIMAL(18,2) COMMENT 'Numeric score (0.00–100.00) representing the overall data quality and completeness of the address record, calculated based on validation status, geocoding accuracy, and field completeness. Supports master data governance and data stewardship workflows.. Valid values are `^(100(.00)?|[0-9]{1,2}(.d{1,2})?)$`',
    `delivery_instruction` STRING COMMENT 'Free-text field capturing special delivery instructions for this address, such as dock door numbers, security gate procedures, receiving hours, or hazardous material handling requirements specific to industrial plant sites.',
    `effective_end_date` DATE COMMENT 'Date after which this address record is no longer valid for business use. A null value indicates the address is currently active with no planned expiry. Used for historical address retention and compliance record-keeping.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_start_date` DATE COMMENT 'Date from which this address record is valid and active for business use. Supports temporal address management for customers who relocate facilities or open new plant sites.. Valid values are `^d{4}-d{2}-d{2}$`',
    `geocoding_accuracy` STRING COMMENT 'Indicates the precision level of the geocoordinates assigned to the address. Rooftop indicates exact match; range_interpolated and approximate indicate lower precision. Used to assess reliability of location-based analytics.. Valid values are `rooftop|range_interpolated|geometric_center|approximate|unverified`',
    `is_default_billing` BOOLEAN COMMENT 'Indicates whether this address is the default billing address for invoice delivery. Used by accounts receivable and ERP invoicing processes to route financial documents to the correct address.. Valid values are `true|false`',
    `is_default_shipping` BOOLEAN COMMENT 'Indicates whether this address is the default shipping/delivery destination for the customer. Used by order management and warehouse management systems to pre-populate delivery addresses on sales orders.. Valid values are `true|false`',
    `is_primary` BOOLEAN COMMENT 'Indicates whether this address is the primary/default address for the associated customer account and address type. Only one address per customer per address type should be flagged as primary.. Valid values are `true|false`',
    `is_validated` BOOLEAN COMMENT 'Indicates whether the address has been validated against a postal authority or address verification service. Validated addresses reduce shipping errors and returned mail for industrial shipments.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'ISO 639-1 language code for the preferred communication language at this address (e.g., en, de, zh-CN, fr). Used to localize shipping documents, invoices, and correspondence for multinational customers.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the address record was most recently updated. Used for change tracking, data synchronization across ERP and CRM systems, and audit compliance.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate of the address in decimal degrees (WGS 84 datum). Enables geocoding, proximity analysis, logistics route optimization, and plant site mapping for multi-site industrial customers.. Valid values are `^-?(90(.0+)?|[0-8]?d(.d+)?)$`',
    `line_1` STRING COMMENT 'Primary street address line including building number, street name, and directional indicators. Represents the first line of the physical or mailing address.',
    `line_2` STRING COMMENT 'Secondary address line for suite, floor, unit, building name, or additional location detail supplementing the primary street address.',
    `line_3` STRING COMMENT 'Tertiary address line used for additional location identifiers such as industrial park name, zone designation, or campus building reference, common in large multi-site industrial facilities.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate of the address in decimal degrees (WGS 84 datum). Used in conjunction with latitude for geocoding, delivery zone assignment, and spatial analytics.. Valid values are `^-?(180(.0+)?|1[0-7]d(.d+)?|[0-9]?d(.d+)?)$`',
    `plant_code` STRING COMMENT 'SAP plant code or equivalent ERP facility identifier associated with this address when the address represents a manufacturing plant or production site. Links the address to production planning and materials management operations.',
    `po_box` STRING COMMENT 'Post Office (PO) Box number for mailing addresses where physical delivery is not applicable. Common for billing and remittance addresses of corporate customers.',
    `postal_code` STRING COMMENT 'Postal or ZIP code for the address. Supports variable formats across countries (e.g., 5-digit US ZIP, alphanumeric UK postcode). Used for shipping rate calculation, tax zone assignment, and geographic analytics.',
    `site_name` STRING COMMENT 'Business name or descriptive label for the physical site at this address (e.g., Chicago Assembly Plant, Frankfurt Distribution Center). Supports multi-site industrial customers with dozens of named plant locations.',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this address record originated (e.g., SAP S/4HANA, Salesforce CRM, SAP Ariba). Supports data lineage tracking and master data reconciliation across ERP and CRM systems.. Valid values are `sap_s4hana|salesforce_crm|sap_ariba|infor_wms|manual|other`',
    `source_system_address_code` STRING COMMENT 'The native address identifier from the originating source system (e.g., SAP Business Partner Address GUID, Salesforce Account Address ID). Enables cross-system reconciliation and traceability back to the system of record.',
    `state_province` STRING COMMENT 'State, province, or administrative region of the address. Stored as ISO 3166-2 subdivision code (e.g., US-CA, DE-BY) to support global multi-country operations and tax jurisdiction mapping.',
    `status` STRING COMMENT 'Current operational status of the address record. Active addresses are used in order fulfillment and billing. Superseded addresses have been replaced by a newer record. Archived addresses are retained for historical compliance.. Valid values are `active|inactive|pending_validation|archived|superseded`',
    `tax_jurisdiction_code` STRING COMMENT 'Tax jurisdiction identifier assigned to the address for sales tax, VAT, or GST determination. Used by ERP tax engines to calculate applicable tax rates for orders shipped to or billed at this address.',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the address location (e.g., America/Chicago, Europe/Berlin). Used for scheduling deliveries, service appointments, and coordinating operations across global plant sites.',
    `type` STRING COMMENT 'Classifies the functional purpose of the address (e.g., headquarters, billing, shipping/delivery, plant site, registered office). A single customer account may have multiple address types across its global operations.. Valid values are `headquarters|billing|shipping|plant_site|registered_office|mailing|remit_to|return|field_service|other`',
    `validation_source` STRING COMMENT 'Identifies the system or service used to validate the address (e.g., USPS CASS, Loqate, Google Maps, manual review). Supports data quality auditing and validation process governance.. Valid values are `usps_cass|loqate|google_maps|here_maps|melissa_data|manual|erp_master|crm_master|unverified`',
    `validation_timestamp` TIMESTAMP COMMENT 'Date and time when the address was last validated against a postal authority or address verification service. Used to schedule re-validation cycles and assess address data freshness.',
    `vat_registration_number` STRING COMMENT 'Value Added Tax (VAT) or GST registration number associated with this address, particularly for EU and international billing addresses. Required for cross-border B2B invoicing and tax compliance in industrial manufacturing.',
    CONSTRAINT pk_address PRIMARY KEY(`address_id`)
) COMMENT 'Authoritative repository of all physical and mailing addresses associated with customer accounts, including headquarters, billing address, shipping/delivery address, plant site address, and registered office. Captures address type, street lines, city, state/province, postal code, country ISO code, geocoordinates, validated flag, validation source, and effective date range. Supports multi-site industrial customers with dozens of plant locations.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`segment` (
    `segment_id` BIGINT COMMENT 'Unique system-generated identifier for each customer segment record within the industrial manufacturing CRM and ERP ecosystem.',
    `campaign_eligibility_flag` BOOLEAN COMMENT 'Boolean indicator specifying whether customers classified in this segment are eligible to receive targeted marketing campaigns, promotional offers, and sales outreach programs.. Valid values are `true|false`',
    `code` STRING COMMENT 'Short alphanumeric code uniquely identifying the customer segment, used for cross-system referencing across SAP S/4HANA SD and Salesforce CRM (e.g., TIER1_OEM, STRAT_DIST, SME_END).. Valid values are `^[A-Z0-9_]{2,20}$`',
    `contract_framework_required` BOOLEAN COMMENT 'Boolean indicator specifying whether customers in this segment must have a formal framework contract or master agreement in place before transacting, as required by commercial policy.. Valid values are `true|false`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp recording when this customer segment record was first created in the data platform, supporting data lineage, audit trails, and governance compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_risk_category` STRING COMMENT 'Credit risk classification assigned to the segment, used to set default credit limits and approval workflows for customer accounts within this segment in SAP S/4HANA FI credit management.. Valid values are `Low|Medium|High|Very High|Blocked`',
    `crm_segment_code` STRING COMMENT 'External identifier for this customer segment as recorded in Salesforce CRM, enabling cross-system reconciliation between the lakehouse silver layer and the CRM system of record.',
    `data_privacy_consent_required` BOOLEAN COMMENT 'Boolean indicator specifying whether explicit data privacy consent must be obtained from customer contacts within this segment before processing their personal data for marketing or analytics purposes.. Valid values are `true|false`',
    `description` STRING COMMENT 'Detailed narrative describing the business rationale, characteristics, and commercial intent of the customer segment for use in sales strategy documentation and go-to-market planning.',
    `discount_rate_percent` DECIMAL(18,2) COMMENT 'Standard percentage discount applied to list prices for customers within this segment as part of the commercial pricing strategy, expressed as a percentage value between 0 and 100.. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    `effective_date` DATE COMMENT 'Date from which this customer segment definition becomes commercially active and applicable for customer account classification, pricing, and SLA assignment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `erp_customer_group_code` STRING COMMENT 'SAP S/4HANA customer group code mapped to this segment, used for pricing condition determination, output determination, and statistical grouping in SD and FI modules.',
    `expiry_date` DATE COMMENT 'Date on which this customer segment definition ceases to be commercially active. Null indicates an open-ended segment with no planned expiration.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_control_classification` STRING COMMENT 'Export control classification applicable to this customer segment, determining whether customers require export licenses or are subject to trade compliance restrictions under US EAR, ITAR, or EU dual-use regulations.. Valid values are `EAR99|ECCN|ITAR|No Restriction|Restricted|Embargoed`',
    `geographic_region` STRING COMMENT 'Primary geographic region associated with the customer segment using ISO 3166-1 alpha-3 country codes, supporting regional go-to-market strategies and territory management across multinational operations.. Valid values are `^[A-Z]{3}$`',
    `go_to_market_channel` STRING COMMENT 'Primary sales and distribution channel through which customers in this segment are engaged and served, informing channel strategy, partner management, and revenue attribution.. Valid values are `Direct Sales|Distributor|Online|Partner Channel|Tender/RFQ|Framework Contract|Hybrid`',
    `industry_vertical` STRING COMMENT 'The primary industry sector served by customers within this segment, enabling vertical-specific go-to-market strategies, product positioning, and regulatory compliance alignment (e.g., Automotive, Aerospace and Defense, Energy and Utilities).. Valid values are `Automotive|Aerospace and Defense|Energy and Utilities|Food and Beverage|Pharmaceuticals|Chemicals|Electronics|Heavy Industry|Building and Infrastructure|Transportation|Other`',
    `last_review_date` DATE COMMENT 'Date on which the most recent formal review of this customer segment was completed, used to track compliance with the defined review cycle and governance obligations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `manager_email` STRING COMMENT 'Corporate email address of the segment manager responsible for this customer segment, used for escalation routing, review notifications, and campaign coordination.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `manager_name` STRING COMMENT 'Full name of the business owner or commercial manager responsible for the strategy, performance, and review of this customer segment.',
    `modified_timestamp` TIMESTAMP COMMENT 'System timestamp recording the most recent update to this customer segment record, used for change tracking, incremental data loads, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `name` STRING COMMENT 'Full descriptive name of the customer segment as used in commercial strategy and go-to-market planning (e.g., Tier-1 OEM, Strategic Distributor, SME End-User, System Integrator).',
    `next_review_date` DATE COMMENT 'Scheduled date for the next formal review of this customer segment, enabling proactive governance and ensuring segment definitions remain aligned with current commercial strategy.. Valid values are `^d{4}-d{2}-d{2}$`',
    `payment_terms` STRING COMMENT 'Standard payment terms applicable to customers within this segment, defining the expected payment timeline and any early payment discount conditions as configured in SAP S/4HANA FI.. Valid values are `Net 30|Net 45|Net 60|Net 90|Immediate|2/10 Net 30|Letter of Credit|Advance Payment`',
    `pricing_strategy` STRING COMMENT 'Commercial pricing approach applied to customers within this segment, determining how product and service prices are structured, discounted, or contracted in SAP S/4HANA SD pricing conditions.. Valid values are `List Price|Negotiated Discount|Volume Rebate|Cost Plus|Fixed Contract|Framework Agreement|Spot Price`',
    `regulatory_compliance_scope` STRING COMMENT 'Comma-separated list of applicable regulatory frameworks and compliance obligations relevant to customers in this segment (e.g., REACH, RoHS, CE Marking, ITAR, Export Control), informing compliance checks during order processing.',
    `revenue_band_currency` STRING COMMENT 'ISO 4217 three-letter currency code in which the revenue band minimum and maximum thresholds are denominated, supporting multi-currency global segment definitions.. Valid values are `^[A-Z]{3}$`',
    `revenue_band_max` DECIMAL(18,2) COMMENT 'Maximum annual revenue threshold (in segment currency) defining the upper boundary of the revenue band used to classify customers into this segment for pricing and SLA tier assignment.',
    `revenue_band_min` DECIMAL(18,2) COMMENT 'Minimum annual revenue threshold (in segment currency) defining the lower boundary of the revenue band used to classify customers into this segment for pricing and SLA tier assignment.',
    `review_cycle` STRING COMMENT 'Frequency at which this customer segment definition, criteria, and performance are formally reviewed and updated by the segment manager and commercial leadership.. Valid values are `Monthly|Quarterly|Semi-Annual|Annual|Ad Hoc`',
    `sales_organization` STRING COMMENT 'SAP S/4HANA sales organization code responsible for managing and owning this customer segment, aligning the segment to the correct legal entity, region, and revenue reporting structure.',
    `sla_tier` STRING COMMENT 'Service Level Agreement tier assigned to this customer segment, governing response times, support entitlements, and delivery commitments for all customers classified within the segment.. Valid values are `Platinum|Gold|Silver|Bronze|Standard`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this customer segment record originated, supporting data lineage traceability and cross-system reconciliation in the Databricks lakehouse silver layer.. Valid values are `SAP_S4HANA|Salesforce_CRM|Manual|Other`',
    `status` STRING COMMENT 'Current operational status of the customer segment record, controlling whether the segment is available for assignment to customer accounts and commercial campaigns.. Valid values are `active|inactive|under_review|archived`',
    `strategic_priority_flag` BOOLEAN COMMENT 'Boolean indicator designating whether this customer segment is classified as a strategic priority for executive-level attention, dedicated account management, and preferential resource allocation.. Valid values are `true|false`',
    `sub_region` STRING COMMENT 'Secondary geographic sub-region or sales territory within the primary geographic region, enabling finer-grained territory management and regional commercial strategy alignment.',
    `target_customer_count` STRING COMMENT 'Planned number of customer accounts targeted for classification within this segment as part of the commercial go-to-market strategy and sales planning cycle.. Valid values are `^[0-9]+$`',
    `tier` STRING COMMENT 'Commercial tier classification indicating the strategic importance and priority level of the segment, used to differentiate service levels, pricing, and SLA assignments (e.g., Tier-1 OEM receives premium SLA).. Valid values are `Tier-1|Tier-2|Tier-3|Strategic|Standard|Emerging`',
    `type` STRING COMMENT 'Classification of the customer segment by buyer archetype within the industrial manufacturing value chain, distinguishing OEM partners, distributors, system integrators, end-users, and resellers.. Valid values are `OEM|Distributor|System Integrator|End User|Reseller|Partner|Government|Other`',
    CONSTRAINT pk_segment PRIMARY KEY(`segment_id`)
) COMMENT 'Market segmentation classification records defining how customer accounts are grouped for commercial strategy, pricing, and go-to-market purposes. Captures segment code, segment name (e.g., Tier-1 OEM, Strategic Distributor, SME End-User, System Integrator), industry vertical, geographic region, revenue band, strategic priority flag, assigned segment manager, and review cycle. Used for targeted sales campaigns and SLA tier assignment.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`credit_profile` (
    `credit_profile_id` BIGINT COMMENT 'Unique surrogate identifier for the customer credit profile record in the Databricks Silver Layer. Serves as the primary key for all credit risk and order-to-cash processes.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Credit profiles are owned by a specific customer account and represent the financial risk standing of that account. This FK is the fundamental ownership relationship. The denormalized customer_account',
    `controlling_area_id` BIGINT COMMENT 'Foreign key linking to finance.controlling_area. Business justification: Credit profiles are managed within controlling areas for credit risk monitoring and exposure analysis. Credit management teams track customer credit limits by controlling area for financial control.',
    `credit_analyst_employee_id` BIGINT COMMENT 'FK to workforce.employee',
    `employee_id` BIGINT COMMENT 'Employee identifier of the credit analyst responsible for managing and reviewing this customers credit profile. Used for workload assignment, accountability tracking, and escalation routing in the order-to-cash process.',
    `credit_account_currency` STRING COMMENT 'ISO 4217 three-letter currency code representing the local account currency in which the credit limit and exposure are denominated for this customer (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `credit_block_status` BOOLEAN COMMENT 'Indicates whether the customer account is currently subject to a credit block (True) or not (False). When True, new sales orders for this customer are blocked in SAP S/4HANA SD pending credit review and release by an authorized credit analyst.. Valid values are `true|false`',
    `credit_check_method` STRING COMMENT 'SAP credit check method code controlling how credit checks are performed for this customer during order-to-cash processing (e.g., A=Static Credit Check, B=Dynamic Credit Check, C=Maximum Document Value, D=No Check). Determines the credit verification logic applied at sales order creation.. Valid values are `A|B|C|D`',
    `credit_control_area` STRING COMMENT 'SAP organizational unit (credit control area code) responsible for managing and monitoring the customers credit. Defines the currency, fiscal year variant, and credit management rules applicable to this customers credit profile.',
    `credit_exposure_amount` DECIMAL(18,2) COMMENT 'Current total credit exposure for the customer in account currency, comprising open sales orders, open deliveries, open billing documents, and outstanding accounts receivable. Compared against credit limit to determine credit availability.',
    `credit_hold_reason` STRING COMMENT 'Reason code explaining why the customer account has been placed on credit hold. Used by credit analysts and order management teams to prioritize resolution actions and communicate hold rationale to sales teams.. Valid values are `OVERLIMIT|OVERDUE|RISK_CLASS|MANUAL|LEGAL_DISPUTE|BANKRUPTCY|PAYMENT_BEHAVIOR|OTHER`',
    `credit_hold_reason_text` STRING COMMENT 'Free-text narrative providing additional context or detail for the credit hold reason beyond the structured reason code. Entered by the credit analyst to document specific circumstances such as dispute details or negotiation status.',
    `credit_insurance_limit` DECIMAL(18,2) COMMENT 'Maximum insured amount covered by the trade credit insurance policy for this customer, expressed in account currency. Represents the insurers approved exposure ceiling and is a key input to the internal credit limit approval process.',
    `credit_insurance_policy_number` STRING COMMENT 'Reference number of the trade credit insurance policy covering this customer account, if applicable. Credit insurance mitigates the financial risk of customer default and may allow higher credit limits to be extended to insured customers.',
    `credit_limit_account_currency` DECIMAL(18,2) COMMENT 'Maximum credit amount extended to the customer expressed in the accounts local currency. Defines the upper boundary of outstanding receivables permitted before credit block is triggered in SAP S/4HANA SD order processing.',
    `credit_limit_approved_date` DATE COMMENT 'Date on which the current credit limit was formally approved by the authorized credit analyst or credit committee. Provides an audit trail for credit limit changes and supports SOX compliance for financial controls.. Valid values are `^d{4}-d{2}-d{2}$`',
    `credit_limit_expiry_date` DATE COMMENT 'Date on which the currently approved credit limit expires and requires renewal or re-approval. After this date, the credit limit may be automatically reduced or the account placed on hold pending review.. Valid values are `^d{4}-d{2}-d{2}$`',
    `credit_limit_group_currency` DECIMAL(18,2) COMMENT 'Maximum credit amount extended to the customer expressed in the corporate group currency (e.g., USD for a US-headquartered multinational). Enables consolidated credit exposure reporting across all subsidiaries and legal entities.',
    `credit_risk_class` STRING COMMENT 'SAP credit risk class code assigned to the customer, representing the internal risk tier (e.g., 001=Very Low Risk, 002=Low Risk, 003=Medium Risk, 004=High Risk, 005=Very High Risk). Drives credit check rules and automatic credit limit proposals.. Valid values are `001|002|003|004|005`',
    `credit_risk_class_description` STRING COMMENT 'Human-readable description of the credit risk class assigned to the customer (e.g., Very Low Risk, Medium Risk, High Risk). Supports reporting and business user interpretation without requiring code lookups.',
    `credit_segment` STRING COMMENT 'SAP credit segment identifier grouping customers for credit management purposes, enabling separate credit limit management per business unit, sales organization, or geographic region within a single customer account.',
    `credit_utilization_pct` DECIMAL(18,2) COMMENT 'Percentage of the credit limit currently utilized, calculated as (credit_exposure_amount / credit_limit_account_currency) * 100. Used for credit risk monitoring dashboards and automated alert thresholds.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `days_sales_outstanding` DECIMAL(18,2) COMMENT 'Average number of days the customer takes to pay invoices, calculated from invoice date to payment receipt date over a rolling period. A key KPI for accounts receivable management and credit risk assessment in the order-to-cash process.',
    `dunning_bradstreet_rating` STRING COMMENT 'External credit rating assigned by Dun & Bradstreet (D&B) for the customer organization, such as the D&B PAYDEX score or Financial Stress Score. Used as an external benchmark to validate and calibrate internal credit risk assessments.',
    `dunning_bradstreet_score` STRING COMMENT 'Numeric D&B PAYDEX score (1–100) reflecting the customers payment performance history based on trade references reported to Dun & Bradstreet. Higher scores indicate better payment behavior. Used alongside internal scoring for credit limit decisions.. Valid values are `^([1-9][0-9]?|100)$`',
    `dunning_level` STRING COMMENT 'Current dunning level (0–4) assigned to the customer in SAP S/4HANA FI-AR, reflecting the escalation stage of the collections process. Level 0 = no dunning; Level 4 = final notice / legal action. Drives automated dunning letter generation and collections escalation.. Valid values are `^[0-4]$`',
    `effective_date` DATE COMMENT 'Date from which the current credit profile terms (credit limit, risk class, payment terms) became effective. Supports bi-temporal data modeling and historical credit profile analysis in the Silver Layer.. Valid values are `^d{4}-d{2}-d{2}$`',
    `group_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the corporate group reporting currency used to express the group-currency credit limit and exposure (e.g., USD, EUR).. Valid values are `^[A-Z]{3}$`',
    `internal_credit_score` STRING COMMENT 'Proprietary internal credit score assigned to the customer based on payment history, financial statements, order behavior, and risk class. Used by credit analysts to make credit limit recommendations and risk classification decisions.',
    `last_dunning_date` DATE COMMENT 'Date on which the most recent dunning notice was issued to the customer. Used to enforce dunning interval rules and prevent premature re-dunning in SAP S/4HANA FI-AR collections management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_review_date` DATE COMMENT 'Date on which the most recent formal credit review was completed for this customer. Used to track review cadence compliance and identify overdue reviews that may require updated credit limit or risk class reassessment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next formal credit review of this customer account. Drives credit analyst workqueue prioritization and ensures timely reassessment of credit limits and risk classifications per internal credit policy.. Valid values are `^d{4}-d{2}-d{2}$`',
    `oldest_open_item_days` STRING COMMENT 'Number of days since the oldest unpaid open invoice item was due for this customer. Used in credit risk assessment and dunning level determination — a high value indicates chronic payment delays requiring escalation.',
    `overdue_amount` DECIMAL(18,2) COMMENT 'Total value of outstanding invoices that have exceeded their payment due date, expressed in account currency. A primary trigger for credit block activation and dunning process initiation in SAP S/4HANA FI-AR.',
    `payment_behavior_code` STRING COMMENT 'Internal classification of the customers historical payment behavior based on analysis of invoice payment patterns, average days past due, and frequency of late payments. Informs credit risk class assignment and credit limit decisions.. Valid values are `EXCELLENT|GOOD|FAIR|POOR|DELINQUENT`',
    `payment_terms_code` STRING COMMENT 'SAP payment terms key (e.g., NT30, NT60, 2/10NET30) assigned to the customer, defining the agreed payment due dates, early payment discount percentages, and baseline date calculation. Directly impacts days sales outstanding (DSO) and credit exposure calculations.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the credit profile record was first created in the source system (SAP S/4HANA). Provides the creation audit trail for compliance, data lineage, and historical analysis in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the credit profile record in the source system. Used for incremental data loading, change detection, and audit trail maintenance in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `review_frequency` STRING COMMENT 'Frequency at which the customers credit profile is formally reviewed and updated. Typically determined by the customers risk class — high-risk customers are reviewed more frequently than low-risk customers.. Valid values are `MONTHLY|QUARTERLY|SEMI_ANNUAL|ANNUAL|TRIGGERED`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this credit profile record was sourced (e.g., SAP_S4HANA for FI/SD-originated records, SALESFORCE_CRM for CRM-originated records). Supports data lineage tracking in the Databricks Silver Layer.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|OTHER`',
    `special_credit_terms` STRING COMMENT 'Description of any special or negotiated credit terms applicable to this customer that deviate from standard payment terms, such as extended payment windows, consignment arrangements, or letter of credit requirements. Documented for order management and finance reference.',
    `status` STRING COMMENT 'Current lifecycle status of the customer credit profile record. ACTIVE indicates a fully operational credit profile; UNDER_REVIEW indicates a formal credit review is in progress; SUSPENDED indicates temporary suspension pending resolution; CLOSED indicates the profile has been deactivated.. Valid values are `ACTIVE|INACTIVE|SUSPENDED|UNDER_REVIEW|CLOSED`',
    CONSTRAINT pk_credit_profile PRIMARY KEY(`credit_profile_id`)
) COMMENT 'Financial credit standing and risk assessment record for each customer account, managed in SAP S/4HANA FI/SD. Captures credit limit (in account currency and group currency), credit exposure, credit risk class, payment terms code, credit block status, credit check method, Dun & Bradstreet rating, internal credit score, last review date, next review date, credit analyst, and credit hold reason. Essential for order-to-cash risk management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`sla_agreement` (
    `sla_agreement_id` BIGINT COMMENT 'Unique system-generated identifier for each Service Level Agreement (SLA) record. Serves as the primary key for the sla_agreement data product and is used for cross-system referencing across CRM and ERP platforms.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: SLA agreements define contractual performance commitments made to specific customer accounts. This FK establishes the fundamental ownership relationship. No existing FK exists. No safe denormalized ac',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: SLA agreements reference a specific customer contact person (customer_contact_name STRING). Normalizing to a FK links the SLA to the authoritative contact record. customer_contact_name is removed as i',
    `sla_definition_id` BIGINT COMMENT 'Foreign key linking to technology.sla_definition. Business justification: Customer SLA agreements reference standardized SLA definitions that specify technical service levels (uptime, response times). Sales and service teams use this to ensure customer contracts align with ',
    `warranty_policy_id` BIGINT COMMENT 'Foreign key linking to product.warranty_policy. Business justification: Service level agreements often extend or customize standard product warranty policies. Service operations use this to determine coverage, response times, and entitlements for customer support requests',
    `agreement_number` STRING COMMENT 'Human-readable, business-facing unique identifier for the SLA agreement, used in customer communications, contract documents, and ERP/CRM cross-referencing. Typically generated by Salesforce CRM or SAP SD.. Valid values are `^SLA-[A-Z0-9]{4,20}$`',
    `approval_status` STRING COMMENT 'The internal approval workflow status of the SLA agreement. Tracks whether the SLA has been reviewed and approved by authorized stakeholders (e.g., legal, finance, operations) before becoming active. Supports governance and audit trail requirements.. Valid values are `pending|approved|rejected|revision_required`',
    `approved_date` DATE COMMENT 'The date on which the SLA agreement received final internal approval and was authorized for activation. Used for audit trail, compliance reporting, and tracking the time from SLA creation to activation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the SLA agreement is configured to automatically renew upon expiry without requiring explicit customer or sales action. When True, the SLA renews under the same terms unless cancelled before the renewal date. Drives automated renewal workflows in SAP SD and Salesforce CRM.. Valid values are `true|false`',
    `business_unit` STRING COMMENT 'The internal business unit or division responsible for fulfilling and managing this SLA. For example, Automation Systems, Electrification Solutions, or Smart Infrastructure. Enables SLA performance reporting and accountability at the business unit level.',
    `category` STRING COMMENT 'Categorizes the SLA by its scope of applicability — whether it applies to a specific customer account, a master contract, a product line, a regional operation, or globally across the enterprise. Supports hierarchical SLA management and reporting.. Valid values are `customer_account|contract|product_line|regional|global`',
    `contract_reference_number` STRING COMMENT 'The reference number of the master contract or service agreement to which this SLA is linked. Enables traceability between SLA commitments and the underlying contractual documents in SAP SD or Salesforce CRM. A single contract may have multiple SLA records.',
    `currency_code` STRING COMMENT 'The ISO 4217 three-letter currency code in which penalty amounts, cap values, and any financial terms of the SLA are denominated. Supports multi-currency operations across global manufacturing entities. Examples: USD, EUR, GBP, JPY, CNY.. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Free-text description of the SLA agreement, capturing the scope, context, and any special conditions or exclusions not covered by structured fields. Provides business context for analysts, account managers, and auditors reviewing the SLA record.',
    `effective_date` DATE COMMENT 'The date on which the SLA agreement becomes contractually active and enforceable. Marks the start of the SLA performance measurement period. Used in SAP SD contract management and Salesforce Service Cloud entitlement activation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `escalation_procedure` STRING COMMENT 'Describes the escalation path and procedure to be followed when an SLA is at risk of breach or has been breached. May reference an escalation matrix, named contacts, or a defined process code. Supports Salesforce Service Cloud escalation rule configuration and customer communication workflows.',
    `escalation_threshold_percent` DECIMAL(18,2) COMMENT 'The percentage of the SLA target value at which an escalation warning is triggered before an actual breach occurs. For example, 80% means an alert is raised when 80% of the allowed response time has elapsed. Enables proactive SLA management and breach prevention.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `expiry_date` DATE COMMENT 'The date on which the SLA agreement expires and is no longer enforceable. After this date, the SLA transitions to expired status unless renewed. Used for contract renewal tracking, compliance monitoring, and customer account management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `governing_law_country` STRING COMMENT 'The ISO 3166-1 alpha-3 country code of the jurisdiction whose laws govern the SLA agreement in case of disputes. Critical for multinational operations where SLAs may be subject to different legal frameworks. Examples: USA, DEU, GBR, CHN, BRA.. Valid values are `^[A-Z]{3}$`',
    `language_code` STRING COMMENT 'The IETF BCP 47 language code of the primary language in which the SLA agreement is written and communicated. Supports multi-language document management in global operations. Examples: en-US, de-DE, zh-CN, fr-FR, pt-BR.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `measurement_frequency` STRING COMMENT 'Defines how often the SLA metric is measured and evaluated for compliance. For example, monthly for delivery performance SLAs, per_incident for support response SLAs, or real_time for uptime SLAs. Drives the cadence of SLA reporting and review cycles.. Valid values are `real_time|daily|weekly|monthly|quarterly|annually|per_incident|per_order`',
    `measurement_window` STRING COMMENT 'Specifies the time window within which SLA performance is measured. Distinguishes between calendar hours (24x7), business hours only, or business days only. Critical for support and field service SLAs where response time commitments differ based on operating hours.. Valid values are `calendar_hours|business_hours|24x7|business_days_only`',
    `metric_name` STRING COMMENT 'The specific performance metric being measured under this SLA, such as First Response Time, Order-to-Ship Lead Time, Mean Time To Repair (MTTR), On-Time Delivery Rate, or Defect Resolution Time. Defines what is being tracked and enforced.',
    `minimum_threshold_value` DECIMAL(18,2) COMMENT 'The minimum acceptable performance level below which penalty clauses are triggered. Distinct from the target value — the target is the goal, while the minimum threshold is the contractual floor. For example, target may be 95% on-time delivery, with a minimum threshold of 90% before penalties apply.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `name` STRING COMMENT 'Descriptive business name of the SLA agreement, such as Platinum Delivery SLA – EMEA or Critical Support Response SLA – Tier 1. Used for identification in dashboards, reports, and customer-facing documents.',
    `owner_name` STRING COMMENT 'The name of the internal account manager, service manager, or contract owner responsible for managing and enforcing this SLA. Used for accountability, escalation routing, and customer relationship management in Salesforce CRM.',
    `penalty_cap_value` DECIMAL(18,2) COMMENT 'The maximum cumulative financial penalty that can be applied under this SLA agreement, regardless of the number or severity of breaches. Expressed in the agreement currency. Protects both parties from unlimited liability and is a standard clause in enterprise manufacturing contracts.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `penalty_clause_flag` BOOLEAN COMMENT 'Indicates whether this SLA agreement includes a contractual penalty clause that is triggered upon SLA breach. When True, the penalty_rate and penalty_type fields define the financial consequences of non-compliance. Critical for financial risk management and contract compliance reporting.. Valid values are `true|false`',
    `penalty_rate` DECIMAL(18,2) COMMENT 'The rate or amount applied as a financial penalty when the SLA is breached. Interpretation depends on penalty_type: for percentage_of_invoice, this is a percentage (e.g., 2.5 = 2.5%); for fixed_amount, this is a monetary value in the agreement currency. Used in SAP FI/CO for penalty invoice generation.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `penalty_type` STRING COMMENT 'Defines the mechanism by which financial penalties are applied upon SLA breach. percentage_of_invoice applies a percentage deduction to the invoice value; fixed_amount applies a flat fee; service_credit issues a credit note; rebate reduces future billing. Drives penalty calculation logic in SAP FI/CO.. Valid values are `percentage_of_invoice|fixed_amount|service_credit|rebate|none`',
    `priority_level` STRING COMMENT 'The priority tier assigned to this SLA, reflecting the urgency and criticality of the performance commitment. Critical and high-priority SLAs typically have tighter targets, stricter penalties, and escalation paths. Used in Salesforce Service Cloud for case routing and escalation rule configuration.. Valid values are `critical|high|medium|low|standard`',
    `region_code` STRING COMMENT 'The internal business region code to which this SLA applies, such as EMEA, APAC, AMER, or a country-specific region. Used for regional SLA performance reporting, compliance tracking, and regional operations management across the multinational enterprise.. Valid values are `^[A-Z]{2,10}$`',
    `renewal_date` DATE COMMENT 'The date on which the SLA agreement is scheduled for renewal review or automatic renewal. Supports proactive contract management, customer retention workflows, and renewal pipeline reporting in Salesforce CRM.. Valid values are `^d{4}-d{2}-d{2}$`',
    `review_frequency` STRING COMMENT 'The agreed frequency at which SLA performance is formally reviewed with the customer. Drives the scheduling of SLA review meetings, performance reports, and continuous improvement discussions. Supports after-sales and customer success management processes.. Valid values are `monthly|quarterly|semi_annually|annually|ad_hoc`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this SLA agreement record originated. Supports data lineage, reconciliation between CRM and ERP systems, and Silver Layer data integration governance in the Databricks Lakehouse.. Valid values are `salesforce_crm|sap_sd|manual|other`',
    `special_conditions` STRING COMMENT 'Documents any special contractual conditions, exclusions, or exceptions that modify the standard SLA terms. For example, force majeure clauses, seasonal exclusions, or product-specific carve-outs. Critical for accurate SLA compliance assessment and dispute resolution.',
    `status` STRING COMMENT 'Current lifecycle status of the SLA agreement. Controls whether the SLA is enforceable and actively monitored. Transitions from draft through approval to active, and eventually to expired or terminated upon contract end or early cancellation.. Valid values are `draft|pending_approval|active|suspended|expired|terminated|under_review`',
    `target_value` DECIMAL(18,2) COMMENT 'The contractually committed performance target for the SLA metric. For example, a target value of 4 with unit hours means the SLA commits to a 4-hour response time. This is the threshold against which actual performance is measured for compliance and penalty assessment.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `termination_date` DATE COMMENT 'The date on which the SLA agreement was early-terminated before its scheduled expiry date. Distinct from expiry_date, which represents the planned end. Populated only when the SLA is terminated early due to contract cancellation, customer churn, or mutual agreement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `termination_reason` STRING COMMENT 'The reason code explaining why the SLA agreement was terminated before its scheduled expiry. Used for root cause analysis, customer churn reporting, and contract performance analytics. Populated only when termination_date is set.. Valid values are `contract_cancellation|customer_request|mutual_agreement|breach_by_customer|breach_by_supplier|business_restructuring|other`',
    `tier` STRING COMMENT 'The commercial service tier associated with this SLA, reflecting the level of service purchased by the customer. Platinum and Gold tiers typically carry premium commitments and are linked to higher-value contracts. Used for customer segmentation, pricing, and service differentiation.. Valid values are `platinum|gold|silver|bronze|standard|custom`',
    `type` STRING COMMENT 'Classification of the SLA by the nature of the performance commitment. Determines which operational process the SLA governs — e.g., delivery lead time for logistics, technical support response for after-sales, or field service for on-site maintenance. Drives routing and enforcement logic in Salesforce Service Cloud and SAP SD.. Valid values are `delivery_lead_time|order_fulfillment|technical_support_response|field_service|preventive_maintenance|spare_parts_availability|uptime_guarantee|quality_defect_resolution`',
    `unit_of_measure` STRING COMMENT 'The unit in which the SLA metric target value is expressed. For example, hours for response time SLAs, percentage for on-time delivery rate SLAs, days for lead time SLAs, or count for defect occurrence SLAs. Essential for correct interpretation and measurement of the target value.. Valid values are `hours|minutes|days|percentage|count|business_days`',
    `version_number` STRING COMMENT 'The version number of the SLA agreement, incremented each time the SLA terms are formally revised and a new version is issued. Supports SLA change history tracking, audit compliance, and ensures the correct version is enforced at any point in time.. Valid values are `^[1-9][0-9]*$`',
    CONSTRAINT pk_sla_agreement PRIMARY KEY(`sla_agreement_id`)
) COMMENT 'Service Level Agreement records defining contractual performance commitments made to customer accounts, including delivery lead time SLAs, order fulfillment SLAs, technical support response SLAs, and field service SLAs. Captures SLA type, metric name, target value, measurement unit, measurement frequency, penalty clause flag, penalty rate, effective date, expiry date, and linked contract reference. Supports after-sales and order management SLA enforcement.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`partner_function` (
    `partner_function_id` BIGINT COMMENT 'Unique surrogate identifier for each partner function assignment record in the silver layer lakehouse. Serves as the primary key for this entity.',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: Partner functions can be assigned to specific contact persons (e.g., a contact is designated as the sold-to or ship-to contact for a partner function). The contact_person_number STRING field is a ',
    `account_id` BIGINT COMMENT 'The Salesforce CRM account identifier corresponding to the partner fulfilling this function. Enables cross-system reconciliation between SAP S/4HANA SD partner determination and Salesforce CRM account records.',
    `address_number` STRING COMMENT 'The SAP address number (from the central address management) associated with this partner function. Used to resolve the physical address for shipping, billing, or correspondence for this specific function.. Valid values are `^[A-Z0-9]{1,20}$`',
    `assignment_level` STRING COMMENT 'Indicates the level at which this partner function is assigned — at the customer master level (default for all transactions), sales area level, document header level, or document item level. Determines the scope of applicability.. Valid values are `customer_master|sales_area|document_header|document_item`',
    `authorization_group` STRING COMMENT 'SAP authorization group code controlling which users or roles are permitted to view or modify this partner function assignment. Supports role-based access control and data security governance.',
    `change_reason` STRING COMMENT 'Business reason or justification for the most recent change to this partner function assignment (e.g., Contract renewal, Organizational restructuring, Customer request, Merger/acquisition). Supports audit trail and change management.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the partner fulfilling this function. Used for tax determination, export control compliance, and regulatory reporting.. Valid values are `^[A-Z]{3}$`',
    `created_by_user` STRING COMMENT 'The user ID or username of the person who created this partner function assignment in the source system. Supports audit trail and accountability tracking per quality management requirements.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this partner function assignment record was first created in the source system. Used for audit trail, data lineage, and lifecycle tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `determination_procedure` STRING COMMENT 'The SAP partner determination procedure code that governs how this partner function is resolved in sales documents. Defines the sequence and rules for automatic partner determination.. Valid values are `^[A-Z0-9]{1,6}$`',
    `distribution_channel` STRING COMMENT 'The SAP distribution channel code scoping this partner function assignment. Represents the means by which products reach customers (e.g., direct sales, wholesale, OEM).. Valid values are `^[A-Z0-9]{1,2}$`',
    `division` STRING COMMENT 'The SAP division code scoping this partner function assignment. Represents the product line or business unit division (e.g., automation, electrification, smart infrastructure).. Valid values are `^[A-Z0-9]{1,2}$`',
    `document_type` STRING COMMENT 'The SAP sales document type (e.g., OR=Standard Order, QT=Quotation, CR=Credit Memo Request) for which this partner function assignment applies. Null indicates applicability across all document types.',
    `erp_partner_number` STRING COMMENT 'The source ERP systems native partner/customer number for this partner function assignment. Used for traceability back to the SAP S/4HANA source record and cross-system reconciliation.. Valid values are `^[A-Z0-9]{1,20}$`',
    `function_category` STRING COMMENT 'Standardized business category classifying the partner function into a canonical role type for cross-system analytics and reporting, independent of source system codes.. Valid values are `sold_to|ship_to|bill_to|payer|end_user|ordering_party|forwarding_agent|contact_person|sales_employee|other`',
    `function_code` STRING COMMENT 'SAP SD partner function code identifying the role of the partner in a commercial transaction (e.g., SP=Sold-To Party, SH=Ship-To Party, BP=Bill-To Party, PY=Payer, EU=End User, AG=Ordering Party). Directly maps to SAP VBPA-PARVW field.. Valid values are `^[A-Z0-9]{2,4}$`',
    `function_description` STRING COMMENT 'Human-readable description of the partner function role (e.g., Sold-To Party, Ship-To Party, Bill-To Party, Payer, End User, Forwarding Agent). Used for display in reports and order documents.',
    `intercompany_flag` BOOLEAN COMMENT 'Indicates whether this partner function assignment represents an intercompany relationship (i.e., the partner belongs to the same corporate group). Used for intercompany billing and transfer pricing processes.. Valid values are `true|false`',
    `is_default` BOOLEAN COMMENT 'Indicates whether this partner function assignment is the default for the given function code within the sales area. When true, this partner is automatically proposed in new sales documents without manual selection.. Valid values are `true|false`',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether this partner function is mandatory for order processing. When true, the system requires this function to be populated before a sales document can be saved or processed.. Valid values are `true|false`',
    `item_category` STRING COMMENT 'The SAP sales document item category for which this partner function is applicable at the item level. Used when partner functions are assigned at document item granularity rather than header level.',
    `language_code` STRING COMMENT 'ISO 639-1 two-letter language code representing the preferred communication language for this partner function. Used to determine the language for order confirmations, invoices, and shipping documents sent to this partner.. Valid values are `^[A-Z]{2}$`',
    `last_modified_by_user` STRING COMMENT 'The user ID or username of the person who last modified this partner function assignment in the source system. Supports audit trail and change accountability.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this partner function assignment record in the source system. Used for incremental data loading, change detection, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `notes` STRING COMMENT 'Free-text notes or comments providing additional context about this partner function assignment, such as special handling instructions, contractual nuances, or operational remarks.',
    `partner_name` STRING COMMENT 'The name of the business partner (company or individual) fulfilling this partner function. Used for display on order confirmations, shipping documents, and invoices.',
    `partner_type` STRING COMMENT 'Indicates the type of business partner fulfilling this function — whether it is a customer account, an individual contact person, a vendor, an employee, or an organizational unit. Maps to SAP partner type (KU, AP, LI, PE).. Valid values are `customer|contact_person|vendor|employee|organization`',
    `sales_organization` STRING COMMENT 'The SAP sales organization code under which this partner function assignment is valid. Defines the organizational unit responsible for the sale of products or services.. Valid values are `^[A-Z0-9]{1,4}$`',
    `sequence_number` STRING COMMENT 'Numeric sequence number used when multiple partners fulfill the same function code for a given account and sales area. Determines the priority order for partner selection in document processing.. Valid values are `^[0-9]{1,3}$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this partner function assignment was sourced (e.g., SAP S/4HANA, Salesforce CRM). Supports data lineage and cross-system reconciliation in the lakehouse.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|OTHER`',
    `source_system_key` STRING COMMENT 'The natural/composite key from the source system uniquely identifying this partner function record (e.g., SAP KNVP composite key: KUNNR+VKORG+VTWEG+SPART+PARVW). Enables idempotent upserts and lineage tracking.',
    `status` STRING COMMENT 'Current operational status of the partner function assignment. Drives whether the assignment is available for use in new sales documents and order routing.. Valid values are `active|inactive|pending|blocked|expired`',
    `tax_jurisdiction_code` STRING COMMENT 'The tax jurisdiction code associated with this partner function, used for tax determination in sales transactions. Particularly relevant for Ship-To and Bill-To partner functions where tax liability is determined.',
    `valid_from_date` DATE COMMENT 'The date from which this partner function assignment becomes effective. Used to manage time-bound partner relationships and contractual validity periods.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'The date on which this partner function assignment expires. After this date, the partner function is no longer valid for new transactions. Used for contract expiry and partner relationship lifecycle management.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_partner_function PRIMARY KEY(`partner_function_id`)
) COMMENT 'Defines the functional roles that customer accounts or contacts play in commercial transactions, such as Sold-To Party, Ship-To Party, Bill-To Party, Payer, and End-User. Captures partner function code, partner function description, account reference, contact reference, default flag, and validity period. Directly maps to SAP S/4HANA SD partner determination schema and is critical for order routing and invoice generation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`account_classification` (
    `account_classification_id` BIGINT COMMENT 'Unique surrogate identifier for each account classification record in the silver layer lakehouse. Serves as the primary key for this entity.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Classification records are owned by a specific customer account. This FK establishes the fundamental ownership relationship enabling multi-dimensional classification of accounts for pricing, reporting',
    `segment_id` BIGINT COMMENT 'Foreign key linking to customer.customer_segment. Business justification: account_classification contains a denormalized customer_segment STRING field that references the customer_segment reference table. Normalizing this to a FK eliminates the string duplication and ensure',
    `abc_class` STRING COMMENT 'The ABC classification assigned to the customer account based on revenue contribution and strategic importance. A represents the highest-value accounts (typically top 20% generating ~80% of revenue), B represents mid-tier accounts, and C represents lower-value accounts. Used in sales prioritization and resource allocation.. Valid values are `A|B|C|D`',
    `approved_by_user` STRING COMMENT 'The username or user ID of the individual who approved the classification assignment. Required for export control classifications (ECCN) and high-risk credit classifications where dual-control approval is mandated.',
    `assigned_by_user` STRING COMMENT 'The username or user ID of the individual who assigned the classification to the customer account. Supports audit trail requirements and accountability for classification decisions.',
    `assigned_date` DATE COMMENT 'The calendar date on which the classification was formally assigned to the customer account. Used for audit trails, compliance reporting, and tracking classification history.. Valid values are `^d{4}-d{2}-d{2}$`',
    `change_reason` STRING COMMENT 'A free-text or coded reason explaining why the classification was changed or updated. Supports audit trail requirements and provides business context for classification history. Examples: Annual ABC review, Export license obtained, Credit risk reassessment.',
    `classification_code` STRING COMMENT 'The standardized short code representing the classification value within the classification scheme. Used for system-to-system integration, SAP S/4HANA customer classification fields, and export control screening lookups.',
    `classification_description` STRING COMMENT 'Human-readable description of the classification value, providing business context for the assigned classification. For example, High-value strategic account for ABC-A, or Dual-use item requiring export license for an ECCN code.',
    `classification_language` STRING COMMENT 'The ISO 639-1 two-letter language code in which the classification description and value are maintained. Supports multi-language classification management for multinational operations.. Valid values are `^[A-Z]{2}$`',
    `classification_priority` STRING COMMENT 'A numeric priority rank assigned to the classification record when multiple classifications of the same type exist for a customer account. Lower numbers indicate higher priority. Used to resolve conflicts when multiple classifications apply simultaneously.. Valid values are `^[1-9][0-9]*$`',
    `classification_scheme` STRING COMMENT 'The formal scheme, standard, or framework under which the classification value is defined. Examples include SAP ABC Analysis, Nielsen Global Segment Framework, US EAR Export Control, EU Dual-Use Regulation, or a company-defined internal scheme.',
    `classification_type` STRING COMMENT 'The category or scheme of classification applied to the customer account. Examples include ABC classification (revenue-based segmentation), Nielsen classification (market research segmentation), ECCN (Export Control Classification Number), EAR99 (Export Administration Regulations catch-all), industry sector, credit risk tier, and strategic account classification.. Valid values are `ABC|Nielsen|ECCN|EAR99|Industry Sector|Customer Segment|Credit Risk|Revenue Tier|Strategic|Regulatory|Export Control|Tax|Compliance|Custom`',
    `classification_value` STRING COMMENT 'The specific classification value or code assigned to the customer account under the given classification type. For example, A, B, or C for ABC classification; an ECCN code such as 3A001 for export control; or a Nielsen segment code.',
    `country_of_application` STRING COMMENT 'The ISO 3166-1 alpha-3 country code indicating the country or jurisdiction in which this classification is applicable. Supports country-specific classification rules, export control by destination, and regional compliance requirements.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the account classification record was first created in the system. Used for audit trail, data lineage, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_risk_class` STRING COMMENT 'The credit risk classification assigned to the customer account based on financial assessment, payment history, and creditworthiness. Drives credit limit setting, payment terms, and order release decisions in SAP S/4HANA FI/SD.. Valid values are `Low|Medium|High|Very High|Blocked|Under Review`',
    `customer_account_group` STRING COMMENT 'The SAP S/4HANA customer account group code that determines the number range, field selection, and partner functions applicable to the customer master record. Examples include KUNA (domestic customers), KUNE (export customers), CPDL (one-time customers).',
    `denied_party_screen_date` DATE COMMENT 'The most recent date on which the customer account was screened against denied party and sanctions lists. Used to ensure screening is current and to schedule re-screening at required intervals.. Valid values are `^d{4}-d{2}-d{2}$`',
    `denied_party_screen_result` STRING COMMENT 'The outcome of the most recent denied party and sanctions screening for the customer account. clear indicates no match found; match_found triggers a compliance hold; potential_match requires manual review.. Valid values are `clear|match_found|potential_match|pending|not_screened`',
    `denied_party_screened` BOOLEAN COMMENT 'Indicates whether the customer account has been screened against denied party, debarred, and sanctioned entity lists (e.g., US BIS Denied Persons List, OFAC SDN List, EU Consolidated Sanctions List). True = screening has been performed.. Valid values are `true|false`',
    `ear99_flag` BOOLEAN COMMENT 'Indicates whether the customer account has been classified as EAR99 under the US Export Administration Regulations, meaning the associated goods or transactions do not require a specific export license for most destinations. True = EAR99 classification applies.. Valid values are `true|false`',
    `eccn_code` STRING COMMENT 'The Export Control Classification Number (ECCN) assigned to the customer account for export control screening purposes. Identifies whether the customer or their end-use requires an export license under the US Export Administration Regulations (EAR). Applicable for industrial manufacturing customers dealing in dual-use goods.. Valid values are `^[0-9][A-Z][0-9]{3}[a-z]?$`',
    `effective_date` DATE COMMENT 'The date from which the classification becomes operationally effective for pricing, reporting, and compliance purposes. May differ from the assigned date if the classification is pre-dated or post-dated.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'The date on which the classification expires and is no longer valid. Applicable for time-bound classifications such as export control licenses, credit risk ratings, and contractual tier assignments.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_license_required` BOOLEAN COMMENT 'Indicates whether an export license is required for transactions with this customer account based on their export control classification, destination country, and end-use. Drives export compliance screening workflows.. Valid values are `true|false`',
    `industry_sector_code` STRING COMMENT 'The industry sector classification code assigned to the customer account, aligned with standard industry classification systems such as NAICS, SIC, or NACE. Used for market segmentation, reporting, and targeted sales strategies.',
    `industry_sector_name` STRING COMMENT 'The human-readable name of the industry sector assigned to the customer account. Complements the industry sector code for reporting and analytics purposes.',
    `is_primary` BOOLEAN COMMENT 'Indicates whether this classification record is the primary or default classification for the given classification type on the customer account. True = this is the primary classification used in pricing and reporting when multiple classifications of the same type exist.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when the account classification record was most recently updated. Supports change tracking, data freshness monitoring, and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `pricing_group` STRING COMMENT 'The pricing group code assigned to the customer account in SAP S/4HANA SD, used to determine applicable pricing conditions, discount schedules, and surcharges. Links the customer to a specific pricing strategy.',
    `reach_rohs_compliant` BOOLEAN COMMENT 'Indicates whether the customer account has confirmed compliance with EU REACH (Registration, Evaluation, Authorisation and Restriction of Chemicals) and RoHS (Restriction of Hazardous Substances) regulations. Relevant for industrial manufacturing customers in the EU market.. Valid values are `true|false`',
    `revenue_tier` STRING COMMENT 'The revenue-based tier assigned to the customer account, used for pricing, discount eligibility, and service level differentiation. Platinum and Gold tiers typically receive preferential pricing and dedicated account management.. Valid values are `Platinum|Gold|Silver|Bronze|Standard`',
    `review_date` DATE COMMENT 'The scheduled date for the next periodic review of the classification. Ensures classifications remain current and accurate, particularly for credit risk, export control, and strategic account tiers.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sales_district` STRING COMMENT 'The sales district code assigned to the customer account in SAP S/4HANA SD, representing the geographic or organizational sales territory. Used for sales reporting, territory management, and commission calculations.',
    `sales_office` STRING COMMENT 'The sales office code associated with the customer account in SAP S/4HANA SD, representing the organizational unit responsible for managing the account. Used for sales reporting and organizational assignment.',
    `source_system` STRING COMMENT 'The originating operational system from which the classification record was sourced. Supports data lineage tracking and reconciliation between SAP S/4HANA SD, Salesforce CRM, and other systems of record.. Valid values are `SAP_S4HANA|Salesforce_CRM|SAP_Ariba|Manual|External_Agency|ERP|CRM`',
    `source_system_record_code` STRING COMMENT 'The unique identifier of the classification record in the originating source system (e.g., SAP S/4HANA customer classification key, Salesforce record ID). Enables traceability and reconciliation back to the system of record.',
    `status` STRING COMMENT 'Current lifecycle status of the account classification record. Indicates whether the classification is currently active and in use, pending review, expired, or superseded by a newer classification.. Valid values are `active|inactive|pending_review|expired|superseded|under_review`',
    `tax_classification` STRING COMMENT 'The tax classification assigned to the customer account, determining the applicable tax treatment for sales transactions. Drives VAT/GST determination in SAP S/4HANA SD and ensures compliance with local tax regulations.. Valid values are `Taxable|Tax Exempt|Zero Rated|Reduced Rate|Not Applicable`',
    `tax_exemption_number` STRING COMMENT 'The official tax exemption certificate number issued by the relevant tax authority, confirming the customer accounts exemption from applicable taxes. Required for compliance and audit purposes.',
    CONSTRAINT pk_account_classification PRIMARY KEY(`account_classification_id`)
) COMMENT 'Stores multi-dimensional classification attributes for customer accounts used in pricing, reporting, and compliance. Captures classification type (e.g., ABC classification, Nielsen classification, export control classification, industry sector), classification value, classification scheme, assigned date, and assigning user. Supports SAP S/4HANA customer classification and export control screening (ECCN, EAR99).';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` (
    `sales_area_assignment_id` BIGINT COMMENT 'Unique surrogate identifier for each sales area assignment record linking a customer account to a specific SAP S/4HANA sales area combination (Sales Organization, Distribution Channel, Division).',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Sales area assignments map customer accounts to specific SAP S/4HANA sales areas (Sales Organization, Distribution Channel, Division). This FK establishes which account the sales area configuration be',
    `account_assignment_group` STRING COMMENT 'SAP Account Assignment Group for the customer, used in revenue account determination to map sales transactions to the correct general ledger (GL) revenue accounts during billing (e.g., 01=Domestic Revenue, 02=Export Revenue, 03=Service Revenue).. Valid values are `^[A-Z0-9]{1,2}$`',
    `authorization_group` STRING COMMENT 'SAP Authorization Group code controlling which user roles and organizational units are permitted to view or modify this customers sales area data. Enforces data access governance and segregation of duties.. Valid values are `^[A-Z0-9]{1,4}$`',
    `billing_block_code` STRING COMMENT 'SAP Billing Block code indicating whether billing is currently blocked for this customer in this sales area and the reason (e.g., 01=Credit Block, 02=Dispute, 03=Audit Hold). A blank value indicates no billing block is active.. Valid values are `^[A-Z0-9 ]{1,2}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this sales area assignment record was first created in the source system (SAP S/4HANA). Used for audit trail, data lineage tracking, and compliance with data governance policies.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code defining the default transaction currency for orders placed by this customer in this sales area (e.g., USD, EUR, GBP, JPY). Used in pricing determination and financial document posting.. Valid values are `^[A-Z]{3}$`',
    `customer_classification` STRING COMMENT 'SAP Customer Classification code used for statistical analysis and ABC segmentation of customers by revenue contribution within this sales area (e.g., A=High Value, B=Medium Value, C=Low Value). Supports strategic account management.. Valid values are `^[A-Z0-9]{1,2}$`',
    `customer_group_code` STRING COMMENT 'SAP Customer Group code classifying the customer for pricing, reporting, and statistical purposes within this sales area (e.g., 01=OEM, 02=System Integrator, 03=Distributor, 04=End User, 05=Government). Used in pricing condition determination.. Valid values are `^[A-Z0-9]{1,2}$`',
    `customer_group_name` STRING COMMENT 'Descriptive name of the customer group classification (e.g., OEM Partner, System Integrator, Distributor, End User) for business reporting and segmentation analysis.',
    `delivery_block_code` STRING COMMENT 'SAP Delivery Block code indicating whether outbound deliveries are currently blocked for this customer in this sales area and the reason (e.g., 01=Credit Limit Exceeded, 02=Export License Pending). A blank value indicates no delivery block.. Valid values are `^[A-Z0-9 ]{1,2}$`',
    `delivery_priority` STRING COMMENT 'SAP Delivery Priority code assigned to this customer in this sales area, controlling the sequence in which deliveries are processed during outbound logistics (e.g., 01=Urgent, 02=Normal, 03=Low). Impacts warehouse scheduling and shipping lead times.. Valid values are `^[0-9]{1,2}$`',
    `distribution_channel_code` STRING COMMENT 'SAP Distribution Channel code defining the route through which products and services reach the customer (e.g., 10=Direct Sales, 20=Distributor, 30=OEM, 40=E-Commerce). Governs pricing conditions and order processing rules.. Valid values are `^[A-Z0-9]{1,2}$`',
    `distribution_channel_name` STRING COMMENT 'Descriptive name of the distribution channel (e.g., Direct Sales, Distributor, OEM Partner, E-Commerce) for reporting and business user clarity.',
    `division_code` STRING COMMENT 'SAP Division code representing the product line or business segment assigned to this customer in this sales area (e.g., 01=Automation Systems, 02=Electrification, 03=Smart Infrastructure). Determines which product catalog and pricing conditions apply.. Valid values are `^[A-Z0-9]{1,2}$`',
    `division_name` STRING COMMENT 'Descriptive name of the division (product line or business segment) for reporting and analytics (e.g., Automation Systems, Electrification Solutions, Smart Infrastructure).',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms) code defining the default delivery terms and risk transfer point for orders placed by this customer in this sales area (e.g., EXW, FCA, DAP, DDP). Governs freight cost allocation and export documentation.. Valid values are `^(EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF)$`',
    `incoterms_location` STRING COMMENT 'Named place or port associated with the Incoterms code specifying the exact point of delivery or risk transfer (e.g., Chicago Port, Customer Warehouse Frankfurt). Required for complete Incoterms specification per ICC 2020 rules.',
    `invoice_dates_code` STRING COMMENT 'SAP Invoice Dates (billing schedule) code defining the default billing frequency or calendar for this customer in this sales area (e.g., monthly billing, weekly billing, milestone billing). Controls when billing documents are created.. Valid values are `^[A-Z0-9]{1,2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when this sales area assignment record was most recently updated in the source system. Supports change tracking, delta processing in the Databricks Silver Layer pipeline, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `max_partial_deliveries` STRING COMMENT 'Maximum number of partial deliveries allowed per sales order for this customer in this sales area. Limits the number of shipment splits permitted, balancing customer flexibility with logistics cost control.. Valid values are `^[0-9]{1,2}$`',
    `order_block_code` STRING COMMENT 'SAP Order Block code indicating whether new sales orders are currently blocked for this customer in this sales area and the reason (e.g., 01=Credit Hold, 02=Sanctions Review, 03=Contract Expired). A blank value indicates no order block is active.. Valid values are `^[A-Z0-9 ]{1,2}$`',
    `order_combination_flag` BOOLEAN COMMENT 'Indicates whether multiple open sales orders for this customer in this sales area can be combined into a single delivery document. When True, SAP SD will attempt to consolidate orders into one shipment to reduce freight costs and improve logistics efficiency.. Valid values are `true|false`',
    `order_probability_pct` DECIMAL(18,2) COMMENT 'Default probability percentage (0-100%) that a sales quotation or inquiry from this customer in this sales area will convert to a confirmed sales order. Used in sales pipeline forecasting and opportunity management.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `partial_delivery_flag` STRING COMMENT 'SAP Partial Delivery indicator controlling whether partial deliveries are permitted for this customer in this sales area (e.g., A=Partial delivery allowed, B=Only complete delivery, C=Partial delivery per item). Governs order fulfillment behavior.. Valid values are `^[A-Z]$`',
    `payment_terms_code` STRING COMMENT 'SAP Payment Terms code defining the default payment conditions for this customer in this sales area (e.g., NT30=Net 30 Days, 2/10NT30=2% discount if paid within 10 days net 30). Copied to sales orders and billing documents.. Valid values are `^[A-Z0-9]{1,4}$`',
    `price_list_type` STRING COMMENT 'SAP Price List Type code determining which price list applies to this customer in this sales area (e.g., 01=Standard List Price, 02=OEM Price, 03=Distributor Price, 04=Contract Price). Drives pricing condition record determination in SAP SD.. Valid values are `^[A-Z0-9]{1,2}$`',
    `pricing_procedure` STRING COMMENT 'SAP Pricing Procedure code assigned to this customer-sales area combination, defining the sequence of condition types (base price, discounts, surcharges, taxes) applied during sales order pricing determination.. Valid values are `^[A-Z0-9]{1,6}$`',
    `rebate_eligible_flag` BOOLEAN COMMENT 'Indicates whether this customer is eligible to participate in rebate agreements within this sales area. When True, SAP SD will process rebate accruals and settlements for qualifying transactions per the applicable rebate agreement.. Valid values are `true|false`',
    `sales_district_code` STRING COMMENT 'SAP Sales District code grouping customers into geographic or market-based territories within the sales organization for territory management, sales rep assignment, and regional performance reporting.. Valid values are `^[A-Z0-9]{1,6}$`',
    `sales_group_code` STRING COMMENT 'SAP Sales Group code identifying the team or group of sales representatives within the sales office responsible for this customer account. Enables granular sales performance tracking at team level.. Valid values are `^[A-Z0-9]{1,3}$`',
    `sales_office_code` STRING COMMENT 'SAP Sales Office code identifying the regional sales office responsible for managing this customer account within the sales organization. Used for organizational reporting and sales performance analysis.. Valid values are `^[A-Z0-9]{1,4}$`',
    `sales_org_code` STRING COMMENT 'SAP Sales Organization code representing the legal entity or business unit responsible for selling products and services. Determines pricing, order processing, and revenue booking. Typically a 4-character alphanumeric code in SAP S/4HANA (e.g., US01, DE01).. Valid values are `^[A-Z0-9]{1,4}$`',
    `sales_org_name` STRING COMMENT 'Descriptive name of the sales organization associated with this assignment, providing human-readable context for reporting and analytics (e.g., North America Industrial Sales).',
    `shipping_condition` STRING COMMENT 'SAP Shipping Condition code defining the default mode and urgency of shipment for this customer in this sales area (e.g., 01=Standard Ground, 02=Express Air, 03=Sea Freight, 04=Customer Pickup). Used in route and shipping point determination.. Valid values are `^[A-Z0-9]{1,2}$`',
    `source_record_key` STRING COMMENT 'Natural composite key from the source SAP S/4HANA system uniquely identifying this record in the originating system (typically concatenation of Customer Number + Sales Org + Distribution Channel + Division, e.g., C0001234-US01-10-01). Enables traceability back to the source system.',
    `source_system_code` STRING COMMENT 'Identifier of the operational source system from which this sales area assignment record originated (e.g., SAP_S4H_PROD, SAP_S4H_EU). Supports multi-system data lineage tracking in the Databricks Lakehouse Silver Layer for multinational deployments.. Valid values are `^[A-Z0-9_]{1,20}$`',
    `status` STRING COMMENT 'Current operational status of this customer sales area assignment record. active indicates the assignment is valid and orders can be processed; inactive indicates the assignment has been deactivated; blocked indicates a temporary hold; pending_review indicates the assignment is under compliance or credit review.. Valid values are `active|inactive|blocked|pending_review`',
    `valid_from_date` DATE COMMENT 'Date from which this sales area assignment becomes effective and the customer is authorized to place orders within this sales area. Used for time-bounded customer-sales area relationships and contract period management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'Date on which this sales area assignment expires and the customer is no longer authorized to place orders within this sales area. A null or far-future date (e.g., 9999-12-31) indicates an open-ended assignment with no planned expiry.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_sales_area_assignment PRIMARY KEY(`sales_area_assignment_id`)
) COMMENT 'Maps customer accounts to specific SAP S/4HANA sales areas (Sales Organization, Distribution Channel, Division) defining which products and pricing conditions apply to each customer in each sales area. Captures sales organization code, distribution channel, division, customer group, price list type, incoterms, delivery priority, and order combination flag. Foundational for order management and pricing determination.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` (
    `pricing_agreement_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying a customer pricing agreement record in the Silver Layer lakehouse. Serves as the primary key for all downstream joins and lineage tracking.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Pricing agreements are negotiated with specific customer accounts (key accounts, OEM partners, distributors). This FK establishes the fundamental ownership relationship. No existing FK exists. No safe',
    `product_price_list_id` BIGINT COMMENT 'Foreign key linking to product.price_list. Business justification: Customer-specific pricing agreements reference standard or custom price lists. Order management systems use this to apply correct negotiated pricing when customers place orders.',
    `segment_id` BIGINT COMMENT 'Foreign key linking to customer.customer_segment. Business justification: The pricing_agreement table contains a denormalized customer_segment STRING field referencing the customer_segment reference table. Pricing agreements can be segment-level (applying to all accounts in',
    `tax_code_id` BIGINT COMMENT 'Foreign key linking to finance.tax_code. Business justification: Pricing agreements reference specific tax codes to calculate correct tax amounts during order processing and invoicing. Sales and billing teams use this for every customer transaction.',
    `agreement_name` STRING COMMENT 'Descriptive name or title of the pricing agreement as referenced in commercial negotiations, e.g., OEM Partner Annual Volume Discount 2024 or Key Account Special Price – Automation Division.',
    `agreement_number` STRING COMMENT 'Business-facing unique identifier for the pricing agreement, typically sourced from SAP S/4HANA SD condition record key or CRM contract number. Used for cross-system reference and customer-facing communication.. Valid values are `^PA-[0-9]{4}-[0-9]{6}$`',
    `agreement_type` STRING COMMENT 'Classification of the pricing arrangement. Determines the pricing logic applied in SAP S/4HANA condition records: customer-specific price (fixed net price), volume rebate (retroactive rebate based on cumulative spend), special discount (percentage or absolute deduction), or other commercial pricing constructs.. Valid values are `customer_specific_price|volume_rebate|special_discount|trade_promotion|contract_price|list_price_override|freight_allowance`',
    `approval_status` STRING COMMENT 'The current approval workflow status of the pricing agreement. Tracks whether the agreement has been reviewed and authorized by the required approving authority before activation in SAP S/4HANA condition records.. Valid values are `pending|approved|rejected|escalated|withdrawn`',
    `approved_by` STRING COMMENT 'Name or employee identifier of the individual or role who granted final approval for this pricing agreement. Typically a Sales Director, VP of Sales, or Pricing Manager depending on the discount threshold and customer tier.',
    `approved_timestamp` TIMESTAMP COMMENT 'The date and time when the pricing agreement was formally approved by the authorized approver. Used for audit trail, compliance reporting, and SLA tracking of the pricing approval process.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `approving_authority_level` STRING COMMENT 'The organizational authority level required to approve this pricing agreement, determined by the discount depth or deal value. Enforces the pricing governance matrix — e.g., discounts above 20% require VP Sales approval, above 30% require CFO sign-off.. Valid values are `sales_rep|sales_manager|regional_director|vp_sales|cfo|executive_committee`',
    `commercial_contract_reference` STRING COMMENT 'Reference number or identifier of the overarching commercial contract, master service agreement, or framework agreement to which this pricing agreement is linked. Enables traceability between pricing conditions and legal contract documents.',
    `condition_type_code` STRING COMMENT 'The SAP S/4HANA SD condition type code (e.g., PR00 for base price, K007 for customer discount, BO01 for rebate) that this pricing agreement maps to in the condition record. Essential for ERP integration and pricing procedure determination.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where this pricing agreement is applicable. Supports regional pricing strategies, export compliance, and multi-country reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when the pricing agreement record was first created in the source system (SAP S/4HANA or Salesforce CRM). Used for audit trail, data lineage, and SLA compliance tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the agreed price, discount, and rebate values are denominated. Supports multi-currency operations across global customer accounts (e.g., USD, EUR, GBP, JPY, CNY).. Valid values are `^[A-Z]{3}$`',
    `discount_percentage` DECIMAL(18,2) COMMENT 'The negotiated percentage discount to be applied off the standard list price or base price. Applicable when agreement_type is special_discount or volume_rebate. Expressed as a percentage value (e.g., 12.5 = 12.5%). Null when the agreement is fixed-price based.. Valid values are `^(100(.0{1,4})?|[0-9]{1,2}(.[0-9]{1,4})?)$`',
    `distribution_channel` STRING COMMENT 'The SAP S/4HANA distribution channel through which the products covered by this pricing agreement are sold. Determines the applicable pricing condition table and access sequence. Examples: direct sales, distributor, OEM, export.. Valid values are `direct|distributor|oem|online|retail|export`',
    `division` STRING COMMENT 'The SAP S/4HANA division (product line or business unit) to which this pricing agreement applies. Used in condition record key determination and supports divisional P&L reporting for pricing analytics.',
    `incoterms` STRING COMMENT 'International Commercial Terms (Incoterms 2020) defining the delivery obligations, risk transfer point, and cost responsibilities between seller and buyer under this pricing agreement. Affects the net price calculation and logistics cost allocation.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `is_exclusive` BOOLEAN COMMENT 'Indicates whether this pricing agreement grants the customer exclusive pricing rights for the covered product or product group within a defined territory or channel. Exclusive agreements restrict the same pricing from being offered to competing customers.. Valid values are `true|false`',
    `is_retroactive` BOOLEAN COMMENT 'Indicates whether the pricing agreement terms apply retroactively to orders placed before the agreement was formally activated. Relevant for volume rebate agreements where retroactive settlement is triggered upon reaching the target volume.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when the pricing agreement record was most recently updated in the source system. Supports incremental data loading in the Databricks Silver Layer and change data capture (CDC) processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'The minimum quantity the customer must order per transaction or within the agreement period to qualify for the agreed pricing. Expressed in the price_unit. A key commercial condition for volume-based and OEM pricing agreements.',
    `minimum_order_value` DECIMAL(18,2) COMMENT 'The minimum monetary value of an order or cumulative period spend required to activate or maintain the pricing agreement. Expressed in currency_code. Used for value-based volume rebate thresholds and key account agreements.',
    `payment_terms_code` STRING COMMENT 'The payment terms code associated with this pricing agreement, referencing the standard payment terms defined in SAP S/4HANA FI (e.g., NT30 for net 30 days, 2/10NT30 for 2% discount if paid within 10 days). Linked to the customers credit and commercial terms.',
    `price_list_type` STRING COMMENT 'The price list category from which the base price is derived before applying the agreed discount or special price. Determines the reference price point for discount calculation in SAP S/4HANA condition records.. Valid values are `standard|oem|distributor|export|intercompany|promotional`',
    `price_per_quantity` DECIMAL(18,2) COMMENT 'The quantity denominator for the agreed price, i.e., the number of units to which the agreed_price applies. For example, a price of $500 per 100 pieces would have price_per_quantity = 100. Aligns with SAP S/4HANA condition record pricing quantity (KPEIN).',
    `rebate_percentage` DECIMAL(18,2) COMMENT 'The retroactive rebate percentage applied to cumulative purchases once the minimum order quantity or revenue threshold is met within the agreement validity period. Applicable for volume_rebate agreement types. Expressed as a percentage (e.g., 3.0 = 3%).. Valid values are `^(100(.0{1,4})?|[0-9]{1,2}(.[0-9]{1,4})?)$`',
    `renewal_type` STRING COMMENT 'Defines the renewal behavior of the pricing agreement upon expiry. auto_renew triggers automatic extension under the same terms; manual_renew requires explicit renegotiation; no_renewal means the agreement terminates at valid_to.. Valid values are `auto_renew|manual_renew|no_renewal`',
    `sales_organization` STRING COMMENT 'The SAP S/4HANA sales organization code responsible for this pricing agreement. Defines the legal selling entity and regional sales structure under which the agreement is managed. Critical for multi-country and multi-entity operations.',
    `scope_type` STRING COMMENT 'Defines whether the pricing agreement applies to a single product (SKU), a product group, a material group, a product hierarchy node, or all products. Determines the granularity of condition record creation in SAP S/4HANA.. Valid values are `single_product|product_group|material_group|product_hierarchy|all_products`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this pricing agreement record originated. Supports data lineage, reconciliation between SAP S/4HANA condition records and Salesforce CRM contract objects, and Silver Layer audit requirements.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL`',
    `status` STRING COMMENT 'Current lifecycle status of the pricing agreement. Controls whether the agreement is eligible to be applied to sales orders in SAP S/4HANA. Superseded indicates a newer version has replaced this agreement.. Valid values are `draft|pending_approval|active|expired|suspended|cancelled|superseded`',
    `superseded_by_agreement` STRING COMMENT 'The agreement_number of the newer pricing agreement that has replaced this one when status is superseded. Provides forward linkage for agreement lineage tracking and ensures sales teams reference the current active agreement.',
    `target_volume` DECIMAL(18,2) COMMENT 'The agreed annual or period target purchase volume (in price_unit) that the customer commits to purchasing under this pricing agreement. Used for volume rebate tracking and commercial performance monitoring.',
    `version_number` STRING COMMENT 'Sequential version number of the pricing agreement, incremented each time the agreement is renegotiated or amended. Enables version history tracking and audit trail for pricing governance and compliance reviews.. Valid values are `^[1-9][0-9]*$`',
    `valid_from` DATE COMMENT 'The start date from which the pricing agreement becomes effective and eligible to be applied to sales orders. Aligns with SAP S/4HANA condition record validity start date (DATAB). Inclusive boundary.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to` DATE COMMENT 'The end date after which the pricing agreement is no longer effective. Aligns with SAP S/4HANA condition record validity end date (DATBI). Inclusive boundary. Agreements with no end date may use 9999-12-31 as a convention.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_pricing_agreement PRIMARY KEY(`pricing_agreement_id`)
) COMMENT 'Customer-specific pricing agreements and special price arrangements negotiated with key accounts, OEM partners, and distributors. Captures agreement type (customer-specific price, volume rebate, special discount), product or product group scope, agreed price or discount percentage, minimum order quantity, validity period, approval status, approving authority, and linked commercial contract reference. Feeds SAP S/4HANA condition records.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`interaction` (
    `interaction_id` BIGINT COMMENT 'Unique system-generated identifier for each customer interaction record. Serves as the primary key for the interaction data product and enables cross-system traceability.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Interactions are customer touchpoints with specific accounts. This FK is the fundamental CRM relationship. account_name and account_segment are denormalized — account_name is retrieved via JOIN to acc',
    `case_id` BIGINT COMMENT 'Foreign key linking to customer.case. Business justification: Interactions can be linked to service cases (e.g., a support call related to a case). The interaction table has a case_number STRING field that is a denormalized reference to the case. Normalizing to ',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: Interactions are with specific contact persons. This FK links the interaction to the individual contact record. contact_name and contact_title are denormalized — retrievable via JOIN to contact.first_',
    `customer_opportunity_id` BIGINT COMMENT 'Foreign key linking to customer.opportunity. Business justification: Interactions are often linked to sales opportunities (e.g., a sales call related to an opportunity). The interaction table has an opportunity_name STRING field that is a denormalized reference to the ',
    `assigned_representative_email` STRING COMMENT 'Corporate email address of the internal representative assigned to the interaction. Used for routing, notifications, and audit trail. Internal employee email classified as confidential.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `assigned_representative_name` STRING COMMENT 'Full name of the internal sales or service representative responsible for conducting and recording the interaction. Sourced from Salesforce CRM user assignment on the Activity or Event record.',
    `assigned_representative_role` STRING COMMENT 'Job role or function of the internal representative assigned to the interaction. Enables analysis of engagement patterns by role type and supports workforce planning.. Valid values are `account_executive|sales_engineer|field_service_engineer|customer_success_manager|technical_sales_specialist|regional_sales_manager|service_technician|other`',
    `campaign_name` STRING COMMENT 'Name of the marketing campaign that generated or is associated with this interaction (e.g., trade show, webinar series, product launch event). Enables marketing attribution and ROI analysis.',
    `channel` STRING COMMENT 'The communication medium or channel through which the customer interaction was conducted (e.g., phone, email, in-person, virtual). Supports omnichannel engagement analytics.. Valid values are `phone|email|in_person|virtual|web|chat|social_media|postal|other`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the interaction record was first created in the source system. Used for audit trail, data freshness monitoring, and compliance with record-keeping obligations.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `date` DATE COMMENT 'The calendar date on which the customer interaction occurred or is scheduled to occur. Used for time-series reporting, SLA tracking, and sales cadence analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `description` STRING COMMENT 'Free-text narrative capturing the details, discussion points, and context of the customer interaction. Corresponds to the Description or Comments field in Salesforce CRM Activity records.',
    `direction` STRING COMMENT 'Indicates whether the interaction was initiated by the customer (inbound) or by the companys sales or service representative (outbound). Used for engagement pattern analysis.. Valid values are `inbound|outbound`',
    `duration_minutes` STRING COMMENT 'Recorded or system-calculated duration of the interaction in minutes. Captured directly from the CRM event record. Used for engagement depth analysis and representative productivity reporting.. Valid values are `^[0-9]+$`',
    `end_timestamp` TIMESTAMP COMMENT 'Precise date and time when the customer interaction concluded. Combined with start_timestamp to derive actual interaction duration for SLA and engagement analytics.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `external_reference_code` STRING COMMENT 'Source system identifier for the interaction record as assigned by the originating system (e.g., Salesforce Activity ID or Event ID). Enables lineage tracing back to the system of record.',
    `is_escalated` BOOLEAN COMMENT 'Indicates whether the interaction involved or resulted in an escalation to a higher-level representative, management, or executive team. Used for escalation rate KPI reporting and service quality monitoring.. Valid values are `true|false`',
    `is_logged_in_crm` BOOLEAN COMMENT 'Indicates whether the interaction has been formally logged and confirmed in the Salesforce CRM system. Supports data completeness auditing and sales representative compliance monitoring.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'ISO 639-1 or BCP 47 language code representing the primary language used during the interaction (e.g., en, de, zh-CN). Supports multilingual engagement analytics for global operations.. Valid values are `^[a-z]{2,3}(-[A-Z]{2,3})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the interaction record in the source system. Supports incremental data loading, change detection, and audit trail requirements in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `location_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the location where the interaction occurred. Supports geographic segmentation, regional sales reporting, and compliance with data residency requirements.. Valid values are `^[A-Z]{3}$`',
    `location_name` STRING COMMENT 'Name or description of the physical or virtual location where the interaction took place (e.g., Hannover Messe 2024, Customer Plant – Stuttgart, Microsoft Teams). Relevant for in-person and event-based interactions.',
    `next_action` STRING COMMENT 'Description of the agreed-upon or planned follow-up action resulting from the interaction (e.g., Send product specification sheet, Schedule factory tour, Submit revised RFQ). Drives sales and service follow-through.',
    `next_action_due_date` DATE COMMENT 'Target completion date for the follow-up action identified during the interaction. Used for task management, sales cadence enforcement, and SLA compliance monitoring.. Valid values are `^d{4}-d{2}-d{2}$`',
    `nps_score` STRING COMMENT 'Net Promoter Score (NPS) captured during or immediately following the interaction, on a 0–10 scale. Measures customer loyalty and likelihood to recommend. Applicable for post-interaction surveys tied to key touchpoints.. Valid values are `^([0-9]|10)$`',
    `outcome` STRING COMMENT 'The business result or disposition of the customer interaction as assessed by the assigned representative. Drives pipeline progression, opportunity creation, and service resolution tracking.. Valid values are `positive|neutral|negative|follow_up_required|opportunity_identified|deal_closed|issue_resolved|escalated|no_outcome`',
    `priority` STRING COMMENT 'Business priority level assigned to the interaction, reflecting urgency or strategic importance. Critical interactions may involve key accounts, escalations, or executive-level engagements.. Valid values are `low|medium|high|critical`',
    `product_line` STRING COMMENT 'The primary product line or solution portfolio discussed during the interaction (e.g., Automation Systems, Electrification Solutions, Smart Infrastructure). Enables product-level engagement and pipeline analytics.',
    `sentiment` STRING COMMENT 'Qualitative assessment of the customers sentiment or disposition during the interaction, as recorded by the representative. Supports customer health scoring and churn risk identification.. Valid values are `positive|neutral|negative|mixed|unknown`',
    `source_system` STRING COMMENT 'Identifies the originating operational system from which the interaction record was sourced (e.g., Salesforce CRM, SAP S/4HANA). Supports data lineage, reconciliation, and audit trail requirements.. Valid values are `salesforce_crm|sap_s4hana|manual_entry|other`',
    `start_timestamp` TIMESTAMP COMMENT 'Precise date and time when the customer interaction began. Used for duration calculation, scheduling conflict detection, and time-zone-aware reporting across global operations.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `status` STRING COMMENT 'Current lifecycle status of the interaction record. Tracks whether the interaction has been completed, is pending, was cancelled, or requires rescheduling.. Valid values are `planned|in_progress|completed|cancelled|no_show|rescheduled`',
    `subject` STRING COMMENT 'Brief title or subject line summarizing the purpose of the customer interaction, as recorded in the CRM activity or event record (e.g., Q3 Product Demo – Automation Line, Follow-up on RFQ #4521).',
    `type` STRING COMMENT 'Classification of the customer interaction by its business nature or purpose. Drives segmentation, reporting, and sales pipeline analytics. Aligned with Salesforce CRM Activity Type taxonomy.. Valid values are `sales_call|site_visit|trade_show_meeting|webinar|product_demonstration|support_escalation|email|phone_call|virtual_meeting|partner_review|executive_briefing|field_service_visit|other`',
    CONSTRAINT pk_interaction PRIMARY KEY(`interaction_id`)
) COMMENT 'Records of all customer touchpoints and engagement activities across channels, including sales calls, site visits, trade show meetings, webinar attendance, product demonstrations, and support escalations. Captures interaction type, channel (phone, email, in-person, virtual), interaction date, duration, outcome, next action, assigned sales/service representative, and linked account and contact. Sourced from Salesforce CRM Activity and Event objects.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` (
    `customer_opportunity_id` BIGINT COMMENT 'Unique system-generated identifier for the sales opportunity record within the enterprise data platform. Serves as the primary key for all downstream joins and lineage tracking.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Sales opportunities are associated with specific customer accounts. This FK is the fundamental CRM relationship enabling account-level pipeline reporting. account_name is a denormalized field retrieva',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Sales opportunities track which products are being quoted/proposed. Sales teams need product specifications, pricing, and availability to develop proposals and forecast revenue by product line.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Sales opportunities for equipment upgrades, replacements, or service contracts reference existing customer equipment. Sales teams use this for upsell and renewal opportunities.',
    `product_variant_id` BIGINT COMMENT 'Foreign key linking to engineering.product_variant. Business justification: Sales opportunities specify which product variants customers are interested in purchasing. Sales teams need engineering variant specifications for technical proposals, feasibility assessment, and accu',
    `segment_id` BIGINT COMMENT 'Foreign key linking to customer.customer_segment. Business justification: The opportunity table contains a denormalized customer_segment STRING field referencing the customer_segment reference table. Normalizing to a FK ensures referential integrity and enables segment-leve',
    `account_executive` STRING COMMENT 'Full name of the account executive (field sales representative) who owns and is responsible for progressing this opportunity. Used for quota tracking, commission calculation, and sales performance reporting.',
    `actual_close_date` DATE COMMENT 'The actual date on which the opportunity was closed (either won or lost). Populated upon stage transition to closed_won or closed_lost. Used for sales cycle analysis and forecast accuracy measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `competitor_names` STRING COMMENT 'Comma-separated list of known competitors being evaluated by the customer for this opportunity (e.g., ABB, Rockwell Automation, Schneider Electric). Used for competitive intelligence, win/loss analysis, and sales strategy development.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customers primary location for this opportunity (e.g., USA, DEU, CHN). Used for geographic pipeline analysis, regulatory compliance, and export control screening.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the opportunity record was first created in the source CRM system. Used for pipeline aging analysis, audit trail, and data lineage in the silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `crm_opportunity_number` STRING COMMENT 'External opportunity reference number as assigned by Salesforce CRM (e.g., 0060X00000XXXXX). Used for cross-system traceability between the lakehouse silver layer and the CRM source system.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the opportunitys estimated revenue and financial values (e.g., USD, EUR, GBP, JPY). Supports multi-currency pipeline reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `deal_size_category` STRING COMMENT 'Categorical classification of the opportunity by deal size (e.g., Small <$100K, Medium $100K–$1M, Large $1M–$10M, Strategic >$10M). Used for resource allocation, approval routing, and executive pipeline review segmentation.. Valid values are `small|medium|large|strategic`',
    `erp_quotation_number` STRING COMMENT 'SAP S/4HANA SD quotation document number linked to this CRM opportunity. Enables cross-system traceability between the CRM pipeline record and the formal ERP quotation for order conversion tracking.',
    `estimated_revenue` DECIMAL(18,2) COMMENT 'Estimated total contract value or deal revenue in the transaction currency. Represents the gross revenue expected if the opportunity is won. Used for pipeline valuation, quota attainment tracking, and revenue forecasting.',
    `estimated_revenue_usd` DECIMAL(18,2) COMMENT 'Estimated revenue converted to US Dollars using the corporate exchange rate at the time of record creation or last update. Enables standardized global pipeline reporting and cross-regional revenue comparison.',
    `expected_close_date` DATE COMMENT 'Target date by which the opportunity is expected to be closed (won or lost). Used for pipeline aging analysis, quarterly revenue forecasting, and sales cycle duration measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `fiscal_quarter` STRING COMMENT 'Fiscal quarter in which the opportunity is expected to close (e.g., Q3-2025). Used for quarterly revenue forecasting, quota attainment tracking, and financial planning alignment.. Valid values are `^Q[1-4]-d{4}$`',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the opportunity is expected to close (e.g., 2025). Used for annual revenue planning, budget alignment, and year-over-year pipeline comparison.. Valid values are `^d{4}$`',
    `forecast_category` STRING COMMENT 'Sales forecast category assigned to the opportunity, indicating the account executives confidence level for inclusion in revenue forecasts. Aligns with standard Salesforce CRM forecast categories used in quarterly business reviews.. Valid values are `pipeline|best_case|commit|closed|omitted`',
    `industry_vertical` STRING COMMENT 'The end-customers industry vertical for this opportunity. Used for vertical market analysis, industry-specific solution positioning, and market penetration reporting.. Valid values are `automotive|food_beverage|oil_gas|pharmaceuticals|utilities|mining|aerospace|logistics|building_automation|water_treatment|other`',
    `is_forecasted` BOOLEAN COMMENT 'Indicates whether the account executive has committed this opportunity to the current periods revenue forecast. Used to distinguish between pipeline opportunities and committed forecast entries in revenue planning.. Valid values are `true|false`',
    `is_strategic` BOOLEAN COMMENT 'Indicates whether this opportunity has been designated as strategically important by sales leadership (e.g., key account, new market entry, flagship reference customer). Strategic opportunities receive elevated executive attention and resource priority.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the opportunity record in the source CRM system. Used for incremental data ingestion, change detection, and audit trail maintenance in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lead_source` STRING COMMENT 'The originating channel or activity that generated this sales opportunity. Used for marketing attribution analysis, channel effectiveness measurement, and return on investment (ROI) reporting for demand generation programs.. Valid values are `inbound_web|trade_show|partner_referral|direct_sales|marketing_campaign|existing_account|cold_outreach|distributor|other`',
    `loss_reason` STRING COMMENT 'Categorized reason why the opportunity was lost, populated upon transition to closed_lost stage. Used for win/loss analysis, product gap identification, and sales process improvement initiatives.. Valid values are `price|competitor_product|no_decision|budget_cut|relationship|technical_fit|timeline|internal_build|other`',
    `loss_reason_detail` STRING COMMENT 'Free-text narrative providing additional context for the loss reason. Captures nuanced competitive or customer-specific factors not covered by the categorical loss_reason field. Used for qualitative win/loss analysis.',
    `name` STRING COMMENT 'Descriptive name of the sales opportunity, typically combining the account name, product line, and deal type (e.g., Acme Corp – Automation Line Upgrade Q3). Used for identification in CRM dashboards and pipeline reports.',
    `next_step` STRING COMMENT 'Free-text description of the immediate next action required to advance the opportunity to the next stage (e.g., Schedule technical demo, Submit formal proposal, Obtain budget approval). Used for sales activity management and pipeline review meetings.',
    `open_date` DATE COMMENT 'Date on which the opportunity was first created and entered into the CRM system. Used to calculate sales cycle length, pipeline aging, and time-to-close metrics.. Valid values are `^d{4}-d{2}-d{2}$`',
    `probability_percent` DECIMAL(18,2) COMMENT 'Estimated probability (0–100%) that the opportunity will be closed-won. Used to calculate weighted pipeline value for revenue forecasting. May be set manually by the account executive or auto-populated based on stage.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `product_family` STRING COMMENT 'Broader product family grouping above the product line level (e.g., Factory Automation, Building Technologies, Transportation Systems). Supports executive-level pipeline reporting by business unit.',
    `product_line` STRING COMMENT 'The primary product line or solution category the customer is interested in (e.g., Automation Systems, Electrification Solutions, Smart Infrastructure, Drive Technology, Industrial Software). Used for product-level pipeline analysis and capacity planning.',
    `proposal_submitted_date` DATE COMMENT 'Date on which the formal commercial proposal or quotation was submitted to the customer. Used for proposal-to-close cycle analysis and sales process milestone tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `rfq_reference` STRING COMMENT 'Customer-issued Request for Quotation (RFQ) or Request for Proposal (RFP) reference number associated with this opportunity. Links the CRM opportunity to the formal procurement event initiated by the customer.',
    `sales_cycle_days` STRING COMMENT 'Number of calendar days elapsed from the opportunity open date to the actual close date. Populated upon closure. Used for sales cycle benchmarking, process efficiency analysis, and forecasting model calibration.. Valid values are `^[0-9]+$`',
    `sales_manager` STRING COMMENT 'Full name of the sales manager responsible for supervising the account executive and approving deal terms for this opportunity. Used for management reporting and deal approval workflows.',
    `sales_region` STRING COMMENT 'Geographic sales region responsible for managing this opportunity (e.g., North America, EMEA, APAC, LATAM). Used for regional pipeline reporting, quota allocation, and territory management.',
    `sales_territory` STRING COMMENT 'Specific sales territory within the sales region assigned to this opportunity. Supports granular territory performance analysis and account coverage planning.',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this opportunity record was sourced (e.g., Salesforce CRM, SAP S/4HANA). Used for data lineage tracking and cross-system reconciliation in the lakehouse silver layer.. Valid values are `salesforce_crm|sap_s4hana|manual`',
    `stage` STRING COMMENT 'Current stage of the sales opportunity within the industrial sales pipeline lifecycle. Drives pipeline reporting, revenue forecasting, and sales process compliance. Stages align with the standard B2B industrial sales methodology.. Valid values are `prospecting|qualification|proposal|negotiation|closed_won|closed_lost`',
    `technical_presales_owner` STRING COMMENT 'Full name of the technical pre-sales engineer or solution architect supporting this opportunity. Responsible for technical qualification, solution design, and proof-of-concept activities in the industrial sales process.',
    `type` STRING COMMENT 'Classification of the opportunity by business development type. Distinguishes between net-new customer acquisition, expansion of existing accounts, contract renewals, and product upgrades. Critical for revenue mix analysis and go-to-market strategy.. Valid values are `new_business|existing_business_expansion|renewal|replacement|upgrade|cross_sell|upsell`',
    CONSTRAINT pk_customer_opportunity PRIMARY KEY(`customer_opportunity_id`)
) COMMENT 'Sales opportunity records tracking potential revenue from customer accounts across the industrial sales pipeline. Captures opportunity name, stage (prospecting, qualification, proposal, negotiation, closed-won, closed-lost), estimated revenue, probability percentage, expected close date, product line of interest, sales region, account executive, technical pre-sales owner, competitor landscape, and loss reason. Sourced from Salesforce CRM Opportunity.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`case` (
    `case_id` BIGINT COMMENT 'Unique surrogate identifier for each customer service and support case record in the lakehouse silver layer.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Service and support cases are raised by customer accounts. This FK is the fundamental CRM relationship linking cases to the account that raised them. No existing FK exists. No safe denormalized accoun',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Service cases document issues with specific products. Support teams need product details for troubleshooting, warranty validation, and tracking product quality issues across the installed base.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Customer support cases frequently relate to specific components for defects, failures, or technical issues. Linking cases to engineering components enables root cause analysis, quality feedback loops,',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: Cases are typically raised by a specific contact person at the customer account. This FK links the case to the individual contact, enabling contact-level case history and SLA tracking. No existing FK ',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Customer support cases often relate to specific equipment experiencing issues. Support teams need equipment details for troubleshooting, warranty validation, and service history.',
    `field_service_order_id` BIGINT COMMENT 'Foreign key linking to service.field_service_order. Business justification: Customer cases often escalate to field service orders when remote resolution fails. Support teams link cases to service orders for complete issue tracking.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Customer service cases often relate to specific sales orders for issues like delivery delays or quality problems. Support teams use this to investigate order-related complaints.',
    `serialized_unit_id` BIGINT COMMENT 'Foreign key linking to inventory.serialized_unit. Business justification: Service cases for industrial equipment reference specific serialized units to access service history, warranty status, and technical specifications. Critical for field service and technical support op',
    `service_ticket_id` BIGINT COMMENT 'Foreign key linking to technology.service_ticket. Business justification: Customer support cases often originate from IT/OT system issues requiring technical service tickets. Links customer-facing case management with backend technical resolution tracking. Service desk uses',
    `affected_quantity` STRING COMMENT 'Number of product units or components affected by the issue reported in the case. Used for impact assessment, warranty cost estimation, and field service resource planning.. Valid values are `^[1-9][0-9]*$`',
    `assigned_engineer` STRING COMMENT 'Name or identifier of the service engineer or support agent assigned as the primary owner of the case. Used for workload balancing, performance tracking, and customer communication.',
    `capa_reference_number` STRING COMMENT 'Reference number of the associated Corrective and Preventive Action (CAPA) record initiated as a result of this case. Links service cases to formal quality improvement actions in the Quality Management System (QMS).. Valid values are `^[A-Z0-9-]{5,30}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer site or installation location where the issue occurred. Supports regional service performance reporting and regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the case record was created in the lakehouse silver layer. Used for data lineage, audit trail, and incremental load tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `crm_case_code` STRING COMMENT 'Native case identifier from Salesforce Service Cloud (source system). Enables bidirectional traceability between the lakehouse silver layer record and the originating CRM case record.',
    `customer_satisfaction_score` DECIMAL(18,2) COMMENT 'Customer satisfaction rating provided by the customer after case resolution, typically on a 1–10 scale. Measures post-resolution service quality and feeds into Net Promoter Score (NPS) and service KPI dashboards.. Valid values are `^([0-9]|10)(.d{1,2})?$`',
    `description` STRING COMMENT 'Full narrative description of the customer issue, complaint, or request as reported. Captures the customers own words and initial context for the service team.',
    `escalation_flag` BOOLEAN COMMENT 'Indicates whether the case has been formally escalated to a higher support tier, management, or specialist team. True if escalated; False if handled at original assignment level.. Valid values are `true|false`',
    `escalation_reason` STRING COMMENT 'Categorized reason for case escalation, capturing why the case was elevated to a higher support tier. Supports root cause analysis of escalation patterns and service improvement initiatives.. Valid values are `sla_breach|customer_request|technical_complexity|management_directive|repeat_issue|safety_concern|regulatory_impact|other`',
    `escalation_timestamp` TIMESTAMP COMMENT 'Date and time when the case was formally escalated. Null if the case was never escalated. Used for escalation pattern analysis and management reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `first_response_timestamp` TIMESTAMP COMMENT 'Date and time when the service team provided the first substantive response to the customer after case creation. Used to measure first response time against SLA commitments.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `language_code` STRING COMMENT 'ISO 639-1 language code of the language used in the case communication (e.g., en, de, fr, zh-CN). Supports multilingual service operations and regional reporting for multinational customers.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the case record was last updated in the lakehouse silver layer. Used for change tracking, incremental processing, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `ncr_number` STRING COMMENT 'Reference number of the Non-Conformance Report (NCR) associated with this case, if the issue resulted in a formal non-conformance record. Links customer complaints to quality management processes.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `number` STRING COMMENT 'Human-readable, business-facing case reference number generated by Salesforce Service Cloud (e.g., CS-2024-00123). Used for customer communication and cross-system traceability.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `open_date` DATE COMMENT 'Calendar date on which the customer service case was officially opened and registered in the system. Used as the baseline for SLA elapsed time calculations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `open_timestamp` TIMESTAMP COMMENT 'Precise date and time when the case was created in Salesforce Service Cloud, including timezone offset. Used for exact SLA elapsed time measurement and audit trail.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `origin` STRING COMMENT 'Channel through which the customer case was originally submitted (e.g., phone, email, web portal, field service visit). Supports omnichannel service analytics and channel performance reporting.. Valid values are `phone|email|web_portal|field_service|chat|partner_portal|edi|manual_entry`',
    `priority` STRING COMMENT 'Business priority level assigned to the case, reflecting urgency and potential customer impact. Determines SLA tier and escalation thresholds for service engineers.. Valid values are `critical|high|medium|low`',
    `product_model_number` STRING COMMENT 'Model or part number of the product or component involved in the case. Used for product-level defect trend analysis, spare parts identification, and engineering change management.',
    `product_serial_number` STRING COMMENT 'Serial number of the specific product unit or equipment associated with the customer case. Enables traceability to manufacturing batch, installation site, and maintenance history.',
    `related_order_number` STRING COMMENT 'Sales order number from SAP S/4HANA SD associated with the case, linking the service issue to the originating customer order. Enables order-level complaint tracking and fulfillment quality analysis.. Valid values are `^[A-Z0-9-]{5,30}$`',
    `resolution_code` STRING COMMENT 'Standardized code categorizing the type of resolution applied to close the case. Enables structured reporting on resolution patterns and service cost analysis.. Valid values are `repaired|replaced|refunded|credited|configuration_change|software_patch|training_provided|no_fault_found|workaround_provided|escalated_to_engineering|warranty_replacement|other`',
    `resolution_date` DATE COMMENT 'Calendar date on which the customer issue was resolved and the case was marked as resolved. Used for SLA compliance reporting and resolution cycle time analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `resolution_description` STRING COMMENT 'Detailed narrative of the actions taken to resolve the customer issue, including steps performed, parts replaced, configuration changes, or guidance provided. Serves as institutional knowledge for recurring issues.',
    `resolution_timestamp` TIMESTAMP COMMENT 'Precise date and time when the case was resolved, including timezone offset. Enables exact SLA breach determination and resolution time measurement in hours and minutes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `root_cause_category` STRING COMMENT 'Categorized root cause of the customer issue as determined during case investigation. Feeds into Corrective and Preventive Action (CAPA) processes and quality improvement programs per ISO 9001.. Valid values are `design_defect|manufacturing_defect|installation_error|operator_error|software_bug|wear_and_tear|logistics_damage|documentation_error|supplier_defect|environmental_factor|unknown|other`',
    `service_team` STRING COMMENT 'Name of the service team or support queue responsible for handling the case (e.g., Tier 1 Support, Field Service EMEA, Warranty Claims Team). Supports team-level workload and performance reporting.',
    `sla_breach_flag` BOOLEAN COMMENT 'Indicates whether the case exceeded the contracted Service Level Agreement (SLA) response or resolution time. True if SLA was breached; False if resolved within SLA. Critical for SLA compliance reporting and customer penalty tracking.. Valid values are `true|false`',
    `sla_target_resolution_hours` DECIMAL(18,2) COMMENT 'Contracted SLA target resolution time in hours for this case, based on the case priority and customer contract tier. Used to determine SLA breach status and measure service performance.. Valid values are `^d{1,7}(.d{1,2})?$`',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this case record was sourced. Supports data lineage tracking and multi-system reconciliation in the lakehouse.. Valid values are `salesforce_service_cloud|sap_s4hana|maximo|manual`',
    `status` STRING COMMENT 'Current lifecycle status of the service case, tracking progression from initial submission through resolution and closure. Used for workload management and SLA compliance monitoring.. Valid values are `new|open|in_progress|pending_customer|pending_internal|escalated|resolved|closed|cancelled`',
    `subject` STRING COMMENT 'Short descriptive title or headline of the customer issue as entered by the customer or service agent. Used for quick identification and search in case management queues.',
    `type` STRING COMMENT 'Classification of the customer service case by the nature of the issue raised. Drives routing, SLA assignment, and reporting segmentation across post-sale support operations.. Valid values are `technical_issue|delivery_complaint|invoice_dispute|warranty_claim|field_service_request|product_defect|spare_parts_request|documentation_request|other`',
    `warranty_claim_flag` BOOLEAN COMMENT 'Indicates whether the case involves a warranty claim against a product or component. True if the case is a warranty claim; False otherwise. Drives warranty cost tracking and product quality reporting.. Valid values are `true|false`',
    `warranty_expiry_date` DATE COMMENT 'Date on which the product or component warranty expires. Used to validate warranty claim eligibility and determine whether the case qualifies for warranty coverage.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_case PRIMARY KEY(`case_id`)
) COMMENT 'Customer service and support case records capturing post-sale issues, technical complaints, warranty claims, and escalations raised by industrial customers. Captures case number, case type (technical issue, delivery complaint, invoice dispute, warranty claim), priority, status, open date, resolution date, SLA breach flag, root cause category, resolution description, and assigned service engineer. Sourced from Salesforce Service Cloud Case.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`nps_response` (
    `nps_response_id` BIGINT COMMENT 'Unique system-generated identifier for each Net Promoter Score (NPS) survey response record. Serves as the primary key for the nps_response data product.',
    `account_id` BIGINT COMMENT 'Reference to the customer account (B2B industrial buyer, OEM partner, distributor, or system integrator) associated with this NPS response. Enables account-level loyalty analysis.',
    `contact_id` BIGINT COMMENT 'Reference to the individual customer contact who submitted the NPS survey response. Enables contact-level satisfaction tracking and follow-up actions.',
    `nps_survey_id` BIGINT COMMENT 'Unique identifier of the NPS survey campaign or questionnaire that generated this response. Links the response to a specific survey program or wave.. Valid values are `^SRV-[A-Z0-9]{6,20}$`',
    `anonymized` BOOLEAN COMMENT 'Boolean flag indicating whether the NPS response has been anonymized (i.e., personal identifiers removed or masked) for use in aggregate reporting or AI/ML model training, in compliance with GDPR data minimisation principles.. Valid values are `true|false`',
    `capa_reference` STRING COMMENT 'Reference number of the Corrective and Preventive Action (CAPA) record raised in the Quality Management System (QMS) as a result of this NPS response. Links customer feedback to formal quality improvement actions.',
    `consent_date` DATE COMMENT 'Date on which the customer contact provided consent for processing of their NPS survey response data. Required for GDPR and CCPA compliance audit trails.. Valid values are `^d{4}-d{2}-d{2}$`',
    `consent_given` BOOLEAN COMMENT 'Boolean flag indicating whether the customer contact provided explicit consent for their survey response data to be processed and stored, in compliance with GDPR and CCPA requirements.. Valid values are `true|false`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code of the customer account location at the time of the survey. Supports regional and geographic NPS benchmarking.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when the NPS response record was first created in the source system. Supports audit trail requirements and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `crm_survey_response_code` STRING COMMENT 'Native identifier of the NPS survey response record in the Salesforce CRM system. Enables cross-system traceability and reconciliation between the lakehouse silver layer and the CRM source of record.',
    `feedback_topic_tags` STRING COMMENT 'Comma-separated list of business topic labels extracted or manually assigned from the verbatim feedback (e.g., Delivery, Quality, Support, Pricing, Technical). Enables topic-based categorization and root cause analysis of customer feedback.',
    `follow_up_date` DATE COMMENT 'Target or actual date by which the follow-up action for this NPS response is to be completed. Used for Service Level Agreement (SLA) compliance tracking in customer recovery programs.. Valid values are `^d{4}-d{2}-d{2}$`',
    `follow_up_owner` STRING COMMENT 'Name or user identifier of the employee or team responsible for executing the follow-up action for this NPS response. Supports accountability tracking in customer recovery workflows.',
    `follow_up_required` BOOLEAN COMMENT 'Boolean flag indicating whether a follow-up action is required for this NPS response, typically triggered for Detractors or responses with critical verbatim feedback. Drives Corrective and Preventive Action (CAPA) workflows.. Valid values are `true|false`',
    `follow_up_status` STRING COMMENT 'Current status of the follow-up action associated with this NPS response. Tracks the lifecycle of customer recovery and Corrective and Preventive Action (CAPA) activities.. Valid values are `Not Required|Pending|In Progress|Completed|Escalated`',
    `language_code` STRING COMMENT 'ISO 639-1 language code of the language in which the NPS survey was presented and the response was collected (e.g., en, de, fr, zh). Supports multilingual survey analysis.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when the NPS response record was most recently updated in the source system. Supports change tracking, audit trails, and incremental data pipeline processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `nps_score` STRING COMMENT 'Numeric score (0–10) provided by the customer contact indicating their likelihood to recommend the company, product, or service. Core metric of the NPS methodology: 0–6 = Detractor, 7–8 = Passive, 9–10 = Promoter.. Valid values are `^([0-9]|10)$`',
    `product_line` STRING COMMENT 'The product line or service category being rated by the customer in this NPS response (e.g., Automation Systems, Electrification Solutions, Smart Infrastructure). Enables product-level satisfaction analysis.',
    `product_sku` STRING COMMENT 'The specific Stock Keeping Unit (SKU) or product identifier being rated in this NPS response. Enables granular product-level satisfaction tracking and quality improvement initiatives.',
    `region` STRING COMMENT 'Geographic region or territory of the customer account (e.g., North America, Europe, Asia Pacific). Supports regional NPS performance reporting and benchmarking.',
    `respondent_category` STRING COMMENT 'Classification of the respondent based on their NPS score: Promoter (9–10), Passive (7–8), or Detractor (0–6). Derived classification used for NPS calculation and loyalty segmentation reporting.. Valid values are `Promoter|Passive|Detractor`',
    `response_date` DATE COMMENT 'Calendar date on which the customer contact submitted their NPS survey response. Used to calculate response latency and for trend reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `response_status` STRING COMMENT 'Current status of the NPS survey response (e.g., Completed, Partial, Declined, Expired, Bounced). Enables response rate analysis and survey program effectiveness tracking.. Valid values are `Completed|Partial|Declined|Expired|Bounced`',
    `response_time_days` STRING COMMENT 'Number of calendar days elapsed between the survey dispatch date and the customer response date. Used to measure survey responsiveness and assess the timeliness of customer engagement.. Valid values are `^d+$`',
    `response_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone) at which the customer submitted the NPS survey response. Supports audit trails and precise response latency calculations.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for the customer account at the time of the survey. Enables organizational-level NPS benchmarking and performance management.',
    `sentiment_category` STRING COMMENT 'Categorical classification of the verbatim feedback sentiment derived from NLP analysis (Positive, Neutral, Negative, Mixed). Enables high-level sentiment trend reporting without requiring score-level analysis.. Valid values are `Positive|Neutral|Negative|Mixed`',
    `sentiment_score` DECIMAL(18,2) COMMENT 'Numeric sentiment score derived from Natural Language Processing (NLP) analysis of the verbatim feedback text, ranging from -1.0 (most negative) to +1.0 (most positive). Supports automated Voice of the Customer (VoC) analytics.. Valid values are `^-?[01](.d{1,4})?$`',
    `service_type` STRING COMMENT 'Type of after-sales or field service associated with the NPS survey trigger event. Applicable when the survey is related to a service interaction rather than a product delivery.. Valid values are `Field Service|Remote Support|Repair|Preventive Maintenance|Commissioning|Training|Warranty|Other`',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this NPS response record was ingested into the Databricks Lakehouse Silver Layer (e.g., Salesforce CRM, SAP S/4HANA). Supports data lineage and audit traceability.. Valid values are `Salesforce CRM|SAP S/4HANA|Siemens Opcenter MES|Manual|Other`',
    `survey_channel` STRING COMMENT 'The communication channel through which the NPS survey was delivered to the customer contact (e.g., Email, SMS, Web Portal, In-App, Phone, Field Service, Event Kiosk). Supports channel effectiveness analysis.. Valid values are `Email|SMS|Web Portal|In-App|Phone|Field Service|Event Kiosk`',
    `survey_date` DATE COMMENT 'Calendar date on which the NPS survey was sent to the customer contact. Used for time-series analysis of customer satisfaction trends.. Valid values are `^d{4}-d{2}-d{2}$`',
    `survey_program` STRING COMMENT 'Classification of the NPS survey program type: Transactional (triggered by a specific event), Relational (periodic relationship survey), Product, Service, or Event. Determines the analytical context for the response.. Valid values are `Transactional|Relational|Product|Service|Event`',
    `survey_wave` STRING COMMENT 'Identifier or label for the NPS survey wave or batch (e.g., Q1-2024, H2-2024-PostDelivery). Enables cohort-based analysis and comparison of NPS results across survey cycles.',
    `trigger_event_reference` STRING COMMENT 'Business reference number or identifier of the specific event that triggered the survey (e.g., delivery order number, service ticket number, work order number). Provides traceability back to the originating business transaction.',
    `trigger_event_type` STRING COMMENT 'The key business event that triggered the NPS survey dispatch (e.g., Product Delivery, Commissioning, Service Resolution, Installation). Enables event-based satisfaction benchmarking.. Valid values are `Product Delivery|Commissioning|Service Resolution|Installation|Repair|Preventive Maintenance|Contract Renewal|Training|Other`',
    `verbatim_feedback` STRING COMMENT 'Open-text qualitative feedback provided by the customer contact explaining the reason for their NPS score. Used for root cause analysis, sentiment analysis, and Voice of the Customer (VoC) programs.',
    CONSTRAINT pk_nps_response PRIMARY KEY(`nps_response_id`)
) COMMENT 'Net Promoter Score survey responses collected from customer contacts following key business events such as product delivery, commissioning, or service resolution. Captures survey date, NPS score (0-10), promoter/passive/detractor classification, verbatim feedback text, survey channel, product or service rated, account reference, contact reference, and follow-up action flag. Supports customer satisfaction and loyalty tracking programs.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`account_document` (
    `account_document_id` BIGINT COMMENT 'Unique surrogate identifier for each customer account document record in the lakehouse silver layer. Serves as the primary key for all downstream joins and lineage tracking.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Account documents (NDAs, master purchase agreements, etc.) are owned by a specific customer account. This FK establishes the fundamental ownership relationship. No existing FK exists. counterparty_nam',
    `evidence_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_evidence. Business justification: Customer contracts and agreements serve as compliance evidence for audits. Legal teams link account documents (NDAs, quality agreements, export licenses) to compliance records for regulatory audit tra',
    `associated_contract_number` STRING COMMENT 'Reference to the parent commercial contract or master agreement number under which this document was created or to which it is subordinate (e.g., a quality agreement linked to a master purchase agreement). Supports document hierarchy and contract portfolio management.',
    `confidentiality_level` STRING COMMENT 'Confidentiality classification assigned to the document itself as per the documents terms or internal information security policy. Drives access control, sharing restrictions, and data handling obligations. Distinct from the data platform classification tag.. Valid values are `public|internal|confidential|strictly_confidential|trade_secret`',
    `counterparty_name` STRING COMMENT 'Legal name of the external party (customer, partner, distributor, OEM) who is a signatory or subject of the document. Used for document search, legal reference, and counterparty risk management.',
    `counterparty_reference_number` STRING COMMENT 'The document reference number assigned by the counterparty (customer or partner) to this agreement. Enables cross-referencing between internal and external document numbering systems for dispute resolution and audit.',
    `created_by_user` STRING COMMENT 'Username or employee ID of the user who created the document record in the source system. Supports audit trail and accountability requirements under quality management and data governance frameworks.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the account document record was first created in the lakehouse silver layer. Supports audit trail, data lineage, and change history reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `custodian_department` STRING COMMENT 'Name of the internal department or business unit responsible for the document (e.g., Legal, Sales, Quality, Finance, Export Control). Supports document ownership reporting and escalation routing.',
    `custodian_name` STRING COMMENT 'Full name of the internal employee or role responsible for maintaining, renewing, and ensuring compliance of this document. The custodian is the primary point of contact for document-related queries and renewal actions.',
    `digital_signature_status` STRING COMMENT 'Status of electronic or digital signature execution for the document. Tracks whether the document has been signed by internal parties, the counterparty, or both. Supports e-signature workflow management and legal enforceability confirmation.. Valid values are `not_required|pending|signed_by_us|signed_by_counterparty|fully_executed|signature_failed|expired`',
    `document_category` STRING COMMENT 'High-level grouping of the document by functional area (e.g., legal, commercial, compliance, quality). Supports document portfolio management, access control, and reporting across the customer domain.. Valid values are `legal|commercial|compliance|quality|financial|export_control|safety|environmental|other`',
    `document_number` STRING COMMENT 'Business-assigned unique document reference number as recorded in the source system (SAP S/4HANA SD or Salesforce CRM). Used for cross-system document traceability and audit purposes.. Valid values are `^[A-Z0-9-]{3,50}$`',
    `document_type` STRING COMMENT 'Classification of the customer account document by its legal or commercial purpose. Drives document handling workflows, retention policies, and compliance obligations. Includes NDAs, master purchase agreements, quality agreements, export licenses, tax exemption certificates, and customer-provided certifications.. Valid values are `NDA|master_purchase_agreement|quality_agreement|export_license|tax_exemption_certificate|customer_certification|SLA_agreement|framework_contract|credit_agreement|insurance_certificate|regulatory_compliance_certificate|other`',
    `execution_date` DATE COMMENT 'The date on which the document was formally executed (signed by all parties). May differ from issue_date for documents that are pre-dated or post-dated. Relevant for legal enforceability determination.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'The date on which the document expires and is no longer legally valid or enforceable. Critical for compliance monitoring, renewal workflows, and SLA management. Null if the document has no defined expiry (e.g., perpetual NDAs).. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_control_classification` STRING COMMENT 'Export control classification applicable to the document or the products/technology it covers. Critical for export license documents, customer certifications, and end-use statements. Aligns with EAR (Export Administration Regulations) and ITAR (International Traffic in Arms Regulations) compliance.. Valid values are `EAR99|ECCN|ITAR|no_restriction|restricted|embargoed|license_required|not_applicable`',
    `file_format` STRING COMMENT 'Electronic file format of the stored document (e.g., PDF, DOCX, XML). Supports document rendering, archival format compliance, and digital signature validation workflows.. Valid values are `PDF|DOCX|XLSX|PPTX|XML|CSV|TIFF|JPEG|PNG|ZIP|other`',
    `file_reference` STRING COMMENT 'Storage path, URI, or document management system reference (e.g., Teamcenter object ID, SharePoint URL, or S3 path) pointing to the physical document file. Enables retrieval of the source document for review, audit, or legal proceedings.',
    `governing_law` STRING COMMENT 'The legal jurisdiction or body of law under which the document is governed and disputes are resolved (e.g., State of New York, USA, England and Wales, Germany - BGB). Essential for legal and contract management in multinational operations.',
    `is_multilingual` BOOLEAN COMMENT 'Indicates whether the document exists in multiple language versions. When true, additional language copies are managed under the same document_number with different language_code values. Relevant for EU regulatory submissions and multinational contracts.. Valid values are `true|false`',
    `issue_date` DATE COMMENT 'The date on which the document was officially issued, signed, or became effective. Used to determine document validity windows, calculate days-to-expiry, and support audit and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `issuing_authority` STRING COMMENT 'Name of the organization, government body, or regulatory agency that issued or certified the document (e.g., Bureau of Industry and Security for export licenses, IRS for tax exemption certificates, UL for safety certifications). Critical for export control and regulatory compliance validation.',
    `issuing_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country in which the document was issued. Supports export control classification, jurisdictional compliance checks, and multi-country regulatory reporting.. Valid values are `^[A-Z]{3}$`',
    `language_code` STRING COMMENT 'ISO 639-1 language code of the documents primary language (e.g., en, de, fr, zh-CN). Supports multilingual document management, translation tracking, and regulatory submission requirements in multinational operations.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_by_user` STRING COMMENT 'Username or employee ID of the user who last modified the document record. Supports change audit trail and accountability requirements for document control under ISO 9001 and data governance policies.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the account document record in the lakehouse silver layer. Used for incremental data processing, change detection, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_review_date` DATE COMMENT 'Date on which the most recent periodic review of the document was completed. Used to calculate the next scheduled review date and to confirm compliance with review frequency obligations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next mandatory review of the document. Derived from last_review_date plus review_frequency_months but stored explicitly to support compliance calendar reporting and proactive alerting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `notes` STRING COMMENT 'Free-text field for capturing additional context, special conditions, amendment summaries, or operational notes related to the document. Supports legal and commercial teams with supplementary information not captured in structured fields.',
    `renewal_reminder_date` DATE COMMENT 'The date on which an automated or manual reminder should be triggered to initiate document renewal or renegotiation. Typically set a configurable number of days before expiry_date. Supports proactive compliance and commercial risk management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `requires_periodic_review` BOOLEAN COMMENT 'Indicates whether the document requires scheduled periodic review (e.g., annual quality agreement review, biennial NDA renewal assessment). When true, review_frequency_months governs the review cycle.. Valid values are `true|false`',
    `review_frequency_months` STRING COMMENT 'Number of months between mandatory periodic reviews of the document. Applicable when requires_periodic_review is true. Drives automated review scheduling and compliance calendar management.. Valid values are `^[0-9]{1,3}$`',
    `revision_code` STRING COMMENT 'Alphanumeric revision code assigned to the document (e.g., A, B, C or Rev01, Rev02) as used in engineering and PLM document control workflows. Complements version_number for documents following letter-based revision schemes common in manufacturing.. Valid values are `^[A-Z0-9]{1,10}$`',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for the customer account associated with this document. Enables document filtering and reporting by sales entity, supporting multi-entity multinational operations.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this document record was ingested (e.g., SAP S/4HANA SD, Salesforce CRM, Siemens Teamcenter PLM). Supports data lineage, reconciliation, and master data management.. Valid values are `SAP_S4HANA|Salesforce_CRM|Teamcenter_PLM|SAP_Ariba|manual|other`',
    `source_system_document_code` STRING COMMENT 'Native document identifier as assigned by the source operational system (e.g., Teamcenter document object ID, SAP document key, Salesforce ContentDocument ID). Enables bidirectional traceability between the lakehouse and source systems.',
    `status` STRING COMMENT 'Current lifecycle status of the account document. Drives workflow routing, compliance alerts, and document validity checks. Active documents are legally binding; expired or superseded documents are retained for audit history.. Valid values are `draft|pending_review|active|expired|superseded|cancelled|archived|pending_signature|rejected`',
    `title` STRING COMMENT 'Full descriptive title of the document as it appears on the official document or as registered in the document management system (Siemens Teamcenter PLM). Used for search, display, and legal reference.',
    `version_number` STRING COMMENT 'Version identifier of the document following semantic versioning conventions (e.g., 1.0, 2.1, 3.0.1). Tracks document revisions over time and ensures the correct version is referenced in commercial and legal proceedings.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)?$`',
    CONSTRAINT pk_account_document PRIMARY KEY(`account_document_id`)
) COMMENT 'Repository of customer account-related documents including signed NDAs, master purchase agreements, quality agreements, export license copies, tax exemption certificates, and customer-provided certifications. Captures document type, document title, file reference, version number, issue date, expiry date, issuing authority, document status, and custodian. Supports compliance, legal, and commercial document management for customer accounts.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` (
    `account_bank_detail_id` BIGINT COMMENT 'Unique surrogate identifier for each customer bank account detail record in the silver layer lakehouse. Serves as the primary key for this entity.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Bank details are owned by a specific customer account. This FK establishes the fundamental ownership relationship between bank/payment instrument records and the master account. No existing FK exists.',
    `bank_account_id` BIGINT COMMENT 'Foreign key linking to finance.bank_account. Business justification: Customer bank details reference master bank accounts for payment processing, direct debits, and refunds. Treasury and AR teams use this for automated payment collection and disbursement.',
    `account_holder_name` STRING COMMENT 'Full legal name of the individual or entity that holds the bank account. Must match the name registered with the bank for payment validation and anti-fraud compliance.',
    `account_type` STRING COMMENT 'Classification of the bank account type (e.g., checking, savings, current). Determines applicable banking rules and payment processing behavior.. Valid values are `checking|savings|current|deposit|escrow`',
    `bank_account_number` STRING COMMENT 'The customers bank account number at the specified bank. Used for direct debit mandates, electronic fund transfers, and refund processing. Subject to PCI/PII data protection requirements.',
    `bank_branch_name` STRING COMMENT 'Name of the specific branch of the bank where the customer account is maintained. Relevant for countries where branch-level identification is required for payment routing.',
    `bank_control_key` STRING COMMENT 'SAP-specific control key that defines the type of bank account and applicable payment processing rules (e.g., distinguishes between checking and savings accounts in certain country-specific configurations).',
    `bank_country_code` STRING COMMENT 'ISO 3166-1 alpha-2 country code of the bank where the customer account is held. Used to determine applicable banking regulations, SEPA eligibility, and payment routing rules.. Valid values are `^[A-Z]{2}$`',
    `bank_key` STRING COMMENT 'National bank routing identifier (e.g., ABA routing number in the US, sort code in the UK, Bankleitzahl in Germany). Used in SAP S/4HANA FI to uniquely identify the bank institution within a country.',
    `blocked_reason` STRING COMMENT 'Reason code explaining why the bank account detail record has been blocked from use in payment processing. Supports investigation, audit, and compliance workflows.. Valid values are `fraud_suspected|account_closed|invalid_details|customer_request|compliance_hold|returned_payment|other`',
    `collection_authorization_flag` BOOLEAN COMMENT 'Indicates whether the customer has explicitly authorized the company to collect payments (direct debit) from this bank account. Required for compliance with direct debit regulations and mandate management.. Valid values are `true|false`',
    `created_by_user` STRING COMMENT 'Username or user ID of the person who created this bank account detail record in the source system. Required for audit trail and access control compliance.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when this bank account detail record was first created in the system. Used for audit trail, data lineage, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `creditor_identifier` STRING COMMENT 'Unique identifier assigned to the company as a SEPA direct debit creditor by the national banking authority. Required on all SEPA direct debit transactions to identify the initiating creditor.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the bank account (e.g., USD, EUR, GBP). Determines the currency in which transactions are processed for this account.. Valid values are `^[A-Z]{3}$`',
    `data_privacy_consent_flag` BOOLEAN COMMENT 'Indicates whether the customer has provided explicit consent for the storage and processing of their bank account data in accordance with applicable data privacy regulations (GDPR, CCPA).. Valid values are `true|false`',
    `iban` STRING COMMENT 'Internationally standardized bank account number conforming to ISO 13616. Used for cross-border electronic fund transfers and SEPA payment processing within the EU and participating countries.. Valid values are `^[A-Z]{2}[0-9]{2}[A-Z0-9]{1,30}$`',
    `is_primary` BOOLEAN COMMENT 'Indicates whether this is the primary (default) bank account for the customer. When multiple bank accounts exist, the primary account is used as the default for payment processing unless overridden.. Valid values are `true|false`',
    `is_verified` BOOLEAN COMMENT 'Indicates whether the bank account details have been verified through a validation process (e.g., micro-deposit verification, bank confirmation, or third-party validation service). Unverified accounts may be restricted from payment use.. Valid values are `true|false`',
    `last_modified_by_user` STRING COMMENT 'Username or user ID of the person who last modified this bank account detail record. Required for audit trail, change management, and compliance reporting.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this bank account detail record. Supports change tracking, audit compliance, and incremental data loading in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_used_date` DATE COMMENT 'Date on which this bank account was last used for a payment transaction (direct debit, refund, or EFT). Used for dormancy detection, mandate validity tracking, and data quality management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `mandate_reference` STRING COMMENT 'Unique reference identifier for the SEPA direct debit mandate associated with this bank account. Required for SEPA Core and SEPA B2B direct debit schemes to authorize recurring collections from the customer.. Valid values are `^[A-Za-z0-9+?/-]{1,35}$`',
    `mandate_signed_date` DATE COMMENT 'Date on which the customer signed and authorized the SEPA direct debit mandate. Required for mandate validity and regulatory compliance under SEPA rules.. Valid values are `^d{4}-d{2}-d{2}$`',
    `mandate_status` STRING COMMENT 'Current operational status of the SEPA direct debit mandate. Determines whether the mandate can be used to initiate direct debit collections from the customers account.. Valid values are `active|inactive|cancelled|pending|expired|suspended`',
    `mandate_type` STRING COMMENT 'Type of SEPA direct debit mandate scheme: SEPA Core (for consumer accounts), SEPA B2B (for business accounts), or COR1 (expedited core). Governs the applicable rulebook and creditor/debtor rights.. Valid values are `core|b2b|cor1`',
    `notes` STRING COMMENT 'Free-text field for additional remarks, instructions, or contextual information related to this bank account detail record. May include special handling instructions or historical context.',
    `partner_bank_type` STRING COMMENT 'SAP partner bank type code used to assign this bank account to specific payment transactions or payment methods in the payment program. Allows differentiation when a customer has multiple bank accounts for different purposes.',
    `payment_method` STRING COMMENT 'The payment instrument or method associated with this bank account record. Determines how outgoing payments (refunds, credits) or incoming collections (direct debits) are processed.. Valid values are `direct_debit|wire_transfer|ach|sepa_credit_transfer|sepa_direct_debit|check|eft`',
    `refund_eligible_flag` BOOLEAN COMMENT 'Indicates whether this bank account is approved and eligible to receive refund payments or credit transfers from the company. Supports refund processing workflows in SAP S/4HANA FI.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this bank account detail record originated. Supports data lineage, reconciliation, and master data management across integrated systems.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|MIGRATION`',
    `source_system_key` STRING COMMENT 'The natural key or record identifier of this bank account detail in the originating source system (e.g., SAP FI bank detail sequence number). Enables traceability and reconciliation back to the system of record.',
    `status` STRING COMMENT 'Current operational status of the bank account detail record. Controls whether the record is available for payment processing, blocked due to issues, or pending verification.. Valid values are `active|inactive|blocked|pending_verification|expired|cancelled`',
    `swift_bic_code` STRING COMMENT 'Society for Worldwide Interbank Financial Telecommunication (SWIFT) Business Identifier Code (BIC) that uniquely identifies the bank for international wire transfers. Conforms to ISO 9362 standard.. Valid values are `^[A-Z]{4}[A-Z]{2}[A-Z0-9]{2}([A-Z0-9]{3})?$`',
    `valid_from_date` DATE COMMENT 'Date from which this bank account detail record is effective and can be used for payment processing. Supports time-based validity management of banking data in SAP S/4HANA.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'Date until which this bank account detail record is valid for payment processing. After this date, the record is considered expired and should not be used for new transactions.. Valid values are `^d{4}-d{2}-d{2}$`',
    `verification_date` DATE COMMENT 'Date on which the bank account details were successfully verified. Used for compliance tracking and determining when re-verification may be required.. Valid values are `^d{4}-d{2}-d{2}$`',
    `verification_method` STRING COMMENT 'Method used to verify the authenticity and ownership of the bank account. Supports audit trail and compliance requirements for payment fraud prevention.. Valid values are `micro_deposit|bank_confirmation|third_party_service|manual_review|prenote`',
    CONSTRAINT pk_account_bank_detail PRIMARY KEY(`account_bank_detail_id`)
) COMMENT 'Customer bank account and payment instrument details used for direct debit mandates, refund processing, and electronic fund transfers. Captures bank country, bank key, bank account number, IBAN, SWIFT/BIC code, account holder name, payment method, mandate reference (for SEPA direct debit), mandate status, and validity dates. Managed in SAP S/4HANA FI customer master banking data.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`account_contact_role` (
    `account_contact_role_id` BIGINT COMMENT 'Unique surrogate identifier for each account-contact role association record in the silver layer lakehouse. Serves as the primary key for this entity.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: account_contact_role is an association entity linking contacts to accounts with specific business roles. The account_id FK is essential to establish which account the role applies to. No existing FK e',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: account_contact_role is an association entity linking contacts to accounts. The contact_id FK is essential to establish which contact holds the role. No existing FK exists. No safe denormalized column',
    `assigned_sales_territory` STRING COMMENT 'The sales territory code or name associated with this contact role, used to align the contact with the correct account management team and regional sales organization for targeted engagement.',
    `authority_limit_currency` STRING COMMENT 'The ISO 4217 three-letter currency code in which the purchase order authority limit is denominated. Supports multi-currency operations across global accounts.. Valid values are `^[A-Z]{3}$`',
    `ccpa_opt_out` BOOLEAN COMMENT 'Indicates whether the contact has exercised their CCPA (California Consumer Privacy Act) right to opt out of the sale or sharing of their personal data in the context of this role. Applicable to contacts in California.. Valid values are `true|false`',
    `communication_language` STRING COMMENT 'The preferred language for communications directed to this contact in this role, expressed as an IETF BCP 47 language tag (e.g., en-US, de-DE, fr-FR). Supports multilingual B2B engagement across global accounts.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `communication_preference` STRING COMMENT 'The preferred channel through which this contact wishes to receive communications in the context of this role. Governs outbound communication routing for commercial, technical, and service interactions.. Valid values are `email|phone|mobile|postal|portal|no_contact`',
    `contract_authority_level` STRING COMMENT 'Defines the level of contractual signing authority held by this contact in the context of this role. Critical for order management, procurement, and legal compliance workflows requiring authorized signatories.. Valid values are `full_signatory|limited_signatory|no_authority|approval_required`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp at which this account-contact role record was first created in the system. Provides the audit trail entry point for the record lifecycle.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `crm_role_code` STRING COMMENT 'The native identifier for this account-contact role record in the Salesforce CRM system. Enables cross-system traceability and reconciliation between the lakehouse silver layer and the CRM source of record.',
    `effective_date` DATE COMMENT 'The business-effective date from which this account-contact role record is considered valid for operational and reporting purposes. Supports bi-temporal data modeling and historical reporting in the silver layer.. Valid values are `^d{4}-d{2}-d{2}$`',
    `end_date` DATE COMMENT 'The date on which the contacts role within the account was terminated or expired. A null value indicates the role is currently active. Used for historical role tracking and succession planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `erp_partner_function_code` STRING COMMENT 'The SAP S/4HANA partner function code corresponding to this contact role (e.g., AP = Accounts Payable, SP = Ship-to Party contact). Enables alignment between CRM relationship data and ERP transactional partner determination.',
    `escalation_priority` STRING COMMENT 'Numeric priority rank (1 = highest) assigned to this contact role for escalation routing in service, quality, or commercial dispute scenarios. Ensures critical contacts are engaged first during incident management.. Valid values are `^[1-5]$`',
    `gdpr_consent_date` DATE COMMENT 'The date on which GDPR consent was obtained or last updated for this contact role. Required for audit trail and regulatory compliance in EU/EEA jurisdictions.. Valid values are `^d{4}-d{2}-d{2}$`',
    `gdpr_consent_status` STRING COMMENT 'Records the GDPR (General Data Protection Regulation) consent status for processing this contacts personal data in the context of this role. Mandatory for contacts in EU/EEA jurisdictions to ensure regulatory compliance.. Valid values are `granted|withdrawn|pending|not_required`',
    `influence_level` STRING COMMENT 'Characterizes the degree of influence this contact exercises over purchasing, technical, or operational decisions within the account. Used in sales strategy, opportunity management, and stakeholder mapping.. Valid values are `decision_maker|influencer|evaluator|gatekeeper|end_user|champion|blocker`',
    `is_primary` BOOLEAN COMMENT 'Indicates whether this contact is the primary point of contact for the specified role type within the account. Only one contact per role type per account should be flagged as primary at any given time.. Valid values are `true|false`',
    `last_interaction_date` DATE COMMENT 'The date of the most recent recorded business interaction (call, meeting, email, site visit) with this contact in the context of this role. Used for relationship health monitoring and account engagement analytics.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent modification to this account-contact role record. Used for change data capture (CDC), incremental loads, and audit trail maintenance in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `next_review_date` DATE COMMENT 'The scheduled date for the next formal review or reassessment of this contacts role assignment within the account. Supports periodic relationship governance and account planning cycles.. Valid values are `^d{4}-d{2}-d{2}$`',
    `notification_opt_in` BOOLEAN COMMENT 'Indicates whether the contact has opted in to receive automated notifications (e.g., order status updates, shipment alerts, quality notifications) in the context of this role. Supports GDPR and CCPA compliant communication.. Valid values are `true|false`',
    `purchase_order_authority_limit` DECIMAL(18,2) COMMENT 'The maximum monetary value (in the accounts base currency) up to which this contact is authorized to approve or issue Purchase Orders (POs) in this role. Used in procurement workflow routing and approval chain configuration.. Valid values are `^d+(.d{1,2})?$`',
    `relationship_strength` STRING COMMENT 'Qualitative assessment of the strength of the business relationship between the contact and the account in this role. Informs account management strategy and customer retention efforts.. Valid values are `strong|moderate|weak|unknown`',
    `role_category` STRING COMMENT 'Broad grouping of the contact role used for segmentation and targeted communication strategies. Enables filtering of contacts by functional area across the account portfolio.. Valid values are `commercial|technical|financial|operational|executive|compliance|service`',
    `role_description` STRING COMMENT 'Free-text description providing additional context about the contacts specific responsibilities or scope within this role at the account. Captures nuances not covered by the standardized role type enumeration.',
    `role_type` STRING COMMENT 'Classifies the specific business function or responsibility the contact holds within the account. Drives communication routing, escalation paths, and relationship mapping across complex B2B accounts in CRM and ERP systems.. Valid values are `primary_commercial_contact|technical_decision_maker|accounts_payable_contact|plant_manager|executive_sponsor|procurement_manager|quality_manager|logistics_coordinator|field_service_contact|legal_contact|safety_officer|it_contact|other`',
    `sla_tier` STRING COMMENT 'The SLA (Service Level Agreement) tier applicable to this contact role, governing response time commitments and escalation priorities for service and support interactions. Aligns with the accounts contracted service level.. Valid values are `platinum|gold|silver|bronze|standard`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this account-contact role record originated. Supports data lineage, audit, and master data management reconciliation.. Valid values are `salesforce_crm|sap_s4hana|manual|other`',
    `source_system_key` STRING COMMENT 'The natural or surrogate key of this record in the originating source system. Used for delta load processing, deduplication, and cross-system reconciliation in the lakehouse ingestion pipeline.',
    `start_date` DATE COMMENT 'The date on which the contact assumed the specified role within the account. Used for tenure tracking, historical analysis, and SLA (Service Level Agreement) assignment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the account-contact role association. Determines whether the role is operationally active for communication routing and relationship management.. Valid values are `active|inactive|pending|suspended`',
    `verification_date` DATE COMMENT 'The date on which the contacts role assignment was last verified or confirmed. Used for data quality audits and to identify stale or unverified role assignments requiring refresh.. Valid values are `^d{4}-d{2}-d{2}$`',
    `verified_flag` BOOLEAN COMMENT 'Indicates whether the contacts role assignment has been formally verified and confirmed by the account management team or the contact themselves. Supports data quality governance and master data management.. Valid values are `true|false`',
    CONSTRAINT pk_account_contact_role PRIMARY KEY(`account_contact_role_id`)
) COMMENT 'Association entity linking contacts to accounts with specific business roles, capturing the nature of the relationship between a person and an organization. Captures role type (primary commercial contact, technical decision maker, accounts payable contact, plant manager, executive sponsor), start date, end date, active flag, and communication preference. Enables targeted communication routing and relationship mapping across complex B2B accounts.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`consent_record` (
    `consent_record_id` BIGINT COMMENT 'Unique system-generated identifier for each consent record. Serves as the primary key for the consent_record data product in the Databricks Silver Layer.',
    `contact_id` BIGINT COMMENT 'Reference to the customer contact for whom this consent record applies. Links to the customer.contact data product to identify the data subject.',
    `crm_contact_id` BIGINT COMMENT 'The Salesforce CRM contact identifier associated with this consent record. Enables direct linkage to the CRM system of record for consent enforcement in marketing and service communications workflows.',
    `data_subject_request_id` BIGINT COMMENT 'Reference to an associated Data Subject Access Request (DSAR) or rights request that triggered or is linked to this consent record change. Supports end-to-end traceability of consent changes driven by formal data subject rights exercises.',
    `channel` STRING COMMENT 'The channel or medium through which the consent was collected from the data subject. Critical for demonstrating the mechanism of consent collection during regulatory audits.. Valid values are `web_form|email|phone|paper_form|mobile_app|crm_portal|trade_show|sales_representative|api|preference_center`',
    `collection_method` STRING COMMENT 'The specific mechanism used to obtain consent from the data subject. GDPR requires consent to be freely given, specific, informed, and unambiguous. This field documents the method to demonstrate compliance with these requirements.. Valid values are `explicit_opt_in|double_opt_in|implicit_opt_in|opt_out|pre_ticked_box|verbal|written_signature|electronic_signature`',
    `consent_reference_number` STRING COMMENT 'Business-facing unique reference number for the consent record, used for audit trails, regulatory inquiries, and cross-system traceability. Typically formatted as a human-readable code (e.g., CONS-2024-000123).',
    `consent_type` STRING COMMENT 'Classification of the specific data processing activity for which consent is being captured. Defines the scope of the consent grant, such as marketing communications, third-party data sharing, or profiling for analytics purposes.. Valid values are `marketing_email|marketing_sms|marketing_phone|data_sharing_third_party|profiling|analytics|personalization|research|product_updates|service_communications|automated_decision_making`',
    `consent_version` STRING COMMENT 'Version identifier of the consent notice or privacy policy under which consent was collected. Enables tracking of consent obtained under different versions of privacy notices and supports re-consent workflows when notices are updated.. Valid values are `^d+.d+(.d+)?$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the jurisdiction in which the consent was collected. Determines the applicable privacy regulation and data residency requirements for the consent record.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time at which this consent record was first created in the system. Provides the audit trail entry point for the consent record lifecycle.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `data_subject_type` STRING COMMENT 'Classification of the data subject category for whom consent is recorded. Supports differentiated consent management across B2B industrial buyers, OEM partners, system integrators, distributors, and end-users as defined in the customer domain.. Valid values are `b2b_contact|end_user|oem_partner_contact|distributor_contact|system_integrator_contact|employee|prospect`',
    `expiry_date` DATE COMMENT 'The date on which the consent record is scheduled to expire and require renewal. Supports consent lifecycle management and ensures time-limited consents are not used beyond their valid period.. Valid values are `^d{4}-d{2}-d{2}$`',
    `granted_date` DATE COMMENT 'The calendar date on which the data subject explicitly granted consent for the specified data processing activity. Used for consent validity calculations and regulatory reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `granted_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone) at which the data subject granted consent. Provides granular audit evidence required for GDPR accountability obligations and legal defensibility.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `is_minor` BOOLEAN COMMENT 'Indicates whether the data subject is a minor (under 16 years of age in EU jurisdictions, or under 13/16 per applicable local law). Triggers enhanced consent requirements including parental or guardian consent verification under GDPR Article 8.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'ISO 639-1 language code (optionally with ISO 3166-1 region suffix) of the language in which the consent notice was presented to the data subject. Ensures consent was provided in the data subjects native language as required for informed consent under GDPR.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time at which this consent record was most recently updated. Supports change tracking and audit trail requirements for GDPR accountability obligations.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `legal_basis` STRING COMMENT 'The lawful basis under which personal data is processed as defined by GDPR Article 6. Determines the regulatory framework governing the data processing activity. For CCPA, maps to the applicable California privacy right basis.. Valid values are `consent|legitimate_interest|contract|legal_obligation|vital_interests|public_task`',
    `notes` STRING COMMENT 'Free-text field for additional context, special conditions, or operational notes related to the consent record. May include details about unusual consent circumstances, legal team annotations, or compliance officer remarks.',
    `parental_consent_obtained` BOOLEAN COMMENT 'Indicates whether parental or guardian consent has been obtained for a minor data subject. Applicable when is_minor is true. Required for GDPR Article 8 compliance for processing personal data of children.. Valid values are `true|false`',
    `privacy_notice_version` STRING COMMENT 'Version identifier of the privacy notice or policy document presented to the data subject at the time of consent collection. Distinct from consent_version as it tracks the specific legal document version rather than the consent form version.',
    `processing_purpose` STRING COMMENT 'Detailed description of the specific purpose for which personal data is being processed under this consent record. Must be specific, explicit, and legitimate per GDPR requirements (e.g., Sending monthly product update newsletters to industrial automation customers).',
    `proof_of_consent_reference` STRING COMMENT 'Reference identifier or document path pointing to the evidence of consent (e.g., signed form scan, email confirmation ID, web session log ID, or digital signature reference). Supports GDPR accountability obligations requiring the controller to demonstrate consent was validly obtained.',
    `re_consent_due_date` DATE COMMENT 'The target date by which re-consent must be obtained from the data subject. Populated when re_consent_required is true. Used to prioritize and schedule re-consent outreach campaigns.. Valid values are `^d{4}-d{2}-d{2}$`',
    `re_consent_required` BOOLEAN COMMENT 'Indicates whether the data subject must be re-consented due to a change in privacy notice, processing purpose, or consent expiry. Drives automated re-consent campaign workflows in Salesforce CRM.. Valid values are `true|false`',
    `record_effective_date` DATE COMMENT 'The business-effective date from which this consent record version is considered active and authoritative. Supports bi-temporal data modeling in the Databricks Silver Layer for point-in-time consent state reconstruction.. Valid values are `^d{4}-d{2}-d{2}$`',
    `regulation_scope` STRING COMMENT 'The specific data privacy regulation(s) under which this consent record is governed. Supports multi-jurisdictional compliance management for a multinational industrial manufacturing enterprise operating across EU, US, and other geographies.. Valid values are `GDPR|CCPA|LGPD|PIPEDA|PDPA|POPIA|APPI|GDPR_CCPA|multi_jurisdiction`',
    `retention_period_days` STRING COMMENT 'The number of days the consent record must be retained for regulatory compliance purposes after the consent expires or is withdrawn. Supports data retention schedule enforcement aligned with GDPR storage limitation principles.. Valid values are `^[0-9]+$`',
    `source_system` STRING COMMENT 'The operational system of record from which this consent record originated. For the Manufacturing enterprise, consent records primarily originate from Salesforce CRM (Sales Cloud/Service Cloud) or the customer preference center, with integration to SAP S/4HANA for ERP-side processing flags.. Valid values are `salesforce_crm|sap_s4hana|preference_center|web_portal|mobile_app|manual_entry|api_integration`',
    `source_system_consent_code` STRING COMMENT 'The native identifier of this consent record in the originating source system (e.g., Salesforce CRM consent object ID). Enables cross-system traceability and reconciliation between the Databricks Silver Layer and operational systems.',
    `status` STRING COMMENT 'Current operational status of the consent record indicating whether the data subject has granted, withdrawn, or allowed the consent to expire. Drives eligibility for data processing activities across CRM and ERP systems.. Valid values are `granted|withdrawn|expired|pending|not_given`',
    `third_party_sharing_scope` STRING COMMENT 'Description of the specific third parties or categories of third parties with whom data may be shared under this consent record. Applicable when consent_type includes data_sharing_third_party. Required for GDPR transparency obligations.',
    `withdrawal_date` DATE COMMENT 'The calendar date on which the data subject withdrew their previously granted consent. Null if consent has not been withdrawn. Triggers cessation of related data processing activities.. Valid values are `^d{4}-d{2}-d{2}$`',
    `withdrawal_reason` STRING COMMENT 'Free-text or categorized reason provided by the data subject or recorded by the business for the withdrawal of consent. Supports analysis of consent withdrawal patterns and improvement of consent management practices.',
    `withdrawal_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone) at which the data subject withdrew consent. Provides granular audit evidence for GDPR accountability and supports SLA compliance for processing cessation timelines.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    CONSTRAINT pk_consent_record PRIMARY KEY(`consent_record_id`)
) COMMENT 'GDPR and CCPA consent management records for customer contacts, tracking explicit consent granted or withdrawn for data processing activities including marketing communications, data sharing with third parties, and profiling. Captures consent type, consent status (granted, withdrawn, expired), consent channel, consent date, withdrawal date, legal basis, data processing purpose, and consent version. Mandatory for EU and California regulatory compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`account_status_history` (
    `account_status_history_id` BIGINT COMMENT 'Unique surrogate identifier for each account status history record in the silver layer lakehouse. Serves as the primary key for this audit trail entity.',
    `account_id` BIGINT COMMENT 'Unique identifier of the customer account in Salesforce CRM. Enables traceability of status changes back to the originating CRM system record.',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether this status transition required formal approval before being applied. Supports governance controls and segregation of duties for sensitive status changes such as credit unblocking.. Valid values are `true|false`',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time at which the status change was formally approved. Used for approval cycle time analysis and compliance audit documentation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `approved_by_user` STRING COMMENT 'Username or user ID of the individual who approved the status change when approval was required. Supports segregation of duties and compliance audit trails.',
    `change_initiated_by` STRING COMMENT 'Indicates whether the status change was initiated by a human user, an automated system process, a batch job, an API integration, or a workflow automation rule. Supports root cause analysis and process governance.. Valid values are `user|system|batch_job|api_integration|workflow_automation`',
    `change_reason_code` STRING COMMENT 'Standardized code identifying the business reason that triggered the account status transition. Used for root cause analysis, compliance reporting, and lifecycle analytics.. Valid values are `credit_limit_exceeded|payment_overdue|customer_request|contract_expiry|reactivation|new_onboarding|fraud_investigation|compliance_hold|merger_acquisition|inactivity|manual_correction|system_migration|other`',
    `change_reason_description` STRING COMMENT 'Free-text narrative providing additional context or detail about the reason for the account status change, supplementing the standardized reason code.',
    `change_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone offset) at which the account status transition was recorded in the source system. Enables exact sequencing of status events and supports compliance audit requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `changed_by_user` STRING COMMENT 'Username or user ID of the individual who initiated or executed the account status change. Critical for accountability, compliance audits, and segregation of duties controls.',
    `changed_by_user_full_name` STRING COMMENT 'Full display name of the user who executed the status change, providing human-readable identification for audit reports and compliance documentation.',
    `compliance_hold_flag` BOOLEAN COMMENT 'Indicates whether this status change was triggered by or resulted in a compliance hold (e.g., export control, REACH/RoHS compliance, sanctions screening, GDPR data subject request). Supports regulatory audit requirements.. Valid values are `true|false`',
    `compliance_hold_reason` STRING COMMENT 'Specifies the regulatory or compliance reason for a compliance hold that triggered or accompanied this status change. Supports regulatory reporting and audit trail requirements.. Valid values are `export_control|sanctions_screening|reach_rohs|gdpr_request|osha_violation|epa_violation|other|none`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer accounts primary country at the time of the status change. Supports regional compliance reporting and geographic lifecycle analysis.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time at which this status history record was created in the data platform. Supports data lineage, audit trail completeness, and silver layer ingestion tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_block_reference` STRING COMMENT 'Reference number or identifier of the credit management action (e.g., SAP credit block code, credit memo, or credit review case) that triggered a credit-blocked status transition. Relevant for credit_blocked transitions.',
    `days_in_previous_status` STRING COMMENT 'Number of calendar days the account remained in the previous status before this transition. Supports dormancy analysis, churn prediction, and lifecycle duration reporting.. Valid values are `^[0-9]+$`',
    `effective_from_date` DATE COMMENT 'The date from which the new account status is considered effective for business operations. May differ from the change date when backdated or future-dated status changes are applied.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_to_date` DATE COMMENT 'The date until which this status record is valid. Populated when the status is superseded by a subsequent transition. Supports bi-temporal modeling and point-in-time status queries.. Valid values are `^d{4}-d{2}-d{2}$`',
    `erp_customer_code` STRING COMMENT 'Unique identifier of the customer account in SAP S/4HANA. Enables cross-system reconciliation of status transitions between CRM and ERP systems.',
    `is_current_record` BOOLEAN COMMENT 'Indicates whether this history record represents the most recent (current) status of the account. Simplifies queries for current account status without requiring window functions.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time at which this status history record was last updated in the data platform. Supports incremental processing, data quality monitoring, and audit trail completeness.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `new_status` STRING COMMENT 'The account status assigned as a result of this transition. Captures the to state in the status lifecycle and represents the current state at the time of the change event.. Valid values are `prospect|active|on_hold|credit_blocked|dormant|churned|suspended|pending_approval|closed`',
    `notes` STRING COMMENT 'Free-text notes or comments entered by the user or system at the time of the status change, providing additional context beyond the standardized reason code. Supports compliance documentation and customer service review.',
    `previous_status` STRING COMMENT 'The account status immediately before this transition occurred. Captures the from state in the status lifecycle, enabling before/after analysis and reactivation tracking.. Valid values are `prospect|active|on_hold|credit_blocked|dormant|churned|suspended|pending_approval|closed`',
    `reactivation_eligible_flag` BOOLEAN COMMENT 'Indicates whether the account is eligible for reactivation from its current status (e.g., dormant or churned accounts that meet reactivation criteria). Supports sales and marketing reactivation campaigns.. Valid values are `true|false`',
    `region_code` STRING COMMENT 'Geographic region code (e.g., EMEA, APAC, AMER) of the customer account at the time of the status change. Supports regional segmentation and lifecycle reporting for multinational operations.',
    `related_document_number` STRING COMMENT 'The document number of the business document (contract, PO, NCR, CAPA, etc.) that triggered or is associated with this status change. Enables cross-referencing with transactional records.',
    `related_document_type` STRING COMMENT 'Type of business document associated with this status change (e.g., contract expiry, Non-Conformance Report (NCR), Corrective and Preventive Action (CAPA), purchase order). Provides traceability to the triggering business event.. Valid values are `contract|purchase_order|credit_memo|complaint|ncr|capa|none`',
    `sales_organization_code` STRING COMMENT 'SAP sales organization code under which this account status change was recorded. Supports multi-org reporting and ensures status changes are attributed to the correct organizational unit in a multinational context.',
    `sla_tier` STRING COMMENT 'The Service Level Agreement (SLA) tier assigned to the customer account at the time of the status change. Captures whether SLA obligations changed as a result of the status transition.. Valid values are `platinum|gold|silver|bronze|standard`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this status change event originated (e.g., SAP S/4HANA, Salesforce CRM). Supports data lineage and cross-system reconciliation.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|API|BATCH`',
    `source_system_record_code` STRING COMMENT 'The unique identifier of this status change record in the originating source system (e.g., SAP change document number, Salesforce audit trail ID). Enables traceability back to the system of record.',
    `transition_type` STRING COMMENT 'Categorizes the nature of the status transition (e.g., activation, deactivation, credit block, reactivation). Enables segmentation of lifecycle events for analytics and reporting.. Valid values are `activation|deactivation|suspension|reactivation|credit_block|credit_unblock|churn|dormancy|escalation|correction`',
    `version_number` STRING COMMENT 'Sequential version number of this status history record, incremented when corrections or amendments are made to a previously recorded status change. Supports data lineage and audit trail integrity.. Valid values are `^[1-9][0-9]*$`',
    `change_date` DATE COMMENT 'Calendar date on which the account status transition became effective. Used for lifecycle duration calculations, dormancy analysis, and compliance audit timelines.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_account_status_history PRIMARY KEY(`account_status_history_id`)
) COMMENT 'Audit trail of all status transitions for customer accounts, capturing when accounts move between states such as prospect, active, on-hold, credit-blocked, dormant, and churned. Captures previous status, new status, change reason, change date, changed by user, and supporting notes. Enables lifecycle analysis, reactivation tracking, and compliance audit requirements for customer master data governance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`communication_preference` (
    `communication_preference_id` BIGINT COMMENT 'Unique surrogate identifier for each communication preference record in the Databricks Silver Layer. Serves as the primary key for this entity.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Communication preferences apply to customer accounts (entity_type=account). This FK links account-level communication preferences to the master account record. Nullable since entity_type determines ',
    `contact_id` BIGINT COMMENT 'Foreign key linking to customer.contact. Business justification: Communication preferences also apply to individual contacts (entity_type=contact). This FK links contact-level communication preferences to the contact record. Nullable since entity_type determines ',
    `partner_id` BIGINT COMMENT 'The EDI interchange identifier assigned to the customer or account for automated B2B document exchange (purchase orders, invoices, advance ship notices). Required when preferred_channel or secondary_channel is edi.',
    `ccpa_opt_out` BOOLEAN COMMENT 'Indicates whether the California-based contact or account has exercised their CCPA right to opt out of the sale or sharing of personal information for marketing and communication purposes. True = opted out.. Valid values are `true|false`',
    `communication_frequency` STRING COMMENT 'Indicates how frequently the customer or contact wishes to receive non-transactional communications such as newsletters, product updates, and marketing content. Transactional notifications (order, service) are sent as events occur regardless of this setting.. Valid values are `real_time|daily|weekly|bi_weekly|monthly|quarterly|as_needed`',
    `consent_collection_method` STRING COMMENT 'The method by which communication consent was collected from the customer or contact. Required for regulatory audit trails to demonstrate lawful basis for processing under GDPR and CCPA.. Valid values are `web_form|email_confirmation|paper_form|portal_registration|verbal|edi_agreement|crm_entry`',
    `consent_version` STRING COMMENT 'Version identifier of the consent notice or privacy policy that was presented to and accepted by the customer or contact at the time of consent collection. Enables tracking of consent against specific policy versions.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the jurisdiction in which this communication preference record applies. Drives regulatory compliance logic (GDPR for EU, CCPA for California/USA, CASL for Canada, etc.).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp recording when this communication preference record was first created in the Databricks Silver Layer. Used for data lineage, audit trails, and SLA compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `crm_preference_code` STRING COMMENT 'The native identifier for this communication preference record in Salesforce CRM (Sales Cloud or Service Cloud). Used for cross-system reconciliation and data lineage tracking between CRM and the Databricks Silver Layer.',
    `do_not_contact` BOOLEAN COMMENT 'Master suppression flag indicating that no outbound communications of any kind should be sent to this customer or contact. Overrides all other preference settings. Used for legal holds, deceased contacts, or explicit customer requests.. Valid values are `true|false`',
    `do_not_contact_reason` STRING COMMENT 'Reason code explaining why the do_not_contact flag has been set. Supports compliance reporting and audit trails for suppression decisions.. Valid values are `customer_request|legal_hold|deceased|regulatory_restriction|account_closed|dispute|other`',
    `effective_end_date` DATE COMMENT 'Date on which this communication preference record expires and should no longer be applied. A null value indicates the record is open-ended and currently active.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_start_date` DATE COMMENT 'Date from which this communication preference record becomes effective and should be applied to outbound communications. Supports temporal validity management for preference changes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `email_format_preference` STRING COMMENT 'Specifies whether the customer or contact prefers to receive emails in HTML (rich formatting with images and links) or plain text format. Relevant for accessibility compliance and email client compatibility.. Valid values are `html|plain_text`',
    `emergency_contact_preference` STRING COMMENT 'Specifies the preferred channel for urgent or emergency communications such as critical safety alerts, product recalls, regulatory notifications, or unplanned production disruptions. May differ from the standard preferred channel.. Valid values are `phone|email|sms|portal|edi|any`',
    `entity_type` STRING COMMENT 'Indicates whether this communication preference record applies to a corporate account (B2B organization) or an individual contact person. Drives how preferences are applied during outbound engagement.. Valid values are `account|contact`',
    `gdpr_consent_date` DATE COMMENT 'Date on which GDPR consent was most recently granted or withdrawn by the data subject. Required for regulatory audit trails and consent lifecycle management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `gdpr_consent_status` STRING COMMENT 'Current GDPR consent status for processing personal data for communication purposes. granted = explicit consent obtained; withdrawn = consent revoked by data subject; not_applicable = outside GDPR jurisdiction; pending = consent request sent but not yet responded to.. Valid values are `granted|withdrawn|not_applicable|pending`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp recording when this communication preference record was most recently updated in the Databricks Silver Layer. Supports change detection, incremental processing, and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_preference_update_date` DATE COMMENT 'Business date on which the customer or contact last updated their communication preferences, either through self-service portal, CRM agent update, or EDI agreement amendment. Used for preference freshness reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `marketing_opt_in` BOOLEAN COMMENT 'Indicates whether the customer or contact has explicitly opted in to receive marketing communications including promotional offers, product launches, and event invitations. True = opted in; False = not opted in. Mandatory for GDPR and CCPA compliance.. Valid values are `true|false`',
    `newsletter_subscription` BOOLEAN COMMENT 'Indicates whether the customer or contact has subscribed to Manufacturings periodic newsletter covering industry insights, product updates, and company news. Managed independently from general marketing opt-in.. Valid values are `true|false`',
    `notes` STRING COMMENT 'Free-text field for capturing additional context, special instructions, or exceptions related to this communication preference record. Examples include specific contact instructions for key accounts or notes from customer service interactions.',
    `order_notification` BOOLEAN COMMENT 'Indicates whether the customer or contact opts to receive transactional notifications related to order lifecycle events such as order confirmation, shipment dispatch, delivery confirmation, and invoice issuance.. Valid values are `true|false`',
    `portal_username` STRING COMMENT 'The registered username or login identifier for the customer or contact on Manufacturings self-service portal. Used to associate portal activity with communication preferences and to route portal-based notifications.',
    `preference_code` STRING COMMENT 'Business-facing alphanumeric code uniquely identifying this communication preference record, used for cross-system referencing and audit trails.. Valid values are `^CP-[A-Z0-9]{6,20}$`',
    `preference_update_channel` STRING COMMENT 'The channel through which the most recent update to this communication preference record was submitted. Supports audit trails and process improvement analysis for preference management workflows.. Valid values are `portal|crm_agent|email_link|paper_form|edi|api`',
    `preferred_channel` STRING COMMENT 'The primary communication channel through which the customer or contact prefers to be reached. Supports standard B2B industrial channels including EDI for automated order/invoice communications, portal for self-service, and traditional channels.. Valid values are `email|phone|portal|edi|fax|postal_mail|sms|no_contact`',
    `preferred_contact_days` STRING COMMENT 'Comma-separated list of days of the week on which the customer or contact prefers to be contacted (e.g., MON,TUE,WED,THU,FRI). Supports scheduling of outbound communications and field service visits.. Valid values are `^(MON|TUE|WED|THU|FRI|SAT|SUN)(,(MON|TUE|WED|THU|FRI|SAT|SUN))*$`',
    `preferred_contact_time_end` STRING COMMENT 'End of the preferred daily time window (HH:MM in 24-hour format) during which the customer or contact is available. Paired with preferred_contact_time_start to define the engagement window.. Valid values are `^([01]d|2[0-3]):[0-5]d$`',
    `preferred_contact_time_start` STRING COMMENT 'Start of the preferred daily time window (HH:MM in 24-hour format) during which the customer or contact is available and willing to receive communications. Used to schedule outbound calls, campaigns, and service follow-ups.. Valid values are `^([01]d|2[0-3]):[0-5]d$`',
    `preferred_contact_timezone` STRING COMMENT 'IANA time zone identifier (e.g., America/New_York, Europe/Berlin) representing the time zone in which the preferred contact time window is expressed. Critical for multinational operations spanning multiple time zones.. Valid values are `^[A-Za-z]+/[A-Za-z_]+$`',
    `preferred_language_code` STRING COMMENT 'ISO 639-1/639-2 language code representing the customers or contacts preferred language for all communications (e.g., en, de, fr, zh-CN). Used to localize emails, portal content, and printed documents.. Valid values are `^[a-z]{2,3}(-[A-Z]{2,3})?$`',
    `product_update_notification` BOOLEAN COMMENT 'Indicates whether the customer or contact wishes to receive notifications about product updates, firmware releases, engineering change notices (ECN), and end-of-life announcements for products they have purchased or are evaluating.. Valid values are `true|false`',
    `region_code` STRING COMMENT 'Internal region or sales territory code associated with this communication preference record (e.g., EMEA, APAC, AMER). Used for regional campaign targeting and compliance scope determination.',
    `sales_organization_code` STRING COMMENT 'SAP S/4HANA sales organization code to which this communication preference is scoped. Enables preference management at the sales organization level for multinational accounts with multiple selling entities.',
    `secondary_channel` STRING COMMENT 'Fallback communication channel to be used when the preferred channel is unavailable or unresponsive. Ensures continuity of engagement for critical operational and commercial communications.. Valid values are `email|phone|portal|edi|fax|postal_mail|sms|none`',
    `service_notification` BOOLEAN COMMENT 'Indicates whether the customer or contact opts to receive service-related notifications including maintenance reminders, service order status updates, warranty expiry alerts, and field service scheduling confirmations.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this communication preference record originated. Supports data lineage, reconciliation, and master data management across CRM and ERP platforms.. Valid values are `salesforce_crm|sap_s4hana|portal|manual|edi|marketing_cloud`',
    `source_system_key` STRING COMMENT 'The primary key or unique record identifier from the originating source system. Enables exact record traceability back to the system of record for audit and reconciliation purposes.',
    `status` STRING COMMENT 'Current lifecycle status of the communication preference record. active means preferences are enforced; inactive means the record is no longer applied; pending_review means awaiting compliance or consent validation; suspended means temporarily halted due to regulatory or operational reasons.. Valid values are `active|inactive|pending_review|suspended`',
    CONSTRAINT pk_communication_preference PRIMARY KEY(`communication_preference_id`)
) COMMENT 'Customer and contact communication preference settings governing how and when Manufacturing engages with each account or individual. Captures preferred language, preferred contact channel (email, phone, portal, EDI), preferred contact time window, marketing opt-in flag, newsletter subscription flag, product update notification flag, and emergency contact preference. Supports personalized engagement and regulatory compliance for outbound communications.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`account_team` (
    `account_team_id` BIGINT COMMENT 'Unique surrogate identifier for each account team member assignment record in the Manufacturing customer domain. Serves as the primary key for this entity in the Databricks Silver Layer.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Account team assignments are per customer account. This FK establishes which account the team member is assigned to manage. The denormalized account_number STRING field is removed as it is fully repla',
    `employee_id` BIGINT COMMENT 'The internal employee identifier of the Manufacturing team member assigned to the customer account. Sourced from HR system (Kronos Workforce Central) and cross-referenced in Salesforce CRM Account Team. Used for territory management, quota tracking, and workforce analytics.. Valid values are `^[A-Z0-9-]{3,20}$`',
    `access_level` STRING COMMENT 'The level of access granted to this team member on the customer account record in Salesforce CRM. Controls visibility and edit permissions for account data, opportunities, cases, and contacts. Aligns with data governance and least-privilege access principles.. Valid values are `read_only|read_write|full_access|owner`',
    `assignment_end_date` DATE COMMENT 'The date on which the team members assignment to the customer account is scheduled to end or was terminated. A null value indicates an open-ended, currently active assignment. Used for succession planning and coverage gap analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `assignment_reason` STRING COMMENT 'The business reason or trigger for this team members assignment to the customer account. Used for workforce planning analytics, territory change management, and audit trail of account coverage decisions.. Valid values are `new_account|territory_realignment|account_growth|escalation_support|merger_acquisition|coverage_gap|strategic_initiative|replacement`',
    `assignment_start_date` DATE COMMENT 'The date on which the team members assignment to the customer account became effective. Used for tenure tracking, quota period alignment, and historical account coverage analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `assignment_type` STRING COMMENT 'Classifies the nature of the team members assignment to the account. Primary denotes the main owner; Secondary denotes a supporting role; Backup denotes coverage during absence; Temporary or Interim denotes time-limited assignments; Global/Regional/Local denotes geographic scope of responsibility.. Valid values are `primary|secondary|backup|temporary|interim|global|regional|local`',
    `business_unit` STRING COMMENT 'The Manufacturing business unit (e.g., Automation Systems, Electrification Solutions, Smart Infrastructure) that this team member represents on the account. Used for product line coverage tracking and cross-BU account management reporting.',
    `case_access_level` STRING COMMENT 'The level of access this team member has to service case records associated with the customer account in Salesforce CRM Service Cloud. Governs visibility into customer support tickets, field service requests, and after-sales interactions.. Valid values are `none|read_only|read_write`',
    `certification_level` STRING COMMENT 'The highest technical certification level achieved by the team member relevant to the products and solutions they support on the account (e.g., Siemens Certified Professional, SAP Certified Consultant). Used for capability matching, account coverage quality assessment, and training gap analysis.. Valid values are `none|associate|professional|expert|master`',
    `country_code` STRING COMMENT 'The ISO 3166-1 alpha-3 country code representing the country where this team member is based or where their account coverage responsibility is located. Used for multi-country reporting, regulatory compliance scoping, and territory management.. Valid values are `^[A-Z]{3}$`',
    `coverage_region` STRING COMMENT 'The geographic sales or service region that this team member is responsible for covering on the account. Aligns with the sales territory hierarchy in Salesforce CRM and SAP S/4HANA SD sales district. Used for territory management, quota allocation, and regional reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this account team assignment record was first created in the source system. Used for audit trail, data lineage, and assignment tenure calculations. Formatted as ISO 8601 with millisecond precision.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `crm_team_member_code` STRING COMMENT 'The native Salesforce CRM Account Team Member record identifier (18-character Salesforce ID). Used for cross-system reconciliation and audit traceability back to the source system of record.',
    `crm_user_code` STRING COMMENT 'The Salesforce CRM User ID of the account team member. Used for cross-referencing user activity logs, opportunity ownership, and case assignments within Salesforce CRM. Distinct from the internal employee_id.',
    `department` STRING COMMENT 'The internal Manufacturing department or business unit to which the account team member belongs. Used for organizational reporting, headcount allocation, and cross-functional account coverage analysis.. Valid values are `Sales|Technical Sales|Customer Success|Field Service|Business Development|Key Account Management|Pre-Sales|Post-Sales|Channel Management|Inside Sales`',
    `email` STRING COMMENT 'The corporate work email address of the account team member. Used for routing customer communications, escalation notifications, and CRM workflow automation. Classified as PII under GDPR and CCPA.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `erp_sales_rep_number` STRING COMMENT 'The SAP S/4HANA sales representative number (PERNR or partner function VE) associated with this team member. Used for linking account team assignments to SAP SD sales documents, order processing, and revenue attribution.',
    `is_primary` BOOLEAN COMMENT 'Indicates whether this team member is the primary point of contact for the customer account. Only one team member per account should carry a True value for a given role at any point in time. Used for routing communications, escalations, and SLA ownership.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'The IETF BCP 47 language code representing the primary language spoken by the team member for customer engagement. Used for routing multilingual customer interactions and ensuring appropriate language coverage for global accounts.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this account team assignment record was last updated in the source system. Used for change data capture (CDC), incremental ETL processing, and audit trail maintenance in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `manager_name` STRING COMMENT 'The name of the direct manager or sales leader responsible for this account team member. Used for escalation routing, performance management, and organizational hierarchy reporting on account coverage.',
    `notes` STRING COMMENT 'Free-text field capturing additional context, special instructions, or business rationale for this account team assignment. May include account-specific coverage agreements, escalation protocols, or transition notes. Used by account managers and sales operations for qualitative account planning.',
    `opportunity_access_level` STRING COMMENT 'The level of access this team member has to opportunity records associated with the customer account in Salesforce CRM. Governs visibility into pipeline, deal stages, and revenue forecasts for the account.. Valid values are `none|read_only|read_write`',
    `phone` STRING COMMENT 'The corporate work phone number of the account team member. Used for direct customer contact routing and field service dispatch. Classified as PII under GDPR and CCPA.. Valid values are `^+?[0-9s-().]{7,20}$`',
    `quota_eligible_flag` BOOLEAN COMMENT 'Indicates whether this team members assignment on the account qualifies them for quota credit and commission on deals closed with this customer. Drives compensation plan calculations and sales performance reporting.. Valid values are `true|false`',
    `sales_organization_code` STRING COMMENT 'The SAP S/4HANA sales organization code under which this account team assignment operates. Defines the legal selling entity and organizational unit responsible for the account. Critical for revenue attribution, quota management, and financial reporting.. Valid values are `^[A-Z0-9]{1,4}$`',
    `sla_tier` STRING COMMENT 'The SLA tier associated with this team members account coverage commitment. Defines expected response times, escalation thresholds, and service quality standards for the assigned account. Aligns with the SLA agreement defined in the customer.sla_agreement product.. Valid values are `platinum|gold|silver|bronze|standard`',
    `source_system` STRING COMMENT 'The operational system of record from which this account team assignment record was sourced. Enables data lineage tracking and cross-system reconciliation in the Databricks Silver Layer.. Valid values are `Salesforce CRM|SAP S/4HANA|Kronos Workforce Central|Manual`',
    `source_system_key` STRING COMMENT 'The native primary key or record identifier of this account team assignment in the originating source system (e.g., Salesforce AccountTeamMember ID). Used for incremental load reconciliation, deduplication, and audit traceability.',
    `status` STRING COMMENT 'Current operational status of the account team member assignment. Active indicates a current, effective assignment. Inactive indicates a terminated or expired assignment. Pending indicates an approved but not yet effective assignment. On Leave indicates temporary coverage gap. Transferred indicates the member has moved to another account.. Valid values are `active|inactive|pending|on_leave|transferred`',
    `team_member_name` STRING COMMENT 'Full name of the Manufacturing employee assigned to the customer account team. Used for display in CRM dashboards, account plans, and customer-facing communications. Sourced from Salesforce CRM AccountTeamMember.',
    `team_role` STRING COMMENT 'The functional role of the team member on the customer account. Defines responsibilities such as commercial ownership (Account Executive), technical advisory (Technical Sales Engineer), or post-sales support (Customer Success Manager, Field Service Coordinator). Drives territory and quota assignment logic.. Valid values are `Account Executive|Technical Sales Engineer|Customer Success Manager|Field Service Coordinator|Inside Sales Representative|Sales Manager|Application Engineer|Key Account Manager|Business Development Manager|Channel Manager|Pre-Sales Consultant|Post-Sales Support`',
    `territory_code` STRING COMMENT 'The sales territory code assigned to this team member for the account, as defined in Salesforce CRM Territory Management. Used for quota assignment, commission calculation, and territory performance reporting.',
    `time_zone` STRING COMMENT 'The IANA time zone identifier for the team members working location (e.g., America/New_York, Europe/Berlin). Used for scheduling customer meetings, SLA response time calculations, and global account coordination.',
    CONSTRAINT pk_account_team PRIMARY KEY(`account_team_id`)
) COMMENT 'Defines the internal Manufacturing team members assigned to manage a customer account, including account executives, technical sales engineers, customer success managers, and field service coordinators. Captures team member employee ID, role on account, primary flag, assignment start date, assignment end date, and coverage region. Sourced from Salesforce CRM Account Team and supports territory and quota management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`installed_base` (
    `installed_base_id` BIGINT COMMENT 'Unique surrogate identifier for each installed base record representing a single product or automation system installed at a customer site.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Installed base records belong to the customer account that purchased/owns the equipment. This FK establishes the primary ownership relationship. The denormalized customer_account_number STRING field i',
    `asset_register_id` BIGINT COMMENT 'Foreign key linking to finance.asset_register. Business justification: Customer-installed equipment (automation systems, infrastructure) often represents company-owned assets under lease or service contracts. Asset accounting tracks depreciation and book value for financ',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Installed base tracks which specific products/equipment are deployed at customer sites. Service, warranty, and maintenance operations require knowing exact product models installed at each account loc',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Installed base tracks which specific engineered components are deployed at customer sites. Service, warranty, and maintenance operations require linking customer installations to engineering component',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: Installed base tracks customer-owned equipment deployed at sites. Each installation references the configuration item (physical/logical asset) for warranty, maintenance, and service management. Used d',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: Installed equipment is covered by service contracts defining maintenance terms. Service teams validate contract coverage before dispatching technicians to installed assets.',
    `delivery_order_id` BIGINT COMMENT 'Foreign key linking to order.delivery_order. Business justification: Installed base references delivery - normalize by replacing delivery_note_number text with FK',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Installed base records reference specific equipment assets deployed at customer locations. Service teams use this to track what equipment is installed where for maintenance and support.',
    `plm_product_catalog_item_id` BIGINT COMMENT 'Identifier of the product definition in Siemens Teamcenter PLM, enabling traceability to the engineering Bill of Materials (BOM), design documentation, and Engineering Change Orders (ECOs).',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Installed equipment at customer sites must track the original equipment manufacturer/supplier for warranty, spare parts sourcing, and maintenance contracts. Critical for service operations and procure',
    `product_certification_id` BIGINT COMMENT 'Foreign key linking to compliance.product_certification. Business justification: Installed equipment at customer sites must reference valid product certifications (CE, UL, IEC). Service teams verify certification compliance for installed automation systems and electrical equipment',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: Installed base records track which production plant manufactured the equipment. Service teams use this for warranty validation, spare parts sourcing, and understanding product configuration based on m',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Installed base created from sales order - normalize by replacing sales_order_number text with FK',
    `sds_id` BIGINT COMMENT 'Foreign key linking to hse.sds. Business justification: Installed automation equipment containing chemicals/substances at customer sites requires SDS documentation for safety compliance. Service technicians access SDS before maintenance work on installed b',
    `serialized_unit_id` BIGINT COMMENT 'Foreign key linking to inventory.serialized_unit. Business justification: Installed base records track which specific serialized equipment (automation systems, drives) is deployed at customer sites. Essential for service contracts, maintenance scheduling, and spare parts pl',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Installed equipment at customer sites has assigned service technicians for maintenance and support. Field service operations track technician assignments for preventive maintenance scheduling and emer',
    `address_id` BIGINT COMMENT 'Foreign key linking to customer.address. Business justification: Installed base records contain embedded site address fields (site_address_line_1, site_city, site_country_code). Normalizing to the authoritative address repository eliminates duplication and enables ',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: Installed base equipment originated from R&D projects. Tracking which development project produced deployed automation systems enables warranty analysis, performance validation, and continuous improve',
    `commissioning_date` DATE COMMENT 'Date on which the installed product was formally commissioned and handed over to the customer for operational use, marking the start of the warranty period and SLA obligations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `connectivity_status` STRING COMMENT 'Current connectivity status of the installed product to the IIoT platform, indicating whether remote monitoring and telemetry data collection is active, used for proactive service and digital service upsell.. Valid values are `connected|disconnected|intermittent|not_applicable`',
    `country_of_origin_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating where the installed product was manufactured, required for customs declarations, export control compliance, and REACH/RoHS regulatory reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the installed base record was first created in the system, used for data lineage, audit trail, and compliance with data governance policies.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `crm_asset_code` STRING COMMENT 'Identifier of the installed asset record in Salesforce CRM Service Cloud, enabling traceability between the lakehouse silver layer and the CRM system of record.',
    `end_customer_account_number` STRING COMMENT 'Account number of the end-user customer operating the installed product when the direct customer is a distributor, OEM partner, or system integrator, enabling end-customer service and upgrade targeting.',
    `end_of_support_date` DATE COMMENT 'Date after which the manufacturer will no longer provide software updates, spare parts, or technical support for this product version, used to drive upgrade and migration campaigns.. Valid values are `^d{4}-d{2}-d{2}$`',
    `erp_equipment_number` STRING COMMENT 'Equipment master number from SAP S/4HANA Plant Maintenance (PM) module, uniquely identifying the physical asset in the ERP system for maintenance and cost tracking.',
    `firmware_version` STRING COMMENT 'Version identifier of the firmware currently installed on the product hardware, critical for cybersecurity vulnerability management, field update campaigns, and technical support.. Valid values are `^d+.d+(.d+)?(.d+)?$`',
    `hardware_revision` STRING COMMENT 'Hardware revision or board revision level of the installed product unit, used to determine spare parts compatibility, field upgrade feasibility, and technical support scope.',
    `iiot_device_code` STRING COMMENT 'Unique device identifier registered in the Siemens MindSphere IIoT platform for this installed product, enabling remote monitoring, predictive maintenance, and telemetry data correlation.',
    `installation_date` DATE COMMENT 'Date on which the product was physically installed at the customer site, used as the baseline for warranty period calculation and service history tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the installed base record, supporting change tracking, data freshness monitoring, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_service_date` DATE COMMENT 'Date of the most recent completed service or maintenance activity performed on the installed product, used for preventive maintenance scheduling and service history reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `next_planned_service_date` DATE COMMENT 'Scheduled date for the next preventive maintenance or planned service visit for the installed product, supporting field service capacity planning and customer communication.. Valid values are `^d{4}-d{2}-d{2}$`',
    `operational_status` STRING COMMENT 'Real-time or last-known operational condition of the installed product as reported by the IIoT platform or field service, distinct from the lifecycle status. Used for proactive maintenance and service dispatch prioritization.. Valid values are `running|stopped|fault|standby|unknown`',
    `product_category` STRING COMMENT 'High-level category classifying the type of installed product, used for service routing, spare parts planning, and installed base segmentation.. Valid values are `automation_system|electrification|smart_infrastructure|drive_system|control_panel|sensor|software|other`',
    `record_number` STRING COMMENT 'Human-readable business key uniquely identifying the installed base record across CRM and ERP systems, used for cross-system referencing and customer communications.. Valid values are `^IB-[A-Z0-9]{6,20}$`',
    `service_contract_number` STRING COMMENT 'Reference number of the active service or maintenance contract covering this installed product, linking the installed base to contractual service obligations and SLA terms.',
    `service_level` STRING COMMENT 'Service level tier assigned to this installed product under the active service contract, determining response time commitments, preventive maintenance frequency, and spare parts priority.. Valid values are `platinum|gold|silver|bronze|basic|none`',
    `service_territory` STRING COMMENT 'Assigned service territory or region responsible for field service delivery to the installation site, used for field engineer dispatch, SLA management, and service capacity planning.',
    `site_name` STRING COMMENT 'Name of the customer facility or plant where the product is installed (e.g., Frankfurt Assembly Plant), used for field service routing, logistics planning, and customer reporting.',
    `sku` STRING COMMENT 'Stock Keeping Unit code identifying the specific product variant installed at the customer site, linking to the product catalog for spare parts, upgrades, and service planning.',
    `software_version` STRING COMMENT 'Version identifier of the application software currently running on the installed product, used for compatibility checks, patch management, and upgrade eligibility assessment.. Valid values are `^d+.d+(.d+)?(.d+)?$`',
    `status` STRING COMMENT 'Current operational lifecycle status of the installed product, driving service eligibility, warranty checks, spare parts availability, and upgrade campaign targeting.. Valid values are `active|inactive|decommissioned|under_maintenance|pending_commissioning|end_of_life|returned`',
    `upgrade_eligibility_flag` BOOLEAN COMMENT 'Indicates whether the installed product is eligible for a hardware or software upgrade based on its current version, hardware revision, and product lifecycle phase, used to target upgrade campaigns.. Valid values are `true|false`',
    `warranty_expiry_date` DATE COMMENT 'Date on which the standard product warranty expires, used to determine warranty eligibility for service requests, spare parts claims, and triggering extended warranty or service contract renewal campaigns.. Valid values are `^d{4}-d{2}-d{2}$`',
    `warranty_start_date` DATE COMMENT 'Date from which the product warranty coverage becomes effective, typically aligned with the commissioning date or first use date as defined in the sales contract.. Valid values are `^d{4}-d{2}-d{2}$`',
    `warranty_type` STRING COMMENT 'Classification of the warranty coverage applicable to the installed product, determining the scope of repair, replacement, and labor obligations under the warranty agreement.. Valid values are `standard|extended|on_site|return_to_depot|parts_only|labor_only|none`',
    CONSTRAINT pk_installed_base PRIMARY KEY(`installed_base_id`)
) COMMENT 'Registry of Manufacturing products and automation systems installed and operating at customer sites, forming the foundation for after-sales service, warranty management, spare parts sales, and upgrade campaigns. Captures installed product SKU, serial number, installation site address, installation date, commissioning date, warranty expiry date, software version, firmware version, operational status, and assigned service territory. Links customer domain to asset and service domains.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`account_payment_term` (
    `account_payment_term_id` BIGINT COMMENT 'Unique surrogate identifier for each account payment term configuration record in the Databricks Silver Layer. Serves as the primary key for this entity.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Payment term configurations are account-specific. This FK establishes the ownership relationship between payment terms and the master account record. The denormalized account_number STRING field is re',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Payment terms may specify default GL accounts for cash discounts, early payment incentives, or late payment penalties. AR teams post these financial impacts during payment processing.',
    `additional_months` STRING COMMENT 'Number of additional calendar months added to the baseline date when calculating the payment due date. Used in conjunction with fixed_day_of_month for complex periodic payment terms (e.g., payment due on the 15th of the following month).. Valid values are `^d{1,2}$`',
    `advance_payment_percent` DECIMAL(18,2) COMMENT 'Percentage of the total invoice amount required as advance payment before production or shipment commences. Applicable for MTO (Make to Order) and ETO (Engineer to Order) scenarios. Zero if no advance payment is required.. Valid values are `^d{1,3}(.d{1,2})?$`',
    `approval_date` DATE COMMENT 'Date on which the payment term configuration was formally approved by the authorized approver. Used for audit trail and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approval_status` STRING COMMENT 'Approval workflow status for this payment term configuration. Non-standard or high-value payment terms (e.g., extended net days, high discount percentages) require credit and finance approval before activation.. Valid values are `approved|pending|rejected|draft|under_review|escalated`',
    `approved_by` STRING COMMENT 'Name or user ID of the finance or credit manager who approved this payment term configuration. Required for audit trail and SOX compliance for non-standard payment terms.',
    `baseline_date_type` STRING COMMENT 'Defines the reference date from which payment due dates and discount periods are calculated. Common options include invoice date, posting date, goods receipt date, or end of month. Critical for accurate DSO calculation and cash flow forecasting.. Valid values are `invoice_date|posting_date|goods_receipt_date|delivery_date|end_of_month`',
    `cash_discount_percent_1` DECIMAL(18,2) COMMENT 'First-tier early payment cash discount percentage offered to the customer (e.g., 2.00 for 2% discount). Applies if payment is received within the first discount period. Directly impacts revenue recognition and AR cash flow.. Valid values are `^d{1,3}(.d{1,2})?$`',
    `cash_discount_percent_2` DECIMAL(18,2) COMMENT 'Second-tier early payment cash discount percentage offered to the customer. Applies if payment is received within the second discount period but after the first discount period has expired. May be zero if only one discount tier is configured.. Valid values are `^d{1,3}(.d{1,2})?$`',
    `contract_reference_number` STRING COMMENT 'Reference number of the master sales contract, framework agreement, or blanket purchase order under which this payment term was negotiated and agreed. Links the payment term to its contractual basis.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customers country for which this payment term applies. Supports country-specific payment regulations, tax treatment, and compliance requirements.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this payment term configuration record was first created in the source system. Used for audit trail, data lineage, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `credit_control_area` STRING COMMENT 'SAP credit control area code that governs the credit management rules applicable to this payment term. Links the payment term to the customers credit profile and dunning procedures in SAP FI-AR.. Valid values are `^[A-Z0-9]{1,4}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the payment term applies (e.g., USD, EUR, GBP, JPY). Supports multi-currency operations for multinational customer accounts.. Valid values are `^[A-Z]{3}$`',
    `days_sales_outstanding_target` STRING COMMENT 'Target number of days sales outstanding (DSO) associated with this payment term, used for cash flow planning and AR performance benchmarking. Derived from the net due days and used as a KPI baseline.. Valid values are `^d{1,4}$`',
    `discount_days_1` STRING COMMENT 'Number of days from the invoice baseline date within which the customer must pay to qualify for the first-tier cash discount. For example, 10 in 2/10 Net 30 means 10 days for the 2% discount.. Valid values are `^d{1,3}$`',
    `discount_days_2` STRING COMMENT 'Number of days from the invoice baseline date within which the customer must pay to qualify for the second-tier cash discount. Represents the outer boundary of the second discount window.. Valid values are `^d{1,3}$`',
    `distribution_channel_code` STRING COMMENT 'SAP distribution channel code (e.g., 10=Direct Sales, 20=Wholesale, 30=OEM) that, together with sales organization and division, defines the sales area for which this payment term applies.. Valid values are `^[A-Z0-9]{1,2}$`',
    `division_code` STRING COMMENT 'SAP division code representing the product line or business unit (e.g., 01=Automation, 02=Electrification, 03=Smart Infrastructure). Completes the sales area definition alongside sales organization and distribution channel.. Valid values are `^[A-Z0-9]{1,2}$`',
    `dunning_procedure` STRING COMMENT 'SAP dunning procedure key assigned to this payment term configuration, defining the escalation schedule and communication templates for overdue payment reminders. Drives AR collections workflow.. Valid values are `^[A-Z0-9]{1,4}$`',
    `early_payment_incentive_flag` BOOLEAN COMMENT 'Indicates whether this payment term includes an early payment incentive program (e.g., supply chain finance, dynamic discounting) beyond the standard cash discount tiers. Supports working capital optimization initiatives.. Valid values are `true|false`',
    `effective_date` DATE COMMENT 'The date from which this payment term configuration becomes active and applicable to customer invoices. Supports time-bound payment term agreements and contract renewals.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'The date on which this payment term configuration expires and is no longer applicable. Null indicates an open-ended term with no scheduled expiry. Used for contract-bound payment arrangements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `fixed_day_of_month` STRING COMMENT 'Specific calendar day of the month on which payment is due (e.g., 15 or 30 for mid-month or end-of-month payment terms). Used for installment or periodic payment arrangements. Null if not applicable.. Valid values are `^([1-9]|[12][0-9]|3[01])$`',
    `incoterms_code` STRING COMMENT 'International Commercial Terms (Incoterms) code associated with this payment term configuration, defining the point of risk transfer and delivery obligations. Relevant for cross-border industrial manufacturing transactions.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `installment_plan_flag` BOOLEAN COMMENT 'Indicates whether this payment term involves multiple installment payments rather than a single lump-sum payment. When true, references an installment schedule defined in SAP FI.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'ISO 639-1 two-letter language code for the language in which the payment term description is maintained (e.g., EN, DE, FR, ZH). Supports multilingual customer-facing documents in global operations.. Valid values are `^[A-Z]{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this payment term configuration record. Supports change tracking, delta processing in the Silver Layer, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `net_due_days` STRING COMMENT 'Total number of days from the invoice baseline date by which the full invoice amount must be paid without any discount. For example, 30 in Net 30 or 2/10 Net 30. Drives dunning and overdue calculations in SAP FI-AR.. Valid values are `^d{1,4}$`',
    `payment_block_reason` STRING COMMENT 'Reason code indicating why outgoing or incoming payments associated with this term are blocked. Used in SAP FI to prevent premature payment processing during disputes or credit reviews.. Valid values are `none|credit_hold|dispute|legal_hold|manual_block|audit_hold`',
    `payment_method` STRING COMMENT 'The agreed payment instrument or method associated with this payment term (e.g., bank transfer, direct debit, letter of credit). Drives accounts receivable processing and cash application in SAP FI.. Valid values are `bank_transfer|check|credit_card|direct_debit|letter_of_credit|cash|electronic_funds_transfer|promissory_note`',
    `payment_term_description` STRING COMMENT 'Human-readable description of the payment term (e.g., Net 30 Days, 2/10 Net 30, Cash in Advance, 50% Advance 50% on Delivery). Used in customer-facing documents and AR reporting.',
    `payment_term_key` STRING COMMENT 'SAP S/4HANA payment term key (e.g., NT30, ZB14, CIA) that uniquely identifies the payment condition configuration in the ERP system. Used for matching and integration across SD and FI modules.. Valid values are `^[A-Z0-9]{1,10}$`',
    `payment_term_type` STRING COMMENT 'Classification of the payment term structure (e.g., standard net days, installment plan, advance payment, cash in advance, letter of credit). Drives AR processing logic and cash flow categorization.. Valid values are `standard|installment|advance|cash_in_advance|letter_of_credit|consignment|milestone|deferred`',
    `sales_organization_code` STRING COMMENT 'SAP sales organization code representing the organizational unit responsible for the sale of products or services. Payment terms may differ by sales organization for the same customer.. Valid values are `^[A-Z0-9]{1,4}$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this payment term configuration was sourced (e.g., SAP_S4HANA for SD/FI module). Supports data lineage and reconciliation in the Databricks Silver Layer.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|LEGACY_ERP`',
    `source_system_key` STRING COMMENT 'The natural or composite key from the source system (e.g., SAP S/4HANA payment term key + customer account + sales area combination) that uniquely identifies this record in the originating system. Used for data lineage and delta load processing.',
    `status` STRING COMMENT 'Current lifecycle status of the payment term configuration. Drives whether the term is applied to new invoices and whether it is visible in AR reporting.. Valid values are `active|inactive|pending_approval|expired|superseded|under_review`',
    CONSTRAINT pk_account_payment_term PRIMARY KEY(`account_payment_term_id`)
) COMMENT 'Customer-specific payment term configurations defining the agreed payment conditions for each account and sales area combination. Captures payment term key, description (e.g., Net 30, 2/10 Net 30, Cash in Advance), cash discount percentage, discount days, net due days, currency, effective date, and approval status. Managed in SAP S/4HANA SD/FI and directly impacts accounts receivable and cash flow planning.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`customer_contract` (
    `customer_contract_id` BIGINT COMMENT 'Primary key for customer_contract',
    `account_id` BIGINT COMMENT 'Foreign key linking to the B2B customer account that is party to this contract',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to the specific catalog item covered under this contract',
    `contract_id` BIGINT COMMENT 'Unique surrogate key identifying this customer-product contract record',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether this contract automatically renews at the end of the contract period',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Percentage discount off list price granted to this customer for this catalog item under this contract',
    `end_date` DATE COMMENT 'Expiration date of this contract agreement, after which terms may need renegotiation',
    `incoterms_override` STRING COMMENT 'Contract-specific Incoterms that override the account-level default for shipments of this catalog item',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity per order that the customer must purchase to receive the contracted pricing',
    `minimum_order_quantity_uom` STRING COMMENT 'Unit of measure for the minimum order quantity',
    `number` STRING COMMENT 'Business-assigned alphanumeric identifier for this contract, used in sales and legal documentation',
    `owner` STRING COMMENT 'Name or username of the sales representative or account manager responsible for managing this contract',
    `payment_terms_override` STRING COMMENT 'Contract-specific payment terms that override the account-level default payment terms for purchases of this catalog item',
    `price` DECIMAL(18,2) COMMENT 'Customer-specific negotiated unit price for this catalog item under this contract, may differ from list price',
    `price_currency` STRING COMMENT 'ISO 4217 three-letter currency code in which the contract price is denominated',
    `renewal_notice_days` STRING COMMENT 'Number of days before contract_end_date that renewal notification must be sent',
    `start_date` DATE COMMENT 'Effective start date of this contract agreement',
    `status` STRING COMMENT 'Current lifecycle status of this contract: DRAFT (under negotiation), ACTIVE (in force), SUSPENDED (temporarily inactive), EXPIRED (past end date), TERMINATED (cancelled before end date)',
    `volume_commitment` DECIMAL(18,2) COMMENT 'Minimum quantity of this catalog item that the customer commits to purchase during the contract period',
    `volume_commitment_uom` STRING COMMENT 'Unit of measure for the volume commitment (e.g., EA, KG, M)',
    CONSTRAINT pk_customer_contract PRIMARY KEY(`customer_contract_id`)
) COMMENT 'This association product represents the negotiated purchasing agreement between a B2B customer account and a specific catalog item. It captures customer-specific pricing, volume commitments, contract terms, and discount structures that exist only in the context of this commercial relationship. Each record links one account to one catalog item with the negotiated terms that govern purchases under this agreement.. Existence Justification: In industrial manufacturing B2B sales, customer accounts negotiate purchasing agreements for multiple catalog items, and each catalog item is sold to multiple customers under different contract terms. These contracts are actively managed operational entities with customer-specific pricing, volume commitments, discount structures, and contract lifecycle management (draft, active, renewal, termination). Sales teams and account managers create, negotiate, and maintain these contracts as a core business process.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`collaboration` (
    `collaboration_id` BIGINT COMMENT 'Unique system-generated identifier for this customers participation in a specific collaboration agreement',
    `account_id` BIGINT COMMENT 'Foreign key linking to the customer account participating in the collaboration agreement',
    `collaboration_agreement_id` BIGINT COMMENT 'Foreign key linking to the collaboration agreement in which the customer is participating',
    `confidentiality_level` STRING COMMENT 'Data classification level governing information sharing with this specific customer under the collaboration agreement. May differ by customer based on trust level and contractual terms.',
    `created_date` TIMESTAMP COMMENT 'System timestamp when this customer collaboration record was created',
    `deliverable_milestones` STRING COMMENT 'Narrative description of deliverables, milestones, or outcomes specific to this customers participation in the collaboration agreement. Captures customer-specific objectives within the broader research scope.',
    `end_date` DATE COMMENT 'Date on which this specific customers participation in the collaboration agreement ended or is scheduled to end. May differ from master agreement expiry_date if customer exits early.',
    `funding_amount` DECIMAL(18,2) COMMENT 'Total financial commitment by this specific customer to the collaboration agreement, representing their share of R&D costs, resource contributions, or sponsored research funding.',
    `ip_ownership_split` DECIMAL(18,2) COMMENT 'Percentage of foreground intellectual property ownership attributed to this specific customer under the collaboration agreement. Used when multiple customers participate with different IP ownership terms.',
    `last_modified_date` TIMESTAMP COMMENT 'System timestamp when this customer collaboration record was last updated',
    `participation_status` STRING COMMENT 'Current status of this customers participation in the collaboration agreement. Tracks whether the customer is actively engaged, has suspended participation, withdrawn early, or completed their commitment.',
    `primary_contact_name` STRING COMMENT 'Name of the primary technical or business contact from the customer organization responsible for this collaboration agreement.',
    `start_date` DATE COMMENT 'Date on which this specific customers participation in the collaboration agreement became effective. May differ from the master agreement effective_date if customer joined an existing multi-party agreement.',
    CONSTRAINT pk_collaboration PRIMARY KEY(`collaboration_id`)
) COMMENT 'This association product represents the contractual relationship between a customer account and a formal R&D collaboration agreement. It captures the customer-specific terms, financial commitments, IP ownership arrangements, and participation details that exist only in the context of this specific customers involvement in a collaborative research initiative. Each record links one customer account to one collaboration agreement with attributes governing that customers participation terms.. Existence Justification: Industrial manufacturers establish formal R&D collaboration agreements with multiple strategic customer accounts simultaneously (e.g., co-developing automation solutions with BMW, Volkswagen, and Tesla in parallel). Each customer account can participate in multiple collaborative research initiatives across different technology domains. The business actively manages customer-specific participation terms including funding commitments, IP ownership splits, confidentiality levels, and deliverable milestones that vary by customer within the same agreement.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` (
    `account_regulatory_applicability_id` BIGINT COMMENT 'Unique system-generated identifier for each account-regulatory requirement applicability record',
    `account_id` BIGINT COMMENT 'Foreign key linking to the customer account to which this regulatory requirement applies',
    `regulatory_requirement_id` BIGINT COMMENT 'Foreign key linking to the regulatory requirement that applies to this customer account',
    `applicability_basis` STRING COMMENT 'Primary basis for determining that this regulatory requirement applies to this account: INDUSTRY_CODE (based on NAICS/SIC), JURISDICTION (based on country/region), CONTRACT (contractual obligation), PRODUCT_SCOPE (products sold to customer), FACILITY_SCOPE (customer facility type), CUSTOMER_REQUEST (customer-mandated requirement)',
    `applicability_scope` STRING COMMENT 'Defines the scope of applicability of this regulatory requirement to this specific account: FULL (entire requirement applies), PARTIAL (only certain clauses apply), CONDITIONAL (applies under specific conditions), NOT_APPLICABLE (explicitly determined not applicable)',
    `assessment_date` DATE COMMENT 'Date on which the compliance status for this account-requirement combination was last assessed or verified by compliance team or auditor',
    `compliance_status` STRING COMMENT 'Current compliance status of this customer account with respect to this specific regulatory requirement: COMPLIANT (account meets requirement), NON_COMPLIANT (account fails requirement), IN_PROGRESS (remediation underway), NOT_ASSESSED (not yet evaluated), EXEMPT (exemption granted)',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this applicability record was created in the system',
    `customer_specific_interpretation` STRING COMMENT 'Free-text field capturing any customer-specific interpretation, contractual variation, or special conditions that modify how this regulatory requirement applies to this particular account (e.g., Customer contract specifies ISO 9001:2008 instead of 2015 version until 2025)',
    `effective_date` DATE COMMENT 'Date on which this regulatory requirement became or becomes applicable to this customer account, which may differ from the requirements general effective date based on contract terms or account-specific circumstances',
    `exemption_status` STRING COMMENT 'Status of any exemption request or granted exemption for this account from this regulatory requirement: NO_EXEMPTION (standard applicability), EXEMPTION_REQUESTED (under review), EXEMPTION_GRANTED (approved exemption), EXEMPTION_DENIED (request rejected), EXEMPTION_EXPIRED (exemption no longer valid)',
    `last_modified_date` TIMESTAMP COMMENT 'Timestamp when this applicability record was last updated',
    `next_assessment_due_date` DATE COMMENT 'Scheduled date for the next compliance assessment or audit of this account against this regulatory requirement, based on compliance_frequency from the requirement and account-specific assessment schedule',
    `responsible_compliance_officer` STRING COMMENT 'Name or employee ID of the compliance officer responsible for managing and monitoring this accounts compliance with this specific regulatory requirement',
    CONSTRAINT pk_account_regulatory_applicability PRIMARY KEY(`account_regulatory_applicability_id`)
) COMMENT 'This association product represents the applicability relationship between customer accounts and regulatory requirements. It captures which regulatory requirements apply to which customer accounts based on industry classification, geographic jurisdiction, contractual obligations, and product scope. Each record links one account to one regulatory requirement with attributes that define the scope, timing, and status of applicability.. Existence Justification: In industrial manufacturing, customer accounts operate under different regulatory regimes based on their industry (medical devices require FDA compliance, aerospace requires EASA/FAA, automotive requires IATF 16949), geographic jurisdiction (EU customers require CE marking and REACH compliance, California customers require CCPA), and contractual obligations (OEM partners may mandate specific ISO certifications). Compliance teams actively manage which regulatory requirements apply to which accounts, conduct periodic assessments, track compliance status, grant exemptions, and maintain customer-specific interpretations of requirements. This is an operational many-to-many relationship where both directions are genuinely many: one account is subject to multiple regulatory requirements simultaneously, and one regulatory requirement applies to multiple accounts across different industries and geographies.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` (
    `preferred_carrier_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each preferred carrier relationship record',
    `account_id` BIGINT COMMENT 'Foreign key linking to the customer account that has established this preferred carrier relationship',
    `carrier_id` BIGINT COMMENT 'Foreign key linking to the approved freight carrier in this preferred relationship',
    `account_number_with_carrier` STRING COMMENT 'The customers unique account identifier in the carriers billing and tracking system. Required for shipment booking and freight bill reconciliation.',
    `effective_date` DATE COMMENT 'Date from which this preferred carrier relationship became active and available for use in transportation planning and execution.',
    `expiry_date` DATE COMMENT 'Date on which this preferred carrier relationship expires or is scheduled for review. Null indicates an ongoing relationship with no defined end date.',
    `preferred_rank` STRING COMMENT 'Numeric ranking indicating the customers preference order for this carrier (1 = most preferred). Used by TMS for carrier selection logic when multiple carriers are available for a route.',
    `service_level` STRING COMMENT 'Service level(s) approved for this customer-carrier relationship. Constrains which carrier services can be used for this customers shipments.',
    `special_instructions` STRING COMMENT 'Free-text field capturing customer-specific handling requirements, delivery instructions, or operational constraints that apply when using this carrier for this customers shipments.',
    `status` STRING COMMENT 'Current operational status of this preferred carrier relationship. Only ACTIVE relationships are used in carrier selection logic.',
    CONSTRAINT pk_preferred_carrier PRIMARY KEY(`preferred_carrier_id`)
) COMMENT 'This association product represents the preferred carrier relationship between customer accounts and approved freight carriers. It captures customer-specific carrier preferences, service level agreements, and routing instructions used by transportation teams for carrier selection and route planning. Each record links one customer account to one carrier with relationship-specific attributes including preference ranking, approved service levels, carrier-specific account numbers, and special handling instructions.. Existence Justification: In industrial manufacturing operations, B2B customer accounts establish preferred carrier relationships with multiple approved freight carriers to support diverse shipping requirements across geographies, service levels, and product types. Each customer-carrier relationship is actively managed by transportation teams and captures relationship-specific data including preference rankings for carrier selection, approved service levels, customer-specific account numbers at each carrier, and special handling instructions. Carriers simultaneously serve multiple customer accounts, each with distinct contractual terms and operational requirements.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` (
    `account_delivery_zone_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each account-zone delivery configuration record',
    `account_id` BIGINT COMMENT 'Foreign key linking to the customer account that has delivery locations within this transport zone',
    `transport_zone_id` BIGINT COMMENT 'Foreign key linking to the transport zone where the customer account has delivery locations',
    `created_date` TIMESTAMP COMMENT 'System timestamp when this account-zone delivery configuration record was initially created',
    `delivery_priority` STRING COMMENT 'Priority level assigned to deliveries for this account within this zone, used by route planners to sequence stops and allocate carrier capacity',
    `delivery_window_end` STRING COMMENT 'End time of the acceptable delivery window for this account in this zone (HH:MM format, local time), used for appointment scheduling and route optimization',
    `delivery_window_start` STRING COMMENT 'Start time of the acceptable delivery window for this account in this zone (HH:MM format, local time), used for appointment scheduling and route optimization',
    `effective_date` DATE COMMENT 'Date from which this account-zone delivery configuration becomes active and should be used by TMS route planning and carrier assignment processes',
    `expiration_date` DATE COMMENT 'Date after which this account-zone delivery configuration is no longer valid, allowing for time-bound seasonal or contractual delivery arrangements',
    `last_modified_date` TIMESTAMP COMMENT 'System timestamp when this account-zone delivery configuration record was last updated',
    `modified_by` STRING COMMENT 'Username or identifier of the logistics operations user who last modified this account-zone delivery configuration',
    `requires_dock_appointment` BOOLEAN COMMENT 'Indicates whether deliveries to this account in this zone require advance dock appointment scheduling, impacting carrier dispatch and route planning lead times',
    `service_level` STRING COMMENT 'Contracted service level for deliveries to this account in this zone, defining expected transit time and delivery commitment',
    `special_requirements` STRING COMMENT 'Free-text field capturing zone-specific special requirements for this account such as dock appointment requirements, security clearances, unloading equipment needs, or access restrictions',
    `status` STRING COMMENT 'Current lifecycle status of this account-zone delivery configuration, controlling whether it is used in active route planning and carrier assignment',
    CONSTRAINT pk_account_delivery_zone PRIMARY KEY(`account_delivery_zone_id`)
) COMMENT 'This association product represents the delivery configuration between customer accounts and transport zones. It captures zone-specific delivery requirements, service levels, and operational constraints for each account-zone combination. Each record links one account to one transport zone with attributes that define how deliveries to that account within that zone should be executed.. Existence Justification: In industrial manufacturing logistics, customer accounts have delivery locations that span multiple geographic transport zones (e.g., a national OEM has facilities in multiple freight pricing regions), and each transport zone serves delivery locations for multiple customer accounts. The business actively manages zone-specific delivery configurations including time windows, service levels, priority handling, and special requirements (dock appointments, security clearances) that vary by account-zone combination. Route planners and TMS systems use these configurations for delivery scheduling and zone optimization.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`account_contract` (
    `account_contract_id` BIGINT COMMENT 'Unique surrogate key identifying this specific account-contract relationship record',
    `account_id` BIGINT COMMENT 'Foreign key linking to the B2B customer account that is party to this IT contract agreement',
    `it_contract_id` BIGINT COMMENT 'Foreign key linking to the IT contract that applies to this customer account',
    `account_manager` STRING COMMENT 'Name of the account manager or customer success manager responsible for managing this contract relationship with this specific customer account.',
    `billing_frequency` STRING COMMENT 'The frequency at which this customer account is invoiced for this IT contract (e.g., Monthly, Quarterly, Annually). May differ from the master contract payment_schedule if customer-specific billing terms were negotiated.',
    `contract_value` DECIMAL(18,2) COMMENT 'The total committed financial value of this IT contract for this specific customer account over the contract term. May represent a portion of the master contract value if multiple customers share the contract.',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this account-contract relationship record was created in the system',
    `customer_contract_reference` STRING COMMENT 'The customers own internal contract or purchase order reference number for this IT contract agreement. Used for customer invoicing and reconciliation.',
    `end_date` DATE COMMENT 'The scheduled expiration date of this IT contract for this specific customer account. Triggers renewal planning workflows and notice period tracking.',
    `last_modified_date` TIMESTAMP COMMENT 'Timestamp when this account-contract relationship record was last updated',
    `renewal_status` STRING COMMENT 'Current status of the contract renewal process for this specific customer account. Tracks the renewal lifecycle from initial review through final decision.',
    `service_scope` STRING COMMENT 'Description of the specific services, systems, or sites covered under this IT contract for this customer account. Defines what is in-scope vs out-of-scope for support and maintenance.',
    `start_date` DATE COMMENT 'The effective commencement date of this IT contract for this specific customer account. May differ from the master contract start_date if the customer was added to an existing multi-customer contract.',
    CONSTRAINT pk_account_contract PRIMARY KEY(`account_contract_id`)
) COMMENT 'This association product represents the contractual relationship between a customer account and an IT/technology contract. It captures customer-specific contract terms, pricing, service scope, and renewal tracking for each account-contract pairing. Each record links one account to one it_contract with attributes that exist only in the context of this specific customer-contract agreement.. Existence Justification: In industrial manufacturing, B2B customer accounts frequently have multiple concurrent IT/OT service contracts (e.g., SAP maintenance, Siemens PLC support, Azure cloud services, Rockwell Automation licenses), and each enterprise IT contract often covers multiple customer accounts (e.g., a global SAP support contract covering multiple subsidiaries or customer sites). Contract management teams actively manage these relationships, tracking customer-specific terms, pricing allocations, service scopes, billing arrangements, and renewal timelines for each account-contract pairing.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`license_entitlement` (
    `license_entitlement_id` BIGINT COMMENT 'Unique system-generated identifier for each customer-specific license entitlement record',
    `account_id` BIGINT COMMENT 'Foreign key to customer.account identifying the customer account holding this entitlement',
    `software_license_id` BIGINT COMMENT 'Foreign key linking to the software license being entitled to the customer account',
    `activation_date` DATE COMMENT 'Date on which this customer accounts entitlement to use this software license was activated and became effective',
    `contract_reference` STRING COMMENT 'Reference number or identifier of the master service agreement, enterprise license agreement (ELA), or purchase contract under which this entitlement was granted to the customer account',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this license entitlement record was created in the system',
    `expiration_date` DATE COMMENT 'Date on which this customer accounts entitlement to use this software license expires. May differ from the master license expiry_date if customer has a custom contract term.',
    `last_modified_date` TIMESTAMP COMMENT 'Timestamp when this license entitlement record was last updated',
    `license_quantity` STRING COMMENT 'Number of license seats, users, devices, cores, or instances allocated to this specific customer account under this entitlement. This is customer-specific and may differ from the master license total_entitlements.',
    `license_type` STRING COMMENT 'The specific licensing model under which this customer account is authorized to use this software (e.g., Perpetual, Subscription, Concurrent, Named User). Captures customer-specific licensing terms that may vary from the master license default.',
    `maintenance_level` STRING COMMENT 'The tier of vendor maintenance and support services included with this customers license entitlement (e.g., Standard, Premium, Enterprise). Defines SLA, support hours, and escalation rights for this customer-license combination.',
    `status` STRING COMMENT 'Current lifecycle status of this customer-specific license entitlement',
    `usage_rights` STRING COMMENT 'Textual description of the specific usage rights, restrictions, or scope granted to this customer account under this license entitlement (e.g., Production use only, Development and testing, Global deployment, Single site)',
    CONSTRAINT pk_license_entitlement PRIMARY KEY(`license_entitlement_id`)
) COMMENT 'This association product represents the contractual entitlement between a customer account and a software license. It captures the customer-specific licensing terms, quantities, activation dates, expiration dates, usage rights, and maintenance levels that exist only in the context of this account-license relationship. Each record links one account to one software license with attributes that define the specific terms under which that customer is authorized to use that software.. Existence Justification: In industrial manufacturing, customer accounts (OEMs, system integrators, distributors) license multiple software products (ERP, MES, CAD/CAM, SCADA) simultaneously, and each software license can be entitled to multiple customer accounts with different quantities, terms, and maintenance levels. Software Asset Management (SAM) teams actively manage these entitlements as distinct business records, tracking customer-specific activation dates, expiration dates, license quantities, usage rights, and maintenance levels that vary by customer-license combination.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`contact_system_access` (
    `contact_system_access_id` BIGINT COMMENT 'Unique surrogate identifier for each contact-system access provisioning record',
    `contact_id` BIGINT COMMENT 'Foreign key linking to the customer contact who is the beneficiary of system access',
    `user_access_request_id` BIGINT COMMENT 'Foreign key to technology.user_access_request identifying the IAM request that provisioned this access',
    `access_granted_timestamp` TIMESTAMP COMMENT 'Date and time when access was technically provisioned in the target system(s), marking when the contact could first authenticate and use the system.',
    `access_level` STRING COMMENT 'Degree of access granted to the contact for the target system, ranging from read-only to administrative privileges. Explicitly identified in detection reasoning as relationship data.',
    `access_purpose` STRING COMMENT 'Business justification or purpose for granting this specific access to the contact (e.g., remote equipment monitoring, engineering collaboration, customer portal access). Explicitly identified in detection reasoning as relationship data.',
    `approval_date` DATE COMMENT 'Date when the access request was formally approved by the designated approver. Explicitly identified in detection reasoning as relationship data.',
    `approval_status` STRING COMMENT 'Current approval and lifecycle status of this specific contact-system access. Explicitly identified in detection reasoning as relationship data.',
    `expiration_date` DATE COMMENT 'Date when the granted access will expire and require renewal or recertification. Explicitly identified in detection reasoning as relationship data.',
    `is_active` BOOLEAN COMMENT 'Indicates whether this access is currently active and usable by the contact, or has been deprovisioned/suspended.',
    `last_access_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent successful authentication or system usage by this contact, used for access recertification and dormant account identification.',
    `provisioned_systems` STRING COMMENT 'Comma-separated list or JSON array of specific systems or system components provisioned as part of this access grant. Explicitly identified in detection reasoning as relationship data.',
    CONSTRAINT pk_contact_system_access PRIMARY KEY(`contact_system_access_id`)
) COMMENT 'This association product represents the access provisioning relationship between external customer contacts and enterprise IT/OT systems. It captures the IAM lifecycle for B2B customer users who require access to customer portals, remote monitoring platforms, engineering collaboration tools, and other systems. Each record links one contact to one access request with attributes that track approval, provisioning status, access levels, and expiration dates specific to that contact-system combination.. Existence Justification: In industrial manufacturing B2B environments, customer contacts (procurement managers, engineering leads, plant managers) require access to multiple enterprise systems over time (customer portals, remote monitoring platforms, PLM collaboration tools, SCADA systems), and each system has multiple authorized external users. IT security and IAM teams actively manage these contact-system access relationships as distinct operational records, tracking approval workflows, access levels, expiration dates, and provisioning status for each contact-system combination. This is not a simple reference but an operational IAM governance process where the relationship itself carries critical compliance and security data.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`approval` (
    `approval_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each SKU approval record',
    `account_id` BIGINT COMMENT 'Foreign key linking to the industrial customer account that has approved this SKU for purchase',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to the SKU that has been qualified and approved by the customer',
    `approved_by` STRING COMMENT 'Name or identifier of the customer representative (typically procurement manager, quality engineer, or technical authority) who authorized the SKU approval',
    `approved_date` DATE COMMENT 'Date on which the customer formally approved this SKU for purchase following successful qualification testing and certification',
    `certification_document` STRING COMMENT 'Document management system reference or file path to the formal certification document, test report, or approval letter issued by the customer confirming SKU qualification',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this approval record was initially created in the system',
    `expiration_date` DATE COMMENT 'Date on which this SKU approval expires and requires re-qualification. Common in industries with periodic re-certification requirements (aerospace, medical devices, automotive).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp when this approval record was last updated',
    `qualification_notes` STRING COMMENT 'Free-text notes capturing customer-specific requirements, testing conditions, approved use cases, or restrictions associated with this SKU approval',
    `qualification_status` STRING COMMENT 'Current lifecycle status of the SKU qualification for this customer. PENDING indicates qualification initiated but testing not started. IN_QUALIFICATION indicates active testing and certification process. APPROVED indicates SKU is qualified and orderable. SUSPENDED indicates temporary hold on purchases pending re-certification. REVOKED indicates approval withdrawn due to quality or compliance issues. EXPIRED indicates approval lapsed and requires renewal.',
    `technical_specification_reference` STRING COMMENT 'Reference identifier or document number for the customer-specific technical specification or drawing that this SKU was qualified against. Links to engineering documentation system.',
    CONSTRAINT pk_approval PRIMARY KEY(`approval_id`)
) COMMENT 'This association product represents the formal qualification and approval process between industrial customer accounts and specific SKUs. It captures the business-critical vendor qualification workflow where customers certify that specific SKUs meet their technical, safety, and regulatory requirements before they can be purchased. Each record links one account to one approved SKU with qualification metadata including approval dates, certification documents, technical specifications, and approval authority.. Existence Justification: In industrial manufacturing, B2B customers maintain Approved Vendor Lists (AVLs) where specific SKUs must undergo formal qualification and certification before they can be purchased, especially for safety-critical, regulated, or mission-critical components. A single customer approves hundreds or thousands of SKUs across their product portfolio, and a single SKU (e.g., a standard automation component) is approved by multiple customers through independent qualification processes. Each approval is a managed business entity with its own lifecycle, certification documentation, expiration dates, and approval authority.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`approved_component_list` (
    `approved_component_list_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each customer-component approval record',
    `account_id` BIGINT COMMENT 'Foreign key linking to the customer account that has approved this component',
    `component_id` BIGINT COMMENT 'Foreign key linking to the engineered component that has been approved by this customer',
    `annual_volume_commitment` DECIMAL(18,2) COMMENT 'Estimated or contracted annual volume quantity of this component that the customer commits to purchase',
    `approved_date` DATE COMMENT 'Date on which the customer formally approved this component for use in their projects or systems',
    `customer_part_number` STRING COMMENT 'Customer-specific part number or SKU assigned to this component in the customers internal systems for cross-reference and ordering',
    `effective_from_date` DATE COMMENT 'Date from which this component approval becomes effective for ordering and use by the customer',
    `effective_to_date` DATE COMMENT 'Date on which this component approval expires or is scheduled for review, null if indefinite',
    `notes` STRING COMMENT 'Free-text notes capturing special conditions, restrictions, or context related to this customer-component approval',
    `price_agreement_reference` STRING COMMENT 'Reference number or identifier of the pricing agreement or contract that governs the commercial terms for this customer-component combination',
    `qualification_engineer` STRING COMMENT 'Name or employee ID of the engineering representative responsible for managing the technical qualification of this component with this customer',
    `qualification_status` STRING COMMENT 'Current status of the component qualification process with this customer (e.g., PENDING, QUALIFIED, APPROVED, CONDITIONAL, SUSPENDED, OBSOLETE)',
    CONSTRAINT pk_approved_component_list PRIMARY KEY(`approved_component_list_id`)
) COMMENT 'This association product represents the formal approval relationship between customer accounts and engineered components. It captures the customer-specific qualification and commercial terms under which a component is approved for use in customer projects. Each record links one customer account to one component with approval status, customer-specific part numbering, pricing agreements, and volume commitments that exist only in the context of this approval relationship.. Existence Justification: In industrial manufacturing, customers maintain Approved Component Lists (ACLs) as a formal business process where B2B customers qualify and approve specific engineered components for use in their systems and projects. One customer approves many components across different product lines, and one component is approved by many different customers, each with their own qualification status, customer-specific part numbers, pricing agreements, and volume commitments. This is an operational relationship actively managed by sales, engineering, and procurement teams.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` (
    `account_certification_requirement_id` BIGINT COMMENT 'Unique surrogate key identifying each customer-specific certification requirement or acceptance record',
    `account_id` BIGINT COMMENT 'Foreign key linking to the B2B customer account that requires or has accepted this certification',
    `engineering_regulatory_certification_id` BIGINT COMMENT 'Foreign key linking to the regulatory certification that is required by or presented to this customer',
    `certification_document_reference` STRING COMMENT 'Document management reference or storage path to the customer-specific certification documentation, declaration of conformity, or acceptance letter provided to this customer.',
    `certification_scope` STRING COMMENT 'Customer-specific scope definition describing which products, product families, or components this certification applies to for this particular customer relationship. May differ from the certifications general scope.',
    `contract_reference` STRING COMMENT 'Reference to the customer contract, purchase order, or master agreement that stipulates this certification requirement.',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this customer certification requirement record was created in the system.',
    `customer_acceptance_date` DATE COMMENT 'Date on which the customer formally accepted or acknowledged this certification as meeting their regulatory or contractual requirements.',
    `last_updated_date` TIMESTAMP COMMENT 'Timestamp of the most recent update to this customer certification requirement record.',
    `notes` STRING COMMENT 'Free-text notes capturing customer-specific requirements, exceptions, or clarifications related to this certification requirement.',
    `requirement_status` STRING COMMENT 'Current status of this certification requirement for this customer. Required indicates customer mandates it, Accepted indicates customer has accepted the certification, Expired indicates validity period has lapsed, Waived indicates customer has waived the requirement.',
    `responsible_account_manager` STRING COMMENT 'Name or employee ID of the account manager or sales representative responsible for managing this certification requirement with the customer.',
    `valid_from_date` DATE COMMENT 'Date from which this certification is valid and accepted for this customer relationship. May differ from the certifications issue date based on customer acceptance timing.',
    `valid_to_date` DATE COMMENT 'Date until which this certification remains valid for this customer relationship. May be earlier than the certifications expiry if customer contract or requirements change.',
    CONSTRAINT pk_account_certification_requirement PRIMARY KEY(`account_certification_requirement_id`)
) COMMENT 'This association product represents the customer-specific regulatory certification requirements and acceptance records between industrial customer accounts and product certifications. It captures which certifications are required by which customers, the scope of applicability, validity periods, and customer acceptance documentation. Each record links one account to one regulatory_certification with attributes that exist only in the context of this customer-specific requirement.. Existence Justification: In industrial manufacturing B2B relationships, customers frequently require multiple regulatory certifications (CE, UL, RoHS, REACH) for different product families or market access, and each certification is required by multiple customers with varying scope and acceptance terms. The relationship represents customer-specific certification requirements and acceptance records that are actively managed by account managers and compliance teams as part of contract fulfillment and export compliance processes.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` (
    `account_chemical_approval_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each customer-chemical approval record',
    `account_id` BIGINT COMMENT 'Foreign key linking to the B2B customer account that has been granted approval to use this chemical substance',
    `chemical_substance_id` BIGINT COMMENT 'Foreign key linking to the chemical substance that has been approved for use by this customer account',
    `approval_date` DATE COMMENT 'Date on which the customer account was granted approval to use this chemical substance, marking the start of the approval validity period',
    `approval_reference_number` STRING COMMENT 'External reference number or permit identifier associated with this approval (e.g., REACH authorization number, internal compliance case number)',
    `approval_status` STRING COMMENT 'Current lifecycle status of the customer-chemical approval. ACTIVE indicates valid authorization; PENDING indicates under review; EXPIRED indicates approval period has lapsed; SUSPENDED indicates temporary hold; REVOKED indicates permanent withdrawal of authorization',
    `approved_by` STRING COMMENT 'Name or username of the HSE compliance officer or regulatory manager who authorized this customer-chemical approval',
    `approved_usage_volume` DECIMAL(18,2) COMMENT 'Maximum volume or quantity of the chemical substance that the customer account is authorized to use within the approval period, measured in the unit specified in volume_unit_of_measure',
    `expiry_date` DATE COMMENT 'Date on which the customer-chemical approval expires and must be renewed or re-evaluated for continued usage authorization',
    `last_review_date` DATE COMMENT 'Date on which this customer-chemical approval was most recently reviewed or audited for continued compliance',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review or audit of this customer-chemical approval to ensure ongoing regulatory compliance',
    `notes` STRING COMMENT 'Additional notes, comments, or context regarding this customer-chemical approval (e.g., special conditions negotiated with customer, regulatory exemptions applied)',
    `usage_restrictions` STRING COMMENT 'Free-text description of customer-specific restrictions, conditions, or limitations imposed on the use of this chemical substance (e.g., approved only for specific product lines, restricted to certain facilities, requires additional PPE)',
    `volume_unit_of_measure` STRING COMMENT 'Unit of measure for the approved usage volume (e.g., KG for kilograms, L for liters, MT for metric tons)',
    CONSTRAINT pk_account_chemical_approval PRIMARY KEY(`account_chemical_approval_id`)
) COMMENT 'This association product represents the regulatory approval contract between a B2B customer account and a chemical substance for use in manufacturing operations. It captures customer-specific usage authorizations, volume limits, compliance restrictions, and approval lifecycle management required for REACH/RoHS regulatory compliance. Each record links one customer account to one approved chemical substance with attributes that exist only in the context of this customer-substance approval relationship.. Existence Justification: In industrial manufacturing, B2B customer accounts (OEMs, system integrators, distributors) require regulatory approval to use specific chemical substances in their operations, with each customer-substance combination governed by unique volume limits, usage restrictions, and compliance periods mandated by REACH/RoHS regulations. A single customer account uses multiple chemical substances across their manufacturing processes, and each chemical substance is approved for use by multiple customer accounts with customer-specific terms. HSE compliance teams actively manage these approvals as operational records, tracking approval dates, expiry dates, volume limits, and approval statuses for each customer-substance pairing.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` (
    `campaign_enrollment_id` BIGINT COMMENT 'Unique system-generated identifier for each campaign enrollment record',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to the sales campaign in which the contact is enrolled',
    `contact_id` BIGINT COMMENT 'Foreign key linking to the individual contact enrolled in the campaign',
    `sales_campaign_id` BIGINT COMMENT 'Foreign key to sales.sales_campaign.sales_campaign_id',
    `email_click_count` STRING COMMENT 'Number of times this contact clicked links in campaign emails for this enrollment',
    `email_open_count` STRING COMMENT 'Number of times this contact opened campaign emails for this enrollment',
    `email_sent_count` STRING COMMENT 'Number of campaign emails sent to this contact as part of this enrollment',
    `engagement_score` DECIMAL(18,2) COMMENT 'Calculated engagement score for this contact within this specific campaign, based on email opens, clicks, downloads, and other interaction metrics',
    `enrollment_date` DATE COMMENT 'Date when the contact was enrolled into this specific campaign, sourced from marketing automation system',
    `enrollment_status` STRING COMMENT 'Current lifecycle status of this enrollment (active, completed, paused, removed)',
    `last_interaction_date` DATE COMMENT 'Date of the most recent interaction (email open, click, form submission) by this contact with this campaign',
    `lead_generated_flag` BOOLEAN COMMENT 'Indicates whether this campaign enrollment resulted in a qualified lead being created',
    `opportunity_generated_flag` BOOLEAN COMMENT 'Indicates whether this campaign enrollment resulted in a sales opportunity being created',
    `response_status` STRING COMMENT 'Current response status of the contact for this campaign enrollment (responded, not_responded, bounced, opted_out)',
    `source_system` STRING COMMENT 'Marketing automation or CRM system that recorded this enrollment (e.g., Salesforce Campaign Member, Marketo Program Member)',
    `unsubscribe_date` DATE COMMENT 'Date when the contact unsubscribed from this campaign, if applicable',
    `unsubscribe_flag` BOOLEAN COMMENT 'Indicates whether the contact unsubscribed from this specific campaign (campaign-level opt-out, distinct from global email_opt_out)',
    CONSTRAINT pk_campaign_enrollment PRIMARY KEY(`campaign_enrollment_id`)
) COMMENT 'This association product represents the enrollment of individual contacts into targeted sales campaigns. It captures marketing automation tracking data including enrollment timing, engagement metrics, response behavior, and opt-out status. Each record links one contact to one sales_campaign with attributes that exist only in the context of this relationship, enabling multi-touch campaign attribution and contact journey analysis.. Existence Justification: In industrial manufacturing sales operations, individual contacts (procurement managers, engineering leads, plant managers) are enrolled in multiple sales campaigns simultaneously through marketing automation systems. A single contact may be in a product launch campaign, an end-of-life promotion, and a vertical market initiative concurrently. Each campaign targets hundreds or thousands of contacts. The business actively manages these enrollments, tracking engagement metrics, response behavior, and attribution for each contact-campaign combination.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ADD CONSTRAINT `fk_customer_sla_agreement_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ADD CONSTRAINT `fk_customer_partner_function_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ADD CONSTRAINT `fk_customer_account_classification_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `manufacturing_ecm`.`customer`.`segment`(`segment_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ADD CONSTRAINT `fk_customer_pricing_agreement_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `manufacturing_ecm`.`customer`.`segment`(`segment_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_case_id` FOREIGN KEY (`case_id`) REFERENCES `manufacturing_ecm`.`customer`.`case`(`case_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_customer_opportunity_id` FOREIGN KEY (`customer_opportunity_id`) REFERENCES `manufacturing_ecm`.`customer`.`customer_opportunity`(`customer_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ADD CONSTRAINT `fk_customer_customer_opportunity_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `manufacturing_ecm`.`customer`.`segment`(`segment_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ADD CONSTRAINT `fk_customer_nps_response_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ADD CONSTRAINT `fk_customer_account_contact_role_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ADD CONSTRAINT `fk_customer_consent_record_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ADD CONSTRAINT `fk_customer_consent_record_crm_contact_id` FOREIGN KEY (`crm_contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ADD CONSTRAINT `fk_customer_communication_preference_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`customer`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ADD CONSTRAINT `fk_customer_contact_system_access_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ADD CONSTRAINT `fk_customer_campaign_enrollment_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`customer` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `manufacturing_ecm`.`customer` SET TAGS ('dbx_domain' = 'customer');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` SET TAGS ('dbx_subdomain' = 'account_management');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `account_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `ccpa_opt_out` SET TAGS ('dbx_business_glossary_term' = 'California Consumer Privacy Act (CCPA) Opt-Out Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `ccpa_opt_out` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Contact Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Contact Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `crm_contact_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Relationship Management (CRM) Contact ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `data_subject_request_status` SET TAGS ('dbx_business_glossary_term' = 'Data Subject Request (DSR) Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `data_subject_request_status` SET TAGS ('dbx_value_regex' = 'none|access_requested|deletion_requested|portability_requested|rectification_requested|completed');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `department` SET TAGS ('dbx_business_glossary_term' = 'Contact Department');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `email` SET TAGS ('dbx_business_glossary_term' = 'Contact Primary Email Address');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `email_opt_in` SET TAGS ('dbx_business_glossary_term' = 'Email Marketing Opt-In Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `email_opt_in` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `email_opt_in` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `email_opt_in` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `email_opt_out` SET TAGS ('dbx_business_glossary_term' = 'Email Marketing Opt-Out Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `email_opt_out` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `email_opt_out` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `email_opt_out` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `first_name` SET TAGS ('dbx_business_glossary_term' = 'Contact First Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `first_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `first_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `gdpr_consent_date` SET TAGS ('dbx_business_glossary_term' = 'General Data Protection Regulation (GDPR) Consent Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `gdpr_consent_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `gdpr_consent_status` SET TAGS ('dbx_business_glossary_term' = 'General Data Protection Regulation (GDPR) Consent Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `gdpr_consent_status` SET TAGS ('dbx_value_regex' = 'granted|withdrawn|pending|not_applicable');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `is_decision_maker` SET TAGS ('dbx_business_glossary_term' = 'Is Decision Maker Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `is_decision_maker` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `is_influencer` SET TAGS ('dbx_business_glossary_term' = 'Is Influencer Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `is_influencer` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `is_primary_contact` SET TAGS ('dbx_business_glossary_term' = 'Is Primary Contact Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `is_primary_contact` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `job_title` SET TAGS ('dbx_business_glossary_term' = 'Contact Job Title');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `last_activity_date` SET TAGS ('dbx_business_glossary_term' = 'Contact Last Activity Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `last_activity_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `last_contacted_date` SET TAGS ('dbx_business_glossary_term' = 'Contact Last Contacted Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `last_contacted_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Contact Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `last_name` SET TAGS ('dbx_business_glossary_term' = 'Contact Last Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `last_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `last_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `lead_source` SET TAGS ('dbx_business_glossary_term' = 'Contact Lead Source');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `lead_source` SET TAGS ('dbx_value_regex' = 'web|trade_show|referral|cold_outreach|partner|inbound_call|marketing_campaign|existing_customer|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `linkedin_profile_url` SET TAGS ('dbx_business_glossary_term' = 'Contact LinkedIn Profile URL');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `linkedin_profile_url` SET TAGS ('dbx_value_regex' = '^https://(www.)?linkedin.com/in/[a-zA-Z0-9-_%]+/?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `linkedin_profile_url` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `mailing_city` SET TAGS ('dbx_business_glossary_term' = 'Contact Mailing City');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `mailing_city` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `mailing_city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `mailing_state_province` SET TAGS ('dbx_business_glossary_term' = 'Contact Mailing State or Province');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `mailing_state_province` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `mailing_state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `mobile_phone` SET TAGS ('dbx_business_glossary_term' = 'Contact Mobile Phone Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `mobile_phone` SET TAGS ('dbx_value_regex' = '^+?[0-9s-().]{7,20}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `mobile_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `mobile_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `nps_score` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS)');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `nps_score` SET TAGS ('dbx_value_regex' = '^([0-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `phone` SET TAGS ('dbx_business_glossary_term' = 'Contact Business Phone Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `phone` SET TAGS ('dbx_value_regex' = '^+?[0-9s-().]{7,20}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `phone_opt_out` SET TAGS ('dbx_business_glossary_term' = 'Phone Communication Opt-Out Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `phone_opt_out` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `phone_opt_out` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `phone_opt_out` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `preferred_language` SET TAGS ('dbx_business_glossary_term' = 'Contact Preferred Language');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `preferred_language` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `record_effective_date` SET TAGS ('dbx_business_glossary_term' = 'Contact Record Effective Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `record_effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `reports_to_name` SET TAGS ('dbx_business_glossary_term' = 'Reports To Contact Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `role` SET TAGS ('dbx_business_glossary_term' = 'Contact Role Classification');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `role` SET TAGS ('dbx_value_regex' = 'technical|commercial|executive|operational|financial|quality|logistics|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `salutation` SET TAGS ('dbx_business_glossary_term' = 'Contact Salutation');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `salutation` SET TAGS ('dbx_value_regex' = 'Mr.|Ms.|Mrs.|Dr.|Prof.|Eng.');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `sap_business_partner_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Business Partner ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Contact Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce_crm|sap_s4hana|manual_entry|data_import|web_form|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Contact Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|do_not_contact|deceased|merged');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` SET TAGS ('dbx_subdomain' = 'account_management');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `account_hierarchy_id` SET TAGS ('dbx_business_glossary_term' = 'Account Hierarchy ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `account_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `parent_account_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `root_account_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `account_group_code` SET TAGS ('dbx_business_glossary_term' = 'Account Group Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Approval Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Approval Authority');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `child_account_code` SET TAGS ('dbx_business_glossary_term' = 'Child Account Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `consolidated_credit_limit` SET TAGS ('dbx_business_glossary_term' = 'Consolidated Credit Limit');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `consolidated_credit_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `consolidation_method` SET TAGS ('dbx_business_glossary_term' = 'Financial Consolidation Method');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `consolidation_method` SET TAGS ('dbx_value_regex' = 'full_consolidation|proportional_consolidation|equity_method|cost_method|not_consolidated');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Master Contract Reference Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Child Account Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `credit_limit_currency` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit Currency Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `credit_limit_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `customer_classification` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Classification');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `customer_classification` SET TAGS ('dbx_value_regex' = 'strategic|key_account|standard|distributor|oem_partner|system_integrator|end_user|prospect');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Effective Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Expiry Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `global_account_manager` SET TAGS ('dbx_business_glossary_term' = 'Global Account Manager Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `hierarchy_code` SET TAGS ('dbx_business_glossary_term' = 'Account Hierarchy Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `hierarchy_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `hierarchy_depth` SET TAGS ('dbx_business_glossary_term' = 'Account Hierarchy Depth');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `hierarchy_depth` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_business_glossary_term' = 'Account Hierarchy Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `hierarchy_path` SET TAGS ('dbx_business_glossary_term' = 'Account Hierarchy Path');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `hierarchy_type` SET TAGS ('dbx_business_glossary_term' = 'Account Hierarchy Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `hierarchy_type` SET TAGS ('dbx_value_regex' = 'corporate|sales|credit|reporting|legal|operational');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `industry_sector_code` SET TAGS ('dbx_business_glossary_term' = 'Industry Sector Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `is_direct_relationship` SET TAGS ('dbx_business_glossary_term' = 'Is Direct Parent-Child Relationship Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `is_direct_relationship` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `is_primary_hierarchy` SET TAGS ('dbx_business_glossary_term' = 'Is Primary Hierarchy Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `is_primary_hierarchy` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Account Hierarchy Notes');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `ownership_percentage` SET TAGS ('dbx_business_glossary_term' = 'Ownership Percentage');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `ownership_percentage` SET TAGS ('dbx_value_regex' = '^(100(.00?)?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `ownership_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `parent_account_code` SET TAGS ('dbx_business_glossary_term' = 'Parent Account Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Child Account Region Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `relationship_type` SET TAGS ('dbx_business_glossary_term' = 'Account Relationship Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `relationship_type` SET TAGS ('dbx_value_regex' = 'subsidiary|division|affiliate|joint_venture|branch|holding|franchise|distributor|oem_partner|system_integrator');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `restructuring_reason` SET TAGS ('dbx_business_glossary_term' = 'Corporate Restructuring Reason');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `restructuring_reason` SET TAGS ('dbx_value_regex' = 'merger|acquisition|divestiture|spin_off|reorganization|joint_venture_formation|dissolution|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `root_account_code` SET TAGS ('dbx_business_glossary_term' = 'Root (Ultimate Parent) Account Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System of Record');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `source_system_record_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Record ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Account Hierarchy Relationship Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|terminated|under_review');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` SET TAGS ('dbx_subdomain' = 'account_management');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `address_id` SET TAGS ('dbx_business_glossary_term' = 'Address ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `address_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `address_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `access_restriction` SET TAGS ('dbx_business_glossary_term' = 'Site Access Restriction');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `access_restriction` SET TAGS ('dbx_value_regex' = 'none|security_clearance_required|appointment_required|restricted_hours|hazmat_certified_only|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `attention_line` SET TAGS ('dbx_business_glossary_term' = 'Attention Line');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `city` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `county_district` SET TAGS ('dbx_business_glossary_term' = 'County / District');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `customs_region_code` SET TAGS ('dbx_business_glossary_term' = 'Customs Region Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `data_quality_score` SET TAGS ('dbx_business_glossary_term' = 'Address Data Quality Score');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `data_quality_score` SET TAGS ('dbx_value_regex' = '^(100(.00)?|[0-9]{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `delivery_instruction` SET TAGS ('dbx_business_glossary_term' = 'Delivery Instruction');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `geocoding_accuracy` SET TAGS ('dbx_business_glossary_term' = 'Geocoding Accuracy Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `geocoding_accuracy` SET TAGS ('dbx_value_regex' = 'rooftop|range_interpolated|geometric_center|approximate|unverified');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `is_default_billing` SET TAGS ('dbx_business_glossary_term' = 'Default Billing Address Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `is_default_billing` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `is_default_shipping` SET TAGS ('dbx_business_glossary_term' = 'Default Shipping Address Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `is_default_shipping` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `is_primary` SET TAGS ('dbx_business_glossary_term' = 'Primary Address Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `is_primary` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `is_validated` SET TAGS ('dbx_business_glossary_term' = 'Address Validated Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `is_validated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Latitude');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `latitude` SET TAGS ('dbx_value_regex' = '^-?(90(.0+)?|[0-8]?d(.d+)?)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `line_1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `line_1` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `line_1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `line_2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `line_2` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `line_2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `line_3` SET TAGS ('dbx_business_glossary_term' = 'Address Line 3');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `line_3` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `line_3` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Longitude');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `longitude` SET TAGS ('dbx_value_regex' = '^-?(180(.0+)?|1[0-7]d(.d+)?|[0-9]?d(.d+)?)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `po_box` SET TAGS ('dbx_business_glossary_term' = 'Post Office (PO) Box');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `po_box` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `po_box` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `site_name` SET TAGS ('dbx_business_glossary_term' = 'Site Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'sap_s4hana|salesforce_crm|sap_ariba|infor_wms|manual|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `source_system_address_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Address ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `source_system_address_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `source_system_address_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State / Province');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `state_province` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Address Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_validation|archived|superseded');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `tax_jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Jurisdiction Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `time_zone` SET TAGS ('dbx_business_glossary_term' = 'Time Zone');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Address Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'headquarters|billing|shipping|plant_site|registered_office|mailing|remit_to|return|field_service|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `validation_source` SET TAGS ('dbx_business_glossary_term' = 'Address Validation Source');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `validation_source` SET TAGS ('dbx_value_regex' = 'usps_cass|loqate|google_maps|here_maps|melissa_data|manual|erp_master|crm_master|unverified');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `validation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Address Validation Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `vat_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Value Added Tax (VAT) Registration Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`address` ALTER COLUMN `vat_registration_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` SET TAGS ('dbx_subdomain' = 'account_management');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` SET TAGS ('dbx_original_name' = 'customer_segment');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `segment_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Segment ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `campaign_eligibility_flag` SET TAGS ('dbx_business_glossary_term' = 'Campaign Eligibility Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `campaign_eligibility_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Segment Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `contract_framework_required` SET TAGS ('dbx_business_glossary_term' = 'Contract Framework Required Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `contract_framework_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `credit_risk_category` SET TAGS ('dbx_business_glossary_term' = 'Credit Risk Category');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `credit_risk_category` SET TAGS ('dbx_value_regex' = 'Low|Medium|High|Very High|Blocked');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `credit_risk_category` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `crm_segment_code` SET TAGS ('dbx_business_glossary_term' = 'CRM Segment ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `data_privacy_consent_required` SET TAGS ('dbx_business_glossary_term' = 'Data Privacy Consent Required Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `data_privacy_consent_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Segment Description');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `discount_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'Discount Rate Percent');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `discount_rate_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `discount_rate_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `erp_customer_group_code` SET TAGS ('dbx_business_glossary_term' = 'ERP (Enterprise Resource Planning) Customer Group Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_value_regex' = 'EAR99|ECCN|ITAR|No Restriction|Restricted|Embargoed');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `geographic_region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `geographic_region` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `go_to_market_channel` SET TAGS ('dbx_business_glossary_term' = 'Go-to-Market (GTM) Channel');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `go_to_market_channel` SET TAGS ('dbx_value_regex' = 'Direct Sales|Distributor|Online|Partner Channel|Tender/RFQ|Framework Contract|Hybrid');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `industry_vertical` SET TAGS ('dbx_business_glossary_term' = 'Industry Vertical');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `industry_vertical` SET TAGS ('dbx_value_regex' = 'Automotive|Aerospace and Defense|Energy and Utilities|Food and Beverage|Pharmaceuticals|Chemicals|Electronics|Heavy Industry|Building and Infrastructure|Transportation|Other');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `last_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `manager_email` SET TAGS ('dbx_business_glossary_term' = 'Segment Manager Email Address');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `manager_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `manager_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `manager_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `manager_name` SET TAGS ('dbx_business_glossary_term' = 'Segment Manager Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Segment Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = 'Net 30|Net 45|Net 60|Net 90|Immediate|2/10 Net 30|Letter of Credit|Advance Payment');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `pricing_strategy` SET TAGS ('dbx_business_glossary_term' = 'Pricing Strategy');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `pricing_strategy` SET TAGS ('dbx_value_regex' = 'List Price|Negotiated Discount|Volume Rebate|Cost Plus|Fixed Contract|Framework Agreement|Spot Price');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `pricing_strategy` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `regulatory_compliance_scope` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Scope');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `revenue_band_currency` SET TAGS ('dbx_business_glossary_term' = 'Revenue Band Currency');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `revenue_band_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `revenue_band_max` SET TAGS ('dbx_business_glossary_term' = 'Revenue Band Maximum');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `revenue_band_max` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `revenue_band_min` SET TAGS ('dbx_business_glossary_term' = 'Revenue Band Minimum');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `revenue_band_min` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `review_cycle` SET TAGS ('dbx_business_glossary_term' = 'Review Cycle');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `review_cycle` SET TAGS ('dbx_value_regex' = 'Monthly|Quarterly|Semi-Annual|Annual|Ad Hoc');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'Platinum|Gold|Silver|Bronze|Standard');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|Salesforce_CRM|Manual|Other');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Segment Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|under_review|archived');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `strategic_priority_flag` SET TAGS ('dbx_business_glossary_term' = 'Strategic Priority Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `strategic_priority_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `sub_region` SET TAGS ('dbx_business_glossary_term' = 'Sub-Region');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `target_customer_count` SET TAGS ('dbx_business_glossary_term' = 'Target Customer Count');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `target_customer_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `tier` SET TAGS ('dbx_business_glossary_term' = 'Segment Tier');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `tier` SET TAGS ('dbx_value_regex' = 'Tier-1|Tier-2|Tier-3|Strategic|Standard|Emerging');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Segment Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`segment` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'OEM|Distributor|System Integrator|End User|Reseller|Partner|Government|Other');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` SET TAGS ('dbx_subdomain' = 'financial_operations');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_profile_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Profile ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `controlling_area_id` SET TAGS ('dbx_business_glossary_term' = 'Controlling Area Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_analyst_employee_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Analyst ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_account_currency` SET TAGS ('dbx_business_glossary_term' = 'Credit Account Currency');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_account_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_block_status` SET TAGS ('dbx_business_glossary_term' = 'Credit Block Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_block_status` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_check_method` SET TAGS ('dbx_business_glossary_term' = 'Credit Check Method');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_check_method` SET TAGS ('dbx_value_regex' = 'A|B|C|D');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_control_area` SET TAGS ('dbx_business_glossary_term' = 'Credit Control Area');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_exposure_amount` SET TAGS ('dbx_business_glossary_term' = 'Credit Exposure Amount');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_exposure_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_hold_reason` SET TAGS ('dbx_business_glossary_term' = 'Credit Hold Reason');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_hold_reason` SET TAGS ('dbx_value_regex' = 'OVERLIMIT|OVERDUE|RISK_CLASS|MANUAL|LEGAL_DISPUTE|BANKRUPTCY|PAYMENT_BEHAVIOR|OTHER');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_hold_reason_text` SET TAGS ('dbx_business_glossary_term' = 'Credit Hold Reason Text');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_insurance_limit` SET TAGS ('dbx_business_glossary_term' = 'Credit Insurance Limit');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_insurance_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_insurance_policy_number` SET TAGS ('dbx_business_glossary_term' = 'Credit Insurance Policy Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_insurance_policy_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_limit_account_currency` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit (Account Currency)');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_limit_account_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_limit_approved_date` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit Approved Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_limit_approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_limit_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit Expiry Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_limit_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_limit_group_currency` SET TAGS ('dbx_business_glossary_term' = 'Credit Limit (Group Currency)');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_limit_group_currency` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_risk_class` SET TAGS ('dbx_business_glossary_term' = 'Credit Risk Class');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_risk_class` SET TAGS ('dbx_value_regex' = '001|002|003|004|005');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_risk_class_description` SET TAGS ('dbx_business_glossary_term' = 'Credit Risk Class Description');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_segment` SET TAGS ('dbx_business_glossary_term' = 'Credit Segment');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_utilization_pct` SET TAGS ('dbx_business_glossary_term' = 'Credit Utilization Percentage');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_utilization_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `credit_utilization_pct` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `days_sales_outstanding` SET TAGS ('dbx_business_glossary_term' = 'Days Sales Outstanding (DSO)');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `days_sales_outstanding` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `dunning_bradstreet_rating` SET TAGS ('dbx_business_glossary_term' = 'Dun & Bradstreet (D&B) Rating');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `dunning_bradstreet_rating` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `dunning_bradstreet_score` SET TAGS ('dbx_business_glossary_term' = 'Dun & Bradstreet (D&B) PAYDEX Score');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `dunning_bradstreet_score` SET TAGS ('dbx_value_regex' = '^([1-9][0-9]?|100)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `dunning_bradstreet_score` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `dunning_level` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `dunning_level` SET TAGS ('dbx_value_regex' = '^[0-4]$');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Credit Profile Effective Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `group_currency` SET TAGS ('dbx_business_glossary_term' = 'Group Currency');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `group_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `internal_credit_score` SET TAGS ('dbx_business_glossary_term' = 'Internal Credit Score');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `internal_credit_score` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `last_dunning_date` SET TAGS ('dbx_business_glossary_term' = 'Last Dunning Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `last_dunning_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Credit Review Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `last_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Credit Review Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `oldest_open_item_days` SET TAGS ('dbx_business_glossary_term' = 'Oldest Open Item Age (Days)');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `overdue_amount` SET TAGS ('dbx_business_glossary_term' = 'Overdue Amount');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `overdue_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `payment_behavior_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Behavior Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `payment_behavior_code` SET TAGS ('dbx_value_regex' = 'EXCELLENT|GOOD|FAIR|POOR|DELINQUENT');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `review_frequency` SET TAGS ('dbx_business_glossary_term' = 'Credit Review Frequency');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `review_frequency` SET TAGS ('dbx_value_regex' = 'MONTHLY|QUARTERLY|SEMI_ANNUAL|ANNUAL|TRIGGERED');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `special_credit_terms` SET TAGS ('dbx_business_glossary_term' = 'Special Credit Terms');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `special_credit_terms` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Credit Profile Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'ACTIVE|INACTIVE|SUSPENDED|UNDER_REVIEW|CLOSED');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` SET TAGS ('dbx_subdomain' = 'service_delivery');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `sla_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Agreement ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `sla_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Definition Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `warranty_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Agreement Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_value_regex' = '^SLA-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Approval Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|revision_required');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Approved Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Auto-Renewal Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `business_unit` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Business Unit');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Category');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'customer_account|contract|product_line|regional|global');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `contract_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Linked Contract Reference Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `contract_reference_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Agreement Currency Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Description');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Effective Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `escalation_procedure` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Escalation Procedure');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `escalation_threshold_percent` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Escalation Threshold Percentage');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `escalation_threshold_percent` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Expiry Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `governing_law_country` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Governing Law Country');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `governing_law_country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Language Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `measurement_frequency` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Measurement Frequency');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `measurement_frequency` SET TAGS ('dbx_value_regex' = 'real_time|daily|weekly|monthly|quarterly|annually|per_incident|per_order');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `measurement_window` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Measurement Window');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `measurement_window` SET TAGS ('dbx_value_regex' = 'calendar_hours|business_hours|24x7|business_days_only');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `metric_name` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Metric Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `minimum_threshold_value` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Minimum Threshold Value');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `minimum_threshold_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `owner_name` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Owner Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `penalty_cap_value` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Penalty Cap Value');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `penalty_cap_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `penalty_cap_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `penalty_clause_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Penalty Clause Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `penalty_clause_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `penalty_rate` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Penalty Rate');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `penalty_rate` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `penalty_rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `penalty_type` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Penalty Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `penalty_type` SET TAGS ('dbx_value_regex' = 'percentage_of_invoice|fixed_amount|service_credit|rebate|none');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Priority Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|standard');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Region Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `region_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `renewal_date` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Renewal Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `renewal_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `review_frequency` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Review Frequency');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `review_frequency` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annually|annually|ad_hoc');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce_crm|sap_sd|manual|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `special_conditions` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Special Conditions');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `special_conditions` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|active|suspended|expired|terminated|under_review');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `target_value` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Target Value');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `target_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Termination Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `termination_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Termination Reason');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `termination_reason` SET TAGS ('dbx_value_regex' = 'contract_cancellation|customer_request|mutual_agreement|breach_by_customer|breach_by_supplier|business_restructuring|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard|custom');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'delivery_lead_time|order_fulfillment|technical_support_response|field_service|preventive_maintenance|spare_parts_availability|uptime_guarantee|quality_defect_resolution');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'hours|minutes|days|percentage|count|business_days');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Version Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` SET TAGS ('dbx_subdomain' = 'account_management');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `partner_function_id` SET TAGS ('dbx_business_glossary_term' = 'Partner Function ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'CRM Account ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `address_number` SET TAGS ('dbx_business_glossary_term' = 'Partner Address Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `address_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `address_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `address_number` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `assignment_level` SET TAGS ('dbx_business_glossary_term' = 'Partner Function Assignment Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `assignment_level` SET TAGS ('dbx_value_regex' = 'customer_master|sales_area|document_header|document_item');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `authorization_group` SET TAGS ('dbx_business_glossary_term' = 'Authorization Group Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `change_reason` SET TAGS ('dbx_business_glossary_term' = 'Partner Function Change Reason');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Partner Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `determination_procedure` SET TAGS ('dbx_business_glossary_term' = 'Partner Determination Procedure Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `determination_procedure` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `division` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Sales Document Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `erp_partner_number` SET TAGS ('dbx_business_glossary_term' = 'ERP Partner Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `erp_partner_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `function_category` SET TAGS ('dbx_business_glossary_term' = 'Partner Function Category');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `function_category` SET TAGS ('dbx_value_regex' = 'sold_to|ship_to|bill_to|payer|end_user|ordering_party|forwarding_agent|contact_person|sales_employee|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `function_code` SET TAGS ('dbx_business_glossary_term' = 'Partner Function Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `function_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,4}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `function_description` SET TAGS ('dbx_business_glossary_term' = 'Partner Function Description');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `intercompany_flag` SET TAGS ('dbx_business_glossary_term' = 'Intercompany Partner Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `intercompany_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `is_default` SET TAGS ('dbx_business_glossary_term' = 'Default Partner Function Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `is_default` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Mandatory Partner Function Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `item_category` SET TAGS ('dbx_business_glossary_term' = 'Sales Document Item Category');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Partner Communication Language Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `last_modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Partner Function Notes');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `partner_name` SET TAGS ('dbx_business_glossary_term' = 'Partner Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `partner_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `partner_type` SET TAGS ('dbx_business_glossary_term' = 'Partner Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `partner_type` SET TAGS ('dbx_value_regex' = 'customer|contact_person|vendor|employee|organization');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `sales_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Partner Function Sequence Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `sequence_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Natural Key');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Partner Function Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|blocked|expired');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `tax_jurisdiction_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Jurisdiction Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Partner Function Valid From Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Partner Function Valid To Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` SET TAGS ('dbx_subdomain' = 'account_management');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `account_classification_id` SET TAGS ('dbx_business_glossary_term' = 'Account Classification ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `segment_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Segment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `abc_class` SET TAGS ('dbx_business_glossary_term' = 'ABC Classification');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `abc_class` SET TAGS ('dbx_value_regex' = 'A|B|C|D');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `approved_by_user` SET TAGS ('dbx_business_glossary_term' = 'Classification Approved By User');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `assigned_by_user` SET TAGS ('dbx_business_glossary_term' = 'Classification Assigned By User');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `assigned_date` SET TAGS ('dbx_business_glossary_term' = 'Classification Assigned Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `assigned_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `change_reason` SET TAGS ('dbx_business_glossary_term' = 'Classification Change Reason');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `classification_code` SET TAGS ('dbx_business_glossary_term' = 'Classification Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `classification_description` SET TAGS ('dbx_business_glossary_term' = 'Classification Description');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `classification_language` SET TAGS ('dbx_business_glossary_term' = 'Classification Language');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `classification_language` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `classification_priority` SET TAGS ('dbx_business_glossary_term' = 'Classification Priority');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `classification_priority` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `classification_scheme` SET TAGS ('dbx_business_glossary_term' = 'Classification Scheme');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `classification_type` SET TAGS ('dbx_business_glossary_term' = 'Classification Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `classification_type` SET TAGS ('dbx_value_regex' = 'ABC|Nielsen|ECCN|EAR99|Industry Sector|Customer Segment|Credit Risk|Revenue Tier|Strategic|Regulatory|Export Control|Tax|Compliance|Custom');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `classification_value` SET TAGS ('dbx_business_glossary_term' = 'Classification Value');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `country_of_application` SET TAGS ('dbx_business_glossary_term' = 'Country of Application');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `country_of_application` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `credit_risk_class` SET TAGS ('dbx_business_glossary_term' = 'Credit Risk Classification');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `credit_risk_class` SET TAGS ('dbx_value_regex' = 'Low|Medium|High|Very High|Blocked|Under Review');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `credit_risk_class` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `customer_account_group` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Group');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `denied_party_screen_date` SET TAGS ('dbx_business_glossary_term' = 'Denied Party Screening Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `denied_party_screen_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `denied_party_screen_result` SET TAGS ('dbx_business_glossary_term' = 'Denied Party Screening Result');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `denied_party_screen_result` SET TAGS ('dbx_value_regex' = 'clear|match_found|potential_match|pending|not_screened');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `denied_party_screened` SET TAGS ('dbx_business_glossary_term' = 'Denied Party Screening Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `denied_party_screened` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `ear99_flag` SET TAGS ('dbx_business_glossary_term' = 'Export Administration Regulations 99 (EAR99) Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `ear99_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `eccn_code` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification Number (ECCN) Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `eccn_code` SET TAGS ('dbx_value_regex' = '^[0-9][A-Z][0-9]{3}[a-z]?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Classification Effective Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Classification Expiry Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `export_license_required` SET TAGS ('dbx_business_glossary_term' = 'Export License Required Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `export_license_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `industry_sector_code` SET TAGS ('dbx_business_glossary_term' = 'Industry Sector Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `industry_sector_name` SET TAGS ('dbx_business_glossary_term' = 'Industry Sector Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `is_primary` SET TAGS ('dbx_business_glossary_term' = 'Primary Classification Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `is_primary` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `pricing_group` SET TAGS ('dbx_business_glossary_term' = 'Pricing Group');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `reach_rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'REACH and RoHS Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `reach_rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `revenue_tier` SET TAGS ('dbx_business_glossary_term' = 'Revenue Tier');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `revenue_tier` SET TAGS ('dbx_value_regex' = 'Platinum|Gold|Silver|Bronze|Standard');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `review_date` SET TAGS ('dbx_business_glossary_term' = 'Classification Review Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `sales_district` SET TAGS ('dbx_business_glossary_term' = 'Sales District');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `sales_office` SET TAGS ('dbx_business_glossary_term' = 'Sales Office');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|Salesforce_CRM|SAP_Ariba|Manual|External_Agency|ERP|CRM');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `source_system_record_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Record ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Classification Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_review|expired|superseded|under_review');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `tax_classification` SET TAGS ('dbx_business_glossary_term' = 'Tax Classification');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `tax_classification` SET TAGS ('dbx_value_regex' = 'Taxable|Tax Exempt|Zero Rated|Reduced Rate|Not Applicable');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `tax_exemption_number` SET TAGS ('dbx_business_glossary_term' = 'Tax Exemption Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ALTER COLUMN `tax_exemption_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` SET TAGS ('dbx_subdomain' = 'account_management');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `sales_area_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Area Assignment ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `account_assignment_group` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment Group');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `account_assignment_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `authorization_group` SET TAGS ('dbx_business_glossary_term' = 'Authorization Group');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `authorization_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `billing_block_code` SET TAGS ('dbx_business_glossary_term' = 'Billing Block Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `billing_block_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9 ]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `customer_classification` SET TAGS ('dbx_business_glossary_term' = 'Customer Classification');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `customer_classification` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `customer_group_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Group Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `customer_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `customer_group_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Group Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `delivery_block_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Block Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `delivery_block_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9 ]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `delivery_priority` SET TAGS ('dbx_business_glossary_term' = 'Delivery Priority');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `delivery_priority` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `distribution_channel_name` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `division_code` SET TAGS ('dbx_business_glossary_term' = 'Division Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `division_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `division_name` SET TAGS ('dbx_business_glossary_term' = 'Division Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = '^(EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Location');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `invoice_dates_code` SET TAGS ('dbx_business_glossary_term' = 'Invoice Dates Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `invoice_dates_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `max_partial_deliveries` SET TAGS ('dbx_business_glossary_term' = 'Maximum Partial Deliveries');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `max_partial_deliveries` SET TAGS ('dbx_value_regex' = '^[0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `order_block_code` SET TAGS ('dbx_business_glossary_term' = 'Order Block Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `order_block_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9 ]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `order_combination_flag` SET TAGS ('dbx_business_glossary_term' = 'Order Combination Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `order_combination_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `order_probability_pct` SET TAGS ('dbx_business_glossary_term' = 'Order Probability Percentage');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `order_probability_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `partial_delivery_flag` SET TAGS ('dbx_business_glossary_term' = 'Partial Delivery Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `partial_delivery_flag` SET TAGS ('dbx_value_regex' = '^[A-Z]$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `price_list_type` SET TAGS ('dbx_business_glossary_term' = 'Price List Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `price_list_type` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `pricing_procedure` SET TAGS ('dbx_business_glossary_term' = 'Pricing Procedure');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `pricing_procedure` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `rebate_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Rebate Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `rebate_eligible_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `sales_district_code` SET TAGS ('dbx_business_glossary_term' = 'Sales District Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `sales_district_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `sales_group_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Group Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `sales_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `sales_office_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Office Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `sales_office_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `sales_org_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization (Sales Org) Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `sales_org_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `sales_org_name` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization (Sales Org) Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `shipping_condition` SET TAGS ('dbx_business_glossary_term' = 'Shipping Condition');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `shipping_condition` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `source_record_key` SET TAGS ('dbx_business_glossary_term' = 'Source Record Key');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `source_system_code` SET TAGS ('dbx_business_glossary_term' = 'Source System ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `source_system_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Sales Area Assignment Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|pending_review');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` SET TAGS ('dbx_subdomain' = 'financial_operations');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `pricing_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Pricing Agreement ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `product_price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Price List Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `segment_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Segment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `tax_code_id` SET TAGS ('dbx_business_glossary_term' = 'Tax Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `agreement_name` SET TAGS ('dbx_business_glossary_term' = 'Pricing Agreement Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Pricing Agreement Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_value_regex' = '^PA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Pricing Agreement Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'customer_specific_price|volume_rebate|special_discount|trade_promotion|contract_price|list_price_override|freight_allowance');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|escalated|withdrawn');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `approving_authority_level` SET TAGS ('dbx_business_glossary_term' = 'Approving Authority Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `approving_authority_level` SET TAGS ('dbx_value_regex' = 'sales_rep|sales_manager|regional_director|vp_sales|cfo|executive_committee');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `commercial_contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Commercial Contract Reference');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `condition_type_code` SET TAGS ('dbx_business_glossary_term' = 'SAP Condition Type Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Agreement Currency Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,4})?|[0-9]{1,2}(.[0-9]{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = 'direct|distributor|oem|online|retail|export');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `incoterms` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `is_exclusive` SET TAGS ('dbx_business_glossary_term' = 'Exclusive Agreement Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `is_exclusive` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `is_retroactive` SET TAGS ('dbx_business_glossary_term' = 'Retroactive Pricing Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `is_retroactive` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `minimum_order_value` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Value');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `minimum_order_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `price_list_type` SET TAGS ('dbx_business_glossary_term' = 'Price List Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `price_list_type` SET TAGS ('dbx_value_regex' = 'standard|oem|distributor|export|intercompany|promotional');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `price_per_quantity` SET TAGS ('dbx_business_glossary_term' = 'Price Per Quantity');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `rebate_percentage` SET TAGS ('dbx_business_glossary_term' = 'Volume Rebate Percentage');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `rebate_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,4})?|[0-9]{1,2}(.[0-9]{1,4})?)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `rebate_percentage` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `renewal_type` SET TAGS ('dbx_business_glossary_term' = 'Agreement Renewal Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `renewal_type` SET TAGS ('dbx_value_regex' = 'auto_renew|manual_renew|no_renewal');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `scope_type` SET TAGS ('dbx_business_glossary_term' = 'Agreement Scope Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `scope_type` SET TAGS ('dbx_value_regex' = 'single_product|product_group|material_group|product_hierarchy|all_products');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Pricing Agreement Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|active|expired|suspended|cancelled|superseded');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `superseded_by_agreement` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Agreement Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `target_volume` SET TAGS ('dbx_business_glossary_term' = 'Target Volume');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Agreement Version Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `valid_from` SET TAGS ('dbx_business_glossary_term' = 'Agreement Valid From Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `valid_from` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `valid_to` SET TAGS ('dbx_business_glossary_term' = 'Agreement Valid To Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ALTER COLUMN `valid_to` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` SET TAGS ('dbx_subdomain' = 'engagement_tracking');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `interaction_id` SET TAGS ('dbx_business_glossary_term' = 'Interaction ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `case_id` SET TAGS ('dbx_business_glossary_term' = 'Case Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `customer_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `assigned_representative_email` SET TAGS ('dbx_business_glossary_term' = 'Assigned Representative Email');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `assigned_representative_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `assigned_representative_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `assigned_representative_name` SET TAGS ('dbx_business_glossary_term' = 'Assigned Representative Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `assigned_representative_role` SET TAGS ('dbx_business_glossary_term' = 'Assigned Representative Role');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `assigned_representative_role` SET TAGS ('dbx_value_regex' = 'account_executive|sales_engineer|field_service_engineer|customer_success_manager|technical_sales_specialist|regional_sales_manager|service_technician|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `campaign_name` SET TAGS ('dbx_business_glossary_term' = 'Linked Marketing Campaign Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `channel` SET TAGS ('dbx_business_glossary_term' = 'Interaction Channel');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `channel` SET TAGS ('dbx_value_regex' = 'phone|email|in_person|virtual|web|chat|social_media|postal|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `date` SET TAGS ('dbx_business_glossary_term' = 'Interaction Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Interaction Description');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `direction` SET TAGS ('dbx_business_glossary_term' = 'Interaction Direction');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `direction` SET TAGS ('dbx_value_regex' = 'inbound|outbound');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Interaction Duration (Minutes)');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Interaction End Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `end_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `external_reference_code` SET TAGS ('dbx_business_glossary_term' = 'External Reference ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `is_escalated` SET TAGS ('dbx_business_glossary_term' = 'Escalation Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `is_escalated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `is_logged_in_crm` SET TAGS ('dbx_business_glossary_term' = 'CRM Logging Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `is_logged_in_crm` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Interaction Language Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2,3}(-[A-Z]{2,3})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `location_country_code` SET TAGS ('dbx_business_glossary_term' = 'Interaction Location Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `location_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `location_name` SET TAGS ('dbx_business_glossary_term' = 'Interaction Location Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `next_action` SET TAGS ('dbx_business_glossary_term' = 'Next Action');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `next_action_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Action Due Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `next_action_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `nps_score` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS)');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `nps_score` SET TAGS ('dbx_value_regex' = '^([0-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `outcome` SET TAGS ('dbx_business_glossary_term' = 'Interaction Outcome');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `outcome` SET TAGS ('dbx_value_regex' = 'positive|neutral|negative|follow_up_required|opportunity_identified|deal_closed|issue_resolved|escalated|no_outcome');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Interaction Priority');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `product_line` SET TAGS ('dbx_business_glossary_term' = 'Discussed Product Line');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `sentiment` SET TAGS ('dbx_business_glossary_term' = 'Interaction Sentiment');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `sentiment` SET TAGS ('dbx_value_regex' = 'positive|neutral|negative|mixed|unknown');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce_crm|sap_s4hana|manual_entry|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Interaction Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Interaction Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'planned|in_progress|completed|cancelled|no_show|rescheduled');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `subject` SET TAGS ('dbx_business_glossary_term' = 'Interaction Subject');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Interaction Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'sales_call|site_visit|trade_show_meeting|webinar|product_demonstration|support_escalation|email|phone_call|virtual_meeting|partner_review|executive_briefing|field_service_visit|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` SET TAGS ('dbx_subdomain' = 'engagement_tracking');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `customer_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `product_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Product Variant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `segment_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Segment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `account_executive` SET TAGS ('dbx_business_glossary_term' = 'Account Executive');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `actual_close_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Close Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `actual_close_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `competitor_names` SET TAGS ('dbx_business_glossary_term' = 'Competitor Landscape');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `competitor_names` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `crm_opportunity_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Relationship Management (CRM) Opportunity Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `deal_size_category` SET TAGS ('dbx_business_glossary_term' = 'Deal Size Category');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `deal_size_category` SET TAGS ('dbx_value_regex' = 'small|medium|large|strategic');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `erp_quotation_number` SET TAGS ('dbx_business_glossary_term' = 'Enterprise Resource Planning (ERP) Quotation Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `estimated_revenue` SET TAGS ('dbx_business_glossary_term' = 'Estimated Revenue');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `estimated_revenue` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `estimated_revenue_usd` SET TAGS ('dbx_business_glossary_term' = 'Estimated Revenue (USD)');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `estimated_revenue_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `expected_close_date` SET TAGS ('dbx_business_glossary_term' = 'Expected Close Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `expected_close_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `fiscal_quarter` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Quarter');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `fiscal_quarter` SET TAGS ('dbx_value_regex' = '^Q[1-4]-d{4}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^d{4}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `forecast_category` SET TAGS ('dbx_business_glossary_term' = 'Forecast Category');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `forecast_category` SET TAGS ('dbx_value_regex' = 'pipeline|best_case|commit|closed|omitted');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `industry_vertical` SET TAGS ('dbx_business_glossary_term' = 'Industry Vertical');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `industry_vertical` SET TAGS ('dbx_value_regex' = 'automotive|food_beverage|oil_gas|pharmaceuticals|utilities|mining|aerospace|logistics|building_automation|water_treatment|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `is_forecasted` SET TAGS ('dbx_business_glossary_term' = 'Forecasted Opportunity Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `is_forecasted` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `is_strategic` SET TAGS ('dbx_business_glossary_term' = 'Strategic Opportunity Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `is_strategic` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `lead_source` SET TAGS ('dbx_business_glossary_term' = 'Lead Source');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `lead_source` SET TAGS ('dbx_value_regex' = 'inbound_web|trade_show|partner_referral|direct_sales|marketing_campaign|existing_account|cold_outreach|distributor|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `loss_reason` SET TAGS ('dbx_business_glossary_term' = 'Loss Reason');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `loss_reason` SET TAGS ('dbx_value_regex' = 'price|competitor_product|no_decision|budget_cut|relationship|technical_fit|timeline|internal_build|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `loss_reason_detail` SET TAGS ('dbx_business_glossary_term' = 'Loss Reason Detail');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `next_step` SET TAGS ('dbx_business_glossary_term' = 'Next Step');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `open_date` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Open Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `open_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `probability_percent` SET TAGS ('dbx_business_glossary_term' = 'Win Probability Percentage');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `probability_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `product_family` SET TAGS ('dbx_business_glossary_term' = 'Product Family');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `product_line` SET TAGS ('dbx_business_glossary_term' = 'Product Line of Interest');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `proposal_submitted_date` SET TAGS ('dbx_business_glossary_term' = 'Proposal Submitted Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `proposal_submitted_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `rfq_reference` SET TAGS ('dbx_business_glossary_term' = 'Request for Quotation (RFQ) Reference');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `sales_cycle_days` SET TAGS ('dbx_business_glossary_term' = 'Sales Cycle Duration (Days)');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `sales_cycle_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `sales_manager` SET TAGS ('dbx_business_glossary_term' = 'Sales Manager');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `sales_region` SET TAGS ('dbx_business_glossary_term' = 'Sales Region');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `sales_territory` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce_crm|sap_s4hana|manual');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `stage` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Stage');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `stage` SET TAGS ('dbx_value_regex' = 'prospecting|qualification|proposal|negotiation|closed_won|closed_lost');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `technical_presales_owner` SET TAGS ('dbx_business_glossary_term' = 'Technical Pre-Sales Owner');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'new_business|existing_business_expansion|renewal|replacement|upgrade|cross_sell|upsell');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` SET TAGS ('dbx_subdomain' = 'service_delivery');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `case_id` SET TAGS ('dbx_business_glossary_term' = 'Case ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `field_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Field Service Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `serialized_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Serialized Unit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `service_ticket_id` SET TAGS ('dbx_business_glossary_term' = 'Service Ticket Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `affected_quantity` SET TAGS ('dbx_business_glossary_term' = 'Affected Quantity');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `affected_quantity` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `assigned_engineer` SET TAGS ('dbx_business_glossary_term' = 'Assigned Service Engineer');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `capa_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `capa_reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `crm_case_code` SET TAGS ('dbx_business_glossary_term' = 'CRM Case ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `customer_satisfaction_score` SET TAGS ('dbx_business_glossary_term' = 'Customer Satisfaction (CSAT) Score');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `customer_satisfaction_score` SET TAGS ('dbx_value_regex' = '^([0-9]|10)(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Case Description');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `escalation_flag` SET TAGS ('dbx_business_glossary_term' = 'Case Escalation Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `escalation_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `escalation_reason` SET TAGS ('dbx_business_glossary_term' = 'Case Escalation Reason');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `escalation_reason` SET TAGS ('dbx_value_regex' = 'sla_breach|customer_request|technical_complexity|management_directive|repeat_issue|safety_concern|regulatory_impact|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `escalation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Case Escalation Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `escalation_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `first_response_timestamp` SET TAGS ('dbx_business_glossary_term' = 'First Response Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `first_response_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Case Language Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `ncr_number` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Report (NCR) Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `ncr_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Case Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `open_date` SET TAGS ('dbx_business_glossary_term' = 'Case Open Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `open_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `open_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Case Open Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `open_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `origin` SET TAGS ('dbx_business_glossary_term' = 'Case Origin Channel');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `origin` SET TAGS ('dbx_value_regex' = 'phone|email|web_portal|field_service|chat|partner_portal|edi|manual_entry');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Case Priority');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `product_model_number` SET TAGS ('dbx_business_glossary_term' = 'Product Model Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `product_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Product Serial Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `related_order_number` SET TAGS ('dbx_business_glossary_term' = 'Related Sales Order Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `related_order_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{5,30}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `resolution_code` SET TAGS ('dbx_business_glossary_term' = 'Case Resolution Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `resolution_code` SET TAGS ('dbx_value_regex' = 'repaired|replaced|refunded|credited|configuration_change|software_patch|training_provided|no_fault_found|workaround_provided|escalated_to_engineering|warranty_replacement|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Case Resolution Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `resolution_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `resolution_description` SET TAGS ('dbx_business_glossary_term' = 'Case Resolution Description');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `resolution_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Case Resolution Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `resolution_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'design_defect|manufacturing_defect|installation_error|operator_error|software_bug|wear_and_tear|logistics_damage|documentation_error|supplier_defect|environmental_factor|unknown|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `service_team` SET TAGS ('dbx_business_glossary_term' = 'Service Team');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `sla_target_resolution_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Target Resolution Hours');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `sla_target_resolution_hours` SET TAGS ('dbx_value_regex' = '^d{1,7}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce_service_cloud|sap_s4hana|maximo|manual');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Case Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'new|open|in_progress|pending_customer|pending_internal|escalated|resolved|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `subject` SET TAGS ('dbx_business_glossary_term' = 'Case Subject');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Case Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'technical_issue|delivery_complaint|invoice_dispute|warranty_claim|field_service_request|product_defect|spare_parts_request|documentation_request|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `warranty_claim_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `warranty_claim_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiry Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` SET TAGS ('dbx_subdomain' = 'engagement_tracking');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `nps_response_id` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS) Response ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `nps_survey_id` SET TAGS ('dbx_business_glossary_term' = 'Survey ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `nps_survey_id` SET TAGS ('dbx_value_regex' = '^SRV-[A-Z0-9]{6,20}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `anonymized` SET TAGS ('dbx_business_glossary_term' = 'Anonymized Response Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `anonymized` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `capa_reference` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `consent_date` SET TAGS ('dbx_business_glossary_term' = 'Data Processing Consent Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `consent_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `consent_given` SET TAGS ('dbx_business_glossary_term' = 'Data Processing Consent Given Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `consent_given` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `crm_survey_response_code` SET TAGS ('dbx_business_glossary_term' = 'CRM Survey Response ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `feedback_topic_tags` SET TAGS ('dbx_business_glossary_term' = 'Feedback Topic Tags');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `follow_up_date` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `follow_up_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `follow_up_owner` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Owner');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `follow_up_required` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Required Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `follow_up_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `follow_up_status` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `follow_up_status` SET TAGS ('dbx_value_regex' = 'Not Required|Pending|In Progress|Completed|Escalated');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Survey Language Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `nps_score` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS) Score');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `nps_score` SET TAGS ('dbx_value_regex' = '^([0-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `product_line` SET TAGS ('dbx_business_glossary_term' = 'Product Line');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `product_sku` SET TAGS ('dbx_business_glossary_term' = 'Product Stock Keeping Unit (SKU)');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `respondent_category` SET TAGS ('dbx_business_glossary_term' = 'NPS Respondent Category');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `respondent_category` SET TAGS ('dbx_value_regex' = 'Promoter|Passive|Detractor');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `response_date` SET TAGS ('dbx_business_glossary_term' = 'Response Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `response_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `response_status` SET TAGS ('dbx_business_glossary_term' = 'Response Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `response_status` SET TAGS ('dbx_value_regex' = 'Completed|Partial|Declined|Expired|Bounced');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `response_time_days` SET TAGS ('dbx_business_glossary_term' = 'Response Time (Days)');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `response_time_days` SET TAGS ('dbx_value_regex' = '^d+$');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `response_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Response Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `response_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `sentiment_category` SET TAGS ('dbx_business_glossary_term' = 'Sentiment Category');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `sentiment_category` SET TAGS ('dbx_value_regex' = 'Positive|Neutral|Negative|Mixed');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `sentiment_score` SET TAGS ('dbx_business_glossary_term' = 'Sentiment Score');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `sentiment_score` SET TAGS ('dbx_value_regex' = '^-?[01](.d{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'Field Service|Remote Support|Repair|Preventive Maintenance|Commissioning|Training|Warranty|Other');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'Salesforce CRM|SAP S/4HANA|Siemens Opcenter MES|Manual|Other');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `survey_channel` SET TAGS ('dbx_business_glossary_term' = 'Survey Channel');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `survey_channel` SET TAGS ('dbx_value_regex' = 'Email|SMS|Web Portal|In-App|Phone|Field Service|Event Kiosk');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `survey_date` SET TAGS ('dbx_business_glossary_term' = 'Survey Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `survey_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `survey_program` SET TAGS ('dbx_business_glossary_term' = 'Survey Program Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `survey_program` SET TAGS ('dbx_value_regex' = 'Transactional|Relational|Product|Service|Event');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `survey_wave` SET TAGS ('dbx_business_glossary_term' = 'Survey Wave');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `trigger_event_reference` SET TAGS ('dbx_business_glossary_term' = 'Survey Trigger Event Reference');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `trigger_event_type` SET TAGS ('dbx_business_glossary_term' = 'Survey Trigger Event Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `trigger_event_type` SET TAGS ('dbx_value_regex' = 'Product Delivery|Commissioning|Service Resolution|Installation|Repair|Preventive Maintenance|Contract Renewal|Training|Other');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `verbatim_feedback` SET TAGS ('dbx_business_glossary_term' = 'Verbatim Feedback');
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ALTER COLUMN `verbatim_feedback` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` SET TAGS ('dbx_subdomain' = 'account_management');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `account_document_id` SET TAGS ('dbx_business_glossary_term' = 'Account Document ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `evidence_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Evidence Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `associated_contract_number` SET TAGS ('dbx_business_glossary_term' = 'Associated Contract Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `associated_contract_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_business_glossary_term' = 'Document Confidentiality Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_value_regex' = 'public|internal|confidential|strictly_confidential|trade_secret');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `counterparty_name` SET TAGS ('dbx_business_glossary_term' = 'Counterparty Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `counterparty_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `counterparty_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Counterparty Reference Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `counterparty_reference_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `custodian_department` SET TAGS ('dbx_business_glossary_term' = 'Document Custodian Department');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `custodian_name` SET TAGS ('dbx_business_glossary_term' = 'Document Custodian Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `digital_signature_status` SET TAGS ('dbx_business_glossary_term' = 'Digital Signature Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `digital_signature_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|signed_by_us|signed_by_counterparty|fully_executed|signature_failed|expired');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `document_category` SET TAGS ('dbx_business_glossary_term' = 'Document Category');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `document_category` SET TAGS ('dbx_value_regex' = 'legal|commercial|compliance|quality|financial|export_control|safety|environmental|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Document Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,50}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Document Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `document_type` SET TAGS ('dbx_value_regex' = 'NDA|master_purchase_agreement|quality_agreement|export_license|tax_exemption_certificate|customer_certification|SLA_agreement|framework_contract|credit_agreement|insurance_certificate|regulatory_compliance_certificate|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `document_type` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `execution_date` SET TAGS ('dbx_business_glossary_term' = 'Document Execution Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `execution_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Document Expiry Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_value_regex' = 'EAR99|ECCN|ITAR|no_restriction|restricted|embargoed|license_required|not_applicable');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `file_format` SET TAGS ('dbx_business_glossary_term' = 'File Format');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `file_format` SET TAGS ('dbx_value_regex' = 'PDF|DOCX|XLSX|PPTX|XML|CSV|TIFF|JPEG|PNG|ZIP|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `file_reference` SET TAGS ('dbx_business_glossary_term' = 'File Reference');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `file_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `governing_law` SET TAGS ('dbx_business_glossary_term' = 'Governing Law');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `governing_law` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `is_multilingual` SET TAGS ('dbx_business_glossary_term' = 'Is Multilingual Document');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `is_multilingual` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Document Issue Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `issue_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Issuing Authority');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `issuing_country_code` SET TAGS ('dbx_business_glossary_term' = 'Issuing Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `issuing_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Document Language Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `last_modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `last_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Document Notes');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `notes` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `renewal_reminder_date` SET TAGS ('dbx_business_glossary_term' = 'Renewal Reminder Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `renewal_reminder_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `requires_periodic_review` SET TAGS ('dbx_business_glossary_term' = 'Requires Periodic Review');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `requires_periodic_review` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `review_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Review Frequency (Months)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `review_frequency_months` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `revision_code` SET TAGS ('dbx_business_glossary_term' = 'Document Revision Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `revision_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|Salesforce_CRM|Teamcenter_PLM|SAP_Ariba|manual|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `source_system_document_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Document ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Document Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_review|active|expired|superseded|cancelled|archived|pending_signature|rejected');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Document Title');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `title` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Document Version Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` SET TAGS ('dbx_subdomain' = 'financial_operations');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `account_bank_detail_id` SET TAGS ('dbx_business_glossary_term' = 'Account Bank Detail ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `account_holder_name` SET TAGS ('dbx_business_glossary_term' = 'Account Holder Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `account_holder_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `account_holder_name` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `account_type` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `account_type` SET TAGS ('dbx_value_regex' = 'checking|savings|current|deposit|escrow');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `bank_branch_name` SET TAGS ('dbx_business_glossary_term' = 'Bank Branch Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `bank_control_key` SET TAGS ('dbx_business_glossary_term' = 'Bank Control Key');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `bank_country_code` SET TAGS ('dbx_business_glossary_term' = 'Bank Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `bank_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `bank_key` SET TAGS ('dbx_business_glossary_term' = 'Bank Key');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `blocked_reason` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Blocked Reason');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `blocked_reason` SET TAGS ('dbx_value_regex' = 'fraud_suspected|account_closed|invalid_details|customer_request|compliance_hold|returned_payment|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `collection_authorization_flag` SET TAGS ('dbx_business_glossary_term' = 'Collection Authorization Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `collection_authorization_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Record Created By User');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `creditor_identifier` SET TAGS ('dbx_business_glossary_term' = 'SEPA Creditor Identifier');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Account Currency Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `data_privacy_consent_flag` SET TAGS ('dbx_business_glossary_term' = 'Data Privacy Consent Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `data_privacy_consent_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `iban` SET TAGS ('dbx_business_glossary_term' = 'International Bank Account Number (IBAN)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `iban` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}[0-9]{2}[A-Z0-9]{1,30}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `iban` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `iban` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `is_primary` SET TAGS ('dbx_business_glossary_term' = 'Primary Bank Account Indicator');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `is_primary` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `is_verified` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Verified Indicator');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `is_verified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `last_modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified By User');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `last_used_date` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Last Used Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `last_used_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `mandate_reference` SET TAGS ('dbx_business_glossary_term' = 'SEPA Direct Debit Mandate Reference');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `mandate_reference` SET TAGS ('dbx_value_regex' = '^[A-Za-z0-9+?/-]{1,35}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `mandate_signed_date` SET TAGS ('dbx_business_glossary_term' = 'Mandate Signed Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `mandate_signed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `mandate_status` SET TAGS ('dbx_business_glossary_term' = 'SEPA Mandate Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `mandate_status` SET TAGS ('dbx_value_regex' = 'active|inactive|cancelled|pending|expired|suspended');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `mandate_type` SET TAGS ('dbx_business_glossary_term' = 'SEPA Mandate Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `mandate_type` SET TAGS ('dbx_value_regex' = 'core|b2b|cor1');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Bank Detail Notes');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `partner_bank_type` SET TAGS ('dbx_business_glossary_term' = 'Partner Bank Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'direct_debit|wire_transfer|ach|sepa_credit_transfer|sepa_direct_debit|check|eft');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `refund_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Refund Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `refund_eligible_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|MIGRATION');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Bank Detail Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|pending_verification|expired|cancelled');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `swift_bic_code` SET TAGS ('dbx_business_glossary_term' = 'SWIFT/BIC Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `swift_bic_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[A-Z]{2}[A-Z0-9]{2}([A-Z0-9]{3})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Bank Detail Valid From Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Bank Detail Valid To Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Verification Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `verification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `verification_method` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Verification Method');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ALTER COLUMN `verification_method` SET TAGS ('dbx_value_regex' = 'micro_deposit|bank_confirmation|third_party_service|manual_review|prenote');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` SET TAGS ('dbx_subdomain' = 'account_management');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `account_contact_role_id` SET TAGS ('dbx_business_glossary_term' = 'Account Contact Role ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `assigned_sales_territory` SET TAGS ('dbx_business_glossary_term' = 'Assigned Sales Territory');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `authority_limit_currency` SET TAGS ('dbx_business_glossary_term' = 'Authority Limit Currency');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `authority_limit_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `ccpa_opt_out` SET TAGS ('dbx_business_glossary_term' = 'California Consumer Privacy Act (CCPA) Opt-Out Indicator');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `ccpa_opt_out` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `communication_language` SET TAGS ('dbx_business_glossary_term' = 'Communication Language');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `communication_language` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `communication_preference` SET TAGS ('dbx_business_glossary_term' = 'Communication Preference');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `communication_preference` SET TAGS ('dbx_value_regex' = 'email|phone|mobile|postal|portal|no_contact');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `contract_authority_level` SET TAGS ('dbx_business_glossary_term' = 'Contract Authority Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `contract_authority_level` SET TAGS ('dbx_value_regex' = 'full_signatory|limited_signatory|no_authority|approval_required');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `crm_role_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Relationship Management (CRM) Role ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Record Effective Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Role End Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `erp_partner_function_code` SET TAGS ('dbx_business_glossary_term' = 'Enterprise Resource Planning (ERP) Partner Function Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `escalation_priority` SET TAGS ('dbx_business_glossary_term' = 'Escalation Priority');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `escalation_priority` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `gdpr_consent_date` SET TAGS ('dbx_business_glossary_term' = 'General Data Protection Regulation (GDPR) Consent Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `gdpr_consent_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `gdpr_consent_status` SET TAGS ('dbx_business_glossary_term' = 'General Data Protection Regulation (GDPR) Consent Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `gdpr_consent_status` SET TAGS ('dbx_value_regex' = 'granted|withdrawn|pending|not_required');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `influence_level` SET TAGS ('dbx_business_glossary_term' = 'Influence Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `influence_level` SET TAGS ('dbx_value_regex' = 'decision_maker|influencer|evaluator|gatekeeper|end_user|champion|blocker');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `is_primary` SET TAGS ('dbx_business_glossary_term' = 'Primary Role Indicator');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `is_primary` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `last_interaction_date` SET TAGS ('dbx_business_glossary_term' = 'Last Interaction Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `last_interaction_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `notification_opt_in` SET TAGS ('dbx_business_glossary_term' = 'Notification Opt-In Indicator');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `notification_opt_in` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `purchase_order_authority_limit` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Authority Limit');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `purchase_order_authority_limit` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `purchase_order_authority_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `relationship_strength` SET TAGS ('dbx_business_glossary_term' = 'Relationship Strength');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `relationship_strength` SET TAGS ('dbx_value_regex' = 'strong|moderate|weak|unknown');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `role_category` SET TAGS ('dbx_business_glossary_term' = 'Role Category');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `role_category` SET TAGS ('dbx_value_regex' = 'commercial|technical|financial|operational|executive|compliance|service');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `role_description` SET TAGS ('dbx_business_glossary_term' = 'Role Description');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `role_type` SET TAGS ('dbx_business_glossary_term' = 'Role Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `role_type` SET TAGS ('dbx_value_regex' = 'primary_commercial_contact|technical_decision_maker|accounts_payable_contact|plant_manager|executive_sponsor|procurement_manager|quality_manager|logistics_coordinator|field_service_contact|legal_contact|safety_officer|it_contact|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce_crm|sap_s4hana|manual|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Role Start Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Role Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|suspended');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Role Verification Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `verification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `verified_flag` SET TAGS ('dbx_business_glossary_term' = 'Role Verified Indicator');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ALTER COLUMN `verified_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` SET TAGS ('dbx_subdomain' = 'engagement_tracking');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `consent_record_id` SET TAGS ('dbx_business_glossary_term' = 'Consent Record ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `crm_contact_id` SET TAGS ('dbx_business_glossary_term' = 'CRM Contact ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `data_subject_request_id` SET TAGS ('dbx_business_glossary_term' = 'Data Subject Request ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `channel` SET TAGS ('dbx_business_glossary_term' = 'Consent Channel');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `channel` SET TAGS ('dbx_value_regex' = 'web_form|email|phone|paper_form|mobile_app|crm_portal|trade_show|sales_representative|api|preference_center');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `collection_method` SET TAGS ('dbx_business_glossary_term' = 'Consent Collection Method');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `collection_method` SET TAGS ('dbx_value_regex' = 'explicit_opt_in|double_opt_in|implicit_opt_in|opt_out|pre_ticked_box|verbal|written_signature|electronic_signature');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `consent_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Consent Reference Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `consent_type` SET TAGS ('dbx_business_glossary_term' = 'Consent Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `consent_type` SET TAGS ('dbx_value_regex' = 'marketing_email|marketing_sms|marketing_phone|data_sharing_third_party|profiling|analytics|personalization|research|product_updates|service_communications|automated_decision_making');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `consent_version` SET TAGS ('dbx_business_glossary_term' = 'Consent Version');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `consent_version` SET TAGS ('dbx_value_regex' = '^d+.d+(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `data_subject_type` SET TAGS ('dbx_business_glossary_term' = 'Data Subject Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `data_subject_type` SET TAGS ('dbx_value_regex' = 'b2b_contact|end_user|oem_partner_contact|distributor_contact|system_integrator_contact|employee|prospect');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Consent Expiry Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `granted_date` SET TAGS ('dbx_business_glossary_term' = 'Consent Granted Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `granted_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `granted_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Consent Granted Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `granted_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `is_minor` SET TAGS ('dbx_business_glossary_term' = 'Minor Data Subject Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `is_minor` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Consent Language Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `legal_basis` SET TAGS ('dbx_business_glossary_term' = 'Legal Basis for Processing');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `legal_basis` SET TAGS ('dbx_value_regex' = 'consent|legitimate_interest|contract|legal_obligation|vital_interests|public_task');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Consent Record Notes');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `parental_consent_obtained` SET TAGS ('dbx_business_glossary_term' = 'Parental Consent Obtained Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `parental_consent_obtained` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `privacy_notice_version` SET TAGS ('dbx_business_glossary_term' = 'Privacy Notice Version');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `processing_purpose` SET TAGS ('dbx_business_glossary_term' = 'Data Processing Purpose');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `proof_of_consent_reference` SET TAGS ('dbx_business_glossary_term' = 'Proof of Consent Reference');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `re_consent_due_date` SET TAGS ('dbx_business_glossary_term' = 'Re-Consent Due Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `re_consent_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `re_consent_required` SET TAGS ('dbx_business_glossary_term' = 'Re-Consent Required Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `re_consent_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `record_effective_date` SET TAGS ('dbx_business_glossary_term' = 'Record Effective Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `record_effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `regulation_scope` SET TAGS ('dbx_business_glossary_term' = 'Regulation Scope');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `regulation_scope` SET TAGS ('dbx_value_regex' = 'GDPR|CCPA|LGPD|PIPEDA|PDPA|POPIA|APPI|GDPR_CCPA|multi_jurisdiction');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `retention_period_days` SET TAGS ('dbx_business_glossary_term' = 'Consent Retention Period (Days)');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `retention_period_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce_crm|sap_s4hana|preference_center|web_portal|mobile_app|manual_entry|api_integration');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `source_system_consent_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Consent ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Consent Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'granted|withdrawn|expired|pending|not_given');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `third_party_sharing_scope` SET TAGS ('dbx_business_glossary_term' = 'Third Party Data Sharing Scope');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `withdrawal_date` SET TAGS ('dbx_business_glossary_term' = 'Consent Withdrawal Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `withdrawal_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `withdrawal_reason` SET TAGS ('dbx_business_glossary_term' = 'Consent Withdrawal Reason');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `withdrawal_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Consent Withdrawal Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ALTER COLUMN `withdrawal_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` SET TAGS ('dbx_subdomain' = 'account_management');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `account_status_history_id` SET TAGS ('dbx_business_glossary_term' = 'Account Status History ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Relationship Management (CRM) Account ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `approval_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Approval Required Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `approval_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `approved_by_user` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `change_initiated_by` SET TAGS ('dbx_business_glossary_term' = 'Change Initiated By');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `change_initiated_by` SET TAGS ('dbx_value_regex' = 'user|system|batch_job|api_integration|workflow_automation');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `change_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Status Change Reason Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `change_reason_code` SET TAGS ('dbx_value_regex' = 'credit_limit_exceeded|payment_overdue|customer_request|contract_expiry|reactivation|new_onboarding|fraud_investigation|compliance_hold|merger_acquisition|inactivity|manual_correction|system_migration|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `change_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Status Change Reason Description');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `change_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Status Change Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `change_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `changed_by_user` SET TAGS ('dbx_business_glossary_term' = 'Changed By User');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `changed_by_user_full_name` SET TAGS ('dbx_business_glossary_term' = 'Changed By User Full Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `changed_by_user_full_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `changed_by_user_full_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `compliance_hold_flag` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hold Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `compliance_hold_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `compliance_hold_reason` SET TAGS ('dbx_business_glossary_term' = 'Compliance Hold Reason');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `compliance_hold_reason` SET TAGS ('dbx_value_regex' = 'export_control|sanctions_screening|reach_rohs|gdpr_request|osha_violation|epa_violation|other|none');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `credit_block_reference` SET TAGS ('dbx_business_glossary_term' = 'Credit Block Reference');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `days_in_previous_status` SET TAGS ('dbx_business_glossary_term' = 'Days in Previous Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `days_in_previous_status` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `erp_customer_code` SET TAGS ('dbx_business_glossary_term' = 'Enterprise Resource Planning (ERP) Customer ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `is_current_record` SET TAGS ('dbx_business_glossary_term' = 'Is Current Record Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `is_current_record` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `new_status` SET TAGS ('dbx_business_glossary_term' = 'New Account Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `new_status` SET TAGS ('dbx_value_regex' = 'prospect|active|on_hold|credit_blocked|dormant|churned|suspended|pending_approval|closed');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Status Change Notes');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `previous_status` SET TAGS ('dbx_business_glossary_term' = 'Previous Account Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `previous_status` SET TAGS ('dbx_value_regex' = 'prospect|active|on_hold|credit_blocked|dormant|churned|suspended|pending_approval|closed');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `reactivation_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Reactivation Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `reactivation_eligible_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `related_document_number` SET TAGS ('dbx_business_glossary_term' = 'Related Document Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `related_document_type` SET TAGS ('dbx_business_glossary_term' = 'Related Document Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `related_document_type` SET TAGS ('dbx_value_regex' = 'contract|purchase_order|credit_memo|complaint|ncr|capa|none');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|API|BATCH');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `source_system_record_code` SET TAGS ('dbx_business_glossary_term' = 'Source System Record ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `transition_type` SET TAGS ('dbx_business_glossary_term' = 'Status Transition Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `transition_type` SET TAGS ('dbx_value_regex' = 'activation|deactivation|suspension|reactivation|credit_block|credit_unblock|churn|dormancy|escalation|correction');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Version Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `change_date` SET TAGS ('dbx_business_glossary_term' = 'Status Change Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ALTER COLUMN `change_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` SET TAGS ('dbx_subdomain' = 'engagement_tracking');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `communication_preference_id` SET TAGS ('dbx_business_glossary_term' = 'Communication Preference ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `partner_id` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Partner ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `ccpa_opt_out` SET TAGS ('dbx_business_glossary_term' = 'California Consumer Privacy Act (CCPA) Opt-Out Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `ccpa_opt_out` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `communication_frequency` SET TAGS ('dbx_business_glossary_term' = 'Communication Frequency Preference');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `communication_frequency` SET TAGS ('dbx_value_regex' = 'real_time|daily|weekly|bi_weekly|monthly|quarterly|as_needed');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `consent_collection_method` SET TAGS ('dbx_business_glossary_term' = 'Consent Collection Method');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `consent_collection_method` SET TAGS ('dbx_value_regex' = 'web_form|email_confirmation|paper_form|portal_registration|verbal|edi_agreement|crm_entry');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `consent_version` SET TAGS ('dbx_business_glossary_term' = 'Consent Version');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `crm_preference_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Relationship Management (CRM) Preference ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `do_not_contact` SET TAGS ('dbx_business_glossary_term' = 'Do Not Contact Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `do_not_contact` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `do_not_contact_reason` SET TAGS ('dbx_business_glossary_term' = 'Do Not Contact Reason');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `do_not_contact_reason` SET TAGS ('dbx_value_regex' = 'customer_request|legal_hold|deceased|regulatory_restriction|account_closed|dispute|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `email_format_preference` SET TAGS ('dbx_business_glossary_term' = 'Email Format Preference');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `email_format_preference` SET TAGS ('dbx_value_regex' = 'html|plain_text');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `emergency_contact_preference` SET TAGS ('dbx_business_glossary_term' = 'Emergency Contact Preference');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `emergency_contact_preference` SET TAGS ('dbx_value_regex' = 'phone|email|sms|portal|edi|any');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `entity_type` SET TAGS ('dbx_business_glossary_term' = 'Entity Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `entity_type` SET TAGS ('dbx_value_regex' = 'account|contact');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `gdpr_consent_date` SET TAGS ('dbx_business_glossary_term' = 'General Data Protection Regulation (GDPR) Consent Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `gdpr_consent_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `gdpr_consent_status` SET TAGS ('dbx_business_glossary_term' = 'General Data Protection Regulation (GDPR) Consent Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `gdpr_consent_status` SET TAGS ('dbx_value_regex' = 'granted|withdrawn|not_applicable|pending');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `last_preference_update_date` SET TAGS ('dbx_business_glossary_term' = 'Last Preference Update Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `last_preference_update_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `marketing_opt_in` SET TAGS ('dbx_business_glossary_term' = 'Marketing Opt-In Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `marketing_opt_in` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `newsletter_subscription` SET TAGS ('dbx_business_glossary_term' = 'Newsletter Subscription Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `newsletter_subscription` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Communication Preference Notes');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `order_notification` SET TAGS ('dbx_business_glossary_term' = 'Order Notification Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `order_notification` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `portal_username` SET TAGS ('dbx_business_glossary_term' = 'Customer Portal Username');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `portal_username` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preference_code` SET TAGS ('dbx_business_glossary_term' = 'Communication Preference Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preference_code` SET TAGS ('dbx_value_regex' = '^CP-[A-Z0-9]{6,20}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preference_update_channel` SET TAGS ('dbx_business_glossary_term' = 'Preference Update Channel');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preference_update_channel` SET TAGS ('dbx_value_regex' = 'portal|crm_agent|email_link|paper_form|edi|api');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preferred_channel` SET TAGS ('dbx_business_glossary_term' = 'Preferred Contact Channel');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preferred_channel` SET TAGS ('dbx_value_regex' = 'email|phone|portal|edi|fax|postal_mail|sms|no_contact');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preferred_contact_days` SET TAGS ('dbx_business_glossary_term' = 'Preferred Contact Days');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preferred_contact_days` SET TAGS ('dbx_value_regex' = '^(MON|TUE|WED|THU|FRI|SAT|SUN)(,(MON|TUE|WED|THU|FRI|SAT|SUN))*$');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preferred_contact_time_end` SET TAGS ('dbx_business_glossary_term' = 'Preferred Contact Time Window End');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preferred_contact_time_end` SET TAGS ('dbx_value_regex' = '^([01]d|2[0-3]):[0-5]d$');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preferred_contact_time_start` SET TAGS ('dbx_business_glossary_term' = 'Preferred Contact Time Window Start');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preferred_contact_time_start` SET TAGS ('dbx_value_regex' = '^([01]d|2[0-3]):[0-5]d$');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preferred_contact_timezone` SET TAGS ('dbx_business_glossary_term' = 'Preferred Contact Time Zone');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preferred_contact_timezone` SET TAGS ('dbx_value_regex' = '^[A-Za-z]+/[A-Za-z_]+$');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preferred_language_code` SET TAGS ('dbx_business_glossary_term' = 'Preferred Language Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `preferred_language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2,3}(-[A-Z]{2,3})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `product_update_notification` SET TAGS ('dbx_business_glossary_term' = 'Product Update Notification Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `product_update_notification` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `secondary_channel` SET TAGS ('dbx_business_glossary_term' = 'Secondary Contact Channel');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `secondary_channel` SET TAGS ('dbx_value_regex' = 'email|phone|portal|edi|fax|postal_mail|sms|none');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `service_notification` SET TAGS ('dbx_business_glossary_term' = 'Service Notification Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `service_notification` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce_crm|sap_s4hana|portal|manual|edi|marketing_cloud');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Communication Preference Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_review|suspended');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` SET TAGS ('dbx_subdomain' = 'account_management');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `account_team_id` SET TAGS ('dbx_business_glossary_term' = 'Account Team ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `employee_id` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,20}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `access_level` SET TAGS ('dbx_business_glossary_term' = 'Account Access Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `access_level` SET TAGS ('dbx_value_regex' = 'read_only|read_write|full_access|owner');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `assignment_end_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment End Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `assignment_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `assignment_reason` SET TAGS ('dbx_business_glossary_term' = 'Assignment Reason');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `assignment_reason` SET TAGS ('dbx_value_regex' = 'new_account|territory_realignment|account_growth|escalation_support|merger_acquisition|coverage_gap|strategic_initiative|replacement');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `assignment_start_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Start Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `assignment_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `assignment_type` SET TAGS ('dbx_business_glossary_term' = 'Assignment Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `assignment_type` SET TAGS ('dbx_value_regex' = 'primary|secondary|backup|temporary|interim|global|regional|local');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `business_unit` SET TAGS ('dbx_business_glossary_term' = 'Business Unit');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `case_access_level` SET TAGS ('dbx_business_glossary_term' = 'Service Case Access Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `case_access_level` SET TAGS ('dbx_value_regex' = 'none|read_only|read_write');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `certification_level` SET TAGS ('dbx_business_glossary_term' = 'Technical Certification Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `certification_level` SET TAGS ('dbx_value_regex' = 'none|associate|professional|expert|master');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `coverage_region` SET TAGS ('dbx_business_glossary_term' = 'Coverage Region');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `crm_team_member_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Relationship Management (CRM) Team Member ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `crm_user_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Relationship Management (CRM) User ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `department` SET TAGS ('dbx_business_glossary_term' = 'Department');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `department` SET TAGS ('dbx_value_regex' = 'Sales|Technical Sales|Customer Success|Field Service|Business Development|Key Account Management|Pre-Sales|Post-Sales|Channel Management|Inside Sales');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `email` SET TAGS ('dbx_business_glossary_term' = 'Team Member Work Email Address');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `erp_sales_rep_number` SET TAGS ('dbx_business_glossary_term' = 'Enterprise Resource Planning (ERP) Sales Representative Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `is_primary` SET TAGS ('dbx_business_glossary_term' = 'Primary Team Member Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `is_primary` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `manager_name` SET TAGS ('dbx_business_glossary_term' = 'Direct Manager Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Assignment Notes');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `opportunity_access_level` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Access Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `opportunity_access_level` SET TAGS ('dbx_value_regex' = 'none|read_only|read_write');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `phone` SET TAGS ('dbx_business_glossary_term' = 'Team Member Work Phone Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `phone` SET TAGS ('dbx_value_regex' = '^+?[0-9s-().]{7,20}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `quota_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Quota Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `quota_eligible_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization (Sales Org) Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'Salesforce CRM|SAP S/4HANA|Kronos Workforce Central|Manual');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Record Key');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Assignment Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|on_leave|transferred');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `team_member_name` SET TAGS ('dbx_business_glossary_term' = 'Account Team Member Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `team_member_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `team_role` SET TAGS ('dbx_business_glossary_term' = 'Account Team Role');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `team_role` SET TAGS ('dbx_value_regex' = 'Account Executive|Technical Sales Engineer|Customer Success Manager|Field Service Coordinator|Inside Sales Representative|Sales Manager|Application Engineer|Key Account Manager|Business Development Manager|Channel Manager|Pre-Sales Consultant|Post...');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `territory_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Territory Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ALTER COLUMN `time_zone` SET TAGS ('dbx_business_glossary_term' = 'Time Zone');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` SET TAGS ('dbx_subdomain' = 'service_delivery');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `installed_base_id` SET TAGS ('dbx_business_glossary_term' = 'Installed Base ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `asset_register_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Register Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `delivery_order_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Note Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `plm_product_catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Product Lifecycle Management (PLM) Product ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `product_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Certification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `sds_id` SET TAGS ('dbx_business_glossary_term' = 'Sds Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `serialized_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Serialized Unit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Service Technician Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `address_id` SET TAGS ('dbx_business_glossary_term' = 'Site Address Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `address_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `address_id` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Source Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `connectivity_status` SET TAGS ('dbx_business_glossary_term' = 'IIoT Connectivity Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `connectivity_status` SET TAGS ('dbx_value_regex' = 'connected|disconnected|intermittent|not_applicable');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `country_of_origin_code` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `country_of_origin_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `crm_asset_code` SET TAGS ('dbx_business_glossary_term' = 'Customer Relationship Management (CRM) Asset ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `end_customer_account_number` SET TAGS ('dbx_business_glossary_term' = 'End Customer Account Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `end_customer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `end_customer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `end_of_support_date` SET TAGS ('dbx_business_glossary_term' = 'End of Support Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `end_of_support_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `erp_equipment_number` SET TAGS ('dbx_business_glossary_term' = 'Enterprise Resource Planning (ERP) Equipment Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `firmware_version` SET TAGS ('dbx_business_glossary_term' = 'Firmware Version');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `firmware_version` SET TAGS ('dbx_value_regex' = '^d+.d+(.d+)?(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `hardware_revision` SET TAGS ('dbx_business_glossary_term' = 'Hardware Revision');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `iiot_device_code` SET TAGS ('dbx_business_glossary_term' = 'Industrial Internet of Things (IIoT) Device ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `installation_date` SET TAGS ('dbx_business_glossary_term' = 'Installation Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `installation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `last_service_date` SET TAGS ('dbx_business_glossary_term' = 'Last Service Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `last_service_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `next_planned_service_date` SET TAGS ('dbx_business_glossary_term' = 'Next Planned Service Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `next_planned_service_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'running|stopped|fault|standby|unknown');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `product_category` SET TAGS ('dbx_business_glossary_term' = 'Product Category');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `product_category` SET TAGS ('dbx_value_regex' = 'automation_system|electrification|smart_infrastructure|drive_system|control_panel|sensor|software|other');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `record_number` SET TAGS ('dbx_business_glossary_term' = 'Installed Base Record Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `record_number` SET TAGS ('dbx_value_regex' = '^IB-[A-Z0-9]{6,20}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `service_contract_number` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `service_level` SET TAGS ('dbx_business_glossary_term' = 'Service Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `service_level` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|basic|none');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `service_territory` SET TAGS ('dbx_business_glossary_term' = 'Service Territory');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `site_name` SET TAGS ('dbx_business_glossary_term' = 'Installation Site Name');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `software_version` SET TAGS ('dbx_business_glossary_term' = 'Software Version');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `software_version` SET TAGS ('dbx_value_regex' = '^d+.d+(.d+)?(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Installed Base Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|decommissioned|under_maintenance|pending_commissioning|end_of_life|returned');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `upgrade_eligibility_flag` SET TAGS ('dbx_business_glossary_term' = 'Upgrade Eligibility Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `upgrade_eligibility_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiry Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `warranty_type` SET TAGS ('dbx_business_glossary_term' = 'Warranty Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ALTER COLUMN `warranty_type` SET TAGS ('dbx_value_regex' = 'standard|extended|on_site|return_to_depot|parts_only|labor_only|none');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` SET TAGS ('dbx_subdomain' = 'financial_operations');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `account_payment_term_id` SET TAGS ('dbx_business_glossary_term' = 'Account Payment Term ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `additional_months` SET TAGS ('dbx_business_glossary_term' = 'Additional Months');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `additional_months` SET TAGS ('dbx_value_regex' = '^d{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `advance_payment_percent` SET TAGS ('dbx_business_glossary_term' = 'Advance Payment Percentage');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `advance_payment_percent` SET TAGS ('dbx_value_regex' = '^d{1,3}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `advance_payment_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'approved|pending|rejected|draft|under_review|escalated');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `baseline_date_type` SET TAGS ('dbx_business_glossary_term' = 'Baseline Date Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `baseline_date_type` SET TAGS ('dbx_value_regex' = 'invoice_date|posting_date|goods_receipt_date|delivery_date|end_of_month');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `cash_discount_percent_1` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Percentage (Tier 1)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `cash_discount_percent_1` SET TAGS ('dbx_value_regex' = '^d{1,3}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `cash_discount_percent_1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `cash_discount_percent_2` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Percentage (Tier 2)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `cash_discount_percent_2` SET TAGS ('dbx_value_regex' = '^d{1,3}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `cash_discount_percent_2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `contract_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `contract_reference_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `credit_control_area` SET TAGS ('dbx_business_glossary_term' = 'Credit Control Area');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `credit_control_area` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `days_sales_outstanding_target` SET TAGS ('dbx_business_glossary_term' = 'Days Sales Outstanding (DSO) Target');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `days_sales_outstanding_target` SET TAGS ('dbx_value_regex' = '^d{1,4}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `discount_days_1` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Days (Tier 1)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `discount_days_1` SET TAGS ('dbx_value_regex' = '^d{1,3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `discount_days_2` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Days (Tier 2)');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `discount_days_2` SET TAGS ('dbx_value_regex' = '^d{1,3}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `distribution_channel_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `division_code` SET TAGS ('dbx_business_glossary_term' = 'Division Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `division_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `dunning_procedure` SET TAGS ('dbx_business_glossary_term' = 'Dunning Procedure');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `dunning_procedure` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `early_payment_incentive_flag` SET TAGS ('dbx_business_glossary_term' = 'Early Payment Incentive Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `early_payment_incentive_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `fixed_day_of_month` SET TAGS ('dbx_business_glossary_term' = 'Fixed Day of Month');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `fixed_day_of_month` SET TAGS ('dbx_value_regex' = '^([1-9]|[12][0-9]|3[01])$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `incoterms_code` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `installment_plan_flag` SET TAGS ('dbx_business_glossary_term' = 'Installment Plan Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `installment_plan_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `net_due_days` SET TAGS ('dbx_business_glossary_term' = 'Net Due Days');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `net_due_days` SET TAGS ('dbx_value_regex' = '^d{1,4}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `payment_block_reason` SET TAGS ('dbx_business_glossary_term' = 'Payment Block Reason');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `payment_block_reason` SET TAGS ('dbx_value_regex' = 'none|credit_hold|dispute|legal_hold|manual_block|audit_hold');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'bank_transfer|check|credit_card|direct_debit|letter_of_credit|cash|electronic_funds_transfer|promissory_note');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `payment_term_description` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Description');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `payment_term_key` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Key');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `payment_term_key` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `payment_term_type` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `payment_term_type` SET TAGS ('dbx_value_regex' = 'standard|installment|advance|cash_in_advance|letter_of_credit|consignment|milestone|deferred');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization (SO) Code');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `sales_organization_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|LEGACY_ERP');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Payment Term Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_approval|expired|superseded|under_review');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` SET TAGS ('dbx_subdomain' = 'financial_operations');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` SET TAGS ('dbx_association_edges' = 'customer.account,product.catalog_item');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `customer_contract_id` SET TAGS ('dbx_business_glossary_term' = 'customer_contract Identifier');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Contract - Account Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Contract - Catalog Item Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Identifier');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto Renewal Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract End Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `incoterms_override` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Override');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `minimum_order_quantity_uom` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `owner` SET TAGS ('dbx_business_glossary_term' = 'Contract Owner');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `payment_terms_override` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Override');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `price` SET TAGS ('dbx_business_glossary_term' = 'Negotiated Contract Price');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `price_currency` SET TAGS ('dbx_business_glossary_term' = 'Contract Price Currency');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notice Days');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Start Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Contract Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `volume_commitment` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment');
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ALTER COLUMN `volume_commitment_uom` SET TAGS ('dbx_business_glossary_term' = 'Volume Commitment Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` SET TAGS ('dbx_subdomain' = 'service_delivery');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` SET TAGS ('dbx_association_edges' = 'customer.account,research.collaboration_agreement');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` SET TAGS ('dbx_original_name' = 'customer_collaboration');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `collaboration_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Collaboration Identifier');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Collaboration - Account Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `collaboration_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Collaboration - Collaboration Agreement Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_business_glossary_term' = 'Customer-Specific Confidentiality Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `deliverable_milestones` SET TAGS ('dbx_business_glossary_term' = 'Customer-Specific Deliverable Milestones');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Participation End Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `funding_amount` SET TAGS ('dbx_business_glossary_term' = 'Customer Funding Commitment');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `ip_ownership_split` SET TAGS ('dbx_business_glossary_term' = 'Customer IP Ownership Percentage');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `last_modified_date` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `participation_status` SET TAGS ('dbx_business_glossary_term' = 'Customer Participation Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Primary Contact');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Participation Start Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` SET TAGS ('dbx_subdomain' = 'compliance_requirements');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` SET TAGS ('dbx_association_edges' = 'customer.account,compliance.regulatory_requirement');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ALTER COLUMN `account_regulatory_applicability_id` SET TAGS ('dbx_business_glossary_term' = 'Account Regulatory Applicability ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Regulatory Applicability - Account Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ALTER COLUMN `regulatory_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Account Regulatory Applicability - Regulatory Requirement Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ALTER COLUMN `applicability_basis` SET TAGS ('dbx_business_glossary_term' = 'Applicability Basis');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ALTER COLUMN `applicability_scope` SET TAGS ('dbx_business_glossary_term' = 'Applicability Scope');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ALTER COLUMN `assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Compliance Assessment Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Record Created Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ALTER COLUMN `customer_specific_interpretation` SET TAGS ('dbx_business_glossary_term' = 'Customer-Specific Interpretation');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Applicability Effective Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ALTER COLUMN `exemption_status` SET TAGS ('dbx_business_glossary_term' = 'Exemption Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ALTER COLUMN `last_modified_date` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ALTER COLUMN `next_assessment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Assessment Due Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ALTER COLUMN `responsible_compliance_officer` SET TAGS ('dbx_business_glossary_term' = 'Responsible Compliance Officer');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` SET TAGS ('dbx_subdomain' = 'service_delivery');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` SET TAGS ('dbx_association_edges' = 'customer.account,logistics.carrier');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` ALTER COLUMN `preferred_carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Carrier Relationship ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Carrier - Account Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` ALTER COLUMN `carrier_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Carrier - Carrier Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` ALTER COLUMN `account_number_with_carrier` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Number at Carrier');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` ALTER COLUMN `account_number_with_carrier` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` ALTER COLUMN `account_number_with_carrier` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Relationship Effective Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Relationship Expiry Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` ALTER COLUMN `preferred_rank` SET TAGS ('dbx_business_glossary_term' = 'Carrier Preference Rank');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` ALTER COLUMN `service_level` SET TAGS ('dbx_business_glossary_term' = 'Approved Service Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Customer-Specific Handling Instructions');
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Relationship Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` SET TAGS ('dbx_subdomain' = 'service_delivery');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` SET TAGS ('dbx_association_edges' = 'customer.account,logistics.transport_zone');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `account_delivery_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Account Delivery Zone Identifier');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Delivery Zone - Account Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `transport_zone_id` SET TAGS ('dbx_business_glossary_term' = 'Account Delivery Zone - Transport Zone Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `delivery_priority` SET TAGS ('dbx_business_glossary_term' = 'Delivery Priority Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `delivery_window_end` SET TAGS ('dbx_business_glossary_term' = 'Delivery Window End Time');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `delivery_window_start` SET TAGS ('dbx_business_glossary_term' = 'Delivery Window Start Time');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Configuration Effective Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Configuration Expiration Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `last_modified_date` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modifying User');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `requires_dock_appointment` SET TAGS ('dbx_business_glossary_term' = 'Dock Appointment Required Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `service_level` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `special_requirements` SET TAGS ('dbx_business_glossary_term' = 'Special Delivery Requirements');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Configuration Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` SET TAGS ('dbx_subdomain' = 'financial_operations');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` SET TAGS ('dbx_association_edges' = 'customer.account,technology.it_contract');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ALTER COLUMN `account_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Account Contract Identifier');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Contract - Account Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ALTER COLUMN `it_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Account Contract - It Contract Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ALTER COLUMN `account_manager` SET TAGS ('dbx_business_glossary_term' = 'Account Manager');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_business_glossary_term' = 'Billing Frequency');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ALTER COLUMN `contract_value` SET TAGS ('dbx_business_glossary_term' = 'Contract Value');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Created Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ALTER COLUMN `customer_contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Customer Contract Reference');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract End Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ALTER COLUMN `last_modified_date` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ALTER COLUMN `renewal_status` SET TAGS ('dbx_business_glossary_term' = 'Renewal Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ALTER COLUMN `service_scope` SET TAGS ('dbx_business_glossary_term' = 'Service Scope');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Start Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` SET TAGS ('dbx_subdomain' = 'financial_operations');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` SET TAGS ('dbx_association_edges' = 'customer.account,technology.software_license');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ALTER COLUMN `license_entitlement_id` SET TAGS ('dbx_business_glossary_term' = 'License Entitlement Identifier');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Identifier');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ALTER COLUMN `software_license_id` SET TAGS ('dbx_business_glossary_term' = 'License Entitlement - Software License Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ALTER COLUMN `activation_date` SET TAGS ('dbx_business_glossary_term' = 'Activation Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Created Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Expiration Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ALTER COLUMN `last_modified_date` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ALTER COLUMN `license_quantity` SET TAGS ('dbx_business_glossary_term' = 'License Quantity');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ALTER COLUMN `license_type` SET TAGS ('dbx_business_glossary_term' = 'License Type');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ALTER COLUMN `maintenance_level` SET TAGS ('dbx_business_glossary_term' = 'Maintenance Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Entitlement Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ALTER COLUMN `usage_rights` SET TAGS ('dbx_business_glossary_term' = 'Usage Rights');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` SET TAGS ('dbx_subdomain' = 'engagement_tracking');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` SET TAGS ('dbx_association_edges' = 'customer.contact,technology.user_access_request');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ALTER COLUMN `contact_system_access_id` SET TAGS ('dbx_business_glossary_term' = 'Contact System Access ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Contact System Access - Contact Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ALTER COLUMN `user_access_request_id` SET TAGS ('dbx_business_glossary_term' = 'User Access Request ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ALTER COLUMN `access_granted_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Access Granted Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ALTER COLUMN `access_level` SET TAGS ('dbx_business_glossary_term' = 'Access Level');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ALTER COLUMN `access_level` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ALTER COLUMN `access_purpose` SET TAGS ('dbx_business_glossary_term' = 'Access Purpose');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Access Expiration Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ALTER COLUMN `is_active` SET TAGS ('dbx_business_glossary_term' = 'Is Active');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ALTER COLUMN `last_access_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Access Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ALTER COLUMN `provisioned_systems` SET TAGS ('dbx_business_glossary_term' = 'Provisioned Systems');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` SET TAGS ('dbx_subdomain' = 'compliance_requirements');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` SET TAGS ('dbx_association_edges' = 'customer.account,product.sku');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` ALTER COLUMN `approval_id` SET TAGS ('dbx_business_glossary_term' = 'Approval Identifier');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Approval - Account Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Approval - Sku Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` ALTER COLUMN `certification_document` SET TAGS ('dbx_business_glossary_term' = 'Certification Document');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` ALTER COLUMN `expiration_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Expiration Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` ALTER COLUMN `qualification_notes` SET TAGS ('dbx_business_glossary_term' = 'Qualification Notes');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` ALTER COLUMN `qualification_status` SET TAGS ('dbx_business_glossary_term' = 'Qualification Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` ALTER COLUMN `technical_specification_reference` SET TAGS ('dbx_business_glossary_term' = 'Technical Specification Reference');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` SET TAGS ('dbx_subdomain' = 'compliance_requirements');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` SET TAGS ('dbx_association_edges' = 'customer.account,engineering.component');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` ALTER COLUMN `approved_component_list_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Component List ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Component List - Account Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Component List - Component Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` ALTER COLUMN `annual_volume_commitment` SET TAGS ('dbx_business_glossary_term' = 'Annual Volume Commitment');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Component Approval Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` ALTER COLUMN `customer_part_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Part Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Approval Notes');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` ALTER COLUMN `price_agreement_reference` SET TAGS ('dbx_business_glossary_term' = 'Price Agreement Reference');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` ALTER COLUMN `qualification_engineer` SET TAGS ('dbx_business_glossary_term' = 'Qualification Engineer');
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` ALTER COLUMN `qualification_status` SET TAGS ('dbx_business_glossary_term' = 'Qualification Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` SET TAGS ('dbx_subdomain' = 'compliance_requirements');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` SET TAGS ('dbx_association_edges' = 'customer.account,engineering.regulatory_certification');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ALTER COLUMN `account_certification_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Account Certification Requirement ID');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Certification Requirement - Account Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ALTER COLUMN `engineering_regulatory_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Account Certification Requirement - Regulatory Certification Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ALTER COLUMN `certification_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Certification Document Reference');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ALTER COLUMN `certification_scope` SET TAGS ('dbx_business_glossary_term' = 'Certification Scope');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Created Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ALTER COLUMN `customer_acceptance_date` SET TAGS ('dbx_business_glossary_term' = 'Customer Acceptance Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ALTER COLUMN `last_updated_date` SET TAGS ('dbx_business_glossary_term' = 'Last Updated Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ALTER COLUMN `requirement_status` SET TAGS ('dbx_business_glossary_term' = 'Requirement Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ALTER COLUMN `responsible_account_manager` SET TAGS ('dbx_business_glossary_term' = 'Responsible Account Manager');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` SET TAGS ('dbx_subdomain' = 'compliance_requirements');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` SET TAGS ('dbx_association_edges' = 'customer.account,hse.chemical_substance');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ALTER COLUMN `account_chemical_approval_id` SET TAGS ('dbx_business_glossary_term' = 'Account Chemical Approval Identifier');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Account Chemical Approval - Account Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ALTER COLUMN `chemical_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Account Chemical Approval - Chemical Substance Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ALTER COLUMN `approval_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Approval Reference Number');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ALTER COLUMN `approved_usage_volume` SET TAGS ('dbx_business_glossary_term' = 'Approved Usage Volume');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Expiry Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Approval Notes');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ALTER COLUMN `usage_restrictions` SET TAGS ('dbx_business_glossary_term' = 'Usage Restrictions');
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ALTER COLUMN `volume_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Volume Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` SET TAGS ('dbx_subdomain' = 'engagement_tracking');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` SET TAGS ('dbx_association_edges' = 'customer.contact,sales.sales_campaign');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `campaign_enrollment_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Enrollment Identifier');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Enrollment - Sales Campaign Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `contact_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Enrollment - Contact Id');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `sales_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Campaign Identifier');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `email_click_count` SET TAGS ('dbx_business_glossary_term' = 'Email Click Count');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `email_click_count` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `email_click_count` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `email_open_count` SET TAGS ('dbx_business_glossary_term' = 'Email Open Count');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `email_open_count` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `email_open_count` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `email_sent_count` SET TAGS ('dbx_business_glossary_term' = 'Email Sent Count');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `email_sent_count` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `email_sent_count` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `engagement_score` SET TAGS ('dbx_business_glossary_term' = 'Engagement Score');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `enrollment_date` SET TAGS ('dbx_business_glossary_term' = 'Enrollment Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `enrollment_status` SET TAGS ('dbx_business_glossary_term' = 'Enrollment Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `last_interaction_date` SET TAGS ('dbx_business_glossary_term' = 'Last Interaction Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `lead_generated_flag` SET TAGS ('dbx_business_glossary_term' = 'Lead Generated Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `opportunity_generated_flag` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Generated Flag');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `response_status` SET TAGS ('dbx_business_glossary_term' = 'Response Status');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `unsubscribe_date` SET TAGS ('dbx_business_glossary_term' = 'Unsubscribe Date');
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ALTER COLUMN `unsubscribe_flag` SET TAGS ('dbx_business_glossary_term' = 'Unsubscribe Flag');
