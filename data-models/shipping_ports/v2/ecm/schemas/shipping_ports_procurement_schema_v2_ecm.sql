-- Schema for Domain: procurement | Business: Shipping_Ports | Version: v2_ecm
-- Generated on: 2026-07-13 08:38:29

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_shipping_ports_v1`.`procurement` COMMENT 'Manages vendor management, purchase orders, materials management (MM), spare parts procurement, contract management with suppliers, supplier performance evaluation, and procurement-to-pay processes. Integrates with SAP MM. SSOT for procurement and supplier relationship data.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` (
    `vendor_id` BIGINT COMMENT 'Unique identifier for the vendor record. Primary key. System-generated surrogate key for internal reference.',
    `country_id` BIGINT COMMENT 'Foreign key linking to masterdata.country. Business justification: Vendor country of registration required for sanctions screening, trade compliance, payment routing (SWIFT), tax treaty application, and PSC targeting factor assessment. Replaces denormalized country_c',
    `port_community_participant_id` BIGINT COMMENT 'Foreign key linking to customer.port_community_participant. Business justification: Many vendors are also port community participants (stevedore companies, service providers, hauliers). This FK enables linking vendor procurement records to their participant profile for ISPS accredita',
    `un_locode_id` BIGINT COMMENT 'Foreign key linking to masterdata.un_locode. Business justification: Vendors located at specific UN/LOCODE locations for logistics planning, freight cost calculation, customs documentation (place of supply), and local content requirement verification in port procuremen',
    `address_line_1` STRING COMMENT 'First line of the vendors registered business address including street number and street name.',
    `address_line_2` STRING COMMENT 'Second line of the vendors business address for additional location details such as building name, floor, or suite number.',
    `approved_commodity_categories` STRING COMMENT 'Comma-separated list of UNSPSC commodity categories or internal procurement categories that the vendor is approved to supply. Restricts purchase order creation to approved categories only.',
    `bank_account_currency` STRING COMMENT 'Three-letter ISO 4217 currency code of the vendors bank account. May differ from transaction currency if currency conversion is required for payment.. Valid values are `^[A-Z]{3}$`',
    `bank_account_number` STRING COMMENT 'Vendors bank account number for payment processing. Format varies by country. Highly sensitive financial information. Sourced from SAP MM Vendor Master (LFBK-BANKN).',
    `bank_account_valid_from` DATE COMMENT 'Date from which the vendors bank account details are valid and can be used for payment processing. Used to manage bank account changes over time.',
    `bank_account_valid_to` DATE COMMENT 'Date until which the vendors bank account details remain valid. Null indicates the account is currently active with no planned end date.',
    `bank_branch` STRING COMMENT 'Specific branch or location of the bank where the vendor account is held. May include branch code or address.',
    `bank_name` STRING COMMENT 'Name of the financial institution where the vendor holds their primary payment account. Used for electronic funds transfer and payment processing. Sourced from SAP MM Vendor Master (LFBK-BANKS).',
    `business_registration_number` STRING COMMENT 'Official company registration number issued by the national business registry or chamber of commerce. Used to verify legal entity status.',
    `vendor_category` STRING COMMENT 'Primary business classification of the vendor based on the type of goods or services they provide to the port authority. Determines procurement workflows and approval hierarchies. [ENUM-REF-CANDIDATE: spare_parts_supplier|equipment_vendor|service_contractor|fuel_supplier|chemical_supplier|consumables_provider|marine_services|logistics_provider|construction_contractor|professional_services — 10 candidates stripped; promote to reference product]',
    `city` STRING COMMENT 'City or municipality where the vendors business is located.',
    `vendor_code` STRING COMMENT 'Externally-known unique business identifier for the vendor. Alphanumeric code used in procurement documents, purchase orders, and supplier communications. Sourced from SAP MM Vendor Master (LFA1-LIFNR).. Valid values are `^[A-Z0-9]{6,12}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this vendor record was first created in the system. Used for audit trail and data lineage tracking.',
    `credit_limit` DECIMAL(18,2) COMMENT 'Maximum outstanding payable amount allowed for this vendor before new purchase orders are blocked. Used for financial risk management. Sourced from SAP MM Vendor Master (LFB1-KLIMK).',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code in which transactions with this vendor are conducted (e.g., USD, EUR, GBP, SGD). Sourced from SAP MM Vendor Master (LFB1-WAERS).. Valid values are `^[A-Z]{3}$`',
    `iban` STRING COMMENT 'International Bank Account Number used for cross-border payments in SEPA and international wire transfers. Standardized format for global payment processing.. Valid values are `^[A-Z]{2}[0-9]{2}[A-Z0-9]{1,30}$`',
    `iso_14001_certificate_number` STRING COMMENT 'Unique certificate number issued by the certification body for ISO 14001 environmental compliance.',
    `iso_14001_certified` BOOLEAN COMMENT 'Indicates whether the vendor holds valid ISO 14001 Environmental Management System certification. Important for chemical suppliers and contractors.',
    `iso_14001_expiry_date` DATE COMMENT 'Date when the vendors ISO 14001 environmental certification expires and requires renewal.',
    `iso_45001_certificate_number` STRING COMMENT 'Unique certificate number issued by the certification body for ISO 45001 occupational health and safety compliance.',
    `iso_45001_certified` BOOLEAN COMMENT 'Indicates whether the vendor holds valid ISO 45001 Occupational Health and Safety Management System certification. Required for service contractors working on port premises.',
    `iso_45001_expiry_date` DATE COMMENT 'Date when the vendors ISO 45001 occupational health and safety certification expires and requires renewal.',
    `iso_9001_certificate_number` STRING COMMENT 'Unique certificate number issued by the certification body for ISO 9001 compliance. Used for verification and audit purposes.',
    `iso_9001_certified` BOOLEAN COMMENT 'Indicates whether the vendor holds valid ISO 9001 Quality Management System certification. Critical for equipment and spare parts suppliers.',
    `iso_9001_expiry_date` DATE COMMENT 'Date when the vendors ISO 9001 certification expires and requires renewal. Monitored to ensure continued compliance.',
    `isps_clearance_expiry_date` DATE COMMENT 'Date when the vendors ISPS security clearance expires. Vendors with expired clearance cannot access restricted port areas.',
    `isps_clearance_number` STRING COMMENT 'Unique clearance number issued by port security authority under ISPS Code requirements. Used for access control and security audits.',
    `isps_clearance_status` STRING COMMENT 'Security clearance status under ISPS Code for vendors requiring access to restricted port areas. Mandatory for marine services and contractors working in secure zones.. Valid values are `cleared|pending|expired|not_required`',
    `last_performance_review_date` DATE COMMENT 'Date of the most recent vendor performance evaluation. Used to track periodic supplier assessments and qualification reviews.',
    `minimum_order_value` DECIMAL(18,2) COMMENT 'Minimum monetary value required for a purchase order to be accepted by the vendor. Orders below this threshold may incur additional fees or be rejected.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this vendor record was last updated. Tracks the most recent change to any field in the vendor master record.',
    `vendor_name` STRING COMMENT 'Full legal registered name of the vendor organization as it appears on contracts, invoices, and official documents. Sourced from SAP MM Vendor Master (LFA1-NAME1).',
    `next_performance_review_date` DATE COMMENT 'Scheduled date for the next vendor performance evaluation. Ensures regular assessment of supplier quality, delivery, and service levels.',
    `onboarding_date` DATE COMMENT 'Date when the vendor was first registered and approved in the procurement system. Marks the start of the vendor relationship.',
    `payment_terms_code` STRING COMMENT 'Standard payment terms code defining the number of days and conditions for invoice payment (e.g., NET30, NET60, 2/10NET30). Sourced from SAP MM Vendor Master (LFB1-ZTERM).',
    `payment_terms_days` STRING COMMENT 'Number of days from invoice date within which payment must be made to the vendor. Standard terms range from 15 to 90 days depending on vendor agreement.',
    `postal_code` STRING COMMENT 'Postal or ZIP code for the vendors business address. Format varies by country postal system.',
    `primary_contact_email` STRING COMMENT 'Email address of the primary contact person for purchase orders, delivery coordination, and vendor communications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `primary_contact_name` STRING COMMENT 'Full name of the primary contact person at the vendor organization for procurement and operational matters.',
    `primary_contact_phone` STRING COMMENT 'Telephone number of the primary contact person including country code and extension if applicable.',
    `short_name` STRING COMMENT 'Abbreviated or trading name of the vendor used for display purposes in operational systems and reports.',
    `standard_lead_time_days` STRING COMMENT 'Typical number of days from purchase order issuance to delivery of goods or completion of services. Used for procurement planning and inventory management.',
    `state_province` STRING COMMENT 'State, province, or administrative region where the vendors business is located. Format varies by country.',
    `swift_bic_code` STRING COMMENT 'SWIFT/BIC code identifying the vendors bank for international wire transfers. 8 or 11 character code following ISO 9362 standard.. Valid values are `^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$`',
    `tax_identifier` STRING COMMENT 'Government-issued tax registration number or VAT number for the vendor. Format varies by jurisdiction (e.g., EIN in USA, VAT in EU, GST in India). Used for tax reporting and compliance. Sourced from SAP MM Vendor Master (LFA1-STCEG).',
    `tier` STRING COMMENT 'Strategic classification of vendor based on spend volume, criticality of supplies, performance history, and relationship strength. Tier 1 vendors receive preferential treatment and longer-term contracts.. Valid values are `tier_1_strategic|tier_2_preferred|tier_3_approved|tier_4_conditional`',
    `trade_license_expiry_date` DATE COMMENT 'Date when the vendors trade license expires. Vendors with expired licenses may be blocked from new transactions pending renewal.',
    `trade_license_issuing_authority` STRING COMMENT 'Name of the government body or regulatory authority that issued the vendors trade license (e.g., Ministry of Commerce, Chamber of Commerce).',
    `trade_license_number` STRING COMMENT 'Government-issued trade license or business permit number authorizing the vendor to conduct commercial operations in the jurisdiction.',
    `vendor_status` STRING COMMENT 'Current operational status of the vendor in the procurement system. Active vendors can receive purchase orders. Blocked vendors cannot transact. Sourced from SAP MM Vendor Master (LFA1-SPERR).. Valid values are `active|inactive|suspended|blocked|pending_approval|under_review`',
    CONSTRAINT pk_vendor PRIMARY KEY(`vendor_id`)
) COMMENT 'Master record for all suppliers and vendors engaged by the port authority, including spare parts suppliers, equipment vendors, service contractors, fuel suppliers, chemical suppliers, and consumables providers. Captures vendor identity, registration details, tax identifiers, business category, approved commodity categories, payment terms, currency, lead times, vendor tier classification, bank account details (bank name, branch, account number, IBAN, SWIFT/BIC, currency, validity), and compliance certifications (ISO 9001, ISO 14001, ISO 45001, ISPS clearances, trade licences with issuing body, certificate numbers, and expiry tracking). SSOT for vendor/supplier identity, payment details, and qualification profile within the procurement domain. Sourced from SAP MM Vendor Master (LFA1/LFB1/LFBK/LFM1).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` (
    `vendor_bank_account_id` BIGINT COMMENT 'Unique identifier for the vendor bank account record. Primary key for this entity.',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor master record to which this bank account belongs. Links to the vendor entity in the procurement domain.',
    `account_holder_name` STRING COMMENT 'Legal name of the account holder as registered with the bank. Must match vendor legal name for payment processing.',
    `account_status` STRING COMMENT 'Current operational status of the bank account record indicating whether it can be used for payment processing.. Valid values are `active|inactive|blocked|pending_verification|closed`',
    `account_type` STRING COMMENT 'Classification of the bank account type indicating the nature of the account for payment processing purposes.. Valid values are `checking|savings|current|business|escrow|trust`',
    `bank_account_number` STRING COMMENT 'The vendors bank account number used for payment disbursement. Format varies by country and banking system.',
    `bank_account_purpose` STRING COMMENT 'Business purpose or use case for this specific bank account, such as general payments, advance payments, or specific contract payments.',
    `bank_address_line1` STRING COMMENT 'First line of the bank branch physical address including street number and name.',
    `bank_address_line2` STRING COMMENT 'Second line of the bank branch physical address for additional location details such as building or suite number.',
    `bank_branch` STRING COMMENT 'Name or identifier of the specific bank branch where the account is held.',
    `bank_city` STRING COMMENT 'City or municipality where the bank branch is located.',
    `bank_control_key` STRING COMMENT 'Additional bank-specific control identifier used in certain countries for payment validation and routing purposes.',
    `bank_country_code` STRING COMMENT 'Three-letter ISO country code indicating the country where the bank is located.. Valid values are `^[A-Z]{3}$`',
    `bank_key` STRING COMMENT 'Bank identification key or routing number that uniquely identifies the financial institution. May be a sort code, routing number, or bank code depending on country.',
    `bank_name` STRING COMMENT 'Full legal name of the financial institution holding the vendors account.',
    `bank_postal_code` STRING COMMENT 'Postal or ZIP code for the bank branch address used for correspondence and verification.',
    `bank_state_province` STRING COMMENT 'State, province, or region where the bank branch is located.',
    `block_reason` STRING COMMENT 'Explanation or reason code for why the bank account has been blocked for payment processing.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this bank account record was first created in the system. Audit trail for record creation.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code indicating the currency in which this bank account operates for payment disbursement.. Valid values are `^[A-Z]{3}$`',
    `iban` STRING COMMENT 'International Bank Account Number used for international wire transfers and SEPA payments. Standardized format for cross-border transactions.',
    `intermediary_bank_name` STRING COMMENT 'Name of the intermediary or correspondent bank used for routing international payments when direct transfer is not available.',
    `intermediary_swift_code` STRING COMMENT 'SWIFT/BIC code of the intermediary bank used for multi-hop international wire transfers.. Valid values are `^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$`',
    `is_blocked_for_payment` BOOLEAN COMMENT 'Boolean flag indicating whether this bank account is temporarily blocked from receiving payments due to compliance, audit, or vendor issues.',
    `is_primary_account` BOOLEAN COMMENT 'Boolean flag indicating whether this is the primary or default bank account for the vendor. Used for automatic payment selection.',
    `last_payment_date` DATE COMMENT 'Date of the most recent payment disbursed to this bank account. Used for account activity monitoring and reconciliation.',
    `modified_by` STRING COMMENT 'User identifier or system name that last modified this bank account record. Part of the audit trail for data governance.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this bank account record was last modified or updated. Audit trail for record changes.',
    `payment_method` STRING COMMENT 'Preferred payment method or instrument for disbursing funds to this bank account. Determines the payment processing workflow. [ENUM-REF-CANDIDATE: eft|wire|swift|ach|sepa|cheque|bacs — 7 candidates stripped; promote to reference product]',
    `payment_terms` STRING COMMENT 'Standard payment terms or conditions associated with this bank account, such as net 30, net 60, or immediate payment requirements.',
    `reference_details` STRING COMMENT 'Additional reference information or payment instructions specific to this bank account, such as beneficiary reference or special handling notes.',
    `swift_code` STRING COMMENT 'SWIFT/BIC code identifying the bank for international payments. 8 or 11 character code used for cross-border wire transfers.. Valid values are `^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$`',
    `valid_from_date` DATE COMMENT 'Date from which this bank account becomes valid and can be used for payment disbursement. Start of the validity period.',
    `valid_to_date` DATE COMMENT 'Date until which this bank account remains valid for payment processing. Null indicates no expiration. End of the validity period.',
    `verification_date` DATE COMMENT 'Date when the bank account details were last verified or validated by the procurement or finance team.',
    `verification_status` STRING COMMENT 'Status of the bank account verification process indicating whether the account details have been validated for payment processing.. Valid values are `verified|pending|failed|not_verified`',
    `verified_by` STRING COMMENT 'Name or identifier of the user or system that performed the bank account verification.',
    `created_by` STRING COMMENT 'User identifier or system name that created this bank account record. Part of the audit trail for data governance.',
    CONSTRAINT pk_vendor_bank_account PRIMARY KEY(`vendor_bank_account_id`)
) COMMENT 'Bank account details registered for each vendor, supporting payment disbursement via EFT, SWIFT, or cheque. Captures bank name, branch, account number, IBAN, SWIFT/BIC code, currency, account type, and validity period. Linked to vendor master for accounts payable processing. Sourced from SAP MM vendor banking data (LFBK).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` (
    `material_master_id` BIGINT COMMENT 'Unique identifier for the material master record. Primary key.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: Procurement materials must map to HS codes for customs declarations, import/export licensing, tariff calculation, and regulatory compliance in international maritime trade. Essential for cross-border ',
    `packaging_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.packaging_type. Business justification: Materials require packaging type specifications for IMDG compliance, handling equipment selection, storage area allocation, and SOLAS VGM requirements. Critical for hazardous materials and containeriz',
    `abc_indicator` STRING COMMENT 'ABC classification for inventory management. A = high-value/critical items, B = moderate-value, C = low-value/high-volume items. Used for stock control prioritization.. Valid values are `A|B|C`',
    `base_unit_of_measure` STRING COMMENT 'Standard unit in which the material quantity is managed and stored (e.g., EA for each, KG for kilogram, L for liter, M for meter). ISO unit codes preferred.. Valid values are `^[A-Z]{2,3}$`',
    `batch_management_flag` BOOLEAN COMMENT 'Indicates whether the material is managed in batches. Batch management tracks production lots, expiry dates, and quality characteristics.',
    `created_date` DATE COMMENT 'Date when the material master record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for material pricing and valuation (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `deletion_flag` BOOLEAN COMMENT 'Indicates whether the material is marked for deletion. Marked materials cannot be used in new transactions but historical data is retained.',
    `gross_weight` DECIMAL(18,2) COMMENT 'Total weight of the material including packaging, measured in the weight unit specified.',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether the material is classified as hazardous or dangerous goods requiring special handling, storage, and regulatory compliance.',
    `imdg_class` STRING COMMENT 'IMDG classification code for hazardous materials (e.g., Class 3 for flammable liquids, Class 8 for corrosives). Null if not hazardous.',
    `last_modified_by` STRING COMMENT 'User ID or name of the person who last modified the material master record.',
    `last_modified_date` DATE COMMENT 'Date when the material master record was last updated or changed.',
    `lead_time_days` STRING COMMENT 'Average number of days required from purchase order creation to goods receipt. Used for material requirements planning (MRP).',
    `lot_size_procedure` STRING COMMENT 'Rule for calculating procurement or production lot sizes (e.g., fixed lot size, lot-for-lot, economic order quantity).',
    `manufacturer_name` STRING COMMENT 'Name of the original equipment manufacturer (OEM) or producer of the material.',
    `manufacturer_part_number` STRING COMMENT 'Original part number assigned by the manufacturer. Used for cross-referencing, warranty claims, and supplier communication.',
    `material_description` STRING COMMENT 'Short textual description of the material, spare part, or consumable. Used for identification and search purposes.',
    `material_group` STRING COMMENT 'Grouping code used to categorize materials for procurement, reporting, and analytics. Aligns with port operational categories such as crane parts, electrical components, marine supplies.',
    `material_long_description` STRING COMMENT 'Extended textual description providing detailed specifications, usage instructions, or technical characteristics of the material.',
    `material_number` STRING COMMENT 'Unique alphanumeric code assigned to the material in SAP MM. External business identifier used across procurement, inventory, and maintenance systems.. Valid values are `^[A-Z0-9]{8,18}$`',
    `material_status` STRING COMMENT 'Current lifecycle status of the material master record. Controls whether the material can be procured, issued, or used in operations.. Valid values are `active|inactive|blocked|obsolete|pending_approval`',
    `material_type` STRING COMMENT 'Classification of the material by its primary usage category. Determines procurement rules, inventory handling, and accounting treatment. [ENUM-REF-CANDIDATE: spare_part|consumable|raw_material|service|equipment|fuel|lubricant — 7 candidates stripped; promote to reference product]',
    `maximum_stock_level` DECIMAL(18,2) COMMENT 'Maximum inventory quantity that should be held to avoid overstocking and excess capital tied up in inventory.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Smallest quantity that can be ordered from a supplier or produced in a single batch.',
    `minimum_shelf_life_days` STRING COMMENT 'Minimum remaining shelf life required at the time of goods receipt. Materials with shorter remaining shelf life are rejected.',
    `moving_average_price` DECIMAL(18,2) COMMENT 'Weighted average price recalculated with each goods receipt. Used for material valuation in moving average price costing.',
    `mrp_type` STRING COMMENT 'Code defining the MRP procedure used for the material (e.g., reorder point planning, forecast-based planning, no planning).',
    `net_weight` DECIMAL(18,2) COMMENT 'Weight of the material excluding packaging, measured in the weight unit specified.',
    `price_unit` STRING COMMENT 'Quantity unit for which the price is specified (e.g., price per 1, per 10, per 100 units). Used to normalize pricing across different order quantities.',
    `procurement_type` STRING COMMENT 'Indicates whether the material is procured externally from suppliers, produced/serviced internally, or both.. Valid values are `external|internal|both`',
    `purchasing_group` STRING COMMENT 'Code identifying the buyer or procurement team responsible for purchasing this material category.',
    `quality_inspection_flag` BOOLEAN COMMENT 'Indicates whether incoming goods of this material must undergo quality inspection before being released for use.',
    `reorder_point` DECIMAL(18,2) COMMENT 'Inventory level at which a replenishment order should be triggered to avoid stockouts. Used in automatic reorder point planning.',
    `safety_stock_level` DECIMAL(18,2) COMMENT 'Minimum inventory quantity maintained as buffer stock to protect against demand variability and supply delays.',
    `serial_number_profile` STRING COMMENT 'Configuration code indicating whether and how serial numbers are managed for this material (e.g., mandatory at goods receipt, optional, not used).',
    `shelf_life_days` STRING COMMENT 'Maximum number of days the material can be stored before it expires or degrades. Used for perishable or time-sensitive materials.',
    `standard_price` DECIMAL(18,2) COMMENT 'Fixed price used for material valuation in standard costing. Remains constant until manually updated. Used for cost accounting and budgeting.',
    `storage_conditions` STRING COMMENT 'Special storage requirements for the material such as temperature control, humidity control, ventilation, or segregation from other materials.',
    `un_number` STRING COMMENT 'Four-digit UN identification number for hazardous substances and articles. Used for international transport and customs compliance.. Valid values are `^UN[0-9]{4}$`',
    `valuation_class` STRING COMMENT 'Accounting classification code that determines the General Ledger (GL) accounts to which material movements are posted. Links material to financial accounting.',
    `volume` DECIMAL(18,2) COMMENT 'Physical volume or cubic capacity of the material, measured in the volume unit specified. Used for storage space planning.',
    `volume_unit` STRING COMMENT 'Unit of measure for volume (e.g., L for liter, M3 for cubic meter, CBM for cubic meter).. Valid values are `^[A-Z]{2,3}$`',
    `weight_unit` STRING COMMENT 'Unit of measure for weight (e.g., KG for kilogram, LB for pound, TON for metric ton).. Valid values are `^[A-Z]{2,3}$`',
    `created_by` STRING COMMENT 'User ID or name of the person who created the material master record.',
    CONSTRAINT pk_material_master PRIMARY KEY(`material_master_id`)
) COMMENT 'Master catalogue of all materials, spare parts, consumables, and stock items managed by the port. Captures material number, description, material type (spare part, consumable, raw material, service), base unit of measure, material group, storage conditions, hazardous material flags, IMDG classification, reorder point, safety stock level, standard price, moving average price, and shelf life. SSOT for material identity. Sourced from SAP MM Material Master (MARA/MARC/MARD).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` (
    `material_group_id` BIGINT COMMENT 'Unique identifier for the material group. Primary key for the material group taxonomy.',
    `cargo_category_id` BIGINT COMMENT 'Foreign key linking to masterdata.cargo_category. Business justification: Material groups map to cargo categories to determine handling methods, storage area types, applicable equipment, and tariff classifications. Essential for procurement planning aligned with port operat',
    `parent_material_group_id` BIGINT COMMENT 'Reference to the parent material group in the hierarchical taxonomy. Supports multi-level classification (category group → category → sub-category). Null for top-level groups.',
    `annual_spend_estimate` DECIMAL(18,2) COMMENT 'Estimated annual procurement spend for this material group in base currency. Used for budget planning, sourcing strategy prioritization, and spend analysis. Updated annually during budget cycles.',
    `approval_workflow` STRING COMMENT 'Default approval workflow for Purchase Requisitions (PR) and Purchase Orders (PO) in this material group. Options include standard multi-level approval, expedited approval for critical spares, executive approval for high-value items, or technical review for specialized equipment.. Valid values are `standard|expedited|executive|technical_review`',
    `budget_allocation_code` STRING COMMENT 'Financial budget code or cost center allocation rule for spend in this material group. Links procurement spend to financial planning, budget tracking, and variance analysis in SAP Controlling (CO).',
    `material_group_code` STRING COMMENT 'Alphanumeric code uniquely identifying the material group in SAP MM and procurement systems. Used as the business key for procurement classification and spend reporting.. Valid values are `^[A-Z0-9]{4,10}$`',
    `commodity_type` STRING COMMENT 'High-level commodity classification for the material group. Port-specific categories include mechanical spare parts, electrical components, lubricants, marine chemicals, Personal Protective Equipment (PPE), Information Technology (IT) equipment, civil materials, fuel, professional services, and port security. Used for sourcing strategy definition and category management. [ENUM-REF-CANDIDATE: mechanical_spare_parts|electrical_components|lubricants|marine_chemicals|ppe|it_equipment|civil_materials|fuel|professional_services|port_security|consumables|office_supplies — 12 candidates stripped; promote to reference product]',
    `contract_management_required` BOOLEAN COMMENT 'Flag indicating whether materials in this group must be procured under formal contracts with suppliers. Triggers contract compliance checks, Service Level Agreement (SLA) monitoring, and supplier performance evaluation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this material group record was first created in the system. Used for audit trail, data lineage, and compliance reporting.',
    `critical_spare_indicator` BOOLEAN COMMENT 'Flag indicating whether materials in this group are classified as critical spare parts essential for port operations continuity. Drives safety stock levels, supplier performance requirements, and expedited procurement processes.',
    `material_group_description` STRING COMMENT 'Detailed description of the material group scope, including examples of materials, spare parts, or services covered. Used for category management guidance and sourcing strategy documentation.',
    `effective_from_date` DATE COMMENT 'Date from which this material group classification becomes effective for procurement transactions. Used for time-dependent taxonomy changes and historical spend analysis.',
    `effective_to_date` DATE COMMENT 'Date until which this material group classification remains effective. Null for currently active groups. Used for managing taxonomy evolution and ensuring historical data integrity.',
    `environmental_compliance_required` BOOLEAN COMMENT 'Flag indicating whether materials in this group must meet environmental compliance standards such as ISO 14001 Environmental Management System (EMS), MARPOL emissions requirements, or Greenhouse Gas (GHG) reduction targets. Drives supplier qualification and product certification requirements.',
    `external_reference_code` STRING COMMENT 'External identifier for this material group in third-party systems, supplier catalogs, or industry classification schemes. Used for data integration, Electronic Data Interchange (EDI), and cross-system reconciliation.',
    `hazmat_indicator` BOOLEAN COMMENT 'Flag indicating whether materials in this group are classified as hazardous under International Maritime Dangerous Goods (IMDG) Code or Marine Pollution Convention (MARPOL). Triggers special handling, storage, and compliance requirements.',
    `hierarchy_level` STRING COMMENT 'Numeric level in the material group hierarchy. Level 1 = top-level category group, Level 2 = category, Level 3 = sub-category. Supports drill-down spend analysis and budget allocation.',
    `hs_code_prefix` STRING COMMENT 'Harmonized System (HS) Code prefix applicable to materials in this group for customs classification and international trade compliance. Used for import/export documentation, duty calculation, and trade statistics reporting.. Valid values are `^[0-9]{2,6}$`',
    `last_modified_by` STRING COMMENT 'User ID or name of the procurement or master data administrator who last modified this material group record. Used for audit trail and change management tracking.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this material group record was last modified. Used for audit trail, change tracking, and data synchronization across systems.',
    `lead_time_days` STRING COMMENT 'Average procurement lead time in days for materials in this group, from Purchase Order (PO) creation to goods receipt. Used for Materials Requirements Planning (MRP), safety stock calculation, and procurement planning.',
    `local_content_requirement` DECIMAL(18,2) COMMENT 'Percentage of local content required for materials in this group to comply with government regulations, port authority mandates, or corporate social responsibility commitments. Used in supplier selection and bid evaluation.',
    `material_group_status` STRING COMMENT 'Current lifecycle status of the material group. Active groups are used in procurement; inactive groups are retained for historical reporting; deprecated groups are being phased out; under-review groups are subject to category management evaluation.. Valid values are `active|inactive|deprecated|under_review`',
    `material_type` STRING COMMENT 'SAP MM material type classification indicating the nature of items in this group: raw materials, spare parts, consumables, services, equipment, or trading goods. Influences procurement process, inventory management, and valuation rules.. Valid values are `raw_material|spare_part|consumable|service|equipment|trading_goods`',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Default minimum order quantity for materials in this group, typically driven by supplier terms or economic order quantity calculations. Used in procurement planning and Purchase Requisition (PR) consolidation.',
    `material_group_name` STRING COMMENT 'Full descriptive name of the material group. Human-readable label used in procurement documents, purchase orders, and spend reports.',
    `notes` STRING COMMENT 'Free-text notes providing additional context, sourcing guidance, or category management insights for this material group. Used by procurement teams for operational reference and knowledge sharing.',
    `obsolescence_risk` STRING COMMENT 'Assessment of obsolescence risk for materials in this group due to technology changes, supplier discontinuation, or regulatory phase-outs. High-risk groups require proactive lifecycle management and alternative sourcing strategies.. Valid values are `high|medium|low`',
    `preferred_supplier_count` STRING COMMENT 'Target number of preferred suppliers for this material group to balance supply risk, negotiation leverage, and administrative efficiency. Used in supplier rationalization and category management strategies.',
    `procurement_category` STRING COMMENT 'Procurement classification indicating whether the material group represents direct materials (used in operations), indirect materials (supporting operations), services, or capital expenditure items. Drives procurement process routing and approval workflows.. Valid values are `direct|indirect|services|capital`',
    `purchasing_group` STRING COMMENT 'SAP MM purchasing group code identifying the buyer or procurement team responsible for this material group. Used for workload distribution, supplier negotiation, and Purchase Order (PO) approval routing.. Valid values are `^[A-Z0-9]{3}$`',
    `purchasing_organization` STRING COMMENT 'Default purchasing organization responsible for sourcing materials in this group. May represent a centralized procurement team or a port-specific purchasing unit. Used for buyer assignment and sourcing strategy execution.',
    `quality_inspection_required` BOOLEAN COMMENT 'Flag indicating whether materials in this group require mandatory quality inspection upon receipt. Triggers Quality Management (QM) workflows in SAP MM and ensures compliance with Safety of Life at Sea (SOLAS) and port safety standards.',
    `spend_category` STRING COMMENT 'Financial classification indicating whether spend in this material group is Operational Expenditure (OPEX), Capital Expenditure (CAPEX), or mixed. Used for budget allocation, financial planning, and spend reporting alignment.. Valid values are `opex|capex|mixed`',
    `spend_visibility_level` STRING COMMENT 'Classification of spend visibility and data quality for this material group. High visibility indicates well-structured spend data suitable for advanced analytics; low visibility indicates fragmented or incomplete data requiring data cleansing.. Valid values are `high|medium|low`',
    `strategic_sourcing_indicator` BOOLEAN COMMENT 'Flag indicating whether this material group is subject to strategic sourcing initiatives, including long-term contracts, preferred supplier programs, or category management strategies. Influences procurement planning and supplier relationship management.',
    `supplier_consolidation_target` BOOLEAN COMMENT 'Flag indicating whether this material group is targeted for supplier base consolidation to reduce complexity, improve negotiation leverage, and achieve economies of scale. Used in category management and sourcing strategy planning.',
    `sustainability_criteria` STRING COMMENT 'Environmental, social, and governance (ESG) sustainability criteria applicable to this material group, such as carbon footprint limits, ethical sourcing requirements, or circular economy principles. Used for supplier qualification and sustainable procurement initiatives.',
    `tax_classification` STRING COMMENT 'Default tax classification code for materials in this group, determining Value Added Tax (VAT), Goods and Services Tax (GST), or customs duty treatment. Used for automatic tax calculation in Purchase Orders (PO) and invoice verification.',
    `unit_of_measure` STRING COMMENT 'Default unit of measure for materials in this group. Common port units include Each (EA), Kilogram (KG), Liter (L), Meter (M), Square Meter (M2), Cubic Meter (CBM/M3), Set, Hour (HR), and Day. Used for quantity specification in Purchase Orders (PO) and inventory management. [ENUM-REF-CANDIDATE: EA|KG|L|M|M2|M3|SET|HR|DAY — 9 candidates stripped; promote to reference product]',
    `valuation_class` STRING COMMENT 'SAP MM valuation class code linking the material group to General Ledger (GL) account determination for inventory valuation and cost posting. Drives automatic account assignment in Materials Management (MM) and Financial Accounting (FI) integration.. Valid values are `^[A-Z0-9]{4}$`',
    `created_by` STRING COMMENT 'User ID or name of the procurement or master data administrator who created this material group record. Used for audit trail and data governance accountability.',
    CONSTRAINT pk_material_group PRIMARY KEY(`material_group_id`)
) COMMENT 'Unified procurement classification taxonomy for categorising materials, spare parts, and services by commodity type. Supports hierarchical classification (category group → category → sub-category), spend analysis, budget allocation, sourcing strategy definition, and category management. Covers port-specific categories: mechanical spare parts, electrical components, lubricants, marine chemicals, PPE, IT equipment, civil materials, fuel, professional services, and port security. Also serves as the reference taxonomy for spend reporting, OPEX/CAPEX categorisation, and procurement planning alignment. Sourced from SAP MM material group configuration (T023) and extended with port-specific spend taxonomy.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` (
    `purchase_requisition_id` BIGINT COMMENT 'Unique identifier for the purchase requisition record. Primary key.',
    `org_unit_id` BIGINT COMMENT 'Identifier of the port department or business unit that originated the requisition (e.g., terminal operations, marine services, asset management, infrastructure).',
    `vendor_id` BIGINT COMMENT 'Identifier of the preferred or recommended supplier for sourcing this requisition. May be based on contract, past performance, or technical specification.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee or user who created the purchase requisition. Used for audit trail and requisitioner contact.',
    `account_assignment_category` STRING COMMENT 'Financial account assignment type determining how costs will be posted in the general ledger (e.g., cost center, work breakdown structure element, asset, internal order).. Valid values are `cost_center|internal_order|wbs_element|asset|sales_order|network`',
    `approval_date` DATE COMMENT 'Date when the requisition received final approval and was released for purchase order creation.',
    `asset_number` STRING COMMENT 'Fixed asset number when the requisition is for asset procurement or capitalized maintenance. Links to asset master data for depreciation tracking.. Valid values are `^[0-9]{12}$`',
    `contract_number` STRING COMMENT 'Reference to an existing purchasing contract or outline agreement against which this requisition should be fulfilled.. Valid values are `^[0-9]{10}$`',
    `cost_center` STRING COMMENT 'Controlling area cost center to which the requisition expenditure will be charged. Used for internal cost allocation and financial reporting.. Valid values are `^[0-9]{10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the purchase requisition record was first created in the system. Audit trail for requisition lifecycle.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for estimated price and total value (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `deletion_indicator` BOOLEAN COMMENT 'Flag indicating the requisition line is marked for deletion. Soft-delete mechanism for requisition cancellation without physical removal.',
    `delivery_date` DATE COMMENT 'Date by which the material or service is required at the delivery location. Drives procurement lead time and supplier selection.',
    `estimated_total_value` DECIMAL(18,2) COMMENT 'Total estimated value of the requisition line (quantity × estimated unit price). Used for budget control and approval thresholds.',
    `estimated_unit_price` DECIMAL(18,2) COMMENT 'Estimated or budgeted unit price for the requisitioned item. Used for budget checking and cost estimation. Currency specified in currency_code.',
    `fixed_vendor_indicator` BOOLEAN COMMENT 'Flag indicating whether the preferred vendor is mandatory (true) or just a recommendation (false). When true, procurement must use the specified vendor.',
    `gl_account` STRING COMMENT 'General ledger account number to which the expenditure will be posted. Defines the expense or asset category in financial accounting.. Valid values are `^[0-9]{10}$`',
    `internal_order_number` STRING COMMENT 'Controlling internal order number for tracking costs against specific operational activities or maintenance campaigns.. Valid values are `^[0-9]{12}$`',
    `item_category` STRING COMMENT 'Procurement item category defining the procurement process type (standard purchase, service, consignment, subcontracting, stock transfer, third-party).. Valid values are `standard|service|consignment|subcontracting|stock_transfer|third_party`',
    `material_description` STRING COMMENT 'Short text description of the material or service being requisitioned. Free-text field for non-catalog items or additional specification.',
    `material_group` STRING COMMENT 'Material group classification for procurement analytics and reporting (e.g., spare parts, consumables, services, capital equipment).. Valid values are `^[A-Z0-9]{1,9}$`',
    `material_number` STRING COMMENT 'SAP material master number for the requested item. Applicable for stock materials and spare parts. Null for service requisitions or non-stock items.. Valid values are `^[0-9]{18}$`',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the requisition record. Tracks changes throughout the approval and procurement process.',
    `notes` STRING COMMENT 'Free-text field for additional instructions, specifications, or comments related to the requisition. Used for special handling requirements or technical details.',
    `plant_code` STRING COMMENT 'SAP plant code representing the port facility or terminal location where materials or services will be delivered and consumed.. Valid values are `^[A-Z0-9]{4}$`',
    `priority` STRING COMMENT 'Business priority level indicating urgency of procurement need. Influences approval routing and sourcing timeline.. Valid values are `urgent|high|normal|low`',
    `purchase_order_item` STRING COMMENT 'Line item number within the purchase order that fulfills this requisition. Null until PO is created.',
    `purchase_order_number` STRING COMMENT 'Purchase order number created from this requisition. Null until PO is generated. Used to track requisition fulfillment.. Valid values are `^[0-9]{10}$`',
    `purchasing_group` STRING COMMENT 'Buyer or purchasing group responsible for sourcing and procurement execution. Determines procurement specialist assignment.. Valid values are `^[A-Z0-9]{3}$`',
    `purchasing_organization` STRING COMMENT 'Organizational unit responsible for procurement activities. Defines procurement authority and vendor relationships.. Valid values are `^[A-Z0-9]{4}$`',
    `quantity` DECIMAL(18,2) COMMENT 'Requested quantity of material or service. Expressed in the unit of measure specified in unit_of_measure field.',
    `release_indicator` BOOLEAN COMMENT 'Flag indicating whether the requisition has been released for procurement processing after approval workflow completion.',
    `requisition_number` STRING COMMENT 'Business identifier for the purchase requisition. Externally visible requisition document number used across procurement processes.. Valid values are `^PR[0-9]{10}$`',
    `requisition_status` STRING COMMENT 'Current lifecycle status of the requisition in the procurement workflow. Tracks progression from draft through approval to purchase order creation. [ENUM-REF-CANDIDATE: draft|submitted|approved|rejected|partially_ordered|fully_ordered|closed|cancelled — 8 candidates stripped; promote to reference product]',
    `requisition_type` STRING COMMENT 'Classification of the requisition based on procurement purpose: standard purchase, stock replenishment, subcontracting, consignment, service procurement, or asset procurement.. Valid values are `standard|stock_replenishment|subcontracting|consignment|service|asset_procurement`',
    `requisitioner_email` STRING COMMENT 'Email address of the requisitioner for procurement communication and delivery coordination.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `requisitioner_name` STRING COMMENT 'Full name of the employee who raised the requisition. Provides business user context for procurement follow-up.',
    `source_determination_indicator` STRING COMMENT 'Method by which the vendor source will be determined: automatic sourcing, manual buyer selection, contract release order, or purchasing info record.. Valid values are `automatic|manual|contract_release|info_record`',
    `storage_location` STRING COMMENT 'Warehouse or storage location code within the plant where materials will be received and stored (e.g., spare parts warehouse, container yard stores).. Valid values are `^[A-Z0-9]{4}$`',
    `tracking_number` STRING COMMENT 'Optional tracking or reference number for requisition monitoring and reporting. Used for grouping related requisitions or campaign tracking.. Valid values are `^[A-Z0-9]{1,10}$`',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the requisitioned quantity (e.g., EA for each, KG for kilogram, M for meter, HR for hour). ISO standard unit codes.. Valid values are `^[A-Z]{2,3}$`',
    `valuation_type` STRING COMMENT 'Material valuation type for split valuation scenarios (e.g., different valuation for same material from different sources). Blank for non-valuated items.. Valid values are `^[A-Z0-9]{0,10}$`',
    `wbs_element` STRING COMMENT 'Project Systems WBS element for capital projects or infrastructure development initiatives. Used when requisition is project-related (e.g., berth expansion, crane installation).. Valid values are `^[A-Z0-9-.]{1,24}$`',
    CONSTRAINT pk_purchase_requisition PRIMARY KEY(`purchase_requisition_id`)
) COMMENT 'Internal procurement request raised by port departments (terminal operations, marine services, asset management, infrastructure) to initiate the procurement of materials or services. Captures requisition header and line-item details including requisition number, requesting department, cost centre, plant, priority, approval status, sourcing recommendation, and per-line material/service description, quantity, unit of measure, delivery date, storage location, account assignment category, WBS element, and item status. Supports granular tracking of requisition fulfilment against purchase orders. Precursor to purchase order creation. Sourced from SAP MM PR (EBAN).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` (
    `purchase_requisition_item_id` BIGINT COMMENT 'Unique identifier for the purchase requisition item line. Primary key.',
    `material_master_id` BIGINT COMMENT 'add column material_master_id (BIGINT) with FK to procurement.material_master.material_master_id - requisition line items must specify which material is being requested',
    `purchase_requisition_id` BIGINT COMMENT 'Reference to the parent purchase requisition header document. Links this line item to its parent requisition.',
    `account_assignment_category` STRING COMMENT 'Type of account assignment for financial posting. K=Cost Center, A=Asset, P=Project/WBS Element, F=Order, N=Network. Determines how costs are allocated.. Valid values are `K|A|P|F|N`',
    `asset_number` STRING COMMENT 'Fixed asset number when the requisition is for asset acquisition or capitalized maintenance. Links to port equipment, cranes, RTG, AGV, or infrastructure assets.. Valid values are `^[A-Z0-9]{12}$`',
    `contract_item` STRING COMMENT 'Line item number in the referenced contract. Links the requisition to specific contract terms.',
    `contract_number` STRING COMMENT 'Reference to an existing purchasing contract or outline agreement. Used to leverage pre-negotiated terms and pricing.. Valid values are `^[0-9]{10}$`',
    `cost_center` STRING COMMENT 'Cost center to which the requisition expense will be charged. Used for operational expense tracking and budget control.. Valid values are `^[A-Z0-9]{10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the requisition item was created in the system. Used for audit trail and processing time analysis.',
    `currency` STRING COMMENT 'Three-letter ISO 4217 currency code for the valuation price. Supports multi-currency procurement for international suppliers.. Valid values are `^[A-Z]{3}$`',
    `deletion_indicator` BOOLEAN COMMENT 'Flag indicating the item is marked for deletion. Soft-delete flag that prevents further processing without removing historical data.',
    `delivery_date` DATE COMMENT 'Date by which the material or service is required. Critical for planning vessel maintenance windows, berth operations, and equipment availability.',
    `fixed_vendor_indicator` BOOLEAN COMMENT 'Flag indicating whether the vendor is fixed and cannot be changed during purchase order creation. Used for sole-source or contract-mandated suppliers.',
    `gl_account` STRING COMMENT 'General ledger account number for financial posting. Determines the expense or asset account in the chart of accounts.. Valid values are `^[0-9]{6,10}$`',
    `goods_receipt_indicator` BOOLEAN COMMENT 'Flag indicating whether goods receipt posting is required for this item. Typically true for materials, false for services.',
    `internal_order` STRING COMMENT 'Internal order number for tracking specific operational or maintenance activities. Used for cost collection and allocation.. Valid values are `^[A-Z0-9]{12}$`',
    `invoice_receipt_indicator` BOOLEAN COMMENT 'Flag indicating whether invoice verification is required. Controls whether the item must be invoice-matched before payment.',
    `item_category` STRING COMMENT 'Classification of the requisition item type. Standard categories include material, service, subcontracting, or consignment.. Valid values are `^[A-Z]{1}$`',
    `item_number` STRING COMMENT 'Sequential line item number within the purchase requisition. Determines ordering and display sequence of items in the requisition document.',
    `item_status` STRING COMMENT 'Current processing status of the requisition item. Tracks lifecycle from creation through purchase order conversion to closure.. Valid values are `open|approved|partially_ordered|fully_ordered|closed|cancelled`',
    `long_text` STRING COMMENT 'Detailed description or specification of the material or service. May include technical specifications, quality requirements, or special instructions for procurement.',
    `material_group` STRING COMMENT 'Classification code grouping similar materials for procurement analysis and reporting. Used for spend analysis and supplier segmentation.. Valid values are `^[A-Z0-9]{4,10}$`',
    `material_number` STRING COMMENT 'Unique material master identifier for the requested item. References the material master record in SAP MM for spare parts, consumables, or services.. Valid values are `^[A-Z0-9]{8,18}$`',
    `modified_by` STRING COMMENT 'User ID of the person who last modified the requisition item. Used for change tracking and accountability.. Valid values are `^[A-Z0-9]{8,12}$`',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the requisition item. Tracks changes throughout the requisition lifecycle.',
    `plant` STRING COMMENT 'Port facility or terminal location where the material will be delivered. Represents the physical location within the port infrastructure.. Valid values are `^[A-Z0-9]{4}$`',
    `priority` STRING COMMENT 'Priority level for procurement processing. Urgent items may be required for critical equipment repairs or vessel operations.. Valid values are `urgent|high|normal|low`',
    `purchase_order_item` STRING COMMENT 'Line item number in the purchase order that fulfills this requisition item. Links requisition to purchase order for tracking.',
    `purchase_order_number` STRING COMMENT 'Purchase order number created from this requisition item. Populated when the requisition is converted to a purchase order.. Valid values are `^[0-9]{10}$`',
    `purchasing_group` STRING COMMENT 'Buyer or procurement team responsible for sourcing this item. Determines workflow routing and purchasing authority.. Valid values are `^[A-Z0-9]{3}$`',
    `quantity` DECIMAL(18,2) COMMENT 'Requested quantity of the material or service. Represents the amount needed to fulfill operational requirements.',
    `release_indicator` STRING COMMENT 'Approval release status for the requisition item. Indicates whether the item has been approved for procurement.. Valid values are `not_released|released|rejected`',
    `requisition_type` STRING COMMENT 'Type of requisition based on procurement process. Standard for direct procurement, stock for inventory replenishment, service for labor or professional services.. Valid values are `standard|stock|service|subcontract|consignment`',
    `requisitioner` STRING COMMENT 'Employee or user ID of the person who created the requisition item. Used for approval routing and accountability.. Valid values are `^[A-Z0-9]{8,12}$`',
    `short_text` STRING COMMENT 'Brief description of the material or service being requisitioned. Provides human-readable context for the line item.',
    `source_of_supply` STRING COMMENT 'Identifier for the source of supply, which may be a vendor, contract, or scheduling agreement. Used for automated purchase order creation.. Valid values are `^[A-Z0-9]{10}$`',
    `storage_location` STRING COMMENT 'Specific warehouse or storage area within the plant where material will be received and stored. Used for inventory management and material tracking.. Valid values are `^[A-Z0-9]{4}$`',
    `total_value` DECIMAL(18,2) COMMENT 'Total estimated value of the line item (quantity × valuation price). Used for requisition approval workflows and budget checking.',
    `tracking_number` STRING COMMENT 'Internal tracking or reference number for the requisition item. Used for cross-referencing with maintenance work orders or project documentation.. Valid values are `^[A-Z0-9]{10,20}$`',
    `unit_of_measure` STRING COMMENT 'Unit in which the quantity is expressed. Standard units include EA (each), KG (kilogram), L (liter), M (meter), HR (hour), TON (metric ton) for maritime operations. [ENUM-REF-CANDIDATE: EA|KG|L|M|M2|M3|SET|HR|DAY|TON|PC — 11 candidates stripped; promote to reference product]',
    `valuation_price` DECIMAL(18,2) COMMENT 'Estimated unit price for the material or service. Used for budget estimation and purchase order creation. May be based on historical pricing or catalog rates.',
    `vendor_number` STRING COMMENT 'Preferred or assigned supplier for this requisition item. May be pre-populated based on material master or sourcing agreements.. Valid values are `^[A-Z0-9]{10}$`',
    `wbs_element` STRING COMMENT 'Project work breakdown structure element for capital expenditure (CAPEX) items. Used for port infrastructure development, equipment acquisition, and major maintenance projects.. Valid values are `^[A-Z0-9-]{8,24}$`',
    `created_by` STRING COMMENT 'User ID of the person who created the requisition item record in the system. May differ from requisitioner if created on behalf of another user.. Valid values are `^[A-Z0-9]{8,12}$`',
    CONSTRAINT pk_purchase_requisition_item PRIMARY KEY(`purchase_requisition_item_id`)
) COMMENT 'Line-item detail of each purchase requisition, capturing individual material or service line requirements. Includes item number, material number, short text, quantity, unit of measure, delivery date, plant, storage location, account assignment category, cost centre, WBS element, and item status. Supports granular tracking of requisition fulfilment against purchase orders.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` (
    `rfq_id` BIGINT COMMENT 'Unique identifier for the request for quotation record. Primary key.',
    `vendor_id` BIGINT COMMENT 'Identifier of the vendor selected through the RFQ evaluation process. Links to the vendor master record.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to masterdata.commodity_code. Business justification: RFQs for imported materials require HS code classification for tariff estimation, duty calculation, import license requirements, and vendor quotation comparability in international procurement through',
    `employee_id` BIGINT COMMENT 'Identifier of the procurement professional responsible for managing this RFQ process. Links to employee master data.',
    `material_group_id` BIGINT COMMENT 'Foreign key linking to procurement.material_group. Business justification: RFQs are typically scoped to specific material groups or commodity categories for strategic sourcing. Adding material_group_id FK enables better classification, spend analysis, and sourcing strategy a',
    `purchase_requisition_id` BIGINT COMMENT 'add column purchase_requisition_id (BIGINT) with FK to procurement.purchase_requisition.purchase_requisition_id - RFQs originate from purchase requisitions in the procure-to-pay process',
    `approval_status` STRING COMMENT 'Current approval workflow status for the RFQ. High-value RFQs may require management approval before issuance to vendors.. Valid values are `pending|approved|rejected`',
    `approved_by` STRING COMMENT 'User ID of the manager or authority who approved the RFQ for issuance. Required for procurement governance and audit compliance.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the RFQ was formally approved. Marks authorization to proceed with vendor solicitation.',
    `award_date` DATE COMMENT 'Date when the RFQ was formally awarded to the selected vendor. Marks the transition from evaluation to contracting.',
    `award_justification` STRING COMMENT 'Business rationale and evaluation summary explaining why the selected vendor was chosen. Required for procurement audit trail and compliance.',
    `awarded_quotation_number` STRING COMMENT 'Reference number of the winning vendor quotation that was selected for award. Provides audit trail to the selected bid.',
    `commodity_description` STRING COMMENT 'Detailed description of the goods or services being procured through this RFQ. Includes specifications, technical requirements, and quality standards.',
    `confidentiality_level` STRING COMMENT 'Data classification level for the RFQ document and vendor responses. Determines access controls and information sharing restrictions.. Valid values are `public|internal|confidential|restricted`',
    `contract_type` STRING COMMENT 'Type of purchasing agreement that will result from this RFQ (one-time purchase order, framework agreement, blanket order). Influences vendor commitment and pricing structure.. Valid values are `one_time|framework|blanket|spot`',
    `cost_center` STRING COMMENT 'Financial cost center to which procurement costs will be charged. Used for budget tracking and financial reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the RFQ record was first created in the procurement system. Used for audit trail and process cycle time analysis.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code in which quotations must be submitted. Enables consistent price comparison across vendors.. Valid values are `^[A-Z]{3}$`',
    `delivery_location` STRING COMMENT 'Port terminal, warehouse, or facility where goods must be delivered or services performed. Critical for logistics planning and freight cost evaluation.',
    `environmental_requirements` STRING COMMENT 'Environmental compliance and sustainability criteria vendors must satisfy (e.g., ISO 14001, MARPOL compliance, carbon footprint limits).',
    `evaluation_criteria` STRING COMMENT 'Documented criteria and weightings used to evaluate and score vendor quotations (e.g., price 50%, quality 30%, delivery 20%). Ensures transparent and auditable vendor selection.',
    `gl_account` STRING COMMENT 'General ledger account code for expense classification. Determines financial statement line item for procurement spend.',
    `incoterms` STRING COMMENT 'Standardized trade terms defining the division of costs, risks, and responsibilities between buyer and seller. Critical for total landed cost evaluation. [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF — 11 candidates stripped; promote to reference product]',
    `insurance_requirements` STRING COMMENT 'Minimum insurance coverage vendors must maintain (e.g., liability limits, P&I coverage, cargo insurance). Critical for risk management in maritime operations.',
    `issue_date` DATE COMMENT 'Date when the RFQ was formally issued to shortlisted vendors. Marks the start of the vendor response period.',
    `lowest_quoted_price` DECIMAL(18,2) COMMENT 'Lowest total quoted price received from all vendors. Used for quick price benchmarking and savings calculation.',
    `modified_by` STRING COMMENT 'User ID of the last person to update the RFQ record. Tracks responsibility for changes and amendments.',
    `modified_timestamp` TIMESTAMP COMMENT 'System timestamp when the RFQ record was last updated. Tracks changes throughout the RFQ lifecycle from draft to closure.',
    `notes` STRING COMMENT 'Additional instructions, clarifications, or special conditions communicated to vendors. May include site visit requirements, sample submission instructions, or bid bond requirements.',
    `payment_terms` STRING COMMENT 'Standard payment terms requested from vendors (e.g., Net 30, Net 60, 2/10 Net 30). Influences cash flow and vendor pricing.',
    `purchasing_group` STRING COMMENT 'Specialized procurement team or category responsible for this commodity. Used for workload distribution and expertise alignment.',
    `purchasing_organization` STRING COMMENT 'Organizational unit responsible for this procurement activity. Determines approval authority and vendor relationships.',
    `quality_requirements` STRING COMMENT 'Specific quality standards, certifications, and inspection requirements vendors must meet (e.g., ISO 9001, SOLAS compliance, material certificates).',
    `quantity_requested` DECIMAL(18,2) COMMENT 'Total quantity of goods or volume of services requested in the RFQ. Used for vendor capacity assessment and pricing evaluation.',
    `quotation_count` STRING COMMENT 'Total number of vendor quotations received in response to this RFQ. Indicates level of competitive interest and market response.',
    `required_delivery_date` DATE COMMENT 'Target date by which goods must be delivered or services completed. Used to evaluate vendor lead time commitments.',
    `requisition_number` STRING COMMENT 'Reference to the originating purchase requisition that triggered this RFQ. Provides traceability to business demand.',
    `rfq_number` STRING COMMENT 'Business identifier for the RFQ document, externally visible and used in vendor communications. Sourced from SAP MM RFQ document number (EKKO-EBELN where BSART=AN).. Valid values are `^RFQ-[0-9]{8}$`',
    `rfq_status` STRING COMMENT 'Current lifecycle status of the RFQ in the competitive sourcing workflow. Tracks progression from draft through vendor selection to closure. [ENUM-REF-CANDIDATE: draft|issued|open|under_evaluation|awarded|closed|cancelled — 7 candidates stripped; promote to reference product]',
    `rfq_type` STRING COMMENT 'Classification of the RFQ based on procurement strategy and urgency. Determines evaluation criteria and approval workflows.. Valid values are `standard|framework|emergency|spot|contract`',
    `safety_requirements` STRING COMMENT 'Occupational health and safety standards vendors must comply with (e.g., ISO 45001, ISPS Code, port safety regulations).',
    `submission_deadline` TIMESTAMP COMMENT 'Date and time by which vendors must submit their quotations. Late submissions may be rejected per procurement policy.',
    `technical_specifications` STRING COMMENT 'Detailed technical requirements, standards, certifications, and performance criteria that vendors must meet. May reference industry standards (IMO, SOLAS, ISO).',
    `total_estimated_value` DECIMAL(18,2) COMMENT 'Estimated total value of the procurement at RFQ issuance. Used for budget validation and approval routing.',
    `unit_of_measure` STRING COMMENT 'Standard unit in which the requested quantity is measured (e.g., EA, KG, M, HR). Aligns with SAP MM material master UOM.',
    `validity_end_date` DATE COMMENT 'Date until which vendor quotations must remain valid and binding. Ensures vendors cannot withdraw pricing during evaluation.',
    `vendor_prequalification_required` BOOLEAN COMMENT 'Indicates whether vendors must be pre-approved and registered in the vendor master before submitting quotations. Ensures only qualified suppliers participate.',
    `created_by` STRING COMMENT 'User ID of the procurement professional who created the RFQ record. Provides accountability and contact point for vendor inquiries.',
    CONSTRAINT pk_rfq PRIMARY KEY(`rfq_id`)
) COMMENT 'Request for Quotation and vendor quotation management record encompassing the full competitive sourcing cycle: RFQ issuance to shortlisted vendors, vendor-submitted quotations with pricing and delivery terms, comparative bid evaluation, and vendor selection outcome. Captures RFQ number, issue date, submission deadline, commodity description, quantity, delivery requirements, evaluation criteria, RFQ status, and all vendor responses including quotation number, vendor reference, quoted prices, lead times, validity periods, payment terms, deviations from specifications, evaluation scores, line-item pricing, total quoted value, currency, and vendor selection rationale. SSOT for the competitive sourcing and quotation process. Supports transparent vendor selection and audit trail for sourcing decisions. Sourced from SAP MM RFQ/Quotation (EKKO/EKPO - Document Type AN).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` (
    `vendor_quotation_id` BIGINT COMMENT 'Unique identifier for the vendor quotation record. Primary key for the vendor quotation entity.',
    `employee_id` BIGINT COMMENT 'Reference to the procurement buyer or purchasing agent responsible for evaluating this quotation and managing the vendor relationship.',
    `rfq_id` BIGINT COMMENT 'Reference to the originating request for quotation that this vendor quotation responds to. Links the vendor response back to the procurement request.',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor submitting this quotation. Identifies the supplier providing the price and terms.',
    `award_justification` STRING COMMENT 'Business justification for recommending or not recommending this quotation for award. Documents the rationale behind the procurement decision.',
    `commercial_terms_notes` STRING COMMENT 'Additional commercial terms and conditions proposed by the vendor, including special discounts, volume pricing, or contractual clauses.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this quotation record was first created in the data platform. Audit trail for data lineage and compliance.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary values in this quotation. Essential for multi-currency procurement operations and exchange rate management.. Valid values are `^[A-Z]{3}$`',
    `delivery_lead_time_days` STRING COMMENT 'The number of days from purchase order placement to expected delivery. Key factor in vendor selection for time-sensitive procurement of spare parts and materials.',
    `delivery_location` STRING COMMENT 'The physical location where the vendor will deliver the goods. May reference port terminal, warehouse, or specific facility address.',
    `evaluation_score` DECIMAL(18,2) COMMENT 'The composite score assigned to this quotation during the bid evaluation process. Calculated based on price, delivery time, technical compliance, and vendor performance criteria.',
    `incoterms` STRING COMMENT 'The Incoterms rule defining the division of costs and risks between buyer and seller. Critical for international procurement of port equipment and materials. [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF — 11 candidates stripped; promote to reference product]',
    `material_group` STRING COMMENT 'The classification of materials or services covered by this quotation. Used for spend analysis and category management in port procurement operations.',
    `modified_timestamp` TIMESTAMP COMMENT 'The timestamp when this quotation record was last updated in the data platform. Tracks the most recent change for audit and synchronization purposes.',
    `payment_terms` STRING COMMENT 'The payment terms and conditions offered by the vendor, such as net 30, net 60, or advance payment requirements. Critical for cash flow planning and vendor comparison.',
    `price_competitiveness_rank` STRING COMMENT 'The ranking of this quotation relative to other vendor quotations for the same RFQ based on total quoted value. Rank 1 indicates the lowest price.',
    `purchasing_group` STRING COMMENT 'The specialized procurement team or category group handling this quotation. Examples include marine equipment, IT services, or facilities maintenance groups.',
    `purchasing_organization` STRING COMMENT 'The organizational unit within the port authority responsible for this procurement activity. May represent different terminals or business divisions.',
    `quotation_number` STRING COMMENT 'The vendor-assigned quotation reference number. External business identifier used by the vendor to track their quotation submission.',
    `quotation_status` STRING COMMENT 'Current lifecycle status of the vendor quotation in the procurement evaluation workflow. Tracks progression from submission through evaluation to final disposition. [ENUM-REF-CANDIDATE: draft|submitted|under_evaluation|accepted|rejected|withdrawn|expired — 7 candidates stripped; promote to reference product]',
    `quotation_type` STRING COMMENT 'The category of quotation based on procurement context. Distinguishes between standard competitive bids, framework agreements, emergency purchases, and contract renewals.. Valid values are `standard|framework|spot|emergency|contract_renewal`',
    `recommended_for_award_flag` BOOLEAN COMMENT 'Indicates whether the procurement team recommends this quotation for purchase order award. True if recommended, false otherwise.',
    `source_system_key` STRING COMMENT 'The unique identifier of this quotation in the source operational system. Enables traceability back to SAP MM quotation document.',
    `submission_date` DATE COMMENT 'The date when the vendor submitted this quotation to the port authority. Key business event timestamp for tracking response timeliness and evaluation sequencing.',
    `tax_amount` DECIMAL(18,2) COMMENT 'The total tax amount applicable to this quotation. Includes all applicable taxes such as VAT, GST, or customs duties.',
    `technical_compliance_flag` BOOLEAN COMMENT 'Indicates whether the quoted items meet all technical specifications and requirements defined in the RFQ. True if compliant, false if deviations exist.',
    `technical_deviation_notes` STRING COMMENT 'Detailed description of any deviations from the technical specifications requested in the RFQ. Documents alternative materials, dimensions, or performance characteristics offered by the vendor.',
    `total_quoted_value` DECIMAL(18,2) COMMENT 'The total monetary value of all line items in this quotation before taxes and adjustments. Used for comparative bid evaluation and budget verification.',
    `total_value_including_tax` DECIMAL(18,2) COMMENT 'The final total value of the quotation including all taxes and charges. Represents the complete financial commitment if this quotation is accepted.',
    `validity_end_date` DATE COMMENT 'The date until which the quoted prices and terms remain valid. After this date, the vendor may revise pricing or withdraw the offer.',
    `validity_start_date` DATE COMMENT 'The date from which the quoted prices and terms become valid. Defines the beginning of the quotation validity period.',
    `vendor_contact_email` STRING COMMENT 'The email address of the vendor contact person for this quotation. Used for communication regarding quotation clarifications and negotiations.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `vendor_contact_name` STRING COMMENT 'The name of the vendor representative who submitted this quotation. Primary point of contact for clarifications and negotiations.',
    `vendor_contact_phone` STRING COMMENT 'The phone number of the vendor contact person for this quotation. Enables direct communication for urgent procurement matters.',
    `warranty_period_months` STRING COMMENT 'The duration in months for which the vendor provides warranty coverage on supplied goods. Important for lifecycle cost evaluation of port equipment and spare parts.',
    CONSTRAINT pk_vendor_quotation PRIMARY KEY(`vendor_quotation_id`)
) COMMENT 'Vendor-submitted quotation in response to an RFQ, capturing the vendors offered price, delivery lead time, validity period, payment terms, and any deviations from specifications. Supports comparative bid evaluation and vendor selection. Includes quotation number, vendor reference, line-item pricing, total quoted value, currency, and evaluation score. Sourced from SAP MM Quotation (EKKO/EKPO - Doc Type AN with vendor response).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` (
    `purchase_order_id` BIGINT COMMENT 'Unique identifier for the purchase order record. Primary key.',
    `port_location_id` BIGINT COMMENT 'Foreign key linking to masterdata.port_location. Business justification: Port-specific purchases (terminal services, stevedoring, pilotage) require delivery location reference to actual port infrastructure (berths, yards, gates) for service delivery coordination and access',
    `zone_id` BIGINT COMMENT 'Foreign key linking to security.security_zone. Business justification: Purchase orders for security equipment or restricted materials delivered to specific security zones require zone tracking for access authorization, MARSEC-level compliance verification, installation p',
    `vendor_id` BIGINT COMMENT 'Identifier of the vendor to whom the purchase order is issued. Links to the vendor master data.',
    `approval_date` DATE COMMENT 'Date when the purchase order was approved. Key milestone in the procurement lifecycle.',
    `approval_status` STRING COMMENT 'Current approval status of the purchase order in the workflow (not required, pending, approved, rejected). Tracks authorization state.. Valid values are `not_required|pending|approved|rejected`',
    `approved_by` STRING COMMENT 'Name or identifier of the person who approved the purchase order. Captures authorization accountability.',
    `buyer_name` STRING COMMENT 'Name of the procurement buyer or purchasing agent responsible for creating and managing this purchase order.',
    `cancellation_reason` STRING COMMENT 'Reason or explanation for cancelling the purchase order. Provides context for procurement analytics and vendor performance tracking.',
    `cancelled_date` DATE COMMENT 'Date when the purchase order was cancelled. Applicable when PO is terminated before fulfillment.',
    `closed_date` DATE COMMENT 'Date when the purchase order was closed after full receipt and invoice processing. Marks the end of the PO lifecycle.',
    `collective_number` STRING COMMENT 'Collective or batch number grouping multiple purchase orders for consolidated processing or reporting. Used for bulk procurement activities.',
    `company_code` STRING COMMENT 'Code identifying the legal entity or company code for financial accounting purposes. Used for financial postings and reporting.. Valid values are `^[A-Z0-9]{4}$`',
    `contract_reference_number` STRING COMMENT 'Reference number of the master contract or blanket purchase agreement under which this PO is issued. Links PO to long-term procurement agreements.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the purchase order record was first created in the system. Audit trail for record creation.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the purchase order monetary values (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `delivery_address` STRING COMMENT 'Full delivery address where the materials or services are to be delivered. May include terminal, warehouse, or facility address.',
    `delivery_country_code` STRING COMMENT 'Three-letter ISO 3166 country code of the delivery destination (e.g., USA, SGP, GBR).. Valid values are `^[A-Z]{3}$`',
    `delivery_date` DATE COMMENT 'Expected or requested delivery date for the materials or services ordered. Header-level delivery date; line items may have specific dates.',
    `delivery_postal_code` STRING COMMENT 'Postal or ZIP code of the delivery location. Used for logistics planning and freight calculation.',
    `document_date` DATE COMMENT 'Date when the purchase order document was created in the system. Principal business event timestamp for PO creation.',
    `freight_terms` STRING COMMENT 'Terms defining who pays for freight charges (prepaid by vendor, collect from buyer, or third-party billing).. Valid values are `prepaid|collect|third_party`',
    `goods_receipt_indicator` BOOLEAN COMMENT 'Flag indicating whether goods receipt is required for this purchase order. True if GR is mandatory for invoice processing (three-way match).',
    `incoterms` STRING COMMENT 'International Commercial Terms (Incoterms) code defining the responsibilities of buyer and seller for delivery, insurance, and risk transfer (e.g., FOB, CIF, DDP). [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF — 11 candidates stripped; promote to reference product]',
    `incoterms_location` STRING COMMENT 'Named place or port specified in the Incoterms agreement where the transfer of risk and costs occurs (e.g., Port of Los Angeles, Singapore Port).',
    `invoice_receipt_indicator` BOOLEAN COMMENT 'Flag indicating whether invoice receipt is expected for this purchase order. True if invoice verification is required.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the purchase order record was last modified. Audit trail for record updates.',
    `net_order_value` DECIMAL(18,2) COMMENT 'Net total value of the purchase order after applying all discounts, surcharges, and taxes. Final committed amount.',
    `notes` STRING COMMENT 'Free-text notes or special instructions related to the purchase order. May include delivery instructions, quality requirements, or vendor-specific notes.',
    `payment_terms` STRING COMMENT 'Code representing the payment terms agreed with the vendor (e.g., Net 30, Net 60, 2/10 Net 30). Defines payment due date and discount conditions.. Valid values are `^[A-Z0-9]{4,10}$`',
    `plant_code` STRING COMMENT 'Code identifying the port facility, terminal, or plant where the materials or services will be delivered or consumed.. Valid values are `^[A-Z0-9]{4,6}$`',
    `po_number` STRING COMMENT 'Externally-known unique purchase order number assigned by the procurement system. Business identifier for tracking and reference.. Valid values are `^[A-Z0-9]{8,15}$`',
    `po_status` STRING COMMENT 'Current lifecycle status of the purchase order indicating its workflow state (draft, pending approval, approved, issued, partially received, fully received, closed, cancelled). [ENUM-REF-CANDIDATE: draft|pending_approval|approved|issued|partially_received|fully_received|closed|cancelled — 8 candidates stripped; promote to reference product]',
    `po_type` STRING COMMENT 'Classification of the purchase order type indicating the procurement arrangement (standard, blanket, contract, subcontracting, consignment, framework).. Valid values are `standard|blanket|contract|subcontracting|consignment|framework`',
    `priority` STRING COMMENT 'Priority level assigned to the purchase order indicating urgency of fulfillment (low, normal, high, urgent). Affects vendor processing and delivery scheduling.. Valid values are `low|normal|high|urgent`',
    `purchasing_group` STRING COMMENT 'Code identifying the purchasing group or buyer responsible for this purchase order. Key for procurement responsibility and performance tracking.. Valid values are `^[A-Z0-9]{3,6}$`',
    `purchasing_organization` STRING COMMENT 'Code identifying the purchasing organization responsible for procuring materials or services. Organizational unit that negotiates conditions of purchase with vendors.. Valid values are `^[A-Z0-9]{4,10}$`',
    `release_strategy` STRING COMMENT 'Code identifying the approval release strategy applied to this purchase order. Defines the approval workflow and authorization levels required.',
    `requisition_number` STRING COMMENT 'Reference number of the purchase requisition that originated this purchase order. Provides traceability to the procurement request.',
    `requisitioner_name` STRING COMMENT 'Name of the employee or department who requested the purchase. Originator of the procurement requirement.',
    `service_entry_required` BOOLEAN COMMENT 'Flag indicating whether service entry sheet is required for this purchase order. Applicable for service procurement.',
    `shipping_method` STRING COMMENT 'Method of transportation for delivering the ordered materials (sea freight, air freight, road transport, rail transport, courier, multimodal).. Valid values are `sea_freight|air_freight|road_transport|rail_transport|courier|multimodal`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount applicable to the purchase order. Calculated based on tax jurisdiction and vendor tax classification.',
    `total_po_value` DECIMAL(18,2) COMMENT 'Total monetary value of the purchase order including all line items, before taxes and adjustments. Represents committed procurement spend.',
    `vendor_contact_email` STRING COMMENT 'Email address of the vendor contact person. Used for PO transmission and order-related communication.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `vendor_contact_name` STRING COMMENT 'Name of the primary contact person at the vendor organization for this purchase order. Facilitates communication and order management.',
    `vendor_contact_phone` STRING COMMENT 'Phone number of the vendor contact person. Used for urgent order inquiries and coordination.',
    CONSTRAINT pk_purchase_order PRIMARY KEY(`purchase_order_id`)
) COMMENT 'Formal purchase order issued to a vendor for the supply of materials or services to the port. Captures PO header and line-item details including PO number, vendor, document date, delivery date, plant, purchasing organisation, purchasing group, payment terms, incoterms, total PO value, currency, approval status, PO type, and per-line item number, material number, ordered quantity, unit of measure, net price, total value, delivery date, storage location, account assignment, goods receipt indicator, invoice receipt indicator, and delivery status. SSOT for committed procurement spend. Supports granular PO tracking and three-way matching. Sourced from SAP MM PO (EKKO/EKPO).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` (
    `purchase_order_item_id` BIGINT COMMENT 'Unique identifier for the purchase order line item. Primary key for the purchase order item entity.',
    `equipment_type_id` BIGINT COMMENT 'Foreign key linking to masterdata.equipment_type. Business justification: Port equipment purchases (cranes, RTGs, forklifts) require equipment type classification for maintenance planning, certification tracking, spare parts management, and asset lifecycle management. Essen',
    `material_master_id` BIGINT COMMENT 'Reference to the material master record being procured. Identifies the specific material, spare part, or service item ordered in this line.',
    `purchase_order_id` BIGINT COMMENT 'Reference to the parent purchase order header. Links this line item to its containing purchase order document.',
    `supplier_contract_item_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract_item. Business justification: Line-level linkage between PO items and contract line items enables precise contract release tracking, utilization monitoring, and verification that PO pricing/terms match the contracted rates. This i',
    `work_order_id` BIGINT COMMENT 'Reference to maintenance work order when procuring materials or services for maintenance activities. Links procurement to asset maintenance operations.',
    `account_assignment_category` STRING COMMENT 'Type of financial account assignment for this procurement. Determines how costs are allocated in financial accounting and controlling.. Valid values are `cost_center|asset|order|project|sales_order|unknown`',
    `asset_number` STRING COMMENT 'Fixed asset number when procuring capital equipment. Used when account_assignment_category is asset for CAPEX procurement.',
    `confirmation_control_key` STRING COMMENT 'Code defining the type of supplier confirmation required. Controls whether order acknowledgment, shipping notification, or other confirmations are expected.',
    `cost_center` STRING COMMENT 'Cost center to which this procurement expense is charged. Used when account_assignment_category is cost_center.',
    `created_by_user` STRING COMMENT 'Username or employee ID of the procurement officer who created this line item. Provides accountability for procurement decisions.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this purchase order item record was first created in the system. Audit trail for procurement record creation.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code for the net price and order value. Defines the monetary unit for all financial amounts on this line item.. Valid values are `^[A-Z]{3}$`',
    `deletion_indicator` BOOLEAN COMMENT 'Flag indicating this line item has been marked for deletion. When true, the item is cancelled and excluded from further processing.',
    `delivery_date` DATE COMMENT 'Requested or committed delivery date for this line item. Target date by which the supplier should deliver the material or complete the service.',
    `general_ledger_account` STRING COMMENT 'General ledger account number for expense posting. Defines the financial account in the chart of accounts where this procurement cost is recorded.',
    `goods_receipt_indicator` BOOLEAN COMMENT 'Flag indicating whether goods receipt is required for this item. When true, physical receipt must be posted before invoice can be processed.',
    `goods_receipt_quantity` DECIMAL(18,2) COMMENT 'Cumulative quantity of goods received against this purchase order item. Tracks actual receipt progress for three-way matching.',
    `incoterms` STRING COMMENT 'International commercial terms defining delivery responsibilities and risk transfer. Examples: FOB (Free on Board), CIF (Cost Insurance Freight), EXW (Ex Works).',
    `incoterms_location` STRING COMMENT 'Named place or port specified in the Incoterms clause. Defines the geographic point where risk and responsibility transfer occurs.',
    `invoice_receipt_indicator` BOOLEAN COMMENT 'Flag indicating whether invoice verification is required. When true, supplier invoice must be matched and verified before payment.',
    `invoiced_quantity` DECIMAL(18,2) COMMENT 'Cumulative quantity invoiced by the supplier for this line item. Used for three-way matching and invoice verification.',
    `item_category` STRING COMMENT 'Classification of the procurement item type. Determines procurement processing rules, inventory treatment, and account assignment behavior.. Valid values are `standard|consignment|subcontracting|service|stock_transfer|third_party`',
    `item_number` STRING COMMENT 'Sequential line item number within the purchase order. Determines the ordering and position of this item in the PO document.',
    `item_status` STRING COMMENT 'Current delivery and receipt status of the line item. Tracks the fulfillment lifecycle from order placement through final receipt.. Valid values are `open|partially_received|fully_received|closed|cancelled`',
    `manufacturer_part_number` STRING COMMENT 'Original equipment manufacturers part number. Identifies the exact OEM specification for spare parts and equipment procurement.',
    `material_group` STRING COMMENT 'Classification grouping for procurement reporting and analysis. Groups similar materials for spend analysis and supplier performance tracking.',
    `material_number` STRING COMMENT 'Business identifier for the material being procured. External material code used in procurement documents and supplier communication.',
    `modified_by_user` STRING COMMENT 'Username or employee ID of the last person to modify this line item. Audit trail for tracking changes and amendments.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to this purchase order item. Tracks the last change for audit and version control purposes.',
    `net_order_value` DECIMAL(18,2) COMMENT 'Total value of this line item calculated as (ordered_quantity * net_price / price_unit). Represents the line item subtotal before taxes.',
    `net_price` DECIMAL(18,2) COMMENT 'Price per unit of measure agreed with the supplier, excluding taxes and additional charges. Base price used for line item value calculation.',
    `ordered_quantity` DECIMAL(18,2) COMMENT 'Quantity of material or service units ordered in this line item. Represents the total amount requested from the supplier.',
    `outstanding_quantity` DECIMAL(18,2) COMMENT 'Remaining quantity yet to be delivered. Calculated as ordered_quantity minus goods_receipt_quantity.',
    `over_delivery_tolerance_percent` DECIMAL(18,2) COMMENT 'Acceptable percentage by which supplier may exceed ordered quantity. Defines upper limit for goods receipt without requiring PO amendment.',
    `plant_code` STRING COMMENT 'Port facility or plant where the material will be received. Identifies the receiving location within the port organization.',
    `price_unit` STRING COMMENT 'Number of units to which the net price applies. For example, price per 100 units would have price_unit = 100.',
    `purchase_requisition_item` STRING COMMENT 'Line item number within the purchase requisition. Combined with purchase_requisition_number, provides full traceability to the original request.',
    `purchase_requisition_number` STRING COMMENT 'Reference to the originating purchase requisition document. Links the PO item back to the internal request that triggered procurement.',
    `requisitioner_name` STRING COMMENT 'Name of the employee or department that requested this procurement. Identifies the internal customer for the material or service.',
    `short_text` STRING COMMENT 'Brief description of the material or service being procured. Provides human-readable identification of the line item for procurement staff and approvers.',
    `storage_location` STRING COMMENT 'Specific storage location or warehouse within the plant where material will be stocked. Defines the inventory destination for goods receipt.',
    `tax_code` STRING COMMENT 'Tax classification code determining applicable tax rates and treatment. Used for tax calculation and compliance reporting.',
    `under_delivery_tolerance_percent` DECIMAL(18,2) COMMENT 'Acceptable percentage by which supplier may deliver less than ordered quantity. Defines lower limit before item is considered short-shipped.',
    `unit_of_measure` STRING COMMENT 'Unit in which the ordered quantity is expressed. Examples include EA (each), KG (kilogram), M (meter), HR (hour) for services.',
    `vendor_material_number` STRING COMMENT 'Suppliers own part number or catalog code for this material. Used for cross-referencing and supplier communication.',
    CONSTRAINT pk_purchase_order_item PRIMARY KEY(`purchase_order_item_id`)
) COMMENT 'Line-item detail of each purchase order, capturing individual material or service lines. Includes item number, material number, short text, ordered quantity, unit of measure, net price, total value, delivery date, plant, storage location, account assignment, goods receipt indicator, invoice receipt indicator, and item delivery status. Supports granular PO tracking and three-way matching. Sourced from SAP MM PO Item (EKPO).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` (
    `goods_receipt_id` BIGINT COMMENT 'Unique identifier for the goods receipt transaction. Primary key for the goods receipt record.',
    `customs_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.customs_declaration. Business justification: Goods receipts for imported materials require customs clearance before posting. Links GR to the specific customs declaration for duty reconciliation, four-way match validation (PO-GR-Invoice-Customs),',
    `access_point_id` BIGINT COMMENT 'Foreign key linking to security.access_point. Business justification: Goods receipts must record the specific port gate or access point where materials entered the facility for security screening verification, customs clearance documentation, and chain-of-custody compli',
    `material_master_id` BIGINT COMMENT 'Identifier of the material or spare part received. Links to the master data for the procured item.',
    `purchase_order_id` BIGINT COMMENT 'Reference to the purchase order against which goods are received. Links the goods receipt to the originating procurement document.',
    `purchase_order_item_id` BIGINT COMMENT 'Reference to the specific line item on the purchase order for which goods are being received.',
    `employee_id` BIGINT COMMENT 'Identifier of the employee who performed the goods receipt. Links to workforce management for accountability and audit trail.',
    `asset_location_id` BIGINT COMMENT 'Identifier of the specific storage location or warehouse within the plant where the received goods are stored.',
    `vendor_id` BIGINT COMMENT 'Identifier of the vendor who delivered the materials or spare parts. Key party reference for supplier performance tracking.',
    `vessel_master_id` BIGINT COMMENT 'Foreign key linking to masterdata.vessel_master. Business justification: Goods received from vessels (ship spares, bunkers, provisions delivered by supply vessels) require vessel tracking for cargo reconciliation, customs clearance, and bill of lading matching in port oper',
    `batch_number` STRING COMMENT 'The batch or lot number assigned to the received materials for traceability and quality control purposes. Critical for spare parts and consumables management.',
    `bill_of_lading_number` STRING COMMENT 'The bill of lading number associated with the shipment, if goods were received via maritime transport. Links to cargo documentation.',
    `carrier_name` STRING COMMENT 'Name of the logistics carrier or freight forwarder who delivered the goods to the port.',
    `certificate_of_origin_number` STRING COMMENT 'The certificate of origin document number, if applicable for the received goods. Required for certain international trade transactions.',
    `container_number` STRING COMMENT 'ISO 6346 container identification number if the goods were delivered in a shipping container. Follows format: 4 letters (owner code) + 7 digits (serial + check digit).. Valid values are `^[A-Z]{4}[0-9]{7}$`',
    `country_of_origin` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code indicating where the goods were manufactured or produced. Required for trade compliance and preferential tariff determination.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when the goods receipt record was first created in the system. Audit trail for record creation.',
    `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code in which the valuation amount is denominated. [ENUM-REF-CANDIDATE: USD|EUR|GBP|JPY|CNY|AED|SGD — 7 candidates stripped; promote to reference product]',
    `delivery_date` DATE COMMENT 'The actual date on which the goods were physically delivered to the port facility by the vendor.',
    `delivery_note_number` STRING COMMENT 'The delivery note or packing slip number provided by the vendor with the shipment. Used for cross-referencing vendor documentation.',
    `document_date` DATE COMMENT 'The date printed on the goods receipt document. May differ from posting date for backdated or forward-dated transactions.',
    `document_number` STRING COMMENT 'The externally-known unique document number assigned to this goods receipt transaction in the SAP MM system. Used for tracking and audit purposes.. Valid values are `^[A-Z0-9]{10}$`',
    `goods_receipt_status` STRING COMMENT 'Current lifecycle status of the goods receipt transaction. Tracks the document through its workflow from creation to completion or reversal.. Valid values are `draft|posted|reversed|cancelled|completed`',
    `hs_code` STRING COMMENT 'The Harmonized System tariff classification code for the received material. Used for customs, duties, and trade compliance.. Valid values are `^[0-9]{6,10}$`',
    `inspection_lot_number` STRING COMMENT 'The quality inspection lot number created for the received goods, if quality inspection is required.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when the goods receipt record was last updated or modified. Audit trail for record changes.',
    `material_document_year` STRING COMMENT 'Fiscal year in which the goods receipt material document was posted. Part of the compound key in SAP MM for document identification.',
    `movement_type` STRING COMMENT 'SAP MM movement type code indicating the nature of the goods receipt transaction. 101=GR for PO, 102=GR reversal, 103=GR into blocked stock, 105=GR from release order, 161=GR for returnable transport packaging, 501=GR without PO, 511=GR from delivery without PO. [ENUM-REF-CANDIDATE: 101|102|103|105|161|501|511 — 7 candidates stripped; promote to reference product]',
    `notes` STRING COMMENT 'Free-text notes or comments recorded by the receiving personnel regarding the condition of goods, delivery issues, or special handling requirements.',
    `ordered_quantity` DECIMAL(18,2) COMMENT 'The quantity originally ordered on the purchase order line item. Used for variance analysis and three-way matching.',
    `plant_code` BIGINT COMMENT 'Identifier of the port facility or plant where the goods were received. Represents the receiving location within the port infrastructure.',
    `posting_date` DATE COMMENT 'The date on which the goods receipt transaction was posted in the financial and materials management system. Principal business event timestamp for the receipt.',
    `quality_inspection_status` STRING COMMENT 'Current status of quality inspection for the received goods. Determines whether materials can be released for operational use.. Valid values are `not_required|pending|in_progress|passed|failed|conditional`',
    `received_quantity` DECIMAL(18,2) COMMENT 'The quantity of materials or spare parts physically received and accepted. Principal quantitative fact for the goods receipt transaction.',
    `receiver_name` STRING COMMENT 'Name of the port employee or warehouse personnel who physically received and verified the goods.',
    `serial_number` STRING COMMENT 'The unique serial number of the received item, applicable for serialized assets and high-value spare parts.',
    `stock_type` STRING COMMENT 'The type of stock into which the goods were received. Unrestricted=available for use, quality_inspection=pending QC approval, blocked=not available for use, restricted=limited use authorization.. Valid values are `unrestricted|quality_inspection|blocked|restricted`',
    `three_way_match_status` STRING COMMENT 'Status of the three-way matching process comparing purchase order, goods receipt, and vendor invoice. Critical for invoice verification and payment authorization.. Valid values are `not_started|matched|variance_detected|approved|rejected`',
    `transport_mode` STRING COMMENT 'The mode of transportation used to deliver the goods to the port facility. Relevant for intermodal logistics coordination.. Valid values are `truck|rail|vessel|barge|air|courier`',
    `unit_of_measure` STRING COMMENT 'The unit in which the received quantity is measured. Common maritime logistics units include EA=Each, KG=Kilogram, L=Liter, M=Meter, TON=Metric Ton, CBM=Cubic Meter, TEU=Twenty-foot Equivalent Unit, FEU=Forty-foot Equivalent Unit. [ENUM-REF-CANDIDATE: EA|KG|L|M|M2|M3|TON|CBM|TEU|FEU — 10 candidates stripped; promote to reference product]',
    `unit_price` DECIMAL(18,2) COMMENT 'The price per unit of measure for the received material, as per the purchase order. Used for valuation and variance analysis.',
    `unloading_point` STRING COMMENT 'The specific dock, gate, or unloading area within the port facility where the goods were received. Relevant for terminal operations and logistics tracking.',
    `valuation_amount` DECIMAL(18,2) COMMENT 'The total monetary value of the goods received, calculated based on the purchase order price and received quantity. Used for inventory valuation and financial posting.',
    `variance_quantity` DECIMAL(18,2) COMMENT 'The difference between ordered quantity and received quantity. Positive values indicate over-delivery, negative values indicate under-delivery.',
    `variance_reason_code` STRING COMMENT 'Code indicating the reason for any quantity or quality variance between ordered and received goods. Used for supplier performance evaluation.. Valid values are `damage|shortage|overage|quality_issue|wrong_item|partial_delivery`',
    `vehicle_registration_number` STRING COMMENT 'Registration or license plate number of the truck or vehicle that delivered the goods. Used for gate operations and security tracking.',
    CONSTRAINT pk_goods_receipt PRIMARY KEY(`goods_receipt_id`)
) COMMENT 'Record of physical receipt of materials or spare parts delivered by a vendor against a purchase order. Captures goods receipt document number, posting date, delivery note number, vendor, plant, storage location, received quantity, unit of measure, batch number, and quality inspection status. Triggers inventory update and initiates three-way matching for invoice verification. Sourced from SAP MM Goods Receipt (MKPF/MSEG - Movement Type 101).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` (
    `service_entry_sheet_id` BIGINT COMMENT 'Unique identifier for the service entry sheet record. Primary key.',
    `booking_service_order_id` BIGINT COMMENT 'Foreign key linking to booking.booking_service_order. Business justification: Service entry sheets accept vendor-provided services (pilotage, towage, mooring, waste disposal) requested via booking service orders. Enables three-way match: service order request → vendor performan',
    `employee_id` BIGINT COMMENT 'Reference to the employee or user who accepted the services and approved the service entry sheet.',
    `purchase_order_id` BIGINT COMMENT 'Reference to the service purchase order or blanket order under which the services were rendered.',
    `service_employee_id` BIGINT COMMENT 'Reference to the user who last modified the service entry sheet record.',
    `supplier_contract_id` BIGINT COMMENT 'Reference to the master service contract or blanket purchase agreement under which this service entry sheet was created.',
    `tertiary_service_created_by_user_employee_id` BIGINT COMMENT 'Reference to the user who created the service entry sheet record.',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor who rendered the services under the purchase order.',
    `acceptance_date` DATE COMMENT 'Date on which the services were formally accepted by the receiving organization.',
    `acceptance_timestamp` TIMESTAMP COMMENT 'Precise timestamp when the service entry sheet was accepted, including time zone information.',
    `accepted_by_name` STRING COMMENT 'Full name of the person who accepted the services.',
    `approval_date` DATE COMMENT 'Date on which the service entry sheet received final approval.',
    `approval_status` STRING COMMENT 'Current approval status of the service entry sheet in the multi-level approval workflow.. Valid values are `pending|approved|rejected`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity for which the services were procured.. Valid values are `^[A-Z0-9]{4}$`',
    `cost_center` STRING COMMENT 'Cost center to which the service costs are allocated for financial controlling purposes.. Valid values are `^[A-Z0-9]{10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the service entry sheet record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the accepted value (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `document_date` DATE COMMENT 'Date on which the service entry sheet document was created or issued by the vendor.',
    `fiscal_period` STRING COMMENT 'Fiscal period (month) within the fiscal year in which the service entry sheet was posted.',
    `fiscal_year` STRING COMMENT 'Fiscal year in which the service entry sheet was posted for financial reporting purposes.',
    `gl_account_code` STRING COMMENT 'General ledger account code to which the service expense is posted in financial accounting.. Valid values are `^[0-9]{6,10}$`',
    `invoice_verification_status` STRING COMMENT 'Status of invoice verification process against this service entry sheet, required for payment release.. Valid values are `not_started|in_progress|completed|blocked`',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the service entry sheet record was last modified.',
    `payment_release_status` STRING COMMENT 'Status indicating whether payment has been released for the accepted services.. Valid values are `not_released|released|paid|blocked`',
    `plant_code` STRING COMMENT 'SAP plant code representing the port facility or operational site where the services were delivered.. Valid values are `^[A-Z0-9]{4}$`',
    `posting_date` DATE COMMENT 'Date on which the service entry sheet was posted to financial accounting and inventory management.',
    `reference_document_number` STRING COMMENT 'External reference number from vendor documentation or delivery note associated with the service delivery.',
    `rejection_reason` STRING COMMENT 'Reason for rejection if the service entry sheet was not accepted, including quality or compliance issues.',
    `remarks` STRING COMMENT 'Additional notes or comments regarding the service acceptance, quality issues, or special conditions.',
    `service_description` STRING COMMENT 'Detailed textual description of the services rendered and accepted under this service entry sheet.',
    `service_entry_sheet_number` STRING COMMENT 'Externally-known business identifier for the service entry sheet, typically a 10-character alphanumeric code assigned by SAP MM upon creation.. Valid values are `^[A-Z0-9]{10}$`',
    `service_entry_sheet_status` STRING COMMENT 'Current lifecycle status of the service entry sheet in the approval and posting workflow.. Valid values are `draft|submitted|accepted|rejected|cancelled|posted`',
    `service_period_end_date` DATE COMMENT 'End date of the period during which the services were rendered.',
    `service_period_start_date` DATE COMMENT 'Start date of the period during which the services were rendered.',
    `service_type_code` STRING COMMENT 'Classification code identifying the type of service rendered (e.g., maintenance, pilotage, towage, dredging, consulting).. Valid values are `^[A-Z0-9]{4,10}$`',
    `total_accepted_quantity` DECIMAL(18,2) COMMENT 'Total quantity of services accepted across all line items in this service entry sheet, measured in the unit of measure specified per line.',
    `total_accepted_value` DECIMAL(18,2) COMMENT 'Total monetary value of all accepted services in this service entry sheet, calculated as sum of line item values.',
    CONSTRAINT pk_service_entry_sheet PRIMARY KEY(`service_entry_sheet_id`)
) COMMENT 'Record confirming the completion and acceptance of services rendered by a vendor under a service purchase order or blanket order. Captures service entry sheet number, service PO reference, service line items, accepted quantities, acceptance date, accepted by, total accepted value, and approval status. Required for service invoice verification and payment release. Sourced from SAP MM Service Entry Sheet (ESLH/ESLL).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` (
    `vendor_invoice_id` BIGINT COMMENT 'Unique identifier for the vendor invoice record. Primary key for the vendor invoice entity.',
    `goods_receipt_id` BIGINT COMMENT 'Reference to the goods receipt document confirming materials or services were received. Used for three-way matching validation.',
    `purchase_order_id` BIGINT COMMENT 'Reference to the purchase order against which this invoice is submitted. Used for three-way matching (PO-GR-Invoice).',
    `purchase_order_item_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order_item. Business justification: Invoice verification at line-item level (not just header) enables precise quantity and price matching against PO line items. This supports detailed variance analysis and line-level payment blocking. N',
    `service_entry_sheet_id` BIGINT COMMENT 'Foreign key linking to procurement.service_entry_sheet. Business justification: Vendor invoices for services require linkage to service entry sheets for 3-way match verification (PO + SES + Invoice). This is the service equivalent of goods_receipt_id for material invoices. New at',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor who submitted this invoice. Links to the vendor master data entity.',
    `baseline_date` DATE COMMENT 'The reference date used for calculating payment due date and cash discount periods. Typically the invoice date or goods receipt date.',
    `cash_discount_amount` DECIMAL(18,2) COMMENT 'The discount amount available if payment is made within the early payment discount period specified in payment terms.',
    `cash_discount_percentage` DECIMAL(18,2) COMMENT 'The percentage discount rate applicable for early payment within the discount period.',
    `company_code` STRING COMMENT 'The company code (legal entity) within the port organization to which this invoice is assigned for accounting purposes.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time this invoice record was first created in the system. Record audit trail for data lineage.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the invoice amounts. Determines the currency in which the vendor will be paid.. Valid values are `^[A-Z]{3}$`',
    `document_header_text` STRING COMMENT 'Free-text field for additional notes or comments at the invoice header level. May include special instructions or explanations.',
    `fiscal_period` STRING COMMENT 'The fiscal period (month) within the fiscal year in which the invoice was posted.',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the invoice was posted for financial reporting purposes.',
    `invoice_date` DATE COMMENT 'The date the vendor issued the invoice. Principal business event timestamp for this transaction. Used for aging analysis and payment term calculation.',
    `invoice_gross_amount` DECIMAL(18,2) COMMENT 'Total gross amount invoiced by the vendor before any deductions. Includes base amount plus tax and other charges.',
    `invoice_net_amount` DECIMAL(18,2) COMMENT 'Net amount invoiced excluding tax. Base amount for goods or services before tax calculation.',
    `invoice_number` STRING COMMENT 'The vendor-assigned invoice number as printed on the invoice document. Business identifier for external reference and vendor reconciliation.',
    `invoice_receipt_date` DATE COMMENT 'The date the invoice document was received by the port organization. Used for tracking invoice processing cycle time.',
    `invoice_status` STRING COMMENT 'Current lifecycle status of the invoice in the verification and payment workflow. Parked invoices are saved but not posted; blocked invoices require approval; cleared invoices are approved for payment; posted invoices are in accounts payable; cancelled or reversed invoices are voided.. Valid values are `parked|blocked|cleared|posted|cancelled|reversed`',
    `invoice_type` STRING COMMENT 'Classification of the invoice document type. Standard invoices are for goods/services delivered; credit memos reduce amounts owed; debit memos increase amounts owed; prepayment and down payment invoices are advance payments; final invoices settle the remaining balance.. Valid values are `standard|credit_memo|debit_memo|prepayment|down_payment|final_invoice`',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time this invoice record was last modified. Record audit trail for change tracking.',
    `payment_block_code` STRING COMMENT 'Code indicating the invoice is blocked for payment pending resolution of discrepancies or approval. Empty if not blocked.',
    `payment_block_reason` STRING COMMENT 'Detailed explanation of why the invoice is blocked for payment. May include quantity variance, price variance, or missing approvals.',
    `payment_date` DATE COMMENT 'The actual date payment was made to the vendor. Null if invoice is not yet paid.',
    `payment_due_date` DATE COMMENT 'The date by which payment must be made to the vendor to comply with payment terms. Calculated from invoice date and payment terms.',
    `payment_method` STRING COMMENT 'The method by which payment will be made to the vendor. Determines payment processing workflow and bank account selection.. Valid values are `bank_transfer|check|wire_transfer|ach|credit_card|letter_of_credit`',
    `payment_reference` STRING COMMENT 'Reference number assigned when payment is executed. Links the invoice to the actual payment transaction for reconciliation.',
    `payment_terms` STRING COMMENT 'Payment terms code defining the due date calculation and any early payment discount conditions. Examples include Net 30, 2/10 Net 30.',
    `posting_date` DATE COMMENT 'The date the invoice was posted to the financial accounting system. Determines the fiscal period for accounting purposes.',
    `price_variance` DECIMAL(18,2) COMMENT 'The difference between invoiced price and purchase order price. Used to identify pricing discrepancies requiring approval or vendor correction.',
    `quantity_variance` DECIMAL(18,2) COMMENT 'The difference between invoiced quantity and goods receipt quantity. Positive values indicate over-invoicing; negative values indicate under-invoicing.',
    `reversal_date` DATE COMMENT 'The date the invoice was reversed or cancelled. Null if not reversed.',
    `reversal_indicator` BOOLEAN COMMENT 'Flag indicating whether this invoice has been reversed or cancelled. True if reversed; false otherwise.',
    `reversal_reason` STRING COMMENT 'Explanation of why the invoice was reversed. May include duplicate invoice, incorrect amount, or vendor request.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount charged on the invoice. May include VAT, GST, sales tax, or other applicable taxes based on jurisdiction.',
    `tax_code` STRING COMMENT 'Tax code applied to the invoice determining the tax rate and tax type. Configured per jurisdiction and material/service category.',
    `three_way_match_status` STRING COMMENT 'Status of the three-way matching process comparing purchase order, goods receipt, and invoice. Matched indicates all three documents align within tolerance; variances indicate discrepancies requiring resolution.. Valid values are `matched|quantity_variance|price_variance|not_matched|bypassed`',
    `vendor_reference_number` STRING COMMENT 'Additional reference number provided by the vendor for their internal tracking or delivery note reference. May include packing slip number or vendor order number.',
    `verification_date` DATE COMMENT 'The date the invoice was verified and approved for payment. Marks completion of three-way matching and approval workflow.',
    `verified_by` STRING COMMENT 'User ID or name of the person who verified and approved the invoice for payment.',
    `withholding_tax_amount` DECIMAL(18,2) COMMENT 'Tax amount withheld from vendor payment as required by tax regulations. Remitted directly to tax authorities on behalf of the vendor.',
    `withholding_tax_code` STRING COMMENT 'Code identifying the type and rate of withholding tax applied to the invoice.',
    CONSTRAINT pk_vendor_invoice PRIMARY KEY(`vendor_invoice_id`)
) COMMENT 'Vendor-submitted invoice for materials delivered or services rendered to the port, pending verification and payment. Captures invoice number, vendor reference, invoice date, PO reference, invoiced quantity, invoiced amount, tax amount, currency, payment due date, and invoice verification status (blocked, cleared, parked). Supports three-way matching (PO–GR–Invoice) and accounts payable processing. Sourced from SAP MM Invoice Verification (RBKP/RSEG - LIV).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` (
    `supplier_contract_id` BIGINT COMMENT 'Unique identifier for the supplier contract record. Primary key.',
    `vendor_id` BIGINT COMMENT 'Reference to the supplier or vendor party with whom this contract is established.',
    `amendment_count` STRING COMMENT 'Total number of amendments or change orders issued against this contract since its inception.',
    `approval_date` DATE COMMENT 'Date on which the contract received final approval and authorization for execution.',
    `approval_status` STRING COMMENT 'Current approval workflow status indicating whether the contract has been reviewed and authorized by appropriate authorities.. Valid values are `pending|approved|rejected|under_review`',
    `approved_by` STRING COMMENT 'Name or identifier of the authorized person who approved this contract for execution.',
    `commodity_code` STRING COMMENT 'Classification code identifying the primary commodity or material group covered by this contract (e.g., spare parts, fuel, services).',
    `company_code` STRING COMMENT 'The legal entity or company code within the enterprise that holds financial accountability for this contract.',
    `compliance_requirements` STRING COMMENT 'Regulatory, safety, environmental, or quality compliance standards that the vendor must adhere to under this contract (e.g., ISO certifications, ISPS, MARPOL).',
    `confidentiality_clause` STRING COMMENT 'Non-disclosure and confidentiality obligations binding the vendor regarding proprietary information, trade secrets, and business data.',
    `contract_description` STRING COMMENT 'Detailed textual description of the contract scope, materials, services, and special terms covered by this agreement.',
    `contract_document_reference` STRING COMMENT 'Reference identifier or file path to the signed contract document stored in the document management system.',
    `contract_number` STRING COMMENT 'Externally-known unique business identifier for the procurement contract. Used in SAP MM as the outline agreement number (EKKO-EBELN).',
    `contract_owner` STRING COMMENT 'Name or identifier of the procurement manager or contract administrator responsible for this agreement.',
    `contract_status` STRING COMMENT 'Current lifecycle status of the supplier contract indicating its operational state and validity.. Valid values are `draft|active|suspended|expired|terminated|closed`',
    `contract_type` STRING COMMENT 'Classification of the procurement contract type. Maps to SAP MM document types: MK (Quantity Contract), WK (Value Contract), LP (Scheduling Agreement), LPA (Framework Agreement).. Valid values are `blanket_purchase_order|scheduling_agreement|quantity_contract|value_contract|framework_agreement|outline_agreement`',
    `contract_value` DECIMAL(18,2) COMMENT 'Total monetary value of the contract representing the maximum commitment or target spend over the contract period.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this contract record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the contract value and pricing (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `delivery_location` STRING COMMENT 'Named location or address where goods or services under this contract are to be delivered.',
    `dispute_resolution_method` STRING COMMENT 'Agreed mechanism for resolving disputes arising from the contract, including jurisdiction and arbitration clauses.. Valid values are `negotiation|mediation|arbitration|litigation`',
    `governing_law` STRING COMMENT 'Legal jurisdiction and governing law under which the contract is executed and disputes are resolved.',
    `incoterms` STRING COMMENT 'International Commercial Terms defining the responsibilities, costs, and risks between buyer and seller for delivery of goods. [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF — 11 candidates stripped; promote to reference product]',
    `insurance_requirements` STRING COMMENT 'Mandatory insurance coverage and liability protection that the vendor must maintain during the contract period.',
    `last_amendment_date` DATE COMMENT 'Date of the most recent amendment or modification made to the contract terms.',
    `modified_by` STRING COMMENT 'User identifier or name of the person who last modified this contract record in the system.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this contract record was last updated or modified in the system.',
    `payment_terms` STRING COMMENT 'Standard payment terms and conditions agreed with the vendor, including net due days and discount terms (e.g., Net 30, 2/10 Net 30).',
    `penalty_clause` STRING COMMENT 'Contractual penalties and liquidated damages applicable for non-performance, late delivery, or quality failures by the vendor.',
    `plant_code` STRING COMMENT 'The port facility, terminal, or plant location where materials or services under this contract will be delivered or performed.',
    `purchasing_group` STRING COMMENT 'The buyer group or procurement team responsible for operational management of this contract.',
    `purchasing_organization` STRING COMMENT 'The organizational unit responsible for negotiating and managing this contract within the enterprise structure.',
    `quantity_unit` STRING COMMENT 'Unit of measure for the target quantity (e.g., EA for each, TON for metric tons, CBM for cubic meters).',
    `released_quantity` DECIMAL(18,2) COMMENT 'Cumulative quantity of materials or services released through purchase orders against this contract to date.',
    `released_value` DECIMAL(18,2) COMMENT 'Cumulative monetary value of all release orders or call-offs issued against this contract to date.',
    `renewal_terms` STRING COMMENT 'Conditions and provisions for contract renewal, including automatic renewal clauses, notice periods, and renewal pricing adjustments.',
    `risk_classification` STRING COMMENT 'Risk level assigned to this contract based on vendor reliability, commodity criticality, and supply chain exposure.. Valid values are `low|medium|high|critical`',
    `service_level_agreement` STRING COMMENT 'Defined service level commitments, performance metrics, and quality standards that the vendor must meet under this contract.',
    `target_quantity` DECIMAL(18,2) COMMENT 'Planned or target quantity of materials or services to be procured over the contract period. Applicable for quantity contracts.',
    `termination_clause` STRING COMMENT 'Legal provisions and conditions under which either party may terminate the contract, including notice periods and penalties.',
    `utilization_percentage` DECIMAL(18,2) COMMENT 'Percentage of contract value or quantity that has been utilized through release orders, calculated as (released / target) * 100.',
    `valid_from_date` DATE COMMENT 'Start date from which the contract becomes legally binding and operationally effective.',
    `valid_to_date` DATE COMMENT 'End date until which the contract remains valid. Nullable for open-ended contracts.',
    `vendor_performance_rating` STRING COMMENT 'Overall performance rating of the vendor under this contract based on delivery, quality, and service metrics.. Valid values are `excellent|good|satisfactory|poor|unrated`',
    `created_by` STRING COMMENT 'User identifier or name of the person who created this contract record in the system.',
    CONSTRAINT pk_supplier_contract PRIMARY KEY(`supplier_contract_id`)
) COMMENT 'Long-term procurement contracts and framework agreements established with vendors for recurring supply of materials or services, including blanket purchase orders, scheduling agreements, and outline agreements. Captures contract header and line-item details including contract number, vendor, contract type, validity period, total contract value, commodity scope, payment terms, penalty clauses, renewal terms, and per-line material/service lines, agreed quantities, target values, pricing conditions, and release order history. Supports contract utilisation tracking, release order management, and contract compliance monitoring. Sourced from SAP MM Outline Agreement (EKKO/EKPO - Doc Types MK, WK, LP, LPA).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` (
    `supplier_contract_item_id` BIGINT COMMENT 'Unique identifier for the supplier contract line item. Primary key for this entity.',
    `material_master_id` BIGINT COMMENT 'Reference to the material or spare part being procured under this contract line. Links to the master material catalog.',
    `supplier_contract_id` BIGINT COMMENT 'Reference to the parent supplier contract or framework agreement header. Links this line item to the master contract.',
    `blocking_indicator` BOOLEAN COMMENT 'Flag indicating whether this contract line is temporarily blocked from use in release orders. Used for quality holds or contractual disputes.',
    `contract_item_number` STRING COMMENT 'Sequential line item number within the contract document. Used for ordering and referencing specific contract lines.. Valid values are `^[0-9]{5,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this contract line item record was first created in the system. Part of audit trail.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code for the contract line pricing. Examples: USD, EUR, GBP, SGD.. Valid values are `^[A-Z]{3}$`',
    `deletion_indicator` BOOLEAN COMMENT 'Flag indicating whether this contract line item is marked for deletion. When true, the line is logically deleted but retained for audit purposes.',
    `delivery_lead_time_days` STRING COMMENT 'Standard number of calendar days from release order placement to expected delivery at the destination. Used for planning and scheduling.',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Negotiated discount percentage applied to the net price for this contract line. Used for pricing calculations on release orders.',
    `goods_receipt_required` BOOLEAN COMMENT 'Flag indicating whether a goods receipt must be posted for materials ordered against this contract line. Controls inventory management integration.',
    `incoterms` STRING COMMENT 'International Commercial Terms defining the delivery terms and transfer of risk between supplier and buyer. Examples: FOB (Free On Board), CIF (Cost Insurance Freight), DDP (Delivered Duty Paid). [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF — 11 candidates stripped; promote to reference product]',
    `incoterms_location` STRING COMMENT 'Named place or port specified in the Incoterms clause where risk and cost transfer occurs. Examples: Port of Singapore, Supplier Warehouse.',
    `invoice_receipt_required` BOOLEAN COMMENT 'Flag indicating whether invoice verification is required for orders against this contract line. Controls accounts payable integration.',
    `item_category` STRING COMMENT 'Classification of the contract line item type. Determines procurement behavior and release order processing rules.. Valid values are `standard|consignment|subcontracting|service|limit|blanket`',
    `item_status` STRING COMMENT 'Current lifecycle status of the contract line item. Controls whether the line can be used for release orders and tracks utilization state.. Valid values are `draft|active|suspended|expired|closed|cancelled`',
    `last_goods_receipt_date` DATE COMMENT 'Date when the most recent goods receipt was posted for materials ordered against this contract line. Tracks fulfillment activity.',
    `last_release_order_date` DATE COMMENT 'Date when the most recent release order was created against this contract line. Used for contract activity monitoring.',
    `manufacturer_part_number` STRING COMMENT 'Original equipment manufacturer part number for the contracted material. Used for precise material identification and cross-referencing.',
    `material_description` STRING COMMENT 'Short text description of the material or service being contracted. Provides human-readable context for the line item.',
    `material_group` STRING COMMENT 'Material group classification code for procurement categorization and reporting. Groups similar materials for analysis.. Valid values are `^[A-Z0-9]{8,10}$`',
    `maximum_order_quantity` DECIMAL(18,2) COMMENT 'Maximum quantity that can be ordered per release against this contract line. Enforces capacity or contractual constraints.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity that must be ordered per release against this contract line. Enforces supplier minimum order requirements.',
    `modified_by` STRING COMMENT 'User ID or name of the person who last modified this contract line item record. Part of audit trail for change tracking.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this contract line item record was last modified. Tracks the most recent change for audit purposes.',
    `net_price` DECIMAL(18,2) COMMENT 'Agreed unit price for the material or service excluding taxes and surcharges. Base price used for release order valuation.',
    `order_quantity_multiple` DECIMAL(18,2) COMMENT 'Quantity increment or rounding value for release orders. Orders must be placed in multiples of this value (e.g., multiples of 10 units).',
    `payment_terms` STRING COMMENT 'Payment terms code defining the payment schedule and discount conditions for this contract line. Examples: Net 30, 2/10 Net 30.. Valid values are `^[A-Z0-9]{4}$`',
    `plant_code` STRING COMMENT 'Port facility or plant code where the contracted material or service will be delivered or performed. Links to organizational structure.. Valid values are `^[A-Z0-9]{4}$`',
    `price_unit` STRING COMMENT 'Number of units to which the net price applies. For example, price per 100 units would have price_unit = 100.',
    `purchasing_group` STRING COMMENT 'Buyer or purchasing group responsible for managing this contract line. Used for workload distribution and accountability.. Valid values are `^[A-Z0-9]{3}$`',
    `quality_inspection_required` BOOLEAN COMMENT 'Flag indicating whether incoming materials must undergo quality inspection before acceptance. Triggers quality management workflows.',
    `released_quantity` DECIMAL(18,2) COMMENT 'Cumulative quantity already released against this contract line through purchase orders or release orders. Used for contract utilization tracking.',
    `released_value` DECIMAL(18,2) COMMENT 'Cumulative monetary value already released against this contract line through purchase orders. Tracks spend against target value.',
    `remaining_quantity` DECIMAL(18,2) COMMENT 'Remaining quantity available for release under this contract line. Calculated as target_quantity minus released_quantity.',
    `remaining_value` DECIMAL(18,2) COMMENT 'Remaining monetary value available for release under this contract line. Calculated as target_value minus released_value.',
    `service_description` STRING COMMENT 'Detailed description of the service being contracted when the line item represents a service rather than a material. Used for service-based contracts.',
    `storage_location` STRING COMMENT 'Specific storage location or warehouse within the plant where materials will be received. Used for inventory management integration.. Valid values are `^[A-Z0-9]{4}$`',
    `target_quantity` DECIMAL(18,2) COMMENT 'Planned or target quantity of material or service units to be procured under this contract line over the contract period. Used for contract utilization tracking.',
    `target_value` DECIMAL(18,2) COMMENT 'Total planned monetary value for this contract line over the contract period. Calculated as target_quantity multiplied by net_price, adjusted for price_unit.',
    `tax_code` STRING COMMENT 'Tax classification code determining applicable tax rates and treatment for this contract line. Used for tax calculation on release orders.. Valid values are `^[A-Z0-9]{2}$`',
    `technical_specification_reference` STRING COMMENT 'Reference to technical specification document or standard that the contracted material or service must meet. Examples: ISO standard, IMO regulation, port technical specification.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the contracted quantity. Examples: EA (each), KG (kilogram), M (meter), HR (hour), CBM (cubic meter).. Valid values are `^[A-Z]{2,3}$`',
    `validity_end_date` DATE COMMENT 'Date on which this contract line item expires and can no longer be used for release orders. Defines the contract line validity period.',
    `validity_start_date` DATE COMMENT 'Date from which this contract line item becomes effective and can be used for release orders. Part of the contract line validity period.',
    `warranty_period_months` STRING COMMENT 'Duration in months for which the supplier provides warranty coverage for materials or services under this contract line.',
    `created_by` STRING COMMENT 'User ID or name of the person who created this contract line item record. Part of audit trail for accountability.',
    CONSTRAINT pk_supplier_contract_item PRIMARY KEY(`supplier_contract_item_id`)
) COMMENT 'Line-item detail of supplier contracts and framework agreements, capturing individual material or service lines with agreed quantities, target values, pricing conditions, and release order history. Supports contract utilisation tracking and release order management. Sourced from SAP MM Outline Agreement Item (EKPO).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` (
    `vendor_evaluation_id` BIGINT COMMENT 'Unique identifier for the vendor evaluation record. Primary key for the vendor evaluation entity.',
    `employee_id` BIGINT COMMENT 'Reference to the employee who conducted the vendor evaluation. Links to workforce master data.',
    `kpi_id` BIGINT COMMENT 'Foreign key linking to safety.safety_kpi. Business justification: Vendor HSSE performance scores (contractor incident rates, environmental compliance, safety audit results) are formal evaluation criteria. Safety KPI linkage enables quantitative vendor scoring, perfo',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor being evaluated. Links to the vendor master data in the procurement domain.',
    `approval_date` DATE COMMENT 'Date when the vendor evaluation was formally approved by management. Represents the point at which evaluation results become official and actionable.',
    `approved_by` STRING COMMENT 'Name of the manager or procurement director who approved the vendor evaluation. Captures approval authority for audit trail purposes.',
    `corrective_action_description` STRING COMMENT 'Description of the corrective actions required from the vendor. Details specific performance improvements, process changes, or compliance measures that must be implemented.',
    `corrective_action_due_date` DATE COMMENT 'Target date by which the vendor must complete required corrective actions. Used to track vendor response and follow-up evaluation scheduling.',
    `corrective_action_required` BOOLEAN COMMENT 'Flag indicating whether the vendor is required to implement corrective actions based on evaluation findings. True if performance deficiencies require formal remediation.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the vendor evaluation record was first created in the system. Audit trail field for record lifecycle tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the total purchase value. Indicates the currency in which vendor transactions were conducted during the evaluation period.. Valid values are `^[A-Z]{3}$`',
    `current_vendor_tier` STRING COMMENT 'Current classification tier of the vendor prior to this evaluation. Preferred vendors receive priority in sourcing, approved vendors meet minimum standards, conditional vendors have restrictions, probation vendors are under performance improvement plans, and blocked vendors are suspended from new business.. Valid values are `preferred|approved|conditional|probation|blocked`',
    `documentation_compliance_score` DECIMAL(18,2) COMMENT 'Performance score for vendor adherence to documentation requirements including certificates, test reports, material safety data sheets, customs documentation, and trade compliance paperwork during the evaluation period.',
    `documentation_compliance_weight` DECIMAL(18,2) COMMENT 'Weighting factor applied to the documentation compliance score in the overall score calculation. Expressed as a percentage or decimal fraction.',
    `evaluation_comments` STRING COMMENT 'Free-text comments and observations from the evaluator. Captures qualitative feedback, notable incidents, improvement areas, and strengths observed during the evaluation period.',
    `evaluation_date` DATE COMMENT 'Date when the vendor evaluation was conducted and finalized. Represents the business event timestamp for the evaluation activity.',
    `evaluation_number` STRING COMMENT 'Business identifier for the vendor evaluation. Human-readable reference number used in procurement documentation and vendor communications.',
    `evaluation_period_end_date` DATE COMMENT 'End date of the period covered by this vendor evaluation. Defines the conclusion of the performance measurement window.',
    `evaluation_period_start_date` DATE COMMENT 'Start date of the period covered by this vendor evaluation. Defines the beginning of the performance measurement window.',
    `evaluation_status` STRING COMMENT 'Current lifecycle status of the vendor evaluation. Tracks the evaluation through its workflow from initial draft to final completion.. Valid values are `draft|submitted|under_review|approved|rejected|completed`',
    `evaluation_type` STRING COMMENT 'Classification of the evaluation based on its trigger and purpose. Periodic evaluations occur on a regular schedule, ad-hoc evaluations are triggered by specific events, contract renewal evaluations support sourcing decisions, incident-driven evaluations follow quality or delivery issues, and qualification/requalification evaluations determine vendor eligibility.. Valid values are `periodic|ad_hoc|contract_renewal|incident_driven|qualification|requalification`',
    `evaluator_name` STRING COMMENT 'Full name of the employee who conducted the vendor evaluation. Captured for audit trail and accountability purposes.',
    `hsse_compliance_score` DECIMAL(18,2) COMMENT 'Performance score for vendor adherence to health, safety, security, and environmental standards. Evaluates compliance with ISPS Code, SOLAS, MARPOL, ISO 45001 (Occupational Health and Safety), ISO 14001 (Environmental Management), and port-specific HSSE requirements during the evaluation period.',
    `hsse_compliance_weight` DECIMAL(18,2) COMMENT 'Weighting factor applied to the HSSE compliance score in the overall score calculation. Expressed as a percentage or decimal fraction.',
    `late_deliveries` STRING COMMENT 'Number of purchase orders delivered after the requested delivery date during the evaluation period. Used to calculate the on-time delivery score.',
    `modified_by` STRING COMMENT 'User ID or name of the system user who last modified the vendor evaluation record. Audit trail field for accountability.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the vendor evaluation record was last modified. Audit trail field for change tracking.',
    `next_evaluation_due_date` DATE COMMENT 'Scheduled date for the next vendor evaluation. May be accelerated for vendors on probation or extended for preferred vendors based on evaluation results.',
    `on_time_deliveries` STRING COMMENT 'Number of purchase orders delivered on or before the requested delivery date during the evaluation period. Used to calculate the on-time delivery score.',
    `on_time_delivery_score` DECIMAL(18,2) COMMENT 'Performance score for vendor adherence to delivery schedules. Measures the percentage of purchase orders delivered on or before the requested delivery date during the evaluation period.',
    `on_time_delivery_weight` DECIMAL(18,2) COMMENT 'Weighting factor applied to the on-time delivery score in the overall score calculation. Expressed as a percentage or decimal fraction.',
    `overall_rating` STRING COMMENT 'Qualitative rating band derived from the overall score. Provides a business-friendly classification of vendor performance for reporting and decision-making.. Valid values are `excellent|good|satisfactory|marginal|unsatisfactory`',
    `overall_score` DECIMAL(18,2) COMMENT 'Composite vendor performance score calculated from weighted sub-criteria scores. Typically expressed as a percentage or on a 0-100 scale. Used for vendor ranking and qualification decisions.',
    `price_competitiveness_score` DECIMAL(18,2) COMMENT 'Performance score for vendor pricing relative to market benchmarks and competing suppliers. Evaluates cost-effectiveness and value for money during the evaluation period.',
    `price_competitiveness_weight` DECIMAL(18,2) COMMENT 'Weighting factor applied to the price competitiveness score in the overall score calculation. Expressed as a percentage or decimal fraction.',
    `quality_acceptance_rate` DECIMAL(18,2) COMMENT 'Percentage of goods receipts accepted without quality issues during the evaluation period. Calculated as (total receipts - rejections) / total receipts * 100.',
    `quality_compliance_score` DECIMAL(18,2) COMMENT 'Performance score for vendor adherence to quality specifications and standards. Measures defect rates, rejection rates, and compliance with quality requirements during the evaluation period.',
    `quality_compliance_weight` DECIMAL(18,2) COMMENT 'Weighting factor applied to the quality compliance score in the overall score calculation. Expressed as a percentage or decimal fraction.',
    `quality_rejections` STRING COMMENT 'Number of goods receipts rejected due to quality defects during the evaluation period. Used to calculate the quality compliance score.',
    `recommended_vendor_tier` STRING COMMENT 'Recommended classification tier for the vendor based on this evaluation. May differ from current tier if performance warrants upgrade or downgrade.. Valid values are `preferred|approved|conditional|probation|blocked`',
    `responsiveness_score` DECIMAL(18,2) COMMENT 'Performance score for vendor communication, inquiry response time, and flexibility in addressing urgent requirements or changes during the evaluation period.',
    `responsiveness_weight` DECIMAL(18,2) COMMENT 'Weighting factor applied to the responsiveness score in the overall score calculation. Expressed as a percentage or decimal fraction.',
    `tier_change_reason` STRING COMMENT 'Business justification for recommending a change in vendor tier classification. Captures the rationale for upgrade or downgrade decisions.',
    `total_purchase_orders` STRING COMMENT 'Total number of purchase orders issued to the vendor during the evaluation period. Provides context for the evaluation sample size.',
    `total_purchase_value` DECIMAL(18,2) COMMENT 'Total monetary value of purchases from the vendor during the evaluation period. Expressed in the base currency of the port authority.',
    `created_by` STRING COMMENT 'User ID or name of the system user who created the vendor evaluation record. Audit trail field for accountability.',
    CONSTRAINT pk_vendor_evaluation PRIMARY KEY(`vendor_evaluation_id`)
) COMMENT 'Periodic performance evaluation of vendors across key criteria including on-time delivery, quality compliance, price competitiveness, responsiveness, and HSSE (Health, Safety, Security, Environment) compliance. Captures evaluation period, overall score, sub-scores by criterion, evaluator, evaluation date, and recommended vendor tier adjustment. Supports vendor qualification, preferred vendor lists, and sourcing decisions. Sourced from SAP MM Vendor Evaluation (ME61/LFM1).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` (
    `approved_vendor_list_id` BIGINT COMMENT 'Unique identifier for the approved vendor list entry. Primary key.',
    `commodity_code_id` BIGINT COMMENT 'add column commodity_code_id (BIGINT) with FK to masterdata.commodity_code.commodity_code_id - approved vendor lists are often commodity-specific beyond material group level',
    `material_group_id` BIGINT COMMENT 'Foreign key linking to procurement.material_group. Business justification: AVL entries are typically scoped to specific material groups or commodity categories. Adding material_group_id FK enables structured vendor qualification by category, supports source determination log',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor entity that has been approved for procurement activities.',
    `approval_authority` STRING COMMENT 'Name or title of the individual, committee, or department that granted the vendor approval.',
    `approval_date` DATE COMMENT 'Date on which the vendor was officially approved and added to the approved vendor list.',
    `approval_number` STRING COMMENT 'Unique business identifier for the vendor approval record, used for tracking and audit purposes.. Valid values are `^AVL-[0-9]{8}$`',
    `approval_status` STRING COMMENT 'Current lifecycle status of the vendor approval indicating whether the vendor is authorized to receive purchase orders.. Valid values are `approved|conditional|suspended|revoked|expired|under_review`',
    `approval_type` STRING COMMENT 'Classification of the approval indicating the scope and conditions under which the vendor is authorized to supply.. Valid values are `full|conditional|trial|temporary|emergency`',
    `approved_by` STRING COMMENT 'Name or identifier of the individual who authorized the vendor approval.',
    `approved_service_categories` STRING COMMENT 'Comma-separated list of service categories that the vendor is approved to provide (e.g., maintenance, engineering, consulting, logistics).',
    `audit_date` DATE COMMENT 'Date of the most recent on-site or documentation audit conducted to verify vendor capabilities and compliance.',
    `audit_outcome` STRING COMMENT 'Result of the most recent vendor audit indicating compliance with qualification requirements.. Valid values are `passed|passed_with_conditions|failed|not_applicable`',
    `certification_requirements` STRING COMMENT 'List of mandatory certifications or standards the vendor must maintain (e.g., ISO 9001, ISO 14001, ISPS compliance, OHSAS 18001).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the approved vendor list record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the maximum order value and financial limits.. Valid values are `^[A-Z]{3}$`',
    `financial_stability_check_date` DATE COMMENT 'Date of the most recent financial stability assessment or credit check performed on the vendor.',
    `geographic_scope` STRING COMMENT 'Geographic regions or port locations where the vendor is approved to supply materials or services.',
    `hsse_approval_date` DATE COMMENT 'Date on which the HSSE team granted approval for the vendor to operate within port facilities.',
    `hsse_approved` BOOLEAN COMMENT 'Indicates whether the vendor has been approved by the Health, Safety, Security, and Environment team for compliance with port safety and environmental standards.',
    `imo_compliant` BOOLEAN COMMENT 'Indicates whether the vendor complies with IMO regulations and standards for maritime operations.',
    `insurance_expiry_date` DATE COMMENT 'Expiration date of the vendors insurance coverage requiring renewal or re-verification.',
    `insurance_verified` BOOLEAN COMMENT 'Indicates whether the vendors insurance coverage (liability, workers compensation, professional indemnity) has been verified and meets port requirements.',
    `iso_certifications` STRING COMMENT 'Comma-separated list of ISO certifications held by the vendor (e.g., ISO 9001, ISO 14001, ISO 45001, ISO 28000).',
    `isps_compliant` BOOLEAN COMMENT 'Indicates whether the vendor meets ISPS Code security requirements for port facility operations.',
    `last_review_date` DATE COMMENT 'Date of the most recent review or evaluation of the vendor approval status.',
    `maximum_order_value` DECIMAL(18,2) COMMENT 'Maximum monetary value allowed for a single purchase order to this vendor under the current approval.',
    `modified_by` STRING COMMENT 'User identifier or name of the person who last modified the approved vendor list record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the approved vendor list record.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of the vendor approval and performance evaluation.',
    `performance_score` DECIMAL(18,2) COMMENT 'Quantitative performance score or rating assigned to the vendor based on delivery, quality, compliance, and service metrics (typically 0-100 scale).',
    `preferred_vendor` BOOLEAN COMMENT 'Indicates whether this vendor has preferred status for sourcing decisions based on performance, pricing, or strategic relationship.',
    `qualification_basis` STRING COMMENT 'The method or process by which the vendor was qualified and approved for the approved vendor list.. Valid values are `audit|certification|trial_order|reference_check|pre_qualification|tender_evaluation`',
    `reinstatement_date` DATE COMMENT 'Date on which a previously suspended vendor approval was reinstated after corrective actions.',
    `remarks` STRING COMMENT 'Additional notes, comments, or special instructions related to the vendor approval.',
    `review_frequency_months` STRING COMMENT 'Number of months between periodic reviews of the vendor approval status and performance.',
    `risk_rating` STRING COMMENT 'Overall risk assessment of the vendor based on financial stability, performance history, compliance, and operational factors.. Valid values are `low|medium|high|critical`',
    `supply_restrictions` STRING COMMENT 'Description of any limitations or restrictions on the vendors ability to supply (e.g., geographic restrictions, volume caps, specific terminals only).',
    `suspension_date` DATE COMMENT 'Date on which the vendor approval was suspended or revoked.',
    `suspension_reason` STRING COMMENT 'Explanation for why the vendor approval was suspended or revoked, if applicable.',
    `valid_from_date` DATE COMMENT 'Effective start date from which the vendor approval is active and the vendor can receive purchase orders.',
    `valid_to_date` DATE COMMENT 'Expiration date of the vendor approval after which the vendor must be re-evaluated or the approval renewed.',
    `created_by` STRING COMMENT 'User identifier or name of the person who created the approved vendor list record.',
    CONSTRAINT pk_approved_vendor_list PRIMARY KEY(`approved_vendor_list_id`)
) COMMENT 'Registry of vendors approved to supply specific materials or services to the port, capturing approval status, approved commodity categories, approval validity period, approval authority, qualification basis (audit, certification, trial order), and any supply restrictions. Supports sourcing compliance and ensures only qualified vendors receive purchase orders. Maintained by the procurement and HSSE teams.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` (
    `vendor_certification_id` BIGINT COMMENT 'Unique identifier for the vendor certification record. Primary key.',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor holding this certification. Links to the vendor master data.',
    `accreditation_body` STRING COMMENT 'Name of the accreditation body that accredits the issuing body, providing third-party validation of the certification authority. Examples include national accreditation bodies or international accreditation forums.',
    `audit_frequency_months` STRING COMMENT 'Frequency in months at which surveillance audits or compliance reviews are required by the certifying body to maintain the certification.',
    `certificate_document_url` STRING COMMENT 'Uniform Resource Locator (URL) or file path to the digital copy of the certification document stored in the document management system.',
    `certification_level` STRING COMMENT 'Level, grade, or tier of the certification if the certification scheme includes multiple levels of achievement or compliance. Examples include basic, advanced, gold, platinum, or numerical levels.',
    `certification_name` STRING COMMENT 'Full descriptive name of the certification or accreditation as stated on the certificate.',
    `certification_number` STRING COMMENT 'Unique certificate number or registration number issued by the certifying body. This is the externally-known identifier for the certification.',
    `certification_scope` STRING COMMENT 'Detailed description of the scope of the certification, including the specific products, services, processes, or activities covered by the certification. Defines the boundaries and applicability of the certification.',
    `certification_status` STRING COMMENT 'Current lifecycle status of the certification. Indicates whether the certification is active and valid, expired, suspended by the issuing body, pending renewal, revoked, or under review.. Valid values are `Active|Expired|Suspended|Pending Renewal|Revoked|Under Review`',
    `certification_type` STRING COMMENT 'Type or category of certification held by the vendor. Includes quality management (ISO 9001), environmental management (ISO 14001), occupational health and safety (ISO 45001), supply chain security (ISO 28000), International Ship and Port Facility Security (ISPS) clearances, trade licenses, and other industry-specific certifications. [ENUM-REF-CANDIDATE: ISO 9001|ISO 14001|ISO 45001|ISO 28000|ISPS|Trade License|Industry Specific|Other — 8 candidates stripped; promote to reference product]',
    `compliance_standard` STRING COMMENT 'Full name and version of the standard, regulation, or framework against which the vendor is certified. Examples include ISO 9001:2015, ISO 14001:2015, ISO 45001:2018, ISPS Code Amendment, or specific trade regulations.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this vendor certification record was first created in the system. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `effective_from_date` DATE COMMENT 'Date from which the certification becomes valid and enforceable. May differ from issue date in cases of delayed effectiveness. Format: yyyy-MM-dd.',
    `expiry_date` DATE COMMENT 'Date when the certification expires and is no longer valid unless renewed. Format: yyyy-MM-dd.',
    `is_mandatory` BOOLEAN COMMENT 'Boolean flag indicating whether this certification is mandatory for the vendor to conduct business with the port or is required by regulatory authorities. True if mandatory, False if voluntary or preferred.',
    `is_verified` BOOLEAN COMMENT 'Boolean flag indicating whether the certification has been independently verified by the ports procurement or compliance team. True if verified, False if pending verification.',
    `issue_date` DATE COMMENT 'Date when the certification was originally issued or granted by the certifying body. Format: yyyy-MM-dd.',
    `issuing_body` STRING COMMENT 'Name of the organization, authority, or accreditation body that issued the certification. Examples include certification bodies, government agencies, industry associations, or regulatory authorities.',
    `issuing_body_country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code representing the country where the issuing body is registered or headquartered.. Valid values are `^[A-Z]{3}$`',
    `last_audit_date` DATE COMMENT 'Date of the most recent surveillance audit, recertification audit, or compliance review conducted by the certifying body. Format: yyyy-MM-dd.',
    `modified_by` STRING COMMENT 'User ID or name of the person who last modified this vendor certification record.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this vendor certification record was last modified or updated. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `next_audit_date` DATE COMMENT 'Scheduled date for the next surveillance audit or recertification audit required to maintain the certification. Format: yyyy-MM-dd.',
    `notification_sent_date` DATE COMMENT 'Date when a notification was sent to the vendor regarding certification expiry, renewal requirement, or compliance issue. Format: yyyy-MM-dd.',
    `reinstatement_date` DATE COMMENT 'Date when a previously suspended or revoked certification was reinstated by the issuing body. Format: yyyy-MM-dd.',
    `remarks` STRING COMMENT 'Additional notes, comments, or observations related to the certification, including special conditions, exceptions, or clarifications provided by the vendor or procurement team.',
    `renewal_due_date` DATE COMMENT 'Date by which the certification renewal process must be initiated or completed to maintain continuous certification status. Typically precedes the expiry date. Format: yyyy-MM-dd.',
    `renewal_initiated_date` DATE COMMENT 'Date when the certification renewal process was initiated by the vendor or the ports procurement team. Format: yyyy-MM-dd.',
    `renewal_status` STRING COMMENT 'Current status of the certification renewal process. Indicates whether renewal is not required, pending initiation, in progress, completed, or overdue.. Valid values are `Not Required|Pending|In Progress|Completed|Overdue`',
    `risk_rating` STRING COMMENT 'Risk rating assigned based on the certification status and compliance posture. High or Critical ratings indicate expired, suspended, or missing mandatory certifications that pose procurement or operational risk.. Valid values are `Low|Medium|High|Critical`',
    `suspension_date` DATE COMMENT 'Date when the certification was suspended or revoked by the issuing body. Format: yyyy-MM-dd.',
    `suspension_reason` STRING COMMENT 'Detailed reason or explanation for the suspension or revocation of the certification by the issuing body. Populated only when certification status is Suspended or Revoked.',
    `vendor_qualification_impact` STRING COMMENT 'Impact of this certification on the vendors overall qualification status for procurement activities. Indicates whether the vendor is fully qualified, conditionally qualified, disqualified, or under review based on certification status.. Valid values are `Qualified|Conditionally Qualified|Disqualified|Under Review`',
    `verification_date` DATE COMMENT 'Date when the certification was verified by the ports procurement or compliance team. Format: yyyy-MM-dd.',
    `verified_by` STRING COMMENT 'Name or identifier of the procurement or compliance officer who verified the authenticity and validity of the certification.',
    `created_by` STRING COMMENT 'User ID or name of the person who created this vendor certification record in the system.',
    CONSTRAINT pk_vendor_certification PRIMARY KEY(`vendor_certification_id`)
) COMMENT 'Compliance certifications and accreditations held by vendors, including ISO 9001 (Quality), ISO 14001 (Environmental), ISO 45001 (OHS), ISPS security clearances, trade licences, and industry-specific certifications. Captures certificate type, issuing body, certificate number, issue date, expiry date, and renewal status. Supports vendor qualification and regulatory compliance verification.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` (
    `tender_id` BIGINT COMMENT 'Unique identifier for the tender record. Primary key.',
    `agreement_id` BIGINT COMMENT 'Reference to the resulting contract record created after tender award.',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor who was awarded the tender contract.',
    `material_group_id` BIGINT COMMENT 'Reference to the material group classification in SAP MM that categorizes the procurement scope.',
    `employee_id` BIGINT COMMENT 'User ID of the person who created this tender record.',
    `purchase_requisition_id` BIGINT COMMENT 'add column purchase_requisition_id (BIGINT) with FK to procurement.purchase_requisition.purchase_requisition_id - tenders originate from purchase requisitions for formal procurement',
    `quaternary_tender_modified_by_user_employee_id` BIGINT COMMENT 'User ID of the person who last modified this tender record.',
    `tertiary_tender_manager_user_employee_id` BIGINT COMMENT 'User ID of the procurement professional responsible for managing this tender process.',
    `approval_date` DATE COMMENT 'Date when the tender was formally approved by the authorized approver.',
    `approval_status` STRING COMMENT 'Current approval status of the tender: pending (awaiting approval), approved (authorized to proceed), rejected (not authorized), or conditional (approved with conditions).. Valid values are `pending|approved|rejected|conditional`',
    `approval_workflow_code` STRING COMMENT 'Reference to the approval workflow or routing process required for this tender based on value thresholds and organizational policies.',
    `award_date` DATE COMMENT 'Date when the tender was officially awarded to the winning vendor.',
    `awarded_value` DECIMAL(18,2) COMMENT 'Final contracted value awarded to the winning vendor, in the specified currency.',
    `bid_bond_amount` DECIMAL(18,2) COMMENT 'Required bid bond amount in the specified currency, if applicable.',
    `bid_bond_required` BOOLEAN COMMENT 'Indicates whether bidders must submit a bid bond or bid security as part of their submission.',
    `budget_allocation_code` STRING COMMENT 'Budget line or allocation code against which this tender is authorized and funded.',
    `cancellation_reason` STRING COMMENT 'Explanation for why the tender was cancelled or withdrawn, if applicable.',
    `closing_date` DATE COMMENT 'Deadline date by which all bids must be submitted. No bids are accepted after this date.',
    `closing_time` TIMESTAMP COMMENT 'Precise timestamp (date and time) when the tender submission window closes.',
    `commodity_scope` STRING COMMENT 'High-level categorization of the commodity or service category being procured (e.g., marine equipment, IT services, construction works, spare parts).',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity conducting the tender.. Valid values are `^[A-Z0-9]{4}$`',
    `contract_duration_months` STRING COMMENT 'Expected duration of the resulting contract in months.',
    `cost_center` STRING COMMENT 'Cost center code to which the tender expenditure will be charged for financial accounting purposes.. Valid values are `^[A-Z0-9]{10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this tender record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the tender value (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `delivery_location` STRING COMMENT 'Specified delivery location or port terminal where goods or services are to be delivered.',
    `tender_description` STRING COMMENT 'Detailed description of the goods, services, or works being procured through this tender, including scope, specifications, and requirements.',
    `estimated_value` DECIMAL(18,2) COMMENT 'Estimated total value of the tender in the specified currency, used for budget planning and approval thresholds.',
    `evaluation_criteria` STRING COMMENT 'Detailed description of the criteria and weightings used to evaluate bids (e.g., price 60%, technical capability 30%, delivery time 10%).',
    `evaluation_method` STRING COMMENT 'Method used to evaluate and compare bids: lowest price, best value (price and quality), technical merit, two-envelope system (technical then commercial), or quality-cost based scoring.. Valid values are `lowest_price|best_value|technical_merit|two_envelope|quality_cost`',
    `incoterms` STRING COMMENT 'Incoterms code defining the delivery terms and transfer of risk for goods procurement (e.g., FOB, CIF, DDP). [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF — 11 candidates stripped; promote to reference product]',
    `issue_date` DATE COMMENT 'Date when the tender was officially published and made available to potential bidders.',
    `manager_name` STRING COMMENT 'Full name of the tender manager responsible for this procurement.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this tender record was last modified.',
    `number_of_bids_evaluated` STRING COMMENT 'Count of bids that met eligibility criteria and were formally evaluated.',
    `number_of_bids_received` STRING COMMENT 'Total count of valid bids received by the closing date.',
    `outcome` STRING COMMENT 'Final outcome of the tender process: awarded (contract given), no award (no suitable bids), cancelled (process terminated), withdrawn (by issuer), or under review (pending decision).. Valid values are `awarded|no_award|cancelled|withdrawn|under_review`',
    `payment_terms` STRING COMMENT 'Payment terms specified in the tender (e.g., net 30 days, milestone-based, advance payment percentage).',
    `performance_bond_required` BOOLEAN COMMENT 'Indicates whether the awarded vendor must provide a performance bond or guarantee upon contract execution.',
    `plant_code` STRING COMMENT 'SAP plant code representing the port terminal or facility where the procured goods or services will be delivered or used.. Valid values are `^[A-Z0-9]{4}$`',
    `pre_qualification_required` BOOLEAN COMMENT 'Indicates whether vendors must be pre-qualified or pre-registered to participate in this tender.',
    `publication_channel` STRING COMMENT 'Channels through which the tender was published (e.g., port authority website, government procurement portal, industry publications).',
    `purchasing_group` STRING COMMENT 'SAP purchasing group code representing the procurement team or buyer responsible for managing this tender.. Valid values are `^[A-Z0-9]{3}$`',
    `purchasing_organization` STRING COMMENT 'SAP purchasing organization code responsible for this tender (e.g., port authority division or business unit).. Valid values are `^[A-Z0-9]{4}$`',
    `remarks` STRING COMMENT 'Additional notes, comments, or special instructions related to the tender process.',
    `tender_number` STRING COMMENT 'Externally-known unique business identifier for the tender, typically following organizational numbering convention.. Valid values are `^TND-[0-9]{8}$`',
    `tender_status` STRING COMMENT 'Current lifecycle status of the tender process: draft (being prepared), published (announced), open (accepting bids), closed (submission deadline passed), evaluation (under review), awarded (vendor selected), cancelled, or withdrawn. [ENUM-REF-CANDIDATE: draft|published|open|closed|evaluation|awarded|cancelled|withdrawn — 8 candidates stripped; promote to reference product]',
    `tender_type` STRING COMMENT 'Classification of the tender process: open tender (public), restricted tender (pre-qualified vendors), negotiated tender, expression of interest (EOI), framework agreement, or single source procurement.. Valid values are `open|restricted|negotiated|eoi|framework|single_source`',
    `title` STRING COMMENT 'Descriptive title or name of the tender, summarizing the procurement scope.',
    CONSTRAINT pk_tender PRIMARY KEY(`tender_id`)
) COMMENT 'Formal competitive tender process for high-value or strategic procurement, including open tenders, restricted tenders, and expression of interest (EOI) processes. Captures tender number, tender type, commodity scope, estimated value, issue date, closing date, evaluation method, number of bids received, awarded vendor, awarded value, and tender outcome. Supports transparent and compliant procurement governance for port authority requirements.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` (
    `purchasing_info_id` BIGINT COMMENT 'Unique identifier for the purchasing information record. Primary key for the purchasing_info product.',
    `material_master_id` BIGINT COMMENT 'Reference to the material for which this purchasing information record is maintained. Links to the material master data.',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: Purchasing info records often derive pricing and terms from framework contracts. Linking purchasing_info to supplier_contract enables contract-based pricing inheritance, validity period synchronizatio',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor for whom this purchasing information record is maintained. Links to the vendor master data.',
    `acknowledgement_required` BOOLEAN COMMENT 'Flag indicating whether the vendor must formally acknowledge receipt and acceptance of purchase orders for this material.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this purchasing information record was first created in the source system.',
    `currency_code` STRING COMMENT 'The three-letter ISO 4217 currency code in which the net price is denominated.. Valid values are `^[A-Z]{3}$`',
    `deletion_indicator` BOOLEAN COMMENT 'Flag indicating that this purchasing information record is marked for deletion and should not be used for new purchase orders.',
    `goods_receipt_processing_time_days` STRING COMMENT 'The number of days required to process goods receipt, including unloading, inspection, and put-away. Added to planned delivery time for total lead time calculation.',
    `incoterms` STRING COMMENT 'The agreed Incoterms rule that defines the responsibilities of buyer and seller for delivery, insurance, and risk transfer in international trade. [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF — 11 candidates stripped; promote to reference product]',
    `incoterms_location` STRING COMMENT 'The specific location or port associated with the Incoterms rule (e.g., FOB Singapore, CIF Rotterdam).',
    `info_record_category` STRING COMMENT 'The category or type of purchasing information record indicating the procurement arrangement type.. Valid values are `standard|subcontracting|consignment|pipeline`',
    `info_record_number` STRING COMMENT 'The unique business identifier for the purchasing information record in the source system. Used for external reference and integration.',
    `info_record_status` STRING COMMENT 'The current lifecycle status of the purchasing information record indicating whether it can be used for procurement activities.. Valid values are `active|inactive|blocked|pending_approval`',
    `last_purchase_order_date` DATE COMMENT 'The date when the last purchase order was created using this purchasing information record.',
    `last_purchase_order_number` STRING COMMENT 'The most recent purchase order number created using this purchasing information record. Provides traceability to actual procurement transactions.',
    `last_purchase_price` DECIMAL(18,2) COMMENT 'The actual price paid in the most recent purchase order for this vendor-material combination. May differ from the info record net price due to negotiated discounts or surcharges.',
    `manufacturer_name` STRING COMMENT 'The name of the original manufacturer of the material, if different from the vendor. Relevant for quality assurance and warranty tracking.',
    `manufacturer_part_number` STRING COMMENT 'The original manufacturers part number for the material, if different from the vendor material number. Important for spare parts and technical specifications.',
    `maximum_order_quantity` DECIMAL(18,2) COMMENT 'The maximum quantity that can be ordered in a single purchase order from this vendor for this material.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'The minimum quantity that must be ordered from this vendor for this material. Orders below this quantity may not be accepted or may incur additional charges.',
    `modified_timestamp` TIMESTAMP COMMENT 'The date and time when this purchasing information record was last modified in the source system.',
    `net_price` DECIMAL(18,2) COMMENT 'The agreed net price per unit for the material from this vendor. This is the base price before any additional charges or discounts.',
    `order_quantity_multiple` DECIMAL(18,2) COMMENT 'The quantity increment in which the material must be ordered. For example, if set to 10, orders must be in multiples of 10 units.',
    `over_delivery_tolerance_percent` DECIMAL(18,2) COMMENT 'The acceptable percentage by which the vendor may over-deliver beyond the ordered quantity without requiring approval.',
    `payment_terms` STRING COMMENT 'The agreed payment terms for purchases from this vendor for this material (e.g., Net 30, Net 60, 2/10 Net 30).',
    `planned_delivery_time_days` STRING COMMENT 'The number of calendar days from purchase order placement to expected delivery at the plant. Used for material requirements planning and order scheduling.',
    `plant_code` STRING COMMENT 'The plant or facility for which this purchasing information record is valid. Represents the physical location where the material will be delivered.',
    `price_change_indicator` BOOLEAN COMMENT 'Flag indicating whether the price has changed since the last update. Used to trigger price variance analysis and approval workflows.',
    `price_date` DATE COMMENT 'The date on which the current net price was established or last updated. Used for price history tracking and analysis.',
    `price_unit` STRING COMMENT 'The quantity of material to which the net price applies. For example, if price_unit is 100, the net_price is for 100 units of the material.',
    `purchasing_group` STRING COMMENT 'The purchasing group responsible for managing procurement activities for this vendor-material combination. Represents the buyer or procurement team.',
    `purchasing_organization` STRING COMMENT 'The purchasing organization responsible for procuring this material from this vendor. Represents the organizational unit that negotiates conditions of purchase with vendors.',
    `quality_inspection_required` BOOLEAN COMMENT 'Flag indicating whether goods received from this vendor for this material must undergo quality inspection before acceptance.',
    `reminder_days` STRING COMMENT 'The number of days before the expected delivery date when a reminder should be sent to the vendor to confirm shipment status.',
    `source_system_key` STRING COMMENT 'The unique identifier or key of this purchasing information record in the source operational system. Used for data lineage and reconciliation.',
    `standard_order_quantity` DECIMAL(18,2) COMMENT 'The standard or recommended order quantity for this material from this vendor. Used as a default in purchase requisition and order creation.',
    `tax_code` STRING COMMENT 'The tax code that determines the tax treatment for purchases of this material from this vendor.',
    `under_delivery_tolerance_percent` DECIMAL(18,2) COMMENT 'The acceptable percentage by which the vendor may under-deliver below the ordered quantity without requiring approval or penalty.',
    `unit_of_measure` STRING COMMENT 'The unit of measure in which the material is purchased from this vendor (e.g., EA for each, KG for kilogram, M for meter).',
    `unlimited_over_delivery_allowed` BOOLEAN COMMENT 'Flag indicating whether the vendor is allowed to deliver any quantity above the ordered amount without restriction.',
    `valid_from_date` DATE COMMENT 'The date from which this purchasing information record becomes effective and can be used for purchase order creation.',
    `valid_to_date` DATE COMMENT 'The date until which this purchasing information record remains valid. After this date, the record cannot be used for new purchase orders unless extended.',
    `vendor_material_number` STRING COMMENT 'The material number or part number used by the vendor to identify this material in their catalog or system. Facilitates communication and order processing.',
    CONSTRAINT pk_purchasing_info PRIMARY KEY(`purchasing_info_id`)
) COMMENT 'Vendor-material purchasing information record capturing the agreed or historical pricing and conditions for a specific vendor-material combination. Includes info record number, vendor, material, purchasing organisation, plant, net price, price unit, validity period, planned delivery time, minimum order quantity, and last purchase order reference. Supports automatic price defaulting in purchase orders. Sourced from SAP MM Purchasing Info Record (EINA/EINE).';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` (
    `vendor_service_rate_card_id` BIGINT COMMENT 'Unique identifier for this vendor-service rate card record. Primary key. System-generated surrogate.',
    `service_code_id` BIGINT COMMENT 'Foreign key linking to the port service code being provided',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to the vendor providing this service',
    `contract_reference` STRING COMMENT 'Reference to the master service agreement or purchase contract under which this rate card is governed. Links to contract management system.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this vendor-service rate card record was first created in the system. Format: yyyy-MM-ddTHH:mm:ss.SSSZ',
    `effective_from_date` DATE COMMENT 'Start date from which this vendor-service rate is valid and can be used for procurement and billing. Part of rate card revision cycle.',
    `effective_to_date` DATE COMMENT 'End date until which this vendor-service rate remains valid. Null indicates open-ended validity subject to contract terms.',
    `last_modified_by` STRING COMMENT 'User ID or name of the person who last modified this rate card record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this rate card record was last updated. Format: yyyy-MM-ddTHH:mm:ss.SSSZ',
    `last_rate_review_date` DATE COMMENT 'Date when this vendor-service rate was last reviewed or renegotiated by procurement. Used for tracking rate review cycles and contract renewal planning.',
    `minimum_charge` DECIMAL(18,2) COMMENT 'Vendor-specific minimum charge for this service regardless of quantity or usage. Overrides any minimum charge in service_code master for this vendor.',
    `negotiated_rate` DECIMAL(18,2) COMMENT 'Vendor-specific negotiated rate for this service. May differ from the standard published rate in service_code master. Used by procurement for cost comparison and by billing for vendor invoice reconciliation.',
    `next_rate_review_date` DATE COMMENT 'Scheduled date for next rate review or renegotiation. Triggers procurement workflow for rate benchmarking and vendor negotiation.',
    `notes` STRING COMMENT 'Free-text notes documenting special conditions, exclusions, surcharge applicability, or other vendor-service specific terms not captured in structured fields.',
    `payment_terms` STRING COMMENT 'Service-specific payment terms negotiated for this vendor-service combination. May override vendors standard payment terms for high-value or specialized services.',
    `preferred_vendor_flag` BOOLEAN COMMENT 'Indicates whether this vendor is designated as preferred supplier for this service based on rate competitiveness, quality, or strategic relationship. Used by procurement for sourcing prioritization.',
    `rate_card_status` STRING COMMENT 'Current lifecycle status of this vendor-service rate card. ACTIVE cards are available for procurement and billing. SUSPENDED cards are temporarily inactive pending contract renegotiation.',
    `rate_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the negotiated rate. May differ from vendors default currency or service standard currency.',
    `sla_response_time_hours` STRING COMMENT 'Service Level Agreement response time in hours committed by this vendor for this specific service. Used for vendor performance monitoring and contract compliance tracking.',
    `volume_discount_tier` STRING COMMENT 'Volume-based discount tier applicable to this vendor-service combination (e.g., Tier 1: 0-100 units, Tier 2: 101-500 units). References volume discount schedule in procurement contract.',
    `created_by` STRING COMMENT 'User ID or name of the procurement officer who created this rate card record.',
    CONSTRAINT pk_vendor_service_rate_card PRIMARY KEY(`vendor_service_rate_card_id`)
) COMMENT 'This association product represents the commercial agreement between a vendor and a port service code. It captures negotiated pricing, payment terms, service level agreements, and validity periods for procurement and billing operations. Each record links one vendor to one service code with rate-specific attributes that exist only in the context of this vendor-service relationship. SSOT for vendor-specific service pricing used by procurement for RFQ evaluation and by commercial/billing for rate application.. Existence Justification: In maritime port operations, vendors provide multiple types of services (stevedoring, lashing, fumigation, customs brokerage, pilotage, towage, etc.) and each service type can be provided by multiple qualified vendors. Ports maintain vendor-service rate cards with negotiated pricing, payment terms, SLAs, and validity periods as part of procurement contract management and billing operations. This is an operational business entity actively managed by procurement during vendor qualification, rate negotiation, and contract lifecycle management.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` (
    `vendor_commodity_approval_id` BIGINT COMMENT 'Unique identifier for the vendor-commodity approval record. Primary key. System-generated surrogate.',
    `commodity_code_id` BIGINT COMMENT 'Foreign key linking to the commodity code the vendor is approved to supply',
    `employee_id` BIGINT COMMENT 'Foreign key to the user or procurement officer who approved this vendor-commodity pairing. Used for audit trail and accountability.',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to the approved vendor',
    `approval_status` STRING COMMENT 'Current status of the vendors approval to supply this commodity code. APPROVED indicates active authorization, PENDING indicates under review, SUSPENDED indicates temporary hold, REVOKED indicates permanent removal, EXPIRED indicates certification lapsed.',
    `approved_date` DATE COMMENT 'Date when the vendor was approved to supply this commodity code. Represents the effective start date of the approval.',
    `certification_expiry_date` DATE COMMENT 'Date when the vendors certification for this commodity expires. Used to trigger recertification workflows and prevent sourcing from expired approvals.',
    `certification_number` STRING COMMENT 'Unique identifier of the certification or qualification document that authorizes this vendor to supply this commodity. May reference ISO certifications, trade licenses, or commodity-specific qualifications.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this vendor-commodity approval record was created in the system.',
    `last_supply_date` DATE COMMENT 'Most recent date when this vendor successfully supplied this commodity code to the port. Used to track active vs dormant vendor-commodity relationships.',
    `notes` STRING COMMENT 'Free-text notes regarding special conditions, restrictions, or context for this vendor-commodity approval. May include volume limits, geographic restrictions, or special handling requirements.',
    `preferred_vendor_flag` BOOLEAN COMMENT 'Indicates whether this vendor is designated as a preferred or strategic supplier for this commodity code. Preferred vendors receive priority in sourcing decisions and may have negotiated pricing or terms.',
    `quality_rating` DECIMAL(18,2) COMMENT 'Vendor performance quality rating specific to this commodity code, typically on a scale of 0.00 to 5.00. Based on historical supply quality, defect rates, compliance, and delivery performance for this commodity type.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this vendor-commodity approval record was last modified.',
    CONSTRAINT pk_vendor_commodity_approval PRIMARY KEY(`vendor_commodity_approval_id`)
) COMMENT 'This association product represents the approval relationship between vendors and commodity codes they are authorized to supply to the port. It captures vendor qualification, certification, and performance tracking for specific commodity types. Each record links one vendor to one commodity code with approval status, certification details, quality ratings, and supply history that exist only in the context of this vendor-commodity pairing.. Existence Justification: In maritime port operations, vendors are approved to supply specific commodity codes based on certifications, quality standards, and regulatory compliance requirements. A single vendor (e.g., a chemical supplier) may be approved for multiple HS commodity codes (various chemical types), and each commodity code can be sourced from multiple qualified vendors to ensure supply chain resilience and competitive pricing. The ports procurement team actively manages these vendor-commodity approvals as a strategic sourcing function, tracking certifications, quality ratings, and preferred vendor designations for each pairing.';

