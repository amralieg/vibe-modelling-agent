-- Schema for Domain: supplier | Business:  | Version: v2_ecm
-- Generated on: 2026-07-12 13:53:26

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`supplier` COMMENT 'Authoritative source for supplier and vendor master data including contact information, contracts, compliance certifications, performance scorecards, chargebacks (vendor compliance penalties), RTV (Return to Vendor) processes, EDI integration, MOQ and lead time agreements, and VMI configurations. Manages supplier onboarding, qualification, risk assessment, and ongoing relationship management for national brands, private label manufacturers, and DSD vendors.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`vendor` (
    `vendor_id` BIGINT COMMENT 'Unique identifier for the vendor. Primary key for the vendor master record.',
    `contract_expiry_date` DATE COMMENT 'Expiration date of the current master supply agreement or contract with this vendor. Used for contract renewal planning and vendor relationship management.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this vendor master record was first created in the system. Used for audit trail and data lineage tracking.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code representing the vendors preferred currency for invoicing and payment (e.g., USD, EUR, GBP, CAD).. Valid values are `^[A-Z]{3}$`',
    `diversity_certification` STRING COMMENT 'Diversity certification status of the vendor for supplier diversity programs. MBE (Minority Business Enterprise), WBE (Women Business Enterprise), DBE (Disadvantaged Business Enterprise), VBE (Veteran Business Enterprise), LGBTBE (LGBT Business Enterprise), SDVOSB (Service-Disabled Veteran-Owned Small Business), or none if not certified. [ENUM-REF-CANDIDATE: mbe|wbe|dbe|vbe|lgbtbe|sdvosb|none — 7 candidates stripped; promote to reference product]',
    `duns_number` STRING COMMENT 'Nine-digit unique identifier assigned by Dun & Bradstreet to identify business entities globally. Used for vendor qualification, credit assessment, and supplier risk management.. Valid values are `^[0-9]{9}$`',
    `edi_capable_flag` BOOLEAN COMMENT 'Boolean indicator of whether the vendor supports EDI (Electronic Data Interchange) for automated exchange of purchase orders, advance ship notices, invoices, and other business documents. True indicates EDI capability is enabled.',
    `edi_identifier` STRING COMMENT 'Unique EDI identifier or interchange ID used to route electronic documents to this vendor in EDI transactions (e.g., ISA ID, GS1 GLN).',
    `fill_rate_pct` DECIMAL(18,2) COMMENT 'Vendor performance metric representing the percentage of ordered quantity that the vendor successfully delivers (order completion percentage). A fill rate of 100% indicates all ordered items were delivered in full.',
    `insurance_certificate_expiry_date` DATE COMMENT 'Expiration date of the vendors general liability and product liability insurance certificate. Used to ensure vendors maintain required insurance coverage as per contract terms.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this vendor master record was last updated or modified. Used for change tracking and data quality monitoring.',
    `last_purchase_order_date` DATE COMMENT 'Date of the most recent purchase order issued to this vendor. Used to identify inactive vendors and support vendor rationalization initiatives.',
    `lead_time_days` STRING COMMENT 'Standard lead time in days from purchase order placement to delivery at the distribution center or store. Used for replenishment planning and inventory management.',
    `modified_by_user` STRING COMMENT 'User ID or system identifier of the person or process that last modified this vendor record. Used for audit trail and accountability.',
    `moq_units` DECIMAL(18,2) COMMENT 'Minimum Order Quantity (MOQ) in units that must be ordered from this vendor per purchase order or per SKU (Stock Keeping Unit). Used in procurement planning and order optimization.',
    `vendor_name` STRING COMMENT 'The full legal name of the vendor or supplier as registered with governing authorities. Used for contracts, purchase orders, and legal documentation.',
    `on_time_delivery_rate_pct` DECIMAL(18,2) COMMENT 'Vendor performance metric representing the percentage of orders delivered on or before the requested delivery date. Used in vendor scorecards and supplier performance management.',
    `onboarding_date` DATE COMMENT 'Date when the vendor was officially onboarded and approved for transactions in the vendor master system. Represents the start of the vendor relationship.',
    `payment_method` STRING COMMENT 'Preferred method for remitting payment to the vendor. ACH (Automated Clearing House) for electronic bank transfers, wire transfer for same-day transfers, check for paper checks, EFT (Electronic Funds Transfer) for direct deposit, credit card for card-based payments, and virtual card for single-use card numbers.. Valid values are `ach|wire_transfer|check|eft|credit_card|virtual_card`',
    `payment_terms_code` STRING COMMENT 'Standard payment terms code defining the payment schedule and discount conditions for this vendor (e.g., Net 30, 2/10 Net 30, Net 60). Determines when payment is due and any early payment discounts available.',
    `primary_contact_email` STRING COMMENT 'Email address of the primary contact person for operational communication, order management, and issue resolution.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `primary_contact_name` STRING COMMENT 'Full name of the primary contact person at the vendor organization, typically the account manager or sales representative responsible for the business relationship.',
    `primary_contact_phone` STRING COMMENT 'Primary telephone number for the vendor contact person, including country code and extension if applicable.',
    `quality_acceptance_rate_pct` DECIMAL(18,2) COMMENT 'Vendor performance metric representing the percentage of received goods that pass quality inspection and are accepted into inventory without rejection or return. Used to monitor product quality and vendor compliance.',
    `remittance_email` STRING COMMENT 'Email address for sending payment remittance advice and electronic payment notifications to the vendors accounts receivable department.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `risk_rating` STRING COMMENT 'Overall risk assessment rating for the vendor based on financial stability, operational performance, compliance history, and supply chain risk factors. Low indicates minimal risk, medium indicates moderate risk requiring monitoring, high indicates elevated risk requiring mitigation plans, and critical indicates severe risk requiring immediate action or alternative sourcing.. Valid values are `low|medium|high|critical`',
    `sustainability_certified_flag` BOOLEAN COMMENT 'Boolean indicator of whether the vendor holds recognized sustainability or environmental certifications (e.g., ISO 14001, B Corp, Fair Trade, Rainforest Alliance). True indicates the vendor has sustainability credentials.',
    `tax_classification` STRING COMMENT 'Tax classification of the vendor for withholding and reporting purposes. W-9 US person indicates a domestic US entity, W-8 foreign entity indicates a non-US entity subject to withholding, exempt organization indicates tax-exempt status, and government entity indicates a governmental body.. Valid values are `w9_us_person|w8_foreign_entity|exempt_organization|government_entity`',
    `tax_identifier` STRING COMMENT 'The vendors tax identification number (TIN) or Employer Identification Number (EIN) used for tax reporting and compliance. Format varies by jurisdiction (e.g., EIN in USA, VAT number in EU).',
    `vendor_status` STRING COMMENT 'Current operational status of the vendor in the vendor lifecycle. Active vendors are approved for transactions, inactive vendors are not currently used but remain in the system, suspended vendors are temporarily blocked due to performance or compliance issues, pending approval vendors are undergoing onboarding qualification, blocked vendors cannot transact due to critical issues, and terminated vendors have ended their relationship with the business.. Valid values are `active|inactive|suspended|pending_approval|blocked|terminated`',
    `vendor_type` STRING COMMENT 'Classification of the vendor based on the type of goods or services provided. National brand manufacturers supply branded products, private label producers manufacture store-brand products, DSD (Direct Store Delivery) vendors deliver directly to stores bypassing distribution centers, 3PL (Third-Party Logistics) partners provide logistics and fulfillment services, service providers offer non-product services, and raw material suppliers provide ingredients or components for private label manufacturing.. Valid values are `national_brand|private_label|dsd_vendor|3pl_partner|service_provider|raw_material_supplier`',
    `vmi_enabled_flag` BOOLEAN COMMENT 'Boolean indicator of whether this vendor participates in Vendor Managed Inventory (VMI) programs where the vendor monitors inventory levels and initiates replenishment orders. True indicates VMI is active for this vendor.',
    CONSTRAINT pk_vendor PRIMARY KEY(`vendor_id`)
) COMMENT 'Master record for all suppliers and vendors including national brand manufacturers, private label producers, DSD vendors, and 3PL partners. Serves as the authoritative golden record for vendor identity, classification, tax identifiers (W-9/W-8), remittance details, business type, ownership structure, diversity certifications, DUNS number, and onboarding status. Contains embedded contact persons (account managers, EDI coordinators, compliance contacts, executive sponsors) with role types, communication preferences, and escalation paths. Contains embedded multi-address records (headquarters, remittance, ship-from, RTV addresses) with geo-coordinates, address validation status, and address type classification. Sourced from the customer master data system and SAP S/4HANA MM vendor master.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`vendor_contact` (
    `vendor_contact_id` BIGINT COMMENT 'Unique identifier for the vendor contact person. Primary key.',
    `vendor_id` BIGINT COMMENT 'Reference to the parent vendor organization this contact represents. Links to the vendor master record.',
    `address_line_1` STRING COMMENT 'First line of the business address for the vendor contacts office location. Typically includes street number and name.',
    `address_line_2` STRING COMMENT 'Second line of the business address for additional location details such as suite, floor, or building number.',
    `city` STRING COMMENT 'City or municipality where the vendor contacts office is located.',
    `contact_status` STRING COMMENT 'Current lifecycle status of the vendor contact. Inactive or terminated contacts should not receive communications.. Valid values are `active|inactive|on_leave|terminated`',
    `contact_type` STRING COMMENT 'The functional role or responsibility area of this contact within the vendor organization. Determines escalation paths and communication routing.. Valid values are `account_manager|edi_coordinator|compliance_contact|executive_sponsor|logistics_coordinator|quality_assurance`',
    `country_code` STRING COMMENT 'Three-letter ISO country code for the vendor contacts office location. [ENUM-REF-CANDIDATE: USA|CAN|MEX|GBR|DEU|FRA|CHN|JPN — 8 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this vendor contact record was first created in the system. Supports audit trail and data lineage.',
    `department` STRING COMMENT 'The department or business unit within the vendor organization where this contact works (e.g., Sales, Logistics, Quality Assurance, Finance).',
    `effective_end_date` DATE COMMENT 'The date when this vendor contact ceased to be active. Null for currently active contacts. Used for historical tracking and audit trails.',
    `effective_start_date` DATE COMMENT 'The date when this vendor contact became active and available for business communications. Supports temporal tracking of contact relationships.',
    `email_address` STRING COMMENT 'Primary business email address for the vendor contact. Used for official communications, purchase orders, and compliance notifications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `fax_number` STRING COMMENT 'Fax number for the vendor contact, if still used for formal document transmission.',
    `first_name` STRING COMMENT 'The given name of the vendor contact person.',
    `is_escalation_contact` BOOLEAN COMMENT 'Indicates whether this contact should be included in escalation workflows for critical issues such as compliance violations, quality failures, or delivery delays.',
    `is_primary_contact` BOOLEAN COMMENT 'Indicates whether this contact is the primary point of contact for the vendor. Used for default routing of communications and escalations.',
    `job_title` STRING COMMENT 'The official job title or position of the contact within the vendor organization (e.g., Account Manager, Supply Chain Director, Compliance Officer).',
    `language_preference` STRING COMMENT 'Preferred language for business communications with this contact. Uses ISO 639-2 three-letter language codes.. Valid values are `ENG|SPA|FRA|DEU|CHN|JPN`',
    `last_contact_date` DATE COMMENT 'The most recent date when this vendor contact was engaged in business communication. Used for relationship health monitoring and engagement tracking.',
    `last_name` STRING COMMENT 'The family name or surname of the vendor contact person.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this vendor contact record was most recently modified. Supports change tracking and audit compliance.',
    `middle_name` STRING COMMENT 'The middle name or initial of the vendor contact person, if applicable.',
    `mobile_number` STRING COMMENT 'Mobile phone number for the vendor contact. Used for urgent escalations and time-sensitive communications.',
    `notes` STRING COMMENT 'Free-form text field for additional information about the vendor contact, such as special instructions, preferences, or relationship history.',
    `office_location` STRING COMMENT 'The physical office location or site where this contact is based (e.g., headquarters, regional office, manufacturing plant).',
    `phone_number` STRING COMMENT 'Primary business phone number for the vendor contact. Includes country code and extension if applicable.',
    `postal_code` STRING COMMENT 'Postal or ZIP code for the vendor contacts office location.',
    `preferred_communication_channel` STRING COMMENT 'The contacts preferred method for receiving business communications. Supports personalized engagement and improved response rates.. Valid values are `email|phone|mobile|fax|edi|portal`',
    `state_province` STRING COMMENT 'State, province, or region where the vendor contacts office is located.',
    `time_zone` STRING COMMENT 'The time zone where the vendor contact is located. Used for scheduling meetings and understanding business hours. Format follows IANA Time Zone Database (e.g., America/New_York, Europe/London).',
    CONSTRAINT pk_vendor_contact PRIMARY KEY(`vendor_contact_id`)
) COMMENT 'Contact persons associated with a vendor including account managers, EDI coordinators, compliance contacts, and executive sponsors. Tracks name, title, role type, phone, email, preferred communication channel, and active status. Supports relationship management and escalation workflows.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`vendor_address` (
    `vendor_address_id` BIGINT COMMENT 'Unique identifier for the vendor address record. Primary key.',
    `vendor_id` BIGINT COMMENT 'Identifier of the vendor to whom this address belongs. Links to the vendor master record.',
    `address_line_1` STRING COMMENT 'Primary street address line including street number, street name, and building identifier. Organizational contact data classified as confidential.',
    `address_line_2` STRING COMMENT 'Secondary address line for suite, floor, department, or additional location details. Organizational contact data classified as confidential.',
    `address_line_3` STRING COMMENT 'Tertiary address line for complex addresses requiring additional location specification. Organizational contact data classified as confidential.',
    `address_name` STRING COMMENT 'Descriptive name or label for the address location (e.g., Main Distribution Center, Corporate HQ, Returns Processing Facility).',
    `address_status` STRING COMMENT 'Current lifecycle status of the address: active (in use), inactive (no longer used), pending_validation (awaiting verification), invalid (failed validation), temporary (short-term use).. Valid values are `active|inactive|pending_validation|invalid|temporary`',
    `address_type` STRING COMMENT 'Classification of the address purpose: headquarters (corporate office), remittance (payment processing), ship_from (origin for DSD or shipments), returns (RTV processing location), billing (invoice address), warehouse (distribution or storage facility).. Valid values are `headquarters|remittance|ship_from|returns|billing|warehouse`',
    `city` STRING COMMENT 'City or municipality name where the vendor address is located. Organizational contact data classified as confidential.',
    `country_code` STRING COMMENT 'Three-letter ISO country code identifying the country of the address (e.g., USA, CAN, MEX, GBR, DEU).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this address record was first created in the system. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `duns_number` STRING COMMENT 'Dun & Bradstreet DUNS number for the location, used for business identity verification, credit assessment, and supplier risk management. 9-digit numeric identifier.. Valid values are `^[0-9]{9}$`',
    `effective_end_date` DATE COMMENT 'Date when this address is no longer valid or was deactivated. Null indicates the address is currently active. Format: yyyy-MM-dd.',
    `effective_start_date` DATE COMMENT 'Date when this address became active and valid for use in procurement, logistics, and vendor transactions. Format: yyyy-MM-dd.',
    `email_address` STRING COMMENT 'Primary email contact for the address location, used for logistics coordination, RTV notifications, and operational communication. Organizational contact data classified as confidential.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `fax_number` STRING COMMENT 'Fax number for the address location, used for EDI transmission or document exchange with vendors. Organizational contact data classified as confidential.',
    `gln` STRING COMMENT 'GS1 Global Location Number uniquely identifying the physical location for EDI transactions, logistics routing, and supply chain integration. 13-digit numeric identifier.. Valid values are `^[0-9]{13}$`',
    `is_dsd_location` BOOLEAN COMMENT 'Flag indicating whether this address is a DSD (Direct Store Delivery) origin location where vendors deliver directly to retail stores bypassing distribution centers. True if DSD location, False otherwise.',
    `is_primary_address` BOOLEAN COMMENT 'Flag indicating whether this is the primary or default address for the vendor. True if primary, False otherwise.',
    `is_remittance_address` BOOLEAN COMMENT 'Flag indicating whether this address is used for payment remittance and accounts payable processing. True if remittance address, False otherwise.',
    `is_rtv_address` BOOLEAN COMMENT 'Flag indicating whether this address is designated for RTV (Return to Vendor) processing and merchandise returns. True if RTV address, False otherwise. Critical for reverse logistics and vendor compliance.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this address record was last modified or updated. Format: yyyy-MM-ddTHH:mm:ss.SSSXXX.',
    `latitude` DECIMAL(18,2) COMMENT 'Geographic latitude coordinate in decimal degrees for geospatial routing, logistics optimization, and mapping. Supports last-mile delivery planning and ship-from-store calculations.',
    `longitude` DECIMAL(18,2) COMMENT 'Geographic longitude coordinate in decimal degrees for geospatial routing, logistics optimization, and mapping. Supports last-mile delivery planning and ship-from-store calculations.',
    `notes` STRING COMMENT 'Free-text field for additional address-specific information, special delivery instructions, access requirements, or operational notes for logistics and procurement teams.',
    `phone_number` STRING COMMENT 'Primary contact phone number for the address location. Organizational contact data classified as confidential.',
    `postal_code` STRING COMMENT 'Postal or ZIP code for mail delivery routing. Format varies by country (e.g., 5-digit ZIP in USA, alphanumeric in Canada). Organizational contact data classified as confidential.',
    `state_province` STRING COMMENT 'State, province, or regional subdivision where the address is located. Organizational contact data classified as confidential.',
    `tax_jurisdiction_code` STRING COMMENT 'Tax jurisdiction or district code applicable to this address location, used for sales tax calculation, VAT compliance, and financial reporting.',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the address location (e.g., America/New_York, America/Chicago, Europe/London). Supports scheduling, delivery windows, and cross-timezone coordination.',
    `validation_date` DATE COMMENT 'Date when the address was last validated against postal authority or third-party address verification services. Format: yyyy-MM-dd.',
    `validation_source` STRING COMMENT 'Name of the service or system used to validate the address (e.g., USPS Address Validation API, Canada Post AddressComplete, UPS Address Validation, manual verification).',
    `validation_status` STRING COMMENT 'Indicates whether the address has been verified against postal authority databases or third-party address validation services: validated (confirmed accurate), unvalidated (not yet checked), failed (does not match postal records), partial (some fields validated).. Valid values are `validated|unvalidated|failed|partial`',
    CONSTRAINT pk_vendor_address PRIMARY KEY(`vendor_address_id`)
) COMMENT 'Physical and mailing addresses for vendors including headquarters, remittance, ship-from, and returns (RTV) addresses. Tracks address type, street, city, state, postal code, country, geo-coordinates, and validation status. Supports procurement, logistics routing, and RTV processing.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` (
    `vendor_contract_id` BIGINT COMMENT 'Unique identifier for the vendor contract. Primary key for the vendor contract entity.',
    `buyer_id` BIGINT COMMENT 'Foreign key linking to merchandising.buyer. Business justification: Vendor contracts are negotiated, approved, and managed by the buyer responsible for that vendor relationship. Contract approval workflows route to the assigned buyer, and buyers are accountable for co',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Contract management requires tracking which retail associate has signing authority for legal compliance, delegation of authority verification, and audit trails. Replaces denormalized signatory_name/ti',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Retail procurement validates every PO against active contract terms (pricing, payment terms, MOQ, lead time). Buyers and AP teams enforce contract compliance per PO; audit trails require PO-to-contrac',
    `vendor_id` BIGINT COMMENT 'Identifier of the supplier or vendor party to this contract. Links to the vendor master record.',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the contract automatically renews at expiration. True if the contract extends for another term unless either party provides termination notice. False if the contract expires without action.',
    `chargeback_terms` STRING COMMENT 'Description of vendor compliance penalties and chargeback conditions. Defines scenarios where the buyer may deduct fees from vendor payments for non-compliance (late delivery, incorrect labeling, missing ASN, pallet configuration errors).',
    `compliance_certifications_required` STRING COMMENT 'List of regulatory and industry certifications the vendor must maintain to fulfill this contract. Examples include FDA registration for food suppliers, CPSC compliance for consumer products, organic certifications, fair trade certifications, and safety standards.',
    `contract_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the contract value and payment terms. All financial terms in this contract are denominated in this currency.. Valid values are `^[A-Z]{3}$`',
    `contract_document_url` STRING COMMENT 'Uniform Resource Locator pointing to the digitally stored contract document. Links to the document management system or secure file repository where the full contract PDF or scanned image is stored.',
    `contract_number` STRING COMMENT 'Externally visible business identifier for the vendor contract. Used in procurement documents, purchase orders, and vendor communications.',
    `contract_status` STRING COMMENT 'Current lifecycle state of the vendor contract. Draft contracts are under negotiation. Pending approval contracts await internal sign-off. Active contracts are in force. Suspended contracts are temporarily paused. Terminated contracts are ended before expiry. Expired contracts have passed their end date. Renewed contracts have been extended. [ENUM-REF-CANDIDATE: draft|pending_approval|active|suspended|terminated|expired|renewed — 7 candidates stripped; promote to reference product]',
    `contract_type` STRING COMMENT 'Classification of the vendor contract. National brand contracts cover branded merchandise from manufacturers. Private label contracts govern store-brand product manufacturing. DSD (Direct Store Delivery) contracts define vendor-managed delivery terms. Master service agreements cover ongoing services. Blanket orders establish terms for recurring purchases. Framework agreements set umbrella terms for multiple purchase orders.. Valid values are `national_brand|private_label|dsd|master_service_agreement|blanket_order|framework_agreement`',
    `contract_value_amount` DECIMAL(18,2) COMMENT 'Total monetary value committed under this vendor contract. Represents the aggregate purchase commitment or spending cap over the contract term. Used for budget planning and vendor performance tracking.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this vendor contract record was first created in the system. Used for audit trail and data lineage tracking.',
    `discount_percentage` DECIMAL(18,2) COMMENT 'Standard discount rate applied to purchases under this contract. Expressed as a percentage off list price. Used for volume discounts, early payment discounts, or negotiated pricing agreements.',
    `edi_enabled_flag` BOOLEAN COMMENT 'Indicates whether Electronic Data Interchange is enabled for transactions under this contract. True if purchase orders, invoices, and shipping notices are exchanged via EDI. False for manual or email-based document exchange.',
    `edi_identifier` STRING COMMENT 'Vendor EDI interchange identifier corresponding to the EDI qualifier. Used in EDI message headers to identify the sender and receiver.',
    `edi_qualifier` STRING COMMENT 'EDI interchange identifier qualifier for the vendor. Examples include 01 (DUNS number), 12 (phone number), 14 (UPC), ZZ (mutually defined). Used to route EDI messages to the correct vendor system.',
    `effective_end_date` DATE COMMENT 'Date when the vendor contract terms expire. Nullable for open-ended contracts. Procurement transactions must occur before this date unless the contract is renewed.',
    `effective_start_date` DATE COMMENT 'Date when the vendor contract terms become binding and enforceable. Procurement transactions referencing this contract must occur on or after this date.',
    `exclusivity_flag` BOOLEAN COMMENT 'Indicates whether this contract grants the vendor exclusive rights to supply specific products or categories. True if the buyer commits to purchasing exclusively from this vendor for the covered scope. False for non-exclusive agreements.',
    `exclusivity_scope` STRING COMMENT 'Description of the product categories, geographic regions, or channels covered by the exclusivity clause. Applicable only when exclusivity_flag is true. Defines the boundaries of the exclusive supply arrangement.',
    `incoterms_code` STRING COMMENT 'International Commercial Terms code defining the division of costs and risks between buyer and seller. EXW (Ex Works) - buyer collects from vendor premises. FOB (Free On Board) - vendor delivers to shipping vessel. DDP (Delivered Duty Paid) - vendor delivers to buyer location with all duties paid. [ENUM-REF-CANDIDATE: EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF — 11 candidates stripped; promote to reference product]',
    `insurance_requirements` STRING COMMENT 'Minimum insurance coverage the vendor must carry to fulfill this contract. Typically includes general liability, product liability, and cargo insurance with specified coverage limits.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this vendor contract record was most recently modified. Used for audit trail, change tracking, and data synchronization.',
    `lead_time_days` STRING COMMENT 'Standard number of calendar days from purchase order submission to delivery at the receiving location. Used for replenishment planning, inventory forecasting, and order scheduling.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum order quantity required per purchase order under this contract. Vendor will not accept orders below this threshold. Used for production planning and logistics optimization.',
    `moq_unit_of_measure` STRING COMMENT 'Unit of measure for the minimum order quantity. Examples include EA (each), CS (case), PLT (pallet), KG (kilogram), LB (pound). Must align with vendor catalog and purchase order units.',
    `notes` STRING COMMENT 'Free-text field for additional contract details, special terms, negotiation history, or operational notes. Used by procurement teams to capture context not covered by structured fields.',
    `payment_method` STRING COMMENT 'Preferred payment instrument for settling invoices under this contract. ACH (Automated Clearing House) for electronic bank transfers. Wire transfer for same-day settlement. Check for paper-based payment. EDI (Electronic Data Interchange) payment for automated remittance. Credit card for small purchases. Letter of credit for international trade.. Valid values are `ach|wire_transfer|check|edi_payment|credit_card|letter_of_credit`',
    `payment_terms_code` STRING COMMENT 'Standard payment terms code defining the due date calculation and discount structure. Examples include Net 30, Net 60, 2/10 Net 30 (2% discount if paid within 10 days, otherwise net 30 days).',
    `quality_assurance_terms` STRING COMMENT 'Quality standards and inspection requirements for goods supplied under this contract. Defines acceptable quality levels, sampling procedures, defect rates, and vendor quality certifications required.',
    `receiving_location_code` STRING COMMENT 'Buyer distribution center, warehouse, or store location designated to receive shipments under this contract. Used for routing purchase orders and coordinating inbound logistics.',
    `renewal_term_months` STRING COMMENT 'Duration in months for each automatic renewal period. Applicable only when auto_renewal_flag is true. Contract extends by this duration at each renewal.',
    `return_to_vendor_policy` STRING COMMENT 'Terms governing the return of defective, damaged, or unsold merchandise to the vendor. Defines RTV authorization process, restocking fees, return shipping responsibility, and credit issuance timeline.',
    `shipping_point` STRING COMMENT 'Vendor facility or distribution center from which goods are shipped under this contract. Used for logistics planning, freight cost calculation, and delivery time estimation.',
    `signature_date` DATE COMMENT 'Date when the contract was signed by the authorized buyer representative. Used for contract validity verification and audit trail.',
    `termination_notice_days` STRING COMMENT 'Number of calendar days advance notice required to terminate the contract. Either party must provide written notice this many days before the desired termination date.',
    `vendor_signatory_name` STRING COMMENT 'Full name of the authorized representative who signed the contract on behalf of the vendor organization. Used for contract validation and audit trail.',
    `vendor_signatory_title` STRING COMMENT 'Job title or role of the vendor authorized signatory. Examples include CEO, VP Sales, Director of Business Development. Used to verify vendor signing authority.',
    `vendor_signature_date` DATE COMMENT 'Date when the contract was signed by the authorized vendor representative. Used for contract validity verification and audit trail.',
    `vmi_enabled_flag` BOOLEAN COMMENT 'Indicates whether Vendor Managed Inventory is enabled under this contract. True if the vendor monitors buyer inventory levels and automatically replenishes stock. False for buyer-managed replenishment.',
    CONSTRAINT pk_vendor_contract PRIMARY KEY(`vendor_contract_id`)
) COMMENT 'Supplier trading agreements and master vendor contracts including terms and conditions, payment terms, discount structures, exclusivity clauses, private label agreements, and contract validity periods. Tracks contract type (national brand, private label, DSD), effective and expiry dates, auto-renewal flags, and signatory details. Sourced from SAP S/4HANA SD/MM contract management.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`chargeback` (
    `chargeback_id` BIGINT COMMENT 'Unique identifier for the vendor compliance chargeback penalty record.',
    `ap_invoice_id` BIGINT COMMENT 'Reference to the AP invoice from which the chargeback penalty was deducted, if the recovery method was AP deduction.',
    `asn_id` BIGINT COMMENT 'Reference to the ASN document related to the shipment that violated compliance rules, if applicable.',
    `buying_order_id` BIGINT COMMENT 'Foreign key linking to merchandising.buying_order. Business justification: Chargebacks reference original buying orders when vendors violate compliance terms on specific merchandise purchases. Compliance teams trace routing guide violations, ASN errors, and quality issues ba',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Vendor compliance chargebacks are operational expenses that must be allocated to cost centers for vendor performance cost analysis, budget tracking, and supply chain expense management reporting.',
    `dc_facility_id` BIGINT COMMENT 'Reference to the distribution center or receiving facility where the compliance violation was detected.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Chargebacks post to specific GL accounts (typically vendor compliance expense or freight recovery accounts) for financial statement preparation, P&L reporting, and audit compliance in retail supply ch',
    `goods_receipt_id` BIGINT COMMENT 'Foreign key linking to inventory.goods_receipt. Business justification: Chargebacks for receipt discrepancies (short shipments, damaged goods, labeling violations) require direct link to the specific goods_receipt event for validation, dispute resolution, and vendor score',
    `purchase_order_id` BIGINT COMMENT 'Reference to the purchase order associated with the compliance violation that triggered this chargeback.',
    `rma_id` BIGINT COMMENT 'Foreign key linking to returns.rma. Business justification: Vendor chargebacks often stem from customer returns (damaged/defective goods). AP teams reconcile chargebacks against originating RMAs to validate penalty legitimacy and negotiate vendor disputes. Ena',
    `routing_guide_id` BIGINT COMMENT 'Reference to the specific routing guide rule or compliance policy that was violated, enabling traceability to the governing standard.',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Chargebacks for quality, compliance, or labeling violations must identify affected SKUs. Business process: chargeback dispute resolution, root cause analysis, vendor scorecard impact assessment, and f',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: Chargebacks enforce contract compliance by penalizing vendors for violations. Linking to vendor_contract enables retrieving penalty schedules, dispute resolution procedures, and recovery methods defin',
    `vendor_id` BIGINT COMMENT 'Reference to the supplier or vendor against whom this chargeback penalty is issued.',
    `location_id` BIGINT COMMENT 'Foreign key linking to store.store_location. Business justification: Chargebacks for routing guide violations, labeling errors, or receiving discrepancies originate at specific receiving locations (stores or DCs). Tracking the violation location supports root cause ana',
    `affected_units` STRING COMMENT 'The number of units (SKUs, cartons, or pallets) impacted by the compliance violation.',
    `approval_date` DATE COMMENT 'The date on which the chargeback was formally approved for issuance.',
    `approved_by` STRING COMMENT 'User ID of the procurement or compliance manager who approved the chargeback for issuance to the vendor.',
    `chargeback_number` STRING COMMENT 'Externally visible business identifier for the chargeback penalty, used in vendor communications and dispute resolution.',
    `chargeback_status` STRING COMMENT 'Current lifecycle state of the chargeback penalty in the dispute and recovery workflow. [ENUM-REF-CANDIDATE: pending|issued|disputed|under_review|approved|rejected|paid|written_off|cancelled — 9 candidates stripped; promote to reference product]',
    `chargeback_type` STRING COMMENT 'High-level category of the compliance violation that triggered the chargeback penalty. [ENUM-REF-CANDIDATE: routing_guide_violation|labeling_non_compliance|edi_failure|late_shipment|fill_rate_shortfall|asn_error|packaging_defect|quality_defect|documentation_error|other — 10 candidates stripped; promote to reference product]',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this chargeback record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the penalty amount.. Valid values are `USD|CAD|EUR|GBP|MXN|JPY`',
    `debit_memo_number` STRING COMMENT 'The external document number of the debit memo issued to the vendor for the chargeback penalty, if applicable.',
    `detection_date` DATE COMMENT 'The date on which the compliance violation was formally identified and logged in the system, which may differ from the violation date.',
    `dispute_date` DATE COMMENT 'The date on which the vendor formally disputed the chargeback penalty.',
    `dispute_reason` STRING COMMENT 'Free-text explanation provided by the vendor for disputing the chargeback, including supporting evidence references.',
    `dispute_status` STRING COMMENT 'Indicates whether the vendor has disputed the chargeback and the current state of the dispute resolution process.. Valid values are `not_disputed|disputed|under_investigation|resolved_vendor_favor|resolved_retailer_favor`',
    `is_repeat_violation` BOOLEAN COMMENT 'Flag indicating whether this chargeback represents a repeat violation of the same compliance rule by the vendor within a defined time window.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this chargeback record was most recently modified.',
    `notes` STRING COMMENT 'Free-text field for additional context, supporting documentation references, or special handling instructions related to the chargeback.',
    `notification_method` STRING COMMENT 'The communication channel used to notify the vendor of the chargeback penalty.. Valid values are `vendor_portal|edi|email|fax|mail`',
    `notification_sent_date` DATE COMMENT 'The date on which the chargeback notification was sent to the vendor through the vendor portal or EDI channel.',
    `penalty_amount` DECIMAL(18,2) COMMENT 'The monetary value of the chargeback penalty assessed against the vendor for the compliance violation.',
    `penalty_calculation_method` STRING COMMENT 'The method used to calculate the chargeback penalty amount, such as a fixed flat fee or a percentage of the order value.. Valid values are `flat_fee|percentage_of_order|per_unit|per_carton|per_pallet|tiered`',
    `penalty_percentage` DECIMAL(18,2) COMMENT 'The percentage rate applied to the order or shipment value when the penalty calculation method is percentage-based.',
    `previous_violation_count` STRING COMMENT 'The number of prior chargebacks issued to this vendor for the same violation category within the trailing 12-month period.',
    `recovery_date` DATE COMMENT 'The date on which the chargeback penalty amount was successfully recovered from the vendor through the specified recovery method.',
    `recovery_method` STRING COMMENT 'The mechanism used to recover the chargeback penalty amount from the vendor, such as accounts payable deduction or separate debit memo.. Valid values are `ap_deduction|debit_memo|credit_memo|offset_future_payment|written_off`',
    `resolution_date` DATE COMMENT 'The date on which the chargeback dispute was resolved and a final decision was made.',
    `resolution_notes` STRING COMMENT 'Internal notes documenting the outcome of the dispute resolution process, including any adjustments or waivers granted.',
    `vendor_scorecard_impact` DECIMAL(18,2) COMMENT 'The negative impact score applied to the vendors performance scorecard as a result of this chargeback, used in vendor relationship management and future sourcing decisions.',
    `violation_category` STRING COMMENT 'Detailed classification of the specific compliance rule or requirement that was violated, such as GS1-128 labeling failure, RFID tag missing, or incorrect pallet configuration.',
    `violation_date` DATE COMMENT 'The date on which the compliance violation occurred or was detected by the receiving facility or quality control process.',
    `created_by` STRING COMMENT 'User ID or system identifier of the person or automated process that created the chargeback record.',
    CONSTRAINT pk_chargeback PRIMARY KEY(`chargeback_id`)
) COMMENT 'Vendor compliance penalty records issued to suppliers for violations of routing guides, labeling requirements (GS1-128, RFID/EPC), EDI non-compliance, late shipments, fill rate shortfalls, ASN failures, and packaging defects. Tracks chargeback type, violation category, violation date, penalty amount (flat fee or percentage), dispute status, resolution date, recovery method (AP deduction or separate debit memo), and linkage to the originating routing guide rule. Critical for vendor compliance enforcement, cost recovery, and feeds vendor scorecard KPIs. Supports automated penalty calculation and vendor portal notification workflows.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`rtv_request` (
    `rtv_request_id` BIGINT COMMENT 'Primary key for rtv_request',
    `buying_order_id` BIGINT COMMENT 'Foreign key linking to merchandising.buying_order. Business justification: RTV requests reference the original buying order that authorized the merchandise purchase being returned. Receiving teams and AP need this link to reconcile vendor credits against original purchase te',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Return-to-vendor transactions impact inventory shrink and vendor quality costs that must be allocated to cost centers for operational expense tracking, budget variance analysis, and supply chain cost',
    `location_id` BIGINT COMMENT 'Identifier of the vendor facility or location where the returned merchandise is to be delivered.',
    `environmental_event_id` BIGINT COMMENT 'Foreign key linking to compliance.environmental_event. Business justification: RTVs for hazmat, expired chemicals, recalled items, or damaged goods requiring special disposal trigger environmental event logging for EPA manifest tracking, waste hauler documentation, and regulator',
    `goods_receipt_id` BIGINT COMMENT 'Foreign key linking to inventory.goods_receipt. Business justification: RTV requests originate from defective or non-conforming goods identified at receipt. Linking to goods_receipt enables root cause analysis, quality trend tracking, and automated RMA generation tied to',
    `origin_location_id` BIGINT COMMENT 'Identifier of the retailer location (store, distribution center, or warehouse) from which the merchandise is being returned.',
    `rma_id` BIGINT COMMENT 'Foreign key linking to returns.rma. Business justification: Supplier RTVs are frequently triggered by customer returns. Buyers analyze which customer return reasons drive vendor RTVs to negotiate better contract terms and identify systemic quality issues. Enab',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Return-to-vendor workflows require tracking which retail associate initiated the request for accountability, performance metrics, and training needs analysis. Replaces denormalized requestor_name/emai',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Return-to-vendor requests must specify which SKUs are being returned for defects, damage, or overstock. Business process: RTV authorization, credit memo generation, inventory disposition, quality trac',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: RTV requests reference originating PO for credit memo reconciliation, chargeback calculation, and vendor dispute resolution. AP teams match RTV claims to PO invoice for cost recovery. Real-world retai',
    `vendor_contact_id` BIGINT COMMENT 'Identifier of the specific vendor contact person handling this RTV request on the supplier side.',
    `vendor_id` BIGINT COMMENT 'Identifier of the supplier or vendor to whom the merchandise is being returned. Links to the vendor master record.',
    `approver_name` STRING COMMENT 'The name of the retailer manager or authorized personnel who approved the RTV request before submission to the vendor.',
    `authorization_date` DATE COMMENT 'The date when the vendor approved and authorized the return, issuing the RMA number.',
    `carrier_name` STRING COMMENT 'The name of the logistics carrier or third-party logistics (3PL) provider used to ship the returned merchandise.',
    `chargeback_amount` DECIMAL(18,2) COMMENT 'The monetary penalty amount assessed against the vendor for non-compliance or quality failures that triggered the return. Part of vendor performance management.',
    `chargeback_reason` STRING COMMENT 'Explanation of the vendor compliance violation or quality issue that resulted in the chargeback penalty.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this RTV request record was first created in the system. Used for audit trail and data lineage.',
    `credit_date` DATE COMMENT 'The date when the vendor issued credit or replacement for the returned merchandise.',
    `credit_memo_number` STRING COMMENT 'The credit memo number issued by the vendor to document the financial credit provided for the returned merchandise.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the return value (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `disposition_method` STRING COMMENT 'The method by which the vendor will handle the returned merchandise and compensate the retailer (e.g., issue credit, send replacement, authorize destruction).. Valid values are `credit|replacement|repair|destroy|donate|salvage`',
    `edi_control_number` STRING COMMENT 'The unique control number assigned to the EDI transmission of this RTV request for tracking and reconciliation purposes.',
    `edi_transaction_set` STRING COMMENT 'The EDI transaction set identifier used for electronic communication of this RTV request with the vendor (e.g., EDI 180 Return Merchandise Authorization).',
    `freight_cost` DECIMAL(18,2) COMMENT 'The actual or estimated cost of freight for shipping the returned merchandise back to the vendor.',
    `freight_responsibility` STRING COMMENT 'Indicates which party (vendor or retailer) is responsible for paying the freight costs associated with returning the merchandise.. Valid values are `vendor|retailer|shared|prepaid_and_add|collect`',
    `inspection_result` STRING COMMENT 'The outcome of the vendors quality inspection of the returned merchandise, determining eligibility for credit or replacement.. Valid values are `passed|failed|partial|pending|not_applicable`',
    `invoice_number` STRING COMMENT 'The vendor invoice number associated with the original purchase of the merchandise being returned. Used for credit memo reconciliation.',
    `is_recall_related` BOOLEAN COMMENT 'Boolean flag indicating whether this RTV request is related to a product recall mandated by regulatory authorities or the manufacturer.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this RTV request record was most recently modified. Used for audit trail and change tracking.',
    `notes` STRING COMMENT 'Free-text field for additional comments, special instructions, or contextual information related to the RTV request.',
    `quality_inspection_required` BOOLEAN COMMENT 'Boolean flag indicating whether the vendor requires a quality inspection of the returned merchandise before issuing credit or replacement.',
    `recall_number` STRING COMMENT 'The official recall identification number issued by the regulatory body or manufacturer if this RTV is recall-related.',
    `received_date` DATE COMMENT 'The date when the vendor confirmed receipt of the returned merchandise at their facility.',
    `request_date` DATE COMMENT 'The date when the RTV request was initiated by the retailer. This is the principal business event timestamp for the transaction.',
    `return_reason_code` STRING COMMENT 'Standardized code indicating the business reason for returning the merchandise to the vendor. Used for vendor performance tracking and chargeback determination. [ENUM-REF-CANDIDATE: defective|damaged|overstock|seasonal_clearance|recall|quality_failure|expired|wrong_item|obsolete|vendor_error — 10 candidates stripped; promote to reference product]',
    `return_reason_description` STRING COMMENT 'Detailed free-text explanation of the reason for the return, providing additional context beyond the standardized reason code.',
    `rma_number` STRING COMMENT 'The authorization number issued by the vendor permitting the return of merchandise. This is the externally-known business identifier for the RTV transaction.. Valid values are `^[A-Z0-9]{8,20}$`',
    `rtv_status` STRING COMMENT 'Current lifecycle status of the RTV request indicating its position in the return workflow from draft through final credit or closure. [ENUM-REF-CANDIDATE: draft|submitted|approved|rejected|in_transit|received|credited|closed|cancelled — 9 candidates stripped; promote to reference product]',
    `ship_date` DATE COMMENT 'The date when the returned merchandise was shipped back to the vendor from the retailers location.',
    `total_return_quantity` DECIMAL(18,2) COMMENT 'The total quantity of units being returned to the vendor across all SKUs in this RTV request, measured in the base unit of measure.',
    `total_return_value` DECIMAL(18,2) COMMENT 'The total monetary value of the merchandise being returned, calculated at cost basis. Represents the expected credit or reimbursement amount.',
    `tracking_number` STRING COMMENT 'The tracking number provided by the carrier for monitoring the shipment of returned merchandise in transit.',
    CONSTRAINT pk_rtv_request PRIMARY KEY(`rtv_request_id`)
) COMMENT 'Return to Vendor (RTV) requests authorizing the return of merchandise to suppliers due to defects, overstock, seasonal clearance, product recalls, or quality failures. Tracks RMA number, return reason code, SKU and quantity, return authorization date, disposition method (credit, replacement, destroy), freight responsibility, and RTV status. Sourced from the case management system and SAP MM.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` (
    `vendor_scorecard_id` BIGINT COMMENT 'Unique identifier for the vendor scorecard record. Primary key. Role: TRANSACTION_HEADER (scorecard is a periodic performance evaluation event).',
    `audit_event_id` BIGINT COMMENT 'Foreign key linking to compliance.audit_event. Business justification: Vendor scorecards incorporate compliance audit results (food safety audits, labor practice audits, quality system audits) as key performance metrics. Retail supplier management requires linking audit',
    `buyer_id` BIGINT COMMENT 'Foreign key linking to merchandising.buyer. Business justification: Vendor scorecards are reviewed and acted upon by the buyer managing that vendor relationship. Buyer performance evaluations, vendor selection decisions, and contract renewal workflows depend on scorec',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Vendor performance evaluation in retail requires tracking which associate conducted the scorecard assessment for accountability, bias detection, and evaluator performance analysis. Replaces denormaliz',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_definition. Business justification: Vendor scorecards measure specific KPIs (on-time delivery rate, fill rate, composite score). Links scorecard metrics to standardized KPI definitions for cross-vendor benchmarking and performance dashb',
    `kpi_value_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_value. Business justification: Scorecard measurements (on_time_delivery_rate, fill_rate, composite_score) are instances of KPI values for specific vendors and periods. Enables time-series vendor performance reporting, variance anal',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Scorecards measure vendor performance (on-time delivery, fill rate, invoice accuracy) across PO history. Retail buyers review scorecard metrics tied to specific POs for vendor negotiations, tier assig',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: Vendor scorecards measure performance against contract SLAs (on-time delivery rate, fill rate, EDI compliance). Linking to vendor_contract enables comparing actual performance metrics to contractual c',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor being evaluated in this scorecard. Links to the vendor master data entity.',
    `chargeback_amount` DECIMAL(18,2) COMMENT 'Total monetary value of chargebacks assessed against the vendor during the scoring period, typically in USD.',
    `chargeback_count` STRING COMMENT 'Total number of chargebacks (vendor compliance penalties) issued to the vendor during the scoring period for violations such as late delivery, incorrect labeling, or packaging non-compliance.',
    `composite_score` DECIMAL(18,2) COMMENT 'Weighted overall vendor performance score calculated from individual KPI values (on-time delivery, fill rate, quality, etc.). Scale typically 0-100. Used for vendor tier classification.',
    `corrective_action_due_date` DATE COMMENT 'Deadline by which the vendor must submit a corrective action plan if required.',
    `corrective_action_required` BOOLEAN COMMENT 'Flag indicating whether the vendor is required to submit a corrective action plan based on scorecard results (true if performance is below acceptable thresholds).',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this scorecard record was first created in the system.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this scorecard (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `edi_compliance_rate` DECIMAL(18,2) COMMENT 'Percentage of transactions (purchase orders, ASNs, invoices) successfully transmitted via EDI without errors or manual intervention during the scoring period.',
    `evaluation_date` DATE COMMENT 'Date when the scorecard was completed and finalized by the evaluator.',
    `fill_rate` DECIMAL(18,2) COMMENT 'Percentage of ordered quantity that was fulfilled by the vendor during the scoring period. Measures vendor ability to meet demand without stockouts.',
    `invoice_accuracy_rate` DECIMAL(18,2) COMMENT 'Percentage of invoices submitted without pricing, quantity, or calculation errors during the scoring period. Measures vendor billing quality.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this scorecard record was last modified.',
    `lead_time_adherence_rate` DECIMAL(18,2) COMMENT 'Percentage of orders where the vendor met the agreed lead time from order placement to delivery during the scoring period.',
    `minimum_order_quantity_compliance_rate` DECIMAL(18,2) COMMENT 'Percentage of orders where the vendor honored MOQ agreements without imposing additional fees or rejecting orders during the scoring period.',
    `notes` STRING COMMENT 'Free-text field for additional comments, context, or qualitative observations about vendor performance during the scoring period.',
    `on_time_delivery_rate` DECIMAL(18,2) COMMENT 'Percentage of purchase orders or shipments delivered on or before the promised delivery date during the scoring period. Key KPI for vendor reliability.',
    `prior_period_composite_score` DECIMAL(18,2) COMMENT 'Composite score from the previous scoring period, used to calculate trend and performance improvement or decline.',
    `product_quality_score` DECIMAL(18,2) COMMENT 'Composite quality score based on defect rates, customer returns, and quality inspection results for products supplied by the vendor during the scoring period. Scale typically 0-100.',
    `return_to_vendor_amount` DECIMAL(18,2) COMMENT 'Total monetary value of goods returned to the vendor during the scoring period, typically in USD.',
    `return_to_vendor_count` STRING COMMENT 'Total number of RTV transactions initiated during the scoring period due to defects, overstock, or non-compliance.',
    `score_trend` STRING COMMENT 'Directional trend of vendor performance compared to the prior period (improving, stable, or declining).. Valid values are `improving|stable|declining`',
    `scorecard_number` STRING COMMENT 'Business identifier for the scorecard, typically formatted as SC-YYYYMMDD or similar pattern for external reference and reporting.. Valid values are `^SC-[0-9]{8}$`',
    `scorecard_status` STRING COMMENT 'Current lifecycle status of the scorecard indicating whether it is in draft, published for vendor review, under internal review, finalized, or archived.. Valid values are `draft|published|under_review|finalized|archived`',
    `scoring_period_end_date` DATE COMMENT 'The end date of the evaluation period covered by this scorecard (e.g., end of quarter or month).',
    `scoring_period_start_date` DATE COMMENT 'The start date of the evaluation period covered by this scorecard (e.g., beginning of quarter or month).',
    `total_purchase_order_count` STRING COMMENT 'Total number of purchase orders issued to the vendor during the scoring period. Provides context for volume-based KPI interpretation.',
    `total_purchase_order_value` DECIMAL(18,2) COMMENT 'Total monetary value of purchase orders issued to the vendor during the scoring period, typically in USD. Provides spend context for scorecard evaluation.',
    `vendor_acknowledgment_date` DATE COMMENT 'Date when the vendor acknowledged receipt and review of the scorecard.',
    `vendor_notification_date` DATE COMMENT 'Date when the scorecard was shared with the vendor for review and discussion.',
    `vendor_tier` STRING COMMENT 'Classification tier assigned to the vendor based on the composite score and strategic importance. Preferred vendors receive priority, probation vendors face restrictions, suspended vendors are blocked from new orders.. Valid values are `preferred|approved|conditional|probation|suspended`',
    CONSTRAINT pk_vendor_scorecard PRIMARY KEY(`vendor_scorecard_id`)
) COMMENT 'Periodic vendor performance scorecards measuring KPIs including on-time delivery rate, fill rate, EDI compliance rate, invoice accuracy, chargeback frequency, product quality scores, and overall vendor rating. Tracks scoring period, individual KPI values, weighted composite score, tier classification (preferred, approved, probation), and trend vs prior period. Enables strategic vendor relationship management.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` (
    `vendor_certification_id` BIGINT COMMENT 'Unique identifier for the vendor certification record. Primary key.',
    `category_id` BIGINT COMMENT 'Foreign key linking to merchandising.category. Business justification: Vendor certifications often apply to specific product categories (organic for grocery, CPSC for toys, FDA for food). Compliance teams filter and audit certifications by category. Assortment planning a',
    `certification_id` BIGINT COMMENT 'Foreign key linking to compliance.certification. Business justification: Vendor certifications (organic, fair trade, ISO, GFSI) are master-managed in compliance.certification for audit trails, regulatory filings, and supplier qualification. Retail operations require linkin',
    `compliance_program_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_program. Business justification: Vendor certifications must map to compliance programs (food safety, sustainability, labor standards) for program-level reporting, audit scheduling, and regulatory framework alignment. Essential for su',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Certain certifications (organic, fair trade, food safety, sustainability) are PO-level compliance requirements. Retail quality/compliance teams validate certification coverage per PO for regulatory au',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor or supplier who holds this certification.',
    `audit_frequency` STRING COMMENT 'The required frequency of audits or inspections to maintain the certification.. Valid values are `annual|semi_annual|quarterly|biennial|as_needed`',
    `compliance_level` STRING COMMENT 'The level of compliance achieved by the vendor for this certification, indicating whether all requirements are met or if there are outstanding conditions.. Valid values are `fully_compliant|conditionally_compliant|non_compliant|pending_verification`',
    `corrective_action_due_date` DATE COMMENT 'The deadline by which the vendor must complete corrective actions to address audit findings or non-conformances.',
    `corrective_action_required` BOOLEAN COMMENT 'Indicates whether corrective actions are required to address audit findings or non-conformances. True if corrective actions are pending, False otherwise.',
    `country_of_origin` STRING COMMENT 'The country where the certified products or materials originate, as declared in the certification. Uses 3-letter ISO country codes (e.g., USA, CHN, DEU).',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this vendor certification record was first created in the system.',
    `critical_non_conformance_count` STRING COMMENT 'The number of critical non-conformances identified during the most recent audit that require immediate corrective action.',
    `document_reference_number` STRING COMMENT 'The internal or external reference number for the certification document stored in the document management system or vendor portal.',
    `facility_location_covered` STRING COMMENT 'The specific vendor facility, manufacturing plant, or distribution center (DC) location covered by this certification.',
    `is_mandatory` BOOLEAN COMMENT 'Indicates whether this certification is mandatory for the vendor to do business with the retailer. True if required, False if optional or preferred.',
    `is_renewable` BOOLEAN COMMENT 'Indicates whether the certification is renewable. True if the certification can be renewed upon expiration, False if it is a one-time certification.',
    `last_audit_date` DATE COMMENT 'The date of the most recent audit or inspection conducted by the certifying body.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this vendor certification record was last modified or updated.',
    `next_audit_date` DATE COMMENT 'The scheduled date for the next audit or inspection to maintain certification.',
    `non_conformance_count` STRING COMMENT 'The number of non-conformances or deficiencies identified during the most recent audit.',
    `notes` STRING COMMENT 'Free-text field for additional notes, comments, or special conditions related to the certification.',
    `product_category_covered` STRING COMMENT 'The product categories or SKU (Stock Keeping Unit) groups that are covered under this certification (e.g., fresh produce, dairy, electronics).',
    `regulatory_authority` STRING COMMENT 'The government or regulatory body that mandates or oversees this certification (e.g., FDA, CPSC, USDA, EPA).',
    `renewal_date` DATE COMMENT 'The scheduled date for certification renewal or re-audit. Used for proactive compliance tracking.',
    `renewal_notification_days` STRING COMMENT 'The number of days before expiration that the system should trigger a renewal notification to the vendor and procurement team.',
    `verification_method` STRING COMMENT 'The method used to verify the certification, such as on-site audit, document review, third-party verification, or self-attestation.. Valid values are `on_site_audit|document_review|third_party_verification|self_attestation|remote_audit`',
    CONSTRAINT pk_vendor_certification PRIMARY KEY(`vendor_certification_id`)
) COMMENT 'Vendor compliance certifications and regulatory documentation including FDA food safety certifications, CPSC product safety compliance, ISO 9001 quality management, organic/fair-trade certifications, country-of-origin declarations, conflict minerals disclosures, and GDPR/CCPA data processing agreements. Tracks certification type, issuing body, issue date, expiry date, document reference, and renewal status.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`edi_config` (
    `edi_config_id` BIGINT COMMENT 'Unique identifier for the EDI configuration record. Primary key for the EDI configuration entity.',
    `vendor_id` BIGINT COMMENT 'Unique identifier assigned to the trading partner in the EDI network. Used in EDI envelope segments to identify sender and receiver.',
    `edi_vendor_id` BIGINT COMMENT 'Reference to the vendor or supplier for whom this EDI configuration is established. Links to the vendor master record.',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: EDI integration requirements (transaction sets, acknowledgment SLAs, compliance thresholds) are typically defined in vendor contracts. Linking edi_config to vendor_contract enables tracking which cont',
    `alert_email_addresses` STRING COMMENT 'Comma-separated list of email addresses to notify when EDI errors, SLA violations, or integration health issues occur. Used for operational alerting.',
    `authentication_method` STRING COMMENT 'The authentication mechanism used to secure the EDI connection. Certificate-based authentication is standard for AS2; SSH keys are common for SFTP.. Valid values are `certificate|username_password|ssh_key|oauth|api_key`',
    `certification_date` DATE COMMENT 'The date when the EDI integration was certified and approved for production use after successful testing. Null if not yet certified.',
    `chargeback_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the chargeback penalty amount. Example: USD, EUR, GBP.. Valid values are `^[A-Z]{3}$`',
    `chargeback_penalty_amount` DECIMAL(18,2) COMMENT 'The monetary penalty amount (in base currency) assessed per EDI compliance violation. Chargebacks are vendor compliance penalties for failing to meet EDI standards or SLAs.',
    `communication_protocol` STRING COMMENT 'The technical protocol used to transmit EDI documents between trading partners. AS2 is the most common secure protocol; VAN refers to Value-Added Network services.. Valid values are `AS2|SFTP|FTP|FTPS|VAN|API`',
    `compliance_threshold_error_rate` DECIMAL(18,2) COMMENT 'The maximum acceptable error rate (as a percentage) for EDI transactions before compliance penalties or chargebacks are triggered. Example: 2.00 means 2% error rate threshold.',
    `connection_endpoint` STRING COMMENT 'The URL, IP address, or network address used to connect to the trading partner for EDI transmission. May be an AS2 URL, SFTP host, or VAN mailbox identifier.',
    `connection_port` STRING COMMENT 'The network port number used for EDI communication. Common ports: 22 for SFTP, 443 for AS2 over HTTPS.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this EDI configuration record was first created in the system. Audit trail field for record lifecycle tracking.',
    `edi_version` STRING COMMENT 'The EDI standard version supported by this configuration. Examples: 4010, 5010 for ANSI X12; D96A, D01B for EDIFACT.',
    `effective_end_date` DATE COMMENT 'The date on which this EDI configuration ceases to be effective. Null for currently active configurations. Supports temporal validity tracking and configuration history.',
    `effective_start_date` DATE COMMENT 'The date from which this EDI configuration becomes effective and valid for use. Supports temporal validity tracking.',
    `environment_type` STRING COMMENT 'Indicates whether this EDI configuration is for production use or a non-production environment (test, development, staging). Test environments are used during EDI onboarding and integration testing.. Valid values are `production|test|development|staging`',
    `fa_sla_hours` STRING COMMENT 'The maximum number of hours allowed to send a functional acknowledgment (997) after receiving an EDI document. Failure to meet this SLA may trigger compliance chargebacks.',
    `functional_acknowledgment_required` BOOLEAN COMMENT 'Indicates whether the trading partner requires a 997 Functional Acknowledgment to be sent in response to received EDI documents. True if FA is mandatory per trading partner agreement.',
    `go_live_date` DATE COMMENT 'The date when the EDI configuration was activated for production transaction processing. Marks the transition from test to production environment.',
    `gs_qualifier` STRING COMMENT 'GS qualifier code that identifies the type of identification being used in the functional group envelope. Defines how the sender/receiver codes are interpreted.. Valid values are `01|02|12|14|ZZ`',
    `inbound_enabled` BOOLEAN COMMENT 'Indicates whether this configuration is enabled to receive inbound EDI documents from the trading partner. True if inbound processing is active.',
    `integration_health_status` STRING COMMENT 'Current operational health status of the EDI integration. Derived from recent transmission success rates, error rates, and SLA compliance. Used for proactive monitoring.. Valid values are `healthy|degraded|critical|offline`',
    `is_active` BOOLEAN COMMENT 'Indicates whether this EDI configuration is currently active and operational. False if the configuration has been deactivated or suspended.',
    `isa_qualifier` STRING COMMENT 'ISA qualifier code that identifies the type of identification being used in the EDI interchange envelope. Common values: 01=DUNS, 14=DUNS+4, ZZ=Mutually Defined. [ENUM-REF-CANDIDATE: 01|14|20|27|28|29|30|33|ZZ — 9 candidates stripped; promote to reference product]',
    `last_error_code` STRING COMMENT 'The error code or identifier for the most recent EDI processing failure. Used in conjunction with last_error_timestamp for diagnostics.',
    `last_error_description` STRING COMMENT 'Human-readable description of the most recent EDI error. Provides context for troubleshooting and resolution.',
    `last_error_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent EDI transmission or processing error. Used for troubleshooting and error resolution tracking.',
    `last_successful_transmission_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent successful EDI document transmission (inbound or outbound). Used for integration health monitoring and alerting.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The timestamp when this EDI configuration record was most recently modified. Audit trail field for change tracking.',
    `max_retry_attempts` STRING COMMENT 'The maximum number of times a failed EDI transmission will be retried before being marked as permanently failed and requiring manual intervention.',
    `notes` STRING COMMENT 'Free-form text field for capturing additional configuration details, special requirements, or historical context about the EDI integration.',
    `onboarding_start_date` DATE COMMENT 'The date when EDI onboarding activities began for this trading partner. Marks the start of the integration project.',
    `onboarding_status` STRING COMMENT 'Current status of the EDI onboarding lifecycle for this trading partner. Tracks progression from initial setup through testing, certification, and production activation. [ENUM-REF-CANDIDATE: not_started|in_progress|testing|certified|active|suspended|terminated — 7 candidates stripped; promote to reference product]',
    `outbound_enabled` BOOLEAN COMMENT 'Indicates whether this configuration is enabled to send outbound EDI documents to the trading partner. True if outbound processing is active.',
    `retry_policy` STRING COMMENT 'The retry strategy applied when EDI transmission failures occur. Defines how and when failed transmissions are retried.. Valid values are `immediate|exponential_backoff|scheduled|manual`',
    `supported_transaction_sets` STRING COMMENT 'Comma-separated list of EDI transaction set codes supported by this trading partner. Common retail sets: 850 (Purchase Order), 855 (PO Acknowledgment), 856 (Advance Ship Notice), 810 (Invoice), 832 (Price/Sales Catalog), 846 (Inventory Inquiry/Advice), 997 (Functional Acknowledgment).',
    CONSTRAINT pk_edi_config PRIMARY KEY(`edi_config_id`)
) COMMENT 'EDI (Electronic Data Interchange) integration configuration for each trading partner defining connection parameters and supported transaction sets. Captures vendor trading partner ID, ISA/GS qualifiers, supported EDI documents (850, 855, 856, 810, 832, 846), communication protocol (AS2, SFTP, VAN), test vs production status, functional acknowledgment SLA, and compliance thresholds that trigger chargebacks. Manages EDI onboarding lifecycle, ongoing integration health monitoring, and serves as the reference record for edi_transaction processing and error resolution.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` (
    `supplier_edi_transaction_id` BIGINT COMMENT 'Unique identifier for the EDI transaction log entry. Primary key.',
    `dq_result_id` BIGINT COMMENT 'Foreign key linking to analytics.dq_result. Business justification: EDI transaction processing generates data quality results (error rates, acknowledgment status, retry counts). Links transaction execution to quality measurement for EDI health dashboards and supplier',
    `edi_config_id` BIGINT COMMENT 'Foreign key linking to supplier.edi_config. Business justification: EDI transactions should directly reference the edi_config that governs their processing rules, acknowledgment requirements, and retry policies. Currently, the relationship is indirect via vendor_id. A',
    `vendor_id` BIGINT COMMENT 'Reference to the supplier or vendor involved in this EDI transaction.',
    `acknowledgment_code` STRING COMMENT 'ANSI X12 acknowledgment code from the 997/999 FA: A=Accepted, E=Accepted with Errors, R=Rejected, P=Partially Accepted, M=Rejected due to Missing Data, W=Rejected due to Wrong Data, X=Rejected due to Unrecognized Transaction Set. [ENUM-REF-CANDIDATE: A|E|R|P|M|W|X — 7 candidates stripped; promote to reference product]',
    `acknowledgment_timestamp` TIMESTAMP COMMENT 'Date and time when the functional acknowledgment (997/999) was received or sent for this transaction.',
    `archive_timestamp` TIMESTAMP COMMENT 'Date and time when this EDI transaction was archived to long-term storage.',
    `archived_flag` BOOLEAN COMMENT 'Boolean flag indicating whether this EDI transaction has been archived to long-term storage and purged from active operational tables.',
    `business_document_reference` STRING COMMENT 'Reference to the underlying business document (e.g., purchase order number, invoice number, shipment number) that this EDI transaction represents.',
    `chargeback_amount` DECIMAL(18,2) COMMENT 'Monetary penalty amount assessed to the vendor for EDI non-compliance (e.g., missing ASN, late acknowledgment, data quality failure).',
    `chargeback_eligible` BOOLEAN COMMENT 'Boolean flag indicating whether this EDI transaction failure or non-compliance is eligible for a vendor chargeback penalty.',
    `chargeback_reason_code` STRING COMMENT 'Code identifying the specific EDI compliance violation that triggered the chargeback (e.g., LATE_ASN, MISSING_997, DATA_ERROR, DUPLICATE_ICN).. Valid values are `^[A-Z0-9]{2,10}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when this EDI transaction log record was first created in the system.',
    `direction` STRING COMMENT 'Direction of the EDI message flow: inbound (received from vendor) or outbound (sent to vendor).. Valid values are `inbound|outbound`',
    `error_code` STRING COMMENT 'Error code returned by the EDI translator or validation engine if the transaction failed processing. May reference ANSI X12 syntax error codes or internal error codes.. Valid values are `^[A-Z0-9]{1,10}$`',
    `error_description` STRING COMMENT 'Human-readable description of the error encountered during EDI processing, including segment, element, and validation failure details.',
    `file_name` STRING COMMENT 'Name of the EDI file as received or sent, used for file-based EDI transmissions.',
    `file_size_bytes` BIGINT COMMENT 'Size of the EDI file in bytes, used for transmission monitoring and capacity planning.',
    `functional_acknowledgment_status` STRING COMMENT 'Status of the 997 or 999 functional acknowledgment received or sent for this transaction, indicating whether the EDI message was accepted, rejected, or accepted with errors.. Valid values are `accepted|accepted_with_errors|rejected|partially_accepted|pending|not_required`',
    `functional_group_control_number` STRING COMMENT 'Control number assigned to the functional group (GS segment) within the EDI interchange.. Valid values are `^[0-9]{1,9}$`',
    `interchange_control_number` STRING COMMENT 'Unique control number assigned to the EDI interchange envelope (ISA segment) for tracking and reconciliation purposes.. Valid values are `^[0-9]{9}$`',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when this EDI transaction log record was last modified, typically updated when processing status or acknowledgment status changes.',
    `max_retry_count` STRING COMMENT 'Maximum number of retry attempts allowed for this transaction type before escalation or manual intervention is required.',
    `processing_status` STRING COMMENT 'Current processing status of the EDI transaction within the internal EDI pipeline (received, parsed, validated, processed, failed, retrying, archived). [ENUM-REF-CANDIDATE: received|parsed|validated|processed|failed|retrying|archived — 7 candidates stripped; promote to reference product]',
    `processing_timestamp` TIMESTAMP COMMENT 'Date and time when the EDI transaction was processed by the internal EDI translation and integration engine.',
    `receiver_code` STRING COMMENT 'EDI receiver identifier from the ISA08 segment, typically the retailers EDI ID or DUNS number.. Valid values are `^[A-Z0-9]{2,15}$`',
    `receiver_qualifier` STRING COMMENT 'Qualifier code identifying the type of receiver ID (e.g., 01=DUNS, 08=UCC/EAN, 12=Phone, 14=DUNS+4, ZZ=Mutually Defined). [ENUM-REF-CANDIDATE: 01|02|08|09|10|11|12|13|14|15|16|20|27|28|29|30|33|ZZ — 18 candidates stripped; promote to reference product]',
    `retry_count` STRING COMMENT 'Number of times the EDI transaction has been retried after initial processing failure. Used to track retry attempts and enforce retry limits.',
    `segment_count` STRING COMMENT 'Total number of EDI segments in the transaction set, used for validation and completeness checks.',
    `sender_code` STRING COMMENT 'EDI sender identifier from the ISA06 segment, typically the vendors EDI ID or DUNS number.. Valid values are `^[A-Z0-9]{2,15}$`',
    `sender_qualifier` STRING COMMENT 'Qualifier code identifying the type of sender ID (e.g., 01=DUNS, 08=UCC/EAN, 12=Phone, 14=DUNS+4, ZZ=Mutually Defined). [ENUM-REF-CANDIDATE: 01|02|08|09|10|11|12|13|14|15|16|20|27|28|29|30|33|ZZ — 18 candidates stripped; promote to reference product]',
    `test_indicator` BOOLEAN COMMENT 'Boolean flag indicating whether this is a test/sandbox EDI transaction (true) or a production transaction (false).',
    `transaction_set_control_number` STRING COMMENT 'Control number assigned to the individual transaction set (ST segment) for unique identification within the functional group.. Valid values are `^[0-9]{1,9}$`',
    `transaction_set_type` STRING COMMENT 'The ANSI X12 transaction set identifier (e.g., 850=Purchase Order, 810=Invoice, 856=Advance Ship Notice, 860=Purchase Order Change, 997/999=Functional Acknowledgment, 846=Inventory Inquiry, 855=Purchase Order Acknowledgment, 875=Grocery Products Purchase Order, 204=Motor Carrier Load Tender, 214=Transportation Carrier Shipment Status). [ENUM-REF-CANDIDATE: 850|810|856|860|997|999|846|855|875|204|214 — 11 candidates stripped; promote to reference product]',
    `transmission_timestamp` TIMESTAMP COMMENT 'Date and time when the EDI message was transmitted (for outbound) or received (for inbound) by the EDI gateway.',
    CONSTRAINT pk_supplier_edi_transaction PRIMARY KEY(`supplier_edi_transaction_id`)
) COMMENT 'Log of EDI message exchanges with vendors capturing transaction set type, direction (inbound/outbound), interchange control number, functional acknowledgment status (997/999), processing timestamp, error codes, and retry count. Provides operational visibility into EDI pipeline health and supports chargeback issuance for EDI non-compliance.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` (
    `lead_time_agreement_id` BIGINT COMMENT 'Unique identifier for the lead time agreement record. Primary key.',
    `dc_facility_id` BIGINT COMMENT 'Reference to the distribution center or warehouse that receives shipments under this agreement.',
    `inventory_node_id` BIGINT COMMENT 'Foreign key linking to inventory.inventory_node. Business justification: Lead time agreements specify delivery terms to specific DCs, stores, or cross-dock facilities. Essential for replenishment planning, inbound appointment scheduling, and on-time delivery SLA measuremen',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_definition. Business justification: Lead time adherence is a core supply chain KPI measured against agreement terms. Links lead time agreements to KPI definitions for supplier performance measurement and replenishment planning analytics',
    `category_id` BIGINT COMMENT 'Reference to the product category covered by this agreement when scope_level is category or subcategory.',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: Lead time agreements define MOQ, lead times, and delivery SLAs that are typically negotiated as part of vendor contracts. Linking to vendor_contract enables tracking agreement lineage, contract renewa',
    `vendor_id` BIGINT COMMENT 'Reference to the supplier or vendor party covered by this lead time agreement.',
    `agreement_name` STRING COMMENT 'Descriptive name or title of the lead time agreement for easy identification.',
    `agreement_number` STRING COMMENT 'Business identifier for the lead time agreement, used for external reference and vendor communication.',
    `agreement_status` STRING COMMENT 'Current lifecycle status of the lead time agreement.. Valid values are `draft|active|suspended|expired|terminated`',
    `agreement_type` STRING COMMENT 'Classification of the lead time agreement based on its purpose and operational context. VMI indicates Vendor Managed Inventory agreements.. Valid values are `standard|expedited|seasonal|promotional|emergency|vmi`',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether this agreement automatically renews upon expiration.',
    `compliance_penalty_rate` DECIMAL(18,2) COMMENT 'Percentage rate applied as chargeback penalty for vendor non-compliance with lead time or delivery terms.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this lead time agreement record was first created in the system.',
    `delivery_frequency` STRING COMMENT 'Standard frequency of deliveries from vendor. DSD indicates Direct Store Delivery model.. Valid values are `daily|weekly|biweekly|monthly|on_demand|dsd`',
    `delivery_window_end_time` TIMESTAMP COMMENT 'End time of the agreed delivery window at distribution center (HH:MM format).',
    `delivery_window_start_time` TIMESTAMP COMMENT 'Start time of the agreed delivery window at distribution center (HH:MM format).',
    `edi_enabled_flag` BOOLEAN COMMENT 'Indicates whether purchase orders and ASNs are exchanged via EDI for this agreement.',
    `effective_end_date` DATE COMMENT 'Date when this lead time agreement expires or is terminated. Null for open-ended agreements.',
    `effective_start_date` DATE COMMENT 'Date when this lead time agreement becomes active and enforceable.',
    `expedited_lead_time_days` STRING COMMENT 'Reduced lead time in days available for rush or expedited orders, typically at premium cost.',
    `fill_rate_sla_percent` DECIMAL(18,2) COMMENT 'Target percentage of ordered quantity that vendor must deliver to meet order completion SLA.',
    `incoterm` STRING COMMENT 'Standard trade term defining responsibilities for shipping, insurance, and customs (e.g., FOB, CIF, DDP).. Valid values are `EXW|FOB|CIF|DDP|DAP|FCA`',
    `inner_pack_quantity` STRING COMMENT 'Number of consumer units in an inner pack within the master case, used for store-level replenishment.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this lead time agreement record was last modified.',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum number of units that must be ordered per purchase order to meet vendor requirements.',
    `notes` STRING COMMENT 'Free-text field for additional terms, special instructions, or exceptions related to this lead time agreement.',
    `on_time_delivery_sla_percent` DECIMAL(18,2) COMMENT 'Target percentage of deliveries that must arrive within the agreed lead time window to meet SLA.',
    `order_increment_quantity` DECIMAL(18,2) COMMENT 'Quantity increment in which orders must be placed above the MOQ (e.g., must order in multiples of 12 units).',
    `origin_location` STRING COMMENT 'Geographic location or facility from which vendor ships products (city, state, country).',
    `pack_size` STRING COMMENT 'Number of consumer units contained in a single vendor pack or case.',
    `pallet_quantity` STRING COMMENT 'Standard number of cases or units per pallet for warehouse receiving and cross-docking operations.',
    `renewal_notice_days` STRING COMMENT 'Number of days advance notice required before agreement renewal or termination.',
    `scope_level` STRING COMMENT 'Granularity level at which this lead time agreement applies: vendor-wide, product category, subcategory, individual SKU, or product group.. Valid values are `vendor|category|subcategory|sku|product_group`',
    `seasonal_lead_time_adjustment_days` STRING COMMENT 'Additional days added to standard lead time during peak seasonal periods (e.g., holiday season, back-to-school).',
    `seasonal_period_end_date` DATE COMMENT 'End date of the seasonal period when lead time adjustments apply.',
    `seasonal_period_start_date` DATE COMMENT 'Start date of the seasonal period when lead time adjustments apply.',
    `sku` STRING COMMENT 'Specific SKU identifier when this agreement applies to an individual product. Null when agreement is at vendor or category level.',
    `standard_lead_time_days` STRING COMMENT 'Standard number of days from purchase order placement to goods receipt at distribution center under normal operating conditions.',
    `transportation_mode` STRING COMMENT 'Primary mode of transportation used for shipments under this agreement.. Valid values are `truck|rail|air|ocean|intermodal|parcel`',
    `unit_of_measure` STRING COMMENT 'Standard unit of measure for quantities in this agreement (each, case, pallet, weight, volume). [ENUM-REF-CANDIDATE: each|case|pallet|pound|kilogram|liter|gallon — 7 candidates stripped; promote to reference product]',
    `vmi_enabled_flag` BOOLEAN COMMENT 'Indicates whether this agreement operates under a VMI model where vendor manages inventory replenishment.',
    `created_by` STRING COMMENT 'User ID or name of the procurement specialist who created this agreement record.',
    CONSTRAINT pk_lead_time_agreement PRIMARY KEY(`lead_time_agreement_id`)
) COMMENT 'Documented lead time and MOQ (Minimum Order Quantity) agreements per vendor and product category or SKU. Captures standard lead time (days), expedited lead time, MOQ units, order increment, pack size, inner pack quantity, and seasonal lead time adjustments. Feeds Blue Yonder demand planning replenishment parameters and OTB calculations.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`vmi_config` (
    `vmi_config_id` BIGINT COMMENT 'Unique identifier for the VMI configuration record. Primary key.',
    `inventory_node_id` BIGINT COMMENT 'Reference to the specific DC or store location where this VMI configuration applies.',
    `kpi_definition_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_definition. Business justification: VMI program performance metrics (stockout rates, inventory turns, fill rates) are tracked KPIs with defined SLA targets. Links VMI configuration to KPI definitions for VMI program effectiveness dashbo',
    `lead_time_agreement_id` BIGINT COMMENT 'Foreign key linking to supplier.lead_time_agreement. Business justification: VMI configuration replenishment timing should reference the lead_time_agreement that defines vendor lead times and delivery windows. This ensures VMI replenishment calculations use contractually agree',
    `category_id` BIGINT COMMENT 'Reference to the product category covered by this VMI configuration. Null if configuration applies to a specific product.',
    `reorder_policy_id` BIGINT COMMENT 'Foreign key linking to inventory.reorder_policy. Business justification: VMI configurations operationalize reorder policies for vendor-managed SKUs. Linking config to policy enables automated replenishment execution, policy compliance monitoring, and vendor performance eva',
    `sku_id` BIGINT COMMENT 'Reference to the specific product or SKU covered by this VMI configuration. Null if configuration applies to a product category.',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor who manages inventory under this VMI agreement.',
    `vmi_agreement_id` BIGINT COMMENT 'Reference to the parent VMI agreement that governs this configuration.',
    `approval_required_flag` BOOLEAN COMMENT 'Indicates whether retailer approval is required before the vendor can execute a replenishment order under this configuration.',
    `auto_replenishment_enabled` BOOLEAN COMMENT 'Indicates whether the vendor is authorized to automatically generate and fulfill replenishment orders without retailer approval.',
    `config_name` STRING COMMENT 'Business-friendly name or label for this VMI configuration for identification and reporting purposes.',
    `config_notes` STRING COMMENT 'Free-text notes capturing special instructions, exceptions, or business context for this VMI configuration.',
    `config_status` STRING COMMENT 'Current lifecycle status of the VMI configuration indicating whether it is operational.. Valid values are `active|inactive|suspended|pending_activation|terminated`',
    `consignment_flag` BOOLEAN COMMENT 'Indicates whether this VMI arrangement operates under a consignment model where the vendor retains ownership until sale or consumption.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this VMI configuration record was first created in the system.',
    `data_sharing_frequency` STRING COMMENT 'The frequency at which inventory position and consumption data is shared with the vendor.. Valid values are `real_time|hourly|daily|weekly|on_request`',
    `edi_transaction_set` STRING COMMENT 'The EDI transaction set codes used for VMI data exchange (e.g., 852 Product Activity Data, 846 Inventory Inquiry).',
    `effective_end_date` DATE COMMENT 'The date on which this VMI configuration expires or is terminated. Null for open-ended configurations.',
    `effective_start_date` DATE COMMENT 'The date on which this VMI configuration becomes active and operational.',
    `excess_inventory_penalty_amount` DECIMAL(18,2) COMMENT 'The financial penalty amount charged to the vendor for maintaining inventory levels above the maximum threshold.',
    `last_replenishment_date` DATE COMMENT 'The date on which the vendor last executed a replenishment order under this VMI configuration.',
    `last_review_date` DATE COMMENT 'The date on which the vendor last reviewed inventory levels under this VMI configuration.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this VMI configuration record was last modified.',
    `max_inventory_threshold` DECIMAL(18,2) COMMENT 'The maximum stock level that the vendor should maintain at the location.',
    `min_inventory_threshold` DECIMAL(18,2) COMMENT 'The minimum stock level that triggers a replenishment action by the vendor.',
    `next_review_date` DATE COMMENT 'The scheduled date for the next inventory review by the vendor under this VMI configuration.',
    `ownership_transfer_point` STRING COMMENT 'The point in the supply chain at which inventory ownership transfers from the vendor to the retailer.. Valid values are `at_receipt|at_consumption|at_sale|at_shipment`',
    `performance_sla_target` DECIMAL(18,2) COMMENT 'The target service level percentage (e.g., 98.5%) that the vendor must maintain for in-stock availability under this VMI configuration.',
    `reorder_point` DECIMAL(18,2) COMMENT 'The inventory level at which the vendor initiates a replenishment order.',
    `replenishment_frequency` STRING COMMENT 'The cadence at which the vendor reviews and replenishes inventory under this VMI configuration.. Valid values are `daily|weekly|bi_weekly|monthly|on_demand|continuous`',
    `replenishment_model` STRING COMMENT 'The inventory replenishment strategy used by the vendor under this VMI configuration.. Valid values are `min_max|consumption_based|forecast_driven|event_triggered|hybrid`',
    `reporting_format` STRING COMMENT 'The technical format used for sharing inventory and consumption reports with the vendor.. Valid values are `edi|xml|json|csv|api|portal`',
    `review_cycle_days` STRING COMMENT 'The frequency in days at which the vendor reviews inventory levels to determine replenishment needs.',
    `safety_stock_level` DECIMAL(18,2) COMMENT 'The buffer inventory quantity maintained to protect against stockouts due to demand variability or supply delays.',
    `stockout_penalty_amount` DECIMAL(18,2) COMMENT 'The financial penalty amount charged to the vendor for each stockout incident under this VMI configuration.',
    `target_inventory_level` DECIMAL(18,2) COMMENT 'The optimal stock level that the vendor aims to maintain under normal operating conditions.',
    `threshold_unit_of_measure` STRING COMMENT 'The unit of measure for all inventory threshold quantities (min, max, target, safety stock, reorder point). [ENUM-REF-CANDIDATE: EA|CS|PL|LB|KG|GAL|LTR — 7 candidates stripped; promote to reference product]',
    `vendor_access_level` STRING COMMENT 'The level of system access granted to the vendor for inventory visibility and replenishment management.. Valid values are `read_only|read_write|full_control|restricted`',
    CONSTRAINT pk_vmi_config PRIMARY KEY(`vmi_config_id`)
) COMMENT 'Vendor Managed Inventory (VMI) configuration defining the terms under which a vendor manages stock levels at designated DC or store locations. Captures min/max inventory thresholds, replenishment trigger rules, vendor access permissions, reporting frequency, ownership transfer point, and VMI program status. Supports automated replenishment and reduces stockout risk.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`vendor_item` (
    `vendor_item_id` BIGINT COMMENT 'Unique identifier for the vendor-item relationship record. Primary key.',
    `lead_time_agreement_id` BIGINT COMMENT 'Foreign key linking to supplier.lead_time_agreement. Business justification: Vendor_item captures item-specific lead times and MOQ values that should be governed by a lead_time_agreement. Adding this FK normalizes lead time and MOQ data to the authoritative agreement record. R',
    `po_line_id` BIGINT COMMENT 'Foreign key linking to supplychain.po_line. Business justification: Vendor_item defines vendors catalog entry (pack size, cost, lead time). PO lines reference vendor_item_number (denormalized). Real-world procurement systems link PO lines to vendor item master for co',
    `sku_id` BIGINT COMMENT 'Reference to the internal product master record. Links vendor catalog to internal SKU (Stock Keeping Unit).',
    `vendor_id` BIGINT COMMENT 'Reference to the supplier or vendor providing this item. Links to the vendor master record.',
    `case_pack_quantity` STRING COMMENT 'Number of individual units contained in one vendor case pack. Used for ordering and receiving calculations.',
    `vendor_item_category` STRING COMMENT 'The vendors product category classification for this item. May differ from internal merchandising hierarchy.',
    `cost_currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the unit cost (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `cost_effective_date` DATE COMMENT 'The date from which the current unit cost is effective. Used for cost change tracking and historical cost analysis.',
    `cost_expiration_date` DATE COMMENT 'The date through which the current unit cost remains valid. Null indicates open-ended pricing.',
    `country_of_origin` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code indicating where the item is manufactured or produced. Required for customs, tariffs, and trade compliance.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this vendor-item record was first created in the system.',
    `vendor_item_description` STRING COMMENT 'The vendors description of the item as it appears in their catalog. May differ from internal product description.',
    `dsd_eligible_flag` BOOLEAN COMMENT 'Indicates whether this item can be delivered directly to stores by the vendor, bypassing the DC (Distribution Center). Common for beverages, bread, and snacks.',
    `ean` STRING COMMENT '13-digit European Article Number barcode identifier used internationally for retail product identification.. Valid values are `^[0-9]{13}$`',
    `edi_enabled_flag` BOOLEAN COMMENT 'Indicates whether purchase orders and ASN (Advanced Shipping Notice) transactions for this vendor-item are transmitted via EDI (Electronic Data Interchange).',
    `effective_end_date` DATE COMMENT 'The date through which this vendor-item relationship remains active. Null indicates an open-ended relationship.',
    `effective_start_date` DATE COMMENT 'The date from which this vendor-item relationship became active and available for ordering.',
    `gtin` STRING COMMENT 'Global Trade Item Number assigned by GS1 for worldwide product identification. Can be 8, 12, 13, or 14 digits.. Valid values are `^[0-9]{8,14}$`',
    `inner_pack_quantity` STRING COMMENT 'Number of individual units contained in one inner pack within a case. Used for shelf-ready packaging and store replenishment.',
    `last_cost_change_date` DATE COMMENT 'The date when the unit cost was last modified. Used for cost trend analysis and vendor negotiation tracking.',
    `last_order_date` DATE COMMENT 'The date when this vendor-item combination was last ordered. Used to identify slow-moving or obsolete vendor relationships.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'The date and time when this vendor-item record was last modified.',
    `notes` STRING COMMENT 'Free-form text field for additional information about this vendor-item relationship, such as special handling instructions or ordering restrictions.',
    `pallet_hi` STRING COMMENT 'Number of layers (tiers) stacked on a pallet. Part of the TI/HI pallet configuration used in warehouse and DC operations.',
    `pallet_ti` STRING COMMENT 'Number of cases per layer on a pallet. Part of the TI/HI pallet configuration used in warehouse and DC (Distribution Center) operations.',
    `preferred_vendor_flag` BOOLEAN COMMENT 'Indicates whether this vendor is the preferred source for this item when multiple vendors supply the same product. Used in automated sourcing decisions.',
    `private_label_flag` BOOLEAN COMMENT 'Indicates whether this item is a private label (store brand) product manufactured exclusively for the retailer by this vendor.',
    `seasonal_lead_time_adjustment_days` STRING COMMENT 'Additional lead time days required during peak seasonal periods (e.g., holiday season). Added to standard lead time for seasonal planning.',
    `unit_cost` DECIMAL(18,2) COMMENT 'The cost per individual unit charged by the vendor. Used for COGS (Cost of Goods Sold) calculations and margin analysis. Excludes freight and other charges.',
    `upc` STRING COMMENT '12-digit Universal Product Code barcode identifier used primarily in North America for retail scanning at POS (Point of Sale).. Valid values are `^[0-9]{12}$`',
    `vendor_item_number` STRING COMMENT 'The vendors unique part number or catalog identifier for this item. Used in purchase orders and EDI (Electronic Data Interchange) transactions.',
    `vendor_item_status` STRING COMMENT 'Current lifecycle status of this vendor-item relationship. Active items are available for ordering; discontinued items are being phased out.. Valid values are `active|inactive|discontinued|pending|suspended`',
    `vendor_pack_configuration` STRING COMMENT 'Description of how the vendor packages this item (e.g., case pack, master carton, pallet). Defines the vendors standard shipping unit.',
    `vmi_enabled_flag` BOOLEAN COMMENT 'Indicates whether this vendor-item combination is managed under a VMI (Vendor Managed Inventory) agreement where the vendor controls replenishment.',
    CONSTRAINT pk_vendor_item PRIMARY KEY(`vendor_item_id`)
) COMMENT 'Vendor-specific item catalog linking vendor part numbers, UPCs, GTINs, and EANs to internal SKUs. Captures vendor item number, vendor pack configuration, case pack quantity, inner pack, pallet TI/HI, unit cost, cost effective date, country of origin, and item status. Includes lead time and MOQ agreements per vendor-item combination: standard lead time (days), expedited lead time, MOQ units, order increment, pack size, inner pack quantity, seasonal lead time adjustments, and category-level defaults. Serves as the cross-reference between vendor catalogs and the internal product master, and feeds Blue Yonder demand planning replenishment parameters and OTB calculations.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` (
    `vendor_allowance_id` BIGINT COMMENT 'Unique identifier for the vendor allowance record. Primary key.',
    `buyer_id` BIGINT COMMENT 'Foreign key linking to merchandising.buyer. Business justification: Vendor allowances are negotiated and tracked by the buyer responsible for that vendor. OTB budget reconciliation, margin planning, and vendor negotiation workflows require buyer-level allowance visibi',
    `campaign_id` BIGINT COMMENT 'Foreign key linking to marketing.campaign. Business justification: Vendor allowances (co-op marketing funds, promotional allowances) directly fund specific retail marketing campaigns. Retailers must track which campaign consumed which vendor allowance for accrual rec',
    `kpi_value_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_value. Business justification: Allowance accrual rates, settlement rates, and disputed amounts are financial KPIs tracked by vendor and period. Links allowance transactions to KPI measurement for trade spend analytics and vendor fu',
    `promo_campaign_id` BIGINT COMMENT 'Identifier linking the allowance to a specific promotional campaign or event if the allowance is promotion-specific.',
    `promo_offer_id` BIGINT COMMENT 'Foreign key linking to promotion.promo_offer. Business justification: Vendor allowances frequently fund specific promotional offers (e.g., temporary price reductions, BOGOs) rather than entire campaigns. Merchandising teams reconcile allowance accruals and claims agains',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Vendor allowances (scan-based trading, promotional funding, volume rebates) are frequently SKU-specific or apply to defined SKU lists. Business process: promotional cost accounting, margin analysis, a',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Allowances (rebates, volume discounts, promotional funding) accrue based on qualifying PO spend. Retail finance teams reconcile allowance claims to PO history for accrual accuracy, settlement validati',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: Vendor_allowance currently has contract_reference as a STRING field. Trade allowances, co-op funds, and promotional funding are typically defined in vendor contracts. Normalizing this to a FK enables',
    `vendor_id` BIGINT COMMENT 'Identifier of the supplier or vendor providing the allowance. Links to the vendor master record.',
    `accrual_method` STRING COMMENT 'Method by which the allowance is accrued in financial systems: invoice-based (at purchase), sales-based (at POS), volume-based (cumulative tier), time-based (periodic), or event-based (specific milestone).. Valid values are `invoice_based|sales_based|volume_based|time_based|event_based`',
    `accrued_amount` DECIMAL(18,2) COMMENT 'Total monetary value of allowances earned but not yet settled or paid by the vendor.',
    `allowance_amount` DECIMAL(18,2) COMMENT 'Fixed monetary value of the allowance if structured as a lump sum payment or credit.',
    `allowance_description` STRING COMMENT 'Detailed narrative description of the allowance terms, purpose, and business rationale.',
    `allowance_number` STRING COMMENT 'Business identifier or agreement number for the vendor allowance as referenced in contracts and supplier communications.',
    `allowance_percentage` DECIMAL(18,2) COMMENT 'Percentage rate applied to qualifying purchase volume or sales to calculate the allowance value.',
    `allowance_status` STRING COMMENT 'Current lifecycle status of the vendor allowance agreement.. Valid values are `draft|active|suspended|expired|settled|cancelled`',
    `allowance_type` STRING COMMENT 'Classification of the vendor allowance mechanism: off-invoice (deducted at purchase), bill-back (claimed post-sale), scan-based (tied to POS data), slotting fee (shelf placement), co-op advertising (marketing fund), or volume rebate (tier-based discount).. Valid values are `off_invoice|bill_back|scan_based|slotting_fee|co_op_advertising|volume_rebate`',
    `approval_status` STRING COMMENT 'Internal approval workflow status for the allowance setup or claim.. Valid values are `pending_approval|approved|rejected`',
    `approved_by` STRING COMMENT 'Name or identifier of the procurement or finance manager who approved the allowance agreement or claim.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the allowance was approved in the system.',
    `claimed_amount` DECIMAL(18,2) COMMENT 'Total monetary value of allowances formally claimed from the vendor through bill-back or settlement process.',
    `cost_center_code` STRING COMMENT 'Cost center or profit center code associated with the allowance for internal financial allocation and P&L reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the vendor allowance record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the allowance monetary values.. Valid values are `^[A-Z]{3}$`',
    `disputed_amount` DECIMAL(18,2) COMMENT 'Monetary value of allowances under dispute or chargeback contention with the vendor.',
    `effective_end_date` DATE COMMENT 'Date when the vendor allowance agreement expires or is no longer eligible for new accruals.',
    `effective_start_date` DATE COMMENT 'Date when the vendor allowance agreement becomes active and eligible for accrual.',
    `gl_account_code` STRING COMMENT 'General ledger account code to which the vendor allowance is posted for financial reporting and cost of goods sold (COGS) adjustment.',
    `last_claim_date` DATE COMMENT 'Most recent date when an allowance claim was submitted to the vendor.',
    `last_settlement_date` DATE COMMENT 'Most recent date when the vendor made a payment or credit against the allowance.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time when the vendor allowance record was most recently modified.',
    `minimum_purchase_amount` DECIMAL(18,2) COMMENT 'Minimum purchase value required to qualify for the allowance.',
    `minimum_purchase_quantity` DECIMAL(18,2) COMMENT 'Minimum order quantity (MOQ) in units required to qualify for the allowance.',
    `notes` STRING COMMENT 'Free-text field for additional comments, special instructions, or clarifications regarding the allowance agreement or settlement.',
    `payment_method` STRING COMMENT 'Mechanism by which the vendor settles the allowance: credit memo, check, electronic funds transfer (EFT), invoice offset, or promotional credit.. Valid values are `credit_memo|check|eft|offset_invoice|promotional_credit`',
    `payment_terms` STRING COMMENT 'Negotiated terms for allowance settlement timing and conditions, such as net 30, net 60, or upon claim submission.',
    `product_category` STRING COMMENT 'Merchandise category or product line to which the allowance applies, used for category management and gross margin return on investment (GMROI) analysis.',
    `qualifying_condition` STRING COMMENT 'Business rules and criteria that must be met to earn or claim the allowance, such as minimum order quantity (MOQ), purchase volume thresholds, promotional participation, or compliance requirements.',
    `redemption_end_date` DATE COMMENT 'Final date by which accrued allowances must be claimed or they expire.',
    `redemption_start_date` DATE COMMENT 'Earliest date when accrued allowances can be claimed or redeemed from the vendor.',
    `settled_amount` DECIMAL(18,2) COMMENT 'Total monetary value of allowances paid or credited by the vendor.',
    `settlement_status` STRING COMMENT 'Current state of financial settlement for the allowance: pending claim, partially paid, fully paid, under dispute, or written off.. Valid values are `pending|partially_settled|fully_settled|disputed|written_off`',
    `sku_list` STRING COMMENT 'Comma-separated or structured list of specific SKUs (Stock Keeping Units) eligible for the allowance, if restricted to specific items.',
    CONSTRAINT pk_vendor_allowance PRIMARY KEY(`vendor_allowance_id`)
) COMMENT 'Vendor-funded trade allowances, co-op advertising funds, slotting fees, promotional funding, and volume rebates negotiated with suppliers. Tracks allowance type (off-invoice, bill-back, scan-based), allowance amount or percentage, qualifying conditions, accrual method, redemption period, and settlement status. Critical for net landed cost and P&L accuracy.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` (
    `onboarding_request_id` BIGINT COMMENT 'Unique identifier for the vendor onboarding request record.',
    `buyer_id` BIGINT COMMENT 'Identifier of the procurement buyer or category manager responsible for managing this onboarding request and the vendor relationship.',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Vendor onboarding workflow tracking requires linking the associate who modified the request for audit trail, workload analysis, and process improvement. Replaces denormalized modified_by_user text fie',
    `third_party_assessment_id` BIGINT COMMENT 'Foreign key linking to compliance.third_party_assessment. Business justification: New vendor onboarding requires third-party compliance assessments (data security, labor practices, ethical sourcing, certifications) before approval. Retail supplier onboarding process mandates linkin',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor master record being onboarded. Links to the vendor entity once the onboarding is approved and the vendor record is created.',
    `application_submitted_date` DATE COMMENT 'Date when the vendor onboarding application was initially submitted for review.',
    `approval_date` DATE COMMENT 'Date when the vendor onboarding request was approved and the vendor was added to the approved vendor list.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this onboarding request record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for transactions with this vendor (e.g., USD, EUR, GBP, CAD).. Valid values are `^[A-Z]{3}$`',
    `diversity_certification` STRING COMMENT 'Diversity certification status of the vendor: MBE (Minority Business Enterprise), WBE (Women Business Enterprise), VBE (Veteran Business Enterprise), DBE (Disadvantaged Business Enterprise), LGBTBE (LGBT Business Enterprise), SDVOSB (Service-Disabled Veteran-Owned Small Business), HUBZone, or none. [ENUM-REF-CANDIDATE: mbe|wbe|vbe|dbe|lgbtbe|sdvosb|hubzone|none — 8 candidates stripped; promote to reference product]',
    `duns_number` STRING COMMENT 'The 9-digit DUNS number assigned by Dun & Bradstreet for unique identification of the vendors business entity.. Valid values are `^[0-9]{9}$`',
    `edi_capable_flag` BOOLEAN COMMENT 'Indicates whether the vendor has the technical capability to exchange business documents (purchase orders, invoices, ASNs) via EDI.',
    `edi_setup_completed_flag` BOOLEAN COMMENT 'Indicates whether the EDI connection and transaction sets have been successfully configured and tested with the vendor.',
    `headquarters_address_line1` STRING COMMENT 'First line of the vendors headquarters street address (street number and name).',
    `headquarters_city` STRING COMMENT 'City where the vendors headquarters is located.',
    `headquarters_country_code` STRING COMMENT 'Three-letter ISO 3166-1 alpha-3 country code for the vendors headquarters location (e.g., USA, CAN, MEX, GBR).. Valid values are `^[A-Z]{3}$`',
    `headquarters_postal_code` STRING COMMENT 'Postal code or ZIP code of the vendors headquarters location.',
    `headquarters_state_province` STRING COMMENT 'State or province where the vendors headquarters is located.',
    `insurance_certificate_received_flag` BOOLEAN COMMENT 'Indicates whether the required insurance certificate has been received and validated during the onboarding process.',
    `insurance_certificate_required_flag` BOOLEAN COMMENT 'Indicates whether the vendor is required to provide proof of insurance (general liability, product liability, workers compensation) as part of the onboarding process.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this onboarding request record was last updated or modified.',
    `lead_time_days` STRING COMMENT 'Standard lead time in days from purchase order placement to delivery at the distribution center or store, as committed by the vendor.',
    `moq_units` STRING COMMENT 'The minimum order quantity in units that the vendor requires for purchase orders, as agreed during onboarding negotiations.',
    `notes` STRING COMMENT 'Free-form text field for capturing additional notes, comments, or special instructions related to the vendor onboarding process.',
    `onboarding_completion_date` DATE COMMENT 'Date when all onboarding activities were completed, including EDI setup, item setup, and first purchase order issuance.',
    `onboarding_stage` STRING COMMENT 'Current stage in the vendor onboarding workflow: application submitted, document review in progress, compliance check, EDI (Electronic Data Interchange) setup, item setup in PIM, first PO (Purchase Order) issued, completed, or rejected. [ENUM-REF-CANDIDATE: application|document_review|compliance_check|edi_setup|item_setup|first_po|completed|rejected — 8 candidates stripped; promote to reference product]',
    `onboarding_status` STRING COMMENT 'Overall status of the onboarding request: draft, submitted, in review, pending additional information, approved, rejected, on hold, or cancelled. [ENUM-REF-CANDIDATE: draft|submitted|in_review|pending_info|approved|rejected|on_hold|cancelled — 8 candidates stripped; promote to reference product]',
    `payment_terms_code` STRING COMMENT 'Standard payment terms code agreed upon with the vendor (e.g., NET30, NET60, 2/10NET30) defining the payment due date and any early payment discounts.',
    `primary_contact_email` STRING COMMENT 'Email address of the primary contact person at the vendor organization.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `primary_contact_name` STRING COMMENT 'Full name of the primary contact person at the vendor organization for onboarding coordination and ongoing relationship management.',
    `primary_contact_phone` STRING COMMENT 'Phone number of the primary contact person at the vendor organization.',
    `rejection_date` DATE COMMENT 'Date when the vendor onboarding request was rejected, if applicable.',
    `rejection_reason` STRING COMMENT 'Detailed explanation of why the vendor onboarding request was rejected, including specific compliance, financial, or operational concerns.',
    `request_number` STRING COMMENT 'Business-facing unique identifier for the onboarding request, typically formatted as ONB-YYYYMMDD or similar pattern for tracking and reference.. Valid values are `^ONB-[0-9]{8}$`',
    `risk_assessment_score` DECIMAL(18,2) COMMENT 'Quantitative risk score assigned during the vendor qualification process, typically on a scale of 0-100, with higher scores indicating higher risk.',
    `risk_tier` STRING COMMENT 'Risk classification of the vendor based on factors such as spend volume, product category criticality, geographic location, and compliance history. Used to determine the level of due diligence and ongoing monitoring required.. Valid values are `low|medium|high|critical`',
    `sustainability_certified_flag` BOOLEAN COMMENT 'Indicates whether the vendor holds recognized sustainability certifications such as ISO 14001, B Corp, Fair Trade, or similar environmental and social responsibility standards.',
    `tax_identifier` STRING COMMENT 'The vendors tax identification number (EIN in the US, VAT number in EU, or equivalent) for tax reporting and compliance purposes.',
    `vendor_dba_name` STRING COMMENT 'The trade name or DBA name under which the vendor operates, if different from the legal name.',
    `vendor_legal_name` STRING COMMENT 'The full legal name of the vendor organization as it appears on official registration documents and contracts.',
    `vmi_enabled_flag` BOOLEAN COMMENT 'Indicates whether the vendor will participate in a VMI program where they manage inventory levels and replenishment at the retailers locations.',
    `w9_form_received_flag` BOOLEAN COMMENT 'Indicates whether the IRS Form W-9 (Request for Taxpayer Identification Number and Certification) has been received from the vendor for US tax reporting purposes.',
    CONSTRAINT pk_onboarding_request PRIMARY KEY(`onboarding_request_id`)
) COMMENT 'Vendor onboarding and qualification workflow records tracking the end-to-end process of bringing a new supplier onto the approved vendor list. Captures onboarding stage (application, document review, compliance check, EDI setup, item setup, first PO), assigned buyer, risk tier, required certifications checklist, approval status, and onboarding completion date.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` (
    `risk_assessment_id` BIGINT COMMENT 'Unique identifier for the vendor risk assessment record. Primary key.',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Supplier risk assessment workflows require tracking which associate conducted the evaluation for accountability, expertise validation, and workload balancing. Replaces denormalized assessor_name/depar',
    `buyer_id` BIGINT COMMENT 'Foreign key linking to merchandising.buyer. Business justification: Risk assessments are conducted by or assigned to the buyer managing that vendor relationship. Sourcing decisions, vendor selection, and contract negotiations depend on buyer-reviewed risk profiles. Bu',
    `kpi_value_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_value. Business justification: Risk scores (financial stability, geopolitical, ESG, overall risk tier) are KPI measurements by vendor and assessment period. Links risk assessments to KPI framework for supplier risk dashboards and e',
    `risk_register_id` BIGINT COMMENT 'Foreign key linking to compliance.risk_register. Business justification: Supplier risk assessments (financial stability, geopolitical, ESG, cybersecurity) feed into enterprise risk register for consolidated risk management, board reporting, and regulatory disclosure. Retai',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor being assessed. Links to the vendor master record.',
    `approval_date` DATE COMMENT 'Date when the risk assessment was formally approved and became effective for vendor management decisions.',
    `approved_by` STRING COMMENT 'Name or identifier of the individual who approved the risk assessment (e.g., Chief Procurement Officer, Risk Committee Chair, VP Supply Chain).',
    `assessment_date` DATE COMMENT 'Date when the risk assessment was conducted. Principal business event timestamp for this assessment.',
    `assessment_expiry_date` DATE COMMENT 'Date when this risk assessment expires and is no longer valid for vendor management decisions. Expired assessments require immediate reassessment before continuing business.',
    `assessment_notes` STRING COMMENT 'Free-text field for additional context, observations, qualitative risk factors, assessor commentary, or special considerations not captured in structured risk scores.',
    `assessment_number` STRING COMMENT 'Business identifier for the risk assessment, formatted as RA-YYYYMMDD or similar pattern for external reference and audit trails.. Valid values are `^RA-[0-9]{8}$`',
    `assessment_status` STRING COMMENT 'Current lifecycle status of the risk assessment: draft, in progress, under review by risk committee, approved, rejected, or expired requiring reassessment.. Valid values are `draft|in_progress|under_review|approved|rejected|expired`',
    `assessment_type` STRING COMMENT 'Classification of the assessment trigger: initial onboarding assessment, periodic scheduled review, triggered by event, contract renewal, ad-hoc request, or incident-driven investigation.. Valid values are `initial|periodic|triggered|renewal|ad_hoc|incident_driven`',
    `compliance_risk_score` DECIMAL(18,2) COMMENT 'Score evaluating vendors adherence to regulatory requirements, industry standards, contractual obligations, and history of chargebacks (vendor compliance penalties), RTV (Return to Vendor) incidents, and audit findings.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this risk assessment record was first created in the system. Audit trail for record creation.',
    `cybersecurity_risk_score` DECIMAL(18,2) COMMENT 'Score evaluating vendors cybersecurity posture, data protection practices, incident history, compliance with PCI DSS (Payment Card Industry Data Security Standard), ISO 27001, and ability to protect shared data and EDI (Electronic Data Interchange) integrations.',
    `data_sources` STRING COMMENT 'List or description of data sources used for the assessment (e.g., Dun & Bradstreet financial reports, vendor self-assessment questionnaire, third-party ESG ratings, internal performance scorecards, audit reports).',
    `esg_risk_score` DECIMAL(18,2) COMMENT 'Composite score assessing vendors environmental practices, social responsibility, labor standards, ethical governance, and sustainability certifications. Evaluates ESG compliance and reputational risk.',
    `financial_stability_score` DECIMAL(18,2) COMMENT 'Quantitative score evaluating the vendors financial health, creditworthiness, liquidity ratios, and solvency. Typically scored 0-100 or 0-10 scale based on financial statement analysis and credit ratings.',
    `geopolitical_risk_score` DECIMAL(18,2) COMMENT 'Score assessing exposure to geopolitical instability, trade restrictions, sanctions, tariffs, political unrest, or regulatory changes in vendors operating regions.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this risk assessment record was last updated. Audit trail for record modification.',
    `mitigation_actions_required` STRING COMMENT 'Detailed description of risk mitigation actions, controls, or remediation steps required to reduce identified risks to acceptable levels. May include contract amendments, additional insurance, dual sourcing, enhanced monitoring, or capability improvements.',
    `mitigation_due_date` DATE COMMENT 'Target completion date for mitigation actions. Used to track remediation progress and escalate overdue items.',
    `mitigation_owner` STRING COMMENT 'Name or role of the individual or team responsible for executing and tracking mitigation actions (e.g., Category Manager, Supplier Quality Engineer, Procurement Director).',
    `mitigation_status` STRING COMMENT 'Current status of mitigation action execution: not started, in progress, completed, on hold pending vendor response, or cancelled if risk is accepted or vendor relationship terminated.. Valid values are `not_started|in_progress|completed|on_hold|cancelled`',
    `modified_by_user` STRING COMMENT 'User ID or name of the individual who last modified the risk assessment record. Audit trail for accountability.',
    `next_assessment_date` DATE COMMENT 'Scheduled date for the next periodic risk assessment. Calculated based on reassessment schedule and current assessment date.',
    `overall_risk_score` DECIMAL(18,2) COMMENT 'Composite quantitative risk score calculated from weighted individual risk category scores. Used to rank vendors and prioritize risk mitigation efforts.',
    `overall_risk_tier` STRING COMMENT 'Aggregated risk classification tier derived from individual risk category scores. Determines vendor management intensity, monitoring frequency, and escalation protocols: low (minimal oversight), medium (standard monitoring), high (enhanced controls), critical (executive attention and mitigation required).. Valid values are `low|medium|high|critical`',
    `quality_risk_score` DECIMAL(18,2) COMMENT 'Score assessing product quality consistency, defect rates, recall history, quality acceptance rate percentage, and adherence to quality management standards such as ISO 9001.',
    `reassessment_schedule` STRING COMMENT 'Frequency at which this vendor must be reassessed based on risk tier. Critical and high-risk vendors typically require quarterly or semi-annual reassessment; low-risk vendors may be assessed annually or biennially.. Valid values are `monthly|quarterly|semi_annually|annually|biannually|event_driven`',
    `risk_appetite_threshold` DECIMAL(18,2) COMMENT 'Enterprise-defined risk appetite threshold score for this vendor category or spend tier. Vendors scoring above this threshold require executive approval or enhanced mitigation before continuing business.',
    `risk_scoring_methodology` STRING COMMENT 'Name or version of the risk scoring framework, algorithm, or methodology applied (e.g., weighted average, Monte Carlo simulation, proprietary enterprise risk model version 2.1).',
    `single_source_dependency_score` DECIMAL(18,2) COMMENT 'Risk score evaluating the business impact if this vendor is the sole or primary source for critical SKUs (Stock Keeping Units), categories, or services. Higher score indicates higher dependency risk.',
    `supply_continuity_risk_score` DECIMAL(18,2) COMMENT 'Score assessing the vendors ability to maintain continuous supply, including manufacturing capacity, inventory buffers, lead time (supplier delivery duration) reliability, disaster recovery plans, and business continuity preparedness.',
    `third_party_assessment_flag` BOOLEAN COMMENT 'Indicates whether a third-party risk assessment firm or auditor was engaged to conduct or validate the assessment. True if external assessment was performed, False if internal only.',
    `third_party_assessor_name` STRING COMMENT 'Name of the external firm or auditor that conducted the third-party risk assessment, if applicable (e.g., Deloitte, EcoVadis, Dun & Bradstreet).',
    CONSTRAINT pk_risk_assessment PRIMARY KEY(`risk_assessment_id`)
) COMMENT 'Vendor risk assessment records evaluating financial stability, geopolitical exposure, single-source dependency, ESG (environmental, social, governance) risk, cybersecurity posture, and supply continuity risk. Tracks assessment date, risk category scores, overall risk tier (low, medium, high, critical), mitigation actions, and reassessment schedule. Supports supply chain resilience planning.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` (
    `vendor_dispute_id` BIGINT COMMENT 'Unique identifier for the vendor dispute record. Primary key.',
    `adjustment_id` BIGINT COMMENT 'Foreign key linking to inventory.adjustment. Business justification: Vendor disputes over inventory adjustments (shrinkage claims, damage responsibility, quantity discrepancies) require direct link to adjustment record for resolution workflow, supporting documentation',
    `associate_id` BIGINT COMMENT 'Identifier of the internal employee or user assigned to review and resolve the vendor dispute.',
    `buying_order_id` BIGINT COMMENT 'Foreign key linking to merchandising.buying_order. Business justification: Vendor disputes frequently reference specific buying orders when invoice discrepancies, quality issues, or delivery failures occur. AP teams trace disputed charges to the original buying order to vali',
    `cost_center_id` BIGINT COMMENT 'FK to finance.cost_center',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Vendor disputes result in credits, debits, or adjustments that must post to specific GL accounts for accounts payable reconciliation, financial statement accuracy, and audit trail documentation in ret',
    `kpi_value_id` BIGINT COMMENT 'Foreign key linking to analytics.kpi_value. Business justification: Dispute resolution time (aging days, SLA compliance) and disputed amounts are vendor relationship KPIs tracked by vendor and period. Links disputes to KPI measurement for AP efficiency dashboards and',
    `purchase_order_id` BIGINT COMMENT 'Foreign key linking to supplychain.purchase_order. Business justification: Disputes (invoice discrepancies, short-ship claims, pricing errors) reference originating PO for root cause analysis and resolution. AP and procurement teams track dispute aging and credit recovery ag',
    `vendor_id` BIGINT COMMENT 'Identifier of the vendor who raised the dispute.',
    `aging_days` STRING COMMENT 'Number of days the dispute has been open since submission date. Used for tracking dispute resolution performance and identifying overdue disputes.',
    `approved_credit_amount` DECIMAL(18,2) COMMENT 'Monetary amount approved for credit or refund to the vendor as a result of the dispute resolution. May be equal to, less than, or zero relative to the disputed amount depending on the resolution decision.',
    `business_unit` STRING COMMENT 'Business unit or division within the retailer organization responsible for managing the dispute (e.g., Grocery, Apparel, Electronics). Used for internal accountability and reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the vendor dispute record was first created in the system.',
    `credit_issue_date` DATE COMMENT 'Date when the approved credit was formally issued to the vendor in the accounts payable system.',
    `credit_memo_number` STRING COMMENT 'Reference number of the credit memo issued to the vendor if the dispute was approved or partially approved. Used for accounts payable reconciliation.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for the disputed amount (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `dispute_category` STRING COMMENT 'High-level business category for grouping and reporting disputes (e.g., Financial, Operational, Quality, Compliance). Used for analytics and trend analysis.',
    `dispute_closure_date` DATE COMMENT 'Date when the dispute was formally closed and no further action is required. Represents the end of the dispute lifecycle.',
    `dispute_number` STRING COMMENT 'Business-facing unique dispute reference number used for tracking and communication with vendors.',
    `dispute_reason_code` STRING COMMENT 'Standardized code representing the specific reason for the dispute as categorized by the business (e.g., CHRG-001 for incorrect chargeback calculation, INV-002 for unauthorized deduction).',
    `dispute_reason_description` STRING COMMENT 'Detailed free-text explanation provided by the vendor describing the basis for the dispute, including specific circumstances and supporting rationale.',
    `dispute_status` STRING COMMENT 'Current lifecycle status of the vendor dispute. Open indicates newly submitted; under review indicates internal investigation in progress; pending documentation indicates awaiting additional evidence from vendor; approved indicates dispute accepted and credit issued; rejected indicates dispute denied; partially approved indicates partial credit granted; closed indicates dispute resolution completed. [ENUM-REF-CANDIDATE: open|under_review|pending_documentation|approved|rejected|partially_approved|closed — 7 candidates stripped; promote to reference product]',
    `dispute_submission_channel` STRING COMMENT 'Channel through which the vendor submitted the dispute (vendor portal, email, EDI message, phone call, physical mail).. Valid values are `vendor_portal|email|edi|phone|mail`',
    `dispute_submission_date` DATE COMMENT 'Date when the vendor formally submitted the dispute to the retailer for review.',
    `dispute_type` STRING COMMENT 'Category of dispute raised by the vendor. Chargeback disputes contest vendor compliance penalties; invoice deduction disputes contest unauthorized deductions; short payment disputes contest partial payments; compliance penalty disputes contest fines for non-compliance; pricing discrepancy disputes contest incorrect pricing applied; quantity discrepancy disputes contest received quantity variances.. Valid values are `chargeback|invoice_deduction|short_payment|compliance_penalty|pricing_discrepancy|quantity_discrepancy`',
    `disputed_amount` DECIMAL(18,2) COMMENT 'Total monetary value being contested by the vendor in the dispute, representing the amount the vendor believes was incorrectly charged, deducted, or withheld.',
    `escalation_date` DATE COMMENT 'Date when the dispute was escalated to a higher authority for resolution.',
    `escalation_flag` BOOLEAN COMMENT 'Boolean indicator of whether the dispute was escalated to senior management or a specialized dispute resolution team due to complexity, high value, or vendor relationship sensitivity.',
    `escalation_reason` STRING COMMENT 'Explanation of why the dispute required escalation (e.g., high dollar value, strategic vendor, complex legal issue, repeated dispute pattern).',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the vendor dispute record was last updated or modified.',
    `modified_by_user` STRING COMMENT 'Username or identifier of the user who last modified the vendor dispute record.',
    `original_transaction_date` DATE COMMENT 'Date when the original disputed transaction occurred (e.g., invoice date, chargeback date, payment date).',
    `original_transaction_reference` STRING COMMENT 'Reference number or identifier of the original business transaction that is the subject of the dispute (e.g., invoice number, purchase order number, chargeback reference, payment reference).',
    `resolution_decision` STRING COMMENT 'Final decision made by the internal reviewer regarding the dispute. Approved indicates full acceptance of vendor claim; rejected indicates denial of vendor claim; partially approved indicates acceptance of a portion of the claim.. Valid values are `approved|rejected|partially_approved`',
    `resolution_notes` STRING COMMENT 'Internal notes and rationale documenting the basis for the resolution decision, including findings from the investigation and justification for approval or rejection.',
    `review_completion_date` DATE COMMENT 'Date when the internal review of the dispute was completed and a resolution decision was made.',
    `review_start_date` DATE COMMENT 'Date when internal review of the dispute officially began.',
    `sla_resolution_due_date` DATE COMMENT 'Target date by which the dispute should be fully resolved according to internal service level agreements or vendor contract terms.',
    `sla_response_due_date` DATE COMMENT 'Target date by which the retailer is contractually or operationally committed to provide an initial response to the vendor regarding the dispute, based on service level agreements.',
    `supporting_documentation_reference` STRING COMMENT 'Reference identifier or file path to supporting documentation provided by the vendor (e.g., proof of delivery, corrected invoices, shipping manifests, quality certificates). May contain multiple document references separated by delimiters.',
    `vendor_contact_email` STRING COMMENT 'Email address of the vendor representative managing the dispute, used for communication regarding dispute status and resolution.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `vendor_contact_name` STRING COMMENT 'Name of the vendor representative who submitted or is managing the dispute on behalf of the vendor organization.',
    `vendor_contact_phone` STRING COMMENT 'Phone number of the vendor representative managing the dispute.',
    CONSTRAINT pk_vendor_dispute PRIMARY KEY(`vendor_dispute_id`)
) COMMENT 'Formal dispute records raised by vendors contesting chargebacks, invoice deductions, short payments, or compliance penalties. Tracks dispute type, disputed amount, dispute reason, supporting documentation references, internal reviewer, resolution decision, approved credit amount, and dispute closure date. Supports vendor relations and accounts payable reconciliation.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`routing_guide` (
    `routing_guide_id` BIGINT COMMENT 'Unique identifier for the routing guide record. Primary key.',
    `associate_id` BIGINT COMMENT 'Foreign key linking to workforce.associate. Business justification: Routing guide creation requires tracking which associate authored the guide for accountability, expertise tracking, and change management. Replaces denormalized created_by_user text field with proper',
    `dc_facility_id` BIGINT COMMENT 'Reference to the distribution center for which this routing guide specifies receiving requirements. Links to inventory node or facility master.',
    `vendor_contract_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor_contract. Business justification: Routing guides define mandatory shipping instructions, labeling requirements, and compliance penalties that are typically contractual obligations. Linking routing_guide to vendor_contract enables trac',
    `vendor_id` BIGINT COMMENT 'Reference to the vendor or vendor group to which this routing guide applies. Links to the vendor master data.',
    `applicability_scope` STRING COMMENT 'Defines the scope of vendors to which this routing guide applies: all vendors, a vendor group, or a specific vendor.. Valid values are `all_vendors|vendor_group|specific_vendor`',
    `appointment_required_flag` BOOLEAN COMMENT 'Indicates whether vendors must schedule a delivery appointment with the DC before shipment.',
    `appointment_scheduling_rule` STRING COMMENT 'Instructions for scheduling delivery appointments including booking windows, contact information, and scheduling system details.',
    `asn_lead_time_hours` STRING COMMENT 'Minimum number of hours before delivery that the ASN must be transmitted to the DC for compliance.',
    `asn_timing_requirement` STRING COMMENT 'Mandatory timing for ASN transmission, specifying the pre-receipt window (e.g., 24-48 hours before delivery) required for DC planning.',
    `carrier_selection_rule` STRING COMMENT 'Mandatory carrier selection instructions specifying which carriers or carrier types must be used for shipments under this guide.',
    `case_pack_quantity` STRING COMMENT 'Required number of units per case for shipments under this routing guide.',
    `chargeback_amount_per_violation` DECIMAL(18,2) COMMENT 'Standard chargeback amount assessed per routing guide violation, used to calculate vendor compliance penalties.',
    `compliance_enforcement_date` DATE COMMENT 'Date from which non-compliance penalties and chargebacks will be enforced for violations of this routing guide.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this routing guide record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for chargeback amounts and penalty fees.. Valid values are `^[A-Z]{3}$`',
    `dock_door_assignment_rule` STRING COMMENT 'Instructions for dock door assignment at the DC, including any vendor-specific or product-category-specific door assignments.',
    `edi_transaction_set` STRING COMMENT 'Required EDI transaction sets for compliance, such as 856 (ASN), 810 (Invoice), and 997 (Functional Acknowledgment).',
    `effective_end_date` DATE COMMENT 'Date on which this routing guide expires or is superseded. Null indicates open-ended validity.',
    `effective_start_date` DATE COMMENT 'Date from which this routing guide becomes effective and enforceable for vendor shipments.',
    `exception_approval_notes` STRING COMMENT 'Detailed notes documenting approved exceptions, including scope, duration, and conditions of the exception.',
    `exception_approval_status` STRING COMMENT 'Status of any exception requests submitted by the vendor for deviations from standard routing guide requirements.. Valid values are `none|requested|approved|denied`',
    `gs1_128_required_flag` BOOLEAN COMMENT 'Indicates whether GS1-128 compliant carton labels are mandatory for shipments under this routing guide.',
    `guide_name` STRING COMMENT 'Descriptive name of the routing guide for internal reference and vendor portal display.',
    `guide_number` STRING COMMENT 'Externally-known business identifier for the routing guide, used in vendor communications and supplier portal.. Valid values are `^RG-[0-9]{6,10}$`',
    `guide_status` STRING COMMENT 'Current lifecycle status of the routing guide indicating its operational state.. Valid values are `draft|published|active|superseded|archived`',
    `guide_version` STRING COMMENT 'Version number of the routing guide, incremented with each revision to track changes over time.. Valid values are `^[0-9]+.[0-9]+$`',
    `labeling_requirement` STRING COMMENT 'Detailed labeling requirements including GS1-128 carton label specifications, RFID/EPC tag mandates, and placement instructions.',
    `last_modified_by_user` STRING COMMENT 'User ID or name of the person who last modified this routing guide record.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp when this routing guide record was last updated.',
    `notes` STRING COMMENT 'Additional notes, instructions, or clarifications related to this routing guide for internal or vendor reference.',
    `packing_standard` STRING COMMENT 'Mandatory packing standards including case pack quantities, pallet build configurations, and stacking requirements.',
    `pallet_configuration` STRING COMMENT 'Specifications for pallet build including dimensions, weight limits, and stacking patterns required for DC receiving.',
    `penalty_schedule` STRING COMMENT 'Detailed penalty schedule defining chargeback amounts for non-compliance with routing guide requirements, organized by violation type.',
    `published_date` DATE COMMENT 'Date on which this routing guide was published to the supplier portal.',
    `published_to_portal_flag` BOOLEAN COMMENT 'Indicates whether this routing guide has been published to the supplier portal for vendor access.',
    `receiving_hours` STRING COMMENT 'DC receiving hours during which deliveries are accepted, specified by day of week and time ranges.',
    `rfid_required_flag` BOOLEAN COMMENT 'Indicates whether RFID or EPC tags are required on cartons or pallets for automated receiving and inventory tracking.',
    `shipping_mode` STRING COMMENT 'Required shipping mode or transportation method for shipments covered by this routing guide.. Valid values are `LTL|FTL|parcel|intermodal|air_freight`',
    `vendor_acknowledgment_date` DATE COMMENT 'Date on which the vendor formally acknowledged the routing guide through the supplier portal.',
    `vendor_acknowledgment_status` STRING COMMENT 'Status indicating whether the vendor has acknowledged receipt and acceptance of this routing guide via the supplier portal.. Valid values are `pending|acknowledged|rejected|expired`',
    CONSTRAINT pk_routing_guide PRIMARY KEY(`routing_guide_id`)
) COMMENT 'Vendor routing and compliance guides specifying mandatory shipping instructions, carrier selection rules, labeling requirements (GS1-128 carton labels, RFID/EPC tags), packing standards (case pack, pallet build), ASN timing requirements (pre-receipt window), appointment scheduling rules, and DC-specific receiving requirements. Defines the penalty schedule for non-compliance that drives chargeback issuance. Tracks guide version, effective date, vendor acknowledgment status, exception approvals, and applicability scope (all vendors, vendor group, or specific vendor). Published to vendors via supplier portal.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`supply_lane` (
    `supply_lane_id` BIGINT COMMENT 'Unique identifier for this vendor-DC supply lane relationship. Primary key.',
    `dc_facility_id` BIGINT COMMENT 'Foreign key linking to the distribution center facility master record',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to the vendor master record',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this supply lane record was first created in the system.',
    `delivery_frequency` STRING COMMENT 'Standard delivery cadence for shipments from this vendor to this DC (e.g., Daily, Weekly, Bi-Weekly, Monthly, On-Demand).',
    `delivery_window_end_time` TIMESTAMP COMMENT 'End time of the delivery window at the DC for this vendor in HH:MM format (e.g., 16:00). DC-specific based on dock scheduling and receiving capacity.',
    `delivery_window_start_time` TIMESTAMP COMMENT 'Start time of the delivery window at the DC for this vendor in HH:MM format (e.g., 08:00). DC-specific based on dock scheduling and receiving capacity.',
    `effective_end_date` DATE COMMENT 'Date when this supply lane agreement expires or was terminated. Null indicates currently active agreement.',
    `effective_start_date` DATE COMMENT 'Date when this supply lane agreement became effective. Supports temporal tracking of vendor-DC relationships and terms changes.',
    `incoterm` STRING COMMENT 'International Commercial Terms defining responsibility for shipping costs, risk transfer, and customs clearance for this vendor-DC lane.',
    `lane_status` STRING COMMENT 'Current operational status of this supply lane (Active, Inactive, Suspended, Pending). Allows temporary suspension without deleting the relationship.',
    `lead_time_days` STRING COMMENT 'DC-specific lead time in days from PO placement to delivery at this specific DC. Varies by vendor-DC combination based on distance, transportation mode, and vendor capacity allocation.',
    `min_order_quantity` DECIMAL(18,2) COMMENT 'Minimum order quantity in units required for shipments on this supply lane. May differ from vendor-level MOQ based on DC-specific economics and transportation constraints.',
    `shipping_mode` STRING COMMENT 'Transportation mode used for shipments on this supply lane (TL=Truckload, LTL=Less Than Truckload, Parcel, Intermodal, DSD=Direct Store Delivery).',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this supply lane record was last modified.',
    CONSTRAINT pk_supply_lane PRIMARY KEY(`supply_lane_id`)
) COMMENT 'This association product represents the supply agreement between a vendor and a distribution center facility. It captures DC-specific shipping terms, lead times, delivery windows, and order constraints that exist only in the context of this vendor-DC relationship. Each record links one vendor to one DC facility with logistics and fulfillment parameters negotiated for that specific supply lane.. Existence Justification: In retail supply chain operations, a single vendor supplies products to multiple distribution centers across different regions, and each DC receives inventory from multiple vendors to ensure supply continuity and competitive sourcing. Each vendor-DC combination has unique logistics parameters including DC-specific lead times, delivery windows aligned with dock schedules, shipping modes based on distance and volume, and minimum order quantities driven by transportation economics.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`vendor_program_enrollment` (
    `vendor_program_enrollment_id` BIGINT COMMENT 'Unique identifier for this vendor-program enrollment record. Primary key.',
    `compliance_program_id` BIGINT COMMENT 'Foreign key to compliance program master record',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to the vendor master record in the supplier domain',
    `vendor_program_compliance_program_id` BIGINT COMMENT 'Foreign key linking to the compliance program master record',
    `compliance_status` STRING COMMENT 'Current compliance status of the vendor within this specific program. Explicitly identified in detection phase relationship data. Values: Compliant, Non_Compliant, Under_Review, Pending_Assessment, Conditionally_Compliant, Exempted, Suspended.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this enrollment record was first created in the system.',
    `enrollment_date` DATE COMMENT 'Date when the vendor was enrolled or onboarded into this specific compliance program. Explicitly identified in detection phase relationship data.',
    `exemption_flag` BOOLEAN COMMENT 'Boolean indicator of whether this vendor has been granted an exemption from certain requirements of this compliance program. Explicitly identified in detection phase relationship data.',
    `exemption_reason` STRING COMMENT 'Business justification or regulatory basis for granting an exemption to this vendor for this program. Null if exemption_flag is false. Explicitly identified in detection phase relationship data.',
    `last_assessment_date` DATE COMMENT 'Date of the most recent compliance assessment or audit conducted for this vendor under this program. Explicitly identified in detection phase relationship data.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next compliance review or assessment of this vendor under this program. Explicitly identified in detection phase relationship data.',
    `program_tier` STRING COMMENT 'Program-specific compliance tier or risk classification assigned to this vendor within this program. Explicitly identified in detection phase relationship data. Values: Tier_1_Critical, Tier_2_High, Tier_3_Standard, Tier_4_Low, Not_Tiered.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this enrollment record was last modified.',
    CONSTRAINT pk_vendor_program_enrollment PRIMARY KEY(`vendor_program_enrollment_id`)
) COMMENT 'This association product represents the enrollment relationship between vendors and compliance programs. It captures the participation of each vendor in each compliance program, including enrollment dates, compliance status, assessment schedules, program-specific tiers, and exemption details. Each record links one vendor to one compliance program with attributes that exist only in the context of this enrollment relationship.. Existence Justification: In retail operations, vendors participate in multiple compliance programs simultaneously (e.g., a food supplier must comply with FDA/FSMA food safety, OSHA workplace safety, and environmental programs), and each compliance program enrolls many vendors across different categories. The business actively manages these enrollments as operational entities, tracking enrollment dates, compliance status, assessment schedules, program-specific tiers, and exemptions for each vendor-program combination.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`vendor_category_sourcing` (
    `vendor_category_sourcing_id` BIGINT COMMENT 'Unique identifier for this vendor-category sourcing relationship. Primary key.',
    `category_id` BIGINT COMMENT 'Foreign key linking to the merchandise category. Identifies which category this vendor is authorized to supply.',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to the vendor master record. Identifies which vendor is authorized to supply this category.',
    `buyer_notes` STRING COMMENT 'Free-text notes from the buyer regarding this vendor-category relationship, including negotiation history, performance observations, strategic considerations, or special terms.',
    `category_spend_allocation_pct` DECIMAL(18,2) COMMENT 'Target percentage of category spend allocated to this vendor. Used in OTB planning and vendor negotiation. Sum across all vendors for a category should approach 100%.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this vendor-category sourcing record was first created in the system. Used for audit and data lineage.',
    `effective_end_date` DATE COMMENT 'Date when this vendor-category sourcing relationship ended or is scheduled to end. Null for active relationships. Used to track vendor exits and category re-sourcing events.',
    `effective_start_date` DATE COMMENT 'Date when this vendor-category sourcing relationship became active. Used to track sourcing history and vendor tenure within a category.',
    `fill_rate_sla_pct` DECIMAL(18,2) COMMENT 'Service level agreement for fill rate (percentage of ordered quantity delivered) specific to this vendor-category relationship. Negotiated based on category criticality and vendor capability.',
    `last_review_date` DATE COMMENT 'Date of the most recent performance review for this vendor-category relationship. Used to track review cadence and ensure regular vendor performance assessment.',
    `lead_time_days` STRING COMMENT 'Lead time in days from PO placement to delivery for this vendor-category combination. May differ from vendor master lead_time_days due to category-specific logistics, production complexity, or shipping arrangements.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next performance review of this vendor-category relationship. Aligns with category review cycles.',
    `preferred_vendor_rank` STRING COMMENT 'Ranking of this vendor within the categorys approved vendor list. Rank 1 indicates primary/preferred vendor. Used by buyers to prioritize sourcing decisions and PO allocation.',
    `sourcing_status` STRING COMMENT 'Current status of the vendor-category sourcing relationship. Active=currently sourcing, Pending=approved but not yet active, Suspended=temporarily halted, Terminated=ended, Under Review=performance review in progress.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this vendor-category sourcing record. Used for change tracking and data freshness monitoring.',
    CONSTRAINT pk_vendor_category_sourcing PRIMARY KEY(`vendor_category_sourcing_id`)
) COMMENT 'This association product represents the sourcing relationship between a vendor and a merchandise category. It captures vendor-category specific sourcing terms, performance targets, and spend allocation strategies managed by buyers and category managers. Each record links one vendor to one category with attributes that exist only in the context of this vendor-category sourcing relationship, including preferred vendor rankings, category-specific lead times, fill rate SLAs, and spend allocation percentages that drive OTB planning and assortment decisions.. Existence Justification: In retail operations, vendors supply multiple merchandise categories (e.g., Procter & Gamble supplies health & beauty, household cleaning, baby care), and each category is sourced from multiple vendors to ensure supply chain resilience, competitive pricing, and assortment diversity. Buyers and category managers actively manage vendor-category sourcing relationships as operational entities, setting preferred vendor rankings, spend allocation targets, category-specific lead times, and fill rate SLAs for each vendor-category pair. This is not an analytical correlation but an operational business process where sourcing strategies, OTB budget allocation, and assortment planning depend on managing these vendor-category relationships as distinct business entities.';

CREATE OR REPLACE TABLE `vibe_retail_v1`.`supplier`.`vendor_training_requirement` (
    `vendor_training_requirement_id` BIGINT COMMENT 'Unique identifier for this vendor training requirement record. Primary key for the association.',
    `training_program_id` BIGINT COMMENT 'Foreign key linking to the compliance training program master record. Identifies which training program is required for this vendor.',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to the vendor master record. Identifies which vendor has this training requirement.',
    `assigned_by` STRING COMMENT 'Name or user ID of the compliance officer or procurement manager who assigned this training requirement to the vendor.',
    `completion_deadline` DATE COMMENT 'Date by which the vendor must complete this training program to maintain compliance. May be driven by contract effective dates, regulatory deadlines, or onboarding schedules.',
    `compliance_status` STRING COMMENT 'Current compliance state for this vendor-program pairing. Compliant: training completed and current. Non-compliant: required but not completed or expired. Pending: in progress. Overdue: past deadline. Waived: requirement waived. Not started: requirement assigned but no activity.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this vendor training requirement record was created in the system.',
    `last_completion_date` DATE COMMENT 'Date when the vendor most recently completed this training program. Used to calculate compliance status and determine when renewal is required based on program completion frequency.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this vendor training requirement record was last modified, including status changes, deadline updates, or waiver approvals.',
    `notes` STRING COMMENT 'Free-text notes about this specific vendor-program requirement, including waiver justifications, special conditions, or compliance exceptions.',
    `required_flag` BOOLEAN COMMENT 'Indicates whether this training program is mandatory for this vendor (true) or optional/recommended (false). Driven by regulatory requirements, contract terms, or risk assessment.',
    `requirement_effective_date` DATE COMMENT 'Date when this training requirement became effective for this vendor. Typically aligned with vendor onboarding date, contract start date, or regulatory mandate effective date.',
    `requirement_source` STRING COMMENT 'Origin of this training requirement. Regulatory mandate: required by law (FSMA, OSHA, PCI-DSS). Contract term: specified in supply agreement. Risk assessment: identified through vendor risk review. Industry standard: best practice. Corporate policy: internal requirement.',
    `waiver_approved` BOOLEAN COMMENT 'Indicates whether a waiver has been approved exempting this vendor from this training requirement. Waivers may be granted based on equivalent certifications, limited scope of work, or risk-based exceptions.',
    `waiver_expiration_date` DATE COMMENT 'Date when the approved waiver expires and the training requirement becomes mandatory again. Null if no waiver approved or waiver is permanent.',
    CONSTRAINT pk_vendor_training_requirement PRIMARY KEY(`vendor_training_requirement_id`)
) COMMENT 'This association product represents the compliance requirement relationship between vendors and training programs. It captures which training programs are required for each vendor based on the goods/services they provide, regulatory mandates, and contractual obligations. Each record links one vendor to one training program with attributes tracking requirement status, completion deadlines, compliance state, and waiver approvals that exist only in the context of this vendor-program pairing.. Existence Justification: In retail operations, vendors must complete multiple compliance training programs based on the goods/services they provide (food safety for food suppliers, data security for IT vendors, ethical sourcing for apparel manufacturers), and each training program applies to many vendors across different categories. The compliance department actively manages these requirements, tracking which programs are mandatory per vendor, monitoring completion status against deadlines, approving waivers for equivalent certifications, and enforcing compliance before contract renewals or new purchase orders.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contact` ADD CONSTRAINT `fk_supplier_vendor_contact_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` ADD CONSTRAINT `fk_supplier_vendor_address_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ADD CONSTRAINT `fk_supplier_vendor_contract_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_routing_guide_id` FOREIGN KEY (`routing_guide_id`) REFERENCES `vibe_retail_v1`.`supplier`.`routing_guide`(`routing_guide_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_vendor_contact_id` FOREIGN KEY (`vendor_contact_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contact`(`vendor_contact_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ADD CONSTRAINT `fk_supplier_vendor_scorecard_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ADD CONSTRAINT `fk_supplier_vendor_scorecard_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` ADD CONSTRAINT `fk_supplier_vendor_certification_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ADD CONSTRAINT `fk_supplier_edi_config_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ADD CONSTRAINT `fk_supplier_edi_config_edi_vendor_id` FOREIGN KEY (`edi_vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ADD CONSTRAINT `fk_supplier_edi_config_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ADD CONSTRAINT `fk_supplier_supplier_edi_transaction_edi_config_id` FOREIGN KEY (`edi_config_id`) REFERENCES `vibe_retail_v1`.`supplier`.`edi_config`(`edi_config_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ADD CONSTRAINT `fk_supplier_supplier_edi_transaction_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ADD CONSTRAINT `fk_supplier_lead_time_agreement_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ADD CONSTRAINT `fk_supplier_lead_time_agreement_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ADD CONSTRAINT `fk_supplier_vmi_config_lead_time_agreement_id` FOREIGN KEY (`lead_time_agreement_id`) REFERENCES `vibe_retail_v1`.`supplier`.`lead_time_agreement`(`lead_time_agreement_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ADD CONSTRAINT `fk_supplier_vmi_config_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ADD CONSTRAINT `fk_supplier_vendor_item_lead_time_agreement_id` FOREIGN KEY (`lead_time_agreement_id`) REFERENCES `vibe_retail_v1`.`supplier`.`lead_time_agreement`(`lead_time_agreement_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ADD CONSTRAINT `fk_supplier_vendor_item_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ADD CONSTRAINT `fk_supplier_onboarding_request_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ADD CONSTRAINT `fk_supplier_risk_assessment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ADD CONSTRAINT `fk_supplier_vendor_dispute_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ADD CONSTRAINT `fk_supplier_routing_guide_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ADD CONSTRAINT `fk_supplier_routing_guide_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`supply_lane` ADD CONSTRAINT `fk_supplier_supply_lane_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_program_enrollment` ADD CONSTRAINT `fk_supplier_vendor_program_enrollment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_category_sourcing` ADD CONSTRAINT `fk_supplier_vendor_category_sourcing_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_training_requirement` ADD CONSTRAINT `fk_supplier_vendor_training_requirement_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`supplier` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_retail_v1`.`supplier` SET TAGS ('dbx_domain' = 'supplier');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` SET TAGS ('dbx_subdomain' = 'vendor_master');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `diversity_certification` SET TAGS ('dbx_business_glossary_term' = 'Diversity Certification Type');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `duns_number` SET TAGS ('dbx_business_glossary_term' = 'Data Universal Numbering System (DUNS) Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `duns_number` SET TAGS ('dbx_value_regex' = '^[0-9]{9}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `edi_capable_flag` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Capable Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `edi_identifier` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Identifier');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `fill_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Fill Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `modified_by_user` SET TAGS ('dbx_business_glossary_term' = 'Modified By User ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `moq_units` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ) Units');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `vendor_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Legal Name');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `on_time_delivery_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `onboarding_date` SET TAGS ('dbx_business_glossary_term' = 'Vendor Onboarding Date');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'ach|wire_transfer|check|eft|credit_card|virtual_card');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Email Address');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Person Name');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Phone Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `quality_acceptance_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Quality Acceptance Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `remittance_email` SET TAGS ('dbx_business_glossary_term' = 'Remittance Email Address');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `remittance_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `risk_rating` SET TAGS ('dbx_business_glossary_term' = 'Vendor Risk Rating');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `risk_rating` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `tax_classification` SET TAGS ('dbx_business_glossary_term' = 'Tax Classification Type');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `tax_classification` SET TAGS ('dbx_value_regex' = 'w9_us_person|w8_foreign_entity|exempt_organization|government_entity');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_business_glossary_term' = 'Tax Identification Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `vendor_status` SET TAGS ('dbx_business_glossary_term' = 'Vendor Lifecycle Status');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `vendor_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|pending_approval|blocked|terminated');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `vendor_type` SET TAGS ('dbx_business_glossary_term' = 'Vendor Type Classification');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `vendor_type` SET TAGS ('dbx_value_regex' = 'national_brand|private_label|dsd_vendor|3pl_partner|service_provider|raw_material_supplier');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor` ALTER COLUMN `vmi_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Vendor Managed Inventory (VMI) Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contact` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contact` SET TAGS ('dbx_subdomain' = 'vendor_master');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contact` ALTER COLUMN `contact_status` SET TAGS ('dbx_value_regex' = 'active|inactive|on_leave|terminated');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contact` ALTER COLUMN `contact_type` SET TAGS ('dbx_value_regex' = 'account_manager|edi_coordinator|compliance_contact|executive_sponsor|logistics_coordinator|quality_assurance');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contact` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contact` ALTER COLUMN `language_preference` SET TAGS ('dbx_value_regex' = 'ENG|SPA|FRA|DEU|CHN|JPN');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contact` ALTER COLUMN `preferred_communication_channel` SET TAGS ('dbx_value_regex' = 'email|phone|mobile|fax|edi|portal');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contact` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State or Province');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` SET TAGS ('dbx_subdomain' = 'vendor_master');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` ALTER COLUMN `address_status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_validation|invalid|temporary');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` ALTER COLUMN `address_type` SET TAGS ('dbx_value_regex' = 'headquarters|remittance|ship_from|returns|billing|warehouse');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` ALTER COLUMN `duns_number` SET TAGS ('dbx_business_glossary_term' = 'Data Universal Numbering System (DUNS) Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` ALTER COLUMN `duns_number` SET TAGS ('dbx_value_regex' = '^[0-9]{9}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` ALTER COLUMN `gln` SET TAGS ('dbx_business_glossary_term' = 'Global Location Number (GLN)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` ALTER COLUMN `gln` SET TAGS ('dbx_value_regex' = '^[0-9]{13}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` ALTER COLUMN `is_dsd_location` SET TAGS ('dbx_business_glossary_term' = 'Is Direct Store Delivery (DSD) Location');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` ALTER COLUMN `is_rtv_address` SET TAGS ('dbx_business_glossary_term' = 'Is Return to Vendor (RTV) Address');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State or Province');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_address` ALTER COLUMN `validation_status` SET TAGS ('dbx_value_regex' = 'validated|unvalidated|failed|partial');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` SET TAGS ('dbx_subdomain' = 'contract_compliance');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ALTER COLUMN `buyer_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Signatory Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ALTER COLUMN `contract_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_value_regex' = 'national_brand|private_label|dsd|master_service_agreement|blanket_order|framework_agreement');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ALTER COLUMN `edi_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Contract Notes');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'ach|wire_transfer|check|edi_payment|credit_card|letter_of_credit');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ALTER COLUMN `return_to_vendor_policy` SET TAGS ('dbx_business_glossary_term' = 'Return to Vendor (RTV) Policy');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ALTER COLUMN `vmi_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Vendor Managed Inventory (VMI) Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` SET TAGS ('dbx_subdomain' = 'performance_risk');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Accounts Payable (AP) Invoice ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `asn_id` SET TAGS ('dbx_business_glossary_term' = 'Advanced Shipping Notice (ASN) ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `buying_order_id` SET TAGS ('dbx_business_glossary_term' = 'Buying Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Center (DC) ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `rma_id` SET TAGS ('dbx_business_glossary_term' = 'Returns Rma Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `routing_guide_id` SET TAGS ('dbx_business_glossary_term' = 'Routing Guide Rule ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Violation Location Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|CAD|EUR|GBP|MXN|JPY');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `dispute_status` SET TAGS ('dbx_value_regex' = 'not_disputed|disputed|under_investigation|resolved_vendor_favor|resolved_retailer_favor');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `notification_method` SET TAGS ('dbx_value_regex' = 'vendor_portal|edi|email|fax|mail');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `penalty_calculation_method` SET TAGS ('dbx_value_regex' = 'flat_fee|percentage_of_order|per_unit|per_carton|per_pallet|tiered');
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ALTER COLUMN `recovery_method` SET TAGS ('dbx_value_regex' = 'ap_deduction|debit_memo|credit_memo|offset_future_payment|written_off');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` SET TAGS ('dbx_subdomain' = 'performance_risk');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `rtv_request_id` SET TAGS ('dbx_business_glossary_term' = 'Rtv Request Identifier');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `buying_order_id` SET TAGS ('dbx_business_glossary_term' = 'Buying Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `environmental_event_id` SET TAGS ('dbx_business_glossary_term' = 'Environmental Event Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `rma_id` SET TAGS ('dbx_business_glossary_term' = 'Originating Returns Rma Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Requestor Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `authorization_date` SET TAGS ('dbx_business_glossary_term' = 'RTV Authorization Date');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `credit_date` SET TAGS ('dbx_business_glossary_term' = 'RTV Credit Date');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `disposition_method` SET TAGS ('dbx_value_regex' = 'credit|replacement|repair|destroy|donate|salvage');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `edi_control_number` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Control Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `edi_transaction_set` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Transaction Set');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `freight_responsibility` SET TAGS ('dbx_value_regex' = 'vendor|retailer|shared|prepaid_and_add|collect');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `inspection_result` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Result');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `inspection_result` SET TAGS ('dbx_value_regex' = 'passed|failed|partial|pending|not_applicable');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Invoice Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `is_recall_related` SET TAGS ('dbx_business_glossary_term' = 'Is Recall Related Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'RTV Notes');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `quality_inspection_required` SET TAGS ('dbx_business_glossary_term' = 'Quality Inspection Required Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `recall_number` SET TAGS ('dbx_business_glossary_term' = 'Product Recall Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `received_date` SET TAGS ('dbx_business_glossary_term' = 'RTV Received Date');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `request_date` SET TAGS ('dbx_business_glossary_term' = 'RTV Request Date');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `rma_number` SET TAGS ('dbx_business_glossary_term' = 'Return Merchandise Authorization (RMA) Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `rma_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `rtv_status` SET TAGS ('dbx_business_glossary_term' = 'Return to Vendor (RTV) Status');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `ship_date` SET TAGS ('dbx_business_glossary_term' = 'RTV Ship Date');
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Shipment Tracking Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` SET TAGS ('dbx_subdomain' = 'performance_risk');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `audit_event_id` SET TAGS ('dbx_business_glossary_term' = 'Audit Event Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `buyer_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Evaluator Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `kpi_value_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Value Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `edi_compliance_rate` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Compliance Rate');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `minimum_order_quantity_compliance_rate` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ) Compliance Rate');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Scorecard Notes');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `on_time_delivery_rate` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery Rate');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `return_to_vendor_amount` SET TAGS ('dbx_business_glossary_term' = 'Return to Vendor (RTV) Amount');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `return_to_vendor_count` SET TAGS ('dbx_business_glossary_term' = 'Return to Vendor (RTV) Count');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `score_trend` SET TAGS ('dbx_value_regex' = 'improving|stable|declining');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `scorecard_number` SET TAGS ('dbx_value_regex' = '^SC-[0-9]{8}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `scorecard_status` SET TAGS ('dbx_value_regex' = 'draft|published|under_review|finalized|archived');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `total_purchase_order_count` SET TAGS ('dbx_business_glossary_term' = 'Total Purchase Order (PO) Count');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `total_purchase_order_value` SET TAGS ('dbx_business_glossary_term' = 'Total Purchase Order (PO) Value');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ALTER COLUMN `vendor_tier` SET TAGS ('dbx_value_regex' = 'preferred|approved|conditional|probation|suspended');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` SET TAGS ('dbx_subdomain' = 'vendor_master');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Category Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` ALTER COLUMN `certification_id` SET TAGS ('dbx_business_glossary_term' = 'Certification Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` ALTER COLUMN `audit_frequency` SET TAGS ('dbx_value_regex' = 'annual|semi_annual|quarterly|biennial|as_needed');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` ALTER COLUMN `compliance_level` SET TAGS ('dbx_value_regex' = 'fully_compliant|conditionally_compliant|non_compliant|pending_verification');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` ALTER COLUMN `critical_non_conformance_count` SET TAGS ('dbx_business_glossary_term' = 'Critical Non-Conformance Count');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` ALTER COLUMN `non_conformance_count` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Count');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` ALTER COLUMN `verification_method` SET TAGS ('dbx_value_regex' = 'on_site_audit|document_review|third_party_verification|self_attestation|remote_audit');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` SET TAGS ('dbx_subdomain' = 'trading_operations');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `edi_config_id` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Configuration ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Trading Partner ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `authentication_method` SET TAGS ('dbx_value_regex' = 'certificate|username_password|ssh_key|oauth|api_key');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `chargeback_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `communication_protocol` SET TAGS ('dbx_value_regex' = 'AS2|SFTP|FTP|FTPS|VAN|API');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `compliance_threshold_error_rate` SET TAGS ('dbx_business_glossary_term' = 'Compliance Threshold Error Rate Percentage');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `edi_version` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Version');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `environment_type` SET TAGS ('dbx_value_regex' = 'production|test|development|staging');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `fa_sla_hours` SET TAGS ('dbx_business_glossary_term' = 'Functional Acknowledgment (FA) Service Level Agreement (SLA) Hours');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `functional_acknowledgment_required` SET TAGS ('dbx_business_glossary_term' = 'Functional Acknowledgment (FA) Required');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `go_live_date` SET TAGS ('dbx_business_glossary_term' = 'Go-Live Date');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `gs_qualifier` SET TAGS ('dbx_business_glossary_term' = 'Application Sender/Receiver Code Qualifier (GS)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `gs_qualifier` SET TAGS ('dbx_value_regex' = '01|02|12|14|ZZ');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `integration_health_status` SET TAGS ('dbx_value_regex' = 'healthy|degraded|critical|offline');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `isa_qualifier` SET TAGS ('dbx_business_glossary_term' = 'Interchange Sender/Receiver ID Qualifier (ISA)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `max_retry_attempts` SET TAGS ('dbx_business_glossary_term' = 'Maximum Retry Attempts');
ALTER TABLE `vibe_retail_v1`.`supplier`.`edi_config` ALTER COLUMN `retry_policy` SET TAGS ('dbx_value_regex' = 'immediate|exponential_backoff|scheduled|manual');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` SET TAGS ('dbx_subdomain' = 'trading_operations');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `supplier_edi_transaction_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Electronic Data Interchange (EDI) Transaction ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `dq_result_id` SET TAGS ('dbx_business_glossary_term' = 'Dq Result Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `edi_config_id` SET TAGS ('dbx_business_glossary_term' = 'Edi Config Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `acknowledgment_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Functional Acknowledgment (FA) Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `business_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Business Document Reference Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `chargeback_eligible` SET TAGS ('dbx_business_glossary_term' = 'Chargeback Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `chargeback_reason_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `direction` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Transaction Direction');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `direction` SET TAGS ('dbx_value_regex' = 'inbound|outbound');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `error_code` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Error Code');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `error_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `error_description` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Error Description');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `file_name` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) File Name');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `file_size_bytes` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) File Size (Bytes)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `functional_acknowledgment_status` SET TAGS ('dbx_business_glossary_term' = 'Functional Acknowledgment (FA) Status');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `functional_acknowledgment_status` SET TAGS ('dbx_value_regex' = 'accepted|accepted_with_errors|rejected|partially_accepted|pending|not_required');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `functional_group_control_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,9}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `interchange_control_number` SET TAGS ('dbx_business_glossary_term' = 'Interchange Control Number (ICN)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `interchange_control_number` SET TAGS ('dbx_value_regex' = '^[0-9]{9}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `max_retry_count` SET TAGS ('dbx_business_glossary_term' = 'Maximum Retry Count');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `processing_status` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Processing Status');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `processing_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Processing Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `receiver_code` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Receiver ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `receiver_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,15}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `receiver_qualifier` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Receiver Qualifier');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `retry_count` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Retry Count');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `segment_count` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Segment Count');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `sender_code` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Sender ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `sender_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,15}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `sender_qualifier` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Sender Qualifier');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `test_indicator` SET TAGS ('dbx_business_glossary_term' = 'Test Indicator Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `transaction_set_control_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,9}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `transaction_set_type` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Transaction Set Type');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ALTER COLUMN `transmission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Transmission Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` SET TAGS ('dbx_subdomain' = 'contract_compliance');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Distribution Center (DC) ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `inventory_node_id` SET TAGS ('dbx_business_glossary_term' = 'Destination Inventory Node Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `agreement_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|terminated');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'standard|expedited|seasonal|promotional|emergency|vmi');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `delivery_frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|biweekly|monthly|on_demand|dsd');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `edi_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `fill_rate_sla_percent` SET TAGS ('dbx_business_glossary_term' = 'Fill Rate Service Level Agreement (SLA) Percent');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `incoterm` SET TAGS ('dbx_business_glossary_term' = 'International Commercial Terms (Incoterm)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `incoterm` SET TAGS ('dbx_value_regex' = 'EXW|FOB|CIF|DDP|DAP|FCA');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Agreement Notes');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `on_time_delivery_sla_percent` SET TAGS ('dbx_business_glossary_term' = 'On-Time Delivery Service Level Agreement (SLA) Percent');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `scope_level` SET TAGS ('dbx_value_regex' = 'vendor|category|subcategory|sku|product_group');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `sku` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `transportation_mode` SET TAGS ('dbx_value_regex' = 'truck|rail|air|ocean|intermodal|parcel');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `vmi_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Vendor Managed Inventory (VMI) Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Created By User');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` SET TAGS ('dbx_subdomain' = 'trading_operations');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `vmi_config_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Managed Inventory (VMI) Configuration ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `kpi_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Definition Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `lead_time_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Agreement Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `reorder_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Reorder Policy Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Product ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `vmi_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Managed Inventory (VMI) Agreement ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `auto_replenishment_enabled` SET TAGS ('dbx_business_glossary_term' = 'Auto Replenishment Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `config_name` SET TAGS ('dbx_business_glossary_term' = 'VMI Configuration Name');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `config_notes` SET TAGS ('dbx_business_glossary_term' = 'Configuration Notes');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `config_status` SET TAGS ('dbx_business_glossary_term' = 'VMI Configuration Status');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `config_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|pending_activation|terminated');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `data_sharing_frequency` SET TAGS ('dbx_value_regex' = 'real_time|hourly|daily|weekly|on_request');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `edi_transaction_set` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Transaction Set');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `max_inventory_threshold` SET TAGS ('dbx_business_glossary_term' = 'Maximum Inventory Threshold');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `min_inventory_threshold` SET TAGS ('dbx_business_glossary_term' = 'Minimum Inventory Threshold');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `ownership_transfer_point` SET TAGS ('dbx_value_regex' = 'at_receipt|at_consumption|at_sale|at_shipment');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `performance_sla_target` SET TAGS ('dbx_business_glossary_term' = 'Performance Service Level Agreement (SLA) Target');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `reorder_point` SET TAGS ('dbx_business_glossary_term' = 'Reorder Point (ROP)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `replenishment_frequency` SET TAGS ('dbx_value_regex' = 'daily|weekly|bi_weekly|monthly|on_demand|continuous');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `replenishment_model` SET TAGS ('dbx_value_regex' = 'min_max|consumption_based|forecast_driven|event_triggered|hybrid');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `reporting_format` SET TAGS ('dbx_value_regex' = 'edi|xml|json|csv|api|portal');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `review_cycle_days` SET TAGS ('dbx_business_glossary_term' = 'Review Cycle (Days)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `threshold_unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Threshold Unit of Measure (UOM)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ALTER COLUMN `vendor_access_level` SET TAGS ('dbx_value_regex' = 'read_only|read_write|full_control|restricted');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` SET TAGS ('dbx_subdomain' = 'vendor_master');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `lead_time_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Time Agreement Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `po_line_id` SET TAGS ('dbx_business_glossary_term' = 'Po Line Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Product ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `dsd_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Direct Store Delivery (DSD) Eligible Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `ean` SET TAGS ('dbx_business_glossary_term' = 'European Article Number (EAN)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `ean` SET TAGS ('dbx_value_regex' = '^[0-9]{13}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `edi_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `gtin` SET TAGS ('dbx_business_glossary_term' = 'Global Trade Item Number (GTIN)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `gtin` SET TAGS ('dbx_value_regex' = '^[0-9]{8,14}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `pallet_hi` SET TAGS ('dbx_business_glossary_term' = 'Pallet HI (High)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `pallet_ti` SET TAGS ('dbx_business_glossary_term' = 'Pallet TI (Tier)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `seasonal_lead_time_adjustment_days` SET TAGS ('dbx_business_glossary_term' = 'Seasonal Lead Time Adjustment (Days)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `upc` SET TAGS ('dbx_business_glossary_term' = 'Universal Product Code (UPC)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `upc` SET TAGS ('dbx_value_regex' = '^[0-9]{12}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `vendor_item_status` SET TAGS ('dbx_value_regex' = 'active|inactive|discontinued|pending|suspended');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ALTER COLUMN `vmi_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Vendor Managed Inventory (VMI) Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` SET TAGS ('dbx_subdomain' = 'contract_compliance');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `buyer_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `kpi_value_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Value Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `promo_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Promotion ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `promo_offer_id` SET TAGS ('dbx_business_glossary_term' = 'Promo Offer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `accrual_method` SET TAGS ('dbx_value_regex' = 'invoice_based|sales_based|volume_based|time_based|event_based');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `allowance_number` SET TAGS ('dbx_business_glossary_term' = 'Allowance Agreement Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `allowance_status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|expired|settled|cancelled');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `allowance_type` SET TAGS ('dbx_value_regex' = 'off_invoice|bill_back|scan_based|slotting_fee|co_op_advertising|volume_rebate');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending_approval|approved|rejected');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'credit_memo|check|eft|offset_invoice|promotional_credit');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `settlement_status` SET TAGS ('dbx_value_regex' = 'pending|partially_settled|fully_settled|disputed|written_off');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ALTER COLUMN `sku_list` SET TAGS ('dbx_business_glossary_term' = 'Stock Keeping Unit (SKU) List');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` SET TAGS ('dbx_subdomain' = 'trading_operations');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Modified By Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `third_party_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Third Party Assessment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `duns_number` SET TAGS ('dbx_business_glossary_term' = 'Data Universal Numbering System (DUNS) Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `duns_number` SET TAGS ('dbx_value_regex' = '^[0-9]{9}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `edi_capable_flag` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Capable Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `edi_setup_completed_flag` SET TAGS ('dbx_business_glossary_term' = 'Electronic Data Interchange (EDI) Setup Completed Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `headquarters_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Headquarters Address Line 1');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `headquarters_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `headquarters_state_province` SET TAGS ('dbx_business_glossary_term' = 'Headquarters State or Province');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `moq_units` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ) Units');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Notes');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Email Address');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Phone Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `request_number` SET TAGS ('dbx_business_glossary_term' = 'Onboarding Request Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `request_number` SET TAGS ('dbx_value_regex' = '^ONB-[0-9]{8}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `risk_tier` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `tax_identifier` SET TAGS ('dbx_business_glossary_term' = 'Tax Identification Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `vendor_dba_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Doing Business As (DBA) Name');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `vmi_enabled_flag` SET TAGS ('dbx_business_glossary_term' = 'Vendor Managed Inventory (VMI) Enabled Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ALTER COLUMN `w9_form_received_flag` SET TAGS ('dbx_business_glossary_term' = 'W-9 Form Received Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` SET TAGS ('dbx_subdomain' = 'performance_risk');
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Assessor Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ALTER COLUMN `buyer_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ALTER COLUMN `kpi_value_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Value Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ALTER COLUMN `risk_register_id` SET TAGS ('dbx_business_glossary_term' = 'Risk Register Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ALTER COLUMN `assessment_number` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ALTER COLUMN `assessment_number` SET TAGS ('dbx_value_regex' = '^RA-[0-9]{8}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ALTER COLUMN `assessment_status` SET TAGS ('dbx_value_regex' = 'draft|in_progress|under_review|approved|rejected|expired');
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ALTER COLUMN `assessment_type` SET TAGS ('dbx_value_regex' = 'initial|periodic|triggered|renewal|ad_hoc|incident_driven');
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ALTER COLUMN `esg_risk_score` SET TAGS ('dbx_business_glossary_term' = 'Environmental Social Governance (ESG) Risk Score');
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ALTER COLUMN `mitigation_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|on_hold|cancelled');
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ALTER COLUMN `overall_risk_tier` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ALTER COLUMN `reassessment_schedule` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annually|annually|biannually|event_driven');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` SET TAGS ('dbx_subdomain' = 'performance_risk');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ALTER COLUMN `adjustment_id` SET TAGS ('dbx_business_glossary_term' = 'Adjustment Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Reviewer ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ALTER COLUMN `buying_order_id` SET TAGS ('dbx_business_glossary_term' = 'Buying Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ALTER COLUMN `kpi_value_id` SET TAGS ('dbx_business_glossary_term' = 'Kpi Value Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ALTER COLUMN `purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Purchase Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ALTER COLUMN `dispute_submission_channel` SET TAGS ('dbx_value_regex' = 'vendor_portal|email|edi|phone|mail');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ALTER COLUMN `dispute_type` SET TAGS ('dbx_value_regex' = 'chargeback|invoice_deduction|short_payment|compliance_penalty|pricing_discrepancy|quantity_discrepancy');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ALTER COLUMN `resolution_decision` SET TAGS ('dbx_value_regex' = 'approved|rejected|partially_approved');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ALTER COLUMN `sla_resolution_due_date` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Resolution Due Date');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ALTER COLUMN `sla_response_due_date` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Response Due Date');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ALTER COLUMN `vendor_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` SET TAGS ('dbx_subdomain' = 'contract_compliance');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Created By Associate Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Distribution Center (DC) ID');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `vendor_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `applicability_scope` SET TAGS ('dbx_value_regex' = 'all_vendors|vendor_group|specific_vendor');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `asn_lead_time_hours` SET TAGS ('dbx_business_glossary_term' = 'ASN (Advanced Shipping Notice) Lead Time Hours');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `asn_timing_requirement` SET TAGS ('dbx_business_glossary_term' = 'ASN (Advanced Shipping Notice) Timing Requirement');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `edi_transaction_set` SET TAGS ('dbx_business_glossary_term' = 'EDI (Electronic Data Interchange) Transaction Set');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `exception_approval_status` SET TAGS ('dbx_value_regex' = 'none|requested|approved|denied');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `gs1_128_required_flag` SET TAGS ('dbx_business_glossary_term' = 'GS1-128 Required Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `guide_name` SET TAGS ('dbx_business_glossary_term' = 'Routing Guide Name');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `guide_number` SET TAGS ('dbx_business_glossary_term' = 'Routing Guide Number');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `guide_number` SET TAGS ('dbx_value_regex' = '^RG-[0-9]{6,10}$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `guide_status` SET TAGS ('dbx_business_glossary_term' = 'Routing Guide Status');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `guide_status` SET TAGS ('dbx_value_regex' = 'draft|published|active|superseded|archived');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `guide_version` SET TAGS ('dbx_business_glossary_term' = 'Routing Guide Version');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `guide_version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `rfid_required_flag` SET TAGS ('dbx_business_glossary_term' = 'RFID (Radio Frequency Identification) Required Flag');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `shipping_mode` SET TAGS ('dbx_value_regex' = 'LTL|FTL|parcel|intermodal|air_freight');
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ALTER COLUMN `vendor_acknowledgment_status` SET TAGS ('dbx_value_regex' = 'pending|acknowledged|rejected|expired');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supply_lane` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supply_lane` SET TAGS ('dbx_subdomain' = 'trading_operations');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supply_lane` SET TAGS ('dbx_association_edges' = 'supplier.vendor,supplychain.dc_facility');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supply_lane` ALTER COLUMN `supply_lane_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Lane Identifier');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supply_lane` ALTER COLUMN `dc_facility_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Lane - Dc Facility Id');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supply_lane` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Lane - Vendor Id');
ALTER TABLE `vibe_retail_v1`.`supplier`.`supply_lane` ALTER COLUMN `min_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_program_enrollment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_program_enrollment` SET TAGS ('dbx_subdomain' = 'trading_operations');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_program_enrollment` SET TAGS ('dbx_association_edges' = 'supplier.vendor,compliance.compliance_program');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_program_enrollment` ALTER COLUMN `vendor_program_enrollment_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Program Enrollment Identifier');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_program_enrollment` ALTER COLUMN `compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Program Identifier');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_program_enrollment` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Program Enrollment - Vendor Id');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_program_enrollment` ALTER COLUMN `vendor_program_compliance_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Program Enrollment - Compliance Program Id');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_category_sourcing` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_category_sourcing` SET TAGS ('dbx_subdomain' = 'contract_compliance');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_category_sourcing` SET TAGS ('dbx_association_edges' = 'supplier.vendor,merchandising.category');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_category_sourcing` ALTER COLUMN `category_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Category Sourcing - Category Id');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_category_sourcing` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Category Sourcing - Vendor Id');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_category_sourcing` ALTER COLUMN `category_spend_allocation_pct` SET TAGS ('dbx_business_glossary_term' = 'Category Spend Allocation Percentage');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_category_sourcing` ALTER COLUMN `fill_rate_sla_pct` SET TAGS ('dbx_business_glossary_term' = 'Fill Rate SLA Percentage');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_category_sourcing` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Category-Specific Lead Time Days');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_training_requirement` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_training_requirement` SET TAGS ('dbx_subdomain' = 'trading_operations');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_training_requirement` SET TAGS ('dbx_association_edges' = 'supplier.vendor,compliance.training_program');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_training_requirement` ALTER COLUMN `training_program_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Training Requirement - Training Program Id');
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_training_requirement` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Training Requirement - Vendor Id');