CREATE OR REPLACE TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` (
    `procurement_plan_id` BIGINT COMMENT 'Unique identifier for the procurement plan record. Primary key.',
    `material_group_id` BIGINT COMMENT 'Reference to the primary material group or commodity category covered by this procurement plan.',
    `approval_date` DATE COMMENT 'Date on which this procurement plan received formal approval to proceed.',
    `approval_threshold_tier` STRING COMMENT 'Approval authority tier required for this procurement plan based on total value thresholds defined in governance policy.. Valid values are `tier_1|tier_2|tier_3|tier_4|board_level`',
    `approval_workflow_code` STRING COMMENT 'Identifier of the approval workflow process assigned to this procurement plan based on value and risk classification.',
    `approved_by` STRING COMMENT 'Name or user ID of the authority who approved this procurement plan for execution.',
    `budget_code` STRING COMMENT 'Financial budget code or cost center against which this procurement plan is allocated and tracked.',
    `budget_commitment_amount` DECIMAL(18,2) COMMENT 'Amount of budget formally committed or reserved for execution of this procurement plan.',
    `capex_allocation_amount` DECIMAL(18,2) COMMENT 'Portion of total planned spend allocated to capital expenditure projects (infrastructure, equipment, long-term assets).',
    `competitive_tender_required_flag` BOOLEAN COMMENT 'Indicates whether competitive tendering process is mandated for procurements under this plan.',
    `compliance_framework` STRING COMMENT 'Regulatory or industry compliance framework(s) applicable to procurement activities under this plan (e.g., IMO, ISPS, WCO, local procurement regulations).',
    `contract_management_required_flag` BOOLEAN COMMENT 'Indicates whether formal contract management and administration processes are required for procurements executed under this plan.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this procurement plan record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for all monetary amounts in this procurement plan.. Valid values are `^[A-Z]{3}$`',
    `department_code` STRING COMMENT 'Port department or business unit code for which this procurement plan is prepared.',
    `fiscal_year` STRING COMMENT 'Fiscal year for which this procurement plan applies (e.g., 2024).',
    `hazmat_procurement_flag` BOOLEAN COMMENT 'Indicates whether this procurement plan includes hazardous materials requiring special handling, storage, and compliance with IMDG and MARPOL regulations.',
    `justification_notes` STRING COMMENT 'Business justification and rationale for the procurement plan, including alignment to strategic objectives, operational needs, and budget priorities.',
    `local_content_requirement_percentage` DECIMAL(18,2) COMMENT 'Minimum percentage of local content or local supplier participation required under this procurement plan, if applicable.',
    `modified_timestamp` TIMESTAMP COMMENT 'Date and time when this procurement plan record was last modified or updated.',
    `opex_allocation_amount` DECIMAL(18,2) COMMENT 'Portion of total planned spend allocated to operational expenditure (maintenance, consumables, services).',
    `period_end_date` DATE COMMENT 'End date of the period covered by this procurement plan.',
    `period_start_date` DATE COMMENT 'Start date of the period covered by this procurement plan.',
    `plan_description` STRING COMMENT 'Detailed narrative description of the procurement plans scope, objectives, and strategic alignment with port operational and capital investment priorities.',
    `plan_name` STRING COMMENT 'Descriptive name of the procurement plan, typically indicating fiscal period and scope (e.g., FY2024 Port Infrastructure Procurement Plan).',
    `plan_number` STRING COMMENT 'Business identifier for the procurement plan, typically following format PP-YYYY-NNNNNN where YYYY is fiscal year and NNNNNN is sequence number.. Valid values are `^PP-[0-9]{4}-[0-9]{6}$`',
    `plan_status` STRING COMMENT 'Current lifecycle status of the procurement plan in the approval and execution workflow.. Valid values are `draft|submitted|approved|active|closed|cancelled`',
    `plan_type` STRING COMMENT 'Classification of the procurement plan by planning horizon and purpose.. Valid values are `annual|quarterly|project_specific|emergency|strategic`',
    `prepared_by` STRING COMMENT 'Name or user ID of the procurement professional who prepared this procurement plan.',
    `purchasing_group` STRING COMMENT 'SAP purchasing group code assigned to manage procurement activities under this plan.',
    `purchasing_organization` STRING COMMENT 'SAP purchasing organization code responsible for executing this procurement plan.',
    `quality_inspection_required_flag` BOOLEAN COMMENT 'Indicates whether quality inspection and acceptance testing are mandatory for goods and services procured under this plan.',
    `risk_classification` STRING COMMENT 'Overall risk level assigned to this procurement plan based on value, complexity, supply market conditions, and strategic importance.. Valid values are `low|medium|high|critical`',
    `source_system_key` STRING COMMENT 'Unique identifier or primary key of this procurement plan record in the source system.',
    `sourcing_strategy` STRING COMMENT 'Primary sourcing approach defined for procurement activities under this plan.. Valid values are `open_market|preferred_vendor|competitive_tender|framework_agreement|single_source|consortium`',
    `strategic_sourcing_indicator` BOOLEAN COMMENT 'Indicates whether this procurement plan is part of a strategic sourcing initiative requiring long-term supplier relationship management.',
    `supplier_consolidation_target_count` STRING COMMENT 'Target number of preferred suppliers to be engaged under this procurement plan as part of supplier base rationalization strategy.',
    `sustainability_criteria_required_flag` BOOLEAN COMMENT 'Indicates whether environmental and sustainability criteria must be evaluated in vendor selection and procurement decisions under this plan.',
    `tender_schedule_end_date` DATE COMMENT 'Planned completion date for tender evaluation and award if competitive tendering is required.',
    `tender_schedule_start_date` DATE COMMENT 'Planned start date for tender activities if competitive tendering is required.',
    `total_planned_spend_amount` DECIMAL(18,2) COMMENT 'Total budgeted procurement spend amount for the plan period across all categories and line items.',
    CONSTRAINT pk_procurement_plan PRIMARY KEY(`procurement_plan_id`)
) COMMENT 'Annual or periodic procurement plan defining anticipated purchasing requirements aligned to port operational and capital budgets. Captures plan period, total planned spend by material group and department, sourcing strategy per category (open market, preferred vendor, competitive tender), planned tender schedule, approval workflow requirements by value threshold, and alignment to CAPEX/OPEX budgets. Supports procurement pipeline management, budget commitment planning, and governance compliance.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ADD CONSTRAINT `fk_procurement_vendor_bank_account_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ADD CONSTRAINT `fk_procurement_material_group_parent_material_group_id` FOREIGN KEY (`parent_material_group_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_group`(`material_group_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ADD CONSTRAINT `fk_procurement_purchase_requisition_item_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ADD CONSTRAINT `fk_procurement_purchase_requisition_item_purchase_requisition_id` FOREIGN KEY (`purchase_requisition_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition`(`purchase_requisition_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ADD CONSTRAINT `fk_procurement_rfq_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ADD CONSTRAINT `fk_procurement_rfq_material_group_id` FOREIGN KEY (`material_group_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_group`(`material_group_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ADD CONSTRAINT `fk_procurement_rfq_purchase_requisition_id` FOREIGN KEY (`purchase_requisition_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition`(`purchase_requisition_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ADD CONSTRAINT `fk_procurement_vendor_quotation_rfq_id` FOREIGN KEY (`rfq_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`rfq`(`rfq_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ADD CONSTRAINT `fk_procurement_vendor_quotation_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ADD CONSTRAINT `fk_procurement_purchase_order_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ADD CONSTRAINT `fk_procurement_purchase_order_item_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ADD CONSTRAINT `fk_procurement_purchase_order_item_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ADD CONSTRAINT `fk_procurement_purchase_order_item_supplier_contract_item_id` FOREIGN KEY (`supplier_contract_item_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item`(`supplier_contract_item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_purchase_order_item_id` FOREIGN KEY (`purchase_order_item_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item`(`purchase_order_item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ADD CONSTRAINT `fk_procurement_service_entry_sheet_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ADD CONSTRAINT `fk_procurement_service_entry_sheet_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ADD CONSTRAINT `fk_procurement_service_entry_sheet_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ADD CONSTRAINT `fk_procurement_vendor_invoice_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ADD CONSTRAINT `fk_procurement_vendor_invoice_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ADD CONSTRAINT `fk_procurement_vendor_invoice_purchase_order_item_id` FOREIGN KEY (`purchase_order_item_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item`(`purchase_order_item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ADD CONSTRAINT `fk_procurement_vendor_invoice_service_entry_sheet_id` FOREIGN KEY (`service_entry_sheet_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet`(`service_entry_sheet_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ADD CONSTRAINT `fk_procurement_vendor_invoice_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ADD CONSTRAINT `fk_procurement_supplier_contract_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ADD CONSTRAINT `fk_procurement_supplier_contract_item_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ADD CONSTRAINT `fk_procurement_supplier_contract_item_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ADD CONSTRAINT `fk_procurement_vendor_evaluation_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ADD CONSTRAINT `fk_procurement_approved_vendor_list_material_group_id` FOREIGN KEY (`material_group_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_group`(`material_group_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ADD CONSTRAINT `fk_procurement_approved_vendor_list_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ADD CONSTRAINT `fk_procurement_vendor_certification_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ADD CONSTRAINT `fk_procurement_tender_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ADD CONSTRAINT `fk_procurement_tender_material_group_id` FOREIGN KEY (`material_group_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_group`(`material_group_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ADD CONSTRAINT `fk_procurement_tender_purchase_requisition_id` FOREIGN KEY (`purchase_requisition_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition`(`purchase_requisition_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ADD CONSTRAINT `fk_procurement_purchasing_info_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ADD CONSTRAINT `fk_procurement_purchasing_info_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ADD CONSTRAINT `fk_procurement_purchasing_info_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ADD CONSTRAINT `fk_procurement_vendor_service_rate_card_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ADD CONSTRAINT `fk_procurement_vendor_commodity_approval_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ADD CONSTRAINT `fk_procurement_procurement_plan_material_group_id` FOREIGN KEY (`material_group_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_group`(`material_group_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_shipping_ports_v1`.`procurement` SET TAGS ('dbx_division' = 'corporate');
ALTER SCHEMA `vibe_shipping_ports_v1`.`procurement` SET TAGS ('dbx_domain' = 'procurement');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `country_id` SET TAGS ('dbx_business_glossary_term' = 'Country Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `port_community_participant_id` SET TAGS ('dbx_business_glossary_term' = 'Port Community Participant Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `un_locode_id` SET TAGS ('dbx_business_glossary_term' = 'Un Locode Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `address_line_1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `address_line_1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `address_line_1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `address_line_2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `address_line_2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `address_line_2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `approved_commodity_categories` SET TAGS ('dbx_business_glossary_term' = 'Approved Commodity Categories');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_currency` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Currency');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_currency` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_currency` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_valid_from` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Valid From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_valid_from` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_valid_from` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_valid_to` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Valid To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_valid_to` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_account_valid_to` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_branch` SET TAGS ('dbx_business_glossary_term' = 'Bank Branch Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_branch` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_name` SET TAGS ('dbx_business_glossary_term' = 'Bank Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `bank_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `business_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Business Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `vendor_category` SET TAGS ('dbx_business_glossary_term' = 'Vendor Business Category');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `vendor_code` SET TAGS ('dbx_business_glossary_term' = 'Vendor Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `vendor_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{6,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `credit_limit` SET TAGS ('dbx_business_glossary_term' = 'Vendor Credit Limit');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `credit_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `iban` SET TAGS ('dbx_business_glossary_term' = 'International Bank Account Number (IBAN)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `iban` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}[0-9]{2}[A-Z0-9]{1,30}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `iban` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `iban` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `iso_14001_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'ISO 14001 Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `iso_14001_certified` SET TAGS ('dbx_business_glossary_term' = 'ISO 14001 Environmental Management Certification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `iso_14001_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'ISO 14001 Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `iso_45001_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'ISO 45001 Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `iso_45001_certified` SET TAGS ('dbx_business_glossary_term' = 'ISO 45001 Occupational Health and Safety Certification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `iso_45001_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'ISO 45001 Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `iso_9001_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'ISO 9001 Certificate Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `iso_9001_certified` SET TAGS ('dbx_business_glossary_term' = 'ISO 9001 Quality Management Certification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `iso_9001_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'ISO 9001 Certificate Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `isps_clearance_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'ISPS Clearance Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `isps_clearance_number` SET TAGS ('dbx_business_glossary_term' = 'ISPS Clearance Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `isps_clearance_status` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Clearance Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `isps_clearance_status` SET TAGS ('dbx_value_regex' = 'cleared|pending|expired|not_required');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `last_performance_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Performance Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `minimum_order_value` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `vendor_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Legal Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `next_performance_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Performance Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `onboarding_date` SET TAGS ('dbx_business_glossary_term' = 'Vendor Onboarding Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `payment_terms_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `payment_terms_days` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms Days');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Person Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `short_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Short Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `standard_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Standard Lead Time Days');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State or Province');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `swift_bic_code` SET TAGS ('dbx_business_glossary_term' = 'SWIFT Bank Identifier Code (BIC)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `swift_bic_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `swift_bic_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_business_glossary_term' = 'Tax Identification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `tier` SET TAGS ('dbx_business_glossary_term' = 'Vendor Tier Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `tier` SET TAGS ('dbx_value_regex' = 'tier_1_strategic|tier_2_preferred|tier_3_approved|tier_4_conditional');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `trade_license_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Trade License Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `trade_license_issuing_authority` SET TAGS ('dbx_business_glossary_term' = 'Trade License Issuing Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `trade_license_number` SET TAGS ('dbx_business_glossary_term' = 'Trade License Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `vendor_status` SET TAGS ('dbx_business_glossary_term' = 'Vendor Lifecycle Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ALTER COLUMN `vendor_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|blocked|pending_approval|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `vendor_bank_account_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Bank Account ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `vendor_bank_account_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `vendor_bank_account_id` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `account_holder_name` SET TAGS ('dbx_business_glossary_term' = 'Account Holder Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `account_holder_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `account_status` SET TAGS ('dbx_business_glossary_term' = 'Account Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `account_status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|pending_verification|closed');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `account_type` SET TAGS ('dbx_business_glossary_term' = 'Account Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `account_type` SET TAGS ('dbx_value_regex' = 'checking|savings|current|business|escrow|trust');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_account_purpose` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Purpose');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_account_purpose` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_account_purpose` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Bank Address Line 1');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_address_line2` SET TAGS ('dbx_business_glossary_term' = 'Bank Address Line 2');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_branch` SET TAGS ('dbx_business_glossary_term' = 'Bank Branch');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_city` SET TAGS ('dbx_business_glossary_term' = 'Bank City');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_control_key` SET TAGS ('dbx_business_glossary_term' = 'Bank Control Key');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_country_code` SET TAGS ('dbx_business_glossary_term' = 'Bank Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_key` SET TAGS ('dbx_business_glossary_term' = 'Bank Key');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_name` SET TAGS ('dbx_business_glossary_term' = 'Bank Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_postal_code` SET TAGS ('dbx_business_glossary_term' = 'Bank Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_state_province` SET TAGS ('dbx_business_glossary_term' = 'Bank State or Province');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_state_province` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `bank_state_province` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `block_reason` SET TAGS ('dbx_business_glossary_term' = 'Block Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `iban` SET TAGS ('dbx_business_glossary_term' = 'International Bank Account Number (IBAN)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `iban` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `iban` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `intermediary_bank_name` SET TAGS ('dbx_business_glossary_term' = 'Intermediary Bank Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `intermediary_swift_code` SET TAGS ('dbx_business_glossary_term' = 'Intermediary Society for Worldwide Interbank Financial Telecommunication (SWIFT) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `intermediary_swift_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `intermediary_swift_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `intermediary_swift_code` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `is_blocked_for_payment` SET TAGS ('dbx_business_glossary_term' = 'Is Blocked for Payment Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `is_primary_account` SET TAGS ('dbx_business_glossary_term' = 'Is Primary Account Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `last_payment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Payment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `reference_details` SET TAGS ('dbx_business_glossary_term' = 'Reference Details');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `swift_code` SET TAGS ('dbx_business_glossary_term' = 'Society for Worldwide Interbank Financial Telecommunication (SWIFT) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `swift_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `swift_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `swift_code` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Verification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `verification_status` SET TAGS ('dbx_business_glossary_term' = 'Verification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `verification_status` SET TAGS ('dbx_value_regex' = 'verified|pending|failed|not_verified');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `verified_by` SET TAGS ('dbx_business_glossary_term' = 'Verified By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_bank_account` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` SET TAGS ('dbx_subdomain' = 'catalogue_planning');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `material_master_id` SET TAGS ('dbx_business_glossary_term' = 'Material Master ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `packaging_type_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `abc_indicator` SET TAGS ('dbx_business_glossary_term' = 'ABC Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `abc_indicator` SET TAGS ('dbx_value_regex' = 'A|B|C');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `base_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Base Unit of Measure (UoM)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `base_unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `batch_management_flag` SET TAGS ('dbx_business_glossary_term' = 'Batch Management Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Material Master Created Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `deletion_flag` SET TAGS ('dbx_business_glossary_term' = 'Deletion Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `gross_weight` SET TAGS ('dbx_business_glossary_term' = 'Gross Weight');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `imdg_class` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Dangerous Goods (IMDG) Class');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `last_modified_date` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Procurement Lead Time (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `lot_size_procedure` SET TAGS ('dbx_business_glossary_term' = 'Lot Size Procedure');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `manufacturer_name` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `manufacturer_part_number` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Part Number (MPN)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `material_long_description` SET TAGS ('dbx_business_glossary_term' = 'Material Long Description');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,18}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `material_status` SET TAGS ('dbx_business_glossary_term' = 'Material Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `material_status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|obsolete|pending_approval');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `material_type` SET TAGS ('dbx_business_glossary_term' = 'Material Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `maximum_stock_level` SET TAGS ('dbx_business_glossary_term' = 'Maximum Stock Level');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `minimum_shelf_life_days` SET TAGS ('dbx_business_glossary_term' = 'Minimum Remaining Shelf Life (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `moving_average_price` SET TAGS ('dbx_business_glossary_term' = 'Moving Average Price (MAP)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `moving_average_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `mrp_type` SET TAGS ('dbx_business_glossary_term' = 'Material Requirements Planning (MRP) Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `net_weight` SET TAGS ('dbx_business_glossary_term' = 'Net Weight');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `price_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `procurement_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `procurement_type` SET TAGS ('dbx_value_regex' = 'external|internal|both');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `quality_inspection_flag` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `reorder_point` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `safety_stock_level` SET TAGS ('dbx_business_glossary_term' = 'Safety Stock Level');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `serial_number_profile` SET TAGS ('dbx_business_glossary_term' = 'Serial Number Profile');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `shelf_life_days` SET TAGS ('dbx_business_glossary_term' = 'Shelf Life (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `standard_price` SET TAGS ('dbx_business_glossary_term' = 'Standard Price');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `standard_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `storage_conditions` SET TAGS ('dbx_business_glossary_term' = 'Storage Conditions');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `un_number` SET TAGS ('dbx_business_glossary_term' = 'United Nations (UN) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `un_number` SET TAGS ('dbx_value_regex' = '^UN[0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `valuation_class` SET TAGS ('dbx_business_glossary_term' = 'Valuation Class');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `volume` SET TAGS ('dbx_business_glossary_term' = 'Volume');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `volume_unit` SET TAGS ('dbx_business_glossary_term' = 'Volume Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `volume_unit` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `weight_unit` SET TAGS ('dbx_business_glossary_term' = 'Weight Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `weight_unit` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` SET TAGS ('dbx_subdomain' = 'catalogue_planning');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `material_group_id` SET TAGS ('dbx_business_glossary_term' = 'Material Group ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `cargo_category_id` SET TAGS ('dbx_business_glossary_term' = 'Cargo Category Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `parent_material_group_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Material Group ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `annual_spend_estimate` SET TAGS ('dbx_business_glossary_term' = 'Annual Spend Estimate');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `annual_spend_estimate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `approval_workflow` SET TAGS ('dbx_business_glossary_term' = 'Approval Workflow');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `approval_workflow` SET TAGS ('dbx_value_regex' = 'standard|expedited|executive|technical_review');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `budget_allocation_code` SET TAGS ('dbx_business_glossary_term' = 'Budget Allocation Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `material_group_code` SET TAGS ('dbx_business_glossary_term' = 'Material Group Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `material_group_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `commodity_type` SET TAGS ('dbx_business_glossary_term' = 'Commodity Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `contract_management_required` SET TAGS ('dbx_business_glossary_term' = 'Contract Management Required');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `critical_spare_indicator` SET TAGS ('dbx_business_glossary_term' = 'Critical Spare Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `material_group_description` SET TAGS ('dbx_business_glossary_term' = 'Material Group Description');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `environmental_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'Environmental Compliance Required');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `external_reference_code` SET TAGS ('dbx_business_glossary_term' = 'External Reference ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `hazmat_indicator` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HAZMAT) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_business_glossary_term' = 'Hierarchy Level');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `hs_code_prefix` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Code Prefix');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `hs_code_prefix` SET TAGS ('dbx_value_regex' = '^[0-9]{2,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Days');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `local_content_requirement` SET TAGS ('dbx_business_glossary_term' = 'Local Content Requirement Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `material_group_status` SET TAGS ('dbx_business_glossary_term' = 'Material Group Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `material_group_status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `material_type` SET TAGS ('dbx_business_glossary_term' = 'Material Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `material_type` SET TAGS ('dbx_value_regex' = 'raw_material|spare_part|consumable|service|equipment|trading_goods');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `material_group_name` SET TAGS ('dbx_business_glossary_term' = 'Material Group Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `obsolescence_risk` SET TAGS ('dbx_business_glossary_term' = 'Obsolescence Risk');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `obsolescence_risk` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `preferred_supplier_count` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier Count');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `procurement_category` SET TAGS ('dbx_business_glossary_term' = 'Procurement Category');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `procurement_category` SET TAGS ('dbx_value_regex' = 'direct|indirect|services|capital');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `quality_inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Required');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `spend_category` SET TAGS ('dbx_business_glossary_term' = 'Spend Category');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `spend_category` SET TAGS ('dbx_value_regex' = 'opex|capex|mixed');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `spend_visibility_level` SET TAGS ('dbx_business_glossary_term' = 'Spend Visibility Level');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `spend_visibility_level` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `strategic_sourcing_indicator` SET TAGS ('dbx_business_glossary_term' = 'Strategic Sourcing Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `supplier_consolidation_target` SET TAGS ('dbx_business_glossary_term' = 'Supplier Consolidation Target');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `sustainability_criteria` SET TAGS ('dbx_business_glossary_term' = 'Sustainability Criteria');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `tax_classification` SET TAGS ('dbx_business_glossary_term' = 'Tax Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `valuation_class` SET TAGS ('dbx_business_glossary_term' = 'Valuation Class');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `valuation_class` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` SET TAGS ('dbx_subdomain' = 'requisition_sourcing');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `org_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Requesting Department ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Preferred Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Requisitioner ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment Category');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_value_regex' = 'cost_center|internal_order|wbs_element|asset|sales_order|network');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `asset_number` SET TAGS ('dbx_business_glossary_term' = 'Asset Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `asset_number` SET TAGS ('dbx_value_regex' = '^[0-9]{12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `contract_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `deletion_indicator` SET TAGS ('dbx_business_glossary_term' = 'Deletion Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `estimated_total_value` SET TAGS ('dbx_business_glossary_term' = 'Estimated Total Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `estimated_unit_price` SET TAGS ('dbx_business_glossary_term' = 'Estimated Unit Price');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `fixed_vendor_indicator` SET TAGS ('dbx_business_glossary_term' = 'Fixed Vendor Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `gl_account` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `gl_account` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `internal_order_number` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `internal_order_number` SET TAGS ('dbx_value_regex' = '^[0-9]{12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `item_category` SET TAGS ('dbx_business_glossary_term' = 'Requisition Item Category');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `item_category` SET TAGS ('dbx_value_regex' = 'standard|service|consignment|subcontracting|stock_transfer|third_party');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `material_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,9}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[0-9]{18}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Requisition Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Requisition Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'urgent|high|normal|low');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_order_item` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Item Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Requisition Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `release_indicator` SET TAGS ('dbx_business_glossary_term' = 'Release Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `requisition_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `requisition_number` SET TAGS ('dbx_value_regex' = '^PR[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `requisition_status` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `requisition_type` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `requisition_type` SET TAGS ('dbx_value_regex' = 'standard|stock_replenishment|subcontracting|consignment|service|asset_procurement');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `requisitioner_email` SET TAGS ('dbx_business_glossary_term' = 'Requisitioner Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `requisitioner_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `requisitioner_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `requisitioner_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `requisitioner_name` SET TAGS ('dbx_business_glossary_term' = 'Requisitioner Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `source_determination_indicator` SET TAGS ('dbx_business_glossary_term' = 'Source Determination Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `source_determination_indicator` SET TAGS ('dbx_value_regex' = 'automatic|manual|contract_release|info_record');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Tracking Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `tracking_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `valuation_type` SET TAGS ('dbx_business_glossary_term' = 'Valuation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `valuation_type` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{0,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ALTER COLUMN `wbs_element` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{1,24}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` SET TAGS ('dbx_subdomain' = 'requisition_sourcing');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `purchase_requisition_item_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Item ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment Category');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_value_regex' = 'K|A|P|F|N');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `asset_number` SET TAGS ('dbx_business_glossary_term' = 'Asset Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `asset_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `contract_item` SET TAGS ('dbx_business_glossary_term' = 'Contract Item Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `contract_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `currency` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `deletion_indicator` SET TAGS ('dbx_business_glossary_term' = 'Deletion Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `fixed_vendor_indicator` SET TAGS ('dbx_business_glossary_term' = 'Fixed Vendor Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `gl_account` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `gl_account` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `goods_receipt_indicator` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `internal_order` SET TAGS ('dbx_business_glossary_term' = 'Internal Order');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `internal_order` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `invoice_receipt_indicator` SET TAGS ('dbx_business_glossary_term' = 'Invoice Receipt (IR) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `item_category` SET TAGS ('dbx_business_glossary_term' = 'Item Category');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `item_category` SET TAGS ('dbx_value_regex' = '^[A-Z]{1}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `item_number` SET TAGS ('dbx_business_glossary_term' = 'Item Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `item_status` SET TAGS ('dbx_business_glossary_term' = 'Item Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `item_status` SET TAGS ('dbx_value_regex' = 'open|approved|partially_ordered|fully_ordered|closed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `long_text` SET TAGS ('dbx_business_glossary_term' = 'Item Long Text');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `material_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `material_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,18}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `modified_by` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `plant` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `plant` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Requisition Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'urgent|high|normal|low');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `purchase_order_item` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Item Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_value_regex' = '^[0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Requisition Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `release_indicator` SET TAGS ('dbx_business_glossary_term' = 'Release Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `release_indicator` SET TAGS ('dbx_value_regex' = 'not_released|released|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `requisition_type` SET TAGS ('dbx_business_glossary_term' = 'Requisition Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `requisition_type` SET TAGS ('dbx_value_regex' = 'standard|stock|service|subcontract|consignment');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `requisitioner` SET TAGS ('dbx_business_glossary_term' = 'Requisitioner ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `requisitioner` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `short_text` SET TAGS ('dbx_business_glossary_term' = 'Item Short Text');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `source_of_supply` SET TAGS ('dbx_business_glossary_term' = 'Source of Supply');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `source_of_supply` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `total_value` SET TAGS ('dbx_business_glossary_term' = 'Total Line Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Tracking Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `tracking_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10,20}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `valuation_price` SET TAGS ('dbx_business_glossary_term' = 'Valuation Price');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `vendor_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `vendor_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `wbs_element` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{8,24}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition_item` ALTER COLUMN `created_by` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,12}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` SET TAGS ('dbx_subdomain' = 'requisition_sourcing');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `rfq_id` SET TAGS ('dbx_business_glossary_term' = 'Request for Quotation (RFQ) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Awarded Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `material_group_id` SET TAGS ('dbx_business_glossary_term' = 'Material Group Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By User');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `award_date` SET TAGS ('dbx_business_glossary_term' = 'Award Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `award_justification` SET TAGS ('dbx_business_glossary_term' = 'Award Justification');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `awarded_quotation_number` SET TAGS ('dbx_business_glossary_term' = 'Awarded Quotation Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `commodity_description` SET TAGS ('dbx_business_glossary_term' = 'Commodity Description');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Level');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_value_regex' = 'public|internal|confidential|restricted');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `contract_type` SET TAGS ('dbx_business_glossary_term' = 'Contract Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `contract_type` SET TAGS ('dbx_value_regex' = 'one_time|framework|blanket|spot');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `delivery_location` SET TAGS ('dbx_business_glossary_term' = 'Delivery Location');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `environmental_requirements` SET TAGS ('dbx_business_glossary_term' = 'Environmental Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `evaluation_criteria` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Criteria');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `gl_account` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'International Commercial Terms (Incoterms)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `insurance_requirements` SET TAGS ('dbx_business_glossary_term' = 'Insurance Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'RFQ Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `lowest_quoted_price` SET TAGS ('dbx_business_glossary_term' = 'Lowest Quoted Price');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Record Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'RFQ Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `quality_requirements` SET TAGS ('dbx_business_glossary_term' = 'Quality Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `quantity_requested` SET TAGS ('dbx_business_glossary_term' = 'Quantity Requested');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `quotation_count` SET TAGS ('dbx_business_glossary_term' = 'Quotation Count');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `required_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Required Delivery Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `requisition_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `rfq_number` SET TAGS ('dbx_business_glossary_term' = 'Request for Quotation (RFQ) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `rfq_number` SET TAGS ('dbx_value_regex' = '^RFQ-[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `rfq_status` SET TAGS ('dbx_business_glossary_term' = 'Request for Quotation (RFQ) Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `rfq_type` SET TAGS ('dbx_business_glossary_term' = 'Request for Quotation (RFQ) Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `rfq_type` SET TAGS ('dbx_value_regex' = 'standard|framework|emergency|spot|contract');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `safety_requirements` SET TAGS ('dbx_business_glossary_term' = 'Safety Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `submission_deadline` SET TAGS ('dbx_business_glossary_term' = 'Quotation Submission Deadline');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `technical_specifications` SET TAGS ('dbx_business_glossary_term' = 'Technical Specifications');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `total_estimated_value` SET TAGS ('dbx_business_glossary_term' = 'Total Estimated Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'RFQ Validity End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `vendor_prequalification_required` SET TAGS ('dbx_business_glossary_term' = 'Vendor Prequalification Required');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` SET TAGS ('dbx_subdomain' = 'requisition_sourcing');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `vendor_quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Quotation Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `rfq_id` SET TAGS ('dbx_business_glossary_term' = 'Request for Quotation (RFQ) Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Identifier (ID)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `award_justification` SET TAGS ('dbx_business_glossary_term' = 'Award Justification');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `commercial_terms_notes` SET TAGS ('dbx_business_glossary_term' = 'Commercial Terms Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `delivery_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Delivery Lead Time (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `delivery_location` SET TAGS ('dbx_business_glossary_term' = 'Delivery Location');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `evaluation_score` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Score');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'International Commercial Terms (Incoterms)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `price_competitiveness_rank` SET TAGS ('dbx_business_glossary_term' = 'Price Competitiveness Rank');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `quotation_number` SET TAGS ('dbx_business_glossary_term' = 'Quotation Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `quotation_status` SET TAGS ('dbx_business_glossary_term' = 'Quotation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `quotation_type` SET TAGS ('dbx_business_glossary_term' = 'Quotation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `quotation_type` SET TAGS ('dbx_value_regex' = 'standard|framework|spot|emergency|contract_renewal');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `recommended_for_award_flag` SET TAGS ('dbx_business_glossary_term' = 'Recommended for Award Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Quotation Submission Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `technical_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Technical Compliance Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `technical_deviation_notes` SET TAGS ('dbx_business_glossary_term' = 'Technical Deviation Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `total_quoted_value` SET TAGS ('dbx_business_glossary_term' = 'Total Quoted Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `total_value_including_tax` SET TAGS ('dbx_business_glossary_term' = 'Total Value Including Tax');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Quotation Validity End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Quotation Validity Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `vendor_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contact Email Address');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `vendor_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `vendor_contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `vendor_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `vendor_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contact Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `vendor_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `vendor_contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `vendor_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contact Phone Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `vendor_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `vendor_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ALTER COLUMN `warranty_period_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Period (Months)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` SET TAGS ('dbx_subdomain' = 'order_fulfilment');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `port_location_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Port Location Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `zone_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Security Zone Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|approved|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `buyer_name` SET TAGS ('dbx_business_glossary_term' = 'Buyer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `cancelled_date` SET TAGS ('dbx_business_glossary_term' = 'Cancelled Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `closed_date` SET TAGS ('dbx_business_glossary_term' = 'Closed Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `collective_number` SET TAGS ('dbx_business_glossary_term' = 'Collective Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `contract_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `delivery_address` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `delivery_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `delivery_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `delivery_country_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `delivery_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Delivery Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `delivery_postal_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Postal Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `delivery_postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `delivery_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `freight_terms` SET TAGS ('dbx_business_glossary_term' = 'Freight Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `freight_terms` SET TAGS ('dbx_value_regex' = 'prepaid|collect|third_party');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `goods_receipt_indicator` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Location');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `invoice_receipt_indicator` SET TAGS ('dbx_business_glossary_term' = 'Invoice Receipt (IR) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `net_order_value` SET TAGS ('dbx_business_glossary_term' = 'Net Order Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `po_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,15}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `po_status` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `po_type` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `po_type` SET TAGS ('dbx_value_regex' = 'standard|blanket|contract|subcontracting|consignment|framework');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Priority');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|normal|high|urgent');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `release_strategy` SET TAGS ('dbx_business_glossary_term' = 'Release Strategy');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `requisition_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `requisitioner_name` SET TAGS ('dbx_business_glossary_term' = 'Requisitioner Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `service_entry_required` SET TAGS ('dbx_business_glossary_term' = 'Service Entry Required');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `shipping_method` SET TAGS ('dbx_business_glossary_term' = 'Shipping Method');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `shipping_method` SET TAGS ('dbx_value_regex' = 'sea_freight|air_freight|road_transport|rail_transport|courier|multimodal');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `total_po_value` SET TAGS ('dbx_business_glossary_term' = 'Total Purchase Order (PO) Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `vendor_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contact Email');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `vendor_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `vendor_contact_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `vendor_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `vendor_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contact Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `vendor_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `vendor_contact_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `vendor_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contact Phone');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `vendor_contact_phone` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ALTER COLUMN `vendor_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` SET TAGS ('dbx_subdomain' = 'order_fulfilment');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `purchase_order_item_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Item ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `equipment_type_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Type Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `material_master_id` SET TAGS ('dbx_business_glossary_term' = 'Material ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `supplier_contract_item_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Item Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `work_order_id` SET TAGS ('dbx_business_glossary_term' = 'Work Order ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_business_glossary_term' = 'Account Assignment Category');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `account_assignment_category` SET TAGS ('dbx_value_regex' = 'cost_center|asset|order|project|sales_order|unknown');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `asset_number` SET TAGS ('dbx_business_glossary_term' = 'Asset Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `confirmation_control_key` SET TAGS ('dbx_business_glossary_term' = 'Confirmation Control Key');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `created_by_user` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `deletion_indicator` SET TAGS ('dbx_business_glossary_term' = 'Deletion Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Delivery Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `general_ledger_account` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `goods_receipt_indicator` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `goods_receipt_quantity` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Location');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `invoice_receipt_indicator` SET TAGS ('dbx_business_glossary_term' = 'Invoice Receipt (IR) Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `invoiced_quantity` SET TAGS ('dbx_business_glossary_term' = 'Invoiced Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `item_category` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Item Category');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `item_category` SET TAGS ('dbx_value_regex' = 'standard|consignment|subcontracting|service|stock_transfer|third_party');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `item_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Item Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `item_status` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Item Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `item_status` SET TAGS ('dbx_value_regex' = 'open|partially_received|fully_received|closed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `manufacturer_part_number` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Part Number (MPN)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `material_number` SET TAGS ('dbx_business_glossary_term' = 'Material Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Modified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `net_order_value` SET TAGS ('dbx_business_glossary_term' = 'Net Order Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Price per Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Ordered Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `outstanding_quantity` SET TAGS ('dbx_business_glossary_term' = 'Outstanding Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `over_delivery_tolerance_percent` SET TAGS ('dbx_business_glossary_term' = 'Over-Delivery Tolerance Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `price_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `purchase_requisition_item` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition (PR) Item Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `purchase_requisition_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition (PR) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `requisitioner_name` SET TAGS ('dbx_business_glossary_term' = 'Requisitioner Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `short_text` SET TAGS ('dbx_business_glossary_term' = 'Item Short Text');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `under_delivery_tolerance_percent` SET TAGS ('dbx_business_glossary_term' = 'Under-Delivery Tolerance Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ALTER COLUMN `vendor_material_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Material Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` SET TAGS ('dbx_subdomain' = 'order_fulfilment');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `customs_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Customs Declaration Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `access_point_id` SET TAGS ('dbx_business_glossary_term' = 'Entry Access Point Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `material_master_id` SET TAGS ('dbx_business_glossary_term' = 'Material ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `purchase_order_item_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Line ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Receiver Employee ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `asset_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `vessel_master_id` SET TAGS ('dbx_business_glossary_term' = 'Vessel Master Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `batch_number` SET TAGS ('dbx_business_glossary_term' = 'Batch Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `bill_of_lading_number` SET TAGS ('dbx_business_glossary_term' = 'Bill of Lading (BOL) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `carrier_name` SET TAGS ('dbx_business_glossary_term' = 'Carrier Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `certificate_of_origin_number` SET TAGS ('dbx_business_glossary_term' = 'Certificate of Origin Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `container_number` SET TAGS ('dbx_business_glossary_term' = 'Container Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `container_number` SET TAGS ('dbx_value_regex' = '^[A-Z]{4}[0-9]{7}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Delivery Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `delivery_note_number` SET TAGS ('dbx_business_glossary_term' = 'Delivery Note Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `goods_receipt_status` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `goods_receipt_status` SET TAGS ('dbx_value_regex' = 'draft|posted|reversed|cancelled|completed');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `hs_code` SET TAGS ('dbx_business_glossary_term' = 'Harmonized System (HS) Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `hs_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `inspection_lot_number` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `material_document_year` SET TAGS ('dbx_business_glossary_term' = 'Material Document Year');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `movement_type` SET TAGS ('dbx_business_glossary_term' = 'Movement Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `ordered_quantity` SET TAGS ('dbx_business_glossary_term' = 'Ordered Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `quality_inspection_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|in_progress|passed|failed|conditional');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `received_quantity` SET TAGS ('dbx_business_glossary_term' = 'Received Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `receiver_name` SET TAGS ('dbx_business_glossary_term' = 'Receiver Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Serial Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `stock_type` SET TAGS ('dbx_business_glossary_term' = 'Stock Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `stock_type` SET TAGS ('dbx_value_regex' = 'unrestricted|quality_inspection|blocked|restricted');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `three_way_match_status` SET TAGS ('dbx_business_glossary_term' = 'Three-Way Match Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `three_way_match_status` SET TAGS ('dbx_value_regex' = 'not_started|matched|variance_detected|approved|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `transport_mode` SET TAGS ('dbx_business_glossary_term' = 'Transport Mode');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `transport_mode` SET TAGS ('dbx_value_regex' = 'truck|rail|vessel|barge|air|courier');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `unloading_point` SET TAGS ('dbx_business_glossary_term' = 'Unloading Point');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `valuation_amount` SET TAGS ('dbx_business_glossary_term' = 'Valuation Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `variance_quantity` SET TAGS ('dbx_business_glossary_term' = 'Variance Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `variance_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Variance Reason Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `variance_reason_code` SET TAGS ('dbx_value_regex' = 'damage|shortage|overage|quality_issue|wrong_item|partial_delivery');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ALTER COLUMN `vehicle_registration_number` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Registration Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` SET TAGS ('dbx_subdomain' = 'order_fulfilment');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_entry_sheet_id` SET TAGS ('dbx_business_glossary_term' = 'Service Entry Sheet ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `booking_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Booking Service Order Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Accepted By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Contract ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `tertiary_service_created_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `tertiary_service_created_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `tertiary_service_created_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `acceptance_date` SET TAGS ('dbx_business_glossary_term' = 'Service Acceptance Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `acceptance_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Service Acceptance Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `accepted_by_name` SET TAGS ('dbx_business_glossary_term' = 'Accepted By Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `invoice_verification_status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Verification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `invoice_verification_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|blocked');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `payment_release_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Release Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `payment_release_status` SET TAGS ('dbx_value_regex' = 'not_released|released|paid|blocked');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_description` SET TAGS ('dbx_business_glossary_term' = 'Service Description');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_entry_sheet_number` SET TAGS ('dbx_business_glossary_term' = 'Service Entry Sheet Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_entry_sheet_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_entry_sheet_status` SET TAGS ('dbx_business_glossary_term' = 'Service Entry Sheet Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_entry_sheet_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|accepted|rejected|cancelled|posted');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Service Period End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Service Period Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_type_code` SET TAGS ('dbx_business_glossary_term' = 'Service Type Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `service_type_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `total_accepted_quantity` SET TAGS ('dbx_business_glossary_term' = 'Total Accepted Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ALTER COLUMN `total_accepted_value` SET TAGS ('dbx_business_glossary_term' = 'Total Accepted Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` SET TAGS ('dbx_subdomain' = 'order_fulfilment');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `vendor_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Invoice ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `purchase_order_item_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Item Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `service_entry_sheet_id` SET TAGS ('dbx_business_glossary_term' = 'Service Entry Sheet Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `baseline_date` SET TAGS ('dbx_business_glossary_term' = 'Baseline Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `cash_discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `cash_discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Cash Discount Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `document_header_text` SET TAGS ('dbx_business_glossary_term' = 'Document Header Text');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `invoice_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `invoice_gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoice Gross Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `invoice_net_amount` SET TAGS ('dbx_business_glossary_term' = 'Invoice Net Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Invoice Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `invoice_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Receipt Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `invoice_status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Verification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `invoice_status` SET TAGS ('dbx_value_regex' = 'parked|blocked|cleared|posted|cancelled|reversed');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_business_glossary_term' = 'Invoice Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `invoice_type` SET TAGS ('dbx_value_regex' = 'standard|credit_memo|debit_memo|prepayment|down_payment|final_invoice');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `payment_block_code` SET TAGS ('dbx_business_glossary_term' = 'Payment Block Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `payment_block_reason` SET TAGS ('dbx_business_glossary_term' = 'Payment Block Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `payment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'bank_transfer|check|wire_transfer|ach|credit_card|letter_of_credit');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `payment_reference` SET TAGS ('dbx_business_glossary_term' = 'Payment Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `price_variance` SET TAGS ('dbx_business_glossary_term' = 'Price Variance');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `quantity_variance` SET TAGS ('dbx_business_glossary_term' = 'Quantity Variance');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `reversal_date` SET TAGS ('dbx_business_glossary_term' = 'Reversal Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `reversal_indicator` SET TAGS ('dbx_business_glossary_term' = 'Reversal Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `three_way_match_status` SET TAGS ('dbx_business_glossary_term' = 'Three-Way Match Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `three_way_match_status` SET TAGS ('dbx_value_regex' = 'matched|quantity_variance|price_variance|not_matched|bypassed');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `vendor_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Reference Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Invoice Verification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `verified_by` SET TAGS ('dbx_business_glossary_term' = 'Verified By User');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `withholding_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_invoice` ALTER COLUMN `withholding_tax_code` SET TAGS ('dbx_business_glossary_term' = 'Withholding Tax Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` SET TAGS ('dbx_subdomain' = 'contract_settlement');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `amendment_count` SET TAGS ('dbx_business_glossary_term' = 'Amendment Count');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `commodity_code` SET TAGS ('dbx_business_glossary_term' = 'Commodity Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `compliance_requirements` SET TAGS ('dbx_business_glossary_term' = 'Compliance Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `confidentiality_clause` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Clause');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_description` SET TAGS ('dbx_business_glossary_term' = 'Contract Description');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Document Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_owner` SET TAGS ('dbx_business_glossary_term' = 'Contract Owner');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_status` SET TAGS ('dbx_business_glossary_term' = 'Contract Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|terminated|closed');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_business_glossary_term' = 'Contract Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_value_regex' = 'blanket_purchase_order|scheduling_agreement|quantity_contract|value_contract|framework_agreement|outline_agreement');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `contract_value` SET TAGS ('dbx_business_glossary_term' = 'Contract Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `delivery_location` SET TAGS ('dbx_business_glossary_term' = 'Delivery Location');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `dispute_resolution_method` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Method');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `dispute_resolution_method` SET TAGS ('dbx_value_regex' = 'negotiation|mediation|arbitration|litigation');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `governing_law` SET TAGS ('dbx_business_glossary_term' = 'Governing Law');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `insurance_requirements` SET TAGS ('dbx_business_glossary_term' = 'Insurance Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `last_amendment_date` SET TAGS ('dbx_business_glossary_term' = 'Last Amendment Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `penalty_clause` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `quantity_unit` SET TAGS ('dbx_business_glossary_term' = 'Quantity Unit of Measure');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `released_quantity` SET TAGS ('dbx_business_glossary_term' = 'Released Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `released_value` SET TAGS ('dbx_business_glossary_term' = 'Released Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `renewal_terms` SET TAGS ('dbx_business_glossary_term' = 'Renewal Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `risk_classification` SET TAGS ('dbx_business_glossary_term' = 'Risk Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `risk_classification` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `service_level_agreement` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `target_quantity` SET TAGS ('dbx_business_glossary_term' = 'Target Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `termination_clause` SET TAGS ('dbx_business_glossary_term' = 'Termination Clause');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `utilization_percentage` SET TAGS ('dbx_business_glossary_term' = 'Utilization Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `vendor_performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Vendor Performance Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `vendor_performance_rating` SET TAGS ('dbx_value_regex' = 'excellent|good|satisfactory|poor|unrated');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` SET TAGS ('dbx_subdomain' = 'contract_settlement');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `supplier_contract_item_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Item ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `material_master_id` SET TAGS ('dbx_business_glossary_term' = 'Material ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `blocking_indicator` SET TAGS ('dbx_business_glossary_term' = 'Blocking Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `contract_item_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Item Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `contract_item_number` SET TAGS ('dbx_value_regex' = '^[0-9]{5,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `deletion_indicator` SET TAGS ('dbx_business_glossary_term' = 'Deletion Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `delivery_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Delivery Lead Time (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `discount_percentage` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `goods_receipt_required` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Required');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Location');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `invoice_receipt_required` SET TAGS ('dbx_business_glossary_term' = 'Invoice Receipt Required');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `item_category` SET TAGS ('dbx_business_glossary_term' = 'Item Category');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `item_category` SET TAGS ('dbx_value_regex' = 'standard|consignment|subcontracting|service|limit|blanket');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `item_status` SET TAGS ('dbx_business_glossary_term' = 'Item Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `item_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|closed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `last_goods_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Last Goods Receipt Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `last_release_order_date` SET TAGS ('dbx_business_glossary_term' = 'Last Release Order Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `manufacturer_part_number` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Part Number (MPN)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `material_description` SET TAGS ('dbx_business_glossary_term' = 'Material Description');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `material_group` SET TAGS ('dbx_business_glossary_term' = 'Material Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `material_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `maximum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Order Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Price');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `order_quantity_multiple` SET TAGS ('dbx_business_glossary_term' = 'Order Quantity Multiple');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `price_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `quality_inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Required');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `released_quantity` SET TAGS ('dbx_business_glossary_term' = 'Released Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `released_value` SET TAGS ('dbx_business_glossary_term' = 'Released Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `remaining_quantity` SET TAGS ('dbx_business_glossary_term' = 'Remaining Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `remaining_value` SET TAGS ('dbx_business_glossary_term' = 'Remaining Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `service_description` SET TAGS ('dbx_business_glossary_term' = 'Service Description');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Storage Location');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `storage_location` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `target_quantity` SET TAGS ('dbx_business_glossary_term' = 'Target Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `target_value` SET TAGS ('dbx_business_glossary_term' = 'Target Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `tax_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `technical_specification_reference` SET TAGS ('dbx_business_glossary_term' = 'Technical Specification Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Validity End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Validity Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `warranty_period_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Period (Months)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`supplier_contract_item` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `vendor_evaluation_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Evaluation ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Evaluator ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `kpi_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Kpi Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `corrective_action_description` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Description');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `corrective_action_due_date` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `corrective_action_required` SET TAGS ('dbx_business_glossary_term' = 'Corrective Action Required');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `current_vendor_tier` SET TAGS ('dbx_business_glossary_term' = 'Current Vendor Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `current_vendor_tier` SET TAGS ('dbx_value_regex' = 'preferred|approved|conditional|probation|blocked');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `documentation_compliance_score` SET TAGS ('dbx_business_glossary_term' = 'Documentation Compliance Score');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `documentation_compliance_weight` SET TAGS ('dbx_business_glossary_term' = 'Documentation Compliance Weight');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `evaluation_comments` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Comments');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `evaluation_date` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `evaluation_number` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `evaluation_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Period End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `evaluation_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Period Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `evaluation_status` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `evaluation_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|approved|rejected|completed');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `evaluation_type` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `evaluation_type` SET TAGS ('dbx_value_regex' = 'periodic|ad_hoc|contract_renewal|incident_driven|qualification|requalification');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `evaluator_name` SET TAGS ('dbx_business_glossary_term' = 'Evaluator Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `hsse_compliance_score` SET TAGS ('dbx_business_glossary_term' = 'Health, Safety, Security, Environment (HSSE) Compliance Score');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `hsse_compliance_weight` SET TAGS ('dbx_business_glossary_term' = 'Health, Safety, Security, Environment (HSSE) Compliance Weight');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `late_deliveries` SET TAGS ('dbx_business_glossary_term' = 'Late Deliveries');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `next_evaluation_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Evaluation Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `on_time_deliveries` SET TAGS ('dbx_business_glossary_term' = 'On-Time Deliveries');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `on_time_delivery_score` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery Score');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `on_time_delivery_weight` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery Weight');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `overall_rating` SET TAGS ('dbx_business_glossary_term' = 'Overall Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `overall_rating` SET TAGS ('dbx_value_regex' = 'excellent|good|satisfactory|marginal|unsatisfactory');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `overall_score` SET TAGS ('dbx_business_glossary_term' = 'Overall Score');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `price_competitiveness_score` SET TAGS ('dbx_business_glossary_term' = 'Price Competitiveness Score');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `price_competitiveness_weight` SET TAGS ('dbx_business_glossary_term' = 'Price Competitiveness Weight');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `quality_acceptance_rate` SET TAGS ('dbx_business_glossary_term' = 'Quality Acceptance Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `quality_compliance_score` SET TAGS ('dbx_business_glossary_term' = 'Quality Compliance Score');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `quality_compliance_weight` SET TAGS ('dbx_business_glossary_term' = 'Quality Compliance Weight');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `quality_rejections` SET TAGS ('dbx_business_glossary_term' = 'Quality Rejections');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `recommended_vendor_tier` SET TAGS ('dbx_business_glossary_term' = 'Recommended Vendor Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `recommended_vendor_tier` SET TAGS ('dbx_value_regex' = 'preferred|approved|conditional|probation|blocked');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `responsiveness_score` SET TAGS ('dbx_business_glossary_term' = 'Responsiveness Score');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `responsiveness_weight` SET TAGS ('dbx_business_glossary_term' = 'Responsiveness Weight');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `tier_change_reason` SET TAGS ('dbx_business_glossary_term' = 'Tier Change Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `total_purchase_orders` SET TAGS ('dbx_business_glossary_term' = 'Total Purchase Orders');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `total_purchase_value` SET TAGS ('dbx_business_glossary_term' = 'Total Purchase Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approved_vendor_list_id` SET TAGS ('dbx_business_glossary_term' = 'Approved Vendor List ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `material_group_id` SET TAGS ('dbx_business_glossary_term' = 'Material Group Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approval_authority` SET TAGS ('dbx_business_glossary_term' = 'Approval Authority');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approval_number` SET TAGS ('dbx_business_glossary_term' = 'Approval Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approval_number` SET TAGS ('dbx_value_regex' = '^AVL-[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'approved|conditional|suspended|revoked|expired|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approval_type` SET TAGS ('dbx_business_glossary_term' = 'Approval Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approval_type` SET TAGS ('dbx_value_regex' = 'full|conditional|trial|temporary|emergency');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `approved_service_categories` SET TAGS ('dbx_business_glossary_term' = 'Approved Service Categories');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `audit_date` SET TAGS ('dbx_business_glossary_term' = 'Audit Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `audit_outcome` SET TAGS ('dbx_business_glossary_term' = 'Audit Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `audit_outcome` SET TAGS ('dbx_value_regex' = 'passed|passed_with_conditions|failed|not_applicable');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `certification_requirements` SET TAGS ('dbx_business_glossary_term' = 'Certification Requirements');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `financial_stability_check_date` SET TAGS ('dbx_business_glossary_term' = 'Financial Stability Check Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_business_glossary_term' = 'Geographic Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `hsse_approval_date` SET TAGS ('dbx_business_glossary_term' = 'Health Safety Security and Environment (HSSE) Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `hsse_approved` SET TAGS ('dbx_business_glossary_term' = 'Health Safety Security and Environment (HSSE) Approved');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `imo_compliant` SET TAGS ('dbx_business_glossary_term' = 'International Maritime Organization (IMO) Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `insurance_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Insurance Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `insurance_verified` SET TAGS ('dbx_business_glossary_term' = 'Insurance Verified');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `iso_certifications` SET TAGS ('dbx_business_glossary_term' = 'International Organization for Standardization (ISO) Certifications');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `isps_compliant` SET TAGS ('dbx_business_glossary_term' = 'International Ship and Port Facility Security (ISPS) Compliant');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `maximum_order_value` SET TAGS ('dbx_business_glossary_term' = 'Maximum Order Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `performance_score` SET TAGS ('dbx_business_glossary_term' = 'Performance Score');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `preferred_vendor` SET TAGS ('dbx_business_glossary_term' = 'Preferred Vendor');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `qualification_basis` SET TAGS ('dbx_business_glossary_term' = 'Qualification Basis');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `qualification_basis` SET TAGS ('dbx_value_regex' = 'audit|certification|trial_order|reference_check|pre_qualification|tender_evaluation');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `reinstatement_date` SET TAGS ('dbx_business_glossary_term' = 'Reinstatement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `review_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Review Frequency Months');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Risk Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `risk_rating` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `supply_restrictions` SET TAGS ('dbx_business_glossary_term' = 'Supply Restrictions');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `suspension_date` SET TAGS ('dbx_business_glossary_term' = 'Suspension Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `suspension_reason` SET TAGS ('dbx_business_glossary_term' = 'Suspension Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `vendor_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Certification ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `accreditation_body` SET TAGS ('dbx_business_glossary_term' = 'Accreditation Body');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `audit_frequency_months` SET TAGS ('dbx_business_glossary_term' = 'Audit Frequency Months');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `certificate_document_url` SET TAGS ('dbx_business_glossary_term' = 'Certificate Document URL');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `certification_level` SET TAGS ('dbx_business_glossary_term' = 'Certification Level');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `certification_name` SET TAGS ('dbx_business_glossary_term' = 'Certification Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `certification_number` SET TAGS ('dbx_business_glossary_term' = 'Certification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `certification_scope` SET TAGS ('dbx_business_glossary_term' = 'Certification Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `certification_status` SET TAGS ('dbx_business_glossary_term' = 'Certification Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `certification_status` SET TAGS ('dbx_value_regex' = 'Active|Expired|Suspended|Pending Renewal|Revoked|Under Review');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `certification_type` SET TAGS ('dbx_business_glossary_term' = 'Certification Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `compliance_standard` SET TAGS ('dbx_business_glossary_term' = 'Compliance Standard');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `is_mandatory` SET TAGS ('dbx_business_glossary_term' = 'Is Mandatory');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `is_verified` SET TAGS ('dbx_business_glossary_term' = 'Is Verified');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `issuing_body` SET TAGS ('dbx_business_glossary_term' = 'Issuing Body');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `issuing_body_country_code` SET TAGS ('dbx_business_glossary_term' = 'Issuing Body Country Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `issuing_body_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Last Audit Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `modified_by` SET TAGS ('dbx_business_glossary_term' = 'Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `next_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Next Audit Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `notification_sent_date` SET TAGS ('dbx_business_glossary_term' = 'Notification Sent Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `reinstatement_date` SET TAGS ('dbx_business_glossary_term' = 'Reinstatement Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `renewal_due_date` SET TAGS ('dbx_business_glossary_term' = 'Renewal Due Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `renewal_initiated_date` SET TAGS ('dbx_business_glossary_term' = 'Renewal Initiated Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `renewal_status` SET TAGS ('dbx_business_glossary_term' = 'Renewal Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `renewal_status` SET TAGS ('dbx_value_regex' = 'Not Required|Pending|In Progress|Completed|Overdue');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Risk Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `risk_rating` SET TAGS ('dbx_value_regex' = 'Low|Medium|High|Critical');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `suspension_date` SET TAGS ('dbx_business_glossary_term' = 'Suspension Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `suspension_reason` SET TAGS ('dbx_business_glossary_term' = 'Suspension Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `vendor_qualification_impact` SET TAGS ('dbx_business_glossary_term' = 'Vendor Qualification Impact');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `vendor_qualification_impact` SET TAGS ('dbx_value_regex' = 'Qualified|Conditionally Qualified|Disqualified|Under Review');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `verification_date` SET TAGS ('dbx_business_glossary_term' = 'Verification Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `verified_by` SET TAGS ('dbx_business_glossary_term' = 'Verified By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_certification` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` SET TAGS ('dbx_subdomain' = 'requisition_sourcing');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `tender_id` SET TAGS ('dbx_business_glossary_term' = 'Tender Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Contract Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Awarded Vendor Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `material_group_id` SET TAGS ('dbx_business_glossary_term' = 'Material Group Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Created By User Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `quaternary_tender_modified_by_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By User Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `quaternary_tender_modified_by_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `quaternary_tender_modified_by_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `tertiary_tender_manager_user_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Tender Manager User Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `tertiary_tender_manager_user_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `tertiary_tender_manager_user_employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|conditional');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `approval_workflow_code` SET TAGS ('dbx_business_glossary_term' = 'Approval Workflow Identifier');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `award_date` SET TAGS ('dbx_business_glossary_term' = 'Tender Award Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `awarded_value` SET TAGS ('dbx_business_glossary_term' = 'Awarded Tender Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `awarded_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `bid_bond_amount` SET TAGS ('dbx_business_glossary_term' = 'Bid Bond Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `bid_bond_required` SET TAGS ('dbx_business_glossary_term' = 'Bid Bond Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `budget_allocation_code` SET TAGS ('dbx_business_glossary_term' = 'Budget Allocation Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `closing_date` SET TAGS ('dbx_business_glossary_term' = 'Tender Closing Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `closing_time` SET TAGS ('dbx_business_glossary_term' = 'Tender Closing Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `commodity_scope` SET TAGS ('dbx_business_glossary_term' = 'Commodity Scope');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `contract_duration_months` SET TAGS ('dbx_business_glossary_term' = 'Contract Duration in Months');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{10}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `delivery_location` SET TAGS ('dbx_business_glossary_term' = 'Delivery Location');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `tender_description` SET TAGS ('dbx_business_glossary_term' = 'Tender Description');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `estimated_value` SET TAGS ('dbx_business_glossary_term' = 'Estimated Tender Value');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `estimated_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `evaluation_criteria` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Criteria');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `evaluation_method` SET TAGS ('dbx_business_glossary_term' = 'Evaluation Method');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `evaluation_method` SET TAGS ('dbx_value_regex' = 'lowest_price|best_value|technical_merit|two_envelope|quality_cost');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'International Commercial Terms (Incoterms)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `issue_date` SET TAGS ('dbx_business_glossary_term' = 'Tender Issue Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `manager_name` SET TAGS ('dbx_business_glossary_term' = 'Tender Manager Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `number_of_bids_evaluated` SET TAGS ('dbx_business_glossary_term' = 'Number of Bids Evaluated');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `number_of_bids_received` SET TAGS ('dbx_business_glossary_term' = 'Number of Bids Received');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `outcome` SET TAGS ('dbx_business_glossary_term' = 'Tender Outcome');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `outcome` SET TAGS ('dbx_value_regex' = 'awarded|no_award|cancelled|withdrawn|under_review');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `performance_bond_required` SET TAGS ('dbx_business_glossary_term' = 'Performance Bond Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `plant_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `pre_qualification_required` SET TAGS ('dbx_business_glossary_term' = 'Pre-Qualification Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `publication_channel` SET TAGS ('dbx_business_glossary_term' = 'Publication Channel');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `remarks` SET TAGS ('dbx_business_glossary_term' = 'Tender Remarks');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `tender_number` SET TAGS ('dbx_business_glossary_term' = 'Tender Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `tender_number` SET TAGS ('dbx_value_regex' = '^TND-[0-9]{8}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `tender_status` SET TAGS ('dbx_business_glossary_term' = 'Tender Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `tender_type` SET TAGS ('dbx_business_glossary_term' = 'Tender Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `tender_type` SET TAGS ('dbx_value_regex' = 'open|restricted|negotiated|eoi|framework|single_source');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Tender Title');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` SET TAGS ('dbx_subdomain' = 'catalogue_planning');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `purchasing_info_id` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Information Record ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `material_master_id` SET TAGS ('dbx_business_glossary_term' = 'Material ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `acknowledgement_required` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Acknowledgement Required');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `deletion_indicator` SET TAGS ('dbx_business_glossary_term' = 'Deletion Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `goods_receipt_processing_time_days` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt (GR) Processing Time (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'International Commercial Terms (Incoterms)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `incoterms_location` SET TAGS ('dbx_business_glossary_term' = 'Incoterms Location');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `info_record_category` SET TAGS ('dbx_business_glossary_term' = 'Information Record Category');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `info_record_category` SET TAGS ('dbx_value_regex' = 'standard|subcontracting|consignment|pipeline');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `info_record_number` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Information Record Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `info_record_status` SET TAGS ('dbx_business_glossary_term' = 'Information Record Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `info_record_status` SET TAGS ('dbx_value_regex' = 'active|inactive|blocked|pending_approval');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `last_purchase_order_date` SET TAGS ('dbx_business_glossary_term' = 'Last Purchase Order (PO) Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `last_purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Last Purchase Order (PO) Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `last_purchase_price` SET TAGS ('dbx_business_glossary_term' = 'Last Purchase Price');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `manufacturer_name` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `manufacturer_part_number` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Part Number (MPN)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `maximum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Order Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Price');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `order_quantity_multiple` SET TAGS ('dbx_business_glossary_term' = 'Order Quantity Multiple');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `over_delivery_tolerance_percent` SET TAGS ('dbx_business_glossary_term' = 'Over-Delivery Tolerance Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `planned_delivery_time_days` SET TAGS ('dbx_business_glossary_term' = 'Planned Delivery Time (Days)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `price_change_indicator` SET TAGS ('dbx_business_glossary_term' = 'Price Change Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `price_date` SET TAGS ('dbx_business_glossary_term' = 'Price Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `price_unit` SET TAGS ('dbx_business_glossary_term' = 'Price Unit');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `quality_inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Required');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `reminder_days` SET TAGS ('dbx_business_glossary_term' = 'Reminder Days');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `standard_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Standard Order Quantity');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `under_delivery_tolerance_percent` SET TAGS ('dbx_business_glossary_term' = 'Under-Delivery Tolerance Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `unlimited_over_delivery_allowed` SET TAGS ('dbx_business_glossary_term' = 'Unlimited Over-Delivery Allowed');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchasing_info` ALTER COLUMN `vendor_material_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Material Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` SET TAGS ('dbx_association_edges' = 'procurement.vendor,masterdata.service_code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `vendor_service_rate_card_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Service Rate Card ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `service_code_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Service Rate Card - Service Code Id');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Service Rate Card - Vendor Id');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Last Modified By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `last_rate_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Rate Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `minimum_charge` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `minimum_charge` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `negotiated_rate` SET TAGS ('dbx_business_glossary_term' = 'Negotiated Rate');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `negotiated_rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `next_rate_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Rate Review Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `preferred_vendor_flag` SET TAGS ('dbx_business_glossary_term' = 'Preferred Vendor Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `rate_card_status` SET TAGS ('dbx_business_glossary_term' = 'Rate Card Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `rate_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Rate Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `sla_response_time_hours` SET TAGS ('dbx_business_glossary_term' = 'SLA Response Time Hours');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `volume_discount_tier` SET TAGS ('dbx_business_glossary_term' = 'Volume Discount Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `volume_discount_tier` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` SET TAGS ('dbx_subdomain' = 'supplier_management');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` SET TAGS ('dbx_association_edges' = 'procurement.vendor,masterdata.commodity_code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `vendor_commodity_approval_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Commodity Approval ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `commodity_code_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Commodity Approval - Commodity Code Id');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approved By User ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Commodity Approval - Vendor Id');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Expiry Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `certification_number` SET TAGS ('dbx_business_glossary_term' = 'Certification Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `last_supply_date` SET TAGS ('dbx_business_glossary_term' = 'Last Supply Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Approval Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `preferred_vendor_flag` SET TAGS ('dbx_business_glossary_term' = 'Preferred Vendor Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `quality_rating` SET TAGS ('dbx_business_glossary_term' = 'Quality Rating');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` SET TAGS ('dbx_subdomain' = 'catalogue_planning');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `procurement_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Plan ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `material_group_id` SET TAGS ('dbx_business_glossary_term' = 'Material Group ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `approval_threshold_tier` SET TAGS ('dbx_business_glossary_term' = 'Approval Threshold Tier');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `approval_threshold_tier` SET TAGS ('dbx_value_regex' = 'tier_1|tier_2|tier_3|tier_4|board_level');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `approval_workflow_code` SET TAGS ('dbx_business_glossary_term' = 'Approval Workflow ID');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `budget_code` SET TAGS ('dbx_business_glossary_term' = 'Budget Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `budget_commitment_amount` SET TAGS ('dbx_business_glossary_term' = 'Budget Commitment Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `capex_allocation_amount` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) Allocation Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `competitive_tender_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Competitive Tender Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `compliance_framework` SET TAGS ('dbx_business_glossary_term' = 'Compliance Framework');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `contract_management_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Contract Management Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `department_code` SET TAGS ('dbx_business_glossary_term' = 'Department Code');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `hazmat_procurement_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Materials (HAZMAT) Procurement Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `justification_notes` SET TAGS ('dbx_business_glossary_term' = 'Justification Notes');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `local_content_requirement_percentage` SET TAGS ('dbx_business_glossary_term' = 'Local Content Requirement Percentage');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Modified Timestamp');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `opex_allocation_amount` SET TAGS ('dbx_business_glossary_term' = 'Operational Expenditure (OPEX) Allocation Amount');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Plan Period End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Plan Period Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `plan_description` SET TAGS ('dbx_business_glossary_term' = 'Procurement Plan Description');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `plan_name` SET TAGS ('dbx_business_glossary_term' = 'Procurement Plan Name');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Procurement Plan Number');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_value_regex' = '^PP-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_business_glossary_term' = 'Procurement Plan Status');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `plan_status` SET TAGS ('dbx_value_regex' = 'draft|submitted|approved|active|closed|cancelled');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_business_glossary_term' = 'Procurement Plan Type');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `plan_type` SET TAGS ('dbx_value_regex' = 'annual|quarterly|project_specific|emergency|strategic');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `prepared_by` SET TAGS ('dbx_business_glossary_term' = 'Prepared By');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `purchasing_group` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Group');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `purchasing_organization` SET TAGS ('dbx_business_glossary_term' = 'Purchasing Organization');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `quality_inspection_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `risk_classification` SET TAGS ('dbx_business_glossary_term' = 'Risk Classification');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `risk_classification` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `source_system_key` SET TAGS ('dbx_business_glossary_term' = 'Source System Key');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Strategy');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `sourcing_strategy` SET TAGS ('dbx_value_regex' = 'open_market|preferred_vendor|competitive_tender|framework_agreement|single_source|consortium');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `strategic_sourcing_indicator` SET TAGS ('dbx_business_glossary_term' = 'Strategic Sourcing Indicator');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `supplier_consolidation_target_count` SET TAGS ('dbx_business_glossary_term' = 'Supplier Consolidation Target Count');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `sustainability_criteria_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Sustainability Criteria Required Flag');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `tender_schedule_end_date` SET TAGS ('dbx_business_glossary_term' = 'Tender Schedule End Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `tender_schedule_start_date` SET TAGS ('dbx_business_glossary_term' = 'Tender Schedule Start Date');
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`procurement_plan` ALTER COLUMN `total_planned_spend_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Planned Spend Amount');
